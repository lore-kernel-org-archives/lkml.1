Return-Path: <linux-kernel-owner+w=401wt.eu-S1761370AbYFTVcA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761370AbYFTVcA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2008 17:32:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760188AbYFTVbn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Jun 2008 17:31:43 -0400
Received: from fk-out-0910.google.com ([209.85.128.190]:5898 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759566AbYFTVbl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2008 17:31:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=io5FTArv3sByYCrOxmjivJMU+szk9DCVeQrGu1B3haIf1zyp/1mIKk2iOP2B58jq6c
         SJoaRpQZLm/ayURyRxmREKBN1MRzELnFLcb+bJzC1Hepskkn19H2Kl8pFnoXcD0Ncl2v
         HSoMEnXNw55XGO45Kol2Yu7Yx80C+kIRDyTgk=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Date: Fri, 20 Jun 2008 23:33:30 +0200
Message-Id: <20080620213330.13202.11017.sendpatchset@localhost.localdomain>
In-Reply-To: <20080620213323.13202.71450.sendpatchset@localhost.localdomain>
References: <20080620213323.13202.71450.sendpatchset@localhost.localdomain>
Subject: [PATCH 02/18] ide: use I/O ops directly in ide-dma.c
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use I/O ops directly in ide_dma_host_set(), ide_dma_setup(),
ide_dma_start() and __ide_dma_end().

There should be no functional changes caused by this patch.

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/ide-dma.c |   59 ++++++++++++++++++++++++++++++++++++++------------
 1 file changed, 45 insertions(+), 14 deletions(-)

Index: b/drivers/ide/ide-dma.c
===================================================================
--- a/drivers/ide/ide-dma.c
+++ b/drivers/ide/ide-dma.c
@@ -376,7 +376,10 @@ void ide_dma_host_set(ide_drive_t *drive
 	else
 		dma_stat &= ~(1 << (5 + unit));
 
-	hwif->OUTB(dma_stat, hwif->dma_status);
+	if (hwif->host_flags & IDE_HFLAG_MMIO)
+		writeb(dma_stat, (void __iomem *)hwif->dma_status);
+	else
+		outb(dma_stat, hwif->dma_status);
 }
 
 EXPORT_SYMBOL_GPL(ide_dma_host_set);
@@ -449,6 +452,7 @@ int ide_dma_setup(ide_drive_t *drive)
 	ide_hwif_t *hwif = drive->hwif;
 	struct request *rq = HWGROUP(drive)->rq;
 	unsigned int reading;
+	u8 mmio = (hwif->host_flags & IDE_HFLAG_MMIO) ? 1 : 0;
 	u8 dma_stat;
 
 	if (rq_data_dir(rq))
@@ -470,13 +474,20 @@ int ide_dma_setup(ide_drive_t *drive)
 		outl(hwif->dmatable_dma, hwif->dma_base + ATA_DMA_TABLE_OFS);
 
 	/* specify r/w */
-	hwif->OUTB(reading, hwif->dma_command);
+	if (mmio)
+		writeb(reading, (void __iomem *)hwif->dma_command);
+	else
+		outb(reading, hwif->dma_command);
 
 	/* read DMA status for INTR & ERROR flags */
 	dma_stat = hwif->read_sff_dma_status(hwif);
 
 	/* clear INTR & ERROR flags */
-	hwif->OUTB(dma_stat|6, hwif->dma_status);
+	if (mmio)
+		writeb(dma_stat | 6, (void __iomem *)hwif->dma_status);
+	else
+		outb(dma_stat | 6, hwif->dma_status);
+
 	drive->waiting_for_dma = 1;
 	return 0;
 }
@@ -492,16 +503,23 @@ EXPORT_SYMBOL_GPL(ide_dma_exec_cmd);
 
 void ide_dma_start(ide_drive_t *drive)
 {
-	ide_hwif_t *hwif	= HWIF(drive);
-	u8 dma_cmd		= hwif->INB(hwif->dma_command);
+	ide_hwif_t *hwif = drive->hwif;
+	u8 dma_cmd;
 
 	/* Note that this is done *after* the cmd has
 	 * been issued to the drive, as per the BM-IDE spec.
 	 * The Promise Ultra33 doesn't work correctly when
 	 * we do this part before issuing the drive cmd.
 	 */
-	/* start DMA */
-	hwif->OUTB(dma_cmd|1, hwif->dma_command);
+	if (hwif->host_flags & IDE_HFLAG_MMIO) {
+		dma_cmd = readb((void __iomem *)hwif->dma_command);
+		/* start DMA */
+		writeb(dma_cmd | 1, (void __iomem *)hwif->dma_command);
+	} else {
+		dma_cmd = inb(hwif->dma_command);
+		outb(dma_cmd | 1, hwif->dma_command);
+	}
+
 	hwif->dma = 1;
 	wmb();
 }
@@ -511,18 +529,31 @@ EXPORT_SYMBOL_GPL(ide_dma_start);
 /* returns 1 on error, 0 otherwise */
 int __ide_dma_end (ide_drive_t *drive)
 {
-	ide_hwif_t *hwif	= HWIF(drive);
+	ide_hwif_t *hwif = drive->hwif;
+	u8 mmio = (hwif->host_flags & IDE_HFLAG_MMIO) ? 1 : 0;
 	u8 dma_stat = 0, dma_cmd = 0;
 
 	drive->waiting_for_dma = 0;
-	/* get dma_command mode */
-	dma_cmd = hwif->INB(hwif->dma_command);
-	/* stop DMA */
-	hwif->OUTB(dma_cmd&~1, hwif->dma_command);
+
+	if (mmio) {
+		/* get DMA command mode */
+		dma_cmd = readb((void __iomem *)hwif->dma_command);
+		/* stop DMA */
+		writeb(dma_cmd & ~1, (void __iomem *)hwif->dma_command);
+	} else {
+		dma_cmd = inb(hwif->dma_command);
+		outb(dma_cmd & ~1, hwif->dma_command);
+	}
+
 	/* get DMA status */
 	dma_stat = hwif->read_sff_dma_status(hwif);
-	/* clear the INTR & ERROR bits */
-	hwif->OUTB(dma_stat|6, hwif->dma_status);
+
+	if (mmio)
+		/* clear the INTR & ERROR bits */
+		writeb(dma_stat | 6, (void __iomem *)hwif->dma_status);
+	else
+		outb(dma_stat | 6, hwif->dma_status);
+
 	/* purge DMA mappings */
 	ide_destroy_dmatable(drive);
 	/* verify good DMA status */
