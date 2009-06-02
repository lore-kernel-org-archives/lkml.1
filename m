Return-Path: <linux-kernel-owner+w=401wt.eu-S1760598AbZFBLGA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760598AbZFBLGA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jun 2009 07:06:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759893AbZFBLFV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Jun 2009 07:05:21 -0400
Received: from mtagate3.uk.ibm.com ([195.212.29.136]:56305 "EHLO
	mtagate3.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759093AbZFBLFR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jun 2009 07:05:17 -0400
Message-Id: <20090602110512.792641005@de.ibm.com>
References: <20090602105311.591592481@de.ibm.com>
User-Agent: quilt/0.46-1
Date: Tue, 02 Jun 2009 12:53:15 +0200
From: Heiko Carstens <heiko.carstens@de.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Steven Rostedt <rostedt@goodmis.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>,
       Heiko Carstens <heiko.carstens@de.ibm.com>
Subject: [PATCH/RFC 4/4] add dynamic ftrace support
Content-Disposition: inline; filename=203-dynamic-ftrace.diff
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Heiko Carstens <heiko.carstens@de.ibm.com>

Dynamic ftrace support for s390.

Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>
---

 arch/s390/Kconfig               |    2 
 arch/s390/include/asm/ftrace.h  |   19 +++++
 arch/s390/include/asm/lowcore.h |    8 +-
 arch/s390/kernel/Makefile       |    5 +
 arch/s390/kernel/early.c        |    4 +
 arch/s390/kernel/ftrace.c       |  132 ++++++++++++++++++++++++++++++++++++++++
 arch/s390/kernel/mcount.S       |  119 +++++++++++++++++++++++++++---------
 arch/s390/kernel/setup.c        |    2 
 arch/s390/kernel/smp.c          |    1 
 scripts/recordmcount.pl         |   13 +++
 10 files changed, 276 insertions(+), 29 deletions(-)

Index: linux-2.6/arch/s390/include/asm/ftrace.h
===================================================================
--- linux-2.6.orig/arch/s390/include/asm/ftrace.h
+++ linux-2.6/arch/s390/include/asm/ftrace.h
@@ -2,7 +2,26 @@
 #define _ASM_S390_FTRACE_H
 
 #ifndef __ASSEMBLY__
+
 extern void _mcount(void);
+extern unsigned long ftrace_dyn_func;
+
+struct dyn_arch_ftrace { };
+
+#define MCOUNT_ADDR ((long)_mcount)
+
+#ifdef CONFIG_64BIT
+#define MCOUNT_INSN_SIZE 24
+#define MCOUNT_OFFSET	 14
+#else
+#define MCOUNT_INSN_SIZE 30
+#define MCOUNT_OFFSET	  8
 #endif
 
+static inline unsigned long ftrace_call_adjust(unsigned long addr)
+{
+	return addr - MCOUNT_OFFSET;
+}
+
+#endif /* __ASSEMBLY__ */
 #endif /* _ASM_S390_FTRACE_H */
Index: linux-2.6/arch/s390/include/asm/lowcore.h
===================================================================
--- linux-2.6.orig/arch/s390/include/asm/lowcore.h
+++ linux-2.6/arch/s390/include/asm/lowcore.h
@@ -67,6 +67,7 @@
 #define __LC_CPUID			0x02b0
 #define __LC_INT_CLOCK			0x02c8
 #define __LC_MACHINE_FLAGS		0x02d8
+#define __LC_FTRACE_FUNC		0x02dc
 #define __LC_IRB			0x0300
 #define __LC_PFAULT_INTPARM		0x0080
 #define __LC_CPU_TIMER_SAVE_AREA	0x00d8
@@ -112,6 +113,7 @@
 #define __LC_INT_CLOCK			0x0340
 #define __LC_VDSO_PER_CPU		0x0350
 #define __LC_MACHINE_FLAGS		0x0358
+#define __LC_FTRACE_FUNC		0x0360
 #define __LC_IRB			0x0380
 #define __LC_PASTE			0x03c0
 #define __LC_PFAULT_INTPARM		0x11b8
@@ -280,7 +282,8 @@ struct _lowcore
 	__u64	int_clock;			/* 0x02c8 */
 	__u64	clock_comparator;		/* 0x02d0 */
 	__u32	machine_flags;			/* 0x02d8 */
-	__u8	pad_0x02dc[0x0300-0x02dc];	/* 0x02dc */
+	__u32	ftrace_func;			/* 0x02dc */
+	__u8	pad_0x02f0[0x0300-0x02f0];	/* 0x02f0 */
 
 	/* Interrupt response block */
 	__u8	irb[64];			/* 0x0300 */
@@ -385,7 +388,8 @@ struct _lowcore
 	__u64	clock_comparator;		/* 0x0348 */
 	__u64	vdso_per_cpu_data;		/* 0x0350 */
 	__u64	machine_flags;			/* 0x0358 */
-	__u8	pad_0x0360[0x0380-0x0360];	/* 0x0360 */
+	__u64	ftrace_func;			/* 0x0360 */
+	__u8	pad_0x0368[0x0380-0x0368];	/* 0x0368 */
 
 	/* Interrupt response block. */
 	__u8	irb[64];			/* 0x0380 */
Index: linux-2.6/arch/s390/Kconfig
===================================================================
--- linux-2.6.orig/arch/s390/Kconfig
+++ linux-2.6/arch/s390/Kconfig
@@ -82,6 +82,8 @@ config S390
 	select USE_GENERIC_SMP_HELPERS if SMP
 	select HAVE_SYSCALL_WRAPPERS
 	select HAVE_FUNCTION_TRACER
+	select HAVE_FTRACE_MCOUNT_RECORD
+	select HAVE_DYNAMIC_FTRACE
 	select HAVE_DEFAULT_NO_SPIN_MUTEXES
 	select HAVE_OPROFILE
 	select HAVE_KPROBES
Index: linux-2.6/arch/s390/kernel/early.c
===================================================================
--- linux-2.6.orig/arch/s390/kernel/early.c
+++ linux-2.6/arch/s390/kernel/early.c
@@ -11,6 +11,7 @@
 #include <linux/errno.h>
 #include <linux/string.h>
 #include <linux/ctype.h>
+#include <linux/ftrace.h>
 #include <linux/lockdep.h>
 #include <linux/module.h>
 #include <linux/pfn.h>
@@ -410,5 +411,8 @@ void __init startup_init(void)
 	sclp_facilities_detect();
 	detect_memory_layout(memory_chunk);
 	S390_lowcore.machine_flags = machine_flags;
+#ifdef CONFIG_DYNAMIC_FTRACE
+	S390_lowcore.ftrace_func = (unsigned long)ftrace_caller;
+#endif
 	lockdep_on();
 }
