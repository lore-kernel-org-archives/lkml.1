Return-Path: <linux-kernel-owner+w=401wt.eu-S1755037AbZFMMal@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755037AbZFMMal (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Jun 2009 08:30:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752300AbZFMMad
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 13 Jun 2009 08:30:33 -0400
Received: from bilbo.ozlabs.org ([203.10.76.25]:52897 "EHLO bilbo.ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750929AbZFMMac (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Jun 2009 08:30:32 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18995.39910.109998.926269@cargo.ozlabs.ibm.com>
Date: Sat, 13 Jun 2009 22:30:30 +1000
From: Paul Mackerras <paulus@samba.org>
To: benh@kernel.crashing.org, linuxppc-dev@ozlabs.org
CC: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       linux-kernel@vger.kernel.org
Subject: [PATCH RFC] powerpc: perf_counter: Enable use of software
   counters on 32-bit powerpc
X-Mailer: VM 8.0.12 under 22.2.1 (i486-pc-linux-gnu)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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

Signed-off-by: Paul Mackerras <paulus@samba.org>
---
This patch depends on my 2 patches that provide an atomic64_t
implementation on 32-bit powerpc.

 arch/powerpc/Kconfig                    |    1 +
 arch/powerpc/include/asm/hw_irq.h       |    5 ++++-
 arch/powerpc/include/asm/perf_counter.h |    8 ++++++++
 arch/powerpc/kernel/Makefile            |    2 +-
 arch/powerpc/kernel/time.c              |   25 +++++++++++++++++++++++++
 arch/powerpc/platforms/Kconfig.cputype  |    1 -
 6 files changed, 39 insertions(+), 3 deletions(-)

diff --git a/arch/powerpc/Kconfig b/arch/powerpc/Kconfig
index 3f0a983..c531abc 100644
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
index b7f8f4a..5b7ebf9 100644
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
index cc7c887..df6c1fe 100644
--- a/arch/powerpc/include/asm/perf_counter.h
+++ b/arch/powerpc/include/asm/perf_counter.h
@@ -9,6 +9,7 @@
  * 2 of the License, or (at your option) any later version.
  */
 #include <linux/types.h>
+#include <linux/percpu.h>
 
 #define MAX_HWCOUNTERS		8
 #define MAX_EVENT_ALTERNATIVES	8
@@ -53,12 +54,19 @@ extern struct power_pmu *ppmu;
 #define PPMU_LIMITED_PMC_REQD	2	/* have to put this on a limited PMC */
 #define PPMU_ONLY_COUNT_RUN	4	/* only counting in run state */
 
+#ifdef CONFIG_PPC64
 struct pt_regs;
 extern unsigned long perf_misc_flags(struct pt_regs *regs);
 #define perf_misc_flags(regs)	perf_misc_flags(regs)
+#endif /* CONFIG_PPC64 */
 
 extern unsigned long perf_instruction_pointer(struct pt_regs *regs);
 
+#ifdef CONFIG_PPC32
+DECLARE_PER_CPU(u8, perf_counter_pending);
+extern void set_perf_counter_pending(void);
+#endif
+
 /*
  * The power_pmu.get_constraint function returns a 64-bit value and
  * a 64-bit mask that express the constraints between this event and
diff --git a/arch/powerpc/kernel/Makefile b/arch/powerpc/kernel/Makefile
index a2c6834..26db8ae 100644
--- a/arch/powerpc/kernel/Makefile
+++ b/arch/powerpc/kernel/Makefile
@@ -94,7 +94,7 @@ obj64-$(CONFIG_AUDIT)		+= compat_audit.o
 
 obj-$(CONFIG_DYNAMIC_FTRACE)	+= ftrace.o
 obj-$(CONFIG_FUNCTION_GRAPH_TRACER)	+= ftrace.o
-obj-$(CONFIG_PERF_COUNTERS)	+= perf_counter.o power4-pmu.o ppc970-pmu.o \
+obj64-$(CONFIG_PERF_COUNTERS)	+= perf_counter.o power4-pmu.o ppc970-pmu.o \
 				   power5-pmu.o power5+-pmu.o power6-pmu.o \
 				   power7-pmu.o
 
diff --git a/arch/powerpc/kernel/time.c b/arch/powerpc/kernel/time.c
index 48571ac..f9b718c 100644
--- a/arch/powerpc/kernel/time.c
+++ b/arch/powerpc/kernel/time.c
@@ -52,6 +52,7 @@
 #include <linux/jiffies.h>
 #include <linux/posix-timers.h>
 #include <linux/irq.h>
+#include <linux/perf_counter.h>
 
 #include <asm/io.h>
 #include <asm/processor.h>
@@ -524,6 +525,26 @@ void __init iSeries_time_init_early(void)
 }
 #endif /* CONFIG_PPC_ISERIES */
 
+#if defined(CONFIG_PERF_COUNTERS) && defined(CONFIG_PPC32)
+DEFINE_PER_CPU(u8, perf_counter_pending);
+
+extern void set_perf_counter_pending(void)
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
@@ -550,6 +571,10 @@ void timer_interrupt(struct pt_regs * regs)
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
index 732ee93..9da795e 100644
--- a/arch/powerpc/platforms/Kconfig.cputype
+++ b/arch/powerpc/platforms/Kconfig.cputype
@@ -1,7 +1,6 @@
 config PPC64
 	bool "64-bit kernel"
 	default n
-	select HAVE_PERF_COUNTERS
 	help
 	  This option selects whether a 32-bit or a 64-bit kernel
 	  will be built.
