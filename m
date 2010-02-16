Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756949Ab0BPOQt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Feb 2010 09:16:49 -0500
Received: from hera.kernel.org ([140.211.167.34]:44823 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756391Ab0BPOQq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Feb 2010 09:16:46 -0500
Date: Tue, 16 Feb 2010 14:16:18 GMT
From: tip-bot for Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       a.p.zijlstra@chello.nl, tglx@linutronix.de
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       a.p.zijlstra@chello.nl, tglx@linutronix.de
In-Reply-To: <1266241712.15770.420.camel@laptop>
References: <1266241712.15770.420.camel@laptop>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/urgent] sched: Fix race between ttwu() and task_rq_lock()
Message-ID: <tip-0970d2992dfd7d5ec2c787417cf464f01eeaf42a@git.kernel.org>
Git-Commit-ID: 0970d2992dfd7d5ec2c787417cf464f01eeaf42a
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Tue, 16 Feb 2010 14:16:21 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  0970d2992dfd7d5ec2c787417cf464f01eeaf42a
Gitweb:     http://git.kernel.org/tip/0970d2992dfd7d5ec2c787417cf464f01eeaf42a
Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
AuthorDate: Mon, 15 Feb 2010 14:45:54 +0100
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Tue, 16 Feb 2010 15:13:59 +0100

sched: Fix race between ttwu() and task_rq_lock()

Thomas found that due to ttwu() changing a task's cpu without holding
the rq->lock, task_rq_lock() might end up locking the wrong rq.

Avoid this by serializing against TASK_WAKING.

Reported-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
LKML-Reference: <1266241712.15770.420.camel@laptop>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 kernel/sched.c |   73 +++++++++++++++++++++++++++++++++++--------------------
 1 files changed, 46 insertions(+), 27 deletions(-)

diff --git a/kernel/sched.c b/kernel/sched.c
index 4d78aef..404e201 100644
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
@@ -2647,7 +2679,7 @@ void wake_up_new_task(struct task_struct *p, unsigned long clone_flags)
 {
 	unsigned long flags;
 	struct rq *rq;
-	int cpu __maybe_unused = get_cpu();
+	int cpu = get_cpu();
 
 #ifdef CONFIG_SMP
 	/*
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
@@ -7156,27 +7194,8 @@ int set_cpus_allowed_ptr(struct task_struct *p, const struct cpumask *new_mask)
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
