Return-Path: <linux-kernel-owner+w=401wt.eu-S1753984AbZKPRTI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753984AbZKPRTI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Nov 2009 12:19:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753740AbZKPRTG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Nov 2009 12:19:06 -0500
Received: from hera.kernel.org ([140.211.167.34]:33482 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753299AbZKPRTD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Nov 2009 12:19:03 -0500
From: Tejun Heo <tj@kernel.org>
To: linux-kernel@vger.kernel.org, jeff@garzik.org, mingo@elte.hu,
       akpm@linux-foundation.org, jens.axboe@oracle.com, rusty@rustcorp.com.au,
       cl@linux-foundation.org, dhowells@redhat.com, arjan@linux.intel.com,
       torvalds@linux-foundation.org, avi@redhat.com, peterz@infradead.org,
       andi@firstfloor.org, fweisbec@gmail.com
Cc: Tejun Heo <tj@kernel.org>
Subject: [PATCH 04/21] sched: implement scheduler notifiers
Date: Tue, 17 Nov 2009 02:15:09 +0900
Message-Id: <1258391726-30264-5-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.6.4.2
In-Reply-To: <1258391726-30264-1-git-send-email-tj@kernel.org>
References: <1258391726-30264-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Implement scheduler notifiers.  This is superset of preempt notifiers
which will be removed in favor of new notifiers.  Four notifications
are defined - activated, deactivated, in and out.  In and out are
identical to preempt notifiers.  Activated and deactivated are called
when a task's readiness to run changes.  The first three are always
called under rq lock.  Out may not be called under rq lock depending
on architecture.

The notifier block contains union of all four callbacks to avoid
defining separate interface for each.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 include/linux/sched.h |   33 +++++++++++++++++++++++++++++
 kernel/sched.c        |   54 +++++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 87 insertions(+), 0 deletions(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index 75e6e60..0012980 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1210,6 +1210,37 @@ struct sched_rt_entity {
 #endif
 };
 
+/*
+ * Scheduler notifiers
+ *
+ * All notifications other than OUT are guaranteed to be called with
+ * the respective rq lock held.  Depending on architecture
+ * (__ARCH_WANT_UNLOCKED_CTXSW), OUT might be called without the rq
+ * lock but task->oncpu is guaranteed to be true.
+ */
+enum sched_notifier_type {
+	SCHED_NOTIFIER_ACTIVATED,	/* put on runqueue */
+	SCHED_NOTIFIER_DEACTIVATED,	/* removed from runqueue */
+	SCHED_NOTIFIER_IN,		/* occupying CPU */
+	SCHED_NOTIFIER_OUT,		/* leaving CPU */
+
+	SCHED_NR_NOTIFIERS,
+};
+
+struct sched_notifier {
+	struct hlist_node	link;
+	union {
+		void (*activated)(struct sched_notifier *n, bool wakeup);
+		void (*deactivated)(struct sched_notifier *n, bool sleep);
+		void (*in)(struct sched_notifier *n, struct task_struct *prev);
+		void (*out)(struct sched_notifier *n, struct task_struct *next);
+	};
+};
+
+void sched_notifier_register(enum sched_notifier_type type,
+			     struct sched_notifier *notifier);
+void sched_notifier_unregister(struct sched_notifier *notifier);
+
 struct rcu_node;
 
 struct task_struct {
@@ -1237,6 +1268,8 @@ struct task_struct {
 	/* list of struct preempt_notifier: */
 	struct hlist_head preempt_notifiers;
 #endif
+	/* sched notifiers */
+	struct hlist_head notifiers[SCHED_NR_NOTIFIERS];
 
 	/*
 	 * fpu_counter contains the number of consecutive context switches
diff --git a/kernel/sched.c b/kernel/sched.c
index de8a765..946c7a8 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -1389,6 +1389,20 @@ static const u32 prio_to_wmult[40] = {
  /*  15 */ 119304647, 148102320, 186737708, 238609294, 286331153,
 };
 
+#define sched_notifier_for_each(notifier, pos, p, type)			\
+	hlist_for_each_entry((notifier), (pos),				\
+			     &(p)->notifiers[(type)], link)
+
+#define sched_notifier_call(p, type, callback, args...) do {		\
+	struct task_struct *__p = (p);					\
+	struct sched_notifier *__notifier;				\
+	struct hlist_node *__pos;					\
+									\
+	if (unlikely(!hlist_empty(&__p->notifiers[(type)])))		\
+		sched_notifier_for_each(__notifier, __pos, __p, (type))	\
+			__notifier->callback(__notifier , ##args);	\
+} while (0)
+
 static void activate_task(struct rq *rq, struct task_struct *p, int wakeup);
 
 /*
@@ -1939,6 +1953,8 @@ static int effective_prio(struct task_struct *p)
  */
 static void activate_task(struct rq *rq, struct task_struct *p, int wakeup)
 {
+	sched_notifier_call(p, SCHED_NOTIFIER_ACTIVATED, activated, wakeup);
+
 	if (task_contributes_to_load(p))
 		rq->nr_uninterruptible--;
 
@@ -1951,6 +1967,8 @@ static void activate_task(struct rq *rq, struct task_struct *p, int wakeup)
  */
 static void deactivate_task(struct rq *rq, struct task_struct *p, int sleep)
 {
+	sched_notifier_call(p, SCHED_NOTIFIER_DEACTIVATED, deactivated, sleep);
+
 	if (task_contributes_to_load(p))
 		rq->nr_uninterruptible++;
 
@@ -2478,6 +2496,8 @@ int wake_up_state(struct task_struct *p, unsigned int state)
  */
 static void __sched_fork(struct task_struct *p)
 {
+	int i;
+
 	p->se.exec_start		= 0;
 	p->se.sum_exec_runtime		= 0;
 	p->se.prev_sum_exec_runtime	= 0;
@@ -2529,6 +2549,8 @@ static void __sched_fork(struct task_struct *p)
 #ifdef CONFIG_PREEMPT_NOTIFIERS
 	INIT_HLIST_HEAD(&p->preempt_notifiers);
 #endif
+	for (i = 0; i < SCHED_NR_NOTIFIERS; i++)
+		INIT_HLIST_HEAD(&p->notifiers[i]);
 
 	/*
 	 * We mark the process as running here, but have not actually
@@ -2709,6 +2731,7 @@ static inline void
 prepare_task_switch(struct rq *rq, struct task_struct *prev,
 		    struct task_struct *next)
 {
+	sched_notifier_call(prev, SCHED_NOTIFIER_OUT, out, next);
 	fire_sched_out_preempt_notifiers(prev, next);
 	prepare_lock_switch(rq, next);
 	prepare_arch_switch(next);
@@ -2751,6 +2774,7 @@ static void finish_task_switch(struct rq *rq, struct task_struct *prev)
 	prev_state = prev->state;
 	finish_arch_switch(prev);
 	perf_event_task_sched_in(current, cpu_of(rq));
+	sched_notifier_call(current, SCHED_NOTIFIER_IN, in, prev);
 	fire_sched_in_preempt_notifiers(current);
 	finish_lock_switch(rq, prev);
 
@@ -7399,6 +7423,34 @@ static void calc_global_load_remove(struct rq *rq)
 }
 #endif /* CONFIG_HOTPLUG_CPU */
 
+/**
+ * sched_notifier_register - register a sched_notifier
+ * @type: type of sched_notifier to register
+ * @notifier: sched_notifier to register
+ *
+ * Register @notifier of @type to the current task.
+ */
+void sched_notifier_register(enum sched_notifier_type type,
+			     struct sched_notifier *notifier)
+{
+	BUG_ON(type < 0 || type >= SCHED_NR_NOTIFIERS);
+	hlist_add_head(&notifier->link, &current->notifiers[type]);
+}
+EXPORT_SYMBOL_GPL(sched_notifier_register);
+
+/**
+ * sched_notifier_unregister - unregister a sched_notifier
+ * @notifier: sched_notifier to unregister
+ *
+ * Unregister @notifier from the current task.  This function must be
+ * called from the task @notifier is registered to.
+ */
+void sched_notifier_unregister(struct sched_notifier *notifier)
+{
+	hlist_del_init(&notifier->link);
+}
+EXPORT_SYMBOL_GPL(sched_notifier_unregister);
+
 #if defined(CONFIG_SCHED_DEBUG) && defined(CONFIG_SYSCTL)
 
 static struct ctl_table sd_ctl_dir[] = {
@@ -9534,6 +9586,8 @@ void __init sched_init(void)
 #ifdef CONFIG_PREEMPT_NOTIFIERS
 	INIT_HLIST_HEAD(&init_task.preempt_notifiers);
 #endif
+	for (i = 0; i < SCHED_NR_NOTIFIERS; i++)
+		INIT_HLIST_HEAD(&init_task.notifiers[i]);
 
 #ifdef CONFIG_SMP
 	open_softirq(SCHED_SOFTIRQ, run_rebalance_domains);
-- 
1.6.4.2

