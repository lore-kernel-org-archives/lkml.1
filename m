Return-Path: <linux-kernel-owner+w=401wt.eu-S1754638AbYCIRLz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754638AbYCIRLz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Mar 2008 13:11:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752830AbYCIRJY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Mar 2008 13:09:24 -0400
Received: from viefep25-int.chello.at ([62.179.121.45]:26581 "EHLO
	viefep25-int.chello.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752310AbYCIRJU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Mar 2008 13:09:20 -0400
X-SourceIP: 80.56.237.116
Message-Id: <20080309170929.384700000@chello.nl>
References: <20080309170850.256853000@chello.nl>
User-Agent: quilt/0.45-1
Date: Sun, 09 Mar 2008 18:09:05 +0100
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>
Cc: Dmitry Adamushko <dmitry.adamushko@gmail.com>,
       Mike Galbraith <efault@gmx.de>,
       Dhaval Giani <dhaval@linux.vnet.ibm.com>,
       Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [RFC/PATCH 15/17] sched: fair-group: EEVDF scheduling
Content-Disposition: inline; filename=sched-dual.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Two groups, A and B. A has 1 tasks, B 2. Say that B has double
the latency requirement A has, but have equal weight.

This gives the following scenario:

    A  |---|---|
    ---+-------+
    B1 |-------|
    B2 |-------|

The various scheduling options:

    Ideal: A B1 A  B2
    CFS:   A B1 B2 A
    EDF:   A A  B1 B2

Both CFS and EDF mess up in that they'll lump A together and schedule
both Bs in between, making A miss its latency requirement.

[ Note, both CFS and EDF have the freedom to accidentally schedule it
  properly, but there is no guarantee ]

However, mixing both can give the ideal result.

Vruntime makes task time run as fast as real-time and by keeping track
of where in vruntime we actually are we can make a decision between the
two tasks presented by either method.

We schedule using the following rule:
  s1) we use the EDF result if its eligible to run (has >= 0 lag)
  s2) we use the CFS result

    A  |---|
1)  ---+---+---+           s1 -> A
    B1 |-------|
    B2 |-------|
       ^

    A      |---|
2)  ---+---+---+-------+   s2 -> B1
    B1 |-------|
    B2 |-------|
         ^

    A      |---|
3)  ---+---+---+-------+   s1 -> A
    B1         |-------|
    B2 |-------|
           ^

    A          |---|
4)  ---+-------+---+---+   s2 -> B2
    B1         |-------|
    B2 |-------|
             ^
[ ^ denotes time ]

Note that 3 is still ambiguous as both A and B2 have identical deadlines
and both start times are before or at the current time. While this situation
will be extremely rare, we can resolve this by making the EDF tree prefer
tasks with a smaller period over those with a larger.

We use a dual tree approach instead of the modified binary tree mentioned in
the EEVDF paper because it allows for a slimmer !group config and saves the
hassle of implementing yet another balanced tree.

With thanks to Dmitry Adamushko for analyzing the problems and poking holes
into my earlier implementations :-)

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: Dmitry Adamushko <dmitry.adamushko@gmail.com>
---
 include/linux/sched.h |    6 +
 kernel/sched.c        |    8 +-
 kernel/sched_debug.c  |    6 -
 kernel/sched_fair.c   |  193 ++++++++++++++++++++++++++++++++++++++++----------
 4 files changed, 172 insertions(+), 41 deletions(-)

