Return-Path: <linux-kernel-owner+w=401wt.eu-S1754954AbZBWR6q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754954AbZBWR6q (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Feb 2009 12:58:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752298AbZBWR6h
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Feb 2009 12:58:37 -0500
Received: from smtp-noauth7.primus.ca ([216.254.180.38]:52637 "EHLO
	mail-08.primus.ca" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752081AbZBWR6g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Feb 2009 12:58:36 -0500
From: Matthew Wilcox <matthew@wil.cx>
To: linux-pci@vger.kernel.org, jbarnes@virtuousgeek.org,
       linux-kernel@vger.kernel.org
Cc: Matthew Wilcox <willy@linux.intel.com>
Subject: [PATCH 6/6] PCI MSI: Add support for multiple MSI
Date: Mon, 23 Feb 2009 12:28:02 -0500
Message-Id: <1235410082-5016-7-git-send-email-matthew@wil.cx>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <1235410082-5016-1-git-send-email-matthew@wil.cx>
References: <1235410082-5016-1-git-send-email-matthew@wil.cx>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Matthew Wilcox <willy@linux.intel.com>

Add the new API pci_enable_msi_block() to allow drivers to
request multiple MSI and reimplement pci_enable_msi in terms of
pci_enable_msi_block.  Ensure that the architecture back ends don't
have to know about multiple MSI.

Signed-off-by: Matthew Wilcox <willy@linux.intel.com>
---
 Documentation/PCI/MSI-HOWTO.txt |   45 +++++++++++++++++---
 arch/powerpc/kernel/msi.c       |    4 ++
 arch/x86/kernel/io_apic.c       |    4 ++
 drivers/pci/msi.c               |   91 +++++++++++++++++++++++++++-----------
 drivers/pci/msi.h               |    6 ---
 include/linux/msi.h             |    1 +
 include/linux/pci.h             |    6 ++-
 7 files changed, 116 insertions(+), 41 deletions(-)

diff --git a/Documentation/PCI/MSI-HOWTO.txt b/Documentation/PCI/MSI-HOWTO.txt
index f1b9f09..18a1e20 100644
--- a/Documentation/PCI/MSI-HOWTO.txt
+++ b/Documentation/PCI/MSI-HOWTO.txt
@@ -94,15 +94,48 @@ This function should be called before the driver calls request_irq()
 since enabling MSIs disables the pin-based IRQ and the driver will not
 receive interrupts on the old interrupt.
 
-4.2.2 pci_disable_msi
+4.2.2 pci_enable_msi_block
+
+int pci_enable_msi_block(struct pci_dev *dev, int count)
+
+This variation on the above call allows a device driver to request multiple
+MSIs.  The MSI specification only allows interrupts to be allocated in
+powers of two, up to a maximum of 2^5 (32).
+
+If this function returns 0, it has succeeded in allocating at least as many
+interrupts as the driver requested (it may have allocated more in order
+to satisfy the power-of-two requirement).  In this case, the function
+enables MSI on this device and updates dev->irq to be the lowest of
+the new interrupts assigned to it.  The other interrupts assigned to
+the device are in the range dev->irq to dev->irq + count - 1.
+
+If this function returns a negative number, it indicates an error and
+the driver should not attempt to request any more MSI interrupts for
+this device.  If this function returns a positive number, it will be
+less than 'count' and indicate the number of interrupts that could have
+been allocated.  In neither case will the irq value have been
+updated, nor will the device have been switched into MSI mode.
+
+The device driver must decide what action to take if
+pci_enable_msi_block() returns a value less than the number asked for.
+Some devices can make use of fewer interrupts than the maximum they
+request; in this case the driver should call pci_enable_msi_block()
+again.  Note that it is not guaranteed to succeed, even when the
+'count' has been reduced to the value returned from a previous call to
+pci_enable_msi_block().  This is because there are multiple constraints
+on the number of vectors that can be allocated; pci_enable_msi_block()
+will return as soon as it finds any constraint that doesn't allow the
+call to succeed.
+
+4.2.3 pci_disable_msi
 
 void pci_disable_msi(struct pci_dev *dev)
 
-This function should be used to undo the effect of pci_enable_msi().
-Calling it restores dev->irq to the pin-based interrupt number and frees
-the previously allocated message signaled interrupt(s).  The interrupt
-may subsequently be assigned to another device, so drivers should not
-cache the value of dev->irq.
+This function should be used to undo the effect of pci_enable_msi() or
+pci_enable_msi_block().  Calling it restores dev->irq to the pin-based
+interrupt number and frees the previously allocated message signaled
+interrupt(s).  The interrupt may subsequently be assigned to another
+device, so drivers should not cache the value of dev->irq.
 
 A device driver must always call free_irq() on the interrupt(s)
 for which it has called request_irq() before calling this function.
diff --git a/arch/powerpc/kernel/msi.c b/arch/powerpc/kernel/msi.c
index 3bb7d3d..0c16e2a 100644
--- a/arch/powerpc/kernel/msi.c
+++ b/arch/powerpc/kernel/msi.c
@@ -19,6 +19,10 @@ int arch_msi_check_device(struct pci_dev* dev, int nvec, int type)
 		return -ENOSYS;
 	}
 
+	/* PowerPC doesn't support multiple MSI yet */
+	if (type == PCI_CAP_ID_MSI && nvec > 1)
+		return 1;
+
 	if (ppc_md.msi_check_device) {
 		pr_debug("msi: Using platform check routine.\n");
 		return ppc_md.msi_check_device(dev, nvec, type);
diff --git a/arch/x86/kernel/io_apic.c b/arch/x86/kernel/io_apic.c
index bc7ac4d..a09549a 100644
--- a/arch/x86/kernel/io_apic.c
+++ b/arch/x86/kernel/io_apic.c
@@ -3510,6 +3510,10 @@ int arch_setup_msi_irqs(struct pci_dev *dev, int nvec, int type)
 	int index = 0;
 #endif
 
+	/* x86 doesn't support multiple MSI yet */
+	if (type == PCI_CAP_ID_MSI && nvec > 1)
+		return 1;
+
 	irq_want = nr_irqs_gsi;
 	sub_handle = 0;
 	list_for_each_entry(msidesc, &dev->msi_list, list) {
diff --git a/drivers/pci/msi.c b/drivers/pci/msi.c
index 41f18cb..bd3c7e8 100644
--- a/drivers/pci/msi.c
+++ b/drivers/pci/msi.c
@@ -40,6 +40,13 @@ int arch_setup_msi_irqs(struct pci_dev *dev, int nvec, int type)
 	struct msi_desc *entry;
 	int ret;
 
+	/*
+	 * If an architecture wants to support multiple MSI, it needs to
+	 * override arch_setup_msi_irqs()
+	 */
+	if (type == PCI_CAP_ID_MSI && nvec > 1)
+		return 1;
+
 	list_for_each_entry(entry, &dev->msi_list, list) {
 		ret = arch_setup_msi_irq(dev, entry);
 		if (ret < 0)
@@ -58,8 +65,12 @@ void arch_teardown_msi_irqs(struct pci_dev *dev)
 	struct msi_desc *entry;
 
 	list_for_each_entry(entry, &dev->msi_list, list) {
-		if (entry->irq != 0)
-			arch_teardown_msi_irq(entry->irq);
+		int i, nvec;
+		if (entry->irq == 0)
+			continue;
+		nvec = 1 << entry->msi_attrib.multiple;
+		for (i = 0; i < nvec; i++)
+			arch_teardown_msi_irq(entry->irq + i);
 	}
 }
 #endif
@@ -166,7 +177,8 @@ static int msi_set_mask_bit(unsigned irq, u32 flag)
 		readl(desc->mask_base);		/* Flush write to device */
 		return 1;
 	} else {
-		return msi_mask_irq(desc, 1, flag);
+		unsigned offset = irq - desc->dev->irq;
+		return msi_mask_irq(desc, 1 << offset, flag << offset);
 	}
 }
 
@@ -232,6 +244,12 @@ void write_msi_msg_desc(struct irq_desc *desc, struct msi_msg *msg)
 	} else {
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
@@ -294,7 +312,7 @@ static void __pci_restore_msi_state(struct pci_dev *dev)
 	pci_read_config_word(dev, pos + PCI_MSI_FLAGS, &control);
 	msi_mask_irq(entry, msi_capable_mask(control), entry->masked);
 	control &= ~PCI_MSI_FLAGS_QSIZE;
-	control |= PCI_MSI_FLAGS_ENABLE;
+	control |= (entry->msi_attrib.multiple << 4) | PCI_MSI_FLAGS_ENABLE;
 	pci_write_config_word(dev, pos + PCI_MSI_FLAGS, control);
 }
 
