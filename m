Return-Path: <linux-kernel-owner+w=401wt.eu-S1756184AbXD2FJH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756184AbXD2FJH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Apr 2007 01:09:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756192AbXD2FJH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Apr 2007 01:09:07 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:34507 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756184AbXD2FJF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Apr 2007 01:09:05 -0400
Date: Sat, 28 Apr 2007 22:09:04 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: akpm@linux-foundation.org
cc: linux-kernel@vger.kernel.org, Arjan van de Ven <arjan@linux.intel.com>
Subject: vmstat: use our own timer events
Message-ID: <Pine.LNX.4.64.0704282206530.29468@schroedinger.engr.sgi.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

vmstat is currently using the cache reaper to periodically bring the
statistics up to date. The cache reaper does only exists in SLUB
as a way to provide compatibility with SLAB. This patch removes
the vmstat calls from the slab allocators and provides its own
handling.

The advantage is also that we can use a different frequency for the
updates. Refreshing vm stats is a pretty fast job so we can run this
every second and stagger this by only one tick. This will lead to
some overlap in large systems. F.e a system running at 250 HZ with
1024 processors will have 4 vm updates occurring at once.

However, the vm stats update only accesses per node information.
It is only necessary to stagger the vm statistics updates per
processor in each node. Vm counter updates occurring on distant
nodes will not cause cacheline contention.

We could implement an alternate approach that runs the first processor
on each node at the second and then each of the other processor on a
node on a subsequent tick. That may be useful to keep a large amount
of the second free of timer activity. Maybe the timer folks will have
some feedback on this one?

CC: Arjan van de Ven <arjan@linux.intel.com>
Signed-off-by: Christoph Lameter <clameter@sgi.com>

---
 include/linux/vmstat.h |    3 ---
 mm/slab.c              |    1 -
 mm/slub.c              |    1 -
 mm/vmstat.c            |   39 +++++++++++++++++++++++++++++++++++----
 4 files changed, 35 insertions(+), 9 deletions(-)

Index: slub/mm/slab.c
===================================================================
--- slub.orig/mm/slab.c	2007-04-28 19:35:19.000000000 -0700
+++ slub/mm/slab.c	2007-04-28 19:35:26.000000000 -0700
@@ -4155,7 +4155,6 @@ next:
 	check_irq_on();
 	mutex_unlock(&cache_chain_mutex);
 	next_reap_node();
-	refresh_cpu_vm_stats(smp_processor_id());
 out:
 	/* Set up the next iteration */
 	schedule_delayed_work(work, round_jiffies_relative(REAPTIMEOUT_CPUC));
Index: slub/mm/slub.c
===================================================================
--- slub.orig/mm/slub.c	2007-04-28 19:35:28.000000000 -0700
+++ slub/mm/slub.c	2007-04-28 19:36:12.000000000 -0700
@@ -2514,7 +2514,6 @@ static DEFINE_PER_CPU(struct delayed_wor
 static void cache_reap(struct work_struct *unused)
 {
 	next_reap_node();
-	refresh_cpu_vm_stats(smp_processor_id());
 	schedule_delayed_work(&__get_cpu_var(reap_work),
 				      REAPTIMEOUT_CPUC);
 }
Index: slub/include/linux/vmstat.h
===================================================================
--- slub.orig/include/linux/vmstat.h	2007-04-28 19:30:01.000000000 -0700
+++ slub/include/linux/vmstat.h	2007-04-28 19:36:38.000000000 -0700
@@ -213,8 +213,6 @@ extern void dec_zone_state(struct zone *
 extern void __dec_zone_state(struct zone *, enum zone_stat_item);
 
 void refresh_cpu_vm_stats(int);
-void refresh_vm_stats(void);
-
 #else /* CONFIG_SMP */
 
 /*
@@ -261,7 +259,6 @@ static inline void __dec_zone_page_state
 #define mod_zone_page_state __mod_zone_page_state
 
 static inline void refresh_cpu_vm_stats(int cpu) { }
-static inline void refresh_vm_stats(void) { }
 #endif
 
 #endif /* _LINUX_VMSTAT_H */
Index: slub/mm/vmstat.c
===================================================================
--- slub.orig/mm/vmstat.c	2007-04-28 19:30:01.000000000 -0700
+++ slub/mm/vmstat.c	2007-04-28 19:36:38.000000000 -0700
@@ -640,6 +640,22 @@ const struct seq_operations vmstat_op = 
 #endif /* CONFIG_PROC_FS */
 
 #ifdef CONFIG_SMP
+static DEFINE_PER_CPU(struct delayed_work, vmstat_work);
+
+static void vmstat_update(struct work_struct *w)
+{
+	refresh_cpu_vm_stats(smp_processor_id());
+	schedule_delayed_work(&__get_cpu_var(vmstat_work), HZ);
+}
+
+static void __devinit start_cpu_timer(int cpu)
+{
+	struct delayed_work *vmstat_work = &per_cpu(vmstat_work, cpu);
+
+	INIT_DELAYED_WORK(vmstat_work, vmstat_update);
+	schedule_delayed_work_on(cpu, vmstat_work, HZ + cpu);
+}
+
 /*
  * Use the cpu notifier to insure that the thresholds are recalculated
  * when necessary.
@@ -648,11 +664,21 @@ static int __cpuinit vmstat_cpuup_callba
 		unsigned long action,
 		void *hcpu)
 {
+	long cpu = (long)hcpu;
+
 	switch (action) {
-	case CPU_UP_PREPARE:
-	case CPU_UP_PREPARE_FROZEN:
-	case CPU_UP_CANCELED:
-	case CPU_UP_CANCELED_FROZEN:
+	case CPU_ONLINE:
+	case CPU_ONLINE_FROZEN:
+		start_cpu_timer(cpu);
+		break;
+	case CPU_DOWN_PREPARE:
+	case CPU_DOWN_PREPARE_FROZEN:
+		cancel_rearming_delayed_work(&per_cpu(vmstat_work, cpu));
+		per_cpu(vmstat_work, cpu).work.func = NULL;
+	case CPU_DOWN_FAILED:
+	case CPU_DOWN_FAILED_FROZEN:
+		start_cpu_timer(cpu);
+		break;
 	case CPU_DEAD:
 	case CPU_DEAD_FROZEN:
 		refresh_zone_stat_thresholds();
@@ -668,8 +694,13 @@ static struct notifier_block __cpuinitda
 
 int __init setup_vmstat(void)
 {
+	int cpu;
+
 	refresh_zone_stat_thresholds();
 	register_cpu_notifier(&vmstat_notifier);
+
+	for_each_online_cpu(cpu)
+		start_cpu_timer(cpu);
 	return 0;
 }
 module_init(setup_vmstat)
