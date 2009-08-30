Return-Path: <linux-kernel-owner+w=401wt.eu-S1754093AbZH3VbP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754093AbZH3VbP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Aug 2009 17:31:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753486AbZH3VbO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Aug 2009 17:31:14 -0400
Received: from mail.df.lth.se ([194.47.250.12]:53559 "EHLO df.lth.se"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753242AbZH3VbO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Aug 2009 17:31:14 -0400
From: Linus Walleij <linus.walleij@stericsson.com>
To: linux-arm-kernel@lists.infradead.org
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
       Liam Girdwood <lrg@slimlogic.co.uk>,
       Samuel Ortiz <sameo@linux.intel.com>,
       Russell King <linux@arm.linux.org.uk>, linux-kernel@vger.kernel.org,
       Linus Walleij <linus.walleij@stericsson.com>
Subject: [PATCH 2/2] U300 AB3100 boardinfo
Date: Sun, 30 Aug 2009 23:30:55 +0200
Message-Id: <1251667855-31806-1-git-send-email-linus.walleij@stericsson.com>
X-Mailer: git-send-email 1.6.2.rc1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This defines regulator platform data and board power
regulator hogs for the ST-Ericsson U300 platform.

Signed-off-by: Linus Walleij <linus.walleij@stericsson.com>
Reviewed-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Liam Girdwood <lrg@slimlogic.co.uk>
Cc: Samuel Ortiz <sameo@linux.intel.com>
Cc: Russell King <linux@arm.linux.org.uk>
---
ChangeLog v1->v2

- Shaped up power supplies, moved the board-bound regulator
  get() and enable() into a U300-specific regulator hog
  file in arch/arm/mach-u300/regulator.c

This is pending Russells next tree (I2C
board init file), and applies cleanly to the linux-next
tree as of 2009-08-25.
---
 arch/arm/mach-u300/Makefile    |    1 +
 arch/arm/mach-u300/i2c.c       |  304 ++++++++++++++++++++++++++++++++++++++++
 arch/arm/mach-u300/regulator.c |  150 ++++++++++++++++++++
 3 files changed, 455 insertions(+), 0 deletions(-)
 create mode 100644 arch/arm/mach-u300/regulator.c

diff --git a/arch/arm/mach-u300/Makefile b/arch/arm/mach-u300/Makefile
index 885b5c0..fab46fe 100644
--- a/arch/arm/mach-u300/Makefile
+++ b/arch/arm/mach-u300/Makefile
@@ -12,3 +12,4 @@ obj-$(CONFIG_MMC)                 += mmc.o
 obj-$(CONFIG_SPI_PL022)           += spi.o
 obj-$(CONFIG_MACH_U300_SPIDUMMY)  += dummyspichip.o
 obj-$(CONFIG_I2C_STU300)          += i2c.o
+obj-$(CONFIG_REGULATOR_AB3100)    += regulator.o
diff --git a/arch/arm/mach-u300/i2c.c b/arch/arm/mach-u300/i2c.c
index 10be1f8..d182376 100644
--- a/arch/arm/mach-u300/i2c.c
+++ b/arch/arm/mach-u300/i2c.c
@@ -9,13 +9,312 @@
  */
 #include <linux/kernel.h>
 #include <linux/i2c.h>
+#include <linux/mfd/ab3100.h>
+#include <linux/regulator/machine.h>
+#include <linux/amba/bus.h>
 #include <mach/irqs.h>
 
+/*
+ * Initial settings of ab3100 registers.
+ * Common for below LDO regulator settings are that
+ * bit 7-5 controls voltage. Bit 4 turns regulator ON(1) or OFF(0).
+ * Bit 3-2 controls sleep enable and bit 1-0 controls sleep mode.
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
+#define LDO_E_SLEEP_SETTING	0x00
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
+/* BUCK 0x7D: 1.2V, ON, SLEEP_A and B, SLEEP low power */
+#define BUCK_SETTING	0x7D
+/* BUCK SLEEP 0xAC: 1.05V, Not used, SLEEP_A and B, Not used */
+#define BUCK_SLEEP_SETTING	0xAC
+
+/*
+ * This is the consumer for the on-board devices that should
+ * never be powered off.
+ */
+static struct regulator_consumer_supply supply_ldo_a[] = {
+	{
+		.dev = NULL,
+		.supply = "vrad", /* Powers the radio */
+	},
+};
+
+static struct regulator_consumer_supply supply_ldo_c[] = {
+	{
+		.dev_name = "ab3100-codec",
+		.supply = "vaudio", /* Powers the codec */
+	},
+};
+
+static struct regulator_consumer_supply supply_ldo_d[] = {
+	{
+		.dev = NULL,
+		.supply = "vana15", /* Powers the SoC (CPU etc) */
+	},
+};
+
+static struct regulator_consumer_supply supply_ldo_e[] = {
+	{
+		.dev = NULL,
+		.supply = "vio", /* Powers the I/O peripherals */
+	},
+};
+
+static struct regulator_consumer_supply supply_ldo_e_sleep[] = {
+	{
+		.dev = NULL,
+		.supply = "vioslp", /* Powers the I/O peripherals in sleep */
+	},
+};
+
+static struct regulator_consumer_supply supply_ldo_f[] = {
+	{
+		.dev = NULL,
+		.supply = "vana25", /* Powers the SoC (CPU etc) */
+	},
+};
+
+static struct regulator_consumer_supply supply_ldo_g[] = {
+	{
+		.dev_name = "mmci",
+		.supply = "vcard", /* Powers MMC/SD card */
+	},
+};
+
+static struct regulator_consumer_supply supply_ldo_h[] = {
+	{
+		.dev_name = "fwcam",
+		.supply = "vcam", /* Powers camera */
+	},
+};
+
+static struct regulator_consumer_supply supply_ldo_k[] = {
+	{
+		.dev_name = "irda",
+		.supply = "vir", /* Power IrDA */
+	},
+};
+
+static struct regulator_consumer_supply supply_ldo_ext[] = {
+	{
+		.dev = NULL,
+		.supply = "vext", /* External power */
+	},
+};
+
+static struct regulator_consumer_supply supply_buck[] = {
+	{
+		.dev = NULL,
+		.supply = "vcore", /* Powers the SoC CPU etc */
+	},
+};
+
+static struct regulator_consumer_supply supply_buck_sleep[] = {
+	{
+		.dev = NULL,
+		.supply = "vcoreslp", /* Powers the SoC CPU etc in sleep */
+	},
+};
+
+
+/* Preset (hardware defined) voltages for these regulators */
+#define LDO_A_VOLTAGE 2750000
+#define LDO_C_VOLTAGE 2650000
+#define LDO_D_VOLTAGE 2650000
+
+static struct ab3100_platform_data ab3100_plf_data = {
+	.reg_constraints = {
+		/* LDO A routing and constraints */
+		{
+			.constraints = {
+				.min_uV = LDO_A_VOLTAGE,
+				.max_uV = LDO_A_VOLTAGE,
+				.valid_modes_mask = REGULATOR_MODE_NORMAL,
+			},
+			.num_consumer_supplies = ARRAY_SIZE(supply_ldo_a),
+			.consumer_supplies = supply_ldo_a,
+		},
+		/* LDO C routing and constraints */
+		{
+			.constraints = {
+				.min_uV = LDO_C_VOLTAGE,
+				.max_uV = LDO_C_VOLTAGE,
+				.valid_modes_mask = REGULATOR_MODE_NORMAL,
+			},
+			.num_consumer_supplies = ARRAY_SIZE(supply_ldo_c),
+			.consumer_supplies = supply_ldo_c,
+		},
+		/* LDO D routing and constraints */
+		{
+			.constraints = {
+				.min_uV = LDO_D_VOLTAGE,
+				.max_uV = LDO_D_VOLTAGE,
+				.valid_modes_mask = REGULATOR_MODE_NORMAL,
+			},
+			.num_consumer_supplies = ARRAY_SIZE(supply_ldo_d),
+			.consumer_supplies = supply_ldo_d,
+		},
+		/* LDO E routing and constraints */
+		{
+			.constraints = {
+				.min_uV = 0,
+				.max_uV = 1800000,
+				.valid_modes_mask = REGULATOR_MODE_NORMAL,
+				.valid_ops_mask =
+				REGULATOR_CHANGE_VOLTAGE |
+				REGULATOR_CHANGE_STATUS,
+			},
+			.num_consumer_supplies = ARRAY_SIZE(supply_ldo_e),
+			.consumer_supplies = supply_ldo_e,
+		},
+		/* LDO E in sleep mode routing and constraints */
+		{
+			.constraints = {
+				.min_uV = 0,
+				.max_uV = 1800000,
+				.valid_modes_mask = REGULATOR_MODE_NORMAL,
+				.valid_ops_mask =
+				REGULATOR_CHANGE_VOLTAGE |
+				REGULATOR_CHANGE_STATUS,
+			},
+			.num_consumer_supplies = ARRAY_SIZE(supply_ldo_e_sleep),
+			.consumer_supplies = supply_ldo_e_sleep,
+		},
+		/* LDO F routing and constraints */
+		{
+			.constraints = {
+				.min_uV = 0,
+				.max_uV = 2650000,
+				.valid_modes_mask = REGULATOR_MODE_NORMAL,
+				.valid_ops_mask =
+				REGULATOR_CHANGE_VOLTAGE |
+				REGULATOR_CHANGE_STATUS,
+			},
+			.num_consumer_supplies = ARRAY_SIZE(supply_ldo_f),
+			.consumer_supplies = supply_ldo_f,
+		},
+		/* LDO G routing and constraints */
+		{
+			.constraints = {
+				.min_uV = 0,
+				.max_uV = 2850000,
+				.valid_modes_mask = REGULATOR_MODE_NORMAL,
+				.valid_ops_mask =
+				REGULATOR_CHANGE_VOLTAGE |
+				REGULATOR_CHANGE_STATUS,
+			},
+			.num_consumer_supplies = ARRAY_SIZE(supply_ldo_g),
+			.consumer_supplies = supply_ldo_g,
+		},
+		/* LDO H routing and constraints */
+		{
+			.constraints = {
+				.min_uV = 0,
+				.max_uV = 2750000,
+				.valid_modes_mask = REGULATOR_MODE_NORMAL,
+				.valid_ops_mask =
+				REGULATOR_CHANGE_VOLTAGE |
+				REGULATOR_CHANGE_STATUS,
+			},
+			.num_consumer_supplies = ARRAY_SIZE(supply_ldo_h),
+			.consumer_supplies = supply_ldo_h,
+		},
+		/* LDO K routing and constraints */
+		{
+			.constraints = {
+				.min_uV = 0,
+				.max_uV = 2750000,
+				.valid_modes_mask = REGULATOR_MODE_NORMAL,
+				.valid_ops_mask =
+				REGULATOR_CHANGE_VOLTAGE |
+				REGULATOR_CHANGE_STATUS,
+			},
+			.num_consumer_supplies = ARRAY_SIZE(supply_ldo_k),
+			.consumer_supplies = supply_ldo_k,
+		},
+		/* External regulator interface. No fixed voltage specified.
+		 * If we knew the voltage of the external regulator and it
+		 * was connected on the board, we could add the (fixed)
+		 * voltage for it here.
+		 */
+		{
+			.constraints = {
+				.min_uV = 0,
+				.max_uV = 0,
+				.valid_modes_mask = REGULATOR_MODE_NORMAL,
+				.valid_ops_mask =
+				REGULATOR_CHANGE_STATUS,
+			},
+			.num_consumer_supplies = ARRAY_SIZE(supply_ldo_ext),
+			.consumer_supplies = supply_ldo_ext,
+		},
+		/* Buck converter routing and constraints */
+		{
+			.constraints = {
+				.min_uV = 0,
+				.max_uV = 1800000,
+				.valid_modes_mask = REGULATOR_MODE_NORMAL,
+				.valid_ops_mask =
+				REGULATOR_CHANGE_VOLTAGE |
+				REGULATOR_CHANGE_STATUS,
+			},
+			.num_consumer_supplies = ARRAY_SIZE(supply_buck),
+			.consumer_supplies = supply_buck,
+		},
+		/* Buck converter in sleep mode routing and constraints */
+		{
+			.constraints = {
+				.min_uV = 0,
+				.max_uV = 1800000,
+				.valid_modes_mask = REGULATOR_MODE_NORMAL,
+				.valid_ops_mask =
+				REGULATOR_CHANGE_VOLTAGE |
+				REGULATOR_CHANGE_STATUS,
+			},
+			.num_consumer_supplies = ARRAY_SIZE(supply_buck_sleep),
+			.consumer_supplies = supply_buck_sleep,
+		},
+	},
+	.reg_initvals = {
+		LDO_A_SETTING,
+		LDO_C_SETTING,
+		LDO_D_SETTING,
+		LDO_E_SETTING,
+		LDO_E_SLEEP_SETTING,
+		LDO_F_SETTING,
+		LDO_G_SETTING,
+		LDO_H_SETTING,
+		LDO_K_SETTING,
+		LDO_EXT_SETTING,
+		BUCK_SETTING,
+		BUCK_SLEEP_SETTING,
+	},
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
 
@@ -38,6 +337,11 @@ void __init u300_i2c_register_board_devices(void)
 {
 	i2c_register_board_info(0, bus0_i2c_board_info,
 				ARRAY_SIZE(bus0_i2c_board_info));
+	/*
+	 * This makes the core shut down all unused regulators
+	 * after all the initcalls have completed.
+	 */
+	regulator_has_full_constraints();
 	i2c_register_board_info(1, bus1_i2c_board_info,
 				ARRAY_SIZE(bus1_i2c_board_info));
 }
diff --git a/arch/arm/mach-u300/regulator.c b/arch/arm/mach-u300/regulator.c
new file mode 100644
index 0000000..99776f1
--- /dev/null
+++ b/arch/arm/mach-u300/regulator.c
@@ -0,0 +1,150 @@
+/*
+ * arch/arm/mach-u300/regulator.c
+ *
+ * Copyright (C) 2009 ST-Ericsson AB
+ * License terms: GNU General Public License (GPL) version 2
+ * Handle board-bound regulators and board power not related
+ * to any devices.
+ * Author: Linus Walleij <linus.walleij@stericsson.com>
+ */
+#include <linux/device.h>
+#include <linux/signal.h>
+#include <linux/err.h>
+#include <linux/regulator/consumer.h>
+/* Those are just for writing in syscon */
+#include <linux/io.h>
+#include <mach/hardware.h>
+#include <mach/syscon.h>
+
+/*
+ * Regulators that power the board and chip and which are
+ * not copuled to specific drivers are hogged in these
+ * instances.
+ */
+static struct regulator *radio_power;
+static struct regulator *main_power_15;
+static struct regulator *main_power_25;
+static struct regulator *io_power;
+static struct regulator *io_power_sleep;
+static struct regulator *core_power;
+static struct regulator *core_power_sleep;
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
+		if (main_power_15)
+			regulator_disable(main_power_15);
+		else
+			pr_err("regulator not available to shut down system\n");
+		(void) sigprocmask(SIG_SETMASK, &old, NULL);
+	}
+	return;
+}
+
+/*
+ * Hog the regulators needed to power up the board.
+ */
+static int __init u300_init_boardpower(void)
+{
+	int err;
+	u32 val;
+
+	pr_info("U300: setting up board power\n");
+	radio_power = regulator_get(NULL, "vrad");
+	if (IS_ERR(radio_power)) {
+		pr_err("could not get vrad\n");
+		return PTR_ERR(radio_power);
+	}
+	err = regulator_enable(radio_power);
+	if (err) {
+		pr_err("could not enable vrad\n");
+		return err;
+	}
+
+	main_power_25 = regulator_get(NULL, "vana25");
+	if (IS_ERR(main_power_25)) {
+		pr_err("could not get vana25\n");
+		return PTR_ERR(main_power_25);
+	}
+	err = regulator_enable(main_power_25);
+	if (err) {
+		pr_err("could not enable vana25\n");
+		return err;
+	}
+
+	io_power = regulator_get(NULL, "vio");
+	if (IS_ERR(io_power)) {
+		pr_err("could not get vio\n");
+		return PTR_ERR(io_power);
+	}
+	err = regulator_enable(io_power);
+	if (err) {
+		pr_err("could not enable vio\n");
+		return err;
+	}
+
+	io_power_sleep = regulator_get(NULL, "vioslp");
+	if (IS_ERR(io_power_sleep)) {
+		pr_err("could not get vioslp\n");
+		return PTR_ERR(io_power_sleep);
+	}
+
+	core_power = regulator_get(NULL, "vcore");
+	if (IS_ERR(core_power)) {
+		pr_err("could not get vcore\n");
+		return PTR_ERR(core_power);
+	}
+	err = regulator_enable(core_power);
+	if (err) {
+		pr_err("could not enable vcore\n");
+		return err;
+	}
+
+	core_power_sleep = regulator_get(NULL, "vcoreslp");
+	if (IS_ERR(core_power_sleep)) {
+		pr_err("could not get vcoreslp\n");
+		return PTR_ERR(core_power_sleep);
+	}
+
+	main_power_15 = regulator_get(NULL, "vana15");
+	if (IS_ERR(main_power_15)) {
+		pr_err("could not get vana15");
+		return PTR_ERR(main_power_15);
+	}
+	err = regulator_enable(main_power_15);
+	if (err) {
+		pr_err("could not enable vana15\n");
+		return err;
+	}
+
+	/*
+	 * On U300 a special system controller register pulls up the DC
+	 * until the vana15 (LDO D) regulator comes up. At this point, all
+	 * regulators are set and we do not need power control via
+	 * DC ON anymore. This function will likely be moved whenever
+	 * the rest of the U300 power management is implemented.
+	 */
+	pr_info("U300: disable system controller pull-up\n");
+	val = readw(U300_SYSCON_VBASE + U300_SYSCON_PMCR);
+	val &= ~U300_SYSCON_PMCR_DCON_ENABLE;
+	writew(val, U300_SYSCON_VBASE + U300_SYSCON_PMCR);
+
+	/* Register globally exported PM poweroff hook */
+	pm_power_off = u300_pm_poweroff;
+
+	return 0;
+}
+
+/*
+ * So at module init time we hog the regulator!
+ */
+module_init(u300_init_boardpower);
-- 
1.6.2.1

