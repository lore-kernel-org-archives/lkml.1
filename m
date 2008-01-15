Return-Path: <linux-kernel-owner+w=401wt.eu-S1751130AbYAOPJm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751130AbYAOPJm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2008 10:09:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751318AbYAOPJY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jan 2008 10:09:24 -0500
Received: from ms-smtp-02.nyroc.rr.com ([24.24.2.56]:33162 "EHLO
	ms-smtp-02.nyroc.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751270AbYAOPJW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2008 10:09:22 -0500
Date: Tue, 15 Jan 2008 10:09:11 -0500 (EST)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Andy Whitcroft <apw@shadowen.org>
cc: rdunlap@xenotime.net, jschopp@austin.ibm.com,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: EXPORTS_SYMBOLs that are in assembly?
In-Reply-To: <20080114192507.GC25058@shadowen.org>
Message-ID: <Pine.LNX.4.58.0801151007080.28291@gandalf.stny.rr.com>
References: <Pine.LNX.4.58.0801132038410.1764@gandalf.stny.rr.com>
 <20080114192507.GC25058@shadowen.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Mon, 14 Jan 2008, Andy Whitcroft wrote:
>
> Could you send me a fuller example fragment defining 'foo' as an
> example?  It is entirly possible you are doing it right and this is an
> 'ignore checkpatch' situation.

Here's the full patch that gives me the problem. mcount is defined in
entry.S but needs to be exported for modules to use.

I'll be posting these patches soon anyway.

-- Steve


================
Subject: Add basic support for gcc profiler instrumentation

If CONFIG_MCOUNT is selected and /proc/sys/kernel/mcount_enabled is set to a
non-zero value the mcount routine will be called everytime we enter a kernel
function that is not marked with the "notrace" attribute.

The mcount routine will then call a registered function if a function
happens to be registered.

[This code has been highly hacked by Steven Rostedt, so don't
 blame Arnaldo for all of this ;-) ]

Signed-off-by: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Signed-off-by: Steven Rostedt <srostedt@redhat.com>
---
 Makefile                   |    3
 arch/x86/Kconfig           |    1
 arch/x86/kernel/entry_32.S |   22 +++++++
 arch/x86/kernel/entry_64.S |   33 ++++++++++
 include/linux/linkage.h    |    2
 include/linux/mcount.h     |   34 ++++++++++
 kernel/sysctl.c            |   11 +++
 lib/Kconfig.debug          |    2
 lib/Makefile               |    2
 lib/tracing/Kconfig        |   10 +++
 lib/tracing/Makefile       |    3
 lib/tracing/mcount.c       |  141 +++++++++++++++++++++++++++++++++++++++++++++
 12 files changed, 264 insertions(+)

Index: linux-compile.git/Makefile
===================================================================
--- linux-compile.git.orig/Makefile	2008-01-14 13:14:05.000000000 -0500
+++ linux-compile.git/Makefile	2008-01-14 13:14:13.000000000 -0500
@@ -509,6 +509,9 @@ endif

 include $(srctree)/arch/$(SRCARCH)/Makefile

+ifdef CONFIG_MCOUNT
+KBUILD_CFLAGS	+= -pg
+endif
 ifdef CONFIG_FRAME_POINTER
 KBUILD_CFLAGS	+= -fno-omit-frame-pointer -fno-optimize-sibling-calls
 else
Index: linux-compile.git/arch/x86/Kconfig
===================================================================
--- linux-compile.git.orig/arch/x86/Kconfig	2008-01-14 13:14:05.000000000 -0500
+++ linux-compile.git/arch/x86/Kconfig	2008-01-14 13:14:13.000000000 -0500
@@ -19,6 +19,7 @@ config X86_64
 config X86
 	bool
 	default y
+	select HAVE_MCOUNT

 config GENERIC_TIME
 	bool
Index: linux-compile.git/arch/x86/kernel/entry_32.S
===================================================================
--- linux-compile.git.orig/arch/x86/kernel/entry_32.S	2008-01-14 13:14:05.000000000 -0500
+++ linux-compile.git/arch/x86/kernel/entry_32.S	2008-01-14 13:14:13.000000000 -0500
@@ -75,6 +75,28 @@ DF_MASK		= 0x00000400
 NT_MASK		= 0x00004000
 VM_MASK		= 0x00020000

+#ifdef CONFIG_MCOUNT
+.globl mcount
+mcount:
+	cmpl $0, mcount_enabled
+	jz out
+
+	/* taken from glibc */
+	pushl %eax
+	pushl %ecx
+	pushl %edx
+	movl 0xc(%esp), %edx
+	movl 0x4(%ebp), %eax
+
+	call   *mcount_trace_function
+
+	popl %edx
+	popl %ecx
+	popl %eax
+out:
+	ret
+#endif
+
 #ifdef CONFIG_PREEMPT
 #define preempt_stop(clobbers)	DISABLE_INTERRUPTS(clobbers); TRACE_IRQS_OFF
 #else
