Return-Path: <linux-kernel-owner+w=401wt.eu-S1754630AbZBWRqs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754630AbZBWRqs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Feb 2009 12:46:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752043AbZBWRqj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Feb 2009 12:46:39 -0500
Received: from smtp-noauth7.primus.ca ([216.254.180.38]:51218 "EHLO
	mail-01.primus.ca" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751981AbZBWRqi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Feb 2009 12:46:38 -0500
X-Greylist: delayed 1113 seconds by postgrey-1.27 at vger.kernel.org; Mon, 23 Feb 2009 12:46:38 EST
From: Matthew Wilcox <matthew@wil.cx>
To: linux-pci@vger.kernel.org, jbarnes@virtuousgeek.org,
       linux-kernel@vger.kernel.org
Cc: Matthew Wilcox <willy@linux.intel.com>
Subject: [PATCH 2/6] PCI MSI: Replace 'type' with 'is_msix'
Date: Mon, 23 Feb 2009 12:27:58 -0500
Message-Id: <1235410082-5016-3-git-send-email-matthew@wil.cx>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <1235410082-5016-1-git-send-email-matthew@wil.cx>
References: <1235410082-5016-1-git-send-email-matthew@wil.cx>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Matthew Wilcox <willy@linux.intel.com>

By changing from a 5-bit field to a 1-bit field, we free up some bits
that can be used by a later patch.  Also rearrange the fields for better
packing on 64-bit platforms (reducing the size of msi_desc from 72 bytes
to 64 bytes).

Signed-off-by: Matthew Wilcox <willy@linux.intel.com>
---
 drivers/pci/msi.c   |  115 +++++++++++++++++---------------------------------
 include/linux/msi.h |    4 +-
 2 files changed, 41 insertions(+), 78 deletions(-)

diff --git a/drivers/pci/msi.c b/drivers/pci/msi.c
index dceea56..b3db438 100644
--- a/drivers/pci/msi.c
+++ b/drivers/pci/msi.c
@@ -111,20 +111,10 @@ static void msix_flush_writes(struct irq_desc *desc)
 
 	entry = get_irq_desc_msi(desc);
 	BUG_ON(!entry || !entry->dev);
-	switch (entry->msi_attrib.type) {
-	case PCI_CAP_ID_MSI:
-		/* nothing to do */
-		break;
-	case PCI_CAP_ID_MSIX:
-	{
+	if (entry->msi_attrib.is_msix) {
 		int offset = entry->msi_attrib.entry_nr * PCI_MSIX_ENTRY_SIZE +
 			PCI_MSIX_ENTRY_VECTOR_CTRL_OFFSET;
 		readl(entry->mask_base + offset);
-		break;
-	}
-	default:
-		BUG();
-		break;
 	}
 }
 
@@ -143,32 +133,23 @@ static int msi_set_mask_bits(struct irq_desc *desc, u32 mask, u32 flag)
 
 	entry = get_irq_desc_msi(desc);
 	BUG_ON(!entry || !entry->dev);
-	switch (entry->msi_attrib.type) {
-	case PCI_CAP_ID_MSI:
-		if (entry->msi_attrib.maskbit) {
-			int pos;
-			u32 mask_bits;
-
-			pos = (long)entry->mask_base;
-			pci_read_config_dword(entry->dev, pos, &mask_bits);
-			mask_bits &= ~(mask);
-			mask_bits |= flag & mask;
-			pci_write_config_dword(entry->dev, pos, mask_bits);
-		} else {
-			return 0;
-		}
-		break;
-	case PCI_CAP_ID_MSIX:
-	{
+	if (entry->msi_attrib.is_msix) {
 		int offset = entry->msi_attrib.entry_nr * PCI_MSIX_ENTRY_SIZE +
 			PCI_MSIX_ENTRY_VECTOR_CTRL_OFFSET;
 		writel(flag, entry->mask_base + offset);
 		readl(entry->mask_base + offset);
-		break;
-	}
-	default:
-		BUG();
-		break;
+	} else {
+		int pos;
+		u32 mask_bits;
+
+		if (!entry->msi_attrib.maskbit)
+			return 0;
+
+		pos = (long)entry->mask_base;
+		pci_read_config_dword(entry->dev, pos, &mask_bits);
+		mask_bits &= ~mask;
+		mask_bits |= flag & mask;
+		pci_write_config_dword(entry->dev, pos, mask_bits);
 	}
 	entry->msi_attrib.masked = !!flag;
 	return 1;
@@ -177,9 +158,14 @@ static int msi_set_mask_bits(struct irq_desc *desc, u32 mask, u32 flag)
 void read_msi_msg_desc(struct irq_desc *desc, struct msi_msg *msg)
 {
 	struct msi_desc *entry = get_irq_desc_msi(desc);
-	switch(entry->msi_attrib.type) {
-	case PCI_CAP_ID_MSI:
-	{
+	if (entry->msi_attrib.is_msix) {
+		void __iomem *base = entry->mask_base +
+			entry->msi_attrib.entry_nr * PCI_MSIX_ENTRY_SIZE;
+
+		msg->address_lo = readl(base + PCI_MSIX_ENTRY_LOWER_ADDR_OFFSET);
+		msg->address_hi = readl(base + PCI_MSIX_ENTRY_UPPER_ADDR_OFFSET);
+		msg->data = readl(base + PCI_MSIX_ENTRY_DATA_OFFSET);
+	} else {
 		struct pci_dev *dev = entry->dev;
 		int pos = entry->msi_attrib.pos;
 		u16 data;
@@ -195,21 +181,6 @@ void read_msi_msg_desc(struct irq_desc *desc, struct msi_msg *msg)
 			pci_read_config_word(dev, msi_data_reg(pos, 0), &data);
 		}
 		msg->data = data;
-		break;
-	}
-	case PCI_CAP_ID_MSIX:
-	{
-		void __iomem *base;
-		base = entry->mask_base +
-			entry->msi_attrib.entry_nr * PCI_MSIX_ENTRY_SIZE;
-
-		msg->address_lo = readl(base + PCI_MSIX_ENTRY_LOWER_ADDR_OFFSET);
-		msg->address_hi = readl(base + PCI_MSIX_ENTRY_UPPER_ADDR_OFFSET);
-		msg->data = readl(base + PCI_MSIX_ENTRY_DATA_OFFSET);
- 		break;
- 	}
- 	default:
-		BUG();
 	}
 }
 
@@ -223,9 +194,17 @@ void read_msi_msg(unsigned int irq, struct msi_msg *msg)
 void write_msi_msg_desc(struct irq_desc *desc, struct msi_msg *msg)
 {
 	struct msi_desc *entry = get_irq_desc_msi(desc);
-	switch (entry->msi_attrib.type) {
-	case PCI_CAP_ID_MSI:
-	{
+	if (entry->msi_attrib.is_msix) {
+		void __iomem *base;
+		base = entry->mask_base +
+			entry->msi_attrib.entry_nr * PCI_MSIX_ENTRY_SIZE;
+
+		writel(msg->address_lo,
+			base + PCI_MSIX_ENTRY_LOWER_ADDR_OFFSET);
+		writel(msg->address_hi,
+			base + PCI_MSIX_ENTRY_UPPER_ADDR_OFFSET);
+		writel(msg->data, base + PCI_MSIX_ENTRY_DATA_OFFSET);
+	} else {
 		struct pci_dev *dev = entry->dev;
 		int pos = entry->msi_attrib.pos;
 
@@ -240,23 +219,6 @@ void write_msi_msg_desc(struct irq_desc *desc, struct msi_msg *msg)
 			pci_write_config_word(dev, msi_data_reg(pos, 0),
 						msg->data);
 		}
-		break;
-	}
-	case PCI_CAP_ID_MSIX:
-	{
-		void __iomem *base;
-		base = entry->mask_base +
-			entry->msi_attrib.entry_nr * PCI_MSIX_ENTRY_SIZE;
-
-		writel(msg->address_lo,
-			base + PCI_MSIX_ENTRY_LOWER_ADDR_OFFSET);
-		writel(msg->address_hi,
-			base + PCI_MSIX_ENTRY_UPPER_ADDR_OFFSET);
-		writel(msg->data, base + PCI_MSIX_ENTRY_DATA_OFFSET);
-		break;
-	}
-	default:
-		BUG();
 	}
 	entry->msg = *msg;
 }
@@ -393,7 +355,7 @@ static int msi_capability_init(struct pci_dev *dev)
 	if (!entry)
 		return -ENOMEM;
 
-	entry->msi_attrib.type = PCI_CAP_ID_MSI;
+	entry->msi_attrib.is_msix = 0;
 	entry->msi_attrib.is_64 = is_64bit_address(control);
 	entry->msi_attrib.entry_nr = 0;
 	entry->msi_attrib.maskbit = is_mask_bit_support(control);
@@ -475,7 +437,7 @@ static int msix_capability_init(struct pci_dev *dev,
 			break;
 
  		j = entries[i].entry;
-		entry->msi_attrib.type = PCI_CAP_ID_MSIX;
+		entry->msi_attrib.is_msix = 1;
 		entry->msi_attrib.is_64 = 1;
 		entry->msi_attrib.entry_nr = j;
 		entry->msi_attrib.maskbit = 1;
@@ -619,12 +581,13 @@ void pci_msi_shutdown(struct pci_dev* dev)
 		struct irq_desc *desc = irq_to_desc(dev->irq);
 		msi_set_mask_bits(desc, mask, ~mask);
 	}
-	if (!entry->dev || entry->msi_attrib.type != PCI_CAP_ID_MSI)
+	if (!entry->dev || entry->msi_attrib.is_msix)
 		return;
 
 	/* Restore dev->irq to its default pin-assertion irq */
 	dev->irq = entry->msi_attrib.default_irq;
 }
+
 void pci_disable_msi(struct pci_dev* dev)
 {
 	struct msi_desc *entry;
@@ -635,7 +598,7 @@ void pci_disable_msi(struct pci_dev* dev)
 	pci_msi_shutdown(dev);
 
 	entry = list_entry(dev->msi_list.next, struct msi_desc, list);
-	if (!entry->dev || entry->msi_attrib.type != PCI_CAP_ID_MSI)
+	if (!entry->dev || entry->msi_attrib.is_msix)
 		return;
 
 	msi_free_irqs(dev);
@@ -654,7 +617,7 @@ static int msi_free_irqs(struct pci_dev* dev)
 	arch_teardown_msi_irqs(dev);
 
 	list_for_each_entry_safe(entry, tmp, &dev->msi_list, list) {
-		if (entry->msi_attrib.type == PCI_CAP_ID_MSIX) {
+		if (entry->msi_attrib.is_msix) {
 			writel(1, entry->mask_base + entry->msi_attrib.entry_nr
 				  * PCI_MSIX_ENTRY_SIZE
 				  + PCI_MSIX_ENTRY_VECTOR_CTRL_OFFSET);
diff --git a/include/linux/msi.h b/include/linux/msi.h
index d2b8a1e..9c5ce21 100644
--- a/include/linux/msi.h
+++ b/include/linux/msi.h
@@ -20,13 +20,13 @@ extern void write_msi_msg(unsigned int irq, struct msi_msg *msg);
 
 struct msi_desc {
 	struct {
-		__u8	type	: 5; 	/* {0: unused, 5h:MSI, 11h:MSI-X} */
+		__u8	is_msix	: 1;
 		__u8	maskbit	: 1; 	/* mask-pending bit supported ?   */
 		__u8	masked	: 1;
 		__u8	is_64	: 1;	/* Address size: 0=32bit 1=64bit  */
 		__u8	pos;	 	/* Location of the msi capability */
-		__u32	maskbits_mask;  /* mask bits mask */
 		__u16	entry_nr;    	/* specific enabled entry 	  */
+		__u32	maskbits_mask;  /* mask bits mask */
 		unsigned default_irq;	/* default pre-assigned irq	  */
 	}msi_attrib;
 
-- 
1.5.6.5

