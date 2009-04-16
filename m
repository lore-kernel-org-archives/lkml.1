Return-Path: <linux-kernel-owner+w=401wt.eu-S1755209AbZDPFya@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755209AbZDPFya (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Apr 2009 01:54:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752621AbZDPFyI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Apr 2009 01:54:08 -0400
Received: from mail-bw0-f169.google.com ([209.85.218.169]:54585 "EHLO
	mail-bw0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754423AbZDPFyG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Apr 2009 01:54:06 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=date:from:to:subject:message-id:reply-to:mail-followup-to
         :references:mime-version:content-type:content-disposition
         :in-reply-to:user-agent;
        b=HvK3FbUYIRJYH1A8svajEU1eNsk1j3Dpv7OpcqCSU6LJRdKWf5tHiY6HGOP/iLKs45
         13YYW5juktJPneqnu0CmwekWTk5UyBDnjZNJxg1EC9OJ7GQ9xwe5HHcUPgd3wXFm2HMb
         EuQg/D1W90XTJ/SK48NpW893Y5frf4Q10aAjY=
Date: Thu, 16 Apr 2009 07:54:00 +0200
From: Borislav Petkov <petkovbb@googlemail.com>
To: linux-kernel@vger.kernel.org
Subject: [PATCH 3/3] ide-atapi: convert ide-{floppy,tape} to using
	preallocated sense buffer
Message-ID: <20090416055400.GA21817@liondog.tnic>
Reply-To: petkovbb@gmail.com
Mail-Followup-To: petkovbb@gmail.com, linux-kernel@vger.kernel.org
References: <49E6A0B5.2090704@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <49E6A0B5.2090704@kernel.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since we're issuing REQ_TYPE_SENSE now we need to allow those types of
rqs in the ->do_request callbacks. As a future improvement, sense_len
assignment might be unified across all ATAPI devices. Borislav to check
with specs and test.

As a result, get rid of ide_queue_pc_head() and the block layer structs.

CC: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
CC: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
CC: Tejun Heo <tj@kernel.org>
Signed-off-by: Borislav Petkov <petkovbb@gmail.com>
---
 drivers/ide/ide-atapi.c  |   59 ++++++++++++++--------------------------------
 drivers/ide/ide-floppy.c |   19 ++++++++++++++-
 drivers/ide/ide-gd.c     |    4 +++
 drivers/ide/ide-tape.c   |   23 +++++++++++++++++-
 include/linux/ide.h      |    3 --
 5 files changed, 62 insertions(+), 46 deletions(-)

diff --git a/drivers/ide/ide-atapi.c b/drivers/ide/ide-atapi.c
index fa09789..43a2337 100644
--- a/drivers/ide/ide-atapi.c
+++ b/drivers/ide/ide-atapi.c
@@ -80,40 +80,6 @@ void ide_init_pc(struct ide_atapi_pc *pc)
 EXPORT_SYMBOL_GPL(ide_init_pc);
 
 /*
- * Generate a new packet command request in front of the request queue, before
- * the current request, so that it will be processed immediately, on the next
- * pass through the driver.
- */
-static void ide_queue_pc_head(ide_drive_t *drive, struct gendisk *disk,
-			      struct ide_atapi_pc *pc, struct request *rq,
-			      struct bio *bio, struct bio_vec *bvec,
-			      unsigned short bvec_len)
-{
-	blk_rq_init(NULL, rq);
-	rq->cmd_type = REQ_TYPE_SPECIAL;
-	rq->cmd_flags |= REQ_PREEMPT;
-	rq->special = (char *)pc;
-	rq->rq_disk = disk;
-
-	if (pc->req_xfer) {
-		int error;
-
-		error = blk_rq_map_kern_prealloc(drive->queue, rq, bio,
-						 bvec, bvec_len,
-						 pc->buf, pc->req_xfer, true);
-		BUG_ON(error);
-	}
-
-	memcpy(rq->cmd, pc->c, 12);
-	if (drive->media == ide_tape)
-		rq->cmd[13] = REQ_IDETAPE_PC1;
-
-	drive->hwif->rq = NULL;
-
-	elv_add_request(drive->queue, rq, ELEVATOR_INSERT_FRONT, 0);
-}
-
-/*
  * Add a special packet command request to the tail of the request queue,
  * and wait for it to be serviced.
  */
@@ -237,22 +203,29 @@ void ide_queue_sense_rq(ide_drive_t *drive)
 EXPORT_SYMBOL_GPL(ide_queue_sense_rq);
 
 /*
- * Called when an error was detected during the last packet command.
- * We queue a request sense packet command in the head of the request list.
+ * Called when an error was detected during the last packet command. We queue a
+ * request sense packet command at the head of the request queue.
  */
 void ide_retry_pc(ide_drive_t *drive, struct gendisk *disk)
 {
-	struct request *rq = &drive->request_sense_rq;
-	struct bio *bio = &drive->request_sense_bio;
-	struct bio_vec *bvec = drive->request_sense_bvec;
 	struct ide_atapi_pc *pc = &drive->request_sense_pc;
-	unsigned short bvec_len = ARRAY_SIZE(drive->request_sense_bvec);
 
 	(void)ide_read_error(drive);
 	ide_create_request_sense_cmd(drive, pc);
 	if (drive->media == ide_tape)
 		set_bit(IDE_AFLAG_IGNORE_DSC, &drive->atapi_flags);
-	ide_queue_pc_head(drive, disk, pc, rq, bio, bvec, bvec_len);
+
+	drive->sense_rq->special = (char *)pc;
+	drive->sense_rq->rq_disk = disk;
+
+	/* FIXME: sense_len == sizeof(struct request_sense) */
+	memcpy(drive->sense_rq->cmd, pc->c, 12);
+	drive->sense_rq->sense_len = pc->req_xfer;
+
+	if (drive->media == ide_tape)
+		drive->sense_rq->cmd[13] = REQ_IDETAPE_PC1;
+
+	ide_queue_sense_rq(drive);
 }
 EXPORT_SYMBOL_GPL(ide_retry_pc);
 
@@ -425,6 +398,10 @@ static ide_startstop_t ide_pc_intr(ide_drive_t *drive)
 			error = uptodate ? 0 : -EIO;
 		}
 
+		/* prepare request sense if it got used with the last rq */
+		if (blk_sense_request(rq))
+			drive->sense_rq = NULL;
+
 		ide_complete_rq(drive, error, done);
 		return ide_stopped;
 	}
