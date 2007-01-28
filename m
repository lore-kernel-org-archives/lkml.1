Return-Path: <linux-kernel-owner+w=401wt.eu-S932794AbXA1TxK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932794AbXA1TxK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Jan 2007 14:53:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932792AbXA1TxJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Jan 2007 14:53:09 -0500
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:44433 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932801AbXA1TxH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Jan 2007 14:53:07 -0500
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
Subject: [PATCH 5/6] msi: Kill the msi_desc array.
References: <1169714047.65693.647693675533.qpush@cradle>
	<m1hcubq6re.fsf@ebiederm.dsl.xmission.com>
	<m1d54zq6o3.fsf_-_@ebiederm.dsl.xmission.com>
	<m18xfnq6lm.fsf_-_@ebiederm.dsl.xmission.com>
	<m14pqbq6j1.fsf_-_@ebiederm.dsl.xmission.com>
	<m1zm83orvb.fsf_-_@ebiederm.dsl.xmission.com>
Date: Sun, 28 Jan 2007 12:52:03 -0700
In-Reply-To: <m1zm83orvb.fsf_-_@ebiederm.dsl.xmission.com> (Eric
	W. Biederman's message of "Sun, 28 Jan 2007 12:47:52 -0700")
Message-ID: <m1veiroroc.fsf_-_@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


We need to be able to get from an irq number to a struct msi_desc.
The msi_desc array in msi.c had several short comings the big one was
that it could not be used outside of msi.c.  Using irq_data in struct
irq_desc almost worked except on some architectures irq_data needs to
be used for something else. 

So this patch adds a msi_desc pointer to irq_desc, adds the appropriate
wrappers and changes all of the msi code to use them.

The dynamic_irq_init/cleanup code was tweaked to ensure the new
field is left in a well defined state.

Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
---
 arch/ia64/sn/kernel/msi_sn.c |    2 +-
 drivers/pci/msi.c            |   44 ++++++++++++++++++++---------------------
 include/linux/irq.h          |    4 +++
 kernel/irq/chip.c            |   28 ++++++++++++++++++++++++++
 4 files changed, 54 insertions(+), 24 deletions(-)

diff --git a/arch/ia64/sn/kernel/msi_sn.c b/arch/ia64/sn/kernel/msi_sn.c
index b3a435f..31fbb85 100644
--- a/arch/ia64/sn/kernel/msi_sn.c
+++ b/arch/ia64/sn/kernel/msi_sn.c
@@ -74,7 +74,7 @@ int sn_setup_msi_irq(unsigned int irq, struct pci_dev *pdev)
 	struct pcibus_bussoft *bussoft = SN_PCIDEV_BUSSOFT(pdev);
 	struct sn_pcibus_provider *provider = SN_PCIDEV_BUSPROVIDER(pdev);
 
-	entry = get_irq_data(irq);
+	entry = get_irq_msi(irq);
 	if (!entry->msi_attrib.is_64)
 		return -EINVAL;
 
diff --git a/drivers/pci/msi.c b/drivers/pci/msi.c
index b994012..d7a2259 100644
--- a/drivers/pci/msi.c
+++ b/drivers/pci/msi.c
@@ -24,7 +24,6 @@
 #include "pci.h"
 #include "msi.h"
 
-static struct msi_desc* msi_desc[NR_IRQS] = { [0 ... NR_IRQS-1] = NULL };
 static struct kmem_cache* msi_cachep;
 
 static int pci_msi_enable = 1;
@@ -43,7 +42,7 @@ static void msi_set_mask_bit(unsigned int irq, int flag)
 {
 	struct msi_desc *entry;
 
-	entry = msi_desc[irq];
+	entry = get_irq_msi(irq);
 	BUG_ON(!entry || !entry->dev);
 	switch (entry->msi_attrib.type) {
 	case PCI_CAP_ID_MSI:
@@ -73,7 +72,7 @@ static void msi_set_mask_bit(unsigned int irq, int flag)
 
 void read_msi_msg(unsigned int irq, struct msi_msg *msg)
 {
-	struct msi_desc *entry = get_irq_data(irq);
+	struct msi_desc *entry = get_irq_msi(irq);
 	switch(entry->msi_attrib.type) {
 	case PCI_CAP_ID_MSI:
 	{
@@ -112,7 +111,7 @@ void read_msi_msg(unsigned int irq, struct msi_msg *msg)
 
 void write_msi_msg(unsigned int irq, struct msi_msg *msg)
 {
-	struct msi_desc *entry = get_irq_data(irq);
+	struct msi_desc *entry = get_irq_msi(irq);
 	switch (entry->msi_attrib.type) {
 	case PCI_CAP_ID_MSI:
 	{
@@ -208,7 +207,7 @@ static int create_msi_irq(void)
 		return -EBUSY;
 	}
 
-	set_irq_data(irq, entry);
+	set_irq_msi(irq, entry);
 
 	return irq;
 }
@@ -217,9 +216,9 @@ static void destroy_msi_irq(unsigned int irq)
 {
 	struct msi_desc *entry;
 
-	entry = get_irq_data(irq);
+	entry = get_irq_msi(irq);
 	set_irq_chip(irq, NULL);
-	set_irq_data(irq, NULL);
+	set_irq_msi(irq, NULL);
 	destroy_irq(irq);
 	kmem_cache_free(msi_cachep, entry);
 }
@@ -371,10 +370,10 @@ static int __pci_save_msix_state(struct pci_dev *dev)
 	while (head != tail) {
 		struct msi_desc *entry;
 
-		entry = msi_desc[irq];
+		entry = get_irq_msi(irq);
 		read_msi_msg(irq, &entry->msg_save);
 
-		tail = msi_desc[irq]->link.tail;
+		tail = entry->link.tail;
 		irq = tail;
 	}
 
@@ -421,10 +420,10 @@ static void __pci_restore_msix_state(struct pci_dev *dev)
 	/* route the table */
 	irq = head = dev->first_msi_irq;
 	while (head != tail) {
-		entry = msi_desc[irq];
+		entry = get_irq_msi(irq);
 		write_msi_msg(irq, &entry->msg_save);
 
-		tail = msi_desc[irq]->link.tail;
+		tail = entry->link.tail;
 		irq = tail;
 	}
 
@@ -462,7 +461,7 @@ static int msi_capability_init(struct pci_dev *dev)
 	if (irq < 0)
 		return irq;
 
-	entry = get_irq_data(irq);
+	entry = get_irq_msi(irq);
 	entry->link.head = irq;
 	entry->link.tail = irq;
 	entry->msi_attrib.type = PCI_CAP_ID_MSI;
@@ -497,7 +496,7 @@ static int msi_capability_init(struct pci_dev *dev)
 	}
 
 	dev->first_msi_irq = irq;
-	msi_desc[irq] = entry;
+	set_irq_msi(irq, entry);
 	/* Set MSI enabled bits	 */
 	enable_msi_mode(dev, pos, PCI_CAP_ID_MSI);
 
@@ -546,7 +545,7 @@ static int msix_capability_init(struct pci_dev *dev,
 		if (irq < 0)
 			break;
 
-		entry = get_irq_data(irq);
+		entry = get_irq_msi(irq);
  		j = entries[i].entry;
  		entries[i].vector = irq;
 		entry->msi_attrib.type = PCI_CAP_ID_MSIX;
@@ -576,7 +575,7 @@ static int msix_capability_init(struct pci_dev *dev,
 			break;
 		}
 
-		msi_desc[irq] = entry;
+		set_irq_msi(irq, entry);
 	}
 	if (i != nvec) {
 		int avail = i - 1;
@@ -693,7 +692,7 @@ void pci_disable_msi(struct pci_dev* dev)
 
 	disable_msi_mode(dev, pos, PCI_CAP_ID_MSI);
 
-	entry = msi_desc[dev->first_msi_irq];
+	entry = get_irq_msi(dev->first_msi_irq);
 	if (!entry || !entry->dev || entry->msi_attrib.type != PCI_CAP_ID_MSI) {
 		return;
 	}
@@ -720,7 +719,7 @@ static int msi_free_irq(struct pci_dev* dev, int irq)
 
 	arch_teardown_msi_irq(irq);
 
-	entry = msi_desc[irq];
+	entry = get_irq_msi(irq);
 	if (!entry || entry->dev != dev) {
 		return -EINVAL;
 	}
@@ -728,10 +727,9 @@ static int msi_free_irq(struct pci_dev* dev, int irq)
 	entry_nr = entry->msi_attrib.entry_nr;
 	head = entry->link.head;
 	base = entry->mask_base;
-	msi_desc[entry->link.head]->link.tail = entry->link.tail;
-	msi_desc[entry->link.tail]->link.head = entry->link.head;
+	get_irq_msi(entry->link.head)->link.tail = entry->link.tail;
+	get_irq_msi(entry->link.tail)->link.head = entry->link.head;
 	entry->dev = NULL;
-	msi_desc[irq] = NULL;
 
 	destroy_msi_irq(irq);
 
@@ -832,7 +830,7 @@ void pci_disable_msix(struct pci_dev* dev)
 
 	irq = head = dev->first_msi_irq;
 	while (head != tail) {
-		tail = msi_desc[irq]->link.tail;
+		tail = get_irq_msi(irq)->link.tail;
 		if (irq_has_action(irq))
 			warning = 1;
 		else if (irq != head)	/* Release MSI-X irq */
@@ -878,8 +876,8 @@ void msi_remove_pci_irq_vectors(struct pci_dev* dev)
 
 		irq = head = dev->first_msi_irq;
 		while (head != tail) {
-			tail = msi_desc[irq]->link.tail;
-			base = msi_desc[irq]->mask_base;
+			tail = get_irq_msi(irq)->link.tail;
+			base = get_irq_msi(irq)->mask_base;
 			if (irq_has_action(irq))
 				warning = 1;
 			else if (irq != head) /* Release MSI-X irq */
diff --git a/include/linux/irq.h b/include/linux/irq.h
index 52fc405..5504b67 100644
--- a/include/linux/irq.h
+++ b/include/linux/irq.h
@@ -68,6 +68,7 @@ typedef	void fastcall (*irq_flow_handler_t)(unsigned int irq,
 #define IRQ_MOVE_PENDING	0x40000000	/* need to re-target IRQ destination */
 
 struct proc_dir_entry;
+struct msi_desc;
 
 /**
  * struct irq_chip - hardware interrupt chip descriptor
@@ -148,6 +149,7 @@ struct irq_chip {
 struct irq_desc {
 	irq_flow_handler_t	handle_irq;
 	struct irq_chip		*chip;
+	struct msi_desc		*msi_desc;
 	void			*handler_data;
 	void			*chip_data;
 	struct irqaction	*action;	/* IRQ action list */
@@ -373,10 +375,12 @@ extern int set_irq_chip(unsigned int irq, struct irq_chip *chip);
 extern int set_irq_data(unsigned int irq, void *data);
 extern int set_irq_chip_data(unsigned int irq, void *data);
 extern int set_irq_type(unsigned int irq, unsigned int type);
+extern int set_irq_msi(unsigned int irq, struct msi_desc *entry);
 
 #define get_irq_chip(irq)	(irq_desc[irq].chip)
 #define get_irq_chip_data(irq)	(irq_desc[irq].chip_data)
 #define get_irq_data(irq)	(irq_desc[irq].handler_data)
+#define get_irq_msi(irq)	(irq_desc[irq].msi_desc)
 
 #endif /* CONFIG_GENERIC_HARDIRQS */
 
diff --git a/kernel/irq/chip.c b/kernel/irq/chip.c
index d27b258..475e8a7 100644
--- a/kernel/irq/chip.c
+++ b/kernel/irq/chip.c
@@ -39,6 +39,7 @@ void dynamic_irq_init(unsigned int irq)
 	desc->chip = &no_irq_chip;
 	desc->handle_irq = handle_bad_irq;
 	desc->depth = 1;
+	desc->msi_desc = NULL;
 	desc->handler_data = NULL;
 	desc->chip_data = NULL;
 	desc->action = NULL;
@@ -74,6 +75,9 @@ void dynamic_irq_cleanup(unsigned int irq)
 		WARN_ON(1);
 		return;
 	}
+	desc->msi_desc = NULL;
+	desc->handler_data = NULL;
+	desc->chip_data = NULL;
 	desc->handle_irq = handle_bad_irq;
 	desc->chip = &no_irq_chip;
 	spin_unlock_irqrestore(&desc->lock, flags);
@@ -162,6 +166,30 @@ int set_irq_data(unsigned int irq, void *data)
 EXPORT_SYMBOL(set_irq_data);
 
 /**
+ *	set_irq_data - set irq type data for an irq
+ *	@irq:	Interrupt number
+ *	@data:	Pointer to interrupt specific data
+ *
+ *	Set the hardware irq controller data for an irq
+ */
+int set_irq_msi(unsigned int irq, struct msi_desc *entry)
+{
+	struct irq_desc *desc;
+	unsigned long flags;
+
+	if (irq >= NR_IRQS) {
+		printk(KERN_ERR
+		       "Trying to install msi data for IRQ%d\n", irq);
+		return -EINVAL;
+	}
+	desc = irq_desc + irq;
+	spin_lock_irqsave(&desc->lock, flags);
+	desc->msi_desc = entry;
+	spin_unlock_irqrestore(&desc->lock, flags);
+	return 0;
+}
+
+/**
  *	set_irq_chip_data - set irq chip data for an irq
  *	@irq:	Interrupt number
  *	@data:	Pointer to chip specific data
-- 
1.4.4.1.g278f

