Return-Path: <linux-kernel-owner+w=401wt.eu-S1755009AbYGOM3G@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755009AbYGOM3G (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2008 08:29:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756733AbYGOM2G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jul 2008 08:28:06 -0400
Received: from mail.windriver.com ([147.11.1.11]:39653 "EHLO mail.wrs.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755009AbYGOM16 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2008 08:27:58 -0400
From: Jason Wessel <jason.wessel@windriver.com>
To: linux-kernel@vger.kernel.org
Cc: Jason Wessel <jason.wessel@windriver.com>
Subject: [PATCH 2/4] kgdb, powerpc: arch specific powerpc kgdb support
Date: Tue, 15 Jul 2008 07:27:54 -0500
Message-Id: <1216124876-19108-3-git-send-email-jason.wessel@windriver.com>
X-Mailer: git-send-email 1.5.5.1
In-Reply-To: <1216124876-19108-2-git-send-email-jason.wessel@windriver.com>
References: <1216124876-19108-1-git-send-email-jason.wessel@windriver.com>
 <1216124876-19108-2-git-send-email-jason.wessel@windriver.com>
CC: paulus@samba.org
CC: benh@kernel.crashing.org
X-OriginalArrivalTime: 15 Jul 2008 12:27:56.0821 (UTC) FILETIME=[36193450:01C8E676]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch removes the old kgdb reminants from ARCH=powerpc and
implements the new style arch specific stub for the common kgdb core
interface.

It is possible to have xmon and kgdb in the same kernel, but you
cannot use both at the same time because there is only one set of
debug hooks.

The arch specific kgdb implementation saves the previous state of the
debug hooks and restores them if you unconfigure the kgdb I/O driver.
Kgdb should have no impact on a kernel that has no kgdb I/O driver
configured.

Signed-off-by: Jason Wessel <jason.wessel@windriver.com>
---
 arch/powerpc/Kconfig                    |    1 +
 arch/powerpc/Kconfig.debug              |   34 +--
 arch/powerpc/kernel/Makefile            |    1 +
 arch/powerpc/kernel/kgdb.c              |  410 +++++++++++++++++++++++++++++++
 arch/powerpc/kernel/setup_32.c          |   16 --
 arch/powerpc/platforms/powermac/setup.c |    6 -
 include/asm-powerpc/kgdb.h              |   92 ++++----
 7 files changed, 468 insertions(+), 92 deletions(-)
 create mode 100644 arch/powerpc/kernel/kgdb.c

diff --git a/arch/powerpc/Kconfig b/arch/powerpc/Kconfig
index a5e9912..eef8109 100644
--- a/arch/powerpc/Kconfig
+++ b/arch/powerpc/Kconfig
@@ -109,6 +109,7 @@ config PPC
 	select HAVE_FTRACE
 	select HAVE_IDE
 	select HAVE_KPROBES
+	select HAVE_ARCH_KGDB
 	select HAVE_KRETPROBES
 	select HAVE_LMB
 	select HAVE_OPROFILE
diff --git a/arch/powerpc/Kconfig.debug b/arch/powerpc/Kconfig.debug
index a7d24e6..f27b6b0 100644
--- a/arch/powerpc/Kconfig.debug
+++ b/arch/powerpc/Kconfig.debug
@@ -57,36 +57,9 @@ config KGDB
 	  debugger.  See <http://kgdb.sourceforge.net/> for more information.
 	  Unless you are intending to debug the kernel, say N here.
 
-choice
-	prompt "Serial Port"
-	depends on KGDB
-	default KGDB_TTYS1
-
-config KGDB_TTYS0
-	bool "ttyS0"
-
-config KGDB_TTYS1
-	bool "ttyS1"
-
-config KGDB_TTYS2
-	bool "ttyS2"
-
-config KGDB_TTYS3
-	bool "ttyS3"
-
-endchoice
-
-config KGDB_CONSOLE
-	bool "Enable serial console thru kgdb port"
-	depends on KGDB && 8xx || CPM2
-	help
-	  If you enable this, all serial console messages will be sent
-	  over the gdb stub.
-	  If unsure, say N.
-
 config XMON
 	bool "Include xmon kernel debugger"
-	depends on DEBUGGER
+	depends on DEBUG_KERNEL
 	help
 	  Include in-kernel hooks for the xmon kernel monitor/debugger.
 	  Unless you are intending to debug the kernel, say N here.
@@ -116,6 +89,11 @@ config XMON_DISASSEMBLY
 	  to say Y here, unless you're building for a memory-constrained
 	  system.
 
+config DEBUGGER
+	bool
+	depends on KGDB || XMON
+	default y
+
 config IRQSTACKS
 	bool "Use separate kernel stacks when processing interrupts"
 	help
diff --git a/arch/powerpc/kernel/Makefile b/arch/powerpc/kernel/Makefile
index f3f5e26..f5a8183 100644
--- a/arch/powerpc/kernel/Makefile
+++ b/arch/powerpc/kernel/Makefile
@@ -73,6 +73,7 @@ obj-y				+= time.o prom.o traps.o setup-common.o \
 				   misc_$(CONFIG_WORD_SIZE).o
 obj-$(CONFIG_PPC32)		+= entry_32.o setup_32.o
 obj-$(CONFIG_PPC64)		+= dma_64.o iommu.o
+obj-$(CONFIG_KGDB)		+= kgdb.o
 obj-$(CONFIG_PPC_MULTIPLATFORM)	+= prom_init.o
 obj-$(CONFIG_MODULES)		+= ppc_ksyms.o
 obj-$(CONFIG_BOOTX_TEXT)	+= btext.o
diff --git a/arch/powerpc/kernel/kgdb.c b/arch/powerpc/kernel/kgdb.c
new file mode 100644
index 0000000..b4fdf2f
--- /dev/null
+++ b/arch/powerpc/kernel/kgdb.c
@@ -0,0 +1,410 @@
+/*
+ * PowerPC backend to the KGDB stub.
+ *
+ * 1998 (c) Michael AK Tesch (tesch@cs.wisc.edu)
+ * Copyright (C) 2003 Timesys Corporation.
+ * Copyright (C) 2004-2006 MontaVista Software, Inc.
+ * PPC64 Mods (C) 2005 Frank Rowand (frowand@mvista.com)
+ * PPC32 support restored by Vitaly Wool <vwool@ru.mvista.com> and
+ * Sergei Shtylyov <sshtylyov@ru.mvista.com>
+ * Copyright (C) 2007-2008 Wind River Systems, Inc.
+ *
+ * This file is licensed under the terms of the GNU General Public License
+ * version 2. This program as licensed "as is" without any warranty of any
+ * kind, whether express or implied.
+ */
+
+#include <linux/kernel.h>
+#include <linux/init.h>
+#include <linux/kgdb.h>
+#include <linux/smp.h>
+#include <linux/signal.h>
+#include <linux/ptrace.h>
+#include <asm/current.h>
+#include <asm/processor.h>
+#include <asm/machdep.h>
+
+/*
+ * This table contains the mapping between PowerPC hardware trap types, and
+ * signals, which are primarily what GDB understands.  GDB and the kernel
+ * don't always agree on values, so we use constants taken from gdb-6.2.
+ */
+static struct hard_trap_info
+{
+	unsigned int tt;		/* Trap type code for powerpc */
+	unsigned char signo;		/* Signal that we map this trap into */
+} hard_trap_info[] = {
+	{ 0x0100, 0x02 /* SIGINT */  },		/* system reset */
+	{ 0x0200, 0x0b /* SIGSEGV */ },		/* machine check */
+	{ 0x0300, 0x0b /* SIGSEGV */ },		/* data access */
+	{ 0x0400, 0x0b /* SIGSEGV */ },		/* instruction access */
+	{ 0x0500, 0x02 /* SIGINT */  },		/* external interrupt */
+	{ 0x0600, 0x0a /* SIGBUS */  },		/* alignment */
+	{ 0x0700, 0x05 /* SIGTRAP */ },		/* program check */
+	{ 0x0800, 0x08 /* SIGFPE */  },		/* fp unavailable */
+	{ 0x0900, 0x0e /* SIGALRM */ },		/* decrementer */
+	{ 0x0c00, 0x14 /* SIGCHLD */ },		/* system call */
+#if defined(CONFIG_40x) || defined(CONFIG_BOOKE)
+	{ 0x2002, 0x05 /* SIGTRAP */ },		/* debug */
+#if defined(CONFIG_FSL_BOOKE)
+	{ 0x2010, 0x08 /* SIGFPE */  },		/* spe unavailable */
+	{ 0x2020, 0x08 /* SIGFPE */  },		/* spe unavailable */
+	{ 0x2030, 0x08 /* SIGFPE */  },		/* spe fp data */
+	{ 0x2040, 0x08 /* SIGFPE */  },		/* spe fp data */
+	{ 0x2050, 0x08 /* SIGFPE */  },		/* spe fp round */
+	{ 0x2060, 0x0e /* SIGILL */  },		/* performace monitor */
+	{ 0x2900, 0x08 /* SIGFPE */  },		/* apu unavailable */
+	{ 0x3100, 0x0e /* SIGALRM */ },		/* fixed interval timer */
+	{ 0x3200, 0x02 /* SIGINT */  }, 	/* watchdog */
+#else /* ! CONFIG_FSL_BOOKE */
+	{ 0x1000, 0x0e /* SIGALRM */ },		/* prog interval timer */
+	{ 0x1010, 0x0e /* SIGALRM */ },		/* fixed interval timer */
+	{ 0x1020, 0x02 /* SIGINT */  }, 	/* watchdog */
+	{ 0x2010, 0x08 /* SIGFPE */  },		/* fp unavailable */
+	{ 0x2020, 0x08 /* SIGFPE */  },		/* ap unavailable */
+#endif
+#else /* ! (defined(CONFIG_40x) || defined(CONFIG_BOOKE)) */
+	{ 0x0d00, 0x05 /* SIGTRAP */ },		/* single-step */
+#if defined(CONFIG_8xx)
+	{ 0x1000, 0x04 /* SIGILL */  },		/* software emulation */
+#else /* ! CONFIG_8xx */
+	{ 0x0f00, 0x04 /* SIGILL */  },		/* performance monitor */
+	{ 0x0f20, 0x08 /* SIGFPE */  },		/* altivec unavailable */
+	{ 0x1300, 0x05 /* SIGTRAP */ }, 	/* instruction address break */
+#if defined(CONFIG_PPC64)
+	{ 0x1200, 0x05 /* SIGILL */  },		/* system error */
+	{ 0x1500, 0x04 /* SIGILL */  },		/* soft patch */
+	{ 0x1600, 0x04 /* SIGILL */  },		/* maintenance */
+	{ 0x1700, 0x08 /* SIGFPE */  },		/* altivec assist */
+	{ 0x1800, 0x04 /* SIGILL */  },		/* thermal */
+#else /* ! CONFIG_PPC64 */
+	{ 0x1400, 0x02 /* SIGINT */  },		/* SMI */
+	{ 0x1600, 0x08 /* SIGFPE */  },		/* altivec assist */
+	{ 0x1700, 0x04 /* SIGILL */  },		/* TAU */
+	{ 0x2000, 0x05 /* SIGTRAP */ },		/* run mode */
+#endif
+#endif
+#endif
+	{ 0x0000, 0x00 }			/* Must be last */
+};
+
+static int computeSignal(unsigned int tt)
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
+static int kgdb_call_nmi_hook(struct pt_regs *regs)
+{
+	kgdb_nmicallback(raw_smp_processor_id(), regs);
+	return 0;
+}
+
+#ifdef CONFIG_SMP
+void kgdb_roundup_cpus(unsigned long flags)
+{
+	smp_send_debugger_break(MSG_ALL_BUT_SELF);
+}
+#endif
+
+/* KGDB functions to use existing PowerPC64 hooks. */
+static int kgdb_debugger(struct pt_regs *regs)
+{
+	return kgdb_handle_exception(0, computeSignal(TRAP(regs)), 0, regs);
+}
+
+static int kgdb_handle_breakpoint(struct pt_regs *regs)
+{
+	if (user_mode(regs))
+		return 0;
+
+	if (kgdb_handle_exception(0, SIGTRAP, 0, regs) != 0)
+		return 0;
+
+	if (*(u32 *) (regs->nip) == *(u32 *) (&arch_kgdb_ops.gdb_bpt_instr))
+		regs->nip += 4;
+
+	return 1;
+}
+
+static int kgdb_singlestep(struct pt_regs *regs)
+{
+	struct thread_info *thread_info, *exception_thread_info;
+
+	if (user_mode(regs))
+		return 0;
+
+	/*
+	 * On Book E and perhaps other processsors, singlestep is handled on
+	 * the critical exception stack.  This causes current_thread_info()
+	 * to fail, since it it locates the thread_info by masking off
+	 * the low bits of the current stack pointer.  We work around
+	 * this issue by copying the thread_info from the kernel stack
+	 * before calling kgdb_handle_exception, and copying it back
+	 * afterwards.  On most processors the copy is avoided since
+	 * exception_thread_info == thread_info.
+	 */
+	thread_info = (struct thread_info *)(regs->gpr[1] & ~(THREAD_SIZE-1));
+	exception_thread_info = current_thread_info();
+
+	if (thread_info != exception_thread_info)
+		memcpy(exception_thread_info, thread_info, sizeof *thread_info);
+
+	kgdb_handle_exception(0, SIGTRAP, 0, regs);
+
+	if (thread_info != exception_thread_info)
+		memcpy(thread_info, exception_thread_info, sizeof *thread_info);
+
+	return 1;
+}
+
+static int kgdb_iabr_match(struct pt_regs *regs)
+{
+	if (user_mode(regs))
+		return 0;
+
+	if (kgdb_handle_exception(0, computeSignal(TRAP(regs)), 0, regs) != 0)
+		return 0;
+	return 1;
+}
+
+static int kgdb_dabr_match(struct pt_regs *regs)
+{
+	if (user_mode(regs))
+		return 0;
+
+	if (kgdb_handle_exception(0, computeSignal(TRAP(regs)), 0, regs) != 0)
+		return 0;
+	return 1;
+}
+
+#define PACK64(ptr, src) do { *(ptr++) = (src); } while (0)
+
+#define PACK32(ptr, src) do {          \
+	u32 *ptr32;                   \
+	ptr32 = (u32 *)ptr;           \
+	*(ptr32++) = (src);           \
+	ptr = (unsigned long *)ptr32; \
+	} while (0)
+
+
+void pt_regs_to_gdb_regs(unsigned long *gdb_regs, struct pt_regs *regs)
+{
+	unsigned long *ptr = gdb_regs;
+	int reg;
+
+	memset(gdb_regs, 0, NUMREGBYTES);
+
+	for (reg = 0; reg < 32; reg++)
+		PACK64(ptr, regs->gpr[reg]);
+
+#ifdef CONFIG_FSL_BOOKE
+#ifdef CONFIG_SPE
+	for (reg = 0; reg < 32; reg++)
+		PACK64(ptr, current->thread.evr[reg]);
+#else
+	ptr += 32;
+#endif
+#else
+	/* fp registers not used by kernel, leave zero */
+	ptr += 32 * 8 / sizeof(long);
+#endif
+
+	PACK64(ptr, regs->nip);
+	PACK64(ptr, regs->msr);
+	PACK32(ptr, regs->ccr);
+	PACK64(ptr, regs->link);
+	PACK64(ptr, regs->ctr);
+	PACK32(ptr, regs->xer);
+
+	BUG_ON((unsigned long)ptr >
+	       (unsigned long)(((void *)gdb_regs) + NUMREGBYTES));
+}
+
+void sleeping_thread_to_gdb_regs(unsigned long *gdb_regs, struct task_struct *p)
+{
+	struct pt_regs *regs = (struct pt_regs *)(p->thread.ksp +
+						  STACK_FRAME_OVERHEAD);
+	unsigned long *ptr = gdb_regs;
+	int reg;
+
+	memset(gdb_regs, 0, NUMREGBYTES);
+
+	/* Regs GPR0-2 */
+	for (reg = 0; reg < 3; reg++)
+		PACK64(ptr, regs->gpr[reg]);
+
+	/* Regs GPR3-13 are caller saved, not in regs->gpr[] */
+	ptr += 11;
+
+	/* Regs GPR14-31 */
+	for (reg = 14; reg < 32; reg++)
+		PACK64(ptr, regs->gpr[reg]);
+
+#ifdef CONFIG_FSL_BOOKE
+#ifdef CONFIG_SPE
+	for (reg = 0; reg < 32; reg++)
+		PACK64(ptr, p->thread.evr[reg]);
+#else
+	ptr += 32;
+#endif
+#else
+	/* fp registers not used by kernel, leave zero */
+	ptr += 32 * 8 / sizeof(long);
+#endif
+
+	PACK64(ptr, regs->nip);
+	PACK64(ptr, regs->msr);
+	PACK32(ptr, regs->ccr);
+	PACK64(ptr, regs->link);
+	PACK64(ptr, regs->ctr);
+	PACK32(ptr, regs->xer);
+
+	BUG_ON((unsigned long)ptr >
+	       (unsigned long)(((void *)gdb_regs) + NUMREGBYTES));
+}
+
+#define UNPACK64(dest, ptr) do { dest = *(ptr++); } while (0)
+
+#define UNPACK32(dest, ptr) do {       \
+	u32 *ptr32;                   \
+	ptr32 = (u32 *)ptr;           \
+	dest = *(ptr32++);            \
+	ptr = (unsigned long *)ptr32; \
+	} while (0)
+
+void gdb_regs_to_pt_regs(unsigned long *gdb_regs, struct pt_regs *regs)
+{
+	unsigned long *ptr = gdb_regs;
+	int reg;
+#ifdef CONFIG_SPE
+	union {
+		u32 v32[2];
+		u64 v64;
+	} acc;
+#endif
+
+	for (reg = 0; reg < 32; reg++)
+		UNPACK64(regs->gpr[reg], ptr);
+
+#ifdef CONFIG_FSL_BOOKE
+#ifdef CONFIG_SPE
+	for (reg = 0; reg < 32; reg++)
+		UNPACK64(current->thread.evr[reg], ptr);
+#else
+	ptr += 32;
+#endif
+#else
+	/* fp registers not used by kernel, leave zero */
+	ptr += 32 * 8 / sizeof(int);
+#endif
+
+	UNPACK64(regs->nip, ptr);
+	UNPACK64(regs->msr, ptr);
+	UNPACK32(regs->ccr, ptr);
+	UNPACK64(regs->link, ptr);
+	UNPACK64(regs->ctr, ptr);
+	UNPACK32(regs->xer, ptr);
+
+	BUG_ON((unsigned long)ptr >
+	       (unsigned long)(((void *)gdb_regs) + NUMREGBYTES));
+}
+
+/*
+ * This function does PowerPC specific procesing for interfacing to gdb.
+ */
+int kgdb_arch_handle_exception(int vector, int signo, int err_code,
+			       char *remcom_in_buffer, char *remcom_out_buffer,
+			       struct pt_regs *linux_regs)
+{
+	char *ptr = &remcom_in_buffer[1];
+	unsigned long addr;
+
+	switch (remcom_in_buffer[0]) {
+		/*
+		 * sAA..AA   Step one instruction from AA..AA
+		 * This will return an error to gdb ..
+		 */
+	case 's':
+	case 'c':
+		/* handle the optional parameter */
+		if (kgdb_hex2long(&ptr, &addr))
+			linux_regs->nip = addr;
+
+		atomic_set(&kgdb_cpu_doing_single_step, -1);
+		/* set the trace bit if we're stepping */
+		if (remcom_in_buffer[0] == 's') {
+#if defined(CONFIG_40x) || defined(CONFIG_BOOKE)
+			mtspr(SPRN_DBCR0,
+			      mfspr(SPRN_DBCR0) | DBCR0_IC | DBCR0_IDM);
+			linux_regs->msr |= MSR_DE;
+#else
+			linux_regs->msr |= MSR_SE;
+#endif
+			kgdb_single_step = 1;
+			if (kgdb_contthread)
+				atomic_set(&kgdb_cpu_doing_single_step,
+					   raw_smp_processor_id());
+		}
+		return 0;
+	}
+
+	return -1;
+}
+
+/*
+ * Global data
+ */
+struct kgdb_arch arch_kgdb_ops = {
+	.gdb_bpt_instr = {0x7d, 0x82, 0x10, 0x08},
+};
+
+static int kgdb_not_implemented(struct pt_regs *regs)
+{
+	return 0;
+}
+
+static void *old__debugger_ipi;
+static void *old__debugger;
+static void *old__debugger_bpt;
+static void *old__debugger_sstep;
+static void *old__debugger_iabr_match;
+static void *old__debugger_dabr_match;
+static void *old__debugger_fault_handler;
+
+int kgdb_arch_init(void)
+{
+	old__debugger_ipi = __debugger_ipi;
+	old__debugger = __debugger;
+	old__debugger_bpt = __debugger_bpt;
+	old__debugger_sstep = __debugger_sstep;
+	old__debugger_iabr_match = __debugger_iabr_match;
+	old__debugger_dabr_match = __debugger_dabr_match;
+	old__debugger_fault_handler = __debugger_fault_handler;
+
+	__debugger_ipi = kgdb_call_nmi_hook;
+	__debugger = kgdb_debugger;
+	__debugger_bpt = kgdb_handle_breakpoint;
+	__debugger_sstep = kgdb_singlestep;
+	__debugger_iabr_match = kgdb_iabr_match;
+	__debugger_dabr_match = kgdb_dabr_match;
+	__debugger_fault_handler = kgdb_not_implemented;
+
+	return 0;
+}
+
+void kgdb_arch_exit(void)
+{
+	__debugger_ipi = old__debugger_ipi;
+	__debugger = old__debugger;
+	__debugger_bpt = old__debugger_bpt;
+	__debugger_sstep = old__debugger_sstep;
+	__debugger_iabr_match = old__debugger_iabr_match;
+	__debugger_dabr_match = old__debugger_dabr_match;
+	__debugger_fault_handler = old__debugger_fault_handler;
+}
diff --git a/arch/powerpc/kernel/setup_32.c b/arch/powerpc/kernel/setup_32.c
index 19e8fcb..50580b1 100644
--- a/arch/powerpc/kernel/setup_32.c
+++ b/arch/powerpc/kernel/setup_32.c
@@ -43,10 +43,6 @@
 
 #define DBG(fmt...)
 
