Return-Path: <linux-kernel-owner+w=401wt.eu-S1757173AbZCJVHd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757173AbZCJVHd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Mar 2009 17:07:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755600AbZCJVFl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Mar 2009 17:05:41 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:41999 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754233AbZCJVFf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Mar 2009 17:05:35 -0400
Message-Id: <20090310210531.528259075@goodmis.org>
References: <20090310210408.419131392@goodmis.org>
User-Agent: quilt/0.46-1
Date: Tue, 10 Mar 2009 17:04:13 -0400
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
Subject: [PATCH 5/7] tracing: document TRACE_EVENT macro in tracepoint.h
Content-Disposition: inline; filename=0005-tracing-document-TRACE_EVENT-macro-in-tracepoint.h.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

Impact: clean up / comments

Kosaki Motohiro asked about an explanation to the TRACE_EVENT macro.
Ingo Molnar replied with a nice description.

This patch takes the description that Ingo wrote (with some slight
modifications) and adds it to the tracepoint.h file.

Reported-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Signed-off-by: Steven Rostedt <srostedt@redhat.com>
---
 include/linux/tracepoint.h |  103 ++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 103 insertions(+), 0 deletions(-)

diff --git a/include/linux/tracepoint.h b/include/linux/tracepoint.h
index c7b0945..119ece2 100644
--- a/include/linux/tracepoint.h
+++ b/include/linux/tracepoint.h
@@ -157,6 +157,109 @@ static inline void tracepoint_synchronize_unregister(void)
 #define TRACE_FORMAT(name, proto, args, fmt)		\
 	DECLARE_TRACE(name, PARAMS(proto), PARAMS(args))
 
+
+/*
+ * For use with the TRACE_EVENT macro:
+ *
+ * We define a tracepoint, its arguments, its printk format
+ * and its 'fast binay record' layout.
+ *
+ * Firstly, name your tracepoint via TRACE_EVENT(name : the
+ * 'subsystem_event' notation is fine.
+ *
+ * Think about this whole construct as the
+ * 'trace_sched_switch() function' from now on.
+ *
+ *
+ *  TRACE_EVENT(sched_switch,
+ *
+ *	*
+ *	* A function has a regular function arguments
+ *	* prototype, declare it via TP_PROTO():
+ *	*
+ *
+ * 	TP_PROTO(struct rq *rq, struct task_struct *prev,
+ * 		 struct task_struct *next),
+ *
+ *	*
+ *	* Define the call signature of the 'function'.
+ *	* (Design sidenote: we use this instead of a
+ *	*  TP_PROTO1/TP_PROTO2/TP_PROTO3 ugliness.)
+ *	*
+ *
+ * 	TP_ARGS(rq, prev, next),
+ *
+ *	*
+ *	* Fast binary tracing: define the trace record via
+ *	* TP_STRUCT__entry(). You can think about it like a
+ *	* regular C structure local variable definition.
+ *	*
+ *	* This is how the trace record is structured and will
+ *	* be saved into the ring buffer. These are the fields
+ *	* that will be exposed to user-space in
+ *	* /debug/tracing/events/<*>/format.
+ *	*
+ *	* The declared 'local variable' is called '__entry'
+ *	*
+ *	* __field(pid_t, prev_prid) is equivalent to a standard declariton:
+ *	*
+ *	*	pid_t	prev_pid;
+ *	*
+ *	* __array(char, prev_comm, TASK_COMM_LEN) is equivalent to:
+ *	*
+ *	*	char	prev_comm[TASK_COMM_LEN];
+ *	*
+ *
+ *	TP_STRUCT__entry(
+ *		__array(	char,	prev_comm,	TASK_COMM_LEN	)
+ *		__field(	pid_t,	prev_pid			)
+ *		__field(	int,	prev_prio			)
+ *		__array(	char,	next_comm,	TASK_COMM_LEN	)
+ *		__field(	pid_t,	next_pid			)
+ *		__field(	int,	next_prio			)
+ *	),
+ *
+ *	*
+ *	* Assign the entry into the trace record, by embedding
+ *	* a full C statement block into TP_fast_assign(). You
+ *	* can refer to the trace record as '__entry' -
+ *	* otherwise you can put arbitrary C code in here.
+ *	*
+ *	* Note: this C code will execute every time a trace event
+ *	* happens, on an active tracepoint.
+ *	*
+ *
+ * 	TP_fast_assign(
+ * 		memcpy(__entry->next_comm, next->comm, TASK_COMM_LEN);
+ * 		__entry->prev_pid	= prev->pid;
+ * 		__entry->prev_prio	= prev->prio;
+ *		memcpy(__entry->prev_comm, prev->comm, TASK_COMM_LEN);
+ *		__entry->next_pid	= next->pid;
+ * 		__entry->next_prio	= next->prio;
+ *	)
+ *
+ *	*
+ *	* Formatted output of a trace record via TP_printk().
+ *	* This is how the tracepoint will appear under ftrace
+ *	* plugins that make use of this tracepoint.
+ *	*
+ *	* (raw-binary tracing wont actually perform this step.)
+ *	*
+ *
+ *	TP_printk("task %s:%d [%d] ==> %s:%d [%d]",
+ *		__entry->prev_comm, __entry->prev_pid, __entry->prev_prio,
+ *		__entry->next_comm, __entry->next_pid, __entry->next_prio),
+ *
+ * );
+ *
+ * This macro construct is thus used for the regular printk format
+ * tracing setup, it is used to construct a function pointer based
+ * tracepoint callback (this is used by programmatic plugins and
+ * can also by used by generic instrumentation like SystemTap), and
+ * it is also used to expose a structured trace record in
+ * /debug/tracing/events/.
+ */
+
 #define TRACE_EVENT(name, proto, args, struct, assign, print)	\
 	DECLARE_TRACE(name, PARAMS(proto), PARAMS(args))
 
-- 
1.6.1.3

-- 
