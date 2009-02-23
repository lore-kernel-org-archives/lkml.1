Return-Path: <linux-kernel-owner+w=401wt.eu-S1756234AbZBWSAn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756234AbZBWSAn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Feb 2009 13:00:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753685AbZBWSAL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Feb 2009 13:00:11 -0500
Received: from smtp-noauth7.primus.ca ([216.254.180.38]:51904 "EHLO
	mail-07.primus.ca" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753273AbZBWSAK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Feb 2009 13:00:10 -0500
From: Matthew Wilcox <matthew@wil.cx>
To: linux-pci@vger.kernel.org, jbarnes@virtuousgeek.org,
       linux-kernel@vger.kernel.org
Cc: Matthew Wilcox <willy@linux.intel.com>
Subject: [PATCH 3/6] PCI MSI: msi_desc->dev is always initialised
Date: Mon, 23 Feb 2009 12:27:59 -0500
Message-Id: <1235410082-5016-4-git-send-email-matthew@wil.cx>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <1235410082-5016-1-git-send-email-matthew@wil.cx>
References: <1235410082-5016-1-git-send-email-matthew@wil.cx>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Matthew Wilcox <willy@linux.intel.com>

By passing the pci_dev into alloc_msi_entry() we can be sure that
the ->dev entry is always assigned and so we don't need to check it.
Also, we used kzalloc() so we don't need to initialise ->irq to 0.

Signed-off-by: Matthew Wilcox <willy@linux.intel.com>
---
 drivers/pci/msi.c |   29 ++++++++++++-----------------
 1 files changed, 12 insertions(+), 17 deletions(-)

diff --git a/drivers/pci/msi.c b/drivers/pci/msi.c
index b3db438..a658c0f 100644
--- a/drivers/pci/msi.c
+++ b/drivers/pci/msi.c
@@ -110,7 +110,7 @@ static void msix_flush_writes(struct irq_desc *desc)
 	struct msi_desc *entry;
 
 	entry = get_irq_desc_msi(desc);
-	BUG_ON(!entry || !entry->dev);
+	BUG_ON(!entry);
 	if (entry->msi_attrib.is_msix) {
 		int offset = entry->msi_attrib.entry_nr * PCI_MSIX_ENTRY_SIZE +
 			PCI_MSIX_ENTRY_VECTOR_CTRL_OFFSET;
@@ -132,7 +132,7 @@ static int msi_set_mask_bits(struct irq_desc *desc, u32 mask, u32 flag)
 	struct msi_desc *entry;
 
 	entry = get_irq_desc_msi(desc);
-	BUG_ON(!entry || !entry->dev);
+	BUG_ON(!entry);
 	if (entry->msi_attrib.is_msix) {
 		int offset = entry->msi_attrib.entry_nr * PCI_MSIX_ENTRY_SIZE +
 			PCI_MSIX_ENTRY_VECTOR_CTRL_OFFSET;
@@ -248,19 +248,16 @@ void unmask_msi_irq(unsigned int irq)
 
 static int msi_free_irqs(struct pci_dev* dev);
 
-static struct msi_desc* alloc_msi_entry(void)
+static struct msi_desc *alloc_msi_entry(struct pci_dev *dev)
 {
-	struct msi_desc *entry;
-
-	entry = kzalloc(sizeof(struct msi_desc), GFP_KERNEL);
-	if (!entry)
+	struct msi_desc *desc = kzalloc(sizeof(*desc), GFP_KERNEL);
+	if (!desc)
 		return NULL;
 
-	INIT_LIST_HEAD(&entry->list);
-	entry->irq = 0;
-	entry->dev = NULL;
+	INIT_LIST_HEAD(&desc->list);
+	desc->dev = dev;
 
-	return entry;
+	return desc;
 }
 
 static void pci_intx_for_msi(struct pci_dev *dev, int enable)
@@ -351,7 +348,7 @@ static int msi_capability_init(struct pci_dev *dev)
    	pos = pci_find_capability(dev, PCI_CAP_ID_MSI);
 	pci_read_config_word(dev, msi_control_reg(pos), &control);
 	/* MSI Entry Initialization */
-	entry = alloc_msi_entry();
+	entry = alloc_msi_entry(dev);
 	if (!entry)
 		return -ENOMEM;
 
@@ -362,7 +359,6 @@ static int msi_capability_init(struct pci_dev *dev)
 	entry->msi_attrib.masked = 1;
 	entry->msi_attrib.default_irq = dev->irq;	/* Save IOAPIC IRQ */
 	entry->msi_attrib.pos = pos;
-	entry->dev = dev;
 	if (entry->msi_attrib.maskbit) {
 		unsigned int base, maskbits, temp;
 
@@ -432,7 +428,7 @@ static int msix_capability_init(struct pci_dev *dev,
 
 	/* MSI-X Table Initialization */
 	for (i = 0; i < nvec; i++) {
-		entry = alloc_msi_entry();
+		entry = alloc_msi_entry(dev);
 		if (!entry)
 			break;
 
@@ -444,7 +440,6 @@ static int msix_capability_init(struct pci_dev *dev,
 		entry->msi_attrib.masked = 1;
 		entry->msi_attrib.default_irq = dev->irq;
 		entry->msi_attrib.pos = pos;
-		entry->dev = dev;
 		entry->mask_base = base;
 
 		list_add_tail(&entry->list, &dev->msi_list);
@@ -581,7 +576,7 @@ void pci_msi_shutdown(struct pci_dev* dev)
 		struct irq_desc *desc = irq_to_desc(dev->irq);
 		msi_set_mask_bits(desc, mask, ~mask);
 	}
-	if (!entry->dev || entry->msi_attrib.is_msix)
+	if (entry->msi_attrib.is_msix)
 		return;
 
 	/* Restore dev->irq to its default pin-assertion irq */
@@ -598,7 +593,7 @@ void pci_disable_msi(struct pci_dev* dev)
 	pci_msi_shutdown(dev);
 
 	entry = list_entry(dev->msi_list.next, struct msi_desc, list);
-	if (!entry->dev || entry->msi_attrib.is_msix)
+	if (entry->msi_attrib.is_msix)
 		return;
 
 	msi_free_irqs(dev);
-- 
1.5.6.5

