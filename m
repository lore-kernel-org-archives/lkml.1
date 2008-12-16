Return-Path: <linux-kernel-owner+w=401wt.eu-S1755930AbYLPHmQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755930AbYLPHmQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Dec 2008 02:42:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752103AbYLPHl7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Dec 2008 02:41:59 -0500
Received: from mail-bw0-f21.google.com ([209.85.218.21]:47282 "EHLO
	mail-bw0-f21.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751946AbYLPHl6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2008 02:41:58 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=to:cc:subject:date:message-id:x-mailer:in-reply-to:references:from;
        b=B6MBx+VNP4r0gJ52Y7tPW1gt84rqySyT4RYhmRMbtZRjwpZwveLuq1cj5ns6unJkAE
         ke5L145W7KwoLpFGjck6/lIvUUqGx4OR6y7x1aUMhO8y6x6apfcQjT25tU1J7HB+hSqg
         PQk3XBx2weQEzoPO4JzWevaYwzpKwa/VTr9CA=
To: <bzolnier@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org,
       Borislav Petkov <petkovbb@gmail.com>
Subject: [PATCH 3/9] ide-atapi: replace pc->buf with rq->data in the irq handler
Date: Tue, 16 Dec 2008 08:36:03 +0100
Message-Id: <1229412969-3552-4-git-send-email-petkovbb@gmail.com>
X-Mailer: git-send-email 1.6.0.4
In-Reply-To: <1229412969-3552-1-git-send-email-petkovbb@gmail.com>
References: <1229412969-3552-1-git-send-email-petkovbb@gmail.com>
From: Borislav Petkov <petkovbb@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

... and also
1. pc->xferred with rq->data_len

2. add a dummy end request callback similar to ide-cd so that rqs don't get
killed while DRQ is still set

There should be no functionality change resulting from this patch.

Signed-off-by: Borislav Petkov <petkovbb@gmail.com>
---
 drivers/ide/ide-atapi.c  |   41 +++++++++++++++++++++++++----------------
 drivers/ide/ide-floppy.c |    3 ++-
 drivers/ide/ide-tape.c   |   12 ++++++------
 3 files changed, 33 insertions(+), 23 deletions(-)

diff --git a/drivers/ide/ide-atapi.c b/drivers/ide/ide-atapi.c
index ec29133..964a7e2 100644
--- a/drivers/ide/ide-atapi.c
+++ b/drivers/ide/ide-atapi.c
@@ -142,6 +142,8 @@ static void ide_queue_pc_head(ide_drive_t *drive, struct gendisk *disk,
 	memcpy(rq->cmd, pc->c, 12);
 	if (drive->media == ide_tape)
 		rq->cmd[13] = REQ_IDETAPE_PC1;
+	rq->data = pc->buf;
+	rq->data_len = 0;
 	ide_do_drive_cmd(drive, rq);
 }
 
@@ -161,6 +163,8 @@ int ide_queue_pc_tail(ide_drive_t *drive, struct gendisk *disk,
 	memcpy(rq->cmd, pc->c, 12);
 	if (drive->media == ide_tape)
 		rq->cmd[13] = REQ_IDETAPE_PC1;
+	rq->data = pc->buf;
+	rq->data_len = 0;
 	error = blk_execute_rq(drive->queue, disk, rq, 0);
 	blk_put_request(rq);
 
@@ -284,6 +288,11 @@ int ide_cd_get_xferlen(struct request *rq)
 }
 EXPORT_SYMBOL_GPL(ide_cd_get_xferlen);
 
+static int ide_floppy_irq_dummy_cb(struct request *rq)
+{
+	return 1;
+}
+
 /*
  * This is the usual interrupt handler which will be called during a packet
  * command.  We will transfer some of the data (as requested by the drive)
@@ -326,7 +335,7 @@ static ide_startstop_t ide_pc_intr(ide_drive_t *drive)
 						     ? "write" : "read");
 			drive->pc_flags |= PC_FLAG_DMA_ERROR;
 		} else {
-			pc->xferred = pc->req_xfer;
+			rq->data_len = pc->req_xfer;
 			if (drive->pc_update_buffers)
 				drive->pc_update_buffers(drive, pc);
 		}
@@ -336,7 +345,7 @@ static ide_startstop_t ide_pc_intr(ide_drive_t *drive)
 	/* No more interrupts */
 	if ((stat & ATA_DRQ) == 0) {
 		debug_log("Packet command completed, %d bytes transferred\n",
-			  pc->xferred);
+			  rq->data_len);
 
 		drive->pc_flags &= ~PC_FLAG_DMA_IN_PROGRESS;
 
@@ -406,9 +415,10 @@ static ide_startstop_t ide_pc_intr(ide_drive_t *drive)
 
 	if (!write) {
 		/* Reading - Check that we have enough space */
-		temp = pc->xferred + bcount;
+		temp = rq->data_len + bcount;
 		if (temp > pc->req_xfer) {
 			if (temp > pc->buf_size) {
+
 				printk(KERN_ERR "%s: The device wants to send "
 						"us more data than expected - "
 						"discarding data\n",
@@ -424,19 +434,22 @@ static ide_startstop_t ide_pc_intr(ide_drive_t *drive)
 	} else
 		xferfunc = tp_ops->output_data;
 
-	if ((drive->media == ide_floppy && !pc->buf) ||
+	if ((drive->media == ide_floppy && !rq->data) ||
 	    (drive->media == ide_tape && pc->bh)) {
-		int done = drive->pc_io_buffers(drive, pc, bcount, write);
 
-		/* FIXME: don't do partial completions */
+		drive->pc_io_buffers(drive, pc, bcount, write);
+
 		if (drive->media == ide_floppy)
-			ide_end_request(drive, 1, done >> 9);
-	} else
-		xferfunc(drive, NULL, pc->cur_pos, bcount);
+			blk_end_request_callback(rq, 0, bcount,
+						 ide_floppy_irq_dummy_cb);
 
-	/* Update the current position */
-	pc->xferred += bcount;
-	pc->cur_pos += bcount;
+	} else {
+		xferfunc(drive, NULL, rq->data, bcount);
+
+		/* Update the current position */
+		rq->data_len += bcount;
+		rq->data += bcount;
+	}
 
 	debug_log("[cmd %x] transferred %d bytes on that intr.\n",
 		  rq->cmd[0], bcount);
@@ -557,10 +570,6 @@ ide_startstop_t ide_issue_pc(ide_drive_t *drive, unsigned int timeout)
 	u32 tf_flags;
 	u16 bcount;
 
-	/* We haven't transferred any data yet */
-	pc->xferred = 0;
-	pc->cur_pos = pc->buf;
-
 	if (dev_is_idecd(drive)) {
 		tf_flags = IDE_TFLAG_OUT_NSECT | IDE_TFLAG_OUT_LBAL;
 		bcount = ide_cd_get_xferlen(hwif->hwgroup->rq);
diff --git a/drivers/ide/ide-floppy.c b/drivers/ide/ide-floppy.c
index 44e5b8a..f88ccd1 100644
--- a/drivers/ide/ide-floppy.c
+++ b/drivers/ide/ide-floppy.c
@@ -256,7 +256,8 @@ static void idefloppy_create_rw_cmd(ide_drive_t *drive,
 
 	pc->rq = rq;
 	pc->b_count = 0;
-	pc->buf = NULL;
+	rq->data = NULL;
+	rq->data_len = 0;
 	pc->req_xfer = pc->buf_size = blocks * floppy->block_size;
 	drive->pc_flags |= PC_FLAG_DMA_OK;
 }
diff --git a/drivers/ide/ide-tape.c b/drivers/ide/ide-tape.c
index caccb82..1890f9f 100644
--- a/drivers/ide/ide-tape.c
+++ b/drivers/ide/ide-tape.c
@@ -375,7 +375,7 @@ static void idetape_update_buffers(ide_drive_t *drive, struct ide_atapi_pc *pc)
 	struct idetape_bh *bh = pc->bh;
 	struct request *rq = drive->hwif->hwgroup->rq;
 	int count;
-	unsigned int bcount = pc->xferred;
+	unsigned int bcount = rq->data_len;
 
 	if (rq_data_dir(rq) == WRITE)
 		return;
@@ -401,6 +401,7 @@ static void idetape_update_buffers(ide_drive_t *drive, struct ide_atapi_pc *pc)
 static void idetape_analyze_error(ide_drive_t *drive, u8 *sense)
 {
 	idetape_tape_t *tape = drive->driver_data;
+	struct request *rq = drive->hwif->hwgroup->rq;
 	struct ide_atapi_pc *pc = tape->failed_pc;
 
 	tape->sense_key = sense[2] & 0xF;
@@ -410,9 +411,9 @@ static void idetape_analyze_error(ide_drive_t *drive, u8 *sense)
 	debug_log(DBG_ERR, "pc = %x, sense key = %x, asc = %x, ascq = %x\n",
 		 pc->c[0], tape->sense_key, tape->asc, tape->ascq);
 
-	/* Correct pc->xferred by asking the tape.	 */
+	/* Correct rq->data_len by asking the tape.	 */
 	if (drive->pc_flags & PC_FLAG_DMA_ERROR) {
-		pc->xferred = pc->req_xfer -
+		rq->data_len = pc->req_xfer -
 			tape->blk_size *
 			get_unaligned_be32(&sense[3]);
 		idetape_update_buffers(drive, pc);
@@ -449,8 +450,7 @@ static void idetape_analyze_error(ide_drive_t *drive, u8 *sense)
 			pc->error = IDETAPE_ERROR_EOD;
 			drive->pc_flags |= PC_FLAG_ABORT;
 		}
-		if (!(drive->pc_flags & PC_FLAG_ABORT) &&
-		    pc->xferred)
+		if (!(drive->pc_flags & PC_FLAG_ABORT) && rq->data_len)
 			pc->retries = IDETAPE_MAX_PC_RETRIES + 1;
 	}
 }
@@ -533,7 +533,7 @@ static void ide_tape_callback(ide_drive_t *drive, int dsc)
 					"itself - Aborting request!\n");
 	} else if (pc->c[0] == READ_6 || pc->c[0] == WRITE_6) {
 		struct request *rq = drive->hwif->hwgroup->rq;
-		int blocks = pc->xferred / tape->blk_size;
+		int blocks = rq->data_len / tape->blk_size;
 
 		tape->avg_size += blocks * tape->blk_size;
 
-- 
1.6.0.4

