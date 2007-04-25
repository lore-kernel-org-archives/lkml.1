Return-Path: <linux-kernel-owner+w=401wt.eu-S1423352AbXDYRyW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423352AbXDYRyW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2007 13:54:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423351AbXDYRyW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Apr 2007 13:54:22 -0400
Received: from brick.kernel.dk ([80.160.20.94]:21366 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1423352AbXDYRyV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2007 13:54:21 -0400
Date: Wed, 25 Apr 2007 19:50:47 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Alan.Brunelle@pobox.com
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 5/15] cfq-iosched: speed up rbtree handling
Message-ID: <20070425175047.GF4730@kernel.dk>
References: <11774025432481-git-send-email-jens.axboe@oracle.com> <11774025432403-git-send-email-jens.axboe@oracle.com> <462F7AD9.8020300@hp.com> <20070425171539.GE4730@kernel.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070425171539.GE4730@kernel.dk>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 25 2007, Jens Axboe wrote:
> On Wed, Apr 25 2007, Alan D. Brunelle wrote:
> > Hi Jens -
> > 
> > The attached patch speeds it up even more - I'm finding a >9% reduction 
> > in %system with no loss in IO performance. This just sets the cached 
> > element when the first is looked for.
> 
> Interesting, good thinking. It should not change the IO pattern, as the
> end result should be the same. Thanks Alan, will commit!
> 
> I'll give elevator.c the same treatment, should be even more beneficial.
> Stay tuned for a test patch.

Something like this, totally untested (it compiles). I initially wanted
to fold the cfq addon into the elevator.h provided implementation, but
that requires more extensive changes. Given how little code it is, I
think I'll keep them seperate.

