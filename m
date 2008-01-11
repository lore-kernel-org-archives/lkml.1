Return-Path: <linux-kernel-owner+w=401wt.eu-S1761673AbYAKMGy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761673AbYAKMGy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jan 2008 07:06:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760706AbYAKMDy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Jan 2008 07:03:54 -0500
Received: from smtp116.plus.mail.re1.yahoo.com ([69.147.102.79]:39093 "HELO
	smtp116.plus.mail.re1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1759138AbYAKMDk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jan 2008 07:03:40 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.de;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:Received:From:To:Cc:Subject:Date:Message-Id:X-Mailer:In-Reply-To:References;
  b=BJlCO/wVW2lUQS9M/YcYBs5V9VhJpNVY18OTbAOiUk0xq/vtgysqQ/V59++YmUE70zddcWl6RAgcwxXGRAkIMg0GEK/jtCFiZS4FlAlgckhdqGHMbMFTz7ek79WfeR1LgMSXGvQ+SLZUIwIfHAbVJUXST6dK+S8s6yrE2KRf+64=  ;
X-YMail-OSG: QFbBfj0VM1mTtBchmP15Q63SThLbO6SVsyke4YANQHPBW9xqZhjtnKYQGdEP9dwTnDLX3segEQ--
X-Yahoo-Newman-Property: ymail-3
From: Borislav Petkov <bbpetkov@yahoo.de>
To: Bartlomiej@gollum.tnic, Zolnierkiewicz@gollum.tnic, <bzolnier@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org,
       Borislav Petkov <bbpetkov@yahoo.de>, Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 01/21] ide-floppy: convert to generic packet commands
Date: Fri, 11 Jan 2008 12:57:59 +0100
Message-Id: <1200052699-28420-2-git-send-email-bbpetkov@yahoo.de>
X-Mailer: git-send-email debian.1.5.3.7.1-dirty
In-Reply-To: <1200052699-28420-1-git-send-email-bbpetkov@yahoo.de>
References: <1200052699-28420-1-git-send-email-bbpetkov@yahoo.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Replace the ide-floppy packet commands opcode defines with the generic ones.
Add a missing GPCMD_WRITE_12 (opcode 0xaa) to the generic ones in cdrom.h. The
last one can be found in the current version of INF-8090, p.905.

CC: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Borislav Petkov <bbpetkov@yahoo.de>
---
 drivers/ide/ide-floppy.c |   44 ++++++++++++--------------------------------
 include/linux/cdrom.h    |    1 +
 2 files changed, 13 insertions(+), 32 deletions(-)

