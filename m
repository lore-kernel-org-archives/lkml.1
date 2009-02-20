Return-Path: <linux-kernel-owner+w=401wt.eu-S1759893AbZBTRNj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759893AbZBTRNj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Feb 2009 12:13:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759075AbZBTRK4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Feb 2009 12:10:56 -0500
Received: from nf-out-0910.google.com ([64.233.182.187]:50686 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758990AbZBTRKx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Feb 2009 12:10:53 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=tKno3+xsYUKyRAfssbUR3maqhwZ1JdRZvksSazmYhgNTm6bKabHF7XjMVGKR+IZP+3
         MNHI/wnSxvWfVQCk1MMeXXjgvHSKmQU7kJ8oADr647RUgHnnLH5s7PeeBSgJnpsm3HJ1
         UQFBFEjD80Haxjz05+F+Kmeq2QV/QQI0aqc+k=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Date: Fri, 20 Feb 2009 18:12:43 +0100
Message-Id: <20090220171243.25429.21171.sendpatchset@localhost.localdomain>
In-Reply-To: <20090220171139.25429.26702.sendpatchset@localhost.localdomain>
References: <20090220171139.25429.26702.sendpatchset@localhost.localdomain>
Subject: [PATCH 09/10] ide: set/clear drive->waiting_for_dma flag in the core code
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: [PATCH] ide: set/clear drive->waiting_for_dma flag in the core code

Set/clear drive->waiting_for_dma flag in the core code
instead of in ->dma_setup and ->dma_end methods.

There should be no functional changes caused by this patch.

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/au1xxx-ide.c  |    6 ------
 drivers/ide/cmd64x.c      |    1 -
 drivers/ide/icside.c      |    4 ----
 drivers/ide/ide-atapi.c   |    4 +++-
 drivers/ide/ide-cd.c      |    1 +
 drivers/ide/ide-dma-sff.c |    3 ---
 drivers/ide/ide-dma.c     |    4 ++++
 drivers/ide/ns87415.c     |    1 -
 drivers/ide/pmac.c        |    3 ---
 drivers/ide/sc1200.c      |    2 --
 drivers/ide/scc_pata.c    |    3 +--
 drivers/ide/sgiioc4.c     |    3 ---
 drivers/ide/trm290.c      |    8 ++------
 drivers/ide/tx4939ide.c   |    4 ----
 14 files changed, 11 insertions(+), 36 deletions(-)

Index: b/drivers/ide/au1xxx-ide.c
===================================================================
--- a/drivers/ide/au1xxx-ide.c
+++ b/drivers/ide/au1xxx-ide.c
@@ -291,7 +291,6 @@ static int auide_dma_setup(ide_drive_t *
 	if (auide_build_dmatable(drive, cmd) == 0)
 		return 1;
 
-	drive->waiting_for_dma = 1;
 	return 0;
 }
 
@@ -316,16 +315,11 @@ static void auide_dma_host_set(ide_drive
 
 static void auide_ddma_tx_callback(int irq, void *param)
 {
-	_auide_hwif *ahwif = (_auide_hwif*)param;
-	ahwif->drive->waiting_for_dma = 0;
 }
 
 static void auide_ddma_rx_callback(int irq, void *param)
 {
-	_auide_hwif *ahwif = (_auide_hwif*)param;
-	ahwif->drive->waiting_for_dma = 0;
 }
-
 #endif /* end CONFIG_BLK_DEV_IDE_AU1XXX_MDMA2_DBDMA */
 
 static void auide_init_dbdma_dev(dbdev_tab_t *dev, u32 dev_id, u32 tsize, u32 devwidth, u32 flags)
Index: b/drivers/ide/cmd64x.c
===================================================================
--- a/drivers/ide/cmd64x.c
+++ b/drivers/ide/cmd64x.c
@@ -318,7 +318,6 @@ static int cmd646_1_dma_end(ide_drive_t 
 	ide_hwif_t *hwif = drive->hwif;
 	u8 dma_stat = 0, dma_cmd = 0;
 
-	drive->waiting_for_dma = 0;
 	/* get DMA status */
 	dma_stat = inb(hwif->dma_base + ATA_DMA_STATUS);
 	/* read DMA command state */
Index: b/drivers/ide/icside.c
===================================================================
--- a/drivers/ide/icside.c
+++ b/drivers/ide/icside.c
@@ -287,8 +287,6 @@ static int icside_dma_end(ide_drive_t *d
 	ide_hwif_t *hwif = drive->hwif;
 	struct expansion_card *ec = ECARD_DEV(hwif->dev);
 
-	drive->waiting_for_dma = 0;
-
 	disable_dma(ec->dma);
 
 	return get_dma_residue(ec->dma) != 0;
@@ -343,8 +341,6 @@ static int icside_dma_setup(ide_drive_t 
 	set_dma_sg(ec->dma, hwif->sg_table, cmd->sg_nents);
 	set_dma_mode(ec->dma, dma_mode);
 
-	drive->waiting_for_dma = 1;
-
 	return 0;
 }
 
Index: b/drivers/ide/ide-atapi.c
===================================================================
--- a/drivers/ide/ide-atapi.c
+++ b/drivers/ide/ide-atapi.c
@@ -322,8 +322,10 @@ static ide_startstop_t ide_pc_intr(ide_d
 	stat = tp_ops->read_status(hwif);
 
 	if (pc->flags & PC_FLAG_DMA_IN_PROGRESS) {
-		int rc = hwif->dma_ops->dma_end(drive);
+		int rc;
 
+		drive->waiting_for_dma = 0;
+		rc = hwif->dma_ops->dma_end(drive);
 		ide_destroy_dmatable(drive);
 
 		if (rc || (drive->media == ide_tape && (stat & ATA_ERR))) {
Index: b/drivers/ide/ide-cd.c
===================================================================
--- a/drivers/ide/ide-cd.c
+++ b/drivers/ide/ide-cd.c
@@ -638,6 +638,7 @@ static ide_startstop_t cdrom_newpc_intr(
 	dma = drive->dma;
 	if (dma) {
 		drive->dma = 0;
+		drive->waiting_for_dma = 0;
 		dma_error = hwif->dma_ops->dma_end(drive);
 		ide_destroy_dmatable(drive);
 		if (dma_error) {
Index: b/drivers/ide/ide-dma-sff.c
===================================================================
--- a/drivers/ide/ide-dma-sff.c
+++ b/drivers/ide/ide-dma-sff.c
@@ -216,7 +216,6 @@ int ide_dma_setup(ide_drive_t *drive, st
 	/* clear INTR & ERROR flags */
 	ide_dma_sff_write_status(hwif, dma_stat | ATA_DMA_ERR | ATA_DMA_INTR);
 
-	drive->waiting_for_dma = 1;
 	return 0;
 }
 EXPORT_SYMBOL_GPL(ide_dma_setup);
@@ -290,8 +289,6 @@ int ide_dma_end(ide_drive_t *drive)
 	ide_hwif_t *hwif = drive->hwif;
 	u8 dma_stat = 0, dma_cmd = 0, mask;
 
-	drive->waiting_for_dma = 0;
-
 	/* stop DMA */
 	if (hwif->host_flags & IDE_HFLAG_MMIO) {
 		dma_cmd = readb((void __iomem *)(hwif->dma_base + ATA_DMA_CMD));
Index: b/drivers/ide/ide-dma.c
===================================================================
--- a/drivers/ide/ide-dma.c
+++ b/drivers/ide/ide-dma.c
@@ -91,6 +91,7 @@ ide_startstop_t ide_dma_intr(ide_drive_t
 	ide_hwif_t *hwif = drive->hwif;
 	u8 stat = 0, dma_stat = 0;
 
+	drive->waiting_for_dma = 0;
 	dma_stat = hwif->dma_ops->dma_end(drive);
 	ide_destroy_dmatable(drive);
 	stat = hwif->tp_ops->read_status(hwif);
@@ -475,6 +476,7 @@ ide_startstop_t ide_dma_timeout_retry(id
 
 	if (error < 0) {
 		printk(KERN_WARNING "%s: DMA timeout error\n", drive->name);
+		drive->waiting_for_dma = 0;
 		(void)dma_ops->dma_end(drive);
 		ide_destroy_dmatable(drive);
 		ret = ide_error(drive, "dma timeout error",
@@ -487,6 +489,7 @@ ide_startstop_t ide_dma_timeout_retry(id
 		if (dma_ops->dma_test_irq(drive) == 0) {
 			ide_dump_status(drive, "DMA timeout",
 					hwif->tp_ops->read_status(hwif));
+			drive->waiting_for_dma = 0;
 			(void)dma_ops->dma_end(drive);
 			ide_destroy_dmatable(drive);
 		}
@@ -573,5 +576,6 @@ int ide_dma_prepare(ide_drive_t *drive, 
 		ide_map_sg(drive, cmd);
 		return 1;
 	}
+	drive->waiting_for_dma = 1;
 	return 0;
 }
Index: b/drivers/ide/ns87415.c
===================================================================
--- a/drivers/ide/ns87415.c
+++ b/drivers/ide/ns87415.c
@@ -207,7 +207,6 @@ static int ns87415_dma_end(ide_drive_t *
 	ide_hwif_t *hwif = drive->hwif;
 	u8 dma_stat = 0, dma_cmd = 0;
 
-	drive->waiting_for_dma = 0;
 	dma_stat = hwif->dma_ops->dma_sff_read_status(hwif);
 	/* get DMA command mode */
 	dma_cmd = inb(hwif->dma_base + ATA_DMA_CMD);
Index: b/drivers/ide/pmac.c
===================================================================
--- a/drivers/ide/pmac.c
+++ b/drivers/ide/pmac.c
@@ -1518,8 +1518,6 @@ static int pmac_ide_dma_setup(ide_drive_
 		(void)readl(PMAC_IDE_REG(IDE_TIMING_CONFIG));
 	}
 
-	drive->waiting_for_dma = 1;
-
 	return 0;
 }
 
@@ -1554,7 +1552,6 @@ pmac_ide_dma_end (ide_drive_t *drive)
 	volatile struct dbdma_regs __iomem *dma = pmif->dma_regs;
 	u32 dstat;
 
-	drive->waiting_for_dma = 0;
 	dstat = readl(&dma->status);
 	writel(((RUN|WAKE|DEAD) << 16), &dma->control);
 
Index: b/drivers/ide/sc1200.c
===================================================================
--- a/drivers/ide/sc1200.c
+++ b/drivers/ide/sc1200.c
@@ -183,8 +183,6 @@ static int sc1200_dma_end(ide_drive_t *d
 	outb(dma_stat|0x1b, dma_base+2);	/* clear the INTR & ERROR bits */
 	outb(inb(dma_base)&~1, dma_base);	/* !! DO THIS HERE !! stop DMA */
 
-	drive->waiting_for_dma = 0;
-
 	return (dma_stat & 7) != 4;		/* verify good DMA status */
 }
 
Index: b/drivers/ide/scc_pata.c
===================================================================
--- a/drivers/ide/scc_pata.c
+++ b/drivers/ide/scc_pata.c
@@ -335,7 +335,7 @@ static int scc_dma_setup(ide_drive_t *dr
 
 	/* clear INTR & ERROR flags */
 	out_be32((void __iomem *)(hwif->dma_base + 4), dma_stat | 6);
-	drive->waiting_for_dma = 1;
+
 	return 0;
 }
 
@@ -354,7 +354,6 @@ static int __scc_dma_end(ide_drive_t *dr
 	ide_hwif_t *hwif = drive->hwif;
 	u8 dma_stat, dma_cmd;
 
-	drive->waiting_for_dma = 0;
 	/* get DMA command mode */
 	dma_cmd = scc_ide_inb(hwif->dma_base);
 	/* stop DMA */
Index: b/drivers/ide/sgiioc4.c
===================================================================
--- a/drivers/ide/sgiioc4.c
+++ b/drivers/ide/sgiioc4.c
@@ -258,8 +258,6 @@ static int sgiioc4_dma_end(ide_drive_t *
 		}
 	}
 
-	drive->waiting_for_dma = 0;
-
 	return dma_stat;
 }
 
@@ -412,7 +410,6 @@ sgiioc4_configure_for_dma(int dma_direct
 	writel(ending_dma_addr, (void __iomem *)(dma_base + IOC4_DMA_END_ADDR * 4));
 
 	writel(dma_direction, (void __iomem *)ioc4_dma_addr);
-	drive->waiting_for_dma = 1;
 }
 
 /* IOC4 Scatter Gather list Format 					 */
Index: b/drivers/ide/trm290.c
===================================================================
--- a/drivers/ide/trm290.c
+++ b/drivers/ide/trm290.c
@@ -198,9 +198,9 @@ static int trm290_dma_setup(ide_drive_t 
 		return 1;
 
 	outl(hwif->dmatable_dma | rw, hwif->dma_base);
-	drive->waiting_for_dma = 1;
 	/* start DMA */
 	outw(count * 2 - 1, hwif->dma_base + 2);
+
 	return 0;
 }
 
@@ -211,11 +211,7 @@ static void trm290_dma_start(ide_drive_t
 
 static int trm290_dma_end(ide_drive_t *drive)
 {
-	u16 status;
-
-	drive->waiting_for_dma = 0;
-
-	status = inw(drive->hwif->dma_base + 2);
+	u16 status = inw(drive->hwif->dma_base + 2);
 
 	trm290_prepare_drive(drive, 0);
 
Index: b/drivers/ide/tx4939ide.c
===================================================================
--- a/drivers/ide/tx4939ide.c
+++ b/drivers/ide/tx4939ide.c
@@ -304,8 +304,6 @@ static int tx4939ide_dma_setup(ide_drive
 	/* clear INTR & ERROR flags */
 	tx4939ide_clear_dma_status(base);
 
-	drive->waiting_for_dma = 1;
-
 	tx4939ide_writew(SECTOR_SIZE / 2, base, drive->dn ?
 			 TX4939IDE_Xfer_Cnt_2 : TX4939IDE_Xfer_Cnt_1);
 
@@ -321,8 +319,6 @@ static int tx4939ide_dma_end(ide_drive_t
 	void __iomem *base = TX4939IDE_BASE(hwif);
 	u16 ctl = tx4939ide_readw(base, TX4939IDE_Int_Ctl);
 
-	drive->waiting_for_dma = 0;
-
 	/* get DMA command mode */
 	dma_cmd = tx4939ide_readb(base, TX4939IDE_DMA_Cmd);
 	/* stop DMA */
