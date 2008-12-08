Return-Path: <linux-kernel-owner+w=401wt.eu-S1754021AbYLHWIW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754021AbYLHWIW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2008 17:08:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752867AbYLHWIA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Dec 2008 17:08:00 -0500
Received: from hera.kernel.org ([140.211.167.34]:34785 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753924AbYLHWH5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2008 17:07:57 -0500
Message-ID: <493D9A8E.7070107@kernel.org>
Date: Mon, 08 Dec 2008 14:07:10 -0800
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Thunderbird 2.0.0.18 (X11/20081112)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: [PATCH] irq: move irq_desc according to smp_affinity v6
References: <1228532430-28958-1-git-send-email-yinghai@kernel.org> <20081208134219.GC29965@elte.hu>
In-Reply-To: <20081208134219.GC29965@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


impact: new feature move irq_desc with sparseirq

if CONFIG_MOVE_IRQ_DESC is set
  make irq_desc to go with affinity aka irq_desc moving etc
  call move_irq_desc in irq_complete_move()
  legacy irq_desc is not moved, because they are allocated via static array

v3: add calling to irq_to_desc after calling ack/eoi instead of passing desc

v6: use irq_remap_to_desc to avoid some #ifdef according to Ingo

for logical apic mode, need to add move_desc_in_progress_in_same_domain. otherwise it will not get moved. ==> also could need two phase to get irq_desc moved.
	for example: 0xff is old affinity, and need to set 0xf, and then set to 0xf0.
	[ or we need to change domain definition to cpus on the same node ? ]

LBSuse:~ # cat /proc/irq/22/smp_affinity
00000000,00000000,00000000,000000ff
LBSuse:~ # echo f > /proc/irq/22/smp_affinity
LBSuse:~ # cat /proc/irq/22/smp_affinity
00000000,00000000,00000000,0000000f
LBSuse:~ # tail /var/log/messages
...
Oct 27 12:35:34 LBSuse kernel: klogd 1.4.1, log source = /proc/kmsg started.
Oct 27 12:35:34 LBSuse kernel: eth0: no IPv6 routers present
LBSuse:~ # echo f0 > /proc/irq/22/smp_affinity
LBSuse:~ # tail /var/log/messages
Oct 27 12:35:34 LBSuse kernel: klogd 1.4.1, log source = /proc/kmsg started.
Oct 27 12:35:34 LBSuse kernel: eth0: no IPv6 routers present
Oct 27 12:36:46 LBSuse kernel:   move irq_desc for 22 aka 0x16 to cpu 7 node 1
Oct 27 12:36:46 LBSuse kernel:   alloc kstat_irqs on cpu 7 node 1
Oct 27 12:36:46 LBSuse kernel:   alloc irq_cfg on cpu 7 node 1
Oct 27 12:36:46 LBSuse kernel:   alloc irq_2_pin on cpu 7 node 1

so assume the user space program should update /proc/irq/XX/smp_affinity to 03 or 0f at first on boot
or we change irq_default_affinity ?

for physical apic is much simple
on 4 sockets 16 cores system
irq_desc is moving..
when
# echo 10 > /proc/irq/134483967/smp_affinity
# echo 100 > /proc/irq/134483967/smp_affinity
# echo 1000 > /proc/irq/134483967/smp_affinity
got
Nov  9 21:39:51 LBSuse kernel:   move irq_desc for 134483967 aka 0x8040fff to cpu 4 node 1
Nov  9 21:39:51 LBSuse kernel:   alloc kstat_irqs on cpu 4 node 1
Nov  9 21:39:51 LBSuse kernel:   alloc irq_cfg on cpu 4 node 1
Nov  9 21:40:05 LBSuse kernel:   move irq_desc for 134483967 aka 0x8040fff to cpu 8 node 2
Nov  9 21:40:05 LBSuse kernel:   alloc kstat_irqs on cpu 8 node 2
Nov  9 21:40:05 LBSuse kernel:   alloc irq_cfg on cpu 8 node 2
Nov  9 21:40:18 LBSuse kernel:   move irq_desc for 134483967 aka 0x8040fff to cpu 12 node 3
Nov  9 21:40:18 LBSuse kernel:   alloc kstat_irqs on cpu 12 node 3
Nov  9 21:40:18 LBSuse kernel:   alloc irq_cfg on cpu 12 node 3

Signed-off-by: Yinghai Lu <yinghai@kernel.org>

---
 arch/x86/Kconfig          |    9 ++
 arch/x86/kernel/io_apic.c |  143 +++++++++++++++++++++++++++++++++++++++++++++-
 include/linux/irq.h       |   10 +++
 kernel/irq/chip.c         |   12 +++
 kernel/irq/handle.c       |  119 +++++++++++++++++++++++++++++++++++++-
 5 files changed, 288 insertions(+), 5 deletions(-)

Index: linux-2.6/arch/x86/Kconfig
===================================================================
--- linux-2.6.orig/arch/x86/Kconfig
+++ linux-2.6/arch/x86/Kconfig
@@ -253,6 +253,15 @@ config SPARSE_IRQ
 
 	  If you don't know what to do here, say Y.
 
+config MOVE_IRQ_DESC
+	bool "Move irq desc when changing irq smp_affinity"
+	depends on SPARSE_IRQ && SMP
+	default y
+	help
+	  This enables moving irq_desc to cpu/node that irq will use handled.
+
+	  If you don't know what to do here, say Y.
+
 config X86_FIND_SMP_CONFIG
 	def_bool y
 	depends on X86_MPPARSE || X86_VOYAGER
Index: linux-2.6/arch/x86/kernel/io_apic.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/io_apic.c
+++ linux-2.6/arch/x86/kernel/io_apic.c
@@ -141,6 +141,9 @@ struct irq_cfg {
 	unsigned move_cleanup_count;
 	u8 vector;
 	u8 move_in_progress : 1;
+#ifdef CONFIG_MOVE_IRQ_DESC
+	u8 move_desc_in_progress_in_same_domain : 1;
+#endif
 };
 
 /* irq_cfg is indexed by the sum of all RTEs in all I/O APICs. */
@@ -223,6 +226,122 @@ void arch_init_chip_data(struct irq_desc
 	}
 }
 
