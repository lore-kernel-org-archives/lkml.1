Return-Path: <linux-kernel-owner+w=401wt.eu-S1760978AbYGRRKk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760978AbYGRRKk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2008 13:10:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760783AbYGRRJy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jul 2008 13:09:54 -0400
Received: from mail.windriver.com ([147.11.1.11]:36330 "EHLO mail.wrs.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756031AbYGRRJu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2008 13:09:50 -0400
From: Jason Wessel <jason.wessel@windriver.com>
To: linux-kernel@vger.kernel.org
Cc: ralf@linux-mips.org, linux-mips@linux-mips.org,
       Jason Wessel <jason.wessel@windriver.com>
Subject: [PATCH 2/3] kgdb, mips: add arch support for the kernel's kgdb core
Date: Fri, 18 Jul 2008 12:08:47 -0500
Message-Id: <1216400928-29097-3-git-send-email-jason.wessel@windriver.com>
X-Mailer: git-send-email 1.5.5.1
In-Reply-To: <1216400928-29097-2-git-send-email-jason.wessel@windriver.com>
References: <1216400928-29097-1-git-send-email-jason.wessel@windriver.com>
 <1216400928-29097-2-git-send-email-jason.wessel@windriver.com>
X-OriginalArrivalTime: 18 Jul 2008 17:08:46.0786 (UTC) FILETIME=[F0B31220:01C8E8F8]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The new kgdb architecture specific handler registers and unregisters
dynamically for exceptions depending on when you configure a kgdb I/O
driver.  Asside from initializing the exceptions earlier in the boot
process, kgdb should have no impact on a device when it is compiled in
so long as an I/O module is not configured for use.

There have been quite a number of contributors during the existence
of this patch (see arch/mips/kernel/kgdb.c).

Signed-off-by: Jason Wessel <jason.wessel@windriver.com>
---
 arch/mips/Kconfig               |    1 +
 arch/mips/kernel/Makefile       |    1 +
 arch/mips/kernel/irq.c          |   15 ++
 arch/mips/kernel/kgdb.c         |  295 ++++++++++++++++++++++++++++++++++
 arch/mips/kernel/kgdb_handler.S |  339 +++++++++++++++++++++++++++++++++++++++
 arch/mips/kernel/traps.c        |    6 +
 include/asm-mips/asmmacro-32.h  |   43 +++++
 include/asm-mips/asmmacro-64.h  |   99 ++++++++++++
 include/asm-mips/kgdb.h         |   54 ++++++
 9 files changed, 853 insertions(+), 0 deletions(-)
 create mode 100644 arch/mips/kernel/kgdb.c
 create mode 100644 arch/mips/kernel/kgdb_handler.S
 create mode 100644 include/asm-mips/kgdb.h

diff --git a/arch/mips/Kconfig b/arch/mips/Kconfig
index 1c07cb9..8c1b36e 100644
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
diff --git a/arch/mips/kernel/Makefile b/arch/mips/kernel/Makefile
index 73ff048..a312d4c 100644
--- a/arch/mips/kernel/Makefile
+++ b/arch/mips/kernel/Makefile
@@ -71,6 +71,7 @@ obj-$(CONFIG_MIPS32_COMPAT)	+= linux32.o ptrace32.o signal32.o
 obj-$(CONFIG_MIPS32_N32)	+= binfmt_elfn32.o scall64-n32.o signal_n32.o
 obj-$(CONFIG_MIPS32_O32)	+= binfmt_elfo32.o scall64-o32.o
 
+obj-$(CONFIG_KGDB)		+= kgdb_handler.o kgdb.o
 obj-$(CONFIG_PROC_FS)		+= proc.o
 
 obj-$(CONFIG_64BIT)		+= cpu-bugs64.o
diff --git a/arch/mips/kernel/irq.c b/arch/mips/kernel/irq.c
index 8acba08..7f1337b 100644
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
@@ -133,5 +138,15 @@ void __init init_IRQ(void)
 	for (i = 0; i < NR_IRQS; i++)
 		set_irq_noprobe(i);
 
+#ifdef CONFIG_KGDB
+	if (kgdb_early_setup)
+		return;
+#endif
+
 	arch_init_irq();
+
+#ifdef CONFIG_KGDB
+	if (!kgdb_early_setup)
+		kgdb_early_setup = 1;
+#endif
 }
