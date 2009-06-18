Return-Path: <linux-kernel-owner+w=401wt.eu-S1761847AbZFRMtm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761847AbZFRMtm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jun 2009 08:49:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752894AbZFRMte
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Jun 2009 08:49:34 -0400
Received: from hera.kernel.org ([140.211.167.34]:38161 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751137AbZFRMtd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jun 2009 08:49:33 -0400
Date: Thu, 18 Jun 2009 12:48:53 GMT
From: tip-bot for Paul Mackerras <paulus@samba.org>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, paulus@samba.org, hpa@zytor.com,
       mingo@redhat.com, a.p.zijlstra@chello.nl, tglx@linutronix.de,
       mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org,
       linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl,
       tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <19000.55404.103840.393470@cargo.ozlabs.ibm.com>
References: <19000.55404.103840.393470@cargo.ozlabs.ibm.com>
Subject: [tip:perfcounters/core] perf_counter: powerpc: Enable use of software counters on 32-bit powerpc
Message-ID: <tip-105988c015943e77092a6568bc5fb7e386df6ccd@git.kernel.org>
Git-Commit-ID: 105988c015943e77092a6568bc5fb7e386df6ccd
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Thu, 18 Jun 2009 12:48:54 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  105988c015943e77092a6568bc5fb7e386df6ccd
Gitweb:     http://git.kernel.org/tip/105988c015943e77092a6568bc5fb7e386df6ccd
Author:     Paul Mackerras <paulus@samba.org>
AuthorDate: Wed, 17 Jun 2009 21:50:04 +1000
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Thu, 18 Jun 2009 11:11:44 +0200

perf_counter: powerpc: Enable use of software counters on 32-bit powerpc

This enables the perf_counter subsystem on 32-bit powerpc.  Since we
don't have any support for hardware counters on 32-bit powerpc yet,
only software counters can be used.

Besides selecting HAVE_PERF_COUNTERS for 32-bit powerpc as well as
64-bit, the main thing this does is add an implementation of
set_perf_counter_pending().  This needs to arrange for
perf_counter_do_pending() to be called when interrupts are enabled.
Rather than add code to local_irq_restore as 64-bit does, the 32-bit
set_perf_counter_pending() generates an interrupt by setting the
decrementer to 1 so that a decrementer interrupt will become pending
in 1 or 2 timebase ticks (if a decrementer interrupt isn't already
pending).  When interrupts are enabled, timer_interrupt() will be
called, and some new code in there calls perf_counter_do_pending().
We use a per-cpu array of flags to indicate whether we need to call
perf_counter_do_pending() or not.

This introduces a couple of new Kconfig symbols: PPC_HAVE_PMU_SUPPORT,
which is selected by processor families for which we have hardware PMU
support (currently only PPC64), and PPC_PERF_CTRS, which enables the
powerpc-specific perf_counter back-end.

Signed-off-by: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: linuxppc-dev@ozlabs.org
Cc: benh@kernel.crashing.org
LKML-Reference: <19000.55404.103840.393470@cargo.ozlabs.ibm.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 arch/powerpc/Kconfig                    |    1 +
 arch/powerpc/include/asm/hw_irq.h       |    5 ++++-
 arch/powerpc/include/asm/perf_counter.h |   10 ++++++++--
 arch/powerpc/kernel/Makefile            |    6 +++---
 arch/powerpc/kernel/time.c              |   25 +++++++++++++++++++++++++
 arch/powerpc/platforms/Kconfig.cputype  |   11 ++++++++++-
 6 files changed, 51 insertions(+), 7 deletions(-)

diff --git a/arch/powerpc/Kconfig b/arch/powerpc/Kconfig
index 9fb344d..bf6cedf 100644
--- a/arch/powerpc/Kconfig
+++ b/arch/powerpc/Kconfig
@@ -126,6 +126,7 @@ config PPC
 	select HAVE_OPROFILE
 	select HAVE_SYSCALL_WRAPPERS if PPC64
 	select GENERIC_ATOMIC64 if PPC32
+	select HAVE_PERF_COUNTERS
 
 config EARLY_PRINTK
 	bool
diff --git a/arch/powerpc/include/asm/hw_irq.h b/arch/powerpc/include/asm/hw_irq.h
index 10a642d..867ab8e 100644
--- a/arch/powerpc/include/asm/hw_irq.h
+++ b/arch/powerpc/include/asm/hw_irq.h
@@ -131,6 +131,8 @@ static inline int irqs_disabled_flags(unsigned long flags)
 struct irq_chip;
 
 #ifdef CONFIG_PERF_COUNTERS
+
+#ifdef CONFIG_PPC64
 static inline unsigned long test_perf_counter_pending(void)
 {
 	unsigned long x;
@@ -154,8 +156,9 @@ static inline void clear_perf_counter_pending(void)
 		"r" (0),
 		"i" (offsetof(struct paca_struct, perf_counter_pending)));
 }
+#endif /* CONFIG_PPC64 */
 
