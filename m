Return-Path: <linux-kernel-owner+w=401wt.eu-S932780AbXA1ToU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932780AbXA1ToU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Jan 2007 14:44:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932781AbXA1ToU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Jan 2007 14:44:20 -0500
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:42339 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932780AbXA1ToT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Jan 2007 14:44:19 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: Greg Kroah-Hartman <greg@kroah.com>
Cc: linux-pci@atrey.karlin.mff.cuni.cz,
       "David S. Miller" <davem@davemloft.net>,
       Kyle McMartin <kyle@parisc-linux.org>, <linuxppc-dev@ozlabs.org>,
       Brice Goglin <brice@myri.com>, <shaohua.li@intel.com>,
       Michael Ellerman <michael@ellerman.id.au>,
       Grant Grundler <grundler@parisc-linux.org>,
       Tony Luck <tony.luck@intel.com>, <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>
Subject: [PATCH 1/6] msi: Kill msi_lookup_irq
References: <1169714047.65693.647693675533.qpush@cradle>
	<m1hcubq6re.fsf@ebiederm.dsl.xmission.com>
Date: Sun, 28 Jan 2007 12:42:52 -0700
In-Reply-To: <m1hcubq6re.fsf@ebiederm.dsl.xmission.com> (Eric W. Biederman's
	message of "Sun, 28 Jan 2007 12:40:53 -0700")
Message-ID: <m1d54zq6o3.fsf_-_@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


The function msi_lookup_irq was horrible.  As a side effect of running
it changed dev->irq, and then the callers would need to change it
back.  In addition it does a global scan through all of the irqs,
which seems to be the sole justification of the msi_lock.

To remove the neede for msi_lookup_irq I added first_msi_irq to struct
pci_dev.  Then depending on the context I replaced msi_lookup_irq with
dev->first_msi_irq, dev->msi_enabled, or dev->msix_enabled.

msi_enabled and msix_enabled were already present in pci_dev for other
reasons.

Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
---
 drivers/pci/msi.c   |  149 ++++++++++++++++++++-------------------------------
 include/linux/pci.h |    3 +
 2 files changed, 62 insertions(+), 90 deletions(-)

diff --git a/drivers/pci/msi.c b/drivers/pci/msi.c
index bca5a8a..71080c9 100644
--- a/drivers/pci/msi.c
+++ b/drivers/pci/msi.c
@@ -283,28 +283,6 @@ void pci_disable_device_msi(struct pci_dev *dev)
 			PCI_CAP_ID_MSIX);
 }
 
