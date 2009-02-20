Return-Path: <linux-kernel-owner+w=401wt.eu-S1759461AbZBTRL4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759461AbZBTRL4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Feb 2009 12:11:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754112AbZBTRKW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Feb 2009 12:10:22 -0500
Received: from mail-fx0-f167.google.com ([209.85.220.167]:65258 "EHLO
	mail-fx0-f167.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755811AbZBTRKU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Feb 2009 12:10:20 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=uo+MpzHXpb0W2IeGHD6s+xSxPIrX6qk/0subutG2FysHXooGDvv+SAHiBPPsi6KQNc
         Lyf2/c+KTthjZe7OVvbt+c9YmvMtpLcqV90foa/PFFB+K74N4DSA5Q6fVEm2MFHBOxjm
         OogvyFqebLSguy7queiiM5rNwUqU6518D9npQ=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Date: Fri, 20 Feb 2009 18:12:15 +0100
Message-Id: <20090220171215.25429.46593.sendpatchset@localhost.localdomain>
In-Reply-To: <20090220171139.25429.26702.sendpatchset@localhost.localdomain>
References: <20090220171139.25429.26702.sendpatchset@localhost.localdomain>
Subject: [PATCH 05/10] ns87415: use custom ->dma_{start,end} to handle ns87415_prepare_drive()
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: [PATCH] ns87415: use custom ->dma_{start,end} to handle ns87415_prepare_drive()

Use custom ->dma_{start,end} methods to handle ns87415_prepare_drive()
there instead of in ->dma_setup method.

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/ns87415.c |   24 +++++++++++-------------
 1 file changed, 11 insertions(+), 13 deletions(-)

Index: b/drivers/ide/ns87415.c
===================================================================
--- a/drivers/ide/ns87415.c
+++ b/drivers/ide/ns87415.c
@@ -196,6 +196,12 @@ static void ns87415_selectproc (ide_driv
 			      !!(drive->dev_flags & IDE_DFLAG_USING_DMA));
 }
 
+static void ns87415_dma_start(ide_drive_t *drive)
+{
+	ns87415_prepare_drive(drive, 1);
+	ide_dma_start(drive);
+}
+
 static int ns87415_dma_end(ide_drive_t *drive)
 {
 	ide_hwif_t *hwif = drive->hwif;
@@ -210,19 +216,11 @@ static int ns87415_dma_end(ide_drive_t *
 	/* from ERRATA: clear the INTR & ERROR bits */
 	dma_cmd = inb(hwif->dma_base + ATA_DMA_CMD);
 	outb(dma_cmd | 6, hwif->dma_base + ATA_DMA_CMD);
-	/* verify good DMA status */
-	return (dma_stat & 7) != 4;
-}
 
-static int ns87415_dma_setup(ide_drive_t *drive, struct ide_cmd *cmd)
-{
-	/* select DMA xfer */
-	ns87415_prepare_drive(drive, 1);
-	if (ide_dma_setup(drive, cmd) == 0)
-		return 0;
-	/* DMA failed: select PIO xfer */
 	ns87415_prepare_drive(drive, 0);
-	return 1;
+
+	/* verify good DMA status */
+	return (dma_stat & 7) != 4;
 }
 
 static void __devinit init_hwif_ns87415 (ide_hwif_t *hwif)
@@ -298,8 +296,8 @@ static const struct ide_port_ops ns87415
 
 static const struct ide_dma_ops ns87415_dma_ops = {
 	.dma_host_set		= ide_dma_host_set,
-	.dma_setup		= ns87415_dma_setup,
-	.dma_start		= ide_dma_start,
+	.dma_setup		= ide_dma_setup,
+	.dma_start		= ns87415_dma_start,
 	.dma_end		= ns87415_dma_end,
 	.dma_test_irq		= ide_dma_test_irq,
 	.dma_lost_irq		= ide_dma_lost_irq,
