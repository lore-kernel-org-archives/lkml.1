Return-Path: <linux-kernel-owner+w=401wt.eu-S1757517AbZCJVIS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757517AbZCJVIS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Mar 2009 17:08:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755821AbZCJVFn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Mar 2009 17:05:43 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:48396 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754679AbZCJVFf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Mar 2009 17:05:35 -0400
Message-Id: <20090310210531.292811947@goodmis.org>
References: <20090310210408.419131392@goodmis.org>
User-Agent: quilt/0.46-1
Date: Tue, 10 Mar 2009 17:04:12 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Mathieu Desnoyers <compudj@krystal.dyndns.org>,
       Lai Jiangshan <laijs@cn.fujitsu.com>,
       "Martin J. Bligh" <mbligh@mbligh.org>,
       "Frank Ch. Eigler" <fche@redhat.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Larry Woodman <lwoodman@redhat.com>, Jason Baron <jbaron@redhat.com>,
       Tom Zanussi <tzanussi@gmail.com>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       Christoph Hellwig <hch@infradead.org>,
       Jiaying Zhang <jiayingz@google.com>,
       Steven Rostedt <srostedt@redhat.com>
Subject: [PATCH 4/7] tracing: flip the TP_printk and TP_fast_assign in the TRACE_EVENT macro
Content-Disposition: inline; filename=0004-tracing-flip-the-TP_printk-and-TP_fast_assign-in-th.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

Impact: clean up

In trying to stay consistant with the C style format in the TRACE_EVENT
macro, it makes more sense to do the printk after the assigning of
the variables.

Reported-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Steven Rostedt <srostedt@redhat.com>
---
 include/linux/tracepoint.h          |    2 +-
 include/trace/irq_event_types.h     |    8 ++--
 include/trace/sched_event_types.h   |  102 +++++++++++++++++-----------------
 kernel/trace/trace_events_stage_1.h |    2 +-
 kernel/trace/trace_events_stage_2.h |    4 +-
 kernel/trace/trace_events_stage_3.h |    2 +-
 6 files changed, 60 insertions(+), 60 deletions(-)

diff --git a/include/linux/tracepoint.h b/include/linux/tracepoint.h
index 69b5698..c7b0945 100644
--- a/include/linux/tracepoint.h
+++ b/include/linux/tracepoint.h
@@ -157,7 +157,7 @@ static inline void tracepoint_synchronize_unregister(void)
 #define TRACE_FORMAT(name, proto, args, fmt)		\
 	DECLARE_TRACE(name, PARAMS(proto), PARAMS(args))
 
-#define TRACE_EVENT(name, proto, args, struct, print, assign)	\
+#define TRACE_EVENT(name, proto, args, struct, assign, print)	\
 	DECLARE_TRACE(name, PARAMS(proto), PARAMS(args))
 
 #endif
diff --git a/include/trace/irq_event_types.h b/include/trace/irq_event_types.h
index 43bcb74..214bb92 100644
--- a/include/trace/irq_event_types.h
+++ b/include/trace/irq_event_types.h
@@ -31,13 +31,13 @@ TRACE_EVENT(irq_handler_exit,
 		__field(	int,	ret	)
 	),
 
-	TP_printk("irq=%d return=%s",
-		  __entry->irq, __entry->ret ? "handled" : "unhandled"),
-
 	TP_fast_assign(
 		__entry->irq	= irq;
 		__entry->ret	= ret;
-	)
+	),
+
+	TP_printk("irq=%d return=%s",
+		  __entry->irq, __entry->ret ? "handled" : "unhandled")
 );
 
 #undef TRACE_SYSTEM
diff --git a/include/trace/sched_event_types.h b/include/trace/sched_event_types.h
index fb37af6..63547dc 100644
--- a/include/trace/sched_event_types.h
+++ b/include/trace/sched_event_types.h
@@ -22,12 +22,12 @@ TRACE_EVENT(sched_kthread_stop,
 		__field(	pid_t,	pid			)
 	),
 
