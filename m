Return-Path: <linux-kernel-owner+w=401wt.eu-S1760448AbYE0WCN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760448AbYE0WCN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2008 18:02:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759091AbYE0WB5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 May 2008 18:01:57 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:42120 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758966AbYE0WB4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2008 18:01:56 -0400
X-IronPort-AV: E=McAfee;i="5200,2160,5304"; a="3444376"
From: Max Krasnyansky <maxk@qualcomm.com>
To: mingo@elte.hu
Cc: pj@sgi.com, a.p.zijlstra@chello.nl, linux-kernel@vger.kernel.org,
       tglx@linutronix.de, rdunlap@xenotime.net,
       Max Krasnyansky <maxk@qualcomm.com>
Subject: [PATCH] [genirq] Expose default irq affinity mask (take 2)
Date: Tue, 27 May 2008 15:01:53 -0700
Message-Id: <1211925713-11253-1-git-send-email-maxk@qualcomm.com>
X-Mailer: git-send-email 1.5.4.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Current IRQ affinity interface does not provide a way to set affinity
for the IRQs that will be allocated/activated in the future.
This patch creates /proc/irq/default_smp_affinity that lets users set
default affinity mask for the newly allocated IRQs. Changing the default
does not affect affinity masks for the currently active IRQs, they
have to be changed explicitly.

This version addressed comments from Paul and Randy.

Signed-off-by: Max Krasnyansky <maxk@qualcomm.com>
---
 Documentation/filesystems/proc.txt |   30 ++++++++++++-------
 arch/alpha/kernel/irq.c            |    5 +--
 include/linux/irq.h                |   14 +++------
 kernel/irq/manage.c                |   28 ++++++++++++++++-
 kernel/irq/proc.c                  |   57 +++++++++++++++++++++++++++++++++++-
 5 files changed, 108 insertions(+), 26 deletions(-)

diff --git a/Documentation/filesystems/proc.txt b/Documentation/filesystems/proc.txt
index 518ebe6..231d9db 100644
--- a/Documentation/filesystems/proc.txt
+++ b/Documentation/filesystems/proc.txt
@@ -379,28 +379,36 @@ i386 and x86_64 platforms support the new IRQ vector displays.
 Of some interest is the introduction of the /proc/irq directory to 2.4.
 It could be used to set IRQ to CPU affinity, this means that you can "hook" an
 IRQ to only one CPU, or to exclude a CPU of handling IRQs. The contents of the
-irq subdir is one subdir for each IRQ, and one file; prof_cpu_mask
+irq subdir is one subdir for each IRQ, and two files; default_smp_affinity and 
+prof_cpu_mask
 
 For example 
   > ls /proc/irq/
   0  10  12  14  16  18  2  4  6  8  prof_cpu_mask
-  1  11  13  15  17  19  3  5  7  9
+  1  11  13  15  17  19  3  5  7  9  default_smp_affinity
   > ls /proc/irq/0/
   smp_affinity
 
-The contents of the prof_cpu_mask file and each smp_affinity file for each IRQ
-is the same by default:
+smp_affinity is a bitmask, in which you can specify which CPUs can handle the 
+IRQ, you can set it by doing:
 
-  > cat /proc/irq/0/smp_affinity 
-  ffffffff
+  > echo 1 > /proc/irq/5/smp_affinity
+
+This means that only the first CPU will handle the IRQ, but you can also echo
+5 which means that only the first and fourth CPU can handle the IRQ.
 
-It's a bitmask, in which you can specify which CPUs can handle the IRQ, you can
-set it by doing:
+The contents of each smp_affinity file is the same by default:
+
+  > cat /proc/irq/0/smp_affinity
+  ffffffff
 
-  > echo 1 > /proc/irq/prof_cpu_mask
+default_smp_affinity mask applies to all non-active IRQs. In other words IRQs 
+that have not been allocated/activated yet (for which /proc/irq/[0-9]* directory
+does not exist). Once IRQ is activated its affinity mask can be changed as
+described above.
 
