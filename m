Return-Path: <linux-kernel-owner+w=401wt.eu-S1751443AbXCZXSf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751443AbXCZXSf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Mar 2007 19:18:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752203AbXCZXSf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Mar 2007 19:18:35 -0400
Received: from mga01.intel.com ([192.55.52.88]:28413 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750917AbXCZXSe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Mar 2007 19:18:34 -0400
X-ExtLoop1: 1
X-IronPort-AV: i="4.14,331,1170662400"; 
   d="scan'208"; a="219730595:sNHT1008886417"
Subject: [PATCH 2.6.21-rc5] MSI: read-flush MSI-X table
From: Mitch Williams <mitch.a.williams@intel.com>
To: linux-pci@atrey.karlin.mff.cuni.cz
Cc: gregkh@suse.de, ebiederm@xmission.com, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, auke-jan.h.kok@intel.com
Content-Type: text/plain
Date: Mon, 26 Mar 2007 16:18:22 -0700
Message-Id: <1174951102.22190.15.camel@strongmad>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.3 (2.6.3-1.fc5.5) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes a kernel bug which is triggered when using the
irqbalance daemon with MSI-X hardware.

Because both MSI-X interrupt messages and MSI-X table writes are posted,
it's possible for them to cross while in-flight.  This results in
interrupts being received long after the kernel thinks they're disabled,
and in interrupts being sent to stale vectors after rebalancing.

This patch performs a read flush after writes to the MSI-X table for
enable/disable and rebalancing operations.  Because this is an expensive
operation, we do not perform the read flush after mask/unmask
operations.  Hardware which supports MSI-X typically also supports some
sort of interrupt moderation, so a read-flush is not necessary for
mask/unmask operations.

This patch has been validated with (unreleased) network hardware which
uses MSI-X.

Generated from 2.6.21-rc4; applies cleanly to 2.6.21-rc5.

Signed-off-by: Mitch Williams <mitch.a.williams@intel.com>

diff -urpN -X dontdiff linux-2.6.21-rc4-clean/arch/i386/kernel/io_apic.c linux-2.6.21-rc4/arch/i386/kernel/io_apic.c
--- linux-2.6.21-rc4-clean/arch/i386/kernel/io_apic.c	2007-03-19 16:16:30.000000000 -0700
+++ linux-2.6.21-rc4/arch/i386/kernel/io_apic.c	2007-03-19 16:24:05.000000000 -0700
@@ -2594,6 +2594,8 @@ static void set_msi_irq_affinity(unsigne
  */
 static struct irq_chip msi_chip = {
 	.name		= "PCI-MSI",
+	.enable		= enable_msi_irq,
+	.disable	= disable_msi_irq,
 	.unmask		= unmask_msi_irq,
 	.mask		= mask_msi_irq,
 	.ack		= ack_ioapic_irq,
diff -urpN -X dontdiff linux-2.6.21-rc4-clean/arch/ia64/kernel/msi_ia64.c linux-2.6.21-rc4/arch/ia64/kernel/msi_ia64.c
--- linux-2.6.21-rc4-clean/arch/ia64/kernel/msi_ia64.c	2007-03-19 16:16:30.000000000 -0700
+++ linux-2.6.21-rc4/arch/ia64/kernel/msi_ia64.c	2007-03-19 16:24:05.000000000 -0700
@@ -121,6 +121,8 @@ static int ia64_msi_retrigger_irq(unsign
  */
 static struct irq_chip ia64_msi_chip = {
 	.name		= "PCI-MSI",
+	.enable		= enable_msi_irq,
+	.disable	= disable_msi_irq,
 	.mask		= mask_msi_irq,
 	.unmask		= unmask_msi_irq,
 	.ack		= ia64_ack_msi_irq,
diff -urpN -X dontdiff linux-2.6.21-rc4-clean/arch/ia64/sn/kernel/msi_sn.c linux-2.6.21-rc4/arch/ia64/sn/kernel/msi_sn.c
--- linux-2.6.21-rc4-clean/arch/ia64/sn/kernel/msi_sn.c	2007-03-19 16:16:30.000000000 -0700
+++ linux-2.6.21-rc4/arch/ia64/sn/kernel/msi_sn.c	2007-03-19 16:24:05.000000000 -0700
@@ -224,6 +224,8 @@ static int sn_msi_retrigger_irq(unsigned
 
 static struct irq_chip sn_msi_chip = {
 	.name		= "PCI-MSI",
+	.enable		= enable_msi_irq,
+	.disable	= disable_msi_irq,
 	.mask		= mask_msi_irq,
 	.unmask		= unmask_msi_irq,
 	.ack		= sn_ack_msi_irq,
diff -urpN -X dontdiff linux-2.6.21-rc4-clean/arch/x86_64/kernel/io_apic.c linux-2.6.21-rc4/arch/x86_64/kernel/io_apic.c
--- linux-2.6.21-rc4-clean/arch/x86_64/kernel/io_apic.c	2007-03-19 16:16:31.000000000 -0700
+++ linux-2.6.21-rc4/arch/x86_64/kernel/io_apic.c	2007-03-21 12:44:51.000000000 -0700
@@ -1942,6 +1942,7 @@ static void set_msi_irq_affinity(unsigne
 	if (cpus_empty(tmp))
 		return;
 
+	msix_flush_writes(irq);
 	if (assign_irq_vector(irq, mask))
 		return;
 
@@ -1956,6 +1957,7 @@ static void set_msi_irq_affinity(unsigne
 	msg.address_lo |= MSI_ADDR_DEST_ID(dest);
 
 	write_msi_msg(irq, &msg);
+	msix_flush_writes(irq);
 	irq_desc[irq].affinity = mask;
 }
 #endif /* CONFIG_SMP */
@@ -1966,6 +1968,8 @@ static void set_msi_irq_affinity(unsigne
  */
 static struct irq_chip msi_chip = {
 	.name		= "PCI-MSI",
+	.enable		= enable_msi_irq,
+	.disable	= disable_msi_irq,
 	.unmask		= unmask_msi_irq,
 	.mask		= mask_msi_irq,
 	.ack		= ack_apic_edge,
diff -urpN -X dontdiff linux-2.6.21-rc4-clean/drivers/pci/msi.c linux-2.6.21-rc4/drivers/pci/msi.c
--- linux-2.6.21-rc4-clean/drivers/pci/msi.c	2007-03-19 16:16:32.000000000 -0700
+++ linux-2.6.21-rc4/drivers/pci/msi.c	2007-03-21 12:44:51.000000000 -0700
@@ -68,6 +68,29 @@ static void msix_set_enable(struct pci_d
 	}
 }
 
+void msix_flush_writes(unsigned int irq)
+{
+	struct msi_desc *entry;
+
+	entry = get_irq_msi(irq);
+	BUG_ON(!entry || !entry->dev);
+	switch (entry->msi_attrib.type) {
+	case PCI_CAP_ID_MSI:
+		/* nothing to do */
+		break;
+	case PCI_CAP_ID_MSIX:
+	{
+		int offset = entry->msi_attrib.entry_nr * PCI_MSIX_ENTRY_SIZE +
+			PCI_MSIX_ENTRY_VECTOR_CTRL_OFFSET;
+		readl(entry->mask_base + offset);
+		break;
+	}
+	default:
+		BUG();
+		break;
+	}
+}
+
 static void msi_set_mask_bit(unsigned int irq, int flag)
 {
 	struct msi_desc *entry;
@@ -193,6 +216,17 @@ void unmask_msi_irq(unsigned int irq)
 	msi_set_mask_bit(irq, 0);
 }
 
+void disable_msi_irq(unsigned int irq)
+{
+	msi_set_mask_bit(irq, 1);
+	msix_flush_writes(irq);
+}
+
+void enable_msi_irq(unsigned int irq)
+{
+	msi_set_mask_bit(irq, 0);
+	msix_flush_writes(irq);
+}
 static int msi_free_irq(struct pci_dev* dev, int irq);
 
 static int msi_init(void)
diff -urpN -X dontdiff linux-2.6.21-rc4-clean/include/linux/msi.h linux-2.6.21-rc4/include/linux/msi.h
--- linux-2.6.21-rc4-clean/include/linux/msi.h	2007-03-19 16:16:34.000000000 -0700
+++ linux-2.6.21-rc4/include/linux/msi.h	2007-03-21 12:44:51.000000000 -0700
@@ -10,8 +10,11 @@ struct msi_msg {
 /* Helper functions */
 extern void mask_msi_irq(unsigned int irq);
 extern void unmask_msi_irq(unsigned int irq);
+extern void disable_msi_irq(unsigned int irq);
+extern void enable_msi_irq(unsigned int irq);
 extern void read_msi_msg(unsigned int irq, struct msi_msg *msg);
 extern void write_msi_msg(unsigned int irq, struct msi_msg *msg);
+extern void msix_flush_writes(unsigned int irq);
 
 struct msi_desc {
 	struct {
