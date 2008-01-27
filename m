Return-Path: <linux-kernel-owner+w=401wt.eu-S1759757AbYA0Jyo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759757AbYA0Jyo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jan 2008 04:54:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756963AbYA0Jte
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Jan 2008 04:49:34 -0500
Received: from [212.23.103.76] ([212.23.103.76]:58944 "EHLO gollum.tnic"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755983AbYA0JtV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jan 2008 04:49:21 -0500
From: Borislav Petkov <petkovbb@gmail.com>
To: <bzolnier@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org,
       Borislav Petkov <bbpetkov@yahoo.de>
Subject: [PATCH 16/32] ide-tape: use generic scsi commands
Date: Sun, 27 Jan 2008 10:48:04 +0100
Message-Id: <1201427300-3954-11-git-send-email-petkovbb@gmail.com>
X-Mailer: git-send-email debian.1.5.3.7.1-dirty
In-Reply-To: <1201427300-3954-1-git-send-email-petkovbb@gmail.com>
References: <1201427300-3954-1-git-send-email-petkovbb@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Borislav Petkov <bbpetkov@yahoo.de>

Also, remove those which weren't used.

Signed-off-by: Borislav Petkov <bbpetkov@yahoo.de>
---
 drivers/ide/ide-tape.c |   80 ++++++++++++++++++------------------------------
 1 files changed, 30 insertions(+), 50 deletions(-)

diff --git a/drivers/ide/ide-tape.c b/drivers/ide/ide-tape.c
index 0708049..1435f4e 100644
--- a/drivers/ide/ide-tape.c
+++ b/drivers/ide/ide-tape.c
@@ -36,6 +36,7 @@
 #include <linux/completion.h>
 #include <linux/bitops.h>
 #include <linux/mutex.h>
+#include <scsi/scsi.h>
 
 #include <asm/byteorder.h>
 #include <asm/irq.h>
@@ -521,27 +522,6 @@ static void ide_tape_put(struct ide_tape_obj *tape)
 #define IDETAPE_MEDIUM_PRESENT		9
 
 /*
- *	Supported ATAPI tape drives packet commands
- */
-#define IDETAPE_TEST_UNIT_READY_CMD	0x00
-#define IDETAPE_REWIND_CMD		0x01
-#define IDETAPE_REQUEST_SENSE_CMD	0x03
-#define IDETAPE_READ_CMD		0x08
-#define IDETAPE_WRITE_CMD		0x0a
-#define IDETAPE_WRITE_FILEMARK_CMD	0x10
-#define IDETAPE_SPACE_CMD		0x11
-#define IDETAPE_INQUIRY_CMD		0x12
-#define IDETAPE_ERASE_CMD		0x19
-#define IDETAPE_MODE_SENSE_CMD		0x1a
-#define IDETAPE_MODE_SELECT_CMD		0x15
-#define IDETAPE_LOAD_UNLOAD_CMD		0x1b
-#define IDETAPE_PREVENT_CMD		0x1e
-#define IDETAPE_LOCATE_CMD		0x2b
-#define IDETAPE_READ_POSITION_CMD	0x34
-#define IDETAPE_READ_BUFFER_CMD		0x3c
-#define IDETAPE_SET_SPEED_CMD		0xbb
-
-/*
  *	Some defines for the READ BUFFER command
  */
 #define IDETAPE_RETRIEVE_FAULTY_BLOCK	6
@@ -813,7 +793,7 @@ static void idetape_analyze_error(ide_drive_t *drive, u8 *sense)
 	 * sense key=5, asc=0x22, ascq=0, let it slide.  Some drives (i.e.
 	 * Seagate STT3401A Travan) don't support 0-length read/writes.
 	 */
-	if ((pc->c[0] == IDETAPE_READ_CMD || pc->c[0] == IDETAPE_WRITE_CMD)
+	if ((pc->c[0] == READ_6 || pc->c[0] == WRITE_6)
 		/* length==0 */
 		&& pc->c[4] == 0 && pc->c[3] == 0 && pc->c[2] == 0) {
 		if (tape->sense_key == 5) {
@@ -823,11 +803,11 @@ static void idetape_analyze_error(ide_drive_t *drive, u8 *sense)
 			set_bit(PC_ABORT, &pc->flags);
 		}
 	}
-	if (pc->c[0] == IDETAPE_READ_CMD && !!(sense[2] & 0x80)) {
+	if (pc->c[0] == READ_6 && !!(sense[2] & 0x80)) {
 		pc->error = IDETAPE_ERROR_FILEMARK;
 		set_bit(PC_ABORT, &pc->flags);
 	}
-	if (pc->c[0] == IDETAPE_WRITE_CMD) {
+	if (pc->c[0] == WRITE_6) {
 		if (!!(sense[2] & 0x40) ||
 				(tape->sense_key == 0xd &&
 				 tape->asc == 0x0 &&
@@ -836,7 +816,7 @@ static void idetape_analyze_error(ide_drive_t *drive, u8 *sense)
 			set_bit(PC_ABORT, &pc->flags);
 		}
 	}
-	if (pc->c[0] == IDETAPE_READ_CMD || pc->c[0] == IDETAPE_WRITE_CMD) {
+	if (pc->c[0] == READ_6 || pc->c[0] == WRITE_6) {
 		if (tape->sense_key == 8) {
 			pc->error = IDETAPE_ERROR_EOD;
 			set_bit(PC_ABORT, &pc->flags);
@@ -1073,7 +1053,7 @@ static ide_startstop_t idetape_request_sense_callback (ide_drive_t *drive)
 static void idetape_create_request_sense_cmd (idetape_pc_t *pc)
 {
 	idetape_init_pc(pc);	
-	pc->c[0] = IDETAPE_REQUEST_SENSE_CMD;
+	pc->c[0] = REQUEST_SENSE;
 	pc->c[4] = 20;
 	pc->request_transfer = 20;
 	pc->callback = &idetape_request_sense_callback;
@@ -1216,22 +1196,22 @@ static ide_startstop_t idetape_pc_intr (ide_drive_t *drive)
 		local_irq_enable();
 
 #if SIMULATE_ERRORS
-		if ((pc->c[0] == IDETAPE_WRITE_CMD ||
-		     pc->c[0] == IDETAPE_READ_CMD) &&
+		if ((pc->c[0] == WRITE_6 ||
+		     pc->c[0] == READ_6) &&
 		    (++error_sim_count % 100) == 0) {
 			printk(KERN_INFO "ide-tape: %s: simulating error\n",
 				tape->name);
 			stat |= ERR_STAT;
 		}
 #endif
-		if ((stat & ERR_STAT) && pc->c[0] == IDETAPE_REQUEST_SENSE_CMD)
+		if ((stat & ERR_STAT) && pc->c[0] == REQUEST_SENSE)
 			stat &= ~ERR_STAT;
 		if ((stat & ERR_STAT) || test_bit(PC_DMA_ERROR, &pc->flags)) {
 
 			/* Error detected */
 			debug_log(DBG_ERR, "%s: I/O error\n", tape->name);
 
-			if (pc->c[0] == IDETAPE_REQUEST_SENSE_CMD) {
+			if (pc->c[0] == REQUEST_SENSE) {
 				printk(KERN_ERR "ide-tape: I/O error in request sense command\n");
 				return ide_do_reset(drive);
 			}
@@ -1416,13 +1396,13 @@ static ide_startstop_t idetape_issue_packet_command (ide_drive_t *drive, idetape
 	int dma_ok = 0;
 	u16 bcount;
 
-	if (tape->pc->c[0] == IDETAPE_REQUEST_SENSE_CMD &&
-	    pc->c[0] == IDETAPE_REQUEST_SENSE_CMD) {
+	if (tape->pc->c[0] == REQUEST_SENSE &&
+	    pc->c[0] == REQUEST_SENSE) {
 		printk(KERN_ERR "ide-tape: possible ide-tape.c bug - "
 			"Two request sense in serial were issued\n");
 	}
 
-	if (tape->failed_pc == NULL && pc->c[0] != IDETAPE_REQUEST_SENSE_CMD)
+	if (tape->failed_pc == NULL && pc->c[0] != REQUEST_SENSE)
 		tape->failed_pc = pc;
 	/* Set the current packet command */
 	tape->pc = pc;
@@ -1435,7 +1415,7 @@ static ide_startstop_t idetape_issue_packet_command (ide_drive_t *drive, idetape
 		 *	filemark, or end of the media, for example).
 		 */
 		if (!test_bit(PC_ABORT, &pc->flags)) {
-			if (!(pc->c[0] == IDETAPE_TEST_UNIT_READY_CMD &&
+			if (!(pc->c[0] == TEST_UNIT_READY &&
 			      tape->sense_key == 2 && tape->asc == 4 &&
 			     (tape->ascq == 1 || tape->ascq == 8))) {
 				printk(KERN_ERR "ide-tape: %s: I/O error, "
@@ -1502,7 +1482,7 @@ static ide_startstop_t idetape_pc_callback (ide_drive_t *drive)
 static void idetape_create_mode_sense_cmd (idetape_pc_t *pc, u8 page_code)
 {
 	idetape_init_pc(pc);
-	pc->c[0] = IDETAPE_MODE_SENSE_CMD;
+	pc->c[0] = MODE_SENSE;
 	if (page_code != IDETAPE_BLOCK_DESCRIPTOR)
 		pc->c[1] = 8;	/* DBD = 1 - Don't return block descriptors */
 	pc->c[2] = page_code;
@@ -1583,7 +1563,7 @@ static ide_startstop_t idetape_media_access_finished (ide_drive_t *drive)
 	if (stat & SEEK_STAT) {
 		if (stat & ERR_STAT) {
 			/* Error detected */
-			if (pc->c[0] != IDETAPE_TEST_UNIT_READY_CMD)
+			if (pc->c[0] != TEST_UNIT_READY)
 				printk(KERN_ERR "ide-tape: %s: I/O error, ",
 						tape->name);
 			/* Retry operation */
@@ -1636,7 +1616,7 @@ static ide_startstop_t idetape_rw_callback (ide_drive_t *drive)
 static void idetape_create_read_cmd(idetape_tape_t *tape, idetape_pc_t *pc, unsigned int length, struct idetape_bh *bh)
 {
 	idetape_init_pc(pc);
-	pc->c[0] = IDETAPE_READ_CMD;
+	pc->c[0] = READ_6;
 	put_unaligned(htonl(length), (unsigned int *) &pc->c[1]);
 	pc->c[1] = 1;
 	pc->callback = &idetape_rw_callback;
@@ -1654,7 +1634,7 @@ static void idetape_create_read_buffer_cmd(idetape_tape_t *tape, idetape_pc_t *p
 	struct idetape_bh *p = bh;
 
 	idetape_init_pc(pc);
-	pc->c[0] = IDETAPE_READ_BUFFER_CMD;
+	pc->c[0] = READ_BUFFER;
 	pc->c[1] = IDETAPE_RETRIEVE_FAULTY_BLOCK;
 	pc->c[7] = size >> 8;
 	pc->c[8] = size & 0xff;
@@ -1672,7 +1652,7 @@ static void idetape_create_read_buffer_cmd(idetape_tape_t *tape, idetape_pc_t *p
 static void idetape_create_write_cmd(idetape_tape_t *tape, idetape_pc_t *pc, unsigned int length, struct idetape_bh *bh)
 {
 	idetape_init_pc(pc);
-	pc->c[0] = IDETAPE_WRITE_CMD;
+	pc->c[0] = WRITE_6;
 	put_unaligned(htonl(length), (unsigned int *) &pc->c[1]);
 	pc->c[1] = 1;
 	pc->callback = &idetape_rw_callback;
@@ -1715,7 +1695,7 @@ static ide_startstop_t idetape_do_request(ide_drive_t *drive,
 	 *	Retry a failed packet command
 	 */
 	if (tape->failed_pc != NULL &&
-	    tape->pc->c[0] == IDETAPE_REQUEST_SENSE_CMD) {
+	    tape->pc->c[0] == REQUEST_SENSE) {
 		return idetape_issue_packet_command(drive, tape->failed_pc);
 	}
 	if (postponed_rq != NULL)
@@ -2079,7 +2059,7 @@ static ide_startstop_t idetape_read_position_callback(ide_drive_t *drive)
 static void idetape_create_write_filemark_cmd (ide_drive_t *drive, idetape_pc_t *pc,int write_filemark)
 {
 	idetape_init_pc(pc);
-	pc->c[0] = IDETAPE_WRITE_FILEMARK_CMD;
+	pc->c[0] = WRITE_FILEMARKS;
 	pc->c[4] = write_filemark;
 	set_bit(PC_WAIT_FOR_DSC, &pc->flags);
 	pc->callback = &idetape_pc_callback;
@@ -2088,7 +2068,7 @@ static void idetape_create_write_filemark_cmd (ide_drive_t *drive, idetape_pc_t
 static void idetape_create_test_unit_ready_cmd(idetape_pc_t *pc)
 {
 	idetape_init_pc(pc);
-	pc->c[0] = IDETAPE_TEST_UNIT_READY_CMD;
+	pc->c[0] = TEST_UNIT_READY;
 	pc->callback = &idetape_pc_callback;
 }
 
@@ -2126,7 +2106,7 @@ static int __idetape_queue_pc_tail (ide_drive_t *drive, idetape_pc_t *pc)
 static void idetape_create_load_unload_cmd (ide_drive_t *drive, idetape_pc_t *pc,int cmd)
 {
 	idetape_init_pc(pc);
-	pc->c[0] = IDETAPE_LOAD_UNLOAD_CMD;
+	pc->c[0] = START_STOP;
 	pc->c[4] = cmd;
 	set_bit(PC_WAIT_FOR_DSC, &pc->flags);
 	pc->callback = &idetape_pc_callback;
@@ -2183,7 +2163,7 @@ static int idetape_flush_tape_buffers (ide_drive_t *drive)
 static void idetape_create_read_position_cmd (idetape_pc_t *pc)
 {
 	idetape_init_pc(pc);
-	pc->c[0] = IDETAPE_READ_POSITION_CMD;
+	pc->c[0] = READ_POSITION;
 	pc->request_transfer = 20;
 	pc->callback = &idetape_read_position_callback;
 }
@@ -2206,7 +2186,7 @@ static int idetape_read_position (ide_drive_t *drive)
 static void idetape_create_locate_cmd (ide_drive_t *drive, idetape_pc_t *pc, unsigned int block, u8 partition, int skip)
 {
 	idetape_init_pc(pc);
-	pc->c[0] = IDETAPE_LOCATE_CMD;
+	pc->c[0] = POSITION_TO_ELEMENT;
 	pc->c[1] = 2;
 	put_unaligned(htonl(block), (unsigned int *) &pc->c[3]);
 	pc->c[8] = partition;
@@ -2223,7 +2203,7 @@ static int idetape_create_prevent_cmd (ide_drive_t *drive, idetape_pc_t *pc, int
 		return 0;
 
 	idetape_init_pc(pc);
-	pc->c[0] = IDETAPE_PREVENT_CMD;
+	pc->c[0] = ALLOW_MEDIUM_REMOVAL;
 	pc->c[4] = prevent;
 	pc->callback = &idetape_pc_callback;
 	return 1;
@@ -2373,7 +2353,7 @@ static void idetape_insert_pipeline_into_queue (ide_drive_t *drive)
 static void idetape_create_inquiry_cmd (idetape_pc_t *pc)
 {
 	idetape_init_pc(pc);
-	pc->c[0] = IDETAPE_INQUIRY_CMD;
+	pc->c[0] = INQUIRY;
 	pc->c[4] = pc->request_transfer = 254;
 	pc->callback = &idetape_pc_callback;
 }
@@ -2381,7 +2361,7 @@ static void idetape_create_inquiry_cmd (idetape_pc_t *pc)
 static void idetape_create_rewind_cmd (ide_drive_t *drive, idetape_pc_t *pc)
 {
 	idetape_init_pc(pc);
-	pc->c[0] = IDETAPE_REWIND_CMD;
+	pc->c[0] = REZERO_UNIT;
 	set_bit(PC_WAIT_FOR_DSC, &pc->flags);
 	pc->callback = &idetape_pc_callback;
 }
@@ -2389,7 +2369,7 @@ static void idetape_create_rewind_cmd (ide_drive_t *drive, idetape_pc_t *pc)
 static void idetape_create_erase_cmd (idetape_pc_t *pc)
 {
 	idetape_init_pc(pc);
-	pc->c[0] = IDETAPE_ERASE_CMD;
+	pc->c[0] = ERASE;
 	pc->c[1] = 1;
 	set_bit(PC_WAIT_FOR_DSC, &pc->flags);
 	pc->callback = &idetape_pc_callback;
@@ -2398,7 +2378,7 @@ static void idetape_create_erase_cmd (idetape_pc_t *pc)
 static void idetape_create_space_cmd (idetape_pc_t *pc,int count, u8 cmd)
 {
 	idetape_init_pc(pc);
-	pc->c[0] = IDETAPE_SPACE_CMD;
+	pc->c[0] = SPACE;
 	put_unaligned(htonl(count), (unsigned int *) &pc->c[1]);
 	pc->c[1] = cmd;
 	set_bit(PC_WAIT_FOR_DSC, &pc->flags);
-- 
1.5.3.7

