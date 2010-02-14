Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756070Ab0BNJN4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Feb 2010 04:13:56 -0500
Received: from hera.kernel.org ([140.211.167.34]:33581 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755685Ab0BNJNu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Feb 2010 04:13:50 -0500
Date: Sun, 14 Feb 2010 09:13:01 GMT
From: tip-bot for Don Zickus <dzickus@redhat.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       tglx@linutronix.de, mingo@elte.hu, dzickus@redhat.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       tglx@linutronix.de, dzickus@redhat.com, mingo@elte.hu
In-Reply-To: <1266013161-31197-2-git-send-email-dzickus@redhat.com>
References: <1266013161-31197-2-git-send-email-dzickus@redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/nmi] nmi_watchdog: Compile and portability fixes
Message-ID: <tip-504d7cf10ee42bb76b9556859f23d4121dee0a77@git.kernel.org>
Git-Commit-ID: 504d7cf10ee42bb76b9556859f23d4121dee0a77
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Sun, 14 Feb 2010 09:13:04 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  504d7cf10ee42bb76b9556859f23d4121dee0a77
Gitweb:     http://git.kernel.org/tip/504d7cf10ee42bb76b9556859f23d4121dee0a77
Author:     Don Zickus <dzickus@redhat.com>
AuthorDate: Fri, 12 Feb 2010 17:19:19 -0500
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Sun, 14 Feb 2010 09:19:43 +0100

nmi_watchdog: Compile and portability fixes

The original patch was x86_64 centric.  Changed the code to make
it less so.

ested by building and running on a powerpc.

Signed-off-by: Don Zickus <dzickus@redhat.com>
Cc: peterz@infradead.org
Cc: gorcunov@gmail.com
Cc: aris@redhat.com
LKML-Reference: <1266013161-31197-2-git-send-email-dzickus@redhat.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/include/asm/nmi.h    |    2 +
 arch/x86/kernel/apic/hw_nmi.c |   21 ++++++++++++----
 include/linux/nmi.h           |    9 +++++++
 kernel/nmi_watchdog.c         |   52 ++++++++++++++++++++++++++++++++--------
 kernel/sysctl.c               |   15 +++++++++++-
 5 files changed, 82 insertions(+), 17 deletions(-)

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
diff --git a/arch/x86/kernel/apic/hw_nmi.c b/arch/x86/kernel/apic/hw_nmi.c
index 8c0e6a4..312d772 100644
--- a/arch/x86/kernel/apic/hw_nmi.c
+++ b/arch/x86/kernel/apic/hw_nmi.c
@@ -32,8 +32,13 @@ static DEFINE_PER_CPU(unsigned, last_irq_sum);
  */
 static inline unsigned int get_timer_irqs(int cpu)
 {
-        return per_cpu(irq_stat, cpu).apic_timer_irqs +
-                per_cpu(irq_stat, cpu).irq0_irqs;
+	unsigned int irqs = per_cpu(irq_stat, cpu).irq0_irqs;
+
+#if defined(CONFIG_X86_LOCAL_APIC)
+	irqs += per_cpu(irq_stat, cpu).apic_timer_irqs;
+#endif
+
+        return irqs;
 }
 
 static inline int mce_in_progress(void)
@@ -82,6 +87,11 @@ int hw_nmi_is_cpu_stuck(struct pt_regs *regs)
 	}
 }
 
+u64 hw_nmi_get_sample_period(void)
+{
+        return cpu_khz * 1000;
+}
+
 void arch_trigger_all_cpu_backtrace(void)
 {
 	int i;
@@ -100,15 +110,16 @@ void arch_trigger_all_cpu_backtrace(void)
 }
 
 /* STUB calls to mimic old nmi_watchdog behaviour */
+#if defined(CONFIG_X86_LOCAL_APIC)
 unsigned int nmi_watchdog = NMI_NONE;
 EXPORT_SYMBOL(nmi_watchdog);
+void acpi_nmi_enable(void) { return; }
+void acpi_nmi_disable(void) { return; }
+#endif
 atomic_t nmi_active = ATOMIC_INIT(0);           /* oprofile uses this */
 EXPORT_SYMBOL(nmi_active);
-int nmi_watchdog_enabled;
 int unknown_nmi_panic;
 void cpu_nmi_set_wd_enabled(void) { return; }
-void acpi_nmi_enable(void) { return; }
-void acpi_nmi_disable(void) { return; }
 void stop_apic_nmi_watchdog(void *unused) { return; }
 void setup_apic_nmi_watchdog(void *unused) { return; }
 int __init check_nmi_watchdog(void) { return 0; }
