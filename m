Return-Path: <linux-kernel-owner+w=401wt.eu-S1760368AbYF2LBx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760368AbYF2LBx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jun 2008 07:01:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758502AbYF2K71
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Jun 2008 06:59:27 -0400
Received: from fg-out-1718.google.com ([72.14.220.153]:57300 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755380AbYF2K7P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jun 2008 06:59:15 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=to:cc:subject:date:message-id:x-mailer:in-reply-to:references:from;
        b=sItNOs2hj/x1Ltxu6610wL+oTNrUfvz8NYw3AbZfIIHjywjxC2z00M2HD/UtIdp2Xd
         rLGcch3Wqnuz/Dc2zILlJvt16hZ0V1EEtlw4cVZ0kTODd+jQITNKxAKrf3TYN5Ev7zs5
         efRUgNoJl0TAtMJhKBaatJDYebCz1V5zVu0G8=
To: <bzolnier@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org,
       Borislav Petkov <petkovbb@gmail.com>
Subject: [PATCH 07/16] ide-tape: make room for packet command ids in rq->cmd
Date: Sun, 29 Jun 2008 12:59:10 +0200
Message-Id: <1214737159-1078-8-git-send-email-petkovbb@gmail.com>
X-Mailer: git-send-email 1.5.5.1
In-Reply-To: <1214737159-1078-1-git-send-email-petkovbb@gmail.com>
References: <1214737159-1078-1-git-send-email-petkovbb@gmail.com>
From: Borislav Petkov <petkovbb@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ide-tape uses rq->cmd for special commands from the chrdev interface so move
those to byte 13 (BLK_MAX_CDB = 16) since a packet cmd is max 12 bytes.

There should be no functionality change resulting from this patch.

Signed-off-by: Borislav Petkov <petkovbb@gmail.com>
---
 drivers/ide/ide-tape.c |   22 +++++++++++-----------
 1 files changed, 11 insertions(+), 11 deletions(-)

diff --git a/drivers/ide/ide-tape.c b/drivers/ide/ide-tape.c
index b9179ee..efe9c51 100644
--- a/drivers/ide/ide-tape.c
+++ b/drivers/ide/ide-tape.c
@@ -704,7 +704,7 @@ static void idetape_init_rq(struct request *rq, u8 cmd)
 {
 	blk_rq_init(NULL, rq);
 	rq->cmd_type = REQ_TYPE_SPECIAL;
-	rq->cmd[0] = cmd;
+	rq->cmd[13] = cmd;
 }
 
 /*
@@ -1018,7 +1018,7 @@ static ide_startstop_t idetape_do_request(ide_drive_t *drive,
 	 */
 	stat = ide_read_status(drive);
 
-	if (!drive->dsc_overlap && !(rq->cmd[0] & REQ_IDETAPE_PC2))
+	if (!drive->dsc_overlap && !(rq->cmd[13] & REQ_IDETAPE_PC2))
 		set_bit(IDETAPE_FLAG_IGNORE_DSC, &tape->flags);
 
 	if (drive->post_reset == 1) {
@@ -1035,7 +1035,7 @@ static ide_startstop_t idetape_do_request(ide_drive_t *drive,
 		} else if (time_after(jiffies, tape->dsc_timeout)) {
 			printk(KERN_ERR "ide-tape: %s: DSC timeout\n",
 				tape->name);
-			if (rq->cmd[0] & REQ_IDETAPE_PC2) {
+			if (rq->cmd[13] & REQ_IDETAPE_PC2) {
 				idetape_media_access_finished(drive);
 				return ide_stopped;
 			} else {
@@ -1048,27 +1048,27 @@ static ide_startstop_t idetape_do_request(ide_drive_t *drive,
 		idetape_postpone_request(drive);
 		return ide_stopped;
 	}
-	if (rq->cmd[0] & REQ_IDETAPE_READ) {
+	if (rq->cmd[13] & REQ_IDETAPE_READ) {
 		pc = idetape_next_pc_storage(drive);
 		ide_tape_create_rw_cmd(tape, pc, rq->current_nr_sectors,
 					(struct idetape_bh *)rq->special,
 					READ_6);
 		goto out;
 	}
-	if (rq->cmd[0] & REQ_IDETAPE_WRITE) {
+	if (rq->cmd[13] & REQ_IDETAPE_WRITE) {
 		pc = idetape_next_pc_storage(drive);
 		ide_tape_create_rw_cmd(tape, pc, rq->current_nr_sectors,
 					 (struct idetape_bh *)rq->special,
 					 WRITE_6);
 		goto out;
 	}
-	if (rq->cmd[0] & REQ_IDETAPE_PC1) {
+	if (rq->cmd[13] & REQ_IDETAPE_PC1) {
 		pc = (struct ide_atapi_pc *) rq->buffer;
-		rq->cmd[0] &= ~(REQ_IDETAPE_PC1);
-		rq->cmd[0] |= REQ_IDETAPE_PC2;
+		rq->cmd[13] &= ~(REQ_IDETAPE_PC1);
+		rq->cmd[13] |= REQ_IDETAPE_PC2;
 		goto out;
 	}
-	if (rq->cmd[0] & REQ_IDETAPE_PC2) {
+	if (rq->cmd[13] & REQ_IDETAPE_PC2) {
 		idetape_media_access_finished(drive);
 		return ide_stopped;
 	}
@@ -1280,7 +1280,7 @@ static int idetape_queue_pc_tail(ide_drive_t *drive, struct ide_atapi_pc *pc)
 
 	rq = blk_get_request(drive->queue, READ, __GFP_WAIT);
 	rq->cmd_type = REQ_TYPE_SPECIAL;
-	rq->cmd[0] = REQ_IDETAPE_PC1;
+	rq->cmd[13] = REQ_IDETAPE_PC1;
 	rq->buffer = (char *)pc;
 	error = blk_execute_rq(drive->queue, tape->disk, rq, 0);
 	blk_put_request(rq);
@@ -1464,7 +1464,7 @@ static int idetape_queue_rw_tail(ide_drive_t *drive, int cmd, int blocks,
 
 	rq = blk_get_request(drive->queue, READ, __GFP_WAIT);
 	rq->cmd_type = REQ_TYPE_SPECIAL;
-	rq->cmd[0] = cmd;
+	rq->cmd[13] = cmd;
 	rq->rq_disk = tape->disk;
 	rq->special = (void *)bh;
 	rq->sector = tape->first_frame;
-- 
1.5.5.4

