Return-Path: <linux-kernel-owner+w=401wt.eu-S1756969AbYHJPpd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756969AbYHJPpd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Aug 2008 11:45:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756489AbYHJPkN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Aug 2008 11:40:13 -0400
Received: from mu-out-0910.google.com ([209.85.134.188]:2609 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756458AbYHJPkK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Aug 2008 11:40:10 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=gEIyh+PoIwHfulUzHNBQHlLfIlmh6S2W7XuNPawPq+i9P+KU2WEqAgXBrNGXqgdIAQ
         FhKw4o/BCDox2tl7iRJZEr6L3lssG0tuVzTCRGEhssvHQqhb4I9/FE3MTKGi0KUr71qS
         Z6VQtB/MBZ7jK240Wxc2mgK5Dww2tnn+LFSrw=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: Borislav Petkov <petkovbb@gmail.com>,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Date: Sun, 10 Aug 2008 17:37:58 +0200
Message-Id: <20080810153758.16255.56271.sendpatchset@localhost.localdomain>
In-Reply-To: <20080810153527.16255.2504.sendpatchset@localhost.localdomain>
References: <20080810153527.16255.2504.sendpatchset@localhost.localdomain>
Subject: [PATCH 21/22] ide: make ide_pc_intr() static
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Always use ide_pc_intr as a handler in ide_pc_intr().

* Remove no longer used ide*_pc_intr() and 'handler'
  argument from ide_{transfer_pc,pc_intr}().

* Make ide_pc_intr() static.

There should be no functional changes caused by this patch.

Cc: Borislav Petkov <petkovbb@gmail.com>
Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/ide-atapi.c  |   15 +++++++++------
 drivers/ide/ide-floppy.c |   10 ++--------
 drivers/ide/ide-tape.c   |   18 +++---------------
 drivers/scsi/ide-scsi.c  |   11 +----------
 include/linux/ide.h      |    4 +---
 5 files changed, 16 insertions(+), 42 deletions(-)

Index: b/drivers/ide/ide-atapi.c
===================================================================
--- a/drivers/ide/ide-atapi.c
+++ b/drivers/ide/ide-atapi.c
@@ -246,7 +246,12 @@ int ide_scsi_expiry(ide_drive_t *drive)
 }
 EXPORT_SYMBOL_GPL(ide_scsi_expiry);
 
-ide_startstop_t ide_pc_intr(ide_drive_t *drive, ide_handler_t *handler)
+/*
+ * This is the usual interrupt handler which will be called during a packet
+ * command.  We will transfer some of the data (as requested by the drive)
+ * and will re-point interrupt handler to us.
+ */
+static ide_startstop_t ide_pc_intr(ide_drive_t *drive)
 {
 	struct ide_atapi_pc *pc = drive->pc;
 	ide_hwif_t *hwif = drive->hwif;
@@ -425,10 +430,9 @@ cmd_finished:
 		  rq->cmd[0], bcount);
 next_irq:
 	/* And set the interrupt handler again */
-	ide_set_handler(drive, handler, timeout, expiry);
+	ide_set_handler(drive, ide_pc_intr, timeout, expiry);
 	return ide_started;
 }
