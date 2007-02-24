Return-Path: <linux-kernel-owner+w=401wt.eu-S933350AbXBXChQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933350AbXBXChQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Feb 2007 21:37:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933351AbXBXChQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Feb 2007 21:37:16 -0500
Received: from mga09.intel.com ([134.134.136.24]:23669 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933350AbXBXChO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Feb 2007 21:37:14 -0500
X-ExtLoop1: 1
X-IronPort-AV: i="4.14,213,1170662400"; 
   d="scan'208"; a="50111103:sNHT26496936"
Date: Fri, 23 Feb 2007 18:01:37 -0800
From: "Siddha, Suresh B" <suresh.b.siddha@intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "Siddha, Suresh B" <suresh.b.siddha@intel.com>, mingo@elte.hu,
       linux-kernel@vger.kernel.org, npiggin@suse.de, rostedt@goodmis.org
Subject: [patch] sched: dynticks idle load balancing - v3
Message-ID: <20070223180137.A2120@unix-os.sc.intel.com>
References: <20061213150314.B12795@unix-os.sc.intel.com> <20061213233157.GA20470@elte.hu> <20061213151926.C12795@unix-os.sc.intel.com> <20061219201247.GA12648@elte.hu> <20061219131223.E23105@unix-os.sc.intel.com> <20070116113505.GA6294@elte.hu> <20070130135709.B32010@unix-os.sc.intel.com> <20070216180335.A8744@unix-os.sc.intel.com> <20070216180842.B8744@unix-os.sc.intel.com> <20070221122344.564fb44f.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.2.5.1i
In-Reply-To: <20070221122344.564fb44f.akpm@linux-foundation.org>; from akpm@linux-foundation.org on Wed, Feb 21, 2007 at 12:23:44PM -0800
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 21, 2007 at 12:23:44PM -0800, Andrew Morton wrote:
> I spose I'll hold my nose and merge this, but it creates too much of a mess
> to be mergeable into the CPU scheduler, IMO.

Cleaned up patch appended. Please drop sched-dynticks-idle-load-balancing-v2.patch
and include this instead.

thanks,
suresh
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

diff -pNru linus-2.6/include/linux/sched.h linux/include/linux/sched.h
--- linus-2.6/include/linux/sched.h	2007-02-22 15:25:16.000000000 -0800
+++ linux/include/linux/sched.h	2007-02-22 15:27:01.000000000 -0800
@@ -194,6 +194,14 @@ extern void sched_init_smp(void);
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
diff -pNru linus-2.6/kernel/sched.c linux/kernel/sched.c
--- linus-2.6/kernel/sched.c	2007-02-23 16:58:48.000000000 -0800
+++ linux/kernel/sched.c	2007-02-23 18:32:23.000000000 -0800
@@ -224,6 +224,9 @@ struct rq {
 #ifdef CONFIG_SMP
 	unsigned long cpu_load[3];
 	unsigned char idle_at_tick;
+#ifdef CONFIG_NO_HZ
+	unsigned char in_nohz_recently;
+#endif
 #endif
 	unsigned long long nr_switches;
 
@@ -1050,6 +1053,17 @@ static void resched_task(struct task_str
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
@@ -2658,6 +2672,12 @@ redo:
 		double_rq_unlock(this_rq, busiest);
 		local_irq_restore(flags);
 
+		/*
+		 * some other cpu did the load balance for us.
+		 */
+		if (nr_moved && this_cpu != smp_processor_id())
+			resched_cpu(this_cpu);
+
 		/* All tasks on this runqueue were pinned by CPU affinity */
 		if (unlikely(all_pinned)) {
 			cpu_clear(cpu_of(busiest), cpus);
@@ -2928,27 +2948,98 @@ static void update_load(struct rq *this_
 	}
 }
 
+#ifdef CONFIG_NO_HZ
+static struct {
+	atomic_t load_balancer;
+	cpumask_t  cpu_mask;
+} nohz ____cacheline_aligned = {
+	.load_balancer = ATOMIC_INIT(-1),
+	.cpu_mask = CPU_MASK_NONE,
+};
+
 /*
- * run_rebalance_domains is triggered when needed from the scheduler tick.
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
  *
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
+		if (cpu_is_offline(cpu) &&
+		    atomic_read(&nohz.load_balancer) == cpu) {
+			if (atomic_cmpxchg(&nohz.load_balancer, cpu, -1) != cpu)
+				BUG();
+			return 0;
+		}
+
+		/* time for ilb owner also to sleep */
+		if (cpus_weight(nohz.cpu_mask) == num_online_cpus()) {
+			if (atomic_read(&nohz.load_balancer) == cpu)
+				atomic_set(&nohz.load_balancer, -1);
+			return 0;
+		}
+
+		if (atomic_read(&nohz.load_balancer) == -1) {
+			/* make me the ilb owner */
+			if (atomic_cmpxchg(&nohz.load_balancer, -1, cpu) == -1)
+				return 1;
+		} else if (atomic_read(&nohz.load_balancer) == cpu)
+			return 1;
+	} else {
+		if (!cpu_isset(cpu, nohz.cpu_mask))
+			return 0;
+
+		cpu_clear(cpu, nohz.cpu_mask);
+
+		if (atomic_read(&nohz.load_balancer) == cpu)
+			if (atomic_cmpxchg(&nohz.load_balancer, cpu, -1) != cpu)
+				BUG();
+	}
+	return 0;
+}
+#endif
+
+static DEFINE_SPINLOCK(balancing);
+
+/*
  * It checks each scheduling domain to see if it is due to be balanced,
  * and initiates a balancing operation if so.
  *
  * Balancing parameters are set up in arch_init_sched_domains.
  */
-static DEFINE_SPINLOCK(balancing);
-
-static void run_rebalance_domains(struct softirq_action *h)
+static inline void rebalance_domains(int cpu, enum idle_type idle)
 {
-	int this_cpu = smp_processor_id(), balance = 1;
-	struct rq *this_rq = cpu_rq(this_cpu);
+	int balance = 1;
+	struct rq *rq = cpu_rq(cpu);
 	unsigned long interval;
 	struct sched_domain *sd;
-	enum idle_type idle = this_rq->idle_at_tick ? SCHED_IDLE : NOT_IDLE;
-	/* Earliest time when we have to call run_rebalance_domains again */
+	/* Earliest time when we have to do rebalance again */
 	unsigned long next_balance = jiffies + 60*HZ;
 
-	for_each_domain(this_cpu, sd) {
+	for_each_domain(cpu, sd) {
 		if (!(sd->flags & SD_LOAD_BALANCE))
 			continue;
 
@@ -2967,7 +3058,7 @@ static void run_rebalance_domains(struct
 		}
 
 		if (time_after_eq(jiffies, sd->last_balance + interval)) {
-			if (load_balance(this_cpu, this_rq, sd, idle, &balance)) {
+			if (load_balance(cpu, rq, sd, idle, &balance)) {
 				/*
 				 * We've pulled tasks over so either we're no
 				 * longer idle, or one of our SMT siblings is
@@ -2991,7 +3082,52 @@ out:
 		if (!balance)
 			break;
 	}
-	this_rq->next_balance = next_balance;
+	rq->next_balance = next_balance;
+}
+
+/*
+ * run_rebalance_domains is triggered when needed from the scheduler tick.
+ * In CONFIG_NO_HZ case, the idle load balance owner will do the
+ * rebalancing for all the cpus for whom scheduler ticks are stopped.
+ */
+static void run_rebalance_domains(struct softirq_action *h)
+{
+	int local_cpu = smp_processor_id();
+	struct rq *local_rq = cpu_rq(local_cpu);
+	enum idle_type idle = local_rq->idle_at_tick ? SCHED_IDLE : NOT_IDLE;
+
+	rebalance_domains(local_cpu, idle);
+
+#ifdef CONFIG_NO_HZ
+	/*
+	 * If this cpu is the owner for idle load balancing, then do the
+	 * balancing on behalf of the other idle cpus whose ticks are
+	 * stopped.
+	 */
+	if (local_rq->idle_at_tick &&
+	    atomic_read(&nohz.load_balancer) == local_cpu) {
+		cpumask_t cpus = nohz.cpu_mask;
+		struct rq *rq;
+		int balance_cpu;
+
+		cpu_clear(local_cpu, cpus);
+		for_each_cpu_mask(balance_cpu, cpus) {
+			/*
+			 * If this cpu gets work to do, stop the load balancing
+			 * work being done for other cpus. Next load
+			 * balancing owner will pick it up.
+			 */
+			if (need_resched())
+				break;
+
+			rebalance_domains(balance_cpu, SCHED_IDLE);
+
+			rq = cpu_rq(balance_cpu);
+			if (time_after(local_rq->next_balance, rq->next_balance))
+				local_rq->next_balance = rq->next_balance;
+		}
+	}
+#endif
 }
 #else
 /*
@@ -3220,6 +3356,68 @@ out_unlock:
 }
 
 /*
+ * Trigger the SCHED_SOFTIRQ if it is time to do periodic load balancing.
+ *
+ * In case of CONFIG_NO_HZ, this is the place where we nominate a new
+ * idle load balancing owner or decide to stop the periodic load balancing,
+ * if the whole system is idle.
+ */
+static inline void trigger_load_balance(int cpu)
+{
+	struct rq *rq = cpu_rq(cpu);
+#ifdef CONFIG_NO_HZ
+	/*
+	 * If we were in the nohz mode recently and busy at the current
+	 * scheduler tick, then check if we need to nominate new idle
+	 * load balancer.
+	 */
+	if (rq->in_nohz_recently && !rq->idle_at_tick) {
+		rq->in_nohz_recently = 0;
+
+		if (atomic_read(&nohz.load_balancer) == cpu) {
+			cpu_clear(cpu, nohz.cpu_mask);
+			atomic_set(&nohz.load_balancer, -1);
+		}
+
+		if (atomic_read(&nohz.load_balancer) == -1) {
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
+
+	/*
+	 * If this cpu is idle and doing idle load balancing for all the
+	 * cpus with ticks stopped, is it time for that to stop?
+	 */
+	if (rq->idle_at_tick && atomic_read(&nohz.load_balancer) == cpu &&
+	    cpus_weight(nohz.cpu_mask) == num_online_cpus()) {
+		resched_cpu(cpu);
+		return;
+	}
+
+	/*
+	 * If this cpu is idle and the idle load balancing is done by
+	 * someone else, then no need raise the SCHED_SOFTIRQ
+	 */
+	if (rq->idle_at_tick && atomic_read(&nohz.load_balancer) != cpu &&
+	    cpu_isset(cpu, nohz.cpu_mask))
+		return;
+#endif
+	if (time_after_eq(jiffies, rq->next_balance))
+		raise_softirq(SCHED_SOFTIRQ);
+}
+
+/*
  * This function gets called by the timer code, with HZ frequency.
  * We call it with interrupts disabled.
  *
@@ -3244,8 +3442,8 @@ void scheduler_tick(void)
 #ifdef CONFIG_SMP
 	rq->idle_at_tick = idle_at_tick;
 	update_load(rq);
-	if (time_after_eq(jiffies, rq->next_balance))
-		raise_softirq(SCHED_SOFTIRQ);
+
+	trigger_load_balance(cpu);
 #endif
 }
 
diff -pNru linus-2.6/kernel/time/tick-sched.c linux/kernel/time/tick-sched.c
--- linus-2.6/kernel/time/tick-sched.c	2007-02-22 15:25:17.000000000 -0800
+++ linux/kernel/time/tick-sched.c	2007-02-23 17:01:14.000000000 -0800
@@ -215,6 +215,14 @@ void tick_nohz_stop_sched_tick(void)
 		 * the scheduler tick in nohz_restart_sched_tick.
 		 */
 		if (!ts->tick_stopped) {
+			if (select_nohz_load_balancer(1)) {
+				/*
+				 * sched tick not stopped!
+				 */
+				cpu_clear(cpu, nohz_cpu_mask);
+				goto out;
+			}
+
 			ts->idle_tick = ts->sched_timer.expires;
 			ts->tick_stopped = 1;
 			ts->idle_jiffies = last_jiffies;
@@ -271,6 +279,7 @@ void tick_nohz_restart_sched_tick(void)
 	now = ktime_get();
 
 	local_irq_disable();
+	select_nohz_load_balancer(0);
 	tick_do_update_jiffies64(now);
 	cpu_clear(cpu, nohz_cpu_mask);
 
