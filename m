Return-Path: <linux-kernel-owner+w=401wt.eu-S1757156AbZASBUL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757156AbZASBUL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Jan 2009 20:20:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755673AbZASBT6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 Jan 2009 20:19:58 -0500
Received: from fg-out-1718.google.com ([72.14.220.152]:26592 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755538AbZASBT5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Jan 2009 20:19:57 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:cc:subject;
        b=Obc+etMkE/c4jBAlZdzJrbVDfGAPIp9G+xzlbi/aB5eJvm5zI9eFJSs6qb6KGPDH3y
         xX57g2dOg1ukTU3L0qlAmYt2IVc7lcN55HE+PgQ9/FLA01l0skzehSvAG96XX5whLHrT
         tcPZXsx2gCqYaAgyscMfoojMRIOl0Av65s/hU=
Message-ID: <4973d53a.0e0f660a.0847.1c47@mx.google.com>
Date: Sun, 18 Jan 2009 17:19:54 -0800 (PST)
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Steven Rostedt <rostedt@goodmis.org>
Subject: [PATCH v2] ftrace based hard lockup detector
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Sorry, I forgot the function tracer dependency]
--
Like the NMI watchdog, this feature try to detect hard lockups by
lurking at the non-progress of the timer interrupts.

You can enable it at boot time by passing the ftrace_hardlockup parameter.
I plan to add a debugfs file to enable/disable at runtime.

When a hardlockup is detected, it will print a backtrace. Perhaps it
would be good to print the locks held from lockdep too?

It only support x86 for the moment, because a kind

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
---
 Documentation/kernel-parameters.txt |    4 +
 arch/x86/Kconfig.debug              |   15 ++++-
 arch/x86/include/asm/nmi.h          |   15 +++++
 arch/x86/kernel/Makefile            |    2 +
 arch/x86/kernel/ftrace_hardlockup.c |  115 +++++++++++++++++++++++++++++++++++
 arch/x86/kernel/nmi.c               |   14 ----
 include/linux/seqlock.h             |    6 ++
 7 files changed, 156 insertions(+), 15 deletions(-)
 create mode 100644 arch/x86/kernel/ftrace_hardlockup.c

diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
index ac613a6..9881426 100644
--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -774,6 +774,10 @@ and is between 256 and 4096 characters. It is defined in the file
 	ftrace_dump_on_oops
 			[ftrace] will dump the trace buffers on oops.
 
+	ftrace_hardlockup
+			[ftrace] will hook most of the kernel functions and
+			try to detect hard lockups.
+
 	gamecon.map[2|3]=
 			[HW,JOY] Multisystem joystick and NES/SNES/PSX pad
 			support via parallel port (up to 5 devices per port)
diff --git a/arch/x86/Kconfig.debug b/arch/x86/Kconfig.debug
index 097d79a..33ae6c5 100644
--- a/arch/x86/Kconfig.debug
+++ b/arch/x86/Kconfig.debug
@@ -367,5 +367,18 @@ config OPTIMIZE_INLINING
 
 	  If unsure, say N.
 
-endmenu
+config FTRACE_HARLOCKUPS_DETECT
+	bool "Ftrace based hard-lockup detection"
+	select FUNCTION_TRACER
+	help
+	  This options makes ftrace hooking most of the kernel functions, trying to
+	  detect a hard lockup and then print a backtrace if so. Its check is
+	  similar to the one performed by the nmi watchdog which lurks in the
+	  non-progress of the timer interrupts. By default it is not enabled.
+	  If you want to launch it, add the ftrace_hardlockup kernel parameter.
 
+	  Enabling this option will bring almost no overhead, assuming you
+	  enabled CONFIG_DYNAMIC_FTRACE. But once you activate it through the
+	  ftrace_hardlockup parameter, your system will be a bit slower.
+
+endmenu
diff --git a/arch/x86/include/asm/nmi.h b/arch/x86/include/asm/nmi.h
index c45a0a5..9177b60 100644
--- a/arch/x86/include/asm/nmi.h
+++ b/arch/x86/include/asm/nmi.h
@@ -48,6 +48,21 @@ extern int unknown_nmi_panic;
 void __trigger_all_cpu_backtrace(void);
 #define trigger_all_cpu_backtrace() __trigger_all_cpu_backtrace()
 
