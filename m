Return-Path: <linux-kernel-owner+w=401wt.eu-S1760975AbZCTU6j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760975AbZCTU6j (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Mar 2009 16:58:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758803AbZCTU43
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Mar 2009 16:56:29 -0400
Received: from g5t0008.atlanta.hp.com ([15.192.0.45]:39064 "EHLO
	g5t0008.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758773AbZCTU42 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Mar 2009 16:56:28 -0400
From: Alex Chiang <achiang@hp.com>
Subject: [PATCH v5 07/13] PCI: Introduce pci_rescan_bus()
To: jbarnes@virtuousgeek.org
Cc: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
       Alex Chiang <achiang@hp.com>
Date: Fri, 20 Mar 2009 14:56:25 -0600
Message-ID: <20090320205625.12275.48602.stgit@bob.kio>
In-Reply-To: <20090320204327.12275.43010.stgit@bob.kio>
References: <20090320204327.12275.43010.stgit@bob.kio>
User-Agent: StGIT/0.14.3.215.gff3d
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This API is used by the PCI core to rescan a bus and rediscover
newly added devices.

Over time, it is expected that the various PCI hotplug drivers
will migrate to this interface and away from the old
pci_do_scan_bus() interface.

Signed-off-by: Alex Chiang <achiang@hp.com>
---

 drivers/pci/hotplug/fakephp.c |    6 +++---
 drivers/pci/probe.c           |   32 ++++++++++++++++++++++++++++++++
 include/linux/pci.h           |    3 +++
 3 files changed, 38 insertions(+), 3 deletions(-)

diff --git a/drivers/pci/hotplug/fakephp.c b/drivers/pci/hotplug/fakephp.c
index d8649e1..1606374 100644
--- a/drivers/pci/hotplug/fakephp.c
+++ b/drivers/pci/hotplug/fakephp.c
@@ -245,12 +245,12 @@ static int pci_rescan_slot(struct pci_dev *temp)
 
 
 /**
- * pci_rescan_bus - Rescan PCI bus
+ * pci_rescan_bus_local - fakephp version of rescan PCI bus
  * @bus: the PCI bus to rescan
  *
  * Call pci_rescan_slot for each possible function of the bus.
  */
-static void pci_rescan_bus(const struct pci_bus *bus)
+static void pci_rescan_bus_local(const struct pci_bus *bus)
 {
 	unsigned int devfn;
 	struct pci_dev *dev;
@@ -291,7 +291,7 @@ static void pci_rescan_buses(const struct list_head *list)
 	const struct list_head *l;
 	list_for_each(l,list) {
 		const struct pci_bus *b = pci_bus_b(l);
-		pci_rescan_bus(b);
+		pci_rescan_bus_local(b);
 		pci_rescan_buses(&b->children);
 	}
 }
diff --git a/drivers/pci/probe.c b/drivers/pci/probe.c
index b75ed4b..53edb7e 100644
--- a/drivers/pci/probe.c
+++ b/drivers/pci/probe.c
@@ -1203,6 +1203,38 @@ struct pci_bus * __devinit pci_scan_bus_parented(struct device *parent,
 EXPORT_SYMBOL(pci_scan_bus_parented);
 
 #ifdef CONFIG_HOTPLUG
+/**
+ * pci_rescan_bus - scan a PCI bus for devices.
+ * @bus: PCI bus to scan
+ *
+ * Scan a PCI bus and child buses for new devices, adds them,
+ * and enables them.
+ *
+ * Returns the max number of subordinate bus discovered.
+ */
+unsigned int __devinit pci_rescan_bus(struct pci_bus *bus)
+{
+	unsigned int max;
+	struct pci_dev *dev;
+
+	max = pci_scan_child_bus(bus);
+
+	up_read(&pci_bus_sem);
+	list_for_each_entry(dev, &bus->devices, bus_list)
+		if (dev->hdr_type == PCI_HEADER_TYPE_BRIDGE ||
+		    dev->hdr_type == PCI_HEADER_TYPE_CARDBUS)
+			if (dev->subordinate)
+				pci_bus_size_bridges(dev->subordinate);
+	down_read(&pci_bus_sem);
+
+	pci_bus_assign_resources(bus);
+	pci_enable_bridges(bus);
+	pci_bus_add_devices(bus);
+
+	return max;
+}
+EXPORT_SYMBOL_GPL(pci_rescan_bus);
+
 EXPORT_SYMBOL(pci_add_new_bus);
 EXPORT_SYMBOL(pci_scan_slot);
 EXPORT_SYMBOL(pci_scan_bridge);
diff --git a/include/linux/pci.h b/include/linux/pci.h
index 72ccf15..39e3029 100644
--- a/include/linux/pci.h
+++ b/include/linux/pci.h
@@ -710,6 +710,9 @@ int pci_back_from_sleep(struct pci_dev *dev);
 
 /* Functions for PCI Hotplug drivers to use */
 int pci_bus_find_capability(struct pci_bus *bus, unsigned int devfn, int cap);
+#ifdef CONFIG_HOTPLUG
+unsigned int pci_rescan_bus(struct pci_bus *bus);
+#endif
 
 /* Vital product data routines */
 ssize_t pci_read_vpd(struct pci_dev *dev, loff_t pos, size_t count, void *buf);

