Return-Path: <linux-kernel-owner+w=401wt.eu-S933229AbYBTTfp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933229AbYBTTfp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2008 14:35:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765795AbYBTTeT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Feb 2008 14:34:19 -0500
Received: from mail.windriver.com ([147.11.1.11]:53101 "EHLO mail.wrs.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1765496AbYBTTeN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2008 14:34:13 -0500
From: Jason Wessel <jason.wessel@windriver.com>
To: mingo@elte.hu
Cc: linux-kernel@vger.kernel.org, Jason Wessel <jason.wessel@windriver.com>
Subject: [PATCH 3/3] kgdb: support for ARCH=arm
Date: Wed, 20 Feb 2008 13:33:40 -0600
Message-Id: <1203536020-20102-4-git-send-email-jason.wessel@windriver.com>
X-Mailer: git-send-email 1.5.4
In-Reply-To: <1203536020-20102-3-git-send-email-jason.wessel@windriver.com>
References: <1203536020-20102-1-git-send-email-jason.wessel@windriver.com>
 <1203536020-20102-2-git-send-email-jason.wessel@windriver.com>
 <1203536020-20102-3-git-send-email-jason.wessel@windriver.com>
X-OriginalArrivalTime: 20 Feb 2008 19:33:42.0250 (UTC) FILETIME=[800CD4A0:01C873F7]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds the ARCH=arm specific a kgdb backend, originally
written by Deepak Saxena <dsaxena@plexity.net> and George Davis
<gdavis@mvista.com>.  Geoff Levand <geoffrey.levand@am.sony.com>,
Nicolas Pitre, and Manish Lachwani have contributed various fixups
here as well.

The changes to setup the traps earlier allow for early debugging with
a uart based KGDB I/O driver.  The do_undefinstr() routine also needed
to allow the lookup of kernel address space in order for the debugger
to plant undefined instructions in kernel memory space and receive the
correct notification.

Signed-off-by: Jason Wessel <jason.wessel@windriver.com>
---
 arch/arm/Kconfig         |    1 +
 arch/arm/kernel/Makefile |    1 +
 arch/arm/kernel/kgdb.c   |  219 ++++++++++++++++++++++++++++++++++++++++++++++
 arch/arm/kernel/setup.c  |    5 +
 arch/arm/kernel/traps.c  |   11 +++
 include/asm-arm/kgdb.h   |  101 +++++++++++++++++++++
 include/asm-arm/traps.h  |    2 +
 7 files changed, 340 insertions(+), 0 deletions(-)
 create mode 100644 arch/arm/kernel/kgdb.c
 create mode 100644 include/asm-arm/kgdb.h

diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
index 9619c43..9e2e631 100644
--- a/arch/arm/Kconfig
+++ b/arch/arm/Kconfig
@@ -11,6 +11,7 @@ config ARM
 	select RTC_LIB
 	select SYS_SUPPORTS_APM_EMULATION
 	select HAVE_OPROFILE
+	select HAVE_ARCH_KGDB
 	select HAVE_KPROBES if (!XIP_KERNEL)
 	help
 	  The ARM series is a line of low-power-consumption RISC chip designs
diff --git a/arch/arm/kernel/Makefile b/arch/arm/kernel/Makefile
index 00d44c6..9bb17e6 100644
--- a/arch/arm/kernel/Makefile
+++ b/arch/arm/kernel/Makefile
@@ -22,6 +22,7 @@ obj-$(CONFIG_KEXEC)		+= machine_kexec.o relocate_kernel.o
 obj-$(CONFIG_KPROBES)		+= kprobes.o kprobes-decode.o
 obj-$(CONFIG_ATAGS_PROC)	+= atags.o
 obj-$(CONFIG_OABI_COMPAT)	+= sys_oabi-compat.o
+obj-$(CONFIG_KGDB)		+= kgdb.o
 
 obj-$(CONFIG_CRUNCH)		+= crunch.o crunch-bits.o
 AFLAGS_crunch-bits.o		:= -Wa,-mcpu=ep9312
diff --git a/arch/arm/kernel/kgdb.c b/arch/arm/kernel/kgdb.c
new file mode 100644
index 0000000..4f5b297
--- /dev/null
+++ b/arch/arm/kernel/kgdb.c
@@ -0,0 +1,219 @@
+/*
+ * arch/arm/kernel/kgdb.c
+ *
+ * ARM KGDB support
+ *
+ * Copyright (c) 2002-2004 MontaVista Software, Inc
+ * Copyright (c) 2008 Wind River Systems, Inc.
+ *
+ * Authors:  George Davis <davis_g@mvista.com>
+ *           Deepak Saxena <dsaxena@plexity.net>
+ */
+#include <linux/types.h>
+#include <linux/kernel.h>
+#include <linux/signal.h>
+#include <linux/sched.h>
+#include <linux/mm.h>
+#include <linux/spinlock.h>
+#include <linux/personality.h>
+#include <linux/ptrace.h>
+#include <linux/elf.h>
+#include <linux/interrupt.h>
+#include <linux/init.h>
+#include <linux/kgdb.h>
+#include <linux/io.h>
+#include <linux/uaccess.h>
+#include <linux/unistd.h>
+
+#include <asm/atomic.h>
+#include <asm/pgtable.h>
+#include <asm/system.h>
+#include <asm/traps.h>
+
+/* Make a local copy of the registers passed into the handler (bletch) */
+void pt_regs_to_gdb_regs(unsigned long *gdb_regs, struct pt_regs *kernel_regs)
+{
+	int regno;
+
+	/* Initialize all to zero. */
+	for (regno = 0; regno < GDB_MAX_REGS; regno++)
+		gdb_regs[regno] = 0;
+
+	gdb_regs[_R0] = kernel_regs->ARM_r0;
+	gdb_regs[_R1] = kernel_regs->ARM_r1;
+	gdb_regs[_R2] = kernel_regs->ARM_r2;
+	gdb_regs[_R3] = kernel_regs->ARM_r3;
+	gdb_regs[_R4] = kernel_regs->ARM_r4;
+	gdb_regs[_R5] = kernel_regs->ARM_r5;
+	gdb_regs[_R6] = kernel_regs->ARM_r6;
+	gdb_regs[_R7] = kernel_regs->ARM_r7;
+	gdb_regs[_R8] = kernel_regs->ARM_r8;
+	gdb_regs[_R9] = kernel_regs->ARM_r9;
+	gdb_regs[_R10] = kernel_regs->ARM_r10;
+	gdb_regs[_FP] = kernel_regs->ARM_fp;
+	gdb_regs[_IP] = kernel_regs->ARM_ip;
+	gdb_regs[_SPT] = kernel_regs->ARM_sp;
+	gdb_regs[_LR] = kernel_regs->ARM_lr;
+	gdb_regs[_PC] = kernel_regs->ARM_pc;
+	gdb_regs[_CPSR] = kernel_regs->ARM_cpsr;
+}
+
+/* Copy local gdb registers back to kgdb regs, for later copy to kernel */
+void gdb_regs_to_pt_regs(unsigned long *gdb_regs, struct pt_regs *kernel_regs)
+{
+	kernel_regs->ARM_r0 = gdb_regs[_R0];
+	kernel_regs->ARM_r1 = gdb_regs[_R1];
+	kernel_regs->ARM_r2 = gdb_regs[_R2];
+	kernel_regs->ARM_r3 = gdb_regs[_R3];
+	kernel_regs->ARM_r4 = gdb_regs[_R4];
+	kernel_regs->ARM_r5 = gdb_regs[_R5];
+	kernel_regs->ARM_r6 = gdb_regs[_R6];
+	kernel_regs->ARM_r7 = gdb_regs[_R7];
+	kernel_regs->ARM_r8 = gdb_regs[_R8];
+	kernel_regs->ARM_r9 = gdb_regs[_R9];
+	kernel_regs->ARM_r10 = gdb_regs[_R10];
+	kernel_regs->ARM_fp = gdb_regs[_FP];
+	kernel_regs->ARM_ip = gdb_regs[_IP];
+	kernel_regs->ARM_sp = gdb_regs[_SPT];
+	kernel_regs->ARM_lr = gdb_regs[_LR];
+	kernel_regs->ARM_pc = gdb_regs[_PC];
+	kernel_regs->ARM_cpsr = gdb_regs[_CPSR];
+}
+
+void sleeping_thread_to_gdb_regs(unsigned long *gdb_regs,
+				 struct task_struct *task)
+{
+	int regno;
+	struct pt_regs *thread_regs;
+
+	/* Just making sure... */
+	if (task == NULL)
+		return;
+
+	/* Initialize to zero */
+	for (regno = 0; regno < GDB_MAX_REGS; regno++)
+		gdb_regs[regno] = 0;
+
+	/* Otherwise, we have only some registers from switch_to() */
+	thread_regs = task_pt_regs(task);
+	gdb_regs[_R0] = thread_regs->ARM_r0;
+	gdb_regs[_R1] = thread_regs->ARM_r1;
+	gdb_regs[_R2] = thread_regs->ARM_r2;
+	gdb_regs[_R3] = thread_regs->ARM_r3;
+	gdb_regs[_R4] = thread_regs->ARM_r4;
+	gdb_regs[_R5] = thread_regs->ARM_r5;
+	gdb_regs[_R6] = thread_regs->ARM_r6;
+	gdb_regs[_R7] = thread_regs->ARM_r7;
+	gdb_regs[_R8] = thread_regs->ARM_r8;
+	gdb_regs[_R9] = thread_regs->ARM_r9;
+	gdb_regs[_R10] = thread_regs->ARM_r10;
+	gdb_regs[_FP] = thread_regs->ARM_fp;
+	gdb_regs[_IP] = thread_regs->ARM_ip;
+	gdb_regs[_SPT] = thread_regs->ARM_sp;
+	gdb_regs[_LR] = thread_regs->ARM_lr;
+	gdb_regs[_PC] = thread_regs->ARM_pc;
+	gdb_regs[_CPSR] = thread_regs->ARM_cpsr;
+}
+
+static int compiled_break;
+
+int kgdb_arch_handle_exception(int exception_vector, int signo,
+			       int err_code, char *remcom_in_buffer,
+			       char *remcom_out_buffer,
+			       struct pt_regs *linux_regs)
+{
+	long addr;
+	char *ptr;
+
+	switch (remcom_in_buffer[0]) {
+	case 'D':
+	case 'k':
+	case 'c':
+		kgdb_contthread = NULL;
+
+		/*
+		 * Try to read optional parameter, pc unchanged if no parm.
+		 * If this was a compiled breakpoint, we need to move
+		 * to the next instruction or we will just breakpoint
+		 * over and over again.
+		 */
+		ptr = &remcom_in_buffer[1];
+		if (kgdb_hex2long(&ptr, &addr))
+			linux_regs->ARM_pc = addr;
+		else if (compiled_break == 1)
+			linux_regs->ARM_pc += 4;
+
+		compiled_break = 0;
+
+		return 0;
+	}
+
+	return -1;
+}
+
+static int kgdb_brk_fn(struct pt_regs *regs, unsigned int instr)
+{
+	kgdb_handle_exception(1, SIGTRAP, 0, regs);
+
+	return 0;
+}
+
+static int kgdb_compiled_brk_fn(struct pt_regs *regs, unsigned int instr)
+{
+	compiled_break = 1;
+	kgdb_handle_exception(1, SIGTRAP, 0, regs);
+
+	return 0;
+}
+
+static struct undef_hook kgdb_brkpt_hook = {
+	.instr_mask = 0xffffffff,
+	.instr_val = KGDB_BREAKINST,
+	.fn = kgdb_brk_fn
+};
+
+static struct undef_hook kgdb_compiled_brkpt_hook = {
+	.instr_mask = 0xffffffff,
+	.instr_val = KGDB_COMPILED_BREAK,
+	.fn = kgdb_compiled_brk_fn
+};
+
+/**
+ *	kgdb_arch_init - Perform any architecture specific initalization.
+ *
+ *	This function will handle the initalization of any architecture
+ *	specific callbacks.
+ */
+int kgdb_arch_init(void)
+{
+	register_undef_hook(&kgdb_brkpt_hook);
+	register_undef_hook(&kgdb_compiled_brkpt_hook);
+
+	return 0;
+}
+
+/**
+ *	kgdb_arch_exit - Perform any architecture specific uninitalization.
+ *
+ *	This function will handle the uninitalization of any architecture
+ *	specific callbacks, for dynamic registration and unregistration.
+ */
+void kgdb_arch_exit(void)
+{
+	unregister_undef_hook(&kgdb_brkpt_hook);
+	unregister_undef_hook(&kgdb_compiled_brkpt_hook);
+}
+/*
+ * Register our undef instruction hooks with ARM undef core.
+ * We regsiter a hook specifically looking for the KGB break inst
+ * and we handle the normal undef case within the do_undefinstr
+ * handler.
+ */
+
+struct kgdb_arch arch_kgdb_ops = {
+#ifndef __ARMEB__
+	.gdb_bpt_instr = {0xfe, 0xde, 0xff, 0xe7}
+#else /* ! __ARMEB__ */
+	.gdb_bpt_instr = {0xe7, 0xff, 0xde, 0xfe}
+#endif
+};
diff --git a/arch/arm/kernel/setup.c b/arch/arm/kernel/setup.c
index b7b0720..3385cb5 100644
--- a/arch/arm/kernel/setup.c
+++ b/arch/arm/kernel/setup.c
@@ -36,6 +36,7 @@
 #include <asm/mach/arch.h>
 #include <asm/mach/irq.h>
 #include <asm/mach/time.h>
+#include <asm/traps.h>
 
 #include "compat.h"
 #include "atags.h"
@@ -853,6 +854,10 @@ void __init setup_arch(char **cmdline_p)
 	conswitchp = &dummy_con;
 #endif
 #endif
+
+#if defined(CONFIG_KGDB)
+	early_trap_init();
+#endif
 }
 
 
