Return-Path: <linux-kernel-owner+w=401wt.eu-S1757016AbZKWKlC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757016AbZKWKlC (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Nov 2009 05:41:02 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756986AbZKWKlA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Nov 2009 05:41:00 -0500
Received: from casper.infradead.org ([85.118.1.10]:53254 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756978AbZKWKk5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Nov 2009 05:40:57 -0500
Message-Id: <20091123103819.842455480@chello.nl>
References: <20091123103722.140831906@chello.nl>
User-Agent: quilt/0.46-1
Date: Mon, 23 Nov 2009 11:37:27 +0100
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Ingo Molnar <mingo@elte.hu>, Paul Mackerras <paulus@samba.org>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [PATCH 5/8] perf: fix __perf_event_exit_task update_event_times locking
Content-Disposition: inline; filename=perf-foo-8.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Move the update_event_times() call in __perf_event_exit_task() into
list_del_event() because that holds the proper lock (ctx->lock) and
seems a more natural place to do the last time update.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 kernel/perf_event.c |   78 ++++++++++++++++++++++++++--------------------------
 1 file changed, 39 insertions(+), 39 deletions(-)

Index: linux-2.6/kernel/perf_event.c
===================================================================
--- linux-2.6.orig/kernel/perf_event.c
+++ linux-2.6/kernel/perf_event.c
@@ -246,6 +246,44 @@ static void perf_unpin_context(struct pe
 	put_ctx(ctx);
 }
 
+static inline u64 perf_clock(void)
+{
+	return cpu_clock(smp_processor_id());
+}
+
+/*
+ * Update the record of the current time in a context.
+ */
+static void update_context_time(struct perf_event_context *ctx)
+{
+	u64 now = perf_clock();
+
+	ctx->time += now - ctx->timestamp;
+	ctx->timestamp = now;
+}
+
+/*
+ * Update the total_time_enabled and total_time_running fields for a event.
+ */
+static void update_event_times(struct perf_event *event)
+{
+	struct perf_event_context *ctx = event->ctx;
+	u64 run_end;
+
+	if (event->state < PERF_EVENT_STATE_INACTIVE ||
+	    event->group_leader->state < PERF_EVENT_STATE_INACTIVE)
+		return;
+
+	event->total_time_enabled = ctx->time - event->tstamp_enabled;
+
+	if (event->state == PERF_EVENT_STATE_INACTIVE)
+		run_end = event->tstamp_stopped;
+	else
+		run_end = ctx->time;
+
+	event->total_time_running = run_end - event->tstamp_running;
+}
+
 /*
  * Add a event from the lists for its context.
  * Must be called with ctx->mutex and ctx->lock held.
@@ -294,6 +332,7 @@ list_del_event(struct perf_event *event,
 	if (event->group_leader != event)
 		event->group_leader->nr_siblings--;
 
+	update_event_times(event);
 	event->state = PERF_EVENT_STATE_OFF;
 
 	/*
@@ -454,44 +493,6 @@ retry:
 	spin_unlock_irq(&ctx->lock);
 }
 
-static inline u64 perf_clock(void)
-{
-	return cpu_clock(smp_processor_id());
-}
-
-/*
- * Update the record of the current time in a context.
- */
-static void update_context_time(struct perf_event_context *ctx)
-{
-	u64 now = perf_clock();
-
-	ctx->time += now - ctx->timestamp;
-	ctx->timestamp = now;
-}
-
-/*
- * Update the total_time_enabled and total_time_running fields for a event.
- */
-static void update_event_times(struct perf_event *event)
-{
-	struct perf_event_context *ctx = event->ctx;
-	u64 run_end;
-
-	if (event->state < PERF_EVENT_STATE_INACTIVE ||
-	    event->group_leader->state < PERF_EVENT_STATE_INACTIVE)
-		return;
-
-	event->total_time_enabled = ctx->time - event->tstamp_enabled;
-
-	if (event->state == PERF_EVENT_STATE_INACTIVE)
-		run_end = event->tstamp_stopped;
-	else
-		run_end = ctx->time;
-
-	event->total_time_running = run_end - event->tstamp_running;
-}
-
 /*
  * Update total_time_enabled and total_time_running for all events in a group.
  */
@@ -4931,7 +4932,6 @@ __perf_event_exit_task(struct perf_event
 {
 	struct perf_event *parent_event;
 
-	update_event_times(child_event);
 	perf_event_remove_from_context(child_event);
 
 	parent_event = child_event->parent;

-- 

