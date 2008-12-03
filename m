Return-Path: <linux-kernel-owner+w=401wt.eu-S1756246AbYLCEwd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756246AbYLCEwd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2008 23:52:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753767AbYLCEut
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Dec 2008 23:50:49 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:63726 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752975AbYLCEup (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2008 23:50:45 -0500
Message-Id: <20081203045044.002248353@goodmis.org>
References: <20081203045001.367443457@goodmis.org>
User-Agent: quilt/0.46-1
Date: Tue, 02 Dec 2008 23:50:05 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Steven Rostedt <srostedt@redhat.com>
Subject: [PATCH 4/5] ftrace: function graph return for function entry
Content-Disposition: inline; filename=0004-ftrace-function-graph-return-for-function-entry.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

Impact: feature, let entry function decide to trace or not

This patch lets the graph tracer entry function decide if the tracing
should be done at the end as well. This requires all function graph
entry functions return 1 if it should trace, or 0 if the return should
not be traced.

Signed-off-by: Steven Rostedt <srostedt@redhat.com>
---
 arch/x86/kernel/entry_32.S |    3 +++
 arch/x86/kernel/entry_64.S |    3 +++
 arch/x86/kernel/ftrace.c   |    7 ++++++-
 include/linux/ftrace.h     |    2 +-
 kernel/trace/ftrace.c      |   10 +++++++---
 kernel/trace/trace.c       |    4 +++-
 kernel/trace/trace.h       |    2 +-
 7 files changed, 24 insertions(+), 7 deletions(-)

diff --git a/arch/x86/kernel/entry_32.S b/arch/x86/kernel/entry_32.S
index 3497321..d6f0490 100644
--- a/arch/x86/kernel/entry_32.S
+++ b/arch/x86/kernel/entry_32.S
@@ -993,6 +993,9 @@ ENTRY(mcount)
 #ifdef CONFIG_FUNCTION_GRAPH_TRACER
 	cmpl $ftrace_stub, ftrace_graph_return
 	jnz ftrace_graph_caller
+
+	cmpl $ftrace_graph_entry_stub, ftrace_graph_entry
+	jnz ftrace_graph_caller
 #endif
 .globl ftrace_stub
 ftrace_stub:
diff --git a/arch/x86/kernel/entry_64.S b/arch/x86/kernel/entry_64.S
index 47aa5f0..cef05a2 100644
--- a/arch/x86/kernel/entry_64.S
+++ b/arch/x86/kernel/entry_64.S
@@ -119,6 +119,9 @@ ENTRY(mcount)
 #ifdef CONFIG_FUNCTION_GRAPH_TRACER
 	cmpq $ftrace_stub, ftrace_graph_return
 	jnz ftrace_graph_caller
+
+	cmpq $ftrace_graph_entry_stub, ftrace_graph_entry
+	jnz ftrace_graph_caller
 #endif
 
 .globl ftrace_stub
diff --git a/arch/x86/kernel/ftrace.c b/arch/x86/kernel/ftrace.c
index adba8e9..d278ad2 100644
--- a/arch/x86/kernel/ftrace.c
+++ b/arch/x86/kernel/ftrace.c
@@ -425,6 +425,7 @@ static void pop_return_trace(struct ftrace_graph_ret *trace, unsigned long *ret)
 	trace->calltime = current->ret_stack[index].calltime;
 	trace->overrun = atomic_read(&current->trace_overrun);
 	trace->depth = index;
+	barrier();
 	current->curr_ret_stack--;
 }
 
@@ -506,7 +507,11 @@ void prepare_ftrace_return(unsigned long *parent, unsigned long self_addr)
 	}
 
 	trace.func = self_addr;
-	ftrace_graph_entry(&trace);
 
+	/* Only trace if the calling function expects to */
+	if (!ftrace_graph_entry(&trace)) {
+		current->curr_ret_stack--;
+		*parent = old;
+	}
 }
 #endif /* CONFIG_FUNCTION_GRAPH_TRACER */