diff --git a/arch/mips/kernel/kgdb.c b/arch/mips/kernel/kgdb.c
new file mode 100644
index 0000000..d553d21
--- /dev/null
+++ b/arch/mips/kernel/kgdb.c
@@ -0,0 +1,295 @@
+/*
+ * arch/mips/kernel/kgdb.c
+ *
+ *  Originally written by Glenn Engel, Lake Stevens Instrument Division
+ *
+ *  Contributed by HP Systems
+ *
+ *  Modified for SPARC by Stu Grossman, Cygnus Support.
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
+ *  Author: Jason Wessel, jason.wessel@windriver.com
+ *
+ *  This file is licensed under the terms of the GNU General Public License
+ *  version 2. This program is licensed "as is" without any warranty of any
+ *  kind, whether express or implied.
+ */
+
+#include <linux/string.h>
+#include <linux/kernel.h>
+#include <linux/sched.h>
+#include <linux/smp.h>
+#include <linux/spinlock.h>
+#include <linux/delay.h>
+#include <linux/ptrace.h>		/* for linux pt_regs struct */
+#include <asm/system.h>
+#include <linux/kgdb.h>
+#include <linux/init.h>
+#include <linux/kdebug.h>
+#include <asm/inst.h>
+#include <asm/gdb-stub.h>
+#include <asm/cacheflush.h>
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
+/* Save the normal trap handlers for user-mode traps. */
+void *saved_vectors[32];
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
+/*
+ * Set up exception handlers for tracing and breakpoints
+ */
+void handle_exception(struct pt_regs *regs)
+{
+	int trap = (regs->cp0_cause & 0x7c) >> 2;
+
+	if (fixup_exception(regs))
+		return;
+
+	if (atomic_read(&kgdb_active) != -1)
+		kgdb_nmicallback(smp_processor_id(), regs);
+
+	if (atomic_read(&kgdb_setting_breakpoint))
+		if ((trap == 9) && (regs->cp0_epc == (unsigned long)breakinst))
+			regs->cp0_epc += 4;
+
+	kgdb_handle_exception(0, compute_signal(trap), 0, regs);
+
+	/* In SMP mode, __flush_cache_all does IPI */
+	local_irq_enable();
+	__flush_cache_all();
+}
+
+void set_debug_traps(void)
+{
+	struct hard_trap_info *ht;
+	unsigned long flags;
+
+	local_irq_save(flags);
+
+	for (ht = hard_trap_info; ht->tt && ht->signo; ht++)
+		saved_vectors[ht->tt] = set_except_vector(ht->tt, trap_low);
+
+	local_irq_restore(flags);
+}
+
+void pt_regs_to_gdb_regs(unsigned long *gdb_regs, struct pt_regs *regs)
+{
+	int reg;
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
+	return;
+}
+
+void gdb_regs_to_pt_regs(unsigned long *gdb_regs, struct pt_regs *regs)
+{
+
+	int reg;
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
+	/* See if KGDB is interested. */
+	if (user_mode(regs))
+		/* Userpace events, ignore. */
+		return NOTIFY_DONE;
+
+	kgdb_handle_exception(trap, compute_signal(trap), 0, regs);
+	return NOTIFY_OK;
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
+	/* Set our traps. */
+	/* This needs to be done more finely grained again, paired in
+	 * a before/after in kgdb_handle_exception(...) -- Tom */
+	set_debug_traps();
+	register_die_notifier(&kgdb_notifier);
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
+	unregister_die_notifier(&kgdb_notifier);
+}
diff --git a/arch/mips/kernel/kgdb_handler.S b/arch/mips/kernel/kgdb_handler.S
new file mode 100644
index 0000000..6d7028d
--- /dev/null
+++ b/arch/mips/kernel/kgdb_handler.S
@@ -0,0 +1,339 @@
+/*
+ * arch/mips/kernel/kgdb_handler.S
+ *
+ * Copyright (C) 2007-2008 Wind River Systems, Inc.
+ *
+ * Copyright (C) 2004-2005 MontaVista Software Inc.
+ * Author: Manish Lachwani, mlachwani@mvista.com or manish@koffee-break.com
+ *
+ * This file is licensed under the terms of the GNU General Public
+ * version 2. This program is licensed "as is" without any warranty of any
+ * kind, whether express or implied.
+ */
+
+/*
+ * Trap Handler for the new KGDB framework. The main KGDB handler is
+ * handle_exception that will be called from here
+ *
+ */
+
+#include <linux/sys.h>
+
+#include <asm/asm.h>
+#include <asm/errno.h>
+#include <asm/mipsregs.h>
+#include <asm/regdef.h>
+#include <asm/stackframe.h>
+#include <asm/gdb-stub.h>
+
+#ifdef CONFIG_32BIT
+#define DMFC0	mfc0
+#define DMTC0	mtc0
+#define LDC1	lwc1
+#define SDC1	swc1
+#endif
+#ifdef CONFIG_64BIT
+#define DMFC0	dmfc0
+#define DMTC0	dmtc0
+#define LDC1	ldc1
+#define SDC1	sdc1
+#endif
+
+#include <asm/asmmacro.h>
+
+/*
+ * [jsun] We reserves about 2x GDB_FR_SIZE in stack.  The lower (addressed)
+ * part is used to store registers and passed to exception handler.
+ * The upper part is reserved for "call func" feature where gdb client
+ * saves some of the regs, setups call frame and passes args.
+ *
+ * A trace shows about 200 bytes are used to store about half of all regs.
+ * The rest should be big enough for frame setup and passing args.
+ */
+
+/*
+ * The low level trap handler
+ */
+		.align 	5
+		NESTED(trap_low, GDB_FR_SIZE, sp)
+		.set	noat
+		.set 	noreorder
+
+		mfc0	k0, CP0_STATUS
+		sll	k0, 3     		/* extract cu0 bit */
+		bltz	k0, 1f
+		move	k1, sp
+
+		/*
+		 * Called from user mode, go somewhere else.
+		 */
+#if defined(CONFIG_32BIT)
+		lui	k1, %hi(saved_vectors)
+		mfc0	k0, CP0_CAUSE
+		andi	k0, k0, 0x7c
+		add	k1, k1, k0
+		lw	k0, %lo(saved_vectors)(k1)
+#elif defined(CONFIG_64BIT) && !defined(CONFIG_BUILD_ELF32)
+		DMFC0	k0, CP0_CAUSE
+		lui	k1, %highest(saved_vectors)
+                andi    k0, k0, 0x7c           /* mask exception type */
+                dsll    k0, 1                  /* turn into byte offset */
+		daddiu	k1, %higher(saved_vectors)
+		dsll	k1, k1, 16
+		daddiu	k1, %hi(saved_vectors)
+		dsll	k1, k1, 16
+		daddu	k1, k1, k0
+		LONG_L	k0, %lo(saved_vectors)(k1)
+#else
+#error "MIPS configuration is unsupported for kgdb!!"
+#endif
+		jr	k0
+		nop
+1:
+		move	k0, sp
+		PTR_SUBU sp, k1, GDB_FR_SIZE*2	# see comment above
+		LONG_S	k0, GDB_FR_REG29(sp)
+		LONG_S	$2, GDB_FR_REG2(sp)
+
+/*
+ * First save the CP0 and special registers
+ */
+
+		mfc0	v0, CP0_STATUS
+		LONG_S	v0, GDB_FR_STATUS(sp)
+		mfc0	v0, CP0_CAUSE
+		LONG_S	v0, GDB_FR_CAUSE(sp)
+		DMFC0	v0, CP0_EPC
+		LONG_S	v0, GDB_FR_EPC(sp)
+		DMFC0	v0, CP0_BADVADDR
+		LONG_S	v0, GDB_FR_BADVADDR(sp)
+		mfhi	v0
+		LONG_S	v0, GDB_FR_HI(sp)
+		mflo	v0
+		LONG_S	v0, GDB_FR_LO(sp)
+
+/*
+ * Now the integer registers
+ */
+
+		LONG_S	zero, GDB_FR_REG0(sp)		/* I know... */
+		LONG_S	$1, GDB_FR_REG1(sp)
+		/* v0 already saved */
+		LONG_S	$3, GDB_FR_REG3(sp)
+		LONG_S	$4, GDB_FR_REG4(sp)
+		LONG_S	$5, GDB_FR_REG5(sp)
+		LONG_S	$6, GDB_FR_REG6(sp)
+		LONG_S	$7, GDB_FR_REG7(sp)
+		LONG_S	$8, GDB_FR_REG8(sp)
+		LONG_S	$9, GDB_FR_REG9(sp)
+		LONG_S	$10, GDB_FR_REG10(sp)
+		LONG_S	$11, GDB_FR_REG11(sp)
+		LONG_S	$12, GDB_FR_REG12(sp)
+		LONG_S	$13, GDB_FR_REG13(sp)
+		LONG_S	$14, GDB_FR_REG14(sp)
+		LONG_S	$15, GDB_FR_REG15(sp)
+		LONG_S	$16, GDB_FR_REG16(sp)
+		LONG_S	$17, GDB_FR_REG17(sp)
+		LONG_S	$18, GDB_FR_REG18(sp)
+		LONG_S	$19, GDB_FR_REG19(sp)
+		LONG_S	$20, GDB_FR_REG20(sp)
+		LONG_S	$21, GDB_FR_REG21(sp)
+		LONG_S	$22, GDB_FR_REG22(sp)
+		LONG_S	$23, GDB_FR_REG23(sp)
+		LONG_S	$24, GDB_FR_REG24(sp)
+		LONG_S	$25, GDB_FR_REG25(sp)
+		LONG_S	$26, GDB_FR_REG26(sp)
+		LONG_S	$27, GDB_FR_REG27(sp)
+		LONG_S	$28, GDB_FR_REG28(sp)
+		/* sp already saved */
+		LONG_S	$30, GDB_FR_REG30(sp)
+		LONG_S	$31, GDB_FR_REG31(sp)
+
+		CLI				/* disable interrupts */
+
+/*
+ * Followed by the floating point registers
+ */
+		mfc0	v0, CP0_STATUS		/* FPU enabled? */
+		srl	v0, v0, 16
+		andi	v0, v0, (ST0_CU1 >> 16)
+
+		beqz	v0,3f			/* disabled, skip */
+		 nop
+
+		li	t0, 0
+#ifdef CONFIG_64BIT
+		mfc0	t0, CP0_STATUS
+#endif
+		fpu_save_double_kgdb sp t0 t1	# clobbers t1
+
+
+/*
+ * Current stack frame ptr
+ */
+
+3:
+		LONG_S	sp, GDB_FR_FRP(sp)
+
+/*
+ * CP0 registers (R4000/R4400 unused registers skipped)
+ */
+
+		mfc0	v0, CP0_INDEX
+		LONG_S	v0, GDB_FR_CP0_INDEX(sp)
+		mfc0	v0, CP0_RANDOM
+		LONG_S	v0, GDB_FR_CP0_RANDOM(sp)
+		DMFC0	v0, CP0_ENTRYLO0
+		LONG_S	v0, GDB_FR_CP0_ENTRYLO0(sp)
+		DMFC0	v0, CP0_ENTRYLO1
+		LONG_S	v0, GDB_FR_CP0_ENTRYLO1(sp)
+		DMFC0	v0, CP0_CONTEXT
+		LONG_S	v0, GDB_FR_CP0_CONTEXT(sp)
+		mfc0	v0, CP0_PAGEMASK
+		LONG_S	v0, GDB_FR_CP0_PAGEMASK(sp)
+		mfc0	v0, CP0_WIRED
+		LONG_S	v0, GDB_FR_CP0_WIRED(sp)
+		DMFC0	v0, CP0_ENTRYHI
+		LONG_S	v0, GDB_FR_CP0_ENTRYHI(sp)
+		mfc0	v0, CP0_PRID
+		LONG_S	v0, GDB_FR_CP0_PRID(sp)
+
+		.set	at
+
+/*
+ * Continue with the higher level handler
+ */
+
+		move	a0,sp
+
+		jal	handle_exception
+		 nop
+
+/*
+ * Restore all writable registers, in reverse order
+ */
+
+		.set	noat
+
+		LONG_L	v0, GDB_FR_CP0_ENTRYHI(sp)
+		LONG_L	v1, GDB_FR_CP0_WIRED(sp)
+		DMTC0	v0, CP0_ENTRYHI
+		mtc0	v1, CP0_WIRED
+		LONG_L	v0, GDB_FR_CP0_PAGEMASK(sp)
+		LONG_L	v1, GDB_FR_CP0_ENTRYLO1(sp)
+		mtc0	v0, CP0_PAGEMASK
+		DMTC0	v1, CP0_ENTRYLO1
+		LONG_L	v0, GDB_FR_CP0_ENTRYLO0(sp)
+		LONG_L	v1, GDB_FR_CP0_INDEX(sp)
+		DMTC0	v0, CP0_ENTRYLO0
+		LONG_L	v0, GDB_FR_CP0_CONTEXT(sp)
+		mtc0	v1, CP0_INDEX
+		DMTC0	v0, CP0_CONTEXT
+
+
+/*
+ * Next, the floating point registers
+ */
+		mfc0	v0, CP0_STATUS		/* check if FPU is enabled */
+		srl	v0, v0, 16
+		andi	v0, v0, (ST0_CU1 >> 16)
+
+		beqz	v0, 3f			/* disabled, skip */
+		 nop
+
+		li	t0, 0
+#ifdef CONFIG_64BIT
+		mfc0	t0, CP0_STATUS
+#endif
+		fpu_restore_double_kgdb sp t0 t1 # clobbers t1
+
+
+/*
+ * Now the CP0 and integer registers
+ */
+
+3:
+		mfc0	t0, CP0_STATUS
+		ori	t0, 0x1f
+		xori	t0, 0x1f
+		mtc0	t0, CP0_STATUS
+
+		LONG_L	v0, GDB_FR_STATUS(sp)
+		LONG_L	v1, GDB_FR_EPC(sp)
+		mtc0	v0, CP0_STATUS
+		DMTC0	v1, CP0_EPC
+		LONG_L	v0, GDB_FR_HI(sp)
+		LONG_L	v1, GDB_FR_LO(sp)
+		mthi	v0
+		mtlo	v1
+		LONG_L	$31, GDB_FR_REG31(sp)
+		LONG_L	$30, GDB_FR_REG30(sp)
+		LONG_L	$28, GDB_FR_REG28(sp)
+		LONG_L	$27, GDB_FR_REG27(sp)
+		LONG_L	$26, GDB_FR_REG26(sp)
+		LONG_L	$25, GDB_FR_REG25(sp)
+		LONG_L	$24, GDB_FR_REG24(sp)
+		LONG_L	$23, GDB_FR_REG23(sp)
+		LONG_L	$22, GDB_FR_REG22(sp)
+		LONG_L	$21, GDB_FR_REG21(sp)
+		LONG_L	$20, GDB_FR_REG20(sp)
+		LONG_L	$19, GDB_FR_REG19(sp)
+		LONG_L	$18, GDB_FR_REG18(sp)
+		LONG_L	$17, GDB_FR_REG17(sp)
+		LONG_L	$16, GDB_FR_REG16(sp)
+		LONG_L	$15, GDB_FR_REG15(sp)
+		LONG_L	$14, GDB_FR_REG14(sp)
+		LONG_L	$13, GDB_FR_REG13(sp)
+		LONG_L	$12, GDB_FR_REG12(sp)
+		LONG_L	$11, GDB_FR_REG11(sp)
+		LONG_L	$10, GDB_FR_REG10(sp)
+		LONG_L	$9, GDB_FR_REG9(sp)
+		LONG_L	$8, GDB_FR_REG8(sp)
+		LONG_L	$7, GDB_FR_REG7(sp)
+		LONG_L	$6, GDB_FR_REG6(sp)
+		LONG_L	$5, GDB_FR_REG5(sp)
+		LONG_L	$4, GDB_FR_REG4(sp)
+		LONG_L	$3, GDB_FR_REG3(sp)
+		LONG_L	$2, GDB_FR_REG2(sp)
+		LONG_L	$1, GDB_FR_REG1(sp)
+#if defined(CONFIG_CPU_R3000) || defined(CONFIG_CPU_TX39XX)
+		LONG_L	k0, GDB_FR_EPC(sp)
+		LONG_L	$29, GDB_FR_REG29(sp)		/* Deallocate stack */
+		jr	k0
+		rfe
+#else
+		LONG_L	sp, GDB_FR_REG29(sp)		/* Deallocate stack */
+
+		.set	mips3
+		eret
+		.set	mips0
+#endif
+		.set	at
+		.set	reorder
+		END(trap_low)
+
+LEAF(kgdb_read_byte)
+4:		lb	t0, (a0)
+		sb	t0, (a1)
+		li	v0, 0
+		jr	ra
+		.section __ex_table,"a"
+		PTR	4b, kgdbfault
+		.previous
+		END(kgdb_read_byte)
+
+LEAF(kgdb_write_byte)
+5:		sb	a0, (a1)
+		li	v0, 0
+		jr	ra
+		.section __ex_table,"a"
+		PTR	5b, kgdbfault
+		.previous
+		END(kgdb_write_byte)
+
+		.type	kgdbfault@function
+		.ent	kgdbfault
+
+kgdbfault:	li	v0, -EFAULT
+		jr	ra
+		.end	kgdbfault
diff --git a/arch/mips/kernel/traps.c b/arch/mips/kernel/traps.c
index b8ea4e9..129ee35 100644
--- a/arch/mips/kernel/traps.c
+++ b/arch/mips/kernel/traps.c
@@ -23,6 +23,7 @@
 #include <linux/bootmem.h>
 #include <linux/interrupt.h>
 #include <linux/ptrace.h>
