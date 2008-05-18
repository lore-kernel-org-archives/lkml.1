Return-Path: <linux-kernel-owner+w=401wt.eu-S1760966AbYERSwN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760966AbYERSwN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 May 2008 14:52:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757998AbYERSmh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 May 2008 14:42:37 -0400
Received: from gv-out-0910.google.com ([216.239.58.185]:22495 "EHLO
	gv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758526AbYERSmf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 May 2008 14:42:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=NyiILXyALI/XcEmAY5L6zub+dOLHo6y4ajXBNIXYNihbFCAD/+VfXrmQMJc4cBncZYZ5l4Xo7OXmCswb72XLgjiqQT+tRAxkv7WKnLKRxFyjDjVHRbBgcOW8YxBqbm5X/BR3icMGfwkRVRIhhLBnoEE1pElSiZ7UTwBcgteeDW4=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: Borislav Petkov <petkovbb@gmail.com>,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Date: Sun, 18 May 2008 21:00:00 +0200
Message-Id: <20080518190000.5636.8620.sendpatchset@localhost.localdomain>
In-Reply-To: <20080518185428.5636.77234.sendpatchset@localhost.localdomain>
References: <20080518185428.5636.77234.sendpatchset@localhost.localdomain>
Subject: [PATCH 37/40] ide-scsi: use pc->callback
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Add ide_scsi_callback() pc->callback implementation, then update
  idescsi_check_condition() and idescsi_queue() to setup ->callback.

* Convert idescsi_pc_intr() to use pc->callback.

This is a preparation for adding generic ide_pc_intr() helper.

Cc: Borislav Petkov <petkovbb@gmail.com>
Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/scsi/ide-scsi.c |   32 ++++++++++++++++++++++----------
 1 file changed, 22 insertions(+), 10 deletions(-)

Index: b/drivers/scsi/ide-scsi.c
===================================================================
--- a/drivers/scsi/ide-scsi.c
+++ b/drivers/scsi/ide-scsi.c
@@ -183,6 +183,24 @@ static void ide_scsi_hex_dump(u8 *data, 
 	print_hex_dump(KERN_CONT, "", DUMP_PREFIX_NONE, 16, 1, data, len, 0);
 }
 
+static int idescsi_end_request(ide_drive_t *, int, int);
+
+static void ide_scsi_callback(ide_drive_t *drive)
+{
+	idescsi_scsi_t *scsi = drive_to_idescsi(drive);
+	struct ide_atapi_pc *pc = scsi->pc;
+
+	if (pc->flags & PC_FLAG_TIMEDOUT)
+		debug_log("%s: got timed out packet %lu at %lu\n", __func__,
+			  pc->scsi_cmd->serial_number, jiffies);
+		/* end this request now - scsi should retry it*/
+	else if (test_bit(IDESCSI_LOG_CMD, &scsi->log))
+		printk(KERN_INFO "Packet command completed, %d bytes"
+				 " transferred\n", pc->xferred);
+
+	idescsi_end_request(drive, 1, 0);
+}
+
 static int idescsi_check_condition(ide_drive_t *drive,
 		struct request *failed_cmd)
 {
@@ -210,6 +228,7 @@ static int idescsi_check_condition(ide_d
 	rq->cmd_type = REQ_TYPE_SENSE;
 	rq->cmd_flags |= REQ_PREEMPT;
 	pc->timeout = jiffies + WAIT_READY;
+	pc->callback = ide_scsi_callback;
 	/* NOTE! Save the failed packet command in "rq->buffer" */
 	rq->buffer = (void *) failed_cmd->special;
 	pc->scsi_cmd = ((struct ide_atapi_pc *) failed_cmd->special)->scsi_cmd;
@@ -222,8 +241,6 @@ static int idescsi_check_condition(ide_d
 	return 0;
 }
 
-static int idescsi_end_request(ide_drive_t *, int, int);
-
 static ide_startstop_t
 idescsi_atapi_error(ide_drive_t *drive, struct request *rq, u8 stat, u8 err)
 {
@@ -350,10 +367,7 @@ static ide_startstop_t idescsi_pc_intr (
 	debug_log("Reached %s interrupt handler\n", __func__);
 
 	if (pc->flags & PC_FLAG_TIMEDOUT) {
-		debug_log("%s: got timed out packet %lu at %lu\n", __func__,
-			  pc->scsi_cmd->serial_number, jiffies);
-		/* end this request now - scsi should retry it*/
-		idescsi_end_request (drive, 1, 0);
+		pc->callback(drive);
 		return ide_stopped;
 	}
 	if (pc->flags & PC_FLAG_DMA_IN_PROGRESS) {
@@ -369,14 +383,11 @@ static ide_startstop_t idescsi_pc_intr (
 
 	if ((stat & DRQ_STAT) == 0) {
 		/* No more interrupts */
-		if (test_bit(IDESCSI_LOG_CMD, &scsi->log))
-			printk(KERN_INFO "Packet command completed, %d bytes"
-					" transferred\n", pc->xferred);
 		pc->flags &= ~PC_FLAG_DMA_IN_PROGRESS;
 		local_irq_enable_in_hardirq();
 		if ((stat & ERR_STAT) || (pc->flags & PC_FLAG_DMA_ERROR))
 			rq->errors++;
-		idescsi_end_request (drive, 1, 0);
+		pc->callback(drive);
 		return ide_stopped;
 	}
 	if (pc->flags & PC_FLAG_DMA_IN_PROGRESS) {
@@ -718,6 +729,7 @@ static int idescsi_queue (struct scsi_cm
 	pc->scsi_cmd = cmd;
 	pc->done = done;
 	pc->timeout = jiffies + cmd->timeout_per_command;
+	pc->callback = ide_scsi_callback;
 
 	if (test_bit(IDESCSI_LOG_CMD, &scsi->log)) {
 		printk ("ide-scsi: %s: que %lu, cmd = ", drive->name, cmd->serial_number);
