Return-Path: <linux-kernel-owner+w=401wt.eu-S1762842AbZLPSlh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762842AbZLPSlh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Dec 2009 13:41:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935173AbZLPSia
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Dec 2009 13:38:30 -0500
Received: from hera.kernel.org ([140.211.167.34]:53464 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935170AbZLPSi2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Dec 2009 13:38:28 -0500
Date: Wed, 16 Dec 2009 18:37:52 GMT
From: tip-bot for Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       a.p.zijlstra@chello.nl, efault@gmx.de, tglx@linutronix.de,
       mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       a.p.zijlstra@chello.nl, efault@gmx.de, tglx@linutronix.de,
       mingo@elte.hu
In-Reply-To: <20091216170517.807938893@chello.nl>
References: <20091216170517.807938893@chello.nl>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/urgent] sched: Ensure set_task_cpu() is never called on blocked tasks
Message-ID: <tip-e2912009fb7b715728311b0d8fe327a1432b3f79@git.kernel.org>
Git-Commit-ID: e2912009fb7b715728311b0d8fe327a1432b3f79
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  e2912009fb7b715728311b0d8fe327a1432b3f79
Gitweb:     http://git.kernel.org/tip/e2912009fb7b715728311b0d8fe327a1432b3f79
Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
AuthorDate: Wed, 16 Dec 2009 18:04:36 +0100
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 16 Dec 2009 19:01:56 +0100

sched: Ensure set_task_cpu() is never called on blocked tasks

In order to clean up the set_task_cpu() rq dependencies we need
to ensure it is never called on blocked tasks because such usage
does not pair with consistent rq->lock usage.

This puts the migration burden on ttwu().

Furthermore we need to close a race against changing
->cpus_allowed, since select_task_rq() runs with only preemption
disabled.

For sched_fork() this is safe because the child isn't in the
tasklist yet, for wakeup we fix this by synchronizing
set_cpus_allowed_ptr() against TASK_WAKING, which leaves
sched_exec to be a problem

This also closes a hole in (6ad4c1888 sched: Fix balance vs
hotplug race) where ->select_task_rq() doesn't validate the
result against the sched_domain/root_domain.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Mike Galbraith <efault@gmx.de>
LKML-Reference: <20091216170517.807938893@chello.nl>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/sched.c |   85 +++++++++++++++++++++++++++++++++++++++++++------------
 1 files changed, 66 insertions(+), 19 deletions(-)

