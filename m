Return-Path: <linux-kernel-owner+w=401wt.eu-S1753380AbZEYHbY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753380AbZEYHbY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 May 2009 03:31:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752129AbZEYHbL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 May 2009 03:31:11 -0400
Received: from brick.kernel.dk ([93.163.65.50]:38632 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752015AbZEYHbK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 May 2009 03:31:10 -0400
From: Jens Axboe <jens.axboe@oracle.com>
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Cc: chris.mason@oracle.com, david@fromorbit.com, hch@infradead.org,
       akpm@linux-foundation.org, jack@suse.cz, yanmin_zhang@linux.intel.com,
       Jens Axboe <jens.axboe@oracle.com>
Subject: [PATCH 02/13] block: add static rq allocation cache
Date: Mon, 25 May 2009 09:30:46 +0200
Message-Id: <1243236668-3398-4-git-send-email-jens.axboe@oracle.com>
X-Mailer: git-send-email 1.6.3.rc0.1.gf800
In-Reply-To: <1243236668-3398-1-git-send-email-jens.axboe@oracle.com>
References: <1243236668-3398-1-git-send-email-jens.axboe@oracle.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Normally a request is allocated through mempool, which means that
we do a slab allocation for each request. To check whether this
slows us down for high iops rates, add a sysfs file that allows
the user to setup a preallocated request cache to avoid going into
slab for each request.

Typically, you'd setup a cache for the full depth of the device.
This defaults to 128, so by doing:

	echo 128 > /sys/block/sda/queue/rq_cache

you would turn this feature on for sda. Writing "0" to the file
will turn it back off.

Signed-off-by: Jens Axboe <jens.axboe@oracle.com>
---
 block/blk-core.c       |   43 ++++++++++++++++++++++++++-
 block/blk-sysfs.c      |   74 ++++++++++++++++++++++++++++++++++++++++++++++++
 include/linux/blkdev.h |    5 +++
 3 files changed, 120 insertions(+), 2 deletions(-)

diff --git a/block/blk-core.c b/block/blk-core.c
index c89883b..fe1eca4 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -635,17 +635,56 @@ int blk_get_queue(struct request_queue *q)
 	return 1;
 }
 
