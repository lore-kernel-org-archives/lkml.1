Return-Path: <linux-kernel-owner+w=401wt.eu-S1758944AbZCPCdw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758944AbZCPCdw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Mar 2009 22:33:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752473AbZCPC3Z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Mar 2009 22:29:25 -0400
Received: from hera.kernel.org ([140.211.167.34]:44317 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753248AbZCPC3W (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Mar 2009 22:29:22 -0400
From: Tejun Heo <tj@kernel.org>
To: axboe@kernel.dk, linux-kernel@vger.kernel.org, bzolnier@gmail.com
Cc: Tejun Heo <tj@kernel.org>
Subject: [PATCH 13/17] block: move rq->start_time initialization to blk_rq_init()
Date: Mon, 16 Mar 2009 11:28:56 +0900
Message-Id: <1237170540-19130-14-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.6.0.2
In-Reply-To: <1237170540-19130-1-git-send-email-tj@kernel.org>
References: <1237170540-19130-1-git-send-email-tj@kernel.org>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Mon, 16 Mar 2009 02:29:18 +0000 (UTC)
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

