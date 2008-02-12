Return-Path: <linux-kernel-owner+w=401wt.eu-S1760897AbYBLNAP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760897AbYBLNAP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2008 08:00:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754600AbYBLNAA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Feb 2008 08:00:00 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:40618 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751868AbYBLM76 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2008 07:59:58 -0500
Subject: [RFC][PATCH] sched: fair-group: load_balance_monitor vs wakeups
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Ingo Molnar <mingo@elte.hu>, Arjan van de Ven <arjan@infradead.org>,
       vatsa <vatsa@linux.vnet.ibm.com>,
       Dhaval Giani <dhaval@linux.vnet.ibm.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Tue, 12 Feb 2008 13:59:38 +0100
Message-Id: <1202821178.6247.21.camel@lappy>
Mime-Version: 1.0
X-Mailer: Evolution 2.21.90 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


The biggest issue with load_balance_monitor atm is that it never goes
to sleep, and generates a huge amount of wakeups, even on idle systems.

I tried doing a simple interruptible sleep on idle, but wake_up_process
can't be used while holding the rq lock, so that didn't quite work out.

The next option was turning it into a timer, this does work however it
now runs from hardirq context and I worry that it might be too heavy,
esp on larger boxen.

However, if we split the global lb_monitor into a per root-domain monitor
I think it might be doable,.. thoughts?

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 kernel/sched.c      |  268 +++++++++++++++++++++++++++++++---------------------
 kernel/sched_fair.c |    3 
 2 files changed, 163 insertions(+), 108 deletions(-)

Index: linux-2.6/kernel/sched.c
===================================================================
--- linux-2.6.orig/kernel/sched.c
+++ linux-2.6/kernel/sched.c
@@ -337,11 +337,112 @@ static DEFINE_SPINLOCK(task_group_lock);
 /* doms_cur_mutex serializes access to doms_cur[] array */
 static DEFINE_MUTEX(doms_cur_mutex);
 
+/*
+ * Tunables that become constants when CONFIG_SCHED_DEBUG is off:
+ */
+#ifdef CONFIG_SCHED_DEBUG
+# define const_debug __read_mostly
+#else
+# define const_debug static const
+#endif
+
 #ifdef CONFIG_FAIR_GROUP_SCHED
 #ifdef CONFIG_SMP
 /* kernel thread that runs rebalance_shares() periodically */
-static struct task_struct *lb_monitor_task;
-static int load_balance_monitor(void *unused);
+
+struct lb_monitor {
+	struct hrtimer timer;
+	ktime_t timeout;
+	spinlock_t lock;
+};
+
+static struct lb_monitor lb_monitor;
+
+/*
+ * How frequently should we rebalance_shares() across cpus?
+ *
+ * The more frequently we rebalance shares, the more accurate is the fairness
+ * of cpu bandwidth distribution between task groups. However higher frequency
+ * also implies increased scheduling overhead.
+ *
+ * sysctl_sched_min_bal_int_shares represents the minimum interval between
+ * consecutive calls to rebalance_shares() in the same sched domain.
+ *
+ * sysctl_sched_max_bal_int_shares represents the maximum interval between
+ * consecutive calls to rebalance_shares() in the same sched domain.
+ *
+ * These settings allows for the appropriate trade-off between accuracy of
+ * fairness and the associated overhead.
+ *
+ */
+
+/* default: 8ms, units: milliseconds */
+const_debug unsigned int sysctl_sched_min_bal_int_shares = 8;
+
+/* default: 128ms, units: milliseconds */
+const_debug unsigned int sysctl_sched_max_bal_int_shares = 128;
+
+enum {
+	shares_idle,		/* nothing to balance */
+	shares_balanced,	/* it was in balance */
+	shares_unbalanced,	/* it needed balancing */
+};
+
+static int load_balance_shares(struct lb_monitor *lb_monitor);
+
+static enum hrtimer_restart lb_monitor_timer(struct hrtimer *timer)
+{
+	int state = shares_idle;
+	struct lb_monitor *lb_monitor =
+		container_of(timer, struct lb_monitor, timer);
+
+	for (;;) {
+		ktime_t now = hrtimer_cb_get_time(timer);
+		int overrun = hrtimer_forward(timer, now, lb_monitor->timeout);
+
+		if (!overrun)
+			break;
+
+		state = load_balance_shares(lb_monitor);
+	}
+
+	return (state == shares_idle) ? HRTIMER_NORESTART : HRTIMER_RESTART;
+}
+
+static void lb_monitor_wake(struct lb_monitor *lb_monitor)
+{
+	ktime_t now;
+
+	if (hrtimer_active(&lb_monitor->timer))
+		return;
+
+	if (nr_cpu_ids == 1)
+		return;
+
+	spin_lock(&lb_monitor->lock);
+	for (;;) {
+		if (hrtimer_active(&lb_monitor->timer))
+			break;
+
+		now = hrtimer_cb_get_time(&lb_monitor->timer);
+		hrtimer_forward(&lb_monitor->timer, now, lb_monitor->timeout);
+		hrtimer_start(&lb_monitor->timer, lb_monitor->timer.expires,
+				HRTIMER_MODE_ABS);
+	}
+	spin_unlock(&lb_monitor->lock);
+}
+
+static void lb_monitor_init(struct lb_monitor *lb_monitor)
+{
+	hrtimer_init(&lb_monitor->timer, CLOCK_MONOTONIC, HRTIMER_MODE_REL);
+	lb_monitor->timer.function = lb_monitor_timer;
+	lb_monitor->timer.cb_mode = HRTIMER_CB_IRQSAFE_NO_SOFTIRQ;
+
+	lb_monitor->timeout = ns_to_ktime((u64)sysctl_sched_min_bal_int_shares *
+			NSEC_PER_MSEC);
+
+	spin_lock_init(&lb_monitor->lock);
+}
 #endif
 
 static void set_se_shares(struct sched_entity *se, unsigned long shares);
