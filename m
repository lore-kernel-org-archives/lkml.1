Return-Path: <linux-kernel-owner+w=401wt.eu-S1756718AbYERSic@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756718AbYERSic (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 May 2008 14:38:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755006AbYERShc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 May 2008 14:37:32 -0400
Received: from fk-out-0910.google.com ([209.85.128.191]:17569 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756038AbYERSha (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 May 2008 14:37:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=jW8ge+Lu+bRmweKqSrCNSRcL7TYpmKoF4LTP4ZGq+xOpwRLFiJREPebr461ftK37PNmnWUsTJ9fjbiyIiuB/Tp+xoSv/ozsn+PK3B+yr+V/zSLwFaJ5A8s5z9PSJBdBEPvPTNEYIA5shCdixfZ6EcvnqJXEisiKfQCNPH5QxUgQ=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: Borislav Petkov <petkovbb@gmail.com>,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Date: Sun, 18 May 2008 20:54:54 +0200
Message-Id: <20080518185454.5636.48014.sendpatchset@localhost.localdomain>
In-Reply-To: <20080518185428.5636.77234.sendpatchset@localhost.localdomain>
References: <20080518185428.5636.77234.sendpatchset@localhost.localdomain>
Subject: [PATCH 03/40] ide-scsi: fix handling of DMA errors in idescsi_pc_intr()
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Check return value of ->dma_end method and if there was a DMA error
handle it accordingly (set PC_FLAG_DMA_ERROR pc flag, don't update
pc->xferred and increase rq->errors).

Also move debug message in the right place while at it.

Cc: Borislav Petkov <petkovbb@gmail.com>
Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/scsi/ide-scsi.c |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

Index: b/drivers/scsi/ide-scsi.c
===================================================================
--- a/drivers/scsi/ide-scsi.c
+++ b/drivers/scsi/ide-scsi.c
@@ -388,11 +388,13 @@ static ide_startstop_t idescsi_pc_intr (
 		return ide_stopped;
 	}
 	if (pc->flags & PC_FLAG_DMA_IN_PROGRESS) {
+		if (hwif->dma_ops->dma_end(drive))
+			pc->flags |= PC_FLAG_DMA_ERROR;
+		else
+			pc->xferred = pc->req_xfer;
 #if IDESCSI_DEBUG_LOG
 		printk ("ide-scsi: %s: DMA complete\n", drive->name);
 #endif /* IDESCSI_DEBUG_LOG */
-		pc->xferred = pc->req_xfer;
-		(void)hwif->dma_ops->dma_end(drive);
 	}
 
 	/* Clear the interrupt */
@@ -405,7 +407,7 @@ static ide_startstop_t idescsi_pc_intr (
 					" transferred\n", pc->xferred);
 		pc->flags &= ~PC_FLAG_DMA_IN_PROGRESS;
 		local_irq_enable_in_hardirq();
-		if (stat & ERR_STAT)
+		if ((stat & ERR_STAT) || (pc->flags & PC_FLAG_DMA_ERROR))
 			rq->errors++;
 		idescsi_end_request (drive, 1, 0);
 		return ide_stopped;
