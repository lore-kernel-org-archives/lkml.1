Return-Path: <linux-kernel-owner+w=401wt.eu-S1755477AbZFXJIS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755477AbZFXJIS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jun 2009 05:08:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753395AbZFXJIE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Jun 2009 05:08:04 -0400
Received: from smtp.nokia.com ([192.100.122.233]:57827 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752735AbZFXJH7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jun 2009 05:07:59 -0400
From: Amit Kucheria <amit.kucheria@verdurent.com>
To: linux-kernel@vger.kernel.org
Cc: sameo@linux.intel.com, dbrownell@users.sourceforge.net,
       linux-omap@vger.kernel.org
Subject: [PATCH 1/3] TWL4030: power: Add support for TWL4030/5030 dynamic power switching
Date: Wed, 24 Jun 2009 12:07:48 +0300
Message-Id: <1245834468-7933-1-git-send-email-amit.kucheria@verdurent.com>
X-Mailer: git-send-email 1.6.3.1
In-Reply-To: <1245834390-7904-1-git-send-email-amit.kucheria@verdurent.com>
References: <1245834390-7904-1-git-send-email-amit.kucheria@verdurent.com>
X-OriginalArrivalTime: 24 Jun 2009 09:07:52.0465 (UTC) FILETIME=[410BD810:01C9F4AB]
X-Nokia-AV: Clean
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
---
 drivers/mfd/Kconfig         |   13 ++
 drivers/mfd/Makefile        |    1 +
 drivers/mfd/twl4030-core.c  |   26 +++
 drivers/mfd/twl4030-power.c |  389 +++++++++++++++++++++++++++++++++++++++++++
 include/linux/i2c/twl4030.h |   91 +++++++++-
 5 files changed, 510 insertions(+), 10 deletions(-)
 create mode 100644 drivers/mfd/twl4030-power.c

diff --git a/drivers/mfd/Kconfig b/drivers/mfd/Kconfig
index ee3927a..502c116 100644
--- a/drivers/mfd/Kconfig
+++ b/drivers/mfd/Kconfig
@@ -107,6 +107,19 @@ config TWL4030_CORE
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
index 3afb519..44a0053 100644
--- a/drivers/mfd/Makefile
+++ b/drivers/mfd/Makefile
@@ -23,6 +23,7 @@ obj-$(CONFIG_TPS65010)		+= tps65010.o
 obj-$(CONFIG_MENELAUS)		+= menelaus.o
 
 obj-$(CONFIG_TWL4030_CORE)	+= twl4030-core.o twl4030-irq.o
+obj-$(CONFIG_TWL4030_POWER)    += twl4030-power.o
 
 obj-$(CONFIG_MFD_CORE)		+= mfd-core.o
 
diff --git a/drivers/mfd/twl4030-core.c b/drivers/mfd/twl4030-core.c
index ec90e95..30d1179 100644
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
@@ -102,6 +108,13 @@
 #endif
 
 
+#if defined(CONFIG_INPUT_TWL4030_PWRBUTTON) \
+	|| defined(CONFIG_INPUT_TWL4030_PWBUTTON_MODULE)
+#define twl_has_pwrbutton()	true
+#else
+#define twl_has_pwrbutton()	false
+#endif
+
 /* Triton Core internal information (BEGIN) */
 
 /* Last - for index max*/
@@ -225,6 +238,8 @@ static struct twl4030mapping twl4030_map[TWL4030_MODULE_LAST + 1] = {
 	{ 3, TWL4030_BASEADD_SECURED_REG },
 };
 
+extern void twl4030_power_init(struct twl4030_power_data *triton2_scripts);
+
 /*----------------------------------------------------------------------*/
 
 /* Exported Functions */
@@ -526,6 +541,13 @@ add_children(struct twl4030_platform_data *pdata, unsigned long features)
 		usb_transceiver = child;
 	}
 