+#include <linux/kgdb.h>
 
 #include <asm/bootinfo.h>
 #include <asm/branch.h>
@@ -1537,6 +1538,11 @@ void __init trap_init(void)
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
diff --git a/include/asm-mips/asmmacro-32.h b/include/asm-mips/asmmacro-32.h
index 5de3963..ed9be99 100644
--- a/include/asm-mips/asmmacro-32.h
+++ b/include/asm-mips/asmmacro-32.h
@@ -11,6 +11,28 @@
 #include <asm/regdef.h>
 #include <asm/fpregdef.h>
 #include <asm/mipsregs.h>
+#include <asm/gdb-stub.h>
+
+	.macro	fpu_save_double_kgdb stack status tmp1 = t0
+	cfc1	\tmp1,  fcr31
+	sdc1	$f0, GDB_FR_FPR0(\stack)
+	sdc1	$f2, GDB_FR_FPR2(\stack)
+	sdc1	$f4, GDB_FR_FPR4(\stack)
+	sdc1	$f6, GDB_FR_FPR6(\stack)
+	sdc1	$f8, GDB_FR_FPR8(\stack)
+	sdc1	$f10, GDB_FR_FPR10(\stack)
+	sdc1	$f12, GDB_FR_FPR12(\stack)
+	sdc1	$f14, GDB_FR_FPR14(\stack)
+	sdc1	$f16, GDB_FR_FPR16(\stack)
+	sdc1	$f18, GDB_FR_FPR18(\stack)
+	sdc1	$f20, GDB_FR_FPR20(\stack)
+	sdc1	$f22, GDB_FR_FPR22(\stack)
+	sdc1	$f24, GDB_FR_FPR24(\stack)
+	sdc1	$f26, GDB_FR_FPR26(\stack)
+	sdc1	$f28, GDB_FR_FPR28(\stack)
+	sdc1	$f30, GDB_FR_FPR30(\stack)
+	sw	\tmp1, GDB_FR_FSR(\stack)
+	.endm
 
 	.macro	fpu_save_double thread status tmp1=t0
 	cfc1	\tmp1,  fcr31
