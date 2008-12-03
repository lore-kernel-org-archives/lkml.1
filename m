Return-Path: <linux-kernel-owner+w=401wt.eu-S1756150AbYLCEwQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756150AbYLCEwQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2008 23:52:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754015AbYLCEus
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Dec 2008 23:50:48 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:63723 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752928AbYLCEup (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2008 23:50:45 -0500
Message-Id: <20081203045043.769665847@goodmis.org>
References: <20081203045001.367443457@goodmis.org>
User-Agent: quilt/0.46-1
Date: Tue, 02 Dec 2008 23:50:04 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Steven Rostedt <srostedt@redhat.com>
Subject: [PATCH 3/5] ftrace: print real return in dumpstack for function graph
Content-Disposition: inline; filename=0003-ftrace-print-real-return-in-dumpstack-for-function.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

Impact: better dumpstack output

I noticed in my crash dumps and even in the stack tracer that a
lot of functions listed in the stack trace are simply
return_to_handler which is ftrace graphs way to insert its own
call into the return of a function. But we lose out where
the actually function was called from.

This patch adds in hooks to the dumpstack mechanism that detects
this and finds the real function to print. Both are printed to
let the user know that a hook is still in place.

This does give a funny side effect in the stack tracer output:

        Depth   Size      Location    (80 entries)
        -----   ----      --------
  0)     4144      48   save_stack_trace+0x2f/0x4d
  1)     4096     128   ftrace_call+0x5/0x2b
  2)     3968      16   mempool_alloc_slab+0x16/0x18
  3)     3952     384   return_to_handler+0x0/0x73
  4)     3568    -240   stack_trace_call+0x11d/0x209
  5)     3808     144   return_to_handler+0x0/0x73
  6)     3664    -128   mempool_alloc+0x4d/0xfe
  7)     3792     128   return_to_handler+0x0/0x73
  8)     3664     -32   scsi_sg_alloc+0x48/0x4a [scsi_mod]

As you can see, the real functions are now negative. This is due
to them not being found inside the stack.

Signed-off-by: Steven Rostedt <srostedt@redhat.com>
---
 arch/x86/kernel/dumpstack.c    |   34 +++++++++++++++++++++++++++++++++-
 arch/x86/kernel/dumpstack.h    |    2 +-
 arch/x86/kernel/dumpstack_32.c |    5 ++++-
 arch/x86/kernel/dumpstack_64.c |    7 ++++---
 4 files changed, 42 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kernel/dumpstack.c b/arch/x86/kernel/dumpstack.c
index 5962176..6b1f6f6 100644
--- a/arch/x86/kernel/dumpstack.c
+++ b/arch/x86/kernel/dumpstack.c
@@ -30,6 +30,37 @@ void printk_address(unsigned long address, int reliable)
 			reliable ? "" : "? ", (void *) address);
 }
 
