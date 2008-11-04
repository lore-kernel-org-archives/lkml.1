Return-Path: <linux-kernel-owner+w=401wt.eu-S1755151AbYKDEXQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755151AbYKDEXQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2008 23:23:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753380AbYKDEWK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Nov 2008 23:22:10 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:33061 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752924AbYKDEWG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2008 23:22:06 -0500
Message-Id: <20081104042203.362452209@goodmis.org>
References: <20081104041554.605521183@goodmis.org>
User-Agent: quilt/0.46-1
Date: Mon, 03 Nov 2008 23:15:56 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Steven Rostedt <srostedt@redhat.com>
Subject: [PATCH 2/3] ftrace: insert in the ftrace_preempt_disable functions
Content-Disposition: inline; filename=ftrace-preempt-disable-implement.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch replaces the schedule safe preempt disable code with the
ftrace_preempt_disable and ftrace_preempt_enable safe functions.

Signed-off-by: Steven Rostedt <srostedt@redhat.com>
---
 kernel/trace/ring_buffer.c        |   27 +++++++++------------------
 kernel/trace/trace.c              |    8 ++------
 kernel/trace/trace_sched_wakeup.c |   13 ++-----------
 kernel/trace/trace_stack.c        |    8 ++------
 4 files changed, 15 insertions(+), 41 deletions(-)

Index: linux-tip.git/kernel/trace/ring_buffer.c
===================================================================
--- linux-tip.git.orig/kernel/trace/ring_buffer.c	2008-11-03 18:49:30.000000000 -0500
+++ linux-tip.git/kernel/trace/ring_buffer.c	2008-11-03 19:05:24.000000000 -0500
@@ -16,6 +16,8 @@
 #include <linux/list.h>
 #include <linux/fs.h>
 
+#include "trace.h"
+
 /* Up this if you want to test the TIME_EXTENTS and normalization */
 #define DEBUG_SHIFT 0
 
@@ -1122,8 +1124,7 @@ ring_buffer_lock_reserve(struct ring_buf
 		return NULL;
 
 	/* If we are tracing schedule, we don't want to recurse */
-	resched = need_resched();
-	preempt_disable_notrace();
+	resched = ftrace_preempt_disable();
 
 	cpu = raw_smp_processor_id();
 
@@ -1154,10 +1155,7 @@ ring_buffer_lock_reserve(struct ring_buf
 	return event;
 
  out:
-	if (resched)
-		preempt_enable_notrace();
-	else
-		preempt_enable_notrace();
+	ftrace_preempt_enable(resched);
 	return NULL;
 }
 
@@ -1199,12 +1197,9 @@ int ring_buffer_unlock_commit(struct rin
 	/*
 	 * Only the last preempt count needs to restore preemption.
 	 */
-	if (preempt_count() == 1) {
-		if (per_cpu(rb_need_resched, cpu))
-			preempt_enable_no_resched_notrace();
-		else
-			preempt_enable_notrace();
-	} else
+	if (preempt_count() == 1)
+		ftrace_preempt_enable(per_cpu(rb_need_resched, cpu));
+	else
 		preempt_enable_no_resched_notrace();
 
 	return 0;
@@ -1237,8 +1232,7 @@ int ring_buffer_write(struct ring_buffer
 	if (atomic_read(&buffer->record_disabled))
 		return -EBUSY;
 
-	resched = need_resched();
-	preempt_disable_notrace();
+	resched = ftrace_preempt_disable();
 
 	cpu = raw_smp_processor_id();
 
@@ -1264,10 +1258,7 @@ int ring_buffer_write(struct ring_buffer
 
 	ret = 0;
  out:
-	if (resched)
-		preempt_enable_no_resched_notrace();
-	else
-		preempt_enable_notrace();
+	ftrace_preempt_enable(resched);
 
 	return ret;
 }
Index: linux-tip.git/kernel/trace/trace.c
===================================================================
--- linux-tip.git.orig/kernel/trace/trace.c	2008-11-03 18:49:37.000000000 -0500
+++ linux-tip.git/kernel/trace/trace.c	2008-11-03 19:05:24.000000000 -0500
@@ -893,8 +893,7 @@ function_trace_call(unsigned long ip, un
 		return;
 
 	pc = preempt_count();
-	resched = need_resched();
-	preempt_disable_notrace();
+	resched = ftrace_preempt_disable();
 	local_save_flags(flags);
 	cpu = raw_smp_processor_id();
 	data = tr->data[cpu];
@@ -904,10 +903,7 @@ function_trace_call(unsigned long ip, un
 		trace_function(tr, data, ip, parent_ip, flags, pc);
 
 	atomic_dec(&data->disabled);
-	if (resched)
-		preempt_enable_no_resched_notrace();
-	else
-		preempt_enable_notrace();
+	ftrace_preempt_enable(resched);
 }
 
 static struct ftrace_ops trace_ops __read_mostly =
Index: linux-tip.git/kernel/trace/trace_sched_wakeup.c
===================================================================
--- linux-tip.git.orig/kernel/trace/trace_sched_wakeup.c	2008-11-03 18:49:30.000000000 -0500
+++ linux-tip.git/kernel/trace/trace_sched_wakeup.c	2008-11-03 19:05:24.000000000 -0500
@@ -50,8 +50,7 @@ wakeup_tracer_call(unsigned long ip, uns
 		return;
 
 	pc = preempt_count();
-	resched = need_resched();
-	preempt_disable_notrace();
+	resched = ftrace_preempt_disable();
 
 	cpu = raw_smp_processor_id();
 	data = tr->data[cpu];
@@ -81,15 +80,7 @@ wakeup_tracer_call(unsigned long ip, uns
  out:
 	atomic_dec(&data->disabled);
 
-	/*
-	 * To prevent recursion from the scheduler, if the
-	 * resched flag was set before we entered, then
-	 * don't reschedule.
-	 */
-	if (resched)
-		preempt_enable_no_resched_notrace();
-	else
-		preempt_enable_notrace();
+	ftrace_preempt_enable(resched);
 }
 
 static struct ftrace_ops trace_ops __read_mostly =
Index: linux-tip.git/kernel/trace/trace_stack.c
===================================================================
--- linux-tip.git.orig/kernel/trace/trace_stack.c	2008-11-03 18:49:30.000000000 -0500
+++ linux-tip.git/kernel/trace/trace_stack.c	2008-11-03 19:05:24.000000000 -0500
@@ -107,8 +107,7 @@ stack_trace_call(unsigned long ip, unsig
 	if (unlikely(!ftrace_enabled || stack_trace_disabled))
 		return;
 
-	resched = need_resched();
-	preempt_disable_notrace();
+	resched = ftrace_preempt_disable();
 
 	cpu = raw_smp_processor_id();
 	/* no atomic needed, we only modify this variable by this cpu */
@@ -120,10 +119,7 @@ stack_trace_call(unsigned long ip, unsig
  out:
 	per_cpu(trace_active, cpu)--;
 	/* prevent recursion in schedule */
-	if (resched)
-		preempt_enable_no_resched_notrace();
-	else
-		preempt_enable_notrace();
+	ftrace_preempt_enable(resched);
 }
 
 static struct ftrace_ops trace_ops __read_mostly =

-- 