@@ -91,6 +113,27 @@
 	ctc1	\tmp, fcr31
 	.endm
 
+	.macro	fpu_restore_double_kgdb stack status tmp = t0
+	lw	\tmp, GDB_FR_FSR(\stack)
+	ldc1	$f0,  GDB_FR_FPR0(\stack)
+	ldc1	$f2,  GDB_FR_FPR2(\stack)
+	ldc1	$f4,  GDB_FR_FPR4(\stack)
+	ldc1	$f6,  GDB_FR_FPR6(\stack)
+	ldc1	$f8,  GDB_FR_FPR8(\stack)
+	ldc1	$f10, GDB_FR_FPR10(\stack)
+	ldc1	$f12, GDB_FR_FPR12(\stack)
+	ldc1	$f14, GDB_FR_FPR14(\stack)
+	ldc1	$f16, GDB_FR_FPR16(\stack)
+	ldc1	$f18, GDB_FR_FPR18(\stack)
+	ldc1	$f20, GDB_FR_FPR20(\stack)
+	ldc1	$f22, GDB_FR_FPR22(\stack)
+	ldc1	$f24, GDB_FR_FPR24(\stack)
+	ldc1	$f26, GDB_FR_FPR26(\stack)
+	ldc1	$f28, GDB_FR_FPR28(\stack)
+	ldc1	$f30, GDB_FR_FPR30(\stack)
+	ctc1	\tmp, fcr31
+	.endm
+
 	.macro	fpu_restore_single thread tmp=t0
 	lw	\tmp, THREAD_FCR31(\thread)
 	lwc1	$f0,  THREAD_FPR0(\thread)
