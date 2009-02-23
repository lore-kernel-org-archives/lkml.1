Return-Path: <linux-kernel-owner+w=401wt.eu-S1756325AbZBWRwX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756325AbZBWRwX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Feb 2009 12:52:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753253AbZBWRvu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Feb 2009 12:51:50 -0500
Received: from smtp-noauth7.primus.ca ([216.254.180.38]:48820 "EHLO
	mail-09.primus.ca" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752954AbZBWRvs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Feb 2009 12:51:48 -0500
From: Matthew Wilcox <matthew@wil.cx>
To: linux-pci@vger.kernel.org, jbarnes@virtuousgeek.org,
       linux-kernel@vger.kernel.org
Cc: Matthew Wilcox <willy@linux.intel.com>
Subject: [PATCH 5/6] PCI MSI: Refactor interrupt masking code
Date: Mon, 23 Feb 2009 12:28:01 -0500
Message-Id: <1235410082-5016-6-git-send-email-matthew@wil.cx>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <1235410082-5016-1-git-send-email-matthew@wil.cx>
References: <1235410082-5016-1-git-send-email-matthew@wil.cx>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Matthew Wilcox <willy@linux.intel.com>

Since most of the callers already know whether they have an MSI or
an MSI-X capability, split msi_set_mask_bits() into msi_mask_irq()
and msix_mask_irq().  The only callers which don't (mask_msi_irq()
and unmask_msi_irq()) can share code in msi_set_mask_bit().  This then
becomes the only caller of msix_flush_writes(), so we can inline it.
The flushing read can be to any address that belongs to the device,
so we can eliminate the calculation too.

We can also get rid of maskbits_mask from struct msi_desc and simply
recalculate it on the rare occasion that we need it.  The single-bit
'masked' element is replaced by a copy of the 32-bit 'masked' register,
so this patch does not affect the size of msi_desc.

Signed-off-by: Matthew Wilcox <willy@linux.intel.com>
---
 drivers/pci/msi.c   |  157 +++++++++++++++++++++++++--------------------------
 include/linux/msi.h |    5 +-
 2 files changed, 79 insertions(+), 83 deletions(-)

diff --git a/drivers/pci/msi.c b/drivers/pci/msi.c
index fcde04d..41f18cb 100644
--- a/drivers/pci/msi.c
+++ b/drivers/pci/msi.c
@@ -105,17 +105,14 @@ static inline __attribute_const__ u32 msi_mask(unsigned x)
 	return (1 << (1 << x)) - 1;
 }
 
-static void msix_flush_writes(struct irq_desc *desc)
+static inline __attribute_const__ u32 msi_capable_mask(u16 control)
 {
-	struct msi_desc *entry;
+	return msi_mask((control >> 1) & 7);
+}
 
-	entry = get_irq_desc_msi(desc);
-	BUG_ON(!entry);
-	if (entry->msi_attrib.is_msix) {
-		int offset = entry->msi_attrib.entry_nr * PCI_MSIX_ENTRY_SIZE +
-			PCI_MSIX_ENTRY_VECTOR_CTRL_OFFSET;
-		readl(entry->mask_base + offset);
-	}
+static inline __attribute_const__ u32 msi_enabled_mask(u16 control)
+{
+	return msi_mask((control >> 4) & 7);
 }
 
 /*
@@ -127,34 +124,62 @@ static void msix_flush_writes(struct irq_desc *desc)
  * Returns 1 if it succeeded in masking the interrupt and 0 if the device
  * doesn't support MSI masking.
  */
-static int msi_set_mask_bits(struct irq_desc *desc, u32 mask, u32 flag)
+static int msi_mask_irq(struct msi_desc *desc, u32 mask, u32 flag)
 {
-	struct msi_desc *entry;
+	u32 mask_bits = desc->masked;
 
-	entry = get_irq_desc_msi(desc);
-	BUG_ON(!entry);
-	if (entry->msi_attrib.is_msix) {
-		int offset = entry->msi_attrib.entry_nr * PCI_MSIX_ENTRY_SIZE +
-			PCI_MSIX_ENTRY_VECTOR_CTRL_OFFSET;
-		writel(flag, entry->mask_base + offset);
-		readl(entry->mask_base + offset);
-	} else {
-		int pos;
-		u32 mask_bits;
+	if (!desc->msi_attrib.maskbit)
+		return 0;
 
-		if (!entry->msi_attrib.maskbit)
-			return 0;
+	mask_bits &= ~mask;
+	mask_bits |= flag;
+	pci_write_config_dword(desc->dev, desc->mask_pos, mask_bits);
+	desc->masked = mask_bits;
 
-		pos = entry->mask_pos;
-		pci_read_config_dword(entry->dev, pos, &mask_bits);
-		mask_bits &= ~mask;
-		mask_bits |= flag & mask;
-		pci_write_config_dword(entry->dev, pos, mask_bits);
-	}
-	entry->msi_attrib.masked = !!flag;
 	return 1;
 }
 
