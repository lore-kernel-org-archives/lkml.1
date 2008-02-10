Return-Path: <linux-kernel-owner+w=401wt.eu-S1759376AbYBJHYb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759376AbYBJHYb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Feb 2008 02:24:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758058AbYBJHUu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Feb 2008 02:20:50 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:56853 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758036AbYBJHUr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Feb 2008 02:20:47 -0500
Date: Sun, 10 Feb 2008 08:20:35 +0100
From: Ingo Molnar <mingo@elte.hu>
To: linux-kernel@vger.kernel.org
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@zip.com.au>, Steven Rostedt <rostedt@goodmis.org>
Subject: [10/19] ftrace: add basic support for gcc profiler instrumentation
Message-ID: <20080210072035.GK4100@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>

If CONFIG_FTRACE is selected and /proc/sys/kernel/ftrace_enabled is
set to a non-zero value the ftrace routine will be called everytime
we enter a kernel function that is not marked with the "notrace"
attribute.

The ftrace routine will then call a registered function if a function
happens to be registered.

[ This code has been highly hacked by Steven Rostedt and Ingo Molnar,
  so don't blame Arnaldo for all of this ;-) ]

Update:
  It is now possible to register more than one ftrace function.
  If only one ftrace function is registered, that will be the
  function that ftrace calls directly. If more than one function
  is registered, then ftrace will call a function that will loop
  through the functions to call.

Signed-off-by: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Signed-off-by: Steven Rostedt <srostedt@redhat.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 Makefile                   |    3 
 arch/x86/Kconfig           |    1 
 arch/x86/kernel/entry_32.S |   27 ++++++++
 arch/x86/kernel/entry_64.S |   37 ++++++++++++
 include/linux/ftrace.h     |   38 ++++++++++++
 kernel/Makefile            |    1 
 kernel/trace/Kconfig       |    5 +
 kernel/trace/Makefile      |    3 
 kernel/trace/ftrace.c      |  138 +++++++++++++++++++++++++++++++++++++++++++++
 lib/Kconfig.debug          |    2 
 10 files changed, 255 insertions(+)

Index: linux/Makefile
===================================================================
--- linux.orig/Makefile
+++ linux/Makefile
@@ -509,6 +509,9 @@ endif
 
 include $(srctree)/arch/$(SRCARCH)/Makefile
 
+ifdef CONFIG_FTRACE
+KBUILD_CFLAGS	+= -pg
+endif
 ifdef CONFIG_FRAME_POINTER
 KBUILD_CFLAGS	+= -fno-omit-frame-pointer -fno-optimize-sibling-calls
 else
Index: linux/arch/x86/Kconfig
===================================================================
--- linux.orig/arch/x86/Kconfig
+++ linux/arch/x86/Kconfig
@@ -20,6 +20,7 @@ config X86
 	def_bool y
 	select HAVE_OPROFILE
 	select HAVE_KPROBES
+	select HAVE_FTRACE
 
 config GENERIC_LOCKBREAK
 	def_bool n
Index: linux/arch/x86/kernel/entry_32.S
===================================================================
--- linux.orig/arch/x86/kernel/entry_32.S
+++ linux/arch/x86/kernel/entry_32.S
@@ -75,6 +75,33 @@ DF_MASK		= 0x00000400 
 NT_MASK		= 0x00004000
 VM_MASK		= 0x00020000
 
+#ifdef CONFIG_FTRACE
+ENTRY(mcount)
+	cmpl $ftrace_stub, ftrace_trace_function
+	jnz trace
+
+.globl ftrace_stub
+ftrace_stub:
+	ret
+
+	/* taken from glibc */
+trace:
+	pushl %eax
+	pushl %ecx
+	pushl %edx
+	movl 0xc(%esp), %eax
+	movl 0x4(%ebp), %edx
+
+	call   *ftrace_trace_function
+
+	popl %edx
+	popl %ecx
+	popl %eax
+
+	jmp ftrace_stub
+END(mcount)
+#endif
+
 #ifdef CONFIG_PREEMPT
 #define preempt_stop(clobbers)	DISABLE_INTERRUPTS(clobbers); TRACE_IRQS_OFF
 #else
Index: linux/arch/x86/kernel/entry_64.S
===================================================================
--- linux.orig/arch/x86/kernel/entry_64.S
+++ linux/arch/x86/kernel/entry_64.S
@@ -54,6 +54,43 @@
 
 	.code64
 
+#ifdef CONFIG_FTRACE
+ENTRY(mcount)
+	cmpq $ftrace_stub, ftrace_trace_function
+	jnz trace
+.globl ftrace_stub
+ftrace_stub:
+	retq
+
+trace:
+	/* taken from glibc */
+	subq $0x38, %rsp
+	movq %rax, (%rsp)
+	movq %rcx, 8(%rsp)
+	movq %rdx, 16(%rsp)
+	movq %rsi, 24(%rsp)
+	movq %rdi, 32(%rsp)
+	movq %r8, 40(%rsp)
+	movq %r9, 48(%rsp)
+
+	movq 0x38(%rsp), %rdi
+	movq 8(%rbp), %rsi
+
+	call   *ftrace_trace_function
+
+	movq 48(%rsp), %r9
+	movq 40(%rsp), %r8
+	movq 32(%rsp), %rdi
+	movq 24(%rsp), %rsi
+	movq 16(%rsp), %rdx
+	movq 8(%rsp), %rcx
+	movq (%rsp), %rax
+	addq $0x38, %rsp
+
+	jmp ftrace_stub
+END(mcount)
+#endif
+
 #ifndef CONFIG_PREEMPT
 #define retint_kernel retint_restore_args
 #endif	
Index: linux/include/linux/ftrace.h
===================================================================
--- /dev/null
+++ linux/include/linux/ftrace.h
@@ -0,0 +1,38 @@
+#ifndef _LINUX_FTRACE_H
+#define _LINUX_FTRACE_H
+
+#ifdef CONFIG_FTRACE
+
+#include <linux/linkage.h>
+
+#define CALLER_ADDR0 ((unsigned long)__builtin_return_address(0))
+#define CALLER_ADDR1 ((unsigned long)__builtin_return_address(1))
+#define CALLER_ADDR2 ((unsigned long)__builtin_return_address(2))
+
+typedef void (*ftrace_func_t)(unsigned long ip, unsigned long parent_ip);
+
+struct ftrace_ops {
+	ftrace_func_t	  func;
+	struct ftrace_ops *next;
+};
+
+/*
+ * The ftrace_ops must be a static and should also
+ * be read_mostly.  These functions do modify read_mostly variables
+ * so use them sparely. Never free an ftrace_op or modify the
+ * next pointer after it has been registered. Even after unregistering
+ * it, the next pointer may still be used internally.
+ */
+int register_ftrace_function(struct ftrace_ops *ops);
+int unregister_ftrace_function(struct ftrace_ops *ops);
+void clear_ftrace_function(void);
+
+extern void ftrace_stub(unsigned long a0, unsigned long a1);
+extern void mcount(void);
+
+#else /* !CONFIG_FTRACE */
+# define register_ftrace_function(ops) do { } while (0)
+# define unregister_ftrace_function(ops) do { } while (0)
+# define clear_ftrace_function(ops) do { } while (0)
+#endif /* CONFIG_FTRACE */
+#endif /* _LINUX_FTRACE_H */
Index: linux/kernel/Makefile
===================================================================
--- linux.orig/kernel/Makefile
+++ linux/kernel/Makefile
@@ -68,6 +68,7 @@ obj-$(CONFIG_TASK_DELAY_ACCT) += delayac
 obj-$(CONFIG_TASKSTATS) += taskstats.o tsacct.o
 obj-$(CONFIG_MARKERS) += marker.o
 obj-$(CONFIG_LATENCYTOP) += latencytop.o
+obj-$(CONFIG_FTRACE) += trace/
 
 ifneq ($(CONFIG_SCHED_NO_NO_OMIT_FRAME_POINTER),y)
 # According to Alan Modra <alan@linuxcare.com.au>, the -fno-omit-frame-pointer is
Index: linux/kernel/trace/Kconfig
===================================================================
--- /dev/null
+++ linux/kernel/trace/Kconfig
@@ -0,0 +1,5 @@
+#
+# Architectures that offer an FTRACE implementation should select HAVE_FTRACE:
+#
+config HAVE_FTRACE
+	bool
Index: linux/kernel/trace/Makefile
===================================================================
--- /dev/null
+++ linux/kernel/trace/Makefile
@@ -0,0 +1,3 @@
+obj-$(CONFIG_FTRACE) += libftrace.o
+
+libftrace-y := ftrace.o
Index: linux/kernel/trace/ftrace.c
===================================================================
--- /dev/null
+++ linux/kernel/trace/ftrace.c
@@ -0,0 +1,138 @@
+/*
+ * Infrastructure for profiling code inserted by 'gcc -pg'.
+ *
+ * Copyright (C) 2007-2008 Steven Rostedt <srostedt@redhat.com>
+ * Copyright (C) 2004-2008 Ingo Molnar <mingo@redhat.com>
+ *
+ * Originally ported from the -rt patch by:
+ *   Copyright (C) 2007 Arnaldo Carvalho de Melo <acme@redhat.com>
+ *
+ * Based on code in the latency_tracer, that is:
+ *
+ *  Copyright (C) 2004-2006 Ingo Molnar
+ *  Copyright (C) 2004 William Lee Irwin III
+ */
+
+#include <linux/module.h>
+#include <linux/ftrace.h>
+
+static DEFINE_SPINLOCK(ftrace_func_lock);
+static struct ftrace_ops ftrace_list_end __read_mostly =
+{
+	.func = ftrace_stub,
+};
+
+static struct ftrace_ops *ftrace_list __read_mostly = &ftrace_list_end;
+ftrace_func_t ftrace_trace_function __read_mostly = ftrace_stub;
+
+/* mcount is defined per arch in assembly */
+EXPORT_SYMBOL_GPL(mcount);
+
+notrace void ftrace_list_func(unsigned long ip, unsigned long parent_ip)
+{
+	struct ftrace_ops *op = ftrace_list;
+
+	/* in case someone actually ports this to alpha! */
+	read_barrier_depends();
+
+	while (op != &ftrace_list_end) {
+		/* silly alpha */
+		read_barrier_depends();
+		op->func(ip, parent_ip);
+		op = op->next;
+	};
+}
+
+/**
+ * register_ftrace_function - register a function for profiling
+ * @ops - ops structure that holds the function for profiling.
+ *
+ * Register a function to be called by all functions in the
+ * kernel.
+ *
+ * Note: @ops->func and all the functions it calls must be labeled
+ *       with "notrace", otherwise it will go into a
+ *       recursive loop.
+ */
+int register_ftrace_function(struct ftrace_ops *ops)
+{
+	unsigned long flags;
+
+	spin_lock_irqsave(&ftrace_func_lock, flags);
+	ops->next = ftrace_list;
+	/*
+	 * We are entering ops into the ftrace_list but another
+	 * CPU might be walking that list. We need to make sure
+	 * the ops->next pointer is valid before another CPU sees
+	 * the ops pointer included into the ftrace_list.
+	 */
+	smp_wmb();
+	ftrace_list = ops;
+	/*
+	 * For one func, simply call it directly.
+	 * For more than one func, call the chain.
+	 */
+	if (ops->next == &ftrace_list_end)
+		ftrace_trace_function = ops->func;
+	else
+		ftrace_trace_function = ftrace_list_func;
+	spin_unlock_irqrestore(&ftrace_func_lock, flags);
+
+	return 0;
+}
+
+/**
+ * unregister_ftrace_function - unresgister a function for profiling.
+ * @ops - ops structure that holds the function to unregister
+ *
+ * Unregister a function that was added to be called by ftrace profiling.
+ */
+int unregister_ftrace_function(struct ftrace_ops *ops)
+{
+	unsigned long flags;
+	struct ftrace_ops **p;
+	int ret = 0;
+
+	spin_lock_irqsave(&ftrace_func_lock, flags);
+
+	/*
+	 * If we are the only function, then the ftrace pointer is
+	 * pointing directly to that function.
+	 */
+	if (ftrace_list == ops && ops->next == &ftrace_list_end) {
+		ftrace_trace_function = ftrace_stub;
+		ftrace_list = &ftrace_list_end;
+		goto out;
+	}
+
+	for (p = &ftrace_list; *p != &ftrace_list_end; p = &(*p)->next)
+		if (*p == ops)
+			break;
+
+	if (*p != ops) {
+		ret = -1;
+		goto out;
+	}
+
+	*p = (*p)->next;
+
+	/* If we only have one func left, then call that directly */
+	if (ftrace_list->next == &ftrace_list_end)
+		ftrace_trace_function = ftrace_list->func;
+
+ out:
+	spin_unlock_irqrestore(&ftrace_func_lock, flags);
+
+	return 0;
+}
+
+/**
+ * clear_ftrace_function - reset the ftrace function
+ *
+ * This NULLs the ftrace function and in essence stops
+ * tracing.  There may be lag
+ */
+void clear_ftrace_function(void)
+{
+	ftrace_trace_function = ftrace_stub;
+}
Index: linux/lib/Kconfig.debug
===================================================================
--- linux.orig/lib/Kconfig.debug
+++ linux/lib/Kconfig.debug
@@ -602,6 +602,8 @@ config LATENCYTOP
 	  Enable this option if you want to use the LatencyTOP tool
 	  to find out which userspace is blocking on what kernel operations.
 
+source kernel/trace/Kconfig
+
 config PROVIDE_OHCI1394_DMA_INIT
 	bool "Provide code for enabling DMA over FireWire early on boot"
 	depends on PCI && X86
