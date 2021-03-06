library(caret)
library(e1071)
library(dplyr)


# get data
source("data-samplelabel.R")



#Call original svmBag functions
#str(svmBag)
#svmBag$fit
#svmBag$pred
#svmBag$aggregate

#Define custom bagging svm function using svm package of our choosing {fit, pred, aggregate}
bsvm.fit <- function (x, y, ...)
     {
#	x <- dat[,-1]
#	y <- dat[, 1]
         loadNamespace("e1071")
         out <- e1071::svm(as.matrix(x), y, kernel = "radial", scale = F, type = "one-classification")
         out
     }

bsvm.pred <- svmBag$pred

bsvm.pred <- function(object, x) {
	predict(object, x)
}

bsvm.aggregate <- svmBag$aggregate

#Define "number" to be number of folds desired
#Define selectionFunction to be "best", "oneSE", or "tolerance"
set.seed(300)
#ctrl <- trainControl(method = "boot", number = 2, selectionFunction = "best")

#Creating bagging control object
bagctrl <- bagControl(fit = bsvm.fit,
                      predict = bsvm.pred,
                      aggregate = bsvm.aggregate)

bagctrl <- bagControl(fit = svmBag.fit,
                      predict = svmBag.pred,
                      aggregate = svmBag.aggregate)

#Fix data formatting
dat1$y <- as.factor(dat1$y)


#Create a sample subset for faster testing runtimes
set.seed(300)
dat1_subset10 <- sample_n(dat1, 1000)
rownames(dat1_subset10) <- NULL
head(dat1_subset10)


#Evaluate bagged function
set.seed(300)
svmbag <- train(y ~ ., data = dat1_subset10, method = "bag", bagControl = bagctrl)

#Warnings 11, 22, and 23 mean...?
warnings()

svmbag