+/*
+ * This internal function does not flush PCI writes to the device.
+ * All users must ensure that they read from the device before either
+ * assuming that the device state is up to date, or returning out of this
+ * file.  This saves a few milliseconds when initialising devices with lots
+ * of MSI-X interrupts.
+ */
+static void msix_mask_irq(struct msi_desc *desc, u32 flag)
+{
+	u32 mask_bits = desc->masked;
+	unsigned offset = desc->msi_attrib.entry_nr * PCI_MSIX_ENTRY_SIZE +
+					PCI_MSIX_ENTRY_VECTOR_CTRL_OFFSET;
+	mask_bits &= ~1;
+	mask_bits |= flag;
+	writel(mask_bits, desc->mask_base + offset);
+	desc->masked = mask_bits;
+}
+
+static int msi_set_mask_bit(unsigned irq, u32 flag)
+{
+	struct msi_desc *desc = get_irq_msi(irq);
+
+	if (desc->msi_attrib.is_msix) {
+		msix_mask_irq(desc, flag);
+		readl(desc->mask_base);		/* Flush write to device */
+		return 1;
+	} else {
+		return msi_mask_irq(desc, 1, flag);
+	}
+}
+
+void mask_msi_irq(unsigned int irq)
+{
+	msi_set_mask_bit(irq, 1);
+}
+
+void unmask_msi_irq(unsigned int irq)
+{
+	msi_set_mask_bit(irq, 0);
+}
+
 void read_msi_msg_desc(struct irq_desc *desc, struct msi_msg *msg)
 {
 	struct msi_desc *entry = get_irq_desc_msi(desc);
@@ -230,22 +255,6 @@ void write_msi_msg(unsigned int irq, struct msi_msg *msg)
 	write_msi_msg_desc(desc, msg);
 }
 
-void mask_msi_irq(unsigned int irq)
-{
-	struct irq_desc *desc = irq_to_desc(irq);
-
-	msi_set_mask_bits(desc, 1, 1);
-	msix_flush_writes(desc);
-}
-
-void unmask_msi_irq(unsigned int irq)
-{
-	struct irq_desc *desc = irq_to_desc(irq);
-
-	msi_set_mask_bits(desc, 1, 0);
-	msix_flush_writes(desc);
-}
-
 static int msi_free_irqs(struct pci_dev* dev);
 
 static struct msi_desc *alloc_msi_entry(struct pci_dev *dev)
@@ -281,13 +290,9 @@ static void __pci_restore_msi_state(struct pci_dev *dev)
 	pci_intx_for_msi(dev, 0);
 	msi_set_enable(dev, 0);
 	write_msi_msg(dev->irq, &entry->msg);
-	if (entry->msi_attrib.maskbit) {
-		struct irq_desc *desc = irq_to_desc(dev->irq);
-		msi_set_mask_bits(desc, entry->msi_attrib.maskbits_mask,
-				  entry->msi_attrib.masked);
-	}
 
 	pci_read_config_word(dev, pos + PCI_MSI_FLAGS, &control);
+	msi_mask_irq(entry, msi_capable_mask(control), entry->masked);
 	control &= ~PCI_MSI_FLAGS_QSIZE;
 	control |= PCI_MSI_FLAGS_ENABLE;
 	pci_write_config_word(dev, pos + PCI_MSI_FLAGS, control);
@@ -307,9 +312,8 @@ static void __pci_restore_msix_state(struct pci_dev *dev)
 	msix_set_enable(dev, 0);
 
 	list_for_each_entry(entry, &dev->msi_list, list) {
-		struct irq_desc *desc = irq_to_desc(entry->irq);
 		write_msi_msg(entry->irq, &entry->msg);
-		msi_set_mask_bits(desc, 1, entry->msi_attrib.masked);
+		msix_mask_irq(entry, entry->masked);
 	}
 
 	BUG_ON(list_empty(&dev->msi_list));
@@ -342,6 +346,7 @@ static int msi_capability_init(struct pci_dev *dev)
 	struct msi_desc *entry;
 	int pos, ret;
 	u16 control;
+	unsigned mask;
 
 	msi_set_enable(dev, 0);	/* Ensure msi is disabled as I set it up */
 
@@ -356,21 +361,15 @@ static int msi_capability_init(struct pci_dev *dev)
 	entry->msi_attrib.is_64 = is_64bit_address(control);
 	entry->msi_attrib.entry_nr = 0;
 	entry->msi_attrib.maskbit = is_mask_bit_support(control);
