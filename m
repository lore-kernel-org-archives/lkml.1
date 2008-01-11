Return-Path: <linux-kernel-owner+w=401wt.eu-S1761892AbYAKMIv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761892AbYAKMIv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jan 2008 07:08:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760831AbYAKMEN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Jan 2008 07:04:13 -0500
Received: from smtp110.plus.mail.re1.yahoo.com ([69.147.102.73]:21112 "HELO
	smtp110.plus.mail.re1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1759898AbYAKMDr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jan 2008 07:03:47 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.de;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:Received:From:To:Cc:Subject:Date:Message-Id:X-Mailer:In-Reply-To:References;
  b=HKkw28TlQuNiiDD0dBUi7ZYhuDuin9qmVzjA8ivt4Qc6y4ZvJ5qLeWu20jvRrsCLGn9I5m8GWZUjgcpTtTYTuL7/Qtcq8hLRADdTVFCaxQPhDzlyMPlmNXjie/5b6xTNbkbRHlwZTXvpbbRO2IQAJdhqJwduQ/JriImLBZgsmsY=  ;
X-YMail-OSG: BK_ZI38VM1kQRHEx3phv.jguw_MZlMXE_WaY1VMv9yFFEImHU8K9o7NkN79z2FYM_K4xGnZMEA--
X-Yahoo-Newman-Property: ymail-3
From: Borislav Petkov <bbpetkov@yahoo.de>
To: Bartlomiej@gollum.tnic, Zolnierkiewicz@gollum.tnic, <bzolnier@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org,
       Borislav Petkov <bbpetkov@yahoo.de>
Subject: [PATCH 20/21] ide-floppy: merge idefloppy_{input,output}_buffers
Date: Fri, 11 Jan 2008 12:58:18 +0100
Message-Id: <1200052699-28420-21-git-send-email-bbpetkov@yahoo.de>
X-Mailer: git-send-email debian.1.5.3.7.1-dirty
In-Reply-To: <1200052699-28420-20-git-send-email-bbpetkov@yahoo.de>
References: <1200052699-28420-1-git-send-email-bbpetkov@yahoo.de>
 <1200052699-28420-2-git-send-email-bbpetkov@yahoo.de>
 <1200052699-28420-3-git-send-email-bbpetkov@yahoo.de>
 <1200052699-28420-4-git-send-email-bbpetkov@yahoo.de>
 <1200052699-28420-5-git-send-email-bbpetkov@yahoo.de>
 <1200052699-28420-6-git-send-email-bbpetkov@yahoo.de>
 <1200052699-28420-7-git-send-email-bbpetkov@yahoo.de>
 <1200052699-28420-8-git-send-email-bbpetkov@yahoo.de>
 <1200052699-28420-9-git-send-email-bbpetkov@yahoo.de>
 <1200052699-28420-10-git-send-email-bbpetkov@yahoo.de>
 <1200052699-28420-11-git-send-email-bbpetkov@yahoo.de>
 <1200052699-28420-12-git-send-email-bbpetkov@yahoo.de>
 <1200052699-28420-13-git-send-email-bbpetkov@yahoo.de>
 <1200052699-28420-14-git-send-email-bbpetkov@yahoo.de>
 <1200052699-28420-15-git-send-email-bbpetkov@yahoo.de>
 <1200052699-28420-16-git-send-email-bbpetkov@yahoo.de>
 <1200052699-28420-17-git-send-email-bbpetkov@yahoo.de>
 <1200052699-28420-18-git-send-email-bbpetkov@yahoo.de>
 <1200052699-28420-19-git-send-email-bbpetkov@yahoo.de>
 <1200052699-28420-20-git-send-email-bbpetkov@yahoo.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We merge idefloppy_{input,output}_buffers() into idefloppy_io_buffers() by
introducing a 4th arg. called direction. According to its value
we atapi_input_bytes() or atapi_output_bytes(). Also, simplify the interrupt
handler by removing multiple calls testing the data direction and using a local
variable instead.

Signed-off-by: Borislav Petkov <bbpetkov@yahoo.de>
---
 drivers/ide/ide-floppy.c |   67 +++++++++++----------------------------------
 1 files changed, 17 insertions(+), 50 deletions(-)

diff --git a/drivers/ide/ide-floppy.c b/drivers/ide/ide-floppy.c
index 3d9b1e5..4106eb4 100644
--- a/drivers/ide/ide-floppy.c
+++ b/drivers/ide/ide-floppy.c
@@ -295,42 +295,8 @@ static int idefloppy_do_end_request(ide_drive_t *drive, int uptodate, int nsecs)
 	return 0;
 }
 
