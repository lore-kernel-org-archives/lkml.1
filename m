Return-Path: <linux-kernel-owner+w=401wt.eu-S1760166AbYF2LDr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760166AbYF2LDr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jun 2008 07:03:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759907AbYF2K7m
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Jun 2008 06:59:42 -0400
Received: from fg-out-1718.google.com ([72.14.220.154]:56206 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756023AbYF2K7R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jun 2008 06:59:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=to:cc:subject:date:message-id:x-mailer:in-reply-to:references:from;
        b=BsK6y3SWY1CDLRV9+Or9qTcwnPG16JB/wkwG+QfNrgAlH4pqmisJisz7GPv+I3wdJE
         mI05kq/OS0zmkjUEwm9u2uYpr3H1GNZyBrlD18b+itCJlRcJ2f6ibPfSZmbjXlW3ReV6
         bjv0WfZ22P8VjEG0hzx2vJHgiwWE4Bl4VnpyM=
To: <bzolnier@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org,
       Borislav Petkov <petkovbb@gmail.com>
Subject: [PATCH 08/16] ide-tape: pass packet command in rq->cmd
Date: Sun, 29 Jun 2008 12:59:11 +0200
Message-Id: <1214737159-1078-9-git-send-email-petkovbb@gmail.com>
X-Mailer: git-send-email 1.5.5.1
In-Reply-To: <1214737159-1078-1-git-send-email-petkovbb@gmail.com>
References: <1214737159-1078-1-git-send-email-petkovbb@gmail.com>
From: Borislav Petkov <petkovbb@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make a redundant copy of the packet command bits into rq->cmd. Later, after
all drivers have been converted, it'll be switched to use that in the
common code instead of pc->c. While at it, simplify ide_tape_create_rw_cmd.

There should be no functionality change resulting from this patch.

Signed-off-by: Borislav Petkov <petkovbb@gmail.com>
---
 drivers/ide/ide-tape.c |   19 +++++++++++--------
 1 files changed, 11 insertions(+), 8 deletions(-)

diff --git a/drivers/ide/ide-tape.c b/drivers/ide/ide-tape.c
index efe9c51..e60faf3 100644
--- a/drivers/ide/ide-tape.c
+++ b/drivers/ide/ide-tape.c
@@ -731,6 +731,7 @@ static void idetape_queue_pc_head(ide_drive_t *drive, struct ide_atapi_pc *pc,
 	rq->cmd_flags |= REQ_PREEMPT;
 	rq->buffer = (char *) pc;
 	rq->rq_disk = tape->disk;
+	memcpy(rq->cmd, pc->c, 12);
 	ide_do_drive_cmd(drive, rq);
 }
 
@@ -952,9 +953,12 @@ static ide_startstop_t idetape_media_access_finished(ide_drive_t *drive)
 }
 
 static void ide_tape_create_rw_cmd(idetape_tape_t *tape,
-		struct ide_atapi_pc *pc, unsigned int length,
-		struct idetape_bh *bh, u8 opcode)
+				   struct ide_atapi_pc *pc, struct request *rq,
+				   u8 opcode)
 {
+	struct idetape_bh *bh = (struct idetape_bh *)rq->special;
+	unsigned int length = rq->current_nr_sectors;
+
 	idetape_init_pc(pc);
 	put_unaligned(cpu_to_be32(length), (unsigned int *) &pc->c[1]);
 	pc->c[1] = 1;
@@ -974,6 +978,8 @@ static void ide_tape_create_rw_cmd(idetape_tape_t *tape,
 		pc->b_data = bh->b_data;
 		pc->b_count = atomic_read(&bh->b_count);
 	}
+
+	memcpy(rq->cmd, pc->c, 12);
 }
 
 static ide_startstop_t idetape_do_request(ide_drive_t *drive,
@@ -1050,16 +1056,12 @@ static ide_startstop_t idetape_do_request(ide_drive_t *drive,
 	}
 	if (rq->cmd[13] & REQ_IDETAPE_READ) {
 		pc = idetape_next_pc_storage(drive);
-		ide_tape_create_rw_cmd(tape, pc, rq->current_nr_sectors,
-					(struct idetape_bh *)rq->special,
-					READ_6);
+		ide_tape_create_rw_cmd(tape, pc, rq, READ_6);
 		goto out;
 	}
 	if (rq->cmd[13] & REQ_IDETAPE_WRITE) {
 		pc = idetape_next_pc_storage(drive);
-		ide_tape_create_rw_cmd(tape, pc, rq->current_nr_sectors,
-					 (struct idetape_bh *)rq->special,
-					 WRITE_6);
+		ide_tape_create_rw_cmd(tape, pc, rq, WRITE_6);
 		goto out;
 	}
 	if (rq->cmd[13] & REQ_IDETAPE_PC1) {
@@ -1282,6 +1284,7 @@ static int idetape_queue_pc_tail(ide_drive_t *drive, struct ide_atapi_pc *pc)
 	rq->cmd_type = REQ_TYPE_SPECIAL;
 	rq->cmd[13] = REQ_IDETAPE_PC1;
 	rq->buffer = (char *)pc;
+	memcpy(rq->cmd, pc->c, 12);
 	error = blk_execute_rq(drive->queue, tape->disk, rq, 0);
 	blk_put_request(rq);
 	return error;
-- 
1.5.5.4

