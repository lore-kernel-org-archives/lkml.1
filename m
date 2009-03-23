Return-Path: <linux-kernel-owner+w=401wt.eu-S1759820AbZCWVRV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759820AbZCWVRV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Mar 2009 17:17:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751660AbZCWVRK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Mar 2009 17:17:10 -0400
Received: from mail-bw0-f169.google.com ([209.85.218.169]:45297 "EHLO
	mail-bw0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751082AbZCWVRJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Mar 2009 17:17:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=VtXBQ0RXQDWepVIKG2VhcCgi6zJ1beARWiOUrNK/Wd1TZ4Ub/WJjgLABrpvyK/LFST
         /xs0dHFXVBcNgmboSWOpiqBNkYe7iLrmCG2t0mhvGljgwOOFVzwPcwfJ2R+3XVuCTcjF
         3GrPbCR4jsI2kj8crs0EwzLbl13k45MOK1xT8=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Steven Rostedt <rostedt@goodmis.org>, LKML <linux-kernel@vger.kernel.org>,
       Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH] tracing/function-graph-tracer: fix functions call traces imbalance
Date: Mon, 23 Mar 2009 22:17:01 +0100
Message-Id: <1237843021-11695-1-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.6.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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

This is because the tracers doesn't check all failures that can happen on
buffer insertion.
This patch reports the tracing recursion failures and the ring buffer
failures. In such cases, we now restore the original return address for the
function, giving up its return trace.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
---
 kernel/trace/trace.c |   16 +++++++++++-----
 1 files changed, 11 insertions(+), 5 deletions(-)

diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index 5c8571b..dcfb116 100644
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
-- 
1.6.1

