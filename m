Return-Path: <linux-kernel-owner+w=401wt.eu-S1756742AbYHJPn4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756742AbYHJPn4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Aug 2008 11:43:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756297AbYHJPjn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Aug 2008 11:39:43 -0400
Received: from mu-out-0910.google.com ([209.85.134.187]:3925 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755403AbYHJPjl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Aug 2008 11:39:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=YfsWq6fMmHUr/9Yl9iirbEfJ6mSjc+i7D/HpqFjHXbJdqqAUV+zca5twB6wV6hvcDS
         hUTurRZr/DMaFJdYtfavTts/7mS/OxURKcexNz3Tp64sMx7HAxOyd+S9V2MNY/5jA5oG
         QrUjqO7zPCRM+LyhsBKAyPC8vZdPLgd0b2Elc=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: Borislav Petkov <petkovbb@gmail.com>,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Date: Sun, 10 Aug 2008 17:37:29 +0200
Message-Id: <20080810153729.16255.12064.sendpatchset@localhost.localdomain>
In-Reply-To: <20080810153527.16255.2504.sendpatchset@localhost.localdomain>
References: <20080810153527.16255.2504.sendpatchset@localhost.localdomain>
Subject: [PATCH 17/22] ide: drop 'timeout' and 'expiry' arguments from ide_pc_intr()
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Move idescsi_expiry() to ide-atapi.c.

* Move get_timeout() to <linux/ide.h>.

* Drop 'timeout' and 'expiry' arguments from ide_pc_intr().

While at it:

* idescsi_expiry() -> ide_scsi_expiry()

* get_timeout() -> ide_scsi_get_timeout()

There should be no functional changes caused by this patch.

Cc: Borislav Petkov <petkovbb@gmail.com>
Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/ide-atapi.c  |   34 +++++++++++++++++++++++++++-------
 drivers/ide/ide-floppy.c |    3 +--
 drivers/ide/ide-tape.c   |    5 ++---
 drivers/scsi/ide-scsi.c  |   25 ++++---------------------
 include/linux/ide.h      |   10 ++++++++--
 5 files changed, 42 insertions(+), 35 deletions(-)

Index: b/drivers/ide/ide-atapi.c
===================================================================
--- a/drivers/ide/ide-atapi.c
+++ b/drivers/ide/ide-atapi.c
@@ -203,9 +203,21 @@ int ide_set_media_lock(ide_drive_t *driv
 }
 EXPORT_SYMBOL_GPL(ide_set_media_lock);
 
+int ide_scsi_expiry(ide_drive_t *drive)
+{
+	struct ide_atapi_pc *pc = drive->pc;
+
+	debug_log("%s called for %lu at %lu\n", __func__,
+		  pc->scsi_cmd->serial_number, jiffies);
+
+	pc->flags |= PC_FLAG_TIMEDOUT;
+
+	return 0; /* we do not want the IDE subsystem to retry */
+}
+EXPORT_SYMBOL_GPL(ide_scsi_expiry);
+
 /* TODO: unify the code thus making some arguments go away */
-ide_startstop_t ide_pc_intr(ide_drive_t *drive,
-	ide_handler_t *handler, unsigned int timeout, ide_expiry_t *expiry,
+ide_startstop_t ide_pc_intr(ide_drive_t *drive, ide_handler_t *handler,
 	void (*update_buffers)(ide_drive_t *, struct ide_atapi_pc *),
 	void (*retry_pc)(ide_drive_t *),
 	int (*io_buffers)(ide_drive_t *, struct ide_atapi_pc *, unsigned, int))
@@ -215,12 +227,22 @@ ide_startstop_t ide_pc_intr(ide_drive_t 
 	struct request *rq = hwif->hwgroup->rq;
 	const struct ide_tp_ops *tp_ops = hwif->tp_ops;
 	xfer_func_t *xferfunc;
-	unsigned int temp;
+	ide_expiry_t *expiry;
+	unsigned int timeout, temp;
 	u16 bcount;
 	u8 stat, ireason, scsi = drive->scsi, dsc = 0;
 
 	debug_log("Enter %s - interrupt handler\n", __func__);
 
+	if (scsi) {
+		timeout = ide_scsi_get_timeout(pc);
+		expiry = ide_scsi_expiry;
+	} else {
+		timeout = (drive->media == ide_floppy) ? WAIT_FLOPPY_CMD
+						       : WAIT_TAPE_CMD;
+		expiry = NULL;
+	}
+
 	if (pc->flags & PC_FLAG_TIMEDOUT) {
 		drive->pc_callback(drive, 0);
 		return ide_stopped;
@@ -347,9 +369,7 @@ cmd_finished:
 				pc->xferred += temp;
 				pc->cur_pos += temp;
 				ide_pad_transfer(drive, 0, bcount - temp);
-				ide_set_handler(drive, handler, timeout,
-						expiry);
-				return ide_started;
+				goto next_irq;
 			}
 			debug_log("The device wants to send us more data than "
 				  "expected - allowing transfer\n");
@@ -376,7 +396,7 @@ cmd_finished:
 
 	debug_log("[cmd %x] transferred %d bytes on that intr.\n",
 		  rq->cmd[0], bcount);
-
+next_irq:
 	/* And set the interrupt handler again */
 	ide_set_handler(drive, handler, timeout, expiry);
 	return ide_started;
Index: b/drivers/ide/ide-floppy.c
===================================================================
--- a/drivers/ide/ide-floppy.c
+++ b/drivers/ide/ide-floppy.c
@@ -218,8 +218,7 @@ static void idefloppy_retry_pc(ide_drive
 /* The usual interrupt handler called during a packet command. */
 static ide_startstop_t idefloppy_pc_intr(ide_drive_t *drive)
 {
-	return ide_pc_intr(drive, idefloppy_pc_intr,
-			   WAIT_FLOPPY_CMD, NULL, idefloppy_update_buffers,
+	return ide_pc_intr(drive, idefloppy_pc_intr, idefloppy_update_buffers,
 			   idefloppy_retry_pc, ide_io_buffers);
 }
 
Index: b/drivers/ide/ide-tape.c
===================================================================
--- a/drivers/ide/ide-tape.c
+++ b/drivers/ide/ide-tape.c
@@ -655,9 +655,8 @@ static int ide_tape_io_buffers(ide_drive
  */
 static ide_startstop_t idetape_pc_intr(ide_drive_t *drive)
 {
-	return ide_pc_intr(drive, idetape_pc_intr, WAIT_TAPE_CMD,
-			   NULL, idetape_update_buffers, idetape_retry_pc,
-			   ide_tape_io_buffers);
+	return ide_pc_intr(drive, idetape_pc_intr, idetape_update_buffers,
+			   idetape_retry_pc, ide_tape_io_buffers);
 }
 
 /*
Index: b/drivers/scsi/ide-scsi.c
===================================================================
--- a/drivers/scsi/ide-scsi.c
+++ b/drivers/scsi/ide-scsi.c
@@ -270,36 +270,19 @@ static int idescsi_end_request (ide_driv
 	return 0;
 }
 
-static inline unsigned long get_timeout(struct ide_atapi_pc *pc)
-{
-	return max_t(unsigned long, WAIT_CMD, pc->timeout - jiffies);
-}
-
-static int idescsi_expiry(ide_drive_t *drive)
-{
-	struct ide_atapi_pc *pc = drive->pc;
-
-	debug_log("%s called for %lu at %lu\n", __func__,
-		  pc->scsi_cmd->serial_number, jiffies);
-
-	pc->flags |= PC_FLAG_TIMEDOUT;
-
-	return 0;					/* we do not want the ide subsystem to retry */
-}
-
 /*
  *	Our interrupt handler.
  */
 static ide_startstop_t idescsi_pc_intr (ide_drive_t *drive)
 {
-	return ide_pc_intr(drive, idescsi_pc_intr, get_timeout(drive->pc),
-			   idescsi_expiry, NULL, NULL, ide_io_buffers);
+	return ide_pc_intr(drive, idescsi_pc_intr, NULL, NULL, ide_io_buffers);
 }
 
 static ide_startstop_t idescsi_transfer_pc(ide_drive_t *drive)
 {
 	return ide_transfer_pc(drive, idescsi_pc_intr,
-			       get_timeout(drive->pc), idescsi_expiry);
+			       ide_scsi_get_timeout(drive->pc),
+			       ide_scsi_expiry);
 }
 
 static inline int idescsi_set_direction(struct ide_atapi_pc *pc)
@@ -348,7 +331,7 @@ static ide_startstop_t idescsi_issue_pc(
 	drive->pc = pc;
 
 	return ide_issue_pc(drive, idescsi_transfer_pc,
-			    get_timeout(pc), idescsi_expiry);
+			    ide_scsi_get_timeout(pc), ide_scsi_expiry);
 }
 
 /*
Index: b/include/linux/ide.h
===================================================================
--- a/include/linux/ide.h
+++ b/include/linux/ide.h
@@ -1164,8 +1164,14 @@ int ide_do_test_unit_ready(ide_drive_t *
 int ide_do_start_stop(ide_drive_t *, struct gendisk *, int);
 int ide_set_media_lock(ide_drive_t *, struct gendisk *, int);
 
-ide_startstop_t ide_pc_intr(ide_drive_t *drive,
-	ide_handler_t *handler, unsigned int timeout, ide_expiry_t *expiry,
+static inline unsigned long ide_scsi_get_timeout(struct ide_atapi_pc *pc)
+{
+	return max_t(unsigned long, WAIT_CMD, pc->timeout - jiffies);
+}
+
+int ide_scsi_expiry(ide_drive_t *);
+
+ide_startstop_t ide_pc_intr(ide_drive_t *drive, ide_handler_t *handler,
 	void (*update_buffers)(ide_drive_t *, struct ide_atapi_pc *),
 	void (*retry_pc)(ide_drive_t *),
 	int (*io_buffers)(ide_drive_t *, struct ide_atapi_pc *, unsigned int,
