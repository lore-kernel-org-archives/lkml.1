Return-Path: <linux-kernel-owner+w=401wt.eu-S1758617AbXJCVUo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758617AbXJCVUo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Oct 2007 17:20:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754785AbXJCVUg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Oct 2007 17:20:36 -0400
Received: from mga11.intel.com ([192.55.52.93]:41530 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754254AbXJCVUf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Oct 2007 17:20:35 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.21,226,1188802800"; 
   d="scan'208";a="161969490"
Date: Wed, 3 Oct 2007 14:13:27 -0700
From: "Keshavamurthy, Anil S" <anil.s.keshavamurthy@intel.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Cc: "Keshavamurthy, Anil S" <anil.s.keshavamurthy@intel.com>,
       akpm@linux-foundation.org, Greg KH <greg@kroah.com>, muli@il.ibm.com,
       paulus@samba.org, kristen.c.accardi@intel.com
Subject: [patch take 2][Intel-IOMMU] Fix for IOMMU early crash
Message-ID: <20071003211327.GA14159@askeshav-devel.jf.intel.com>
Reply-To: "Keshavamurthy, Anil S" <anil.s.keshavamurthy@intel.com>
References: <20070908200523.GA16204@askeshav-devel.jf.intel.com> <18148.12140.21118.252581@cargo.ozlabs.ibm.com> <20070911174231.GC24627@askeshav-devel.jf.intel.com> <20070912192854.GA32610@askeshav-devel.jf.intel.com> <18150.61732.490669.269794@cargo.ozlabs.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <18150.61732.490669.269794@cargo.ozlabs.ibm.com>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Subject: [patch][Intel-IOMMU] Fix for IOMMU early crash

pci_dev's->sysdata is highly overloaded and currently
IOMMU is broken due to IOMMU code depending on this field.

This patch introduces new field in pci_dev's struct to
hold IOMMU specific per device IOMMU private data.

Signed-off-by: Anil S Keshavamurthy <anil.s.keshavamurthy@intel.com>

---
 drivers/pci/intel-iommu.c |   22 +++++++++++-----------
 include/linux/pci.h       |    1 +
 2 files changed, 12 insertions(+), 11 deletions(-)

Index: 2.6-mm/drivers/pci/intel-iommu.c
===================================================================
--- 2.6-mm.orig/drivers/pci/intel-iommu.c	2007-10-03 13:48:18.000000000 -0700
+++ 2.6-mm/drivers/pci/intel-iommu.c	2007-10-03 13:48:41.000000000 -0700
@@ -1348,7 +1348,7 @@
 		list_del(&info->link);
 		list_del(&info->global);
 		if (info->dev)
-			info->dev->sysdata = NULL;
+			info->dev->iommu_private = NULL;
 		spin_unlock_irqrestore(&device_domain_lock, flags);
 
 		detach_domain_for_dev(info->domain, info->bus, info->devfn);
@@ -1361,7 +1361,7 @@
 
 /*
  * find_domain
- * Note: we use struct pci_dev->sysdata stores the info
+ * Note: we use struct pci_dev->iommu_private stores the info
  */
 struct dmar_domain *
 find_domain(struct pci_dev *pdev)
@@ -1369,7 +1369,7 @@
 	struct device_domain_info *info;
 
 	/* No lock here, assumes no domain exit in normal case */
-	info = pdev->sysdata;
+	info = pdev->iommu_private;
 	if (info)
 		return info->domain;
 	return NULL;
@@ -1519,7 +1519,7 @@
 	}
 	list_add(&info->link, &domain->devices);
 	list_add(&info->global, &device_domain_list);
-	pdev->sysdata = info;
+	pdev->iommu_private = info;
 	spin_unlock_irqrestore(&device_domain_lock, flags);
 	return domain;
 error:
@@ -1579,7 +1579,7 @@
 static inline int iommu_prepare_rmrr_dev(struct dmar_rmrr_unit *rmrr,
 	struct pci_dev *pdev)
 {
-	if (pdev->sysdata == DUMMY_DEVICE_DOMAIN_INFO)
+	if (pdev->iommu_private == DUMMY_DEVICE_DOMAIN_INFO)
 		return 0;
 	return iommu_prepare_identity_map(pdev, rmrr->base_address,
 		rmrr->end_address + 1);
@@ -1595,7 +1595,7 @@
 	int ret;
 
 	for_each_pci_dev(pdev) {
-		if (pdev->sysdata == DUMMY_DEVICE_DOMAIN_INFO ||
+		if (pdev->iommu_private == DUMMY_DEVICE_DOMAIN_INFO ||
 				!IS_GFX_DEVICE(pdev))
 			continue;
 		printk(KERN_INFO "IOMMU: gfx device %s 1-1 mapping\n",
@@ -1836,7 +1836,7 @@
 	int prot = 0;
 
 	BUG_ON(dir == DMA_NONE);
-	if (pdev->sysdata == DUMMY_DEVICE_DOMAIN_INFO)
+	if (pdev->iommu_private == DUMMY_DEVICE_DOMAIN_INFO)
 		return virt_to_bus(addr);
 
 	domain = get_valid_domain_for_dev(pdev);
@@ -1900,7 +1900,7 @@
 	unsigned long start_addr;
 	struct iova *iova;
 
-	if (pdev->sysdata == DUMMY_DEVICE_DOMAIN_INFO)
+	if (pdev->iommu_private == DUMMY_DEVICE_DOMAIN_INFO)
 		return;
 	domain = find_domain(pdev);
 	BUG_ON(!domain);
@@ -1974,7 +1974,7 @@
 	size_t size = 0;
 	void *addr;
 
-	if (pdev->sysdata == DUMMY_DEVICE_DOMAIN_INFO)
+	if (pdev->iommu_private == DUMMY_DEVICE_DOMAIN_INFO)
 		return;
 
 	domain = find_domain(pdev);
@@ -2032,7 +2032,7 @@
 	unsigned long start_addr;
 
 	BUG_ON(dir == DMA_NONE);
-	if (pdev->sysdata == DUMMY_DEVICE_DOMAIN_INFO)
+	if (pdev->iommu_private == DUMMY_DEVICE_DOMAIN_INFO)
 		return intel_nontranslate_map_sg(hwdev, sg, nelems, dir);
 
 	domain = get_valid_domain_for_dev(pdev);
@@ -2234,7 +2234,7 @@
 		for (i = 0; i < drhd->devices_cnt; i++) {
 			if (!drhd->devices[i])
 				continue;
-			drhd->devices[i]->sysdata = DUMMY_DEVICE_DOMAIN_INFO;
+			drhd->devices[i]->iommu_private = DUMMY_DEVICE_DOMAIN_INFO;
 		}
 	}
 }
Index: 2.6-mm/include/linux/pci.h
===================================================================
--- 2.6-mm.orig/include/linux/pci.h	2007-10-03 13:48:20.000000000 -0700
+++ 2.6-mm/include/linux/pci.h	2007-10-03 13:49:08.000000000 -0700
@@ -195,6 +195,7 @@
 #ifdef CONFIG_PCI_MSI
 	struct list_head msi_list;
 #endif
+	void		*iommu_private;	/* hook for IOMMU specific extension */
 };
 
 extern struct pci_dev *alloc_pci_dev(void);
