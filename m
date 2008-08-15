Return-Path: <linux-kernel-owner+w=401wt.eu-S1757323AbYHOCXB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757323AbYHOCXB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Aug 2008 22:23:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755367AbYHOCVc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Aug 2008 22:21:32 -0400
Received: from yw-out-2324.google.com ([74.125.46.31]:29630 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754051AbYHOCVb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Aug 2008 22:21:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=SMiPeOeE2qrFSEsPu8extru81apaGun3DbxDjZL+TH826PziRqsveaLufZWuTqnVt4
         2dJ7ApyKL23ugVu1pX/rCu1BJuxoALudjP1EtMiB5ZInvSULksGm+9YyHhzb0QBjVbPH
         I3sNwtZ99iFO4ZqCbk2uoVIO+UuCtRS4cLM88=
From: Yinghai Lu <yhlu.kernel@gmail.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Yinghai Lu <yhlu.kernel@gmail.com>
Subject: [PATCH 5/7] x86: make 32bit support per_cpu vector fix #2
Date: Thu, 14 Aug 2008 19:20:30 -0700
Message-Id: <1218766832-20476-6-git-send-email-yhlu.kernel@gmail.com>
X-Mailer: git-send-email 1.5.4.5
In-Reply-To: <1218766832-20476-5-git-send-email-yhlu.kernel@gmail.com>
References: <no>
 <1218766832-20476-1-git-send-email-yhlu.kernel@gmail.com>
 <1218766832-20476-2-git-send-email-yhlu.kernel@gmail.com>
 <1218766832-20476-3-git-send-email-yhlu.kernel@gmail.com>
 <1218766832-20476-4-git-send-email-yhlu.kernel@gmail.com>
 <1218766832-20476-5-git-send-email-yhlu.kernel@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

need to check if desc is null in smp_irq_move_cleanup

also migration need to reset vector too, so copy __target_IO_APIC_irq from 64bit

Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>
---
 arch/x86/kernel/io_apic_32.c |  188 +++++++++++++++++++++++++----------------
 1 files changed, 115 insertions(+), 73 deletions(-)

diff --git a/arch/x86/kernel/io_apic_32.c b/arch/x86/kernel/io_apic_32.c
index 2d504fa..e0f85b5 100644
--- a/arch/x86/kernel/io_apic_32.c
+++ b/arch/x86/kernel/io_apic_32.c
@@ -268,6 +268,7 @@ static struct irq_cfg *irq_cfg_with_new(unsigned int irq)
 	return cfg;
 }
 
