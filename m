Return-Path: <linux-kernel-owner+w=401wt.eu-S1753715AbZGTNhQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753715AbZGTNhQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jul 2009 09:37:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751054AbZGTNhO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Jul 2009 09:37:14 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:33900 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750847AbZGTNhK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jul 2009 09:37:10 -0400
From: balajitk@ti.com
To: linux-kernel@vger.kernel.org
Cc: tony@atomide.com, khilman@deeprootsystems.com, david-b@pacbell.net,
       linux-omap@vger.kernel.org, linux-i2c@vger.kernel.org,
       sameo@openedhand.com, wim@iguana.be, timo.t.kokkonen@nokia.com,
       ben-linux@fluff.org, lrg@slimlogic.co.uk,
       broonie@opensource.wolfsonmicro.com, Balaji T K <balajitk@ti.com>,
       Rajendra Nayak <rnayak@ti.com>,
       Santosh Shilimkar <santosh.shilimkar@ti.com>
Subject: [RFC][PATCH 1/4] OMAP4: PMIC: Add support for twl6030 irq framework
Date: Mon, 20 Jul 2009 19:06:32 +0530
Message-Id: <1248096992-14610-1-git-send-email-balajitk@ti.com>
X-Mailer: git-send-email 1.5.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Balaji T K <balajitk@ti.com>

This patch adds support for phoenix interrupt framework. New Interrupt status
register A, B, C are introduced in Phoenix and are cleared on write.
Due to difference in interrupt handling with respect to TWL4030,
twl6030-irq.c is created for TWL6030 PMIC

Signed-off-by: Rajendra Nayak <rnayak@ti.com>
Signed-off-by: Balaji T K <balajitk@ti.com>
Signed-off-by: Santosh Shilimkar <santosh.shilimkar@ti.com>
---
 arch/arm/plat-omap/include/mach/irqs.h |   12 ++
 drivers/mfd/Kconfig                    |   13 ++
 drivers/mfd/Makefile                   |    1 +
 drivers/mfd/twl-core.c                 |   97 +++++++++--
 drivers/mfd/twl6030-irq.c              |  301 ++++++++++++++++++++++++++++++++
 include/linux/i2c/twl.h                |  124 +++++++++++++-
 6 files changed, 531 insertions(+), 17 deletions(-)
 create mode 100644 drivers/mfd/twl6030-irq.c

diff --git a/arch/arm/plat-omap/include/mach/irqs.h b/arch/arm/plat-omap/include/mach/irqs.h
index fb7cb77..009cf4d 100644
--- a/arch/arm/plat-omap/include/mach/irqs.h
+++ b/arch/arm/plat-omap/include/mach/irqs.h
@@ -551,8 +551,20 @@
 #endif
 #define TWL4030_GPIO_IRQ_END	(TWL4030_GPIO_IRQ_BASE + TWL4030_GPIO_NR_IRQS)
 
+#define	TWL6030_IRQ_BASE	(OMAP_FPGA_IRQ_END)
+#ifdef CONFIG_TWL6030_CORE
+#define	TWL6030_BASE_NR_IRQS	20
+#else
+#define	TWL6030_BASE_NR_IRQS	0
+#endif
+#define TWL6030_IRQ_END		(TWL6030_IRQ_BASE + TWL6030_BASE_NR_IRQS)
+
 /* Total number of interrupts depends on the enabled blocks above */
+#ifdef CONFIG_TWL4030_CORE
 #define NR_IRQS			TWL4030_GPIO_IRQ_END
+#else
+#define NR_IRQS			TWL6030_IRQ_END
+#endif
 
 #define OMAP_IRQ_BIT(irq)	(1 << ((irq) % 32))
 
diff --git a/drivers/mfd/Kconfig b/drivers/mfd/Kconfig
index 491ac0f..3eec1ac 100644
--- a/drivers/mfd/Kconfig
+++ b/drivers/mfd/Kconfig
@@ -108,6 +108,19 @@ config TWL4030_CORE
 	  high speed USB OTG transceiver, an audio codec (on most
 	  versions) and many other features.
 
+config TWL6030_CORE
+	bool "Texas Instruments TWL6030 Support"
+	depends on I2C=y && GENERIC_HARDIRQS
+	depends on !TWL4030_CORE
+	help
+	  Say yes here if you have TWL6030 family chip on your board.
+	  This core driver provides register access and IRQ handling
+	  facilities, and registers devices for the various functions
+	  so that function-specific drivers can bind to them.
+
+	  These multi-function chips are meant for OMAP4 processors,
+	  providing power management, RTC, a USB transciever and a GPADC.
+
 config MFD_TMIO
 	bool
 	default n
