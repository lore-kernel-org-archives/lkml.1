Return-Path: <linux-kernel-owner+w=401wt.eu-S1757987AbZCQWIY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757987AbZCQWIY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Mar 2009 18:08:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756212AbZCQWGT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Mar 2009 18:06:19 -0400
Received: from casper.infradead.org ([85.118.1.10]:35077 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754437AbZCQWGO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Mar 2009 18:06:14 -0400
Message-Id: <20090317220421.641671253@chello.nl>
References: <20090317215606.037073805@chello.nl>
User-Agent: quilt/0.46-1
Date: Tue, 17 Mar 2009 22:56:16 +0100
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: mingo@elte.hu, paulus@samba.org, rostedt@goodmis.org
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [RFC][PATCH 10/11] perfcounters: abstract wakeup flag setting in core to fix powerpc build
Content-Disposition: inline; filename=paulus_perfcounters-abstract_wakeup_flag_setting_in_core_to_fix_powerpc_build.patch
X-Bad-Reply: References but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Paul Mackerras <paulus@samba.org>

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
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 arch/powerpc/include/asm/hw_irq.h   |   14 +++++++++++---
 arch/powerpc/kernel/irq.c           |   11 +++--------
 arch/powerpc/kernel/perf_counter.c  |    3 +--
 arch/x86/include/asm/perf_counter.h |    3 +++
 kernel/perf_counter.c               |    2 +-
 5 files changed, 19 insertions(+), 14 deletions(-)

Index: linux-2.6/arch/powerpc/include/asm/hw_irq.h
===================================================================
--- linux-2.6.orig/arch/powerpc/include/asm/hw_irq.h
+++ linux-2.6/arch/powerpc/include/asm/hw_irq.h
@@ -142,10 +142,17 @@ static inline unsigned long get_perf_cou
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
 
@@ -158,7 +165,8 @@ static inline unsigned long get_perf_cou
 	return 0;
 }
 
-static inline void set_perf_counter_pending(int x) {}
+static inline void set_perf_counter_pending(void) {}
+static inline void clear_perf_counter_pending(void) {}
 static inline void perf_counter_do_pending(void) {}
 #endif /* CONFIG_PERF_COUNTERS */
 
Index: linux-2.6/arch/powerpc/kernel/irq.c
===================================================================
--- linux-2.6.orig/arch/powerpc/kernel/irq.c
+++ linux-2.6/arch/powerpc/kernel/irq.c
@@ -104,13 +104,6 @@ static inline notrace void set_soft_enab
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
@@ -142,8 +135,10 @@ notrace void raw_local_irq_restore(unsig
 			iseries_handle_interrupts();
 	}
 
-	if (get_perf_counter_pending())
+	if (get_perf_counter_pending()) {
+		clear_perf_counter_pending();
 		perf_counter_do_pending();
+	}
 
 	/*
 	 * if (get_paca()->hard_enabled) return;
Index: linux-2.6/arch/powerpc/kernel/perf_counter.c
===================================================================
--- linux-2.6.orig/arch/powerpc/kernel/perf_counter.c
+++ linux-2.6/arch/powerpc/kernel/perf_counter.c
@@ -653,7 +653,6 @@ void perf_counter_do_pending(void)
 	struct cpu_hw_counters *cpuhw = &__get_cpu_var(cpu_hw_counters);
 	struct perf_counter *counter;
 
-	set_perf_counter_pending(0);
 	for (i = 0; i < cpuhw->n_counters; ++i) {
 		counter = cpuhw->counter[i];
 		if (counter && counter->wakeup_pending) {
@@ -811,7 +810,7 @@ static void perf_counter_interrupt(struc
 			perf_counter_do_pending();
 			irq_exit();
 		} else {
-			set_perf_counter_pending(1);
+			set_perf_counter_pending();
 		}
 	}
 }
Index: linux-2.6/arch/x86/include/asm/perf_counter.h
===================================================================
--- linux-2.6.orig/arch/x86/include/asm/perf_counter.h
+++ linux-2.6/arch/x86/include/asm/perf_counter.h
@@ -84,6 +84,9 @@ union cpuid10_edx {
 #define MSR_ARCH_PERFMON_FIXED_CTR2			0x30b
 #define X86_PMC_IDX_FIXED_BUS_CYCLES			(X86_PMC_IDX_FIXED + 2)
 
+#define set_perf_counter_pending()	\
+		set_tsk_thread_flag(current, TIF_PERF_COUNTERS);
+
 #ifdef CONFIG_PERF_COUNTERS
 extern void init_hw_perf_counters(void);
 extern void perf_counters_lapic_init(int nmi);
Index: linux-2.6/kernel/perf_counter.c
===================================================================
--- linux-2.6.orig/kernel/perf_counter.c
+++ linux-2.6/kernel/perf_counter.c
@@ -1438,7 +1438,7 @@ static void perf_swcounter_interrupt(str
 
 	if (nmi) {
 		counter->wakeup_pending = 1;
-		set_tsk_thread_flag(current, TIF_PERF_COUNTERS);
+		set_perf_counter_pending();
 	} else
 		wake_up(&counter->waitq);
 }

-- 