diff --git a/include/linux/ftrace.h b/include/linux/ftrace.h
index 58ca1c3..469ceb3 100644
--- a/include/linux/ftrace.h
+++ b/include/linux/ftrace.h
@@ -371,7 +371,7 @@ struct ftrace_graph_ret {
 #define FTRACE_RETSTACK_ALLOC_SIZE 32
 /* Type of the callback handlers for tracing function graph*/
 typedef void (*trace_func_graph_ret_t)(struct ftrace_graph_ret *); /* return */
-typedef void (*trace_func_graph_ent_t)(struct ftrace_graph_ent *); /* entry */
+typedef int (*trace_func_graph_ent_t)(struct ftrace_graph_ent *); /* entry */
 
 extern int register_ftrace_graph(trace_func_graph_ret_t retfunc,
 				trace_func_graph_ent_t entryfunc);
diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
index a44af05..65b9e86 100644
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -1636,11 +1636,15 @@ ftrace_enable_sysctl(struct ctl_table *table, int write,
 
 static atomic_t ftrace_graph_active;
 
+int ftrace_graph_entry_stub(struct ftrace_graph_ent *trace)
+{
+	return 0;
+}
+
 /* The callbacks that hook a function */
 trace_func_graph_ret_t ftrace_graph_return =
 			(trace_func_graph_ret_t)ftrace_stub;
-trace_func_graph_ent_t ftrace_graph_entry =
-			(trace_func_graph_ent_t)ftrace_stub;
+trace_func_graph_ent_t ftrace_graph_entry = ftrace_graph_entry_stub;
 
 /* Try to assign a return stack array on FTRACE_RETSTACK_ALLOC_SIZE tasks. */
 static int alloc_retstack_tasklist(struct ftrace_ret_stack **ret_stack_list)
@@ -1738,7 +1742,7 @@ void unregister_ftrace_graph(void)
 
 	atomic_dec(&ftrace_graph_active);
 	ftrace_graph_return = (trace_func_graph_ret_t)ftrace_stub;
-	ftrace_graph_entry = (trace_func_graph_ent_t)ftrace_stub;
+	ftrace_graph_entry = ftrace_graph_entry_stub;
 	ftrace_shutdown(FTRACE_STOP_FUNC_RET);
 
 	mutex_unlock(&ftrace_sysctl_lock);
diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index 380de63..8b6409a 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -1200,7 +1200,7 @@ function_trace_call(unsigned long ip, unsigned long parent_ip)
 }
 
 #ifdef CONFIG_FUNCTION_GRAPH_TRACER
-void trace_graph_entry(struct ftrace_graph_ent *trace)
+int trace_graph_entry(struct ftrace_graph_ent *trace)
 {
 	struct trace_array *tr = &global_trace;
 	struct trace_array_cpu *data;
@@ -1219,6 +1219,8 @@ void trace_graph_entry(struct ftrace_graph_ent *trace)
 	}
 	atomic_dec(&data->disabled);
 	local_irq_restore(flags);
+
+	return 1;
 }
 
 void trace_graph_return(struct ftrace_graph_ret *trace)
diff --git a/kernel/trace/trace.h b/kernel/trace/trace.h
index f96f4e7..0565ae9 100644
--- a/kernel/trace/trace.h
+++ b/kernel/trace/trace.h
@@ -412,7 +412,7 @@ void trace_function(struct trace_array *tr,
 		    unsigned long flags, int pc);
 
 void trace_graph_return(struct ftrace_graph_ret *trace);
-void trace_graph_entry(struct ftrace_graph_ent *trace);
+int trace_graph_entry(struct ftrace_graph_ent *trace);
 void trace_bts(struct trace_array *tr,
 	       unsigned long from,
 	       unsigned long to);
-- 
1.5.6.5

-- 
