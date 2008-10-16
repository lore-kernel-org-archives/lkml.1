Return-Path: <linux-kernel-owner+w=401wt.eu-S1758281AbYJPRa3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758281AbYJPRa3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2008 13:30:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756532AbYJPRPG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Oct 2008 13:15:06 -0400
Received: from kroah.org ([198.145.64.141]:47043 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755670AbYJPRPE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2008 13:15:04 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 42/46] Driver core: add bus_sort_breadthfirst() function
Date: Thu, 16 Oct 2008 10:10:43 -0700
Message-Id: <1224177047-11859-42-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.6.0.2
In-Reply-To: <20081016170954.GA11824@kroah.com>
References: <20081016170954.GA11824@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The PCI core wants to reorder the devices in the bus list.  So move this
functionality out of the pci core and into the driver core so that
anyone else can also do this if needed.  This also lets us change how
struct device is attached to drivers in the future without messing with
the PCI core.

Acked-by: Jesse Barnes <jbarnes@virtuousgeek.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/base/bus.c     |   50 ++++++++++++++++++++++++++++++++++++++++++++++++
 drivers/pci/probe.c    |   50 ++++-------------------------------------------
 include/linux/device.h |    3 ++
 3 files changed, 58 insertions(+), 45 deletions(-)

diff --git a/drivers/base/bus.c b/drivers/base/bus.c
index 39b9b58..5aee1c0 100644
--- a/drivers/base/bus.c
+++ b/drivers/base/bus.c
@@ -980,6 +980,56 @@ struct klist *bus_get_device_klist(struct bus_type *bus)
 }
 EXPORT_SYMBOL_GPL(bus_get_device_klist);
 
+/*
+ * Yes, this forcably breaks the klist abstraction temporarily.  It
+ * just wants to sort the klist, not change reference counts and
+ * take/drop locks rapidly in the process.  It does all this while
+ * holding the lock for the list, so objects can't otherwise be
+ * added/removed while we're swizzling.
+ */
+static void device_insertion_sort_klist(struct device *a, struct list_head *list,
+					int (*compare)(const struct device *a,
+							const struct device *b))
+{
+	struct list_head *pos;
+	struct klist_node *n;
+	struct device *b;
+
+	list_for_each(pos, list) {
+		n = container_of(pos, struct klist_node, n_node);
+		b = container_of(n, struct device, knode_bus);
+		if (compare(a, b) <= 0) {
+			list_move_tail(&a->knode_bus.n_node,
+				       &b->knode_bus.n_node);
+			return;
+		}
+	}
+	list_move_tail(&a->knode_bus.n_node, list);
+}
+
+void bus_sort_breadthfirst(struct bus_type *bus,
+			   int (*compare)(const struct device *a,
+					  const struct device *b))
+{
+	LIST_HEAD(sorted_devices);
+	struct list_head *pos, *tmp;
+	struct klist_node *n;
+	struct device *dev;
+	struct klist *device_klist;
+
+	device_klist = bus_get_device_klist(bus);
+
+	spin_lock(&device_klist->k_lock);
+	list_for_each_safe(pos, tmp, &device_klist->k_list) {
+		n = container_of(pos, struct klist_node, n_node);
+		dev = container_of(n, struct device, knode_bus);
+		device_insertion_sort_klist(dev, &sorted_devices, compare);
+	}
+	list_splice(&sorted_devices, &device_klist->k_list);
+	spin_unlock(&device_klist->k_lock);
+}
+EXPORT_SYMBOL_GPL(bus_sort_breadthfirst);
+
 int __init buses_init(void)
 {
 	bus_kset = kset_create_and_add("bus", &bus_uevent_ops, NULL);
diff --git a/drivers/pci/probe.c b/drivers/pci/probe.c
index 36698e5..dd9161a 100644
--- a/drivers/pci/probe.c
+++ b/drivers/pci/probe.c
@@ -1237,8 +1237,11 @@ EXPORT_SYMBOL(pci_scan_bridge);
 EXPORT_SYMBOL_GPL(pci_scan_child_bus);
 #endif
 
-static int __init pci_sort_bf_cmp(const struct pci_dev *a, const struct pci_dev *b)
+static int __init pci_sort_bf_cmp(const struct device *d_a, const struct device *d_b)
 {
+	const struct pci_dev *a = to_pci_dev(d_a);
+	const struct pci_dev *b = to_pci_dev(d_b);
+
 	if      (pci_domain_nr(a->bus) < pci_domain_nr(b->bus)) return -1;
 	else if (pci_domain_nr(a->bus) > pci_domain_nr(b->bus)) return  1;
 
@@ -1251,50 +1254,7 @@ static int __init pci_sort_bf_cmp(const struct pci_dev *a, const struct pci_dev
 	return 0;
 }
 
-/*
- * Yes, this forcably breaks the klist abstraction temporarily.  It
- * just wants to sort the klist, not change reference counts and
- * take/drop locks rapidly in the process.  It does all this while
- * holding the lock for the list, so objects can't otherwise be
- * added/removed while we're swizzling.
- */
-static void __init pci_insertion_sort_klist(struct pci_dev *a, struct list_head *list)
-{
-	struct list_head *pos;
-	struct klist_node *n;
-	struct device *dev;
-	struct pci_dev *b;
-
-	list_for_each(pos, list) {
-		n = container_of(pos, struct klist_node, n_node);
-		dev = container_of(n, struct device, knode_bus);
-		b = to_pci_dev(dev);
-		if (pci_sort_bf_cmp(a, b) <= 0) {
-			list_move_tail(&a->dev.knode_bus.n_node, &b->dev.knode_bus.n_node);
-			return;
-		}
-	}
-	list_move_tail(&a->dev.knode_bus.n_node, list);
-}
-
 void __init pci_sort_breadthfirst(void)
 {
-	LIST_HEAD(sorted_devices);
-	struct list_head *pos, *tmp;
-	struct klist_node *n;
-	struct device *dev;
-	struct pci_dev *pdev;
-	struct klist *device_klist;
-
-	device_klist = bus_get_device_klist(&pci_bus_type);
-
-	spin_lock(&device_klist->k_lock);
-	list_for_each_safe(pos, tmp, &device_klist->k_list) {
-		n = container_of(pos, struct klist_node, n_node);
-		dev = container_of(n, struct device, knode_bus);
-		pdev = to_pci_dev(dev);
-		pci_insertion_sort_klist(pdev, &sorted_devices);
-	}
-	list_splice(&sorted_devices, &device_klist->k_list);
-	spin_unlock(&device_klist->k_lock);
+	bus_sort_breadthfirst(&pci_bus_type, &pci_sort_bf_cmp);
 }
diff --git a/include/linux/device.h b/include/linux/device.h
index ec90e79..987f591 100644
--- a/include/linux/device.h
+++ b/include/linux/device.h
@@ -90,6 +90,9 @@ int __must_check bus_for_each_drv(struct bus_type *bus,
 				  struct device_driver *start, void *data,
 				  int (*fn)(struct device_driver *, void *));
 
+void bus_sort_breadthfirst(struct bus_type *bus,
+			   int (*compare)(const struct device *a,
+					  const struct device *b));
 /*
  * Bus notifiers: Get notified of addition/removal of devices
  * and binding/unbinding of drivers to devices.
-- 
1.6.0.2