Index: linux-2.6-2/include/linux/sched.h
===================================================================
--- linux-2.6-2.orig/include/linux/sched.h
+++ linux-2.6-2/include/linux/sched.h
@@ -917,7 +917,11 @@ struct load_weight {
  */
 struct sched_entity {
 	struct load_weight	load;		/* for load-balancing */
-	struct rb_node		run_node;
+	struct rb_node		timeline_node;
+#ifdef CONFIG_FAIR_GROUP_SCHED
+	struct rb_node		deadline_node;
+	u64			vperiod;
+#endif
 	struct list_head	group_node;
 	unsigned int		on_rq;
 
Index: linux-2.6-2/kernel/sched.c
===================================================================
--- linux-2.6-2.orig/kernel/sched.c
+++ linux-2.6-2/kernel/sched.c
@@ -385,9 +385,12 @@ struct cfs_root_rq {
 	u64 min_vruntime;
 
 	struct rb_root tasks_timeline;
-	struct rb_node *rb_leftmost;
+	struct rb_node *left_timeline;
 
 #ifdef CONFIG_FAIR_GROUP_SCHED
+	struct rb_root tasks_deadline;
+	struct rb_node *left_deadline;
+
 	s64 avg_vruntime;
 	unsigned long nr_queued;
 #endif
@@ -7498,6 +7501,9 @@ static void init_cfs_root_rq(struct cfs_
 {
 	cfs_r_rq->tasks_timeline = RB_ROOT;
 	cfs_r_rq->min_vruntime = (u64)(-(1LL << 20));
+#ifdef CONFIG_FAIR_GROUP_SCHED
+	cfs_r_rq->tasks_deadline = RB_ROOT;
+#endif
 }
 
 static void init_cfs_rq(struct cfs_rq *cfs_rq, struct rq *rq)
Index: linux-2.6-2/kernel/sched_fair.c
===================================================================
--- linux-2.6-2.orig/kernel/sched_fair.c
+++ linux-2.6-2/kernel/sched_fair.c
@@ -219,7 +219,7 @@ static inline u64 min_vruntime(u64 min_v
 }
 
 static inline
-s64 entity_key(struct cfs_root_rq *cfs_r_rq, struct sched_entity *se)
+s64 entity_timeline_key(struct cfs_root_rq *cfs_r_rq, struct sched_entity *se)
 {
 	return se->vruntime - cfs_r_rq->min_vruntime;
 }
@@ -234,18 +234,18 @@ static void __enqueue_timeline(struct cf
 	int leftmost = 1;
 
 	link = &cfs_r_rq->tasks_timeline.rb_node;
-	key = entity_key(cfs_r_rq, se);
+	key = entity_timeline_key(cfs_r_rq, se);
 	/*
 	 * Find the right place in the rbtree:
 	 */
 	while (*link) {
 		parent = *link;
-		entry = rb_entry(parent, struct sched_entity, run_node);
+		entry = rb_entry(parent, struct sched_entity, timeline_node);
 		/*
 		 * We dont care about collisions. Nodes with
 		 * the same key stay together.
 		 */
-		if (key < entity_key(cfs_r_rq, entry)) {
+		if (key < entity_timeline_key(cfs_r_rq, entry)) {
 			link = &parent->rb_left;
 		} else {
 			link = &parent->rb_right;
@@ -258,26 +258,48 @@ static void __enqueue_timeline(struct cf
 	 * used):
 	 */
 	if (leftmost)
-		cfs_r_rq->rb_leftmost = &se->run_node;
+		cfs_r_rq->left_timeline = &se->timeline_node;
 
-	rb_link_node(&se->run_node, parent, link);
-	rb_insert_color(&se->run_node, &cfs_r_rq->tasks_timeline);
+	rb_link_node(&se->timeline_node, parent, link);
+	rb_insert_color(&se->timeline_node, &cfs_r_rq->tasks_timeline);
 }
 
 static void __dequeue_timeline(struct cfs_root_rq *cfs_r_rq,
 		struct sched_entity *se)
 {
-	if (cfs_r_rq->rb_leftmost == &se->run_node)
-		cfs_r_rq->rb_leftmost = rb_next(&se->run_node);
+	if (cfs_r_rq->left_timeline == &se->timeline_node)
+		cfs_r_rq->left_timeline = rb_next(&se->timeline_node);
 
-	rb_erase(&se->run_node, &cfs_r_rq->tasks_timeline);
+	rb_erase(&se->timeline_node, &cfs_r_rq->tasks_timeline);
+}
+
+static inline struct rb_node *first_fair(struct cfs_root_rq *cfs_r_rq)
+{
+	return cfs_r_rq->left_timeline;
+}
+
+static struct sched_entity *__pick_next_timeline(struct cfs_root_rq *cfs_r_rq)
+{
+	return rb_entry(first_fair(cfs_r_rq),
+			struct sched_entity, timeline_node);
+}
+
+static inline
+struct sched_entity *__pick_last_timeline(struct cfs_root_rq *cfs_r_rq)
+{
+	struct rb_node *last = rb_last(&cfs_r_rq->tasks_timeline);
+
+	if (!last)
+		return NULL;
+
+	return rb_entry(last, struct sched_entity, timeline_node);
 }
 
 #ifdef CONFIG_FAIR_GROUP_SCHED
 static inline
 void avg_vruntime_add(struct cfs_root_rq *cfs_r_rq, struct sched_entity *se)
 {
-	s64 key = entity_key(cfs_r_rq, se);
+	s64 key = entity_timeline_key(cfs_r_rq, se);
 	cfs_r_rq->avg_vruntime += key;
 	cfs_r_rq->nr_queued++;
 }
@@ -285,7 +307,7 @@ void avg_vruntime_add(struct cfs_root_rq
 static inline
 void avg_vruntime_sub(struct cfs_root_rq *cfs_r_rq, struct sched_entity *se)
 {
-	s64 key = entity_key(cfs_r_rq, se);
+	s64 key = entity_timeline_key(cfs_r_rq, se);
 	cfs_r_rq->avg_vruntime -= key;
 	cfs_r_rq->nr_queued--;
 }
@@ -316,6 +338,108 @@ s64 avg_vruntime(struct cfs_root_rq *cfs
 	return avg;
 }
 
+static inline
+s64 entity_deadline_key(struct cfs_root_rq *cfs_r_rq, struct sched_entity *se)
+{
+	return se->vruntime + se->vperiod - cfs_r_rq->min_vruntime;
+}
+
+static u64 sched_vslice_add(struct cfs_rq *cfs_rq, struct sched_entity *se);
+
+static void sched_calc_deadline(struct cfs_root_rq *cfs_r_rq,
+				struct sched_entity *se)
+{
+	u64 deadline = avg_vruntime(cfs_r_rq) +
+		sched_vslice_add(cfs_rq_of(se), se);
+	se->vperiod = deadline - entity_timeline_key(cfs_r_rq, se);
+}
+
+static void __enqueue_deadline(struct cfs_root_rq *cfs_r_rq,
+			       struct sched_entity *se)
+{
+	struct rb_node **link;
+	struct rb_node *parent = NULL;
+	struct sched_entity *entry;
+	s64 key, entry_key;
+	int leftmost = 1;
+
+	sched_calc_deadline(cfs_r_rq, se);
+
+	link = &cfs_r_rq->tasks_deadline.rb_node;
+	key = entity_deadline_key(cfs_r_rq, se);
+	/*
+	 * Find the right place in the rbtree:
+	 */
+	while (*link) {
+		parent = *link;
+		entry = rb_entry(parent, struct sched_entity, deadline_node);
+		/*
+		 * Prefer shorter latency tasks over higher.
+		 */
+		entry_key = entity_deadline_key(cfs_r_rq, entry);
+		if (key < entry_key ||
+		    (key == entry_key && se->vperiod < entry->vperiod)) {
+
+			link = &parent->rb_left;
+
+		} else {
+			link = &parent->rb_right;
+			leftmost = 0;
+		}
+	}
+
+	/*
+	 * Maintain a cache of leftmost tree entries (it is frequently
+	 * used):
+	 */
+	if (leftmost)
+		cfs_r_rq->left_deadline = &se->deadline_node;
+
+	rb_link_node(&se->deadline_node, parent, link);
+	rb_insert_color(&se->deadline_node, &cfs_r_rq->tasks_deadline);
+}
+
+static void __dequeue_deadline(struct cfs_root_rq *cfs_r_rq,
+			       struct sched_entity *se)
+{
+	if (cfs_r_rq->left_deadline == &se->deadline_node)
+		cfs_r_rq->left_deadline = rb_next(&se->deadline_node);
+
+	rb_erase(&se->deadline_node, &cfs_r_rq->tasks_deadline);
+}
+
+static inline struct rb_node *first_deadline(struct cfs_root_rq *cfs_r_rq)
+{
+	return cfs_r_rq->left_deadline;
+}
+
+static struct sched_entity *__pick_next_deadline(struct cfs_root_rq *cfs_r_rq)
+{
+	return rb_entry(first_deadline(cfs_r_rq),
+			struct sched_entity, deadline_node);
+}
+
+/*
+ * Earliest Eligible Virtual Deadline First
+ *
+ * pick a task using the virtual deadline tree, when it is eligible to run
+ * use it, otherwise run the task with the greatest need.
+ *
+ * Eligibility means we never run a task which has more than its fair share
+ * of runtime.
+ */
+static struct sched_entity *__pick_next_entity(struct cfs_root_rq *cfs_r_rq)
+{
+	struct sched_entity *next_deadline;
+	s64 avg = avg_vruntime(cfs_r_rq);
+
+	next_deadline = __pick_next_deadline(cfs_r_rq);
+	if (entity_timeline_key(cfs_r_rq, next_deadline) <= avg)
+		return next_deadline;
+
+	return __pick_next_timeline(cfs_r_rq);
+}
+
 #else /* CONFIG_FAIR_GROUP_SCHED */
 
 static inline
@@ -332,6 +456,22 @@ static inline
 void avg_vruntime_update(struct cfs_root_rq *cfs_rq, s64 delta)
 {
 }
+
+static inline
+void __enqueue_deadline(struct cfs_root_rq *cfs_r_rq, struct sched_entity *se)
+{
+}
+
+static inline
+void __dequeue_deadline(struct cfs_root_rq *cfs_r_rq, struct sched_entity *se)
+{
+}
+
+static inline
+struct sched_entity *__pick_next_entity(struct cfs_root_rq *cfs_r_rq)
+{
+	return __pick_next_timeline(cfs_r_rq);
+}
 #endif /* CONFIG_FAIR_GROUP_SCHED */
 
 /*
@@ -347,6 +487,7 @@ static void __enqueue_entity(struct cfs_
 		return;
 
 	__enqueue_timeline(&rq_of(cfs_rq)->cfs_root, se);
+	__enqueue_deadline(&rq_of(cfs_rq)->cfs_root, se);
 	avg_vruntime_add(&rq_of(cfs_rq)->cfs_root, se);
 }
 
@@ -359,30 +500,10 @@ static void __dequeue_entity(struct cfs_
 		return;
 
 	__dequeue_timeline(&rq_of(cfs_rq)->cfs_root, se);
+	__dequeue_deadline(&rq_of(cfs_rq)->cfs_root, se);
 	avg_vruntime_sub(&rq_of(cfs_rq)->cfs_root, se);
 }
 
-static inline struct rb_node *first_fair(struct cfs_root_rq *cfs_r_rq)
-{
-	return cfs_r_rq->rb_leftmost;
-}
-
-static struct sched_entity *__pick_next_entity(struct cfs_root_rq *cfs_r_rq)
-{
-	return rb_entry(first_fair(cfs_r_rq), struct sched_entity, run_node);
-}
-
-static inline
-struct sched_entity *__pick_last_entity(struct cfs_root_rq *cfs_r_rq)
-{
-	struct rb_node *last = rb_last(&cfs_rq->tasks_timeline);
-
-	if (!last)
-		return NULL;
-
-	return rb_entry(last, struct sched_entity, timeline_node);
-}
-
 /**************************************************************
  * Scheduling class statistics methods:
  */
@@ -440,7 +561,7 @@ calc_delta_fair(unsigned long delta, str
  *
  * p = (nr <= nl) ? l : l*nr/nl
  */
-static u64 __sched_period(unsigned long nr_running)
+static inline u64 __sched_period(unsigned long nr_running)
 {
 	u64 period = sysctl_sched_latency;
 	unsigned long nr_latency = sched_nr_latency;
@@ -535,7 +656,7 @@ void __update_root(struct cfs_root_rq *c
 	 */
 	if (first_fair(cfs_r_rq)) {
 		vruntime = min_vruntime(curr->vruntime,
-				__pick_next_entity(cfs_r_rq)->vruntime);
+				__pick_next_timeline(cfs_r_rq)->vruntime);
 	} else
 		vruntime = curr->vruntime;
 
@@ -1024,7 +1145,7 @@ static void yield_task_fair(struct rq *r
 	/*
 	 * Find the rightmost entry in the rbtree:
 	 */
-	rightmost = __pick_last_entity(&rq->cfs_root);
+	rightmost = __pick_last_timeline(&rq->cfs_root);
 	/*
 	 * Already in the rightmost position?
 	 */
Index: linux-2.6-2/kernel/sched_debug.c
===================================================================
--- linux-2.6-2.orig/kernel/sched_debug.c
+++ linux-2.6-2/kernel/sched_debug.c
@@ -113,9 +113,9 @@ void print_cfs_root(struct seq_file *m, 
 	SEQ_printf(m, "\ncfs_root_rq\n");
 
 	spin_lock_irqsave(&rq->lock, flags);
-	if (cfs_r_rq->rb_leftmost)
-		MIN_vruntime = (__pick_next_entity(cfs_r_rq))->vruntime;
-	last = __pick_last_entity(cfs_r_rq);
+	if (cfs_r_rq->left_timeline)
+		MIN_vruntime = (__pick_next_timeline(cfs_r_rq))->vruntime;
+	last = __pick_last_timeline(cfs_r_rq);
 	if (last)
 		max_vruntime = last->vruntime;
 	min_vruntime = cfs_r_rq->min_vruntime;

--

