close all;
clear all;
clc;
disp('Preparing training data');
folderCat = './Training1/Cat/';
folderDog = './Training1/Dog/';
filesCat = [dir(fullfile(folderCat, '*.jpg')); dir(fullfile(folderCat, '*.jfif')); dir(fullfile(folderCat, '*.png'));]
filesDog = [dir(fullfile(folderDog, '*.jpg')); dir(fullfile(folderDog, '*.jfif')); dir(fullfile(folderDog, '*.png'));]
feats = zeros(length(filesCat) + length(filesDog), 3072);
labels = zeros(length(filesCat) + length(filesDog),1);
for i = 1:length(filesCat)
disp(i);
filename = filesCat(i,1).name;
img = imread([folderCat filename]);
img = imresize(img,[32,32]);
feat = tinyimg(img);
feats(i,:) = feat;
labels(i) = 0;
end
for i = 1:length(filesDog)
disp(i);
filename = filesDog(i,1).name;
img = imread([folderDog filename]);
img = imresize(img,[32,32]);
feat = tinyimg(img);
feats(i + length(filesCat),:) = feat;
labels(i + length(filesCat)) = 1;
end
disp('Preparing testing data');
folderCat = './Testing1/Cat/';
folderDog = './Testing1/Dog/';
filesCat = dir(fullfile(folderCat, '*.jpg'));
filesDog = dir(fullfile(folderDog, '*.jpg'));
featsTest = zeros(length(filesCat) + length(filesDog), 3072);
groundtruthLabel = zeros(length(filesCat) + length(filesDog), 1);
predictedLabel = zeros(length(filesCat) + length(filesDog), 1);
for i = 1:length(filesCat)
disp(i);
filename = filesCat(i,1).name;
img = imread([folderCat filename]);
img = imresize(img,[32,32]);
feat = tinyimg(img);
featsTest(i,:) = feat;
groundtruthLabel(i) = 0;
end
for i = 1:length(filesDog)
disp(i);
filename = filesDog(i,1).name;
img = imread([folderDog filename]);
img = imresize(img,[32,32]);
feat = tinyimg(img);
featsTest(i + length(filesCat),:) = feat;
groundtruthLabel(i + length(filesCat)) = 1;
end

net = feedforwardnet(5);
net = train(net,feats',labels');
disp('Performing testing');
predictedLabel = net(featsTest');
accurateClassification = 0;
for i = 1:size(featsTest,1)
if predictedLabel(i)>= 0.5
predictedLabel(i) = 1;
else
predictedLabel(i) = 0;
end
if(predictedLabel(i) == groundtruthLabel(i))
accurateClassification = accurateClassification + 1;
end
end
accuracy = accurateClassification/length(groundtruthLabel);
disp(['The accuracy:' num2str(accuracy * 100) '%']);

