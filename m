Return-Path: <linux-kernel-owner+w=401wt.eu-S1760109AbYAFQZw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760109AbYAFQZw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jan 2008 11:25:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757990AbYAFQXY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Jan 2008 11:23:24 -0500
Received: from viefep18-int.chello.at ([213.46.255.22]:10270 "EHLO
	viefep34-int.chello.at" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757068AbYAFQXS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jan 2008 11:23:18 -0500
Message-Id: <20080106162124.523142000@chello.nl>
References: <20080106161128.152634000@chello.nl>
User-Agent: quilt/0.45-1
Date: Sun, 06 Jan 2008 17:11:37 +0100
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Balbir Singh <balbir@linux.vnet.ibm.com>,
       dmitry.adamushko@gmail.com,
       Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       Gregory Haskins <ghaskins@novell.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH 09/11] sched: rt-group: dynamic period ticks
Content-Disposition: inline; filename=sched-rt-rq-dyn.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Disable the period updates for inactive groups.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 kernel/sched.c    |  158 ------------------------------------------------------
 kernel/sched_rt.c |   54 ++++++++++++++++++
 2 files changed, 53 insertions(+), 159 deletions(-)

Index: linux-2.6/kernel/sched.c
===================================================================
--- linux-2.6.orig/kernel/sched.c
+++ linux-2.6/kernel/sched.c
@@ -5277,158 +5277,6 @@ static inline void sched_init_granularit
 	sysctl_sched_batch_wakeup_granularity *= factor;
 }
 
