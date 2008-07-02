Return-Path: <linux-kernel-owner+w=401wt.eu-S1760669AbYGBWvl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760669AbYGBWvl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2008 18:51:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758715AbYGBWvb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Jul 2008 18:51:31 -0400
Received: from ug-out-1314.google.com ([66.249.92.169]:32022 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750904AbYGBWv3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2008 18:51:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:organization:to:subject:date:user-agent:cc:references
         :in-reply-to:mime-version:content-type:message-id;
        b=FXYzIBfQX7gF0vhIiNWGqmxCIjdgNCdpvkz56jg06X/gWHjJSGPBjQs3UFSROqovgu
         Dl/0yoBYgAipdtyym+6AGDIjgTNOnLj+Y9GNh7amlXMyR8Zj8ubC3FUnYBoL+5OCvOZr
         QfLD760snbQtFE38FAlHsoRZnJ21YPcuLGHW8=
From: Marek Vasut <marek.vasut@gmail.com>
Organization: Hack&Dev
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Subject: Re: [PATCH] PalmTX initial support
Date: Thu, 3 Jul 2008 00:52:59 +0200
User-Agent: KMail/1.9.9
Cc: Ben Dooks <ben-linux@fluff.org>, linux-kernel@vger.kernel.org,
       linux-arm-kernel@lists.arm.linux.org.uk
References: <200807022232.47294.marek.vasut@gmail.com> <20080702204110.GA22107@fluff.org.uk> <20080702220356.GE19143@flint.arm.linux.org.uk>
In-Reply-To: <20080702220356.GE19143@flint.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_MbAbIhUm8G8hBdH"
Message-Id: <200807030053.00019.marek.vasut@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Boundary-00=_MbAbIhUm8G8hBdH
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

ok, I fixed what I was able to grasp. That is :

-Are these useful? + Dittos
-Don't you have to configure GPIO47 as a GPIO to change its state?
Since you don't, and I assume you've tested this, I think you've
proven that you can delete the fiddling with GPIO47.

Actually GPIO47 was set up before by palmos (since Im not booting from clean 
state, but from palmOS) so it wasnt necessary to set it up again in linux and 
it didnt cause any problems. Booting it from clean state would cause 
problems, so I fixed it.

-I belive these calls are being deprecated.
-don't call set_irq_type, pass the relevant trigger flags to
request_irq().
-I've never seen the pooint of #ifdefs for platform data, just bung
the lot in, it is always possible to build and an insert a new driver
module to support this after building the zImage.
-hmm, real email addresses are generally safe here.
-aren't there some gpio defines to actually define these to?

Yea, I threw away all the remaining redefined GPIOs

That's it, but what I still dont understand is the pxa branch (and new PWM 
stuff). Im currently using mainline (linus's tree), so that's not the tree I 
should use ?

--Boundary-00=_MbAbIhUm8G8hBdH
Content-Type: text/x-diff;
  charset="iso-8859-1";
  name="palmtx-ml-v2.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="palmtx-ml-v2.patch"

Signed-off-by: Marek Vasut <marek.vasut@gmail.com>
diff --git a/arch/arm/mach-pxa/Kconfig b/arch/arm/mach-pxa/Kconfig
index 5da7a68..ee136b7 100644
--- a/arch/arm/mach-pxa/Kconfig
+++ b/arch/arm/mach-pxa/Kconfig
@@ -138,6 +138,19 @@ config MACH_PCM027
 	select PXA27x
 	select IWMMXT
 
+config ARCH_PXA_PALM
+	bool "PXA based Palm PDAs"
+
+config MACH_XSCALE_PALMTX
+	bool "Palm T|X"
+	default y
+	depends on ARCH_PXA_PALM
+	select PXA27x
+	select IWMMXT
+	help
+	  Say Y here if you intend to run this kernel on a Palm T|X
+	  handheld computer.
+
 endchoice
 
 choice
diff --git a/arch/arm/mach-pxa/Makefile b/arch/arm/mach-pxa/Makefile
index 0e6d05b..e74c043 100644
--- a/arch/arm/mach-pxa/Makefile
+++ b/arch/arm/mach-pxa/Makefile
@@ -36,6 +36,7 @@ obj-$(CONFIG_MACH_TOSA)		+= tosa.o
 obj-$(CONFIG_MACH_EM_X270)	+= em-x270.o
 obj-$(CONFIG_MACH_MAGICIAN)	+= magician.o
 obj-$(CONFIG_ARCH_PXA_ESERIES)	+= eseries.o
+obj-$(CONFIG_MACH_XSCALE_PALMTX)+= palmtx.o
 
 ifeq ($(CONFIG_MACH_ZYLONITE),y)
   obj-y				+= zylonite.o
diff --git a/arch/arm/mach-pxa/palmtx.c b/arch/arm/mach-pxa/palmtx.c
new file mode 100644
index 0000000..c16cfe0
--- /dev/null
+++ b/arch/arm/mach-pxa/palmtx.c
@@ -0,0 +1,300 @@
+/*
+ * Hardware definitions for PalmTX
+ *
+ * Authors:	Marek Vasut <marek.vasut@gmail.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ * (find more info at www.hackndev.com)
+ *
+ */
+
+#include <linux/platform_device.h>
+#include <linux/delay.h>
+#include <linux/irq.h>
+#include <linux/gpio_keys.h>
+#include <linux/input.h>
+
+#include <asm/mach-types.h>
+#include <asm/mach/arch.h>
+#include <asm/mach/map.h>
+
+#include <asm/arch/palmtx-init.h>
+#include <asm/arch/palmtx-gpio.h>
+#include <asm/arch/mmc.h>
+#include <asm/arch/pxafb.h>
+#include <asm/arch/pxa-regs.h>
+#include <asm/arch/gpio.h>
+#include <asm/arch/mfp-pxa27x.h>
+#include <asm/arch/irda.h>
+#include <asm/arch/pxa27x_keypad.h>
+
+#include "generic.h"
+
+/******************************************************************************
+ * SD/MMC card controller
+ ******************************************************************************/
+static unsigned long palmtx_pin_config[] = {
+	/* MMC */
+	GPIO32_MMC_CLK,
+	GPIO92_MMC_DAT_0,
+	GPIO109_MMC_DAT_1,
+	GPIO110_MMC_DAT_2,
+	GPIO111_MMC_DAT_3,
+	GPIO112_MMC_CMD,
+
+	/* AC97 */
+	GPIO28_AC97_BITCLK,
+	GPIO29_AC97_SDATA_IN_0,
+	GPIO30_AC97_SDATA_OUT,
+	GPIO31_AC97_SYNC,
+
+	/* IrDA */
+	GPIO46_FICP_RXD,
+	GPIO47_FICP_TXD,
+};
+
+/******************************************************************************
+ * SD/MMC card controller
+ ******************************************************************************/
+static int palmtx_mci_init(struct device *dev,
+				irqreturn_t (*palmtx_detect_int)(int, void *),
+				void *data)
+{
+	int err = 0;
+
+	/* Setup an interrupt for detecting card insert/remove events */
+	err = request_irq(IRQ_GPIO_PALMTX_SD_DETECT_N, palmtx_detect_int,
+			IRQF_DISABLED | IRQF_SAMPLE_RANDOM |
+			IRQF_TRIGGER_FALLING | IRQF_TRIGGER_RISING,
+			"SD/MMC card detect", data);
+	if (err) {
+		printk(KERN_ERR "%s: cannot request SD/MMC card detect IRQ\n",
+				__func__);
+		return err;
+	}
+
+	printk(KERN_DEBUG "%s: irq registered\n", __func__);
+
+	return 0;
+}
+
+static void palmtx_mci_exit(struct device *dev, void *data)
+{
+	free_irq(IRQ_GPIO_PALMTX_SD_DETECT_N, data);
+}
+
+static void palmtx_mci_power(struct device *dev, unsigned int vdd)
+{
+	struct pxamci_platform_data *p_d = dev->platform_data;
+	gpio_set_value(GPIO_NR_PALMTX_SD_POWER, !!((1 << vdd) & p_d->ocr_mask));
+}
+
+static int palmtx_mci_get_ro(struct device *dev)
+{
+	return gpio_get_value(GPIO_NR_PALMTX_SD_READONLY);
+}
+
+static struct pxamci_platform_data palmtx_mci_platform_data = {
+	.ocr_mask	= MMC_VDD_32_33 | MMC_VDD_33_34,
+	.setpower	= palmtx_mci_power,
+	.get_ro		= palmtx_mci_get_ro,
+	.init 		= palmtx_mci_init,
+	.exit		= palmtx_mci_exit,
+};
+
+/******************************************************************************
+ * GPIO keyboard
+ ******************************************************************************/
+static unsigned int palmtx_matrix_keys[] = {
+	KEY(0, 0, KEY_POWER),
+	KEY(0, 1, KEY_F1),
+	KEY(0, 2, KEY_ENTER),
+
+	KEY(1, 0, KEY_F2),
+	KEY(1, 1, KEY_F3),
+	KEY(1, 2, KEY_F4),
+
+	KEY(2, 0, KEY_UP),
+	KEY(2, 2, KEY_DOWN),
+
+	KEY(3, 0, KEY_RIGHT),
+	KEY(3, 2, KEY_LEFT),
+
+};
+
+static struct pxa27x_keypad_platform_data palmtx_keypad_platform_data = {
+	.matrix_key_rows	= 4,
+	.matrix_key_cols	= 3,
+	.matrix_key_map		= palmtx_matrix_keys,
+	.matrix_key_map_size	= ARRAY_SIZE(palmtx_matrix_keys),
+
+	.debounce_interval	= 30,
+};
+
+/******************************************************************************
+ * GPIO keys
+ ******************************************************************************/
+static struct gpio_keys_button palmtx_pxa_buttons[] = {
+	{KEY_F8, GPIO_NR_PALMTX_HOTSYNC_BUTTON_N, 1, "HotSync Button" },
+};
+
+static struct gpio_keys_platform_data palmtx_pxa_keys_data = {
+	.buttons	= palmtx_pxa_buttons,
+	.nbuttons	= ARRAY_SIZE(palmtx_pxa_buttons),
+};
+
+static struct platform_device palmtx_pxa_keys = {
+	.name	= "gpio-keys",
+	.id	= -1,
+	.dev	= {
+		.platform_data = &palmtx_pxa_keys_data,
+	},
+};
+
+/******************************************************************************
+ * Backlight
+ ******************************************************************************/
+static void palmtx_set_bl_intensity(int intensity)
+{
+	gpio_set_value(GPIO_NR_PALMTX_BL_POWER, intensity);
+	gpio_set_value(GPIO_NR_PALMTX_LCD_POWER, intensity);
+	if (intensity) {
+		PWM_CTRL0	= 0x7;
+		PWM_PERVAL0	= PALMTX_PERIOD;
+		PWM_PWDUTY0	= intensity;
+	}
+}
+
+static struct generic_bl_info palmtx_bl_info = {
+	.max_intensity		= PALMTX_MAX_INTENSITY,
+	.default_intensity	= PALMTX_MAX_INTENSITY,
+	.set_bl_intensity	= palmtx_set_bl_intensity,
+	.limit_mask		= PALMTX_LIMIT_MASK,
+};
+
+static struct platform_device palmtx_backlight = {
+	.name	= "generic-bl",
+	.id	= -1,
+	.dev	= {
+		.platform_data = &palmtx_bl_info,
+	},
+};
+
+/******************************************************************************
+ * IrDA
+ ******************************************************************************/
+static void palmtx_irda_transceiver_mode(struct device *dev, int mode)
+{
+	unsigned long flags;
+
+	local_irq_save(flags);
+
+	gpio_set_value(GPIO_NR_PALMTX_IR_DISABLE, !!(mode & IR_OFF));
+	if (!(mode & IR_OFF)) {
+		gpio_set_value(GPIO47_FICP_TXD, 1);
+		mdelay(30);
+		gpio_set_value(GPIO47_FICP_TXD, 0);
+	}
+
+	local_irq_restore(flags);
+}
+
+static struct pxaficp_platform_data palmtx_ficp_platform_data = {
+	.transceiver_cap	= IR_SIRMODE | IR_FIRMODE | IR_OFF,
+	.transceiver_mode	= palmtx_irda_transceiver_mode,
+};
+
+/******************************************************************************
+ * AC97
+ ******************************************************************************/
+static struct platform_device palmtx_ac97 = {
+	.name	= "pxa2xx-ac97",
+	.id	= 0,
+};
+
+/******************************************************************************
+ * Framebuffer
+ ******************************************************************************/
+static struct pxafb_mode_info palmtx_lcd_modes[] = {
+{
+	.pixclock	= 57692,
+	.xres		= 320,
+	.yres		= 480,
+	.bpp		= 16,
+
+	.left_margin	= 32,
+	.right_margin	= 1,
+	.upper_margin	= 7,
+	.lower_margin	= 1,
+
+	.hsync_len	= 4,
+	.vsync_len	= 1,
+
+	.sync		= FB_SYNC_HOR_HIGH_ACT|FB_SYNC_VERT_HIGH_ACT,
+},
+};
+
+static struct pxafb_mach_info palmtx_lcd_screen = {
+	.modes		= palmtx_lcd_modes,
+	.num_modes	= ARRAY_SIZE(palmtx_lcd_modes),
+	.lccr0		= LCCR0_Color | LCCR0_Sngl | LCCR0_Act | LCCR0_RDSTM |
+			  LCCR0_CMDIM | LCCR0_OUC  | LCCR0_LDDALT,
+	.lccr3		= LCCR3_HorSnchL | LCCR3_VrtSnchL |
+			  LCCR3_PixFlEdg | LCCR3_Bpp(4),
+};
+
+/******************************************************************************
+ * Machine init
+ ******************************************************************************/
+static struct platform_device *devices[] __initdata = {
+#ifdef CONFIG_KEYBOARD_GPIO
+	&palmtx_pxa_keys,
+#endif
+	&palmtx_ac97,
+	&palmtx_backlight,
+};
+
+static struct map_desc palmtx_io_desc[] __initdata = {
+{
+	.virtual	= PALMTX_PCMCIA_VIRT,
+	.pfn		= __phys_to_pfn(PALMTX_PCMCIA_PHYS),
+	.length		= PALMTX_PCMCIA_SIZE,
+	.type		= MT_DEVICE
+},
+};
+
+static void __init palmtx_map_io(void)
+{
+	pxa_map_io();
+	iotable_init(palmtx_io_desc, ARRAY_SIZE(palmtx_io_desc));
+}
+
+static void __init palmtx_init(void)
+{
+	pxa2xx_mfp_config(ARRAY_AND_SIZE(palmtx_pin_config));
+
+	/* disable primary codec interrupt to prevent WM9712 constantly
+	 * interrupting the CPU and preventing the boot process to complete
+	 * (Thanx Alex & Shadowmite!) */
+	GCR &= ~GCR_PRIRDY_IEN;
+
+	/* configure AC97's GPIOs */
+	set_pxa_fb_info(&palmtx_lcd_screen);
+	pxa_set_mci_info(&palmtx_mci_platform_data);
+	pxa_set_ficp_info(&palmtx_ficp_platform_data);
+	pxa_set_keypad_info(&palmtx_keypad_platform_data);
+	platform_add_devices(devices, ARRAY_SIZE(devices));
+}
+
+MACHINE_START(XSCALE_PALMTX, "Palm T|X")
+	.phys_io	= PALMTX_PHYS_IO_START,
+	.io_pg_offst	= io_p2v(0x40000000),
+	.boot_params	= 0xa0000100,
+	.map_io		= palmtx_map_io,
+	.init_irq	= pxa27x_init_irq,
+	.timer		= &pxa_timer,
+	.init_machine	= palmtx_init
+MACHINE_END
diff --git a/include/asm-arm/arch-pxa/palmtx-gpio.h b/include/asm-arm/arch-pxa/palmtx-gpio.h
new file mode 100644
index 0000000..9deeb92
--- /dev/null
+++ b/include/asm-arm/arch-pxa/palmtx-gpio.h
@@ -0,0 +1,69 @@
+/*
+ * GPIOs and interrupts for Palm T|X Handheld Computer
+ *
+ * Based on palmld-gpio.h by Alex Osborne
+ *
+ * Authors:	Marek Vasut <marek.vasut@gmail.com>
+ *		Cristiano P. <cristianop@users.sourceforge.net>
+ *		Jan Herman <2hp@seznam.cz>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ */
+
+#ifndef _INCLUDE_PALMTX_GPIO_H_
+#define _INCLUDE_PALMTX_GPIO_H_
+
+/* GPIOs */
+#define GPIO_NR_PALMTX_GPIO_RESET		1
+
+#define GPIO_NR_PALMTX_POWER_DETECT		12 /* 90 */
+#define GPIO_NR_PALMTX_HOTSYNC_BUTTON_N		10
+#define GPIO_NR_PALMTX_EARPHONE_DETECT		107
+
+/* SD/MMC */
+#define GPIO_NR_PALMTX_SD_DETECT_N		14
+#define GPIO_NR_PALMTX_SD_POWER			114 /* probably */
+#define GPIO_NR_PALMTX_SD_READONLY		115 /* probably */
+
+/* TOUCHSCREEN */
+#define GPIO_NR_PALMTX_WM9712_IRQ		27
+
+/* IRDA -  disable GPIO connected to SD pin of tranceiver (TFBS4710?) ? */
+#define GPIO_NR_PALMTX_IR_DISABLE		40
+
+/* USB */
+#define GPIO_NR_PALMTX_USB_DETECT_N		13
+#define GPIO_NR_PALMTX_USB_POWER		95
+#define GPIO_NR_PALMTX_USB_PULLUP		93
+
+/* LCD/BACKLIGHT */
+#define GPIO_NR_PALMTX_BL_POWER			84
+#define GPIO_NR_PALMTX_LCD_POWER		96
+
+/* LCD BORDER */
+#define GPIO_NR_PALMTX_BORDER_SWITCH		98
+#define GPIO_NR_PALMTX_BORDER_SELECT		22
+
+/* BLUETOOTH */
+#define GPIO_NR_PALMTX_BT_POWER			17
+#define GPIO_NR_PALMTX_BT_RESET			83
+
+/* PCMCIA (WiFi) */
+#define GPIO_NR_PALMTX_PCMCIA_POWER1		94
+#define GPIO_NR_PALMTX_PCMCIA_POWER2		108
+#define GPIO_NR_PALMTX_PCMCIA_RESET		79
+#define GPIO_NR_PALMTX_PCMCIA_READY		116
+
+/* NAND Flash ... this GPIO may be incorrect! */
+#define GPIO_NR_PALMTX_NAND_BUFFER_DIR		79
+
+/* INTERRUPTS */
+#define IRQ_GPIO_PALMTX_SD_DETECT_N	IRQ_GPIO(GPIO_NR_PALMTX_SD_DETECT_N)
+#define IRQ_GPIO_PALMTX_WM9712_IRQ	IRQ_GPIO(GPIO_NR_PALMTX_WM9712_IRQ)
+#define IRQ_GPIO_PALMTX_USB_DETECT	IRQ_GPIO(GPIO_NR_PALMTX_USB_DETECT)
+#define IRQ_GPIO_PALMTX_GPIO_RESET	IRQ_GPIO(GPIO_NR_PALMTX_GPIO_RESET)
+
+#endif
diff --git a/include/asm-arm/arch-pxa/palmtx-init.h b/include/asm-arm/arch-pxa/palmtx-init.h
new file mode 100644
index 0000000..8b70694
--- /dev/null
+++ b/include/asm-arm/arch-pxa/palmtx-init.h
@@ -0,0 +1,51 @@
+/*
+ * Init values for Palm T|X Handheld Computer
+ *
+ * Authors:	Marek Vasut <marek.vasut@gmail.com>
+ *		Cristiano P. <cristianop@users.sourceforge.net>
+ *		Jan Herman <2hp@seznam.cz>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ */
+
+#ifndef _INCLUDE_PALMTX_INIT_H_
+
+#define _INCLUDE_PALMTX_INIT_H_
+
+/* Various addresses  */
+#define PALMTX_PCMCIA_PHYS	0x28000000
+#define PALMTX_PCMCIA_VIRT	0xf0000000
+#define PALMTX_PCMCIA_SIZE	0x100000
+
+#define PALMTX_PHYS_RAM_START	0xa0000000
+#define PALMTX_PHYS_IO_START	0x40000000
+
+#define PALMTX_PHYS_FLASH_START	PXA_CS0_PHYS    /* ChipSelect 0 */
+#define PALMTX_PHYS_NAND_START	PXA_CS1_PHYS    /* ChipSelect 1 */
+
+/* TOUCHSCREEN */
+#define AC97_LINK_FRAME		21
+
+
+/* BATTERY */
+#define PALMTX_BAT_MAX_VOLTAGE		4000	/* 4.00v current voltage */
+#define PALMTX_BAT_MIN_VOLTAGE		3550	/* 3.55v critical voltage */
+#define PALMTX_BAT_MAX_CURRENT		   0	/* unknokn */
+#define PALMTX_BAT_MIN_CURRENT		   0	/* unknown */
+#define PALMTX_BAT_MAX_CHARGE		   1	/* unknown */
+#define PALMTX_BAT_MIN_CHARGE		   1	/* unknown */
+#define PALMTX_MAX_LIFE_MINS		 360    /* on-life in minutes */
+
+#define PALMTX_BAT_MEASURE_DELAY (HZ * 1)
+
+/* BACKLIGHT */
+#define PALMTX_MAX_INTENSITY            0xFE
+#define PALMTX_DEFAULT_INTENSITY        0x7E
+#define PALMTX_LIMIT_MASK               0x7F
+#define PALMTX_PRESCALER                0x3F
+#define PALMTX_PERIOD                   0x12C
+
+#endif

--Boundary-00=_MbAbIhUm8G8hBdH--
