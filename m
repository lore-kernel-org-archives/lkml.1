Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757162Ab0BQOf3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Feb 2010 09:35:29 -0500
Received: from www.tglx.de ([62.245.132.106]:46572 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752043Ab0BQOfZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Feb 2010 09:35:25 -0500
Message-Id: <20100217143453.570657459@linutronix.de>
User-Agent: quilt/0.47-1
Date: Wed, 17 Feb 2010 14:35:19 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: [patch 1/2] pci: Convert pci_lock to raw_spinlock
References: <20100217143401.673569070@linutronix.de>
Content-Disposition: inline; filename=0119.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

pci_lock must be a real spinlock in preempt-rt. Convert it to
raw_spinlock. No change for !RT kernels.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>

diff --git a/drivers/pci/access.c b/drivers/pci/access.c
index db23200..fddeb63 100644
--- a/drivers/pci/access.c
+++ b/drivers/pci/access.c
@@ -12,7 +12,7 @@
  * configuration space.
  */
 
-static DEFINE_SPINLOCK(pci_lock);
+static DEFINE_RAW_SPINLOCK(pci_lock);
 
 /*
  *  Wrappers for all PCI configuration access functions.  They just check
@@ -32,10 +32,10 @@ int pci_bus_read_config_##size \
 	unsigned long flags;						\
 	u32 data = 0;							\
 	if (PCI_##size##_BAD) return PCIBIOS_BAD_REGISTER_NUMBER;	\
-	spin_lock_irqsave(&pci_lock, flags);				\
+	raw_spin_lock_irqsave(&pci_lock, flags);			\
 	res = bus->ops->read(bus, devfn, pos, len, &data);		\
 	*value = (type)data;						\
-	spin_unlock_irqrestore(&pci_lock, flags);			\
+	raw_spin_unlock_irqrestore(&pci_lock, flags);		\
 	return res;							\
 }
 
@@ -46,9 +46,9 @@ int pci_bus_write_config_##size \
 	int res;							\
 	unsigned long flags;						\
 	if (PCI_##size##_BAD) return PCIBIOS_BAD_REGISTER_NUMBER;	\
-	spin_lock_irqsave(&pci_lock, flags);				\
+	raw_spin_lock_irqsave(&pci_lock, flags);			\
 	res = bus->ops->write(bus, devfn, pos, len, value);		\
-	spin_unlock_irqrestore(&pci_lock, flags);			\
+	raw_spin_unlock_irqrestore(&pci_lock, flags);		\
 	return res;							\
 }
 
@@ -78,10 +78,10 @@ struct pci_ops *pci_bus_set_ops(struct pci_bus *bus, struct pci_ops *ops)
 	struct pci_ops *old_ops;
 	unsigned long flags;
 
-	spin_lock_irqsave(&pci_lock, flags);
+	raw_spin_lock_irqsave(&pci_lock, flags);
 	old_ops = bus->ops;
 	bus->ops = ops;
-	spin_unlock_irqrestore(&pci_lock, flags);
+	raw_spin_unlock_irqrestore(&pci_lock, flags);
 	return old_ops;
 }
 EXPORT_SYMBOL(pci_bus_set_ops);
@@ -135,9 +135,9 @@ static noinline void pci_wait_ucfg(struct pci_dev *dev)
 	__add_wait_queue(&pci_ucfg_wait, &wait);
 	do {
 		set_current_state(TASK_UNINTERRUPTIBLE);
-		spin_unlock_irq(&pci_lock);
+		raw_spin_unlock_irq(&pci_lock);
 		schedule();
-		spin_lock_irq(&pci_lock);
+		raw_spin_lock_irq(&pci_lock);
 	} while (dev->block_ucfg_access);
 	__remove_wait_queue(&pci_ucfg_wait, &wait);
 }
@@ -149,11 +149,11 @@ int pci_user_read_config_##size						\
 	int ret = 0;							\
 	u32 data = -1;							\
 	if (PCI_##size##_BAD) return PCIBIOS_BAD_REGISTER_NUMBER;	\
-	spin_lock_irq(&pci_lock);					\
+	raw_spin_lock_irq(&pci_lock);				\
 	if (unlikely(dev->block_ucfg_access)) pci_wait_ucfg(dev);	\
 	ret = dev->bus->ops->read(dev->bus, dev->devfn,			\
 					pos, sizeof(type), &data);	\
-	spin_unlock_irq(&pci_lock);					\
+	raw_spin_unlock_irq(&pci_lock);				\
 	*val = (type)data;						\
 	return ret;							\
 }
@@ -164,11 +164,11 @@ int pci_user_write_config_##size					\
 {									\
 	int ret = -EIO;							\
 	if (PCI_##size##_BAD) return PCIBIOS_BAD_REGISTER_NUMBER;	\
-	spin_lock_irq(&pci_lock);					\
+	raw_spin_lock_irq(&pci_lock);				\
 	if (unlikely(dev->block_ucfg_access)) pci_wait_ucfg(dev);	\
 	ret = dev->bus->ops->write(dev->bus, dev->devfn,		\
 					pos, sizeof(type), val);	\
-	spin_unlock_irq(&pci_lock);					\
+	raw_spin_unlock_irq(&pci_lock);				\
 	return ret;							\
 }
 
@@ -395,10 +395,10 @@ void pci_block_user_cfg_access(struct pci_dev *dev)
 	unsigned long flags;
 	int was_blocked;
 
-	spin_lock_irqsave(&pci_lock, flags);
+	raw_spin_lock_irqsave(&pci_lock, flags);
 	was_blocked = dev->block_ucfg_access;
 	dev->block_ucfg_access = 1;
-	spin_unlock_irqrestore(&pci_lock, flags);
+	raw_spin_unlock_irqrestore(&pci_lock, flags);
 
 	/* If we BUG() inside the pci_lock, we're guaranteed to hose
 	 * the machine */
@@ -416,7 +416,7 @@ void pci_unblock_user_cfg_access(struct pci_dev *dev)
 {
 	unsigned long flags;
 
-	spin_lock_irqsave(&pci_lock, flags);
+	raw_spin_lock_irqsave(&pci_lock, flags);
 
 	/* This indicates a problem in the caller, but we don't need
 	 * to kill them, unlike a double-block above. */
@@ -424,6 +424,6 @@ void pci_unblock_user_cfg_access(struct pci_dev *dev)
 
 	dev->block_ucfg_access = 0;
 	wake_up_all(&pci_ucfg_wait);
-	spin_unlock_irqrestore(&pci_lock, flags);
+	raw_spin_unlock_irqrestore(&pci_lock, flags);
 }
 EXPORT_SYMBOL_GPL(pci_unblock_user_cfg_access);


