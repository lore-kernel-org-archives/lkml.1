Return-Path: <linux-kernel-owner+w=401wt.eu-S1753555AbZHQOBz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753555AbZHQOBz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Aug 2009 10:01:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753422AbZHQOBy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Aug 2009 10:01:54 -0400
Received: from mail-ew0-f214.google.com ([209.85.219.214]:49433 "EHLO
	mail-ew0-f214.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753308AbZHQOBx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Aug 2009 10:01:53 -0400
From: Amit Kucheria <amit.kucheria@verdurent.com>
To: linux-kernel@vger.kernel.org
Cc: sameo@linux.intel.com, dbrownell@users.sourceforge.net,
       linux-omap@vger.kernel.org
Subject: [PATCH 1/3] MFD: TWL4030: Add support for TWL4030/5030 dynamic power switching
Date: Mon, 17 Aug 2009 17:01:46 +0300
Message-Id: <1250517706-16053-1-git-send-email-amit.kucheria@verdurent.com>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1250517469-15899-1-git-send-email-amit.kucheria@verdurent.com>
References: <1250517469-15899-1-git-send-email-amit.kucheria@verdurent.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The TWL4030/5030 family of multifunction devices allows board-specific
control of the the various regulators, clock and reset lines through
'scripts' that are loaded into its memory. This allows for Dynamic Power
Switching (DPS).

Implement board-independent core support for DPS that is then used by
board-specific code to load custom DPS scripts.

Signed-off-by: Amit Kucheria <amit.kucheria@verdurent.com>
Cc: sameo@linux.intel.com
Cc: dbrownell@users.sourceforge.net
Cc: linux-omap@vger.kernel.org
---
 drivers/mfd/Kconfig         |   13 ++
 drivers/mfd/Makefile        |    1 +
 drivers/mfd/twl4030-core.c  |   10 +
 drivers/mfd/twl4030-power.c |  466 +++++++++++++++++++++++++++++++++++++++++++
 include/linux/i2c/twl4030.h |   94 ++++++++-
 5 files changed, 574 insertions(+), 10 deletions(-)
 create mode 100644 drivers/mfd/twl4030-power.c

diff --git a/drivers/mfd/Kconfig b/drivers/mfd/Kconfig
index 491ac0f..94fa9a0 100644
--- a/drivers/mfd/Kconfig
+++ b/drivers/mfd/Kconfig
@@ -108,6 +108,19 @@ config TWL4030_CORE
 	  high speed USB OTG transceiver, an audio codec (on most
 	  versions) and many other features.
 
+config TWL4030_POWER
+	bool "Support power resources on TWL4030 family chips"
+	depends on TWL4030_CORE
+	help
+	  Say yes here if you want to use the power resources on the
+	  TWL4030 family chips.  Most of these resources are regulators,
+	  which have a separate driver; some are control signals, such
+	  as clock request handshaking.
+
+	  This driver uses board-specific data to initialize the resources
+	  and load scripts controling which resources are switched off/on
+	  or reset when a sleep, wakeup or warm reset event occurs.
+
 config MFD_TMIO
 	bool
 	default n
diff --git a/drivers/mfd/Makefile b/drivers/mfd/Makefile
index 6f8a9a1..84b9eda 100644
--- a/drivers/mfd/Makefile
+++ b/drivers/mfd/Makefile
@@ -23,6 +23,7 @@ obj-$(CONFIG_TPS65010)		+= tps65010.o
 obj-$(CONFIG_MENELAUS)		+= menelaus.o
 
 obj-$(CONFIG_TWL4030_CORE)	+= twl4030-core.o twl4030-irq.o
+obj-$(CONFIG_TWL4030_POWER)    += twl4030-power.o
 
 obj-$(CONFIG_MFD_CORE)		+= mfd-core.o
 
diff --git a/drivers/mfd/twl4030-core.c b/drivers/mfd/twl4030-core.c
index ca54996..28a45a3 100644
--- a/drivers/mfd/twl4030-core.c
+++ b/drivers/mfd/twl4030-core.c
@@ -89,6 +89,12 @@
 #define twl_has_madc()	false
 #endif
 
+#ifdef CONFIG_TWL4030_POWER
+#define twl_has_power()        true
+#else
+#define twl_has_power()        false
+#endif
+
 #if defined(CONFIG_RTC_DRV_TWL4030) || defined(CONFIG_RTC_DRV_TWL4030_MODULE)
 #define twl_has_rtc()	true
 #else
@@ -788,6 +794,10 @@ twl4030_probe(struct i2c_client *client, const struct i2c_device_id *id)
 	/* setup clock framework */
 	clocks_init(&client->dev);
 
+	/* load power event scripts */
+	if (twl_has_power() && pdata->power)
+		twl4030_power_init(pdata->power);
+
 	/* Maybe init the T2 Interrupt subsystem */
 	if (client->irq
 			&& pdata->irq_base
diff --git a/drivers/mfd/twl4030-power.c b/drivers/mfd/twl4030-power.c
new file mode 100644
index 0000000..e7688b0
--- /dev/null
+++ b/drivers/mfd/twl4030-power.c
@@ -0,0 +1,466 @@
+/*
+ * linux/drivers/i2c/chips/twl4030-power.c
+ *
+ * Handle TWL4030 Power initialization
+ *
+ * Copyright (C) 2008 Nokia Corporation
+ * Copyright (C) 2006 Texas Instruments, Inc
+ *
+ * Written by 	Kalle Jokiniemi
+ *		Peter De Schrijver <peter.de-schrijver@nokia.com>
+ * Several fixes by Amit Kucheria <amit.kucheria@verdurent.com>
+ *
+ * This file is subject to the terms and conditions of the GNU General
+ * Public License. See the file "COPYING" in the main directory of this
+ * archive for more details.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
+ */
+
+#include <linux/module.h>
+#include <linux/pm.h>
+#include <linux/i2c/twl4030.h>
+#include <linux/platform_device.h>
+
+#include <asm/mach-types.h>
+
+static u8 twl4030_start_script_address = 0x2b;
+
+#define PWR_P1_SW_EVENTS	0x10
+#define PWR_DEVOFF	(1<<0)
+
+#define PHY_TO_OFF_PM_MASTER(p)		(p - 0x36)
+#define PHY_TO_OFF_PM_RECEIVER(p)	(p - 0x5b)
+
+/* resource - hfclk */
+#define R_HFCLKOUT_DEV_GRP 	PHY_TO_OFF_PM_RECEIVER(0xe6)
+
+/* PM events */
+#define R_P1_SW_EVENTS		PHY_TO_OFF_PM_MASTER(0x46)
+#define R_P2_SW_EVENTS		PHY_TO_OFF_PM_MASTER(0x47)
+#define R_P3_SW_EVENTS		PHY_TO_OFF_PM_MASTER(0x48)
+#define R_CFG_P1_TRANSITION	PHY_TO_OFF_PM_MASTER(0x36)
+#define R_CFG_P2_TRANSITION	PHY_TO_OFF_PM_MASTER(0x37)
+#define R_CFG_P3_TRANSITION	PHY_TO_OFF_PM_MASTER(0x38)
+
+#define LVL_WAKEUP	0x08
+
+#define ENABLE_WARMRESET (1<<4)
+
+#define END_OF_SCRIPT		0x3f
+
+#define R_SEQ_ADD_A2S		PHY_TO_OFF_PM_MASTER(0x55)
+#define R_SEQ_ADD_S2A12		PHY_TO_OFF_PM_MASTER(0x56)
+#define	R_SEQ_ADD_S2A3		PHY_TO_OFF_PM_MASTER(0x57)
+#define	R_SEQ_ADD_WARM		PHY_TO_OFF_PM_MASTER(0x58)
+#define R_MEMORY_ADDRESS	PHY_TO_OFF_PM_MASTER(0x59)
+#define R_MEMORY_DATA		PHY_TO_OFF_PM_MASTER(0x5a)
+
+#define R_PROTECT_KEY		0x0E
+#define KEY_1			0xC0
+#define KEY_2			0x0C
+
+/* resource configuration registers */
+
+#define DEVGROUP_OFFSET		0
+#define TYPE_OFFSET		1
+
+/* Bit positions */
+#define DEVGROUP_SHIFT		5
+#define DEVGROUP_MASK		(7 << DEVGROUP_SHIFT)
+#define TYPE_SHIFT		0
+#define TYPE_MASK		(7 << TYPE_SHIFT)
+#define TYPE2_SHIFT		3
+#define TYPE2_MASK		(3 << TYPE2_SHIFT)
+
+static u8 res_config_addrs[] = {
+	[RES_VAUX1]	= 0x17,
+	[RES_VAUX2]	= 0x1b,
+	[RES_VAUX3]	= 0x1f,
+	[RES_VAUX4]	= 0x23,
+	[RES_VMMC1]	= 0x27,
+	[RES_VMMC2]	= 0x2b,
+	[RES_VPLL1]	= 0x2f,
+	[RES_VPLL2]	= 0x33,
+	[RES_VSIM]	= 0x37,
+	[RES_VDAC]	= 0x3b,
+	[RES_VINTANA1]	= 0x3f,
+	[RES_VINTANA2]	= 0x43,
+	[RES_VINTDIG]	= 0x47,
+	[RES_VIO]	= 0x4b,
+	[RES_VDD1]	= 0x55,
+	[RES_VDD2]	= 0x63,
+	[RES_VUSB_1V5]	= 0x71,
+	[RES_VUSB_1V8]	= 0x74,
+	[RES_VUSB_3V1]	= 0x77,
+	[RES_VUSBCP]	= 0x7a,
+	[RES_REGEN]	= 0x7f,
+	[RES_NRES_PWRON] = 0x82,
+	[RES_CLKEN]	= 0x85,
+	[RES_SYSEN]	= 0x88,
+	[RES_HFCLKOUT]	= 0x8b,
+	[RES_32KCLKOUT]	= 0x8e,
+	[RES_RESET]	= 0x91,
+	[RES_Main_Ref]	= 0x94,
+};
+
+static int __init twl4030_write_script_byte(u8 address, u8 byte)
+{
+	int err;
+
+	err = twl4030_i2c_write_u8(TWL4030_MODULE_PM_MASTER, address,
+				R_MEMORY_ADDRESS);
+	if (err)
+		goto out;
+	err = twl4030_i2c_write_u8(TWL4030_MODULE_PM_MASTER, byte,
+				R_MEMORY_DATA);
+out:
+	return err;
+}
+
+static int __init twl4030_write_script_ins(u8 address, u16 pmb_message,
+					   u8 delay, u8 next)
+{
+	int err;
+
+	address *= 4;
+	err = twl4030_write_script_byte(address++, pmb_message >> 8);
+	if (err)
+		goto out;
+	err = twl4030_write_script_byte(address++, pmb_message & 0xff);
+	if (err)
+		goto out;
+	err = twl4030_write_script_byte(address++, delay);
+	if (err)
+		goto out;
+	err = twl4030_write_script_byte(address++, next);
+out:
+	return err;
+}
+
+static int __init twl4030_write_script(u8 address, struct twl4030_ins *script,
+				       int len)
+{
+	int err;
+
+	for (; len; len--, address++, script++) {
+		if (len == 1) {
+			err = twl4030_write_script_ins(address,
+						script->pmb_message,
+						script->delay,
+						END_OF_SCRIPT);
+			if (err)
+				break;
+		} else {
+			err = twl4030_write_script_ins(address,
+						script->pmb_message,
+						script->delay,
+						address + 1);
+			if (err)
+				break;
+		}
+	}
+	return err;
+}
+
+static int __init twl4030_config_wakeup3_sequence(u8 address)
+{
+	int err;
+	u8 data;
+
+	/* Set SLEEP to ACTIVE SEQ address for P3 */
+	err = twl4030_i2c_write_u8(TWL4030_MODULE_PM_MASTER, address,
+				R_SEQ_ADD_S2A3);
+	if (err)
+		goto out;
+
+	/* P3 LVL_WAKEUP should be on LEVEL */
+	err = twl4030_i2c_read_u8(TWL4030_MODULE_PM_MASTER, &data,
+				R_P3_SW_EVENTS);
+	if (err)
+		goto out;
+	data |= LVL_WAKEUP;
+	err = twl4030_i2c_write_u8(TWL4030_MODULE_PM_MASTER, data,
+				R_P3_SW_EVENTS);
+out:
+	if (err)
+		pr_err("TWL4030 wakeup sequence for P3 config error\n");
+	return err;
+}
+
+static int __init twl4030_config_wakeup12_sequence(u8 address)
+{
+	int err = 0;
+	u8 data;
+
+	/* Set SLEEP to ACTIVE SEQ address for P1 and P2 */
+	err = twl4030_i2c_write_u8(TWL4030_MODULE_PM_MASTER, address,
+				R_SEQ_ADD_S2A12);
+	if (err)
+		goto out;
+
+	/* P1/P2 LVL_WAKEUP should be on LEVEL */
+	err = twl4030_i2c_read_u8(TWL4030_MODULE_PM_MASTER, &data,
+				R_P1_SW_EVENTS);
+	if (err)
+		goto out;
+
+	data |= LVL_WAKEUP;
+	err = twl4030_i2c_write_u8(TWL4030_MODULE_PM_MASTER, data,
+				R_P1_SW_EVENTS);
+	if (err)
+		goto out;
+
+	err = twl4030_i2c_read_u8(TWL4030_MODULE_PM_MASTER, &data,
+				R_P2_SW_EVENTS);
+	if (err)
+		goto out;
+
+	data |= LVL_WAKEUP;
+	err = twl4030_i2c_write_u8(TWL4030_MODULE_PM_MASTER, data,
+				R_P2_SW_EVENTS);
+	if (err)
+		goto out;
+
+	if (machine_is_omap_3430sdp() || machine_is_omap_ldp()) {
+		/* Disabling AC charger effect on sleep-active transitions */
+		err = twl4030_i2c_read_u8(TWL4030_MODULE_PM_MASTER, &data,
+					R_CFG_P1_TRANSITION);
+		if (err)
+			goto out;
+		data &= ~(1<<1);
+		err = twl4030_i2c_write_u8(TWL4030_MODULE_PM_MASTER, data ,
+					R_CFG_P1_TRANSITION);
+		if (err)
+			goto out;
+	}
+
+out:
+	if (err)
+		pr_err("TWL4030 wakeup sequence for P1 and P2" \
+			"config error\n");
+	return err;
+}
+
+static int __init twl4030_config_sleep_sequence(u8 address)
+{
+	int err;
+
+	/* Set ACTIVE to SLEEP SEQ address in T2 memory*/
+	err = twl4030_i2c_write_u8(TWL4030_MODULE_PM_MASTER, address,
+				R_SEQ_ADD_A2S);
+
+	if (err)
+		pr_err("TWL4030 sleep sequence config error\n");
+
+	return err;
+}
+
+static int __init twl4030_config_warmreset_sequence(u8 address)
+{
+	int err;
+	u8 rd_data;
+
+	/* Set WARM RESET SEQ address for P1 */
+	err = twl4030_i2c_write_u8(TWL4030_MODULE_PM_MASTER, address,
+				R_SEQ_ADD_WARM);
+	if (err)
+		goto out;
+
+	/* P1/P2/P3 enable WARMRESET */
+	err = twl4030_i2c_read_u8(TWL4030_MODULE_PM_MASTER, &rd_data,
+				R_P1_SW_EVENTS);
+	if (err)
+		goto out;
+
+	rd_data |= ENABLE_WARMRESET;
+	err = twl4030_i2c_write_u8(TWL4030_MODULE_PM_MASTER, rd_data,
+				R_P1_SW_EVENTS);
+	if (err)
+		goto out;
+
+	err = twl4030_i2c_read_u8(TWL4030_MODULE_PM_MASTER, &rd_data,
+				R_P2_SW_EVENTS);
+	if (err)
+		goto out;
+
+	rd_data |= ENABLE_WARMRESET;
+	err = twl4030_i2c_write_u8(TWL4030_MODULE_PM_MASTER, rd_data,
+				R_P2_SW_EVENTS);
+	if (err)
+		goto out;
+
+	err = twl4030_i2c_read_u8(TWL4030_MODULE_PM_MASTER, &rd_data,
+				R_P3_SW_EVENTS);
+	if (err)
+		goto out;
+
+	rd_data |= ENABLE_WARMRESET;
+	err = twl4030_i2c_write_u8(TWL4030_MODULE_PM_MASTER, rd_data,
+				R_P3_SW_EVENTS);
+out:
+	if (err)
+		pr_err("TWL4030 warmreset seq config error\n");
+	return err;
+}
+
+static int __init twl4030_configure_resource(struct twl4030_resconfig *rconfig)
+{
+	int rconfig_addr;
+	int err;
+	u8 type;
+	u8 grp;
+
+	if (rconfig->resource > TOTAL_RESOURCES) {
+		pr_err("TWL4030 Resource %d does not exist\n",
+			rconfig->resource);
+		return -EINVAL;
+	}
+
+	rconfig_addr = res_config_addrs[rconfig->resource];
+
+	/* Set resource group */
+	err = twl4030_i2c_read_u8(TWL4030_MODULE_PM_RECEIVER, &grp,
+				rconfig_addr + DEVGROUP_OFFSET);
+	if (err) {
+		pr_err("TWL4030 Resource %d group could not be read\n",
+			rconfig->resource);
+		return err;
+	}
+
+	if (rconfig->devgroup >= 0) {
+		grp &= ~DEVGROUP_MASK;
+		grp |= rconfig->devgroup << DEVGROUP_SHIFT;
+		err = twl4030_i2c_write_u8(TWL4030_MODULE_PM_RECEIVER,
+					grp, rconfig_addr + DEVGROUP_OFFSET);
+		if (err < 0) {
+			pr_err("TWL4030 failed to program devgroup\n");
+			return err;
+		}
+	}
+
+	/* Set resource types */
+	err = twl4030_i2c_read_u8(TWL4030_MODULE_PM_RECEIVER, &type,
+				rconfig_addr + TYPE_OFFSET);
+	if (err < 0) {
+		pr_err("TWL4030 Resource %d type could not be read\n",
+			rconfig->resource);
+		return err;
+	}
+
+	if (rconfig->type >= 0) {
+		type &= ~TYPE_MASK;
+		type |= rconfig->type << TYPE_SHIFT;
+	}
+
+	if (rconfig->type2 >= 0) {
+		type &= ~TYPE2_MASK;
+		type |= rconfig->type2 << TYPE2_SHIFT;
+	}
+
+	err = twl4030_i2c_write_u8(TWL4030_MODULE_PM_RECEIVER,
+				type, rconfig_addr + TYPE_OFFSET);
+	if (err < 0) {
+		pr_err("TWL4030 failed to program resource type\n");
+		return err;
+	}
+
+	return 0;
+}
+
+static int __init load_twl4030_script(struct twl4030_script *tscript,
+	       u8 address)
+{
+	int err;
+
+	/* Make sure the script isn't going beyond last valid address (0x3f) */
+	if ((address + tscript->size) > END_OF_SCRIPT) {
+		pr_err("TWL4030 scripts too big error\n");
+		return -EINVAL;
+	}
+
+	err = twl4030_write_script(address, tscript->script, tscript->size);
+	if (err)
+		goto out;
+
+	if (tscript->flags & TWL4030_WRST_SCRIPT) {
+		err = twl4030_config_warmreset_sequence(address);
+		if (err)
+			goto out;
+	}
+	if (tscript->flags & TWL4030_WAKEUP12_SCRIPT) {
+		err = twl4030_config_wakeup12_sequence(address);
+		if (err)
+			goto out;
+	}
+	if (tscript->flags & TWL4030_WAKEUP3_SCRIPT) {
+		err = twl4030_config_wakeup3_sequence(address);
+		if (err)
+			goto out;
+	}
+	if (tscript->flags & TWL4030_SLEEP_SCRIPT)
+		err = twl4030_config_sleep_sequence(address);
+out:
+	return err;
+}
+
+void __init twl4030_power_init(struct twl4030_power_data *twl4030_scripts)
+{
+	int err = 0;
+	int i;
+	struct twl4030_resconfig *resconfig;
+	u8 address = twl4030_start_script_address;
+
+	err = twl4030_i2c_write_u8(TWL4030_MODULE_PM_MASTER, KEY_1,
+				R_PROTECT_KEY);
+	if (err)
+		goto unlock;
+
+	err = twl4030_i2c_write_u8(TWL4030_MODULE_PM_MASTER, KEY_2,
+				R_PROTECT_KEY);
+	if (err)
+		goto unlock;
+
+	for (i = 0; i < twl4030_scripts->num; i++) {
+		err = load_twl4030_script(twl4030_scripts->scripts[i], address);
+		if (err)
+			goto load;
+		address += twl4030_scripts->scripts[i]->size;
+	}
+
+	resconfig = twl4030_scripts->resource_config;
+	if (resconfig) {
+		while (resconfig->resource) {
+			err = twl4030_configure_resource(resconfig);
+			if (err)
+				goto resource;
+			resconfig++;
+
+		}
+	}
+
+	err = twl4030_i2c_write_u8(TWL4030_MODULE_PM_MASTER, 0, R_PROTECT_KEY);
+	if (err)
+		pr_err("TWL4030 Unable to relock registers\n");
+	return;
+
+unlock:
+	if (err)
+		pr_err("TWL4030 Unable to unlock registers\n");
+	return;
+load:
+	if (err)
+		pr_err("TWL4030 failed to load scripts\n");
+	return;
+resource:
+	if (err)
+		pr_err("TWL4030 failed to configure resource\n");
+	return;
+}
diff --git a/include/linux/i2c/twl4030.h b/include/linux/i2c/twl4030.h
index 0dc80ef..d0c24ad 100644
--- a/include/linux/i2c/twl4030.h
+++ b/include/linux/i2c/twl4030.h
@@ -220,19 +220,28 @@ int twl4030_i2c_read(u8 mod_no, u8 *value, u8 reg, unsigned num_bytes);
 
 /* Power bus message definitions */
 
-#define DEV_GRP_NULL		0x0
-#define DEV_GRP_P1		0x1
-#define DEV_GRP_P2		0x2
-#define DEV_GRP_P3		0x4
+/* The TWL4030/5030 splits its power-management resources (the various
+ * regulators, clock and reset lines) into 3 processor groups - P1, P2 and
+ * P3. These groups can then be configured to transition between sleep, wait-on
+ * and active states by sending messages to the power bus.  See Section 5.4.2
+ * Power Resources of TWL4030 TRM
+ */
 
-#define RES_GRP_RES		0x0
-#define RES_GRP_PP		0x1
-#define RES_GRP_RC		0x2
+/* Processor groups */
+#define DEV_GRP_NULL		0x0
+#define DEV_GRP_P1		0x1	/* P1: all OMAP devices */
+#define DEV_GRP_P2		0x2	/* P2: all Modem devices */
+#define DEV_GRP_P3		0x4	/* P3: all peripheral devices */
+
+/* Resource groups */
+#define RES_GRP_RES		0x0	/* Reserved */
+#define RES_GRP_PP		0x1	/* Power providers */
+#define RES_GRP_RC		0x2	/* Reset and control */
 #define RES_GRP_PP_RC		0x3
-#define RES_GRP_PR		0x4
+#define RES_GRP_PR		0x4	/* Power references */
 #define RES_GRP_PP_PR		0x5
 #define RES_GRP_RC_PR		0x6
-#define RES_GRP_ALL		0x7
+#define RES_GRP_ALL		0x7	/* All resource groups */
 
 #define RES_TYPE2_R0		0x0
 
@@ -243,6 +252,41 @@ int twl4030_i2c_read(u8 mod_no, u8 *value, u8 reg, unsigned num_bytes);
 #define RES_STATE_SLEEP		0x8
 #define RES_STATE_OFF		0x0
 
+/* Power resources */
+
+/* Power providers */
+#define RES_VAUX1               1
+#define RES_VAUX2               2
+#define RES_VAUX3               3
+#define RES_VAUX4               4
+#define RES_VMMC1               5
+#define RES_VMMC2               6
+#define RES_VPLL1               7
+#define RES_VPLL2               8
+#define RES_VSIM                9
+#define RES_VDAC                10
+#define RES_VINTANA1            11
+#define RES_VINTANA2            12
+#define RES_VINTDIG             13
+#define RES_VIO                 14
+#define RES_VDD1                15
+#define RES_VDD2                16
+#define RES_VUSB_1V5            17
+#define RES_VUSB_1V8            18
+#define RES_VUSB_3V1            19
+#define RES_VUSBCP              20
+#define RES_REGEN               21
+/* Reset and control */
+#define RES_NRES_PWRON          22
+#define RES_CLKEN               23
+#define RES_SYSEN               24
+#define RES_HFCLKOUT            25
+#define RES_32KCLKOUT           26
+#define RES_RESET               27
+/* Power Reference */
+#define RES_Main_Ref            28
+
+#define TOTAL_RESOURCES		28
 /*
  * Power Bus Message Format ... these can be sent individually by Linux,
  * but are usually part of downloaded scripts that are run when various
@@ -320,6 +364,36 @@ struct twl4030_usb_data {
 	enum twl4030_usb_mode	usb_mode;
 };
 
+struct twl4030_ins {
+	u16 pmb_message;
+	u8 delay;
+};
+
+struct twl4030_script {
+	struct twl4030_ins *script;
+	unsigned size;
+	u8 flags;
+#define TWL4030_WRST_SCRIPT	(1<<0)
+#define TWL4030_WAKEUP12_SCRIPT	(1<<1)
+#define TWL4030_WAKEUP3_SCRIPT	(1<<2)
+#define TWL4030_SLEEP_SCRIPT	(1<<3)
+};
+
+struct twl4030_resconfig {
+	u8 resource;
+	u8 devgroup;	/* Processor group that Power resource belongs to */
+	u8 type;	/* Power resource addressed, 6 / broadcast message */
+	u8 type2;	/* Power resource addressed, 3 / broadcast message */
+};
+
+struct twl4030_power_data {
+	struct twl4030_script **scripts;
+	unsigned num;
+	struct twl4030_resconfig *resource_config;
+};
+
+extern void twl4030_power_init(struct twl4030_power_data *triton2_scripts);
+
 struct twl4030_platform_data {
 	unsigned				irq_base, irq_end;
 	struct twl4030_bci_platform_data	*bci;
@@ -327,6 +401,7 @@ struct twl4030_platform_data {
 	struct twl4030_madc_platform_data	*madc;
 	struct twl4030_keypad_data		*keypad;
 	struct twl4030_usb_data			*usb;
+	struct twl4030_power_data		*power;
 
 	/* LDO regulators */
 	struct regulator_init_data		*vdac;
@@ -357,7 +432,6 @@ int twl4030_sih_setup(int module);
 #define TWL4030_VAUX3_DEV_GRP		0x1F
 #define TWL4030_VAUX3_DEDICATED		0x22
 
-
 #if defined(CONFIG_TWL4030_BCI_BATTERY) || \
 	defined(CONFIG_TWL4030_BCI_BATTERY_MODULE)
 	extern int twl4030charger_usb_en(int enable);
-- 
1.6.3.3

