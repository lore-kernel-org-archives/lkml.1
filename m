Return-Path: <linux-kernel-owner+w=401wt.eu-S1753434AbZCJE7w@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753434AbZCJE7w (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Mar 2009 00:59:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752821AbZCJE6U
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Mar 2009 00:58:20 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:42445 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751647AbZCJE6P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Mar 2009 00:58:15 -0400
Message-Id: <20090310045811.520029745@goodmis.org>
References: <20090310045710.286915983@goodmis.org>
User-Agent: quilt/0.46-1
Date: Tue, 10 Mar 2009 00:57:15 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>, Theodore Tso <tytso@mit.edu>,
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
Subject: [PATCH 5/7] tracing: convert the sched trace points to the TRACE_EVENT macros
Content-Disposition: inline; filename=0005-tracing-convert-the-sched-trace-points-to-the-TRACE.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

Impact: enhancement

This patch converts the rest of the sched trace points to use the new
more powerful TRACE_EVENT macro.

Signed-off-by: Steven Rostedt <srostedt@redhat.com>
---
 include/trace/sched_event_types.h |  322 ++++++++++++++++++++++++++++---------
 1 files changed, 246 insertions(+), 76 deletions(-)

diff --git a/include/trace/sched_event_types.h b/include/trace/sched_event_types.h
index aa77fb7..0bbbf41 100644
--- a/include/trace/sched_event_types.h
+++ b/include/trace/sched_event_types.h
@@ -8,59 +8,137 @@
 #undef TRACE_SYSTEM
 #define TRACE_SYSTEM sched
 
-TRACE_EVENT_FORMAT(sched_kthread_stop,
+/*
+ * Tracepoint for calling kthread_stop, performed to end a kthread:
+ */
+TRACE_EVENT(sched_kthread_stop,
+
 	TP_PROTO(struct task_struct *t),
+
 	TP_ARGS(t),
-	TP_FMT("task %s:%d", t->comm, t->pid),
-	TRACE_STRUCT(
-		TRACE_FIELD(pid_t, pid, t->pid)
+
+	TP_STRUCT__entry(
+		__array(	char,	comm,	TASK_COMM_LEN	)
+		__field(	pid_t,	pid			)
 	),
-	TP_RAW_FMT("task %d")
-	);
 
-TRACE_EVENT_FORMAT(sched_kthread_stop_ret,
+	TP_printk("task %s:%d", __entry->comm, __entry->pid),
+
+	TP_fast_assign(
+		memcpy(__entry->comm, t->comm, TASK_COMM_LEN);
+		__entry->pid	= t->pid;
+	)
+);
+
+/*
+ * Tracepoint for the return value of the kthread stopping:
+ */
+TRACE_EVENT(sched_kthread_stop_ret,
+
 	TP_PROTO(int ret),
+
 	TP_ARGS(ret),
-	TP_FMT("ret=%d", ret),
-	TRACE_STRUCT(
-		TRACE_FIELD(int, ret, ret)
+
+	TP_STRUCT__entry(
+		__field(	int,	ret	)
 	),
-	TP_RAW_FMT("ret=%d")
-	);
 
-TRACE_EVENT_FORMAT(sched_wait_task,
+	TP_printk("ret %d", __entry->ret),
+
+	TP_fast_assign(
+		__entry->ret	= ret;
+	)
+);
+
+/*
+ * Tracepoint for waiting on task to unschedule:
+ *
+ * (NOTE: the 'rq' argument is not used by generic trace events,
+ *        but used by the latency tracer plugin. )
+ */
+TRACE_EVENT(sched_wait_task,
+
 	TP_PROTO(struct rq *rq, struct task_struct *p),
+
 	TP_ARGS(rq, p),
-	TP_FMT("task %s:%d", p->comm, p->pid),
-	TRACE_STRUCT(
-		TRACE_FIELD(pid_t, pid, p->pid)
+
+	TP_STRUCT__entry(
+		__array(	char,	comm,	TASK_COMM_LEN	)
+		__field(	pid_t,	pid			)
+		__field(	int,	prio			)
 	),
-	TP_RAW_FMT("task %d")
-	);
 
-TRACE_EVENT_FORMAT(sched_wakeup,
+	TP_printk("task %s:%d [%d]",
+		  __entry->comm, __entry->pid, __entry->prio),
+
+	TP_fast_assign(
+		memcpy(__entry->comm, p->comm, TASK_COMM_LEN);
+		__entry->pid	= p->pid;
+		__entry->prio	= p->prio;
+	)
+);
+
+/*
+ * Tracepoint for waking up a task:
+ *
+ * (NOTE: the 'rq' argument is not used by generic trace events,
+ *        but used by the latency tracer plugin. )
+ */
+TRACE_EVENT(sched_wakeup,
+
 	TP_PROTO(struct rq *rq, struct task_struct *p, int success),
+
 	TP_ARGS(rq, p, success),
-	TP_FMT("task %s:%d %s",
-	      p->comm, p->pid, success ? "succeeded" : "failed"),
-	TRACE_STRUCT(
-		TRACE_FIELD(pid_t, pid, p->pid)
-		TRACE_FIELD(int, success, success)
+
+	TP_STRUCT__entry(
+		__array(	char,	comm,	TASK_COMM_LEN	)
+		__field(	pid_t,	pid			)
+		__field(	int,	prio			)
+		__field(	int,	success			)
 	),
-	TP_RAW_FMT("task %d success=%d")
-	);
 
-TRACE_EVENT_FORMAT(sched_wakeup_new,
+	TP_printk("task %s:%d [%d] success=%d",
+		  __entry->comm, __entry->pid, __entry->prio,
+		  __entry->success),
+
+	TP_fast_assign(
+		memcpy(__entry->comm, p->comm, TASK_COMM_LEN);
+		__entry->pid		= p->pid;
+		__entry->prio		= p->prio;
+		__entry->success	= success;
+	)
+);
+
+/*
+ * Tracepoint for waking up a new task:
+ *
+ * (NOTE: the 'rq' argument is not used by generic trace events,
+ *        but used by the latency tracer plugin. )
+ */
+TRACE_EVENT(sched_wakeup_new,
+
 	TP_PROTO(struct rq *rq, struct task_struct *p, int success),
+
 	TP_ARGS(rq, p, success),
-	TP_FMT("task %s:%d",
-	      p->comm, p->pid, success ? "succeeded" : "failed"),
-	TRACE_STRUCT(
-		TRACE_FIELD(pid_t, pid, p->pid)
-		TRACE_FIELD(int, success, success)
+
+	TP_STRUCT__entry(
+		__array(	char,	comm,	TASK_COMM_LEN	)
+		__field(	pid_t,	pid			)
+		__field(	int,	prio			)
+		__field(	int,	success			)
 	),
-	TP_RAW_FMT("task %d success=%d")
-	);
+
+	TP_printk("task %s:%d [%d] success=%d",
+		  __entry->comm, __entry->pid, __entry->prio,
+		  __entry->success),
+
+	TP_fast_assign(
+		memcpy(__entry->comm, p->comm, TASK_COMM_LEN);
+		__entry->pid		= p->pid;
+		__entry->prio		= p->prio;
+		__entry->success	= success;
+	)
+);
 
 /*
  * Tracepoint for task switches, performed by the scheduler:
@@ -98,70 +176,162 @@ TRACE_EVENT(sched_switch,
 	)
 );
 
-TRACE_EVENT_FORMAT(sched_migrate_task,
+/*
+ * Tracepoint for a task being migrated:
+ */
+TRACE_EVENT(sched_migrate_task,
+
 	TP_PROTO(struct task_struct *p, int orig_cpu, int dest_cpu),
+
 	TP_ARGS(p, orig_cpu, dest_cpu),
-	TP_FMT("task %s:%d from: %d  to: %d",
-	      p->comm, p->pid, orig_cpu, dest_cpu),
-	TRACE_STRUCT(
-		TRACE_FIELD(pid_t, pid, p->pid)
-		TRACE_FIELD(int, orig_cpu, orig_cpu)
-		TRACE_FIELD(int, dest_cpu, dest_cpu)
+
+	TP_STRUCT__entry(
+		__array(	char,	comm,	TASK_COMM_LEN	)
+		__field(	pid_t,	pid			)
+		__field(	int,	prio			)
+		__field(	int,	orig_cpu		)
+		__field(	int,	dest_cpu		)
 	),
-	TP_RAW_FMT("task %d  from: %d to: %d")
-	);
 
-TRACE_EVENT_FORMAT(sched_process_free,
+	TP_printk("task %s:%d [%d] from: %d  to: %d",
+		  __entry->comm, __entry->pid, __entry->prio,
+		  __entry->orig_cpu, __entry->dest_cpu),
+
+	TP_fast_assign(
+		memcpy(__entry->comm, p->comm, TASK_COMM_LEN);
+		__entry->pid		= p->pid;
+		__entry->prio		= p->prio;
+		__entry->orig_cpu	= orig_cpu;
+		__entry->dest_cpu	= dest_cpu;
+	)
+);
+
+/*
+ * Tracepoint for freeing a task:
+ */
+TRACE_EVENT(sched_process_free,
+
 	TP_PROTO(struct task_struct *p),
+
 	TP_ARGS(p),
-	TP_FMT("task %s:%d", p->comm, p->pid),
-	TRACE_STRUCT(
-		TRACE_FIELD(pid_t, pid, p->pid)
+
+	TP_STRUCT__entry(
+		__array(	char,	comm,	TASK_COMM_LEN	)
+		__field(	pid_t,	pid			)
+		__field(	int,	prio			)
 	),
-	TP_RAW_FMT("task %d")
-	);
 
-TRACE_EVENT_FORMAT(sched_process_exit,
+	TP_printk("task %s:%d [%d]",
+		  __entry->comm, __entry->pid, __entry->prio),
+
+	TP_fast_assign(
+		memcpy(__entry->comm, p->comm, TASK_COMM_LEN);
+		__entry->pid		= p->pid;
+		__entry->prio		= p->prio;
+	)
+);
+
+/*
+ * Tracepoint for a task exiting:
+ */
+TRACE_EVENT(sched_process_exit,
+
 	TP_PROTO(struct task_struct *p),
+
 	TP_ARGS(p),
-	TP_FMT("task %s:%d", p->comm, p->pid),
-	TRACE_STRUCT(
-		TRACE_FIELD(pid_t, pid, p->pid)
+
+	TP_STRUCT__entry(
+		__array(	char,	comm,	TASK_COMM_LEN	)
+		__field(	pid_t,	pid			)
+		__field(	int,	prio			)
 	),
-	TP_RAW_FMT("task %d")
-	);
 
-TRACE_EVENT_FORMAT(sched_process_wait,
+	TP_printk("task %s:%d [%d]",
+		  __entry->comm, __entry->pid, __entry->prio),
+
+	TP_fast_assign(
+		memcpy(__entry->comm, p->comm, TASK_COMM_LEN);
+		__entry->pid		= p->pid;
+		__entry->prio		= p->prio;
+	)
+);
+
+/*
+ * Tracepoint for a waiting task:
+ */
+TRACE_EVENT(sched_process_wait,
+
 	TP_PROTO(struct pid *pid),
+
 	TP_ARGS(pid),
-	TP_FMT("pid %d", pid_nr(pid)),
-	TRACE_STRUCT(
-		TRACE_FIELD(pid_t, pid, pid_nr(pid))
+
+	TP_STRUCT__entry(
+		__array(	char,	comm,	TASK_COMM_LEN	)
+		__field(	pid_t,	pid			)
+		__field(	int,	prio			)
 	),
-	TP_RAW_FMT("task %d")
-	);
 
-TRACE_EVENT_FORMAT(sched_process_fork,
+	TP_printk("task %s:%d [%d]",
+		  __entry->comm, __entry->pid, __entry->prio),
+
+	TP_fast_assign(
+		memcpy(__entry->comm, current->comm, TASK_COMM_LEN);
+		__entry->pid		= pid_nr(pid);
+		__entry->prio		= current->prio;
+	)
+);
+
+/*
+ * Tracepoint for do_fork:
+ */
+TRACE_EVENT(sched_process_fork,
+
 	TP_PROTO(struct task_struct *parent, struct task_struct *child),
+
 	TP_ARGS(parent, child),
-	TP_FMT("parent %s:%d  child %s:%d",
-	      parent->comm, parent->pid, child->comm, child->pid),
-	TRACE_STRUCT(
-		TRACE_FIELD(pid_t, parent, parent->pid)
-		TRACE_FIELD(pid_t, child, child->pid)
+
+	TP_STRUCT__entry(
+		__array(	char,	parent_comm,	TASK_COMM_LEN	)
+		__field(	pid_t,	parent_pid			)
+		__array(	char,	child_comm,	TASK_COMM_LEN	)
+		__field(	pid_t,	child_pid			)
 	),
-	TP_RAW_FMT("parent %d  child %d")
-	);
 
-TRACE_EVENT_FORMAT(sched_signal_send,
+	TP_printk("parent %s:%d  child %s:%d",
+		__entry->parent_comm, __entry->parent_pid,
+		__entry->child_comm, __entry->child_pid),
+
+	TP_fast_assign(
+		memcpy(__entry->parent_comm, parent->comm, TASK_COMM_LEN);
+		__entry->parent_pid	= parent->pid;
+		memcpy(__entry->child_comm, child->comm, TASK_COMM_LEN);
+		__entry->child_pid	= child->pid;
+	)
+);
+
+/*
+ * Tracepoint for sending a signal:
+ */
+TRACE_EVENT(sched_signal_send,
+
 	TP_PROTO(int sig, struct task_struct *p),
+
 	TP_ARGS(sig, p),
-	TP_FMT("sig: %d   task %s:%d", sig, p->comm, p->pid),
-	TRACE_STRUCT(
-		TRACE_FIELD(int, sig, sig)
-		TRACE_FIELD(pid_t, pid, p->pid)
+
+	TP_STRUCT__entry(
+		__field(	int,	sig			)
+		__array(	char,	comm,	TASK_COMM_LEN	)
+		__field(	pid_t,	pid			)
 	),
-	TP_RAW_FMT("sig: %d  task %d")
-	);
+
+	TP_printk("sig: %d  task %s:%d",
+		  __entry->sig, __entry->comm, __entry->pid),
+
+	TP_fast_assign(
+		memcpy(__entry->comm, p->comm, TASK_COMM_LEN);
+		__entry->pid	= p->pid;
+		__entry->sig	= sig;
+	)
+);
 
 #undef TRACE_SYSTEM
-- 
1.6.1.3

-- 
