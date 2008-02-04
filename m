Return-Path: <linux-kernel-owner+w=401wt.eu-S1757514AbYBDNqd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757514AbYBDNqd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2008 08:46:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756136AbYBDNms
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Feb 2008 08:42:48 -0500
Received: from rn-out-0910.google.com ([64.233.170.191]:3718 "EHLO
	rn-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756080AbYBDNmp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2008 08:42:45 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=to:cc:subject:date:message-id:x-mailer:in-reply-to:references:from;
        b=CfVHbh4wiXSfzEBS/d5Fk8hlkNNc8P2hrSJ40dZhgsL9dNi7k0WFTFhn8/MAeLHIuujVwlSfze551ffGAMppp9F0Q2YSnoSYTp2JVDOo3rSM8ISLf1cFJ4VFooB8n7vNCvZtOEPdcKQnAtcsAENdkm6UPysuj4hTEyYDg/cuB+Q=
To: <bzolnier@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org,
       Borislav Petkov <petkovbb@gmail.com>
Subject: [PATCH 04/22] ide-tape: simplify code branching in the interrupt handler
Date: Mon,  4 Feb 2008 14:40:22 +0100
Message-Id: <1202132440-26648-5-git-send-email-petkovbb@gmail.com>
X-Mailer: git-send-email debian.1.5.3.7.1-dirty
In-Reply-To: <1202132440-26648-1-git-send-email-petkovbb@gmail.com>
References: <1202132440-26648-1-git-send-email-petkovbb@gmail.com>
From: Borislav Petkov <petkovbb@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

... by adding a new typedef function pointer idetape_io_buf in order to call
the proper buffer i/o handler depending on the data direction.

Signed-off-by: Borislav Petkov <petkovbb@gmail.com>
---
 drivers/ide/ide-tape.c |   55 +++++++++++++++++++++++++----------------------
 1 files changed, 29 insertions(+), 26 deletions(-)

diff --git a/drivers/ide/ide-tape.c b/drivers/ide/ide-tape.c
index b15dd17..2857965 100644
--- a/drivers/ide/ide-tape.c
+++ b/drivers/ide/ide-tape.c
@@ -1105,18 +1105,22 @@ static void idetape_postpone_request (ide_drive_t *drive)
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
+typedef void idetape_io_buf(ide_drive_t *, idetape_pc_t *, unsigned int);
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
@@ -1184,7 +1188,8 @@ static ide_startstop_t idetape_pc_intr (ide_drive_t *drive)
 			debug_log(DBG_ERR, "%s: I/O error\n", tape->name);
 
 			if (pc->c[0] == REQUEST_SENSE) {
-				printk(KERN_ERR "ide-tape: I/O error in request sense command\n");
+				printk(KERN_ERR "ide-tape: I/O error in request"
+						" sense command\n");
 				return ide_do_reset(drive);
 			}
 			debug_log(DBG_ERR, "[cmd %x]: check condition\n",
@@ -1223,7 +1228,7 @@ static ide_startstop_t idetape_pc_intr (ide_drive_t *drive)
 	ireason = hwif->INB(IDE_IREASON_REG);
 
 	if (ireason & CD) {
-		printk(KERN_ERR "ide-tape: CoD != 0 in idetape_pc_intr\n");
+		printk(KERN_ERR "ide-tape: CoD != 0 in %s\n", __func__);
 		return ide_do_reset(drive);
 	}
 	if (((ireason & IO) == IO) == test_bit(PC_WRITING, &pc->flags)) {
@@ -1239,31 +1244,29 @@ static ide_startstop_t idetape_pc_intr (ide_drive_t *drive)
 		temp = pc->actually_transferred + bcount;
 		if (temp > pc->request_transfer) {
 			if (temp > pc->buffer_size) {
-				printk(KERN_ERR "ide-tape: The tape wants to send us more data than expected - discarding data\n");
+				printk(KERN_ERR "ide-tape: The tape wants to "
+					"send us more data than expected "
+					"- discarding data\n");
 				idetape_discard_data(drive, bcount);
-				ide_set_handler(drive, &idetape_pc_intr, IDETAPE_WAIT_CMD, NULL);
+				ide_set_handler(drive, &idetape_pc_intr,
+						IDETAPE_WAIT_CMD, NULL);
 				return ide_started;
 			}
 			debug_log(DBG_SENSE, "The tape wants to send us more "
 				"data than expected - allowing transfer\n");
-
 		}
-	}
-	if (test_bit(PC_WRITING, &pc->flags)) {
-		if (pc->bh != NULL)
-			idetape_output_buffers(drive, pc, bcount);
-		else
-			/* Write the current buffer */
-			hwif->atapi_output_bytes(drive, pc->current_position,
-						 bcount);
+		iobuf = &idetape_input_buffers;
+		xferfunc = hwif->atapi_input_bytes;
 	} else {
-		if (pc->bh != NULL)
-			idetape_input_buffers(drive, pc, bcount);
-		else
-			/* Read the current buffer */
-			hwif->atapi_input_bytes(drive, pc->current_position,
-						bcount);
+		iobuf = &idetape_output_buffers;
+		xferfunc = hwif->atapi_output_bytes;
 	}
+
+	if (pc->bh)
+		iobuf(drive, pc, bcount);
+	else
+		xferfunc(drive, pc->current_position, bcount);
+
 	/* Update the current position */
 	pc->actually_transferred += bcount;
 	pc->current_position += bcount;
-- 
1.5.3.7