-static enum hrtimer_restart sched_rt_period_timer(struct hrtimer *timer)
-{
-	struct rt_rq *rt_rq =
-		container_of(timer, struct rt_rq, rt_period_timer);
-	struct rq *rq = rq_of_rt_rq(rt_rq);
-	ktime_t now = ktime_get();
-
-	WARN_ON(smp_processor_id() != cpu_of(rq));
-	WARN_ON(!in_irq());
-
-	spin_lock(&rq->lock);
-	update_sched_rt_period(rt_rq);
-	spin_unlock(&rq->lock);
-
-	hrtimer_forward(timer, now, sched_rt_period(rt_rq));
-	return HRTIMER_RESTART;
-}
-
-static void sched_rt_period_start(struct rt_rq *rt_rq)
-{
-	ktime_t period = sched_rt_period(rt_rq);
-
-	WARN_ON(smp_processor_id() != cpu_of(rq_of_rt_rq(rt_rq)));
-
-	for (;;) {
-		ktime_t now = ktime_get();
-		hrtimer_forward(&rt_rq->rt_period_timer, now, period);
-		hrtimer_start(&rt_rq->rt_period_timer,
-				rt_rq->rt_period_timer.expires,
-				HRTIMER_MODE_ABS);
-		if (hrtimer_active(&rt_rq->rt_period_timer))
-			break;
-	}
-}
-
-#if defined CONFIG_SMP || defined CONFIG_FAIR_GROUP_SCHED
-static void sched_rt_period_stop(struct rt_rq *rt_rq)
-{
-	hrtimer_cancel(&rt_rq->rt_period_timer);
-}
-#endif
-
-static void sched_rt_period_start_cpu(int cpu)
-{
-	struct rq *rq = cpu_rq(cpu);
-	struct rt_rq *rt_rq;
-
-	for_each_leaf_rt_rq(rt_rq, rq)
-		sched_rt_period_start(rt_rq);
-}
-
-#ifdef CONFIG_SMP
-static void sched_rt_period_stop_cpu(int cpu)
-{
-	struct rq *rq = cpu_rq(cpu);
-	struct rt_rq *rt_rq;
-
-	for_each_leaf_rt_rq(rt_rq, rq)
-		sched_rt_period_stop(rt_rq);
-}
-
-static int sched_rt_period_hotplug(struct notifier_block *nfb,
-		unsigned long action, void *hcpu)
-{
-	int cpu = (unsigned long)hcpu;
-
-	switch (action) {
-	case CPU_UP_PREPARE:
-	case CPU_UP_PREPARE_FROZEN:
-	case CPU_DOWN_FAILED:
-	case CPU_DOWN_FAILED_FROZEN:
-		sched_rt_period_start_cpu(cpu);
-		return NOTIFY_OK;
-
-	case CPU_DOWN_PREPARE:
-	case CPU_DOWN_PREPARE_FROZEN:
-	case CPU_UP_CANCELED:
-	case CPU_UP_CANCELED_FROZEN:
-		sched_rt_period_stop_cpu(cpu);
-		return NOTIFY_OK;
-
-	case CPU_ONLINE:
-	case CPU_ONLINE_FROZEN:
-	case CPU_DEAD:
-	case CPU_DEAD_FROZEN:
-		return NOTIFY_OK;
-
-	default:
-		return NOTIFY_DONE;
-	}
-
-	return NOTIFY_OK;
-}
-
-static void __init __sched_rt_period_init(void *arg)
-{
-	int cpu = smp_processor_id();
-	sched_rt_period_start_cpu(cpu);
-}
-
-static void __init sched_rt_period_init(void)
-{
-	on_each_cpu(__sched_rt_period_init, NULL, 0, 1);
-	hotcpu_notifier(sched_rt_period_hotplug, 0);
-}
-
-#ifdef CONFIG_FAIR_GROUP_SCHED
-static void __sched_rt_period_init_tg(void *arg)
-{
-	struct task_group *tg = arg;
-	int cpu = smp_processor_id();
-
-	sched_rt_period_start(tg->rt_rq[cpu]);
-}
-
-static void sched_rt_period_init_tg(struct task_group *tg)
-{
-	on_each_cpu(__sched_rt_period_init_tg, tg, 0, 1);
-}
-
-static void __sched_rt_period_destroy_tg(void *arg)
-{
-	struct task_group *tg = arg;
-	int cpu = smp_processor_id();
-
-	sched_rt_period_stop(tg->rt_rq[cpu]);
-}
-
-static void sched_rt_period_destroy_tg(struct task_group *tg)
-{
-	on_each_cpu(__sched_rt_period_destroy_tg, tg, 0, 1);
-}
-#endif /* CONFIG_FAIR_GROUP_SCHED */
-#else /* CONFIG_SMP */
-static void __init sched_rt_period_init(void)
-{
-	sched_rt_period_start_cpu(0);
-}
-
-#ifdef CONFIG_FAIR_GROUP_SCHED
-static void sched_rt_period_init_tg(struct task_group *tg)
-{
-	sched_rt_period_start(tg->rt_rq[0]);
-}
-
-static void sched_rt_period_destroy_tg(struct task_group *tg)
-{
-	sched_rt_period_stop(tg->rt_rq[0]);
-}
-#endif /* CONFIG_FAIR_GROUP_SCHED */
-#endif /* CONFIG_SMP */
-
 #ifdef CONFIG_SMP
 /*
  * This is how migration works:
@@ -7210,7 +7058,6 @@ void __init sched_init_smp(void)
 	if (set_cpus_allowed(current, non_isolated_cpus) < 0)
 		BUG();
 	sched_init_granularity();
-	sched_rt_period_init();
 
 #ifdef CONFIG_FAIR_GROUP_SCHED
 	if (nr_cpu_ids == 1)
@@ -7231,7 +7078,6 @@ void __init sched_init_smp(void)
 void __init sched_init_smp(void)
 {
 	sched_init_granularity();
-	sched_rt_period_init();
 }
 #endif /* CONFIG_SMP */
 
