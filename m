Return-Path: <linux-kernel-owner+w=401wt.eu-S1756012AbZFAHx5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756012AbZFAHx5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jun 2009 03:53:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754955AbZFAHx2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Jun 2009 03:53:28 -0400
Received: from bilbo.ozlabs.org ([203.10.76.25]:55084 "EHLO bilbo.ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753686AbZFAHx1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jun 2009 03:53:27 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18979.35006.819769.416327@cargo.ozlabs.ibm.com>
Date: Mon, 1 Jun 2009 17:52:30 +1000
From: Paul Mackerras <paulus@samba.org>
To: Ingo Molnar <mingo@elte.hu>
CC: Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-kernel@vger.kernel.org
Subject: [PATCH] perf_counter: Fix cpu migration counter
In-Reply-To: <18979.34748.755674.596386@cargo.ozlabs.ibm.com>
References: <18979.34748.755674.596386@cargo.ozlabs.ibm.com>
X-Mailer: VM 8.0.12 under 22.2.1 (i486-pc-linux-gnu)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This fixes the cpu migration software counter to count correctly even
when contexts get swapped from one task to another.  Previously the
cpu migration counts reported by perf stat were bogus, ranging from
negative to several thousand for a single "lat_ctx 2 8 32" run.  With
this patch the cpu migration count reported for "lat_ctx 2 8 32" is
almost always between 35 and 44.

This fixes the problem by adding a call into the perf_counter code
from set_task_cpu when tasks are migrated.  This enables us to use the
generic swcounter code (with some modifications) for the cpu migration
counter.

This modifies the swcounter code to allow a NULL regs pointer to be
passed in to perf_swcounter_ctx_event() etc.  The cpu migration
counter does this because there isn't necessarily a pt_regs struct for
the task available.  In this case, the counter will not have interrupt
capability - but the migration counter didn't have interrupt
capability before, so this is no loss.

Signed-off-by: Paul Mackerras <paulus@samba.org>
---
 include/linux/perf_counter.h |    4 ++
 kernel/perf_counter.c        |   74 ++++++++++++------------------------------
 kernel/sched.c               |    1 +
 3 files changed, 26 insertions(+), 53 deletions(-)

diff --git a/include/linux/perf_counter.h b/include/linux/perf_counter.h
index 81ec79c..e630602 100644
--- a/include/linux/perf_counter.h
+++ b/include/linux/perf_counter.h
@@ -615,6 +615,8 @@ extern void perf_counter_munmap(unsigned long addr, unsigned long len,
 
 extern void perf_counter_comm(struct task_struct *tsk);
 
+extern void perf_counter_task_migration(struct task_struct *task, int cpu);
+
 #define MAX_STACK_DEPTH		255
 
 struct perf_callchain_entry {
@@ -668,6 +670,8 @@ perf_counter_munmap(unsigned long addr, unsigned long len,
 
 static inline void perf_counter_comm(struct task_struct *tsk)		{ }
 static inline void perf_counter_init(void)				{ }
+static inline void perf_counter_task_migration(struct task_struct *task,
+					       int cpu)			{ }
 #endif
 
 #endif /* __KERNEL__ */
diff --git a/kernel/perf_counter.c b/kernel/perf_counter.c
index ff8b463..c7a20fa 100644
--- a/kernel/perf_counter.c
+++ b/kernel/perf_counter.c
@@ -2919,11 +2919,13 @@ static int perf_swcounter_match(struct perf_counter *counter,
 	if (counter->hw_event.config != event_config)
 		return 0;
 
-	if (counter->hw_event.exclude_user && user_mode(regs))
-		return 0;
+	if (regs) {
+		if (counter->hw_event.exclude_user && user_mode(regs))
+			return 0;
 
-	if (counter->hw_event.exclude_kernel && !user_mode(regs))
-		return 0;
+		if (counter->hw_event.exclude_kernel && !user_mode(regs))
+			return 0;
+	}
 
 	return 1;
 }
@@ -2932,7 +2934,7 @@ static void perf_swcounter_add(struct perf_counter *counter, u64 nr,
 			       int nmi, struct pt_regs *regs, u64 addr)
 {
 	int neg = atomic64_add_negative(nr, &counter->hw.count);
-	if (counter->hw.irq_period && !neg)
+	if (counter->hw.irq_period && !neg && regs)
 		perf_swcounter_overflow(counter, nmi, regs, addr);
 }
 
@@ -3148,55 +3150,24 @@ static const struct pmu perf_ops_task_clock = {
 /*
  * Software counter: cpu migrations
  */
-
-static inline u64 get_cpu_migrations(struct perf_counter *counter)
-{
-	struct task_struct *curr = counter->ctx->task;
-
-	if (curr)
-		return curr->se.nr_migrations;
-	return cpu_nr_migrations(smp_processor_id());
-}
-
-static void cpu_migrations_perf_counter_update(struct perf_counter *counter)
-{
-	u64 prev, now;
-	s64 delta;
-
-	prev = atomic64_read(&counter->hw.prev_count);
-	now = get_cpu_migrations(counter);
-
-	atomic64_set(&counter->hw.prev_count, now);
-
-	delta = now - prev;
-
-	atomic64_add(delta, &counter->count);
-}
-
-static void cpu_migrations_perf_counter_read(struct perf_counter *counter)
+void perf_counter_task_migration(struct task_struct *task, int cpu)
 {
-	cpu_migrations_perf_counter_update(counter);
-}
+	struct perf_cpu_context *cpuctx = &per_cpu(perf_cpu_context, cpu);
+	struct perf_counter_context *ctx;
 
-static int cpu_migrations_perf_counter_enable(struct perf_counter *counter)
-{
-	if (counter->prev_state <= PERF_COUNTER_STATE_OFF)
-		atomic64_set(&counter->hw.prev_count,
-			     get_cpu_migrations(counter));
-	return 0;
-}
+	perf_swcounter_ctx_event(&cpuctx->ctx, PERF_TYPE_SOFTWARE,
+				 PERF_COUNT_CPU_MIGRATIONS,
+				 1, 1, NULL, 0);
 
-static void cpu_migrations_perf_counter_disable(struct perf_counter *counter)
-{
-	cpu_migrations_perf_counter_update(counter);
+	ctx = perf_pin_task_context(task);
+	if (ctx) {
+		perf_swcounter_ctx_event(ctx, PERF_TYPE_SOFTWARE,
+					 PERF_COUNT_CPU_MIGRATIONS,
+					 1, 1, NULL, 0);
+		perf_unpin_context(ctx);
+	}
 }
 
-static const struct pmu perf_ops_cpu_migrations = {
-	.enable		= cpu_migrations_perf_counter_enable,
-	.disable	= cpu_migrations_perf_counter_disable,
-	.read		= cpu_migrations_perf_counter_read,
-};
-
 #ifdef CONFIG_EVENT_PROFILE
 void perf_tpcounter_event(int event_id)
 {
@@ -3269,11 +3240,8 @@ static const struct pmu *sw_perf_counter_init(struct perf_counter *counter)
 	case PERF_COUNT_PAGE_FAULTS_MIN:
 	case PERF_COUNT_PAGE_FAULTS_MAJ:
 	case PERF_COUNT_CONTEXT_SWITCHES:
-		pmu = &perf_ops_generic;
-		break;
 	case PERF_COUNT_CPU_MIGRATIONS:
-		if (!counter->hw_event.exclude_kernel)
-			pmu = &perf_ops_cpu_migrations;
+		pmu = &perf_ops_generic;
 		break;
 	}
 
diff --git a/kernel/sched.c b/kernel/sched.c
index ad079f0..a55c192 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -1977,6 +1977,7 @@ void set_task_cpu(struct task_struct *p, unsigned int new_cpu)
 		if (task_hot(p, old_rq->clock, NULL))
 			schedstat_inc(p, se.nr_forced2_migrations);
 #endif
+		perf_counter_task_migration(p, new_cpu);
 	}
 	p->se.vruntime -= old_cfsrq->min_vruntime -
 					 new_cfsrq->min_vruntime;
-- 
1.6.0.4

