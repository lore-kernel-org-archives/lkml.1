Return-Path: <linux-kernel-owner+w=401wt.eu-S1757092AbZBDSZd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757092AbZBDSZd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Feb 2009 13:25:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752026AbZBDSZY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Feb 2009 13:25:24 -0500
Received: from g5t0009.atlanta.hp.com ([15.192.0.46]:30175 "EHLO
	g5t0009.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751771AbZBDSZX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Feb 2009 13:25:23 -0500
Date: Wed, 4 Feb 2009 11:25:22 -0700
From: Alex Chiang <achiang@hp.com>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: Andrew Patterson <andrew.patterson@hp.com>, linux-pci@vger.kernel.org,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH] PCI: enhance physical slot debug information
Message-ID: <20090204182522.GA22419@ldl.fc.hp.com>
Mail-Followup-To: Alex Chiang <achiang@hp.com>,
	Jesse Barnes <jbarnes@virtuousgeek.org>,
	Andrew Patterson <andrew.patterson@hp.com>,
	linux-pci@vger.kernel.org,
	linux-kernel <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Convert usages of pr_debug to dev_dbg and add physical slot name.

Note that we use dev_dbg on the struct pci_bus and still manually
print out the PCI slot number (instead of calling dev_dbg on a
pci_dev) because a struct pci_bus with empty physical slots will
not have any pci_devs.

Reviewed-by: Andrew Patterson <andrew.patterson@hp.com>
Signed-off-by: Alex Chiang <achiang@hp.com>
---
Jesse, since this is all under #ifdef DEBUG, it's your call
whether you want to queue it for .29 or .30. Doesn't matter much
to us either way, thanks.
---
 slot.c |   18 ++++++++----------
 1 file changed, 8 insertions(+), 10 deletions(-)

diff --git a/drivers/pci/slot.c b/drivers/pci/slot.c
index 5a8ccb4..2118944 100644
--- a/drivers/pci/slot.c
+++ b/drivers/pci/slot.c
@@ -1,8 +1,8 @@
 /*
  * drivers/pci/slot.c
  * Copyright (C) 2006 Matthew Wilcox <matthew@wil.cx>
- * Copyright (C) 2006-2008 Hewlett-Packard Development Company, L.P.
- * 	Alex Chiang <achiang@hp.com>
+ * Copyright (C) 2006-2009 Hewlett-Packard Development Company, L.P.
+ *	Alex Chiang <achiang@hp.com>
  */
 
 #include <linux/kobject.h>
@@ -52,8 +52,8 @@ static void pci_slot_release(struct kobject *kobj)
 	struct pci_dev *dev;
 	struct pci_slot *slot = to_pci_slot(kobj);
 
-	pr_debug("%s: releasing pci_slot on %x:%d\n", __func__,
-		 slot->bus->number, slot->number);
+	dev_dbg(&slot->bus->dev, "dev %02x, released physical slot %s\n",
+		slot->number, pci_slot_name(slot));
 
 	list_for_each_entry(dev, &slot->bus->devices, bus_list)
 		if (PCI_SLOT(dev->devfn) == slot->number)
@@ -248,9 +248,8 @@ placeholder:
 		if (PCI_SLOT(dev->devfn) == slot_nr)
 			dev->slot = slot;
 
-	/* Don't care if debug printk has a -1 for slot_nr */
-	pr_debug("%s: created pci_slot on %04x:%02x:%02x\n",
-		 __func__, pci_domain_nr(parent), parent->number, slot_nr);
+	dev_dbg(&parent->dev, "dev %02x, created physical slot %s\n",
+		slot_nr, pci_slot_name(slot));
 
 out:
 	kfree(slot_name);
@@ -299,9 +298,8 @@ EXPORT_SYMBOL_GPL(pci_renumber_slot);
  */
 void pci_destroy_slot(struct pci_slot *slot)
 {
-	pr_debug("%s: dec refcount to %d on %04x:%02x:%02x\n", __func__,
-		 atomic_read(&slot->kobj.kref.refcount) - 1,
-		 pci_domain_nr(slot->bus), slot->bus->number, slot->number);
+	dev_dbg(&slot->bus->dev, "dev %02x, dec refcount to %d\n",
+		slot->number, atomic_read(&slot->kobj.kref.refcount) - 1);
 
 	down_write(&pci_bus_sem);
 	kobject_put(&slot->kobj);
