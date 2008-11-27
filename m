Return-Path: <linux-kernel-owner+w=401wt.eu-S1756331AbYK0Poj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756331AbYK0Poj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2008 10:44:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754825AbYK0Plh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Nov 2008 10:41:37 -0500
Received: from outbound-wa4.frontbridge.com ([216.32.181.16]:15944 "EHLO
	WA4EHSOBE005.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753364AbYK0PlZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2008 10:41:25 -0500
X-BigFish: VPS-4(zz655Ozzzzz32i43j62h)
X-Spam-TCS-SCL: 1:0
X-WSS-ID: 0KB00W8-03-L7E-01
From: Joerg Roedel <joerg.roedel@amd.com>
To: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
       iommu@lists.linux-foundation.org
CC: avi@redhat.com, weidong.han@intel.com, mingo@redhat.com,
       dwmw2@infradead.org, amit.shah@redhat.com,
       Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 9/9] KVM: change KVM iommu.c to use IOMMU API
Date: Thu, 27 Nov 2008 16:40:54 +0100
Message-ID: <1227800454-9555-10-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.5.6.4
In-Reply-To: <1227800454-9555-1-git-send-email-joerg.roedel@amd.com>
References: <1227800454-9555-1-git-send-email-joerg.roedel@amd.com>
X-OriginalArrivalTime: 27 Nov 2008 15:40:54.0953 (UTC) FILETIME=[88F83190:01C950A6]
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 arch/x86/include/asm/kvm_host.h |    3 +-
 virt/kvm/iommu.c                |   66 ++++++++++++++++++++-------------------
 2 files changed, 36 insertions(+), 33 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index f58f7eb..77f4afa 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -14,6 +14,7 @@
 #include <linux/types.h>
 #include <linux/mm.h>
 #include <linux/mmu_notifier.h>
+#include <linux/iommu.h>
 
 #include <linux/kvm.h>
 #include <linux/kvm_para.h>
