Return-Path: <linux-kernel-owner+w=401wt.eu-S1756158AbYKIQ1e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756158AbYKIQ1e (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Nov 2008 11:27:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756164AbYKIQZG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Nov 2008 11:25:06 -0500
Received: from nf-out-0910.google.com ([64.233.182.188]:40170 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755996AbYKIQZE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Nov 2008 11:25:04 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=FOraU1ri80ocCJ5XYv0EHSDhMeFQrk+k32fIDKmp6lHuKhKeO+rl+1jXmEKcZoS+Sk
         bET34XzpWcVx5bHnjP6L/nJ1bGdJSM63OQd7FfMV3ydZxSrCcusnU+Dcjd77sfD7oWj3
         0GDyyUsjd7EQR64HZqHNFJsF1DpNlVrlwsfWo=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Date: Sun, 09 Nov 2008 17:23:01 +0100
Message-Id: <20081109162301.18999.9793.sendpatchset@localhost.localdomain>
In-Reply-To: <20081109162219.18999.74912.sendpatchset@localhost.localdomain>
References: <20081109162219.18999.74912.sendpatchset@localhost.localdomain>
Subject: [PATCH 07/11] ide: use ATA_DMA_* defines in ide-dma-sff.c
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: [PATCH] ide: use ATA_DMA_* defines in ide-dma-sff.c

In few places open-coded values were still being used.  Fix it.

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/ide-dma-sff.c |   52 ++++++++++++++++++++--------------------------
 1 file changed, 23 insertions(+), 29 deletions(-)

Index: b/drivers/ide/ide-dma-sff.c
===================================================================
--- a/drivers/ide/ide-dma-sff.c
+++ b/drivers/ide/ide-dma-sff.c
@@ -176,15 +176,10 @@ int ide_dma_setup(ide_drive_t *drive)
 {
 	ide_hwif_t *hwif = drive->hwif;
 	struct request *rq = hwif->hwgroup->rq;
-	unsigned int reading;
+	unsigned int reading = rq_data_dir(rq) ? 0 : ATA_DMA_WR;
 	u8 mmio = (hwif->host_flags & IDE_HFLAG_MMIO) ? 1 : 0;
 	u8 dma_stat;
 
-	if (rq_data_dir(rq))
-		reading = 0;
-	else
-		reading = 1 << 3;
-
 	/* fall back to pio! */
 	if (!ide_build_dmatable(drive, rq)) {
 		ide_map_sg(drive, rq);
@@ -209,10 +204,11 @@ int ide_dma_setup(ide_drive_t *drive)
 
 	/* clear INTR & ERROR flags */
 	if (mmio)
-		writeb(dma_stat | 6,
+		writeb(dma_stat | ATA_DMA_ERR | ATA_DMA_INTR,
 		       (void __iomem *)(hwif->dma_base + ATA_DMA_STATUS));
 	else
-		outb(dma_stat | 6, hwif->dma_base + ATA_DMA_STATUS);
+		outb(dma_stat | ATA_DMA_ERR | ATA_DMA_INTR,
+		     hwif->dma_base + ATA_DMA_STATUS);
 
 	drive->waiting_for_dma = 1;
 	return 0;
@@ -246,14 +242,13 @@ static int dma_timer_expiry(ide_drive_t 
 
 	hwif->hwgroup->expiry = NULL;	/* one free ride for now */
 
-	/* 1 dmaing, 2 error, 4 intr */
-	if (dma_stat & 2)	/* ERROR */
+	if (dma_stat & ATA_DMA_ERR)	/* ERROR */
 		return -1;
 
-	if (dma_stat & 1)	/* DMAing */
+	if (dma_stat & ATA_DMA_ACTIVE)	/* DMAing */
 		return WAIT_CMD;
 
-	if (dma_stat & 4)	/* Got an Interrupt */
+	if (dma_stat & ATA_DMA_INTR)	/* Got an Interrupt */
 		return WAIT_CMD;
 
 	return 0;	/* Status is unknown -- reset the bus */
@@ -279,12 +274,11 @@ void ide_dma_start(ide_drive_t *drive)
 	 */
 	if (hwif->host_flags & IDE_HFLAG_MMIO) {
 		dma_cmd = readb((void __iomem *)(hwif->dma_base + ATA_DMA_CMD));
-		/* start DMA */
-		writeb(dma_cmd | 1,
+		writeb(dma_cmd | ATA_DMA_START,
 		       (void __iomem *)(hwif->dma_base + ATA_DMA_CMD));
 	} else {
 		dma_cmd = inb(hwif->dma_base + ATA_DMA_CMD);
-		outb(dma_cmd | 1, hwif->dma_base + ATA_DMA_CMD);
+		outb(dma_cmd | ATA_DMA_START, hwif->dma_base + ATA_DMA_CMD);
 	}
 
 	wmb();
@@ -296,19 +290,18 @@ int ide_dma_end(ide_drive_t *drive)
 {
 	ide_hwif_t *hwif = drive->hwif;
 	u8 mmio = (hwif->host_flags & IDE_HFLAG_MMIO) ? 1 : 0;
-	u8 dma_stat = 0, dma_cmd = 0;
+	u8 dma_stat = 0, dma_cmd = 0, mask;
 
 	drive->waiting_for_dma = 0;
 
+	/* stop DMA */
 	if (mmio) {
-		/* get DMA command mode */
 		dma_cmd = readb((void __iomem *)(hwif->dma_base + ATA_DMA_CMD));
-		/* stop DMA */
-		writeb(dma_cmd & ~1,
+		writeb(dma_cmd & ~ATA_DMA_START,
 		       (void __iomem *)(hwif->dma_base + ATA_DMA_CMD));
 	} else {
 		dma_cmd = inb(hwif->dma_base + ATA_DMA_CMD);
-		outb(dma_cmd & ~1, hwif->dma_base + ATA_DMA_CMD);
+		outb(dma_cmd & ~ATA_DMA_START, hwif->dma_base + ATA_DMA_CMD);
 	}
 
 	/* get DMA status */
@@ -316,16 +309,21 @@ int ide_dma_end(ide_drive_t *drive)
 
 	if (mmio)
 		/* clear the INTR & ERROR bits */
-		writeb(dma_stat | 6,
+		writeb(dma_stat | ATA_DMA_ERR | ATA_DMA_INTR,
 		       (void __iomem *)(hwif->dma_base + ATA_DMA_STATUS));
 	else
-		outb(dma_stat | 6, hwif->dma_base + ATA_DMA_STATUS);
+		outb(dma_stat | ATA_DMA_ERR | ATA_DMA_INTR,
+		     hwif->dma_base + ATA_DMA_STATUS);
 
 	/* purge DMA mappings */
 	ide_destroy_dmatable(drive);
-	/* verify good DMA status */
 	wmb();
-	return (dma_stat & 7) != 4 ? (0x10 | dma_stat) : 0;
+
+	/* verify good DMA status */
+	mask = ATA_DMA_ACTIVE | ATA_DMA_ERR | ATA_DMA_INTR;
+	if ((dma_stat & mask) != ATA_DMA_INTR)
+		return 0x10 | dma_stat;
+	return 0;
 }
 EXPORT_SYMBOL_GPL(ide_dma_end);
 
@@ -335,11 +333,7 @@ int ide_dma_test_irq(ide_drive_t *drive)
 	ide_hwif_t *hwif = drive->hwif;
 	u8 dma_stat = hwif->tp_ops->read_sff_dma_status(hwif);
 
-	/* return 1 if INTR asserted */
-	if ((dma_stat & 4) == 4)
-		return 1;
-
-	return 0;
+	return (dma_stat & ATA_DMA_INTR) ? 1 : 0;
 }
 EXPORT_SYMBOL_GPL(ide_dma_test_irq);
 