-#if defined CONFIG_KGDB
-#include <asm/kgdb.h>
-#endif
-
 extern void bootx_init(unsigned long r4, unsigned long phys);
 
 int boot_cpuid;
@@ -271,18 +267,6 @@ void __init setup_arch(char **cmdline_p)
 
 	xmon_setup();
 
-#if defined(CONFIG_KGDB)
-	if (ppc_md.kgdb_map_scc)
-		ppc_md.kgdb_map_scc();
-	set_debug_traps();
-	if (strstr(cmd_line, "gdb")) {
-		if (ppc_md.progress)
-			ppc_md.progress("setup_arch: kgdb breakpoint", 0x4000);
-		printk("kgdb breakpoint activated\n");
-		breakpoint();
-	}
-#endif
-
 	/*
 	 * Set cache line size based on type of cpu as a default.
 	 * Systems with OF can look in the properties on the cpu node(s)
diff --git a/arch/powerpc/platforms/powermac/setup.c b/arch/powerpc/platforms/powermac/setup.c
index 00bd016..3163544 100644
--- a/arch/powerpc/platforms/powermac/setup.c
+++ b/arch/powerpc/platforms/powermac/setup.c
@@ -97,8 +97,6 @@ extern struct machdep_calls pmac_md;
 int sccdbg;
 #endif
 
-extern void zs_kgdb_hook(int tty_num);
-
 sys_ctrler_t sys_ctrler = SYS_CTRLER_UNKNOWN;
 EXPORT_SYMBOL(sys_ctrler);
 
@@ -329,10 +327,6 @@ static void __init pmac_setup_arch(void)
 	l2cr_init();
 #endif /* CONFIG_PPC32 */
 
