Return-Path: <linux-kernel-owner+w=401wt.eu-S1759746AbZBTRNY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759746AbZBTRNY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Feb 2009 12:13:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758911AbZBTRKo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Feb 2009 12:10:44 -0500
Received: from mail-bw0-f161.google.com ([209.85.218.161]:36537 "EHLO
	mail-bw0-f161.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758905AbZBTRKm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Feb 2009 12:10:42 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=FjrOZkvnrJOH1jQxD+mtfaCf4Uu6zj1sauOBLMBOICjXZeGHpmIRxkif9WL3NfyAnV
         hV1yVW9N5+5Yli55vkh1fgr893tS78GXQcI8bwnuQF9UbTXDoJGRuzXycECVvKR2pul/
         mXkoEBKgdw2rhyNIFNw8LhcIPFyvs/faeQSUQ=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Date: Fri, 20 Feb 2009 18:12:36 +0100
Message-Id: <20090220171236.25429.25264.sendpatchset@localhost.localdomain>
In-Reply-To: <20090220171139.25429.26702.sendpatchset@localhost.localdomain>
References: <20090220171139.25429.26702.sendpatchset@localhost.localdomain>
Subject: [PATCH 08/10] ide: move ide_map_sg() call out from ->dma_setup method
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: [PATCH] ide: move ide_map_sg() call out from ->dma_setup method

Move ide_map_sg() call from ->dma_setup implementations
and ide_destroy_dmatable() one from *_build_dmatable() to
ide_dma_prepare().

There should be no functional changes caused by this patch.

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/au1xxx-ide.c  |    8 ++------
 drivers/ide/ide-dma-sff.c |    2 --
 drivers/ide/ide-dma.c     |    8 ++++++--
 drivers/ide/pmac.c        |    6 +-----
 drivers/ide/scc_pata.c    |    4 +---
 drivers/ide/sgiioc4.c     |    6 +-----
 drivers/ide/trm290.c      |    5 ++---
 drivers/ide/tx4939ide.c   |    6 +-----
 8 files changed, 14 insertions(+), 31 deletions(-)

Index: b/drivers/ide/au1xxx-ide.c
===================================================================
--- a/drivers/ide/au1xxx-ide.c
+++ b/drivers/ide/au1xxx-ide.c
@@ -272,9 +272,7 @@ static int auide_build_dmatable(ide_driv
 	if (count)
 		return 1;
 
- use_pio_instead:
-	ide_destroy_dmatable(drive);
-
+use_pio_instead:
 	return 0; /* revert to PIO for this request */
 }
 
@@ -290,10 +288,8 @@ static void auide_dma_start(ide_drive_t 
 
 static int auide_dma_setup(ide_drive_t *drive, struct ide_cmd *cmd)
 {
-	if (auide_build_dmatable(drive, cmd) == 0) {
-		ide_map_sg(drive, cmd);
+	if (auide_build_dmatable(drive, cmd) == 0)
 		return 1;
-	}
 
 	drive->waiting_for_dma = 1;
 	return 0;
Index: b/drivers/ide/ide-dma-sff.c
===================================================================
--- a/drivers/ide/ide-dma-sff.c
+++ b/drivers/ide/ide-dma-sff.c
@@ -166,8 +166,6 @@ use_pio_instead:
 	printk(KERN_ERR "%s: %s\n", drive->name,
 		count ? "DMA table too small" : "empty DMA table?");
 
-	ide_destroy_dmatable(drive);
-
 	return 0; /* revert to PIO for this request */
 }
 EXPORT_SYMBOL_GPL(ide_build_dmatable);
Index: b/drivers/ide/ide-dma.c
===================================================================
--- a/drivers/ide/ide-dma.c
+++ b/drivers/ide/ide-dma.c
@@ -566,8 +566,12 @@ int ide_dma_prepare(ide_drive_t *drive, 
 
 	if ((drive->dev_flags & IDE_DFLAG_USING_DMA) == 0 ||
 	    (dma_ops->dma_check && dma_ops->dma_check(drive, cmd)) ||
-	    ide_build_sglist(drive, cmd) == 0 ||
-	    dma_ops->dma_setup(drive, cmd))
+	    ide_build_sglist(drive, cmd) == 0)
 		return 1;
+	if (dma_ops->dma_setup(drive, cmd)) {
+		ide_destroy_dmatable(drive);
+		ide_map_sg(drive, cmd);
+		return 1;
+	}
 	return 0;
 }
Index: b/drivers/ide/pmac.c
===================================================================
--- a/drivers/ide/pmac.c
+++ b/drivers/ide/pmac.c
@@ -1493,8 +1493,6 @@ static int pmac_ide_build_dmatable(ide_d
 	printk(KERN_DEBUG "%s: empty DMA table?\n", drive->name);
 
 use_pio_instead:
-	ide_destroy_dmatable(drive);
-
 	return 0; /* revert to PIO for this request */
 }
 
@@ -1510,10 +1508,8 @@ static int pmac_ide_dma_setup(ide_drive_
 	u8 unit = drive->dn & 1, ata4 = (pmif->kind == controller_kl_ata4);
 	u8 write = !!(cmd->tf_flags & IDE_TFLAG_WRITE);
 
-	if (pmac_ide_build_dmatable(drive, cmd) == 0) {
-		ide_map_sg(drive, cmd);
+	if (pmac_ide_build_dmatable(drive, cmd) == 0)
 		return 1;
-	}
 
 	/* Apple adds 60ns to wrDataSetup on reads */
 	if (ata4 && (pmif->timings[unit] & TR_66_UDMA_EN)) {
Index: b/drivers/ide/scc_pata.c
===================================================================
--- a/drivers/ide/scc_pata.c
+++ b/drivers/ide/scc_pata.c
@@ -321,10 +321,8 @@ static int scc_dma_setup(ide_drive_t *dr
 	u8 dma_stat;
 
 	/* fall back to pio! */
-	if (ide_build_dmatable(drive, cmd) == 0) {
-		ide_map_sg(drive, cmd);
+	if (ide_build_dmatable(drive, cmd) == 0)
 		return 1;
-	}
 
 	/* PRD table */
 	out_be32((void __iomem *)(hwif->dma_base + 8), hwif->dmatable_dma);
Index: b/drivers/ide/sgiioc4.c
===================================================================
--- a/drivers/ide/sgiioc4.c
+++ b/drivers/ide/sgiioc4.c
@@ -478,8 +478,6 @@ static int sgiioc4_build_dmatable(ide_dr
 	}
 
 use_pio_instead:
-	ide_destroy_dmatable(drive);
-
 	return 0;		/* revert to PIO for this request */
 }
 
@@ -488,11 +486,9 @@ static int sgiioc4_dma_setup(ide_drive_t
 	int ddir;
 	u8 write = !!(cmd->tf_flags & IDE_TFLAG_WRITE);
 
-	if (sgiioc4_build_dmatable(drive, cmd) == 0) {
+	if (sgiioc4_build_dmatable(drive, cmd) == 0)
 		/* try PIO instead of DMA */
-		ide_map_sg(drive, cmd);
 		return 1;
-	}
 
 	if (write)
 		/* Writes TO the IOC4 FROM Main Memory */
Index: b/drivers/ide/trm290.c
===================================================================
--- a/drivers/ide/trm290.c
+++ b/drivers/ide/trm290.c
@@ -193,11 +193,10 @@ static int trm290_dma_setup(ide_drive_t 
 	unsigned int count, rw = (cmd->tf_flags & IDE_TFLAG_WRITE) ? 1 : 2;
 
 	count = ide_build_dmatable(drive, cmd);
-	if (count == 0) {
-		ide_map_sg(drive, cmd);
+	if (count == 0)
 		/* try PIO instead of DMA */
 		return 1;
-	}
+
 	outl(hwif->dmatable_dma | rw, hwif->dma_base);
 	drive->waiting_for_dma = 1;
 	/* start DMA */
Index: b/drivers/ide/tx4939ide.c
===================================================================
--- a/drivers/ide/tx4939ide.c
+++ b/drivers/ide/tx4939ide.c
@@ -279,8 +279,6 @@ use_pio_instead:
 	printk(KERN_ERR "%s: %s\n", drive->name,
 		count ? "DMA table too small" : "empty DMA table?");
 
-	ide_destroy_dmatable(drive);
-
 	return 0; /* revert to PIO for this request */
 }
 #else
@@ -294,10 +292,8 @@ static int tx4939ide_dma_setup(ide_drive
 	u8 rw = (cmd->tf_flags & IDE_TFLAG_WRITE) ? 0 : ATA_DMA_WR;
 
 	/* fall back to PIO! */
-	if (tx4939ide_build_dmatable(drive, cmd) == 0) {
-		ide_map_sg(drive, cmd);
+	if (tx4939ide_build_dmatable(drive, cmd) == 0)
 		return 1;
-	}
 
 	/* PRD table */
 	tx4939ide_writel(hwif->dmatable_dma, base, TX4939IDE_PRD_Ptr);
