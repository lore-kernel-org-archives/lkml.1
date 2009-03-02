Return-Path: <linux-kernel-owner+w=401wt.eu-S1758412AbZCBQdb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758412AbZCBQdb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Mar 2009 11:33:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757409AbZCBQcw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Mar 2009 11:32:52 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:36844 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1757392AbZCBQcv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Mar 2009 11:32:51 -0500
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Liam Girdwood <lrg@slimlogic.co.uk>
Cc: linux-kernel@vger.kernel.org,
       Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH 2/2] regulator: Implement list_voltage for WM835x LDOs and DCDCs
Date: Mon,  2 Mar 2009 16:32:47 +0000
Message-Id: <1236011567-31311-2-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.6.1.3
In-Reply-To: <1236011567-31311-1-git-send-email-broonie@opensource.wolfsonmicro.com>
References: <1236011567-31311-1-git-send-email-broonie@opensource.wolfsonmicro.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Implement the recently added voltage step listing API for the WM835x
DCDCs and LDOs. DCDCs can use values up to 0x66, LDOs can use the full
range of values in the mask. Both masks are the lower bits of the
register.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 drivers/regulator/wm8350-regulator.c |   29 +++++++++++++++++++++++++++++
 1 files changed, 29 insertions(+), 0 deletions(-)

diff --git a/drivers/regulator/wm8350-regulator.c b/drivers/regulator/wm8350-regulator.c
index 261db94..771eca1 100644
--- a/drivers/regulator/wm8350-regulator.c
+++ b/drivers/regulator/wm8350-regulator.c
@@ -24,6 +24,9 @@
 #include <linux/regulator/driver.h>
 #include <linux/regulator/machine.h>
 
+/* Maximum value possible for VSEL */
+#define WM8350_DCDC_MAX_VSEL 0x66
+
 /* Microamps */
 static const int isink_cur[] = {
 	4,
@@ -385,6 +388,14 @@ static int wm8350_dcdc_get_voltage(struct regulator_dev *rdev)
 	return wm8350_dcdc_val_to_mvolts(val) * 1000;
 }
 
+static int wm8350_dcdc_list_voltage(struct regulator_dev *rdev,
+				    unsigned selector)
+{
+	if (selector > WM8350_DCDC_MAX_VSEL)
+		return -EINVAL;
+	return wm8350_dcdc_val_to_mvolts(selector) * 1000;
+}
+
 static int wm8350_dcdc_set_suspend_voltage(struct regulator_dev *rdev, int uV)
 {
 	struct wm8350 *wm8350 = rdev_get_drvdata(rdev);
@@ -775,6 +786,14 @@ static int wm8350_ldo_get_voltage(struct regulator_dev *rdev)
 	return wm8350_ldo_val_to_mvolts(val) * 1000;
 }
 
