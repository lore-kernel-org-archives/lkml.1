Return-Path: <linux-kernel-owner+w=401wt.eu-S1755300AbYGGLbb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755300AbYGGLbb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2008 07:31:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753271AbYGGLbJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Jul 2008 07:31:09 -0400
Received: from palinux.external.hp.com ([192.25.206.14]:44366 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752716AbYGGLbH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2008 07:31:07 -0400
Date: Mon, 7 Jul 2008 05:31:05 -0600
From: Matthew Wilcox <matthew@wil.cx>
To: Michael Ellerman <michael@ellerman.id.au>
Cc: linux-pci@vger.kernel.org, kaneshige.kenji@jp.fujitsu.com, mingo@elte.hu,
       tglx@linutronix.de, davem@davemloft.net, dan.j.williams@intel.com,
       Martine.Silbermann@hp.com, benh@kernel.crashing.org,
       linux-kernel@vger.kernel.org, Matthew Wilcox <willy@linux.intel.com>
Subject: Re: [PATCH 2/4] PCI: Support multiple MSI
Message-ID: <20080707113105.GY14894@parisc-linux.org>
References: <20080705132728.GO14894@parisc-linux.org> <1215264855-4372-2-git-send-email-matthew@wil.cx> <1215396326.19157.15.camel@localhost> <20080707024525.GV14894@parisc-linux.org> <1215403012.9862.25.camel@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1215403012.9862.25.camel@localhost>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 07, 2008 at 01:56:52PM +1000, Michael Ellerman wrote:
> Yeah I think it's just us.

Grep agrees.

> But there's also the default implementation, which will happily use the
> singular arch hook to setup multiple MSIs without any constraint on the
> irq numbers - which will break.

Yup.

> So I think you want to make the default arch_msi_check_device() return
> an error if you ask for MSI & nvec > 1. Then on powerpc we'll probably
> add the same check to our version (at least until we can test it), but
> on x86 you can let MSI & nvec > 1 pass.

That was my intent ... something like this:

diff --git a/arch/powerpc/kernel/msi.c b/arch/powerpc/kernel/msi.c
index c62d101..79ff21f 100644
--- a/arch/powerpc/kernel/msi.c
+++ b/arch/powerpc/kernel/msi.c
@@ -29,10 +29,12 @@ int arch_msi_check_device(struct pci_dev* dev, int nvec, int type)
 
 int arch_setup_msi_irqs(struct pci_dev *dev, int nvec, int type)
 {
+	if (type == PCI_CAP_ID_MSI && nvec > 1)
+		return 1;
 	return ppc_md.setup_msi_irqs(dev, nvec, type);
 }
 
-void arch_teardown_msi_irqs(struct pci_dev *dev)
+void arch_teardown_msi_irqs(struct pci_dev *dev, int nvec)
 {
 	return ppc_md.teardown_msi_irqs(dev);
 }
diff --git a/drivers/pci/msi.c b/drivers/pci/msi.c
index 92992a8..4f7b31f 100644
--- a/drivers/pci/msi.c
+++ b/drivers/pci/msi.c
@@ -42,11 +42,14 @@ arch_setup_msi_irq(struct pci_dev *dev, struct msi_desc *entry)
 int __attribute__ ((weak))
 arch_setup_msi_irqs(struct pci_dev *dev, int nvec, int type)
 {
-	struct msi_desc *entry;
+	struct msi_desc *desc;
 	int ret;
 
-	list_for_each_entry(entry, &dev->msi_list, list) {
-		ret = arch_setup_msi_irq(dev, entry);
+	if ((type == PCI_CAP_ID_MSI) && (nvec > 1))
+		return 1;
+
+	list_for_each_entry(desc, &dev->msi_list, list) {
+		ret = arch_setup_msi_irq(dev, desc);
 		if (ret)
 			return ret;
 	}
@@ -60,13 +63,16 @@ void __attribute__ ((weak)) arch_teardown_msi_irq(unsigned int irq)
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
 
@@ -350,7 +356,7 @@ EXPORT_SYMBOL_GPL(pci_restore_msi_state);
  * multiple messages. A return of zero indicates the successful setup
  * of an entry zero with the new MSI irq or non-zero for otherwise.
  **/
-static int msi_capability_init(struct pci_dev *dev)
+static int msi_capability_init(struct pci_dev *dev, int nr_irqs)
 {
 	struct msi_desc *entry;
 	int pos, ret;
@@ -394,7 +400,7 @@ static int msi_capability_init(struct pci_dev *dev)
 	list_add_tail(&entry->list, &dev->msi_list);
 
 	/* Configure MSI capability structure */
-	ret = arch_setup_msi_irqs(dev, 1, PCI_CAP_ID_MSI);
+	ret = arch_setup_msi_irqs(dev, nr_irqs, PCI_CAP_ID_MSI);
 	if (ret) {
 		msi_free_irqs(dev);
 		return ret;
@@ -546,36 +552,47 @@ static int pci_msi_check_device(struct pci_dev* dev, int nvec, int type)
 }
 
 /**
- * pci_enable_msi - configure device's MSI capability structure
- * @dev: pointer to the pci_dev data structure of MSI device function
+ * pci_enable_msi_block - configure device's MSI capability structure
+ * @pdev: Device to configure
+ * @nr_irqs: Number of IRQs requested
  *
- * Setup the MSI capability structure of device function with
- * a single MSI irq upon its software driver call to request for
- * MSI mode enabled on its hardware device function. A return of zero
- * indicates the successful setup of an entry zero with the new MSI
- * irq or non-zero for otherwise.
+ * Allocate IRQs for a device with the MSI capability.
+ * This function returns a negative errno if an error occurs.  On success,
+ * this function returns the number of IRQs actually allocated.  Since
+ * MSIs are required to be a power of two, the number of IRQs allocated
+ * may be rounded up to the next power of two (if the number requested is
+ * not a power of two).  Fewer IRQs than requested may be allocated if the
+ * system does not have the resources for the full number.
+ *
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
@@ -621,26 +638,30 @@ EXPORT_SYMBOL(pci_disable_msi);
 
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
index d322148..f2400cc 100644
--- a/include/linux/msi.h
+++ b/include/linux/msi.h
@@ -42,12 +42,14 @@ struct msi_desc {
 };
 
 /*
- * The arch hook for setup up msi irqs
+ * These functions should be implemented by the CPU architecture.
+ * Note that you need to implement only one of arch_setup_msi_irq() and
+ * arch_teardown_msi_irqs()
  */
 int arch_setup_msi_irq(struct pci_dev *dev, struct msi_desc *desc);
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
Intel are signing my paycheques ... these opinions are still mine
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
