Return-Path: <linux-kernel-owner+w=401wt.eu-S1752609AbXCVVIW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752609AbXCVVIW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Mar 2007 17:08:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752577AbXCVVIW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Mar 2007 17:08:22 -0400
Received: from mga03.intel.com ([143.182.124.21]:41631 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752599AbXCVVIV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Mar 2007 17:08:21 -0400
X-ExtLoop1: 1
X-IronPort-AV: i="4.14,316,1170662400"; 
   d="scan'208"; a="201021279:sNHT30786721"
Subject: [PATCH 2.6.20.3] Flush writes to MSI-X table
From: Mitch Williams <mitch.a.williams@intel.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@redhat.com, gregkh@suse.de, auke-jan.h.kok@intel.com,
       john.ronciak@intel.com, jesse.brandeburg@intel.com
Content-Type: text/plain
Date: Thu, 22 Mar 2007 14:08:19 -0700
Message-Id: <1174597699.24177.32.camel@strongmad>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.3 (2.6.3-1.fc5.5) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

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

Signed-off-by: Mitch Williams <mitch.a.williams@intel.com>

diff -urpN -X dontdiff linux-2.6.20.3-clean/arch/i386/kernel/io_apic.c linux-2.6.20.3/arch/i386/kernel/io_apic.c
--- linux-2.6.20.3-clean/arch/i386/kernel/io_apic.c	2007-02-04 10:44:54.000000000 -0800
+++ linux-2.6.20.3/arch/i386/kernel/io_apic.c	2007-03-22 10:33:47.000000000 -0700
@@ -2597,6 +2597,8 @@ static void set_msi_irq_affinity(unsigne
  */
 static struct irq_chip msi_chip = {
 	.name		= "PCI-MSI",
+	.enable		= enable_msi_irq,
+	.disable	= disable_msi_irq,
 	.unmask		= unmask_msi_irq,
 	.mask		= mask_msi_irq,
 	.ack		= ack_ioapic_irq,
diff -urpN -X dontdiff linux-2.6.20.3-clean/arch/ia64/kernel/msi_ia64.c linux-2.6.20.3/arch/ia64/kernel/msi_ia64.c
--- linux-2.6.20.3-clean/arch/ia64/kernel/msi_ia64.c	2007-02-04 10:44:54.000000000 -0800
+++ linux-2.6.20.3/arch/ia64/kernel/msi_ia64.c	2007-03-22 10:33:47.000000000 -0700
@@ -116,6 +116,8 @@ static int ia64_msi_retrigger_irq(unsign
  */
 static struct irq_chip ia64_msi_chip = {
 	.name		= "PCI-MSI",
+	.enable		= enable_msi_irq,
+	.disable	= disable_msi_irq,
 	.mask		= mask_msi_irq,
 	.unmask		= unmask_msi_irq,
 	.ack		= ia64_ack_msi_irq,
diff -urpN -X dontdiff linux-2.6.20.3-clean/arch/ia64/sn/kernel/msi_sn.c linux-2.6.20.3/arch/ia64/sn/kernel/msi_sn.c
--- linux-2.6.20.3-clean/arch/ia64/sn/kernel/msi_sn.c	2007-02-04 10:44:54.000000000 -0800
+++ linux-2.6.20.3/arch/ia64/sn/kernel/msi_sn.c	2007-03-22 10:33:47.000000000 -0700
@@ -216,6 +216,8 @@ static int sn_msi_retrigger_irq(unsigned
 
 static struct irq_chip sn_msi_chip = {
 	.name		= "PCI-MSI",
+	.enable		= enable_msi_irq,
+	.disable	= disable_msi_irq,
 	.mask		= mask_msi_irq,
 	.unmask		= unmask_msi_irq,
 	.ack		= sn_ack_msi_irq,
diff -urpN -X dontdiff linux-2.6.20.3-clean/arch/x86_64/kernel/io_apic.c linux-2.6.20.3/arch/x86_64/kernel/io_apic.c
--- linux-2.6.20.3-clean/arch/x86_64/kernel/io_apic.c	2007-02-04 10:44:54.000000000 -0800
+++ linux-2.6.20.3/arch/x86_64/kernel/io_apic.c	2007-03-22 10:36:03.000000000 -0700
@@ -1923,6 +1923,7 @@ static void set_msi_irq_affinity(unsigne
 
 	cpus_and(mask, tmp, CPU_MASK_ALL);
 
+	msix_flush_writes(irq);
 	vector = assign_irq_vector(irq, mask, &tmp);
 	if (vector < 0)
 		return;
@@ -1937,6 +1938,7 @@ static void set_msi_irq_affinity(unsigne
 	msg.address_lo |= MSI_ADDR_DEST_ID(dest);
 
 	write_msi_msg(irq, &msg);
+	msix_flush_writes(irq);
 	set_native_irq_info(irq, mask);
 }
 #endif /* CONFIG_SMP */
@@ -1947,6 +1949,8 @@ static void set_msi_irq_affinity(unsigne
  */
 static struct irq_chip msi_chip = {
 	.name		= "PCI-MSI",
+	.enable		= enable_msi_irq,
+	.disable	= disable_msi_irq,
 	.unmask		= unmask_msi_irq,
 	.mask		= mask_msi_irq,
 	.ack		= ack_apic_edge,
diff -urpN -X dontdiff linux-2.6.20.3-clean/drivers/pci/msi.c linux-2.6.20.3/drivers/pci/msi.c
--- linux-2.6.20.3-clean/drivers/pci/msi.c	2007-02-04 10:44:54.000000000 -0800
+++ linux-2.6.20.3/drivers/pci/msi.c	2007-03-22 10:33:47.000000000 -0700
@@ -40,6 +40,29 @@ static int msi_cache_init(void)
 	return 0;
 }
 
+void msix_flush_writes(unsigned int irq)
+{
+	struct msi_desc *entry;
+
+	entry = msi_desc[irq];
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
@@ -161,6 +184,17 @@ void unmask_msi_irq(unsigned int irq)
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
 {
diff -urpN -X dontdiff linux-2.6.20.3-clean/include/linux/msi.h linux-2.6.20.3/include/linux/msi.h
--- linux-2.6.20.3-clean/include/linux/msi.h	2007-02-04 10:44:54.000000000 -0800
+++ linux-2.6.20.3/include/linux/msi.h	2007-03-22 10:33:47.000000000 -0700
@@ -10,9 +10,12 @@ struct msi_msg {
 /* Heper functions */
 extern void mask_msi_irq(unsigned int irq);
 extern void unmask_msi_irq(unsigned int irq);
+extern void disable_msi_irq(unsigned int irq);
+extern void enable_msi_irq(unsigned int irq);
 extern void read_msi_msg(unsigned int irq, struct msi_msg *msg);
 
 extern void write_msi_msg(unsigned int irq, struct msi_msg *msg);
+extern void msix_flush_writes(unsigned int irq);
 
 struct msi_desc {
 	struct {
