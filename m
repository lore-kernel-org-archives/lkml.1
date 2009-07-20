Return-Path: <linux-kernel-owner+w=401wt.eu-S1751289AbZGTNiK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751289AbZGTNiK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jul 2009 09:38:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751054AbZGTNiI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Jul 2009 09:38:08 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:59730 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751822AbZGTNiF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jul 2009 09:38:05 -0400
From: balajitk@ti.com
To: linux-kernel@vger.kernel.org
Cc: tony@atomide.com, khilman@deeprootsystems.com, david-b@pacbell.net,
       linux-omap@vger.kernel.org, linux-i2c@vger.kernel.org,
       sameo@openedhand.com, wim@iguana.be, timo.t.kokkonen@nokia.com,
       ben-linux@fluff.org, lrg@slimlogic.co.uk,
       broonie@opensource.wolfsonmicro.com, Rajendra Nayak <rnayak@ti.com>
Subject: [RFC][PATCH 3/4] OMAP4: PMIC: Add support for twl6030 regulators
Date: Mon, 20 Jul 2009 19:07:35 +0530
Message-Id: <1248097055-14736-1-git-send-email-balajitk@ti.com>
X-Mailer: git-send-email 1.5.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rajendra Nayak <rnayak@ti.com>

This patch updates the regulator driver to add support
for TWL6030 PMIC specific LDO regulators.
SMPS resources are not yet supported for TWL6030 and
also .set_mode and .get_status for LDO's are yet to
be implemented.

Signed-off-by: Rajendra Nayak <rnayak@ti.com>
---
 drivers/regulator/Kconfig         |    4 +-
 drivers/regulator/Makefile        |    2 +-
 drivers/regulator/twl-regulator.c |  106 +++++++++++++++++++++++++++++++------
 include/linux/i2c/twl.h           |   35 ++++++++++++
 4 files changed, 127 insertions(+), 20 deletions(-)

diff --git a/drivers/regulator/Kconfig b/drivers/regulator/Kconfig
index f431779..9e989a4 100644
--- a/drivers/regulator/Kconfig
+++ b/drivers/regulator/Kconfig
@@ -75,9 +75,9 @@ config REGULATOR_MAX1586
 	  regulator via I2C bus. The provided regulator is suitable
 	  for PXA27x chips to control VCC_CORE and VCC_USIM voltages.
 
-config REGULATOR_TWL4030
+config REGULATOR_TWL
 	bool "TI TWL4030/TWL5030/TPS695x0 PMIC"
-	depends on TWL4030_CORE
+	depends on TWL4030_CORE || TWL6030_CORE
 	help
 	  This driver supports the voltage regulators provided by
 	  this family of companion chips.
diff --git a/drivers/regulator/Makefile b/drivers/regulator/Makefile
index 0653ce8..712f733 100644
--- a/drivers/regulator/Makefile
+++ b/drivers/regulator/Makefile
@@ -11,7 +11,7 @@ obj-$(CONFIG_REGULATOR_USERSPACE_CONSUMER) += userspace-consumer.o
 obj-$(CONFIG_REGULATOR_BQ24022) += bq24022.o
 obj-$(CONFIG_REGULATOR_LP3971) += lp3971.o
 obj-$(CONFIG_REGULATOR_MAX1586) += max1586.o
-obj-$(CONFIG_REGULATOR_TWL4030) += twl-regulator.o
+obj-$(CONFIG_REGULATOR_TWL) += twl-regulator.o
 obj-$(CONFIG_REGULATOR_WM8350) += wm8350-regulator.o
 obj-$(CONFIG_REGULATOR_WM8400) += wm8400-regulator.o
 obj-$(CONFIG_REGULATOR_DA903X)	+= da903x.o