diff --git a/include/asm-mips/asmmacro-64.h b/include/asm-mips/asmmacro-64.h
index 225feef..9789218 100644
--- a/include/asm-mips/asmmacro-64.h
+++ b/include/asm-mips/asmmacro-64.h
@@ -12,6 +12,7 @@
 #include <asm/regdef.h>
 #include <asm/fpregdef.h>
 #include <asm/mipsregs.h>
+#include <asm/gdb-stub.h>
 
 	.macro	fpu_save_16even thread tmp=t0
 	cfc1	\tmp, fcr31
@@ -53,6 +54,46 @@
 	sdc1	$f31, THREAD_FPR31(\thread)
 	.endm
 
+	.macro	fpu_save_16odd_kgdb stack
+	sdc1	$f1, GDB_FR_FPR1(\stack)
+	sdc1	$f3, GDB_FR_FPR3(\stack)
+	sdc1	$f5, GDB_FR_FPR5(\stack)
+	sdc1	$f7, GDB_FR_FPR7(\stack)
+	sdc1	$f9, GDB_FR_FPR9(\stack)
+	sdc1	$f11, GDB_FR_FPR11(\stack)
+	sdc1	$f13, GDB_FR_FPR13(\stack)
+	sdc1	$f15, GDB_FR_FPR15(\stack)
+	sdc1	$f17, GDB_FR_FPR17(\stack)
+	sdc1	$f19, GDB_FR_FPR19(\stack)
+	sdc1	$f21, GDB_FR_FPR21(\stack)
+	sdc1	$f23, GDB_FR_FPR23(\stack)
+	sdc1	$f25, GDB_FR_FPR25(\stack)
+	sdc1	$f27, GDB_FR_FPR27(\stack)
+	sdc1	$f29, GDB_FR_FPR29(\stack)
+	sdc1	$f31, GDB_FR_FPR31(\stack)
+	.endm
+
+	.macro	fpu_save_16even_kgdb stack tmp = t0
+	cfc1	\tmp,  fcr31
+	sdc1	$f0, GDB_FR_FPR0(\stack)
+	sdc1	$f2, GDB_FR_FPR2(\stack)
+	sdc1	$f4, GDB_FR_FPR4(\stack)
+	sdc1	$f6, GDB_FR_FPR6(\stack)
+	sdc1	$f8, GDB_FR_FPR8(\stack)
+	sdc1	$f10, GDB_FR_FPR10(\stack)
+	sdc1	$f12, GDB_FR_FPR12(\stack)
+	sdc1	$f14, GDB_FR_FPR14(\stack)
+	sdc1	$f16, GDB_FR_FPR16(\stack)
+	sdc1	$f18, GDB_FR_FPR18(\stack)
+	sdc1	$f20, GDB_FR_FPR20(\stack)
+	sdc1	$f22, GDB_FR_FPR22(\stack)
+	sdc1	$f24, GDB_FR_FPR24(\stack)
+	sdc1	$f26, GDB_FR_FPR26(\stack)
+	sdc1	$f28, GDB_FR_FPR28(\stack)
+	sdc1	$f30, GDB_FR_FPR30(\stack)
+	sw	\tmp, GDB_FR_FSR(\stack)
+	.endm
+
 	.macro	fpu_save_double thread status tmp
 	sll	\tmp, \status, 5
 	bgez	\tmp, 2f
