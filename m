Return-Path: <linux-kernel-owner+w=401wt.eu-S1759986AbYA0J4J@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759986AbYA0J4J (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jan 2008 04:56:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757084AbYA0Jtm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Jan 2008 04:49:42 -0500
Received: from [212.23.103.76] ([212.23.103.76]:58941 "EHLO gollum.tnic"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756655AbYA0Jt2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jan 2008 04:49:28 -0500
From: Borislav Petkov <petkovbb@gmail.com>
To: <bzolnier@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org,
       Borislav Petkov <bbpetkov@yahoo.de>
Subject: [PATCH 25/32] ide-tape: simplify code branching in the interrupt handler
Date: Sun, 27 Jan 2008 10:48:13 +0100
Message-Id: <1201427300-3954-20-git-send-email-petkovbb@gmail.com>
X-Mailer: git-send-email debian.1.5.3.7.1-dirty
In-Reply-To: <1201427300-3954-1-git-send-email-petkovbb@gmail.com>
References: <1201427300-3954-1-git-send-email-petkovbb@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Borislav Petkov <bbpetkov@yahoo.de>

... by adding a new typedef function pointer idetape_io_buf in order to call
the proper buffer i/o handler depending on the data direction.

Signed-off-by: Borislav Petkov <bbpetkov@yahoo.de>
---
 drivers/ide/ide-tape.c |   54 +++++++++++++++++++++++++----------------------
 1 files changed, 29 insertions(+), 25 deletions(-)

diff --git a/drivers/ide/ide-tape.c b/drivers/ide/ide-tape.c
index eab552e..041edcd 100644
--- a/drivers/ide/ide-tape.c
+++ b/drivers/ide/ide-tape.c
@@ -1090,18 +1090,22 @@ static void idetape_postpone_request (ide_drive_t *drive)
 }
 
 /*
- *	idetape_pc_intr is the usual interrupt handler which will be called
- *	during a packet command. We will transfer some of the data (as
- *	requested by the drive) and will re-point interrupt handler to us.
- *	When data transfer is finished, we will act according to the
- *	algorithm described before idetape_issue_packet_command.
- *
+ * This is the usual interrupt handler which will be called during a packet
+ * command. We will transfer some of the data (as requested by the drive) and
+ * will re-point interrupt handler to us. When data transfer is finished, we
+ * will act according to the algorithm described before
+ * idetape_issue_packet_command.
  */
-static ide_startstop_t idetape_pc_intr (ide_drive_t *drive)
+
+typedef void idetape_io_buf(ide_drive_t *, idetape_pc_t *, uint);
+
+static ide_startstop_t idetape_pc_intr(ide_drive_t *drive)
 {
 	ide_hwif_t *hwif = drive->hwif;
 	idetape_tape_t *tape = drive->driver_data;
 	idetape_pc_t *pc = tape->pc;
+	xfer_func_t *xferfunc;
+	idetape_io_buf *iobuf;
 	unsigned int temp;
 #if SIMULATE_ERRORS
 	static int error_sim_count = 0;
@@ -1171,7 +1175,8 @@ static ide_startstop_t idetape_pc_intr (ide_drive_t *drive)
 			debug_log(DBG_ERR, "%s: I/O error\n", tape->name);
 
 			if (pc->c[0] == REQUEST_SENSE) {
-				printk(KERN_ERR "ide-tape: I/O error in request sense command\n");
+				printk(KERN_ERR "ide-tape: I/O error in request"
+						" sense command\n");
 				return ide_do_reset(drive);
 			}
 			debug_log(DBG_ERR, "[cmd %x]: check condition\n",
@@ -1210,7 +1215,7 @@ static ide_startstop_t idetape_pc_intr (ide_drive_t *drive)
 	ireason = hwif->INB(IDE_IREASON_REG);
 
 	if (ireason & CD) {
-		printk(KERN_ERR "ide-tape: CoD != 0 in idetape_pc_intr\n");
+		printk(KERN_ERR "ide-tape: CoD != 0 in %s\n", __func__);
 		return ide_do_reset(drive);
 	}
 	if (((ireason & IO) == IO) == test_bit(PC_WRITING, &pc->flags)) {
@@ -1226,31 +1231,30 @@ static ide_startstop_t idetape_pc_intr (ide_drive_t *drive)
 		temp = pc->xferred + bcount;
 		if (temp > pc->rq_xfer) {
 			if (temp > pc->buf_size) {
-				printk(KERN_ERR "ide-tape: The tape wants to send us more data than expected - discarding data\n");
+				printk(KERN_ERR "ide-tape: The tape wants to "
+						"send us more data than "
+						"expected - discarding data\n");
 				idetape_discard_data(drive, bcount);
-				ide_set_handler(drive, &idetape_pc_intr, IDETAPE_WAIT_CMD, NULL);
+				ide_set_handler(drive, &idetape_pc_intr,
+						IDETAPE_WAIT_CMD, NULL);
 				return ide_started;
 			}
 			debug_log(DBG_SENSE, "The tape wants to send us more "
 				"data than expected - allowing transfer\n");
 
 		}
-	}
-	if (test_bit(PC_WRITING, &pc->flags)) {
-		if (pc->bh != NULL)
-			idetape_output_buffers(drive, pc, bcount);
-		else
-			/* Write the current buffer */
-			hwif->atapi_output_bytes(drive, pc->cur_pos,
-						 bcount);
+		iobuf = &idetape_input_buffers;
+		xferfunc = hwif->atapi_input_bytes;
 	} else {
-		if (pc->bh != NULL)
-			idetape_input_buffers(drive, pc, bcount);
-		else
-			/* Read the current buffer */
-			hwif->atapi_input_bytes(drive, pc->cur_pos,
-						bcount);
+		iobuf = &idetape_output_buffers;
+		xferfunc = hwif->atapi_output_bytes;
 	}
+
+	if (pc->bh)
+		iobuf(drive, pc, bcount);
+	else
+		xferfunc(drive, pc->cur_pos, bcount);
+
 	/* Update the current position */
 	pc->xferred += bcount;
 	pc->cur_pos += bcount;
-- 
1.5.3.7

