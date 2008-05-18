Return-Path: <linux-kernel-owner+w=401wt.eu-S1758788AbYERSq7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758788AbYERSq7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 May 2008 14:46:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757350AbYERSkf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 May 2008 14:40:35 -0400
Received: from fg-out-1718.google.com ([72.14.220.152]:31100 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757554AbYERSkd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 May 2008 14:40:33 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=vVGOo9ZogqsE6J8Xcg8TAAI26/snF+la4A3xtGMGlHvFfO6uyRG/FeRJI9/zE5mHtWRFrUUkiB7Gfp85clREU8PXA0E6WvCCslgPuPlnXNTHMSAfl8RUf+r4ZpXzyyPmgenIrUbySAhivjVN4GU4a7CQerjnWLnurqaVOAC4JmA=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: Borislav Petkov <petkovbb@gmail.com>,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Date: Sun, 18 May 2008 20:57:55 +0200
Message-Id: <20080518185755.5636.98728.sendpatchset@localhost.localdomain>
In-Reply-To: <20080518185428.5636.77234.sendpatchset@localhost.localdomain>
References: <20080518185428.5636.77234.sendpatchset@localhost.localdomain>
Subject: [PATCH 23/40] ide-tape: set PC_FLAG_DMA_IN_PROGRESS flag in idetape_transfer_pc()
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Set PC_FLAG_DMA_IN_PROGRESS flag in idetape_transfer_pc() instead of
idetape_issue_pc() to match the other ATAPI device drivers.

Cc: Borislav Petkov <petkovbb@gmail.com>
Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/ide-tape.c |   10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

Index: b/drivers/ide/ide-tape.c
===================================================================
--- a/drivers/ide/ide-tape.c
+++ b/drivers/ide/ide-tape.c
@@ -984,8 +984,10 @@ static ide_startstop_t idetape_transfer_
 	ide_set_handler(drive, &idetape_pc_intr, IDETAPE_WAIT_CMD, NULL);
 
 	/* Begin DMA, if necessary */
-	if (pc->flags & PC_FLAG_DMA_IN_PROGRESS)
+	if (pc->flags & PC_FLAG_DMA_OK) {
+		pc->flags |= PC_FLAG_DMA_IN_PROGRESS;
 		hwif->dma_ops->dma_start(drive);
+	}
 
 	/* Send the actual packet */
 	hwif->output_data(drive, NULL, pc->c, 12);
@@ -1053,11 +1055,11 @@ static ide_startstop_t idetape_issue_pc(
 	if ((pc->flags & PC_FLAG_DMA_OK) && drive->using_dma)
 		dma_ok = !hwif->dma_ops->dma_setup(drive);
 
+	if (!dma_ok)
+		pc->flags &= ~PC_FLAG_DMA_OK;
+
 	ide_pktcmd_tf_load(drive, IDE_TFLAG_OUT_DEVICE, bcount, dma_ok);
 
-	if (dma_ok)
-		/* Will begin DMA later */
-		pc->flags |= PC_FLAG_DMA_IN_PROGRESS;
 	if (test_bit(IDETAPE_FLAG_DRQ_INTERRUPT, &tape->flags)) {
 		ide_execute_command(drive, WIN_PACKETCMD, &idetape_transfer_pc,
 				    IDETAPE_WAIT_CMD, NULL);