+static int assign_irq_vector(int irq, cpumask_t mask);
 /*
  * Rough estimation of how many shared IRQs there are, can
  * be changed anytime.
@@ -437,6 +438,65 @@ static void ioapic_mask_entry(int apic, int pin)
 	spin_unlock_irqrestore(&ioapic_lock, flags);
 }
 
+#ifdef CONFIG_SMP
+static void __target_IO_APIC_irq(unsigned int irq, unsigned int dest, u8 vector)
+{
+	int apic, pin;
+	struct irq_cfg *cfg;
+	struct irq_pin_list *entry;
+
+	cfg = irq_cfg(irq);
+	entry = cfg->irq_2_pin;
+	for (;;) {
+		unsigned int reg;
+
+		if (!entry)
+			break;
+
+		apic = entry->apic;
+		pin = entry->pin;
+		io_apic_write(apic, 0x11 + pin*2, dest);
+		reg = io_apic_read(apic, 0x10 + pin*2);
+		reg &= ~IO_APIC_REDIR_VECTOR_MASK;
+		reg |= vector;
+		io_apic_modify(apic, 0x10 + pin *2, reg);
+		if (!entry->next)
+			break;
+		entry = entry->next;
+	}
+}
+static void set_ioapic_affinity_irq(unsigned int irq, struct irq_desc *desc, cpumask_t mask)
+{
+	struct irq_cfg *cfg;
+	unsigned long flags;
+	unsigned int dest;
+	cpumask_t tmp;
+
+	cfg = irq_cfg(irq);
+
+	cpus_and(tmp, mask, cpu_online_map);
+	if (cpus_empty(tmp))
+		return;
+
+	if (assign_irq_vector(irq, mask))
+		return;
+
+	cpus_and(tmp, cfg->domain, mask);
+
+	dest = cpu_mask_to_apicid(tmp);
+	/*
+	 * Only the high 8 bits are valid.
+	 */
+	dest = SET_APIC_LOGICAL_ID(dest);
+
+	spin_lock_irqsave(&ioapic_lock, flags);
+	__target_IO_APIC_irq(irq, dest, cfg->vector);
+	desc->affinity = mask;
+	spin_unlock_irqrestore(&ioapic_lock, flags);
+}
+
+#endif /* CONFIG_SMP */
+
 /*
  * The common case is 1:1 IRQ<->pin mappings. Sometimes there are
  * shared ISA-space IRQs, so we have to support them. We are super
@@ -591,44 +651,6 @@ static void clear_IO_APIC(void)
 			clear_IO_APIC_pin(apic, pin);
 }
 
-#ifdef CONFIG_SMP
-static void set_ioapic_affinity_irq(unsigned int irq, struct irq_desc *desc, cpumask_t cpumask)
-{
-	struct irq_cfg *cfg;
-	unsigned long flags;
-	int pin;
-	struct irq_pin_list *entry;
-	unsigned int apicid_value;
-	cpumask_t tmp;
-
-	cfg = irq_cfg(irq);
-	entry = cfg->irq_2_pin;
-
-	cpus_and(tmp, cpumask, cpu_online_map);
-	if (cpus_empty(tmp))
-		tmp = TARGET_CPUS;
-
-	cpus_and(cpumask, tmp, CPU_MASK_ALL);
-
-	apicid_value = cpu_mask_to_apicid(cpumask);
-	/* Prepare to do the io_apic_write */
-	apicid_value = apicid_value << 24;
-	spin_lock_irqsave(&ioapic_lock, flags);
-	for (;;) {
-		if (!entry)
-			break;
-		pin = entry->pin;
-		io_apic_write(entry->apic, 0x10 + 1 + pin*2, apicid_value);
-		if (!entry->next)
-			break;
-		entry = entry->next;
-	}
-	desc->affinity = cpumask;
-	spin_unlock_irqrestore(&ioapic_lock, flags);
-}
-
-#endif /* CONFIG_SMP */
-
 #ifndef CONFIG_SMP
 void send_IPI_self(int vector)
 {
@@ -793,34 +815,6 @@ int IO_APIC_get_PCI_irq_vector(int bus, int slot, int pin)
 }
 EXPORT_SYMBOL(IO_APIC_get_PCI_irq_vector);
 
