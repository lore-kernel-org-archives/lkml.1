Return-Path: <linux-kernel-owner+w=401wt.eu-S1760432AbZDQVNu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760432AbZDQVNu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Apr 2009 17:13:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757702AbZDQVMg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Apr 2009 17:12:36 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:48526 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754610AbZDQVMd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Apr 2009 17:12:33 -0400
Message-Id: <20090417211231.218150513@goodmis.org>
References: <20090417211135.408179566@goodmis.org>
User-Agent: quilt/0.46-1
Date: Fri, 17 Apr 2009 17:11:38 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH 3/5] tracing: add same level recursion detection
Content-Disposition: inline; filename=0003-tracing-add-same-level-recursion-detection.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

The tracing infrastructure allows for recursion. That is, an interrupt
may interrupt the act of tracing an event, and that interrupt may very well
perform its own trace. This is a recursive trace, and is fine to do.

The problem arises when there is a bug, and the utility doing the trace
calls something that recurses back into the tracer. This recursion is not
caused by an external event like an interrupt, but by code that is not
expected to recurse. The result could be a lockup.

This patch adds a bitmask to the task structure that keeps track
of the trace recursion. To find the interrupt depth, the following
algorithm is used:

  level = hardirq_count() + softirq_count() + in_nmi;

Here, level will be the depth of interrutps and softirqs, and even handles
the nmi. Then the corresponding bit is set in the recursion bitmask.
If the bit was already set, we know we had a recursion at the same level
and we warn about it and fail the writing to the buffer.

After the data has been committed to the buffer, we clear the bit.
No atomics are needed. The only races are with interrupts and they reset
the bitmask before returning anywy.

[ Impact: detect same irq level trace recursion ]

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 include/linux/ftrace.h     |    7 +++++++
 include/linux/init_task.h  |    1 +
 include/linux/sched.h      |    4 +++-
 kernel/trace/ring_buffer.c |   42 ++++++++++++++++++++++++++++++++++++++++++
 4 files changed, 53 insertions(+), 1 deletions(-)

diff --git a/include/linux/ftrace.h b/include/linux/ftrace.h
index 97c83e1..39b95c5 100644
--- a/include/linux/ftrace.h
+++ b/include/linux/ftrace.h
@@ -488,8 +488,15 @@ static inline int test_tsk_trace_graph(struct task_struct *tsk)
 
 extern int ftrace_dump_on_oops;
 
+#ifdef CONFIG_PREEMPT
+#define INIT_TRACE_RECURSION		.trace_recursion = 0,
+#endif
+
 #endif /* CONFIG_TRACING */
 
+#ifndef INIT_TRACE_RECURSION
+#define INIT_TRACE_RECURSION
+#endif
 
 #ifdef CONFIG_HW_BRANCH_TRACER
 
diff --git a/include/linux/init_task.h b/include/linux/init_task.h
index dcfb933..6fc2185 100644
--- a/include/linux/init_task.h
+++ b/include/linux/init_task.h
@@ -187,6 +187,7 @@ extern struct cred init_cred;
 	INIT_TRACE_IRQFLAGS						\
 	INIT_LOCKDEP							\
 	INIT_FTRACE_GRAPH						\
+	INIT_TRACE_RECURSION						\
 }
 
 
diff --git a/include/linux/sched.h b/include/linux/sched.h
index b4c38bc..7ede5e4 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1428,7 +1428,9 @@ struct task_struct {
 #ifdef CONFIG_TRACING
 	/* state flags for use by tracers */
 	unsigned long trace;
-#endif
+	/* bitmask of trace recursion */
+	unsigned long trace_recursion;
+#endif /* CONFIG_TRACING */
 };
 
 /* Future-safe accessor for struct task_struct's cpus_allowed. */
diff --git a/kernel/trace/ring_buffer.c b/kernel/trace/ring_buffer.c
index 84a6055..b421b0e 100644
--- a/kernel/trace/ring_buffer.c
+++ b/kernel/trace/ring_buffer.c
@@ -1481,6 +1481,40 @@ rb_reserve_next_event(struct ring_buffer_per_cpu *cpu_buffer,
 	return event;
 }
 
+static int trace_irq_level(void)
+{
+	return hardirq_count() + softirq_count() + in_nmi();
+}
+
+static int trace_recursive_lock(void)
+{
+	int level;
+
+	level = trace_irq_level();
+
+	if (unlikely(current->trace_recursion & (1 << level))) {
+		/* Disable all tracing before we do anything else */
+		tracing_off_permanent();
+		WARN_ON_ONCE(1);
+		return -1;
+	}
+
+	current->trace_recursion |= 1 << level;
+
+	return 0;
+}
+
+static void trace_recursive_unlock(void)
+{
+	int level;
+
+	level = trace_irq_level();
+
+	WARN_ON_ONCE(!current->trace_recursion & (1 << level));
+
+	current->trace_recursion &= ~(1 << level);
+}
+
 static DEFINE_PER_CPU(int, rb_need_resched);
 
 /**
@@ -1514,6 +1548,9 @@ ring_buffer_lock_reserve(struct ring_buffer *buffer, unsigned long length)
 	/* If we are tracing schedule, we don't want to recurse */
 	resched = ftrace_preempt_disable();
 
+	if (trace_recursive_lock())
+		goto out_nocheck;
+
 	cpu = raw_smp_processor_id();
 
 	if (!cpumask_test_cpu(cpu, buffer->cpumask))
@@ -1543,6 +1580,9 @@ ring_buffer_lock_reserve(struct ring_buffer *buffer, unsigned long length)
 	return event;
 
  out:
+	trace_recursive_unlock();
+
+ out_nocheck:
 	ftrace_preempt_enable(resched);
 	return NULL;
 }
@@ -1581,6 +1621,8 @@ int ring_buffer_unlock_commit(struct ring_buffer *buffer,
 
 	rb_commit(cpu_buffer, event);
 
+	trace_recursive_unlock();
+
 	/*
 	 * Only the last preempt count needs to restore preemption.
 	 */
-- 
1.6.2.1

-- 
