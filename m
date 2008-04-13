Return-Path: <linux-kernel-owner+w=401wt.eu-S1753389AbYDMWYu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753389AbYDMWYu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Apr 2008 18:24:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752267AbYDMWYl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Apr 2008 18:24:41 -0400
Received: from keg.few.vu.nl ([130.37.24.4]:46468 "EHLO keg.few.vu.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752051AbYDMWYj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Apr 2008 18:24:39 -0400
Date: Mon, 14 Apr 2008 00:24:18 +0200 (CEST)
From: Erik Bosman <ejbosman@cs.vu.nl>
X-X-Sender: ebn310@keg.few.vu.nl
To: Andrew Morton <akpm@linux-foundation.org>
cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Arjan van de Ven <arjan@infradead.org>,
       Andrea Arcangeli <andrea@cpushare.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Subject: re: [PATCH 2/3-REVISED] x86: Implement prctl PR_GET_TSC and PR_SET_TSC
In-Reply-To: <Pine.GSO.4.56.0804111855070.16669@keg.few.vu.nl>
Message-ID: <Pine.GSO.4.56.0804140014000.6537@keg.few.vu.nl>
References: <Pine.GSO.4.56.0804111855070.16669@keg.few.vu.nl>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


(I have made it non-configurable and it does not touch kernel/seccomp.c
anymore. I only changed ifdef/endifs)

    This patch implements the PR_GET_TSC and PR_SET_TSC prctl()
    commands on the x86 platform (both 32 and 64 bit.) These
    commands control the ability to read the timestamp counter
    from userspace (the RDTSC instruction.)

    While the RDTSC instuction is a useful profiling tool,
    it is also the source of some non-determinism in ring-3.
    For deterministic replay applications it is useful to be
    able to trap and emulate (and record the outcome of) this
    instruction.

    This patch uses code earlier used to disable the timestamp
    counter for the SECCOMP framework. A side-effect of this
    patch is that the SECCOMP environment will now also disable
    the timestamp counter on x86_64 due to the addition of the
    TIF_NOTSC define on this platform.

    The code which enables/disables the RDTSC instruction during
    context switches is in the __switch_to_xtra function, which
    already handles other unusual conditions, so normal
    performance should not have to suffer from this change.

    Signed-off-by: Erik Bosman <ejbosman@cs.vu.nl>

---
 arch/x86/kernel/process_32.c     |   43 +++++++++++++++++++++--
 arch/x86/kernel/process_64.c     |   68 ++++++++++++++++++++++++++++++++++++++
 include/asm-x86/processor.h      |    7 ++++
 include/asm-x86/thread_info_64.h |    4 ++-
 include/asm-x86/tsc.h            |    1 +
 5 files changed, 118 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kernel/process_32.c b/arch/x86/kernel/process_32.c
index 6496344..e99e615 100644
--- a/arch/x86/kernel/process_32.c
+++ b/arch/x86/kernel/process_32.c
@@ -36,6 +36,7 @@
 #include <linux/personality.h>
 #include <linux/tick.h>
 #include <linux/percpu.h>
+#include <linux/prctl.h>

 #include <asm/uaccess.h>
 #include <asm/pgtable.h>
@@ -528,11 +529,11 @@ start_thread(struct pt_regs *regs, unsigned long new_ip, unsigned long new_sp)
 }
 EXPORT_SYMBOL_GPL(start_thread);

-#ifdef CONFIG_SECCOMP
 static void hard_disable_TSC(void)
 {
 	write_cr4(read_cr4() | X86_CR4_TSD);
 }
+
 void disable_TSC(void)
 {
 	preempt_disable();
@@ -544,11 +545,47 @@ void disable_TSC(void)
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

 static noinline void
 __switch_to_xtra(struct task_struct *prev_p, struct task_struct *next_p,
@@ -582,7 +619,6 @@ __switch_to_xtra(struct task_struct *prev_p, struct task_struct *next_p,
 		set_debugreg(next->debugreg7, 7);
 	}

-#ifdef CONFIG_SECCOMP
 	if (test_tsk_thread_flag(prev_p, TIF_NOTSC) ^
 	    test_tsk_thread_flag(next_p, TIF_NOTSC)) {
 		/* prev and next are different */
@@ -591,7 +627,6 @@ __switch_to_xtra(struct task_struct *prev_p, struct task_struct *next_p,
 		else
 			hard_enable_TSC();
 	}
-#endif

 #ifdef X86_BTS
 	if (test_tsk_thread_flag(prev_p, TIF_BTS_TRACE_TS))
diff --git a/arch/x86/kernel/process_64.c b/arch/x86/kernel/process_64.c
index 043a0c8..efa98af 100644
--- a/arch/x86/kernel/process_64.c
+++ b/arch/x86/kernel/process_64.c
@@ -37,6 +37,7 @@
 #include <linux/kprobes.h>
 #include <linux/kdebug.h>
 #include <linux/tick.h>
+#include <linux/prctl.h>

 #include <asm/uaccess.h>
 #include <asm/pgtable.h>
@@ -555,6 +556,64 @@ start_thread(struct pt_regs *regs, unsigned long new_ip, unsigned long new_sp)
 }
 EXPORT_SYMBOL_GPL(start_thread);

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
+
 /*
  * This special macro can be used to load a debugging register
  */
@@ -592,6 +651,15 @@ static inline void __switch_to_xtra(struct task_struct *prev_p,
 		loaddebug(next, 7);
 	}

+	if (test_tsk_thread_flag(prev_p, TIF_NOTSC) ^
+	    test_tsk_thread_flag(next_p, TIF_NOTSC)) {
+		/* prev and next are different */
+		if (test_tsk_thread_flag(next_p, TIF_NOTSC))
+			hard_disable_TSC();
+		else
+			hard_enable_TSC();
+	}
+
 	if (test_tsk_thread_flag(next_p, TIF_IO_BITMAP)) {
 		/*
 		 * Copy the relevant range of the IO bitmap.
diff --git a/include/asm-x86/processor.h b/include/asm-x86/processor.h
index 7b1e3a8..e6bf92d 100644
--- a/include/asm-x86/processor.h
+++ b/include/asm-x86/processor.h
@@ -921,4 +921,11 @@ extern void start_thread(struct pt_regs *regs, unsigned long new_ip,

 #define KSTK_EIP(task)		(task_pt_regs(task)->ip)

+/* Get/set a process' ability to use the timestamp counter instruction */
+#define GET_TSC_CTL(adr)	get_tsc_mode((adr))
+#define SET_TSC_CTL(val)	set_tsc_mode((val))
+
+extern int get_tsc_mode(unsigned long adr);
+extern int set_tsc_mode(unsigned int val);
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
index d2d8eb5..0434bd8 100644
--- a/include/asm-x86/tsc.h
+++ b/include/asm-x86/tsc.h
@@ -18,6 +18,7 @@ extern unsigned int cpu_khz;
 extern unsigned int tsc_khz;

 extern void disable_TSC(void);
+extern void enable_TSC(void);

 static inline cycles_t get_cycles(void)
 {
