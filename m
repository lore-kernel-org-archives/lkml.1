Return-Path: <linux-kernel-owner+w=401wt.eu-S1767652AbXDFN7L@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767652AbXDFN7L (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Apr 2007 09:59:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1767649AbXDFN7K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Apr 2007 09:59:10 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:43858 "EHLO amd.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1767656AbXDFN7F (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Apr 2007 09:59:05 -0400
Date: Thu, 5 Apr 2007 10:48:50 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Harald Welte <laforge@openmoko.org>, openmoko-kernel@lists.openmoko.org,
       kernel list <linux-kernel@vger.kernel.org>, patches@arm.linux.org.uk
Subject: basic support for neo1973
Message-ID: <20070405084850.GA11008@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.11+cvs20060126
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This adds very basic support for fic1973 (aka gta01, aka
openmoko). With this patch applied, I can boot the kernel and actually
see the messages.

From: Harald Welte <laforge@openmoko.org>
Signed-off-by: Pavel Machek <pavel@suse.cz>

PATCH FOLLOWS
KernelVersion: 2.6.21-rc5-git

diff --git a/arch/arm/mach-s3c2410/Kconfig b/arch/arm/mach-s3c2410/Kconfig
index d4b013b..9f2a874 100644
--- a/arch/arm/mach-s3c2410/Kconfig
+++ b/arch/arm/mach-s3c2410/Kconfig
@@ -109,5 +109,11 @@ config MACH_QT2410
 	help
 	   Say Y here if you are using the Armzone QT2410
 
+config MACH_GTA01
+	bool "FIC Neo1973 GSM Phone"
+	select CPU_S3C2410
+	help
+	   Say Y here if you are using the FIC Neo1973 GSM Phone
+
 endmenu
 
diff --git a/arch/arm/mach-s3c2410/Makefile b/arch/arm/mach-s3c2410/Makefile
index 9a3d3d2..71b82d8 100644
--- a/arch/arm/mach-s3c2410/Makefile
+++ b/arch/arm/mach-s3c2410/Makefile
@@ -29,3 +29,5 @@ obj-$(CONFIG_MACH_AML_M5900)	+= mach-aml
 obj-$(CONFIG_BAST_PC104_IRQ)	+= bast-irq.o
 obj-$(CONFIG_MACH_VR1000)	+= mach-vr1000.o usb-simtec.o
 obj-$(CONFIG_MACH_QT2410)	+= mach-qt2410.o
+obj-$(CONFIG_MACH_GTA01)	+= mach-gta01.o
+
diff --git a/arch/arm/mach-s3c2410/mach-gta01.c b/arch/arm/mach-s3c2410/mach-gta01.c
new file mode 100644
index 0000000..c9b4837
--- /dev/null
+++ b/arch/arm/mach-s3c2410/mach-gta01.c
@@ -0,0 +1,358 @@
+/*
+ * linux/arch/arm/mach-s3c2410/mach-gta01.c
+ *
+ * S3C2410 Machine Support for the FIC GTA01 (Neo1973)
+ *
+ * Copyright (C) 2006-2007 by OpenMoko, Inc.
+ * Author: Harald Welte <laforge@openmoko.org>
+ * All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License as
+ * published by the Free Software Foundation; either version 2 of
+ * the License, or (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 59 Temple Place, Suite 330, Boston,
+ * MA 02111-1307 USA
+ *
+ */
+
+#include <linux/kernel.h>
+#include <linux/types.h>
+#include <linux/interrupt.h>
+#include <linux/list.h>
+#include <linux/timer.h>
+#include <linux/init.h>
+#include <linux/workqueue.h>
+#include <linux/platform_device.h>
+#include <linux/serial_core.h>
+#include <linux/spi/spi.h>
+#include <linux/spi/spi_bitbang.h>
+#include <linux/mmc/protocol.h>
+
+#include <linux/mtd/mtd.h>
+#include <linux/mtd/nand.h>
+#include <linux/mtd/nand_ecc.h>
+#include <linux/mtd/partitions.h>
+
+#include <asm/mach/arch.h>
+#include <asm/mach/map.h>
+#include <asm/mach/irq.h>
+
+#include <asm/hardware.h>
+#include <asm/io.h>
+#include <asm/irq.h>
+#include <asm/mach-types.h>
+
+#include <asm/arch/regs-serial.h>
+#include <asm/arch/regs-gpio.h>
+#include <asm/arch/fb.h>
+#include <asm/arch/udc.h>
+#include <asm/arch/nand.h>
+#include <asm/arch/spi.h>
+#include <asm/arch/spi-gpio.h>
+#include <asm/arch/usb-control.h>
+
+#include <asm/arch/gta01.h>
+
+#include <asm/plat-s3c24xx/clock.h>
+#include <asm/plat-s3c24xx/devs.h>
+#include <asm/plat-s3c24xx/cpu.h>
+
+static struct map_desc gta01_iodesc[] __initdata = {
+	{
+		.virtual	= 0xe0000000,
+		.pfn		= __phys_to_pfn(S3C2410_CS3+0x01000000),
+		.length		= SZ_1M,
+		.type		= MT_DEVICE
+	},
+};
+
+#define UCON S3C2410_UCON_DEFAULT
+#define ULCON S3C2410_LCON_CS8 | S3C2410_LCON_PNONE | S3C2410_LCON_STOPB
+#define UFCON S3C2410_UFCON_RXTRIG8 | S3C2410_UFCON_FIFOMODE
+
+static struct s3c2410_uartcfg gta01_uartcfgs[] = {
+	[0] = {
+		.hwport	     = 0,
+		.flags	     = 0,
+		.ucon	     = UCON,
+		.ulcon	     = ULCON,
+		.ufcon	     = UFCON,
+	},
+	[1] = {
+		.hwport	     = 1,
+		.flags	     = 0,
+		.ucon	     = UCON,
+		.ulcon	     = ULCON,
+		.ufcon	     = UFCON,
+	},
+};
+
+/* LCD driver info */
+
+
+/* Configuration for 480x640 toppoly TD028TTEC1 */
+static struct s3c2410fb_mach_info gta01_lcd_cfg __initdata = {
+	.regs	= {
+		.lcdcon1	= S3C2410_LCDCON1_TFT16BPP |
+				  S3C2410_LCDCON1_TFT |
+				  S3C2410_LCDCON1_CLKVAL(0x01),	/* HCLK/4 */
+
+		.lcdcon2	= S3C2410_LCDCON2_VBPD(1) |	/* 2 */
+				  S3C2410_LCDCON2_LINEVAL(639) |/* 640 */
+				  S3C2410_LCDCON2_VFPD(15) |	/* 16 */
+				  S3C2410_LCDCON2_VSPW(1),	/* 2 */
+
+		.lcdcon3	= S3C2410_LCDCON3_HBPD(7) |	/* 8 */
+				  S3C2410_LCDCON3_HOZVAL(479) |	/* 480 */
+				  S3C2410_LCDCON3_HFPD(103),	/* 104 */
+
+		.lcdcon4	= S3C2410_LCDCON4_MVAL(0) |
+				  S3C2410_LCDCON4_HSPW(7),	/* 8 */
+
+		.lcdcon5	= S3C2410_LCDCON5_FRM565 |
+				  S3C2410_LCDCON5_INVVLINE |
+				  S3C2410_LCDCON5_INVVFRAME |
+				  S3C2410_LCDCON5_PWREN |
+				  S3C2410_LCDCON5_HWSWP,
+	},
+
+	.lpcsel		= ((0xCE6) & ~7) | 1<<4,
+	.type		= S3C2410_LCDCON1_TFT,
+
+	.width		= 480,
+	.height		= 640,
+
+	.xres		= {
+		.min	= 240,
+		.max	= 480,
+		.defval	= 480,
+	},
+
+	.yres		= {
+		.min	= 320,
+		.max	= 640,
+		.defval = 640,
+	},
+
+	.bpp		= {
+		.min	= 1,
+		.max	= 16,
+		.defval = 16,
+	},
+};
+static struct platform_device *gta01_devices[] __initdata = {
+	&s3c_device_lcd,
+};
+
+static struct s3c24xx_board gta01_board __initdata = {
+	.devices       = gta01_devices,
+	.devices_count = ARRAY_SIZE(gta01_devices)
+};
+
+static struct mtd_partition gta01_nand_part[] = {
+	[0] = {
+		.name	= "U-Boot",
+		.size	= 0x30000,
+		.offset	= 0,
+	},
+	[1] = {
+		.name	= "U-Boot environment",
+		.offset = 0x30000,
+		.size	= 0x4000,
+	},
+	[2] = {
+		.name	= "kernel",
+		.offset = 0x34000,
+		.size	= SZ_2M,
+	},
+	[3] = {
+		.name	= "initrd",
+		.offset	= 0x234000,
+		.size	= SZ_4M,
+	},
+	[4] = {
+		.name	= "jffs2",
+		.offset = 0x634000,
+		.size	= 0x39cc000,
+	},
+};
+
+static struct s3c2410_nand_set gta01_nand_sets[] = {
+	[0] = {
+		.name		= "NAND",
+		.nr_chips	= 1,
+		.nr_partitions	= ARRAY_SIZE(gta01_nand_part),
+		.partitions	= gta01_nand_part,
+	},
+};
+
+/* choose a set of timings which should suit most 512Mbit
+ * chips and beyond.
+ */
+
+static struct s3c2410_platform_nand gta01_nand_info = {
+	.tacls		= 20,
+	.twrph0		= 60,
+	.twrph1		= 20,
+	.nr_sets	= ARRAY_SIZE(gta01_nand_sets),
+	.sets		= gta01_nand_sets,
+};
+
+static unsigned int mmc_millivolts[] = {
+	[MMC_VDD_145_150]	= 1500,
+	[MMC_VDD_150_155]	= 1500,
+	[MMC_VDD_155_160]	= 1600,
+	[MMC_VDD_160_165]	= 1600,
+	[MMC_VDD_165_170]	= 1700,
+	[MMC_VDD_17_18]		= 1800,
+	[MMC_VDD_18_19]		= 1900,
+	[MMC_VDD_19_20]		= 2000,
+	[MMC_VDD_20_21]		= 2100,
+	[MMC_VDD_21_22]		= 2200,
+	[MMC_VDD_22_23]		= 2300,
+	[MMC_VDD_23_24]		= 2400,
+	[MMC_VDD_24_25]		= 2500,
+	[MMC_VDD_25_26]		= 2600,
+	[MMC_VDD_26_27]		= 2700,
+	[MMC_VDD_27_28]		= 2800,
+	[MMC_VDD_28_29]		= 2900,
+	[MMC_VDD_29_30]		= 3000,
+	[MMC_VDD_30_31]		= 3100,
+	[MMC_VDD_31_32]		= 3200,
+	[MMC_VDD_32_33]		= 3300,
+};
+
+static void gta01_mmc_set_power(unsigned short vdd)
+{
+	/* FIXME: set GTA01_GPIO_SDMMC_ON on GTA01v4 */
+}
+
+static void gta01_udc_command(enum s3c2410_udc_cmd_e cmd)
+{
+	printk(KERN_DEBUG "%s(%d)\n", __func__, cmd);
+
+	switch (cmd) {
+	case S3C2410_UDC_P_ENABLE:
+		s3c2410_gpio_setpin(GTA01_GPIO_USB_PULLUP, 1);
+		break;
+	case S3C2410_UDC_P_DISABLE:
+		s3c2410_gpio_setpin(GTA01_GPIO_USB_PULLUP, 0);
+		break;
+	case S3C2410_UDC_P_RESET:
+		/* FIXME! */
+		break;
+	default:
+		break;
+	}
+}
+
+static struct gta01bl_machinfo backlight_machinfo = {
+	.default_intensity	= 1,
+	.max_intensity		= 1,
+	.limit_mask		= 1,
+};
+
+static struct resource gta01_bl_resources[] = {
+	[0] = {
+		.start	= GTA01_GPIO_BACKLIGHT,
+		.end	= GTA01_GPIO_BACKLIGHT,
+	},
+};
+
+struct platform_device gta01_bl_dev = {
+	.name 		= "gta01-bl",
+	.num_resources	= ARRAY_SIZE(gta01_bl_resources),
+	.resource	= gta01_bl_resources,
+	.dev		= {
+		.platform_data = &backlight_machinfo,
+	},
+};
+
+static struct resource gta01_button_resources[] = {
+	[0] = {
+		.start = GTA01_GPIO_AUX_KEY,
+		.end   = GTA01_GPIO_AUX_KEY,
+	},
+	[1] = {
+		.start = GTA01_GPIO_HOLD_KEY,
+		.end   = GTA01_GPIO_HOLD_KEY,
+	},
+	[2] = {
+		.start = GTA01_GPIO_JACK_INSERT,
+		.end   = GTA01_GPIO_JACK_INSERT,
+	},
+};
+
+struct platform_device gta01_button_dev = {
+	.name		="gta01-button",
+	.num_resources	= ARRAY_SIZE(gta01_button_resources),
+	.resource	= gta01_button_resources,
+};
+
+static struct platform_device gta01_pm_gsm_dev = {
+	.name		="gta01-pm-gsm",
+};
+
+/* USB */
+static struct s3c2410_hcd_info gta01_usb_info = {
+	.port[0]	= {
+		.flags	= S3C_HCDFLG_USED,
+	},
+	.port[1]	= {
+		.flags	= 0,
+	},
+};
+
+static void __init gta01_map_io(void)
+{
+	s3c24xx_init_io(gta01_iodesc, ARRAY_SIZE(gta01_iodesc));
+	s3c24xx_init_clocks(12*1000*1000);
+	s3c24xx_init_uarts(gta01_uartcfgs, ARRAY_SIZE(gta01_uartcfgs));
+	s3c24xx_set_board(&gta01_board);
+}
+
+static void __init gta01_machine_init(void)
+{
+	s3c_device_usb.dev.platform_data = &gta01_usb_info;
+	s3c_device_nand.dev.platform_data = &gta01_nand_info;
+
+	s3c24xx_fb_set_platdata(&gta01_lcd_cfg);
+
+	/* Set LCD_RESET / XRES to high */
+	s3c2410_gpio_cfgpin(S3C2410_GPC6, S3C2410_GPIO_OUTPUT);
+	s3c2410_gpio_setpin(S3C2410_GPC6, 1);
+
+#ifdef SPI_HARD
+#else
+	/* SPI chip select is gpio output */
+	s3c2410_gpio_cfgpin(S3C2410_GPG3, S3C2410_GPIO_OUTPUT);
+	s3c2410_gpio_setpin(S3C2410_GPG3, 1);
+
+#endif
+	platform_device_register(&gta01_bl_dev);
+	platform_device_register(&gta01_button_dev);
+	platform_device_register(&gta01_pm_gsm_dev);
+
+	s3c2410_pm_init();
+}
+
+MACHINE_START(GTA01, "GTA01")
+	.phys_io	= S3C2410_PA_UART,
+	.io_pg_offst	= (((u32)S3C24XX_VA_UART) >> 18) & 0xfffc,
+	.boot_params	= S3C2410_SDRAM_PA + 0x100,
+	.map_io		= gta01_map_io,
+	.init_irq	= s3c24xx_init_irq,
+	.init_machine	= gta01_machine_init,
+	.timer		= &s3c24xx_timer,
+MACHINE_END
+
+

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
