Return-Path: <linux-kernel-owner+w=401wt.eu-S1757997AbYLDRbs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757997AbYLDRbs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2008 12:31:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756884AbYLDR3Y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Dec 2008 12:29:24 -0500
Received: from outbound-va3.frontbridge.com ([216.32.180.16]:11734 "EHLO
	VA3EHSOBE003.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754589AbYLDR3K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2008 12:29:10 -0500
X-BigFish: VPS6(zzzzzz2b68kz32i43j66h)
X-Spam-TCS-SCL: 5:0
X-FB-SS: 5,
X-WSS-ID: 0KBD4K6-03-CRB-01
From: Joerg Roedel <joerg.roedel@amd.com>
To: avi@redhat.com, mingo@redhat.com, dwmw2@infradead.org, gregkh@suse.de,
       weidong.han@intel.com
CC: iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       kvm@vger.kernel.org, Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 05/11] KVM: change KVM to use IOMMU API
Date: Thu, 4 Dec 2008 18:28:50 +0100
Message-ID: <1228411736-22644-6-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.5.6.4
In-Reply-To: <20081204172142.GH12816@amd.com>
References: <20081204172142.GH12816@amd.com>
X-OriginalArrivalTime: 04 Dec 2008 17:28:56.0709 (UTC) FILETIME=[C949EB50:01C95635]
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 arch/ia64/include/asm/kvm_host.h |    2 +-
 arch/ia64/kvm/Makefile           |    2 +-
 arch/ia64/kvm/kvm-ia64.c         |    3 +-
 arch/x86/include/asm/kvm_host.h  |    2 +-
 arch/x86/kvm/Makefile            |    2 +-
 arch/x86/kvm/x86.c               |    3 +-
 include/linux/kvm_host.h         |    6 ++--
 virt/kvm/iommu.c                 |   45 +++++++++++++++++--------------------
 virt/kvm/kvm_main.c              |    2 +-
 9 files changed, 33 insertions(+), 34 deletions(-)