diff --git a/drivers/ide/ide-floppy.c b/drivers/ide/ide-floppy.c
index 9460033..7d2b219 100644
--- a/drivers/ide/ide-floppy.c
+++ b/drivers/ide/ide-floppy.c
@@ -263,7 +263,7 @@ static ide_startstop_t ide_floppy_do_request(ide_drive_t *drive,
 		}
 		pc = &floppy->queued_pc;
 		idefloppy_create_rw_cmd(drive, pc, rq, (unsigned long)block);
-	} else if (blk_special_request(rq)) {
+	} else if (blk_special_request(rq) || blk_sense_request(rq)) {
 		pc = (struct ide_atapi_pc *)rq->special;
 	} else if (blk_pc_request(rq)) {
 		pc = &floppy->queued_pc;
@@ -273,6 +273,23 @@ static ide_startstop_t ide_floppy_do_request(ide_drive_t *drive,
 		goto out_end;
 	}
 
+	/* prepare request sense if it got used with the last rq */
+	if (!drive->sense_rq) {
+		drive->sense_rq = ide_prep_sense(drive, floppy->disk);
+		if (!drive->sense_rq) {
+			printk(KERN_ERR "%s: error prepping sense request!\n",
+					drive->name);
+			return ide_stopped;
+		}
+	}
+
+	/*
+	 * save the current request in case we'll be queueing a sense rq
+	 * afterwards due to its potential failure.
+	 */
+	if (!blk_sense_request(rq))
+		drive->sense_rq->special = rq;
+
 	memset(&cmd, 0, sizeof(cmd));
 
 	if (rq_data_dir(rq))
diff --git a/drivers/ide/ide-gd.c b/drivers/ide/ide-gd.c
index 1aebdf1..811c002 100644
--- a/drivers/ide/ide-gd.c
+++ b/drivers/ide/ide-gd.c
@@ -82,6 +82,10 @@ static void ide_disk_release(struct device *dev)
 	struct gendisk *g = idkp->disk;
 
 	drive->disk_ops = NULL;
+
+	if (drive->sense_rq)
+		blk_put_request(drive->sense_rq);
+
 	drive->driver_data = NULL;
 	g->private_data = NULL;
 	put_disk(g);
diff --git a/drivers/ide/ide-tape.c b/drivers/ide/ide-tape.c
index d52f8b3..e26c9c7 100644
--- a/drivers/ide/ide-tape.c
+++ b/drivers/ide/ide-tape.c
@@ -758,7 +758,7 @@ static ide_startstop_t idetape_do_request(ide_drive_t *drive,
 			(unsigned long long)rq->sector, rq->nr_sectors,
 			rq->current_nr_sectors);
 
-	if (!blk_special_request(rq)) {
+	if (!(blk_special_request(rq) || blk_sense_request(rq))) {
 		/* We do not support buffer cache originated requests. */
 		printk(KERN_NOTICE "ide-tape: %s: Unsupported request in "
 			"request queue (%d)\n", drive->name, rq->cmd_type);
@@ -850,6 +850,23 @@ static ide_startstop_t idetape_do_request(ide_drive_t *drive,
 	BUG();
 
 out:
+	/* prepare request sense if it got used with the last rq */
+	if (!drive->sense_rq) {
+		drive->sense_rq = ide_prep_sense(drive, tape->disk);
+		if (!drive->sense_rq) {
+			printk(KERN_ERR "%s: error prepping sense request!\n",
+					drive->name);
+			return ide_stopped;
+		}
+	}
+
+	/*
+	 * save the current request in case we'll be queueing a sense rq
+	 * afterwards due to its potential failure.
+	 */
+	if (!blk_sense_request(rq))
+		drive->sense_rq->special = rq;
+
 	if (rq_data_dir(rq))
 		cmd.tf_flags |= IDE_TFLAG_WRITE;
 
@@ -2249,6 +2266,10 @@ static void ide_tape_release(struct device *dev)
 	BUG_ON(tape->merge_bh_size);
 
 	drive->dev_flags &= ~IDE_DFLAG_DSC_OVERLAP;
+
+	if (drive->sense_rq)
+		blk_put_request(drive->sense_rq);
+
 	drive->driver_data = NULL;
 	device_destroy(idetape_sysfs_class, MKDEV(IDETAPE_MAJOR, tape->minor));
 	device_destroy(idetape_sysfs_class,
diff --git a/include/linux/ide.h b/include/linux/ide.h
index 095cda2..2238e61 100644
--- a/include/linux/ide.h
+++ b/include/linux/ide.h
@@ -605,9 +605,6 @@ struct ide_drive_s {
 
 	/* for request sense */
 	struct ide_atapi_pc request_sense_pc;
-	struct request request_sense_rq;
-	struct bio request_sense_bio;
-	struct bio_vec request_sense_bvec[2];
 
 	/* current sense rq and buffer */
 	struct request *sense_rq;
-- 
1.6.2.2


-- 
Regards/Gruss,
    Boris.
