Return-Path: <linux-kernel-owner+w=401wt.eu-S1755742AbYHFNXW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755742AbYHFNXW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2008 09:23:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756043AbYHFNUH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Aug 2008 09:20:07 -0400
Received: from lopsy-lu.misterjones.org ([62.4.18.26]:53648 "EHLO
	young-lust.wild-wind.fr.eu.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753694AbYHFNUA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2008 09:20:00 -0400
From: Marc Zyngier <maz@misterjones.org>
To: linux-kernel@vger.kernel.org
Cc: Amit Walambe <amit.walambe@eurotech-ltd.co.uk>,
       Dominik Brodowski <linux@dominikbrodowski.net>,
       Marc Zyngier <maz@misterjones.org>,
       Marc Zyngier <marc.zyngier@altran.com>
Subject: [PATCH 1/5] Basic support for the Arcom/Eurotech Viper SBC.
Date: Wed,  6 Aug 2008 15:19:50 +0200
Message-Id: <37f79c8da83c915c5ecc1d81cad9f4f5ae3c2b4a.1218018636.git.marc.zyngier@altran.com>
X-Mailer: git-send-email 1.5.4.3
In-Reply-To: <1218028794-850-1-git-send-email-maz@misterjones.org>
References: <>
 <1218028794-850-1-git-send-email-maz@misterjones.org>
X-SA-Exim-Connect-IP: 81.255.32.141
X-SA-Exim-Rcpt-To: linux-kernel@vger.kernel.org, amit.walambe@eurotech-ltd.co.uk, linux@dominikbrodowski.net, maz@misterjones.org, marc.zyngier@altran.com
X-SA-Exim-Mail-From: maz@misterjones.org
X-SA-Exim-Scanned: No (on young-lust.wild-wind.fr.eu.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Marc Zyngier <marc.zyngier@altran.com>
---
 arch/arm/mach-pxa/Kconfig        |    6 +
 arch/arm/mach-pxa/Makefile       |    1 +
 arch/arm/mach-pxa/viper.c        |  952 ++++++++++++++++++++++++++++++++++++++
 include/asm-arm/arch-pxa/irqs.h  |   23 +
 include/asm-arm/arch-pxa/viper.h |   91 ++++
 5 files changed, 1073 insertions(+), 0 deletions(-)
 create mode 100644 arch/arm/mach-pxa/viper.c
 create mode 100644 include/asm-arm/arch-pxa/viper.h

diff --git a/arch/arm/mach-pxa/Kconfig b/arch/arm/mach-pxa/Kconfig
index e8ee7ec..31a554e 100644
--- a/arch/arm/mach-pxa/Kconfig
+++ b/arch/arm/mach-pxa/Kconfig
@@ -115,6 +115,12 @@ config MACH_TOSA
 	depends on PXA_SHARPSL
 	select PXA25x
 
+config ARCH_VIPER
+	bool "Arcom/Eurotech VIPER SBC"
+	select PXA25x
+	select ISA
+	select I2C_GPIO
+
 config ARCH_PXA_ESERIES
 	bool "PXA based Toshiba e-series PDAs"
 	select PXA25x
diff --git a/arch/arm/mach-pxa/Makefile b/arch/arm/mach-pxa/Makefile
index 99ecbe7..c8a47cc 100644
--- a/arch/arm/mach-pxa/Makefile
+++ b/arch/arm/mach-pxa/Makefile
@@ -43,6 +43,7 @@ obj-$(CONFIG_MACH_E750)		+= e750_lcd.o
 obj-$(CONFIG_MACH_E400)		+= e400_lcd.o
 obj-$(CONFIG_MACH_E800)		+= e800_lcd.o
 obj-$(CONFIG_MACH_PALMTX)	+= palmtx.o
+obj-$(CONFIG_ARCH_VIPER)	+= viper.o
 
 ifeq ($(CONFIG_MACH_ZYLONITE),y)
   obj-y				+= zylonite.o
diff --git a/arch/arm/mach-pxa/viper.c b/arch/arm/mach-pxa/viper.c
new file mode 100644
index 0000000..7c1d9a0
--- /dev/null
+++ b/arch/arm/mach-pxa/viper.c
@@ -0,0 +1,952 @@
+/*
+ *  linux/arch/arm/mach-pxa/viper.c
+ *
+ *  Support for the Arcom VIPER SBC.
+ *
+ *  Author:	Ian Campbell
+ *  Created:    Feb 03, 2003
+ *  Copyright:  Arcom Control Systems
+ *
+ *  Maintained by Marc Zyngier <maz@misterjones.org>
+ *                             <marc.zyngier@altran.com>
+ *
+ * Based on lubbock.c:
+ *  Author:	Nicolas Pitre
+ *  Created:	Jun 15, 2001
+ *  Copyright:	MontaVista Software Inc.
+ *
+ *  This program is free software; you can redistribute it and/or modify
+ *  it under the terms of the GNU General Public License version 2 as
+ *  published by the Free Software Foundation.
+ */
+
+#include <linux/types.h>
+#include <linux/memory.h>
+#include <linux/cpu.h>
+#include <linux/cpufreq.h>
+#include <linux/delay.h>
+#include <linux/fs.h>
+#include <linux/init.h>
+#include <linux/interrupt.h>
+#include <linux/major.h>
+#include <linux/module.h>
+#include <linux/pm.h>
+#include <linux/sched.h>
+#include <linux/gpio.h>
+#include <linux/i2c-gpio.h>
+#include <linux/serial_8250.h>
+#include <linux/smc91x.h>
+#include <linux/usb/isp116x.h>
+#include <linux/mtd/mtd.h>
+#include <linux/mtd/partitions.h>
+
+#include <asm/arch/pxa-regs.h>
+#include <asm/arch/pxa2xx-regs.h>
+#include <asm/arch/bitfield.h>
+#include <asm/arch/audio.h>
+#include <asm/arch/pxafb.h>
+#include <asm/arch/mfp-pxa25x.h>
+#include <asm/arch/i2c.h>
+#include <asm/arch/viper.h>
+
+#include <asm/setup.h>
+#include <asm/mach-types.h>
+#include <asm/irq.h>
+#include <asm/sizes.h>
+
+#include <asm/mach/arch.h>
+#include <asm/mach/map.h>
+#include <asm/mach/irq.h>
+#include <asm/mach/flash.h>
+
+#include "generic.h"
+
+#ifdef VIPER_DEBUG_INTR
+#define DEBUG_INTR(fmt...)	printk(fmt)
+#else
+#define DEBUG_INTR(fmt...)	do { } while (0)
+#endif
+
+#ifdef VIPER_DEBUG_VCORE
+#define DEBUG_VCORE(fmt...)	printk(fmt)
+#else
+#define DEBUG_VCORE(fmt...)	do { } while (0)
+#endif
+
+#define VIPER_ICR __VIPER_CPLD_REG(_VIPER_ICR_PHYS)
+
+static unsigned int icr;
+
+void viper_icr_set_bit(unsigned int bit)
+{
+	icr |= bit;
+	VIPER_ICR = icr;
+}
+EXPORT_SYMBOL(viper_icr_set_bit);
+
+void viper_icr_clear_bit(unsigned int bit)
+{
+	icr &= ~bit;
+	VIPER_ICR = icr;
+}
+EXPORT_SYMBOL(viper_icr_clear_bit);
+
+/*
+ * The CPLD version register was not present on VIPER boards prior to
+ * v2i1. On v1 boards where the version register is not present we
+ * will just read back the previous value from the databus.
+ *
+ * Therefore we do two reads. The first time we write 0 to the
+ * (read-only) register before reading and the second time we write
+ * 0xff first. If the two reads do not match or they read back as 0xff
+ * or 0x00 then we have version 1 hardware.
+ */
+#define VIPER_VERSION	__VIPER_CPLD_REG(_VIPER_VERSION_PHYS)
+static u8 viper_hw_version(void)
+{
+	u8 v1, v2;
+	unsigned long flags;
+
+	local_irq_save(flags);
+
+	VIPER_VERSION = 0;
+	v1 = VIPER_VERSION;
+	VIPER_VERSION = 0xff;
+	v2 = VIPER_VERSION;
+
+	if (v1 != v2) { /* a v1i6 board */
+		v1 = 0;
+	} else if (v1 /* ==v2 */ == 0xff) { /* a v1i6 board */
+		v1 = 0;
+	}
+
+	local_irq_restore(flags);
+	return v1;
+}
+
+/* CPU sysdev */
+static int viper_cpu_suspend(struct sys_device *sysdev, pm_message_t state)
+{
+	viper_icr_set_bit(VIPER_ICR_R_DIS);
+	return 0;
+}
+
+static int viper_cpu_resume(struct sys_device *sysdev)
+{
+	viper_icr_clear_bit(VIPER_ICR_R_DIS);
+	return 0;
+}
+
+static struct sysdev_driver viper_cpu_sysdev_driver = {
+	.suspend	= viper_cpu_suspend,
+	.resume		= viper_cpu_resume,
+};
+
+/* Interrupt handling */
+static unsigned long viper_irq_enabled_mask;
+
+static void viper_ack_irq(unsigned int irq)
+{
+	int viper_irq = (irq - VIPER_IRQ(0));
+
+	if (viper_irq < 8) {
+		DEBUG_INTR(KERN_DEBUG "viper_ack_irq: acknowledge lo irq %d "
+			   "(number %d) with 0x%x => %p\n",
+			   irq, viper_irq, 1 << viper_irq,
+			   &VIPER_LO_IRQ_STATUS);
+		VIPER_LO_IRQ_STATUS = 1 << viper_irq;
+	} else {
+		DEBUG_INTR(KERN_DEBUG "viper_ack_irq: acknowledge hi irq %d "
+			   "(number %d) with 0x%x => %p\n",
+			   irq, viper_irq, 1 << (viper_irq - 8),
+			   &VIPER_HI_IRQ_STATUS);
+		VIPER_HI_IRQ_STATUS = 1 << (viper_irq-8);
+	}
+}
+
+static void viper_mask_irq(unsigned int irq)
+{
+	int viper_irq = (irq - VIPER_IRQ(0));
+	viper_irq_enabled_mask &= ~(1 << viper_irq);
+}
+
+static void viper_unmask_irq(unsigned int irq)
+{
+	int viper_irq = (irq - VIPER_IRQ(0));
+	viper_irq_enabled_mask |= (1 << viper_irq);
+}
+
+static inline unsigned long viper_irq_pending(void)
+{
+	u8 hi, lo;
+	unsigned long result;
+
+	hi = VIPER_HI_IRQ_STATUS;
+	lo = VIPER_LO_IRQ_STATUS;
+	result = lo;
+	result |= hi<<8;
+	result &= viper_irq_enabled_mask;
+	return result;
+}
+
+static void viper_irq_handler(unsigned int irq, struct irq_desc *desc)
+{
+	unsigned long pending;
+
+	DEBUG_INTR(KERN_DEBUG "viper_irq_handler: entry\n");
+
+	pending = viper_irq_pending();
+	do {
+		DEBUG_INTR(KERN_DEBUG "viper_irq_handler: pending 0x%lx\n",
+			   pending);
+		GEDR(VIPER_CPLD_GPIO) = GPIO_bit(VIPER_CPLD_GPIO);
+		if (likely(pending)) {
+			irq = VIPER_IRQ(0) + __ffs(pending);
+#ifdef VIPER_DEBUG_INTR
+			desc = irq_desc + irq;
+			DEBUG_INTR(KERN_DEBUG
+			       "viper_irq_handler: dispatching IRQ %d to %p\n",
+			       irq, desc->handle);
+#endif
+			generic_handle_irq(irq);
+		}
+		pending = viper_irq_pending();
+	} while (pending);
+	DEBUG_INTR(KERN_DEBUG "viper_irq_handler: exit\n");
+}
+
+static unsigned int current_voltage_divisor;
+
+/*
+ * If force is not true then step from existing to new divisor. If
+ * force is true then jump straight to the new divisor. Stepping is
+ * used because if the jump in voltage is too large, the VCC can dip
+ * too low and the regulator cuts out.
+ *
+ * force can be used to initialize the divisor to a know state by
+ * setting the value for the current clock speed, since we are already
+ * running at that speed we know the voltage should be pretty close so
+ * the jump won't be too large
+ */
+static void viper_set_core_cpu_voltage(unsigned long khz, int force)
+{
+	int i = 0;
+	unsigned int divisor = 0;
+	const char *v;
+
+	if (khz < 200000) {
+		v = "1.0"; divisor = 0xfff;
+	} else if (khz < 300000) {
+		v = "1.1"; divisor = 0xde5;
+	} else {
+		v = "1.3"; divisor = 0x325;
+	}
+
+	DEBUG_VCORE(KERN_INFO
+		    "viper: setting CPU core voltage to %sV at %d.%03dMHz\n",
+		    v, (int)khz / 1000, (int)khz % 1000);
+
+#define STEP 0x100
+	do {
+		int step;
+
+		if (force)
+			step = divisor;
+		else if (current_voltage_divisor < divisor - STEP)
+			step = current_voltage_divisor + STEP;
+		else if (current_voltage_divisor > divisor + STEP)
+			step = current_voltage_divisor - STEP;
+		else
+			step = divisor;
+		force = 0;
+
+		gpio_set_value(VIPER_PSU_CLK_GPIO, 0);
+		gpio_set_value(VIPER_PSU_nCS_LD_GPIO, 0);
+
+		for (i = 1 << 11 ; i > 0 ; i >>= 1) {
+			udelay(1);
+			if (step & i)
+				gpio_set_value(VIPER_PSU_DATA_GPIO, 1);
+			else
+				gpio_set_value(VIPER_PSU_DATA_GPIO, 0);
+			udelay(1);
+
+			gpio_set_value(VIPER_PSU_CLK_GPIO, 1);
+			udelay(1);
+
+			gpio_set_value(VIPER_PSU_CLK_GPIO, 0);
+		}
+		udelay(1);
+
+		gpio_set_value(VIPER_PSU_nCS_LD_GPIO, 1);
+		udelay(1);
+
+		gpio_set_value(VIPER_PSU_nCS_LD_GPIO, 0);
+
+		current_voltage_divisor = step;
+	} while (current_voltage_divisor != divisor);
+}
+
+#ifdef CONFIG_CPU_FREQ
+static int
+viper_cpufreq_notifier(struct notifier_block *nb, unsigned long val,
+		       void *data)
+{
+	struct cpufreq_freqs *freq = data;
+
+	/* TODO: Adjust timings??? */
+
+	switch (val) {
+	case CPUFREQ_PRECHANGE:
+		if (freq->old < freq->new) {
+			/* we are getting faster so raise the voltage
+			 * before we change freq */
+			viper_set_core_cpu_voltage(freq->new, 0);
+		}
+		break;
+	case CPUFREQ_POSTCHANGE:
+		if (freq->old > freq->new) {
+			/* we are slowing down so drop the power
+			 * after we change freq */
+			viper_set_core_cpu_voltage(freq->new, 0);
+		}
+		break;
+	case CPUFREQ_RESUMECHANGE:
+		viper_set_core_cpu_voltage(freq->new, 0);
+		break;
+	default:
+		/* ignore */
+		break;
+	}
+
+	return 0;
+}
+
+static struct notifier_block viper_cpufreq_notifier_block = {
+	.notifier_call  = viper_cpufreq_notifier
+};
+#endif
+
+static void viper_init_cpufreq(void)
+{
+	if (gpio_request(VIPER_PSU_DATA_GPIO, "PSU data"))
+		goto err_request_data;
+
+	if (gpio_request(VIPER_PSU_CLK_GPIO, "PSU clock"))
+		goto err_request_clk;
+
+	if (gpio_request(VIPER_PSU_nCS_LD_GPIO, "PSU cs"))
+		goto err_request_cs;
+
+	if (gpio_direction_output(VIPER_PSU_DATA_GPIO, 0) ||
+	    gpio_direction_output(VIPER_PSU_CLK_GPIO, 0) ||
+	    gpio_direction_output(VIPER_PSU_nCS_LD_GPIO, 0))
+		goto err_dir;
+
+	if (!cpufreq_register_notifier(&viper_cpufreq_notifier_block,
+				       CPUFREQ_TRANSITION_NOTIFIER))
+		return;
+
+err_dir:
+	gpio_free(VIPER_PSU_nCS_LD_GPIO);
+err_request_cs:
+	gpio_free(VIPER_PSU_CLK_GPIO);
+err_request_clk:
+	gpio_free(VIPER_PSU_DATA_GPIO);
+err_request_data:
+	printk(KERN_ERR "viper: Failed to setup cpufreq\n");
+}
+
+static struct irq_chip viper_irq_chip = {
+	.ack	= viper_ack_irq,
+	.mask	= viper_mask_irq,
+	.unmask	= viper_unmask_irq
+};
+
+static void __init viper_init_irq(void)
+{
+	const int isa_irqs[] = { 3, 4, 5, 6, 7, 10, 11, 12, 9, 14, 15 };
+	int irq;
+
+	pxa25x_init_irq();
+
+	/* setup ISA IRQs */
+	for (irq = VIPER_IRQ(0); irq < VIPER_IRQ(0) + 11; irq++) {
+		printk(KERN_INFO "Map ISA IRQ %d to IRQ %d\n",
+		       isa_irqs[irq - VIPER_IRQ(0)], irq);
+		set_irq_chip(irq, &viper_irq_chip);
+		set_irq_handler(irq, handle_edge_irq);
+		set_irq_flags(irq, IRQF_VALID | IRQF_PROBE);
+	}
+
+	set_irq_chained_handler(VIPER_CPLD_IRQ, viper_irq_handler);
+	set_irq_type(VIPER_CPLD_IRQ, IRQ_TYPE_EDGE_BOTH);
+
+	/* Peripheral IRQs
+	 * Ethernet has been moved to resources */
+	set_irq_type(VIPER_USB_IRQ, IRQ_TYPE_EDGE_RISING);
+	set_irq_type(VIPER_UARTA_IRQ, IRQ_TYPE_EDGE_RISING);
+	set_irq_type(VIPER_UARTB_IRQ, IRQ_TYPE_EDGE_RISING);
+
+	/* GPIO9 and 10 control FB backlight. Initialise to off */
+	if (gpio_request(VIPER_BCKLIGHT_EN_GPIO, "Backlight"))
+		goto err_request_bckl;
+
+	if (gpio_request(VIPER_LCD_EN_GPIO, "LCD"))
+		goto err_request_lcd;
+
+	/* Setup Backlight control on PWM0 */
+	if (gpio_request(VIPER_PWM0_GPIO, "Backlight control"))
+		goto err_request_bc;
+
+	if (gpio_direction_output(VIPER_BCKLIGHT_EN_GPIO, 0) ||
+	    gpio_direction_output(VIPER_LCD_EN_GPIO, 0) ||
+	    gpio_direction_output(VIPER_PWM0_GPIO, 0))
+		goto err_dir;
+
+	PWM_CTRL1 = 4; /* 1 Msec. */
+
+	return;
+
+err_dir:
+	gpio_free(VIPER_PWM0_GPIO);
+err_request_bc:
+	gpio_free(VIPER_LCD_EN_GPIO);
+err_request_lcd:
+	gpio_free(VIPER_BCKLIGHT_EN_GPIO);
+err_request_bckl:
+	printk(KERN_ERR "viper: Failed to setup LCD GPIOs\n");
+}
+
+static void viper_power_off(void)
+{
+	printk(KERN_NOTICE "Shutting off UPS\n");
+	local_irq_disable();
+	gpio_set_value(VIPER_UPS_GPIO, 1);
+	while (1) {
+		/*
+		 * Spin
+		 */
+	}
+}
+
+/* Audio */
+static struct platform_device audio_device = {
+	.name           = "pxa2xx-ac97",
+	.id             = -1,
+};
+
+/* Flat Panel */
+static void viper_lcd_power(int on, struct fb_var_screeninfo *var)
+{
+	/* fb_var_screeninfo is currently unused */
+	if (on)
+		gpio_set_value(VIPER_LCD_EN_GPIO, 1);
+	else
+		gpio_set_value(VIPER_LCD_EN_GPIO, 0);
+}
+
+static void viper_backlight_power(int on)
+{
+	if (on) {
+		gpio_set_value(VIPER_BCKLIGHT_EN_GPIO, 1);
+		/* Set full brightness */
+		gpio_set_value(VIPER_PWM0_GPIO, 0);
+	} else {
+		gpio_set_value(VIPER_BCKLIGHT_EN_GPIO, 0);
+		gpio_set_value(VIPER_PWM0_GPIO, 1);
+	}
+}
+
+static struct pxafb_mode_info fb_mode_info = {
+	.pixclock	= 157500,
+
+	.xres		= 320,
+	.yres		= 240,
+
+	.bpp		= 16,
+
+	.hsync_len	= 63,
+	.left_margin	= 7,
+	.right_margin	= 13,
+
+	.vsync_len	= 20,
+	.upper_margin	= 1,
+	.lower_margin	= 1,
+
+	.sync		= 0,
+};
+
+static struct pxafb_mach_info fb_info = {
+	.modes     = &fb_mode_info,
+	.num_modes = 1,
+	.lccr0	   = LCCR0_Act | LCCR0_Color,
+	.lccr3	   = LCCR3_OutEnH | LCCR3_PixFlEdg | LCCR3_Acb(0xFF),
+
+	.pxafb_lcd_power = viper_lcd_power,
+	.pxafb_backlight_power = viper_backlight_power,
+};
+
+/* Ethernet */
+static struct resource smc91x_resources[] = {
+	[0] = {
+		.name	= "smc91x-regs",
+		.start  = VIPER_ETH_PHYS + 0x300,
+		.end    = VIPER_ETH_PHYS + 0x30f,
+		.flags  = IORESOURCE_MEM,
+	},
+	[1] = {
+		.start  = VIPER_ETH_IRQ,
+		.end    = VIPER_ETH_IRQ,
+		.flags  = (IORESOURCE_IRQ | IORESOURCE_IRQ_HIGHEDGE),
+	},
+	[2] = {
+		.name	= "smc91x-data32",
+		.start  = VIPER_ETH_DATA_PHYS,
+		.end    = VIPER_ETH_DATA_PHYS + 3,
+		.flags  = IORESOURCE_MEM,
+	},
+};
+
+static struct smc91x_platdata viper_smc91x_info = {
+	.flags	= SMC91X_USE_16BIT | SMC91X_NOWAIT,
+};
+
+static struct platform_device smc91x_device = {
+	.name	   = "smc91x",
+	.id		= -1,
+	.num_resources  = ARRAY_SIZE(smc91x_resources),
+	.resource       = smc91x_resources,
+	.dev		= {
+		.platform_data	= &viper_smc91x_info,
+	},
+};
+
+/* i2c */
+static struct i2c_gpio_platform_data i2c_bus_data = {
+	.sda_pin = VIPER_RTC_I2C_SDA_GPIO,
+	.scl_pin = VIPER_RTC_I2C_SCL_GPIO,
+	.udelay  = 10,
+	.timeout = 100,
+};
+
+static struct platform_device i2c_bus_device = {
+	.name		= "i2c-gpio",
+	.id		= 1, /* pxa2xx-i2c is bus 0, so start at 1 */
+	.dev = {
+		.platform_data = &i2c_bus_data,
+	}
+};
+
+static struct i2c_board_info __initdata viper_i2c_devices[] = {
+	{
+		I2C_BOARD_INFO("ds1338", 0x68),
+	},
+};
+
+/* serial */
+static struct resource viper_serial_resources[] = {
+	{
+		.start	= 0x40100000,
+		.end	= 0x4010001f,
+		.flags	= IORESOURCE_MEM,
+	},
+	{
+		.start	= 0x40200000,
+		.end	= 0x4020001f,
+		.flags	= IORESOURCE_MEM,
+	},
+	{
+		.start	= 0x40700000,
+		.end	= 0x4070001f,
+		.flags	= IORESOURCE_MEM,
+	},
+	{
+		.start	= VIPER_UARTA_PHYS,
+		.end	= VIPER_UARTA_PHYS + 0xf,
+		.flags	= IORESOURCE_MEM,
+	},
+	{
+		.start	= VIPER_UARTB_PHYS,
+		.end	= VIPER_UARTB_PHYS + 0xf,
+		.flags	= IORESOURCE_MEM,
+	},
+};
+
+static struct plat_serial8250_port serial_platform_data[] = {
+	/* Internal UARTs */
+	{
+		.membase	= (void *)&FFUART,
+		.mapbase	= __PREG(FFUART),
+		.irq		= IRQ_FFUART,
+		.uartclk	= 921600 * 16,
+		.regshift	= 2,
+		.flags		= UPF_BOOT_AUTOCONF | UPF_SKIP_TEST,
+		.iotype		= UPIO_MEM,
+	},
+	{
+		.membase	= (void *)&BTUART,
+		.mapbase	= __PREG(BTUART),
+		.irq		= IRQ_BTUART,
+		.uartclk	= 921600 * 16,
+		.regshift	= 2,
+		.flags		= UPF_BOOT_AUTOCONF | UPF_SKIP_TEST,
+		.iotype		= UPIO_MEM,
+	},
+	{
+		.membase	= (void *)&STUART,
+		.mapbase	= __PREG(STUART),
+		.irq		= IRQ_STUART,
+		.uartclk	= 921600 * 16,
+		.regshift	= 2,
+		.flags		= UPF_BOOT_AUTOCONF | UPF_SKIP_TEST,
+		.iotype		= UPIO_MEM,
+	},
+	/* External UARTs */
+	{
+		.mapbase	= VIPER_UARTA_PHYS,
+		.irq		= VIPER_UARTA_IRQ,
+		.uartclk	= 1843200,
+		.regshift	= 1,
+		.iotype		= UPIO_MEM,
+		.flags		= UPF_BOOT_AUTOCONF | UPF_IOREMAP |
+				  UPF_SKIP_TEST,
+	},
+	{
+		.mapbase	= VIPER_UARTB_PHYS,
+		.irq		= VIPER_UARTB_IRQ,
+		.uartclk	= 1843200,
+		.regshift	= 1,
+		.iotype		= UPIO_MEM,
+		.flags		= UPF_BOOT_AUTOCONF | UPF_IOREMAP |
+				  UPF_SKIP_TEST,
+	},
+	{ },
+};
+
+static struct platform_device serial_device = {
+	.name			= "serial8250",
+	.id			= 0,
+	.dev			= {
+		.platform_data	= serial_platform_data,
+	},
+	.num_resources		= ARRAY_SIZE(viper_serial_resources),
+	.resource		= viper_serial_resources,
+};
+
+/* USB */
+static void isp116x_delay(struct device *dev, int delay)
+{
+	/* On this platform, we work with 200MHz clock, giving
+	   5 ns per instruction. The cycle below involves 2
+	   instructions and we lose 2 more instruction times due
+	   to pipeline flush at a jump. I.e., we consume 20 ns
+	   per cycle.
+	*/
+	int cyc = delay/20 + 1;
+	cyc <<= 2; /* actually, 400MHz */
+
+	__asm__ volatile ("0:\n"
+			  "     subs  %0, %1, #1\n"
+			  "     bge   0b\n"
+			  : "=r" (cyc)
+			  : "0"  (cyc)
+		);
+}
+
+static struct resource isp116x_resources[] = {
+	[0] = { /* DATA */
+		.start  = VIPER_USB_PHYS + 0,
+		.end    = VIPER_USB_PHYS + 1,
+		.flags  = IORESOURCE_MEM,
+	},
+	[1] = { /* ADDR */
+		.start  = VIPER_USB_PHYS + 2,
+		.end    = VIPER_USB_PHYS + 3,
+		.flags  = IORESOURCE_MEM,
+	},
+	[2] = {
+		.start  = VIPER_USB_IRQ,
+		.end    = VIPER_USB_IRQ,
+		.flags  = IORESOURCE_IRQ,
+	},
+};
+
+/* (DataBusWidth16|AnalogOCEnable|DREQOutputPolarity|DownstreamPort15KRSel ) */
+static struct isp116x_platform_data isp116x_platform_data = {
+	/* Enable internal resistors on downstream ports */
+	.sel15Kres		= 1,
+	/* On-chip overcurrent protection */
+	.oc_enable		= 1,
+	/* INT output polarity */
+	.int_act_high		= 1,
+	/* INT edge or level triggered */
+	.int_edge_triggered	= 0,
+
+	/* WAKEUP pin connected - NOT SUPPORTED  */
+	/* .remote_wakeup_connected = 0, */
+	/* Wakeup by devices on usb bus enabled */
+	.remote_wakeup_enable	= 0,
+	.delay			= isp116x_delay,
+};
+
+static struct platform_device isp116x_device = {
+	.name			= "isp116x-hcd",
+	.id			= -1,
+	.num_resources  	= ARRAY_SIZE(isp116x_resources),
+	.resource       	= isp116x_resources,
+	.dev			= {
+		.platform_data	= &isp116x_platform_data,
+	},
+
+};
+
+static struct resource sram_resource = {
+	.start		= _VIPER_SRAM_BASE,
+	.end		= _VIPER_SRAM_BASE + SZ_256K - 1,
+	.flags		= IORESOURCE_MEM,
+};
+
+static struct platform_device sram_device = {
+	.name		= "pxa2xx-8bit-sram",
+	.id		= 0,
+	.num_resources	= 1,
+	.resource	= &sram_resource,
+};
+
+static struct resource flash_resources[] = {
+	[0] = {	/* RedBoot config + filesystem flash */
+		.start	= VIPER_FLASH_PHYS,
+		.end	= VIPER_FLASH_PHYS + SZ_32M - 1,
+		.flags	= IORESOURCE_MEM,
+	},
+	[1] = {	/* Boot flash */
+		.start	= VIPER_BOOT_PHYS,
+		.end	= VIPER_BOOT_PHYS + SZ_1M - 1,
+		.flags	= IORESOURCE_MEM,
+	},
+};
+
+static struct mtd_partition viper_boot_flash_partition = {
+	.name		= "RedBoot",
+	.size		= SZ_1M,
+	.offset		= 0,
+	.mask_flags	= MTD_WRITEABLE,	/* force R/O */
+};
+
+static struct flash_platform_data viper_flash_data[] = {
+	[0] = {
+		.name		= "ViperFlash",
+		.map_name	= "cfi_probe",
+		.width		= 2,
+		.parts		= NULL,
+		.nr_parts	= 0,
+	},
+	[1] = {
+		.name		= "ViperBootFlash",
+		.map_name	= "jedec_probe",
+		.width		= 2,
+		.parts		= &viper_boot_flash_partition,
+		.nr_parts	= 1,
+	},
+};
+
+static struct platform_device viper_flash_devices[] = {
+	{
+		.name		= "pxa2xx-flash",
+		.id		= 0,
+		.dev		= {
+			.platform_data	= &viper_flash_data[0],
+		},
+		.resource	= &flash_resources[0],
+		.num_resources	= 1,
+	},
+	{
+		.name		= "pxa2xx-flash",
+		.id		= 1,
+		.dev		= {
+			.platform_data	= &viper_flash_data[1],
+		},
+		.resource	= &flash_resources[1],
+		.num_resources	= 1,
+	},
+};
+
+static struct platform_device *viper_devs[] __initdata = {
+	&smc91x_device,
+	&i2c_bus_device,
+	&serial_device,
+	&isp116x_device,
+	&audio_device,
+	&sram_device,
+	&viper_flash_devices[0],
+	&viper_flash_devices[1],
+};
+
+static mfp_cfg_t viper_pin_config[] __initdata = {
+	/* Chip selects */
+	GPIO15_nCS_1,
+	GPIO78_nCS_2,
+	GPIO79_nCS_3,
+	GPIO80_nCS_4,
+	GPIO33_nCS_5,
+
+	/* FP Backlight */
+	VIPER_BCKLIGHT_EN_GPIO  | MFP_DIR_OUT,
+	VIPER_LCD_EN_GPIO 	| MFP_DIR_OUT,
+	VIPER_PWM0_GPIO		| MFP_DIR_OUT,
+
+	/* Compact-Flash / PC104 */
+	VIPER_CF_POWER_GPIO	| MFP_DIR_OUT,
+	VIPER_CF_CD_GPIO,
+	VIPER_CF_RDY_GPIO,
+
+	/* Integrated UPS control */
+	VIPER_UPS_GPIO | MFP_DIR_OUT,
+
+	/* Vcc regulator control */
+	VIPER_PSU_DATA_GPIO	| MFP_DIR_OUT,
+	VIPER_PSU_CLK_GPIO	| MFP_DIR_OUT,
+	VIPER_PSU_nCS_LD_GPIO	| MFP_DIR_OUT,
+
+	/* i2c busses */
+	VIPER_TPM_I2C_SDA_GPIO,
+	VIPER_TPM_I2C_SCL_GPIO	| MFP_DIR_OUT,
+	VIPER_RTC_I2C_SDA_GPIO,
+	VIPER_RTC_I2C_SCL_GPIO	| MFP_DIR_OUT,
+};
+
+static unsigned long viper_tpm;
+
+static int __init viper_tpm_setup(char *str)
+{
+	strict_strtoul(str, 10, &viper_tpm);
+	return 1;
+}
+
+__setup("tpm=", viper_tpm_setup);
+
+static void __init viper_init(void)
+{
+	u8 version;
+
+	pm_power_off = viper_power_off;
+
+	pxa2xx_mfp_config(ARRAY_AND_SIZE(viper_pin_config));
+
+	set_pxa_fb_info(&fb_info);
+
+	/* v1 hardware cannot use the datacs line */
+	version = viper_hw_version();
+	if (version == 0)
+		smc91x_device.num_resources--;
+
+	pxa_set_i2c_info(NULL);
+	platform_add_devices(viper_devs, ARRAY_SIZE(viper_devs));
+
+	viper_init_cpufreq();
+	/* c/should assume redboot set the correct level ??? */
+	viper_set_core_cpu_voltage(get_clk_frequency_khz(0), 1);
+
+	sysdev_driver_register(&cpu_sysdev_class, &viper_cpu_sysdev_driver);
+
+	if (version) {
+		printk(KERN_INFO "viper: hardware v%di%d detected. "
+		       "CPLD revision %d.\n",
+		       VIPER_BOARD_VERSION(version),
+		       VIPER_BOARD_ISSUE(version),
+		       VIPER_CPLD_REVISION(version));
+		system_rev = (VIPER_BOARD_VERSION(version) << 8) |
+			     (VIPER_BOARD_ISSUE(version) << 4) |
+			     VIPER_CPLD_REVISION(version);
+	} else {
+		printk(KERN_INFO "viper: No version register.\n");
+	}
+
+	i2c_register_board_info(1, viper_i2c_devices,
+				ARRAY_SIZE(viper_i2c_devices));
+
+	/* Allocate TPM i2c bus if requested */
+	if (viper_tpm) {
+		struct platform_device *tpm_device;
+		struct i2c_gpio_platform_data i2c_tpm_data = {
+			.sda_pin = VIPER_TPM_I2C_SDA_GPIO,
+			.scl_pin = VIPER_TPM_I2C_SCL_GPIO,
+			.udelay  = 10,
+			.timeout = 100,
+		};
+		char *errstr;
+
+		tpm_device = platform_device_alloc("i2c-gpio", 2);
+		if (tpm_device) {
+			if (!platform_device_add_data(tpm_device,
+						      &i2c_tpm_data,
+						      sizeof(i2c_tpm_data))) {
+				if (platform_device_add(tpm_device)) {
+					errstr = "register TPM i2c bus";
+					goto error_free_tpm;
+				}
+			} else {
+				errstr = "allocate TPM i2c bus data";
+				goto error_free_tpm;
+			}
+
+			goto no_error_tpm;
+		}
+
+		errstr = "allocate TPM i2c device";
+		goto error_tpm;
+
+error_free_tpm:
+		kfree(tpm_device);
+error_tpm:
+		printk(KERN_ERR "viper: Couldn't %s, giving up\n", errstr);
+	}
+
+no_error_tpm:
+
+	return;
+}
+
+static struct map_desc viper_io_desc[] __initdata = {
+	{
+		.virtual = VIPER_CPLD_BASE,
+		.pfn     = __phys_to_pfn(VIPER_CPLD_PHYS),
+		.length  = 0x00300000,
+		.type    = MT_DEVICE,
+	},
+	{
+		.virtual = VIPER_PC104IO_BASE,
+		.pfn     = __phys_to_pfn(_PCMCIA1IO),
+		.length  = 0x00800000,
+		.type    = MT_DEVICE,
+	},
+};
+
+static void __init viper_map_io(void)
+{
+	pxa_map_io();
+
+	iotable_init(viper_io_desc, ARRAY_SIZE(viper_io_desc));
+
+	/* setup sleep mode values */
+	/* FIXME : to be removed once completly converted to mfp */
+	PWER  = 0x00000002;
+	PFER  = 0x00000000;
+	PRER  = 0x00000002;
+	PGSR0 = 0x00008000;
+	PGSR1 = 0x003F0202;
+	PGSR2 = 0x0001C000;
+	PCFR |= PCFR_OPDE;
+}
+
+MACHINE_START(VIPER, "Arcom/Eurotech VIPER SBC")
+	/* Maintainer: Arcom Control Systems Ltd. */
+	.phys_io	= 0x40000000,
+	.io_pg_offst	= (io_p2v(0x40000000) >> 18) & 0xfffc,
+	.boot_params	= 0xa0000100,
+	.map_io		= viper_map_io,
+	.init_irq	= viper_init_irq,
+	.timer          = &pxa_timer,
+	.init_machine	= viper_init,
+MACHINE_END
diff --git a/include/asm-arm/arch-pxa/irqs.h b/include/asm-arm/arch-pxa/irqs.h
index 9413121..583c300 100644
--- a/include/asm-arm/arch-pxa/irqs.h
+++ b/include/asm-arm/arch-pxa/irqs.h
@@ -179,6 +179,7 @@
 #elif defined(CONFIG_SHARP_LOCOMO)
 #define NR_IRQS			(IRQ_LOCOMO_SPI_TEND + 1)
 #elif defined(CONFIG_ARCH_LUBBOCK) || \
+      defined(CONFIG_ARCH_VIPER) || \
       defined(CONFIG_MACH_LOGICPD_PXA270) || \
       defined(CONFIG_MACH_TOSA) || \
       defined(CONFIG_MACH_MAINSTONE) || \
@@ -232,6 +233,28 @@
 #define IRQ_LOCOMO_LT_BASE	(IRQ_BOARD_START + 2)
 #define IRQ_LOCOMO_SPI_BASE	(IRQ_BOARD_START + 3)
 
+/* ARCOM VIPER */
+#define VIPER_ETH_IRQ		IRQ_GPIO(VIPER_ETH_GPIO)
+#define VIPER_CPLD_IRQ		IRQ_GPIO(VIPER_CPLD_GPIO)
+#define VIPER_USB_IRQ		IRQ_GPIO(VIPER_USB_GPIO)
+
+#define VIPER_UARTA_IRQ	 	IRQ_GPIO(VIPER_UARTA_GPIO)
+#define VIPER_UARTB_IRQ	 	IRQ_GPIO(VIPER_UARTB_GPIO)
+
+#define VIPER_CF_CD_IRQ	 	IRQ_GPIO(VIPER_CF_CD_GPIO)
+#define VIPER_CF_RDY_IRQ	IRQ_GPIO(VIPER_CF_RDY_GPIO)
+
+#define VIPER_IRQ(x)		(IRQ_BOARD_START + (x))
+
+#define VIPER_ISA_IRQ3		VIPER_IRQ(0)
+#define VIPER_ISA_IRQ4		VIPER_IRQ(1)
+#define VIPER_ISA_IRQ5		VIPER_IRQ(2)
+#define VIPER_ISA_IRQ6		VIPER_IRQ(3)
+#define VIPER_ISA_IRQ7		VIPER_IRQ(4)
+#define VIPER_ISA_IRQ10	 	VIPER_IRQ(5)
+#define VIPER_ISA_IRQ11	 	VIPER_IRQ(6)
+#define VIPER_ISA_IRQ14	 	VIPER_IRQ(7)
+
 /* phyCORE-PXA270 (PCM027) Interrupts */
 #define PCM027_IRQ(x)          (IRQ_BOARD_START + (x))
 #define PCM027_BTDET_IRQ       PCM027_IRQ(0)
diff --git a/include/asm-arm/arch-pxa/viper.h b/include/asm-arm/arch-pxa/viper.h
new file mode 100644
index 0000000..f8b3630
--- /dev/null
+++ b/include/asm-arm/arch-pxa/viper.h
@@ -0,0 +1,91 @@
+/*
+ *  linux/include/asm-arm/arch-pxa/viper.h
+ *
+ *  Author:	Ian Campbell
+ *  Created:	Feb 03, 2003
+ *  Copyright:	Arcom Control Systems.
+ *
+ * Created based on lubbock.h:
+ *  Author:	Nicolas Pitre
+ *  Created:	Jun 15, 2001
+ *  Copyright:	MontaVista Software Inc.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#ifndef ARCH_VIPER_H
+#define ARCH_VIPER_H
+
+#define VIPER_BOOT_PHYS		PXA_CS0_PHYS
+#define VIPER_FLASH_PHYS	PXA_CS1_PHYS
+#define VIPER_ETH_PHYS		PXA_CS2_PHYS
+#define VIPER_USB_PHYS		PXA_CS3_PHYS
+#define VIPER_ETH_DATA_PHYS	PXA_CS4_PHYS
+#define VIPER_CPLD_PHYS		PXA_CS5_PHYS
+
+#define VIPER_CPLD_BASE		(0xf0000000)
+#define VIPER_PC104IO_BASE	(0xf1000000)
+#define VIPER_USB_BASE		(0xf1800000)
+
+#define VIPER_ETH_GPIO		(0)
+#define VIPER_CPLD_GPIO		(1)
+#define VIPER_USB_GPIO		(2)
+#define VIPER_UARTA_GPIO	(4)
+#define VIPER_UARTB_GPIO	(3)
+#define VIPER_CF_CD_GPIO	(32)
+#define VIPER_CF_RDY_GPIO	(8)
+#define VIPER_BCKLIGHT_EN_GPIO	(9)
+#define VIPER_LCD_EN_GPIO	(10)
+#define VIPER_PSU_DATA_GPIO	(6)
+#define VIPER_PSU_CLK_GPIO	(11)
+#define VIPER_PWM0_GPIO		(16)
+#define VIPER_PSU_nCS_LD_GPIO	(19)
+#define VIPER_UPS_GPIO		(20)
+#define VIPER_CF_POWER_GPIO	(82)
+#define VIPER_TPM_I2C_SDA_GPIO	(26)
+#define VIPER_TPM_I2C_SCL_GPIO	(27)
+#define VIPER_RTC_I2C_SDA_GPIO	(83)
+#define VIPER_RTC_I2C_SCL_GPIO	(84)
+
+#define VIPER_CPLD_P2V(x)	((x) - VIPER_CPLD_PHYS + VIPER_CPLD_BASE)
+#define VIPER_CPLD_V2P(x)	((x) - VIPER_CPLD_BASE + VIPER_CPLD_PHYS)
+
+#ifndef __ASSEMBLY__
+#  define __VIPER_CPLD_REG(x)	(*((volatile u16 *)VIPER_CPLD_P2V(x)))
+#endif
+
+/* board level registers in the CPLD: (offsets from CPLD_BASE) ... */
+
+/* ... Physical addresses */
+#define _VIPER_LO_IRQ_STATUS	(VIPER_CPLD_PHYS + 0x100000)
+#define _VIPER_ICR_PHYS		(VIPER_CPLD_PHYS + 0x100002)
+#define _VIPER_HI_IRQ_STATUS	(VIPER_CPLD_PHYS + 0x100004)
+#define _VIPER_VERSION_PHYS	(VIPER_CPLD_PHYS + 0x100006)
+#define VIPER_UARTA_PHYS	(VIPER_CPLD_PHYS + 0x300010)
+#define VIPER_UARTB_PHYS	(VIPER_CPLD_PHYS + 0x300000)
+#define _VIPER_SRAM_BASE	(VIPER_CPLD_PHYS + 0x800000)
+
+/* ... Virtual addresses */
+#define VIPER_LO_IRQ_STATUS	__VIPER_CPLD_REG(_VIPER_LO_IRQ_STATUS)
+#define VIPER_HI_IRQ_STATUS	__VIPER_CPLD_REG(_VIPER_HI_IRQ_STATUS)
+
+/* Decode VIPER_VERSION register */
+#define VIPER_CPLD_REVISION(x)	(((x) >> 5) & 0x7)
+#define VIPER_BOARD_VERSION(x)	(((x) >> 3) & 0x3)
+#define VIPER_BOARD_ISSUE(x)	(((x) >> 0) & 0x7)
+
+/* Interrupt and Configuration Register (VIPER_ICR) */
+/* This is a write only register. Only CF_RST is used under Linux */
+
+extern void viper_icr_set_bit(unsigned int bit);
+extern void viper_icr_clear_bit(unsigned int bit);
+
+#define VIPER_ICR_RETRIG	(1 << 0)
+#define VIPER_ICR_AUTO_CLR	(1 << 1)
+#define VIPER_ICR_R_DIS		(1 << 2)
+#define VIPER_ICR_CF_RST	(1 << 3)
+
+#endif
+
-- 
1.5.4.3