@@ -61,6 +102,15 @@
 	fpu_save_16even \thread \tmp
 	.endm
 
+	.macro	fpu_save_double_kgdb stack status tmp
+	sll	\tmp, \status, 5
+	bgez	\tmp, 2f
+	nop
+	fpu_save_16odd_kgdb \stack
+2:
+	fpu_save_16even_kgdb \stack \tmp
+	.endm
+
 	.macro	fpu_restore_16even thread tmp=t0
 	lw	\tmp, THREAD_FCR31(\thread)
 	ldc1	$f0,  THREAD_FPR0(\thread)
@@ -101,6 +151,46 @@
 	ldc1	$f31, THREAD_FPR31(\thread)
 	.endm
 
+	.macro	fpu_restore_16even_kgdb stack tmp = t0
+	lw	\tmp, GDB_FR_FSR(\stack)
+	ldc1	$f0,  GDB_FR_FPR0(\stack)
+	ldc1	$f2,  GDB_FR_FPR2(\stack)
+	ldc1	$f4,  GDB_FR_FPR4(\stack)
+	ldc1	$f6,  GDB_FR_FPR6(\stack)
+	ldc1	$f8,  GDB_FR_FPR8(\stack)
+	ldc1	$f10, GDB_FR_FPR10(\stack)
+	ldc1	$f12, GDB_FR_FPR12(\stack)
+	ldc1	$f14, GDB_FR_FPR14(\stack)
+	ldc1	$f16, GDB_FR_FPR16(\stack)
+	ldc1	$f18, GDB_FR_FPR18(\stack)
+	ldc1	$f20, GDB_FR_FPR20(\stack)
+	ldc1	$f22, GDB_FR_FPR22(\stack)
+	ldc1	$f24, GDB_FR_FPR24(\stack)
+	ldc1	$f26, GDB_FR_FPR26(\stack)
+	ldc1	$f28, GDB_FR_FPR28(\stack)
+	ldc1	$f30, GDB_FR_FPR30(\stack)
+	ctc1	\tmp, fcr31
+	.endm
+
+	.macro	fpu_restore_16odd_kgdb stack
+	ldc1	$f1,  GDB_FR_FPR1(\stack)
+	ldc1	$f3,  GDB_FR_FPR3(\stack)
+	ldc1	$f5,  GDB_FR_FPR5(\stack)
+	ldc1	$f7,  GDB_FR_FPR7(\stack)
+	ldc1	$f9,  GDB_FR_FPR9(\stack)
+	ldc1	$f11, GDB_FR_FPR11(\stack)
+	ldc1	$f13, GDB_FR_FPR13(\stack)
+	ldc1	$f15, GDB_FR_FPR15(\stack)
+	ldc1	$f17, GDB_FR_FPR17(\stack)
+	ldc1	$f19, GDB_FR_FPR19(\stack)
+	ldc1	$f21, GDB_FR_FPR21(\stack)
+	ldc1	$f23, GDB_FR_FPR23(\stack)
+	ldc1	$f25, GDB_FR_FPR25(\stack)
+	ldc1	$f27, GDB_FR_FPR27(\stack)
+	ldc1	$f29, GDB_FR_FPR29(\stack)
+	ldc1	$f31, GDB_FR_FPR31(\stack)
+	.endm
+
 	.macro	fpu_restore_double thread status tmp
 	sll	\tmp, \status, 5
 	bgez	\tmp, 1f				# 16 register mode?
