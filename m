Return-Path: <linux-kernel-owner+w=401wt.eu-S1753675Ab0AQMWj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753675Ab0AQMWj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Jan 2010 07:22:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753325Ab0AQMW2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Jan 2010 07:22:28 -0500
Received: from mail-ew0-f219.google.com ([209.85.219.219]:42781 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752243Ab0AQMWY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Jan 2010 07:22:24 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=lWWHfKRLpFWySlhjg3XqmFPdgU7DrIT30FLcjDIAM+Wa12EYw0Nw84wvv3WlY/jKfF
         Wt/qH2z9/Ev7ptrVIlbU3dpEd0m7ANFA5IzvEZj66uZfXlLSJjxBvOiw0gB7E2FL761i
         XEyZW8FACPycr/Ew555qEz6IpbpAfsaPMXXds=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Peter Zijlstra <peterz@infradead.org>,
       Paul Mackerras <paulus@samba.org>,
       Arnaldo Carvalho de Melo <acme@infradead.org>,
       Ingo Molnar <mingo@elte.hu>
Subject: [PATCH 4/4] perf: Better order flexible and pinned scheduling
Date: Sun, 17 Jan 2010 13:22:15 +0100
Message-Id: <1263730935-9770-5-git-send-regression-fweisbec@gmail.com>
X-Mailer: git-send-email 1.6.2.3
In-Reply-To: <1263730935-9770-1-git-send-regression-fweisbec@gmail.com>
References: <1263730935-9770-1-git-send-regression-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When a task gets scheduled in. We don't touch the cpu bound events
so the priority order becomes:

	cpu pinned, cpu flexible, task pinned, task flexible.

So schedule out cpu flexibles when a new task context gets in
and correctly order the groups to schedule in:

	task pinned, cpu flexible, task flexible.

Cpu pinned groups don't need to be touched at this time.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Arnaldo Carvalho de Melo <acme@infradead.org>
---
 kernel/perf_event.c |   34 +++++++++++++++++++++++++++-------
 1 files changed, 27 insertions(+), 7 deletions(-)

diff --git a/kernel/perf_event.c b/kernel/perf_event.c
index a90ae69..edc46b9 100644
--- a/kernel/perf_event.c
+++ b/kernel/perf_event.c
@@ -1362,6 +1362,14 @@ ctx_sched_in(struct perf_event_context *ctx,
 	raw_spin_unlock(&ctx->lock);
 }
 
+static void cpu_ctx_sched_in(struct perf_cpu_context *cpuctx,
+			     enum event_type_t event_type)
+{
+	struct perf_event_context *ctx = &cpuctx->ctx;
+
+	ctx_sched_in(ctx, cpuctx, event_type);
+}
+
 static void task_ctx_sched_in(struct task_struct *task,
 			      enum event_type_t event_type)
 {
@@ -1388,15 +1396,27 @@ static void task_ctx_sched_in(struct task_struct *task,
  */
 void perf_event_task_sched_in(struct task_struct *task)
 {
-	task_ctx_sched_in(task, EVENT_ALL);
-}
+	struct perf_cpu_context *cpuctx = &__get_cpu_var(perf_cpu_context);
+	struct perf_event_context *ctx = task->perf_event_ctxp;
 
-static void cpu_ctx_sched_in(struct perf_cpu_context *cpuctx,
-			     enum event_type_t event_type)
-{
-	struct perf_event_context *ctx = &cpuctx->ctx;
+	if (likely(!ctx))
+		return;
 
-	ctx_sched_in(ctx, cpuctx, event_type);
+	if (cpuctx->task_ctx == ctx)
+		return;
+
+	/*
+	 * We want to keep the following priority order:
+	 * cpu pinned (that don't need to move), task pinned,
+	 * cpu flexible, task flexible.
+	 */
+	cpu_ctx_sched_out(cpuctx, EVENT_FLEXIBLE);
+
+	ctx_sched_in(ctx, cpuctx, EVENT_PINNED);
+	cpu_ctx_sched_in(cpuctx, EVENT_FLEXIBLE);
+	ctx_sched_in(ctx, cpuctx, EVENT_FLEXIBLE);
+
+	cpuctx->task_ctx = ctx;
 }
 
 #define MAX_INTERRUPTS (~0ULL)
-- 
1.6.2.3