-EXPORT_SYMBOL_GPL(ide_pc_intr);
 
 static u8 ide_read_ireason(ide_drive_t *drive)
 {
@@ -464,8 +468,7 @@ static u8 ide_wait_ireason(ide_drive_t *
 	return ireason;
 }
 
-ide_startstop_t ide_transfer_pc(ide_drive_t *drive,
-				ide_handler_t *handler, unsigned int timeout,
+ide_startstop_t ide_transfer_pc(ide_drive_t *drive, unsigned int timeout,
 				ide_expiry_t *expiry)
 {
 	struct ide_atapi_pc *pc = drive->pc;
@@ -491,7 +494,7 @@ ide_startstop_t ide_transfer_pc(ide_driv
 	}
 
 	/* Set the interrupt routine */
-	ide_set_handler(drive, handler, timeout, expiry);
+	ide_set_handler(drive, ide_pc_intr, timeout, expiry);
 
 	/* Begin DMA, if necessary */
 	if (pc->flags & PC_FLAG_DMA_OK) {
Index: b/drivers/ide/ide-floppy.c
===================================================================
--- a/drivers/ide/ide-floppy.c
+++ b/drivers/ide/ide-floppy.c
@@ -192,12 +192,6 @@ static void ide_floppy_callback(ide_driv
 	idefloppy_end_request(drive, uptodate, 0);
 }
 
-/* The usual interrupt handler called during a packet command. */
-static ide_startstop_t idefloppy_pc_intr(ide_drive_t *drive)
-{
-	return ide_pc_intr(drive, idefloppy_pc_intr);
-}
-
 /*
  * What we have here is a classic case of a top half / bottom half interrupt
  * service routine. In interrupt mode, the device sends an interrupt to signal
@@ -229,7 +223,7 @@ static ide_startstop_t idefloppy_start_p
 	 * where the Busy flag was apparently being deasserted before the
 	 * unit was ready to receive data. This was happening on a
 	 * 1200 MHz Athlon system. 10/26/01 25msec is too short,
-	 * 40 and 50msec work well. idefloppy_pc_intr will not be actually
+	 * 40 and 50msec work well. ide_pc_intr will not be actually
 	 * used until after the packet is moved in about 50 msec.
 	 */
 	if (drive->atapi_flags & IDE_AFLAG_ZIP_DRIVE) {
@@ -240,7 +234,7 @@ static ide_startstop_t idefloppy_start_p
 		expiry = NULL;
 	}
 
-	return ide_transfer_pc(drive, idefloppy_pc_intr, timeout, expiry);
+	return ide_transfer_pc(drive, timeout, expiry);
 }
 
 static void ide_floppy_report_error(idefloppy_floppy_t *floppy,
Index: b/drivers/ide/ide-tape.c
===================================================================
--- a/drivers/ide/ide-tape.c
+++ b/drivers/ide/ide-tape.c
@@ -619,18 +619,6 @@ static int ide_tape_io_buffers(ide_drive
 }
 
 /*
- * This is the usual interrupt handler which will be called during a packet
- * command. We will transfer some of the data (as requested by the drive) and
- * will re-point interrupt handler to us. When data transfer is finished, we
- * will act according to the algorithm described before
- * idetape_issue_pc.
- */
-static ide_startstop_t idetape_pc_intr(ide_drive_t *drive)
-{
-	return ide_pc_intr(drive, idetape_pc_intr);
-}
-
-/*
  * Packet Command Interface
  *
  * The current Packet Command is available in drive->pc, and will not change
@@ -640,9 +628,9 @@ static ide_startstop_t idetape_pc_intr(i
  * The handling will be done in three stages:
  *
  * 1. idetape_issue_pc will send the packet command to the drive, and will set
- * the interrupt handler to idetape_pc_intr.
+ * the interrupt handler to ide_pc_intr.
  *
- * 2. On each interrupt, idetape_pc_intr will be called. This step will be
+ * 2. On each interrupt, ide_pc_intr will be called. This step will be
  * repeated until the device signals us that no more interrupts will be issued.
  *
  * 3. ATAPI Tape media access commands have immediate status with a delayed
@@ -668,7 +656,7 @@ static ide_startstop_t idetape_pc_intr(i
  */
 static ide_startstop_t idetape_transfer_pc(ide_drive_t *drive)
 {
-	return ide_transfer_pc(drive, idetape_pc_intr, WAIT_TAPE_CMD, NULL);
+	return ide_transfer_pc(drive, WAIT_TAPE_CMD, NULL);
 }
 
 static ide_startstop_t idetape_issue_pc(ide_drive_t *drive,
Index: b/drivers/scsi/ide-scsi.c
===================================================================
--- a/drivers/scsi/ide-scsi.c
+++ b/drivers/scsi/ide-scsi.c
@@ -270,18 +270,9 @@ static int idescsi_end_request (ide_driv
 	return 0;
 }
 
-/*
- *	Our interrupt handler.
- */
-static ide_startstop_t idescsi_pc_intr (ide_drive_t *drive)
-{
-	return ide_pc_intr(drive, idescsi_pc_intr);
-}
-
 static ide_startstop_t idescsi_transfer_pc(ide_drive_t *drive)
 {
-	return ide_transfer_pc(drive, idescsi_pc_intr,
-			       ide_scsi_get_timeout(drive->pc),
+	return ide_transfer_pc(drive, ide_scsi_get_timeout(drive->pc),
 			       ide_scsi_expiry);
 }
 
Index: b/include/linux/ide.h
===================================================================
--- a/include/linux/ide.h
+++ b/include/linux/ide.h
@@ -1177,9 +1177,7 @@ static inline unsigned long ide_scsi_get
 
 int ide_scsi_expiry(ide_drive_t *);
 
-ide_startstop_t ide_pc_intr(ide_drive_t *drive, ide_handler_t *handler);
-ide_startstop_t ide_transfer_pc(ide_drive_t *,
-				ide_handler_t *, unsigned int, ide_expiry_t *);
+ide_startstop_t ide_transfer_pc(ide_drive_t *, unsigned int, ide_expiry_t *);
 ide_startstop_t ide_issue_pc(ide_drive_t *,
 			     ide_handler_t *, unsigned int, ide_expiry_t *);
 