diff --git a/arch/arm/kernel/traps.c b/arch/arm/kernel/traps.c
index 5595fdd..829aeae 100644
--- a/arch/arm/kernel/traps.c
+++ b/arch/arm/kernel/traps.c
@@ -294,6 +294,7 @@ asmlinkage void __exception do_undefinstr(struct pt_regs *regs)
 	unsigned int instr;
 	struct undef_hook *hook;
 	siginfo_t info;
+	mm_segment_t fs;
 	void __user *pc;
 	unsigned long flags;
 
@@ -304,6 +305,8 @@ asmlinkage void __exception do_undefinstr(struct pt_regs *regs)
 	 */
 	regs->ARM_pc -= correction;
 
+	fs = get_fs();
+	set_fs(KERNEL_DS);
 	pc = (void __user *)instruction_pointer(regs);
 
 	if (processor_mode(regs) == SVC_MODE) {
@@ -313,6 +316,7 @@ asmlinkage void __exception do_undefinstr(struct pt_regs *regs)
 	} else {
 		get_user(instr, (u32 __user *)pc);
 	}
+	set_fs(fs);
 
 #ifdef CONFIG_KPROBES
 	/*
@@ -708,6 +712,13 @@ EXPORT_SYMBOL(abort);
 
 void __init trap_init(void)
 {
+#if defined(CONFIG_KGDB)
+	return;
+}
+
+void __init early_trap_init(void)
+{
+#endif
 	unsigned long vectors = CONFIG_VECTORS_BASE;
 	extern char __stubs_start[], __stubs_end[];
 	extern char __vectors_start[], __vectors_end[];
diff --git a/include/asm-arm/kgdb.h b/include/asm-arm/kgdb.h
new file mode 100644
index 0000000..75efab5
--- /dev/null
+++ b/include/asm-arm/kgdb.h
@@ -0,0 +1,101 @@
+/*
+ * ARM KGDB support
+ *
+ * Author: Deepak Saxena <dsaxena@mvista.com>
+ *
+ * Copyright (C) 2002 MontaVista Software Inc.
+ *
+ */
+
+#ifndef __ARM_KGDB_H__
+#define __ARM_KGDB_H__
+
+#include <linux/ptrace.h>
+
+/*
+ * GDB assumes that we're a user process being debugged, so
+ * it will send us an SWI command to write into memory as the
+ * debug trap. When an SWI occurs, the next instruction addr is
+ * placed into R14_svc before jumping to the vector trap.
+ * This doesn't work for kernel debugging as we are already in SVC
+ * we would loose the kernel's LR, which is a bad thing. This
+ * is  bad thing.
+ *
+ * By doing this as an undefined instruction trap, we force a mode
+ * switch from SVC to UND mode, allowing us to save full kernel state.
+ *
+ * We also define a KGDB_COMPILED_BREAK which can be used to compile
+ * in breakpoints. This is important for things like sysrq-G and for
+ * the initial breakpoint from trap_init().
+ *
+ * Note to ARM HW designers: Add real trap support like SH && PPC to
+ * make our lives much much simpler. :)
+ */
+#define BREAK_INSTR_SIZE	4
+#define GDB_BREAKINST		0xef9f0001
+#define KGDB_BREAKINST		0xe7ffdefe
+#define KGDB_COMPILED_BREAK	0xe7ffdeff
+#define CACHE_FLUSH_IS_SAFE	1
+
+#ifndef	__ASSEMBLY__
+
+static inline void arch_kgdb_breakpoint(void)
+{
+	asm(".word 	0xe7ffdeff");
+}
+
+extern void kgdb_handle_bus_error(void);
+extern int kgdb_fault_expected;
+#endif /* !__ASSEMBLY__ */
+
+/*
+ * From Kevin Hilman:
+ *
+ * gdb is expecting the following registers layout.
+ *
+ * r0-r15: 1 long word each
+ * f0-f7:  unused, 3 long words each !!
+ * fps:    unused, 1 long word
+ * cpsr:   1 long word
+ *
+ * Even though f0-f7 and fps are not used, they need to be
+ * present in the registers sent for correct processing in
+ * the host-side gdb.
+ *
+ * In particular, it is crucial that CPSR is in the right place,
+ * otherwise gdb will not be able to correctly interpret stepping over
+ * conditional branches.
+ */
+#define _GP_REGS 		16
+#define _FP_REGS 		8
+#define _EXTRA_REGS 		2
+#define GDB_MAX_REGS		(_GP_REGS + (_FP_REGS * 3) + _EXTRA_REGS)
+
+#define KGDB_MAX_NO_CPUS	1
+#define BUFMAX			400
+#define NUMREGBYTES		(GDB_MAX_REGS << 2)
+#define NUMCRITREGBYTES		(32 << 2)
+
+#define _R0		0
+#define _R1		1
+#define _R2		2
+#define _R3		3
+#define _R4		4
+#define _R5		5
+#define _R6		6
+#define _R7		7
+#define _R8		8
+#define _R9		9
+#define _R10		10
+#define _FP		11
+#define _IP		12
+#define _SPT		13
+#define _LR		14
+#define _PC		15
+#define _CPSR		(GDB_MAX_REGS - 1)
+
+/* So that we can denote the end of a frame for tracing, in the simple
+ * case. */
+#define CFI_END_FRAME(func)	__CFI_END_FRAME(_PC, _SPT, func)
+
+#endif /* __ASM_KGDB_H__ */
diff --git a/include/asm-arm/traps.h b/include/asm-arm/traps.h
index f1541af..aa399ae 100644
--- a/include/asm-arm/traps.h
+++ b/include/asm-arm/traps.h
@@ -24,4 +24,6 @@ static inline int in_exception_text(unsigned long ptr)
 	       ptr < (unsigned long)&__exception_text_end;
 }
 
+extern void __init early_trap_init(void);
+
 #endif
-- 
1.5.4