@@ -109,6 +199,15 @@
 1:	fpu_restore_16even \thread \tmp
 	.endm
 
+	.macro	fpu_restore_double_kgdb stack status tmp
+	sll	\tmp, \status, 5
+	bgez	\tmp, 1f				# 16 register mode?
+	nop
+
+	fpu_restore_16odd_kgdb \stack
+1:	fpu_restore_16even_kgdb \stack \tmp
+	.endm
+
 	.macro	cpu_save_nonscratch thread
 	LONG_S	s0, THREAD_REG16(\thread)
 	LONG_S	s1, THREAD_REG17(\thread)
diff --git a/include/asm-mips/kgdb.h b/include/asm-mips/kgdb.h
new file mode 100644
index 0000000..0e0ed89
--- /dev/null
+++ b/include/asm-mips/kgdb.h
@@ -0,0 +1,54 @@
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
+static inline void arch_kgdb_breakpoint(void)
+{
+	__asm__ __volatile__(
+		".globl breakinst\n\t"
+		".set\tnoreorder\n\t"
+		"nop\n"
+		"breakinst:\tbreak\n\t"
+		"nop\n\t"
+		".set\treorder");
+}
+#define CACHE_FLUSH_IS_SAFE	0
+
+extern int kgdb_early_setup;
+extern void *saved_vectors[32];
+extern void handle_exception(struct pt_regs *regs);
+extern void trap_low(void);
+extern void breakinst(void);
+
+#endif				/* !__ASSEMBLY__ */
+#endif				/* _ASM_KGDB_H_ */
+#endif				/* __KERNEL__ */
-- 
1.5.5.1

