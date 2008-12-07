Return-Path: <linux-kernel-owner+w=401wt.eu-S1755565AbYLGRWa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755565AbYLGRWa (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Dec 2008 12:22:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753006AbYLGRVY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 7 Dec 2008 12:21:24 -0500
Received: from fk-out-0910.google.com ([209.85.128.191]:24553 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751468AbYLGRVS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Dec 2008 12:21:18 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=to:cc:subject:date:message-id:x-mailer:in-reply-to:references:from;
        b=VgslaXspEH6ghAHzvhvJMjbxB/bvmejlghqT6cA73wemBmMYjJdFdfoAR8JV96rjvW
         pFqmQwQ+oI0IXaP7F96CYZ8KubGOj9fLQtwY5xIYcXDNQnZxL01Rp89cFKOEb9A23hqy
         6Pg3xK/rD/0+5MGCE16tAtblGZF14DeTOYsaI=
To: <bzolnier@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org,
       Borislav Petkov <petkovbb@gmail.com>
Subject: [PATCH 3/4] ide-atapi: remove ide-scsi remnants from ide_pc_intr()
Date: Sun,  7 Dec 2008 18:21:10 +0100
Message-Id: <1228670471-3435-4-git-send-email-petkovbb@gmail.com>
X-Mailer: git-send-email 1.6.0.4
In-Reply-To: <1228670471-3435-1-git-send-email-petkovbb@gmail.com>
References: <1228670471-3435-1-git-send-email-petkovbb@gmail.com>
From: Borislav Petkov <petkovbb@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As a result, remove now unused ide_scsi_get_timeout and ide_scsi_expiry.

Signed-off-by: Borislav Petkov <petkovbb@gmail.com>
---
 drivers/ide/ide-atapi.c |   68 +++++++++--------------------------------------
 include/linux/ide.h     |    6 ----
 2 files changed, 13 insertions(+), 61 deletions(-)

diff --git a/drivers/ide/ide-atapi.c b/drivers/ide/ide-atapi.c
index f5bf405..7a04509 100644
--- a/drivers/ide/ide-atapi.c
+++ b/drivers/ide/ide-atapi.c
@@ -240,19 +240,6 @@ void ide_retry_pc(ide_drive_t *drive, struct gendisk *disk)
 }
 EXPORT_SYMBOL_GPL(ide_retry_pc);
 
-int ide_scsi_expiry(ide_drive_t *drive)
-{
-	struct ide_atapi_pc *pc = drive->pc;
-
-	debug_log("%s called for %lu at %lu\n", __func__,
-		  pc->scsi_cmd->serial_number, jiffies);
-
-	pc->flags |= PC_FLAG_TIMEDOUT;
-
-	return 0; /* we do not want the IDE subsystem to retry */
-}
-EXPORT_SYMBOL_GPL(ide_scsi_expiry);
-
 int ide_cd_expiry(ide_drive_t *drive)
 {
 	struct request *rq = HWGROUP(drive)->rq;
@@ -309,21 +296,14 @@ static ide_startstop_t ide_pc_intr(ide_drive_t *drive)
 	struct request *rq = hwif->hwgroup->rq;
 	const struct ide_tp_ops *tp_ops = hwif->tp_ops;
 	xfer_func_t *xferfunc;
-	ide_expiry_t *expiry;
 	unsigned int timeout, temp;
 	u16 bcount;
-	u8 stat, ireason, scsi = !!(drive->dev_flags & IDE_DFLAG_SCSI), dsc = 0;
+	u8 stat, ireason, dsc = 0;
 
 	debug_log("Enter %s - interrupt handler\n", __func__);
 
-	if (scsi) {
-		timeout = ide_scsi_get_timeout(pc);
-		expiry = ide_scsi_expiry;
-	} else {
-		timeout = (drive->media == ide_floppy) ? WAIT_FLOPPY_CMD
-						       : WAIT_TAPE_CMD;
-		expiry = NULL;
-	}
+	timeout = (drive->media == ide_floppy) ? WAIT_FLOPPY_CMD
+					       : WAIT_TAPE_CMD;
 
 	if (pc->flags & PC_FLAG_TIMEDOUT) {
 		drive->pc_callback(drive, 0);
@@ -335,8 +315,8 @@ static ide_startstop_t ide_pc_intr(ide_drive_t *drive)
 
 	if (pc->flags & PC_FLAG_DMA_IN_PROGRESS) {
 		if (hwif->dma_ops->dma_end(drive) ||
-		    (drive->media == ide_tape && !scsi && (stat & ATA_ERR))) {
-			if (drive->media == ide_floppy && !scsi)
+		    (drive->media == ide_tape && (stat & ATA_ERR))) {
+			if (drive->media == ide_floppy)
 				printk(KERN_ERR "%s: DMA %s error\n",
 					drive->name, rq_data_dir(pc->rq)
 						     ? "write" : "read");
@@ -358,7 +338,7 @@ static ide_startstop_t ide_pc_intr(ide_drive_t *drive)
 
 		local_irq_enable_in_hardirq();
 
-		if (drive->media == ide_tape && !scsi &&
+		if (drive->media == ide_tape &&
 		    (stat & ATA_ERR) && rq->cmd[0] == REQUEST_SENSE)
 			stat &= ~ATA_ERR;
 
@@ -366,11 +346,8 @@ static ide_startstop_t ide_pc_intr(ide_drive_t *drive)
 			/* Error detected */
 			debug_log("%s: I/O error\n", drive->name);
 
-			if (drive->media != ide_tape || scsi) {
+			if (drive->media != ide_tape)
 				pc->rq->errors++;
-				if (scsi)
-					goto cmd_finished;
-			}
 
 			if (rq->cmd[0] == REQUEST_SENSE) {
 				printk(KERN_ERR "%s: I/O error in request sense"
@@ -386,7 +363,6 @@ static ide_startstop_t ide_pc_intr(ide_drive_t *drive)
 			/* queued, but not started */
 			return ide_stopped;
 		}
-cmd_finished:
 		pc->error = 0;
 
 		if ((pc->flags & PC_FLAG_WAIT_FOR_DSC) && (stat & ATA_DSC) == 0)
@@ -433,25 +409,8 @@ cmd_finished:
 						"us more data than expected - "
 						"discarding data\n",
 						drive->name);
-				if (scsi)
-					temp = pc->buf_size - pc->xferred;
-				else
-					temp = 0;
-				if (temp) {
-					if (pc->sg)
-						drive->pc_io_buffers(drive, pc,
-								     temp, 0);
-					else
-						tp_ops->input_data(drive, NULL,
-							pc->cur_pos, temp);
-					printk(KERN_ERR "%s: transferred %d of "
-							"%d bytes\n",
-							drive->name,
-							temp, bcount);
-				}
-				pc->xferred += temp;
-				pc->cur_pos += temp;
-				ide_pad_transfer(drive, 0, bcount - temp);
+
+				ide_pad_transfer(drive, 0, bcount);
 				goto next_irq;
 			}
 			debug_log("The device wants to send us more data than "
@@ -461,14 +420,13 @@ cmd_finished:
 	} else
 		xferfunc = tp_ops->output_data;
 
-	if ((drive->media == ide_floppy && !scsi && !pc->buf) ||
-	    (drive->media == ide_tape && !scsi && pc->bh) ||
-	    (scsi && pc->sg)) {
+	if ((drive->media == ide_floppy && !pc->buf) ||
+	    (drive->media == ide_tape && pc->bh)) {
 		int done = drive->pc_io_buffers(drive, pc, bcount,
 				  !!(pc->flags & PC_FLAG_WRITING));
 
 		/* FIXME: don't do partial completions */
-		if (drive->media == ide_floppy && !scsi)
+		if (drive->media == ide_floppy)
 			ide_end_request(drive, 1, done >> 9);
 	} else
 		xferfunc(drive, NULL, pc->cur_pos, bcount);
@@ -481,7 +439,7 @@ cmd_finished:
 		  rq->cmd[0], bcount);
 next_irq:
 	/* And set the interrupt handler again */
-	ide_set_handler(drive, ide_pc_intr, timeout, expiry);
+	ide_set_handler(drive, ide_pc_intr, timeout, NULL);
 	return ide_started;
 }
 
diff --git a/include/linux/ide.h b/include/linux/ide.h
index e20e0b5..257524e 100644
--- a/include/linux/ide.h
+++ b/include/linux/ide.h
@@ -1248,12 +1248,6 @@ int ide_set_media_lock(ide_drive_t *, struct gendisk *, int);
 void ide_create_request_sense_cmd(ide_drive_t *, struct ide_atapi_pc *);
 void ide_retry_pc(ide_drive_t *, struct gendisk *);
 
-static inline unsigned long ide_scsi_get_timeout(struct ide_atapi_pc *pc)
-{
-	return max_t(unsigned long, WAIT_CMD, pc->timeout - jiffies);
-}
-
-int ide_scsi_expiry(ide_drive_t *);
 int ide_cd_expiry(ide_drive_t *);
 
 int ide_cd_get_xferlen(struct request *);
-- 
1.6.0.4

