Return-Path: <linux-kernel-owner+w=401wt.eu-S1752910AbZKCXpL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752910AbZKCXpL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Nov 2009 18:45:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752863AbZKCXo7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Nov 2009 18:44:59 -0500
Received: from mx1.redhat.com ([209.132.183.28]:30570 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752567AbZKCXoy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Nov 2009 18:44:54 -0500
From: Vivek Goyal <vgoyal@redhat.com>
To: linux-kernel@vger.kernel.org, jens.axboe@oracle.com
Cc: nauman@google.com, dpshah@google.com, lizf@cn.fujitsu.com,
       ryov@valinux.co.jp, fernando@oss.ntt.co.jp, s-uchida@ap.jp.nec.com,
       taka@valinux.co.jp, guijianfeng@cn.fujitsu.com, jmoyer@redhat.com,
       balbir@linux.vnet.ibm.com, righi.andrea@gmail.com,
       m-ikeda@ds.jp.nec.com, vgoyal@redhat.com, akpm@linux-foundation.org,
       riel@redhat.com, kamezawa.hiroyu@jp.fujitsu.com
Subject: [PATCH 04/20] blkio: Introduce the notion of cfq entity
Date: Tue,  3 Nov 2009 18:43:41 -0500
Message-Id: <1257291837-6246-5-git-send-email-vgoyal@redhat.com>
In-Reply-To: <1257291837-6246-1-git-send-email-vgoyal@redhat.com>
References: <1257291837-6246-1-git-send-email-vgoyal@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

o Introduce the notion of cfq entity. This is a common structure which will
  be embedded both in cfq queues as well as cfq groups. This is something like
  scheduling entity of CFS.

o Once groups are introduced it becomes easier to deal with entities while
  enqueuing/dequeuing queues/groups on service tree and we can handle many
  of the operations with single functions dealing in entities instead of
  introducing seprate functions for queues and groups.

Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
---
 block/cfq-iosched.c |  246 +++++++++++++++++++++++++++++----------------------
 1 files changed, 141 insertions(+), 105 deletions(-)

diff --git a/block/cfq-iosched.c b/block/cfq-iosched.c
index ca815ce..922aa8e 100644
--- a/block/cfq-iosched.c
+++ b/block/cfq-iosched.c
@@ -59,8 +59,10 @@ static struct completion *ioc_gone;
 static DEFINE_SPINLOCK(ioc_gone_lock);
 
 #define CFQ_PRIO_LISTS		IOPRIO_BE_NR
-#define cfq_class_idle(cfqq)	((cfqq)->ioprio_class == IOPRIO_CLASS_IDLE)
-#define cfq_class_rt(cfqq)	((cfqq)->ioprio_class == IOPRIO_CLASS_RT)
+#define cfqe_class_idle(cfqe)	((cfqe)->ioprio_class == IOPRIO_CLASS_IDLE)
+#define cfqe_class_rt(cfqe)	((cfqe)->ioprio_class == IOPRIO_CLASS_RT)
+#define cfq_class_idle(cfqq)	(cfqe_class_idle(&(cfqq)->entity))
+#define cfq_class_rt(cfqq)	(cfqe_class_rt(&(cfqq)->entity))
 
 #define sample_valid(samples)	((samples) > 80)
 
@@ -74,7 +76,7 @@ struct cfq_service_tree {
 	struct rb_root rb;
 	struct rb_node *left;
 	u64 min_vdisktime;
-	struct cfq_queue *active;
+	struct cfq_entity *active;
 };
 #define CFQ_RB_ROOT	(struct cfq_service_tree) { RB_ROOT, NULL, 0, NULL}
 
@@ -82,22 +84,26 @@ struct cfq_sched_data {
 	struct cfq_service_tree service_tree[IO_IOPRIO_CLASSES];
 };
 
+struct cfq_entity {
+	struct rb_node rb_node;
+	u64 vdisktime;
+	unsigned int weight;
+	struct cfq_service_tree *st;
+	unsigned short ioprio_class;
+	bool ioprio_class_changed;
+};
+
 /*
  * Per process-grouping structure
  */
 struct cfq_queue {
+	struct cfq_entity entity;
 	/* reference count */
 	atomic_t ref;
 	/* various state flags, see below */
 	unsigned int flags;
 	/* parent cfq_data */
 	struct cfq_data *cfqd;
-	/* service_tree member */
-	struct rb_node rb_node;
-	/* service_tree key */
-	u64 vdisktime;
-	/* service tree we belong to */
-	struct cfq_service_tree *st;
 	/* prio tree member */
 	struct rb_node p_node;
 	/* prio tree root we belong to, if any */
@@ -125,9 +131,7 @@ struct cfq_queue {
 
 	/* io prio of this group */
 	unsigned short ioprio, org_ioprio;
-	unsigned short ioprio_class, org_ioprio_class;
-	bool ioprio_class_changed;
-	unsigned int weight;
+	unsigned short org_ioprio_class;
 
 	pid_t pid;
 };
@@ -252,22 +256,27 @@ static struct cfq_queue *cfq_get_queue(struct cfq_data *, bool,
 static struct cfq_io_context *cfq_cic_lookup(struct cfq_data *,
 						struct io_context *);
 static void cfq_put_queue(struct cfq_queue *cfqq);
-static struct cfq_queue *__cfq_get_next_queue(struct cfq_service_tree *st);
+static struct cfq_entity *__cfq_get_next_entity(struct cfq_service_tree *st);
+
+static inline struct cfq_queue *cfqq_of(struct cfq_entity *cfqe)
+{
+	return container_of(cfqe, struct cfq_queue, entity);
+}
 
 static inline void
-init_cfqq_service_tree(struct cfq_data *cfqd, struct cfq_queue *cfqq)
+init_cfqe_service_tree(struct cfq_data *cfqd, struct cfq_entity *cfqe)
 {
-	unsigned short idx = cfqq->ioprio_class - 1;
+	unsigned short idx = cfqe->ioprio_class - 1;
 
 	BUG_ON(idx >= IO_IOPRIO_CLASSES);
 
-	cfqq->st = &cfqd->sched_data.service_tree[idx];
+	cfqe->st = &cfqd->sched_data.service_tree[idx];
 }
 
 static inline s64
-cfqq_key(struct cfq_service_tree *st, struct cfq_queue *cfqq)
+cfqe_key(struct cfq_service_tree *st, struct cfq_entity *cfqe)
 {
-	return cfqq->vdisktime - st->min_vdisktime;
+	return cfqe->vdisktime - st->min_vdisktime;
 }
 
 static inline u64
@@ -282,11 +291,11 @@ cfq_delta(u64 service, unsigned int numerator_wt, unsigned int denominator_wt)
 }
 
 static inline u64
-cfq_delta_fair(unsigned long delta, struct cfq_queue *cfqq)
+cfq_delta_fair(unsigned long delta, struct cfq_entity *cfqe)
 {
 	u64 d = delta << CFQ_SERVICE_SHIFT;
 
-	return cfq_delta(d, CFQ_WEIGHT_DEFAULT, cfqq->weight);
+	return cfq_delta(d, CFQ_WEIGHT_DEFAULT, cfqe->weight);
 }
 
 static inline u64 max_vdisktime(u64 min_vdisktime, u64 vdisktime)
@@ -315,10 +324,10 @@ static void update_min_vdisktime(struct cfq_service_tree *st)
 		vdisktime = st->active->vdisktime;
 
 	if (st->left) {
-		struct cfq_queue *cfqq = rb_entry(st->left, struct cfq_queue,
+		struct cfq_entity *cfqe = rb_entry(st->left, struct cfq_entity,
 							rb_node);
 
-		vdisktime = min_vdisktime(vdisktime, cfqq->vdisktime);
+		vdisktime = min_vdisktime(vdisktime, cfqe->vdisktime);
 	}
 
 	st->min_vdisktime = max_vdisktime(st->min_vdisktime, vdisktime);
@@ -389,7 +398,7 @@ static int cfq_queue_empty(struct request_queue *q)
 static inline int
 cfq_prio_to_slice(struct cfq_data *cfqd, struct cfq_queue *cfqq)
 {
-	return cfq_weight_slice(cfqd, cfq_cfqq_sync(cfqq), cfqq->weight);
+	return cfq_weight_slice(cfqd, cfq_cfqq_sync(cfqq), cfqq->entity.weight);
 }
 
 static inline void
@@ -538,84 +547,90 @@ cfq_find_next_rq(struct cfq_data *cfqd, struct cfq_queue *cfqq,
 }
 
 static void
-place_cfqq(struct cfq_service_tree *st, struct cfq_queue *cfqq, int add_front)
+place_cfqe(struct cfq_service_tree *st, struct cfq_entity *cfqe, int add_front)
 {
 	u64 vdisktime = st->min_vdisktime;
 	struct rb_node *parent;
-	struct cfq_queue *__cfqq;
+	struct cfq_entity *__cfqe;
 
-	if (cfq_class_idle(cfqq)) {
+	if (cfqe_class_idle(cfqe)) {
 		vdisktime = CFQ_IDLE_DELAY;
 		parent = rb_last(&st->rb);
-		if (parent && parent != &cfqq->rb_node) {
-			__cfqq = rb_entry(parent, struct cfq_queue, rb_node);
-			vdisktime += __cfqq->vdisktime;
+		if (parent && parent != &cfqe->rb_node) {
+			__cfqe = rb_entry(parent, struct cfq_entity, rb_node);
+			vdisktime += __cfqe->vdisktime;
 		} else
 			vdisktime += st->min_vdisktime;
 	} else if (!add_front) {
 		parent = rb_last(&st->rb);
-		if (parent && parent != &cfqq->rb_node) {
-			__cfqq = rb_entry(parent, struct cfq_queue, rb_node);
-			vdisktime = __cfqq->vdisktime;
+		if (parent && parent != &cfqe->rb_node) {
+			__cfqe = rb_entry(parent, struct cfq_entity, rb_node);
+			vdisktime = __cfqe->vdisktime;
 		}
 	}
 
-	cfqq->vdisktime = max_vdisktime(st->min_vdisktime, vdisktime);
+	cfqe->vdisktime = max_vdisktime(st->min_vdisktime, vdisktime);
 }
 
-static inline void cfqq_update_ioprio_class(struct cfq_queue *cfqq)
+static inline void cfqe_update_ioprio_class(struct cfq_entity *cfqe)
 {
-	if (unlikely(cfqq->ioprio_class_changed)) {
+	if (unlikely(cfqe->ioprio_class_changed)) {
+		struct cfq_queue *cfqq = cfqq_of(cfqe);
 		struct cfq_data *cfqd = cfqq->cfqd;
 
 		/*
 		 * Re-initialize the service tree pointer as ioprio class
 		 * change will lead to service tree change.
 		 */
-		init_cfqq_service_tree(cfqd, cfqq);
-		cfqq->ioprio_class_changed = 0;
-		cfqq->vdisktime = 0;
+		init_cfqe_service_tree(cfqd, cfqe);
+		cfqe->ioprio_class_changed = 0;
+		cfqe->vdisktime = 0;
 	}
 }
 
-static void __dequeue_cfqq(struct cfq_service_tree *st, struct cfq_queue *cfqq)
+static void __dequeue_cfqe(struct cfq_service_tree *st, struct cfq_entity *cfqe)
 {
 	/* Node is not on tree */
-	if (RB_EMPTY_NODE(&cfqq->rb_node))
+	if (RB_EMPTY_NODE(&cfqe->rb_node))
 		return;
 
-	if (st->left == &cfqq->rb_node)
-		st->left = rb_next(&cfqq->rb_node);
+	if (st->left == &cfqe->rb_node)
+		st->left = rb_next(&cfqe->rb_node);
 
-	rb_erase(&cfqq->rb_node, &st->rb);
-	RB_CLEAR_NODE(&cfqq->rb_node);
+	rb_erase(&cfqe->rb_node, &st->rb);
+	RB_CLEAR_NODE(&cfqe->rb_node);
 }
 
-static void dequeue_cfqq(struct cfq_queue *cfqq)
+static void dequeue_cfqe(struct cfq_entity *cfqe)
 {
-	struct cfq_service_tree *st = cfqq->st;
+	struct cfq_service_tree *st = cfqe->st;
 
-	if (st->active == cfqq)
+	if (st->active == cfqe)
 		st->active = NULL;
 
-	__dequeue_cfqq(st, cfqq);
+	__dequeue_cfqe(st, cfqe);
 }
 
-static void __enqueue_cfqq(struct cfq_service_tree *st, struct cfq_queue *cfqq,
+static void dequeue_cfqq(struct cfq_queue *cfqq)
+{
+	dequeue_cfqe(&cfqq->entity);
+}
+
+static void __enqueue_cfqe(struct cfq_service_tree *st, struct cfq_entity *cfqe,
 				 int add_front)
 {
 	struct rb_node **node = &st->rb.rb_node;
 	struct rb_node *parent = NULL;
-	struct cfq_queue *__cfqq;
-	s64 key = cfqq_key(st, cfqq);
+	struct cfq_entity *__cfqe;
+	s64 key = cfqe_key(st, cfqe);
 	int leftmost = 1;
 
 	while (*node != NULL) {
 		parent = *node;
-		__cfqq = rb_entry(parent, struct cfq_queue, rb_node);
+		__cfqe = rb_entry(parent, struct cfq_entity, rb_node);
 
-		if (key < cfqq_key(st, __cfqq) ||
-			(add_front && (key == cfqq_key(st, __cfqq)))) {
+		if (key < cfqe_key(st, __cfqe) ||
+			(add_front && (key == cfqe_key(st, __cfqe)))) {
 			node = &parent->rb_left;
 		} else {
 			node = &parent->rb_right;
@@ -628,46 +643,56 @@ static void __enqueue_cfqq(struct cfq_service_tree *st, struct cfq_queue *cfqq,
 	 * used)
 	 */
 	if (leftmost)
-		st->left = &cfqq->rb_node;
+		st->left = &cfqe->rb_node;
+
+	rb_link_node(&cfqe->rb_node, parent, node);
+	rb_insert_color(&cfqe->rb_node, &st->rb);
+}
 
-	rb_link_node(&cfqq->rb_node, parent, node);
-	rb_insert_color(&cfqq->rb_node, &st->rb);
+static void enqueue_cfqe(struct cfq_entity *cfqe)
+{
+	cfqe_update_ioprio_class(cfqe);
+	place_cfqe(cfqe->st, cfqe, 0);
+	__enqueue_cfqe(cfqe->st, cfqe, 0);
 }
 
 static void enqueue_cfqq(struct cfq_queue *cfqq)
 {
-	cfqq_update_ioprio_class(cfqq);
-	place_cfqq(cfqq->st, cfqq, 0);
-	__enqueue_cfqq(cfqq->st, cfqq, 0);
+	enqueue_cfqe(&cfqq->entity);
 }
 
 /* Requeue a cfqq which is already on the service tree */
-static void requeue_cfqq(struct cfq_queue *cfqq, int add_front)
+static void requeue_cfqe(struct cfq_entity *cfqe, int add_front)
 {
-	struct cfq_service_tree *st = cfqq->st;
-	struct cfq_queue *next_cfqq;
+	struct cfq_service_tree *st = cfqe->st;
+	struct cfq_entity *next_cfqe;
 
 	if (add_front) {
-		next_cfqq = __cfq_get_next_queue(st);
-		if (next_cfqq && next_cfqq == cfqq)
+		next_cfqe = __cfq_get_next_entity(st);
+		if (next_cfqe && next_cfqe == cfqe)
 			return;
 	}
 
-	__dequeue_cfqq(st, cfqq);
-	place_cfqq(st, cfqq, add_front);
-	__enqueue_cfqq(st, cfqq, add_front);
+	__dequeue_cfqe(st, cfqe);
+	place_cfqe(st, cfqe, add_front);
+	__enqueue_cfqe(st, cfqe, add_front);
 }
 
-static void __cfqq_served(struct cfq_queue *cfqq, unsigned long served)
+static void requeue_cfqq(struct cfq_queue *cfqq, int add_front)
+{
+	requeue_cfqe(&cfqq->entity, add_front);
+}
+
+static void cfqe_served(struct cfq_entity *cfqe, unsigned long served)
 {
 	/*
 	 * Can't update entity disk time while it is on sorted rb-tree
 	 * as vdisktime is used as key.
 	 */
-	__dequeue_cfqq(cfqq->st, cfqq);
-	cfqq->vdisktime += cfq_delta_fair(served, cfqq);
-	update_min_vdisktime(cfqq->st);
-	__enqueue_cfqq(cfqq->st, cfqq, 0);
+	__dequeue_cfqe(cfqe->st, cfqe);
+	cfqe->vdisktime += cfq_delta_fair(served, cfqe);
+	update_min_vdisktime(cfqe->st);
+	__enqueue_cfqe(cfqe->st, cfqe, 0);
 }
 
 static void cfqq_served(struct cfq_queue *cfqq, unsigned long served)
@@ -680,10 +705,10 @@ static void cfqq_served(struct cfq_queue *cfqq, unsigned long served)
 	 * use the slice and moves to the back of service tree (almost).
 	 */
 	served = cfq_prio_to_slice(cfqq->cfqd, cfqq);
-	__cfqq_served(cfqq, served);
+	cfqe_served(&cfqq->entity, served);
 
 	/* If cfqq prio class has changed, take that into account */
-	if (unlikely(cfqq->ioprio_class_changed)) {
+	if (unlikely(cfqq->entity.ioprio_class_changed)) {
 		dequeue_cfqq(cfqq);
 		enqueue_cfqq(cfqq);
 	}
@@ -698,7 +723,7 @@ static void cfqq_served(struct cfq_queue *cfqq, unsigned long served)
 static void cfq_service_tree_add(struct cfq_data *cfqd, struct cfq_queue *cfqq,
 				bool add_front, unsigned long service)
 {
-	if (RB_EMPTY_NODE(&cfqq->rb_node)) {
+	if (RB_EMPTY_NODE(&cfqq->entity.rb_node)) {
 		/* Its a new queue. Add it to service tree */
 		enqueue_cfqq(cfqq);
 		return;
@@ -1096,14 +1121,32 @@ static inline void cfq_slice_expired(struct cfq_data *cfqd)
 		__cfq_slice_expired(cfqd, cfqq);
 }
 
-static struct cfq_queue *__cfq_get_next_queue(struct cfq_service_tree *st)
+static struct cfq_entity *__cfq_get_next_entity(struct cfq_service_tree *st)
 {
 	struct rb_node *left = st->left;
 
 	if (!left)
 		return NULL;
 
-	return rb_entry(left, struct cfq_queue, rb_node);
+	return rb_entry(left, struct cfq_entity, rb_node);
+}
+
+static struct cfq_entity *cfq_get_next_entity(struct cfq_sched_data *sd)
+{
+	struct cfq_service_tree *st = sd->service_tree;
+	struct cfq_entity *cfqe = NULL;
+	int i;
+
+	for (i = 0; i < IO_IOPRIO_CLASSES; i++, st++) {
+		cfqe = __cfq_get_next_entity(st);
+		if (cfqe) {
+			st->active = cfqe;
+			update_min_vdisktime(cfqe->st);
+			break;
+		}
+	}
+
+	return cfqe;
 }
 
 /*
@@ -1112,24 +1155,17 @@ static struct cfq_queue *__cfq_get_next_queue(struct cfq_service_tree *st)
  */
 static struct cfq_queue *cfq_get_next_queue(struct cfq_data *cfqd)
 {
-	struct cfq_sched_data *sd = &cfqd->sched_data;
-	struct cfq_service_tree *st = sd->service_tree;
-	struct cfq_queue *cfqq = NULL;
-	int i;
+	struct cfq_entity *cfqe = NULL;
 
 	if (!cfqd->rq_queued)
 		return NULL;
 
-	for (i = 0; i < IO_IOPRIO_CLASSES; i++, st++) {
-		cfqq = __cfq_get_next_queue(st);
-		if (cfqq) {
-			st->active = cfqq;
-			update_min_vdisktime(cfqq->st);
-			break;
-		}
-	}
+	cfqe = cfq_get_next_entity(&cfqd->sched_data);
 
-	return cfqq;
+	if (cfqe)
+		return cfqq_of(cfqe);
+	else
+		return NULL;
 }
 
 /*
@@ -1820,33 +1856,33 @@ static void cfq_init_prio_data(struct cfq_queue *cfqq, struct io_context *ioc)
 		 * no prio set, inherit CPU scheduling settings
 		 */
 		cfqq->ioprio = task_nice_ioprio(tsk);
-		cfqq->ioprio_class = task_nice_ioclass(tsk);
+		cfqq->entity.ioprio_class = task_nice_ioclass(tsk);
 		break;
 	case IOPRIO_CLASS_RT:
 		cfqq->ioprio = task_ioprio(ioc);
-		cfqq->ioprio_class = IOPRIO_CLASS_RT;
+		cfqq->entity.ioprio_class = IOPRIO_CLASS_RT;
 		break;
 	case IOPRIO_CLASS_BE:
 		cfqq->ioprio = task_ioprio(ioc);
-		cfqq->ioprio_class = IOPRIO_CLASS_BE;
+		cfqq->entity.ioprio_class = IOPRIO_CLASS_BE;
 		break;
 	case IOPRIO_CLASS_IDLE:
-		cfqq->ioprio_class = IOPRIO_CLASS_IDLE;
+		cfqq->entity.ioprio_class = IOPRIO_CLASS_IDLE;
 		cfqq->ioprio = 7;
 		cfq_clear_cfqq_idle_window(cfqq);
 		break;
 	}
 
-	cfqq->weight = cfq_ioprio_to_weight(cfqq->ioprio);
+	cfqq->entity.weight = cfq_ioprio_to_weight(cfqq->ioprio);
 
-	if (cfqq->org_ioprio_class != cfqq->ioprio_class)
-		cfqq->ioprio_class_changed = 1;
+	if (cfqq->org_ioprio_class != cfqq->entity.ioprio_class)
+		cfqq->entity.ioprio_class_changed = 1;
 	/*
 	 * keep track of original prio settings in case we have to temporarily
 	 * elevate the priority of this queue
 	 */
 	cfqq->org_ioprio = cfqq->ioprio;
-	cfqq->org_ioprio_class = cfqq->ioprio_class;
+	cfqq->org_ioprio_class = cfqq->entity.ioprio_class;
 	cfq_clear_cfqq_prio_changed(cfqq);
 }
 
@@ -1888,7 +1924,7 @@ static void cfq_ioc_set_ioprio(struct io_context *ioc)
 static void cfq_init_cfqq(struct cfq_data *cfqd, struct cfq_queue *cfqq,
 			  pid_t pid, bool is_sync)
 {
-	RB_CLEAR_NODE(&cfqq->rb_node);
+	RB_CLEAR_NODE(&cfqq->entity.rb_node);
 	RB_CLEAR_NODE(&cfqq->p_node);
 	INIT_LIST_HEAD(&cfqq->fifo);
 
@@ -2458,8 +2494,8 @@ static void cfq_prio_boost(struct cfq_queue *cfqq)
 		 * users of the filesystem
 		 */
 		if (cfq_class_idle(cfqq)) {
-			cfqq->ioprio_class = IOPRIO_CLASS_BE;
-			cfqq->ioprio_class_changed = 1;
+			cfqq->entity.ioprio_class = IOPRIO_CLASS_BE;
+			cfqq->entity.ioprio_class_changed = 1;
 		}
 		if (cfqq->ioprio > IOPRIO_NORM)
 			cfqq->ioprio = IOPRIO_NORM;
@@ -2467,9 +2503,9 @@ static void cfq_prio_boost(struct cfq_queue *cfqq)
 		/*
 		 * check if we need to unboost the queue
 		 */
-		if (cfqq->ioprio_class != cfqq->org_ioprio_class) {
-			cfqq->ioprio_class = cfqq->org_ioprio_class;
-			cfqq->ioprio_class_changed = 1;
+		if (cfqq->entity.ioprio_class != cfqq->org_ioprio_class) {
+			cfqq->entity.ioprio_class = cfqq->org_ioprio_class;
+			cfqq->entity.ioprio_class_changed = 1;
 		}
 		if (cfqq->ioprio != cfqq->org_ioprio)
 			cfqq->ioprio = cfqq->org_ioprio;
-- 
1.6.2.5