diff --git a/kernel/sched.c b/kernel/sched.c
index 1672823..33d7965 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -2018,22 +2018,15 @@ static inline void check_class_changed(struct rq *rq, struct task_struct *p,
  */
 void kthread_bind(struct task_struct *p, unsigned int cpu)
 {
-	struct rq *rq = cpu_rq(cpu);
-	unsigned long flags;
-
 	/* Must have done schedule() in kthread() before we set_task_cpu */
 	if (!wait_task_inactive(p, TASK_UNINTERRUPTIBLE)) {
 		WARN_ON(1);
 		return;
 	}
 
-	raw_spin_lock_irqsave(&rq->lock, flags);
-	update_rq_clock(rq);
-	set_task_cpu(p, cpu);
 	p->cpus_allowed = cpumask_of_cpu(cpu);
 	p->rt.nr_cpus_allowed = 1;
 	p->flags |= PF_THREAD_BOUND;
-	raw_spin_unlock_irqrestore(&rq->lock, flags);
 }
 EXPORT_SYMBOL(kthread_bind);
 
@@ -2074,6 +2067,14 @@ void set_task_cpu(struct task_struct *p, unsigned int new_cpu)
 	struct cfs_rq *old_cfsrq = task_cfs_rq(p),
 		      *new_cfsrq = cpu_cfs_rq(old_cfsrq, new_cpu);
 
+#ifdef CONFIG_SCHED_DEBUG
+	/*
+	 * We should never call set_task_cpu() on a blocked task,
+	 * ttwu() will sort out the placement.
+	 */
+	WARN_ON(p->state != TASK_RUNNING && p->state != TASK_WAKING);
+#endif
+
 	trace_sched_migrate_task(p, new_cpu);
 
 	if (old_cpu != new_cpu) {
@@ -2107,13 +2108,10 @@ migrate_task(struct task_struct *p, int dest_cpu, struct migration_req *req)
 
 	/*
 	 * If the task is not on a runqueue (and not running), then
-	 * it is sufficient to simply update the task's cpu field.
+	 * the next wake-up will properly place the task.
 	 */
-	if (!p->se.on_rq && !task_running(rq, p)) {
-		update_rq_clock(rq);
-		set_task_cpu(p, dest_cpu);
+	if (!p->se.on_rq && !task_running(rq, p))
 		return 0;
-	}
 
 	init_completion(&req->done);
 	req->task = p;
@@ -2319,10 +2317,42 @@ void task_oncpu_function_call(struct task_struct *p,
 }
 
 #ifdef CONFIG_SMP
+/*
+ * Called from:
+ *
+ *  - fork, @p is stable because it isn't on the tasklist yet
+ *
+ *  - exec, @p is unstable XXX
+ *
+ *  - wake-up, we serialize ->cpus_allowed against TASK_WAKING so
+ *             we should be good.
+ */
 static inline
 int select_task_rq(struct task_struct *p, int sd_flags, int wake_flags)
 {
-	return p->sched_class->select_task_rq(p, sd_flags, wake_flags);
+	int cpu = p->sched_class->select_task_rq(p, sd_flags, wake_flags);
+
+	/*
+	 * In order not to call set_task_cpu() on a blocking task we need
+	 * to rely on ttwu() to place the task on a valid ->cpus_allowed
+	 * cpu.
+	 *
+	 * Since this is common to all placement strategies, this lives here.
+	 *
+	 * [ this allows ->select_task() to simply return task_cpu(p) and
+	 *   not worry about this generic constraint ]
+	 */
+	if (unlikely(!cpumask_test_cpu(cpu, &p->cpus_allowed) ||
+		     !cpu_active(cpu))) {
+
+		cpu = cpumask_any_and(&p->cpus_allowed, cpu_active_mask);
+		/*
+		 * XXX: race against hot-plug modifying cpu_active_mask
+		 */
+		BUG_ON(cpu >= nr_cpu_ids);
+	}
+
+	return cpu;
 }
 #endif
 
@@ -7098,7 +7128,23 @@ int set_cpus_allowed_ptr(struct task_struct *p, const struct cpumask *new_mask)
 	struct rq *rq;
 	int ret = 0;
 
+	/*
+	 * Since we rely on wake-ups to migrate sleeping tasks, don't change
+	 * the ->cpus_allowed mask from under waking tasks, which would be
+	 * possible when we change rq->lock in ttwu(), so synchronize against
+	 * TASK_WAKING to avoid that.
+	 */
+again:
+	while (p->state == TASK_WAKING)
+		cpu_relax();
+
 	rq = task_rq_lock(p, &flags);
+
+	if (p->state == TASK_WAKING) {
+		task_rq_unlock(rq, &flags);
+		goto again;
+	}
+
 	if (!cpumask_intersects(new_mask, cpu_active_mask)) {
 		ret = -EINVAL;
 		goto out;
@@ -7154,7 +7200,7 @@ EXPORT_SYMBOL_GPL(set_cpus_allowed_ptr);
 static int __migrate_task(struct task_struct *p, int src_cpu, int dest_cpu)
 {
 	struct rq *rq_dest, *rq_src;
-	int ret = 0, on_rq;
+	int ret = 0;
 
 	if (unlikely(!cpu_active(dest_cpu)))
 		return ret;
@@ -7170,12 +7216,13 @@ static int __migrate_task(struct task_struct *p, int src_cpu, int dest_cpu)
 	if (!cpumask_test_cpu(dest_cpu, &p->cpus_allowed))
 		goto fail;
 
-	on_rq = p->se.on_rq;
-	if (on_rq)
+	/*
+	 * If we're not on a rq, the next wake-up will ensure we're
+	 * placed properly.
+	 */
+	if (p->se.on_rq) {
 		deactivate_task(rq_src, p, 0);
-
-	set_task_cpu(p, dest_cpu);
-	if (on_rq) {
+		set_task_cpu(p, dest_cpu);
 		activate_task(rq_dest, p, 0);
 		check_preempt_curr(rq_dest, p, 0);
 	}