Index: linux-2.6/arch/s390/kernel/ftrace.c
===================================================================
--- /dev/null
+++ linux-2.6/arch/s390/kernel/ftrace.c
@@ -0,0 +1,132 @@
+/*
+ * Dynamic function tracer architecture backend.
+ *
+ * Copyright IBM Corp. 2009
+ *
+ *   Author(s): Heiko Carstens <heiko.carstens@de.ibm.com>,
+ *
+ */
+
+#include <linux/uaccess.h>
+#include <linux/ftrace.h>
+#include <linux/kernel.h>
+#include <linux/types.h>
+#include <asm/lowcore.h>
+
+void ftrace_disable_code(void);
+void ftrace_call_code(void);
+void ftrace_nop_code(void);
+
+#define FTRACE_INSN_SIZE 4
+
+#ifdef CONFIG_64BIT
+
+asm(
+	"	.align	4\n"
+	"ftrace_disable_code:\n"
+	"	j	0f\n"
+	"	.word	0x0024\n"
+	"	lg	%r1,"__stringify(__LC_FTRACE_FUNC)"\n"
+	"	basr	%r14,%r1\n"
+	"	lg	%r14,8(15)\n"
+	"	lgr	%r0,%r0\n"
+	"0:\n");
+
+asm(
+	"	.align	4\n"
+	"ftrace_nop_code:\n"
+	"	j	.+"__stringify(MCOUNT_INSN_SIZE)"\n");
+
+asm(
+	"	.align	4\n"
+	"ftrace_call_code:\n"
+	"	stg	%r14,8(%r15)\n");
+
+#else /* CONFIG_64BIT */
+
+asm(
+	"	.align	4\n"
+	"ftrace_disable_code:\n"
+	"	j	0f\n"
+	"	l	%r1,"__stringify(__LC_FTRACE_FUNC)"\n"
+	"	basr	%r14,%r1\n"
+	"	l	%r14,4(%r15)\n"
+	"	j	0f\n"
+	"	bcr	0,%r7\n"
+	"	bcr	0,%r7\n"
+	"	bcr	0,%r7\n"
+	"	bcr	0,%r7\n"
+	"	bcr	0,%r7\n"
+	"	bcr	0,%r7\n"
+	"0:\n");
+
+asm(
+	"	.align	4\n"
+	"ftrace_nop_code:\n"
+	"	j	.+"__stringify(MCOUNT_INSN_SIZE)"\n");
+
+asm(
+	"	.align	4\n"
+	"ftrace_call_code:\n"
+	"	st	%r14,4(%r15)\n");
+
+#endif /* CONFIG_64BIT */
+
+static int ftrace_modify_code(unsigned long ip,
+			      void *old_code, int old_size,
+			      void *new_code, int new_size)
+{
+	unsigned char replaced[MCOUNT_INSN_SIZE];
+
+	/*
+	 * Note: Due to modules code can disappear and change.
+	 *  We need to protect against faulting as well as code
+	 *  changing. We do this by using the probe_kernel_*
+	 *  functions.
+	 *  This however is just a simple sanity check.
+	 */
+	if (probe_kernel_read(replaced, (void *)ip, old_size))
+		return -EFAULT;
+	if (memcmp(replaced, old_code, old_size) != 0)
+		return -EINVAL;
+	if (probe_kernel_write((void *)ip, new_code, new_size))
+		return -EPERM;
+	return 0;
+}
+
+static int ftrace_make_initial_nop(struct module *mod, struct dyn_ftrace *rec,
+				   unsigned long addr)
+{
+	return ftrace_modify_code(rec->ip,
+				  ftrace_call_code, FTRACE_INSN_SIZE,
+				  ftrace_disable_code, MCOUNT_INSN_SIZE);
+}
+
+int ftrace_make_nop(struct module *mod, struct dyn_ftrace *rec,
+		    unsigned long addr)
+{
+	if (addr == MCOUNT_ADDR)
+		return ftrace_make_initial_nop(mod, rec, addr);
+	return ftrace_modify_code(rec->ip,
+				  ftrace_call_code, FTRACE_INSN_SIZE,
+				  ftrace_nop_code, FTRACE_INSN_SIZE);
+}
+
+int ftrace_make_call(struct dyn_ftrace *rec, unsigned long addr)
+{
+	return ftrace_modify_code(rec->ip,
+				  ftrace_nop_code, FTRACE_INSN_SIZE,
+				  ftrace_call_code, FTRACE_INSN_SIZE);
+}
+
+int ftrace_update_ftrace_func(ftrace_func_t func)
+{
+	ftrace_dyn_func = (unsigned long)func;
+	return 0;
+}
+
+int __init ftrace_dyn_arch_init(void *data)
+{
+	*(unsigned long *)data = 0;
+	return 0;
+}
Index: linux-2.6/arch/s390/kernel/Makefile
===================================================================
--- linux-2.6.orig/arch/s390/kernel/Makefile
+++ linux-2.6/arch/s390/kernel/Makefile
@@ -7,6 +7,10 @@ ifdef CONFIG_FUNCTION_TRACER
 CFLAGS_REMOVE_early.o = -pg
 endif
 