diff --git a/block/as-iosched.c b/block/as-iosched.c
index ef12627..37c6fb3 100644
--- a/block/as-iosched.c
+++ b/block/as-iosched.c
@@ -89,7 +89,7 @@ struct as_data {
 	/*
 	 * requests (as_rq s) are present on both sort_list and fifo_list
 	 */
-	struct rb_root sort_list[2];
+	struct blk_rb_root sort_list[2];
 	struct list_head fifo_list[2];
 
 	struct request *next_rq[2];	/* next in sort order */
@@ -369,9 +369,9 @@ as_find_next_rq(struct as_data *ad, struct request *last)
 	else {
 		const int data_dir = rq_is_sync(last);
 
-		rbnext = rb_first(&ad->sort_list[data_dir]);
-		if (rbnext && rbnext != &last->rb_node)
-			next = rb_entry_rq(rbnext);
+		next = elv_rb_first(&ad->sort_list[data_dir]);
+		if (next == last)
+			next = NULL;
 	}
 
 	return as_choose_req(ad, next, prev);
@@ -1057,7 +1057,7 @@ static int as_dispatch_request(request_queue_t *q, int force)
 	 */
 
 	if (reads) {
-		BUG_ON(RB_EMPTY_ROOT(&ad->sort_list[REQ_SYNC]));
+		BUG_ON(BLK_RB_EMPTY_ROOT(&ad->sort_list[REQ_SYNC]));
 
 		if (writes && ad->batch_data_dir == REQ_SYNC)
 			/*
@@ -1081,7 +1081,7 @@ static int as_dispatch_request(request_queue_t *q, int force)
 
 	if (writes) {
 dispatch_writes:
-		BUG_ON(RB_EMPTY_ROOT(&ad->sort_list[REQ_ASYNC]));
+		BUG_ON(BLK_RB_EMPTY_ROOT(&ad->sort_list[REQ_ASYNC]));
 
 		if (ad->batch_data_dir == REQ_SYNC) {
 			ad->changed_batch = 1;
@@ -1337,8 +1337,8 @@ static void *as_init_queue(request_queue_t *q)
 
 	INIT_LIST_HEAD(&ad->fifo_list[REQ_SYNC]);
 	INIT_LIST_HEAD(&ad->fifo_list[REQ_ASYNC]);
-	ad->sort_list[REQ_SYNC] = RB_ROOT;
-	ad->sort_list[REQ_ASYNC] = RB_ROOT;
+	ad->sort_list[REQ_SYNC] = BLK_RB_ROOT;
+	ad->sort_list[REQ_ASYNC] = BLK_RB_ROOT;
 	ad->fifo_expire[REQ_SYNC] = default_read_expire;
 	ad->fifo_expire[REQ_ASYNC] = default_write_expire;
 	ad->antic_expire = default_antic_expire;
diff --git a/block/cfq-iosched.c b/block/cfq-iosched.c
index 7a18f31..f3020aa 100644
--- a/block/cfq-iosched.c
+++ b/block/cfq-iosched.c
@@ -127,7 +127,7 @@ struct cfq_queue {
 	/* service_tree key */
 	unsigned long rb_key;
 	/* sorted list of pending requests */
-	struct rb_root sort_list;
+	struct blk_rb_root sort_list;
 	/* if fifo isn't expired, next request to serve */
 	struct request *next_rq;
 	/* requests queued in sort_list */
@@ -419,9 +419,9 @@ cfq_find_next_rq(struct cfq_data *cfqd, struct cfq_queue *cfqq,
 	if (rbnext)
 		next = rb_entry_rq(rbnext);
 	else {
-		rbnext = rb_first(&cfqq->sort_list);
-		if (rbnext && rbnext != &last->rb_node)
-			next = rb_entry_rq(rbnext);
+		next = elv_rb_first(&cfqq->sort_list);
+		if (next == last)
+			next = NULL;
 	}
 
 	return cfq_choose_req(cfqd, next, prev);
@@ -564,7 +564,7 @@ static inline void cfq_del_rq_rb(struct request *rq)
 
 	elv_rb_del(&cfqq->sort_list, rq);
 
-	if (cfq_cfqq_on_rr(cfqq) && RB_EMPTY_ROOT(&cfqq->sort_list))
+	if (cfq_cfqq_on_rr(cfqq) && BLK_RB_EMPTY_ROOT(&cfqq->sort_list))
 		cfq_del_cfqq_rr(cfqd, cfqq);
 }
 
@@ -871,7 +871,7 @@ static void cfq_arm_slice_timer(struct cfq_data *cfqd)
 	struct cfq_io_context *cic;
 	unsigned long sl;
 
-	WARN_ON(!RB_EMPTY_ROOT(&cfqq->sort_list));
+	WARN_ON(!BLK_RB_EMPTY_ROOT(&cfqq->sort_list));
 	WARN_ON(cfq_cfqq_slice_new(cfqq));
 
 	/*
@@ -983,7 +983,7 @@ static struct cfq_queue *cfq_select_queue(struct cfq_data *cfqd)
 	 * The active queue has requests and isn't expired, allow it to
 	 * dispatch.
 	 */
-	if (!RB_EMPTY_ROOT(&cfqq->sort_list))
+	if (!BLK_RB_EMPTY_ROOT(&cfqq->sort_list))
 		goto keep_queue;
 
 	/*
@@ -1015,7 +1015,7 @@ __cfq_dispatch_requests(struct cfq_data *cfqd, struct cfq_queue *cfqq,
 {
 	int dispatched = 0;
 
-	BUG_ON(RB_EMPTY_ROOT(&cfqq->sort_list));
+	BUG_ON(BLK_RB_EMPTY_ROOT(&cfqq->sort_list));
 
 	do {
 		struct request *rq;
@@ -1038,7 +1038,7 @@ __cfq_dispatch_requests(struct cfq_data *cfqd, struct cfq_queue *cfqq,
 			cfqd->active_cic = RQ_CIC(rq);
 		}
 
-		if (RB_EMPTY_ROOT(&cfqq->sort_list))
+		if (BLK_RB_EMPTY_ROOT(&cfqq->sort_list))
 			break;
 
 	} while (dispatched < max_dispatch);
@@ -1147,7 +1147,7 @@ static void cfq_put_queue(struct cfq_queue *cfqq)
 	if (!atomic_dec_and_test(&cfqq->ref))
 		return;
 
-	BUG_ON(rb_first(&cfqq->sort_list));
+	BUG_ON(elv_rb_first(&cfqq->sort_list));
 	BUG_ON(cfqq->allocated[READ] + cfqq->allocated[WRITE]);
 	BUG_ON(cfq_cfqq_on_rr(cfqq));
 
@@ -1385,6 +1385,7 @@ retry:
 
 		memset(cfqq, 0, sizeof(*cfqq));
 
+		cfqq->sort_list = BLK_RB_ROOT;
 		RB_CLEAR_NODE(&cfqq->rb_node);
 		INIT_LIST_HEAD(&cfqq->fifo);
 
@@ -1783,7 +1784,7 @@ static void cfq_completed_request(request_queue_t *q, struct request *rq)
 		}
 		if (cfq_slice_used(cfqq))
 			cfq_slice_expired(cfqd, 1);
-		else if (sync && RB_EMPTY_ROOT(&cfqq->sort_list))
+		else if (sync && BLK_RB_EMPTY_ROOT(&cfqq->sort_list))
 			cfq_arm_slice_timer(cfqd);
 	}
 
@@ -1973,7 +1974,7 @@ static void cfq_idle_slice_timer(unsigned long data)
 		/*
 		 * not expired and it has a request pending, let it dispatch
 		 */
-		if (!RB_EMPTY_ROOT(&cfqq->sort_list)) {
+		if (!BLK_RB_EMPTY_ROOT(&cfqq->sort_list)) {
 			cfq_mark_cfqq_must_dispatch(cfqq);
 			goto out_kick;
 		}
diff --git a/block/deadline-iosched.c b/block/deadline-iosched.c
index 6d673e9..8db8709 100644
--- a/block/deadline-iosched.c
+++ b/block/deadline-iosched.c
@@ -31,7 +31,7 @@ struct deadline_data {
 	/*
 	 * requests (deadline_rq s) are present on both sort_list and fifo_list
 	 */
-	struct rb_root sort_list[2];	
+	struct blk_rb_root sort_list[2];	
 	struct list_head fifo_list[2];
 	
 	/*
@@ -58,11 +58,10 @@ static void deadline_move_request(struct deadline_data *, struct request *);
 static void
 deadline_add_rq_rb(struct deadline_data *dd, struct request *rq)
 {
-	struct rb_root *root = RQ_RB_ROOT(dd, rq);
 	struct request *__alias;
 
 retry:
-	__alias = elv_rb_add(root, rq);
+	__alias = elv_rb_add(RQ_RB_ROOT(dd, rq), rq);
 	if (unlikely(__alias)) {
 		deadline_move_request(dd, __alias);
 		goto retry;
@@ -270,7 +269,7 @@ static int deadline_dispatch_requests(request_queue_t *q, int force)
 	 */
 
 	if (reads) {
-		BUG_ON(RB_EMPTY_ROOT(&dd->sort_list[READ]));
+		BUG_ON(BLK_RB_EMPTY_ROOT(&dd->sort_list[READ]));
 
 		if (writes && (dd->starved++ >= dd->writes_starved))
 			goto dispatch_writes;
@@ -286,7 +285,7 @@ static int deadline_dispatch_requests(request_queue_t *q, int force)
 
 	if (writes) {
 dispatch_writes:
-		BUG_ON(RB_EMPTY_ROOT(&dd->sort_list[WRITE]));
+		BUG_ON(BLK_RB_EMPTY_ROOT(&dd->sort_list[WRITE]));
 
 		dd->starved = 0;
 
@@ -313,16 +312,13 @@ dispatch_find_request:
 		 */
 		rq = dd->next_rq[data_dir];
 	} else {
-		struct rb_node *node;
 		/*
 		 * The last req was the other direction or we have run out of
 		 * higher-sectored requests. Go back to the lowest sectored
 		 * request (1 way elevator) and start a new batch.
 		 */
 		dd->batching = 0;
-		node = rb_first(&dd->sort_list[data_dir]);
-		if (node)
-			rq = rb_entry_rq(node);
+		rq = elv_rb_first(&dd->sort_list[data_dir]);
 	}
 
 dispatch_request:
@@ -367,8 +363,8 @@ static void *deadline_init_queue(request_queue_t *q)
 
 	INIT_LIST_HEAD(&dd->fifo_list[READ]);
 	INIT_LIST_HEAD(&dd->fifo_list[WRITE]);
-	dd->sort_list[READ] = RB_ROOT;
-	dd->sort_list[WRITE] = RB_ROOT;
+	dd->sort_list[READ] = BLK_RB_ROOT;
+	dd->sort_list[WRITE] = BLK_RB_ROOT;
 	dd->fifo_expire[READ] = read_expire;
 	dd->fifo_expire[WRITE] = write_expire;
 	dd->writes_starved = writes_starved;
diff --git a/block/elevator.c b/block/elevator.c
index 96a00c8..8f1c287 100644
--- a/block/elevator.c
+++ b/block/elevator.c
@@ -336,11 +336,12 @@ static struct request *elv_rqhash_find(request_queue_t *q, sector_t offset)
  * RB-tree support functions for inserting/lookup/removal of requests
  * in a sorted RB tree.
  */
-struct request *elv_rb_add(struct rb_root *root, struct request *rq)
+struct request *elv_rb_add(struct blk_rb_root *root, struct request *rq)
 {
-	struct rb_node **p = &root->rb_node;
+	struct rb_node **p = &root->tree.rb_node;
 	struct rb_node *parent = NULL;
 	struct request *__rq;
+	int left = 1;
 
 	while (*p) {
 		parent = *p;
@@ -348,31 +349,38 @@ struct request *elv_rb_add(struct rb_root *root, struct request *rq)
 
 		if (rq->sector < __rq->sector)
 			p = &(*p)->rb_left;
-		else if (rq->sector > __rq->sector)
+		else if (rq->sector > __rq->sector) {
 			p = &(*p)->rb_right;
-		else
+			left = 0;
+		} else
 			return __rq;
 	}
 
+	if (left)
+		root->left = &rq->rb_node;
+
 	rb_link_node(&rq->rb_node, parent, p);
-	rb_insert_color(&rq->rb_node, root);
+	rb_insert_color(&rq->rb_node, &root->tree);
 	return NULL;
 }
 
 EXPORT_SYMBOL(elv_rb_add);
 
-void elv_rb_del(struct rb_root *root, struct request *rq)
+void elv_rb_del(struct blk_rb_root *root, struct request *rq)
 {
+	if (root->left == &rq->rb_node)
+		root->left = NULL;
+
 	BUG_ON(RB_EMPTY_NODE(&rq->rb_node));
-	rb_erase(&rq->rb_node, root);
+	rb_erase(&rq->rb_node, &root->tree);
 	RB_CLEAR_NODE(&rq->rb_node);
 }
 
 EXPORT_SYMBOL(elv_rb_del);
 
-struct request *elv_rb_find(struct rb_root *root, sector_t sector)
+struct request *elv_rb_find(struct blk_rb_root *root, sector_t sector)
 {
-	struct rb_node *n = root->rb_node;
+	struct rb_node *n = root->tree.rb_node;
 	struct request *rq;
 
 	while (n) {
@@ -391,6 +399,18 @@ struct request *elv_rb_find(struct rb_root *root, sector_t sector)
 
 EXPORT_SYMBOL(elv_rb_find);
 
+struct request *elv_rb_first(struct blk_rb_root *root)
+{
+	if (!root->left)
+		root->left = rb_first(&root->tree);
+	if (root->left)
+		return rb_entry_rq(root->left);
+
+	return NULL;
+}
+
+EXPORT_SYMBOL(elv_rb_first);
+
 /*
  * Insert rq into dispatch queue of q.  Queue lock must be held on
  * entry.  rq is sort insted into the dispatch queue. To be used by
diff --git a/include/linux/elevator.h b/include/linux/elevator.h
index e88fcbc..28cc010 100644
--- a/include/linux/elevator.h
+++ b/include/linux/elevator.h
@@ -139,11 +139,22 @@ extern struct request *elv_rb_former_request(request_queue_t *, struct request *
 extern struct request *elv_rb_latter_request(request_queue_t *, struct request *);
 
 /*
- * rb support functions.
+ * rb support functions below. we have a private rb_root setup where we
+ * cache the leftmost node in the tree, for fastest min element retrieval.
+ * this is the main purpose of the rbtree (sort and min extraction).
  */
-extern struct request *elv_rb_add(struct rb_root *, struct request *);
-extern void elv_rb_del(struct rb_root *, struct request *);
-extern struct request *elv_rb_find(struct rb_root *, sector_t);
+struct blk_rb_root {
+	struct rb_root tree;
+	struct rb_node *left;
+};
+
+#define BLK_RB_ROOT	(struct blk_rb_root) { RB_ROOT, NULL, }
+#define BLK_RB_EMPTY_ROOT(root)	RB_EMPTY_ROOT(&((root)->tree))
+
+extern struct request *elv_rb_add(struct blk_rb_root *, struct request *);
+extern void elv_rb_del(struct blk_rb_root *, struct request *);
+extern struct request *elv_rb_find(struct blk_rb_root *, sector_t);
+extern struct request *elv_rb_first(struct blk_rb_root *);
 
 /*
  * Return values from elevator merger

-- 
Jens Axboe

