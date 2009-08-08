Return-Path: <linux-kernel-owner+w=401wt.eu-S1751287AbZHHEzJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751287AbZHHEzJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Aug 2009 00:55:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751175AbZHHEyz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 8 Aug 2009 00:54:55 -0400
Received: from cantor2.suse.de ([195.135.220.15]:36219 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751211AbZHHEyi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Aug 2009 00:54:38 -0400
From: Nikanth Karthikesan <knikanth@suse.de>
Organization: suse.de
To: Jens Axboe <jens.axboe@oracle.com>, Alasdair G Kergon <agk@redhat.com>
Subject: [PATCH 1/2] Allow delaying initialization of queue after allocation
Date: Sat, 8 Aug 2009 10:25:58 +0530
User-Agent: KMail/1.11.1 (Linux/2.6.27.23-0.1-default; KDE/4.2.1; x86_64; ; )
Cc: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>, Hannes Reinecke <hare@suse.de>,
       dm-devel@redhat.com, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200908081025.58865.knikanth@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Export a way to delay initializing a request_queue after allocating it. This
is needed by device-mapper devices, as they create the queue on device
creation time, but they decide whether it would use the elevator and requests
only after first successful table load. Only request-based dm-devices use the
elevator and requests. Without this either one needs to initialize and free
the mempool and elevator, if it was a bio-based dm-device or leave it
allocated, as it is currently done.

Signed-off-by: Nikanth Karthikesan <knikanth@suse.de>

---

diff --git a/block/blk-core.c b/block/blk-core.c
index 4b45435..5db0772 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -495,6 +495,8 @@ struct request_queue *blk_alloc_queue_node(gfp_t gfp_mask, int node_id)
 	if (!q)
 		return NULL;
 
+	q->node = node_id;
+
 	q->backing_dev_info.unplug_io_fn = blk_backing_dev_unplug;
 	q->backing_dev_info.unplug_io_data = q;
 	q->backing_dev_info.ra_pages =
@@ -569,12 +571,25 @@ blk_init_queue_node(request_fn_proc *rfn, spinlock_t *lock, int node_id)
 	if (!q)
 		return NULL;
 
-	q->node = node_id;
-	if (blk_init_free_list(q)) {
+	if (blk_init_allocated_queue(q, rfn, lock)) {
+		blk_put_queue(q);
 		kmem_cache_free(blk_requestq_cachep, q);
 		return NULL;
 	}
 
+	return q;
+}
+EXPORT_SYMBOL(blk_init_queue_node);
+
+int blk_init_allocated_queue(struct request_queue *q, request_fn_proc *rfn,
+							 spinlock_t *lock)
+{
+	int err = 0;
+
+	err = blk_init_free_list(q);
+	if (err)
+		goto out;
+
 	/*
 	 * if caller didn't supply a lock, they get per-queue locking with
 	 * our embedded lock
@@ -598,15 +613,20 @@ blk_init_queue_node(request_fn_proc *rfn, spinlock_t *lock, int node_id)
 	/*
 	 * all done
 	 */
-	if (!elevator_init(q, NULL)) {
-		blk_queue_congestion_threshold(q);
-		return q;
-	}
+	err = elevator_init(q, NULL);
+	if (err)
+		goto free_and_out;
 
-	blk_put_queue(q);
-	return NULL;
+	blk_queue_congestion_threshold(q);
+
+	return 0;
+
+free_and_out:
+	mempool_destroy(q->rq.rq_pool);
+out:
+	return err;
 }
-EXPORT_SYMBOL(blk_init_queue_node);
+EXPORT_SYMBOL(blk_init_allocated_queue);
 
 int blk_get_queue(struct request_queue *q)
 {
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index e7cb5db..9552961 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -901,6 +901,8 @@ extern void blk_abort_queue(struct request_queue *);
 extern struct request_queue *blk_init_queue_node(request_fn_proc *rfn,
 					spinlock_t *lock, int node_id);
 extern struct request_queue *blk_init_queue(request_fn_proc *, spinlock_t *);
+extern int blk_init_allocated_queue(struct request_queue *q,
+				request_fn_proc *rfn, spinlock_t *lock);
 extern void blk_cleanup_queue(struct request_queue *);
 extern void blk_queue_make_request(struct request_queue *, make_request_fn *);
 extern void blk_queue_bounce_limit(struct request_queue *, u64);

