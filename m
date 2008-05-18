Return-Path: <linux-kernel-owner+w=401wt.eu-S1758711AbYERSvc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758711AbYERSvc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 May 2008 14:51:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758448AbYERSm2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 May 2008 14:42:28 -0400
Received: from ug-out-1314.google.com ([66.249.92.172]:52155 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758425AbYERSm0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 May 2008 14:42:26 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=POBddcqrCqAlcMFJT3Rp11elbfB3xqfXdAsUdF3vy2BCUwkrIV5FoHz7SHKfqmo0egz3LaucMVL8qFVdJdqGrNxZXfhQNQF8LToJQJyF22ocGal9AV9bof2HzNcl3bGU13e9Rw5LGg57XLLhYac5EAasUKE627V4PE7IiPWoB+A=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: Borislav Petkov <petkovbb@gmail.com>,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Date: Sun, 18 May 2008 20:59:52 +0200
Message-Id: <20080518185952.5636.30809.sendpatchset@localhost.localdomain>
In-Reply-To: <20080518185428.5636.77234.sendpatchset@localhost.localdomain>
References: <20080518185428.5636.77234.sendpatchset@localhost.localdomain>
Subject: [PATCH 36/40] ide-floppy: add more debugging to idefloppy_pc_intr()
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add more debugging to idefloppy_pc_intr() to match ide-tape's
idetape_pc_intr().

While at it:

* Correct the first debug message.

* Log device name with "DMA finished" message.

This is a preparation for adding generic ide_pc_intr() helper.

Cc: Borislav Petkov <petkovbb@gmail.com>
Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/ide-floppy.c |   10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

Index: b/drivers/ide/ide-floppy.c
===================================================================
--- a/drivers/ide/ide-floppy.c
+++ b/drivers/ide/ide-floppy.c
@@ -397,7 +397,7 @@ static ide_startstop_t idefloppy_pc_intr
 	u16 bcount;
 	u8 stat, ireason;
 
-	debug_log("Reached %s interrupt handler\n", __func__);
+	debug_log("Enter %s - interrupt handler\n", __func__);
 
 	if (pc->flags & PC_FLAG_DMA_IN_PROGRESS) {
 		dma_error = hwif->dma_ops->dma_end(drive);
@@ -409,7 +409,7 @@ static ide_startstop_t idefloppy_pc_intr
 			pc->xferred = pc->req_xfer;
 			idefloppy_update_buffers(drive, pc);
 		}
-		debug_log("DMA finished\n");
+		debug_log("%s: DMA finished\n", drive->name);
 	}
 
 	/* Clear the interrupt */
@@ -432,6 +432,9 @@ static ide_startstop_t idefloppy_pc_intr
 						" command\n", drive->name);
 				return ide_do_reset(drive);
 			}
+
+			debug_log("[cmd %x]: check condition\n", pc->c[0]);
+
 			/* Retry operation */
 			idefloppy_retry_pc(drive);
 			/* queued, but not started */
@@ -505,6 +508,9 @@ static ide_startstop_t idefloppy_pc_intr
 	pc->xferred += bcount;
 	pc->cur_pos += bcount;
 
+	debug_log("[cmd %x] transferred %d bytes on that intr.\n",
+		  pc->c[0], bcount);
+
 	/* And set the interrupt handler again */
 	ide_set_handler(drive, &idefloppy_pc_intr, IDEFLOPPY_WAIT_CMD, NULL);
 	return ide_started;
