Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933446Ab0BPWFn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Feb 2010 17:05:43 -0500
Received: from mx1.redhat.com ([209.132.183.28]:59360 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933294Ab0BPWFl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Feb 2010 17:05:41 -0500
From: Don Zickus <dzickus@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Don Zickus <dzickus@redhat.com>, mingo@elte.hu, peterz@infradead.org,
       gorcunov@gmail.com, aris@redhat.com, eranian@google.com
Subject: [PATCH 1/2] nmi_watchdog:  support for oprofile
Date: Tue, 16 Feb 2010 17:04:52 -0500
Message-Id: <1266357892-30504-1-git-send-email-dzickus@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Re-arrange the code so that when someone disables nmi_watchdog with

echo 0 > /proc/sys/kernel/nmi_watchdog

it releases the hardware reservation on the PMUs.  This allows the
oprofile module to grab those PMUs and do its thing.  Otherwise
oprofile fails to load because the hardware is reserved by the
perf_events subsystem.

Tested using

oprofile --vm-linux --start

and watched it failed when nmi_watchdog is enabled and succeed when

oprofile --deinit && echo 0 > /proc/sys/kernel/nmi_watchdog

is run.

Note:  this has the side quirk of having the nmi_watchdog latch onto
the software events instead of hardware events if oprofile has already
reserved the hardware first.  User beware! :-)

Signed-off-by: Don Zickus <dzickus@redhat.com>
---
 kernel/nmi_watchdog.c |  144 ++++++++++++++++++++++++++++---------------------
 1 files changed, 82 insertions(+), 62 deletions(-)

diff --git a/kernel/nmi_watchdog.c b/kernel/nmi_watchdog.c
index 4f23505..633b230 100644
--- a/kernel/nmi_watchdog.c
+++ b/kernel/nmi_watchdog.c
@@ -61,50 +61,6 @@ static int __init setup_nmi_watchdog(char *str)
 }
 __setup("nmi_watchdog=", setup_nmi_watchdog);
 
-#ifdef CONFIG_SYSCTL
-/*
- * proc handler for /proc/sys/kernel/nmi_watchdog
- */
-int nmi_watchdog_enabled;
-
-int proc_nmi_enabled(struct ctl_table *table, int write,
-		     void __user *buffer, size_t *length, loff_t *ppos)
-{
-	int cpu;
-
-	if (!write) {
-		struct perf_event *event;
-		for_each_online_cpu(cpu) {
-			event = per_cpu(nmi_watchdog_ev, cpu);
-			if (event->state > PERF_EVENT_STATE_OFF) {
-				nmi_watchdog_enabled = 1;
-				break;
-			}
-		}
-		proc_dointvec(table, write, buffer, length, ppos);
-		return 0;
-	}
-
-	if (per_cpu(nmi_watchdog_ev, smp_processor_id()) == NULL) {
-		nmi_watchdog_enabled = 0;
-		proc_dointvec(table, write, buffer, length, ppos);
-		printk("NMI watchdog failed configuration, can not be enabled\n");
-		return 0;
-	}
-
-	touch_all_nmi_watchdog();
-	proc_dointvec(table, write, buffer, length, ppos);
-	if (nmi_watchdog_enabled)
-		for_each_online_cpu(cpu)
-			perf_event_enable(per_cpu(nmi_watchdog_ev, cpu));
-	else
-		for_each_online_cpu(cpu)
-			perf_event_disable(per_cpu(nmi_watchdog_ev, cpu));
-	return 0;
-}
-
-#endif /* CONFIG_SYSCTL */
-
 struct perf_event_attr wd_attr = {
 	.type = PERF_TYPE_HARDWARE,
 	.config = PERF_COUNT_HW_CPU_CYCLES,
@@ -146,6 +102,85 @@ void wd_overflow(struct perf_event *event, int nmi,
 	return;
 }
 
+static int enable_nmi_watchdog(int cpu)
+{
+	struct perf_event *event;
+
+	event = per_cpu(nmi_watchdog_ev, cpu);
+	if (event && event->state > PERF_EVENT_STATE_OFF)
+		return 0;
+
+	if (event == NULL) {
+		/* Try to register using hardware perf events first */
+		wd_attr.sample_period = hw_nmi_get_sample_period();
+		event = perf_event_create_kernel_counter(&wd_attr, cpu, -1, wd_overflow);
+		if (IS_ERR(event)) {
+			wd_attr.type = PERF_TYPE_SOFTWARE;
+			event = perf_event_create_kernel_counter(&wd_attr, cpu, -1, wd_overflow);
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
+				printk("NMI watchdog failed configuration, "
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
 /*
  * Create/destroy watchdog threads as CPUs come and go:
  */
@@ -153,7 +188,6 @@ static int __cpuinit
 cpu_callback(struct notifier_block *nfb, unsigned long action, void *hcpu)
 {
 	int hotcpu = (unsigned long)hcpu;
-	struct perf_event *event;
 
 	switch (action) {
 	case CPU_UP_PREPARE:
@@ -162,29 +196,15 @@ cpu_callback(struct notifier_block *nfb, unsigned long action, void *hcpu)
 		break;
 	case CPU_ONLINE:
 	case CPU_ONLINE_FROZEN:
-		/* originally wanted the below chunk to be in CPU_UP_PREPARE, but caps is unpriv for non-CPU0 */
-		wd_attr.sample_period = hw_nmi_get_sample_period();
-		event = perf_event_create_kernel_counter(&wd_attr, hotcpu, -1, wd_overflow);
-		if (IS_ERR(event)) {
-			wd_attr.type = PERF_TYPE_SOFTWARE;
-			event = perf_event_create_kernel_counter(&wd_attr, hotcpu, -1, wd_overflow);
-			if (IS_ERR(event)) {
-				printk(KERN_ERR "nmi watchdog failed to create perf event on %i: %p\n", hotcpu, event);
-				return NOTIFY_BAD;
-			}
-		}
-		per_cpu(nmi_watchdog_ev, hotcpu) = event;
-		perf_event_enable(per_cpu(nmi_watchdog_ev, hotcpu));
+		if (enable_nmi_watchdog(hotcpu))
+			return NOTIFY_BAD;
 		break;
 #ifdef CONFIG_HOTPLUG_CPU
 	case CPU_UP_CANCELED:
 	case CPU_UP_CANCELED_FROZEN:
-		perf_event_disable(per_cpu(nmi_watchdog_ev, hotcpu));
+		disable_nmi_watchdog(hotcpu);
 	case CPU_DEAD:
 	case CPU_DEAD_FROZEN:
-		event = per_cpu(nmi_watchdog_ev, hotcpu);
-		per_cpu(nmi_watchdog_ev, hotcpu) = NULL;
-		perf_event_release_kernel(event);
 		break;
 #endif /* CONFIG_HOTPLUG_CPU */
 	}
-- 
1.6.6.83.gc9a2

