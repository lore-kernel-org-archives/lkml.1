Return-Path: <linux-kernel-owner+w=401wt.eu-S1757415AbYGNQ1y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757415AbYGNQ1y (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2008 12:27:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753029AbYGNQ1o
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Jul 2008 12:27:44 -0400
Received: from www.tglx.de ([62.245.132.106]:49302 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753495AbYGNQ1n (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2008 12:27:43 -0400
Date: Mon, 14 Jul 2008 18:27:22 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>
Subject: [GIT pull] genirq updates for 2.6.27
Message-ID: <alpine.LFD.1.10.0807141822470.3283@apollo.tec.linutronix.de>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest genirq git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git genirq

Thanks,

	tglx

------------------>
Max Krasnyansky (1):
      genirq: Expose default irq affinity mask (take 3)

Thomas Gleixner (1):
      genirq: remove extraneous checks in manage.c


 Documentation/IRQ-affinity.txt     |   37 +++++++++++++++++-----
 Documentation/filesystems/proc.txt |   29 +++++++++++-------
 arch/alpha/kernel/irq.c            |    5 +--
 include/linux/interrupt.h          |    5 +++
 include/linux/irq.h                |    9 -----
 kernel/irq/manage.c                |   33 +++++++++++++++++---
 kernel/irq/proc.c                  |   59 +++++++++++++++++++++++++++++++++--
 7 files changed, 136 insertions(+), 41 deletions(-)

diff --git a/Documentation/IRQ-affinity.txt b/Documentation/IRQ-affinity.txt
index 938d7dd..b4a615b 100644
--- a/Documentation/IRQ-affinity.txt
+++ b/Documentation/IRQ-affinity.txt
@@ -1,17 +1,26 @@
+ChangeLog:
+	Started by Ingo Molnar <mingo@redhat.com>
+	Update by Max Krasnyansky <maxk@qualcomm.com>
 
-SMP IRQ affinity, started by Ingo Molnar <mingo@redhat.com>
-
+SMP IRQ affinity
 
 /proc/irq/IRQ#/smp_affinity specifies which target CPUs are permitted
 for a given IRQ source. It's a bitmask of allowed CPUs. It's not allowed
 to turn off all CPUs, and if an IRQ controller does not support IRQ
 affinity then the value will not change from the default 0xffffffff.
 
+/proc/irq/default_smp_affinity specifies default affinity mask that applies
+to all non-active IRQs. Once IRQ is allocated/activated its affinity bitmask
+will be set to the default mask. It can then be changed as described above.
+Default mask is 0xffffffff.
+
 Here is an example of restricting IRQ44 (eth1) to CPU0-3 then restricting
-the IRQ to CPU4-7 (this is an 8-CPU SMP box):
+it to CPU4-7 (this is an 8-CPU SMP box):
 
+[root@moon 44]# cd /proc/irq/44
 [root@moon 44]# cat smp_affinity
 ffffffff
+
 [root@moon 44]# echo 0f > smp_affinity
 [root@moon 44]# cat smp_affinity
 0000000f
@@ -21,17 +30,27 @@ PING hell (195.4.7.3): 56 data bytes
 --- hell ping statistics ---
 6029 packets transmitted, 6027 packets received, 0% packet loss
 round-trip min/avg/max = 0.1/0.1/0.4 ms
-[root@moon 44]# cat /proc/interrupts | grep 44:
- 44:          0       1785       1785       1783       1783          1
-1          0   IO-APIC-level  eth1
+[root@moon 44]# cat /proc/interrupts | grep 'CPU\|44:'
+           CPU0       CPU1       CPU2       CPU3      CPU4       CPU5        CPU6       CPU7
+ 44:       1068       1785       1785       1783         0          0           0         0    IO-APIC-level  eth1
+
+As can be seen from the line above IRQ44 was delivered only to the first four
+processors (0-3).
+Now lets restrict that IRQ to CPU(4-7).
+
 [root@moon 44]# echo f0 > smp_affinity
+[root@moon 44]# cat smp_affinity
+000000f0
 [root@moon 44]# ping -f h
 PING hell (195.4.7.3): 56 data bytes
 ..
 --- hell ping statistics ---
 2779 packets transmitted, 2777 packets received, 0% packet loss
 round-trip min/avg/max = 0.1/0.5/585.4 ms
-[root@moon 44]# cat /proc/interrupts | grep 44:
- 44:       1068       1785       1785       1784       1784       1069       1070       1069   IO-APIC-level  eth1
-[root@moon 44]#
+[root@moon 44]# cat /proc/interrupts |  'CPU\|44:'
+           CPU0       CPU1       CPU2       CPU3      CPU4       CPU5        CPU6       CPU7
+ 44:       1068       1785       1785       1783      1784       1069        1070       1069   IO-APIC-level  eth1
+
+This time around IRQ44 was delivered only to the last four processors.
+i.e counters for the CPU0-3 did not change.
 
diff --git a/Documentation/filesystems/proc.txt b/Documentation/filesystems/proc.txt
index dbc3c6a..7f268f3 100644
--- a/Documentation/filesystems/proc.txt
+++ b/Documentation/filesystems/proc.txt
@@ -380,28 +380,35 @@ i386 and x86_64 platforms support the new IRQ vector displays.
 Of some interest is the introduction of the /proc/irq directory to 2.4.
 It could be used to set IRQ to CPU affinity, this means that you can "hook" an
 IRQ to only one CPU, or to exclude a CPU of handling IRQs. The contents of the
-irq subdir is one subdir for each IRQ, and one file; prof_cpu_mask
+irq subdir is one subdir for each IRQ, and two files; default_smp_affinity and
+prof_cpu_mask.
 
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
+  > echo 1 > /proc/irq/10/smp_affinity
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
+The default_smp_affinity mask applies to all non-active IRQs, which are the
+IRQs which have not yet been allocated/activated, and hence which lack a
+/proc/irq/[0-9]* directory.
 
-This means that only the first CPU will handle the IRQ, but you can also echo 5
-which means that only the first and fourth CPU can handle the IRQ.
+prof_cpu_mask specifies which CPUs are to be profiled by the system wide
+profiler. Default value is ffffffff (all cpus).
 
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
 
diff --git a/include/linux/interrupt.h b/include/linux/interrupt.h
index f1fc747..043400f 100644
--- a/include/linux/interrupt.h
+++ b/include/linux/interrupt.h
@@ -104,8 +104,11 @@ extern void enable_irq(unsigned int irq);
 
 #if defined(CONFIG_SMP) && defined(CONFIG_GENERIC_HARDIRQS)
 
+extern cpumask_t irq_default_affinity;
+
 extern int irq_set_affinity(unsigned int irq, cpumask_t cpumask);
 extern int irq_can_set_affinity(unsigned int irq);
+extern int irq_select_affinity(unsigned int irq);
 
 #else /* CONFIG_SMP */
 
@@ -119,6 +122,8 @@ static inline int irq_can_set_affinity(unsigned int irq)
 	return 0;
 }
 
+static inline int irq_select_affinity(unsigned int irq)  { return 0; }
+
 #endif /* CONFIG_SMP && CONFIG_GENERIC_HARDIRQS */
 
 #ifdef CONFIG_GENERIC_HARDIRQS
diff --git a/include/linux/irq.h b/include/linux/irq.h
index 552e0ec..8ccb462 100644
--- a/include/linux/irq.h
+++ b/include/linux/irq.h
@@ -244,15 +244,6 @@ static inline void set_balance_irq_affinity(unsigned int irq, cpumask_t mask)
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
index 46d6611..77a51be 100644
--- a/kernel/irq/manage.c
+++ b/kernel/irq/manage.c
@@ -17,6 +17,8 @@
 
 #ifdef CONFIG_SMP
 
+cpumask_t irq_default_affinity = CPU_MASK_ALL;
+
 /**
  *	synchronize_irq - wait for pending IRQ handlers (on other CPUs)
  *	@irq: interrupt number to wait for
@@ -95,6 +97,27 @@ int irq_set_affinity(unsigned int irq, cpumask_t cpumask)
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
@@ -354,7 +377,7 @@ int setup_irq(unsigned int irq, struct irqaction *new)
 
 		/* Setup the type (level, edge polarity) if configured: */
 		if (new->flags & IRQF_TRIGGER_MASK) {
-			if (desc->chip && desc->chip->set_type)
+			if (desc->chip->set_type)
 				desc->chip->set_type(irq,
 						new->flags & IRQF_TRIGGER_MASK);
 			else
@@ -364,8 +387,7 @@ int setup_irq(unsigned int irq, struct irqaction *new)
 				 */
 				printk(KERN_WARNING "No IRQF_TRIGGER set_type "
 				       "function for IRQ %d (%s)\n", irq,
-				       desc->chip ? desc->chip->name :
-				       "unknown");
+				       desc->chip->name);
 		} else
 			compat_irq_chip_set_default_handler(desc);
 
@@ -382,6 +404,9 @@ int setup_irq(unsigned int irq, struct irqaction *new)
 		} else
 			/* Undo nested disables: */
 			desc->depth = 1;
