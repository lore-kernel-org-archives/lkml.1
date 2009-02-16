Return-Path: <linux-kernel-owner+w=401wt.eu-S1752283AbZBQDa1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752283AbZBQDa1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Feb 2009 22:30:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753727AbZBQD3a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Feb 2009 22:29:30 -0500
Received: from mga03.intel.com ([143.182.124.21]:17603 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752198AbZBQD3X (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Feb 2009 22:29:23 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.38,220,1233561600"; 
   d="scan'208";a="111302125"
From: Yu Zhao <yu.zhao@intel.com>
To: jbarnes@virtuousgeek.org
Cc: linux-pci@vger.kernel.org, kvm@vger.kernel.org,
       linux-kernel@vger.kernel.org, Yu Zhao <yu.zhao@intel.com>
Subject: [PATCH v9 3/7] PCI: reserve bus range for SR-IOV device
Date: Mon, 16 Feb 2009 21:28:36 +0800
Message-Id: <1234790920-1810-4-git-send-email-yu.zhao@intel.com>
X-Mailer: git-send-email 1.6.1
In-Reply-To: <1234790920-1810-1-git-send-email-yu.zhao@intel.com>
References: <1234790920-1810-1-git-send-email-yu.zhao@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Yu Zhao <yu.zhao@intel.com>
---
 drivers/pci/iov.c   |   34 ++++++++++++++++++++++++++++++++++
 drivers/pci/pci.h   |    5 +++++
 drivers/pci/probe.c |    3 +++
 3 files changed, 42 insertions(+), 0 deletions(-)

diff --git a/drivers/pci/iov.c b/drivers/pci/iov.c
index 1cc879b..c89fcb1 100644
--- a/drivers/pci/iov.c
+++ b/drivers/pci/iov.c
@@ -14,6 +14,16 @@
 #include "pci.h"
 
 
+static inline void virtfn_bdf(struct pci_dev *dev, int id, u8 *busnr, u8 *devfn)
+{
+	u16 bdf;
+
+	bdf = (dev->bus->number << 8) + dev->devfn +
+	      dev->sriov->offset + dev->sriov->stride * id;
+	*busnr = bdf >> 8;
+	*devfn = bdf & 0xff;
+}
+
 static int sriov_init(struct pci_dev *dev, int pos)
 {
 	int i;
@@ -204,3 +214,27 @@ void pci_restore_iov_state(struct pci_dev *dev)
 	if (dev->sriov)
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
+	u8 busnr, devfn;
+	struct pci_dev *dev;
+
+	list_for_each_entry(dev, &bus->devices, bus_list) {
+		if (!dev->sriov)
+			continue;
+		virtfn_bdf(dev, dev->sriov->total - 1, &busnr, &devfn);
+		if (busnr > max)
+			max = busnr;
+	}
+
+	return max ? max - bus->number : 0;
+}
diff --git a/drivers/pci/pci.h b/drivers/pci/pci.h
index 9d76737..fdfc476 100644
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

