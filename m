Return-Path: <linux-kernel-owner+w=401wt.eu-S1754041AbZKPRTQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754041AbZKPRTQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Nov 2009 12:19:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753643AbZKPRTO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Nov 2009 12:19:14 -0500
Received: from hera.kernel.org ([140.211.167.34]:33491 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753740AbZKPRTL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Nov 2009 12:19:11 -0500
From: Tejun Heo <tj@kernel.org>
To: linux-kernel@vger.kernel.org, jeff@garzik.org, mingo@elte.hu,
       akpm@linux-foundation.org, jens.axboe@oracle.com, rusty@rustcorp.com.au,
       cl@linux-foundation.org, dhowells@redhat.com, arjan@linux.intel.com,
       torvalds@linux-foundation.org, avi@redhat.com, peterz@infradead.org,
       andi@firstfloor.org, fweisbec@gmail.com
Cc: Tejun Heo <tj@kernel.org>
Subject: [PATCH 08/21] scheduler: implement force_cpus_allowed_ptr()
Date: Tue, 17 Nov 2009 02:15:13 +0900
Message-Id: <1258391726-30264-9-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.6.4.2
In-Reply-To: <1258391726-30264-1-git-send-email-tj@kernel.org>
References: <1258391726-30264-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Implement force_cpus_allowed_ptr() which is similar to
set_cpus_allowed_ptr() but bypasses PF_THREAD_BOUND check and ignores
cpu_active() status as long as the target cpu is online.  This will be
used for concurrency-managed workqueue.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 include/linux/sched.h |    7 ++++
 kernel/sched.c        |   88 +++++++++++++++++++++++++++++++++----------------
 2 files changed, 66 insertions(+), 29 deletions(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index 5d3a554..f283e6f 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1839,6 +1839,8 @@ static inline void rcu_copy_process(struct task_struct *p)
 #ifdef CONFIG_SMP
 extern int set_cpus_allowed_ptr(struct task_struct *p,
 				const struct cpumask *new_mask);
+extern int force_cpus_allowed_ptr(struct task_struct *p,
+				  const struct cpumask *new_mask);
 #else
 static inline int set_cpus_allowed_ptr(struct task_struct *p,
 				       const struct cpumask *new_mask)
@@ -1847,6 +1849,11 @@ static inline int set_cpus_allowed_ptr(struct task_struct *p,
 		return -EINVAL;
 	return 0;
 }
+static inline int force_cpus_allowed_ptr(struct task_struct *p,
+					 const struct cpumask *new_mask)
+{
+	return set_cpus_allowed_ptr(p, new_mask);
+}
 #endif
 
 #ifndef CONFIG_CPUMASK_OFFSTACK
diff --git a/kernel/sched.c b/kernel/sched.c
index c8868e2..a6d863b 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -2115,6 +2115,7 @@ struct migration_req {
 
 	struct task_struct *task;
 	int dest_cpu;
+	bool force;
 
 	struct completion done;
 };
@@ -2123,8 +2124,8 @@ struct migration_req {
  * The task's runqueue lock must be held.
  * Returns true if you have to wait for migration thread.
  */
-static int
-migrate_task(struct task_struct *p, int dest_cpu, struct migration_req *req)
+static int migrate_task(struct task_struct *p, int dest_cpu,
+			struct migration_req *req, bool force)
 {
 	struct rq *rq = task_rq(p);
 
@@ -2140,6 +2141,7 @@ migrate_task(struct task_struct *p, int dest_cpu, struct migration_req *req)
 	init_completion(&req->done);
 	req->task = p;
 	req->dest_cpu = dest_cpu;
+	req->force = force;
 	list_add(&req->list, &rq->migration_queue);
 
 	return 1;
@@ -3086,7 +3088,7 @@ static void sched_migrate_task(struct task_struct *p, int dest_cpu)
 		goto out;
 
 	/* force the process onto the specified CPU */
-	if (migrate_task(p, dest_cpu, &req)) {
+	if (migrate_task(p, dest_cpu, &req, false)) {
 		/* Need to wait for migration thread (might exit: take ref). */
 		struct task_struct *mt = rq->migration_thread;
 
@@ -6999,34 +7001,19 @@ static inline void sched_init_granularity(void)
  * 7) we wake up and the migration is done.
  */
 
-/*
- * Change a given task's CPU affinity. Migrate the thread to a
- * proper CPU and schedule it away if the CPU it's executing on
- * is removed from the allowed bitmask.
- *
- * NOTE: the caller must have a valid reference to the task, the
- * task must not exit() & deallocate itself prematurely. The
- * call is not atomic; no spinlocks may be held.
- */
-int set_cpus_allowed_ptr(struct task_struct *p, const struct cpumask *new_mask)
+static inline int __set_cpus_allowed_ptr(struct task_struct *p,
+					 const struct cpumask *new_mask,
+					 struct rq *rq, unsigned long *flags,
+					 bool force)
 {
 	struct migration_req req;
-	unsigned long flags;
-	struct rq *rq;
 	int ret = 0;
 
-	rq = task_rq_lock(p, &flags);
 	if (!cpumask_intersects(new_mask, cpu_online_mask)) {
 		ret = -EINVAL;
 		goto out;
 	}
 
-	if (unlikely((p->flags & PF_THREAD_BOUND) && p != current &&
-		     !cpumask_equal(&p->cpus_allowed, new_mask))) {
-		ret = -EINVAL;
-		goto out;
-	}
-
 	if (p->sched_class->set_cpus_allowed)
 		p->sched_class->set_cpus_allowed(p, new_mask);
 	else {
@@ -7038,12 +7025,13 @@ int set_cpus_allowed_ptr(struct task_struct *p, const struct cpumask *new_mask)
 	if (cpumask_test_cpu(task_cpu(p), new_mask))
 		goto out;
 
-	if (migrate_task(p, cpumask_any_and(cpu_online_mask, new_mask), &req)) {
+	if (migrate_task(p, cpumask_any_and(cpu_online_mask, new_mask), &req,
+			 force)) {
 		/* Need help from migration thread: drop lock and wait. */
 		struct task_struct *mt = rq->migration_thread;
 
 		get_task_struct(mt);
-		task_rq_unlock(rq, &flags);
+		task_rq_unlock(rq, flags);
 		wake_up_process(rq->migration_thread);
 		put_task_struct(mt);
 		wait_for_completion(&req.done);
@@ -7051,13 +7039,53 @@ int set_cpus_allowed_ptr(struct task_struct *p, const struct cpumask *new_mask)
 		return 0;
 	}
 out:
-	task_rq_unlock(rq, &flags);
+	task_rq_unlock(rq, flags);
 
 	return ret;
 }
+
+/*
+ * Change a given task's CPU affinity. Migrate the thread to a
+ * proper CPU and schedule it away if the CPU it's executing on
+ * is removed from the allowed bitmask.
+ *
+ * NOTE: the caller must have a valid reference to the task, the
+ * task must not exit() & deallocate itself prematurely. The
+ * call is not atomic; no spinlocks may be held.
+ */
+int set_cpus_allowed_ptr(struct task_struct *p, const struct cpumask *new_mask)
+{
+	unsigned long flags;
+	struct rq *rq;
+
+	rq = task_rq_lock(p, &flags);
+
+	if (unlikely((p->flags & PF_THREAD_BOUND) && p != current &&
+		     !cpumask_equal(&p->cpus_allowed, new_mask))) {
+		task_rq_unlock(rq, &flags);
+		return -EINVAL;
+	}
+
+	return __set_cpus_allowed_ptr(p, new_mask, rq, &flags, false);
+}
 EXPORT_SYMBOL_GPL(set_cpus_allowed_ptr);
 
 /*
+ * Similar to set_cpus_allowed_ptr() but bypasses PF_THREAD_BOUND
+ * check and ignores cpu_active() status as long as the cpu is online.
+ * The caller is responsible for ensuring things don't go bonkers.
+ */
+int force_cpus_allowed_ptr(struct task_struct *p,
+			   const struct cpumask *new_mask)
+{
+	unsigned long flags;
+	struct rq *rq;
+
+	rq = task_rq_lock(p, &flags);
+	return __set_cpus_allowed_ptr(p, new_mask, rq, &flags, true);
+}
+
+/*
  * Move (not current) task off this cpu, onto dest cpu. We're doing
  * this because either it can't run here any more (set_cpus_allowed()
  * away from this CPU, or CPU going down), or because we're
@@ -7068,12 +7096,13 @@ EXPORT_SYMBOL_GPL(set_cpus_allowed_ptr);
  *
  * Returns non-zero if task was successfully migrated.
  */
-static int __migrate_task(struct task_struct *p, int src_cpu, int dest_cpu)
+static int __migrate_task(struct task_struct *p, int src_cpu, int dest_cpu,
+			  bool force)
 {
 	struct rq *rq_dest, *rq_src;
 	int ret = 0, on_rq;
 
-	if (unlikely(!cpu_active(dest_cpu)))
+	if (!force && unlikely(!cpu_active(dest_cpu)))
 		return ret;
 
 	rq_src = cpu_rq(src_cpu);
@@ -7152,7 +7181,8 @@ static int migration_thread(void *data)
 
 		if (req->task != NULL) {
 			spin_unlock(&rq->lock);
-			__migrate_task(req->task, cpu, req->dest_cpu);
+			__migrate_task(req->task, cpu, req->dest_cpu,
+				       req->force);
 		} else if (likely(cpu == (badcpu = smp_processor_id()))) {
 			req->dest_cpu = RCU_MIGRATION_GOT_QS;
 			spin_unlock(&rq->lock);
@@ -7177,7 +7207,7 @@ static int __migrate_task_irq(struct task_struct *p, int src_cpu, int dest_cpu)
 	int ret;
 
 	local_irq_disable();
-	ret = __migrate_task(p, src_cpu, dest_cpu);
+	ret = __migrate_task(p, src_cpu, dest_cpu, false);
 	local_irq_enable();
 	return ret;
 }
-- 
1.6.4.2

