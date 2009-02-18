Return-Path: <linux-kernel-owner+w=401wt.eu-S1757225AbZBRTWj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757225AbZBRTWj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Feb 2009 14:22:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756030AbZBRTVh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Feb 2009 14:21:37 -0500
Received: from fk-out-0910.google.com ([209.85.128.185]:22957 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754297AbZBRTVc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Feb 2009 14:21:32 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:mime-version:content-type
         :content-transfer-encoding:content-disposition:message-id;
        b=FAQmZIXf4PdSHhh6jD3rl3XdDtxPU2efUUOT61jaiDYKmFPEO8syx0jeKJmNrLdIJm
         Oh3Id3nJKtv250FCEQXVv8RDKWK2O5sbDu65mcGwrRT0fT+WUUbCewEIQK3UaqgZ+ZjT
         ICtsU5H4mZwo7x8l6mPzFSrHDzeanooZ1zoJQ=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Subject: [PATCH 1/2] ide-{floppy,tape}: fix padding for PIO transfers
Date: Wed, 18 Feb 2009 20:20:45 +0100
User-Agent: KMail/1.11.0 (Linux/2.6.29-rc5-next-20090218; KDE/4.2.0; i686; ; )
Cc: linux-kernel@vger.kernel.org, Borislav Petkov <petkovbb@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200902182020.46146.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: [PATCH] ide-{floppy,tape}: fix padding for PIO transfers

* Return number of bytes left to transfer from idetape_{in,out}put_buffers()
  and number of bytes done from ide_tape_io_buffers().

* Fix padding for PIO transfers in ide_pc_intr() so read/write buffers are
  always completely processed and then the transfer is padded if necessary.

* Remove invalid error messages.

* Remove now superfluous padding from ide{_io_buffers,tape_input_buffers}().

While at it:

* Set pc->bh to NULL in idetape_input_buffers() after all bh-s are done.

* Cache !!(pc->flags & PC_FLAG_WRITING) in local variable in ide_pc_intr().

Cc: Borislav Petkov <petkovbb@gmail.com>
Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
against pata-2.6 tree

 drivers/ide/ide-atapi.c |   57 ++++++++++++++++--------------------------------
 drivers/ide/ide-tape.c  |   32 +++++++++++++-------------
 2 files changed, 35 insertions(+), 54 deletions(-)

Index: b/drivers/ide/ide-atapi.c
===================================================================
--- a/drivers/ide/ide-atapi.c
+++ b/drivers/ide/ide-atapi.c
@@ -108,13 +108,6 @@ int ide_io_buffers(ide_drive_t *drive, s
 		}
 	}
 
-	if (bcount) {
-		printk(KERN_ERR "%s: %d leftover bytes, %s\n", drive->name,
-			bcount, write ? "padding with zeros"
-				      : "discarding data");
-		ide_pad_transfer(drive, write, bcount);
-	}
-
 	return done;
 }
 EXPORT_SYMBOL_GPL(ide_io_buffers);
