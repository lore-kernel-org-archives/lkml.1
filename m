Return-Path: <linux-kernel-owner+w=401wt.eu-S1755104AbZHTWLj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755104AbZHTWLj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Aug 2009 18:11:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754292AbZHTWLi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Aug 2009 18:11:38 -0400
Received: from mail.df.lth.se ([194.47.250.12]:37237 "EHLO df.lth.se"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754861AbZHTWLh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Aug 2009 18:11:37 -0400
From: Linus Walleij <linus.walleij@stericsson.com>
To: Liam Girdwood <lrg@slimlogic.co.uk>,
       Mark Brown <broonie@opensource.wolfsonmicro.com>,
       linux-kernel@vger.kernel.org
Cc: Samuel Ortiz <sameo@linux.intel.com>,
       Russell King <linux@arm.linux.org.uk>,
       linux-arm-kernel@lists.arm.linux.org.uk,
       Linus Walleij <linus.walleij@stericsson.com>,
       Liam Girdwood <lrg@slimlogic.co.uk>,
       Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH] AB3100 regulator support v1
Date: Fri, 21 Aug 2009 00:11:11 +0200
Message-Id: <1250806271-24419-1-git-send-email-linus.walleij@stericsson.com>
X-Mailer: git-send-email 1.6.2.rc1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This adds support for the regulators found in the AB3100
Mixed-Signal IC.

It further also defines platform data for the ST-Ericsson
U300 platform and extends the AB3100 MFD driver so that
platform/board data with regulation constraints and an init
function can be passed down all the way from the board to
the regulators.

Signed-off-by: Linus Walleij <linus.walleij@stericsson.com>
Cc: Liam Girdwood <lrg@slimlogic.co.uk>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Samuel Ortiz <sameo@linux.intel.com>
Cc: Russell King <linux@arm.linux.org.uk>
---
This is pending some changes that are queued in Samuels
for-next tree (accessor names) and Russells next tree (I2C
board init file), so it will have to come in some time
later in the 2.6.32-rc cycle so mainly reviewing for now
I guess.
---
 arch/arm/mach-u300/core.c  |    2 +-
 arch/arm/mach-u300/core.h  |   13 +
 arch/arm/mach-u300/i2c.c   |  204 +++++++++
 drivers/mfd/ab3100-core.c  |    4 +
 drivers/regulator/Kconfig  |    9 +
 drivers/regulator/Makefile |    1 +
 drivers/regulator/ab3100.c | 1012 ++++++++++++++++++++++++++++++++++++++++++++
 include/linux/mfd/ab3100.h |   19 +
 8 files changed, 1263 insertions(+), 1 deletions(-)
 create mode 100644 arch/arm/mach-u300/core.h
 create mode 100644 drivers/regulator/ab3100.c

diff --git a/arch/arm/mach-u300/core.c b/arch/arm/mach-u300/core.c
index d4cca25..2a1dd78 100644
--- a/arch/arm/mach-u300/core.c
+++ b/arch/arm/mach-u300/core.c
@@ -153,7 +153,7 @@ static struct amba_device pl022_device = {
 	 */
 };
 
