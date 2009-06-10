Return-Path: <linux-kernel-owner+w=401wt.eu-S1759493AbZFJVa4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759493AbZFJVa4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jun 2009 17:30:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754882AbZFJVap
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Jun 2009 17:30:45 -0400
Received: from mail-ew0-f210.google.com ([209.85.219.210]:40141 "EHLO
	mail-ew0-f210.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753470AbZFJVal (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jun 2009 17:30:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:user-agent:cc:mime-version:content-disposition:date
         :message-id:content-type:content-transfer-encoding;
        b=jjJq7VqQ6QrwflMriwGIllDb8LHTXppUI/gyZIFTWhRFcmVQwog6ZjKmCEbGj/O6ab
         hm/ep+bJQYGr9L7NnGFPdFbMUOX87T9heiOcSUbNOYFYH6a5GxuvoFzAPzZ0Ae8Duf1w
         SfFTHiRzRHEY+zn3ZSWR+fItNdOzZQ/MBfTUY=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: [git pull] IDE updates part 1
User-Agent: KMail/1.9.9
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Stephen Rothwell <sfr@canb.auug.org.au>, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Disposition: inline
Date: Wed, 10 Jun 2009 23:35:14 +0200
Message-Id: <200906102335.14917.bzolnier@gmail.com>
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi,

Mostly fixes/cleanups for ATAPI support from Tejun and Borislav
(block layer change has been acked by Jens).


Linus, please pull from 'for-2.6.31' branch of:

master.kernel.org:/pub/scm/linux/kernel/git/bart/ide-2.6.git for-2.6.31

to receive the following updates:

 block/blk-core.c           |   10 +-
 drivers/ide/alim15x3.c     |   10 +-
 drivers/ide/ide-atapi.c    |  168 +++++++----
 drivers/ide/ide-cd.c       |   88 ++----
 drivers/ide/ide-cd.h       |    4 -
 drivers/ide/ide-disk.c     |    1 -
 drivers/ide/ide-dma.c      |   20 +-
 drivers/ide/ide-floppy.c   |   24 +-
 drivers/ide/ide-io.c       |   14 +-
 drivers/ide/ide-ioctls.c   |    1 -
 drivers/ide/ide-park.c     |    7 +-
 drivers/ide/ide-pm.c       |   38 +--
 drivers/ide/ide-tape.c     |  734 ++++++++++----------------------------------
 drivers/ide/ide-taskfile.c |   18 +-
 include/linux/ide.h        |   27 +-
 15 files changed, 369 insertions(+), 795 deletions(-)


Anton Vorontsov (1):
      alim15x3: Remove historical hacks, re-enable init_hwif for PowerPC

Bartlomiej Zolnierkiewicz (5):
      Merge branch 'for-linus' into for-next
      Merge branch 'for-linus' into for-next
      Merge branch 'for-linus' into for-next
      Merge branch 'for-linus' into for-next
      Merge branch 'for-2.6.31' into 2.6.30

Borislav Petkov (3):
      ide: add helpers for preparing sense requests
      ide-cd: convert to using generic sense request
      ide-atapi: convert ide-{floppy,tape} to using preallocated sense buffer

Mark de Wever (1):
      ide-tape: fix debug call

Tejun Heo (23):
      block: clear req->errors on bio completion only for fs requests
      ide-tape: remove back-to-back REQUEST_SENSE detection
      ide: use blk_run_queue() instead of blk_start_queueing()
      ide: don't set REQ_SOFTBARRIER
      ide kill unused ide_cmd->special
      ide-cd: clear sense buffer before issuing request sense
      ide-floppy: block pc always uses bio
      ide-taskfile: don't abuse rq->buffer
      ide-atapi: don't abuse rq->buffer
      ide-cd: don't abuse rq->buffer
      ide-cd,atapi: use bio for internal commands
      ide-pm: don't abuse rq->data
      ide-tape,floppy: fix failed command completion after request sense
      ide-atapi,tape,floppy: allow ->pc_callback() to change rq->data_len
      ide-tape: use single continuous buffer
      ide-tape: use standard data transfer mechanism
      ide-tape: kill idetape_bh
      ide-tape: unify r/w init paths
      ide-tape: use byte size instead of sectors on rw issue functions
      ide-tape: simplify read/write functions
      ide-atapi: kill unused fields and callbacks
      ide: drop rq->data handling from ide_map_sg()
      ide-dma: don't reset request fields on dma_timeout_retry()


diff --git a/block/blk-core.c b/block/blk-core.c
index c89883b..4bc34b6 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -1741,10 +1741,14 @@ static int __end_that_request_first(struct request *req, int error,
 	trace_block_rq_complete(req->q, req);
 
 	/*
-	 * for a REQ_TYPE_BLOCK_PC request, we want to carry any eventual
-	 * sense key with us all the way through
+	 * For fs requests, rq is just carrier of independent bio's
+	 * and each partial completion should be handled separately.
+	 * Reset per-request error on each partial completion.
+	 *
+	 * TODO: tj: This is too subtle.  It would be better to let
+	 * low level drivers do what they see fit.
 	 */
-	if (!blk_pc_request(req))
+	if (blk_fs_request(req))
 		req->errors = 0;
 
 	if (error && (blk_fs_request(req) && !(req->cmd_flags & REQ_QUIET))) {
diff --git a/drivers/ide/alim15x3.c b/drivers/ide/alim15x3.c
index 537da1c..e59b6de 100644
--- a/drivers/ide/alim15x3.c
+++ b/drivers/ide/alim15x3.c
@@ -402,27 +402,23 @@ static u8 ali_cable_detect(ide_hwif_t *hwif)
 	return cbl;
 }
 
-#if !defined(CONFIG_SPARC64) && !defined(CONFIG_PPC)
+#ifndef CONFIG_SPARC64
 /**
  *	init_hwif_ali15x3	-	Initialize the ALI IDE x86 stuff
  *	@hwif: interface to configure
  *
  *	Obtain the IRQ tables for an ALi based IDE solution on the PC
  *	class platforms. This part of the code isn't applicable to the
- *	Sparc and PowerPC systems.
+ *	Sparc systems.
  */
 
 static void __devinit init_hwif_ali15x3 (ide_hwif_t *hwif)
 {
-	struct pci_dev *dev = to_pci_dev(hwif->dev);
 	u8 ideic, inmir;
 	s8 irq_routing_table[] = { -1,  9, 3, 10, 4,  5, 7,  6,
 				      1, 11, 0, 12, 0, 14, 0, 15 };
 	int irq = -1;
 
-	if (dev->device == PCI_DEVICE_ID_AL_M5229)
-		hwif->irq = hwif->channel ? 15 : 14;
-
 	if (isa_dev) {
 		/*
 		 * read IDE interface control
@@ -455,7 +451,7 @@ static void __devinit init_hwif_ali15x3 (ide_hwif_t *hwif)
 }
 #else
 #define init_hwif_ali15x3 NULL
-#endif /* !defined(CONFIG_SPARC64) && !defined(CONFIG_PPC) */
+#endif /* CONFIG_SPARC64 */
 
 /**
  *	init_dma_ali15x3	-	set up DMA on ALi15x3
diff --git a/drivers/ide/ide-atapi.c b/drivers/ide/ide-atapi.c
index 7201b17..afe5a43 100644
--- a/drivers/ide/ide-atapi.c
+++ b/drivers/ide/ide-atapi.c
@@ -80,34 +80,6 @@ void ide_init_pc(struct ide_atapi_pc *pc)
 EXPORT_SYMBOL_GPL(ide_init_pc);
 
 /*
- * Generate a new packet command request in front of the request queue, before
- * the current request, so that it will be processed immediately, on the next
- * pass through the driver.
- */
-static void ide_queue_pc_head(ide_drive_t *drive, struct gendisk *disk,
-			      struct ide_atapi_pc *pc, struct request *rq)
-{
-	blk_rq_init(NULL, rq);
-	rq->cmd_type = REQ_TYPE_SPECIAL;
-	rq->cmd_flags |= REQ_PREEMPT;
-	rq->buffer = (char *)pc;
-	rq->rq_disk = disk;
-
-	if (pc->req_xfer) {
-		rq->data = pc->buf;
-		rq->data_len = pc->req_xfer;
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
@@ -119,19 +91,21 @@ int ide_queue_pc_tail(ide_drive_t *drive, struct gendisk *disk,
 
 	rq = blk_get_request(drive->queue, READ, __GFP_WAIT);
 	rq->cmd_type = REQ_TYPE_SPECIAL;
-	rq->buffer = (char *)pc;
+	rq->special = (char *)pc;
 
 	if (pc->req_xfer) {
-		rq->data = pc->buf;
-		rq->data_len = pc->req_xfer;
+		error = blk_rq_map_kern(drive->queue, rq, pc->buf, pc->req_xfer,
+					GFP_NOIO);
+		if (error)
+			goto put_req;
 	}
 
 	memcpy(rq->cmd, pc->c, 12);
 	if (drive->media == ide_tape)
 		rq->cmd[13] = REQ_IDETAPE_PC1;
 	error = blk_execute_rq(drive->queue, disk, rq, 0);
+put_req:
 	blk_put_request(rq);
-
 	return error;
 }
 EXPORT_SYMBOL_GPL(ide_queue_pc_tail);
@@ -191,20 +165,103 @@ void ide_create_request_sense_cmd(ide_drive_t *drive, struct ide_atapi_pc *pc)
 }
 EXPORT_SYMBOL_GPL(ide_create_request_sense_cmd);
 
+void ide_prep_sense(ide_drive_t *drive, struct request *rq)
+{
+	struct request_sense *sense = &drive->sense_data;
+	struct request *sense_rq = &drive->sense_rq;
+	unsigned int cmd_len, sense_len;
+	int err;
+
+	debug_log("%s: enter\n", __func__);
+
+	switch (drive->media) {
+	case ide_floppy:
+		cmd_len = 255;
+		sense_len = 18;
+		break;
+	case ide_tape:
+		cmd_len = 20;
+		sense_len = 20;
+		break;
+	default:
+		cmd_len = 18;
+		sense_len = 18;
+	}
+
+	BUG_ON(sense_len > sizeof(*sense));
+
+	if (blk_sense_request(rq) || drive->sense_rq_armed)
+		return;
+
+	memset(sense, 0, sizeof(*sense));
+
+	blk_rq_init(rq->q, sense_rq);
+
+	err = blk_rq_map_kern(drive->queue, sense_rq, sense, sense_len,
+			      GFP_NOIO);
+	if (unlikely(err)) {
+		if (printk_ratelimit())
+			printk(KERN_WARNING "%s: failed to map sense buffer\n",
+			       drive->name);
+		return;
+	}
+
+	sense_rq->rq_disk = rq->rq_disk;
+	sense_rq->cmd[0] = GPCMD_REQUEST_SENSE;
+	sense_rq->cmd[4] = cmd_len;
+	sense_rq->cmd_type = REQ_TYPE_SENSE;
+	sense_rq->cmd_flags |= REQ_PREEMPT;
+
+	if (drive->media == ide_tape)
+		sense_rq->cmd[13] = REQ_IDETAPE_PC1;
+
+	drive->sense_rq_armed = true;
+}
+EXPORT_SYMBOL_GPL(ide_prep_sense);
+
+int ide_queue_sense_rq(ide_drive_t *drive, void *special)
+{
+	/* deferred failure from ide_prep_sense() */
+	if (!drive->sense_rq_armed) {
+		printk(KERN_WARNING "%s: failed queue sense request\n",
+		       drive->name);
+		return -ENOMEM;
+	}
+
+	drive->sense_rq.special = special;
+	drive->sense_rq_armed = false;
+
+	drive->hwif->rq = NULL;
+
+	elv_add_request(drive->queue, &drive->sense_rq,
+			ELEVATOR_INSERT_FRONT, 0);
+	return 0;
+}
+EXPORT_SYMBOL_GPL(ide_queue_sense_rq);
+
 /*
  * Called when an error was detected during the last packet command.
- * We queue a request sense packet command in the head of the request list.
+ * We queue a request sense packet command at the head of the request
+ * queue.
  */
-void ide_retry_pc(ide_drive_t *drive, struct gendisk *disk)
+void ide_retry_pc(ide_drive_t *drive)
 {
-	struct request *rq = &drive->request_sense_rq;
+	struct request *sense_rq = &drive->sense_rq;
 	struct ide_atapi_pc *pc = &drive->request_sense_pc;
 
 	(void)ide_read_error(drive);
-	ide_create_request_sense_cmd(drive, pc);
+
+	/* init pc from sense_rq */
+	ide_init_pc(pc);
+	memcpy(pc->c, sense_rq->cmd, 12);
+	pc->buf = bio_data(sense_rq->bio);	/* pointer to mapped address */
+	pc->req_xfer = sense_rq->data_len;
+
 	if (drive->media == ide_tape)
 		set_bit(IDE_AFLAG_IGNORE_DSC, &drive->atapi_flags);
-	ide_queue_pc_head(drive, disk, pc, rq);
+
+	if (ide_queue_sense_rq(drive, pc))
+		ide_complete_rq(drive, -EIO, blk_rq_bytes(drive->hwif->rq));
 }
 EXPORT_SYMBOL_GPL(ide_retry_pc);
 
@@ -276,7 +333,6 @@ static ide_startstop_t ide_pc_intr(ide_drive_t *drive)
 	struct ide_cmd *cmd = &hwif->cmd;
 	struct request *rq = hwif->rq;
 	const struct ide_tp_ops *tp_ops = hwif->tp_ops;
-	xfer_func_t *xferfunc;
 	unsigned int timeout, done;
 	u16 bcount;
 	u8 stat, ireason, dsc = 0;
@@ -303,11 +359,8 @@ static ide_startstop_t ide_pc_intr(ide_drive_t *drive)
 					drive->name, rq_data_dir(pc->rq)
 						     ? "write" : "read");
 			pc->flags |= PC_FLAG_DMA_ERROR;
-		} else {
+		} else
 			pc->xferred = pc->req_xfer;
-			if (drive->pc_update_buffers)
-				drive->pc_update_buffers(drive, pc);
-		}
 		debug_log("%s: DMA finished\n", drive->name);
 	}
 
@@ -343,7 +396,7 @@ static ide_startstop_t ide_pc_intr(ide_drive_t *drive)
 			debug_log("[cmd %x]: check condition\n", rq->cmd[0]);
 
 			/* Retry operation */
-			ide_retry_pc(drive, rq->rq_disk);
+			ide_retry_pc(drive);
 
 			/* queued, but not started */
 			return ide_stopped;
@@ -353,6 +406,12 @@ static ide_startstop_t ide_pc_intr(ide_drive_t *drive)
 		if ((pc->flags & PC_FLAG_WAIT_FOR_DSC) && (stat & ATA_DSC) == 0)
 			dsc = 1;
 
+		/*
+		 * ->pc_callback() might change rq->data_len for
+		 * residual count, cache total length.
+		 */
+		done = blk_rq_bytes(rq);
+
 		/* Command finished - Call the callback function */
 		uptodate = drive->pc_callback(drive, dsc);
 
@@ -361,7 +420,6 @@ static ide_startstop_t ide_pc_intr(ide_drive_t *drive)
 
 		if (blk_special_request(rq)) {
 			rq->errors = 0;
-			done = blk_rq_bytes(rq);
 			error = 0;
 		} else {
 
@@ -370,11 +428,6 @@ static ide_startstop_t ide_pc_intr(ide_drive_t *drive)
 					rq->errors = -EIO;
 			}
 
-			if (drive->media == ide_tape)
-				done = ide_rq_bytes(rq); /* FIXME */
-			else
-				done = blk_rq_bytes(rq);
-
 			error = uptodate ? 0 : -EIO;
 		}
 
@@ -407,21 +460,11 @@ static ide_startstop_t ide_pc_intr(ide_drive_t *drive)
 		return ide_do_reset(drive);
 	}
 
