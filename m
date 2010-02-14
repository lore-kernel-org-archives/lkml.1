Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758272Ab0BNKMS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Feb 2010 05:12:18 -0500
Received: from casper.infradead.org ([85.118.1.10]:60653 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753958Ab0BNKMQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Feb 2010 05:12:16 -0500
Subject: [PATCH] perf_events: Fix FORK events
From: Peter Zijlstra <peterz@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Anton Blanchard <anton@samba.org>,
       Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 14 Feb 2010 11:12:04 +0100
Message-ID: <1266142324.5273.411.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo, could you stick this in perf/urgent, this needs to make .33

---
Commit 22e19085 ("Honour event state for aux stream data") introduced a
bug where we would drop FORK events.

The thing is that we deliver FORK events to the child process' event,
which at that time will be PERF_EVENT_STATE_INACTIVE because the child
won't be scheduled in (we're in the middle of fork).

Solve this twice, change the event state filter to exclude only disabled
(STATE_OFF) or worse, and deliver FORK events to the current (parent).

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 kernel/perf_event.c |   11 +++++------
 1 files changed, 5 insertions(+), 6 deletions(-)

diff --git a/kernel/perf_event.c b/kernel/perf_event.c
index d27746b..57d6297 100644
--- a/kernel/perf_event.c
+++ b/kernel/perf_event.c
@@ -3259,8 +3259,6 @@ static void perf_event_task_output(struct perf_event *event,
 	task_event->event_id.tid = perf_event_tid(event, task);
 	task_event->event_id.ptid = perf_event_tid(event, current);
 
-	task_event->event_id.time = perf_clock();
-
 	perf_output_put(&handle, task_event->event_id);
 
 	perf_output_end(&handle);
@@ -3268,7 +3266,7 @@ static void perf_event_task_output(struct perf_event *event,
 
 static int perf_event_task_match(struct perf_event *event)
 {
-	if (event->state != PERF_EVENT_STATE_ACTIVE)
+	if (event->state < PERF_EVENT_STATE_INACTIVE)
 		return 0;
 
 	if (event->cpu != -1 && event->cpu != smp_processor_id())
@@ -3300,7 +3298,7 @@ static void perf_event_task_event(struct perf_task_event *task_event)
 	cpuctx = &get_cpu_var(perf_cpu_context);
 	perf_event_task_ctx(&cpuctx->ctx, task_event);
 	if (!ctx)
-		ctx = rcu_dereference(task_event->task->perf_event_ctxp);
+		ctx = rcu_dereference(current->perf_event_ctxp);
 	if (ctx)
 		perf_event_task_ctx(ctx, task_event);
 	put_cpu_var(perf_cpu_context);
@@ -3331,6 +3329,7 @@ static void perf_event_task(struct task_struct *task,
 			/* .ppid */
 			/* .tid  */
 			/* .ptid */
+			.time = perf_clock(),
 		},
 	};
 
@@ -3380,7 +3379,7 @@ static void perf_event_comm_output(struct perf_event *event,
 
 static int perf_event_comm_match(struct perf_event *event)
 {
-	if (event->state != PERF_EVENT_STATE_ACTIVE)
+	if (event->state < PERF_EVENT_STATE_INACTIVE)
 		return 0;
 
 	if (event->cpu != -1 && event->cpu != smp_processor_id())
@@ -3500,7 +3499,7 @@ static void perf_event_mmap_output(struct perf_event *event,
 static int perf_event_mmap_match(struct perf_event *event,
 				   struct perf_mmap_event *mmap_event)
 {
-	if (event->state != PERF_EVENT_STATE_ACTIVE)
+	if (event->state < PERF_EVENT_STATE_INACTIVE)
 		return 0;
 
 	if (event->cpu != -1 && event->cpu != smp_processor_id())



