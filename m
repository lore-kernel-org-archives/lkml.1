Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S968437Ab0B0OmI (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Feb 2010 09:42:08 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:44266 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S968420Ab0B0OmG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Feb 2010 09:42:06 -0500
Date: Sat, 27 Feb 2010 15:41:52 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: [GIT PULL] scheduler fixes for v2.6.34
Message-ID: <20100227144152.GA26631@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: 0.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=0.0 required=5.9 tests=none autolearn=no SpamAssassin version=3.2.5
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest sched-fixes-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git sched-fixes-for-linus

These are the pending fixes queued up after v2.6.33-rc8.

 Thanks,

	Ingo

------------------>
Andrew Morton (1):
      kernel/sched.c: Suppress unused var warning

Peter Zijlstra (1):
      sched: Fix race between ttwu() and task_rq_lock()

Suresh Siddha (1):
      sched: Fix SMT scheduler regression in find_busiest_queue()

Vaidyanathan Srinivasan (1):
      sched: Fix sched_mv_power_savings for !SMT


 include/linux/sched.h |    5 ++-
 kernel/sched.c        |   86 +++++++++++++++++++++++++++++++++----------------
 2 files changed, 62 insertions(+), 29 deletions(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index 78efe7c..1f5fa53 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -878,7 +878,10 @@ static inline int sd_balance_for_mc_power(void)
 	if (sched_smt_power_savings)
 		return SD_POWERSAVINGS_BALANCE;
 
-	return SD_PREFER_SIBLING;
+	if (!sched_mc_power_savings)
+		return SD_PREFER_SIBLING;
+
+	return 0;
 }
 
 static inline int sd_balance_for_package_power(void)
diff --git a/kernel/sched.c b/kernel/sched.c
index 3a8fb30..404e201 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -941,16 +941,33 @@ static inline void finish_lock_switch(struct rq *rq, struct task_struct *prev)
 #endif /* __ARCH_WANT_UNLOCKED_CTXSW */
 
 /*
+ * Check whether the task is waking, we use this to synchronize against
+ * ttwu() so that task_cpu() reports a stable number.
+ *
+ * We need to make an exception for PF_STARTING tasks because the fork
+ * path might require task_rq_lock() to work, eg. it can call
+ * set_cpus_allowed_ptr() from the cpuset clone_ns code.
+ */
+static inline int task_is_waking(struct task_struct *p)
+{
+	return unlikely((p->state == TASK_WAKING) && !(p->flags & PF_STARTING));
+}
+
+/*
  * __task_rq_lock - lock the runqueue a given task resides on.
  * Must be called interrupts disabled.
  */
 static inline struct rq *__task_rq_lock(struct task_struct *p)
 	__acquires(rq->lock)
 {
+	struct rq *rq;
+
 	for (;;) {
-		struct rq *rq = task_rq(p);
+		while (task_is_waking(p))
+			cpu_relax();
+		rq = task_rq(p);
 		raw_spin_lock(&rq->lock);
-		if (likely(rq == task_rq(p)))
+		if (likely(rq == task_rq(p) && !task_is_waking(p)))
 			return rq;
 		raw_spin_unlock(&rq->lock);
 	}
@@ -967,10 +984,12 @@ static struct rq *task_rq_lock(struct task_struct *p, unsigned long *flags)
 	struct rq *rq;
 
 	for (;;) {
+		while (task_is_waking(p))
+			cpu_relax();
 		local_irq_save(*flags);
 		rq = task_rq(p);
 		raw_spin_lock(&rq->lock);
-		if (likely(rq == task_rq(p)))
+		if (likely(rq == task_rq(p) && !task_is_waking(p)))
 			return rq;
 		raw_spin_unlock_irqrestore(&rq->lock, *flags);
 	}
@@ -2408,14 +2427,27 @@ static int try_to_wake_up(struct task_struct *p, unsigned int state,
 	__task_rq_unlock(rq);
 
 	cpu = select_task_rq(p, SD_BALANCE_WAKE, wake_flags);
-	if (cpu != orig_cpu)
+	if (cpu != orig_cpu) {
+		/*
+		 * Since we migrate the task without holding any rq->lock,
+		 * we need to be careful with task_rq_lock(), since that
+		 * might end up locking an invalid rq.
+		 */
 		set_task_cpu(p, cpu);
+	}
 
-	rq = __task_rq_lock(p);
+	rq = cpu_rq(cpu);
+	raw_spin_lock(&rq->lock);
 	update_rq_clock(rq);
 
+	/*
+	 * We migrated the task without holding either rq->lock, however
+	 * since the task is not on the task list itself, nobody else
+	 * will try and migrate the task, hence the rq should match the
+	 * cpu we just moved it to.
+	 */
+	WARN_ON(task_cpu(p) != cpu);
 	WARN_ON(p->state != TASK_WAKING);
-	cpu = task_cpu(p);
 
 #ifdef CONFIG_SCHEDSTATS
 	schedstat_inc(rq, ttwu_count);
@@ -2663,7 +2695,13 @@ void wake_up_new_task(struct task_struct *p, unsigned long clone_flags)
 	set_task_cpu(p, cpu);
 #endif
 
-	rq = task_rq_lock(p, &flags);
+	/*
+	 * Since the task is not on the rq and we still have TASK_WAKING set
+	 * nobody else will migrate this task.
+	 */
+	rq = cpu_rq(cpu);
+	raw_spin_lock_irqsave(&rq->lock, flags);
+
 	BUG_ON(p->state != TASK_WAKING);
 	p->state = TASK_RUNNING;
 	update_rq_clock(rq);
@@ -4119,12 +4157,23 @@ find_busiest_queue(struct sched_group *group, enum cpu_idle_type idle,
 			continue;
 
 		rq = cpu_rq(i);
-		wl = weighted_cpuload(i) * SCHED_LOAD_SCALE;
-		wl /= power;
+		wl = weighted_cpuload(i);
 
+		/*
+		 * When comparing with imbalance, use weighted_cpuload()
+		 * which is not scaled with the cpu power.
+		 */
 		if (capacity && rq->nr_running == 1 && wl > imbalance)
 			continue;
 
+		/*
+		 * For the load comparisons with the other cpu's, consider
+		 * the weighted_cpuload() scaled with the cpu power, so that
+		 * the load can be moved away from the cpu that is potentially
+		 * running at a lower capacity.
+		 */
+		wl = (wl * SCHED_LOAD_SCALE) / power;
+
 		if (wl > max_load) {
 			max_load = wl;
 			busiest = rq;
@@ -7145,27 +7194,8 @@ int set_cpus_allowed_ptr(struct task_struct *p, const struct cpumask *new_mask)
 	struct rq *rq;
 	int ret = 0;
 
-	/*
-	 * Since we rely on wake-ups to migrate sleeping tasks, don't change
-	 * the ->cpus_allowed mask from under waking tasks, which would be
-	 * possible when we change rq->lock in ttwu(), so synchronize against
-	 * TASK_WAKING to avoid that.
-	 *
-	 * Make an exception for freshly cloned tasks, since cpuset namespaces
-	 * might move the task about, we have to validate the target in
-	 * wake_up_new_task() anyway since the cpu might have gone away.
-	 */
-again:
-	while (p->state == TASK_WAKING && !(p->flags & PF_STARTING))
-		cpu_relax();
-
 	rq = task_rq_lock(p, &flags);
 
-	if (p->state == TASK_WAKING && !(p->flags & PF_STARTING)) {
-		task_rq_unlock(rq, &flags);
-		goto again;
-	}
-
 	if (!cpumask_intersects(new_mask, cpu_active_mask)) {
 		ret = -EINVAL;
 		goto out;
