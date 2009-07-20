Return-Path: <linux-kernel-owner+w=401wt.eu-S1753859AbZGTNdW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753859AbZGTNdW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jul 2009 09:33:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753822AbZGTNdV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Jul 2009 09:33:21 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:59479 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753830AbZGTNdP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jul 2009 09:33:15 -0400
From: balajitk@ti.com
To: linux-kernel@vger.kernel.org
Cc: tony@atomide.com, khilman@deeprootsystems.com, david-b@pacbell.net,
       linux-omap@vger.kernel.org, linux-i2c@vger.kernel.org,
       sameo@openedhand.com, wim@iguana.be, timo.t.kokkonen@nokia.com,
       ben-linux@fluff.org, lrg@slimlogic.co.uk,
       broonie@opensource.wolfsonmicro.com, Rajendra Nayak <rnayak@ti.com>,
       Balaji T K <balajitk@ti.com>,
       Santosh Shilimkar <santosh.shilimkar@ti.com>
Subject: [PATCH 4/4] ARM: OMAP: Rename twl4030_ to twl_ in twl-regulator.c to make it generic reg
Date: Mon, 20 Jul 2009 19:02:45 +0530
Message-Id: <1248096765-14299-1-git-send-email-balajitk@ti.com>
X-Mailer: git-send-email 1.5.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rajendra Nayak <rnayak@ti.com>

 This patch renames all twl4030_ functions to twl so that regulator driver
 can be reused by Triton - TWL4030 and Phoenix - TWL6030.

Signed-off-by: Rajendra Nayak <rnayak@ti.com>
Signed-off-by: Balaji T K <balajitk@ti.com>
Signed-off-by: Santosh Shilimkar <santosh.shilimkar@ti.com>
---
 drivers/mfd/twl-core.c            |    3 +-
 drivers/regulator/twl-regulator.c |  191 +++++++++++++++++++------------------
 2 files changed, 100 insertions(+), 94 deletions(-)

diff --git a/drivers/mfd/twl-core.c b/drivers/mfd/twl-core.c
index 95d92db..f40768b 100644
--- a/drivers/mfd/twl-core.c
+++ b/drivers/mfd/twl-core.c
@@ -124,6 +124,7 @@
 #define KEYPAD_SUB_CHIP_ID SUB_CHIP_ID2
 #define BCI_SUB_CHIP_ID SUB_CHIP_ID3
 #define RTC_SUB_CHIP_ID SUB_CHIP_ID3
+#define REG_SUB_CHIP_ID SUB_CHIP_ID3
 
 /* Last - for index max*/
 #define TWL4030_MODULE_LAST		TWL4030_MODULE_SECURED_REG
@@ -463,7 +464,7 @@ add_regulator_linked(int num, struct regulator_init_data *pdata,
 	}
 
 	/* NOTE:  we currently ignore regulator IRQs, e.g. for short circuits */
-	return add_numbered_child(3, "twl4030_reg", num,
+	return add_numbered_child(REG_SUB_CHIP_ID, "twl_reg", num,
 		pdata, sizeof(*pdata), false, 0, 0);
 }
 
diff --git a/drivers/regulator/twl-regulator.c b/drivers/regulator/twl-regulator.c
index 68c941d..d01aa4e 100644
--- a/drivers/regulator/twl-regulator.c
+++ b/drivers/regulator/twl-regulator.c
@@ -1,5 +1,5 @@
 /*
- * twl4030-regulator.c -- support regulators in twl4030 family chips
+ * twl-regulator.c -- support regulators in twl4030/twl6030 family chips
  *
  * Copyright (C) 2008 David Brownell
  *
@@ -19,7 +19,7 @@
 
 
 /*
- * The TWL4030/TW5030/TPS659x0 family chips include power management, a
+ * The TWL4030/TW5030/TPS659x0/TWL6030 family chips include power management, a
  * USB OTG transceiver, an RTC, ADC, PWM, and lots more.  Some versions
  * include an audio codec, battery charger, and more voltage regulators.
  * These chips are often used in OMAP-based systems.
@@ -33,7 +33,7 @@ struct twlreg_info {
 	/* start of regulator's PM_RECEIVER control register bank */
 	u8			base;
 
