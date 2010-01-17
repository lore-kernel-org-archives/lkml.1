Return-Path: <linux-kernel-owner+w=401wt.eu-S1753579Ab0AQMWg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753579Ab0AQMWg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Jan 2010 07:22:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751985Ab0AQMW0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Jan 2010 07:22:26 -0500
Received: from mail-ew0-f219.google.com ([209.85.219.219]:55488 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752047Ab0AQMWW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Jan 2010 07:22:22 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=pO1qJtpiLD0gske7JaDdrSGgHG9zqJpsh1DERm1TEXGaLrag+jkjRJdpuf9u6b7huk
         OPaQEBM4UO7d8tYAKuxGcmv4YkK9V+8agbwItXawZC9tHh0NZ1uNHBji9Yr2f6DRNmY5
         R4vQpjfG5vonI4P2NO8ki7Xi7DJ1kfF80XoYg=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Peter Zijlstra <peterz@infradead.org>,
       Paul Mackerras <paulus@samba.org>,
       Arnaldo Carvalho de Melo <acme@infradead.org>,
       Ingo Molnar <mingo@elte.hu>
Subject: [PATCH 2/4] perf: Allow pinned and flexible groups to be scheduled separately
Date: Sun, 17 Jan 2010 13:22:13 +0100
Message-Id: <1263730935-9770-3-git-send-regression-fweisbec@gmail.com>
X-Mailer: git-send-email 1.6.2.3
In-Reply-To: <1263730935-9770-1-git-send-regression-fweisbec@gmail.com>
References: <1263730935-9770-1-git-send-regression-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tune the scheduling helpers so that we can choose to schedule either
pinned and/or flexible groups from a context.

And while at it, refactor a bit the naming of these helpers to make
these more consistent and flexible.

There is no (intended) change in scheduling behaviour in this
patch.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Arnaldo Carvalho de Melo <acme@infradead.org>
---
 kernel/perf_event.c |  137 ++++++++++++++++++++++++++++++++++----------------
 1 files changed, 93 insertions(+), 44 deletions(-)

diff --git a/kernel/perf_event.c b/kernel/perf_event.c
index c4e90b8..bfc4ee0 100644
--- a/kernel/perf_event.c
+++ b/kernel/perf_event.c
@@ -1049,8 +1049,15 @@ static int perf_event_refresh(struct perf_event *event, int refresh)
 	return 0;
 }
 
