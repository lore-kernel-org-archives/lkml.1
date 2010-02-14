Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752341Ab0BNRQe (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Feb 2010 12:16:34 -0500
Received: from hera.kernel.org ([140.211.167.34]:33376 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752200Ab0BNRQc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Feb 2010 12:16:32 -0500
Date: Sun, 14 Feb 2010 17:15:42 GMT
From: tip-bot for Peter Zijlstra <peterz@infradead.org>
Cc: linux-kernel@vger.kernel.org, anton@samba.org, hpa@zytor.com,
       mingo@redhat.com, a.p.zijlstra@chello.nl, acme@ghostprotocols.net,
       peterz@infradead.org, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, anton@samba.org,
       linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl,
       peterz@infradead.org, acme@ghostprotocols.net, tglx@linutronix.de,
       mingo@elte.hu
In-Reply-To: <1266142324.5273.411.camel@laptop>
References: <1266142324.5273.411.camel@laptop>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] perf_events: Fix FORK events
Message-ID: <tip-6f93d0a7c83772997b81c30d6f519a9a5dbab6a9@git.kernel.org>
Git-Commit-ID: 6f93d0a7c83772997b81c30d6f519a9a5dbab6a9
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Sun, 14 Feb 2010 17:15:46 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  6f93d0a7c83772997b81c30d6f519a9a5dbab6a9
Gitweb:     http://git.kernel.org/tip/6f93d0a7c83772997b81c30d6f519a9a5dbab6a9
Author:     Peter Zijlstra <peterz@infradead.org>
AuthorDate: Sun, 14 Feb 2010 11:12:04 +0100
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Sun, 14 Feb 2010 18:10:39 +0100

perf_events: Fix FORK events

Commit 22e19085 ("Honour event state for aux stream data")
introduced a bug where we would drop FORK events.

The thing is that we deliver FORK events to the child process'
event, which at that time will be PERF_EVENT_STATE_INACTIVE
because the child won't be scheduled in (we're in the middle of
fork).

Solve this twice, change the event state filter to exclude only
disabled (STATE_OFF) or worse, and deliver FORK events to the
current (parent).

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Anton Blanchard <anton@samba.org>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
LKML-Reference: <1266142324.5273.411.camel@laptop>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/perf_event.c |   11 +++++------
 1 files changed, 5 insertions(+), 6 deletions(-)

diff --git a/kernel/perf_event.c b/kernel/perf_event.c
index 2b19297..2ae7409 100644
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