+ifdef CONFIG_DYNAMIC_FTRACE
+CFLAGS_REMOVE_ftrace.o = -pg
+endif
+
 #
 # Passing null pointers is ok for smp code, since we access the lowcore here.
 #
@@ -41,6 +45,7 @@ obj-$(CONFIG_COMPAT)		+= compat_linux.o 
 obj-$(CONFIG_STACKTRACE)	+= stacktrace.o
 obj-$(CONFIG_KPROBES)		+= kprobes.o
 obj-$(CONFIG_FUNCTION_TRACER)	+= mcount.o
+obj-$(CONFIG_DYNAMIC_FTRACE)	+= ftrace.o
 
 # Kexec part
 S390_KEXEC_OBJS := machine_kexec.o crash.o
Index: linux-2.6/arch/s390/kernel/mcount.S
===================================================================
--- linux-2.6.orig/arch/s390/kernel/mcount.S
+++ linux-2.6/arch/s390/kernel/mcount.S
@@ -1,5 +1,5 @@
 /*
- * Copyright IBM Corp. 2008
+ * Copyright IBM Corp. 2008,2009
  *
  *   Author(s): Heiko Carstens <heiko.carstens@de.ibm.com>,
  *
@@ -7,36 +7,46 @@
 
 #include <asm/asm-offsets.h>
 
-#ifndef CONFIG_64BIT
-.globl _mcount
+	.globl ftrace_stub
+ftrace_stub:
+	br	%r14
+
+#ifdef CONFIG_64BIT
+
+#ifdef CONFIG_DYNAMIC_FTRACE
+
+	.globl _mcount
 _mcount:
-	stm	%r0,%r5,8(%r15)
-	st	%r14,56(%r15)
-	lr	%r1,%r15
-	ahi	%r15,-96
-	l	%r3,100(%r15)
-	la	%r2,0(%r14)
-	st	%r1,__SF_BACKCHAIN(%r15)
-	la	%r3,0(%r3)
-	bras	%r14,0f
-	.long	ftrace_trace_function
-0:	l	%r14,0(%r14)
-	l	%r14,0(%r14)
-	basr	%r14,%r14
-	ahi	%r15,96
-	lm	%r0,%r5,8(%r15)
-	l	%r14,56(%r15)
 	br	%r14
 
-.globl ftrace_stub
-ftrace_stub:
+	.globl ftrace_caller
+ftrace_caller:
+	stmg	%r2,%r5,32(%r15)
+	stg	%r14,112(%r15)
+	lgr	%r1,%r15
+	aghi	%r15,-160
+	stg	%r1,__SF_BACKCHAIN(%r15)
+	lgr	%r2,%r14
+	lg	%r3,168(%r15)
+	larl	%r14,ftrace_dyn_func
+	lg	%r14,0(%r14)
+	basr	%r14,%r14
+	aghi	%r15,160
+	lmg	%r2,%r5,32(%r15)
+	lg	%r14,112(%r15)
 	br	%r14
 
-#else /* CONFIG_64BIT */
+	.data
+	.globl	ftrace_dyn_func
+ftrace_dyn_func:
+	.quad	ftrace_stub
+	.previous
+
+#else /* CONFIG_DYNAMIC_FTRACE */
 
