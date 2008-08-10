Return-Path: <linux-kernel-owner+w=401wt.eu-S1756106AbYHJPi4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756106AbYHJPi4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Aug 2008 11:38:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754015AbYHJPiD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Aug 2008 11:38:03 -0400
Received: from fk-out-0910.google.com ([209.85.128.191]:10683 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755814AbYHJPiB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Aug 2008 11:38:01 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=IZLHNbInGdTaATaBOvrFQabCUHwMrWn3fzJT7SM6tSKLpeHIrGBPsjaAq6paeaLrXD
         tcqDxgLHPHu8bxswFeYtW8h80LaAJqPZBTkhHxA3U5ZNW/ONO36ir2oGIuw2if1jefK4
         d+UC0akN6nx79271eVOuHbNSTA8CaoMP4i4QY=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: Borislav Petkov <petkovbb@gmail.com>,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Date: Sun, 10 Aug 2008 17:35:48 +0200
Message-Id: <20080810153548.16255.52630.sendpatchset@localhost.localdomain>
In-Reply-To: <20080810153527.16255.2504.sendpatchset@localhost.localdomain>
References: <20080810153527.16255.2504.sendpatchset@localhost.localdomain>
Subject: [PATCH 03/22] ide: add ide_io_buffers() helper
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Make ->io_buffers method return number of bytes transferred.

* Use ide_end_request() instead of idefloppy_end_request()
  in ide_floppy_io_buffers() and then move the call out to
  ide_pc_intr().

* Add ide_io_buffers() helper and convert ide-{floppy,scsi}.c
  to use it instead of ide*_io_buffers().

There should be no functional changes caused by this patch.

Cc: Borislav Petkov <petkovbb@gmail.com>
Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/ide-atapi.c  |   63 ++++++++++++++++++++++++++++++++++++++++++++---
 drivers/ide/ide-floppy.c |   47 -----------------------------------
 drivers/ide/ide-tape.c   |    4 ++
 drivers/scsi/ide-scsi.c  |   46 ----------------------------------
 include/linux/ide.h      |    4 ++
 5 files changed, 67 insertions(+), 97 deletions(-)

Index: b/drivers/ide/ide-atapi.c
===================================================================
--- a/drivers/ide/ide-atapi.c
+++ b/drivers/ide/ide-atapi.c
@@ -61,12 +61,62 @@ int ide_check_atapi_device(ide_drive_t *
 }
 EXPORT_SYMBOL_GPL(ide_check_atapi_device);
 
+/* PIO data transfer routine using the scatter gather table. */
+int ide_io_buffers(ide_drive_t *drive, struct ide_atapi_pc *pc,
+		    unsigned int bcount, int write)
+{
+	ide_hwif_t *hwif = drive->hwif;
+	const struct ide_tp_ops *tp_ops = hwif->tp_ops;
+	xfer_func_t *xf = write ? tp_ops->output_data : tp_ops->input_data;
+	struct scatterlist *sg = pc->sg;
+	char *buf;
+	int count, done = 0;
+
+	while (bcount) {
+		count = min(sg->length - pc->b_count, bcount);
+
+		if (PageHighMem(sg_page(sg))) {
+			unsigned long flags;
+
+			local_irq_save(flags);
+			buf = kmap_atomic(sg_page(sg), KM_IRQ0) + sg->offset;
+			xf(drive, NULL, buf + pc->b_count, count);
+			kunmap_atomic(buf - sg->offset, KM_IRQ0);
+			local_irq_restore(flags);
+		} else {
+			buf = sg_virt(sg);
+			xf(drive, NULL, buf + pc->b_count, count);
+		}
+
+		bcount -= count;
+		pc->b_count += count;
+		done += count;
+
+		if (pc->b_count == sg->length) {
+			if (!--pc->sg_cnt)
+				break;
+			pc->sg = sg = sg_next(sg);
+			pc->b_count = 0;
+		}
+	}
+
+	if (bcount) {
+		printk(KERN_ERR "%s: %d leftover bytes, %s\n", drive->name,
+			bcount, write ? "padding with zeros"
+				      : "discarding data");
+		ide_pad_transfer(drive, write, bcount);
+	}
+
+	return done;
+}
+EXPORT_SYMBOL_GPL(ide_io_buffers);
+
 /* TODO: unify the code thus making some arguments go away */
 ide_startstop_t ide_pc_intr(ide_drive_t *drive, struct ide_atapi_pc *pc,
 	ide_handler_t *handler, unsigned int timeout, ide_expiry_t *expiry,
 	void (*update_buffers)(ide_drive_t *, struct ide_atapi_pc *),
 	void (*retry_pc)(ide_drive_t *), void (*dsc_handle)(ide_drive_t *),
-	void (*io_buffers)(ide_drive_t *, struct ide_atapi_pc *, unsigned, int))
+	int (*io_buffers)(ide_drive_t *, struct ide_atapi_pc *, unsigned, int))
 {
 	ide_hwif_t *hwif = drive->hwif;
 	struct request *rq = hwif->hwgroup->rq;
@@ -219,9 +269,14 @@ cmd_finished:
 
 	if ((drive->media == ide_floppy && !scsi && !pc->buf) ||
 	    (drive->media == ide_tape && !scsi && pc->bh) ||
-	    (scsi && pc->sg))
-		io_buffers(drive, pc, bcount, !!(pc->flags & PC_FLAG_WRITING));
-	else
+	    (scsi && pc->sg)) {
+		int done = io_buffers(drive, pc, bcount,
+				  !!(pc->flags & PC_FLAG_WRITING));
+
+		/* FIXME: don't do partial completions */
+		if (drive->media == ide_floppy && !scsi)
+			ide_end_request(drive, 1, done >> 9);
+	} else
 		xferfunc(drive, NULL, pc->cur_pos, bcount);
 
 	/* Update the current position */