-#else
+#else  /* CONFIG_PERF_COUNTERS */
 
 static inline unsigned long test_perf_counter_pending(void)
 {
diff --git a/arch/powerpc/include/asm/perf_counter.h b/arch/powerpc/include/asm/perf_counter.h
index b398a84..2c2d9f6 100644
--- a/arch/powerpc/include/asm/perf_counter.h
+++ b/arch/powerpc/include/asm/perf_counter.h
@@ -57,11 +57,17 @@ extern struct power_pmu *ppmu;
 
 struct pt_regs;
 extern unsigned long perf_misc_flags(struct pt_regs *regs);
-#define perf_misc_flags(regs)	perf_misc_flags(regs)
-
 extern unsigned long perf_instruction_pointer(struct pt_regs *regs);
 
 /*
+ * Only override the default definitions in include/linux/perf_counter.h
+ * if we have hardware PMU support.
+ */
+#ifdef CONFIG_PPC_PERF_CTRS
+#define perf_misc_flags(regs)	perf_misc_flags(regs)
+#endif
+
+/*
  * The power_pmu.get_constraint function returns a 64-bit value and
  * a 64-bit mask that express the constraints between this event and
  * other events.
diff --git a/arch/powerpc/kernel/Makefile b/arch/powerpc/kernel/Makefile
index 612b0c4..c5f93f0 100644
--- a/arch/powerpc/kernel/Makefile
+++ b/arch/powerpc/kernel/Makefile
@@ -95,9 +95,9 @@ obj64-$(CONFIG_AUDIT)		+= compat_audit.o
 
 obj-$(CONFIG_DYNAMIC_FTRACE)	+= ftrace.o
 obj-$(CONFIG_FUNCTION_GRAPH_TRACER)	+= ftrace.o
-obj-$(CONFIG_PERF_COUNTERS)	+= perf_counter.o power4-pmu.o ppc970-pmu.o \
-				   power5-pmu.o power5+-pmu.o power6-pmu.o \
-				   power7-pmu.o
+obj-$(CONFIG_PPC_PERF_CTRS)	+= perf_counter.o
+obj64-$(CONFIG_PPC_PERF_CTRS)	+= power4-pmu.o ppc970-pmu.o power5-pmu.o \
+				   power5+-pmu.o power6-pmu.o power7-pmu.o
 
 obj-$(CONFIG_8XX_MINIMAL_FPEMU) += softemu8xx.o
 
diff --git a/arch/powerpc/kernel/time.c b/arch/powerpc/kernel/time.c
index 15391c2..eae4511 100644
--- a/arch/powerpc/kernel/time.c
+++ b/arch/powerpc/kernel/time.c
@@ -53,6 +53,7 @@
 #include <linux/posix-timers.h>
 #include <linux/irq.h>
 #include <linux/delay.h>
+#include <linux/perf_counter.h>
 
 #include <asm/io.h>
 #include <asm/processor.h>
@@ -525,6 +526,26 @@ void __init iSeries_time_init_early(void)
 }
 #endif /* CONFIG_PPC_ISERIES */
 
+#if defined(CONFIG_PERF_COUNTERS) && defined(CONFIG_PPC32)
+DEFINE_PER_CPU(u8, perf_counter_pending);
+
+void set_perf_counter_pending(void)
+{
+	get_cpu_var(perf_counter_pending) = 1;
+	set_dec(1);
+	put_cpu_var(perf_counter_pending);
+}
+
+#define test_perf_counter_pending()	__get_cpu_var(perf_counter_pending)
+#define clear_perf_counter_pending()	__get_cpu_var(perf_counter_pending) = 0
+
+#else  /* CONFIG_PERF_COUNTERS && CONFIG_PPC32 */
+
+#define test_perf_counter_pending()	0
+#define clear_perf_counter_pending()
+
+#endif /* CONFIG_PERF_COUNTERS && CONFIG_PPC32 */
+
 /*
  * For iSeries shared processors, we have to let the hypervisor
  * set the hardware decrementer.  We set a virtual decrementer
@@ -551,6 +572,10 @@ void timer_interrupt(struct pt_regs * regs)
 	set_dec(DECREMENTER_MAX);
 
 #ifdef CONFIG_PPC32
+	if (test_perf_counter_pending()) {
+		clear_perf_counter_pending();
+		perf_counter_do_pending();
+	}
 	if (atomic_read(&ppc_n_lost_interrupts) != 0)
 		do_IRQ(regs);
 #endif
diff --git a/arch/powerpc/platforms/Kconfig.cputype b/arch/powerpc/platforms/Kconfig.cputype
index cca6b4f..dd9f3ec 100644
--- a/arch/powerpc/platforms/Kconfig.cputype
+++ b/arch/powerpc/platforms/Kconfig.cputype
@@ -1,7 +1,7 @@
 config PPC64
 	bool "64-bit kernel"
 	default n
-	select HAVE_PERF_COUNTERS
+	select PPC_HAVE_PMU_SUPPORT
 	help
 	  This option selects whether a 32-bit or a 64-bit kernel
 	  will be built.
@@ -243,6 +243,15 @@ config VIRT_CPU_ACCOUNTING
 
 	  If in doubt, say Y here.
 
+config PPC_HAVE_PMU_SUPPORT
+       bool
+
+config PPC_PERF_CTRS
+       def_bool y
+       depends on PERF_COUNTERS && PPC_HAVE_PMU_SUPPORT
+       help
+         This enables the powerpc-specific perf_counter back-end.
+
 config SMP
 	depends on PPC_STD_MMU || FSL_BOOKE
 	bool "Symmetric multi-processing support"