-static int msi_lookup_irq(struct pci_dev *dev, int type)
-{
-	int irq;
-	unsigned long flags;
-
-	spin_lock_irqsave(&msi_lock, flags);
-	for (irq = 0; irq < NR_IRQS; irq++) {
-		if (!msi_desc[irq] || msi_desc[irq]->dev != dev ||
-			msi_desc[irq]->msi_attrib.type != type ||
-			msi_desc[irq]->msi_attrib.default_irq != dev->irq)
-			continue;
-		spin_unlock_irqrestore(&msi_lock, flags);
-		/* This pre-assigned MSI irq for this device
-		   already exists. Override dev->irq with this irq */
-		dev->irq = irq;
-		return 0;
-	}
-	spin_unlock_irqrestore(&msi_lock, flags);
-
-	return -EACCES;
-}
-
 #ifdef CONFIG_PM
 static int __pci_save_msi_state(struct pci_dev *dev)
 {
@@ -375,11 +353,13 @@ static void __pci_restore_msi_state(struct pci_dev *dev)
 static int __pci_save_msix_state(struct pci_dev *dev)
 {
 	int pos;
-	int temp;
 	int irq, head, tail = 0;
 	u16 control;
 	struct pci_cap_saved_state *save_state;
 
+	if (!dev->msix_enabled)
+		return 0;
+
 	pos = pci_find_capability(dev, PCI_CAP_ID_MSIX);
 	if (pos <= 0 || dev->no_msi)
 		return 0;
@@ -397,13 +377,7 @@ static int __pci_save_msix_state(struct pci_dev *dev)
 	*((u16 *)&save_state->data[0]) = control;
 
 	/* save the table */
-	temp = dev->irq;
-	if (msi_lookup_irq(dev, PCI_CAP_ID_MSIX)) {
-		kfree(save_state);
-		return -EINVAL;
-	}
-
-	irq = head = dev->irq;
+	irq = head = dev->first_msi_irq;
 	while (head != tail) {
 		struct msi_desc *entry;
 
@@ -413,7 +387,6 @@ static int __pci_save_msix_state(struct pci_dev *dev)
 		tail = msi_desc[irq]->link.tail;
 		irq = tail;
 	}
-	dev->irq = temp;
 
 	save_state->cap_nr = PCI_CAP_ID_MSIX;
 	pci_add_saved_cap(dev, save_state);
@@ -439,9 +412,11 @@ static void __pci_restore_msix_state(struct pci_dev *dev)
 	int pos;
 	int irq, head, tail = 0;
 	struct msi_desc *entry;
-	int temp;
 	struct pci_cap_saved_state *save_state;
 
+	if (!dev->msix_enabled)
+		return;
+
 	save_state = pci_find_saved_cap(dev, PCI_CAP_ID_MSIX);
 	if (!save_state)
 		return;
@@ -454,10 +429,7 @@ static void __pci_restore_msix_state(struct pci_dev *dev)
 		return;
 
 	/* route the table */
-	temp = dev->irq;
-	if (msi_lookup_irq(dev, PCI_CAP_ID_MSIX))
-		return;
-	irq = head = dev->irq;
+	irq = head = dev->first_msi_irq;
 	while (head != tail) {
 		entry = msi_desc[irq];
 		write_msi_msg(irq, &entry->msg_save);
@@ -465,7 +437,6 @@ static void __pci_restore_msix_state(struct pci_dev *dev)
 		tail = msi_desc[irq]->link.tail;
 		irq = tail;
 	}
-	dev->irq = temp;
 
 	pci_write_config_word(dev, msi_control_reg(pos), save);
 	enable_msi_mode(dev, pos, PCI_CAP_ID_MSIX);
@@ -535,6 +506,7 @@ static int msi_capability_init(struct pci_dev *dev)
 		return status;
 	}
 
+	dev->first_msi_irq = irq;
 	attach_msi_entry(entry, irq);
 	/* Set MSI enabled bits	 */
 	enable_msi_mode(dev, pos, PCI_CAP_ID_MSI);
@@ -631,6 +603,7 @@ static int msix_capability_init(struct pci_dev *dev,
 			avail = -EBUSY;
 		return avail;
 	}
+	dev->first_msi_irq = entries[0].vector;
 	/* Set MSI-X enabled bits */
 	enable_msi_mode(dev, pos, PCI_CAP_ID_MSIX);
 
@@ -678,13 +651,11 @@ int pci_msi_supported(struct pci_dev * dev)
  **/
 int pci_enable_msi(struct pci_dev* dev)
 {
-	int pos, temp, status;
+	int pos, status;
 
 	if (pci_msi_supported(dev) < 0)
 		return -EINVAL;
 
-	temp = dev->irq;
-
 	status = msi_init();
 	if (status < 0)
 		return status;
@@ -693,15 +664,14 @@ int pci_enable_msi(struct pci_dev* dev)
 	if (!pos)
 		return -EINVAL;
 
-	WARN_ON(!msi_lookup_irq(dev, PCI_CAP_ID_MSI));
+	WARN_ON(!!dev->msi_enabled);
 
 	/* Check whether driver already requested for MSI-X irqs */
 	pos = pci_find_capability(dev, PCI_CAP_ID_MSIX);
-	if (pos > 0 && !msi_lookup_irq(dev, PCI_CAP_ID_MSIX)) {
+	if (pos > 0 && dev->msix_enabled) {
 			printk(KERN_INFO "PCI: %s: Can't enable MSI.  "
-			       "Device already has MSI-X irq assigned\n",
+			       "Device already has MSI-X enabled\n",
 			       pci_name(dev));
-			dev->irq = temp;
 			return -EINVAL;
 	}
 	status = msi_capability_init(dev);
@@ -720,6 +690,9 @@ void pci_disable_msi(struct pci_dev* dev)
 	if (!dev)
 		return;
 
+	if (!dev->msi_enabled)
+		return;
+
 	pos = pci_find_capability(dev, PCI_CAP_ID_MSI);
 	if (!pos)
 		return;
@@ -728,28 +701,30 @@ void pci_disable_msi(struct pci_dev* dev)
 	if (!(control & PCI_MSI_FLAGS_ENABLE))
 		return;
 
+
 	disable_msi_mode(dev, pos, PCI_CAP_ID_MSI);
 
 	spin_lock_irqsave(&msi_lock, flags);
-	entry = msi_desc[dev->irq];
+	entry = msi_desc[dev->first_msi_irq];
 	if (!entry || !entry->dev || entry->msi_attrib.type != PCI_CAP_ID_MSI) {
 		spin_unlock_irqrestore(&msi_lock, flags);
 		return;
 	}
-	if (irq_has_action(dev->irq)) {
+	if (irq_has_action(dev->first_msi_irq)) {
 		spin_unlock_irqrestore(&msi_lock, flags);
 		printk(KERN_WARNING "PCI: %s: pci_disable_msi() called without "
 		       "free_irq() on MSI irq %d\n",
-		       pci_name(dev), dev->irq);
-		BUG_ON(irq_has_action(dev->irq));
+		       pci_name(dev), dev->first_msi_irq);
+		BUG_ON(irq_has_action(dev->first_msi_irq));
 	} else {
 		default_irq = entry->msi_attrib.default_irq;
 		spin_unlock_irqrestore(&msi_lock, flags);
-		msi_free_irq(dev, dev->irq);
+		msi_free_irq(dev, dev->first_msi_irq);
 
 		/* Restore dev->irq to its default pin-assertion irq */
 		dev->irq = default_irq;
 	}
+	dev->first_msi_irq = 0;
 }
 
 static int msi_free_irq(struct pci_dev* dev, int irq)
@@ -808,7 +783,7 @@ static int msi_free_irq(struct pci_dev* dev, int irq)
 int pci_enable_msix(struct pci_dev* dev, struct msix_entry *entries, int nvec)
 {
 	int status, pos, nr_entries;
-	int i, j, temp;
+	int i, j;
 	u16 control;
 
 	if (!entries || pci_msi_supported(dev) < 0)
@@ -836,16 +811,14 @@ int pci_enable_msix(struct pci_dev* dev, struct msix_entry *entries, int nvec)
 				return -EINVAL;	/* duplicate entry */
 		}
 	}
-	temp = dev->irq;
-	WARN_ON(!msi_lookup_irq(dev, PCI_CAP_ID_MSIX));
+	WARN_ON(!!dev->msix_enabled);
 
 	/* Check whether driver already requested for MSI irq */
    	if (pci_find_capability(dev, PCI_CAP_ID_MSI) > 0 &&
-		!msi_lookup_irq(dev, PCI_CAP_ID_MSI)) {
+		dev->msi_enabled) {
 		printk(KERN_INFO "PCI: %s: Can't enable MSI-X.  "
 		       "Device already has an MSI irq assigned\n",
 		       pci_name(dev));
-		dev->irq = temp;
 		return -EINVAL;
 	}
 	status = msix_capability_init(dev, entries, nvec);
@@ -854,7 +827,9 @@ int pci_enable_msix(struct pci_dev* dev, struct msix_entry *entries, int nvec)
 
 void pci_disable_msix(struct pci_dev* dev)
 {
-	int pos, temp;
+	int irq, head, tail = 0, warning = 0;
+	unsigned long flags;
+	int pos;
 	u16 control;
 
 	if (!pci_msi_enable)
@@ -862,6 +837,9 @@ void pci_disable_msix(struct pci_dev* dev)
 	if (!dev)
 		return;
 
+	if (!dev->msix_enabled)
+		return;
+
 	pos = pci_find_capability(dev, PCI_CAP_ID_MSIX);
 	if (!pos)
 		return;
@@ -872,31 +850,25 @@ void pci_disable_msix(struct pci_dev* dev)
 
 	disable_msi_mode(dev, pos, PCI_CAP_ID_MSIX);
 
-	temp = dev->irq;
-	if (!msi_lookup_irq(dev, PCI_CAP_ID_MSIX)) {
-		int irq, head, tail = 0, warning = 0;
-		unsigned long flags;
-
-		irq = head = dev->irq;
-		dev->irq = temp;			/* Restore pin IRQ */
-		while (head != tail) {
-			spin_lock_irqsave(&msi_lock, flags);
-			tail = msi_desc[irq]->link.tail;
-			spin_unlock_irqrestore(&msi_lock, flags);
-			if (irq_has_action(irq))
-				warning = 1;
-			else if (irq != head)	/* Release MSI-X irq */
-				msi_free_irq(dev, irq);
-			irq = tail;
-		}
-		msi_free_irq(dev, irq);
-		if (warning) {
-			printk(KERN_WARNING "PCI: %s: pci_disable_msix() called without "
-			       "free_irq() on all MSI-X irqs\n",
-			       pci_name(dev));
-			BUG_ON(warning > 0);
-		}
+	irq = head = dev->first_msi_irq;
+	while (head != tail) {
+		spin_lock_irqsave(&msi_lock, flags);
+		tail = msi_desc[irq]->link.tail;
+		spin_unlock_irqrestore(&msi_lock, flags);
+		if (irq_has_action(irq))
+			warning = 1;
+		else if (irq != head)	/* Release MSI-X irq */
+			msi_free_irq(dev, irq);
+		irq = tail;
+	}
+	msi_free_irq(dev, irq);
+	if (warning) {
+		printk(KERN_WARNING "PCI: %s: pci_disable_msix() called without "
+			"free_irq() on all MSI-X irqs\n",
+			pci_name(dev));
+		BUG_ON(warning > 0);
 	}
+	dev->first_msi_irq = 0;
 }
 
 /**
@@ -910,30 +882,28 @@ void pci_disable_msix(struct pci_dev* dev)
  **/
 void msi_remove_pci_irq_vectors(struct pci_dev* dev)
 {
-	int pos, temp;
+	int pos;
 	unsigned long flags;
 
 	if (!pci_msi_enable || !dev)
  		return;
 
-	temp = dev->irq;		/* Save IOAPIC IRQ */
 	pos = pci_find_capability(dev, PCI_CAP_ID_MSI);
-	if (pos > 0 && !msi_lookup_irq(dev, PCI_CAP_ID_MSI)) {
-		if (irq_has_action(dev->irq)) {
+	if (pos > 0 && dev->msi_enabled) {
+		if (irq_has_action(dev->first_msi_irq)) {
 			printk(KERN_WARNING "PCI: %s: msi_remove_pci_irq_vectors() "
 			       "called without free_irq() on MSI irq %d\n",
-			       pci_name(dev), dev->irq);
-			BUG_ON(irq_has_action(dev->irq));
+			       pci_name(dev), dev->first_msi_irq);
+			BUG_ON(irq_has_action(dev->first_msi_irq));
 		} else /* Release MSI irq assigned to this device */
-			msi_free_irq(dev, dev->irq);
-		dev->irq = temp;		/* Restore IOAPIC IRQ */
+			msi_free_irq(dev, dev->first_msi_irq);
 	}
 	pos = pci_find_capability(dev, PCI_CAP_ID_MSIX);
-	if (pos > 0 && !msi_lookup_irq(dev, PCI_CAP_ID_MSIX)) {
+	if (pos > 0 && dev->msix_enabled) {
 		int irq, head, tail = 0, warning = 0;
 		void __iomem *base = NULL;
 
-		irq = head = dev->irq;
+		irq = head = dev->first_msi_irq;
 		while (head != tail) {
 			spin_lock_irqsave(&msi_lock, flags);
 			tail = msi_desc[irq]->link.tail;
@@ -953,7 +923,6 @@ void msi_remove_pci_irq_vectors(struct pci_dev* dev)
 			       pci_name(dev));
 			BUG_ON(warning > 0);
 		}
-		dev->irq = temp;		/* Restore IOAPIC IRQ */
 	}
 }
 
diff --git a/include/linux/pci.h b/include/linux/pci.h
index 29765e2..1507f8c 100644
--- a/include/linux/pci.h
+++ b/include/linux/pci.h
@@ -174,6 +174,9 @@ struct pci_dev {
 	struct bin_attribute *rom_attr; /* attribute descriptor for sysfs ROM entry */
 	int rom_attr_enabled;		/* has display of the rom attribute been enabled? */
 	struct bin_attribute *res_attr[DEVICE_COUNT_RESOURCE]; /* sysfs file for resources */
+#ifdef CONFIG_PCI_MSI
+	unsigned int first_msi_irq;
+#endif
 };
 
 #define pci_dev_g(n) list_entry(n, struct pci_dev, global_list)
-- 
1.4.4.1.g278f