diff --git a/drivers/ide/ide-floppy.c b/drivers/ide/ide-floppy.c
index 3512637..e4ebb21 100644
--- a/drivers/ide/ide-floppy.c
+++ b/drivers/ide/ide-floppy.c
@@ -273,26 +273,6 @@ typedef struct ide_floppy_obj {
 #define IDEFLOPPY_ZIP_DRIVE		5	/* Requires BH algorithm for packets */
 
 /*
- *	ATAPI floppy drive packet commands
- */
-#define IDEFLOPPY_FORMAT_UNIT_CMD	0x04
-#define IDEFLOPPY_INQUIRY_CMD		0x12
-#define IDEFLOPPY_MODE_SELECT_CMD	0x55
-#define IDEFLOPPY_MODE_SENSE_CMD	0x5a
-#define IDEFLOPPY_READ10_CMD		0x28
-#define IDEFLOPPY_READ12_CMD		0xa8
-#define IDEFLOPPY_READ_CAPACITY_CMD	0x23
-#define IDEFLOPPY_REQUEST_SENSE_CMD	0x03
-#define IDEFLOPPY_PREVENT_REMOVAL_CMD	0x1e
-#define IDEFLOPPY_SEEK_CMD		0x2b
-#define IDEFLOPPY_START_STOP_CMD	0x1b
-#define IDEFLOPPY_TEST_UNIT_READY_CMD	0x00
-#define IDEFLOPPY_VERIFY_CMD		0x2f
-#define IDEFLOPPY_WRITE10_CMD		0x2a
-#define IDEFLOPPY_WRITE12_CMD		0xaa
-#define IDEFLOPPY_WRITE_VERIFY_CMD	0x2e
-
-/*
  *	Defines for the mode sense command
  */
 #define MODE_SENSE_CURRENT		0x00
@@ -696,8 +676,8 @@ static void idefloppy_init_pc (idefloppy_pc_t *pc)
 
 static void idefloppy_create_request_sense_cmd (idefloppy_pc_t *pc)
 {
-	idefloppy_init_pc(pc);	
-	pc->c[0] = IDEFLOPPY_REQUEST_SENSE_CMD;
+	idefloppy_init_pc(pc);
+	pc->c[0] = GPCMD_REQUEST_SENSE;
 	pc->c[4] = 255;
 	pc->request_transfer = 18;
 	pc->callback = &idefloppy_request_sense_callback;
@@ -762,7 +742,7 @@ static ide_startstop_t idefloppy_pc_intr (ide_drive_t *drive)
 			debug_log(KERN_INFO "ide-floppy: %s: I/O error\n",
 				drive->name);
 			rq->errors++;
-			if (pc->c[0] == IDEFLOPPY_REQUEST_SENSE_CMD) {
+			if (pc->c[0] == GPCMD_REQUEST_SENSE) {
 				printk(KERN_ERR "ide-floppy: I/O error in "
 					"request sense command\n");
 				return ide_do_reset(drive);
@@ -962,7 +942,7 @@ static ide_startstop_t idefloppy_issue_pc (ide_drive_t *drive, idefloppy_pc_t *p
 	u8 dma;
 
 	if (floppy->failed_pc == NULL &&
-	    pc->c[0] != IDEFLOPPY_REQUEST_SENSE_CMD)
+	    pc->c[0] != GPCMD_REQUEST_SENSE)
 		floppy->failed_pc = pc;
 	/* Set the current packet command */
 	floppy->pc = pc;
@@ -1052,14 +1032,14 @@ static void idefloppy_create_prevent_cmd (idefloppy_pc_t *pc, int prevent)
 		"prevent = %d\n", prevent);
 
 	idefloppy_init_pc(pc);
-	pc->c[0] = IDEFLOPPY_PREVENT_REMOVAL_CMD;
+	pc->c[0] = GPCMD_PREVENT_ALLOW_MEDIUM_REMOVAL;
 	pc->c[4] = prevent;
 }
 
 static void idefloppy_create_read_capacity_cmd (idefloppy_pc_t *pc)
 {
 	idefloppy_init_pc(pc);
-	pc->c[0] = IDEFLOPPY_READ_CAPACITY_CMD;
+	pc->c[0] = GPCMD_READ_FORMAT_CAPACITIES;
 	pc->c[7] = 255;
 	pc->c[8] = 255;
 	pc->request_transfer = 255;
@@ -1069,7 +1049,7 @@ static void idefloppy_create_format_unit_cmd (idefloppy_pc_t *pc, int b, int l,
 					      int flags)
 {
 	idefloppy_init_pc(pc);
-	pc->c[0] = IDEFLOPPY_FORMAT_UNIT_CMD;
+	pc->c[0] = GPCMD_FORMAT_UNIT;
 	pc->c[1] = 0x17;
 
 	memset(pc->buffer, 0, 12);
@@ -1094,7 +1074,7 @@ static void idefloppy_create_mode_sense_cmd (idefloppy_pc_t *pc, u8 page_code, u
 	u16 length = sizeof(idefloppy_mode_parameter_header_t);
 	
 	idefloppy_init_pc(pc);
-	pc->c[0] = IDEFLOPPY_MODE_SENSE_CMD;
+	pc->c[0] = GPCMD_MODE_SENSE_10;
 	pc->c[1] = 0;
 	pc->c[2] = page_code + (type << 6);
 
@@ -1116,14 +1096,14 @@ static void idefloppy_create_mode_sense_cmd (idefloppy_pc_t *pc, u8 page_code, u
 static void idefloppy_create_start_stop_cmd (idefloppy_pc_t *pc, int start)
 {
 	idefloppy_init_pc(pc);
-	pc->c[0] = IDEFLOPPY_START_STOP_CMD;
+	pc->c[0] = GPCMD_START_STOP_UNIT;
 	pc->c[4] = start;
 }
 
 static void idefloppy_create_test_unit_ready_cmd(idefloppy_pc_t *pc)
 {
 	idefloppy_init_pc(pc);
-	pc->c[0] = IDEFLOPPY_TEST_UNIT_READY_CMD;
+	pc->c[0] = GPCMD_TEST_UNIT_READY;
 }
 
 static void idefloppy_create_rw_cmd (idefloppy_floppy_t *floppy, idefloppy_pc_t *pc, struct request *rq, unsigned long sector)
@@ -1138,10 +1118,10 @@ static void idefloppy_create_rw_cmd (idefloppy_floppy_t *floppy, idefloppy_pc_t
 
 	idefloppy_init_pc(pc);
 	if (test_bit(IDEFLOPPY_USE_READ12, &floppy->flags)) {
-		pc->c[0] = cmd == READ ? IDEFLOPPY_READ12_CMD : IDEFLOPPY_WRITE12_CMD;
+		pc->c[0] = cmd == READ ? GPCMD_READ_12 : GPCMD_WRITE_12;
 		put_unaligned(htonl(blocks), (unsigned int *) &pc->c[6]);
 	} else {
-		pc->c[0] = cmd == READ ? IDEFLOPPY_READ10_CMD : IDEFLOPPY_WRITE10_CMD;
+		pc->c[0] = cmd == READ ? GPCMD_READ_10 : GPCMD_WRITE_10;
 		put_unaligned(htons(blocks), (unsigned short *) &pc->c[7]);
 	}
 	put_unaligned(htonl(block), (unsigned int *) &pc->c[2]);
diff --git a/include/linux/cdrom.h b/include/linux/cdrom.h
index ba32479..dd8e72b 100644
--- a/include/linux/cdrom.h
+++ b/include/linux/cdrom.h
@@ -480,6 +480,7 @@ struct cdrom_generic_command
 #define GPCMD_TEST_UNIT_READY		    0x00
 #define GPCMD_VERIFY_10			    0x2f
 #define GPCMD_WRITE_10			    0x2a
+#define GPCMD_WRITE_12			    0xaa
 #define GPCMD_WRITE_AND_VERIFY_10	    0x2e
 /* This is listed as optional in ATAPI 2.6, but is (curiously) 
  * missing from Mt. Fuji, Table 57.  It _is_ mentioned in Mt. Fuji
-- 
1.5.3.7