@@ -699,15 +800,6 @@ static void update_rq_clock(struct rq *r
 #define cpu_curr(cpu)		(cpu_rq(cpu)->curr)
 
 /*
- * Tunables that become constants when CONFIG_SCHED_DEBUG is off:
- */
-#ifdef CONFIG_SCHED_DEBUG
-# define const_debug __read_mostly
-#else
-# define const_debug static const
-#endif
-
-/*
  * Debugging: various feature bits
  */
 enum {
@@ -7157,21 +7249,6 @@ void __init sched_init_smp(void)
 	if (set_cpus_allowed(current, non_isolated_cpus) < 0)
 		BUG();
 	sched_init_granularity();
-
-#ifdef CONFIG_FAIR_GROUP_SCHED
-	if (nr_cpu_ids == 1)
-		return;
-
-	lb_monitor_task = kthread_create(load_balance_monitor, NULL,
-					 "group_balance");
-	if (!IS_ERR(lb_monitor_task)) {
-		lb_monitor_task->flags |= PF_NOFREEZE;
-		wake_up_process(lb_monitor_task);
-	} else {
-		printk(KERN_ERR "Could not create load balance monitor thread"
-			"(error = %ld) \n", PTR_ERR(lb_monitor_task));
-	}
-#endif
 }
 #else
 void __init sched_init_smp(void)
@@ -7278,8 +7355,11 @@ void __init sched_init(void)
 
 #ifdef CONFIG_SMP
 	init_defrootdomain();
-#endif
 
+#ifdef CONFIG_FAIR_GROUP_SCHED
+	lb_monitor_init(&lb_monitor);
+#endif
+#endif
 	init_rt_bandwidth(&def_rt_bandwidth,
 			global_rt_period(), global_rt_runtime());
 
@@ -7513,7 +7593,7 @@ static int rebalance_shares(struct sched
 	struct cfs_rq *cfs_rq;
 	struct rq *rq = cpu_rq(this_cpu);
 	cpumask_t sdspan = sd->span;
-	int balanced = 1;
+	int state = shares_idle;
 
 	/* Walk thr' all the task groups that we have */
 	for_each_leaf_cfs_rq(rq, cfs_rq) {
@@ -7529,6 +7609,8 @@ static int rebalance_shares(struct sched
 		if (!total_load)
 			continue;
 
+		state = max(state, shares_balanced);
+
 		/*
 		 * tg->shares represents the number of cpu shares the task group
 		 * is eligible to hold on a single cpu. On N cpus, it is
@@ -7550,108 +7632,78 @@ static int rebalance_shares(struct sched
 			if (local_shares == tg->se[i]->load.weight)
 				continue;
 
-			spin_lock_irq(&cpu_rq(i)->lock);
+			spin_lock(&cpu_rq(i)->lock);
 			set_se_shares(tg->se[i], local_shares);
-			spin_unlock_irq(&cpu_rq(i)->lock);
-			balanced = 0;
+			spin_unlock(&cpu_rq(i)->lock);
+			state = shares_unbalanced;
 		}
 	}
 
-	return balanced;
+	return state;
 }
 
-/*
- * How frequently should we rebalance_shares() across cpus?
- *
- * The more frequently we rebalance shares, the more accurate is the fairness
- * of cpu bandwidth distribution between task groups. However higher frequency
- * also implies increased scheduling overhead.
- *
- * sysctl_sched_min_bal_int_shares represents the minimum interval between
- * consecutive calls to rebalance_shares() in the same sched domain.
- *
- * sysctl_sched_max_bal_int_shares represents the maximum interval between
- * consecutive calls to rebalance_shares() in the same sched domain.
- *
- * These settings allows for the appropriate trade-off between accuracy of
- * fairness and the associated overhead.
- *
- */
-
-/* default: 8ms, units: milliseconds */
-const_debug unsigned int sysctl_sched_min_bal_int_shares = 8;
-
-/* default: 128ms, units: milliseconds */
-const_debug unsigned int sysctl_sched_max_bal_int_shares = 128;
-
-/* kernel thread that runs rebalance_shares() periodically */
-static int load_balance_monitor(void *unused)
+static int load_balance_shares(struct lb_monitor *lb_monitor)
 {
-	unsigned int timeout = sysctl_sched_min_bal_int_shares;
-	struct sched_param schedparm;
-	int ret;
+	int i, cpu, state = shares_idle;
+	u64 max_timeout = (u64)sysctl_sched_max_bal_int_shares * NSEC_PER_MSEC;
+	u64 min_timeout = (u64)sysctl_sched_min_bal_int_shares * NSEC_PER_MSEC;
+	u64 timeout;
 
+	/* Prevent cpus going down or coming up */
+	/* get_online_cpus(); */
+	/* lockout changes to doms_cur[] array */
+	/* lock_doms_cur(); */
 	/*
-	 * We don't want this thread's execution to be limited by the shares
-	 * assigned to default group (init_task_group). Hence make it run
-	 * as a SCHED_RR RT task at the lowest priority.
-	 */
-	schedparm.sched_priority = 1;
-	ret = sched_setscheduler(current, SCHED_RR, &schedparm);
-	if (ret)
-		printk(KERN_ERR "Couldn't set SCHED_RR policy for load balance"
-				" monitor thread (error = %d) \n", ret);
-
-	while (!kthread_should_stop()) {
-		int i, cpu, balanced = 1;
+	 * Enter a rcu read-side critical section to safely walk rq->sd
+	 * chain on various cpus and to walk task group list
+	 * (rq->leaf_cfs_rq_list) in rebalance_shares().
+	 */
+	rcu_read_lock();
 
-		/* Prevent cpus going down or coming up */
-		get_online_cpus();
-		/* lockout changes to doms_cur[] array */
-		lock_doms_cur();
-		/*
-		 * Enter a rcu read-side critical section to safely walk rq->sd
-		 * chain on various cpus and to walk task group list
-		 * (rq->leaf_cfs_rq_list) in rebalance_shares().
-		 */
-		rcu_read_lock();
+	for (i = 0; i < ndoms_cur; i++) {
+		cpumask_t cpumap = doms_cur[i];
+		struct sched_domain *sd = NULL, *sd_prev = NULL;
 
-		for (i = 0; i < ndoms_cur; i++) {
-			cpumask_t cpumap = doms_cur[i];
-			struct sched_domain *sd = NULL, *sd_prev = NULL;
-
-			cpu = first_cpu(cpumap);
-
-			/* Find the highest domain at which to balance shares */
-			for_each_domain(cpu, sd) {
-				if (!(sd->flags & SD_LOAD_BALANCE))
-					continue;
-				sd_prev = sd;
-			}
+		cpu = first_cpu(cpumap);
 
-			sd = sd_prev;
-			/* sd == NULL? No load balance reqd in this domain */
-			if (!sd)
+		/* Find the highest domain at which to balance shares */
+		for_each_domain(cpu, sd) {
+			if (!(sd->flags & SD_LOAD_BALANCE))
 				continue;
-
-			balanced &= rebalance_shares(sd, cpu);
+			sd_prev = sd;
 		}
 
-		rcu_read_unlock();
+		sd = sd_prev;
+		/* sd == NULL? No load balance reqd in this domain */
+		if (!sd)
+			continue;
 
-		unlock_doms_cur();
-		put_online_cpus();
+		state = max(state, rebalance_shares(sd, cpu));
+	}
 
-		if (!balanced)
-			timeout = sysctl_sched_min_bal_int_shares;
-		else if (timeout < sysctl_sched_max_bal_int_shares)
+	rcu_read_unlock();
+
+	/* unlock_doms_cur(); */
+	/* put_online_cpus(); */
+
+	timeout = ktime_to_ns(lb_monitor->timeout);
+	switch (state) {
+	case shares_balanced:
+		if (timeout < max_timeout)
 			timeout *= 2;
+		break;
 
-		msleep_interruptible(timeout);
+	default:
+		timeout = min_timeout;
+		break;
 	}
+	lb_monitor->timeout = ns_to_ktime(timeout);
+
+	printk(KERN_EMERG "load_balance_shares: %p %d\n", lb_monitor, state);
 
-	return 0;
+	return state;
 }
+
 #endif	/* CONFIG_SMP */
 
 #ifdef CONFIG_FAIR_GROUP_SCHED
Index: linux-2.6/kernel/sched_fair.c
===================================================================
--- linux-2.6.orig/kernel/sched_fair.c
+++ linux-2.6/kernel/sched_fair.c
@@ -548,6 +548,9 @@ account_entity_enqueue(struct cfs_rq *cf
 	cfs_rq->nr_running++;
 	se->on_rq = 1;
 	list_add(&se->group_node, &cfs_rq->tasks);
+#if defined(CONFIG_FAIR_GROUP_SCHED) && defined(CONFIG_SMP)
+	lb_monitor_wake(&lb_monitor);
+#endif
 }
 
 static void


