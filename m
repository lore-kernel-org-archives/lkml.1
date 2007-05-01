Return-Path: <linux-kernel-owner+w=401wt.eu-S1946244AbXEAEE7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946244AbXEAEE7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2007 00:04:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933465AbXEAEBR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 May 2007 00:01:17 -0400
Received: from mx2.suse.de ([195.135.220.15]:48936 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946244AbXEAD6C (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Apr 2007 23:58:02 -0400
From: Andi Kleen <ak@suse.de>
References: <20070501557.815359000@suse.de>
In-Reply-To: <20070501557.815359000@suse.de>
To: patches@x86-64.org, linux-kernel@vger.kernel.org
Subject: [PATCH] [3/30] i386: Clean up NMI watchdog code
Message-Id: <20070501035800.25D5D15146@wotan.suse.de>
Date: Tue,  1 May 2007 05:58:00 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


- Introduce a wd_ops structure
- Convert the various nmi watchdogs over to it
- This allows to split the perfctr reservation from the watchdog
setup cleanly.
- Do perfctr reservation globally as it should have always been
- Remove dead code referenced only by unused EXPORT_SYMBOLs

Signed-off-by: Andi Kleen <ak@suse.de>

---
 arch/i386/kernel/cpu/Makefile           |    2 
 arch/i386/kernel/cpu/perfctr-watchdog.c |  658 +++++++++++++++++++++++++
 arch/i386/kernel/nmi.c                  |  829 ++------------------------------
 include/asm-i386/nmi.h                  |    8 
 4 files changed, 721 insertions(+), 776 deletions(-)

Index: linux/arch/i386/kernel/nmi.c
===================================================================
--- linux.orig/arch/i386/kernel/nmi.c
+++ linux/arch/i386/kernel/nmi.c
@@ -20,7 +20,6 @@
 #include <linux/sysdev.h>
 #include <linux/sysctl.h>
 #include <linux/percpu.h>
-#include <linux/dmi.h>
 #include <linux/kprobes.h>
 #include <linux/cpumask.h>
 #include <linux/kernel_stat.h>
@@ -28,30 +27,14 @@
 #include <asm/smp.h>
 #include <asm/nmi.h>
 #include <asm/kdebug.h>
-#include <asm/intel_arch_perfmon.h>
 
 #include "mach_traps.h"
 
 int unknown_nmi_panic;
 int nmi_watchdog_enabled;
 
-/* perfctr_nmi_owner tracks the ownership of the perfctr registers:
- * evtsel_nmi_owner tracks the ownership of the event selection
- * - different performance counters/ event selection may be reserved for
- *   different subsystems this reservation system just tries to coordinate
- *   things a little
- */
-
-/* this number is calculated from Intel's MSR_P4_CRU_ESCR5 register and it's
- * offset from MSR_P4_BSU_ESCR0.  It will be the max for all platforms (for now)
- */
-#define NMI_MAX_COUNTER_BITS 66
-#define NMI_MAX_COUNTER_LONGS BITS_TO_LONGS(NMI_MAX_COUNTER_BITS)
-
-static DEFINE_PER_CPU(unsigned long, perfctr_nmi_owner[NMI_MAX_COUNTER_LONGS]);
-static DEFINE_PER_CPU(unsigned long, evntsel_nmi_owner[NMI_MAX_COUNTER_LONGS]);
-
 static cpumask_t backtrace_mask = CPU_MASK_NONE;
+
 /* nmi_active:
  * >0: the lapic NMI watchdog is active, but can be disabled
  * <0: the lapic NMI watchdog has not been set up, and cannot
@@ -63,203 +46,11 @@ atomic_t nmi_active = ATOMIC_INIT(0);		/
 unsigned int nmi_watchdog = NMI_DEFAULT;
 static unsigned int nmi_hz = HZ;
 
-struct nmi_watchdog_ctlblk {
-	int enabled;
-	u64 check_bit;
-	unsigned int cccr_msr;
-	unsigned int perfctr_msr;  /* the MSR to reset in NMI handler */
-	unsigned int evntsel_msr;  /* the MSR to select the events to handle */
-};
-static DEFINE_PER_CPU(struct nmi_watchdog_ctlblk, nmi_watchdog_ctlblk);
+static DEFINE_PER_CPU(short, wd_enabled);
 
 /* local prototypes */
 static int unknown_nmi_panic_callback(struct pt_regs *regs, int cpu);
 
-/* converts an msr to an appropriate reservation bit */
-static inline unsigned int nmi_perfctr_msr_to_bit(unsigned int msr)
-{
-	/* returns the bit offset of the performance counter register */
-	switch (boot_cpu_data.x86_vendor) {
-	case X86_VENDOR_AMD:
-		return (msr - MSR_K7_PERFCTR0);
-	case X86_VENDOR_INTEL:
-		if (cpu_has(&boot_cpu_data, X86_FEATURE_ARCH_PERFMON))
-			return (msr - MSR_ARCH_PERFMON_PERFCTR0);
-
-		switch (boot_cpu_data.x86) {
-		case 6:
-			return (msr - MSR_P6_PERFCTR0);
-		case 15:
-			return (msr - MSR_P4_BPU_PERFCTR0);
-		}
-	}
-	return 0;
-}
-
-/* converts an msr to an appropriate reservation bit */
-static inline unsigned int nmi_evntsel_msr_to_bit(unsigned int msr)
-{
-	/* returns the bit offset of the event selection register */
-	switch (boot_cpu_data.x86_vendor) {
-	case X86_VENDOR_AMD:
-		return (msr - MSR_K7_EVNTSEL0);
-	case X86_VENDOR_INTEL:
-		if (cpu_has(&boot_cpu_data, X86_FEATURE_ARCH_PERFMON))
-			return (msr - MSR_ARCH_PERFMON_EVENTSEL0);
-
-		switch (boot_cpu_data.x86) {
-		case 6:
-			return (msr - MSR_P6_EVNTSEL0);
-		case 15:
-			return (msr - MSR_P4_BSU_ESCR0);
-		}
-	}
-	return 0;
-}
-
-/* checks for a bit availability (hack for oprofile) */
-int avail_to_resrv_perfctr_nmi_bit(unsigned int counter)
-{
-	int cpu;
-	BUG_ON(counter > NMI_MAX_COUNTER_BITS);
-	for_each_possible_cpu (cpu) {
-		if (test_bit(counter, &per_cpu(perfctr_nmi_owner, cpu)[0]))
-			return 0;
-	}
-	return 1;
-}
-
-/* checks the an msr for availability */
-int avail_to_resrv_perfctr_nmi(unsigned int msr)
-{
-	unsigned int counter;
-	int cpu;
-
-	counter = nmi_perfctr_msr_to_bit(msr);
-	BUG_ON(counter > NMI_MAX_COUNTER_BITS);
-
-	for_each_possible_cpu (cpu) {
-		if (test_bit(counter, &per_cpu(perfctr_nmi_owner, cpu)[0]))
-			return 0;
-	}
-	return 1;
-}
-
-static int __reserve_perfctr_nmi(int cpu, unsigned int msr)
-{
-	unsigned int counter;
-	if (cpu < 0)
-		cpu = smp_processor_id();
-
-	counter = nmi_perfctr_msr_to_bit(msr);
-	BUG_ON(counter > NMI_MAX_COUNTER_BITS);
-
-	if (!test_and_set_bit(counter, &per_cpu(perfctr_nmi_owner, cpu)[0]))
-		return 1;
-	return 0;
-}
-
-static void __release_perfctr_nmi(int cpu, unsigned int msr)
-{
-	unsigned int counter;
-	if (cpu < 0)
-		cpu = smp_processor_id();
-
-	counter = nmi_perfctr_msr_to_bit(msr);
-	BUG_ON(counter > NMI_MAX_COUNTER_BITS);
-
-	clear_bit(counter, &per_cpu(perfctr_nmi_owner, cpu)[0]);
-}
-
-int reserve_perfctr_nmi(unsigned int msr)
-{
-	int cpu, i;
-	for_each_possible_cpu (cpu) {
-		if (!__reserve_perfctr_nmi(cpu, msr)) {
-			for_each_possible_cpu (i) {
-				if (i >= cpu)
-					break;
-				__release_perfctr_nmi(i, msr);
-			}
-			return 0;
-		}
-	}
-	return 1;
-}
-
-void release_perfctr_nmi(unsigned int msr)
-{
-	int cpu;
-	for_each_possible_cpu (cpu) {
-		__release_perfctr_nmi(cpu, msr);
-	}
-}
-
-int __reserve_evntsel_nmi(int cpu, unsigned int msr)
-{
-	unsigned int counter;
-	if (cpu < 0)
-		cpu = smp_processor_id();
-
-	counter = nmi_evntsel_msr_to_bit(msr);
-	BUG_ON(counter > NMI_MAX_COUNTER_BITS);
-
-	if (!test_and_set_bit(counter, &per_cpu(evntsel_nmi_owner, cpu)[0]))
-		return 1;
-	return 0;
-}
-
-static void __release_evntsel_nmi(int cpu, unsigned int msr)
-{
-	unsigned int counter;
-	if (cpu < 0)
-		cpu = smp_processor_id();
-
-	counter = nmi_evntsel_msr_to_bit(msr);
-	BUG_ON(counter > NMI_MAX_COUNTER_BITS);
-
-	clear_bit(counter, &per_cpu(evntsel_nmi_owner, cpu)[0]);
-}
-
-int reserve_evntsel_nmi(unsigned int msr)
-{
-	int cpu, i;
-	for_each_possible_cpu (cpu) {
-		if (!__reserve_evntsel_nmi(cpu, msr)) {
-			for_each_possible_cpu (i) {
-				if (i >= cpu)
-					break;
-				__release_evntsel_nmi(i, msr);
-			}
-			return 0;
-		}
-	}
-	return 1;
-}
-
-void release_evntsel_nmi(unsigned int msr)
-{
-	int cpu;
-	for_each_possible_cpu (cpu) {
-		__release_evntsel_nmi(cpu, msr);
-	}
-}
-
-static __cpuinit inline int nmi_known_cpu(void)
-{
-	switch (boot_cpu_data.x86_vendor) {
-	case X86_VENDOR_AMD:
-		return ((boot_cpu_data.x86 == 15) || (boot_cpu_data.x86 == 6)
-			|| (boot_cpu_data.x86 == 16));
-	case X86_VENDOR_INTEL:
-		if (cpu_has(&boot_cpu_data, X86_FEATURE_ARCH_PERFMON))
-			return 1;
-		else
-			return ((boot_cpu_data.x86 == 15) || (boot_cpu_data.x86 == 6));
-	}
-	return 0;
-}
-
 static int endflag __initdata = 0;
 
 #ifdef CONFIG_SMP
@@ -281,28 +72,6 @@ static __init void nmi_cpu_busy(void *da
 }
 #endif
 
-static unsigned int adjust_for_32bit_ctr(unsigned int hz)
-{
-	u64 counter_val;
-	unsigned int retval = hz;
-
-	/*
-	 * On Intel CPUs with P6/ARCH_PERFMON only 32 bits in the counter
-	 * are writable, with higher bits sign extending from bit 31.
-	 * So, we can only program the counter with 31 bit values and
-	 * 32nd bit should be 1, for 33.. to be 1.
-	 * Find the appropriate nmi_hz
-	 */
-	counter_val = (u64)cpu_khz * 1000;
-	do_div(counter_val, retval);
- 	if (counter_val > 0x7fffffffULL) {
-		u64 count = (u64)cpu_khz * 1000;
-		do_div(count, 0x7fffffffUL);
-		retval = count + 1;
-	}
-	return retval;
-}
-
 static int __init check_nmi_watchdog(void)
 {
 	unsigned int *prev_nmi_count;
@@ -335,14 +104,14 @@ static int __init check_nmi_watchdog(voi
 		if (!cpu_isset(cpu, cpu_callin_map))
 			continue;
 #endif
-		if (!per_cpu(nmi_watchdog_ctlblk, cpu).enabled)
+		if (!per_cpu(wd_enabled, cpu))
 			continue;
 		if (nmi_count(cpu) - prev_nmi_count[cpu] <= 5) {
 			printk("CPU#%d: NMI appears to be stuck (%d->%d)!\n",
 				cpu,
 				prev_nmi_count[cpu],
 				nmi_count(cpu));
-			per_cpu(nmi_watchdog_ctlblk, cpu).enabled = 0;
+			per_cpu(wd_enabled, cpu) = 0;
 			atomic_dec(&nmi_active);
 		}
 	}
@@ -356,16 +125,8 @@ static int __init check_nmi_watchdog(voi
 
 	/* now that we know it works we can reduce NMI frequency to
 	   something more reasonable; makes a difference in some configs */
-	if (nmi_watchdog == NMI_LOCAL_APIC) {
-		struct nmi_watchdog_ctlblk *wd = &__get_cpu_var(nmi_watchdog_ctlblk);
-
-		nmi_hz = 1;
-
-		if (wd->perfctr_msr == MSR_P6_PERFCTR0 ||
-		    wd->perfctr_msr == MSR_ARCH_PERFMON_PERFCTR1) {
-			nmi_hz = adjust_for_32bit_ctr(nmi_hz);
-		}
-	}
+	if (nmi_watchdog == NMI_LOCAL_APIC)
+		nmi_hz = lapic_adjust_nmi_hz(1);
 
 	kfree(prev_nmi_count);
 	return 0;
@@ -388,85 +149,8 @@ static int __init setup_nmi_watchdog(cha
 
 __setup("nmi_watchdog=", setup_nmi_watchdog);
 
-static void disable_lapic_nmi_watchdog(void)
-{
-	BUG_ON(nmi_watchdog != NMI_LOCAL_APIC);
-
-	if (atomic_read(&nmi_active) <= 0)
-		return;
-
-	on_each_cpu(stop_apic_nmi_watchdog, NULL, 0, 1);
-
-	BUG_ON(atomic_read(&nmi_active) != 0);
-}
-
-static void enable_lapic_nmi_watchdog(void)
-{
-	BUG_ON(nmi_watchdog != NMI_LOCAL_APIC);
-
-	/* are we already enabled */
-	if (atomic_read(&nmi_active) != 0)
-		return;
-
-	/* are we lapic aware */
-	if (nmi_known_cpu() <= 0)
-		return;
-
-	on_each_cpu(setup_apic_nmi_watchdog, NULL, 0, 1);
-	touch_nmi_watchdog();
-}
 
-void disable_timer_nmi_watchdog(void)
-{
-	BUG_ON(nmi_watchdog != NMI_IO_APIC);
-
-	if (atomic_read(&nmi_active) <= 0)
-		return;
-
-	disable_irq(0);
-	on_each_cpu(stop_apic_nmi_watchdog, NULL, 0, 1);
-
-	BUG_ON(atomic_read(&nmi_active) != 0);
-}
-
-void enable_timer_nmi_watchdog(void)
-{
-	BUG_ON(nmi_watchdog != NMI_IO_APIC);
-
-	if (atomic_read(&nmi_active) == 0) {
-		touch_nmi_watchdog();
-		on_each_cpu(setup_apic_nmi_watchdog, NULL, 0, 1);
-		enable_irq(0);
-	}
-}
-
-static void __acpi_nmi_disable(void *__unused)
-{
-	apic_write_around(APIC_LVT0, APIC_DM_NMI | APIC_LVT_MASKED);
-}
-
-/*
- * Disable timer based NMIs on all CPUs:
- */
-void acpi_nmi_disable(void)
-{
-	if (atomic_read(&nmi_active) && nmi_watchdog == NMI_IO_APIC)
-		on_each_cpu(__acpi_nmi_disable, NULL, 0, 1);
-}
-
-static void __acpi_nmi_enable(void *__unused)
-{
-	apic_write_around(APIC_LVT0, APIC_DM_NMI);
-}
-
-/*
- * Enable timer based NMIs on all CPUs:
- */
-void acpi_nmi_enable(void)
-{
-	if (atomic_read(&nmi_active) && nmi_watchdog == NMI_IO_APIC)
-		on_each_cpu(__acpi_nmi_enable, NULL, 0, 1);
-}
+/* Suspend/resume support */
 
 #ifdef CONFIG_PM
 
@@ -513,7 +197,7 @@ static int __init init_lapic_nmi_sysfs(v
 	if (nmi_watchdog != NMI_LOCAL_APIC)
 		return 0;
 
-	if ( atomic_read(&nmi_active) < 0 )
+	if (atomic_read(&nmi_active) < 0)
 		return 0;
 
 	error = sysdev_class_register(&nmi_sysclass);
@@ -526,433 +210,69 @@ late_initcall(init_lapic_nmi_sysfs);
 
 #endif	/* CONFIG_PM */
 
-/*
- * Activate the NMI watchdog via the local APIC.
- * Original code written by Keith Owens.
- */
-
-static void write_watchdog_counter(unsigned int perfctr_msr, const char *descr)
-{
-	u64 count = (u64)cpu_khz * 1000;
-
-	do_div(count, nmi_hz);
-	if(descr)
-		Dprintk("setting %s to -0x%08Lx\n", descr, count);
-	wrmsrl(perfctr_msr, 0 - count);
-}
-
-static void write_watchdog_counter32(unsigned int perfctr_msr,
-		const char *descr)
-{
-	u64 count = (u64)cpu_khz * 1000;
-
-	do_div(count, nmi_hz);
-	if(descr)
-		Dprintk("setting %s to -0x%08Lx\n", descr, count);
-	wrmsr(perfctr_msr, (u32)(-count), 0);
-}
-
-/* Note that these events don't tick when the CPU idles. This means
-   the frequency varies with CPU load. */
-
-#define K7_EVNTSEL_ENABLE	(1 << 22)
-#define K7_EVNTSEL_INT		(1 << 20)
-#define K7_EVNTSEL_OS		(1 << 17)
-#define K7_EVNTSEL_USR		(1 << 16)
-#define K7_EVENT_CYCLES_PROCESSOR_IS_RUNNING	0x76
-#define K7_NMI_EVENT		K7_EVENT_CYCLES_PROCESSOR_IS_RUNNING
-
-static int setup_k7_watchdog(void)
-{
-	unsigned int perfctr_msr, evntsel_msr;
-	unsigned int evntsel;
-	struct nmi_watchdog_ctlblk *wd = &__get_cpu_var(nmi_watchdog_ctlblk);
-
-	perfctr_msr = MSR_K7_PERFCTR0;
-	evntsel_msr = MSR_K7_EVNTSEL0;
-	if (!__reserve_perfctr_nmi(-1, perfctr_msr))
-		goto fail;
-
-	if (!__reserve_evntsel_nmi(-1, evntsel_msr))
-		goto fail1;
-
-	wrmsrl(perfctr_msr, 0UL);
-
-	evntsel = K7_EVNTSEL_INT
-		| K7_EVNTSEL_OS
-		| K7_EVNTSEL_USR
-		| K7_NMI_EVENT;
-
-	/* setup the timer */
-	wrmsr(evntsel_msr, evntsel, 0);
-	write_watchdog_counter(perfctr_msr, "K7_PERFCTR0");
-	apic_write(APIC_LVTPC, APIC_DM_NMI);
-	evntsel |= K7_EVNTSEL_ENABLE;
-	wrmsr(evntsel_msr, evntsel, 0);
-
-	wd->perfctr_msr = perfctr_msr;
-	wd->evntsel_msr = evntsel_msr;
-	wd->cccr_msr = 0;  //unused
-	wd->check_bit = 1ULL<<63;
-	return 1;
-fail1:
-	__release_perfctr_nmi(-1, perfctr_msr);
-fail:
-	return 0;
-}
-
-static void stop_k7_watchdog(void)
-{
-	struct nmi_watchdog_ctlblk *wd = &__get_cpu_var(nmi_watchdog_ctlblk);
-
-	wrmsr(wd->evntsel_msr, 0, 0);
-
-	__release_evntsel_nmi(-1, wd->evntsel_msr);
-	__release_perfctr_nmi(-1, wd->perfctr_msr);
-}
-
-#define P6_EVNTSEL0_ENABLE	(1 << 22)
-#define P6_EVNTSEL_INT		(1 << 20)
-#define P6_EVNTSEL_OS		(1 << 17)
-#define P6_EVNTSEL_USR		(1 << 16)
-#define P6_EVENT_CPU_CLOCKS_NOT_HALTED	0x79
-#define P6_NMI_EVENT		P6_EVENT_CPU_CLOCKS_NOT_HALTED
-
-static int setup_p6_watchdog(void)
-{
-	unsigned int perfctr_msr, evntsel_msr;
-	unsigned int evntsel;
-	struct nmi_watchdog_ctlblk *wd = &__get_cpu_var(nmi_watchdog_ctlblk);
-
-	perfctr_msr = MSR_P6_PERFCTR0;
-	evntsel_msr = MSR_P6_EVNTSEL0;
-	if (!__reserve_perfctr_nmi(-1, perfctr_msr))
-		goto fail;
-
-	if (!__reserve_evntsel_nmi(-1, evntsel_msr))
-		goto fail1;
-
-	wrmsrl(perfctr_msr, 0UL);
-
-	evntsel = P6_EVNTSEL_INT
-		| P6_EVNTSEL_OS
-		| P6_EVNTSEL_USR
-		| P6_NMI_EVENT;
-
-	/* setup the timer */
-	wrmsr(evntsel_msr, evntsel, 0);
-	nmi_hz = adjust_for_32bit_ctr(nmi_hz);
-	write_watchdog_counter32(perfctr_msr, "P6_PERFCTR0");
-	apic_write(APIC_LVTPC, APIC_DM_NMI);
-	evntsel |= P6_EVNTSEL0_ENABLE;
-	wrmsr(evntsel_msr, evntsel, 0);
-
-	wd->perfctr_msr = perfctr_msr;
-	wd->evntsel_msr = evntsel_msr;
-	wd->cccr_msr = 0;  //unused
-	wd->check_bit = 1ULL<<39;
-	return 1;
-fail1:
-	__release_perfctr_nmi(-1, perfctr_msr);
-fail:
-	return 0;
-}
-
-static void stop_p6_watchdog(void)
-{
-	struct nmi_watchdog_ctlblk *wd = &__get_cpu_var(nmi_watchdog_ctlblk);
-
-	wrmsr(wd->evntsel_msr, 0, 0);
-
-	__release_evntsel_nmi(-1, wd->evntsel_msr);
-	__release_perfctr_nmi(-1, wd->perfctr_msr);
-}
-
-/* Note that these events don't tick when the CPU idles. This means
-   the frequency varies with CPU load. */
-
-#define MSR_P4_MISC_ENABLE_PERF_AVAIL	(1<<7)
-#define P4_ESCR_EVENT_SELECT(N)	((N)<<25)
-#define P4_ESCR_OS		(1<<3)
-#define P4_ESCR_USR		(1<<2)
-#define P4_CCCR_OVF_PMI0	(1<<26)
-#define P4_CCCR_OVF_PMI1	(1<<27)
-#define P4_CCCR_THRESHOLD(N)	((N)<<20)
-#define P4_CCCR_COMPLEMENT	(1<<19)
-#define P4_CCCR_COMPARE		(1<<18)
-#define P4_CCCR_REQUIRED	(3<<16)
-#define P4_CCCR_ESCR_SELECT(N)	((N)<<13)
-#define P4_CCCR_ENABLE		(1<<12)
-#define P4_CCCR_OVF 		(1<<31)
-/* Set up IQ_COUNTER0 to behave like a clock, by having IQ_CCCR0 filter
-   CRU_ESCR0 (with any non-null event selector) through a complemented
-   max threshold. [IA32-Vol3, Section 14.9.9] */
-
-static int setup_p4_watchdog(void)
+static void __acpi_nmi_enable(void *__unused)
 {
-	unsigned int perfctr_msr, evntsel_msr, cccr_msr;
-	unsigned int evntsel, cccr_val;
-	unsigned int misc_enable, dummy;
-	unsigned int ht_num;
-	struct nmi_watchdog_ctlblk *wd = &__get_cpu_var(nmi_watchdog_ctlblk);
-
-	rdmsr(MSR_IA32_MISC_ENABLE, misc_enable, dummy);
-	if (!(misc_enable & MSR_P4_MISC_ENABLE_PERF_AVAIL))
-		return 0;
-
-#ifdef CONFIG_SMP
-	/* detect which hyperthread we are on */
-	if (smp_num_siblings == 2) {
-		unsigned int ebx, apicid;
-
-        	ebx = cpuid_ebx(1);
-	        apicid = (ebx >> 24) & 0xff;
-        	ht_num = apicid & 1;
-	} else
-#endif
-		ht_num = 0;
-
-	/* performance counters are shared resources
-	 * assign each hyperthread its own set
-	 * (re-use the ESCR0 register, seems safe
-	 * and keeps the cccr_val the same)
-	 */
-	if (!ht_num) {
-		/* logical cpu 0 */
-		perfctr_msr = MSR_P4_IQ_PERFCTR0;
-		evntsel_msr = MSR_P4_CRU_ESCR0;
-		cccr_msr = MSR_P4_IQ_CCCR0;
-		cccr_val = P4_CCCR_OVF_PMI0 | P4_CCCR_ESCR_SELECT(4);
-	} else {
-		/* logical cpu 1 */
-		perfctr_msr = MSR_P4_IQ_PERFCTR1;
-		evntsel_msr = MSR_P4_CRU_ESCR0;
-		cccr_msr = MSR_P4_IQ_CCCR1;
-		cccr_val = P4_CCCR_OVF_PMI1 | P4_CCCR_ESCR_SELECT(4);
-	}
-
-	if (!__reserve_perfctr_nmi(-1, perfctr_msr))
-		goto fail;
-
-	if (!__reserve_evntsel_nmi(-1, evntsel_msr))
-		goto fail1;
-
-	evntsel = P4_ESCR_EVENT_SELECT(0x3F)
-	 	| P4_ESCR_OS
-		| P4_ESCR_USR;
-
-	cccr_val |= P4_CCCR_THRESHOLD(15)
-		 | P4_CCCR_COMPLEMENT
-		 | P4_CCCR_COMPARE
-		 | P4_CCCR_REQUIRED;
-
-	wrmsr(evntsel_msr, evntsel, 0);
-	wrmsr(cccr_msr, cccr_val, 0);
-	write_watchdog_counter(perfctr_msr, "P4_IQ_COUNTER0");
-	apic_write(APIC_LVTPC, APIC_DM_NMI);
-	cccr_val |= P4_CCCR_ENABLE;
-	wrmsr(cccr_msr, cccr_val, 0);
-	wd->perfctr_msr = perfctr_msr;
-	wd->evntsel_msr = evntsel_msr;
-	wd->cccr_msr = cccr_msr;
-	wd->check_bit = 1ULL<<39;
-	return 1;
-fail1:
-	__release_perfctr_nmi(-1, perfctr_msr);
-fail:
-	return 0;
+	apic_write_around(APIC_LVT0, APIC_DM_NMI);
 }
 
-static void stop_p4_watchdog(void)
+/*
+ * Enable timer based NMIs on all CPUs:
+ */
+void acpi_nmi_enable(void)
 {
-	struct nmi_watchdog_ctlblk *wd = &__get_cpu_var(nmi_watchdog_ctlblk);
-
-	wrmsr(wd->cccr_msr, 0, 0);
-	wrmsr(wd->evntsel_msr, 0, 0);
-
-	__release_evntsel_nmi(-1, wd->evntsel_msr);
-	__release_perfctr_nmi(-1, wd->perfctr_msr);
+	if (atomic_read(&nmi_active) && nmi_watchdog == NMI_IO_APIC)
+		on_each_cpu(__acpi_nmi_enable, NULL, 0, 1);
 }
 
-#define ARCH_PERFMON_NMI_EVENT_SEL	ARCH_PERFMON_UNHALTED_CORE_CYCLES_SEL
-#define ARCH_PERFMON_NMI_EVENT_UMASK	ARCH_PERFMON_UNHALTED_CORE_CYCLES_UMASK
-
-static int setup_intel_arch_watchdog(void)
+static void __acpi_nmi_disable(void *__unused)
 {
-	unsigned int ebx;
-	union cpuid10_eax eax;
-	unsigned int unused;
-	unsigned int perfctr_msr, evntsel_msr;
-	unsigned int evntsel;
-	struct nmi_watchdog_ctlblk *wd = &__get_cpu_var(nmi_watchdog_ctlblk);
-
-	/*
-	 * Check whether the Architectural PerfMon supports
-	 * Unhalted Core Cycles Event or not.
-	 * NOTE: Corresponding bit = 0 in ebx indicates event present.
-	 */
-	cpuid(10, &(eax.full), &ebx, &unused, &unused);
-	if ((eax.split.mask_length < (ARCH_PERFMON_UNHALTED_CORE_CYCLES_INDEX+1)) ||
-	    (ebx & ARCH_PERFMON_UNHALTED_CORE_CYCLES_PRESENT))
-		goto fail;
-
-	perfctr_msr = MSR_ARCH_PERFMON_PERFCTR1;
-	evntsel_msr = MSR_ARCH_PERFMON_EVENTSEL1;
-
-	if (!__reserve_perfctr_nmi(-1, perfctr_msr))
-		goto fail;
-
-	if (!__reserve_evntsel_nmi(-1, evntsel_msr))
-		goto fail1;
-
-	wrmsrl(perfctr_msr, 0UL);
-
-	evntsel = ARCH_PERFMON_EVENTSEL_INT
-		| ARCH_PERFMON_EVENTSEL_OS
-		| ARCH_PERFMON_EVENTSEL_USR
-		| ARCH_PERFMON_NMI_EVENT_SEL
-		| ARCH_PERFMON_NMI_EVENT_UMASK;
-
-	/* setup the timer */
-	wrmsr(evntsel_msr, evntsel, 0);
-	nmi_hz = adjust_for_32bit_ctr(nmi_hz);
-	write_watchdog_counter32(perfctr_msr, "INTEL_ARCH_PERFCTR0");
-	apic_write(APIC_LVTPC, APIC_DM_NMI);
-	evntsel |= ARCH_PERFMON_EVENTSEL0_ENABLE;
-	wrmsr(evntsel_msr, evntsel, 0);
-
-	wd->perfctr_msr = perfctr_msr;
-	wd->evntsel_msr = evntsel_msr;
-	wd->cccr_msr = 0;  //unused
-	wd->check_bit = 1ULL << (eax.split.bit_width - 1);
-	return 1;
-fail1:
-	__release_perfctr_nmi(-1, perfctr_msr);
-fail:
-	return 0;
+	apic_write(APIC_LVT0, APIC_DM_NMI | APIC_LVT_MASKED);
 }
 
-static void stop_intel_arch_watchdog(void)
+/*
+ * Disable timer based NMIs on all CPUs:
+ */
+void acpi_nmi_disable(void)
 {
-	unsigned int ebx;
-	union cpuid10_eax eax;
-	unsigned int unused;
-	struct nmi_watchdog_ctlblk *wd = &__get_cpu_var(nmi_watchdog_ctlblk);
-
-	/*
-	 * Check whether the Architectural PerfMon supports
-	 * Unhalted Core Cycles Event or not.
-	 * NOTE: Corresponding bit = 0 in ebx indicates event present.
-	 */
-	cpuid(10, &(eax.full), &ebx, &unused, &unused);
-	if ((eax.split.mask_length < (ARCH_PERFMON_UNHALTED_CORE_CYCLES_INDEX+1)) ||
-	    (ebx & ARCH_PERFMON_UNHALTED_CORE_CYCLES_PRESENT))
-		return;
-
-	wrmsr(wd->evntsel_msr, 0, 0);
-	__release_evntsel_nmi(-1, wd->evntsel_msr);
-	__release_perfctr_nmi(-1, wd->perfctr_msr);
+	if (atomic_read(&nmi_active) && nmi_watchdog == NMI_IO_APIC)
+		on_each_cpu(__acpi_nmi_disable, NULL, 0, 1);
 }
 
 void setup_apic_nmi_watchdog (void *unused)
 {
-	struct nmi_watchdog_ctlblk *wd = &__get_cpu_var(nmi_watchdog_ctlblk);
-
-	/* only support LOCAL and IO APICs for now */
-	if ((nmi_watchdog != NMI_LOCAL_APIC) &&
-	    (nmi_watchdog != NMI_IO_APIC))
-	    	return;
-
-	if (wd->enabled == 1)
-		return;
+	if (__get_cpu_var(wd_enabled))
+ 		return;
 
 	/* cheap hack to support suspend/resume */
 	/* if cpu0 is not active neither should the other cpus */
 	if ((smp_processor_id() != 0) && (atomic_read(&nmi_active) <= 0))
 		return;
 
-	if (nmi_watchdog == NMI_LOCAL_APIC) {
-		switch (boot_cpu_data.x86_vendor) {
-		case X86_VENDOR_AMD:
-			if (boot_cpu_data.x86 != 6 && boot_cpu_data.x86 != 15 &&
-				boot_cpu_data.x86 != 16)
-				return;
-			if (!setup_k7_watchdog())
-				return;
-			break;
-		case X86_VENDOR_INTEL:
-			if (cpu_has(&boot_cpu_data, X86_FEATURE_ARCH_PERFMON)) {
-				if (!setup_intel_arch_watchdog())
-					return;
-				break;
-			}
-			switch (boot_cpu_data.x86) {
-			case 6:
-				if (boot_cpu_data.x86_model > 0xd)
-					return;
-
-				if (!setup_p6_watchdog())
-					return;
-				break;
-			case 15:
-				if (boot_cpu_data.x86_model > 0x4)
-					return;
-
-				if (!setup_p4_watchdog())
-					return;
-				break;
-			default:
-				return;
-			}
-			break;
-		default:
+	switch (nmi_watchdog) {
+	case NMI_LOCAL_APIC:
+		__get_cpu_var(wd_enabled) = 1; /* enable it before to avoid race with handler */
+		if (lapic_watchdog_init(nmi_hz) < 0) {
+			__get_cpu_var(wd_enabled) = 0;
 			return;
 		}
+		/* FALL THROUGH */
+	case NMI_IO_APIC:
+		__get_cpu_var(wd_enabled) = 1;
+		atomic_inc(&nmi_active);
 	}
-	wd->enabled = 1;
-	atomic_inc(&nmi_active);
 }
 
 void stop_apic_nmi_watchdog(void *unused)
 {
-	struct nmi_watchdog_ctlblk *wd = &__get_cpu_var(nmi_watchdog_ctlblk);
-
 	/* only support LOCAL and IO APICs for now */
 	if ((nmi_watchdog != NMI_LOCAL_APIC) &&
 	    (nmi_watchdog != NMI_IO_APIC))
 	    	return;
-
-	if (wd->enabled == 0)
+	if (__get_cpu_var(wd_enabled) == 0)
 		return;
-
-	if (nmi_watchdog == NMI_LOCAL_APIC) {
-		switch (boot_cpu_data.x86_vendor) {
-		case X86_VENDOR_AMD:
-			stop_k7_watchdog();
-			break;
-		case X86_VENDOR_INTEL:
-			if (cpu_has(&boot_cpu_data, X86_FEATURE_ARCH_PERFMON)) {
-				stop_intel_arch_watchdog();
-				break;
-			}
-			switch (boot_cpu_data.x86) {
-			case 6:
-				if (boot_cpu_data.x86_model > 0xd)
-					break;
-				stop_p6_watchdog();
-				break;
-			case 15:
-				if (boot_cpu_data.x86_model > 0x4)
-					break;
-				stop_p4_watchdog();
-				break;
-			}
-			break;
-		default:
-			return;
-		}
-	}
-	wd->enabled = 0;
+	if (nmi_watchdog == NMI_LOCAL_APIC)
+		lapic_watchdog_stop();
+	__get_cpu_var(wd_enabled) = 0;
 	atomic_dec(&nmi_active);
 }
 
@@ -1008,8 +328,6 @@ __kprobes int nmi_watchdog_tick(struct p
 	unsigned int sum;
 	int touched = 0;
 	int cpu = smp_processor_id();
-	struct nmi_watchdog_ctlblk *wd = &__get_cpu_var(nmi_watchdog_ctlblk);
-	u64 dummy;
 	int rc=0;
 
 	/* check for other users first */
@@ -1052,53 +370,20 @@ __kprobes int nmi_watchdog_tick(struct p
 		alert_counter[cpu] = 0;
 	}
 	/* see if the nmi watchdog went off */
-	if (wd->enabled) {
-		if (nmi_watchdog == NMI_LOCAL_APIC) {
-			rdmsrl(wd->perfctr_msr, dummy);
-			if (dummy & wd->check_bit){
-				/* this wasn't a watchdog timer interrupt */
-				goto done;
-			}
-
-			/* only Intel P4 uses the cccr msr */
-	 		if (wd->cccr_msr != 0) {
-	 			/*
-	 			 * P4 quirks:
-	 			 * - An overflown perfctr will assert its interrupt
-	 			 *   until the OVF flag in its CCCR is cleared.
-	 			 * - LVTPC is masked on interrupt and must be
-	 			 *   unmasked by the LVTPC handler.
-	 			 */
-				rdmsrl(wd->cccr_msr, dummy);
-				dummy &= ~P4_CCCR_OVF;
-	 			wrmsrl(wd->cccr_msr, dummy);
-	 			apic_write(APIC_LVTPC, APIC_DM_NMI);
-				/* start the cycle over again */
-				write_watchdog_counter(wd->perfctr_msr, NULL);
-	 		}
-			else if (wd->perfctr_msr == MSR_P6_PERFCTR0 ||
-				 wd->perfctr_msr == MSR_ARCH_PERFMON_PERFCTR1) {
-				/* P6 based Pentium M need to re-unmask
-				 * the apic vector but it doesn't hurt
-				 * other P6 variant.
-				 * ArchPerfom/Core Duo also needs this */
-				apic_write(APIC_LVTPC, APIC_DM_NMI);
-				/* P6/ARCH_PERFMON has 32 bit counter write */
-				write_watchdog_counter32(wd->perfctr_msr, NULL);
-			} else {
-				/* start the cycle over again */
-				write_watchdog_counter(wd->perfctr_msr, NULL);
-			}
-			rc = 1;
-		} else if (nmi_watchdog == NMI_IO_APIC) {
-			/* don't know how to accurately check for this.
-			 * just assume it was a watchdog timer interrupt
-			 * This matches the old behaviour.
-			 */
-			rc = 1;
-		}
+	if (!__get_cpu_var(wd_enabled))
+		return rc;
+	switch (nmi_watchdog) {
+	case NMI_LOCAL_APIC:
+		rc |= lapic_wd_event(nmi_hz);
+		break;
+	case NMI_IO_APIC:
+		/* don't know how to accurately check for this.
+		 * just assume it was a watchdog timer interrupt
+		 * This matches the old behaviour.
+		 */
+		rc = 1;
+		break;
 	}
-done:
 	return rc;
 }
 
@@ -1143,7 +428,7 @@ int proc_nmi_enabled(struct ctl_table *t
 	}
 
 	if (nmi_watchdog == NMI_DEFAULT) {
-		if (nmi_known_cpu() > 0)
+		if (lapic_watchdog_ok())
 			nmi_watchdog = NMI_LOCAL_APIC;
 		else
 			nmi_watchdog = NMI_IO_APIC;
@@ -1179,11 +464,3 @@ void __trigger_all_cpu_backtrace(void)
 
 EXPORT_SYMBOL(nmi_active);
 EXPORT_SYMBOL(nmi_watchdog);
-EXPORT_SYMBOL(avail_to_resrv_perfctr_nmi);
-EXPORT_SYMBOL(avail_to_resrv_perfctr_nmi_bit);
-EXPORT_SYMBOL(reserve_perfctr_nmi);
-EXPORT_SYMBOL(release_perfctr_nmi);
-EXPORT_SYMBOL(reserve_evntsel_nmi);
-EXPORT_SYMBOL(release_evntsel_nmi);
-EXPORT_SYMBOL(disable_timer_nmi_watchdog);
-EXPORT_SYMBOL(enable_timer_nmi_watchdog);
Index: linux/arch/i386/kernel/cpu/Makefile
===================================================================
--- linux.orig/arch/i386/kernel/cpu/Makefile
+++ linux/arch/i386/kernel/cpu/Makefile
@@ -17,3 +17,5 @@ obj-$(CONFIG_X86_MCE)	+=	mcheck/
 
 obj-$(CONFIG_MTRR)	+= 	mtrr/
 obj-$(CONFIG_CPU_FREQ)	+=	cpufreq/
+
+obj-$(CONFIG_X86_LOCAL_APIC) += perfctr-watchdog.o
Index: linux/arch/i386/kernel/cpu/perfctr-watchdog.c
===================================================================
--- /dev/null
+++ linux/arch/i386/kernel/cpu/perfctr-watchdog.c
@@ -0,0 +1,658 @@
+/* local apic based NMI watchdog for various CPUs.
+   This file also handles reservation of performance counters for coordination
+   with other users (like oprofile).
+
+   Note that these events normally don't tick when the CPU idles. This means
+   the frequency varies with CPU load.
+
+   Original code for K7/P6 written by Keith Owens */
+
+#include <linux/percpu.h>
+#include <linux/module.h>
+#include <linux/kernel.h>
+#include <linux/bitops.h>
+#include <linux/smp.h>
+#include <linux/nmi.h>
+#include <asm/apic.h>
+#include <asm/intel_arch_perfmon.h>
+
+struct nmi_watchdog_ctlblk {
+	unsigned int cccr_msr;
+	unsigned int perfctr_msr;  /* the MSR to reset in NMI handler */
+	unsigned int evntsel_msr;  /* the MSR to select the events to handle */
+};
+
+/* Interface defining a CPU specific perfctr watchdog */
+struct wd_ops {
+	int (*reserve)(void);
+	void (*unreserve)(void);
+	int (*setup)(unsigned nmi_hz);
+	void (*rearm)(struct nmi_watchdog_ctlblk *wd, unsigned nmi_hz);
+	void (*stop)(void *);
+	unsigned perfctr;
+	unsigned evntsel;
+	u64 checkbit;
+};
+
+static struct wd_ops *wd_ops;
+
+/* this number is calculated from Intel's MSR_P4_CRU_ESCR5 register and it's
+ * offset from MSR_P4_BSU_ESCR0.  It will be the max for all platforms (for now)
+ */
+#define NMI_MAX_COUNTER_BITS 66
+
+/* perfctr_nmi_owner tracks the ownership of the perfctr registers:
+ * evtsel_nmi_owner tracks the ownership of the event selection
+ * - different performance counters/ event selection may be reserved for
+ *   different subsystems this reservation system just tries to coordinate
+ *   things a little
+ */
+static DECLARE_BITMAP(perfctr_nmi_owner, NMI_MAX_COUNTER_BITS);
+static DECLARE_BITMAP(evntsel_nmi_owner, NMI_MAX_COUNTER_BITS);
+
+static DEFINE_PER_CPU(struct nmi_watchdog_ctlblk, nmi_watchdog_ctlblk);
+
+/* converts an msr to an appropriate reservation bit */
+static inline unsigned int nmi_perfctr_msr_to_bit(unsigned int msr)
+{
+	return wd_ops ? msr - wd_ops->perfctr : 0;
+}
+
+/* converts an msr to an appropriate reservation bit */
+/* returns the bit offset of the event selection register */
+static inline unsigned int nmi_evntsel_msr_to_bit(unsigned int msr)
+{
+	return wd_ops ? msr - wd_ops->evntsel : 0;
+}
+
+/* checks for a bit availability (hack for oprofile) */
+int avail_to_resrv_perfctr_nmi_bit(unsigned int counter)
+{
+	BUG_ON(counter > NMI_MAX_COUNTER_BITS);
+
+	return (!test_bit(counter, perfctr_nmi_owner));
+}
+
+/* checks the an msr for availability */
+int avail_to_resrv_perfctr_nmi(unsigned int msr)
+{
+	unsigned int counter;
+
+	counter = nmi_perfctr_msr_to_bit(msr);
+	BUG_ON(counter > NMI_MAX_COUNTER_BITS);
+
+	return (!test_bit(counter, perfctr_nmi_owner));
+}
+
+int reserve_perfctr_nmi(unsigned int msr)
+{
+	unsigned int counter;
+
+	counter = nmi_perfctr_msr_to_bit(msr);
+	BUG_ON(counter > NMI_MAX_COUNTER_BITS);
+
+	if (!test_and_set_bit(counter, perfctr_nmi_owner))
+		return 1;
+	return 0;
+}
+
+void release_perfctr_nmi(unsigned int msr)
+{
+	unsigned int counter;
+
+	counter = nmi_perfctr_msr_to_bit(msr);
+	BUG_ON(counter > NMI_MAX_COUNTER_BITS);
+
+	clear_bit(counter, perfctr_nmi_owner);
+}
+
+int reserve_evntsel_nmi(unsigned int msr)
+{
+	unsigned int counter;
+
+	counter = nmi_evntsel_msr_to_bit(msr);
+	BUG_ON(counter > NMI_MAX_COUNTER_BITS);
+
+	if (!test_and_set_bit(counter, evntsel_nmi_owner))
+		return 1;
+	return 0;
+}
+
+void release_evntsel_nmi(unsigned int msr)
+{
+	unsigned int counter;
+
+	counter = nmi_evntsel_msr_to_bit(msr);
+	BUG_ON(counter > NMI_MAX_COUNTER_BITS);
+
+	clear_bit(counter, evntsel_nmi_owner);
+}
+
+EXPORT_SYMBOL(avail_to_resrv_perfctr_nmi);
+EXPORT_SYMBOL(avail_to_resrv_perfctr_nmi_bit);
+EXPORT_SYMBOL(reserve_perfctr_nmi);
+EXPORT_SYMBOL(release_perfctr_nmi);
+EXPORT_SYMBOL(reserve_evntsel_nmi);
+EXPORT_SYMBOL(release_evntsel_nmi);
+
+void disable_lapic_nmi_watchdog(void)
+{
+	BUG_ON(nmi_watchdog != NMI_LOCAL_APIC);
+
+	if (atomic_read(&nmi_active) <= 0)
+		return;
+
+	on_each_cpu(wd_ops->stop, NULL, 0, 1);
+	wd_ops->unreserve();
+
+	BUG_ON(atomic_read(&nmi_active) != 0);
+}
+
+void enable_lapic_nmi_watchdog(void)
+{
+	BUG_ON(nmi_watchdog != NMI_LOCAL_APIC);
+
+	/* are we already enabled */
+	if (atomic_read(&nmi_active) != 0)
+		return;
+
+	/* are we lapic aware */
+	if (!wd_ops)
+		return;
+	if (!wd_ops->reserve()) {
+		printk(KERN_ERR "NMI watchdog: cannot reserve perfctrs\n");
+		return;
+	}
+
+	on_each_cpu(setup_apic_nmi_watchdog, NULL, 0, 1);
+	touch_nmi_watchdog();
+}
+
+/*
+ * Activate the NMI watchdog via the local APIC.
+ */
+
+static unsigned int adjust_for_32bit_ctr(unsigned int hz)
+{
+	u64 counter_val;
+	unsigned int retval = hz;
+
+	/*
+	 * On Intel CPUs with P6/ARCH_PERFMON only 32 bits in the counter
+	 * are writable, with higher bits sign extending from bit 31.
+	 * So, we can only program the counter with 31 bit values and
+	 * 32nd bit should be 1, for 33.. to be 1.
+	 * Find the appropriate nmi_hz
+	 */
+	counter_val = (u64)cpu_khz * 1000;
+	do_div(counter_val, retval);
+ 	if (counter_val > 0x7fffffffULL) {
+		u64 count = (u64)cpu_khz * 1000;
+		do_div(count, 0x7fffffffUL);
+		retval = count + 1;
+	}
+	return retval;
+}
+
+static void
+write_watchdog_counter(unsigned int perfctr_msr, const char *descr, unsigned nmi_hz)
+{
+	u64 count = (u64)cpu_khz * 1000;
+
+	do_div(count, nmi_hz);
+	if(descr)
+		Dprintk("setting %s to -0x%08Lx\n", descr, count);
+	wrmsrl(perfctr_msr, 0 - count);
+}
+
+static void write_watchdog_counter32(unsigned int perfctr_msr,
+		const char *descr, unsigned nmi_hz)
+{
+	u64 count = (u64)cpu_khz * 1000;
+
+	do_div(count, nmi_hz);
+	if(descr)
+		Dprintk("setting %s to -0x%08Lx\n", descr, count);
+	wrmsr(perfctr_msr, (u32)(-count), 0);
+}
+
+/* AMD K7/K8/Family10h/Family11h support. AMD keeps this interface
+   nicely stable so there is not much variety */
+
+#define K7_EVNTSEL_ENABLE	(1 << 22)
+#define K7_EVNTSEL_INT		(1 << 20)
+#define K7_EVNTSEL_OS		(1 << 17)
+#define K7_EVNTSEL_USR		(1 << 16)
+#define K7_EVENT_CYCLES_PROCESSOR_IS_RUNNING	0x76
+#define K7_NMI_EVENT		K7_EVENT_CYCLES_PROCESSOR_IS_RUNNING
+
+static int setup_k7_watchdog(unsigned nmi_hz)
+{
+	unsigned int perfctr_msr, evntsel_msr;
+	unsigned int evntsel;
+	struct nmi_watchdog_ctlblk *wd = &__get_cpu_var(nmi_watchdog_ctlblk);
+
+	perfctr_msr = MSR_K7_PERFCTR0;
+	evntsel_msr = MSR_K7_EVNTSEL0;
+
+	wrmsrl(perfctr_msr, 0UL);
+
+	evntsel = K7_EVNTSEL_INT
+		| K7_EVNTSEL_OS
+		| K7_EVNTSEL_USR
+		| K7_NMI_EVENT;
+
+	/* setup the timer */
+	wrmsr(evntsel_msr, evntsel, 0);
+	write_watchdog_counter(perfctr_msr, "K7_PERFCTR0",nmi_hz);
+	apic_write(APIC_LVTPC, APIC_DM_NMI);
+	evntsel |= K7_EVNTSEL_ENABLE;
+	wrmsr(evntsel_msr, evntsel, 0);
+
+	wd->perfctr_msr = perfctr_msr;
+	wd->evntsel_msr = evntsel_msr;
+	wd->cccr_msr = 0;  //unused
+	return 1;
+}
+
+static void single_msr_stop_watchdog(void *arg)
+{
+	struct nmi_watchdog_ctlblk *wd = &__get_cpu_var(nmi_watchdog_ctlblk);
+
+	wrmsr(wd->evntsel_msr, 0, 0);
+}
+
+static int single_msr_reserve(void)
+{
+	if (!reserve_perfctr_nmi(wd_ops->perfctr))
+		return 0;
+
+	if (!reserve_evntsel_nmi(wd_ops->evntsel)) {
+		release_perfctr_nmi(wd_ops->perfctr);
+		return 0;
+	}
+	return 1;
+}
+
+static void single_msr_unreserve(void)
+{
+	release_evntsel_nmi(wd_ops->perfctr);
+	release_perfctr_nmi(wd_ops->evntsel);
+}
+
+static void single_msr_rearm(struct nmi_watchdog_ctlblk *wd, unsigned nmi_hz)
+{
+	/* start the cycle over again */
+	write_watchdog_counter(wd->perfctr_msr, NULL, nmi_hz);
+}
+
+static struct wd_ops k7_wd_ops = {
+	.reserve = single_msr_reserve,
+	.unreserve = single_msr_unreserve,
+	.setup = setup_k7_watchdog,
+	.rearm = single_msr_rearm,
+	.stop = single_msr_stop_watchdog,
+	.perfctr = MSR_K7_PERFCTR0,
+	.evntsel = MSR_K7_EVNTSEL0,
+	.checkbit = 1ULL<<63,
+};
+
+/* Intel Model 6 (PPro+,P2,P3,P-M,Core1) */
+
+#define P6_EVNTSEL0_ENABLE	(1 << 22)
+#define P6_EVNTSEL_INT		(1 << 20)
+#define P6_EVNTSEL_OS		(1 << 17)
+#define P6_EVNTSEL_USR		(1 << 16)
+#define P6_EVENT_CPU_CLOCKS_NOT_HALTED	0x79
+#define P6_NMI_EVENT		P6_EVENT_CPU_CLOCKS_NOT_HALTED
+
+static int setup_p6_watchdog(unsigned nmi_hz)
+{
+	unsigned int perfctr_msr, evntsel_msr;
+	unsigned int evntsel;
+	struct nmi_watchdog_ctlblk *wd = &__get_cpu_var(nmi_watchdog_ctlblk);
+
+	perfctr_msr = MSR_P6_PERFCTR0;
+	evntsel_msr = MSR_P6_EVNTSEL0;
+
+	wrmsrl(perfctr_msr, 0UL);
+
+	evntsel = P6_EVNTSEL_INT
+		| P6_EVNTSEL_OS
+		| P6_EVNTSEL_USR
+		| P6_NMI_EVENT;
+
+	/* setup the timer */
+	wrmsr(evntsel_msr, evntsel, 0);
+	nmi_hz = adjust_for_32bit_ctr(nmi_hz);
+	write_watchdog_counter32(perfctr_msr, "P6_PERFCTR0",nmi_hz);
+	apic_write(APIC_LVTPC, APIC_DM_NMI);
+	evntsel |= P6_EVNTSEL0_ENABLE;
+	wrmsr(evntsel_msr, evntsel, 0);
+
+	wd->perfctr_msr = perfctr_msr;
+	wd->evntsel_msr = evntsel_msr;
+	wd->cccr_msr = 0;  //unused
+	return 1;
+}
+
+static void p6_rearm(struct nmi_watchdog_ctlblk *wd, unsigned nmi_hz)
+{
+	/* P6 based Pentium M need to re-unmask
+	 * the apic vector but it doesn't hurt
+	 * other P6 variant.
+	 * ArchPerfom/Core Duo also needs this */
+	apic_write(APIC_LVTPC, APIC_DM_NMI);
+	/* P6/ARCH_PERFMON has 32 bit counter write */
+	write_watchdog_counter32(wd->perfctr_msr, NULL,nmi_hz);
+}
+
+static struct wd_ops p6_wd_ops = {
+	.reserve = single_msr_reserve,
+	.unreserve = single_msr_unreserve,
+	.setup = setup_p6_watchdog,
+	.rearm = p6_rearm,
+	.stop = single_msr_stop_watchdog,
+	.perfctr = MSR_P6_PERFCTR0,
+	.evntsel = MSR_P6_EVNTSEL0,
+	.checkbit = 1ULL<<39,
+};
+
+/* Intel P4 performance counters. By far the most complicated of all. */
+
+#define MSR_P4_MISC_ENABLE_PERF_AVAIL	(1<<7)
+#define P4_ESCR_EVENT_SELECT(N)	((N)<<25)
+#define P4_ESCR_OS		(1<<3)
+#define P4_ESCR_USR		(1<<2)
+#define P4_CCCR_OVF_PMI0	(1<<26)
+#define P4_CCCR_OVF_PMI1	(1<<27)
+#define P4_CCCR_THRESHOLD(N)	((N)<<20)
+#define P4_CCCR_COMPLEMENT	(1<<19)
+#define P4_CCCR_COMPARE		(1<<18)
+#define P4_CCCR_REQUIRED	(3<<16)
+#define P4_CCCR_ESCR_SELECT(N)	((N)<<13)
+#define P4_CCCR_ENABLE		(1<<12)
+#define P4_CCCR_OVF 		(1<<31)
+
+/* Set up IQ_COUNTER0 to behave like a clock, by having IQ_CCCR0 filter
+   CRU_ESCR0 (with any non-null event selector) through a complemented
+   max threshold. [IA32-Vol3, Section 14.9.9] */
+
+static int setup_p4_watchdog(unsigned nmi_hz)
+{
+	unsigned int perfctr_msr, evntsel_msr, cccr_msr;
+	unsigned int evntsel, cccr_val;
+	unsigned int misc_enable, dummy;
+	unsigned int ht_num;
+	struct nmi_watchdog_ctlblk *wd = &__get_cpu_var(nmi_watchdog_ctlblk);
+
+	rdmsr(MSR_IA32_MISC_ENABLE, misc_enable, dummy);
+	if (!(misc_enable & MSR_P4_MISC_ENABLE_PERF_AVAIL))
+		return 0;
+
+#ifdef CONFIG_SMP
+	/* detect which hyperthread we are on */
+	if (smp_num_siblings == 2) {
+		unsigned int ebx, apicid;
+
+        	ebx = cpuid_ebx(1);
+	        apicid = (ebx >> 24) & 0xff;
+        	ht_num = apicid & 1;
+	} else
+#endif
+		ht_num = 0;
+
+	/* performance counters are shared resources
+	 * assign each hyperthread its own set
+	 * (re-use the ESCR0 register, seems safe
+	 * and keeps the cccr_val the same)
+	 */
+	if (!ht_num) {
+		/* logical cpu 0 */
+		perfctr_msr = MSR_P4_IQ_PERFCTR0;
+		evntsel_msr = MSR_P4_CRU_ESCR0;
+		cccr_msr = MSR_P4_IQ_CCCR0;
+		cccr_val = P4_CCCR_OVF_PMI0 | P4_CCCR_ESCR_SELECT(4);
+	} else {
+		/* logical cpu 1 */
+		perfctr_msr = MSR_P4_IQ_PERFCTR1;
+		evntsel_msr = MSR_P4_CRU_ESCR0;
+		cccr_msr = MSR_P4_IQ_CCCR1;
+		cccr_val = P4_CCCR_OVF_PMI1 | P4_CCCR_ESCR_SELECT(4);
+	}
+
+	evntsel = P4_ESCR_EVENT_SELECT(0x3F)
+	 	| P4_ESCR_OS
+		| P4_ESCR_USR;
+
+	cccr_val |= P4_CCCR_THRESHOLD(15)
+		 | P4_CCCR_COMPLEMENT
+		 | P4_CCCR_COMPARE
+		 | P4_CCCR_REQUIRED;
+
+	wrmsr(evntsel_msr, evntsel, 0);
+	wrmsr(cccr_msr, cccr_val, 0);
+	write_watchdog_counter(perfctr_msr, "P4_IQ_COUNTER0", nmi_hz);
+	apic_write(APIC_LVTPC, APIC_DM_NMI);
+	cccr_val |= P4_CCCR_ENABLE;
+	wrmsr(cccr_msr, cccr_val, 0);
+	wd->perfctr_msr = perfctr_msr;
+	wd->evntsel_msr = evntsel_msr;
+	wd->cccr_msr = cccr_msr;
+	return 1;
+}
+
+static void stop_p4_watchdog(void *arg)
+{
+	struct nmi_watchdog_ctlblk *wd = &__get_cpu_var(nmi_watchdog_ctlblk);
+	wrmsr(wd->cccr_msr, 0, 0);
+	wrmsr(wd->evntsel_msr, 0, 0);
+}
+
+static int p4_reserve(void)
+{
+	if (!reserve_perfctr_nmi(MSR_P4_IQ_PERFCTR0))
+		return 0;
+#ifdef CONFIG_SMP
+	if (smp_num_siblings > 1 && !reserve_perfctr_nmi(MSR_P4_IQ_PERFCTR1))
+		goto fail1;
+#endif
+	if (!reserve_evntsel_nmi(MSR_P4_CRU_ESCR0))
+		goto fail2;
+	/* RED-PEN why is ESCR1 not reserved here? */
+	return 1;
+ fail2:
+#ifdef CONFIG_SMP
+	if (smp_num_siblings > 1)
+		release_perfctr_nmi(MSR_P4_IQ_PERFCTR1);
+ fail1:
+#endif
+	release_perfctr_nmi(MSR_P4_IQ_PERFCTR0);
+	return 0;
+}
+
+static void p4_unreserve(void)
+{
+#ifdef CONFIG_SMP
+	if (smp_num_siblings > 1)
+		release_evntsel_nmi(MSR_P4_IQ_PERFCTR1);
+#endif
+	release_evntsel_nmi(MSR_P4_IQ_PERFCTR0);
+	release_perfctr_nmi(MSR_P4_CRU_ESCR0);
+}
+
+static void p4_rearm(struct nmi_watchdog_ctlblk *wd, unsigned nmi_hz)
+{
+	unsigned dummy;
+	/*
+ 	 * P4 quirks:
+	 * - An overflown perfctr will assert its interrupt
+	 *   until the OVF flag in its CCCR is cleared.
+	 * - LVTPC is masked on interrupt and must be
+	 *   unmasked by the LVTPC handler.
+	 */
+	rdmsrl(wd->cccr_msr, dummy);
+	dummy &= ~P4_CCCR_OVF;
+	wrmsrl(wd->cccr_msr, dummy);
+	apic_write(APIC_LVTPC, APIC_DM_NMI);
+	/* start the cycle over again */
+	write_watchdog_counter(wd->perfctr_msr, NULL, nmi_hz);
+}
+
+static struct wd_ops p4_wd_ops = {
+	.reserve = p4_reserve,
+	.unreserve = p4_unreserve,
+	.setup = setup_p4_watchdog,
+	.rearm = p4_rearm,
+	.stop = stop_p4_watchdog,
+	/* RED-PEN this is wrong for the other sibling */
+	.perfctr = MSR_P4_BPU_PERFCTR0,
+	.evntsel = MSR_P4_BSU_ESCR0,
+	.checkbit = 1ULL<<39,
+};
+
+/* Watchdog using the Intel architected PerfMon. Used for Core2 and hopefully
+   all future Intel CPUs. */
+
+#define ARCH_PERFMON_NMI_EVENT_SEL	ARCH_PERFMON_UNHALTED_CORE_CYCLES_SEL
+#define ARCH_PERFMON_NMI_EVENT_UMASK	ARCH_PERFMON_UNHALTED_CORE_CYCLES_UMASK
+
+static int setup_intel_arch_watchdog(unsigned nmi_hz)
+{
+	unsigned int ebx;
+	union cpuid10_eax eax;
+	unsigned int unused;
+	unsigned int perfctr_msr, evntsel_msr;
+	unsigned int evntsel;
+	struct nmi_watchdog_ctlblk *wd = &__get_cpu_var(nmi_watchdog_ctlblk);
+
+	/*
+	 * Check whether the Architectural PerfMon supports
+	 * Unhalted Core Cycles Event or not.
+	 * NOTE: Corresponding bit = 0 in ebx indicates event present.
+	 */
+	cpuid(10, &(eax.full), &ebx, &unused, &unused);
+	if ((eax.split.mask_length < (ARCH_PERFMON_UNHALTED_CORE_CYCLES_INDEX+1)) ||
+	    (ebx & ARCH_PERFMON_UNHALTED_CORE_CYCLES_PRESENT))
+		return 0;
+
+	perfctr_msr = MSR_ARCH_PERFMON_PERFCTR1;
+	evntsel_msr = MSR_ARCH_PERFMON_EVENTSEL1;
+
+	wrmsrl(perfctr_msr, 0UL);
+
+	evntsel = ARCH_PERFMON_EVENTSEL_INT
+		| ARCH_PERFMON_EVENTSEL_OS
+		| ARCH_PERFMON_EVENTSEL_USR
+		| ARCH_PERFMON_NMI_EVENT_SEL
+		| ARCH_PERFMON_NMI_EVENT_UMASK;
+
+	/* setup the timer */
+	wrmsr(evntsel_msr, evntsel, 0);
+	nmi_hz = adjust_for_32bit_ctr(nmi_hz);
+	write_watchdog_counter32(perfctr_msr, "INTEL_ARCH_PERFCTR0", nmi_hz);
+	apic_write(APIC_LVTPC, APIC_DM_NMI);
+	evntsel |= ARCH_PERFMON_EVENTSEL0_ENABLE;
+	wrmsr(evntsel_msr, evntsel, 0);
+
+	wd->perfctr_msr = perfctr_msr;
+	wd->evntsel_msr = evntsel_msr;
+	wd->cccr_msr = 0;  //unused
+	wd_ops->checkbit = 1ULL << (eax.split.bit_width - 1);
+	return 1;
+}
+
+static struct wd_ops intel_arch_wd_ops = {
+	.reserve = single_msr_reserve,
+	.unreserve = single_msr_unreserve,
+	.setup = setup_intel_arch_watchdog,
+	.rearm = p6_rearm,
+	.stop = single_msr_stop_watchdog,
+	.perfctr = MSR_ARCH_PERFMON_PERFCTR0,
+	.evntsel = MSR_ARCH_PERFMON_EVENTSEL0,
+};
+
+static void probe_nmi_watchdog(void)
+{
+	switch (boot_cpu_data.x86_vendor) {
+	case X86_VENDOR_AMD:
+		if (boot_cpu_data.x86 != 6 && boot_cpu_data.x86 != 15 &&
+		    boot_cpu_data.x86 != 16)
+			return;
+		wd_ops = &k7_wd_ops;
+		break;
+	case X86_VENDOR_INTEL:
+		if (cpu_has(&boot_cpu_data, X86_FEATURE_ARCH_PERFMON)) {
+			wd_ops = &intel_arch_wd_ops;
+			break;
+		}
+		switch (boot_cpu_data.x86) {
+		case 6:
+			if (boot_cpu_data.x86_model > 0xd)
+				return;
+
+			wd_ops = &p6_wd_ops;
+			break;
+		case 15:
+			if (boot_cpu_data.x86_model > 0x4)
+				return;
+
+			wd_ops = &p4_wd_ops;
+			break;
+		default:
+			return;
+		}
+		break;
+	}
+}
+
+/* Interface to nmi.c */
+
+int lapic_watchdog_init(unsigned nmi_hz)
+{
+	if (!wd_ops) {
+		probe_nmi_watchdog();
+		if (!wd_ops)
+			return -1;
+	}
+
+	if (!(wd_ops->setup(nmi_hz))) {
+		printk(KERN_ERR "Cannot setup NMI watchdog on CPU %d\n",
+		       raw_smp_processor_id());
+		return -1;
+	}
+
+	return 0;
+}
+
+void lapic_watchdog_stop(void)
+{
+	if (wd_ops)
+		wd_ops->stop(NULL);
+}
+
+unsigned lapic_adjust_nmi_hz(unsigned hz)
+{
+	struct nmi_watchdog_ctlblk *wd = &__get_cpu_var(nmi_watchdog_ctlblk);
+	if (wd->perfctr_msr == MSR_P6_PERFCTR0 ||
+	    wd->perfctr_msr == MSR_ARCH_PERFMON_PERFCTR1)
+		hz = adjust_for_32bit_ctr(hz);
+	return hz;
+}
+
+int lapic_wd_event(unsigned nmi_hz)
+{
+	struct nmi_watchdog_ctlblk *wd = &__get_cpu_var(nmi_watchdog_ctlblk);
+	u64 ctr;
+	rdmsrl(wd->perfctr_msr, ctr);
+	if (ctr & wd_ops->checkbit) { /* perfctr still running? */
+		return 0;
+	}
+	wd_ops->rearm(wd, nmi_hz);
+	return 1;
+}
+
+int lapic_watchdog_ok(void)
+{
+	return wd_ops != NULL;
+}
Index: linux/include/asm-i386/nmi.h
===================================================================
--- linux.orig/include/asm-i386/nmi.h
+++ linux/include/asm-i386/nmi.h
@@ -50,4 +50,12 @@ void __trigger_all_cpu_backtrace(void);
 
 #endif
 
+void lapic_watchdog_stop(void);
+int lapic_watchdog_init(unsigned nmi_hz);
+int lapic_wd_event(unsigned nmi_hz);
+unsigned lapic_adjust_nmi_hz(unsigned hz);
+int lapic_watchdog_ok(void);
+void disable_lapic_nmi_watchdog(void);
+void enable_lapic_nmi_watchdog(void);
+
 #endif /* ASM_NMI_H */