-#ifdef CONFIG_KGDB
-	zs_kgdb_hook(0);
-#endif
-
 	find_via_cuda();
 	find_via_pmu();
 	smu_init();
diff --git a/include/asm-powerpc/kgdb.h b/include/asm-powerpc/kgdb.h
index b617dac..1399caf 100644
--- a/include/asm-powerpc/kgdb.h
+++ b/include/asm-powerpc/kgdb.h
@@ -1,57 +1,65 @@
 /*
- * kgdb.h: Defines and declarations for serial line source level
- *         remote debugging of the Linux kernel using gdb.
+ * include/asm-powerpc/kgdb.h
  *
+ * The PowerPC (32/64) specific defines / externs for KGDB.  Based on
+ * the previous 32bit and 64bit specific files, which had the following
+ * copyrights:
+ *
+ * PPC64 Mods (C) 2005 Frank Rowand (frowand@mvista.com)
+ * PPC Mods (C) 2004 Tom Rini (trini@mvista.com)
+ * PPC Mods (C) 2003 John Whitney (john.whitney@timesys.com)
  * PPC Mods (C) 1998 Michael Tesch (tesch@cs.wisc.edu)
  *
+ *
  * Copyright (C) 1995 David S. Miller (davem@caip.rutgers.edu)
+ * Author: Tom Rini <trini@kernel.crashing.org>
+ *
+ * 2006 (c) MontaVista Software, Inc. This file is licensed under
+ * the terms of the GNU General Public License version 2. This program
+ * is licensed "as is" without any warranty of any kind, whether express
+ * or implied.
  */
 #ifdef __KERNEL__
