Return-Path: <linux-kernel-owner+w=401wt.eu-S1764388AbZDHVHz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764388AbZDHVHz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Apr 2009 17:07:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761443AbZDHVHh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Apr 2009 17:07:37 -0400
Received: from e32.co.us.ibm.com ([32.97.110.150]:42870 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764855AbZDHVHf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Apr 2009 17:07:35 -0400
Date: Wed, 8 Apr 2009 14:07:25 -0700
From: Gary Hade <garyhade@us.ibm.com>
To: mingo@elte.hu, mingo@redhat.com, tglx@linutronix.de, hpa@zytor.com,
       x86@kernel.org
Cc: linux-kernel@vger.kernel.org, garyhade@us.ibm.com, lcm@us.ibm.com
Subject: [PATCH 1/3] x86/x86_64: consolidate SMP code in io_apic.c
Message-ID: <20090408210725.GC11159@us.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: Cleanup

Reorganizes the code in arch/x86/kernel/io_apic.c by
combining two '#ifdef CONFIG_SMP' regions.  In addition
to making the code easier to understand the first
'#ifdef CONFIG_SMP' region is moved to a location later
in the file which will reduce the need for function
forward declarations when the code subsequently revised.

The only changes other than relocating code to a different
position in the file were the removal of the assign_irq_vector()
forward declaration which was no longer needed and some line
length reduction formatting changes.

Signed-off-by: Gary Hade <garyhade@us.ibm.com>

---
 arch/x86/kernel/apic/io_apic.c |  224 +++++++++++++++----------------
 1 file changed, 110 insertions(+), 114 deletions(-)

Index: linux-2.6.30-rc1/arch/x86/kernel/apic/io_apic.c
===================================================================
--- linux-2.6.30-rc1.orig/arch/x86/kernel/apic/io_apic.c	2009-04-08 09:21:50.000000000 -0700
+++ linux-2.6.30-rc1/arch/x86/kernel/apic/io_apic.c	2009-04-08 09:22:00.000000000 -0700
@@ -518,120 +518,6 @@ static void ioapic_mask_entry(int apic, 
 	spin_unlock_irqrestore(&ioapic_lock, flags);
 }
 
-#ifdef CONFIG_SMP
-static void send_cleanup_vector(struct irq_cfg *cfg)
-{
-	cpumask_var_t cleanup_mask;
-
-	if (unlikely(!alloc_cpumask_var(&cleanup_mask, GFP_ATOMIC))) {
-		unsigned int i;
-		cfg->move_cleanup_count = 0;
-		for_each_cpu_and(i, cfg->old_domain, cpu_online_mask)
-			cfg->move_cleanup_count++;
-		for_each_cpu_and(i, cfg->old_domain, cpu_online_mask)
-			apic->send_IPI_mask(cpumask_of(i), IRQ_MOVE_CLEANUP_VECTOR);
-	} else {
-		cpumask_and(cleanup_mask, cfg->old_domain, cpu_online_mask);
-		cfg->move_cleanup_count = cpumask_weight(cleanup_mask);
-		apic->send_IPI_mask(cleanup_mask, IRQ_MOVE_CLEANUP_VECTOR);
-		free_cpumask_var(cleanup_mask);
-	}
-	cfg->move_in_progress = 0;
-}
-
-static void __target_IO_APIC_irq(unsigned int irq, unsigned int dest, struct irq_cfg *cfg)
-{
-	int apic, pin;
-	struct irq_pin_list *entry;
-	u8 vector = cfg->vector;
-
-	entry = cfg->irq_2_pin;
-	for (;;) {
-		unsigned int reg;
-
-		if (!entry)
-			break;
-
-		apic = entry->apic;
-		pin = entry->pin;
-		/*
-		 * With interrupt-remapping, destination information comes
-		 * from interrupt-remapping table entry.
-		 */
-		if (!irq_remapped(irq))
-			io_apic_write(apic, 0x11 + pin*2, dest);
-		reg = io_apic_read(apic, 0x10 + pin*2);
-		reg &= ~IO_APIC_REDIR_VECTOR_MASK;
-		reg |= vector;
-		io_apic_modify(apic, 0x10 + pin*2, reg);
-		if (!entry->next)
-			break;
-		entry = entry->next;
-	}
-}
-
-static int
-assign_irq_vector(int irq, struct irq_cfg *cfg, const struct cpumask *mask);
-
-/*
- * Either sets desc->affinity to a valid value, and returns
- * ->cpu_mask_to_apicid of that, or returns BAD_APICID and
- * leaves desc->affinity untouched.
- */
-static unsigned int
-set_desc_affinity(struct irq_desc *desc, const struct cpumask *mask)
-{
-	struct irq_cfg *cfg;
-	unsigned int irq;
-
-	if (!cpumask_intersects(mask, cpu_online_mask))
-		return BAD_APICID;
-
-	irq = desc->irq;
-	cfg = desc->chip_data;
-	if (assign_irq_vector(irq, cfg, mask))
-		return BAD_APICID;
-
-	/* check that before desc->addinity get updated */
-	set_extra_move_desc(desc, mask);
-
-	cpumask_copy(desc->affinity, mask);
-
-	return apic->cpu_mask_to_apicid_and(desc->affinity, cfg->domain);
-}
-
-static void
-set_ioapic_affinity_irq_desc(struct irq_desc *desc, const struct cpumask *mask)
-{
-	struct irq_cfg *cfg;
-	unsigned long flags;
-	unsigned int dest;
-	unsigned int irq;
-
-	irq = desc->irq;
-	cfg = desc->chip_data;
-
-	spin_lock_irqsave(&ioapic_lock, flags);
-	dest = set_desc_affinity(desc, mask);
-	if (dest != BAD_APICID) {
-		/* Only the high 8 bits are valid. */
-		dest = SET_APIC_LOGICAL_ID(dest);
-		__target_IO_APIC_irq(irq, dest, cfg);
-	}
-	spin_unlock_irqrestore(&ioapic_lock, flags);
-}
-
-static void
-set_ioapic_affinity_irq(unsigned int irq, const struct cpumask *mask)
-{
-	struct irq_desc *desc;
-
-	desc = irq_to_desc(irq);
-
-	set_ioapic_affinity_irq_desc(desc, mask);
-}
-#endif /* CONFIG_SMP */
-
 /*
  * The common case is 1:1 IRQ<->pin mappings. Sometimes there are
  * shared ISA-space IRQs, so we have to support them. We are super
@@ -2360,6 +2246,116 @@ static int ioapic_retrigger_irq(unsigned
  */
 
 #ifdef CONFIG_SMP
+static void send_cleanup_vector(struct irq_cfg *cfg)
+{
+	cpumask_var_t cleanup_mask;
+
+	if (unlikely(!alloc_cpumask_var(&cleanup_mask, GFP_ATOMIC))) {
+		unsigned int i;
+		cfg->move_cleanup_count = 0;
+		for_each_cpu_and(i, cfg->old_domain, cpu_online_mask)
+			cfg->move_cleanup_count++;
+		for_each_cpu_and(i, cfg->old_domain, cpu_online_mask)
+			apic->send_IPI_mask(cpumask_of(i),
+					    IRQ_MOVE_CLEANUP_VECTOR);
+	} else {
+		cpumask_and(cleanup_mask, cfg->old_domain, cpu_online_mask);
+		cfg->move_cleanup_count = cpumask_weight(cleanup_mask);
+		apic->send_IPI_mask(cleanup_mask, IRQ_MOVE_CLEANUP_VECTOR);
+		free_cpumask_var(cleanup_mask);
+	}
+	cfg->move_in_progress = 0;
+}
+
+static void __target_IO_APIC_irq(unsigned int irq, unsigned int dest,
+				 struct irq_cfg *cfg)
+{
+	int apic, pin;
+	struct irq_pin_list *entry;
+	u8 vector = cfg->vector;
+
+	entry = cfg->irq_2_pin;
+	for (;;) {
+		unsigned int reg;
+
+		if (!entry)
+			break;
+
+		apic = entry->apic;
+		pin = entry->pin;
+		/*
+		 * With interrupt-remapping, destination information comes
+		 * from interrupt-remapping table entry.
+		 */
+		if (!irq_remapped(irq))
+			io_apic_write(apic, 0x11 + pin*2, dest);
+		reg = io_apic_read(apic, 0x10 + pin*2);
+		reg &= ~IO_APIC_REDIR_VECTOR_MASK;
+		reg |= vector;
+		io_apic_modify(apic, 0x10 + pin*2, reg);
+		if (!entry->next)
+			break;
+		entry = entry->next;
+	}
+}
+
+/*
+ * Either sets desc->affinity to a valid value, and returns
+ * ->cpu_mask_to_apicid of that, or returns BAD_APICID and
+ * leaves desc->affinity untouched.
+ */
+static unsigned int
+set_desc_affinity(struct irq_desc *desc, const struct cpumask *mask)
+{
+	struct irq_cfg *cfg;
+	unsigned int irq;
+
+	if (!cpumask_intersects(mask, cpu_online_mask))
+		return BAD_APICID;
+
+	irq = desc->irq;
+	cfg = desc->chip_data;
+	if (assign_irq_vector(irq, cfg, mask))
+		return BAD_APICID;
+
+	/* check that before desc->addinity get updated */
+	set_extra_move_desc(desc, mask);
+
+	cpumask_copy(desc->affinity, mask);
+
+	return apic->cpu_mask_to_apicid_and(desc->affinity, cfg->domain);
+}
+
+static void
+set_ioapic_affinity_irq_desc(struct irq_desc *desc, const struct cpumask *mask)
+{
+	struct irq_cfg *cfg;
+	unsigned long flags;
+	unsigned int dest;
+	unsigned int irq;
+
+	irq = desc->irq;
+	cfg = desc->chip_data;
+
+	spin_lock_irqsave(&ioapic_lock, flags);
+	dest = set_desc_affinity(desc, mask);
+	if (dest != BAD_APICID) {
+		/* Only the high 8 bits are valid. */
+		dest = SET_APIC_LOGICAL_ID(dest);
+		__target_IO_APIC_irq(irq, dest, cfg);
+	}
+	spin_unlock_irqrestore(&ioapic_lock, flags);
+}
+
+static void
+set_ioapic_affinity_irq(unsigned int irq, const struct cpumask *mask)
+{
+	struct irq_desc *desc;
+
+	desc = irq_to_desc(irq);
+
+	set_ioapic_affinity_irq_desc(desc, mask);
+}
 
 #ifdef CONFIG_INTR_REMAP
 
