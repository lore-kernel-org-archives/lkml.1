Return-Path: <linux-kernel-owner+w=401wt.eu-S1751934AbYGEOwG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751934AbYGEOwG (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Jul 2008 10:52:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753298AbYGEOvw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 Jul 2008 10:51:52 -0400
Received: from mail.tor.primus.ca ([216.254.136.21]:35940 "EHLO
	mail-08.primus.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751310AbYGEOvv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Jul 2008 10:51:51 -0400
From: Matthew Wilcox <matthew@wil.cx>
To: linux-pci@vger.kernel.org
Cc: kaneshige.kenji@jp.fujitsu.com, mingo@elte.hu, tglx@linutronix.de,
       davem@davemloft.net, dan.j.williams@intel.com,
       Martine.Silbermann@hp.com, benh@kernel.crashing.org,
       michael@ellerman.id.au, linux-kernel@vger.kernel.org,
       Matthew Wilcox <matthew@wil.cx>, Matthew Wilcox <willy@linux.intel.com>
Subject: [PATCH 2/4] PCI: Support multiple MSI
Date: Sat,  5 Jul 2008 09:34:13 -0400
Message-Id: <1215264855-4372-2-git-send-email-matthew@wil.cx>
X-Mailer: git-send-email 1.5.5.4
In-Reply-To: <20080705132728.GO14894@parisc-linux.org>
References: <20080705132728.GO14894@parisc-linux.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add the new API pci_enable_msi_block() to allow drivers to
request multiple MSIs.  Reimplement pci_enable_msi in terms
of pci_enable_msi_block.  Add a default implementation of
arch_setup_msi_block() that only allows one MSI to be requested.

Signed-off-by: Matthew Wilcox <willy@linux.intel.com>
---
 arch/powerpc/kernel/msi.c |    2 +-
 drivers/pci/msi.c         |  109 +++++++++++++++++++++++++++++----------------
 include/linux/msi.h       |    3 +-
 include/linux/pci.h       |    6 ++-
 4 files changed, 77 insertions(+), 43 deletions(-)

diff --git a/arch/powerpc/kernel/msi.c b/arch/powerpc/kernel/msi.c
index c62d101..317c7c8 100644
--- a/arch/powerpc/kernel/msi.c
+++ b/arch/powerpc/kernel/msi.c
@@ -32,7 +32,7 @@ int arch_setup_msi_irqs(struct pci_dev *dev, int nvec, int type)
 	return ppc_md.setup_msi_irqs(dev, nvec, type);
 }
 
-void arch_teardown_msi_irqs(struct pci_dev *dev)
+void arch_teardown_msi_irqs(struct pci_dev *dev, int nvec)
 {
 	return ppc_md.teardown_msi_irqs(dev);
 }
diff --git a/drivers/pci/msi.c b/drivers/pci/msi.c
index 92992a8..6cbdf11 100644
--- a/drivers/pci/msi.c
+++ b/drivers/pci/msi.c
@@ -40,18 +40,31 @@ arch_setup_msi_irq(struct pci_dev *dev, struct msi_desc *entry)
 }
 
 int __attribute__ ((weak))
+arch_setup_msi_block(struct pci_dev *pdev, struct msi_desc *desc, int nvec)
+{
+	if (nvec > 1)
+		return 1;
+	return arch_setup_msi_irq(pdev, desc);
+}
+
+int __attribute__ ((weak))
 arch_setup_msi_irqs(struct pci_dev *dev, int nvec, int type)
 {
-	struct msi_desc *entry;
+	struct msi_desc *desc;
 	int ret;
 
-	list_for_each_entry(entry, &dev->msi_list, list) {
-		ret = arch_setup_msi_irq(dev, entry);
-		if (ret)
-			return ret;
+	if (type == PCI_CAP_ID_MSI) {
+		desc = list_first_entry(&dev->msi_list, struct msi_desc, list);
+		ret = arch_setup_msi_block(dev, desc, nvec);
+	} else {
+		list_for_each_entry(desc, &dev->msi_list, list) {
+			ret = arch_setup_msi_irq(dev, desc);
+			if (ret)
+				break;
+		}
 	}
 
-	return 0;
+	return ret;
 }
 
 void __attribute__ ((weak)) arch_teardown_msi_irq(unsigned int irq)
@@ -60,13 +73,16 @@ void __attribute__ ((weak)) arch_teardown_msi_irq(unsigned int irq)
 }
 
 void __attribute__ ((weak))
