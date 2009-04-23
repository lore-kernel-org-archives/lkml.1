Return-Path: <linux-kernel-owner+w=401wt.eu-S1759057AbZDWSgr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759057AbZDWSgr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Apr 2009 14:36:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753355AbZDWSgh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Apr 2009 14:36:37 -0400
Received: from va3ehsobe001.messaging.microsoft.com ([216.32.180.11]:26669
	"EHLO VA3EHSOBE001.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752003AbZDWSgg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Apr 2009 14:36:36 -0400
X-BigFish: VPS-12(zz936eQ1469Kzz1202hzzz2fh6bh61h)
X-Spam-TCS-SCL: 0:0
X-FB-SS: 5,
Message-ID: <49F0B4FE.8070107@am.sony.com>
Date: Thu, 23 Apr 2009 11:35:42 -0700
From: Tim Bird <tim.bird@am.sony.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: linux kernel <linux-kernel@vger.kernel.org>
CC: linux-arm-kernel <linux-arm-kernel@lists.arm.linux.org.uk>,
       Steven Rostedt <rostedt@goodmis.org>,
       =?ISO-8859-1?Q?Uwe_Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>,
       Ingo Molnar <mingo@redhat.com>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Russell King <rmk@arm.linux.org.uk>
Subject: [PATCH] Add function graph tracer support for ARM (resend)
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 23 Apr 2009 18:35:43.0261 (UTC) FILETIME=[4F363CD0:01C9C442]
X-SEL-encryption-scan: scanned
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

My first post of this wasn't wide enough. Now adding the
linux-arm-kernel list and a few more CC:s.  Sorry if you
get this twice.

Add ftrace function-graph tracer support for ARM.

This includes adding code in mcount to check for
(and call) a registered function graph trace entry
routine, and adding infrastructure to the threadinfo
structure to support a return trampoline.

I wrote a separate program to scan the kernel assembly
output and validate that callframes for mcount are
generated properly. (It's available upon request for
anyone interested.)

Much of the code in arch/arm/kernel/ftrace.c was
cloned from arch/x86/kernel/ftrace.c

IRQENTRY_TEXT was added to vmlinux.lds.S (to eliminate
a compiler error on kernel/trace/trace_functions_graph.c),
although no routines were marked as __irq_entry.

FIXTHIS indicates questions or areas of uncertainty.

This works for me with a gcc 4.1.1 compiler (EABI with
frame pointers turned on) on an OMAP OSK board, with
kernel 2.6.29.

The use of "already_here" works around trace entry nesting
(I believe due to instrumentation of either cpu_clock or
raw_smp_processor_id).  Advice on the best way to deal
with this would be appreciated.  (that is, whether
to use the guard variable, or just un-instrument the
offending routines).

Thanks for any feedback.

Signed-off-by: <tim.bird@am.sony.com>
---
 arch/arm/Kconfig               |    1
 arch/arm/include/asm/ftrace.h  |   28 +++++++
 arch/arm/kernel/Makefile       |    3
 arch/arm/kernel/entry-common.S |   29 +++++++-
 arch/arm/kernel/ftrace.c       |  146 +++++++++++++++++++++++++++++++++++++++++
 arch/arm/kernel/vmlinux.lds.S  |    1
 6 files changed, 204 insertions(+), 4 deletions(-)

--- a/arch/arm/Kconfig
+++ b/arch/arm/Kconfig
@@ -17,6 +17,7 @@ config ARM
 	select HAVE_KPROBES if (!XIP_KERNEL)
 	select HAVE_KRETPROBES if (HAVE_KPROBES)
 	select HAVE_FUNCTION_TRACER if (!XIP_KERNEL)
+	select HAVE_FUNCTION_GRAPH_TRACER if (!XIP_KERNEL)
 	select HAVE_GENERIC_DMA_COHERENT
 	help
 	  The ARM series is a line of low-power-consumption RISC chip designs
--- a/arch/arm/include/asm/ftrace.h
+++ b/arch/arm/include/asm/ftrace.h
@@ -7,8 +7,32 @@

 #ifndef __ASSEMBLY__
 extern void mcount(void);
-#endif
+#endif /* __ASSEMBLY__ */

-#endif
+#endif /* CONFIG_FUNCTION_TRACER */
+
+#ifdef CONFIG_FUNCTION_GRAPH_TRACER
+
+#ifndef __ASSEMBLY__
+
+/*
+ * Stack of return addresses for functions of a thread.
+ * Used in struct thread_info
+ */
+struct ftrace_ret_stack {
+	unsigned long ret;
+	unsigned long func;
+	unsigned long long calltime;
+};
+
+/*
+ * Primary handler of a function return.
+ * It relays on ftrace_return_to_handler.
+ * Defined in entry-common.S
+ */
+extern void return_to_handler(void);
+
+#endif /* __ASSEMBLY__ */
+#endif /* CONFIG_FUNCTION_GRAPH_TRACER */

 #endif /* _ASM_ARM_FTRACE */
--- a/arch/arm/kernel/Makefile
+++ b/arch/arm/kernel/Makefile
@@ -4,7 +4,7 @@

 AFLAGS_head.o := -DTEXT_OFFSET=$(TEXT_OFFSET)

-ifdef CONFIG_DYNAMIC_FTRACE
+ifdef CONFIG_FUNCTION_TRACER
 CFLAGS_REMOVE_ftrace.o = -pg
 endif

@@ -23,6 +23,7 @@ obj-$(CONFIG_ISA_DMA)		+= dma-isa.o
 obj-$(CONFIG_PCI)		+= bios32.o isa.o
 obj-$(CONFIG_SMP)		+= smp.o
 obj-$(CONFIG_DYNAMIC_FTRACE)	+= ftrace.o
+obj-$(CONFIG_FUNCTION_GRAPH_TRACER)	+= ftrace.o
 obj-$(CONFIG_KEXEC)		+= machine_kexec.o relocate_kernel.o
 obj-$(CONFIG_KPROBES)		+= kprobes.o kprobes-decode.o
 obj-$(CONFIG_ATAGS_PROC)	+= atags.o
--- a/arch/arm/kernel/entry-common.S
+++ b/arch/arm/kernel/entry-common.S
@@ -135,8 +135,16 @@ ENTRY(mcount)
 	adr r0, ftrace_stub
 	cmp r0, r2
 	bne trace
+
+#ifdef CONFIG_FUNCTION_GRAPH_TRACER
+	ldr r1, =ftrace_graph_return
+	ldr r2, [r1]
+	cmp r0, r2		@ if *ftrace_graph_return != ftrace_stub
+	bne ftrace_graph_caller
+#endif /* CONFIG_FUNCTION_GRAPH_TRACER */
+
 	ldr lr, [fp, #-4]			@ restore lr
-	ldmia sp!, {r0-r3, pc}
+	ldmia sp!, {r0-r3, pc}			@ return doing nothing

 trace:
 	ldr r1, [fp, #-4]			@ lr of instrumented routine
@@ -147,6 +155,25 @@ trace:
 	mov lr, r1				@ restore lr
 	ldmia sp!, {r0-r3, pc}

+#ifdef CONFIG_FUNCTION_GRAPH_TRACER
+ENTRY(ftrace_graph_caller)
+	sub r0, fp, #4			@ &lr of instrumented routine (&parent)
+	mov r1, lr			@ instrumented routine (func)
+	sub r1, r1, #MCOUNT_INSN_SIZE
+	bl prepare_ftrace_return
+	ldr lr, [fp, #-4]		@ restore lr
+	ldmia sp!, {r0-r3, pc}
+
+	.globl return_to_handler
+return_to_handler:
+	stmdb sp!, {r0-r3}
+	bl ftrace_return_to_handler
+	mov lr, r0			@ r0 has real ret addr
+	ldmia sp!, {r0-r3}
+	mov pc, lr
+
+#endif /* CONFIG_FUNCTION_GRAPH_TRACER */
+
 #endif /* CONFIG_DYNAMIC_FTRACE */

 	.globl ftrace_stub
--- a/arch/arm/kernel/ftrace.c
+++ b/arch/arm/kernel/ftrace.c
@@ -16,6 +16,8 @@
 #include <asm/cacheflush.h>
 #include <asm/ftrace.h>

+#ifdef CONFIG_DYNAMIC_FTRACE
+
 #define PC_OFFSET      8
 #define BL_OPCODE      0xeb000000
 #define BL_OFFSET_MASK 0x00ffffff
@@ -101,3 +103,147 @@ int __init ftrace_dyn_arch_init(void *da
 	ftrace_mcount_set(data);
 	return 0;
 }
+
+#endif /* CONFIG_DYNAMIC_FTRACE */
+
+#ifdef CONFIG_FUNCTION_GRAPH_TRACER
+
+/* Add a function return address to the trace stack on thread info.*/
+static int push_return_trace(unsigned long ret, unsigned long long time,
+	unsigned long func, int *depth)
+{
+	int index;
+
+	if (!current->ret_stack)
+		return -EBUSY;
+
+	/* The return trace stack is full */
+	if (current->curr_ret_stack == FTRACE_RETFUNC_DEPTH - 1) {
+		atomic_inc(&current->trace_overrun);
+		return -EBUSY;
+	}
+
+	index = ++current->curr_ret_stack;
+	barrier();
+	current->ret_stack[index].ret = ret;
+	current->ret_stack[index].func = func;
+	current->ret_stack[index].calltime = time;
+	*depth = index;
+
+	return 0;
+}
+
+/*
+ * Retrieve a function return address from the trace stack on thread info.
+ *   set the address to return to in *ret
+ */
+static void pop_return_trace(struct ftrace_graph_ret *trace, unsigned long *ret)
+{
+	int index;
+
+	index = current->curr_ret_stack;
+
+	if (unlikely(index < 0)) {
+		ftrace_graph_stop();
+		WARN_ON(1);
+		/* Might as well panic, otherwise we have no where to go */
+		*ret = (unsigned long)panic;
+		return;
+	}
+
+	*ret = current->ret_stack[index].ret;
+	trace->func = current->ret_stack[index].func;
+	trace->calltime = current->ret_stack[index].calltime;
+	trace->overrun = atomic_read(&current->trace_overrun);
+	trace->depth = index;
+	barrier();
+	current->curr_ret_stack--;
+}
+
+int already_here;	 /* starts at 0 */
+
+/*
+ * Send the trace to the ring-buffer
+ * @return the original return address
+ */
+unsigned long ftrace_return_to_handler(void)
+{
+	struct ftrace_graph_ret trace;
+	unsigned long ret;
+
+	/* guard against trace entry while handling a trace exit */
+	already_here++;
+
+	pop_return_trace(&trace, &ret);
+	trace.rettime = cpu_clock(raw_smp_processor_id());
+	ftrace_graph_return(&trace);
+
+	if (unlikely(!ret)) {
+		ftrace_graph_stop();
+		WARN_ON(1);
+		/* Might as well panic. Where else to go? */
+		ret = (unsigned long)panic;
+	}
+
+	already_here--;
+	return ret;
+}
+
+/*
+ * Hook the return address and push it in the stack of return addrs
+ * in current thread info.
+ */
+
+void prepare_ftrace_return(unsigned long *parent, unsigned long self_addr)
+{
+	unsigned long old;
+	unsigned long long calltime;
+
+	struct ftrace_graph_ent trace;
+	unsigned long return_hooker = (unsigned long)
+				&return_to_handler;
+
+	if (already_here)
+		return;
+	already_here++;
+
+	if (unlikely(atomic_read(&current->tracing_graph_pause))) {
+		already_here--;
+		return;
+	}
+
+	/* FIXTHIS - need a local_irqsave here?, (to fend off ints?) */
+
+	/* FIXTHIS - x86 protects against a fault during this operation!*/
+	old = *parent;
+	*parent = return_hooker;
+
+	if (unlikely(!__kernel_text_address(old))) {
+		ftrace_graph_stop();
+		*parent = old;
+		WARN_ON(1);
+		already_here--;
+		return;
+	}
+
+	/* FIXTHIS - trace entry appears to nest inside following */
+	calltime = cpu_clock(raw_smp_processor_id());
+
+	if (push_return_trace(old, calltime,
+			self_addr, &trace.depth) == -EBUSY) {
+		*parent = old;
+		already_here--;
+		return;
+	}
+
+	trace.func = self_addr;
+
+	/* Only trace if the calling function expects to */
+	if (!ftrace_graph_entry(&trace)) {
+		current->curr_ret_stack--;
+		*parent = old;
+	}
+
+	already_here--;
+}
+#endif /* CONFIG_FUNCTION_GRAPH_TRACER */
--- a/arch/arm/kernel/vmlinux.lds.S
+++ b/arch/arm/kernel/vmlinux.lds.S
@@ -95,6 +95,7 @@ SECTIONS
 			SCHED_TEXT
 			LOCK_TEXT
 			KPROBES_TEXT
+			IRQENTRY_TEXT
 #ifdef CONFIG_MMU
 			*(.fixup)
 #endif

