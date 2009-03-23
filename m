Return-Path: <linux-kernel-owner+w=401wt.eu-S1760584AbZCWW2X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760584AbZCWW2X (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Mar 2009 18:28:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753225AbZCWW2O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Mar 2009 18:28:14 -0400
Received: from hera.kernel.org ([140.211.167.34]:52362 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752553AbZCWW2N (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Mar 2009 18:28:13 -0400
Date: Mon, 23 Mar 2009 22:27:32 GMT
From: Frederic Weisbecker <fweisbec@gmail.com>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       fweisbec@gmail.com, rostedt@goodmis.org, tglx@linutronix.de,
       mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       fweisbec@gmail.com, rostedt@goodmis.org, tglx@linutronix.de,
       mingo@elte.hu
In-Reply-To: <1237843021-11695-1-git-send-email-fweisbec@gmail.com>
References: <1237843021-11695-1-git-send-email-fweisbec@gmail.com>
Subject: [tip:tracing/filters] tracing/function-graph-tracer: fix functions call traces imbalance
Message-ID: <tip-1618536961d31f9b3f55767b22d4a897f4204c26@git.kernel.org>
Git-Commit-ID: 1618536961d31f9b3f55767b22d4a897f4204c26
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Mon, 23 Mar 2009 22:27:34 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  1618536961d31f9b3f55767b22d4a897f4204c26
Gitweb:     http://git.kernel.org/tip/1618536961d31f9b3f55767b22d4a897f4204c26
Author:     Frederic Weisbecker <fweisbec@gmail.com>
AuthorDate: Mon, 23 Mar 2009 22:17:01 +0100
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Mon, 23 Mar 2009 23:25:32 +0100

tracing/function-graph-tracer: fix functions call traces imbalance

Impact: fix traces output

Sometimes one can observe an imbalance in the traces between function
calls and function return traces:

func1() {
    }
}

The curly brace inside func1() is the return of another function nested
inside func1. The return trace have been inserted in the buffer but not
the entry.
We are storing a return address on the function traces stack while we
haven't inserted its entry on the buffer, hence the imbalance on the
traces.

This is because the tracers doesn't check all failures that can happen
on buffer insertion.

This patch reports the tracing recursion failures and the ring buffer
failures. In such cases, we now restore the original return address for
the function, giving up its return trace.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
LKML-Reference: <1237843021-11695-1-git-send-email-fweisbec@gmail.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 kernel/trace/trace.c |   16 +++++++++++-----
 1 files changed, 11 insertions(+), 5 deletions(-)

diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index 6bad128..89f0c25 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -924,7 +924,7 @@ trace_function(struct trace_array *tr,
 }
 
 #ifdef CONFIG_FUNCTION_GRAPH_TRACER
-static void __trace_graph_entry(struct trace_array *tr,
+static int __trace_graph_entry(struct trace_array *tr,
 				struct ftrace_graph_ent *trace,
 				unsigned long flags,
 				int pc)
@@ -933,15 +933,17 @@ static void __trace_graph_entry(struct trace_array *tr,
 	struct ftrace_graph_ent_entry *entry;
 
 	if (unlikely(local_read(&__get_cpu_var(ftrace_cpu_disabled))))
-		return;
+		return 0;
 
 	event = trace_buffer_lock_reserve(&global_trace, TRACE_GRAPH_ENT,
 					  sizeof(*entry), flags, pc);
 	if (!event)
-		return;
+		return 0;
 	entry	= ring_buffer_event_data(event);
 	entry->graph_ent			= *trace;
 	ring_buffer_unlock_commit(global_trace.buffer, event);
+
+	return 1;
 }
 
 static void __trace_graph_return(struct trace_array *tr,
@@ -1162,6 +1164,7 @@ int trace_graph_entry(struct ftrace_graph_ent *trace)
 	struct trace_array_cpu *data;
 	unsigned long flags;
 	long disabled;
+	int ret;
 	int cpu;
 	int pc;
 
@@ -1177,15 +1180,18 @@ int trace_graph_entry(struct ftrace_graph_ent *trace)
 	disabled = atomic_inc_return(&data->disabled);
 	if (likely(disabled == 1)) {
 		pc = preempt_count();
-		__trace_graph_entry(tr, trace, flags, pc);
+		ret = __trace_graph_entry(tr, trace, flags, pc);
+	} else {
+		ret = 0;
 	}
 	/* Only do the atomic if it is not already set */
 	if (!test_tsk_trace_graph(current))
 		set_tsk_trace_graph(current);
+
 	atomic_dec(&data->disabled);
 	local_irq_restore(flags);
 
-	return 1;
+	return ret;
 }
 
 void trace_graph_return(struct ftrace_graph_ret *trace)
