Return-Path: <linux-kernel-owner+w=401wt.eu-S1755033AbYAANuV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755033AbYAANuV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jan 2008 08:50:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755237AbYAANs6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Jan 2008 08:48:58 -0500
Received: from smtp5.pp.htv.fi ([213.243.153.39]:50118 "EHLO smtp5.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755227AbYAANsy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jan 2008 08:48:54 -0500
Date: Tue, 1 Jan 2008 15:48:39 +0200
From: Adrian Bunk <bunk@kernel.org>
To: Thomas Gleixner <tglx@cruncher.tec.linutronix.de>, dwmw2@infradead.org
Cc: linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [2.6 patch] remove broken MTD drivers
Message-ID: <20080101134839.GN2360@does.not.exist>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch removes two MTD drivers that have been marked as
BROKEN 19 months ago due to requiring nonexisting header files.

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---

This patch has been sent on:
- 24 Oct 2007

 drivers/mtd/nand/Kconfig          |   12 
 drivers/mtd/nand/Makefile         |    2 
 drivers/mtd/nand/ppchameleonevb.c |  439 ------------------------------
 drivers/mtd/nand/toto.c           |  208 --------------
 4 files changed, 661 deletions(-)

eb65564be12f427ae8a96a2ffa7e727a814e1129 
diff --git a/drivers/mtd/nand/Kconfig b/drivers/mtd/nand/Kconfig
index 246d451..fa6b8b5 100644
--- a/drivers/mtd/nand/Kconfig
+++ b/drivers/mtd/nand/Kconfig
@@ -69,12 +69,6 @@ config MTD_NAND_AMS_DELTA
 	help
 	  Support for NAND flash on Amstrad E3 (Delta).
 
-config MTD_NAND_TOTO
-	tristate "NAND Flash device on TOTO board"
-	depends on ARCH_OMAP && BROKEN
-	help
-	  Support for NAND flash on Texas Instruments Toto platform.
-
 config MTD_NAND_TS7250
 	tristate "NAND Flash device on TS-7250 board"
 	depends on MACH_TS72XX
@@ -120,12 +114,6 @@ config MTD_NAND_RTC_FROM4
 	  This enables the driver for the Renesas Technology AG-AND
 	  flash interface board (FROM_BOARD4)
 
-config MTD_NAND_PPCHAMELEONEVB
-	tristate "NAND Flash device on PPChameleonEVB board"
-	depends on PPCHAMELEONEVB && BROKEN
-	help
-	  This enables the NAND flash driver on the PPChameleon EVB Board.
-
 config MTD_NAND_S3C2410
 	tristate "NAND Flash support for S3C2410/S3C2440 SoC"
 	depends on ARCH_S3C2410
diff --git a/drivers/mtd/nand/Makefile b/drivers/mtd/nand/Makefile
index 3ad6c01..f6b27de 100644
--- a/drivers/mtd/nand/Makefile
+++ b/drivers/mtd/nand/Makefile
@@ -9,12 +9,10 @@ obj-$(CONFIG_MTD_NAND_IDS)		+= nand_ids.o
 obj-$(CONFIG_MTD_NAND_CAFE)		+= cafe_nand.o
 obj-$(CONFIG_MTD_NAND_SPIA)		+= spia.o
 obj-$(CONFIG_MTD_NAND_AMS_DELTA)	+= ams-delta.o
-obj-$(CONFIG_MTD_NAND_TOTO)		+= toto.o
 obj-$(CONFIG_MTD_NAND_AUTCPU12)		+= autcpu12.o
 obj-$(CONFIG_MTD_NAND_EDB7312)		+= edb7312.o
 obj-$(CONFIG_MTD_NAND_AU1550)		+= au1550nd.o
 obj-$(CONFIG_MTD_NAND_BF5XX)		+= bf5xx_nand.o
-obj-$(CONFIG_MTD_NAND_PPCHAMELEONEVB)	+= ppchameleonevb.o
 obj-$(CONFIG_MTD_NAND_S3C2410)		+= s3c2410.o
 obj-$(CONFIG_MTD_NAND_DISKONCHIP)	+= diskonchip.o
 obj-$(CONFIG_MTD_NAND_H1900)		+= h1910.o
diff --git a/drivers/mtd/nand/ppchameleonevb.c b/drivers/mtd/nand/ppchameleonevb.c
deleted file mode 100644
index 082073a..0000000
--- a/drivers/mtd/nand/ppchameleonevb.c
+++ /dev/null
@@ -1,439 +0,0 @@
-/*
- *  drivers/mtd/nand/ppchameleonevb.c
- *
- *  Copyright (C) 2003 DAVE Srl (info@wawnet.biz)
- *
- *  Derived from drivers/mtd/nand/edb7312.c
- *
- *
- * $Id: ppchameleonevb.c,v 1.7 2005/11/07 11:14:31 gleixner Exp $
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License version 2 as
- * published by the Free Software Foundation.
- *
- *  Overview:
- *   This is a device driver for the NAND flash devices found on the
- *   PPChameleon/PPChameleonEVB system.
- *   PPChameleon options (autodetected):
- *   - BA model: no NAND
- *   - ME model: 32MB (Samsung K9F5608U0B)
- *   - HI model: 128MB (Samsung K9F1G08UOM)
- *   PPChameleonEVB options:
- *   - 32MB (Samsung K9F5608U0B)
- */
-
-#include <linux/init.h>
-#include <linux/slab.h>
-#include <linux/module.h>
-#include <linux/mtd/mtd.h>
-#include <linux/mtd/nand.h>
-#include <linux/mtd/partitions.h>
-#include <asm/io.h>
-#include <platforms/PPChameleonEVB.h>
-
-#undef USE_READY_BUSY_PIN
-#define USE_READY_BUSY_PIN
-/* see datasheets (tR) */
-#define NAND_BIG_DELAY_US		25
-#define NAND_SMALL_DELAY_US		10
-
-/* handy sizes */
-#define SZ_4M                           0x00400000
-#define NAND_SMALL_SIZE                 0x02000000
-#define NAND_MTD_NAME		"ppchameleon-nand"
-#define NAND_EVB_MTD_NAME	"ppchameleonevb-nand"
-
-/* GPIO pins used to drive NAND chip mounted on processor module */
-#define NAND_nCE_GPIO_PIN 		(0x80000000 >> 1)
-#define NAND_CLE_GPIO_PIN 		(0x80000000 >> 2)
-#define NAND_ALE_GPIO_PIN 		(0x80000000 >> 3)
-#define NAND_RB_GPIO_PIN 		(0x80000000 >> 4)
-/* GPIO pins used to drive NAND chip mounted on EVB */
-#define NAND_EVB_nCE_GPIO_PIN 	(0x80000000 >> 14)
-#define NAND_EVB_CLE_GPIO_PIN 	(0x80000000 >> 15)
-#define NAND_EVB_ALE_GPIO_PIN 	(0x80000000 >> 16)
-#define NAND_EVB_RB_GPIO_PIN 	(0x80000000 >> 31)
-
-/*
- * MTD structure for PPChameleonEVB board
- */
-static struct mtd_info *ppchameleon_mtd = NULL;
-static struct mtd_info *ppchameleonevb_mtd = NULL;
-
-/*
- * Module stuff
- */
-static unsigned long ppchameleon_fio_pbase = CFG_NAND0_PADDR;
-static unsigned long ppchameleonevb_fio_pbase = CFG_NAND1_PADDR;
-
-#ifdef MODULE
-module_param(ppchameleon_fio_pbase, ulong, 0);
-module_param(ppchameleonevb_fio_pbase, ulong, 0);
-#else
-__setup("ppchameleon_fio_pbase=", ppchameleon_fio_pbase);
-__setup("ppchameleonevb_fio_pbase=", ppchameleonevb_fio_pbase);
-#endif
-
-#ifdef CONFIG_MTD_PARTITIONS
-/*
- * Define static partitions for flash devices
- */
-static struct mtd_partition partition_info_hi[] = {
-      { .name = "PPChameleon HI Nand Flash",
-	.offset = 0,
-	.size = 128 * 1024 * 1024
-      }
-};
-
-static struct mtd_partition partition_info_me[] = {
-      { .name = "PPChameleon ME Nand Flash",
-	.offset = 0,
-	.size = 32 * 1024 * 1024
-      }
-};
-
-static struct mtd_partition partition_info_evb[] = {
-      { .name = "PPChameleonEVB Nand Flash",
-	.offset = 0,
-	.size = 32 * 1024 * 1024
-      }
-};
-
-#define NUM_PARTITIONS 1
-
-extern int parse_cmdline_partitions(struct mtd_info *master, struct mtd_partition **pparts, const char *mtd_id);
-#endif
-
-/*
- *	hardware specific access to control-lines
- */
-static void ppchameleon_hwcontrol(struct mtd_info *mtdinfo, int cmd,
-				  unsigned int ctrl)
-{
-	struct nand_chip *chip = mtd->priv;
-
-	if (ctrl & NAND_CTRL_CHANGE) {
-#error Missing headerfiles. No way to fix this. -tglx
-		switch (cmd) {
-		case NAND_CTL_SETCLE:
-			MACRO_NAND_CTL_SETCLE((unsigned long)CFG_NAND0_PADDR);
-			break;
-		case NAND_CTL_CLRCLE:
-			MACRO_NAND_CTL_CLRCLE((unsigned long)CFG_NAND0_PADDR);
-			break;
-		case NAND_CTL_SETALE:
-			MACRO_NAND_CTL_SETALE((unsigned long)CFG_NAND0_PADDR);
-			break;
-		case NAND_CTL_CLRALE:
-			MACRO_NAND_CTL_CLRALE((unsigned long)CFG_NAND0_PADDR);
-			break;
-		case NAND_CTL_SETNCE:
-			MACRO_NAND_ENABLE_CE((unsigned long)CFG_NAND0_PADDR);
-			break;
-		case NAND_CTL_CLRNCE:
-			MACRO_NAND_DISABLE_CE((unsigned long)CFG_NAND0_PADDR);
-			break;
-		}
-	}
-	if (cmd != NAND_CMD_NONE)
-		writeb(cmd, chip->IO_ADDR_W);
-}
-
-static void ppchameleonevb_hwcontrol(struct mtd_info *mtdinfo, int cmd,
-				     unsigned int ctrl)
-{
-	struct nand_chip *chip = mtd->priv;
-
-	if (ctrl & NAND_CTRL_CHANGE) {
-#error Missing headerfiles. No way to fix this. -tglx
-		switch (cmd) {
-		case NAND_CTL_SETCLE:
-			MACRO_NAND_CTL_SETCLE((unsigned long)CFG_NAND1_PADDR);
-			break;
-		case NAND_CTL_CLRCLE:
-			MACRO_NAND_CTL_CLRCLE((unsigned long)CFG_NAND1_PADDR);
-			break;
-		case NAND_CTL_SETALE:
-			MACRO_NAND_CTL_SETALE((unsigned long)CFG_NAND1_PADDR);
-			break;
-		case NAND_CTL_CLRALE:
-			MACRO_NAND_CTL_CLRALE((unsigned long)CFG_NAND1_PADDR);
-			break;
-		case NAND_CTL_SETNCE:
-			MACRO_NAND_ENABLE_CE((unsigned long)CFG_NAND1_PADDR);
-			break;
-		case NAND_CTL_CLRNCE:
-			MACRO_NAND_DISABLE_CE((unsigned long)CFG_NAND1_PADDR);
-			break;
-		}
-	}
-	if (cmd != NAND_CMD_NONE)
-		writeb(cmd, chip->IO_ADDR_W);
-}
-
-#ifdef USE_READY_BUSY_PIN
-/*
- *	read device ready pin
- */
-static int ppchameleon_device_ready(struct mtd_info *minfo)
-{
-	if (in_be32((volatile unsigned *)GPIO0_IR) & NAND_RB_GPIO_PIN)
-		return 1;
-	return 0;
-}
-
-static int ppchameleonevb_device_ready(struct mtd_info *minfo)
-{
-	if (in_be32((volatile unsigned *)GPIO0_IR) & NAND_EVB_RB_GPIO_PIN)
-		return 1;
-	return 0;
-}
-#endif
-
-#ifdef CONFIG_MTD_PARTITIONS
-const char *part_probes[] = { "cmdlinepart", NULL };
-const char *part_probes_evb[] = { "cmdlinepart", NULL };
-#endif
-
-/*
- * Main initialization routine
- */
-static int __init ppchameleonevb_init(void)
-{
-	struct nand_chip *this;
-	const char *part_type = 0;
-	int mtd_parts_nb = 0;
-	struct mtd_partition *mtd_parts = 0;
-	void __iomem *ppchameleon_fio_base;
-	void __iomem *ppchameleonevb_fio_base;
-
-	/*********************************
-	* Processor module NAND (if any) *
-	*********************************/
-	/* Allocate memory for MTD device structure and private data */
-	ppchameleon_mtd = kmalloc(sizeof(struct mtd_info) + sizeof(struct nand_chip), GFP_KERNEL);
-	if (!ppchameleon_mtd) {
-		printk("Unable to allocate PPChameleon NAND MTD device structure.\n");
-		return -ENOMEM;
-	}
-
-	/* map physical address */
-	ppchameleon_fio_base = ioremap(ppchameleon_fio_pbase, SZ_4M);
-	if (!ppchameleon_fio_base) {
-		printk("ioremap PPChameleon NAND flash failed\n");
-		kfree(ppchameleon_mtd);
-		return -EIO;
-	}
-
-	/* Get pointer to private data */
-	this = (struct nand_chip *)(&ppchameleon_mtd[1]);
-
-	/* Initialize structures */
-	memset(ppchameleon_mtd, 0, sizeof(struct mtd_info));
-	memset(this, 0, sizeof(struct nand_chip));
-
-	/* Link the private data with the MTD structure */
-	ppchameleon_mtd->priv = this;
-	ppchameleon_mtd->owner = THIS_MODULE;
-
-	/* Initialize GPIOs */
-	/* Pin mapping for NAND chip */
-	/*
-	   CE   GPIO_01
-	   CLE  GPIO_02
-	   ALE  GPIO_03
-	   R/B  GPIO_04
-	 */
-	/* output select */
-	out_be32((volatile unsigned *)GPIO0_OSRH, in_be32((volatile unsigned *)GPIO0_OSRH) & 0xC0FFFFFF);
-	/* three-state select */
-	out_be32((volatile unsigned *)GPIO0_TSRH, in_be32((volatile unsigned *)GPIO0_TSRH) & 0xC0FFFFFF);
-	/* enable output driver */
-	out_be32((volatile unsigned *)GPIO0_TCR,
-		 in_be32((volatile unsigned *)GPIO0_TCR) | NAND_nCE_GPIO_PIN | NAND_CLE_GPIO_PIN | NAND_ALE_GPIO_PIN);
-#ifdef USE_READY_BUSY_PIN
-	/* three-state select */
-	out_be32((volatile unsigned *)GPIO0_TSRH, in_be32((volatile unsigned *)GPIO0_TSRH) & 0xFF3FFFFF);
-	/* high-impedecence */
-	out_be32((volatile unsigned *)GPIO0_TCR, in_be32((volatile unsigned *)GPIO0_TCR) & (~NAND_RB_GPIO_PIN));
-	/* input select */
-	out_be32((volatile unsigned *)GPIO0_ISR1H,
-		 (in_be32((volatile unsigned *)GPIO0_ISR1H) & 0xFF3FFFFF) | 0x00400000);
-#endif
-
-	/* insert callbacks */
-	this->IO_ADDR_R = ppchameleon_fio_base;
-	this->IO_ADDR_W = ppchameleon_fio_base;
-	this->cmd_ctrl = ppchameleon_hwcontrol;
-#ifdef USE_READY_BUSY_PIN
-	this->dev_ready = ppchameleon_device_ready;
-#endif
-	this->chip_delay = NAND_BIG_DELAY_US;
-	/* ECC mode */
-	this->ecc.mode = NAND_ECC_SOFT;
-
-	/* Scan to find existence of the device (it could not be mounted) */
-	if (nand_scan(ppchameleon_mtd, 1)) {
-		iounmap((void *)ppchameleon_fio_base);
-		ppchameleon_fio_base = NULL;
-		kfree(ppchameleon_mtd);
-		goto nand_evb_init;
-	}
-#ifndef USE_READY_BUSY_PIN
-	/* Adjust delay if necessary */
-	if (ppchameleon_mtd->size == NAND_SMALL_SIZE)
-		this->chip_delay = NAND_SMALL_DELAY_US;
-#endif
-
-#ifdef CONFIG_MTD_PARTITIONS
-	ppchameleon_mtd->name = "ppchameleon-nand";
-	mtd_parts_nb = parse_mtd_partitions(ppchameleon_mtd, part_probes, &mtd_parts, 0);
-	if (mtd_parts_nb > 0)
-		part_type = "command line";
-	else
-		mtd_parts_nb = 0;
-#endif
-	if (mtd_parts_nb == 0) {
-		if (ppchameleon_mtd->size == NAND_SMALL_SIZE)
-			mtd_parts = partition_info_me;
-		else
-			mtd_parts = partition_info_hi;
-		mtd_parts_nb = NUM_PARTITIONS;
-		part_type = "static";
-	}
-
-	/* Register the partitions */
-	printk(KERN_NOTICE "Using %s partition definition\n", part_type);
-	add_mtd_partitions(ppchameleon_mtd, mtd_parts, mtd_parts_nb);
-
- nand_evb_init:
-	/****************************
-	* EVB NAND (always present) *
-	****************************/
-	/* Allocate memory for MTD device structure and private data */
-	ppchameleonevb_mtd = kmalloc(sizeof(struct mtd_info) + sizeof(struct nand_chip), GFP_KERNEL);
-	if (!ppchameleonevb_mtd) {
-		printk("Unable to allocate PPChameleonEVB NAND MTD device structure.\n");
-		if (ppchameleon_fio_base)
-			iounmap(ppchameleon_fio_base);
-		return -ENOMEM;
-	}
-
-	/* map physical address */
-	ppchameleonevb_fio_base = ioremap(ppchameleonevb_fio_pbase, SZ_4M);
-	if (!ppchameleonevb_fio_base) {
-		printk("ioremap PPChameleonEVB NAND flash failed\n");
-		kfree(ppchameleonevb_mtd);
-		if (ppchameleon_fio_base)
-			iounmap(ppchameleon_fio_base);
-		return -EIO;
-	}
-
-	/* Get pointer to private data */
-	this = (struct nand_chip *)(&ppchameleonevb_mtd[1]);
-
-	/* Initialize structures */
-	memset(ppchameleonevb_mtd, 0, sizeof(struct mtd_info));
-	memset(this, 0, sizeof(struct nand_chip));
-
-	/* Link the private data with the MTD structure */
-	ppchameleonevb_mtd->priv = this;
-
-	/* Initialize GPIOs */
-	/* Pin mapping for NAND chip */
-	/*
-	   CE   GPIO_14
-	   CLE  GPIO_15
-	   ALE  GPIO_16
-	   R/B  GPIO_31
-	 */
-	/* output select */
-	out_be32((volatile unsigned *)GPIO0_OSRH, in_be32((volatile unsigned *)GPIO0_OSRH) & 0xFFFFFFF0);
-	out_be32((volatile unsigned *)GPIO0_OSRL, in_be32((volatile unsigned *)GPIO0_OSRL) & 0x3FFFFFFF);
-	/* three-state select */
-	out_be32((volatile unsigned *)GPIO0_TSRH, in_be32((volatile unsigned *)GPIO0_TSRH) & 0xFFFFFFF0);
-	out_be32((volatile unsigned *)GPIO0_TSRL, in_be32((volatile unsigned *)GPIO0_TSRL) & 0x3FFFFFFF);
-	/* enable output driver */
-	out_be32((volatile unsigned *)GPIO0_TCR, in_be32((volatile unsigned *)GPIO0_TCR) | NAND_EVB_nCE_GPIO_PIN |
-		 NAND_EVB_CLE_GPIO_PIN | NAND_EVB_ALE_GPIO_PIN);
-#ifdef USE_READY_BUSY_PIN
-	/* three-state select */
-	out_be32((volatile unsigned *)GPIO0_TSRL, in_be32((volatile unsigned *)GPIO0_TSRL) & 0xFFFFFFFC);
-	/* high-impedecence */
-	out_be32((volatile unsigned *)GPIO0_TCR, in_be32((volatile unsigned *)GPIO0_TCR) & (~NAND_EVB_RB_GPIO_PIN));
-	/* input select */
-	out_be32((volatile unsigned *)GPIO0_ISR1L,
-		 (in_be32((volatile unsigned *)GPIO0_ISR1L) & 0xFFFFFFFC) | 0x00000001);
-#endif
-
-	/* insert callbacks */
-	this->IO_ADDR_R = ppchameleonevb_fio_base;
-	this->IO_ADDR_W = ppchameleonevb_fio_base;
-	this->cmd_ctrl = ppchameleonevb_hwcontrol;
-#ifdef USE_READY_BUSY_PIN
-	this->dev_ready = ppchameleonevb_device_ready;
-#endif
-	this->chip_delay = NAND_SMALL_DELAY_US;
-
-	/* ECC mode */
-	this->ecc.mode = NAND_ECC_SOFT;
-
-	/* Scan to find existence of the device */
-	if (nand_scan(ppchameleonevb_mtd, 1)) {
-		iounmap((void *)ppchameleonevb_fio_base);
-		kfree(ppchameleonevb_mtd);
-		if (ppchameleon_fio_base)
-			iounmap(ppchameleon_fio_base);
-		return -ENXIO;
-	}
-#ifdef CONFIG_MTD_PARTITIONS
-	ppchameleonevb_mtd->name = NAND_EVB_MTD_NAME;
-	mtd_parts_nb = parse_mtd_partitions(ppchameleonevb_mtd, part_probes_evb, &mtd_parts, 0);
-	if (mtd_parts_nb > 0)
-		part_type = "command line";
-	else
-		mtd_parts_nb = 0;
-#endif
-	if (mtd_parts_nb == 0) {
-		mtd_parts = partition_info_evb;
-		mtd_parts_nb = NUM_PARTITIONS;
-		part_type = "static";
-	}
-
-	/* Register the partitions */
-	printk(KERN_NOTICE "Using %s partition definition\n", part_type);
-	add_mtd_partitions(ppchameleonevb_mtd, mtd_parts, mtd_parts_nb);
-
-	/* Return happy */
-	return 0;
-}
-
-module_init(ppchameleonevb_init);
-
-/*
- * Clean up routine
- */
-static void __exit ppchameleonevb_cleanup(void)
-{
-	struct nand_chip *this;
-
-	/* Release resources, unregister device(s) */
-	nand_release(ppchameleon_mtd);
-	nand_release(ppchameleonevb_mtd);
-
-	/* Release iomaps */
-	this = (struct nand_chip *) &ppchameleon_mtd[1];
-	iounmap((void *) this->IO_ADDR_R);
-	this = (struct nand_chip *) &ppchameleonevb_mtd[1];
-	iounmap((void *) this->IO_ADDR_R);
-
-	/* Free the MTD device structure */
-	kfree (ppchameleon_mtd);
-	kfree (ppchameleonevb_mtd);
-}
-module_exit(ppchameleonevb_cleanup);
-
-MODULE_LICENSE("GPL");
-MODULE_AUTHOR("DAVE Srl <support-ppchameleon@dave-tech.it>");
-MODULE_DESCRIPTION("MTD map driver for DAVE Srl PPChameleonEVB board");
diff --git a/drivers/mtd/nand/toto.c b/drivers/mtd/nand/toto.c
deleted file mode 100644
index f9e2d4a..0000000
--- a/drivers/mtd/nand/toto.c
+++ /dev/null
@@ -1,208 +0,0 @@
-/*
- *  drivers/mtd/nand/toto.c
- *
- *  Copyright (c) 2003 Texas Instruments
- *
- *  Derived from drivers/mtd/autcpu12.c
- *
- *  Copyright (c) 2002 Thomas Gleixner <tgxl@linutronix.de>
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License version 2 as
- * published by the Free Software Foundation.
- *
- *  Overview:
- *   This is a device driver for the NAND flash device found on the
- *   TI fido board. It supports 32MiB and 64MiB cards
- *
- * $Id: toto.c,v 1.5 2005/11/07 11:14:31 gleixner Exp $
- */
-
-#include <linux/slab.h>
-#include <linux/init.h>
-#include <linux/module.h>
-#include <linux/delay.h>
-#include <linux/mtd/mtd.h>
-#include <linux/mtd/nand.h>
-#include <linux/mtd/partitions.h>
-#include <asm/io.h>
-#include <asm/arch/hardware.h>
-#include <asm/sizes.h>
-#include <asm/arch/toto.h>
-#include <asm/arch-omap1510/hardware.h>
-#include <asm/arch/gpio.h>
-
-#define CONFIG_NAND_WORKAROUND 1
-
-/*
- * MTD structure for TOTO board
- */
-static struct mtd_info *toto_mtd = NULL;
-
-static unsigned long toto_io_base = OMAP_FLASH_1_BASE;
-
-/*
- * Define partitions for flash devices
- */
-
-static struct mtd_partition partition_info64M[] = {
-	{ .name =	"toto kernel partition 1",
-	  .offset =	0,
-	  .size	=	2 * SZ_1M },
-	{ .name =	"toto file sys partition 2",
-	  .offset =	2 * SZ_1M,
-	  .size =	14 * SZ_1M },
-	{ .name =	"toto user partition 3",
-	  .offset =	16 * SZ_1M,
-	  .size =	16 * SZ_1M },
-	{ .name =	"toto devboard extra partition 4",
-	  .offset =	32 * SZ_1M,
-	  .size =	32 * SZ_1M },
-};
-
-static struct mtd_partition partition_info32M[] = {
-	{ .name =	"toto kernel partition 1",
-	  .offset =	0,
-	  .size =	2 * SZ_1M },
-	{ .name =	"toto file sys partition 2",
-	  .offset =	2 * SZ_1M,
-	  .size =	14 * SZ_1M },
-	{ .name =	"toto user partition 3",
-	  .offset =	16 * SZ_1M,
-	  .size =	16 * SZ_1M },
-};
-
-#define NUM_PARTITIONS32M 3
-#define NUM_PARTITIONS64M 4
-
-/*
- *	hardware specific access to control-lines
- *
- *	ctrl:
- *	NAND_NCE: bit 0 -> bit 14 (0x4000)
- *	NAND_CLE: bit 1 -> bit 12 (0x1000)
- *	NAND_ALE: bit 2 -> bit 1  (0x0002)
- */
-static void toto_hwcontrol(struct mtd_info *mtd, int cmd,
-			   unsigned int ctrl)
-{
-	struct nand_chip *chip = mtd->priv;
-
-	if (ctrl & NAND_CTRL_CHANGE) {
-		unsigned long bits;
-
-		/* hopefully enough time for tc make proceding write to clear */
-		udelay(1);
-
-		bits = (~ctrl & NAND_NCE) << 14;
-		bits |= (ctrl & NAND_CLE) << 12;
-		bits |= (ctrl & NAND_ALE) >> 1;
-
-#warning Wild guess as gpiosetout() is nowhere defined in the kernel source - tglx
-		gpiosetout(0x5002, bits);
-
-#ifdef CONFIG_NAND_WORKAROUND
-		/* "some" dev boards busted, blue wired to rts2 :( */
-		rts2setout(2, (ctrl & NAND_CLE) << 1);
-#endif
-		/* allow time to ensure gpio state to over take memory write */
-		udelay(1);
-	}
-
-	if (cmd != NAND_CMD_NONE)
-		writeb(cmd, chip->IO_ADDR_W);
-}
-
-/*
- * Main initialization routine
- */
-static int __init toto_init(void)
-{
-	struct nand_chip *this;
-	int err = 0;
-
-	/* Allocate memory for MTD device structure and private data */
-	toto_mtd = kmalloc(sizeof(struct mtd_info) + sizeof(struct nand_chip), GFP_KERNEL);
-	if (!toto_mtd) {
-		printk(KERN_WARNING "Unable to allocate toto NAND MTD device structure.\n");
-		err = -ENOMEM;
-		goto out;
-	}
-
-	/* Get pointer to private data */
-	this = (struct nand_chip *)(&toto_mtd[1]);
-
-	/* Initialize structures */
-	memset(toto_mtd, 0, sizeof(struct mtd_info));
-	memset(this, 0, sizeof(struct nand_chip));
-
-	/* Link the private data with the MTD structure */
-	toto_mtd->priv = this;
-	toto_mtd->owner = THIS_MODULE;
-
-	/* Set address of NAND IO lines */
-	this->IO_ADDR_R = toto_io_base;
-	this->IO_ADDR_W = toto_io_base;
-	this->cmd_ctrl = toto_hwcontrol;
-	this->dev_ready = NULL;
-	/* 25 us command delay time */
-	this->chip_delay = 30;
-	this->ecc.mode = NAND_ECC_SOFT;
-
-	/* Scan to find existance of the device */
-	if (nand_scan(toto_mtd, 1)) {
-		err = -ENXIO;
-		goto out_mtd;
-	}
-
-	/* Register the partitions */
-	switch (toto_mtd->size) {
-	case SZ_64M:
-		add_mtd_partitions(toto_mtd, partition_info64M, NUM_PARTITIONS64M);
-		break;
-	case SZ_32M:
-		add_mtd_partitions(toto_mtd, partition_info32M, NUM_PARTITIONS32M);
-		break;
-	default:{
-			printk(KERN_WARNING "Unsupported Nand device\n");
-			err = -ENXIO;
-			goto out_buf;
-		}
-	}
-
-	gpioreserve(NAND_MASK);	/* claim our gpios */
-	archflashwp(0, 0);	/* open up flash for writing */
-
-	goto out;
-
- out_mtd:
-	kfree(toto_mtd);
- out:
-	return err;
-}
-
-module_init(toto_init);
-
-/*
- * Clean up routine
- */
-static void __exit toto_cleanup(void)
-{
-	/* Release resources, unregister device */
-	nand_release(toto_mtd);
-
-	/* Free the MTD device structure */
-	kfree(toto_mtd);
-
-	/* stop flash writes */
-	archflashwp(0, 1);
-
-	/* release gpios to system */
-	gpiorelease(NAND_MASK);
-}
-
-module_exit(toto_cleanup);
-
-MODULE_LICENSE("GPL");
-MODULE_AUTHOR("Richard Woodruff <r-woodruff2@ti.com>");
-MODULE_DESCRIPTION("Glue layer for NAND flash on toto board");

