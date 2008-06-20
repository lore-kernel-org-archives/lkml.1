Return-Path: <linux-kernel-owner+w=401wt.eu-S1761505AbYFTVca@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761505AbYFTVca (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2008 17:32:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761084AbYFTVbu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Jun 2008 17:31:50 -0400
Received: from fk-out-0910.google.com ([209.85.128.190]:5898 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760995AbYFTVbr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2008 17:31:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=c72d3jNbWWIkKWZEeIi3HjibAaNzjMiUznuaTTowobndLg8hj/nDvUnQzp/TaID27A
         8jfNV4euljM+LeqcZDApQDuzAbbk3J7fjiOdu1an/yMKySiQ4mgoA/2M88FM9ozv6Xhl
         RXCJMIEf4OY+xiIFLFEKamodVhz5NCt0VV3fw=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Date: Fri, 20 Jun 2008 23:33:43 +0200
Message-Id: <20080620213343.13202.68218.sendpatchset@localhost.localdomain>
In-Reply-To: <20080620213323.13202.71450.sendpatchset@localhost.localdomain>
References: <20080620213323.13202.71450.sendpatchset@localhost.localdomain>
Subject: [PATCH 03/18] ide: remove ->dma_{status,command} fields from ide_hwif_t
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Use ->dma_base + offset instead of ->dma_{status,command}
  and remove no longer needed ->dma_{status,command}.

While at it:

* Use ATA_DMA_* defines.

There should be no functional changes caused by this patch.

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/ide-dma.c          |   42 ++++++++++++++++++++---------------------
 drivers/ide/ide-iops.c         |    4 +--
 drivers/ide/pci/cmd64x.c       |   12 +++++------
 drivers/ide/pci/hpt366.c       |   10 ++++-----
 drivers/ide/pci/ns87415.c      |   14 ++++++-------
 drivers/ide/pci/pdc202xx_old.c |    2 -
 drivers/ide/pci/piix.c         |    4 +--
 drivers/ide/pci/scc_pata.c     |   38 +++++++++++++++++--------------------
 drivers/ide/pci/siimage.c      |    4 +--
 drivers/ide/pci/sl82c105.c     |    4 +--
 drivers/ide/pci/tc86c001.c     |   13 +++++++-----
 include/linux/ide.h            |    2 -
 12 files changed, 74 insertions(+), 75 deletions(-)

Index: b/drivers/ide/ide-dma.c
===================================================================
--- a/drivers/ide/ide-dma.c
+++ b/drivers/ide/ide-dma.c
@@ -377,9 +377,10 @@ void ide_dma_host_set(ide_drive_t *drive
 		dma_stat &= ~(1 << (5 + unit));
 
 	if (hwif->host_flags & IDE_HFLAG_MMIO)
-		writeb(dma_stat, (void __iomem *)hwif->dma_status);
+		writeb(dma_stat,
+		       (void __iomem *)(hwif->dma_base + ATA_DMA_STATUS));
 	else
-		outb(dma_stat, hwif->dma_status);
+		outb(dma_stat, hwif->dma_base + ATA_DMA_STATUS);
 }
 
 EXPORT_SYMBOL_GPL(ide_dma_host_set);
@@ -475,18 +476,19 @@ int ide_dma_setup(ide_drive_t *drive)
 
 	/* specify r/w */
 	if (mmio)
-		writeb(reading, (void __iomem *)hwif->dma_command);
+		writeb(reading, (void __iomem *)(hwif->dma_base + ATA_DMA_CMD));
 	else
-		outb(reading, hwif->dma_command);
+		outb(reading, hwif->dma_base + ATA_DMA_CMD);
 
 	/* read DMA status for INTR & ERROR flags */
 	dma_stat = hwif->read_sff_dma_status(hwif);
 
 	/* clear INTR & ERROR flags */
 	if (mmio)
-		writeb(dma_stat | 6, (void __iomem *)hwif->dma_status);
+		writeb(dma_stat | 6,
+		       (void __iomem *)(hwif->dma_base + ATA_DMA_STATUS));
 	else
-		outb(dma_stat | 6, hwif->dma_status);
+		outb(dma_stat | 6, hwif->dma_base + ATA_DMA_STATUS);
 
 	drive->waiting_for_dma = 1;
 	return 0;
@@ -512,12 +514,13 @@ void ide_dma_start(ide_drive_t *drive)
 	 * we do this part before issuing the drive cmd.
 	 */
 	if (hwif->host_flags & IDE_HFLAG_MMIO) {
-		dma_cmd = readb((void __iomem *)hwif->dma_command);
+		dma_cmd = readb((void __iomem *)(hwif->dma_base + ATA_DMA_CMD));
 		/* start DMA */
-		writeb(dma_cmd | 1, (void __iomem *)hwif->dma_command);
+		writeb(dma_cmd | 1,
+		       (void __iomem *)(hwif->dma_base + ATA_DMA_CMD));
 	} else {
-		dma_cmd = inb(hwif->dma_command);
-		outb(dma_cmd | 1, hwif->dma_command);
+		dma_cmd = inb(hwif->dma_base + ATA_DMA_CMD);
+		outb(dma_cmd | 1, hwif->dma_base + ATA_DMA_CMD);
 	}
 
 	hwif->dma = 1;
@@ -537,12 +540,13 @@ int __ide_dma_end (ide_drive_t *drive)
 
 	if (mmio) {
 		/* get DMA command mode */
-		dma_cmd = readb((void __iomem *)hwif->dma_command);
+		dma_cmd = readb((void __iomem *)(hwif->dma_base + ATA_DMA_CMD));
 		/* stop DMA */
-		writeb(dma_cmd & ~1, (void __iomem *)hwif->dma_command);
+		writeb(dma_cmd & ~1,
+		       (void __iomem *)(hwif->dma_base + ATA_DMA_CMD));
 	} else {
-		dma_cmd = inb(hwif->dma_command);
-		outb(dma_cmd & ~1, hwif->dma_command);
+		dma_cmd = inb(hwif->dma_base + ATA_DMA_CMD);
+		outb(dma_cmd & ~1, hwif->dma_base + ATA_DMA_CMD);
 	}
 
 	/* get DMA status */
@@ -550,9 +554,10 @@ int __ide_dma_end (ide_drive_t *drive)
 
 	if (mmio)
 		/* clear the INTR & ERROR bits */
-		writeb(dma_stat | 6, (void __iomem *)hwif->dma_status);
+		writeb(dma_stat | 6,
+		       (void __iomem *)(hwif->dma_base + ATA_DMA_STATUS));
 	else
-		outb(dma_stat | 6, hwif->dma_status);
+		outb(dma_stat | 6, hwif->dma_base + ATA_DMA_STATUS);
 
 	/* purge DMA mappings */
 	ide_destroy_dmatable(drive);
@@ -888,11 +893,6 @@ void ide_setup_dma(ide_hwif_t *hwif, uns
 {
 	hwif->dma_base = base;
 
-	if (!hwif->dma_command)
-		hwif->dma_command	= hwif->dma_base + 0;
-	if (!hwif->dma_status)
-		hwif->dma_status	= hwif->dma_base + 2;
-
 	hwif->dma_ops = &sff_dma_ops;
 }
 
Index: b/drivers/ide/ide-iops.c
===================================================================
--- a/drivers/ide/ide-iops.c
+++ b/drivers/ide/ide-iops.c
@@ -106,9 +106,9 @@ void SELECT_MASK(ide_drive_t *drive, int
 static u8 ide_read_sff_dma_status(ide_hwif_t *hwif)
 {
 	if (hwif->host_flags & IDE_HFLAG_MMIO)
-		return readb((void __iomem *)hwif->dma_status);
+		return readb((void __iomem *)(hwif->dma_base + ATA_DMA_STATUS));
 	else
-		return inb(hwif->dma_status);
+		return inb(hwif->dma_base + ATA_DMA_STATUS);
 }
 
 static void ide_tf_load(ide_drive_t *drive, ide_task_t *task)
Index: b/drivers/ide/pci/cmd64x.c
===================================================================
--- a/drivers/ide/pci/cmd64x.c
+++ b/drivers/ide/pci/cmd64x.c
@@ -262,7 +262,7 @@ static int cmd648_dma_test_irq(ide_drive
 	unsigned long base	= hwif->dma_base - (hwif->channel * 8);
 	u8 irq_mask		= hwif->channel ? MRDMODE_INTR_CH1 :
 						  MRDMODE_INTR_CH0;
-	u8 dma_stat		= inb(hwif->dma_status);
+	u8 dma_stat		= inb(hwif->dma_base + ATA_DMA_STATUS);
 	u8 mrdmode		= inb(base + 1);
 
 #ifdef DEBUG
@@ -286,7 +286,7 @@ static int cmd64x_dma_test_irq(ide_drive
 	int irq_reg		= hwif->channel ? ARTTIM23 : CFR;
 	u8  irq_mask		= hwif->channel ? ARTTIM23_INTR_CH1 :
 						  CFR_INTR_CH0;
-	u8  dma_stat		= inb(hwif->dma_status);
+	u8  dma_stat		= inb(hwif->dma_base + ATA_DMA_STATUS);
 	u8  irq_stat		= 0;
 
 	(void) pci_read_config_byte(dev, irq_reg, &irq_stat);
@@ -317,13 +317,13 @@ static int cmd646_1_dma_end(ide_drive_t 
 
 	drive->waiting_for_dma = 0;
 	/* get DMA status */
-	dma_stat = inb(hwif->dma_status);
+	dma_stat = inb(hwif->dma_base + ATA_DMA_STATUS);
 	/* read DMA command state */
-	dma_cmd = inb(hwif->dma_command);
+	dma_cmd = inb(hwif->dma_base + ATA_DMA_CMD);
 	/* stop DMA */
-	outb(dma_cmd & ~1, hwif->dma_command);
+	outb(dma_cmd & ~1, hwif->dma_base + ATA_DMA_CMD);
 	/* clear the INTR & ERROR bits */
-	outb(dma_stat | 6, hwif->dma_status);
+	outb(dma_stat | 6, hwif->dma_base + ATA_DMA_STATUS);
 	/* and free any DMA resources */
 	ide_destroy_dmatable(drive);
 	/* verify good DMA status */
Index: b/drivers/ide/pci/hpt366.c
===================================================================
--- a/drivers/ide/pci/hpt366.c
+++ b/drivers/ide/pci/hpt366.c
@@ -801,9 +801,9 @@ static void hpt370_irq_timeout(ide_drive
 	printk(KERN_DEBUG "%s: %d bytes in FIFO\n", drive->name, bfifo & 0x1ff);
 
 	/* get DMA command mode */
-	dma_cmd = inb(hwif->dma_command);
+	dma_cmd = inb(hwif->dma_base + ATA_DMA_CMD);
 	/* stop DMA */
-	outb(dma_cmd & ~0x1, hwif->dma_command);
+	outb(dma_cmd & ~0x1, hwif->dma_base + ATA_DMA_CMD);
 	hpt370_clear_engine(drive);
 }
 
@@ -818,12 +818,12 @@ static void hpt370_dma_start(ide_drive_t
 static int hpt370_dma_end(ide_drive_t *drive)
 {
 	ide_hwif_t *hwif	= HWIF(drive);
-	u8  dma_stat		= inb(hwif->dma_status);
+	u8  dma_stat		= inb(hwif->dma_base + ATA_DMA_STATUS);
 
 	if (dma_stat & 0x01) {
 		/* wait a little */
 		udelay(20);
-		dma_stat = inb(hwif->dma_status);
+		dma_stat = inb(hwif->dma_base + ATA_DMA_STATUS);
 		if (dma_stat & 0x01)
 			hpt370_irq_timeout(drive);
 	}
@@ -850,7 +850,7 @@ static int hpt374_dma_test_irq(ide_drive
 		return 0;
 	}
 
-	dma_stat = inb(hwif->dma_status);
+	dma_stat = inb(hwif->dma_base + ATA_DMA_STATUS);
 	/* return 1 if INTR asserted */
 	if (dma_stat & 4)
 		return 1;
Index: b/drivers/ide/pci/ns87415.c
===================================================================
--- a/drivers/ide/pci/ns87415.c
+++ b/drivers/ide/pci/ns87415.c
@@ -65,7 +65,7 @@ static u8 superio_ide_inb (unsigned long
 
 static u8 superio_read_sff_dma_status(ide_hwif_t *hwif)
 {
-	return superio_ide_inb(hwif->dma_status);
+	return superio_ide_inb(hwif->dma_base + ATA_DMA_STATUS);
 }
 
 static void superio_tf_read(ide_drive_t *drive, ide_task_t *task)
@@ -208,13 +208,13 @@ static int ns87415_dma_end(ide_drive_t *
 
 	drive->waiting_for_dma = 0;
 	dma_stat = hwif->read_sff_dma_status(hwif);
-	/* get dma command mode */
-	dma_cmd = inb(hwif->dma_command);
+	/* get DMA command mode */
+	dma_cmd = inb(hwif->dma_base + ATA_DMA_CMD);
 	/* stop DMA */
-	outb(dma_cmd & ~1, hwif->dma_command);
+	outb(dma_cmd & ~1, hwif->dma_base + ATA_DMA_CMD);
 	/* from ERRATA: clear the INTR & ERROR bits */
-	dma_cmd = inb(hwif->dma_command);
-	outb(dma_cmd | 6, hwif->dma_command);
+	dma_cmd = inb(hwif->dma_base + ATA_DMA_CMD);
+	outb(dma_cmd | 6, hwif->dma_base + ATA_DMA_CMD);
 	/* and free any DMA resources */
 	ide_destroy_dmatable(drive);
 	/* verify good DMA status */
@@ -302,7 +302,7 @@ static void __devinit init_hwif_ns87415 
 	if (!hwif->dma_base)
 		return;
 
-	outb(0x60, hwif->dma_status);
+	outb(0x60, hwif->dma_base + ATA_DMA_STATUS);
 }
 
 static const struct ide_port_ops ns87415_port_ops = {
Index: b/drivers/ide/pci/pdc202xx_old.c
===================================================================
--- a/drivers/ide/pci/pdc202xx_old.c
+++ b/drivers/ide/pci/pdc202xx_old.c
@@ -206,7 +206,7 @@ static int pdc202xx_dma_test_irq(ide_dri
 {
 	ide_hwif_t *hwif	= HWIF(drive);
 	unsigned long high_16	= hwif->extra_base - 16;
-	u8 dma_stat		= inb(hwif->dma_status);
+	u8 dma_stat		= inb(hwif->dma_base + ATA_DMA_STATUS);
 	u8 sc1d			= inb(high_16 + 0x001d);
 
 	if (hwif->channel) {
Index: b/drivers/ide/pci/piix.c
===================================================================
--- a/drivers/ide/pci/piix.c
+++ b/drivers/ide/pci/piix.c
@@ -227,9 +227,9 @@ static void piix_dma_clear_irq(ide_drive
 	u8 dma_stat;
 
 	/* clear the INTR & ERROR bits */
-	dma_stat = inb(hwif->dma_status);
+	dma_stat = inb(hwif->dma_base + ATA_DMA_STATUS);
 	/* Should we force the bit as well ? */
-	outb(dma_stat, hwif->dma_status);
+	outb(dma_stat, hwif->dma_base + ATA_DMA_STATUS);
 }
 
 struct ich_laptop {
Index: b/drivers/ide/pci/scc_pata.c
===================================================================
--- a/drivers/ide/pci/scc_pata.c
+++ b/drivers/ide/pci/scc_pata.c
@@ -128,7 +128,7 @@ static u8 scc_ide_inb(unsigned long port
 
 static u8 scc_read_sff_dma_status(ide_hwif_t *hwif)
 {
-	return (u8)in_be32((void *)hwif->dma_status);
+	return (u8)in_be32((void *)(hwif->dma_base + 4));
 }
 
 static void scc_ide_insw(unsigned long port, void *addr, u32 count)
@@ -266,14 +266,14 @@ static void scc_dma_host_set(ide_drive_t
 {
 	ide_hwif_t *hwif = drive->hwif;
 	u8 unit = (drive->select.b.unit & 0x01);
-	u8 dma_stat = scc_ide_inb(hwif->dma_status);
+	u8 dma_stat = scc_ide_inb(hwif->dma_base + 4);
 
 	if (on)
 		dma_stat |= (1 << (5 + unit));
 	else
 		dma_stat &= ~(1 << (5 + unit));
 
-	scc_ide_outb(dma_stat, hwif->dma_status);
+	scc_ide_outb(dma_stat, hwif->dma_base + 4);
 }
 
 /**
@@ -309,13 +309,13 @@ static int scc_dma_setup(ide_drive_t *dr
 	out_be32((void __iomem *)(hwif->dma_base + 8), hwif->dmatable_dma);
 
 	/* specify r/w */
-	out_be32((void __iomem *)hwif->dma_command, reading);
+	out_be32((void __iomem *)hwif->dma_base, reading);
 
-	/* read dma_status for INTR & ERROR flags */
-	dma_stat = in_be32((void __iomem *)hwif->dma_status);
+	/* read DMA status for INTR & ERROR flags */
+	dma_stat = in_be32((void __iomem *)(hwif->dma_base + 4));
 
 	/* clear INTR & ERROR flags */
-	out_be32((void __iomem *)hwif->dma_status, dma_stat|6);
+	out_be32((void __iomem *)(hwif->dma_base + 4), dma_stat | 6);
 	drive->waiting_for_dma = 1;
 	return 0;
 }
@@ -323,10 +323,10 @@ static int scc_dma_setup(ide_drive_t *dr
 static void scc_dma_start(ide_drive_t *drive)
 {
 	ide_hwif_t *hwif = drive->hwif;
-	u8 dma_cmd = scc_ide_inb(hwif->dma_command);
+	u8 dma_cmd = scc_ide_inb(hwif->dma_base);
 
 	/* start DMA */
-	scc_ide_outb(dma_cmd | 1, hwif->dma_command);
+	scc_ide_outb(dma_cmd | 1, hwif->dma_base);
 	hwif->dma = 1;
 	wmb();
 }
@@ -338,13 +338,13 @@ static int __scc_dma_end(ide_drive_t *dr
 
 	drive->waiting_for_dma = 0;
 	/* get DMA command mode */
-	dma_cmd = scc_ide_inb(hwif->dma_command);
+	dma_cmd = scc_ide_inb(hwif->dma_base);
 	/* stop DMA */
-	scc_ide_outb(dma_cmd & ~1, hwif->dma_command);
+	scc_ide_outb(dma_cmd & ~1, hwif->dma_base);
 	/* get DMA status */
-	dma_stat = scc_ide_inb(hwif->dma_status);
+	dma_stat = scc_ide_inb(hwif->dma_base + 4);
 	/* clear the INTR & ERROR bits */
-	scc_ide_outb(dma_stat | 6, hwif->dma_status);
+	scc_ide_outb(dma_stat | 6, hwif->dma_base + 4);
 	/* purge DMA mappings */
 	ide_destroy_dmatable(drive);
 	/* verify good DMA status */
@@ -364,6 +364,7 @@ static int __scc_dma_end(ide_drive_t *dr
 static int scc_dma_end(ide_drive_t *drive)
 {
 	ide_hwif_t *hwif = HWIF(drive);
+	void __iomem *dma_base = (void __iomem *)hwif->dma_base;
 	unsigned long intsts_port = hwif->dma_base + 0x014;
 	u32 reg;
 	int dma_stat, data_loss = 0;
@@ -402,7 +403,7 @@ static int scc_dma_end(ide_drive_t *driv
 			printk(KERN_WARNING "%s: SERROR\n", SCC_PATA_NAME);
 			out_be32((void __iomem *)intsts_port, INTSTS_SERROR|INTSTS_BMSINT);
 
-			out_be32((void __iomem *)hwif->dma_command, in_be32((void __iomem *)hwif->dma_command) & ~QCHCD_IOS_SS);
+			out_be32(dma_base, in_be32(dma_base) & ~QCHCD_IOS_SS);
 			continue;
 		}
 
@@ -417,7 +418,7 @@ static int scc_dma_end(ide_drive_t *driv
 
 			out_be32((void __iomem *)intsts_port, INTSTS_PRERR|INTSTS_BMSINT);
 
-			out_be32((void __iomem *)hwif->dma_command, in_be32((void __iomem *)hwif->dma_command) & ~QCHCD_IOS_SS);
+			out_be32(dma_base, in_be32(dma_base) & ~QCHCD_IOS_SS);
 			continue;
 		}
 
@@ -425,12 +426,12 @@ static int scc_dma_end(ide_drive_t *driv
 			printk(KERN_WARNING "%s: Response Error\n", SCC_PATA_NAME);
 			out_be32((void __iomem *)intsts_port, INTSTS_RERR|INTSTS_BMSINT);
 
-			out_be32((void __iomem *)hwif->dma_command, in_be32((void __iomem *)hwif->dma_command) & ~QCHCD_IOS_SS);
+			out_be32(dma_base, in_be32(dma_base) & ~QCHCD_IOS_SS);
 			continue;
 		}
 
 		if (reg & INTSTS_ICERR) {
-			out_be32((void __iomem *)hwif->dma_command, in_be32((void __iomem *)hwif->dma_command) & ~QCHCD_IOS_SS);
+			out_be32(dma_base, in_be32(dma_base) & ~QCHCD_IOS_SS);
 
 			printk(KERN_WARNING "%s: Illegal Configuration\n", SCC_PATA_NAME);
 			out_be32((void __iomem *)intsts_port, INTSTS_ICERR|INTSTS_BMSINT);
@@ -833,9 +834,6 @@ static void __devinit init_hwif_scc(ide_
 
 	ports->hwif = hwif;
 
-	hwif->dma_command = hwif->dma_base;
-	hwif->dma_status = hwif->dma_base + 0x04;
-
 	/* PTERADD */
 	out_be32((void __iomem *)(hwif->dma_base + 0x018), hwif->dmatable_dma);
 
Index: b/drivers/ide/pci/siimage.c
===================================================================
--- a/drivers/ide/pci/siimage.c
+++ b/drivers/ide/pci/siimage.c
@@ -334,7 +334,7 @@ static int siimage_io_dma_test_irq(ide_d
 	unsigned long addr	= siimage_selreg(hwif, 1);
 
 	/* return 1 if INTR asserted */
-	if (hwif->INB(hwif->dma_status) & 4)
+	if (inb(hwif->dma_base + ATA_DMA_STATUS) & 4)
 		return 1;
 
 	/* return 1 if Device INTR asserted */
@@ -382,7 +382,7 @@ static int siimage_mmio_dma_test_irq(ide
 	}
 
 	/* return 1 if INTR asserted */
-	if (readb((void __iomem *)hwif->dma_status) & 0x04)
+	if (readb((void __iomem *)(hwif->dma_base + ATA_DMA_STATUS)) & 4)
 		return 1;
 
 	/* return 1 if Device INTR asserted */
Index: b/drivers/ide/pci/sl82c105.c
===================================================================
--- a/drivers/ide/pci/sl82c105.c
+++ b/drivers/ide/pci/sl82c105.c
@@ -157,9 +157,9 @@ static void sl82c105_dma_lost_irq(ide_dr
 	 * Was DMA enabled?  If so, disable it - we're resetting the
 	 * host.  The IDE layer will be handling the drive for us.
 	 */
-	dma_cmd = inb(hwif->dma_command);
+	dma_cmd = inb(hwif->dma_base + ATA_DMA_CMD);
 	if (dma_cmd & 1) {
-		outb(dma_cmd & ~1, hwif->dma_command);
+		outb(dma_cmd & ~1, hwif->dma_base + ATA_DMA_CMD);
 		printk("sl82c105: DMA was enabled\n");
 	}
 
Index: b/drivers/ide/pci/tc86c001.c
===================================================================
--- a/drivers/ide/pci/tc86c001.c
+++ b/drivers/ide/pci/tc86c001.c
@@ -63,7 +63,7 @@ static int tc86c001_timer_expiry(ide_dri
 	ide_hwif_t *hwif	= HWIF(drive);
 	ide_expiry_t *expiry	= ide_get_hwifdata(hwif);
 	ide_hwgroup_t *hwgroup	= HWGROUP(drive);
-	u8 dma_stat		= inb(hwif->dma_status);
+	u8 dma_stat		= inb(hwif->dma_base + ATA_DMA_STATUS);
 
 	/* Restore a higher level driver's expiry handler first. */
 	hwgroup->expiry	= expiry;
@@ -71,21 +71,24 @@ static int tc86c001_timer_expiry(ide_dri
 	if ((dma_stat & 5) == 1) {	/* DMA active and no interrupt */
 		unsigned long sc_base	= hwif->config_data;
 		unsigned long twcr_port	= sc_base + (drive->dn ? 0x06 : 0x04);
-		u8 dma_cmd		= inb(hwif->dma_command);
+		u8 dma_cmd		= inb(hwif->dma_base + ATA_DMA_CMD);
 
 		printk(KERN_WARNING "%s: DMA interrupt possibly stuck, "
 		       "attempting recovery...\n", drive->name);
 
 		/* Stop DMA */
-		outb(dma_cmd & ~0x01, hwif->dma_command);
+		outb(dma_cmd & ~0x01, hwif->dma_base + ATA_DMA_CMD);
 
 		/* Setup the dummy DMA transfer */
 		outw(0, sc_base + 0x0a);	/* Sector Count */
 		outw(0, twcr_port);	/* Transfer Word Count 1 or 2 */
 
 		/* Start the dummy DMA transfer */
-		outb(0x00, hwif->dma_command); /* clear R_OR_WCTR for write */
-		outb(0x01, hwif->dma_command); /* set START_STOPBM */
+
+		/* clear R_OR_WCTR for write */
+		outb(0x00, hwif->dma_base + ATA_DMA_CMD);
+		/* set START_STOPBM */
+		outb(0x01, hwif->dma_base + ATA_DMA_CMD);
 
 		/*
 		 * If an interrupt was pending, it should come thru shortly.
Index: b/include/linux/ide.h
===================================================================
--- a/include/linux/ide.h
+++ b/include/linux/ide.h
@@ -505,8 +505,6 @@ typedef struct hwif_s {
 	int		irq;		/* our irq number */
 
 	unsigned long	dma_base;	/* base addr for dma ports */
-	unsigned long	dma_command;	/* dma command register */
-	unsigned long	dma_status;	/* dma status register */
 
 	unsigned long	config_data;	/* for use by chipset-specific code */
 	unsigned long	select_data;	/* for use by chipset-specific code */
