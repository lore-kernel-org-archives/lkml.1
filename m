Return-Path: <linux-kernel-owner+w=401wt.eu-S1759773AbYEACTz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759773AbYEACTz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2008 22:19:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759802AbYEACRp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Apr 2008 22:17:45 -0400
Received: from rex.securecomputing.com ([203.24.151.4]:57512 "EHLO
	snapgear.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1759704AbYEACRn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2008 22:17:43 -0400
Date: Thu, 1 May 2008 12:17:08 +1000
From: Greg Ungerer <gerg@snapgear.com>
Message-Id: <200805010217.m412H87U004127@goober>
To: torvalds@linux-foundation.org
Subject: [PATCH] m68knommu: add WilFire and WildfireMod board support
Cc: akpm@linux-foundation.org, gerg@uclinux.org, linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steve Bennett <steveb@workware.net.au>

This patch adds linux-2.6.x kernel support for the Intec Automation
ColdFire 5282-based boards, the WildFire and WildFireMod

Signed-Off-By: Steve Bennett <steveb@workware.net.au>
Signed-off-by: Greg Ungerer <gerg@uclinux.org>
---


diff -Naurp linux-2.6.25/arch/m68knommu/platform/528x/config.c linux-2.6.25-uc0/arch/m68knommu/platform/528x/config.c
--- linux-2.6.25/arch/m68knommu/platform/528x/config.c	2008-04-17 12:49:44.000000000 +1000
+++ linux-2.6.25-uc0/arch/m68knommu/platform/528x/config.c	2008-04-22 14:48:44.000000000 +1000
@@ -26,9 +26,240 @@
 #include <asm/mcfuart.h>
 #include <asm/mcfqspi.h>
 
+#ifdef CONFIG_MTD_PARTITIONS
+#include <linux/mtd/partitions.h>
+#endif
+
 /***************************************************************************/
 
 void coldfire_reset(void);
+static void coldfire_qspi_cs_control(u8 cs, u8 command);
+
+/***************************************************************************/
+
+#if defined(CONFIG_SPI)
+
+#if defined(CONFIG_WILDFIRE)
+#define SPI_NUM_CHIPSELECTS 	0x02
+#define SPI_PAR_VAL		0x07  /* Enable DIN, DOUT, CLK */
+#define SPI_CS_MASK		0x18
+
+#define FLASH_BLOCKSIZE		(1024*64)
+#define FLASH_NUMBLOCKS		16
+#define FLASH_TYPE		"m25p80"
+
+#define M25P80_CS		0
+#define MMC_CS			1
+
+#ifdef CONFIG_MTD_PARTITIONS
+static struct mtd_partition stm25p_partitions[] = {
+	/* sflash */
+	[0] = {
+		.name = "stm25p80",
+		.offset = 0x00000000,
+		.size = FLASH_BLOCKSIZE * FLASH_NUMBLOCKS,
+		.mask_flags = 0
+	}
+};
+
+#endif
+
+#elif defined(CONFIG_WILDFIREMOD)
+
+#define SPI_NUM_CHIPSELECTS	0x08
+#define SPI_PAR_VAL		0x07  /* Enable DIN, DOUT, CLK */
+#define SPI_CS_MASK		0x78
+
+#define FLASH_BLOCKSIZE		(1024*64)
+#define FLASH_NUMBLOCKS		64
+#define FLASH_TYPE		"m25p32"
+/* Reserve 1M for the kernel parition */
+#define FLASH_KERNEL_SIZE   (1024 * 1024)
+
+#define M25P80_CS		5
+#define MMC_CS			6
+
+#ifdef CONFIG_MTD_PARTITIONS
+static struct mtd_partition stm25p_partitions[] = {
+	/* sflash */
+	[0] = {
+		.name = "kernel",
+		.offset = FLASH_BLOCKSIZE * FLASH_NUMBLOCKS - FLASH_KERNEL_SIZE,
+		.size = FLASH_KERNEL_SIZE,
+		.mask_flags = 0
+	},
+	[1] = {
+		.name = "image",
+		.offset = 0x00000000,
+		.size = FLASH_BLOCKSIZE * FLASH_NUMBLOCKS - FLASH_KERNEL_SIZE,
+		.mask_flags = 0
+	},
+	[2] = {
+		.name = "all",
+		.offset = 0x00000000,
+		.size = FLASH_BLOCKSIZE * FLASH_NUMBLOCKS,
+		.mask_flags = 0
+	}
+};
+#endif
+
+#else
+#define SPI_NUM_CHIPSELECTS 	0x04
+#define SPI_PAR_VAL		0x7F  /* Enable DIN, DOUT, CLK, CS0 - CS4 */
+#endif
+
+#ifdef MMC_CS
+static struct coldfire_spi_chip flash_chip_info = {
+	.mode = SPI_MODE_0,
+	.bits_per_word = 16,
+	.del_cs_to_clk = 17,
+	.del_after_trans = 1,
+	.void_write_data = 0
+};
+
+static struct coldfire_spi_chip mmc_chip_info = {
+	.mode = SPI_MODE_0,
+	.bits_per_word = 16,
+	.del_cs_to_clk = 17,
+	.del_after_trans = 1,
+	.void_write_data = 0xFFFF
+};
+#endif
+
+#ifdef M25P80_CS
+static struct flash_platform_data stm25p80_platform_data = {
+	.name = "ST M25P80 SPI Flash chip",
+#ifdef CONFIG_MTD_PARTITIONS
+	.parts = stm25p_partitions,
+	.nr_parts = sizeof(stm25p_partitions) / sizeof(*stm25p_partitions),
+#endif
+	.type = FLASH_TYPE
+};
+#endif
+
+static struct spi_board_info spi_board_info[] __initdata = {
+#ifdef M25P80_CS
+	{
+		.modalias = "m25p80",
+		.max_speed_hz = 16000000,
+		.bus_num = 1,
+		.chip_select = M25P80_CS,
+		.platform_data = &stm25p80_platform_data,
+		.controller_data = &flash_chip_info
+	},
+#endif
+#ifdef MMC_CS
+	{
+		.modalias = "mmc_spi",
+		.max_speed_hz = 16000000,
+		.bus_num = 1,
+		.chip_select = MMC_CS,
+		.controller_data = &mmc_chip_info
+	}
+#endif
+};
+
+static struct coldfire_spi_master coldfire_master_info = {
+	.bus_num = 1,
+	.num_chipselect = SPI_NUM_CHIPSELECTS,
+	.irq_source = MCF5282_QSPI_IRQ_SOURCE,
+	.irq_vector = MCF5282_QSPI_IRQ_VECTOR,
+	.irq_mask = ((0x01 << MCF5282_QSPI_IRQ_SOURCE) | 0x01),
+	.irq_lp = 0x2B,  /* Level 5 and Priority 3 */
+	.par_val = SPI_PAR_VAL,
+	.cs_control = coldfire_qspi_cs_control,
+};
+
+static struct resource coldfire_spi_resources[] = {
+	[0] = {
+		.name = "qspi-par",
+		.start = MCF5282_QSPI_PAR,
+		.end = MCF5282_QSPI_PAR,
+		.flags = IORESOURCE_MEM
+	},
+
+	[1] = {
+		.name = "qspi-module",
+		.start = MCF5282_QSPI_QMR,
+		.end = MCF5282_QSPI_QMR + 0x18,
+		.flags = IORESOURCE_MEM
+	},
+
+	[2] = {
+		.name = "qspi-int-level",
+		.start = MCF5282_INTC0 + MCFINTC_ICR0 + MCF5282_QSPI_IRQ_SOURCE,
+		.end = MCF5282_INTC0 + MCFINTC_ICR0 + MCF5282_QSPI_IRQ_SOURCE,
+		.flags = IORESOURCE_MEM
+	},
+
+	[3] = {
+		.name = "qspi-int-mask",
+		.start = MCF5282_INTC0 + MCFINTC_IMRL,
+		.end = MCF5282_INTC0 + MCFINTC_IMRL,
+		.flags = IORESOURCE_MEM
+	}
+};
+
+static struct platform_device coldfire_spi = {
+	.name = "spi_coldfire",
+	.id = -1,
+	.resource = coldfire_spi_resources,
+	.num_resources = ARRAY_SIZE(coldfire_spi_resources),
+	.dev = {
+		.platform_data = &coldfire_master_info,
+	}
+};
+
+static void coldfire_qspi_cs_control(u8 cs, u8 command)
+{
+	u8 cs_bit = ((0x01 << cs) << 3) & SPI_CS_MASK;
+
+#if defined(CONFIG_WILDFIRE)
+	u8 cs_mask = ~(((0x01 << cs) << 3) & SPI_CS_MASK);
+#endif
+#if defined(CONFIG_WILDFIREMOD)
+	u8 cs_mask = (cs << 3) & SPI_CS_MASK;
+#endif
+
+	/*
+	 * Don't do anything if the chip select is not
+	 * one of the port qs pins.
+	 */
+	if (command & QSPI_CS_INIT) {
+#if defined(CONFIG_WILDFIRE)
+		MCF5282_GPIO_DDRQS  |= cs_bit;
+		MCF5282_GPIO_PQSPAR &= ~cs_bit;
+#endif
+
+#if defined(CONFIG_WILDFIREMOD)
+		MCF5282_GPIO_DDRQS  |= SPI_CS_MASK;
+		MCF5282_GPIO_PQSPAR &= ~SPI_CS_MASK;
+#endif
+	}
+
+	if (command & QSPI_CS_ASSERT) {
+		MCF5282_GPIO_PORTQS &= ~SPI_CS_MASK;
+		MCF5282_GPIO_PORTQS |= cs_mask;
+	} else if (command & QSPI_CS_DROP) {
+		MCF5282_GPIO_PORTQS |= SPI_CS_MASK;
+	}
+}
+
+static int __init spi_dev_init(void)
+{
+	int retval;
+
+	retval = platform_device_register(&coldfire_spi);
+	if (retval < 0)
+		return retval;
+
+	if (ARRAY_SIZE(spi_board_info))
+		retval = spi_register_board_info(spi_board_info, ARRAY_SIZE(spi_board_info));
+
+	return retval;
+}
+
+#endif /* CONFIG_SPI */
 
 /***************************************************************************/
 
@@ -111,10 +342,43 @@ void mcf_autovector(unsigned int vec)
 
 /***************************************************************************/
 
+#ifdef CONFIG_WILDFIRE
+void wildfire_halt(void)
+{
+	writeb(0, 0x30000007);
+	writeb(0x2, 0x30000007);
+}
+#endif
+
+#ifdef CONFIG_WILDFIREMOD
+void wildfiremod_halt(void)
+{
+	printk(KERN_INFO "WildFireMod hibernating...\n");
+
+	/* Set portE.5 to Digital IO */
+	MCF5282_GPIO_PEPAR &= ~(1 << (5 * 2));
+
+	/* Make portE.5 an output */
+	MCF5282_GPIO_DDRE |= (1 << 5);
+
+	/* Now toggle portE.5 from low to high */
+	MCF5282_GPIO_PORTE &= ~(1 << 5);
+	MCF5282_GPIO_PORTE |= (1 << 5);
+
+	printk(KERN_EMERG "Failed to hibernate. Halting!\n");
+}
+#endif
+
 void __init config_BSP(char *commandp, int size)
 {
 	mcf_disableall();
-	mach_reset = coldfire_reset;
+
+#ifdef CONFIG_WILDFIRE
+	mach_halt = wildfire_halt;
+#endif
+#ifdef CONFIG_WILDFIREMOD
+	mach_halt = wildfiremod_halt;
+#endif
 }
 
 /***************************************************************************/
