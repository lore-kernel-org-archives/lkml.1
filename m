Return-Path: <linux-kernel-owner+w=401wt.eu-S1756758AbZDUQlY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756758AbZDUQlY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Apr 2009 12:41:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755553AbZDUQiW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Apr 2009 12:38:22 -0400
Received: from hera.kernel.org ([140.211.167.34]:40123 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755588AbZDUQiQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Apr 2009 12:38:16 -0400
From: Tejun Heo <tj@kernel.org>
To: axboe@kernel.dk, linux-kernel@vger.kernel.org, bzolnier@gmail.com
Cc: Tejun Heo <tj@kernel.org>
Subject: [PATCH 10/14] block: move rq->start_time initialization to blk_rq_init()
Date: Wed, 22 Apr 2009 01:37:57 +0900
Message-Id: <1240331881-28218-11-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.6.0.2
In-Reply-To: <1240331881-28218-1-git-send-email-tj@kernel.org>
References: <1240331881-28218-1-git-send-email-tj@kernel.org>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Tue, 21 Apr 2009 16:38:13 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

rq->start_time was initialized in init_request_from_bio() so special
requests didn't have start_time set.  This has been okay as start_time
has been used only for fs requests; however, there is no indication of
this actually is the case or not.  Set rq->start_time in blk_rq_init()
and guarantee that all initialized rq's have its start_time set.  This
improves consistency at virtually no cost and future changes will make
use of the timestamp for !bio requests.

[ Impact: rq->start_time is valid for all requests ]

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 block/blk-core.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/block/blk-core.c b/block/blk-core.c
index 274888b..4b39e9e 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -134,6 +134,7 @@ void blk_rq_init(struct request_queue *q, struct request *rq)
 	rq->cmd_len = BLK_MAX_CDB;
 	rq->tag = -1;
 	rq->ref_count = 1;
+	rq->start_time = jiffies;
 }
 EXPORT_SYMBOL(blk_rq_init);
 
@@ -1097,7 +1098,6 @@ void init_request_from_bio(struct request *req, struct bio *bio)
 	req->errors = 0;
 	req->hard_sector = req->sector = bio->bi_sector;
 	req->ioprio = bio_prio(bio);
-	req->start_time = jiffies;
 	blk_rq_bio_prep(req->q, req, bio);
 }
 
-- 
1.6.0.2