diff --git a/drivers/mfd/Makefile b/drivers/mfd/Makefile
index 4e9d513..17c533d 100644
--- a/drivers/mfd/Makefile
+++ b/drivers/mfd/Makefile
@@ -23,6 +23,7 @@ obj-$(CONFIG_TPS65010)		+= tps65010.o
 obj-$(CONFIG_MENELAUS)		+= menelaus.o
 
 obj-$(CONFIG_TWL4030_CORE)	+= twl-core.o twl4030-irq.o
+obj-$(CONFIG_TWL6030_CORE)	+= twl-core.o twl6030-irq.o
 
 obj-$(CONFIG_MFD_CORE)		+= mfd-core.o
 
diff --git a/drivers/mfd/twl-core.c b/drivers/mfd/twl-core.c
index f40768b..7ee7a1e 100644
--- a/drivers/mfd/twl-core.c
+++ b/drivers/mfd/twl-core.c
@@ -130,7 +130,7 @@
 #define TWL4030_MODULE_LAST		TWL4030_MODULE_SECURED_REG
 #define TWL_MODULE_LAST TWL4030_MODULE_LAST
 
-/* Base Address defns for twl4030_map[] */
+/* Base Address defns for twl_map[] */
 
 /* subchip/slave 0 - USB ID */
 #define TWL4030_BASEADD_USB		0x0000
@@ -165,6 +165,47 @@
 /* Triton Core internal information (END) */
 
 
+#ifdef CONFIG_TWL6030_CORE
+#define TWL6030_MODULE_LAST TWL6030_MODULE_AUDIO
+#define TWL_MODULE_LAST TWL6030_MODULE_LAST
+
+#define RTC_SUB_CHIP_ID		SUB_CHIP_ID0
+#define REG_SUB_CHIP_ID		SUB_CHIP_ID0
+#define USB_SUB_CHIP_ID		SUB_CHIP_ID1
+#define MADC_SUB_CHIP_ID	SUB_CHIP_ID1
+#define BCI_SUB_CHIP_ID		SUB_CHIP_ID1
+#define GPIO_SUB_CHIP_ID	0 /* NOT SUPPORTED IN TWL6030 */
+#define KEYPAD_SUB_CHIP_ID	0 /* ADDED FOR COMPILATION ONLY */
+
+/* subchip/slave 0 0x48 - POWER */
+#define TWL6030_BASEADD_RTC		0x0000
+#define TWL6030_BASEADD_MEM		0x0017
+#define TWL6030_BASEADD_PM_MASTER	0x001F
+#define TWL6030_BASEADD_PM_SLAVE_MISC	0x0030
+#define TWL6030_BASEADD_PM_SLAVE_SMPS	0x0040
+#define TWL6030_BASEADD_PM_SLAVE_LDO	0x0080
+#define TWL6030_BASEADD_PM_SLAVE_RES	0x00AD
+#define TWL6030_BASEADD_PM_MISC		0x00E3
+#define TWL6030_BASEADD_PM_PUPD		0x00F0
+
+/* subchip/slave 1 0x49 - FEATURE */
+#define TWL6030_BASEADD_USB		0x0000
+#define TWL6030_BASEADD_GPADC_CTRL	0x0030
+#define TWL6030_BASEADD_GPADC_RT	0x0035
+#define TWL6030_BASEADD_GPADC		0x005D
+#define TWL6030_BASEADD_AUX		0x0090
+#define TWL6030_BASEADD_PWM		0x00BA
+#define TWL6030_BASEADD_GASGAUGE	0x00C0
+#define TWL6030_BASEADD_PIH		0x00D0
+#define TWL6030_BASEADD_CHARGER		0x00E0
+
+/* subchip/slave 2 0x4A - DFT */
+#define TWL6030_BASEADD_DIEID		0x00C0
+
+/* subchip/slave 3 0x4B - AUDIO */
+#define TWL6030_BASEADD_AUDIO		0x0000
+#endif /* CONFIG_TWL6030_CORE */
+
 /* Few power values */
 #define R_CFG_BOOT			0x05
 #define R_PROTECT_KEY			0x0E
@@ -190,7 +231,7 @@
 /* is driver active, bound to a chip? */
 static bool inuse;
 
