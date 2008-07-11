Return-Path: <linux-kernel-owner+w=401wt.eu-S1761256AbYGKBDm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761256AbYGKBDm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2008 21:03:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759073AbYGKBCu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jul 2008 21:02:50 -0400
Received: from mail.tor.primus.ca ([216.254.136.21]:34566 "EHLO
	mail-05.primus.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760802AbYGKBCs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2008 21:02:48 -0400
From: Matthew Wilcox <matthew@wil.cx>
To: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: grundler@parisc-linux.org, mingo@elte.hu, tglx@linutronix.de,
       jgarzik@pobox.com, linux-ide@vger.kernel.org, suresh.b.siddha@intel.com,
       benh@kernel.crashing.org, jbarnes@virtuousgeek.org,
       rdunlap@xenotime.net, mtk.manpages@gmail.com,
       Matthew Wilcox <matthew@wil.cx>, Matthew Wilcox <willy@linux.intel.com>
Subject: [PATCH] PCI: Add support for multiple MSI
Date: Thu, 10 Jul 2008 20:59:59 -0400
Message-Id: <1215738002-4961-2-git-send-email-matthew@wil.cx>
X-Mailer: git-send-email 1.5.5.4
In-Reply-To: <20080711005719.GO14894@parisc-linux.org>
References: <20080711005719.GO14894@parisc-linux.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add the new API pci_enable_msi_block() to allow drivers to
request multiple MSI and reimplement pci_enable_msi in terms of
pci_enable_msi_block.  Ensure that the architecture back ends don't
have to know about multiple MSI.

Signed-off-by: Matthew Wilcox <willy@linux.intel.com>
---
 arch/powerpc/kernel/msi.c |    4 ++
 drivers/pci/msi.c         |   79 +++++++++++++++++++++++++++++++-------------
 drivers/pci/msi.h         |    4 --
 include/linux/msi.h       |    1 +
 include/linux/pci.h       |    6 ++-
 5 files changed, 64 insertions(+), 30 deletions(-)

diff --git a/arch/powerpc/kernel/msi.c b/arch/powerpc/kernel/msi.c
index c62d101..5bc8dda 100644
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
diff --git a/drivers/pci/msi.c b/drivers/pci/msi.c
index 104f297..bc2e888 100644
--- a/drivers/pci/msi.c
+++ b/drivers/pci/msi.c
@@ -45,6 +45,13 @@ arch_setup_msi_irqs(struct pci_dev *dev, int nvec, int type)
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
 		if (ret)
@@ -65,8 +72,12 @@ arch_teardown_msi_irqs(struct pci_dev *dev)
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
 
@@ -186,6 +197,12 @@ void write_msi_msg(unsigned int irq, struct msi_msg *msg)
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
@@ -301,13 +318,15 @@ EXPORT_SYMBOL_GPL(pci_restore_msi_state);
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
@@ -351,7 +370,7 @@ static int msi_capability_init(struct pci_dev *dev)
 	list_add_tail(&entry->list, &dev->msi_list);
 
 	/* Configure MSI capability structure */
-	ret = arch_setup_msi_irqs(dev, 1, PCI_CAP_ID_MSI);
+	ret = arch_setup_msi_irqs(dev, nvec, PCI_CAP_ID_MSI);
 	if (ret) {
 		msi_free_irqs(dev);
 		return ret;
@@ -503,36 +522,44 @@ static int pci_msi_check_device(struct pci_dev* dev, int nvec, int type)
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
 	int status;
 
-	status = pci_msi_check_device(dev, 1, PCI_CAP_ID_MSI);
+	/* MSI only supports up to 32 interrupts */
+	if (nvec > 32)
+		return 32;
+
+	status = pci_msi_check_device(dev, nvec, PCI_CAP_ID_MSI);
 	if (status)
 		return status;
 
 	WARN_ON(!!dev->msi_enabled);
 
-	/* Check whether driver already requested for MSI-X irqs */
+	/* Check whether driver already requested MSI-X irqs */
 	if (dev->msix_enabled) {
 		printk(KERN_INFO "PCI: %s: Can't enable MSI.  "
 			"Device already has MSI-X enabled\n",
 			pci_name(dev));
 		return -EINVAL;
 	}
-	status = msi_capability_init(dev);
+
+	status = msi_capability_init(dev, nvec);
 	return status;
 }
-EXPORT_SYMBOL(pci_enable_msi);
+EXPORT_SYMBOL(pci_enable_msi_block);
 
 void pci_msi_shutdown(struct pci_dev* dev)
 {
@@ -581,8 +608,12 @@ static int msi_free_irqs(struct pci_dev* dev)
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
index 13a8a1b..70fcebc 100644
--- a/include/linux/msi.h
+++ b/include/linux/msi.h
@@ -18,6 +18,7 @@ extern void write_msi_msg(unsigned int irq, struct msi_msg *msg);
 struct msi_desc {
 	struct {
 		__u8	is_msix	: 1;
+		__u8	multiple: 3;	/* log2 number of messages */
 		__u8	maskbit	: 1; 	/* mask-pending bit supported ?   */
 		__u8	masked	: 1;
 		__u8	is_64	: 1;	/* Address size: 0=32bit 1=64bit  */
diff --git a/include/linux/pci.h b/include/linux/pci.h
index d18b1dd..16df5f9 100644
--- a/include/linux/pci.h
+++ b/include/linux/pci.h
@@ -699,7 +699,7 @@ struct msix_entry {
 
 
 #ifndef CONFIG_PCI_MSI
-static inline int pci_enable_msi(struct pci_dev *dev)
+static inline int pci_enable_msi_block(struct pci_dev *dev, unsigned int nvec)
 {
 	return -1;
 }
@@ -726,7 +726,7 @@ static inline void msi_remove_pci_irq_vectors(struct pci_dev *dev)
 static inline void pci_restore_msi_state(struct pci_dev *dev)
 { }
 #else
-extern int pci_enable_msi(struct pci_dev *dev);
+extern int pci_enable_msi_block(struct pci_dev *dev, unsigned int nvec);
 extern void pci_msi_shutdown(struct pci_dev *dev);
 extern void pci_disable_msi(struct pci_dev *dev);
 extern int pci_enable_msix(struct pci_dev *dev,
@@ -737,6 +737,8 @@ extern void msi_remove_pci_irq_vectors(struct pci_dev *dev);
 extern void pci_restore_msi_state(struct pci_dev *dev);
 #endif
 
+#define pci_enable_msi(pdev)	pci_enable_msi_block(pdev, 1)
+
 #ifdef CONFIG_HT_IRQ
 /* The functions a driver should call */
 int  ht_create_irq(struct pci_dev *dev, int idx);
-- 
1.5.5.4

