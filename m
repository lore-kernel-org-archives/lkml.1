Return-Path: <linux-kernel-owner+w=401wt.eu-S933162AbYBMQYg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933162AbYBMQYg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2008 11:24:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757541AbYBMQX6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Feb 2008 11:23:58 -0500
Received: from ug-out-1314.google.com ([66.249.92.175]:65149 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759172AbYBMQX4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2008 11:23:56 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=to:cc:subject:date:message-id:x-mailer:in-reply-to:references:from;
        b=KWeeBjffq3CvOQZKYyoYUTJqxucROSVdIdmoFzEZq1SjpP8tJQWiIzR5LYyYAwQoMriXNUB9Qd1/jYAkSmnb8vjZ3iBplsAGrSECwsVJGteNvZ5CmgNIQueFe+fKDZUH+OT3fYGO47KXG7XYbkaRQ8pxYwZ9nxrDc0B64yFsKaA=
To: <bzolnier@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org,
       Borislav Petkov <petkovbb@gmail.com>
Subject: [PATCH 2/2] ide-scsi: do non-atomic pc->flags testing
Date: Wed, 13 Feb 2008 17:18:51 +0100
Message-Id: <1202919531-17798-2-git-send-email-petkovbb@gmail.com>
X-Mailer: git-send-email debian.1.5.3.7.1-dirty
In-Reply-To: <1202919531-17798-1-git-send-email-petkovbb@gmail.com>
References: <1202919531-17798-1-git-send-email-petkovbb@gmail.com>
From: Borislav Petkov <petkovbb@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Borislav Petkov <petkovbb@gmail.com>
---
 drivers/scsi/ide-scsi.c |   27 ++++++++++++++-------------
 1 files changed, 14 insertions(+), 13 deletions(-)

diff --git a/drivers/scsi/ide-scsi.c b/drivers/scsi/ide-scsi.c
index d46c81c..93c3fc2 100644
--- a/drivers/scsi/ide-scsi.c
+++ b/drivers/scsi/ide-scsi.c
@@ -311,10 +311,10 @@ static int idescsi_end_request (ide_drive_t *drive, int uptodate, int nrsecs)
 		pc = opc;
 		rq = pc->rq;
 		pc->scsi_cmd->result = (CHECK_CONDITION << 1) |
-				((test_bit(PC_FLAG_TIMEDOUT, &pc->flags) ?
+				(((pc->flags & PC_FLAG_TIMEDOUT) ?
 				  DID_TIME_OUT :
 				  DID_OK) << 16);
-	} else if (test_bit(PC_FLAG_TIMEDOUT, &pc->flags)) {
+	} else if (pc->flags & PC_FLAG_TIMEDOUT) {
 		if (log)
 			printk (KERN_WARNING "ide-scsi: %s: timed out for %lu\n",
 					drive->name, pc->scsi_cmd->serial_number);
@@ -356,7 +356,7 @@ static int idescsi_expiry(ide_drive_t *drive)
 #if IDESCSI_DEBUG_LOG
 	printk(KERN_WARNING "idescsi_expiry called for %lu at %lu\n", pc->scsi_cmd->serial_number, jiffies);
 #endif
-	set_bit(PC_FLAG_TIMEDOUT, &pc->flags);
+	pc->flags |= PC_FLAG_TIMEDOUT;
 
 	return 0;					/* we do not want the ide subsystem to retry */
 }
@@ -378,7 +378,7 @@ static ide_startstop_t idescsi_pc_intr (ide_drive_t *drive)
 	printk (KERN_INFO "ide-scsi: Reached idescsi_pc_intr interrupt handler\n");
 #endif /* IDESCSI_DEBUG_LOG */
 
-	if (test_bit(PC_FLAG_TIMEDOUT, &pc->flags)) {
+	if (pc->flags & PC_FLAG_TIMEDOUT) {
 #if IDESCSI_DEBUG_LOG
 		printk(KERN_WARNING "idescsi_pc_intr: got timed out packet  %lu at %lu\n",
 				pc->scsi_cmd->serial_number, jiffies);
@@ -387,7 +387,8 @@ static ide_startstop_t idescsi_pc_intr (ide_drive_t *drive)
 		idescsi_end_request (drive, 1, 0);
 		return ide_stopped;
 	}
-	if (test_and_clear_bit(PC_FLAG_DMA_IN_PROGRESS, &pc->flags)) {
+	if (pc->flags & PC_FLAG_DMA_IN_PROGRESS) {
+		pc->flags &= ~PC_FLAG_DMA_IN_PROGRESS;
 #if IDESCSI_DEBUG_LOG
 		printk ("ide-scsi: %s: DMA complete\n", drive->name);
 #endif /* IDESCSI_DEBUG_LOG */
@@ -426,7 +427,7 @@ static ide_startstop_t idescsi_pc_intr (ide_drive_t *drive)
 					"- discarding data\n");
 				temp = pc->buf_size - pc->xferred;
 				if (temp) {
-					clear_bit(PC_FLAG_WRITING, &pc->flags);
+					pc->flags &= ~PC_FLAG_WRITING;
 					if (pc->sg)
 						idescsi_input_buffers(drive, pc,
 									temp);
@@ -448,14 +449,14 @@ static ide_startstop_t idescsi_pc_intr (ide_drive_t *drive)
 		}
 	}
 	if (ireason & IO) {
-		clear_bit(PC_FLAG_WRITING, &pc->flags);
+		pc->flags &= ~PC_FLAG_WRITING;
 		if (pc->sg)
 			idescsi_input_buffers(drive, pc, bcount);
 		else
 			hwif->atapi_input_bytes(drive, pc->cur_pos,
 						bcount);
 	} else {
-		set_bit(PC_FLAG_WRITING, &pc->flags);
+		pc->flags |= PC_FLAG_WRITING;
 		if (pc->sg)
 			idescsi_output_buffers(drive, pc, bcount);
 		else
@@ -495,8 +496,8 @@ static ide_startstop_t idescsi_transfer_pc(ide_drive_t *drive)
 	ide_set_handler(drive, &idescsi_pc_intr, get_timeout(pc), idescsi_expiry);
 	/* Send the actual packet */
 	drive->hwif->atapi_output_bytes(drive, scsi->pc->c, 12);
-	if (test_bit(PC_FLAG_DMA_OK, &pc->flags)) {
-		set_bit(PC_FLAG_DMA_IN_PROGRESS, &pc->flags);
+	if (pc->flags & PC_FLAG_DMA_OK) {
+		pc->flags |= PC_FLAG_DMA_IN_PROGRESS;
 		hwif->dma_start(drive);
 	}
 	return ide_started;
@@ -506,10 +507,10 @@ static inline int idescsi_set_direction(struct ide_atapi_pc *pc)
 {
 	switch (pc->c[0]) {
 		case READ_6: case READ_10: case READ_12:
-			clear_bit(PC_FLAG_WRITING, &pc->flags);
+			pc->flags &= ~PC_FLAG_WRITING;
 			return 0;
 		case WRITE_6: case WRITE_10: case WRITE_12:
-			set_bit(PC_FLAG_WRITING, &pc->flags);
+			pc->flags |= PC_FLAG_WRITING;
 			return 0;
 		default:
 			return 1;
@@ -566,7 +567,7 @@ static ide_startstop_t idescsi_issue_pc(ide_drive_t *drive,
 	ide_pktcmd_tf_load(drive, IDE_TFLAG_NO_SELECT_MASK, bcount, dma);
 
 	if (dma)
-		set_bit(PC_FLAG_DMA_OK, &pc->flags);
+		pc->flags |= PC_FLAG_DMA_OK;
 
 	if (test_bit(IDESCSI_DRQ_INTERRUPT, &scsi->flags)) {
 		ide_execute_command(drive, WIN_PACKETCMD, &idescsi_transfer_pc,
-- 
1.5.3.7