-arch_teardown_msi_irqs(struct pci_dev *dev)
+arch_teardown_msi_irqs(struct pci_dev *dev, int nvec)
 {
 	struct msi_desc *entry;
 
 	list_for_each_entry(entry, &dev->msi_list, list) {
-		if (entry->irq != 0)
-			arch_teardown_msi_irq(entry->irq);
+		int i;
+		if (entry->irq == 0)
+			continue;
+		for (i = 0; i < nvec; i++)
+			arch_teardown_msi_irq(entry->irq + i);
 	}
 }
 
@@ -350,7 +366,7 @@ EXPORT_SYMBOL_GPL(pci_restore_msi_state);
  * multiple messages. A return of zero indicates the successful setup
  * of an entry zero with the new MSI irq or non-zero for otherwise.
  **/
-static int msi_capability_init(struct pci_dev *dev)
+static int msi_capability_init(struct pci_dev *dev, int nr_irqs)
 {
 	struct msi_desc *entry;
 	int pos, ret;
@@ -394,7 +410,7 @@ static int msi_capability_init(struct pci_dev *dev)
 	list_add_tail(&entry->list, &dev->msi_list);
 
 	/* Configure MSI capability structure */
-	ret = arch_setup_msi_irqs(dev, 1, PCI_CAP_ID_MSI);
+	ret = arch_setup_msi_irqs(dev, nr_irqs, PCI_CAP_ID_MSI);
 	if (ret) {
 		msi_free_irqs(dev);
 		return ret;
@@ -546,36 +562,47 @@ static int pci_msi_check_device(struct pci_dev* dev, int nvec, int type)
 }
 
 /**
- * pci_enable_msi - configure device's MSI capability structure
- * @dev: pointer to the pci_dev data structure of MSI device function
+ * pci_enable_msi_block - configure device's MSI capability structure
+ * @pdev: Device to configure
+ * @nr_irqs: Number of IRQs requested
+ *
+ * Allocate IRQs for a device with the MSI capability.
+ * This function returns a negative errno if an error occurs.  On success,
+ * this function returns the number of IRQs actually allocated.  Since
+ * MSIs are required to be a power of two, the number of IRQs allocated
+ * may be rounded up to the next power of two (if the number requested is
+ * not a power of two).  Fewer IRQs than requested may be allocated if the
+ * system does not have the resources for the full number.
  *
- * Setup the MSI capability structure of device function with
- * a single MSI irq upon its software driver call to request for
- * MSI mode enabled on its hardware device function. A return of zero
- * indicates the successful setup of an entry zero with the new MSI
- * irq or non-zero for otherwise.
+ * If successful, the @pdev's irq member will be updated to the lowest new
+ * IRQ allocated; the other IRQs allocated to this device will be consecutive.
  **/
-int pci_enable_msi(struct pci_dev* dev)
+int pci_enable_msi_block(struct pci_dev *pdev, unsigned int nr_irqs)
 {
 	int status;
 
-	status = pci_msi_check_device(dev, 1, PCI_CAP_ID_MSI);
+	/* MSI only supports up to 32 interrupts */
+	if (nr_irqs > 32)
+		return 32;
+
+	status = pci_msi_check_device(pdev, nr_irqs, PCI_CAP_ID_MSI);
 	if (status)
 		return status;
 
-	WARN_ON(!!dev->msi_enabled);
+	WARN_ON(!!pdev->msi_enabled);
 
-	/* Check whether driver already requested for MSI-X irqs */
-	if (dev->msix_enabled) {
+	/* Check whether driver already requested MSI-X irqs */
+	if (pdev->msix_enabled) {
 		printk(KERN_INFO "PCI: %s: Can't enable MSI.  "
 			"Device already has MSI-X enabled\n",
-			pci_name(dev));
+			pci_name(pdev));
 		return -EINVAL;
 	}
-	status = msi_capability_init(dev);
+
+	status = msi_capability_init(pdev, nr_irqs);
 	return status;
 }
-EXPORT_SYMBOL(pci_enable_msi);
+EXPORT_SYMBOL(pci_enable_msi_block);
 
 void pci_msi_shutdown(struct pci_dev* dev)
 {
@@ -621,26 +648,30 @@ EXPORT_SYMBOL(pci_disable_msi);
 
 static int msi_free_irqs(struct pci_dev* dev)
 {
-	struct msi_desc *entry, *tmp;
+	int i, nvec = 1;
+	struct msi_desc *desc, *tmp;
 
-	list_for_each_entry(entry, &dev->msi_list, list) {
-		if (entry->irq)
-			BUG_ON(irq_has_action(entry->irq));
+	list_for_each_entry(desc, &dev->msi_list, list) {
+		nvec = 1 << desc->msi_attrib.multiple;
+		if (!desc->irq)
+			continue;
+		for (i = 0; i < nvec; i++)
+			BUG_ON(irq_has_action(desc->irq + i));
 	}
 
-	arch_teardown_msi_irqs(dev);
+	arch_teardown_msi_irqs(dev, nvec);
 
-	list_for_each_entry_safe(entry, tmp, &dev->msi_list, list) {
-		if (entry->msi_attrib._type == MSIX_ATTRIB) {
-			writel(1, entry->mask_base + entry->msi_attrib.entry_nr
+	list_for_each_entry_safe(desc, tmp, &dev->msi_list, list) {
+		if (desc->msi_attrib._type == MSIX_ATTRIB) {
+			writel(1, desc->mask_base + desc->msi_attrib.entry_nr
 				  * PCI_MSIX_ENTRY_SIZE
 				  + PCI_MSIX_ENTRY_VECTOR_CTRL_OFFSET);
 
-			if (list_is_last(&entry->list, &dev->msi_list))
-				iounmap(entry->mask_base);
+			if (list_is_last(&desc->list, &dev->msi_list))
+				iounmap(desc->mask_base);
 		}
-		list_del(&entry->list);
-		kfree(entry);
+		list_del(&desc->list);
+		kfree(desc);
 	}
 
 	return 0;
diff --git a/include/linux/msi.h b/include/linux/msi.h
index d322148..4731fe7 100644
--- a/include/linux/msi.h
+++ b/include/linux/msi.h
@@ -45,9 +45,10 @@ struct msi_desc {
  * The arch hook for setup up msi irqs
  */
 int arch_setup_msi_irq(struct pci_dev *dev, struct msi_desc *desc);
+int arch_setup_msi_block(struct pci_dev *dev, struct msi_desc *desc, int nvec);
 void arch_teardown_msi_irq(unsigned int irq);
 extern int arch_setup_msi_irqs(struct pci_dev *dev, int nvec, int type);
-extern void arch_teardown_msi_irqs(struct pci_dev *dev);
+extern void arch_teardown_msi_irqs(struct pci_dev *dev, int nvec);
 extern int arch_msi_check_device(struct pci_dev* dev, int nvec, int type);
 
 
diff --git a/include/linux/pci.h b/include/linux/pci.h
index d18b1dd..f7ca7f8 100644
--- a/include/linux/pci.h
+++ b/include/linux/pci.h
@@ -699,7 +699,7 @@ struct msix_entry {
 
 
 #ifndef CONFIG_PCI_MSI
-static inline int pci_enable_msi(struct pci_dev *dev)
+static inline int pci_enable_msi_block(struct pci_dev *dev, unsigned int count)
 {
 	return -1;
 }
@@ -726,7 +726,7 @@ static inline void msi_remove_pci_irq_vectors(struct pci_dev *dev)
 static inline void pci_restore_msi_state(struct pci_dev *dev)
 { }
 #else
-extern int pci_enable_msi(struct pci_dev *dev);
+extern int pci_enable_msi_block(struct pci_dev *dev, unsigned int count);
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

