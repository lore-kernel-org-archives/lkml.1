Return-Path: <linux-kernel-owner+w=401wt.eu-S1758129AbYHUJTS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758129AbYHUJTS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2008 05:19:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753391AbYHUJTG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Aug 2008 05:19:06 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:35559 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753866AbYHUJTE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2008 05:19:04 -0400
Subject: [PATCH] sched: properly account IRQ and RT load in SCHED_OTHER
	load balancing
From: Peter Zijlstra <peterz@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>,
       Gregory Haskins <ghaskins@novell.com>, vatsa <vatsa@in.ibm.com>,
       linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Thu, 21 Aug 2008 11:18:50 +0200
Message-Id: <1219310330.8651.93.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Subject: sched: properly account IRQ and RT load in SCHED_OTHER load balancing
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
Date: Thu Aug 14 09:31:20 CEST 2008

We used to account for RT tasks in SCHED_OTHER load-balancing by giving
them some phantom weight.

This is incorrect because there is no saying how much time a RT task will
actually consume. Also, it doesn't take IRQ time into account.

This patch tries to solve this issue by accounting the time spend on both
Real-Time tasks and IRQ handling, and using that to proportionally inflate
the SCHED_OTHER load.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 include/linux/hardirq.h |   10 +++
 include/linux/sched.h   |    1 
 kernel/sched.c          |  126 +++++++++++++++++++++++++++++++++++++++++++-----
 kernel/sched_debug.c    |    2 
 kernel/sched_rt.c       |    8 +++
 kernel/softirq.c        |    1 
 kernel/sysctl.c         |    8 +++
 7 files changed, 145 insertions(+), 11 deletions(-)

Index: linux-2.6/include/linux/hardirq.h
===================================================================
--- linux-2.6.orig/include/linux/hardirq.h
+++ linux-2.6/include/linux/hardirq.h
@@ -127,6 +127,14 @@ static inline void account_system_vtime(
 }
 #endif
 
+#ifdef CONFIG_SMP
+extern void sched_irq_enter(void);
+extern void sched_irq_exit(void);
+#else
+# define sched_irq_enter() do { } while (0)
+# define sched_irq_exit() do { } while (0)
+#endif
+
 #if defined(CONFIG_PREEMPT_RCU) && defined(CONFIG_NO_HZ)
 extern void rcu_irq_enter(void);
 extern void rcu_irq_exit(void);
@@ -143,6 +151,7 @@ extern void rcu_irq_exit(void);
  */
 #define __irq_enter()					\
 	do {						\
+		sched_irq_enter();			\
 		rcu_irq_enter();			\
 		account_system_vtime(current);		\
 		add_preempt_count(HARDIRQ_OFFSET);	\
@@ -163,6 +172,7 @@ extern void irq_enter(void);
 		account_system_vtime(current);		\
 		sub_preempt_count(HARDIRQ_OFFSET);	\
 		rcu_irq_exit();				\
+		sched_irq_exit();			\
 	} while (0)
 
 /*
Index: linux-2.6/include/linux/sched.h
===================================================================
--- linux-2.6.orig/include/linux/sched.h
+++ linux-2.6/include/linux/sched.h
@@ -1614,6 +1614,7 @@ extern unsigned int sysctl_sched_feature
 extern unsigned int sysctl_sched_migration_cost;
 extern unsigned int sysctl_sched_nr_migrate;
 extern unsigned int sysctl_sched_shares_ratelimit;
+extern unsigned int sysctl_sched_time_avg;
 
 int sched_nr_latency_handler(struct ctl_table *table, int write,
 		struct file *file, void __user *buffer, size_t *length,
Index: linux-2.6/kernel/sched.c
===================================================================
--- linux-2.6.orig/kernel/sched.c
+++ linux-2.6/kernel/sched.c
@@ -571,6 +571,12 @@ struct rq {
 
 	struct task_struct *migration_thread;
 	struct list_head migration_queue;
+
+	u64 irq_stamp;
+	unsigned long irq_time;
+	unsigned long rt_time;
+	u64 age_stamp;
+
 #endif
 
 #ifdef CONFIG_SCHED_HRTICK
@@ -816,14 +822,21 @@ const_debug unsigned int sysctl_sched_nr
 unsigned int sysctl_sched_shares_ratelimit = 250000;
 
 /*
- * period over which we measure -rt task cpu usage in us.
+ * period over which we average the IRQ and RT cpu consumption, measured in
+ * jiffies.
  * default: 1s
  */
