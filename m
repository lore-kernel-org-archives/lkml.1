Return-Path: <linux-kernel-owner+w=401wt.eu-S1754508Ab0AKVcq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754508Ab0AKVcq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jan 2010 16:32:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751810Ab0AKV1S
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Jan 2010 16:27:18 -0500
Received: from mail-ew0-f209.google.com ([209.85.219.209]:50852 "EHLO
	mail-ew0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751566Ab0AKV1Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jan 2010 16:27:16 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer:in-reply-to
         :references;
        b=pZmwF3qlaVzatlb71AoP1gLCpFHmp71GiEccmSAapviwgZg9VSTYUi8l8qbY5AsUD1
         vW4Shv1SRcA4bHB9eCtjm5wBULbvYcfOZtE1z4dJlhQHd8SJfKKubjeXuOm5h+O0zjOO
         L45+94qCqxWwn3asLbe45cHn+HFPbp0ZTf96Y=
From: John Kacur <jkacur@redhat.com>
To: Thomas Gleixner <tglx@linutronix.de>, lkml <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>
Cc: Clark Williams <williams@redhat.com>, John Kacur <jkacur@redhat.com>
Subject: [PATCH 05/26] x86: Convert ioapic_lock and vector_lock to raw_spinlocks
Date: Mon, 11 Jan 2010 22:26:35 +0100
Message-Id: <1263245216-14754-6-git-send-email-jkacur@redhat.com>
X-Mailer: git-send-email 1.6.5.2
In-Reply-To: <1263245216-14754-5-git-send-email-jkacur@redhat.com>
References: <1263245216-14754-1-git-send-email-jkacur@redhat.com>
 <1263245216-14754-2-git-send-email-jkacur@redhat.com>
 <1263245216-14754-3-git-send-email-jkacur@redhat.com>
 <1263245216-14754-4-git-send-email-jkacur@redhat.com>
 <1263245216-14754-5-git-send-email-jkacur@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Convert locks which cannot sleep in preempt-rt to raw_spinlocks.

See also: f32843e644be4d636101117c377a59e0646796e4

Signed-off-by: John Kacur <jkacur@redhat.com>
---
 arch/x86/kernel/apic/io_apic.c |  102 ++++++++++++++++++++--------------------
 1 files changed, 51 insertions(+), 51 deletions(-)

diff --git a/arch/x86/kernel/apic/io_apic.c b/arch/x86/kernel/apic/io_apic.c
index de00c46..7719fa0 100644
--- a/arch/x86/kernel/apic/io_apic.c
+++ b/arch/x86/kernel/apic/io_apic.c
@@ -73,8 +73,8 @@
  */
 int sis_apic_bug = -1;
 
-static DEFINE_SPINLOCK(ioapic_lock);
-static DEFINE_SPINLOCK(vector_lock);
+static DEFINE_RAW_SPINLOCK(ioapic_lock);
+static DEFINE_RAW_SPINLOCK(vector_lock);
 
 /*
  * # of IRQ routing registers
@@ -406,7 +406,7 @@ static bool io_apic_level_ack_pending(struct irq_cfg *cfg)
 	struct irq_pin_list *entry;
 	unsigned long flags;
 
-	spin_lock_irqsave(&ioapic_lock, flags);
+	raw_spin_lock_irqsave(&ioapic_lock, flags);
 	for_each_irq_pin(entry, cfg->irq_2_pin) {
 		unsigned int reg;
 		int pin;
@@ -415,11 +415,11 @@ static bool io_apic_level_ack_pending(struct irq_cfg *cfg)
 		reg = io_apic_read(entry->apic, 0x10 + pin*2);
 		/* Is the remote IRR bit set? */
 		if (reg & IO_APIC_REDIR_REMOTE_IRR) {
-			spin_unlock_irqrestore(&ioapic_lock, flags);
+			raw_spin_unlock_irqrestore(&ioapic_lock, flags);
 			return true;
 		}
 	}
