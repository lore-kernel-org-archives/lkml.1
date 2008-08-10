Return-Path: <linux-kernel-owner+w=401wt.eu-S1756429AbYHJPoy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756429AbYHJPoy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Aug 2008 11:44:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756079AbYHJPkF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Aug 2008 11:40:05 -0400
Received: from mu-out-0910.google.com ([209.85.134.187]:3925 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755721AbYHJPkC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Aug 2008 11:40:02 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=xf9GTQchujsavk1qVXZ34CHHOycph97LroYkENho5KB5obkDzUSqQlLoGaObR2HmK+
         UHyqEeqWPxfHKxq/4HATaeex4pW17HtdiC47cAndrFE3g1egtPTmCdOls9oYM4/N+jXQ
         LnHfeg0RHf6jpekcNxhWpDQrxr0/XaOiUEi4I=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: Borislav Petkov <petkovbb@gmail.com>,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Date: Sun, 10 Aug 2008 17:37:51 +0200
Message-Id: <20080810153751.16255.87331.sendpatchset@localhost.localdomain>
In-Reply-To: <20080810153527.16255.2504.sendpatchset@localhost.localdomain>
References: <20080810153527.16255.2504.sendpatchset@localhost.localdomain>
Subject: [PATCH 20/22] ide: add ->pc_{update,io}_buffers methods
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add ->pc_{update,io}_buffers methods to ide_drive_t and use
them instead of {update,io}_buffers ide_pc_intr() arguments.

There should be no functional changes caused by this patch.

Cc: Borislav Petkov <petkovbb@gmail.com>
Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/ide-atapi.c  |   14 ++++++--------
 drivers/ide/ide-floppy.c |    7 ++++---
 drivers/ide/ide-tape.c   |    7 ++++---
 drivers/scsi/ide-scsi.c  |    6 ++++--
 include/linux/ide.h      |    9 +++++----
 5 files changed, 23 insertions(+), 20 deletions(-)

Index: b/drivers/ide/ide-atapi.c
===================================================================
--- a/drivers/ide/ide-atapi.c
+++ b/drivers/ide/ide-atapi.c
@@ -246,10 +246,7 @@ int ide_scsi_expiry(ide_drive_t *drive)
 }
 EXPORT_SYMBOL_GPL(ide_scsi_expiry);
 
-/* TODO: unify the code thus making some arguments go away */
-ide_startstop_t ide_pc_intr(ide_drive_t *drive, ide_handler_t *handler,
-	void (*update_buffers)(ide_drive_t *, struct ide_atapi_pc *),
-	int (*io_buffers)(ide_drive_t *, struct ide_atapi_pc *, unsigned, int))
+ide_startstop_t ide_pc_intr(ide_drive_t *drive, ide_handler_t *handler)
 {
 	struct ide_atapi_pc *pc = drive->pc;
 	ide_hwif_t *hwif = drive->hwif;
@@ -290,8 +287,8 @@ ide_startstop_t ide_pc_intr(ide_drive_t 
 			pc->flags |= PC_FLAG_DMA_ERROR;
 		} else {
 			pc->xferred = pc->req_xfer;
-			if (update_buffers)
-				update_buffers(drive, pc);
+			if (drive->pc_update_buffers)
+				drive->pc_update_buffers(drive, pc);
 		}
 		debug_log("%s: DMA finished\n", drive->name);
 	}
