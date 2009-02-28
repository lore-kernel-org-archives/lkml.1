Return-Path: <linux-kernel-owner+w=401wt.eu-S1754595AbZB1JO0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754595AbZB1JO0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Feb 2009 04:14:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754564AbZB1JJz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Feb 2009 04:09:55 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:36628 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754128AbZB1JJm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Feb 2009 04:09:42 -0500
Message-Id: <20090228090938.634332049@goodmis.org>
References: <20090228090646.265765024@goodmis.org>
User-Agent: quilt/0.46-1
Date: Sat, 28 Feb 2009 04:06:55 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Mathieu Desnoyers <compudj@krystal.dyndns.org>,
       Tom Zanussi <tzanussi@gmail.com>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Jason Baron <jbaron@redhat.com>, "Frank Ch. Eigler" <fche@redhat.com>,
       acme@ghostprotocols.net, Steven Rostedt <srostedt@redhat.com>
Subject: [PATCH 09/10] tracing: create the C style tracing for the sched subsystem
Content-Disposition: inline; filename=0009-tracing-create-the-C-style-tracing-for-the-sched-su.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

This patch utilizes the TRACE_EVENT_FORMAT macro to enable the C style
faster tracing for the sched subsystem trace points.

Signed-off-by: Steven Rostedt <srostedt@redhat.com>
---
 include/linux/tracepoint.h        |    3 +
 include/trace/sched_event_types.h |  119 +++++++++++++++++++++++++++++--------
 2 files changed, 97 insertions(+), 25 deletions(-)

diff --git a/include/linux/tracepoint.h b/include/linux/tracepoint.h
index 62d1339..152b2f0 100644
--- a/include/linux/tracepoint.h
+++ b/include/linux/tracepoint.h
@@ -157,4 +157,7 @@ static inline void tracepoint_synchronize_unregister(void)
 #define TRACE_FORMAT(name, proto, args, fmt)		\
 	DECLARE_TRACE(name, PARAMS(proto), PARAMS(args))
 
+#define TRACE_EVENT_FORMAT(name, proto, args, fmt, struct, tpfmt)	\
+	TRACE_FORMAT(name, PARAMS(proto), PARAMS(args), PARAMS(fmt))
+
 #endif
diff --git a/include/trace/sched_event_types.h b/include/trace/sched_event_types.h
index 2ada206..ba059c1 100644
--- a/include/trace/sched_event_types.h
+++ b/include/trace/sched_event_types.h
@@ -1,6 +1,6 @@
 
 /* use <trace/sched.h> instead */
-#ifndef TRACE_FORMAT
+#ifndef TRACE_EVENT_FORMAT
 # error Do not include this file directly.
 # error Unless you know what you are doing.
 #endif
@@ -8,70 +8,139 @@
 #undef TRACE_SYSTEM
 #define TRACE_SYSTEM sched
 
-TRACE_FORMAT(sched_kthread_stop,
+TRACE_EVENT_FORMAT(sched_kthread_stop,
 	TPPROTO(struct task_struct *t),
 	TPARGS(t),
-	TPFMT("task %s:%d", t->comm, t->pid));
+	TPFMT("task %s:%d", t->comm, t->pid),
+	TRACE_STRUCT(
+		TRACE_FIELD(pid_t, pid, t->pid)
+	),
+	TPRAWFMT("task %d")
+	);
 
-TRACE_FORMAT(sched_kthread_stop_ret,
+TRACE_EVENT_FORMAT(sched_kthread_stop_ret,
 	TPPROTO(int ret),
 	TPARGS(ret),
-	TPFMT("ret=%d", ret));
+	TPFMT("ret=%d", ret),
+	TRACE_STRUCT(
+		TRACE_FIELD(int, ret, ret)
+	),
+	TPRAWFMT("ret=%d")
+	);
 
-TRACE_FORMAT(sched_wait_task,
+TRACE_EVENT_FORMAT(sched_wait_task,
 	TPPROTO(struct rq *rq, struct task_struct *p),
 	TPARGS(rq, p),
-	TPFMT("task %s:%d", p->comm, p->pid));
+	TPFMT("task %s:%d", p->comm, p->pid),
+	TRACE_STRUCT(
+		TRACE_FIELD(pid_t, pid, p->pid)
+	),
+	TPRAWFMT("task %d")
+	);
 
-TRACE_FORMAT(sched_wakeup,
+TRACE_EVENT_FORMAT(sched_wakeup,
 	TPPROTO(struct rq *rq, struct task_struct *p, int success),
 	TPARGS(rq, p, success),
 	TPFMT("task %s:%d %s",
-	      p->comm, p->pid, success?"succeeded":"failed"));
+	      p->comm, p->pid, success ? "succeeded" : "failed"),
+	TRACE_STRUCT(
+		TRACE_FIELD(pid_t, pid, p->pid)
+		TRACE_FIELD(int, success, success)
+	),
+	TPRAWFMT("task %d success=%d")
+	);
 
