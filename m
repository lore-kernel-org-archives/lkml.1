Return-Path: <linux-kernel-owner+w=401wt.eu-S1759849AbYGKVSr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759849AbYGKVSr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2008 17:18:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754805AbYGKVSb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Jul 2008 17:18:31 -0400
Received: from mail.tor.primus.ca ([216.254.136.21]:49497 "EHLO
	mail-09.primus.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752487AbYGKVS3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2008 17:18:29 -0400
From: Matthew Wilcox <matthew@wil.cx>
To: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: grundler@parisc-linux.org, mingo@elte.hu, tglx@linutronix.de,
       jgarzik@pobox.com, linux-ide@vger.kernel.org, suresh.b.siddha@intel.com,
       benh@kernel.crashing.org, jbarnes@virtuousgeek.org,
       rdunlap@xenotime.net, mtk.manpages@gmail.com, ebiederm@xmission.com,
       Matthew Wilcox <matthew@wil.cx>, Matthew Wilcox <willy@linux.intel.com>
Subject: [PATCH 6/6] x86-64: Support for multiple MSIs
Date: Fri, 11 Jul 2008 17:16:58 -0400
Message-Id: <1215811018-15270-6-git-send-email-matthew@wil.cx>
X-Mailer: git-send-email 1.5.5.4
In-Reply-To: <20080711211559.GV14894@parisc-linux.org>
References: <20080711211559.GV14894@parisc-linux.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add support for allocating an aligned block of interrupt vectors.
Allow interrupts to have up to 32 subchannels.
Implement the arch_setup_msi_irqs() and arch_teardown_msi_irqs()
interfaces.

Signed-off-by: Matthew Wilcox <willy@linux.intel.com>
---
 arch/x86/kernel/io_apic_64.c |  221 +++++++++++++++++++++++++++++++++++------
 arch/x86/kernel/irq_64.c     |    2 +-
 include/asm-x86/irq_64.h     |    2 +
 3 files changed, 191 insertions(+), 34 deletions(-)

diff --git a/arch/x86/kernel/io_apic_64.c b/arch/x86/kernel/io_apic_64.c
index ef1a8df..4edf988 100644
--- a/arch/x86/kernel/io_apic_64.c
+++ b/arch/x86/kernel/io_apic_64.c
@@ -61,7 +61,7 @@ struct irq_cfg {
 };
 
 /* irq_cfg is indexed by the sum of all RTEs in all I/O APICs. */
-struct irq_cfg irq_cfg[NR_IRQS] __read_mostly = {
+static struct irq_cfg irq_cfg[NR_IRQS] __read_mostly = {
 	[0]  = { .domain = CPU_MASK_ALL, .vector = IRQ0_VECTOR,  },
 	[1]  = { .domain = CPU_MASK_ALL, .vector = IRQ1_VECTOR,  },
 	[2]  = { .domain = CPU_MASK_ALL, .vector = IRQ2_VECTOR,  },
@@ -683,6 +683,8 @@ static int pin_2_irq(int idx, int apic, int pin)
 	return irq;
 }
 
+static int current_vector = FIRST_DEVICE_VECTOR;
+
 static int __assign_irq_vector(int irq, cpumask_t mask)
 {
 	/*
@@ -696,7 +698,7 @@ static int __assign_irq_vector(int irq, cpumask_t mask)
 	 * Also, we've got to be careful not to trash gate
 	 * 0x80, because int 0x80 is hm, kind of importantish. ;)
 	 */
-	static int current_vector = FIRST_DEVICE_VECTOR, current_offset = 0;
+	static int current_offset = 0;
 	unsigned int old_vector;
 	int cpu;
 	struct irq_cfg *cfg;
@@ -769,11 +771,98 @@ static int assign_irq_vector(int irq, cpumask_t mask)
 	return err;
 }
 
-static void __clear_irq_vector(int irq)
+static int __assign_irq_vector_block(int irq, int count, cpumask_t mask)
+{
+	unsigned int old_vector;
+	int i, cpu;
+	struct irq_cfg *cfg;
+
+	/*
+	 * We've got to be careful not to trash gate 0x80,
+	 * because int 0x80 is hm, kind of importantish. ;)
+	 */
+	BUG_ON((unsigned)irq >= NR_IRQS);
+	cfg = &irq_cfg[irq];
+
+	/* Only try and allocate irqs on cpus that are present */
+	cpus_and(mask, mask, cpu_online_map);
+
+	if ((cfg->move_in_progress) || cfg->move_cleanup_count)
+		return -EBUSY;
+
+	old_vector = cfg->vector;
+	if (old_vector) {
+		cpumask_t tmp;
+		cpus_and(tmp, cfg->domain, mask);
+		if (!cpus_empty(tmp))
+			return 0;
+	}
+
+	for_each_cpu_mask(cpu, mask) {
+		cpumask_t domain, new_mask;
+		int new_cpu;
+		int vector;
+
+		domain = vector_allocation_domain(cpu);
+		cpus_and(new_mask, domain, cpu_online_map);
+
+		vector = current_vector & ~(count - 1);
+ next:
+		vector += count;
+		if (vector + count >= FIRST_SYSTEM_VECTOR) {
+			vector = FIRST_DEVICE_VECTOR & ~(count - 1);
+			if (vector < FIRST_DEVICE_VECTOR)
+				vector += count;
+		}
+		if (unlikely(vector == (current_vector & ~(count - 1))))
+			continue;
+		if ((IA32_SYSCALL_VECTOR >= vector) &&
+		    (IA32_SYSCALL_VECTOR < vector + count))
+			goto next;
+		for_each_cpu_mask(new_cpu, new_mask) {
+			for (i = 0; i < count; i++) {
+				if (per_cpu(vector_irq, new_cpu)[vector + i]
+									!= -1)
+					goto next;
+			}
+		}
+		/* Found one! */
+		current_vector = vector + count - 1;
+		if (old_vector) {
+			cfg->move_in_progress = 1;
+			cfg->old_domain = cfg->domain;
+		}
+		for_each_cpu_mask(new_cpu, new_mask) {
+			for (i = 0; i < count; i++) {
+				per_cpu(vector_irq, new_cpu)[vector + i] =
+					irq | (i << IRQ_SUBCHANNEL_SHIFT);
+			}
+		}
+		cfg->vector = vector;
+		cfg->domain = domain;
+		return 0;
+	}
+	return -ENOSPC;
+}
+
+/* Assumes that count is a power of two and aligns to that power of two */
+static int assign_irq_vector_block(int irq, int count, cpumask_t mask)
+{
+	int result;
+	unsigned long flags;
+
+	spin_lock_irqsave(&vector_lock, flags);
+	result = __assign_irq_vector_block(irq, count, mask);
+	spin_unlock_irqrestore(&vector_lock, flags);
+
+	return result;
+}
+
+static void __clear_irq_vectors(int irq, int count)
 {
 	struct irq_cfg *cfg;
 	cpumask_t mask;
-	int cpu, vector;
+	int cpu, vector, i;
 
 	BUG_ON((unsigned)irq >= NR_IRQS);
 	cfg = &irq_cfg[irq];
@@ -781,8 +870,10 @@ static void __clear_irq_vector(int irq)
 
 	vector = cfg->vector;
 	cpus_and(mask, cfg->domain, cpu_online_map);
-	for_each_cpu_mask(cpu, mask)
-		per_cpu(vector_irq, cpu)[vector] = -1;
+	for_each_cpu_mask(cpu, mask) {
+		for (i = 0; i < count; i++)
+			per_cpu(vector_irq, cpu)[vector + i] = -1;
+	}
 
 	cfg->vector = 0;
 	cpus_clear(cfg->domain);
@@ -1895,11 +1986,11 @@ device_initcall(ioapic_init_sysfs);
 /*
  * Dynamic irq allocate and deallocation
  */
-int create_irq(void)
+
+static int create_irq_block(int count)
 {
 	/* Allocate an unused irq */
-	int irq;
-	int new;
+	int irq, rc, new;
 	unsigned long flags;
 
 	irq = -ENOSPC;
@@ -1909,34 +2000,49 @@ int create_irq(void)
 			continue;
 		if (irq_cfg[new].vector != 0)
 			continue;
-		if (__assign_irq_vector(new, TARGET_CPUS) == 0)
+		if (count == 1)
+			rc = __assign_irq_vector(new, TARGET_CPUS);
+		else
+			rc = __assign_irq_vector_block(new, count, TARGET_CPUS);
+
+		if (rc == 0)
 			irq = new;
 		break;
 	}
 	spin_unlock_irqrestore(&vector_lock, flags);
 
-	if (irq >= 0) {
+	if (irq >= 0)
 		dynamic_irq_init(irq);
-	}
 	return irq;
 }
 
-void destroy_irq(unsigned int irq)
+int create_irq(void)
+{
+	return create_irq_block(1);
+}
+
+static void destroy_irq_block(unsigned int irq, int count)
 {
 	unsigned long flags;
 
 	dynamic_irq_cleanup(irq);
 
 	spin_lock_irqsave(&vector_lock, flags);
-	__clear_irq_vector(irq);
+	__clear_irq_vectors(irq, count);
 	spin_unlock_irqrestore(&vector_lock, flags);
 }
 
+void destroy_irq(unsigned int irq)
+{
+	destroy_irq_block(irq, 1);
+}
+
 /*
  * MSI message composition
  */
 #ifdef CONFIG_PCI_MSI
-static int msi_compose_msg(struct pci_dev *pdev, unsigned int irq, struct msi_msg *msg)
+static int msi_compose_msg(struct pci_dev *pdev, unsigned int irq,
+				unsigned int count, struct msi_msg *msg)
 {
 	struct irq_cfg *cfg = irq_cfg + irq;
 	int err;
@@ -1944,7 +2050,10 @@ static int msi_compose_msg(struct pci_dev *pdev, unsigned int irq, struct msi_ms
 	cpumask_t tmp;
 
 	tmp = TARGET_CPUS;
-	err = assign_irq_vector(irq, tmp);
+	if (count == 1)
+		err = assign_irq_vector(irq, tmp);
+	else
+		err = assign_irq_vector_block(irq, count, tmp);
 	if (!err) {
 		cpus_and(tmp, cfg->domain, tmp);
 		dest = cpu_mask_to_apicid(tmp);
@@ -1975,6 +2084,8 @@ static int msi_compose_msg(struct pci_dev *pdev, unsigned int irq, struct msi_ms
 static void set_msi_irq_affinity(unsigned int irq, cpumask_t mask)
 {
 	struct irq_cfg *cfg = irq_cfg + irq;
+	struct msi_desc *desc = get_irq_msi(irq);
+	int count = 1 << desc->msi_attrib.multiple;
 	struct msi_msg msg;
 	unsigned int dest;
 	cpumask_t tmp;
@@ -1983,8 +2094,13 @@ static void set_msi_irq_affinity(unsigned int irq, cpumask_t mask)
 	if (cpus_empty(tmp))
 		return;
 
-	if (assign_irq_vector(irq, mask))
-		return;
+	if (count > 1) {
+		if (assign_irq_vector_block(irq, count, mask))
+			return;
+	} else {
+		if (assign_irq_vector(irq, mask))
+			return;
+	}
 
 	cpus_and(tmp, cfg->domain, mask);
 	dest = cpu_mask_to_apicid(tmp);
@@ -2016,31 +2132,70 @@ static struct irq_chip msi_chip = {
 	.retrigger	= ioapic_retrigger_irq,
 };
 
-int arch_setup_msi_irq(struct pci_dev *dev, struct msi_desc *desc)
+static int x86_setup_msi_irq(struct pci_dev *pdev, struct msi_desc *desc, int count)
 {
 	struct msi_msg msg;
-	int irq, ret;
-	irq = create_irq();
-	if (irq < 0)
-		return irq;
-
-	ret = msi_compose_msg(dev, irq, &msg);
-	if (ret < 0) {
-		destroy_irq(irq);
-		return ret;
+	int irq, ret, alloc;
+
+	/* MSI can only allocate a power-of-two */
+	alloc = roundup_pow_of_two(count);
+
+	for (;;) {
+		irq = create_irq_block(alloc);
+		if (irq >= 0) {
+			if (alloc >= count)
+				break;
+			destroy_irq_block(irq, count);
+			return count;
+		}
+		if (alloc == 1)
+			return irq;
+		alloc /= 2;
 	}
 
-	set_irq_msi(irq, desc);
-	write_msi_msg(irq, &msg);
+	ret = msi_compose_msg(pdev, irq, alloc, &msg);
+	if (ret)
+		return ret;
 
+	desc->msi_attrib.multiple = order_base_2(alloc);
+
+	set_irq_msi(irq, desc);
 	set_irq_chip_and_handler_name(irq, &msi_chip, handle_edge_irq, "edge");
+	write_msi_msg(irq, &msg);
 
 	return 0;
 }
 
-void arch_teardown_msi_irq(unsigned int irq)
+int arch_setup_msi_irqs(struct pci_dev *pdev, int nvec, int type)
 {
-	destroy_irq(irq);
+	struct msi_desc *desc;
+	int ret;
+
+	if (type == PCI_CAP_ID_MSI) {
+		desc = list_first_entry(&pdev->msi_list, struct msi_desc, list);
+		ret = x86_setup_msi_irq(pdev, desc, nvec);
+	} else {
+		list_for_each_entry(desc, &pdev->msi_list, list) {
+			ret = x86_setup_msi_irq(pdev, desc, 1);
+			if (ret)
+				break;
+		}
+	}
+
+	return ret;
+}
+
+void arch_teardown_msi_irqs(struct pci_dev *dev)
+{
+	struct msi_desc *entry;
+
+	list_for_each_entry(entry, &dev->msi_list, list) {
+		int nvec;
+		if (entry->irq == 0)
+			continue;
+		nvec = 1 << entry->msi_attrib.multiple;
+		destroy_irq_block(entry->irq, nvec);
+	}
 }
 
 #ifdef CONFIG_DMAR
@@ -2090,7 +2245,7 @@ int arch_setup_dmar_msi(unsigned int irq)
 	int ret;
 	struct msi_msg msg;
 
-	ret = msi_compose_msg(NULL, irq, &msg);
+	ret = msi_compose_msg(NULL, irq, 1, &msg);
 	if (ret < 0)
 		return ret;
 	dmar_msi_write(irq, &msg);
diff --git a/arch/x86/kernel/irq_64.c b/arch/x86/kernel/irq_64.c
index 3aac154..dbb5487 100644
--- a/arch/x86/kernel/irq_64.c
+++ b/arch/x86/kernel/irq_64.c
@@ -173,7 +173,7 @@ asmlinkage unsigned int do_IRQ(struct pt_regs *regs)
 	stack_overflow_check(regs);
 #endif
 
-	if (likely(irq < NR_IRQS))
+	if (likely((get_irq_value(irq)) < NR_IRQS))
 		generic_handle_irq(irq);
 	else {
 		if (!disable_apic)
diff --git a/include/asm-x86/irq_64.h b/include/asm-x86/irq_64.h
index 083d35a..5259854 100644
--- a/include/asm-x86/irq_64.h
+++ b/include/asm-x86/irq_64.h
@@ -34,6 +34,8 @@
 #define NR_IRQS (NR_VECTORS + (32 * NR_CPUS))
 #define NR_IRQ_VECTORS NR_IRQS
 
+#define IRQ_SUBCHANNEL_BITS	5
+
 static inline int irq_canonicalize(int irq)
 {
 	return ((irq == 2) ? 9 : irq);
-- 
1.5.5.4

