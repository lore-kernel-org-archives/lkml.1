Return-Path: <linux-kernel-owner+w=401wt.eu-S933549AbZFOTFV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933549AbZFOTFV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jun 2009 15:05:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932868AbZFOTFI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Jun 2009 15:05:08 -0400
Received: from ms01.sssup.it ([193.205.80.99]:37776 "EHLO sssup.it"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1765080AbZFOTFF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jun 2009 15:05:05 -0400
Date: Mon, 15 Jun 2009 21:06:08 +0200
From: Fabio Checconi <fchecconi@gmail.com>
To: mingo@elte.hu, a.p.zijlstra@chello.nl
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 3/8] Replace struct prio_array with an RB tree
Message-ID: <20090615190608.GM21741@gandalf.sssup.it>
References: <cover.1245092261.git.fabio@helm.retis>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1245092261.git.fabio@helm.retis>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

To store groups in deadline order the old prio_array is not enough.
To keep things simple, use the same data structure to store tasks in
priority order.
---
 include/linux/init_task.h |    1 -
 include/linux/sched.h     |    2 +-
 kernel/sched.c            |   25 ++-----
 kernel/sched_rt.c         |  157 +++++++++++++++++++++++++++++++--------------
 4 files changed, 117 insertions(+), 68 deletions(-)

diff --git a/include/linux/init_task.h b/include/linux/init_task.h
index 28b1f30..5c698b4 100644
--- a/include/linux/init_task.h
+++ b/include/linux/init_task.h
@@ -139,7 +139,6 @@ extern struct cred init_cred;
 		.group_node 	= LIST_HEAD_INIT(tsk.se.group_node),	\
 	},								\
 	.rt		= {						\
-		.run_list	= LIST_HEAD_INIT(tsk.rt.run_list),	\
 		.time_slice	= HZ, 					\
 		.nr_cpus_allowed = NR_CPUS,				\
 	},								\
diff --git a/include/linux/sched.h b/include/linux/sched.h
index d08b3f7..a115067 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1128,7 +1128,7 @@ struct sched_entity {
 };
 
 struct sched_rt_entity {
-	struct list_head run_list;
+	struct rb_node rb_node;
 	unsigned long timeout;
 	unsigned int time_slice;
 	int nr_cpus_allowed;
diff --git a/kernel/sched.c b/kernel/sched.c
index b8d432b..675ea96 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -157,11 +157,11 @@ static inline int task_has_rt_policy(struct task_struct *p)
 }
 
 /*
- * This is the priority-queue data structure of the RT scheduling class:
+ * This is the EDF queue data structure of the RT scheduling class:
  */
