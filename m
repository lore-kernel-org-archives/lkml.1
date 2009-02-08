Return-Path: <linux-kernel-owner+w=401wt.eu-S1753379AbZBHThp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753379AbZBHThp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Feb 2009 14:37:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753322AbZBHThI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Feb 2009 14:37:08 -0500
Received: from smtp117.sbc.mail.sp1.yahoo.com ([69.147.64.90]:46124 "HELO
	smtp117.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751387AbZBHThD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Feb 2009 14:37:03 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=xDHSRJLsicrEBMaq5DDkc9BW840APOgOkK81ZvX3ZZbZPJzSlQ5vnsKyed28BV0gKkTTpWCjZBo3But9ye1y1YRzBeLGc53u+rWFnId/aT487PjrjRgGBfr/qQ+gSoZFQfGYVgYN5pXeI5C1q4Tro5Z52czGhISpmviw5bhy3o0=  ;
X-YMail-OSG: 07AAM3IVM1lAduNruZG2PLEFlyPuZthGMkkSqShEebtclMpmGZc789MBiDTPBL5Af5ciSaGZg5kHO.K7YnRpIStGX8vAIOr3iHzMAoJeJR6kFvEJpBkcfyOvHmraY5yM77_7q5gHvhAVlNfwYEN.lTtzocni65HtLVpVbo0ADa2fM3xYtrnWrUaBqq2q8WOK0yE-
X-Yahoo-Newman-Property: ymail-5
From: David Brownell <david-b@pacbell.net>
To: Liam Girdwood <lrg@slimlogic.co.uk>, Mark Brown <broonie@sirena.org.uk>
Subject: [patch 2.6.29-rc3-git 1/2] regulator: twl4030 regulators
Date: Sun, 8 Feb 2009 10:37:06 -0800
User-Agent: KMail/1.9.10
Cc: lkml <linux-kernel@vger.kernel.org>, OMAP <linux-omap@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200902081037.06645.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Brownell <dbrownell@users.sourceforge.net>

Support most of the LDO regulators in the twl4030 family chips.
In the case of LDOs supporting MMC/SD, the voltage controls are
used; but in most other cases, the regulator framework is only
used to enable/disable a supplies, conserving power when a given
voltage rail is not needed.

The drivers/mfd/twl4030-core.c code already sets up the various
regulators according to board-specific configuration, and knows
that some chips don't provide the full set of voltage rails.

The omitted regulators are intended to be under hardware control,
such as during the hardware-mediated system powerup, powerdown,
and suspend states.  Unless/until software hooks are known to
be safe, they won't be exported here.

These regulators implement the new get_status() operation, but
can't realistically implement get_mode(); the status output is
effectively the result of a vote, with the relevant hardware
inputs not exposed.

Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
---
Note a minor regulator API glitch:  there is no clean way to
convert voltages supported by a regulator like VMMC1 or VMMC2
to/from the MMC/SD framework's voltage masks.

 drivers/regulator/Kconfig             |    7 
 drivers/regulator/Makefile            |    1 
 drivers/regulator/twl4030-regulator.c |  511 ++++++++++++++++++++++++++++++++
 include/linux/i2c/twl4030.h           |   47 ++
 4 files changed, 566 insertions(+)

--- a/drivers/regulator/Kconfig
+++ b/drivers/regulator/Kconfig
@@ -52,6 +52,13 @@ config REGULATOR_BQ24022
 	  charging select between 100 mA and 500 mA charging current
 	  limit.
 
+config REGULATOR_TWL4030
+	bool "TI TWL4030/TWL5030/TPS695x0 PMIC"
+	depends on TWL4030_CORE
+	help
+	  This driver supports the voltage regulators provided by
+	  this family of companion chips.
+
 config REGULATOR_WM8350
 	tristate "Wolfson Microelectroncis WM8350 AudioPlus PMIC"
 	depends on MFD_WM8350
--- a/drivers/regulator/Makefile
+++ b/drivers/regulator/Makefile
@@ -8,6 +8,7 @@ obj-$(CONFIG_REGULATOR_FIXED_VOLTAGE) +=
 obj-$(CONFIG_REGULATOR_VIRTUAL_CONSUMER) += virtual.o
 
 obj-$(CONFIG_REGULATOR_BQ24022) += bq24022.o
+obj-$(CONFIG_REGULATOR_TWL4030) += twl4030-regulator.o
 obj-$(CONFIG_REGULATOR_WM8350) += wm8350-regulator.o
 obj-$(CONFIG_REGULATOR_WM8400) += wm8400-regulator.o
 obj-$(CONFIG_REGULATOR_DA903X)	+= da903x.o
--- /dev/null
+++ b/drivers/regulator/twl4030-regulator.c
@@ -0,0 +1,511 @@
+/*
+ * twl4030-regulator.c -- support regulators in twl4030 family chips
+ *
+ * Copyright (C) 2008 David Brownell
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ */
+
+#include <linux/module.h>
+#include <linux/init.h>
+#include <linux/err.h>
+#include <linux/platform_device.h>
+#include <linux/regulator/driver.h>
+#include <linux/regulator/machine.h>
+#include <linux/i2c/twl4030.h>
+
+
+/*
+ * The TWL4030/TW5030/TPS659x0 family chips include power management, a
+ * USB OTG transceiver, an RTC, ADC, PWM, and lots more.  Some versions
+ * include an audio codec, battery charger, and more voltage regulators.
+ * These chips are often used in OMAP-based systems.
+ *
+ * This driver implements software-based resource control for various
+ * voltage regulators.  This is usually augmented with state machine
+ * based control.
+ */
+
+struct twlreg_info {
+	/* start of regulator's PM_RECEIVER control register bank */
+	u8			base;
+
+	/* twl4030 resource ID, for resource control state machine */
+	u8			id;
+
+	/* voltage in mV = table[VSEL]; table_len must be a power-of-two */
+	u8			table_len;
+	const u16		*table;
+
+	/* chip constraints on regulator behavior */
+	u16			min_mV;
+	u16			max_mV;
+
+	/* used by regulator core */
+	struct regulator_desc	desc;
+};
+
+
+/* LDO control registers ... offset is from the base of its register bank.
+ * The first three registers of all power resource banks help hardware to
+ * manage the various resource groups.
+ */
+#define VREG_GRP		0
+#define VREG_TYPE		1
+#define VREG_REMAP		2
+#define VREG_DEDICATED		3	/* LDO control */
+
+
+static inline int
+twl4030reg_read(struct twlreg_info *info, unsigned offset)
+{
+	u8 value;
+	int status;
+
+	status = twl4030_i2c_read_u8(TWL4030_MODULE_PM_RECEIVER,
+			&value, info->base + offset);
+	return (status < 0) ? status : value;
+}
+
+static inline int
+twl4030reg_write(struct twlreg_info *info, unsigned offset, u8 value)
+{
+	return twl4030_i2c_write_u8(TWL4030_MODULE_PM_RECEIVER,
+			value, info->base + offset);
+}
+
+/*----------------------------------------------------------------------*/
+
+/* generic power resource operations, which work on all regulators */
+
+static int twl4030reg_grp(struct regulator_dev *rdev)
+{
+	return twl4030reg_read(rdev_get_drvdata(rdev), VREG_GRP);
+}
+
+/*
+ * Enable/disable regulators by joining/leaving the P1 (processor) group.
+ * We assume nobody else is updating the DEV_GRP registers.
+ */
+
+#define P3_GRP		BIT(7)		/* "peripherals" */
+#define P2_GRP		BIT(6)		/* secondary processor, modem, etc */
+#define P1_GRP		BIT(5)		/* CPU/Linux */
+
+static int twl4030reg_is_enabled(struct regulator_dev *rdev)
+{
+	int	state = twl4030reg_grp(rdev);
+
+	if (state < 0)
+		return state;
+
+	return (state & P1_GRP) != 0;
+}
+
+static int twl4030reg_enable(struct regulator_dev *rdev)
+{
+	struct twlreg_info	*info = rdev_get_drvdata(rdev);
+	int			grp;
+
+	grp = twl4030reg_read(info, VREG_GRP);
+	if (grp < 0)
+		return grp;
+
+	grp |= P1_GRP;
+	return twl4030reg_write(info, VREG_GRP, grp);
+}
+
+static int twl4030reg_disable(struct regulator_dev *rdev)
+{
+	struct twlreg_info	*info = rdev_get_drvdata(rdev);
+	int			grp;
+
+	grp = twl4030reg_read(info, VREG_GRP);
+	if (grp < 0)
+		return grp;
+
+	grp &= ~P1_GRP;
+	return twl4030reg_write(info, VREG_GRP, grp);
+}
+
+static int twl4030reg_get_status(struct regulator_dev *rdev)
+{
+	int	state = twl4030reg_grp(rdev);
+
+	if (state < 0)
+		return state;
+	state &= 0x0f;
+
+	/* assume state != WARM_RESET; we'd not be running...  */
+	if (!state)
+		return REGULATOR_STATUS_OFF;
+	return (state & BIT(3))
+		? REGULATOR_STATUS_NORMAL
+		: REGULATOR_STATUS_STANDBY;
+}
+
+static int twl4030reg_set_mode(struct regulator_dev *rdev, unsigned mode)
+{
+	struct twlreg_info	*info = rdev_get_drvdata(rdev);
+	unsigned		message;
+	int			status;
+
+	/* We can only set the mode through state machine commands... */
+	switch (mode) {
+	case REGULATOR_MODE_NORMAL:
+		message = MSG_SINGULAR(DEV_GRP_P1, info->id, RES_STATE_ACTIVE);
+		break;
+	case REGULATOR_MODE_STANDBY:
+		message = MSG_SINGULAR(DEV_GRP_P1, info->id, RES_STATE_SLEEP);
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	/* Ensure the resource is associated with some group */
+	status = twl4030reg_grp(rdev);
+	if (status < 0)
+		return status;
+	if (!(status & (P3_GRP | P2_GRP | P1_GRP)))
+		return -EACCES;
+
+	status = twl4030_i2c_write_u8(TWL4030_MODULE_PM_MASTER,
+			message >> 8, 0x15 /* PB_WORD_MSB */ );
+	if (status >= 0)
+		return status;
+
+	return twl4030_i2c_write_u8(TWL4030_MODULE_PM_MASTER,
+			message, 0x16 /* PB_WORD_LSB */ );
+}
+
+/*----------------------------------------------------------------------*/
+
+/*
+ * Support for adjustable-voltage LDOs uses a four bit (or less) voltage
+ * select field in its control register.   We use tables indexed by VSEL
+ * to record voltages in milliVolts.  (Accuracy is about three percent.)
+ *
+ * Note that VSEL values for VAUX2 changed in twl5030 and newer silicon;
+ * currently handled by listing two slightly different VAUX2 regulators,
+ * only one of which will be configured.
+ *
+ * VSEL values documented as "TI cannot support these values" are flagged
+ * in these tables as UNSUP() values; we normally won't assign them.
+ */
+#ifdef CONFIG_TWL4030_ALLOW_UNSUPPORTED
+#define UNSUP_MASK	0x0000
+#else
+#define UNSUP_MASK	0x8000
+#endif
+
+#define UNSUP(x)	(UNSUP_MASK | (x))
+#define IS_UNSUP(x)	(UNSUP_MASK & (x))
+#define LDO_MV(x)	(~UNSUP_MASK & (x))
+
+
+static const u16 VAUX1_VSEL_table[] = {
+	UNSUP(1500), UNSUP(1800), 2500, 2800,
+	3000, 3000, 3000, 3000,
+};
+static const u16 VAUX2_4030_VSEL_table[] = {
+	UNSUP(1000), UNSUP(1000), UNSUP(1200), 1300,
+	1500, 1800, UNSUP(1850), 2500,
+	UNSUP(2600), 2800, UNSUP(2850), UNSUP(3000),
+	UNSUP(3150), UNSUP(3150), UNSUP(3150), UNSUP(3150),
+};
+static const u16 VAUX2_VSEL_table[] = {
+	1700, 1700, 1900, 1300,
+	1500, 1800, 2000, 2500,
+	2100, 2800, 2200, 2300,
+	2400, 2400, 2400, 2400,
+};
+static const u16 VAUX3_VSEL_table[] = {
+	1500, 1800, 2500, 2800,
+	UNSUP(3000), UNSUP(3000), UNSUP(3000), UNSUP(3000),
+};
+static const u16 VAUX4_VSEL_table[] = {
+	700, 1000, 1200, UNSUP(1300),
+	1500, 1800, UNSUP(1850), 2500,
+};
+static const u16 VMMC1_VSEL_table[] = {
+	1850, 2850, 3000, 3150,
+};
+static const u16 VMMC2_VSEL_table[] = {
+	UNSUP(1000), UNSUP(1000), UNSUP(1200), UNSUP(1300),
+	UNSUP(1500), UNSUP(1800), 1850, UNSUP(2500),
+	2600, 2800, 2850, 3000,
+	3150, 3150, 3150, 3150,
+};
+static const u16 VPLL1_VSEL_table[] = {
+	1000, 1200, 1300, 1800,
+	UNSUP(2800), UNSUP(3000), UNSUP(3000), UNSUP(3000),
+};
+static const u16 VPLL2_VSEL_table[] = {
+	700, 1000, 1200, 1300,
+	UNSUP(1500), 1800, UNSUP(1850), UNSUP(2500),
+	UNSUP(2600), UNSUP(2800), UNSUP(2850), UNSUP(3000),
+	UNSUP(3150), UNSUP(3150), UNSUP(3150), UNSUP(3150),
+};
+static const u16 VSIM_VSEL_table[] = {
+	UNSUP(1000), UNSUP(1200), UNSUP(1300), 1800,
+	2800, 3000, 3000, 3000,
+};
+static const u16 VDAC_VSEL_table[] = {
+	1200, 1300, 1800, 1800,
+};
+
+
+static int
+twl4030ldo_set_voltage(struct regulator_dev *rdev, int min_uV, int max_uV)
+{
+	struct twlreg_info	*info = rdev_get_drvdata(rdev);
+	int			vsel;
+
+	for (vsel = 0; vsel < info->table_len; vsel++) {
+		int mV = info->table[vsel];
+		int uV;
+
+		if (IS_UNSUP(mV))
+			continue;
+		uV = LDO_MV(mV) * 1000;
+
+		/* use the first in-range value */
+		if (min_uV <= uV && uV <= max_uV)
+			return twl4030reg_write(info, VREG_DEDICATED, vsel);
+	}
+
+	return -EDOM;
+}
+
+static int twl4030ldo_get_voltage(struct regulator_dev *rdev)
+{
+	struct twlreg_info	*info = rdev_get_drvdata(rdev);
+	int			vsel = twl4030reg_read(info, VREG_DEDICATED);
+
+	if (vsel < 0)
+		return vsel;
+
+	vsel &= info->table_len - 1;
+	return LDO_MV(info->table[vsel]) * 1000;
+}
+
+static struct regulator_ops twl4030ldo_ops = {
+	.set_voltage	= twl4030ldo_set_voltage,
+	.get_voltage	= twl4030ldo_get_voltage,
+
+	.enable		= twl4030reg_enable,
+	.disable	= twl4030reg_disable,
+	.is_enabled	= twl4030reg_is_enabled,
+
+	.set_mode	= twl4030reg_set_mode,
+
+	.get_status	= twl4030reg_get_status,
+};
+
+/*----------------------------------------------------------------------*/
+
+/*
+ * Fixed voltage LDOs don't have a VSEL field to update.
+ */
+static int twl4030fixed_get_voltage(struct regulator_dev *rdev)
+{
+	struct twlreg_info	*info = rdev_get_drvdata(rdev);
+
+	return info->min_mV * 1000;
+}
+
+static struct regulator_ops twl4030fixed_ops = {
+	.get_voltage	= twl4030fixed_get_voltage,
+
+	.enable		= twl4030reg_enable,
+	.disable	= twl4030reg_disable,
+	.is_enabled	= twl4030reg_is_enabled,
+
+	.set_mode	= twl4030reg_set_mode,
+
+	.get_status	= twl4030reg_get_status,
+};
+
+/*----------------------------------------------------------------------*/
+
+#define TWL_ADJUSTABLE_LDO(label, offset, num) { \
+	.base = offset, \
+	.id = num, \
+	.table_len = ARRAY_SIZE(label##_VSEL_table), \
+	.table = label##_VSEL_table, \
+	.desc = { \
+		.name = #label, \
+		.id = TWL4030_REG_##label, \
+		.ops = &twl4030ldo_ops, \
+		.type = REGULATOR_VOLTAGE, \
+		.owner = THIS_MODULE, \
+		}, \
+	}
+
+#define TWL_FIXED_LDO(label, offset, mVolts, num) { \
+	.base = offset, \
+	.id = num, \
+	.min_mV = mVolts, \
+	.max_mV = mVolts, \
+	.desc = { \
+		.name = #label, \
+		.id = TWL4030_REG_##label, \
+		.ops = &twl4030fixed_ops, \
+		.type = REGULATOR_VOLTAGE, \
+		.owner = THIS_MODULE, \
+		}, \
+	}
+
+/*
+ * We list regulators here if systems need some level of
+ * software control over them after boot.
+ */
+static struct twlreg_info twl4030_regs[] = {
+	TWL_ADJUSTABLE_LDO(VAUX1, 0x17, 1),
+	TWL_ADJUSTABLE_LDO(VAUX2_4030, 0x1b, 2),
+	TWL_ADJUSTABLE_LDO(VAUX2, 0x1b, 2),
+	TWL_ADJUSTABLE_LDO(VAUX3, 0x1f, 3),
+	TWL_ADJUSTABLE_LDO(VAUX4, 0x23, 4),
+	TWL_ADJUSTABLE_LDO(VMMC1, 0x27, 5),
+	TWL_ADJUSTABLE_LDO(VMMC2, 0x2b, 6),
+	/*
+	TWL_ADJUSTABLE_LDO(VPLL1, 0x2f, 7),
+	TWL_ADJUSTABLE_LDO(VPLL2, 0x33, 8),
+	*/
+	TWL_ADJUSTABLE_LDO(VSIM, 0x37, 9),
+	TWL_ADJUSTABLE_LDO(VDAC, 0x3b, 10),
+	/*
+	TWL_ADJUSTABLE_LDO(VINTANA1, 0x3f, 11),
+	TWL_ADJUSTABLE_LDO(VINTANA2, 0x43, 12),
+	TWL_ADJUSTABLE_LDO(VINTDIG, 0x47, 13),
+	TWL_SMPS(VIO, 0x4b, 14),
+	TWL_SMPS(VDD1, 0x55, 15),
+	TWL_SMPS(VDD2, 0x63, 16),
+	 */
+	TWL_FIXED_LDO(VUSB1V5, 0x71, 1500, 17),
+	TWL_FIXED_LDO(VUSB1V8, 0x74, 1800, 18),
+	TWL_FIXED_LDO(VUSB3V1, 0x77, 3100, 19),
+	/* VUSBCP is managed *only* by the USB subchip */
+};
+
+static int twl4030reg_probe(struct platform_device *pdev)
+{
+	int				i;
+	struct twlreg_info		*info;
+	struct regulator_init_data	*initdata;
+	struct regulation_constraints	*c;
+	struct regulator_dev		*rdev;
+	int				min_uV, max_uV;
+
+	for (i = 0, info = NULL; i < ARRAY_SIZE(twl4030_regs); i++) {
+		if (twl4030_regs[i].desc.id != pdev->id)
+			continue;
+		info = twl4030_regs + i;
+		min_uV = info->min_mV * 1000;
+		max_uV = info->max_mV * 1000;
+		break;
+	}
+	if (!info)
+		return -ENODEV;
+
+	initdata = pdev->dev.platform_data;
+	if (!initdata)
+		return -EINVAL;
+
+	/* Constrain board-specific capabilities according to what
+	 * this driver and the chip itself can actually do.
+	 */
+	c = &initdata->constraints;
+	if (!c->min_uV || c->min_uV < min_uV)
+		c->min_uV = min_uV;
+	if (!c->max_uV || c->max_uV > max_uV)
+		c->max_uV = max_uV;
+	c->valid_modes_mask &= REGULATOR_MODE_NORMAL | REGULATOR_MODE_STANDBY;
+	c->valid_ops_mask &= REGULATOR_CHANGE_VOLTAGE
+				| REGULATOR_CHANGE_MODE
+				| REGULATOR_CHANGE_STATUS;
+
+	rdev = regulator_register(&info->desc, &pdev->dev, info);
+	if (IS_ERR(rdev)) {
+		dev_err(&pdev->dev, "can't register %s, %ld\n",
+				info->desc.name, PTR_ERR(rdev));
+		return PTR_ERR(rdev);
+	}
+	platform_set_drvdata(pdev, rdev);
+
+	/* NOTE:  many regulators support short-circuit IRQs (presentable
+	 * as REGULATOR_OVER_CURRENT notifications?) configured via:
+	 *  - SC_CONFIG
+	 *  - SC_DETECT1 (vintana2, vmmc1/2, vaux1/2/3/4)
+	 *  - SC_DETECT2 (vusb, vdac, vio, vdd1/2, vpll2)
+	 *  - IT_CONFIG
+	 */
+
+	return 0;
+}
+
+static int __devexit twl4030reg_remove(struct platform_device *pdev)
+{
+	regulator_unregister(platform_get_drvdata(pdev));
+	return 0;
+}
+
+MODULE_ALIAS("platform:twl4030_reg");
+
+static struct platform_driver twl4030reg_driver = {
+	.probe		= twl4030reg_probe,
+	.remove		= __devexit_p(twl4030reg_remove),
+	/* NOTE: short name, to work around driver model truncation of
+	 * "twl4030_regulator.12" (and friends) to "twl4030_regulator.1".
+	 */
+	.driver.name	= "twl4030_reg",
+	.driver.owner	= THIS_MODULE,
+};
+
+static int __init twl4030reg_init(void)
+{
+	unsigned i, j;
+
+	/* determine min/max voltage constraints, taking into account
+	 * whether set_voltage() will use the "unsupported" settings
+	 */
+	for (i = 0; i < ARRAY_SIZE(twl4030_regs); i++) {
+		struct twlreg_info	*info = twl4030_regs + i;
+		const u16		*table;
+
+		/* fixed-voltage regulators */
+		if (!info->table_len)
+			continue;
+
+		/* LDO regulators: */
+		for (j = 0, table = info->table;
+				j < info->table_len;
+				j++, table++) {
+			u16		mV = *table;
+
+			if (IS_UNSUP(mV))
+				continue;
+			mV = LDO_MV(mV);
+
+			if (info->min_mV == 0 || info->min_mV > mV)
+				info->min_mV = mV;
+			if (info->max_mV < mV)
+				info->max_mV = mV;
+		}
+	}
+
+	return platform_driver_register(&twl4030reg_driver);
+}
+subsys_initcall(twl4030reg_init);
+
+static void __exit twl4030reg_exit(void)
+{
+	platform_driver_unregister(&twl4030reg_driver);
+}
+module_exit(twl4030reg_exit)
+
+MODULE_DESCRIPTION("TWL4030 regulator driver");
+MODULE_LICENSE("GPL");
--- a/include/linux/i2c/twl4030.h
+++ b/include/linux/i2c/twl4030.h
@@ -218,6 +218,53 @@ int twl4030_i2c_read(u8 mod_no, u8 *valu
 
 /*----------------------------------------------------------------------*/
 
+/* Power bus message definitions */
+
+#define DEV_GRP_NULL		0x0
+#define DEV_GRP_P1		0x1
+#define DEV_GRP_P2		0x2
+#define DEV_GRP_P3		0x4
+
+#define RES_GRP_RES		0x0
+#define RES_GRP_PP		0x1
+#define RES_GRP_RC		0x2
+#define RES_GRP_PP_RC		0x3
+#define RES_GRP_PR		0x4
+#define RES_GRP_PP_PR		0x5
+#define RES_GRP_RC_PR		0x6
+#define RES_GRP_ALL		0x7
+
+#define RES_TYPE2_R0		0x0
+
+#define RES_TYPE_ALL		0x7
+
+#define RES_STATE_WRST		0xF
+#define RES_STATE_ACTIVE	0xE
+#define RES_STATE_SLEEP		0x8
+#define RES_STATE_OFF		0x0
+
+/*
+ * Power Bus Message Format ... these can be sent individually by Linux,
+ * but are usually part of downloaded scripts that are run when various
+ * power events are triggered.
+ *
+ *  Broadcast Message (16 Bits):
+ *    DEV_GRP[15:13] MT[12]  RES_GRP[11:9]  RES_TYPE2[8:7] RES_TYPE[6:4]
+ *    RES_STATE[3:0]
+ *
+ *  Singular Message (16 Bits):
+ *    DEV_GRP[15:13] MT[12]  RES_ID[11:4]  RES_STATE[3:0]
+ */
+
+#define MSG_BROADCAST(devgrp, grp, type, type2, state) \
+	( (devgrp) << 13 | 1 << 12 | (grp) << 9 | (type2) << 7 \
+	| (type) << 4 | (state))
+
+#define MSG_SINGULAR(devgrp, id, state) \
+	((devgrp) << 13 | 0 << 12 | (id) << 4 | (state))
+
+/*----------------------------------------------------------------------*/
+
 struct twl4030_bci_platform_data {
 	int *battery_tmp_tbl;
 	unsigned int tblsize;
