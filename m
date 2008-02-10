Return-Path: <linux-kernel-owner+w=401wt.eu-S1755824AbYBJHPn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755824AbYBJHPn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Feb 2008 02:15:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757535AbYBJHOL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Feb 2008 02:14:11 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:49458 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757488AbYBJHOD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Feb 2008 02:14:03 -0500
Date: Sun, 10 Feb 2008 08:13:45 +0100
From: Ingo Molnar <mingo@elte.hu>
To: linux-kernel@vger.kernel.org
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@zip.com.au>, Thomas Gleixner <tglx@linutronix.de>,
       Jason Wessel <jason.wessel@windriver.com>
Subject: [5/6] x86: kgdb support
Message-ID: <20080210071345.GE3851@elte.hu>
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

From: Ingo Molnar <mingo@elte.hu>

simplified and streamlined kgdb support on x86, both 32-bit and 64-bit,
based on patch from:

  Subject: kgdb: core-lite
  From: Jason Wessel <jason.wessel@windriver.com>

[ and countless other authors - see the patch for details. ]

Signed-off-by: Ingo Molnar <mingo@elte.hu>
Reviewed-by: Thomas Gleixner <tglx@linutronix.de>
---
 arch/x86/Kconfig         |    4 
 arch/x86/kernel/Makefile |    1 
 arch/x86/kernel/kgdb.c   |  550 +++++++++++++++++++++++++++++++++++++++++++++++
 include/asm-x86/kgdb.h   |   87 +++++++
 4 files changed, 642 insertions(+)

Index: linux-kgdb.q/arch/x86/Kconfig
===================================================================
--- linux-kgdb.q.orig/arch/x86/Kconfig
+++ linux-kgdb.q/arch/x86/Kconfig
@@ -14,6 +14,7 @@ config X86_32
 
 config X86_64
 	def_bool 64BIT
+	select KGDB_ARCH_HAS_SHADOW_INFO
 
 ### Arch settings
 config X86
@@ -139,6 +140,9 @@ config AUDIT_ARCH
 config ARCH_SUPPORTS_AOUT
 	def_bool y
 
+config ARCH_SUPPORTS_KGDB
+	def_bool y
+
 # Use the generic interrupt handling code in kernel/irq/:
 config GENERIC_HARDIRQS
 	bool
Index: linux-kgdb.q/arch/x86/kernel/Makefile
===================================================================
--- linux-kgdb.q.orig/arch/x86/kernel/Makefile
+++ linux-kgdb.q/arch/x86/kernel/Makefile
@@ -58,6 +58,7 @@ obj-$(CONFIG_MODULES)		+= module_$(BITS)
 obj-$(CONFIG_ACPI_SRAT) 	+= srat_32.o
 obj-$(CONFIG_EFI) 		+= efi.o efi_$(BITS).o efi_stub_$(BITS).o
 obj-$(CONFIG_DOUBLEFAULT) 	+= doublefault_32.o
+obj-$(CONFIG_KGDB)		+= kgdb.o
 obj-$(CONFIG_VM86)		+= vm86_32.o
 obj-$(CONFIG_EARLY_PRINTK)	+= early_printk.o
 
