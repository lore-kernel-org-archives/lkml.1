Return-Path: <linux-kernel-owner+w=401wt.eu-S1756216AbZFAIUP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756216AbZFAIUP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jun 2009 04:20:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755715AbZFAIUB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Jun 2009 04:20:01 -0400
Received: from hera.kernel.org ([140.211.167.34]:38931 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754248AbZFAIUA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jun 2009 04:20:00 -0400
Date: Mon, 1 Jun 2009 08:19:18 GMT
From: tip-bot for Paul Mackerras <paulus@samba.org>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, acme@redhat.com, paulus@samba.org,
       hpa@zytor.com, mingo@redhat.com, jkacur@redhat.com,
       a.p.zijlstra@chello.nl, efault@gmx.de, mtosatti@redhat.com,
       tglx@linutronix.de, cjashfor@linux.vnet.ibm.com, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org, acme@redhat.com,
       linux-kernel@vger.kernel.org, jkacur@redhat.com, a.p.zijlstra@chello.nl,
       efault@gmx.de, mtosatti@redhat.com, tglx@linutronix.de,
       cjashfor@linux.vnet.ibm.com, mingo@elte.hu
In-Reply-To: <18979.35006.819769.416327@cargo.ozlabs.ibm.com>
References: <18979.35006.819769.416327@cargo.ozlabs.ibm.com>
Subject: [tip:perfcounters/core] perf_counter: Fix cpu migration counter
Message-ID: <tip-ed058219223216eabe14c0692d6e51f032043bb9@git.kernel.org>
Git-Commit-ID: ed058219223216eabe14c0692d6e51f032043bb9
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Mon, 01 Jun 2009 08:19:19 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  ed058219223216eabe14c0692d6e51f032043bb9
Gitweb:     http://git.kernel.org/tip/ed058219223216eabe14c0692d6e51f032043bb9
Author:     Paul Mackerras <paulus@samba.org>
AuthorDate: Mon, 1 Jun 2009 17:52:30 +1000
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Mon, 1 Jun 2009 10:04:07 +0200

perf_counter: Fix cpu migration counter

This fixes the cpu migration software counter to count
correctly even when contexts get swapped from one task to
another.  Previously the cpu migration counts reported by perf
stat were bogus, ranging from negative to several thousand for
a single "lat_ctx 2 8 32" run.  With this patch the cpu
migration count reported for "lat_ctx 2 8 32" is almost always
between 35 and 44.

This fixes the problem by adding a call into the perf_counter
code from set_task_cpu when tasks are migrated.  This enables
us to use the generic swcounter code (with some modifications)
for the cpu migration counter.

This modifies the swcounter code to allow a NULL regs pointer
to be passed in to perf_swcounter_ctx_event() etc.  The cpu
migration counter does this because there isn't necessarily a
pt_regs struct for the task available.  In this case, the
counter will not have interrupt capability - but the migration
counter didn't have interrupt capability before, so this is no
loss.

Signed-off-by: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: Marcelo Tosatti <mtosatti@redhat.com>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: John Kacur <jkacur@redhat.com>
LKML-Reference: <18979.35006.819769.416327@cargo.ozlabs.ibm.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


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
