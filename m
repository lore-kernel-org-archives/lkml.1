Return-Path: <linux-kernel-owner+w=401wt.eu-S1755699Ab0A2J0N@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755699Ab0A2J0N (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jan 2010 04:26:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754989Ab0A2J0H
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Jan 2010 04:26:07 -0500
Received: from hera.kernel.org ([140.211.167.34]:50613 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932192Ab0A2J0E (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jan 2010 04:26:04 -0500
Date: Fri, 29 Jan 2010 09:25:12 GMT
From: tip-bot for Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       fweisbec@gmail.com, rostedt@goodmis.org, tglx@linutronix.de,
       laijs@cn.fujitsu.com, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       fweisbec@gmail.com, rostedt@goodmis.org, tglx@linutronix.de,
       laijs@cn.fujitsu.com, mingo@elte.hu
In-Reply-To: <4B4DB0B6.7040607@cn.fujitsu.com>
References: <4B4DB0B6.7040607@cn.fujitsu.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:tracing/core] tracing: Simplify test for function_graph tracing start point
Message-ID: <tip-ea2c68a08fedb5053ba312d661e47df9f4d72411@git.kernel.org>
Git-Commit-ID: ea2c68a08fedb5053ba312d661e47df9f4d72411
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Fri, 29 Jan 2010 09:25:12 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  ea2c68a08fedb5053ba312d661e47df9f4d72411
Gitweb:     http://git.kernel.org/tip/ea2c68a08fedb5053ba312d661e47df9f4d72411
Author:     Lai Jiangshan <laijs@cn.fujitsu.com>
AuthorDate: Wed, 13 Jan 2010 19:38:30 +0800
Committer:  Frederic Weisbecker <fweisbec@gmail.com>
CommitDate: Fri, 29 Jan 2010 01:05:12 +0100

tracing: Simplify test for function_graph tracing start point

In the function graph tracer, a calling function is to be traced
only when it is enabled through the set_graph_function file,
or when it is nested in an enabled function.

Current code uses TSK_TRACE_FL_GRAPH to test whether it is nested
or not. Looking at the code, we can get this:
(trace->depth > 0) <==> (TSK_TRACE_FL_GRAPH is set)

trace->depth is more explicit to tell that it is nested.
So we use trace->depth directly and simplify the code.

No functionality is changed.
TSK_TRACE_FL_GRAPH is not removed yet, it is left for future usage.

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Steven Rostedt <rostedt@goodmis.org>
LKML-Reference: <4B4DB0B6.7040607@cn.fujitsu.com>
Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
---
 kernel/trace/trace.h                 |    2 +-
 kernel/trace/trace_functions_graph.c |    8 ++------
 2 files changed, 3 insertions(+), 7 deletions(-)

diff --git a/kernel/trace/trace.h b/kernel/trace/trace.h
index 4df6a77..ce077fb 100644
--- a/kernel/trace/trace.h
+++ b/kernel/trace/trace.h
@@ -504,7 +504,7 @@ static inline int ftrace_graph_addr(unsigned long addr)
 {
 	int i;
 
-	if (!ftrace_graph_count || test_tsk_trace_graph(current))
+	if (!ftrace_graph_count)
 		return 1;
 
 	for (i = 0; i < ftrace_graph_count; i++) {
diff --git a/kernel/trace/trace_functions_graph.c b/kernel/trace/trace_functions_graph.c
index f225229..616b135 100644
--- a/kernel/trace/trace_functions_graph.c
+++ b/kernel/trace/trace_functions_graph.c
@@ -215,7 +215,8 @@ int trace_graph_entry(struct ftrace_graph_ent *trace)
 	if (!ftrace_trace_task(current))
 		return 0;
 
-	if (!ftrace_graph_addr(trace->func))
+	/* trace it when it is-nested-in or is a function enabled. */
+	if (!(trace->depth || ftrace_graph_addr(trace->func)))
 		return 0;
 
 	local_irq_save(flags);
@@ -228,9 +229,6 @@ int trace_graph_entry(struct ftrace_graph_ent *trace)
 	} else {
 		ret = 0;
 	}
-	/* Only do the atomic if it is not already set */
-	if (!test_tsk_trace_graph(current))
-		set_tsk_trace_graph(current);
 
 	atomic_dec(&data->disabled);
 	local_irq_restore(flags);
@@ -278,8 +276,6 @@ void trace_graph_return(struct ftrace_graph_ret *trace)
 		pc = preempt_count();
 		__trace_graph_return(tr, trace, flags, pc);
 	}
-	if (!trace->depth)
-		clear_tsk_trace_graph(current);
 	atomic_dec(&data->disabled);
 	local_irq_restore(flags);
 }