Index: linux-kgdb.q/arch/x86/kernel/kgdb.c
===================================================================
--- /dev/null
+++ linux-kgdb.q/arch/x86/kernel/kgdb.c
@@ -0,0 +1,550 @@
+/*
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License as published by the
+ * Free Software Foundation; either version 2, or (at your option) any
+ * later version.
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ *
+ */
+
+/*
+ * Copyright (C) 2004 Amit S. Kale <amitkale@linsyssoft.com>
+ * Copyright (C) 2000-2001 VERITAS Software Corporation.
+ * Copyright (C) 2002 Andi Kleen, SuSE Labs
+ * Copyright (C) 2004 LinSysSoft Technologies Pvt. Ltd.
+ * Copyright (C) 2007 MontaVista Software, Inc.
+ * Copyright (C) 2007-2008 Jason Wessel, Wind River Systems, Inc.
+ */
+/****************************************************************************
+ *  Contributor:     Lake Stevens Instrument Division$
+ *  Written by:      Glenn Engel $
+ *  Updated by:	     Amit Kale<akale@veritas.com>
+ *  Updated by:	     Tom Rini <trini@kernel.crashing.org>
+ *  Updated by:	     Jason Wessel <jason.wessel@windriver.com>
+ *  Modified for 386 by Jim Kingdon, Cygnus Support.
+ *  Origianl kgdb, compatibility with 2.1.xx kernel by
+ *  David Grothe <dave@gcom.com>
+ *  Integrated into 2.2.5 kernel by Tigran Aivazian <tigran@sco.com>
+ *  X86_64 changes from Andi Kleen's patch merged by Jim Houston
+ */
+#include <linux/spinlock.h>
+#include <linux/kdebug.h>
+#include <linux/string.h>
+#include <linux/kernel.h>
+#include <linux/ptrace.h>
+#include <linux/sched.h>
+#include <linux/delay.h>
+#include <linux/kgdb.h>
+#include <linux/init.h>
+#include <linux/smp.h>
+
+#include <asm/apicdef.h>
+#include <asm/system.h>
+
+#ifdef CONFIG_X86_32
+# include <mach_ipi.h>
+#else
+# include <asm/mach_apic.h>
+#endif
+
+/*
+ * Put the error code here just in case the user cares:
+ */
+static int gdb_x86errcode;
+
+/*
+ * Likewise, the vector number here (since GDB only gets the signal
+ * number through the usual means, and that's not very specific):
+ */
+static int gdb_x86vector = -1;
+
+void pt_regs_to_gdb_regs(unsigned long *gdb_regs, struct pt_regs *regs)
+{
+	gdb_regs[GDB_AX]	= regs->ax;
+	gdb_regs[GDB_BX]	= regs->bx;
+	gdb_regs[GDB_CX]	= regs->cx;
+	gdb_regs[GDB_DX]	= regs->dx;
+	gdb_regs[GDB_SI]	= regs->si;
+	gdb_regs[GDB_DI]	= regs->di;
+	gdb_regs[GDB_BP]	= regs->bp;
+	gdb_regs[GDB_PS]	= regs->flags;
+	gdb_regs[GDB_PC]	= regs->ip;
+#ifdef CONFIG_X86_32
+	gdb_regs[GDB_DS]	= regs->ds;
+	gdb_regs[GDB_ES]	= regs->es;
+	gdb_regs[GDB_CS]	= regs->cs;
+	gdb_regs[GDB_SS]	= __KERNEL_DS;
+	gdb_regs[GDB_FS]	= 0xFFFF;
+	gdb_regs[GDB_GS]	= 0xFFFF;
+#else
+	gdb_regs[GDB_R8]	= regs->r8;
+	gdb_regs[GDB_R9]	= regs->r9;
+	gdb_regs[GDB_R10]	= regs->r10;
+	gdb_regs[GDB_R11]	= regs->r11;
+	gdb_regs[GDB_R12]	= regs->r12;
+	gdb_regs[GDB_R13]	= regs->r13;
+	gdb_regs[GDB_R14]	= regs->r14;
+	gdb_regs[GDB_R15]	= regs->r15;
+#endif
+	gdb_regs[GDB_SP]	= regs->sp;
+}
+
+void sleeping_thread_to_gdb_regs(unsigned long *gdb_regs, struct task_struct *p)
+{
+	gdb_regs[GDB_AX]	= 0;
+	gdb_regs[GDB_BX]	= 0;
+	gdb_regs[GDB_CX]	= 0;
+	gdb_regs[GDB_DX]	= 0;
+	gdb_regs[GDB_SI]	= 0;
+	gdb_regs[GDB_DI]	= 0;
+	gdb_regs[GDB_BP]	= *(unsigned long *)p->thread.sp;
+#ifdef CONFIG_X86_32
+	gdb_regs[GDB_DS]	= __KERNEL_DS;
+	gdb_regs[GDB_ES]	= __KERNEL_DS;
+	gdb_regs[GDB_PS]	= 0;
+	gdb_regs[GDB_CS]	= __KERNEL_CS;
+	gdb_regs[GDB_PC]	= p->thread.ip;
+	gdb_regs[GDB_SS]	= __KERNEL_DS;
+	gdb_regs[GDB_FS]	= 0xFFFF;
+	gdb_regs[GDB_GS]	= 0xFFFF;
+#else
+	gdb_regs[GDB_PS]	= *(unsigned long *)(p->thread.sp + 8);
+	gdb_regs[GDB_PC]	= 0;
+	gdb_regs[GDB_R8]	= 0;
+	gdb_regs[GDB_R9]	= 0;
+	gdb_regs[GDB_R10]	= 0;
+	gdb_regs[GDB_R11]	= 0;
+	gdb_regs[GDB_R12]	= 0;
+	gdb_regs[GDB_R13]	= 0;
+	gdb_regs[GDB_R14]	= 0;
+	gdb_regs[GDB_R15]	= 0;
+#endif
+	gdb_regs[GDB_SP]	= p->thread.sp;
+}
+
+void gdb_regs_to_pt_regs(unsigned long *gdb_regs, struct pt_regs *regs)
+{
+	regs->ax		= gdb_regs[GDB_AX];
+	regs->bx		= gdb_regs[GDB_BX];
+	regs->cx		= gdb_regs[GDB_CX];
+	regs->dx		= gdb_regs[GDB_DX];
+	regs->si		= gdb_regs[GDB_SI];
+	regs->di		= gdb_regs[GDB_DI];
+	regs->bp		= gdb_regs[GDB_BP];
+	regs->flags		= gdb_regs[GDB_PS];
+	regs->ip		= gdb_regs[GDB_PC];
+#ifdef CONFIG_X86_32
+	regs->ds		= gdb_regs[GDB_DS];
+	regs->es		= gdb_regs[GDB_ES];
+	regs->cs		= gdb_regs[GDB_CS];
+#else
+	regs->r8		= gdb_regs[GDB_R8];
+	regs->r9		= gdb_regs[GDB_R9];
+	regs->r10		= gdb_regs[GDB_R10];
+	regs->r11		= gdb_regs[GDB_R11];
+	regs->r12		= gdb_regs[GDB_R12];
+	regs->r13		= gdb_regs[GDB_R13];
+	regs->r14		= gdb_regs[GDB_R14];
+	regs->r15		= gdb_regs[GDB_R15];
+#endif
+}
+
+static struct hw_breakpoint {
+	unsigned		enabled;
+	unsigned		type;
+	unsigned		len;
+	unsigned long		addr;
+} breakinfo[4] = {
+	{ .enabled = 0 },
+	{ .enabled = 0 },
+	{ .enabled = 0 },
+	{ .enabled = 0 },
+};
+
+static void kgdb_correct_hw_break(void)
+{
+	unsigned long dr7;
+	int correctit = 0;
+	int breakbit;
+	int breakno;
+
+	get_debugreg(dr7, 7);
+	for (breakno = 0; breakno < 4; breakno++) {
+		breakbit = 2 << (breakno << 1);
+		if (!(dr7 & breakbit) && breakinfo[breakno].enabled) {
+			correctit = 1;
+			dr7 |= breakbit;
+			dr7 &= ~(0xf0000 << (breakno << 2));
+			dr7 |= ((breakinfo[breakno].len << 2) |
+				 breakinfo[breakno].type) <<
+			       ((breakno << 2) + 16);
+			switch (breakno) {
+			case 0:
+				set_debugreg(breakinfo[0].addr, 0);
+				break;
+
+			case 1:
+				set_debugreg(breakinfo[1].addr, 1);
+				break;
+
+			case 2:
+				set_debugreg(breakinfo[2].addr, 2);
+				break;
+
+			case 3:
+				set_debugreg(breakinfo[3].addr, 3);
+				break;
+			}
+		} else if ((dr7 & breakbit) && !breakinfo[breakno].enabled) {
+			correctit = 1;
+			dr7 &= ~breakbit;
+			dr7 &= ~(0xf0000 << (breakno << 2));
+		}
+	}
+	if (correctit)
+		set_debugreg(dr7, 7);
+}
+
+static int
+kgdb_remove_hw_break(unsigned long addr, int len, enum kgdb_bptype bptype)
+{
+	int i;
+
+	for (i = 0; i < 4; i++)
+		if (breakinfo[i].addr == addr && breakinfo[i].enabled)
+			break;
+	if (i == 4)
+		return -1;
+
+	breakinfo[i].enabled = 0;
+
+	return 0;
+}
+
+static void kgdb_remove_all_hw_break(void)
+{
+	int i;
+
+	for (i = 0; i < 4; i++)
+		memset(&breakinfo[i], 0, sizeof(struct hw_breakpoint));
+}
+
+static int
+kgdb_set_hw_break(unsigned long addr, int len, enum kgdb_bptype bptype)
+{
+	unsigned type;
+	int i;
+
+	for (i = 0; i < 4; i++)
+		if (!breakinfo[i].enabled)
+			break;
+	if (i == 4)
+		return -1;
+
+	switch (bptype) {
+	case BP_HARDWARE_BREAKPOINT:
+		type = 0;
+		len  = 1;
+		break;
+	case BP_WRITE_WATCHPOINT:
+		type = 1;
+		break;
+	case BP_ACCESS_WATCHPOINT:
+		type = 3;
+		break;
+	default:
+		return -1;
+	}
+
+	if (len == 1 || len == 2 || len == 4)
+		breakinfo[i].len  = len - 1;
+	else
+		return -1;
+
+	breakinfo[i].enabled = 1;
+	breakinfo[i].addr = addr;
+	breakinfo[i].type = type;
+
+	return 0;
+}
+
+void kgdb_disable_hw_debug(struct pt_regs *regs)
+{
+	/* Disable hardware debugging while we are in kgdb: */
+	set_debugreg(0UL, 7);
+}
+
+void kgdb_post_master_code(struct pt_regs *regs, int e_vector, int err_code)
+{
+	/* Master processor is completely in the debugger */
+	gdb_x86vector = e_vector;
+	gdb_x86errcode = err_code;
+}
+
+#ifdef CONFIG_SMP
+void kgdb_roundup_cpus(unsigned long flags)
+{
+	send_IPI_allbutself(APIC_DM_NMI);
+}
+#endif
+
+int kgdb_arch_handle_exception(int e_vector, int signo, int err_code,
+			       char *remcomInBuffer, char *remcomOutBuffer,
+			       struct pt_regs *linux_regs)
+{
+	unsigned long addr;
+	unsigned long dr6;
+	char *ptr;
+	int newPC;
+
+	switch (remcomInBuffer[0]) {
+	case 'c':
+	case 's':
+		/* try to read optional parameter, pc unchanged if no parm */
+		ptr = &remcomInBuffer[1];
+		if (kgdb_hex2long(&ptr, &addr))
+			linux_regs->ip = addr;
+		newPC = linux_regs->ip;
+
+		/* clear the trace bit */
+		linux_regs->flags &= ~TF_MASK;
+		atomic_set(&cpu_doing_single_step, -1);
+
+		/* set the trace bit if we're stepping */
+		if (remcomInBuffer[0] == 's') {
+			linux_regs->flags |= TF_MASK;
+			debugger_step = 1;
+			if (kgdb_contthread) {
+				atomic_set(&cpu_doing_single_step,
+					   raw_smp_processor_id());
+			}
+		}
+
+		get_debugreg(dr6, 6);
+		if (!(dr6 & 0x4000)) {
+			int breakno;
+
+			for (breakno = 0; breakno < 4; breakno++) {
+				if (dr6 & (1 << breakno) &&
+				    breakinfo[breakno].type == 0) {
+					/* Set restore flag: */
+					linux_regs->flags |= X86_EFLAGS_RF;
+					break;
+				}
+			}
+		}
+		set_debugreg(0UL, 6);
+		kgdb_correct_hw_break();
+
+		return 0;
+	}
+
+	/* this means that we do not want to exit from the handler: */
+	return -1;
+}
+
+#ifdef CONFIG_X86_64
+
+static struct pt_regs *in_interrupt_stack(unsigned long rsp, int cpu)
+{
+	struct pt_regs *regs = NULL;
+	unsigned long end = (unsigned long)cpu_pda(cpu)->irqstackptr;
+
+	if (rsp <= end && rsp >= end - IRQSTACKSIZE + 8)
+		regs = *(((struct pt_regs **)end) - 1);
+
+	return regs;
+}
+
+static struct pt_regs *in_exception_stack(unsigned long rsp, int cpu)
+{
+	struct tss_struct *init_tss = &__get_cpu_var(init_tss);
+	struct pt_regs *regs;
+	int i;
+
+	for (i = 0; i < N_EXCEPTION_STACKS; i++)
+		if (rsp >= init_tss[cpu].x86_tss.ist[i] &&
+		    rsp <= init_tss[cpu].x86_tss.ist[i] + EXCEPTION_STKSZ) {
+			regs = (void *) init_tss[cpu].x86_tss.ist[i] +\
+				EXCEPTION_STKSZ;
+			return regs - 1;
+		}
+
+	return NULL;
+}
+
+void kgdb_shadowinfo(struct pt_regs *regs, char *buffer, unsigned threadid)
+{
+	static char intr_desc[] = "Stack at interrupt entrypoint";
+	static char exc_desc[] = "Stack at exception entrypoint";
+	int cpu = raw_smp_processor_id();
+	struct pt_regs *stregs;
+
+	stregs = in_interrupt_stack(regs->sp, cpu);
+	if (stregs) {
+		kgdb_mem2hex(intr_desc, buffer, strlen(intr_desc));
+	} else {
+		stregs = in_exception_stack(regs->sp, cpu);
+		if (stregs)
+			kgdb_mem2hex(exc_desc, buffer, strlen(exc_desc));
+	}
+}
+
+struct task_struct *kgdb_get_shadow_thread(struct pt_regs *regs, int threadid)
+{
+	int cpu = raw_smp_processor_id();
+	struct pt_regs *stregs;
+
+	stregs = in_interrupt_stack(regs->sp, cpu);
+	if (stregs) {
+		return current;
+	} else {
+		stregs = in_exception_stack(regs->sp, cpu);
+		if (stregs)
+			return current;
+	}
+
+	return NULL;
+}
+
+struct pt_regs *kgdb_shadow_regs(struct pt_regs *regs, int threadid)
+{
+	int cpu = raw_smp_processor_id();
+	struct pt_regs *stregs;
+
+	stregs = in_interrupt_stack(regs->sp, cpu);
+	if (stregs) {
+		return stregs;
+	} else {
+		stregs = in_exception_stack(regs->sp, cpu);
+		if (stregs)
+			return stregs;
+	}
+
+	return NULL;
+}
+
+#endif /* CONFIG_X86_64 */
+
+static inline int
+single_step_cont(struct pt_regs *regs, struct die_args *args)
+{
+	/*
+	 * Single step exception from kernel space to user space so
+	 * eat the exception and continue the process:
+	 */
+	printk(KERN_ERR "KGDB: trap/step from kernel to user space, "
+			"resuming...\n");
+	kgdb_arch_handle_exception(args->trapnr, args->signr,
+				   args->err, "c", "", regs);
+
+	return NOTIFY_STOP;
+}
+
+static int
+kgdb_notify(struct notifier_block *self, unsigned long cmd, void *ptr)
+{
+	struct die_args *args = ptr;
+	struct pt_regs *regs = args->regs;
+
+	switch (cmd) {
+	case DIE_NMI:
+		if (atomic_read(&debugger_active)) {
+			/* KGDB CPU roundup */
+			kgdb_nmicallback(raw_smp_processor_id(), regs);
+			return NOTIFY_STOP;
+		}
+		return NOTIFY_DONE;
+
+	case DIE_NMI_IPI:
+		if (atomic_read(&debugger_active)) {
+			/* KGDB CPU roundup: */
+			if (kgdb_nmicallback(raw_smp_processor_id(), regs))
+				return NOTIFY_DONE;
+			return NOTIFY_STOP;
+		}
+		return NOTIFY_DONE;
+
+	case DIE_NMIWATCHDOG:
+		if (atomic_read(&debugger_active)) {
+			/* KGDB CPU roundup: */
+			kgdb_nmicallback(raw_smp_processor_id(), regs);
+			return NOTIFY_STOP;
+		}
+		/* Enter debugger: */
+		break;
+
+	case DIE_DEBUG:
+		if (atomic_read(&cpu_doing_single_step) ==
+			raw_smp_processor_id() &&
+			user_mode(regs))
+			return single_step_cont(regs, args);
+		/* fall through */
+	default:
+		if (user_mode(regs))
+			return NOTIFY_DONE;
+	}
+
+	if (kgdb_handle_exception(args->trapnr, args->signr, args->err, regs))
+		return NOTIFY_DONE;
+
+	return NOTIFY_STOP;
+}
+
+static struct notifier_block kgdb_notifier = {
+	.notifier_call	= kgdb_notify,
+
+	/*
+	 * Lowest-prio notifier priority, we want to be notified last:
+	 */
+	.priority	= -INT_MAX,
+};
+
+int kgdb_arch_init(void)
+{
+	register_die_notifier(&kgdb_notifier);
+	return 0;
+}
+
+void kgdb_arch_uninit(void)
+{
+	unregister_die_notifier(&kgdb_notifier);
+}
+
+/*
+ * Skip an int3 exception when it occurs after a breakpoint has been
+ * removed. Backtrack eip by 1 since the int3 would have caused it to
+ * increment by 1.
+ */
+int kgdb_skipexception(int exception, struct pt_regs *regs)
+{
+	if (exception == 3 && kgdb_isremovedbreak(regs->ip - 1)) {
+		regs->ip -= 1;
+		return 1;
+	}
+	return 0;
+}
+
+unsigned long kgdb_arch_pc(int exception, struct pt_regs *regs)
+{
+	if (exception == 3)
+		return instruction_pointer(regs) - 1;
+	return instruction_pointer(regs);
+}
+
+struct kgdb_arch arch_kgdb_ops = {
+	/* Breakpoint instruction: */
+	.gdb_bpt_instr		= { 0xcc },
+	.flags			= KGDB_HW_BREAKPOINT,
+#ifndef CONFIG_X86_32
+	.shadowth		= 1,
+#endif
+	.set_hw_breakpoint	= kgdb_set_hw_break,
+	.remove_hw_breakpoint	= kgdb_remove_hw_break,
+	.remove_all_hw_break	= kgdb_remove_all_hw_break,
+	.correct_hw_break	= kgdb_correct_hw_break,
+};
Index: linux-kgdb.q/include/asm-x86/kgdb.h
===================================================================
--- /dev/null
+++ linux-kgdb.q/include/asm-x86/kgdb.h
@@ -0,0 +1,87 @@
+#ifdef __KERNEL__
+#ifndef _ASM_KGDB_H_
+#define _ASM_KGDB_H_
+
+/*
+ * Copyright (C) 2001-2004 Amit S. Kale
+ * Copyright (C) 2008 Wind River Systems, Inc.
+ */
+
+#include <asm-generic/kgdb.h>
+
+/*
+ * BUFMAX defines the maximum number of characters in inbound/outbound
+ * buffers at least NUMREGBYTES*2 are needed for register packets
+ * Longer buffer is needed to list all threads
+ */
+#define BUFMAX			1024
+
+/*
+ *  Note that this register image is in a different order than
+ *  the register image that Linux produces at interrupt time.
+ *
+ *  Linux's register image is defined by struct pt_regs in ptrace.h.
+ *  Just why GDB uses a different order is a historical mystery.
+ */
+#ifdef CONFIG_X86_32
+enum regnames {
+	GDB_AX,			/* 0 */
+	GDB_CX,			/* 1 */
+	GDB_DX,			/* 2 */
+	GDB_BX,			/* 3 */
+	GDB_SP,			/* 4 */
+	GDB_BP,			/* 5 */
+	GDB_SI,			/* 6 */
+	GDB_DI,			/* 7 */
+	GDB_PC,			/* 8 also known as eip */
+	GDB_PS,			/* 9 also known as eflags */
+	GDB_CS,			/* 10 */
+	GDB_SS,			/* 11 */
+	GDB_DS,			/* 12 */
+	GDB_ES,			/* 13 */
+	GDB_FS,			/* 14 */
+	GDB_GS,			/* 15 */
+};
+#else /* ! CONFIG_X86_32 */
+enum regnames {
+	GDB_AX,			/* 0 */
+	GDB_DX,			/* 1 */
+	GDB_CX,			/* 2 */
+	GDB_BX,			/* 3 */
+	GDB_SI,			/* 4 */
+	GDB_DI,			/* 5 */
+	GDB_BP,			/* 6 */
+	GDB_SP,			/* 7 */
+	GDB_R8,			/* 8 */
+	GDB_R9,			/* 9 */
+	GDB_R10,		/* 10 */
+	GDB_R11,		/* 11 */
+	GDB_R12,		/* 12 */
+	GDB_R13,		/* 13 */
+	GDB_R14,		/* 14 */
+	GDB_R15,		/* 15 */
+	GDB_PC,			/* 16 */
+	GDB_PS,			/* 17 */
+};
+#endif /* CONFIG_X86_32 */
+
+/*
+ * Number of bytes of registers:
+ */
+#ifdef CONFIG_X86_32
+# define NUMREGBYTES		64
+#else
+# define NUMREGBYTES		((GDB_PS+1)*8)
+#endif
+
+#ifndef __ASSEMBLY__
+static inline void arch_kgdb_breakpoint(void)
+{
+	asm("   int $3");
+}
+# define BREAK_INSTR_SIZE	1
+# define CACHE_FLUSH_IS_SAFE	1
+#endif
+
+#endif				/* _ASM_KGDB_H_ */
+#endif				/* __KERNEL__ */