@@ -386,7 +383,8 @@ cmd_finished:
 					temp = 0;
 				if (temp) {
 					if (pc->sg)
-						io_buffers(drive, pc, temp, 0);
+						drive->pc_io_buffers(drive, pc,
+								     temp, 0);
 					else
 						tp_ops->input_data(drive, NULL,
 							pc->cur_pos, temp);
@@ -410,7 +408,7 @@ cmd_finished:
 	if ((drive->media == ide_floppy && !scsi && !pc->buf) ||
 	    (drive->media == ide_tape && !scsi && pc->bh) ||
 	    (scsi && pc->sg)) {
-		int done = io_buffers(drive, pc, bcount,
+		int done = drive->pc_io_buffers(drive, pc, bcount,
 				  !!(pc->flags & PC_FLAG_WRITING));
 
 		/* FIXME: don't do partial completions */
Index: b/drivers/ide/ide-floppy.c
===================================================================
--- a/drivers/ide/ide-floppy.c
+++ b/drivers/ide/ide-floppy.c
@@ -195,8 +195,7 @@ static void ide_floppy_callback(ide_driv
 /* The usual interrupt handler called during a packet command. */
 static ide_startstop_t idefloppy_pc_intr(ide_drive_t *drive)
 {
-	return ide_pc_intr(drive, idefloppy_pc_intr, idefloppy_update_buffers,
-			   ide_io_buffers);
+	return ide_pc_intr(drive, idefloppy_pc_intr);
 }
 
 /*
@@ -635,7 +634,9 @@ static void idefloppy_setup(ide_drive_t 
 
 	*((u16 *)&gcw) = id[ATA_ID_CONFIG];
 
-	drive->pc_callback = ide_floppy_callback;
+	drive->pc_callback	 = ide_floppy_callback;
+	drive->pc_update_buffers = idefloppy_update_buffers;
+	drive->pc_io_buffers	 = ide_io_buffers;
 
 	if (((gcw[0] & 0x60) >> 5) == 1)
 		drive->atapi_flags |= IDE_AFLAG_DRQ_INTERRUPT;
Index: b/drivers/ide/ide-tape.c
===================================================================
--- a/drivers/ide/ide-tape.c
+++ b/drivers/ide/ide-tape.c
@@ -627,8 +627,7 @@ static int ide_tape_io_buffers(ide_drive
  */
 static ide_startstop_t idetape_pc_intr(ide_drive_t *drive)
 {
-	return ide_pc_intr(drive, idetape_pc_intr, idetape_update_buffers,
-			   ide_tape_io_buffers);
+	return ide_pc_intr(drive, idetape_pc_intr);
 }
 
 /*
@@ -2210,7 +2209,9 @@ static void idetape_setup(ide_drive_t *d
 	u8 gcw[2];
 	u16 *ctl = (u16 *)&tape->caps[12];
 
-	drive->pc_callback = ide_tape_callback;
+	drive->pc_callback	 = ide_tape_callback;
+	drive->pc_update_buffers = idetape_update_buffers;
+	drive->pc_io_buffers	 = ide_tape_io_buffers;
 
 	spin_lock_init(&tape->lock);
 	drive->dsc_overlap = 1;
Index: b/drivers/scsi/ide-scsi.c
===================================================================
--- a/drivers/scsi/ide-scsi.c
+++ b/drivers/scsi/ide-scsi.c
@@ -275,7 +275,7 @@ static int idescsi_end_request (ide_driv
  */
 static ide_startstop_t idescsi_pc_intr (ide_drive_t *drive)
 {
-	return ide_pc_intr(drive, idescsi_pc_intr, NULL, ide_io_buffers);
+	return ide_pc_intr(drive, idescsi_pc_intr);
 }
 
 static ide_startstop_t idescsi_transfer_pc(ide_drive_t *drive)
@@ -407,7 +407,9 @@ static void idescsi_setup (ide_drive_t *
 	set_bit(IDESCSI_LOG_CMD, &scsi->log);
 #endif /* IDESCSI_DEBUG_LOG */
 
-	drive->pc_callback = ide_scsi_callback;
+	drive->pc_callback	 = ide_scsi_callback;
+	drive->pc_update_buffers = NULL;
+	drive->pc_io_buffers	 = ide_io_buffers;
 
 	ide_proc_register_driver(drive, scsi->driver);
 }
Index: b/include/linux/ide.h
===================================================================
--- a/include/linux/ide.h
+++ b/include/linux/ide.h
@@ -552,6 +552,10 @@ struct ide_drive_s {
 	/* callback for packet commands */
 	void (*pc_callback)(struct ide_drive_s *, int);
 
+	void (*pc_update_buffers)(struct ide_drive_s *, struct ide_atapi_pc *);
+	int  (*pc_io_buffers)(struct ide_drive_s *, struct ide_atapi_pc *,
+			      unsigned int, int);
+
 	unsigned long atapi_flags;
 
 	struct ide_atapi_pc request_sense_pc;
@@ -1173,10 +1177,7 @@ static inline unsigned long ide_scsi_get
 
 int ide_scsi_expiry(ide_drive_t *);
 
-ide_startstop_t ide_pc_intr(ide_drive_t *drive, ide_handler_t *handler,
-	void (*update_buffers)(ide_drive_t *, struct ide_atapi_pc *),
-	int (*io_buffers)(ide_drive_t *, struct ide_atapi_pc *, unsigned int,
-			   int));
+ide_startstop_t ide_pc_intr(ide_drive_t *drive, ide_handler_t *handler);
 ide_startstop_t ide_transfer_pc(ide_drive_t *,
 				ide_handler_t *, unsigned int, ide_expiry_t *);
 ide_startstop_t ide_issue_pc(ide_drive_t *,