Index: b/drivers/ide/ide-floppy.c
===================================================================
--- a/drivers/ide/ide-floppy.c
+++ b/drivers/ide/ide-floppy.c
@@ -207,51 +207,6 @@ static int idefloppy_end_request(ide_dri
 	return 0;
 }
 
-static void ide_floppy_io_buffers(ide_drive_t *drive, struct ide_atapi_pc *pc,
-				  unsigned int bcount, int direction)
-{
-	ide_hwif_t *hwif = drive->hwif;
-	const struct ide_tp_ops *tp_ops = hwif->tp_ops;
-	xfer_func_t *xf = direction ? tp_ops->output_data : tp_ops->input_data;
-	struct scatterlist *sg = pc->sg;
-	char *buf;
-	int count, done = 0;
-
-	while (bcount) {
-		count = min(sg->length - pc->b_count, bcount);
-		if (PageHighMem(sg_page(sg))) {
-			unsigned long flags;
-
-			local_irq_save(flags);
-			buf = kmap_atomic(sg_page(sg), KM_IRQ0) + sg->offset;
-			xf(drive, NULL, buf + pc->b_count, count);
-			kunmap_atomic(buf - sg->offset, KM_IRQ0);
-			local_irq_restore(flags);
-		} else {
-			buf = sg_virt(sg);
-			xf(drive, NULL, buf + pc->b_count, count);
-		}
-		bcount -= count;
-		pc->b_count += count;
-		done += count;
-
-		if (pc->b_count == sg->length) {
-			if (!--pc->sg_cnt)
-				break;
-			pc->sg = sg = sg_next(sg);
-			pc->b_count = 0;
-		}
-	}
-
-	idefloppy_end_request(drive, 1, done >> 9);
-
-	if (bcount) {
-		printk(KERN_ERR "%s: leftover data in %s, bcount == %d\n",
-				drive->name, __func__, bcount);
-		ide_pad_transfer(drive, direction, bcount);
-	}
-}
-
 static void idefloppy_update_buffers(ide_drive_t *drive,
 				struct ide_atapi_pc *pc)
 {
@@ -355,7 +310,7 @@ static ide_startstop_t idefloppy_pc_intr
 
 	return ide_pc_intr(drive, floppy->pc, idefloppy_pc_intr,
 			   IDEFLOPPY_WAIT_CMD, NULL, idefloppy_update_buffers,
-			   idefloppy_retry_pc, NULL, ide_floppy_io_buffers);
+			   idefloppy_retry_pc, NULL, ide_io_buffers);
 }
 
 /*
Index: b/drivers/ide/ide-tape.c
===================================================================
--- a/drivers/ide/ide-tape.c
+++ b/drivers/ide/ide-tape.c
@@ -693,13 +693,15 @@ static void ide_tape_handle_dsc(ide_driv
 	idetape_postpone_request(drive);
 }
 
-static void ide_tape_io_buffers(ide_drive_t *drive, struct ide_atapi_pc *pc,
+static int ide_tape_io_buffers(ide_drive_t *drive, struct ide_atapi_pc *pc,
 				unsigned int bcount, int write)
 {
 	if (write)
 		idetape_output_buffers(drive, pc, bcount);
 	else
 		idetape_input_buffers(drive, pc, bcount);
+
+	return bcount;
 }
 
 /*
Index: b/drivers/scsi/ide-scsi.c
===================================================================
--- a/drivers/scsi/ide-scsi.c
+++ b/drivers/scsi/ide-scsi.c
@@ -130,50 +130,6 @@ static inline idescsi_scsi_t *drive_to_i
 	return scsihost_to_idescsi(ide_drive->driver_data);
 }
 
-/*
- *	PIO data transfer routine using the scatter gather table.
- */
-static void ide_scsi_io_buffers(ide_drive_t *drive, struct ide_atapi_pc *pc,
-				unsigned int bcount, int write)
-{
-	ide_hwif_t *hwif = drive->hwif;
-	const struct ide_tp_ops *tp_ops = hwif->tp_ops;
-	xfer_func_t *xf = write ? tp_ops->output_data : tp_ops->input_data;
-	struct scatterlist *sg = pc->sg;
-	char *buf;
-	int count;
-
-	while (bcount) {
-		count = min(sg->length - pc->b_count, bcount);
-		if (PageHighMem(sg_page(sg))) {
-			unsigned long flags;
-
-			local_irq_save(flags);
-			buf = kmap_atomic(sg_page(sg), KM_IRQ0) + sg->offset;
-			xf(drive, NULL, buf + pc->b_count, count);
-			kunmap_atomic(buf - sg->offset, KM_IRQ0);
-			local_irq_restore(flags);
-		} else {
-			buf = sg_virt(sg);
-			xf(drive, NULL, buf + pc->b_count, count);
-		}
-		bcount -= count; pc->b_count += count;
-		if (pc->b_count == sg->length) {
-			if (!--pc->sg_cnt)
-				break;
-			pc->sg = sg = sg_next(sg);
-			pc->b_count = 0;
-		}
-	}
-
-	if (bcount) {
-		printk(KERN_ERR "%s: scatter gather table too small, %s\n",
-				drive->name, write ? "padding with zeros"
-						   : "discarding data");
-		ide_pad_transfer(drive, write, bcount);
-	}
-}
-
 static void ide_scsi_hex_dump(u8 *data, int len)
 {
 	print_hex_dump(KERN_CONT, "", DUMP_PREFIX_NONE, 16, 1, data, len, 0);
@@ -343,7 +299,7 @@ static ide_startstop_t idescsi_pc_intr (
 
 	return ide_pc_intr(drive, pc, idescsi_pc_intr, get_timeout(pc),
 			   idescsi_expiry, NULL, NULL, NULL,
-			   ide_scsi_io_buffers);
+			   ide_io_buffers);
 }
 
 static ide_startstop_t idescsi_transfer_pc(ide_drive_t *drive)
