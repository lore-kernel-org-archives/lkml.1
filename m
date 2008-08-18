Return-Path: <linux-kernel-owner+w=401wt.eu-S1752775AbYHRENq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752775AbYHRENq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2008 00:13:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752202AbYHRENb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Aug 2008 00:13:31 -0400
Received: from wa-out-1112.google.com ([209.85.146.177]:23416 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751276AbYHRENW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2008 00:13:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=HfG7XHHTsnfu+cL73u5UcCBA9qrm3sqJtVeM7gHYnwvrEpR4bWHlchZQ3Z6M+QD48C
         ByzDbelcjdiR2s96uFQFHIKvc85SB1B0Q9wIXOt5XA0UlZlqqdF8YgerGH0gXYJjSMIZ
         ahPMaA8BErxJ3CiYisbjFtnOWos3bWJC5x31E=
From: Yinghai Lu <yhlu.kernel@gmail.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Yinghai Lu <yhlu.kernel@gmail.com>
Subject: [PATCH 1/2] x86: make HAVE_SPARSE_IRQ support selectable
Date: Sun, 17 Aug 2008 21:12:28 -0700
Message-Id: <1219032749-9312-2-git-send-email-yhlu.kernel@gmail.com>
X-Mailer: git-send-email 1.5.4.5
In-Reply-To: <1219032749-9312-1-git-send-email-yhlu.kernel@gmail.com>
References: <no>
 <1219032749-9312-1-git-send-email-yhlu.kernel@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo said sparse_irq is some intrusive. need to make it selectable

to make it simple, remove irq_desc as parameter in some functions.
(ack, eoi, set_affinity).
may need to make member if irq_chip to take irq_desc, or struct irq later.

Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>
---
 arch/Kconfig              |    3 -
 arch/x86/Kconfig          |   12 ++++
 arch/x86/kernel/io_apic.c |  124 ++++++++++++++++++++++++++++++----------------
 arch/x86/kernel/irq_32.c  |    2 
 arch/x86/kernel/irq_64.c  |    4 -
 include/linux/irq.h       |   12 ----
 kernel/irq/chip.c         |   26 ---------
 kernel/irq/handle.c       |   34 +-----------
 kernel/irq/manage.c       |    8 --
 kernel/irq/migration.c    |    8 --
 10 files changed, 103 insertions(+), 130 deletions(-)

Index: linux-2.6/arch/Kconfig
===================================================================
--- linux-2.6.orig/arch/Kconfig
+++ linux-2.6/arch/Kconfig
@@ -106,6 +106,3 @@ config HAVE_CLK
 config HAVE_DYN_ARRAY
 	def_bool n
 
-config HAVE_SPARSE_IRQ
-	def_bool n
-
Index: linux-2.6/arch/x86/Kconfig
===================================================================
--- linux-2.6.orig/arch/x86/Kconfig
+++ linux-2.6/arch/x86/Kconfig
@@ -34,7 +34,6 @@ config X86
 	select HAVE_GENERIC_DMA_COHERENT if X86_32
 	select HAVE_EFFICIENT_UNALIGNED_ACCESS
 	select HAVE_DYN_ARRAY
-	select HAVE_SPARSE_IRQ
 
 config ARCH_DEFCONFIG
 	string
@@ -241,6 +240,17 @@ config SMP
 
 	  If you don't know what to do here, say N.
 
+config HAVE_SPARSE_IRQ
+	bool "Support sparse irq numbering"
+	depends on PCI_MSI || HT_IRQ
+	default y
+	help
+	  This enables support for sparse irq, esp for msi/msi-x. the irq
+	  number will be bus/dev/fn + 12bit. You may need if you have lots of
+	  cards supports msi-x installed.
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
@@ -107,7 +107,9 @@ struct irq_cfg;
 struct irq_pin_list;
 struct irq_cfg {
 	unsigned int irq;
+#ifdef CONFIG_HAVE_SPARSE_IRQ
 	struct irq_cfg *next;
+#endif
 	struct irq_pin_list *irq_2_pin;
 	cpumask_t domain;
 	cpumask_t old_domain;
@@ -137,20 +139,6 @@ static struct irq_cfg irq_cfg_legacy[] _
 };
 
 static struct irq_cfg irq_cfg_init = { .irq =  -1U, };
-/* need to be biger than size of irq_cfg_legacy */
-static int nr_irq_cfg = 32;
-
-static int __init parse_nr_irq_cfg(char *arg)
-{
-	if (arg) {
-		nr_irq_cfg = simple_strtoul(arg, NULL, 0);
-		if (nr_irq_cfg < 32)
-			nr_irq_cfg = 32;
-	}
-	return 0;
-}
-
-early_param("nr_irq_cfg", parse_nr_irq_cfg);
 
 static void init_one_irq_cfg(struct irq_cfg *cfg)
 {
@@ -158,7 +146,9 @@ static void init_one_irq_cfg(struct irq_
 }
 
 static struct irq_cfg *irq_cfgx;
+#ifdef CONFIG_HAVE_SPARSE_IRQ
 static struct irq_cfg *irq_cfgx_free;
+#endif
 static void __init init_work(void *data)
 {
 	struct dyn_array *da = data;
@@ -174,15 +164,34 @@ static void __init init_work(void *data)
 	for (i = legacy_count; i < *da->nr; i++)
 		init_one_irq_cfg(&cfg[i]);
 
+#ifdef CONFIG_HAVE_SPARSE_IRQ
 	for (i = 1; i < *da->nr; i++)
 		cfg[i-1].next = &cfg[i];
 
 	irq_cfgx_free = &irq_cfgx[legacy_count];
 	irq_cfgx[legacy_count - 1].next = NULL;
+#endif
 }
 
-#define for_each_irq_cfg(cfg)		\
-	for (cfg = irq_cfgx; cfg; cfg = cfg->next)
+#ifdef CONFIG_HAVE_SPARSE_IRQ
+/* need to be biger than size of irq_cfg_legacy */
+static int nr_irq_cfg = 32;
+
+static int __init parse_nr_irq_cfg(char *arg)
+{
+	if (arg) {
+		nr_irq_cfg = simple_strtoul(arg, NULL, 0);
+		if (nr_irq_cfg < 32)
+			nr_irq_cfg = 32;
+	}
+	return 0;
+}
+
+early_param("nr_irq_cfg", parse_nr_irq_cfg);
+
+#define for_each_irq_cfg(irqX, cfg)           \
+        for (cfg = irq_cfgx, irqX = cfg->irq; cfg; cfg = cfg->next, irqX = cfg ? cfg->irq : -1U)
+
 
 DEFINE_DYN_ARRAY(irq_cfgx, sizeof(struct irq_cfg), nr_irq_cfg, PAGE_SIZE, init_work);
 
@@ -273,7 +282,26 @@ static struct irq_cfg *irq_cfg_with_new(
 #endif
 	return cfg;
 }
+#else
 
+#define for_each_irq_cfg(irq, cfg)		\
+	for (irq = 0, cfg = &irq_cfgx[irq]; irq < nr_irqs; irq++, cfg = &irq_cfgx[irq])
+
+DEFINE_DYN_ARRAY(irq_cfgx, sizeof(struct irq_cfg), nr_irqs, PAGE_SIZE, init_work);
+
+struct irq_cfg *irq_cfg(unsigned int irq)
+{
+        if (irq < nr_irqs)
+                return &irq_cfgx[irq];
+
+        return NULL;
+}
+struct irq_cfg *irq_cfg_with_new(unsigned int irq)
+{
+        return irq_cfg(irq);
+}
+
+#endif
 /*
  * This is performance-critical, we want to do it O(1)
  *
@@ -506,12 +534,13 @@ static void __target_IO_APIC_irq(unsigne
 
 static int assign_irq_vector(int irq, cpumask_t mask);
 
-static void set_ioapic_affinity_irq(unsigned int irq, struct irq_desc *desc, cpumask_t mask)
+static void set_ioapic_affinity_irq(unsigned int irq, cpumask_t mask)
 {
 	struct irq_cfg *cfg;
 	unsigned long flags;
 	unsigned int dest;
 	cpumask_t tmp;
+	struct irq_desc *desc;
 
 	cpus_and(tmp, mask, cpu_online_map);
 	if (cpus_empty(tmp))
@@ -528,6 +557,7 @@ static void set_ioapic_affinity_irq(unsi
 	 */
 	dest = SET_APIC_LOGICAL_ID(dest);
 
+	desc = irq_desc(irq);
 	spin_lock_irqsave(&ioapic_lock, flags);
 	__target_IO_APIC_irq(irq, dest, cfg->vector);
 	desc->affinity = mask;
@@ -1289,11 +1319,10 @@ void __setup_vector_irq(int cpu)
 	struct irq_cfg *cfg;
 
 	/* Mark the inuse vectors */
-	for_each_irq_cfg(cfg) {
+	for_each_irq_cfg(irq, cfg) {
 		if (!cpu_isset(cpu, cfg->domain))
 			continue;
 		vector = cfg->vector;
-		irq = cfg->irq;
 		per_cpu(vector_irq, cpu)[vector] = irq;
 	}
 	/* Mark the free vectors */
@@ -1570,6 +1599,7 @@ __apicdebuginit(void) print_IO_APIC(void
 	union IO_APIC_reg_03 reg_03;
 	unsigned long flags;
 	struct irq_cfg *cfg;
+	unsigned int irq;
 
 	if (apic_verbosity == APIC_QUIET)
 		return;
@@ -1658,11 +1688,11 @@ __apicdebuginit(void) print_IO_APIC(void
 	}
 	}
 	printk(KERN_DEBUG "IRQ to pin mappings:\n");
-	for_each_irq_cfg(cfg) {
+	for_each_irq_cfg(irq, cfg) {
 		struct irq_pin_list *entry = cfg->irq_2_pin;
 		if (!entry)
 			continue;
-		printk(KERN_DEBUG "IRQ%d ", cfg->irq);
+		printk(KERN_DEBUG "IRQ%d ", irq);
 		for (;;) {
 			printk("-> %d:%d", entry->apic, entry->pin);
 			if (!entry->next)
@@ -2299,7 +2329,7 @@ static void ir_irq_migration(struct work
 				continue;
 			}
 
-			desc->chip->set_affinity(irq, desc, desc->pending_mask);
+			desc->chip->set_affinity(irq, desc->pending_mask);
 			spin_unlock_irqrestore(&desc->lock, flags);
 		}
 	}
@@ -2308,8 +2338,10 @@ static void ir_irq_migration(struct work
 /*
  * Migrates the IRQ destination in the process context.
  */
-static void set_ir_ioapic_affinity_irq(unsigned int irq, struct irq_desc *desc, cpumask_t mask)
+static void set_ir_ioapic_affinity_irq(unsigned int irq, cpumask_t mask)
 {
+	struct irq_desc *desc = irq_desc(irq);
+
 	if (desc->status & IRQ_LEVEL) {
 		desc->status |= IRQ_MOVE_PENDING;
 		desc->pending_mask = mask;
@@ -2381,19 +2413,21 @@ static void irq_complete_move(unsigned i
 static inline void irq_complete_move(unsigned int irq) {}
 #endif
 #ifdef CONFIG_INTR_REMAP
-static void ack_x2apic_level(unsigned int irq, struct irq_desc *desc)
+static void ack_x2apic_level(unsigned int irq)
 {
 	ack_x2APIC_irq();
 }
 
-static void ack_x2apic_edge(unsigned int irq, struct irq_desc *desc)
+static void ack_x2apic_edge(unsigned int irq)
 {
 	ack_x2APIC_irq();
 }
 #endif
 
-static void ack_apic_edge(unsigned int irq, struct irq_desc *desc)
+static void ack_apic_edge(unsigned int irq)
 {
+	struct irq_desc *desc = irq_desc(irq);
+
 	irq_complete_move(irq);
 	move_native_irq(irq, desc);
 	ack_APIC_irq();
@@ -2403,13 +2437,14 @@ static void ack_apic_edge(unsigned int i
 atomic_t irq_mis_count;
 #endif
 
-static void ack_apic_level(unsigned int irq, struct irq_desc *desc)
+static void ack_apic_level(unsigned int irq)
 {
 #ifdef CONFIG_X86_32
 	unsigned long v;
 	int i;
 #endif
 	int do_unmask_irq = 0;
+	struct irq_desc *desc = irq_desc(irq);
 
 	irq_complete_move(irq);
 #ifdef CONFIG_GENERIC_PENDING_IRQ
@@ -2540,8 +2575,7 @@ static inline void init_IO_APIC_traps(vo
 	 * Also, we've got to be careful not to trash gate
 	 * 0x80, because int 0x80 is hm, kind of importantish. ;)
 	 */
-	for_each_irq_cfg(cfg) {
-		irq = cfg->irq;
+	for_each_irq_cfg(irq, cfg) {
 		if (IO_APIC_IRQ(irq) && !cfg->vector) {
 			/*
 			 * Hmm.. We don't have an entry for this,
@@ -2579,7 +2613,7 @@ static void unmask_lapic_irq(unsigned in
 	apic_write(APIC_LVT0, v & ~APIC_LVT_MASKED);
 }
 
-static void ack_lapic_irq(unsigned int irq, struct irq_desc *desc)
+static void ack_lapic_irq(unsigned int irq)
 {
 	ack_APIC_irq();
 }
@@ -3128,12 +3162,13 @@ static int msi_compose_msg(struct pci_de
 }
 
 #ifdef CONFIG_SMP
-static void set_msi_irq_affinity(unsigned int irq, struct irq_desc *desc, cpumask_t mask)
+static void set_msi_irq_affinity(unsigned int irq, cpumask_t mask)
 {
 	struct irq_cfg *cfg;
 	struct msi_msg msg;
 	unsigned int dest;
 	cpumask_t tmp;
+	struct irq_desc *desc;
 
 	cpus_and(tmp, mask, cpu_online_map);
 	if (cpus_empty(tmp))
@@ -3154,6 +3189,7 @@ static void set_msi_irq_affinity(unsigne
 	msg.address_lo |= MSI_ADDR_DEST_ID(dest);
 
 	write_msi_msg(irq, &msg);
+	desc = irq_desc(irq);
 	desc->affinity = mask;
 }
 
@@ -3162,12 +3198,13 @@ static void set_msi_irq_affinity(unsigne
  * Migrate the MSI irq to another cpumask. This migration is
  * done in the process context using interrupt-remapping hardware.
  */
-static void ir_set_msi_irq_affinity(unsigned int irq, struct irq_desc *desc, cpumask_t mask)
+static void ir_set_msi_irq_affinity(unsigned int irq, cpumask_t mask)
 {
 	struct irq_cfg *cfg;
 	unsigned int dest;
 	cpumask_t tmp, cleanup_mask;
 	struct irte irte;
+	struct irq_desc *desc;
 
 	cpus_and(tmp, mask, cpu_online_map);
 	if (cpus_empty(tmp))
@@ -3203,6 +3240,7 @@ static void ir_set_msi_irq_affinity(unsi
 		cfg->move_in_progress = 0;
 	}
 
+	desc = irq_desc(irq);
 	desc->affinity = mask;
 }
 #endif
@@ -3403,12 +3441,13 @@ void arch_teardown_msi_irq(unsigned int
 
 #ifdef CONFIG_DMAR
 #ifdef CONFIG_SMP
-static void dmar_msi_set_affinity(unsigned int irq, struct irq_desc *desc, cpumask_t mask)
+static void dmar_msi_set_affinity(unsigned int irq, cpumask_t mask)
 {
 	struct irq_cfg *cfg;
 	struct msi_msg msg;
 	unsigned int dest;
 	cpumask_t tmp;
+	struct irq_desc *desc;
 
 	cpus_and(tmp, mask, cpu_online_map);
 	if (cpus_empty(tmp))
@@ -3429,6 +3468,8 @@ static void dmar_msi_set_affinity(unsign
 	msg.address_lo |= MSI_ADDR_DEST_ID(dest);
 
 	dmar_msi_write(irq, &msg);
+
+	desc = irq_desc(irq);
 	desc->affinity = mask;
 }
 #endif /* CONFIG_SMP */
@@ -3481,11 +3522,12 @@ static void target_ht_irq(unsigned int i
 	write_ht_irq_msg(irq, &msg);
 }
 
-static void set_ht_irq_affinity(unsigned int irq, struct irq_desc *desc, cpumask_t mask)
+static void set_ht_irq_affinity(unsigned int irq, cpumask_t mask)
 {
 	struct irq_cfg *cfg;
 	unsigned int dest;
 	cpumask_t tmp;
+	struct irq_desc *desc;
 
 	cpus_and(tmp, mask, cpu_online_map);
 	if (cpus_empty(tmp))
@@ -3499,6 +3541,7 @@ static void set_ht_irq_affinity(unsigned
 	dest = cpu_mask_to_apicid(tmp);
 
 	target_ht_irq(irq, dest, cfg->vector);
+	desc = irq_desc(irq);
 	desc->affinity = mask;
 }
 #endif
@@ -3712,7 +3755,6 @@ void __init setup_ioapic_dest(void)
 {
 	int pin, ioapic, irq, irq_entry;
 	struct irq_cfg *cfg;
-	struct irq_desc *desc;
 
 	if (skip_ioapic_setup == 1)
 		return;
@@ -3734,15 +3776,11 @@ void __init setup_ioapic_dest(void)
 						  irq_trigger(irq_entry),
 						  irq_polarity(irq_entry));
 #ifdef CONFIG_INTR_REMAP
-			else if (intr_remapping_enabled) {
-				desc = irq_desc(irq);
-				set_ir_ioapic_affinity_irq(irq, desc, TARGET_CPUS);
-			}
+			else if (intr_remapping_enabled)
+				set_ir_ioapic_affinity_irq(irq, TARGET_CPUS);
 #endif
-			else {
-				desc = irq_desc(irq);
-				set_ioapic_affinity_irq(irq, desc, TARGET_CPUS);
-			}
+			else
+				set_ioapic_affinity_irq(irq, TARGET_CPUS);
 		}
 	}
 }
Index: linux-2.6/arch/x86/kernel/irq_64.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/irq_64.c
+++ linux-2.6/arch/x86/kernel/irq_64.c
@@ -74,7 +74,7 @@ int show_interrupts(struct seq_file *p,
 	struct irqaction * action;
 	unsigned long flags;
 	unsigned int entries;
-	struct irq_desc *desc;
+	struct irq_desc *desc = NULL;
 	int tail = 0;
 
 #ifdef CONFIG_HAVE_SPARSE_IRQ
@@ -275,7 +275,7 @@ void fixup_irqs(cpumask_t map)
 			desc->chip->mask(irq);
 
 		if (desc->chip->set_affinity)
-			desc->chip->set_affinity(irq, desc, mask);
+			desc->chip->set_affinity(irq, mask);
 		else if (!(warned++))
 			set_affinity = 0;
 
Index: linux-2.6/include/linux/irq.h
===================================================================
--- linux-2.6.orig/include/linux/irq.h
+++ linux-2.6/include/linux/irq.h
@@ -104,26 +104,14 @@ struct irq_chip {
 	void		(*enable)(unsigned int irq);
 	void		(*disable)(unsigned int irq);
 
-#ifdef CONFIG_HAVE_SPARSE_IRQ
-	void		(*ack)(unsigned int irq, struct irq_desc *desc);
-#else
 	void		(*ack)(unsigned int irq);
-#endif
 	void		(*mask)(unsigned int irq);
 	void		(*mask_ack)(unsigned int irq);
 	void		(*unmask)(unsigned int irq);
-#ifdef CONFIG_HAVE_SPARSE_IRQ
-	void		(*eoi)(unsigned int irq, struct irq_desc *desc);
-#else
 	void		(*eoi)(unsigned int irq);
-#endif
 
 	void		(*end)(unsigned int irq);
-#ifdef CONFIG_HAVE_SPARSE_IRQ
-	void		(*set_affinity)(unsigned int irq, struct irq_desc *desc, cpumask_t dest);
-#else
 	void		(*set_affinity)(unsigned int irq, cpumask_t dest);
-#endif
 	int		(*retrigger)(unsigned int irq);
 	int		(*set_type)(unsigned int irq, unsigned int flow_type);
 	int		(*set_wake)(unsigned int irq, unsigned int on);
Index: linux-2.6/kernel/irq/chip.c
===================================================================
--- linux-2.6.orig/kernel/irq/chip.c
+++ linux-2.6/kernel/irq/chip.c
@@ -299,11 +299,7 @@ static inline void mask_ack_irq(struct i
 		desc->chip->mask_ack(irq);
 	else {
 		desc->chip->mask(irq);
-#ifdef CONFIG_HAVE_SPARSE_IRQ
-		desc->chip->ack(irq, desc);
-#else
 		desc->chip->ack(irq);
-#endif
 	}
 }
 
@@ -443,11 +439,7 @@ handle_fasteoi_irq(unsigned int irq, str
 	spin_lock(&desc->lock);
 	desc->status &= ~IRQ_INPROGRESS;
 out:
-#ifdef CONFIG_HAVE_SPARSE_IRQ
-	desc->chip->eoi(irq, desc);
-#else
 	desc->chip->eoi(irq);
-#endif
 
 	spin_unlock(&desc->lock);
 }
@@ -490,11 +482,7 @@ handle_edge_irq(unsigned int irq, struct
 	kstat_irqs_this_cpu(desc)++;
 
 	/* Start handling the irq */
-#ifdef CONFIG_HAVE_SPARSE_IRQ
-	desc->chip->ack(irq, desc);
-#else
 	desc->chip->ack(irq);
-#endif
 
 	/* Mark the IRQ currently in progress.*/
 	desc->status |= IRQ_INPROGRESS;
@@ -548,25 +536,15 @@ handle_percpu_irq(unsigned int irq, stru
 
 	kstat_irqs_this_cpu(desc)++;
 
-	if (desc->chip->ack) {
-#ifdef CONFIG_HAVE_SPARSE_IRQ
-		desc->chip->ack(irq, desc);
-#else
+	if (desc->chip->ack)
 		desc->chip->ack(irq);
-#endif
-	}
 
 	action_ret = handle_IRQ_event(irq, desc->action);
 	if (!noirqdebug)
 		note_interrupt(irq, desc, action_ret);
 
-	if (desc->chip->eoi) {
-#ifdef CONFIG_HAVE_SPARSE_IRQ
-		desc->chip->eoi(irq, desc);
-#else
+	if (desc->chip->eoi)
 		desc->chip->eoi(irq);
-#endif
-	}
 }
 
 void
Index: linux-2.6/kernel/irq/handle.c
===================================================================
--- linux-2.6.orig/kernel/irq/handle.c
+++ linux-2.6/kernel/irq/handle.c
@@ -285,13 +285,6 @@ struct irq_desc *irq_desc_with_new(unsig
  * What should we do if we get a hw irq event on an illegal vector?
  * Each architecture has to answer this themself.
  */
-#ifdef CONFIG_HAVE_SPARSE_IRQ
-static void ack_bad(unsigned int irq, struct irq_desc *desc)
-{
-	print_irq_desc(irq, desc);
-	ack_bad_irq(irq);
-}
-#else
 static void ack_bad(unsigned int irq)
 {
 	struct irq_desc *desc;
@@ -300,7 +293,6 @@ static void ack_bad(unsigned int irq)
 	print_irq_desc(irq, desc);
 	ack_bad_irq(irq);
 }
-#endif
 
 /*
  * NOP functions
@@ -309,12 +301,6 @@ static void noop(unsigned int irq)
 {
 }
 
-#ifdef CONFIG_HAVE_SPARSE_IRQ
-static void noop_desc(unsigned int irq, struct irq_desc *desc)
-{
-}
-#endif
-
 static unsigned int noop_ret(unsigned int irq)
 {
 	return 0;
@@ -343,11 +329,7 @@ struct irq_chip dummy_irq_chip = {
 	.shutdown	= noop,
 	.enable		= noop,
 	.disable	= noop,
-#ifdef CONFIG_HAVE_SPARSE_IRQ
-	.ack		= noop_desc,
-#else
 	.ack		= noop,
-#endif
 	.mask		= noop,
 	.unmask		= noop,
 	.end		= noop,
@@ -415,13 +397,9 @@ unsigned int __do_IRQ(unsigned int irq,
 		/*
 		 * No locking required for CPU-local interrupts:
 		 */
-		if (desc->chip->ack) {
-#ifdef CONFIG_HAVE_SPARSE_IRQ
-			desc->chip->ack(irq, desc);
-#else
+		if (desc->chip->ack)
 			desc->chip->ack(irq);
-#endif
-		}
+
 		if (likely(!(desc->status & IRQ_DISABLED))) {
 			action_ret = handle_IRQ_event(irq, desc->action);
 			if (!noirqdebug)
@@ -432,13 +410,9 @@ unsigned int __do_IRQ(unsigned int irq,
 	}
 
 	spin_lock(&desc->lock);
-	if (desc->chip->ack) {
-#ifdef CONFIG_HAVE_SPARSE_IRQ
-		desc->chip->ack(irq, desc);
-#else
+	if (desc->chip->ack)
 		desc->chip->ack(irq);
-#endif
-	}
+
 	/*
 	 * REPLAY is when Linux resends an IRQ that was dropped earlier
 	 * WAITING is used by probe to mark irqs that are being tested
Index: linux-2.6/kernel/irq/manage.c
===================================================================
--- linux-2.6.orig/kernel/irq/manage.c
+++ linux-2.6/kernel/irq/manage.c
@@ -91,11 +91,7 @@ int irq_set_affinity(unsigned int irq, c
 		unsigned long flags;
 
 		spin_lock_irqsave(&desc->lock, flags);
-#ifdef CONFIG_HAVE_SPARSE_IRQ
-		desc->chip->set_affinity(irq, desc, cpumask);
-#else
 		desc->chip->set_affinity(irq, cpumask);
-#endif
 		spin_unlock_irqrestore(&desc->lock, flags);
 	} else
 		set_pending_irq(irq, cpumask);
@@ -122,11 +118,7 @@ int irq_select_affinity(unsigned int irq
 
 	desc = irq_desc(irq);
 	desc->affinity = mask;
-#ifdef CONFIG_HAVE_SPARSE_IRQ
-	desc->chip->set_affinity(irq, desc, mask);
-#else
 	desc->chip->set_affinity(irq, mask);
-#endif
 
 	return 0;
 }
Index: linux-2.6/kernel/irq/migration.c
===================================================================
--- linux-2.6.orig/kernel/irq/migration.c
+++ linux-2.6/kernel/irq/migration.c
@@ -51,13 +51,9 @@ void move_masked_irq(int irq, struct irq
 	 * For correct operation this depends on the caller
 	 * masking the irqs.
 	 */
-	if (likely(!cpus_empty(tmp))) {
-#ifdef CONFIG_HAVE_SPARSE_IRQ
-		desc->chip->set_affinity(irq, desc, tmp);
-#else
+	if (likely(!cpus_empty(tmp)))
 		desc->chip->set_affinity(irq, tmp);
-#endif
-	}
+
 	cpus_clear(desc->pending_mask);
 }
 
Index: linux-2.6/arch/x86/kernel/irq_32.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/irq_32.c
+++ linux-2.6/arch/x86/kernel/irq_32.c
@@ -269,7 +269,7 @@ int show_interrupts(struct seq_file *p,
 	struct irqaction * action;
 	unsigned long flags;
 	unsigned int entries;
-	struct irq_desc *desc;
+	struct irq_desc *desc = NULL;
 	int tail = 0;
 
 #ifdef CONFIG_HAVE_SPARSE_IRQ
@@ -434,7 +434,7 @@ void fixup_irqs(cpumask_t map)
 			mask = map;
 		}
 		if (desc->chip->set_affinity)
-			desc->chip->set_affinity(irq, desc, mask);
+			desc->chip->set_affinity(irq, mask);
 		else if (desc->action && !(warned++))
 			printk("Cannot set affinity for irq %i\n", irq);
 	}