+static int wm8350_ldo_list_voltage(struct regulator_dev *rdev,
+				    unsigned selector)
+{
+	if (selector > WM8350_LDO1_VSEL_MASK)
+		return -EINVAL;
+	return wm8350_ldo_val_to_mvolts(selector) * 1000;
+}
+
 int wm8350_dcdc_set_slot(struct wm8350 *wm8350, int dcdc, u16 start,
 			 u16 stop, u16 fault)
 {
@@ -1162,6 +1181,7 @@ static int wm8350_ldo_is_enabled(struct regulator_dev *rdev)
 static struct regulator_ops wm8350_dcdc_ops = {
 	.set_voltage = wm8350_dcdc_set_voltage,
 	.get_voltage = wm8350_dcdc_get_voltage,
+	.list_voltage = wm8350_dcdc_list_voltage,
 	.enable = wm8350_dcdc_enable,
 	.disable = wm8350_dcdc_disable,
 	.get_mode = wm8350_dcdc_get_mode,
@@ -1185,6 +1205,7 @@ static struct regulator_ops wm8350_dcdc2_5_ops = {
 static struct regulator_ops wm8350_ldo_ops = {
 	.set_voltage = wm8350_ldo_set_voltage,
 	.get_voltage = wm8350_ldo_get_voltage,
+	.list_voltage = wm8350_ldo_list_voltage,
 	.enable = wm8350_ldo_enable,
 	.disable = wm8350_ldo_disable,
 	.is_enabled = wm8350_ldo_is_enabled,
@@ -1209,6 +1230,7 @@ static struct regulator_desc wm8350_reg[NUM_WM8350_REGULATORS] = {
 		.ops = &wm8350_dcdc_ops,
 		.irq = WM8350_IRQ_UV_DC1,
 		.type = REGULATOR_VOLTAGE,
+		.n_voltages = WM8350_DCDC_MAX_VSEL + 1,
 		.owner = THIS_MODULE,
 	},
 	{
@@ -1225,6 +1247,7 @@ static struct regulator_desc wm8350_reg[NUM_WM8350_REGULATORS] = {
 		.ops = &wm8350_dcdc_ops,
 		.irq = WM8350_IRQ_UV_DC3,
 		.type = REGULATOR_VOLTAGE,
+		.n_voltages = WM8350_DCDC_MAX_VSEL + 1,
 		.owner = THIS_MODULE,
 	},
 	{
@@ -1233,6 +1256,7 @@ static struct regulator_desc wm8350_reg[NUM_WM8350_REGULATORS] = {
 		.ops = &wm8350_dcdc_ops,
 		.irq = WM8350_IRQ_UV_DC4,
 		.type = REGULATOR_VOLTAGE,
+		.n_voltages = WM8350_DCDC_MAX_VSEL + 1,
 		.owner = THIS_MODULE,
 	},
 	{
@@ -1249,6 +1273,7 @@ static struct regulator_desc wm8350_reg[NUM_WM8350_REGULATORS] = {
 		.ops = &wm8350_dcdc_ops,
 		.irq = WM8350_IRQ_UV_DC6,
 		.type = REGULATOR_VOLTAGE,
+		.n_voltages = WM8350_DCDC_MAX_VSEL + 1,
 		.owner = THIS_MODULE,
 	},
 	{
@@ -1257,6 +1282,7 @@ static struct regulator_desc wm8350_reg[NUM_WM8350_REGULATORS] = {
 		.ops = &wm8350_ldo_ops,
 		.irq = WM8350_IRQ_UV_LDO1,
 		.type = REGULATOR_VOLTAGE,
+		.n_voltages = WM8350_LDO1_VSEL_MASK + 1,
 		.owner = THIS_MODULE,
 	},
 	{
@@ -1265,6 +1291,7 @@ static struct regulator_desc wm8350_reg[NUM_WM8350_REGULATORS] = {
 		.ops = &wm8350_ldo_ops,
 		.irq = WM8350_IRQ_UV_LDO2,
 		.type = REGULATOR_VOLTAGE,
+		.n_voltages = WM8350_LDO2_VSEL_MASK + 1,
 		.owner = THIS_MODULE,
 	},
 	{
@@ -1273,6 +1300,7 @@ static struct regulator_desc wm8350_reg[NUM_WM8350_REGULATORS] = {
 		.ops = &wm8350_ldo_ops,
 		.irq = WM8350_IRQ_UV_LDO3,
 		.type = REGULATOR_VOLTAGE,
+		.n_voltages = WM8350_LDO3_VSEL_MASK + 1,
 		.owner = THIS_MODULE,
 	},
 	{
@@ -1281,6 +1309,7 @@ static struct regulator_desc wm8350_reg[NUM_WM8350_REGULATORS] = {
 		.ops = &wm8350_ldo_ops,
 		.irq = WM8350_IRQ_UV_LDO4,
 		.type = REGULATOR_VOLTAGE,
+		.n_voltages = WM8350_LDO4_VSEL_MASK + 1,
 		.owner = THIS_MODULE,
 	},
 	{
-- 
1.6.1.3

