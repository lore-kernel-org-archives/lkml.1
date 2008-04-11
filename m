Return-Path: <linux-kernel-owner+w=401wt.eu-S1761680AbYDKRO3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761680AbYDKRO3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Apr 2008 13:14:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761052AbYDKROG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Apr 2008 13:14:06 -0400
Received: from keg.few.vu.nl ([130.37.24.4]:46263 "EHLO keg.few.vu.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760404AbYDKROE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Apr 2008 13:14:04 -0400
Date: Fri, 11 Apr 2008 18:55:58 +0200 (CEST)
From: Erik Bosman <ebn310@few.vu.nl>
To: Andrew Morton <akpm@linux-foundation.org>
cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrea Arcangeli <andrea@cpushare.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Subject: [PATCH 2/3] x86: Implement prctl PR_GET_TSC and PR_SET_TSC
Message-ID: <Pine.GSO.4.56.0804111855070.16669@keg.few.vu.nl>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


    x86: Implement prctl PR_GET_TSC and PR_SET_TSC

    This patch adds a configure option CONFIG_DISABLE_TSC
    (off by default) for the x86 platform to enable the
    PR_GET_TSC and PR_SET_TSC commands. These control the
    ability to use the timestamp counter from userspace
    (the RDTSC instruction.)

    This patch uses code earlier used to disable the
    timestamp counter for the SECCOMP framework. It used
    to disable the RDTSC on 32 bit kernels, but allow it
    on x86_64. This patch makes SECCOMP disable the
    timestamp counter whenever CONFIG_DISABLE_TSC is
    enabled.

	Signed-off-by: Erik Bosman <ejbosman@cs.vu.nl>
---
 arch/x86/Kconfig                 |   15 ++++++++
 arch/x86/kernel/process_32.c     |   46 ++++++++++++++++++++++--
 arch/x86/kernel/process_64.c     |   72 ++++++++++++++++++++++++++++++++++++++
 include/asm-x86/processor.h      |   11 ++++++
 include/asm-x86/thread_info_64.h |    4 ++-
 include/asm-x86/tsc.h            |    3 ++
 kernel/seccomp.c                 |    2 +-
 7 files changed, 148 insertions(+), 5 deletions(-)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 56bef39..8b79203 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -1122,6 +1122,21 @@ config IRQBALANCE
 	  The default yes will allow the kernel to do irq load balancing.
 	  Saying no will keep the kernel from doing irq load balancing.

+config DISABLE_TSC
+	def_bool n
+	prompt "Make availability of the RDTSC instruction configurable"
+	depends on (X86_32 || X86_64) && EXPERIMENTAL
+	help
+	  While the RDTSC instruction allows for very precise time
+	  measurements, it is also a source for non-determinism
+	  during the execution of a process which can be a problem in some
+	  security contexts. This option adds prctl commands to configure
+	  and test the availability of the RDTSC instruction on a
+	  per-process basis. Choosing this option may cause a small
+	  performance hit during context switching.
+
+	  If unsure, say N.
+
 config SECCOMP
 	def_bool y
 	prompt "Enable seccomp to safely compute untrusted bytecode"
diff --git a/arch/x86/kernel/process_32.c b/arch/x86/kernel/process_32.c
index 6496344..e6a861f 100644
--- a/arch/x86/kernel/process_32.c
+++ b/arch/x86/kernel/process_32.c
@@ -36,6 +36,7 @@
 #include <linux/personality.h>
 #include <linux/tick.h>
 #include <linux/percpu.h>
+#include <linux/prctl.h>

 #include <asm/uaccess.h>
 #include <asm/pgtable.h>
@@ -528,11 +529,12 @@ start_thread(struct pt_regs *regs, unsigned long new_ip, unsigned long new_sp)
 }
 EXPORT_SYMBOL_GPL(start_thread);

-#ifdef CONFIG_SECCOMP
+#ifdef CONFIG_DISABLE_TSC
 static void hard_disable_TSC(void)
 {
 	write_cr4(read_cr4() | X86_CR4_TSD);
 }
+
 void disable_TSC(void)
 {
 	preempt_disable();
@@ -544,11 +546,48 @@ void disable_TSC(void)
 		hard_disable_TSC();
 	preempt_enable();
 }
+
 static void hard_enable_TSC(void)
 {
 	write_cr4(read_cr4() & ~X86_CR4_TSD);
 }