+/*
+ * Take the local apic timer and PIT/HPET into account. We don't
+ * know which one is active, when we have highres/dyntick on
+ */
+static inline unsigned int get_timer_irqs(int cpu)
+{
+#ifdef CONFIG_X86_64
+	return read_pda(apic_timer_irqs) + read_pda(irq0_irqs);
+#else
+	return per_cpu(irq_stat, cpu).apic_timer_irqs +
+		per_cpu(irq_stat, cpu).irq0_irqs;
+#endif
+}
+
+
 static inline void localise_nmi_watchdog(void)
 {
 	if (nmi_watchdog == NMI_IO_APIC)
diff --git a/arch/x86/kernel/Makefile b/arch/x86/kernel/Makefile
index eb07453..c488d76 100644
--- a/arch/x86/kernel/Makefile
+++ b/arch/x86/kernel/Makefile
@@ -13,6 +13,7 @@ CFLAGS_REMOVE_rtc.o = -pg
 CFLAGS_REMOVE_paravirt-spinlocks.o = -pg
 CFLAGS_REMOVE_ftrace.o = -pg
 CFLAGS_REMOVE_early_printk.o = -pg
+CFLAGS_REMOVE_ftrace_hardlockup.o = -pg
 endif
 
 #
@@ -68,6 +69,7 @@ obj-$(CONFIG_X86_IO_APIC)	+= io_apic.o
 obj-$(CONFIG_X86_REBOOTFIXUPS)	+= reboot_fixups_32.o
 obj-$(CONFIG_DYNAMIC_FTRACE)	+= ftrace.o
 obj-$(CONFIG_FUNCTION_GRAPH_TRACER)	+= ftrace.o
+obj-$(CONFIG_FTRACE_HARLOCKUPS_DETECT) += ftrace_hardlockup.o
 obj-$(CONFIG_KEXEC)		+= machine_kexec_$(BITS).o
 obj-$(CONFIG_KEXEC)		+= relocate_kernel_$(BITS).o crash.o
 obj-$(CONFIG_CRASH_DUMP)	+= crash_dump_$(BITS).o
diff --git a/arch/x86/kernel/ftrace_hardlockup.c b/arch/x86/kernel/ftrace_hardlockup.c
new file mode 100644
index 0000000..5f61626
--- /dev/null
+++ b/arch/x86/kernel/ftrace_hardlockup.c
@@ -0,0 +1,115 @@
+/*
+ * Ftrace based Hard Lockup detector.
+ *
+ * Copyright (C) 2009 Frederic Weisbecker <fweisbec@gmail.com>
+ * Suggested by Ingo Molnar <mingo@elte.hu>
+ *
+ * Based on ideas and code of nmi.c which was
+ * started by Ingo Molnar.
+ *
+ */
+
+
+#include <linux/ftrace.h>
+#include <linux/cpumask.h>
+#include <linux/percpu.h>
+#include <linux/hrtimer.h>
+#include <linux/time.h>
+#include <asm/hardirq.h>
+#include <asm/nmi.h>
+
+
+/* Store the numbers of timer interrupts raised on one CPU. */
+struct last_timer_irq_stat {
+	int nb_irqs;
+	ktime_t last_seen;
+};
+
+static bool hardlockup_detect_enabled __read_mostly;
+
+static DEFINE_PER_CPU(struct last_timer_irq_stat, prev_timer_irqs);
+
+/* Protect from ftrace recursions */
+static DEFINE_PER_CPU(atomic_t, trace_recursion_wall);
+
+/* Mask of Cpus which already had a hard lockup backtrace printed */
+static cpumask_t backtrace_mask;
+
+
+/* The main check function */
+static void check_hardlockup(unsigned long ip, unsigned long parent_ip)
+{
+	struct last_timer_irq_stat *prev_stat;
+	atomic_t *trace_recursion_wall;
+	unsigned int nb_timer_irqs;
+	ktime_t elapsed, now;
+	int cpu;
+
+	/* We use a lot of per-cpu values here */
+	preempt_disable_notrace();
+
+	/* Protect against ftrace recursion */
+	trace_recursion_wall = &__get_cpu_var(trace_recursion_wall);
+	if (atomic_inc_return(trace_recursion_wall) != 1)
+		goto out;
+
+	/*
+	 * We use ktime_get() here. And ktime uses a read lock
+	 * on xtime_lock. So if we trace a function which holds a
+	 * write lock on xtime_lock in this CPU, we will deadlock.
+	 * Avoid it with this check.
+	 */
+	if (unlikely(write_is_seqlocked(&xtime_lock)))
+		goto out;
+
+	cpu = raw_smp_processor_id();
+
+	nb_timer_irqs = get_timer_irqs(cpu);
+	prev_stat = &__get_cpu_var(prev_timer_irqs);
+
+	if (nb_timer_irqs != prev_stat->nb_irqs) {
+		prev_stat->nb_irqs = nb_timer_irqs;
+		prev_stat->last_seen = ktime_get();
+		goto out;
+	}
+
+	now = ktime_get();
+	elapsed = ktime_sub(now, prev_stat->last_seen);
+
+	/*
+	 * Check if the timer interrupts didn't triggered for 5 secs.
+	 * Don't spend time with a div, 30 bits right is near 10^9
+	 */
+	if (ktime_to_ns(elapsed) >> 30 >= 5) {
+		/* Already printed ? */
+		if (cpu_test_and_set(cpu, backtrace_mask))
+			goto out;
+
+		printk(KERN_WARNING "ftrace: hard lockup detected\n");
+		dump_stack();
+	}
+
+out:
+	atomic_dec(trace_recursion_wall);
+	preempt_enable_no_resched_notrace();
+}
+
+static struct ftrace_ops hardlockup_detect_ops __read_mostly = {
+	.func = check_hardlockup
+};
+
+static __init int enable_ftrace_hardlockup(char *str)
+{
+	hardlockup_detect_enabled = true;
+	return 1;
+}
+__setup("ftrace_hardlockup", enable_ftrace_hardlockup);
+
+static int __init ftrace_hardlockup_init(void)
+{
+	if (hardlockup_detect_enabled)
+		register_ftrace_function(&hardlockup_detect_ops);
+
+	return 0;
+}
+device_initcall(ftrace_hardlockup_init);
diff --git a/arch/x86/kernel/nmi.c b/arch/x86/kernel/nmi.c
index 7228979..86225f8 100644
--- a/arch/x86/kernel/nmi.c
+++ b/arch/x86/kernel/nmi.c
@@ -76,20 +76,6 @@ static inline int mce_in_progress(void)
 	return 0;
 }
 
-/*
- * Take the local apic timer and PIT/HPET into account. We don't
- * know which one is active, when we have highres/dyntick on
- */
-static inline unsigned int get_timer_irqs(int cpu)
-{
-#ifdef CONFIG_X86_64
-	return read_pda(apic_timer_irqs) + read_pda(irq0_irqs);
-#else
-	return per_cpu(irq_stat, cpu).apic_timer_irqs +
-		per_cpu(irq_stat, cpu).irq0_irqs;
-#endif
-}
-
 #ifdef CONFIG_SMP
 /*
  * The performance counters used by NMI_LOCAL_APIC don't trigger when
diff --git a/include/linux/seqlock.h b/include/linux/seqlock.h
index 632205c..545cb85 100644
--- a/include/linux/seqlock.h
+++ b/include/linux/seqlock.h
@@ -82,6 +82,12 @@ static inline int write_tryseqlock(seqlock_t *sl)
 	return ret;
 }
 
+static inline int write_is_seqlocked(seqlock_t *sl)
+{
+	return spin_is_locked(&sl->lock);
+}
+
+
 /* Start of read calculation -- fetch last complete writer token */
 static __always_inline unsigned read_seqbegin(const seqlock_t *sl)
 {
-- 
1.6.0.4


