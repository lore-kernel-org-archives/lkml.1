Return-Path: <linux-kernel-owner+w=401wt.eu-S1754006AbYJ1LDj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754006AbYJ1LDj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2008 07:03:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752771AbYJ1LDb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Oct 2008 07:03:31 -0400
Received: from ppsw-0.csi.cam.ac.uk ([131.111.8.130]:60123 "EHLO
	ppsw-0.csi.cam.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752719AbYJ1LDa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2008 07:03:30 -0400
X-Cam-AntiVirus: no malware found
X-Cam-SpamDetails: not scanned
X-Cam-ScannerInfo: http://www.cam.ac.uk/cs/email/scanner/
Message-ID: <4906F194.30901@cam.ac.uk>
Date: Tue, 28 Oct 2008 11:03:48 +0000
From: Jonathan Cameron <jic23@cam.ac.uk>
User-Agent: Thunderbird 2.0.0.16 (X11/20080801)
MIME-Version: 1.0
To: Eric Miao <eric.y.miao@gmail.com>
CC: Jonathan Cameron <Jonathan.Cameron@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>, Liam Girdwood <lrg@kernel.org>
Subject: Re: [PATCH] da903x regulator bug fix
References: <4901EE0F.5000508@cam.ac.uk> <4905DE3D.1010101@gmail.com>	 <f17812d70810271801t47830712h431df82baee11654@mail.gmail.com> <f17812d70810271802v75b08712l4ab243802f59ecce@mail.gmail.com>
In-Reply-To: <f17812d70810271802v75b08712l4ab243802f59ecce@mail.gmail.com>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Changes the device registration part of the probe function to supply the
regulator device rather than its parent (the mfd device) as this caused
problems when the regulator core attempted to find constraints associated
with the regulators.

Signed-of-by: Jonathan Cameron <jic23@cam.ac.uk>

--
Version 2 applying Eric Miao's suggestion about using an inline function.
Change made in couple of additional places I'd missed the first time.


diff --git a/drivers/regulator/da903x.c b/drivers/regulator/da903x.c
index 3688e33..773b29c 100644
--- a/drivers/regulator/da903x.c
+++ b/drivers/regulator/da903x.c
@@ -79,6 +79,11 @@ struct da903x_regulator_info {
 	int	enable_bit;
 };
 
+static inline struct device *to_da903x_dev(struct regulator_dev *rdev)
+{
+	return rdev_get_dev(rdev)->parent->parent;
+}
+
 static inline int check_range(struct da903x_regulator_info *info,
 				int min_uV, int max_uV)
 {
@@ -93,7 +98,7 @@ static int da903x_set_ldo_voltage(struct regulator_dev *rdev,
 				  int min_uV, int max_uV)
 {
 	struct da903x_regulator_info *info = rdev_get_drvdata(rdev);
-	struct device *da9034_dev = rdev_get_dev(rdev)->parent;
+	struct device *da9034_dev = to_da903x_dev(rdev);
 	uint8_t val, mask;
 
 	if (check_range(info, min_uV, max_uV)) {
@@ -111,7 +116,7 @@ static int da903x_set_ldo_voltage(struct regulator_dev *rdev,
 static int da903x_get_voltage(struct regulator_dev *rdev)
 {
 	struct da903x_regulator_info *info = rdev_get_drvdata(rdev);
-	struct device *da9034_dev = rdev_get_dev(rdev)->parent;
+	struct device *da9034_dev = to_da903x_dev(rdev);
 	uint8_t val, mask;
 	int ret;
 
@@ -128,7 +133,7 @@ static int da903x_get_voltage(struct regulator_dev *rdev)
 static int da903x_enable(struct regulator_dev *rdev)
 {
 	struct da903x_regulator_info *info = rdev_get_drvdata(rdev);
-	struct device *da9034_dev = rdev_get_dev(rdev)->parent;
+	struct device *da9034_dev = to_da903x_dev(rdev);
 
 	return da903x_set_bits(da9034_dev, info->enable_reg,
 					1 << info->enable_bit);
@@ -137,7 +142,7 @@ static int da903x_enable(struct regulator_dev *rdev)
 static int da903x_disable(struct regulator_dev *rdev)
 {
 	struct da903x_regulator_info *info = rdev_get_drvdata(rdev);
-	struct device *da9034_dev = rdev_get_dev(rdev)->parent;
+	struct device *da9034_dev = to_da903x_dev(rdev);
 
 	return da903x_clr_bits(da9034_dev, info->enable_reg,
 					1 << info->enable_bit);
@@ -146,7 +151,7 @@ static int da903x_disable(struct regulator_dev *rdev)
 static int da903x_is_enabled(struct regulator_dev *rdev)
 {
 	struct da903x_regulator_info *info = rdev_get_drvdata(rdev);
-	struct device *da9034_dev = rdev_get_dev(rdev)->parent;
+	struct device *da9034_dev = to_da903x_dev(rdev);
 	uint8_t reg_val;
 	int ret;
 
@@ -162,7 +167,7 @@ static int da9030_set_ldo1_15_voltage(struct regulator_dev *rdev,
 				       int min_uV, int max_uV)
 {
 	struct da903x_regulator_info *info = rdev_get_drvdata(rdev);
-	struct device *da903x_dev = rdev_get_dev(rdev)->parent;
+	struct device *da903x_dev = to_da903x_dev(rdev);
 	uint8_t val, mask;
 	int ret;
 
@@ -189,7 +194,7 @@ static int da9030_set_ldo14_voltage(struct regulator_dev *rdev,
 				  int min_uV, int max_uV)
 {
 	struct da903x_regulator_info *info = rdev_get_drvdata(rdev);
-	struct device *da903x_dev = rdev_get_dev(rdev)->parent;
+	struct device *da903x_dev = to_da903x_dev(rdev);
 	uint8_t val, mask;
 	int thresh;
 
@@ -215,7 +220,7 @@ static int da9030_set_ldo14_voltage(struct regulator_dev *rdev,
 static int da9030_get_ldo14_voltage(struct regulator_dev *rdev)
 {
 	struct da903x_regulator_info *info = rdev_get_drvdata(rdev);
-	struct device *da903x_dev = rdev_get_dev(rdev)->parent;
+	struct device *da903x_dev = to_da903x_dev(rdev);
 	uint8_t val, mask;
 	int ret;
 
@@ -238,7 +243,7 @@ static int da9034_set_dvc_voltage(struct regulator_dev *rdev,
 				  int min_uV, int max_uV)
 {
 	struct da903x_regulator_info *info = rdev_get_drvdata(rdev);
-	struct device *da9034_dev = rdev_get_dev(rdev)->parent;
+	struct device *da9034_dev = to_da903x_dev(rdev);
 	uint8_t val, mask;
 	int ret;
 
@@ -264,7 +269,7 @@ static int da9034_set_ldo12_voltage(struct regulator_dev *rdev,
 				    int min_uV, int max_uV)
 {
 	struct da903x_regulator_info *info = rdev_get_drvdata(rdev);
-	struct device *da9034_dev = rdev_get_dev(rdev)->parent;
+	struct device *da9034_dev = to_da903x_dev(rdev);
 	uint8_t val, mask;
 
 	if (check_range(info, min_uV, max_uV)) {
@@ -283,7 +288,7 @@ static int da9034_set_ldo12_voltage(struct regulator_dev *rdev,
 static int da9034_get_ldo12_voltage(struct regulator_dev *rdev)
 {
 	struct da903x_regulator_info *info = rdev_get_drvdata(rdev);
-	struct device *da9034_dev = rdev_get_dev(rdev)->parent;
+	struct device *da9034_dev = to_da903x_dev(rdev);
 	uint8_t val, mask;
 	int ret;
 
@@ -466,7 +471,7 @@ static int __devinit da903x_regulator_probe(struct platform_device *pdev)
 	if (ri->desc.id == DA9030_ID_LDO1 || ri->desc.id == DA9030_ID_LDO15)
 		ri->desc.ops = &da9030_regulator_ldo1_15_ops;
 
-	rdev = regulator_register(&ri->desc, pdev->dev.parent, ri);
+	rdev = regulator_register(&ri->desc, &pdev->dev, ri);
 	if (IS_ERR(rdev)) {
 		dev_err(&pdev->dev, "failed to register regulator %s\n",
 				ri->desc.name);


