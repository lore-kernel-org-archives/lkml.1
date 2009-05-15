Return-Path: <linux-kernel-owner+w=401wt.eu-S1760609AbZEOFNp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760609AbZEOFNp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 May 2009 01:13:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754050AbZEOFLs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 May 2009 01:11:48 -0400
Received: from mail-bw0-f174.google.com ([209.85.218.174]:55701 "EHLO
	mail-bw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753216AbZEOFLk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 May 2009 01:11:40 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=Ye2QfU0pUyPzoQVcV/t1Po1leNBAlBwtdKUghezYUEyeZg8G0Z0Sp3SX2c1gZHcoEV
         T7rv3gsllWGk7bep7oXSbcchXcBAq/YENJQJ8stXkcgjQOfcUOXoyyL3TQFKvWpIBGi0
         say/FIMYNXsqAfAuisUW2JRqgfAYADfyNM7CI=
From: Borislav Petkov <petkovbb@googlemail.com>
To: <bzolnier@gmail.com>
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 03/15] ide-atapi: switch to rq->resid_len
Date: Fri, 15 May 2009 07:11:21 +0200
Message-Id: <1242364293-29223-4-git-send-email-petkovbb@gmail.com>
X-Mailer: git-send-email 1.6.3
In-Reply-To: <1242364293-29223-1-git-send-email-petkovbb@gmail.com>
References: <1242364293-29223-1-git-send-email-petkovbb@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now that we have rq->resid_len, use it to account partial completion
amount during the lifetime of an rq, decrementing it on each successful
transfer. As a result, get rid of now unused pc->xferred.

While at it, remove noisy debug call in ide_prep_sense.

Signed-off-by: Borislav Petkov <petkovbb@gmail.com>
---
 drivers/ide/ide-atapi.c |   19 ++++++++-----------
 drivers/ide/ide-tape.c  |   12 +++++-------
 include/linux/ide.h     |    2 --
 3 files changed, 13 insertions(+), 20 deletions(-)

diff --git a/drivers/ide/ide-atapi.c b/drivers/ide/ide-atapi.c
index 7129495..1022e42 100644
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
@@ -370,7 +368,7 @@ static ide_startstop_t ide_pc_intr(ide_drive_t *drive)
 						     ? "write" : "read");
 			pc->flags |= PC_FLAG_DMA_ERROR;
 		} else
-			pc->xferred = blk_rq_bytes(rq);
+			rq->resid_len = 0;
 		debug_log("%s: DMA finished\n", drive->name);
 	}
 
@@ -379,7 +377,7 @@ static ide_startstop_t ide_pc_intr(ide_drive_t *drive)
 		int uptodate, error;
 
 		debug_log("Packet command completed, %d bytes transferred\n",
-			  pc->xferred);
+			  blk_rq_bytes(rq));
 
 		pc->flags &= ~PC_FLAG_DMA_IN_PROGRESS;
 
@@ -467,15 +465,15 @@ static ide_startstop_t ide_pc_intr(ide_drive_t *drive)
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
@@ -643,16 +641,15 @@ ide_startstop_t ide_issue_pc(ide_drive_t *drive, struct ide_cmd *cmd)
 	} else {
 		pc = drive->pc;
 
-		/* We haven't transferred any data yet */
-		pc->xferred = 0;
-
 		valid_tf = IDE_VALID_DEVICE;
 		bytes = blk_rq_bytes(rq);
-
 		bcount = ((drive->media == ide_tape) ? bytes
 						     : min_t(unsigned int,
 							     bytes, 63 * 1024));
 
+		/* We haven't transferred any data yet */
+		rq->resid_len = bcount;
+
 		if (pc->flags & PC_FLAG_DMA_ERROR) {
 			pc->flags &= ~PC_FLAG_DMA_ERROR;
 			ide_dma_off(drive);
diff --git a/drivers/ide/ide-tape.c b/drivers/ide/ide-tape.c
index aaeef12..c933709 100644
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
@@ -369,7 +367,8 @@ static int ide_tape_callback(ide_drive_t *drive, int dsc)
 			printk(KERN_ERR "ide-tape: Error in REQUEST SENSE "
 					"itself - Aborting request!\n");
 	} else if (pc->c[0] == READ_6 || pc->c[0] == WRITE_6) {
-		int blocks = pc->xferred / tape->blk_size;
+		unsigned int blocks =
+			(blk_rq_bytes(rq) - rq->resid_len) / tape->blk_size;
 
 		tape->avg_size += blocks * tape->blk_size;
 
@@ -381,7 +380,6 @@ static int ide_tape_callback(ide_drive_t *drive, int dsc)
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
1.6.3