-.globl _mcount
+	.globl _mcount
 _mcount:
-	stmg	%r0,%r5,16(%r15)
+	stmg	%r2,%r5,32(%r15)
 	stg	%r14,112(%r15)
 	lgr	%r1,%r15
 	aghi	%r15,-160
@@ -47,12 +57,67 @@ _mcount:
 	lg	%r14,0(%r14)
 	basr	%r14,%r14
 	aghi	%r15,160
-	lmg	%r0,%r5,16(%r15)
+	lmg	%r2,%r5,32(%r15)
 	lg	%r14,112(%r15)
 	br	%r14
 
-.globl ftrace_stub
-ftrace_stub:
+#endif /* CONFIG_DYNAMIC_FTRACE */
+
+#else /* CONFIG_64BIT */
+
+#ifdef CONFIG_DYNAMIC_FTRACE
+
+	.globl _mcount
+_mcount:
+	br	%r14
+
+	.globl ftrace_caller
+ftrace_caller:
+	stm	%r2,%r5,16(%r15)
+	st	%r14,56(%r15)
+	lr	%r1,%r15
+	ahi	%r15,-96
+	l	%r3,100(%r15)
+	la	%r2,0(%r14)
+	st	%r1,__SF_BACKCHAIN(%r15)
+	la	%r3,0(%r3)
+	bras	%r14,0f
+	.long	ftrace_dyn_func
+0:	l	%r14,0(%r14)
+	l	%r14,0(%r14)
+	basr	%r14,%r14
+	ahi	%r15,96
+	lm	%r2,%r5,16(%r15)
+	l	%r14,56(%r15)
+	br	%r14
+
+	.data
+	.globl	ftrace_dyn_func
+ftrace_dyn_func:
+	.long	ftrace_stub
+	.previous
+
+#else /* CONFIG_DYNAMIC_FTRACE */
+
+	.globl _mcount
+_mcount:
+	stm	%r2,%r5,16(%r15)
+	st	%r14,56(%r15)
+	lr	%r1,%r15
+	ahi	%r15,-96
+	l	%r3,100(%r15)
+	la	%r2,0(%r14)
+	st	%r1,__SF_BACKCHAIN(%r15)
+	la	%r3,0(%r3)
+	bras	%r14,0f
+	.long	ftrace_trace_function
+0:	l	%r14,0(%r14)
+	l	%r14,0(%r14)
+	basr	%r14,%r14
+	ahi	%r15,96
+	lm	%r2,%r5,16(%r15)
+	l	%r14,56(%r15)
 	br	%r14
 
