Return-Path: <linux-kernel-owner+w=401wt.eu-S1754872AbYGGMEd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754872AbYGGMEd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2008 08:04:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753531AbYGGMEZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Jul 2008 08:04:25 -0400
Received: from palinux.external.hp.com ([192.25.206.14]:40155 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753066AbYGGMEX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2008 08:04:23 -0400
Date: Mon, 7 Jul 2008 06:04:18 -0600
From: Matthew Wilcox <matthew@wil.cx>
To: Michael Ellerman <michael@ellerman.id.au>
Cc: linux-pci@vger.kernel.org, kaneshige.kenji@jp.fujitsu.com, mingo@elte.hu,
       tglx@linutronix.de, davem@davemloft.net, dan.j.williams@intel.com,
       Martine.Silbermann@hp.com, benh@kernel.crashing.org,
       linux-kernel@vger.kernel.org, Matthew Wilcox <willy@linux.intel.com>
Subject: Re: [PATCH 1/4] PCI MSI: Store the number of messages in the msi_desc
Message-ID: <20080707120418.GZ14894@parisc-linux.org>
References: <20080705132728.GO14894@parisc-linux.org> <1215264855-4372-1-git-send-email-matthew@wil.cx> <1215396324.19157.14.camel@localhost> <20080707024125.GU14894@parisc-linux.org> <1215402512.9862.16.camel@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1215402512.9862.16.camel@localhost>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 07, 2008 at 01:48:32PM +1000, Michael Ellerman wrote:
> Yeah seriously :)  The _ is part of it, but MSI_ATTRIB is uglier than
> PCI_CAP_ID_MSI exactly because it's not PCI_CAP_ID_MSI, which exists and
> is well defined and is used in the rest of the code.

Here's an improvement over both the status quo and my patch -- simply
use a single bit called is_msix.

> I didn't say it was a queue, but a Q ;)  But I agree it's not a good
> name, the spec calls it "multiple message enable", nvec would match the
> existing code best, or log_nvec.

I don't see what's wrong with 'multiple'.  log_nvec is clunky, and
'multiple' works well as a boolean (since 0 means 1 interrupt).

> > > If you're worried about bloating msi_desc, there's several fields in
> > > there that are per-device not per-desc, so we could do another patch to
> > > move them into pci_dev or something hanging off it, eg.
> > > pci_dev->msi_info rather than storing them in every desc.

Ouch.  I just used pahole and discovered we were using 72 bytes on
64-bit.  A swift rearrangement of a u16 gets us back down to 64.

Here's the replacement patch:

diff --git a/drivers/pci/msi.c b/drivers/pci/msi.c
index 8c61304..8f7e483 100644
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
@@ -180,32 +167,31 @@ void read_msi_msg(unsigned int irq, struct msi_msg *msg)
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
+		u16 msgctl;
+
+		pci_read_config_word(dev, msi_control_reg(pos), &msgctl);
+		msgctl &= ~PCI_MSI_FLAGS_QSIZE;
+		msgctl |= entry->msi_attrib.multiple << 4;
+		pci_write_config_word(dev, msi_control_reg(pos), msgctl);
 
 		pci_write_config_dword(dev, msi_lower_address_reg(pos),
 					msg->address_lo);
@@ -218,23 +204,6 @@ void write_msi_msg(unsigned int irq, struct msi_msg *msg)
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
@@ -359,7 +328,7 @@ static int msi_capability_init(struct pci_dev *dev)
 	if (!entry)
 		return -ENOMEM;
 
-	entry->msi_attrib.type = PCI_CAP_ID_MSI;
+	entry->msi_attrib.is_msix = 0;
 	entry->msi_attrib.is_64 = is_64bit_address(control);
 	entry->msi_attrib.entry_nr = 0;
 	entry->msi_attrib.maskbit = is_mask_bit_support(control);
@@ -446,7 +415,7 @@ static int msix_capability_init(struct pci_dev *dev,
 			break;
 
  		j = entries[i].entry;
-		entry->msi_attrib.type = PCI_CAP_ID_MSIX;
+		entry->msi_attrib.is_msix = 1;
 		entry->msi_attrib.is_64 = 1;
 		entry->msi_attrib.entry_nr = j;
 		entry->msi_attrib.maskbit = 1;
@@ -589,12 +558,13 @@ void pci_msi_shutdown(struct pci_dev* dev)
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
@@ -605,7 +575,7 @@ void pci_disable_msi(struct pci_dev* dev)
 	pci_msi_shutdown(dev);
 
 	entry = list_entry(dev->msi_list.next, struct msi_desc, list);
-	if (!entry->dev || entry->msi_attrib.type != PCI_CAP_ID_MSI)
+	if (!entry->dev || entry->msi_attrib.is_msix)
 		return;
 
 	msi_free_irqs(dev);
@@ -624,7 +594,7 @@ static int msi_free_irqs(struct pci_dev* dev)
 	arch_teardown_msi_irqs(dev);
 
 	list_for_each_entry_safe(entry, tmp, &dev->msi_list, list) {
-		if (entry->msi_attrib.type == PCI_CAP_ID_MSIX) {
+		if (entry->msi_attrib.is_msix) {
 			writel(1, entry->mask_base + entry->msi_attrib.entry_nr
 				  * PCI_MSIX_ENTRY_SIZE
 				  + PCI_MSIX_ENTRY_VECTOR_CTRL_OFFSET);
diff --git a/drivers/pci/msi.h b/drivers/pci/msi.h
index 3898f52..b72e0bd 100644
--- a/drivers/pci/msi.h
+++ b/drivers/pci/msi.h
@@ -22,12 +22,8 @@
 #define msi_disable(control)		control &= ~PCI_MSI_FLAGS_ENABLE
 #define multi_msi_capable(control) \
 	(1 << ((control & PCI_MSI_FLAGS_QMASK) >> 1))
-#define multi_msi_enable(control, num) \
-	control |= (((num >> 1) << 4) & PCI_MSI_FLAGS_QSIZE);
 #define is_64bit_address(control)	(!!(control & PCI_MSI_FLAGS_64BIT))
 #define is_mask_bit_support(control)	(!!(control & PCI_MSI_FLAGS_MASKBIT))
-#define msi_enable(control, num) multi_msi_enable(control, num); \
-	control |= PCI_MSI_FLAGS_ENABLE
 
 #define msix_table_offset_reg(base)	(base + 0x04)
 #define msix_pba_offset_reg(base)	(base + 0x08)
diff --git a/include/linux/msi.h b/include/linux/msi.h
index 8f29392..70fcebc 100644
--- a/include/linux/msi.h
+++ b/include/linux/msi.h
@@ -17,13 +17,14 @@ extern void write_msi_msg(unsigned int irq, struct msi_msg *msg);
 
 struct msi_desc {
 	struct {
-		__u8	type	: 5; 	/* {0: unused, 5h:MSI, 11h:MSI-X} */
+		__u8	is_msix	: 1;
+		__u8	multiple: 3;	/* log2 number of messages */
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
Intel are signing my paycheques ... these opinions are still mine
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
