Return-Path: <linux-kernel-owner+w=401wt.eu-S1756596AbZCEBBB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756596AbZCEBBB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Mar 2009 20:01:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750972AbZCEBAu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Mar 2009 20:00:50 -0500
Received: from ey-out-2122.google.com ([74.125.78.26]:18020 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754850AbZCEBAt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Mar 2009 20:00:49 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:from:date:subject:to:cc;
        b=flExjWihDDSA85OipO8RByho12qFd1ECTS2PlMwShd9PifyV011N1Av10B+3wfChzV
         Lq2cOjqv1HLhIbAtDUeG/lnUN/lytUE7LAnUSUlm46T2SaKKQQ69VkaAUgBsRQcweP8m
         8f+xLZLMkyTTwP9WhPDwtphG+Kvsyl/bneOU0=
Message-ID: <49af243d.06e9300a.53ad.ffff840c@mx.google.com>
From: Frederic Weisbecker <fweisbec@gmail.com>
Date: Thu, 5 Mar 2009 01:49:22 +0100
Subject: [PATCH 2/2] tracing/function-graph-tracer: use the more lightweight local clock
To: Ingo Molnar <mingo@elte.hu>
Cc: Steven Rostedt <rostedt@goodmis.org>,
       Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: decrease hangs risks with the graph tracer on slow systems

Since the function graph tracer can spend too much time on timer interrupts,
it's better now to use the more lightweight local clock. Anyway, the function graph
traces are more reliable on a per cpu trace.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
---
 arch/x86/kernel/ftrace.c             |    2 +-
 kernel/trace/trace_functions_graph.c |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/ftrace.c b/arch/x86/kernel/ftrace.c
index 3925ec0..40960c2 100644
--- a/arch/x86/kernel/ftrace.c
+++ b/arch/x86/kernel/ftrace.c
@@ -436,7 +436,7 @@ void prepare_ftrace_return(unsigned long *parent, unsigned long self_addr)
 		return;
 	}
 
-	calltime = cpu_clock(raw_smp_processor_id());
+	calltime = sched_clock();
 
 	if (ftrace_push_return_trace(old, calltime,
 				self_addr, &trace.depth) == -EBUSY) {
diff --git a/kernel/trace/trace_functions_graph.c b/kernel/trace/trace_functions_graph.c
index 2461732..c5038f4 100644
--- a/kernel/trace/trace_functions_graph.c
+++ b/kernel/trace/trace_functions_graph.c
@@ -112,7 +112,7 @@ unsigned long ftrace_return_to_handler(void)
 	unsigned long ret;
 
 	ftrace_pop_return_trace(&trace, &ret);
-	trace.rettime = cpu_clock(raw_smp_processor_id());
+	trace.rettime = sched_clock();
 	ftrace_graph_return(&trace);
 
 	if (unlikely(!ret)) {
-- 
1.6.1


