Return-Path: <linux-kernel-owner+w=401wt.eu-S1754261AbZKVMJk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754261AbZKVMJk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Nov 2009 07:09:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751753AbZKVMJj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Nov 2009 07:09:39 -0500
Received: from mail.gmx.net ([213.165.64.20]:59802 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751607AbZKVMJi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Nov 2009 07:09:38 -0500
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1/HUPFh0gLHdF543SVWt3HNtViEJU7N51oM56rBhU
	Bum5nPuL633221
Subject: [patch] sched: fix set_task_cpu() and provide an unlocked runqueue
 variant
From: Mike Galbraith <efault@gmx.de>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Sun, 22 Nov 2009 13:09:41 +0100
Message-Id: <1258891781.14325.34.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1.1 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.46
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


sched: fix set_task_cpu() and provide an unlocked runqueue variant.

set_task_cpu() falsifies migration stats by unconditionally generating migration
stats whether a task's cpu actually changed or not.  As used in copy_process(),
the runqueue is unlocked, so we need to provide an unlocked variant which does
the locking to provide a write barrier.

Signed-off-by: Mike Galbraith <efault@gmx.de>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
LKML-Reference: <new-submission>

---
 include/linux/sched.h |    5 +++++
 kernel/fork.c         |    2 +-
 kernel/sched.c        |   38 ++++++++++++++++++++++++--------------
 3 files changed, 30 insertions(+), 15 deletions(-)

Index: linux-2.6/kernel/sched.c
===================================================================
--- linux-2.6.orig/kernel/sched.c
+++ linux-2.6/kernel/sched.c
@@ -2056,7 +2056,6 @@ task_hot(struct task_struct *p, u64 now,
 	return delta < (s64)sysctl_sched_migration_cost;
 }
 
-
 void set_task_cpu(struct task_struct *p, unsigned int new_cpu)
 {
 	int old_cpu = task_cpu(p);
@@ -2065,10 +2064,10 @@ void set_task_cpu(struct task_struct *p,
 		      *new_cfsrq = cpu_cfs_rq(old_cfsrq, new_cpu);
 	u64 clock_offset;
 
-	clock_offset = old_rq->clock - new_rq->clock;
-
-	trace_sched_migrate_task(p, new_cpu);
+	if (unlikely(old_cpu == new_cpu))
+		goto out;
 
+	clock_offset = old_rq->clock - new_rq->clock;
 #ifdef CONFIG_SCHEDSTATS
 	if (p->se.wait_start)
 		p->se.wait_start -= clock_offset;
@@ -2076,22 +2075,33 @@ void set_task_cpu(struct task_struct *p,
 		p->se.sleep_start -= clock_offset;
 	if (p->se.block_start)
 		p->se.block_start -= clock_offset;
+	if (task_hot(p, old_rq->clock, NULL))
+		schedstat_inc(p, se.nr_forced2_migrations);
 #endif
-	if (old_cpu != new_cpu) {
-		p->se.nr_migrations++;
-#ifdef CONFIG_SCHEDSTATS
-		if (task_hot(p, old_rq->clock, NULL))
-			schedstat_inc(p, se.nr_forced2_migrations);
-#endif
-		perf_sw_event(PERF_COUNT_SW_CPU_MIGRATIONS,
-				     1, 1, NULL, 0);
-	}
 	p->se.vruntime -= old_cfsrq->min_vruntime -
-					 new_cfsrq->min_vruntime;
+				 new_cfsrq->min_vruntime;
+	p->se.nr_migrations++;
+	trace_sched_migrate_task(p, new_cpu);
+	perf_sw_event(PERF_COUNT_SW_CPU_MIGRATIONS, 1, 1, NULL, 0);
 
+out:
 	__set_task_cpu(p, new_cpu);
 }
 
+void set_task_cpu_unlocked(struct task_struct *p, unsigned int new_cpu)
+{
+	unsigned long flags;
+	struct rq *rq, *new_rq = cpu_rq(new_cpu);
+
+	smp_wmb();
+	rq = task_rq_lock(p, &flags);
+	update_rq_clock(rq);
+	if (rq != new_rq)
+		update_rq_clock(new_rq);
+	set_task_cpu(p, new_cpu);
+	task_rq_unlock(rq, &flags);
+}
+
 struct migration_req {
 	struct list_head list;
 
Index: linux-2.6/include/linux/sched.h
===================================================================
--- linux-2.6.orig/include/linux/sched.h
+++ linux-2.6/include/linux/sched.h
@@ -2457,6 +2457,7 @@ static inline unsigned int task_cpu(cons
 }
 
 extern void set_task_cpu(struct task_struct *p, unsigned int cpu);
+extern void set_task_cpu_unlocked(struct task_struct *p, unsigned int cpu);
 
 #else
 
@@ -2469,6 +2470,10 @@ static inline void set_task_cpu(struct t
 {
 }
 
+static inline void set_task_cpu_unlocked(struct task_struct *p, unsigned int cpu)
+{
+}
+
 #endif /* CONFIG_SMP */
 
 extern void arch_pick_mmap_layout(struct mm_struct *mm);
Index: linux-2.6/kernel/fork.c
===================================================================
--- linux-2.6.orig/kernel/fork.c
+++ linux-2.6/kernel/fork.c
@@ -1242,7 +1242,7 @@ static struct task_struct *copy_process(
 	p->rt.nr_cpus_allowed = current->rt.nr_cpus_allowed;
 	if (unlikely(!cpu_isset(task_cpu(p), p->cpus_allowed) ||
 			!cpu_online(task_cpu(p))))
-		set_task_cpu(p, smp_processor_id());
+		set_task_cpu_unlocked(p, smp_processor_id());
 
 	/* CLONE_PARENT re-uses the old parent */
 	if (clone_flags & (CLONE_PARENT|CLONE_THREAD)) {


