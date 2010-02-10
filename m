Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755960Ab0BJRYZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Feb 2010 12:24:25 -0500
Received: from mx1.redhat.com ([209.132.183.28]:53438 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755790Ab0BJRXP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Feb 2010 12:23:15 -0500
From: Avi Kivity <avi@redhat.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 30/40] KVM: use gfn_to_pfn_memslot in kvm_iommu_map_pages
Date: Wed, 10 Feb 2010 19:22:59 +0200
Message-Id: <1265822589-11155-31-git-send-email-avi@redhat.com>
In-Reply-To: <1265822589-11155-1-git-send-email-avi@redhat.com>
References: <1265822589-11155-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Marcelo Tosatti <mtosatti@redhat.com>

So its possible to iommu map a memslot before making it visible to
kvm.

Signed-off-by: Marcelo Tosatti <mtosatti@redhat.com>
---
 include/linux/kvm_host.h |    3 +--
 virt/kvm/iommu.c         |   13 ++++++-------
 virt/kvm/kvm_main.c      |    2 +-
 3 files changed, 8 insertions(+), 10 deletions(-)

diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index f1f78de..9af2403 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -440,8 +440,7 @@ void kvm_free_irq_source_id(struct kvm *kvm, int irq_source_id);
 #define KVM_IOMMU_CACHE_COHERENCY	0x1
 
 #ifdef CONFIG_IOMMU_API
-int kvm_iommu_map_pages(struct kvm *kvm, gfn_t base_gfn,
-			unsigned long npages);
+int kvm_iommu_map_pages(struct kvm *kvm, struct kvm_memory_slot *slot);
 int kvm_iommu_map_guest(struct kvm *kvm);
 int kvm_iommu_unmap_guest(struct kvm *kvm);
 int kvm_assign_device(struct kvm *kvm,
diff --git a/virt/kvm/iommu.c b/virt/kvm/iommu.c
index bc697a6..cf567d8 100644
--- a/virt/kvm/iommu.c
+++ b/virt/kvm/iommu.c
@@ -32,10 +32,10 @@ static int kvm_iommu_unmap_memslots(struct kvm *kvm);
 static void kvm_iommu_put_pages(struct kvm *kvm,
 				gfn_t base_gfn, unsigned long npages);
 
-int kvm_iommu_map_pages(struct kvm *kvm,
-			gfn_t base_gfn, unsigned long npages)
+int kvm_iommu_map_pages(struct kvm *kvm, struct kvm_memory_slot *slot)
 {
-	gfn_t gfn = base_gfn;
+	gfn_t gfn = slot->base_gfn;
+	unsigned long npages = slot->npages;
 	pfn_t pfn;
 	int i, r = 0;
 	struct iommu_domain *domain = kvm->arch.iommu_domain;
@@ -54,7 +54,7 @@ int kvm_iommu_map_pages(struct kvm *kvm,
 		if (iommu_iova_to_phys(domain, gfn_to_gpa(gfn)))
 			continue;
 
-		pfn = gfn_to_pfn(kvm, gfn);
+		pfn = gfn_to_pfn_memslot(kvm, slot, gfn);
 		r = iommu_map_range(domain,
 				    gfn_to_gpa(gfn),
 				    pfn_to_hpa(pfn),
@@ -69,7 +69,7 @@ int kvm_iommu_map_pages(struct kvm *kvm,
 	return 0;
 
 unmap_pages:
-	kvm_iommu_put_pages(kvm, base_gfn, i);
+	kvm_iommu_put_pages(kvm, slot->base_gfn, i);
 	return r;
 }
 
@@ -81,8 +81,7 @@ static int kvm_iommu_map_memslots(struct kvm *kvm)
 	slots = kvm->memslots;
 
 	for (i = 0; i < slots->nmemslots; i++) {
-		r = kvm_iommu_map_pages(kvm, slots->memslots[i].base_gfn,
-					slots->memslots[i].npages);
+		r = kvm_iommu_map_pages(kvm, &slots->memslots[i]);
 		if (r)
 			break;
 	}
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 4e2321c..87d296d 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -684,7 +684,7 @@ skip_lpage:
 	spin_unlock(&kvm->mmu_lock);
 #ifdef CONFIG_DMAR
 	/* map the pages in iommu page table */
-	r = kvm_iommu_map_pages(kvm, base_gfn, npages);
+	r = kvm_iommu_map_pages(kvm, memslot);
 	if (r)
 		goto out;
 #endif
-- 
1.6.5.3

