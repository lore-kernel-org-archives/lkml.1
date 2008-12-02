Return-Path: <linux-kernel-owner+w=401wt.eu-S1755494AbYLBNE4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755494AbYLBNE4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2008 08:04:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754762AbYLBNCJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Dec 2008 08:02:09 -0500
Received: from outbound-va3.frontbridge.com ([216.32.180.16]:26738 "EHLO
	VA3EHSOBE003.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754673AbYLBNBs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2008 08:01:48 -0500
X-BigFish: VPS-1(zz655Ozzzz2b68kz32i43j65h)
X-Spam-TCS-SCL: 4:0
X-FB-SS: 5,
X-WSS-ID: 0KB92UC-04-VCR-01
From: Joerg Roedel <joerg.roedel@amd.com>
To: Ingo Molnar <mingo@redhat.com>, Avi Kivity <avi@redhat.com>,
       David Woodhouse <dwmw2@infradead.org>,
       Greg Kroah-Hartman <gregkh@suse.de>, Alexander Graf <agraf@suse.de>,
       Han Weidong <weidong.han@intel.com>
CC: linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
       iommu@lists.linux-foundation.org, Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 07/12] KVM: change KVM iommu.c to use IOMMU API
Date: Tue, 2 Dec 2008 14:01:18 +0100
Message-ID: <1228222883-17207-8-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.5.6.4
In-Reply-To: <1228222883-17207-1-git-send-email-joerg.roedel@amd.com>
References: <1228222883-17207-1-git-send-email-joerg.roedel@amd.com>
X-OriginalArrivalTime: 02 Dec 2008 13:01:23.0911 (UTC) FILETIME=[143FD570:01C9547E]
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 arch/ia64/kvm/Makefile          |    2 +-
 arch/x86/include/asm/kvm_host.h |    3 +-
 arch/x86/kvm/Makefile           |    2 +-
 virt/kvm/iommu.c                |   68 ++++++++++++++++++++-------------------
 virt/kvm/kvm_main.c             |    2 +-
 5 files changed, 40 insertions(+), 37 deletions(-)

diff --git a/arch/ia64/kvm/Makefile b/arch/ia64/kvm/Makefile
index cb69dfc..0bb99b7 100644
--- a/arch/ia64/kvm/Makefile
+++ b/arch/ia64/kvm/Makefile
@@ -51,7 +51,7 @@ EXTRA_AFLAGS += -Ivirt/kvm -Iarch/ia64/kvm/
 common-objs = $(addprefix ../../../virt/kvm/, kvm_main.o ioapic.o \
 		coalesced_mmio.o irq_comm.o)
 
