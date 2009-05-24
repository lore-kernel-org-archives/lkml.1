Return-Path: <linux-kernel-owner+w=401wt.eu-S1760044AbZEXQCz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760044AbZEXQCz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 May 2009 12:02:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758946AbZEXPzO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 May 2009 11:55:14 -0400
Received: from mx2.redhat.com ([66.187.237.31]:41827 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753802AbZEXPuc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 May 2009 11:50:32 -0400
From: Avi Kivity <avi@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: kvm@vger.kernel.org
Subject: [PATCH 11/45] KVM: Enable snooping control for supported hardware
Date: Sun, 24 May 2009 18:49:56 +0300
Message-Id: <1243180230-2480-12-git-send-email-avi@redhat.com>
In-Reply-To: <1243180230-2480-1-git-send-email-avi@redhat.com>
References: <1243180230-2480-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sheng Yang <sheng@linux.intel.com>

Memory aliases with different memory type is a problem for guest. For the guest
without assigned device, the memory type of guest memory would always been the
same as host(WB); but for the assigned device, some part of memory may be used
as DMA and then set to uncacheable memory type(UC/WC), which would be a conflict of
host memory type then be a potential issue.

Snooping control can guarantee the cache correctness of memory go through the
DMA engine of VT-d.

[avi: fix build on ia64]

Signed-off-by: Sheng Yang <sheng@linux.intel.com>
Signed-off-by: Avi Kivity <avi@redhat.com>
---
 arch/ia64/include/asm/kvm_host.h |    1 +
 arch/x86/include/asm/kvm_host.h  |    1 +
 arch/x86/kvm/vmx.c               |   19 +++++++++++++++++--
 include/linux/kvm_host.h         |    3 +++
 virt/kvm/iommu.c                 |   27 ++++++++++++++++++++++++---
 5 files changed, 46 insertions(+), 5 deletions(-)

diff --git a/arch/ia64/include/asm/kvm_host.h b/arch/ia64/include/asm/kvm_host.h
index 589536f..5f43697 100644
--- a/arch/ia64/include/asm/kvm_host.h
+++ b/arch/ia64/include/asm/kvm_host.h
@@ -474,6 +474,7 @@ struct kvm_arch {
 
 	struct list_head assigned_dev_head;
 	struct iommu_domain *iommu_domain;
+	int iommu_flags;
 	struct hlist_head irq_ack_notifier_list;
 
 	unsigned long irq_sources_bitmap;
diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 8a6f6b6..253d8f6 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -393,6 +393,7 @@ struct kvm_arch{
 	struct list_head active_mmu_pages;
 	struct list_head assigned_dev_head;
 	struct iommu_domain *iommu_domain;
+	int iommu_flags;
 	struct kvm_pic *vpic;
 	struct kvm_ioapic *vioapic;
 	struct kvm_pit *vpit;
diff --git a/arch/x86/kvm/vmx.c b/arch/x86/kvm/vmx.c
index 59b080c..e8a5649 100644
--- a/arch/x86/kvm/vmx.c
+++ b/arch/x86/kvm/vmx.c
@@ -3581,11 +3581,26 @@ static u64 vmx_get_mt_mask(struct kvm_vcpu *vcpu, gfn_t gfn, bool is_mmio)
 {
 	u64 ret;
 
+	/* For VT-d and EPT combination
+	 * 1. MMIO: always map as UC
+	 * 2. EPT with VT-d:
+	 *   a. VT-d without snooping control feature: can't guarantee the
+	 *	result, try to trust guest.
+	 *   b. VT-d with snooping control feature: snooping control feature of
+	 *	VT-d engine can guarantee the cache correctness. Just set it
+	 *	to WB to keep consistent with host. So the same as item 3.
+	 * 3. EPT without VT-d: always map as WB and set IGMT=1 to keep
+	 *    consistent with host MTRR
+	 */
 	if (is_mmio)
 		ret = MTRR_TYPE_UNCACHABLE << VMX_EPT_MT_EPTE_SHIFT;
+	else if (vcpu->kvm->arch.iommu_domain &&
+		!(vcpu->kvm->arch.iommu_flags & KVM_IOMMU_CACHE_COHERENCY))
+		ret = kvm_get_guest_memory_type(vcpu, gfn) <<
+		      VMX_EPT_MT_EPTE_SHIFT;
 	else
-		ret = (kvm_get_guest_memory_type(vcpu, gfn) <<
-			VMX_EPT_MT_EPTE_SHIFT) | VMX_EPT_IGMT_BIT;
+		ret = (MTRR_TYPE_WRBACK << VMX_EPT_MT_EPTE_SHIFT)
+			| VMX_EPT_IGMT_BIT;
 
 	return ret;
 }
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 72d5684..bdce8e1 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -367,6 +367,9 @@ void kvm_unregister_irq_ack_notifier(struct kvm_irq_ack_notifier *kian);
 int kvm_request_irq_source_id(struct kvm *kvm);
 void kvm_free_irq_source_id(struct kvm *kvm, int irq_source_id);
 
+/* For vcpu->arch.iommu_flags */
+#define KVM_IOMMU_CACHE_COHERENCY	0x1
+
 #ifdef CONFIG_IOMMU_API
 int kvm_iommu_map_pages(struct kvm *kvm, gfn_t base_gfn,
 			unsigned long npages);
diff --git a/virt/kvm/iommu.c b/virt/kvm/iommu.c
index 4c40375..1514758 100644
--- a/virt/kvm/iommu.c
+++ b/virt/kvm/iommu.c
@@ -39,11 +39,16 @@ int kvm_iommu_map_pages(struct kvm *kvm,
 	pfn_t pfn;
 	int i, r = 0;
 	struct iommu_domain *domain = kvm->arch.iommu_domain;
+	int flags;
 
 	/* check if iommu exists and in use */
 	if (!domain)
 		return 0;
 
+	flags = IOMMU_READ | IOMMU_WRITE;
+	if (kvm->arch.iommu_flags & KVM_IOMMU_CACHE_COHERENCY)
+		flags |= IOMMU_CACHE;
+
 	for (i = 0; i < npages; i++) {
 		/* check if already mapped */
 		if (iommu_iova_to_phys(domain, gfn_to_gpa(gfn)))
@@ -53,8 +58,7 @@ int kvm_iommu_map_pages(struct kvm *kvm,
 		r = iommu_map_range(domain,
 				    gfn_to_gpa(gfn),
 				    pfn_to_hpa(pfn),
-				    PAGE_SIZE,
-				    IOMMU_READ | IOMMU_WRITE);
+				    PAGE_SIZE, flags);
 		if (r) {
 			printk(KERN_ERR "kvm_iommu_map_address:"
 			       "iommu failed to map pfn=%lx\n", pfn);
@@ -88,7 +92,7 @@ int kvm_assign_device(struct kvm *kvm,
 {
 	struct pci_dev *pdev = NULL;
 	struct iommu_domain *domain = kvm->arch.iommu_domain;
-	int r;
+	int r, last_flags;
 
 	/* check if iommu exists and in use */
 	if (!domain)
@@ -107,12 +111,29 @@ int kvm_assign_device(struct kvm *kvm,
 		return r;
 	}
 
+	last_flags = kvm->arch.iommu_flags;
+	if (iommu_domain_has_cap(kvm->arch.iommu_domain,
+				 IOMMU_CAP_CACHE_COHERENCY))
+		kvm->arch.iommu_flags |= KVM_IOMMU_CACHE_COHERENCY;
+
+	/* Check if need to update IOMMU page table for guest memory */
+	if ((last_flags ^ kvm->arch.iommu_flags) ==
+			KVM_IOMMU_CACHE_COHERENCY) {
+		kvm_iommu_unmap_memslots(kvm);
+		r = kvm_iommu_map_memslots(kvm);
+		if (r)
+			goto out_unmap;
+	}
+
 	printk(KERN_DEBUG "assign device: host bdf = %x:%x:%x\n",
 		assigned_dev->host_busnr,
 		PCI_SLOT(assigned_dev->host_devfn),
 		PCI_FUNC(assigned_dev->host_devfn));
 
 	return 0;
+out_unmap:
+	kvm_iommu_unmap_memslots(kvm);
+	return r;
 }
 
 int kvm_deassign_device(struct kvm *kvm,
-- 
1.6.0.6

