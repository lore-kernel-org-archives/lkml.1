Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756116Ab0CJNOG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Mar 2010 08:14:06 -0500
Received: from hera.kernel.org ([140.211.167.34]:43067 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755476Ab0CJNOA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Mar 2010 08:14:00 -0500
Date: Wed, 10 Mar 2010 13:13:29 GMT
From: tip-bot for Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       acme@infradead.org, a.p.zijlstra@chello.nl, tglx@linutronix.de,
       mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       a.p.zijlstra@chello.nl, acme@infradead.org, tglx@linutronix.de,
       mingo@elte.hu
In-Reply-To: <new-submission>
References: <new-submission>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] perf: Provide better condition for event rotation
Message-ID: <tip-d4944a06666054707d23e11888e480af239e5abf@git.kernel.org>
Git-Commit-ID: d4944a06666054707d23e11888e480af239e5abf
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 10 Mar 2010 13:13:29 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  d4944a06666054707d23e11888e480af239e5abf
Gitweb:     http://git.kernel.org/tip/d4944a06666054707d23e11888e480af239e5abf
Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
AuthorDate: Mon, 8 Mar 2010 13:51:20 +0100
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 10 Mar 2010 13:22:36 +0100

perf: Provide better condition for event rotation

Try to avoid useless rotation and PMU disables.

[ Could be improved by keeping a nr_runnable count to better account
  for the < PERF_STAT_INACTIVE counters ]

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Arnaldo Carvalho de Melo <acme@infradead.org>
Cc: paulus@samba.org
Cc: eranian@google.com
Cc: robert.richter@amd.com
Cc: fweisbec@gmail.com
LKML-Reference: <new-submission>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/perf_event.c |   21 +++++++++++++++------
 1 files changed, 15 insertions(+), 6 deletions(-)

diff --git a/kernel/perf_event.c b/kernel/perf_event.c
index d810846..52c69a3 100644
--- a/kernel/perf_event.c
+++ b/kernel/perf_event.c
@@ -1524,12 +1524,15 @@ static void perf_ctx_adjust_freq(struct perf_event_context *ctx)
 		 */
 		if (interrupts == MAX_INTERRUPTS) {
 			perf_log_throttle(event, 1);
+			perf_disable();
 			event->pmu->unthrottle(event);
+			perf_enable();
 		}
 
 		if (!event->attr.freq || !event->attr.sample_freq)
 			continue;
 
+		perf_disable();
 		event->pmu->read(event);
 		now = atomic64_read(&event->count);
 		delta = now - hwc->freq_count_stamp;
@@ -1537,6 +1540,7 @@ static void perf_ctx_adjust_freq(struct perf_event_context *ctx)
 
 		if (delta > 0)
 			perf_adjust_period(event, TICK_NSEC, delta);
+		perf_enable();
 	}
 	raw_spin_unlock(&ctx->lock);
 }
@@ -1546,9 +1550,6 @@ static void perf_ctx_adjust_freq(struct perf_event_context *ctx)
  */
 static void rotate_ctx(struct perf_event_context *ctx)
 {
-	if (!ctx->nr_events)
-		return;
-
 	raw_spin_lock(&ctx->lock);
 
 	/* Rotate the first entry last of non-pinned groups */
@@ -1561,19 +1562,28 @@ void perf_event_task_tick(struct task_struct *curr)
 {
 	struct perf_cpu_context *cpuctx;
 	struct perf_event_context *ctx;
+	int rotate = 0;
 
 	if (!atomic_read(&nr_events))
 		return;
 
 	cpuctx = &__get_cpu_var(perf_cpu_context);
-	ctx = curr->perf_event_ctxp;
+	if (cpuctx->ctx.nr_events &&
+	    cpuctx->ctx.nr_events != cpuctx->ctx.nr_active)
+		rotate = 1;
 
-	perf_disable();
+	ctx = curr->perf_event_ctxp;
+	if (ctx && ctx->nr_events && ctx->nr_events != ctx->nr_active)
+		rotate = 1;
 
 	perf_ctx_adjust_freq(&cpuctx->ctx);
 	if (ctx)
 		perf_ctx_adjust_freq(ctx);
 
+	if (!rotate)
+		return;
+
+	perf_disable();
 	cpu_ctx_sched_out(cpuctx, EVENT_FLEXIBLE);
 	if (ctx)
 		task_ctx_sched_out(ctx, EVENT_FLEXIBLE);
@@ -1585,7 +1595,6 @@ void perf_event_task_tick(struct task_struct *curr)
 	cpu_ctx_sched_in(cpuctx, EVENT_FLEXIBLE);
 	if (ctx)
 		task_ctx_sched_in(curr, EVENT_FLEXIBLE);
-
 	perf_enable();
 }
 
