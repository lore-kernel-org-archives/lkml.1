Return-Path: <linux-kernel-owner+w=401wt.eu-S1751662AbZL1KIz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751662AbZL1KIz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Dec 2009 05:08:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751354AbZL1KIx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Dec 2009 05:08:53 -0500
Received: from hera.kernel.org ([140.211.167.34]:36308 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751575AbZL1KIw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Dec 2009 05:08:52 -0500
Date: Mon, 28 Dec 2009 10:07:17 GMT
From: tip-bot for Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: linux-kernel@vger.kernel.org, acme@redhat.com, paulus@samba.org,
       hpa@zytor.com, mingo@redhat.com, a.p.zijlstra@chello.nl, efault@gmx.de,
       fweisbec@gmail.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org, acme@redhat.com,
       linux-kernel@vger.kernel.org, fweisbec@gmail.com,
       a.p.zijlstra@chello.nl, efault@gmx.de, tglx@linutronix.de,
       mingo@elte.hu
In-Reply-To: <new-submission>
References: <new-submission>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf events: Remove arg from perf sched hooks
Message-ID: <tip-49f474331e563a6ecf3b1e87ec27ec5482b3e4f1@git.kernel.org>
Git-Commit-ID: 49f474331e563a6ecf3b1e87ec27ec5482b3e4f1
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  49f474331e563a6ecf3b1e87ec27ec5482b3e4f1
Gitweb:     http://git.kernel.org/tip/49f474331e563a6ecf3b1e87ec27ec5482b3e4f1
Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
AuthorDate: Sun, 27 Dec 2009 11:51:52 +0100
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Mon, 28 Dec 2009 09:21:33 +0100

perf events: Remove arg from perf sched hooks

Since we only ever schedule the local cpu, there is no need to pass the
cpu number to the perf sched hooks.

This micro-optimizes things a bit.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
LKML-Reference: <new-submission>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 include/linux/perf_event.h |   12 ++++++------
 kernel/perf_event.c        |   27 ++++++++++++++-------------
 kernel/sched.c             |    6 +++---
 3 files changed, 23 insertions(+), 22 deletions(-)

diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
index c66b34f..a494e75 100644
--- a/include/linux/perf_event.h
+++ b/include/linux/perf_event.h
@@ -746,10 +746,10 @@ extern int perf_max_events;
 
 extern const struct pmu *hw_perf_event_init(struct perf_event *event);
 
-extern void perf_event_task_sched_in(struct task_struct *task, int cpu);
+extern void perf_event_task_sched_in(struct task_struct *task);
 extern void perf_event_task_sched_out(struct task_struct *task,
-					struct task_struct *next, int cpu);
-extern void perf_event_task_tick(struct task_struct *task, int cpu);
+					struct task_struct *next);
+extern void perf_event_task_tick(struct task_struct *task);
 extern int perf_event_init_task(struct task_struct *child);
 extern void perf_event_exit_task(struct task_struct *child);
 extern void perf_event_free_task(struct task_struct *task);
@@ -870,12 +870,12 @@ extern void perf_event_enable(struct perf_event *event);
 extern void perf_event_disable(struct perf_event *event);
 #else
 static inline void
-perf_event_task_sched_in(struct task_struct *task, int cpu)		{ }
+perf_event_task_sched_in(struct task_struct *task)			{ }
 static inline void
 perf_event_task_sched_out(struct task_struct *task,
-			    struct task_struct *next, int cpu)		{ }
+			    struct task_struct *next)			{ }
 static inline void
-perf_event_task_tick(struct task_struct *task, int cpu)			{ }
+perf_event_task_tick(struct task_struct *task)				{ }
 static inline int perf_event_init_task(struct task_struct *child)	{ return 0; }
 static inline void perf_event_exit_task(struct task_struct *child)	{ }
 static inline void perf_event_free_task(struct task_struct *task)	{ }
