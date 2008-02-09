Return-Path: <linux-kernel-owner+w=401wt.eu-S1758185AbYBINg3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758185AbYBINg3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Feb 2008 08:36:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757471AbYBINfZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 Feb 2008 08:35:25 -0500
Received: from mail.windriver.com ([147.11.1.11]:60450 "EHLO mail.wrs.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757434AbYBINfT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Feb 2008 08:35:19 -0500
From: jason.wessel@windriver.com
To: linux-kernel@vger.kernel.org
Cc: Jason Wessel <jason.wessel@windriver.com>, Jan Kiszka <jan.kiszka@web.de>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH 5/8] kgdb, x86: Add arch specfic kgdb support
Date: Sat,  9 Feb 2008 07:35:11 -0600
Message-Id: <1202564114-18587-6-git-send-email-jason.wessel@windriver.com>
X-Mailer: git-send-email 1.5.4
In-Reply-To: <1202564114-18587-5-git-send-email-jason.wessel@windriver.com>
References: <1202564114-18587-1-git-send-email-jason.wessel@windriver.com>
 <1202564114-18587-2-git-send-email-jason.wessel@windriver.com>
 <1202564114-18587-3-git-send-email-jason.wessel@windriver.com>
 <1202564114-18587-4-git-send-email-jason.wessel@windriver.com>
 <1202564114-18587-5-git-send-email-jason.wessel@windriver.com>
X-OriginalArrivalTime: 09 Feb 2008 13:34:56.0321 (UTC) FILETIME=[8F0D7B10:01C86B20]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jason Wessel <jason.wessel@windriver.com>

On the i386 arch, in order to support early debugginer with kgdb when
used with kgdb via rs232 some traps must be initialized sooner rather
than later, but it is safe to always do this. The arch i386 now calls
parse_early_param() to explicitly look at anything marked
early_param().  KGDB also adds an additional IPI die hook to catch NMI
as well as IPI and to disinguish between the two. To achieve better
back trace results from the debugger some labels were added to the
switch_to macros.

This patch also add primative hardware breakpoint support from KGDB in
the kernel only context for the x86_64 and i386 arch.

Signed-off-by: Jason Wessel <jason.wessel@windriver.com>
Signed-off-by: Jan Kiszka <jan.kiszka@web.de>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 arch/x86/kernel/Makefile   |    1 +
 arch/x86/kernel/kgdb.c     |  533 ++++++++++++++++++++++++++++++++++++++++++++
 arch/x86/kernel/setup_32.c |    2 +
 arch/x86/kernel/setup_64.c |    4 +
 arch/x86/kernel/traps_32.c |   14 +-
 arch/x86/kernel/traps_64.c |   17 ++-
 include/asm-x86/kgdb.h     |   79 +++++++
 include/asm-x86/system.h   |    3 +
 lib/Kconfig.kgdb           |    2 +-
 9 files changed, 648 insertions(+), 7 deletions(-)
 create mode 100644 arch/x86/kernel/kgdb.c
 create mode 100644 include/asm-x86/kgdb.h

diff --git a/arch/x86/kernel/Makefile b/arch/x86/kernel/Makefile
index 21dc1a0..3784bab 100644
--- a/arch/x86/kernel/Makefile
+++ b/arch/x86/kernel/Makefile
@@ -58,6 +58,7 @@ obj-$(CONFIG_MODULES)		+= module_$(BITS).o
 obj-$(CONFIG_ACPI_SRAT) 	+= srat_32.o
 obj-$(CONFIG_EFI) 		+= efi.o efi_$(BITS).o efi_stub_$(BITS).o
 obj-$(CONFIG_DOUBLEFAULT) 	+= doublefault_32.o
+obj-$(CONFIG_KGDB)		+= kgdb.o
 obj-$(CONFIG_VM86)		+= vm86_32.o
 obj-$(CONFIG_EARLY_PRINTK)	+= early_printk.o
 
