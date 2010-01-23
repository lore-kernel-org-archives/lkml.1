Return-Path: <linux-kernel-owner+w=401wt.eu-S1755933Ab0AWAUm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755933Ab0AWAUm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jan 2010 19:20:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932166Ab0AWAUj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Jan 2010 19:20:39 -0500
Received: from kroah.org ([198.145.64.141]:35122 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755562Ab0AWATF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jan 2010 19:19:05 -0500
X-Mailbox-Line: From gregkh@mini.kroah.org Fri Jan 22 16:11:13 2010
Message-Id: <20100123001113.778789298@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Fri, 22 Jan 2010 16:10:12 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@elte.hu>
Subject: [28/29] perf events: Dont report side-band events on each cpu for per-task-per-cpu events
In-Reply-To: <20100123001145.GA7391@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Peter Zijlstra <a.p.zijlstra@chello.nl>

commit 5d27c23df09b702868d9a3bff86ec6abd22963ac upstream.

Acme noticed that his FORK/MMAP numbers were inflated by about
the same factor as his cpu-count.

This led to the discovery of a few more sites that need to
respect the event->cpu filter.

Reported-by: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>
LKML-Reference: <20091217121830.215333434@chello.nl>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 kernel/perf_event.c |   20 ++++++++++++++++++--
 1 file changed, 18 insertions(+), 2 deletions(-)

--- a/kernel/perf_event.c
+++ b/kernel/perf_event.c
@@ -1359,6 +1359,9 @@ static void perf_ctx_adjust_freq(struct 
 		if (event->state != PERF_EVENT_STATE_ACTIVE)
 			continue;
 
+		if (event->cpu != -1 && event->cpu != smp_processor_id())
+			continue;
+
 		hwc = &event->hw;
 
 		interrupts = hwc->interrupts;
@@ -3226,6 +3229,9 @@ static void perf_event_task_output(struc
 
 static int perf_event_task_match(struct perf_event *event)
 {
+	if (event->cpu != -1 && event->cpu != smp_processor_id())
+		return 0;
+
 	if (event->attr.comm || event->attr.mmap || event->attr.task)
 		return 1;
 
@@ -3262,6 +3268,7 @@ static void perf_event_task_event(struct
 		ctx = rcu_dereference(task_event->task->perf_event_ctxp);
 	if (ctx)
 		perf_event_task_ctx(ctx, task_event);
+	put_cpu_var(perf_cpu_context);
 	rcu_read_unlock();
 }
 
@@ -3338,6 +3345,9 @@ static void perf_event_comm_output(struc
 
 static int perf_event_comm_match(struct perf_event *event)
 {
+	if (event->cpu != -1 && event->cpu != smp_processor_id())
+		return 0;
+
 	if (event->attr.comm)
 		return 1;
 
@@ -3378,7 +3388,6 @@ static void perf_event_comm_event(struct
 
 	cpuctx = &get_cpu_var(perf_cpu_context);
 	perf_event_comm_ctx(&cpuctx->ctx, comm_event);
-	put_cpu_var(perf_cpu_context);
 
 	rcu_read_lock();
 	/*
@@ -3388,6 +3397,7 @@ static void perf_event_comm_event(struct
 	ctx = rcu_dereference(current->perf_event_ctxp);
 	if (ctx)
 		perf_event_comm_ctx(ctx, comm_event);
+	put_cpu_var(perf_cpu_context);
 	rcu_read_unlock();
 }
 
@@ -3462,6 +3472,9 @@ static void perf_event_mmap_output(struc
 static int perf_event_mmap_match(struct perf_event *event,
 				   struct perf_mmap_event *mmap_event)
 {
+	if (event->cpu != -1 && event->cpu != smp_processor_id())
+		return 0;
+
 	if (event->attr.mmap)
 		return 1;
 
@@ -3539,7 +3552,6 @@ got_name:
 
 	cpuctx = &get_cpu_var(perf_cpu_context);
 	perf_event_mmap_ctx(&cpuctx->ctx, mmap_event);
-	put_cpu_var(perf_cpu_context);
 
 	rcu_read_lock();
 	/*
@@ -3549,6 +3561,7 @@ got_name:
 	ctx = rcu_dereference(current->perf_event_ctxp);
 	if (ctx)
 		perf_event_mmap_ctx(ctx, mmap_event);
+	put_cpu_var(perf_cpu_context);
 	rcu_read_unlock();
 
 	kfree(buf);
@@ -3811,6 +3824,9 @@ static int perf_swevent_match(struct per
 				enum perf_type_id type,
 				u32 event_id, struct pt_regs *regs)
 {
+	if (event->cpu != -1 && event->cpu != smp_processor_id())
+		return 0;
+
 	if (!perf_swevent_is_counting(event))
 		return 0;
 


