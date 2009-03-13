Return-Path: <linux-kernel-owner+w=401wt.eu-S1757807AbZCMFEs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757807AbZCMFEs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Mar 2009 01:04:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756462AbZCMFDe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Mar 2009 01:03:34 -0400
Received: from hera.kernel.org ([140.211.167.34]:59741 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752719AbZCMFDb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Mar 2009 01:03:31 -0400
From: Tejun Heo <tj@kernel.org>
To: axboe@kernel.dk, linux-kernel@vger.kernel.org
Cc: Tejun Heo <tj@kernel.org>
Subject: [PATCH 04/14] block: cleanup REQ_SOFTBARRIER usages
Date: Fri, 13 Mar 2009 14:02:48 +0900
Message-Id: <1236920578-2179-5-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.6.0.2
In-Reply-To: <1236920578-2179-1-git-send-email-tj@kernel.org>
References: <1236920578-2179-1-git-send-email-tj@kernel.org>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Fri, 13 Mar 2009 05:03:22 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: cleanup

Low level drivers don't need to worry about REQ_SOFTBARRIER, either
does blk_insert_request().  Don't set it there.  It doesn't cause
malfunction but is confusing.  After this, REQ_SOFTBARRIER is used
only in elevator proper and for discard requests.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 block/blk-core.c         |    1 -
 drivers/ide/ide-disk.c   |    1 -
 drivers/ide/ide-ioctls.c |    1 -
 3 files changed, 0 insertions(+), 3 deletions(-)

diff --git a/block/blk-core.c b/block/blk-core.c
index d7b2cc9..9e5f154 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -944,7 +944,6 @@ void blk_insert_request(struct request_queue *q, struct request *rq,
 	 * barrier
 	 */
 	rq->cmd_type = REQ_TYPE_SPECIAL;
-	rq->cmd_flags |= REQ_SOFTBARRIER;
 
 	rq->special = data;
 
diff --git a/drivers/ide/ide-disk.c b/drivers/ide/ide-disk.c
index 806760d..0cd287d 100644
--- a/drivers/ide/ide-disk.c
+++ b/drivers/ide/ide-disk.c
@@ -405,7 +405,6 @@ static void idedisk_prepare_flush(struct request_queue *q, struct request *rq)
 	task->data_phase = TASKFILE_NO_DATA;
 
 	rq->cmd_type = REQ_TYPE_ATA_TASKFILE;
-	rq->cmd_flags |= REQ_SOFTBARRIER;
 	rq->special = task;
 }
 
diff --git a/drivers/ide/ide-ioctls.c b/drivers/ide/ide-ioctls.c
index 1be263e..d440fbb 100644
--- a/drivers/ide/ide-ioctls.c
+++ b/drivers/ide/ide-ioctls.c
@@ -229,7 +229,6 @@ static int generic_drive_reset(ide_drive_t *drive)
 	rq->cmd_type = REQ_TYPE_SPECIAL;
 	rq->cmd_len = 1;
 	rq->cmd[0] = REQ_DRIVE_RESET;
-	rq->cmd_flags |= REQ_SOFTBARRIER;
 	if (blk_execute_rq(drive->queue, NULL, rq, 1))
 		ret = rq->errors;
 	blk_put_request(rq);
-- 
1.6.0.2

