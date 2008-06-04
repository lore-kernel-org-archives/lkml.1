Return-Path: <linux-kernel-owner+w=401wt.eu-S1759313AbYFDTgj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759313AbYFDTgj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2008 15:36:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762050AbYFDTgU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Jun 2008 15:36:20 -0400
Received: from 66-189-124-104.dhcp.oxfr.ma.charter.com ([66.189.124.104]:40162
	"EHLO novell1.haskins.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1760403AbYFDTgS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2008 15:36:18 -0400
From: Gregory Haskins <ghaskins@novell.com>
Subject: [PATCH 1/2] sched: fix cpupri hotplug support
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutonix.de>,
       Steven Rostedt <rostedt@goodmis.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Gregory Haskins <ghaskins@novell.com>, linux-kernel@vger.kernel.org,
       linux-rt-users@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>
Date: Wed, 04 Jun 2008 15:04:05 -0400
Message-ID: <20080604190405.5108.89979.stgit@novell1.haskins.net>
In-Reply-To: <20080604185838.5108.54912.stgit@novell1.haskins.net>
References: <20080604185838.5108.54912.stgit@novell1.haskins.net>
User-Agent: StGIT/0.12.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The RT folks over at RedHat found an issue w.r.t. hotplug support which
was traced to problems with the cpupri infrastructure in the scheduler:

https://bugzilla.redhat.com/show_bug.cgi?id=449676

This bug affects 23-rt12+, 24-rtX, 25-rtX, and sched-devel.  This patch
applies to 25.4-rt4, though it should trivially apply to most cpupri enabled
kernels mentioned above.

It turned out that the issue was that offline cpus could get inadvertently
registered with cpupri so that they were erroneously selected during
migration decisions.  The end result would be an OOPS as the offline cpu
had tasks routed to it.

This patch generalizes the old join/leave domain interface into an 
online/offline interface, and adjusts the root-domain/hotplug code to
utilize it.

I was able to easily reproduce the issue prior to this patch, and am no
longer able to reproduce it after this patch.  I can offline cpus
indefinately and everything seems to be in working order.

Thanks to Arnaldo (acme), Thomas, and Peter for doing the legwork to point
me in the right direction.  Also thank you to Peter for reviewing the
early iterations of this patch.

Signed-off-by: Gregory Haskins <ghaskins@novell.com>
CC: Ingo Molnar <mingo@elte.hu>
CC: Thomas Gleixner <tglx@linutonix.de>
CC: Steven Rostedt <rostedt@goodmis.org>
CC: Arnaldo Carvalho de Melo <acme@redhat.com>
CC: Peter Zijlstra <peterz@infradead.org>
---

 include/linux/sched.h |    4 ++--
 kernel/sched.c        |   54 ++++++++++++++++++++++++++++++++++++-------------
 kernel/sched_rt.c     |   24 ++++++++++++++++------
 3 files changed, 60 insertions(+), 22 deletions(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index bb71371..3b6fab8 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -968,8 +968,8 @@ struct sched_class {
 	void (*task_new) (struct rq *rq, struct task_struct *p);
 	void (*set_cpus_allowed)(struct task_struct *p, cpumask_t *newmask);
 
-	void (*join_domain)(struct rq *rq);
-	void (*leave_domain)(struct rq *rq);
+	void (*rq_online)(struct rq *rq);
+	void (*rq_offline)(struct rq *rq);
 
 	void (*switched_from) (struct rq *this_rq, struct task_struct *task,
 			       int running);
diff --git a/kernel/sched.c b/kernel/sched.c
index 0399411..31f91d9 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -489,6 +489,7 @@ struct rq {
 	int push_cpu;
 	/* cpu of this runqueue: */
 	int cpu;
+	int online;
 
 	struct task_struct *migration_thread;
 	struct list_head migration_queue;
@@ -1320,6 +1321,8 @@ static int task_hot(struct task_struct *p, u64 now, struct sched_domain *sd);
 #endif
 
 #define sched_class_highest (&rt_sched_class)
+#define for_each_class(class) \
+   for (class = sched_class_highest; class; class = class->next)
 
 static inline void inc_load(struct rq *rq, const struct task_struct *p)
 {
@@ -6278,6 +6281,36 @@ static void unregister_sched_domain_sysctl(void)
 }
 #endif
 
+static void set_rq_online(struct rq *rq)
+{
+	if (!rq->online) {
+		const struct sched_class *class;
+
+		cpu_set(rq->cpu, rq->rd->online);
+		rq->online = 1;
+
+		for_each_class(class) {
+			if (class->rq_online)
+				class->rq_online(rq);
+		}
+	}
+}
+
+static void set_rq_offline(struct rq *rq)
+{
+	if (rq->online) {
+		const struct sched_class *class;
+
+		for_each_class(class) {
+			if (class->rq_offline)
+				class->rq_offline(rq);
+		}
+
+		cpu_clear(rq->cpu, rq->rd->online);
+		rq->online = 0;
+	}
+}
+
 /*
  * migration_call - callback that gets triggered when a CPU is added.
  * Here we can start up the necessary migration thread for the new CPU.
@@ -6315,7 +6348,8 @@ migration_call(struct notifier_block *nfb, unsigned long action, void *hcpu)
 		spin_lock_irqsave(&rq->lock, flags);
 		if (rq->rd) {
 			BUG_ON(!cpu_isset(cpu, rq->rd->span));
-			cpu_set(cpu, rq->rd->online);
+
+			set_rq_online(rq);
 		}
 		spin_unlock_irqrestore(&rq->lock, flags);
 		break;
@@ -6376,7 +6410,7 @@ migration_call(struct notifier_block *nfb, unsigned long action, void *hcpu)
 		spin_lock_irqsave(&rq->lock, flags);
 		if (rq->rd) {
 			BUG_ON(!cpu_isset(cpu, rq->rd->span));
-			cpu_clear(cpu, rq->rd->online);
+			set_rq_offline(rq);
 		}
 		spin_unlock_irqrestore(&rq->lock, flags);
 		break;
@@ -6571,7 +6605,6 @@ sd_parent_degenerate(struct sched_domain *sd, struct sched_domain *parent)
 static void rq_attach_root(struct rq *rq, struct root_domain *rd)
 {
 	unsigned long flags;
-	const struct sched_class *class;
 	struct root_domain *reap = NULL;
 
 	spin_lock_irqsave(&rq->lock, flags);
@@ -6579,13 +6612,10 @@ static void rq_attach_root(struct rq *rq, struct root_domain *rd)
 	if (rq->rd) {
 		struct root_domain *old_rd = rq->rd;
 
-		for (class = sched_class_highest; class; class = class->next) {
-			if (class->leave_domain)
-				class->leave_domain(rq);
-		}
+		if (cpu_isset(rq->cpu, old_rd->online))
+			set_rq_offline(rq);
 
 		cpu_clear(rq->cpu, old_rd->span);
-		cpu_clear(rq->cpu, old_rd->online);
 
 		if (atomic_dec_and_test(&old_rd->refcount))
 			reap = old_rd;
@@ -6596,12 +6626,7 @@ static void rq_attach_root(struct rq *rq, struct root_domain *rd)
 
 	cpu_set(rq->cpu, rd->span);
 	if (cpu_isset(rq->cpu, cpu_online_map))
-		cpu_set(rq->cpu, rd->online);
-
-	for (class = sched_class_highest; class; class = class->next) {
-		if (class->join_domain)
-			class->join_domain(rq);
-	}
+		set_rq_online(rq);
 
 	spin_unlock_irqrestore(&rq->lock, flags);
 
@@ -7692,6 +7717,7 @@ void __init sched_init(void)
 		rq->next_balance = jiffies;
 		rq->push_cpu = 0;
 		rq->cpu = i;
+		rq->online = 0;
 		rq->migration_thread = NULL;
 		INIT_LIST_HEAD(&rq->migration_queue);
 		rq_attach_root(rq, &def_root_domain);
diff --git a/kernel/sched_rt.c b/kernel/sched_rt.c
index 425cf01..9f2d200 100644
--- a/kernel/sched_rt.c
+++ b/kernel/sched_rt.c
@@ -12,6 +12,9 @@ static inline int rt_overloaded(struct rq *rq)
 
 static inline void rt_set_overload(struct rq *rq)
 {
+	if (!rq->online)
+		return;
+
 	cpu_set(rq->cpu, rq->rd->rto_mask);
 	/*
 	 * Make sure the mask is visible before we set
@@ -26,6 +29,9 @@ static inline void rt_set_overload(struct rq *rq)
 
 static inline void rt_clear_overload(struct rq *rq)
 {
+	if (!rq->online)
+		return;
+
 	/* the order here really doesn't matter */
 	atomic_dec(&rq->rd->rto_count);
 	cpu_clear(rq->cpu, rq->rd->rto_mask);
@@ -280,7 +286,10 @@ void inc_rt_tasks(struct sched_rt_entity *rt_se, struct rt_rq *rt_rq)
 	if (rt_se_prio(rt_se) < rt_rq->highest_prio) {
 		struct rq *rq = rq_of_rt_rq(rt_rq);
 		rt_rq->highest_prio = rt_se_prio(rt_se);
-		cpupri_set(&rq->rd->cpupri, rq->cpu, rt_se_prio(rt_se));
+
+		if (rq->online)
+			cpupri_set(&rq->rd->cpupri, rq->cpu,
+				   rt_se_prio(rt_se));
 	}
 #endif
 #ifdef CONFIG_SMP
@@ -330,7 +339,10 @@ void dec_rt_tasks(struct sched_rt_entity *rt_se, struct rt_rq *rt_rq)
 
 	if (rt_rq->highest_prio != highest_prio) {
 		struct rq *rq = rq_of_rt_rq(rt_rq);
-		cpupri_set(&rq->rd->cpupri, rq->cpu, rt_rq->highest_prio);
+
+		if (rq->online)
+			cpupri_set(&rq->rd->cpupri, rq->cpu,
+				   rt_rq->highest_prio);
 	}
 
 	update_rt_migration(rq_of_rt_rq(rt_rq));
@@ -1101,7 +1113,7 @@ static void set_cpus_allowed_rt(struct task_struct *p, cpumask_t *new_mask)
 }
 
 /* Assumes rq->lock is held */
-static void join_domain_rt(struct rq *rq)
+static void rq_online_rt(struct rq *rq)
 {
 	if (rq->rt.overloaded)
 		rt_set_overload(rq);
@@ -1110,7 +1122,7 @@ static void join_domain_rt(struct rq *rq)
 }
 
 /* Assumes rq->lock is held */
-static void leave_domain_rt(struct rq *rq)
+static void rq_offline_rt(struct rq *rq)
 {
 	if (rq->rt.overloaded)
 		rt_clear_overload(rq);
@@ -1278,8 +1290,8 @@ const struct sched_class rt_sched_class = {
 	.load_balance		= load_balance_rt,
 	.move_one_task		= move_one_task_rt,
 	.set_cpus_allowed       = set_cpus_allowed_rt,
-	.join_domain            = join_domain_rt,
-	.leave_domain           = leave_domain_rt,
+	.rq_online              = rq_online_rt,
+	.rq_offline             = rq_offline_rt,
 	.pre_schedule		= pre_schedule_rt,
 	.post_schedule		= post_schedule_rt,
 	.task_wake_up		= task_wake_up_rt,

