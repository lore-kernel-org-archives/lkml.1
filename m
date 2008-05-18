Return-Path: <linux-kernel-owner+w=401wt.eu-S1759566AbYERSpb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759566AbYERSpb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 May 2008 14:45:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757465AbYERSj4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 May 2008 14:39:56 -0400
Received: from fg-out-1718.google.com ([72.14.220.158]:28998 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757444AbYERSjz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 May 2008 14:39:55 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=ATzCPzGPiPUduiQ4xKoi/HEk7eql6uVl22mYgun/k+IgQH9cSI3WZW2qUlyhUtvVAXNtKdu5V1HOazaSyK71LTYryxzBk0FzDm+7KDWKGOXas0keiKt5x8JxVcAkoTgALSWkONr48yar7dKpOjcnOrDp4fWj7KqOS5OyPO3UvOI=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: Borislav Petkov <petkovbb@gmail.com>,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Date: Sun, 18 May 2008 20:57:19 +0200
Message-Id: <20080518185719.5636.31745.sendpatchset@localhost.localdomain>
In-Reply-To: <20080518185428.5636.77234.sendpatchset@localhost.localdomain>
References: <20080518185428.5636.77234.sendpatchset@localhost.localdomain>
Subject: [PATCH 19/40] ide-floppy: merge callbacks
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Borislav Petkov <petkovbb@gmail.com>
Subject: [PATCH] ide-floppy: merge callbacks

The appropriate functionality of the callback is established through querying
the ATAPI packet command in pc->c[0].

While at it, simplify if (floppy->failed_pc)-branch to be found in the original
idefloppy_request_sense_callback().

Bart:
- keep handling for blk_pc_request() requests unchanged + add FIXME
- add uptodate variable + leave just one idefloppy_end_request() call
- add newline to the debug message

Signed-off-by: Borislav Petkov <petkovbb@gmail.com>
Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/ide-floppy.c |   71 +++++++++++++++--------------------------------
 1 file changed, 24 insertions(+), 47 deletions(-)

Index: b/drivers/ide/ide-floppy.c
===================================================================
--- a/drivers/ide/ide-floppy.c
+++ b/drivers/ide/ide-floppy.c
@@ -312,50 +312,38 @@ static struct request *idefloppy_next_rq
 	return (&floppy->rq_stack[floppy->rq_stack_index++]);
 }
 
-static void idefloppy_request_sense_callback(ide_drive_t *drive)
+static void ide_floppy_callback(ide_drive_t *drive)
 {
 	idefloppy_floppy_t *floppy = drive->driver_data;
-	u8 *buf = floppy->pc->buf;
+	struct ide_atapi_pc *pc = floppy->pc;
+	int uptodate = pc->error ? 0 : 1;
 
 	debug_log("Reached %s\n", __func__);
 
-	if (!floppy->pc->error) {
-		floppy->sense_key = buf[2] & 0x0F;
-		floppy->asc = buf[12];
-		floppy->ascq = buf[13];
-		floppy->progress_indication = buf[15] & 0x80 ?
-			(u16)get_unaligned((u16 *)&buf[16]) : 0x10000;
-
-		if (floppy->failed_pc)
-			debug_log("pc = %x, sense key = %x, asc = %x,"
-					" ascq = %x\n",
-					floppy->failed_pc->c[0],
-					floppy->sense_key,
-					floppy->asc,
-					floppy->ascq);
-		else
-			debug_log("sense key = %x, asc = %x, ascq = %x\n",
-					floppy->sense_key,
-					floppy->asc,
-					floppy->ascq);
+	if (pc->c[0] == GPCMD_READ_10 || pc->c[0] == GPCMD_WRITE_10 ||
+	    (pc->rq && blk_pc_request(pc->rq)))
+		uptodate = 1; /* FIXME */
+	else if (pc->c[0] == GPCMD_REQUEST_SENSE) {
+		u8 *buf = floppy->pc->buf;
+
+		if (!pc->error) {
+			floppy->sense_key = buf[2] & 0x0F;
+			floppy->asc = buf[12];
+			floppy->ascq = buf[13];
+			floppy->progress_indication = buf[15] & 0x80 ?
+				(u16)get_unaligned((u16 *)&buf[16]) : 0x10000;
 
+			if (floppy->failed_pc)
+				debug_log("pc = %x, ", floppy->failed_pc->c[0]);
 
-		idefloppy_end_request(drive, 1, 0);
-	} else {
-		printk(KERN_ERR "Error in REQUEST SENSE itself - Aborting"
-				" request!\n");
-		idefloppy_end_request(drive, 0, 0);
+			debug_log("sense key = %x, asc = %x, ascq = %x\n",
+				  floppy->sense_key, floppy->asc, floppy->ascq);
+		} else
+			printk(KERN_ERR "Error in REQUEST SENSE itself - "
+					"Aborting request!\n");
 	}
-}
 
-/* General packet command callback function. */
-static void idefloppy_pc_callback(ide_drive_t *drive)
-{
-	idefloppy_floppy_t *floppy = drive->driver_data;
-
-	debug_log("Reached %s\n", __func__);
-
-	idefloppy_end_request(drive, floppy->pc->error ? 0 : 1, 0);
+	idefloppy_end_request(drive, uptodate, 0);
 }
 
 static void idefloppy_init_pc(struct ide_atapi_pc *pc)
@@ -366,7 +354,7 @@ static void idefloppy_init_pc(struct ide
 	pc->req_xfer = 0;
 	pc->buf = pc->pc_buf;
 	pc->buf_size = IDEFLOPPY_PC_BUFFER_SIZE;
-	pc->idefloppy_callback = &idefloppy_pc_callback;
+	pc->idefloppy_callback = &ide_floppy_callback;
 }
 
 static void idefloppy_create_request_sense_cmd(struct ide_atapi_pc *pc)
@@ -375,7 +363,6 @@ static void idefloppy_create_request_sen
 	pc->c[0] = GPCMD_REQUEST_SENSE;
 	pc->c[4] = 255;
 	pc->req_xfer = 18;
-	pc->idefloppy_callback = &idefloppy_request_sense_callback;
 }
 
 /*
@@ -668,14 +655,6 @@ static ide_startstop_t idefloppy_issue_p
 	}
 }
 
-static void idefloppy_rw_callback(ide_drive_t *drive)
-{
-	debug_log("Reached %s\n", __func__);
-
-	idefloppy_end_request(drive, 1, 0);
-	return;
-}
-
 static void idefloppy_create_prevent_cmd(struct ide_atapi_pc *pc, int prevent)
 {
 	debug_log("creating prevent removal command, prevent = %d\n", prevent);
@@ -770,7 +749,6 @@ static void idefloppy_create_rw_cmd(idef
 	put_unaligned(cpu_to_be16(blocks), (unsigned short *)&pc->c[7]);
 	put_unaligned(cpu_to_be32(block), (unsigned int *) &pc->c[2]);
 
-	pc->idefloppy_callback = &idefloppy_rw_callback;
 	pc->rq = rq;
 	pc->b_count = cmd == READ ? 0 : rq->bio->bi_size;
 	if (rq->cmd_flags & REQ_RW)
@@ -784,7 +762,6 @@ static void idefloppy_blockpc_cmd(ideflo
 		struct ide_atapi_pc *pc, struct request *rq)
 {
 	idefloppy_init_pc(pc);
-	pc->idefloppy_callback = &idefloppy_rw_callback;
 	memcpy(pc->c, rq->cmd, sizeof(pc->c));
 	pc->rq = rq;
 	pc->b_count = rq->data_len;