-#ifndef _PPC_KGDB_H
-#define _PPC_KGDB_H
+#ifndef __POWERPC_KGDB_H__
+#define __POWERPC_KGDB_H__
 
 #ifndef __ASSEMBLY__
 
-/* Things specific to the gen550 backend. */
-struct uart_port;
-
-extern void gen550_progress(char *, unsigned short);
-extern void gen550_kgdb_map_scc(void);
-extern void gen550_init(int, struct uart_port *);
-
-/* Things specific to the pmac backend. */
-extern void zs_kgdb_hook(int tty_num);
-
-/* To init the kgdb engine. (called by serial hook)*/
-extern void set_debug_traps(void);
-
-/* To enter the debugger explicitly. */
-extern void breakpoint(void);
-
-/* For taking exceptions
- * these are defined in traps.c
- */
-extern int (*debugger)(struct pt_regs *regs);
-extern int (*debugger_bpt)(struct pt_regs *regs);
-extern int (*debugger_sstep)(struct pt_regs *regs);
-extern int (*debugger_iabr_match)(struct pt_regs *regs);
-extern int (*debugger_dabr_match)(struct pt_regs *regs);
-extern void (*debugger_fault_handler)(struct pt_regs *regs);
-
-/* What we bring to the party */
-int kgdb_bpt(struct pt_regs *regs);
-int kgdb_sstep(struct pt_regs *regs);
-void kgdb(struct pt_regs *regs);
-int kgdb_iabr_match(struct pt_regs *regs);
-int kgdb_dabr_match(struct pt_regs *regs);
+#define BREAK_INSTR_SIZE	4
+#define BUFMAX			((NUMREGBYTES * 2) + 512)
+#define OUTBUFMAX		((NUMREGBYTES * 2) + 512)
+static inline void arch_kgdb_breakpoint(void)
+{
+	asm(".long 0x7d821008"); /* twge r2, r2 */
+}
+#define CACHE_FLUSH_IS_SAFE	1
 