+
+		/* Set default affinity mask once everything is setup */
+		irq_select_affinity(irq);
 	}
 	/* Reset broken irq detection when installing new handler */
 	desc->irq_count = 0;
@@ -571,8 +596,6 @@ int request_irq(unsigned int irq, irq_handler_t handler,
 	action->next = NULL;
 	action->dev_id = dev_id;
 
-	select_smp_affinity(irq);
-
 #ifdef CONFIG_DEBUG_SHIRQ
 	if (irqflags & IRQF_SHARED) {
 		/*
diff --git a/kernel/irq/proc.c b/kernel/irq/proc.c
index c2f2ccb..6c6d35d 100644
--- a/kernel/irq/proc.c
+++ b/kernel/irq/proc.c
@@ -44,7 +44,7 @@ static int irq_affinity_write_proc(struct file *file, const char __user *buffer,
 				   unsigned long count, void *data)
 {
 	unsigned int irq = (int)(long)data, full_count = count, err;
-	cpumask_t new_value, tmp;
+	cpumask_t new_value;
 
 	if (!irq_desc[irq].chip->set_affinity || no_irq_affinity ||
 	    irq_balancing_disabled(irq))
@@ -62,17 +62,51 @@ static int irq_affinity_write_proc(struct file *file, const char __user *buffer,
 	 * way to make the system unusable accidentally :-) At least
 	 * one online CPU still has to be targeted.
 	 */
-	cpus_and(tmp, new_value, cpu_online_map);
-	if (cpus_empty(tmp))
+	if (!cpus_intersects(new_value, cpu_online_map))
 		/* Special case for empty set - allow the architecture
 		   code to set default SMP affinity. */
-		return select_smp_affinity(irq) ? -EINVAL : full_count;
+		return irq_select_affinity(irq) ? -EINVAL : full_count;
 
 	irq_set_affinity(irq, new_value);
 
 	return full_count;
 }
 
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
+	cpumask_t new_value;
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
+	if (!cpus_intersects(new_value, cpu_online_map))
+		return -EINVAL;
+
+	irq_default_affinity = new_value;
+
+	return full_count;
+}
 #endif
 
 static int irq_spurious_read(char *page, char **start, off_t off,
@@ -171,6 +205,21 @@ void unregister_handler_proc(unsigned int irq, struct irqaction *action)
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
@@ -180,6 +229,8 @@ void init_irq_proc(void)
 	if (!root_irq_dir)
 		return;
 
+	register_default_affinity_proc();
+
 	/*
 	 * Create entries for all existing IRQs.
 	 */
