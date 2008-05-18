Return-Path: <linux-kernel-owner+w=401wt.eu-S1756391AbYERSjR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756391AbYERSjR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 May 2008 14:39:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756362AbYERShv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 May 2008 14:37:51 -0400
Received: from fg-out-1718.google.com ([72.14.220.154]:25716 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756256AbYERSht (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 May 2008 14:37:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=kUG52gHZiXD9EJfS5c+/nBJGc0SzARYeQvlKAKkTjhmCmpolTY4lY8kcQKBd42gHSvnms9QV3rkZFPggYu56DuFAhQ1P7ByzYr3xS/y3BYRqwAwshv0qdujXHOz80bFLPpK0MQHmk1kJmdMw9SLtN6782rUjkX2+oVuAdlGIFnI=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: Borislav Petkov <petkovbb@gmail.com>,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Date: Sun, 18 May 2008 20:55:12 +0200
Message-Id: <20080518185512.5636.28587.sendpatchset@localhost.localdomain>
In-Reply-To: <20080518185428.5636.77234.sendpatchset@localhost.localdomain>
References: <20080518185428.5636.77234.sendpatchset@localhost.localdomain>
Subject: [PATCH 05/40] ide-scsi: merge idescsi_input_buffers() and idescsi_output_buffers()
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Merge idescsi_input_buffers() and idescsi_output_buffers()
  into ide_scsi_io_buffers() helper.

While at it:

* Log device name instead of driver name on error.

* Use xfer_func_t.

Cc: Borislav Petkov <petkovbb@gmail.com>
Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/scsi/ide-scsi.c |   81 ++++++++++++++----------------------------------
 1 file changed, 24 insertions(+), 57 deletions(-)

Index: b/drivers/scsi/ide-scsi.c
===================================================================
--- a/drivers/scsi/ide-scsi.c
+++ b/drivers/scsi/ide-scsi.c
@@ -129,51 +129,15 @@ static inline idescsi_scsi_t *drive_to_i
 #define IDESCSI_PC_RQ			90
 
 /*
- *	PIO data transfer routines using the scatter gather table.
+ *	PIO data transfer routine using the scatter gather table.
  */
-static void idescsi_input_buffers(ide_drive_t *drive, struct ide_atapi_pc *pc,
-		unsigned int bcount)
+static void ide_scsi_io_buffers(ide_drive_t *drive, struct ide_atapi_pc *pc,
+				unsigned int bcount, int write)
 {
 	ide_hwif_t *hwif = drive->hwif;
-	int count;
+	xfer_func_t *xf = write ? hwif->output_data : hwif->input_data;
 	char *buf;
-
-	while (bcount) {
-		count = min(pc->sg->length - pc->b_count, bcount);
-		if (PageHighMem(sg_page(pc->sg))) {
-			unsigned long flags;
-
-			local_irq_save(flags);
-			buf = kmap_atomic(sg_page(pc->sg), KM_IRQ0) +
-					pc->sg->offset;
-			hwif->input_data(drive, NULL, buf + pc->b_count, count);
-			kunmap_atomic(buf - pc->sg->offset, KM_IRQ0);
-			local_irq_restore(flags);
-		} else {
-			buf = sg_virt(pc->sg);
-			hwif->input_data(drive, NULL, buf + pc->b_count, count);
-		}
-		bcount -= count; pc->b_count += count;
-		if (pc->b_count == pc->sg->length) {
-			if (!--pc->sg_cnt)
-				break;
-			pc->sg = sg_next(pc->sg);
-			pc->b_count = 0;
-		}
-	}
-
-	if (bcount) {
-		printk (KERN_ERR "ide-scsi: scatter gather table too small, discarding data\n");
-		ide_pad_transfer(drive, 0, bcount);
-	}
-}
-
-static void idescsi_output_buffers(ide_drive_t *drive, struct ide_atapi_pc *pc,
-		unsigned int bcount)
-{
-	ide_hwif_t *hwif = drive->hwif;
 	int count;
-	char *buf;
 
 	while (bcount) {
 		count = min(pc->sg->length - pc->b_count, bcount);
@@ -182,13 +146,13 @@ static void idescsi_output_buffers(ide_d
 
 			local_irq_save(flags);
 			buf = kmap_atomic(sg_page(pc->sg), KM_IRQ0) +
-						pc->sg->offset;
-			hwif->output_data(drive, NULL, buf + pc->b_count, count);
+					  pc->sg->offset;
+			xf(drive, NULL, buf + pc->b_count, count);
 			kunmap_atomic(buf - pc->sg->offset, KM_IRQ0);
 			local_irq_restore(flags);
 		} else {
 			buf = sg_virt(pc->sg);
-			hwif->output_data(drive, NULL, buf + pc->b_count, count);
+			xf(drive, NULL, buf + pc->b_count, count);
 		}
 		bcount -= count; pc->b_count += count;
 		if (pc->b_count == pc->sg->length) {
@@ -200,8 +164,10 @@ static void idescsi_output_buffers(ide_d
 	}
 
 	if (bcount) {
-		printk (KERN_ERR "ide-scsi: scatter gather table too small, padding with zeros\n");
-		ide_pad_transfer(drive, 1, bcount);
+		printk(KERN_ERR "%s: scatter gather table too small, %s\n",
+				drive->name, write ? "padding with zeros"
+						   : "discarding data");
+		ide_pad_transfer(drive, write, bcount);
 	}
 }
 
@@ -370,6 +336,7 @@ static ide_startstop_t idescsi_pc_intr (
 	ide_hwif_t *hwif = drive->hwif;
 	struct ide_atapi_pc *pc = scsi->pc;
 	struct request *rq = pc->rq;
+	xfer_func_t *xferfunc;
 	unsigned int temp;
 	u16 bcount;
 	u8 stat, ireason;
@@ -445,8 +412,8 @@ static ide_startstop_t idescsi_pc_intr (
 				temp = pc->buf_size - pc->xferred;
 				if (temp) {
 					if (pc->sg)
-						idescsi_input_buffers(drive, pc,
-									temp);
+						ide_scsi_io_buffers(drive, pc,
+								    temp, 0);
 					else
 						hwif->input_data(drive, NULL,
 							pc->cur_pos, temp);
@@ -464,16 +431,16 @@ static ide_startstop_t idescsi_pc_intr (
 			printk (KERN_NOTICE "ide-scsi: The scsi wants to send us more data than expected - allowing transfer\n");
 #endif /* IDESCSI_DEBUG_LOG */
 		}
-		if (pc->sg)
-			idescsi_input_buffers(drive, pc, bcount);
-		else
-			hwif->input_data(drive, NULL, pc->cur_pos, bcount);
-	} else {
-		if (pc->sg)
-			idescsi_output_buffers(drive, pc, bcount);
-		else
-			hwif->output_data(drive, NULL, pc->cur_pos, bcount);
-	}
+		xferfunc = hwif->input_data;
+	} else
+		xferfunc = hwif->output_data;
+
+	if (pc->sg)
+		ide_scsi_io_buffers(drive, pc, bcount,
+				    !!(pc->flags & PC_FLAG_WRITING));
+	else
+		xferfunc(drive, NULL, pc->cur_pos, bcount);
+
 	/* Update the current position */
 	pc->xferred += bcount;
 	pc->cur_pos += bcount;
