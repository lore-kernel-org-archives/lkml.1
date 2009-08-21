Return-Path: <linux-kernel-owner+w=401wt.eu-S933075AbZHUVf7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933075AbZHUVf7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Aug 2009 17:35:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932987AbZHUVf4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Aug 2009 17:35:56 -0400
Received: from www.tglx.de ([62.245.132.106]:51880 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932994AbZHUVdG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Aug 2009 17:33:06 -0400
Message-Id: <20090821205602.826717491@linutronix.de>
User-Agent: quilt/0.47-1
Date: Fri, 21 Aug 2009 21:31:20 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: x86 team <x86@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Arjan van de Veen <arjan@infradead.org>, Avi Kivity <avi@redhat.com>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Alok N Kataria <akataria@vmware.com>,
       Pan Jacob jun <jacob.jun.pan@intel.com>
Subject: [RFC patch 21/32] x86: Add timer_init to platform
References: <20090821205008.518392436@linutronix.de>
Content-Disposition: inline; filename=x86-add-timer-init-to-platform.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The timer init code is convoluted with several quirks and the paravirt
timer chooser. Figuring out which code path is actually taken is not
for the faint hearted.

Move the numaq TSC quirk to tsc_pre_init platform function and replace
the paravirt time chooser and the remaining x86 quirk with a simple
platform setup function.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 arch/x86/include/asm/paravirt.h  |    7 ------
 arch/x86/include/asm/platform.h  |    4 +++
 arch/x86/include/asm/setup.h     |   21 +------------------
 arch/x86/include/asm/time.h      |    1 
 arch/x86/include/asm/timer.h     |    3 --
 arch/x86/kernel/apic/numaq_32.c  |   10 +--------
 arch/x86/kernel/paravirt.c       |    1 
 arch/x86/kernel/platform_setup.c |    3 ++
 arch/x86/kernel/setup.c          |   43 ---------------------------------------
 arch/x86/kernel/time_32.c        |   34 ++++++++++++++++++++----------
 arch/x86/kernel/time_64.c        |    9 ++++++--
 arch/x86/kernel/tsc.c            |    2 +
 arch/x86/kernel/visws_quirks.c   |   22 +++++--------------
 arch/x86/kernel/vmi_32.c         |    2 -
 arch/x86/lguest/boot.c           |    2 -
 arch/x86/xen/enlighten.c         |    4 +--
 16 files changed, 54 insertions(+), 114 deletions(-)

Index: linux-2.6/arch/x86/include/asm/paravirt.h
===================================================================
--- linux-2.6.orig/arch/x86/include/asm/paravirt.h
+++ linux-2.6/arch/x86/include/asm/paravirt.h
@@ -98,8 +98,6 @@ struct pv_lazy_ops {
 };
 
 struct pv_time_ops {
-	void (*time_init)(void);
-
 	/* Set and set time of day */
 	unsigned long (*get_wallclock)(void);
 	int (*set_wallclock)(unsigned long);
@@ -693,11 +691,6 @@ static inline int set_wallclock(unsigned
 	return PVOP_CALL1(int, pv_time_ops.set_wallclock, nowtime);
 }
 
-static inline void (*choose_time_init(void))(void)
-{
-	return pv_time_ops.time_init;
-}
-
 /* The paravirtualized CPUID instruction. */
 static inline void __cpuid(unsigned int *eax, unsigned int *ebx,
 			   unsigned int *ecx, unsigned int *edx)
Index: linux-2.6/arch/x86/include/asm/platform.h
===================================================================
--- linux-2.6.orig/arch/x86/include/asm/platform.h
+++ linux-2.6/arch/x86/include/asm/platform.h
@@ -88,9 +88,13 @@ struct platform_setup_paging {
  * struct platform_setup_timers - platform specific timer setup
  * @setup_perpcu_clockev:	set up the per cpu clock event device for the
  *				boot cpu
+ * @tsc_pre_init:		platform function called before TSC init
+ * @timer_init:			initialize the platform timer (default PIT/HPET)
  */
 struct platform_setup_timers {
 	void (*setup_percpu_clockev)(void);
+	void (*tsc_pre_init)(void);
+	void (*timer_init)(void);
 };
 
 /**
Index: linux-2.6/arch/x86/include/asm/setup.h
===================================================================
--- linux-2.6.orig/arch/x86/include/asm/setup.h
+++ linux-2.6/arch/x86/include/asm/setup.h
@@ -5,24 +5,6 @@
 
 #define COMMAND_LINE_SIZE 2048
 
-#ifndef __ASSEMBLY__
-
-#include <asm/platform.h>
-
-/*
- * Any setup quirks to be performed?
- */
-
-struct x86_quirks {
-	int (*arch_pre_time_init)(void);
-	int (*arch_time_init)(void);
-};
-
-extern void x86_quirk_pre_time_init(void);
-extern void x86_quirk_time_init(void);
-
-#endif /* __ASSEMBLY__ */
-
 #ifdef __i386__
 
 #include <linux/pfn.h>
@@ -42,6 +24,7 @@ extern void x86_quirk_time_init(void);
 
 #ifndef __ASSEMBLY__
 #include <asm/bootparam.h>
+#include <asm/platform.h>
 
 /* Interrupt control for vSMPowered x86_64 systems */
 #ifdef CONFIG_X86_64
@@ -60,11 +43,11 @@ static inline void visws_early_detect(vo
 static inline int is_visws_box(void) { return 0; }
 #endif
 
-extern struct x86_quirks *x86_quirks;
 extern unsigned long saved_video_mode;
 
 extern void reserve_standard_io_resources(void);
 extern void i386_reserve_resources(void);
+extern void setup_default_timer_irq(void);
 
 #ifndef _SETUP
 
Index: linux-2.6/arch/x86/include/asm/time.h
===================================================================
--- linux-2.6.orig/arch/x86/include/asm/time.h
+++ linux-2.6/arch/x86/include/asm/time.h
@@ -54,7 +54,6 @@ extern void time_init(void);
 
 #define get_wallclock() native_get_wallclock()
 #define set_wallclock(x) native_set_wallclock(x)
-#define choose_time_init() hpet_time_init
 
 #endif /* CONFIG_PARAVIRT */
 
Index: linux-2.6/arch/x86/include/asm/timer.h
===================================================================
--- linux-2.6.orig/arch/x86/include/asm/timer.h
+++ linux-2.6/arch/x86/include/asm/timer.h
@@ -12,8 +12,7 @@ unsigned long native_calibrate_tsc(void)
 
 #ifdef CONFIG_X86_32
 extern int timer_ack;
-extern irqreturn_t timer_interrupt(int irq, void *dev_id);
-#endif /* CONFIG_X86_32 */
+#endif
 extern int recalibrate_cpu_khz(void);
 
 extern int no_timer_check;
Index: linux-2.6/arch/x86/kernel/apic/numaq_32.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/apic/numaq_32.c
+++ linux-2.6/arch/x86/kernel/apic/numaq_32.c
@@ -129,10 +129,9 @@ void __cpuinit numaq_tsc_disable(void)
 	}
 }
 
-static int __init numaq_pre_time_init(void)
+static void __init numaq_tsc_init(void)
 {
 	numaq_tsc_disable();
-	return 0;
 }
 
 static inline int generate_logical_apicid(int quad, int phys_apicid)
@@ -262,11 +261,6 @@ static void __init smp_read_mpc_oem(stru
 	}
 }
 
-static struct x86_quirks numaq_x86_quirks __initdata = {
-	.arch_pre_time_init		= numaq_pre_time_init,
-	.arch_time_init			= NULL,
-};
-
 static __init void early_check_numaq(void)
 {
 	/*
@@ -281,13 +275,13 @@ static __init void early_check_numaq(voi
 		early_get_smp_config();
 
 	if (found_numaq) {
-		x86_quirks = &numaq_x86_quirks;
 		platform_setup.quirks.mpc_record = numaq_mpc_record;
 		platform_setup.mpparse.setup_ioapic_ids = platform_setup_noop;
 		platform_setup.mpparse.mpc_apic_id = mpc_apic_id;
 		platform_setup.mpparse.smp_read_mpc_oem	= smp_read_mpc_oem;
 		platform_setup.mpparse.mpc_oem_pci_bus = mpc_oem_pci_bus;
 		platform_setup.mpparse.mpc_oem_bus_info	= mpc_oem_bus_info;
+		platform_setup.tsc_pre_init = numaq_tsc_init;
 	}
 }
 
Index: linux-2.6/arch/x86/kernel/paravirt.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/paravirt.c
+++ linux-2.6/arch/x86/kernel/paravirt.c
@@ -306,7 +306,6 @@ struct pv_init_ops pv_init_ops = {
 };
 
 struct pv_time_ops pv_time_ops = {
-	.time_init = hpet_time_init,
 	.get_wallclock = native_get_wallclock,
 	.set_wallclock = native_set_wallclock,
 	.sched_clock = native_sched_clock,
Index: linux-2.6/arch/x86/kernel/platform_setup.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/platform_setup.c
+++ linux-2.6/arch/x86/kernel/platform_setup.c
@@ -10,6 +10,7 @@
 #include <asm/setup.h>
 #include <asm/apic.h>
 #include <asm/e820.h>
+#include <asm/time.h>
 #include <asm/irq.h>
 
 void __cpuinit platform_setup_noop(void) { }
@@ -56,6 +57,8 @@ struct __initdata platform_setup_ops pla
 
 	.timers = {
 		.setup_percpu_clockev = setup_boot_APIC_clock,
+		.tsc_pre_init = platform_setup_noop,
+		.timer_init = hpet_time_init,
 	},
 
 	.quirks = {
Index: linux-2.6/arch/x86/kernel/setup.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/setup.c
+++ linux-2.6/arch/x86/kernel/setup.c
@@ -626,10 +626,6 @@ static int __init setup_elfcorehdr(char 
 early_param("elfcorehdr", setup_elfcorehdr);
 #endif
 
-static struct x86_quirks default_x86_quirks __initdata;
-
-struct x86_quirks *x86_quirks __initdata = &default_x86_quirks;
-
 #ifdef CONFIG_X86_RESERVE_LOW_64K
 static int __init dmi_low_memory_corruption(const struct dmi_system_id *d)
 {
@@ -1016,45 +1012,6 @@ void __init setup_arch(char **cmdline_p)
 
 #ifdef CONFIG_X86_32
 
-static struct irqaction irq0  = {
-	.handler = timer_interrupt,
-	.flags = IRQF_DISABLED | IRQF_NOBALANCING | IRQF_IRQPOLL | IRQF_TIMER,
-	.name = "timer"
-};
-
-/**
- * x86_quirk_pre_time_init - do any specific initialisations before.
- *
- **/
-void __init x86_quirk_pre_time_init(void)
-{
-	if (x86_quirks->arch_pre_time_init)
-		x86_quirks->arch_pre_time_init();
-}
-
-/**
- * x86_quirk_time_init - do any specific initialisations for the system timer.
- *
- * Description:
- *	Must plug the system timer interrupt source at HZ into the IRQ listed
- *	in irq_vectors.h:TIMER_IRQ
- **/
-void __init x86_quirk_time_init(void)
-{
-	if (x86_quirks->arch_time_init) {
-		/*
-		 * A nonzero return code does not mean failure, it means
-		 * that the architecture quirk does not want any
-		 * generic (timer) setup to be performed after this:
-		 */
-		if (x86_quirks->arch_time_init())
-			return;
-	}
-
-	irq0.mask = cpumask_of_cpu(0);
-	setup_irq(0, &irq0);
-}
-
 static struct resource video_ram_resource = {
 	.name	= "Video RAM area",
 	.start	= 0xa0000,
Index: linux-2.6/arch/x86/kernel/time_32.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/time_32.c
+++ linux-2.6/arch/x86/kernel/time_32.c
@@ -72,7 +72,7 @@ EXPORT_SYMBOL(profile_pc);
  * Time Stamp Counter value at the time of the timer interrupt, so that
  * we later on can estimate the time of day more exactly.
  */
-irqreturn_t timer_interrupt(int irq, void *dev_id)
+static irqreturn_t timer_interrupt(int irq, void *dev_id)
 {
 	/* Keep nmi watchdog up to date */
 	inc_irq_stat(irq0_irqs);
@@ -113,25 +113,37 @@ irqreturn_t timer_interrupt(int irq, voi
 	return IRQ_HANDLED;
 }
 
-/* Duplicate of time_init() below, with hpet_enable part added */
+static struct irqaction irq0  = {
+	.handler = timer_interrupt,
+	.flags = IRQF_DISABLED | IRQF_NOBALANCING | IRQF_IRQPOLL | IRQF_TIMER,
+	.name = "timer"
+};
+
+void __init setup_default_timer_irq(void)
+{
+	irq0.mask = cpumask_of_cpu(0);
+	setup_irq(0, &irq0);
+}
+
+/* Default timer init function */
 void __init hpet_time_init(void)
 {
 	if (!hpet_enable())
 		setup_pit_timer();
-	x86_quirk_time_init();
+	setup_default_timer_irq();
+}
+
+static void x86_late_time_init(void)
+{
+	platform_setup.timers.timer_init();
 }
 
 /*
- * This is called directly from init code; we must delay timer setup in the
- * HPET case as we can't make the decision to turn on HPET this early in the
- * boot process.
- *
- * The chosen time_init function will usually be hpet_time_init, above, but
- * in the case of virtual hardware, an alternative function may be substituted.
+ * Initialize TSC and delay the periodic timer init to
+ * late x86_late_time_init() so ioremap works.
  */
 void __init time_init(void)
 {
-	x86_quirk_pre_time_init();
 	tsc_init();
-	late_time_init = choose_time_init();
+	late_time_init = x86_late_time_init;
 }
Index: linux-2.6/arch/x86/kernel/time_64.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/time_64.c
+++ linux-2.6/arch/x86/kernel/time_64.c
@@ -19,6 +19,7 @@
 #include <linux/mca.h>
 #include <linux/nmi.h>
 
+#include <asm/platform.h>
 #include <asm/i8253.h>
 #include <asm/hpet.h>
 #include <asm/vgtod.h>
@@ -127,9 +128,13 @@ void __init hpet_time_init(void)
 	setup_irq(0, &irq0);
 }
 
+static void x86_late_time_init(void)
+{
+	platform_setup.timers.timer_init();
+}
+
 void __init time_init(void)
 {
 	tsc_init();
-
-	late_time_init = choose_time_init();
+	late_time_init = x86_late_time_init;
 }
Index: linux-2.6/arch/x86/kernel/tsc.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/tsc.c
+++ linux-2.6/arch/x86/kernel/tsc.c
@@ -857,6 +857,8 @@ void __init tsc_init(void)
 	u64 lpj;
 	int cpu;
 
+	platform_setup.timers.tsc_pre_init();
+
 	if (!cpu_has_tsc)
 		return;
 
Index: linux-2.6/arch/x86/kernel/visws_quirks.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/visws_quirks.c
+++ linux-2.6/arch/x86/kernel/visws_quirks.c
@@ -30,6 +30,7 @@
 #include <asm/setup.h>
 #include <asm/apic.h>
 #include <asm/e820.h>
+#include <asm/time.h>
 #include <asm/io.h>
 
 #include <linux/kernel_stat.h>
@@ -53,8 +54,10 @@ int is_visws_box(void)
 	return visws_board_type >= 0;
 }
 
-static int __init visws_time_init(void)
+static void __init visws_time_init(void)
 {
+	hpet_time_init();
+
 	printk(KERN_INFO "Starting Cobalt Timer system clock\n");
 
 	/* Set the countdown value */
@@ -65,12 +68,6 @@ static int __init visws_time_init(void)
 
 	/* Enable (unmask) the timer interrupt */
 	co_cpu_write(CO_CPU_CTRL, co_cpu_read(CO_CPU_CTRL) & ~CO_CTRL_TIMEMASK);
-
-	/*
-	 * Zero return means the generic timer setup code will set up
-	 * the standard vector:
-	 */
-	return 0;
 }
 
 /* Replaces the default init_ISA_irqs in the generic setup */
@@ -226,10 +223,6 @@ static void __init visws_find_smp_config
 
 static void visws_trap_init(void);
 
-static struct x86_quirks visws_x86_quirks __initdata = {
-	.arch_time_init		= visws_time_init,
-};
-
 void __init visws_early_detect(void)
 {
 	int raw;
@@ -241,17 +234,14 @@ void __init visws_early_detect(void)
 		return;
 
 	/*
-	 * Install special quirks for timer, interrupt and memory setup:
-	 * Fall back to generic behavior for traps:
-	 * Override generic MP-table parsing:
+	 * Override the default platform setup functions
 	 */
-	x86_quirks = &visws_x86_quirks;
-
 	platform_setup.resources.memory_setup = visws_memory_setup;
 	platform_setup.mpparse.get_smp_config = visws_get_smp_config;
 	platform_setup.mpparse.find_smp_config = visws_find_smp_config;
 	platform_setup.irqs.pre_vector_init = visws_pre_intr_init;
 	platform_setup.irqs.trap_init = visws_trap_init;
+	platform_setup.timers.timer_init = visws_time_init;
 
 	/*
 	 * Install reboot quirks:
Index: linux-2.6/arch/x86/kernel/vmi_32.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/vmi_32.c
+++ linux-2.6/arch/x86/kernel/vmi_32.c
@@ -817,7 +817,7 @@ static inline int __init activate_vmi(vo
 		vmi_timer_ops.set_alarm = vmi_get_function(VMI_CALL_SetAlarm);
 		vmi_timer_ops.cancel_alarm =
 			 vmi_get_function(VMI_CALL_CancelAlarm);
-		pv_time_ops.time_init = vmi_time_init;
+		platform_setup.timers.timer_init = vmi_time_init;
 		pv_time_ops.get_wallclock = vmi_get_wallclock;
 		pv_time_ops.set_wallclock = vmi_set_wallclock;
 #ifdef CONFIG_X86_LOCAL_APIC
Index: linux-2.6/arch/x86/lguest/boot.c
===================================================================
--- linux-2.6.orig/arch/x86/lguest/boot.c
+++ linux-2.6/arch/x86/lguest/boot.c
@@ -1320,11 +1320,11 @@ __init void lguest_init(void)
 
 	/* Time operations */
 	pv_time_ops.get_wallclock = lguest_get_wallclock;
-	pv_time_ops.time_init = lguest_time_init;
 	pv_time_ops.get_tsc_khz = lguest_tsc_khz;
 
 	platform_setup.resources.memory_setup = lguest_memory_setup;
 	platform_setup.irqs.intr_init = lguest_init_IRQ;
+	platform_setup.timers.timer_init = lguest_time_init;
 
 	/*
 	 * Now is a good time to look at the implementations of these functions
Index: linux-2.6/arch/x86/xen/enlighten.c
===================================================================
--- linux-2.6.orig/arch/x86/xen/enlighten.c
+++ linux-2.6/arch/x86/xen/enlighten.c
@@ -842,8 +842,6 @@ static const struct pv_init_ops xen_init
 };
 
 static const struct pv_time_ops xen_time_ops __initdata = {
-	.time_init = xen_time_init,
-
 	.set_wallclock = xen_set_wallclock,
 	.get_wallclock = xen_get_wallclock,
 	.get_tsc_khz = xen_tsc_khz,
@@ -982,6 +980,8 @@ asmlinkage void __init xen_start_kernel(
 	platform_setup.oem.arch_setup = xen_arch_setup;
 	platform_setup.oem.banner = xen_banner;
 
+	platform_setup.timers.timer_init = xen_time_init;
+
 	/* Override the default per cpu clockevents setup functions */
 	platform_setup.timers.setup_percpu_clockev = platform_setup_noop;
 	platform_cpuhotplug_setup.setup_percpu_clockev = platform_setup_noop;


