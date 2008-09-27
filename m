Return-Path: <linux-kernel-owner+w=401wt.eu-S1753830AbYI0I3e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753830AbYI0I3e (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Sep 2008 04:29:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752958AbYI0I2s
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 27 Sep 2008 04:28:48 -0400
Received: from mga02.intel.com ([134.134.136.20]:33654 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753468AbYI0I2p convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Sep 2008 04:28:45 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.33,319,1220252400"; 
   d="scan'208";a="341193425"
From: "Zhao, Yu" <yu.zhao@intel.com>
To: "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>
CC: Jesse Barnes <jbarnes@virtuousgeek.org>,
       Randy Dunlap <randy.dunlap@oracle.com>,
       Grant Grundler <grundler@parisc-linux.org>,
       Alex Chiang <achiang@hp.com>, Matthew Wilcox <matthew@wil.cx>,
       Roland Dreier <rdreier@cisco.com>, Greg KH <greg@kroah.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
       "virtualization@lists.linux-foundation.org" 
	<virtualization@lists.linux-foundation.org>
Date: Sat, 27 Sep 2008 16:28:29 +0800
Subject: [PATCH 5/6 v3] PCI: reserve bus range for SR-IOV
Thread-Topic: [PATCH 5/6 v3] PCI: reserve bus range for SR-IOV
Thread-Index: AckgewVD9efylgV7TpyAWI3um3GjrA==
Message-ID: <D8078B8B3B09934AA9F8F2D5FB3F28CE088751B5F5@pdsmsx502.ccr.corp.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Reserve bus range for SR-IOV at device scanning stage.

Cc: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Grant Grundler <grundler@parisc-linux.org>
Cc: Alex Chiang <achiang@hp.com>
Cc: Matthew Wilcox <matthew@wil.cx>
Cc: Roland Dreier <rdreier@cisco.com>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Yu Zhao <yu.zhao@intel.com>

---
 drivers/pci/iov.c   |   24 ++++++++++++++++++++++++
 drivers/pci/pci.h   |    5 +++++
 drivers/pci/probe.c |    3 +++
 3 files changed, 32 insertions(+), 0 deletions(-)

diff --git a/drivers/pci/iov.c b/drivers/pci/iov.c
index a2b2de9..17ada58 100644
--- a/drivers/pci/iov.c
+++ b/drivers/pci/iov.c
@@ -600,6 +600,30 @@ void pci_iov_remove_sysfs(struct pci_dev *dev)
        kfree(iov->ve);
 }

+/**
+ * pci_iov_bus_range - find bus range used by SR-IOV capability
+ * @bus: the PCI bus
+ *
+ * Returns max number of buses (exclude current one) used by Virtual
+ * Functions.
+ */
+int pci_iov_bus_range(struct pci_bus *bus)
+{
+       int max = 0;
+       u8 busnr, devfn;
+       struct pci_dev *dev;
+
+       list_for_each_entry(dev, &bus->devices, bus_list) {
+               if (!dev->iov)
+                       continue;
+               vf_rid(dev, dev->iov->totalvfs - 1, &busnr, &devfn);
+               if (busnr > max)
+                       max = busnr;
+       }
+
+       return max ? max - bus->number : 0;
+}
+
 int pci_iov_resource_align(struct pci_dev *dev, int resno)
 {
        if (resno < PCI_IOV_RESOURCES || resno > PCI_IOV_RESOURCES_END)
diff --git a/drivers/pci/pci.h b/drivers/pci/pci.h
index 11b1d17..7039243 100644
--- a/drivers/pci/pci.h
+++ b/drivers/pci/pci.h
@@ -208,6 +208,7 @@ void pci_iov_remove_sysfs(struct pci_dev *dev);
 extern int pci_iov_resource_align(struct pci_dev *dev, int resno);
 extern int pci_iov_resource_bar(struct pci_dev *dev, int resno,
                                enum pci_bar_type *type);
+extern int pci_iov_bus_range(struct pci_bus *bus);
 #else
 static inline int pci_iov_init(struct pci_dev *dev)
 {
@@ -231,6 +232,10 @@ static inline int pci_iov_resource_bar(struct pci_dev *dev, int resno,
 {
        return 0;
 }
+extern inline int pci_iov_bus_range(struct pci_bus *bus)
+{
+       return 0;
+}
 #endif /* CONFIG_PCI_IOV */

 #endif /* DRIVERS_PCI_H */
diff --git a/drivers/pci/probe.c b/drivers/pci/probe.c
index f18174e..a0abcde 100644
--- a/drivers/pci/probe.c
+++ b/drivers/pci/probe.c
@@ -1128,6 +1128,9 @@ unsigned int __devinit pci_scan_child_bus(struct pci_bus *bus)
        for (devfn = 0; devfn < 0x100; devfn += 8)
                pci_scan_slot(bus, devfn);

+       /* Reserve buses for SR-IOV capability. */
+       max += pci_iov_bus_range(bus);
+
        /*
         * After performing arch-dependent fixup of the bus, look behind
         * all PCI-to-PCI bridges on this bus.
--
1.5.6.4