Index: b/include/linux/ide.h
===================================================================
--- a/include/linux/ide.h
+++ b/include/linux/ide.h
@@ -1097,6 +1097,8 @@ void ide_tf_read(ide_drive_t *, ide_task
 void ide_input_data(ide_drive_t *, struct request *, void *, unsigned int);
 void ide_output_data(ide_drive_t *, struct request *, void *, unsigned int);
 
+int ide_io_buffers(ide_drive_t *, struct ide_atapi_pc *, unsigned int, int);
+
 extern void SELECT_DRIVE(ide_drive_t *);
 void SELECT_MASK(ide_drive_t *, int);
 
@@ -1113,7 +1115,7 @@ ide_startstop_t ide_pc_intr(ide_drive_t 
 	ide_handler_t *handler, unsigned int timeout, ide_expiry_t *expiry,
 	void (*update_buffers)(ide_drive_t *, struct ide_atapi_pc *),
 	void (*retry_pc)(ide_drive_t *), void (*dsc_handle)(ide_drive_t *),
-	void (*io_buffers)(ide_drive_t *, struct ide_atapi_pc *, unsigned int,
+	int (*io_buffers)(ide_drive_t *, struct ide_atapi_pc *, unsigned int,
 			   int));
 ide_startstop_t ide_transfer_pc(ide_drive_t *, struct ide_atapi_pc *,
 				ide_handler_t *, unsigned int, ide_expiry_t *);
