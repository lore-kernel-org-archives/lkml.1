Return-Path: <linux-kernel-owner+w=401wt.eu-S1762635AbZCYOVb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762635AbZCYOVb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Mar 2009 10:21:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761520AbZCYOS0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Mar 2009 10:18:26 -0400
Received: from hera.kernel.org ([140.211.167.34]:57752 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761751AbZCYOSM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Mar 2009 10:18:12 -0400
From: Tejun Heo <tj@kernel.org>
To: bzolnier@gmail.com, linux-kernel@vger.kernel.org, axboe@kernel.dk,
       linux-ide@vger.kernel.org
Cc: Tejun Heo <tj@kernel.org>
Subject: [PATCH 09/10] ide-atapi: kill unused fields and callbacks
Date: Wed, 25 Mar 2009 23:17:52 +0900
Message-Id: <1237990673-8358-10-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.6.0.2
In-Reply-To: <1237990673-8358-1-git-send-email-tj@kernel.org>
References: <1237990673-8358-1-git-send-email-tj@kernel.org>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 25 Mar 2009 14:18:07 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: remove fields code paths which are no longer necessary

Now that ide-tape uses standard mechanisms to transfer data, special
case handling for bh handling can be dropped from ide-atapi.  Drop the
followings.

* pc->cur_pos, b_count, bh and b_data
* drive->pc_update_buffers() and pc_io_buffers().

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 drivers/ide/ide-atapi.c |   15 +++------------
 drivers/ide/ide-tape.c  |    1 -
 include/linux/ide.h     |   12 ------------
 3 files changed, 3 insertions(+), 25 deletions(-)

diff --git a/drivers/ide/ide-atapi.c b/drivers/ide/ide-atapi.c
index 53e811d..bbb8da1 100644
--- a/drivers/ide/ide-atapi.c
+++ b/drivers/ide/ide-atapi.c
@@ -317,9 +317,6 @@ static ide_startstop_t ide_pc_intr(ide_drive_t *drive)
 			pc->flags |= PC_FLAG_DMA_ERROR;
 		} else {
 			pc->xferred = pc->req_xfer;
-			if (drive->pc_update_buffers)
-				drive->pc_update_buffers(drive, pc);
-
 			if (drive->media == ide_floppy)
 				ide_complete_rq(drive, 0, blk_rq_bytes(rq));
 		}
@@ -420,16 +417,11 @@ static ide_startstop_t ide_pc_intr(ide_drive_t *drive)
 		return ide_do_reset(drive);
 	}
 
-	if (drive->media == ide_tape && pc->bh)
-		done = drive->pc_io_buffers(drive, pc, bcount, write);
-	else {
-		done = min_t(unsigned int, bcount, cmd->nleft);
-		ide_pio_bytes(drive, cmd, write, done);
-	}
+	done = min_t(unsigned int, bcount, cmd->nleft);
+	ide_pio_bytes(drive, cmd, write, done);
 
-	/* Update the current position */
+	/* Update transferred byte count */
 	pc->xferred += done;
-	pc->cur_pos += done;
 
 	bcount -= done;
 
@@ -610,7 +602,6 @@ ide_startstop_t ide_issue_pc(ide_drive_t *drive, struct ide_cmd *cmd)
 
 		/* We haven't transferred any data yet */
 		pc->xferred = 0;
-		pc->cur_pos = pc->buf;
 
 		tf_flags = IDE_TFLAG_OUT_DEVICE;
 		bcount = ((drive->media == ide_tape) ?
diff --git a/drivers/ide/ide-tape.c b/drivers/ide/ide-tape.c
index 95e9131..557f073 100644
--- a/drivers/ide/ide-tape.c
+++ b/drivers/ide/ide-tape.c
@@ -593,7 +593,6 @@ static void ide_tape_create_rw_cmd(idetape_tape_t *tape,
 	ide_init_pc(pc);
 	put_unaligned(cpu_to_be32(length), (unsigned int *) &pc->c[1]);
 	pc->c[1] = 1;
-	pc->bh = NULL;
 	pc->buf = NULL;
 	pc->buf_size = length * tape->blk_size;
 	pc->req_xfer = pc->buf_size;
diff --git a/include/linux/ide.h b/include/linux/ide.h
index 8d3bb27..996adae 100644
--- a/include/linux/ide.h
+++ b/include/linux/ide.h
@@ -397,11 +397,7 @@ struct ide_atapi_pc {
 
 	/* data buffer */
 	u8 *buf;
-	/* current buffer position */
-	u8 *cur_pos;
 	int buf_size;
-	/* missing/available data on the current buffer */
-	int b_count;
 
 	/* the corresponding request */
 	struct request *rq;
@@ -414,10 +410,6 @@ struct ide_atapi_pc {
 	 */
 	u8 pc_buf[IDE_PC_BUFFER_SIZE];
 
-	/* idetape only */
-	struct idetape_bh *bh;
-	char *b_data;
-
 	unsigned long timeout;
 };
 
@@ -630,10 +622,6 @@ struct ide_drive_s {
 	/* callback for packet commands */
 	int  (*pc_callback)(struct ide_drive_s *, int);
 
-	void (*pc_update_buffers)(struct ide_drive_s *, struct ide_atapi_pc *);
-	int  (*pc_io_buffers)(struct ide_drive_s *, struct ide_atapi_pc *,
-			      unsigned int, int);
-
 	ide_startstop_t (*irq_handler)(struct ide_drive_s *);
 
 	unsigned long atapi_flags;
-- 
1.6.0.2

