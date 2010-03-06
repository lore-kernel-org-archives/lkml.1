Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752565Ab0CFAc2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Mar 2010 19:32:28 -0500
Received: from tx2ehsobe003.messaging.microsoft.com ([65.55.88.13]:11994 "EHLO
	TX2EHSOBE006.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751014Ab0CFAc0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Mar 2010 19:32:26 -0500
X-SpamScore: -4
X-BigFish: VPS-4(zz655Lab9bhzz1202hzzz2fh2a8h6bh62h)
X-Spam-TCS-SCL: 1:0
Message-ID: <4B91A25E.5030707@am.sony.com>
Date: Fri, 5 Mar 2010 16:31:26 -0800
From: Tim Bird <tim.bird@am.sony.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.8) Gecko/20100301 Fedora/3.0.3-1.fc12 Thunderbird/3.0.3
MIME-Version: 1.0
To: Tony Lindgren <tony@atomide.com>, Russell King <rmk@arm.linux.org.uk>,
       linux-arm-kernel <linux-arm-kernel@lists.arm.linux.org.uk>,
       linux kernel <linux-kernel@vger.kernel.org>,
       Steven Rostedt <rostedt@goodmis.org>,
       Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH 2/2] ftrace - add ftrace function_graph support on ARM
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Reverse-DNS: mail7.fw-bc.sony.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add ftrace function-graph tracer support for ARM.

This includes adding code in mcount to check for
(and call) a registered function graph trace entry
routine, and adding code to support a return
trampoline, to catch the function exit.

IRQENTRY_TEXT was added to vmlinux.lds.S (to eliminate
a compiler error on kernel/trace/trace_functions_graph.c),
although no routines were marked as __irq_entry.

Signed-off-by: Tim Bird <tim.bird@am.sony.com>
---
 arch/arm/Kconfig               |    1
 arch/arm/kernel/Makefile       |    4 +--
 arch/arm/kernel/entry-common.S |   36 +++++++++++++++++++++++++++++++-
 arch/arm/kernel/ftrace_graph.c |   46 +++++++++++++++++++++++++++++++++++++++++
 arch/arm/kernel/vmlinux.lds.S  |    1
 5 files changed, 85 insertions(+), 3 deletions(-)

--- a/arch/arm/Kconfig
+++ b/arch/arm/Kconfig
@@ -18,6 +18,7 @@ config ARM
 	select HAVE_KPROBES if (!XIP_KERNEL)
 	select HAVE_KRETPROBES if (HAVE_KPROBES)
 	select HAVE_FUNCTION_TRACER if (!XIP_KERNEL)
+	select HAVE_FUNCTION_GRAPH_TRACER if (!XIP_KERNEL)
 	select HAVE_GENERIC_DMA_COHERENT
 	select HAVE_KERNEL_GZIP
 	select HAVE_KERNEL_LZO
--- a/arch/arm/kernel/Makefile
+++ b/arch/arm/kernel/Makefile
@@ -5,9 +5,8 @@
 CPPFLAGS_vmlinux.lds := -DTEXT_OFFSET=$(TEXT_OFFSET)
 AFLAGS_head.o        := -DTEXT_OFFSET=$(TEXT_OFFSET)

-ifdef CONFIG_DYNAMIC_FTRACE
 CFLAGS_REMOVE_ftrace.o = -pg
-endif
+CFLAGS_REMOVE_ftrace_graph.o = -pg

 CFLAGS_REMOVE_return_address.o = -pg

@@ -31,6 +30,7 @@ obj-$(CONFIG_SMP)		+= smp.o
 obj-$(CONFIG_HAVE_ARM_SCU)	+= smp_scu.o
 obj-$(CONFIG_HAVE_ARM_TWD)	+= smp_twd.o
 obj-$(CONFIG_DYNAMIC_FTRACE)	+= ftrace.o
+obj-$(CONFIG_FUNCTION_GRAPH_TRACER)	+= ftrace_graph.o
 obj-$(CONFIG_KEXEC)		+= machine_kexec.o relocate_kernel.o
 obj-$(CONFIG_KPROBES)		+= kprobes.o kprobes-decode.o
 obj-$(CONFIG_ATAGS_PROC)	+= atags.o
--- a/arch/arm/kernel/entry-common.S
+++ b/arch/arm/kernel/entry-common.S
@@ -98,6 +98,11 @@ ENTRY(mcount)
 	mov r0, lr
 	sub r0, r0, #MCOUNT_INSN_SIZE

+#ifdef CONFIG_FUNCTION_GRAPH_TRACER
+	@ FIXTHIS - DYNAMIC_FTRACE does not support function graph tracing
+	@ when the dynamic work is revived, this should be supported as well
+#endif
+
 	.globl mcount_call
 mcount_call:
 	bl ftrace_stub
@@ -144,8 +149,16 @@ ENTRY(mcount)
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
@@ -156,6 +169,27 @@ trace:
 	ldr lr, [fp, #-4]			@ restore lr
 	ldmia sp!, {r0-r3, pc}

+#ifdef CONFIG_FUNCTION_GRAPH_TRACER
+ENTRY(ftrace_graph_caller)
+	sub r0, fp, #4			@ &lr of instrumented routine (&parent)
+	mov r1, lr			@ instrumented routine (func)
+	sub r1, r1, #MCOUNT_INSN_SIZE
+	mov r2, fp			@ frame pointer
+	bl prepare_ftrace_return
+	ldr lr, [fp, #-4]		@ restore lr
+	ldmia sp!, {r0-r3, pc}
+
+	.globl return_to_handler
+return_to_handler:
+	stmdb sp!, {r0-r3}
+	mov r0, fp			@ frame pointer
+	bl ftrace_return_to_handler
+	mov lr, r0			@ r0 has real ret addr
+	ldmia sp!, {r0-r3}
+	mov pc, lr
+
+#endif /* CONFIG_FUNCTION_GRAPH_TRACER */
+
 #endif /* CONFIG_DYNAMIC_FTRACE */

 	.globl ftrace_stub
--- /dev/null
+++ b/arch/arm/kernel/ftrace_graph.c
@@ -0,0 +1,46 @@
+/*
+ * function graph tracing support.
+ *
+ * Copyright (C) 2009 Tim Bird <tim.bird@am.sony.com>
+ *
+ * For licencing details, see COPYING.
+ *
+ * Defines routine needed for ARM return trampoline for tracing
+ * function exits.
+ */
+
+#include <linux/ftrace.h>
+
+/*
+ * Hook the return address and push it in the stack of return addrs
+ * in current thread info.
+ */
+void prepare_ftrace_return(unsigned long *parent, unsigned long self_addr,
+			   unsigned long frame_pointer)
+{
+	unsigned long old;
+
+	struct ftrace_graph_ent trace;
+	unsigned long return_hooker = (unsigned long)
+				&return_to_handler;
+
+	if (unlikely(atomic_read(&current->tracing_graph_pause)))
+		return;
+
+	old = *parent;
+	*parent = return_hooker;
+
+	if (ftrace_push_return_trace(old, self_addr, &trace.depth,
+		    frame_pointer) == -EBUSY) {
+		*parent = old;
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
+}
--- a/arch/arm/kernel/vmlinux.lds.S
+++ b/arch/arm/kernel/vmlinux.lds.S
@@ -91,6 +91,7 @@ SECTIONS
 			SCHED_TEXT
 			LOCK_TEXT
 			KPROBES_TEXT
+			IRQENTRY_TEXT
 #ifdef CONFIG_MMU
 			*(.fixup)
 #endif

