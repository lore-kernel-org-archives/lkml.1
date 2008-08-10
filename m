Return-Path: <linux-kernel-owner+w=401wt.eu-S1757346AbYHJPnW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757346AbYHJPnW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Aug 2008 11:43:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755257AbYHJPj2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Aug 2008 11:39:28 -0400
Received: from mu-out-0910.google.com ([209.85.134.188]:2609 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755760AbYHJPj0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Aug 2008 11:39:26 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=B1gsQ2tpKfh2F6x9p0C1AJpqIJBbT6/hhgwztZb7zQ0DWMyVX0mDRRTvB1J4iJLc4L
         QF9b2ve1W5VMJw0nfikCc6ytWv/oLy7U3haNy2j4c7Gdtzce2acbPFmwaSs6tTEj9U2r
         F+e9k1i6jVqMtdqQK2dpdMieiLjSP/6QI8Dtg=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: Borislav Petkov <petkovbb@gmail.com>,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Date: Sun, 10 Aug 2008 17:37:14 +0200
Message-Id: <20080810153714.16255.66112.sendpatchset@localhost.localdomain>
In-Reply-To: <20080810153527.16255.2504.sendpatchset@localhost.localdomain>
References: <20080810153527.16255.2504.sendpatchset@localhost.localdomain>
Subject: [PATCH 15/22] ide: drop dsc_handle argument from ide_pc_intr()
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Add 'int dsc' argument to ->pc_callback method.

* Call ide_tape_handle_dsc() internally in ide_tape_callback()
  if dsc argument is set and update ide_pc_intr() accordingly.

There should be no functional changes caused by this patch.

Cc: Borislav Petkov <petkovbb@gmail.com>
Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/ide-atapi.c  |   16 +++++++---------
 drivers/ide/ide-floppy.c |    6 +++---
 drivers/ide/ide-tape.c   |   13 +++++++++----
 drivers/scsi/ide-scsi.c  |    5 ++---
 include/linux/ide.h      |    4 ++--
 5 files changed, 23 insertions(+), 21 deletions(-)

Index: b/drivers/ide/ide-atapi.c
===================================================================
--- a/drivers/ide/ide-atapi.c
+++ b/drivers/ide/ide-atapi.c
@@ -207,7 +207,7 @@ EXPORT_SYMBOL_GPL(ide_set_media_lock);
 ide_startstop_t ide_pc_intr(ide_drive_t *drive, struct ide_atapi_pc *pc,
 	ide_handler_t *handler, unsigned int timeout, ide_expiry_t *expiry,
 	void (*update_buffers)(ide_drive_t *, struct ide_atapi_pc *),
-	void (*retry_pc)(ide_drive_t *), void (*dsc_handle)(ide_drive_t *),
+	void (*retry_pc)(ide_drive_t *),
 	int (*io_buffers)(ide_drive_t *, struct ide_atapi_pc *, unsigned, int))
 {
 	ide_hwif_t *hwif = drive->hwif;
@@ -216,12 +216,12 @@ ide_startstop_t ide_pc_intr(ide_drive_t 
 	xfer_func_t *xferfunc;
 	unsigned int temp;
 	u16 bcount;
-	u8 stat, ireason, scsi = drive->scsi;
+	u8 stat, ireason, scsi = drive->scsi, dsc = 0;
 
 	debug_log("Enter %s - interrupt handler\n", __func__);
 
 	if (pc->flags & PC_FLAG_TIMEDOUT) {
-		drive->pc_callback(drive);
+		drive->pc_callback(drive, 0);
 		return ide_stopped;
 	}
 
@@ -283,14 +283,12 @@ ide_startstop_t ide_pc_intr(ide_drive_t 
 		}
 cmd_finished:
 		pc->error = 0;
-		if ((pc->flags & PC_FLAG_WAIT_FOR_DSC) &&
-		    (stat & ATA_DSC) == 0) {
-			dsc_handle(drive);
-			return ide_stopped;
-		}
+
+		if ((pc->flags & PC_FLAG_WAIT_FOR_DSC) && (stat & ATA_DSC) == 0)
+			dsc = 1;
 
 		/* Command finished - Call the callback function */
-		drive->pc_callback(drive);
+		drive->pc_callback(drive, dsc);
 
 		return ide_stopped;
 	}
Index: b/drivers/ide/ide-floppy.c
===================================================================
--- a/drivers/ide/ide-floppy.c
+++ b/drivers/ide/ide-floppy.c
@@ -155,7 +155,7 @@ static void idefloppy_update_buffers(ide
 		idefloppy_end_request(drive, 1, 0);
 }
 
-static void ide_floppy_callback(ide_drive_t *drive)
+static void ide_floppy_callback(ide_drive_t *drive, int dsc)
 {
 	idefloppy_floppy_t *floppy = drive->driver_data;
 	struct ide_atapi_pc *pc = floppy->pc;
@@ -222,7 +222,7 @@ static ide_startstop_t idefloppy_pc_intr
 
 	return ide_pc_intr(drive, floppy->pc, idefloppy_pc_intr,
 			   WAIT_FLOPPY_CMD, NULL, idefloppy_update_buffers,
-			   idefloppy_retry_pc, NULL, ide_io_buffers);
+			   idefloppy_retry_pc, ide_io_buffers);
 }
 
 /*
@@ -307,7 +307,7 @@ static ide_startstop_t idefloppy_issue_p
 		pc->error = IDEFLOPPY_ERROR_GENERAL;
 
 		floppy->failed_pc = NULL;
-		drive->pc_callback(drive);
+		drive->pc_callback(drive, 0);
 		return ide_stopped;
 	}
 
Index: b/drivers/ide/ide-tape.c
===================================================================
--- a/drivers/ide/ide-tape.c
+++ b/drivers/ide/ide-tape.c
@@ -522,7 +522,9 @@ static int idetape_end_request(ide_drive
 	return 0;
 }
 
-static void ide_tape_callback(ide_drive_t *drive)
+static void ide_tape_handle_dsc(ide_drive_t *);
+
+static void ide_tape_callback(ide_drive_t *drive, int dsc)
 {
 	idetape_tape_t *tape = drive->driver_data;
 	struct ide_atapi_pc *pc = tape->pc;
@@ -530,6 +532,9 @@ static void ide_tape_callback(ide_drive_
 
 	debug_log(DBG_PROCS, "Enter %s\n", __func__);
 
+	if (dsc)
+		ide_tape_handle_dsc(drive);
+
 	if (tape->failed_pc == pc)
 		tape->failed_pc = NULL;
 
@@ -658,7 +663,7 @@ static ide_startstop_t idetape_pc_intr(i
 
 	return ide_pc_intr(drive, tape->pc, idetape_pc_intr, WAIT_TAPE_CMD,
 			   NULL, idetape_update_buffers, idetape_retry_pc,
-			   ide_tape_handle_dsc, ide_tape_io_buffers);
+			   ide_tape_io_buffers);
 }
 
 /*
@@ -743,7 +748,7 @@ static ide_startstop_t idetape_issue_pc(
 			pc->error = IDETAPE_ERROR_GENERAL;
 		}
 		tape->failed_pc = NULL;
-		drive->pc_callback(drive);
+		drive->pc_callback(drive, 0);
 		return ide_stopped;
 	}
 	debug_log(DBG_SENSE, "Retry #%d, cmd = %02X\n", pc->retries, pc->c[0]);
@@ -805,7 +810,7 @@ static ide_startstop_t idetape_media_acc
 		pc->error = IDETAPE_ERROR_GENERAL;
 		tape->failed_pc = NULL;
 	}
-	drive->pc_callback(drive);
+	drive->pc_callback(drive, 0);
 	return ide_stopped;
 }
 
Index: b/drivers/scsi/ide-scsi.c
===================================================================
--- a/drivers/scsi/ide-scsi.c
+++ b/drivers/scsi/ide-scsi.c
@@ -137,7 +137,7 @@ static void ide_scsi_hex_dump(u8 *data, 
 
 static int idescsi_end_request(ide_drive_t *, int, int);
 
-static void ide_scsi_callback(ide_drive_t *drive)
+static void ide_scsi_callback(ide_drive_t *drive, int dsc)
 {
 	idescsi_scsi_t *scsi = drive_to_idescsi(drive);
 	struct ide_atapi_pc *pc = scsi->pc;
@@ -298,8 +298,7 @@ static ide_startstop_t idescsi_pc_intr (
 	struct ide_atapi_pc *pc = scsi->pc;
 
 	return ide_pc_intr(drive, pc, idescsi_pc_intr, get_timeout(pc),
-			   idescsi_expiry, NULL, NULL, NULL,
-			   ide_io_buffers);
+			   idescsi_expiry, NULL, NULL, ide_io_buffers);
 }
 
 static ide_startstop_t idescsi_transfer_pc(ide_drive_t *drive)
Index: b/include/linux/ide.h
===================================================================
--- a/include/linux/ide.h
+++ b/include/linux/ide.h
@@ -482,7 +482,7 @@ struct ide_drive_s {
 	struct completion gendev_rel_comp;	/* to deal with device release() */
 
 	/* callback for packet commands */
-	void (*pc_callback)(struct ide_drive_s *);
+	void (*pc_callback)(struct ide_drive_s *, int);
 
 	unsigned long atapi_flags;
 };
@@ -1163,7 +1163,7 @@ int ide_set_media_lock(ide_drive_t *, st
 ide_startstop_t ide_pc_intr(ide_drive_t *drive, struct ide_atapi_pc *pc,
 	ide_handler_t *handler, unsigned int timeout, ide_expiry_t *expiry,
 	void (*update_buffers)(ide_drive_t *, struct ide_atapi_pc *),
-	void (*retry_pc)(ide_drive_t *), void (*dsc_handle)(ide_drive_t *),
+	void (*retry_pc)(ide_drive_t *),
 	int (*io_buffers)(ide_drive_t *, struct ide_atapi_pc *, unsigned int,
 			   int));
 ide_startstop_t ide_transfer_pc(ide_drive_t *, struct ide_atapi_pc *,