-static void idefloppy_input_buffers(ide_drive_t *drive, idefloppy_pc_t *pc,
-		unsigned int bcount)
-{
-	struct request *rq = pc->rq;
-	struct bio_vec *bvec;
-	struct req_iterator iter;
-	unsigned long flags;
-	char *data;
-	int count, done = 0;
-
-	rq_for_each_segment(bvec, rq, iter) {
-		if (!bcount)
-			break;
-
-		count = min(bvec->bv_len, bcount);
-
-		data = bvec_kmap_irq(bvec, &flags);
-		drive->hwif->atapi_input_bytes(drive, data, count);
-		bvec_kunmap_irq(data, &flags);
-
-		bcount -= count;
-		pc->b_count += count;
-		done += count;
-	}
-
-	idefloppy_do_end_request(drive, 1, done >> 9);
-
-	if (bcount) {
-		printk(KERN_ERR "%s: leftover data in %s, bcount == %d\n",
-				drive->name, __FUNCTION__, bcount);
-		idefloppy_discard_data(drive, bcount);
-	}
-}
-
-static void idefloppy_output_buffers(ide_drive_t *drive, idefloppy_pc_t *pc,
-		unsigned int bcount)
+static void idefloppy_io_buffers(ide_drive_t *drive, idefloppy_pc_t *pc,
+		unsigned int bcount, int direction)
 {
 	struct request *rq = pc->rq;
 	struct req_iterator iter;
@@ -346,7 +312,10 @@ static void idefloppy_output_buffers(ide_drive_t *drive, idefloppy_pc_t *pc,
 		count = min(bvec->bv_len, bcount);
 
 		data = bvec_kmap_irq(bvec, &flags);
-		drive->hwif->atapi_output_bytes(drive, data, count);
+		if (direction)
+			drive->hwif->atapi_output_bytes(drive, data, count);
+		else
+			drive->hwif->atapi_input_bytes(drive, data, count);
 		bvec_kunmap_irq(data, &flags);
 
 		bcount -= count;
@@ -360,7 +329,10 @@ static void idefloppy_output_buffers(ide_drive_t *drive, idefloppy_pc_t *pc,
 	if (bcount) {
 		printk(KERN_ERR "%s: leftover data in %s, bcount == %d\n",
 				drive->name, __FUNCTION__, bcount);
-		idefloppy_write_zeros(drive, bcount);
+		if (direction)
+			idefloppy_write_zeros(drive, bcount);
+		else
+			idefloppy_discard_data(drive, bcount);
 	}
 #endif
 }
@@ -491,8 +463,6 @@ static void idefloppy_retry_pc(ide_drive_t *drive)
 	idefloppy_queue_pc_head(drive, pc, rq);
 }
 
-typedef void (io_buf_t)(ide_drive_t *, idefloppy_pc_t *, unsigned int);
-
 /*  The usual interrupt handler called during a packet command. */
 static ide_startstop_t idefloppy_pc_intr(ide_drive_t *drive)
 {
@@ -501,7 +471,6 @@ static ide_startstop_t idefloppy_pc_intr(ide_drive_t *drive)
 	idefloppy_pc_t *pc = floppy->pc;
 	struct request *rq = pc->rq;
 	xfer_func_t *xferfunc;
-	io_buf_t *iobuf_func;
 	unsigned int temp;
 	u16 bcount;
 	u8 stat, ireason;
@@ -573,7 +542,7 @@ static ide_startstop_t idefloppy_pc_intr(ide_drive_t *drive)
 		printk(KERN_ERR "ide-floppy: CoD != 0 in %s\n", __FUNCTION__);
 		return ide_do_reset(drive);
 	}
-	if (((ireason & IO) == IO) == test_bit(PC_WRITING, &pc->flags)) {
+	if (((ireason & IO) == IO) == write) {
 		/* Hopefully, we will never get here */
 		printk(KERN_ERR "ide-floppy: We wanted to %s, ",
 				(ireason & IO) ? "Write" : "Read");
@@ -581,7 +550,7 @@ static ide_startstop_t idefloppy_pc_intr(ide_drive_t *drive)
 				(ireason & IO) ? "Read" : "Write");
 		return ide_do_reset(drive);
 	}
-	if (!test_bit(PC_WRITING, &pc->flags)) {
+	if (!write) {
 		/* Reading - Check that we have enough space */
 		temp = pc->actually_transferred + bcount;
 		if (temp > pc->request_transfer) {
@@ -601,18 +570,16 @@ static ide_startstop_t idefloppy_pc_intr(ide_drive_t *drive)
 					" expected - allowing transfer\n");
 		}
 	}
-	if (test_bit(PC_WRITING, &pc->flags)) {
+
+	if (write)
 		xferfunc = hwif->atapi_output_bytes;
-		iobuf_func = &idefloppy_output_buffers;
-	} else {
+	 else
 		xferfunc = hwif->atapi_input_bytes;
-		iobuf_func = &idefloppy_input_buffers;
-	}
 
-	if (pc->buffer != NULL)
+	if (pc->buffer)
 		xferfunc(drive, pc->current_position, bcount);
 	else
-		iobuf_func(drive, pc, bcount);
+		idefloppy_io_buffers(drive, pc, bcount, write);
 
 	/* Update the current position */
 	pc->actually_transferred += bcount;
-- 
1.5.3.7

