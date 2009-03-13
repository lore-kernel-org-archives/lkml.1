Return-Path: <linux-kernel-owner+w=401wt.eu-S1758239AbZCMFGk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758239AbZCMFGk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Mar 2009 01:06:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756979AbZCMFDp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Mar 2009 01:03:45 -0400
Received: from hera.kernel.org ([140.211.167.34]:59762 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757341AbZCMFDo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Mar 2009 01:03:44 -0400
From: Tejun Heo <tj@kernel.org>
To: axboe@kernel.dk, linux-kernel@vger.kernel.org
Cc: Tejun Heo <tj@kernel.org>
Subject: [PATCH 10/14] block: move rq->start_time initialization to blk_rq_init()
Date: Fri, 13 Mar 2009 14:02:54 +0900
Message-Id: <1236920578-2179-11-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.6.0.2
In-Reply-To: <1236920578-2179-1-git-send-email-tj@kernel.org>
References: <1236920578-2179-1-git-send-email-tj@kernel.org>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Fri, 13 Mar 2009 05:03:35 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: rq->start_time is valid for all requests

rq->start_time was initialized in init_request_from_bio() so special
requests didn't have start_time set.  This has been okay as start_time
has been used only for fs requests; however, there is no indication of
this actually is the case or not.  Set rq->start_time in blk_rq_init()
and guarantee that all initialized rq's have its start_time set.  This
improves consistency at virtually no cost and future changes will make
use of the timestamp for !bio requests.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 block/blk-core.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/block/blk-core.c b/block/blk-core.c
index b1781dd..7d0ab48 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -134,6 +134,7 @@ void blk_rq_init(struct request_queue *q, struct request *rq)
 	rq->cmd = rq->__cmd;
 	rq->tag = -1;
 	rq->ref_count = 1;
+	rq->start_time = jiffies;
 }
 EXPORT_SYMBOL(blk_rq_init);
 
@@ -1094,7 +1095,6 @@ void init_request_from_bio(struct request *req, struct bio *bio)
 	req->errors = 0;
 	req->hard_sector = req->sector = bio->bi_sector;
 	req->ioprio = bio_prio(bio);
-	req->start_time = jiffies;
 	blk_rq_bio_prep(req->q, req, bio);
 }
 
-- 
1.6.0.2

