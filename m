Return-Path: <linux-kernel-owner+w=401wt.eu-S1755557Ab0AVBQw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755557Ab0AVBQw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jan 2010 20:16:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755409Ab0AVBQg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Jan 2010 20:16:36 -0500
Received: from mail-fx0-f220.google.com ([209.85.220.220]:57482 "EHLO
	mail-fx0-f220.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755085Ab0AVBQf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jan 2010 20:16:35 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=eHh6uhKDkSKiKMk7zudJ881AxsmyAhIiUVIrnE3S1d7rM4eKw/LQ6Qe421cglg31ni
         yhrlZKe6UXs3Lw8eLABKslqUUaCe65fF/g1g7JqiV8VTYOcgaWVHT2/V1LqDTORlrgJ8
         h9eggxF/Lqyu1DawEa3PraMuHOxhv+HGZLTFg=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>, Lai Jiangshan <laijs@cn.fujitsu.com>,
       Steven Rostedt <rostedt@goodmis.org>, Li Zefan <lizf@cn.fujitsu.com>,
       Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH 08/10] tracing: Simplify test for function_graph tracing
Date: Fri, 22 Jan 2010 02:16:20 +0100
Message-Id: <1264122982-1553-9-git-send-regression-fweisbec@gmail.com>
X-Mailer: git-send-email 1.6.2.3
In-Reply-To: <1264122982-1553-1-git-send-regression-fweisbec@gmail.com>
References: <1264122982-1553-1-git-send-regression-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Lai Jiangshan <laijs@cn.fujitsu.com>

For function_graph, a calling function is to be traced only when
it is enabled or it is nested in a enabled function.

Current code uses TSK_TRACE_FL_GRAPH to test whether it is nested
or not. Looking at the code, we can get this:
(trace->depth > 0) <==> (TSK_TRACE_FL_GRAPH is set)

trace->depth is more explicit to tell that it is nested.
So we use trace->depth directly and simplify the code.

No functionality is changed.
TSK_TRACE_FL_GRAPH is not removed now, it is left for future usage.

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Li Zefan <lizf@cn.fujitsu.com>
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
-- 
1.6.2.3