+#ifdef CONFIG_MOVE_IRQ_DESC
+
+static void init_copy_irq_2_pin(struct irq_cfg *old_cfg, struct irq_cfg *cfg,
+				 int cpu)
+{
+	struct irq_pin_list *old_entry, *head, *tail, *entry;
+
+	cfg->irq_2_pin = NULL;
+	old_entry = old_cfg->irq_2_pin;
+	if (!old_entry)
+		return;
+
+	entry = get_one_free_irq_2_pin(cpu);
+	if (!entry)
+		return;
+
+	entry->apic = old_entry->apic;
+	entry->pin = old_entry->pin;
+	head = entry;
+	tail = entry;
+	old_entry = old_entry->next;
+
+	while (old_entry) {
+		entry = get_one_free_irq_2_pin(cpu);
+		if (!entry) {
+			entry = head;
+			while (entry) {
+				head = entry->next;
+				kfree(entry);
+				entry = head;
+			}
+			/* still use the old one */
+			return;
+		}
+		entry->apic = old_entry->apic;
+		entry->pin = old_entry->pin;
+		tail->next = entry;
+		tail = entry;
+		old_entry = old_entry->next;
+	}
+
+	tail->next = NULL;
+	cfg->irq_2_pin = head;
+}
+
+static void free_irq_2_pin(struct irq_cfg *old_cfg, struct irq_cfg *cfg)
+{
+	struct irq_pin_list *entry, *next;
+
+	if (old_cfg->irq_2_pin == cfg->irq_2_pin)
+		return;
+
+	entry = old_cfg->irq_2_pin;
+
+	while (entry) {
+		next = entry->next;
+		kfree(entry);
+		entry = next;
+	}
+	old_cfg->irq_2_pin = NULL;
+}
+
+void arch_init_copy_chip_data(struct irq_desc *old_desc,
+				 struct irq_desc *desc, int cpu)
+{
+	struct irq_cfg *cfg;
+	struct irq_cfg *old_cfg;
+
+	cfg = get_one_free_irq_cfg(cpu);
+
+	if (!cfg)
+		return;
+
+	desc->chip_data = cfg;
+
+	old_cfg = old_desc->chip_data;
+
+	memcpy(cfg, old_cfg, sizeof(struct irq_cfg));
+
+	init_copy_irq_2_pin(old_cfg, cfg, cpu);
+}
+
+static void free_irq_cfg(struct irq_cfg *old_cfg)
+{
+	kfree(old_cfg);
+}
+
+void arch_free_chip_data(struct irq_desc *old_desc, struct irq_desc *desc)
+{
+	struct irq_cfg *old_cfg, *cfg;
+
+	old_cfg = old_desc->chip_data;
+	cfg = desc->chip_data;
+
+	if (old_cfg == cfg)
+		return;
+
+	if (old_cfg) {
+		free_irq_2_pin(old_cfg, cfg);
+		free_irq_cfg(old_cfg);
+		old_desc->chip_data = NULL;
+	}
+}
+
+static void set_extra_move_desc(struct irq_desc *desc, cpumask_t mask)
+{
+	struct irq_cfg *cfg = desc->chip_data;
+
+	if (!cfg->move_in_progress) {
+		/* it means that domain is not changed */
+		if (!cpus_intersects(desc->affinity, mask))
+			cfg->move_desc_in_progress_in_same_domain = 1;
+	}
+}
+#endif
+
 #else
 static struct irq_cfg *irq_cfg(unsigned int irq)
 {
@@ -231,9 +350,11 @@ static struct irq_cfg *irq_cfg(unsigned
 
 #endif
 
+#ifndef CONFIG_MOVE_IRQ_DESC
 static inline void set_extra_move_desc(struct irq_desc *desc, cpumask_t mask)
 {
 }
+#endif
 
 struct io_apic {
 	unsigned int index;
@@ -2346,14 +2467,34 @@ static void irq_complete_move(struct irq
 	struct irq_cfg *cfg = desc->chip_data;
 	unsigned vector, me;
 
-	if (likely(!cfg->move_in_progress))
+	if (likely(!cfg->move_in_progress)) {
+#ifdef CONFIG_MOVE_IRQ_DESC
+		if (likely(!cfg->move_desc_in_progress_in_same_domain))
+			return;
+
+		/* domain is not change, but affinity is changed */
+		me = smp_processor_id();
+		if (cpu_isset(me, desc->affinity)) {
+			*descp = desc = move_irq_desc(desc, me);
+			/* get the new one */
+			cfg = desc->chip_data;
+			cfg->move_desc_in_progress_in_same_domain = 0;
+		}
+#endif
 		return;
+	}
 
 	vector = ~get_irq_regs()->orig_ax;
 	me = smp_processor_id();
 	if ((vector == cfg->vector) && cpu_isset(me, cfg->domain)) {
 		cpumask_t cleanup_mask;
 
+#ifdef CONFIG_MOVE_IRQ_DESC
+		*descp = desc = move_irq_desc(desc, me);
+		/* get the new one */
+		cfg = desc->chip_data;
+#endif
+
 		cpus_and(cleanup_mask, cfg->old_domain, cpu_online_map);
 		cfg->move_cleanup_count = cpus_weight(cleanup_mask);
 		send_IPI_mask(cleanup_mask, IRQ_MOVE_CLEANUP_VECTOR);
Index: linux-2.6/kernel/irq/handle.c
===================================================================
--- linux-2.6.orig/kernel/irq/handle.c
+++ linux-2.6/kernel/irq/handle.c
@@ -90,6 +90,32 @@ static void init_kstat_irqs(struct irq_d
 		desc->kstat_irqs = (unsigned int *)ptr;
 }
 
+#ifdef CONFIG_MOVE_IRQ_DESC
+static void init_copy_kstat_irqs(struct irq_desc *old_desc, struct irq_desc *desc,
+				 int cpu, int nr)
+{
+	unsigned long bytes;
+
+	init_kstat_irqs(desc, cpu, nr);
+
+	if (desc->kstat_irqs != old_desc->kstat_irqs) {
+		/* Compute how many bytes we need per irq and allocate them */
+		bytes = nr * sizeof(unsigned int);
+
+		memcpy(desc->kstat_irqs, old_desc->kstat_irqs, bytes);
+	}
+}
+
+static void free_kstat_irqs(struct irq_desc *old_desc, struct irq_desc *desc)
+{
+	if (old_desc->kstat_irqs == desc->kstat_irqs)
+		return;
+
+	kfree(old_desc->kstat_irqs);
+	old_desc->kstat_irqs = NULL;
+}
+#endif
+
 void __attribute__((weak)) arch_init_chip_data(struct irq_desc *desc, int cpu)
 {
 }
@@ -110,6 +136,23 @@ static void init_one_irq_desc(int irq, s
 	arch_init_chip_data(desc, cpu);
 }
 
+#ifdef CONFIG_MOVE_IRQ_DESC
+static void init_copy_one_irq_desc(int irq, struct irq_desc *old_desc,
+		 struct irq_desc *desc, int cpu)
+{
+	memcpy(desc, old_desc, sizeof(struct irq_desc));
+	desc->cpu = cpu;
+	lockdep_set_class(&desc->lock, &irq_desc_lock_class);
+	init_copy_kstat_irqs(old_desc, desc, cpu, nr_cpu_ids);
+	arch_init_copy_chip_data(old_desc, desc, cpu);
+}
+
+static void free_one_irq_desc(struct irq_desc *old_desc, struct irq_desc *desc)
+{
+	free_kstat_irqs(old_desc, desc);
+	arch_free_chip_data(old_desc, desc);
+}
+#endif
 /*
  * Protect the sparse_irqs:
  */
@@ -203,6 +246,73 @@ out_unlock:
 	return desc;
 }
 
+#ifdef CONFIG_MOVE_IRQ_DESC
+static struct irq_desc *__real_move_irq_desc(struct irq_desc *old_desc,
+						int cpu)
+{
+	struct irq_desc *desc;
+	unsigned int irq;
+	unsigned long flags;
+	int node;
+
+	irq = old_desc->irq;
+
+	spin_lock_irqsave(&sparse_irq_lock, flags);
+
+	/* We have to check it to avoid races with another CPU */
+	desc = irq_desc_ptrs[irq];
+
+	if (desc && old_desc != desc)
+			goto out_unlock;
+
+	node = cpu_to_node(cpu);
+	desc = kzalloc_node(sizeof(*desc), GFP_ATOMIC, node);
+	printk(KERN_DEBUG "  move irq_desc for %d to cpu %d node %d\n",
+		 irq, cpu, node);
+	if (!desc) {
+		printk(KERN_ERR "can not get new irq_desc for moving\n");
+		/* still use old one */
+		desc = old_desc;
+		goto out_unlock;
+	}
+	init_copy_one_irq_desc(irq, old_desc, desc, cpu);
+
+	irq_desc_ptrs[irq] = desc;
+
+	/* free the old one */
+	free_one_irq_desc(old_desc, desc);
+	kfree(old_desc);
+
+out_unlock:
+	spin_unlock_irqrestore(&sparse_irq_lock, flags);
+
+	return desc;
+}
+
+struct irq_desc *move_irq_desc(struct irq_desc *desc, int cpu)
+{
+	int old_cpu;
+	int node, old_node;
+
+	/* those all static, do move them */
+	if (desc->irq < NR_IRQS_LEGACY)
+		return desc;
+
+	old_cpu = desc->cpu;
+	printk(KERN_DEBUG "try to move irq_desc from cpu %d to %d\n", old_cpu, cpu);
+	if (old_cpu != cpu) {
+		node = cpu_to_node(cpu);
+		old_node = cpu_to_node(old_cpu);
+		if (old_node != node)
+			desc = __real_move_irq_desc(desc, cpu);
+		else
+			desc->cpu = cpu;
+	}
+
+	return desc;
+}
+#endif
+
 #else
 
 struct irq_desc irq_desc[NR_IRQS] __cacheline_aligned_in_smp = {
@@ -337,8 +447,11 @@ unsigned int __do_IRQ(unsigned int irq)
 		/*
 		 * No locking required for CPU-local interrupts:
 		 */
-		if (desc->chip->ack)
+		if (desc->chip->ack) {
 			desc->chip->ack(irq);
+			/* get new one */
+			desc = irq_remap_to_desc(irq, desc);
+		}
 		if (likely(!(desc->status & IRQ_DISABLED))) {
 			action_ret = handle_IRQ_event(irq, desc->action);
 			if (!noirqdebug)
@@ -349,8 +462,10 @@ unsigned int __do_IRQ(unsigned int irq)
 	}
 
 	spin_lock(&desc->lock);
-	if (desc->chip->ack)
+	if (desc->chip->ack) {
 		desc->chip->ack(irq);
+		desc = irq_remap_to_desc(irq, desc);
+	}
 	/*
 	 * REPLAY is when Linux resends an IRQ that was dropped earlier
 	 * WAITING is used by probe to mark irqs that are being tested
Index: linux-2.6/kernel/irq/chip.c
===================================================================
--- linux-2.6.orig/kernel/irq/chip.c
+++ linux-2.6/kernel/irq/chip.c
@@ -354,6 +354,7 @@ handle_level_irq(unsigned int irq, struc
 
 	spin_lock(&desc->lock);
 	mask_ack_irq(desc, irq);
+	desc = irq_remap_to_desc(irq, desc);
 
 	if (unlikely(desc->status & IRQ_INPROGRESS))
 		goto out_unlock;
@@ -431,6 +432,7 @@ handle_fasteoi_irq(unsigned int irq, str
 	desc->status &= ~IRQ_INPROGRESS;
 out:
 	desc->chip->eoi(irq);
+	desc = irq_remap_to_desc(irq, desc);
 
 	spin_unlock(&desc->lock);
 }
@@ -467,12 +469,14 @@ handle_edge_irq(unsigned int irq, struct
 		    !desc->action)) {
 		desc->status |= (IRQ_PENDING | IRQ_MASKED);
 		mask_ack_irq(desc, irq);
+		desc = irq_remap_to_desc(irq, desc);
 		goto out_unlock;
 	}
 	kstat_incr_irqs_this_cpu(irq, desc);
 
 	/* Start handling the irq */
 	desc->chip->ack(irq);
+	desc = irq_remap_to_desc(irq, desc);
 
 	/* Mark the IRQ currently in progress.*/
 	desc->status |= IRQ_INPROGRESS;
@@ -533,8 +537,10 @@ handle_percpu_irq(unsigned int irq, stru
 	if (!noirqdebug)
 		note_interrupt(irq, desc, action_ret);
 
-	if (desc->chip->eoi)
+	if (desc->chip->eoi) {
 		desc->chip->eoi(irq);
+		desc = irq_remap_to_desc(irq, desc);
+	}
 }
 
 void
@@ -569,8 +575,10 @@ __set_irq_handler(unsigned int irq, irq_
 
 	/* Uninstall? */
 	if (handle == handle_bad_irq) {
-		if (desc->chip != &no_irq_chip)
+		if (desc->chip != &no_irq_chip) {
 			mask_ack_irq(desc, irq);
+			desc = irq_remap_to_desc(irq, desc);
+		}
 		desc->status |= IRQ_DISABLED;
 		desc->depth = 1;
 	}
Index: linux-2.6/include/linux/irq.h
===================================================================
--- linux-2.6.orig/include/linux/irq.h
+++ linux-2.6/include/linux/irq.h
@@ -227,6 +227,16 @@ extern struct irq_desc *move_irq_desc(st
 
 #endif
 
+static inline struct irq_desc *
+irq_remap_to_desc(unsigned int irq, struct irq_desc *desc)
+{
+#ifdef CONFIG_MOVE_IRQ_DESC
+	return irq_to_desc(irq);
+#else
+	return desc;
+#endif
+}
+
 /*
  * Migration helpers for obsolete names, they will go away:
  */