diff --git a/arch/x86/kernel/kgdb.c b/arch/x86/kernel/kgdb.c
new file mode 100644
index 0000000..ac3624f
--- /dev/null
+++ b/arch/x86/kernel/kgdb.c
@@ -0,0 +1,533 @@
+/*
+ *
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
+
+#include <linux/string.h>
+#include <linux/kernel.h>
+#include <linux/sched.h>
+#include <linux/smp.h>
+#include <linux/spinlock.h>
+#include <linux/delay.h>
+#include <asm/system.h>
+#include <linux/ptrace.h>		/* for linux pt_regs struct */
+#include <linux/kgdb.h>
+#include <linux/init.h>
+#include <linux/kdebug.h>
+#include <asm/apicdef.h>
+#ifdef CONFIG_X86_32
+#include <mach_ipi.h>
+#else /* !CONFIG_X86_32 */
+#include <asm/mach_apic.h>
+#endif /* !CONFIG_X86_32 */
+
+/* Put the error code here just in case the user cares.  */
+static int gdb_x86errcode;
+/* Likewise, the vector number here (since GDB only gets the signal
+   number through the usual means, and that's not very specific).  */
+static int gdb_x86vector = -1;
+
+void pt_regs_to_gdb_regs(unsigned long *gdb_regs, struct pt_regs *regs)
+{
+	gdb_regs[_AX] = regs->ax;
+	gdb_regs[_BX] = regs->bx;
+	gdb_regs[_CX] = regs->cx;
+	gdb_regs[_DX] = regs->dx;
+	gdb_regs[_SI] = regs->si;
+	gdb_regs[_DI] = regs->di;
+	gdb_regs[_BP] = regs->bp;
+	gdb_regs[_PS] = regs->flags;
+	gdb_regs[_PC] = regs->ip;
+#ifdef CONFIG_X86_32
+	gdb_regs[_DS] = regs->ds;
+	gdb_regs[_ES] = regs->es;
+	gdb_regs[_CS] = regs->cs;
+	gdb_regs[_SP] = (int)(&regs->sp);
+	gdb_regs[_SS] = __KERNEL_DS;
+	gdb_regs[_FS] = 0xFFFF;
+	gdb_regs[_GS] = 0xFFFF;
+#else /* ! CONFIG_X86_32 */
+	gdb_regs[_R8] = regs->r8;
+	gdb_regs[_R9] = regs->r9;
+	gdb_regs[_R10] = regs->r10;
+	gdb_regs[_R11] = regs->r11;
+	gdb_regs[_R12] = regs->r12;
+	gdb_regs[_R13] = regs->r13;
+	gdb_regs[_R14] = regs->r14;
+	gdb_regs[_R15] = regs->r15;
+	gdb_regs[_SP] = regs->sp;
+#endif /* ! CONFIG_X86_32 */
+}
+
+void sleeping_thread_to_gdb_regs(unsigned long *gdb_regs, struct task_struct *p)
+{
+	gdb_regs[_AX] = 0;
+	gdb_regs[_BX] = 0;
+	gdb_regs[_CX] = 0;
+	gdb_regs[_DX] = 0;
+	gdb_regs[_SI] = 0;
+	gdb_regs[_DI] = 0;
+	gdb_regs[_BP] = *(unsigned long *)p->thread.sp;
+#ifdef CONFIG_X86_32
+	gdb_regs[_DS] = __KERNEL_DS;
+	gdb_regs[_ES] = __KERNEL_DS;
+	gdb_regs[_PS] = 0;
+	gdb_regs[_CS] = __KERNEL_CS;
+	gdb_regs[_PC] = p->thread.ip;
+	gdb_regs[_SS] = __KERNEL_DS;
+	gdb_regs[_FS] = 0xFFFF;
+	gdb_regs[_GS] = 0xFFFF;
+#else /* ! CONFIG_X86_32 */
+	gdb_regs[_PS] = *(unsigned long *)(p->thread.sp + 8);
+	gdb_regs[_PC] = (unsigned long)&thread_return;
+	gdb_regs[_R8] = 0;
+	gdb_regs[_R9] = 0;
+	gdb_regs[_R10] = 0;
+	gdb_regs[_R11] = 0;
+	gdb_regs[_R12] = 0;
+	gdb_regs[_R13] = 0;
+	gdb_regs[_R14] = 0;
+	gdb_regs[_R15] = 0;
+#endif /* ! CONFIG_X86_32 */
+	gdb_regs[_SP] = p->thread.sp;
+}
+
+void gdb_regs_to_pt_regs(unsigned long *gdb_regs, struct pt_regs *regs)
+{
+	regs->ax = gdb_regs[_AX];
+	regs->bx = gdb_regs[_BX];
+	regs->cx = gdb_regs[_CX];
+	regs->dx = gdb_regs[_DX];
+	regs->si = gdb_regs[_SI];
+	regs->di = gdb_regs[_DI];
+	regs->bp = gdb_regs[_BP];
+	regs->flags = gdb_regs[_PS];
+	regs->ip = gdb_regs[_PC];
+#ifdef CONFIG_X86_32
+	regs->ds = gdb_regs[_DS];
+	regs->es = gdb_regs[_ES];
+	regs->cs = gdb_regs[_CS];
+#else /* ! CONFIG_X86_32 */
+	regs->r8 = gdb_regs[_R8];
+	regs->r9 = gdb_regs[_R9];
+	regs->r10 = gdb_regs[_R10];
+	regs->r11 = gdb_regs[_R11];
+	regs->r12 = gdb_regs[_R12];
+	regs->r13 = gdb_regs[_R13];
+	regs->r14 = gdb_regs[_R14];
+	regs->r15 = gdb_regs[_R15];
+#endif /* ! CONFIG_X86_32 */
+}
+
+static struct hw_breakpoint {
+	unsigned enabled;
+	unsigned type;
+	unsigned len;
+	unsigned long addr;
+} breakinfo[4] = {
+	{ .enabled = 0 },
+	{ .enabled = 0 },
+	{ .enabled = 0 },
+	{ .enabled = 0 },
+};
+
+static void kgdb_correct_hw_break(void)
+{
+	int breakno;
+	int breakbit;
+	int correctit = 0;
+	unsigned long dr7;
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
+static int kgdb_remove_hw_break(unsigned long addr, int len,
+				enum kgdb_bptype bptype)
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
+static int kgdb_set_hw_break(unsigned long addr, int len,
+			     enum kgdb_bptype bptype)
+{
+	int i;
+	unsigned type;
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
+	return 0;
+}
+
+void kgdb_disable_hw_debug(struct pt_regs *regs)
+{
+	/* Disable hardware debugging while we are in kgdb */
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
+	char *ptr;
+	int newPC;
+	unsigned long dr6;
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
+			if (kgdb_contthread)
+				atomic_set(&cpu_doing_single_step,
+					   raw_smp_processor_id());
+
+		}
+
+		get_debugreg(dr6, 6);
+		if (!(dr6 & 0x4000)) {
+			int breakno;
+
+			for (breakno = 0; breakno < 4; breakno++) {
+				if (dr6 & (1 << breakno) &&
+				    breakinfo[breakno].type == 0) {
+					/* Set restore flag */
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
+	/* this means that we do not want to exit from the handler */
+	return -1;
+}
+
+#ifndef CONFIG_X86_32
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
+	struct pt_regs *stregs;
+	int cpu = raw_smp_processor_id();
+	stregs = in_interrupt_stack(regs->sp, cpu);
+	if (stregs)
+		kgdb_mem2hex(intr_desc, buffer, strlen(intr_desc));
+	else {
+		stregs = in_exception_stack(regs->sp, cpu);
+		if (stregs)
+			kgdb_mem2hex(exc_desc, buffer, strlen(exc_desc));
+	}
+}
+
+struct task_struct *kgdb_get_shadow_thread(struct pt_regs *regs, int threadid)
+{
+	struct pt_regs *stregs;
+	int cpu = raw_smp_processor_id();
+
+	stregs = in_interrupt_stack(regs->sp, cpu);
+	if (stregs)
+		return current;
+	else {
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
+	struct pt_regs *stregs;
+	int cpu = raw_smp_processor_id();
+
+	stregs = in_interrupt_stack(regs->sp, cpu);
+	if (stregs)
+		return stregs;
+	else {
+		stregs = in_exception_stack(regs->sp, cpu);
+		if (stregs)
+			return stregs;
+	}
+
+	return NULL;
+}
+#endif /* ! CONFIG_X86_32 */
+
+static inline int single_step_cont(struct pt_regs *regs,
+			struct die_args *args)
+{
+	/* single step exception from kernel space to user space so
+	 * eat the exception and continue the process
+	 */
+	printk(KERN_ERR "KGDB: trap/step from kernel to user space,"
+			" resuming...\n");
+	kgdb_arch_handle_exception(args->trapnr, args->signr,
+			args->err, "c", "", regs);
+
+	return NOTIFY_STOP;
+}
+
+static int kgdb_notify(struct notifier_block *self, unsigned long cmd,
+		       void *ptr)
+{
+	struct die_args *args = ptr;
+	struct pt_regs *regs = args->regs;
+
+	switch (cmd) {
+	case DIE_NMI:
+		if (kgdb_active()) {
+			/* KGDB CPU roundup */
+			kgdb_nmihook(raw_smp_processor_id(), regs);
+			return NOTIFY_STOP;
+		}
+		return NOTIFY_DONE;
+	case DIE_NMI_IPI:
+		if (kgdb_active()) {
+			/* KGDB CPU roundup */
+			if (kgdb_nmihook(raw_smp_processor_id(), regs))
+				return NOTIFY_DONE;
+			return NOTIFY_STOP;
+		}
+		return NOTIFY_DONE;
+	case DIE_NMIWATCHDOG:
+		if (kgdb_active()) {
+			/* KGDB CPU roundup */
+			kgdb_nmihook(raw_smp_processor_id(), regs);
+			return NOTIFY_STOP;
+		}
+		/* Enter debugger */
+		break;
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
+	if (kgdb_handle_exception(args->trapnr, args->signr,
+		args->err, regs))
+		return NOTIFY_DONE;
+
+	return NOTIFY_STOP;
+}
+
+static struct notifier_block kgdb_notifier = {
+	.notifier_call = kgdb_notify,
+	.priority = 0x7fffffff,	/* we need to be notified first */
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
+
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
+	.gdb_bpt_instr = {0xcc},
+	.flags = KGDB_HW_BREAKPOINT,
+#ifndef CONFIG_X86_32
+	.shadowth = 1,
+#endif /* ! CONFIG_X86_32 */
+	.set_hw_breakpoint = kgdb_set_hw_break,
+	.remove_hw_breakpoint = kgdb_remove_hw_break,
+	.remove_all_hw_break = kgdb_remove_all_hw_break,
+	.correct_hw_break = kgdb_correct_hw_break,
+};
diff --git a/arch/x86/kernel/setup_32.c b/arch/x86/kernel/setup_32.c
index d1d8c34..e909d39 100644
--- a/arch/x86/kernel/setup_32.c
+++ b/arch/x86/kernel/setup_32.c
@@ -184,6 +184,7 @@ EXPORT_SYMBOL(ist_info);
 #endif
 
 extern void early_cpu_init(void);
+extern void early_trap_init(void);
 extern int root_mountflags;
 
 unsigned long saved_videomode;
@@ -700,6 +701,7 @@ void __init setup_arch(char **cmdline_p)
 	memcpy(&boot_cpu_data, &new_cpu_data, sizeof(new_cpu_data));
 	pre_setup_arch_hook();
 	early_cpu_init();
+	early_trap_init();
 	early_ioremap_init();
 
 #ifdef CONFIG_EFI
diff --git a/arch/x86/kernel/setup_64.c b/arch/x86/kernel/setup_64.c
index c0d8208..ecebc5f 100644
--- a/arch/x86/kernel/setup_64.c
+++ b/arch/x86/kernel/setup_64.c
@@ -91,6 +91,8 @@ unsigned long saved_video_mode;
 
 int force_mwait __cpuinitdata;
 
+void early_trap_init(void);
+
 /*
  * Early DMI memory
  */
@@ -270,6 +272,8 @@ void __init setup_arch(char **cmdline_p)
 {
 	unsigned i;
 
+	early_trap_init();
+
 	printk(KERN_INFO "Command line: %s\n", boot_command_line);
 
 	ROOT_DEV = old_decode_dev(boot_params.hdr.root_dev);
diff --git a/arch/x86/kernel/traps_32.c b/arch/x86/kernel/traps_32.c
index b22c01e..47ca425 100644
--- a/arch/x86/kernel/traps_32.c
+++ b/arch/x86/kernel/traps_32.c
@@ -919,6 +919,7 @@ void __kprobes do_debug(struct pt_regs * regs, long error_code)
 	 */
 clear_dr7:
 	set_debugreg(0, 7);
+	notify_die(DIE_DEBUG, "debug2", regs, condition, error_code, SIGTRAP);
 	return;
 
 debug_vm86:
@@ -1136,6 +1137,14 @@ asmlinkage void math_emulate(long arg)
 
 #endif /* CONFIG_MATH_EMULATION */
 
+/* Set of traps needed for early debugging. */
+void __init early_trap_init(void)
+{
+	set_intr_gate(1, &debug);
+	set_system_intr_gate(3, &int3); /* int3 can be called from all */
+	set_intr_gate(14, &page_fault);
+	load_idt(&idt_descr);
+}
 
 void __init trap_init(void)
 {
@@ -1154,10 +1163,8 @@ void __init trap_init(void)
 #endif
 
 	set_trap_gate(0,&divide_error);
-	set_intr_gate(1,&debug);
 	set_intr_gate(2,&nmi);
-	set_system_intr_gate(3, &int3); /* int3/4 can be called from all */
-	set_system_gate(4,&overflow);
+	set_system_gate(4, &overflow); /* int4/5 can be called from all */
 	set_trap_gate(5,&bounds);
 	set_trap_gate(6,&invalid_op);
 	set_trap_gate(7,&device_not_available);
@@ -1167,7 +1174,6 @@ void __init trap_init(void)
 	set_trap_gate(11,&segment_not_present);
 	set_trap_gate(12,&stack_segment);
 	set_trap_gate(13,&general_protection);
-	set_intr_gate(14,&page_fault);
 	set_trap_gate(15,&spurious_interrupt_bug);
 	set_trap_gate(16,&coprocessor_error);
 	set_trap_gate(17,&alignment_check);
diff --git a/arch/x86/kernel/traps_64.c b/arch/x86/kernel/traps_64.c
index efc66df..00baf0d 100644
--- a/arch/x86/kernel/traps_64.c
+++ b/arch/x86/kernel/traps_64.c
@@ -600,8 +600,13 @@ void die(const char * str, struct pt_regs * regs, long err)
 
 void __kprobes die_nmi(char *str, struct pt_regs *regs, int do_panic)
 {
-	unsigned long flags = oops_begin();
+	unsigned long flags;
+
+	if (notify_die(DIE_NMIWATCHDOG, "nmi", regs, 0, 2, SIGINT)
+			== NOTIFY_STOP)
+		return;
 
+	flags = oops_begin();
 	/*
 	 * We are in trouble anyway, lets at least try
 	 * to get a message out.
@@ -1124,6 +1129,15 @@ asmlinkage void math_state_restore(void)
 }
 EXPORT_SYMBOL_GPL(math_state_restore);
 
+/* Set of traps needed for early debugging. */
+void __init early_trap_init(void)
+{
+	set_intr_gate(1, &debug);
+	set_intr_gate(3, &int3);
+	set_intr_gate(14, &page_fault);
+	load_idt((const struct desc_ptr *)&idt_descr);
+}
+
 void __init trap_init(void)
 {
 	set_intr_gate(0,&divide_error);
@@ -1140,7 +1154,6 @@ void __init trap_init(void)
 	set_intr_gate(11,&segment_not_present);
 	set_intr_gate_ist(12,&stack_segment,STACKFAULT_STACK);
 	set_intr_gate(13,&general_protection);
-	set_intr_gate(14,&page_fault);
 	set_intr_gate(15,&spurious_interrupt_bug);
 	set_intr_gate(16,&coprocessor_error);
 	set_intr_gate(17,&alignment_check);
diff --git a/include/asm-x86/kgdb.h b/include/asm-x86/kgdb.h
new file mode 100644
index 0000000..c2803a8
--- /dev/null
+++ b/include/asm-x86/kgdb.h
@@ -0,0 +1,79 @@
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
+enum regnames { _AX,	/* 0 */
+	_CX,	/* 1 */
+	_DX,	/* 2 */
+	_BX,	/* 3 */
+	_SP,	/* 4 */
+	_BP,	/* 5 */
+	_SI,	/* 6 */
+	_DI,	/* 7 */
+	_PC,	/* 8 also known as eip */
+	_PS,	/* 9 also known as eflags */
+	_CS,	/* 10 */
+	_SS,	/* 11 */
+	_DS,	/* 12 */
+	_ES,	/* 13 */
+	_FS,	/* 14 */
+	_GS		/* 15 */
+};
+#else /* ! CONFIG_X86_32 */
+enum regnames { _AX,	/* 0 */
+	_DX,	/* 1 */
+	_CX,	/* 2 */
+	_BX,	/* 3 */
+	_SI,	/* 4 */
+	_DI,	/* 5 */
+	_BP,	/* 6 */
+	_SP,	/* 7 */
+	_R8,	/* 8 */
+	_R9,	/* 9 */
+	_R10,	/* 10 */
+	_R11,	/* 11 */
+	_R12,	/* 12 */
+	_R13,	/* 13 */
+	_R14,	/* 14 */
+	_R15,	/* 15 */
+	_PC,	/* 16 */
+	_PS		/* 17 */
+};
+#endif /* CONFIG_X86_32 */
+
+/* Number of bytes for gdb registers */
+#ifdef CONFIG_X86_32
+#define NUMREGBYTES		64
+#else /* ! CONFIG_X86_32 */
+#define NUMREGBYTES		((_PS+1)*8)
+#endif /* CONFIG_X86_32 */
+
+#ifndef __ASSEMBLY__
+#define BREAKPOINT()		asm("   int $3");
+#define BREAK_INSTR_SIZE	1
+#define CACHE_FLUSH_IS_SAFE	1
+#endif				/* !__ASSEMBLY__ */
+#endif				/* _ASM_KGDB_H_ */
+#endif				/* __KERNEL__ */
diff --git a/include/asm-x86/system.h b/include/asm-x86/system.h
index 9cff02f..33851cb 100644
--- a/include/asm-x86/system.h
+++ b/include/asm-x86/system.h
@@ -61,6 +61,7 @@ struct task_struct *__switch_to(struct task_struct *prev,
 	, "rcx", "rbx", "rdx", "r8", "r9", "r10", "r11", \
 	  "r12", "r13", "r14", "r15"
 
+extern void thread_return(void);
 /* Save restore flags to clear handle leaking NT */
 #define switch_to(prev, next, last) \
 	asm volatile(SAVE_CONTEXT						    \
@@ -75,6 +76,8 @@ struct task_struct *__switch_to(struct task_struct *prev,
 	     "movq %%rax,%%rdi\n\t" 					  \
 	     "jc   ret_from_fork\n\t"					  \
 	     RESTORE_CONTEXT						  \
+	     "\n.globl __switch_to_end\n\t"			\
+	     "__switch_to_end:\n\t"				\
 	     : "=a" (last)					  	  \
 	     : [next] "S" (next), [prev] "D" (prev),			  \
 	       [threadrsp] "i" (offsetof(struct task_struct, thread.sp)), \
diff --git a/lib/Kconfig.kgdb b/lib/Kconfig.kgdb
index afa61bb..e6fb7e3 100644
--- a/lib/Kconfig.kgdb
+++ b/lib/Kconfig.kgdb
@@ -4,7 +4,7 @@ menuconfig KGDB
 	select KGDB_ARCH_HAS_SHADOW_INFO if X86_64
 	select DEBUG_INFO
 	select FRAME_POINTER
-	depends on DEBUG_KERNEL && ADD_A_KGDB_ARCH
+	depends on DEBUG_KERNEL && (X86)
 	help
 	  If you say Y here, it will be possible to remotely debug the
 	  kernel using gdb.  Documentation of kernel debugger is available
-- 
1.5.4