-	entry->msi_attrib.masked = 1;
 	entry->msi_attrib.default_irq = dev->irq;	/* Save IOAPIC IRQ */
 	entry->msi_attrib.pos = pos;
-	if (entry->msi_attrib.maskbit) {
-		unsigned int base, maskbits, temp;
-
-		base = msi_mask_bits_reg(pos, entry->msi_attrib.is_64);
-		entry->mask_pos = base;
-		/* All MSIs are unmasked by default, Mask them all */
-		pci_read_config_dword(dev, base, &maskbits);
-		temp = msi_mask((control & PCI_MSI_FLAGS_QMASK) >> 1);
-		maskbits |= temp;
-		pci_write_config_dword(dev, base, maskbits);
-		entry->msi_attrib.maskbits_mask = temp;
-	}
+
+	entry->mask_pos = msi_mask_bits_reg(pos, entry->msi_attrib.is_64);
+	/* All MSIs are unmasked by default, Mask them all */
+	pci_read_config_dword(dev, entry->mask_pos, &entry->masked);
+	mask = msi_capable_mask(control);
+	msi_mask_irq(entry, mask, mask);
+
 	list_add_tail(&entry->list, &dev->msi_list);
 
 	/* Configure MSI capability structure */
@@ -435,11 +434,12 @@ static int msix_capability_init(struct pci_dev *dev,
 		entry->msi_attrib.is_msix = 1;
 		entry->msi_attrib.is_64 = 1;
 		entry->msi_attrib.entry_nr = j;
-		entry->msi_attrib.maskbit = 1;
-		entry->msi_attrib.masked = 1;
 		entry->msi_attrib.default_irq = dev->irq;
 		entry->msi_attrib.pos = pos;
 		entry->mask_base = base;
+		entry->masked = readl(base + j * PCI_MSIX_ENTRY_SIZE +
+					PCI_MSIX_ENTRY_VECTOR_CTRL_OFFSET);
+		msix_mask_irq(entry, 1);
 
 		list_add_tail(&entry->list, &dev->msi_list);
 	}
@@ -556,9 +556,11 @@ int pci_enable_msi(struct pci_dev* dev)
 }
 EXPORT_SYMBOL(pci_enable_msi);
 
-void pci_msi_shutdown(struct pci_dev* dev)
+void pci_msi_shutdown(struct pci_dev *dev)
 {
-	struct msi_desc *entry;
+	struct msi_desc *desc;
+	u32 mask;
+	u16 ctrl;
 
 	if (!pci_msi_enable || !dev || !dev->msi_enabled)
 		return;
@@ -568,18 +570,13 @@ void pci_msi_shutdown(struct pci_dev* dev)
 	dev->msi_enabled = 0;
 
 	BUG_ON(list_empty(&dev->msi_list));
-	entry = list_entry(dev->msi_list.next, struct msi_desc, list);
-	/* Return the the pci reset with msi irqs unmasked */
-	if (entry->msi_attrib.maskbit) {
-		u32 mask = entry->msi_attrib.maskbits_mask;
-		struct irq_desc *desc = irq_to_desc(dev->irq);
-		msi_set_mask_bits(desc, mask, ~mask);
-	}
-	if (entry->msi_attrib.is_msix)
-		return;
+	desc = list_first_entry(&dev->msi_list, struct msi_desc, list);
+	pci_read_config_word(dev, desc->msi_attrib.pos + PCI_MSI_FLAGS, &ctrl);
+	mask = msi_capable_mask(ctrl);
+	msi_mask_irq(desc, mask, ~mask);
 
 	/* Restore dev->irq to its default pin-assertion irq */
-	dev->irq = entry->msi_attrib.default_irq;
+	dev->irq = desc->msi_attrib.default_irq;
 }
 
 void pci_disable_msi(struct pci_dev* dev)
diff --git a/include/linux/msi.h b/include/linux/msi.h
index 5025ca4..37c1bbe 100644
--- a/include/linux/msi.h
+++ b/include/linux/msi.h
@@ -22,14 +22,13 @@ struct msi_desc {
 	struct {
 		__u8	is_msix	: 1;
 		__u8	maskbit	: 1; 	/* mask-pending bit supported ?   */
-		__u8	masked	: 1;
 		__u8	is_64	: 1;	/* Address size: 0=32bit 1=64bit  */
 		__u8	pos;	 	/* Location of the msi capability */
 		__u16	entry_nr;    	/* specific enabled entry 	  */
-		__u32	maskbits_mask;  /* mask bits mask */
 		unsigned default_irq;	/* default pre-assigned irq	  */
-	}msi_attrib;
+	} msi_attrib;
 
+	u32 masked;			/* mask bits */
 	unsigned int irq;
 	struct list_head list;
 
-- 
1.5.6.5

