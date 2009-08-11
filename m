Return-Path: <linux-kernel-owner+w=401wt.eu-S1752300AbZHKL5I@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752300AbZHKL5I (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Aug 2009 07:57:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752251AbZHKL5G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Aug 2009 07:57:06 -0400
Received: from cantor.suse.de ([195.135.220.2]:37433 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751204AbZHKLyb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Aug 2009 07:54:31 -0400
From: Nikanth Karthikesan <knikanth@suse.de>
Organization: suse.de
To: Jens Axboe <jens.axboe@oracle.com>
Subject: [PATCH-v3 1/2] Allow delaying initialization of queue after allocation
Date: Tue, 11 Aug 2009 15:02:36 +0530
User-Agent: KMail/1.11.1 (Linux/2.6.27.23-0.1-default; KDE/4.2.1; x86_64; ; )
Cc: Mike Snitzer <snitzer@redhat.com>, Alasdair G Kergon <agk@redhat.com>,
       Kiyoshi Ueda <k-ueda@ct.jp.nec.com>, dm-devel@redhat.com,
       linux-kernel@vger.kernel.org, Hannes Reinecke <hare@suse.de>
References: <200908081025.58865.knikanth@suse.de> <200908101551.08605.knikanth@suse.de> <200908101618.18085.knikanth@suse.de>
In-Reply-To: <200908101618.18085.knikanth@suse.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200908111502.36570.knikanth@suse.de>
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

This slightly changes the behaviour of block_init_queue_node() such that
blk_put_queue() would be called, even if blk_init_free_list() fails.

Also export elevator_register_queue() to modules.

Signed-off-by: Nikanth Karthikesan <knikanth@suse.de>

---

diff --git a/block/blk-core.c b/block/blk-core.c
index e3299a7..8b05b3b 100644
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
+							spinlock_t *lock)
+{
+	int err = 0;
+
+	err = blk_init_free_list(q);
+	if (err)
+		goto out;
+
 	q->request_fn		= rfn;
 	q->prep_rq_fn		= NULL;
 	q->unplug_fn		= generic_unplug_device;
@@ -591,15 +606,23 @@ blk_init_queue_node(request_fn_proc *rfn, spinlock_t *lock, int node_id)
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
+	/*
+	 * Cleanup mempool allocated by blk_init_free_list
+	 */
+	mempool_destroy(q->rq.rq_pool);
+out:
+	return err;
 }
-EXPORT_SYMBOL(blk_init_queue_node);
+EXPORT_SYMBOL(blk_init_allocated_queue);
 
 int blk_get_queue(struct request_queue *q)
 {
diff --git a/block/elevator.c b/block/elevator.c
index 2d511f9..0827cd3 100644
--- a/block/elevator.c
+++ b/block/elevator.c
@@ -930,6 +930,7 @@ int elv_register_queue(struct request_queue *q)
 	}
 	return error;
 }
+EXPORT_SYMBOL(elv_register_queue);
 
 static void __elv_unregister_queue(struct elevator_queue *e)
 {
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index 69103e0..4a26fc1 100644
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

