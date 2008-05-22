Return-Path: <linux-kernel-owner+w=401wt.eu-S1765873AbYEVEYv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765873AbYEVEYv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2008 00:24:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751746AbYEVEXL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 May 2008 00:23:11 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:36604 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751357AbYEVEXE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2008 00:23:04 -0400
Message-Id: <20080522042302.091353246@goodmis.org>
References: <20080522042215.584408893@goodmis.org>
User-Agent: quilt/0.46-1
Date: Thu, 22 May 2008 00:22:19 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, pq@iki.fi, proski@gnu.org,
       sandmann@redhat.com, a.p.zijlstra@chello.nl,
       Steven Rostedt <srostedt@redhat.com>
Subject: [PATCH 4/5] ftrace: add function tracing to wake up tracing
Content-Disposition: inline; filename=ftrace-add-function-trace-to-wakeup.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds function tracing to the functions that are called
on the CPU of the task being traced.

Signed-off-by: Steven Rostedt <srostedt@redhat.com>
---
 kernel/trace/trace_sched_wakeup.c |   67 +++++++++++++++++++++++++++++++++++++-
 1 file changed, 66 insertions(+), 1 deletion(-)

Index: linux-tip.git/kernel/trace/trace_sched_wakeup.c
===================================================================
--- linux-tip.git.orig/kernel/trace/trace_sched_wakeup.c	2008-05-21 20:22:27.000000000 -0400
+++ linux-tip.git/kernel/trace/trace_sched_wakeup.c	2008-05-22 00:01:50.000000000 -0400
@@ -30,6 +30,69 @@ static DEFINE_SPINLOCK(wakeup_lock);
 
 static void __wakeup_reset(struct trace_array *tr);
 
+#ifdef CONFIG_FTRACE
+/*
+ * irqsoff uses its own tracer function to keep the overhead down:
+ */
+static void
+wakeup_tracer_call(unsigned long ip, unsigned long parent_ip)
+{
+	struct trace_array *tr = wakeup_trace;
+	struct trace_array_cpu *data;
+	unsigned long flags;
+	long disabled;
+	int resched;
+	int cpu;
+
+	if (likely(!wakeup_task))
+		return;
+
+	resched = need_resched();
+	preempt_disable_notrace();
+
+	cpu = raw_smp_processor_id();
+	data = tr->data[cpu];
+	disabled = atomic_inc_return(&data->disabled);
+	if (unlikely(disabled != 1))
+		goto out;
+
+	spin_lock_irqsave(&wakeup_lock, flags);
+
+	if (unlikely(!wakeup_task))
+		goto unlock;
+
+	/*
+	 * The task can't disappear because it needs to
+	 * wake up first, and we have the wakeup_lock.
+	 */
+	if (task_cpu(wakeup_task) != cpu)
+		goto unlock;
+
+	trace_function(tr, data, ip, parent_ip, flags);
+
+ unlock:
+	spin_unlock_irqrestore(&wakeup_lock, flags);
+
+ out:
+	atomic_dec(&data->disabled);
+
+	/*
+	 * To prevent recursion from the scheduler, if the
+	 * resched flag was set before we entered, then
+	 * don't reschedule.
+	 */
+	if (resched)
+		preempt_enable_no_resched_notrace();
+	else
+		preempt_enable_notrace();
+}
+
+static struct ftrace_ops trace_ops __read_mostly =
+{
+	.func = wakeup_tracer_call,
+};
+#endif /* CONFIG_FTRACE */
+
 /*
  * Should this new latency be reported/recorded?
  */
@@ -73,7 +136,7 @@ wakeup_sched_switch(void *private, void 
 	if (next != wakeup_task)
 		return;
 
-	/* The task we are waitng for is waking up */
+	/* The task we are waiting for is waking up */
 	data = tr->data[wakeup_cpu];
 
 	/* disable local data, not wakeup_cpu data */
@@ -290,6 +353,7 @@ static void start_wakeup_tracer(struct t
 	smp_wmb();
 
 	tracer_enabled = 1;
+	register_ftrace_function(&trace_ops);
 
 	return;
 fail_deprobe_wake_new:
@@ -305,6 +369,7 @@ fail_deprobe:
 static void stop_wakeup_tracer(struct trace_array *tr)
 {
 	tracer_enabled = 0;
+	unregister_ftrace_function(&trace_ops);
 	marker_probe_unregister("kernel_sched_schedule",
 				sched_switch_callback,
 				&wakeup_trace);

-- 