-unsigned int sysctl_sched_rt_period = 1000000;
+const_debug unsigned int sysctl_sched_time_avg = MSEC_PER_SEC;
 
 static __read_mostly int scheduler_running;
 
 /*
+ * period over which we measure -rt task cpu usage in us.
+ * default: 1s
+ */
+unsigned int sysctl_sched_rt_period = 1000000;
+
+/*
  * part of the period that we allow rt tasks to run in us.
  * default: 9.5s
  */
@@ -1143,6 +1156,82 @@ static inline void init_hrtick(void)
 }
 #endif
 
+#ifdef CONFIG_SMP
+/*
+ * Measure IRQ time, we start when we first enter IRQ state
+ * and stop when we last leave IRQ state (nested IRQs).
+ */
+void sched_irq_enter(void)
+{
+	if (!in_irq()) {
+		struct rq *rq = this_rq();
+
+		update_rq_clock(rq);
+		rq->irq_stamp = rq->clock;
+	}
+}
+
+void sched_irq_exit(void)
+{
+	if (!in_irq()) {
+		struct rq *rq = this_rq();
+
+		update_rq_clock(rq);
+		rq->irq_time += rq->clock - rq->irq_stamp;
+	}
+}
+
+static inline u64 sched_avg_period(void)
+{
+	return (u64)sysctl_sched_time_avg * (NSEC_PER_MSEC / 2);
+}
+
+/*
+ * Every period/2 we half the accumulated time. See lib/proportions.c
+ */
+static void sched_age_time(struct rq *rq)
+{
+	if (rq->clock - rq->age_stamp >= sched_avg_period()) {
+		rq->irq_time /= 2;
+		rq->rt_time /= 2;
+		rq->age_stamp = rq->clock;
+	}
+}
+
+/*
+ * Scale the SCHED_OTHER load on this rq up to compensate for the pressure
+ * of IRQ and RT usage of this CPU.
+ *
+ * See lib/proportions.c
+ */
+static unsigned long sched_scale_load(struct rq *rq, u64 load)
+{
+	u64 total = sched_avg_period() + (rq->clock - rq->age_stamp);
+	u64 available = total - rq->irq_time - rq->rt_time;
+
+	/*
+	 * Shift back to roughly us scale, so that the divisor fits in u32.
+	 */
+	total >>= 10;
+	available >>= 10;
+
+	if (unlikely((s64)available <= 0))
+		available = 1;
+
+	load *= total;
+	load = div_u64(load, available);
+
+	/*
+	 * Clip the maximal load value to something plenty high.
+	 */
+	return min_t(unsigned long, load, 1UL << 22);
+}
+#else
+static inline void sched_age_time(struct rq *rq)
+{
+}
+#endif
+
 /*
  * resched_task - mark a task 'to be rescheduled now'.
  *
@@ -1635,8 +1724,12 @@ static void dec_nr_running(struct rq *rq
 static void set_load_weight(struct task_struct *p)
 {
 	if (task_has_rt_policy(p)) {
-		p->se.load.weight = prio_to_weight[0] * 2;
-		p->se.load.inv_weight = prio_to_wmult[0] >> 1;
+		/*
+		 * Real-time tasks do not contribute to SCHED_OTHER load
+		 * this is compensated by sched_scale_load() usage.
+		 */
+		p->se.load.weight = 0;
+		p->se.load.inv_weight = 0;
 		return;
 	}
 