@@ -335,13 +353,15 @@ EXPORT_SYMBOL_GPL(pci_restore_msi_state);
 /**
  * msi_capability_init - configure device's MSI capability structure
  * @dev: pointer to the pci_dev data structure of MSI device function
+ * @nvec: number of interrupts to allocate
  *
- * Setup the MSI capability structure of device function with a single
- * MSI irq, regardless of device function is capable of handling
- * multiple messages. A return of zero indicates the successful setup
- * of an entry zero with the new MSI irq or non-zero for otherwise.
- **/
-static int msi_capability_init(struct pci_dev *dev)
+ * Setup the MSI capability structure of the device with the requested
+ * number of interrupts.  A return value of zero indicates the successful
+ * setup of an entry with the new MSI irq.  A negative return value indicates
+ * an error, and a positive return value indicates the number of interrupts
+ * which could have been allocated.
+ */
+static int msi_capability_init(struct pci_dev *dev, int nvec)
 {
 	struct msi_desc *entry;
 	int pos, ret;
@@ -373,7 +393,7 @@ static int msi_capability_init(struct pci_dev *dev)
 	list_add_tail(&entry->list, &dev->msi_list);
 
 	/* Configure MSI capability structure */
-	ret = arch_setup_msi_irqs(dev, 1, PCI_CAP_ID_MSI);
+	ret = arch_setup_msi_irqs(dev, nvec, PCI_CAP_ID_MSI);
 	if (ret) {
 		msi_free_irqs(dev);
 		return ret;
@@ -526,35 +546,48 @@ static int pci_msi_check_device(struct pci_dev* dev, int nvec, int type)
 }
 
 /**
- * pci_enable_msi - configure device's MSI capability structure
- * @dev: pointer to the pci_dev data structure of MSI device function
+ * pci_enable_msi_block - configure device's MSI capability structure
+ * @dev: device to configure
+ * @nvec: number of interrupts to configure
  *
- * Setup the MSI capability structure of device function with
- * a single MSI irq upon its software driver call to request for
- * MSI mode enabled on its hardware device function. A return of zero
- * indicates the successful setup of an entry zero with the new MSI
- * irq or non-zero for otherwise.
- **/
-int pci_enable_msi(struct pci_dev* dev)
+ * Allocate IRQs for a device with the MSI capability.
+ * This function returns a negative errno if an error occurs.  If it
+ * is unable to allocate the number of interrupts requested, it returns
+ * the number of interrupts it might be able to allocate.  If it successfully
+ * allocates at least the number of interrupts requested, it returns 0 and
+ * updates the @dev's irq member to the lowest new interrupt number; the
+ * other interrupt numbers allocated to this device are consecutive.
+ */
+int pci_enable_msi_block(struct pci_dev *dev, unsigned int nvec)
 {
-	int status;
+	int status, pos, maxvec;
+	u16 msgctl;
 
-	status = pci_msi_check_device(dev, 1, PCI_CAP_ID_MSI);
+	pos = pci_find_capability(dev, PCI_CAP_ID_MSI);
+	if (!pos)
+		return -EINVAL;
+	pci_read_config_word(dev, pos + PCI_MSI_FLAGS, &msgctl);
+	maxvec = 1 << ((msgctl & PCI_MSI_FLAGS_QMASK) >> 1);
+	if (nvec > maxvec)
+		return maxvec;
+
+	status = pci_msi_check_device(dev, nvec, PCI_CAP_ID_MSI);
 	if (status)
 		return status;
 
 	WARN_ON(!!dev->msi_enabled);
 
-	/* Check whether driver already requested for MSI-X irqs */
+	/* Check whether driver already requested MSI-X irqs */
 	if (dev->msix_enabled) {
 		dev_info(&dev->dev, "can't enable MSI "
 			 "(MSI-X already enabled)\n");
 		return -EINVAL;
 	}
-	status = msi_capability_init(dev);
+
+	status = msi_capability_init(dev, nvec);
 	return status;
 }
-EXPORT_SYMBOL(pci_enable_msi);
+EXPORT_SYMBOL(pci_enable_msi_block);
 
 void pci_msi_shutdown(struct pci_dev *dev)
 {
@@ -601,8 +634,12 @@ static int msi_free_irqs(struct pci_dev* dev)
 	struct msi_desc *entry, *tmp;
 
 	list_for_each_entry(entry, &dev->msi_list, list) {
-		if (entry->irq)
-			BUG_ON(irq_has_action(entry->irq));
+		int i, nvec;
+		if (!entry->irq)
+			continue;
+		nvec = 1 << entry->msi_attrib.multiple;
+		for (i = 0; i < nvec; i++)
+			BUG_ON(irq_has_action(entry->irq + i));
 	}
 
 	arch_teardown_msi_irqs(dev);
diff --git a/drivers/pci/msi.h b/drivers/pci/msi.h
index 3898f52..71f4df2 100644
--- a/drivers/pci/msi.h
+++ b/drivers/pci/msi.h
@@ -20,14 +20,8 @@
 #define msi_mask_bits_reg(base, is64bit) \
 	( (is64bit == 1) ? base+PCI_MSI_MASK_BIT : base+PCI_MSI_MASK_BIT-4)
 #define msi_disable(control)		control &= ~PCI_MSI_FLAGS_ENABLE
-#define multi_msi_capable(control) \
-	(1 << ((control & PCI_MSI_FLAGS_QMASK) >> 1))
-#define multi_msi_enable(control, num) \
-	control |= (((num >> 1) << 4) & PCI_MSI_FLAGS_QSIZE);
 #define is_64bit_address(control)	(!!(control & PCI_MSI_FLAGS_64BIT))
 #define is_mask_bit_support(control)	(!!(control & PCI_MSI_FLAGS_MASKBIT))
-#define msi_enable(control, num) multi_msi_enable(control, num); \
-	control |= PCI_MSI_FLAGS_ENABLE
 
 #define msix_table_offset_reg(base)	(base + 0x04)
 #define msix_pba_offset_reg(base)	(base + 0x08)
diff --git a/include/linux/msi.h b/include/linux/msi.h
index 37c1bbe..6991ab5 100644
--- a/include/linux/msi.h
+++ b/include/linux/msi.h
@@ -21,6 +21,7 @@ extern void write_msi_msg(unsigned int irq, struct msi_msg *msg);
 struct msi_desc {
 	struct {
 		__u8	is_msix	: 1;
+		__u8	multiple: 3;	/* log2 number of messages */
 		__u8	maskbit	: 1; 	/* mask-pending bit supported ?   */
 		__u8	is_64	: 1;	/* Address size: 0=32bit 1=64bit  */
 		__u8	pos;	 	/* Location of the msi capability */
diff --git a/include/linux/pci.h b/include/linux/pci.h
index 7baf2a5..1f6c5dd 100644
--- a/include/linux/pci.h
+++ b/include/linux/pci.h
@@ -789,7 +789,7 @@ struct msix_entry {
 
 
 #ifndef CONFIG_PCI_MSI
-static inline int pci_enable_msi(struct pci_dev *dev)
+static inline int pci_enable_msi_block(struct pci_dev *dev, unsigned int nvec)
 {
 	return -1;
 }
@@ -824,7 +824,7 @@ static inline int pci_msi_enabled(void)
 	return 0;
 }
 #else
-extern int pci_enable_msi(struct pci_dev *dev);
+extern int pci_enable_msi_block(struct pci_dev *dev, unsigned int nvec);
 extern void pci_msi_shutdown(struct pci_dev *dev);
 extern void pci_disable_msi(struct pci_dev *dev);
 extern int pci_msix_table_size(struct pci_dev *dev);
@@ -846,6 +846,8 @@ static inline int pcie_aspm_enabled(void)
 extern int pcie_aspm_enabled(void);
 #endif
 
+#define pci_enable_msi(pdev)	pci_enable_msi_block(pdev, 1)
+
 #ifdef CONFIG_HT_IRQ
 /* The functions a driver should call */
 int  ht_create_irq(struct pci_dev *dev, int idx);
-- 
1.5.6.5

