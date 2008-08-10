Return-Path: <linux-kernel-owner+w=401wt.eu-S1755055AbYHJPmX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755055AbYHJPmX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Aug 2008 11:42:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755807AbYHJPjI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Aug 2008 11:39:08 -0400
Received: from mu-out-0910.google.com ([209.85.134.187]:3925 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754136AbYHJPjG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Aug 2008 11:39:06 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=QE+o+ReJ4O4OlZ0mXdGtPUDnANYATyG8/ESQRILs0p2PspTla1CtZAdAHWTPjp86bn
         pwHqQQXJgR6V3CX6PRLznZ0uJ9z77JNzEOTFxTMRwJtiwwtFLxUsfK+1Q42nHhAMXLnH
         Ux/ed4Nd7fDHWL+ofMT5XGbEL1N45xlqtqXMQ=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: Borislav Petkov <petkovbb@gmail.com>,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Date: Sun, 10 Aug 2008 17:36:52 +0200
Message-Id: <20080810153652.16255.57929.sendpatchset@localhost.localdomain>
In-Reply-To: <20080810153527.16255.2504.sendpatchset@localhost.localdomain>
References: <20080810153527.16255.2504.sendpatchset@localhost.localdomain>
Subject: [PATCH 12/22] ide: add ide_do_start_stop() helper
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Add ide_do_start_stop() helper and convert ide-{floppy,tape}.c
  to use it.

* Remove no longer used idefloppy_create_start_stop_cmd()
  and idetape_create_load_unload_cmd().

There should be no functional changes caused by this patch.

Cc: Borislav Petkov <petkovbb@gmail.com>
Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/ide-atapi.c  |   15 +++++++++++++++
 drivers/ide/ide-floppy.c |   19 ++++---------------
 drivers/ide/ide-tape.c   |   24 ++++--------------------
 include/linux/ide.h      |    1 +
 4 files changed, 24 insertions(+), 35 deletions(-)

Index: b/drivers/ide/ide-atapi.c
===================================================================
--- a/drivers/ide/ide-atapi.c
+++ b/drivers/ide/ide-atapi.c
@@ -162,6 +162,21 @@ int ide_queue_pc_tail(ide_drive_t *drive
 }
 EXPORT_SYMBOL_GPL(ide_queue_pc_tail);
 
+int ide_do_start_stop(ide_drive_t *drive, struct gendisk *disk, int start)
+{
+	struct ide_atapi_pc pc;
+
+	ide_init_pc(&pc);
+	pc.c[0] = START_STOP;
+	pc.c[4] = start;
+
+	if (drive->media == ide_tape)
+		pc.flags |= PC_FLAG_WAIT_FOR_DSC;
+
+	return ide_queue_pc_tail(drive, disk, &pc);
+}
+EXPORT_SYMBOL_GPL(ide_do_start_stop);
+
 int ide_set_media_lock(ide_drive_t *drive, struct gendisk *disk, int on)
 {
 	struct ide_atapi_pc pc;
Index: b/drivers/ide/ide-floppy.c
===================================================================
--- a/drivers/ide/ide-floppy.c
+++ b/drivers/ide/ide-floppy.c
@@ -358,13 +358,6 @@ void ide_floppy_create_mode_sense_cmd(st
 	pc->req_xfer = length;
 }
 
-static void idefloppy_create_start_stop_cmd(struct ide_atapi_pc *pc, int start)
-{
-	ide_init_pc(pc);
-	pc->c[0] = GPCMD_START_STOP_UNIT;
-	pc->c[4] = start;
-}
-
 static void idefloppy_create_rw_cmd(idefloppy_floppy_t *floppy,
 				    struct ide_atapi_pc *pc, struct request *rq,
 				    unsigned long sector)
@@ -799,10 +792,8 @@ static int idefloppy_open(struct inode *
 		ide_init_pc(&pc);
 		pc.c[0] = GPCMD_TEST_UNIT_READY;
 
-		if (ide_queue_pc_tail(drive, disk, &pc)) {
-			idefloppy_create_start_stop_cmd(&pc, 1);
-			(void)ide_queue_pc_tail(drive, disk, &pc);
-		}
+		if (ide_queue_pc_tail(drive, disk, &pc))
+			ide_do_start_stop(drive, disk, 1);
 
 		if (ide_floppy_get_capacity(drive)
 		   && (filp->f_flags & O_NDELAY) == 0
@@ -879,10 +870,8 @@ static int ide_floppy_lockdoor(ide_drive
 
 	ide_set_media_lock(drive, disk, prevent);
 
-	if (cmd == CDROMEJECT) {
-		idefloppy_create_start_stop_cmd(pc, 2);
-		(void)ide_queue_pc_tail(drive, disk, pc);
-	}
+	if (cmd == CDROMEJECT)
+		ide_do_start_stop(drive, disk, 2);
 
 	return 0;
 }
Index: b/drivers/ide/ide-tape.c
===================================================================
--- a/drivers/ide/ide-tape.c
+++ b/drivers/ide/ide-tape.c
@@ -1124,15 +1124,6 @@ static void idetape_create_test_unit_rea
 	pc->c[0] = TEST_UNIT_READY;
 }
 
-static void idetape_create_load_unload_cmd(ide_drive_t *drive,
-		struct ide_atapi_pc *pc, int cmd)
-{
-	ide_init_pc(pc);
-	pc->c[0] = START_STOP;
-	pc->c[4] = cmd;
-	pc->flags |= PC_FLAG_WAIT_FOR_DSC;
-}
-
 static int idetape_wait_ready(ide_drive_t *drive, unsigned long timeout)
 {
 	idetape_tape_t *tape = drive->driver_data;
@@ -1152,9 +1143,7 @@ static int idetape_wait_ready(ide_drive_
 			/* no media */
 			if (load_attempted)
 				return -ENOMEDIUM;
-			idetape_create_load_unload_cmd(drive, &pc,
-							IDETAPE_LU_LOAD_MASK);
-			ide_queue_pc_tail(drive, disk, &pc);
+			ide_do_start_stop(drive, disk, IDETAPE_LU_LOAD_MASK);
 			load_attempted = 1;
 		/* not about to be ready */
 		} else if (!(tape->sense_key == 2 && tape->asc == 4 &&
@@ -1835,9 +1824,7 @@ static int idetape_mtioctop(ide_drive_t 
 		return 0;
 	case MTLOAD:
 		ide_tape_discard_merge_buffer(drive, 0);
-		idetape_create_load_unload_cmd(drive, &pc,
-					       IDETAPE_LU_LOAD_MASK);
-		return ide_queue_pc_tail(drive, disk, &pc);
+		return ide_do_start_stop(drive, disk, IDETAPE_LU_LOAD_MASK);
 	case MTUNLOAD:
 	case MTOFFL:
 		/*
@@ -1849,9 +1836,7 @@ static int idetape_mtioctop(ide_drive_t 
 				tape->door_locked = DOOR_UNLOCKED;
 		}
 		ide_tape_discard_merge_buffer(drive, 0);
-		idetape_create_load_unload_cmd(drive, &pc,
-					      !IDETAPE_LU_LOAD_MASK);
-		retval = ide_queue_pc_tail(drive, disk, &pc);
+		retval = ide_do_start_stop(drive, disk, !IDETAPE_LU_LOAD_MASK);
 		if (!retval)
 			clear_bit(IDE_AFLAG_MEDIUM_PRESENT, &drive->atapi_flags);
 		return retval;
@@ -1860,9 +1845,8 @@ static int idetape_mtioctop(ide_drive_t 
 		return idetape_flush_tape_buffers(drive);
 	case MTRETEN:
 		ide_tape_discard_merge_buffer(drive, 0);
-		idetape_create_load_unload_cmd(drive, &pc,
+		return ide_do_start_stop(drive, disk,
 			IDETAPE_LU_RETENSION_MASK | IDETAPE_LU_LOAD_MASK);
-		return ide_queue_pc_tail(drive, disk, &pc);
 	case MTEOM:
 		idetape_create_space_cmd(&pc, 0, IDETAPE_SPACE_TO_EOD);
 		return ide_queue_pc_tail(drive, disk, &pc);
Index: b/include/linux/ide.h
===================================================================
--- a/include/linux/ide.h
+++ b/include/linux/ide.h
@@ -1140,6 +1140,7 @@ void ide_queue_pc_head(ide_drive_t *, st
 		       struct request *);
 int ide_queue_pc_tail(ide_drive_t *, struct gendisk *, struct ide_atapi_pc *);
 
+int ide_do_start_stop(ide_drive_t *, struct gendisk *, int);
 int ide_set_media_lock(ide_drive_t *, struct gendisk *, int);
 
 ide_startstop_t ide_pc_intr(ide_drive_t *drive, struct ide_atapi_pc *pc,
