Return-Path: <linux-kernel-owner+w=401wt.eu-S1752980AbYJ0P24@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752980AbYJ0P24 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2008 11:28:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751539AbYJ0P2r
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Oct 2008 11:28:47 -0400
Received: from ppsw-7.csi.cam.ac.uk ([131.111.8.137]:52425 "EHLO
	ppsw-7.csi.cam.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751236AbYJ0P2q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2008 11:28:46 -0400
X-Cam-AntiVirus: no malware found
X-Cam-SpamDetails: not scanned
X-Cam-ScannerInfo: http://www.cam.ac.uk/cs/email/scanner/
Message-ID: <4905DE3D.1010101@gmail.com>
Date: Mon, 27 Oct 2008 15:29:01 +0000
From: Jonathan Cameron <Jonathan.Cameron@gmail.com>
User-Agent: Thunderbird 2.0.0.16 (X11/20080801)
MIME-Version: 1.0
To: Jonathan Cameron <jic23@cam.ac.uk>
CC: LKML <linux-kernel@vger.kernel.org>, eric miao <eric.y.miao@gmail.com>,
       Liam Girdwood <lg@opensource.wolfsonmicro.com>
Subject: [PATCH] da903x regulator bug fix
References: <4901EE0F.5000508@cam.ac.uk>
In-Reply-To: <4901EE0F.5000508@cam.ac.uk>
Content-Type: text/plain; charset=ISO-8859-1
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
This is quickest and simplest way to fix this bug. There may be better
ways of doing it, but they all require considerably more substantial
changes to the driver.

diff --git a/drivers/regulator/da903x.c b/drivers/regulator/da903x.c
index 3688e33..f928aa1 100644
--- a/drivers/regulator/da903x.c
+++ b/drivers/regulator/da903x.c
@@ -93,7 +93,7 @@ static int da903x_set_ldo_voltage(struct regulator_dev
*rdev,
                   int min_uV, int max_uV)
 {
     struct da903x_regulator_info *info = rdev_get_drvdata(rdev);
-    struct device *da9034_dev = rdev_get_dev(rdev)->parent;
+    struct device *da9034_dev = rdev_get_dev(rdev)->parent->parent;
     uint8_t val, mask;
 
     if (check_range(info, min_uV, max_uV)) {
@@ -111,7 +111,7 @@ static int da903x_set_ldo_voltage(struct
regulator_dev *rdev,
 static int da903x_get_voltage(struct regulator_dev *rdev)
 {
     struct da903x_regulator_info *info = rdev_get_drvdata(rdev);
-    struct device *da9034_dev = rdev_get_dev(rdev)->parent;
+    struct device *da9034_dev = rdev_get_dev(rdev)->parent->parent;
     uint8_t val, mask;
     int ret;
 
@@ -128,7 +128,7 @@ static int da903x_get_voltage(struct regulator_dev
*rdev)
 static int da903x_enable(struct regulator_dev *rdev)
 {
     struct da903x_regulator_info *info = rdev_get_drvdata(rdev);
-    struct device *da9034_dev = rdev_get_dev(rdev)->parent;
+    struct device *da9034_dev = rdev_get_dev(rdev)->parent->parent;
 
     return da903x_set_bits(da9034_dev, info->enable_reg,
                     1 << info->enable_bit);
@@ -137,7 +137,7 @@ static int da903x_enable(struct regulator_dev *rdev)
 static int da903x_disable(struct regulator_dev *rdev)
 {
     struct da903x_regulator_info *info = rdev_get_drvdata(rdev);
-    struct device *da9034_dev = rdev_get_dev(rdev)->parent;
+    struct device *da9034_dev = rdev_get_dev(rdev)->parent->parent;
 
     return da903x_clr_bits(da9034_dev, info->enable_reg,
                     1 << info->enable_bit);
@@ -146,7 +146,7 @@ static int da903x_disable(struct regulator_dev *rdev)
 static int da903x_is_enabled(struct regulator_dev *rdev)
 {
     struct da903x_regulator_info *info = rdev_get_drvdata(rdev);
-    struct device *da9034_dev = rdev_get_dev(rdev)->parent;
+    struct device *da9034_dev = rdev_get_dev(rdev)->parent->parent;
     uint8_t reg_val;
     int ret;
 
@@ -238,7 +238,7 @@ static int da9034_set_dvc_voltage(struct
regulator_dev *rdev,
                   int min_uV, int max_uV)
 {
     struct da903x_regulator_info *info = rdev_get_drvdata(rdev);
-    struct device *da9034_dev = rdev_get_dev(rdev)->parent;
+    struct device *da9034_dev = rdev_get_dev(rdev)->parent->parent;
     uint8_t val, mask;
     int ret;
 
@@ -264,7 +264,7 @@ static int da9034_set_ldo12_voltage(struct
regulator_dev *rdev,
                     int min_uV, int max_uV)
 {
     struct da903x_regulator_info *info = rdev_get_drvdata(rdev);
-    struct device *da9034_dev = rdev_get_dev(rdev)->parent;
+    struct device *da9034_dev = rdev_get_dev(rdev)->parent->parent;
     uint8_t val, mask;
 
     if (check_range(info, min_uV, max_uV)) {
@@ -283,7 +283,7 @@ static int da9034_set_ldo12_voltage(struct
regulator_dev *rdev,
 static int da9034_get_ldo12_voltage(struct regulator_dev *rdev)
 {
     struct da903x_regulator_info *info = rdev_get_drvdata(rdev);
-    struct device *da9034_dev = rdev_get_dev(rdev)->parent;
+    struct device *da9034_dev = rdev_get_dev(rdev)->parent->parent;
     uint8_t val, mask;
     int ret;
 
@@ -466,7 +466,7 @@ static int __devinit da903x_regulator_probe(struct
platform_device *pdev)
     if (ri->desc.id == DA9030_ID_LDO1 || ri->desc.id == DA9030_ID_LDO15)
         ri->desc.ops = &da9030_regulator_ldo1_15_ops;
 
-    rdev = regulator_register(&ri->desc, pdev->dev.parent, ri);
+    rdev = regulator_register(&ri->desc, &pdev->dev, ri);
     if (IS_ERR(rdev)) {
         dev_err(&pdev->dev, "failed to register regulator %s\n",
                 ri->desc.name);




