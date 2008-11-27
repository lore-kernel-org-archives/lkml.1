Return-Path: <linux-kernel-owner+w=401wt.eu-S1755934AbYK0KkS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755934AbYK0KkS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2008 05:40:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753039AbYK0Kcz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Nov 2008 05:32:55 -0500
Received: from mtagate7.de.ibm.com ([195.212.29.156]:62876 "EHLO
	mtagate7.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752752AbYK0KcX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2008 05:32:23 -0500
Message-Id: <20081127103133.957555357@de.ibm.com>
References: <20081127103020.528516828@de.ibm.com>
User-Agent: quilt/0.46-1
Date: Thu, 27 Nov 2008 11:30:42 +0100
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
To: linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>
Subject: [patch 22/60] ftrace: function tracer backend for s390
Content-Disposition: inline; filename=121-func-tracer.diff
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Heiko Carstens <heiko.carstens@de.ibm.com>

This implements just the basic function tracer (_mcount) backend for s390.
The dynamic variant will come later.

Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>
Signed-off-by: Martin Schwidefsky <schwidefsky@de.ibm.com>
---

 arch/s390/Kconfig              |    1 
 arch/s390/include/asm/ftrace.h |    8 +++++
 arch/s390/kernel/Makefile      |    6 ++++
 arch/s390/kernel/mcount.S      |   56 +++++++++++++++++++++++++++++++++++++++++
 arch/s390/kernel/s390_ksyms.c  |    5 +++
 5 files changed, 76 insertions(+)

Index: quilt-2.6/arch/s390/include/asm/ftrace.h
===================================================================
--- /dev/null
+++ quilt-2.6/arch/s390/include/asm/ftrace.h
@@ -0,0 +1,8 @@
+#ifndef _ASM_S390_FTRACE_H
+#define _ASM_S390_FTRACE_H
+
+#ifndef __ASSEMBLY__
+extern void _mcount(void);
+#endif
+
+#endif /* _ASM_S390_FTRACE_H */
Index: quilt-2.6/arch/s390/Kconfig
===================================================================
--- quilt-2.6.orig/arch/s390/Kconfig
+++ quilt-2.6/arch/s390/Kconfig
@@ -74,6 +74,7 @@ mainmenu "Linux Kernel Configuration"
 config S390
 	def_bool y
 	select USE_GENERIC_SMP_HELPERS if SMP
+	select HAVE_FUNCTION_TRACER
 	select HAVE_OPROFILE
 	select HAVE_KPROBES
 	select HAVE_KRETPROBES
Index: quilt-2.6/arch/s390/kernel/Makefile
===================================================================
--- quilt-2.6.orig/arch/s390/kernel/Makefile
+++ quilt-2.6/arch/s390/kernel/Makefile
@@ -2,6 +2,11 @@
 # Makefile for the linux kernel.
 #
 
+ifdef CONFIG_FUNCTION_TRACER
+# Do not trace early boot code
+CFLAGS_REMOVE_early.o = -pg
+endif
+
 #
 # Passing null pointers is ok for smp code, since we access the lowcore here.
 #
@@ -34,6 +39,7 @@ obj-$(CONFIG_COMPAT)		+= compat_linux.o 
 obj-$(CONFIG_VIRT_TIMER)	+= vtime.o
 obj-$(CONFIG_STACKTRACE)	+= stacktrace.o
 obj-$(CONFIG_KPROBES)		+= kprobes.o
+obj-$(CONFIG_FUNCTION_TRACER)	+= mcount.o
 
 # Kexec part
 S390_KEXEC_OBJS := machine_kexec.o crash.o
Index: quilt-2.6/arch/s390/kernel/mcount.S
===================================================================
--- /dev/null
+++ quilt-2.6/arch/s390/kernel/mcount.S
@@ -0,0 +1,56 @@
+/*
+ * Copyright IBM Corp. 2008
+ *
+ *   Author(s): Heiko Carstens <heiko.carstens@de.ibm.com>,
+ *
+ */
+
+#ifndef CONFIG_64BIT
+.globl _mcount
+_mcount:
+	stm	%r0,%r5,8(%r15)
+	st	%r14,56(%r15)
+	lr	%r1,%r15
+	ahi	%r15,-96
+	l	%r3,100(%r15)
+	la	%r2,0(%r14)
+	st	%r1,0(%r15)
+	la	%r3,0(%r3)
+	bras	%r14,0f
+	.long	ftrace_trace_function
+0:	l	%r14,0(%r14)
+	l	%r14,0(%r14)
+	basr	%r14,%r14
+	ahi	%r15,96
+	lm	%r0,%r5,8(%r15)
+	l	%r14,56(%r15)
+	br	%r14
+
+.globl ftrace_stub
+ftrace_stub:
+	br	%r14
+
+#else /* CONFIG_64BIT */
+
+.globl _mcount
+_mcount:
+	stmg	%r0,%r5,16(%r15)
+	stg	%r14,112(%r15)
+	lgr	%r1,%r15
+	aghi	%r15,-160
+	stg	%r1,0(%r15)
+	lgr	%r2,%r14
+	lg	%r3,168(%r15)
+	larl	%r14,ftrace_trace_function
+	lg	%r14,0(%r14)
+	basr	%r14,%r14
+	aghi	%r15,160
+	lmg	%r0,%r5,16(%r15)
+	lg	%r14,112(%r15)
+	br	%r14
+
+.globl ftrace_stub
+ftrace_stub:
+	br	%r14
+
+#endif /* CONFIG_64BIT */
Index: quilt-2.6/arch/s390/kernel/s390_ksyms.c
===================================================================
--- quilt-2.6.orig/arch/s390/kernel/s390_ksyms.c
+++ quilt-2.6/arch/s390/kernel/s390_ksyms.c
@@ -14,6 +14,7 @@
 #include <asm/delay.h>
 #include <asm/pgalloc.h>
 #include <asm/setup.h>
+#include <asm/ftrace.h>
 #ifdef CONFIG_IP_MULTICAST
 #include <net/arp.h>
 #endif
@@ -43,3 +44,7 @@ EXPORT_SYMBOL(csum_fold);
 EXPORT_SYMBOL(console_mode);
 EXPORT_SYMBOL(console_devno);
 EXPORT_SYMBOL(console_irq);
+
+#ifdef CONFIG_FUNCTION_TRACER
+EXPORT_SYMBOL(_mcount);
+#endif

-- 
blue skies,
   Martin.

"Reality continues to ruin my life." - Calvin.

