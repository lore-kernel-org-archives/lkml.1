Return-Path: <linux-kernel-owner+w=401wt.eu-S935734AbYBOAsp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935734AbYBOAsp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2008 19:48:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934970AbYBOAnA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Feb 2008 19:43:00 -0500
Received: from cantor2.suse.de ([195.135.220.15]:54125 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934945AbYBOAm6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2008 19:42:58 -0500
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-pci@atrey.karlin.mff.cuni.cz
Cc: linux-kernel@vger.kernel.org, pcihpd-discuss@lists.sourceforge.net,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 12/12] PCI: remove global list of PCI devices
Date: Thu, 14 Feb 2008 16:40:10 -0800
Message-Id: <1203036010-27988-12-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.5.4
In-Reply-To: <20080215003909.GA27981@kroah.com>
References: <20080215003909.GA27981@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch finally removes the global list of PCI devices.  We are
relying entirely on the list held in the driver core now, and do not
need a separate "shadow" list as no one uses it.

Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/pci/bus.c    |    4 ----
 drivers/pci/probe.c  |   39 +--------------------------------------
 drivers/pci/remove.c |    4 ----
 include/linux/pci.h  |    3 ---
 4 files changed, 1 insertions(+), 49 deletions(-)

diff --git a/drivers/pci/bus.c b/drivers/pci/bus.c
index f2eae65..2a3ad5d 100644
--- a/drivers/pci/bus.c
+++ b/drivers/pci/bus.c
@@ -85,10 +85,6 @@ int pci_bus_add_device(struct pci_dev *dev)
 		return retval;
 
 	dev->is_added = 1;
-	down_write(&pci_bus_sem);
-	list_add_tail(&dev->global_list, &pci_devices);
-	up_write(&pci_bus_sem);
-
 	pci_proc_attach_device(dev);
 	pci_create_sysfs_dev_files(dev);
 	return 0;
diff --git a/drivers/pci/probe.c b/drivers/pci/probe.c
index 7a1efc1..1076876 100644
--- a/drivers/pci/probe.c
+++ b/drivers/pci/probe.c
@@ -20,8 +20,6 @@
 LIST_HEAD(pci_root_buses);
 EXPORT_SYMBOL(pci_root_buses);
 
-LIST_HEAD(pci_devices);
-
 
 static int find_anything(struct device *dev, void *data)
 {
@@ -860,7 +858,6 @@ struct pci_dev *alloc_pci_dev(void)
 	if (!dev)
 		return NULL;
 
-	INIT_LIST_HEAD(&dev->global_list);
 	INIT_LIST_HEAD(&dev->bus_list);
 
 	pci_msi_init_pci_dev(dev);
@@ -957,7 +954,6 @@ void pci_device_add(struct pci_dev *dev, struct pci_bus *bus)
 	 * Add the device to our list of discovered devices
 	 * and the bus list for fixup functions, etc.
 	 */
-	INIT_LIST_HEAD(&dev->global_list);
 	down_write(&pci_bus_sem);
 	list_add_tail(&dev->bus_list, &bus->devices);
 	up_write(&pci_bus_sem);
@@ -1186,7 +1182,7 @@ static void __init pci_insertion_sort_klist(struct pci_dev *a, struct list_head
 	list_move_tail(&a->dev.knode_bus.n_node, list);
 }
 
-static void __init pci_sort_breadthfirst_klist(void)
+void __init pci_sort_breadthfirst(void)
 {
 	LIST_HEAD(sorted_devices);
 	struct list_head *pos, *tmp;
@@ -1207,36 +1203,3 @@ static void __init pci_sort_breadthfirst_klist(void)
 	list_splice(&sorted_devices, &device_klist->k_list);
 	spin_unlock(&device_klist->k_lock);
 }
-
-static void __init pci_insertion_sort_devices(struct pci_dev *a, struct list_head *list)
-{
-	struct pci_dev *b;
-
-	list_for_each_entry(b, list, global_list) {
-		if (pci_sort_bf_cmp(a, b) <= 0) {
-			list_move_tail(&a->global_list, &b->global_list);
-			return;
-		}
-	}
-	list_move_tail(&a->global_list, list);
-}
-
-static void __init pci_sort_breadthfirst_devices(void)
-{
-	LIST_HEAD(sorted_devices);
-	struct pci_dev *dev, *tmp;
-
-	down_write(&pci_bus_sem);
-	list_for_each_entry_safe(dev, tmp, &pci_devices, global_list) {
-		pci_insertion_sort_devices(dev, &sorted_devices);
-	}
-	list_splice(&sorted_devices, &pci_devices);
-	up_write(&pci_bus_sem);
-}
-
-void __init pci_sort_breadthfirst(void)
-{
-	pci_sort_breadthfirst_devices();
-	pci_sort_breadthfirst_klist();
-}
-
diff --git a/drivers/pci/remove.c b/drivers/pci/remove.c
index d3c77cb..b682483 100644
--- a/drivers/pci/remove.c
+++ b/drivers/pci/remove.c
@@ -23,10 +23,6 @@ static void pci_stop_dev(struct pci_dev *dev)
 		pci_remove_sysfs_dev_files(dev);
 		device_unregister(&dev->dev);
 		dev->is_added = 0;
-		down_write(&pci_bus_sem);
-		list_del(&dev->global_list);
-		dev->global_list.next = dev->global_list.prev = NULL;
-		up_write(&pci_bus_sem);
 	}
 }
 
diff --git a/include/linux/pci.h b/include/linux/pci.h
index b567d37..511edbf 100644
--- a/include/linux/pci.h
+++ b/include/linux/pci.h
@@ -132,7 +132,6 @@ struct pci_cap_saved_state {
  * The pci_dev structure is used to describe PCI devices.
  */
 struct pci_dev {
-	struct list_head global_list;	/* node in list of all PCI devices */
 	struct list_head bus_list;	/* node in per-bus list */
 	struct pci_bus	*bus;		/* bus this device is on */
 	struct pci_bus	*subordinate;	/* bus this device bridges to */
@@ -206,7 +205,6 @@ struct pci_dev {
 
 extern struct pci_dev *alloc_pci_dev(void);
 
-#define pci_dev_g(n) list_entry(n, struct pci_dev, global_list)
 #define pci_dev_b(n) list_entry(n, struct pci_dev, bus_list)
 #define	to_pci_dev(n) container_of(n, struct pci_dev, dev)
 #define for_each_pci_dev(d) while ((d = pci_get_device(PCI_ANY_ID, PCI_ANY_ID, d)) != NULL)
@@ -439,7 +437,6 @@ extern struct bus_type pci_bus_type;
 /* Do NOT directly access these two variables, unless you are arch specific pci
  * code, or pci core code. */
 extern struct list_head pci_root_buses;	/* list of all known PCI buses */
-extern struct list_head pci_devices;	/* list of all devices */
 /* Some device drivers need know if pci is initiated */
 extern int no_pci_devices(void);
 
-- 
1.5.4

