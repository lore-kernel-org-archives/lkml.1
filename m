Return-Path: <linux-kernel-owner+w=401wt.eu-S1760760AbZASNj3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760760AbZASNj3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2009 08:39:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756784AbZASNhS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Jan 2009 08:37:18 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:34180 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756261AbZASNhJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2009 08:37:09 -0500
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Liam Girdwood <lrg@slimlogic.co.uk>
Cc: linux-kernel@vger.kernel.org,
       Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH 1/5] regulator: Pass regulator init data as explict argument when registering
Date: Mon, 19 Jan 2009 13:37:02 +0000
Message-Id: <1232372226-23319-1-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.5.6.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rather than having the regulator init data read from the platform_data
member of the struct device that is registered for the regulator make
the init data an explict argument passed in when registering. This
allows drivers to use the platform data for their own purposes if they
wish.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 drivers/regulator/bq24022.c            |    2 +-
 drivers/regulator/core.c               |    5 +++--
 drivers/regulator/da903x.c             |    3 ++-
 drivers/regulator/pcf50633-regulator.c |    3 ++-
 drivers/regulator/wm8350-regulator.c   |    2 +-
 drivers/regulator/wm8400-regulator.c   |    2 +-
 include/linux/regulator/driver.h       |    3 ++-
 7 files changed, 12 insertions(+), 8 deletions(-)

diff --git a/drivers/regulator/bq24022.c b/drivers/regulator/bq24022.c
index 366565a..50129b4 100644
--- a/drivers/regulator/bq24022.c
+++ b/drivers/regulator/bq24022.c
@@ -105,7 +105,7 @@ static int __init bq24022_probe(struct platform_device *pdev)
 	ret = gpio_direction_output(pdata->gpio_iset2, 0);
 	ret = gpio_direction_output(pdata->gpio_nce, 1);
 
-	bq24022 = regulator_register(&bq24022_desc, &pdev->dev, pdata);
+	bq24022 = regulator_register(&bq24022_desc, &pdev->dev, NULL, pdata);
 	if (IS_ERR(bq24022)) {
 		dev_dbg(&pdev->dev, "couldn't register regulator\n");
 		ret = PTR_ERR(bq24022);
diff --git a/drivers/regulator/core.c b/drivers/regulator/core.c
index 0ff95c3..314997b 100644
--- a/drivers/regulator/core.c
+++ b/drivers/regulator/core.c
@@ -1874,17 +1874,18 @@ static int add_regulator_attributes(struct regulator_dev *rdev)
  * regulator_register - register regulator
  * @regulator_desc: regulator to register
  * @dev: struct device for the regulator
+ * @init_data: platform provided init data, passed through by driver
  * @driver_data: private regulator data
  *
  * Called by regulator drivers to register a regulator.
  * Returns 0 on success.
  */
 struct regulator_dev *regulator_register(struct regulator_desc *regulator_desc,
-	struct device *dev, void *driver_data)
+	struct device *dev, struct regulator_init_data *init_data,
+	void *driver_data)
 {
 	static atomic_t regulator_no = ATOMIC_INIT(0);
 	struct regulator_dev *rdev;
-	struct regulator_init_data *init_data = dev->platform_data;
 	int ret, i;
 
 	if (regulator_desc == NULL)
diff --git a/drivers/regulator/da903x.c b/drivers/regulator/da903x.c
index fe77730..72b1549 100644
--- a/drivers/regulator/da903x.c
+++ b/drivers/regulator/da903x.c
@@ -471,7 +471,8 @@ static int __devinit da903x_regulator_probe(struct platform_device *pdev)
 	if (ri->desc.id == DA9030_ID_LDO1 || ri->desc.id == DA9030_ID_LDO15)
 		ri->desc.ops = &da9030_regulator_ldo1_15_ops;
 
-	rdev = regulator_register(&ri->desc, &pdev->dev, ri);
+	rdev = regulator_register(&ri->desc, &pdev->dev,
+				  pdev->dev.platform_data, ri);
 	if (IS_ERR(rdev)) {
 		dev_err(&pdev->dev, "failed to register regulator %s\n",
 				ri->desc.name);
diff --git a/drivers/regulator/pcf50633-regulator.c b/drivers/regulator/pcf50633-regulator.c
index 4cc85ec..cd761d8 100644
--- a/drivers/regulator/pcf50633-regulator.c
+++ b/drivers/regulator/pcf50633-regulator.c
@@ -284,7 +284,8 @@ static int __devinit pcf50633_regulator_probe(struct platform_device *pdev)
 	/* Already set by core driver */
 	pcf = platform_get_drvdata(pdev);
 
-	rdev = regulator_register(&regulators[pdev->id], &pdev->dev, pcf);
+	rdev = regulator_register(&regulators[pdev->id], &pdev->dev,
+				  pdev->dev.platform_data, pcf);
 	if (IS_ERR(rdev))
 		return PTR_ERR(rdev);
 
diff --git a/drivers/regulator/wm8350-regulator.c b/drivers/regulator/wm8350-regulator.c
index 5056e23..510920e 100644
--- a/drivers/regulator/wm8350-regulator.c
+++ b/drivers/regulator/wm8350-regulator.c
@@ -1333,9 +1333,9 @@ static int wm8350_regulator_probe(struct platform_device *pdev)
 		break;
 	}
 
-
 	/* register regulator */
 	rdev = regulator_register(&wm8350_reg[pdev->id], &pdev->dev,
+				  pdev->dev.platform_data,
 				  dev_get_drvdata(&pdev->dev));
 	if (IS_ERR(rdev)) {
 		dev_err(&pdev->dev, "failed to register %s\n",
diff --git a/drivers/regulator/wm8400-regulator.c b/drivers/regulator/wm8400-regulator.c
index 56e23d4..6ed43b0 100644
--- a/drivers/regulator/wm8400-regulator.c
+++ b/drivers/regulator/wm8400-regulator.c
@@ -294,7 +294,7 @@ static int __devinit wm8400_regulator_probe(struct platform_device *pdev)
 	struct regulator_dev *rdev;
 
 	rdev = regulator_register(&regulators[pdev->id], &pdev->dev,
-		pdev->dev.driver_data);
+		pdev->dev.platform_data, pdev->dev.driver_data);
 
 	if (IS_ERR(rdev))
 		return PTR_ERR(rdev);
diff --git a/include/linux/regulator/driver.h b/include/linux/regulator/driver.h
index 6e957aa..2254ad9 100644
--- a/include/linux/regulator/driver.h
+++ b/include/linux/regulator/driver.h
@@ -138,7 +138,8 @@ struct regulator_desc {
 };
 
 struct regulator_dev *regulator_register(struct regulator_desc *regulator_desc,
-	struct device *dev, void *driver_data);
+	struct device *dev, struct regulator_init_data *init_data,
+	void *driver_data);
 void regulator_unregister(struct regulator_dev *rdev);
 
 int regulator_notifier_call_chain(struct regulator_dev *rdev,
-- 
1.5.6.5

