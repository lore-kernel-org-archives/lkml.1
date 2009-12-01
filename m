Return-Path: <linux-kernel-owner+w=401wt.eu-S1755105AbZLBAzT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755105AbZLBAzT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Dec 2009 19:55:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755013AbZLBAym
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Dec 2009 19:54:42 -0500
Received: from mga11.intel.com ([192.55.52.93]:60065 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754943AbZLBAyk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Dec 2009 19:54:40 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.47,324,1257148800"; 
   d="scan'208";a="518876470"
Message-Id: <20091201233335.065361533@sbs-t61.sc.intel.com>
User-Agent: quilt/0.47-1
Date: Tue, 01 Dec 2009 15:31:16 -0800
From: Suresh Siddha <suresh.b.siddha@intel.com>
To: "Maciej W. Rozycki" <macro@linux-mips.org>, hpa@zytor.com, mingo@elte.hu,
       tglx@linutronix.de, ebiederm@xmission.com, garyhade@us.ibm.com
Cc: linux-kernel@vger.kernel.org, Suresh Siddha <suresh.b.siddha@intel.com>
Subject: [patch 2/4] x86, ioapic: fix the EOI register detection mechanism
References: <20091201233334.975416130@sbs-t61.sc.intel.com>
Content-Disposition: inline; filename=fix_ioapic_eoi_checks.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Maciej W. Rozycki reported:
> 82093AA I/O APIC has its version set to 0x11 and it 
> does not support the EOI register.  Similarly I/O APICs integrated into 
> the 82379AB south bridge and the 82374EB/SB EISA component.

IO-APIC versions below 0x20 don't support EOI register.

Some of the Intel ICH Specs (ICH2 to ICH5) documents the io-apic
version as 0x2. This is an error with documentation and these ICH chips
use io-apic's of version 0x20 and indeed has a working EOI register
for the io-apic.

Fix the EOI register detection mechanism to check for version 0x20 and beyond.

And also, a platform can potentially  have io-apic's with different versions.
Make the EOI register check per io-apic.

Reported-by: Maciej W. Rozycki <macro@linux-mips.org>
Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
---
 arch/x86/kernel/apic/io_apic.c |  115 +++++++++++++++++++++--------------------
 1 file changed, 61 insertions(+), 54 deletions(-)

Index: tip/arch/x86/kernel/apic/io_apic.c
===================================================================
--- tip.orig/arch/x86/kernel/apic/io_apic.c
+++ tip/arch/x86/kernel/apic/io_apic.c
@@ -539,23 +539,41 @@ static void __init replace_pin_at_irq_no
 	add_pin_to_irq_node(cfg, node, newapic, newpin);
 }
 
+static void __io_apic_modify_irq(struct irq_pin_list *entry,
+				 int mask_and, int mask_or,
+				 void (*final)(struct irq_pin_list *entry))
+{
+	unsigned int reg, pin;
+
+	pin = entry->pin;
+	reg = io_apic_read(entry->apic, 0x10 + pin * 2);
+	reg &= mask_and;
+	reg |= mask_or;
+	io_apic_modify(entry->apic, 0x10 + pin * 2, reg);
+	if (final)
+		final(entry);
+}
+
 static void io_apic_modify_irq(struct irq_cfg *cfg,
 			       int mask_and, int mask_or,
 			       void (*final)(struct irq_pin_list *entry))
 {
-	int pin;
 	struct irq_pin_list *entry;
 
-	for_each_irq_pin(entry, cfg->irq_2_pin) {
-		unsigned int reg;
-		pin = entry->pin;
-		reg = io_apic_read(entry->apic, 0x10 + pin * 2);
-		reg &= mask_and;
-		reg |= mask_or;
-		io_apic_modify(entry->apic, 0x10 + pin * 2, reg);
-		if (final)
-			final(entry);
-	}
+	for_each_irq_pin(entry, cfg->irq_2_pin)
+		__io_apic_modify_irq(entry, mask_and, mask_or, final);
+}
+
+static void __mask_and_edge_IO_APIC_irq(struct irq_pin_list *entry)
+{
+	__io_apic_modify_irq(entry, ~IO_APIC_REDIR_LEVEL_TRIGGER,
+			     IO_APIC_REDIR_MASKED, NULL);
+}
+
+static void __unmask_and_level_IO_APIC_irq(struct irq_pin_list *entry)
+{
+	__io_apic_modify_irq(entry, ~IO_APIC_REDIR_MASKED,
+			     IO_APIC_REDIR_LEVEL_TRIGGER, NULL);
 }
 
 static void __unmask_IO_APIC_irq(struct irq_cfg *cfg)
