Return-Path: <linux-kernel-owner+w=401wt.eu-S1753926AbXDDSec@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753926AbXDDSec (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Apr 2007 14:34:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753931AbXDDSIm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Apr 2007 14:08:42 -0400
Received: from nlpi001.sbcis.sbc.com ([207.115.36.30]:36946 "EHLO
	nlpi001.sbcis.sbc.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753933AbXDDSIb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Apr 2007 14:08:31 -0400
X-ORBL: [67.117.73.34]
From: Tony Lindgren <tony@atomide.com>
To: linux-kernel@vger.kernel.org
Cc: Syed Mohammed Khasim <x0khasim@ti.com>, Tony Lindgren <tony@atomide.com>
Subject: [PATCH 27/90] ARM: OMAP: Add minimal OMAP2430 support
Date: Wed,  4 Apr 2007 14:05:06 -0400
Message-Id: <1175710033286-git-send-email-tony@atomide.com>
X-Mailer: git-send-email 1.4.4.2
In-Reply-To: <11757100302964-git-send-email-tony@atomide.com>
References: 11757088953851-git-send-email-tony@atomide.com <11757099691323-git-send-email-tony@atomide.com> <11757099743984-git-send-email-tony@atomide.com> <1175709977545-git-send-email-tony@atomide.com> <1175709988265-git-send-email-tony@atomide.com> <11757099942493-git-send-email-tony@atomide.com> <11757100011056-git-send-email-tony@atomide.com> <1175710003925-git-send-email-tony@atomide.com> <11757100063945-git-send-email-tony@atomide.com> <11757100092910-git-send-email-tony@atomide.com> <11757100112473-git-send-email-tony@atomide.com> <11757100143517-git-send-email-tony@atomide.com> <11757100163760-git-send-email-tony@atomide.com> <11757100181189-git-send-email-tony@atomide.com> <11757100214151-git-send-email-tony@atomide.com> <11757100242980-git-send-email-tony@atomide.com> <1175710026446-git-send-email-tony@atomide.com> <11757100281957-git-send-email-tony@atomide.com> <11757100302964-git-send-email-tony@atomide.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Syed Mohammed Khasim <x0khasim@ti.com>

This patch adds minimal OMAP2430 support to get the kernel booting on 2430SDP.

Signed-off-by: Syed Mohammed Khasim <x0khasim@ti.com>
Signed-off-by: Tony Lindgren <tony@atomide.com>
---
 arch/arm/mach-omap2/Kconfig               |    8 +
 arch/arm/mach-omap2/Makefile              |    1 +
 arch/arm/mach-omap2/board-2430sdp.c       |  226 +++++++++++++++++++++++++++++
 arch/arm/mach-omap2/devices.c             |    2 +-
 arch/arm/mach-omap2/gpmc.c                |    7 +
 arch/arm/mach-omap2/id.c                  |    6 +
 arch/arm/mach-omap2/io.c                  |   20 +++
 include/asm-arm/arch-omap/board-2430sdp.h |   41 +++++
 include/asm-arm/arch-omap/hardware.h      |    4 +
 include/asm-arm/arch-omap/io.h            |   10 ++
 include/asm-arm/arch-omap/irqs.h          |    1 +
 include/asm-arm/arch-omap/omap24xx.h      |   12 ++
 12 files changed, 337 insertions(+), 1 deletions(-)

diff --git a/arch/arm/mach-omap2/Kconfig b/arch/arm/mach-omap2/Kconfig
index 4c90cc7..47c8b57 100644
--- a/arch/arm/mach-omap2/Kconfig
+++ b/arch/arm/mach-omap2/Kconfig
@@ -10,6 +10,10 @@ config ARCH_OMAP2420
 	depends on ARCH_OMAP24XX
 	select OMAP_DM_TIMER
 
+config ARCH_OMAP2430
+	bool "OMAP2430 support"
+	depends on ARCH_OMAP24XX
+
 comment "OMAP Board Type"
 	depends on ARCH_OMAP2
 
@@ -25,3 +29,7 @@ config MACH_OMAP_H4
 config MACH_OMAP_APOLLON
 	bool "OMAP 2420 Apollon board"
 	depends on ARCH_OMAP2 && ARCH_OMAP24XX
+
+config MACH_OMAP_2430SDP
+	bool "OMAP 2430 SDP board"
+	depends on ARCH_OMAP2 && ARCH_OMAP24XX
\ No newline at end of file
diff --git a/arch/arm/mach-omap2/Makefile b/arch/arm/mach-omap2/Makefile
index 266d88e..b05b738 100644
--- a/arch/arm/mach-omap2/Makefile
+++ b/arch/arm/mach-omap2/Makefile
@@ -14,5 +14,6 @@ obj-$(CONFIG_PM) += pm.o pm-domain.o sleep.o
 # Specific board support
 obj-$(CONFIG_MACH_OMAP_GENERIC)		+= board-generic.o
 obj-$(CONFIG_MACH_OMAP_H4)		+= board-h4.o
+obj-$(CONFIG_MACH_OMAP_2430SDP)		+= board-2430sdp.o
 obj-$(CONFIG_MACH_OMAP_APOLLON)		+= board-apollon.o
 
diff --git a/arch/arm/mach-omap2/board-2430sdp.c b/arch/arm/mach-omap2/board-2430sdp.c
new file mode 100644
index 0000000..77e77c1
--- /dev/null
+++ b/arch/arm/mach-omap2/board-2430sdp.c
@@ -0,0 +1,226 @@
+/*
+ * linux/arch/arm/mach-omap/omap2/board-2430sdp.c
+ *
+ * Copyright (C) 2006 Texas Instruments
+ *
+ * Modified from mach-omap2/board-generic.c
+ *
+ * Initial Code : Based on a patch from Komal Shah and Richard Woodruff
+ * Updated the Code for 2430 SDP : Syed Mohammed Khasim
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#include <linux/kernel.h>
+#include <linux/init.h>
+#include <linux/platform_device.h>
+#include <linux/mtd/mtd.h>
+#include <linux/mtd/partitions.h>
+#include <linux/delay.h>
+#include <linux/workqueue.h>
+#include <linux/input.h>
+#include <linux/err.h>
+#include <linux/clk.h>
+
+#include <asm/hardware.h>
+#include <asm/mach-types.h>
+#include <asm/mach/arch.h>
+#include <asm/mach/map.h>
+#include <asm/mach/flash.h>
+
+#include <asm/arch/gpio.h>
+#include <asm/arch/gpioexpander.h>
+#include <asm/arch/mux.h>
+#include <asm/arch/usb.h>
+#include <asm/arch/irda.h>
+#include <asm/arch/board.h>
+#include <asm/arch/common.h>
+#include <asm/arch/keypad.h>
+#include <asm/arch/menelaus.h>
+#include <asm/arch/dma.h>
+#include <asm/arch/gpmc.h>
+#include "prcm-regs.h"
+
+#include <asm/io.h>
+
+
+#define	SDP2430_FLASH_CS	0
+#define	SDP2430_SMC91X_CS	5
+
+static struct mtd_partition sdp2430_partitions[] = {
+	/* bootloader (U-Boot, etc) in first sector */
+	{
+		.name		= "bootloader",
+		.offset		= 0,
+		.size		= SZ_256K,
+		.mask_flags	= MTD_WRITEABLE,	/* force read-only */
+	 },
+	/* bootloader params in the next sector */
+	{
+		.name		= "params",
+		.offset		= MTDPART_OFS_APPEND,
+		.size		= SZ_128K,
+		.mask_flags	= 0,
+	 },
+	/* kernel */
+	{
+		.name		= "kernel",
+		.offset		= MTDPART_OFS_APPEND,
+		.size		= SZ_2M,
+		.mask_flags	= 0
+	},
+	/* file system */
+	{
+		.name		= "filesystem",
+		.offset		= MTDPART_OFS_APPEND,
+		.size		= MTDPART_SIZ_FULL,
+		.mask_flags	= 0
+	}
+};
+
+static struct flash_platform_data sdp2430_flash_data = {
+	.map_name	= "cfi_probe",
+	.width		= 2,
+	.parts		= sdp2430_partitions,
+	.nr_parts	= ARRAY_SIZE(sdp2430_partitions),
+};
+
+static struct resource sdp2430_flash_resource = {
+	.start		= SDP2430_CS0_BASE,
+	.end		= SDP2430_CS0_BASE + SZ_64M - 1,
+	.flags		= IORESOURCE_MEM,
+};
+
+static struct platform_device sdp2430_flash_device = {
+	.name		= "omapflash",
+	.id		= 0,
+	.dev = {
+		.platform_data	= &sdp2430_flash_data,
+	},
+	.num_resources	= 1,
+	.resource	= &sdp2430_flash_resource,
+};
+
+static struct resource sdp2430_smc91x_resources[] = {
+	[0] = {
+		.start	= SDP2430_CS0_BASE,
+		.end	= SDP2430_CS0_BASE + SZ_64M - 1,
+		.flags	= IORESOURCE_MEM,
+	},
+	[1] = {
+		.start	= OMAP_GPIO_IRQ(OMAP24XX_ETHR_GPIO_IRQ),
+		.end	= OMAP_GPIO_IRQ(OMAP24XX_ETHR_GPIO_IRQ),
+		.flags	= IORESOURCE_IRQ,
+	},
+};
+
+static struct platform_device sdp2430_smc91x_device = {
+	.name		= "smc91x",
+	.id		= -1,
+	.num_resources	= ARRAY_SIZE(sdp2430_smc91x_resources),
+	.resource	= sdp2430_smc91x_resources,
+};
+
+static struct platform_device *sdp2430_devices[] __initdata = {
+	&sdp2430_smc91x_device,
+	&sdp2430_flash_device,
+};
+
+static inline void __init sdp2430_init_smc91x(void)
+{
+	int eth_cs;
+	unsigned long cs_mem_base;
+	unsigned int rate;
+	struct clk *l3ck;
+
+	eth_cs = SDP2430_SMC91X_CS;
+
+	l3ck = clk_get(NULL, "core_l3_ck");
+	if (IS_ERR(l3ck))
+		rate = 100000000;
+	else
+		rate = clk_get_rate(l3ck);
+
+	/* Make sure CS1 timings are correct, for 2430 always muxed */
+	gpmc_cs_write_reg(eth_cs, GPMC_CS_CONFIG1, 0x00011200);
+
+	if (rate >= 160000000) {
+		gpmc_cs_write_reg(eth_cs, GPMC_CS_CONFIG2, 0x001f1f01);
+		gpmc_cs_write_reg(eth_cs, GPMC_CS_CONFIG3, 0x00080803);
+		gpmc_cs_write_reg(eth_cs, GPMC_CS_CONFIG4, 0x1c0b1c0a);
+		gpmc_cs_write_reg(eth_cs, GPMC_CS_CONFIG5, 0x041f1F1F);
+		gpmc_cs_write_reg(eth_cs, GPMC_CS_CONFIG6, 0x000004C4);
+	} else if (rate >= 130000000) {
+		gpmc_cs_write_reg(eth_cs, GPMC_CS_CONFIG2, 0x001f1f00);
+		gpmc_cs_write_reg(eth_cs, GPMC_CS_CONFIG3, 0x00080802);
+		gpmc_cs_write_reg(eth_cs, GPMC_CS_CONFIG4, 0x1C091C09);
+		gpmc_cs_write_reg(eth_cs, GPMC_CS_CONFIG5, 0x041f1F1F);
+		gpmc_cs_write_reg(eth_cs, GPMC_CS_CONFIG6, 0x000004C4);
+	} else { /* rate = 100000000 */
+		gpmc_cs_write_reg(eth_cs, GPMC_CS_CONFIG2, 0x001f1f00);
+		gpmc_cs_write_reg(eth_cs, GPMC_CS_CONFIG3, 0x00080802);
+		gpmc_cs_write_reg(eth_cs, GPMC_CS_CONFIG4, 0x1C091C09);
+		gpmc_cs_write_reg(eth_cs, GPMC_CS_CONFIG5, 0x031A1F1F);
+		gpmc_cs_write_reg(eth_cs, GPMC_CS_CONFIG6, 0x000003C2);
+	}
+
+	if (gpmc_cs_request(eth_cs, SZ_16M, &cs_mem_base) < 0) {
+		printk(KERN_ERR "Failed to request GPMC mem for smc91x\n");
+		return;
+	}
+
+	sdp2430_smc91x_resources[0].start = cs_mem_base + 0x300;
+	sdp2430_smc91x_resources[0].end = cs_mem_base + 0x30f;
+	udelay(100);
+
+	if (omap_request_gpio(OMAP24XX_ETHR_GPIO_IRQ) < 0) {
+		printk(KERN_ERR "Failed to request GPIO%d for smc91x IRQ\n",
+			OMAP24XX_ETHR_GPIO_IRQ);
+		gpmc_cs_free(eth_cs);
+		return;
+	}
+	omap_set_gpio_direction(OMAP24XX_ETHR_GPIO_IRQ, 1);
+
+}
+
+static void __init omap_2430sdp_init_irq(void)
+{
+	omap2_init_common_hw();
+	omap_init_irq();
+	omap_gpio_init();
+	sdp2430_init_smc91x();
+}
+
+static struct omap_uart_config sdp2430_uart_config __initdata = {
+	.enabled_uarts = ((1 << 0) | (1 << 1) | (1 << 2)),
+};
+
+static struct omap_board_config_kernel sdp2430_config[] = {
+	{OMAP_TAG_UART, &sdp2430_uart_config},
+};
+
+static void __init omap_2430sdp_init(void)
+{
+	platform_add_devices(sdp2430_devices, ARRAY_SIZE(sdp2430_devices));
+	omap_board_config = sdp2430_config;
+	omap_board_config_size = ARRAY_SIZE(sdp2430_config);
+	omap_serial_init();
+}
+
+static void __init omap_2430sdp_map_io(void)
+{
+	omap2_map_common_io();
+}
+
+MACHINE_START(OMAP_2430SDP, "OMAP2430 sdp2430 board")
+	/* Maintainer: Syed Khasim - Texas Instruments Inc */
+	.phys_io	= 0x48000000,
+	.io_pg_offst	= ((0xd8000000) >> 18) & 0xfffc,
+	.boot_params	= 0x80000100,
+	.map_io		= omap_2430sdp_map_io,
+	.init_irq	= omap_2430sdp_init_irq,
+	.init_machine	= omap_2430sdp_init,
+	.timer		= &omap_timer,
+MACHINE_END
diff --git a/arch/arm/mach-omap2/devices.c b/arch/arm/mach-omap2/devices.c
index aa43224..cb5e775 100644
--- a/arch/arm/mach-omap2/devices.c
+++ b/arch/arm/mach-omap2/devices.c
@@ -52,7 +52,7 @@ static struct platform_device omap_i2c_device2 = {
 static void omap_init_i2c(void)
 {
 	/* REVISIT: Second I2C not in use on H4? */
-	if (machine_is_omap_h4())
+	if (machine_is_omap_h4() || machine_is_omap_2430sdp())
 		return;
 
 	omap_cfg_reg(J15_24XX_I2C2_SCL);
diff --git a/arch/arm/mach-omap2/gpmc.c b/arch/arm/mach-omap2/gpmc.c
index 3236e12..032c20d 100644
--- a/arch/arm/mach-omap2/gpmc.c
+++ b/arch/arm/mach-omap2/gpmc.c
@@ -22,7 +22,14 @@
 
 #undef DEBUG
 
+#ifdef CONFIG_ARCH_OMAP2420
 #define GPMC_BASE		0x6800a000
+#endif
+
+#ifdef CONFIG_ARCH_OMAP2430
+#define GPMC_BASE		0x6E000000
+#endif
+
 #define GPMC_REVISION		0x00
 #define GPMC_SYSCONFIG		0x10
 #define GPMC_SYSSTATUS		0x14
diff --git a/arch/arm/mach-omap2/id.c b/arch/arm/mach-omap2/id.c
index 871ace4..4dfd878 100644
--- a/arch/arm/mach-omap2/id.c
+++ b/arch/arm/mach-omap2/id.c
@@ -17,7 +17,13 @@
 
 #include <asm/io.h>
 
+#if defined(CONFIG_ARCH_OMAP2420)
 #define OMAP24XX_TAP_BASE	io_p2v(0x48014000)
+#endif
+
+#if defined(CONFIG_ARCH_OMAP2430)
+#define OMAP24XX_TAP_BASE	io_p2v(0x4900A000)
+#endif
 
 #define OMAP_TAP_IDCODE		0x0204
 #define OMAP_TAP_PROD_ID	0x0208
diff --git a/arch/arm/mach-omap2/io.c b/arch/arm/mach-omap2/io.c
index 748920f..af4b6e4 100644
--- a/arch/arm/mach-omap2/io.c
+++ b/arch/arm/mach-omap2/io.c
@@ -5,6 +5,7 @@
  *
  * Copyright (C) 2005 Nokia Corporation
  * Author: Juha Yrjölä <juha.yrjola@nokia.com>
+ * Updated map desc to add 2430 support : <x0khasim@ti.com>
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License version 2 as
@@ -40,6 +41,20 @@ static struct map_desc omap2_io_desc[] __initdata = {
 		.length		= L3_24XX_SIZE,
 		.type		= MT_DEVICE
 	},
+#ifdef CONFIG_ARCH_OMAP2430
+	{
+		.virtual	= L4_WK_243X_VIRT,
+		.pfn		= __phys_to_pfn(L4_WK_243X_PHYS),
+		.length		= L4_WK_243X_SIZE,
+		.type		= MT_DEVICE
+	},
+	{
+		.virtual	= OMAP243X_GPMC_VIRT,
+		.pfn		= __phys_to_pfn(OMAP243X_GPMC_PHYS),
+		.length		= OMAP243X_GPMC_SIZE,
+		.type		= MT_DEVICE
+	},
+#endif
 	{
 		.virtual	= L4_24XX_VIRT,
 		.pfn		= __phys_to_pfn(L4_24XX_PHYS),
@@ -68,6 +83,11 @@ void __init omap2_init_common_hw(void)
 {
 	omap2_mux_init();
 	omap2_clk_init();
+/*
+ * Need to Fix this for 2430
+ */
+#ifndef CONFIG_ARCH_OMAP2430
 	omap2_init_memory();
+#endif
 	gpmc_init();
 }
diff --git a/include/asm-arm/arch-omap/board-2430sdp.h b/include/asm-arm/arch-omap/board-2430sdp.h
new file mode 100644
index 0000000..6749ad7
--- /dev/null
+++ b/include/asm-arm/arch-omap/board-2430sdp.h
@@ -0,0 +1,41 @@
+/*
+ * linux/include/asm-arm/arch-omap/board-2430sdp.h
+ *
+ * Hardware definitions for TI OMAP2430 SDP board.
+ *
+ * Based on board-h4.h by Dirk Behme <dirk.behme@de.bosch.com>
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License as published by the
+ * Free Software Foundation; either version 2 of the License, or (at your
+ * option) any later version.
+ *
+ * THIS SOFTWARE IS PROVIDED ``AS IS'' AND ANY EXPRESS OR IMPLIED
+ * WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF
+ * MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN
+ * NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY DIRECT, INDIRECT,
+ * INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT
+ * NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF
+ * USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON
+ * ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
+ * (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF
+ * THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
+ *
+ * You should have received a copy of the GNU General Public License along
+ * with this program; if not, write to the Free Software Foundation, Inc.,
+ * 675 Mass Ave, Cambridge, MA 02139, USA.
+ */
+
+#ifndef __ASM_ARCH_OMAP_2430SDP_H
+#define __ASM_ARCH_OMAP_2430SDP_H
+
+/* Placeholder for 2430SDP specific defines */
+#define OMAP24XX_ETHR_START		 0x08000300
+#define OMAP24XX_ETHR_GPIO_IRQ		149
+#define SDP2430_CS0_BASE		0x04000000
+
+/*
+ * Just a place holder, need to add more
+ */
+
+#endif				/*  __ASM_ARCH_OMAP_2430SDP_H */
diff --git a/include/asm-arm/arch-omap/hardware.h b/include/asm-arm/arch-omap/hardware.h
index df4f168..1a111a0 100644
--- a/include/asm-arm/arch-omap/hardware.h
+++ b/include/asm-arm/arch-omap/hardware.h
@@ -309,6 +309,10 @@
 #include "board-h4.h"
 #endif
 
+#ifdef CONFIG_MACH_OMAP_2430SDP
+#include "board-2430sdp.h"
+#endif
+
 #ifdef CONFIG_MACH_OMAP_APOLLON
 #include "board-apollon.h"
 #endif
diff --git a/include/asm-arm/arch-omap/io.h b/include/asm-arm/arch-omap/io.h
index 78f68e6..cc100cb 100644
--- a/include/asm-arm/arch-omap/io.h
+++ b/include/asm-arm/arch-omap/io.h
@@ -72,6 +72,16 @@
 #define L4_24XX_PHYS	L4_24XX_BASE	/* 0x48000000 */
 #define L4_24XX_VIRT	0xd8000000
 #define L4_24XX_SIZE	SZ_1M		/* 1MB of 128MB used, want 1MB sect */
+
+#ifdef CONFIG_ARCH_OMAP2430
+#define L4_WK_243X_PHYS		L4_WK_243X_BASE		/* 0x49000000 */
+#define L4_WK_243X_VIRT		0xd9000000
+#define L4_WK_243X_SIZE		SZ_1M
+#define OMAP243X_GPMC_PHYS	OMAP243X_GPMC_BASE	/* 0x49000000 */
+#define OMAP243X_GPMC_VIRT	0xFE000000
+#define OMAP243X_GPMC_SIZE	SZ_1M
+#endif
+
 #define IO_OFFSET	0x90000000
 #define IO_ADDRESS(pa)	((pa) + IO_OFFSET)	/* Works for L3 and L4 */
 #define io_p2v(pa)	((pa) + IO_OFFSET)	/* Works for L3 and L4 */
diff --git a/include/asm-arm/arch-omap/irqs.h b/include/asm-arm/arch-omap/irqs.h
index c5bb05a..8d4b958 100644
--- a/include/asm-arm/arch-omap/irqs.h
+++ b/include/asm-arm/arch-omap/irqs.h
@@ -243,6 +243,7 @@
 #define INT_24XX_GPIO_BANK2	30
 #define INT_24XX_GPIO_BANK3	31
 #define INT_24XX_GPIO_BANK4	32
+#define INT_24XX_GPIO_BANK5	33
 #define INT_24XX_GPTIMER1	37
 #define INT_24XX_GPTIMER2	38
 #define INT_24XX_GPTIMER3	39
diff --git a/include/asm-arm/arch-omap/omap24xx.h b/include/asm-arm/arch-omap/omap24xx.h
index 6e59805..f9187a7 100644
--- a/include/asm-arm/arch-omap/omap24xx.h
+++ b/include/asm-arm/arch-omap/omap24xx.h
@@ -8,6 +8,7 @@
  */
 
 #define L4_24XX_BASE		0x48000000
+#define L4_WK_243X_BASE		0x49000000
 #define L3_24XX_BASE		0x68000000
 
 /* interrupt controller */
@@ -16,9 +17,20 @@
 #define OMAP24XX_IVA_INTC_BASE	0x40000000
 #define IRQ_SIR_IRQ		0x0040
 
+#ifdef CONFIG_ARCH_OMAP2420
 #define OMAP24XX_32KSYNCT_BASE	(L4_24XX_BASE + 0x4000)
 #define OMAP24XX_PRCM_BASE	(L4_24XX_BASE + 0x8000)
 #define OMAP24XX_SDRC_BASE	(L3_24XX_BASE + 0x9000)
+#define OMAP242X_CONTROL_STATUS	(L4_24XX_BASE + 0x2f8)
+#endif
+
+#ifdef CONFIG_ARCH_OMAP2430
+#define OMAP24XX_32KSYNCT_BASE	(L4_WK_243X_BASE + 0x20000)
+#define OMAP24XX_PRCM_BASE	(L4_WK_243X_BASE + 0x6000)
+#define OMAP24XX_SDRC_BASE	(0x6D000000)
+#define OMAP242X_CONTROL_STATUS	(L4_24XX_BASE + 0x2f8)
+#define OMAP243X_GPMC_BASE	0x6E000000
+#endif
 
 #endif /* __ASM_ARCH_OMAP24XX_H */
 
-- 
1.4.4.2

