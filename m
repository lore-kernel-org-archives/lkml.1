Return-Path: <linux-kernel-owner+w=401wt.eu-S1762613AbZCXQKv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762613AbZCXQKv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Mar 2009 12:10:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761311AbZCXQGp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Mar 2009 12:06:45 -0400
Received: from hera.kernel.org ([140.211.167.34]:41833 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762040AbZCXQGi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Mar 2009 12:06:38 -0400
From: Tejun Heo <tj@kernel.org>
To: bzolnier@gmail.com, linux-kernel@vger.kernel.org, axboe@kernel.dk,
       linux-ide@vger.kernel.org
Cc: Tejun Heo <tj@kernel.org>
Subject: [PATCH 10/14] ide-atapi: don't abuse rq->buffer
Date: Wed, 25 Mar 2009 01:06:12 +0900
Message-Id: <1237910776-10983-11-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.6.0.2
In-Reply-To: <1237910776-10983-1-git-send-email-tj@kernel.org>
References: <1237910776-10983-1-git-send-email-tj@kernel.org>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Tue, 24 Mar 2009 16:06:34 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: rq->buffer usage cleanup

ide-atapi uses rq->buffer as private opaque value for internal special
requests.  rq->special isn't used for these cases (the only case where
rq->special is used is for ide-tape rw requests).  Use rq->special
instead.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Jens Axboe <axboe@kernel.dk>
---
 drivers/ide/ide-atapi.c  |    4 ++--
 drivers/ide/ide-floppy.c |    2 +-
 drivers/ide/ide-tape.c   |    2 +-
 3 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/ide/ide-atapi.c b/drivers/ide/ide-atapi.c
index 11a680c..5ab3014 100644
--- a/drivers/ide/ide-atapi.c
+++ b/drivers/ide/ide-atapi.c
@@ -88,7 +88,7 @@ static void ide_queue_pc_head(ide_drive_t *drive, struct gendisk *disk,
 	blk_rq_init(NULL, rq);
 	rq->cmd_type = REQ_TYPE_SPECIAL;
 	rq->cmd_flags |= REQ_PREEMPT;
-	rq->buffer = (char *)pc;
+	rq->special = (char *)pc;
 	rq->rq_disk = disk;
 
 	if (pc->req_xfer) {
@@ -117,7 +117,7 @@ int ide_queue_pc_tail(ide_drive_t *drive, struct gendisk *disk,
 
 	rq = blk_get_request(drive->queue, READ, __GFP_WAIT);
 	rq->cmd_type = REQ_TYPE_SPECIAL;
-	rq->buffer = (char *)pc;
+	rq->special = (char *)pc;
 
 	if (pc->req_xfer) {
 		rq->data = pc->buf;
diff --git a/drivers/ide/ide-floppy.c b/drivers/ide/ide-floppy.c
index 3b22e06..9460033 100644
--- a/drivers/ide/ide-floppy.c
+++ b/drivers/ide/ide-floppy.c
@@ -264,7 +264,7 @@ static ide_startstop_t ide_floppy_do_request(ide_drive_t *drive,
 		pc = &floppy->queued_pc;
 		idefloppy_create_rw_cmd(drive, pc, rq, (unsigned long)block);
 	} else if (blk_special_request(rq)) {
-		pc = (struct ide_atapi_pc *) rq->buffer;
+		pc = (struct ide_atapi_pc *)rq->special;
 	} else if (blk_pc_request(rq)) {
 		pc = &floppy->queued_pc;
 		idefloppy_blockpc_cmd(floppy, pc, rq);
diff --git a/drivers/ide/ide-tape.c b/drivers/ide/ide-tape.c
index cb942a9..3d16c77 100644
--- a/drivers/ide/ide-tape.c
+++ b/drivers/ide/ide-tape.c
@@ -834,7 +834,7 @@ static ide_startstop_t idetape_do_request(ide_drive_t *drive,
 		goto out;
 	}
 	if (rq->cmd[13] & REQ_IDETAPE_PC1) {
-		pc = (struct ide_atapi_pc *) rq->buffer;
+		pc = (struct ide_atapi_pc *)rq->special;
 		rq->cmd[13] &= ~(REQ_IDETAPE_PC1);
 		rq->cmd[13] |= REQ_IDETAPE_PC2;
 		goto out;
-- 
1.6.0.2

