Return-Path: <linux-kernel-owner+w=401wt.eu-S1758248AbZDFMuJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758248AbZDFMuJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Apr 2009 08:50:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755118AbZDFMsT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Apr 2009 08:48:19 -0400
Received: from brick.kernel.dk ([93.163.65.50]:50496 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754906AbZDFMsQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Apr 2009 08:48:16 -0400
From: Jens Axboe <jens.axboe@oracle.com>
To: linux-kernel@vger.kernel.org
Cc: tytso@mit.edu, torvalds@linux-foundation.org,
       Jens Axboe <jens.axboe@oracle.com>
Subject: [PATCH 6/8] block: enabling plugging on SSD devices that don't do queuing
Date: Mon,  6 Apr 2009 14:48:06 +0200
Message-Id: <1239022088-29002-7-git-send-email-jens.axboe@oracle.com>
X-Mailer: git-send-email 1.6.2.1.423.g442d
In-Reply-To: <1239022088-29002-1-git-send-email-jens.axboe@oracle.com>
References: <1239022088-29002-1-git-send-email-jens.axboe@oracle.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For the older SSD devices that don't do command queuing, we do want to
enable plugging to get better merging.

Signed-off-by: Jens Axboe <jens.axboe@oracle.com>
---
 block/blk-core.c |   13 +++++++++++--
 1 files changed, 11 insertions(+), 2 deletions(-)

diff --git a/block/blk-core.c b/block/blk-core.c
index a32b571..c4198f0 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -1136,6 +1136,15 @@ void init_request_from_bio(struct request *req, struct bio *bio)
 	blk_rq_bio_prep(req->q, req, bio);
 }
 
+/*
+ * Only disabling plugging for non-rotational devices if it does tagging
+ * as well, otherwise we do need the proper merging
+ */
+static inline bool queue_should_plug(struct request_queue *q)
+{
+	return !(blk_queue_nonrot(q) && blk_queue_tagged(q));
+}
+
 static int __make_request(struct request_queue *q, struct bio *bio)
 {
 	struct request *req;
@@ -1242,11 +1251,11 @@ get_rq:
 	if (test_bit(QUEUE_FLAG_SAME_COMP, &q->queue_flags) ||
 	    bio_flagged(bio, BIO_CPU_AFFINE))
 		req->cpu = blk_cpu_to_group(smp_processor_id());
-	if (!blk_queue_nonrot(q) && elv_queue_empty(q))
+	if (queue_should_plug(q) && elv_queue_empty(q))
 		blk_plug_device(q);
 	add_request(q, req);
 out:
-	if (unplug || blk_queue_nonrot(q))
+	if (unplug || !queue_should_plug(q))
 		__generic_unplug_device(q);
 	spin_unlock_irq(q->queue_lock);
 	return 0;
-- 
1.6.2.1.423.g442d