+	if (twl_has_pwrbutton()) {
+		child = add_child(1, "twl4030_pwrbutton",
+				NULL, 0, true, pdata->irq_base + 8 + 0, 0);
+		if (IS_ERR(child))
+			return PTR_ERR(child);
+	}
+
 	if (twl_has_regulator()) {
 		/*
 		child = add_regulator(TWL4030_REG_VPLL1, pdata->vpll1);
@@ -776,6 +798,10 @@ twl4030_probe(struct i2c_client *client, const struct i2c_device_id *id)
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
index 0000000..75dd814
--- /dev/null
+++ b/drivers/mfd/twl4030-power.c
@@ -0,0 +1,389 @@
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
+static u8 triton_next_free_address = 0x2b;
+
+#define PWR_P1_SW_EVENTS	0x10
+#define PWR_DEVOFF	(1<<0)
+
+#define PHY_TO_OFF_PM_MASTER(p)		(p - 0x36)
+#define PHY_TO_OFF_PM_RECEIVER(p)	(p - 0x5b)
+
+#define NUM_OF_RESOURCES	28
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
+					R_MEMORY_ADDRESS);
+	err |= twl4030_i2c_write_u8(TWL4030_MODULE_PM_MASTER, byte,
+					R_MEMORY_DATA);
+
+	return err;
+}
+
+static int __init twl4030_write_script_ins(u8 address, u16 pmb_message,
+						u8 delay, u8 next)
+{
+	int err = 0;
+
+	address *= 4;
+	err |= twl4030_write_script_byte(address++, pmb_message >> 8);
+	err |= twl4030_write_script_byte(address++, pmb_message & 0xff);
+	err |= twl4030_write_script_byte(address++, delay);
+	err |= twl4030_write_script_byte(address++, next);
+
+	return err;
+}
+
+static int __init twl4030_write_script(u8 address, struct twl4030_ins *script,
+					int len)
+{
+	int err = 0;
+
+	for (; len; len--, address++, script++) {
+		if (len == 1)
+			err |= twl4030_write_script_ins(address,
+							script->pmb_message,
+							script->delay,
+							END_OF_SCRIPT);
+		else
+			err |= twl4030_write_script_ins(address,
+							script->pmb_message,
+							script->delay,
+							address + 1);
+	}
+
+	return err;
+}
+
+static int __init config_wakeup3_sequence(u8 address)
+{
+
+	int err = 0;
+
+	/* Set SLEEP to ACTIVE SEQ address for P3 */
+	err |= twl4030_i2c_write_u8(TWL4030_MODULE_PM_MASTER, address,
+				  R_SEQ_ADD_S2A3);
+
+	err |= twl4030_i2c_write_u8(TWL4030_MODULE_PM_MASTER, LVL_WAKEUP,
+					R_P3_SW_EVENTS);
+	if (err)
+		printk(KERN_ERR "TWL4030 wakeup sequence for P3" \
+				"config error\n");
+
+	return err;
+}
+
+static int __init config_wakeup12_sequence(u8 address)
+{
+	int err = 0;
+
+	/* Set SLEEP to ACTIVE SEQ address for P1 and P2 */
+	err |= twl4030_i2c_write_u8(TWL4030_MODULE_PM_MASTER, address,
+				  R_SEQ_ADD_S2A12);
+
+	/* P1/P2/P3 LVL_WAKEUP should be on LEVEL */
+	err |= twl4030_i2c_write_u8(TWL4030_MODULE_PM_MASTER, LVL_WAKEUP,
+					R_P1_SW_EVENTS);
+	err |= twl4030_i2c_write_u8(TWL4030_MODULE_PM_MASTER, LVL_WAKEUP,
+					R_P2_SW_EVENTS);
+
+	if (machine_is_omap_3430sdp() || machine_is_omap_ldp()) {
+		u8 data;
+		/* Disabling AC charger effect on sleep-active transitions */
+		err |= twl4030_i2c_read_u8(TWL4030_MODULE_PM_MASTER, &data,
+						R_CFG_P1_TRANSITION);
+		data &= ~(1<<1);
+		err |= twl4030_i2c_write_u8(TWL4030_MODULE_PM_MASTER, data ,
+						R_CFG_P1_TRANSITION);
+	}
+
+	if (err)
+		printk(KERN_ERR "TWL4030 wakeup sequence for P1 and P2" \
+				"config error\n");
+
+	return err;
+}
+
+static int __init config_sleep_sequence(u8 address)
+{
+	int err = 0;
+
+	/*
+	 * CLKREQ is pulled high on the 2430SDP, therefore, we need to take
+	 * it out of the HFCLKOUT DEV_GRP for P1 else HFCLKOUT can't be stopped.
+	 */
+
+	err |= twl4030_i2c_write_u8(TWL4030_MODULE_PM_RECEIVER,
+				  0x20, R_HFCLKOUT_DEV_GRP);
+
+	/* Set ACTIVE to SLEEP SEQ address in T2 memory*/
+	err |= twl4030_i2c_write_u8(TWL4030_MODULE_PM_MASTER, address,
+				  R_SEQ_ADD_A2S);
+
+	if (err)
+		printk(KERN_ERR "TWL4030 sleep sequence config error\n");
+
+	return err;
+}
+
+static int __init config_warmreset_sequence(u8 address)
+{
+
+	int err = 0;
+	u8 rd_data;
+
+	/* Set WARM RESET SEQ address for P1 */
+	err |= twl4030_i2c_write_u8(TWL4030_MODULE_PM_MASTER, address,
+					R_SEQ_ADD_WARM);
+
+	/* P1/P2/P3 enable WARMRESET */
+	err |= twl4030_i2c_read_u8(TWL4030_MODULE_PM_MASTER, &rd_data,
+					R_P1_SW_EVENTS);
+	rd_data |= ENABLE_WARMRESET;
+	err |= twl4030_i2c_write_u8(TWL4030_MODULE_PM_MASTER, rd_data,
+					R_P1_SW_EVENTS);
+
+	err |= twl4030_i2c_read_u8(TWL4030_MODULE_PM_MASTER, &rd_data,
+					R_P2_SW_EVENTS);
+	rd_data |= ENABLE_WARMRESET;
+	err |= twl4030_i2c_write_u8(TWL4030_MODULE_PM_MASTER, rd_data,
+					R_P2_SW_EVENTS);
+
+	err |= twl4030_i2c_read_u8(TWL4030_MODULE_PM_MASTER, &rd_data,
+					R_P3_SW_EVENTS);
+	rd_data |= ENABLE_WARMRESET;
+	err |= twl4030_i2c_write_u8(TWL4030_MODULE_PM_MASTER, rd_data,
+					R_P3_SW_EVENTS);
+
+	if (err)
+		printk(KERN_ERR
+			"TWL4030 warmreset seq config error\n");
+	return err;
+}
+
+static int __init twl4030_configure_resource(struct twl4030_resconfig *rconfig)
+{
+	int rconfig_addr;
+	int err;
+	u8 type;
+
+	if (rconfig->resource > NUM_OF_RESOURCES) {
+		printk(KERN_ERR
+			"TWL4030 Resource %d does not exist\n",
+			rconfig->resource);
+		return -EINVAL;
+	}
+
+	rconfig_addr = res_config_addrs[rconfig->resource];
+
+	/* Set resource group */
+	if (rconfig->devgroup >= 0)
+		err = twl4030_i2c_write_u8(TWL4030_MODULE_PM_RECEIVER,
+					rconfig->devgroup << 5,
+					rconfig_addr + DEVGROUP_OFFSET);
+	if (err < 0) {
+		printk(KERN_ERR
+		       "TWL4030 failed to program devgroup");
+		return err;
+	}
+
+	/* Set resource types */
+	err = twl4030_i2c_read_u8(TWL4030_MODULE_PM_RECEIVER, &type,
+				  rconfig_addr + TYPE_OFFSET);
+	if (err < 0) {
+		printk(KERN_ERR
+		       "TWL4030 Resource %d type could not be read\n",
+		       rconfig->resource);
+		return err;
+	}
+
+	if (rconfig->type >= 0) {
+		type &= ~7;
+		type |= rconfig->type;
+	}
+
+	if (rconfig->type2 >= 0) {
+		type &= ~(3 << 3);
+		type |= rconfig->type2 << 3;
+	}
+
+	err = twl4030_i2c_write_u8(TWL4030_MODULE_PM_RECEIVER,
+				type, rconfig_addr + TYPE_OFFSET);
+	if (err < 0) {
+		printk(KERN_ERR
+		       "TWL4030 failed to program resource type");
+		return err;
+	}
+
+	return 0;
+
+}
+
+static int __init load_triton_script(struct twl4030_script *tscript)
+{
+	u8 address = triton_next_free_address;
+	int err;
+
+	/* Make sure the script isn't going beyond last valid address */
+	if ((address + tscript->size) > (END_OF_SCRIPT-1)) {
+		printk(KERN_ERR "TWL4030 script too big error\n");
+		return -EINVAL;
+	}
+
+	err = twl4030_write_script(address, tscript->script, tscript->size);
+	if (err)
+		return err;
+
+	triton_next_free_address += tscript->size;
+
+	if (tscript->flags & TRITON_WRST_SCRIPT)
+		err |= config_warmreset_sequence(address);
+
+	if (tscript->flags & TRITON_WAKEUP12_SCRIPT)
+		err |= config_wakeup12_sequence(address);
+
+	if (tscript->flags & TRITON_WAKEUP3_SCRIPT)
+		err |= config_wakeup3_sequence(address);
+
+	if (tscript->flags & TRITON_SLEEP_SCRIPT)
+		err |= config_sleep_sequence(address);
+
+	return err;
+}
+
+void __init twl4030_power_init(struct twl4030_power_data *triton2_scripts)
+{
+	int err = 0;
+	int i;
+	struct twl4030_resconfig *resconfig;
+
+	err = twl4030_i2c_write_u8(TWL4030_MODULE_PM_MASTER, KEY_1,
+				R_PROTECT_KEY);
+	err |= twl4030_i2c_write_u8(TWL4030_MODULE_PM_MASTER, KEY_2,
+				R_PROTECT_KEY);
+	if (err)
+		printk(KERN_ERR
+			"TWL4030 Unable to unlock registers\n");
+
+	for (i = 0; i < triton2_scripts->size; i++) {
+		err = load_triton_script(triton2_scripts->scripts[i]);
+		if (err < 0) {
+			printk(KERN_ERR "TWL4030 failed to load scripts");
+			break;
+		}
+	}
+
+	resconfig = triton2_scripts->resource_config;
+	if (resconfig) {
+		while (resconfig->resource) {
+			err = twl4030_configure_resource(resconfig);
+			resconfig++;
+			if (err < 0) {
+				printk(KERN_ERR
+				       "TWL4030 failed to configure resource");
+				break;
+			}
+		}
+	}
+
+	if (twl4030_i2c_write_u8(TWL4030_MODULE_PM_MASTER, 0, R_PROTECT_KEY))
+		printk(KERN_ERR
+			"TWL4030 Unable to relock registers\n");
+}
diff --git a/include/linux/i2c/twl4030.h b/include/linux/i2c/twl4030.h
index 0dc80ef..15edfaa 100644
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
 
