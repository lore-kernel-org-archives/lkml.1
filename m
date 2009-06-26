Return-Path: <linux-kernel-owner+w=401wt.eu-S1758669AbZFZJGO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758669AbZFZJGO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jun 2009 05:06:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758266AbZFZJFX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Jun 2009 05:05:23 -0400
Received: from brick.kernel.dk ([93.163.65.50]:42918 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758256AbZFZJFT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jun 2009 05:05:19 -0400
From: Jens Axboe <jens.axboe@oracle.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, Jens Axboe <jens.axboe@oracle.com>
Subject: [PATCH 2/2] cfq-iosched: get rid of the need for __GFP_FAIL in cfq_find_alloc_queue()
Date: Fri, 26 Jun 2009 11:05:20 +0200
Message-Id: <1246007120-24034-3-git-send-email-jens.axboe@oracle.com>
X-Mailer: git-send-email 1.6.3
In-Reply-To: <1246007120-24034-1-git-send-email-jens.axboe@oracle.com>
References: <1246007120-24034-1-git-send-email-jens.axboe@oracle.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Setup an emergency fallback cfqq that we allocate at IO scheduler init
time. If the slab allocation fails in cfq_find_alloc_queue(), we'll just
punt IO to that cfqq instead. This ensures that cfq_find_alloc_queue()
never fails without having to ensure free memory.

Signed-off-by: Jens Axboe <jens.axboe@oracle.com>
---
 block/cfq-iosched.c |  124 +++++++++++++++++++++++++++-----------------------
 1 files changed, 67 insertions(+), 57 deletions(-)

diff --git a/block/cfq-iosched.c b/block/cfq-iosched.c
index c760ae7..91e7e0b 100644
--- a/block/cfq-iosched.c
+++ b/block/cfq-iosched.c
@@ -71,6 +71,51 @@ struct cfq_rb_root {
 #define CFQ_RB_ROOT	(struct cfq_rb_root) { RB_ROOT, NULL, }
 
 /*
+ * Per process-grouping structure
+ */
+struct cfq_queue {
+	/* reference count */
+	atomic_t ref;
+	/* various state flags, see below */
+	unsigned int flags;
+	/* parent cfq_data */
+	struct cfq_data *cfqd;
+	/* service_tree member */
+	struct rb_node rb_node;
+	/* service_tree key */
+	unsigned long rb_key;
+	/* prio tree member */
+	struct rb_node p_node;
+	/* prio tree root we belong to, if any */
+	struct rb_root *p_root;
+	/* sorted list of pending requests */
+	struct rb_root sort_list;
+	/* if fifo isn't expired, next request to serve */
+	struct request *next_rq;
+	/* requests queued in sort_list */
+	int queued[2];
+	/* currently allocated requests */
+	int allocated[2];
+	/* fifo list of requests in sort_list */
+	struct list_head fifo;
+
+	unsigned long slice_end;
+	long slice_resid;
+	unsigned int slice_dispatch;
+
+	/* pending metadata requests */
+	int meta_pending;
+	/* number of requests that are on the dispatch list or inside driver */
+	int dispatched;
+
+	/* io prio of this group */
+	unsigned short ioprio, org_ioprio;
+	unsigned short ioprio_class, org_ioprio_class;
+
+	pid_t pid;
+};
+
+/*
  * Per block device queue structure
  */
 struct cfq_data {
@@ -135,51 +180,11 @@ struct cfq_data {
 	unsigned int cfq_slice_idle;
 
 	struct list_head cic_list;
-};
 
-/*
- * Per process-grouping structure
- */
-struct cfq_queue {
-	/* reference count */
-	atomic_t ref;
-	/* various state flags, see below */
-	unsigned int flags;
-	/* parent cfq_data */
-	struct cfq_data *cfqd;
-	/* service_tree member */
-	struct rb_node rb_node;
-	/* service_tree key */
-	unsigned long rb_key;
-	/* prio tree member */
-	struct rb_node p_node;
-	/* prio tree root we belong to, if any */
-	struct rb_root *p_root;
-	/* sorted list of pending requests */
-	struct rb_root sort_list;
-	/* if fifo isn't expired, next request to serve */
-	struct request *next_rq;
-	/* requests queued in sort_list */
-	int queued[2];
-	/* currently allocated requests */
-	int allocated[2];
-	/* fifo list of requests in sort_list */
-	struct list_head fifo;
-
-	unsigned long slice_end;
-	long slice_resid;
-	unsigned int slice_dispatch;
-
-	/* pending metadata requests */
-	int meta_pending;
-	/* number of requests that are on the dispatch list or inside driver */
-	int dispatched;
-
-	/* io prio of this group */
-	unsigned short ioprio, org_ioprio;
-	unsigned short ioprio_class, org_ioprio_class;
-
-	pid_t pid;
+	/*
+	 * Fallback dummy cfqq for extreme OOM conditions
+	 */
+	struct cfq_queue oom_cfqq;
 };
 
 enum cfqq_state_flags {
@@ -1686,28 +1691,28 @@ retry:
 			 */
 			spin_unlock_irq(cfqd->queue->queue_lock);
 			new_cfqq = kmem_cache_alloc_node(cfq_pool,
-					gfp_mask | __GFP_NOFAIL | __GFP_ZERO,
+					gfp_mask | __GFP_ZERO,
 					cfqd->queue->node);
 			spin_lock_irq(cfqd->queue->queue_lock);
-			goto retry;
+			if (new_cfqq)
+				goto retry;
 		} else {
 			cfqq = kmem_cache_alloc_node(cfq_pool,
 					gfp_mask | __GFP_ZERO,
 					cfqd->queue->node);
-			if (!cfqq)
-				goto out;
 		}
 
-		cfq_init_cfqq(cfqd, cfqq, current->pid, is_sync);
-		cfq_init_prio_data(cfqq, ioc);
-		cfq_log_cfqq(cfqd, cfqq, "alloced");
+		if (cfqq) {
+			cfq_init_cfqq(cfqd, cfqq, current->pid, is_sync);
+			cfq_init_prio_data(cfqq, ioc);
+			cfq_log_cfqq(cfqd, cfqq, "alloced");
+		} else
+			cfqq = &cfqd->oom_cfqq;
 	}
 
 	if (new_cfqq)
 		kmem_cache_free(cfq_pool, new_cfqq);
 
-out:
-	WARN_ON((gfp_mask & __GFP_WAIT) && !cfqq);
 	return cfqq;
 }
 
@@ -1740,11 +1745,8 @@ cfq_get_queue(struct cfq_data *cfqd, int is_sync, struct io_context *ioc,
 		cfqq = *async_cfqq;
 	}
 
-	if (!cfqq) {
+	if (!cfqq)
 		cfqq = cfq_find_alloc_queue(cfqd, is_sync, ioc, gfp_mask);
-		if (!cfqq)
-			return NULL;
-	}
 
 	/*
 	 * pin the queue now that it's allocated, scheduler exit will prune it
@@ -2470,6 +2472,14 @@ static void *cfq_init_queue(struct request_queue *q)
 	for (i = 0; i < CFQ_PRIO_LISTS; i++)
 		cfqd->prio_trees[i] = RB_ROOT;
 
+	/*
+	 * Our fallback cfqq if cfq_find_alloc_queue() runs into OOM issues.
+	 * Grab a permanent reference to it, so that the normal code flow
+	 * will not attempt to free it.
+	 */
+	cfq_init_cfqq(cfqd, &cfqd->oom_cfqq, 1, 0);
+	atomic_inc(&cfqd->oom_cfqq.ref);
+
 	INIT_LIST_HEAD(&cfqd->cic_list);
 
 	cfqd->queue = q;
-- 
1.6.3.2.306.g4f4fa