-/*
- * This function currently is only a helper for the i386 smp boot process where
- * we need to reprogram the ioredtbls to cater for the cpus which have come online
- * so mask in all cases should simply be TARGET_CPUS
- */
-#ifdef CONFIG_SMP
-void __init setup_ioapic_dest(void)
-{
-	int pin, ioapic, irq, irq_entry;
-	struct irq_desc *desc;
-
-	if (skip_ioapic_setup == 1)
-		return;
-
-	for (ioapic = 0; ioapic < nr_ioapics; ioapic++) {
-		for (pin = 0; pin < nr_ioapic_registers[ioapic]; pin++) {
-			irq_entry = find_irq_entry(ioapic, pin, mp_INT);
-			if (irq_entry == -1)
-				continue;
-			irq = pin_2_irq(irq_entry, ioapic, pin);
-			desc = irq_desc(irq);
-			set_ioapic_affinity_irq(irq, desc, TARGET_CPUS);
-		}
-
-	}
-}
-#endif
-
 #if defined(CONFIG_EISA) || defined(CONFIG_MCA)
 /*
  * EISA Edge/Level control register, ELCR
@@ -2003,6 +1997,9 @@ asmlinkage void smp_irq_move_cleanup_interrupt(void)
 		irq = __get_cpu_var(vector_irq)[vector];
 
 		desc = irq_desc(irq);
+		if (!desc)
+			continue;
+
 		cfg = irq_cfg(irq);
 		spin_lock(&desc->lock);
 		if (!cfg->move_cleanup_count)
@@ -2695,15 +2692,15 @@ void arch_teardown_msi_irq(unsigned int irq)
 
 #ifdef CONFIG_SMP
 
-static void target_ht_irq(unsigned int irq, unsigned int dest)
+static void target_ht_irq(unsigned int irq, unsigned int dest, u8 vector)
 {
 	struct ht_irq_msg msg;
 	fetch_ht_irq_msg(irq, &msg);
 
-	msg.address_lo &= ~(HT_IRQ_LOW_DEST_ID_MASK);
+	msg.address_lo &= ~(HT_IRQ_LOW_VECTOR_MASK | HT_IRQ_LOW_DEST_ID_MASK);
 	msg.address_hi &= ~(HT_IRQ_HIGH_DEST_ID_MASK);
 
-	msg.address_lo |= HT_IRQ_LOW_DEST_ID(dest);
+	msg.address_lo |= HT_IRQ_LOW_VECTOR(vector) | HT_IRQ_LOW_DEST_ID(dest);
 	msg.address_hi |= HT_IRQ_HIGH_DEST_ID(dest);
 
 	write_ht_irq_msg(irq, &msg);
@@ -2711,18 +2708,22 @@ static void target_ht_irq(unsigned int irq, unsigned int dest)
 
 static void set_ht_irq_affinity(unsigned int irq, struct irq_desc *desc, cpumask_t mask)
 {
+	struct irq_cfg *cfg;
 	unsigned int dest;
 	cpumask_t tmp;
 
 	cpus_and(tmp, mask, cpu_online_map);
 	if (cpus_empty(tmp))
-		tmp = TARGET_CPUS;
+		return;
 
-	cpus_and(mask, tmp, CPU_MASK_ALL);
+	if (assign_irq_vector(irq, mask))
+		return;
 
-	dest = cpu_mask_to_apicid(mask);
+	cfg = irq_cfg(irq);
+	cpus_and(tmp, cfg->domain, mask);
+	dest = cpu_mask_to_apicid(tmp);
 
-	target_ht_irq(irq, dest);
+	target_ht_irq(irq, dest, cfg->vector);
 	desc->affinity = mask;
 }
 #endif
@@ -2925,6 +2926,47 @@ int acpi_get_override_irq(int bus_irq, int *trigger, int *polarity)
 
 #endif /* CONFIG_ACPI */
 
+/*
+ * This function currently is only a helper for the i386 smp boot process where
+ * we need to reprogram the ioredtbls to cater for the cpus which have come online
+ * so mask in all cases should simply be TARGET_CPUS
+ */
+#ifdef CONFIG_SMP
+void __init setup_ioapic_dest(void)
+{
+	int pin, ioapic, irq, irq_entry;
+	struct irq_cfg *cfg;
+	struct irq_desc *desc;
+
+	if (skip_ioapic_setup == 1)
+		return;
+
+	for (ioapic = 0; ioapic < nr_ioapics; ioapic++) {
+		for (pin = 0; pin < nr_ioapic_registers[ioapic]; pin++) {
+			irq_entry = find_irq_entry(ioapic, pin, mp_INT);
+			if (irq_entry == -1)
+				continue;
+			irq = pin_2_irq(irq_entry, ioapic, pin);
+
+			/* setup_IO_APIC_irqs could fail to get vector for some device
+			 * when you have too many devices, because at that time only boot
+			 * cpu is online.
+			 */
+			cfg = irq_cfg(irq);
+			if (!cfg->vector)
+				setup_IO_APIC_irq(ioapic, pin, irq,
+						  irq_trigger(irq_entry),
+						  irq_polarity(irq_entry));
+			else {
+				desc = irq_desc(irq);
+				set_ioapic_affinity_irq(irq, desc, TARGET_CPUS);
+			}
+		}
+
+	}
+}
+#endif
+
 static int __init parse_disable_timer_pin_1(char *arg)
 {
 	disable_timer_pin_1 = 1;
-- 
1.5.4.5

