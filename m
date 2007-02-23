Return-Path: <linux-kernel-owner+w=401wt.eu-S932109AbXBWLgU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932109AbXBWLgU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Feb 2007 06:36:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932114AbXBWLgU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Feb 2007 06:36:20 -0500
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:45742 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932109AbXBWLgS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Feb 2007 06:36:18 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: Andrew Morton <akpm@osdl.org>
Cc: linux-kernel@vger.kernel.org, Zwane Mwaikambo <zwane@infradead.org>,
       Ashok Raj <ashok.raj@intel.com>, Ingo Molnar <mingo@elte.hu>,
       "Lu, Yinghai" <yinghai.lu@amd.com>,
       Natalie Protasevich <protasnb@gmail.com>, Andi Kleen <ak@suse.de>,
       "Siddha, Suresh B" <suresh.b.siddha@intel.com>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 10/14] x86_64 irq: Simplify assign_irq_vector's arguments.
References: <200701221116.13154.luigi.genoni@pirelli.com>
	<m1wt2s8ksa.fsf@ebiederm.dsl.xmission.com>
	<m1veib6dgi.fsf@ebiederm.dsl.xmission.com>
	<m1hctt1sfp.fsf_-_@ebiederm.dsl.xmission.com>
	<Pine.LNX.4.64.0702102146380.8245@montezuma.fsmlabs.com>
	<m13b5d0zdp.fsf@ebiederm.dsl.xmission.com>
	<Pine.LNX.4.64.0702110753390.8245@montezuma.fsmlabs.com>
	<m17iuoz74f.fsf@ebiederm.dsl.xmission.com>
	<Pine.LNX.4.64.0702111416220.24829@montezuma.fsmlabs.com>
	<m1r6swx9l2.fsf@ebiederm.dsl.xmission.com>
	<m1irdtw3jb.fsf_-_@ebiederm.dsl.xmission.com>
	<m1bqjlw2mr.fsf_-_@ebiederm.dsl.xmission.com>
	<m17iu9w2kj.fsf_-_@ebiederm.dsl.xmission.com>
	<m13b4xw2h8.fsf_-_@ebiederm.dsl.xmission.com>
	<m1y7mpunuk.fsf_-_@ebiederm.dsl.xmission.com>
	<m1tzxdunsg.fsf_-_@ebiederm.dsl.xmission.com>
	<m1ps81uno3.fsf_-_@ebiederm.dsl.xmission.com>
	<m1lkipunl0.fsf_-_@ebiederm.dsl.xmission.com>
	<m1ejohung7.fsf_-_@ebiederm.dsl.xmission.com>
	<m17iu9unb6.fsf_-_@ebiederm.dsl.xmission.com>
	<m13b4xun1c.fsf_-_@ebiederm.dsl.xmission.com>
