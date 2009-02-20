Return-Path: <linux-kernel-owner+w=401wt.eu-S1759080AbZBTRK4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759080AbZBTRK4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Feb 2009 12:10:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754691AbZBTRKE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Feb 2009 12:10:04 -0500
Received: from mail-fx0-f167.google.com ([209.85.220.167]:65258 "EHLO
	mail-fx0-f167.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758619AbZBTRKB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Feb 2009 12:10:01 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=r1gUlT7udzh5/AXZ47M4yDDK8vRv4ganrHiXbiqA/qfsJeMu3n5GNcBU9qxYiTwl9X
         01LhaSeTTLnuiJZ38iEzPly+wPJfFsAFwBvU0v1ADa8K3xzPCIHWdtGZ8knbJ0lb2byD
         8k8nUtEIlMHOWVpkirE5ewUxw2sZZBE6APx10=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Date: Fri, 20 Feb 2009 18:11:54 +0100
Message-Id: <20090220171154.25429.24988.sendpatchset@localhost.localdomain>
In-Reply-To: <20090220171139.25429.26702.sendpatchset@localhost.localdomain>
References: <20090220171139.25429.26702.sendpatchset@localhost.localdomain>
Subject: [PATCH 02/10] ide: inline ide_dma_timeout() into ide_dma_timeout_retry()
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: [PATCH] ide: inline ide_dma_timeout() into ide_dma_timeout_retry()

Since ide_dma_timeout() is only used by ide_dma_timeout_retry()
inline it there.

There should be no functional changes caused by this patch.

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/ide-dma.c |   21 ++++++---------------
 1 file changed, 6 insertions(+), 15 deletions(-)

Index: b/drivers/ide/ide-dma.c
===================================================================
--- a/drivers/ide/ide-dma.c
+++ b/drivers/ide/ide-dma.c
@@ -456,20 +456,6 @@ void ide_dma_lost_irq(ide_drive_t *drive
 }
 EXPORT_SYMBOL_GPL(ide_dma_lost_irq);
 
-static void ide_dma_timeout(ide_drive_t *drive)
-{
-	ide_hwif_t *hwif = drive->hwif;
-
-	printk(KERN_ERR "%s: timeout waiting for DMA\n", drive->name);
-
-	if (hwif->dma_ops->dma_test_irq(drive))
-		return;
-
-	ide_dump_status(drive, "DMA timeout", hwif->tp_ops->read_status(hwif));
-
-	hwif->dma_ops->dma_end(drive);
-}
-
 /*
  * un-busy the port etc, and clear any pending DMA status. we want to
  * retry the current request in pio mode instead of risking tossing it
@@ -495,7 +481,12 @@ ide_startstop_t ide_dma_timeout_retry(id
 		printk(KERN_WARNING "%s: DMA timeout retry\n", drive->name);
 		if (dma_ops->dma_clear)
 			dma_ops->dma_clear(drive);
-		ide_dma_timeout(drive);
+		printk(KERN_ERR "%s: timeout waiting for DMA\n", drive->name);
+		if (dma_ops->dma_test_irq(drive) == 0) {
+			ide_dump_status(drive, "DMA timeout",
+					hwif->tp_ops->read_status(hwif));
+			(void)dma_ops->dma_end(drive);
+		}
 	}
 
 	/*
