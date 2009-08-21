Return-Path: <linux-kernel-owner+w=401wt.eu-S933000AbZHUVcu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933000AbZHUVcu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Aug 2009 17:32:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932999AbZHUVcs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Aug 2009 17:32:48 -0400
Received: from www.tglx.de ([62.245.132.106]:51822 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932992AbZHUVco (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Aug 2009 17:32:44 -0400
Message-Id: <20090821205602.770249126@linutronix.de>
User-Agent: quilt/0.47-1
Date: Fri, 21 Aug 2009 21:31:14 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: x86 team <x86@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Arjan van de Veen <arjan@infradead.org>, Avi Kivity <avi@redhat.com>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Alok N Kataria <akataria@vmware.com>,
       Pan Jacob jun <jacob.jun.pan@intel.com>
Subject: [RFC patch 20/32] x86: Move percpu clockevents setup to platform
References: <20090821205008.518392436@linutronix.de>
Content-Disposition: inline;
	filename=x86-platform-support-for-per-cpu-timer-setup.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

paravirt overrides the setup of the default apic timers as per cpu
timers. Moorestown needs to override that as well.

Move it to platform setup and create a separate
platform_cpuhotplug_setup struct which holds the function for the
secondary evtl. hotplugabble CPUs.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 arch/x86/include/asm/apic.h      |    3 ---
 arch/x86/include/asm/paravirt.h  |   15 ---------------
 arch/x86/include/asm/platform.h  |   19 +++++++++++++++++++
 arch/x86/kernel/apic/apic.c      |    3 ++-
 arch/x86/kernel/kvmclock.c       |    5 ++++-
 arch/x86/kernel/paravirt.c       |    2 --
 arch/x86/kernel/platform_setup.c |    9 +++++++++
 arch/x86/kernel/smpboot.c        |    4 ++--
 arch/x86/kernel/vmi_32.c         |    5 +++--
 arch/x86/xen/enlighten.c         |    6 ++++--
 10 files changed, 43 insertions(+), 28 deletions(-)

Index: linux-2.6/arch/x86/include/asm/apic.h
===================================================================
--- linux-2.6.orig/arch/x86/include/asm/apic.h
+++ linux-2.6/arch/x86/include/asm/apic.h
@@ -70,9 +70,6 @@ static inline void default_inquire_remot
  */
 #ifdef CONFIG_PARAVIRT
 #include <asm/paravirt.h>
-#else
-#define setup_boot_clock setup_boot_APIC_clock
-#define setup_secondary_clock setup_secondary_APIC_clock
 #endif
 
 #ifdef CONFIG_X86_64
Index: linux-2.6/arch/x86/include/asm/paravirt.h
===================================================================
--- linux-2.6.orig/arch/x86/include/asm/paravirt.h
+++ linux-2.6/arch/x86/include/asm/paravirt.h
@@ -228,9 +228,6 @@ struct pv_irq_ops {
 
 struct pv_apic_ops {
 #ifdef CONFIG_X86_LOCAL_APIC
-	void (*setup_boot_clock)(void);
-	void (*setup_secondary_clock)(void);
-
 	void (*startup_ipi_hook)(int phys_apicid,
 				 unsigned long start_eip,
 				 unsigned long start_esp);
@@ -995,18 +992,6 @@ static inline void slow_down_io(void)
 #endif
 }
 
-#ifdef CONFIG_X86_LOCAL_APIC
-static inline void setup_boot_clock(void)
-{
-	PVOP_VCALL0(pv_apic_ops.setup_boot_clock);
-}
-
-static inline void setup_secondary_clock(void)
-{
-	PVOP_VCALL0(pv_apic_ops.setup_secondary_clock);
-}
-#endif
-
 #ifdef CONFIG_SMP
 static inline void startup_ipi_hook(int phys_apicid, unsigned long start_eip,
 				    unsigned long start_esp)
Index: linux-2.6/arch/x86/include/asm/platform.h
===================================================================
--- linux-2.6.orig/arch/x86/include/asm/platform.h
+++ linux-2.6/arch/x86/include/asm/platform.h
@@ -85,6 +85,15 @@ struct platform_setup_paging {
 };
 
 /**
+ * struct platform_setup_timers - platform specific timer setup
+ * @setup_perpcu_clockev:	set up the per cpu clock event device for the
+ *				boot cpu
+ */
+struct platform_setup_timers {
+	void (*setup_percpu_clockev)(void);
+};
+
+/**
  * struct platform_setup_ops - functions for platform specific setup
  *
  */
@@ -94,10 +103,20 @@ struct platform_setup_ops {
 	struct platform_setup_irqs irqs;
 	struct platform_setup_oem oem;
 	struct platform_setup_paging paging;
+	struct platform_setup_timers timers;
 	struct platform_setup_quirks quirks;
 };
 
+/**
+ * struct platform_setup_cpuhotplug - platform specific cpu hotplug setups
+ * @setup_percpu_clockev:	set up the per cpu clock event device
+ */
+struct platform_setup_cpuhotplug {
+	void (*setup_percpu_clockev)(void);
+};
+
 extern struct platform_setup_ops platform_setup;
+extern struct platform_setup_cpuhotplug platform_cpuhotplug_setup;
 
 extern void platform_setup_noop(void);
 extern void platform_setup_uint_noop(unsigned int unused);
Index: linux-2.6/arch/x86/kernel/apic/apic.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/apic/apic.c
+++ linux-2.6/arch/x86/kernel/apic/apic.c
@@ -36,6 +36,7 @@
 #include <linux/mm.h>
 
 #include <asm/perf_counter.h>
+#include <asm/platform.h>
 #include <asm/pgalloc.h>
 #include <asm/atomic.h>
 #include <asm/mpspec.h>
@@ -1701,7 +1702,7 @@ int __init APIC_init_uniprocessor(void)
 	localise_nmi_watchdog();
 #endif
 
-	setup_boot_clock();
+	platform_setup.timers.setup_percpu_clockev();
 #ifdef CONFIG_X86_64
 	check_nmi_watchdog();
 #endif
Index: linux-2.6/arch/x86/kernel/kvmclock.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/kvmclock.c
+++ linux-2.6/arch/x86/kernel/kvmclock.c
@@ -22,6 +22,8 @@
 #include <asm/msr.h>
 #include <asm/apic.h>
 #include <linux/percpu.h>
+
+#include <asm/platform.h>
 #include <asm/reboot.h>
 
 #define KVM_SCALE 22
@@ -187,7 +189,8 @@ void __init kvmclock_init(void)
 		pv_time_ops.sched_clock = kvm_clock_read;
 		pv_time_ops.get_tsc_khz = kvm_get_tsc_khz;
 #ifdef CONFIG_X86_LOCAL_APIC
-		pv_apic_ops.setup_secondary_clock = kvm_setup_secondary_clock;
+		platform_cpuhotplug_setup.setup_percpu_clockev =
+			kvm_setup_secondary_clock;
 #endif
 #ifdef CONFIG_SMP
 		smp_ops.smp_prepare_boot_cpu = kvm_smp_prepare_boot_cpu;
Index: linux-2.6/arch/x86/kernel/paravirt.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/paravirt.c
+++ linux-2.6/arch/x86/kernel/paravirt.c
@@ -387,8 +387,6 @@ struct pv_cpu_ops pv_cpu_ops = {
 
 struct pv_apic_ops pv_apic_ops = {
 #ifdef CONFIG_X86_LOCAL_APIC
-	.setup_boot_clock = setup_boot_APIC_clock,
-	.setup_secondary_clock = setup_secondary_APIC_clock,
 	.startup_ipi_hook = paravirt_nop,
 #endif
 };
Index: linux-2.6/arch/x86/kernel/platform_setup.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/platform_setup.c
+++ linux-2.6/arch/x86/kernel/platform_setup.c
@@ -8,6 +8,7 @@
 #include <asm/bios_ebda.h>
 #include <asm/mpspec.h>
 #include <asm/setup.h>
+#include <asm/apic.h>
 #include <asm/e820.h>
 #include <asm/irq.h>
 
@@ -53,7 +54,15 @@ struct __initdata platform_setup_ops pla
 		.pagetable_setup_done = native_pagetable_setup_done,
 	},
 
+	.timers = {
+		.setup_percpu_clockev = setup_boot_APIC_clock,
+	},
+
 	.quirks = {
 		.mpc_record = platform_setup_uint_noop,
 	},
 };
+
+__cpuinitdata struct platform_setup_cpuhotplug platform_cpuhotplug_setup = {
+	.setup_percpu_clockev = setup_secondary_APIC_clock,
+};
Index: linux-2.6/arch/x86/kernel/smpboot.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/smpboot.c
+++ linux-2.6/arch/x86/kernel/smpboot.c
@@ -323,7 +323,7 @@ notrace static void __cpuinit start_seco
 	/* enable local interrupts */
 	local_irq_enable();
 
-	setup_secondary_clock();
+	platform_cpuhotplug_setup.setup_percpu_clockev();
 
 	wmb();
 	cpu_idle();
@@ -1112,7 +1112,7 @@ void __init native_smp_prepare_cpus(unsi
 
 	printk(KERN_INFO "CPU%d: ", 0);
 	print_cpu_info(&cpu_data(0));
-	setup_boot_clock();
+	platform_setup.timers.setup_percpu_clockev();
 
 	if (is_uv_system())
 		uv_system_init();
Index: linux-2.6/arch/x86/kernel/vmi_32.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/vmi_32.c
+++ linux-2.6/arch/x86/kernel/vmi_32.c
@@ -821,8 +821,9 @@ static inline int __init activate_vmi(vo
 		pv_time_ops.get_wallclock = vmi_get_wallclock;
 		pv_time_ops.set_wallclock = vmi_set_wallclock;
 #ifdef CONFIG_X86_LOCAL_APIC
-		pv_apic_ops.setup_boot_clock = vmi_time_bsp_init;
-		pv_apic_ops.setup_secondary_clock = vmi_time_ap_init;
+		platform_setup.timers.setup_percpu_clockev = vmi_time_bsp_init;
+		platform_cpuhotplug_setup.setup_percpu_clockev =
+			vmi_time_ap_init;
 #endif
 		pv_time_ops.sched_clock = vmi_sched_clock;
 		pv_time_ops.get_tsc_khz = vmi_tsc_khz;
Index: linux-2.6/arch/x86/xen/enlighten.c
===================================================================
--- linux-2.6.orig/arch/x86/xen/enlighten.c
+++ linux-2.6/arch/x86/xen/enlighten.c
@@ -912,8 +912,6 @@ static const struct pv_cpu_ops xen_cpu_o
 
 static const struct pv_apic_ops xen_apic_ops __initdata = {
 #ifdef CONFIG_X86_LOCAL_APIC
-	.setup_boot_clock = paravirt_nop,
-	.setup_secondary_clock = paravirt_nop,
 	.startup_ipi_hook = paravirt_nop,
 #endif
 };
@@ -984,6 +982,10 @@ asmlinkage void __init xen_start_kernel(
 	platform_setup.oem.arch_setup = xen_arch_setup;
 	platform_setup.oem.banner = xen_banner;
 
+	/* Override the default per cpu clockevents setup functions */
+	platform_setup.timers.setup_percpu_clockev = platform_setup_noop;
+	platform_cpuhotplug_setup.setup_percpu_clockev = platform_setup_noop;
+
 	xen_init_mmu_ops();
 	xen_init_irq_ops();
 


