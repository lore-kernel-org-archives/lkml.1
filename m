Return-Path: <linux-kernel-owner+w=401wt.eu-S1756766AbYHJPnk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756766AbYHJPnk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Aug 2008 11:43:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756247AbYHJPjh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Aug 2008 11:39:37 -0400
Received: from mu-out-0910.google.com ([209.85.134.187]:3925 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756221AbYHJPjg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Aug 2008 11:39:36 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=rkZw1ypQkfAxu31uOnioy1EVsaOpx26K3lbyVnD5rUCaJDNdAn8QU+XVwAPUxHJWK5
         3zpQpBG2FPIdDXyIf3vsJ8yA9vWoMv3k8lMnym+PkMA/a8q1b/wWkcn6A8N2knHaBCkC
         +DWZhP2iTpmlwBbLGmDnyZEda9BRU1Yj7AICk=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: Borislav Petkov <petkovbb@gmail.com>,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Date: Sun, 10 Aug 2008 17:37:21 +0200
Message-Id: <20080810153721.16255.7150.sendpatchset@localhost.localdomain>
In-Reply-To: <20080810153527.16255.2504.sendpatchset@localhost.localdomain>
References: <20080810153527.16255.2504.sendpatchset@localhost.localdomain>
Subject: [PATCH 16/22] ide: add pointer to the current packet command to ide_drive_t
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Add pointer to the current packet command (struct ide_atapi_pc *pc)
  to ide_drive_t and use it instead of the pointer in struct ide_*_obj.

* Use drive->pc in ide_{issue,transfer}_pc() and ide_pc_intr()
  instead of 'pc' argument.

There should be no functional changes caused by this patch.

Cc: Borislav Petkov <petkovbb@gmail.com>
Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/ide-atapi.c  |    9 ++++---
 drivers/ide/ide-floppy.c |   20 ++++++----------
 drivers/ide/ide-floppy.h |    2 -
 drivers/ide/ide-tape.c   |   31 ++++++++-----------------
 drivers/scsi/ide-scsi.c  |   58 ++++++++++++++++++++++-------------------------
 include/linux/ide.h      |   10 +++++---
 6 files changed, 60 insertions(+), 70 deletions(-)

Index: b/drivers/ide/ide-atapi.c
===================================================================
--- a/drivers/ide/ide-atapi.c
+++ b/drivers/ide/ide-atapi.c
@@ -204,12 +204,13 @@ int ide_set_media_lock(ide_drive_t *driv
 EXPORT_SYMBOL_GPL(ide_set_media_lock);
 
 /* TODO: unify the code thus making some arguments go away */
-ide_startstop_t ide_pc_intr(ide_drive_t *drive, struct ide_atapi_pc *pc,
+ide_startstop_t ide_pc_intr(ide_drive_t *drive,
 	ide_handler_t *handler, unsigned int timeout, ide_expiry_t *expiry,
 	void (*update_buffers)(ide_drive_t *, struct ide_atapi_pc *),
 	void (*retry_pc)(ide_drive_t *),
 	int (*io_buffers)(ide_drive_t *, struct ide_atapi_pc *, unsigned, int))
 {
+	struct ide_atapi_pc *pc = drive->pc;
 	ide_hwif_t *hwif = drive->hwif;
 	struct request *rq = hwif->hwgroup->rq;
 	const struct ide_tp_ops *tp_ops = hwif->tp_ops;
@@ -416,10 +417,11 @@ static u8 ide_wait_ireason(ide_drive_t *
 	return ireason;
 }
 
-ide_startstop_t ide_transfer_pc(ide_drive_t *drive, struct ide_atapi_pc *pc,
+ide_startstop_t ide_transfer_pc(ide_drive_t *drive,
 				ide_handler_t *handler, unsigned int timeout,
 				ide_expiry_t *expiry)
 {
+	struct ide_atapi_pc *pc = drive->pc;
 	ide_hwif_t *hwif = drive->hwif;
 	struct request *rq = hwif->hwgroup->rq;
 	ide_startstop_t startstop;
@@ -458,10 +460,11 @@ ide_startstop_t ide_transfer_pc(ide_driv
 }
 EXPORT_SYMBOL_GPL(ide_transfer_pc);
 
-ide_startstop_t ide_issue_pc(ide_drive_t *drive, struct ide_atapi_pc *pc,
+ide_startstop_t ide_issue_pc(ide_drive_t *drive,
 			     ide_handler_t *handler, unsigned int timeout,
 			     ide_expiry_t *expiry)
 {
+	struct ide_atapi_pc *pc = drive->pc;
 	ide_hwif_t *hwif = drive->hwif;
 	u16 bcount;
 	u8 dma = 0;
Index: b/drivers/ide/ide-floppy.c
===================================================================
--- a/drivers/ide/ide-floppy.c
+++ b/drivers/ide/ide-floppy.c
@@ -158,7 +158,7 @@ static void idefloppy_update_buffers(ide
 static void ide_floppy_callback(ide_drive_t *drive, int dsc)
 {
 	idefloppy_floppy_t *floppy = drive->driver_data;
-	struct ide_atapi_pc *pc = floppy->pc;
+	struct ide_atapi_pc *pc = drive->pc;
 	int uptodate = pc->error ? 0 : 1;
 
 	debug_log("Reached %s\n", __func__);
@@ -170,7 +170,7 @@ static void ide_floppy_callback(ide_driv
 	    (pc->rq && blk_pc_request(pc->rq)))
 		uptodate = 1; /* FIXME */
 	else if (pc->c[0] == GPCMD_REQUEST_SENSE) {
-		u8 *buf = floppy->pc->buf;
+		u8 *buf = pc->buf;
 
 		if (!pc->error) {
 			floppy->sense_key = buf[2] & 0x0F;
@@ -218,9 +218,7 @@ static void idefloppy_retry_pc(ide_drive
 /* The usual interrupt handler called during a packet command. */
 static ide_startstop_t idefloppy_pc_intr(ide_drive_t *drive)
 {
-	idefloppy_floppy_t *floppy = drive->driver_data;
-
-	return ide_pc_intr(drive, floppy->pc, idefloppy_pc_intr,
+	return ide_pc_intr(drive, idefloppy_pc_intr,
 			   WAIT_FLOPPY_CMD, NULL, idefloppy_update_buffers,
 			   idefloppy_retry_pc, ide_io_buffers);
 }
@@ -233,10 +231,8 @@ static ide_startstop_t idefloppy_pc_intr
  */
 static int idefloppy_transfer_pc(ide_drive_t *drive)
 {
-	idefloppy_floppy_t *floppy = drive->driver_data;
-
 	/* Send the actual packet */
-	drive->hwif->tp_ops->output_data(drive, NULL, floppy->pc->c, 12);
+	drive->hwif->tp_ops->output_data(drive, NULL, drive->pc->c, 12);
 
 	/* Timeout for the packet command */
 	return WAIT_FLOPPY_CMD;
@@ -250,7 +246,6 @@ static int idefloppy_transfer_pc(ide_dri
 static ide_startstop_t idefloppy_start_pc_transfer(ide_drive_t *drive)
 {
 	idefloppy_floppy_t *floppy = drive->driver_data;
-	struct ide_atapi_pc *pc = floppy->pc;
 	ide_expiry_t *expiry;
 	unsigned int timeout;
 
@@ -270,7 +265,7 @@ static ide_startstop_t idefloppy_start_p
 		expiry = NULL;
 	}
 
-	return ide_transfer_pc(drive, pc, idefloppy_pc_intr, timeout, expiry);
+	return ide_transfer_pc(drive, idefloppy_pc_intr, timeout, expiry);
 }
 
 static void ide_floppy_report_error(idefloppy_floppy_t *floppy,
@@ -297,8 +292,9 @@ static ide_startstop_t idefloppy_issue_p
 	if (floppy->failed_pc == NULL &&
 	    pc->c[0] != GPCMD_REQUEST_SENSE)
 		floppy->failed_pc = pc;
+
 	/* Set the current packet command */
-	floppy->pc = pc;
+	drive->pc = pc;
 
 	if (pc->retries > IDEFLOPPY_MAX_PC_RETRIES) {
 		if (!(pc->flags & PC_FLAG_SUPPRESS_ERROR))
@@ -315,7 +311,7 @@ static ide_startstop_t idefloppy_issue_p
 
 	pc->retries++;
 
-	return ide_issue_pc(drive, pc, idefloppy_start_pc_transfer,
+	return ide_issue_pc(drive, idefloppy_start_pc_transfer,
 			    WAIT_FLOPPY_CMD, NULL);
 }
 
Index: b/drivers/ide/ide-floppy.h
===================================================================
--- a/drivers/ide/ide-floppy.h
+++ b/drivers/ide/ide-floppy.h
@@ -13,8 +13,6 @@ typedef struct ide_floppy_obj {
 	struct kref	kref;
 	unsigned int	openers;	/* protected by BKL for now */
 
-	/* Current packet command */
-	struct ide_atapi_pc *pc;
 	/* Last failed packet command */
 	struct ide_atapi_pc *failed_pc;
 	/* used for blk_{fs,pc}_request() requests */
Index: b/drivers/ide/ide-tape.c
===================================================================
--- a/drivers/ide/ide-tape.c
+++ b/drivers/ide/ide-tape.c
@@ -172,15 +172,11 @@ typedef struct ide_tape_obj {
 	struct kref	kref;
 
 	/*
-	 *	pc points to the current processed packet command.
-	 *
 	 *	failed_pc points to the last failed packet command, or contains
 	 *	NULL if we do not need to retry any packet command. This is
 	 *	required since an additional packet command is needed before the
 	 *	retry, to get detailed information on what went wrong.
 	 */
-	/* Current packet command */
-	struct ide_atapi_pc *pc;
 	/* Last failed packet command */
 	struct ide_atapi_pc *failed_pc;
 	/* used by REQ_IDETAPE_{READ,WRITE} requests */
@@ -527,7 +523,7 @@ static void ide_tape_handle_dsc(ide_driv
 static void ide_tape_callback(ide_drive_t *drive, int dsc)
 {
 	idetape_tape_t *tape = drive->driver_data;
-	struct ide_atapi_pc *pc = tape->pc;
+	struct ide_atapi_pc *pc = drive->pc;
 	int uptodate = pc->error ? 0 : 1;
 
 	debug_log(DBG_PROCS, "Enter %s\n", __func__);
@@ -563,7 +559,7 @@ static void ide_tape_callback(ide_drive_
 		if (pc->error)
 			uptodate = pc->error;
 	} else if (pc->c[0] == READ_POSITION && uptodate) {
-		u8 *readpos = tape->pc->buf;
+		u8 *readpos = pc->buf;
 
 		debug_log(DBG_SENSE, "BOP - %s\n",
 				(readpos[0] & 0x80) ? "Yes" : "No");
@@ -659,9 +655,7 @@ static int ide_tape_io_buffers(ide_drive
  */
 static ide_startstop_t idetape_pc_intr(ide_drive_t *drive)
 {
-	idetape_tape_t *tape = drive->driver_data;
-
-	return ide_pc_intr(drive, tape->pc, idetape_pc_intr, WAIT_TAPE_CMD,
+	return ide_pc_intr(drive, idetape_pc_intr, WAIT_TAPE_CMD,
 			   NULL, idetape_update_buffers, idetape_retry_pc,
 			   ide_tape_io_buffers);
 }
@@ -669,7 +663,7 @@ static ide_startstop_t idetape_pc_intr(i
 /*
  * Packet Command Interface
  *
- * The current Packet Command is available in tape->pc, and will not change
+ * The current Packet Command is available in drive->pc, and will not change
  * until we finish handling it. Each packet command is associated with a
  * callback function that will be called when the command is finished.
  *
@@ -704,10 +698,7 @@ static ide_startstop_t idetape_pc_intr(i
  */
 static ide_startstop_t idetape_transfer_pc(ide_drive_t *drive)
 {
-	idetape_tape_t *tape = drive->driver_data;
-
-	return ide_transfer_pc(drive, tape->pc, idetape_pc_intr,
-			       WAIT_TAPE_CMD, NULL);
+	return ide_transfer_pc(drive, idetape_pc_intr, WAIT_TAPE_CMD, NULL);
 }
 
 static ide_startstop_t idetape_issue_pc(ide_drive_t *drive,
@@ -715,7 +706,7 @@ static ide_startstop_t idetape_issue_pc(
 {
 	idetape_tape_t *tape = drive->driver_data;
 
-	if (tape->pc->c[0] == REQUEST_SENSE &&
+	if (drive->pc->c[0] == REQUEST_SENSE &&
 	    pc->c[0] == REQUEST_SENSE) {
 		printk(KERN_ERR "ide-tape: possible ide-tape.c bug - "
 			"Two request sense in serial were issued\n");
@@ -723,8 +714,9 @@ static ide_startstop_t idetape_issue_pc(
 
 	if (tape->failed_pc == NULL && pc->c[0] != REQUEST_SENSE)
 		tape->failed_pc = pc;
+
 	/* Set the current packet command */
-	tape->pc = pc;
+	drive->pc = pc;
 
 	if (pc->retries > IDETAPE_MAX_PC_RETRIES ||
 		(pc->flags & PC_FLAG_ABORT)) {
@@ -755,8 +747,7 @@ static ide_startstop_t idetape_issue_pc(
 
 	pc->retries++;
 
-	return ide_issue_pc(drive, pc, idetape_transfer_pc,
-			    WAIT_TAPE_CMD, NULL);
+	return ide_issue_pc(drive, idetape_transfer_pc, WAIT_TAPE_CMD, NULL);
 }
 
 /* A mode sense command is used to "sense" tape parameters. */
@@ -790,7 +781,7 @@ static ide_startstop_t idetape_media_acc
 {
 	ide_hwif_t *hwif = drive->hwif;
 	idetape_tape_t *tape = drive->driver_data;
-	struct ide_atapi_pc *pc = tape->pc;
+	struct ide_atapi_pc *pc = drive->pc;
 	u8 stat;
 
 	stat = hwif->tp_ops->read_status(hwif);
@@ -866,7 +857,7 @@ static ide_startstop_t idetape_do_reques
 	}
 
 	/* Retry a failed packet command */
-	if (tape->failed_pc && tape->pc->c[0] == REQUEST_SENSE) {
+	if (tape->failed_pc && drive->pc->c[0] == REQUEST_SENSE) {
 		pc = tape->failed_pc;
 		goto out;
 	}
Index: b/drivers/scsi/ide-scsi.c
===================================================================
--- a/drivers/scsi/ide-scsi.c
+++ b/drivers/scsi/ide-scsi.c
@@ -82,7 +82,6 @@ typedef struct ide_scsi_obj {
 	struct gendisk		*disk;
 	struct Scsi_Host	*host;
 
-	struct ide_atapi_pc *pc;		/* Current packet command */
 	unsigned long transform;		/* SCSI cmd translation layer */
 	unsigned long log;			/* log flags */
 } idescsi_scsi_t;
@@ -140,7 +139,7 @@ static int idescsi_end_request(ide_drive
 static void ide_scsi_callback(ide_drive_t *drive, int dsc)
 {
 	idescsi_scsi_t *scsi = drive_to_idescsi(drive);
-	struct ide_atapi_pc *pc = scsi->pc;
+	struct ide_atapi_pc *pc = drive->pc;
 
 	if (pc->flags & PC_FLAG_TIMEDOUT)
 		debug_log("%s: got timed out packet %lu at %lu\n", __func__,
@@ -267,7 +266,7 @@ static int idescsi_end_request (ide_driv
 	spin_unlock_irqrestore(host->host_lock, flags);
 	kfree(pc);
 	blk_put_request(rq);
-	scsi->pc = NULL;
+	drive->pc = NULL;
 	return 0;
 }
 
@@ -278,8 +277,7 @@ static inline unsigned long get_timeout(
 
 static int idescsi_expiry(ide_drive_t *drive)
 {
-	idescsi_scsi_t *scsi = drive_to_idescsi(drive);
-	struct ide_atapi_pc   *pc   = scsi->pc;
+	struct ide_atapi_pc *pc = drive->pc;
 
 	debug_log("%s called for %lu at %lu\n", __func__,
 		  pc->scsi_cmd->serial_number, jiffies);
@@ -294,19 +292,14 @@ static int idescsi_expiry(ide_drive_t *d
  */
 static ide_startstop_t idescsi_pc_intr (ide_drive_t *drive)
 {
-	idescsi_scsi_t *scsi = drive_to_idescsi(drive);
-	struct ide_atapi_pc *pc = scsi->pc;
-
-	return ide_pc_intr(drive, pc, idescsi_pc_intr, get_timeout(pc),
+	return ide_pc_intr(drive, idescsi_pc_intr, get_timeout(drive->pc),
 			   idescsi_expiry, NULL, NULL, ide_io_buffers);
 }
 
 static ide_startstop_t idescsi_transfer_pc(ide_drive_t *drive)
 {
-	idescsi_scsi_t *scsi = drive_to_idescsi(drive);
-
-	return ide_transfer_pc(drive, scsi->pc, idescsi_pc_intr,
-			       get_timeout(scsi->pc), idescsi_expiry);
+	return ide_transfer_pc(drive, idescsi_pc_intr,
+			       get_timeout(drive->pc), idescsi_expiry);
 }
 
 static inline int idescsi_set_direction(struct ide_atapi_pc *pc)
@@ -351,12 +344,10 @@ static int idescsi_map_sg(ide_drive_t *d
 static ide_startstop_t idescsi_issue_pc(ide_drive_t *drive,
 		struct ide_atapi_pc *pc)
 {
-	idescsi_scsi_t *scsi = drive_to_idescsi(drive);
-
 	/* Set the current packet command */
-	scsi->pc = pc;
+	drive->pc = pc;
 
-	return ide_issue_pc(drive, pc, idescsi_transfer_pc,
+	return ide_issue_pc(drive, idescsi_transfer_pc,
 			    get_timeout(pc), idescsi_expiry);
 }
 
@@ -621,6 +612,8 @@ static int idescsi_eh_abort (struct scsi
 	int		busy;
 	int             ret   = FAILED;
 
+	struct ide_atapi_pc *pc;
+
 	/* In idescsi_eh_abort we try to gently pry our command from the ide subsystem */
 
 	if (test_bit(IDESCSI_LOG_CMD, &scsi->log))
@@ -641,26 +634,27 @@ static int idescsi_eh_abort (struct scsi
 	spin_lock_irq(&ide_lock);
 
 	/* If there is no pc running we're done (our interrupt took care of it) */
-	if (!scsi->pc) {
+	pc = drive->pc;
+	if (pc == NULL) {
 		ret = SUCCESS;
 		goto ide_unlock;
 	}
 
 	/* It's somewhere in flight. Does ide subsystem agree? */
-	if (scsi->pc->scsi_cmd->serial_number == cmd->serial_number && !busy &&
-	    elv_queue_empty(drive->queue) && HWGROUP(drive)->rq != scsi->pc->rq) {
+	if (pc->scsi_cmd->serial_number == cmd->serial_number && !busy &&
+	    elv_queue_empty(drive->queue) && HWGROUP(drive)->rq != pc->rq) {
 		/*
 		 * FIXME - not sure this condition can ever occur
 		 */
 		printk (KERN_ERR "ide-scsi: cmd aborted!\n");
 
-		if (blk_sense_request(scsi->pc->rq))
-			kfree(scsi->pc->buf);
+		if (blk_sense_request(pc->rq))
+			kfree(pc->buf);
 		/* we need to call blk_put_request twice. */
-		blk_put_request(scsi->pc->rq);
-		blk_put_request(scsi->pc->rq);
-		kfree(scsi->pc);
-		scsi->pc = NULL;
+		blk_put_request(pc->rq);
+		blk_put_request(pc->rq);
+		kfree(pc);
+		drive->pc = NULL;
 
 		ret = SUCCESS;
 	}
@@ -682,6 +676,8 @@ static int idescsi_eh_reset (struct scsi
 	int             ready = 0;
 	int             ret   = SUCCESS;
 
+	struct ide_atapi_pc *pc;
+
 	/* In idescsi_eh_reset we forcefully remove the command from the ide subsystem and reset the device. */
 
 	if (test_bit(IDESCSI_LOG_CMD, &scsi->log))
@@ -696,7 +692,9 @@ static int idescsi_eh_reset (struct scsi
 	spin_lock_irq(cmd->device->host->host_lock);
 	spin_lock(&ide_lock);
 
-	if (!scsi->pc || (req = scsi->pc->rq) != HWGROUP(drive)->rq || !HWGROUP(drive)->handler) {
+	pc = drive->pc;
+
+	if (pc == NULL || (req = pc->rq) != HWGROUP(drive)->rq || !HWGROUP(drive)->handler) {
 		printk (KERN_WARNING "ide-scsi: No active request in idescsi_eh_reset\n");
 		spin_unlock(&ide_lock);
 		spin_unlock_irq(cmd->device->host->host_lock);
@@ -707,9 +705,9 @@ static int idescsi_eh_reset (struct scsi
 	if (__blk_end_request(req, -EIO, 0))
 		BUG();
 	if (blk_sense_request(req))
-		kfree(scsi->pc->buf);
-	kfree(scsi->pc);
-	scsi->pc = NULL;
+		kfree(pc->buf);
+	kfree(pc);
+	drive->pc = NULL;
 	blk_put_request(req);
 
 	/* now nuke the drive queue */
Index: b/include/linux/ide.h
===================================================================
--- a/include/linux/ide.h
+++ b/include/linux/ide.h
@@ -321,6 +321,7 @@ typedef enum {
 	ide_started,	/* a drive operation was started, handler was set */
 } ide_startstop_t;
 
+struct ide_atapi_pc;
 struct ide_devset;
 struct ide_driver_s;
 
@@ -481,6 +482,9 @@ struct ide_drive_s {
 	struct device	gendev;
 	struct completion gendev_rel_comp;	/* to deal with device release() */
 
+	/* current packet command */
+	struct ide_atapi_pc *pc;
+
 	/* callback for packet commands */
 	void (*pc_callback)(struct ide_drive_s *, int);
 
@@ -1160,15 +1164,15 @@ int ide_do_test_unit_ready(ide_drive_t *
 int ide_do_start_stop(ide_drive_t *, struct gendisk *, int);
 int ide_set_media_lock(ide_drive_t *, struct gendisk *, int);
 
-ide_startstop_t ide_pc_intr(ide_drive_t *drive, struct ide_atapi_pc *pc,
+ide_startstop_t ide_pc_intr(ide_drive_t *drive,
 	ide_handler_t *handler, unsigned int timeout, ide_expiry_t *expiry,
 	void (*update_buffers)(ide_drive_t *, struct ide_atapi_pc *),
 	void (*retry_pc)(ide_drive_t *),
 	int (*io_buffers)(ide_drive_t *, struct ide_atapi_pc *, unsigned int,
 			   int));
-ide_startstop_t ide_transfer_pc(ide_drive_t *, struct ide_atapi_pc *,
+ide_startstop_t ide_transfer_pc(ide_drive_t *,
 				ide_handler_t *, unsigned int, ide_expiry_t *);
-ide_startstop_t ide_issue_pc(ide_drive_t *, struct ide_atapi_pc *,
+ide_startstop_t ide_issue_pc(ide_drive_t *,
 			     ide_handler_t *, unsigned int, ide_expiry_t *);
 
 ide_startstop_t do_rw_taskfile(ide_drive_t *, ide_task_t *);