-	xferfunc = write ? tp_ops->output_data : tp_ops->input_data;
-
-	if (drive->media == ide_floppy && pc->buf == NULL) {
-		done = min_t(unsigned int, bcount, cmd->nleft);
-		ide_pio_bytes(drive, cmd, write, done);
-	} else if (drive->media == ide_tape && pc->bh) {
-		done = drive->pc_io_buffers(drive, pc, bcount, write);
-	} else {
-		done = min_t(unsigned int, bcount, pc->req_xfer - pc->xferred);
-		xferfunc(drive, NULL, pc->cur_pos, done);
-	}
+	done = min_t(unsigned int, bcount, cmd->nleft);
+	ide_pio_bytes(drive, cmd, write, done);
 
-	/* Update the current position */
+	/* Update transferred byte count */
 	pc->xferred += done;
-	pc->cur_pos += done;
 
 	bcount -= done;
 
@@ -599,7 +642,6 @@ ide_startstop_t ide_issue_pc(ide_drive_t *drive, struct ide_cmd *cmd)
 
 		/* We haven't transferred any data yet */
 		pc->xferred = 0;
-		pc->cur_pos = pc->buf;
 
 		valid_tf = IDE_VALID_DEVICE;
 		bcount = ((drive->media == ide_tape) ?
diff --git a/drivers/ide/ide-cd.c b/drivers/ide/ide-cd.c
index 925eb9e..a75e4ee 100644
--- a/drivers/ide/ide-cd.c
+++ b/drivers/ide/ide-cd.c
@@ -206,54 +206,25 @@ static void cdrom_analyze_sense_data(ide_drive_t *drive,
 	ide_cd_log_error(drive->name, failed_command, sense);
 }
 
-static void cdrom_queue_request_sense(ide_drive_t *drive, void *sense,
-				      struct request *failed_command)
-{
-	struct cdrom_info *info		= drive->driver_data;
-	struct request *rq		= &drive->request_sense_rq;
-
-	ide_debug_log(IDE_DBG_SENSE, "enter");
-
-	if (sense == NULL)
-		sense = &info->sense_data;
-
-	/* stuff the sense request in front of our current request */
-	blk_rq_init(NULL, rq);
-	rq->cmd_type = REQ_TYPE_ATA_PC;
-	rq->rq_disk = info->disk;
-
-	rq->data = sense;
-	rq->cmd[0] = GPCMD_REQUEST_SENSE;
-	rq->cmd[4] = 18;
-	rq->data_len = 18;
-
-	rq->cmd_type = REQ_TYPE_SENSE;
-	rq->cmd_flags |= REQ_PREEMPT;
-
-	/* NOTE! Save the failed command in "rq->buffer" */
-	rq->buffer = (void *) failed_command;
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
-	 * For REQ_TYPE_SENSE, "rq->buffer" points to the original
-	 * failed request
+	 * For REQ_TYPE_SENSE, "rq->special" points to the original
+	 * failed request.  Also, the sense data should be read
+	 * directly from rq which might be different from the original
+	 * sense buffer if it got copied during mapping.
 	 */
-	struct request *failed = (struct request *)rq->buffer;
-	struct cdrom_info *info = drive->driver_data;
-	void *sense = &info->sense_data;
+	struct request *failed = (struct request *)rq->special;
+	void *sense = bio_data(rq->bio);
 
 	if (failed) {
 		if (failed->sense) {
+			/*
+			 * Sense is always read into drive->sense_data.
+			 * Copy back if the failed request has its
+			 * sense pointer set.
+			 */
+			memcpy(failed->sense, sense, 18);
 			sense = failed->sense;
 			failed->sense_len = rq->sense_len;
 		}
@@ -428,7 +399,7 @@ static int cdrom_decode_status(ide_drive_t *drive, u8 stat)
 
 	/* if we got a CHECK_CONDITION status, queue a request sense command */
 	if (stat & ATA_ERR)
-		cdrom_queue_request_sense(drive, NULL, NULL);
+		return ide_queue_sense_rq(drive, NULL) ? 2 : 1;
 	return 1;
 
 end_request:
@@ -442,8 +413,7 @@ end_request:
 
 		hwif->rq = NULL;
 
-		cdrom_queue_request_sense(drive, rq->sense, rq);
-		return 1;
+		return ide_queue_sense_rq(drive, rq) ? 2 : 1;
 	} else
 		return 2;
 }
@@ -503,14 +473,8 @@ static void ide_cd_request_sense_fixup(ide_drive_t *drive, struct ide_cmd *cmd)
 	 * and some drives don't send them.  Sigh.
 	 */
 	if (rq->cmd[0] == GPCMD_REQUEST_SENSE &&
-	    cmd->nleft > 0 && cmd->nleft <= 5) {
-		unsigned int ofs = cmd->nbytes - cmd->nleft;
-
-		while (cmd->nleft > 0) {
-			*((u8 *)rq->data + ofs++) = 0;
-			cmd->nleft--;
-		}
-	}
+	    cmd->nleft > 0 && cmd->nleft <= 5)
+		cmd->nleft = 0;
 }
 
 int ide_cd_queue_pc(ide_drive_t *drive, const unsigned char *cmd,
@@ -543,8 +507,12 @@ int ide_cd_queue_pc(ide_drive_t *drive, const unsigned char *cmd,
 		rq->cmd_flags |= cmd_flags;
 		rq->timeout = timeout;
 		if (buffer) {
-			rq->data = buffer;
-			rq->data_len = *bufflen;
+			error = blk_rq_map_kern(drive->queue, rq, buffer,
+						*bufflen, GFP_NOIO);
+			if (error) {
+				blk_put_request(rq);
+				return error;
+			}
 		}
 
 		error = blk_execute_rq(drive->queue, info->disk, rq, 0);
@@ -838,15 +806,10 @@ static void cdrom_do_block_pc(ide_drive_t *drive, struct request *rq)
 	drive->dma = 0;
 
 	/* sg request */
-	if (rq->bio || ((rq->cmd_type == REQ_TYPE_ATA_PC) && rq->data_len)) {
+	if (rq->bio) {
 		struct request_queue *q = drive->queue;
+		char *buf = bio_data(rq->bio);
 		unsigned int alignment;
-		char *buf;
-
-		if (rq->bio)
-			buf = bio_data(rq->bio);
-		else
-			buf = rq->data;
 
 		drive->dma = !!(drive->dev_flags & IDE_DFLAG_USING_DMA);
 
@@ -896,6 +859,9 @@ static ide_startstop_t ide_cd_do_request(ide_drive_t *drive, struct request *rq,
 		goto out_end;
 	}
 
+	/* prepare sense request for this command */
+	ide_prep_sense(drive, rq);
+
 	memset(&cmd, 0, sizeof(cmd));
 
 	if (rq_data_dir(rq))
diff --git a/drivers/ide/ide-cd.h b/drivers/ide/ide-cd.h
index 1d97101..93a3cf1 100644
--- a/drivers/ide/ide-cd.h
+++ b/drivers/ide/ide-cd.h
@@ -87,10 +87,6 @@ struct cdrom_info {
 
 	struct atapi_toc *toc;
 
-	/* The result of the last successful request sense command
-	   on this device. */
-	struct request_sense sense_data;
-
 	u8 max_speed;		/* Max speed of the drive. */
 	u8 current_speed;	/* Current speed of the drive. */
 
diff --git a/drivers/ide/ide-disk.c b/drivers/ide/ide-disk.c
index a9fbe2c..c243880 100644
--- a/drivers/ide/ide-disk.c
+++ b/drivers/ide/ide-disk.c
@@ -411,7 +411,6 @@ static void idedisk_prepare_flush(struct request_queue *q, struct request *rq)
 	cmd->protocol = ATA_PROT_NODATA;
 
 	rq->cmd_type = REQ_TYPE_ATA_TASKFILE;
-	rq->cmd_flags |= REQ_SOFTBARRIER;
 	rq->special = cmd;
 }
 
diff --git a/drivers/ide/ide-dma.c b/drivers/ide/ide-dma.c
index a0b8cab..d9123ec 100644
--- a/drivers/ide/ide-dma.c
+++ b/drivers/ide/ide-dma.c
@@ -510,23 +510,11 @@ ide_startstop_t ide_dma_timeout_retry(ide_drive_t *drive, int error)
 	/*
 	 * un-busy drive etc and make sure request is sane
 	 */
-
 	rq = hwif->rq;
-	if (!rq)
-		goto out;
-
-	hwif->rq = NULL;
-
-	rq->errors = 0;
-
-	if (!rq->bio)
-		goto out;
-
-	rq->sector = rq->bio->bi_sector;
-	rq->current_nr_sectors = bio_iovec(rq->bio)->bv_len >> 9;
-	rq->hard_cur_sectors = rq->current_nr_sectors;
-	rq->buffer = bio_data(rq->bio);
-out:
+	if (rq) {
+		hwif->rq = NULL;
+		rq->errors = 0;
+	}
 	return ret;
 }
 
diff --git a/drivers/ide/ide-floppy.c b/drivers/ide/ide-floppy.c
index 2b4868d..537b7c5 100644
--- a/drivers/ide/ide-floppy.c
+++ b/drivers/ide/ide-floppy.c
@@ -134,13 +134,17 @@ static ide_startstop_t ide_floppy_issue_pc(ide_drive_t *drive,
 	drive->pc = pc;
 
 	if (pc->retries > IDEFLOPPY_MAX_PC_RETRIES) {
+		unsigned int done = blk_rq_bytes(drive->hwif->rq);
+
 		if (!(pc->flags & PC_FLAG_SUPPRESS_ERROR))
 			ide_floppy_report_error(floppy, pc);
+
 		/* Giving up */
 		pc->error = IDE_DRV_ERROR_GENERAL;
 
 		drive->failed_pc = NULL;
 		drive->pc_callback(drive, 0);
+		ide_complete_rq(drive, -EIO, done);
 		return ide_stopped;
 	}
 
@@ -216,15 +220,13 @@ static void idefloppy_blockpc_cmd(struct ide_disk_obj *floppy,
 	ide_init_pc(pc);
 	memcpy(pc->c, rq->cmd, sizeof(pc->c));
 	pc->rq = rq;
-	if (rq->data_len && rq_data_dir(rq) == WRITE)
-		pc->flags |= PC_FLAG_WRITING;
-	pc->buf = rq->data;
-	if (rq->bio)
+	if (rq->data_len) {
 		pc->flags |= PC_FLAG_DMA_OK;
-	/*
-	 * possibly problematic, doesn't look like ide-floppy correctly
-	 * handled scattered requests if dma fails...
-	 */
+		if (rq_data_dir(rq) == WRITE)
+			pc->flags |= PC_FLAG_WRITING;
+	}
+	/* pio will be performed by ide_pio_bytes() which handles sg fine */
+	pc->buf = NULL;
 	pc->req_xfer = pc->buf_size = rq->data_len;
 }
 
@@ -265,8 +267,8 @@ static ide_startstop_t ide_floppy_do_request(ide_drive_t *drive,
 		}
 		pc = &floppy->queued_pc;
 		idefloppy_create_rw_cmd(drive, pc, rq, (unsigned long)block);
-	} else if (blk_special_request(rq)) {
-		pc = (struct ide_atapi_pc *) rq->buffer;
+	} else if (blk_special_request(rq) || blk_sense_request(rq)) {
+		pc = (struct ide_atapi_pc *)rq->special;
 	} else if (blk_pc_request(rq)) {
 		pc = &floppy->queued_pc;
 		idefloppy_blockpc_cmd(floppy, pc, rq);
@@ -275,6 +277,8 @@ static ide_startstop_t ide_floppy_do_request(ide_drive_t *drive,
 		goto out_end;
 	}
 
+	ide_prep_sense(drive, rq);
+
 	memset(&cmd, 0, sizeof(cmd));
 
 	if (rq_data_dir(rq))
diff --git a/drivers/ide/ide-io.c b/drivers/ide/ide-io.c
index 6415a2e..41d8040 100644
--- a/drivers/ide/ide-io.c
+++ b/drivers/ide/ide-io.c
@@ -248,14 +248,7 @@ void ide_map_sg(ide_drive_t *drive, struct ide_cmd *cmd)
 	struct scatterlist *sg = hwif->sg_table;
 	struct request *rq = cmd->rq;
 
-	if (rq->cmd_type == REQ_TYPE_ATA_TASKFILE) {
-		sg_init_one(sg, rq->buffer, rq->nr_sectors * SECTOR_SIZE);
-		cmd->sg_nents = 1;
-	} else if (!rq->bio) {
-		sg_init_one(sg, rq->data, rq->data_len);
-		cmd->sg_nents = 1;
-	} else
-		cmd->sg_nents = blk_rq_map_sg(drive->queue, rq, sg);
+	cmd->sg_nents = blk_rq_map_sg(drive->queue, rq, sg);
 }
 EXPORT_SYMBOL_GPL(ide_map_sg);
 
@@ -371,7 +364,7 @@ static ide_startstop_t start_request (ide_drive_t *drive, struct request *rq)
 		if (rq->cmd_type == REQ_TYPE_ATA_TASKFILE)
 			return execute_drive_cmd(drive, rq);
 		else if (blk_pm_request(rq)) {
-			struct request_pm_state *pm = rq->data;
+			struct request_pm_state *pm = rq->special;
 #ifdef DEBUG_PM
 			printk("%s: start_power_step(step: %d)\n",
 				drive->name, pm->pm_step);
@@ -484,6 +477,9 @@ void do_ide_request(struct request_queue *q)
 
 	spin_unlock_irq(q->queue_lock);
 
+	/* HLD do_request() callback might sleep, make sure it's okay */
+	might_sleep();
+
 	if (ide_lock_host(host, hwif))
 		goto plug_device_2;
 
diff --git a/drivers/ide/ide-ioctls.c b/drivers/ide/ide-ioctls.c
index c1c25eb..5991b23 100644
--- a/drivers/ide/ide-ioctls.c
+++ b/drivers/ide/ide-ioctls.c
@@ -231,7 +231,6 @@ static int generic_drive_reset(ide_drive_t *drive)
 	rq->cmd_type = REQ_TYPE_SPECIAL;
 	rq->cmd_len = 1;
 	rq->cmd[0] = REQ_DRIVE_RESET;
-	rq->cmd_flags |= REQ_SOFTBARRIER;
 	if (blk_execute_rq(drive->queue, NULL, rq, 1))
 		ret = rq->errors;
 	blk_put_request(rq);
diff --git a/drivers/ide/ide-park.c b/drivers/ide/ide-park.c
index 310d03f..a914023 100644
--- a/drivers/ide/ide-park.c
+++ b/drivers/ide/ide-park.c
@@ -24,11 +24,8 @@ static void issue_park_cmd(ide_drive_t *drive, unsigned long timeout)
 			start_queue = 1;
 		spin_unlock_irq(&hwif->lock);
 
-		if (start_queue) {
-			spin_lock_irq(q->queue_lock);
-			blk_start_queueing(q);
-			spin_unlock_irq(q->queue_lock);
-		}
+		if (start_queue)
+			blk_run_queue(q);
 		return;
 	}
 	spin_unlock_irq(&hwif->lock);
diff --git a/drivers/ide/ide-pm.c b/drivers/ide/ide-pm.c
index 0d8a151..ba1488b 100644
--- a/drivers/ide/ide-pm.c
+++ b/drivers/ide/ide-pm.c
@@ -7,7 +7,6 @@ int generic_ide_suspend(struct device *dev, pm_message_t mesg)
 	ide_hwif_t *hwif = drive->hwif;
 	struct request *rq;
 	struct request_pm_state rqpm;
-	struct ide_cmd cmd;
 	int ret;
 
 	/* call ACPI _GTM only once */
@@ -15,11 +14,9 @@ int generic_ide_suspend(struct device *dev, pm_message_t mesg)
 		ide_acpi_get_timing(hwif);
 
 	memset(&rqpm, 0, sizeof(rqpm));
-	memset(&cmd, 0, sizeof(cmd));
 	rq = blk_get_request(drive->queue, READ, __GFP_WAIT);
 	rq->cmd_type = REQ_TYPE_PM_SUSPEND;
-	rq->special = &cmd;
-	rq->data = &rqpm;
+	rq->special = &rqpm;
 	rqpm.pm_step = IDE_PM_START_SUSPEND;
 	if (mesg.event == PM_EVENT_PRETHAW)
 		mesg.event = PM_EVENT_FREEZE;
@@ -41,7 +38,6 @@ int generic_ide_resume(struct device *dev)
 	ide_hwif_t *hwif = drive->hwif;
 	struct request *rq;
 	struct request_pm_state rqpm;
-	struct ide_cmd cmd;
 	int err;
 
 	/* call ACPI _PS0 / _STM only once */
@@ -53,12 +49,10 @@ int generic_ide_resume(struct device *dev)
 	ide_acpi_exec_tfs(drive);
 
 	memset(&rqpm, 0, sizeof(rqpm));
-	memset(&cmd, 0, sizeof(cmd));
 	rq = blk_get_request(drive->queue, READ, __GFP_WAIT);
 	rq->cmd_type = REQ_TYPE_PM_RESUME;
 	rq->cmd_flags |= REQ_PREEMPT;
-	rq->special = &cmd;
-	rq->data = &rqpm;
+	rq->special = &rqpm;
 	rqpm.pm_step = IDE_PM_START_RESUME;
 	rqpm.pm_state = PM_EVENT_ON;
 
@@ -77,7 +71,7 @@ int generic_ide_resume(struct device *dev)
 
 void ide_complete_power_step(ide_drive_t *drive, struct request *rq)
 {
-	struct request_pm_state *pm = rq->data;
+	struct request_pm_state *pm = rq->special;
 
 #ifdef DEBUG_PM
 	printk(KERN_INFO "%s: complete_power_step(step: %d)\n",
@@ -107,10 +101,8 @@ void ide_complete_power_step(ide_drive_t *drive, struct request *rq)
 
 ide_startstop_t ide_start_power_step(ide_drive_t *drive, struct request *rq)
 {
-	struct request_pm_state *pm = rq->data;
-	struct ide_cmd *cmd = rq->special;
-
-	memset(cmd, 0, sizeof(*cmd));
+	struct request_pm_state *pm = rq->special;
+	struct ide_cmd cmd = { };
 
 	switch (pm->pm_step) {
 	case IDE_PM_FLUSH_CACHE:	/* Suspend step 1 (flush cache) */
@@ -123,12 +115,12 @@ ide_startstop_t ide_start_power_step(ide_drive_t *drive, struct request *rq)
 			return ide_stopped;
 		}
 		if (ata_id_flush_ext_enabled(drive->id))
-			cmd->tf.command = ATA_CMD_FLUSH_EXT;
+			cmd.tf.command = ATA_CMD_FLUSH_EXT;
 		else
-			cmd->tf.command = ATA_CMD_FLUSH;
+			cmd.tf.command = ATA_CMD_FLUSH;
 		goto out_do_tf;
 	case IDE_PM_STANDBY:		/* Suspend step 2 (standby) */
-		cmd->tf.command = ATA_CMD_STANDBYNOW1;
+		cmd.tf.command = ATA_CMD_STANDBYNOW1;
 		goto out_do_tf;
 	case IDE_PM_RESTORE_PIO:	/* Resume step 1 (restore PIO) */
 		ide_set_max_pio(drive);
@@ -141,7 +133,7 @@ ide_startstop_t ide_start_power_step(ide_drive_t *drive, struct request *rq)
 			ide_complete_power_step(drive, rq);
 		return ide_stopped;
 	case IDE_PM_IDLE:		/* Resume step 2 (idle) */
-		cmd->tf.command = ATA_CMD_IDLEIMMEDIATE;
+		cmd.tf.command = ATA_CMD_IDLEIMMEDIATE;
 		goto out_do_tf;
 	case IDE_PM_RESTORE_DMA:	/* Resume step 3 (restore DMA) */
 		/*
@@ -163,11 +155,11 @@ ide_startstop_t ide_start_power_step(ide_drive_t *drive, struct request *rq)
 	return ide_stopped;
 
 out_do_tf:
-	cmd->valid.out.tf = IDE_VALID_OUT_TF | IDE_VALID_DEVICE;
-	cmd->valid.in.tf  = IDE_VALID_IN_TF  | IDE_VALID_DEVICE;
-	cmd->protocol = ATA_PROT_NODATA;
+	cmd.valid.out.tf = IDE_VALID_OUT_TF | IDE_VALID_DEVICE;
+	cmd.valid.in.tf  = IDE_VALID_IN_TF  | IDE_VALID_DEVICE;
+	cmd.protocol = ATA_PROT_NODATA;
 
-	return do_rw_taskfile(drive, cmd);
+	return do_rw_taskfile(drive, &cmd);
 }
 
 /**
@@ -181,7 +173,7 @@ out_do_tf:
 void ide_complete_pm_rq(ide_drive_t *drive, struct request *rq)
 {
 	struct request_queue *q = drive->queue;
-	struct request_pm_state *pm = rq->data;
+	struct request_pm_state *pm = rq->special;
 	unsigned long flags;
 
 	ide_complete_power_step(drive, rq);
@@ -207,7 +199,7 @@ void ide_complete_pm_rq(ide_drive_t *drive, struct request *rq)
 
 void ide_check_pm_state(ide_drive_t *drive, struct request *rq)
 {
-	struct request_pm_state *pm = rq->data;
+	struct request_pm_state *pm = rq->special;
 
 	if (blk_pm_suspend_request(rq) &&
 	    pm->pm_step == IDE_PM_START_SUSPEND)
diff --git a/drivers/ide/ide-tape.c b/drivers/ide/ide-tape.c
index 3a53e08..203bbea 100644
--- a/drivers/ide/ide-tape.c
+++ b/drivers/ide/ide-tape.c
@@ -131,13 +131,6 @@ enum {
 	IDETAPE_DIR_WRITE = (1 << 2),
 };
 
-struct idetape_bh {
-	u32 b_size;
-	atomic_t b_count;
-	struct idetape_bh *b_reqnext;
-	char *b_data;
-};
-
 /* Tape door status */
 #define DOOR_UNLOCKED			0
 #define DOOR_LOCKED			1
@@ -219,18 +212,12 @@ typedef struct ide_tape_obj {
 
 	/* Data buffer size chosen based on the tape's recommendation */
 	int buffer_size;
-	/* merge buffer */
-	struct idetape_bh *merge_bh;
-	/* size of the merge buffer */
-	int merge_bh_size;
-	/* pointer to current buffer head within the merge buffer */
-	struct idetape_bh *bh;
-	char *b_data;
-	int b_count;
-
-	int pages_per_buffer;
-	/* Wasted space in each stage */
-	int excess_bh_size;
+	/* Staging buffer of buffer_size bytes */
+	void *buf;
+	/* The read/write cursor */
+	void *cur;
+	/* The number of valid bytes in buf */
+	size_t valid;
 
 	/* Measures average tape speed */
 	unsigned long avg_time;
@@ -297,84 +284,6 @@ static struct ide_tape_obj *ide_tape_chrdev_get(unsigned int i)
 	return tape;
 }
 
-static int idetape_input_buffers(ide_drive_t *drive, struct ide_atapi_pc *pc,
-				  unsigned int bcount)
-{
-	struct idetape_bh *bh = pc->bh;
-	int count;
-
-	while (bcount) {
-		if (bh == NULL)
-			break;
-		count = min(
-			(unsigned int)(bh->b_size - atomic_read(&bh->b_count)),
-			bcount);
-		drive->hwif->tp_ops->input_data(drive, NULL, bh->b_data +
-					atomic_read(&bh->b_count), count);
-		bcount -= count;
-		atomic_add(count, &bh->b_count);
-		if (atomic_read(&bh->b_count) == bh->b_size) {
-			bh = bh->b_reqnext;
-			if (bh)
-				atomic_set(&bh->b_count, 0);
-		}
-	}
-
-	pc->bh = bh;
-
-	return bcount;
-}
-
-static int idetape_output_buffers(ide_drive_t *drive, struct ide_atapi_pc *pc,
-				   unsigned int bcount)
-{
-	struct idetape_bh *bh = pc->bh;
-	int count;
-
-	while (bcount) {
-		if (bh == NULL)
-			break;
-		count = min((unsigned int)pc->b_count, (unsigned int)bcount);
-		drive->hwif->tp_ops->output_data(drive, NULL, pc->b_data, count);
-		bcount -= count;
-		pc->b_data += count;
-		pc->b_count -= count;
-		if (!pc->b_count) {
-			bh = bh->b_reqnext;
-			pc->bh = bh;
-			if (bh) {
-				pc->b_data = bh->b_data;
-				pc->b_count = atomic_read(&bh->b_count);
-			}
-		}
-	}
-
-	return bcount;
-}
-
-static void idetape_update_buffers(ide_drive_t *drive, struct ide_atapi_pc *pc)
-{
-	struct idetape_bh *bh = pc->bh;
-	int count;
-	unsigned int bcount = pc->xferred;
-
-	if (pc->flags & PC_FLAG_WRITING)
-		return;
-	while (bcount) {
-		if (bh == NULL) {
-			printk(KERN_ERR "ide-tape: bh == NULL in %s\n",
-					__func__);
-			return;
-		}
-		count = min((unsigned int)bh->b_size, (unsigned int)bcount);
-		atomic_set(&bh->b_count, count);
-		if (atomic_read(&bh->b_count) == bh->b_size)
-			bh = bh->b_reqnext;
-		bcount -= count;
-	}
-	pc->bh = bh;
-}
-
 /*
  * called on each failed packet command retry to analyze the request sense. We
  * currently do not utilize this information.
@@ -392,12 +301,10 @@ static void idetape_analyze_error(ide_drive_t *drive, u8 *sense)
 		 pc->c[0], tape->sense_key, tape->asc, tape->ascq);
 
 	/* Correct pc->xferred by asking the tape.	 */
-	if (pc->flags & PC_FLAG_DMA_ERROR) {
+	if (pc->flags & PC_FLAG_DMA_ERROR)
 		pc->xferred = pc->req_xfer -
 			tape->blk_size *
 			get_unaligned_be32(&sense[3]);
-		idetape_update_buffers(drive, pc);
-	}
 
 	/*
 	 * If error was the result of a zero-length read or write command,
@@ -436,29 +343,6 @@ static void idetape_analyze_error(ide_drive_t *drive, u8 *sense)
 	}
 }
 
-/* Free data buffers completely. */
-static void ide_tape_kfree_buffer(idetape_tape_t *tape)
-{
-	struct idetape_bh *prev_bh, *bh = tape->merge_bh;
-
-	while (bh) {
-		u32 size = bh->b_size;
-
-		while (size) {
-			unsigned int order = fls(size >> PAGE_SHIFT)-1;
-
-			if (bh->b_data)
-				free_pages((unsigned long)bh->b_data, order);
-
-			size &= (order-1);
-			bh->b_data += (1 << order) * PAGE_SIZE;
-		}
-		prev_bh = bh;
-		bh = bh->b_reqnext;
-		kfree(prev_bh);
-	}
-}
-
 static void ide_tape_handle_dsc(ide_drive_t *);
 
 static int ide_tape_callback(ide_drive_t *drive, int dsc)
@@ -496,7 +380,7 @@ static int ide_tape_callback(ide_drive_t *drive, int dsc)
 		}
 
 		tape->first_frame += blocks;
-		rq->current_nr_sectors -= blocks;
+		rq->data_len -= blocks * tape->blk_size;
 
 		if (pc->error) {
 			uptodate = 0;
@@ -558,19 +442,6 @@ static void ide_tape_handle_dsc(ide_drive_t *drive)
 	idetape_postpone_request(drive);
 }
 
-static int ide_tape_io_buffers(ide_drive_t *drive, struct ide_atapi_pc *pc,
-				unsigned int bcount, int write)
-{
-	unsigned int bleft;
-
-	if (write)
-		bleft = idetape_output_buffers(drive, pc, bcount);
-	else
-		bleft = idetape_input_buffers(drive, pc, bcount);
-
-	return bcount - bleft;
-}
-
 /*
  * Packet Command Interface
  *
@@ -622,6 +493,8 @@ static ide_startstop_t ide_tape_issue_pc(ide_drive_t *drive,
 
 	if (pc->retries > IDETAPE_MAX_PC_RETRIES ||
 		(pc->flags & PC_FLAG_ABORT)) {
+		unsigned int done = blk_rq_bytes(drive->hwif->rq);
+
 		/*
 		 * We will "abort" retrying a packet command in case legitimate
 		 * error code was received (crossing a filemark, or end of the
@@ -641,8 +514,10 @@ static ide_startstop_t ide_tape_issue_pc(ide_drive_t *drive,
 			/* Giving up */
 			pc->error = IDE_DRV_ERROR_GENERAL;
 		}
+
 		drive->failed_pc = NULL;
 		drive->pc_callback(drive, 0);
+		ide_complete_rq(drive, -EIO, done);
 		return ide_stopped;
 	}
 	debug_log(DBG_SENSE, "Retry #%d, cmd = %02X\n", pc->retries, pc->c[0]);
@@ -695,7 +570,7 @@ static ide_startstop_t idetape_media_access_finished(ide_drive_t *drive)
 				printk(KERN_ERR "ide-tape: %s: I/O error, ",
 						tape->name);
 			/* Retry operation */
-			ide_retry_pc(drive, tape->disk);
+			ide_retry_pc(drive);
 			return ide_stopped;
 		}
 		pc->error = 0;
@@ -711,27 +586,22 @@ static void ide_tape_create_rw_cmd(idetape_tape_t *tape,
 				   struct ide_atapi_pc *pc, struct request *rq,
 				   u8 opcode)
 {
-	struct idetape_bh *bh = (struct idetape_bh *)rq->special;
-	unsigned int length = rq->current_nr_sectors;
+	unsigned int length = rq->nr_sectors;
 
 	ide_init_pc(pc);
 	put_unaligned(cpu_to_be32(length), (unsigned int *) &pc->c[1]);
 	pc->c[1] = 1;
-	pc->bh = bh;
 	pc->buf = NULL;
 	pc->buf_size = length * tape->blk_size;
 	pc->req_xfer = pc->buf_size;
 	if (pc->req_xfer == tape->buffer_size)
 		pc->flags |= PC_FLAG_DMA_OK;
 
-	if (opcode == READ_6) {
+	if (opcode == READ_6)
 		pc->c[0] = READ_6;
-		atomic_set(&bh->b_count, 0);
-	} else if (opcode == WRITE_6) {
+	else if (opcode == WRITE_6) {
 		pc->c[0] = WRITE_6;
 		pc->flags |= PC_FLAG_WRITING;
-		pc->b_data = bh->b_data;
-		pc->b_count = atomic_read(&bh->b_count);
 	}
 
 	memcpy(rq->cmd, pc->c, 12);
@@ -747,12 +617,10 @@ static ide_startstop_t idetape_do_request(ide_drive_t *drive,
 	struct ide_cmd cmd;
 	u8 stat;
 
-	debug_log(DBG_SENSE, "sector: %llu, nr_sectors: %lu,"
-			" current_nr_sectors: %u\n",
-			(unsigned long long)rq->sector, rq->nr_sectors,
-			rq->current_nr_sectors);
+	debug_log(DBG_SENSE, "sector: %llu, nr_sectors: %lu\n",
+		  (unsigned long long)rq->sector, rq->nr_sectors);
 
-	if (!blk_special_request(rq)) {
+	if (!(blk_special_request(rq) || blk_sense_request(rq))) {
 		/* We do not support buffer cache originated requests. */
 		printk(KERN_NOTICE "ide-tape: %s: Unsupported request in "
 			"request queue (%d)\n", drive->name, rq->cmd_type);
@@ -828,7 +696,7 @@ static ide_startstop_t idetape_do_request(ide_drive_t *drive,
 		goto out;
 	}
 	if (rq->cmd[13] & REQ_IDETAPE_PC1) {
-		pc = (struct ide_atapi_pc *) rq->buffer;
+		pc = (struct ide_atapi_pc *)rq->special;
 		rq->cmd[13] &= ~(REQ_IDETAPE_PC1);
 		rq->cmd[13] |= REQ_IDETAPE_PC2;
 		goto out;
@@ -840,6 +708,9 @@ static ide_startstop_t idetape_do_request(ide_drive_t *drive,
 	BUG();
 
 out:
+	/* prepare sense request for this command */
+	ide_prep_sense(drive, rq);
+
 	memset(&cmd, 0, sizeof(cmd));
 
 	if (rq_data_dir(rq))
@@ -847,167 +718,10 @@ out:
 
 	cmd.rq = rq;
 
-	return ide_tape_issue_pc(drive, &cmd, pc);
-}
-
-/*
- * The function below uses __get_free_pages to allocate a data buffer of size
- * tape->buffer_size (or a bit more). We attempt to combine sequential pages as
- * much as possible.
- *
- * It returns a pointer to the newly allocated buffer, or NULL in case of
- * failure.
- */
-static struct idetape_bh *ide_tape_kmalloc_buffer(idetape_tape_t *tape,
-						  int full, int clear)
-{
-	struct idetape_bh *prev_bh, *bh, *merge_bh;
-	int pages = tape->pages_per_buffer;
-	unsigned int order, b_allocd;
-	char *b_data = NULL;
-
-	merge_bh = kmalloc(sizeof(struct idetape_bh), GFP_KERNEL);
-	bh = merge_bh;
-	if (bh == NULL)
-		goto abort;
-
-	order = fls(pages) - 1;
-	bh->b_data = (char *) __get_free_pages(GFP_KERNEL, order);
-	if (!bh->b_data)
-		goto abort;
-	b_allocd = (1 << order) * PAGE_SIZE;
-	pages &= (order-1);
-
-	if (clear)
-		memset(bh->b_data, 0, b_allocd);
-	bh->b_reqnext = NULL;
-	bh->b_size = b_allocd;
-	atomic_set(&bh->b_count, full ? bh->b_size : 0);
-
-	while (pages) {
-		order = fls(pages) - 1;
-		b_data = (char *) __get_free_pages(GFP_KERNEL, order);
-		if (!b_data)
-			goto abort;
-		b_allocd = (1 << order) * PAGE_SIZE;
-
-		if (clear)
-			memset(b_data, 0, b_allocd);
-
-		/* newly allocated page frames below buffer header or ...*/
-		if (bh->b_data == b_data + b_allocd) {
-			bh->b_size += b_allocd;
-			bh->b_data -= b_allocd;
-			if (full)
-				atomic_add(b_allocd, &bh->b_count);
-			continue;
-		}
-		/* they are above the header */
-		if (b_data == bh->b_data + bh->b_size) {
-			bh->b_size += b_allocd;
-			if (full)
-				atomic_add(b_allocd, &bh->b_count);
-			continue;
-		}
-		prev_bh = bh;
-		bh = kmalloc(sizeof(struct idetape_bh), GFP_KERNEL);
-		if (!bh) {
-			free_pages((unsigned long) b_data, order);
-			goto abort;
-		}
-		bh->b_reqnext = NULL;
-		bh->b_data = b_data;
-		bh->b_size = b_allocd;
-		atomic_set(&bh->b_count, full ? bh->b_size : 0);
-		prev_bh->b_reqnext = bh;
-
-		pages &= (order-1);
-	}
-
-	bh->b_size -= tape->excess_bh_size;
-	if (full)
-		atomic_sub(tape->excess_bh_size, &bh->b_count);
-	return merge_bh;
-abort:
-	ide_tape_kfree_buffer(tape);
-	return NULL;
-}
+	ide_init_sg_cmd(&cmd, pc->req_xfer);
+	ide_map_sg(drive, &cmd);
 
-static int idetape_copy_stage_from_user(idetape_tape_t *tape,
-					const char __user *buf, int n)
-{
-	struct idetape_bh *bh = tape->bh;
-	int count;
-	int ret = 0;
-
-	while (n) {
-		if (bh == NULL) {
-			printk(KERN_ERR "ide-tape: bh == NULL in %s\n",
-					__func__);
-			return 1;
-		}
-		count = min((unsigned int)
-				(bh->b_size - atomic_read(&bh->b_count)),
-				(unsigned int)n);
-		if (copy_from_user(bh->b_data + atomic_read(&bh->b_count), buf,
-				count))
-			ret = 1;
-		n -= count;
-		atomic_add(count, &bh->b_count);
-		buf += count;
-		if (atomic_read(&bh->b_count) == bh->b_size) {
-			bh = bh->b_reqnext;
-			if (bh)
-				atomic_set(&bh->b_count, 0);
-		}
-	}
-	tape->bh = bh;
-	return ret;
-}
-
-static int idetape_copy_stage_to_user(idetape_tape_t *tape, char __user *buf,
-				      int n)
-{
-	struct idetape_bh *bh = tape->bh;
-	int count;
-	int ret = 0;
-
-	while (n) {
-		if (bh == NULL) {
-			printk(KERN_ERR "ide-tape: bh == NULL in %s\n",
-					__func__);
-			return 1;
-		}
-		count = min(tape->b_count, n);
-		if  (copy_to_user(buf, tape->b_data, count))
-			ret = 1;
-		n -= count;
-		tape->b_data += count;
-		tape->b_count -= count;
-		buf += count;
-		if (!tape->b_count) {
-			bh = bh->b_reqnext;
-			tape->bh = bh;
-			if (bh) {
-				tape->b_data = bh->b_data;
-				tape->b_count = atomic_read(&bh->b_count);
-			}
-		}
-	}
-	return ret;
-}
-
-static void idetape_init_merge_buffer(idetape_tape_t *tape)
-{
-	struct idetape_bh *bh = tape->merge_bh;
-	tape->bh = tape->merge_bh;
-
-	if (tape->chrdev_dir == IDETAPE_DIR_WRITE)
-		atomic_set(&bh->b_count, 0);
-	else {
-		tape->b_data = bh->b_data;
-		tape->b_count = atomic_read(&bh->b_count);
-	}
+	return ide_tape_issue_pc(drive, &cmd, pc);
 }
 
 /*
@@ -1107,10 +821,10 @@ static void __ide_tape_discard_merge_buffer(ide_drive_t *drive)
 		return;
 
 	clear_bit(IDE_AFLAG_FILEMARK, &drive->atapi_flags);
-	tape->merge_bh_size = 0;
-	if (tape->merge_bh != NULL) {
-		ide_tape_kfree_buffer(tape);
-		tape->merge_bh = NULL;
+	tape->valid = 0;
+	if (tape->buf != NULL) {
+		kfree(tape->buf);
+		tape->buf = NULL;
 	}
 
 	tape->chrdev_dir = IDETAPE_DIR_NONE;
@@ -1164,36 +878,44 @@ static void ide_tape_discard_merge_buffer(ide_drive_t *drive,
  * Generate a read/write request for the block device interface and wait for it
  * to be serviced.
  */
-static int idetape_queue_rw_tail(ide_drive_t *drive, int cmd, int blocks,
-				 struct idetape_bh *bh)
+static int idetape_queue_rw_tail(ide_drive_t *drive, int cmd, int size)
 {
 	idetape_tape_t *tape = drive->driver_data;
 	struct request *rq;
-	int ret, errors;
+	int ret;
 
 	debug_log(DBG_SENSE, "%s: cmd=%d\n", __func__, cmd);
+	BUG_ON(cmd != REQ_IDETAPE_READ && cmd != REQ_IDETAPE_WRITE);
+	BUG_ON(size < 0 || size % tape->blk_size);
 
 	rq = blk_get_request(drive->queue, READ, __GFP_WAIT);
 	rq->cmd_type = REQ_TYPE_SPECIAL;
 	rq->cmd[13] = cmd;
 	rq->rq_disk = tape->disk;
-	rq->special = (void *)bh;
 	rq->sector = tape->first_frame;
-	rq->nr_sectors = blocks;
-	rq->current_nr_sectors = blocks;
-	blk_execute_rq(drive->queue, tape->disk, rq, 0);
 
-	errors = rq->errors;
-	ret = tape->blk_size * (blocks - rq->current_nr_sectors);
-	blk_put_request(rq);
+	if (size) {
+		ret = blk_rq_map_kern(drive->queue, rq, tape->buf, size,
+				      __GFP_WAIT);
+		if (ret)
+			goto out_put;
+	}
 
-	if ((cmd & (REQ_IDETAPE_READ | REQ_IDETAPE_WRITE)) == 0)
-		return 0;
+	blk_execute_rq(drive->queue, tape->disk, rq, 0);
 
-	if (tape->merge_bh)
-		idetape_init_merge_buffer(tape);
-	if (errors == IDE_DRV_ERROR_GENERAL)
-		return -EIO;
+	/* calculate the number of transferred bytes and update buffer state */
+	size -= rq->data_len;
+	tape->cur = tape->buf;
+	if (cmd == REQ_IDETAPE_READ)
+		tape->valid = size;
+	else
+		tape->valid = 0;
+
+	ret = size;
+	if (rq->errors == IDE_DRV_ERROR_GENERAL)
+		ret = -EIO;
+out_put:
+	blk_put_request(rq);
 	return ret;
 }
 
@@ -1230,153 +952,87 @@ static void idetape_create_space_cmd(struct ide_atapi_pc *pc, int count, u8 cmd)
 	pc->flags |= PC_FLAG_WAIT_FOR_DSC;
 }
 
-/* Queue up a character device originated write request. */
-static int idetape_add_chrdev_write_request(ide_drive_t *drive, int blocks)
-{
-	idetape_tape_t *tape = drive->driver_data;
-
-	debug_log(DBG_CHRDEV, "Enter %s\n", __func__);
-
-	return idetape_queue_rw_tail(drive, REQ_IDETAPE_WRITE,
-				     blocks, tape->merge_bh);
-}
-
 static void ide_tape_flush_merge_buffer(ide_drive_t *drive)
 {
 	idetape_tape_t *tape = drive->driver_data;
-	int blocks, min;
-	struct idetape_bh *bh;
 
 	if (tape->chrdev_dir != IDETAPE_DIR_WRITE) {
 		printk(KERN_ERR "ide-tape: bug: Trying to empty merge buffer"
 				" but we are not writing.\n");
 		return;
 	}
-	if (tape->merge_bh_size > tape->buffer_size) {
-		printk(KERN_ERR "ide-tape: bug: merge_buffer too big\n");
-		tape->merge_bh_size = tape->buffer_size;
-	}
-	if (tape->merge_bh_size) {
-		blocks = tape->merge_bh_size / tape->blk_size;
-		if (tape->merge_bh_size % tape->blk_size) {
-			unsigned int i;
-
-			blocks++;
-			i = tape->blk_size - tape->merge_bh_size %
-				tape->blk_size;
-			bh = tape->bh->b_reqnext;
-			while (bh) {
-				atomic_set(&bh->b_count, 0);
-				bh = bh->b_reqnext;
-			}
-			bh = tape->bh;
-			while (i) {
-				if (bh == NULL) {
-					printk(KERN_INFO "ide-tape: bug,"
-							 " bh NULL\n");
-					break;
-				}
-				min = min(i, (unsigned int)(bh->b_size -
-						atomic_read(&bh->b_count)));
-				memset(bh->b_data + atomic_read(&bh->b_count),
-						0, min);
-				atomic_add(min, &bh->b_count);
-				i -= min;
-				bh = bh->b_reqnext;
-			}
-		}
-		(void) idetape_add_chrdev_write_request(drive, blocks);
-		tape->merge_bh_size = 0;
-	}
-	if (tape->merge_bh != NULL) {
-		ide_tape_kfree_buffer(tape);
-		tape->merge_bh = NULL;
+	if (tape->buf) {
+		size_t aligned = roundup(tape->valid, tape->blk_size);
+
+		memset(tape->cur, 0, aligned - tape->valid);
+		idetape_queue_rw_tail(drive, REQ_IDETAPE_WRITE, aligned);
+		kfree(tape->buf);
+		tape->buf = NULL;
 	}
 	tape->chrdev_dir = IDETAPE_DIR_NONE;
 }
 
-static int idetape_init_read(ide_drive_t *drive)
+static int idetape_init_rw(ide_drive_t *drive, int dir)
 {
 	idetape_tape_t *tape = drive->driver_data;
-	int bytes_read;
+	int rc;
 
-	/* Initialize read operation */
-	if (tape->chrdev_dir != IDETAPE_DIR_READ) {
-		if (tape->chrdev_dir == IDETAPE_DIR_WRITE) {
-			ide_tape_flush_merge_buffer(drive);
-			idetape_flush_tape_buffers(drive);
-		}
-		if (tape->merge_bh || tape->merge_bh_size) {
-			printk(KERN_ERR "ide-tape: merge_bh_size should be"
-					 " 0 now\n");
-			tape->merge_bh_size = 0;
-		}
-		tape->merge_bh = ide_tape_kmalloc_buffer(tape, 0, 0);
-		if (!tape->merge_bh)
-			return -ENOMEM;
-		tape->chrdev_dir = IDETAPE_DIR_READ;
+	BUG_ON(dir != IDETAPE_DIR_READ && dir != IDETAPE_DIR_WRITE);
 
-		/*
-		 * Issue a read 0 command to ensure that DSC handshake is
-		 * switched from completion mode to buffer available mode.
-		 * No point in issuing this if DSC overlap isn't supported, some
-		 * drives (Seagate STT3401A) will return an error.
-		 */
-		if (drive->dev_flags & IDE_DFLAG_DSC_OVERLAP) {
-			bytes_read = idetape_queue_rw_tail(drive,
-							REQ_IDETAPE_READ, 0,
-							tape->merge_bh);
-			if (bytes_read < 0) {
-				ide_tape_kfree_buffer(tape);
-				tape->merge_bh = NULL;
-				tape->chrdev_dir = IDETAPE_DIR_NONE;
-				return bytes_read;
-			}
-		}
-	}
+	if (tape->chrdev_dir == dir)
+		return 0;
 
-	return 0;
-}
+	if (tape->chrdev_dir == IDETAPE_DIR_READ)
+		ide_tape_discard_merge_buffer(drive, 1);
+	else if (tape->chrdev_dir == IDETAPE_DIR_WRITE) {
+		ide_tape_flush_merge_buffer(drive);
+		idetape_flush_tape_buffers(drive);
+	}
 
-/* called from idetape_chrdev_read() to service a chrdev read request. */
-static int idetape_add_chrdev_read_request(ide_drive_t *drive, int blocks)
-{
-	idetape_tape_t *tape = drive->driver_data;
+	if (tape->buf || tape->valid) {
+		printk(KERN_ERR "ide-tape: valid should be 0 now\n");
+		tape->valid = 0;
+	}
 
-	debug_log(DBG_PROCS, "Enter %s, %d blocks\n", __func__, blocks);
+	tape->buf = kmalloc(tape->buffer_size, GFP_KERNEL);
+	if (!tape->buf)
+		return -ENOMEM;
+	tape->chrdev_dir = dir;
+	tape->cur = tape->buf;
 
-	/* If we are at a filemark, return a read length of 0 */
-	if (test_bit(IDE_AFLAG_FILEMARK, &drive->atapi_flags))
-		return 0;
-
-	idetape_init_read(drive);
+	/*
+	 * Issue a 0 rw command to ensure that DSC handshake is
+	 * switched from completion mode to buffer available mode.  No
+	 * point in issuing this if DSC overlap isn't supported, some
+	 * drives (Seagate STT3401A) will return an error.
+	 */
+	if (drive->dev_flags & IDE_DFLAG_DSC_OVERLAP) {
+		int cmd = dir == IDETAPE_DIR_READ ? REQ_IDETAPE_READ
+						  : REQ_IDETAPE_WRITE;
+
+		rc = idetape_queue_rw_tail(drive, cmd, 0);
+		if (rc < 0) {
+			kfree(tape->buf);
+			tape->buf = NULL;
+			tape->chrdev_dir = IDETAPE_DIR_NONE;
+			return rc;
+		}
+	}
 
-	return idetape_queue_rw_tail(drive, REQ_IDETAPE_READ, blocks,
-				     tape->merge_bh);
+	return 0;
 }
 
 static void idetape_pad_zeros(ide_drive_t *drive, int bcount)
 {
 	idetape_tape_t *tape = drive->driver_data;
-	struct idetape_bh *bh;
-	int blocks;
+
+	memset(tape->buf, 0, tape->buffer_size);
 
 	while (bcount) {
-		unsigned int count;
+		unsigned int count = min(tape->buffer_size, bcount);
 
-		bh = tape->merge_bh;
-		count = min(tape->buffer_size, bcount);
+		idetape_queue_rw_tail(drive, REQ_IDETAPE_WRITE, count);
 		bcount -= count;
-		blocks = count / tape->blk_size;
-		while (count) {
-			atomic_set(&bh->b_count,
-				   min(count, (unsigned int)bh->b_size));
-			memset(bh->b_data, 0, atomic_read(&bh->b_count));
-			count -= atomic_read(&bh->b_count);
-			bh = bh->b_reqnext;
-		}
-		idetape_queue_rw_tail(drive, REQ_IDETAPE_WRITE, blocks,
-				      tape->merge_bh);
 	}
 }
 
@@ -1456,7 +1112,7 @@ static int idetape_space_over_filemarks(ide_drive_t *drive, short mt_op,
 	}
 
 	if (tape->chrdev_dir == IDETAPE_DIR_READ) {
-		tape->merge_bh_size = 0;
+		tape->valid = 0;
 		if (test_and_clear_bit(IDE_AFLAG_FILEMARK, &drive->atapi_flags))
 			++count;
 		ide_tape_discard_merge_buffer(drive, 0);
@@ -1505,9 +1161,9 @@ static ssize_t idetape_chrdev_read(struct file *file, char __user *buf,
 {
 	struct ide_tape_obj *tape = file->private_data;
 	ide_drive_t *drive = tape->drive;
-	ssize_t bytes_read, temp, actually_read = 0, rc;
+	size_t done = 0;
 	ssize_t ret = 0;
-	u16 ctl = *(u16 *)&tape->caps[12];
+	int rc;
 
 	debug_log(DBG_CHRDEV, "Enter %s, count %Zd\n", __func__, count);
 
@@ -1517,49 +1173,43 @@ static ssize_t idetape_chrdev_read(struct file *file, char __user *buf,
 			    (count % tape->blk_size) == 0)
 				tape->user_bs_factor = count / tape->blk_size;
 	}
-	rc = idetape_init_read(drive);
+
+	rc = idetape_init_rw(drive, IDETAPE_DIR_READ);
 	if (rc < 0)
 		return rc;
-	if (count == 0)
-		return (0);
-	if (tape->merge_bh_size) {
-		actually_read = min((unsigned int)(tape->merge_bh_size),
-				    (unsigned int)count);
-		if (idetape_copy_stage_to_user(tape, buf, actually_read))
-			ret = -EFAULT;
-		buf += actually_read;
-		tape->merge_bh_size -= actually_read;
-		count -= actually_read;
-	}
-	while (count >= tape->buffer_size) {
-		bytes_read = idetape_add_chrdev_read_request(drive, ctl);
-		if (bytes_read <= 0)
-			goto finish;
-		if (idetape_copy_stage_to_user(tape, buf, bytes_read))
-			ret = -EFAULT;
-		buf += bytes_read;
-		count -= bytes_read;
-		actually_read += bytes_read;
-	}
-	if (count) {
-		bytes_read = idetape_add_chrdev_read_request(drive, ctl);
-		if (bytes_read <= 0)
-			goto finish;
-		temp = min((unsigned long)count, (unsigned long)bytes_read);
-		if (idetape_copy_stage_to_user(tape, buf, temp))
+
+	while (done < count) {
+		size_t todo;
+
+		/* refill if staging buffer is empty */
+		if (!tape->valid) {
+			/* If we are at a filemark, nothing more to read */
+			if (test_bit(IDE_AFLAG_FILEMARK, &drive->atapi_flags))
+				break;
+			/* read */
+			if (idetape_queue_rw_tail(drive, REQ_IDETAPE_READ,
+						  tape->buffer_size) <= 0)
+				break;
+		}
+
+		/* copy out */
+		todo = min_t(size_t, count - done, tape->valid);
+		if (copy_to_user(buf + done, tape->cur, todo))
 			ret = -EFAULT;
-		actually_read += temp;
-		tape->merge_bh_size = bytes_read-temp;
+
+		tape->cur += todo;
+		tape->valid -= todo;
+		done += todo;
 	}
-finish:
-	if (!actually_read && test_bit(IDE_AFLAG_FILEMARK, &drive->atapi_flags)) {
+
+	if (!done && test_bit(IDE_AFLAG_FILEMARK, &drive->atapi_flags)) {
 		debug_log(DBG_SENSE, "%s: spacing over filemark\n", tape->name);
 
 		idetape_space_over_filemarks(drive, MTFSF, 1);
 		return 0;
 	}
 
-	return ret ? ret : actually_read;
+	return ret ? ret : done;
 }
 
 static ssize_t idetape_chrdev_write(struct file *file, const char __user *buf,
@@ -1567,9 +1217,9 @@ static ssize_t idetape_chrdev_write(struct file *file, const char __user *buf,
 {
 	struct ide_tape_obj *tape = file->private_data;
 	ide_drive_t *drive = tape->drive;
-	ssize_t actually_written = 0;
+	size_t done = 0;
 	ssize_t ret = 0;
-	u16 ctl = *(u16 *)&tape->caps[12];
+	int rc;
 
 	/* The drive is write protected. */
 	if (tape->write_prot)
@@ -1578,80 +1228,31 @@ static ssize_t idetape_chrdev_write(struct file *file, const char __user *buf,
 	debug_log(DBG_CHRDEV, "Enter %s, count %Zd\n", __func__, count);
 
 	/* Initialize write operation */
-	if (tape->chrdev_dir != IDETAPE_DIR_WRITE) {
-		if (tape->chrdev_dir == IDETAPE_DIR_READ)
-			ide_tape_discard_merge_buffer(drive, 1);
-		if (tape->merge_bh || tape->merge_bh_size) {
-			printk(KERN_ERR "ide-tape: merge_bh_size "
-				"should be 0 now\n");
-			tape->merge_bh_size = 0;
-		}
-		tape->merge_bh = ide_tape_kmalloc_buffer(tape, 0, 0);
-		if (!tape->merge_bh)
-			return -ENOMEM;
-		tape->chrdev_dir = IDETAPE_DIR_WRITE;
-		idetape_init_merge_buffer(tape);
+	rc = idetape_init_rw(drive, IDETAPE_DIR_WRITE);
+	if (rc < 0)
+		return rc;
 
-		/*
-		 * Issue a write 0 command to ensure that DSC handshake is
-		 * switched from completion mode to buffer available mode. No
-		 * point in issuing this if DSC overlap isn't supported, some
-		 * drives (Seagate STT3401A) will return an error.
-		 */
-		if (drive->dev_flags & IDE_DFLAG_DSC_OVERLAP) {
-			ssize_t retval = idetape_queue_rw_tail(drive,
-							REQ_IDETAPE_WRITE, 0,
-							tape->merge_bh);
-			if (retval < 0) {
-				ide_tape_kfree_buffer(tape);
-				tape->merge_bh = NULL;
-				tape->chrdev_dir = IDETAPE_DIR_NONE;
-				return retval;
-			}
-		}
-	}
-	if (count == 0)
-		return (0);
-	if (tape->merge_bh_size) {
-		if (tape->merge_bh_size >= tape->buffer_size) {
-			printk(KERN_ERR "ide-tape: bug: merge buf too big\n");
-			tape->merge_bh_size = 0;
-		}
-		actually_written = min((unsigned int)
-				(tape->buffer_size - tape->merge_bh_size),
-				(unsigned int)count);
-		if (idetape_copy_stage_from_user(tape, buf, actually_written))
-				ret = -EFAULT;
-		buf += actually_written;
-		tape->merge_bh_size += actually_written;
-		count -= actually_written;
-
-		if (tape->merge_bh_size == tape->buffer_size) {
-			ssize_t retval;
-			tape->merge_bh_size = 0;
-			retval = idetape_add_chrdev_write_request(drive, ctl);
-			if (retval <= 0)
-				return (retval);
-		}
-	}
-	while (count >= tape->buffer_size) {
-		ssize_t retval;
-		if (idetape_copy_stage_from_user(tape, buf, tape->buffer_size))
-			ret = -EFAULT;
-		buf += tape->buffer_size;
-		count -= tape->buffer_size;
-		retval = idetape_add_chrdev_write_request(drive, ctl);
-		actually_written += tape->buffer_size;
-		if (retval <= 0)
-			return (retval);
-	}
-	if (count) {
-		actually_written += count;
-		if (idetape_copy_stage_from_user(tape, buf, count))
+	while (done < count) {
+		size_t todo;
+
+		/* flush if staging buffer is full */
+		if (tape->valid == tape->buffer_size &&
+		    idetape_queue_rw_tail(drive, REQ_IDETAPE_WRITE,
+					  tape->buffer_size) <= 0)
+			return rc;
+
+		/* copy in */
+		todo = min_t(size_t, count - done,
+			     tape->buffer_size - tape->valid);
+		if (copy_from_user(tape->cur, buf + done, todo))
 			ret = -EFAULT;
-		tape->merge_bh_size += count;
+
+		tape->cur += todo;
+		tape->valid += todo;
+		done += todo;
 	}
-	return ret ? ret : actually_written;
+
+	return ret ? ret : done;
 }
 
 static int idetape_write_filemark(ide_drive_t *drive)
@@ -1812,7 +1413,7 @@ static int idetape_chrdev_ioctl(struct inode *inode, struct file *file,
 		idetape_flush_tape_buffers(drive);
 	}
 	if (cmd == MTIOCGET || cmd == MTIOCPOS) {
-		block_offset = tape->merge_bh_size /
+		block_offset = tape->valid /
 			(tape->blk_size * tape->user_bs_factor);
 		position = idetape_read_position(drive);
 		if (position < 0)
@@ -1960,12 +1561,12 @@ static void idetape_write_release(ide_drive_t *drive, unsigned int minor)
 	idetape_tape_t *tape = drive->driver_data;
 
 	ide_tape_flush_merge_buffer(drive);
-	tape->merge_bh = ide_tape_kmalloc_buffer(tape, 1, 0);
-	if (tape->merge_bh != NULL) {
+	tape->buf = kmalloc(tape->buffer_size, GFP_KERNEL);
+	if (tape->buf != NULL) {
 		idetape_pad_zeros(drive, tape->blk_size *
 				(tape->user_bs_factor - 1));
-		ide_tape_kfree_buffer(tape);
-		tape->merge_bh = NULL;
+		kfree(tape->buf);
+		tape->buf = NULL;
 	}
 	idetape_write_filemark(drive);
 	idetape_flush_tape_buffers(drive);
@@ -2159,8 +1760,6 @@ static void idetape_setup(ide_drive_t *drive, idetape_tape_t *tape, int minor)
 	u16 *ctl = (u16 *)&tape->caps[12];
 
 	drive->pc_callback	 = ide_tape_callback;
-	drive->pc_update_buffers = idetape_update_buffers;
-	drive->pc_io_buffers	 = ide_tape_io_buffers;
 
 	drive->dev_flags |= IDE_DFLAG_DSC_OVERLAP;
 
@@ -2191,11 +1790,6 @@ static void idetape_setup(ide_drive_t *drive, idetape_tape_t *tape, int minor)
 		tape->buffer_size = *ctl * tape->blk_size;
 	}
 	buffer_size = tape->buffer_size;
-	tape->pages_per_buffer = buffer_size / PAGE_SIZE;
-	if (buffer_size % PAGE_SIZE) {
-		tape->pages_per_buffer++;
-		tape->excess_bh_size = PAGE_SIZE - buffer_size % PAGE_SIZE;
-	}
 
 	/* select the "best" DSC read/write polling freq */
 	speed = max(*(u16 *)&tape->caps[14], *(u16 *)&tape->caps[8]);
@@ -2238,7 +1832,7 @@ static void ide_tape_release(struct device *dev)
 	ide_drive_t *drive = tape->drive;
 	struct gendisk *g = tape->disk;
 
-	BUG_ON(tape->merge_bh_size);
+	BUG_ON(tape->valid);
 
 	drive->dev_flags &= ~IDE_DFLAG_DSC_OVERLAP;
 	drive->driver_data = NULL;
diff --git a/drivers/ide/ide-taskfile.c b/drivers/ide/ide-taskfile.c
index 4aa6223..f400eb4 100644
--- a/drivers/ide/ide-taskfile.c
+++ b/drivers/ide/ide-taskfile.c
@@ -424,7 +424,9 @@ int ide_raw_taskfile(ide_drive_t *drive, struct ide_cmd *cmd, u8 *buf,
 
 	rq = blk_get_request(drive->queue, READ, __GFP_WAIT);
 	rq->cmd_type = REQ_TYPE_ATA_TASKFILE;
-	rq->buffer = buf;
+
+	if (cmd->tf_flags & IDE_TFLAG_WRITE)
+		rq->cmd_flags |= REQ_RW;
 
 	/*
 	 * (ks) We transfer currently only whole sectors.
@@ -432,18 +434,20 @@ int ide_raw_taskfile(ide_drive_t *drive, struct ide_cmd *cmd, u8 *buf,
 	 * if we would find a solution to transfer any size.
 	 * To support special commands like READ LONG.
 	 */
-	rq->hard_nr_sectors = rq->nr_sectors = nsect;
-	rq->hard_cur_sectors = rq->current_nr_sectors = nsect;
-
-	if (cmd->tf_flags & IDE_TFLAG_WRITE)
-		rq->cmd_flags |= REQ_RW;
+	if (nsect) {
+		error = blk_rq_map_kern(drive->queue, rq, buf,
+					nsect * SECTOR_SIZE, __GFP_WAIT);
+		if (error)
+			goto put_req;
+	}
 
 	rq->special = cmd;
 	cmd->rq = rq;
 
 	error = blk_execute_rq(drive->queue, NULL, rq, 0);
-	blk_put_request(rq);
 
+put_req:
+	blk_put_request(rq);
 	return error;
 }
 
diff --git a/include/linux/ide.h b/include/linux/ide.h
index 9fed365..867cb68 100644
--- a/include/linux/ide.h
+++ b/include/linux/ide.h
@@ -26,6 +26,9 @@
 #include <asm/io.h>
 #include <asm/mutex.h>
 
+/* for request_sense */
+#include <linux/cdrom.h>
+
 #if defined(CONFIG_CRIS) || defined(CONFIG_FRV) || defined(CONFIG_MN10300)
 # define SUPPORT_VLB_SYNC 0
 #else
@@ -324,7 +327,6 @@ struct ide_cmd {
 	unsigned int		cursg_ofs;
 
 	struct request		*rq;		/* copy of request */
-	void			*special;	/* valid_t generally */
 };
 
 /* ATAPI packet command flags */
@@ -360,11 +362,7 @@ struct ide_atapi_pc {
 
 	/* data buffer */
 	u8 *buf;
-	/* current buffer position */
-	u8 *cur_pos;
 	int buf_size;
-	/* missing/available data on the current buffer */
-	int b_count;
 
 	/* the corresponding request */
 	struct request *rq;
@@ -377,10 +375,6 @@ struct ide_atapi_pc {
 	 */
 	u8 pc_buf[IDE_PC_BUFFER_SIZE];
 
-	/* idetape only */
-	struct idetape_bh *bh;
-	char *b_data;
-
 	unsigned long timeout;
 };
 
@@ -593,16 +587,16 @@ struct ide_drive_s {
 	/* callback for packet commands */
 	int  (*pc_callback)(struct ide_drive_s *, int);
 
-	void (*pc_update_buffers)(struct ide_drive_s *, struct ide_atapi_pc *);
-	int  (*pc_io_buffers)(struct ide_drive_s *, struct ide_atapi_pc *,
-			      unsigned int, int);
-
 	ide_startstop_t (*irq_handler)(struct ide_drive_s *);
 
 	unsigned long atapi_flags;
 
 	struct ide_atapi_pc request_sense_pc;
-	struct request request_sense_rq;
+
+	/* current sense rq and buffer */
+	bool sense_rq_armed;
+	struct request sense_rq;
+	struct request_sense sense_data;
 };
 
 typedef struct ide_drive_s ide_drive_t;
@@ -1174,7 +1168,10 @@ int ide_do_test_unit_ready(ide_drive_t *, struct gendisk *);
 int ide_do_start_stop(ide_drive_t *, struct gendisk *, int);
 int ide_set_media_lock(ide_drive_t *, struct gendisk *, int);
 void ide_create_request_sense_cmd(ide_drive_t *, struct ide_atapi_pc *);
-void ide_retry_pc(ide_drive_t *, struct gendisk *);
+void ide_retry_pc(ide_drive_t *drive);
+
+void ide_prep_sense(ide_drive_t *drive, struct request *rq);
+int ide_queue_sense_rq(ide_drive_t *drive, void *special);
 
 int ide_cd_expiry(ide_drive_t *);
 
