Return-Path: <linux-kernel-owner+w=401wt.eu-S1753153AbYIBSeK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753153AbYIBSeK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Sep 2008 14:34:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751439AbYIBSdz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Sep 2008 14:33:55 -0400
Received: from ug-out-1314.google.com ([66.249.92.173]:4811 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751387AbYIBSdy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Sep 2008 14:33:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:mime-version:content-type
         :content-transfer-encoding:content-disposition:message-id;
        b=nnXM+mGMJ8/G1SFeW+sArFrZdIJprDlhcbbLOFcaCKc/uV4FkRHpc4QZDQAuA9G+Yt
         g1jjb0jQfptDovXfia6TDMMaxQKDxJr4Lp6c3jKSmBpx2w9O4c6IJakb3cLWv/pW9r4/
         kQTxSlitki97w+khhUjjXZDCLrs4uJhUMAKFA=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Subject: [PATCH 1/2] pmac: remove superfluous pmif == NULL checks
Date: Tue, 2 Sep 2008 20:30:30 +0200
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200809022030.30297.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/ppc/pmac.c |   39 +++++----------------------------------
 1 file changed, 5 insertions(+), 34 deletions(-)

Index: b/drivers/ide/ppc/pmac.c
===================================================================
--- a/drivers/ide/ppc/pmac.c
+++ b/drivers/ide/ppc/pmac.c
@@ -430,9 +430,6 @@ pmac_ide_selectproc(ide_drive_t *drive)
 	pmac_ide_hwif_t *pmif =
 		(pmac_ide_hwif_t *)dev_get_drvdata(hwif->gendev.parent);
 
-	if (pmif == NULL)
-		return;
-
 	if (drive->dn & 1)
 		writel(pmif->timings[1], PMAC_IDE_REG(IDE_TIMING_CONFIG));
 	else
@@ -452,9 +449,6 @@ pmac_ide_kauai_selectproc(ide_drive_t *d
 	pmac_ide_hwif_t *pmif =
 		(pmac_ide_hwif_t *)dev_get_drvdata(hwif->gendev.parent);
 
-	if (pmif == NULL)
-		return;
-
 	if (drive->dn & 1) {
 		writel(pmif->timings[1], PMAC_IDE_REG(IDE_KAUAI_PIO_CONFIG));
 		writel(pmif->timings[3], PMAC_IDE_REG(IDE_KAUAI_ULTRA_CONFIG));
@@ -475,9 +469,6 @@ pmac_ide_do_update_timings(ide_drive_t *
 	pmac_ide_hwif_t *pmif =
 		(pmac_ide_hwif_t *)dev_get_drvdata(hwif->gendev.parent);
 
-	if (pmif == NULL)
-		return;
-
 	if (pmif->kind == controller_sh_ata6 ||
 	    pmif->kind == controller_un_ata6 ||
 	    pmif->kind == controller_k2_ata6)
@@ -524,9 +515,6 @@ pmac_ide_set_pio_mode(ide_drive_t *drive
 	unsigned accessTime, recTime;
 	unsigned int cycle_time;
 
-	if (pmif == NULL)
-		return;
-		
 	/* which drive is it ? */
 	timings = &pmif->timings[drive->dn & 1];
 	t = *timings;
@@ -1558,11 +1546,7 @@ pmac_ide_dma_setup(ide_drive_t *drive)
 	pmac_ide_hwif_t *pmif =
 		(pmac_ide_hwif_t *)dev_get_drvdata(hwif->gendev.parent);
 	struct request *rq = HWGROUP(drive)->rq;
-	u8 unit = drive->dn & 1, ata4;
-
-	if (pmif == NULL)
-		return 1;
-	ata4 = (pmif->kind == controller_kl_ata4);	
+	u8 unit = drive->dn & 1, ata4 = (pmif->kind == controller_kl_ata4);
 
 	if (!pmac_ide_build_dmatable(drive, rq)) {
 		ide_map_sg(drive, rq);
@@ -1616,12 +1600,8 @@ pmac_ide_dma_end (ide_drive_t *drive)
 	ide_hwif_t *hwif = drive->hwif;
 	pmac_ide_hwif_t *pmif =
 		(pmac_ide_hwif_t *)dev_get_drvdata(hwif->gendev.parent);
-	volatile struct dbdma_regs __iomem *dma;
+	volatile struct dbdma_regs __iomem *dma = pmif->dma_regs;
 	u32 dstat;
-	
-	if (pmif == NULL)
-		return 0;
-	dma = pmif->dma_regs;
 
 	drive->waiting_for_dma = 0;
 	dstat = readl(&dma->status);
@@ -1646,13 +1626,9 @@ pmac_ide_dma_test_irq (ide_drive_t *driv
 	ide_hwif_t *hwif = drive->hwif;
 	pmac_ide_hwif_t *pmif =
 		(pmac_ide_hwif_t *)dev_get_drvdata(hwif->gendev.parent);
-	volatile struct dbdma_regs __iomem *dma;
+	volatile struct dbdma_regs __iomem *dma = pmif->dma_regs;
 	unsigned long status, timeout;
 
-	if (pmif == NULL)
-		return 0;
-	dma = pmif->dma_regs;
-
 	/* We have to things to deal with here:
 	 * 
 	 * - The dbdma won't stop if the command was started
@@ -1705,14 +1681,9 @@ pmac_ide_dma_lost_irq (ide_drive_t *driv
 	ide_hwif_t *hwif = drive->hwif;
 	pmac_ide_hwif_t *pmif =
 		(pmac_ide_hwif_t *)dev_get_drvdata(hwif->gendev.parent);
-	volatile struct dbdma_regs __iomem *dma;
-	unsigned long status;
-
-	if (pmif == NULL)
-		return;
-	dma = pmif->dma_regs;
+	volatile struct dbdma_regs __iomem *dma = pmif->dma_regs;
+	unsigned long status = readl(&dma->status);
 
-	status = readl(&dma->status);
 	printk(KERN_ERR "ide-pmac lost interrupt, dma status: %lx\n", status);
 }
 