-ifeq ($(CONFIG_DMAR),y)
+ifeq ($(CONFIG_IOMMU_API),y)
 common-objs += $(addprefix ../../../virt/kvm/, iommu.o)
 endif
 
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
diff --git a/arch/x86/kvm/Makefile b/arch/x86/kvm/Makefile
index 00f46c2..d3ec292 100644
--- a/arch/x86/kvm/Makefile
+++ b/arch/x86/kvm/Makefile
@@ -7,7 +7,7 @@ common-objs = $(addprefix ../../../virt/kvm/, kvm_main.o ioapic.o \
 ifeq ($(CONFIG_KVM_TRACE),y)
 common-objs += $(addprefix ../../../virt/kvm/, kvm_trace.o)
 endif
-ifeq ($(CONFIG_DMAR),y)
+ifeq ($(CONFIG_IOMMU_API),y)
 common-objs += $(addprefix ../../../virt/kvm/, iommu.o)
 endif
 
diff --git a/virt/kvm/iommu.c b/virt/kvm/iommu.c
index 832ee04..110c455 100644
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
@@ -36,9 +39,9 @@ int kvm_iommu_map_pages(struct kvm *kvm,
 {
 	gfn_t gfn = base_gfn;
 	pfn_t pfn;
-	int r = 0;
-	unsigned long i;
-	struct dmar_domain *domain = kvm->arch.intel_iommu_domain;
+	phys_addr_t paddr;
+	int i, r = 0;
+	struct iommu_domain *domain = kvm->arch.iommu_domain;
 
 	/* check if iommu exists and in use */
 	if (!domain)
@@ -46,18 +49,13 @@ int kvm_iommu_map_pages(struct kvm *kvm,
 
 	for (i = 0; i < npages; i++) {
 		/* check if already mapped */
-		pfn = (pfn_t)intel_iommu_iova_to_pfn(domain,
-						     gfn_to_gpa(gfn));
-		if (pfn)
+		paddr = (pfn_t)iommu_iova_to_phys(domain, gfn_to_gpa(gfn));
+		if (paddr)
 			kvm_iommu_put_pages(kvm, gfn, 1);
 
 		pfn = gfn_to_pfn(kvm, gfn);
-		r = intel_iommu_map_pages(domain,
-					  gfn_to_gpa(gfn),
-					  pfn_to_hpa(pfn),
-					  PAGE_SIZE,
-					  DMA_PTE_READ |
-					  DMA_PTE_WRITE);
+		r = iommu_map_range(domain, gfn_to_gpa(gfn), pfn_to_hpa(pfn),
+				    PAGE_SIZE, DMA_PTE_READ | DMA_PTE_WRITE);
 		if (r) {
 			printk(KERN_ERR "kvm_iommu_map_pages:"
 			       "iommu failed to map pfn=%lx\n", pfn);
@@ -91,7 +89,7 @@ int kvm_assign_device(struct kvm *kvm,
 		      struct kvm_assigned_dev_kernel *assigned_dev)
 {
 	struct pci_dev *pdev = NULL;
-	struct dmar_domain *domain = kvm->arch.intel_iommu_domain;
+	struct iommu_domain *domain = kvm->arch.iommu_domain;
 	int r;
 
 	/* check if iommu exists and in use */
@@ -102,7 +100,12 @@ int kvm_assign_device(struct kvm *kvm,
 	if (pdev == NULL)
 		return -ENODEV;
 
-	r = intel_iommu_assign_device(domain, pdev);
+	if (!iommu_found()) {
+		printk(KERN_ERR "%s: No IOMMU found\n", __func__);
+		return -ENODEV;
+	}
+
+	r = iommu_attach_device(domain, &pdev->dev);
 	if (r) {
 		printk(KERN_ERR "assign device %x:%x.%x failed",
 		       pdev->bus->number,
@@ -111,7 +114,7 @@ int kvm_assign_device(struct kvm *kvm,
 		return r;
 	}
 
-	printk(KERN_DEBUG "assign device: host bdf = %x:%x:%x\n",
+	printk(KERN_DEBUG "KVM IOMMU direct map: host bdf = %x:%x:%x\n",
 	       assigned_dev->host_busnr,
 	       PCI_SLOT(assigned_dev->host_devfn),
 	       PCI_FUNC(assigned_dev->host_devfn));
@@ -122,7 +125,7 @@ int kvm_assign_device(struct kvm *kvm,
 int kvm_deassign_device(struct kvm *kvm,
 			struct kvm_assigned_dev_kernel *assigned_dev)
 {
-	struct dmar_domain *domain = kvm->arch.intel_iommu_domain;
+	struct iommu_domain *domain = kvm->arch.iommu_domain;
 	struct pci_dev *pdev = NULL;
 
 	/* check if iommu exists and in use */
@@ -133,7 +136,7 @@ int kvm_deassign_device(struct kvm *kvm,
 	if (pdev == NULL)
 		return -ENODEV;
 
-	intel_iommu_deassign_device(domain, pdev);
+	iommu_detach_device(domain, &pdev->dev);
 
 	printk(KERN_DEBUG "deassign device: host bdf = %x:%x:%x\n",
 	       assigned_dev->host_busnr,
@@ -147,13 +150,13 @@ int kvm_iommu_map_guest(struct kvm *kvm)
 {
 	int r;
 
-	if (!intel_iommu_found()) {
-		printk(KERN_ERR "%s: intel iommu not found\n", __func__);
+	if (!iommu_found()) {
+		printk(KERN_ERR "%s: iommu not found\n", __func__);
 		return -ENODEV;
 	}
 
-	kvm->arch.intel_iommu_domain = intel_iommu_alloc_domain();
-	if (!kvm->arch.intel_iommu_domain)
+	kvm->arch.iommu_domain = iommu_domain_alloc();
+	if (!kvm->arch.iommu_domain)
 		return -ENOMEM;
 
 	r = kvm_iommu_map_memslots(kvm);
@@ -171,8 +174,8 @@ static void kvm_iommu_put_pages(struct kvm *kvm,
 				gfn_t base_gfn, unsigned long npages)
 {
 	gfn_t gfn = base_gfn;
-	pfn_t pfn;
-	struct dmar_domain *domain = kvm->arch.intel_iommu_domain;
+	phys_addr_t paddr;
+	struct iommu_domain *domain = kvm->arch.iommu_domain;
 	unsigned long i;
 
 	/* check if iommu exists and in use */
@@ -180,15 +183,12 @@ static void kvm_iommu_put_pages(struct kvm *kvm,
 		return;
 
 	for (i = 0; i < npages; i++) {
-		pfn = (pfn_t)intel_iommu_iova_to_pfn(domain,
-						     gfn_to_gpa(gfn));
-		kvm_release_pfn_clean(pfn);
+		paddr = iommu_iova_to_phys(domain, gfn_to_gpa(gfn));
+		kvm_release_pfn_clean(paddr >> PAGE_SHIFT);
 		gfn++;
 	}
 
-	intel_iommu_unmap_pages(domain,
-				gfn_to_gpa(base_gfn),
-				PAGE_SIZE * npages);
+	iommu_unmap_range(domain, gfn_to_gpa(base_gfn), PAGE_SIZE * npages);
 }
 
 static int kvm_iommu_unmap_memslots(struct kvm *kvm)
@@ -207,22 +207,24 @@ static int kvm_iommu_unmap_memslots(struct kvm *kvm)
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
 
 		/* detach kvm dmar domain */
-		intel_iommu_deassign_device(domain, entry->dev);
+		iommu_detach_device(domain, &pdev->dev);
 	}
 	kvm_iommu_unmap_memslots(kvm);
-	intel_iommu_free_domain(domain);
+	iommu_domain_free(domain);
+
 	return 0;
 }
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index fe6aba0..397ad0f 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -472,7 +472,7 @@ static int kvm_vm_ioctl_assign_device(struct kvm *kvm,
 	list_add(&match->list, &kvm->arch.assigned_dev_head);
 
 	if (assigned_dev->flags & KVM_DEV_ASSIGN_ENABLE_IOMMU) {
-		if (!kvm->arch.intel_iommu_domain) {
+		if (!kvm->arch.iommu_domain) {
 			r = kvm_iommu_map_guest(kvm);
 			if (r)
 				goto out_list_del;
-- 
1.5.6.4