-/* Structure for each TWL4030 Slave */
+/* Structure for each TWL4030/TWL6030 Slave */
 struct twl_client {
 	struct i2c_client *client;
 	u8 address;
@@ -212,7 +253,7 @@ struct twl_mapping {
 };
 
 #ifdef CONFIG_TWL4030_CORE
-static struct twl_mapping twl4030_map[TWL4030_MODULE_LAST + 1] = {
+static struct twl_mapping twl_map[TWL4030_MODULE_LAST + 1] = {
 	/*
 	 * NOTE:  don't change this table without updating the
 	 * <linux/i2c/twl4030.h> defines for TWL4030_MODULE_*
@@ -247,12 +288,45 @@ static struct twl_mapping twl4030_map[TWL4030_MODULE_LAST + 1] = {
 };
 #endif
 
+#ifdef CONFIG_TWL6030_CORE
+static struct twl_mapping twl_map[TWL6030_MODULE_LAST + 1] = {
+	/*
+	 * NOTE:  don't change this table without updating the
+	 * <linux/i2c/twl6030.h> defines for TWL6030_MODULE_*
+	 * so they continue to match the order in this table.
+	 */
+	{ SUB_CHIP_ID0, TWL6030_BASEADD_RTC },
+	{ SUB_CHIP_ID0, TWL6030_BASEADD_MEM },
+	{ SUB_CHIP_ID0, TWL6030_BASEADD_PM_MASTER },
+	{ SUB_CHIP_ID0, TWL6030_BASEADD_PM_SLAVE_MISC },
+	{ SUB_CHIP_ID0, TWL6030_BASEADD_PM_SLAVE_SMPS },
+	{ SUB_CHIP_ID0, TWL6030_BASEADD_PM_SLAVE_LDO },
+	{ SUB_CHIP_ID0, TWL6030_BASEADD_PM_SLAVE_RES },
+	{ SUB_CHIP_ID0, TWL6030_BASEADD_PM_MISC },
+	{ SUB_CHIP_ID0, TWL6030_BASEADD_PM_PUPD },
+
+	{ SUB_CHIP_ID1, TWL6030_BASEADD_USB },
+	{ SUB_CHIP_ID1, TWL6030_BASEADD_GPADC_CTRL },
+	{ SUB_CHIP_ID1, TWL6030_BASEADD_GPADC_RT },
+	{ SUB_CHIP_ID1, TWL6030_BASEADD_GPADC },
+	{ SUB_CHIP_ID1, TWL6030_BASEADD_AUX },
+	{ SUB_CHIP_ID1, TWL6030_BASEADD_PWM },
+	{ SUB_CHIP_ID1, TWL6030_BASEADD_GASGAUGE },
+	{ SUB_CHIP_ID1, TWL6030_BASEADD_PIH },
+	{ SUB_CHIP_ID1, TWL6030_BASEADD_CHARGER },
+
+	{ SUB_CHIP_ID2, TWL6030_BASEADD_DIEID },
+
+	{ SUB_CHIP_ID3, TWL6030_BASEADD_AUDIO },
+};
+#endif
+
 /*----------------------------------------------------------------------*/
 
 /* Exported Functions */
 
 /**
- * twl_i2c_write - Writes a n bit register in TWL4030
+ * twl_i2c_write - Writes a n bit register in TWL4030/TWL6030
  * @mod_no: module number
  * @value: an array of num_bytes+1 containing data to write
  * @reg: register address (just offset will do)
@@ -274,7 +348,7 @@ int twl_i2c_write(u8 mod_no, u8 *value, u8 reg, unsigned num_bytes)
 		pr_err("%s: invalid module number %d\n", DRIVER_NAME, mod_no);
 		return -EPERM;
 	}
-	sid = twl4030_map[mod_no].sid;
+	sid = twl_map[mod_no].sid;
 	twl = &twl_modules[sid];
 
 	if (unlikely(!inuse)) {
@@ -292,7 +366,7 @@ int twl_i2c_write(u8 mod_no, u8 *value, u8 reg, unsigned num_bytes)
 	msg->flags = 0;
 	msg->buf = value;
 	/* over write the first byte of buffer with the register address */
-	*value = twl4030_map[mod_no].base + reg;
+	*value = twl_map[mod_no].base + reg;
 	ret = i2c_transfer(twl->client->adapter, twl->xfer_msg, 1);
 	mutex_unlock(&twl->xfer_lock);
 
@@ -304,7 +378,7 @@ int twl_i2c_write(u8 mod_no, u8 *value, u8 reg, unsigned num_bytes)
 EXPORT_SYMBOL(twl_i2c_write);
 
 /**
- * twl_i2c_read - Reads a n bit register in TWL4030
+ * twl_i2c_read - Reads a n bit register in TWL4030/TWL6030
  * @mod_no: module number
  * @value: an array of num_bytes containing data to be read
  * @reg: register address (just offset will do)
@@ -324,7 +398,7 @@ int twl_i2c_read(u8 mod_no, u8 *value, u8 reg, unsigned num_bytes)
 		pr_err("%s: invalid module number %d\n", DRIVER_NAME, mod_no);
 		return -EPERM;
 	}
-	sid = twl4030_map[mod_no].sid;
+	sid = twl_map[mod_no].sid;
 	twl = &twl_modules[sid];
 
 	if (unlikely(!inuse)) {
@@ -337,7 +411,7 @@ int twl_i2c_read(u8 mod_no, u8 *value, u8 reg, unsigned num_bytes)
 	msg->addr = twl->address;
 	msg->len = 1;
 	msg->flags = 0;	/* Read the register value */
-	val = twl4030_map[mod_no].base + reg;
+	val = twl_map[mod_no].base + reg;
 	msg->buf = &val;
 	/* [MSG2] fill the data rx buffer */
 	msg = &twl->xfer_msg[1];
@@ -356,7 +430,7 @@ int twl_i2c_read(u8 mod_no, u8 *value, u8 reg, unsigned num_bytes)
 EXPORT_SYMBOL(twl_i2c_read);
 
 /**
- * twl_i2c_write_u8 - Writes a 8 bit register in TWL4030
+ * twl_i2c_write_u8 - Writes a 8 bit register in TWL4030/TWL6030
  * @mod_no: module number
  * @value: the value to be written 8 bit
  * @reg: register address (just offset will do)
@@ -375,7 +449,7 @@ int twl_i2c_write_u8(u8 mod_no, u8 value, u8 reg)
 EXPORT_SYMBOL(twl_i2c_write_u8);
 
 /**
- * twl_i2c_read_u8 - Reads a 8 bit register from TWL4030
+ * twl_i2c_read_u8 - Reads a 8 bit register from TWL4030/TWL6030
  * @mod_no: module number
  * @value: the value read 8 bit
  * @reg: register address (just offset will do)
@@ -826,6 +900,7 @@ static const struct i2c_device_id twl_ids[] = {
 	{ "tps65950", 0 },		/* catalog version of twl5030 */
 	{ "tps65930", TPS_SUBSET },	/* fewer LDOs and DACs; no charger */
 	{ "tps65920", TPS_SUBSET },	/* fewer LDOs; no codec or charger */
+	{ "twl6030", 0 },	/* "Phoenix power chip" */
 	{ /* end of list */ },
 };
 MODULE_DEVICE_TABLE(i2c, twl_ids);
diff --git a/drivers/mfd/twl6030-irq.c b/drivers/mfd/twl6030-irq.c
new file mode 100644
index 0000000..0b9e933
--- /dev/null
+++ b/drivers/mfd/twl6030-irq.c
@@ -0,0 +1,301 @@
+/*
+ * twl6030-irq.c - TWL6030 irq support
+ *
+ * Copyright (C) 2005-2009 Texas Instruments, Inc.
+ *
+ * Modifications to defer interrupt handling to a kernel thread:
+ * Copyright (C) 2006 MontaVista Software, Inc.
+ *
+ * Based on tlv320aic23.c:
+ * Copyright (c) by Kai Svahn <kai.svahn@nokia.com>
+ *
+ * Code cleanup and modifications to IRQ handler.
+ * by syed khasim <x0khasim@ti.com>
+ *
+ * TWL6030 specific code and IRQ handling changes by
+ * Jagadeesh Bhaskar Pakaravoor <j-pakaravoor@ti.com>
+ * Balaji T K <balajitk@ti.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307 USA
+ */
+
+#include <linux/init.h>
+#include <linux/interrupt.h>
+#include <linux/irq.h>
+#include <linux/kthread.h>
+#include <linux/i2c/twl.h>
+
+/*
+ * TWL6030 (unlike its predecessors, which had two level interrupt handling)
+ * three interrupt registers INT_STS_A, INT_STS_B and INT_STS_C.
+ * It exposes status bits saying who has raised an interrupt. There are
+ * three mask registers that corresponds to these status registers, that
+ * enables/disables these interrupts.
+ *
+ * We set up IRQs starting at a platform-specified base. An interrupt map table,
+ * specifies mapping between interrupt number and the associated module.
+ *
+ */
+
+static int twl6030_interrupt_mapping[24] = {
+	PWR_INTR_OFFSET,	/* Bit 0	PWRON			*/
+	PWR_INTR_OFFSET,	/* Bit 1	RPWRON			*/
+	PWR_INTR_OFFSET,	/* Bit 2	BAT_VLOW		*/
+	PWR_INTR_OFFSET,	/* Bit 3	VBAT			*/
+	RTC_INTR_OFFSET,	/* Bit 4	RTC_ALARM		*/
+	RTC_INTR_OFFSET,	/* Bit 5	RTC_PERIOD		*/
+	HOTDIE_INTR_OFFSET,	/* Bit 6	HOT_DIE			*/
+	RSV_INTR_OFFSET,  	/* Bit 7	Reserved		*/
+
+	SMPSLDO_INTR_OFFSET,	/* Bit 8	VXXX_SHORT		*/
+	SMPSLDO_INTR_OFFSET,	/* Bit 9	VMMC_SHORT		*/
+	SMPSLDO_INTR_OFFSET,	/* Bit 10	VUSIM_SHORT		*/
+	SIMDETECT_INTR_OFFSET,	/* Bit 11	SIM			*/
+	MMCDETECT_INTR_OFFSET,	/* Bit 12	MMC			*/
+	GPADC_INTR_OFFSET,	/* Bit 13	GPADC_RT_EOC		*/
+	GPADC_INTR_OFFSET,	/* Bit 14	GPADC_SW_EOC		*/
+	GASGAUGE_INTR_OFFSET,	/* Bit 15	CC_AUTOCAL		*/
+
+	USBOTG_INTR_OFFSET,	/* Bit 16	ID_WKUP			*/
+	USBOTG_INTR_OFFSET,	/* Bit 17	VBUS_WKUP		*/
+	USBOTG_INTR_OFFSET,	/* Bit 18	ID			*/
+	USBOTG_INTR_OFFSET,	/* Bit 19	VBUS			*/
+	CHARGER_INTR_OFFSET,	/* Bit 20	CHRG_CTRL		*/
+	CHARGER_INTR_OFFSET,	/* Bit 21	EXT_CHRG		*/
+	CHARGER_INTR_OFFSET,	/* Bit 22	INT_CHRG		*/
+	CHARGER_INTR_OFFSET,	/* Bit 23	BAT_OVT			*/
+};
+/*----------------------------------------------------------------------*/
+
+static unsigned twl6030_irq_base;
+
+static struct completion irq_event;
+
+/*
+ * This thread processes interrupts reported by the Primary Interrupt Handler.
+ */
+static int twl6030_irq_thread(void *data)
+{
+	long irq = (long)data;
+	static unsigned i2c_errors;
+	static const unsigned max_i2c_errors = 100;
+	int ret;
+
+	current->flags |= PF_NOFREEZE;
+
+	while (!kthread_should_stop()) {
+		int i;
+		union {
+		u8 bytes[4];
+		u32 int_sts;
+		} sts;
+
+		/* Wait for IRQ, then read PIH irq status (also blocking) */
+		wait_for_completion_interruptible(&irq_event);
+
+		/* read INT_STS_A, B and C in one shot using a burst read */
+		ret = twl_i2c_read(TWL6030_MODULE_PIH, sts.bytes,
+				REG_INT_STS_A, 3);
+		if (ret) {
+			pr_warning("twl6030: I2C error %d reading PIH ISR\n",
+					ret);
+			if (++i2c_errors >= max_i2c_errors) {
+				printk(KERN_ERR "Maximum I2C error count"
+						" exceeded.  Terminating %s.\n",
+						__func__);
+				break;
+			}
+			complete(&irq_event);
+			continue;
+		}
+
+
+
+		sts.bytes[3] = 0; /* Only 24 bits are valid*/
+
+		for (i = 0; sts.int_sts; sts.int_sts >>= 1, i++) {
+			local_irq_disable();
+			if (sts.int_sts & 0x1) {
+				int module_irq = TWL6030_IRQ_BASE +
+					twl6030_interrupt_mapping[i];
+				struct irq_desc *d = irq_to_desc(module_irq);
+
+				if (!d) {
+					pr_err("twl6030: Invalid SIH IRQ: %d\n",
+					       module_irq);
+					return -EINVAL;
+				}
+
+				/* These can't be masked ... always warn
+				 * if we get any surprises.
+				 */
+				if (d->status & IRQ_DISABLED)
+					note_interrupt(module_irq, d,
+							IRQ_NONE);
+				else
+					d->handle_irq(module_irq, d);
+
+			}
+		local_irq_enable();
+		}
+		ret = twl_i2c_write(TWL6030_MODULE_PIH, sts.bytes,
+				REG_INT_STS_A, 3); /* clear INT_STS_A */
+		if (ret)
+			pr_warning("twl6030: I2C error in clearing PIH ISR\n");
+
+		enable_irq(irq);
+	}
+
+	return 0;
+}
+
+/*
+ * handle_twl6030_int() is the desc->handle method for the twl6030 interrupt.
+ * This is a chained interrupt, so there is no desc->action method for it.
+ * Now we need to query the interrupt controller in the twl6030 to determine
+ * which module is generating the interrupt request.  However, we can't do i2c
+ * transactions in interrupt context, so we must defer that work to a kernel
+ * thread.  All we do here is acknowledge and mask the interrupt and wakeup
+ * the kernel thread.
+ */
+static irqreturn_t handle_twl6030_pih(int irq, void *devid)
+{
+	disable_irq_nosync(irq);
+	complete(devid);
+	return IRQ_HANDLED;
+}
+
+/*----------------------------------------------------------------------*/
+
+static inline void activate_irq(int irq)
+{
+#ifdef CONFIG_ARM
+	/* ARM requires an extra step to clear IRQ_NOREQUEST, which it
+	 * sets on behalf of every irq_chip.  Also sets IRQ_NOPROBE.
+	 */
+	set_irq_flags(irq, IRQF_VALID);
+#else
+	/* same effect on other architectures */
+	set_irq_noprobe(irq);
+#endif
+}
+
+/*----------------------------------------------------------------------*/
+
+static unsigned twl6030_irq_next;
+
+/*----------------------------------------------------------------------*/
+int twl_int_mask_reset(u8 bit_mask, u8 offset)
+{
+	int ret;
+	u8 unmask_value;
+	ret = twl_i2c_read_u8(TWL6030_MODULE_PIH, &unmask_value,
+			REG_INT_STS_A + offset);
+	unmask_value &= (~(bit_mask));
+	ret |= twl_i2c_write_u8(TWL6030_MODULE_PIH, unmask_value,
+			REG_INT_STS_A + offset); /* unmask INT_MSK_A/B/C */
+	return ret;
+}
+
+int twl_int_mask_set(u8 bit_mask, u8 offset)
+{
+	int ret;
+	u8 mask_value;
+	ret = twl_i2c_read_u8(TWL6030_MODULE_PIH, &mask_value,
+			REG_INT_STS_A + offset);
+	mask_value |= (bit_mask);
+	ret |= twl_i2c_write_u8(TWL6030_MODULE_PIH, mask_value,
+			REG_INT_STS_A + offset); /* mask INT_MSK_A/B/C */
+	return ret;
+}
+
+int twl_init_irq(int irq_num, unsigned irq_base, unsigned irq_end)
+{
+
+	int	status = 0;
+	int	i;
+	struct task_struct	*task;
+	int ret;
+	u8 mask[4];
+
+	static struct irq_chip	twl6030_irq_chip;
+	mask[1] = 0xFF;
+	mask[2] = 0xFF;
+	mask[3] = 0xFF;
+	ret = twl_i2c_write(TWL6030_MODULE_PIH, &mask[0],
+			REG_INT_MSK_LINE_A, 3); /* MASK ALL INT LINES*/
+
+	mask[1] = 0;
+	mask[2] = 0;
+	mask[3] = 0;
+	ret = twl_i2c_write(TWL6030_MODULE_PIH, &mask[0],
+			REG_INT_STS_A, 3); /* clear INT_STS_A,B,C */
+
+	ret |= twl_int_mask_reset(TWL6030_RTC_INT_MASK, REG_INT_MSK_LINE_A);
+
+	twl6030_irq_base = irq_base;
+
+	/* install an irq handler for each of the modules;
+	 * clone dummy irq_chip since PIH can't *do* anything
+	 */
+	twl6030_irq_chip = dummy_irq_chip;
+	twl6030_irq_chip.name = "twl6030";
+	twl6030_irq_chip.set_type = NULL;
+
+	for (i = irq_base; i < irq_end; i++) {
+		set_irq_chip_and_handler(i, &twl6030_irq_chip,
+				handle_simple_irq);
+		activate_irq(i);
+	}
+
+	twl6030_irq_next = i;
+	pr_info("twl6030: %s (irq %d) chaining IRQs %d..%d\n", "PIH",
+			irq_num, irq_base, twl6030_irq_next - 1);
+
+	/* install an irq handler to demultiplex the TWL6030 interrupt */
+	init_completion(&irq_event);
+	task = kthread_run(twl6030_irq_thread, (void *)irq_num, "twl6030-irq");
+	if (IS_ERR(task)) {
+		pr_err("twl6030: could not create irq %d thread!\n", irq_num);
+		status = PTR_ERR(task);
+		goto fail_kthread;
+	}
+
+	status = request_irq(irq_num, handle_twl6030_pih, IRQF_DISABLED,
+				"TWL6030-PIH", &irq_event);
+	if (status < 0) {
+		pr_err("twl6030: could not claim irq%d: %d\n", irq_num, status);
+		goto fail;
+	}
+	return status;
+fail_kthread:
+	free_irq(irq_num, &irq_event);
+
+fail:
+	for (i = irq_base; i < irq_end; i++)
+		set_irq_chip_and_handler(i, NULL, NULL);
+	return status;
+}
+
+int twl_exit_irq(void)
+{
+
+	if (twl6030_irq_base) {
+		pr_err("twl6030: can't yet clean up IRQs?\n");
+		return -ENOSYS;
+	}
+	return 0;
+}
+
diff --git a/include/linux/i2c/twl.h b/include/linux/i2c/twl.h
index 1695e92..5ec9070 100644
--- a/include/linux/i2c/twl.h
+++ b/include/linux/i2c/twl.h
@@ -70,10 +70,10 @@
 #define TWL_MODULE_USB		TWL4030_MODULE_USB
 #define TWL_MODULE_AUDIO_VOICE	TWL4030_MODULE_AUDIO_VOICE
 #define TWL_MODULE_GPIO		TWL4030_MODULE_GPIO
-#define TWL_MODULE_INTBR		TWL4030_MODULE_INTBR
+#define TWL_MODULE_INTBR	TWL4030_MODULE_INTBR
 #define TWL_MODULE_PIH		TWL4030_MODULE_PIH
 #define TWL_MODULE_TEST		TWL4030_MODULE_TEST
-#define TWL_MODULE_KEYPAD		TWL4030_MODULE_KEYPAD
+#define TWL_MODULE_KEYPAD	TWL4030_MODULE_KEYPAD
 #define TWL_MODULE_MADC		TWL4030_MODULE_MADC
 #define TWL_MODULE_INTERRUPTS	TWL4030_MODULE_INTERRUPTS
 #define TWL_MODULE_LED		TWL4030_MODULE_LED
@@ -83,7 +83,7 @@
 #define TWL_MODULE_PWM1		TWL4030_MODULE_PWM1
 #define TWL_MODULE_PWMA		TWL4030_MODULE_PWMA
 #define TWL_MODULE_PWMB		TWL4030_MODULE_PWMB
-#define TWL_MODULE_BACKUP		TWL4030_MODULE_BACKUP
+#define TWL_MODULE_BACKUP	TWL4030_MODULE_BACKUP
 #define TWL_MODULE_INT		TWL4030_MODULE_INT
 #define TWL_MODULE_PM_MASTER	TWL4030_MODULE_PM_MASTER
 #define TWL_MODULE_PM_RECEIVER	TWL4030_MODULE_PM_RECEIVER
@@ -92,12 +92,122 @@
 
 #define GPIO_INTR_OFFSET	0
 #define KEYPAD_INTR_OFFSET	1
-#define BCI_INTR_OFFSET	2
+#define BCI_INTR_OFFSET		2
 #define MADC_INTR_OFFSET	3
-#define USB_INTR_OFFSET	4
+#define USB_INTR_OFFSET		4
 #define BCI_PRES_INTR_OFFSET	9
 #define USB_PRES_INTR_OFFSET	10
-#define RTC_INTR_OFFSET	11
+#define RTC_INTR_OFFSET		11
+#endif
+
+/*
+ * Using the twl6030 core we address registers using a pair
+ *	{ module id, relative register offset }
+ * which that core then maps to the relevant
+ *	{ i2c slave, absolute register address }
+ *
+ * The module IDs are meaningful only to the twl6030 core code,
+ * which uses them as array indices to look up the first register
+ * address each module uses within a given i2c slave.
+ */
+/* subchip/slave 0 0x48 - POWER */
+#define TWL6030_MODULE_RTC			0x00
+#define TWL6030_MODULE_MEM			0x01
+#define TWL6030_MODULE_PM_MASTER		0x02
+#define TWL6030_MODULE_PM_SLAVE_MISC		0x03
+#define TWL6030_MODULE_PM_SLAVE_SMPS		0x04
+#define TWL6030_MODULE_PM_SLAVE_LDO		0x05
+#define TWL6030_MODULE_PM_SLAVE_RES		0x06
+#define TWL6030_MODULE_PM_MISC			0x07
+#define TWL6030_MODULE_PM_PUPD			0x08
+
+/* subchip/slave 1 0x49 - FEATURE */
+#define TWL6030_MODULE_USB			0x09
+#define TWL6030_MODULE_GPADC_CTRL		0x0A
+#define TWL6030_MODULE_GPADC_RT			0x0B
+#define TWL6030_MODULE_GPADC			0x0C
+#define TWL6030_MODULE_AUX			0x0D
+#define TWL6030_MODULE_PWM			0x0E
+#define TWL6030_MODULE_GASGAUGE			0x0F
+#define TWL6030_MODULE_PIH			0x10
+#define TWL6030_MODULE_CHARGER			0x11
+
+/* subchip/slave 2 0x4A - DFT */
+#define TWL6030_MODULE_DIEID			0x12
+
+/* subchip/slave 3 0x4B - AUDIO */
+#define TWL6030_MODULE_AUDIO			0x13
+
+#ifdef CONFIG_TWL6030_CORE
+#define TWL_MODULE_RTC			TWL6030_MODULE_RTC
+#define TWL_MODULE_MEM			TWL6030_MODULE_MEM
+#define TWL_MODULE_PM_MASTER		TWL6030_MODULE_PM_MASTER
+#define TWL_MODULE_PM_SLAVE_MISC	TWL6030_MODULE_PM_SLAVE_MISC
+#define TWL_MODULE_PM_SLAVE_SMPS	TWL6030_MODULE_PM_SLAVE_SMP
+#define TWL_MODULE_PM_SLAVE_LDO		TWL6030_MODULE_PM_SLAVE_LDO
+#define TWL_MODULE_PM_SLAVE_RES		TWL6030_MODULE_PM_SLAVE_RES
+#define TWL_MODULE_PM_MISC		TWL6030_MODULE_PM_MISC
+#define TWL_MODULE_PM_PUPD		TWL6030_MODULE_PM_PUPD
+#define TWL_MODULE_USB			TWL6030_MODULE_USB
+#define TWL_MODULE_GPADC_CTRL		TWL6030_MODULE_GPADC_CTRL
+#define TWL_MODULE_GPADC_RT		TWL6030_MODULE_GPADC_RT
+#define TWL_MODULE_GPADC		TWL6030_MODULE_GPADC
+#define TWL_MODULE_AUX			TWL6030_MODULE_AUX
+#define TWL_MODULE_PWM			TWL6030_MODULE_PWM
+#define TWL_MODULE_GASGAUGE		TWL6030_MODULE_GASGAUGE
+#define TWL_MODULE_PIH			TWL6030_MODULE_PIH
+#define TWL_MODULE_CHARGER		TWL6030_MODULE_CHARGER
+#define TWL_MODULE_DIEID		TWL6030_MODULE_DIEID
+#define TWL_MODULE_AUDIO		TWL6030_MODULE_AUDIO
+
+/* INT register offsets */
+#define REG_INT_STS_A			0x00
+#define REG_INT_STS_B			0x01
+#define REG_INT_STS_C			0x02
+
+#define REG_INT_MSK_LINE_A		0x03
+#define REG_INT_MSK_LINE_B		0x04
+#define REG_INT_MSK_LINE_C		0x05
+
+#define REG_INT_MSK_STS_A		0x06
+#define REG_INT_MSK_STS_B		0x07
+#define REG_INT_MSK_STS_C		0x08
+
+#define TWL6030_PWR_INT_MASK 		0x0F
+#define TWL6030_RTC_INT_MASK 		0x30
+#define TWL6030_HOTDIE_INT_MASK 	0x40
+
+#define TWL6030_SMPSLDO_INT_MASK 	0x07
+#define TWL6030_SIMDETECT_INT_MASK 	0x08
+#define TWL6030_MMCDETECT_INT_MASK 	0x10
+#define TWL6030_GPADC_INT_MASK 		0x60
+#define TWL6030_GASGAUGE_INT_MASK 	0x80
+
+#define TWL6030_USBOTG_INT_MASK  	0x0F
+#define TWL6030_CHARGER_INT_MASK 	0xF0
+
+/*
+ * Offset from TWL6030_IRQ_BASE / pdata->irq_base
+ */
+#define PWR_INTR_OFFSET		0
+#define RTC_INTR_OFFSET		1
+#define HOTDIE_INTR_OFFSET	2
+#define SMPSLDO_INTR_OFFSET	3
+#define SIMDETECT_INTR_OFFSET	4
+#define MMCDETECT_INTR_OFFSET	5
+#define GPADC_INTR_OFFSET	6
+#define GASGAUGE_INTR_OFFSET	7
+#define USBOTG_INTR_OFFSET	8
+#define CHARGER_INTR_OFFSET	9
+#define RSV_INTR_OFFSET		0
+
+#define BCI_PRES_INTR_OFFSET	4
+#define MADC_INTR_OFFSET	6
+#define BCI_INTR_OFFSET		8
+#define USB_PRES_INTR_OFFSET	8
+#define USB_INTR_OFFSET		8
+#define GPIO_INTR_OFFSET	0 /* NOT SUPPORTED IN TWL6030 */
+#define KEYPAD_INTR_OFFSET	0 /* ADDED FOR COMPILATION ONLY */
 #endif
 /*
  * Read and write single 8-bit registers
@@ -432,6 +542,8 @@ int twl4030_sih_setup(int module);
 #define TWL4030_REG_VUSB1V8	18
 #define TWL4030_REG_VUSB3V1	19
 
+int twl_int_mask_reset(u8 bit_mask, u8 offset);
+int twl_int_mask_set(u8 bit_mask, u8 offset);
 int twl_init_irq(int irq_num, unsigned irq_base, unsigned irq_end);
 int twl_exit_irq(void);
 
-- 
1.5.4.7