+/* The number bytes of registers we have to save depends on a few
+ * things.  For 64bit we default to not including vector registers and
+ * vector state registers. */
+#ifdef CONFIG_PPC64
 /*
- * external low-level support routines (ie macserial.c)
+ * 64 bit (8 byte) registers:
+ *   32 gpr, 32 fpr, nip, msr, link, ctr
+ * 32 bit (4 byte) registers:
+ *   ccr, xer, fpscr
  */
-extern void kgdb_interruptible(int); /* control interrupts from serial */
-extern void putDebugChar(char);   /* write a single character      */
-extern char getDebugChar(void);   /* read and return a single char */
-
+#define NUMREGBYTES		((68 * 8) + (3 * 4))
+#define NUMCRITREGBYTES		184
+#else /* CONFIG_PPC32 */
+/* On non-E500 family PPC32 we determine the size by picking the last
+ * register we need, but on E500 we skip sections so we list what we
+ * need to store, and add it up. */
+#ifndef CONFIG_E500
+#define MAXREG			(PT_FPSCR+1)
+#else
+/* 32 GPRs (8 bytes), nip, msr, ccr, link, ctr, xer, acc (8 bytes), spefscr*/
+#define MAXREG                 ((32*2)+6+2+1)
+#endif
+#define NUMREGBYTES		(MAXREG * sizeof(int))
+/* CR/LR, R1, R2, R13-R31 inclusive. */
+#define NUMCRITREGBYTES		(23 * sizeof(int))
+#endif /* 32/64 */
 #endif /* !(__ASSEMBLY__) */
-#endif /* !(_PPC_KGDB_H) */
+#endif /* !__POWERPC_KGDB_H__ */
 #endif /* __KERNEL__ */
-- 
1.5.5.1

