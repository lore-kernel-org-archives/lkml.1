Return-Path: <linux-kernel-owner+w=401wt.eu-S1760124AbYFLKbQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760124AbYFLKbQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2008 06:31:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759590AbYFLK3Z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Jun 2008 06:29:25 -0400
Received: from www.tglx.de ([62.245.132.106]:59830 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759572AbYFLK3X (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2008 06:29:23 -0400
Message-Id: <20080610171712.465591661@linutronix.de>
References: <20080610171639.551369443@linutronix.de>
User-Agent: quilt/0.46-1
Date: Thu, 12 Jun 2008 10:29:00 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Arjan van de Veen <arjan@infradead.org>,
       Andreas Herrmann <andreas.herrmann3@amd.com>
Subject: [patch 6/6] x86: add c1e aware idle function
Content-Disposition: inline;
	filename=0006-31a3761dc561e16ed154bb099ef79acee4457ff8.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

C1E on AMD machines is like C3 but without control from the OS. Up to
now we disabled the local apic timer for those machines as it stops
when the CPU goes into C1E. This excludes those machines from high
resolution timers / dynamic ticks, which hurts especially the X2 based
laptops.

The current boot time C1E detection has another more serious flaw:
some BIOSes do not enable C1E until the ACPI processor module is
loaded. This causes systems to stop working after that point.

To work nicely with C1E enabled machines we use a separate idle
function, which checks on idle entry whether C1E was enabled in the
Interrupt Pending Message MSR. This allows us to do timer broadcasting
for C1E and covers the late enablement of C1E as well.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Andreas Herrmann <andreas.herrmann3@amd.com>

---
 arch/x86/kernel/apic_32.c    |    5 +--
 arch/x86/kernel/apic_64.c    |   26 ----------------
 arch/x86/kernel/cpu/amd.c    |   30 -------------------
 arch/x86/kernel/process.c    |   66 +++++++++++++++++++++++++++++++++++++++++++
 arch/x86/kernel/setup_64.c   |   25 ----------------
 include/asm-x86/apic.h       |    3 -
 kernel/time/tick-broadcast.c |    6 ++-
 7 files changed, 73 insertions(+), 88 deletions(-)

Index: linux-2.6/arch/x86/kernel/apic_32.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/apic_32.c
+++ linux-2.6/arch/x86/kernel/apic_32.c
@@ -64,9 +64,8 @@ static int enable_local_apic __initdata;
 
 /* Local APIC timer verification ok */
 static int local_apic_timer_verify_ok;
-/* Disable local APIC timer from the kernel commandline or via dmi quirk
-   or using CPU MSR check */
-int local_apic_timer_disabled;
+/* Disable local APIC timer from the kernel commandline or via dmi quirk */
+static int local_apic_timer_disabled;
 /* Local APIC timer works in C2 */
 int local_apic_timer_c2_ok;
 EXPORT_SYMBOL_GPL(local_apic_timer_c2_ok);
Index: linux-2.6/arch/x86/kernel/apic_64.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/apic_64.c
+++ linux-2.6/arch/x86/kernel/apic_64.c
@@ -43,7 +43,7 @@
 #include <mach_ipi.h>
 #include <mach_apic.h>
 
-int disable_apic_timer __cpuinitdata;
+static int disable_apic_timer __cpuinitdata;
 static int apic_calibrate_pmtmr __initdata;
 int disable_apic;
 
@@ -422,32 +422,8 @@ void __init setup_boot_APIC_clock(void)
 	setup_APIC_timer();
 }
 
-/*
- * AMD C1E enabled CPUs have a real nasty problem: Some BIOSes set the
- * C1E flag only in the secondary CPU, so when we detect the wreckage
- * we already have enabled the boot CPU local apic timer. Check, if
- * disable_apic_timer is set and the DUMMY flag is cleared. If yes,
- * set the DUMMY flag again and force the broadcast mode in the
- * clockevents layer.
- */
-static void __cpuinit check_boot_apic_timer_broadcast(void)
-{
-	if (!disable_apic_timer ||
-	    (lapic_clockevent.features & CLOCK_EVT_FEAT_DUMMY))
-		return;
-
-	printk(KERN_INFO "AMD C1E detected late. Force timer broadcast.\n");
-	lapic_clockevent.features |= CLOCK_EVT_FEAT_DUMMY;
-
-	local_irq_enable();
-	clockevents_notify(CLOCK_EVT_NOTIFY_BROADCAST_FORCE,
-			   &boot_cpu_physical_apicid);
-	local_irq_disable();
-}
-
 void __cpuinit setup_secondary_APIC_clock(void)
 {
-	check_boot_apic_timer_broadcast();
 	setup_APIC_timer();
 }
 
Index: linux-2.6/arch/x86/kernel/cpu/amd.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/cpu/amd.c
+++ linux-2.6/arch/x86/kernel/cpu/amd.c
@@ -24,31 +24,6 @@
 extern void vide(void);
 __asm__(".align 4\nvide: ret");
 
-#ifdef CONFIG_X86_LOCAL_APIC
-
-/* AMD systems with C1E don't have a working lAPIC timer. Check for that. */
-static __cpuinit int amd_apic_timer_broken(struct cpuinfo_x86 *c)
-{
-	u32 lo, hi;
-
-	if (c->x86 < 0x0F)
-		return 0;
-
-	/* Family 0x0f models < rev F do not have this MSR */
-	if (c->x86 == 0x0f && c->x86_model < 0x40)
-		return 0;
-
-	rdmsr(MSR_K8_INT_PENDING_MSG, lo, hi);
-	if (lo & K8_INTP_C1E_ACTIVE_MASK) {
-		if (smp_processor_id() != boot_cpu_physical_apicid)
-			printk(KERN_INFO "AMD C1E detected late. "
-			       "Force timer broadcast.\n");
-		return 1;
-	}
-	return 0;
-}
-#endif
-
 int force_mwait __cpuinitdata;
 
 static void __cpuinit early_init_amd(struct cpuinfo_x86 *c)
@@ -285,11 +260,6 @@ static void __cpuinit init_amd(struct cp
 			num_cache_leaves = 3;
 	}
 
-#ifdef CONFIG_X86_LOCAL_APIC
-	if (amd_apic_timer_broken(c))
-		local_apic_timer_disabled = 1;
-#endif
-
 	/* K6s reports MCEs but don't actually have all the MSRs */
 	if (c->x86 < 6)
 		clear_cpu_cap(c, X86_FEATURE_MCE);
Index: linux-2.6/arch/x86/kernel/process.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/process.c
+++ linux-2.6/arch/x86/kernel/process.c
@@ -6,6 +6,7 @@
 #include <linux/sched.h>
 #include <linux/module.h>
 #include <linux/pm.h>
+#include <linux/clockchips.h>
 
 struct kmem_cache *task_xstate_cachep;
 
@@ -219,6 +220,68 @@ static int __cpuinit mwait_usable(const 
 	return edx & MWAIT_EDX_C1;
 }
 
+/*
+ * Check for AMD CPUs, which have potentially C1E support
+ */
+static int __cpuinit check_c1e_idle(const struct cpuinfo_x86 *c)
+{
+	if (c->x86_vendor != X86_VENDOR_AMD)
+		return 0;
+
+	if (c->x86 < 0x0F)
+		return 0;
+
+	/* Family 0x0f models < rev F do not have C1E */
+	if (c->x86 == 0x0f && c->x86_model < 0x40)
+		return 0;
+
+	return 1;
+}
+
+/*
+ * C1E aware idle routine. We check for C1E active in the interrupt
+ * pending message MSR. If we detect C1E, then we handle it the same
+ * way as C3 power states (local apic timer and TSC stop)
+ */
+static void c1e_idle(void)
+{
+	static cpumask_t c1e_mask = CPU_MASK_NONE;
+	static int c1e_detected;
+
+	if (need_resched())
+		return;
+
+	if (!c1e_detected) {
+		u32 lo, hi;
+
+		rdmsr(MSR_K8_INT_PENDING_MSG, lo, hi);
+		if (lo & K8_INTP_C1E_ACTIVE_MASK) {
+			c1e_detected = 1;
+			mark_tsc_unstable("TSC halt in C1E");
+			printk(KERN_INFO "System has C1E enabled\n");
+		}
+	}
+
+	if (c1e_detected) {
+		int cpu = smp_processor_id();
+
+		if (!cpu_isset(cpu, c1e_mask)) {
+			cpu_set(cpu, c1e_mask);
+			/* Force broadcast so ACPI can not interfere */
+			clockevents_notify(CLOCK_EVT_NOTIFY_BROADCAST_FORCE,
+					   &cpu);
+			printk(KERN_INFO "Switch to broadcast mode on CPU%d\n",
+			       cpu);
+		}
+		clockevents_notify(CLOCK_EVT_NOTIFY_BROADCAST_ENTER, &cpu);
+		default_idle();
+		local_irq_disable();
+		clockevents_notify(CLOCK_EVT_NOTIFY_BROADCAST_EXIT, &cpu);
+		local_irq_enable();
+	} else
+		default_idle();
+}
+
 void __cpuinit select_idle_routine(const struct cpuinfo_x86 *c)
 {
 #ifdef CONFIG_X86_SMP
@@ -236,6 +299,9 @@ void __cpuinit select_idle_routine(const
 		 */
 		printk(KERN_INFO "using mwait in idle threads.\n");
 		pm_idle = mwait_idle;
+	} else if (check_c1e_idle(c)) {
+		printk(KERN_INFO "using C1E aware idle routine.\n");
+		pm_idle = c1e_idle;
 	} else
 		pm_idle = default_idle;
 }
Index: linux-2.6/arch/x86/kernel/setup_64.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/setup_64.c
+++ linux-2.6/arch/x86/kernel/setup_64.c
@@ -682,28 +682,6 @@ static void __cpuinit early_init_amd_mc(
 #endif
 }
 
-/* AMD systems with C1E don't have a working lAPIC timer. Check for that. */
-static __cpuinit int amd_apic_timer_broken(struct cpuinfo_x86 *c)
-{
-	u32 lo, hi;
-
-	if (c->x86 < 0x0F)
-		return 0;
-
-	/* Family 0x0f models < rev F do not have this MSR */
-	if (c->x86 == 0x0f && c->x86_model < 0x40)
-		return 0;
-
-	rdmsr(MSR_K8_INT_PENDING_MSG, lo, hi);
-	if (lo & K8_INTP_C1E_ACTIVE_MASK) {
-		if (smp_processor_id() != boot_cpu_physical_apicid)
-			printk(KERN_INFO "AMD C1E detected late. "
-			       "Force timer broadcast.\n");
-		return 1;
-	}
-	return 0;
-}
-
 static void __cpuinit early_init_amd(struct cpuinfo_x86 *c)
 {
 	early_init_amd_mc(c);
@@ -781,9 +759,6 @@ static void __cpuinit init_amd(struct cp
 	if (c->x86 == 0x10)
 		fam10h_check_enable_mmcfg();
 
-	if (amd_apic_timer_broken(c))
-		disable_apic_timer = 1;
-
 	if (c == &boot_cpu_data && c->x86 >= 0xf && c->x86 <= 0x11) {
 		unsigned long long tseg;
 
Index: linux-2.6/include/asm-x86/apic.h
===================================================================
--- linux-2.6.orig/include/asm-x86/apic.h
+++ linux-2.6/include/asm-x86/apic.h
@@ -38,12 +38,9 @@ extern void generic_apic_probe(void);
 extern int apic_verbosity;
 extern int timer_over_8254;
 extern int local_apic_timer_c2_ok;
-extern int local_apic_timer_disabled;
 
-extern int apic_runs_main_timer;
 extern int ioapic_force;
 extern int disable_apic;
-extern int disable_apic_timer;
 
 /*
  * Basic functions accessing APICs.
Index: linux-2.6/kernel/time/tick-broadcast.c
===================================================================
--- linux-2.6.orig/kernel/time/tick-broadcast.c
+++ linux-2.6/kernel/time/tick-broadcast.c
@@ -30,6 +30,7 @@
 struct tick_device tick_broadcast_device;
 static cpumask_t tick_broadcast_mask;
 static DEFINE_SPINLOCK(tick_broadcast_lock);
+static int tick_broadcast_force;
 
 #ifdef CONFIG_TICK_ONESHOT
 static void tick_broadcast_clear_oneshot(int cpu);
@@ -232,10 +233,11 @@ static void tick_do_broadcast_on_off(voi
 						     CLOCK_EVT_MODE_SHUTDOWN);
 		}
 		if (*reason == CLOCK_EVT_NOTIFY_BROADCAST_FORCE)
-			dev->features |= CLOCK_EVT_FEAT_DUMMY;
+			tick_broadcast_force = 1;
 		break;
 	case CLOCK_EVT_NOTIFY_BROADCAST_OFF:
-		if (cpu_isset(cpu, tick_broadcast_mask)) {
+		if (!tick_broadcast_force &&
+		    cpu_isset(cpu, tick_broadcast_mask)) {
 			cpu_clear(cpu, tick_broadcast_mask);
 			if (td->mode == TICKDEV_MODE_PERIODIC)
 				tick_setup_periodic(dev, 0);

-- 

