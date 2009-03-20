Return-Path: <linux-kernel-owner+w=401wt.eu-S1759961AbZCTD0R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759961AbZCTD0R (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Mar 2009 23:26:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755634AbZCTDYp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Mar 2009 23:24:45 -0400
Received: from mga02.intel.com ([134.134.136.20]:22298 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753217AbZCTDYi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Mar 2009 23:24:38 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.38,392,1233561600"; 
   d="scan'208";a="396042869"
From: Yu Zhao <yu.zhao@intel.com>
To: jbarnes@virtuousgeek.org
Cc: linux-pci@vger.kernel.org, kvm@vger.kernel.org,
       linux-kernel@vger.kernel.org, Yu Zhao <yu.zhao@intel.com>
Subject: [PATCH v12 3/8] PCI: reserve bus range for SR-IOV device
Date: Fri, 20 Mar 2009 11:25:13 +0800
Message-Id: <1237519518-24048-4-git-send-email-yu.zhao@intel.com>
X-Mailer: git-send-email 1.6.1
In-Reply-To: <1237519518-24048-1-git-send-email-yu.zhao@intel.com>
References: <1237519518-24048-1-git-send-email-yu.zhao@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Reserve the bus number range used by the Virtual Function when
pcibios_assign_all_busses() returns true.

Reviewed-by: Matthew Wilcox <willy@linux.intel.com>
Signed-off-by: Yu Zhao <yu.zhao@intel.com>
---
 drivers/pci/iov.c   |   36 ++++++++++++++++++++++++++++++++++++
 drivers/pci/pci.h   |    5 +++++
 drivers/pci/probe.c |    3 +++
 3 files changed, 44 insertions(+), 0 deletions(-)

diff --git a/drivers/pci/iov.c b/drivers/pci/iov.c
index b121e47..5ddfc09 100644
--- a/drivers/pci/iov.c
+++ b/drivers/pci/iov.c
@@ -14,6 +14,18 @@
 #include "pci.h"
 
 
+static inline u8 virtfn_bus(struct pci_dev *dev, int id)
+{
+	return dev->bus->number + ((dev->devfn + dev->sriov->offset +
+				    dev->sriov->stride * id) >> 8);
+}
+
+static inline u8 virtfn_devfn(struct pci_dev *dev, int id)
+{
+	return (dev->devfn + dev->sriov->offset +
+		dev->sriov->stride * id) & 0xff;
+}
+
 static int sriov_init(struct pci_dev *dev, int pos)
 {
 	int i;
@@ -209,3 +221,27 @@ void pci_restore_iov_state(struct pci_dev *dev)
 	if (dev->is_physfn)
 		sriov_restore_state(dev);
 }
+
+/**
+ * pci_iov_bus_range - find bus range used by Virtual Function
+ * @bus: the PCI bus
+ *
+ * Returns max number of buses (exclude current one) used by Virtual
+ * Functions.
+ */
+int pci_iov_bus_range(struct pci_bus *bus)
+{
+	int max = 0;
+	u8 busnr;
+	struct pci_dev *dev;
+
+	list_for_each_entry(dev, &bus->devices, bus_list) {
+		if (!dev->is_physfn)
+			continue;
+		busnr = virtfn_bus(dev, dev->sriov->total - 1);
+		if (busnr > max)
+			max = busnr;
+	}
+
+	return max ? max - bus->number : 0;
+}
diff --git a/drivers/pci/pci.h b/drivers/pci/pci.h
index efd79a2..7abdef6 100644
--- a/drivers/pci/pci.h
+++ b/drivers/pci/pci.h
@@ -217,6 +217,7 @@ extern void pci_iov_release(struct pci_dev *dev);
 extern int pci_iov_resource_bar(struct pci_dev *dev, int resno,
 				enum pci_bar_type *type);
 extern void pci_restore_iov_state(struct pci_dev *dev);
+extern int pci_iov_bus_range(struct pci_bus *bus);
 #else
 static inline int pci_iov_init(struct pci_dev *dev)
 {
@@ -234,6 +235,10 @@ static inline int pci_iov_resource_bar(struct pci_dev *dev, int resno,
 static inline void pci_restore_iov_state(struct pci_dev *dev)
 {
 }
+static inline int pci_iov_bus_range(struct pci_bus *bus)
+{
+	return 0;
+}
 #endif /* CONFIG_PCI_IOV */
 
 #endif /* DRIVERS_PCI_H */
diff --git a/drivers/pci/probe.c b/drivers/pci/probe.c
index 03b6f29..4c8abd0 100644
--- a/drivers/pci/probe.c
+++ b/drivers/pci/probe.c
@@ -1078,6 +1078,9 @@ unsigned int __devinit pci_scan_child_bus(struct pci_bus *bus)
 	for (devfn = 0; devfn < 0x100; devfn += 8)
 		pci_scan_slot(bus, devfn);
 
+	/* Reserve buses for SR-IOV capability. */
+	max += pci_iov_bus_range(bus);
+
 	/*
 	 * After performing arch-dependent fixup of the bus, look behind
 	 * all PCI-to-PCI bridges on this bus.
-- 
1.5.6.4

