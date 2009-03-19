Return-Path: <linux-kernel-owner+w=401wt.eu-S1760701AbZCSToF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760701AbZCSToF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Mar 2009 15:44:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758546AbZCSTnW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Mar 2009 15:43:22 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:53492 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755065AbZCSTnU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Mar 2009 15:43:20 -0400
Message-Id: <20090319194233.283522645@chello.nl>
References: <20090319192610.660857280@chello.nl>
User-Agent: quilt/0.46-1
Date: Thu, 19 Mar 2009 20:26:12 +0100
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: mingo@elte.hu, paulus@samba.org, rostedt@goodmis.org
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [PATCH 02/10] perf_counter: generic context switch event
Content-Disposition: inline; filename=perf_swcounter_ctx.patch
X-Bad-Reply: References but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

use the generic software events for context switches.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 include/linux/sched.h |    1 
 kernel/perf_counter.c |   60 +++-----------------------------------------------
 kernel/sched.c        |    6 -----
 3 files changed, 4 insertions(+), 63 deletions(-)

Index: linux-2.6/include/linux/sched.h
===================================================================
--- linux-2.6.orig/include/linux/sched.h
+++ linux-2.6/include/linux/sched.h
@@ -137,7 +137,6 @@ extern unsigned long nr_running(void);
 extern unsigned long nr_uninterruptible(void);
 extern unsigned long nr_active(void);
 extern unsigned long nr_iowait(void);
-extern u64 cpu_nr_switches(int cpu);
 extern u64 cpu_nr_migrations(int cpu);
 
 extern unsigned long get_parent_ip(unsigned long addr);
Index: linux-2.6/kernel/perf_counter.c
===================================================================
--- linux-2.6.orig/kernel/perf_counter.c
+++ linux-2.6/kernel/perf_counter.c
@@ -710,10 +710,13 @@ void perf_counter_task_sched_out(struct 
 {
 	struct perf_cpu_context *cpuctx = &per_cpu(perf_cpu_context, cpu);
 	struct perf_counter_context *ctx = &task->perf_counter_ctx;
+	struct pt_regs *regs;
 
 	if (likely(!cpuctx->task_ctx))
 		return;
 
+	regs = task_pt_regs(task);
+	perf_swcounter_event(PERF_COUNT_CONTEXT_SWITCHES, 1, 1, regs);
 	__perf_counter_sched_out(ctx, cpuctx);
 
 	cpuctx->task_ctx = NULL;
@@ -1671,58 +1674,6 @@ static const struct hw_perf_counter_ops 
 };
 
 /*
- * Software counter: context switches
- */
-
-static u64 get_context_switches(struct perf_counter *counter)
-{
-	struct task_struct *curr = counter->ctx->task;
-
-	if (curr)
-		return curr->nvcsw + curr->nivcsw;
-	return cpu_nr_switches(smp_processor_id());
-}
-
-static void context_switches_perf_counter_update(struct perf_counter *counter)
-{
-	u64 prev, now;
-	s64 delta;
-
-	prev = atomic64_read(&counter->hw.prev_count);
-	now = get_context_switches(counter);
-
-	atomic64_set(&counter->hw.prev_count, now);
-
-	delta = now - prev;
-
-	atomic64_add(delta, &counter->count);
-}
-
-static void context_switches_perf_counter_read(struct perf_counter *counter)
-{
-	context_switches_perf_counter_update(counter);
-}
-
-static int context_switches_perf_counter_enable(struct perf_counter *counter)
-{
-	if (counter->prev_state <= PERF_COUNTER_STATE_OFF)
-		atomic64_set(&counter->hw.prev_count,
-			     get_context_switches(counter));
-	return 0;
-}
-
-static void context_switches_perf_counter_disable(struct perf_counter *counter)
-{
-	context_switches_perf_counter_update(counter);
-}
-
-static const struct hw_perf_counter_ops perf_ops_context_switches = {
-	.enable		= context_switches_perf_counter_enable,
-	.disable	= context_switches_perf_counter_disable,
-	.read		= context_switches_perf_counter_read,
-};
-
-/*
  * Software counter: cpu migrations
  */
 
@@ -1811,11 +1762,8 @@ sw_perf_counter_init(struct perf_counter
 	case PERF_COUNT_PAGE_FAULTS:
 	case PERF_COUNT_PAGE_FAULTS_MIN:
 	case PERF_COUNT_PAGE_FAULTS_MAJ:
-		hw_ops = &perf_ops_generic;
-		break;
 	case PERF_COUNT_CONTEXT_SWITCHES:
-		if (!counter->hw_event.exclude_kernel)
-			hw_ops = &perf_ops_context_switches;
+		hw_ops = &perf_ops_generic;
 		break;
 	case PERF_COUNT_CPU_MIGRATIONS:
 		if (!counter->hw_event.exclude_kernel)
Index: linux-2.6/kernel/sched.c
===================================================================
--- linux-2.6.orig/kernel/sched.c
+++ linux-2.6/kernel/sched.c
@@ -2911,14 +2911,8 @@ unsigned long nr_active(void)
 
 /*
  * Externally visible per-cpu scheduler statistics:
- * cpu_nr_switches(cpu) - number of context switches on that cpu
  * cpu_nr_migrations(cpu) - number of migrations into that cpu
  */
-u64 cpu_nr_switches(int cpu)
-{
-	return cpu_rq(cpu)->nr_switches;
-}
-
 u64 cpu_nr_migrations(int cpu)
 {
 	return cpu_rq(cpu)->nr_migrations_in;

-- 

