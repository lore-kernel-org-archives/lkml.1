Return-Path: <linux-kernel-owner+w=401wt.eu-S1759557AbYERSxE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759557AbYERSxE (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 May 2008 14:53:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759319AbYERSoB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 May 2008 14:44:01 -0400
Received: from mu-out-0910.google.com ([209.85.134.184]:29480 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754588AbYERSn7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 May 2008 14:43:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=Oote+tgZ5zmDnR2YHqyKzBHy74AebNOBYOe12U1yynktaUccIlHlgl1294/YrYR39COVTVbLkLRf++iHC4cHpZKybW2hpKvG5fI234XG0t/mSU3siDY1kDUXqEObowPxP32zs3kE2eZL/e3A0Y5ndcqTyYPlSdTGu/5iegGMSCU=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: Borislav Petkov <petkovbb@gmail.com>,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Date: Sun, 18 May 2008 21:00:28 +0200
Message-Id: <20080518190028.5636.94015.sendpatchset@localhost.localdomain>
In-Reply-To: <20080518185428.5636.77234.sendpatchset@localhost.localdomain>
References: <20080518185428.5636.77234.sendpatchset@localhost.localdomain>
Subject: [PATCH 40/40] ide: add ide_pc_intr() helper
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* ide-tape.c: add 'drive' argument to idetape_update_buffers().

* Add generic ide_pc_intr() helper to ide-atapi.c and then
  convert ide-{floppy,tape,scsi} device drivers to use it.

* ide-tape.c: remove no longer needed DBG_PC_INTR.

There should be no functional changes caused by this patch
(unless the debugging is explicitely compiled in).

Cc: Borislav Petkov <petkovbb@gmail.com>
Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/ide-atapi.c  |  177 +++++++++++++++++++++++++++++++++++++++++++++++
 drivers/ide/ide-floppy.c |  128 ---------------------------------
 drivers/ide/ide-tape.c   |  132 +----------------------------------
 drivers/scsi/ide-scsi.c  |  115 ------------------------------
 include/linux/ide.h      |    6 +
 5 files changed, 195 insertions(+), 363 deletions(-)

Index: b/drivers/ide/ide-atapi.c
===================================================================
--- a/drivers/ide/ide-atapi.c
+++ b/drivers/ide/ide-atapi.c
@@ -5,6 +5,183 @@
 #include <linux/kernel.h>
 #include <linux/delay.h>
 #include <linux/ide.h>
+#include <scsi/scsi.h>
+
+#ifdef DEBUG
+#define debug_log(fmt, args...) \
+	printk(KERN_INFO "ide: " fmt, ## args)
+#else
+#define debug_log(fmt, args...) do {} while (0)
+#endif
+
+/* TODO: unify the code thus making some arguments go away */
+ide_startstop_t ide_pc_intr(ide_drive_t *drive, struct ide_atapi_pc *pc,
+	ide_handler_t *handler, unsigned int timeout, ide_expiry_t *expiry,
+	void (*update_buffers)(ide_drive_t *, struct ide_atapi_pc *),
+	void (*retry_pc)(ide_drive_t *), void (*dsc_handle)(ide_drive_t *),
+	void (*io_buffers)(ide_drive_t *, struct ide_atapi_pc *, unsigned, int))
+{
+	ide_hwif_t *hwif = drive->hwif;
+	xfer_func_t *xferfunc;
+	unsigned int temp;
+	u16 bcount;
+	u8 stat, ireason, scsi = drive->scsi;
+
+	debug_log("Enter %s - interrupt handler\n", __func__);
+
+	if (pc->flags & PC_FLAG_TIMEDOUT) {
+		pc->callback(drive);
+		return ide_stopped;
+	}
+
+	/* Clear the interrupt */
+	stat = ide_read_status(drive);
+
+	if (pc->flags & PC_FLAG_DMA_IN_PROGRESS) {
+		if (hwif->dma_ops->dma_end(drive) ||
+		    (drive->media == ide_tape && !scsi && (stat & ERR_STAT))) {
+			if (drive->media == ide_floppy && !scsi)
+				printk(KERN_ERR "%s: DMA %s error\n",
+					drive->name, rq_data_dir(pc->rq)
+						     ? "write" : "read");
+			pc->flags |= PC_FLAG_DMA_ERROR;
+		} else {
+			pc->xferred = pc->req_xfer;
+			if (update_buffers)
+				update_buffers(drive, pc);
+		}
+		debug_log("%s: DMA finished\n", drive->name);
+	}
+
+	/* No more interrupts */
+	if ((stat & DRQ_STAT) == 0) {
+		debug_log("Packet command completed, %d bytes transferred\n",
+			  pc->xferred);
+
+		pc->flags &= ~PC_FLAG_DMA_IN_PROGRESS;
+
+		local_irq_enable_in_hardirq();
+
+		if (drive->media == ide_tape && !scsi &&
+		    (stat & ERR_STAT) && pc->c[0] == REQUEST_SENSE)
+			stat &= ~ERR_STAT;
+		if ((stat & ERR_STAT) || (pc->flags & PC_FLAG_DMA_ERROR)) {
+			/* Error detected */
+			debug_log("%s: I/O error\n", drive->name);
+
+			if (drive->media != ide_tape || scsi) {
+				pc->rq->errors++;
+				if (scsi)
+					goto cmd_finished;
+			}
+
+			if (pc->c[0] == REQUEST_SENSE) {
+				printk(KERN_ERR "%s: I/O error in request sense"
+						" command\n", drive->name);
+				return ide_do_reset(drive);
+			}
+
+			debug_log("[cmd %x]: check condition\n", pc->c[0]);
+
+			/* Retry operation */
+			retry_pc(drive);
+			/* queued, but not started */
+			return ide_stopped;
+		}
+cmd_finished:
+		pc->error = 0;
+		if ((pc->flags & PC_FLAG_WAIT_FOR_DSC) &&
+		    (stat & SEEK_STAT) == 0) {
+			dsc_handle(drive);
+			return ide_stopped;
+		}
+		/* Command finished - Call the callback function */
+		pc->callback(drive);
+		return ide_stopped;
+	}
+
+	if (pc->flags & PC_FLAG_DMA_IN_PROGRESS) {
+		pc->flags &= ~PC_FLAG_DMA_IN_PROGRESS;
+		printk(KERN_ERR "%s: The device wants to issue more interrupts "
+				"in DMA mode\n", drive->name);
+		ide_dma_off(drive);
+		return ide_do_reset(drive);
+	}
+	/* Get the number of bytes to transfer on this interrupt. */
+	bcount = (hwif->INB(hwif->io_ports.lbah_addr) << 8) |
+		  hwif->INB(hwif->io_ports.lbam_addr);
+
+	ireason = hwif->INB(hwif->io_ports.nsect_addr);
+
+	if (ireason & CD) {
+		printk(KERN_ERR "%s: CoD != 0 in %s\n", drive->name, __func__);
+		return ide_do_reset(drive);
+	}
+	if (((ireason & IO) == IO) == !!(pc->flags & PC_FLAG_WRITING)) {
+		/* Hopefully, we will never get here */
+		printk(KERN_ERR "%s: We wanted to %s, but the device wants us "
+				"to %s!\n", drive->name,
+				(ireason & IO) ? "Write" : "Read",
+				(ireason & IO) ? "Read" : "Write");
+		return ide_do_reset(drive);
+	}
+	if (!(pc->flags & PC_FLAG_WRITING)) {
+		/* Reading - Check that we have enough space */
+		temp = pc->xferred + bcount;
+		if (temp > pc->req_xfer) {
+			if (temp > pc->buf_size) {
+				printk(KERN_ERR "%s: The device wants to send "
+						"us more data than expected - "
+						"discarding data\n",
+						drive->name);
+				if (scsi)
+					temp = pc->buf_size - pc->xferred;
+				else
+					temp = 0;
+				if (temp) {
+					if (pc->sg)
+						io_buffers(drive, pc, temp, 0);
+					else
+						hwif->input_data(drive, NULL,
+							pc->cur_pos, temp);
+					printk(KERN_ERR "%s: transferred %d of "
+							"%d bytes\n",
+							drive->name,
+							temp, bcount);
+				}
+				pc->xferred += temp;
+				pc->cur_pos += temp;
+				ide_pad_transfer(drive, 0, bcount - temp);
+				ide_set_handler(drive, handler, timeout,
+						expiry);
+				return ide_started;
+			}
+			debug_log("The device wants to send us more data than "
+				  "expected - allowing transfer\n");
+		}
+		xferfunc = hwif->input_data;
+	} else
+		xferfunc = hwif->output_data;
+
+	if ((drive->media == ide_floppy && !scsi && !pc->buf) ||
+	    (drive->media == ide_tape && !scsi && pc->bh) ||
+	    (scsi && pc->sg))
+		io_buffers(drive, pc, bcount, !!(pc->flags & PC_FLAG_WRITING));
+	else
+		xferfunc(drive, NULL, pc->cur_pos, bcount);
+
+	/* Update the current position */
+	pc->xferred += bcount;
+	pc->cur_pos += bcount;
+
+	debug_log("[cmd %x] transferred %d bytes on that intr.\n",
+		  pc->c[0], bcount);
+
+	/* And set the interrupt handler again */
+	ide_set_handler(drive, handler, timeout, expiry);
+	return ide_started;
+}
+EXPORT_SYMBOL_GPL(ide_pc_intr);
 
 static u8 ide_wait_ireason(ide_drive_t *drive, u8 ireason)
 {
Index: b/drivers/ide/ide-floppy.c
===================================================================
--- a/drivers/ide/ide-floppy.c
+++ b/drivers/ide/ide-floppy.c
@@ -388,132 +388,10 @@ static void idefloppy_retry_pc(ide_drive
 static ide_startstop_t idefloppy_pc_intr(ide_drive_t *drive)
 {
 	idefloppy_floppy_t *floppy = drive->driver_data;
-	ide_hwif_t *hwif = drive->hwif;
-	struct ide_atapi_pc *pc = floppy->pc;
-	struct request *rq = pc->rq;
-	xfer_func_t *xferfunc;
-	unsigned int temp;
-	int dma_error = 0;
-	u16 bcount;
-	u8 stat, ireason;
-
-	debug_log("Enter %s - interrupt handler\n", __func__);
-
-	/* Clear the interrupt */
-	stat = ide_read_status(drive);
-
-	if (pc->flags & PC_FLAG_DMA_IN_PROGRESS) {
-		dma_error = hwif->dma_ops->dma_end(drive);
-		if (dma_error) {
-			printk(KERN_ERR "%s: DMA %s error\n", drive->name,
-					rq_data_dir(rq) ? "write" : "read");
-			pc->flags |= PC_FLAG_DMA_ERROR;
-		} else {
-			pc->xferred = pc->req_xfer;
-			idefloppy_update_buffers(drive, pc);
-		}
-		debug_log("%s: DMA finished\n", drive->name);
-	}
-
-	/* No more interrupts */
-	if ((stat & DRQ_STAT) == 0) {
-		debug_log("Packet command completed, %d bytes transferred\n",
-				pc->xferred);
-		pc->flags &= ~PC_FLAG_DMA_IN_PROGRESS;
-
-		local_irq_enable_in_hardirq();
-
-		if ((stat & ERR_STAT) || (pc->flags & PC_FLAG_DMA_ERROR)) {
-			/* Error detected */
-			debug_log("%s: I/O error\n", drive->name);
-			rq->errors++;
-			if (pc->c[0] == GPCMD_REQUEST_SENSE) {
-				printk(KERN_ERR "%s: I/O error in request sense"
-						" command\n", drive->name);
-				return ide_do_reset(drive);
-			}
-
-			debug_log("[cmd %x]: check condition\n", pc->c[0]);
-
-			/* Retry operation */
-			idefloppy_retry_pc(drive);
-			/* queued, but not started */
-			return ide_stopped;
-		}
-		pc->error = 0;
-		/* Command finished - Call the callback function */
-		pc->callback(drive);
-		return ide_stopped;
-	}
-
-	if (pc->flags & PC_FLAG_DMA_IN_PROGRESS) {
-		pc->flags &= ~PC_FLAG_DMA_IN_PROGRESS;
-		printk(KERN_ERR "%s: The device wants to issue more interrupts "
-				"in DMA mode\n", drive->name);
-		ide_dma_off(drive);
-		return ide_do_reset(drive);
-	}
-
-	/* Get the number of bytes to transfer */
-	bcount = (hwif->INB(hwif->io_ports.lbah_addr) << 8) |
-		  hwif->INB(hwif->io_ports.lbam_addr);
-	/* on this interrupt */
-	ireason = hwif->INB(hwif->io_ports.nsect_addr);
-
-	if (ireason & CD) {
-		printk(KERN_ERR "%s: CoD != 0 in %s\n", drive->name, __func__);
-		return ide_do_reset(drive);
-	}
-	if (((ireason & IO) == IO) == !!(pc->flags & PC_FLAG_WRITING)) {
-		/* Hopefully, we will never get here */
-		printk(KERN_ERR "%s: We wanted to %s, but the device wants us "
-				"to %s!\n", drive->name,
-				(ireason & IO) ? "Write" : "Read",
-				(ireason & IO) ? "Read" : "Write");
-		return ide_do_reset(drive);
-	}
-	if (!(pc->flags & PC_FLAG_WRITING)) {
-		/* Reading - Check that we have enough space */
-		temp = pc->xferred + bcount;
-		if (temp > pc->req_xfer) {
-			if (temp > pc->buf_size) {
-				printk(KERN_ERR "%s: The device wants to send "
-						"us more data than expected - "
-						"discarding data\n",
-						drive->name);
-				ide_pad_transfer(drive, 0, bcount);
-
-				ide_set_handler(drive,
-						&idefloppy_pc_intr,
-						IDEFLOPPY_WAIT_CMD,
-						NULL);
-				return ide_started;
-			}
-			debug_log("The device wants to send us more data than "
-				  "expected - allowing transfer\n");
-		}
-	}
-	if (pc->flags & PC_FLAG_WRITING)
-		xferfunc = hwif->output_data;
-	else
-		xferfunc = hwif->input_data;
-
-	if (pc->buf)
-		xferfunc(drive, NULL, pc->cur_pos, bcount);
-	else
-		ide_floppy_io_buffers(drive, pc, bcount,
-				      !!(pc->flags & PC_FLAG_WRITING));
 
-	/* Update the current position */
-	pc->xferred += bcount;
-	pc->cur_pos += bcount;
-
-	debug_log("[cmd %x] transferred %d bytes on that intr.\n",
-		  pc->c[0], bcount);
-
-	/* And set the interrupt handler again */
-	ide_set_handler(drive, &idefloppy_pc_intr, IDEFLOPPY_WAIT_CMD, NULL);
-	return ide_started;
+	return ide_pc_intr(drive, floppy->pc, idefloppy_pc_intr,
+			   IDEFLOPPY_WAIT_CMD, NULL, idefloppy_update_buffers,
+			   idefloppy_retry_pc, NULL, ide_floppy_io_buffers);
 }
 
 /*
Index: b/drivers/ide/ide-tape.c
===================================================================
--- a/drivers/ide/ide-tape.c
+++ b/drivers/ide/ide-tape.c
@@ -56,8 +56,6 @@ enum {
 	DBG_PROCS =		(1 << 3),
 	/* buffer alloc info (pc_stack & rq_stack) */
 	DBG_PCRQ_STACK =	(1 << 4),
-	/* IRQ handler (always log debug info if debugging is on) */
-	DBG_PC_INTR = 		(1 << 5),
 };
 
 /* define to see debug info */
@@ -66,7 +64,7 @@ enum {
 #if IDETAPE_DEBUG_LOG
 #define debug_log(lvl, fmt, args...)			\
 {							\
-	if ((lvl & DBG_PC_INTR) || (tape->debug_mask & lvl)) \
+	if (tape->debug_mask & lvl)			\
 	printk(KERN_INFO "ide-tape: " fmt, ## args);	\
 }
 #else
@@ -441,7 +439,7 @@ static void idetape_output_buffers(ide_d
 	}
 }
 
-static void idetape_update_buffers(struct ide_atapi_pc *pc)
+static void idetape_update_buffers(ide_drive_t *drive, struct ide_atapi_pc *pc)
 {
 	struct idetape_bh *bh = pc->bh;
 	int count;
@@ -526,7 +524,7 @@ static void idetape_analyze_error(ide_dr
 		pc->xferred = pc->req_xfer -
 			tape->blk_size *
 			get_unaligned_be32(&sense[3]);
-		idetape_update_buffers(pc);
+		idetape_update_buffers(drive, pc);
 	}
 
 	/*
@@ -800,129 +798,11 @@ static void ide_tape_io_buffers(ide_driv
  */
 static ide_startstop_t idetape_pc_intr(ide_drive_t *drive)
 {
-	ide_hwif_t *hwif = drive->hwif;
 	idetape_tape_t *tape = drive->driver_data;
-	struct ide_atapi_pc *pc = tape->pc;
-	xfer_func_t *xferfunc;
-	unsigned int temp;
-	u16 bcount;
-	u8 stat, ireason;
-
-	debug_log(DBG_PC_INTR, "Enter %s - interrupt handler\n", __func__);
-
-	/* Clear the interrupt */
-	stat = ide_read_status(drive);
-
-	if (pc->flags & PC_FLAG_DMA_IN_PROGRESS) {
-		if (hwif->dma_ops->dma_end(drive) || (stat & ERR_STAT)) {
-			pc->flags |= PC_FLAG_DMA_ERROR;
-		} else {
-			pc->xferred = pc->req_xfer;
-			idetape_update_buffers(pc);
-		}
-		debug_log(DBG_PC_INTR, "%s: DMA finished\n", drive->name);
-	}
-
-	/* No more interrupts */
-	if ((stat & DRQ_STAT) == 0) {
-		debug_log(DBG_PC_INTR, "Packet command completed, %d bytes"
-				" transferred\n", pc->xferred);
-
-		pc->flags &= ~PC_FLAG_DMA_IN_PROGRESS;
-		local_irq_enable_in_hardirq();
-
-		if ((stat & ERR_STAT) && pc->c[0] == REQUEST_SENSE)
-			stat &= ~ERR_STAT;
-		if ((stat & ERR_STAT) || (pc->flags & PC_FLAG_DMA_ERROR)) {
-			/* Error detected */
-			debug_log(DBG_PC_INTR, "%s: I/O error\n", drive->name);
-
-			if (pc->c[0] == REQUEST_SENSE) {
-				printk(KERN_ERR "%s: I/O error in request sense"
-						" command\n", drive->name);
-				return ide_do_reset(drive);
-			}
-			debug_log(DBG_PC_INTR, "[cmd %x]: check condition\n",
-					pc->c[0]);
-
-			/* Retry operation */
-			idetape_retry_pc(drive);
-			return ide_stopped;
-		}
-		pc->error = 0;
-		if ((pc->flags & PC_FLAG_WAIT_FOR_DSC) &&
-		    (stat & SEEK_STAT) == 0) {
-			ide_tape_handle_dsc(drive);
-			return ide_stopped;
-		}
-		/* Command finished - Call the callback function */
-		pc->callback(drive);
-		return ide_stopped;
-	}
-
-	if (pc->flags & PC_FLAG_DMA_IN_PROGRESS) {
-		pc->flags &= ~PC_FLAG_DMA_IN_PROGRESS;
-		printk(KERN_ERR "%s: The device wants to issue more interrupts "
-				"in DMA mode\n", drive->name);
-		ide_dma_off(drive);
-		return ide_do_reset(drive);
-	}
-	/* Get the number of bytes to transfer on this interrupt. */
-	bcount = (hwif->INB(hwif->io_ports.lbah_addr) << 8) |
-		  hwif->INB(hwif->io_ports.lbam_addr);
-
-	ireason = hwif->INB(hwif->io_ports.nsect_addr);
-
-	if (ireason & CD) {
-		printk(KERN_ERR "%s: CoD != 0 in %s\n", drive->name, __func__);
-		return ide_do_reset(drive);
-	}
-	if (((ireason & IO) == IO) == !!(pc->flags & PC_FLAG_WRITING)) {
-		/* Hopefully, we will never get here */
-		printk(KERN_ERR "%s: We wanted to %s, but the device wants us "
-				"to %s!\n", drive->name,
-				(ireason & IO) ? "Write" : "Read",
-				(ireason & IO) ? "Read" : "Write");
-		return ide_do_reset(drive);
-	}
-	if (!(pc->flags & PC_FLAG_WRITING)) {
-		/* Reading - Check that we have enough space */
-		temp = pc->xferred + bcount;
-		if (temp > pc->req_xfer) {
-			if (temp > pc->buf_size) {
-				printk(KERN_ERR "%s: The device wants to send "
-						"us more data than expected - "
-						"discarding data\n",
-						drive->name);
-				ide_pad_transfer(drive, 0, bcount);
-				ide_set_handler(drive, &idetape_pc_intr,
-						IDETAPE_WAIT_CMD, NULL);
-				return ide_started;
-			}
-			debug_log(DBG_PC_INTR, "The device wants to send us more "
-				"data than expected - allowing transfer\n");
-		}
-		xferfunc = hwif->input_data;
-	} else {
-		xferfunc = hwif->output_data;
-	}
-
-	if (pc->bh)
-		ide_tape_io_buffers(drive, pc, bcount,
-				    !!(pc->flags & PC_FLAG_WRITING));
-	else
-		xferfunc(drive, NULL, pc->cur_pos, bcount);
 
-	/* Update the current position */
-	pc->xferred += bcount;
-	pc->cur_pos += bcount;
-
-	debug_log(DBG_PC_INTR, "[cmd %x] transferred %d bytes on that intr.\n",
-			pc->c[0], bcount);
-
-	/* And set the interrupt handler again */
-	ide_set_handler(drive, &idetape_pc_intr, IDETAPE_WAIT_CMD, NULL);
-	return ide_started;
+	return ide_pc_intr(drive, tape->pc, idetape_pc_intr, IDETAPE_WAIT_CMD,
+			   NULL, idetape_update_buffers, idetape_retry_pc,
+			   ide_tape_handle_dsc, ide_tape_io_buffers);
 }
 
 /*
Index: b/drivers/scsi/ide-scsi.c
===================================================================
--- a/drivers/scsi/ide-scsi.c
+++ b/drivers/scsi/ide-scsi.c
@@ -356,120 +356,11 @@ static int idescsi_expiry(ide_drive_t *d
 static ide_startstop_t idescsi_pc_intr (ide_drive_t *drive)
 {
 	idescsi_scsi_t *scsi = drive_to_idescsi(drive);
-	ide_hwif_t *hwif = drive->hwif;
 	struct ide_atapi_pc *pc = scsi->pc;
-	struct request *rq = pc->rq;
-	xfer_func_t *xferfunc;
-	unsigned int temp;
-	u16 bcount;
-	u8 stat, ireason;
-
-	debug_log("Enter %s - interrupt handler\n", __func__);
-
-	if (pc->flags & PC_FLAG_TIMEDOUT) {
-		pc->callback(drive);
-		return ide_stopped;
-	}
-
-	/* Clear the interrupt */
-	stat = ide_read_status(drive);
-
-	if (pc->flags & PC_FLAG_DMA_IN_PROGRESS) {
-		if (hwif->dma_ops->dma_end(drive))
-			pc->flags |= PC_FLAG_DMA_ERROR;
-		else
-			pc->xferred = pc->req_xfer;
-		debug_log("%s: DMA finished\n", drive->name);
-	}
-
-	if ((stat & DRQ_STAT) == 0) {
-		/* No more interrupts */
-		debug_log("Packet command completed, %d bytes transferred\n",
-			  pc->xferred);
-		pc->flags &= ~PC_FLAG_DMA_IN_PROGRESS;
-		local_irq_enable_in_hardirq();
-		if ((stat & ERR_STAT) || (pc->flags & PC_FLAG_DMA_ERROR)) {
-			/* Error detected */
-			debug_log("%s: I/O error\n", drive->name);
-
-			rq->errors++;
-		}
-		pc->callback(drive);
-		return ide_stopped;
-	}
-	if (pc->flags & PC_FLAG_DMA_IN_PROGRESS) {
-		pc->flags &= ~PC_FLAG_DMA_IN_PROGRESS;
-		printk(KERN_ERR "%s: The device wants to issue more interrupts "
-				"in DMA mode\n", drive->name);
-		ide_dma_off(drive);
-		return ide_do_reset(drive);
-	}
-	bcount = (hwif->INB(hwif->io_ports.lbah_addr) << 8) |
-		  hwif->INB(hwif->io_ports.lbam_addr);
-	ireason = hwif->INB(hwif->io_ports.nsect_addr);
-
-	if (ireason & CD) {
-		printk(KERN_ERR "%s: CoD != 0 in %s\n", drive->name, __func__);
-		return ide_do_reset (drive);
-	}
-	if (((ireason & IO) == IO) == !!(pc->flags & PC_FLAG_WRITING)) {
-		/* Hopefully, we will never get here */
-		printk(KERN_ERR "%s: We wanted to %s, but the device wants us "
-				"to %s!\n", drive->name,
-				(ireason & IO) ? "Write" : "Read",
-				(ireason & IO) ? "Read" : "Write");
-		return ide_do_reset(drive);
-	}
-	if (!(pc->flags & PC_FLAG_WRITING)) {
-		temp = pc->xferred + bcount;
-		if (temp > pc->req_xfer) {
-			if (temp > pc->buf_size) {
-				printk(KERN_ERR "%s: The device wants to send "
-						"us more data than expected - "
-						"discarding data\n",
-						drive->name);
-				temp = pc->buf_size - pc->xferred;
-				if (temp) {
-					if (pc->sg)
-						ide_scsi_io_buffers(drive, pc,
-								    temp, 0);
-					else
-						hwif->input_data(drive, NULL,
-							pc->cur_pos, temp);
-					printk(KERN_ERR "%s: transferred %d of "
-							"%d bytes\n",
-							drive->name,
-							temp, bcount);
-				}
-				pc->xferred += temp;
-				pc->cur_pos += temp;
-				ide_pad_transfer(drive, 0, bcount - temp);
-				ide_set_handler(drive, &idescsi_pc_intr, get_timeout(pc), idescsi_expiry);
-				return ide_started;
-			}
-			debug_log("The device wants to send us more data than "
-				  "expected - allowing transfer\n");
-		}
-		xferfunc = hwif->input_data;
-	} else
-		xferfunc = hwif->output_data;
-
-	if (pc->sg)
-		ide_scsi_io_buffers(drive, pc, bcount,
-				    !!(pc->flags & PC_FLAG_WRITING));
-	else
-		xferfunc(drive, NULL, pc->cur_pos, bcount);
 
-	/* Update the current position */
-	pc->xferred += bcount;
-	pc->cur_pos += bcount;
-
-	debug_log("[cmd %x] transferred %d bytes on that intr.\n",
-		  pc->c[0], bcount);
-
-	/* And set the interrupt handler again */
-	ide_set_handler(drive, &idescsi_pc_intr, get_timeout(pc), idescsi_expiry);
-	return ide_started;
+	return ide_pc_intr(drive, pc, idescsi_pc_intr, get_timeout(pc),
+			   idescsi_expiry, NULL, NULL, NULL,
+			   ide_scsi_io_buffers);
 }
 
 static ide_startstop_t idescsi_transfer_pc(ide_drive_t *drive)
Index: b/include/linux/ide.h
===================================================================
--- a/include/linux/ide.h
+++ b/include/linux/ide.h
@@ -953,6 +953,12 @@ extern int drive_is_ready(ide_drive_t *)
 
 void ide_pktcmd_tf_load(ide_drive_t *, u32, u16, u8);
 
+ide_startstop_t ide_pc_intr(ide_drive_t *drive, struct ide_atapi_pc *pc,
+	ide_handler_t *handler, unsigned int timeout, ide_expiry_t *expiry,
+	void (*update_buffers)(ide_drive_t *, struct ide_atapi_pc *),
+	void (*retry_pc)(ide_drive_t *), void (*dsc_handle)(ide_drive_t *),
+	void (*io_buffers)(ide_drive_t *, struct ide_atapi_pc *, unsigned int,
+			   int));
 ide_startstop_t ide_transfer_pc(ide_drive_t *, struct ide_atapi_pc *,
 				ide_handler_t *, unsigned int, ide_expiry_t *);
 ide_startstop_t ide_issue_pc(ide_drive_t *, struct ide_atapi_pc *,
