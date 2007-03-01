Return-Path: <linux-kernel-owner+w=401wt.eu-S1161048AbXCAWfV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161048AbXCAWfV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Mar 2007 17:35:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161045AbXCAWfV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Mar 2007 17:35:21 -0500
Received: from mail04.syd.optusnet.com.au ([211.29.132.185]:52819 "EHLO
	mail04.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1161048AbXCAWfU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Mar 2007 17:35:20 -0500
From: Con Kolivas <kernel@kolivas.org>
To: Ingo Molnar <mingo@elte.hu>
Subject: [PATCH] sched: remove SMT nice
Date: Fri, 2 Mar 2007 09:33:37 +1100
User-Agent: KMail/1.9.5
Cc: tglx@linutronix.de, Mike Galbraith <efault@gmx.de>,
       Michal Piotrowski <michal.k.k.piotrowski@gmail.com>,
       Adrian Bunk <bunk@stusta.de>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
References: <Pine.LNX.4.64.0702202043280.4043@woody.linux-foundation.org> <20070301133004.GA32724@elte.hu> <200703020851.57810.kernel@kolivas.org>
In-Reply-To: <200703020851.57810.kernel@kolivas.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200703020933.37590.kernel@kolivas.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Remove the SMT-nice feature which idles sibling cpus on SMT cpus to
facilitiate nice working properly where cpu power is shared. The idling
of cpus in the presence of runnable tasks is considered too fragile, easy
to break with outside code, and the complexity of managing this system if an
architecture comes along with many logical cores sharing cpu power will be
unworkable.

Remove the associated per_cpu_gain variable in sched_domains used only by
this code.

Signed-off-by: Con Kolivas <kernel@kolivas.org>

---
 include/asm-i386/topology.h           |    1 
 include/asm-ia64/topology.h           |    2 
 include/asm-mips/mach-ip27/topology.h |    1 
 include/asm-powerpc/topology.h        |    1 
 include/asm-x86_64/topology.h         |    1 
 include/linux/sched.h                 |    1 
 include/linux/topology.h              |    4 
 kernel/sched.c                        |  155 ----------------------------------
 8 files changed, 1 insertion(+), 165 deletions(-)

Index: linux-2.6.21-rc2/kernel/sched.c
===================================================================
--- linux-2.6.21-rc2.orig/kernel/sched.c	2007-03-02 08:56:45.000000000 +1100
+++ linux-2.6.21-rc2/kernel/sched.c	2007-03-02 08:58:40.000000000 +1100
@@ -3006,23 +3006,6 @@ static inline void idle_balance(int cpu,
 }
 #endif
 
-static inline void wake_priority_sleeper(struct rq *rq)
-{
-#ifdef CONFIG_SCHED_SMT
-	if (!rq->nr_running)
-		return;
-
-	spin_lock(&rq->lock);
-	/*
-	 * If an SMT sibling task has been put to sleep for priority
-	 * reasons reschedule the idle task to see if it can now run.
-	 */
-	if (rq->nr_running)
-		resched_task(rq->idle);
-	spin_unlock(&rq->lock);
-#endif
-}
-
 DEFINE_PER_CPU(struct kernel_stat, kstat);
 
 EXPORT_PER_CPU_SYMBOL(kstat);
@@ -3239,10 +3222,7 @@ void scheduler_tick(void)
 
 	update_cpu_clock(p, rq, now);
 
-	if (p == rq->idle)
-		/* Task on the idle queue */
-		wake_priority_sleeper(rq);
-	else
+	if (p != rq->idle)
 		task_running_tick(rq, p);
 #ifdef CONFIG_SMP
 	update_load(rq);
@@ -3251,136 +3231,6 @@ void scheduler_tick(void)
 #endif
 }
 
