Return-Path: <linux-kernel-owner+w=401wt.eu-S1763414AbXKCAKw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763414AbXKCAKw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Nov 2007 20:10:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761721AbXKCACO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Nov 2007 20:02:14 -0400
Received: from cantor.suse.de ([195.135.220.2]:41176 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761995AbXKCACM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Nov 2007 20:02:12 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@suse.de>, Kay Sievers <kay.sievers@vrfy.org>
Subject: [PATCH 32/54] driver core: add way to get to bus device klist
Date: Fri,  2 Nov 2007 16:59:10 -0700
Message-Id: <1194047972-9850-32-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.5.3.4
In-Reply-To: <20071102235758.GA9803@kroah.com>
References: <20071102235758.GA9803@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This allows an easier way to get to the device klist associated with a
struct bus_type (you have three to choose from...)  This will make it
easier to move these fields to be dynamic in a future patch.

The only user of this is the PCI core which horribly abuses this
interface to rearrange the order of the pci devices.  This should be
done using the existing bus device walking functions, but that's left
for future patches.

Cc: Kay Sievers <kay.sievers@vrfy.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/base/bus.c     |    6 ++++++
 drivers/pci/probe.c    |   11 +++++++----
 include/linux/device.h |    1 +
 3 files changed, 14 insertions(+), 4 deletions(-)

diff --git a/drivers/base/bus.c b/drivers/base/bus.c
index 3cd991f..e502ca6 100644
--- a/drivers/base/bus.c
+++ b/drivers/base/bus.c
@@ -942,6 +942,12 @@ struct kset *bus_get_kset(struct bus_type *bus)
 }
 EXPORT_SYMBOL_GPL(bus_get_kset);
 
+struct klist *bus_get_device_klist(struct bus_type *bus)
+{
+	return &bus->klist_devices;
+}
+EXPORT_SYMBOL_GPL(bus_get_device_klist);
+
 int __init buses_init(void)
 {
 	bus_kset = kset_create_and_register("bus", &bus_uevent_ops,
diff --git a/drivers/pci/probe.c b/drivers/pci/probe.c
index 463a5a9..994e185 100644
--- a/drivers/pci/probe.c
+++ b/drivers/pci/probe.c
@@ -1251,16 +1251,19 @@ static void __init pci_sort_breadthfirst_klist(void)
 	struct klist_node *n;
 	struct device *dev;
 	struct pci_dev *pdev;
+	struct klist *device_klist;
 
-	spin_lock(&pci_bus_type.klist_devices.k_lock);
-	list_for_each_safe(pos, tmp, &pci_bus_type.klist_devices.k_list) {
+	device_klist = bus_get_device_klist(&pci_bus_type);
+
+	spin_lock(&device_klist->k_lock);
+	list_for_each_safe(pos, tmp, &device_klist->k_list) {
 		n = container_of(pos, struct klist_node, n_node);
 		dev = container_of(n, struct device, knode_bus);
 		pdev = to_pci_dev(dev);
 		pci_insertion_sort_klist(pdev, &sorted_devices);
 	}
-	list_splice(&sorted_devices, &pci_bus_type.klist_devices.k_list);
-	spin_unlock(&pci_bus_type.klist_devices.k_lock);
+	list_splice(&sorted_devices, &device_klist->k_list);
+	spin_unlock(&device_klist->k_lock);
 }
 
 static void __init pci_insertion_sort_devices(struct pci_dev *a, struct list_head *list)
diff --git a/include/linux/device.h b/include/linux/device.h
index 86eff9d..6d56a34 100644
--- a/include/linux/device.h
+++ b/include/linux/device.h
@@ -118,6 +118,7 @@ extern int bus_unregister_notifier(struct bus_type *bus,
 						      unbound */
 
 extern struct kset *bus_get_kset(struct bus_type *bus);
+extern struct klist *bus_get_device_klist(struct bus_type *bus);
 
 struct device_driver {
 	const char		* name;
-- 
1.5.3.4

