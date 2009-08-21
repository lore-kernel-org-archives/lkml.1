Return-Path: <linux-kernel-owner+w=401wt.eu-S933069AbZHUVes@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933069AbZHUVes (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Aug 2009 17:34:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933032AbZHUVeE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Aug 2009 17:34:04 -0400
Received: from www.tglx.de ([62.245.132.106]:52013 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932986AbZHUVd7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Aug 2009 17:33:59 -0400
Message-Id: <20090821205603.267985525@linutronix.de>
User-Agent: quilt/0.47-1
Date: Fri, 21 Aug 2009 21:32:12 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: x86 team <x86@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Arjan van de Veen <arjan@infradead.org>, Avi Kivity <avi@redhat.com>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Alok N Kataria <akataria@vmware.com>,
       Pan Jacob jun <jacob.jun.pan@intel.com>
Subject: [RFC patch 30/32] x86: Move tsc_calibration to platform
References: <20090821205008.518392436@linutronix.de>
Content-Disposition: inline;
	filename=x86-move-tsc-calibration-to-platform.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

TSC calibration is modified by the vmware hypervisor and paravirt by
separate means. Moorestown wants to add its own calibration routine as
well. So make calibrate_tsc a proper platform function and override it
by paravirt or by the early setup of the vmware hypervisor.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 arch/x86/include/asm/hypervisor.h |    2 +-
 arch/x86/include/asm/paravirt.h   |    2 --
 arch/x86/include/asm/platform.h   |    2 ++
 arch/x86/include/asm/timer.h      |    5 -----
 arch/x86/include/asm/tsc.h        |    3 ++-
 arch/x86/include/asm/vmware.h     |    2 +-
 arch/x86/kernel/cpu/hypervisor.c  |   14 +++++++-------
 arch/x86/kernel/cpu/vmware.c      |   35 +++++++++++++++++++----------------
 arch/x86/kernel/kvmclock.c        |    2 +-
 arch/x86/kernel/paravirt.c        |    1 -
 arch/x86/kernel/platform_setup.c  |    2 ++
 arch/x86/kernel/setup.c           |    2 +-
 arch/x86/kernel/tsc.c             |   10 ++--------
 arch/x86/kernel/vmi_32.c          |    2 +-
 arch/x86/kernel/vmiclock_32.c     |    2 +-
 arch/x86/lguest/boot.c            |    2 +-
 arch/x86/xen/enlighten.c          |    2 +-
 17 files changed, 42 insertions(+), 48 deletions(-)

Index: linux-2.6/arch/x86/include/asm/hypervisor.h
===================================================================
--- linux-2.6.orig/arch/x86/include/asm/hypervisor.h
+++ linux-2.6/arch/x86/include/asm/hypervisor.h
@@ -20,7 +20,7 @@
 #ifndef ASM_X86__HYPERVISOR_H
 #define ASM_X86__HYPERVISOR_H
 
-extern unsigned long get_hypervisor_tsc_freq(void);
 extern void init_hypervisor(struct cpuinfo_x86 *c);
+extern void init_hypervisor_platform(void);
 
 #endif
Index: linux-2.6/arch/x86/include/asm/paravirt.h
===================================================================
--- linux-2.6.orig/arch/x86/include/asm/paravirt.h
+++ linux-2.6/arch/x86/include/asm/paravirt.h
@@ -103,7 +103,6 @@ struct pv_time_ops {
 	int (*set_wallclock)(unsigned long);
 
 	unsigned long long (*sched_clock)(void);
-	unsigned long (*get_tsc_khz)(void);
 };
 
 struct pv_cpu_ops {
@@ -867,7 +866,6 @@ static inline unsigned long long paravir
 {
 	return PVOP_CALL0(unsigned long long, pv_time_ops.sched_clock);
 }
-#define calibrate_tsc() (pv_time_ops.get_tsc_khz())
 
 static inline unsigned long long paravirt_read_pmc(int counter)
 {
Index: linux-2.6/arch/x86/include/asm/platform.h
===================================================================
--- linux-2.6.orig/arch/x86/include/asm/platform.h
+++ linux-2.6/arch/x86/include/asm/platform.h
@@ -90,11 +90,13 @@ struct platform_setup_paging {
  *				boot cpu
  * @tsc_pre_init:		platform function called before TSC init
  * @timer_init:			initialize the platform timer (default PIT/HPET)
+ * @calibrate_tsc:		calibrate TSC
  */
 struct platform_setup_timers {
 	void (*setup_percpu_clockev)(void);
 	void (*tsc_pre_init)(void);
 	void (*timer_init)(void);
+	unsigned long (*calibrate_tsc)(void);
 };
 
 /**
Index: linux-2.6/arch/x86/include/asm/timer.h
===================================================================
--- linux-2.6.orig/arch/x86/include/asm/timer.h
+++ linux-2.6/arch/x86/include/asm/timer.h
@@ -8,7 +8,6 @@
 #define TICK_SIZE (tick_nsec / 1000)
 
 unsigned long long native_sched_clock(void);
-unsigned long native_calibrate_tsc(void);
 extern int recalibrate_cpu_khz(void);
 
 #if defined(CONFIG_X86_32) && defined(CONFIG_X86_IO_APIC)
@@ -19,10 +18,6 @@ extern int timer_ack;
 
 extern int no_timer_check;
 
-#ifndef CONFIG_PARAVIRT
-#define calibrate_tsc() native_calibrate_tsc()
-#endif
-
 /* Accelerators for sched_clock()
  * convert from cycles(64bits) => nanoseconds (64bits)
  *  basic equation:
Index: linux-2.6/arch/x86/include/asm/tsc.h
===================================================================
--- linux-2.6.orig/arch/x86/include/asm/tsc.h
+++ linux-2.6/arch/x86/include/asm/tsc.h
@@ -48,7 +48,8 @@ static __always_inline cycles_t vget_cyc
 extern void tsc_init(void);
 extern void mark_tsc_unstable(char *reason);
 extern int unsynchronized_tsc(void);
-int check_tsc_unstable(void);
+extern int check_tsc_unstable(void);
+extern unsigned long native_calibrate_tsc(void);
 
 /*
  * Boot-time check whether the TSCs are synchronized across
Index: linux-2.6/arch/x86/include/asm/vmware.h
===================================================================
--- linux-2.6.orig/arch/x86/include/asm/vmware.h
+++ linux-2.6/arch/x86/include/asm/vmware.h
@@ -20,7 +20,7 @@
 #ifndef ASM_X86__VMWARE_H
 #define ASM_X86__VMWARE_H
 
-extern unsigned long vmware_get_tsc_khz(void);
+extern void vmware_platform_setup(void);
 extern int vmware_platform(void);
 extern void vmware_set_feature_bits(struct cpuinfo_x86 *c);
 
Index: linux-2.6/arch/x86/kernel/cpu/hypervisor.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/cpu/hypervisor.c
+++ linux-2.6/arch/x86/kernel/cpu/hypervisor.c
@@ -35,13 +35,6 @@ detect_hypervisor_vendor(struct cpuinfo_
 	}
 }
 
-unsigned long get_hypervisor_tsc_freq(void)
-{
-	if (boot_cpu_data.x86_hyper_vendor == X86_HYPER_VENDOR_VMWARE)
-		return vmware_get_tsc_khz();
-	return 0;
-}
-
 static inline void __cpuinit
 hypervisor_set_feature_bits(struct cpuinfo_x86 *c)
 {
@@ -56,3 +49,10 @@ void __cpuinit init_hypervisor(struct cp
 	detect_hypervisor_vendor(c);
 	hypervisor_set_feature_bits(c);
 }
+
+void __init init_hypervisor_platform(void)
+{
+	init_hypervisor(&boot_cpu_data);
+	if (boot_cpu_data.x86_hyper_vendor == X86_HYPER_VENDOR_VMWARE)
+		vmware_platform_setup();
+}
Index: linux-2.6/arch/x86/kernel/cpu/vmware.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/cpu/vmware.c
+++ linux-2.6/arch/x86/kernel/cpu/vmware.c
@@ -24,6 +24,7 @@
 #include <linux/dmi.h>
 #include <asm/div64.h>
 #include <asm/vmware.h>
+#include <asm/platform.h>
 
 #define CPUID_VMWARE_INFO_LEAF	0x40000000
 #define VMWARE_HYPERVISOR_MAGIC	0x564D5868
@@ -47,19 +48,27 @@ static inline int __vmware_platform(void
 	return eax != (uint32_t)-1 && ebx == VMWARE_HYPERVISOR_MAGIC;
 }
 
-static unsigned long __vmware_get_tsc_khz(void)
+static unsigned long vmware_get_tsc_khz(void)
 {
-        uint64_t tsc_hz;
-        uint32_t eax, ebx, ecx, edx;
+	uint64_t tsc_hz;
+	uint32_t eax, ebx, ecx, edx;
+
+	VMWARE_PORT(GETHZ, eax, ebx, ecx, edx);
+
+	tsc_hz = eax | (((uint64_t)ebx) << 32);
+	do_div(tsc_hz, 1000);
+	BUG_ON(tsc_hz >> 32);
+	return tsc_hz;
+}
+
+void __init vmware_platform_setup(void)
+{
+	uint32_t eax, ebx, ecx, edx;
 
-        VMWARE_PORT(GETHZ, eax, ebx, ecx, edx);
+	VMWARE_PORT(GETHZ, eax, ebx, ecx, edx);
 
-        if (ebx == UINT_MAX)
-                return 0;
-        tsc_hz = eax | (((uint64_t)ebx) << 32);
-        do_div(tsc_hz, 1000);
-        BUG_ON(tsc_hz >> 32);
-        return tsc_hz;
+	if (ebx != UINT_MAX)
+		platform_setup.timers.calibrate_tsc = vmware_get_tsc_khz;
 }
 
 /*
@@ -87,12 +96,6 @@ int vmware_platform(void)
 	return 0;
 }
 
-unsigned long vmware_get_tsc_khz(void)
-{
-	BUG_ON(!vmware_platform());
-	return __vmware_get_tsc_khz();
-}
-
 /*
  * VMware hypervisor takes care of exporting a reliable TSC to the guest.
  * Still, due to timing difference when running on virtual cpus, the TSC can
Index: linux-2.6/arch/x86/kernel/kvmclock.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/kvmclock.c
+++ linux-2.6/arch/x86/kernel/kvmclock.c
@@ -187,7 +187,7 @@ void __init kvmclock_init(void)
 		pv_time_ops.get_wallclock = kvm_get_wallclock;
 		pv_time_ops.set_wallclock = kvm_set_wallclock;
 		pv_time_ops.sched_clock = kvm_clock_read;
-		pv_time_ops.get_tsc_khz = kvm_get_tsc_khz;
+		platform_setup.timers.calibrate_tsc = kvm_get_tsc_khz;
 #ifdef CONFIG_X86_LOCAL_APIC
 		platform_cpuhotplug_setup.setup_percpu_clockev =
 			kvm_setup_secondary_clock;
Index: linux-2.6/arch/x86/kernel/paravirt.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/paravirt.c
+++ linux-2.6/arch/x86/kernel/paravirt.c
@@ -309,7 +309,6 @@ struct pv_time_ops pv_time_ops = {
 	.get_wallclock = native_get_wallclock,
 	.set_wallclock = native_set_wallclock,
 	.sched_clock = native_sched_clock,
-	.get_tsc_khz = native_calibrate_tsc,
 };
 
 struct pv_irq_ops pv_irq_ops = {
Index: linux-2.6/arch/x86/kernel/platform_setup.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/platform_setup.c
+++ linux-2.6/arch/x86/kernel/platform_setup.c
@@ -12,6 +12,7 @@
 #include <asm/e820.h>
 #include <asm/time.h>
 #include <asm/irq.h>
+#include <asm/tsc.h>
 
 void __cpuinit platform_setup_noop(void) { }
 void __init platform_setup_uint_noop(unsigned int unused) { }
@@ -59,6 +60,7 @@ struct __initdata platform_setup_ops pla
 		.setup_percpu_clockev = setup_boot_APIC_clock,
 		.tsc_pre_init = platform_setup_noop,
 		.timer_init = hpet_time_init,
+		.calibrate_tsc = native_calibrate_tsc,
 	},
 
 	.quirks = {
Index: linux-2.6/arch/x86/kernel/setup.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/setup.c
+++ linux-2.6/arch/x86/kernel/setup.c
@@ -818,7 +818,7 @@ void __init setup_arch(char **cmdline_p)
 	 * VMware detection requires dmi to be available, so this
 	 * needs to be done after dmi_scan_machine, for the BP.
 	 */
-	init_hypervisor(&boot_cpu_data);
+	init_hypervisor_platform();
 
 	platform_setup.resources.probe_roms();
 
Index: linux-2.6/arch/x86/kernel/tsc.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/tsc.c
+++ linux-2.6/arch/x86/kernel/tsc.c
@@ -401,15 +401,9 @@ unsigned long native_calibrate_tsc(void)
 {
 	u64 tsc1, tsc2, delta, ref1, ref2;
 	unsigned long tsc_pit_min = ULONG_MAX, tsc_ref_min = ULONG_MAX;
-	unsigned long flags, latch, ms, fast_calibrate, hv_tsc_khz;
+	unsigned long flags, latch, ms, fast_calibrate;
 	int hpet = is_hpet_enabled(), i, loopmin;
 
-	hv_tsc_khz = get_hypervisor_tsc_freq();
-	if (hv_tsc_khz) {
-		printk(KERN_INFO "TSC: Frequency read from the hypervisor\n");
-		return hv_tsc_khz;
-	}
-
 	local_irq_save(flags);
 	fast_calibrate = quick_pit_calibrate();
 	local_irq_restore(flags);
@@ -917,7 +911,7 @@ void __init tsc_init(void)
 	if (!cpu_has_tsc)
 		return;
 
-	tsc_khz = calibrate_tsc();
+	tsc_khz = platform_setup.timers.calibrate_tsc();
 	cpu_khz = tsc_khz;
 
 	if (!tsc_khz) {
Index: linux-2.6/arch/x86/kernel/vmi_32.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/vmi_32.c
+++ linux-2.6/arch/x86/kernel/vmi_32.c
@@ -826,7 +826,7 @@ static inline int __init activate_vmi(vo
 			vmi_time_ap_init;
 #endif
 		pv_time_ops.sched_clock = vmi_sched_clock;
-		pv_time_ops.get_tsc_khz = vmi_tsc_khz;
+		platform_setup.timers.calibrate_tsc = vmi_tsc_khz;
 
 		/* We have true wallclock functions; disable CMOS clock sync */
 		no_sync_cmos_clock = 1;
Index: linux-2.6/arch/x86/kernel/vmiclock_32.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/vmiclock_32.c
+++ linux-2.6/arch/x86/kernel/vmiclock_32.c
@@ -68,7 +68,7 @@ unsigned long long vmi_sched_clock(void)
 	return cycles_2_ns(vmi_timer_ops.get_cycle_counter(VMI_CYCLES_AVAILABLE));
 }
 
-/* paravirt_ops.get_tsc_khz = vmi_tsc_khz */
+/* platform_setup.calibrate_tsc = vmi_tsc_khz */
 unsigned long vmi_tsc_khz(void)
 {
 	unsigned long long khz;
Index: linux-2.6/arch/x86/lguest/boot.c
===================================================================
--- linux-2.6.orig/arch/x86/lguest/boot.c
+++ linux-2.6/arch/x86/lguest/boot.c
@@ -1320,11 +1320,11 @@ __init void lguest_init(void)
 
 	/* Time operations */
 	pv_time_ops.get_wallclock = lguest_get_wallclock;
-	pv_time_ops.get_tsc_khz = lguest_tsc_khz;
 
 	platform_setup.resources.memory_setup = lguest_memory_setup;
 	platform_setup.irqs.intr_init = lguest_init_IRQ;
 	platform_setup.timers.timer_init = lguest_time_init;
+	platform_setup.timers.calibrate_tsc = lguest_tsc_khz;
 
 	/*
 	 * Now is a good time to look at the implementations of these functions
Index: linux-2.6/arch/x86/xen/enlighten.c
===================================================================
--- linux-2.6.orig/arch/x86/xen/enlighten.c
+++ linux-2.6/arch/x86/xen/enlighten.c
@@ -844,7 +844,6 @@ static const struct pv_init_ops xen_init
 static const struct pv_time_ops xen_time_ops __initdata = {
 	.set_wallclock = xen_set_wallclock,
 	.get_wallclock = xen_get_wallclock,
-	.get_tsc_khz = xen_tsc_khz,
 	.sched_clock = xen_sched_clock,
 };
 
@@ -981,6 +980,7 @@ asmlinkage void __init xen_start_kernel(
 	platform_setup.oem.banner = xen_banner;
 
 	platform_setup.timers.timer_init = xen_time_init;
+	platform_setup.timers.calibrate_tsc = xen_tsc_khz;
 
 	/* Override the default per cpu clockevents setup functions */
 	platform_setup.timers.setup_percpu_clockev = platform_setup_noop;


