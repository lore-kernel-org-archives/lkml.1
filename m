Return-Path: <linux-kernel-owner+w=401wt.eu-S1758668AbYGKVUJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758668AbYGKVUJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2008 17:20:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760320AbYGKVSz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Jul 2008 17:18:55 -0400
Received: from mail.tor.primus.ca ([216.254.136.21]:36157 "EHLO
	mail-06.primus.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760226AbYGKVSw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2008 17:18:52 -0400
From: Matthew Wilcox <matthew@wil.cx>
To: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: grundler@parisc-linux.org, mingo@elte.hu, tglx@linutronix.de,
       jgarzik@pobox.com, linux-ide@vger.kernel.org, suresh.b.siddha@intel.com,
       benh@kernel.crashing.org, jbarnes@virtuousgeek.org,
       rdunlap@xenotime.net, mtk.manpages@gmail.com, ebiederm@xmission.com,
       Matthew Wilcox <matthew@wil.cx>, Matthew Wilcox <willy@linux.intel.com>
Subject: [PATCH 2/6] PCI MSI: Replace 'type' with 'is_msix'
Date: Fri, 11 Jul 2008 17:16:54 -0400
Message-Id: <1215811018-15270-2-git-send-email-matthew@wil.cx>
X-Mailer: git-send-email 1.5.5.4
In-Reply-To: <20080711211559.GV14894@parisc-linux.org>
References: <20080711211559.GV14894@parisc-linux.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

By changing from a 5-bit field to a 1-bit field, we free up some bits
that can be used by a later patch.  Also rearrange the fields for better
packing on 64-bit platforms (reducing the size of msi_desc from 72 bytes
to 64 bytes).

Signed-off-by: Matthew Wilcox <willy@linux.intel.com>
---
 drivers/pci/msi.c   |  100 ++++++++++++++++----------------------------------
 include/linux/msi.h |    4 +-
 2 files changed, 34 insertions(+), 70 deletions(-)

diff --git a/drivers/pci/msi.c b/drivers/pci/msi.c
index 8c61304..104f297 100644
--- a/drivers/pci/msi.c
+++ b/drivers/pci/msi.c
@@ -106,20 +106,10 @@ static void msix_flush_writes(unsigned int irq)
 
 	entry = get_irq_msi(irq);
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
 
@@ -129,8 +119,12 @@ static void msi_set_mask_bits(unsigned int irq, u32 mask, u32 flag)
 
 	entry = get_irq_msi(irq);
 	BUG_ON(!entry || !entry->dev);
-	switch (entry->msi_attrib.type) {
-	case PCI_CAP_ID_MSI:
+	if (entry->msi_attrib.is_msix) {
+		int offset = entry->msi_attrib.entry_nr * PCI_MSIX_ENTRY_SIZE +
+			PCI_MSIX_ENTRY_VECTOR_CTRL_OFFSET;
+		writel(flag, entry->mask_base + offset);
+		readl(entry->mask_base + offset);
+	} else {
 		if (entry->msi_attrib.maskbit) {
 			int pos;
 			u32 mask_bits;
@@ -143,18 +137,6 @@ static void msi_set_mask_bits(unsigned int irq, u32 mask, u32 flag)
 		} else {
 			msi_set_enable(entry->dev, !flag);
 		}
-		break;
-	case PCI_CAP_ID_MSIX:
-	{
-		int offset = entry->msi_attrib.entry_nr * PCI_MSIX_ENTRY_SIZE +
-			PCI_MSIX_ENTRY_VECTOR_CTRL_OFFSET;
-		writel(flag, entry->mask_base + offset);
-		readl(entry->mask_base + offset);
-		break;
-	}
-	default:
-		BUG();
-		break;
 	}
 	entry->msi_attrib.masked = !!flag;
 }
@@ -162,9 +144,14 @@ static void msi_set_mask_bits(unsigned int irq, u32 mask, u32 flag)
 void read_msi_msg(unsigned int irq, struct msi_msg *msg)
 {
 	struct msi_desc *entry = get_irq_msi(irq);
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
@@ -180,30 +167,23 @@ void read_msi_msg(unsigned int irq, struct msi_msg *msg)
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
 
 void write_msi_msg(unsigned int irq, struct msi_msg *msg)
 {
 	struct msi_desc *entry = get_irq_msi(irq);
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
 
@@ -218,23 +198,6 @@ void write_msi_msg(unsigned int irq, struct msi_msg *msg)
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
@@ -359,7 +322,7 @@ static int msi_capability_init(struct pci_dev *dev)
 	if (!entry)
 		return -ENOMEM;
 
-	entry->msi_attrib.type = PCI_CAP_ID_MSI;
+	entry->msi_attrib.is_msix = 0;
 	entry->msi_attrib.is_64 = is_64bit_address(control);
 	entry->msi_attrib.entry_nr = 0;
 	entry->msi_attrib.maskbit = is_mask_bit_support(control);
@@ -446,7 +409,7 @@ static int msix_capability_init(struct pci_dev *dev,
 			break;
 
  		j = entries[i].entry;
-		entry->msi_attrib.type = PCI_CAP_ID_MSIX;
+		entry->msi_attrib.is_msix = 1;
 		entry->msi_attrib.is_64 = 1;
 		entry->msi_attrib.entry_nr = j;
 		entry->msi_attrib.maskbit = 1;
@@ -589,12 +552,13 @@ void pci_msi_shutdown(struct pci_dev* dev)
 		u32 mask = entry->msi_attrib.maskbits_mask;
 		msi_set_mask_bits(dev->irq, mask, ~mask);
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
@@ -605,7 +569,7 @@ void pci_disable_msi(struct pci_dev* dev)
 	pci_msi_shutdown(dev);
 
 	entry = list_entry(dev->msi_list.next, struct msi_desc, list);
-	if (!entry->dev || entry->msi_attrib.type != PCI_CAP_ID_MSI)
+	if (!entry->dev || entry->msi_attrib.is_msix)
 		return;
 
 	msi_free_irqs(dev);
@@ -624,7 +588,7 @@ static int msi_free_irqs(struct pci_dev* dev)
 	arch_teardown_msi_irqs(dev);
 
 	list_for_each_entry_safe(entry, tmp, &dev->msi_list, list) {
-		if (entry->msi_attrib.type == PCI_CAP_ID_MSIX) {
+		if (entry->msi_attrib.is_msix) {
 			writel(1, entry->mask_base + entry->msi_attrib.entry_nr
 				  * PCI_MSIX_ENTRY_SIZE
 				  + PCI_MSIX_ENTRY_VECTOR_CTRL_OFFSET);
diff --git a/include/linux/msi.h b/include/linux/msi.h
index 8f29392..13a8a1b 100644
--- a/include/linux/msi.h
+++ b/include/linux/msi.h
@@ -17,13 +17,13 @@ extern void write_msi_msg(unsigned int irq, struct msi_msg *msg);
 
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
1.5.5.4

