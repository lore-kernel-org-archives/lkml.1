Return-Path: <linux-kernel-owner+w=401wt.eu-S1755698Ab0A1LjY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755698Ab0A1LjY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jan 2010 06:39:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755744Ab0A1LjV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Jan 2010 06:39:21 -0500
Received: from tx2ehsobe005.messaging.microsoft.com ([65.55.88.15]:28829 "EHLO
	TX2EHSOBE010.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932204Ab0A1Lij (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jan 2010 06:38:39 -0500
X-SpamScore: 8
X-BigFish: VPS8(z1857rzab9bh936eMzz1202hzzz32i6bh87h43j61h)
X-Spam-TCS-SCL: 0:0
X-FB-DOMAIN-IP-MATCH: fail
X-WSS-ID: 0KWYGC1-01-FXY-02
X-M-MSG: 
From: Joerg Roedel <joerg.roedel@amd.com>
To: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
       David Woodhouse <dwmw2@infradead.org>
CC: kvm@vger.kernel.org, iommu@lists.linux-foundation.org,
       linux-kernel@vger.kernel.org, Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 06/11] kvm: Change kvm_iommu_map_pages to map large pages
Date: Thu, 28 Jan 2010 12:37:57 +0100
Message-ID: <1264678682-30655-7-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.6.6
In-Reply-To: <1264678682-30655-1-git-send-email-joerg.roedel@amd.com>
References: <1264678682-30655-1-git-send-email-joerg.roedel@amd.com>
X-OriginalArrivalTime: 28 Jan 2010 11:38:20.0945 (UTC) FILETIME=[647E1010:01CAA00E]
MIME-Version: 1.0
Content-Type: text/plain
X-Reverse-DNS: unknown
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch changes the implementation of of
kvm_iommu_map_pages to map the pages with the host page size
into the io virtual address space.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 virt/kvm/iommu.c |  106 ++++++++++++++++++++++++++++++++++++++++++-----------
 1 files changed, 84 insertions(+), 22 deletions(-)

diff --git a/virt/kvm/iommu.c b/virt/kvm/iommu.c
index 65a5143..92a434d 100644
--- a/virt/kvm/iommu.c
+++ b/virt/kvm/iommu.c
@@ -32,12 +32,27 @@ static int kvm_iommu_unmap_memslots(struct kvm *kvm);
 static void kvm_iommu_put_pages(struct kvm *kvm,
 				gfn_t base_gfn, unsigned long npages);
 
+static pfn_t kvm_pin_pages(struct kvm *kvm, struct kvm_memory_slot *slot,
+			   gfn_t gfn, unsigned long size)
+{
+	gfn_t end_gfn;
+	pfn_t pfn;
+
+	pfn     = gfn_to_pfn_memslot(kvm, slot, gfn);
+	end_gfn = gfn + (size >> PAGE_SHIFT);
+	gfn    += 1;
+
+	while (gfn < end_gfn)
+		gfn_to_pfn_memslot(kvm, slot, gfn++);
+
+	return pfn;
+}
+
 int kvm_iommu_map_pages(struct kvm *kvm, struct kvm_memory_slot *slot)
 {
-	gfn_t gfn = slot->base_gfn;
-	unsigned long npages = slot->npages;
+	gfn_t gfn, end_gfn;
 	pfn_t pfn;
-	int i, r = 0;
+	int r = 0;
 	struct iommu_domain *domain = kvm->arch.iommu_domain;
 	int flags;
 
@@ -45,31 +60,58 @@ int kvm_iommu_map_pages(struct kvm *kvm, struct kvm_memory_slot *slot)
 	if (!domain)
 		return 0;
 
+	gfn     = slot->base_gfn;
+	end_gfn = gfn + slot->npages;
+
 	flags = IOMMU_READ | IOMMU_WRITE;
 	if (kvm->arch.iommu_flags & KVM_IOMMU_CACHE_COHERENCY)
 		flags |= IOMMU_CACHE;
 
-	for (i = 0; i < npages; i++) {
-		/* check if already mapped */
-		if (iommu_iova_to_phys(domain, gfn_to_gpa(gfn)))
+
+	while (gfn < end_gfn) {
+		unsigned long page_size;
+
+		/* Check if already mapped */
+		if (iommu_iova_to_phys(domain, gfn_to_gpa(gfn))) {
+			gfn += 1;
 			continue;
+		}
+
+		/* Get the page size we could use to map */
+		page_size = kvm_host_page_size(kvm, gfn);
+
+		/* Make sure the page_size does not exceed the memslot */
+		while ((gfn + (page_size >> PAGE_SHIFT)) > end_gfn)
+			page_size >>= 1;
+
+		/* Make sure gfn is aligned to the page size we want to map */
+		while ((gfn << PAGE_SHIFT) & (page_size - 1))
+			page_size >>= 1;
+
+		/*
+		 * Pin all pages we are about to map in memory. This is
+		 * important because we unmap and unpin in 4kb steps later.
+		 */
+		pfn = kvm_pin_pages(kvm, slot, gfn, page_size);
+
+		/* Map into IO address space */
+		r = iommu_map(domain, gfn_to_gpa(gfn), pfn_to_hpa(pfn),
+			      get_order(page_size), flags);
+
+		gfn += page_size >> PAGE_SHIFT;
 
-		pfn = gfn_to_pfn_memslot(kvm, slot, gfn);
-		r = iommu_map_range(domain,
-				    gfn_to_gpa(gfn),
-				    pfn_to_hpa(pfn),
-				    PAGE_SIZE, flags);
 		if (r) {
 			printk(KERN_ERR "kvm_iommu_map_address:"
 			       "iommu failed to map pfn=%lx\n", pfn);
 			goto unmap_pages;
 		}
-		gfn++;
+
 	}
+
 	return 0;
 
 unmap_pages:
-	kvm_iommu_put_pages(kvm, slot->base_gfn, i);
+	kvm_iommu_put_pages(kvm, slot->base_gfn, gfn);
 	return r;
 }
 
@@ -186,27 +228,47 @@ out_unmap:
 	return r;
 }
 
+static void kvm_unpin_pages(struct kvm *kvm, pfn_t pfn, unsigned long npages)
+{
+	unsigned long i;
+
+	for (i = 0; i < npages; ++i)
+		kvm_release_pfn_clean(pfn + i);
+}
+
 static void kvm_iommu_put_pages(struct kvm *kvm,
 				gfn_t base_gfn, unsigned long npages)
 {
-	gfn_t gfn = base_gfn;
+	struct iommu_domain *domain;
+	gfn_t end_gfn, gfn;
 	pfn_t pfn;
-	struct iommu_domain *domain = kvm->arch.iommu_domain;
-	unsigned long i;
 	u64 phys;
 
+	domain  = kvm->arch.iommu_domain;
+	end_gfn = base_gfn + npages;
+	gfn     = base_gfn;
+
 	/* check if iommu exists and in use */
 	if (!domain)
 		return;
 
-	for (i = 0; i < npages; i++) {
+	while (gfn < end_gfn) {
+		unsigned long unmap_pages;
+		int order;
+
+		/* Get physical address */
 		phys = iommu_iova_to_phys(domain, gfn_to_gpa(gfn));
-		pfn = phys >> PAGE_SHIFT;
-		kvm_release_pfn_clean(pfn);
-		gfn++;
-	}
+		pfn  = phys >> PAGE_SHIFT;
+
+		/* Unmap address from IO address space */
+		order       = iommu_unmap(domain, gfn_to_gpa(gfn), PAGE_SIZE);
+		unmap_pages = 1ULL << order;
 
-	iommu_unmap_range(domain, gfn_to_gpa(base_gfn), PAGE_SIZE * npages);
+		/* Unpin all pages we just unmapped to not leak any memory */
+		kvm_unpin_pages(kvm, pfn, unmap_pages);
+
+		gfn += unmap_pages;
+	}
 }
 
 static int kvm_iommu_unmap_memslots(struct kvm *kvm)
-- 
1.6.6