-	TP_printk("task %s:%d", __entry->comm, __entry->pid),
-
 	TP_fast_assign(
 		memcpy(__entry->comm, t->comm, TASK_COMM_LEN);
 		__entry->pid	= t->pid;
-	)
+	),
+
+	TP_printk("task %s:%d", __entry->comm, __entry->pid)
 );
 
 /*
@@ -43,11 +43,11 @@ TRACE_EVENT(sched_kthread_stop_ret,
 		__field(	int,	ret	)
 	),
 
-	TP_printk("ret %d", __entry->ret),
-
 	TP_fast_assign(
 		__entry->ret	= ret;
-	)
+	),
+
+	TP_printk("ret %d", __entry->ret)
 );
 
 /*
@@ -68,14 +68,14 @@ TRACE_EVENT(sched_wait_task,
 		__field(	int,	prio			)
 	),
 
-	TP_printk("task %s:%d [%d]",
-		  __entry->comm, __entry->pid, __entry->prio),
-
 	TP_fast_assign(
 		memcpy(__entry->comm, p->comm, TASK_COMM_LEN);
 		__entry->pid	= p->pid;
 		__entry->prio	= p->prio;
-	)
+	),
+
+	TP_printk("task %s:%d [%d]",
+		  __entry->comm, __entry->pid, __entry->prio)
 );
 
 /*
@@ -97,16 +97,16 @@ TRACE_EVENT(sched_wakeup,
 		__field(	int,	success			)
 	),
 
-	TP_printk("task %s:%d [%d] success=%d",
-		  __entry->comm, __entry->pid, __entry->prio,
-		  __entry->success),
-
 	TP_fast_assign(
 		memcpy(__entry->comm, p->comm, TASK_COMM_LEN);
 		__entry->pid		= p->pid;
 		__entry->prio		= p->prio;
 		__entry->success	= success;
-	)
+	),
+
+	TP_printk("task %s:%d [%d] success=%d",
+		  __entry->comm, __entry->pid, __entry->prio,
+		  __entry->success)
 );
 
 /*
@@ -128,16 +128,16 @@ TRACE_EVENT(sched_wakeup_new,
 		__field(	int,	success			)
 	),
 
-	TP_printk("task %s:%d [%d] success=%d",
-		  __entry->comm, __entry->pid, __entry->prio,
-		  __entry->success),
-
 	TP_fast_assign(
 		memcpy(__entry->comm, p->comm, TASK_COMM_LEN);
 		__entry->pid		= p->pid;
 		__entry->prio		= p->prio;
 		__entry->success	= success;
-	)
+	),
+
+	TP_printk("task %s:%d [%d] success=%d",
+		  __entry->comm, __entry->pid, __entry->prio,
+		  __entry->success)
 );
 
 /*
@@ -162,10 +162,6 @@ TRACE_EVENT(sched_switch,
 		__field(	int,	next_prio			)
 	),
 
-	TP_printk("task %s:%d [%d] ==> %s:%d [%d]",
-		__entry->prev_comm, __entry->prev_pid, __entry->prev_prio,
-		__entry->next_comm, __entry->next_pid, __entry->next_prio),
-
 	TP_fast_assign(
 		memcpy(__entry->next_comm, next->comm, TASK_COMM_LEN);
 		__entry->prev_pid	= prev->pid;
@@ -173,7 +169,11 @@ TRACE_EVENT(sched_switch,
 		memcpy(__entry->prev_comm, prev->comm, TASK_COMM_LEN);
 		__entry->next_pid	= next->pid;
 		__entry->next_prio	= next->prio;
-	)
+	),
+
+	TP_printk("task %s:%d [%d] ==> %s:%d [%d]",
+		__entry->prev_comm, __entry->prev_pid, __entry->prev_prio,
+		__entry->next_comm, __entry->next_pid, __entry->next_prio)
 );
 
 /*
@@ -193,17 +193,17 @@ TRACE_EVENT(sched_migrate_task,
 		__field(	int,	dest_cpu		)
 	),
 
-	TP_printk("task %s:%d [%d] from: %d  to: %d",
-		  __entry->comm, __entry->pid, __entry->prio,
-		  __entry->orig_cpu, __entry->dest_cpu),
-
 	TP_fast_assign(
 		memcpy(__entry->comm, p->comm, TASK_COMM_LEN);
 		__entry->pid		= p->pid;
 		__entry->prio		= p->prio;
 		__entry->orig_cpu	= orig_cpu;
 		__entry->dest_cpu	= dest_cpu;
-	)
+	),
+
+	TP_printk("task %s:%d [%d] from: %d  to: %d",
+		  __entry->comm, __entry->pid, __entry->prio,
+		  __entry->orig_cpu, __entry->dest_cpu)
 );
 
 /*
@@ -221,14 +221,14 @@ TRACE_EVENT(sched_process_free,
 		__field(	int,	prio			)
 	),
 
-	TP_printk("task %s:%d [%d]",
-		  __entry->comm, __entry->pid, __entry->prio),
-
 	TP_fast_assign(
 		memcpy(__entry->comm, p->comm, TASK_COMM_LEN);
 		__entry->pid		= p->pid;
 		__entry->prio		= p->prio;
-	)
+	),
+
+	TP_printk("task %s:%d [%d]",
+		  __entry->comm, __entry->pid, __entry->prio)
 );
 
 /*
@@ -246,14 +246,14 @@ TRACE_EVENT(sched_process_exit,
 		__field(	int,	prio			)
 	),
 
-	TP_printk("task %s:%d [%d]",
-		  __entry->comm, __entry->pid, __entry->prio),
-
 	TP_fast_assign(
 		memcpy(__entry->comm, p->comm, TASK_COMM_LEN);
 		__entry->pid		= p->pid;
 		__entry->prio		= p->prio;
-	)
+	),
+
+	TP_printk("task %s:%d [%d]",
+		  __entry->comm, __entry->pid, __entry->prio)
 );
 
 /*
@@ -271,14 +271,14 @@ TRACE_EVENT(sched_process_wait,
 		__field(	int,	prio			)
 	),
 
-	TP_printk("task %s:%d [%d]",
-		  __entry->comm, __entry->pid, __entry->prio),
-
 	TP_fast_assign(
 		memcpy(__entry->comm, current->comm, TASK_COMM_LEN);
 		__entry->pid		= pid_nr(pid);
 		__entry->prio		= current->prio;
-	)
+	),
+
+	TP_printk("task %s:%d [%d]",
+		  __entry->comm, __entry->pid, __entry->prio)
 );
 
 /*
@@ -297,16 +297,16 @@ TRACE_EVENT(sched_process_fork,
 		__field(	pid_t,	child_pid			)
 	),
 
-	TP_printk("parent %s:%d  child %s:%d",
-		__entry->parent_comm, __entry->parent_pid,
-		__entry->child_comm, __entry->child_pid),
-
 	TP_fast_assign(
 		memcpy(__entry->parent_comm, parent->comm, TASK_COMM_LEN);
 		__entry->parent_pid	= parent->pid;
 		memcpy(__entry->child_comm, child->comm, TASK_COMM_LEN);
 		__entry->child_pid	= child->pid;
-	)
+	),
+
+	TP_printk("parent %s:%d  child %s:%d",
+		__entry->parent_comm, __entry->parent_pid,
+		__entry->child_comm, __entry->child_pid)
 );
 
 /*
@@ -324,14 +324,14 @@ TRACE_EVENT(sched_signal_send,
 		__field(	pid_t,	pid			)
 	),
 
-	TP_printk("sig: %d  task %s:%d",
-		  __entry->sig, __entry->comm, __entry->pid),
-
 	TP_fast_assign(
 		memcpy(__entry->comm, p->comm, TASK_COMM_LEN);
 		__entry->pid	= p->pid;
 		__entry->sig	= sig;
-	)
+	),
+
+	TP_printk("sig: %d  task %s:%d",
+		  __entry->sig, __entry->comm, __entry->pid)
 );
 
 #undef TRACE_SYSTEM
diff --git a/kernel/trace/trace_events_stage_1.h b/kernel/trace/trace_events_stage_1.h
index 15e9bf9..82f6844 100644
--- a/kernel/trace/trace_events_stage_1.h
+++ b/kernel/trace/trace_events_stage_1.h
@@ -27,7 +27,7 @@
 #define TP_STRUCT__entry(args...) args
 
 #undef TRACE_EVENT
-#define TRACE_EVENT(name, proto, args, tstruct, print, assign)	\
+#define TRACE_EVENT(name, proto, args, tstruct, assign, print)	\
 	struct ftrace_raw_##name {				\
 		struct trace_entry	ent;			\
 		tstruct						\
diff --git a/kernel/trace/trace_events_stage_2.h b/kernel/trace/trace_events_stage_2.h
index d91bf4c..1ad9f8d 100644
--- a/kernel/trace/trace_events_stage_2.h
+++ b/kernel/trace/trace_events_stage_2.h
@@ -39,7 +39,7 @@
 #define TP_printk(fmt, args...) fmt "\n", args
 
 #undef TRACE_EVENT
-#define TRACE_EVENT(call, proto, args, tstruct, print, assign)		\
+#define TRACE_EVENT(call, proto, args, tstruct, assign, print)		\
 enum print_line_t							\
 ftrace_raw_output_##call(struct trace_iterator *iter, int flags)	\
 {									\
@@ -115,7 +115,7 @@ ftrace_raw_output_##call(struct trace_iterator *iter, int flags)	\
 #define TP_fast_assign(args...) args
 
 #undef TRACE_EVENT
-#define TRACE_EVENT(call, proto, args, tstruct, print, func)		\
+#define TRACE_EVENT(call, proto, args, tstruct, func, print)		\
 static int								\
 ftrace_format_##call(struct trace_seq *s)				\
 {									\
diff --git a/kernel/trace/trace_events_stage_3.h b/kernel/trace/trace_events_stage_3.h
index 3ba55d4..d6de06b 100644
--- a/kernel/trace/trace_events_stage_3.h
+++ b/kernel/trace/trace_events_stage_3.h
@@ -148,7 +148,7 @@ __attribute__((section("_ftrace_events"))) event_##call = {		\
 #define __entry entry
 
 #undef TRACE_EVENT
-#define TRACE_EVENT(call, proto, args, tstruct, print, assign)		\
+#define TRACE_EVENT(call, proto, args, tstruct, assign, print)		\
 									\
 static struct ftrace_event_call event_##call;				\
 									\
-- 
1.6.1.3

-- 
