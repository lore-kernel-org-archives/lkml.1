Return-Path: <linux-kernel-owner+w=401wt.eu-S1757397AbYA0Ink@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757397AbYA0Ink (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jan 2008 03:43:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756306AbYA0Imi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Jan 2008 03:42:38 -0500
Received: from smtp109.plus.mail.re1.yahoo.com ([69.147.102.72]:26255 "HELO
	smtp109.plus.mail.re1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1756054AbYA0Img (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jan 2008 03:42:36 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.de;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:Received:From:To:Cc:Subject:Date:Message-Id:X-Mailer:In-Reply-To:References;
  b=D3hmIKuLq/oybyS2j5ipiGYwfXUiezTbSZh9ZSkpECM2MgHFKma+7bqlDpWvGd59f07kHtjuBqh83gGAuAf1NvinJrDICPUHeZDQAQrjYtfIY6CCnCYClB53NpWdIhulNvVAFBUSdJSlZXWV2cuhTBwlVWgG8t/cPiwb69VjN0A=  ;
X-YMail-OSG: VMe5QRUVM1lO5pheg1xRQQbwI.uQHzZxJSb0jVoSIsoyjbGFRH7A9dyIDTA8.vUApH6JJJMxSw--
X-Yahoo-Newman-Property: ymail-3
From: Borislav Petkov <bbpetkov@yahoo.de>
To: <bzolnier@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org,
       Borislav Petkov <bbpetkov@yahoo.de>
Subject: [PATCH 3/32] ide-tape: remove struct idetape_request_sense_result_t
Date: Sun, 27 Jan 2008 09:41:23 +0100
Message-Id: <1201423312-2460-4-git-send-email-bbpetkov@yahoo.de>
X-Mailer: git-send-email debian.1.5.3.7.1-dirty
In-Reply-To: <1201423312-2460-1-git-send-email-bbpetkov@yahoo.de>
References: <1201423312-2460-1-git-send-email-bbpetkov@yahoo.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Borislav Petkov <bbpetkov@yahoo.de>
---
 drivers/ide/ide-tape.c |   83 +++++++++++++++--------------------------------
 1 files changed, 27 insertions(+), 56 deletions(-)

diff --git a/drivers/ide/ide-tape.c b/drivers/ide/ide-tape.c
index 3bedeb8..173ac0d 100644
--- a/drivers/ide/ide-tape.c
+++ b/drivers/ide/ide-tape.c
@@ -333,32 +333,6 @@ typedef struct idetape_stage_s {
 } idetape_stage_t;
 
 /*
- *	REQUEST SENSE packet command result - Data Format.
- */
-typedef struct {
-	unsigned	error_code	:7;	/* Current of deferred errors */
-	unsigned	valid		:1;	/* The information field conforms to QIC-157C */
-	__u8		reserved1	:8;	/* Segment Number - Reserved */
-	unsigned	sense_key	:4;	/* Sense Key */
-	unsigned	reserved2_4	:1;	/* Reserved */
-	unsigned	ili		:1;	/* Incorrect Length Indicator */
-	unsigned	eom		:1;	/* End Of Medium */
-	unsigned	filemark 	:1;	/* Filemark */
-	__u32		information __attribute__ ((packed));
-	__u8		asl;			/* Additional sense length (n-7) */
-	__u32		command_specific;	/* Additional command specific information */
-	__u8		asc;			/* Additional Sense Code */
-	__u8		ascq;			/* Additional Sense Code Qualifier */
-	__u8		replaceable_unit_code;	/* Field Replaceable Unit Code */
-	unsigned	sk_specific1 	:7;	/* Sense Key Specific */
-	unsigned	sksv		:1;	/* Sense Key Specific information is valid */
-	__u8		sk_specific2;		/* Sense Key Specific */
-	__u8		sk_specific3;		/* Sense Key Specific */
-	__u8		pad[2];			/* Padding to 20 bytes */
-} idetape_request_sense_result_t;
-
-
-/*
  *	Most of our global data which we need to save even as we leave the
  *	driver due to an interrupt or a timer event is stored in a variable
  *	of type idetape_tape_t, defined below.
@@ -512,9 +486,6 @@ typedef struct ide_tape_obj {
 	int avg_size;
 	int avg_speed;
 
-	/* last sense information */
-	idetape_request_sense_result_t sense;
-
 	char vendor_id[10];
 	char product_id[18];
 	char firmware_revision[6];
@@ -1025,67 +996,67 @@ static void idetape_init_pc (idetape_pc_t *pc)
 }
 
 /*
- *	idetape_analyze_error is called on each failed packet command retry
- *	to analyze the request sense. We currently do not utilize this
- *	information.
+ * called on each failed packet command retry to analyze the request sense. We
+ * currently do not utilize this information.
  */
-static void idetape_analyze_error (ide_drive_t *drive, idetape_request_sense_result_t *result)
+static void idetape_analyze_error(ide_drive_t *drive, u8 *sense)
 {
 	idetape_tape_t *tape = drive->driver_data;
 	idetape_pc_t *pc = tape->failed_pc;
 
-	tape->sense     = *result;
-	tape->sense_key = result->sense_key;
-	tape->asc       = result->asc;
-	tape->ascq      = result->ascq;
+	tape->sense_key = sense[2] & 0xF;
+	tape->asc       = sense[12];
+	tape->ascq      = sense[13];
 #if IDETAPE_DEBUG_LOG
 	/*
-	 *	Without debugging, we only log an error if we decided to
-	 *	give up retrying.
+	 * Without debugging, we only log an error if we decided to give up
+	 * retrying.
 	 */
 	if (tape->debug_level >= 1)
 		printk(KERN_INFO "ide-tape: pc = %x, sense key = %x, "
 			"asc = %x, ascq = %x\n",
-			pc->c[0], result->sense_key,
-			result->asc, result->ascq);
+			pc->c[0], tape->sense_key,
+			tape->asc, tape->ascq);
 #endif /* IDETAPE_DEBUG_LOG */
 
-	/*
-	 *	Correct pc->actually_transferred by asking the tape.
-	 */
+	/* Correct pc->actually_transferred by asking the tape.	 */
 	if (test_bit(PC_DMA_ERROR, &pc->flags)) {
-		pc->actually_transferred = pc->request_transfer - tape->tape_block_size * ntohl(get_unaligned(&result->information));
+		pc->actually_transferred = pc->request_transfer -
+			tape->tape_block_size *
+			ntohl(get_unaligned((u32 *)&sense[3]));
 		idetape_update_buffers(pc);
 	}
 
 	/*
-	 * If error was the result of a zero-length read or write command,
-	 * with sense key=5, asc=0x22, ascq=0, let it slide.  Some drives
-	 * (i.e. Seagate STT3401A Travan) don't support 0-length read/writes.
+	 * If error was the result of a zero-length read or write command, with
+	 * sense key=5, asc=0x22, ascq=0, let it slide.  Some drives (i.e.
+	 * Seagate STT3401A Travan) don't support 0-length read/writes.
 	 */
 	if ((pc->c[0] == IDETAPE_READ_CMD || pc->c[0] == IDETAPE_WRITE_CMD)
-	    && pc->c[4] == 0 && pc->c[3] == 0 && pc->c[2] == 0) { /* length==0 */
-		if (result->sense_key == 5) {
+		/* length==0 */
+		&& pc->c[4] == 0 && pc->c[3] == 0 && pc->c[2] == 0) {
+		if (tape->sense_key == 5) {
 			/* don't report an error, everything's ok */
 			pc->error = 0;
 			/* don't retry read/write */
 			set_bit(PC_ABORT, &pc->flags);
 		}
 	}
-	if (pc->c[0] == IDETAPE_READ_CMD && result->filemark) {
+	if (pc->c[0] == IDETAPE_READ_CMD && !!(sense[2] & 0x80)) {
 		pc->error = IDETAPE_ERROR_FILEMARK;
 		set_bit(PC_ABORT, &pc->flags);
 	}
 	if (pc->c[0] == IDETAPE_WRITE_CMD) {
-		if (result->eom ||
-		    (result->sense_key == 0xd && result->asc == 0x0 &&
-		     result->ascq == 0x2)) {
+		if (!!(sense[2] & 0x40) ||
+				(tape->sense_key == 0xd &&
+				 tape->asc == 0x0 &&
+				 tape->ascq == 0x2)) {
 			pc->error = IDETAPE_ERROR_EOD;
 			set_bit(PC_ABORT, &pc->flags);
 		}
 	}
 	if (pc->c[0] == IDETAPE_READ_CMD || pc->c[0] == IDETAPE_WRITE_CMD) {
-		if (result->sense_key == 8) {
+		if (tape->sense_key == 8) {
 			pc->error = IDETAPE_ERROR_EOD;
 			set_bit(PC_ABORT, &pc->flags);
 		}
@@ -1327,7 +1298,7 @@ static ide_startstop_t idetape_request_sense_callback (ide_drive_t *drive)
 		printk(KERN_INFO "ide-tape: Reached idetape_request_sense_callback\n");
 #endif /* IDETAPE_DEBUG_LOG */
 	if (!tape->pc->error) {
-		idetape_analyze_error(drive, (idetape_request_sense_result_t *) tape->pc->buffer);
+		idetape_analyze_error(drive, tape->pc->buffer);
 		idetape_end_request(drive, 1, 0);
 	} else {
 		printk(KERN_ERR "ide-tape: Error in REQUEST SENSE itself - Aborting request!\n");
-- 
1.5.3.7

