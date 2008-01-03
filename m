Return-Path: <linux-kernel-owner+w=401wt.eu-S1760369AbYACH0e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760369AbYACH0e (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jan 2008 02:26:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757133AbYACHYa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Jan 2008 02:24:30 -0500
Received: from ms-smtp-03.nyroc.rr.com ([24.24.2.57]:40014 "EHLO
	ms-smtp-03.nyroc.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754262AbYACHYS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jan 2008 02:24:18 -0500
Message-Id: <20080103072226.776141236@goodmis.org>
References: <20080103071609.478486470@goodmis.org>
User-Agent: quilt/0.46-1
Date: Thu, 03 Jan 2008 02:16:10 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Christoph Hellwig <hch@infradead.org>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Gregory Haskins <ghaskins@novell.com>,
       Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
       "William L. Irwin" <sparclinux@vger.kernel.org>,
       Steven Rostedt <srostedt@redhat.com>
Subject: [RFC PATCH 01/11] Add basic support for gcc profiler instrumentation
Content-Disposition: inline; filename=mcount-add-basic-support-for-gcc-profiler-instrum.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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
 Documentation/stable_api_nonsense.txt |    3 +
 Makefile                              |    4 +
 arch/x86/Kconfig                      |    6 ++
 arch/x86/Makefile_32                  |    4 +
 arch/x86/kernel/Makefile_32           |    1 
 arch/x86/kernel/entry_64.S            |   46 ++++++++++++++++++++
 arch/x86/kernel/mcount-wrapper.S      |   25 ++++++++++
 include/linux/linkage.h               |    2 
 include/linux/mcount.h                |   21 +++++++++
 kernel/sysctl.c                       |   11 ++++
 lib/Kconfig.debug                     |    2 
 lib/Makefile                          |    2 
 lib/mcount/Kconfig                    |    6 ++
 lib/mcount/Makefile                   |    3 +
 lib/mcount/mcount.c                   |   78 ++++++++++++++++++++++++++++++++++
 15 files changed, 213 insertions(+), 1 deletion(-)
 create mode 100644 arch/i386/kernel/mcount-wrapper.S
 create mode 100644 lib/mcount/Kconfig
 create mode 100644 lib/mcount/Makefile
 create mode 100644 lib/mcount/mcount.c
 create mode 100644 lib/mcount/mcount.h

Index: linux-compile.git/Documentation/stable_api_nonsense.txt
===================================================================
--- linux-compile.git.orig/Documentation/stable_api_nonsense.txt	2008-01-03 01:02:28.000000000 -0500
+++ linux-compile.git/Documentation/stable_api_nonsense.txt	2008-01-03 01:02:33.000000000 -0500
@@ -62,6 +62,9 @@ consider the following facts about the L
       - different structures can contain different fields
       - Some functions may not be implemented at all, (i.e. some locks
 	compile away to nothing for non-SMP builds.)
+      - Parameter passing of variables from function to function can be
+	done in different ways (the CONFIG_REGPARM option controls
+	this.)
       - Memory within the kernel can be aligned in different ways,
 	depending on the build options.
   - Linux runs on a wide range of different processor architectures.
Index: linux-compile.git/Makefile
===================================================================
--- linux-compile.git.orig/Makefile	2008-01-03 01:02:28.000000000 -0500
+++ linux-compile.git/Makefile	2008-01-03 01:02:39.000000000 -0500
@@ -509,11 +509,15 @@ endif
 
 include $(srctree)/arch/$(SRCARCH)/Makefile
 
+ifdef CONFIG_MCOUNT
+KBUILD_CFLAGS	+= -pg -fno-omit-frame-pointer -fno-optimize-sibling-calls
+else
 ifdef CONFIG_FRAME_POINTER
 KBUILD_CFLAGS	+= -fno-omit-frame-pointer -fno-optimize-sibling-calls
 else
 KBUILD_CFLAGS	+= -fomit-frame-pointer
 endif
+endif
 
 ifdef CONFIG_DEBUG_INFO
 KBUILD_CFLAGS	+= -g
Index: linux-compile.git/arch/x86/Kconfig
===================================================================
--- linux-compile.git.orig/arch/x86/Kconfig	2008-01-03 01:02:28.000000000 -0500
+++ linux-compile.git/arch/x86/Kconfig	2008-01-03 01:02:33.000000000 -0500
@@ -28,6 +28,12 @@ config GENERIC_CMOS_UPDATE
 	bool
 	default y
 
+# function tracing might turn this off:
+config REGPARM
+	bool
+	depends on !MCOUNT
+	default y
+
 config CLOCKSOURCE_WATCHDOG
 	bool
 	default y
Index: linux-compile.git/arch/x86/Makefile_32
===================================================================
--- linux-compile.git.orig/arch/x86/Makefile_32	2008-01-03 01:02:28.000000000 -0500
+++ linux-compile.git/arch/x86/Makefile_32	2008-01-03 01:02:33.000000000 -0500
@@ -37,7 +37,7 @@ LDFLAGS_vmlinux := --emit-relocs
 endif
 CHECKFLAGS	+= -D__i386__
 
-KBUILD_CFLAGS += -pipe -msoft-float -mregparm=3 -freg-struct-return
+KBUILD_CFLAGS += -pipe -msoft-float
 
 # prevent gcc from keeping the stack 16 byte aligned
 KBUILD_CFLAGS += $(call cc-option,-mpreferred-stack-boundary=2)
@@ -45,6 +45,8 @@ KBUILD_CFLAGS += $(call cc-option,-mpref
 # CPU-specific tuning. Anything which can be shared with UML should go here.
 include $(srctree)/arch/x86/Makefile_32.cpu
 
+cflags-$(CONFIG_REGPARM) += -mregparm=3 -freg-struct-return
+
 # temporary until string.h is fixed
 cflags-y += -ffreestanding
 
Index: linux-compile.git/arch/x86/kernel/Makefile_32
===================================================================
--- linux-compile.git.orig/arch/x86/kernel/Makefile_32	2008-01-03 01:02:28.000000000 -0500
+++ linux-compile.git/arch/x86/kernel/Makefile_32	2008-01-03 01:02:33.000000000 -0500
@@ -23,6 +23,7 @@ obj-$(CONFIG_APM)		+= apm_32.o
 obj-$(CONFIG_X86_SMP)		+= smp_32.o smpboot_32.o tsc_sync.o
 obj-$(CONFIG_SMP)		+= smpcommon_32.o
 obj-$(CONFIG_X86_TRAMPOLINE)	+= trampoline_32.o
+obj-$(CONFIG_MCOUNT)		+= mcount-wrapper.o
 obj-$(CONFIG_X86_MPPARSE)	+= mpparse_32.o
 obj-$(CONFIG_X86_LOCAL_APIC)	+= apic_32.o nmi_32.o
 obj-$(CONFIG_X86_IO_APIC)	+= io_apic_32.o
Index: linux-compile.git/arch/x86/kernel/mcount-wrapper.S
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-compile.git/arch/x86/kernel/mcount-wrapper.S	2008-01-03 01:02:33.000000000 -0500
@@ -0,0 +1,25 @@
+/*
+ *  linux/arch/x86/mcount-wrapper.S
+ *
+ *  Copyright (C) 2004 Ingo Molnar
+ */
+
+.globl mcount
+mcount:
+	cmpl $0, mcount_enabled
+	jz out
+
+	push %ebp
+	mov %esp, %ebp
+	pushl %eax
+	pushl %ecx
+	pushl %edx
+
+	call __mcount
+
+	popl %edx
+	popl %ecx
+	popl %eax
+	popl %ebp
+out:
+	ret
Index: linux-compile.git/include/linux/linkage.h
===================================================================
--- linux-compile.git.orig/include/linux/linkage.h	2008-01-03 01:02:28.000000000 -0500
+++ linux-compile.git/include/linux/linkage.h	2008-01-03 01:02:33.000000000 -0500
@@ -3,6 +3,8 @@
 
 #include <asm/linkage.h>
 
+#define notrace __attribute__((no_instrument_function))
+
 #ifdef __cplusplus
 #define CPP_ASMLINKAGE extern "C"
 #else
Index: linux-compile.git/kernel/sysctl.c
===================================================================
--- linux-compile.git.orig/kernel/sysctl.c	2008-01-03 01:02:28.000000000 -0500
+++ linux-compile.git/kernel/sysctl.c	2008-01-03 01:02:33.000000000 -0500
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
--- linux-compile.git.orig/lib/Kconfig.debug	2008-01-03 01:02:28.000000000 -0500
+++ linux-compile.git/lib/Kconfig.debug	2008-01-03 01:02:33.000000000 -0500
@@ -517,4 +517,6 @@ config FAULT_INJECTION_STACKTRACE_FILTER
 	help
 	  Provide stacktrace filter for fault-injection capabilities
 
+source lib/mcount/Kconfig
+
 source "samples/Kconfig"
Index: linux-compile.git/lib/Makefile
===================================================================
--- linux-compile.git.orig/lib/Makefile	2008-01-03 01:02:28.000000000 -0500
+++ linux-compile.git/lib/Makefile	2008-01-03 01:02:33.000000000 -0500
@@ -66,6 +66,8 @@ obj-$(CONFIG_AUDIT_GENERIC) += audit.o
 obj-$(CONFIG_SWIOTLB) += swiotlb.o
 obj-$(CONFIG_FAULT_INJECTION) += fault-inject.o
 
+obj-$(CONFIG_MCOUNT) += mcount/
+
 lib-$(CONFIG_GENERIC_BUG) += bug.o
 
 hostprogs-y	:= gen_crc32table
Index: linux-compile.git/lib/mcount/Kconfig
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-compile.git/lib/mcount/Kconfig	2008-01-03 01:02:33.000000000 -0500
@@ -0,0 +1,6 @@
+
+# MCOUNT itself is useless, or will just be added overhead.
+# It needs something to register a function with it.
+config MCOUNT
+	bool
+	depends on DEBUG_KERNEL
Index: linux-compile.git/lib/mcount/Makefile
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-compile.git/lib/mcount/Makefile	2008-01-03 01:02:33.000000000 -0500
@@ -0,0 +1,3 @@
+obj-$(CONFIG_MCOUNT) += libmcount.o
+
+libmcount-objs := mcount.o
Index: linux-compile.git/lib/mcount/mcount.c
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-compile.git/lib/mcount/mcount.c	2008-01-03 01:02:33.000000000 -0500
@@ -0,0 +1,78 @@
+/*
+ * Infrastructure for profiling code inserted by 'gcc -pg'.
+ *
+ * Copyright (C) 2007 Arnaldo Carvalho de Melo <acme@redhat.com>
+ *
+ * Converted to be more generic:
+ *   Copyright (C) 2007-2008 Steven Rostedt <srostedt@redhat.com>
+ *
+ * From code in the latency_tracer, that is:
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
+mcount_func_t mcount_trace_function = dummy_mcount_tracer;
+int mcount_enabled;
+
+/** __mcount - hook for profiling
+ *
+ * This routine is called from the arch specific mcount routine, that in turn is
+ * called from code inserted by gcc -pg.
+ */
+notrace void __mcount(void)
+{
+	if (mcount_trace_function != dummy_mcount_tracer)
+		mcount_trace_function(CALLER_ADDR1, CALLER_ADDR2);
+}
+EXPORT_SYMBOL_GPL(mcount);
+/*
+ * The above EXPORT_SYMBOL is for the gcc call of mcount and not the
+ * function __mcount that it is underneath. I put the export there
+ * to fool checkpatch.pl. It wants that export to be with the
+ * function, but that function happens to be in assembly.
+ */
+
+/**
+ * register_mcount_function - register a function for profiling
+ * @func - the function for profiling.
+ *
+ * Register a function to be called by all functions in the
+ * kernel.
+ *
+ * Note: @func and all the functions it calls must be labeled
+ *       with "notrace", otherwise it will go into a
+ *       recursive loop.
+ */
+int register_mcount_function(mcount_func_t func)
+{
+	mcount_trace_function = func;
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
Index: linux-compile.git/include/linux/mcount.h
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-compile.git/include/linux/mcount.h	2008-01-03 01:02:33.000000000 -0500
@@ -0,0 +1,21 @@
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
+extern void mcount(void);
+
+int register_mcount_function(mcount_func_t func);
+void clear_mcount_function(void);
+
+#endif /* CONFIG_MCOUNT */
+#endif /* _LINUX_MCOUNT_H */
Index: linux-compile.git/arch/x86/kernel/entry_64.S
===================================================================
--- linux-compile.git.orig/arch/x86/kernel/entry_64.S	2008-01-03 01:02:28.000000000 -0500
+++ linux-compile.git/arch/x86/kernel/entry_64.S	2008-01-03 01:02:33.000000000 -0500
@@ -53,6 +53,52 @@
 
 	.code64
 
+#ifdef CONFIG_MCOUNT
+
+ENTRY(mcount)
+	cmpl $0, mcount_enabled
+	jz out
+
+	push %rbp
+
+	lea dummy_mcount_tracer, %rbp
+	cmpq %rbp, mcount_trace_function
+	jz out_rbp
+
+	mov %rsp,%rbp
+
+	push %r11
+	push %r10
+	push %r9
+	push %r8
+	push %rdi
+	push %rsi
+	push %rdx
+	push %rcx
+	push %rax
+
+	mov 0x0(%rbp),%rax
+	mov 0x8(%rbp),%rdi
+	mov 0x8(%rax),%rsi
+
+	call   *mcount_trace_function
+
+	pop %rax
+	pop %rcx
+	pop %rdx
+	pop %rsi
+	pop %rdi
+	pop %r8
+	pop %r9
+	pop %r10
+	pop %r11
+
+out_rbp:
+	pop %rbp
+out:
+	ret
+#endif
+
 #ifndef CONFIG_PREEMPT
 #define retint_kernel retint_restore_args
 #endif	

-- 
