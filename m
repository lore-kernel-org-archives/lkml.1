Return-Path: <linux-kernel-owner+w=401wt.eu-S1760995AbYBLP0b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760995AbYBLP0b (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2008 10:26:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755675AbYBLP0V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Feb 2008 10:26:21 -0500
Received: from wa-out-1112.google.com ([209.85.146.183]:11885 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755157AbYBLP0U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2008 10:26:20 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=date:to:cc:subject:message-id:reply-to:mail-followup-to:references:mime-version:content-type:content-disposition:content-transfer-encoding:in-reply-to:user-agent:from;
        b=rtpgtJX7fhV3YvfBKfclSA4vrC/JpQQUSEIGpeTPAoB9ub8s4qMbAhmuwB76Chj0yP2F/8d05cufhdo6WGRjPJJTFsaRotAyg22M5W7vSyAz7gIWYt5PVfxYRAoXTILkWo8Ar9d5rEDsIH7S27CCr+FeE1XD+HRKv8qW6HILJzU=
Date: Tue, 12 Feb 2008 16:25:50 +0100
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org
Subject: [PATCH] ide-scsi: do non-atomic pc->flags testing
Message-ID: <20080212152550.GE4530@gollum.tnic>
Reply-To: petkovbb@gmail.com
Mail-Followup-To: petkovbb@gmail.com,
	Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
	linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org
References: <1202718880-1793-1-git-send-email-petkovbb@gmail.com> <200802120109.24152.bzolnier@gmail.com> <20080212055919.GD2879@gollum.tnic> <200802121328.48515.bzolnier@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <200802121328.48515.bzolnier@gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
From: Borislav Petkov <petkovbb@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

commit 272976f0f5754707f9e41da315717a6eb8d9d536
Author: Borislav Petkov <petkovbb@gmail.com>
Date:   Tue Feb 12 16:22:44 2008 +0100

    ide-scsi: do non-atomic pc->flags testing

    Signed-off-by: Borislav Petkov <petkovbb@gmail.com>

diff --git a/drivers/scsi/ide-scsi.c b/drivers/scsi/ide-scsi.c
index 5ec421c..eb84cdc 100644
--- a/drivers/scsi/ide-scsi.c
+++ b/drivers/scsi/ide-scsi.c
@@ -319,8 +319,10 @@ static int idescsi_end_request (ide_drive_t *drive, int uptodate, int nrsecs)
 		pc = opc;
 		rq = pc->rq;
 		pc->scsi_cmd->result = (CHECK_CONDITION << 1) |
-					((test_bit(PC_TIMEDOUT, &pc->flags)?DID_TIME_OUT:DID_OK) << 16);
-	} else if (test_bit(PC_TIMEDOUT, &pc->flags)) {
+					(((pc->flags & PC_TIMEDOUT) ?
+							  DID_TIME_OUT :
+							  DID_OK) << 16);
+	} else if (pc->flags & PC_TIMEDOUT) {
 		if (log)
 			printk (KERN_WARNING "ide-scsi: %s: timed out for %lu\n",
 					drive->name, pc->scsi_cmd->serial_number);
@@ -362,7 +364,7 @@ static int idescsi_expiry(ide_drive_t *drive)
 #if IDESCSI_DEBUG_LOG
 	printk(KERN_WARNING "idescsi_expiry called for %lu at %lu\n", pc->scsi_cmd->serial_number, jiffies);
 #endif
-	set_bit(PC_TIMEDOUT, &pc->flags);
+	pc->flags |= PC_TIMEDOUT;
 
 	return 0;					/* we do not want the ide subsystem to retry */
 }
@@ -384,7 +386,7 @@ static ide_startstop_t idescsi_pc_intr (ide_drive_t *drive)
 	printk (KERN_INFO "ide-scsi: Reached idescsi_pc_intr interrupt handler\n");
 #endif /* IDESCSI_DEBUG_LOG */
 
-	if (test_bit(PC_TIMEDOUT, &pc->flags)){
+	if (pc->flags & PC_TIMEDOUT) {
 #if IDESCSI_DEBUG_LOG
 		printk(KERN_WARNING "idescsi_pc_intr: got timed out packet  %lu at %lu\n",
 				pc->scsi_cmd->serial_number, jiffies);
@@ -393,7 +395,8 @@ static ide_startstop_t idescsi_pc_intr (ide_drive_t *drive)
 		idescsi_end_request (drive, 1, 0);
 		return ide_stopped;
 	}
-	if (test_and_clear_bit (PC_DMA_IN_PROGRESS, &pc->flags)) {
+	if (pc->flags & PC_DMA_IN_PROGRESS) {
+		pc->flags &= ~PC_DMA_IN_PROGRESS;
 #if IDESCSI_DEBUG_LOG
 		printk ("ide-scsi: %s: DMA complete\n", drive->name);
 #endif /* IDESCSI_DEBUG_LOG */
@@ -432,7 +435,7 @@ static ide_startstop_t idescsi_pc_intr (ide_drive_t *drive)
 					"- discarding data\n");
 				temp = pc->buf_size - pc->xferred;
 				if (temp) {
-					clear_bit(PC_WRITING, &pc->flags);
+					pc->flags &= ~PC_WRITING;
 					if (pc->sg)
 						idescsi_input_buffers(drive, pc,
 									temp);
@@ -454,14 +457,14 @@ static ide_startstop_t idescsi_pc_intr (ide_drive_t *drive)
 		}
 	}
 	if (ireason & IO) {
-		clear_bit(PC_WRITING, &pc->flags);
+		pc->flags &= ~PC_WRITING;
 		if (pc->sg)
 			idescsi_input_buffers(drive, pc, bcount);
 		else
 			hwif->atapi_input_bytes(drive, pc->cur_pos,
 						bcount);
 	} else {
-		set_bit(PC_WRITING, &pc->flags);
+		pc->flags |= PC_WRITING;
 		if (pc->sg)
 			idescsi_output_buffers(drive, pc, bcount);
 		else
@@ -501,8 +504,8 @@ static ide_startstop_t idescsi_transfer_pc(ide_drive_t *drive)
 	ide_set_handler(drive, &idescsi_pc_intr, get_timeout(pc), idescsi_expiry);
 	/* Send the actual packet */
 	drive->hwif->atapi_output_bytes(drive, scsi->pc->c, 12);
-	if (test_bit (PC_DMA_OK, &pc->flags)) {
-		set_bit (PC_DMA_IN_PROGRESS, &pc->flags);
+	if (pc->flags & PC_DMA_OK) {
+		pc->flags |= PC_DMA_IN_PROGRESS;
 		hwif->dma_start(drive);
 	}
 	return ide_started;
@@ -512,10 +515,10 @@ static inline int idescsi_set_direction(struct ide_atapi_pc *pc)
 {
 	switch (pc->c[0]) {
 		case READ_6: case READ_10: case READ_12:
-			clear_bit(PC_WRITING, &pc->flags);
+			pc->flags &= ~PC_WRITING;
 			return 0;
 		case WRITE_6: case WRITE_10: case WRITE_12:
-			set_bit(PC_WRITING, &pc->flags);
+			pc->flags |= PC_WRITING;
 			return 0;
 		default:
 			return 1;
@@ -572,7 +575,7 @@ static ide_startstop_t idescsi_issue_pc(ide_drive_t *drive,
 	ide_pktcmd_tf_load(drive, IDE_TFLAG_NO_SELECT_MASK, bcount, dma);
 
 	if (dma)
-		set_bit(PC_DMA_OK, &pc->flags);
+		pc->flags |= PC_DMA_OK;
 
 	if (test_bit(IDESCSI_DRQ_INTERRUPT, &scsi->flags)) {
 		ide_execute_command(drive, WIN_PACKETCMD, &idescsi_transfer_pc,
-- 
Regards/Gruﬂ,
    Boris.