-	spin_unlock_irqrestore(&ioapic_lock, flags);
+	raw_spin_unlock_irqrestore(&ioapic_lock, flags);
 
 	return false;
 }
@@ -433,10 +433,10 @@ static struct IO_APIC_route_entry ioapic_read_entry(int apic, int pin)
 {
 	union entry_union eu;
 	unsigned long flags;
-	spin_lock_irqsave(&ioapic_lock, flags);
+	raw_spin_lock_irqsave(&ioapic_lock, flags);
 	eu.w1 = io_apic_read(apic, 0x10 + 2 * pin);
 	eu.w2 = io_apic_read(apic, 0x11 + 2 * pin);
-	spin_unlock_irqrestore(&ioapic_lock, flags);
+	raw_spin_unlock_irqrestore(&ioapic_lock, flags);
 	return eu.entry;
 }
 
@@ -459,9 +459,9 @@ __ioapic_write_entry(int apic, int pin, struct IO_APIC_route_entry e)
 void ioapic_write_entry(int apic, int pin, struct IO_APIC_route_entry e)
 {
 	unsigned long flags;
-	spin_lock_irqsave(&ioapic_lock, flags);
+	raw_spin_lock_irqsave(&ioapic_lock, flags);
 	__ioapic_write_entry(apic, pin, e);
-	spin_unlock_irqrestore(&ioapic_lock, flags);
+	raw_spin_unlock_irqrestore(&ioapic_lock, flags);
 }
 
 /*
@@ -474,10 +474,10 @@ static void ioapic_mask_entry(int apic, int pin)
 	unsigned long flags;
 	union entry_union eu = { .entry.mask = 1 };
 
-	spin_lock_irqsave(&ioapic_lock, flags);
+	raw_spin_lock_irqsave(&ioapic_lock, flags);
 	io_apic_write(apic, 0x10 + 2*pin, eu.w1);
 	io_apic_write(apic, 0x11 + 2*pin, eu.w2);
-	spin_unlock_irqrestore(&ioapic_lock, flags);
+	raw_spin_unlock_irqrestore(&ioapic_lock, flags);
 }
 
 /*
@@ -604,9 +604,9 @@ static void mask_IO_APIC_irq_desc(struct irq_desc *desc)
 
 	BUG_ON(!cfg);
 
-	spin_lock_irqsave(&ioapic_lock, flags);
+	raw_spin_lock_irqsave(&ioapic_lock, flags);
 	__mask_IO_APIC_irq(cfg);
-	spin_unlock_irqrestore(&ioapic_lock, flags);
+	raw_spin_unlock_irqrestore(&ioapic_lock, flags);
 }
 
 static void unmask_IO_APIC_irq_desc(struct irq_desc *desc)
@@ -614,9 +614,9 @@ static void unmask_IO_APIC_irq_desc(struct irq_desc *desc)
 	struct irq_cfg *cfg = desc->chip_data;
 	unsigned long flags;
 
-	spin_lock_irqsave(&ioapic_lock, flags);
+	raw_spin_lock_irqsave(&ioapic_lock, flags);
 	__unmask_IO_APIC_irq(cfg);
-	spin_unlock_irqrestore(&ioapic_lock, flags);
+	raw_spin_unlock_irqrestore(&ioapic_lock, flags);
 }
 
 static void mask_IO_APIC_irq(unsigned int irq)
@@ -1140,12 +1140,12 @@ void lock_vector_lock(void)
 	/* Used to the online set of cpus does not change
 	 * during assign_irq_vector.
 	 */
-	spin_lock(&vector_lock);
+	raw_spin_lock(&vector_lock);
 }
 
 void unlock_vector_lock(void)
 {
-	spin_unlock(&vector_lock);
+	raw_spin_unlock(&vector_lock);
 }
 
 static int
@@ -1232,9 +1232,9 @@ int assign_irq_vector(int irq, struct irq_cfg *cfg, const struct cpumask *mask)
 	int err;
 	unsigned long flags;
 
