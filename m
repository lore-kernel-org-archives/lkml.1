Return-Path: <linux-kernel-owner+w=401wt.eu-S1752278AbZKCKxb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752278AbZKCKxb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Nov 2009 05:53:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751688AbZKCKxa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Nov 2009 05:53:30 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:56837 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751544AbZKCKx1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Nov 2009 05:53:27 -0500
Date: Tue, 3 Nov 2009 11:53:20 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Arve Hj?nnev?g <arve@android.com>,
       kernel list <linux-kernel@vger.kernel.org>,
       linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
       Brian Swetland <swetland@google.com>
Subject: dream: glue for mmc controller
Message-ID: <20091103105319.GA2492@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This is what I came up with (relative to the previous
patches). Unfortunately, it does not quite work: mmc controller is
detected, but it hangs trying to access the card.

Good news is that GPIO support seems to work, and I am able to flash
the keyboard backlight.

Does anyone have an idea what is wrong? Do I need some more
infrastructure to set up (DMA transfers or something?)?

I'm only setting up one mmc channel; I believe the other one is for
wifi, and it should work like this...?
								Pavel

diff --git a/arch/arm/mach-msm/Makefile b/arch/arm/mach-msm/Makefile
index 91e6f5c..16c0faa 100644
--- a/arch/arm/mach-msm/Makefile
+++ b/arch/arm/mach-msm/Makefile
@@ -6,4 +6,4 @@ obj-y += clock.o clock-7x01a.o
 
 obj-$(CONFIG_MACH_HALIBUT) += board-halibut.o
 
