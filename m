Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754780Ab0BAOI5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Feb 2010 09:08:57 -0500
Received: from mail-fx0-f220.google.com ([209.85.220.220]:58995 "EHLO
	mail-fx0-f220.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754738Ab0BAOIy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Feb 2010 09:08:54 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=f0iloohGHUpvir1muwIOEvQuF2bNvRHXMsZ096+ZZlKgJnS+r8GRG42E27bSjCPKNn
         e37ap/mAQKOyd4LxXg8vmepUOX+P2kUD95rphLPbA+0ZpvaNy0erwAlDC7TRQHXF2arv
         T/E6NcdCKeDK7Ax7n7o49vKNCYCGjNF7jP7Xo=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Date: Mon, 01 Feb 2010 15:08:44 +0100
Message-Id: <20100201140844.15716.43797.sendpatchset@localhost>
In-Reply-To: <20100201140832.15716.393.sendpatchset@localhost>
References: <20100201140832.15716.393.sendpatchset@localhost>
Subject: [PATCH 2/4] opti621: convert to ide2libata
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: [PATCH] opti621: convert to ide2libata

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ata/pata_opti.h |   55 ++++++++++++++++++++++-
 drivers/ide/opti621.c   |  114 +++---------------------------------------------
 2 files changed, 62 insertions(+), 107 deletions(-)

Index: b/drivers/ata/pata_opti.h
===================================================================
--- a/drivers/ata/pata_opti.h
+++ b/drivers/ata/pata_opti.h
@@ -21,8 +21,9 @@ enum {
 
 static void opti_write_reg(struct ata_port *ap, u8 val, int reg)
 {
+#ifndef __IDE2LIBATA
 	void __iomem *regio = ap->ioaddr.cmd_addr;
-
+#endif
 	/* These 3 unlock the control register access */
 	ioread16(regio + 1);
 	ioread16(regio + 1);
@@ -35,6 +36,23 @@ static void opti_write_reg(struct ata_po
 	iowrite8(0x83, regio + 2);
 }
 
+#ifdef __IDE2LIBATA
+static u8 opti_read_reg(int reg)
+{
+	u8 ret = 0;
+
+	ioread16(regio + 1);
+	ioread16(regio + 1);
+	iowrite8(3, regio + 2);
+
+	ret = ioread8(regio + reg);
+
+	iowrite8(0x83, regio + 2);
+
+	return ret;
+}
+#endif
+
 /**
  *	opti_set_piomode	-	set initial PIO mode data
  *	@ap: ATA interface
@@ -50,10 +68,15 @@ static void opti_set_piomode(struct ata_
 	struct ata_device *pair = ata_dev_pair(adev);
 	int clock;
 	int pio = adev->pio_mode - XFER_PIO_0;
+#ifndef __IDE2LIBATA
 	void __iomem *regio = ap->ioaddr.cmd_addr;
+#else
+	unsigned long flags;
+#endif
 	u8 addr;
 
 	/* Address table precomputed with prefetch off and a DCLK of 2 */
+#ifndef __IDE2LIBATA
 	static const u8 addr_timing[2][5] = {
 		{ 0x30, 0x20, 0x20, 0x10, 0x10 },
 		{ 0x20, 0x20, 0x10, 0x10, 0x10 }
@@ -62,10 +85,34 @@ static void opti_set_piomode(struct ata_
 		{ 0x6B, 0x56, 0x42, 0x32, 0x31 },
 		{ 0x58, 0x44, 0x32, 0x22, 0x21 }
 	};
+#else
+	static const u8 addr_timing[2][5] = {
+		{ 0x20, 0x10, 0x00, 0x00, 0x00 },	/* 33 MHz */
+		{ 0x10, 0x10, 0x00, 0x00, 0x00 },	/* 25 MHz */
+	};
+	static const u8 data_rec_timing[2][5] = {
+		{ 0x5b, 0x45, 0x32, 0x21, 0x20 },	/* 33 MHz */
+		{ 0x48, 0x34, 0x21, 0x10, 0x10 }	/* 25 MHz */
+	};
+
+	spin_lock_irqsave(&opti621_lock, flags);
+
+	regio = ap->io_ports.data_addr;
+
+	iowrite8(0xc0, regio + CNTRL_REG); /* allow Register-B */
+#endif
 
 	iowrite8(0xff, regio + 5);
+#ifdef __IDE2LIBATA
+	/* if reads 0xff, adapter not exist? */
+	(void)ioread8(regio + CNTRL_REG);
+	/* if reads 0xc0, no interface exist? */
+	opti_read_reg(CNTRL_REG);
+#endif
 	clock = ioread16(regio + 5) & 1;
-
+#ifdef __IDE2LIBATA
+	printk(KERN_INFO "%s: CLK = %d MHz\n", ap->name, clock ? 25 : 33);
+#endif
 	/*
 	 *	As with many controllers the address setup time is shared
 	 *	and must suit both devices if present.
@@ -87,4 +134,8 @@ static void opti_set_piomode(struct ata_
 
 	/* Programming sequence complete, override strapping */
 	opti_write_reg(ap, 0x85, CNTRL_REG);
+
+#ifdef __IDE2LIBATA
+	spin_unlock_irqrestore(&opti621_lock, flags);
+#endif
 }
Index: b/drivers/ide/opti621.c
===================================================================
--- a/drivers/ide/opti621.c
+++ b/drivers/ide/opti621.c
@@ -7,6 +7,7 @@
  * Jaromir Koutek <miri@punknet.cz>,
  * Jan Harkes <jaharkes@cwi.nl>,
  * Mark Lord <mlord@pobox.com>
+ * Bartlomiej Zolnierkiewicz
  * Some parts of code are from ali14xx.c and from rz1000.c.
  */
 
@@ -20,115 +21,18 @@
 
 #define DRV_NAME "opti621"
 
-#define READ_REG 0	/* index of Read cycle timing register */
-#define WRITE_REG 1	/* index of Write cycle timing register */
-#define CNTRL_REG 3	/* index of Control register */
-#define STRAP_REG 5	/* index of Strap register */
-#define MISC_REG 6	/* index of Miscellaneous register */
-
-static int reg_base;
+static int regio;
 
 static DEFINE_SPINLOCK(opti621_lock);
 
-/* Write value to register reg, base of register
- * is at reg_base (0x1f0 primary, 0x170 secondary,
- * if not changed by PCI configuration).
- * This is from setupvic.exe program.
- */
-static void write_reg(u8 value, int reg)
-{
-	inw(reg_base + 1);
-	inw(reg_base + 1);
-	outb(3, reg_base + 2);
-	outb(value, reg_base + reg);
-	outb(0x83, reg_base + 2);
-}
-
-/* Read value from register reg, base of register
- * is at reg_base (0x1f0 primary, 0x170 secondary,
- * if not changed by PCI configuration).
- * This is from setupvic.exe program.
- */
-static u8 read_reg(int reg)
-{
-	u8 ret = 0;
-
-	inw(reg_base + 1);
-	inw(reg_base + 1);
-	outb(3, reg_base + 2);
-	ret = inb(reg_base + reg);
-	outb(0x83, reg_base + 2);
-
-	return ret;
-}
-
-static void opti621_set_pio_mode(ide_hwif_t *hwif, ide_drive_t *drive)
-{
-	ide_drive_t *pair = ide_get_pair_dev(drive);
-	unsigned long flags;
-	unsigned long mode = drive->pio_mode, pair_mode;
-	const u8 pio = mode - XFER_PIO_0;
-	u8 tim, misc, addr_pio = pio, clk;
-
-	/* DRDY is default 2 (by OPTi Databook) */
-	static const u8 addr_timings[2][5] = {
-		{ 0x20, 0x10, 0x00, 0x00, 0x00 },	/* 33 MHz */
-		{ 0x10, 0x10, 0x00, 0x00, 0x00 },	/* 25 MHz */
-	};
-	static const u8 data_rec_timings[2][5] = {
-		{ 0x5b, 0x45, 0x32, 0x21, 0x20 },	/* 33 MHz */
-		{ 0x48, 0x34, 0x21, 0x10, 0x10 }	/* 25 MHz */
-	};
-
-	ide_set_drivedata(drive, (void *)mode);
-
-	if (pair) {
-		pair_mode = (unsigned long)ide_get_drivedata(pair);
-		if (pair_mode && pair_mode < mode)
-			addr_pio = pair_mode - XFER_PIO_0;
-	}
-
-	spin_lock_irqsave(&opti621_lock, flags);
-
-	reg_base = hwif->io_ports.data_addr;
-
-	/* allow Register-B */
-	outb(0xc0, reg_base + CNTRL_REG);
-	/* hmm, setupvic.exe does this ;-) */
-	outb(0xff, reg_base + 5);
-	/* if reads 0xff, adapter not exist? */
-	(void)inb(reg_base + CNTRL_REG);
-	/* if reads 0xc0, no interface exist? */
-	read_reg(CNTRL_REG);
-
-	/* check CLK speed */
-	clk = read_reg(STRAP_REG) & 1;
-
-	printk(KERN_INFO "%s: CLK = %d MHz\n", hwif->name, clk ? 25 : 33);
-
-	tim  = data_rec_timings[clk][pio];
-	misc = addr_timings[clk][addr_pio];
-
-	/* select Index-0/1 for Register-A/B */
-	write_reg(drive->dn & 1, MISC_REG);
-	/* set read cycle timings */
-	write_reg(tim, READ_REG);
-	/* set write cycle timings */
-	write_reg(tim, WRITE_REG);
-
-	/* use Register-A for drive 0 */
-	/* use Register-B for drive 1 */
-	write_reg(0x85, CNTRL_REG);
-
-	/* set address setup, DRDY timings,   */
-	/*  and read prefetch for both drives */
-	write_reg(misc, MISC_REG);
-
-	spin_unlock_irqrestore(&opti621_lock, flags);
-}
+#include <linux/ide2libata.h>
+#define ioread8 inb
+#define ioread16 inw
+#define iowrite8 outb
+#include "../ata/pata_opti.h"
 
 static const struct ide_port_ops opti621_port_ops = {
-	.set_pio_mode		= opti621_set_pio_mode,
+	.set_pio_mode		= opti_set_piomode,
 };
 
 static const struct ide_port_info opti621_chipset __devinitdata = {
@@ -173,6 +77,6 @@ static void __exit opti621_ide_exit(void
 module_init(opti621_ide_init);
 module_exit(opti621_ide_exit);
 
-MODULE_AUTHOR("Jaromir Koutek, Jan Harkes, Mark Lord");
+MODULE_AUTHOR("Jaromir Koutek, Jan Harkes, Mark Lord, Bartlomiej Zolnierkiewicz");
 MODULE_DESCRIPTION("PCI driver module for Opti621 IDE");
 MODULE_LICENSE("GPL");