-	spin_lock_irqsave(&vector_lock, flags);
+	raw_spin_lock_irqsave(&vector_lock, flags);
 	err = __assign_irq_vector(irq, cfg, mask);
-	spin_unlock_irqrestore(&vector_lock, flags);
+	raw_spin_unlock_irqrestore(&vector_lock, flags);
 	return err;
 }
 
@@ -1601,14 +1601,14 @@ __apicdebuginit(void) print_IO_APIC(void)
 
 	for (apic = 0; apic < nr_ioapics; apic++) {
 
-	spin_lock_irqsave(&ioapic_lock, flags);
+	raw_spin_lock_irqsave(&ioapic_lock, flags);
 	reg_00.raw = io_apic_read(apic, 0);
 	reg_01.raw = io_apic_read(apic, 1);
 	if (reg_01.bits.version >= 0x10)
 		reg_02.raw = io_apic_read(apic, 2);
 	if (reg_01.bits.version >= 0x20)
 		reg_03.raw = io_apic_read(apic, 3);
-	spin_unlock_irqrestore(&ioapic_lock, flags);
+	raw_spin_unlock_irqrestore(&ioapic_lock, flags);
 
 	printk("\n");
 	printk(KERN_DEBUG "IO APIC #%d......\n", mp_ioapics[apic].apicid);
@@ -1903,9 +1903,9 @@ void __init enable_IO_APIC(void)
 	 * The number of IO-APIC IRQ registers (== #pins):
 	 */
 	for (apic = 0; apic < nr_ioapics; apic++) {
-		spin_lock_irqsave(&ioapic_lock, flags);
+		raw_spin_lock_irqsave(&ioapic_lock, flags);
 		reg_01.raw = io_apic_read(apic, 1);
-		spin_unlock_irqrestore(&ioapic_lock, flags);
+		raw_spin_unlock_irqrestore(&ioapic_lock, flags);
 		nr_ioapic_registers[apic] = reg_01.bits.entries+1;
 	}
 
@@ -2045,9 +2045,9 @@ void __init setup_ioapic_ids_from_mpc(void)
 	for (apic_id = 0; apic_id < nr_ioapics; apic_id++) {
 
 		/* Read the register 0 value */
-		spin_lock_irqsave(&ioapic_lock, flags);
+		raw_spin_lock_irqsave(&ioapic_lock, flags);
 		reg_00.raw = io_apic_read(apic_id, 0);
-		spin_unlock_irqrestore(&ioapic_lock, flags);
+		raw_spin_unlock_irqrestore(&ioapic_lock, flags);
 
 		old_id = mp_ioapics[apic_id].apicid;
 
@@ -2106,16 +2106,16 @@ void __init setup_ioapic_ids_from_mpc(void)
 			mp_ioapics[apic_id].apicid);
 
 		reg_00.bits.ID = mp_ioapics[apic_id].apicid;
-		spin_lock_irqsave(&ioapic_lock, flags);
+		raw_spin_lock_irqsave(&ioapic_lock, flags);
 		io_apic_write(apic_id, 0, reg_00.raw);
-		spin_unlock_irqrestore(&ioapic_lock, flags);
+		raw_spin_unlock_irqrestore(&ioapic_lock, flags);
 
 		/*
 		 * Sanity check
 		 */
-		spin_lock_irqsave(&ioapic_lock, flags);
+		raw_spin_lock_irqsave(&ioapic_lock, flags);
 		reg_00.raw = io_apic_read(apic_id, 0);
-		spin_unlock_irqrestore(&ioapic_lock, flags);
+		raw_spin_unlock_irqrestore(&ioapic_lock, flags);
 		if (reg_00.bits.ID != mp_ioapics[apic_id].apicid)
 			printk("could not set ID!\n");
 		else
@@ -2198,7 +2198,7 @@ static unsigned int startup_ioapic_irq(unsigned int irq)
 	unsigned long flags;
 	struct irq_cfg *cfg;
 
-	spin_lock_irqsave(&ioapic_lock, flags);
+	raw_spin_lock_irqsave(&ioapic_lock, flags);
 	if (irq < nr_legacy_irqs) {
 		disable_8259A_irq(irq);
 		if (i8259A_irq_pending(irq))
@@ -2206,7 +2206,7 @@ static unsigned int startup_ioapic_irq(unsigned int irq)
 	}
 	cfg = irq_cfg(irq);
 	__unmask_IO_APIC_irq(cfg);
-	spin_unlock_irqrestore(&ioapic_lock, flags);
+	raw_spin_unlock_irqrestore(&ioapic_lock, flags);
 
 	return was_pending;
 }
@@ -2217,9 +2217,9 @@ static int ioapic_retrigger_irq(unsigned int irq)
 	struct irq_cfg *cfg = irq_cfg(irq);
 	unsigned long flags;
 
-	spin_lock_irqsave(&vector_lock, flags);
+	raw_spin_lock_irqsave(&vector_lock, flags);
 	apic->send_IPI_mask(cpumask_of(cpumask_first(cfg->domain)), cfg->vector);
-	spin_unlock_irqrestore(&vector_lock, flags);
+	raw_spin_unlock_irqrestore(&vector_lock, flags);
 
 	return 1;
 }