@@ -243,6 +252,40 @@ int twl4030_i2c_read(u8 mod_no, u8 *value, u8 reg, unsigned num_bytes);
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
 /*
  * Power Bus Message Format ... these can be sent individually by Linux,
  * but are usually part of downloaded scripts that are run when various
@@ -320,6 +363,34 @@ struct twl4030_usb_data {
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
+#define TRITON_WRST_SCRIPT	(1<<0)
+#define TRITON_WAKEUP12_SCRIPT	(1<<1)
+#define TRITON_WAKEUP3_SCRIPT	(1<<2)
+#define TRITON_SLEEP_SCRIPT	(1<<3)
+};
+
+struct twl4030_resconfig {
+	u8 resource;
+	u8 devgroup;
+	u8 type;
+	u8 type2;
+};
+
+struct twl4030_power_data {
+	struct twl4030_script **scripts;
+	unsigned size;
+	const struct twl4030_resconfig *resource_config;
+};
+
 struct twl4030_platform_data {
 	unsigned				irq_base, irq_end;
 	struct twl4030_bci_platform_data	*bci;
@@ -327,6 +398,7 @@ struct twl4030_platform_data {
 	struct twl4030_madc_platform_data	*madc;
 	struct twl4030_keypad_data		*keypad;
 	struct twl4030_usb_data			*usb;
+	struct twl4030_power_data		*power;
 
 	/* LDO regulators */
 	struct regulator_init_data		*vdac;
@@ -357,7 +429,6 @@ int twl4030_sih_setup(int module);
 #define TWL4030_VAUX3_DEV_GRP		0x1F
 #define TWL4030_VAUX3_DEDICATED		0x22
 
-
 #if defined(CONFIG_TWL4030_BCI_BATTERY) || \
 	defined(CONFIG_TWL4030_BCI_BATTERY_MODULE)
 	extern int twl4030charger_usb_en(int enable);
-- 
1.6.3.1