-obj-$(CONFIG_MACH_TROUT) += board-dream.o
+obj-$(CONFIG_MACH_TROUT) += board-dream.o board-dream-mmc.o board-dream-gpio.o generic_gpio.o
diff --git a/arch/arm/mach-msm/board-dream-gpio.c b/arch/arm/mach-msm/board-dream-gpio.c
new file mode 100644
index 0000000..7e86a99
--- /dev/null
+++ b/arch/arm/mach-msm/board-dream-gpio.c
@@ -0,0 +1,301 @@
+/* arch/arm/mach-msm/board-dream-gpio.c
+ *
+ * Copyright (C) 2008 Google, Inc.
+ *
+ * This software is licensed under the terms of the GNU General Public
+ * License version 2, as published by the Free Software Foundation, and
+ * may be copied, distributed, and modified under those terms.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ */
+
+#include <linux/kernel.h>
+#include <linux/errno.h>
+#include <linux/irq.h>
+#include <linux/pm.h>
+#include <linux/sysdev.h>
+
+#include <asm/io.h>
+#include <asm/gpio.h>
+#include <asm/mach-types.h>
+
+#include "board-dream.h"
+#include "gpio_chip.h"
+
+#undef MODULE_PARAM_PREFIX
+#define MODULE_PARAM_PREFIX "board_dream."
+
+static uint cpld_usb_h2w_sw;
+module_param_named(usb_h2w_sw, cpld_usb_h2w_sw, uint, 0);
+
+static uint8_t dream_cpld_shadow[4] = {
+#if defined(CONFIG_MSM_DEBUG_UART1)
+	/* H2W pins <-> UART1 */
+        [0] = 0x40, // for serial debug, low current
+#else
+	/* H2W pins <-> UART3, Bluetooth <-> UART1 */
+        [0] = 0x80, // for serial debug, low current
+#endif
+        [1] = 0x04, // I2C_PULL
+        [3] = 0x04, // mmdi 32k en
+};
+static uint8_t dream_int_mask[2] = {
+        [0] = 0xff, /* mask all interrupts */
+        [1] = 0xff,
+};
+static uint8_t dream_sleep_int_mask[] = {
+        [0] = 0xff,
+        [1] = 0xff,
+};
+static int dream_suspended;
+
+static int dream_gpio_read(struct gpio_chip *chip, unsigned n)
+{
+	uint8_t b;
+	int reg;
+	if (n >= TROUT_GPIO_VIRTUAL_BASE)
+		n += TROUT_GPIO_VIRTUAL_TO_REAL_OFFSET;
+	b = 1U << (n & 7);
+	reg = (n & 0x78) >> 2; // assumes base is 128
+	return !!(readb(TROUT_CPLD_BASE + reg) & b);
+}
+
+static void update_pwrsink(unsigned gpio, unsigned on)
+{
+	switch(gpio) {
+	case TROUT_GPIO_UI_LED_EN:
+		break;
+	case TROUT_GPIO_QTKEY_LED_EN:
+		break;
+	}
+}
+
+static uint8_t dream_gpio_write_shadow(unsigned n, unsigned on)
+{
+	uint8_t b = 1U << (n & 7);
+	int reg = (n & 0x78) >> 2; // assumes base is 128
+
+	if(on)
+		return dream_cpld_shadow[reg >> 1] |= b;
+	else
+		return dream_cpld_shadow[reg >> 1] &= ~b;
+}
+
+static int dream_gpio_write(struct gpio_chip *chip, unsigned n, unsigned on)
+{
+	int reg = (n & 0x78) >> 2; // assumes base is 128
+	unsigned long flags;
+	uint8_t reg_val;
+
+	if ((reg >> 1) >= ARRAY_SIZE(dream_cpld_shadow)) {
+		printk(KERN_ERR "dream_gpio_write called on input %d\n", n);
+		return -ENOTSUPP;
+	}
+
+	local_irq_save(flags);
+	update_pwrsink(n, on);
+	reg_val = dream_gpio_write_shadow(n, on);
+	writeb(reg_val, TROUT_CPLD_BASE + reg);
+	local_irq_restore(flags);
+	return 0;
+}
+
+static int dream_gpio_configure(struct gpio_chip *chip, unsigned int gpio, unsigned long flags)
+{
+	if(flags & (GPIOF_OUTPUT_LOW | GPIOF_OUTPUT_HIGH))
+		dream_gpio_write(chip, gpio, flags & GPIOF_OUTPUT_HIGH);
+	return 0;
+}
+
+static int dream_gpio_get_irq_num(struct gpio_chip *chip, unsigned int gpio, unsigned int *irqp, unsigned long *irqnumflagsp)
+{
+	if ((gpio < TROUT_GPIO_BANK0_FIRST_INT_SOURCE ||
+	     gpio > TROUT_GPIO_BANK0_LAST_INT_SOURCE) &&
+	    (gpio < TROUT_GPIO_BANK1_FIRST_INT_SOURCE ||
+	     gpio > TROUT_GPIO_BANK1_LAST_INT_SOURCE))
+		return -ENOENT;
+	*irqp = TROUT_GPIO_TO_INT(gpio);
+	if(irqnumflagsp)
+		*irqnumflagsp = 0;
+	return 0;
+}
+
+static void dream_gpio_irq_ack(unsigned int irq)
+{
+	int bank = TROUT_INT_TO_BANK(irq);
+	uint8_t mask = TROUT_INT_TO_MASK(irq);
+	int reg = TROUT_BANK_TO_STAT_REG(bank);
+	/*printk(KERN_INFO "dream_gpio_irq_ack irq %d\n", irq);*/
+	writeb(mask, TROUT_CPLD_BASE + reg);
+}
+
+static void dream_gpio_irq_mask(unsigned int irq)
+{
+	unsigned long flags;
+	uint8_t reg_val;
+	int bank = TROUT_INT_TO_BANK(irq);
+	uint8_t mask = TROUT_INT_TO_MASK(irq);
+	int reg = TROUT_BANK_TO_MASK_REG(bank);
+
+	local_irq_save(flags);
+	reg_val = dream_int_mask[bank] |= mask;
+	/*printk(KERN_INFO "dream_gpio_irq_mask irq %d => %d:%02x\n",
+	       irq, bank, reg_val);*/
+	if (!dream_suspended)
+		writeb(reg_val, TROUT_CPLD_BASE + reg);
+	local_irq_restore(flags);
+}
+
+static void dream_gpio_irq_unmask(unsigned int irq)
+{
+	unsigned long flags;
+	uint8_t reg_val;
+	int bank = TROUT_INT_TO_BANK(irq);
+	uint8_t mask = TROUT_INT_TO_MASK(irq);
+	int reg = TROUT_BANK_TO_MASK_REG(bank);
+
+	local_irq_save(flags);
+	reg_val = dream_int_mask[bank] &= ~mask;
+	/*printk(KERN_INFO "dream_gpio_irq_unmask irq %d => %d:%02x\n",
+	       irq, bank, reg_val);*/
+	if (!dream_suspended)
+		writeb(reg_val, TROUT_CPLD_BASE + reg);
+	local_irq_restore(flags);
+}
+
+int dream_gpio_irq_set_wake(unsigned int irq, unsigned int on)
+{
+	unsigned long flags;
+	int bank = TROUT_INT_TO_BANK(irq);
+	uint8_t mask = TROUT_INT_TO_MASK(irq);
+
+	local_irq_save(flags);
+	if(on)
+		dream_sleep_int_mask[bank] &= ~mask;
+	else
+		dream_sleep_int_mask[bank] |= mask;
+	local_irq_restore(flags);
+	return 0;
+}
+
+static void dream_gpio_irq_handler(unsigned int irq, struct irq_desc *desc)
+{
+	int j, m;
+	unsigned v;
+	int bank;
+	int stat_reg;
+	int int_base = TROUT_INT_START;
+	uint8_t int_mask;
+
+	for (bank = 0; bank < 2; bank++) {
+		stat_reg = TROUT_BANK_TO_STAT_REG(bank);
+		v = readb(TROUT_CPLD_BASE + stat_reg);
+		int_mask = dream_int_mask[bank];
+		if (v & int_mask) {
+			writeb(v & int_mask, TROUT_CPLD_BASE + stat_reg);
+			printk(KERN_ERR "dream_gpio_irq_handler: got masked "
+			       "interrupt: %d:%02x\n", bank, v & int_mask);
+		}
+		v &= ~int_mask;
+		while (v) {
+			m = v & -v;
+			j = fls(m) - 1;
+			/*printk(KERN_INFO "msm_gpio_irq_handler %d:%02x %02x b"
+			       "it %d irq %d\n", bank, v, m, j, int_base + j);*/
+			v &= ~m;
+			generic_handle_irq(int_base + j);
+		}
+		int_base += TROUT_INT_BANK0_COUNT;
+	}
+	desc->chip->ack(irq);
+}
+
+static int dream_sysdev_suspend(struct sys_device *dev, pm_message_t state)
+{
+	dream_suspended = 1;
+	writeb(dream_sleep_int_mask[0],
+	       TROUT_CPLD_BASE + TROUT_GPIO_INT_MASK0_REG);
+	writeb(dream_sleep_int_mask[1],
+	       TROUT_CPLD_BASE + TROUT_GPIO_INT_MASK1_REG);
+	writeb(dream_sleep_int_mask[0],
+	       TROUT_CPLD_BASE + TROUT_GPIO_INT_STAT0_REG);
+	writeb(dream_sleep_int_mask[1],
+	       TROUT_CPLD_BASE + TROUT_GPIO_INT_STAT1_REG);
+	return 0;
+}
+
+int dream_sysdev_resume(struct sys_device *dev)
+{
+	writeb(dream_int_mask[0], TROUT_CPLD_BASE + TROUT_GPIO_INT_MASK0_REG);
+	writeb(dream_int_mask[1], TROUT_CPLD_BASE + TROUT_GPIO_INT_MASK1_REG);
+	dream_suspended = 0;
+	return 0;
+}
+
+static struct irq_chip dream_gpio_irq_chip = {
+	.name      = "dreamgpio",
+	.ack       = dream_gpio_irq_ack,
+	.mask      = dream_gpio_irq_mask,
+	.unmask    = dream_gpio_irq_unmask,
+	.set_wake  = dream_gpio_irq_set_wake,
+	//.set_type  = dream_gpio_irq_set_type,
+};
+
+static struct gpio_chip dream_gpio_chip = {
+	.start = TROUT_GPIO_START,
+	.end = TROUT_GPIO_END,
+	.configure = dream_gpio_configure,
+	.get_irq_num = dream_gpio_get_irq_num,
+	.read = dream_gpio_read,
+	.write = dream_gpio_write,
+//	.read_detect_status = dream_gpio_read_detect_status,
+//	.clear_detect_status = dream_gpio_clear_detect_status
+};
+
+struct sysdev_class dream_sysdev_class = {
+	.name = "dreamgpio_irq",
+	.suspend = dream_sysdev_suspend,
+	.resume = dream_sysdev_resume,
+};
+
+static struct sys_device dream_irq_device = {
+	.cls    = &dream_sysdev_class,
+};
+
+static int __init dream_init_gpio(void)
+{
+	int i;
+
+	if (!machine_is_trout())
+		return 0;
+
+	/* adjust GPIOs based on bootloader request */
+	pr_info("dream_init_gpio: cpld_usb_hw2_sw = %d\n", cpld_usb_h2w_sw);
+	dream_gpio_write_shadow(TROUT_GPIO_USB_H2W_SW, cpld_usb_h2w_sw);
+
+	for(i = 0; i < ARRAY_SIZE(dream_cpld_shadow); i++)
+		writeb(dream_cpld_shadow[i], TROUT_CPLD_BASE + i * 2);
+
+	for(i = TROUT_INT_START; i <= TROUT_INT_END; i++) {
+		set_irq_chip(i, &dream_gpio_irq_chip);
+		set_irq_handler(i, handle_edge_irq);
+		set_irq_flags(i, IRQF_VALID);
+	}
+
+	register_gpio_chip(&dream_gpio_chip);
+
+	set_irq_type(MSM_GPIO_TO_INT(17), IRQF_TRIGGER_HIGH);
+	set_irq_chained_handler(MSM_GPIO_TO_INT(17), dream_gpio_irq_handler);
+	set_irq_wake(MSM_GPIO_TO_INT(17), 1);
+
+	if(sysdev_class_register(&dream_sysdev_class) == 0)
+		sysdev_register(&dream_irq_device);
+
+	return 0;
+}
+
+postcore_initcall(dream_init_gpio);
diff --git a/arch/arm/mach-msm/board-dream-mmc.c b/arch/arm/mach-msm/board-dream-mmc.c
new file mode 100644
index 0000000..1b65ece
--- /dev/null
+++ b/arch/arm/mach-msm/board-dream-mmc.c
@@ -0,0 +1,240 @@
+/* linux/arch/arm/mach-msm/board-dream-mmc.c
+ * Author: Brian Swetland <swetland@google.com>
+ *
+ * GPLv2.
+ */
+
+#include <linux/kernel.h>
+#include <linux/init.h>
+#include <linux/platform_device.h>
+#include <linux/delay.h>
+#include <linux/mmc/host.h>
+#include <linux/mmc/sdio_ids.h>
+#include <linux/err.h>
+#include <linux/debugfs.h>
+
+#include <asm/gpio.h>
+#include <asm/io.h>
+
+#include <mach/vreg.h>
+
+#include <mach/mmc.h>
+
+#include "devices.h"
+#include "board-dream.h"
+#include "proc_comm.h"
+
+#define DEBUG_SDSLOT_VDD 1
+
+extern int msm_add_sdcc(unsigned int controller, struct mmc_platform_data *plat,
+			unsigned int stat_irq, unsigned long stat_irq_flags);
+
+/* ---- COMMON ---- */
+static void config_gpio_table(uint32_t *table, int len)
+{
+	int n;
+	unsigned id;
+	for(n = 0; n < len; n++) {
+		id = table[n];
+		msm_proc_comm(PCOM_RPC_GPIO_TLMM_CONFIG_EX, &id, 0);
+	}
+}
+
+/* ---- SDCARD ---- */
+
+static uint32_t sdcard_on_gpio_table[] = {
+	PCOM_GPIO_CFG(62, 2, GPIO_OUTPUT, GPIO_NO_PULL, GPIO_8MA), /* CLK */
+	PCOM_GPIO_CFG(63, 2, GPIO_OUTPUT, GPIO_PULL_UP, GPIO_8MA), /* CMD */
+	PCOM_GPIO_CFG(64, 2, GPIO_OUTPUT, GPIO_PULL_UP, GPIO_8MA), /* DAT3 */
+	PCOM_GPIO_CFG(65, 2, GPIO_OUTPUT, GPIO_PULL_UP, GPIO_8MA), /* DAT2 */
+	PCOM_GPIO_CFG(66, 2, GPIO_OUTPUT, GPIO_PULL_UP, GPIO_4MA), /* DAT1 */
+	PCOM_GPIO_CFG(67, 2, GPIO_OUTPUT, GPIO_PULL_UP, GPIO_4MA), /* DAT0 */
+};
+
+static uint32_t sdcard_off_gpio_table[] = {
+	PCOM_GPIO_CFG(62, 0, GPIO_OUTPUT, GPIO_NO_PULL, GPIO_4MA), /* CLK */
+	PCOM_GPIO_CFG(63, 0, GPIO_OUTPUT, GPIO_NO_PULL, GPIO_4MA), /* CMD */
+	PCOM_GPIO_CFG(64, 0, GPIO_OUTPUT, GPIO_NO_PULL, GPIO_4MA), /* DAT3 */
+	PCOM_GPIO_CFG(65, 0, GPIO_OUTPUT, GPIO_NO_PULL, GPIO_4MA), /* DAT2 */
+	PCOM_GPIO_CFG(66, 0, GPIO_OUTPUT, GPIO_NO_PULL, GPIO_4MA), /* DAT1 */
+	PCOM_GPIO_CFG(67, 0, GPIO_OUTPUT, GPIO_NO_PULL, GPIO_4MA), /* DAT0 */
+};
+
+static uint opt_disable_sdcard;
+
+static int __init dream_disablesdcard_setup(char *str)
+{
+	int cal = simple_strtol(str, NULL, 0);
+	
+	opt_disable_sdcard = cal;
+	return 1;
+}
+
+__setup("board_dream.disable_sdcard=", dream_disablesdcard_setup);
+
+static struct vreg *vreg_sdslot;	/* SD slot power */
+
+struct mmc_vdd_xlat {
+	int mask;
+	int level;
+};
+
+static struct mmc_vdd_xlat mmc_vdd_table[] = {
+	{ MMC_VDD_165_195,	1800 },
+	{ MMC_VDD_20_21,	2050 },
+	{ MMC_VDD_21_22,	2150 },
+	{ MMC_VDD_22_23,	2250 },
+	{ MMC_VDD_23_24,	2350 },
+	{ MMC_VDD_24_25,	2450 },
+	{ MMC_VDD_25_26,	2550 },
+	{ MMC_VDD_26_27,	2650 },
+	{ MMC_VDD_27_28,	2750 },
+	{ MMC_VDD_28_29,	2850 },
+	{ MMC_VDD_29_30,	2950 },
+};
+
+static unsigned int sdslot_vdd = 0xffffffff;
+static unsigned int sdslot_vreg_enabled;
+
+static uint32_t dream_sdslot_switchvdd(struct device *dev, unsigned int vdd)
+{
+	int i, rc;
+
+	BUG_ON(!vreg_sdslot);
+
+	if (vdd == sdslot_vdd)
+		return 0;
+
+	sdslot_vdd = vdd;
+
+	if (vdd == 0) {
+#if DEBUG_SDSLOT_VDD
+		printk("%s: Disabling SD slot power\n", __func__);
+#endif
+		config_gpio_table(sdcard_off_gpio_table,
+				  ARRAY_SIZE(sdcard_off_gpio_table));
+		vreg_disable(vreg_sdslot);
+		sdslot_vreg_enabled = 0;
+		return 0;
+	}
+
+	if (!sdslot_vreg_enabled) {
+		rc = vreg_enable(vreg_sdslot);
+		if (rc) {
+			printk(KERN_ERR "%s: Error enabling vreg (%d)\n",
+			       __func__, rc);
+		}
+		config_gpio_table(sdcard_on_gpio_table,
+				  ARRAY_SIZE(sdcard_on_gpio_table));
+		sdslot_vreg_enabled = 1;
+	}
+
+	for (i = 0; i < ARRAY_SIZE(mmc_vdd_table); i++) {
+		if (mmc_vdd_table[i].mask == (1 << vdd)) {
+#if DEBUG_SDSLOT_VDD
+			printk("%s: Setting level to %u\n",
+			        __func__, mmc_vdd_table[i].level);
+#endif
+			rc = vreg_set_level(vreg_sdslot,
+					    mmc_vdd_table[i].level);
+			if (rc) {
+				printk(KERN_ERR
+				       "%s: Error setting vreg level (%d)\n",
+				       __func__, rc);
+			}
+			return 0;
+		}
+	}
+
+	printk(KERN_ERR "%s: Invalid VDD %d specified\n", __func__, vdd);
+	return 0;
+}
+
+static unsigned int dream_sdslot_status(struct device *dev)
+{
+	unsigned int status;
+
+	status = (unsigned int) gpio_get_value(TROUT_GPIO_SDMC_CD_N);
+	return (!status);
+}
+
+#define TROUT_MMC_VDD	MMC_VDD_165_195 | MMC_VDD_20_21 | MMC_VDD_21_22 \
+			| MMC_VDD_22_23 | MMC_VDD_23_24 | MMC_VDD_24_25 \
+			| MMC_VDD_25_26 | MMC_VDD_26_27 | MMC_VDD_27_28 \
+			| MMC_VDD_28_29 | MMC_VDD_29_30
+
+static struct mmc_platform_data dream_sdslot_data = {
+	.ocr_mask	= TROUT_MMC_VDD,
+	.status		= dream_sdslot_status,
+	.translate_vdd	= dream_sdslot_switchvdd,
+};
+
+int __init dream_init_mmc(unsigned int sys_rev)
+{
+	sdslot_vreg_enabled = 0;
+
+	vreg_sdslot = vreg_get(0, "gp6");
+	if (IS_ERR(vreg_sdslot))
+		return PTR_ERR(vreg_sdslot);
+
+	set_irq_wake(TROUT_GPIO_TO_INT(TROUT_GPIO_SDMC_CD_N), 1);
+
+	if (!opt_disable_sdcard)
+		msm_add_sdcc(2, &dream_sdslot_data,
+			     TROUT_GPIO_TO_INT(TROUT_GPIO_SDMC_CD_N), 0);
+	else
+		printk(KERN_INFO "dream: SD-Card interface disabled\n");
+	return 0;
+}
+
+#if defined(CONFIG_DEBUG_FS)
+static int dreammmc_dbg_sd_pwr_set(void *data, u64 val)
+{
+	dream_sdslot_switchvdd(NULL, (unsigned int) val);
+	return 0;
+}
+
+static int dreammmc_dbg_sd_pwr_get(void *data, u64 *val)
+{
+	*val = sdslot_vdd;
+	return 0;
+}
+
+static int dreammmc_dbg_sd_cd_set(void *data, u64 val)
+{
+	return -ENOSYS;
+}
+
+static int dreammmc_dbg_sd_cd_get(void *data, u64 *val)
+{
+	*val = dream_sdslot_status(NULL);
+	return 0;
+}
+
+DEFINE_SIMPLE_ATTRIBUTE(dreammmc_dbg_sd_pwr_fops,
+			dreammmc_dbg_sd_pwr_get,
+			dreammmc_dbg_sd_pwr_set, "%llu\n");
+
+DEFINE_SIMPLE_ATTRIBUTE(dreammmc_dbg_sd_cd_fops,
+			dreammmc_dbg_sd_cd_get,
+			dreammmc_dbg_sd_cd_set, "%llu\n");
+
+static int __init dreammmc_dbg_init(void)
+{
+	struct dentry *dent;
+
+	dent = debugfs_create_dir("dreammmc_dbg", 0);
+	if (IS_ERR(dent))
+		return PTR_ERR(dent);
+
+	debugfs_create_file("sd_pwr", 0644, dent, NULL,
+			    &dreammmc_dbg_sd_pwr_fops);
+	debugfs_create_file("sd_cd", 0644, dent, NULL,
+			    &dreammmc_dbg_sd_cd_fops);
+
+	return 0;
+}
+
+device_initcall(dreammmc_dbg_init);
+
+#endif
diff --git a/arch/arm/mach-msm/board-dream.c b/arch/arm/mach-msm/board-dream.c
index a0877a3..49de63b 100644
--- a/arch/arm/mach-msm/board-dream.c
+++ b/arch/arm/mach-msm/board-dream.c
@@ -12,16 +12,19 @@
  * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
  * GNU General Public License for more details.
  *