@@ -579,18 +597,6 @@ static void __mask_IO_APIC_irq(struct ir
 	io_apic_modify_irq(cfg, ~0, IO_APIC_REDIR_MASKED, &io_apic_sync);
 }
 
-static void __mask_and_edge_IO_APIC_irq(struct irq_cfg *cfg)
-{
-	io_apic_modify_irq(cfg, ~IO_APIC_REDIR_LEVEL_TRIGGER,
-			IO_APIC_REDIR_MASKED, NULL);
-}
-
-static void __unmask_and_level_IO_APIC_irq(struct irq_cfg *cfg)
-{
-	io_apic_modify_irq(cfg, ~IO_APIC_REDIR_MASKED,
-			IO_APIC_REDIR_LEVEL_TRIGGER, NULL);
-}
-
 static void mask_IO_APIC_irq_desc(struct irq_desc *desc)
 {
 	struct irq_cfg *cfg = desc->chip_data;
@@ -2492,17 +2498,42 @@ static void ack_apic_edge(unsigned int i
 
 atomic_t irq_mis_count;
 
-static int use_eoi_reg __read_mostly;
-
+/*
+ * IO-APIC versions below 0x20 don't support EOI register.
+ * For the record, here is the information about various versions:
+ *     0Xh     82489DX
+ *     1Xh     I/OAPIC or I/O(x)APIC which are not PCI 2.2 Compliant
+ *     2Xh     I/O(x)APIC which is PCI 2.2 Compliant
+ *     30h-FFh Reserved
+ *
+ * Some of the Intel ICH Specs (ICH2 to ICH5) documents the io-apic
+ * version as 0x2. This is an error with documentation and these ICH chips
+ * use io-apic's of version 0x20.
+ *
+ * For IO-APIC's with EOI register, we use that to do an explicit EOI.
+ * Otherwise, we simulate the EOI message manually by changing the trigger
+ * mode to edge and then back to level, with RTE being masked during this.
+*/
 static void __eoi_ioapic_irq(unsigned int irq, struct irq_cfg *cfg)
 {
 	struct irq_pin_list *entry;
 
 	for_each_irq_pin(entry, cfg->irq_2_pin) {
-		if (irq_remapped(irq))
-			io_apic_eoi(entry->apic, entry->pin);
-		else
-			io_apic_eoi(entry->apic, cfg->vector);
+		if (mp_ioapics[entry->apic].apicver >= 0x20) {
+			/*
+			 * Intr-remapping uses pin number as the virtual vector
+			 * in the RTE. Actual vector is programmed in
+			 * intr-remapping table entry. Hence for the io-apic
+			 * EOI we use the pin number.
+			 */
+			if (irq_remapped(irq))
+				io_apic_eoi(entry->apic, entry->pin);
+			else
+				io_apic_eoi(entry->apic, cfg->vector);
+		} else {
+			__mask_and_edge_IO_APIC_irq(entry);
+			__unmask_and_level_IO_APIC_irq(entry);
+		}
 	}
 }
 
@@ -2520,23 +2551,6 @@ static void eoi_ioapic_irq(struct irq_de
 	spin_unlock_irqrestore(&ioapic_lock, flags);
 }
 
-static int ioapic_supports_eoi(void)
-{
-	struct pci_dev *root;
-
-	root = pci_get_bus_and_slot(0, PCI_DEVFN(0, 0));
-	if (root && root->vendor == PCI_VENDOR_ID_INTEL &&
-	    mp_ioapics[0].apicver >= 0x2) {
-		use_eoi_reg = 1;
-		printk(KERN_INFO "IO-APIC supports EOI register\n");
-	} else
-		printk(KERN_INFO "IO-APIC doesn't support EOI\n");
-
-	return 0;
-}
-
-fs_initcall(ioapic_supports_eoi);
-
 static void ack_apic_level(unsigned int irq)
 {
 	struct irq_desc *desc = irq_to_desc(irq);
@@ -2587,14 +2601,7 @@ static void ack_apic_level(unsigned int 
 	if (!(v & (1 << (i & 0x1f)))) {
 		atomic_inc(&irq_mis_count);
 
-		if (use_eoi_reg)
-			eoi_ioapic_irq(desc);
-		else {
-			spin_lock(&ioapic_lock);
-			__mask_and_edge_IO_APIC_irq(cfg);
-			__unmask_and_level_IO_APIC_irq(cfg);
-			spin_unlock(&ioapic_lock);
-		}
+		eoi_ioapic_irq(desc);
 	}
 
 	/* Now we can move and renable the irq */