-#endif /* CONFIG_SECCOMP */
+
+void enable_TSC(void)
+{
+	preempt_disable();
+	if (test_and_clear_thread_flag(TIF_NOTSC))
+		/*
+		 * Must flip the CPU state synchronously with
+		 * TIF_NOTSC in the current running context.
+		 */
+		hard_enable_TSC();
+	preempt_enable();
+}
+
+int get_tsc_mode(unsigned long adr)
+{
+	unsigned int val;
+
+	if (test_thread_flag(TIF_NOTSC))
+		val = PR_TSC_SIGSEGV;
+	else
+		val = PR_TSC_ENABLE;
+
+	return put_user(val, (unsigned int __user *)adr);
+}
+
+int set_tsc_mode(unsigned int val)
+{
+	if (val == PR_TSC_SIGSEGV)
+		disable_TSC();
+	else if (val == PR_TSC_ENABLE)
+		enable_TSC();
+	else
+		return -EINVAL;
+
+	return 0;
+}
+#endif /* CONFIG_DISABLE_TSC */

 static noinline void
 __switch_to_xtra(struct task_struct *prev_p, struct task_struct *next_p,
@@ -582,7 +621,7 @@ __switch_to_xtra(struct task_struct *prev_p, struct task_struct *next_p,
 		set_debugreg(next->debugreg7, 7);
 	}

-#ifdef CONFIG_SECCOMP
+#ifdef CONFIG_DISABLE_TSC
 	if (test_tsk_thread_flag(prev_p, TIF_NOTSC) ^
 	    test_tsk_thread_flag(next_p, TIF_NOTSC)) {
 		/* prev and next are different */
@@ -839,3 +878,4 @@ unsigned long arch_randomize_brk(struct mm_struct *mm)
 	unsigned long range_end = mm->brk + 0x02000000;
 	return randomize_range(mm->brk, range_end, 0) ? : mm->brk;
 }
+
diff --git a/arch/x86/kernel/process_64.c b/arch/x86/kernel/process_64.c
index 043a0c8..8ef8a2f 100644
--- a/arch/x86/kernel/process_64.c
+++ b/arch/x86/kernel/process_64.c
@@ -37,6 +37,7 @@
 #include <linux/kprobes.h>
 #include <linux/kdebug.h>
 #include <linux/tick.h>
+#include <linux/prctl.h>

 #include <asm/uaccess.h>
 #include <asm/pgtable.h>
@@ -555,6 +556,66 @@ start_thread(struct pt_regs *regs, unsigned long new_ip, unsigned long new_sp)
 }
 EXPORT_SYMBOL_GPL(start_thread);

+#ifdef CONFIG_DISABLE_TSC
+static void hard_disable_TSC(void)
+{
+	write_cr4(read_cr4() | X86_CR4_TSD);
+}
+
+void disable_TSC(void)
+{
+	preempt_disable();
+	if (!test_and_set_thread_flag(TIF_NOTSC))
+		/*
+		 * Must flip the CPU state synchronously with
+		 * TIF_NOTSC in the current running context.
+		 */
+		hard_disable_TSC();
+	preempt_enable();
+}
+
+static void hard_enable_TSC(void)
+{
+	write_cr4(read_cr4() & ~X86_CR4_TSD);
+}
+
+void enable_TSC(void)
+{
+	preempt_disable();
+	if (test_and_clear_thread_flag(TIF_NOTSC))
+		/*
+		 * Must flip the CPU state synchronously with
+		 * TIF_NOTSC in the current running context.
+		 */
+		hard_enable_TSC();
+	preempt_enable();
+}
+
+int get_tsc_mode(unsigned long adr)
+{
+	unsigned int val;
+
+	if (test_thread_flag(TIF_NOTSC))
+		val = PR_TSC_SIGSEGV;
+	else
+		val = PR_TSC_ENABLE;
+
+	return put_user(val, (unsigned int __user *)adr);
+}
+
+int set_tsc_mode(unsigned int val)
+{
+	if (val == PR_TSC_SIGSEGV)
+		disable_TSC();
+	else if (val == PR_TSC_ENABLE)
+		enable_TSC();
+	else
+		return -EINVAL;
+
+	return 0;
+}
+#endif /* CONFIG_DISABLE_TSC */
+
 /*
  * This special macro can be used to load a debugging register
  */
@@ -592,6 +653,17 @@ static inline void __switch_to_xtra(struct task_struct *prev_p,
 		loaddebug(next, 7);
 	}

