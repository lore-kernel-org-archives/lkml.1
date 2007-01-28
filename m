Return-Path: <linux-kernel-owner+w=401wt.eu-S932799AbXA1TpH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932799AbXA1TpH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Jan 2007 14:45:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932820AbXA1TpH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Jan 2007 14:45:07 -0500
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:42350 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932803AbXA1TpE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Jan 2007 14:45:04 -0500
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
Subject: [PATCH 2/6] msi: Remove msi_lock.
References: <1169714047.65693.647693675533.qpush@cradle>
	<m1hcubq6re.fsf@ebiederm.dsl.xmission.com>
	<m1d54zq6o3.fsf_-_@ebiederm.dsl.xmission.com>
Date: Sun, 28 Jan 2007 12:44:21 -0700
In-Reply-To: <m1d54zq6o3.fsf_-_@ebiederm.dsl.xmission.com> (Eric
	W. Biederman's message of "Sun, 28 Jan 2007 12:42:52 -0700")
Message-ID: <m18xfnq6lm.fsf_-_@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


With the removal of msi_lookup_irq all of the functions using msi_lock
operated on a single device and none of them could reasonably be
called on that device at the same time. 

Since what little synchronization that needs to happen needs to happen
outside of the msi functions, msi_lock could never be contended and as
such is useless and just complicates the code.

Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
---
 drivers/pci/msi.c |   20 --------------------
 1 files changed, 0 insertions(+), 20 deletions(-)

diff --git a/drivers/pci/msi.c b/drivers/pci/msi.c
index 71080c9..5e7a187 100644
--- a/drivers/pci/msi.c
+++ b/drivers/pci/msi.c
@@ -24,7 +24,6 @@
 #include "pci.h"
 #include "msi.h"
 
-static DEFINE_SPINLOCK(msi_lock);
 static struct msi_desc* msi_desc[NR_IRQS] = { [0 ... NR_IRQS-1] = NULL };
 static struct kmem_cache* msi_cachep;
 
@@ -196,11 +195,7 @@ static struct msi_desc* alloc_msi_entry(void)
 
 static void attach_msi_entry(struct msi_desc *entry, int irq)
 {
-	unsigned long flags;
-
-	spin_lock_irqsave(&msi_lock, flags);
 	msi_desc[irq] = entry;
-	spin_unlock_irqrestore(&msi_lock, flags);
 }
 
 static int create_msi_irq(void)
@@ -683,7 +678,6 @@ void pci_disable_msi(struct pci_dev* dev)
 	struct msi_desc *entry;
 	int pos, default_irq;
 	u16 control;
-	unsigned long flags;
 
 	if (!pci_msi_enable)
 		return;
@@ -704,21 +698,17 @@ void pci_disable_msi(struct pci_dev* dev)
 
 	disable_msi_mode(dev, pos, PCI_CAP_ID_MSI);
 
-	spin_lock_irqsave(&msi_lock, flags);
 	entry = msi_desc[dev->first_msi_irq];
 	if (!entry || !entry->dev || entry->msi_attrib.type != PCI_CAP_ID_MSI) {
-		spin_unlock_irqrestore(&msi_lock, flags);
 		return;
 	}
 	if (irq_has_action(dev->first_msi_irq)) {
-		spin_unlock_irqrestore(&msi_lock, flags);
 		printk(KERN_WARNING "PCI: %s: pci_disable_msi() called without "
 		       "free_irq() on MSI irq %d\n",
 		       pci_name(dev), dev->first_msi_irq);
 		BUG_ON(irq_has_action(dev->first_msi_irq));
 	} else {
 		default_irq = entry->msi_attrib.default_irq;
-		spin_unlock_irqrestore(&msi_lock, flags);
 		msi_free_irq(dev, dev->first_msi_irq);
 
 		/* Restore dev->irq to its default pin-assertion irq */
@@ -732,14 +722,11 @@ static int msi_free_irq(struct pci_dev* dev, int irq)
 	struct msi_desc *entry;
 	int head, entry_nr, type;
 	void __iomem *base;
-	unsigned long flags;
 
 	arch_teardown_msi_irq(irq);
 
-	spin_lock_irqsave(&msi_lock, flags);
 	entry = msi_desc[irq];
 	if (!entry || entry->dev != dev) {
-		spin_unlock_irqrestore(&msi_lock, flags);
 		return -EINVAL;
 	}
 	type = entry->msi_attrib.type;
@@ -750,7 +737,6 @@ static int msi_free_irq(struct pci_dev* dev, int irq)
 	msi_desc[entry->link.tail]->link.head = entry->link.head;
 	entry->dev = NULL;
 	msi_desc[irq] = NULL;
-	spin_unlock_irqrestore(&msi_lock, flags);
 
 	destroy_msi_irq(irq);
 
@@ -828,7 +814,6 @@ int pci_enable_msix(struct pci_dev* dev, struct msix_entry *entries, int nvec)
 void pci_disable_msix(struct pci_dev* dev)
 {
 	int irq, head, tail = 0, warning = 0;
-	unsigned long flags;
 	int pos;
 	u16 control;
 
@@ -852,9 +837,7 @@ void pci_disable_msix(struct pci_dev* dev)
 
 	irq = head = dev->first_msi_irq;
 	while (head != tail) {
-		spin_lock_irqsave(&msi_lock, flags);
 		tail = msi_desc[irq]->link.tail;
-		spin_unlock_irqrestore(&msi_lock, flags);
 		if (irq_has_action(irq))
 			warning = 1;
 		else if (irq != head)	/* Release MSI-X irq */
@@ -883,7 +866,6 @@ void pci_disable_msix(struct pci_dev* dev)
 void msi_remove_pci_irq_vectors(struct pci_dev* dev)
 {
 	int pos;
-	unsigned long flags;
 
 	if (!pci_msi_enable || !dev)
  		return;
@@ -905,10 +887,8 @@ void msi_remove_pci_irq_vectors(struct pci_dev* dev)
 
 		irq = head = dev->first_msi_irq;
 		while (head != tail) {
-			spin_lock_irqsave(&msi_lock, flags);
 			tail = msi_desc[irq]->link.tail;
 			base = msi_desc[irq]->mask_base;
-			spin_unlock_irqrestore(&msi_lock, flags);
 			if (irq_has_action(irq))
 				warning = 1;
 			else if (irq != head) /* Release MSI-X irq */
-- 
1.4.4.1.g278f

