Return-Path: <linux-kernel-owner+w=401wt.eu-S1759297AbXJaUeA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759297AbXJaUeA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2007 16:34:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754311AbXJaUdx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Oct 2007 16:33:53 -0400
Received: from smtp3-g19.free.fr ([212.27.42.29]:36001 "EHLO smtp3-g19.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754301AbXJaUdw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2007 16:33:52 -0400
From: Guillaume Chazarain <guichaz@yahoo.fr>
Subject: [PATCH] sched: CONFIG_FAIR_USER_SCHED: auto adjust users weights
To: Ingo Molnar <mingo@elte.hu>
Cc: Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
       linux-kernel@vger.kernel.org
Date: Wed, 31 Oct 2007 21:29:57 +0100
Message-ID: <20071031202957.2738.15014.stgit@localhost.localdomain>
User-Agent: StGIT/0.12.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

CONFIG_FAIR_USER_SCHED is great and I'm happy to see it is enabled by default
but it suffers from some limitations IMHO at this time:

- on a single user system, it's useful to have root processes be given twice
as CPU as user processes but I don't want nice 19 cron jobs like updatedb or
rpmq to have twice as cpu as my nice -20 tasks.

- on a multi user system, a user should be able to give back its cpu share to
other users. This is not possible for now with CONFIG_FAIR_USER_SCHED.

This implies that returning EPERM on nice(<0) becomes worthless, as it is
equivalent to nice(>0) for every other process of the user, ignoring the limits
of the nice range.

To address these problems, this patch changes the weight of the cfs_rq of each
user to the maximum weight of the processes on this cfs_rq, scaled with
/sys/kernel/uids/UID/cpu_share. It's possible that more elaborate mathematics
than taking the max are needed, but basic testing showed the expected fairness.

Signed-off-by: Guillaume Chazarain <guichaz@yahoo.fr>
---

 include/linux/sched.h |    4 ++
 kernel/sched.c        |   50 +++++++++++++++++++----
 kernel/sched_fair.c   |  108 +++++++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 154 insertions(+), 8 deletions(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index 155d743..d6d2db9 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -908,6 +908,10 @@ struct sched_entity {
 	/* rq "owned" by this entity/group: */
 	struct cfs_rq		*my_q;
 #endif
+#ifdef CONFIG_FAIR_USER_SCHED
+	/* used to track the max load.weight */
+	struct rb_node		max_load;
+#endif
 };
 
 struct task_struct {
diff --git a/kernel/sched.c b/kernel/sched.c
index 3f6bd11..df8114b 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -260,6 +260,10 @@ struct cfs_rq {
 	struct list_head leaf_cfs_rq_list; /* Better name : task_cfs_rq_list? */
 	struct task_group *tg;    /* group that "owns" this runqueue */
 #endif
+#ifdef CONFIG_FAIR_USER_SCHED
+	/* used to track the sched_entity with the max load in this cfs_rq */
+	struct rb_root max_load_se;
+#endif
 };
 
 /* Real-Time classes' related field in a runqueue: */
@@ -7094,14 +7098,12 @@ done:
 	task_rq_unlock(rq, &flags);
 }
 
+/* cfs_rq->rq->lock must be taken */
 static void set_se_shares(struct sched_entity *se, unsigned long shares)
 {
 	struct cfs_rq *cfs_rq = se->cfs_rq;
-	struct rq *rq = cfs_rq->rq;
 	int on_rq;
 
-	spin_lock_irq(&rq->lock);
-
 	on_rq = se->on_rq;
 	if (on_rq)
 		dequeue_entity(cfs_rq, se, 0);
@@ -7111,22 +7113,54 @@ static void set_se_shares(struct sched_entity *se, unsigned long shares)
 
 	if (on_rq)
 		enqueue_entity(cfs_rq, se, 0);
+}
 
-	spin_unlock_irq(&rq->lock);
+#ifdef CONFIG_FAIR_USER_SCHED
+static void update_group_share(struct task_group *tg, int cpu)
+{
+	struct rb_node *max_load_node = rb_last(&tg->cfs_rq[cpu]->max_load_se);
+	struct sched_entity *max_load_entry;
+	unsigned long shares;
+
+	if (!max_load_node)
+		/* empty cfs_rq */
+		return;
+
+	max_load_entry = rb_entry(max_load_node, struct sched_entity, max_load);
+	shares = scale_tg_weight(tg, max_load_entry->load.weight);
+	set_se_shares(tg->se[cpu], shares);
+}
+#else
+static void update_group_share(struct task_group *tg, int cpu)
+{
+	set_se_shares(tg->se[cpu], tg->shares);
 }
+#endif
 
 int sched_group_set_shares(struct task_group *tg, unsigned long shares)
 {
-	int i;
+	int cpu;
+	unsigned long flags;
+
+	if (shares <= 1)
+		return -EINVAL;
+
+#ifdef CONFIG_FAIR_USER_SCHED
+	if ((shares * prio_to_weight[0]) / prio_to_weight[0] != shares)
+		/* The provided value would overflow in scale_tg_weight() */
+		return -EINVAL;
+#endif
 
 	spin_lock(&tg->lock);
 	if (tg->shares == shares)
 		goto done;
 
 	tg->shares = shares;
-	for_each_possible_cpu(i)
-		set_se_shares(tg->se[i], shares);
-
+	for_each_possible_cpu(cpu) {
+		spin_lock_irqsave(&tg->cfs_rq[cpu]->rq->lock, flags);
+		update_group_share(tg, cpu);
+		spin_unlock_irqrestore(&tg->cfs_rq[cpu]->rq->lock, flags);
+	}
 done:
 	spin_unlock(&tg->lock);
 	return 0;
diff --git a/kernel/sched_fair.c b/kernel/sched_fair.c
index 01859f6..70ed34e 100644
--- a/kernel/sched_fair.c
+++ b/kernel/sched_fair.c
@@ -135,6 +135,112 @@ static inline s64 entity_key(struct cfs_rq *cfs_rq, struct sched_entity *se)
 	return se->vruntime - cfs_rq->min_vruntime;
 }
 
+#ifdef CONFIG_FAIR_USER_SCHED
+static void set_se_shares(struct sched_entity *se, unsigned long shares);
+
+static unsigned long scale_tg_weight(struct task_group *tg, unsigned long weight)
+{
+	unsigned long scaled_weight = (weight * tg->shares) / NICE_0_LOAD;
+	return max(scaled_weight, 2UL);
+}
+
+static void enqueue_max_load(struct cfs_rq *cfs_rq, struct sched_entity *se)
+{
+	struct rb_node **link;
+	struct rb_node *parent = NULL;
+	struct sched_entity *entry;
+	unsigned long scaled_weight;
+
+	if (!cfs_rq->tg)
+		/* this is the main cfs_rq, not a user specific one */
+		return;
+
+	/*
+	 * We cannot take cfs_rq->tg->lock. As we already lock the rq, we
+	 * could deadlock in sched_group_set_shares()
+	 */
+
+	/*
+	 * Insert the sched_entity at its place in cfs_rq->max_load_se, given
+	 * its load.weight
+	 */
+	link = &cfs_rq->max_load_se.rb_node;
+	while (*link) {
+		parent = *link;
+		entry = rb_entry(parent, struct sched_entity, max_load);
+		if (se->load.weight < entry->load.weight)
+			link = &parent->rb_left;
+		else
+			link = &parent->rb_right;
+	}
+	rb_link_node(&se->max_load, parent, link);
+	rb_insert_color(&se->max_load, &cfs_rq->max_load_se);
+
+	/*
+	 * Update the weight of the cfs_rq if we inserted a higher weight
+	 * sched_entity
+	 */
+	scaled_weight = scale_tg_weight(cfs_rq->tg, se->load.weight);
+	if (scaled_weight > cfs_rq->load.weight)
+		set_se_shares(se->parent, scaled_weight);
+}
+
+static void dequeue_max_load(struct cfs_rq *cfs_rq, struct sched_entity *se)
+{
+	struct rb_node *prev_node;
+	struct rb_node *next_node;
+	struct sched_entity *prev_entry;
+	unsigned long scaled_weight;
+
+	if (!cfs_rq->tg)
+		/* this is the main cfs_rq, not a user specific one */
+		return;
+
+	/*
+	 * We cannot take cfs_rq->tg->lock. As we already lock the rq, we
+	 * could deadlock in sched_group_set_shares()
+	 */
+
+	next_node = rb_next(&se->max_load);
+	if (!next_node)
+		prev_node = rb_prev(&se->max_load);
+	rb_erase(&se->max_load, &cfs_rq->max_load_se);
+
+	if (next_node)
+		/* The removed sched_entity was not the highest weight */
+		return;
+
+	/*
+	 * Here we know we removed the highest weight sched_entity, so
+	 * prev_node now contains the highest weight sched_entity
+	 */
+
+	if (!prev_node)
+		/* The cfs_rq is now empty */
+		return;
+
+	prev_entry = rb_entry(prev_node, struct sched_entity, max_load);
+	if (prev_entry->load.weight == se->load.weight)
+		/*
+		 * A sched_entity in the cfs_rq had the same weight, so the
+		 * max weight did not change
+		 */
+		return;
+
+	scaled_weight = scale_tg_weight(cfs_rq->tg, prev_entry->load.weight);
+	if (scaled_weight != cfs_rq->load.weight)
+		set_se_shares(prev_entry->parent, scaled_weight);
+}
+#else
+static inline void enqueue_max_load(struct cfs_rq *cfs_rq, struct sched_entity *se)
+{
+}
+
+static inline void dequeue_max_load(struct cfs_rq *cfs_rq, struct sched_entity *se)
+{
+}
+#endif
+
 /*
  * Enqueue an entity into the rb-tree:
  */
@@ -173,6 +279,7 @@ static void __enqueue_entity(struct cfs_rq *cfs_rq, struct sched_entity *se)
 
 	rb_link_node(&se->run_node, parent, link);
 	rb_insert_color(&se->run_node, &cfs_rq->tasks_timeline);
+	enqueue_max_load(cfs_rq, se);
 }
 
 static void __dequeue_entity(struct cfs_rq *cfs_rq, struct sched_entity *se)
@@ -181,6 +288,7 @@ static void __dequeue_entity(struct cfs_rq *cfs_rq, struct sched_entity *se)
 		cfs_rq->rb_leftmost = rb_next(&se->run_node);
 
 	rb_erase(&se->run_node, &cfs_rq->tasks_timeline);
+	dequeue_max_load(cfs_rq, se);
 }
 
 static inline struct rb_node *first_fair(struct cfs_rq *cfs_rq)

