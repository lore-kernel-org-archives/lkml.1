Return-Path: <linux-kernel-owner+w=401wt.eu-S1753987Ab0AKV2F@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753987Ab0AKV2F (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jan 2010 16:28:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752932Ab0AKV1u
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Jan 2010 16:27:50 -0500
Received: from ey-out-2122.google.com ([74.125.78.24]:34876 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752379Ab0AKV1q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jan 2010 16:27:46 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer:in-reply-to
         :references;
        b=qWDIPW0vOjKl40+qX0FQMVtb2tDVCeEiE3lA8IGFHgE873yki/mMF4wDD1u+LNmKqV
         8Vb5ZWZT1WMFfICCrKAMw+qizy20+JOa5EBrUhU/EkeXW0vPHgdQXGmy6sIZV8CaSDFh
         OcncZl/9e3BhmlRC8PmZAX2ygS2c43Zc8S0dw=
From: John Kacur <jkacur@redhat.com>
To: Thomas Gleixner <tglx@linutronix.de>, lkml <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>
Cc: Clark Williams <williams@redhat.com>, John Kacur <jkacur@redhat.com>
Subject: [PATCH 24/26] pci-access: Convert pci_lock to raw_spinlock
Date: Mon, 11 Jan 2010 22:26:54 +0100
Message-Id: <1263245216-14754-25-git-send-email-jkacur@redhat.com>
X-Mailer: git-send-email 1.6.5.2
In-Reply-To: <1263245216-14754-24-git-send-email-jkacur@redhat.com>
References: <1263245216-14754-1-git-send-email-jkacur@redhat.com>
 <1263245216-14754-2-git-send-email-jkacur@redhat.com>
 <1263245216-14754-3-git-send-email-jkacur@redhat.com>
 <1263245216-14754-4-git-send-email-jkacur@redhat.com>
 <1263245216-14754-5-git-send-email-jkacur@redhat.com>
 <1263245216-14754-6-git-send-email-jkacur@redhat.com>
 <1263245216-14754-7-git-send-email-jkacur@redhat.com>
 <1263245216-14754-8-git-send-email-jkacur@redhat.com>
 <1263245216-14754-9-git-send-email-jkacur@redhat.com>
 <1263245216-14754-10-git-send-email-jkacur@redhat.com>
 <1263245216-14754-11-git-send-email-jkacur@redhat.com>
 <1263245216-14754-12-git-send-email-jkacur@redhat.com>
 <1263245216-14754-13-git-send-email-jkacur@redhat.com>
 <1263245216-14754-14-git-send-email-jkacur@redhat.com>
 <1263245216-14754-15-git-send-email-jkacur@redhat.com>
 <1263245216-14754-16-git-send-email-jkacur@redhat.com>
 <1263245216-14754-17-git-send-email-jkacur@redhat.com>
 <1263245216-14754-18-git-send-email-jkacur@redhat.com>
 <1263245216-14754-19-git-send-email-jkacur@redhat.com>
 <1263245216-14754-20-git-send-email-jkacur@redhat.com>
 <1263245216-14754-21-git-send-email-jkacur@redhat.com>
 <1263245216-14754-22-git-send-email-jkacur@redhat.com>
 <1263245216-14754-23-git-send-email-jkacur@redhat.com>
 <1263245216-14754-24-git-send-email-jkacur@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Convert locks which cannot be sleeping locks in preempt-rt to raw_spinlocks.

See also b68d8890994c099f089ab36eb55302fdc1884612

Signed-off-by: John Kacur <jkacur@redhat.com>
---
 drivers/pci/access.c |   34 +++++++++++++++++-----------------
 1 files changed, 17 insertions(+), 17 deletions(-)

diff --git a/drivers/pci/access.c b/drivers/pci/access.c
index db23200..b54f7a4 100644
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
+	raw_spin_lock_irqsave(&pci_lock, flags);				\
 	res = bus->ops->read(bus, devfn, pos, len, &data);		\
 	*value = (type)data;						\
-	spin_unlock_irqrestore(&pci_lock, flags);			\
+	raw_spin_unlock_irqrestore(&pci_lock, flags);			\
 	return res;							\
 }
 
@@ -46,9 +46,9 @@ int pci_bus_write_config_##size \
 	int res;							\
 	unsigned long flags;						\
 	if (PCI_##size##_BAD) return PCIBIOS_BAD_REGISTER_NUMBER;	\
-	spin_lock_irqsave(&pci_lock, flags);				\
+	raw_spin_lock_irqsave(&pci_lock, flags);				\
 	res = bus->ops->write(bus, devfn, pos, len, value);		\
-	spin_unlock_irqrestore(&pci_lock, flags);			\
+	raw_spin_unlock_irqrestore(&pci_lock, flags);			\
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
+	raw_spin_lock_irq(&pci_lock);					\
 	if (unlikely(dev->block_ucfg_access)) pci_wait_ucfg(dev);	\
 	ret = dev->bus->ops->read(dev->bus, dev->devfn,			\
 					pos, sizeof(type), &data);	\
-	spin_unlock_irq(&pci_lock);					\
+	raw_spin_unlock_irq(&pci_lock);					\
 	*val = (type)data;						\
 	return ret;							\
 }
@@ -164,11 +164,11 @@ int pci_user_write_config_##size					\
 {									\
 	int ret = -EIO;							\
 	if (PCI_##size##_BAD) return PCIBIOS_BAD_REGISTER_NUMBER;	\
-	spin_lock_irq(&pci_lock);					\
+	raw_spin_lock_irq(&pci_lock);					\
 	if (unlikely(dev->block_ucfg_access)) pci_wait_ucfg(dev);	\
 	ret = dev->bus->ops->write(dev->bus, dev->devfn,		\
 					pos, sizeof(type), val);	\
-	spin_unlock_irq(&pci_lock);					\
+	raw_spin_unlock_irq(&pci_lock);					\
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
-- 
1.6.5.2

