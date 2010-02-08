Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753663Ab0BHIxd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Feb 2010 03:53:33 -0500
Received: from hera.kernel.org ([140.211.167.34]:59567 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752075Ab0BHIx0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Feb 2010 03:53:26 -0500
Date: Mon, 8 Feb 2010 08:51:57 GMT
From: tip-bot for Don Zickus <dzickus@redhat.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       tglx@linutronix.de, dzickus@redhat.com, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       tglx@linutronix.de, dzickus@redhat.com, mingo@elte.hu
In-Reply-To: <1265424425-31562-3-git-send-email-dzickus@redhat.com>
References: <1265424425-31562-3-git-send-email-dzickus@redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/nmi] nmi_watchdog: Add new, generic implementation, using perf events
Message-ID: <tip-1fb9d6ad2766a1dd70d167552988375049a97f21@git.kernel.org>
Git-Commit-ID: 1fb9d6ad2766a1dd70d167552988375049a97f21
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Mon, 08 Feb 2010 08:51:58 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  1fb9d6ad2766a1dd70d167552988375049a97f21
Gitweb:     http://git.kernel.org/tip/1fb9d6ad2766a1dd70d167552988375049a97f21
Author:     Don Zickus <dzickus@redhat.com>
AuthorDate: Fri, 5 Feb 2010 21:47:04 -0500
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Mon, 8 Feb 2010 08:29:02 +0100

nmi_watchdog: Add new, generic implementation, using perf events

This is a new generic nmi_watchdog implementation using the perf
events infrastructure as suggested by Ingo.

The implementation is simple, just create an in-kernel perf
event and register an overflow handler to check for cpu lockups.

I created a generic implementation that lives in kernel/ and
the hardware specific part that for now lives in arch/x86.

This approach has a number of advantages:

 - It simplifies the x86 PMU implementation in the long run,
   in that it removes the hardcoded low-level PMU implementation
   that was the NMI watchdog before.

 - It allows new NMI watchdog features to be added in a central
   place.

 - It allows other architectures to enable the NMI watchdog,
   as long as they have perf events (that provide NMIs)
   implemented.

 - It also allows for more graceful co-existence of existing
   perf events apps and the NMI watchdog - before these changes
   the relationship was exclusive. (The NMI watchdog will 'spend'
   a perf event when enabled. In later iterations we might be
   able to piggyback from an existing NMI event without having
   to allocate a hardware event for the NMI watchdog - turning
   this into a no-hardware-cost feature.)

As for compatibility, we'll keep the old NMI watchdog code as
well until the new one can 100% replace it on all CPUs, old and
new alike.  That might take some time as the NMI watchdog has
been ported to many CPU models.

I have done light testing to make sure the framework works
correctly and it does.

 v2: Set the correct timeout values based on the old nmi
     watchdog

Signed-off-by: Don Zickus <dzickus@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: gorcunov@gmail.com
Cc: aris@redhat.com
Cc: peterz@infradead.org
LKML-Reference: <1265424425-31562-3-git-send-email-dzickus@redhat.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/kernel/apic/hw_nmi.c |  114 ++++++++++++++++++++++++
 kernel/nmi_watchdog.c         |  191 +++++++++++++++++++++++++++++++++++++++++
 2 files changed, 305 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/apic/hw_nmi.c b/arch/x86/kernel/apic/hw_nmi.c
