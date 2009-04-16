Return-Path: <linux-kernel-owner+w=401wt.eu-S1754860AbZDPFyM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754860AbZDPFyM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Apr 2009 01:54:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752856AbZDPFxy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Apr 2009 01:53:54 -0400
Received: from mail-fx0-f158.google.com ([209.85.220.158]:63248 "EHLO
	mail-fx0-f158.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754347AbZDPFxw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Apr 2009 01:53:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=date:from:to:subject:message-id:reply-to:mail-followup-to
         :references:mime-version:content-type:content-disposition
         :in-reply-to:user-agent;
        b=iTS1kBJr4OIYQAA7URsrxIBs3KsualHZI/xG9NxjqSdm1mTY+/ZXMSwhCWxgjfFVFW
         6KW53z3aGRVwsXER+YwHo0qMv5vITbEjWWDGW6SW3+gL3zfqRwyUm9HMD5kSIO3WfbR/
         2BvUOZncBV4SbX5deUAuQBdQQuVz/vfiH+074=
Date: Thu, 16 Apr 2009 07:53:47 +0200
From: Borislav Petkov <petkovbb@googlemail.com>
To: linux-kernel@vger.kernel.org
Subject: [PATCH 2/3] ide-cd: convert to using generic sense request
Message-ID: <20090416055347.GA21793@liondog.tnic>
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

Preallocate a sense request in the ->do_request method and reinitialize
it only on demand, in case it's been consumed in the IRQ handler path.
The reason for this is that we don't want to be mapping rq to bio in
the IRQ path and introduce all kinds of unnecessary hacks to the block
layer.

tj: * After this patch, ide_cd_do_request() might sleep.  This should
      be okay as ide request_fn - do_ide_request() - is invoked only
      from make_request and plug work.  Make sure this is the case by
      adding might_sleep() to do_ide_request().

    * Both user and kernel PC requests expect sense data to be stored
      in separate storage other than info->sense_data.  Copy sense
      data to rq->sense on completion if rq->sense is not NULL.  This
      fixes bogus sense data on PC requests.

As a result, remove cdrom_queue_request_sense.

CC: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
CC: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
CC: Tejun Heo <tj@kernel.org>
Signed-off-by: Borislav Petkov <petkovbb@gmail.com>
---
 drivers/ide/ide-atapi.c |    2 +
 drivers/ide/ide-cd.c    |   86 +++++++++++++++++++----------------------------
 drivers/ide/ide-io.c    |    3 ++
 3 files changed, 40 insertions(+), 51 deletions(-)

diff --git a/drivers/ide/ide-atapi.c b/drivers/ide/ide-atapi.c
index 1f4d20f..fa09789 100644
--- a/drivers/ide/ide-atapi.c
+++ b/drivers/ide/ide-atapi.c
@@ -229,6 +229,8 @@ EXPORT_SYMBOL_GPL(ide_prep_sense);
 
 void ide_queue_sense_rq(ide_drive_t *drive)
 {
+	drive->hwif->rq = NULL;
+
 	BUG_ON(!drive->sense_rq);
 	elv_add_request(drive->queue, drive->sense_rq, ELEVATOR_INSERT_FRONT, 0);
 }
diff --git a/drivers/ide/ide-cd.c b/drivers/ide/ide-cd.c
index 35d0973..0a50c77 100644
--- a/drivers/ide/ide-cd.c
+++ b/drivers/ide/ide-cd.c
@@ -206,53 +206,6 @@ static void cdrom_analyze_sense_data(ide_drive_t *drive,
 	ide_cd_log_error(drive->name, failed_command, sense);
 }
 
-static void cdrom_queue_request_sense(ide_drive_t *drive, void *sense,
-				      struct request *failed_command)
-{
-	struct cdrom_info *info	= drive->driver_data;
-	struct request *rq	= &drive->request_sense_rq;
-	struct bio *bio		= &drive->request_sense_bio;
-	struct bio_vec *bvec	= drive->request_sense_bvec;
-	unsigned int bvec_len	= ARRAY_SIZE(drive->request_sense_bvec);
-	unsigned sense_len	= 18;
-	int error;
-
-	ide_debug_log(IDE_DBG_SENSE, "enter");
-
-	if (sense == NULL) {
-		sense = &info->sense_data;
-		sense_len = sizeof(struct request_sense);
-	}
-
-	memset(sense, 0, sense_len);
-
-	/* stuff the sense request in front of our current request */
-	blk_rq_init(NULL, rq);
-
-	error = blk_rq_map_kern_prealloc(drive->queue, rq, bio, bvec, bvec_len,
-					 sense, sense_len, true);
-	BUG_ON(error);
-
-	rq->rq_disk = info->disk;
-
-	rq->cmd[0] = GPCMD_REQUEST_SENSE;
-	rq->cmd[4] = sense_len;
-
-	rq->cmd_type = REQ_TYPE_SENSE;
-	rq->cmd_flags |= REQ_PREEMPT;
-
-	/* NOTE! Save the failed command in "rq->special" */
-	rq->special = (void *)failed_command;
-
-	if (failed_command)
-		ide_debug_log(IDE_DBG_SENSE, "failed_cmd: 0x%x",
-					     failed_command->cmd[0]);
-
-	drive->hwif->rq = NULL;
-
-	elv_add_request(drive->queue, rq, ELEVATOR_INSERT_FRONT, 0);
-}
-
 static void ide_cd_complete_failed_rq(ide_drive_t *drive, struct request *rq)
 {
 	/*
@@ -260,11 +213,16 @@ static void ide_cd_complete_failed_rq(ide_drive_t *drive, struct request *rq)
 	 * failed request
 	 */
 	struct request *failed = (struct request *)rq->special;
-	struct cdrom_info *info = drive->driver_data;
-	void *sense = &info->sense_data;
+	struct request_sense *sense = &drive->sense_data;
 
 	if (failed) {
 		if (failed->sense) {
+			/*
+			 * Sense is always read into info->sense_data.
+			 * Copy back if the failed request has its
+			 * sense pointer set.
+			 */
+			memcpy(failed->sense, sense, sizeof(*sense));
 			sense = failed->sense;
 			failed->sense_len = rq->sense_len;
 		}
@@ -440,7 +398,7 @@ static int cdrom_decode_status(ide_drive_t *drive, u8 stat)
 
 	/* if we got a CHECK_CONDITION status, queue a request sense command */
 	if (stat & ATA_ERR)
-		cdrom_queue_request_sense(drive, NULL, NULL);
+		ide_queue_sense_rq(drive);
 	return 1;
 
 end_request:
@@ -454,7 +412,7 @@ end_request:
 
 		hwif->rq = NULL;
 
-		cdrom_queue_request_sense(drive, rq->sense, rq);
+		ide_queue_sense_rq(drive);
 		return 1;
 	} else
 		return 2;
@@ -788,6 +746,10 @@ out_end:
 
 		ide_complete_rq(drive, uptodate ? 0 : -EIO, nsectors << 9);
 
+		/* our sense buffer got used, reset it the next time around. */
+		if (sense)
+			drive->sense_rq = NULL;
+
 		if (sense && rc == 2)
 			ide_error(drive, "request sense failure", stat);
 	}
@@ -872,6 +834,7 @@ static void cdrom_do_block_pc(ide_drive_t *drive, struct request *rq)
 static ide_startstop_t ide_cd_do_request(ide_drive_t *drive, struct request *rq,
 					sector_t block)
 {
+	struct cdrom_info *info = drive->driver_data;
 	struct ide_cmd cmd;
 	int uptodate = 0, nsectors;
 
@@ -901,6 +864,23 @@ static ide_startstop_t ide_cd_do_request(ide_drive_t *drive, struct request *rq,
 		goto out_end;
 	}
 
+	/* prepare request sense if it got used with the last rq */
+	if (!drive->sense_rq) {
+		drive->sense_rq = ide_prep_sense(drive, info->disk);
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
@@ -1644,6 +1624,10 @@ static void ide_cd_release(struct device *dev)
 	kfree(info->toc);
 	if (devinfo->handle == drive)
 		unregister_cdrom(devinfo);
+
+	if (drive->sense_rq)
+		blk_put_request(drive->sense_rq);
+
 	drive->driver_data = NULL;
 	blk_queue_prep_rq(drive->queue, NULL);
 	g->private_data = NULL;
diff --git a/drivers/ide/ide-io.c b/drivers/ide/ide-io.c
index 492699d..a4625e1 100644
--- a/drivers/ide/ide-io.c
+++ b/drivers/ide/ide-io.c
@@ -478,6 +478,9 @@ void do_ide_request(struct request_queue *q)
 
 	spin_unlock_irq(q->queue_lock);
 
+	/* HLD do_request() callback might sleep, make sure it's okay */
+	might_sleep();
+
 	if (ide_lock_host(host, hwif))
 		goto plug_device_2;
 
-- 
1.6.2.2


-- 
Regards/Gruss,
    Boris.