-static void __perf_event_sched_out(struct perf_event_context *ctx,
-				   struct perf_cpu_context *cpuctx)
+enum event_type_t {
+	EVENT_FLEXIBLE = 0x1,
+	EVENT_PINNED = 0x2,
+	EVENT_ALL = EVENT_FLEXIBLE | EVENT_PINNED,
+};
+
+static void ctx_sched_out(struct perf_event_context *ctx,
+			  struct perf_cpu_context *cpuctx,
+			  enum event_type_t event_type)
 {
 	struct perf_event *event;
 
@@ -1061,13 +1068,18 @@ static void __perf_event_sched_out(struct perf_event_context *ctx,
 	update_context_time(ctx);
 
 	perf_disable();
-	if (ctx->nr_active) {
+	if (!ctx->nr_active)
+		goto out_enable;
+
+	if (event_type & EVENT_PINNED)
 		list_for_each_entry(event, &ctx->pinned_groups, group_entry)
 			group_sched_out(event, cpuctx, ctx);
 
+	if (event_type & EVENT_FLEXIBLE)
 		list_for_each_entry(event, &ctx->flexible_groups, group_entry)
 			group_sched_out(event, cpuctx, ctx);
-	}
+
+ out_enable:
 	perf_enable();
  out:
 	raw_spin_unlock(&ctx->lock);
@@ -1229,15 +1241,13 @@ void perf_event_task_sched_out(struct task_struct *task,
 	rcu_read_unlock();
 
 	if (do_switch) {
-		__perf_event_sched_out(ctx, cpuctx);
+		ctx_sched_out(ctx, cpuctx, EVENT_ALL);
 		cpuctx->task_ctx = NULL;
 	}
 }
 
-/*
- * Called with IRQs disabled
- */
-static void __perf_event_task_sched_out(struct perf_event_context *ctx)
+static void task_ctx_sched_out(struct perf_event_context *ctx,
+			       enum event_type_t event_type)
 {
 	struct perf_cpu_context *cpuctx = &__get_cpu_var(perf_cpu_context);
 
@@ -1247,39 +1257,34 @@ static void __perf_event_task_sched_out(struct perf_event_context *ctx)
 	if (WARN_ON_ONCE(ctx != cpuctx->task_ctx))
 		return;
 
-	__perf_event_sched_out(ctx, cpuctx);
+	ctx_sched_out(ctx, cpuctx, event_type);
 	cpuctx->task_ctx = NULL;
 }
 
 /*
  * Called with IRQs disabled
  */
-static void perf_event_cpu_sched_out(struct perf_cpu_context *cpuctx)
+static void __perf_event_task_sched_out(struct perf_event_context *ctx)
 {
-	__perf_event_sched_out(&cpuctx->ctx, cpuctx);
+	task_ctx_sched_out(ctx, EVENT_ALL);
+}
+
+/*
+ * Called with IRQs disabled
+ */
+static void cpu_ctx_sched_out(struct perf_cpu_context *cpuctx,
+			      enum event_type_t event_type)
+{
+	ctx_sched_out(&cpuctx->ctx, cpuctx, event_type);
 }
 
 static void
-__perf_event_sched_in(struct perf_event_context *ctx,
-			struct perf_cpu_context *cpuctx)
+ctx_pinned_sched_in(struct perf_event_context *ctx,
+		    struct perf_cpu_context *cpuctx,
+		    int cpu)
 {
-	int cpu = smp_processor_id();
 	struct perf_event *event;
-	int can_add_hw = 1;
-
-	raw_spin_lock(&ctx->lock);
-	ctx->is_active = 1;
-	if (likely(!ctx->nr_events))
-		goto out;
-
-	ctx->timestamp = perf_clock();
-
-	perf_disable();
 
-	/*
-	 * First go through the list and put on any pinned groups
-	 * in order to give them the best chance of going on.
-	 */
 	list_for_each_entry(event, &ctx->pinned_groups, group_entry) {
 		if (event->state <= PERF_EVENT_STATE_OFF)
 			continue;
@@ -1298,6 +1303,15 @@ __perf_event_sched_in(struct perf_event_context *ctx,
 			event->state = PERF_EVENT_STATE_ERROR;
 		}
 	}
+}
+
+static void
+ctx_flexible_sched_in(struct perf_event_context *ctx,
+		      struct perf_cpu_context *cpuctx,
+		      int cpu)
+{
+	struct perf_event *event;
+	int can_add_hw = 1;
 
 	list_for_each_entry(event, &ctx->flexible_groups, group_entry) {
 		/* Ignore events in OFF or ERROR state */
@@ -1314,11 +1328,53 @@ __perf_event_sched_in(struct perf_event_context *ctx,
 			if (group_sched_in(event, cpuctx, ctx, cpu))
 				can_add_hw = 0;
 	}
+}
+
+static void
+ctx_sched_in(struct perf_event_context *ctx,
+	     struct perf_cpu_context *cpuctx,
+	     enum event_type_t event_type)
+{
+	int cpu = smp_processor_id();
+
+	raw_spin_lock(&ctx->lock);
+	ctx->is_active = 1;
+	if (likely(!ctx->nr_events))
+		goto out;
+
+	ctx->timestamp = perf_clock();
+
+	perf_disable();
+
+	/*
+	 * First go through the list and put on any pinned groups
+	 * in order to give them the best chance of going on.
+	 */
+	if (event_type & EVENT_PINNED)
+		ctx_pinned_sched_in(ctx, cpuctx, cpu);
+
+	/* Then walk through the lower prio flexible groups */
+	if (event_type & EVENT_FLEXIBLE)
+		ctx_flexible_sched_in(ctx, cpuctx, cpu);
+
 	perf_enable();
  out:
 	raw_spin_unlock(&ctx->lock);
 }
 
+static void task_ctx_sched_in(struct task_struct *task,
+			      enum event_type_t event_type)
+{
+	struct perf_cpu_context *cpuctx = &__get_cpu_var(perf_cpu_context);
+	struct perf_event_context *ctx = task->perf_event_ctxp;
+
+	if (likely(!ctx))
+		return;
+	if (cpuctx->task_ctx == ctx)
+		return;
+	ctx_sched_in(ctx, cpuctx, event_type);
+	cpuctx->task_ctx = ctx;
+}
 /*
  * Called from scheduler to add the events of the current task
  * with interrupts disabled.
@@ -1332,22 +1388,15 @@ __perf_event_sched_in(struct perf_event_context *ctx,
  */
 void perf_event_task_sched_in(struct task_struct *task)
 {
-	struct perf_cpu_context *cpuctx = &__get_cpu_var(perf_cpu_context);
-	struct perf_event_context *ctx = task->perf_event_ctxp;
-
-	if (likely(!ctx))
-		return;
-	if (cpuctx->task_ctx == ctx)
-		return;
-	__perf_event_sched_in(ctx, cpuctx);
-	cpuctx->task_ctx = ctx;
+	task_ctx_sched_in(task, EVENT_ALL);
 }
 
-static void perf_event_cpu_sched_in(struct perf_cpu_context *cpuctx)
+static void cpu_ctx_sched_in(struct perf_cpu_context *cpuctx,
+			     enum event_type_t event_type)
 {
 	struct perf_event_context *ctx = &cpuctx->ctx;
 
-	__perf_event_sched_in(ctx, cpuctx);
+	ctx_sched_in(ctx, cpuctx, event_type);
 }
 
 #define MAX_INTERRUPTS (~0ULL)
@@ -1476,17 +1525,17 @@ void perf_event_task_tick(struct task_struct *curr)
 	if (ctx)
 		perf_ctx_adjust_freq(ctx);
 
-	perf_event_cpu_sched_out(cpuctx);
+	cpu_ctx_sched_out(cpuctx, EVENT_ALL);
 	if (ctx)
-		__perf_event_task_sched_out(ctx);
+		task_ctx_sched_out(ctx, EVENT_ALL);
 
 	rotate_ctx(&cpuctx->ctx);
 	if (ctx)
 		rotate_ctx(ctx);
 
-	perf_event_cpu_sched_in(cpuctx);
+	cpu_ctx_sched_in(cpuctx, EVENT_ALL);
 	if (ctx)
-		perf_event_task_sched_in(curr);
+		task_ctx_sched_in(curr, EVENT_ALL);
 }
 
 static int event_enable_on_exec(struct perf_event *event,
-- 
1.6.2.3

