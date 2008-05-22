Return-Path: <linux-kernel-owner+w=401wt.eu-S932285AbYEVEXk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932285AbYEVEXk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2008 00:23:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751387AbYEVEXH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 May 2008 00:23:07 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:56975 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751332AbYEVEXE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2008 00:23:04 -0400
Message-Id: <20080522042301.782160037@goodmis.org>
References: <20080522042215.584408893@goodmis.org>
User-Agent: quilt/0.46-1
Date: Thu, 22 May 2008 00:22:17 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, pq@iki.fi, proski@gnu.org,
       sandmann@redhat.com, a.p.zijlstra@chello.nl,
       Steven Rostedt <srostedt@redhat.com>
Subject: [PATCH 2/5] ftrace: remove wakeup functions from sched_switch tracer
Content-Disposition: inline; filename=ftrace-remove-wakeup-from-sched.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The added wakeup functions inside the sched_switch tracer dirty the trace
quite a bit. The sched_switch tracer is used to watch context switches.
Adding wakeups to this make the flow of this trace much more complex to
understand.

Perhaps we can add a way to turn on or off this tracing but for now I'm
reverting the sched_switch back to its original behavior.

Signed-off-by: Steven Rostedt <srostedt@redhat.com>
---
 kernel/trace/trace_sched_switch.c |   92 --------------------------------------
 1 file changed, 1 insertion(+), 91 deletions(-)

Index: linux-tip.git/kernel/trace/trace_sched_switch.c
===================================================================
--- linux-tip.git.orig/kernel/trace/trace_sched_switch.c	2008-05-21 13:25:34.000000000 -0400
+++ linux-tip.git/kernel/trace/trace_sched_switch.c	2008-05-21 22:24:13.000000000 -0400
@@ -72,59 +72,6 @@ sched_switch_callback(void *probe_data, 
 	sched_switch_func(probe_data, __rq, prev, next);
 }
 
-static void
-wakeup_func(void *private, void *__rq, struct task_struct *wakee, struct
-			task_struct *curr)
-{
-	struct trace_array **ptr = private;
-	struct trace_array *tr = *ptr;
-	struct trace_array_cpu *data;
-	unsigned long flags;
-	long disabled;
-	int cpu;
-
-	if (!tracer_enabled)
-		return;
-
-	tracing_record_cmdline(curr);
-
-	local_irq_save(flags);
-	cpu = raw_smp_processor_id();
-	data = tr->data[cpu];
-	disabled = atomic_inc_return(&data->disabled);
-
-	if (likely(disabled == 1))
-		tracing_sched_wakeup_trace(tr, data, wakee, curr, flags);
-
-	atomic_dec(&data->disabled);
-	local_irq_restore(flags);
-}
-
-static notrace void
-wake_up_callback(void *probe_data, void *call_data,
-		 const char *format, va_list *args)
-{
-	struct task_struct *curr;
-	struct task_struct *task;
-	struct rq *__rq;
-
-	if (likely(!tracer_enabled))
-		return;
-
-	/* Skip pid %d state %ld */
-	(void)va_arg(*args, int);
-	(void)va_arg(*args, long);
-	/* now get the meat: "rq %p task %p rq->curr %p" */
-	__rq = va_arg(*args, typeof(__rq));
-	task = va_arg(*args, typeof(task));
-	curr = va_arg(*args, typeof(curr));
-
-	tracing_record_cmdline(task);
-	tracing_record_cmdline(curr);
-
-	wakeup_func(probe_data, __rq, task, curr);
-}
-
 void
 ftrace_special(unsigned long arg1, unsigned long arg2, unsigned long arg3)
 {
@@ -163,47 +110,16 @@ static int tracing_sched_register(void)
 {
 	int ret;
 
-	ret = marker_probe_register("kernel_sched_wakeup",
-			"pid %d state %ld ## rq %p task %p rq->curr %p",
-			wake_up_callback,
-			&ctx_trace);
-	if (ret) {
-		pr_info("wakeup trace: Couldn't add marker"
-			" probe to kernel_sched_wakeup\n");
-		return ret;
-	}
-
-	ret = marker_probe_register("kernel_sched_wakeup_new",
-			"pid %d state %ld ## rq %p task %p rq->curr %p",
-			wake_up_callback,
-			&ctx_trace);
-	if (ret) {
-		pr_info("wakeup trace: Couldn't add marker"
-			" probe to kernel_sched_wakeup_new\n");
-		goto fail_deprobe;
-	}
-
 	ret = marker_probe_register("kernel_sched_schedule",
 		"prev_pid %d next_pid %d prev_state %ld "
 		"## rq %p prev %p next %p",
 		sched_switch_callback,
 		&ctx_trace);
-	if (ret) {
+	if (ret)
 		pr_info("sched trace: Couldn't add marker"
 			" probe to kernel_sched_schedule\n");
-		goto fail_deprobe_wake_new;
-	}
 
 	return ret;
-fail_deprobe_wake_new:
-	marker_probe_unregister("kernel_sched_wakeup_new",
-				wake_up_callback,
-				&ctx_trace);
-fail_deprobe:
-	marker_probe_unregister("kernel_sched_wakeup",
-				wake_up_callback,
-				&ctx_trace);
-	return ret;
 }
 
 static void tracing_sched_unregister(void)
@@ -211,12 +127,6 @@ static void tracing_sched_unregister(voi
 	marker_probe_unregister("kernel_sched_schedule",
 				sched_switch_callback,
 				&ctx_trace);
-	marker_probe_unregister("kernel_sched_wakeup_new",
-				wake_up_callback,
-				&ctx_trace);
-	marker_probe_unregister("kernel_sched_wakeup",
-				wake_up_callback,
-				&ctx_trace);
 }
 
 void tracing_start_sched_switch(void)

-- 
