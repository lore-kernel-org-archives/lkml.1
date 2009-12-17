Return-Path: <linux-kernel-owner+w=401wt.eu-S934567AbZLQMUx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934567AbZLQMUx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Dec 2009 07:20:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764647AbZLQMTM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Dec 2009 07:19:12 -0500
Received: from casper.infradead.org ([85.118.1.10]:47321 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764643AbZLQMTJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Dec 2009 07:19:09 -0500
Message-Id: <20091217121830.215333434@chello.nl>
References: <20091217121626.682772324@chello.nl>
User-Agent: quilt/0.46-1
Date: Thu, 17 Dec 2009 13:16:32 +0100
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>, LKML <linux-kernel@vger.kernel.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Paul Mackerras <paulus@samba.org>
Subject: [PATCH 6/6] perf: Dont report side-band events on each cpu for per-task-per-cpu events
Content-Disposition: inline; filename=perf4.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Acme noticed that his FORK/MMAP numbers were inflated by about the
same factor as his cpu-count.

This led to the discovery of a few more sites that need to respect the
event->cpu filter.

Reported-by: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>
---
 kernel/perf_event.c |   32 ++++++++++++++++++--------------
 1 file changed, 18 insertions(+), 14 deletions(-)

Index: linux-2.6/kernel/perf_event.c
===================================================================
--- linux-2.6.orig/kernel/perf_event.c
+++ linux-2.6/kernel/perf_event.c
@@ -1381,6 +1381,9 @@ static void perf_ctx_adjust_freq(struct 
 		if (event->state != PERF_EVENT_STATE_ACTIVE)
 			continue;
 
+		if (event->cpu != -1 && event->cpu != smp_processor_id())
+			continue;
+
 		hwc = &event->hw;
 
 		interrupts = hwc->interrupts;
@@ -3265,6 +3268,9 @@ static void perf_event_task_output(struc
 
 static int perf_event_task_match(struct perf_event *event)
 {
+	if (event->cpu != -1 && event->cpu != smp_processor_id())
+		return 0;
+
 	if (event->attr.comm || event->attr.mmap || event->attr.task)
 		return 1;
 
@@ -3290,12 +3296,11 @@ static void perf_event_task_event(struct
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
 
@@ -3372,6 +3377,9 @@ static void perf_event_comm_output(struc
 
 static int perf_event_comm_match(struct perf_event *event)
 {
+	if (event->cpu != -1 && event->cpu != smp_processor_id())
+		return 0;
+
 	if (event->attr.comm)
 		return 1;
 
@@ -3408,15 +3416,10 @@ static void perf_event_comm_event(struct
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
 
@@ -3491,6 +3494,9 @@ static void perf_event_mmap_output(struc
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
@@ -3863,6 +3864,9 @@ static int perf_swevent_match(struct per
 				struct perf_sample_data *data,
 				struct pt_regs *regs)
 {
+	if (event->cpu != -1 && event->cpu != smp_processor_id())
+		return 0;
+
 	if (!perf_swevent_is_counting(event))
 		return 0;
 

-- 

