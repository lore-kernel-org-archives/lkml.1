Return-Path: <linux-kernel-owner+w=401wt.eu-S1755089AbYACNYE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755089AbYACNYE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jan 2008 08:24:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752647AbYACNXH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Jan 2008 08:23:07 -0500
Received: from smtp105.plus.mail.re1.yahoo.com ([69.147.102.68]:40664 "HELO
	smtp105.plus.mail.re1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752032AbYACNXA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jan 2008 08:23:00 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.de;
  h=Received:X-YMail-OSG:Received:From:To:Cc:Subject:Date:Message-Id:X-Mailer:In-Reply-To:References;
  b=S+BUnx9Mi6kZgZZ0W1NXZM728isK6SK2ZDV9BGK8KUwrmQ7N62KomS+X3V0U1qdg2cQzsNqYwTPIsB0veuZupRIGgyE9TENtdvN26O2RzkIuyNdIBF/+nDN73vrYXc20sxDNnB9Zsl7f5+n045HCq4GanGHr77QsbKdvmPPKOnE=  ;
X-YMail-OSG: ycqT8yEVM1lRTWoZaw5HjUkLlFqMeSsE20hu68j4eyamlVo98qCK2ma0AD.QLSffb0.8wf2NLA--
From: Borislav Petkov <bbpetkov@yahoo.de>
To: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: bzolnier@gmail.com, Borislav Petkov <bbpetkov@yahoo.de>,
       Jens Axboe <axboe@kernel.dk>
Subject: [RESEND PATCH 03/10] ide-floppy: convert to generic packet commands
Date: Thu,  3 Jan 2008 14:20:02 +0100
Message-Id: <1199366409-26016-4-git-send-email-bbpetkov@yahoo.de>
X-Mailer: git-send-email debian.1.5.3.7.1-dirty
In-Reply-To: <1199366409-26016-3-git-send-email-bbpetkov@yahoo.de>
References: <1199366409-26016-1-git-send-email-bbpetkov@yahoo.de>
 <1199366409-26016-2-git-send-email-bbpetkov@yahoo.de>
 <1199366409-26016-3-git-send-email-bbpetkov@yahoo.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Replace the ide-floppy packet commands opcode defines with the generic ones.
Add a missing GPCMD_WRITE_12 (opcode 0xaa) to the generic ones in cdrom.h. The
last one can be found in the current version of INF-8090, p.905.

CC: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Borislav Petkov <bbpetkov@yahoo.de>
---
 drivers/ide/ide-floppy.c |   26 +++++++++++++-------------
 drivers/ide/ide-floppy.h |   21 ---------------------
 include/linux/cdrom.h    |    1 +
 3 files changed, 14 insertions(+), 34 deletions(-)

diff --git a/drivers/ide/ide-floppy.c b/drivers/ide/ide-floppy.c
index 52d09c1..4fb6128 100644
--- a/drivers/ide/ide-floppy.c
+++ b/drivers/ide/ide-floppy.c
@@ -313,7 +313,7 @@ static void idefloppy_init_pc (idefloppy_pc_t *pc)
 static void idefloppy_create_request_sense_cmd (idefloppy_pc_t *pc)
 {
 	idefloppy_init_pc(pc);
-	pc->c[0] = IDEFLOPPY_REQUEST_SENSE_CMD;
+	pc->c[0] = GPCMD_REQUEST_SENSE;
 	pc->c[4] = 255;
 	pc->request_transfer = 18;
 	pc->callback = &idefloppy_request_sense_callback;
@@ -379,7 +379,7 @@ static ide_startstop_t idefloppy_pc_intr (ide_drive_t *drive)
 			debug_log(KERN_INFO "ide-floppy: %s: I/O error\n",
 				drive->name);
 			rq->errors++;
-			if (pc->c[0] == IDEFLOPPY_REQUEST_SENSE_CMD) {
+			if (pc->c[0] == GPCMD_REQUEST_SENSE) {
 				printk(KERN_ERR "ide-floppy: I/O error in "
 					"request sense command\n");
 				return ide_do_reset(drive);
@@ -586,8 +586,8 @@ static ide_startstop_t idefloppy_issue_pc (ide_drive_t *drive, idefloppy_pc_t *p
          and have lived on another thread's stack; that stack may have become
          unmapped meanwhile (CONFIG_DEBUG_PAGEALLOC). */
 #if IDEFLOPPY_DEBUG_BUGS
-	if (floppy->pc->c[0] == IDEFLOPPY_REQUEST_SENSE_CMD &&
-	    pc->c[0] == IDEFLOPPY_REQUEST_SENSE_CMD) {
+	if (floppy->pc->c[0] == GPCMD_REQUEST_SENSE &&
+	    pc->c[0] == GPCMD_REQUEST_SENSE) {
 		printk(KERN_ERR "ide-floppy: possible ide-floppy.c bug - "
 			"Two request sense in serial were issued\n");
 	}
@@ -595,7 +595,7 @@ static ide_startstop_t idefloppy_issue_pc (ide_drive_t *drive, idefloppy_pc_t *p
 #endif
 
 	if (floppy->failed_pc == NULL &&
-	    pc->c[0] != IDEFLOPPY_REQUEST_SENSE_CMD)
+	    pc->c[0] != GPCMD_REQUEST_SENSE)
 		floppy->failed_pc = pc;
 	/* Set the current packet command */
 	floppy->pc = pc;
@@ -690,14 +690,14 @@ static void idefloppy_create_prevent_cmd (idefloppy_pc_t *pc, int prevent)
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
@@ -707,7 +707,7 @@ static void idefloppy_create_format_unit_cmd (idefloppy_pc_t *pc, int b, int l,
 					      int flags)
 {
 	idefloppy_init_pc(pc);
-	pc->c[0] = IDEFLOPPY_FORMAT_UNIT_CMD;
+	pc->c[0] = GPCMD_FORMAT_UNIT;
 	pc->c[1] = 0x17;
 
 	memset(pc->buffer, 0, 12);
@@ -733,7 +733,7 @@ static void idefloppy_create_mode_sense_cmd (idefloppy_pc_t *pc, u8 page_code,
 	u16 length = sizeof(idefloppy_mode_par_hdr_t);
 
 	idefloppy_init_pc(pc);
-	pc->c[0] = IDEFLOPPY_MODE_SENSE_CMD;
+	pc->c[0] = GPCMD_MODE_SENSE_10;
 	pc->c[1] = 0;
 	pc->c[2] = page_code + (type << 6);
 
@@ -755,14 +755,14 @@ static void idefloppy_create_mode_sense_cmd (idefloppy_pc_t *pc, u8 page_code,
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
 
 static void idefloppy_create_rw_cmd (idefloppy_t *floppy, idefloppy_pc_t *pc,
@@ -778,10 +778,10 @@ static void idefloppy_create_rw_cmd (idefloppy_t *floppy, idefloppy_pc_t *pc,
 
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
diff --git a/drivers/ide/ide-floppy.h b/drivers/ide/ide-floppy.h
index ecfafa6..4e12038 100644
--- a/drivers/ide/ide-floppy.h
+++ b/drivers/ide/ide-floppy.h
@@ -248,27 +248,6 @@ typedef struct ide_floppy_obj {
 
 #define IDEFLOPPY_ZIP_DRIVE		5	/* Requires BH algorithm for \
 						   packets */
-
-/*
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
 /*
  *	Defines for the mode sense command
  */
diff --git a/include/linux/cdrom.h b/include/linux/cdrom.h
index ba32479..a729b02 100644
--- a/include/linux/cdrom.h
+++ b/include/linux/cdrom.h
@@ -480,6 +480,7 @@ struct cdrom_generic_command
 #define GPCMD_TEST_UNIT_READY		    0x00
 #define GPCMD_VERIFY_10			    0x2f
 #define GPCMD_WRITE_10			    0x2a
+#define GPCMD_WRITE_12			    0xaa	/* ide floppy */
 #define GPCMD_WRITE_AND_VERIFY_10	    0x2e
 /* This is listed as optional in ATAPI 2.6, but is (curiously) 
  * missing from Mt. Fuji, Table 57.  It _is_ mentioned in Mt. Fuji
-- 
1.5.3.7

