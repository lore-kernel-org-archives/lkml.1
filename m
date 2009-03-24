Return-Path: <linux-kernel-owner+w=401wt.eu-S1755546AbZCXN4h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755546AbZCXN4h (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Mar 2009 09:56:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754507AbZCXN4N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Mar 2009 09:56:13 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:40453 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753941AbZCXN4M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Mar 2009 09:56:12 -0400
Message-Id: <20090324135610.027400816@goodmis.org>
References: <20090324135422.026619569@goodmis.org>
User-Agent: quilt/0.46-1
Date: Tue, 24 Mar 2009 09:54:23 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Steven Rostedt <srostedt@redhat.com>
Subject: [PATCH 1/3] function-graph: moved the timestamp from arch to generic code
Content-Disposition: inline; filename=0001-function-graph-moved-the-timestamp-from-arch-to-gen.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

This patch move the timestamp from happening in the arch specific
code into the general code. This allows for better control by the tracer
to time manipulation.

Signed-off-by: Steven Rostedt <srostedt@redhat.com>
---
 arch/x86/kernel/ftrace.c             |    6 +-----
 include/linux/ftrace.h               |    3 +--
 kernel/trace/trace_functions_graph.c |    8 +++++---
 3 files changed, 7 insertions(+), 10 deletions(-)

diff --git a/arch/x86/kernel/ftrace.c b/arch/x86/kernel/ftrace.c
index 57b33ed..61df775 100644
--- a/arch/x86/kernel/ftrace.c
+++ b/arch/x86/kernel/ftrace.c
@@ -410,7 +410,6 @@ int ftrace_disable_ftrace_graph_caller(void)
 void prepare_ftrace_return(unsigned long *parent, unsigned long self_addr)
 {
 	unsigned long old;
-	unsigned long long calltime;
 	int faulted;
 	struct ftrace_graph_ent trace;
 	unsigned long return_hooker = (unsigned long)
@@ -453,10 +452,7 @@ void prepare_ftrace_return(unsigned long *parent, unsigned long self_addr)
 		return;
 	}
 
-	calltime = trace_clock_local();
-
-	if (ftrace_push_return_trace(old, calltime,
-				self_addr, &trace.depth) == -EBUSY) {
+	if (ftrace_push_return_trace(old, self_addr, &trace.depth) == -EBUSY) {
 		*parent = old;
 		return;
 	}
diff --git a/include/linux/ftrace.h b/include/linux/ftrace.h
index db3fed6..1141248 100644
--- a/include/linux/ftrace.h
+++ b/include/linux/ftrace.h
@@ -369,8 +369,7 @@ struct ftrace_ret_stack {
 extern void return_to_handler(void);
 
 extern int
-ftrace_push_return_trace(unsigned long ret, unsigned long long time,
-			 unsigned long func, int *depth);
+ftrace_push_return_trace(unsigned long ret, unsigned long func, int *depth);
 extern void
 ftrace_pop_return_trace(struct ftrace_graph_ret *trace, unsigned long *ret);
 
diff --git a/kernel/trace/trace_functions_graph.c b/kernel/trace/trace_functions_graph.c
index e876816..d28687e 100644
--- a/kernel/trace/trace_functions_graph.c
+++ b/kernel/trace/trace_functions_graph.c
@@ -57,9 +57,9 @@ static struct tracer_flags tracer_flags = {
 
 /* Add a function return address to the trace stack on thread info.*/
 int
-ftrace_push_return_trace(unsigned long ret, unsigned long long time,
-			 unsigned long func, int *depth)
+ftrace_push_return_trace(unsigned long ret, unsigned long func, int *depth)
 {
+	unsigned long long calltime;
 	int index;
 
 	if (!current->ret_stack)
@@ -71,11 +71,13 @@ ftrace_push_return_trace(unsigned long ret, unsigned long long time,
 		return -EBUSY;
 	}
 
+	calltime = trace_clock_local();
+
 	index = ++current->curr_ret_stack;
 	barrier();
 	current->ret_stack[index].ret = ret;
 	current->ret_stack[index].func = func;
-	current->ret_stack[index].calltime = time;
+	current->ret_stack[index].calltime = calltime;
 	*depth = index;
 
 	return 0;
-- 
1.6.2

-- 