Date: Fri, 23 Feb 2007 04:35:05 -0700
In-Reply-To: <m13b4xun1c.fsf_-_@ebiederm.dsl.xmission.com> (Eric
	W. Biederman's message of "Fri, 23 Feb 2007 04:32:47 -0700")
Message-ID: <m1y7mpt8d2.fsf_-_@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Currently assign_irq_vector works mostly by side effect and returns
the results of it's changes to the caller.  Which makes for a lot of
arguments to pass/return and confusion as to what to do if you need
the status but you aren't calling assign_irq_vector.

This patch stops returning values from assign_irq_vector that can be
retrieved just as easily by examining irq_cfg, and modifies the
callers to retrive those values from irq_cfg when they need them.

Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
---
 arch/x86_64/kernel/io_apic.c |  109 +++++++++++++++++++++--------------------
 1 files changed, 56 insertions(+), 53 deletions(-)

diff --git a/arch/x86_64/kernel/io_apic.c b/arch/x86_64/kernel/io_apic.c
index dd6580c..79fa7b2 100644
--- a/arch/x86_64/kernel/io_apic.c
+++ b/arch/x86_64/kernel/io_apic.c
@@ -72,7 +72,7 @@ struct irq_cfg irq_cfg[NR_IRQS] __read_mostly = {
 	[15] = { .domain = CPU_MASK_ALL, .vector = FIRST_EXTERNAL_VECTOR + 15 },
 };
 
-static int assign_irq_vector(int irq, cpumask_t mask, cpumask_t *result);
+static int assign_irq_vector(int irq, cpumask_t mask);
 
 #define __apicdebuginit  __init
 
@@ -262,19 +262,19 @@ static void __target_IO_APIC_irq(unsigned int irq, unsigned int dest, u8 vector)
 
 static void set_ioapic_affinity_irq(unsigned int irq, cpumask_t mask)
 {
+	struct irq_cfg *cfg = irq_cfg + irq;
 	unsigned long flags;
 	unsigned int dest;
 	cpumask_t tmp;
-	int vector;
 
 	cpus_and(tmp, mask, cpu_online_map);
 	if (cpus_empty(tmp))
 		return;
 
-	vector = assign_irq_vector(irq, mask, &tmp);
-	if (vector < 0)
+	if (assign_irq_vector(irq, mask))
 		return;
 
+	cpus_and(tmp, cfg->domain, mask);
 	dest = cpu_mask_to_apicid(tmp);
 
 	/*
@@ -283,7 +283,7 @@ static void set_ioapic_affinity_irq(unsigned int irq, cpumask_t mask)
 	dest = SET_APIC_LOGICAL_ID(dest);
 
 	spin_lock_irqsave(&ioapic_lock, flags);
-	__target_IO_APIC_irq(irq, dest, vector);
+	__target_IO_APIC_irq(irq, dest, cfg->vector);
 	irq_desc[irq].affinity = mask;
 	spin_unlock_irqrestore(&ioapic_lock, flags);
 }
@@ -638,7 +638,7 @@ static int pin_2_irq(int idx, int apic, int pin)
 	return irq;
 }
 
-static int __assign_irq_vector(int irq, cpumask_t mask, cpumask_t *result)
+static int __assign_irq_vector(int irq, cpumask_t mask)
 {
 	/*
 	 * NOTE! The local APIC isn't very good at handling
@@ -653,7 +653,7 @@ static int __assign_irq_vector(int irq, cpumask_t mask, cpumask_t *result)
 	 */
 	static int current_vector = FIRST_DEVICE_VECTOR, current_offset = 0;
 	cpumask_t old_mask = CPU_MASK_NONE;
-	int old_vector = -1;
+	unsigned int old_vector;
 	int cpu;
 	struct irq_cfg *cfg;
 
@@ -663,12 +663,12 @@ static int __assign_irq_vector(int irq, cpumask_t mask, cpumask_t *result)
 	/* Only try and allocate irqs on cpus that are present */
 	cpus_and(mask, mask, cpu_online_map);
 
-	if (cfg->vector > 0)
-		old_vector = cfg->vector;
-	if (old_vector > 0) {
-		cpus_and(*result, cfg->domain, mask);
-		if (!cpus_empty(*result))
-			return old_vector;
+	old_vector = cfg->vector;
+	if (old_vector) {
+		cpumask_t tmp;
+		cpus_and(tmp, cfg->domain, mask);
+		if (!cpus_empty(tmp))
+			return 0;
 		cpus_and(old_mask, cfg->domain, cpu_online_map);
 	}
 
@@ -705,21 +705,20 @@ next:
 			per_cpu(vector_irq, new_cpu)[vector] = irq;
 		cfg->vector = vector;
 		cfg->domain = domain;
-		cpus_and(*result, domain, mask);
-		return vector;
+		return 0;
 	}
 	return -ENOSPC;
 }
 
-static int assign_irq_vector(int irq, cpumask_t mask, cpumask_t *result)
+static int assign_irq_vector(int irq, cpumask_t mask)
 {
-	int vector;
+	int err;
 	unsigned long flags;
 
 	spin_lock_irqsave(&vector_lock, flags);
-	vector = __assign_irq_vector(irq, mask, result);
+	err = __assign_irq_vector(irq, mask);
 	spin_unlock_irqrestore(&vector_lock, flags);
-	return vector;
+	return err;
 }
 
 static void __clear_irq_vector(int irq)
@@ -780,22 +779,24 @@ static void ioapic_register_intr(int irq, unsigned long trigger)
 static void setup_IO_APIC_irq(int apic, int pin, unsigned int irq,
 			      int trigger, int polarity)
 {
+	struct irq_cfg *cfg = irq_cfg + irq;
 	struct IO_APIC_route_entry entry;
 	cpumask_t mask;
-	int vector;
 	unsigned long flags;
 
 	if (!IO_APIC_IRQ(irq))
 		return;
 
-	vector = assign_irq_vector(irq, TARGET_CPUS, &mask);
-	if (vector < 0)
+	mask = TARGET_CPUS;
+	if (assign_irq_vector(irq, mask))
 		return;
 
+	cpus_and(mask, cfg->domain, mask);
+
 	apic_printk(APIC_VERBOSE,KERN_DEBUG
 		    "IOAPIC[%d]: Set routing entry (%d-%d -> 0x%x -> "
 		    "IRQ %d Mode:%i Active:%i)\n",
-		    apic, mp_ioapics[apic].mpc_apicid, pin, vector,
+		    apic, mp_ioapics[apic].mpc_apicid, pin, cfg->vector,
 		    irq, trigger, polarity);
 
 	/*
@@ -809,7 +810,7 @@ static void setup_IO_APIC_irq(int apic, int pin, unsigned int irq,
 	entry.mask = 0;				/* enable IRQ */
 	entry.trigger = trigger;
 	entry.polarity = polarity;
-	entry.vector = vector;
+	entry.vector = cfg->vector;
 
 	/* Mask level triggered irqs.
 	 * Use IRQ_DELAYED_DISABLE for edge triggered irqs.
@@ -1558,15 +1559,14 @@ static inline void unlock_ExtINT_logic(void)
  */
 static inline void check_timer(void)
 {
+	struct irq_cfg *cfg = irq_cfg + 0;
 	int apic1, pin1, apic2, pin2;
-	int vector;
-	cpumask_t mask;
 
 	/*
 	 * get/set the timer IRQ vector:
 	 */
 	disable_8259A_irq(0);
-	vector = assign_irq_vector(0, TARGET_CPUS, &mask);
+	assign_irq_vector(0, TARGET_CPUS);
 
 	/*
 	 * Subtle, code in do_timer_interrupt() expects an AEOI
@@ -1586,7 +1586,7 @@ static inline void check_timer(void)
 	apic2 = ioapic_i8259.apic;
 
 	apic_printk(APIC_VERBOSE,KERN_INFO "..TIMER: vector=0x%02X apic1=%d pin1=%d apic2=%d pin2=%d\n",
-		vector, apic1, pin1, apic2, pin2);
+		cfg->vector, apic1, pin1, apic2, pin2);
 
 	if (pin1 != -1) {
 		/*
@@ -1617,7 +1617,7 @@ static inline void check_timer(void)
 		/*
 		 * legacy devices should be connected to IO APIC #0
 		 */
-		setup_ExtINT_IRQ0_pin(apic2, pin2, vector);
+		setup_ExtINT_IRQ0_pin(apic2, pin2, cfg->vector);
 		if (timer_irq_works()) {
 			apic_printk(APIC_VERBOSE," works.\n");
 			nmi_watchdog_default();
@@ -1642,14 +1642,14 @@ static inline void check_timer(void)
 
 	disable_8259A_irq(0);
 	irq_desc[0].chip = &lapic_irq_type;
-	apic_write(APIC_LVT0, APIC_DM_FIXED | vector);	/* Fixed mode */
+	apic_write(APIC_LVT0, APIC_DM_FIXED | cfg->vector);	/* Fixed mode */
 	enable_8259A_irq(0);
 
 	if (timer_irq_works()) {
 		apic_printk(APIC_VERBOSE," works.\n");
 		return;
 	}
-	apic_write(APIC_LVT0, APIC_LVT_MASKED | APIC_DM_FIXED | vector);
+	apic_write(APIC_LVT0, APIC_LVT_MASKED | APIC_DM_FIXED | cfg->vector);
 	apic_printk(APIC_VERBOSE," failed.\n");
 
 	apic_printk(APIC_VERBOSE, KERN_INFO "...trying to set up timer as ExtINT IRQ...");
@@ -1796,9 +1796,7 @@ int create_irq(void)
 	/* Allocate an unused irq */
 	int irq;
 	int new;
-	int vector = 0;
 	unsigned long flags;
-	cpumask_t mask;
 
 	irq = -ENOSPC;
 	spin_lock_irqsave(&vector_lock, flags);
@@ -1807,8 +1805,7 @@ int create_irq(void)
 			continue;
 		if (irq_cfg[new].vector != 0)
 			continue;
-		vector = __assign_irq_vector(new, TARGET_CPUS, &mask);
-		if (likely(vector > 0))
+		if (__assign_irq_vector(new, TARGET_CPUS) == 0)
 			irq = new;
 		break;
 	}
@@ -1837,12 +1834,15 @@ void destroy_irq(unsigned int irq)
 #ifdef CONFIG_PCI_MSI
 static int msi_compose_msg(struct pci_dev *pdev, unsigned int irq, struct msi_msg *msg)
 {
-	int vector;
+	struct irq_cfg *cfg = irq_cfg + irq;
+	int err;
 	unsigned dest;
 	cpumask_t tmp;
 
-	vector = assign_irq_vector(irq, TARGET_CPUS, &tmp);
-	if (vector >= 0) {
+	tmp = TARGET_CPUS;
+	err = assign_irq_vector(irq, tmp);
+	if (!err) {
+		cpus_and(tmp, cfg->domain, tmp);
 		dest = cpu_mask_to_apicid(tmp);
 
 		msg->address_hi = MSI_ADDR_BASE_HI;
@@ -1862,33 +1862,33 @@ static int msi_compose_msg(struct pci_dev *pdev, unsigned int irq, struct msi_ms
 			((INT_DELIVERY_MODE != dest_LowestPrio) ?
 				MSI_DATA_DELIVERY_FIXED:
 				MSI_DATA_DELIVERY_LOWPRI) |
-			MSI_DATA_VECTOR(vector);
+			MSI_DATA_VECTOR(cfg->vector);
 	}
-	return vector;
+	return err;
 }
 
 #ifdef CONFIG_SMP
 static void set_msi_irq_affinity(unsigned int irq, cpumask_t mask)
 {
+	struct irq_cfg *cfg = irq_cfg + irq;
 	struct msi_msg msg;
 	unsigned int dest;
 	cpumask_t tmp;
-	int vector;
 
 	cpus_and(tmp, mask, cpu_online_map);
 	if (cpus_empty(tmp))
 		return;
 
-	vector = assign_irq_vector(irq, mask, &tmp);
-	if (vector < 0)
+	if (assign_irq_vector(irq, mask))
 		return;
 
+	cpus_and(tmp, cfg->domain, mask);
 	dest = cpu_mask_to_apicid(tmp);
 
 	read_msi_msg(irq, &msg);
 
 	msg.data &= ~MSI_DATA_VECTOR_MASK;
-	msg.data |= MSI_DATA_VECTOR(vector);
+	msg.data |= MSI_DATA_VECTOR(cfg->vector);
 	msg.address_lo &= ~MSI_ADDR_DEST_ID_MASK;
 	msg.address_lo |= MSI_ADDR_DEST_ID(dest);
 
@@ -1964,21 +1964,21 @@ static void target_ht_irq(unsigned int irq, unsigned int dest, u8 vector)
 
 static void set_ht_irq_affinity(unsigned int irq, cpumask_t mask)
 {
+	struct irq_cfg *cfg = irq_cfg + irq;
 	unsigned int dest;
 	cpumask_t tmp;
-	int vector;
 
 	cpus_and(tmp, mask, cpu_online_map);
 	if (cpus_empty(tmp))
 		return;
 
-	vector = assign_irq_vector(irq, mask, &tmp);
-	if (vector < 0)
+	if (assign_irq_vector(irq, mask))
 		return;
 
+	cpus_and(tmp, cfg->domain, mask);
 	dest = cpu_mask_to_apicid(tmp);
 
-	target_ht_irq(irq, dest, vector);
+	target_ht_irq(irq, dest, cfg->vector);
 	irq_desc[irq].affinity = mask;
 }
 #endif
@@ -1996,14 +1996,17 @@ static struct irq_chip ht_irq_chip = {
 
 int arch_setup_ht_irq(unsigned int irq, struct pci_dev *dev)
 {
-	int vector;
+	struct irq_cfg *cfg = irq_cfg + irq;
+	int err;
 	cpumask_t tmp;
 
-	vector = assign_irq_vector(irq, TARGET_CPUS, &tmp);
-	if (vector >= 0) {
+	tmp = TARGET_CPUS;
+	err = assign_irq_vector(irq, tmp);
+	if (!err) {
 		struct ht_irq_msg msg;
 		unsigned dest;
 
+		cpus_and(tmp, cfg->domain, tmp);
 		dest = cpu_mask_to_apicid(tmp);
 
 		msg.address_hi = HT_IRQ_HIGH_DEST_ID(dest);
@@ -2011,7 +2014,7 @@ int arch_setup_ht_irq(unsigned int irq, struct pci_dev *dev)
 		msg.address_lo =
 			HT_IRQ_LOW_BASE |
 			HT_IRQ_LOW_DEST_ID(dest) |
-			HT_IRQ_LOW_VECTOR(vector) |
+			HT_IRQ_LOW_VECTOR(cfg->vector) |
 			((INT_DEST_MODE == 0) ?
 				HT_IRQ_LOW_DM_PHYSICAL :
 				HT_IRQ_LOW_DM_LOGICAL) |
@@ -2026,7 +2029,7 @@ int arch_setup_ht_irq(unsigned int irq, struct pci_dev *dev)
 		set_irq_chip_and_handler_name(irq, &ht_irq_chip,
 					      handle_edge_irq, "edge");
 	}
-	return vector;
+	return err;
 }
 #endif /* CONFIG_HT_IRQ */
 
-- 
1.5.0.g53756