-#ifdef CONFIG_SCHED_SMT
-static inline void wakeup_busy_runqueue(struct rq *rq)
-{
-	/* If an SMT runqueue is sleeping due to priority reasons wake it up */
-	if (rq->curr == rq->idle && rq->nr_running)
-		resched_task(rq->idle);
-}
-
-/*
- * Called with interrupt disabled and this_rq's runqueue locked.
- */
-static void wake_sleeping_dependent(int this_cpu)
-{
-	struct sched_domain *tmp, *sd = NULL;
-	int i;
-
-	for_each_domain(this_cpu, tmp) {
-		if (tmp->flags & SD_SHARE_CPUPOWER) {
-			sd = tmp;
-			break;
-		}
-	}
-
-	if (!sd)
-		return;
-
-	for_each_cpu_mask(i, sd->span) {
-		struct rq *smt_rq = cpu_rq(i);
-
-		if (i == this_cpu)
-			continue;
-		if (unlikely(!spin_trylock(&smt_rq->lock)))
-			continue;
-
-		wakeup_busy_runqueue(smt_rq);
-		spin_unlock(&smt_rq->lock);
-	}
-}
-
-/*
- * number of 'lost' timeslices this task wont be able to fully
- * utilize, if another task runs on a sibling. This models the
- * slowdown effect of other tasks running on siblings:
- */
-static inline unsigned long
-smt_slice(struct task_struct *p, struct sched_domain *sd)
-{
-	return p->time_slice * (100 - sd->per_cpu_gain) / 100;
-}
-
-/*
- * To minimise lock contention and not have to drop this_rq's runlock we only
- * trylock the sibling runqueues and bypass those runqueues if we fail to
- * acquire their lock. As we only trylock the normal locking order does not
- * need to be obeyed.
- */
-static int
-dependent_sleeper(int this_cpu, struct rq *this_rq, struct task_struct *p)
-{
-	struct sched_domain *tmp, *sd = NULL;
-	int ret = 0, i;
-
-	/* kernel/rt threads do not participate in dependent sleeping */
-	if (!p->mm || rt_task(p))
-		return 0;
-
-	for_each_domain(this_cpu, tmp) {
-		if (tmp->flags & SD_SHARE_CPUPOWER) {
-			sd = tmp;
-			break;
-		}
-	}
-
-	if (!sd)
-		return 0;
-
-	for_each_cpu_mask(i, sd->span) {
-		struct task_struct *smt_curr;
-		struct rq *smt_rq;
-
-		if (i == this_cpu)
-			continue;
-
-		smt_rq = cpu_rq(i);
-		if (unlikely(!spin_trylock(&smt_rq->lock)))
-			continue;
-
-		smt_curr = smt_rq->curr;
-
-		if (!smt_curr->mm)
-			goto unlock;
-
-		/*
-		 * If a user task with lower static priority than the
-		 * running task on the SMT sibling is trying to schedule,
-		 * delay it till there is proportionately less timeslice
-		 * left of the sibling task to prevent a lower priority
-		 * task from using an unfair proportion of the
-		 * physical cpu's resources. -ck
-		 */
-		if (rt_task(smt_curr)) {
-			/*
-			 * With real time tasks we run non-rt tasks only
-			 * per_cpu_gain% of the time.
-			 */
-			if ((jiffies % DEF_TIMESLICE) >
-				(sd->per_cpu_gain * DEF_TIMESLICE / 100))
-					ret = 1;
-		} else {
-			if (smt_curr->static_prio < p->static_prio &&
-				!TASK_PREEMPTS_CURR(p, smt_rq) &&
-				smt_slice(smt_curr, sd) > task_timeslice(p))
-					ret = 1;
-		}
-unlock:
-		spin_unlock(&smt_rq->lock);
-	}
-	return ret;
-}
-#else
-static inline void wake_sleeping_dependent(int this_cpu)
-{
-}
-static inline int
-dependent_sleeper(int this_cpu, struct rq *this_rq, struct task_struct *p)
-{
-	return 0;
-}
-#endif
-
 #if defined(CONFIG_PREEMPT) && defined(CONFIG_DEBUG_PREEMPT)
 
 void fastcall add_preempt_count(int val)
@@ -3507,7 +3357,6 @@ need_resched_nonpreemptible:
 		if (!rq->nr_running) {
 			next = rq->idle;
 			rq->expired_timestamp = 0;
-			wake_sleeping_dependent(cpu);
 			goto switch_tasks;
 		}
 	}
@@ -3547,8 +3396,6 @@ need_resched_nonpreemptible:
 		}
 	}
 	next->sleep_type = SLEEP_NORMAL;
-	if (dependent_sleeper(cpu, rq, next))
-		next = rq->idle;
 switch_tasks:
 	if (next == rq->idle)
 		schedstat_inc(rq, sched_goidle);
