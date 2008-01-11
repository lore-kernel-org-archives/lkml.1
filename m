Return-Path: <linux-kernel-owner+w=401wt.eu-S1761928AbYAKMH7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761928AbYAKMH7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jan 2008 07:07:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758474AbYAKMED
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Jan 2008 07:04:03 -0500
Received: from smtp112.plus.mail.re1.yahoo.com ([69.147.102.75]:27214 "HELO
	smtp112.plus.mail.re1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1759807AbYAKMDr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jan 2008 07:03:47 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.de;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:Received:From:To:Cc:Subject:Date:Message-Id:X-Mailer:In-Reply-To:References;
  b=TqIsoPy68eL89YkCH3fZTVbn6TOkEIEG1l2c0tks8YsyG/tyoYbyi5ATYx4l99+xU4HehTyqLGwNu6x2t5MMzsMvuq1EqJ9g2Z+H6ZsCERjS7bdWdOIUgD9F6hkhGK6cR3Za1ggg9/KfAFKXePEEqf8tAl6uGXj72AzXpbcepn4=  ;
X-YMail-OSG: BK_ZI38VM1kQRHEx3phv.jguw_MZlMXE_WaY1VMv9yFFEImHU8K9o7NkN79z2FYM_K4xGnZMEA--
X-Yahoo-Newman-Property: ymail-3
From: Borislav Petkov <bbpetkov@yahoo.de>
To: Bartlomiej@gollum.tnic, Zolnierkiewicz@gollum.tnic, <bzolnier@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org,
       Borislav Petkov <bbpetkov@yahoo.de>
Subject: [PATCH 09/21] ide-floppy: remove struct idefloppy_request_sense_result
Date: Fri, 11 Jan 2008 12:58:07 +0100
Message-Id: <1200052699-28420-10-git-send-email-bbpetkov@yahoo.de>
X-Mailer: git-send-email debian.1.5.3.7.1-dirty
In-Reply-To: <1200052699-28420-9-git-send-email-bbpetkov@yahoo.de>
References: <1200052699-28420-1-git-send-email-bbpetkov@yahoo.de>
 <1200052699-28420-2-git-send-email-bbpetkov@yahoo.de>
 <1200052699-28420-3-git-send-email-bbpetkov@yahoo.de>
 <1200052699-28420-4-git-send-email-bbpetkov@yahoo.de>
 <1200052699-28420-5-git-send-email-bbpetkov@yahoo.de>
 <1200052699-28420-6-git-send-email-bbpetkov@yahoo.de>
 <1200052699-28420-7-git-send-email-bbpetkov@yahoo.de>
 <1200052699-28420-8-git-send-email-bbpetkov@yahoo.de>
 <1200052699-28420-9-git-send-email-bbpetkov@yahoo.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

While at it, collapse idefloppy_analyze_error() into
idefloppy_request_sense_callback() since the latter was its only user.

Signed-off-by: Borislav Petkov <bbpetkov@yahoo.de>
---
 drivers/ide/ide-floppy.c |   82 +++++++++++++--------------------------------
 1 files changed, 24 insertions(+), 58 deletions(-)

diff --git a/drivers/ide/ide-floppy.c b/drivers/ide/ide-floppy.c
index d98264e..7d4ac0b 100644
--- a/drivers/ide/ide-floppy.c
+++ b/drivers/ide/ide-floppy.c
@@ -232,39 +232,6 @@ struct idefloppy_id_gcw {
 };
 
 /*
- *	REQUEST SENSE packet command result - Data Format.
- */
-typedef struct {
-#if defined(__LITTLE_ENDIAN_BITFIELD)
-	unsigned	error_code	:7;	/* Current error (0x70) */
-	unsigned	valid		:1;	/* The information field conforms to SFF-8070i */
-	u8		reserved1	:8;	/* Reserved */
-	unsigned	sense_key	:4;	/* Sense Key */
-	unsigned	reserved2_4	:1;	/* Reserved */
-	unsigned	ili		:1;	/* Incorrect Length Indicator */
-	unsigned	reserved2_67	:2;
-#elif defined(__BIG_ENDIAN_BITFIELD)
-	unsigned	valid		:1;	/* The information field conforms to SFF-8070i */
-	unsigned	error_code	:7;	/* Current error (0x70) */
-	u8		reserved1	:8;	/* Reserved */
-	unsigned	reserved2_67	:2;
-	unsigned	ili		:1;	/* Incorrect Length Indicator */
-	unsigned	reserved2_4	:1;	/* Reserved */
-	unsigned	sense_key	:4;	/* Sense Key */
-#else
-#error "Bitfield endianness not defined! Check your byteorder.h"
-#endif
-	u32		information __attribute__ ((packed));
-	u8		asl;			/* Additional sense length (n-7) */
-	u32		command_specific;	/* Additional command specific information */
-	u8		asc;			/* Additional Sense Code */
-	u8		ascq;			/* Additional Sense Code Qualifier */
-	u8		replaceable_unit_code;	/* Field Replaceable Unit Code */
-	u8		sksv[3];
-	u8		pad[2];			/* Padding to 20 bytes */
-} idefloppy_request_sense_result_t;
-
-/*
  * Pages of the SELECT SENSE / MODE SENSE packet commands.
  * See SFF-8070i spec.
  */
@@ -480,39 +447,38 @@ static struct request *idefloppy_next_rq_storage (ide_drive_t *drive)
 	return (&floppy->rq_stack[floppy->rq_stack_index++]);
 }
 