-struct rt_prio_array {
-	DECLARE_BITMAP(bitmap, MAX_RT_PRIO+1); /* include 1 bit for delimiter */
-	struct list_head queue[MAX_RT_PRIO];
+struct rt_edf_tree {
+	struct rb_root rb_root;
+	struct rb_node *rb_leftmost;
 };
 
 struct rt_bandwidth {
@@ -481,7 +481,7 @@ struct cfs_rq {
 
 /* Real-Time classes' related field in a runqueue: */
 struct rt_rq {
-	struct rt_prio_array active;
+	struct rt_edf_tree active;
 	unsigned long rt_nr_running;
 #if defined CONFIG_SMP || defined CONFIG_RT_GROUP_SCHED
 	struct {
@@ -2595,7 +2595,7 @@ static void __sched_fork(struct task_struct *p)
 	p->se.wait_max			= 0;
 #endif
 
-	INIT_LIST_HEAD(&p->rt.run_list);
+	RB_CLEAR_NODE(&p->rt.rb_node);
 	p->se.on_rq = 0;
 	INIT_LIST_HEAD(&p->se.group_node);
 
@@ -9069,16 +9069,7 @@ static void init_cfs_rq(struct cfs_rq *cfs_rq, struct rq *rq)
 
 static void init_rt_rq(struct rt_rq *rt_rq, struct rq *rq)
 {
-	struct rt_prio_array *array;
-	int i;
-
-	array = &rt_rq->active;
-	for (i = 0; i < MAX_RT_PRIO; i++) {
-		INIT_LIST_HEAD(array->queue + i);
-		__clear_bit(i, array->bitmap);
-	}
-	/* delimiter for bitsearch: */
-	__set_bit(MAX_RT_PRIO, array->bitmap);
+	rt_rq->active.rb_root = RB_ROOT;
 
 #if defined CONFIG_SMP || defined CONFIG_RT_GROUP_SCHED
 	rt_rq->highest_prio.curr = MAX_RT_PRIO;
@@ -9158,7 +9149,7 @@ static void init_tg_rt_entry(struct task_group *tg, struct rt_rq *rt_rq,
 
 	rt_se->my_q = rt_rq;
 	rt_se->parent = parent;
-	INIT_LIST_HEAD(&rt_se->run_list);
+	RB_CLEAR_NODE(&rt_se->rb_node);
 }
 #endif
 
diff --git a/kernel/sched_rt.c b/kernel/sched_rt.c
index 9bf0d2a..7ae1212 100644
--- a/kernel/sched_rt.c
+++ b/kernel/sched_rt.c
@@ -136,7 +136,7 @@ void dec_rt_migration(struct sched_rt_entity *rt_se, struct rt_rq *rt_rq)
 
 static inline int on_rt_rq(struct sched_rt_entity *rt_se)
 {
-	return !list_empty(&rt_se->run_list);
+	return !RB_EMPTY_NODE(&rt_se->rb_node);
 }
 
 #ifdef CONFIG_RT_GROUP_SCHED
@@ -668,6 +668,14 @@ void dec_rt_prio_smp(struct rt_rq *rt_rq, int prio, int prev_prio) {}
 
 #endif /* CONFIG_SMP */
 
+static inline struct sched_rt_entity *__rt_edf_first(struct rt_edf_tree *tree)
+{
+	if (!tree->rb_leftmost)
+		return NULL;
+
+	return rb_entry(tree->rb_leftmost, struct sched_rt_entity, rb_node);
+}
+
 #if defined CONFIG_SMP || defined CONFIG_RT_GROUP_SCHED
 static void
 inc_rt_prio(struct rt_rq *rt_rq, int prio)
@@ -683,6 +691,7 @@ inc_rt_prio(struct rt_rq *rt_rq, int prio)
 static void
 dec_rt_prio(struct rt_rq *rt_rq, int prio)
 {
+	struct sched_rt_entity *rt_se;
 	int prev_prio = rt_rq->highest_prio.curr;
 
 	if (rt_rq->rt_nr_running) {
@@ -694,10 +703,8 @@ dec_rt_prio(struct rt_rq *rt_rq, int prio)
 		 * we may have some recomputation to do
 		 */
 		if (prio == prev_prio) {
-			struct rt_prio_array *array = &rt_rq->active;
-
-			rt_rq->highest_prio.curr =
-				sched_find_first_bit(array->bitmap);
+			rt_se = __rt_edf_first(&rt_rq->active);
+			rt_rq->highest_prio.curr = rt_se_prio(rt_se);
 		}
 
 	} else
@@ -772,12 +779,71 @@ void dec_rt_tasks(struct sched_rt_entity *rt_se, struct rt_rq *rt_rq)
 	dec_rt_group(rt_se, rt_rq);
 }
 
+static inline int rt_entity_before(struct sched_rt_entity *a,
+				   struct sched_rt_entity *b)
+{
+	return rt_se_prio(a) < rt_se_prio(b);
+}
+
+static void __rt_entity_insert(struct rt_edf_tree *tree,
+			       struct sched_rt_entity *rt_se)
+{
+	struct rb_node **link = &tree->rb_root.rb_node;
+	struct rb_node *parent = NULL;
+	struct sched_rt_entity *entry;
+	int leftmost = 1;
+
+	while (*link) {
+		parent = *link;
+		entry = rb_entry(parent, struct sched_rt_entity, rb_node);
+		if (rt_entity_before(rt_se, entry))
+			link = &parent->rb_left;
+		else {
+			link = &parent->rb_right;
+			leftmost = 0;
+		}
+	}
+
+	if (leftmost)
+		tree->rb_leftmost = &rt_se->rb_node;
+
+	rb_link_node(&rt_se->rb_node, parent, link);
+	rb_insert_color(&rt_se->rb_node, &tree->rb_root);
+}
+
+/*
+ * Attempt to insert rt_se as the first element of tree.  This is used
+ * when requeueing a task at the head of a rt_rq before a reschedule, so
+ * it makes sense only if it is at the highest prio.
+ */
+static int __rt_entity_insert_head(struct rt_edf_tree *tree,
+				   struct sched_rt_entity *rt_se)
+{
+	struct rb_node **link;
+	struct rb_node *parent;
+	struct sched_rt_entity *entry;
+
+	if (tree->rb_leftmost) {
+		entry = __rt_edf_first(tree);
+		if (rt_se_prio(entry) < rt_se_prio(rt_se))
+			return 1;
+	}
+
+	parent = rb_first(&tree->rb_root);
+	link = &parent->rb_left;
+
+	tree->rb_leftmost = &rt_se->rb_node;
+
+	rb_link_node(&rt_se->rb_node, parent, link);
+	rb_insert_color(&rt_se->rb_node, &tree->rb_root);
+
+	return 0;
+}
+
 static void __enqueue_rt_entity(struct sched_rt_entity *rt_se)
 {
 	struct rt_rq *rt_rq = rt_rq_of_se(rt_se);
-	struct rt_prio_array *array = &rt_rq->active;
 	struct rt_rq *group_rq = group_rt_rq(rt_se);
-	struct list_head *queue = array->queue + rt_se_prio(rt_se);
 
 	/*
 	 * Don't enqueue the group if its throttled, or when empty.
@@ -788,21 +854,25 @@ static void __enqueue_rt_entity(struct sched_rt_entity *rt_se)
 	if (group_rq && (rt_rq_throttled(group_rq) || !group_rq->rt_nr_running))
 		return;
 
-	list_add_tail(&rt_se->run_list, queue);
-	__set_bit(rt_se_prio(rt_se), array->bitmap);
-
+	__rt_entity_insert(&rt_rq->active, rt_se);
 	inc_rt_tasks(rt_se, rt_rq);
 }
 
+static void __rt_entity_remove(struct rt_edf_tree *tree,
+			       struct sched_rt_entity *rt_se)
+{
+	if (tree->rb_leftmost == &rt_se->rb_node)
+		tree->rb_leftmost = rb_next(&rt_se->rb_node);
+
+	rb_erase(&rt_se->rb_node, &tree->rb_root);
+	RB_CLEAR_NODE(&rt_se->rb_node);
+}
+
 static void __dequeue_rt_entity(struct sched_rt_entity *rt_se)
 {
 	struct rt_rq *rt_rq = rt_rq_of_se(rt_se);
-	struct rt_prio_array *array = &rt_rq->active;
-
-	list_del_init(&rt_se->run_list);
-	if (list_empty(array->queue + rt_se_prio(rt_se)))
-		__clear_bit(rt_se_prio(rt_se), array->bitmap);
 
+	__rt_entity_remove(&rt_rq->active, rt_se);
 	dec_rt_tasks(rt_se, rt_rq);
 }
 
@@ -881,14 +951,13 @@ static void dequeue_task_rt(struct rq *rq, struct task_struct *p, int sleep)
 static void
 requeue_rt_entity(struct rt_rq *rt_rq, struct sched_rt_entity *rt_se, int head)
 {
-	if (on_rt_rq(rt_se)) {
-		struct rt_prio_array *array = &rt_rq->active;
-		struct list_head *queue = array->queue + rt_se_prio(rt_se);
+	struct rt_edf_tree *tree;
 
-		if (head)
-			list_move(&rt_se->run_list, queue);
-		else
-			list_move_tail(&rt_se->run_list, queue);
+	if (on_rt_rq(rt_se)) {
+		tree = &rt_rq->active;
+		__rt_entity_remove(tree, rt_se);
+		if (!head || __rt_entity_insert_head(tree, rt_se))
+			__rt_entity_insert(tree, rt_se);
 	}
 }
 
@@ -1000,18 +1069,12 @@ static void check_preempt_curr_rt(struct rq *rq, struct task_struct *p, int sync
 static struct sched_rt_entity *pick_next_rt_entity(struct rq *rq,
 						   struct rt_rq *rt_rq)
 {
-	struct rt_prio_array *array = &rt_rq->active;
-	struct sched_rt_entity *next = NULL;
-	struct list_head *queue;
-	int idx;
+	struct rb_node *left = rt_rq->active.rb_leftmost;
 
-	idx = sched_find_first_bit(array->bitmap);
-	BUG_ON(idx >= MAX_RT_PRIO);
-
-	queue = array->queue + idx;
-	next = list_entry(queue->next, struct sched_rt_entity, run_list);
+	if (!left)
+		return NULL;
 
-	return next;
+	return rb_entry(left, struct sched_rt_entity, rb_node);
 }
 
 static struct task_struct *_pick_next_task_rt(struct rq *rq)
@@ -1083,31 +1146,27 @@ static int pick_rt_task(struct rq *rq, struct task_struct *p, int cpu)
 /* Return the second highest RT task, NULL otherwise */
 static struct task_struct *pick_next_highest_task_rt(struct rq *rq, int cpu)
 {
-	struct task_struct *next = NULL;
+	struct task_struct *p, *next = NULL;
 	struct sched_rt_entity *rt_se;
-	struct rt_prio_array *array;
 	struct rt_rq *rt_rq;
-	int idx;
+	struct rt_edf_tree *tree;
+	struct rb_node *node;
 
 	for_each_leaf_rt_rq(rt_rq, rq) {
-		array = &rt_rq->active;
-		idx = sched_find_first_bit(array->bitmap);
- next_idx:
-		if (idx >= MAX_RT_PRIO)
-			continue;
-		if (next && next->prio < idx)
-			continue;
-		list_for_each_entry(rt_se, array->queue + idx, run_list) {
-			struct task_struct *p = rt_task_of(rt_se);
+		tree = &rt_rq->active;
+		for (node = tree->rb_leftmost; node; node = rb_next(node)) {
+			rt_se = rb_entry(node, struct sched_rt_entity, rb_node);
+			if (group_rt_rq(rt_se))
+				continue;
+
+			p = rt_task_of(rt_se);
+			if (next && next->prio < p->prio)
+				break;
 			if (pick_rt_task(rq, p, cpu)) {
 				next = p;
 				break;
 			}
 		}
-		if (!next) {
-			idx = find_next_bit(array->bitmap, MAX_RT_PRIO, idx+1);
-			goto next_idx;
-		}
 	}
 
 	return next;
@@ -1706,7 +1765,7 @@ static void task_tick_rt(struct rq *rq, struct task_struct *p, int queued)
 	 * Requeue to the end of queue if we are not the only element
 	 * on the queue:
 	 */
-	if (p->rt.run_list.prev != p->rt.run_list.next) {
+	if (rb_next(&p->rt.rb_node)) {
 		requeue_task_rt(rq, p, 0);
 		set_tsk_need_resched(p);
 	}
-- 
1.6.2.2

