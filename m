Return-Path: <linux-kernel-owner+w=401wt.eu-S1756658AbZCJQ3K@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756658AbZCJQ3K (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Mar 2009 12:29:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754968AbZCJQ2l
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Mar 2009 12:28:41 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:55671 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753746AbZCJQ2k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Mar 2009 12:28:40 -0400
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Liam Girdwood <lrg@slimlogic.co.uk>
Cc: linux-kernel@vger.kernel.org,
       Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH 1/2] regulator: Implement list_voltage() for WM8400 DCDCs and LDOs
Date: Tue, 10 Mar 2009 16:28:35 +0000
Message-Id: <1236702516-30733-1-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.6.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

All DCDCs and LDOs are identical.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 drivers/regulator/wm8400-regulator.c |   34 ++++++++++++++++++++++++++++++----
 1 files changed, 30 insertions(+), 4 deletions(-)

diff --git a/drivers/regulator/wm8400-regulator.c b/drivers/regulator/wm8400-regulator.c
index 6ed43b0..1574260 100644
--- a/drivers/regulator/wm8400-regulator.c
+++ b/drivers/regulator/wm8400-regulator.c
@@ -43,6 +43,18 @@ static int wm8400_ldo_disable(struct regulator_dev *dev)
 			       WM8400_LDO1_ENA, 0);
 }
 
+static int wm8400_ldo_list_voltage(struct regulator_dev *dev,
+				   unsigned selector)
+{
+	if (selector > WM8400_LDO1_VSEL_MASK)
+		return -EINVAL;
+
+	if (selector < 15)
+		return 900000 + (selector * 50000);
+	else
+		return 1600000 + ((selector - 14) * 100000);
+}
+
 static int wm8400_ldo_get_voltage(struct regulator_dev *dev)
 {
 	struct wm8400 *wm8400 = rdev_get_drvdata(dev);
@@ -51,10 +63,7 @@ static int wm8400_ldo_get_voltage(struct regulator_dev *dev)
 	val = wm8400_reg_read(wm8400, WM8400_LDO1_CONTROL + rdev_get_id(dev));
 	val &= WM8400_LDO1_VSEL_MASK;
 
-	if (val < 15)
-		return 900000 + (val * 50000);
-	else
-		return 1600000 + ((val - 14) * 100000);
+	return wm8400_ldo_list_voltage(dev, val);
 }
 
 static int wm8400_ldo_set_voltage(struct regulator_dev *dev,
@@ -92,6 +101,7 @@ static struct regulator_ops wm8400_ldo_ops = {
 	.is_enabled = wm8400_ldo_is_enabled,
 	.enable = wm8400_ldo_enable,
 	.disable = wm8400_ldo_disable,
+	.list_voltage = wm8400_ldo_list_voltage,
 	.get_voltage = wm8400_ldo_get_voltage,
 	.set_voltage = wm8400_ldo_set_voltage,
 };
@@ -124,6 +134,15 @@ static int wm8400_dcdc_disable(struct regulator_dev *dev)
 			       WM8400_DC1_ENA, 0);
 }
 
+static int wm8400_dcdc_list_voltage(struct regulator_dev *dev,
+				    unsigned selector)
+{
+	if (selector > WM8400_DC1_VSEL_MASK)
+		return -EINVAL;
+
+	return 850000 + (selector * 25000);
+}
+
 static int wm8400_dcdc_get_voltage(struct regulator_dev *dev)
 {
 	struct wm8400 *wm8400 = rdev_get_drvdata(dev);
@@ -237,6 +256,7 @@ static struct regulator_ops wm8400_dcdc_ops = {
 	.is_enabled = wm8400_dcdc_is_enabled,
 	.enable = wm8400_dcdc_enable,
 	.disable = wm8400_dcdc_disable,
+	.list_voltage = wm8400_dcdc_list_voltage,
 	.get_voltage = wm8400_dcdc_get_voltage,
 	.set_voltage = wm8400_dcdc_set_voltage,
 	.get_mode = wm8400_dcdc_get_mode,
@@ -249,6 +269,7 @@ static struct regulator_desc regulators[] = {
 		.name = "LDO1",
 		.id = WM8400_LDO1,
 		.ops = &wm8400_ldo_ops,
+		.n_voltages = WM8400_LDO1_VSEL_MASK + 1,
 		.type = REGULATOR_VOLTAGE,
 		.owner = THIS_MODULE,
 	},
@@ -256,6 +277,7 @@ static struct regulator_desc regulators[] = {
 		.name = "LDO2",
 		.id = WM8400_LDO2,
 		.ops = &wm8400_ldo_ops,
+		.n_voltages = WM8400_LDO2_VSEL_MASK + 1,
 		.type = REGULATOR_VOLTAGE,
 		.owner = THIS_MODULE,
 	},
@@ -263,6 +285,7 @@ static struct regulator_desc regulators[] = {
 		.name = "LDO3",
 		.id = WM8400_LDO3,
 		.ops = &wm8400_ldo_ops,
+		.n_voltages = WM8400_LDO3_VSEL_MASK + 1,
 		.type = REGULATOR_VOLTAGE,
 		.owner = THIS_MODULE,
 	},
@@ -270,6 +293,7 @@ static struct regulator_desc regulators[] = {
 		.name = "LDO4",
 		.id = WM8400_LDO4,
 		.ops = &wm8400_ldo_ops,
+		.n_voltages = WM8400_LDO4_VSEL_MASK + 1,
 		.type = REGULATOR_VOLTAGE,
 		.owner = THIS_MODULE,
 	},
@@ -277,6 +301,7 @@ static struct regulator_desc regulators[] = {
 		.name = "DCDC1",
 		.id = WM8400_DCDC1,
 		.ops = &wm8400_dcdc_ops,
+		.n_voltages = WM8400_DC1_VSEL_MASK + 1,
 		.type = REGULATOR_VOLTAGE,
 		.owner = THIS_MODULE,
 	},
@@ -284,6 +309,7 @@ static struct regulator_desc regulators[] = {
 		.name = "DCDC2",
 		.id = WM8400_DCDC2,
 		.ops = &wm8400_dcdc_ops,
+		.n_voltages = WM8400_DC2_VSEL_MASK + 1,
 		.type = REGULATOR_VOLTAGE,
 		.owner = THIS_MODULE,
 	},
-- 
1.6.2