Index: linux-compile.git/arch/x86/kernel/entry_64.S
===================================================================
--- linux-compile.git.orig/arch/x86/kernel/entry_64.S	2008-01-14 13:14:05.000000000 -0500
+++ linux-compile.git/arch/x86/kernel/entry_64.S	2008-01-14 13:14:13.000000000 -0500
@@ -53,6 +53,39 @@

 	.code64

+#ifdef CONFIG_MCOUNT
+
+ENTRY(mcount)
+	cmpl $0, mcount_enabled
+	jz out
+
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
+	movq 0x38(%rsp), %rsi
+	movq 8(%rbp), %rdi
+
+	call   *mcount_trace_function
+
+	movq 48(%rsp), %r9
+	movq 40(%rsp), %r8
+	movq 32(%rsp), %rdi
+	movq 24(%rsp), %rsi
+	movq 16(%rsp), %rdx
+	movq 8(%rsp), %rcx
+	movq (%rsp), %rax
+	addq $0x38, %rsp
+out:
+	retq
+#endif
+
 #ifndef CONFIG_PREEMPT
 #define retint_kernel retint_restore_args
 #endif
Index: linux-compile.git/include/linux/linkage.h
===================================================================
--- linux-compile.git.orig/include/linux/linkage.h	2008-01-14 13:14:05.000000000 -0500
+++ linux-compile.git/include/linux/linkage.h	2008-01-14 13:14:13.000000000 -0500
@@ -3,6 +3,8 @@

 #include <asm/linkage.h>

+#define notrace __attribute__((no_instrument_function))
+
 #ifdef __cplusplus
 #define CPP_ASMLINKAGE extern "C"
 #else
Index: linux-compile.git/include/linux/mcount.h
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-compile.git/include/linux/mcount.h	2008-01-14 14:57:35.000000000 -0500
@@ -0,0 +1,34 @@
+#ifndef _LINUX_MCOUNT_H
+#define _LINUX_MCOUNT_H
+
+#ifdef CONFIG_MCOUNT
+extern int mcount_enabled;
+
+#include <linux/linkage.h>
+
+#define CALLER_ADDR0 ((unsigned long)__builtin_return_address(0))
+#define CALLER_ADDR1 ((unsigned long)__builtin_return_address(1))
+#define CALLER_ADDR2 ((unsigned long)__builtin_return_address(2))
+
+typedef void (*mcount_func_t)(unsigned long ip, unsigned long parent_ip);
+
+struct mcount_ops {
+	mcount_func_t func;
+	struct mcount_ops *next;
+};
+
+/*
+ * The mcount_ops must be a static and should also
+ * be read_mostly.  These functions do modify read_mostly variables
+ * so use them sparely. Never free an mcount_op or modify the
+ * next pointer after it has been registered. Even after unregistering
+ * it, the next pointer may still be used internally.
+ */
+int register_mcount_function(struct mcount_ops *ops);
+int unregister_mcount_function(struct mcount_ops *ops);
+void clear_mcount_function(void);
+
+extern void mcount(void);
+
+#endif /* CONFIG_MCOUNT */
+#endif /* _LINUX_MCOUNT_H */
Index: linux-compile.git/kernel/sysctl.c
===================================================================
--- linux-compile.git.orig/kernel/sysctl.c	2008-01-14 13:14:05.000000000 -0500
+++ linux-compile.git/kernel/sysctl.c	2008-01-14 13:14:13.000000000 -0500
@@ -46,6 +46,7 @@
 #include <linux/nfs_fs.h>
 #include <linux/acpi.h>
 #include <linux/reboot.h>
+#include <linux/mcount.h>

 #include <asm/uaccess.h>
 #include <asm/processor.h>
@@ -470,6 +471,16 @@ static struct ctl_table kern_table[] = {
 		.mode		= 0644,
 		.proc_handler	= &proc_dointvec,
 	},