@@ -315,9 +308,10 @@ static ide_startstop_t ide_pc_intr(ide_d
 	struct request *rq = hwif->rq;
 	const struct ide_tp_ops *tp_ops = hwif->tp_ops;
 	xfer_func_t *xferfunc;
-	unsigned int timeout, temp;
+	unsigned int timeout, done;
 	u16 bcount;
 	u8 stat, ireason, dsc = 0;
+	u8 write = !!(pc->flags & PC_FLAG_WRITING);
 
 	debug_log("Enter %s - interrupt handler\n", __func__);
 
@@ -421,8 +415,7 @@ static ide_startstop_t ide_pc_intr(ide_d
 		return ide_do_reset(drive);
 	}
 
-	if (((ireason & ATAPI_IO) == ATAPI_IO) ==
-		!!(pc->flags & PC_FLAG_WRITING)) {
+	if (((ireason & ATAPI_IO) == ATAPI_IO) == write) {
 		/* Hopefully, we will never get here */
 		printk(KERN_ERR "%s: We wanted to %s, but the device wants us "
 				"to %s!\n", drive->name,
@@ -431,45 +424,33 @@ static ide_startstop_t ide_pc_intr(ide_d
 		return ide_do_reset(drive);
 	}
 
-	if (!(pc->flags & PC_FLAG_WRITING)) {
-		/* Reading - Check that we have enough space */
-		temp = pc->xferred + bcount;
-		if (temp > pc->req_xfer) {
-			if (temp > pc->buf_size) {
-				printk(KERN_ERR "%s: The device wants to send "
-						"us more data than expected - "
-						"discarding data\n",
-						drive->name);
-
-				ide_pad_transfer(drive, 0, bcount);
-				goto next_irq;
-			}
-			debug_log("The device wants to send us more data than "
-				  "expected - allowing transfer\n");
-		}
-		xferfunc = tp_ops->input_data;
-	} else
-		xferfunc = tp_ops->output_data;
+	xferfunc = write ? tp_ops->output_data : tp_ops->input_data;
 
 	if ((drive->media == ide_floppy && !pc->buf) ||
 	    (drive->media == ide_tape && pc->bh)) {
-		int done = drive->pc_io_buffers(drive, pc, bcount,
-				  !!(pc->flags & PC_FLAG_WRITING));
+		done = drive->pc_io_buffers(drive, pc, bcount, write);
 
 		/* FIXME: don't do partial completions */
 		if (drive->media == ide_floppy)
 			ide_complete_rq(drive, 0,
 					done ? done : ide_rq_bytes(rq));
-	} else
-		xferfunc(drive, NULL, pc->cur_pos, bcount);
+	} else {
+		done = min_t(unsigned int, bcount, pc->req_xfer - pc->xferred);
+		xferfunc(drive, NULL, pc->cur_pos, done);
+	}
 
 	/* Update the current position */
-	pc->xferred += bcount;
-	pc->cur_pos += bcount;
+	pc->xferred += done;
+	pc->cur_pos += done;
+
+	bcount -= done;
+
+	if (bcount)
+		ide_pad_transfer(drive, write, bcount);
+
+	debug_log("[cmd %x] transferred %d bytes, padded %d bytes\n",
+		  rq->cmd[0], done, bcount);
 
-	debug_log("[cmd %x] transferred %d bytes on that intr.\n",
-		  rq->cmd[0], bcount);
-next_irq:
 	/* And set the interrupt handler again */
 	ide_set_handler(drive, ide_pc_intr, timeout);
 	return ide_started;
Index: b/drivers/ide/ide-tape.c
===================================================================
--- a/drivers/ide/ide-tape.c
+++ b/drivers/ide/ide-tape.c
@@ -297,19 +297,15 @@ static struct ide_tape_obj *ide_tape_chr
 	return tape;
 }
 
-static void idetape_input_buffers(ide_drive_t *drive, struct ide_atapi_pc *pc,
+static int idetape_input_buffers(ide_drive_t *drive, struct ide_atapi_pc *pc,
 				  unsigned int bcount)
 {
 	struct idetape_bh *bh = pc->bh;
 	int count;
 
 	while (bcount) {
-		if (bh == NULL) {
-			printk(KERN_ERR "ide-tape: bh == NULL in "
-				"idetape_input_buffers\n");
-			ide_pad_transfer(drive, 0, bcount);
-			return;
-		}
+		if (bh == NULL)
+			break;
 		count = min(
 			(unsigned int)(bh->b_size - atomic_read(&bh->b_count)),
 			bcount);
@@ -323,21 +319,21 @@ static void idetape_input_buffers(ide_dr
 				atomic_set(&bh->b_count, 0);
 		}
 	}
+
 	pc->bh = bh;
+
+	return bcount;
 }
 
-static void idetape_output_buffers(ide_drive_t *drive, struct ide_atapi_pc *pc,
+static int idetape_output_buffers(ide_drive_t *drive, struct ide_atapi_pc *pc,
 				   unsigned int bcount)
 {
 	struct idetape_bh *bh = pc->bh;
 	int count;
 
 	while (bcount) {
-		if (bh == NULL) {
-			printk(KERN_ERR "ide-tape: bh == NULL in %s\n",
-					__func__);
-			return;
-		}
+		if (bh == NULL)
+			break;
 		count = min((unsigned int)pc->b_count, (unsigned int)bcount);
 		drive->hwif->tp_ops->output_data(drive, NULL, pc->b_data, count);
 		bcount -= count;
@@ -352,6 +348,8 @@ static void idetape_output_buffers(ide_d
 			}
 		}
 	}
+
+	return bcount;
 }
 
 static void idetape_update_buffers(ide_drive_t *drive, struct ide_atapi_pc *pc)
@@ -563,12 +561,14 @@ static void ide_tape_handle_dsc(ide_driv
 static int ide_tape_io_buffers(ide_drive_t *drive, struct ide_atapi_pc *pc,
 				unsigned int bcount, int write)
 {
+	unsigned int bleft;
+
 	if (write)
-		idetape_output_buffers(drive, pc, bcount);
+		bleft = idetape_output_buffers(drive, pc, bcount);
 	else
-		idetape_input_buffers(drive, pc, bcount);
+		bleft = idetape_input_buffers(drive, pc, bcount);
 
-	return bcount;
+	return bcount - bleft;
 }
 
 /*
