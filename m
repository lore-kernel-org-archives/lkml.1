Return-Path: <linux-kernel-owner+w=401wt.eu-S1755109AbYGYDA5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755109AbYGYDA5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2008 23:00:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752076AbYGYDAr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Jul 2008 23:00:47 -0400
Received: from mail.windriver.com ([147.11.1.11]:38115 "EHLO mail.wrs.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751439AbYGYDAq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2008 23:00:46 -0400
Message-ID: <488941C5.9060908@windriver.com>
Date: Thu, 24 Jul 2008 22:00:21 -0500
From: Jason Wessel <jason.wessel@windriver.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080502)
MIME-Version: 1.0
To: Atsushi Nemoto <anemo@mba.ocn.ne.jp>
CC: linux-kernel@vger.kernel.org, ralf@linux-mips.org,
       linux-mips@linux-mips.org
Subject: Re: [PATCH 2/3] kgdb, mips: add arch support for the kernel's kgdb
 core
References: <1216400928-29097-1-git-send-email-jason.wessel@windriver.com><1216400928-29097-2-git-send-email-jason.wessel@windriver.com><1216400928-29097-3-git-send-email-jason.wessel@windriver.com> <20080725.012748.108121457.anemo@mba.ocn.ne.jp>
In-Reply-To: <20080725.012748.108121457.anemo@mba.ocn.ne.jp>
Content-Type: multipart/mixed;
 boundary="------------080009090105060707000603"
X-OriginalArrivalTime: 25 Jul 2008 03:00:25.0119 (UTC) FILETIME=[95D552F0:01C8EE02]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------080009090105060707000603
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

