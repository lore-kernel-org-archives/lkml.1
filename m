Return-Path: <linux-kernel-owner+w=401wt.eu-S965921AbXDIVY1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965921AbXDIVY1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Apr 2007 17:24:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965913AbXDIVYE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Apr 2007 17:24:04 -0400
Received: from nlpi015.sbcis.sbc.com ([207.115.36.44]:26622 "EHLO
	nlpi015.sbcis.sbc.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965881AbXDIVXM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Apr 2007 17:23:12 -0400
X-ORBL: [67.117.73.34]
From: Tony Lindgren <tony@atomide.com>
To: linux-kernel@vger.kernel.org
Cc: Tony Lindgren <tony@atomide.com>
Subject: [PATCH 6/18] ARM: OMAP: Sync core code with linux-omap
Date: Mon,  9 Apr 2007 17:22:11 -0400
Message-Id: <11761537672719-git-send-email-tony@atomide.com>
X-Mailer: git-send-email 1.4.4.2
In-Reply-To: <11761537613625-git-send-email-tony@atomide.com>
References: <11761537431635-git-send-email-tony@atomide.com> <117615374683-git-send-email-tony@atomide.com> <11761537491968-git-send-email-tony@atomide.com> <11761537522665-git-send-email-tony@atomide.com> <11761537563620-git-send-email-tony@atomide.com> <11761537613625-git-send-email-tony@atomide.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch syncs omap specific core code with linux-omap.
Most of the changes are needed to fix bitrot caused by
driver updates in linux-omap tree.

Signed-off-by: Tony Lindgren <tony@atomide.com>
---
 arch/arm/mach-omap1/Kconfig   |   17 ++--
 arch/arm/mach-omap1/Makefile  |    5 +-
 arch/arm/mach-omap1/devices.c |   71 +++++++++------
 arch/arm/mach-omap2/Kconfig   |   27 +++++-
 arch/arm/mach-omap2/Makefile  |    7 ++
 arch/arm/mach-omap2/devices.c |   60 +++++++++++-
 arch/arm/mach-omap2/gpmc.c    |   12 ++-
 arch/arm/mach-omap2/io.c      |   24 +++++-
 arch/arm/plat-omap/Kconfig    |    8 ++
 arch/arm/plat-omap/Makefile   |   12 +++-
 arch/arm/plat-omap/common.c   |    8 ++-
 arch/arm/plat-omap/devices.c  |   70 ++++++++++++++-
 arch/arm/plat-omap/dmtimer.c  |    2 +-
 arch/arm/plat-omap/fb.c       |   72 ++++++++++++----
 arch/arm/plat-omap/sram.c     |   77 ++++++++++-------
 arch/arm/plat-omap/usb.c      |  199 ++++++++++++++++++++++++++++++++--------
 16 files changed, 525 insertions(+), 146 deletions(-)

Index: linux-2.6/arch/arm/mach-omap1/Kconfig
===================================================================
--- linux-2.6.orig/arch/arm/mach-omap1/Kconfig	2007-04-06 09:00:28.000000000 -0400
+++ linux-2.6/arch/arm/mach-omap1/Kconfig	2007-04-09 14:40:23.000000000 -0400
@@ -22,6 +22,7 @@ comment "OMAP Board Type"
 config MACH_OMAP_INNOVATOR
 	bool "TI Innovator"
 	depends on ARCH_OMAP1 && (ARCH_OMAP15XX || ARCH_OMAP16XX)
+	select OMAP_MCBSP
 	help
           TI OMAP 1510 or 1610 Innovator board support. Say Y here if you
           have such a board.
@@ -29,6 +30,7 @@ config MACH_OMAP_INNOVATOR
 config MACH_OMAP_H2
 	bool "TI H2 Support"
 	depends on ARCH_OMAP1 && ARCH_OMAP16XX
+	select OMAP_MCBSP
     	help
 	  TI OMAP 1610/1611B H2 board support. Say Y here if you have such
 	  a board.
@@ -36,6 +38,7 @@ config MACH_OMAP_H2
 config MACH_OMAP_H3
 	bool "TI H3 Support"
 	depends on ARCH_OMAP1 && ARCH_OMAP16XX
+	select GPIOEXPANDER_OMAP
     	help
 	  TI OMAP 1710 H3 board support. Say Y here if you have such
 	  a board.
Index: linux-2.6/arch/arm/mach-omap1/Makefile
===================================================================
--- linux-2.6.orig/arch/arm/mach-omap1/Makefile	2007-04-06 09:00:28.000000000 -0400
+++ linux-2.6/arch/arm/mach-omap1/Makefile	2007-04-09 14:40:23.000000000 -0400
@@ -37,4 +37,3 @@ led-$(CONFIG_MACH_OMAP_INNOVATOR)	+= led
 led-$(CONFIG_MACH_OMAP_PERSEUS2)	+= leds-h2p2-debug.o
 led-$(CONFIG_MACH_OMAP_OSK)		+= leds-osk.o
 obj-$(CONFIG_LEDS)			+= $(led-y)
-
Index: linux-2.6/arch/arm/mach-omap1/devices.c
===================================================================
--- linux-2.6.orig/arch/arm/mach-omap1/devices.c	2007-04-06 09:00:28.000000000 -0400
+++ linux-2.6/arch/arm/mach-omap1/devices.c	2007-04-09 14:40:23.000000000 -0400
@@ -24,35 +24,6 @@
 #include <asm/arch/mux.h>
 #include <asm/arch/gpio.h>
 
-#if	defined(CONFIG_OMAP1610_IR) || defined(CONFIG_OMAP161O_IR_MODULE)
-
-static u64 irda_dmamask = 0xffffffff;
-
-static struct platform_device omap1610ir_device = {
-	.name = "omap1610-ir",
-	.id = -1,
-	.dev = {
-		.dma_mask	= &irda_dmamask,
-	},
-};
-
-static void omap_init_irda(void)
-{
-	/* FIXME define and use a boot tag, members something like:
-	 *  u8		uart;		// uart1, or uart3
-	 * ... but driver only handles uart3 for now
-	 *  s16		fir_sel;	// gpio for SIR vs FIR
-	 * ... may prefer a callback for SIR/MIR/FIR mode select;
-	 * while h2 uses a GPIO, H3 uses a gpio expander
-	 */
-	if (machine_is_omap_h2()
-			|| machine_is_omap_h3())
-		(void) platform_device_register(&omap1610ir_device);
-}
-#else
-static inline void omap_init_irda(void) {}
-#endif
-
 /*-------------------------------------------------------------------------*/
 
 #if defined(CONFIG_RTC_DRV_OMAP) || defined(CONFIG_RTC_DRV_OMAP_MODULE)
@@ -90,6 +61,45 @@ static void omap_init_rtc(void)
 static inline void omap_init_rtc(void) {}
 #endif
 
+#if defined(CONFIG_OMAP_DSP) || defined(CONFIG_OMAP_DSP_MODULE)
+
+#if defined(CONFIG_ARCH_OMAP15XX)
+#  define OMAP1_MBOX_SIZE	0x23
+#  define INT_DSP_MAILBOX1	INT_1510_DSP_MAILBOX1
+#elif defined(CONFIG_ARCH_OMAP16XX)
+#  define OMAP1_MBOX_SIZE	0x2f
+#  define INT_DSP_MAILBOX1	INT_1610_DSP_MAILBOX1
+#endif
+
+#define OMAP1_MBOX_BASE		IO_ADDRESS(OMAP16XX_MAILBOX_BASE)
+
+static struct resource mbox_resources[] = {
+	{
+		.start		= OMAP1_MBOX_BASE,
+		.end		= OMAP1_MBOX_BASE + OMAP1_MBOX_SIZE,
+		.flags		= IORESOURCE_MEM,
+	},
+	{
+		.start		= INT_DSP_MAILBOX1,
+		.flags		= IORESOURCE_IRQ,
+	},
+};
+
+static struct platform_device mbox_device = {
+	.name		= "mailbox",
+	.id		= -1,
+	.num_resources	= ARRAY_SIZE(mbox_resources),
+	.resource	= mbox_resources,
+};
+
+static inline void omap_init_mbox(void)
+{
+	platform_device_register(&mbox_device);
+}
+#else
+static inline void omap_init_mbox(void) { }
+#endif
+
 #if defined(CONFIG_OMAP_STI)
 
 #define OMAP1_STI_BASE		IO_ADDRESS(0xfffea000)
@@ -154,7 +164,8 @@ static int __init omap1_init_devices(voi
 	/* please keep these calls, and their implementations above,
 	 * in alphabetical order so they're easier to sort through.
 	 */
-	omap_init_irda();
+
+	omap_init_mbox();
 	omap_init_rtc();
 	omap_init_sti();
 
Index: linux-2.6/arch/arm/mach-omap2/Kconfig
===================================================================
--- linux-2.6.orig/arch/arm/mach-omap2/Kconfig	2007-04-09 14:20:29.000000000 -0400
+++ linux-2.6/arch/arm/mach-omap2/Kconfig	2007-04-09 14:40:23.000000000 -0400
@@ -9,6 +9,7 @@ config ARCH_OMAP2420
 	bool "OMAP2420 support"
 	depends on ARCH_OMAP24XX
 	select OMAP_DM_TIMER
+	select ARCH_OMAP_OTG
 
 comment "OMAP Board Type"
 	depends on ARCH_OMAP2
Index: linux-2.6/arch/arm/mach-omap2/devices.c
===================================================================
--- linux-2.6.orig/arch/arm/mach-omap2/devices.c	2007-04-06 09:00:28.000000000 -0400
+++ linux-2.6/arch/arm/mach-omap2/devices.c	2007-04-09 14:40:23.000000000 -0400
@@ -66,6 +66,40 @@ static void omap_init_i2c(void) {}
 
 #endif
 
+#if defined(CONFIG_OMAP_DSP) || defined(CONFIG_OMAP_DSP_MODULE)
+#define OMAP2_MBOX_BASE		IO_ADDRESS(OMAP24XX_MAILBOX_BASE)
+
+static struct resource mbox_resources[] = {
+	{
+		.start		= OMAP2_MBOX_BASE,
+		.end		= OMAP2_MBOX_BASE + 0x11f,
+		.flags		= IORESOURCE_MEM,
+	},
+	{
+		.start		= INT_24XX_MAIL_U0_MPU,
+		.flags		= IORESOURCE_IRQ,
+	},
+	{
+		.start		= INT_24XX_MAIL_U3_MPU,
+		.flags		= IORESOURCE_IRQ,
+	},
+};
+
+static struct platform_device mbox_device = {
+	.name		= "mailbox",
+	.id		= -1,
+	.num_resources	= ARRAY_SIZE(mbox_resources),
+	.resource	= mbox_resources,
+};
+
+static inline void omap_init_mbox(void)
+{
+	platform_device_register(&mbox_device);
+}
+#else
+static inline void omap_init_mbox(void) { }
+#endif
+
 #if defined(CONFIG_OMAP_STI)
 
 #define OMAP2_STI_BASE		IO_ADDRESS(0x48068000)
@@ -111,29 +145,45 @@ static inline void omap_init_sti(void) {
 #define OMAP2_MCSPI1_BASE		0x48098000
 #define OMAP2_MCSPI2_BASE		0x4809a000
 
-/* FIXME: use resources instead */
-
 static struct omap2_mcspi_platform_config omap2_mcspi1_config = {
-	.base		= io_p2v(OMAP2_MCSPI1_BASE),
 	.num_cs		= 4,
 };
 
+static struct resource omap2_mcspi1_resources[] = {
+	{
+		.start		= OMAP2_MCSPI1_BASE,
+		.end		= OMAP2_MCSPI1_BASE + 0xff,
+		.flags		= IORESOURCE_MEM,
+	},
+};
+
 struct platform_device omap2_mcspi1 = {
 	.name		= "omap2_mcspi",
 	.id		= 1,
+	.num_resources	= ARRAY_SIZE(omap2_mcspi1_resources),
+	.resource	= omap2_mcspi1_resources,
 	.dev		= {
 		.platform_data = &omap2_mcspi1_config,
 	},
 };
 
 static struct omap2_mcspi_platform_config omap2_mcspi2_config = {
-	.base		= io_p2v(OMAP2_MCSPI2_BASE),
 	.num_cs		= 2,
 };
 
+static struct resource omap2_mcspi2_resources[] = {
+	{
+		.start		= OMAP2_MCSPI2_BASE,
+		.end		= OMAP2_MCSPI2_BASE + 0xff,
+		.flags		= IORESOURCE_MEM,
+	},
+};
+
 struct platform_device omap2_mcspi2 = {
 	.name		= "omap2_mcspi",
 	.id		= 2,
+	.num_resources	= ARRAY_SIZE(omap2_mcspi2_resources),
+	.resource	= omap2_mcspi2_resources,
 	.dev		= {
 		.platform_data = &omap2_mcspi2_config,
 	},
@@ -157,10 +207,10 @@ static int __init omap2_init_devices(voi
 	 * in alphabetical order so they're easier to sort through.
 	 */
 	omap_init_i2c();
+	omap_init_mbox();
 	omap_init_mcspi();
 	omap_init_sti();
 
 	return 0;
 }
 arch_initcall(omap2_init_devices);
-
Index: linux-2.6/arch/arm/mach-omap2/gpmc.c
===================================================================
--- linux-2.6.orig/arch/arm/mach-omap2/gpmc.c	2007-04-06 09:00:28.000000000 -0400
+++ linux-2.6/arch/arm/mach-omap2/gpmc.c	2007-04-09 14:40:23.000000000 -0400
@@ -246,14 +246,22 @@ static int gpmc_cs_mem_enabled(int cs)
 	return l & (1 << 6);
 }
 
-static void gpmc_cs_set_reserved(int cs, int reserved)
+int gpmc_cs_set_reserved(int cs, int reserved)
 {
+	if (cs > GPMC_CS_NUM)
+		return -ENODEV;
+
 	gpmc_cs_map &= ~(1 << cs);
 	gpmc_cs_map |= (reserved ? 1 : 0) << cs;
+
+	return 0;
 }
 
-static int gpmc_cs_reserved(int cs)
+int gpmc_cs_reserved(int cs)
 {
+	if (cs > GPMC_CS_NUM)
+		return -ENODEV;
+
 	return gpmc_cs_map & (1 << cs);
 }
 
Index: linux-2.6/arch/arm/mach-omap2/io.c
===================================================================
--- linux-2.6.orig/arch/arm/mach-omap2/io.c	2007-04-06 09:00:28.000000000 -0400
+++ linux-2.6/arch/arm/mach-omap2/io.c	2007-04-09 14:40:23.000000000 -0400
@@ -40,9 +40,21 @@ static struct map_desc omap2_io_desc[] _
 		.type		= MT_DEVICE
 	},
 	{
-		.virtual	= L4_24XX_VIRT,
-		.pfn		= __phys_to_pfn(L4_24XX_PHYS),
-		.length		= L4_24XX_SIZE,
+		.virtual	= DSP_MEM_24XX_VIRT,
+		.pfn		= __phys_to_pfn(DSP_MEM_24XX_PHYS),
+		.length		= DSP_MEM_24XX_SIZE,
+		.type		= MT_DEVICE
+	},
+	{
+		.virtual	= DSP_IPI_24XX_VIRT,
+		.pfn		= __phys_to_pfn(DSP_IPI_24XX_PHYS),
+		.length		= DSP_IPI_24XX_SIZE,
+		.type		= MT_DEVICE
+	},
+	{
+		.virtual	= DSP_MMU_24XX_VIRT,
+		.pfn		= __phys_to_pfn(DSP_MMU_24XX_PHYS),
+		.length		= DSP_MMU_24XX_SIZE,
 		.type		= MT_DEVICE
 	}
 };
Index: linux-2.6/arch/arm/plat-omap/Kconfig
===================================================================
--- linux-2.6.orig/arch/arm/plat-omap/Kconfig	2007-04-09 14:20:29.000000000 -0400
+++ linux-2.6/arch/arm/plat-omap/Kconfig	2007-04-09 14:40:23.000000000 -0400
@@ -62,6 +62,14 @@ config OMAP_MUX_WARNINGS
 	  to change the pin multiplexing setup.  When there are no warnings
 	  printed, it's safe to deselect OMAP_MUX for your product.
 
+config OMAP_MCBSP
+	bool "McBSP support"
+	depends on ARCH_OMAP
+	default y
+	help
+	  Say Y here if you want support for the OMAP Multichannel
+	  Buffered Serial Port.
+
 choice
         prompt "System timer"
 	default OMAP_MPU_TIMER
Index: linux-2.6/arch/arm/plat-omap/Makefile
===================================================================
--- linux-2.6.orig/arch/arm/plat-omap/Makefile	2007-04-09 14:20:29.000000000 -0400
+++ linux-2.6/arch/arm/plat-omap/Makefile	2007-04-09 14:40:23.000000000 -0400
@@ -3,7 +3,8 @@
 #
 
 # Common support
-obj-y := common.o sram.o sram-fn.o clock.o devices.o dma.o mux.o gpio.o mcbsp.o usb.o fb.o
+obj-y := common.o sram.o sram-fn.o clock.o devices.o dma.o mux.o gpio.o \
+	 usb.o fb.o
 obj-m :=
 obj-n :=
 obj-  :=
Index: linux-2.6/arch/arm/plat-omap/common.c
===================================================================
--- linux-2.6.orig/arch/arm/plat-omap/common.c	2007-04-06 09:00:28.000000000 -0400
+++ linux-2.6/arch/arm/plat-omap/common.c	2007-04-09 14:40:23.000000000 -0400
@@ -93,8 +93,12 @@ static const void *get_config(u16 tag, s
 	 * in the kernel. */
 	for (i = 0; i < omap_board_config_size; i++) {
 		if (omap_board_config[i].tag == tag) {
-			kinfo = &omap_board_config[i];
-			break;
+			if (skip == 0) {
+				kinfo = &omap_board_config[i];
+				break;
+			} else {
+				skip--;
+			}
 		}
 	}
 	if (kinfo == NULL)
Index: linux-2.6/arch/arm/plat-omap/devices.c
===================================================================
--- linux-2.6.orig/arch/arm/plat-omap/devices.c	2007-04-09 14:15:04.000000000 -0400
+++ linux-2.6/arch/arm/plat-omap/devices.c	2007-04-09 14:40:23.000000000 -0400
@@ -25,7 +25,71 @@
 #include <asm/arch/gpio.h>
 #include <asm/arch/menelaus.h>
 
-#if 	defined(CONFIG_I2C_OMAP) || defined(CONFIG_I2C_OMAP_MODULE)
+#if	defined(CONFIG_OMAP_DSP) || defined(CONFIG_OMAP_DSP_MODULE)
+
+#include "../plat-omap/dsp/dsp_common.h"
+
+static struct dsp_platform_data dsp_pdata = {
+	.kdev_list = LIST_HEAD_INIT(dsp_pdata.kdev_list),
+};
+
+static struct resource omap_dsp_resources[] = {
+	{
+		.name	= "dsp_mmu",
+		.start	= -1,
+		.flags	= IORESOURCE_IRQ,
+	},
+};
+
+static struct platform_device omap_dsp_device = {
+	.name		= "dsp",
+	.id		= -1,
+	.num_resources	= ARRAY_SIZE(omap_dsp_resources),
+	.resource	= omap_dsp_resources,
+	.dev = {
+		.platform_data = &dsp_pdata,
+	},
+};
+
+static inline void omap_init_dsp(void)
+{
+	struct resource *res;
+	int irq;
+
+	if (cpu_is_omap15xx())
+		irq = INT_1510_DSP_MMU;
+	else if (cpu_is_omap16xx())
+		irq = INT_1610_DSP_MMU;
+	else if (cpu_is_omap24xx())
+		irq = INT_24XX_DSP_MMU;
+
+	res = platform_get_resource_byname(&omap_dsp_device,
+					   IORESOURCE_IRQ, "dsp_mmu");
+	res->start = irq;
+
+	platform_device_register(&omap_dsp_device);
+}
+
+int dsp_kfunc_device_register(struct dsp_kfunc_device *kdev)
+{
+	static DEFINE_MUTEX(dsp_pdata_lock);
+
+	mutex_init(&kdev->lock);
+
+	mutex_lock(&dsp_pdata_lock);
+	list_add_tail(&kdev->entry, &dsp_pdata.kdev_list);
+	mutex_unlock(&dsp_pdata_lock);
+
+	return 0;
+}
+EXPORT_SYMBOL(dsp_kfunc_device_register);
+
+#else
+static inline void omap_init_dsp(void) { }
+#endif	/* CONFIG_OMAP_DSP */
+
+/*-------------------------------------------------------------------------*/
+#if	defined(CONFIG_I2C_OMAP) || defined(CONFIG_I2C_OMAP_MODULE)
 
 #define	OMAP1_I2C_BASE		0xfffb3800
 #define OMAP2_I2C_BASE1		0x48070000
@@ -376,7 +440,7 @@ static inline void omap_init_wdt(void) {
 
 /*-------------------------------------------------------------------------*/
 
-#if	defined(CONFIG_OMAP_RNG) || defined(CONFIG_OMAP_RNG_MODULE)
+#if defined(CONFIG_HW_RANDOM_OMAP) || defined(CONFIG_HW_RANDOM_OMAP_MODULE)
 
 #ifdef CONFIG_ARCH_OMAP24XX
 #define	OMAP_RNG_BASE		0x480A0000
@@ -436,6 +500,7 @@ static int __init omap_init_devices(void
 	/* please keep these calls, and their implementations above,
 	 * in alphabetical order so they're easier to sort through.
 	 */
+	omap_init_dsp();
 	omap_init_i2c();
 	omap_init_kp();
 	omap_init_mmc();
@@ -446,4 +511,3 @@ static int __init omap_init_devices(void
 	return 0;
 }
 arch_initcall(omap_init_devices);
-
Index: linux-2.6/arch/arm/plat-omap/dmtimer.c
===================================================================
--- linux-2.6.orig/arch/arm/plat-omap/dmtimer.c	2007-04-09 14:15:04.000000000 -0400
+++ linux-2.6/arch/arm/plat-omap/dmtimer.c	2007-04-09 14:40:23.000000000 -0400
@@ -372,7 +372,7 @@ void omap_dm_timer_set_source(struct oma
 
 	/* When the functional clock disappears, too quick writes seem to
 	 * cause an abort. */
-	__delay(15000);
+	__delay(150000);
 }
 
 #endif
Index: linux-2.6/arch/arm/plat-omap/fb.c
===================================================================
--- linux-2.6.orig/arch/arm/plat-omap/fb.c	2007-04-09 14:18:58.000000000 -0400
+++ linux-2.6/arch/arm/plat-omap/fb.c	2007-04-09 14:40:23.000000000 -0400
@@ -1,3 +1,26 @@
+/*
+ * File: arch/arm/plat-omap/fb.c
+ *
+ * Framebuffer device registration for TI OMAP platforms
+ *
+ * Copyright (C) 2006 Nokia Corporation
+ * Author: Imre Deak <imre.deak@nokia.com>
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License as published by the
+ * Free Software Foundation; either version 2 of the License, or (at your
+ * option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License along
+ * with this program; if not, write to the Free Software Foundation, Inc.,
+ * 59 Temple Place - Suite 330, Boston, MA  02111-1307, USA.
+ */
+
 #include <linux/module.h>
 #include <linux/kernel.h>
 #include <linux/init.h>
@@ -34,25 +57,42 @@ static struct platform_device omap_fb_de
 void omapfb_reserve_mem(void)
 {
 	const struct omap_fbmem_config *fbmem_conf;
+	unsigned long total_size;
+	int i;
 
-	omapfb_config.fbmem.fb_sram_start = omap_fb_sram_start;
-	omapfb_config.fbmem.fb_sram_size = omap_fb_sram_size;
-
-	fbmem_conf = omap_get_config(OMAP_TAG_FBMEM, struct omap_fbmem_config);
+	if (!omap_fb_sram_valid) {
+		/* FBMEM SRAM configuration was already found to be invalid.
+		 * Ignore the whole configuration block. */
+		omapfb_config.mem_desc.region_cnt = 0;
+		return;
+	}
 
-	if (fbmem_conf != NULL) {
-		/* indicate that the bootloader already initialized the
-		 * fb device, so we'll skip that part in the fb driver
-		 */
-		omapfb_config.fbmem.fb_sdram_start = fbmem_conf->fb_sdram_start;
-		omapfb_config.fbmem.fb_sdram_size = fbmem_conf->fb_sdram_size;
-		if (fbmem_conf->fb_sdram_size) {
-			pr_info("Reserving %u bytes SDRAM for frame buffer\n",
-				fbmem_conf->fb_sdram_size);
-			reserve_bootmem(fbmem_conf->fb_sdram_start,
-					fbmem_conf->fb_sdram_size);
+	i = 0;
+	total_size = 0;
+	while ((fbmem_conf = omap_get_nr_config(OMAP_TAG_FBMEM,
+				struct omap_fbmem_config, i)) != NULL) {
+		unsigned long start;
+		unsigned long size;
+
+		if (i == OMAPFB_PLANE_NUM) {
+			printk(KERN_ERR "ignoring extra plane info\n");
+			break;
 		}
+		start = fbmem_conf->start;
+		size  = fbmem_conf->size;
+		omapfb_config.mem_desc.region[i].paddr = start;
+		omapfb_config.mem_desc.region[i].size = size;
+		if (omap_fb_sram_plane != i && start) {
+			reserve_bootmem(start, size);
+			total_size += size;
+		}
+		i++;
 	}
+	omapfb_config.mem_desc.region_cnt = i;
+	if (total_size)
+		pr_info("Reserving %lu bytes SDRAM for frame buffer\n",
+			 total_size);
+
 }
 
 void omapfb_set_ctrl_platform_data(void *data)
Index: linux-2.6/arch/arm/plat-omap/sram.c
===================================================================
--- linux-2.6.orig/arch/arm/plat-omap/sram.c	2007-04-06 09:00:28.000000000 -0400
+++ linux-2.6/arch/arm/plat-omap/sram.c	2007-04-09 14:40:23.000000000 -0400
@@ -46,12 +46,13 @@
 
 #define ROUND_DOWN(value,boundary)	((value) & (~((boundary)-1)))
 
+static unsigned long omap_sram_start;
 static unsigned long omap_sram_base;
 static unsigned long omap_sram_size;
 static unsigned long omap_sram_ceil;
 
-unsigned long omap_fb_sram_start;
-unsigned long omap_fb_sram_size;
+int	omap_fb_sram_plane = -1;
+int	omap_fb_sram_valid;
 
 /* Depending on the target RAMFS firewall setup, the public usable amount of
  * SRAM varies.  The default accessable size for all device types is 2k. A GP
@@ -77,30 +78,43 @@ static int is_sram_locked(void)
 		return 1; /* assume locked with no PPA or security driver */
 }
 
-void get_fb_sram_conf(unsigned long start_avail, unsigned size_avail,
-		      unsigned long *start, unsigned long *size)
+static int get_fb_sram_conf(unsigned long start_avail, unsigned size_avail,
+			      unsigned long *start, int *plane_idx)
 {
 	const struct omap_fbmem_config *fbmem_conf;
+	unsigned long size = 0;
+	int i;
 
-	fbmem_conf = omap_get_config(OMAP_TAG_FBMEM, struct omap_fbmem_config);
-	if (fbmem_conf != NULL) {
-		*start = fbmem_conf->fb_sram_start;
-		*size = fbmem_conf->fb_sram_size;
-	} else {
-		*size = 0;
-		*start = 0;
+	i = 0;
+	*start = 0;
+	*plane_idx = -1;
+	while ((fbmem_conf = omap_get_nr_config(OMAP_TAG_FBMEM,
+				struct omap_fbmem_config, i)) != NULL) {
+		u32 paddr, end;
+
+		paddr = fbmem_conf->start;
+		end = fbmem_conf->start + fbmem_conf->size;
+		if (paddr > omap_sram_start &&
+		    paddr < omap_sram_start + omap_sram_size) {
+			if (*plane_idx != -1 || paddr < start_avail ||
+			    paddr == end ||
+			    end > start_avail + size_avail) {
+				printk(KERN_ERR "invalid FB SRAM configuration");
+				*start = 0;
+				return -1;
+			}
+			*plane_idx = i;
+			*start = fbmem_conf->start;
+			size = fbmem_conf->size;
+		}
+		i++;
 	}
 
-	if (*size && (
-	    *start < start_avail ||
-	    *start + *size > start_avail + size_avail)) {
-		printk(KERN_ERR "invalid FB SRAM configuration\n");
-		*start = start_avail;
-		*size = size_avail;
-	}
+	if (*plane_idx >= 0)
+		pr_info("Reserving %lu bytes SRAM frame buffer "
+			"for plane %d\n", size, *plane_idx);
 
-	if (*size)
-		pr_info("Reserving %lu bytes SRAM for frame buffer\n", *size);
+	return 0;
 }
 
 /*
@@ -111,16 +125,16 @@ void get_fb_sram_conf(unsigned long star
  */
 void __init omap_detect_sram(void)
 {
-	unsigned long sram_start;
+	unsigned long fb_sram_start;
 
 	if (cpu_is_omap24xx()) {
 		if (is_sram_locked()) {
 			omap_sram_base = OMAP2_SRAM_PUB_VA;
-			sram_start = OMAP2_SRAM_PUB_PA;
+			omap_sram_start = OMAP2_SRAM_PUB_PA;
 			omap_sram_size = 0x800; /* 2K */
 		} else {
 			omap_sram_base = OMAP2_SRAM_VA;
-			sram_start = OMAP2_SRAM_PA;
+			omap_sram_start = OMAP2_SRAM_PA;
 			if (cpu_is_omap242x())
 				omap_sram_size = 0xa0000; /* 640K */
 			else if (cpu_is_omap243x())
@@ -128,7 +142,7 @@ void __init omap_detect_sram(void)
 		}
 	} else {
 		omap_sram_base = OMAP1_SRAM_VA;
-		sram_start = OMAP1_SRAM_PA;
+		omap_sram_start = OMAP1_SRAM_PA;
 
 		if (cpu_is_omap730())
 			omap_sram_size = 0x32000;	/* 200K */
@@ -144,12 +158,13 @@ void __init omap_detect_sram(void)
 			omap_sram_size = 0x4000;
 		}
 	}
-	get_fb_sram_conf(sram_start + SRAM_BOOTLOADER_SZ,
-			 omap_sram_size - SRAM_BOOTLOADER_SZ,
-			 &omap_fb_sram_start, &omap_fb_sram_size);
-	if (omap_fb_sram_size)
-		omap_sram_size -= sram_start + omap_sram_size -
-				  omap_fb_sram_start;
+	if (get_fb_sram_conf(omap_sram_start + SRAM_BOOTLOADER_SZ,
+			    omap_sram_size - SRAM_BOOTLOADER_SZ,
+			    &fb_sram_start, &omap_fb_sram_plane) == 0)
+		omap_fb_sram_valid = 1;
+	if (omap_fb_sram_valid && omap_fb_sram_plane >= 0)
+		omap_sram_size -= omap_sram_start + omap_sram_size -
+				  fb_sram_start;
 	omap_sram_ceil = omap_sram_base + omap_sram_size;
 }
 
Index: linux-2.6/arch/arm/plat-omap/usb.c
===================================================================
--- linux-2.6.orig/arch/arm/plat-omap/usb.c	2007-04-06 09:00:28.000000000 -0400
+++ linux-2.6/arch/arm/plat-omap/usb.c	2007-04-09 14:40:23.000000000 -0400
@@ -37,9 +37,27 @@
 #include <asm/arch/usb.h>
 #include <asm/arch/board.h>
 
+#ifdef CONFIG_ARCH_OMAP1
+
+#define INT_USB_IRQ_GEN		IH2_BASE + 20
+#define INT_USB_IRQ_NISO	IH2_BASE + 30
+#define INT_USB_IRQ_ISO		IH2_BASE + 29
+#define INT_USB_IRQ_HGEN	INT_USB_HHC_1
+#define INT_USB_IRQ_OTG		IH2_BASE + 8
+
+#else
+
+#define INT_USB_IRQ_GEN		INT_24XX_USB_IRQ_GEN
+#define INT_USB_IRQ_NISO	INT_24XX_USB_IRQ_NISO
+#define INT_USB_IRQ_ISO		INT_24XX_USB_IRQ_ISO
+#define INT_USB_IRQ_HGEN	INT_24XX_USB_IRQ_HGEN
+#define INT_USB_IRQ_OTG		INT_24XX_USB_IRQ_OTG
+
+#endif
+
+
 /* These routines should handle the standard chip-specific modes
  * for usb0/1/2 ports, covering basic mux and transceiver setup.
- * Call omap_usb_init() once, from INIT_MACHINE().
  *
  * Some board-*.c files will need to set up additional mux options,
  * like for suspend handling, vbus sensing, GPIOs, and the D+ pullup.
@@ -96,19 +114,26 @@ static u32 __init omap_usb0_init(unsigne
 {
 	u32	syscon1 = 0;
 
+	if (cpu_is_omap24xx())
+		CONTROL_DEVCONF_REG &= ~USBT0WRMODEI(USB_BIDIR_TLL);
+
 	if (nwires == 0) {
-		if (!cpu_is_omap15xx()) {
+		if (cpu_class_is_omap1() && !cpu_is_omap15xx()) {
 			/* pulldown D+/D- */
 			USB_TRANSCEIVER_CTRL_REG &= ~(3 << 1);
 		}
 		return 0;
 	}
 
-	if (is_device)
-		omap_cfg_reg(W4_USB_PUEN);
+	if (is_device) {
+		if (cpu_is_omap24xx())
+			omap_cfg_reg(J20_24XX_USB0_PUEN);
+		else
+			omap_cfg_reg(W4_USB_PUEN);
+	}
 
-	/* internal transceiver */
-	if (nwires == 2) {
+	/* internal transceiver (unavailable on 17xx, 24xx) */
+	if (!cpu_class_is_omap2() && nwires == 2) {
 		// omap_cfg_reg(P9_USB_DP);
 		// omap_cfg_reg(R8_USB_DM);
 
@@ -136,29 +161,50 @@ static u32 __init omap_usb0_init(unsigne
 		return 0;
 	}
 
-	omap_cfg_reg(V6_USB0_TXD);
-	omap_cfg_reg(W9_USB0_TXEN);
-	omap_cfg_reg(W5_USB0_SE0);
-
-	/* NOTE:  SPEED and SUSP aren't configured here */
-
-	if (nwires != 3)
-		omap_cfg_reg(Y5_USB0_RCV);
-	if (nwires != 6)
+	if (cpu_is_omap24xx()) {
+		omap_cfg_reg(K18_24XX_USB0_DAT);
+		omap_cfg_reg(K19_24XX_USB0_TXEN);
+		omap_cfg_reg(J14_24XX_USB0_SE0);
+		if (nwires != 3)
+			omap_cfg_reg(J18_24XX_USB0_RCV);
+	} else {
+		omap_cfg_reg(V6_USB0_TXD);
+		omap_cfg_reg(W9_USB0_TXEN);
+		omap_cfg_reg(W5_USB0_SE0);
+		if (nwires != 3)
+			omap_cfg_reg(Y5_USB0_RCV);
+	}
+
+	/* NOTE:  SPEED and SUSP aren't configured here.  OTG hosts
+	 * may be able to use I2C requests to set those bits along
+	 * with VBUS switching and overcurrent detction.
+	 */
+
+	if (cpu_class_is_omap1() && nwires != 6)
 		USB_TRANSCEIVER_CTRL_REG &= ~CONF_USB2_UNI_R;
 
 	switch (nwires) {
 	case 3:
 		syscon1 = 2;
+		if (cpu_is_omap24xx())
+			CONTROL_DEVCONF_REG |= USBT0WRMODEI(USB_BIDIR);
 		break;
 	case 4:
 		syscon1 = 1;
+		if (cpu_is_omap24xx())
+			CONTROL_DEVCONF_REG |= USBT0WRMODEI(USB_BIDIR);
 		break;
 	case 6:
 		syscon1 = 3;
-		omap_cfg_reg(AA9_USB0_VP);
-		omap_cfg_reg(R9_USB0_VM);
-		USB_TRANSCEIVER_CTRL_REG |= CONF_USB2_UNI_R;
+		if (cpu_is_omap24xx()) {
+			omap_cfg_reg(J19_24XX_USB0_VP);
+			omap_cfg_reg(K20_24XX_USB0_VM);
+			CONTROL_DEVCONF_REG |= USBT0WRMODEI(USB_UNIDIR);
+		} else {
+			omap_cfg_reg(AA9_USB0_VP);
+			omap_cfg_reg(R9_USB0_VM);
+			USB_TRANSCEIVER_CTRL_REG |= CONF_USB2_UNI_R;
+		}
 		break;
 	default:
 		printk(KERN_ERR "illegal usb%d %d-wire transceiver\n",
@@ -171,14 +217,22 @@ static u32 __init omap_usb1_init(unsigne
 {
 	u32	syscon1 = 0;
 
-	if (nwires != 6 && !cpu_is_omap15xx())
+	if (cpu_class_is_omap1() && !cpu_is_omap15xx() && nwires != 6)
 		USB_TRANSCEIVER_CTRL_REG &= ~CONF_USB1_UNI_R;
+	if (cpu_is_omap24xx())
+		CONTROL_DEVCONF_REG &= ~USBT1WRMODEI(USB_BIDIR_TLL);
+
 	if (nwires == 0)
 		return 0;
 
 	/* external transceiver */
-	omap_cfg_reg(USB1_TXD);
-	omap_cfg_reg(USB1_TXEN);
+	if (cpu_class_is_omap1()) {
+		omap_cfg_reg(USB1_TXD);
+		omap_cfg_reg(USB1_TXEN);
+		if (nwires != 3)
+			omap_cfg_reg(USB1_RCV);
+	}
+
 	if (cpu_is_omap15xx()) {
 		omap_cfg_reg(USB1_SEO);
 		omap_cfg_reg(USB1_SPEED);
@@ -190,20 +244,38 @@ static u32 __init omap_usb1_init(unsigne
 	} else if (cpu_is_omap1710()) {
 		omap_cfg_reg(R13_1710_USB1_SE0);
 		// SUSP
+	} else if (cpu_is_omap24xx()) {
+		/* NOTE:  board-specific code must set up pin muxing for usb1,
+		 * since each signal could come out on either of two balls.
+		 */
 	} else {
-		pr_debug("usb unrecognized\n");
+		pr_debug("usb%d cpu unrecognized\n", 1);
+		return 0;
 	}
-	if (nwires != 3)
-		omap_cfg_reg(USB1_RCV);
 
 	switch (nwires) {
+	case 2:
+		if (!cpu_is_omap24xx())
+			goto bad;
+		/* NOTE: board-specific code must override this setting if
+		 * this TLL link is not using DP/DM
+		 */
+		syscon1 = 1;
+		CONTROL_DEVCONF_REG |= USBT1WRMODEI(USB_BIDIR_TLL);
+		break;
 	case 3:
 		syscon1 = 2;
+		if (cpu_is_omap24xx())
+			CONTROL_DEVCONF_REG |= USBT1WRMODEI(USB_BIDIR);
 		break;
 	case 4:
 		syscon1 = 1;
+		if (cpu_is_omap24xx())
+			CONTROL_DEVCONF_REG |= USBT1WRMODEI(USB_BIDIR);
 		break;
 	case 6:
+		if (cpu_is_omap24xx())
+			goto bad;
 		syscon1 = 3;
 		omap_cfg_reg(USB1_VP);
 		omap_cfg_reg(USB1_VM);
@@ -211,6 +283,7 @@ static u32 __init omap_usb1_init(unsigne
 			USB_TRANSCEIVER_CTRL_REG |= CONF_USB1_UNI_R;
 		break;
 	default:
+bad:
 		printk(KERN_ERR "illegal usb%d %d-wire transceiver\n",
 			1, nwires);
 	}
@@ -221,10 +294,17 @@ static u32 __init omap_usb2_init(unsigne
 {
 	u32	syscon1 = 0;
 
-	/* NOTE erratum: must leave USB2_UNI_R set if usb0 in use */
+	if (cpu_is_omap24xx()) {
+		CONTROL_DEVCONF_REG &= ~(USBT2WRMODEI(USB_BIDIR_TLL)
+					| USBT2TLL5PI);
+		alt_pingroup = 0;
+	}
+
+	/* NOTE omap1 erratum: must leave USB2_UNI_R set if usb0 in use */
 	if (alt_pingroup || nwires == 0)
 		return 0;
-	if (nwires != 6 && !cpu_is_omap15xx())
+
+	if (cpu_class_is_omap1() && !cpu_is_omap15xx() && nwires != 6)
 		USB_TRANSCEIVER_CTRL_REG &= ~CONF_USB2_UNI_R;
 
 	/* external transceiver */
@@ -242,19 +322,54 @@ static u32 __init omap_usb2_init(unsigne
 		if (nwires != 3)
 			omap_cfg_reg(Y5_USB2_RCV);
 		// FIXME omap_cfg_reg(USB2_SPEED);
+	} else if (cpu_is_omap24xx()) {
+		omap_cfg_reg(Y11_24XX_USB2_DAT);
+		omap_cfg_reg(AA10_24XX_USB2_SE0);
+		if (nwires > 2)
+			omap_cfg_reg(AA12_24XX_USB2_TXEN);
+		if (nwires > 3)
+			omap_cfg_reg(AA6_24XX_USB2_RCV);
 	} else {
-		pr_debug("usb unrecognized\n");
+		pr_debug("usb%d cpu unrecognized\n", 1);
+		return 0;
 	}
-	// omap_cfg_reg(USB2_SUSP);
+	// if (cpu_class_is_omap1()) omap_cfg_reg(USB2_SUSP);
 
 	switch (nwires) {
+	case 2:
+		if (!cpu_is_omap24xx())
+			goto bad;
+		/* NOTE: board-specific code must override this setting if
+		 * this TLL link is not using DP/DM
+		 */
+		syscon1 = 1;
+		CONTROL_DEVCONF_REG |= USBT2WRMODEI(USB_BIDIR_TLL);
+		break;
 	case 3:
 		syscon1 = 2;
+		if (cpu_is_omap24xx())
+			CONTROL_DEVCONF_REG |= USBT2WRMODEI(USB_BIDIR);
 		break;
 	case 4:
 		syscon1 = 1;
+		if (cpu_is_omap24xx())
+			CONTROL_DEVCONF_REG |= USBT2WRMODEI(USB_BIDIR);
+		break;
+	case 5:
+		if (!cpu_is_omap24xx())
+			goto bad;
+		omap_cfg_reg(AA4_24XX_USB2_TLLSE0);
+		/* NOTE: board-specific code must override this setting if
+		 * this TLL link is not using DP/DM.  Something must also
+		 * set up OTG_SYSCON2.HMC_TLL{ATTACH,SPEED}
+		 */
+		syscon1 = 3;
+		CONTROL_DEVCONF_REG |= USBT2WRMODEI(USB_UNIDIR_TLL)
+					| USBT2TLL5PI;
 		break;
 	case 6:
+		if (cpu_is_omap24xx())
+			goto bad;
 		syscon1 = 3;
 		if (cpu_is_omap15xx()) {
 			omap_cfg_reg(USB2_VP);
@@ -266,6 +381,7 @@ static u32 __init omap_usb2_init(unsigne
 		}
 		break;
 	default:
+bad:
 		printk(KERN_ERR "illegal usb%d %d-wire transceiver\n",
 			2, nwires);
 	}
@@ -294,13 +410,13 @@ static struct resource udc_resources[] =
 		.end		= UDC_BASE + 0xff,
 		.flags		= IORESOURCE_MEM,
 	}, {		/* general IRQ */
-		.start		= IH2_BASE + 20,
+		.start		= INT_USB_IRQ_GEN,
 		.flags		= IORESOURCE_IRQ,
 	}, {		/* PIO IRQ */
-		.start		= IH2_BASE + 30,
+		.start		= INT_USB_IRQ_NISO,
 		.flags		= IORESOURCE_IRQ,
 	}, {		/* SOF IRQ */
-		.start		= IH2_BASE + 29,
+		.start		= INT_USB_IRQ_ISO,
 		.flags		= IORESOURCE_IRQ,
 	},
 };
@@ -329,11 +445,11 @@ static u64 ohci_dmamask = ~(u32)0;
 static struct resource ohci_resources[] = {
 	{
 		.start	= OMAP_OHCI_BASE,
-		.end	= OMAP_OHCI_BASE + 4096 - 1,
+		.end	= OMAP_OHCI_BASE + 0xff,
 		.flags	= IORESOURCE_MEM,
 	},
 	{
-		.start	= INT_USB_HHC_1,
+		.start	= INT_USB_IRQ_HGEN,
 		.flags	= IORESOURCE_IRQ,
 	},
 };
@@ -361,7 +477,7 @@ static struct resource otg_resources[] =
 		.end		= OTG_BASE + 0xff,
 		.flags		= IORESOURCE_MEM,
 	}, {
-		.start		= IH2_BASE + 8,
+		.start		= INT_USB_IRQ_OTG,
 		.flags		= IORESOURCE_IRQ,
 	},
 };
@@ -385,7 +501,7 @@ static struct platform_device otg_device
 
 
 // FIXME correct answer depends on hmc_mode,
-// as does any nonzero value for config->otg port number
+// as does (on omap1) any nonzero value for config->otg port number
 #ifdef	CONFIG_USB_GADGET_OMAP
 #define	is_usb0_device(config)	1
 #else
@@ -426,12 +542,13 @@ omap_otg_init(struct omap_usb_config *co
 	if (config->otg)
 		syscon |= OTG_EN;
 #endif
-	pr_debug("USB_TRANSCEIVER_CTRL_REG = %03x\n", USB_TRANSCEIVER_CTRL_REG);
+	if (cpu_class_is_omap1())
+		pr_debug("USB_TRANSCEIVER_CTRL_REG = %03x\n", USB_TRANSCEIVER_CTRL_REG);
 	pr_debug("OTG_SYSCON_2_REG = %08x\n", syscon);
 	OTG_SYSCON_2_REG = syscon;
 
 	printk("USB: hmc %d", config->hmc_mode);
-	if (alt_pingroup)
+	if (!alt_pingroup)
 		printk(", usb2 alt %d wires", config->pins[2]);
 	else if (config->pins[0])
 		printk(", usb0 %d wires%s", config->pins[0],
@@ -444,10 +561,12 @@ omap_otg_init(struct omap_usb_config *co
 		printk(", Mini-AB on usb%d", config->otg - 1);
 	printk("\n");
 
-	/* leave USB clocks/controllers off until needed */
-	ULPD_SOFT_REQ_REG &= ~SOFT_USB_CLK_REQ;
-	ULPD_CLOCK_CTRL_REG &= ~USB_MCLK_EN;
-	ULPD_CLOCK_CTRL_REG |= DIS_USB_PVCI_CLK;
+	if (cpu_class_is_omap1()) {
+		/* leave USB clocks/controllers off until needed */
+		ULPD_SOFT_REQ_REG &= ~SOFT_USB_CLK_REQ;
+		ULPD_CLOCK_CTRL_REG &= ~USB_MCLK_EN;
+		ULPD_CLOCK_CTRL_REG |= DIS_USB_PVCI_CLK;
+	}
 	syscon = OTG_SYSCON_1_REG;
 	syscon |= HST_IDLE_EN|DEV_IDLE_EN|OTG_IDLE_EN;
 
@@ -585,7 +704,7 @@ omap_usb_init(void)
 	}
 	platform_data = *config;
 
-	if (cpu_is_omap730() || cpu_is_omap16xx())
+	if (cpu_is_omap730() || cpu_is_omap16xx() || cpu_is_omap24xx())
 		omap_otg_init(&platform_data);
 	else if (cpu_is_omap15xx())
 		omap_1510_usb_init(&platform_data);
