Return-Path: <linux-kernel-owner+w=401wt.eu-S1755857Ab0AMLkW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755857Ab0AMLkW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jan 2010 06:40:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755556Ab0AMLkV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Jan 2010 06:40:21 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:60994 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1755550Ab0AMLkU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jan 2010 06:40:20 -0500
Message-ID: <4B4DB0B6.7040607@cn.fujitsu.com>
Date: Wed, 13 Jan 2010 19:38:30 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>, Steven Rostedt <rostedt@goodmis.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] tracing, function_graph: simplify test for tracing
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


For function_graph, a calling function is to be traced only when
it is enabled or it is nested in a enabled function.

Current code uses TSK_TRACE_FL_GRAPH to test whether it is nested or not.
read the code, we can get this:
(trace->depth > 0) <==> (TSK_TRACE_FL_GRAPH is set)

trace->depth is more explicit to tell that it is nested.
So we use trace->depth directly and simplify the code.

No functionality is changed.
TSK_TRACE_FL_GRAPH is not removed now, it is left for future usage.

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
---
diff --git a/kernel/trace/trace.h b/kernel/trace/trace.h
index 3976520..9a69b9c 100644
--- a/kernel/trace/trace.h
+++ b/kernel/trace/trace.h
@@ -506,7 +506,7 @@ static inline int ftrace_graph_addr(unsigned long addr)
 {
 	int i;
 
-	if (!ftrace_graph_count || test_tsk_trace_graph(current))
+	if (!ftrace_graph_count)
 		return 1;
 
 	for (i = 0; i < ftrace_graph_count; i++) {
diff --git a/kernel/trace/trace_functions_graph.c b/kernel/trace/trace_functions_graph.c
index b1342c5..8e17a57 100644
--- a/kernel/trace/trace_functions_graph.c
+++ b/kernel/trace/trace_functions_graph.c
@@ -218,7 +218,8 @@ int trace_graph_entry(struct ftrace_graph_ent *trace)
 	if (!ftrace_trace_task(current))
 		return 0;
 
-	if (!ftrace_graph_addr(trace->func))
+	/* trace it when it is-nested-in or is a function enabled. */
+	if (!(trace->depth || ftrace_graph_addr(trace->func)))
 		return 0;
 
 	local_irq_save(flags);
@@ -231,9 +232,6 @@ int trace_graph_entry(struct ftrace_graph_ent *trace)
 	} else {
 		ret = 0;
 	}
-	/* Only do the atomic if it is not already set */
-	if (!test_tsk_trace_graph(current))
-		set_tsk_trace_graph(current);
 
 	atomic_dec(&data->disabled);
 	local_irq_restore(flags);
@@ -281,8 +279,6 @@ void trace_graph_return(struct ftrace_graph_ret *trace)
 		pc = preempt_count();
 		__trace_graph_return(tr, trace, flags, pc);
 	}
-	if (!trace->depth)
-		clear_tsk_trace_graph(current);
 	atomic_dec(&data->disabled);
 	local_irq_restore(flags);
 }