@@ -2312,14 +2312,14 @@ set_ioapic_affinity_irq_desc(struct irq_desc *desc, const struct cpumask *mask)
 	irq = desc->irq;
 	cfg = desc->chip_data;
 
-	spin_lock_irqsave(&ioapic_lock, flags);
+	raw_spin_lock_irqsave(&ioapic_lock, flags);
 	ret = set_desc_affinity(desc, mask, &dest);
 	if (!ret) {
 		/* Only the high 8 bits are valid. */
 		dest = SET_APIC_LOGICAL_ID(dest);
 		__target_IO_APIC_irq(irq, dest, cfg);
 	}
-	spin_unlock_irqrestore(&ioapic_lock, flags);
+	raw_spin_unlock_irqrestore(&ioapic_lock, flags);
 
 	return ret;
 }
@@ -2547,9 +2547,9 @@ static void eoi_ioapic_irq(struct irq_desc *desc)
 	irq = desc->irq;
 	cfg = desc->chip_data;
 
-	spin_lock_irqsave(&ioapic_lock, flags);
+	raw_spin_lock_irqsave(&ioapic_lock, flags);
 	__eoi_ioapic_irq(irq, cfg);
-	spin_unlock_irqrestore(&ioapic_lock, flags);
+	raw_spin_unlock_irqrestore(&ioapic_lock, flags);
 }
 
 static void ack_apic_level(unsigned int irq)
@@ -3131,13 +3131,13 @@ static int ioapic_resume(struct sys_device *dev)
 	data = container_of(dev, struct sysfs_ioapic_data, dev);
 	entry = data->entry;
 
-	spin_lock_irqsave(&ioapic_lock, flags);
+	raw_spin_lock_irqsave(&ioapic_lock, flags);
 	reg_00.raw = io_apic_read(dev->id, 0);
 	if (reg_00.bits.ID != mp_ioapics[dev->id].apicid) {
 		reg_00.bits.ID = mp_ioapics[dev->id].apicid;
 		io_apic_write(dev->id, 0, reg_00.raw);
 	}
-	spin_unlock_irqrestore(&ioapic_lock, flags);
+	raw_spin_unlock_irqrestore(&ioapic_lock, flags);
 	for (i = 0; i < nr_ioapic_registers[dev->id]; i++)
 		ioapic_write_entry(dev->id, i, entry[i]);
 
@@ -3200,7 +3200,7 @@ unsigned int create_irq_nr(unsigned int irq_want, int node)
 	if (irq_want < nr_irqs_gsi)
 		irq_want = nr_irqs_gsi;
 
