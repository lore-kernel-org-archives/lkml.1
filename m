Return-Path: <linux-kernel-owner+w=401wt.eu-S1754047AbYHSKpx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754047AbYHSKpx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2008 06:45:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752837AbYHSKoT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Aug 2008 06:44:19 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:54426 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752708AbYHSKoR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2008 06:44:17 -0400
Message-Id: <20080819103844.304088393@chello.nl>
References: <20080819103301.787700742@chello.nl>
User-Agent: quilt/0.46-1
Date: Tue, 19 Aug 2008 12:33:05 +0200
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: linux-kernel@vger.kernel.org
Cc: Stefani Seibold <stefani@seibold.net>, Dario Faggioli <raistlin@linux.it>,
       Nick Piggin <nickpiggin@yahoo.com.au>,
       Max Krasnyansky <maxk@qualcomm.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [PATCH 4/6] sched: extract walk_tg_tree()
Content-Disposition: inline; filename=sched-rt-bw-walk-tree.patch
X-Bad-Reply: References but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Extract walk_tg_tree() and make it a little more generic so we can use it
in the schedulablity test.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 kernel/sched.c    |  219 +++++++++++++++++++++++++++++++-----------------------
 kernel/sched_rt.c |   16 ++-
 2 files changed, 135 insertions(+), 100 deletions(-)

Index: linux-2.6/kernel/sched.c
===================================================================
--- linux-2.6.orig/kernel/sched.c
+++ linux-2.6/kernel/sched.c
@@ -1380,38 +1387,24 @@ static inline void dec_cpu_load(struct r
 	update_load_sub(&rq->load, load);
 }
 
-#ifdef CONFIG_SMP
-static unsigned long source_load(int cpu, int type);
-static unsigned long target_load(int cpu, int type);
-static int task_hot(struct task_struct *p, u64 now, struct sched_domain *sd);
-
-static unsigned long cpu_avg_load_per_task(int cpu)
-{
-	struct rq *rq = cpu_rq(cpu);
-
-	if (rq->nr_running)
-		rq->avg_load_per_task = rq->load.weight / rq->nr_running;
-
-	return rq->avg_load_per_task;
-}
-
-#ifdef CONFIG_FAIR_GROUP_SCHED
-
-typedef void (*tg_visitor)(struct task_group *, int, struct sched_domain *);
+#if (defined(CONFIG_SMP) && defined(CONFIG_FAIR_GROUP_SCHED))
+typedef int (*tg_visitor)(struct task_group *, void *);
 
 /*
  * Iterate the full tree, calling @down when first entering a node and @up when
  * leaving it for the final time.
  */
-static void
-walk_tg_tree(tg_visitor down, tg_visitor up, int cpu, struct sched_domain *sd)
+static int walk_tg_tree(tg_visitor down, tg_visitor up, void *data)
 {
 	struct task_group *parent, *child;
+	int ret;
 
 	rcu_read_lock();
 	parent = &root_task_group;
 down:
-	(*down)(parent, cpu, sd);
+	ret = (*down)(parent, data);
+	if (ret)
+		goto out_unlock;
 	list_for_each_entry_rcu(child, &parent->children, siblings) {
 		parent = child;
 		goto down;
@@ -1419,14 +1412,42 @@ down:
 up:
 		continue;
 	}
-	(*up)(parent, cpu, sd);
+	ret = (*up)(parent, data);
+	if (ret)
+		goto out_unlock;
 
 	child = parent;
 	parent = parent->parent;
 	if (parent)
 		goto up;
+out_unlock:
 	rcu_read_unlock();
+
+	return ret;
+}
+
+static int tg_nop(struct task_group *tg, void *data)
+{
+	return 0;
 }
+#endif
+
+#ifdef CONFIG_SMP
+static unsigned long source_load(int cpu, int type);
+static unsigned long target_load(int cpu, int type);
+static int task_hot(struct task_struct *p, u64 now, struct sched_domain *sd);
+
+static unsigned long cpu_avg_load_per_task(int cpu)
+{
+	struct rq *rq = cpu_rq(cpu);
+
+	if (rq->nr_running)
+		rq->avg_load_per_task = rq->load.weight / rq->nr_running;
+
+	return rq->avg_load_per_task;
+}
+
+#ifdef CONFIG_FAIR_GROUP_SCHED
 
 static void __set_se_shares(struct sched_entity *se, unsigned long shares);
 
@@ -1486,11 +1507,11 @@ __update_group_shares_cpu(struct task_gr
  * This needs to be done in a bottom-up fashion because the rq weight of a
  * parent group depends on the shares of its child groups.
  */
-static void
-tg_shares_up(struct task_group *tg, int cpu, struct sched_domain *sd)
+static int tg_shares_up(struct task_group *tg, void *data)
 {
 	unsigned long rq_weight = 0;
 	unsigned long shares = 0;
+	struct sched_domain *sd = data;
 	int i;
 
 	for_each_cpu_mask(i, sd->span) {
@@ -1515,6 +1536,8 @@ tg_shares_up(struct task_group *tg, int 
 		__update_group_shares_cpu(tg, i, shares, rq_weight);
 		spin_unlock_irqrestore(&rq->lock, flags);
 	}
+
+	return 0;
 }
 
 /*
@@ -1522,10 +1545,10 @@ tg_shares_up(struct task_group *tg, int 
  * This needs to be done in a top-down fashion because the load of a child
  * group is a fraction of its parents load.
  */
-static void
-tg_load_down(struct task_group *tg, int cpu, struct sched_domain *sd)
+static int tg_load_down(struct task_group *tg, void *data)
 {
 	unsigned long load;
+	long cpu = (long)data;
 
 	if (!tg->parent) {
 		load = cpu_rq(cpu)->load.weight;
@@ -1536,11 +1559,8 @@ tg_load_down(struct task_group *tg, int 
 	}
 
 	tg->cfs_rq[cpu]->h_load = load;
-}
 
-static void
-tg_nop(struct task_group *tg, int cpu, struct sched_domain *sd)
-{
+	return 0;
 }
 
 static void update_shares(struct sched_domain *sd)
@@ -1550,7 +1570,7 @@ static void update_shares(struct sched_d
 
 	if (elapsed >= (s64)(u64)sysctl_sched_shares_ratelimit) {
 		sd->last_update = now;
-		walk_tg_tree(tg_nop, tg_shares_up, 0, sd);
+		walk_tg_tree(tg_nop, tg_shares_up, sd);
 	}
 }
 
@@ -1561,9 +1581,9 @@ static void update_shares_locked(struct 
 	spin_lock(&rq->lock);
 }
 
-static void update_h_load(int cpu)
+static void update_h_load(long cpu)
 {
-	walk_tg_tree(tg_load_down, tg_nop, cpu, NULL);
+	walk_tg_tree(tg_load_down, tg_nop, (void *)cpu);
 }
 
 #else

-- 

