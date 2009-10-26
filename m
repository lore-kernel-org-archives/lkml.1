Return-Path: <linux-kernel-owner+w=401wt.eu-S1754324AbZJZWDn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754324AbZJZWDn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Oct 2009 18:03:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753556AbZJZWDm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Oct 2009 18:03:42 -0400
Received: from mga14.intel.com ([143.182.124.37]:23580 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753993AbZJZWCe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Oct 2009 18:02:34 -0400
X-ExtLoop1: 1
Message-Id: <20091026230001.947855317@sbs-t61.sc.intel.com>
User-Agent: quilt/0.47-1
Date: Mon, 26 Oct 2009 14:24:35 -0800
From: Suresh Siddha <suresh.b.siddha@intel.com>
To: hpa@zytor.com, mingo@elte.hu, tglx@linutronix.de, ebiederm@xmission.com
Cc: garyhade@us.ibm.com, suresh.b.siddha@intel.com,
       linux-kernel@vger.kernel.org
Subject: [RFC patch 5/6] x86: Use EOI register in io-apic on intel platforms
References: <20091026222430.313656103@sbs-t61.sc.intel.com>
Content-Disposition: inline; filename=use_eoi_for_intel_platforms.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

IO-APIC's in intel chipsets support EOI register starting from IO-APIC version
2. Use that when ever we need to clear the IO-APIC RTE's RemoteIRR bit
explicitly.

Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
Signed-off-by: Gary Hade <garyhade@us.ibm.com>
Cc: Eric W. Biederman <ebiederm@xmission.com>
---
 arch/x86/kernel/apic/io_apic.c |   80 +++++++++++++++++++++++++++--------------
 1 file changed, 53 insertions(+), 27 deletions(-)

Index: tip/arch/x86/kernel/apic/io_apic.c
===================================================================
--- tip.orig/arch/x86/kernel/apic/io_apic.c
+++ tip/arch/x86/kernel/apic/io_apic.c
@@ -2492,6 +2492,50 @@ static void ack_apic_edge(unsigned int i
 
 atomic_t irq_mis_count;
 
+static void __eoi_ioapic_irq(unsigned int irq, struct irq_cfg *cfg)
+{
+	struct irq_pin_list *entry;
+
+	for_each_irq_pin(entry, cfg->irq_2_pin)
+		if (irq_remapped(irq))
+			io_apic_eoi(entry->apic, entry->pin);
+		else
+			io_apic_eoi(entry->apic, cfg->vector);
+}
+
+static void
+eoi_ioapic_irq(struct irq_desc *desc)
+{
+	struct irq_cfg *cfg;
+	unsigned long flags;
+	unsigned int irq;
+
+	irq = desc->irq;
+	cfg = desc->chip_data;
+
+	spin_lock_irqsave(&ioapic_lock, flags);
+	__eoi_ioapic_irq(irq, cfg);
+	spin_unlock_irqrestore(&ioapic_lock, flags);
+}
+
+static int use_eoi_reg;
+static int ioapic_supports_eoi(void)
+{
+	struct pci_dev *root;
+
+	root = pci_get_bus_and_slot(0, PCI_DEVFN(0, 0));
+	if (root && root->vendor == PCI_VENDOR_ID_INTEL &&
+	    mp_ioapics[0].apicver >= 0x2) {
+		use_eoi_reg = 1;
+		printk("IO-APIC supports EOI register\n");
+	} else
+		printk("IO-APIC doesn't support EOI\n");
+
+	return 0;
+}
+
+fs_initcall(ioapic_supports_eoi);
+
 static void ack_apic_level(unsigned int irq)
 {
 	struct irq_desc *desc = irq_to_desc(irq);
@@ -2575,37 +2619,19 @@ static void ack_apic_level(unsigned int 
 	/* Tail end of version 0x11 I/O APIC bug workaround */
 	if (!(v & (1 << (i & 0x1f)))) {
 		atomic_inc(&irq_mis_count);
-		spin_lock(&ioapic_lock);
-		__mask_and_edge_IO_APIC_irq(cfg);
-		__unmask_and_level_IO_APIC_irq(cfg);
-		spin_unlock(&ioapic_lock);
+
+		if (use_eoi_reg)
+			eoi_ioapic_irq(desc);
+		else {
+			spin_lock(&ioapic_lock);
+			__mask_and_edge_IO_APIC_irq(cfg);
+			__unmask_and_level_IO_APIC_irq(cfg);
+			spin_unlock(&ioapic_lock);
+		}
 	}
 }
 
 #ifdef CONFIG_INTR_REMAP
-static void __eoi_ioapic_irq(unsigned int irq, struct irq_cfg *cfg)
-{
-	struct irq_pin_list *entry;
-
-	for_each_irq_pin(entry, cfg->irq_2_pin)
-		io_apic_eoi(entry->apic, entry->pin);
-}
-
-static void
-eoi_ioapic_irq(struct irq_desc *desc)
-{
-	struct irq_cfg *cfg;
-	unsigned long flags;
-	unsigned int irq;
-
-	irq = desc->irq;
-	cfg = desc->chip_data;
-
-	spin_lock_irqsave(&ioapic_lock, flags);
-	__eoi_ioapic_irq(irq, cfg);
-	spin_unlock_irqrestore(&ioapic_lock, flags);
-}
-
 static void ir_ack_apic_edge(unsigned int irq)
 {
 	ack_APIC_irq();


