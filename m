Return-Path: <linux-kernel-owner+w=401wt.eu-S1762602AbZCXQJ7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762602AbZCXQJ7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Mar 2009 12:09:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762220AbZCXQGm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Mar 2009 12:06:42 -0400
Received: from hera.kernel.org ([140.211.167.34]:41830 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762200AbZCXQGi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Mar 2009 12:06:38 -0400
From: Tejun Heo <tj@kernel.org>
To: bzolnier@gmail.com, linux-kernel@vger.kernel.org, axboe@kernel.dk,
       linux-ide@vger.kernel.org
Cc: Tejun Heo <tj@kernel.org>
Subject: [PATCH 09/14] ide-taskfile: don't abuse rq->buffer
Date: Wed, 25 Mar 2009 01:06:11 +0900
Message-Id: <1237910776-10983-10-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.6.0.2
In-Reply-To: <1237910776-10983-1-git-send-email-tj@kernel.org>
References: <1237910776-10983-1-git-send-email-tj@kernel.org>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Tue, 24 Mar 2009 16:06:34 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: rq->buffer usage cleanup

ide_raw_taskfile() directly uses rq->buffer to carry pointer to the
data buffer.  This complicates both block interface and ide backend
request handling.  Use blk_rq_map_kern() instead and drop special
handling for REQ_TYPE_ATA_TASKFILE from ide_map_sg().

Note that REQ_RW setting is moved upwards as blk_rq_map_kern() uses it
to initialize bio rw flag.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Jens Axboe <axboe@kernel.dk>
---
 drivers/ide/ide-io.c       |    5 +----
 drivers/ide/ide-taskfile.c |   18 +++++++++++-------
 2 files changed, 12 insertions(+), 11 deletions(-)

diff --git a/drivers/ide/ide-io.c b/drivers/ide/ide-io.c
index 0321278..c2e622f 100644
--- a/drivers/ide/ide-io.c
+++ b/drivers/ide/ide-io.c
@@ -244,10 +244,7 @@ void ide_map_sg(ide_drive_t *drive, struct ide_cmd *cmd)
 	struct scatterlist *sg = hwif->sg_table;
 	struct request *rq = cmd->rq;
 
-	if (rq->cmd_type == REQ_TYPE_ATA_TASKFILE) {
-		sg_init_one(sg, rq->buffer, rq->nr_sectors * SECTOR_SIZE);
-		cmd->sg_nents = 1;
-	} else if (!rq->bio) {
+	if (!rq->bio) {
 		sg_init_one(sg, rq->data, rq->data_len);
 		cmd->sg_nents = 1;
 	} else
diff --git a/drivers/ide/ide-taskfile.c b/drivers/ide/ide-taskfile.c
index 243421c..4e0d66f 100644
--- a/drivers/ide/ide-taskfile.c
+++ b/drivers/ide/ide-taskfile.c
@@ -396,7 +396,9 @@ int ide_raw_taskfile(ide_drive_t *drive, struct ide_cmd *cmd, u8 *buf,
 
 	rq = blk_get_request(drive->queue, READ, __GFP_WAIT);
 	rq->cmd_type = REQ_TYPE_ATA_TASKFILE;
-	rq->buffer = buf;
+
+	if (cmd->tf_flags & IDE_TFLAG_WRITE)
+		rq->cmd_flags |= REQ_RW;
 
 	/*
 	 * (ks) We transfer currently only whole sectors.
@@ -404,18 +406,20 @@ int ide_raw_taskfile(ide_drive_t *drive, struct ide_cmd *cmd, u8 *buf,
 	 * if we would find a solution to transfer any size.
 	 * To support special commands like READ LONG.
 	 */
-	rq->hard_nr_sectors = rq->nr_sectors = nsect;
-	rq->hard_cur_sectors = rq->current_nr_sectors = nsect;
-
-	if (cmd->tf_flags & IDE_TFLAG_WRITE)
-		rq->cmd_flags |= REQ_RW;
+	if (nsect) {
+		error = blk_rq_map_kern(drive->queue, rq, buf,
+					nsect * SECTOR_SIZE, __GFP_WAIT);
+		if (error)
+			goto put_req;
+	}
 
 	rq->special = cmd;
 	cmd->rq = rq;
 
 	error = blk_execute_rq(drive->queue, NULL, rq, 0);
-	blk_put_request(rq);
 
+put_req:
+	blk_put_request(rq);
 	return error;
 }
 
-- 
1.6.0.2

