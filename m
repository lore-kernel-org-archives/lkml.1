Return-Path: <linux-kernel-owner+w=401wt.eu-S1946378AbXBQCni@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946378AbXBQCni (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Feb 2007 21:43:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946372AbXBQCnh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Feb 2007 21:43:37 -0500
Received: from mga09.intel.com ([134.134.136.24]:43242 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946371AbXBQCnX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Feb 2007 21:43:23 -0500
X-ExtLoop1: 1
X-IronPort-AV: i="4.14,182,1170662400"; 
   d="scan'208"; a="47434200:sNHT24098742"
Date: Fri, 16 Feb 2007 18:08:42 -0800
From: "Siddha, Suresh B" <suresh.b.siddha@intel.com>
To: mingo@elte.hu
Cc: linux-kernel@vger.kernel.org, npiggin@suse.de, rostedt@goodmis.org
Subject: [patch 2/2] sched: dynticks idle load balancing - v2
Message-ID: <20070216180842.B8744@unix-os.sc.intel.com>
References: <20061213224317.GA2986@elte.hu> <20061213231316.GA13849@elte.hu> <20061213150314.B12795@unix-os.sc.intel.com> <20061213233157.GA20470@elte.hu> <20061213151926.C12795@unix-os.sc.intel.com> <20061219201247.GA12648@elte.hu> <20061219131223.E23105@unix-os.sc.intel.com> <20070116113505.GA6294@elte.hu> <20070130135709.B32010@unix-os.sc.intel.com> <20070216180335.A8744@unix-os.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.2.5.1i
In-Reply-To: <20070216180335.A8744@unix-os.sc.intel.com>; from suresh.b.siddha@intel.com on Fri, Feb 16, 2007 at 06:03:35PM -0800
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Changes since v1:

  - Move the idle load balancer selection from schedule()
    to the first busy scheduler_tick() after restarting the tick.
    This will avoid the unnecessay ownership changes when 
    softirq's(which are run in softirqd context in certain -rt
    configurations) like timer, sched are invoked for every idle tick
    that happens.

  - Misc cleanups.

---
Fix the process idle load balancing in the presence of dynticks.
cpus for which ticks are stopped will sleep till the next event wakes it up.
Potentially these sleeps can be for large durations and during which today,
there is no periodic idle load balancing being done.

This patch nominates an owner among the idle cpus, which does the idle load
balancing on behalf of the other idle cpus. And once all the cpus are
completely idle, then we can stop this idle load balancing too. Checks added
in fast path are minimized.  Whenever there are busy cpus in the system, there
will be an owner(idle cpu) doing the system wide idle load balancing.

Open items:
1. Intelligent owner selection (like an idle core in a busy package).
2. Merge with rcu's nohz_cpu_mask?

Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
---

diff -pNru linux-2.6.20.x86_64/include/linux/sched.h linux/include/linux/sched.h
--- linux-2.6.20.x86_64/include/linux/sched.h	2007-02-10 03:41:27.000000000 -0800
+++ linux/include/linux/sched.h	2007-02-16 17:44:08.000000000 -0800
@@ -237,6 +237,14 @@ extern void sched_init_smp(void);
 extern void init_idle(struct task_struct *idle, int cpu);
 
 extern cpumask_t nohz_cpu_mask;
+#if defined(CONFIG_SMP) && defined(CONFIG_NO_HZ)
+extern int select_nohz_load_balancer(int cpu);
+#else
+static inline int select_nohz_load_balancer(int cpu)
+{
+	return 0;
+}
+#endif
 
 /*
  * Only dump TASK_* tasks. (-1 for all tasks)
diff -pNru linux-2.6.20.x86_64/kernel/sched.c linux/kernel/sched.c
--- linux-2.6.20.x86_64/kernel/sched.c	2007-02-16 16:40:16.000000000 -0800
+++ linux/kernel/sched.c	2007-02-16 17:56:13.000000000 -0800
@@ -241,6 +241,9 @@ struct rq {
 #ifdef CONFIG_SMP
 	unsigned long cpu_load[3];
 	unsigned char idle_at_tick;
+#ifdef CONFIG_NO_HZ
+	unsigned char in_nohz_recently;
+#endif
 #endif
 	unsigned long long nr_switches;
 
@@ -1169,6 +1172,17 @@ static void resched_task(struct task_str
 	if (!tsk_is_polling(p))
 		smp_send_reschedule(cpu);
 }
+
+static void resched_cpu(int cpu)
+{
+	struct rq *rq = cpu_rq(cpu);
+	unsigned long flags;
+
+	if (!spin_trylock_irqsave(&rq->lock, flags))
+		return;
+	resched_task(cpu_curr(cpu));
+	spin_unlock_irqrestore(&rq->lock, flags);
+}
 #else
 static inline void resched_task(struct task_struct *p)
 {
@@ -3067,6 +3081,9 @@ redo:
 		double_rq_unlock(this_rq, busiest);
 		local_irq_restore(flags);
 
+		if (nr_moved && this_cpu != smp_processor_id())
+			resched_cpu(this_cpu);
+
 		/* All tasks on this runqueue were pinned by CPU affinity */
 		if (unlikely(all_pinned)) {
 			cpu_clear(cpu_of(busiest), cpus);
@@ -3335,6 +3352,79 @@ static void update_load(struct rq *this_
 	}
 }
 
+#ifdef CONFIG_NO_HZ
+static struct {
+	int load_balancer;
+	cpumask_t  cpu_mask;
+} nohz ____cacheline_aligned = {
+	.load_balancer = -1,
+	.cpu_mask = CPU_MASK_NONE,
+};
+
+/*
+ * This routine will try to nominate the ilb (idle load balancing)
+ * owner among the cpus whose ticks are stopped. ilb owner will do the idle
+ * load balancing on behalf of all those cpus. If all the cpus in the system
+ * go into this tickless mode, then there will be no ilb owner (as there is
+ * no need for one) and all the cpus will sleep till the next wakeup event
+ * arrives...
+ *
+ * For the ilb owner, tick is not stopped. And this tick will be used
+ * for idle load balancing. ilb owner will still be part of
+ * nohz.cpu_mask..
+ *
+ * While stopping the tick, this cpu will become the ilb owner if there
+ * is no other owner. And will be the owner till that cpu becomes busy
+ * or if all cpus in the system stop their ticks at which point
+ * there is no need for ilb owner.
+ *
+ * When the ilb owner becomes busy, it nominates another owner, during the
+ * next busy scheduler_tick()
+ */
+int select_nohz_load_balancer(int stop_tick)
+{
+	int cpu = smp_processor_id();
+
+	if (stop_tick) {
+		cpu_set(cpu, nohz.cpu_mask);
+		cpu_rq(cpu)->in_nohz_recently = 1;
+
+		/*
+		 * If we are going offline and still the leader, give up!
+		 */
+		if (cpu_is_offline(cpu) && nohz.load_balancer == cpu) {
+			if (cmpxchg(&nohz.load_balancer,  cpu, -1) != cpu)
+				BUG();
+			return 0;
+		}
+
+		/* time for ilb owner also to sleep */
+		if (cpus_weight(nohz.cpu_mask) == num_online_cpus()) {
+			if (nohz.load_balancer == cpu)
+				nohz.load_balancer = -1;
+			return 0;
+		}
+
+		if (nohz.load_balancer == -1) {
+			/* make me the ilb owner */
+			if (cmpxchg(&nohz.load_balancer, -1, cpu) == -1)
+				return 1;
+		} else if (nohz.load_balancer == cpu)
+			return 1;
+	} else {
+		if (!cpu_isset(cpu, nohz.cpu_mask))
+			return 0;
+
+		cpu_clear(cpu, nohz.cpu_mask);
+
+		if (nohz.load_balancer == cpu)
+			if (cmpxchg(&nohz.load_balancer,  cpu, -1) != cpu)
+				BUG();
+	}
+	return 0;
+}
+#endif
+
 /*
  * run_rebalance_domains is triggered when needed from the scheduler tick.
  *
@@ -3347,15 +3437,46 @@ static DEFINE_SPINLOCK(balancing);
 
 static void run_rebalance_domains(struct softirq_action *h)
 {
-	int this_cpu = smp_processor_id(), balance = 1;
-	struct rq *this_rq = cpu_rq(this_cpu);
-	unsigned long interval;
+	int balance_cpu = smp_processor_id(), balance;
+	struct rq *balance_rq = cpu_rq(balance_cpu);
+	unsigned long interval, next_balance;
 	struct sched_domain *sd;
-	enum idle_type idle = this_rq->idle_at_tick ? SCHED_IDLE : NOT_IDLE;
+	enum idle_type idle;
+
+#ifdef CONFIG_NO_HZ
+	cpumask_t cpus = nohz.cpu_mask;
+	int local_cpu = balance_cpu;
+	struct rq *local_rq = balance_rq;
+
+restart:
+
+	if (local_rq->idle_at_tick && nohz.load_balancer == local_cpu) {
+		if (need_resched())
+			return;
+
+		balance_cpu = first_cpu(cpus);
+		if (unlikely(balance_cpu >= NR_CPUS))
+			return;
+		balance_rq = cpu_rq(balance_cpu);
+		cpu_clear(balance_cpu, cpus);
+	}
+
+	/*
+	 * We must be doing idle load balancing for some other idle cpu
+	 */
+	if (local_cpu != balance_cpu)
+		idle = SCHED_IDLE;
+	else
+#endif
+		idle = balance_rq->idle_at_tick ? SCHED_IDLE : NOT_IDLE;
+
+	balance = 1;
+
 	/* Earliest time when we have to call run_rebalance_domains again */
-	unsigned long next_balance = jiffies + 60*HZ;
+	next_balance = jiffies + 60*HZ;
+
+	for_each_domain(balance_cpu, sd) {
 
-	for_each_domain(this_cpu, sd) {
 		if (!(sd->flags & SD_LOAD_BALANCE))
 			continue;
 
@@ -3374,7 +3495,7 @@ static void run_rebalance_domains(struct
 		}
 
 		if (time_after_eq(jiffies, sd->last_balance + interval)) {
-			if (load_balance(this_cpu, this_rq, sd, idle, &balance)) {
+			if (load_balance(balance_cpu, balance_rq, sd, idle, &balance)) {
 				/*
 				 * We've pulled tasks over so either we're no
 				 * longer idle, or one of our SMT siblings is
@@ -3398,7 +3519,16 @@ out:
 		if (!balance)
 			break;
 	}
-	this_rq->next_balance = next_balance;
+	balance_rq->next_balance = next_balance;
+
+#ifdef CONFIG_NO_HZ
+	if (local_rq->idle_at_tick && nohz.load_balancer == local_cpu) {
+		if (time_after(next_balance, local_rq->next_balance))
+			local_rq->next_balance = next_balance;
+	    	if (!cpus_empty(cpus))
+			goto restart;
+	}
+#endif
 }
 #else
 /*
@@ -3661,7 +3791,49 @@ void scheduler_tick(void)
 		task_running_tick(rq, p);
 #ifdef CONFIG_SMP
 	update_load(rq);
+#ifdef CONFIG_NO_HZ
+	/*
+	 * If we were in the nohz mode recently and busy at the
+	 * current scheduler tick, then check if we need to nominate idle
+	 * load balancer.
+	 */
+	if (rq->in_nohz_recently && !idle_at_tick) {
+		rq->in_nohz_recently = 0;
+
+		if (nohz.load_balancer == cpu) {
+			cpu_clear(cpu, nohz.cpu_mask);
+			nohz.load_balancer = -1;
+		}
+
+		if (nohz.load_balancer == -1) {
+			/*
+			 * simple selection for now: Nominate the
+			 * first cpu in the nohz list to be the next
+			 * ilb owner.
+			 *
+			 * TBD: Traverse the sched domains and nominate
+			 * the nearest cpu in the nohz.cpu_mask.
+			 */
+			int ilb = first_cpu(nohz.cpu_mask);
+
+			if (ilb != NR_CPUS)
+				resched_cpu(ilb);
+		}
+	}
+#endif
 	rq->idle_at_tick = idle_at_tick;
+#ifdef CONFIG_NO_HZ
+	if (rq->idle_at_tick && nohz.load_balancer == cpu &&
+	    cpus_weight(nohz.cpu_mask) == num_online_cpus()) {
+		resched_cpu(cpu);
+		return;
+	}
+
+	if (rq->idle_at_tick && nohz.load_balancer != cpu &&
+	    cpu_isset(cpu, nohz.cpu_mask))
+		return;
+#endif
+
 	if (time_after_eq(jiffies, rq->next_balance))
 		raise_softirq(SCHED_SOFTIRQ);
 #endif
diff -pNru linux-2.6.20.x86_64/kernel/time/tick-sched.c linux/kernel/time/tick-sched.c
--- linux-2.6.20.x86_64/kernel/time/tick-sched.c	2007-02-10 03:41:27.000000000 -0800
+++ linux/kernel/time/tick-sched.c	2007-02-16 16:56:07.000000000 -0800
@@ -241,6 +241,11 @@ void tick_nohz_stop_sched_tick(void)
 		 * the scheduler tick in nohz_restart_sched_tick.
 		 */
 		if (!ts->tick_stopped) {
+			if (select_nohz_load_balancer(1)) {
+				cpu_clear(cpu, nohz_cpu_mask);
+				goto out;
+			}
+
 			ts->idle_tick = ts->sched_timer.expires;
 			ts->tick_stopped = 1;
 			ts->idle_jiffies = last_jiffies;
@@ -297,6 +302,7 @@ void tick_nohz_restart_sched_tick(void)
 	now = ktime_get();
 
 	local_irq_disable();
+	select_nohz_load_balancer(0);
 	tick_do_update_jiffies64(now);
 	cpu_clear(cpu, nohz_cpu_mask);
 