+#endif /* CONFIG_DYNAMIC_FTRACE */
 #endif /* CONFIG_64BIT */
Index: linux-2.6/arch/s390/kernel/setup.c
===================================================================
--- linux-2.6.orig/arch/s390/kernel/setup.c
+++ linux-2.6/arch/s390/kernel/setup.c
@@ -42,6 +42,7 @@
 #include <linux/ctype.h>
 #include <linux/reboot.h>
 #include <linux/topology.h>
+#include <linux/ftrace.h>
 
 #include <asm/ipl.h>
 #include <asm/uaccess.h>
@@ -442,6 +443,7 @@ setup_lowcore(void)
 	lc->steal_timer = S390_lowcore.steal_timer;
 	lc->last_update_timer = S390_lowcore.last_update_timer;
 	lc->last_update_clock = S390_lowcore.last_update_clock;
+	lc->ftrace_func = S390_lowcore.ftrace_func;
 	set_prefix((u32)(unsigned long) lc);
 	lowcore_ptr[0] = lc;
 }
Index: linux-2.6/arch/s390/kernel/smp.c
===================================================================
--- linux-2.6.orig/arch/s390/kernel/smp.c
+++ linux-2.6/arch/s390/kernel/smp.c
@@ -572,6 +572,7 @@ int __cpuinit __cpu_up(unsigned int cpu)
 	cpu_lowcore->cpu_nr = cpu;
 	cpu_lowcore->kernel_asce = S390_lowcore.kernel_asce;
 	cpu_lowcore->machine_flags = S390_lowcore.machine_flags;
+	cpu_lowcore->ftrace_func = S390_lowcore.ftrace_func;
 	eieio();
 
 	while (signal_processor(cpu, sigp_restart) == sigp_busy)
Index: linux-2.6/scripts/recordmcount.pl
===================================================================
--- linux-2.6.orig/scripts/recordmcount.pl
+++ linux-2.6/scripts/recordmcount.pl
@@ -185,6 +185,19 @@ if ($arch eq "x86_64") {
     $objcopy .= " -O elf32-i386";
     $cc .= " -m32";
 
+} elsif ($arch eq "s390" && $bits == 32) {
+    $mcount_regex = "^\\s*([0-9a-fA-F]+):\\s*R_390_32\\s+_mcount\$";
+    $alignment = 4;
+    $ld .= " -m elf_s390";
+    $cc .= " -m31";
+
+} elsif ($arch eq "s390" && $bits == 64) {
+    $mcount_regex = "^\\s*([0-9a-fA-F]+):\\s*R_390_(PC|PLT)32DBL\\s+_mcount\\+0x2\$";
+    $alignment = 8;
+    $type = ".quad";
+    $ld .= " -m elf64_s390";
+    $cc .= " -m64";
+
 } elsif ($arch eq "sh") {
     $alignment = 2;
 

-- 
