Return-Path: <linux-kernel-owner+w=401wt.eu-S1758627AbXIGTwy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758627AbXIGTwy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Sep 2007 15:52:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752190AbXIGTwr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Sep 2007 15:52:47 -0400
Received: from mga11.intel.com ([192.55.52.93]:35265 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751790AbXIGTwq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Sep 2007 15:52:46 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.20,221,1186383600"; 
   d="scan'208";a="296738409"
Date: Sat, 8 Sep 2007 13:05:24 -0700
From: "Keshavamurthy, Anil S" <anil.s.keshavamurthy@intel.com>
To: akpm@osdl.org, Greg KH <greg@kroah.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>, kristen.c.accardi@intel.com
Subject: [RFC][Intel-IOMMU] Fix for IOMMU early crash
Message-ID: <20070908200523.GA16204@askeshav-devel.jf.intel.com>
Reply-To: "Keshavamurthy, Anil S" <anil.s.keshavamurthy@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Subject: [RFC][Intel-IOMMU] Fix for IOMMU early crash

Populating pci_bus->sysdata way early in the pci discovery phase
sets NON-NULL value to pci_dev->sysdata which breaks the assumption
in the Intel IOMMU driver and crashes the system.


In the drivers/pci/probe.c, pci_dev->sysdata gets a copy of
its pci_bus->sysdata which is not required as
the same can be obtained from pci_dev->bus->sysdata. More over 
the left hand assignment of pci_dev->sysdata is never being used,
so their is no point is setting 
pci_dev->sysdata = pci_bus->sysdata;

This patch removes sysdata from pci_dev struct and creates a new
field called sys_data which is exclusively used 
by IOMMU driver to keep its per device context pointer.

Signed-off-by: Anil S Keshavamurthy <anil.s.keshavamurthy@intel.com>

---
 drivers/pci/hotplug/fakephp.c |    1 -
 drivers/pci/intel-iommu.c     |   22 +++++++++++-----------
 drivers/pci/probe.c           |    1 -
 include/linux/pci.h           |    2 +-
 4 files changed, 12 insertions(+), 14 deletions(-)

Index: work/drivers/pci/hotplug/fakephp.c
===================================================================
--- work.orig/drivers/pci/hotplug/fakephp.c	2007-09-08 12:00:20.000000000 -0700
+++ work/drivers/pci/hotplug/fakephp.c	2007-09-08 12:07:19.000000000 -0700
@@ -243,7 +243,6 @@
 		return;
 
 	dev->bus = (struct pci_bus*)bus;
-	dev->sysdata = bus->sysdata;
 	for (devfn = 0; devfn < 0x100; devfn += 8) {
 		dev->devfn = devfn;
 		pci_rescan_slot(dev);
Index: work/drivers/pci/intel-iommu.c
===================================================================
--- work.orig/drivers/pci/intel-iommu.c	2007-09-08 12:00:47.000000000 -0700
+++ work/drivers/pci/intel-iommu.c	2007-09-08 12:08:20.000000000 -0700
@@ -1348,7 +1348,7 @@
 		list_del(&info->link);
 		list_del(&info->global);
 		if (info->dev)
-			info->dev->sysdata = NULL;
+			info->dev->sys_data = NULL;
 		spin_unlock_irqrestore(&device_domain_lock, flags);
 
 		detach_domain_for_dev(info->domain, info->bus, info->devfn);
@@ -1361,7 +1361,7 @@
 
 /*
  * find_domain
- * Note: we use struct pci_dev->sysdata stores the info
+ * Note: we use struct pci_dev->sys_data stores the info
  */
 struct dmar_domain *
 find_domain(struct pci_dev *pdev)
@@ -1369,7 +1369,7 @@
 	struct device_domain_info *info;
 
 	/* No lock here, assumes no domain exit in normal case */
-	info = pdev->sysdata;
+	info = pdev->sys_data;
 	if (info)
 		return info->domain;
 	return NULL;
@@ -1519,7 +1519,7 @@
 	}
 	list_add(&info->link, &domain->devices);
 	list_add(&info->global, &device_domain_list);
-	pdev->sysdata = info;
+	pdev->sys_data = info;
 	spin_unlock_irqrestore(&device_domain_lock, flags);
 	return domain;
 error:
@@ -1579,7 +1579,7 @@
 static inline int iommu_prepare_rmrr_dev(struct dmar_rmrr_unit *rmrr,
 	struct pci_dev *pdev)
 {
-	if (pdev->sysdata == DUMMY_DEVICE_DOMAIN_INFO)
+	if (pdev->sys_data == DUMMY_DEVICE_DOMAIN_INFO)
 		return 0;
 	return iommu_prepare_identity_map(pdev, rmrr->base_address,
 		rmrr->end_address + 1);
@@ -1595,7 +1595,7 @@
 	int ret;
 
 	for_each_pci_dev(pdev) {
-		if (pdev->sysdata == DUMMY_DEVICE_DOMAIN_INFO ||
+		if (pdev->sys_data == DUMMY_DEVICE_DOMAIN_INFO ||
 				!IS_GFX_DEVICE(pdev))
 			continue;
 		printk(KERN_INFO "IOMMU: gfx device %s 1-1 mapping\n",
@@ -1836,7 +1836,7 @@
 	int prot = 0;
 
 	BUG_ON(dir == DMA_NONE);
-	if (pdev->sysdata == DUMMY_DEVICE_DOMAIN_INFO)
+	if (pdev->sys_data == DUMMY_DEVICE_DOMAIN_INFO)
 		return virt_to_bus(addr);
 
 	domain = get_valid_domain_for_dev(pdev);
@@ -1900,7 +1900,7 @@
 	unsigned long start_addr;
 	struct iova *iova;
 
-	if (pdev->sysdata == DUMMY_DEVICE_DOMAIN_INFO)
+	if (pdev->sys_data == DUMMY_DEVICE_DOMAIN_INFO)
 		return;
 	domain = find_domain(pdev);
 	BUG_ON(!domain);
@@ -1974,7 +1974,7 @@
 	size_t size = 0;
 	void *addr;
 
-	if (pdev->sysdata == DUMMY_DEVICE_DOMAIN_INFO)
+	if (pdev->sys_data == DUMMY_DEVICE_DOMAIN_INFO)
 		return;
 
 	domain = find_domain(pdev);
@@ -2032,7 +2032,7 @@
 	unsigned long start_addr;
 
 	BUG_ON(dir == DMA_NONE);
-	if (pdev->sysdata == DUMMY_DEVICE_DOMAIN_INFO)
+	if (pdev->sys_data == DUMMY_DEVICE_DOMAIN_INFO)
 		return intel_nontranslate_map_sg(hwdev, sg, nelems, dir);
 
 	domain = get_valid_domain_for_dev(pdev);
@@ -2234,7 +2234,7 @@
 		for (i = 0; i < drhd->devices_cnt; i++) {
 			if (!drhd->devices[i])
 				continue;
-			drhd->devices[i]->sysdata = DUMMY_DEVICE_DOMAIN_INFO;
+			drhd->devices[i]->sys_data = DUMMY_DEVICE_DOMAIN_INFO;
 		}
 	}
 }
Index: work/drivers/pci/probe.c
===================================================================
--- work.orig/drivers/pci/probe.c	2007-09-08 12:00:47.000000000 -0700
+++ work/drivers/pci/probe.c	2007-09-08 12:06:59.000000000 -0700
@@ -994,7 +994,6 @@
 		return NULL;
 
 	dev->bus = bus;
-	dev->sysdata = bus->sysdata;
 	dev->dev.parent = bus->bridge;
 	dev->dev.bus = &pci_bus_type;
 	dev->devfn = devfn;
Index: work/include/linux/pci.h
===================================================================
--- work.orig/include/linux/pci.h	2007-09-08 12:00:47.000000000 -0700
+++ work/include/linux/pci.h	2007-09-08 12:29:36.000000000 -0700
@@ -130,7 +130,7 @@
 	struct pci_bus	*bus;		/* bus this device is on */
 	struct pci_bus	*subordinate;	/* bus this device bridges to */
 
-	void		*sysdata;	/* hook for sys-specific extension */
+	void		*sys_data;	/* hook for IOMMU specific extension */
 	struct proc_dir_entry *procent;	/* device entry in /proc/bus/pci */
 
 	unsigned int	devfn;		/* encoded device & function index */
