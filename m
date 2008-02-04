Return-Path: <linux-kernel-owner+w=401wt.eu-S1756010AbYBDNoV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756010AbYBDNoV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2008 08:44:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756016AbYBDNmd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Feb 2008 08:42:33 -0500
Received: from wr-out-0506.google.com ([64.233.184.236]:30309 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755970AbYBDNma (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2008 08:42:30 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=to:cc:subject:date:message-id:x-mailer:in-reply-to:references:from;
        b=OoW1LrcZX33WQxT36/qFc1TYbY+ehMuklMraNS3hIdkvauwg9Pgy6BTYEDAuQBVZ+O3rnm+gAZsZ4LJ9hmc0+A0jgLIz/qLt4btUdNTdDRG1QE/1UYlKBDJP6kHvFElPrULj1L/40GF+EC8A9EFC7MCshs+kWf117wf3SDSkOik=
To: <bzolnier@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org,
       Borislav Petkov <petkovbb@gmail.com>
Subject: [PATCH 08/22] ide-tape: remove packet command and struct request memory buffers
Date: Mon,  4 Feb 2008 14:40:26 +0100
Message-Id: <1202132440-26648-9-git-send-email-petkovbb@gmail.com>
X-Mailer: git-send-email debian.1.5.3.7.1-dirty
In-Reply-To: <1202132440-26648-1-git-send-email-petkovbb@gmail.com>
References: <1202132440-26648-1-git-send-email-petkovbb@gmail.com>
From: Borislav Petkov <petkovbb@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These buffers were always statically allocated during driver initialization no
matter what. Remove them by allocating GFP_ATOMIC memory on demand. In the case
of allocation error, we only issue error msg in the *alloc_{pc,rq} thus postponing
the final error handling and cleanup in their callers. Packet command and
request memory is freed in idetape_end_request() which is at the end of the
request path entered from all callbacks. While at it, integrate comments above
member definitions in ide_tape_obj.

Signed-off-by: Borislav Petkov <petkovbb@gmail.com>
---
 drivers/ide/ide-tape.c |  146 +++++++++++++++++++++---------------------------
 1 files changed, 63 insertions(+), 83 deletions(-)

diff --git a/drivers/ide/ide-tape.c b/drivers/ide/ide-tape.c
index 0b5ccce..b4944ef 100644
--- a/drivers/ide/ide-tape.c
+++ b/drivers/ide/ide-tape.c
@@ -54,8 +54,6 @@ enum {
 	DBG_CHRDEV =		(1 << 2),
 	/* all remaining procedures */
 	DBG_PROCS =		(1 << 3),
-	/* buffer alloc info (pc_stack & rq_stack) */
-	DBG_PCRQ_STACK =	(1 << 4),
 };
 
 /* define to see debug info */
@@ -110,13 +108,6 @@ enum {
 #define IDETAPE_PC_BUFFER_SIZE		256
 
 /*
- *	In various places in the driver, we need to allocate storage
- *	for packet commands and requests, which will remain valid while
- *	we leave the driver to wait for an interrupt or a timeout event.
- */
-#define IDETAPE_PC_STACK		(10 + IDETAPE_MAX_PC_RETRIES)
-
-/*
  * Some drives (for example, Seagate STT3401A Travan) require a very long
  * timeout, because they don't return an interrupt or clear their busy bit
  * until after the command completes (even retension commands).
@@ -255,32 +246,15 @@ typedef struct ide_tape_obj {
 	struct gendisk	*disk;
 	struct kref	kref;
 
+	/* current processed packet command */
+	idetape_pc_t *pc;
 	/*
-	 *	Since a typical character device operation requires more
-	 *	than one packet command, we provide here enough memory
-	 *	for the maximum of interconnected packet commands.
-	 *	The packet commands are stored in the circular array pc_stack.
-	 *	pc_stack_index points to the last used entry, and warps around
-	 *	to the start when we get to the last array entry.
-	 *
-	 *	pc points to the current processed packet command.
-	 *
-	 *	failed_pc points to the last failed packet command, or contains
-	 *	NULL if we do not need to retry any packet command. This is
-	 *	required since an additional packet command is needed before the
-	 *	retry, to get detailed information on what went wrong.
+	 * last failed packet command or NULL if we do not need to retry any
+	 * packet command. This is required since an additional packet command
+	 * is needed before the retry, to get detailed information on what went
+	 * wrong.
 	 */
-	/* Current packet command */
-	idetape_pc_t *pc;
-	/* Last failed packet command */
 	idetape_pc_t *failed_pc;
-	/* Packet command stack */
-	idetape_pc_t pc_stack[IDETAPE_PC_STACK];
-	/* Next free packet command storage space */
-	int pc_stack_index;
-	struct request rq_stack[IDETAPE_PC_STACK];
-	/* We implement a circular array */
-	int rq_stack_index;
 
 	/*
 	 *	DSC polling variables.
@@ -670,45 +644,32 @@ static void idetape_update_buffers (idetape_pc_t *pc)
 	pc->bh = bh;
 }
 
-/*
- *	idetape_next_pc_storage returns a pointer to a place in which we can
- *	safely store a packet command, even though we intend to leave the
- *	driver. A storage space for a maximum of IDETAPE_PC_STACK packet
- *	commands is allocated at initialization time.
- */
-static idetape_pc_t *idetape_next_pc_storage (ide_drive_t *drive)
+static idetape_pc_t *ide_tape_alloc_pc(void)
 {
-	idetape_tape_t *tape = drive->driver_data;
+	idetape_pc_t *pc;
 
-	debug_log(DBG_PCRQ_STACK, "pc_stack_index=%d\n", tape->pc_stack_index);
+	pc = kzalloc(sizeof(idetape_pc_t), GFP_ATOMIC);
+	if (!pc)
+		printk(KERN_ERR "ide-tape: %s: memory allocation error.",
+				__func__);
 
-	if (tape->pc_stack_index == IDETAPE_PC_STACK)
-		tape->pc_stack_index=0;
-	return (&tape->pc_stack[tape->pc_stack_index++]);
+	return pc;
 }
 
 /*
- *	idetape_next_rq_storage is used along with idetape_next_pc_storage.
- *	Since we queue packet commands in the request queue, we need to
- *	allocate a request, along with the allocation of a packet command.
+ * Since we queue packet commands in the request queue, we need to allocate a
+ * request, along with a packet command.
  */
- 
-/**************************************************************
- *                                                            *
- *  This should get fixed to use kmalloc(.., GFP_ATOMIC)      *
- *  followed later on by kfree().   -ml                       *
- *                                                            *
- **************************************************************/
- 
-static struct request *idetape_next_rq_storage (ide_drive_t *drive)
+static struct request *ide_tape_alloc_rq(void)
 {
-	idetape_tape_t *tape = drive->driver_data;
+	struct request *rq;
 
-	debug_log(DBG_PCRQ_STACK, "rq_stack_index=%d\n", tape->rq_stack_index);
+	rq = kzalloc(sizeof(struct request), GFP_ATOMIC);
+	if (!rq)
+		printk(KERN_ERR "ide-tape: %s: memory allocation error.",
+				__func__);
 
-	if (tape->rq_stack_index == IDETAPE_PC_STACK)
-		tape->rq_stack_index=0;
-	return (&tape->rq_stack[tape->rq_stack_index++]);
+	return rq;
 }
 
 /*
@@ -980,9 +941,8 @@ static int idetape_end_request(ide_drive_t *drive, int uptodate, int nr_sects)
 		}
 	}
 	ide_end_drive_cmd(drive, 0, 0);
-//	blkdev_dequeue_request(rq);
-//	drive->rq = NULL;
-//	end_that_request_last(rq);
+	kfree(tape->pc);
+	kfree(rq);
 
 	if (remove_stage)
 		idetape_remove_stage_head(drive);
@@ -1031,13 +991,9 @@ static void idetape_init_rq(struct request *rq, u8 cmd)
  *
  *	idetape_queue_pc_head is called from the request handling part of
  *	the driver (the "bottom" part). Safe storage for the request should
- *	be allocated with idetape_next_pc_storage and idetape_next_rq_storage
+ *	be allocated with ide_tape_alloc_pc and ide_tape_alloc_rq
  *	before calling idetape_queue_pc_head.
  *
- *	Memory for those requests is pre-allocated at initialization time, and
- *	is limited to IDETAPE_PC_STACK requests. We assume that we have enough
- *	space for the maximum possible number of inter-dependent packet commands.
- *
  *	The higher level of the driver - The ioctl handler and the character
  *	device handling functions should queue request to the lower level part
  *	and wait for their completion using idetape_queue_pc_tail or
@@ -1054,19 +1010,27 @@ static void idetape_queue_pc_head (ide_drive_t *drive, idetape_pc_t *pc,struct r
 }
 
 /*
- *	idetape_retry_pc is called when an error was detected during the
- *	last packet command. We queue a request sense packet command in
- *	the head of the request list.
+ * Called when an error was detected during the last packet command. We queue a
+ * request sense packet command in the head of the request list.
  */
-static ide_startstop_t idetape_retry_pc (ide_drive_t *drive)
+static ide_startstop_t idetape_retry_pc(ide_drive_t *drive)
 {
 	idetape_tape_t *tape = drive->driver_data;
 	idetape_pc_t *pc;
 	struct request *rq;
 
 	(void)drive->hwif->INB(IDE_ERROR_REG);
-	pc = idetape_next_pc_storage(drive);
-	rq = idetape_next_rq_storage(drive);
+	pc = ide_tape_alloc_pc();
+	rq = ide_tape_alloc_rq();
+
+	if (!pc || !rq) {
+		printk(KERN_ERR "ide-tape: Cannot retry packet command due to "
+				"low memory.");
+		kfree(pc);
+		kfree(rq);
+		return ide_stopped;
+	}
+
 	idetape_create_request_sense_cmd(pc);
 	set_bit(IDETAPE_IGNORE_DSC, &tape->flags);
 	idetape_queue_pc_head(drive, pc, rq);
@@ -1706,21 +1670,33 @@ static ide_startstop_t idetape_do_request(ide_drive_t *drive,
 	if (rq->cmd[0] & REQ_IDETAPE_READ) {
 		tape->buffer_head++;
 		tape->postpone_cnt = 0;
-		pc = idetape_next_pc_storage(drive);
-		idetape_create_read_cmd(tape, pc, rq->current_nr_sectors, (struct idetape_bh *)rq->special);
+		pc = ide_tape_alloc_pc();
+		if (!pc)
+			goto err;
+
+		idetape_create_read_cmd(tape, pc, rq->current_nr_sectors,
+				(struct idetape_bh *)rq->special);
 		goto out;
 	}
 	if (rq->cmd[0] & REQ_IDETAPE_WRITE) {
 		tape->buffer_head++;
 		tape->postpone_cnt = 0;
-		pc = idetape_next_pc_storage(drive);
-		idetape_create_write_cmd(tape, pc, rq->current_nr_sectors, (struct idetape_bh *)rq->special);
+		pc = ide_tape_alloc_pc();
+		if (!pc)
+			goto err;
+
+		idetape_create_write_cmd(tape, pc, rq->current_nr_sectors,
+				(struct idetape_bh *)rq->special);
 		goto out;
 	}
 	if (rq->cmd[0] & REQ_IDETAPE_READ_BUFFER) {
 		tape->postpone_cnt = 0;
-		pc = idetape_next_pc_storage(drive);
-		idetape_create_read_buffer_cmd(tape, pc, rq->current_nr_sectors, (struct idetape_bh *)rq->special);
+		pc = ide_tape_alloc_pc();
+		if (!pc)
+			goto err;
+
+		idetape_create_read_buffer_cmd(tape, pc, rq->current_nr_sectors,
+				(struct idetape_bh *)rq->special);
 		goto out;
 	}
 	if (rq->cmd[0] & REQ_IDETAPE_PC1) {
@@ -1736,6 +1712,11 @@ static ide_startstop_t idetape_do_request(ide_drive_t *drive,
 	BUG();
 out:
 	return idetape_issue_packet_command(drive, pc);
+
+err:
+	printk(KERN_ERR "ide-tape: Error processing request %u\n", rq->cmd[0]);
+	idetape_end_request(drive, 0, 0);
+	return ide_stopped;
 }
 
 /*
@@ -2041,7 +2022,7 @@ static void idetape_create_test_unit_ready_cmd(idetape_pc_t *pc)
  *	for an interrupt or a timer event.
  *
  *	From the bottom part of the driver, we should allocate safe memory
- *	using idetape_next_pc_storage and idetape_next_rq_storage, and add
+ *	using ide_tape_alloc_pc and ide_tape_alloc_rq, and add
  *	the request to the request list without waiting for it to be serviced !
  *	In that case, we usually use idetape_queue_pc_head.
  */
@@ -3571,7 +3552,6 @@ static void idetape_setup (ide_drive_t *drive, idetape_tape_t *tape, int minor)
 	tape->name[1] = 't';
 	tape->name[2] = '0' + minor;
 	tape->chrdev_dir = IDETAPE_DIR_NONE;
-	tape->pc = tape->pc_stack;
 	tape->max_insert_speed = 10000;
 	tape->speed_control = 1;
 	*((unsigned short *) &gcw) = drive->id->config;
-- 
1.5.3.7