-This means that only the first CPU will handle the IRQ, but you can also echo 5
-which means that only the first and fourth CPU can handle the IRQ.
+prof_cpu_mask specifies which CPUs are to be profiled by the system wide
+profiler.
 
 The way IRQs are routed is handled by the IO-APIC, and it's Round Robin
 between all the CPUs which are allowed to handle it. As usual the kernel has
diff --git a/arch/alpha/kernel/irq.c b/arch/alpha/kernel/irq.c
index facf82a..c626a82 100644
--- a/arch/alpha/kernel/irq.c
+++ b/arch/alpha/kernel/irq.c
@@ -42,8 +42,7 @@ void ack_bad_irq(unsigned int irq)
 #ifdef CONFIG_SMP 
 static char irq_user_affinity[NR_IRQS];
 
-int
-select_smp_affinity(unsigned int irq)
+int irq_select_affinity(unsigned int irq)
 {
 	static int last_cpu;
 	int cpu = last_cpu + 1;
@@ -51,7 +50,7 @@ select_smp_affinity(unsigned int irq)
 	if (!irq_desc[irq].chip->set_affinity || irq_user_affinity[irq])
 		return 1;
 
-	while (!cpu_possible(cpu))
+	while (!cpu_possible(cpu) || !cpu_isset(cpu, irq_default_affinity))
 		cpu = (cpu < (NR_CPUS-1) ? cpu + 1 : 0);
 	last_cpu = cpu;
 
diff --git a/include/linux/irq.h b/include/linux/irq.h
index 176e5e7..8faebf8 100644
--- a/include/linux/irq.h
+++ b/include/linux/irq.h
@@ -228,8 +228,11 @@ static inline void set_pending_irq(unsigned int irq, cpumask_t mask)
 
 #endif /* CONFIG_GENERIC_PENDING_IRQ */
 
+extern cpumask_t irq_default_affinity;
+
 extern int irq_set_affinity(unsigned int irq, cpumask_t cpumask);
 extern int irq_can_set_affinity(unsigned int irq);
+extern int irq_select_affinity(unsigned int irq);
 
 #else /* CONFIG_SMP */
 
@@ -243,6 +246,8 @@ static inline int irq_set_affinity(unsigned int irq, cpumask_t cpumask)
 
 static inline int irq_can_set_affinity(unsigned int irq) { return 0; }
 
+static inline int irq_select_affinity(unsigned int irq)  { return 0; }
+
 #endif /* CONFIG_SMP */
 
 #ifdef CONFIG_IRQBALANCE
@@ -253,15 +258,6 @@ static inline void set_balance_irq_affinity(unsigned int irq, cpumask_t mask)
 }
 #endif
 
-#ifdef CONFIG_AUTO_IRQ_AFFINITY
-extern int select_smp_affinity(unsigned int irq);
-#else
-static inline int select_smp_affinity(unsigned int irq)
-{
-	return 1;
-}
-#endif
-
 extern int no_irq_affinity;
 
 static inline int irq_balancing_disabled(unsigned int irq)
diff --git a/kernel/irq/manage.c b/kernel/irq/manage.c
index 438a014..80c7573 100644
--- a/kernel/irq/manage.c
+++ b/kernel/irq/manage.c
@@ -16,6 +16,8 @@
 
 #ifdef CONFIG_SMP
 
+cpumask_t irq_default_affinity = CPU_MASK_ALL;
+
 /**
  *	synchronize_irq - wait for pending IRQ handlers (on other CPUs)
  *	@irq: interrupt number to wait for
@@ -94,6 +96,27 @@ int irq_set_affinity(unsigned int irq, cpumask_t cpumask)
 	return 0;
 }
 
+#ifndef CONFIG_AUTO_IRQ_AFFINITY
+/*
+ * Generic version of the affinity autoselector.
+ */
+int irq_select_affinity(unsigned int irq)
+{
+	cpumask_t mask;
+
+	if (!irq_can_set_affinity(irq))
+		return 0;
+
+	cpus_and(mask, cpu_online_map, irq_default_affinity);
+
+	irq_desc[irq].affinity = mask;
+	irq_desc[irq].chip->set_affinity(irq, mask);
+
+	set_balance_irq_affinity(irq, mask);
+	return 0;
+}
+#endif
+
 #endif
 
 /**
@@ -376,6 +399,9 @@ int setup_irq(unsigned int irq, struct irqaction *new)
 		} else
 			/* Undo nested disables: */
 			desc->depth = 1;