-	/* twl4030 resource ID, for resource control state machine */
+	/* twl resource ID, for resource control state machine */
 	u8			id;
 
 	/* voltage in mV = table[VSEL]; table_len must be a power-of-two */
@@ -59,20 +59,20 @@ struct twlreg_info {
 
 
 static inline int
-twl4030reg_read(struct twlreg_info *info, unsigned offset)
+twlreg_read(struct twlreg_info *info, unsigned offset)
 {
 	u8 value;
 	int status;
 
-	status = twl_i2c_read_u8(TWL4030_MODULE_PM_RECEIVER,
+	status = twl_i2c_read_u8(TWL_MODULE_PM_RECEIVER,
 			&value, info->base + offset);
 	return (status < 0) ? status : value;
 }
 
 static inline int
-twl4030reg_write(struct twlreg_info *info, unsigned offset, u8 value)
+twlreg_write(struct twlreg_info *info, unsigned offset, u8 value)
 {
-	return twl_i2c_write_u8(TWL4030_MODULE_PM_RECEIVER,
+	return twl_i2c_write_u8(TWL_MODULE_PM_RECEIVER,
 			value, info->base + offset);
 }
 
@@ -80,9 +80,9 @@ twl4030reg_write(struct twlreg_info *info, unsigned offset, u8 value)
 
 /* generic power resource operations, which work on all regulators */
 
-static int twl4030reg_grp(struct regulator_dev *rdev)
+static int twlreg_grp(struct regulator_dev *rdev)
 {
-	return twl4030reg_read(rdev_get_drvdata(rdev), VREG_GRP);
+	return twlreg_read(rdev_get_drvdata(rdev), VREG_GRP);
 }
 
 /*
@@ -94,9 +94,9 @@ static int twl4030reg_grp(struct regulator_dev *rdev)
 #define P2_GRP		BIT(6)		/* secondary processor, modem, etc */
 #define P1_GRP		BIT(5)		/* CPU/Linux */
 
-static int twl4030reg_is_enabled(struct regulator_dev *rdev)
+static int twlreg_is_enabled(struct regulator_dev *rdev)
 {
-	int	state = twl4030reg_grp(rdev);
+	int	state = twlreg_grp(rdev);
 
 	if (state < 0)
 		return state;
@@ -104,35 +104,35 @@ static int twl4030reg_is_enabled(struct regulator_dev *rdev)
 	return (state & P1_GRP) != 0;
 }
 
-static int twl4030reg_enable(struct regulator_dev *rdev)
+static int twlreg_enable(struct regulator_dev *rdev)
 {
 	struct twlreg_info	*info = rdev_get_drvdata(rdev);
 	int			grp;
 
-	grp = twl4030reg_read(info, VREG_GRP);
+	grp = twlreg_read(info, VREG_GRP);
 	if (grp < 0)
 		return grp;
 
 	grp |= P1_GRP;
-	return twl4030reg_write(info, VREG_GRP, grp);
+	return twlreg_write(info, VREG_GRP, grp);
 }
 
-static int twl4030reg_disable(struct regulator_dev *rdev)
+static int twlreg_disable(struct regulator_dev *rdev)
 {
 	struct twlreg_info	*info = rdev_get_drvdata(rdev);
 	int			grp;
 
-	grp = twl4030reg_read(info, VREG_GRP);
+	grp = twlreg_read(info, VREG_GRP);
 	if (grp < 0)
 		return grp;
 
 	grp &= ~P1_GRP;
-	return twl4030reg_write(info, VREG_GRP, grp);
+	return twlreg_write(info, VREG_GRP, grp);
 }
 
-static int twl4030reg_get_status(struct regulator_dev *rdev)
+static int twlreg_get_status(struct regulator_dev *rdev)
 {
-	int	state = twl4030reg_grp(rdev);
+	int	state = twlreg_grp(rdev);
 
 	if (state < 0)
 		return state;
@@ -146,7 +146,7 @@ static int twl4030reg_get_status(struct regulator_dev *rdev)
 		: REGULATOR_STATUS_STANDBY;
 }
 
-static int twl4030reg_set_mode(struct regulator_dev *rdev, unsigned mode)
+static int twlreg_set_mode(struct regulator_dev *rdev, unsigned mode)
 {
 	struct twlreg_info	*info = rdev_get_drvdata(rdev);
 	unsigned		message;
@@ -165,18 +165,18 @@ static int twl4030reg_set_mode(struct regulator_dev *rdev, unsigned mode)
 	}
 
 	/* Ensure the resource is associated with some group */
-	status = twl4030reg_grp(rdev);
+	status = twlreg_grp(rdev);
 	if (status < 0)
 		return status;
 	if (!(status & (P3_GRP | P2_GRP | P1_GRP)))
 		return -EACCES;
 
-	status = twl_i2c_write_u8(TWL4030_MODULE_PM_MASTER,
+	status = twl_i2c_write_u8(TWL_MODULE_PM_MASTER,
 			message >> 8, 0x15/* PB_WORD_MSB */);
 	if (status >= 0)
 		return status;
 
-	return twl_i2c_write_u8(TWL4030_MODULE_PM_MASTER,
+	return twl_i2c_write_u8(TWL_MODULE_PM_MASTER,
 			message, 0x16/* PB_WORD_LSB */);
 }
 
@@ -197,7 +197,7 @@ static int twl4030reg_set_mode(struct regulator_dev *rdev, unsigned mode)
  * VAUX3 at 3V is incorrectly listed in some TI manuals as unsupported.
  * TI are revising the twl5030/tps659x0 specs to support that 3.0V setting.
  */
-#ifdef CONFIG_TWL4030_ALLOW_UNSUPPORTED
+#ifdef CONFIG_TWL_ALLOW_UNSUPPORTED
 #define UNSUP_MASK	0x0000
 #else
 #define UNSUP_MASK	0x8000
@@ -262,7 +262,7 @@ static const u16 VDAC_VSEL_table[] = {
 };
 
 
-static int twl4030ldo_list_voltage(struct regulator_dev *rdev, unsigned index)
+static int twlldo_list_voltage(struct regulator_dev *rdev, unsigned index)
 {
 	struct twlreg_info	*info = rdev_get_drvdata(rdev);
 	int			mV = info->table[index];
@@ -271,7 +271,7 @@ static int twl4030ldo_list_voltage(struct regulator_dev *rdev, unsigned index)
 }
 
 static int
-twl4030ldo_set_voltage(struct regulator_dev *rdev, int min_uV, int max_uV)
+twlldo_set_voltage(struct regulator_dev *rdev, int min_uV, int max_uV)
 {
 	struct twlreg_info	*info = rdev_get_drvdata(rdev);
 	int			vsel;
@@ -288,16 +288,16 @@ twl4030ldo_set_voltage(struct regulator_dev *rdev, int min_uV, int max_uV)
 
 		/* use the first in-range value */
 		if (min_uV <= uV && uV <= max_uV)
-			return twl4030reg_write(info, VREG_DEDICATED, vsel);
+			return twlreg_write(info, VREG_DEDICATED, vsel);
 	}
 
 	return -EDOM;
 }
 
-static int twl4030ldo_get_voltage(struct regulator_dev *rdev)
+static int twlldo_get_voltage(struct regulator_dev *rdev)
 {
 	struct twlreg_info	*info = rdev_get_drvdata(rdev);
-	int			vsel = twl4030reg_read(info, VREG_DEDICATED);
+	int			vsel = twlreg_read(info, VREG_DEDICATED);
 
 	if (vsel < 0)
 		return vsel;
@@ -306,19 +306,19 @@ static int twl4030ldo_get_voltage(struct regulator_dev *rdev)
 	return LDO_MV(info->table[vsel]) * 1000;
 }
 
-static struct regulator_ops twl4030ldo_ops = {
-	.list_voltage	= twl4030ldo_list_voltage,
+static struct regulator_ops twlldo_ops = {
+	.list_voltage	= twlldo_list_voltage,
 
-	.set_voltage	= twl4030ldo_set_voltage,
-	.get_voltage	= twl4030ldo_get_voltage,
+	.set_voltage	= twlldo_set_voltage,
+	.get_voltage	= twlldo_get_voltage,
 
-	.enable		= twl4030reg_enable,
-	.disable	= twl4030reg_disable,
-	.is_enabled	= twl4030reg_is_enabled,
+	.enable		= twlreg_enable,
+	.disable	= twlreg_disable,
+	.is_enabled	= twlreg_is_enabled,
 
-	.set_mode	= twl4030reg_set_mode,
+	.set_mode	= twlreg_set_mode,
 
-	.get_status	= twl4030reg_get_status,
+	.get_status	= twlreg_get_status,
 };
 
 /*----------------------------------------------------------------------*/
@@ -326,60 +326,65 @@ static struct regulator_ops twl4030ldo_ops = {
 /*
  * Fixed voltage LDOs don't have a VSEL field to update.
  */
-static int twl4030fixed_list_voltage(struct regulator_dev *rdev, unsigned index)
+static int twlfixed_list_voltage(struct regulator_dev *rdev, unsigned index)
 {
 	struct twlreg_info	*info = rdev_get_drvdata(rdev);
 
 	return info->min_mV * 1000;
 }
 
-static int twl4030fixed_get_voltage(struct regulator_dev *rdev)
+static int twlfixed_get_voltage(struct regulator_dev *rdev)
 {
 	struct twlreg_info	*info = rdev_get_drvdata(rdev);
 
 	return info->min_mV * 1000;
 }
 
-static struct regulator_ops twl4030fixed_ops = {
-	.list_voltage	= twl4030fixed_list_voltage,
+static struct regulator_ops twlfixed_ops = {
+	.list_voltage	= twlfixed_list_voltage,
 
-	.get_voltage	= twl4030fixed_get_voltage,
+	.get_voltage	= twlfixed_get_voltage,
 
-	.enable		= twl4030reg_enable,
-	.disable	= twl4030reg_disable,
-	.is_enabled	= twl4030reg_is_enabled,
+	.enable		= twlreg_enable,
+	.disable	= twlreg_disable,
+	.is_enabled	= twlreg_is_enabled,
 
-	.set_mode	= twl4030reg_set_mode,
+	.set_mode	= twlreg_set_mode,
 
-	.get_status	= twl4030reg_get_status,
+	.get_status	= twlreg_get_status,
 };
 
 /*----------------------------------------------------------------------*/
 
-#define TWL_ADJUSTABLE_LDO(label, offset, num) { \
+#define TWL4030_ADJUSTABLE_LDO(label, offset, num) \
+		TWL_ADJUSTABLE_LDO(label, offset, num, TWL4030)
+#define TWL4030_FIXED_LDO(label, offset, mVolts, num) \
+		TWL_FIXED_LDO(label, offset, mVolts, num, TWL4030)
+
+#define TWL_ADJUSTABLE_LDO(label, offset, num, family) { \
 	.base = offset, \
 	.id = num, \
 	.table_len = ARRAY_SIZE(label##_VSEL_table), \
 	.table = label##_VSEL_table, \
 	.desc = { \
 		.name = #label, \
-		.id = TWL4030_REG_##label, \
+		.id = family##_REG_##label, \
 		.n_voltages = ARRAY_SIZE(label##_VSEL_table), \
-		.ops = &twl4030ldo_ops, \
+		.ops = &twlldo_ops, \
 		.type = REGULATOR_VOLTAGE, \
 		.owner = THIS_MODULE, \
 		}, \
 	}
 
-#define TWL_FIXED_LDO(label, offset, mVolts, num) { \
+#define TWL_FIXED_LDO(label, offset, mVolts, num, family) { \
 	.base = offset, \
 	.id = num, \
 	.min_mV = mVolts, \
 	.desc = { \
 		.name = #label, \
-		.id = TWL4030_REG_##label, \
+		.id = family##_REG_##label, \
 		.n_voltages = 1, \
-		.ops = &twl4030fixed_ops, \
+		.ops = &twlfixed_ops, \
 		.type = REGULATOR_VOLTAGE, \
 		.owner = THIS_MODULE, \
 		}, \
@@ -389,35 +394,35 @@ static struct regulator_ops twl4030fixed_ops = {
  * We list regulators here if systems need some level of
  * software control over them after boot.
  */
-static struct twlreg_info twl4030_regs[] = {
-	TWL_ADJUSTABLE_LDO(VAUX1, 0x17, 1),
-	TWL_ADJUSTABLE_LDO(VAUX2_4030, 0x1b, 2),
-	TWL_ADJUSTABLE_LDO(VAUX2, 0x1b, 2),
-	TWL_ADJUSTABLE_LDO(VAUX3, 0x1f, 3),
-	TWL_ADJUSTABLE_LDO(VAUX4, 0x23, 4),
-	TWL_ADJUSTABLE_LDO(VMMC1, 0x27, 5),
-	TWL_ADJUSTABLE_LDO(VMMC2, 0x2b, 6),
+static struct twlreg_info twl_regs[] = {
+	TWL4030_ADJUSTABLE_LDO(VAUX1, 0x17, 1),
+	TWL4030_ADJUSTABLE_LDO(VAUX2_4030, 0x1b, 2),
+	TWL4030_ADJUSTABLE_LDO(VAUX2, 0x1b, 2),
+	TWL4030_ADJUSTABLE_LDO(VAUX3, 0x1f, 3),
+	TWL4030_ADJUSTABLE_LDO(VAUX4, 0x23, 4),
+	TWL4030_ADJUSTABLE_LDO(VMMC1, 0x27, 5),
+	TWL4030_ADJUSTABLE_LDO(VMMC2, 0x2b, 6),
 	/*
-	TWL_ADJUSTABLE_LDO(VPLL1, 0x2f, 7),
+	TWL4030_ADJUSTABLE_LDO(VPLL1, 0x2f, 7),
 	*/
-	TWL_ADJUSTABLE_LDO(VPLL2, 0x33, 8),
-	TWL_ADJUSTABLE_LDO(VSIM, 0x37, 9),
-	TWL_ADJUSTABLE_LDO(VDAC, 0x3b, 10),
+	TWL4030_ADJUSTABLE_LDO(VPLL2, 0x33, 8),
+	TWL4030_ADJUSTABLE_LDO(VSIM, 0x37, 9),
+	TWL4030_ADJUSTABLE_LDO(VDAC, 0x3b, 10),
 	/*
-	TWL_ADJUSTABLE_LDO(VINTANA1, 0x3f, 11),
-	TWL_ADJUSTABLE_LDO(VINTANA2, 0x43, 12),
-	TWL_ADJUSTABLE_LDO(VINTDIG, 0x47, 13),
-	TWL_SMPS(VIO, 0x4b, 14),
-	TWL_SMPS(VDD1, 0x55, 15),
-	TWL_SMPS(VDD2, 0x63, 16),
+	TWL4030_ADJUSTABLE_LDO(VINTANA1, 0x3f, 11),
+	TWL4030_ADJUSTABLE_LDO(VINTANA2, 0x43, 12),
+	TWL4030_ADJUSTABLE_LDO(VINTDIG, 0x47, 13),
+	TWL4030_SMPS(VIO, 0x4b, 14),
+	TWL4030_SMPS(VDD1, 0x55, 15),
+	TWL4030_SMPS(VDD2, 0x63, 16),
 	 */
-	TWL_FIXED_LDO(VUSB1V5, 0x71, 1500, 17),
-	TWL_FIXED_LDO(VUSB1V8, 0x74, 1800, 18),
-	TWL_FIXED_LDO(VUSB3V1, 0x77, 3100, 19),
+	TWL4030_FIXED_LDO(VUSB1V5, 0x71, 1500, 17),
+	TWL4030_FIXED_LDO(VUSB1V8, 0x74, 1800, 18),
+	TWL4030_FIXED_LDO(VUSB3V1, 0x77, 3100, 19),
 	/* VUSBCP is managed *only* by the USB subchip */
 };
 
-static int twl4030reg_probe(struct platform_device *pdev)
+static int twlreg_probe(struct platform_device *pdev)
 {
 	int				i;
 	struct twlreg_info		*info;
@@ -425,10 +430,10 @@ static int twl4030reg_probe(struct platform_device *pdev)
 	struct regulation_constraints	*c;
 	struct regulator_dev		*rdev;
 
-	for (i = 0, info = NULL; i < ARRAY_SIZE(twl4030_regs); i++) {
-		if (twl4030_regs[i].desc.id != pdev->id)
+	for (i = 0, info = NULL; i < ARRAY_SIZE(twl_regs); i++) {
+		if (twl_regs[i].desc.id != pdev->id)
 			continue;
-		info = twl4030_regs + i;
+		info = twl_regs + i;
 		break;
 	}
 	if (!info)
@@ -466,35 +471,35 @@ static int twl4030reg_probe(struct platform_device *pdev)
 	return 0;
 }
 
-static int __devexit twl4030reg_remove(struct platform_device *pdev)
+static int __devexit twlreg_remove(struct platform_device *pdev)
 {
 	regulator_unregister(platform_get_drvdata(pdev));
 	return 0;
 }
 
-MODULE_ALIAS("platform:twl4030_reg");
+MODULE_ALIAS("platform:twl_reg");
 
-static struct platform_driver twl4030reg_driver = {
-	.probe		= twl4030reg_probe,
-	.remove		= __devexit_p(twl4030reg_remove),
+static struct platform_driver twlreg_driver = {
+	.probe		= twlreg_probe,
+	.remove		= __devexit_p(twlreg_remove),
 	/* NOTE: short name, to work around driver model truncation of
-	 * "twl4030_regulator.12" (and friends) to "twl4030_regulator.1".
+	 * "twl_regulator.12" (and friends) to "twl_regulator.1".
 	 */
-	.driver.name	= "twl4030_reg",
+	.driver.name	= "twl_reg",
 	.driver.owner	= THIS_MODULE,
 };
 
-static int __init twl4030reg_init(void)
+static int __init twlreg_init(void)
 {
-	return platform_driver_register(&twl4030reg_driver);
+	return platform_driver_register(&twlreg_driver);
 }
-subsys_initcall(twl4030reg_init);
+subsys_initcall(twlreg_init);
 
-static void __exit twl4030reg_exit(void)
+static void __exit twlreg_exit(void)
 {
-	platform_driver_unregister(&twl4030reg_driver);
+	platform_driver_unregister(&twlreg_driver);
 }
-module_exit(twl4030reg_exit)
+module_exit(twlreg_exit)
 
-MODULE_DESCRIPTION("TWL4030 regulator driver");
+MODULE_DESCRIPTION("TWL regulator driver");
 MODULE_LICENSE("GPL");
-- 
1.5.4.7