+#ifdef CONFIG_FUNCTION_GRAPH_TRACER
+static void
+print_ftrace_graph_addr(unsigned long addr, void *data,
+			const struct stacktrace_ops *ops,
+			struct thread_info *tinfo, int *graph)
+{
+	struct task_struct *task = tinfo->task;
+	unsigned long ret_addr;
+	int index = task->curr_ret_stack;
+
+	if (addr != (unsigned long)return_to_handler)
+		return;
+
+	if (!task->ret_stack || index < *graph)
+		return;
+
+	index -= *graph;
+	ret_addr = task->ret_stack[index].ret;
+
+	ops->address(data, ret_addr, 1);
+
+	(*graph)++;
+}
+#else
+static inline void
+print_ftrace_graph_addr(unsigned long addr, void *data,
+			const struct stacktrace_ops *ops,
+			struct thread_info *tinfo, int *graph)
+{ }
+#endif
+
 /*
  * x86-64 can have up to three kernel stacks:
  * process stack
@@ -54,7 +85,7 @@ unsigned long
 print_context_stack(struct thread_info *tinfo,
 		unsigned long *stack, unsigned long bp,
 		const struct stacktrace_ops *ops, void *data,
-		unsigned long *end)
+		unsigned long *end, int *graph)
 {
 	struct stack_frame *frame = (struct stack_frame *)bp;
 
@@ -70,6 +101,7 @@ print_context_stack(struct thread_info *tinfo,
 			} else {
 				ops->address(data, addr, bp == 0);
 			}
+			print_ftrace_graph_addr(addr, data, ops, tinfo, graph);
 		}
 		stack++;
 	}
diff --git a/arch/x86/kernel/dumpstack.h b/arch/x86/kernel/dumpstack.h
index 3119a80..da87590 100644
--- a/arch/x86/kernel/dumpstack.h
+++ b/arch/x86/kernel/dumpstack.h
@@ -18,7 +18,7 @@ extern unsigned long
 print_context_stack(struct thread_info *tinfo,
 		unsigned long *stack, unsigned long bp,
 		const struct stacktrace_ops *ops, void *data,
-		unsigned long *end);
+		unsigned long *end, int *graph);
 
 extern void
 show_trace_log_lvl(struct task_struct *task, struct pt_regs *regs,
diff --git a/arch/x86/kernel/dumpstack_32.c b/arch/x86/kernel/dumpstack_32.c
index 7b031b1..d593cd1 100644
--- a/arch/x86/kernel/dumpstack_32.c
+++ b/arch/x86/kernel/dumpstack_32.c
@@ -23,6 +23,8 @@ void dump_trace(struct task_struct *task, struct pt_regs *regs,
 		unsigned long *stack, unsigned long bp,
 		const struct stacktrace_ops *ops, void *data)
 {
+	int graph = 0;
+
 	if (!task)
 		task = current;
 
@@ -50,7 +52,8 @@ void dump_trace(struct task_struct *task, struct pt_regs *regs,
 
 		context = (struct thread_info *)
 			((unsigned long)stack & (~(THREAD_SIZE - 1)));
-		bp = print_context_stack(context, stack, bp, ops, data, NULL);
+		bp = print_context_stack(context, stack, bp, ops,
+					 data, NULL, &graph);
 
 		stack = (unsigned long *)context->previous_esp;
 		if (!stack)
diff --git a/arch/x86/kernel/dumpstack_64.c b/arch/x86/kernel/dumpstack_64.c
index 33ff102..c302d07 100644
--- a/arch/x86/kernel/dumpstack_64.c
+++ b/arch/x86/kernel/dumpstack_64.c
@@ -109,6 +109,7 @@ void dump_trace(struct task_struct *task, struct pt_regs *regs,
 	unsigned long *irqstack_end = (unsigned long *)cpu_pda(cpu)->irqstackptr;
 	unsigned used = 0;
 	struct thread_info *tinfo;
+	int graph = 0;
 
 	if (!task)
 		task = current;
@@ -149,7 +150,7 @@ void dump_trace(struct task_struct *task, struct pt_regs *regs,
 				break;
 
 			bp = print_context_stack(tinfo, stack, bp, ops,
-							data, estack_end);
+						 data, estack_end, &graph);
 			ops->stack(data, "<EOE>");
 			/*
 			 * We link to the next stack via the
@@ -168,7 +169,7 @@ void dump_trace(struct task_struct *task, struct pt_regs *regs,
 				if (ops->stack(data, "IRQ") < 0)
 					break;
 				bp = print_context_stack(tinfo, stack, bp,
-						ops, data, irqstack_end);
+					ops, data, irqstack_end, &graph);
 				/*
 				 * We link to the next stack (which would be
 				 * the process stack normally) the last
@@ -186,7 +187,7 @@ void dump_trace(struct task_struct *task, struct pt_regs *regs,
 	/*
 	 * This handles the process stack:
 	 */
-	bp = print_context_stack(tinfo, stack, bp, ops, data, NULL);
+	bp = print_context_stack(tinfo, stack, bp, ops, data, NULL, &graph);
 	put_cpu();
 }
 EXPORT_SYMBOL(dump_trace);
-- 
1.5.6.5

-- 
