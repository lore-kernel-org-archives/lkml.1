Return-Path: <linux-kernel-owner+w=401wt.eu-S1757310AbZKWL5Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757310AbZKWL5Y (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Nov 2009 06:57:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757188AbZKWL5X
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Nov 2009 06:57:23 -0500
Received: from hera.kernel.org ([140.211.167.34]:39351 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757055AbZKWL5W (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Nov 2009 06:57:22 -0500
Date: Mon, 23 Nov 2009 11:54:54 GMT
From: tip-bot for Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: linux-kernel@vger.kernel.org, paulus@samba.org, hpa@zytor.com,
       mingo@redhat.com, fweisbec@gmail.com, a.p.zijlstra@chello.nl,
       tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org,
       linux-kernel@vger.kernel.org, fweisbec@gmail.com,
       a.p.zijlstra@chello.nl, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <20091123103819.842455480@chello.nl>
References: <20091123103819.842455480@chello.nl>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf_events: Fix __perf_event_exit_task() vs. update_event_times() locking
Message-ID: <tip-f67218c3e93abaf0f480bb94b53d234853ffe4de@git.kernel.org>
Git-Commit-ID: f67218c3e93abaf0f480bb94b53d234853ffe4de
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  f67218c3e93abaf0f480bb94b53d234853ffe4de
Gitweb:     http://git.kernel.org/tip/f67218c3e93abaf0f480bb94b53d234853ffe4de
Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
AuthorDate: Mon, 23 Nov 2009 11:37:27 +0100
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Mon, 23 Nov 2009 11:49:57 +0100

perf_events: Fix __perf_event_exit_task() vs. update_event_times() locking

Move the update_event_times() call in __perf_event_exit_task()
into list_del_event() because that holds the proper lock
(ctx->lock) and seems a more natural place to do the last time
update.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
LKML-Reference: <20091123103819.842455480@chello.nl>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/perf_event.c |   78 +++++++++++++++++++++++++-------------------------
 1 files changed, 39 insertions(+), 39 deletions(-)

diff --git a/kernel/perf_event.c b/kernel/perf_event.c
index 8be2574..50f11b5 100644
--- a/kernel/perf_event.c
+++ b/kernel/perf_event.c
@@ -246,6 +246,44 @@ static void perf_unpin_context(struct perf_event_context *ctx)
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
@@ -294,6 +332,7 @@ list_del_event(struct perf_event *event, struct perf_event_context *ctx)
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
@@ -4931,7 +4932,6 @@ __perf_event_exit_task(struct perf_event *child_event,
 {
 	struct perf_event *parent_event;
 
-	update_event_times(child_event);
 	perf_event_remove_from_context(child_event);
 
 	parent_event = child_event->parent;