Index: linux-2.6.21-rc2/include/asm-i386/topology.h
===================================================================
--- linux-2.6.21-rc2.orig/include/asm-i386/topology.h	2007-03-02 09:02:01.000000000 +1100
+++ linux-2.6.21-rc2/include/asm-i386/topology.h	2007-03-02 09:02:58.000000000 +1100
@@ -85,7 +85,6 @@ static inline int node_to_first_cpu(int 
 	.idle_idx		= 1,			\
 	.newidle_idx		= 2,			\
 	.wake_idx		= 1,			\
-	.per_cpu_gain		= 100,			\
 	.flags			= SD_LOAD_BALANCE	\
 				| SD_BALANCE_EXEC	\
 				| SD_BALANCE_FORK	\
Index: linux-2.6.21-rc2/include/asm-ia64/topology.h
===================================================================
--- linux-2.6.21-rc2.orig/include/asm-ia64/topology.h	2007-03-02 09:02:01.000000000 +1100
+++ linux-2.6.21-rc2/include/asm-ia64/topology.h	2007-03-02 09:02:33.000000000 +1100
@@ -65,7 +65,6 @@ void build_cpu_to_node_map(void);
 	.max_interval		= 4,			\
 	.busy_factor		= 64,			\
 	.imbalance_pct		= 125,			\
-	.per_cpu_gain		= 100,			\
 	.cache_nice_tries	= 2,			\
 	.busy_idx		= 2,			\
 	.idle_idx		= 1,			\
@@ -97,7 +96,6 @@ void build_cpu_to_node_map(void);
 	.newidle_idx		= 0, /* unused */	\
 	.wake_idx		= 1,			\
 	.forkexec_idx		= 1,			\
-	.per_cpu_gain		= 100,			\
 	.flags			= SD_LOAD_BALANCE	\
 				| SD_BALANCE_EXEC	\
 				| SD_BALANCE_FORK	\
Index: linux-2.6.21-rc2/include/asm-mips/mach-ip27/topology.h
===================================================================
--- linux-2.6.21-rc2.orig/include/asm-mips/mach-ip27/topology.h	2007-03-02 09:02:01.000000000 +1100
+++ linux-2.6.21-rc2/include/asm-mips/mach-ip27/topology.h	2007-03-02 09:02:38.000000000 +1100
@@ -28,7 +28,6 @@ extern unsigned char __node_distances[MA
 	.busy_factor		= 32,			\
 	.imbalance_pct		= 125,			\
 	.cache_nice_tries	= 1,			\
-	.per_cpu_gain		= 100,			\
 	.flags			= SD_LOAD_BALANCE	\
 				| SD_BALANCE_EXEC	\
 				| SD_WAKE_BALANCE,	\
Index: linux-2.6.21-rc2/include/asm-powerpc/topology.h
===================================================================
--- linux-2.6.21-rc2.orig/include/asm-powerpc/topology.h	2007-03-02 09:02:01.000000000 +1100
+++ linux-2.6.21-rc2/include/asm-powerpc/topology.h	2007-03-02 09:02:44.000000000 +1100
@@ -57,7 +57,6 @@ static inline int pcibus_to_node(struct 
 	.busy_factor		= 32,			\
 	.imbalance_pct		= 125,			\
 	.cache_nice_tries	= 1,			\
-	.per_cpu_gain		= 100,			\
 	.busy_idx		= 3,			\
 	.idle_idx		= 1,			\
 	.newidle_idx		= 2,			\
Index: linux-2.6.21-rc2/include/asm-x86_64/topology.h
===================================================================
--- linux-2.6.21-rc2.orig/include/asm-x86_64/topology.h	2007-03-02 09:02:01.000000000 +1100
+++ linux-2.6.21-rc2/include/asm-x86_64/topology.h	2007-03-02 09:02:50.000000000 +1100
@@ -43,7 +43,6 @@ extern int __node_distance(int, int);
 	.newidle_idx		= 0, 			\
 	.wake_idx		= 1,			\
 	.forkexec_idx		= 1,			\
-	.per_cpu_gain		= 100,			\
 	.flags			= SD_LOAD_BALANCE	\
 				| SD_BALANCE_FORK	\
 				| SD_BALANCE_EXEC	\
Index: linux-2.6.21-rc2/include/linux/sched.h
===================================================================
--- linux-2.6.21-rc2.orig/include/linux/sched.h	2007-03-02 09:02:01.000000000 +1100
+++ linux-2.6.21-rc2/include/linux/sched.h	2007-03-02 09:02:27.000000000 +1100
@@ -684,7 +684,6 @@ struct sched_domain {
 	unsigned int imbalance_pct;	/* No balance until over watermark */
 	unsigned long long cache_hot_time; /* Task considered cache hot (ns) */
 	unsigned int cache_nice_tries;	/* Leave cache hot tasks for # tries */
-	unsigned int per_cpu_gain;	/* CPU % gained by adding domain cpus */
 	unsigned int busy_idx;
 	unsigned int idle_idx;
 	unsigned int newidle_idx;
Index: linux-2.6.21-rc2/include/linux/topology.h
===================================================================
--- linux-2.6.21-rc2.orig/include/linux/topology.h	2007-03-02 09:02:01.000000000 +1100
+++ linux-2.6.21-rc2/include/linux/topology.h	2007-03-02 09:02:19.000000000 +1100
@@ -96,7 +96,6 @@
 	.busy_factor		= 64,			\
 	.imbalance_pct		= 110,			\
 	.cache_nice_tries	= 0,			\
-	.per_cpu_gain		= 25,			\
 	.busy_idx		= 0,			\
 	.idle_idx		= 0,			\
 	.newidle_idx		= 1,			\
@@ -128,7 +127,6 @@
 	.busy_factor		= 64,			\
 	.imbalance_pct		= 125,			\
 	.cache_nice_tries	= 1,			\
-	.per_cpu_gain		= 100,			\
 	.busy_idx		= 2,			\
 	.idle_idx		= 1,			\
 	.newidle_idx		= 2,			\
@@ -159,7 +157,6 @@
 	.busy_factor		= 64,			\
 	.imbalance_pct		= 125,			\
 	.cache_nice_tries	= 1,			\
-	.per_cpu_gain		= 100,			\
 	.busy_idx		= 2,			\
 	.idle_idx		= 1,			\
 	.newidle_idx		= 2,			\
@@ -193,7 +190,6 @@
 	.newidle_idx		= 0, /* unused */	\
 	.wake_idx		= 0, /* unused */	\
 	.forkexec_idx		= 0, /* unused */	\
-	.per_cpu_gain		= 100,			\
 	.flags			= SD_LOAD_BALANCE	\
 				| SD_SERIALIZE,	\
 	.last_balance		= jiffies,		\

-- 
-ck
