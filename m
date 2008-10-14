Return-Path: <linux-kernel-owner+w=401wt.eu-S1755963AbYJNL7X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755963AbYJNL7X (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Oct 2008 07:59:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756623AbYJNL6h
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Oct 2008 07:58:37 -0400
Received: from mga02.intel.com ([134.134.136.20]:18033 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755987AbYJNL6f (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Oct 2008 07:58:35 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.33,409,1220252400"; 
   d="scan'208";a="347869718"
Date: Tue, 14 Oct 2008 19:00:23 +0800
From: Yu Zhao <yu.zhao@intel.com>
To: "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>
Cc: "jbarnes@virtuousgeek.org" <jbarnes@virtuousgeek.org>,
       "randy.dunlap@oracle.com" <randy.dunlap@oracle.com>,
       "grundler@parisc-linux.org" <grundler@parisc-linux.org>,
       "achiang@hp.com" <achiang@hp.com>, "matthew@wil.cx" <matthew@wil.cx>,
       "rdreier@cisco.com" <rdreier@cisco.com>,
       "greg@kroah.com" <greg@kroah.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
       "virtualization@lists.linux-foundation.org" 
	<virtualization@lists.linux-foundation.org>
Subject: [PATCH 7/8 v4] PCI: reserve bus range for the SR-IOV device
Message-ID: <20081014110023.GG1734@yzhao12-linux.sh.intel.com>
References: <20081014103424.GA1704@yzhao12-linux.sh.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081014103424.GA1704@yzhao12-linux.sh.intel.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Reserve bus range for SR-IOV at device scanning stage.

Signed-off-by: Yu Zhao <yu.zhao@intel.com>

---
 drivers/pci/iov.c   |   24 ++++++++++++++++++++++++
 drivers/pci/pci.h   |    5 +++++
 drivers/pci/probe.c |    3 +++
 3 files changed, 32 insertions(+), 0 deletions(-)

diff --git a/drivers/pci/iov.c b/drivers/pci/iov.c
index 3cf9709..7685c6b 100644
--- a/drivers/pci/iov.c
+++ b/drivers/pci/iov.c
@@ -603,6 +603,30 @@ void pci_iov_remove_sysfs(struct pci_dev *dev)
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
+	int max = 0;
+	u8 busnr, devfn;
+	struct pci_dev *dev;
+
+	list_for_each_entry(dev, &bus->devices, bus_list) {
+		if (!dev->iov)
+			continue;
+		vf_rid(dev, dev->iov->totalvfs - 1, &busnr, &devfn);
+		if (busnr > max)
+			max = busnr;
+	}
+
+	return max ? max - bus->number : 0;
+}
+
 int pci_iov_resource_align(struct pci_dev *dev, int resno)
 {
 	if (resno < PCI_IOV_RESOURCES || resno > PCI_IOV_RESOURCES_END)
diff --git a/drivers/pci/pci.h b/drivers/pci/pci.h
index c66a4bd..71149b5 100644
--- a/drivers/pci/pci.h
+++ b/drivers/pci/pci.h
@@ -206,6 +206,7 @@ void pci_iov_remove_sysfs(struct pci_dev *dev);
 extern int pci_iov_resource_align(struct pci_dev *dev, int resno);
 extern int pci_iov_resource_bar(struct pci_dev *dev, int resno,
 				enum pci_bar_type *type);
+extern int pci_iov_bus_range(struct pci_bus *bus);
 #else
 static inline int pci_iov_init(struct pci_dev *dev)
 {
@@ -229,6 +230,10 @@ static inline int pci_iov_resource_bar(struct pci_dev *dev, int resno,
 {
 	return 0;
 }
+extern inline int pci_iov_bus_range(struct pci_bus *bus)
+{
+	return 0;
+}
 #endif /* CONFIG_PCI_IOV */
 
 #endif /* DRIVERS_PCI_H */
diff --git a/drivers/pci/probe.c b/drivers/pci/probe.c
index 831d8d0..b11f4b8 100644
--- a/drivers/pci/probe.c
+++ b/drivers/pci/probe.c
@@ -1129,6 +1129,9 @@ unsigned int __devinit pci_scan_child_bus(struct pci_bus *bus)
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

