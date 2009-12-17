Return-Path: <linux-kernel-owner+w=401wt.eu-S936672AbZLQEl2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936672AbZLQEl2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Dec 2009 23:41:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761118AbZLQEkx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Dec 2009 23:40:53 -0500
Received: from mail-ew0-f219.google.com ([209.85.219.219]:47642 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763987AbZLQEkp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Dec 2009 23:40:45 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=bUq0lUKV0hkeKaReUqghITeYFwrB4JVQnKugtyfNbBmG05tvrnKkRNScPBchrrgO5F
         YxlLtx+18kWDf8JGUuR49BCfa593dvGi0Z29E/FrxQaqnaTvKIavqBgEGXlvcxWFuDtb
         2ATPw1CiJ0FEHk05vvt1+rS/ZnL0RTL2AYPsE=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Peter Zijlstra <peterz@infradead.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Paul Mackerras <paulus@samba.org>
Subject: [PATCH 1/2] x86/stacktrace: Make stack walking tunable
Date: Thu, 17 Dec 2009 05:40:33 +0100
Message-Id: <1261024834-5336-1-git-send-regression-fweisbec@gmail.com>
X-Mailer: git-send-email 1.6.2.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(Tested in x86-64 only)

The current print_context_stack helper that does the stack
walking job is good for usual stacktraces as it walks through
all the stack and reports even addresses that look unreliable,
which is nice when we don't have frame pointers for example.

But we have users like perf that only require reliable stacktraces,
and those may want a more adapted stack walker, so lets make this
function a callback in stacktrace_ops that users can tune for their
needs.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Paul Mackerras <paulus@samba.org>
---
 arch/x86/include/asm/stacktrace.h |   18 ++++++++++++++++++
 arch/x86/kernel/cpu/perf_event.c  |    1 +
 arch/x86/kernel/dumpstack.c       |    9 +++++----
 arch/x86/kernel/dumpstack.h       |    6 ------
 arch/x86/kernel/dumpstack_32.c    |    2 +-
 arch/x86/kernel/dumpstack_64.c    |    4 ++--
 arch/x86/kernel/stacktrace.c      |   18 ++++++++++--------
 arch/x86/oprofile/backtrace.c     |    9 +++++----
 kernel/trace/trace_sysprof.c      |    1 +
 9 files changed, 43 insertions(+), 25 deletions(-)

diff --git a/arch/x86/include/asm/stacktrace.h b/arch/x86/include/asm/stacktrace.h
index cf86a5e..6c75151 100644
--- a/arch/x86/include/asm/stacktrace.h
+++ b/arch/x86/include/asm/stacktrace.h
@@ -5,6 +5,23 @@ extern int kstack_depth_to_print;
 
 int x86_is_stack_id(int id, char *name);
 
+struct thread_info;
+struct stacktrace_ops;
+
+typedef unsigned long (*walk_stack_t)(struct thread_info *tinfo,
+				      unsigned long *stack,
+				      unsigned long bp,
+				      const struct stacktrace_ops *ops,
+				      void *data,
+				      unsigned long *end,
+				      int *graph);
+
+extern unsigned long
+print_context_stack(struct thread_info *tinfo,
+		    unsigned long *stack, unsigned long bp,
+		    const struct stacktrace_ops *ops, void *data,
+		    unsigned long *end, int *graph);
+
 /* Generic stack tracer with callbacks */
 
 struct stacktrace_ops {
@@ -14,6 +31,7 @@ struct stacktrace_ops {
 	void (*address)(void *data, unsigned long address, int reliable);
 	/* On negative return stop dumping */
 	int (*stack)(void *data, char *name);
+	walk_stack_t	walk_stack;
 };
 
 void dump_trace(struct task_struct *tsk, struct pt_regs *regs,
diff --git a/arch/x86/kernel/cpu/perf_event.c b/arch/x86/kernel/cpu/perf_event.c
index 45506d5..d3802ee 100644
--- a/arch/x86/kernel/cpu/perf_event.c
+++ b/arch/x86/kernel/cpu/perf_event.c
@@ -2336,6 +2336,7 @@ static const struct stacktrace_ops backtrace_ops = {
 	.warning_symbol		= backtrace_warning_symbol,
 	.stack			= backtrace_stack,
 	.address		= backtrace_address,
+	.walk_stack		= print_context_stack,
 };
 
 #include "../dumpstack.h"
diff --git a/arch/x86/kernel/dumpstack.c b/arch/x86/kernel/dumpstack.c
index 0a0aa1c..8aaa119 100644
--- a/arch/x86/kernel/dumpstack.c
+++ b/arch/x86/kernel/dumpstack.c
@@ -141,10 +141,11 @@ static void print_trace_address(void *data, unsigned long addr, int reliable)
 }
 
 static const struct stacktrace_ops print_trace_ops = {
-	.warning = print_trace_warning,
-	.warning_symbol = print_trace_warning_symbol,
-	.stack = print_trace_stack,
-	.address = print_trace_address,
+	.warning		= print_trace_warning,
+	.warning_symbol		= print_trace_warning_symbol,
+	.stack 			= print_trace_stack,
+	.address 		= print_trace_address,
+	.walk_stack		= print_context_stack,
 };
 
 void
diff --git a/arch/x86/kernel/dumpstack.h b/arch/x86/kernel/dumpstack.h
index 81086c2..4fd1420 100644
--- a/arch/x86/kernel/dumpstack.h
+++ b/arch/x86/kernel/dumpstack.h
@@ -14,12 +14,6 @@
 #define get_bp(bp) asm("movq %%rbp, %0" : "=r" (bp) :)
 #endif
 
-extern unsigned long
-print_context_stack(struct thread_info *tinfo,
-		unsigned long *stack, unsigned long bp,
-		const struct stacktrace_ops *ops, void *data,
-		unsigned long *end, int *graph);
-
 extern void
 show_trace_log_lvl(struct task_struct *task, struct pt_regs *regs,
 		unsigned long *stack, unsigned long bp, char *log_lvl);
diff --git a/arch/x86/kernel/dumpstack_32.c b/arch/x86/kernel/dumpstack_32.c
index e0ed4c7..ae775ca 100644
--- a/arch/x86/kernel/dumpstack_32.c
+++ b/arch/x86/kernel/dumpstack_32.c
@@ -58,7 +58,7 @@ void dump_trace(struct task_struct *task, struct pt_regs *regs,
 
 		context = (struct thread_info *)
 			((unsigned long)stack & (~(THREAD_SIZE - 1)));
-		bp = print_context_stack(context, stack, bp, ops, data, NULL, &graph);
+		bp = ops->walk_stack(context, stack, bp, ops, data, NULL, &graph);
 
 		stack = (unsigned long *)context->previous_esp;
 		if (!stack)
diff --git a/arch/x86/kernel/dumpstack_64.c b/arch/x86/kernel/dumpstack_64.c
index b13af53..0ad9597 100644
--- a/arch/x86/kernel/dumpstack_64.c
+++ b/arch/x86/kernel/dumpstack_64.c
@@ -188,8 +188,8 @@ void dump_trace(struct task_struct *task, struct pt_regs *regs,
 			if (ops->stack(data, id) < 0)
 				break;
 
-			bp = print_context_stack(tinfo, stack, bp, ops,
-						 data, estack_end, &graph);
+			bp = ops->walk_stack(tinfo, stack, bp, ops,
+					     data, estack_end, &graph);
 			ops->stack(data, "<EOE>");
 			/*
 			 * We link to the next stack via the
diff --git a/arch/x86/kernel/stacktrace.c b/arch/x86/kernel/stacktrace.c
index c3eb207..922eefb 100644
--- a/arch/x86/kernel/stacktrace.c
+++ b/arch/x86/kernel/stacktrace.c
@@ -53,17 +53,19 @@ save_stack_address_nosched(void *data, unsigned long addr, int reliable)
 }
 
 static const struct stacktrace_ops save_stack_ops = {
-	.warning = save_stack_warning,
-	.warning_symbol = save_stack_warning_symbol,
-	.stack = save_stack_stack,
-	.address = save_stack_address,
+	.warning	= save_stack_warning,
+	.warning_symbol	= save_stack_warning_symbol,
+	.stack		= save_stack_stack,
+	.address	= save_stack_address,
+	.walk_stack	= print_context_stack,
 };
 
 static const struct stacktrace_ops save_stack_ops_nosched = {
-	.warning = save_stack_warning,
-	.warning_symbol = save_stack_warning_symbol,
-	.stack = save_stack_stack,
-	.address = save_stack_address_nosched,
+	.warning	= save_stack_warning,
+	.warning_symbol	= save_stack_warning_symbol,
+	.stack		= save_stack_stack,
+	.address	= save_stack_address_nosched,
+	.walk_stack	= print_context_stack,
 };
 
 /*
diff --git a/arch/x86/oprofile/backtrace.c b/arch/x86/oprofile/backtrace.c
index 044897b..3855096 100644
--- a/arch/x86/oprofile/backtrace.c
+++ b/arch/x86/oprofile/backtrace.c
@@ -41,10 +41,11 @@ static void backtrace_address(void *data, unsigned long addr, int reliable)
 }
 
 static struct stacktrace_ops backtrace_ops = {
-	.warning = backtrace_warning,
-	.warning_symbol = backtrace_warning_symbol,
-	.stack = backtrace_stack,
-	.address = backtrace_address,
+	.warning	= backtrace_warning,
+	.warning_symbol	= backtrace_warning_symbol,
+	.stack		= backtrace_stack,
+	.address	= backtrace_address,
+	.walk_stack	= print_context_stack,
 };
 
 struct frame_head {
diff --git a/kernel/trace/trace_sysprof.c b/kernel/trace/trace_sysprof.c
index f669396..a7974a5 100644
--- a/kernel/trace/trace_sysprof.c
+++ b/kernel/trace/trace_sysprof.c
@@ -93,6 +93,7 @@ static const struct stacktrace_ops backtrace_ops = {
 	.warning_symbol		= backtrace_warning_symbol,
 	.stack			= backtrace_stack,
 	.address		= backtrace_address,
+	.walk_stack		= print_context_stack,
 };
 
 static int
-- 
1.6.2.3

