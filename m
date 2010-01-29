Return-Path: <linux-kernel-owner+w=401wt.eu-S1755823Ab0A2AYV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755823Ab0A2AYV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jan 2010 19:24:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753726Ab0A2AYU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Jan 2010 19:24:20 -0500
Received: from fg-out-1718.google.com ([72.14.220.154]:40505 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754815Ab0A2AYU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jan 2010 19:24:20 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=JYA1SFtW/7heai9zZJT8H7M/fd9yjSQpGV/Xu8OCIA8hppitpMJkoEe3TzhXaChksC
         d/6nN6tI5cuNJXF+5mFxzlErVcnhOme0hlkckboMrw1/7C/0R5UHfm2esgscplLeV7f0
         uwMXVHyhYKJ15/NT++j6YgFUVzV+QqyhlhXhE=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Lai Jiangshan <laijs@cn.fujitsu.com>,
       Steven Rostedt <rostedt@goodmis.org>
Subject: [GIT PULL] tracing core patchlet
Date: Fri, 29 Jan 2010 01:24:18 +0100
Message-Id: <1264724658-12991-1-git-send-regression-fweisbec@gmail.com>
X-Mailer: git-send-email 1.6.2.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo,

Please pull the tracing/core branch that can be found at:

git://git.kernel.org/pub/scm/linux/kernel/git/frederic/random-tracing.git
	tracing/core

Thanks,
	Frederic
---

Lai Jiangshan (1):
      tracing: Simplify test for function_graph tracing start point


 kernel/trace/trace.h                 |    2 +-
 kernel/trace/trace_functions_graph.c |    8 ++------
 2 files changed, 3 insertions(+), 7 deletions(-)

---
commit ea2c68a08fedb5053ba312d661e47df9f4d72411
Author: Lai Jiangshan <laijs@cn.fujitsu.com>
Date:   Wed Jan 13 19:38:30 2010 +0800

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
