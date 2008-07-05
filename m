Return-Path: <linux-kernel-owner+w=401wt.eu-S1752941AbYGEOvq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752941AbYGEOvq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Jul 2008 10:51:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751170AbYGEOvi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 Jul 2008 10:51:38 -0400
Received: from mail.tor.primus.ca ([216.254.136.21]:52878 "EHLO
	mail-07.primus.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750722AbYGEOvh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Jul 2008 10:51:37 -0400
From: Matthew Wilcox <matthew@wil.cx>
To: linux-pci@vger.kernel.org
Cc: kaneshige.kenji@jp.fujitsu.com, mingo@elte.hu, tglx@linutronix.de,
       davem@davemloft.net, dan.j.williams@intel.com,
       Martine.Silbermann@hp.com, benh@kernel.crashing.org,
       michael@ellerman.id.au, linux-kernel@vger.kernel.org,
       Matthew Wilcox <matthew@wil.cx>, Matthew Wilcox <willy@linux.intel.com>
Subject: [PATCH 1/4] PCI MSI: Store the number of messages in the msi_desc
Date: Sat,  5 Jul 2008 09:34:12 -0400
Message-Id: <1215264855-4372-1-git-send-email-matthew@wil.cx>
X-Mailer: git-send-email 1.5.5.4
In-Reply-To: <20080705132728.GO14894@parisc-linux.org>
References: <20080705132728.GO14894@parisc-linux.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This first part simply changes the msi_attrib data structure to store
how many vectors have been allocated.  In order to do this, I shrink the
'type' from 5 bits to 2 and rename it to _type to catch any unsuspecting
users.

Signed-off-by: Matthew Wilcox <willy@linux.intel.com>
---
 drivers/pci/msi.c   |   41 ++++++++++++++++++++++++-----------------
 drivers/pci/msi.h   |    4 ----
 include/linux/msi.h |    6 +++++-
 3 files changed, 29 insertions(+), 22 deletions(-)

diff --git a/drivers/pci/msi.c b/drivers/pci/msi.c
index 8c61304..92992a8 100644
--- a/drivers/pci/msi.c
+++ b/drivers/pci/msi.c
@@ -106,11 +106,11 @@ static void msix_flush_writes(unsigned int irq)
 
 	entry = get_irq_msi(irq);
 	BUG_ON(!entry || !entry->dev);
-	switch (entry->msi_attrib.type) {
-	case PCI_CAP_ID_MSI:
+	switch (entry->msi_attrib._type) {
+	case MSI_ATTRIB:
 		/* nothing to do */
 		break;
-	case PCI_CAP_ID_MSIX:
+	case MSIX_ATTRIB:
 	{
 		int offset = entry->msi_attrib.entry_nr * PCI_MSIX_ENTRY_SIZE +
 			PCI_MSIX_ENTRY_VECTOR_CTRL_OFFSET;
@@ -129,8 +129,8 @@ static void msi_set_mask_bits(unsigned int irq, u32 mask, u32 flag)
 
 	entry = get_irq_msi(irq);
 	BUG_ON(!entry || !entry->dev);
-	switch (entry->msi_attrib.type) {
-	case PCI_CAP_ID_MSI:
+	switch (entry->msi_attrib._type) {
+	case MSI_ATTRIB:
 		if (entry->msi_attrib.maskbit) {
 			int pos;
 			u32 mask_bits;
@@ -144,7 +144,7 @@ static void msi_set_mask_bits(unsigned int irq, u32 mask, u32 flag)
 			msi_set_enable(entry->dev, !flag);
 		}
 		break;
-	case PCI_CAP_ID_MSIX:
+	case MSIX_ATTRIB:
 	{
 		int offset = entry->msi_attrib.entry_nr * PCI_MSIX_ENTRY_SIZE +
 			PCI_MSIX_ENTRY_VECTOR_CTRL_OFFSET;
@@ -162,8 +162,8 @@ static void msi_set_mask_bits(unsigned int irq, u32 mask, u32 flag)
 void read_msi_msg(unsigned int irq, struct msi_msg *msg)
 {
 	struct msi_desc *entry = get_irq_msi(irq);
-	switch(entry->msi_attrib.type) {
-	case PCI_CAP_ID_MSI:
+	switch(entry->msi_attrib._type) {
+	case MSI_ATTRIB:
 	{
 		struct pci_dev *dev = entry->dev;
 		int pos = entry->msi_attrib.pos;
@@ -182,7 +182,7 @@ void read_msi_msg(unsigned int irq, struct msi_msg *msg)
 		msg->data = data;
 		break;
 	}
-	case PCI_CAP_ID_MSIX:
+	case MSIX_ATTRIB:
 	{
 		void __iomem *base;
 		base = entry->mask_base +
@@ -201,11 +201,17 @@ void read_msi_msg(unsigned int irq, struct msi_msg *msg)
 void write_msi_msg(unsigned int irq, struct msi_msg *msg)
 {
 	struct msi_desc *entry = get_irq_msi(irq);
-	switch (entry->msi_attrib.type) {
-	case PCI_CAP_ID_MSI:
+	switch (entry->msi_attrib._type) {
+	case MSI_ATTRIB:
 	{
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
@@ -220,7 +226,7 @@ void write_msi_msg(unsigned int irq, struct msi_msg *msg)
 		}
 		break;
 	}
-	case PCI_CAP_ID_MSIX:
+	case MSIX_ATTRIB:
 	{
 		void __iomem *base;
 		base = entry->mask_base +
@@ -359,7 +365,7 @@ static int msi_capability_init(struct pci_dev *dev)
 	if (!entry)
 		return -ENOMEM;
 
-	entry->msi_attrib.type = PCI_CAP_ID_MSI;
+	entry->msi_attrib._type = MSI_ATTRIB;
 	entry->msi_attrib.is_64 = is_64bit_address(control);
 	entry->msi_attrib.entry_nr = 0;
 	entry->msi_attrib.maskbit = is_mask_bit_support(control);
@@ -446,7 +452,7 @@ static int msix_capability_init(struct pci_dev *dev,
 			break;
 
  		j = entries[i].entry;
-		entry->msi_attrib.type = PCI_CAP_ID_MSIX;
+		entry->msi_attrib._type = MSIX_ATTRIB;
 		entry->msi_attrib.is_64 = 1;
 		entry->msi_attrib.entry_nr = j;
 		entry->msi_attrib.maskbit = 1;
@@ -589,12 +595,13 @@ void pci_msi_shutdown(struct pci_dev* dev)
 		u32 mask = entry->msi_attrib.maskbits_mask;
 		msi_set_mask_bits(dev->irq, mask, ~mask);
 	}
-	if (!entry->dev || entry->msi_attrib.type != PCI_CAP_ID_MSI)
+	if (!entry->dev || entry->msi_attrib._type != MSI_ATTRIB)
 		return;
 
 	/* Restore dev->irq to its default pin-assertion irq */
 	dev->irq = entry->msi_attrib.default_irq;
 }
+
 void pci_disable_msi(struct pci_dev* dev)
 {
 	struct msi_desc *entry;
@@ -605,7 +612,7 @@ void pci_disable_msi(struct pci_dev* dev)
 	pci_msi_shutdown(dev);
 
 	entry = list_entry(dev->msi_list.next, struct msi_desc, list);
-	if (!entry->dev || entry->msi_attrib.type != PCI_CAP_ID_MSI)
+	if (!entry->dev || entry->msi_attrib._type != MSI_ATTRIB)
 		return;
 
 	msi_free_irqs(dev);
@@ -624,7 +631,7 @@ static int msi_free_irqs(struct pci_dev* dev)
 	arch_teardown_msi_irqs(dev);
 
 	list_for_each_entry_safe(entry, tmp, &dev->msi_list, list) {
-		if (entry->msi_attrib.type == PCI_CAP_ID_MSIX) {
+		if (entry->msi_attrib._type == MSIX_ATTRIB) {
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
index 8f29392..d322148 100644
--- a/include/linux/msi.h
+++ b/include/linux/msi.h
@@ -15,9 +15,13 @@ extern void unmask_msi_irq(unsigned int irq);
 extern void read_msi_msg(unsigned int irq, struct msi_msg *msg);
 extern void write_msi_msg(unsigned int irq, struct msi_msg *msg);
 
+#define MSI_ATTRIB	1
+#define MSIX_ATTRIB	2
+
 struct msi_desc {
 	struct {
-		__u8	type	: 5; 	/* {0: unused, 5h:MSI, 11h:MSI-X} */
+		__u8	_type	: 2; 	/* {0: unused, 1:MSI, 2:MSI-X} */
+		__u8	multiple: 3;	/* log2 number of messages */
 		__u8	maskbit	: 1; 	/* mask-pending bit supported ?   */
 		__u8	masked	: 1;
 		__u8	is_64	: 1;	/* Address size: 0=32bit 1=64bit  */
-- 
1.5.5.4