diff --git a/include/linux/nmi.h b/include/linux/nmi.h
index a42ff0b..794e735 100644
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
@@ -49,6 +53,11 @@ static inline bool trigger_all_cpu_backtrace(void)
 
 #ifdef CONFIG_NMI_WATCHDOG
 int hw_nmi_is_cpu_stuck(struct pt_regs *);
+u64 hw_nmi_get_sample_period(void);
+extern int nmi_watchdog_enabled;
+struct ctl_table;
+extern int proc_nmi_enabled(struct ctl_table *, int ,
+                        void __user *, size_t *, loff_t *);
 #endif
 
 #endif
diff --git a/kernel/nmi_watchdog.c b/kernel/nmi_watchdog.c
index 36817b2..73c1954 100644
--- a/kernel/nmi_watchdog.c
+++ b/kernel/nmi_watchdog.c
@@ -30,6 +30,8 @@ static DEFINE_PER_CPU(struct perf_event *, nmi_watchdog_ev);
 static DEFINE_PER_CPU(int, nmi_watchdog_touch);
 static DEFINE_PER_CPU(long, alert_counter);
 
+static int panic_on_timeout;
+
 void touch_nmi_watchdog(void)
 {
 	__raw_get_cpu_var(nmi_watchdog_touch) = 1;
@@ -46,19 +48,49 @@ void touch_all_nmi_watchdog(void)
 	touch_softlockup_watchdog();
 }
 
+static int __init setup_nmi_watchdog(char *str)
+{
+        if (!strncmp(str, "panic", 5)) {
+                panic_on_timeout = 1;
+                str = strchr(str, ',');
+                if (!str)
+                        return 1;
+                ++str;
+        }
+        return 1;
+}
+__setup("nmi_watchdog=", setup_nmi_watchdog);
+
 #ifdef CONFIG_SYSCTL
 /*
  * proc handler for /proc/sys/kernel/nmi_watchdog
  */
+int nmi_watchdog_enabled;
+
 int proc_nmi_enabled(struct ctl_table *table, int write,
 		     void __user *buffer, size_t *length, loff_t *ppos)
 {
 	int cpu;
 
-	if (per_cpu(nmi_watchdog_ev, smp_processor_id()) == NULL)
+	if (!write) {
+		struct perf_event *event;
+		for_each_online_cpu(cpu) {
+			event = per_cpu(nmi_watchdog_ev, cpu);
+			if (event->state > PERF_EVENT_STATE_OFF) {
+				nmi_watchdog_enabled = 1;
+				break;
+			}
+		}
+		proc_dointvec(table, write, buffer, length, ppos);
+		return 0;
+	}
+
+	if (per_cpu(nmi_watchdog_ev, smp_processor_id()) == NULL) {
 		nmi_watchdog_enabled = 0;
-	else
-		nmi_watchdog_enabled = 1;
+		proc_dointvec(table, write, buffer, length, ppos);
+		printk("NMI watchdog failed configuration, can not be enabled\n");
+		return 0;
+	}
 
 	touch_all_nmi_watchdog();
 	proc_dointvec(table, write, buffer, length, ppos);
@@ -81,8 +113,6 @@ struct perf_event_attr wd_attr = {
 	.disabled = 1,
 };
 
-static int panic_on_timeout;
-
 void wd_overflow(struct perf_event *event, int nmi,
 		 struct perf_sample_data *data,
 		 struct pt_regs *regs)
@@ -103,11 +133,11 @@ void wd_overflow(struct perf_event *event, int nmi,
 		 */
 		per_cpu(alert_counter,cpu) += 1;
 		if (per_cpu(alert_counter,cpu) == 5) {
-			/*
-			 * die_nmi will return ONLY if NOTIFY_STOP happens..
-			 */
-			die_nmi("BUG: NMI Watchdog detected LOCKUP",
-				regs, panic_on_timeout);
+			if (panic_on_timeout) {
+				panic("NMI Watchdog detected LOCKUP on cpu %d", cpu);
+			} else {
+				WARN(1, "NMI Watchdog detected LOCKUP on cpu %d", cpu);
+			}
 		}
 	} else {
 		per_cpu(alert_counter,cpu) = 0;
@@ -133,7 +163,7 @@ cpu_callback(struct notifier_block *nfb, unsigned long action, void *hcpu)
 	case CPU_ONLINE:
 	case CPU_ONLINE_FROZEN:
 		/* originally wanted the below chunk to be in CPU_UP_PREPARE, but caps is unpriv for non-CPU0 */
-		wd_attr.sample_period = cpu_khz * 1000;
+		wd_attr.sample_period = hw_nmi_get_sample_period();
 		event = perf_event_create_kernel_counter(&wd_attr, hotcpu, -1, wd_overflow);
 		if (IS_ERR(event)) {
 			printk(KERN_ERR "nmi watchdog failed to create perf event on %i: %p\n", hotcpu, event);
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
