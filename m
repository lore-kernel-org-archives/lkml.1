Return-Path: <linux-kernel-owner+w=401wt.eu-S1759965AbZCPKSR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759965AbZCPKSR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Mar 2009 06:18:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755926AbZCPKR7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Mar 2009 06:17:59 -0400
Received: from bilbo.ozlabs.org ([203.10.76.25]:40458 "EHLO bilbo.ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753363AbZCPKR6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Mar 2009 06:17:58 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18878.10058.953388.356531@cargo.ozlabs.ibm.com>
Date: Mon, 16 Mar 2009 21:17:46 +1100
From: Paul Mackerras <paulus@samba.org>
To: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH] perfcounters: abstract wakeup flag setting in core to fix powerpc build
X-Mailer: VM 8.0.9 under Emacs 22.2.1 (i486-pc-linux-gnu)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: build fix for powerpc

Commit bd753921015e7905 ("perf_counter: software counter event
infrastructure") introduced a use of TIF_PERF_COUNTERS into the core
perfcounter code.  This breaks the build on powerpc because we use
a flag in a per-cpu area to signal wakeups on powerpc rather than
a thread_info flag, because the thread_info flags have to be
manipulated with atomic operations and are thus slower than per-cpu
flags.

This fixes the by changing the core to use an abstracted
set_perf_counter_pending() function, which is defined on x86 to set
the TIF_PERF_COUNTERS flag and on powerpc to set the per-cpu flag
(paca->perf_counter_pending).  It changes the previous powerpc
definition of set_perf_counter_pending to not take an argument and
adds a clear_perf_counter_pending, so as to simplify the definition
on x86.

On x86, set_perf_counter_pending() is defined as a macro.  Defining
it as a static inline in arch/x86/include/asm/perf_counters.h causes
compile failures because <asm/perf_counters.h> gets included early in
<linux/sched.h>, and the definitions of set_tsk_thread_flag etc. are
therefore not available in <asm/perf_counters.h>.  (On powerpc this
problem is avoided by defining set_perf_counter_pending etc. in
<asm/hw_irq.h>.)

Signed-off-by: Paul Mackerras <paulus@samba.org>
---
This is in the master branch of my perfcounters.git repository at:

git://git.kernel.org/pub/scm/linux/kernel/git/paulus/perfcounters.git master

 arch/powerpc/include/asm/hw_irq.h   |   14 +++++++++++---
 arch/powerpc/kernel/irq.c           |   11 +++--------
 arch/powerpc/kernel/perf_counter.c  |    3 +--
 arch/x86/include/asm/perf_counter.h |    3 +++
 kernel/perf_counter.c               |    2 +-
 5 files changed, 19 insertions(+), 14 deletions(-)

diff --git a/arch/powerpc/include/asm/hw_irq.h b/arch/powerpc/include/asm/hw_irq.h
index e10f151..94361c0 100644
--- a/arch/powerpc/include/asm/hw_irq.h
+++ b/arch/powerpc/include/asm/hw_irq.h
@@ -142,10 +142,17 @@ static inline unsigned long get_perf_counter_pending(void)
 	return x;
 }
 
-static inline void set_perf_counter_pending(int x)
+static inline void set_perf_counter_pending(void)
 {
 	asm volatile("stb %0,%1(13)" : :
-		"r" (x),
+		"r" (1),
+		"i" (offsetof(struct paca_struct, perf_counter_pending)));
+}
+
+static inline void clear_perf_counter_pending(void)
+{
+	asm volatile("stb %0,%1(13)" : :
+		"r" (0),
 		"i" (offsetof(struct paca_struct, perf_counter_pending)));
 }
 
@@ -158,7 +165,8 @@ static inline unsigned long get_perf_counter_pending(void)
 	return 0;
 }
 
-static inline void set_perf_counter_pending(int x) {}
+static inline void set_perf_counter_pending(void) {}
+static inline void clear_perf_counter_pending(void) {}
 static inline void perf_counter_do_pending(void) {}
 #endif /* CONFIG_PERF_COUNTERS */
 
diff --git a/arch/powerpc/kernel/irq.c b/arch/powerpc/kernel/irq.c
index 7f8e6a9..2269976 100644
--- a/arch/powerpc/kernel/irq.c
+++ b/arch/powerpc/kernel/irq.c
@@ -104,13 +104,6 @@ static inline notrace void set_soft_enabled(unsigned long enable)
 	: : "r" (enable), "i" (offsetof(struct paca_struct, soft_enabled)));
 }
 
-#ifdef CONFIG_PERF_COUNTERS
-notrace void __weak perf_counter_do_pending(void)
-{
-	set_perf_counter_pending(0);
-}
-#endif
-
 notrace void raw_local_irq_restore(unsigned long en)
 {
 	/*
@@ -142,8 +135,10 @@ notrace void raw_local_irq_restore(unsigned long en)
 			iseries_handle_interrupts();
 	}
 
-	if (get_perf_counter_pending())
+	if (get_perf_counter_pending()) {
+		clear_perf_counter_pending();
 		perf_counter_do_pending();
+	}
 
 	/*
 	 * if (get_paca()->hard_enabled) return;
diff --git a/arch/powerpc/kernel/perf_counter.c b/arch/powerpc/kernel/perf_counter.c
index 0e33d27..5008762 100644
--- a/arch/powerpc/kernel/perf_counter.c
+++ b/arch/powerpc/kernel/perf_counter.c
@@ -653,7 +653,6 @@ void perf_counter_do_pending(void)
 	struct cpu_hw_counters *cpuhw = &__get_cpu_var(cpu_hw_counters);
 	struct perf_counter *counter;
 
-	set_perf_counter_pending(0);
 	for (i = 0; i < cpuhw->n_counters; ++i) {
 		counter = cpuhw->counter[i];
 		if (counter && counter->wakeup_pending) {
@@ -811,7 +810,7 @@ static void perf_counter_interrupt(struct pt_regs *regs)
 			perf_counter_do_pending();
 			irq_exit();
 		} else {
-			set_perf_counter_pending(1);
+			set_perf_counter_pending();
 		}
 	}
 }
diff --git a/arch/x86/include/asm/perf_counter.h b/arch/x86/include/asm/perf_counter.h
index 2e08ed7..1662043 100644
--- a/arch/x86/include/asm/perf_counter.h
+++ b/arch/x86/include/asm/perf_counter.h
@@ -84,6 +84,9 @@ union cpuid10_edx {
 #define MSR_ARCH_PERFMON_FIXED_CTR2			0x30b
 #define X86_PMC_IDX_FIXED_BUS_CYCLES			(X86_PMC_IDX_FIXED + 2)
 
+#define set_perf_counter_pending()	\
+		set_tsk_thread_flag(current, TIF_PERF_COUNTERS);
+
 #ifdef CONFIG_PERF_COUNTERS
 extern void init_hw_perf_counters(void);
 extern void perf_counters_lapic_init(int nmi);
diff --git a/kernel/perf_counter.c b/kernel/perf_counter.c
index 0018c5e..b39456a 100644
--- a/kernel/perf_counter.c
+++ b/kernel/perf_counter.c
@@ -1433,7 +1433,7 @@ static void perf_swcounter_interrupt(struct perf_counter *counter,
 
 	if (nmi) {
 		counter->wakeup_pending = 1;
-		set_tsk_thread_flag(current, TIF_PERF_COUNTERS);
+		set_perf_counter_pending();
 	} else
 		wake_up(&counter->waitq);
 }
-- 
1.5.6.3