@@ -356,7 +357,7 @@ struct kvm_arch{
 	 */
 	struct list_head active_mmu_pages;
 	struct list_head assigned_dev_head;
-	struct dmar_domain *intel_iommu_domain;
+	struct iommu_domain *iommu_domain;
 	struct kvm_pic *vpic;
 	struct kvm_ioapic *vioapic;
 	struct kvm_pit *vpit;
diff --git a/virt/kvm/iommu.c b/virt/kvm/iommu.c
index a770874..48d1e5e 100644
--- a/virt/kvm/iommu.c
+++ b/virt/kvm/iommu.c
@@ -16,15 +16,18 @@
  *
  * Copyright (C) 2006-2008 Intel Corporation
  * Copyright IBM Corporation, 2008
+ * Copyright (C) 2008 Advanced Micro Devices, Inc.
  * Author: Allen M. Kay <allen.m.kay@intel.com>
  * Author: Weidong Han <weidong.han@intel.com>
  * Author: Ben-Ami Yassour <benami@il.ibm.com>
+ * Author: Joerg Roedel <joerg.roedel@amd.com>
  */
 
 #include <linux/list.h>
 #include <linux/kvm_host.h>
 #include <linux/pci.h>
 #include <linux/dmar.h>
+#include <linux/iommu.h>
 #include <linux/intel-iommu.h>
 
 static int kvm_iommu_unmap_memslots(struct kvm *kvm);
@@ -36,8 +39,9 @@ int kvm_iommu_map_pages(struct kvm *kvm,
 {
 	gfn_t gfn = base_gfn;
 	pfn_t pfn;
+	phys_addr_t phys;
 	int i, r = 0;
-	struct dmar_domain *domain = kvm->arch.intel_iommu_domain;
+	struct iommu_domain *domain = kvm->arch.iommu_domain;
 
 	/* check if iommu exists and in use */
 	if (!domain)
@@ -45,18 +49,16 @@ int kvm_iommu_map_pages(struct kvm *kvm,
 
 	for (i = 0; i < npages; i++) {
 		/* check if already mapped */
-		pfn = (pfn_t)intel_iommu_iova_to_pfn(domain,
-						     gfn_to_gpa(gfn));
-		if (pfn)
+		phys = iommu_iova_to_phys(domain, gfn_to_gpa(gfn));
+		if (phys)
 			continue;
 
 		pfn = gfn_to_pfn(kvm, gfn);
-		r = intel_iommu_page_mapping(domain,
-					     gfn_to_gpa(gfn),
-					     pfn_to_hpa(pfn),
-					     PAGE_SIZE,
-					     DMA_PTE_READ |
-					     DMA_PTE_WRITE);
+		r = iommu_map_address(domain,
+				      gfn_to_gpa(gfn),
+				      pfn_to_hpa(pfn),
+				      PAGE_SIZE,
+				      DMA_PTE_READ | DMA_PTE_WRITE);
 		if (r) {
 			printk(KERN_ERR "kvm_iommu_map_pages:"
 			       "iommu failed to map pfn=%lx\n", pfn);
@@ -92,12 +94,12 @@ int kvm_iommu_map_guest(struct kvm *kvm,
 	struct pci_dev *pdev = NULL;
 	int r;
 
-	if (!intel_iommu_found()) {
-		printk(KERN_ERR "%s: intel iommu not found\n", __func__);
+	if (!iommu_found()) {
+		printk(KERN_ERR "%s: No IOMMU found\n", __func__);
 		return -ENODEV;
 	}
 
-	printk(KERN_DEBUG "VT-d direct map: host bdf = %x:%x:%x\n",
+	printk(KERN_DEBUG "KVM IOMMU direct map: host bdf = %x:%x:%x\n",
 	       assigned_dev->host_busnr,
 	       PCI_SLOT(assigned_dev->host_devfn),
 	       PCI_FUNC(assigned_dev->host_devfn));
@@ -105,26 +107,24 @@ int kvm_iommu_map_guest(struct kvm *kvm,
 	pdev = assigned_dev->dev;
 
 	if (pdev == NULL) {
-		if (kvm->arch.intel_iommu_domain) {
-			intel_iommu_domain_exit(kvm->arch.intel_iommu_domain);
-			kvm->arch.intel_iommu_domain = NULL;
+		if (kvm->arch.iommu_domain) {
+			iommu_domain_free(kvm->arch.iommu_domain);
+			kvm->arch.iommu_domain = NULL;
 		}
 		return -ENODEV;
 	}
 
-	kvm->arch.intel_iommu_domain = intel_iommu_domain_alloc(pdev);
-	if (!kvm->arch.intel_iommu_domain)
+	kvm->arch.iommu_domain = iommu_domain_alloc(&pdev->dev);
+	if (!kvm->arch.iommu_domain)
 		return -ENODEV;
 
 	r = kvm_iommu_map_memslots(kvm);
 	if (r)
 		goto out_unmap;
 
-	intel_iommu_detach_dev(kvm->arch.intel_iommu_domain,
-			       pdev->bus->number, pdev->devfn);
+	iommu_detach_device(kvm->arch.iommu_domain, &pdev->dev);
 
-	r = intel_iommu_context_mapping(kvm->arch.intel_iommu_domain,
-					pdev);
+	r = iommu_attach_device(kvm->arch.iommu_domain, &pdev->dev);
 	if (r) {
 		printk(KERN_ERR "Domain context map for %s failed",
 		       pci_name(pdev));
@@ -138,16 +138,16 @@ out_unmap:
 }
 
 static void kvm_iommu_put_pages(struct kvm *kvm,
-			       gfn_t base_gfn, unsigned long npages)
+				gfn_t base_gfn, unsigned long npages)
 {
 	gfn_t gfn = base_gfn;
 	pfn_t pfn;
-	struct dmar_domain *domain = kvm->arch.intel_iommu_domain;
+	struct iommu_domain *domain = kvm->arch.iommu_domain;
 	int i;
 
 	for (i = 0; i < npages; i++) {
-		pfn = (pfn_t)intel_iommu_iova_to_pfn(domain,
-						     gfn_to_gpa(gfn));
+		pfn = (pfn_t)iommu_iova_to_phys(domain, gfn_to_gpa(gfn));
+		pfn >>= PAGE_SHIFT;
 		kvm_release_pfn_clean(pfn);
 		gfn++;
 	}
@@ -169,23 +169,25 @@ static int kvm_iommu_unmap_memslots(struct kvm *kvm)
 int kvm_iommu_unmap_guest(struct kvm *kvm)
 {
 	struct kvm_assigned_dev_kernel *entry;
-	struct dmar_domain *domain = kvm->arch.intel_iommu_domain;
+	struct iommu_domain *domain = kvm->arch.iommu_domain;
 
 	/* check if iommu exists and in use */
 	if (!domain)
 		return 0;
 
 	list_for_each_entry(entry, &kvm->arch.assigned_dev_head, list) {
-		printk(KERN_DEBUG "VT-d unmap: host bdf = %x:%x:%x\n",
+		struct pci_dev *pdev = entry->dev;
+		printk(KERN_DEBUG "IOMMU unmap: host bdf = %x:%x:%x\n",
 		       entry->host_busnr,
 		       PCI_SLOT(entry->host_devfn),
 		       PCI_FUNC(entry->host_devfn));
 
-		/* detach kvm dmar domain */
-		intel_iommu_detach_dev(domain, entry->host_busnr,
-				       entry->host_devfn);
+		/* detach kvm iommu domain */
+		iommu_detach_device(domain, &pdev->dev);
 	}
 	kvm_iommu_unmap_memslots(kvm);
-	intel_iommu_domain_exit(domain);
+	iommu_domain_free(kvm->arch.iommu_domain);
+	kvm->arch.iommu_domain = NULL;
+
 	return 0;
 }
-- 
1.5.6.4


