Return-Path: <linux-kernel-owner+w=401wt.eu-S1757184AbYLDXrA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757184AbYLDXrA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2008 18:47:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751800AbYLDXqV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Dec 2008 18:46:21 -0500
Received: from www.tglx.de ([62.245.132.106]:38354 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753414AbYLDXqP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2008 18:46:15 -0500
Message-Id: <20081204230228.640677177@linutronix.de>
User-Agent: quilt/0.47-1
Date: Thu, 04 Dec 2008 23:45:00 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: linux-arch@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, Stephane Eranian <eranian@googlemail.com>,
       Eric Dumazet <dada1@cosmosbay.com>,
       Robert Richter <robert.richter@amd.com>,
       Arjan van de Veen <arjan@infradead.org>, Peter Anvin <hpa@zytor.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Steven Rostedt <rostedt@goodmis.org>,
       David Miller <davem@davemloft.net>, Paul Mackerras <paulus@samba.org>
Subject: [patch 3/3] performance counters: x86 support
References: <20081204225345.654705757@linutronix.de>
Content-Disposition: inline; filename=perf-counters-x86.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ingo Molnar <mingo@elte.hu>

Implement performance counters for x86 Intel CPUs.

It's simplified right now: the PERFMON CPU feature is assumed,
which is available in Core2 and later Intel CPUs.

The design is flexible to be extended to more CPU types as well.

Signed-off-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 arch/x86/Kconfig                               |    1 
 arch/x86/ia32/ia32entry.S                      |    3 
 arch/x86/include/asm/hardirq_32.h              |    1 
 arch/x86/include/asm/hw_irq.h                  |    2 
 arch/x86/include/asm/intel_arch_perfmon.h      |   10 
 arch/x86/include/asm/irq_vectors.h             |    5 
 arch/x86/include/asm/mach-default/entry_arch.h |    5 
 arch/x86/include/asm/pda.h                     |    1 
 arch/x86/include/asm/unistd_32.h               |    1 
 arch/x86/include/asm/unistd_64.h               |    3 
 arch/x86/kernel/apic.c                         |    2 
 arch/x86/kernel/cpu/Makefile                   |   12 
 arch/x86/kernel/cpu/common.c                   |    2 
 arch/x86/kernel/cpu/perf_counter.c             |  363 +++++++++++++++++++++++++
 arch/x86/kernel/entry_64.S                     |    6 
 arch/x86/kernel/irq.c                          |    5 
 arch/x86/kernel/irqinit_32.c                   |    3 
 arch/x86/kernel/irqinit_64.c                   |    5 
 arch/x86/kernel/syscall_table_32.S             |    1 
 19 files changed, 424 insertions(+), 7 deletions(-)

Index: linux/arch/x86/Kconfig
===================================================================
--- linux.orig/arch/x86/Kconfig
+++ linux/arch/x86/Kconfig
@@ -651,6 +651,7 @@ config X86_UP_IOAPIC
 config X86_LOCAL_APIC
 	def_bool y
 	depends on X86_64 || (X86_32 && (X86_UP_APIC || (SMP && !X86_VOYAGER) || X86_GENERICARCH))
+	select HAVE_PERF_COUNTERS
 
 config X86_IO_APIC
 	def_bool y
Index: linux/arch/x86/ia32/ia32entry.S
===================================================================
--- linux.orig/arch/x86/ia32/ia32entry.S
+++ linux/arch/x86/ia32/ia32entry.S
@@ -823,7 +823,8 @@ ia32_sys_call_table:
 	.quad compat_sys_signalfd4
 	.quad sys_eventfd2
 	.quad sys_epoll_create1
-	.quad sys_dup3			/* 330 */
+	.quad sys_dup3				/* 330 */
 	.quad sys_pipe2
 	.quad sys_inotify_init1
+	.quad sys_perf_counter_open
 ia32_syscall_end:
Index: linux/arch/x86/include/asm/hardirq_32.h
===================================================================
--- linux.orig/arch/x86/include/asm/hardirq_32.h
+++ linux/arch/x86/include/asm/hardirq_32.h
@@ -9,6 +9,7 @@ typedef struct {
 	unsigned long idle_timestamp;
 	unsigned int __nmi_count;	/* arch dependent */
 	unsigned int apic_timer_irqs;	/* arch dependent */
+	unsigned int apic_perf_irqs;	/* arch dependent */
 	unsigned int irq0_irqs;
 	unsigned int irq_resched_count;
 	unsigned int irq_call_count;
Index: linux/arch/x86/include/asm/hw_irq.h
===================================================================
--- linux.orig/arch/x86/include/asm/hw_irq.h
+++ linux/arch/x86/include/asm/hw_irq.h
@@ -30,6 +30,8 @@
 /* Interrupt handlers registered during init_IRQ */
 extern void apic_timer_interrupt(void);
 extern void error_interrupt(void);
+extern void perf_counter_interrupt(void);
+
 extern void spurious_interrupt(void);
 extern void thermal_interrupt(void);
 extern void reschedule_interrupt(void);
Index: linux/arch/x86/include/asm/intel_arch_perfmon.h
===================================================================
--- linux.orig/arch/x86/include/asm/intel_arch_perfmon.h
+++ linux/arch/x86/include/asm/intel_arch_perfmon.h
@@ -18,6 +18,8 @@
 #define ARCH_PERFMON_UNHALTED_CORE_CYCLES_PRESENT \
 	(1 << (ARCH_PERFMON_UNHALTED_CORE_CYCLES_INDEX))
 
+#define ARCH_PERFMON_BRANCH_MISSES_RETIRED	(6)
+
 union cpuid10_eax {
 	struct {
 		unsigned int version_id:8;
@@ -28,4 +30,12 @@ union cpuid10_eax {
 	unsigned int full;
 };
 
+#ifdef CONFIG_PERF_COUNTERS
+extern void init_hw_perf_counters(void);
+extern void perf_counters_lapic_init(void);
+#else
+static inline void init_hw_perf_counters(void)		{ }
+static inline void perf_counters_lapic_init(void)	{ }
+#endif
+
 #endif /* _ASM_X86_INTEL_ARCH_PERFMON_H */
Index: linux/arch/x86/include/asm/irq_vectors.h
===================================================================
--- linux.orig/arch/x86/include/asm/irq_vectors.h
+++ linux/arch/x86/include/asm/irq_vectors.h
@@ -87,6 +87,11 @@
 #define LOCAL_TIMER_VECTOR	0xef
 
 /*
+ * Performance monitoring interrupt vector:
+ */
+#define LOCAL_PERF_VECTOR	0xee
+
+/*
  * First APIC vector available to drivers: (vectors 0x30-0xee) we
  * start at 0x31(0x41) to spread out vectors evenly between priority
  * levels. (0x80 is the syscall vector)
Index: linux/arch/x86/include/asm/mach-default/entry_arch.h
===================================================================
--- linux.orig/arch/x86/include/asm/mach-default/entry_arch.h
+++ linux/arch/x86/include/asm/mach-default/entry_arch.h
@@ -25,10 +25,15 @@ BUILD_INTERRUPT(irq_move_cleanup_interru
  * a much simpler SMP time architecture:
  */
 #ifdef CONFIG_X86_LOCAL_APIC
+
 BUILD_INTERRUPT(apic_timer_interrupt,LOCAL_TIMER_VECTOR)
 BUILD_INTERRUPT(error_interrupt,ERROR_APIC_VECTOR)
 BUILD_INTERRUPT(spurious_interrupt,SPURIOUS_APIC_VECTOR)
 
+#ifdef CONFIG_PERF_COUNTERS
+BUILD_INTERRUPT(perf_counter_interrupt, LOCAL_PERF_VECTOR)
+#endif
+
 #ifdef CONFIG_X86_MCE_P4THERMAL
 BUILD_INTERRUPT(thermal_interrupt,THERMAL_APIC_VECTOR)
 #endif
Index: linux/arch/x86/include/asm/pda.h
===================================================================
--- linux.orig/arch/x86/include/asm/pda.h
+++ linux/arch/x86/include/asm/pda.h
@@ -30,6 +30,7 @@ struct x8664_pda {
 	short isidle;
 	struct mm_struct *active_mm;
 	unsigned apic_timer_irqs;
+	unsigned apic_perf_irqs;
 	unsigned irq0_irqs;
 	unsigned irq_resched_count;
 	unsigned irq_call_count;
Index: linux/arch/x86/include/asm/unistd_32.h
===================================================================
--- linux.orig/arch/x86/include/asm/unistd_32.h
+++ linux/arch/x86/include/asm/unistd_32.h
@@ -338,6 +338,7 @@
 #define __NR_dup3		330
 #define __NR_pipe2		331
 #define __NR_inotify_init1	332
+#define __NR_perf_counter_open	333
 
 #ifdef __KERNEL__
 
Index: linux/arch/x86/include/asm/unistd_64.h
===================================================================
--- linux.orig/arch/x86/include/asm/unistd_64.h
+++ linux/arch/x86/include/asm/unistd_64.h
@@ -653,7 +653,8 @@ __SYSCALL(__NR_dup3, sys_dup3)
 __SYSCALL(__NR_pipe2, sys_pipe2)
 #define __NR_inotify_init1			294
 __SYSCALL(__NR_inotify_init1, sys_inotify_init1)
-
+#define __NR_perf_counter_open		295
+__SYSCALL(__NR_perf_counter_open, sys_perf_counter_open)
 
 #ifndef __NO_STUBS
 #define __ARCH_WANT_OLD_READDIR
Index: linux/arch/x86/kernel/apic.c
===================================================================
--- linux.orig/arch/x86/kernel/apic.c
+++ linux/arch/x86/kernel/apic.c
@@ -31,6 +31,7 @@
 #include <linux/dmi.h>
 #include <linux/dmar.h>
 
+#include <asm/intel_arch_perfmon.h>
 #include <asm/atomic.h>
 #include <asm/smp.h>
 #include <asm/mtrr.h>
@@ -1147,6 +1148,7 @@ void __cpuinit setup_local_APIC(void)
 		apic_write(APIC_ESR, 0);
 	}
 #endif
+	perf_counters_lapic_init();
 
 	preempt_disable();
 
Index: linux/arch/x86/kernel/cpu/Makefile
===================================================================
--- linux.orig/arch/x86/kernel/cpu/Makefile
+++ linux/arch/x86/kernel/cpu/Makefile
@@ -1,5 +1,5 @@
 #
-# Makefile for x86-compatible CPU details and quirks
+# Makefile for x86-compatible CPU details, features and quirks
 #
 
 obj-y			:= intel_cacheinfo.o addon_cpuid_features.o
@@ -16,11 +16,13 @@ obj-$(CONFIG_CPU_SUP_CENTAUR_64)	+= cent
 obj-$(CONFIG_CPU_SUP_TRANSMETA_32)	+= transmeta.o
 obj-$(CONFIG_CPU_SUP_UMC_32)		+= umc.o
 
-obj-$(CONFIG_X86_MCE)	+= mcheck/
-obj-$(CONFIG_MTRR)	+= mtrr/
-obj-$(CONFIG_CPU_FREQ)	+= cpufreq/
+obj-$(CONFIG_PERF_COUNTERS)		+= perf_counter.o
 
-obj-$(CONFIG_X86_LOCAL_APIC) += perfctr-watchdog.o
+obj-$(CONFIG_X86_MCE)			+= mcheck/
+obj-$(CONFIG_MTRR)			+= mtrr/
+obj-$(CONFIG_CPU_FREQ)			+= cpufreq/
+
+obj-$(CONFIG_X86_LOCAL_APIC)		+= perfctr-watchdog.o
 
 quiet_cmd_mkcapflags = MKCAP   $@
       cmd_mkcapflags = $(PERL) $(srctree)/$(src)/mkcapflags.pl $< $@
Index: linux/arch/x86/kernel/cpu/common.c
===================================================================
--- linux.orig/arch/x86/kernel/cpu/common.c
+++ linux/arch/x86/kernel/cpu/common.c
@@ -17,6 +17,7 @@
 #include <asm/mmu_context.h>
 #include <asm/mtrr.h>
 #include <asm/mce.h>
+#include <asm/intel_arch_perfmon.h>
 #include <asm/pat.h>
 #include <asm/asm.h>
 #include <asm/numa.h>
@@ -750,6 +751,7 @@ void __init identify_boot_cpu(void)
 #else
 	vgetcpu_set_mode();
 #endif
+	init_hw_perf_counters();
 }
 
 void __cpuinit identify_secondary_cpu(struct cpuinfo_x86 *c)
Index: linux/arch/x86/kernel/cpu/perf_counter.c
===================================================================
--- /dev/null
+++ linux/arch/x86/kernel/cpu/perf_counter.c
@@ -0,0 +1,363 @@
+/*
+ * Performance counter x86 architecture code
+ *
+ *  Copyright(C) 2008 Thomas Gleixner <tglx@linutronix.de>
+ *  Copyright(C) 2008 Red Hat, Inc., Ingo Molnar
+ *
+ *  For licencing details see kernel-base/COPYING
+ */
+
+#include <linux/perf_counter.h>
+#include <linux/capability.h>
+#include <linux/hardirq.h>
+#include <linux/sched.h>
+
+#include <asm/intel_arch_perfmon.h>
+#include <asm/apic.h>
+
+static bool perf_counters_initialized __read_mostly;
+
+/*
+ * Number of (generic) HW counters:
+ */
+static int nr_perf_counters __read_mostly;
+
+/* No support for fixed function counters yet */
+
+#define MAX_COUNTERS		8
+
+struct used_counters {
+	struct perf_counter	*counters[MAX_COUNTERS];
+	unsigned long		used[BITS_TO_LONGS(MAX_COUNTERS)];
+};
+
+/* Read from cpuid ! */
+#define COUNTER_OVERFLOW	(1ULL << 40)
+
+/*
+ * Intel PerfMon v3. Used on Core2 and later.
+ */
+static DEFINE_PER_CPU(struct used_counters, used_counters);
+
+const int intel_perfmon_event_map[] =
+{
+  [PERF_COUNT_CYCLES]			= 0x003c,
+  [PERF_COUNT_INSTRUCTIONS]		= 0x00c0,
+  [PERF_COUNT_CACHE_REFERENCES]		= 0x4f2e,
+  [PERF_COUNT_CACHE_MISSES]		= 0x412e,
+  [PERF_COUNT_BRANCH_INSTRUCTIONS]	= 0x00c4,
+  [PERF_COUNT_BRANCH_MISSES]		= 0x00c5,
+};
+
+const int max_intel_perfmon_events = ARRAY_SIZE(intel_perfmon_event_map);
+
+/*
+ * Setup the hardware configuration for a given hw_event_type
+ */
+int hw_perf_counter_init(struct perf_counter *counter, s32 hw_event_type)
+{
+	struct hw_perf_counter *hwc = &counter->hw;
+
+	if (unlikely(!perf_counters_initialized))
+		return -EINVAL;
+
+	/*
+	 * Count user events, and generate PMC IRQs:
+	 * (keep 'enabled' bit clear for now)
+	 */
+	hwc->config = ARCH_PERFMON_EVENTSEL_USR | ARCH_PERFMON_EVENTSEL_INT;
+
+	/*
+	 * If privileged enough, count OS events too:
+	 */
+	if (capable(CAP_SYS_ADMIN))
+		hwc->config |= ARCH_PERFMON_EVENTSEL_OS;
+
+	hwc->config_base = MSR_ARCH_PERFMON_EVENTSEL0;
+	hwc->counter_base = MSR_ARCH_PERFMON_PERFCTR0;
+
+	hwc->irq_period = counter->__irq_period;
+	/*
+	 * Intel PMCs cannot be accessed sanely above 32 bit width,
+	 * so we install an artificial 1<<31 period regardless of
+	 * the generic counter period:
+	 */
+	if (!hwc->irq_period)
+		hwc->irq_period = 0x7FFFFFFF;
+
+	hwc->next_count = -((s32) hwc->irq_period);
+
+	/*
+	 * Negative event types mean raw encoded event+umask values:
+	 */
+	if (hw_event_type < 0) {
+		counter->hw_event_type = -hw_event_type;
+	} else {
+		if (hw_event_type >= max_intel_perfmon_events)
+			return -EINVAL;
+		/*
+		 * The generic map:
+		 */
+		counter->hw_event_type = intel_perfmon_event_map[hw_event_type];
+	}
+	hwc->config |= counter->hw_event_type;
+
+	return 0;
+}
+
+void hw_perf_counter_enable_config(struct perf_counter *counter)
+{
+	counter->hw.config |= ARCH_PERFMON_EVENTSEL0_ENABLE;
+}
+
+void hw_perf_counter_disable_config(struct perf_counter *counter)
+{
+	counter->hw.config &= ~ARCH_PERFMON_EVENTSEL0_ENABLE;
+}
+
+static void __hw_perf_counter_enable(struct hw_perf_counter *hwc, int idx)
+{
+	wrmsr(hwc->counter_base + idx, hwc->next_count, 0);
+	wrmsr(hwc->config_base + idx, hwc->config, 0);
+}
+
+void hw_perf_counter_enable(struct perf_counter *counter)
+{
+	struct used_counters *uc = &__get_cpu_var(used_counters);
+	struct hw_perf_counter *hwc = &counter->hw;
+	int idx = hwc->idx;
+
+	/* Try to get the previous counter again */
+	if (test_and_set_bit(idx, uc->used)) {
+		idx = find_first_zero_bit(uc->used, nr_perf_counters);
+		set_bit(idx, uc->used);
+		hwc->idx = idx;
+	}
+
+	perf_counters_lapic_init();
+
+	wrmsr(hwc->config_base + idx,
+	      hwc->config & ~ARCH_PERFMON_EVENTSEL0_ENABLE, 0);
+
+	uc->counters[idx] = counter;
+	__hw_perf_counter_enable(hwc, idx);
+}
+
+#ifdef CONFIG_X86_64
+static inline void atomic64_counter_set(struct perf_counter *counter, u64 val)
+{
+	atomic64_set(&counter->count, val);
+}
+#else
+/*
+ * Todo: add proper atomic64_t support to 32-bit x86:
+ */
+static inline void atomic64_counter_set(struct perf_counter *counter, u64 val64)
+{
+	u32 *val32 = (void *)&val64;
+
+	atomic_set(counter->count32 + 0, *(val32 + 0));
+	atomic_set(counter->count32 + 1, *(val32 + 1));
+}
+#endif
+
+static void __hw_perf_save_counter(struct perf_counter *counter,
+				   struct hw_perf_counter *hwc, int idx)
+{
+	s64 raw = -1;
+	s64 delta;
+	int err;
+
+	/*
+	 * Get the raw hw counter value:
+	 */
+	err = rdmsrl_safe(hwc->counter_base + idx, &raw);
+	WARN_ON_ONCE(err);
+
+	/*
+	 * Rebase it to zero (it started counting at -irq_period),
+	 * to see the delta since ->prev_count:
+	 */
+	delta = (s64)hwc->irq_period + (s64)(s32)raw;
+
+	atomic64_counter_set(counter, hwc->prev_count + delta);
+
+	/*
+	 * Adjust the ->prev_count offset - if we went beyond
+	 * irq_period of units, then we got an IRQ and the counter
+	 * was set back to -irq_period:
+	 */
+	while (delta > (s64)hwc->irq_period) {
+		hwc->prev_count += hwc->irq_period;
+		delta -= (s64)hwc->irq_period;
+	}
+
+	/*
+	 * Calculate the next raw counter value we'll write into
+	 * the counter at the next sched-in time:
+	 */
+	delta -= (s64)hwc->irq_period;
+	hwc->next_count = (s32)delta;
+}
+
+void hw_perf_counter_disable(struct perf_counter *counter)
+{
+	struct used_counters *uc = &__get_cpu_var(used_counters);
+	struct hw_perf_counter *hwc = &counter->hw;
+	unsigned int idx = hwc->idx;
+
+	wrmsr(hwc->config_base + idx,
+	      hwc->config & ~ARCH_PERFMON_EVENTSEL0_ENABLE, 0);
+
+	clear_bit(idx, uc->used);
+	uc->counters[idx] = NULL;
+	__hw_perf_save_counter(counter, hwc, idx);
+}
+
+void hw_perf_counter_read(struct perf_counter *counter)
+{
+	struct hw_perf_counter *hwc = &counter->hw;
+	unsigned long addr = hwc->counter_base + hwc->idx;
+	s64 offs, val = -1LL;
+	s32 val32;
+	int err;
+
+	/* Careful: NMI might modify the counter offset */
+	do {
+		offs = hwc->prev_count;
+		err = rdmsrl_safe(addr, &val);
+		WARN_ON_ONCE(err);
+	} while (offs != hwc->prev_count);
+
+	val32 = (s32) val;
+	val =  (s64)hwc->irq_period + (s64)val32;
+	atomic64_counter_set(counter, hwc->prev_count + val);
+}
+
+/*
+ * This handler is triggered by the local APIC, so the APIC IRQ handling
+ * rules apply:
+ */
+void smp_perf_counter_interrupt(struct pt_regs *regs)
+{
+	int bit, cpu = smp_processor_id();
+	struct used_counters *uc;
+	u64 status, *p;
+
+	ack_APIC_irq();
+
+	irq_enter();
+
+#ifdef CONFIG_X86_64
+	add_pda(apic_perf_irqs, 1);
+#else
+	per_cpu(irq_stat, cpu).apic_perf_irqs++;
+#endif
+
+	rdmsrl(MSR_CORE_PERF_GLOBAL_STATUS, status);
+	if (!status)
+		goto out;
+
+	uc = &per_cpu(used_counters, cpu);
+
+	for_each_bit(bit, (unsigned long *) &status, nr_perf_counters) {
+		struct perf_counter *counter = uc->counters[bit];
+		struct hw_perf_counter *hwc;
+		struct perf_data *irqdata;
+		int idx;
+
+		if (!counter)
+			continue;
+
+		hwc = &counter->hw;
+		idx = hwc->idx;
+
+		wrmsr(hwc->config_base + idx,
+		      hwc->config & ~ARCH_PERFMON_EVENTSEL0_ENABLE, 0);
+
+		__hw_perf_save_counter(counter, hwc, idx);
+		__hw_perf_counter_enable(hwc, idx);
+
+		if (counter->record_type != PERF_RECORD_IRQ)
+			continue;
+
+		irqdata = counter->irqdata;
+		if (irqdata->len > PERF_DATA_BUFLEN - sizeof(u64))
+			irqdata->overrun++;
+		else {
+			p = (u64 *) &irqdata->data[irqdata->len];
+			*p = instruction_pointer(regs);
+			irqdata->len += sizeof(u64);
+		}
+		wake_up(&counter->waitq);
+	}
+out:
+	/*
+	 * Clear the MASK field of the LAPIC's LVTPC.
+	 *
+	 * IA_SDM_Vol3A says:
+	 *
+	 * " (Pentium 4 and Intel Xeon processors.) When a performance
+	 *   monitoring counters interrupt is generated, the mask bit for
+	 *   its associated LVT entry is set. "
+	 *
+	 * So we need to unmask the LVT entry, otherwise future IRQs are
+	 * masked. Since this does not harm on other CPUs we do this
+	 * unconditionally:
+	 */
+	apic_write(APIC_LVTPC, LOCAL_PERF_VECTOR);
+
+	irq_exit();
+}
+
+void __cpuinit perf_counters_lapic_init(void)
+{
+	u32 apic_val;
+
+	if (!perf_counters_initialized)
+		return;
+	/*
+	 * Enable the performance counter vector in the APIC LVT:
+	 */
+	apic_val = apic_read(APIC_LVTERR);
+
+	apic_write(APIC_LVTERR, apic_val | APIC_LVT_MASKED);
+	apic_write(APIC_LVTPC, LOCAL_PERF_VECTOR);
+	apic_write(APIC_LVTERR, apic_val);
+}
+
+
+void __init init_hw_perf_counters(void)
+{
+	union cpuid10_eax eax;
+	unsigned int unused;
+	unsigned int ebx;
+
+	if (!cpu_has(&boot_cpu_data, X86_FEATURE_ARCH_PERFMON))
+		return;
+
+	/*
+	 * Check whether the Architectural PerfMon supports
+	 * Branch Misses Retired Event or not.
+	 */
+	cpuid(10, &(eax.full), &ebx, &unused, &unused);
+	if (eax.split.mask_length <= ARCH_PERFMON_BRANCH_MISSES_RETIRED)
+		return;
+
+	printk(KERN_INFO "Intel Performance Monitoring support detected.\n");
+
+	printk(KERN_INFO "... version:      %d\n", eax.split.version_id);
+	printk(KERN_INFO "... num_counters: %d\n", eax.split.num_counters);
+	nr_perf_counters = eax.split.num_counters;
+	if (nr_perf_counters > MAX_COUNTERS) {
+		nr_perf_counters = MAX_COUNTERS;
+		WARN(1, KERN_ERR "hw perf counters %d > max(%d), clipping!",
+			nr_perf_counters, MAX_COUNTERS);
+	}
+	printk(KERN_INFO "... bit_width:    %d\n", eax.split.bit_width);
+	printk(KERN_INFO "... mask_length:  %d\n", eax.split.mask_length);
+
+	perf_counters_lapic_init();
+
+	perf_counters_initialized = true;
+}
Index: linux/arch/x86/kernel/entry_64.S
===================================================================
--- linux.orig/arch/x86/kernel/entry_64.S
+++ linux/arch/x86/kernel/entry_64.S
@@ -869,6 +869,12 @@ END(error_interrupt)
 ENTRY(spurious_interrupt)
 	apicinterrupt SPURIOUS_APIC_VECTOR,smp_spurious_interrupt
 END(spurious_interrupt)
+
+#ifdef CONFIG_PERF_COUNTERS
+ENTRY(perf_counter_interrupt)
+	apicinterrupt LOCAL_PERF_VECTOR,smp_perf_counter_interrupt
+END(perf_counter_interrupt)
+#endif
 				
 /*
  * Exception entry points.
Index: linux/arch/x86/kernel/irq.c
===================================================================
--- linux.orig/arch/x86/kernel/irq.c
+++ linux/arch/x86/kernel/irq.c
@@ -56,6 +56,10 @@ static int show_other_interrupts(struct 
 	for_each_online_cpu(j)
 		seq_printf(p, "%10u ", irq_stats(j)->apic_timer_irqs);
 	seq_printf(p, "  Local timer interrupts\n");
+	seq_printf(p, "CNT: ");
+	for_each_online_cpu(j)
+		seq_printf(p, "%10u ", irq_stats(j)->apic_perf_irqs);
+	seq_printf(p, "  Performance counter interrupts\n");
 #endif
 #ifdef CONFIG_SMP
 	seq_printf(p, "RES: ");
@@ -160,6 +164,7 @@ u64 arch_irq_stat_cpu(unsigned int cpu)
 
 #ifdef CONFIG_X86_LOCAL_APIC
 	sum += irq_stats(cpu)->apic_timer_irqs;
+	sum += irq_stats(cpu)->apic_perf_irqs;
 #endif
 #ifdef CONFIG_SMP
 	sum += irq_stats(cpu)->irq_resched_count;
Index: linux/arch/x86/kernel/irqinit_32.c
===================================================================
--- linux.orig/arch/x86/kernel/irqinit_32.c
+++ linux/arch/x86/kernel/irqinit_32.c
@@ -160,6 +160,9 @@ void __init native_init_IRQ(void)
 	/* IPI vectors for APIC spurious and error interrupts */
 	alloc_intr_gate(SPURIOUS_APIC_VECTOR, spurious_interrupt);
 	alloc_intr_gate(ERROR_APIC_VECTOR, error_interrupt);
+# ifdef CONFIG_PERF_COUNTERS
+	alloc_intr_gate(LOCAL_PERF_VECTOR, perf_counter_interrupt);
+# endif
 #endif
 
 #if defined(CONFIG_X86_LOCAL_APIC) && defined(CONFIG_X86_MCE_P4THERMAL)
Index: linux/arch/x86/kernel/irqinit_64.c
===================================================================
--- linux.orig/arch/x86/kernel/irqinit_64.c
+++ linux/arch/x86/kernel/irqinit_64.c
@@ -204,6 +204,11 @@ static void __init apic_intr_init(void)
 	/* IPI vectors for APIC spurious and error interrupts */
 	alloc_intr_gate(SPURIOUS_APIC_VECTOR, spurious_interrupt);
 	alloc_intr_gate(ERROR_APIC_VECTOR, error_interrupt);
+
+	/* Performance monitoring interrupt: */
+#ifdef CONFIG_PERF_COUNTERS
+	alloc_intr_gate(LOCAL_PERF_VECTOR, perf_counter_interrupt);
+#endif
 }
 
 void __init native_init_IRQ(void)
Index: linux/arch/x86/kernel/syscall_table_32.S
===================================================================
--- linux.orig/arch/x86/kernel/syscall_table_32.S
+++ linux/arch/x86/kernel/syscall_table_32.S
@@ -332,3 +332,4 @@ ENTRY(sys_call_table)
 	.long sys_dup3			/* 330 */
 	.long sys_pipe2
 	.long sys_inotify_init1
+	.long sys_perf_counter_open


