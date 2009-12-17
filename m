Return-Path: <linux-kernel-owner+w=401wt.eu-S1761354AbZLQMbY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761354AbZLQMbY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Dec 2009 07:31:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758481AbZLQMbV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Dec 2009 07:31:21 -0500
Received: from hera.kernel.org ([140.211.167.34]:41391 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756877AbZLQMbT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Dec 2009 07:31:19 -0500
Date: Thu, 17 Dec 2009 12:30:32 GMT
From: tip-bot for Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: linux-kernel@vger.kernel.org, paulus@samba.org, hpa@zytor.com,
       mingo@redhat.com, a.p.zijlstra@chello.nl, acme@ghostprotocols.net,
       tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org,
       linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl,
       acme@ghostprotocols.net, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <20091217121830.215333434@chello.nl>
References: <20091217121830.215333434@chello.nl>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] perf events: Dont report side-band events on each cpu for per-task-per-cpu events
Message-ID: <tip-5d27c23df09b702868d9a3bff86ec6abd22963ac@git.kernel.org>
Git-Commit-ID: 5d27c23df09b702868d9a3bff86ec6abd22963ac
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  5d27c23df09b702868d9a3bff86ec6abd22963ac
Gitweb:     http://git.kernel.org/tip/5d27c23df09b702868d9a3bff86ec6abd22963ac
Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
AuthorDate: Thu, 17 Dec 2009 13:16:32 +0100
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Thu, 17 Dec 2009 13:21:36 +0100

perf events: Dont report side-band events on each cpu for per-task-per-cpu events

Acme noticed that his FORK/MMAP numbers were inflated by about
the same factor as his cpu-count.

This led to the discovery of a few more sites that need to
respect the event->cpu filter.

Reported-by: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>
LKML-Reference: <20091217121830.215333434@chello.nl>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/perf_event.c |   32 ++++++++++++++++++--------------
 1 files changed, 18 insertions(+), 14 deletions(-)

diff --git a/kernel/perf_event.c b/kernel/perf_event.c
index 8ab8698..03cc061 100644
--- a/kernel/perf_event.c
+++ b/kernel/perf_event.c
@@ -1381,6 +1381,9 @@ static void perf_ctx_adjust_freq(struct perf_event_context *ctx)
 		if (event->state != PERF_EVENT_STATE_ACTIVE)
 			continue;
 
+		if (event->cpu != -1 && event->cpu != smp_processor_id())
+			continue;
+
 		hwc = &event->hw;
 
 		interrupts = hwc->interrupts;
@@ -3265,6 +3268,9 @@ static void perf_event_task_output(struct perf_event *event,
 
 static int perf_event_task_match(struct perf_event *event)
 {
+	if (event->cpu != -1 && event->cpu != smp_processor_id())
+		return 0;
+
 	if (event->attr.comm || event->attr.mmap || event->attr.task)
 		return 1;
 
@@ -3290,12 +3296,11 @@ static void perf_event_task_event(struct perf_task_event *task_event)
 	rcu_read_lock();
 	cpuctx = &get_cpu_var(perf_cpu_context);
 	perf_event_task_ctx(&cpuctx->ctx, task_event);
-	put_cpu_var(perf_cpu_context);
-
 	if (!ctx)
 		ctx = rcu_dereference(task_event->task->perf_event_ctxp);
 	if (ctx)
 		perf_event_task_ctx(ctx, task_event);
+	put_cpu_var(perf_cpu_context);
 	rcu_read_unlock();
 }
 
@@ -3372,6 +3377,9 @@ static void perf_event_comm_output(struct perf_event *event,
 
 static int perf_event_comm_match(struct perf_event *event)
 {
+	if (event->cpu != -1 && event->cpu != smp_processor_id())
+		return 0;
+
 	if (event->attr.comm)
 		return 1;
 
@@ -3408,15 +3416,10 @@ static void perf_event_comm_event(struct perf_comm_event *comm_event)
 	rcu_read_lock();
 	cpuctx = &get_cpu_var(perf_cpu_context);
 	perf_event_comm_ctx(&cpuctx->ctx, comm_event);
-	put_cpu_var(perf_cpu_context);
-
-	/*
-	 * doesn't really matter which of the child contexts the
-	 * events ends up in.
-	 */
 	ctx = rcu_dereference(current->perf_event_ctxp);
 	if (ctx)
 		perf_event_comm_ctx(ctx, comm_event);
+	put_cpu_var(perf_cpu_context);
 	rcu_read_unlock();
 }
 
@@ -3491,6 +3494,9 @@ static void perf_event_mmap_output(struct perf_event *event,
 static int perf_event_mmap_match(struct perf_event *event,
 				   struct perf_mmap_event *mmap_event)
 {
+	if (event->cpu != -1 && event->cpu != smp_processor_id())
+		return 0;
+
 	if (event->attr.mmap)
 		return 1;
 
@@ -3564,15 +3570,10 @@ got_name:
 	rcu_read_lock();
 	cpuctx = &get_cpu_var(perf_cpu_context);
 	perf_event_mmap_ctx(&cpuctx->ctx, mmap_event);
-	put_cpu_var(perf_cpu_context);
-
-	/*
-	 * doesn't really matter which of the child contexts the
-	 * events ends up in.
-	 */
 	ctx = rcu_dereference(current->perf_event_ctxp);
 	if (ctx)
 		perf_event_mmap_ctx(ctx, mmap_event);
+	put_cpu_var(perf_cpu_context);
 	rcu_read_unlock();
 
 	kfree(buf);
@@ -3863,6 +3864,9 @@ static int perf_swevent_match(struct perf_event *event,
 				struct perf_sample_data *data,
 				struct pt_regs *regs)
 {
+	if (event->cpu != -1 && event->cpu != smp_processor_id())
+		return 0;
+
 	if (!perf_swevent_is_counting(event))
 		return 0;
 