+
+		/* Set default affinity mask once everything is setup */
+		irq_select_affinity(irq);
 	}
 	/* Reset broken irq detection when installing new handler */
 	desc->irq_count = 0;
@@ -555,8 +581,6 @@ int request_irq(unsigned int irq, irq_handler_t handler,
 	action->next = NULL;
 	action->dev_id = dev_id;
 
-	select_smp_affinity(irq);
-
 #ifdef CONFIG_DEBUG_SHIRQ
 	if (irqflags & IRQF_SHARED) {
 		/*
diff --git a/kernel/irq/proc.c b/kernel/irq/proc.c
index c2f2ccb..c20eb52 100644
--- a/kernel/irq/proc.c
+++ b/kernel/irq/proc.c
@@ -66,13 +66,51 @@ static int irq_affinity_write_proc(struct file *file, const char __user *buffer,
 	if (cpus_empty(tmp))
 		/* Special case for empty set - allow the architecture
 		   code to set default SMP affinity. */
-		return select_smp_affinity(irq) ? -EINVAL : full_count;
+		return irq_select_affinity(irq) ? -EINVAL : full_count;
 
 	irq_set_affinity(irq, new_value);
 
 	return full_count;
 }
 
+extern cpumask_t irq_default_affinity;
+
+static int default_affinity_read(char *page, char **start, off_t off,
+				  int count, int *eof, void *data)
+{
+	int len = cpumask_scnprintf(page, count, irq_default_affinity);
+	if (count - len < 2)
+		return -EINVAL;
+	len += sprintf(page + len, "\n");
+	return len;
+}
+
+static int default_affinity_write(struct file *file, const char __user *buffer,
+				   unsigned long count, void *data)
+{
+	unsigned int full_count = count, err;
+	cpumask_t new_value, tmp;
+
+	err = cpumask_parse_user(buffer, count, new_value);
+	if (err)
+		return err;
+
+	if (!is_affinity_mask_valid(new_value))
+		return -EINVAL;
+
+	/*
+	 * Do not allow disabling IRQs completely - it's a too easy
+	 * way to make the system unusable accidentally :-) At least
+	 * one online CPU still has to be targeted.
+	 */
+	cpus_and(tmp, new_value, cpu_online_map);
+	if (cpus_empty(tmp))
+		return -EINVAL;
+
+	irq_default_affinity = new_value;
+
+	return full_count;
+}
 #endif
 
 static int irq_spurious_read(char *page, char **start, off_t off,
@@ -171,6 +209,21 @@ void unregister_handler_proc(unsigned int irq, struct irqaction *action)
 		remove_proc_entry(action->dir->name, irq_desc[irq].dir);
 }
 
+void register_default_affinity_proc(void)
+{
+#ifdef CONFIG_SMP
+	struct proc_dir_entry *entry;
+
+	/* create /proc/irq/default_smp_affinity */
+	entry = create_proc_entry("default_smp_affinity", 0600, root_irq_dir);
+	if (entry) {
+		entry->data = NULL;
+		entry->read_proc  = default_affinity_read;
+		entry->write_proc = default_affinity_write;
+	}
+#endif
+}
+
 void init_irq_proc(void)
 {
 	int i;
@@ -180,6 +233,8 @@ void init_irq_proc(void)
 	if (!root_irq_dir)
 		return;
 
+	register_default_affinity_proc();
+
 	/*
 	 * Create entries for all existing IRQs.
 	 */
-- 
1.5.4.5