diff --git a/arch/ia64/include/asm/kvm_host.h b/arch/ia64/include/asm/kvm_host.h
index 0560f3f..3486636 100644
--- a/arch/ia64/include/asm/kvm_host.h
+++ b/arch/ia64/include/asm/kvm_host.h
@@ -467,7 +467,7 @@ struct kvm_arch {
 	struct kvm_sal_data rdv_sal_data;
 
 	struct list_head assigned_dev_head;
-	struct dmar_domain *intel_iommu_domain;
+	struct iommu_domain *iommu_domain;
 	struct hlist_head irq_ack_notifier_list;
 
 	unsigned long irq_sources_bitmap;
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
 
diff --git a/arch/ia64/kvm/kvm-ia64.c b/arch/ia64/kvm/kvm-ia64.c
index b4d24e2..483a15b 100644
--- a/arch/ia64/kvm/kvm-ia64.c
+++ b/arch/ia64/kvm/kvm-ia64.c
@@ -31,6 +31,7 @@
 #include <linux/bitops.h>
 #include <linux/hrtimer.h>
 #include <linux/uaccess.h>
+#include <linux/iommu.h>
 #include <linux/intel-iommu.h>
 
 #include <asm/pgtable.h>
@@ -189,7 +190,7 @@ int kvm_dev_ioctl_check_extension(long ext)
 		r = KVM_COALESCED_MMIO_PAGE_OFFSET;
 		break;
 	case KVM_CAP_IOMMU:
-		r = intel_iommu_found();
+		r = iommu_found();
 		break;
 	default:
 		r = 0;
diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index f58f7eb..6b24a10 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -356,7 +356,7 @@ struct kvm_arch{
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
 
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 7a2aeba..5d2787b 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -34,6 +34,7 @@
 #include <linux/module.h>
 #include <linux/mman.h>
 #include <linux/highmem.h>
+#include <linux/iommu.h>
 #include <linux/intel-iommu.h>
 
 #include <asm/uaccess.h>
@@ -987,7 +988,7 @@ int kvm_dev_ioctl_check_extension(long ext)
 		r = !tdp_enabled;
 		break;
 	case KVM_CAP_IOMMU:
-		r = intel_iommu_found();
+		r = iommu_found();
 		break;
 	default:
 		r = 0;
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index cb1d404..ca93f7f 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -326,7 +326,7 @@ void kvm_unregister_irq_ack_notifier(struct kvm_irq_ack_notifier *kian);
 int kvm_request_irq_source_id(struct kvm *kvm);
 void kvm_free_irq_source_id(struct kvm *kvm, int irq_source_id);
 
-#ifdef CONFIG_DMAR
+#ifdef CONFIG_IOMMU_API
 int kvm_iommu_map_pages(struct kvm *kvm, gfn_t base_gfn,
 			unsigned long npages);
 int kvm_iommu_map_guest(struct kvm *kvm);
@@ -335,7 +335,7 @@ int kvm_assign_device(struct kvm *kvm,
 		      struct kvm_assigned_dev_kernel *assigned_dev);
 int kvm_deassign_device(struct kvm *kvm,
 			struct kvm_assigned_dev_kernel *assigned_dev);
-#else /* CONFIG_DMAR */
+#else /* CONFIG_IOMMU_API */
 static inline int kvm_iommu_map_pages(struct kvm *kvm,
 				      gfn_t base_gfn,
 				      unsigned long npages)
@@ -364,7 +364,7 @@ static inline int kvm_deassign_device(struct kvm *kvm,
 {
 	return 0;
 }
-#endif /* CONFIG_DMAR */
+#endif /* CONFIG_IOMMU_API */
 
 static inline void kvm_guest_enter(void)
 {
diff --git a/virt/kvm/iommu.c b/virt/kvm/iommu.c
index 174ea1f..8a7f488 100644
--- a/virt/kvm/iommu.c
+++ b/virt/kvm/iommu.c
@@ -25,6 +25,7 @@
 #include <linux/kvm_host.h>
 #include <linux/pci.h>
 #include <linux/dmar.h>
+#include <linux/iommu.h>
 #include <linux/intel-iommu.h>
 
 static int kvm_iommu_unmap_memslots(struct kvm *kvm);
@@ -37,7 +38,7 @@ int kvm_iommu_map_pages(struct kvm *kvm,
 	gfn_t gfn = base_gfn;
 	pfn_t pfn;
 	int i, r = 0;
-	struct dmar_domain *domain = kvm->arch.intel_iommu_domain;
+	struct iommu_domain *domain = kvm->arch.iommu_domain;
 
 	/* check if iommu exists and in use */
 	if (!domain)
@@ -45,16 +46,15 @@ int kvm_iommu_map_pages(struct kvm *kvm,
 
 	for (i = 0; i < npages; i++) {
 		/* check if already mapped */
-		if (intel_iommu_iova_to_phys(domain,
-					     gfn_to_gpa(gfn)))
+		if (iommu_iova_to_phys(domain, gfn_to_gpa(gfn)))
 			continue;
 
 		pfn = gfn_to_pfn(kvm, gfn);
-		r = intel_iommu_map_address(domain,
-					    gfn_to_gpa(gfn),
-					    pfn_to_hpa(pfn),
-					    PAGE_SIZE,
-					    DMA_PTE_READ | DMA_PTE_WRITE);
+		r = iommu_map_range(domain,
+				    gfn_to_gpa(gfn),
+				    pfn_to_hpa(pfn),
+				    PAGE_SIZE,
+				    IOMMU_READ | IOMMU_WRITE);
 		if (r) {
 			printk(KERN_ERR "kvm_iommu_map_address:"
 			       "iommu failed to map pfn=%lx\n", pfn);
@@ -88,7 +88,7 @@ int kvm_assign_device(struct kvm *kvm,
 		      struct kvm_assigned_dev_kernel *assigned_dev)
 {
 	struct pci_dev *pdev = NULL;
-	struct dmar_domain *domain = kvm->arch.intel_iommu_domain;
+	struct iommu_domain *domain = kvm->arch.iommu_domain;
 	int r;
 
 	/* check if iommu exists and in use */
@@ -99,7 +99,7 @@ int kvm_assign_device(struct kvm *kvm,
 	if (pdev == NULL)
 		return -ENODEV;
 
-	r = intel_iommu_attach_device(domain, pdev);
+	r = iommu_attach_device(domain, &pdev->dev);
 	if (r) {
 		printk(KERN_ERR "assign device %x:%x.%x failed",
 			pdev->bus->number,
@@ -119,7 +119,7 @@ int kvm_assign_device(struct kvm *kvm,
 int kvm_deassign_device(struct kvm *kvm,
 			struct kvm_assigned_dev_kernel *assigned_dev)
 {
-	struct dmar_domain *domain = kvm->arch.intel_iommu_domain;
+	struct iommu_domain *domain = kvm->arch.iommu_domain;
 	struct pci_dev *pdev = NULL;
 
 	/* check if iommu exists and in use */
@@ -130,7 +130,7 @@ int kvm_deassign_device(struct kvm *kvm,
 	if (pdev == NULL)
 		return -ENODEV;
 
-	intel_iommu_detach_device(domain, pdev);
+	iommu_detach_device(domain, &pdev->dev);
 
 	printk(KERN_DEBUG "deassign device: host bdf = %x:%x:%x\n",
 		assigned_dev->host_busnr,
@@ -144,13 +144,13 @@ int kvm_iommu_map_guest(struct kvm *kvm)
 {
 	int r;
 
-	if (!intel_iommu_found()) {
+	if (!iommu_found()) {
 		printk(KERN_ERR "%s: intel iommu not found\n", __func__);
 		return -ENODEV;
 	}
 
-	kvm->arch.intel_iommu_domain = intel_iommu_alloc_domain();
-	if (!kvm->arch.intel_iommu_domain)
+	kvm->arch.iommu_domain = iommu_domain_alloc();
+	if (!kvm->arch.iommu_domain)
 		return -ENOMEM;
 
 	r = kvm_iommu_map_memslots(kvm);
@@ -169,7 +169,7 @@ static void kvm_iommu_put_pages(struct kvm *kvm,
 {
 	gfn_t gfn = base_gfn;
 	pfn_t pfn;
-	struct dmar_domain *domain = kvm->arch.intel_iommu_domain;
+	struct iommu_domain *domain = kvm->arch.iommu_domain;
 	unsigned long i;
 	u64 phys;
 
@@ -178,16 +178,13 @@ static void kvm_iommu_put_pages(struct kvm *kvm,
 		return;
 
 	for (i = 0; i < npages; i++) {
-		phys = intel_iommu_iova_to_phys(domain,
-						gfn_to_gpa(gfn));
+		phys = iommu_iova_to_phys(domain, gfn_to_gpa(gfn));
 		pfn = phys >> PAGE_SHIFT;
 		kvm_release_pfn_clean(pfn);
 		gfn++;
 	}
 
-	intel_iommu_unmap_address(domain,
-				  gfn_to_gpa(base_gfn),
-				  PAGE_SIZE * npages);
+	iommu_unmap_range(domain, gfn_to_gpa(base_gfn), PAGE_SIZE * npages);
 }
 
 static int kvm_iommu_unmap_memslots(struct kvm *kvm)
@@ -206,7 +203,7 @@ static int kvm_iommu_unmap_memslots(struct kvm *kvm)
 int kvm_iommu_unmap_guest(struct kvm *kvm)
 {
 	struct kvm_assigned_dev_kernel *entry;
-	struct dmar_domain *domain = kvm->arch.intel_iommu_domain;
+	struct iommu_domain *domain = kvm->arch.iommu_domain;
 
 	/* check if iommu exists and in use */
 	if (!domain)
@@ -219,9 +216,9 @@ int kvm_iommu_unmap_guest(struct kvm *kvm)
 		       PCI_FUNC(entry->host_devfn));
 
 		/* detach kvm dmar domain */
-		intel_iommu_detach_device(domain, entry->dev);
+		iommu_detach_device(domain, &entry->dev->dev);
 	}
 	kvm_iommu_unmap_memslots(kvm);
-	intel_iommu_free_domain(domain);
+	iommu_domain_free(domain);
 	return 0;
 }
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 07ab668..000594e 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -490,7 +490,7 @@ static int kvm_vm_ioctl_assign_device(struct kvm *kvm,
 	list_add(&match->list, &kvm->arch.assigned_dev_head);
 
 	if (assigned_dev->flags & KVM_DEV_ASSIGN_ENABLE_IOMMU) {
-		if (!kvm->arch.intel_iommu_domain) {
+		if (!kvm->arch.iommu_domain) {
 			r = kvm_iommu_map_guest(kvm);
 			if (r)
 				goto out_list_del;
-- 
1.5.6.4


