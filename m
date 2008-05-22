Return-Path: <linux-kernel-owner+w=401wt.eu-S1765548AbYEVEYA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765548AbYEVEYA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2008 00:24:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751507AbYEVEXI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 May 2008 00:23:08 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:56981 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751351AbYEVEXE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2008 00:23:04 -0400
Message-Id: <20080522042301.934671762@goodmis.org>
References: <20080522042215.584408893@goodmis.org>
User-Agent: quilt/0.46-1
Date: Thu, 22 May 2008 00:22:18 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, pq@iki.fi, proski@gnu.org,
       sandmann@redhat.com, a.p.zijlstra@chello.nl,
       Steven Rostedt <srostedt@redhat.com>
Subject: [PATCH 3/5] ftrace: move ftrace_special to trace.c
Content-Disposition: inline; filename=ftrace-move-ftrace-special-out-of-sched-switch.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Move the ftrace_special out of sched_switch to trace.c.

Signed-off-by: Steven Rostedt <srostedt@redhat.com>
---
 kernel/trace/trace.c              |   27 +++++++++++++++++++++++++--
 kernel/trace/trace_sched_switch.c |   24 ------------------------
 2 files changed, 25 insertions(+), 26 deletions(-)

Index: linux-tip.git/kernel/trace/trace.c
===================================================================
--- linux-tip.git.orig/kernel/trace/trace.c	2008-05-21 21:32:23.000000000 -0400
+++ linux-tip.git/kernel/trace/trace.c	2008-05-21 23:19:55.000000000 -0400
@@ -983,6 +983,30 @@ tracing_sched_wakeup_trace(struct trace_
 	trace_wake_up();
 }
 
+void
+ftrace_special(unsigned long arg1, unsigned long arg2, unsigned long arg3)
+{
+	struct trace_array *tr = &global_trace;
+	struct trace_array_cpu *data;
+	unsigned long flags;
+	long disabled;
+	int cpu;
+
+	if (tracing_disabled || current_trace == &no_tracer || !tr->ctrl)
+		return;
+
+	local_irq_save(flags);
+	cpu = raw_smp_processor_id();
+	data = tr->data[cpu];
+	disabled = atomic_inc_return(&data->disabled);
+
+	if (likely(disabled == 1))
+		__trace_special(tr, data, arg1, arg2, arg3);
+
+	atomic_dec(&data->disabled);
+	local_irq_restore(flags);
+}
+
 #ifdef CONFIG_FTRACE
 static void
 function_trace_call(unsigned long ip, unsigned long parent_ip)
@@ -2986,8 +3010,6 @@ __init static int tracer_alloc_buffers(v
 	int ret = -ENOMEM;
 	int i;
 
-	global_trace.ctrl = tracer_enabled;
-
 	/* TODO: make the number of buffers hot pluggable with CPUS */
 	tracing_nr_buffers = num_possible_cpus();
 	tracing_buffer_mask = cpu_possible_map;
@@ -3057,6 +3079,7 @@ __init static int tracer_alloc_buffers(v
 	current_trace = &no_tracer;
 
 	/* All seems OK, enable tracing */
+	global_trace.ctrl = tracer_enabled;
 	tracing_disabled = 0;
 
 	return 0;
Index: linux-tip.git/kernel/trace/trace_sched_switch.c
===================================================================
--- linux-tip.git.orig/kernel/trace/trace_sched_switch.c	2008-05-21 22:24:13.000000000 -0400
+++ linux-tip.git/kernel/trace/trace_sched_switch.c	2008-05-21 22:41:50.000000000 -0400
@@ -72,30 +72,6 @@ sched_switch_callback(void *probe_data, 
 	sched_switch_func(probe_data, __rq, prev, next);
 }
 
-void
-ftrace_special(unsigned long arg1, unsigned long arg2, unsigned long arg3)
-{
-	struct trace_array *tr = ctx_trace;
-	struct trace_array_cpu *data;
-	unsigned long flags;
-	long disabled;
-	int cpu;
-
-	if (!tracer_enabled)
-		return;
-
-	local_irq_save(flags);
-	cpu = raw_smp_processor_id();
-	data = tr->data[cpu];
-	disabled = atomic_inc_return(&data->disabled);
-
-	if (likely(disabled == 1))
-		__trace_special(tr, data, arg1, arg2, arg3);
-
-	atomic_dec(&data->disabled);
-	local_irq_restore(flags);
-}
-
 static void sched_switch_reset(struct trace_array *tr)
 {
 	int cpu;

-- 
