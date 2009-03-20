Return-Path: <linux-kernel-owner+w=401wt.eu-S1761994AbZCTK0r@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761994AbZCTK0r (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Mar 2009 06:26:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761588AbZCTKZi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Mar 2009 06:25:38 -0400
Received: from hera.kernel.org ([140.211.167.34]:35182 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760925AbZCTKZg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Mar 2009 06:25:36 -0400
Date: Fri, 20 Mar 2009 10:24:59 GMT
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, paulus@samba.org, hpa@zytor.com,
       mingo@redhat.com, rostedt@goodmis.org, a.p.zijlstra@chello.nl,
       tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org,
       linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl,
       rostedt@goodmis.org, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <20090319194233.283522645@chello.nl>
References: <20090319194233.283522645@chello.nl>
Subject: [tip:perfcounters/core] perf_counter: generic context switch event
Message-ID: <tip-56675f6a68ace46db70af12bdd39b6103cc54929@git.kernel.org>
Git-Commit-ID: 56675f6a68ace46db70af12bdd39b6103cc54929
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Fri, 20 Mar 2009 10:25:01 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  56675f6a68ace46db70af12bdd39b6103cc54929
Gitweb:     http://git.kernel.org/tip/56675f6a68ace46db70af12bdd39b6103cc54929
Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
AuthorDate: Thu, 19 Mar 2009 20:26:12 +0100
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Fri, 20 Mar 2009 11:15:11 +0100

perf_counter: generic context switch event

Impact: cleanup

Use the generic software events for context switches.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Steven Rostedt <rostedt@goodmis.org>
LKML-Reference: <20090319194233.283522645@chello.nl>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 include/linux/sched.h |    1 -
 kernel/perf_counter.c |   60 +++---------------------------------------------
 kernel/sched.c        |    6 -----
 3 files changed, 4 insertions(+), 63 deletions(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index 3e9bb18..1410859 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -137,7 +137,6 @@ extern unsigned long nr_running(void);
 extern unsigned long nr_uninterruptible(void);
 extern unsigned long nr_active(void);
 extern unsigned long nr_iowait(void);
-extern u64 cpu_nr_switches(int cpu);
 extern u64 cpu_nr_migrations(int cpu);
 
 extern unsigned long get_parent_ip(unsigned long addr);
diff --git a/kernel/perf_counter.c b/kernel/perf_counter.c
index 4c4e9eb..99d5930 100644
--- a/kernel/perf_counter.c
+++ b/kernel/perf_counter.c
@@ -710,10 +710,13 @@ void perf_counter_task_sched_out(struct task_struct *task, int cpu)
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
@@ -1668,58 +1671,6 @@ static const struct hw_perf_counter_ops perf_ops_task_clock = {
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
 
@@ -1808,11 +1759,8 @@ sw_perf_counter_init(struct perf_counter *counter)
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
diff --git a/kernel/sched.c b/kernel/sched.c
index cbfa5ab..7a4667d 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
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