+#ifdef CONFIG_DISABLE_TSC
+	if (test_tsk_thread_flag(prev_p, TIF_NOTSC) ^
+	    test_tsk_thread_flag(next_p, TIF_NOTSC)) {
+		/* prev and next are different */
+		if (test_tsk_thread_flag(next_p, TIF_NOTSC))
+			hard_disable_TSC();
+		else
+			hard_enable_TSC();
+	}
+#endif
+
 	if (test_tsk_thread_flag(next_p, TIF_IO_BITMAP)) {
 		/*
 		 * Copy the relevant range of the IO bitmap.
diff --git a/include/asm-x86/processor.h b/include/asm-x86/processor.h
index 7b1e3a8..64eea62 100644
--- a/include/asm-x86/processor.h
+++ b/include/asm-x86/processor.h
@@ -921,4 +921,15 @@ extern void start_thread(struct pt_regs *regs, unsigned long new_ip,

 #define KSTK_EIP(task)		(task_pt_regs(task)->ip)

+#ifdef CONFIG_DISABLE_TSC
+
+/* Get/set a process' ability to use the timestamp counter instruction */
+#define GET_TSC_CTL(adr)	get_tsc_mode((adr))
+#define SET_TSC_CTL(val)	set_tsc_mode((val))
+
+extern int get_tsc_mode(unsigned long adr);
+extern int set_tsc_mode(unsigned int val);
+
+#endif
+
 #endif
diff --git a/include/asm-x86/thread_info_64.h b/include/asm-x86/thread_info_64.h
index f23fefc..ed664e8 100644
--- a/include/asm-x86/thread_info_64.h
+++ b/include/asm-x86/thread_info_64.h
@@ -124,6 +124,7 @@ static inline struct thread_info *stack_thread_info(void)
 #define TIF_DEBUGCTLMSR		25	/* uses thread_struct.debugctlmsr */
 #define TIF_DS_AREA_MSR		26      /* uses thread_struct.ds_area_msr */
 #define TIF_BTS_TRACE_TS	27      /* record scheduling event timestamps */
+#define TIF_NOTSC		28	/* TSC is not accessible in userland */

 #define _TIF_SYSCALL_TRACE	(1 << TIF_SYSCALL_TRACE)
 #define _TIF_SIGPENDING		(1 << TIF_SIGPENDING)
@@ -145,6 +146,7 @@ static inline struct thread_info *stack_thread_info(void)
 #define _TIF_DEBUGCTLMSR	(1 << TIF_DEBUGCTLMSR)
 #define _TIF_DS_AREA_MSR	(1 << TIF_DS_AREA_MSR)
 #define _TIF_BTS_TRACE_TS	(1 << TIF_BTS_TRACE_TS)
+#define _TIF_NOTSC		(1 << TIF_NOTSC)

 /* work to do on interrupt/exception return */
 #define _TIF_WORK_MASK							\
@@ -158,7 +160,7 @@ static inline struct thread_info *stack_thread_info(void)

 /* flags to check in __switch_to() */
 #define _TIF_WORK_CTXSW							\
-	(_TIF_IO_BITMAP|_TIF_DEBUGCTLMSR|_TIF_DS_AREA_MSR|_TIF_BTS_TRACE_TS)
+	(_TIF_IO_BITMAP|_TIF_DEBUGCTLMSR|_TIF_DS_AREA_MSR|_TIF_BTS_TRACE_TS|_TIF_NOTSC)
 #define _TIF_WORK_CTXSW_PREV _TIF_WORK_CTXSW
 #define _TIF_WORK_CTXSW_NEXT (_TIF_WORK_CTXSW|_TIF_DEBUG)

diff --git a/include/asm-x86/tsc.h b/include/asm-x86/tsc.h
index d2d8eb5..3281e21 100644
--- a/include/asm-x86/tsc.h
+++ b/include/asm-x86/tsc.h
@@ -17,7 +17,10 @@ typedef unsigned long long cycles_t;
 extern unsigned int cpu_khz;
 extern unsigned int tsc_khz;

+#ifdef CONFIG_DISABLE_TSC
 extern void disable_TSC(void);
+extern void enable_TSC(void);
+#endif

 static inline cycles_t get_cycles(void)
 {
diff --git a/kernel/seccomp.c b/kernel/seccomp.c
index ad64fcb..0e0c7f0 100644
--- a/kernel/seccomp.c
+++ b/kernel/seccomp.c
@@ -74,7 +74,7 @@ long prctl_set_seccomp(unsigned long seccomp_mode)
 	if (seccomp_mode && seccomp_mode <= NR_SECCOMP_MODES) {
 		current->seccomp.mode = seccomp_mode;
 		set_thread_flag(TIF_SECCOMP);
-#ifdef TIF_NOTSC
+#ifdef CONFIG_DISABLE_TSC
 		disable_TSC();
 #endif
 		ret = 0;
