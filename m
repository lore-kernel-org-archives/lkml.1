Return-Path: <linux-kernel-owner+w=401wt.eu-S1753038AbZEIHq1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753038AbZEIHq1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 May 2009 03:46:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751693AbZEIHpj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 May 2009 03:45:39 -0400
Received: from mail-fx0-f158.google.com ([209.85.220.158]:45133 "EHLO
	mail-fx0-f158.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750922AbZEIHph (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 May 2009 03:45:37 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=SFARSJ7BkgbpyPhkZBcjFIvlbHScq8GAdvSvCg0yohq2qkwBRfXzEGAAXOtqk/29si
         2mL9J++JYwsZvHH8wWaHxUdj8/qEPTKH3d2G6gu6A6M1ZivSEyhsNi2UYpSQjX0cWr41
         UPUZx0VjQXvCIqZaAJ86Iop8SNa5rNNvcvRFQ=
From: Borislav Petkov <petkovbb@googlemail.com>
To: <bzolnier@gmail.com>
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 03/14] ide-atapi: switch to rq->resid_len
Date: Sat,  9 May 2009 09:45:23 +0200
Message-Id: <1241855134-4984-4-git-send-email-petkovbb@gmail.com>
X-Mailer: git-send-email 1.6.2.4
In-Reply-To: <1241855134-4984-1-git-send-email-petkovbb@gmail.com>
References: <1241855134-4984-1-git-send-email-petkovbb@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now that we have rq->resid_len, use it to account partial completion
amount during the lifetime of an rq, decrementing it on each successful
transfer. As a result, get rid of now unused pc->xferred.

While at it, remove noisy debug call in ide_prep_sense.

Signed-off-by: Borislav Petkov <petkovbb@gmail.com>
---
 drivers/ide/ide-atapi.c |   17 ++++++++---------
 drivers/ide/ide-tape.c  |   11 ++++-------
 include/linux/ide.h     |    2 --
 3 files changed, 12 insertions(+), 18 deletions(-)

diff --git a/drivers/ide/ide-atapi.c b/drivers/ide/ide-atapi.c
index cacffd4..1f2af8b 100644
--- a/drivers/ide/ide-atapi.c
+++ b/drivers/ide/ide-atapi.c
@@ -172,8 +172,6 @@ void ide_prep_sense(ide_drive_t *drive, struct request *rq)
 	unsigned int cmd_len, sense_len;
 	int err;
 
-	debug_log("%s: enter\n", __func__);
-
 	switch (drive->media) {
 	case ide_floppy:
 		cmd_len = 255;
@@ -360,7 +358,7 @@ static ide_startstop_t ide_pc_intr(ide_drive_t *drive)
 						     ? "write" : "read");
 			pc->flags |= PC_FLAG_DMA_ERROR;
 		} else
-			pc->xferred = blk_rq_bytes(rq);
+			rq->resid_len = 0;
 		debug_log("%s: DMA finished\n", drive->name);
 	}
 
@@ -369,7 +367,7 @@ static ide_startstop_t ide_pc_intr(ide_drive_t *drive)
 		int uptodate, error;
 
 		debug_log("Packet command completed, %d bytes transferred\n",
-			  pc->xferred);
+			  blk_rq_bytes(rq));
 
 		pc->flags &= ~PC_FLAG_DMA_IN_PROGRESS;
 
@@ -457,15 +455,15 @@ static ide_startstop_t ide_pc_intr(ide_drive_t *drive)
 	ide_pio_bytes(drive, cmd, write, done);
 
 	/* Update transferred byte count */
-	pc->xferred += done;
+	rq->resid_len -= done;
 
 	bcount -= done;
 
 	if (bcount)
 		ide_pad_transfer(drive, write, bcount);
 
