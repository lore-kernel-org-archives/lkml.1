Return-Path: <linux-kernel-owner+w=401wt.eu-S1754836AbZIMBu0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754836AbZIMBu0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Sep 2009 21:50:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754670AbZIMBuX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 Sep 2009 21:50:23 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:61262 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754471AbZIMBuV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Sep 2009 21:50:21 -0400
Message-Id: <20090913015023.371158736@goodmis.org>
References: <20090913014906.407896305@goodmis.org>
User-Agent: quilt/0.46-1
Date: Sat, 12 Sep 2009 21:49:08 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Li Zefan <lizf@cn.fujitsu.com>, Thomas Gleixner <tglx@linutronix.de>,
       Carsten Emde <Carsten.Emde@osadl.org>, Carsten Emde <C.Emde@osadl.org>
Subject: [PATCH 2/3] tracing: remove unused local variables in tracer probe functions
Content-Disposition: inline; filename=0002-tracing-remove-unused-local-variables-in-tracer-prob.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Carsten Emde <Carsten.Emde@osadl.org>

When the nsecs_to_usecs() conversion in probe_wakeup_sched_switch() and
check_critical_timing() was moved to a later stage in order to avoid
unnecessary computing, it was overlooked to remove the original
variables, assignments and comments..

Signed-off-by: Carsten Emde <C.Emde@osadl.org>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/trace_irqsoff.c      |   12 +-----------
 kernel/trace/trace_sched_wakeup.c |   10 ----------
 2 files changed, 1 insertions(+), 21 deletions(-)

diff --git a/kernel/trace/trace_irqsoff.c b/kernel/trace/trace_irqsoff.c
index 5555b75..06f8ea9 100644
--- a/kernel/trace/trace_irqsoff.c
+++ b/kernel/trace/trace_irqsoff.c
@@ -129,15 +129,10 @@ check_critical_timing(struct trace_array *tr,
 		      unsigned long parent_ip,
 		      int cpu)
 {
-	unsigned long latency, t0, t1;
 	cycle_t T0, T1, delta;
 	unsigned long flags;
 	int pc;
 
-	/*
-	 * usecs conversion is slow so we try to delay the conversion
-	 * as long as possible:
-	 */
 	T0 = data->preempt_timestamp;
 	T1 = ftrace_now(cpu);
 	delta = T1-T0;
@@ -157,17 +152,12 @@ check_critical_timing(struct trace_array *tr,
 
 	trace_function(tr, CALLER_ADDR0, parent_ip, flags, pc);
 
-	latency = nsecs_to_usecs(delta);
-
 	if (data->critical_sequence != max_sequence)
 		goto out_unlock;
 
-	tracing_max_latency = delta;
-	t0 = nsecs_to_usecs(T0);
-	t1 = nsecs_to_usecs(T1);
-
 	data->critical_end = parent_ip;
 
+	tracing_max_latency = delta;
 	update_max_tr_single(tr, current, cpu);
 
 	max_sequence++;
diff --git a/kernel/trace/trace_sched_wakeup.c b/kernel/trace/trace_sched_wakeup.c
index cf43bdb..6e1529b 100644
--- a/kernel/trace/trace_sched_wakeup.c
+++ b/kernel/trace/trace_sched_wakeup.c
@@ -110,7 +110,6 @@ static void notrace
 probe_wakeup_sched_switch(struct rq *rq, struct task_struct *prev,
 	struct task_struct *next)
 {
-	unsigned long latency = 0, t0 = 0, t1 = 0;
 	struct trace_array_cpu *data;
 	cycle_t T0, T1, delta;
 	unsigned long flags;
@@ -156,10 +155,6 @@ probe_wakeup_sched_switch(struct rq *rq, struct task_struct *prev,
 	trace_function(wakeup_trace, CALLER_ADDR0, CALLER_ADDR1, flags, pc);
 	tracing_sched_switch_trace(wakeup_trace, prev, next, flags, pc);
 
-	/*
-	 * usecs conversion is slow so we try to delay the conversion
-	 * as long as possible:
-	 */
 	T0 = data->preempt_timestamp;
 	T1 = ftrace_now(cpu);
 	delta = T1-T0;
@@ -167,12 +162,7 @@ probe_wakeup_sched_switch(struct rq *rq, struct task_struct *prev,
 	if (!report_latency(delta))
 		goto out_unlock;
 
-	latency = nsecs_to_usecs(delta);
-
 	tracing_max_latency = delta;
-	t0 = nsecs_to_usecs(T0);
-	t1 = nsecs_to_usecs(T1);
-
 	update_max_tr(wakeup_trace, wakeup_task, wakeup_cpu);
 
 out_unlock:
-- 
1.6.3.3

-- 