diff --git a/drivers/regulator/twl-regulator.c b/drivers/regulator/twl-regulator.c
index d01aa4e..4152f2c 100644
--- a/drivers/regulator/twl-regulator.c
+++ b/drivers/regulator/twl-regulator.c
@@ -52,27 +52,38 @@ struct twlreg_info {
  * The first three registers of all power resource banks help hardware to
  * manage the various resource groups.
  */
+/* Common offset in TWL4030/6030 */
 #define VREG_GRP		0
+/* TWL4030 register offsets */
 #define VREG_TYPE		1
 #define VREG_REMAP		2
-#define VREG_DEDICATED		3	/* LDO control */
-
+#define VREG_DEDICATED		3
+/* TWL6030 register offsets */
+#define VREG_TRANS		1
+#define VREG_STATE		2
+#define VREG_VOLTAGE		3
+/* TWL6030 Misc register offsets */
+#define VREG_BC_ALL		1
+#define VREG_BC_REF		2
+#define VREG_BC_PROC		3
+#define VREG_BC_CLK_RST		4
 
 static inline int
-twlreg_read(struct twlreg_info *info, unsigned offset)
+twlreg_read(struct twlreg_info *info, unsigned slave_subgp, unsigned offset)
 {
 	u8 value;
 	int status;
 
-	status = twl_i2c_read_u8(TWL_MODULE_PM_RECEIVER,
+	status = twl_i2c_read_u8(slave_subgp,
 			&value, info->base + offset);
 	return (status < 0) ? status : value;
 }
 
 static inline int
-twlreg_write(struct twlreg_info *info, unsigned offset, u8 value)
+twlreg_write(struct twlreg_info *info, unsigned slave_subgp, unsigned offset,
+						 u8 value)
 {
-	return twl_i2c_write_u8(TWL_MODULE_PM_RECEIVER,
+	return twl_i2c_write_u8(slave_subgp,
 			value, info->base + offset);
 }
 
@@ -82,17 +93,23 @@ twlreg_write(struct twlreg_info *info, unsigned offset, u8 value)
 
 static int twlreg_grp(struct regulator_dev *rdev)
 {
-	return twlreg_read(rdev_get_drvdata(rdev), VREG_GRP);
+	return twlreg_read(rdev_get_drvdata(rdev), TWL_MODULE_PM_SLAVE_LDO,
+								 VREG_GRP);
 }
 
 /*
  * Enable/disable regulators by joining/leaving the P1 (processor) group.
  * We assume nobody else is updating the DEV_GRP registers.
  */
-
+#ifdef CONFIG_TWL4030_CORE
 #define P3_GRP		BIT(7)		/* "peripherals" */
 #define P2_GRP		BIT(6)		/* secondary processor, modem, etc */
 #define P1_GRP		BIT(5)		/* CPU/Linux */
+#elif CONFIG_TWL6030_CORE
+#define P3_GRP		BIT(2)		/* secondary processor, modem, etc */
+#define P2_GRP		BIT(1)		/* "peripherals" */
+#define P1_GRP		BIT(0)		/* CPU/Linux */
+#endif
 
 static int twlreg_is_enabled(struct regulator_dev *rdev)
 {
@@ -109,12 +126,12 @@ static int twlreg_enable(struct regulator_dev *rdev)
 	struct twlreg_info	*info = rdev_get_drvdata(rdev);
 	int			grp;
 
-	grp = twlreg_read(info, VREG_GRP);
+	grp = twlreg_read(info, TWL_MODULE_PM_SLAVE_LDO, VREG_GRP);
 	if (grp < 0)
 		return grp;
 
 	grp |= P1_GRP;
-	return twlreg_write(info, VREG_GRP, grp);
+	return twlreg_write(info, TWL_MODULE_PM_SLAVE_LDO, VREG_GRP, grp);
 }
 
 static int twlreg_disable(struct regulator_dev *rdev)
@@ -122,12 +139,12 @@ static int twlreg_disable(struct regulator_dev *rdev)
 	struct twlreg_info	*info = rdev_get_drvdata(rdev);
 	int			grp;
 
-	grp = twlreg_read(info, VREG_GRP);
+	grp = twlreg_read(info, TWL_MODULE_PM_SLAVE_LDO, VREG_GRP);
 	if (grp < 0)
 		return grp;
 
 	grp &= ~P1_GRP;
-	return twlreg_write(info, VREG_GRP, grp);
+	return twlreg_write(info, TWL_MODULE_PM_SLAVE_LDO, VREG_GRP, grp);
 }
 
 static int twlreg_get_status(struct regulator_dev *rdev)
@@ -260,7 +277,29 @@ static const u16 VSIM_VSEL_table[] = {
 static const u16 VDAC_VSEL_table[] = {
 	1200, 1300, 1800, 1800,
 };
-
+static const u16 VAUX1_6030_VSEL_table[] = {
+	1000, 1300, 1800, 2500,
+	2800, 2900, 3000, 3000,
+};
+static const u16 VAUX2_6030_VSEL_table[] = {
+	1200, 1800, 2500, 2750,
+	2800, 2800, 2800, 2800,
+};
+static const u16 VAUX3_6030_VSEL_table[] = {
+	1000, 1200, 1300, 1800,
+	2500, 2800, 3000, 3000,
+};
+static const u16 VMMC_VSEL_table[] = {
+	1200, 1800, 2800, 2900,
+	3000, 3000, 3000, 3000,
+};
+static const u16 VPP_VSEL_table[] = {
+	1800, 1900, 2000, 2100,
+	2200, 2300, 2400, 2500,
+};
+static const u16 VUSIM_VSEL_table[] = {
+	1200, 1800, 2500, 2900,
+};
 
 static int twlldo_list_voltage(struct regulator_dev *rdev, unsigned index)
 {
@@ -288,7 +327,8 @@ twlldo_set_voltage(struct regulator_dev *rdev, int min_uV, int max_uV)
 
 		/* use the first in-range value */
 		if (min_uV <= uV && uV <= max_uV)
-			return twlreg_write(info, VREG_DEDICATED, vsel);
+			return twlreg_write(info, TWL_MODULE_PM_SLAVE_LDO,
+							VREG_VOLTAGE, vsel);
 	}
 
 	return -EDOM;
@@ -297,7 +337,8 @@ twlldo_set_voltage(struct regulator_dev *rdev, int min_uV, int max_uV)
 static int twlldo_get_voltage(struct regulator_dev *rdev)
 {
 	struct twlreg_info	*info = rdev_get_drvdata(rdev);
-	int			vsel = twlreg_read(info, VREG_DEDICATED);
+	int		vsel = twlreg_read(info, TWL_MODULE_PM_SLAVE_LDO,
+								VREG_VOLTAGE);
 
 	if (vsel < 0)
 		return vsel;
@@ -316,9 +357,10 @@ static struct regulator_ops twlldo_ops = {
 	.disable	= twlreg_disable,
 	.is_enabled	= twlreg_is_enabled,
 
+#ifdef CONFIG_TWL4030_CORE
 	.set_mode	= twlreg_set_mode,
-
 	.get_status	= twlreg_get_status,
+#endif
 };
 
 /*----------------------------------------------------------------------*/
@@ -349,9 +391,10 @@ static struct regulator_ops twlfixed_ops = {
 	.disable	= twlreg_disable,
 	.is_enabled	= twlreg_is_enabled,
 
+#ifdef CONFIG_TWL4030_CORE
 	.set_mode	= twlreg_set_mode,
-
 	.get_status	= twlreg_get_status,
+#endif
 };
 
 /*----------------------------------------------------------------------*/
@@ -360,6 +403,10 @@ static struct regulator_ops twlfixed_ops = {
 		TWL_ADJUSTABLE_LDO(label, offset, num, TWL4030)
 #define TWL4030_FIXED_LDO(label, offset, mVolts, num) \
 		TWL_FIXED_LDO(label, offset, mVolts, num, TWL4030)
+#define TWL6030_ADJUSTABLE_LDO(label, offset, num) \
+		TWL_ADJUSTABLE_LDO(label, offset, num, TWL6030)
+#define TWL6030_FIXED_LDO(label, offset, mVolts, num) \
+		TWL_FIXED_LDO(label, offset, mVolts, num, TWL6030)
 
 #define TWL_ADJUSTABLE_LDO(label, offset, num, family) { \
 	.base = offset, \
@@ -395,6 +442,7 @@ static struct regulator_ops twlfixed_ops = {
  * software control over them after boot.
  */
 static struct twlreg_info twl_regs[] = {
+#ifdef CONFIG_TWL4030_CORE
 	TWL4030_ADJUSTABLE_LDO(VAUX1, 0x17, 1),
 	TWL4030_ADJUSTABLE_LDO(VAUX2_4030, 0x1b, 2),
 	TWL4030_ADJUSTABLE_LDO(VAUX2, 0x1b, 2),
@@ -420,6 +468,30 @@ static struct twlreg_info twl_regs[] = {
 	TWL4030_FIXED_LDO(VUSB1V8, 0x74, 1800, 18),
 	TWL4030_FIXED_LDO(VUSB3V1, 0x77, 3100, 19),
 	/* VUSBCP is managed *only* by the USB subchip */
+#elif CONFIG_TWL6030_CORE
+       TWL6030_ADJUSTABLE_LDO(VAUX1_6030, 0x84, 1),
+       TWL6030_ADJUSTABLE_LDO(VAUX2_6030, 0x88, 2),
+       TWL6030_ADJUSTABLE_LDO(VAUX3_6030, 0x8c, 3),
+       TWL6030_ADJUSTABLE_LDO(VMMC, 0x98, 4),
+       TWL6030_ADJUSTABLE_LDO(VPP, 0x9c, 5),
+       /*
+       TWL6030_ADJUSTABLE_LDO(VRTC, 0x00, 6),
+       */
+       TWL6030_ADJUSTABLE_LDO(VUSIM, 0xa4, 7),
+       /* SMPS
+       TWL6030_SMPS(VDD1, 0x4b, 8),
+       TWL6030_SMPS(VDD2, 0x55, 9),
+       TWL6030_SMPS(VDD3, 0x63, 10),
+       TWL6030_SMPS(VMEM, 0x00, 11),
+       TWL6030_SMPS(V1V29, 0x00, 12),
+       TWL6030_SMPS(V1V8, 0x00, 13),
+       TWL6030_SMPS(V2V1, 0x00, 14),
+       */
+       TWL6030_FIXED_LDO(VANA, 0x80, 2100, 15),
+       TWL6030_FIXED_LDO(VCXIO, 0x90, 1800, 16),
+       TWL6030_FIXED_LDO(VDAC, 0x94, 1800, 17),
+       TWL6030_FIXED_LDO(VUSB, 0xa0, 3300, 18)
+#endif
 };
 
 static int twlreg_probe(struct platform_device *pdev)
diff --git a/include/linux/i2c/twl.h b/include/linux/i2c/twl.h
index 5ec9070..b128831 100644
--- a/include/linux/i2c/twl.h
+++ b/include/linux/i2c/twl.h
@@ -87,6 +87,7 @@
 #define TWL_MODULE_INT		TWL4030_MODULE_INT
 #define TWL_MODULE_PM_MASTER	TWL4030_MODULE_PM_MASTER
 #define TWL_MODULE_PM_RECEIVER	TWL4030_MODULE_PM_RECEIVER
+#define TWL_MODULE_PM_SLAVE_LDO TWL_MODULE_PM_RECEIVER
 #define TWL_MODULE_RTC		TWL4030_MODULE_RTC
 #define TWL_MODULE_SECURED_REG	TWL4030_MODULE_SECURED_REG
 
@@ -406,6 +407,12 @@ int twl_i2c_read(u8 mod_no, u8 *value, u8 reg, unsigned num_bytes);
 #define MSG_SINGULAR(devgrp, id, state) \
 	((devgrp) << 13 | 0 << 12 | (id) << 4 | (state))
 
+#define MSG_BROADCAST_ALL(devgrp, state) \
+	((devgrp) << 5 | (state))
+
+#define MSG_BROADCAST_REF MSG_BROADCAST_ALL
+#define MSG_BROADCAST_PROV MSG_BROADCAST_ALL
+#define MSG_BROADCAST__CLK_RST MSG_BROADCAST_ALL
 /*----------------------------------------------------------------------*/
 
 struct twl_bci_platform_data {
@@ -516,6 +523,7 @@ int twl4030_sih_setup(int module);
  * VIO is generally fixed.
  */
 
+/* TWL4030 SMPS/LDO's */
 /* EXTERNAL dc-to-dc buck converters */
 #define TWL4030_REG_VDD1	0
 #define TWL4030_REG_VDD2	1
@@ -542,6 +550,33 @@ int twl4030_sih_setup(int module);
 #define TWL4030_REG_VUSB1V8	18
 #define TWL4030_REG_VUSB3V1	19
 
+/* TWL6030 SMPS/LDO's */
+/* EXTERNAL dc-to-dc buck convertor contollable via SR */
+#define TWL6030_REG_VDD1	0
+#define TWL6030_REG_VDD2	1
+#define TWL6030_REG_VDD3	2
+
+/* Non SR compliant dc-to-dc buck convertors */
+#define	TWL6030_REG_VMEM	3
+#define TWL6030_REG_V2V1	4
+#define	TWL6030_REG_V1V29	5
+#define TWL6030_REG_V1V8	6
+
+/* EXTERNAL LDOs */
+#define TWL6030_REG_VAUX1_6030	7
+#define TWL6030_REG_VAUX2_6030	8
+#define TWL6030_REG_VAUX3_6030	9
+#define TWL6030_REG_VMMC	10
+#define TWL6030_REG_VPP		11
+#define TWL6030_REG_VUSIM	12
+#define TWL6030_REG_VANA	13
+#define TWL6030_REG_VCXIO	14
+#define TWL6030_REG_VDAC	15
+#define TWL6030_REG_VUSB	16
+
+/* INTERNAL LDOs */
+#define TWL6030_REG_VRTC	17
+
 int twl_int_mask_reset(u8 bit_mask, u8 offset);
 int twl_int_mask_set(u8 bit_mask, u8 offset);
 int twl_init_irq(int irq_num, unsigned irq_base, unsigned irq_end);
-- 
1.5.4.7

