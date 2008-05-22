Return-Path: <linux-kernel-owner+w=401wt.eu-S1755322AbYEVPtf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755322AbYEVPtf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2008 11:49:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753321AbYEVPtY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 May 2008 11:49:24 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:61584 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753061AbYEVPtX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2008 11:49:23 -0400
Date: Thu, 22 May 2008 11:49:22 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Ingo Molnar <mingo@elte.hu>
cc: Peter Zijlstra <peterz@infradead.org>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] ftrace: fix up cmdline recording
Message-ID: <Pine.LNX.4.58.0805221147300.14724@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


The new work with converting the trace hooks over to markers broke the
command line recording of ftrace. This patch fixes it again.

Signed-off-by: Steven Rostedt <srostedt@redhat.com>
---
 kernel/trace/trace.c              |    3 ---
 kernel/trace/trace.h              |    4 ++--
 kernel/trace/trace_functions.c    |    4 ++--
 kernel/trace/trace_sched_switch.c |   21 +++++++++++++++------
 4 files changed, 19 insertions(+), 13 deletions(-)

Index: linux-tip.git/kernel/trace/trace.h
===================================================================
--- linux-tip.git.orig/kernel/trace/trace.h	2008-05-21 13:25:34.000000000 -0400
+++ linux-tip.git/kernel/trace/trace.h	2008-05-22 11:19:19.000000000 -0400
@@ -225,6 +225,8 @@ void trace_function(struct trace_array *

 void tracing_start_function_trace(void);
 void tracing_stop_function_trace(void);
+void tracing_start_cmdline_record(void);
+void tracing_stop_cmdline_record(void);
 int register_tracer(struct tracer *type);
 void unregister_tracer(struct tracer *type);

@@ -233,8 +235,6 @@ extern unsigned long nsecs_to_usecs(unsi
 extern unsigned long tracing_max_latency;
 extern unsigned long tracing_thresh;

-extern atomic_t trace_record_cmdline_enabled;
-
 void update_max_tr(struct trace_array *tr, struct task_struct *tsk, int cpu);
 void update_max_tr_single(struct trace_array *tr,
 			  struct task_struct *tsk, int cpu);
Index: linux-tip.git/kernel/trace/trace_functions.c
===================================================================
--- linux-tip.git.orig/kernel/trace/trace_functions.c	2008-05-21 13:25:34.000000000 -0400
+++ linux-tip.git/kernel/trace/trace_functions.c	2008-05-22 11:27:32.000000000 -0400
@@ -29,14 +29,14 @@ static void function_reset(struct trace_
 static void start_function_trace(struct trace_array *tr)
 {
 	function_reset(tr);
-	atomic_inc(&trace_record_cmdline_enabled);
+	tracing_start_cmdline_record();
 	tracing_start_function_trace();
 }

 static void stop_function_trace(struct trace_array *tr)
 {
 	tracing_stop_function_trace();
-	atomic_dec(&trace_record_cmdline_enabled);
+	tracing_stop_cmdline_record();
 }

 static void function_trace_init(struct trace_array *tr)
Index: linux-tip.git/kernel/trace/trace_sched_switch.c
===================================================================
--- linux-tip.git.orig/kernel/trace/trace_sched_switch.c	2008-05-22 08:04:49.000000000 -0400
+++ linux-tip.git/kernel/trace/trace_sched_switch.c	2008-05-22 11:26:13.000000000 -0400
@@ -29,6 +29,9 @@ sched_switch_func(void *private, void *_
 	long disabled;
 	int cpu;

+	tracing_record_cmdline(prev);
+	tracing_record_cmdline(next);
+
 	if (!tracer_enabled)
 		return;

@@ -63,8 +66,6 @@ sched_switch_callback(void *probe_data,
 	prev = va_arg(*args, typeof(prev));
 	next = va_arg(*args, typeof(next));

-	tracing_record_cmdline(prev);
-
 	/*
 	 * If tracer_switch_func only points to the local
 	 * switch func, it still needs the ptr passed to it.
@@ -123,18 +124,26 @@ void tracing_stop_sched_switch(void)
 		tracing_sched_unregister();
 }

+void tracing_start_cmdline_record(void)
+{
+	tracing_start_sched_switch();
+}
+
+void tracing_stop_cmdline_record(void)
+{
+	tracing_stop_sched_switch();
+}
+
 static void start_sched_trace(struct trace_array *tr)
 {
 	sched_switch_reset(tr);
-	atomic_inc(&trace_record_cmdline_enabled);
 	tracer_enabled = 1;
-	tracing_start_sched_switch();
+	tracing_start_cmdline_record();
 }

 static void stop_sched_trace(struct trace_array *tr)
 {
-	tracing_stop_sched_switch();
-	atomic_dec(&trace_record_cmdline_enabled);
+	tracing_stop_cmdline_record();
 	tracer_enabled = 0;
 }

Index: linux-tip.git/kernel/trace/trace.c
===================================================================
--- linux-tip.git.orig/kernel/trace/trace.c	2008-05-22 08:04:49.000000000 -0400
+++ linux-tip.git/kernel/trace/trace.c	2008-05-22 11:27:10.000000000 -0400
@@ -652,9 +652,6 @@ static char saved_cmdlines[SAVED_CMDLINE
 static int cmdline_idx;
 static DEFINE_SPINLOCK(trace_cmdline_lock);

-/* trace in all context switches */
-atomic_t trace_record_cmdline_enabled __read_mostly;
-
 /* temporary disable recording */
 atomic_t trace_record_cmdline_disabled __read_mostly;


