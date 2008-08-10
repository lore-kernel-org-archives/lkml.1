Return-Path: <linux-kernel-owner+w=401wt.eu-S1757749AbYHJPoj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757749AbYHJPoj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Aug 2008 11:44:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756435AbYHJPj6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Aug 2008 11:39:58 -0400
Received: from mu-out-0910.google.com ([209.85.134.188]:2609 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756383AbYHJPj4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Aug 2008 11:39:56 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=jHDgtXyakvI8jbVTz1m0QqaTGQPrLfRVVFHGPxvmfPo/4jgawGSIXty86h/Ab5uzrr
         6/t3peMS7wYCSPsUHDoG54KMJ1rOwb8K8Kqi6yErFl14gHaSGMEkKsIUa7SN1YpcZPJg
         7VKFRX0qjVRssyP4+fAD898x57MZDrSPttMYY=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: Borislav Petkov <petkovbb@gmail.com>,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Date: Sun, 10 Aug 2008 17:37:43 +0200
Message-Id: <20080810153743.16255.23207.sendpatchset@localhost.localdomain>
In-Reply-To: <20080810153527.16255.2504.sendpatchset@localhost.localdomain>
References: <20080810153527.16255.2504.sendpatchset@localhost.localdomain>
Subject: [PATCH 19/22] ide: add ide_retry_pc() helper
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Add ide_create_request_sense_cmd() and ide_retry_pc() helpers
  and convert ide-{atapi,floppy,tape}.c to use them.

* Remove no longer used ide*_create_request_sense_cmd(),
  ide*_retry_pc() and 'retry_pc' argument from ide_pc_intr().

* Make ide_queue_pc_head() static.

There should be no functional changes caused by this patch.

Cc: Borislav Petkov <petkovbb@gmail.com>
Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/ide-atapi.c        |   39 ++++++++++++++++++++++++++++++++++-----
 drivers/ide/ide-floppy.c       |   25 +------------------------
 drivers/ide/ide-floppy.h       |    1 -
 drivers/ide/ide-floppy_ioctl.c |    2 +-
 drivers/ide/ide-tape.c         |   29 ++---------------------------
 drivers/scsi/ide-scsi.c        |    2 +-
 include/linux/ide.h            |    5 ++---
 7 files changed, 41 insertions(+), 62 deletions(-)

Index: b/drivers/ide/ide-atapi.c
===================================================================
--- a/drivers/ide/ide-atapi.c
+++ b/drivers/ide/ide-atapi.c
@@ -124,8 +124,8 @@ EXPORT_SYMBOL_GPL(ide_init_pc);
  * the current request, so that it will be processed immediately, on the next
  * pass through the driver.
  */
-void ide_queue_pc_head(ide_drive_t *drive, struct gendisk *disk,
-		       struct ide_atapi_pc *pc, struct request *rq)
+static void ide_queue_pc_head(ide_drive_t *drive, struct gendisk *disk,
+			      struct ide_atapi_pc *pc, struct request *rq)
 {
 	blk_rq_init(NULL, rq);
 	rq->cmd_type = REQ_TYPE_SPECIAL;
@@ -137,7 +137,6 @@ void ide_queue_pc_head(ide_drive_t *driv
 		rq->cmd[13] = REQ_IDETAPE_PC1;
 	ide_do_drive_cmd(drive, rq);
 }
-EXPORT_SYMBOL_GPL(ide_queue_pc_head);
 
 /*
  * Add a special packet command request to the tail of the request queue,
@@ -203,6 +202,37 @@ int ide_set_media_lock(ide_drive_t *driv
 }
 EXPORT_SYMBOL_GPL(ide_set_media_lock);
 
+void ide_create_request_sense_cmd(ide_drive_t *drive, struct ide_atapi_pc *pc)
+{
+	ide_init_pc(pc);
+	pc->c[0] = REQUEST_SENSE;
+	if (drive->media == ide_floppy) {
+		pc->c[4] = 255;
+		pc->req_xfer = 18;
+	} else {
+		pc->c[4] = 20;
+		pc->req_xfer = 20;
+	}
+}
+EXPORT_SYMBOL_GPL(ide_create_request_sense_cmd);
+
+/*
+ * Called when an error was detected during the last packet command.
+ * We queue a request sense packet command in the head of the request list.
+ */
+void ide_retry_pc(ide_drive_t *drive, struct gendisk *disk)
+{
+	struct request *rq = &drive->request_sense_rq;
+	struct ide_atapi_pc *pc = &drive->request_sense_pc;
+
+	(void)ide_read_error(drive);
+	ide_create_request_sense_cmd(drive, pc);
+	if (drive->media == ide_tape)
+		set_bit(IDE_AFLAG_IGNORE_DSC, &drive->atapi_flags);
+	ide_queue_pc_head(drive, disk, pc, rq);
+}
+EXPORT_SYMBOL_GPL(ide_retry_pc);
+
 int ide_scsi_expiry(ide_drive_t *drive)
 {
 	struct ide_atapi_pc *pc = drive->pc;
@@ -219,7 +249,6 @@ EXPORT_SYMBOL_GPL(ide_scsi_expiry);
 /* TODO: unify the code thus making some arguments go away */
 ide_startstop_t ide_pc_intr(ide_drive_t *drive, ide_handler_t *handler,
 	void (*update_buffers)(ide_drive_t *, struct ide_atapi_pc *),
-	void (*retry_pc)(ide_drive_t *),
 	int (*io_buffers)(ide_drive_t *, struct ide_atapi_pc *, unsigned, int))
 {
 	struct ide_atapi_pc *pc = drive->pc;
@@ -299,7 +328,7 @@ ide_startstop_t ide_pc_intr(ide_drive_t 
 			debug_log("[cmd %x]: check condition\n", rq->cmd[0]);
 
 			/* Retry operation */
-			retry_pc(drive);
+			ide_retry_pc(drive, rq->rq_disk);
 
 			/* queued, but not started */
 			return ide_stopped;
Index: b/drivers/ide/ide-floppy.c
===================================================================
--- a/drivers/ide/ide-floppy.c
+++ b/drivers/ide/ide-floppy.c
@@ -192,34 +192,11 @@ static void ide_floppy_callback(ide_driv
 	idefloppy_end_request(drive, uptodate, 0);
 }
 
-void ide_floppy_create_request_sense_cmd(struct ide_atapi_pc *pc)
-{
-	ide_init_pc(pc);
-	pc->c[0] = GPCMD_REQUEST_SENSE;
-	pc->c[4] = 255;
-	pc->req_xfer = 18;
-}
-
-/*
- * Called when an error was detected during the last packet command. We queue a
- * request sense packet command in the head of the request list.
- */
-static void idefloppy_retry_pc(ide_drive_t *drive)
-{
-	struct ide_floppy_obj *floppy = drive->driver_data;
-	struct request *rq = &drive->request_sense_rq;
-	struct ide_atapi_pc *pc = &drive->request_sense_pc;
-
-	(void)ide_read_error(drive);
-	ide_floppy_create_request_sense_cmd(pc);
-	ide_queue_pc_head(drive, floppy->disk, pc, rq);
-}
-
 /* The usual interrupt handler called during a packet command. */
 static ide_startstop_t idefloppy_pc_intr(ide_drive_t *drive)
 {
 	return ide_pc_intr(drive, idefloppy_pc_intr, idefloppy_update_buffers,
-			   idefloppy_retry_pc, ide_io_buffers);
+			   ide_io_buffers);
 }
 
 /*
Index: b/drivers/ide/ide-floppy.h
===================================================================
--- a/drivers/ide/ide-floppy.h
+++ b/drivers/ide/ide-floppy.h
@@ -49,7 +49,6 @@ typedef struct ide_floppy_obj {
 /* ide-floppy.c */
 void ide_floppy_create_mode_sense_cmd(struct ide_atapi_pc *, u8);
 void ide_floppy_create_read_capacity_cmd(struct ide_atapi_pc *);
-void ide_floppy_create_request_sense_cmd(struct ide_atapi_pc *);
 
 /* ide-floppy_ioctl.c */
 int ide_floppy_format_ioctl(ide_drive_t *, struct file *, unsigned int,
Index: b/drivers/ide/ide-floppy_ioctl.c
===================================================================
--- a/drivers/ide/ide-floppy_ioctl.c
+++ b/drivers/ide/ide-floppy_ioctl.c
@@ -195,7 +195,7 @@ static int ide_floppy_get_format_progres
 	int progress_indication = 0x10000;
 
 	if (drive->atapi_flags & IDE_AFLAG_SRFP) {
-		ide_floppy_create_request_sense_cmd(&pc);
+		ide_create_request_sense_cmd(drive, &pc);
 		if (ide_queue_pc_tail(drive, floppy->disk, &pc))
 			return -EIO;
 
Index: b/drivers/ide/ide-tape.c
===================================================================
--- a/drivers/ide/ide-tape.c
+++ b/drivers/ide/ide-tape.c
@@ -581,31 +581,6 @@ static void ide_tape_callback(ide_drive_
 	idetape_end_request(drive, uptodate, 0);
 }
 
-static void idetape_create_request_sense_cmd(struct ide_atapi_pc *pc)
-{
-	ide_init_pc(pc);
-	pc->c[0] = REQUEST_SENSE;
-	pc->c[4] = 20;
-	pc->req_xfer = 20;
-}
-
-/*
- *	idetape_retry_pc is called when an error was detected during the
- *	last packet command. We queue a request sense packet command in
- *	the head of the request list.
- */
-static void idetape_retry_pc(ide_drive_t *drive)
-{
-	struct ide_tape_obj *tape = drive->driver_data;
-	struct request *rq = &drive->request_sense_rq;
-	struct ide_atapi_pc *pc = &drive->request_sense_pc;
-
-	(void)ide_read_error(drive);
-	idetape_create_request_sense_cmd(pc);
-	set_bit(IDE_AFLAG_IGNORE_DSC, &drive->atapi_flags);
-	ide_queue_pc_head(drive, tape->disk, pc, rq);
-}
-
 /*
  * Postpone the current request so that ide.c will be able to service requests
  * from another device on the same hwgroup while we are polling for DSC.
@@ -653,7 +628,7 @@ static int ide_tape_io_buffers(ide_drive
 static ide_startstop_t idetape_pc_intr(ide_drive_t *drive)
 {
 	return ide_pc_intr(drive, idetape_pc_intr, idetape_update_buffers,
-			   idetape_retry_pc, ide_tape_io_buffers);
+			   ide_tape_io_buffers);
 }
 
 /*
@@ -789,7 +764,7 @@ static ide_startstop_t idetape_media_acc
 				printk(KERN_ERR "ide-tape: %s: I/O error, ",
 						tape->name);
 			/* Retry operation */
-			idetape_retry_pc(drive);
+			ide_retry_pc(drive, tape->disk);
 			return ide_stopped;
 		}
 		pc->error = 0;
Index: b/drivers/scsi/ide-scsi.c
===================================================================
--- a/drivers/scsi/ide-scsi.c
+++ b/drivers/scsi/ide-scsi.c
@@ -275,7 +275,7 @@ static int idescsi_end_request (ide_driv
  */
 static ide_startstop_t idescsi_pc_intr (ide_drive_t *drive)
 {
-	return ide_pc_intr(drive, idescsi_pc_intr, NULL, NULL, ide_io_buffers);
+	return ide_pc_intr(drive, idescsi_pc_intr, NULL, ide_io_buffers);
 }
 
 static ide_startstop_t idescsi_transfer_pc(ide_drive_t *drive)
Index: b/include/linux/ide.h
===================================================================
--- a/include/linux/ide.h
+++ b/include/linux/ide.h
@@ -1158,13 +1158,13 @@ enum {
 	REQ_IDETAPE_WRITE	= (1 << 3),
 };
 
-void ide_queue_pc_head(ide_drive_t *, struct gendisk *, struct ide_atapi_pc *,
-		       struct request *);
 int ide_queue_pc_tail(ide_drive_t *, struct gendisk *, struct ide_atapi_pc *);
 
 int ide_do_test_unit_ready(ide_drive_t *, struct gendisk *);
 int ide_do_start_stop(ide_drive_t *, struct gendisk *, int);
 int ide_set_media_lock(ide_drive_t *, struct gendisk *, int);
+void ide_create_request_sense_cmd(ide_drive_t *, struct ide_atapi_pc *);
+void ide_retry_pc(ide_drive_t *, struct gendisk *);
 
 static inline unsigned long ide_scsi_get_timeout(struct ide_atapi_pc *pc)
 {
@@ -1175,7 +1175,6 @@ int ide_scsi_expiry(ide_drive_t *);
 
 ide_startstop_t ide_pc_intr(ide_drive_t *drive, ide_handler_t *handler,
 	void (*update_buffers)(ide_drive_t *, struct ide_atapi_pc *),
-	void (*retry_pc)(ide_drive_t *),
 	int (*io_buffers)(ide_drive_t *, struct ide_atapi_pc *, unsigned int,
 			   int));
 ide_startstop_t ide_transfer_pc(ide_drive_t *,
