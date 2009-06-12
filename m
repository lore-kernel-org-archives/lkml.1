Return-Path: <linux-kernel-owner+w=401wt.eu-S1765430AbZFLQ1r@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765430AbZFLQ1r (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jun 2009 12:27:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764619AbZFLQZD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Jun 2009 12:25:03 -0400
Received: from smtp.gentoo.org ([140.211.166.183]:39059 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762985AbZFLQY7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jun 2009 12:24:59 -0400
From: Mike Frysinger <vapier@gentoo.org>
To: linux-kernel@vger.kernel.org
Cc: uclinux-dist-devel@blackfin.uclinux.org
Subject: [PATCH 08/27] Blackfin: push down exception oops checking
Date: Fri, 12 Jun 2009 12:24:26 -0400
Message-Id: <1244823885-22410-9-git-send-email-vapier@gentoo.org>
X-Mailer: git-send-email 1.6.3.1
In-Reply-To: <1244823885-22410-1-git-send-email-vapier@gentoo.org>
References: <1244823885-22410-1-git-send-email-vapier@gentoo.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rather than maintain a duplicate list of valid exceptions we can take in
the kernel both in the first if() check and the switch() check, delay the
oops check to after the switch().  All valid exceptions will have returned
by this point leaving only the invalid ones.

Signed-off-by: Mike Frysinger <vapier@gentoo.org>
---
 arch/blackfin/kernel/traps.c |   88 ++++++++++++++++++++---------------------
 1 files changed, 43 insertions(+), 45 deletions(-)

diff --git a/arch/blackfin/kernel/traps.c b/arch/blackfin/kernel/traps.c
index ed7127b..d279552 100644
--- a/arch/blackfin/kernel/traps.c
+++ b/arch/blackfin/kernel/traps.c
@@ -239,6 +239,11 @@ asmlinkage void double_fault_c(struct pt_regs *fp)
 
 }
 
+static int kernel_mode_regs(struct pt_regs *regs)
+{
+	return regs->ipend & 0xffc0;
+}
+
 asmlinkage void trap_c(struct pt_regs *fp)
 {
 #ifdef CONFIG_DEBUG_BFIN_HWTRACE_ON
@@ -247,6 +252,7 @@ asmlinkage void trap_c(struct pt_regs *fp)
 #ifdef CONFIG_DEBUG_HUNT_FOR_ZERO
 	unsigned int cpu = smp_processor_id();
 #endif
+	const char *strerror = NULL;
 	int sig = 0;
 	siginfo_t info;
 	unsigned long trapnr = fp->seqstat & SEQSTAT_EXCAUSE;
@@ -260,27 +266,10 @@ asmlinkage void trap_c(struct pt_regs *fp)
 	 * double faults if the stack has become corrupt
 	 */
 
-	/* If the fault was caused by a kernel thread, or interrupt handler
-	 * we will kernel panic, so the system reboots.
-	 * If KGDB is enabled, don't set this for kernel breakpoints
-	*/
-
-	/* TODO: check to see if we are in some sort of deferred HWERR
-	 * that we should be able to recover from, not kernel panic
-	 */
-	if ((bfin_read_IPEND() & 0xFFC0) && (trapnr != VEC_STEP)
-#ifdef CONFIG_KGDB
-		&& (trapnr != VEC_EXCPT02)
+#ifndef CONFIG_KGDB
+	/* IPEND is skipped if KGDB isn't enabled (see entry code) */
+	fp->ipend = bfin_read_IPEND();
 #endif
-	){
-		console_verbose();
-		oops_in_progress = 1;
-	} else if (current) {
-		if (current->mm == NULL) {
-			console_verbose();
-			oops_in_progress = 1;
-		}
-	}
 
 	/* trap_c() will be called for exceptions. During exceptions
 	 * processing, the pc value should be set with retx value.
@@ -308,7 +297,7 @@ asmlinkage void trap_c(struct pt_regs *fp)
 		sig = SIGTRAP;
 		CHK_DEBUGGER_TRAP_MAYBE();
 		/* Check if this is a breakpoint in kernel space */
-		if (fp->ipend & 0xffc0)
+		if (kernel_mode_regs(fp))
 			goto traps_done;
 		else
 			break;
@@ -316,7 +305,7 @@ asmlinkage void trap_c(struct pt_regs *fp)
 	case VEC_EXCPT03:
 		info.si_code = SEGV_STACKFLOW;
 		sig = SIGSEGV;
-		verbose_printk(KERN_NOTICE EXC_0x03(KERN_NOTICE));
+		strerror = KERN_NOTICE EXC_0x03(KERN_NOTICE);
 		CHK_DEBUGGER_TRAP_MAYBE();
 		break;
 	/* 0x02 - KGDB initial connection and break signal trap */
@@ -345,7 +334,7 @@ asmlinkage void trap_c(struct pt_regs *fp)
 	case VEC_EXCPT04 ... VEC_EXCPT15:
 		info.si_code = ILL_ILLPARAOP;
 		sig = SIGILL;
-		verbose_printk(KERN_NOTICE EXC_0x04(KERN_NOTICE));
+		strerror = KERN_NOTICE EXC_0x04(KERN_NOTICE);
 		CHK_DEBUGGER_TRAP_MAYBE();
 		break;
 	/* 0x10 HW Single step, handled here */
@@ -354,7 +343,7 @@ asmlinkage void trap_c(struct pt_regs *fp)
 		sig = SIGTRAP;
 		CHK_DEBUGGER_TRAP_MAYBE();
 		/* Check if this is a single step in kernel space */
-		if (fp->ipend & 0xffc0)
+		if (kernel_mode_regs(fp))
 			goto traps_done;
 		else
 			break;
@@ -362,7 +351,7 @@ asmlinkage void trap_c(struct pt_regs *fp)
 	case VEC_OVFLOW:
 		info.si_code = TRAP_TRACEFLOW;
 		sig = SIGTRAP;
-		verbose_printk(KERN_NOTICE EXC_0x11(KERN_NOTICE));
+		strerror = KERN_NOTICE EXC_0x11(KERN_NOTICE);
 		CHK_DEBUGGER_TRAP_MAYBE();
 		break;
 	/* 0x12 - Reserved, Caught by default */
@@ -401,35 +390,35 @@ asmlinkage void trap_c(struct pt_regs *fp)
 #endif
 		info.si_code = ILL_ILLOPC;
 		sig = SIGILL;
-		verbose_printk(KERN_NOTICE EXC_0x21(KERN_NOTICE));
+		strerror = KERN_NOTICE EXC_0x21(KERN_NOTICE);
 		CHK_DEBUGGER_TRAP_MAYBE();
 		break;
 	/* 0x22 - Illegal Instruction Combination, handled here */
 	case VEC_ILGAL_I:
 		info.si_code = ILL_ILLPARAOP;
 		sig = SIGILL;
-		verbose_printk(KERN_NOTICE EXC_0x22(KERN_NOTICE));
+		strerror = KERN_NOTICE EXC_0x22(KERN_NOTICE);
 		CHK_DEBUGGER_TRAP_MAYBE();
 		break;
 	/* 0x23 - Data CPLB protection violation, handled here */
 	case VEC_CPLB_VL:
 		info.si_code = ILL_CPLB_VI;
 		sig = SIGBUS;
-		verbose_printk(KERN_NOTICE EXC_0x23(KERN_NOTICE));
+		strerror = KERN_NOTICE EXC_0x23(KERN_NOTICE);
 		CHK_DEBUGGER_TRAP_MAYBE();
 		break;
 	/* 0x24 - Data access misaligned, handled here */
 	case VEC_MISALI_D:
 		info.si_code = BUS_ADRALN;
 		sig = SIGBUS;
-		verbose_printk(KERN_NOTICE EXC_0x24(KERN_NOTICE));
+		strerror = KERN_NOTICE EXC_0x24(KERN_NOTICE);
 		CHK_DEBUGGER_TRAP_MAYBE();
 		break;
 	/* 0x25 - Unrecoverable Event, handled here */
 	case VEC_UNCOV:
 		info.si_code = ILL_ILLEXCPT;
 		sig = SIGILL;
-		verbose_printk(KERN_NOTICE EXC_0x25(KERN_NOTICE));
+		strerror = KERN_NOTICE EXC_0x25(KERN_NOTICE);
 		CHK_DEBUGGER_TRAP_MAYBE();
 		break;
 	/* 0x26 - Data CPLB Miss, normal case is handled in _cplb_hdr,
@@ -437,7 +426,7 @@ asmlinkage void trap_c(struct pt_regs *fp)
 	case VEC_CPLB_M:
 		info.si_code = BUS_ADRALN;
 		sig = SIGBUS;
-		verbose_printk(KERN_NOTICE EXC_0x26(KERN_NOTICE));
+		strerror = KERN_NOTICE EXC_0x26(KERN_NOTICE);
 		break;
 	/* 0x27 - Data CPLB Multiple Hits - Linux Trap Zero, handled here */
 	case VEC_CPLB_MHIT:
@@ -445,10 +434,10 @@ asmlinkage void trap_c(struct pt_regs *fp)
 		sig = SIGSEGV;
 #ifdef CONFIG_DEBUG_HUNT_FOR_ZERO
 		if (cpu_pda[cpu].dcplb_fault_addr < FIXED_CODE_START)
-			verbose_printk(KERN_NOTICE "NULL pointer access\n");
+			strerror = KERN_NOTICE "NULL pointer access\n";
 		else
 #endif
-			verbose_printk(KERN_NOTICE EXC_0x27(KERN_NOTICE));
+			strerror = KERN_NOTICE EXC_0x27(KERN_NOTICE);
 		CHK_DEBUGGER_TRAP_MAYBE();
 		break;
 	/* 0x28 - Emulation Watchpoint, handled here */
@@ -458,7 +447,7 @@ asmlinkage void trap_c(struct pt_regs *fp)
 		pr_debug(EXC_0x28(KERN_DEBUG));
 		CHK_DEBUGGER_TRAP_MAYBE();
 		/* Check if this is a watchpoint in kernel space */
-		if (fp->ipend & 0xffc0)
+		if (kernel_mode_regs(fp))
 			goto traps_done;
 		else
 			break;
@@ -467,7 +456,7 @@ asmlinkage void trap_c(struct pt_regs *fp)
 	case VEC_ISTRU_VL:      /* ADSP-BF535 only (MH) */
 		info.si_code = BUS_OPFETCH;
 		sig = SIGBUS;
-		verbose_printk(KERN_NOTICE "BF535: VEC_ISTRU_VL\n");
+		strerror = KERN_NOTICE "BF535: VEC_ISTRU_VL\n";
 		CHK_DEBUGGER_TRAP_MAYBE();
 		break;
 #else
@@ -477,21 +466,21 @@ asmlinkage void trap_c(struct pt_regs *fp)
 	case VEC_MISALI_I:
 		info.si_code = BUS_ADRALN;
 		sig = SIGBUS;
-		verbose_printk(KERN_NOTICE EXC_0x2A(KERN_NOTICE));
+		strerror = KERN_NOTICE EXC_0x2A(KERN_NOTICE);
 		CHK_DEBUGGER_TRAP_MAYBE();
 		break;
 	/* 0x2B - Instruction CPLB protection violation, handled here */
 	case VEC_CPLB_I_VL:
 		info.si_code = ILL_CPLB_VI;
 		sig = SIGBUS;
-		verbose_printk(KERN_NOTICE EXC_0x2B(KERN_NOTICE));
+		strerror = KERN_NOTICE EXC_0x2B(KERN_NOTICE);
 		CHK_DEBUGGER_TRAP_MAYBE();
 		break;
 	/* 0x2C - Instruction CPLB miss, handled in _cplb_hdr */
 	case VEC_CPLB_I_M:
 		info.si_code = ILL_CPLB_MISS;
 		sig = SIGBUS;
-		verbose_printk(KERN_NOTICE EXC_0x2C(KERN_NOTICE));
+		strerror = KERN_NOTICE EXC_0x2C(KERN_NOTICE);
 		break;
 	/* 0x2D - Instruction CPLB Multiple Hits, handled here */
 	case VEC_CPLB_I_MHIT:
@@ -499,17 +488,17 @@ asmlinkage void trap_c(struct pt_regs *fp)
 		sig = SIGSEGV;
 #ifdef CONFIG_DEBUG_HUNT_FOR_ZERO
 		if (cpu_pda[cpu].icplb_fault_addr < FIXED_CODE_START)
-			verbose_printk(KERN_NOTICE "Jump to NULL address\n");
+			strerror = KERN_NOTICE "Jump to NULL address\n";
 		else
 #endif
-			verbose_printk(KERN_NOTICE EXC_0x2D(KERN_NOTICE));
+			strerror = KERN_NOTICE EXC_0x2D(KERN_NOTICE);
 		CHK_DEBUGGER_TRAP_MAYBE();
 		break;
 	/* 0x2E - Illegal use of Supervisor Resource, handled here */
 	case VEC_ILL_RES:
 		info.si_code = ILL_PRVOPC;
 		sig = SIGILL;
-		verbose_printk(KERN_NOTICE EXC_0x2E(KERN_NOTICE));
+		strerror = KERN_NOTICE EXC_0x2E(KERN_NOTICE);
 		CHK_DEBUGGER_TRAP_MAYBE();
 		break;
 	/* 0x2F - Reserved, Caught by default */
@@ -537,17 +526,17 @@ asmlinkage void trap_c(struct pt_regs *fp)
 		case (SEQSTAT_HWERRCAUSE_SYSTEM_MMR):
 			info.si_code = BUS_ADRALN;
 			sig = SIGBUS;
-			verbose_printk(KERN_NOTICE HWC_x2(KERN_NOTICE));
+			strerror = KERN_NOTICE HWC_x2(KERN_NOTICE);
 			break;
 		/* External Memory Addressing Error */
 		case (SEQSTAT_HWERRCAUSE_EXTERN_ADDR):
 			info.si_code = BUS_ADRERR;
 			sig = SIGBUS;
-			verbose_printk(KERN_NOTICE HWC_x3(KERN_NOTICE));
+			strerror = KERN_NOTICE HWC_x3(KERN_NOTICE);
 			break;
 		/* Performance Monitor Overflow */
 		case (SEQSTAT_HWERRCAUSE_PERF_FLOW):
-			verbose_printk(KERN_NOTICE HWC_x12(KERN_NOTICE));
+			strerror = KERN_NOTICE HWC_x12(KERN_NOTICE);
 			break;
 		/* RAISE 5 instruction */
 		case (SEQSTAT_HWERRCAUSE_RAISE_5):
@@ -564,7 +553,6 @@ asmlinkage void trap_c(struct pt_regs *fp)
 	 * if we get here we hit a reserved one, so panic
 	 */
 	default:
-		oops_in_progress = 1;
 		info.si_code = ILL_ILLPARAOP;
 		sig = SIGILL;
 		verbose_printk(KERN_EMERG "Caught Unhandled Exception, code = %08lx\n",
@@ -575,6 +563,16 @@ asmlinkage void trap_c(struct pt_regs *fp)
 
 	BUG_ON(sig == 0);
 
+	/* If the fault was caused by a kernel thread, or interrupt handler
+	 * we will kernel panic, so the system reboots.
+	 */
+	if (kernel_mode_regs(fp) || (current && !current->mm)) {
+		console_verbose();
+		oops_in_progress = 1;
+		if (strerror)
+			verbose_printk(strerror);
+	}
+
 	if (sig != SIGTRAP) {
 		dump_bfin_process(fp);
 		dump_bfin_mem(fp);
-- 
1.6.3.1