new file mode 100644
index 0000000..8c0e6a4
--- /dev/null
+++ b/arch/x86/kernel/apic/hw_nmi.c
@@ -0,0 +1,114 @@
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
+        return per_cpu(irq_stat, cpu).apic_timer_irqs +
+                per_cpu(irq_stat, cpu).irq0_irqs;
+}
+
+static inline int mce_in_progress(void)
+{
+#if defined(CONFIG_X86_MCE)
+        return atomic_read(&mce_entry) > 0;
+#endif
+        return 0;
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
+        /* Could check oops_in_progress here too, but it's safer not to */
+        if (mce_in_progress())
+                return 0;
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
+
+/* STUB calls to mimic old nmi_watchdog behaviour */
+unsigned int nmi_watchdog = NMI_NONE;
+EXPORT_SYMBOL(nmi_watchdog);
+atomic_t nmi_active = ATOMIC_INIT(0);           /* oprofile uses this */
+EXPORT_SYMBOL(nmi_active);
+int nmi_watchdog_enabled;
+int unknown_nmi_panic;
+void cpu_nmi_set_wd_enabled(void) { return; }
+void acpi_nmi_enable(void) { return; }
+void acpi_nmi_disable(void) { return; }
+void stop_apic_nmi_watchdog(void *unused) { return; }
+void setup_apic_nmi_watchdog(void *unused) { return; }
+int __init check_nmi_watchdog(void) { return 0; }
diff --git a/kernel/nmi_watchdog.c b/kernel/nmi_watchdog.c
new file mode 100644
index 0000000..36817b2
--- /dev/null
+++ b/kernel/nmi_watchdog.c
@@ -0,0 +1,191 @@
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
+#ifdef CONFIG_SYSCTL
+/*
+ * proc handler for /proc/sys/kernel/nmi_watchdog
+ */
+int proc_nmi_enabled(struct ctl_table *table, int write,
+		     void __user *buffer, size_t *length, loff_t *ppos)
+{
+	int cpu;
+
+	if (per_cpu(nmi_watchdog_ev, smp_processor_id()) == NULL)
+		nmi_watchdog_enabled = 0;
+	else
+		nmi_watchdog_enabled = 1;
+
+	touch_all_nmi_watchdog();
+	proc_dointvec(table, write, buffer, length, ppos);
+	if (nmi_watchdog_enabled)
+		for_each_online_cpu(cpu)
+			perf_event_enable(per_cpu(nmi_watchdog_ev, cpu));
+	else
+		for_each_online_cpu(cpu)
+			perf_event_disable(per_cpu(nmi_watchdog_ev, cpu));
+	return 0;
+}
+
+#endif /* CONFIG_SYSCTL */
+
+struct perf_event_attr wd_attr = {
+	.type = PERF_TYPE_HARDWARE,
+	.config = PERF_COUNT_HW_CPU_CYCLES,
+	.size = sizeof(struct perf_event_attr),
+	.pinned = 1,
+	.disabled = 1,
+};
+
+static int panic_on_timeout;
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
+		per_cpu(alert_counter,cpu) += 1;
+		if (per_cpu(alert_counter,cpu) == 5) {
+			/*
+			 * die_nmi will return ONLY if NOTIFY_STOP happens..
+			 */
+			die_nmi("BUG: NMI Watchdog detected LOCKUP",
+				regs, panic_on_timeout);
+		}
+	} else {
+		per_cpu(alert_counter,cpu) = 0;
+	}
+
+	return;
+}
+
+/*
+ * Create/destroy watchdog threads as CPUs come and go:
+ */
+static int __cpuinit
+cpu_callback(struct notifier_block *nfb, unsigned long action, void *hcpu)
+{
+	int hotcpu = (unsigned long)hcpu;
+	struct perf_event *event;
+
+	switch (action) {
+	case CPU_UP_PREPARE:
+	case CPU_UP_PREPARE_FROZEN:
+		per_cpu(nmi_watchdog_touch, hotcpu) = 0;
+		break;
+	case CPU_ONLINE:
+	case CPU_ONLINE_FROZEN:
+		/* originally wanted the below chunk to be in CPU_UP_PREPARE, but caps is unpriv for non-CPU0 */
+		wd_attr.sample_period = cpu_khz * 1000;
+		event = perf_event_create_kernel_counter(&wd_attr, hotcpu, -1, wd_overflow);
+		if (IS_ERR(event)) {
+			printk(KERN_ERR "nmi watchdog failed to create perf event on %i: %p\n", hotcpu, event);
+			return NOTIFY_BAD;
+		}
+		per_cpu(nmi_watchdog_ev, hotcpu) = event;
+		perf_event_enable(per_cpu(nmi_watchdog_ev, hotcpu));
+		break;
+#ifdef CONFIG_HOTPLUG_CPU
+	case CPU_UP_CANCELED:
+	case CPU_UP_CANCELED_FROZEN:
+		perf_event_disable(per_cpu(nmi_watchdog_ev, hotcpu));
+	case CPU_DEAD:
+	case CPU_DEAD_FROZEN:
+		event = per_cpu(nmi_watchdog_ev, hotcpu);
+		per_cpu(nmi_watchdog_ev, hotcpu) = NULL;
+		perf_event_release_kernel(event);
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