-	spin_lock_irqsave(&vector_lock, flags);
+	raw_spin_lock_irqsave(&vector_lock, flags);
 	for (new = irq_want; new < nr_irqs; new++) {
 		desc_new = irq_to_desc_alloc_node(new, node);
 		if (!desc_new) {
@@ -3219,7 +3219,7 @@ unsigned int create_irq_nr(unsigned int irq_want, int node)
 			irq = new;
 		break;
 	}
-	spin_unlock_irqrestore(&vector_lock, flags);
+	raw_spin_unlock_irqrestore(&vector_lock, flags);
 
 	if (irq > 0) {
 		dynamic_irq_init(irq);
@@ -3259,9 +3259,9 @@ void destroy_irq(unsigned int irq)
 	desc->chip_data = cfg;
 
 	free_irte(irq);
-	spin_lock_irqsave(&vector_lock, flags);
+	raw_spin_lock_irqsave(&vector_lock, flags);
 	__clear_irq_vector(irq, cfg);
-	spin_unlock_irqrestore(&vector_lock, flags);
+	raw_spin_unlock_irqrestore(&vector_lock, flags);
 }
 
 /*
@@ -3798,9 +3798,9 @@ int __init io_apic_get_redir_entries (int ioapic)
 	union IO_APIC_reg_01	reg_01;
 	unsigned long flags;
 
-	spin_lock_irqsave(&ioapic_lock, flags);
+	raw_spin_lock_irqsave(&ioapic_lock, flags);
 	reg_01.raw = io_apic_read(ioapic, 1);
-	spin_unlock_irqrestore(&ioapic_lock, flags);
+	raw_spin_unlock_irqrestore(&ioapic_lock, flags);
 
 	return reg_01.bits.entries;
 }
@@ -3962,9 +3962,9 @@ int __init io_apic_get_unique_id(int ioapic, int apic_id)
 	if (physids_empty(apic_id_map))
 		apic->ioapic_phys_id_map(&phys_cpu_present_map, &apic_id_map);
 
-	spin_lock_irqsave(&ioapic_lock, flags);
+	raw_spin_lock_irqsave(&ioapic_lock, flags);
 	reg_00.raw = io_apic_read(ioapic, 0);
-	spin_unlock_irqrestore(&ioapic_lock, flags);
+	raw_spin_unlock_irqrestore(&ioapic_lock, flags);
 
 	if (apic_id >= get_physical_broadcast()) {
 		printk(KERN_WARNING "IOAPIC[%d]: Invalid apic_id %d, trying "
@@ -3998,10 +3998,10 @@ int __init io_apic_get_unique_id(int ioapic, int apic_id)
 	if (reg_00.bits.ID != apic_id) {
 		reg_00.bits.ID = apic_id;
 
-		spin_lock_irqsave(&ioapic_lock, flags);
+		raw_spin_lock_irqsave(&ioapic_lock, flags);
 		io_apic_write(ioapic, 0, reg_00.raw);
 		reg_00.raw = io_apic_read(ioapic, 0);
-		spin_unlock_irqrestore(&ioapic_lock, flags);
+		raw_spin_unlock_irqrestore(&ioapic_lock, flags);
 
 		/* Sanity check */
 		if (reg_00.bits.ID != apic_id) {
@@ -4022,9 +4022,9 @@ int __init io_apic_get_version(int ioapic)
 	union IO_APIC_reg_01	reg_01;
 	unsigned long flags;
 
-	spin_lock_irqsave(&ioapic_lock, flags);
+	raw_spin_lock_irqsave(&ioapic_lock, flags);
 	reg_01.raw = io_apic_read(ioapic, 1);
-	spin_unlock_irqrestore(&ioapic_lock, flags);
+	raw_spin_unlock_irqrestore(&ioapic_lock, flags);
 
 	return reg_01.bits.version;
 }
-- 
1.6.5.2

