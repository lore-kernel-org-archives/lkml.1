Return-Path: <linux-kernel-owner+w=401wt.eu-S1762123AbYBMU61@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762123AbYBMU61 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2008 15:58:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753248AbYBMU6S
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Feb 2008 15:58:18 -0500
Received: from nf-out-0910.google.com ([64.233.182.191]:16577 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752503AbYBMU6Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2008 15:58:16 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=date:to:cc:subject:message-id:reply-to:mail-followup-to:mime-version:content-type:content-disposition:content-transfer-encoding:user-agent:from;
        b=ZWjdO5/C3ryAiqazQoKlvRFazym+P+idK2nFuX44+5UHw+xy0IA140cgLbgqBcvuYYTCbJESscXFzd/TLfWaVayrOxUtEfAtdKE+ePnvo/frozFJBrxtP5v93y1yeKLwekMlfT901oC2lnxqSYT8PiJ0k/Pqq+/QFWMF0QG1bB0=
Date: Wed, 13 Feb 2008 21:57:34 +0100
To: bzolnier@gmail.com
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org
Subject: [PATCH] ide-floppy: merge callbacks
Message-ID: <20080213205733.GC13446@gollum.tnic>
Reply-To: petkovbb@gmail.com
Mail-Followup-To: petkovbb@gmail.com, bzolnier@gmail.com,
	linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.17 (2007-11-01)
From: Borislav Petkov <petkovbb@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

commit d1f1f84f413ab00cb2fec48170d022fcd900e214
Author: Borislav Petkov <petkovbb@gmail.com>
Date:   Wed Feb 13 20:26:56 2008 +0100

    ide-floppy: merge callbacks
    
    The appropriate functionality of the callback is established through querying
    the ATAPI packet command in pc->c[0].
    
    While at it, simplify if (floppy->failed_pc)-branch to be found in the original
    idefloppy_request_sense_callback().
    
    Signed-off-by: Borislav Petkov <petkovbb@gmail.com>

diff --git a/drivers/ide/ide-floppy.c b/drivers/ide/ide-floppy.c
index 5f133df..1365310 100644
--- a/drivers/ide/ide-floppy.c
+++ b/drivers/ide/ide-floppy.c
@@ -313,50 +313,39 @@ static struct request *idefloppy_next_rq_storage(ide_drive_t *drive)
 	return (&floppy->rq_stack[floppy->rq_stack_index++]);
 }
 
-static void idefloppy_request_sense_callback(ide_drive_t *drive)
+static void ide_floppy_callback(ide_drive_t *drive)
 {
 	idefloppy_floppy_t *floppy = drive->driver_data;
-	u8 *buf = floppy->pc->buf;
 
 	debug_log("Reached %s\n", __func__);
 
-	if (!floppy->pc->error) {
-		floppy->sense_key = buf[2] & 0x0F;
-		floppy->asc = buf[12];
-		floppy->ascq = buf[13];
-		floppy->progress_indication = buf[15] & 0x80 ?
-			(u16)get_unaligned((u16 *)&buf[16]) : 0x10000;
+	if (floppy->pc->c[0] == GPCMD_REQUEST_SENSE) {
+		u8 *buf = floppy->pc->buf;
 
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
-
-
-		idefloppy_end_request(drive, 1, 0);
-	} else {
-		printk(KERN_ERR "Error in REQUEST SENSE itself - Aborting"
-				" request!\n");
-		idefloppy_end_request(drive, 0, 0);
-	}
-}
+		if (!floppy->pc->error) {
+			floppy->sense_key = buf[2] & 0x0F;
+			floppy->asc = buf[12];
+			floppy->ascq = buf[13];
+			floppy->progress_indication = buf[15] & 0x80 ?
+				(u16)get_unaligned((u16 *)&buf[16]) : 0x10000;
 
-/* General packet command callback function. */
-static void idefloppy_pc_callback(ide_drive_t *drive)
-{
-	idefloppy_floppy_t *floppy = drive->driver_data;
+			if (floppy->failed_pc)
+				debug_log("pc = %x, ", floppy->failed_pc->c[0]);
 
-	debug_log("Reached %s\n", __func__);
+			debug_log("sense key = %x, asc = %x, ascq = %x\n",
+				floppy->sense_key, floppy->asc,	floppy->ascq);
 
-	idefloppy_end_request(drive, floppy->pc->error ? 0 : 1, 0);
+			idefloppy_end_request(drive, 1, 0);
+		} else {
+			printk(KERN_ERR "Error in REQUEST SENSE itself - "
+					"Aborting request!\n");
+			idefloppy_end_request(drive, 0, 0);
+		}
+	} else if (floppy->pc->c[0] == GPCMD_READ_10 ||
+		floppy->pc->c[0] == GPCMD_WRITE_10)
+		idefloppy_end_request(drive, 1, 0);
+	else
+		idefloppy_end_request(drive, floppy->pc->error ? 0 : 1, 0);
 }
 
 static void idefloppy_init_pc(struct ide_atapi_pc *pc)
@@ -367,7 +356,7 @@ static void idefloppy_init_pc(struct ide_atapi_pc *pc)
 	pc->req_xfer = 0;
 	pc->buf = pc->pc_buf;
 	pc->buf_size = IDEFLOPPY_PC_BUFFER_SIZE;
-	pc->idefloppy_callback = &idefloppy_pc_callback;
+	pc->idefloppy_callback = &ide_floppy_callback;
 }
 
 static void idefloppy_create_request_sense_cmd(struct ide_atapi_pc *pc)
@@ -376,7 +365,6 @@ static void idefloppy_create_request_sense_cmd(struct ide_atapi_pc *pc)
 	pc->c[0] = GPCMD_REQUEST_SENSE;
 	pc->c[4] = 255;
 	pc->req_xfer = 18;
-	pc->idefloppy_callback = &idefloppy_request_sense_callback;
 }
 
 /*
@@ -697,14 +685,6 @@ static ide_startstop_t idefloppy_issue_pc(ide_drive_t *drive,
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
@@ -799,7 +779,6 @@ static void idefloppy_create_rw_cmd(idefloppy_floppy_t *floppy,
 	put_unaligned(cpu_to_be16(blocks), (unsigned short *)&pc->c[7]);
 	put_unaligned(cpu_to_be32(block), (unsigned int *) &pc->c[2]);
 
-	pc->idefloppy_callback = &idefloppy_rw_callback;
 	pc->rq = rq;
 	pc->b_count = cmd == READ ? 0 : rq->bio->bi_size;
 	if (rq->cmd_flags & REQ_RW)
@@ -813,7 +792,6 @@ static void idefloppy_blockpc_cmd(idefloppy_floppy_t *floppy,
 		struct ide_atapi_pc *pc, struct request *rq)
 {
 	idefloppy_init_pc(pc);
-	pc->idefloppy_callback = &idefloppy_rw_callback;
 	memcpy(pc->c, rq->cmd, sizeof(pc->c));
 	pc->rq = rq;
 	pc->b_count = rq->data_len;


-- 
Regards/Gruﬂ,
    Boris.