+#ifdef CONFIG_MCOUNT
+	{
+		.ctl_name	= CTL_UNNUMBERED,
+		.procname	= "mcount_enabled",
+		.data		= &mcount_enabled,
+		.maxlen		= sizeof(int),
+		.mode		= 0644,
+		.proc_handler	= &proc_dointvec,
+	},
+#endif
 #ifdef CONFIG_KMOD
 	{
 		.ctl_name	= KERN_MODPROBE,
Index: linux-compile.git/lib/Kconfig.debug
===================================================================
--- linux-compile.git.orig/lib/Kconfig.debug	2008-01-14 13:14:05.000000000 -0500
+++ linux-compile.git/lib/Kconfig.debug	2008-01-14 13:14:13.000000000 -0500
@@ -517,4 +517,6 @@ config FAULT_INJECTION_STACKTRACE_FILTER
 	help
 	  Provide stacktrace filter for fault-injection capabilities

+source lib/tracing/Kconfig
+
 source "samples/Kconfig"
Index: linux-compile.git/lib/Makefile
===================================================================
--- linux-compile.git.orig/lib/Makefile	2008-01-14 13:14:05.000000000 -0500
+++ linux-compile.git/lib/Makefile	2008-01-14 14:57:36.000000000 -0500
@@ -66,6 +66,8 @@ obj-$(CONFIG_AUDIT_GENERIC) += audit.o
 obj-$(CONFIG_SWIOTLB) += swiotlb.o
 obj-$(CONFIG_FAULT_INJECTION) += fault-inject.o

+obj-$(CONFIG_MCOUNT) += tracing/
+
 lib-$(CONFIG_GENERIC_BUG) += bug.o

 hostprogs-y	:= gen_crc32table
Index: linux-compile.git/lib/tracing/Kconfig
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-compile.git/lib/tracing/Kconfig	2008-01-14 14:58:02.000000000 -0500
@@ -0,0 +1,10 @@
+
+# Archs that enable MCOUNT should select HAVE_MCOUNT
+config HAVE_MCOUNT
+       bool
+
+# MCOUNT itself is useless, or will just be added overhead.
+# It needs something to register a function with it.
+config MCOUNT
+	bool
+	select FRAME_POINTER
Index: linux-compile.git/lib/tracing/Makefile
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-compile.git/lib/tracing/Makefile	2008-01-14 14:58:02.000000000 -0500
@@ -0,0 +1,3 @@
+obj-$(CONFIG_MCOUNT) += libmcount.o
+
+libmcount-y := mcount.o
Index: linux-compile.git/lib/tracing/mcount.c
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-compile.git/lib/tracing/mcount.c	2008-01-14 13:14:13.000000000 -0500
@@ -0,0 +1,141 @@
+/*
+ * Infrastructure for profiling code inserted by 'gcc -pg'.
+ *
+ * Copyright (C) 2007-2008 Steven Rostedt <srostedt@redhat.com>
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
+#include <linux/mcount.h>
+
+/*
+ * Since we have nothing protecting between the test of
+ * mcount_trace_function and the call to it, we can't
+ * set it to NULL without risking a race that will have
+ * the kernel call the NULL pointer. Instead, we just
+ * set the function pointer to a dummy function.
+ */
+notrace void dummy_mcount_tracer(unsigned long ip,
+				 unsigned long parent_ip)
+{
+	/* do nothing */
+}
+
+static DEFINE_SPINLOCK(mcount_func_lock);
+static struct mcount_ops mcount_list_end __read_mostly =
+{
+	.func = dummy_mcount_tracer,
+};
+
+static struct mcount_ops *mcount_list __read_mostly = &mcount_list_end;
+mcount_func_t mcount_trace_function __read_mostly = dummy_mcount_tracer;
+int mcount_enabled __read_mostly;
+
+/* mcount is defined per arch in assembly */
+EXPORT_SYMBOL_GPL(mcount);
+
+notrace void mcount_list_func(unsigned long ip, unsigned long parent_ip)
+{
+	struct mcount_ops *op = mcount_list;
+
+	while (op != &mcount_list_end) {
+		op->func(ip, parent_ip);
+		op = op->next;
+	};
+}
+
+/**
+ * register_mcount_function - register a function for profiling
+ * @ops - ops structure that holds the function for profiling.
+ *
+ * Register a function to be called by all functions in the
+ * kernel.
+ *
+ * Note: @ops->func and all the functions it calls must be labeled
+ *       with "notrace", otherwise it will go into a
+ *       recursive loop.
+ */
+int register_mcount_function(struct mcount_ops *ops)
+{
+	unsigned long flags;
+
+	spin_lock_irqsave(&mcount_func_lock, flags);
+	ops->next = mcount_list;
+	/* must have next seen before we update the list pointer */
+	smp_wmb();
+	mcount_list = ops;
+	/*
+	 * For one func, simply call it directly.
+	 * For more than one func, call the chain.
+	 */
+	if (ops->next == &mcount_list_end)
+		mcount_trace_function = ops->func;
+	else
+		mcount_trace_function = mcount_list_func;
+	spin_unlock_irqrestore(&mcount_func_lock, flags);
+
+	return 0;
+}
+
+/**
+ * unregister_mcount_function - unresgister a function for profiling.
+ * @ops - ops structure that holds the function to unregister
+ *
+ * Unregister a function that was added to be called by mcount profiling.
+ */
+int unregister_mcount_function(struct mcount_ops *ops)
+{
+	unsigned long flags;
+	struct mcount_ops **p;
+	int ret = 0;
+
+	spin_lock_irqsave(&mcount_func_lock, flags);
+
+	/*
+	 * If we are the only function, then the mcount pointer is
+	 * pointing directly to that function.
+	 */
+	if (mcount_list == ops && ops->next == &mcount_list_end) {
+		mcount_trace_function = dummy_mcount_tracer;
+		mcount_list = &mcount_list_end;
+		goto out;
+	}
+
+	for (p = &mcount_list; *p != &mcount_list_end; p = &(*p)->next)
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
+	if (mcount_list->next == &mcount_list_end)
+		mcount_trace_function = mcount_list->func;
+
+ out:
+	spin_unlock_irqrestore(&mcount_func_lock, flags);
+
+	return 0;
+}
+
+/**
+ * clear_mcount_function - reset the mcount function
+ *
+ * This NULLs the mcount function and in essence stops
+ * tracing.  There may be lag
+ */
+void clear_mcount_function(void)
+{
+	mcount_trace_function = dummy_mcount_tracer;
+}
