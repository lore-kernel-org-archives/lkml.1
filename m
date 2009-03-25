Return-Path: <linux-kernel-owner+w=401wt.eu-S1758051AbZCYOY1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758051AbZCYOY1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Mar 2009 10:24:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760368AbZCYOYQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Mar 2009 10:24:16 -0400
Received: from hera.kernel.org ([140.211.167.34]:43341 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756923AbZCYOYP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Mar 2009 10:24:15 -0400
Message-ID: <49CA3E87.8010308@kernel.org>
Date: Wed, 25 Mar 2009 23:24:07 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: bzolnier@gmail.com, linux-kernel@vger.kernel.org, axboe@kernel.dk,
       linux-ide@vger.kernel.org
Subject: [PATCH 03/10 REPOST] ide-tape: use bio to carry data area
References: <1237990673-8358-1-git-send-email-tj@kernel.org> <1237990673-8358-4-git-send-email-tj@kernel.org>
In-Reply-To: <1237990673-8358-4-git-send-email-tj@kernel.org>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 25 Mar 2009 14:24:11 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: use standard way to carry data area in request

ide-tape uses rq in an interesting way.  For r/w requests, rq->special
is used to carry a private buffer management structure idetape_bh and
rq->nr_sectors and current_nr_sectors are initialized to the number of
idetape blocks which isn't necessary 512 bytes.  Also,
rq->current_nr_sectors is used to report back the residual count in
units of idetape blocks.

This peculiarity taxes both block layer and ide.  ide-atapi has
different paths and hooks to accomodate it and what a rq means becomes
quite confusing and making changes at the block layer becomes quite
difficult and error-prone.

This patch makes ide-tape use bio instead.  With the previous patch,
ide-tape currently is using single contiguos buffer so replacing it is
easy.  All that's necessary is doing blk_rq_map_kern() on issue, map
bio to sg in idetape_do_request() and use rq->data_len for residual
count instead of rq->current_nr_sectors.

This change also nicely removes the FIXME in ide_pc_intr() where
ide-tape rqs need to be completed using ide_rq_bytes() instead of
blk_rq_bytes() (although this didn't really matter as the request
didn't have bio).

Note that this patch only changes how the data areas are carried in
requests.  Data transfer is still done using idetape_bh.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Jens Axboe <jens.axboe@oracle.com>
---
Sorry, wrote description to the wrong file.  git tree updated as well.

 drivers/ide/ide-atapi.c |    5 +----
 drivers/ide/ide-tape.c  |   39 ++++++++++++++++++++++-----------------
 2 files changed, 23 insertions(+), 21 deletions(-)

diff --git a/drivers/ide/ide-atapi.c b/drivers/ide/ide-atapi.c
index 2b456c4..53e811d 100644
--- a/drivers/ide/ide-atapi.c
+++ b/drivers/ide/ide-atapi.c
@@ -372,10 +372,7 @@ static ide_startstop_t ide_pc_intr(ide_drive_t *drive)
 		 * ->pc_callback() might change rq->data_len for
 		 * residual count, cache total length.
 		 */
-		if (drive->media == ide_tape)
-			done = ide_rq_bytes(rq);	/* FIXME */
-		else
-			done = blk_rq_bytes(rq);
+		done = blk_rq_bytes(rq);
 
 		/* Command finished - Call the callback function */
 		uptodate = drive->pc_callback(drive, dsc);
diff --git a/drivers/ide/ide-tape.c b/drivers/ide/ide-tape.c
index 3a7bd98..bd0e839 100644
--- a/drivers/ide/ide-tape.c
+++ b/drivers/ide/ide-tape.c
@@ -458,7 +458,7 @@ static int ide_tape_callback(ide_drive_t *drive, int dsc)
 		}
 
 		tape->first_frame += blocks;
-		rq->current_nr_sectors -= blocks;
+		rq->data_len -= blocks * tape->blk_size;
 
 		if (pc->error) {
 			uptodate = 0;
@@ -799,10 +799,6 @@ static ide_startstop_t idetape_do_request(ide_drive_t *drive,
 		pc = (struct ide_atapi_pc *)rq->special;
 		rq->cmd[13] &= ~(REQ_IDETAPE_PC1);
 		rq->cmd[13] |= REQ_IDETAPE_PC2;
-		if (pc->req_xfer) {
-			ide_init_sg_cmd(&cmd, pc->req_xfer);
-			ide_map_sg(drive, &cmd);
-		}
 		goto out;
 	}
 	if (rq->cmd[13] & REQ_IDETAPE_PC2) {
@@ -812,6 +808,10 @@ static ide_startstop_t idetape_do_request(ide_drive_t *drive,
 	BUG();
 
 out:
+	if (pc->req_xfer) {
+		ide_init_sg_cmd(&cmd, pc->req_xfer);
+		ide_map_sg(drive, &cmd);
+	}
 	if (rq_data_dir(rq))
 		cmd.tf_flags |= IDE_TFLAG_WRITE;
 
@@ -1061,32 +1061,37 @@ static int idetape_queue_rw_tail(ide_drive_t *drive, int cmd, int blocks,
 				 struct idetape_bh *bh)
 {
 	idetape_tape_t *tape = drive->driver_data;
+	size_t size = blocks * tape->blk_size;
 	struct request *rq;
-	int ret, errors;
+	int ret;
 
 	debug_log(DBG_SENSE, "%s: cmd=%d\n", __func__, cmd);
+	BUG_ON(cmd != REQ_IDETAPE_READ && cmd != REQ_IDETAPE_WRITE);
 
 	rq = blk_get_request(drive->queue, READ, __GFP_WAIT);
 	rq->cmd_type = REQ_TYPE_SPECIAL;
 	rq->cmd[13] = cmd;
 	rq->rq_disk = tape->disk;
-	rq->special = (void *)bh;
 	rq->sector = tape->first_frame;
-	rq->nr_sectors = blocks;
-	rq->current_nr_sectors = blocks;
-	blk_execute_rq(drive->queue, tape->disk, rq, 0);
 
-	errors = rq->errors;
-	ret = tape->blk_size * (blocks - rq->current_nr_sectors);
-	blk_put_request(rq);
+	if (size) {
+		ret = blk_rq_map_kern(drive->queue, rq, bh->b_data, size,
+				      __GFP_WAIT);
+		if (ret)
+			goto out_put;
+	}
 
-	if ((cmd & (REQ_IDETAPE_READ | REQ_IDETAPE_WRITE)) == 0)
-		return 0;
+	blk_execute_rq(drive->queue, tape->disk, rq, 0);
+
+	size -= rq->data_len;
+	ret = size;
+	if (rq->errors == IDE_DRV_ERROR_GENERAL)
+		ret = -EIO;
 
 	if (tape->merge_bh)
 		idetape_init_merge_buffer(tape);
-	if (errors == IDE_DRV_ERROR_GENERAL)
-		return -EIO;
+out_put:
+	blk_put_request(rq);
 	return ret;
 }
 
-- 
1.6.0.2

