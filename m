Return-Path: <linux-kernel-owner+w=401wt.eu-S1759212AbXJDT0T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759212AbXJDT0T (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Oct 2007 15:26:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756574AbXJDT0J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Oct 2007 15:26:09 -0400
Received: from mga03.intel.com ([143.182.124.21]:28764 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756268AbXJDT0I (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Oct 2007 15:26:08 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.21,232,1188802800"; 
   d="scan'208";a="292782750"
Date: Thu, 4 Oct 2007 12:20:12 -0700
From: "Keshavamurthy, Anil S" <anil.s.keshavamurthy@intel.com>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: "Keshavamurthy, Anil S" <anil.s.keshavamurthy@intel.com>,
       Linux Kernel <linux-kernel@vger.kernel.org>, akpm@linux-foundation.org,
       Greg KH <greg@kroah.com>, muli@il.ibm.com, paulus@samba.org,
       kristen.c.accardi@intel.com
Subject: Re: [patch take 2][Intel-IOMMU] Fix for IOMMU early crash
Message-ID: <20071004192011.GA567@askeshav-devel.jf.intel.com>
Reply-To: "Keshavamurthy, Anil S" <anil.s.keshavamurthy@intel.com>
References: <20070908200523.GA16204@askeshav-devel.jf.intel.com> <18148.12140.21118.252581@cargo.ozlabs.ibm.com> <20070911174231.GC24627@askeshav-devel.jf.intel.com> <20070912192854.GA32610@askeshav-devel.jf.intel.com> <18150.61732.490669.269794@cargo.ozlabs.ibm.com> <20071003211327.GA14159@askeshav-devel.jf.intel.com> <1191460773.22572.139.camel@pasglop> <20071004013606.GA14755@askeshav-devel.jf.intel.com> <1191469179.22572.145.camel@pasglop>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1191469179.22572.145.camel@pasglop>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 04, 2007 at 01:39:39PM +1000, Benjamin Herrenschmidt wrote:
> 
> > > Why don't you use the new struct dev_archdata mechanism ? That's what I
> > > use on powerpc to provide optional iommu linkage to any device in the
> > > system.
> > Good one. I will certainly try out your idea and will update the list
> > tomorrow.
> 
> The advantage is that it allows to completely isolate the iommu code
> from any dependency to PCI, which means you can implement DMA ops
> support for various platform devices or other fancy things. Maybe not
> the most useful in x86-land, but still ;-)

Andrew,
	Please delete my previous patch and add the below patch 
to your MM queue. 

I guess the patch name is "intel-iommu-fix-for-iommu-early-crash.patch".

Thanks,
Anil
------------------------------------------------------

Subject: [Intel-IOMMU] Fix for IOMMU early crash

pci_dev's->sysdata is highly overloaded and currently
IOMMU is broken due to IOMMU code depending on this field.

This patch introduces new field in pci_dev's dev.archdata struct to
hold IOMMU specific per device IOMMU private data.

Signed-off-by: Anil S Keshavamurthy <anil.s.keshavamurthy@intel.com>

---
 drivers/pci/intel-iommu.c   |   22 +++++++++++-----------
 include/asm-x86_64/device.h |    3 +++
 2 files changed, 14 insertions(+), 11 deletions(-)

Index: 2.6-mm/drivers/pci/intel-iommu.c
===================================================================
--- 2.6-mm.orig/drivers/pci/intel-iommu.c	2007-10-04 11:35:09.000000000 -0700
+++ 2.6-mm/drivers/pci/intel-iommu.c	2007-10-04 11:47:47.000000000 -0700
@@ -1348,7 +1348,7 @@
 		list_del(&info->link);
 		list_del(&info->global);
 		if (info->dev)
-			info->dev->sysdata = NULL;
+			info->dev->dev.archdata.iommu = NULL;
 		spin_unlock_irqrestore(&device_domain_lock, flags);
 
 		detach_domain_for_dev(info->domain, info->bus, info->devfn);
@@ -1361,7 +1361,7 @@
 
 /*
  * find_domain
- * Note: we use struct pci_dev->sysdata stores the info
+ * Note: we use struct pci_dev->dev.archdata.iommu stores the info
  */
 struct dmar_domain *
 find_domain(struct pci_dev *pdev)
@@ -1369,7 +1369,7 @@
 	struct device_domain_info *info;
 
 	/* No lock here, assumes no domain exit in normal case */
-	info = pdev->sysdata;
+	info = pdev->dev.archdata.iommu;
 	if (info)
 		return info->domain;
 	return NULL;
@@ -1519,7 +1519,7 @@
 	}
 	list_add(&info->link, &domain->devices);
 	list_add(&info->global, &device_domain_list);
-	pdev->sysdata = info;
+	pdev->dev.archdata.iommu = info;
 	spin_unlock_irqrestore(&device_domain_lock, flags);
 	return domain;
 error:
@@ -1579,7 +1579,7 @@
 static inline int iommu_prepare_rmrr_dev(struct dmar_rmrr_unit *rmrr,
 	struct pci_dev *pdev)
 {
-	if (pdev->sysdata == DUMMY_DEVICE_DOMAIN_INFO)
+	if (pdev->dev.archdata.iommu == DUMMY_DEVICE_DOMAIN_INFO)
 		return 0;
 	return iommu_prepare_identity_map(pdev, rmrr->base_address,
 		rmrr->end_address + 1);
@@ -1595,7 +1595,7 @@
 	int ret;
 
 	for_each_pci_dev(pdev) {
-		if (pdev->sysdata == DUMMY_DEVICE_DOMAIN_INFO ||
+		if (pdev->dev.archdata.iommu == DUMMY_DEVICE_DOMAIN_INFO ||
 				!IS_GFX_DEVICE(pdev))
 			continue;
 		printk(KERN_INFO "IOMMU: gfx device %s 1-1 mapping\n",
@@ -1836,7 +1836,7 @@
 	int prot = 0;
 
 	BUG_ON(dir == DMA_NONE);
-	if (pdev->sysdata == DUMMY_DEVICE_DOMAIN_INFO)
+	if (pdev->dev.archdata.iommu == DUMMY_DEVICE_DOMAIN_INFO)
 		return virt_to_bus(addr);
 
 	domain = get_valid_domain_for_dev(pdev);
@@ -1900,7 +1900,7 @@
 	unsigned long start_addr;
 	struct iova *iova;
 
-	if (pdev->sysdata == DUMMY_DEVICE_DOMAIN_INFO)
+	if (pdev->dev.archdata.iommu == DUMMY_DEVICE_DOMAIN_INFO)
 		return;
 	domain = find_domain(pdev);
 	BUG_ON(!domain);
@@ -1974,7 +1974,7 @@
 	size_t size = 0;
 	void *addr;
 
-	if (pdev->sysdata == DUMMY_DEVICE_DOMAIN_INFO)
+	if (pdev->dev.archdata.iommu == DUMMY_DEVICE_DOMAIN_INFO)
 		return;
 
 	domain = find_domain(pdev);
@@ -2032,7 +2032,7 @@
 	unsigned long start_addr;
 
 	BUG_ON(dir == DMA_NONE);
-	if (pdev->sysdata == DUMMY_DEVICE_DOMAIN_INFO)
+	if (pdev->dev.archdata.iommu == DUMMY_DEVICE_DOMAIN_INFO)
 		return intel_nontranslate_map_sg(hwdev, sg, nelems, dir);
 
 	domain = get_valid_domain_for_dev(pdev);
@@ -2234,7 +2234,7 @@
 		for (i = 0; i < drhd->devices_cnt; i++) {
 			if (!drhd->devices[i])
 				continue;
-			drhd->devices[i]->sysdata = DUMMY_DEVICE_DOMAIN_INFO;
+			drhd->devices[i]->dev.archdata.iommu = DUMMY_DEVICE_DOMAIN_INFO;
 		}
 	}
 }
Index: 2.6-mm/include/asm-x86_64/device.h
===================================================================
--- 2.6-mm.orig/include/asm-x86_64/device.h	2007-10-04 11:35:09.000000000 -0700
+++ 2.6-mm/include/asm-x86_64/device.h	2007-10-04 11:49:44.000000000 -0700
@@ -10,6 +10,9 @@
 #ifdef CONFIG_ACPI
 	void	*acpi_handle;
 #endif
+#ifdef CONFIG_DMAR
+	void *iommu; /* hook for IOMMU specific extension */
+#endif
 };
 
 #endif /* _ASM_X86_64_DEVICE_H */
