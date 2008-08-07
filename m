Return-Path: <linux-kernel-owner+w=401wt.eu-S1756343AbYHGRQV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756343AbYHGRQV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Aug 2008 13:16:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754127AbYHGRPU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Aug 2008 13:15:20 -0400
Received: from fg-out-1718.google.com ([72.14.220.157]:25288 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755235AbYHGRPR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Aug 2008 13:15:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:mime-version:content-disposition
         :message-id:content-type:content-transfer-encoding;
        b=GtLps/mjpNEQZI6Fe3xyXV9j82xGkVMHhk/R0297bjLLG2s28EAh4OYABtsIFx8iHH
         qJ5JlUIa99i7eCrtkv/XHwRujM843pC9kS8JOnVYokfzjjJ284z//B+tJCwxXxbiQ38C
         rhfvzAvLqitWUoeVZbg2IXpfG0t3Abr2OczcQ=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Subject: [PATCH 5/2] ide-{floppy,tape}: remove packet command stack
Date: Thu, 7 Aug 2008 19:10:27 +0200
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org, Borislav Petkov <petkovbb@gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200808071910.27951.bzolnier@gmail.com>
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Add 'struct ide_atapi_pc queued_pc' to struct ide_{floppy,tape}_obj
  and switch ide*_do_request() to use it (there can be only one active
  request for a given device).

* Add 'struct ide_atapi_pc request_sense_pc' to struct ide_*_obj
  and switch ide*_retry_pc() to use it.

* Remove needless {floppy,tape}->pc assignment from ide*_setup().

* Remove no longer needed ide*_next_pc_storage(), pc_stack[],
  rq_stack_index, IDE*_PC_STACK and DBG_PC_STACK.

There should be no functional changes caused by this patch.

Cc: Borislav Petkov <petkovbb@gmail.com>
Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
Yes, 5/2 is correct (=> continuation of patches from yesterday)...

Borislav, please also test this one.

 drivers/ide/ide-floppy.c |   32 ++++++-------------------------
 drivers/ide/ide-tape.c   |   48 +++++------------------------------------------
 2 files changed, 13 insertions(+), 67 deletions(-)

Index: b/drivers/ide/ide-floppy.c
===================================================================
--- a/drivers/ide/ide-floppy.c
+++ b/drivers/ide/ide-floppy.c
@@ -74,13 +74,6 @@
  */
 #define IDEFLOPPY_PC_BUFFER_SIZE	256
 
-/*
- * In various places in the driver, we need to allocate storage for packet
- * commands, which will remain valid while we leave the driver to wait for
- * an interrupt or a timeout event.
- */
-#define IDEFLOPPY_PC_STACK		(10 + IDEFLOPPY_MAX_PC_RETRIES)
-
 /* format capacities descriptor codes */
 #define CAPACITY_INVALID	0x00
 #define CAPACITY_UNFORMATTED	0x01
@@ -103,11 +96,10 @@ typedef struct ide_floppy_obj {
 	struct ide_atapi_pc *pc;
 	/* Last failed packet command */
 	struct ide_atapi_pc *failed_pc;
-	/* Packet command stack */
-	struct ide_atapi_pc pc_stack[IDEFLOPPY_PC_STACK];
-	/* Next free packet command storage space */
-	int pc_stack_index;
+	/* used for blk_{fs,pc}_request() requests */
+	struct ide_atapi_pc queued_pc;
 
+	struct ide_atapi_pc request_sense_pc;
 	struct request request_sense_rq;
 
 	/* Last error information */
@@ -296,15 +288,6 @@ static void idefloppy_queue_pc_head(ide_
 	ide_do_drive_cmd(drive, rq);
 }
 
-static struct ide_atapi_pc *idefloppy_next_pc_storage(ide_drive_t *drive)
-{
-	idefloppy_floppy_t *floppy = drive->driver_data;
-
-	if (floppy->pc_stack_index == IDEFLOPPY_PC_STACK)
-		floppy->pc_stack_index = 0;
-	return (&floppy->pc_stack[floppy->pc_stack_index++]);
-}
-
 static void ide_floppy_callback(ide_drive_t *drive)
 {
 	idefloppy_floppy_t *floppy = drive->driver_data;
@@ -365,10 +348,9 @@ static void idefloppy_retry_pc(ide_drive
 {
 	struct ide_floppy_obj *floppy = drive->driver_data;
 	struct request *rq = &floppy->request_sense_rq;
-	struct ide_atapi_pc *pc;
+	struct ide_atapi_pc *pc = &floppy->request_sense_pc;
 
 	(void)ide_read_error(drive);
-	pc = idefloppy_next_pc_storage(drive);
 	idefloppy_create_request_sense_cmd(pc);
 	idefloppy_queue_pc_head(drive, pc, rq);
 }
@@ -628,12 +610,12 @@ static ide_startstop_t idefloppy_do_requ
 			idefloppy_end_request(drive, 0, 0);
 			return ide_stopped;
 		}
-		pc = idefloppy_next_pc_storage(drive);
+		pc = &floppy->queued_pc;
 		idefloppy_create_rw_cmd(floppy, pc, rq, block);
 	} else if (blk_special_request(rq)) {
 		pc = (struct ide_atapi_pc *) rq->buffer;
 	} else if (blk_pc_request(rq)) {
-		pc = idefloppy_next_pc_storage(drive);
+		pc = &floppy->queued_pc;
 		idefloppy_blockpc_cmd(floppy, pc, rq);
 	} else {
 		blk_dump_rq_flags(rq,
@@ -1006,7 +988,7 @@ static void idefloppy_setup(ide_drive_t 
 	u8 gcw[2];
 
 	*((u16 *)&gcw) = id[ATA_ID_CONFIG];
-	floppy->pc = floppy->pc_stack;
+
 	drive->pc_callback = ide_floppy_callback;
 
 	if (((gcw[0] & 0x60) >> 5) == 1)
Index: b/drivers/ide/ide-tape.c
===================================================================
--- a/drivers/ide/ide-tape.c
+++ b/drivers/ide/ide-tape.c
@@ -56,8 +56,6 @@ enum {
 	DBG_CHRDEV =		(1 << 2),
 	/* all remaining procedures */
 	DBG_PROCS =		(1 << 3),
-	/* buffer alloc info (pc_stack) */
-	DBG_PC_STACK =	(1 << 4),
 };
 
 /* define to see debug info */
@@ -89,13 +87,6 @@ enum {
 #define IDETAPE_PC_BUFFER_SIZE		256
 
 /*
- * In various places in the driver, we need to allocate storage for packet
- * commands, which will remain valid while we leave the driver to wait for
- * an interrupt or a timeout event.
- */
-#define IDETAPE_PC_STACK		(10 + IDETAPE_MAX_PC_RETRIES)
-
-/*
  * Some drives (for example, Seagate STT3401A Travan) require a very long
  * timeout, because they don't return an interrupt or clear their busy bit
  * until after the command completes (even retension commands).
@@ -208,13 +199,6 @@ typedef struct ide_tape_obj {
 	struct kref	kref;
 
 	/*
-	 *	Since a typical character device operation requires more
-	 *	than one packet command, we provide here enough memory
-	 *	for the maximum of interconnected packet commands.
-	 *	The packet commands are stored in the circular array pc_stack.
-	 *	pc_stack_index points to the last used entry, and warps around
-	 *	to the start when we get to the last array entry.
-	 *
 	 *	pc points to the current processed packet command.
 	 *
 	 *	failed_pc points to the last failed packet command, or contains
@@ -226,11 +210,10 @@ typedef struct ide_tape_obj {
 	struct ide_atapi_pc *pc;
 	/* Last failed packet command */
 	struct ide_atapi_pc *failed_pc;
-	/* Packet command stack */
-	struct ide_atapi_pc pc_stack[IDETAPE_PC_STACK];
-	/* Next free packet command storage space */
-	int pc_stack_index;
+	/* used by REQ_IDETAPE_{READ,WRITE} requests */
+	struct ide_atapi_pc queued_pc;
 
+	struct ide_atapi_pc request_sense_pc;
 	struct request request_sense_rq;
 
 	/*
@@ -452,23 +435,6 @@ static void idetape_update_buffers(ide_d
 }
 
 /*
- *	idetape_next_pc_storage returns a pointer to a place in which we can
- *	safely store a packet command, even though we intend to leave the
- *	driver. A storage space for a maximum of IDETAPE_PC_STACK packet
- *	commands is allocated at initialization time.
- */
-static struct ide_atapi_pc *idetape_next_pc_storage(ide_drive_t *drive)
-{
-	idetape_tape_t *tape = drive->driver_data;
-
-	debug_log(DBG_PC_STACK, "pc_stack_index=%d\n", tape->pc_stack_index);
-
-	if (tape->pc_stack_index == IDETAPE_PC_STACK)
-		tape->pc_stack_index = 0;
-	return (&tape->pc_stack[tape->pc_stack_index++]);
-}
-
-/*
  * called on each failed packet command retry to analyze the request sense. We
  * currently do not utilize this information.
  */
@@ -693,10 +659,9 @@ static void idetape_retry_pc(ide_drive_t
 {
 	struct ide_tape_obj *tape = drive->driver_data;
 	struct request *rq = &tape->request_sense_rq;
-	struct ide_atapi_pc *pc;
+	struct ide_atapi_pc *pc = &tape->request_sense_pc;
 
 	(void)ide_read_error(drive);
-	pc = idetape_next_pc_storage(drive);
 	idetape_create_request_sense_cmd(pc);
 	set_bit(IDE_AFLAG_IGNORE_DSC, &drive->atapi_flags);
 	idetape_queue_pc_head(drive, pc, rq);
@@ -1005,12 +970,12 @@ static ide_startstop_t idetape_do_reques
 		return ide_stopped;
 	}
 	if (rq->cmd[13] & REQ_IDETAPE_READ) {
-		pc = idetape_next_pc_storage(drive);
+		pc = &tape->queued_pc;
 		ide_tape_create_rw_cmd(tape, pc, rq, READ_6);
 		goto out;
 	}
 	if (rq->cmd[13] & REQ_IDETAPE_WRITE) {
-		pc = idetape_next_pc_storage(drive);
+		pc = &tape->queued_pc;
 		ide_tape_create_rw_cmd(tape, pc, rq, WRITE_6);
 		goto out;
 	}
@@ -2411,7 +2376,6 @@ static void idetape_setup(ide_drive_t *d
 	tape->name[1] = 't';
 	tape->name[2] = '0' + minor;
 	tape->chrdev_dir = IDETAPE_DIR_NONE;
-	tape->pc = tape->pc_stack;
 
 	*((u16 *)&gcw) = drive->id[ATA_ID_CONFIG];
 