-static struct amba_device mmcsd_device = {
+struct amba_device mmcsd_device = {
 	.dev = {
 		.init_name = "mmci", /* Fast device at 0x1000 offset */
 		.platform_data = NULL, /* Added later */
diff --git a/arch/arm/mach-u300/core.h b/arch/arm/mach-u300/core.h
new file mode 100644
index 0000000..40082df
--- /dev/null
+++ b/arch/arm/mach-u300/core.h
@@ -0,0 +1,13 @@
+/*
+ * arch/arm/mach-u300/core.h
+ *
+ * Copyright (C) 2007-2009 ST-Ericsson AB
+ * License terms: GNU General Public License (GPL) version 2
+ * Stuff the core expose to the outside
+ * Author: Linus Walleij <linus.walleij@stericsson.com>
+ */
+
+/*
+ * Needed to connect the regulator to this device
+ */
+extern struct amba_device mmcsd_device;
diff --git a/arch/arm/mach-u300/i2c.c b/arch/arm/mach-u300/i2c.c
index 10be1f8..750b6cb 100644
--- a/arch/arm/mach-u300/i2c.c
+++ b/arch/arm/mach-u300/i2c.c
@@ -10,12 +10,216 @@
 #include <linux/kernel.h>
 #include <linux/i2c.h>
 #include <mach/irqs.h>
+#include <linux/mfd/ab3100.h>
+#include <linux/regulator/driver.h>
+#include <linux/regulator/machine.h>
+#include <linux/amba/bus.h>
+#include "core.h"
+
+/* Preset (hardware defined) voltages for these regulators */
+#define LDO_A_VOLTAGE 2750000
+#define LDO_C_VOLTAGE 2650000
+#define LDO_D_VOLTAGE 2650000
+/* Not defined by ab3100 so we return 0 */
+#define LDO_EXT_VOLTAGE 0
+
+/*
+ * A local pointer to regulator LDO D which is used for
+ * shutting down the system.
+ */
+static struct regulator_dev *local_ldo_d;
+
+/*
+ * This function is used from pm.h to shut down the system by
+ * resetting all regulators in turn and then disable regulator
+ * LDO D (main power).
+ */
+void u300_pm_poweroff(void)
+{
+	sigset_t old, all;
+
+	sigfillset(&all);
+	if (!sigprocmask(SIG_BLOCK, &all, &old)) {
+		/* Disable LDO D to shut down the system */
+		if (local_ldo_d)
+			(void) local_ldo_d->desc->ops->disable(local_ldo_d);
+		else
+			pr_err("LDO D not available to shut down system\n");
+		(void) sigprocmask(SIG_SETMASK, &old, NULL);
+	}
+	return;
+}
+
+static int u300_ab3100_regulator_init(void *data)
+{
+	struct regulator_dev *rdev = data;
+
+	if (!strcmp(rdev->desc->name, "LDO_D")) {
+		/*
+		 * On U300 a special system controller register pulls up the DC
+		 * until the LDO_D regulator comes up. At this point, all
+		 * regulators are set and we do not need power control via
+		 * DC ON anymore.
+		 */
+		dev_info(&rdev->dev, "disable system controller pull-up\n");
+		/* err = syscon_dc_on(0); */
+		/* Set local regulator device pointer */
+		local_ldo_d = rdev;
+		/* Register globally exported PM poweroff hook */
+		pm_power_off = u300_pm_poweroff;
+	}
+	return 0;
+}
+
+static struct regulator_consumer_supply supply_LDO_G[] = {
+	{
+		.dev = &mmcsd_device.dev,
+		.supply = "VCARD",
+	},
+};
+
+static struct regulator_consumer_supply supply_LDO_H[] = {
+	{
+		.dev = NULL,
+		.supply = "VDISP",
+	},
+};
+
+static struct regulator_consumer_supply supply_LDO_C[] = {
+	{
+		.dev = NULL,
+		.supply = "VAUDIO",
+	},
+};
+
+static const struct ab3100_platform_data ab3100_plf_data = {
+	.reg_constraints = {
+		{
+			.constraints = {
+				.name = "LDO_A",
+				.min_uV = LDO_A_VOLTAGE,
+				.max_uV = LDO_A_VOLTAGE,
+				.valid_modes_mask = REGULATOR_MODE_NORMAL,
+			},
+		},
+		{
+			.constraints = {
+				.name = "LDO_C",
+				.min_uV = LDO_C_VOLTAGE,
+				.max_uV = LDO_C_VOLTAGE,
+				.valid_modes_mask = REGULATOR_MODE_NORMAL,
+			},
+			.num_consumer_supplies = ARRAY_SIZE(supply_LDO_C),
+			.consumer_supplies = supply_LDO_C,
+		},
+		{
+		.constraints = {
+				.name = "LDO_D",
+				.min_uV = LDO_D_VOLTAGE,
+				.max_uV = LDO_D_VOLTAGE,
+				.valid_modes_mask = REGULATOR_MODE_NORMAL,
+				/* Used for powering DB chip */
+				.always_on = 1,
+			},
+		},
+		{
+			.constraints = {
+				.name = "LDO_E",
+				.min_uV = 0,
+				.max_uV = 1800000,
+				.valid_modes_mask = REGULATOR_MODE_NORMAL,
+				.valid_ops_mask =
+				REGULATOR_CHANGE_VOLTAGE |
+				REGULATOR_CHANGE_STATUS,
+				/* Used for powering DB chip */
+				.always_on = 1,
+			},
+		},
+		{
+			.constraints = {
+				.name = "LDO_F",
+				.min_uV = 0,
+				.max_uV = 2650000,
+				.valid_modes_mask = REGULATOR_MODE_NORMAL,
+				.valid_ops_mask =
+				REGULATOR_CHANGE_VOLTAGE |
+				REGULATOR_CHANGE_STATUS,
+				/* Used for powering DB chip */
+				.always_on = 1,
+			},
+		},
+		{
+			.constraints = {
+				.name = "LDO_G",
+				.min_uV = 0,
+				.max_uV = 2850000,
+				.valid_modes_mask = REGULATOR_MODE_NORMAL,
+				.valid_ops_mask =
+				REGULATOR_CHANGE_VOLTAGE |
+				REGULATOR_CHANGE_STATUS,
+			},
+			.num_consumer_supplies = ARRAY_SIZE(supply_LDO_G),
+			.consumer_supplies = supply_LDO_G,
+		},
+		{
+			.constraints = {
+				.name = "LDO_H",
+				.min_uV = 0,
+				.max_uV = 2750000,
+				.valid_modes_mask = REGULATOR_MODE_NORMAL,
+				.valid_ops_mask =
+				REGULATOR_CHANGE_VOLTAGE |
+				REGULATOR_CHANGE_STATUS,
+			},
+			.num_consumer_supplies = ARRAY_SIZE(supply_LDO_H),
+			.consumer_supplies = supply_LDO_H,
+		},
+		{
+			.constraints = {
+				.name = "LDO_K",
+				.min_uV = 0,
+				.max_uV = 2750000,
+				.valid_modes_mask = REGULATOR_MODE_NORMAL,
+				.valid_ops_mask =
+				REGULATOR_CHANGE_VOLTAGE |
+				REGULATOR_CHANGE_STATUS,
+			},
+		},
+		/* External regulator interface. No fixed voltage specified */
+		{
+			.constraints = {
+				.name = "LDO_EXT",
+				.min_uV = 0,
+				.max_uV = 0,
+				.valid_modes_mask = REGULATOR_MODE_NORMAL,
+				.valid_ops_mask =
+				REGULATOR_CHANGE_STATUS,
+			},
+		},
+		{
+			.constraints = {
+				.name = "LDO_BUCK",
+				.min_uV = 0,
+				.max_uV = 1800000,
+				.valid_modes_mask = REGULATOR_MODE_NORMAL,
+				.valid_ops_mask =
+				REGULATOR_CHANGE_VOLTAGE |
+				REGULATOR_CHANGE_STATUS,
+				/* Used for powering DB chip */
+				.always_on = 1,
+			},
+		},
+	},
+	.regulator_init = u300_ab3100_regulator_init,
+};
+
 
 static struct i2c_board_info __initdata bus0_i2c_board_info[] = {
 	{
 		.type = "ab3100",
 		.addr = 0x48,
 		.irq = IRQ_U300_IRQ0_EXT,
+		.platform_data = &ab3100_plf_data,
 	},
 };
 
diff --git a/drivers/mfd/ab3100-core.c b/drivers/mfd/ab3100-core.c
index 098e825..54d3052 100644
--- a/drivers/mfd/ab3100-core.c
+++ b/drivers/mfd/ab3100-core.c
@@ -838,6 +838,8 @@ static int __init ab3100_probe(struct i2c_client *client,
 			const struct i2c_device_id *id)
 {
 	struct ab3100 *ab3100;
+	struct ab3100_platform_data *ab3100_plf_data =
+		client->dev.platform_data;
 	int err;
 	int i;
 
@@ -921,6 +923,8 @@ static int __init ab3100_probe(struct i2c_client *client,
 	for (i = 0; i < ARRAY_SIZE(ab3100_platform_devs); i++) {
 		ab3100_platform_devs[i]->dev.parent =
 			&client->dev;
+		ab3100_platform_devs[i]->dev.platform_data =
+			ab3100_plf_data;
 		platform_set_drvdata(ab3100_platform_devs[i], ab3100);
 	}
 
diff --git a/drivers/regulator/Kconfig b/drivers/regulator/Kconfig
index f431779..ebe7380 100644
--- a/drivers/regulator/Kconfig
+++ b/drivers/regulator/Kconfig
@@ -117,4 +117,13 @@ config REGULATOR_LP3971
 	 Say Y here to support the voltage regulators and convertors
 	 on National Semiconductors LP3971 PMIC
 
+config REGULATOR_AB3100
+	tristate "ST-Ericsson AB3100 Regulator functions"
+	depends on AB3100_CORE
+	default y if AB3100_CORE
+	help
+	 These regulators correspond to functionality in the
+	 AB3100 analog baseband dealing with power regulators
+	 for the system.
+
 endif
diff --git a/drivers/regulator/Makefile b/drivers/regulator/Makefile
index 4d762c4..181555d 100644
--- a/drivers/regulator/Makefile
+++ b/drivers/regulator/Makefile
@@ -16,5 +16,6 @@ obj-$(CONFIG_REGULATOR_WM8350) += wm8350-regulator.o
 obj-$(CONFIG_REGULATOR_WM8400) += wm8400-regulator.o
 obj-$(CONFIG_REGULATOR_DA903X)	+= da903x.o
 obj-$(CONFIG_REGULATOR_PCF50633) += pcf50633-regulator.o
+obj-$(CONFIG_REGULATOR_AB3100) += ab3100.o
 
 ccflags-$(CONFIG_REGULATOR_DEBUG) += -DDEBUG
diff --git a/drivers/regulator/ab3100.c b/drivers/regulator/ab3100.c
new file mode 100644
index 0000000..1defb33
--- /dev/null
+++ b/drivers/regulator/ab3100.c
@@ -0,0 +1,1012 @@
+/*
+ * drivers/regulator/ab3100.c
+ *
+ * Copyright (C) 2008-2009 ST-Ericsson AB
+ * License terms: GNU General Public License (GPL) version 2
+ * Low-level control of the AB3100 IC Low Dropout (LDO) regulators
+ * Author: Mattias Wallin <mattias.wallin@stericsson.com>
+ * Author: Linus Walleij <linus.walleij@stericsson.com>
+ */
+
+#include <linux/module.h>
+#include <linux/kernel.h>
+#include <linux/init.h>
+#include <linux/err.h>
+#include <linux/delay.h>
+#include <linux/platform_device.h>
+#include <linux/regulator/driver.h>
+#include <linux/mfd/ab3100.h>
+
+/* LDO registers and some handy masking definitions for AB3100 */
+#define AB3100_LDO_A		0x40
+#define AB3100_LDO_C		0x41
+#define AB3100_LDO_D		0x42
+#define AB3100_LDO_E		0x43
+#define AB3100_LDO_ESLP		0x44
+#define AB3100_LDO_F		0x45
+#define AB3100_LDO_G		0x46
+#define AB3100_LDO_H		0x47
+#define AB3100_LDO_H_SLEEP_MODE	0
+#define AB3100_LDO_H_SLEEP_EN	2
+#define AB3100_LDO_ON		4
+#define AB3100_LDO_H_VSEL_AC	5
+#define AB3100_LDO_K		0x48
+#define AB3100_LDO_EXT		0x49
+#define AB3100_LDO_BUCK		0x4A
+#define AB3100_LDO_BUCK_SLEEP	0x4B
+#define AB3100_LDO_ON_MASK	0x10
+
+/*
+ * Initial settings of ab3100 registers.
+ * Common for below LDO regulator settings are that
+ * bit 7-5 controls voltage. Bit 4 turns regulator ON(1) or OFF(0).
+ * Bit 3-2 controls sleep enable and bit 1-0 controls sleep mode.
+ * See spec for more detailed info.
+ */
+
+/* LDO_A 0x16: 2.75V, ON, SLEEP_A, SLEEP OFF GND */
+#define LDO_A_SETTING		0x16
+/* LDO_C 0x10: 2.65V, ON, SLEEP_A or B, SLEEP full power */
+#define LDO_C_SETTING		0x10
+/* LDO_D 0x10: 2.65V, ON, sleep mode not used */
+#define LDO_D_SETTING		0x10
+/* LDO_E 0x10: 1.8V, ON, SLEEP_A or B, SLEEP full power */
+#define LDO_E_SETTING		0x10
+/* LDO_E SLEEP 0x00: 1.8V, not used, SLEEP_A or B, not used */
+#define LDO_ESLP_SETTING	0x00
+/* LDO_F 0xD0: 2.5V, ON, SLEEP_A or B, SLEEP full power */
+#define LDO_F_SETTING		0xD0
+/* LDO_G 0x00: 2.85V, OFF, SLEEP_A or B, SLEEP full power */
+#define LDO_G_SETTING		0x00
+/* LDO_H 0x18: 2.75V, ON, SLEEP_B, SLEEP full power */
+#define LDO_H_SETTING		0x18
+/* LDO_K 0x00: 2.75V, OFF, SLEEP_A or B, SLEEP full power */
+#define LDO_K_SETTING		0x00
+/* LDO_EXT 0x00: Voltage not set, OFF, not used, not used */
+#define LDO_EXT_SETTING		0x00
+/* LDO_BUCK 0x7D: 1.2V, ON, SLEEP_A and B, SLEEP low power */
+#define LDO_BUCK_SETTING	0x7D
+/* LDO_BUCK SLEEP 0xAC: 1.05V, Not used, SLEEP_A and B, Not used */
+#define LDO_BUCK_SLEEP_SETTING	0xAC
+
+/* Preset (hardware defined) voltages for these regulators */
+#define LDO_A_VOLTAGE 2750000
+#define LDO_C_VOLTAGE 2650000
+#define LDO_D_VOLTAGE 2650000
+/* Not defined by ab3100 so we return 0 */
+#define LDO_EXT_VOLTAGE 0
+
+struct ab3100_regulator {
+	struct platform_device *pdev;
+	struct ab3100 *ab3100;
+	struct ab3100_platform_data *plfdata;
+};
+
+static inline int ab3100_get_regid(struct regulator_dev *reg, u8 *regid)
+{
+	int ldo = rdev_get_id(reg);
+
+	if (ldo < AB3100_LDO_A || ldo > AB3100_LDO_BUCK_SLEEP) {
+		dev_err(&reg->dev, "wrong regulator id 0x%x\n", ldo);
+		return -EINVAL;
+	}
+	/* typecast int -> u8 should be ok with above check */
+	*regid = (u8)ldo;
+	return 0;
+}
+/*
+ * General functions for enable, disable and is_enabled used for
+ * LDO: A,C,E,F,G,H,K,EXT and BUCK
+ */
+static int ab3100_enable_regulator_LDO(struct regulator_dev *reg)
+{
+	struct ab3100 *ab3100 = reg->reg_data;
+	int err;
+	u8 regid, regval;
+
+	if (ab3100_get_regid(reg, &regid))
+		return -EINVAL;
+
+	err = ab3100_get_register_interruptible(ab3100, regid, &regval);
+	if (err) {
+		dev_warn(&reg->dev, "failed to get regid %d "
+			 "value\n", regid);
+		return err;
+	}
+
+	/* The regulator is already on, no reason to go further */
+	if (regval | AB3100_LDO_ON_MASK)
+		return 0;
+
+	regval |= AB3100_LDO_ON_MASK;
+
+	err = ab3100_set_register_interruptible(ab3100, regid, regval);
+	if (err) {
+		dev_warn(&reg->dev, "failed to set regid %d "
+			 "value\n", regid);
+		return err;
+	}
+
+	/* Per-regulator power on delay from spec */
+	switch (regid) {
+	case AB3100_LDO_A: /* Fallthrough */
+	case AB3100_LDO_C: /* Fallthrough */
+	case AB3100_LDO_D: /* Fallthrough */
+	case AB3100_LDO_E: /* Fallthrough */
+	case AB3100_LDO_H: /* Fallthrough */
+	case AB3100_LDO_K:
+		udelay(200);
+		break;
+	case AB3100_LDO_F:
+		udelay(600);
+		break;
+	case AB3100_LDO_G:
+		udelay(400);
+		break;
+	case AB3100_LDO_BUCK:
+		/* This supplies LEDs and is not time critical */
+		/* mdelay(1); */
+		break;
+	default:
+		break;
+	}
+
+	return err;
+}
+
+static int ab3100_disable_regulator_LDO(struct regulator_dev *reg)
+{
+	struct ab3100 *ab3100 = reg->reg_data;
+	int err;
+	u8 regid, regval;
+
+	if (ab3100_get_regid(reg, &regid))
+		return -EINVAL;
+
+	err = ab3100_get_register_interruptible(ab3100, regid, &regval);
+	if (err) {
+		if (err != -ERESTARTSYS)
+			dev_err(&reg->dev, "unable to get register 0x%x\n",
+				regid);
+		else
+			dev_info(&reg->dev, "iterrupted "
+				 "while getting register 0x%x\n", regid);
+		return err;
+	}
+	regval &= ~AB3100_LDO_ON_MASK;
+	return ab3100_set_register_interruptible(ab3100, regid, regval);
+}
+
+static int ab3100_is_enabled_regulator_LDO(struct regulator_dev *reg)
+{
+	struct ab3100 *ab3100 = reg->reg_data;
+	int err;
+	u8 regid, regval;
+
+	if (ab3100_get_regid(reg, &regid))
+		return -EINVAL;
+
+	err = ab3100_get_register_interruptible(ab3100, regid, &regval);
+	if (err) {
+		if (err != -ERESTARTSYS)
+			dev_err(&reg->dev, "unable to get register 0x%x\n",
+				regid);
+		else
+			dev_info(&reg->dev, "interrupted "
+				 "while getting register 0x%x\n", regid);
+		return err;
+	}
+
+	return regval & AB3100_LDO_ON_MASK;
+}
+
+/* Used for arrays of settings */
+struct ldo_setting {
+	u8 abreg;
+	u8 setting;
+};
+
+static const struct ldo_setting
+ldo_init_settings[] = {
+	{
+		.abreg = AB3100_LDO_A,
+		.setting = LDO_A_SETTING
+	}, {
+		.abreg = AB3100_LDO_C,
+		.setting = LDO_C_SETTING
+	}, {
+		.abreg = AB3100_LDO_E,
+		.setting = LDO_E_SETTING
+	}, {
+		.abreg = AB3100_LDO_ESLP,
+		.setting = LDO_ESLP_SETTING
+	}, {
+		.abreg = AB3100_LDO_F,
+		.setting = LDO_F_SETTING
+	}, {
+		.abreg = AB3100_LDO_G,
+		.setting = LDO_G_SETTING
+	}, {
+		.abreg = AB3100_LDO_H,
+		.setting = LDO_H_SETTING
+	}, {
+		.abreg = AB3100_LDO_K,
+		.setting = LDO_K_SETTING
+	}, {
+		.abreg = AB3100_LDO_EXT,
+		.setting = LDO_EXT_SETTING
+	}, {
+		.abreg = AB3100_LDO_BUCK,
+		.setting = LDO_BUCK_SETTING
+	}, {
+		.abreg = AB3100_LDO_BUCK_SLEEP,
+		.setting = LDO_BUCK_SLEEP_SETTING
+	}, {
+		/* LDO D must be initialized last. */
+		.abreg = AB3100_LDO_D,
+		.setting = LDO_D_SETTING
+	},
+};
+
+static int ab3100_disable_regulator_LDO_D(struct regulator_dev *reg)
+{
+	struct ab3100 *ab3100 = reg->reg_data;
+	int i;
+
+	/*
+	 * Set regulators to default values, ignore any errors,
+	 * we're going DOWN
+	 */
+	for (i = 0; i < ARRAY_SIZE(ldo_init_settings); i++)
+		(void) ab3100_set_register_interruptible(ab3100,
+					  ldo_init_settings[i].abreg,
+					  ldo_init_settings[i].setting);
+
+	/* Setting LDO D to 0x00 cuts the power to the CPU */
+	return ab3100_set_register_interruptible(ab3100,
+						 AB3100_LDO_D, 0x00U);
+}
+
+static int ab3100_get_voltage_regulator_LDO_ACD(struct regulator_dev *reg)
+{
+	u8 regid;
+	if (ab3100_get_regid(reg, &regid))
+		return -EINVAL;
+
+	switch (regid) {
+	case(AB3100_LDO_A):
+		return LDO_A_VOLTAGE;
+	case(AB3100_LDO_C):
+		return LDO_C_VOLTAGE;
+	case(AB3100_LDO_D):
+		return LDO_D_VOLTAGE;
+	default:
+		printk(KERN_ERR "AB3100: get voltage for " \
+		       "unknown regulator 0x%x\n", regid);
+		return 0;
+	}
+}
+
+static int ab3100_get_voltage_regulator_LDO_E_BUCK(struct regulator_dev *reg)
+{
+	struct ab3100 *ab3100 = reg->reg_data;
+	u8 regval;
+	int err;
+
+	err = ab3100_get_register_interruptible(ab3100,
+						AB3100_LDO_E, &regval);
+	if (err) {
+		dev_warn(&reg->dev, "failed to get LDO_EB regulator "
+			 "value\n");
+		return err;
+	}
+
+	regval &= 0xE0;
+	switch (regval >> 5) {
+	case 0:
+		return 1800000;
+	case 1:
+		return 1400000;
+	case 2:
+		return 1300000;
+	case 3:
+		return 1200000;
+	case 4:
+		return 1100000;
+	case 5:
+		return 1050000;
+	case 6:
+		return 900000;
+	case 7:
+		return 0;
+	default:
+		dev_warn(&reg->dev, "erroneous voltage in "
+			 "register LDO_EB %u\n", regval);
+		break;
+	}
+
+	return 0;
+}
+
+static int ab3100_set_voltage_regulator_LDO_E_BUCK(struct regulator_dev *reg,
+						   int min_uV, int max_uV)
+{
+	struct ab3100 *ab3100 = reg->reg_data;
+	int err, v = 0;
+	u8 regval;
+
+	err = ab3100_get_register_interruptible(ab3100,
+						AB3100_LDO_E, &regval);
+	if (err) {
+		dev_warn(&reg->dev, "failed to get LDO_EB "
+			 "regulator value\n");
+		return err;
+	}
+
+	if (min_uV < 900000)
+		v = 7;
+	else if (min_uV < 1050000)
+		v = 6;
+	else if (min_uV < 1100000)
+		v = 5;
+	else if (min_uV < 1200000)
+		v = 4;
+	else if (min_uV < 1300000)
+		v = 3;
+	else if (min_uV < 1400000)
+		v = 2;
+	else if (min_uV < 1800000)
+		v = 1;
+	else
+		v = 0;
+
+	regval &= ~0xE0;
+	regval |= (v << 5);
+	err = ab3100_set_register_interruptible(ab3100,
+						AB3100_LDO_E, regval);
+	if (err)
+		dev_warn(&reg->dev, "failed to set LDO_EB regulator "
+			 "value\n");
+	return err;
+}
+
+static int ab3100_get_voltage_regulator_LDO_F(struct regulator_dev *reg)
+{
+	struct ab3100 *ab3100 = reg->reg_data;
+	u8 regval;
+	int err;
+
+	err = ab3100_get_register_interruptible(ab3100,
+						AB3100_LDO_F, &regval);
+	if (err) {
+		dev_warn(&reg->dev, "failed to get LDO_F regulator value\n");
+		return err;
+	}
+
+	regval &= 0xE0;
+	switch (regval >> 5) {
+	case 0:
+		return 1800000;
+	case 1:
+		return 1400000;
+	case 2:
+		return 1300000;
+	case 3:
+		return 1200000;
+	case 4:
+		return 1100000;
+	case 5:
+		return 1050000;
+	case 6:
+		return 2500000;
+	case 7:
+		return 0;
+	default:
+		dev_warn(&reg->dev, "erroneous voltage in regulator "
+			 "LDO F %u\n", regval);
+		break;
+	}
+
+	return 0;
+}
+
+static int ab3100_set_voltage_regulator_LDO_F(struct regulator_dev *reg,
+					      int min_uV, int max_uV)
+{
+	struct ab3100 *ab3100 = reg->reg_data;
+	int err, v = 0;
+	u8 regval;
+
+	err = ab3100_get_register_interruptible(ab3100,
+						AB3100_LDO_F, &regval);
+	if (err) {
+		dev_warn(&reg->dev, "failed to get LDO_F regulator "
+		       "value\n");
+		return err;
+	}
+
+	if (min_uV < 1050000)
+		v = 7;
+	else if (min_uV < 1100000)
+		v = 5;
+	else if (min_uV < 1200000)
+		v = 4;
+	else if (min_uV < 1300000)
+		v = 3;
+	else if (min_uV < 1400000)
+		v = 2;
+	else if (min_uV < 1800000)
+		v = 1;
+	else if (min_uV < 2500000)
+		v = 0;
+	else
+		v = 6;
+
+	regval &= ~0xE0;
+	regval |= (v << 5);
+	err = ab3100_set_register_interruptible(ab3100,
+						AB3100_LDO_F, regval);
+	if (err)
+		dev_warn(&reg->dev, "failed to set LDO_F regulator "
+			 "value\n");
+	return err;
+}
+
+static int ab3100_get_voltage_regulator_LDO_G(struct regulator_dev *reg)
+{
+	struct ab3100 *ab3100 = reg->reg_data;
+	u8 regval;
+	int err;
+
+	err = ab3100_get_register_interruptible(ab3100,
+						AB3100_LDO_G, &regval);
+	if (err) {
+		dev_warn(&reg->dev, "failed to get LDO_G regulator value\n");
+		return err;
+	}
+
+	regval &= 0xE0;
+	switch (regval >> 5) {
+	case 0:
+		return 2850000;
+	case 1:
+		return 2750000;
+	case 2:
+		return 1800000;
+	case 3:
+		return 1500000;
+	case 7:
+		return 0;
+	default:
+		dev_warn(&reg->dev, "errnoeous voltage register in LDO_G %u\n",
+		       regval);
+		break;
+	}
+
+	return 0;
+}
+
+static int ab3100_set_voltage_regulator_LDO_G(struct regulator_dev *reg,
+					      int min_uV, int max_uV)
+{
+	struct ab3100 *ab3100 = reg->reg_data;
+	int err, v = 0;
+	u8 regval;
+
+	err = ab3100_get_register_interruptible(ab3100,
+						AB3100_LDO_G, &regval);
+	if (err) {
+		dev_warn(&reg->dev, "failed to get LDO_G regulator value\n");
+		return err;
+	}
+
+	if (min_uV < 1500000)
+		v = 7;
+	else if (min_uV < 1800000)
+		v = 3;
+	else if (min_uV < 2750000)
+		v = 2;
+	else if (min_uV < 2850000)
+		v = 1;
+	else
+		v = 0;
+
+	regval &= ~0xE0;
+	regval |= (v << 5);
+	err = ab3100_set_register_interruptible(ab3100,
+						AB3100_LDO_G, regval);
+	if (err)
+		dev_warn(&reg->dev, "failed to set LDO_G regulator value\n");
+	return err;
+}
+
+static int ab3100_get_voltage_regulator_LDO_H(struct regulator_dev *reg)
+{
+	struct ab3100 *ab3100 = reg->reg_data;
+	u8 regval;
+	int err;
+
+	err = ab3100_get_register_interruptible(ab3100,
+						AB3100_LDO_H, &regval);
+	if (err) {
+		dev_warn(&reg->dev, "failed to get LDO_H regulator value\n");
+		return err;
+	}
+
+	regval &= 0xE0;
+	switch (regval >> 5) {
+	case 0:
+		return 2750000;
+	case 1:
+		return 1800000;
+	case 2:
+		return 1500000;
+	case 3:
+		return 1200000;
+	case 7:
+		return 0;
+	default:
+		dev_warn(&reg->dev, "erroneous voltage register LDO_H %u\n",
+		       regval);
+		break;
+	}
+
+	return 0;
+}
+
+static int ab3100_set_voltage_regulator_LDO_H(struct regulator_dev *reg,
+					      int min_uV, int max_uV)
+{
+	struct ab3100 *ab3100 = reg->reg_data;
+	int err, v = 0;
+	u8 regval;
+
+	err = ab3100_get_register_interruptible(ab3100,
+						AB3100_LDO_H, &regval);
+	if (err) {
+		dev_warn(&reg->dev, "failed to get LDO_H regulator value\n");
+		return err;
+	}
+
+	if (min_uV < 1200000)
+		v = 7;
+	else if (min_uV < 1500000)
+		v = 3;
+	else if (min_uV < 1800000)
+		v = 2;
+	else if (min_uV < 2750000)
+		v = 1;
+	else
+		v = 0;
+
+	regval &= ~0xE0;
+	regval |= (v << 5);
+	err = ab3100_set_register_interruptible(ab3100,
+						AB3100_LDO_H, regval);
+	if (err)
+		dev_warn(&reg->dev, "failed to set LDO H regulator value\n");
+	return err;
+}
+
+static int ab3100_get_voltage_regulator_LDO_K(struct regulator_dev *reg)
+{
+	struct ab3100 *ab3100 = reg->reg_data;
+	u8 regval;
+	int err;
+
+	err = ab3100_get_register_interruptible(ab3100,
+						AB3100_LDO_K, &regval);
+	if (err) {
+		dev_warn(&reg->dev, "failed to get LDO_K regulator value\n");
+		return err;
+	}
+
+	regval &= 0xE0;
+	switch (regval >> 5) {
+	case 0:
+		return 2750000;
+	case 1:
+		return 1800000;
+	case 3:
+		return 0;
+	default:
+		dev_warn(&reg->dev,
+			 "erroneous voltage in register LDO_K %u\n",
+			 regval);
+		break;
+	}
+
+	return 0;
+}
+
+static int ab3100_set_voltage_regulator_LDO_K(struct regulator_dev *reg,
+					      int min_uV, int max_uV)
+{
+	struct ab3100 *ab3100 = reg->reg_data;
+	int err, v = 0;
+	u8 regval;
+
+	err = ab3100_get_register_interruptible(ab3100,
+						AB3100_LDO_K, &regval);
+	if (err) {
+		dev_warn(&reg->dev, "failed to get LDO_K regulator value\n");
+		return err;
+	}
+
+	if (min_uV < 1800000)
+		v = 3;
+	else if (min_uV < 2750000)
+		v = 1;
+	else
+		v = 0;
+
+	regval &= ~0xE0;
+	regval |= (v << 5);
+	err = ab3100_set_register_interruptible(ab3100,
+						AB3100_LDO_K, regval);
+	if (err)
+		dev_warn(&reg->dev, "failed to set MMC regulator value\n");
+	return err;
+}
+
+static int ab3100_get_voltage_regulator_LDO_EXT(struct regulator_dev *reg)
+{
+	/* Default return zero because it's unknown */
+	return 0;
+}
+
+static struct regulator_ops regulator_ops_LDO_AC = {
+	.enable      = ab3100_enable_regulator_LDO,
+	.disable     = ab3100_disable_regulator_LDO,
+	.is_enabled  = ab3100_is_enabled_regulator_LDO,
+	.get_voltage = ab3100_get_voltage_regulator_LDO_ACD,
+};
+
+static struct regulator_ops regulator_ops_LDO_D = {
+	/* LDO D cannot be enabled, this is done during set-up */
+	.disable     = ab3100_disable_regulator_LDO_D,
+	.is_enabled  = ab3100_is_enabled_regulator_LDO,
+	.get_voltage = ab3100_get_voltage_regulator_LDO_ACD,
+};
+
+static struct regulator_ops regulator_ops_LDO_E = {
+	.enable      = ab3100_enable_regulator_LDO,
+	.disable     = ab3100_disable_regulator_LDO,
+	.is_enabled  = ab3100_is_enabled_regulator_LDO,
+	.get_voltage = ab3100_get_voltage_regulator_LDO_E_BUCK,
+	.set_voltage = ab3100_set_voltage_regulator_LDO_E_BUCK,
+};
+
+static struct regulator_ops regulator_ops_LDO_F = {
+	.enable      = ab3100_enable_regulator_LDO,
+	.disable     = ab3100_disable_regulator_LDO,
+	.is_enabled  = ab3100_is_enabled_regulator_LDO,
+	.get_voltage = ab3100_get_voltage_regulator_LDO_F,
+	.set_voltage = ab3100_set_voltage_regulator_LDO_F,
+};
+
+static struct regulator_ops regulator_ops_LDO_G = {
+	.enable      = ab3100_enable_regulator_LDO,
+	.disable     = ab3100_disable_regulator_LDO,
+	.is_enabled  = ab3100_is_enabled_regulator_LDO,
+	.get_voltage = ab3100_get_voltage_regulator_LDO_G,
+	.set_voltage = ab3100_set_voltage_regulator_LDO_G,
+};
+
+static struct regulator_ops regulator_ops_LDO_H = {
+	.enable      = ab3100_enable_regulator_LDO,
+	.disable     = ab3100_disable_regulator_LDO,
+	.is_enabled  = ab3100_is_enabled_regulator_LDO,
+	.get_voltage = ab3100_get_voltage_regulator_LDO_H,
+	.set_voltage = ab3100_set_voltage_regulator_LDO_H,
+};
+
+static struct regulator_ops regulator_ops_LDO_K = {
+	.enable      = ab3100_enable_regulator_LDO,
+	.disable     = ab3100_disable_regulator_LDO,
+	.is_enabled  = ab3100_is_enabled_regulator_LDO,
+	.get_voltage = ab3100_get_voltage_regulator_LDO_K,
+	.set_voltage = ab3100_set_voltage_regulator_LDO_K,
+};
+
+/*
+ * LDO EXT is an external regulator so it is really
+ * not possible to get or set any voltage here, AB3100
+ * acts as a mere on/off switch for this regulator.
+ */
+static struct regulator_ops regulator_ops_LDO_EXT = {
+	.enable      = ab3100_enable_regulator_LDO,
+	.disable     = ab3100_disable_regulator_LDO,
+	.is_enabled  = ab3100_is_enabled_regulator_LDO,
+	.get_voltage = ab3100_get_voltage_regulator_LDO_EXT,
+};
+
+static struct regulator_ops regulator_ops_LDO_BUCK = {
+	.enable      = ab3100_enable_regulator_LDO,
+	.disable     = ab3100_disable_regulator_LDO,
+	.is_enabled  = ab3100_is_enabled_regulator_LDO,
+	.get_voltage = ab3100_get_voltage_regulator_LDO_E_BUCK,
+	.set_voltage = ab3100_set_voltage_regulator_LDO_E_BUCK,
+};
+
+static struct regulator_desc regulator_desc_ldo[AB3100_NUM_REGULATORS] = {
+	{
+		.name = "LDO_A",
+		.id   = AB3100_LDO_A,
+		.ops  = &regulator_ops_LDO_AC,
+		.type = REGULATOR_VOLTAGE,
+	},
+	{
+		.name = "LDO_C",
+		.id   = AB3100_LDO_C,
+		.ops  = &regulator_ops_LDO_AC,
+		.type = REGULATOR_VOLTAGE,
+	},
+	{
+		.name = "LDO_D",
+		.id   = AB3100_LDO_D,
+		.ops  = &regulator_ops_LDO_D,
+		.type = REGULATOR_VOLTAGE,
+	},
+	{
+		.name = "LDO_E",
+		.id   = AB3100_LDO_E,
+		.ops  = &regulator_ops_LDO_E,
+		.type = REGULATOR_VOLTAGE,
+	},
+	{
+		.name = "LDO_F",
+		.id   = AB3100_LDO_F,
+		.ops  = &regulator_ops_LDO_F,
+		.type = REGULATOR_VOLTAGE,
+	},
+	{
+		.name = "LDO_G",
+		.id   = AB3100_LDO_G,
+		.ops  = &regulator_ops_LDO_G,
+		.type = REGULATOR_VOLTAGE,
+	},
+	{
+		.name = "LDO_H",
+		.id   = AB3100_LDO_H,
+		.ops  = &regulator_ops_LDO_H,
+		.type = REGULATOR_VOLTAGE,
+	},
+	{
+		.name = "LDO_K",
+		.id   = AB3100_LDO_K,
+		.ops  = &regulator_ops_LDO_K,
+		.type = REGULATOR_VOLTAGE,
+	},
+	{
+		.name = "LDO_EXT",
+		.id   = AB3100_LDO_EXT,
+		.ops  = &regulator_ops_LDO_EXT,
+		.type = REGULATOR_VOLTAGE,
+	},
+	{
+		.name = "LDO_BUCK",
+		.id   = AB3100_LDO_BUCK,
+		.ops  = &regulator_ops_LDO_BUCK,
+		.type = REGULATOR_VOLTAGE,
+	},
+};
+
+static int __init ab3100_regulator_probe(struct platform_device *pdev)
+{
+	struct ab3100_regulator *reg = platform_get_drvdata(pdev);
+	struct ab3100 *ab3100 = reg->ab3100;
+	struct regulator_dev *rdev;
+	int err = 0;
+
+	rdev = regulator_register(&regulator_desc_ldo[pdev->id],
+				  &pdev->dev,
+				  &reg->plfdata->reg_constraints[pdev->id],
+				  /*
+				   * The regulators only really need
+				   * a pointer back to our MFD AB3100
+				   * driver so use this as reg_data
+				   */
+				  ab3100);
+	if (IS_ERR(rdev)) {
+		err = PTR_ERR(rdev);
+		dev_err(&pdev->dev, "%s: failed to register regulator"
+		       " %s err %d\n",
+		       __func__, regulator_desc_ldo[pdev->id].name,
+		       err);
+	}
+
+	/*
+	 * At last set up the board routings, constraints etc
+	 * for the regulator.
+	 */
+	if (reg->plfdata->regulator_init)
+		err = reg->plfdata->regulator_init(rdev);
+
+	return err;
+}
+
+static int __exit ab3100_regulator_remove(struct platform_device *pdev)
+{
+	struct regulator_dev *rdev = platform_get_drvdata(pdev);
+
+	regulator_unregister(rdev);
+	return 0;
+}
+
+static struct platform_driver ab3100_regulator_driver = {
+	.driver = {
+		.name  = "ab3100-regulator",
+		.owner = THIS_MODULE,
+	},
+	.remove = __exit_p(ab3100_regulator_remove),
+};
+
+
+/*
+ * This creates a platform device for a regulator and
+ * registers it to the platform devices.
+ */
+static int __init ab3100_add_regulator_pdev(struct device *parent,
+				    struct ab3100_regulator *rdev,
+				    struct ab3100 *ab3100,
+				    struct ab3100_platform_data *plfdata,
+				    int regid)
+{
+	struct platform_device *pdev;
+	int ret;
+
+	pdev = platform_device_alloc("ab3100-regulator", regid);
+	if (!pdev)
+		return -ENOMEM;
+
+	/*
+	 * Initialize per-regulator struct.
+	 * Inherit platform data, this comes down hierarchally
+	 * from regulators (pluralis), from ab3100 core, from
+	 * i2c boarddata, from the machine. So if you want to
+	 * see what it looks like for a certain machine, go
+	 * into the machine I2C setup.
+	 */
+	rdev->ab3100 = ab3100;
+	rdev->plfdata = plfdata;
+	platform_set_drvdata(pdev, rdev);
+
+	ret = platform_device_add(pdev);
+	if (ret != 0) {
+		dev_err(parent,
+			"Failed to register regulator: %d err %d\n",
+			regid, ret);
+		platform_device_del(pdev);
+	}
+	rdev->pdev = pdev;
+	/* This would seem logical but makes everything break... */
+	/* pdev->dev.parent = parent; */
+
+	return ret;
+}
+
+/* Struct containing the regulator sub-platform devices */
+static struct ab3100_regulator ab3100_regulators[AB3100_NUM_REGULATORS];
+
+/*
+ * NOTE: the following functions are regulators pluralis - it is the
+ * binding to the AB3100 core driver and the parent platform device
+ * for all the different regulators.
+ */
+
+static int __init ab3100_regulators_probe(struct platform_device *pdev)
+{
+	struct ab3100_platform_data *plfdata = pdev->dev.platform_data;
+	struct ab3100 *ab3100 = platform_get_drvdata(pdev);
+	int err = 0;
+	u8 data;
+	int i;
+
+	/* Check chip state */
+	err = ab3100_get_register_interruptible(ab3100,
+						AB3100_LDO_D, &data);
+	if (err) {
+		dev_err(&pdev->dev, "AB3100 regulator: "
+			"Could not read initial status "
+			"of LDO_D\n");
+		return err;
+	} else {
+		if (data & 0x10) {
+			dev_notice(&pdev->dev, "AB3100 regulator LDO D: "
+				   "chip is already in active "
+				   "mode (Warm start)\n");
+		} else {
+			dev_notice(&pdev->dev, "AB3100 regulator LDO D: "
+				   "chip is in inactive mode "
+				   "(Cold start)\n");
+		}
+	}
+
+	/* Set up regulators */
+	for (i = 0; i < ARRAY_SIZE(ldo_init_settings); i++) {
+		err = ab3100_set_register_interruptible(ab3100,
+					  ldo_init_settings[i].abreg,
+					  ldo_init_settings[i].setting);
+		if (err == -ERESTARTSYS) {
+			dev_err(&pdev->dev, "regulator initialization "
+			       "interrupted by system restart");
+			return err;
+		} else if (err != 0) {
+			dev_err(&pdev->dev, "regulator initialization "
+			       "failed with error %d\n",
+			       err);
+			return err;
+		}
+	}
+
+	/* Add platform devices for the regulators if not already done */
+	for (i = 0; i < AB3100_NUM_REGULATORS; i++) {
+		struct ab3100_regulator *rdev = &ab3100_regulators[i];
+
+		if (rdev->pdev)
+			/* Already registered */
+			continue;
+
+		err = ab3100_add_regulator_pdev(&pdev->dev,
+						rdev,
+						ab3100,
+						plfdata,
+						i);
+		if (err) {
+			dev_err(&pdev->dev, "register regulator %d failed "
+				"err %d\n", i, err);
+			return err;
+		}
+	}
+
+	/*
+	 * This makes the core shut down all unused regulators
+	 * after all the initcalls have completed.
+	 */
+	regulator_has_full_constraints();
+
+	/* Add the common platform driver for all regulators */
+	return platform_driver_probe(&ab3100_regulator_driver,
+				     ab3100_regulator_probe);
+}
+
+static int __exit ab3100_regulators_remove(struct platform_device *pdev)
+{
+	/* Remove driver for the regulators */
+	platform_driver_unregister(&ab3100_regulator_driver);
+	/* Keep the platform devices */
+	return 0;
+}
+
+static struct platform_driver ab3100_regulators_driver = {
+	.driver = {
+		.name  = "ab3100-regulators",
+		.owner = THIS_MODULE,
+	},
+	.remove = __exit_p(ab3100_regulators_remove),
+};
+
+static __init int ab3100_regulators_init(void)
+{
+	return platform_driver_probe(&ab3100_regulators_driver,
+				     ab3100_regulators_probe);
+}
+
+static __exit void ab3100_regulators_exit(void)
+{
+	platform_driver_unregister(&ab3100_regulators_driver);
+}
+
+/*
+ * This needs to be an fs_initcall() because the
+ * AB3100 core driver that registers the regulators
+ * device comes in at subsys_initcall() later than
+ * this driver due to link order.
+ */
+fs_initcall(ab3100_regulators_init);
+module_exit(ab3100_regulators_exit);
+
+MODULE_AUTHOR("Mattias Wallin <mattias.wallin@stericsson.com>");
+MODULE_DESCRIPTION("AB3100 Regulator driver");
+MODULE_LICENSE("GPL");
diff --git a/include/linux/mfd/ab3100.h b/include/linux/mfd/ab3100.h
index 56343b8..7d04435 100644
--- a/include/linux/mfd/ab3100.h
+++ b/include/linux/mfd/ab3100.h
@@ -6,6 +6,7 @@
  */
 
 #include <linux/device.h>
+#include <linux/regulator/machine.h>
 
 #ifndef MFD_AB3100_H
 #define MFD_AB3100_H
@@ -56,6 +57,12 @@
 #define AB3100_STR_BATT_REMOVAL				(0x40)
 #define AB3100_STR_VBUS					(0x80)
 
+/*
+ * AB3100 contains 8 regulators, one external regulator controller
+ * and a buck converter
+ */
+#define AB3100_NUM_REGULATORS				10
+
 /**
  * struct ab3100
  * @access_mutex: lock out concurrent accesses to the AB3100 registers
@@ -86,6 +93,18 @@ struct ab3100 {
 	bool startup_events_read;
 };
 
+/**
+ * struct ab3100_platform_data
+ * Data supplied to initialize board connections to the AB3100
+ * @reg_constraints: regulator constraints for target board
+ * @regulator_init: init function to set up the regulators,
+ *     when the regulators are initialized, this will be called
+ */
+struct ab3100_platform_data {
+	struct regulator_init_data reg_constraints[AB3100_NUM_REGULATORS];
+	int (*regulator_init)(void *data);
+};
+
 int ab3100_set_register_interruptible(struct ab3100 *ab3100, u8 reg, u8 regval);
 int ab3100_get_register_interruptible(struct ab3100 *ab3100, u8 reg, u8 *regval);
 int ab3100_get_register_page_interruptible(struct ab3100 *ab3100,
-- 
1.6.2.1

