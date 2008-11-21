Return-Path: <linux-kernel-owner+w=401wt.eu-S1756507AbYKUTk7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756507AbYKUTk7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2008 14:40:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757548AbYKUTka
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Nov 2008 14:40:30 -0500
Received: from mga02.intel.com ([134.134.136.20]:4213 "EHLO mga02.intel.com"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757694AbYKUTk1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2008 14:40:27 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.33,645,1220252400"; 
   d="scan'208";a="465875005"
Date: Sat, 22 Nov 2008 02:43:39 +0800
From: Yu Zhao <yu.zhao@intel.com>
To: "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>
Cc: "achiang@hp.com" <achiang@hp.com>,
       "bjorn.helgaas@hp.com" <bjorn.helgaas@hp.com>,
       "grundler@parisc-linux.org" <grundler@parisc-linux.org>,
       "greg@kroah.com" <greg@kroah.com>, "mingo@elte.hu" <mingo@elte.hu>,
       "jbarnes@virtuousgeek.org" <jbarnes@virtuousgeek.org>,
       "matthew@wil.cx" <matthew@wil.cx>,
       "randy.dunlap@oracle.com" <randy.dunlap@oracle.com>,
       "rdreier@cisco.com" <rdreier@cisco.com>,
       "horms@verge.net.au" <horms@verge.net.au>,
       "yinghai@kernel.org" <yinghai@kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
       "virtualization@lists.linux-foundation.org" 
	<virtualization@lists.linux-foundation.org>
Subject: [PATCH 11/13 v7] PCI: reserve bus range for SR-IOV device
Message-ID: <20081121184339.GL7810@yzhao12-linux.sh.intel.com>
References: <20081121183605.GA7810@yzhao12-linux.sh.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081121183605.GA7810@yzhao12-linux.sh.intel.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Reserve bus range for SR-IOV at device scanning stage when the kernel
boot parameter 'pci=assign-busses' is used .

Signed-off-by: Yu Zhao <yu.zhao@intel.com>

---
 drivers/pci/iov.c   |   24 ++++++++++++++++++++++++
 drivers/pci/pci.h   |    6 ++++++
 drivers/pci/probe.c |    3 +++
 3 files changed, 33 insertions(+), 0 deletions(-)

diff --git a/drivers/pci/iov.c b/drivers/pci/iov.c
index 03f62ca..c1a3cea 100644
--- a/drivers/pci/iov.c
+++ b/drivers/pci/iov.c
@@ -489,3 +489,27 @@ void pci_iov_unregister(struct pci_dev *dev)
 	iov_disable(dev);
 	kobject_uevent(&dev->dev.kobj, KOBJ_CHANGE);
 }
+
+/**
+ * pci_iov_bus_range - find bus range used by the Virtual Function
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
+		if (!dev->iov)
+			continue;
+		virtfn_bdf(dev, dev->iov->total - 1, &busnr, &devfn);
+		if (busnr > max)
+			max = busnr;
+	}
+
+	return max ? max - bus->number : 0;
+}
diff --git a/drivers/pci/pci.h b/drivers/pci/pci.h
index 3113d11..574bbc7 100644
--- a/drivers/pci/pci.h
+++ b/drivers/pci/pci.h
@@ -205,6 +205,7 @@ extern int pci_iov_resource_bar(struct pci_dev *dev, int resno,
 extern int pci_iov_register(struct pci_dev* dev);
 extern void pci_iov_unregister(struct pci_dev* dev);
 extern void pci_restore_iov_state(struct pci_dev *dev);
+extern int pci_iov_bus_range(struct pci_bus *bus);
 #else
 static inline int pci_iov_init(struct pci_dev *dev)
 {
@@ -232,6 +233,11 @@ static inline void pci_iov_unregister(struct pci_dev* dev)
 static inline void pci_restore_iov_state(struct pci_dev *dev)
 {
 }
+
+static inline int pci_iov_bus_range(struct pci_bus *bus)
+{
+	return 0;
+}
 #endif /* CONFIG_PCI_IOV */
 
 #endif /* DRIVERS_PCI_H */
diff --git a/drivers/pci/probe.c b/drivers/pci/probe.c
index cb26e64..7b591e5 100644
--- a/drivers/pci/probe.c
+++ b/drivers/pci/probe.c
@@ -1074,6 +1074,9 @@ unsigned int __devinit pci_scan_child_bus(struct pci_bus *bus)
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

