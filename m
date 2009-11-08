Return-Path: <linux-kernel-owner+w=401wt.eu-S1755228AbZKHUNr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755228AbZKHUNr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Nov 2009 15:13:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755193AbZKHUNf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Nov 2009 15:13:35 -0500
Received: from fg-out-1718.google.com ([72.14.220.155]:45522 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755098AbZKHUNX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Nov 2009 15:13:23 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=IK3C5+0tHO3xAYcoQQnjBNNafkvarBxjdgtyO8GpBtHjCUKH/KCRQa8jx/NkNoDzfR
         cRJkUwjs2BY9590tX6WqsqZSHQOvZt+Du5+mT+xi1S2S6/5OaJgL8x/65QIS3F+hgIz3
         Wby7nx9BFOztKzN67qVG06nMZ0r/KZEv/uApA=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Peter Zijlstra <peterz@infradead.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: [RFC PATCH 4/4] perf/core: Schedule every pinned events before the the non-pinned
Date: Sun,  8 Nov 2009 21:13:26 +0100
Message-Id: <1257711206-12243-5-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.6.2.3
In-Reply-To: <1257711206-12243-1-git-send-email-fweisbec@gmail.com>
References: <1257711206-12243-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently, the order to schedule events is as follows:

- cpu context pinned events
- cpu context non-pinned events
- task context pinned events
- task context non-pinned events

What we want instead is to schedule every pinned events first because
those have a higher priority.

This is what does this patch in each task tick. If the approach is
agreed, we may want to expand this to task-only sched in (where the
cpu events are not sched out), fork, exec, etc... So that we guarantee
the pinned priority every time the task is scheduled in.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
---
 kernel/perf_event.c |   49 ++++++++++++++++++++++++++++++++++++++++++++++---
 1 files changed, 46 insertions(+), 3 deletions(-)

diff --git a/kernel/perf_event.c b/kernel/perf_event.c
index 50f2997..f32aec4 100644
--- a/kernel/perf_event.c
+++ b/kernel/perf_event.c
@@ -1327,6 +1327,41 @@ __perf_event_sched_in(struct perf_event_context *ctx,
 	spin_unlock(&ctx->lock);
 }
 
+static void
+__perf_event_sched_in_all(struct perf_event_context *ctx,
+			  struct perf_cpu_context *cpuctx, int cpu)
+{
+	struct perf_event_context *cpu_ctx = &cpuctx->ctx;
+
+	/* May require different classes between cpu and task lock */
+	spin_lock(&cpu_ctx->lock);
+	spin_lock(&ctx->lock);
+	cpu_ctx->is_active = ctx->is_active = 1;
+
+	ctx->timestamp = cpu_ctx->timestamp = perf_clock();
+
+	perf_disable();
+
+	if (cpu_ctx->nr_events)
+		__perf_event_sched_in_pinned(cpu_ctx, cpuctx, cpu);
+
+	if (ctx->nr_events)
+		__perf_event_sched_in_pinned(cpu_ctx, cpuctx, cpu);
+
+	if (cpu_ctx->nr_events)
+		__perf_event_sched_in_volatile(cpu_ctx, cpuctx, cpu);
+
+	if (ctx->nr_events)
+		__perf_event_sched_in_volatile(cpu_ctx, cpuctx, cpu);
+
+	cpuctx->task_ctx = ctx;
+
+	perf_enable();
+
+	spin_unlock(&ctx->lock);
+	spin_lock(&cpu_ctx->lock);
+}
+
 /*
  * Called from scheduler to add the events of the current task
  * with interrupts disabled.
@@ -1477,6 +1512,16 @@ static void rotate_ctx(struct perf_event_context *ctx)
 	spin_unlock(&ctx->lock);
 }
 
+static void
+perf_event_sched_in_all(struct perf_event_context *ctx,
+			struct perf_cpu_context *cpuctx, int cpu)
+{
+	if (!ctx || ctx == cpuctx->task_ctx)
+		perf_event_cpu_sched_in(cpuctx, cpu);
+	else
+		__perf_event_sched_in_all(ctx, cpuctx, cpu);
+}
+
 void perf_event_task_tick(struct task_struct *curr, int cpu)
 {
 	struct perf_cpu_context *cpuctx;
@@ -1500,9 +1545,7 @@ void perf_event_task_tick(struct task_struct *curr, int cpu)
 	if (ctx)
 		rotate_ctx(ctx);
 
-	perf_event_cpu_sched_in(cpuctx, cpu);
-	if (ctx)
-		perf_event_task_sched_in(curr, cpu);
+	perf_event_sched_in_all(ctx, cpuctx, cpu);
 }
 
 static void __perf_event_enable_on_exec(struct perf_event *event,
-- 
1.6.2.3

