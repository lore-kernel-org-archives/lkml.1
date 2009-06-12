Return-Path: <linux-kernel-owner+w=401wt.eu-S1757967AbZFLMyj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757967AbZFLMyj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jun 2009 08:54:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756351AbZFLMyT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Jun 2009 08:54:19 -0400
Received: from brick.kernel.dk ([93.163.65.50]:52255 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751912AbZFLMyS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jun 2009 08:54:18 -0400
From: Jens Axboe <jens.axboe@oracle.com>
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Cc: chris.mason@oracle.com, david@fromorbit.com, hch@infradead.org,
       akpm@linux-foundation.org, jack@suse.cz, yanmin_zhang@linux.intel.com,
       richard@rsk.demon.co.uk, damien.wyart@free.fr, dedekind1@gmail.com,
       fweisbec@gmail.com, Jens Axboe <jens.axboe@oracle.com>
Subject: [PATCH 01/15] block: don't overwrite bdi->state after bdi_init() has been run
Date: Fri, 12 Jun 2009 14:54:01 +0200
Message-Id: <1244811255-5391-2-git-send-email-jens.axboe@oracle.com>
X-Mailer: git-send-email 1.6.3.rc0.1.gf800
In-Reply-To: <1244811255-5391-1-git-send-email-jens.axboe@oracle.com>
References: <1244811255-5391-1-git-send-email-jens.axboe@oracle.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Move the defaults to where we do the init of the backing_dev_info.

Signed-off-by: Jens Axboe <jens.axboe@oracle.com>
---
 block/blk-core.c     |    5 +++++
 block/blk-settings.c |    4 ----
 2 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/block/blk-core.c b/block/blk-core.c
index f6452f6..94d88fa 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -498,6 +498,11 @@ struct request_queue *blk_alloc_queue_node(gfp_t gfp_mask, int node_id)
 
 	q->backing_dev_info.unplug_io_fn = blk_backing_dev_unplug;
 	q->backing_dev_info.unplug_io_data = q;
+	q->backing_dev_info.ra_pages =
+			(VM_MAX_READAHEAD * 1024) / PAGE_CACHE_SIZE;
+	q->backing_dev_info.state = 0;
+	q->backing_dev_info.capabilities = BDI_CAP_MAP_COPY;
+
 	err = bdi_init(&q->backing_dev_info);
 	if (err) {
 		kmem_cache_free(blk_requestq_cachep, q);
diff --git a/block/blk-settings.c b/block/blk-settings.c
index d71cedc..138610b 100644
--- a/block/blk-settings.c
+++ b/block/blk-settings.c
@@ -129,10 +129,6 @@ void blk_queue_make_request(struct request_queue *q, make_request_fn *mfn)
 	blk_queue_max_segment_size(q, MAX_SEGMENT_SIZE);
 
 	q->make_request_fn = mfn;
-	q->backing_dev_info.ra_pages =
-			(VM_MAX_READAHEAD * 1024) / PAGE_CACHE_SIZE;
-	q->backing_dev_info.state = 0;
-	q->backing_dev_info.capabilities = BDI_CAP_MAP_COPY;
 	blk_queue_max_sectors(q, SAFE_MAX_SECTORS);
 	blk_queue_logical_block_size(q, 512);
 	blk_queue_dma_alignment(q, 511);
-- 
1.6.3.rc0.1.gf800