+ * This machine is also known by its codename, "trout".
  */
 
 #include <linux/kernel.h>
 #include <linux/init.h>
 #include <linux/platform_device.h>
+#include <linux/delay.h>
 
 #include <asm/mach-types.h>
 #include <asm/mach/arch.h>
 #include <asm/mach/map.h>
 #include <asm/setup.h>
+#include <asm/gpio.h>
 
 #include <mach/board.h>
 #include <mach/hardware.h>
@@ -30,6 +33,9 @@
 #include "devices.h"
 #include "board-dream.h"
 
+extern int dream_init_mmc(unsigned int);
+
+
 static struct platform_device *devices[] __initdata = {
 	&msm_device_uart3,
 	&msm_device_smd,
@@ -40,12 +46,12 @@ static struct platform_device *devices[] __initdata = {
 
 extern struct sys_timer msm_timer;
 
-static void __init trout_init_irq(void)
+static void __init dream_init_irq(void)
 {
 	msm_init_irq();
 }
 
-static void __init trout_fixup(struct machine_desc *desc, struct tag *tags,
+static void __init dream_fixup(struct machine_desc *desc, struct tag *tags,
 				char **cmdline, struct meminfo *mi)
 {
 	mi->nr_banks=1;
@@ -54,12 +60,34 @@ static void __init trout_fixup(struct machine_desc *desc, struct tag *tags,
 	mi->bank[0].size = (101*1024*1024);
 }
 
-static void __init trout_init(void)
+static void __init dream_init(void)
 {
+	int rc;
 	platform_add_devices(devices, ARRAY_SIZE(devices));
+
+	rc = dream_init_mmc(system_rev);
+	if (rc)
+		printk(KERN_CRIT "%s: MMC init failure (%d)\n", __func__, rc);
+
+	gpio_set_value(TROUT_GPIO_UI_LED_EN, 1);
+        mdelay(300);
+	gpio_set_value(TROUT_GPIO_UI_LED_EN, 0);
+        mdelay(300);
+        gpio_set_value(TROUT_GPIO_UI_LED_EN, 1);
+	mdelay(300);
+        gpio_set_value(TROUT_GPIO_UI_LED_EN, 0);
+	mdelay(300);
+        gpio_set_value(TROUT_GPIO_UI_LED_EN, 1);
+        mdelay(300);
+        gpio_set_value(TROUT_GPIO_UI_LED_EN, 0);
+        mdelay(300);
+	gpio_set_value(TROUT_GPIO_UI_LED_EN, 1);
+        mdelay(300);
+	gpio_set_value(TROUT_GPIO_UI_LED_EN, 0);
+        mdelay(300);
 }
 
-static struct map_desc trout_io_desc[] __initdata = {
+static struct map_desc dream_io_desc[] __initdata = {
 	{
 		.virtual = TROUT_CPLD_BASE,
 		.pfn     = __phys_to_pfn(TROUT_CPLD_START),
@@ -68,10 +96,10 @@ static struct map_desc trout_io_desc[] __initdata = {
 	}
 };
 
-static void __init trout_map_io(void)
+static void __init dream_map_io(void)
 {
 	msm_map_common_io();
-	iotable_init(trout_io_desc, ARRAY_SIZE(trout_io_desc));
+	iotable_init(dream_io_desc, ARRAY_SIZE(dream_io_desc));
 
 #ifdef CONFIG_MSM_DEBUG_UART3
 	/* route UART3 to the "H2W" extended usb connector */
@@ -87,9 +115,9 @@ MACHINE_START(TROUT, "HTC Dream")
 	.io_pg_offst	= ((MSM_DEBUG_UART_BASE) >> 18) & 0xfffc,
 #endif
 	.boot_params	= 0x10000100,
-	.fixup		= trout_fixup,
-	.map_io		= trout_map_io,
-	.init_irq	= trout_init_irq,
-	.init_machine	= trout_init,
+	.fixup		= dream_fixup,
+	.map_io		= dream_map_io,
+	.init_irq	= dream_init_irq,
+	.init_machine	= dream_init,
 	.timer		= &msm_timer,
 MACHINE_END
diff --git a/arch/arm/mach-msm/board-dream.h b/arch/arm/mach-msm/board-dream.h
index 4f345a5..cdfb0ae 100644
--- a/arch/arm/mach-msm/board-dream.h
+++ b/arch/arm/mach-msm/board-dream.h
@@ -1,5 +1,153 @@
 
+#define MSM_SMI_BASE		0x00000000
+#define MSM_SMI_SIZE		0x00800000
+
+#define MSM_EBI_BASE		0x10000000
+#define MSM_EBI_SIZE		0x06e00000
+
+#define MSM_PMEM_GPU0_BASE	0x00000000
+#define MSM_PMEM_GPU0_SIZE	0x00700000
+
+#define MSM_PMEM_MDP_BASE	0x02000000
+#define MSM_PMEM_MDP_SIZE	0x00800000
+
+#define MSM_PMEM_ADSP_BASE      0x02800000
+#define MSM_PMEM_ADSP_SIZE	0x00800000
+
+#define MSM_PMEM_CAMERA_BASE	0x03000000
+#define MSM_PMEM_CAMERA_SIZE	0x00800000
+
+#define MSM_FB_BASE		0x03800000
+#define MSM_FB_SIZE		0x00100000
+
+#define MSM_LINUX_BASE		MSM_EBI_BASE
+#define MSM_LINUX_SIZE		0x06500000
+
+#define MSM_PMEM_GPU1_SIZE	0x800000
+#define MSM_PMEM_GPU1_BASE	MSM_RAM_CONSOLE_BASE - MSM_PMEM_GPU1_SIZE
+
+#define MSM_RAM_CONSOLE_BASE	MSM_EBI_BASE + 0x6d00000
+#define MSM_RAM_CONSOLE_SIZE	128 * SZ_1K
+
+#if (MSM_FB_BASE + MSM_FB_SIZE) >= (MSM_PMEM_GPU1_BASE)
+#error invalid memory map
+#endif
+
+#define DECLARE_MSM_IOMAP
+#include <mach/msm_iomap.h>
+
+#define TROUT_4_BALL_UP_0     1
+#define TROUT_4_BALL_LEFT_0   18
+#define TROUT_4_BALL_DOWN_0   57
+#define TROUT_4_BALL_RIGHT_0  91
+
+#define TROUT_5_BALL_UP_0     94
+#define TROUT_5_BALL_LEFT_0   18
+#define TROUT_5_BALL_DOWN_0   90
+#define TROUT_5_BALL_RIGHT_0  19
+
+#define TROUT_POWER_KEY     20
+
+#define TROUT_4_TP_LS_EN    19
+#define TROUT_5_TP_LS_EN    1
+
 #define TROUT_CPLD_BASE   0xE8100000
 #define TROUT_CPLD_START  0x98000000
 #define TROUT_CPLD_SIZE   SZ_4K
 
+#define TROUT_GPIO_CABLE_IN1		(83)
+#define TROUT_GPIO_CABLE_IN2		(49)
+
+#define TROUT_GPIO_START (128)
+
+#define TROUT_GPIO_INT_MASK0_REG            (0x0c)
+#define TROUT_GPIO_INT_STAT0_REG            (0x0e)
+#define TROUT_GPIO_INT_MASK1_REG            (0x14)
+#define TROUT_GPIO_INT_STAT1_REG            (0x10)
+
+#define TROUT_GPIO_HAPTIC_PWM               (28)
+#define TROUT_GPIO_PS_HOLD                  (25)
+
+#define TROUT_GPIO_MISC2_BASE               (TROUT_GPIO_START + 0x00)
+#define TROUT_GPIO_MISC3_BASE               (TROUT_GPIO_START + 0x08)
+#define TROUT_GPIO_MISC4_BASE               (TROUT_GPIO_START + 0x10)
+#define TROUT_GPIO_MISC5_BASE               (TROUT_GPIO_START + 0x18)
+#define TROUT_GPIO_INT2_BASE                (TROUT_GPIO_START + 0x20)
+#define TROUT_GPIO_MISC1_BASE               (TROUT_GPIO_START + 0x28)
+#define TROUT_GPIO_VIRTUAL_BASE             (TROUT_GPIO_START + 0x30)
+#define TROUT_GPIO_INT5_BASE                (TROUT_GPIO_START + 0x48)
+
+#define TROUT_GPIO_CHARGER_EN               (TROUT_GPIO_MISC2_BASE + 0)
+#define TROUT_GPIO_ISET                     (TROUT_GPIO_MISC2_BASE + 1)
+#define TROUT_GPIO_H2W_DAT_DIR              (TROUT_GPIO_MISC2_BASE + 2)
+#define TROUT_GPIO_H2W_CLK_DIR              (TROUT_GPIO_MISC2_BASE + 3)
+#define TROUT_GPIO_H2W_DAT_GPO              (TROUT_GPIO_MISC2_BASE + 4)
+#define TROUT_GPIO_H2W_CLK_GPO              (TROUT_GPIO_MISC2_BASE + 5)
+#define TROUT_GPIO_H2W_SEL0                 (TROUT_GPIO_MISC2_BASE + 6)
+#define TROUT_GPIO_H2W_SEL1                 (TROUT_GPIO_MISC2_BASE + 7)
+
+#define TROUT_GPIO_SPOTLIGHT_EN             (TROUT_GPIO_MISC3_BASE + 0)
+#define TROUT_GPIO_FLASH_EN                 (TROUT_GPIO_MISC3_BASE + 1)
+#define TROUT_GPIO_I2C_PULL                 (TROUT_GPIO_MISC3_BASE + 2)
+#define TROUT_GPIO_TP_I2C_PULL              (TROUT_GPIO_MISC3_BASE + 3)
+#define TROUT_GPIO_TP_EN                    (TROUT_GPIO_MISC3_BASE + 4)
+#define TROUT_GPIO_JOG_EN                   (TROUT_GPIO_MISC3_BASE + 5)
+#define TROUT_GPIO_UI_LED_EN                (TROUT_GPIO_MISC3_BASE + 6)
+#define TROUT_GPIO_QTKEY_LED_EN             (TROUT_GPIO_MISC3_BASE + 7)
+
+#define TROUT_GPIO_VCM_PWDN                 (TROUT_GPIO_MISC4_BASE + 0)
+#define TROUT_GPIO_USB_H2W_SW               (TROUT_GPIO_MISC4_BASE + 1)
+#define TROUT_GPIO_COMPASS_RST_N            (TROUT_GPIO_MISC4_BASE + 2)
+#define TROUT_GPIO_HAPTIC_EN_UP             (TROUT_GPIO_MISC4_BASE + 3)
+#define TROUT_GPIO_HAPTIC_EN_MAIN           (TROUT_GPIO_MISC4_BASE + 4)
+#define TROUT_GPIO_USB_PHY_RST_N            (TROUT_GPIO_MISC4_BASE + 5)
+#define TROUT_GPIO_WIFI_PA_RESETX           (TROUT_GPIO_MISC4_BASE + 6)
+#define TROUT_GPIO_WIFI_EN                  (TROUT_GPIO_MISC4_BASE + 7)
+
+#define TROUT_GPIO_BT_32K_EN                (TROUT_GPIO_MISC5_BASE + 0)
+#define TROUT_GPIO_MAC_32K_EN               (TROUT_GPIO_MISC5_BASE + 1)
+#define TROUT_GPIO_MDDI_32K_EN              (TROUT_GPIO_MISC5_BASE + 2)
+#define TROUT_GPIO_COMPASS_32K_EN           (TROUT_GPIO_MISC5_BASE + 3)
+
+#define TROUT_GPIO_NAVI_ACT_N               (TROUT_GPIO_INT2_BASE + 0)
+#define TROUT_GPIO_COMPASS_IRQ              (TROUT_GPIO_INT2_BASE + 1)
+#define TROUT_GPIO_SLIDING_DET              (TROUT_GPIO_INT2_BASE + 2)
+#define TROUT_GPIO_AUD_HSMIC_DET_N          (TROUT_GPIO_INT2_BASE + 3)
+#define TROUT_GPIO_SD_DOOR_N                (TROUT_GPIO_INT2_BASE + 4)
+#define TROUT_GPIO_CAM_BTN_STEP1_N          (TROUT_GPIO_INT2_BASE + 5)
+#define TROUT_GPIO_CAM_BTN_STEP2_N          (TROUT_GPIO_INT2_BASE + 6)
+#define TROUT_GPIO_TP_ATT_N                 (TROUT_GPIO_INT2_BASE + 7)
+#define TROUT_GPIO_BANK0_FIRST_INT_SOURCE   (TROUT_GPIO_NAVI_ACT_N)
+#define TROUT_GPIO_BANK0_LAST_INT_SOURCE    (TROUT_GPIO_TP_ATT_N)
+
+#define TROUT_GPIO_H2W_DAT_GPI              (TROUT_GPIO_MISC1_BASE + 0)
+#define TROUT_GPIO_H2W_CLK_GPI              (TROUT_GPIO_MISC1_BASE + 1)
+#define TROUT_GPIO_CPLD128_VER_0            (TROUT_GPIO_MISC1_BASE + 4)
+#define TROUT_GPIO_CPLD128_VER_1            (TROUT_GPIO_MISC1_BASE + 5)
+#define TROUT_GPIO_CPLD128_VER_2            (TROUT_GPIO_MISC1_BASE + 6)
+#define TROUT_GPIO_CPLD128_VER_3            (TROUT_GPIO_MISC1_BASE + 7)
+
+#define TROUT_GPIO_SDMC_CD_N                (TROUT_GPIO_VIRTUAL_BASE + 0)
+#define TROUT_GPIO_END                      (TROUT_GPIO_SDMC_CD_N)
+#define TROUT_GPIO_BANK1_FIRST_INT_SOURCE   (TROUT_GPIO_SDMC_CD_N)
+#define TROUT_GPIO_BANK1_LAST_INT_SOURCE    (TROUT_GPIO_SDMC_CD_N)
+
+#define TROUT_GPIO_VIRTUAL_TO_REAL_OFFSET \
+	(TROUT_GPIO_INT5_BASE - TROUT_GPIO_VIRTUAL_BASE)
+
+#define TROUT_INT_START (NR_MSM_IRQS + NR_GPIO_IRQS)
+#define TROUT_INT_BANK0_COUNT (8)
+#define TROUT_INT_BANK1_START (TROUT_INT_START + TROUT_INT_BANK0_COUNT)
+#define TROUT_INT_BANK1_COUNT (1)
+#define TROUT_INT_END (TROUT_INT_START + TROUT_INT_BANK0_COUNT + \
+			TROUT_INT_BANK1_COUNT - 1)
+#define TROUT_GPIO_TO_INT(n) (((n) <= TROUT_GPIO_BANK0_LAST_INT_SOURCE) ? \
+	(TROUT_INT_START - TROUT_GPIO_BANK0_FIRST_INT_SOURCE + (n)) : \
+	(TROUT_INT_BANK1_START - TROUT_GPIO_BANK1_FIRST_INT_SOURCE + (n)))
+
+#define TROUT_INT_TO_BANK(n) ((n - TROUT_INT_START) / TROUT_INT_BANK0_COUNT)
+#define TROUT_INT_TO_MASK(n) (1U << ((n - TROUT_INT_START) & 7))
+#define TROUT_BANK_TO_MASK_REG(bank) \
+	(bank ? TROUT_GPIO_INT_MASK1_REG : TROUT_GPIO_INT_MASK0_REG)
+#define TROUT_BANK_TO_STAT_REG(bank) \
+	(bank ? TROUT_GPIO_INT_STAT1_REG : TROUT_GPIO_INT_STAT0_REG)
diff --git a/arch/arm/mach-msm/devices.c b/arch/arm/mach-msm/devices.c
index 31b6b30..afec7c2 100644
--- a/arch/arm/mach-msm/devices.c
+++ b/arch/arm/mach-msm/devices.c
@@ -155,6 +155,7 @@ struct platform_device msm_device_smd = {
 	.id	= -1,
 };
 
+
 static struct resource resources_sdc1[] = {
 	{
 		.start	= MSM_SDC1_PHYS,
@@ -163,8 +164,19 @@ static struct resource resources_sdc1[] = {
 	},
 	{
 		.start	= INT_SDC1_0,
+		.end	= INT_SDC1_0,
+		.flags	= IORESOURCE_IRQ,
+		.name	= "cmd_irq",
+	},
+	{
+		.start	= INT_SDC1_1,
 		.end	= INT_SDC1_1,
 		.flags	= IORESOURCE_IRQ,
+		.name	= "pio_irq",
+	},
+	{
+		.flags	= IORESOURCE_IRQ | IORESOURCE_DISABLED,
+		.name	= "status_irq"
 	},
 	{
 		.start	= 8,
@@ -181,8 +193,19 @@ static struct resource resources_sdc2[] = {
 	},
 	{
 		.start	= INT_SDC2_0,
+		.end	= INT_SDC2_0,
+		.flags	= IORESOURCE_IRQ,
+		.name	= "cmd_irq",
+	},
+		{
+		.start	= INT_SDC2_1,
 		.end	= INT_SDC2_1,
 		.flags	= IORESOURCE_IRQ,
+		.name	= "pio_irq",
+	},
+	{
+		.flags	= IORESOURCE_IRQ | IORESOURCE_DISABLED,
+		.name	= "status_irq"
 	},
 	{
 		.start	= 8,
@@ -199,8 +222,19 @@ static struct resource resources_sdc3[] = {
 	},
 	{
 		.start	= INT_SDC3_0,
+		.end	= INT_SDC3_0,
+		.flags	= IORESOURCE_IRQ,
+		.name	= "cmd_irq",
+	},
+		{
+		.start	= INT_SDC3_1,
 		.end	= INT_SDC3_1,
 		.flags	= IORESOURCE_IRQ,
+		.name	= "pio_irq",
+	},
+	{
+		.flags	= IORESOURCE_IRQ | IORESOURCE_DISABLED,
+		.name	= "status_irq"
 	},
 	{
 		.start	= 8,
@@ -217,8 +251,19 @@ static struct resource resources_sdc4[] = {
 	},
 	{
 		.start	= INT_SDC4_0,
+		.end	= INT_SDC4_0,
+		.flags	= IORESOURCE_IRQ,
+		.name	= "cmd_irq",
+	},
+		{
+		.start	= INT_SDC4_1,
 		.end	= INT_SDC4_1,
 		.flags	= IORESOURCE_IRQ,
+		.name	= "pio_irq",
+	},
+	{
+		.flags	= IORESOURCE_IRQ | IORESOURCE_DISABLED,
+		.name	= "status_irq"
 	},
 	{
 		.start	= 8,
@@ -266,3 +311,35 @@ struct platform_device msm_device_sdc4 = {
 		.coherent_dma_mask	= 0xffffffff,
 	},
 };
+
+
+static struct platform_device *msm_sdcc_devices[] __initdata = {
+	&msm_device_sdc1,
+	&msm_device_sdc2,
+	&msm_device_sdc3,
+	&msm_device_sdc4,
+};
+
+int __init msm_add_sdcc(unsigned int controller, struct mmc_platform_data *plat,
+			unsigned int stat_irq, unsigned long stat_irq_flags)
+{
+	struct platform_device	*pdev;
+	struct resource *res;
+
+	if (controller < 1 || controller > 4)
+		return -EINVAL;
+
+	pdev = msm_sdcc_devices[controller-1];
+	pdev->dev.platform_data = plat;
+
+	res = platform_get_resource_byname(pdev, IORESOURCE_IRQ, "status_irq");
+	if (!res)
+		return -EINVAL;
+	else if (stat_irq) {
+		res->start = res->end = stat_irq;
+		res->flags &= ~IORESOURCE_DISABLED;
+		res->flags |= stat_irq_flags;
+	}
+
+	return platform_device_register(pdev);
+}
diff --git a/arch/arm/mach-msm/generic_gpio.c b/arch/arm/mach-msm/generic_gpio.c
new file mode 100644
index 0000000..fe24d38
--- /dev/null
+++ b/arch/arm/mach-msm/generic_gpio.c
@@ -0,0 +1,274 @@
+/* arch/arm/mach-msm/generic_gpio.c
+ *
+ * Copyright (C) 2007 Google, Inc.
+ *
+ * This software is licensed under the terms of the GNU General Public
+ * License version 2, as published by the Free Software Foundation, and
+ * may be copied, distributed, and modified under those terms.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ */
+
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/errno.h>
+#include <linux/slab.h>
+#include <linux/spinlock.h>
+#include <asm/gpio.h>
+#include "gpio_chip.h"
+
+#define GPIO_NUM_TO_CHIP_INDEX(gpio) ((gpio)>>5)
+
+struct gpio_state {
+	unsigned long flags;
+	int refcount;
+};
+
+static DEFINE_SPINLOCK(gpio_chips_lock);
+static LIST_HEAD(gpio_chip_list);
+static struct gpio_chip **gpio_chip_array;
+static unsigned long gpio_chip_array_size;
+
+int register_gpio_chip(struct gpio_chip *new_gpio_chip)
+{
+	int err = 0;
+	struct gpio_chip *gpio_chip;
+	int i;
+	unsigned long irq_flags;
+	unsigned int chip_array_start_index, chip_array_end_index;
+
+	new_gpio_chip->state = kzalloc((new_gpio_chip->end + 1 - new_gpio_chip->start) * sizeof(new_gpio_chip->state[0]), GFP_KERNEL);
+	if (new_gpio_chip->state == NULL) {
+		printk(KERN_ERR "register_gpio_chip: failed to allocate state\n");
+		return -ENOMEM;
+	}
+
+	spin_lock_irqsave(&gpio_chips_lock, irq_flags);
+	chip_array_start_index = GPIO_NUM_TO_CHIP_INDEX(new_gpio_chip->start);
+	chip_array_end_index = GPIO_NUM_TO_CHIP_INDEX(new_gpio_chip->end);
+	if (chip_array_end_index >= gpio_chip_array_size) {
+		struct gpio_chip **new_gpio_chip_array;
+		unsigned long new_gpio_chip_array_size = chip_array_end_index + 1;
+
+		new_gpio_chip_array = kmalloc(new_gpio_chip_array_size * sizeof(new_gpio_chip_array[0]), GFP_ATOMIC);
+		if (new_gpio_chip_array == NULL) {
+			printk(KERN_ERR "register_gpio_chip: failed to allocate array\n");
+			err = -ENOMEM;
+			goto failed;
+		}
+		for (i = 0; i < gpio_chip_array_size; i++)
+			new_gpio_chip_array[i] = gpio_chip_array[i];
+		for (i = gpio_chip_array_size; i < new_gpio_chip_array_size; i++)
+			new_gpio_chip_array[i] = NULL;
+		gpio_chip_array = new_gpio_chip_array;
+		gpio_chip_array_size = new_gpio_chip_array_size;
+	}
+	list_for_each_entry(gpio_chip, &gpio_chip_list, list) {
+		if (gpio_chip->start > new_gpio_chip->end) {
+			list_add_tail(&new_gpio_chip->list, &gpio_chip->list);
+			goto added;
+		}
+		if (gpio_chip->end >= new_gpio_chip->start) {
+			printk(KERN_ERR "register_gpio_source %u-%u overlaps with %u-%u\n",
+			       new_gpio_chip->start, new_gpio_chip->end,
+			       gpio_chip->start, gpio_chip->end);
+			err = -EBUSY;
+			goto failed;
+		}
+	}
+	list_add_tail(&new_gpio_chip->list, &gpio_chip_list);
+added:
+	for (i = chip_array_start_index; i <= chip_array_end_index; i++) {
+		if (gpio_chip_array[i] == NULL || gpio_chip_array[i]->start > new_gpio_chip->start)
+			gpio_chip_array[i] = new_gpio_chip;
+	}
+failed:
+	spin_unlock_irqrestore(&gpio_chips_lock, irq_flags);
+	if (err)
+		kfree(new_gpio_chip->state);
+	return err;
+}
+
+static struct gpio_chip *get_gpio_chip_locked(unsigned int gpio)
+{
+	unsigned long i;
+	struct gpio_chip *chip;
+
+	i = GPIO_NUM_TO_CHIP_INDEX(gpio);
+	if (i >= gpio_chip_array_size)
+		return NULL;
+	chip = gpio_chip_array[i];
+	if (chip == NULL)
+		return NULL;
+	list_for_each_entry_from(chip, &gpio_chip_list, list) {
+		if (gpio < chip->start)
+			return NULL;
+		if (gpio <= chip->end)
+			return chip;
+	}
+	return NULL;
+}
+
+static int request_gpio(unsigned int gpio, unsigned long flags)
+{
+	int err = 0;
+	struct gpio_chip *chip;
+	unsigned long irq_flags;
+	unsigned long chip_index;
+
+	spin_lock_irqsave(&gpio_chips_lock, irq_flags);
+	chip = get_gpio_chip_locked(gpio);
+	if (chip == NULL) {
+		err = -EINVAL;
+		goto err;
+	}
+	chip_index = gpio - chip->start;
+	if (chip->state[chip_index].refcount == 0) {
+		chip->configure(chip, gpio, flags);
+		chip->state[chip_index].flags = flags;
+		chip->state[chip_index].refcount++;
+	} else if ((flags & IRQF_SHARED) && (chip->state[chip_index].flags & IRQF_SHARED))
+		chip->state[chip_index].refcount++;
+	else
+		err = -EBUSY;
+err:
+	spin_unlock_irqrestore(&gpio_chips_lock, irq_flags);
+	return err;
+}
+
+int gpio_request(unsigned gpio, const char *label)
+{
+	return request_gpio(gpio, 0);
+}
+EXPORT_SYMBOL(gpio_request);
+
+void gpio_free(unsigned gpio)
+{
+	struct gpio_chip *chip;
+	unsigned long irq_flags;
+	unsigned long chip_index;
+
+	spin_lock_irqsave(&gpio_chips_lock, irq_flags);
+	chip = get_gpio_chip_locked(gpio);
+	if (chip) {
+		chip_index = gpio - chip->start;
+		chip->state[chip_index].refcount--;
+	}
+	spin_unlock_irqrestore(&gpio_chips_lock, irq_flags);
+}
+EXPORT_SYMBOL(gpio_free);
+
+static int gpio_get_irq_num(unsigned int gpio, unsigned int *irqp, unsigned long *irqnumflagsp)
+{
+	int ret = -ENOTSUPP;
+	struct gpio_chip *chip;
+	unsigned long irq_flags;
+
+	spin_lock_irqsave(&gpio_chips_lock, irq_flags);
+	chip = get_gpio_chip_locked(gpio);
+	if (chip && chip->get_irq_num)
+		ret = chip->get_irq_num(chip, gpio, irqp, irqnumflagsp);
+	spin_unlock_irqrestore(&gpio_chips_lock, irq_flags);
+	return ret;
+}
+
+int gpio_to_irq(unsigned gpio)
+{
+	int ret, irq;
+	ret = gpio_get_irq_num(gpio, &irq, NULL);
+	if (ret)
+		return ret;
+	return irq;
+}
+EXPORT_SYMBOL(gpio_to_irq);
+
+int gpio_configure(unsigned int gpio, unsigned long flags)
+{
+	int ret = -ENOTSUPP;
+	struct gpio_chip *chip;
+	unsigned long irq_flags;
+
+	spin_lock_irqsave(&gpio_chips_lock, irq_flags);
+	chip = get_gpio_chip_locked(gpio);
+	if (chip)
+		ret = chip->configure(chip, gpio, flags);
+	spin_unlock_irqrestore(&gpio_chips_lock, irq_flags);
+	return ret;
+}
+EXPORT_SYMBOL(gpio_configure);
+
+int gpio_direction_input(unsigned gpio)
+{
+	return gpio_configure(gpio, GPIOF_INPUT);
+}
+EXPORT_SYMBOL(gpio_direction_input);
+
+int gpio_direction_output(unsigned gpio, int value)
+{
+	gpio_set_value(gpio, value);
+	return gpio_configure(gpio, GPIOF_DRIVE_OUTPUT);
+}
+EXPORT_SYMBOL(gpio_direction_output);
+
+int gpio_get_value(unsigned gpio)
+{
+	int ret = -ENOTSUPP;
+	struct gpio_chip *chip;
+	unsigned long irq_flags;
+
+	spin_lock_irqsave(&gpio_chips_lock, irq_flags);
+	chip = get_gpio_chip_locked(gpio);
+	if (chip && chip->read)
+		ret = chip->read(chip, gpio);
+	spin_unlock_irqrestore(&gpio_chips_lock, irq_flags);
+	return ret;
+}
+EXPORT_SYMBOL(gpio_get_value);
+
+void gpio_set_value(unsigned gpio, int on)
+{
+	int ret = -ENOTSUPP;
+	struct gpio_chip *chip;
+	unsigned long irq_flags;
+
+	spin_lock_irqsave(&gpio_chips_lock, irq_flags);
+	chip = get_gpio_chip_locked(gpio);
+	if (chip && chip->write)
+		ret = chip->write(chip, gpio, on);
+	spin_unlock_irqrestore(&gpio_chips_lock, irq_flags);
+}
+EXPORT_SYMBOL(gpio_set_value);
+
+int gpio_read_detect_status(unsigned int gpio)
+{
+	int ret = -ENOTSUPP;
+	struct gpio_chip *chip;
+	unsigned long irq_flags;
+
+	spin_lock_irqsave(&gpio_chips_lock, irq_flags);
+	chip = get_gpio_chip_locked(gpio);
+	if (chip && chip->read_detect_status)
+		ret = chip->read_detect_status(chip, gpio);
+	spin_unlock_irqrestore(&gpio_chips_lock, irq_flags);
+	return ret;
+}
+EXPORT_SYMBOL(gpio_read_detect_status);
+
+int gpio_clear_detect_status(unsigned int gpio)
+{
+	int ret = -ENOTSUPP;
+	struct gpio_chip *chip;
+	unsigned long irq_flags;
+
+	spin_lock_irqsave(&gpio_chips_lock, irq_flags);
+	chip = get_gpio_chip_locked(gpio);
+	if (chip && chip->clear_detect_status)
+		ret = chip->clear_detect_status(chip, gpio);
+	spin_unlock_irqrestore(&gpio_chips_lock, irq_flags);
+	return ret;
+}
+EXPORT_SYMBOL(gpio_clear_detect_status);
diff --git a/arch/arm/mach-msm/gpio_chip.h b/arch/arm/mach-msm/gpio_chip.h
new file mode 100644
index 0000000..eab9f09
--- /dev/null
+++ b/arch/arm/mach-msm/gpio_chip.h
@@ -0,0 +1,38 @@
+/* arch/arm/mach-msm/gpio_chip.h
+ *
+ * Copyright (C) 2007 Google, Inc.
+ *
+ * This software is licensed under the terms of the GNU General Public
+ * License version 2, as published by the Free Software Foundation, and
+ * may be copied, distributed, and modified under those terms.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ */
+
+#ifndef _LINUX_GPIO_CHIP_H
+#define _LINUX_GPIO_CHIP_H
+
+#include <linux/list.h>
+
+struct gpio_chip {
+	struct list_head list;
+	struct gpio_state *state;
+
+	unsigned int start;
+	unsigned int end;
+
+	int (*configure)(struct gpio_chip *chip, unsigned int gpio, unsigned long flags);
+	int (*get_irq_num)(struct gpio_chip *chip, unsigned int gpio, unsigned int *irqp, unsigned long *irqnumflagsp);
+	int (*read)(struct gpio_chip *chip, unsigned int gpio);
+	int (*write)(struct gpio_chip *chip, unsigned int gpio, unsigned on);
+	int (*read_detect_status)(struct gpio_chip *chip, unsigned int gpio);
+	int (*clear_detect_status)(struct gpio_chip *chip, unsigned int gpio);
+};
+
+int register_gpio_chip(struct gpio_chip *gpio_chip);
+
+#endif
diff --git a/arch/arm/mach-msm/gpio_hw.h b/arch/arm/mach-msm/gpio_hw.h
new file mode 100644
index 0000000..61f410c
--- /dev/null
+++ b/arch/arm/mach-msm/gpio_hw.h
@@ -0,0 +1,100 @@
+/* arch/arm/mach-msm/gpio_hw.h
+ *
+ * Copyright (C) 2007 Google, Inc.
+ * Author: Brian Swetland <swetland@google.com>
+ *
+ * This software is licensed under the terms of the GNU General Public
+ * License version 2, as published by the Free Software Foundation, and
+ * may be copied, distributed, and modified under those terms.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ */
+
+#ifndef __ARCH_ARM_MACH_MSM_GPIO_HW_H
+#define __ARCH_ARM_MACH_MSM_GPIO_HW_H
+
+#include <mach/msm_iomap.h>
+
+/* see 80-VA736-2 Rev C pp 695-751
+**
+** These are actually the *shadow* gpio registers, since the
+** real ones (which allow full access) are only available to the
+** ARM9 side of the world.
+**
+** Since the _BASE need to be page-aligned when we're mapping them
+** to virtual addresses, adjust for the additional offset in these
+** macros.
+*/
+
+#define GPIO1_REG(off) (MSM_GPIO1_BASE + 0x800 + (off))
+#define GPIO2_REG(off) (MSM_GPIO2_BASE + 0xC00 + (off))
+
+/* output value */
+#define GPIO_OUT_0         GPIO1_REG(0x00)  /* gpio  15-0  */
+#define GPIO_OUT_1         GPIO2_REG(0x00)  /* gpio  42-16 */
+#define GPIO_OUT_2         GPIO1_REG(0x04)  /* gpio  67-43 */
+#define GPIO_OUT_3         GPIO1_REG(0x08)  /* gpio  94-68 */
+#define GPIO_OUT_4         GPIO1_REG(0x0C)  /* gpio 106-95 */
+#define GPIO_OUT_5         GPIO1_REG(0x50)  /* gpio 107-121 */
+
+/* same pin map as above, output enable */
+#define GPIO_OE_0          GPIO1_REG(0x10)
+#define GPIO_OE_1          GPIO2_REG(0x08)
+#define GPIO_OE_2          GPIO1_REG(0x14)
+#define GPIO_OE_3          GPIO1_REG(0x18)
+#define GPIO_OE_4          GPIO1_REG(0x1C)
+#define GPIO_OE_5          GPIO1_REG(0x54)
+
+/* same pin map as above, input read */
+#define GPIO_IN_0          GPIO1_REG(0x34)
+#define GPIO_IN_1          GPIO2_REG(0x20)
+#define GPIO_IN_2          GPIO1_REG(0x38)
+#define GPIO_IN_3          GPIO1_REG(0x3C)
+#define GPIO_IN_4          GPIO1_REG(0x40)
+#define GPIO_IN_5          GPIO1_REG(0x44)
+
+/* same pin map as above, 1=edge 0=level interrup */
+#define GPIO_INT_EDGE_0    GPIO1_REG(0x60)
+#define GPIO_INT_EDGE_1    GPIO2_REG(0x50)
+#define GPIO_INT_EDGE_2    GPIO1_REG(0x64)
+#define GPIO_INT_EDGE_3    GPIO1_REG(0x68)
+#define GPIO_INT_EDGE_4    GPIO1_REG(0x6C)
+#define GPIO_INT_EDGE_5    GPIO1_REG(0xC0)
+
+/* same pin map as above, 1=positive 0=negative */
+#define GPIO_INT_POS_0     GPIO1_REG(0x70)
+#define GPIO_INT_POS_1     GPIO2_REG(0x58)
+#define GPIO_INT_POS_2     GPIO1_REG(0x74)
+#define GPIO_INT_POS_3     GPIO1_REG(0x78)
+#define GPIO_INT_POS_4     GPIO1_REG(0x7C)
+#define GPIO_INT_POS_5     GPIO1_REG(0xBC)
+
+/* same pin map as above, interrupt enable */
+#define GPIO_INT_EN_0      GPIO1_REG(0x80)
+#define GPIO_INT_EN_1      GPIO2_REG(0x60)
+#define GPIO_INT_EN_2      GPIO1_REG(0x84)
+#define GPIO_INT_EN_3      GPIO1_REG(0x88)
+#define GPIO_INT_EN_4      GPIO1_REG(0x8C)
+#define GPIO_INT_EN_5      GPIO1_REG(0xB8)
+
+/* same pin map as above, write 1 to clear interrupt */
+#define GPIO_INT_CLEAR_0   GPIO1_REG(0x90)
+#define GPIO_INT_CLEAR_1   GPIO2_REG(0x68)
+#define GPIO_INT_CLEAR_2   GPIO1_REG(0x94)
+#define GPIO_INT_CLEAR_3   GPIO1_REG(0x98)
+#define GPIO_INT_CLEAR_4   GPIO1_REG(0x9C)
+#define GPIO_INT_CLEAR_5   GPIO1_REG(0xB4)
+
+/* same pin map as above, 1=interrupt pending */
+#define GPIO_INT_STATUS_0  GPIO1_REG(0xA0)
+#define GPIO_INT_STATUS_1  GPIO2_REG(0x70)
+#define GPIO_INT_STATUS_2  GPIO1_REG(0xA4)
+#define GPIO_INT_STATUS_3  GPIO1_REG(0xA8)
+#define GPIO_INT_STATUS_4  GPIO1_REG(0xAC)
+#define GPIO_INT_STATUS_5  GPIO1_REG(0xB0)
+
+#endif
diff --git a/arch/arm/mach-msm/include/mach/gpio.h b/arch/arm/mach-msm/include/mach/gpio.h
new file mode 100644
index 0000000..590573f
--- /dev/null
+++ b/arch/arm/mach-msm/include/mach/gpio.h
@@ -0,0 +1,47 @@
+/* linux/include/asm-arm/arch-msm/gpio.h
+ *
+ * Copyright (C) 2007 Google, Inc.
+ * Author: Mike Lockwood <lockwood@android.com>
+ *
+ * This software is licensed under the terms of the GNU General Public
+ * License version 2, as published by the Free Software Foundation, and
+ * may be copied, distributed, and modified under those terms.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ */
+
+#ifndef __ASM_ARCH_MSM_GPIO_H
+#define __ASM_ARCH_MSM_GPIO_H
+
+#include <linux/interrupt.h>
+
+int gpio_request(unsigned gpio, const char *label);
+void gpio_free(unsigned gpio);
+int gpio_direction_input(unsigned gpio);
+int gpio_direction_output(unsigned gpio, int value);
+int gpio_get_value(unsigned gpio);
+void gpio_set_value(unsigned gpio, int value);
+int gpio_to_irq(unsigned gpio);
+
+#include <asm-generic/gpio.h>
+
+/* extended gpio api */
+
+#define GPIOF_IRQF_MASK         0x0000ffff /* use to specify edge detection without */
+#define GPIOF_IRQF_TRIGGER_NONE 0x00010000 /* IRQF_TRIGGER_NONE is 0 which also means "as already configured" */
+#define GPIOF_INPUT             0x00020000
+#define GPIOF_DRIVE_OUTPUT      0x00040000
+#define GPIOF_OUTPUT_LOW        0x00080000
+#define GPIOF_OUTPUT_HIGH       0x00100000
+
+#define GPIOIRQF_SHARED         0x00000001 /* the irq line is shared with other inputs */
+
+extern int gpio_configure(unsigned int gpio, unsigned long flags);
+extern int gpio_read_detect_status(unsigned int gpio);
+extern int gpio_clear_detect_status(unsigned int gpio);
+
+#endif
diff --git a/drivers/mmc/host/msm_sdcc.c b/drivers/mmc/host/msm_sdcc.c
index b31946e..7e0c1ac 100644
--- a/drivers/mmc/host/msm_sdcc.c
+++ b/drivers/mmc/host/msm_sdcc.c
@@ -69,6 +69,7 @@ msmsdcc_request_end(struct msmsdcc_host *host, struct mmc_request *mrq)
 
 	host->curr.mrq = NULL;
 	host->curr.cmd = NULL;
+	printk("msm..._request_end\n");
 
 	if (mrq->data)
 		mrq->data->bytes_xfered = host->curr.data_xfered;
@@ -119,6 +120,7 @@ msmsdcc_dma_complete_func(struct msm_dmov_cmd *cmd,
 	unsigned long		flags;
 	struct mmc_request	*mrq;
 
+	printk("data complete func\n");
 	spin_lock_irqsave(&host->lock, flags);
 	mrq = host->curr.mrq;
 	BUG_ON(!mrq);
@@ -360,6 +362,8 @@ msmsdcc_start_command(struct msmsdcc_host *host, struct mmc_command *cmd, u32 c)
 {
 	void __iomem *base = host->base;
 
+	printk("start_command\n");
+
 	if (readl(base + MMCICOMMAND) & MCI_CPSM_ENABLE) {
 		writel(0, base + MMCICOMMAND);
 		udelay(2 + ((5 * 1000000) / host->clk_rate));
@@ -483,6 +487,7 @@ msmsdcc_pio_irq(int irq, void *dev_id)
 	void __iomem		*base = host->base;
 	uint32_t		status;
 
+	printk("msmsdcc_pio_irq\n");
 	status = readl(base + MMCISTATUS);
 
 	do {
@@ -589,6 +594,7 @@ msmsdcc_handle_irq_data(struct msmsdcc_host *host, u32 status,
 {
 	struct mmc_data *data = host->curr.data;
 
+	printk("handle_irq_data\n");
 	if (!data)
 		return;
 
@@ -696,6 +702,7 @@ msmsdcc_request(struct mmc_host *mmc, struct mmc_request *mrq)
 	WARN_ON(host->curr.mrq != NULL);
 	WARN_ON(host->pwr == 0);
 
+	printk("msm..._request\n");
 	spin_lock_irqsave(&host->lock, flags);
 
 	host->stats.reqs++;
diff --git a/kernel/printk.c b/kernel/printk.c
index 2c98b0b..5f37e88 100644
--- a/kernel/printk.c
+++ b/kernel/printk.c
@@ -714,10 +714,12 @@ asmlinkage int vprintk(const char *fmt, va_list args)
 	printed_len += vscnprintf(printk_buf + printed_len,
 				  sizeof(printk_buf) - printed_len, fmt, args);
 
+#if 0
 	{
 		extern void printascii(const char *);
 		printascii(printk_buf);
 	}
+#endif
 
 	p = printk_buf;
 

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