+static struct request *blk_rq_cache_alloc(struct request_queue *q)
+{
+	int tag;
+
+	do {
+		if (q->rq_cache_last != -1) {
+			tag = q->rq_cache_last;
+			q->rq_cache_last = -1;
+		} else {
+			tag = find_first_zero_bit(q->rq_cache_map,
+							q->rq_cache_sz);
+		}
+		if (tag >= q->rq_cache_sz)
+			return NULL;
+	} while (test_and_set_bit_lock(tag, q->rq_cache_map));
+
+	return &q->rq_cache[tag];
+}
+
+static int blk_rq_cache_free(struct request_queue *q, struct request *rq)
+{
+	if (!q->rq_cache)
+		return 1;
+	if (rq >= &q->rq_cache[0] && rq <= &q->rq_cache[q->rq_cache_sz - 1]) {
+		unsigned long idx = rq - q->rq_cache;
+
+		clear_bit(idx, q->rq_cache_map);
+		q->rq_cache_last = idx;
+		return 0;
+	}
+
+	return 1;
+}
+
 static inline void blk_free_request(struct request_queue *q, struct request *rq)
 {
 	if (rq->cmd_flags & REQ_ELVPRIV)
 		elv_put_request(q, rq);
-	mempool_free(rq, q->rq.rq_pool);
+	if (blk_rq_cache_free(q, rq))
+		mempool_free(rq, q->rq.rq_pool);
 }
 
 static struct request *
 blk_alloc_request(struct request_queue *q, int flags, int priv, gfp_t gfp_mask)
 {
-	struct request *rq = mempool_alloc(q->rq.rq_pool, gfp_mask);
+	struct request *rq;
+
+	rq = blk_rq_cache_alloc(q);
+	if (!rq)
+		rq = mempool_alloc(q->rq.rq_pool, gfp_mask);
 
 	if (!rq)
 		return NULL;
diff --git a/block/blk-sysfs.c b/block/blk-sysfs.c
index 3ff9bba..c2d8a71 100644
--- a/block/blk-sysfs.c
+++ b/block/blk-sysfs.c
@@ -218,6 +218,68 @@ static ssize_t queue_iostats_store(struct request_queue *q, const char *page,
 	return ret;
 }
 
+static ssize_t queue_rq_cache_show(struct request_queue *q, char *page)
+{
+	return queue_var_show(q->rq_cache_sz, page);
+}
+
+static ssize_t
+queue_rq_cache_store(struct request_queue *q, const char *page, size_t count)
+{
+	unsigned long *rq_cache_map = NULL;
+	struct request *rq_cache = NULL;
+	unsigned long val;
+	ssize_t ret;
+
+	/*
+	 * alloc cache up front
+	 */
+	ret = queue_var_store(&val, page, count);
+	if (val) {
+		unsigned int map_sz;
+
+		if (val > q->nr_requests)
+			val = q->nr_requests;
+
+		rq_cache = kcalloc(val, sizeof(*rq_cache), GFP_KERNEL);
+		if (!rq_cache)
+			return -ENOMEM;
+
+		map_sz = (val + BITS_PER_LONG - 1) / BITS_PER_LONG;
+		rq_cache_map = kzalloc(map_sz, GFP_KERNEL);
+		if (!rq_cache_map) {
+			kfree(rq_cache);
+			return -ENOMEM;
+		}
+	}
+
+	spin_lock_irq(q->queue_lock);
+	elv_quiesce_start(q);
+
+	/*
+	 * free existing rqcache
+	 */
+	if (q->rq_cache_sz) {
+		kfree(q->rq_cache);
+		kfree(q->rq_cache_map);
+		q->rq_cache = NULL;
+		q->rq_cache_map = NULL;
+		q->rq_cache_sz = 0;
+	}
+
+	if (val) {
+		memset(rq_cache, 0, val * sizeof(struct request));
+		q->rq_cache = rq_cache;
+		q->rq_cache_map = rq_cache_map;
+		q->rq_cache_sz = val;
+		q->rq_cache_last = -1;
+	}
+
+	elv_quiesce_end(q);
+	spin_unlock_irq(q->queue_lock);
+	return ret;
+}
+
 static struct queue_sysfs_entry queue_requests_entry = {
 	.attr = {.name = "nr_requests", .mode = S_IRUGO | S_IWUSR },
 	.show = queue_requests_show,
@@ -276,6 +338,12 @@ static struct queue_sysfs_entry queue_iostats_entry = {
 	.store = queue_iostats_store,
 };
 
+static struct queue_sysfs_entry queue_rqcache_entry = {
+	.attr = {.name = "rq_cache", .mode = S_IRUGO | S_IWUSR },
+	.show = queue_rq_cache_show,
+	.store = queue_rq_cache_store,
+};
+
 static struct attribute *default_attrs[] = {
 	&queue_requests_entry.attr,
 	&queue_ra_entry.attr,
@@ -287,6 +355,7 @@ static struct attribute *default_attrs[] = {
 	&queue_nomerges_entry.attr,
 	&queue_rq_affinity_entry.attr,
 	&queue_iostats_entry.attr,
+	&queue_rqcache_entry.attr,
 	NULL,
 };
 
@@ -363,6 +432,11 @@ static void blk_release_queue(struct kobject *kobj)
 	if (q->queue_tags)
 		__blk_queue_free_tags(q);
 
+	if (q->rq_cache) {
+		kfree(q->rq_cache);
+		kfree(q->rq_cache_map);
+	}
+
 	blk_trace_shutdown(q);
 
 	bdi_destroy(&q->backing_dev_info);
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index b4f71f1..c00f050 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -444,6 +444,11 @@ struct request_queue
 	struct bsg_class_device bsg_dev;
 #endif
 	struct blk_cmd_filter cmd_filter;
+
+	struct request *rq_cache;
+	unsigned int rq_cache_sz;
+	unsigned int rq_cache_last;
+	unsigned long *rq_cache_map;
 };
 
 #define QUEUE_FLAG_CLUSTER	0	/* cluster several segments into 1 */
-- 
1.6.3.rc0.1.gf800

