Return-Path: <linux-kernel-owner+w=401wt.eu-S1752715AbZKCXoe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752715AbZKCXoe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Nov 2009 18:44:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752101AbZKCXod
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Nov 2009 18:44:33 -0500
Received: from mx1.redhat.com ([209.132.183.28]:29552 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752644AbZKCXob (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Nov 2009 18:44:31 -0500
From: Vivek Goyal <vgoyal@redhat.com>
To: linux-kernel@vger.kernel.org, jens.axboe@oracle.com
Cc: nauman@google.com, dpshah@google.com, lizf@cn.fujitsu.com,
       ryov@valinux.co.jp, fernando@oss.ntt.co.jp, s-uchida@ap.jp.nec.com,
       taka@valinux.co.jp, guijianfeng@cn.fujitsu.com, jmoyer@redhat.com,
       balbir@linux.vnet.ibm.com, righi.andrea@gmail.com,
       m-ikeda@ds.jp.nec.com, vgoyal@redhat.com, akpm@linux-foundation.org,
       riel@redhat.com, kamezawa.hiroyu@jp.fujitsu.com
Subject: [PATCH 02/20] blkio: Change CFQ to use CFS like queue time stamps
Date: Tue,  3 Nov 2009 18:43:39 -0500
Message-Id: <1257291837-6246-3-git-send-email-vgoyal@redhat.com>
In-Reply-To: <1257291837-6246-1-git-send-email-vgoyal@redhat.com>
References: <1257291837-6246-1-git-send-email-vgoyal@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

o Currently CFQ provides priority scaled time slices to processes. If a process
  does not use the time slice, either because process did not have sufficient
  IO to do or because think time of process is large and CFQ decided to disable
  idling, then processes looses it time slice share.

o This works well in flat setup where fair share of a process can be achieved
  in one go (by scaled time slices), and CFQ does not have to time stamp the
  queue. But once IO groups are introduced, it does not work very well.
  Consider following case.

			root
			/ \
		      G1  G2
		      |    |
		     T1    T2

  Here G1 and G2 are two groups of weights 100 each and T1 and T2 are two
  tasks of prio 0 and 4 each. Now both groups should get 50% of disk time.
  CFQ assigns slice length of 180ms to T1 (prio 0) and slice length of 100ms
  to T2 (prio4). Now plain round robin of scaled slices does not work at
  group level.

o One possible way to handle this is implement CFS like time stamping of the
  cfq queues and keep track of vtime. Next queue for execution will be selected
  based on the one who got lowest vtime. This patch implemented time stamping
  mechanism of cfq queues based on disk time used.

o min_vdisktime represents the minimum vdisktime of the queue, either being
  serviced or leftmost element on the serviec tree.

o Previously CFQ had one service tree where queues of all theree prio classes
  were being queued. One side affect of this time stamping approach is that
  now single tree approach might not work and we need to keep separate service
  trees for three prio classes.

o Some parts of code of this patch are taken from CFS and BFQ.

Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
---
 block/cfq-iosched.c |  480 +++++++++++++++++++++++++++++++++++----------------
 1 files changed, 335 insertions(+), 145 deletions(-)

diff --git a/block/cfq-iosched.c b/block/cfq-iosched.c
index 069a610..58ac8b7 100644
--- a/block/cfq-iosched.c
+++ b/block/cfq-iosched.c
@@ -28,6 +28,8 @@ static int cfq_slice_async = HZ / 25;
 static const int cfq_slice_async_rq = 2;
 static int cfq_slice_idle = HZ / 125;
 
+#define IO_IOPRIO_CLASSES	3
+
 /*
  * offset from end of service tree
  */
@@ -64,11 +66,17 @@ static DEFINE_SPINLOCK(ioc_gone_lock);
  * to find it. Idea borrowed from Ingo Molnars CFS scheduler. We should
  * move this into the elevator for the rq sorting as well.
  */
-struct cfq_rb_root {
+struct cfq_service_tree {
 	struct rb_root rb;
 	struct rb_node *left;
+	u64 min_vdisktime;
+	struct cfq_queue *active;
+};
+#define CFQ_RB_ROOT	(struct cfq_service_tree) { RB_ROOT, NULL, 0, NULL}
+
+struct cfq_sched_data {
+	struct cfq_service_tree service_tree[IO_IOPRIO_CLASSES];
 };
-#define CFQ_RB_ROOT	(struct cfq_rb_root) { RB_ROOT, NULL, }
 
 /*
  * Per process-grouping structure
@@ -83,7 +91,9 @@ struct cfq_queue {
 	/* service_tree member */
 	struct rb_node rb_node;
 	/* service_tree key */
-	unsigned long rb_key;
+	u64 vdisktime;
+	/* service tree we belong to */
+	struct cfq_service_tree *st;
 	/* prio tree member */
 	struct rb_node p_node;
 	/* prio tree root we belong to, if any */
@@ -99,8 +109,9 @@ struct cfq_queue {
 	/* fifo list of requests in sort_list */
 	struct list_head fifo;
 
+	/* time when first request from queue completed and slice started. */
+	unsigned long slice_start;
 	unsigned long slice_end;
-	long slice_resid;
 	unsigned int slice_dispatch;
 
 	/* pending metadata requests */
@@ -111,6 +122,7 @@ struct cfq_queue {
 	/* io prio of this group */
 	unsigned short ioprio, org_ioprio;
 	unsigned short ioprio_class, org_ioprio_class;
+	bool ioprio_class_changed;
 
 	pid_t pid;
 };
@@ -124,7 +136,7 @@ struct cfq_data {
 	/*
 	 * rr list of queues with requests and the count of them
 	 */
-	struct cfq_rb_root service_tree;
+	struct cfq_sched_data sched_data;
 
 	/*
 	 * Each priority tree is sorted by next_request position.  These
@@ -234,6 +246,67 @@ static struct cfq_queue *cfq_get_queue(struct cfq_data *, bool,
 				       struct io_context *, gfp_t);
 static struct cfq_io_context *cfq_cic_lookup(struct cfq_data *,
 						struct io_context *);
+static void cfq_put_queue(struct cfq_queue *cfqq);
+static struct cfq_queue *__cfq_get_next_queue(struct cfq_service_tree *st);
+
+static inline void
+init_cfqq_service_tree(struct cfq_data *cfqd, struct cfq_queue *cfqq)
+{
+	unsigned short idx = cfqq->ioprio_class - 1;
+
+	BUG_ON(idx >= IO_IOPRIO_CLASSES);
+
+	cfqq->st = &cfqd->sched_data.service_tree[idx];
+}
+
+static inline s64
+cfqq_key(struct cfq_service_tree *st, struct cfq_queue *cfqq)
+{
+	return cfqq->vdisktime - st->min_vdisktime;
+}
+
+static inline u64
+cfq_delta_fair(unsigned long delta, struct cfq_queue *cfqq)
+{
+	const int base_slice = cfqq->cfqd->cfq_slice[cfq_cfqq_sync(cfqq)];
+
+	return delta + (base_slice/CFQ_SLICE_SCALE * (cfqq->ioprio - 4));
+}
+
+static inline u64 max_vdisktime(u64 min_vdisktime, u64 vdisktime)
+{
+	s64 delta = (s64)(vdisktime - min_vdisktime);
+	if (delta > 0)
+		min_vdisktime = vdisktime;
+
+	return min_vdisktime;
+}
+
+static inline u64 min_vdisktime(u64 min_vdisktime, u64 vdisktime)
+{
+	s64 delta = (s64)(vdisktime - min_vdisktime);
+	if (delta < 0)
+		min_vdisktime = vdisktime;
+
+	return min_vdisktime;
+}
+
+static void update_min_vdisktime(struct cfq_service_tree *st)
+{
+	u64 vdisktime = st->min_vdisktime;
+
+	if (st->active)
+		vdisktime = st->active->vdisktime;
+
+	if (st->left) {
+		struct cfq_queue *cfqq = rb_entry(st->left, struct cfq_queue,
+							rb_node);
+
+		vdisktime = min_vdisktime(vdisktime, cfqq->vdisktime);
+	}
+
+	st->min_vdisktime = max_vdisktime(st->min_vdisktime, vdisktime);
+}
 
 static inline int rq_in_driver(struct cfq_data *cfqd)
 {
@@ -277,7 +350,7 @@ static int cfq_queue_empty(struct request_queue *q)
 {
 	struct cfq_data *cfqd = q->elevator->elevator_data;
 
-	return !cfqd->busy_queues;
+	return !cfqd->rq_queued;
 }
 
 /*
@@ -304,6 +377,7 @@ cfq_prio_to_slice(struct cfq_data *cfqd, struct cfq_queue *cfqq)
 static inline void
 cfq_set_prio_slice(struct cfq_data *cfqd, struct cfq_queue *cfqq)
 {
+	cfqq->slice_start = jiffies;
 	cfqq->slice_end = cfq_prio_to_slice(cfqd, cfqq) + jiffies;
 	cfq_log_cfqq(cfqd, cfqq, "set_slice=%lu", cfqq->slice_end - jiffies);
 }
@@ -419,33 +493,6 @@ cfq_choose_req(struct cfq_data *cfqd, struct request *rq1, struct request *rq2)
 }
 
 /*
- * The below is leftmost cache rbtree addon
- */
-static struct cfq_queue *cfq_rb_first(struct cfq_rb_root *root)
-{
-	if (!root->left)
-		root->left = rb_first(&root->rb);
-
-	if (root->left)
-		return rb_entry(root->left, struct cfq_queue, rb_node);
-
-	return NULL;
-}
-
-static void rb_erase_init(struct rb_node *n, struct rb_root *root)
-{
-	rb_erase(n, root);
-	RB_CLEAR_NODE(n);
-}
-
-static void cfq_rb_erase(struct rb_node *n, struct cfq_rb_root *root)
-{
-	if (root->left == n)
-		root->left = NULL;
-	rb_erase_init(n, &root->rb);
-}
-
-/*
  * would be nice to take fifo expire time into account as well
  */
 static struct request *
@@ -472,102 +519,192 @@ cfq_find_next_rq(struct cfq_data *cfqd, struct cfq_queue *cfqq,
 	return cfq_choose_req(cfqd, next, prev);
 }
 
-static unsigned long cfq_slice_offset(struct cfq_data *cfqd,
-				      struct cfq_queue *cfqq)
-{
-	/*
-	 * just an approximation, should be ok.
-	 */
-	return (cfqd->busy_queues - 1) * (cfq_prio_slice(cfqd, 1, 0) -
-		       cfq_prio_slice(cfqd, cfq_cfqq_sync(cfqq), cfqq->ioprio));
-}
-
-/*
- * The cfqd->service_tree holds all pending cfq_queue's that have
- * requests waiting to be processed. It is sorted in the order that
- * we will service the queues.
- */
-static void cfq_service_tree_add(struct cfq_data *cfqd, struct cfq_queue *cfqq,
-				 bool add_front)
+static void
+place_cfqq(struct cfq_service_tree *st, struct cfq_queue *cfqq, int add_front)
 {
-	struct rb_node **p, *parent;
+	u64 vdisktime = st->min_vdisktime;
+	struct rb_node *parent;
 	struct cfq_queue *__cfqq;
-	unsigned long rb_key;
-	int left;
 
 	if (cfq_class_idle(cfqq)) {
-		rb_key = CFQ_IDLE_DELAY;
-		parent = rb_last(&cfqd->service_tree.rb);
+		vdisktime = CFQ_IDLE_DELAY;
+		parent = rb_last(&st->rb);
 		if (parent && parent != &cfqq->rb_node) {
 			__cfqq = rb_entry(parent, struct cfq_queue, rb_node);
-			rb_key += __cfqq->rb_key;
+			vdisktime += __cfqq->vdisktime;
 		} else
-			rb_key += jiffies;
+			vdisktime += st->min_vdisktime;
 	} else if (!add_front) {
-		/*
-		 * Get our rb key offset. Subtract any residual slice
-		 * value carried from last service. A negative resid
-		 * count indicates slice overrun, and this should position
-		 * the next service time further away in the tree.
-		 */
-		rb_key = cfq_slice_offset(cfqd, cfqq) + jiffies;
-		rb_key -= cfqq->slice_resid;
-		cfqq->slice_resid = 0;
-	} else {
-		rb_key = -HZ;
-		__cfqq = cfq_rb_first(&cfqd->service_tree);
-		rb_key += __cfqq ? __cfqq->rb_key : jiffies;
+		parent = rb_last(&st->rb);
+		if (parent && parent != &cfqq->rb_node) {
+			__cfqq = rb_entry(parent, struct cfq_queue, rb_node);
+			vdisktime = __cfqq->vdisktime;
+		}
 	}
 
-	if (!RB_EMPTY_NODE(&cfqq->rb_node)) {
+	cfqq->vdisktime = max_vdisktime(st->min_vdisktime, vdisktime);
+}
+
+static inline void cfqq_update_ioprio_class(struct cfq_queue *cfqq)
+{
+	if (unlikely(cfqq->ioprio_class_changed)) {
+		struct cfq_data *cfqd = cfqq->cfqd;
+
 		/*
-		 * same position, nothing more to do
+		 * Re-initialize the service tree pointer as ioprio class
+		 * change will lead to service tree change.
 		 */
-		if (rb_key == cfqq->rb_key)
-			return;
-
-		cfq_rb_erase(&cfqq->rb_node, &cfqd->service_tree);
+		init_cfqq_service_tree(cfqd, cfqq);
+		cfqq->ioprio_class_changed = 0;
+		cfqq->vdisktime = 0;
 	}
+}
 
-	left = 1;
-	parent = NULL;
-	p = &cfqd->service_tree.rb.rb_node;
-	while (*p) {
-		struct rb_node **n;
+static void __dequeue_cfqq(struct cfq_service_tree *st, struct cfq_queue *cfqq)
+{
+	/* Node is not on tree */
+	if (RB_EMPTY_NODE(&cfqq->rb_node))
+		return;
 
-		parent = *p;
+	if (st->left == &cfqq->rb_node)
+		st->left = rb_next(&cfqq->rb_node);
+
+	rb_erase(&cfqq->rb_node, &st->rb);
+	RB_CLEAR_NODE(&cfqq->rb_node);
+}
+
+static void dequeue_cfqq(struct cfq_queue *cfqq)
+{
+	struct cfq_service_tree *st = cfqq->st;
+
+	if (st->active == cfqq)
+		st->active = NULL;
+
+	__dequeue_cfqq(st, cfqq);
+}
+
+static void __enqueue_cfqq(struct cfq_service_tree *st, struct cfq_queue *cfqq,
+				 int add_front)
+{
+	struct rb_node **node = &st->rb.rb_node;
+	struct rb_node *parent = NULL;
+	struct cfq_queue *__cfqq;
+	s64 key = cfqq_key(st, cfqq);
+	int leftmost = 1;
+
+	while (*node != NULL) {
+		parent = *node;
 		__cfqq = rb_entry(parent, struct cfq_queue, rb_node);
 
-		/*
-		 * sort RT queues first, we always want to give
-		 * preference to them. IDLE queues goes to the back.
-		 * after that, sort on the next service time.
-		 */
-		if (cfq_class_rt(cfqq) > cfq_class_rt(__cfqq))
-			n = &(*p)->rb_left;
-		else if (cfq_class_rt(cfqq) < cfq_class_rt(__cfqq))
-			n = &(*p)->rb_right;
-		else if (cfq_class_idle(cfqq) < cfq_class_idle(__cfqq))
-			n = &(*p)->rb_left;
-		else if (cfq_class_idle(cfqq) > cfq_class_idle(__cfqq))
-			n = &(*p)->rb_right;
-		else if (time_before(rb_key, __cfqq->rb_key))
-			n = &(*p)->rb_left;
-		else
-			n = &(*p)->rb_right;
+		if (key < cfqq_key(st, __cfqq) ||
+			(add_front && (key == cfqq_key(st, __cfqq)))) {
+			node = &parent->rb_left;
+		} else {
+			node = &parent->rb_right;
+			leftmost = 0;
+		}
+	}
+
+	/*
+	 * Maintain a cache of leftmost tree entries (it is frequently
+	 * used)
+	 */
+	if (leftmost)
+		st->left = &cfqq->rb_node;
 
-		if (n == &(*p)->rb_right)
-			left = 0;
+	rb_link_node(&cfqq->rb_node, parent, node);
+	rb_insert_color(&cfqq->rb_node, &st->rb);
+}
 
-		p = n;
+static void enqueue_cfqq(struct cfq_queue *cfqq)
+{
+	cfqq_update_ioprio_class(cfqq);
+	place_cfqq(cfqq->st, cfqq, 0);
+	__enqueue_cfqq(cfqq->st, cfqq, 0);
+}
+
+/* Requeue a cfqq which is already on the service tree */
+static void requeue_cfqq(struct cfq_queue *cfqq, int add_front)
+{
+	struct cfq_service_tree *st = cfqq->st;
+	struct cfq_queue *next_cfqq;
+
+	if (add_front) {
+		next_cfqq = __cfq_get_next_queue(st);
+		if (next_cfqq && next_cfqq == cfqq)
+			return;
+	}
+
+	__dequeue_cfqq(st, cfqq);
+	place_cfqq(st, cfqq, add_front);
+	__enqueue_cfqq(st, cfqq, add_front);
+}
+
+static void __cfqq_served(struct cfq_queue *cfqq, unsigned long served)
+{
+	/*
+	 * Can't update entity disk time while it is on sorted rb-tree
+	 * as vdisktime is used as key.
+	 */
+	__dequeue_cfqq(cfqq->st, cfqq);
+	cfqq->vdisktime += cfq_delta_fair(served, cfqq);
+	update_min_vdisktime(cfqq->st);
+	__enqueue_cfqq(cfqq->st, cfqq, 0);
+}
+
+static void cfqq_served(struct cfq_queue *cfqq, unsigned long served)
+{
+	/*
+	 * We don't want to charge more than allocated slice otherwise this
+	 * queue can miss one dispatch round doubling max latencies. On the
+	 * other hand we don't want to charge less than allocated slice as
+	 * we stick to CFQ theme of queue loosing its share if it does not
+	 * use the slice and moves to the back of service tree (almost).
+	 */
+	served = cfq_prio_to_slice(cfqq->cfqd, cfqq);
+	__cfqq_served(cfqq, served);
+
+	/* If cfqq prio class has changed, take that into account */
+	if (unlikely(cfqq->ioprio_class_changed)) {
+		dequeue_cfqq(cfqq);
+		enqueue_cfqq(cfqq);
 	}
+}
+
+/*
+ * Handles three operations.
+ * Addition of a new queue to service tree, when a new request comes in.
+ * Resorting of an expiring queue (used after slice expired)
+ * Requeuing a queue at the front (used during preemption).
+ */
+static void cfq_service_tree_add(struct cfq_data *cfqd, struct cfq_queue *cfqq,
+				bool add_front, unsigned long service)
+{
+	if (RB_EMPTY_NODE(&cfqq->rb_node)) {
+		/* Its a new queue. Add it to service tree */
+		enqueue_cfqq(cfqq);
+		return;
+	}
+
+	if (service) {
+		/*
+		 * This queue just got served. Compute the new key and requeue
+		 * in the service tree
+		 */
+		cfqq_served(cfqq, service);
 
-	if (left)
-		cfqd->service_tree.left = &cfqq->rb_node;
+		/*
+		 * Requeue async ioq so that these will be again placed at the
+		 * end of service tree giving a chance to sync queues.
+		 * TODO: Handle this case in a better manner.
+		 */
+		if (!cfq_cfqq_sync(cfqq))
+			requeue_cfqq(cfqq, 0);
+		return;
+	}
 
-	cfqq->rb_key = rb_key;
-	rb_link_node(&cfqq->rb_node, parent, p);
-	rb_insert_color(&cfqq->rb_node, &cfqd->service_tree.rb);
+	/* Just requeuing an existing queue, used during preemption */
+	requeue_cfqq(cfqq, add_front);
 }
 
 static struct cfq_queue *
@@ -634,13 +771,14 @@ static void cfq_prio_tree_add(struct cfq_data *cfqd, struct cfq_queue *cfqq)
 /*
  * Update cfqq's position in the service tree.
  */
-static void cfq_resort_rr_list(struct cfq_data *cfqd, struct cfq_queue *cfqq)
+static void cfq_resort_rr_list(struct cfq_data *cfqd, struct cfq_queue *cfqq,
+				unsigned long service)
 {
 	/*
 	 * Resorting requires the cfqq to be on the RR list already.
 	 */
 	if (cfq_cfqq_on_rr(cfqq)) {
-		cfq_service_tree_add(cfqd, cfqq, 0);
+		cfq_service_tree_add(cfqd, cfqq, 0, service);
 		cfq_prio_tree_add(cfqd, cfqq);
 	}
 }
@@ -656,7 +794,7 @@ static void cfq_add_cfqq_rr(struct cfq_data *cfqd, struct cfq_queue *cfqq)
 	cfq_mark_cfqq_on_rr(cfqq);
 	cfqd->busy_queues++;
 
-	cfq_resort_rr_list(cfqd, cfqq);
+	cfq_resort_rr_list(cfqd, cfqq, 0);
 }
 
 /*
@@ -669,8 +807,7 @@ static void cfq_del_cfqq_rr(struct cfq_data *cfqd, struct cfq_queue *cfqq)
 	BUG_ON(!cfq_cfqq_on_rr(cfqq));
 	cfq_clear_cfqq_on_rr(cfqq);
 
-	if (!RB_EMPTY_NODE(&cfqq->rb_node))
-		cfq_rb_erase(&cfqq->rb_node, &cfqd->service_tree);
+	dequeue_cfqq(cfqq);
 	if (cfqq->p_root) {
 		rb_erase(&cfqq->p_node, cfqq->p_root);
 		cfqq->p_root = NULL;
@@ -686,7 +823,6 @@ static void cfq_del_cfqq_rr(struct cfq_data *cfqd, struct cfq_queue *cfqq)
 static void cfq_del_rq_rb(struct request *rq)
 {
 	struct cfq_queue *cfqq = RQ_CFQQ(rq);
-	struct cfq_data *cfqd = cfqq->cfqd;
 	const int sync = rq_is_sync(rq);
 
 	BUG_ON(!cfqq->queued[sync]);
@@ -694,8 +830,17 @@ static void cfq_del_rq_rb(struct request *rq)
 
 	elv_rb_del(&cfqq->sort_list, rq);
 
-	if (cfq_cfqq_on_rr(cfqq) && RB_EMPTY_ROOT(&cfqq->sort_list))
-		cfq_del_cfqq_rr(cfqd, cfqq);
+	if (cfq_cfqq_on_rr(cfqq) && RB_EMPTY_ROOT(&cfqq->sort_list)) {
+		/*
+		 * Queue will be deleted from service tree when we actually
+		 * expire it later. Right now just remove it from prio tree
+		 * as it is empty.
+		 */
+		if (cfqq->p_root) {
+			rb_erase(&cfqq->p_node, cfqq->p_root);
+			cfqq->p_root = NULL;
+		}
+	}
 }
 
 static void cfq_add_rq_rb(struct request *rq)
@@ -869,6 +1014,7 @@ static void __cfq_set_active_queue(struct cfq_data *cfqd,
 {
 	if (cfqq) {
 		cfq_log_cfqq(cfqd, cfqq, "set_active");
+		cfqq->slice_start = 0;
 		cfqq->slice_end = 0;
 		cfqq->slice_dispatch = 0;
 
@@ -888,10 +1034,11 @@ static void __cfq_set_active_queue(struct cfq_data *cfqd,
  * current cfqq expired its slice (or was too idle), select new one
  */
 static void
-__cfq_slice_expired(struct cfq_data *cfqd, struct cfq_queue *cfqq,
-		    bool timed_out)
+__cfq_slice_expired(struct cfq_data *cfqd, struct cfq_queue *cfqq)
 {
-	cfq_log_cfqq(cfqd, cfqq, "slice expired t=%d", timed_out);
+	long slice_used = 0;
+
+	cfq_log_cfqq(cfqd, cfqq, "slice expired");
 
 	if (cfq_cfqq_wait_request(cfqq))
 		del_timer(&cfqd->idle_slice_timer);
@@ -899,14 +1046,20 @@ __cfq_slice_expired(struct cfq_data *cfqd, struct cfq_queue *cfqq,
 	cfq_clear_cfqq_wait_request(cfqq);
 
 	/*
-	 * store what was left of this slice, if the queue idled/timed out
+	 * Queue got expired before even a single request completed or
+	 * got expired immediately after first request completion.
 	 */
-	if (timed_out && !cfq_cfqq_slice_new(cfqq)) {
-		cfqq->slice_resid = cfqq->slice_end - jiffies;
-		cfq_log_cfqq(cfqd, cfqq, "resid=%ld", cfqq->slice_resid);
-	}
+	if (!cfqq->slice_end || cfqq->slice_start == jiffies)
+		slice_used = 1;
+	else
+		slice_used = jiffies - cfqq->slice_start;
 
-	cfq_resort_rr_list(cfqd, cfqq);
+	cfq_log_cfqq(cfqd, cfqq, "sl_used=%ld", slice_used);
+
+	if (cfq_cfqq_on_rr(cfqq) && RB_EMPTY_ROOT(&cfqq->sort_list))
+		cfq_del_cfqq_rr(cfqd, cfqq);
+
+	cfq_resort_rr_list(cfqd, cfqq, slice_used);
 
 	if (cfqq == cfqd->active_queue)
 		cfqd->active_queue = NULL;
@@ -917,12 +1070,22 @@ __cfq_slice_expired(struct cfq_data *cfqd, struct cfq_queue *cfqq,
 	}
 }
 
-static inline void cfq_slice_expired(struct cfq_data *cfqd, bool timed_out)
+static inline void cfq_slice_expired(struct cfq_data *cfqd)
 {
 	struct cfq_queue *cfqq = cfqd->active_queue;
 
 	if (cfqq)
-		__cfq_slice_expired(cfqd, cfqq, timed_out);
+		__cfq_slice_expired(cfqd, cfqq);
+}
+
+static struct cfq_queue *__cfq_get_next_queue(struct cfq_service_tree *st)
+{
+	struct rb_node *left = st->left;
+
+	if (!left)
+		return NULL;
+
+	return rb_entry(left, struct cfq_queue, rb_node);
 }
 
 /*
@@ -931,10 +1094,24 @@ static inline void cfq_slice_expired(struct cfq_data *cfqd, bool timed_out)
  */
 static struct cfq_queue *cfq_get_next_queue(struct cfq_data *cfqd)
 {
-	if (RB_EMPTY_ROOT(&cfqd->service_tree.rb))
+	struct cfq_sched_data *sd = &cfqd->sched_data;
+	struct cfq_service_tree *st = sd->service_tree;
+	struct cfq_queue *cfqq = NULL;
+	int i;
+
+	if (!cfqd->rq_queued)
 		return NULL;
 
-	return cfq_rb_first(&cfqd->service_tree);
+	for (i = 0; i < IO_IOPRIO_CLASSES; i++, st++) {
+		cfqq = __cfq_get_next_queue(st);
+		if (cfqq) {
+			st->active = cfqq;
+			update_min_vdisktime(cfqq->st);
+			break;
+		}
+	}
+
+	return cfqq;
 }
 
 /*
@@ -1181,6 +1358,9 @@ static struct cfq_queue *cfq_select_queue(struct cfq_data *cfqd)
 	if (!cfqq)
 		goto new_queue;
 
+	if (!cfqd->rq_queued)
+		return NULL;
+
 	/*
 	 * The active queue has run out of time, expire it and select new.
 	 */
@@ -1216,7 +1396,7 @@ static struct cfq_queue *cfq_select_queue(struct cfq_data *cfqd)
 	}
 
 expire:
-	cfq_slice_expired(cfqd, 0);
+	cfq_slice_expired(cfqd);
 new_queue:
 	cfqq = cfq_set_active_queue(cfqd, new_cfqq);
 keep_queue:
@@ -1233,6 +1413,10 @@ static int __cfq_forced_dispatch_cfqq(struct cfq_queue *cfqq)
 	}
 
 	BUG_ON(!list_empty(&cfqq->fifo));
+
+	/* By default cfqq is not expired if it is empty. Do it explicitly */
+	__cfq_slice_expired(cfqq->cfqd, cfqq);
+
 	return dispatched;
 }
 
@@ -1245,10 +1429,10 @@ static int cfq_forced_dispatch(struct cfq_data *cfqd)
 	struct cfq_queue *cfqq;
 	int dispatched = 0;
 
-	while ((cfqq = cfq_rb_first(&cfqd->service_tree)) != NULL)
+	while ((cfqq = cfq_get_next_queue(cfqd)) != NULL)
 		dispatched += __cfq_forced_dispatch_cfqq(cfqq);
 
-	cfq_slice_expired(cfqd, 0);
+	cfq_slice_expired(cfqd);
 
 	BUG_ON(cfqd->busy_queues);
 
@@ -1391,7 +1575,7 @@ static int cfq_dispatch_requests(struct request_queue *q, int force)
 	    cfqq->slice_dispatch >= cfq_prio_to_maxrq(cfqd, cfqq)) ||
 	    cfq_class_idle(cfqq))) {
 		cfqq->slice_end = jiffies + 1;
-		cfq_slice_expired(cfqd, 0);
+		cfq_slice_expired(cfqd);
 	}
 
 	cfq_log_cfqq(cfqd, cfqq, "dispatched a request");
@@ -1416,13 +1600,14 @@ static void cfq_put_queue(struct cfq_queue *cfqq)
 	cfq_log_cfqq(cfqd, cfqq, "put_queue");
 	BUG_ON(rb_first(&cfqq->sort_list));
 	BUG_ON(cfqq->allocated[READ] + cfqq->allocated[WRITE]);
-	BUG_ON(cfq_cfqq_on_rr(cfqq));
 
 	if (unlikely(cfqd->active_queue == cfqq)) {
-		__cfq_slice_expired(cfqd, cfqq, 0);
+		__cfq_slice_expired(cfqd, cfqq);
 		cfq_schedule_dispatch(cfqd);
 	}
 
+	BUG_ON(cfq_cfqq_on_rr(cfqq));
+
 	kmem_cache_free(cfq_pool, cfqq);
 }
 
@@ -1514,7 +1699,7 @@ static void cfq_free_io_context(struct io_context *ioc)
 static void cfq_exit_cfqq(struct cfq_data *cfqd, struct cfq_queue *cfqq)
 {
 	if (unlikely(cfqq == cfqd->active_queue)) {
-		__cfq_slice_expired(cfqd, cfqq, 0);
+		__cfq_slice_expired(cfqd, cfqq);
 		cfq_schedule_dispatch(cfqd);
 	}
 
@@ -1634,6 +1819,8 @@ static void cfq_init_prio_data(struct cfq_queue *cfqq, struct io_context *ioc)
 		break;
 	}
 
+	if (cfqq->org_ioprio_class != cfqq->ioprio_class)
+		cfqq->ioprio_class_changed = 1;
 	/*
 	 * keep track of original prio settings in case we have to temporarily
 	 * elevate the priority of this queue
@@ -2079,7 +2266,7 @@ cfq_should_preempt(struct cfq_data *cfqd, struct cfq_queue *new_cfqq,
 static void cfq_preempt_queue(struct cfq_data *cfqd, struct cfq_queue *cfqq)
 {
 	cfq_log_cfqq(cfqd, cfqq, "preempt");
-	cfq_slice_expired(cfqd, 1);
+	cfq_slice_expired(cfqd);
 
 	/*
 	 * Put the new queue at the front of the of the current list,
@@ -2087,7 +2274,7 @@ static void cfq_preempt_queue(struct cfq_data *cfqd, struct cfq_queue *cfqq)
 	 */
 	BUG_ON(!cfq_cfqq_on_rr(cfqq));
 
-	cfq_service_tree_add(cfqd, cfqq, 1);
+	cfq_service_tree_add(cfqd, cfqq, 1, 0);
 
 	cfqq->slice_end = 0;
 	cfq_mark_cfqq_slice_new(cfqq);
@@ -2229,7 +2416,7 @@ static void cfq_completed_request(struct request_queue *q, struct request *rq)
 		 * of idling.
 		 */
 		if (cfq_slice_used(cfqq) || cfq_class_idle(cfqq))
-			cfq_slice_expired(cfqd, 1);
+			cfq_slice_expired(cfqd);
 		else if (cfqq_empty && !cfq_close_cooperator(cfqd, cfqq, 1) &&
 			 sync && !rq_noidle(rq))
 			cfq_arm_slice_timer(cfqd);
@@ -2250,16 +2437,20 @@ static void cfq_prio_boost(struct cfq_queue *cfqq)
 		 * boost idle prio on transactions that would lock out other
 		 * users of the filesystem
 		 */
-		if (cfq_class_idle(cfqq))
+		if (cfq_class_idle(cfqq)) {
 			cfqq->ioprio_class = IOPRIO_CLASS_BE;
+			cfqq->ioprio_class_changed = 1;
+		}
 		if (cfqq->ioprio > IOPRIO_NORM)
 			cfqq->ioprio = IOPRIO_NORM;
 	} else {
 		/*
 		 * check if we need to unboost the queue
 		 */
-		if (cfqq->ioprio_class != cfqq->org_ioprio_class)
+		if (cfqq->ioprio_class != cfqq->org_ioprio_class) {
 			cfqq->ioprio_class = cfqq->org_ioprio_class;
+			cfqq->ioprio_class_changed = 1;
+		}
 		if (cfqq->ioprio != cfqq->org_ioprio)
 			cfqq->ioprio = cfqq->org_ioprio;
 	}
@@ -2391,7 +2582,6 @@ static void cfq_idle_slice_timer(unsigned long data)
 	struct cfq_data *cfqd = (struct cfq_data *) data;
 	struct cfq_queue *cfqq;
 	unsigned long flags;
-	int timed_out = 1;
 
 	cfq_log(cfqd, "idle timer fired");
 
@@ -2399,7 +2589,6 @@ static void cfq_idle_slice_timer(unsigned long data)
 
 	cfqq = cfqd->active_queue;
 	if (cfqq) {
-		timed_out = 0;
 
 		/*
 		 * We saw a request before the queue expired, let it through
@@ -2427,7 +2616,7 @@ static void cfq_idle_slice_timer(unsigned long data)
 			goto out_kick;
 	}
 expire:
-	cfq_slice_expired(cfqd, timed_out);
+	cfq_slice_expired(cfqd);
 out_kick:
 	cfq_schedule_dispatch(cfqd);
 out_cont:
@@ -2465,7 +2654,7 @@ static void cfq_exit_queue(struct elevator_queue *e)
 	spin_lock_irq(q->queue_lock);
 
 	if (cfqd->active_queue)
-		__cfq_slice_expired(cfqd, cfqd->active_queue, 0);
+		__cfq_slice_expired(cfqd, cfqd->active_queue);
 
 	while (!list_empty(&cfqd->cic_list)) {
 		struct cfq_io_context *cic = list_entry(cfqd->cic_list.next,
@@ -2493,7 +2682,8 @@ static void *cfq_init_queue(struct request_queue *q)
 	if (!cfqd)
 		return NULL;
 
-	cfqd->service_tree = CFQ_RB_ROOT;
+	for (i = 0; i < IO_IOPRIO_CLASSES; i++)
+		cfqd->sched_data.service_tree[i] = CFQ_RB_ROOT;
 
 	/*
 	 * Not strictly needed (since RB_ROOT just clears the node and we
-- 
1.6.2.5