-TRACE_FORMAT(sched_wakeup_new,
+TRACE_EVENT_FORMAT(sched_wakeup_new,
 	TPPROTO(struct rq *rq, struct task_struct *p, int success),
 	TPARGS(rq, p, success),
 	TPFMT("task %s:%d",
-	      p->comm, p->pid, success?"succeeded":"failed"));
+	      p->comm, p->pid, success ? "succeeded" : "failed"),
+	TRACE_STRUCT(
+		TRACE_FIELD(pid_t, pid, p->pid)
+		TRACE_FIELD(int, success, success)
+	),
+	TPRAWFMT("task %d success=%d")
+	);
 
-TRACE_FORMAT(sched_switch,
+TRACE_EVENT_FORMAT(sched_switch,
 	TPPROTO(struct rq *rq, struct task_struct *prev,
 		struct task_struct *next),
 	TPARGS(rq, prev, next),
 	TPFMT("task %s:%d ==> %s:%d",
-	      prev->comm, prev->pid, next->comm, next->pid));
+	      prev->comm, prev->pid, next->comm, next->pid),
+	TRACE_STRUCT(
+		TRACE_FIELD(pid_t, prev_pid, prev->pid)
+		TRACE_FIELD(int, prev_prio, prev->prio)
+		TRACE_FIELD(pid_t, next_pid, next->pid)
+		TRACE_FIELD(int, next_prio, next->prio)
+	),
+	TPRAWFMT("prev %d:%d ==> next %d:%d")
+	);
 
-TRACE_FORMAT(sched_migrate_task,
+TRACE_EVENT_FORMAT(sched_migrate_task,
 	TPPROTO(struct task_struct *p, int orig_cpu, int dest_cpu),
 	TPARGS(p, orig_cpu, dest_cpu),
 	TPFMT("task %s:%d from: %d  to: %d",
-	      p->comm, p->pid, orig_cpu, dest_cpu));
+	      p->comm, p->pid, orig_cpu, dest_cpu),
+	TRACE_STRUCT(
+		TRACE_FIELD(pid_t, pid, p->pid)
+		TRACE_FIELD(int, orig_cpu, orig_cpu)
+		TRACE_FIELD(int, dest_cpu, dest_cpu)
+	),
+	TPRAWFMT("task %d  from: %d to: %d")
+	);
 
-TRACE_FORMAT(sched_process_free,
+TRACE_EVENT_FORMAT(sched_process_free,
 	TPPROTO(struct task_struct *p),
 	TPARGS(p),
-	TPFMT("task %s:%d", p->comm, p->pid));
+	TPFMT("task %s:%d", p->comm, p->pid),
+	TRACE_STRUCT(
+		TRACE_FIELD(pid_t, pid, p->pid)
+	),
+	TPRAWFMT("task %d")
+	);
 
-TRACE_FORMAT(sched_process_exit,
+TRACE_EVENT_FORMAT(sched_process_exit,
 	TPPROTO(struct task_struct *p),
 	TPARGS(p),
-	TPFMT("task %s:%d", p->comm, p->pid));
+	TPFMT("task %s:%d", p->comm, p->pid),
+	TRACE_STRUCT(
+		TRACE_FIELD(pid_t, pid, p->pid)
+	),
+	TPRAWFMT("task %d")
+	);
 
-TRACE_FORMAT(sched_process_wait,
+TRACE_EVENT_FORMAT(sched_process_wait,
 	TPPROTO(struct pid *pid),
 	TPARGS(pid),
-	TPFMT("pid %d", pid));
+	TPFMT("pid %d", pid_nr(pid)),
+	TRACE_STRUCT(
+		TRACE_FIELD(pid_t, pid, pid_nr(pid))
+	),
+	TPRAWFMT("task %d")
+	);
 
-TRACE_FORMAT(sched_process_fork,
+TRACE_EVENT_FORMAT(sched_process_fork,
 	TPPROTO(struct task_struct *parent, struct task_struct *child),
 	TPARGS(parent, child),
 	TPFMT("parent %s:%d  child %s:%d",
-	      parent->comm, parent->pid, child->comm, child->pid));
+	      parent->comm, parent->pid, child->comm, child->pid),
+	TRACE_STRUCT(
+		TRACE_FIELD(pid_t, parent, parent->pid)
+		TRACE_FIELD(pid_t, child, child->pid)
+	),
+	TPRAWFMT("parent %d  child %d")
+	);
 
-TRACE_FORMAT(sched_signal_send,
+TRACE_EVENT_FORMAT(sched_signal_send,
 	TPPROTO(int sig, struct task_struct *p),
 	TPARGS(sig, p),
-	TPFMT("sig: %d   task %s:%d", sig, p->comm, p->pid));
+	TPFMT("sig: %d   task %s:%d", sig, p->comm, p->pid),
+	TRACE_STRUCT(
+		TRACE_FIELD(int, sig, sig)
+		TRACE_FIELD(pid_t, pid, p->pid)
+	),
+	TPRAWFMT("sig: %d  task %d")
+	);
 
 #undef TRACE_SYSTEM
-- 
1.5.6.5

-- 
