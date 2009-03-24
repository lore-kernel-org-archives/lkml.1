Return-Path: <linux-kernel-owner+w=401wt.eu-S1753096AbZCXQMz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753096AbZCXQMz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Mar 2009 12:12:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761178AbZCXQGw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Mar 2009 12:06:52 -0400
Received: from hera.kernel.org ([140.211.167.34]:41837 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762209AbZCXQGj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Mar 2009 12:06:39 -0400
From: Tejun Heo <tj@kernel.org>
To: bzolnier@gmail.com, linux-kernel@vger.kernel.org, axboe@kernel.dk,
       linux-ide@vger.kernel.org
Cc: Tejun Heo <tj@kernel.org>
Subject: [PATCH 13/14] ide-atapi: use bio for request sense
Date: Wed, 25 Mar 2009 01:06:15 +0900
Message-Id: <1237910776-10983-14-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.6.0.2
In-Reply-To: <1237910776-10983-1-git-send-email-tj@kernel.org>
References: <1237910776-10983-1-git-send-email-tj@kernel.org>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Tue, 24 Mar 2009 16:06:35 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: unify request data buffer handling

rq->data is used mostly to pass kernel buffer through request queue
without using bio.  There are only a couple of places which still do
this in kernel and converting to bio isn't difficult.

This patch converts ide-atapi to use bio instead of rq->data.  For
ide_queue_pc_tail() which can block, blk_rq_map_kern() is used.  For
ide_queue_pc_head() which is used for request sense and called from
atomic context, drive->request_sense_bio and ->request_sense_bvec[2]
are added and used via bio_map_kern_prealloc().

ide-tape is updated to map sg for special requests.

This change makes all ide-atapi commands except for tape bh ones use
bio.  Drop tp_ops->output/input_data path from ide_pc_intr().

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Jens Axboe <axboe@kernel.dk>
---
 drivers/ide/ide-atapi.c |   38 ++++++++++++++++++++++----------------
 drivers/ide/ide-tape.c  |    8 +++++---
 include/linux/ide.h     |    3 +++
 3 files changed, 30 insertions(+), 19 deletions(-)

diff --git a/drivers/ide/ide-atapi.c b/drivers/ide/ide-atapi.c
index 5ab3014..bc7dfcf 100644
--- a/drivers/ide/ide-atapi.c
+++ b/drivers/ide/ide-atapi.c
@@ -83,7 +83,9 @@ EXPORT_SYMBOL_GPL(ide_init_pc);
  * pass through the driver.
  */
 static void ide_queue_pc_head(ide_drive_t *drive, struct gendisk *disk,
-			      struct ide_atapi_pc *pc, struct request *rq)
+			      struct ide_atapi_pc *pc, struct request *rq,
+			      struct bio *bio, struct bio_vec *bvec,
+			      unsigned short bvec_len)
 {
 	blk_rq_init(NULL, rq);
 	rq->cmd_type = REQ_TYPE_SPECIAL;
@@ -92,8 +94,12 @@ static void ide_queue_pc_head(ide_drive_t *drive, struct gendisk *disk,
 	rq->rq_disk = disk;
 
 	if (pc->req_xfer) {
-		rq->data = pc->buf;
-		rq->data_len = pc->req_xfer;
+		int error;
+
+		error = blk_rq_map_kern_prealloc(drive->queue, rq, bio,
+						 bvec, bvec_len,
+						 pc->buf, pc->req_xfer, true);
+		BUG_ON(error);
 	}
 
 	memcpy(rq->cmd, pc->c, 12);
@@ -120,16 +126,19 @@ int ide_queue_pc_tail(ide_drive_t *drive, struct gendisk *disk,
 	rq->special = (char *)pc;
 
 	if (pc->req_xfer) {
-		rq->data = pc->buf;
-		rq->data_len = pc->req_xfer;
+		error = blk_rq_map_kern(drive->queue, rq, pc->buf, pc->req_xfer,
+					__GFP_WAIT);
+		if (error)
+			goto put_req;
 	}
 
 	memcpy(rq->cmd, pc->c, 12);
 	if (drive->media == ide_tape)
 		rq->cmd[13] = REQ_IDETAPE_PC1;
 	error = blk_execute_rq(drive->queue, disk, rq, 0);
-	blk_put_request(rq);
 
+put_req:
+	blk_put_request(rq);
 	return error;
 }
 EXPORT_SYMBOL_GPL(ide_queue_pc_tail);
@@ -196,13 +205,16 @@ EXPORT_SYMBOL_GPL(ide_create_request_sense_cmd);
 void ide_retry_pc(ide_drive_t *drive, struct gendisk *disk)
 {
 	struct request *rq = &drive->request_sense_rq;
+	struct bio *bio = &drive->request_sense_bio;
+	struct bio_vec *bvec = drive->request_sense_bvec;
 	struct ide_atapi_pc *pc = &drive->request_sense_pc;
+	unsigned short bvec_len = ARRAY_SIZE(drive->request_sense_bvec);
 
 	(void)ide_read_error(drive);
 	ide_create_request_sense_cmd(drive, pc);
 	if (drive->media == ide_tape)
 		set_bit(IDE_AFLAG_IGNORE_DSC, &drive->atapi_flags);
-	ide_queue_pc_head(drive, disk, pc, rq);
+	ide_queue_pc_head(drive, disk, pc, rq, bio, bvec, bvec_len);
 }
 EXPORT_SYMBOL_GPL(ide_retry_pc);
 
@@ -277,7 +289,6 @@ static ide_startstop_t ide_pc_intr(ide_drive_t *drive)
 	struct ide_cmd *cmd = &hwif->cmd;
 	struct request *rq = hwif->rq;
 	const struct ide_tp_ops *tp_ops = hwif->tp_ops;
-	xfer_func_t *xferfunc;
 	unsigned int timeout, done;
 	u16 bcount;
 	u8 stat, ireason, dsc = 0;
@@ -409,16 +420,11 @@ static ide_startstop_t ide_pc_intr(ide_drive_t *drive)
 		return ide_do_reset(drive);
 	}
 
-	xferfunc = write ? tp_ops->output_data : tp_ops->input_data;
-
-	if (drive->media == ide_floppy && pc->buf == NULL) {
+	if (drive->media == ide_tape && pc->bh)
+		done = drive->pc_io_buffers(drive, pc, bcount, write);
+	else {
 		done = min_t(unsigned int, bcount, cmd->nleft);
 		ide_pio_bytes(drive, cmd, write, done);
-	} else if (drive->media == ide_tape && pc->bh) {
-		done = drive->pc_io_buffers(drive, pc, bcount, write);
-	} else {
-		done = min_t(unsigned int, bcount, pc->req_xfer - pc->xferred);
-		xferfunc(drive, NULL, pc->cur_pos, done);
 	}
 
 	/* Update the current position */
diff --git a/drivers/ide/ide-tape.c b/drivers/ide/ide-tape.c
index 3d16c77..d52f8b3 100644
--- a/drivers/ide/ide-tape.c
+++ b/drivers/ide/ide-tape.c
@@ -750,7 +750,7 @@ static ide_startstop_t idetape_do_request(ide_drive_t *drive,
 	idetape_tape_t *tape = drive->driver_data;
 	struct ide_atapi_pc *pc = NULL;
 	struct request *postponed_rq = tape->postponed_rq;
-	struct ide_cmd cmd;
+	struct ide_cmd cmd = { };
 	u8 stat;
 
 	debug_log(DBG_SENSE, "sector: %llu, nr_sectors: %lu,"
@@ -837,6 +837,10 @@ static ide_startstop_t idetape_do_request(ide_drive_t *drive,
 		pc = (struct ide_atapi_pc *)rq->special;
 		rq->cmd[13] &= ~(REQ_IDETAPE_PC1);
 		rq->cmd[13] |= REQ_IDETAPE_PC2;
+		if (pc->req_xfer) {
+			ide_init_sg_cmd(&cmd, pc->req_xfer);
+			ide_map_sg(drive, &cmd);
+		}
 		goto out;
 	}
 	if (rq->cmd[13] & REQ_IDETAPE_PC2) {
@@ -846,8 +850,6 @@ static ide_startstop_t idetape_do_request(ide_drive_t *drive,
 	BUG();
 
 out:
-	memset(&cmd, 0, sizeof(cmd));
-
 	if (rq_data_dir(rq))
 		cmd.tf_flags |= IDE_TFLAG_WRITE;
 
diff --git a/include/linux/ide.h b/include/linux/ide.h
index 662ea26..8d3bb27 100644
--- a/include/linux/ide.h
+++ b/include/linux/ide.h
@@ -638,8 +638,11 @@ struct ide_drive_s {
 
 	unsigned long atapi_flags;
 
+	/* for request sense */
 	struct ide_atapi_pc request_sense_pc;
 	struct request request_sense_rq;
+	struct bio request_sense_bio;
+	struct bio_vec request_sense_bvec[2];
 };
 
 typedef struct ide_drive_s ide_drive_t;
-- 
1.6.0.2

