Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936046Ab0BZMPM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Feb 2010 07:15:12 -0500
Received: from hera.kernel.org ([140.211.167.34]:43493 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935936Ab0BZMO7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Feb 2010 07:14:59 -0500
From: Tejun Heo <tj@kernel.org>
To: torvalds@linux-foundation.org, mingo@elte.hu, peterz@infradead.org,
       awalls@radix.net, linux-kernel@vger.kernel.org, jeff@garzik.org,
       akpm@linux-foundation.org, jens.axboe@oracle.com, rusty@rustcorp.com.au,
       cl@linux-foundation.org, dhowells@redhat.com, arjan@linux.intel.com,
       avi@redhat.com, johannes@sipsolutions.net, andi@firstfloor.org,
       oleg@redhat.com
Cc: Tejun Heo <tj@kernel.org>, Mike Galbraith <efault@gmx.de>
Subject: [PATCH 04/43] sched: implement __set_cpus_allowed()
Date: Fri, 26 Feb 2010 21:22:41 +0900
Message-Id: <1267187000-18791-5-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.6.4.2
In-Reply-To: <1267187000-18791-1-git-send-email-tj@kernel.org>
References: <1267187000-18791-1-git-send-email-tj@kernel.org>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Fri, 26 Feb 2010 12:13:23 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

set_cpus_allowed_ptr() modifies the allowed cpu mask of a task.  The
function performs the following checks before applying new mask.

* Check whether PF_THREAD_BOUND is set.  This is set for bound
  kthreads so that they can't be moved around.

* Check whether the target cpu is still marked active - cpu_active().
  Active state is cleared early while downing a cpu.

This patch adds __set_cpus_allowed() which takes @force parameter
which when true makes __set_cpus_allowed() ignore PF_THREAD_BOUND and
use cpu online state instead of active state for the latter.  This
allows migrating tasks to CPUs as long as they are online.
set_cpus_allowed_ptr() is implemented as inline wrapper around
__set_cpus_allowed().

Due to the way migration is implemented, the @force parameter needs to
be passed over to the migration thread.  @force parameter is added to
struct migration_req and passed to __migrate_task().

Please note the naming discrepancy between set_cpus_allowed_ptr() and
the new functions.  The _ptr suffix is from the days when cpumask API
wasn't mature and future changes should drop it from
set_cpus_allowed_ptr() too.

NOTE: It would be nice to implement kthread_bind() in terms of
      __set_cpus_allowed() if we can drop the capability to bind to a
      dead CPU from kthread_bind(), which doesn't seem too popular
      anyway.  With such change, we'll have set_cpus_allowed_ptr() for
      regular tasks and kthread_bind() for kthreads and can use
      PF_THREAD_BOUND instead of passing @force parameter around.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Ingo Molnar <mingo@elte.hu>
---
 include/linux/sched.h |   14 +++++++++---
 kernel/sched.c        |   55 ++++++++++++++++++++++++++++++++-----------------
 2 files changed, 46 insertions(+), 23 deletions(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index 184389d..c4f6797 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1880,11 +1880,11 @@ static inline void rcu_copy_process(struct task_struct *p)
 #endif
 
 #ifdef CONFIG_SMP
-extern int set_cpus_allowed_ptr(struct task_struct *p,
-				const struct cpumask *new_mask);
+extern int __set_cpus_allowed(struct task_struct *p,
+			      const struct cpumask *new_mask, bool force);
 #else
-static inline int set_cpus_allowed_ptr(struct task_struct *p,
-				       const struct cpumask *new_mask)
+static inline int __set_cpus_allowed(struct task_struct *p,
+				     const struct cpumask *new_mask, bool force)
 {
 	if (!cpumask_test_cpu(0, new_mask))
 		return -EINVAL;
@@ -1892,6 +1892,12 @@ static inline int set_cpus_allowed_ptr(struct task_struct *p,
 }
 #endif
 
+static inline int set_cpus_allowed_ptr(struct task_struct *p,
+				       const struct cpumask *new_mask)
+{
+	return __set_cpus_allowed(p, new_mask, false);
+}
+
 #ifndef CONFIG_CPUMASK_OFFSTACK
 static inline int set_cpus_allowed(struct task_struct *p, cpumask_t new_mask)
 {
diff --git a/kernel/sched.c b/kernel/sched.c
index 4632b13..cb54af8 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -2096,6 +2096,7 @@ struct migration_req {
 
 	struct task_struct *task;
 	int dest_cpu;
+	bool force;
 
 	struct completion done;
 };
@@ -2104,8 +2105,8 @@ struct migration_req {
  * The task's runqueue lock must be held.
  * Returns true if you have to wait for migration thread.
  */
-static int
-migrate_task(struct task_struct *p, int dest_cpu, struct migration_req *req)
+static int migrate_task(struct task_struct *p, int dest_cpu, bool force,
+			struct migration_req *req)
 {
 	struct rq *rq = task_rq(p);
 
@@ -2119,6 +2120,7 @@ migrate_task(struct task_struct *p, int dest_cpu, struct migration_req *req)
 	init_completion(&req->done);
 	req->task = p;
 	req->dest_cpu = dest_cpu;
+	req->force = force;
 	list_add(&req->list, &rq->migration_queue);
 
 	return 1;
@@ -3170,7 +3172,7 @@ again:
 	}
 
 	/* force the process onto the specified CPU */
-	if (migrate_task(p, dest_cpu, &req)) {
+	if (migrate_task(p, dest_cpu, false, &req)) {
 		/* Need to wait for migration thread (might exit: take ref). */
 		struct task_struct *mt = rq->migration_thread;
 
@@ -7124,17 +7126,27 @@ static inline void sched_init_granularity(void)
  * 7) we wake up and the migration is done.
  */
 
-/*
- * Change a given task's CPU affinity. Migrate the thread to a
- * proper CPU and schedule it away if the CPU it's executing on
- * is removed from the allowed bitmask.
+/**
+ * __set_cpus_allowed - change a task's CPU affinity
+ * @p: task to change CPU affinity for
+ * @new_mask: new CPU affinity
+ * @force: override CPU active status and PF_THREAD_BOUND check
+ *
+ * Migrate the thread to a proper CPU and schedule it away if the CPU
+ * it's executing on is removed from the allowed bitmask.
+ *
+ * The caller must have a valid reference to the task, the task must
+ * not exit() & deallocate itself prematurely. The call is not atomic;
+ * no spinlocks may be held.
  *
- * NOTE: the caller must have a valid reference to the task, the
- * task must not exit() & deallocate itself prematurely. The
- * call is not atomic; no spinlocks may be held.
+ * If @force is %true, PF_THREAD_BOUND test is bypassed and CPU active
+ * state is ignored as long as the CPU is online.
  */
-int set_cpus_allowed_ptr(struct task_struct *p, const struct cpumask *new_mask)
+int __set_cpus_allowed(struct task_struct *p, const struct cpumask *new_mask,
+		       bool force)
 {
+	const struct cpumask *cpu_cand_mask =
+		force ? cpu_online_mask : cpu_active_mask;
 	struct migration_req req;
 	unsigned long flags;
 	struct rq *rq;
@@ -7161,12 +7173,12 @@ again:
 		goto again;
 	}
 
-	if (!cpumask_intersects(new_mask, cpu_active_mask)) {
+	if (!cpumask_intersects(new_mask, cpu_cand_mask)) {
 		ret = -EINVAL;
 		goto out;
 	}
 
-	if (unlikely((p->flags & PF_THREAD_BOUND) && p != current &&
+	if (unlikely((p->flags & PF_THREAD_BOUND) && !force && p != current &&
 		     !cpumask_equal(&p->cpus_allowed, new_mask))) {
 		ret = -EINVAL;
 		goto out;
@@ -7183,7 +7195,8 @@ again:
 	if (cpumask_test_cpu(task_cpu(p), new_mask))
 		goto out;
 
-	if (migrate_task(p, cpumask_any_and(cpu_active_mask, new_mask), &req)) {
+	if (migrate_task(p, cpumask_any_and(cpu_cand_mask, new_mask), force,
+			 &req)) {
 		/* Need help from migration thread: drop lock and wait. */
 		struct task_struct *mt = rq->migration_thread;
 
@@ -7200,7 +7213,7 @@ out:
 
 	return ret;
 }
-EXPORT_SYMBOL_GPL(set_cpus_allowed_ptr);
+EXPORT_SYMBOL_GPL(__set_cpus_allowed);
 
 /*
  * Move (not current) task off this cpu, onto dest cpu. We're doing
@@ -7213,12 +7226,15 @@ EXPORT_SYMBOL_GPL(set_cpus_allowed_ptr);
  *
  * Returns non-zero if task was successfully migrated.
  */
-static int __migrate_task(struct task_struct *p, int src_cpu, int dest_cpu)
+static int __migrate_task(struct task_struct *p, int src_cpu, int dest_cpu,
+			  bool force)
 {
+	const struct cpumask *cpu_cand_mask =
+		force ? cpu_online_mask : cpu_active_mask;
 	struct rq *rq_dest, *rq_src;
 	int ret = 0;
 
-	if (unlikely(!cpu_active(dest_cpu)))
+	if (unlikely(!cpumask_test_cpu(dest_cpu, cpu_cand_mask)))
 		return ret;
 
 	rq_src = cpu_rq(src_cpu);
@@ -7298,7 +7314,8 @@ static int migration_thread(void *data)
 
 		if (req->task != NULL) {
 			raw_spin_unlock(&rq->lock);
-			__migrate_task(req->task, cpu, req->dest_cpu);
+			__migrate_task(req->task, cpu, req->dest_cpu,
+				       req->force);
 		} else if (likely(cpu == (badcpu = smp_processor_id()))) {
 			req->dest_cpu = RCU_MIGRATION_GOT_QS;
 			raw_spin_unlock(&rq->lock);
@@ -7323,7 +7340,7 @@ static int __migrate_task_irq(struct task_struct *p, int src_cpu, int dest_cpu)
 	int ret;
 
 	local_irq_disable();
-	ret = __migrate_task(p, src_cpu, dest_cpu);
+	ret = __migrate_task(p, src_cpu, dest_cpu, false);
 	local_irq_enable();
 	return ret;
 }
-- 
1.6.4.2

