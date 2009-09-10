Return-Path: <linux-kernel-owner+w=401wt.eu-S1752667AbZIJENN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752667AbZIJENN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Sep 2009 00:13:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751149AbZIJENE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Sep 2009 00:13:04 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:41395 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750804AbZIJENA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Sep 2009 00:13:00 -0400
Message-Id: <20090910041300.722961667@goodmis.org>
References: <20090910041219.149954890@goodmis.org>
User-Agent: quilt/0.46-1
Date: Thu, 10 Sep 2009 00:12:21 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH 2/6] tracing: do not grab lock in wakeup latency function tracing
Content-Disposition: inline; filename=0002-tracing-do-not-grab-lock-in-wakeup-latency-function-.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

The wakeup tracer, when enabled, has its own function tracer.
It only traces the functions on the CPU where the task it is following
is on. If a task is woken on one CPU but then migrates to another CPU
before it wakes up, the latency tracer will then start tracing functions
on the other CPU.

To find which CPU the task is on, the wakeup function tracer performs
a task_cpu(wakeup_task). But to make sure the task does not disappear
it grabs the wakeup_lock, which is also taken when the task wakes up.
By taking this lock, the function tracer does not need to worry about
the task being freed as it checks its cpu.

Jan Blunck found a problem with this approach on his 32 CPU box. When
a task is being traced by the wakeup tracer, all functions take this
lock. That means that on all 32 CPUs, each function call is taking
this one lock to see if the task is on that CPU. This lock has just
serialized all functions on all 32 CPUs. Needless to say, this caused
major issues on that box. It would even lockup.

This patch changes the wakeup latency to insert a probe on the migrate task
tracepoint. When a task changes its CPU that it will run on, the
probe will take note. Now the wakeup function tracer no longer needs
to take the lock. It only compares the current CPU with a variable that
holds the current CPU the task is on. We don't worry about races since
it is OK to add or miss a function trace.

Reported-by: Jan Blunck <jblunck@suse.de>
Tested-by: Jan Blunck <jblunck@suse.de>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/trace_sched_wakeup.c |   36 ++++++++++++++++++++++--------------
 1 files changed, 22 insertions(+), 14 deletions(-)

diff --git a/kernel/trace/trace_sched_wakeup.c b/kernel/trace/trace_sched_wakeup.c
index ad69f10..cf43bdb 100644
--- a/kernel/trace/trace_sched_wakeup.c
+++ b/kernel/trace/trace_sched_wakeup.c
@@ -24,6 +24,7 @@ static int __read_mostly	tracer_enabled;
 
 static struct task_struct	*wakeup_task;
 static int			wakeup_cpu;
+static int			wakeup_current_cpu;
 static unsigned			wakeup_prio = -1;
 static int			wakeup_rt;
 
@@ -56,33 +57,23 @@ wakeup_tracer_call(unsigned long ip, unsigned long parent_ip)
 	resched = ftrace_preempt_disable();
 
 	cpu = raw_smp_processor_id();
+	if (cpu != wakeup_current_cpu)
+		goto out_enable;
+
 	data = tr->data[cpu];
 	disabled = atomic_inc_return(&data->disabled);
 	if (unlikely(disabled != 1))
 		goto out;
 
 	local_irq_save(flags);
-	__raw_spin_lock(&wakeup_lock);
-
-	if (unlikely(!wakeup_task))
-		goto unlock;
-
-	/*
-	 * The task can't disappear because it needs to
-	 * wake up first, and we have the wakeup_lock.
-	 */
-	if (task_cpu(wakeup_task) != cpu)
-		goto unlock;
 
 	trace_function(tr, ip, parent_ip, flags, pc);
 
- unlock:
-	__raw_spin_unlock(&wakeup_lock);
 	local_irq_restore(flags);
 
  out:
 	atomic_dec(&data->disabled);
-
+ out_enable:
 	ftrace_preempt_enable(resched);
 }
 
@@ -107,6 +98,14 @@ static int report_latency(cycle_t delta)
 	return 1;
 }
 
+static void probe_wakeup_migrate_task(struct task_struct *task, int cpu)
+{
+	if (task != wakeup_task)
+		return;
+
+	wakeup_current_cpu = cpu;
+}
+
 static void notrace
 probe_wakeup_sched_switch(struct rq *rq, struct task_struct *prev,
 	struct task_struct *next)
@@ -244,6 +243,7 @@ probe_wakeup(struct rq *rq, struct task_struct *p, int success)
 	__wakeup_reset(wakeup_trace);
 
 	wakeup_cpu = task_cpu(p);
+	wakeup_current_cpu = wakeup_cpu;
 	wakeup_prio = p->prio;
 
 	wakeup_task = p;
@@ -293,6 +293,13 @@ static void start_wakeup_tracer(struct trace_array *tr)
 		goto fail_deprobe_wake_new;
 	}
 
+	ret = register_trace_sched_migrate_task(probe_wakeup_migrate_task);
+	if (ret) {
+		pr_info("wakeup trace: Couldn't activate tracepoint"
+			" probe to kernel_sched_migrate_task\n");
+		return;
+	}
+
 	wakeup_reset(tr);
 
 	/*
@@ -325,6 +332,7 @@ static void stop_wakeup_tracer(struct trace_array *tr)
 	unregister_trace_sched_switch(probe_wakeup_sched_switch);
 	unregister_trace_sched_wakeup_new(probe_wakeup);
 	unregister_trace_sched_wakeup(probe_wakeup);
+	unregister_trace_sched_migrate_task(probe_wakeup_migrate_task);
 }
 
 static int __wakeup_tracer_init(struct trace_array *tr)
-- 
1.6.3.3

-- 