Atsushi Nemoto wrote:
> On Fri, 18 Jul 2008 12:08:47 -0500, Jason Wessel <jason.wessel@windriver.com> wrote:
>> diff --git a/include/asm-mips/kgdb.h b/include/asm-mips/kgdb.h
> ...
>> +static inline void arch_kgdb_breakpoint(void)
>> +{
>> +	__asm__ __volatile__(
>> +		".globl breakinst\n\t"
>> +		".set\tnoreorder\n\t"
>> +		"nop\n"
>> +		"breakinst:\tbreak\n\t"
>> +		"nop\n\t"
>> +		".set\treorder");
>> +}
> 
> The gcc might inline kgdb_breakpoint() which includes
> arch_kgdb_breakpoint().  I got this error with gcc 4.3.1:
> 
>   CC      kernel/kgdb.o
> {standard input}: Assembler messages:
> {standard input}:809: Error: symbol `breakinst' is already defined
> {standard input}:913: Error: symbol `breakinst' is already defined
> {standard input}:1233: Error: symbol `breakinst' is already defined
> 
> Moving arch_kgdb_breakpoint() into arch/mips/kernel/kgdb.c should
> solve the problem.
> 
> ---
> Atsushi Nemoto


It seem ok to me to try it.  Here is version 3 of the patch, which I was going to send to Ralf.


Jason.

--------------080009090105060707000603
Content-Type: text/x-diff;
 name="mips-lite.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="mips-lite.patch"

From: Jason Wessel <jason.wessel@windriver.com>
CC: ralf@linux-mips.org
Subject: [PATCH] kgdb, mips: add arch support for the kernel's kgdb core

The new kgdb architecture specific handler registers and unregisters
dynamically for exceptions depending on when you configure a kgdb I/O
driver.  

Aside from initializing the exceptions earlier in the boot process,
kgdb should have no impact on a device when it is compiled in so long
as an I/O module is not configured for use.

There have been quite a number of contributors during the existence of
this patch (see arch/mips/kernel/kgdb.c).  Most recently Jason
re-wrote the mips kgdb logic to use the die notification handlers.

Signed-off-by: Jason Wessel <jason.wessel@windriver.com>

---
 arch/mips/Kconfig         |    1 
 arch/mips/kernel/Makefile |    1 
 arch/mips/kernel/irq.c    |   15 ++
 arch/mips/kernel/kgdb.c   |  285 ++++++++++++++++++++++++++++++++++++++++++++++
 arch/mips/kernel/traps.c  |   21 +++
 include/asm-mips/kdebug.h |   14 ++
 include/asm-mips/kgdb.h   |   44 +++++++
 7 files changed, 380 insertions(+), 1 deletion(-)

--- a/arch/mips/kernel/Makefile
+++ b/arch/mips/kernel/Makefile
@@ -71,6 +71,7 @@ obj-$(CONFIG_MIPS32_COMPAT)	+= linux32.o
 obj-$(CONFIG_MIPS32_N32)	+= binfmt_elfn32.o scall64-n32.o signal_n32.o
 obj-$(CONFIG_MIPS32_O32)	+= binfmt_elfo32.o scall64-o32.o
 
+obj-$(CONFIG_KGDB)		+= kgdb.o
 obj-$(CONFIG_PROC_FS)		+= proc.o
 
 obj-$(CONFIG_64BIT)		+= cpu-bugs64.o
--- a/arch/mips/kernel/irq.c
+++ b/arch/mips/kernel/irq.c
@@ -21,11 +21,16 @@
 #include <linux/sched.h>
 #include <linux/seq_file.h>
 #include <linux/kallsyms.h>
+#include <linux/kgdb.h>
 
 #include <asm/atomic.h>
 #include <asm/system.h>
 #include <asm/uaccess.h>
 
+#ifdef CONFIG_KGDB
+int kgdb_early_setup;
+#endif
+
 static unsigned long irq_map[NR_IRQS / BITS_PER_LONG];
 
 int allocate_irqno(void)
@@ -130,8 +135,18 @@ void __init init_IRQ(void)
 {
 	int i;
 
+#ifdef CONFIG_KGDB
+	if (kgdb_early_setup)
+		return;
+#endif
+
 	for (i = 0; i < NR_IRQS; i++)
 		set_irq_noprobe(i);
 
 	arch_init_irq();
+
+#ifdef CONFIG_KGDB
+	if (!kgdb_early_setup)
+		kgdb_early_setup = 1;
+#endif
 }
--- /dev/null
+++ b/arch/mips/kernel/kgdb.c
@@ -0,0 +1,285 @@
+/*
+ * arch/mips/kernel/kgdb.c
+ *
+ *  Originally written by Glenn Engel, Lake Stevens Instrument Division
+ *
+ *  Contributed by HP Systems
+ *
+ *  Modified for Linux/MIPS (and MIPS in general) by Andreas Busse
+ *  Send complaints, suggestions etc. to <andy@waldorf-gmbh.de>
+ *
+ *  Copyright (C) 1995 Andreas Busse
+ *
+ *  Copyright (C) 2003 MontaVista Software Inc.
+ *  Author: Jun Sun, jsun@mvista.com or jsun@junsun.net
+ *
+ *  Copyright (C) 2004-2005 MontaVista Software Inc.
+ *  Author: Manish Lachwani, mlachwani@mvista.com or manish@koffee-break.com
+ *
+ *  Copyright (C) 2007-2008 Wind River Systems, Inc.
+ *  Author/Maintainer: Jason Wessel, jason.wessel@windriver.com
+ *
+ *  This file is licensed under the terms of the GNU General Public License
+ *  version 2. This program is licensed "as is" without any warranty of any
+ *  kind, whether express or implied.
+ */
+
+#include <linux/ptrace.h>		/* for linux pt_regs struct */
+#include <linux/kgdb.h>
+#include <linux/kdebug.h>
+#include <linux/sched.h>
+#include <asm/fpu.h>
+#include <asm/cacheflush.h>
+#include <asm/processor.h>
+#include <asm/sigcontext.h>
+
+static struct hard_trap_info {
+	unsigned char tt;	/* Trap type code for MIPS R3xxx and R4xxx */
+	unsigned char signo;	/* Signal that we map this trap into */
+} hard_trap_info[] = {
+	{ 6, SIGBUS },		/* instruction bus error */
+	{ 7, SIGBUS },		/* data bus error */
+	{ 9, SIGTRAP },		/* break */
+/*	{ 11, SIGILL },	*/	/* CPU unusable */
+	{ 12, SIGFPE },		/* overflow */
+	{ 13, SIGTRAP },	/* trap */
+	{ 14, SIGSEGV },	/* virtual instruction cache coherency */
+	{ 15, SIGFPE },		/* floating point exception */
+	{ 23, SIGSEGV },	/* watch */
+	{ 31, SIGSEGV },	/* virtual data cache coherency */
+	{ 0, 0}			/* Must be last */
+};
+
+void arch_kgdb_breakpoint(void)
+{
+	__asm__ __volatile__(
+		".globl breakinst\n\t"
+		".set\tnoreorder\n\t"
+		"nop\n"
+		"breakinst:\tbreak\n\t"
+		"nop\n\t"
+		".set\treorder");
+}
+
+static void kgdb_call_nmi_hook(void *ignored)
+{
+	kgdb_nmicallback(raw_smp_processor_id(), (void *)0);
+}
+
+void kgdb_roundup_cpus(unsigned long flags)
+{
+	local_irq_enable();
+	smp_call_function(kgdb_call_nmi_hook, NULL, NULL);
+	local_irq_disable();
+}
+
+static int compute_signal(int tt)
+{
+	struct hard_trap_info *ht;
+
+	for (ht = hard_trap_info; ht->tt && ht->signo; ht++)
+		if (ht->tt == tt)
+			return ht->signo;
+
+	return SIGHUP;		/* default for things we don't know about */
+}
+
+void pt_regs_to_gdb_regs(unsigned long *gdb_regs, struct pt_regs *regs)
+{
+	int reg;
+
+#if (KGDB_GDB_REG_SIZE == 32)
+	u32 *ptr = (u32 *)gdb_regs;
+#else
+	u64 *ptr = (u64 *)gdb_regs;
+#endif
+
+	for (reg = 0; reg < 32; reg++)
+		*(ptr++) = regs->regs[reg];
+
+	*(ptr++) = regs->cp0_status;
+	*(ptr++) = regs->lo;
+	*(ptr++) = regs->hi;
+	*(ptr++) = regs->cp0_badvaddr;
+	*(ptr++) = regs->cp0_cause;
+	*(ptr++) = regs->cp0_epc;
+
+	/* FP REGS */
+	if (!(current && (regs->cp0_status & ST0_CU1)))
+		return;
+
+	save_fp(current);
+	for (reg = 0; reg < 32; reg++)
+		*(ptr++) = current->thread.fpu.fpr[reg];
+
+	return;
+}
+
+void gdb_regs_to_pt_regs(unsigned long *gdb_regs, struct pt_regs *regs)
+{
+	int reg;
+
+#if (KGDB_GDB_REG_SIZE == 32)
+	const u32 *ptr = (u32 *)gdb_regs;
+#else
+	const u64 *ptr = (u64 *)gdb_regs;
+#endif
+
+	for (reg = 0; reg < 32; reg++)
+		regs->regs[reg] = *(ptr++);
+
+	regs->cp0_status = *(ptr++);
+	regs->lo = *(ptr++);
+	regs->hi = *(ptr++);
+	regs->cp0_badvaddr = *(ptr++);
+	regs->cp0_cause = *(ptr++);
+	regs->cp0_epc = *(ptr++);
+
+	/* FP REGS from current */
+	if (!(current && (regs->cp0_status & ST0_CU1)))
+		return;
+
+	for (reg = 0; reg < 32; reg++)
+		current->thread.fpu.fpr[reg] = *(ptr++);
+	restore_fp(current);
+
+	return;
+}
+
+/*
+ * Similar to regs_to_gdb_regs() except that process is sleeping and so
+ * we may not be able to get all the info.
+ */
+void sleeping_thread_to_gdb_regs(unsigned long *gdb_regs, struct task_struct *p)
+{
+	int reg;
+	struct thread_info *ti = task_thread_info(p);
+	unsigned long ksp = (unsigned long)ti + THREAD_SIZE - 32;
+	struct pt_regs *regs = (struct pt_regs *)ksp - 1;
+#if (KGDB_GDB_REG_SIZE == 32)
+	u32 *ptr = (u32 *)gdb_regs;
+#else
+	u64 *ptr = (u64 *)gdb_regs;
+#endif
+
+	for (reg = 0; reg < 16; reg++)
+		*(ptr++) = regs->regs[reg];
+
+	/* S0 - S7 */
+	for (reg = 16; reg < 24; reg++)
+		*(ptr++) = regs->regs[reg];
+
+	for (reg = 24; reg < 28; reg++)
+		*(ptr++) = 0;
+
+	/* GP, SP, FP, RA */
+	for (reg = 28; reg < 32; reg++)
+		*(ptr++) = regs->regs[reg];
+
+	*(ptr++) = regs->cp0_status;
+	*(ptr++) = regs->lo;
+	*(ptr++) = regs->hi;
+	*(ptr++) = regs->cp0_badvaddr;
+	*(ptr++) = regs->cp0_cause;
+	*(ptr++) = regs->cp0_epc;
+
+	return;
+}
+
+/*
+ * Calls linux_debug_hook before the kernel dies. If KGDB is enabled,
+ * then try to fall into the debugger
+ */
+static int kgdb_mips_notify(struct notifier_block *self, unsigned long cmd,
+			    void *ptr)
+{
+	struct die_args *args = (struct die_args *)ptr;
+	struct pt_regs *regs = args->regs;
+	int trap = (regs->cp0_cause & 0x7c) >> 2;
+
+	if (fixup_exception(regs))
+		return NOTIFY_DONE;
+
+	/* Userpace events, ignore. */
+	if (user_mode(regs))
+		return NOTIFY_DONE;
+
+	if (atomic_read(&kgdb_active) != -1)
+		kgdb_nmicallback(smp_processor_id(), regs);
+
+	if (kgdb_handle_exception(trap, compute_signal(trap), 0, regs))
+		return NOTIFY_DONE;
+
+	if (atomic_read(&kgdb_setting_breakpoint))
+		if ((trap == 9) && (regs->cp0_epc == (unsigned long)breakinst))
+			regs->cp0_epc += 4;
+
+	/* In SMP mode, __flush_cache_all does IPI */
+	local_irq_enable();
+	__flush_cache_all();
+
+	return NOTIFY_STOP;
+}
+
+static struct notifier_block kgdb_notifier = {
+	.notifier_call = kgdb_mips_notify,
+};
+
+/*
+ * Handle the 's' and 'c' commands
+ */
+int kgdb_arch_handle_exception(int vector, int signo, int err_code,
+			       char *remcom_in_buffer, char *remcom_out_buffer,
+			       struct pt_regs *regs)
+{
+	char *ptr;
+	unsigned long address;
+	int cpu = smp_processor_id();
+
+	switch (remcom_in_buffer[0]) {
+	case 's':
+	case 'c':
+		/* handle the optional parameter */
+		ptr = &remcom_in_buffer[1];
+		if (kgdb_hex2long(&ptr, &address))
+			regs->cp0_epc = address;
+
+		atomic_set(&kgdb_cpu_doing_single_step, -1);
+		if (remcom_in_buffer[0] == 's')
+			if (kgdb_contthread)
+				atomic_set(&kgdb_cpu_doing_single_step, cpu);
+
+		return 0;
+	}
+
+	return -1;
+}
+
+struct kgdb_arch arch_kgdb_ops = {
+#ifdef CONFIG_CPU_LITTLE_ENDIAN
+	.gdb_bpt_instr = {0xd},
+#else /* ! CONFIG_CPU_LITTLE_ENDIAN */
+	.gdb_bpt_instr = {0x00, 0x00, 0x00, 0x0d},
+#endif
+};
+
+/*
+ * We use kgdb_early_setup so that functions we need to call now don't
+ * cause trouble when called again later.
+ */
+int kgdb_arch_init(void)
+{
+	register_die_notifier(&kgdb_notifier);
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
+	unregister_die_notifier(&kgdb_notifier);
+}
--- a/arch/mips/kernel/traps.c
+++ b/arch/mips/kernel/traps.c
@@ -23,6 +23,8 @@
 #include <linux/bootmem.h>
 #include <linux/interrupt.h>
 #include <linux/ptrace.h>
+#include <linux/kgdb.h>
+#include <linux/kdebug.h>
 
 #include <asm/bootinfo.h>
 #include <asm/branch.h>
@@ -425,6 +427,10 @@ asmlinkage void do_be(struct pt_regs *re
 	printk(KERN_ALERT "%s bus error, epc == %0*lx, ra == %0*lx\n",
 	       data ? "Data" : "Instruction",
 	       field, regs->cp0_epc, field, regs->regs[31]);
+	if (notify_die(DIE_OOPS, "bus error", regs, SIGBUS, 0, 0)
+	    == NOTIFY_STOP)
+		return;
+
 	die_if_kernel("Oops", regs);
 	force_sig(SIGBUS, current);
 }
@@ -623,6 +629,9 @@ asmlinkage void do_fpe(struct pt_regs *r
 {
 	siginfo_t info;
 
+	if (notify_die(DIE_FP, "FP exception", regs, SIGFPE, 0, 0)
+	    == NOTIFY_STOP)
+		return;
 	die_if_kernel("FP exception in kernel code", regs);
 
 	if (fcr31 & FPU_CSR_UNI_X) {
@@ -682,6 +691,9 @@ static void do_trap_or_bp(struct pt_regs
 	siginfo_t info;
 	char b[40];
 
+	if (notify_die(DIE_TRAP, str, regs, code, 0, 0) == NOTIFY_STOP)
+		return;
+
 	/*
 	 * A short test says that IRIX 5.3 sends SIGTRAP for all trap
 	 * insns, even for trap and break codes that indicate arithmetic
@@ -762,6 +774,10 @@ asmlinkage void do_ri(struct pt_regs *re
 	unsigned int opcode = 0;
 	int status = -1;
 
+	if (notify_die(DIE_RI, "RI Fault", regs, SIGSEGV, 0, 0)
+	    == NOTIFY_STOP)
+		return;
+
 	die_if_kernel("Reserved instruction in kernel code", regs);
 
 	if (unlikely(compute_return_epc(regs) < 0))
@@ -1537,6 +1553,11 @@ void __init trap_init(void)
 	extern char except_vec4;
 	unsigned long i;
 
+#if defined(CONFIG_KGDB)
+	if (kgdb_early_setup)
+		return;	/* Already done */
+#endif
+
 	if (cpu_has_veic || cpu_has_vint)
 		ebase = (unsigned long) alloc_bootmem_low_pages(0x200 + VECTORSPACING*64);
 	else
--- /dev/null
+++ b/include/asm-mips/kgdb.h
@@ -0,0 +1,44 @@
+#ifdef __KERNEL__
+#ifndef _ASM_KGDB_H_
+#define _ASM_KGDB_H_
+
+#include <asm/sgidefs.h>
+
+#ifndef __ASSEMBLY__
+#if (_MIPS_ISA == _MIPS_ISA_MIPS1) || (_MIPS_ISA == _MIPS_ISA_MIPS2) || \
+	(_MIPS_ISA == _MIPS_ISA_MIPS32)
+
+#define KGDB_GDB_REG_SIZE 32
+
+#elif (_MIPS_ISA == _MIPS_ISA_MIPS3) || (_MIPS_ISA == _MIPS_ISA_MIPS4) || \
+	(_MIPS_ISA == _MIPS_ISA_MIPS64)
+
+#ifdef CONFIG_32BIT
+#define KGDB_GDB_REG_SIZE 32
+#else /* CONFIG_CPU_32BIT */
+#define KGDB_GDB_REG_SIZE 64
+#endif
+#else
+#error "Need to set KGDB_GDB_REG_SIZE for MIPS ISA"
+#endif /* _MIPS_ISA */
+
+#define BUFMAX			2048
+#if (KGDB_GDB_REG_SIZE == 32)
+#define NUMREGBYTES		(90*sizeof(u32))
+#define NUMCRITREGBYTES		(12*sizeof(u32))
+#else
+#define NUMREGBYTES		(90*sizeof(u64))
+#define NUMCRITREGBYTES		(12*sizeof(u64))
+#endif
+#define BREAK_INSTR_SIZE	4
+#define CACHE_FLUSH_IS_SAFE	0
+
+extern void arch_kgdb_breakpoint(void);
+extern int kgdb_early_setup;
+extern void *saved_vectors[32];
+extern void handle_exception(struct pt_regs *regs);
+extern void breakinst(void);
+
+#endif				/* !__ASSEMBLY__ */
+#endif				/* _ASM_KGDB_H_ */
+#endif				/* __KERNEL__ */
--- a/arch/mips/Kconfig
+++ b/arch/mips/Kconfig
@@ -3,6 +3,7 @@ config MIPS
 	default y
 	select HAVE_IDE
 	select HAVE_OPROFILE
+	select HAVE_ARCH_KGDB
 	# Horrible source of confusion.  Die, die, die ...
 	select EMBEDDED
 	select RTC_LIB
--- a/include/asm-mips/kdebug.h
+++ b/include/asm-mips/kdebug.h
@@ -1 +1,13 @@
-#include <asm-generic/kdebug.h>
+#ifndef _ASM_MIPS_KDEBUG_H
+#define _ASM_MIPS_KDEBUG_H
+
+#include <linux/notifier.h>
+
+enum die_val {
+	DIE_OOPS = 1,
+	DIE_FP,
+	DIE_TRAP,
+	DIE_RI,
+};
+
+#endif /* _ASM_MIPS_KDEBUG_H */

--------------080009090105060707000603--
