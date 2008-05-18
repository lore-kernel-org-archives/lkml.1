Return-Path: <linux-kernel-owner+w=401wt.eu-S1760020AbYERSqp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760020AbYERSqp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 May 2008 14:46:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755579AbYERSkZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 May 2008 14:40:25 -0400
Received: from fk-out-0910.google.com ([209.85.128.185]:20229 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754925AbYERSkW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 May 2008 14:40:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=ZMCkMxwY+QpyYIJVV4JrbMpCN5SWtjGPswYgRmfmJVTI91kLjxGZz/kqmC0HjkivRFpbc63uf50S5aFqntUDYK7fW4GxmHFLG7Tx6+hTQlHSrRCJdF7J66V3eN5F7mKSBZAsi/LpBU6Tr2Coa+Xt6emj40UtqQ6AeVo+0kwIimQ=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: Borislav Petkov <petkovbb@gmail.com>,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Date: Sun, 18 May 2008 20:57:45 +0200
Message-Id: <20080518185745.5636.55162.sendpatchset@localhost.localdomain>
In-Reply-To: <20080518185428.5636.77234.sendpatchset@localhost.localdomain>
References: <20080518185428.5636.77234.sendpatchset@localhost.localdomain>
Subject: [PATCH 22/40] ide-floppy: start DMA engine in idefloppy_transfer_pc1()
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Start DMA engine and set PC_FLAG_DMA_IN_PROGRESS flag in
idefloppy_transfer_pc1() instead of idefloppy_issue_pc()
so the Status Register and the Interrupt Reason Register
are checked first.

Cc: Borislav Petkov <petkovbb@gmail.com>
Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/ide-floppy.c |   16 ++++++++++------
 1 file changed, 10 insertions(+), 6 deletions(-)

Index: b/drivers/ide/ide-floppy.c
===================================================================
--- a/drivers/ide/ide-floppy.c
+++ b/drivers/ide/ide-floppy.c
@@ -534,6 +534,7 @@ static ide_startstop_t idefloppy_transfe
 {
 	ide_hwif_t *hwif = drive->hwif;
 	idefloppy_floppy_t *floppy = drive->driver_data;
+	struct ide_atapi_pc *pc = floppy->pc;
 	ide_expiry_t *expiry;
 	unsigned int timeout;
 	ide_startstop_t startstop;
@@ -568,6 +569,12 @@ static ide_startstop_t idefloppy_transfe
 
 	ide_set_handler(drive, &idefloppy_pc_intr, timeout, expiry);
 
+	/* Begin DMA, if necessary */
+	if (pc->flags & PC_FLAG_DMA_OK) {
+		pc->flags |= PC_FLAG_DMA_IN_PROGRESS;
+		hwif->dma_ops->dma_start(drive);
+	}
+
 	if ((floppy->flags & IDEFLOPPY_FLAG_ZIP_DRIVE) == 0)
 		/* Send the actual packet */
 		hwif->output_data(drive, NULL, floppy->pc->c, 12);
@@ -633,13 +640,10 @@ static ide_startstop_t idefloppy_issue_p
 	if ((pc->flags & PC_FLAG_DMA_OK) && drive->using_dma)
 		dma = !hwif->dma_ops->dma_setup(drive);
 
-	ide_pktcmd_tf_load(drive, IDE_TFLAG_OUT_DEVICE, bcount, dma);
+	if (!dma)
+		pc->flags &= ~PC_FLAG_DMA_OK;
 
-	if (dma) {
-		/* Begin DMA, if necessary */
-		pc->flags |= PC_FLAG_DMA_IN_PROGRESS;
-		hwif->dma_ops->dma_start(drive);
-	}
+	ide_pktcmd_tf_load(drive, IDE_TFLAG_OUT_DEVICE, bcount, dma);
 
 	if (floppy->flags & IDEFLOPPY_FLAG_DRQ_INTERRUPT) {
 		/* Issue the packet command */