diff --git a/kernel/perf_event.c b/kernel/perf_event.c
index 03cc061..099bd66 100644
--- a/kernel/perf_event.c
+++ b/kernel/perf_event.c
@@ -1170,9 +1170,9 @@ static void perf_event_sync_stat(struct perf_event_context *ctx,
  * not restart the event.
  */
 void perf_event_task_sched_out(struct task_struct *task,
-				 struct task_struct *next, int cpu)
+				 struct task_struct *next)
 {
-	struct perf_cpu_context *cpuctx = &per_cpu(perf_cpu_context, cpu);
+	struct perf_cpu_context *cpuctx = &__get_cpu_var(perf_cpu_context);
 	struct perf_event_context *ctx = task->perf_event_ctxp;
 	struct perf_event_context *next_ctx;
 	struct perf_event_context *parent;
@@ -1252,8 +1252,9 @@ static void perf_event_cpu_sched_out(struct perf_cpu_context *cpuctx)
 
 static void
 __perf_event_sched_in(struct perf_event_context *ctx,
-			struct perf_cpu_context *cpuctx, int cpu)
+			struct perf_cpu_context *cpuctx)
 {
+	int cpu = smp_processor_id();
 	struct perf_event *event;
 	int can_add_hw = 1;
 
@@ -1326,24 +1327,24 @@ __perf_event_sched_in(struct perf_event_context *ctx,
  * accessing the event control register. If a NMI hits, then it will
  * keep the event running.
  */
-void perf_event_task_sched_in(struct task_struct *task, int cpu)
+void perf_event_task_sched_in(struct task_struct *task)
 {
-	struct perf_cpu_context *cpuctx = &per_cpu(perf_cpu_context, cpu);
+	struct perf_cpu_context *cpuctx = &__get_cpu_var(perf_cpu_context);
 	struct perf_event_context *ctx = task->perf_event_ctxp;
 
 	if (likely(!ctx))
 		return;
 	if (cpuctx->task_ctx == ctx)
 		return;
-	__perf_event_sched_in(ctx, cpuctx, cpu);
+	__perf_event_sched_in(ctx, cpuctx);
 	cpuctx->task_ctx = ctx;
 }
 
-static void perf_event_cpu_sched_in(struct perf_cpu_context *cpuctx, int cpu)
+static void perf_event_cpu_sched_in(struct perf_cpu_context *cpuctx)
 {
 	struct perf_event_context *ctx = &cpuctx->ctx;
 
-	__perf_event_sched_in(ctx, cpuctx, cpu);
+	__perf_event_sched_in(ctx, cpuctx);
 }
 
 #define MAX_INTERRUPTS (~0ULL)
@@ -1461,7 +1462,7 @@ static void rotate_ctx(struct perf_event_context *ctx)
 	raw_spin_unlock(&ctx->lock);
 }
 
-void perf_event_task_tick(struct task_struct *curr, int cpu)
+void perf_event_task_tick(struct task_struct *curr)
 {
 	struct perf_cpu_context *cpuctx;
 	struct perf_event_context *ctx;
@@ -1469,7 +1470,7 @@ void perf_event_task_tick(struct task_struct *curr, int cpu)
 	if (!atomic_read(&nr_events))
 		return;
 
-	cpuctx = &per_cpu(perf_cpu_context, cpu);
+	cpuctx = &__get_cpu_var(perf_cpu_context);
 	ctx = curr->perf_event_ctxp;
 
 	perf_ctx_adjust_freq(&cpuctx->ctx);
@@ -1484,9 +1485,9 @@ void perf_event_task_tick(struct task_struct *curr, int cpu)
 	if (ctx)
 		rotate_ctx(ctx);
 
-	perf_event_cpu_sched_in(cpuctx, cpu);
+	perf_event_cpu_sched_in(cpuctx);
 	if (ctx)
-		perf_event_task_sched_in(curr, cpu);
+		perf_event_task_sched_in(curr);
 }
 
 /*
@@ -1527,7 +1528,7 @@ static void perf_event_enable_on_exec(struct task_struct *task)
 
 	raw_spin_unlock(&ctx->lock);
 
-	perf_event_task_sched_in(task, smp_processor_id());
+	perf_event_task_sched_in(task);
  out:
 	local_irq_restore(flags);
 }
diff --git a/kernel/sched.c b/kernel/sched.c
index 18cceee..d6527ac 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -2752,7 +2752,7 @@ static void finish_task_switch(struct rq *rq, struct task_struct *prev)
 	 */
 	prev_state = prev->state;
 	finish_arch_switch(prev);
-	perf_event_task_sched_in(current, cpu_of(rq));
+	perf_event_task_sched_in(current);
 	finish_lock_switch(rq, prev);
 
 	fire_sched_in_preempt_notifiers(current);
@@ -5266,7 +5266,7 @@ void scheduler_tick(void)
 	curr->sched_class->task_tick(rq, curr, 0);
 	raw_spin_unlock(&rq->lock);
 
-	perf_event_task_tick(curr, cpu);
+	perf_event_task_tick(curr);
 
 #ifdef CONFIG_SMP
 	rq->idle_at_tick = idle_cpu(cpu);
@@ -5480,7 +5480,7 @@ need_resched_nonpreemptible:
 
 	if (likely(prev != next)) {
 		sched_info_switch(prev, next);
-		perf_event_task_sched_out(prev, next, cpu);
+		perf_event_task_sched_out(prev, next);
 
 		rq->nr_switches++;
 		rq->curr = next;