@@ -2028,10 +2121,10 @@ static unsigned long source_load(int cpu
 	struct rq *rq = cpu_rq(cpu);
 	unsigned long total = weighted_cpuload(cpu);
 
-	if (type == 0 || !sched_feat(LB_BIAS))
-		return total;
+	if (type && sched_feat(LB_BIAS))
+		total = min(rq->cpu_load[type-1], total);
 
-	return min(rq->cpu_load[type-1], total);
+	return sched_scale_load(rq, total);
 }
 
 /*
@@ -2043,10 +2136,10 @@ static unsigned long target_load(int cpu
 	struct rq *rq = cpu_rq(cpu);
 	unsigned long total = weighted_cpuload(cpu);
 
-	if (type == 0 || !sched_feat(LB_BIAS))
-		return total;
+	if (type && sched_feat(LB_BIAS))
+		total = max(rq->cpu_load[type-1], total);
 
-	return max(rq->cpu_load[type-1], total);
+	return sched_scale_load(rq, total);
 }
 
 /*
@@ -2956,10 +3049,20 @@ balance_tasks(struct rq *this_rq, int th
 	int loops = 0, pulled = 0, pinned = 0;
 	struct task_struct *p;
 	long rem_load_move = max_load_move;
+	unsigned long busy_weight, this_weight, weight_scale;
 
 	if (max_load_move == 0)
 		goto out;
 
+	/*
+	 * Compute a weight scale to properly account for the varying
+	 * load inflation between these CPUs.
+	 */
+	busy_weight = sched_scale_load(busiest, NICE_0_LOAD);
+	this_weight = sched_scale_load(this_rq, NICE_0_LOAD);
+
+	weight_scale = div_u64((u64)this_weight * NICE_0_LOAD, busy_weight);
+
 	pinned = 1;
 
 	/*
@@ -2978,7 +3081,7 @@ next:
 
 	pull_task(busiest, p, this_rq, this_cpu);
 	pulled++;
-	rem_load_move -= p->se.load.weight;
+	rem_load_move -= (weight_scale * p->se.load.weight) >> NICE_0_SHIFT;
 
 	/*
 	 * We only want to steal up to the prescribed amount of weighted load.
@@ -4211,6 +4314,7 @@ void scheduler_tick(void)
 	spin_lock(&rq->lock);
 	update_rq_clock(rq);
 	update_cpu_load(rq);
+	sched_age_time(rq);
 	curr->sched_class->task_tick(rq, curr, 0);
 	spin_unlock(&rq->lock);
 
Index: linux-2.6/kernel/sched_rt.c
===================================================================
--- linux-2.6.orig/kernel/sched_rt.c
+++ linux-2.6/kernel/sched_rt.c
@@ -478,6 +478,14 @@ static void update_curr_rt(struct rq *rq
 	if (unlikely((s64)delta_exec < 0))
 		delta_exec = 0;
 
+#ifdef CONFIG_SMP
+	/*
+	 * Account the time spend running RT tasks on this rq. Used to inflate
+	 * this rq's load values.
+	 */
+	rq->rt_time += delta_exec;
+#endif
+
 	schedstat_set(curr->se.exec_max, max(curr->se.exec_max, delta_exec));
 
 	curr->se.sum_exec_runtime += delta_exec;
Index: linux-2.6/kernel/softirq.c
===================================================================
--- linux-2.6.orig/kernel/softirq.c
+++ linux-2.6/kernel/softirq.c
@@ -280,6 +280,7 @@ void irq_exit(void)
 	account_system_vtime(current);
 	trace_hardirq_exit();
 	sub_preempt_count(IRQ_EXIT_OFFSET);
+	sched_irq_exit();
 	if (!in_interrupt() && local_softirq_pending())
 		invoke_softirq();
 
Index: linux-2.6/kernel/sysctl.c
===================================================================
--- linux-2.6.orig/kernel/sysctl.c
+++ linux-2.6/kernel/sysctl.c
@@ -309,6 +309,14 @@ static struct ctl_table kern_table[] = {
 		.mode		= 0644,
 		.proc_handler	= &proc_dointvec,
 	},
+	{
+		.ctl_name	= CTL_UNNUMBERED,
+		.procname	= "sched_time_avg_ms",
+		.data		= &sysctl_sched_time_avg,
+		.maxlen		= sizeof(unsigned int),
+		.mode		= 0644,
+		.proc_handler	= &proc_dointvec,
+	},
 #endif
 	{
 		.ctl_name	= CTL_UNNUMBERED,
Index: linux-2.6/kernel/sched_debug.c
===================================================================
--- linux-2.6.orig/kernel/sched_debug.c
+++ linux-2.6/kernel/sched_debug.c
@@ -245,6 +245,8 @@ static void print_cpu(struct seq_file *m
 	P(nr_running);
 	SEQ_printf(m, "  .%-30s: %lu\n", "load",
 		   rq->load.weight);
+	SEQ_printf(m, "  .%-30s: %ld\n", "scaled_load",
+			sched_scale_load(rq, rq->load.weight));
 	P(nr_switches);
 	P(nr_load_updates);
 	P(nr_uninterruptible);


