Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751495Ab0CAT1t (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Mar 2010 14:27:49 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:36277 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751293Ab0CAT1r (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Mar 2010 14:27:47 -0500
Date: Mon, 1 Mar 2010 20:27:34 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] generic NMI watchdog for v2.6.34
Message-ID: <20100301192734.GA1739@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please consider pulling the perf-nmi-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git perf-nmi-for-linus

This tree adds a generic implementation of the x86 'NMI watchdog', in 
kernel/nmi_watchdog.c. This is based on struct perf_event and hence will allow 
the gradual phasing-out of the arch/x86/kernel/cpu/perfctr-watchdog.c code.

We placed it in kernel/ to enable other architectures to make use of it as 
well in the future. An architecture can enable it by providing the 
PERF_EVENTS_NMI Kconfig switch.

 Thanks,

	Ingo

------------------>
Don Zickus (10):
      x86: Move notify_die from nmi.c to traps.c
      nmi_watchdog: Add new, generic implementation, using perf events
      nmi_watchdog: Config option to enable new nmi_watchdog
      nmi_watchdog: Use a boolean config flag for compiling
      nmi_watchdog: Compile and portability fixes
      nmi_watchdog: Fallback to software events when no hardware pmu detected
      nmi_watchdog: support for oprofile
      nmi_watchdog: Properly configure for software events
      nmi_watchdog: Fix undefined 'apic' build bug
      nmi_watchdog: Clean up various small details

Ingo Molnar (2):
      nmi_watchdog: Only enable on x86 for now
      nmi_watchdog: Turn it off by default


 arch/x86/Kconfig              |    1 +
 arch/x86/include/asm/nmi.h    |    2 +
 arch/x86/kernel/apic/Makefile |    7 +-
 arch/x86/kernel/apic/hw_nmi.c |  127 ++++++++++++++++++++
 arch/x86/kernel/apic/nmi.c    |    7 -
 arch/x86/kernel/traps.c       |    7 +
 include/linux/nmi.h           |   13 ++
 init/Kconfig                  |    5 +
 kernel/Makefile               |    1 +
 kernel/nmi_watchdog.c         |  257 +++++++++++++++++++++++++++++++++++++++++
 kernel/sysctl.c               |   15 +++-
 lib/Kconfig.debug             |   12 ++
 12 files changed, 445 insertions(+), 9 deletions(-)
 create mode 100644 arch/x86/kernel/apic/hw_nmi.c
 create mode 100644 kernel/nmi_watchdog.c

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index cbcbfde..4f9685f 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -52,6 +52,7 @@ config X86
 	select HAVE_KERNEL_LZO
 	select HAVE_HW_BREAKPOINT
 	select PERF_EVENTS
+	select PERF_EVENTS_NMI
 	select ANON_INODES
 	select HAVE_ARCH_KMEMCHECK
 	select HAVE_USER_RETURN_NOTIFIER
diff --git a/arch/x86/include/asm/nmi.h b/arch/x86/include/asm/nmi.h
index 93da9c3..5b41b0f 100644
--- a/arch/x86/include/asm/nmi.h
+++ b/arch/x86/include/asm/nmi.h
@@ -17,7 +17,9 @@ int do_nmi_callback(struct pt_regs *regs, int cpu);
 
 extern void die_nmi(char *str, struct pt_regs *regs, int do_panic);
 extern int check_nmi_watchdog(void);
+#if !defined(CONFIG_NMI_WATCHDOG)
 extern int nmi_watchdog_enabled;
+#endif
 extern int avail_to_resrv_perfctr_nmi_bit(unsigned int);
 extern int reserve_perfctr_nmi(unsigned int);
 extern void release_perfctr_nmi(unsigned int);
diff --git a/arch/x86/kernel/apic/Makefile b/arch/x86/kernel/apic/Makefile
index 565c1bf..1a4512e 100644
--- a/arch/x86/kernel/apic/Makefile
+++ b/arch/x86/kernel/apic/Makefile
@@ -2,7 +2,12 @@
 # Makefile for local APIC drivers and for the IO-APIC code
 #
 
-obj-$(CONFIG_X86_LOCAL_APIC)	+= apic.o apic_noop.o probe_$(BITS).o ipi.o nmi.o
+obj-$(CONFIG_X86_LOCAL_APIC)	+= apic.o apic_noop.o probe_$(BITS).o ipi.o
+ifneq ($(CONFIG_NMI_WATCHDOG),y)
+obj-$(CONFIG_X86_LOCAL_APIC)	+= nmi.o
+endif
+obj-$(CONFIG_NMI_WATCHDOG)	+= hw_nmi.o
+
 obj-$(CONFIG_X86_IO_APIC)	+= io_apic.o
 obj-$(CONFIG_SMP)		+= ipi.o
 
diff --git a/arch/x86/kernel/apic/hw_nmi.c b/arch/x86/kernel/apic/hw_nmi.c
new file mode 100644
index 0000000..e8b78a0
--- /dev/null
+++ b/arch/x86/kernel/apic/hw_nmi.c
@@ -0,0 +1,127 @@
+/*
+ *  HW NMI watchdog support
+ *
+ *  started by Don Zickus, Copyright (C) 2010 Red Hat, Inc.
+ *
+ *  Arch specific calls to support NMI watchdog
+ *
+ *  Bits copied from original nmi.c file
+ *
+ */
+
+#include <asm/apic.h>
+#include <linux/smp.h>
+#include <linux/cpumask.h>
+#include <linux/sched.h>
+#include <linux/percpu.h>
+#include <linux/cpumask.h>
+#include <linux/kernel_stat.h>
+#include <asm/mce.h>
+
+#include <linux/nmi.h>
+#include <linux/module.h>
+
+/* For reliability, we're prepared to waste bits here. */
+static DECLARE_BITMAP(backtrace_mask, NR_CPUS) __read_mostly;
+
+static DEFINE_PER_CPU(unsigned, last_irq_sum);
+
+/*
+ * Take the local apic timer and PIT/HPET into account. We don't
+ * know which one is active, when we have highres/dyntick on
+ */
+static inline unsigned int get_timer_irqs(int cpu)
+{
+	unsigned int irqs = per_cpu(irq_stat, cpu).irq0_irqs;
+
+#if defined(CONFIG_X86_LOCAL_APIC)
+	irqs += per_cpu(irq_stat, cpu).apic_timer_irqs;
+#endif
+
+	return irqs;
+}
+
+static inline int mce_in_progress(void)
+{
+#if defined(CONFIG_X86_MCE)
+	return atomic_read(&mce_entry) > 0;
+#endif
+	return 0;
+}
+
+int hw_nmi_is_cpu_stuck(struct pt_regs *regs)
+{
+	unsigned int sum;
+	int cpu = smp_processor_id();
+
+	/* FIXME: cheap hack for this check, probably should get its own
+	 * die_notifier handler
+	 */
+	if (cpumask_test_cpu(cpu, to_cpumask(backtrace_mask))) {
+		static DEFINE_SPINLOCK(lock);	/* Serialise the printks */
+
+		spin_lock(&lock);
+		printk(KERN_WARNING "NMI backtrace for cpu %d\n", cpu);
+		show_regs(regs);
+		dump_stack();
+		spin_unlock(&lock);
+		cpumask_clear_cpu(cpu, to_cpumask(backtrace_mask));
+	}
+
+	/* if we are doing an mce, just assume the cpu is not stuck */
+	/* Could check oops_in_progress here too, but it's safer not to */
+	if (mce_in_progress())
+		return 0;
+
+	/* We determine if the cpu is stuck by checking whether any
+	 * interrupts have happened since we last checked.  Of course
+	 * an nmi storm could create false positives, but the higher
+	 * level logic should account for that
+	 */
+	sum = get_timer_irqs(cpu);
+	if (__get_cpu_var(last_irq_sum) == sum) {
+		return 1;
+	} else {
+		__get_cpu_var(last_irq_sum) = sum;
+		return 0;
+	}
+}
+
+u64 hw_nmi_get_sample_period(void)
+{
+	return cpu_khz * 1000;
+}
+
+#ifdef ARCH_HAS_NMI_WATCHDOG
+void arch_trigger_all_cpu_backtrace(void)
+{
+	int i;
+
+	cpumask_copy(to_cpumask(backtrace_mask), cpu_online_mask);
+
+	printk(KERN_INFO "sending NMI to all CPUs:\n");
+	apic->send_IPI_all(NMI_VECTOR);
+
+	/* Wait for up to 10 seconds for all CPUs to do the backtrace */
+	for (i = 0; i < 10 * 1000; i++) {
+		if (cpumask_empty(to_cpumask(backtrace_mask)))
+			break;
+		mdelay(1);
+	}
+}
+#endif
+
+/* STUB calls to mimic old nmi_watchdog behaviour */
+#if defined(CONFIG_X86_LOCAL_APIC)
+unsigned int nmi_watchdog = NMI_NONE;
+EXPORT_SYMBOL(nmi_watchdog);
+void acpi_nmi_enable(void) { return; }
+void acpi_nmi_disable(void) { return; }
+#endif
+atomic_t nmi_active = ATOMIC_INIT(0);           /* oprofile uses this */
+EXPORT_SYMBOL(nmi_active);
+int unknown_nmi_panic;
+void cpu_nmi_set_wd_enabled(void) { return; }
+void stop_apic_nmi_watchdog(void *unused) { return; }
+void setup_apic_nmi_watchdog(void *unused) { return; }
+int __init check_nmi_watchdog(void) { return 0; }
diff --git a/arch/x86/kernel/apic/nmi.c b/arch/x86/kernel/apic/nmi.c
index 0159a69..5d47682 100644
--- a/arch/x86/kernel/apic/nmi.c
+++ b/arch/x86/kernel/apic/nmi.c
@@ -400,13 +400,6 @@ nmi_watchdog_tick(struct pt_regs *regs, unsigned reason)
 	int cpu = smp_processor_id();
 	int rc = 0;
 
-	/* check for other users first */
-	if (notify_die(DIE_NMI, "nmi", regs, reason, 2, SIGINT)
-			== NOTIFY_STOP) {
-		rc = 1;
-		touched = 1;
-	}
-
 	sum = get_timer_irqs(cpu);
 
 	if (__get_cpu_var(nmi_touch)) {
diff --git a/arch/x86/kernel/traps.c b/arch/x86/kernel/traps.c
index 1168e44..bdc7fab 100644
--- a/arch/x86/kernel/traps.c
+++ b/arch/x86/kernel/traps.c
@@ -400,7 +400,13 @@ static notrace __kprobes void default_do_nmi(struct pt_regs *regs)
 		if (notify_die(DIE_NMI_IPI, "nmi_ipi", regs, reason, 2, SIGINT)
 								== NOTIFY_STOP)
 			return;
+
 #ifdef CONFIG_X86_LOCAL_APIC
+		if (notify_die(DIE_NMI, "nmi", regs, reason, 2, SIGINT)
+							== NOTIFY_STOP)
+			return;
+
+#ifndef CONFIG_NMI_WATCHDOG
 		/*
 		 * Ok, so this is none of the documented NMI sources,
 		 * so it must be the NMI watchdog.
@@ -408,6 +414,7 @@ static notrace __kprobes void default_do_nmi(struct pt_regs *regs)
 		if (nmi_watchdog_tick(regs, reason))
 			return;
 		if (!do_nmi_callback(regs, cpu))
+#endif /* !CONFIG_NMI_WATCHDOG */
 			unknown_nmi_error(reason, regs);
 #else
 		unknown_nmi_error(reason, regs);
diff --git a/include/linux/nmi.h b/include/linux/nmi.h
index b752e80..22cc796 100644
--- a/include/linux/nmi.h
+++ b/include/linux/nmi.h
@@ -20,10 +20,14 @@ extern void touch_nmi_watchdog(void);
 extern void acpi_nmi_disable(void);
 extern void acpi_nmi_enable(void);
 #else
+#ifndef CONFIG_NMI_WATCHDOG
 static inline void touch_nmi_watchdog(void)
 {
 	touch_softlockup_watchdog();
 }
+#else
+extern void touch_nmi_watchdog(void);
+#endif
 static inline void acpi_nmi_disable(void) { }
 static inline void acpi_nmi_enable(void) { }
 #endif
@@ -47,4 +51,13 @@ static inline bool trigger_all_cpu_backtrace(void)
 }
 #endif
 
+#ifdef CONFIG_NMI_WATCHDOG
+int hw_nmi_is_cpu_stuck(struct pt_regs *);
+u64 hw_nmi_get_sample_period(void);
+extern int nmi_watchdog_enabled;
+struct ctl_table;
+extern int proc_nmi_enabled(struct ctl_table *, int ,
+			void __user *, size_t *, loff_t *);
+#endif
+
 #endif
diff --git a/init/Kconfig b/init/Kconfig
index ada4844..7331a16 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -946,6 +946,11 @@ config PERF_USE_VMALLOC
 	help
 	  See tools/perf/design.txt for details
 
+config PERF_EVENTS_NMI
+	bool
+	help
+	  Arch has support for nmi_watchdog
+
 menu "Kernel Performance Events And Counters"
 
 config PERF_EVENTS
diff --git a/kernel/Makefile b/kernel/Makefile
index 864ff75..8a5abe5 100644
--- a/kernel/Makefile
+++ b/kernel/Makefile
@@ -76,6 +76,7 @@ obj-$(CONFIG_AUDIT_TREE) += audit_tree.o
 obj-$(CONFIG_KPROBES) += kprobes.o
 obj-$(CONFIG_KGDB) += kgdb.o
 obj-$(CONFIG_DETECT_SOFTLOCKUP) += softlockup.o
+obj-$(CONFIG_NMI_WATCHDOG) += nmi_watchdog.o
 obj-$(CONFIG_DETECT_HUNG_TASK) += hung_task.o
 obj-$(CONFIG_GENERIC_HARDIRQS) += irq/
 obj-$(CONFIG_SECCOMP) += seccomp.o
diff --git a/kernel/nmi_watchdog.c b/kernel/nmi_watchdog.c
new file mode 100644
index 0000000..0a6f57f
--- /dev/null
+++ b/kernel/nmi_watchdog.c
@@ -0,0 +1,257 @@
+/*
+ * Detect Hard Lockups using the NMI
+ *
+ * started by Don Zickus, Copyright (C) 2010 Red Hat, Inc.
+ *
+ * this code detects hard lockups: incidents in where on a CPU
+ * the kernel does not respond to anything except NMI.
+ *
+ * Note: Most of this code is borrowed heavily from softlockup.c,
+ * so thanks to Ingo for the initial implementation.
+ * Some chunks also taken from arch/x86/kernel/apic/nmi.c, thanks
+ * to those contributors as well.
+ */
+
+#include <linux/mm.h>
+#include <linux/cpu.h>
+#include <linux/nmi.h>
+#include <linux/init.h>
+#include <linux/delay.h>
+#include <linux/freezer.h>
+#include <linux/lockdep.h>
+#include <linux/notifier.h>
+#include <linux/module.h>
+#include <linux/sysctl.h>
+
+#include <asm/irq_regs.h>
+#include <linux/perf_event.h>
+
+static DEFINE_PER_CPU(struct perf_event *, nmi_watchdog_ev);
+static DEFINE_PER_CPU(int, nmi_watchdog_touch);
+static DEFINE_PER_CPU(long, alert_counter);
+
+static int panic_on_timeout;
+
+void touch_nmi_watchdog(void)
+{
+	__raw_get_cpu_var(nmi_watchdog_touch) = 1;
+	touch_softlockup_watchdog();
+}
+EXPORT_SYMBOL(touch_nmi_watchdog);
+
+void touch_all_nmi_watchdog(void)
+{
+	int cpu;
+
+	for_each_online_cpu(cpu)
+		per_cpu(nmi_watchdog_touch, cpu) = 1;
+	touch_softlockup_watchdog();
+}
+
+static int __init setup_nmi_watchdog(char *str)
+{
+	if (!strncmp(str, "panic", 5)) {
+		panic_on_timeout = 1;
+		str = strchr(str, ',');
+		if (!str)
+			return 1;
+		++str;
+	}
+	return 1;
+}
+__setup("nmi_watchdog=", setup_nmi_watchdog);
+
+struct perf_event_attr wd_hw_attr = {
+	.type		= PERF_TYPE_HARDWARE,
+	.config		= PERF_COUNT_HW_CPU_CYCLES,
+	.size		= sizeof(struct perf_event_attr),
+	.pinned		= 1,
+	.disabled	= 1,
+};
+
+struct perf_event_attr wd_sw_attr = {
+	.type		= PERF_TYPE_SOFTWARE,
+	.config		= PERF_COUNT_SW_CPU_CLOCK,
+	.size		= sizeof(struct perf_event_attr),
+	.pinned		= 1,
+	.disabled	= 1,
+};
+
+void wd_overflow(struct perf_event *event, int nmi,
+		 struct perf_sample_data *data,
+		 struct pt_regs *regs)
+{
+	int cpu = smp_processor_id();
+	int touched = 0;
+
+	if (__get_cpu_var(nmi_watchdog_touch)) {
+		per_cpu(nmi_watchdog_touch, cpu) = 0;
+		touched = 1;
+	}
+
+	/* check to see if the cpu is doing anything */
+	if (!touched && hw_nmi_is_cpu_stuck(regs)) {
+		/*
+		 * Ayiee, looks like this CPU is stuck ...
+		 * wait a few IRQs (5 seconds) before doing the oops ...
+		 */
+		per_cpu(alert_counter, cpu) += 1;
+		if (per_cpu(alert_counter, cpu) == 5) {
+			if (panic_on_timeout)
+				panic("NMI Watchdog detected LOCKUP on cpu %d", cpu);
+			else
+				WARN(1, "NMI Watchdog detected LOCKUP on cpu %d", cpu);
+		}
+	} else {
+		per_cpu(alert_counter, cpu) = 0;
+	}
+
+	return;
+}
+
+static int enable_nmi_watchdog(int cpu)
+{
+	struct perf_event *event;
+	struct perf_event_attr *wd_attr;
+
+	event = per_cpu(nmi_watchdog_ev, cpu);
+	if (event && event->state > PERF_EVENT_STATE_OFF)
+		return 0;
+
+	if (event == NULL) {
+		/* Try to register using hardware perf events first */
+		wd_attr = &wd_hw_attr;
+		wd_attr->sample_period = hw_nmi_get_sample_period();
+		event = perf_event_create_kernel_counter(wd_attr, cpu, -1, wd_overflow);
+		if (IS_ERR(event)) {
+			/* hardware doesn't exist or not supported, fallback to software events */
+			printk(KERN_INFO "nmi_watchdog: hardware not available, trying software events\n");
+			wd_attr = &wd_sw_attr;
+			wd_attr->sample_period = NSEC_PER_SEC;
+			event = perf_event_create_kernel_counter(wd_attr, cpu, -1, wd_overflow);
+			if (IS_ERR(event)) {
+				printk(KERN_ERR "nmi watchdog failed to create perf event on %i: %p\n", cpu, event);
+				return -1;
+			}
+		}
+		per_cpu(nmi_watchdog_ev, cpu) = event;
+	}
+	perf_event_enable(per_cpu(nmi_watchdog_ev, cpu));
+	return 0;
+}
+
+static void disable_nmi_watchdog(int cpu)
+{
+	struct perf_event *event;
+
+	event = per_cpu(nmi_watchdog_ev, cpu);
+	if (event) {
+		perf_event_disable(per_cpu(nmi_watchdog_ev, cpu));
+		per_cpu(nmi_watchdog_ev, cpu) = NULL;
+		perf_event_release_kernel(event);
+	}
+}
+
+#ifdef CONFIG_SYSCTL
+/*
+ * proc handler for /proc/sys/kernel/nmi_watchdog
+ */
+int nmi_watchdog_enabled;
+
+int proc_nmi_enabled(struct ctl_table *table, int write,
+		     void __user *buffer, size_t *length, loff_t *ppos)
+{
+	int cpu;
+
+	if (!write) {
+		struct perf_event *event;
+		for_each_online_cpu(cpu) {
+			event = per_cpu(nmi_watchdog_ev, cpu);
+			if (event && event->state > PERF_EVENT_STATE_OFF) {
+				nmi_watchdog_enabled = 1;
+				break;
+			}
+		}
+		proc_dointvec(table, write, buffer, length, ppos);
+		return 0;
+	}
+
+	touch_all_nmi_watchdog();
+	proc_dointvec(table, write, buffer, length, ppos);
+	if (nmi_watchdog_enabled) {
+		for_each_online_cpu(cpu)
+			if (enable_nmi_watchdog(cpu)) {
+				printk(KERN_ERR "NMI watchdog failed configuration, "
+					" can not be enabled\n");
+			}
+	} else {
+		for_each_online_cpu(cpu)
+			disable_nmi_watchdog(cpu);
+	}
+	return 0;
+}
+
+#endif /* CONFIG_SYSCTL */
+
+/*
+ * Create/destroy watchdog threads as CPUs come and go:
+ */
+static int __cpuinit
+cpu_callback(struct notifier_block *nfb, unsigned long action, void *hcpu)
+{
+	int hotcpu = (unsigned long)hcpu;
+
+	switch (action) {
+	case CPU_UP_PREPARE:
+	case CPU_UP_PREPARE_FROZEN:
+		per_cpu(nmi_watchdog_touch, hotcpu) = 0;
+		break;
+	case CPU_ONLINE:
+	case CPU_ONLINE_FROZEN:
+		if (enable_nmi_watchdog(hotcpu))
+			return NOTIFY_BAD;
+		break;
+#ifdef CONFIG_HOTPLUG_CPU
+	case CPU_UP_CANCELED:
+	case CPU_UP_CANCELED_FROZEN:
+		disable_nmi_watchdog(hotcpu);
+	case CPU_DEAD:
+	case CPU_DEAD_FROZEN:
+		break;
+#endif /* CONFIG_HOTPLUG_CPU */
+	}
+	return NOTIFY_OK;
+}
+
+static struct notifier_block __cpuinitdata cpu_nfb = {
+	.notifier_call = cpu_callback
+};
+
+static int __initdata nonmi_watchdog;
+
+static int __init nonmi_watchdog_setup(char *str)
+{
+	nonmi_watchdog = 1;
+	return 1;
+}
+__setup("nonmi_watchdog", nonmi_watchdog_setup);
+
+static int __init spawn_nmi_watchdog_task(void)
+{
+	void *cpu = (void *)(long)smp_processor_id();
+	int err;
+
+	if (nonmi_watchdog)
+		return 0;
+
+	err = cpu_callback(&cpu_nfb, CPU_UP_PREPARE, cpu);
+	if (err == NOTIFY_BAD) {
+		BUG();
+		return 1;
+	}
+	cpu_callback(&cpu_nfb, CPU_ONLINE, cpu);
+	register_cpu_notifier(&cpu_nfb);
+
+	return 0;
+}
+early_initcall(spawn_nmi_watchdog_task);
diff --git a/kernel/sysctl.c b/kernel/sysctl.c
index 8a68b24..ac72c9e 100644
--- a/kernel/sysctl.c
+++ b/kernel/sysctl.c
@@ -60,6 +60,10 @@
 #include <asm/io.h>
 #endif
 
+#ifdef CONFIG_NMI_WATCHDOG
+#include <linux/nmi.h>
+#endif
+
 
 #if defined(CONFIG_SYSCTL)
 
@@ -692,7 +696,16 @@ static struct ctl_table kern_table[] = {
 		.mode		= 0444,
 		.proc_handler	= proc_dointvec,
 	},
-#if defined(CONFIG_X86_LOCAL_APIC) && defined(CONFIG_X86)
+#if defined(CONFIG_NMI_WATCHDOG)
+	{
+		.procname       = "nmi_watchdog",
+		.data           = &nmi_watchdog_enabled,
+		.maxlen         = sizeof (int),
+		.mode           = 0644,
+		.proc_handler   = proc_nmi_enabled,
+	},
+#endif
+#if defined(CONFIG_X86_LOCAL_APIC) && defined(CONFIG_X86) && !defined(CONFIG_NMI_WATCHDOG)
 	{
 		.procname       = "unknown_nmi_panic",
 		.data           = &unknown_nmi_panic,
diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
index 25c3ed5..e2e73cc 100644
--- a/lib/Kconfig.debug
+++ b/lib/Kconfig.debug
@@ -170,6 +170,18 @@ config DETECT_SOFTLOCKUP
 	   can be detected via the NMI-watchdog, on platforms that
 	   support it.)
 
+config NMI_WATCHDOG
+	bool "Detect Hard Lockups with an NMI Watchdog"
+	depends on DEBUG_KERNEL && PERF_EVENTS && PERF_EVENTS_NMI
+	help
+	  Say Y here to enable the kernel to use the NMI as a watchdog
+	  to detect hard lockups.  This is useful when a cpu hangs for no
+	  reason but can still respond to NMIs.  A backtrace is displayed
+	  for reviewing and reporting.
+
+	  The overhead should be minimal, just an extra NMI every few
+	  seconds.
+
 config BOOTPARAM_SOFTLOCKUP_PANIC
 	bool "Panic (Reboot) On Soft Lockups"
 	depends on DETECT_SOFTLOCKUP