-	debug_log("[cmd %x] transferred %d bytes, padded %d bytes\n",
-		  rq->cmd[0], done, bcount);
+	debug_log("[cmd %x] transferred %d bytes, padded %d bytes, resid: %u\n",
+		  rq->cmd[0], done, bcount, rq->resid_len);
 
 	/* And set the interrupt handler again */
 	ide_set_handler(drive, ide_pc_intr, timeout);
@@ -633,8 +631,6 @@ ide_startstop_t ide_issue_pc(ide_drive_t *drive, struct ide_cmd *cmd)
 	} else {
 		pc = drive->pc;
 
-		/* We haven't transferred any data yet */
-		pc->xferred = 0;
 
 		valid_tf = IDE_VALID_DEVICE;
 		bytes = blk_rq_bytes(rq);
@@ -643,6 +639,9 @@ ide_startstop_t ide_issue_pc(ide_drive_t *drive, struct ide_cmd *cmd)
 						     : min_t(unsigned int,
 							     bytes, 63 * 1024));
 
+		/* We haven't transferred any data yet */
+		rq->resid_len = bcount;
+
 		if (pc->flags & PC_FLAG_DMA_ERROR) {
 			pc->flags &= ~PC_FLAG_DMA_ERROR;
 			ide_dma_off(drive);
diff --git a/drivers/ide/ide-tape.c b/drivers/ide/ide-tape.c
index 25463c5..35c188a 100644
--- a/drivers/ide/ide-tape.c
+++ b/drivers/ide/ide-tape.c
@@ -301,11 +301,9 @@ static void idetape_analyze_error(ide_drive_t *drive, u8 *sense)
 	debug_log(DBG_ERR, "pc = %x, sense key = %x, asc = %x, ascq = %x\n",
 		 pc->c[0], tape->sense_key, tape->asc, tape->ascq);
 
-	/* Correct pc->xferred by asking the tape.	 */
+	/* correct remaining bytes to transfer */
 	if (pc->flags & PC_FLAG_DMA_ERROR)
-		pc->xferred = blk_rq_bytes(rq) -
-			tape->blk_size *
-			get_unaligned_be32(&sense[3]);
+		rq->resid_len = tape->blk_size * get_unaligned_be32(&sense[3]);
 
 	/*
 	 * If error was the result of a zero-length read or write command,
@@ -339,7 +337,7 @@ static void idetape_analyze_error(ide_drive_t *drive, u8 *sense)
 			pc->flags |= PC_FLAG_ABORT;
 		}
 		if (!(pc->flags & PC_FLAG_ABORT) &&
-		    pc->xferred)
+		    (blk_rq_bytes(rq) - rq->resid_len))
 			pc->retries = IDETAPE_MAX_PC_RETRIES + 1;
 	}
 }
@@ -369,7 +367,7 @@ static int ide_tape_callback(ide_drive_t *drive, int dsc)
 			printk(KERN_ERR "ide-tape: Error in REQUEST SENSE "
 					"itself - Aborting request!\n");
 	} else if (pc->c[0] == READ_6 || pc->c[0] == WRITE_6) {
-		int blocks = pc->xferred / tape->blk_size;
+		int blocks = (blk_rq_bytes(rq) - rq->resid_len) / tape->blk_size;
 
 		tape->avg_size += blocks * tape->blk_size;
 
@@ -381,7 +379,6 @@ static int ide_tape_callback(ide_drive_t *drive, int dsc)
 		}
 
 		tape->first_frame += blocks;
-		rq->resid_len = blk_rq_bytes(rq) - blocks * tape->blk_size;
 
 		if (pc->error) {
 			uptodate = 0;
diff --git a/include/linux/ide.h b/include/linux/ide.h
index 34c128f..745a393 100644
--- a/include/linux/ide.h
+++ b/include/linux/ide.h
@@ -357,8 +357,6 @@ struct ide_atapi_pc {
 
 	/* bytes to transfer */
 	int req_xfer;
-	/* bytes actually transferred */
-	int xferred;
 
 	/* data buffer */
 	u8 *buf;
-- 
1.6.2.4

