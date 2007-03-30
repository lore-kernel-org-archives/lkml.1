Return-Path: <linux-kernel-owner+w=401wt.eu-S1751659AbXC3Syh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751659AbXC3Syh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2007 14:54:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751906AbXC3Syg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Mar 2007 14:54:36 -0400
Received: from mga02.intel.com ([134.134.136.20]:8826 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751690AbXC3Syf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2007 14:54:35 -0400
X-ExtLoop1: 1
X-IronPort-AV: i="4.14,354,1170662400"; 
   d="scan'208"; a="219404867:sNHT33129607"
Subject: [PATCH 2.6.21-rc5] Flush MSI-X table writes (rev 3)
From: Mitch Williams <mitch.a.williams@intel.com>
To: linux-pci@atrey.karlin.mff.cuni.cz, akpm@linux-foundation.org
Cc: gregkh@suse.de, ebiederm@xmission.com, linux-kernel@vger.kernel.org,
       auke-jan.h.kok@intel.com
Content-Type: text/plain
Date: Fri, 30 Mar 2007 11:54:08 -0700
Message-Id: <1175280848.17652.5.camel@strongmad>
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
mask and unmask operations.  Since the SMP affinity is set while
the interrupt is masked, and since it's unmasked immediately after,
no additional flushes are required in the various affinity setting
routines.

This patch has been validated with (unreleased) network hardware which
uses MSI-X.

Revised with input from Eric Biederman.

Signed-off-by: Mitch Williams <mitch.a.williams@intel.com>

diff -urpN -X dontdiff linux-2.6.21-rc5-clean/drivers/pci/msi.c linux-2.6.21-rc5/drivers/pci/msi.c
--- linux-2.6.21-rc5-clean/drivers/pci/msi.c	2007-03-28 10:05:24.000000000 -0700
+++ linux-2.6.21-rc5/drivers/pci/msi.c	2007-03-28 09:21:34.000000000 -0700
@@ -68,6 +68,29 @@ static void msix_set_enable(struct pci_d
 	}
 }
 
+static void msix_flush_writes(unsigned int irq)
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
@@ -186,11 +209,13 @@ void write_msi_msg(unsigned int irq, str
 void mask_msi_irq(unsigned int irq)
 {
 	msi_set_mask_bit(irq, 1);
+	msix_flush_writes(irq);
 }
 
 void unmask_msi_irq(unsigned int irq)
 {
 	msi_set_mask_bit(irq, 0);
+	msix_flush_writes(irq);
 }
 
 static int msi_free_irq(struct pci_dev* dev, int irq);