@@ -7788,8 +7634,6 @@ struct task_group *sched_create_group(vo
 	list_add_rcu(&tg->list, &task_groups);
 	unlock_task_group_list();
 
-	sched_rt_period_init_tg(tg);
-
 	return tg;
 
 err:
@@ -7811,8 +7655,6 @@ void sched_destroy_group(struct task_gro
 	struct rt_rq *rt_rq = NULL;
 	int i;
 
-	sched_rt_period_destroy_tg(tg);
-
 	lock_task_group_list();
 	for_each_possible_cpu(i) {
 		cfs_rq = tg->cfs_rq[i];
Index: linux-2.6/kernel/sched_rt.c
===================================================================
--- linux-2.6.orig/kernel/sched_rt.c
+++ linux-2.6/kernel/sched_rt.c
@@ -221,8 +221,10 @@ static int sched_rt_ratio_exceeded(struc
 
 	if (rt_rq->rt_time > ratio) {
 		rt_rq->rt_throttled = 1;
-		if (rt_rq_throttled(rt_rq))
+		if (rt_rq_throttled(rt_rq)) {
+			WARN_ON(!hrtimer_active(&rt_rq->rt_period_timer));
 			sched_rt_ratio_dequeue(rt_rq);
+		}
 	}
 
 out:
@@ -242,6 +244,52 @@ static void update_sched_rt_period(struc
 	}
 }
 
+static enum hrtimer_restart sched_rt_period_timer(struct hrtimer *timer)
+{
+	struct rt_rq *rt_rq =
+		container_of(timer, struct rt_rq, rt_period_timer);
+	struct rq *rq = rq_of_rt_rq(rt_rq);
+	ktime_t now = ktime_get();
+
+	WARN_ON(smp_processor_id() != cpu_of(rq));
+	WARN_ON(!in_irq());
+
+	spin_lock(&rq->lock);
+	update_sched_rt_period(rt_rq);
+	spin_unlock(&rq->lock);
+
+	hrtimer_forward(timer, now, sched_rt_period(rt_rq));
+
+	return HRTIMER_RESTART;
+}
+
+static void sched_rt_period_start(struct rt_rq *rt_rq)
+{
+	ktime_t period;
+
+	WARN_ON(smp_processor_id() != cpu_of(rq_of_rt_rq(rt_rq)));
+
+	if (hrtimer_active(&rt_rq->rt_period_timer))
+		return;
+
+	period = sched_rt_period(rt_rq);
+
+	for (;;) {
+		ktime_t now = ktime_get();
+		hrtimer_forward(&rt_rq->rt_period_timer, now, period);
+		hrtimer_start(&rt_rq->rt_period_timer,
+				rt_rq->rt_period_timer.expires,
+				HRTIMER_MODE_ABS);
+		if (hrtimer_active(&rt_rq->rt_period_timer))
+			break;
+	}
+}
+
+static void sched_rt_period_stop(struct rt_rq *rt_rq)
+{
+	hrtimer_cancel(&rt_rq->rt_period_timer);
+}
+
 /*
  * Update the current task's runtime statistics. Skip current tasks that
  * are not in our scheduling class.
@@ -274,6 +322,8 @@ static inline
 void inc_rt_tasks(struct sched_rt_entity *rt_se, struct rt_rq *rt_rq)
 {
 	WARN_ON(!rt_prio(rt_se_prio(rt_se)));
+	if (!rt_rq->rt_nr_running && !group_rt_rq(rt_se))
+		sched_rt_period_start(rt_rq);
 	rt_rq->rt_nr_running++;
 #if defined CONFIG_SMP || defined CONFIG_FAIR_GROUP_SCHED
 	if (rt_se_prio(rt_se) < rt_rq->highest_prio)
@@ -299,6 +349,8 @@ void dec_rt_tasks(struct sched_rt_entity
 	WARN_ON(!rt_prio(rt_se_prio(rt_se)));
 	WARN_ON(!rt_rq->rt_nr_running);
 	rt_rq->rt_nr_running--;
+	if (!rt_rq->rt_nr_running && !group_rt_rq(rt_se))
+		sched_rt_period_stop(rt_rq);
 #if defined CONFIG_SMP || defined CONFIG_FAIR_GROUP_SCHED
 	if (rt_rq->rt_nr_running) {
 		struct rt_prio_array *array;

--