-/*
- *	idefloppy_analyze_error is called on each failed packet command retry
- *	to analyze the request sense.
- */
-static void idefloppy_analyze_error (ide_drive_t *drive,idefloppy_request_sense_result_t *result)
-{
-	idefloppy_floppy_t *floppy = drive->driver_data;
-
-	floppy->sense_key = result->sense_key;
-	floppy->asc = result->asc;
-	floppy->ascq = result->ascq;
-	floppy->progress_indication = result->sksv[0] & 0x80 ?
-		(u16)get_unaligned((u16 *)(result->sksv+1)):0x10000;
-	if (floppy->failed_pc)
-		debug_log("pc = %x, sense key = %x, asc = %x, ascq = %x\n",
-				floppy->failed_pc->c[0], result->sense_key,
-				result->asc, result->ascq);
-	else
-		debug_log("sense key = %x, asc = %x, ascq = %x\n",
-				result->sense_key, result->asc, result->ascq);
-}
-
-static void idefloppy_request_sense_callback (ide_drive_t *drive)
+static void idefloppy_request_sense_callback(ide_drive_t *drive)
 {
 	idefloppy_floppy_t *floppy = drive->driver_data;
+	u8 *buf = floppy->pc->buffer;
 
 	debug_log("Reached %s\n", __FUNCTION__);
 
 	if (!floppy->pc->error) {
-		idefloppy_analyze_error(drive,(idefloppy_request_sense_result_t *) floppy->pc->buffer);
+		floppy->sense_key = buf[2] & 0x0F;
+		floppy->asc = buf[12];
+		floppy->ascq = buf[13];
+		floppy->progress_indication = buf[15] & 0x80 ?
+			(u16)get_unaligned((u16 *)&buf[16]) : 0x10000;
+
+		if (floppy->failed_pc)
+			debug_log("pc = %x, sense key = %x, asc = %x,"
+					" ascq = %x\n",
+					floppy->failed_pc->c[0],
+					floppy->sense_key,
+					floppy->asc,
+					floppy->ascq);
+		else
+			debug_log("sense key = %x, asc = %x, ascq = %x\n",
+					floppy->sense_key,
+					floppy->asc,
+					floppy->ascq);
+
+
 		idefloppy_do_end_request(drive, 1, 0);
 	} else {
-		printk(KERN_ERR "Error in REQUEST SENSE itself - Aborting request!\n");
+		printk(KERN_ERR "Error in REQUEST SENSE itself - Aborting"
+				" request!\n");
 		idefloppy_do_end_request(drive, 0, 0);
 	}
 }
-- 
1.5.3.7

