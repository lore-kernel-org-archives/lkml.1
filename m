Return-Path: <linux-kernel-owner+w=401wt.eu-S1758946AbXLWPCN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758946AbXLWPCN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Dec 2007 10:02:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756080AbXLWOwP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Dec 2007 09:52:15 -0500
Received: from il.qumranet.com ([82.166.9.18]:35927 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753586AbXLWOvp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Dec 2007 09:51:45 -0500
From: Avi Kivity <avi@qumranet.com>
To: linux-kernel@vger.kernel.org, kvm-devel@lists.sourceforge.net
Cc: Anthony Liguori <aliguori@us.ibm.com>
Subject: [PATCH 30/50] KVM: MMU: More struct kvm_vcpu -> struct kvm cleanups
Date: Sun, 23 Dec 2007 16:51:15 +0200
Message-Id: <1198421495-31481-31-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.3.7
In-Reply-To: <1198421495-31481-1-git-send-email-avi@qumranet.com>
References: <1198421495-31481-1-git-send-email-avi@qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Anthony Liguori <aliguori@us.ibm.com>

This time, the biggest change is gpa_to_hpa. The translation of GPA to HPA does
not depend on the VCPU state unlike GVA to GPA so there's no need to pass in
the kvm_vcpu.

Signed-off-by: Anthony Liguori <aliguori@us.ibm.com>
Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 drivers/kvm/kvm.h         |    2 +-
 drivers/kvm/mmu.c         |   26 +++++++++++++-------------
 drivers/kvm/paging_tmpl.h |    6 +++---
 3 files changed, 17 insertions(+), 17 deletions(-)

diff --git a/drivers/kvm/kvm.h b/drivers/kvm/kvm.h
index 9c9c1d7..d56962d 100644
--- a/drivers/kvm/kvm.h
+++ b/drivers/kvm/kvm.h
@@ -554,7 +554,7 @@ void kvm_mmu_slot_remove_write_access(struct kvm *kvm, int slot);
 void kvm_mmu_zap_all(struct kvm *kvm);
 void kvm_mmu_change_mmu_pages(struct kvm *kvm, unsigned int kvm_nr_mmu_pages);
 
-hpa_t gpa_to_hpa(struct kvm_vcpu *vcpu, gpa_t gpa);
+hpa_t gpa_to_hpa(struct kvm *kvm, gpa_t gpa);
 #define HPA_MSB ((sizeof(hpa_t) * 8) - 1)
 #define HPA_ERR_MASK ((hpa_t)1 << HPA_MSB)
 static inline int is_error_hpa(hpa_t hpa) { return hpa >> HPA_MSB; }
diff --git a/drivers/kvm/mmu.c b/drivers/kvm/mmu.c
index a5ca945..d046ba8 100644
--- a/drivers/kvm/mmu.c
+++ b/drivers/kvm/mmu.c
@@ -451,14 +451,14 @@ static void rmap_remove(struct kvm *kvm, u64 *spte)
 	}
 }
 
-static void rmap_write_protect(struct kvm_vcpu *vcpu, u64 gfn)
+static void rmap_write_protect(struct kvm *kvm, u64 gfn)
 {
 	struct kvm_rmap_desc *desc;
 	unsigned long *rmapp;
 	u64 *spte;
 
-	gfn = unalias_gfn(vcpu->kvm, gfn);
-	rmapp = gfn_to_rmap(vcpu->kvm, gfn);
+	gfn = unalias_gfn(kvm, gfn);
+	rmapp = gfn_to_rmap(kvm, gfn);
 
 	while (*rmapp) {
 		if (!(*rmapp & 1))
@@ -471,9 +471,9 @@ static void rmap_write_protect(struct kvm_vcpu *vcpu, u64 gfn)
 		BUG_ON(!(*spte & PT_PRESENT_MASK));
 		BUG_ON(!(*spte & PT_WRITABLE_MASK));
 		rmap_printk("rmap_write_protect: spte %p %llx\n", spte, *spte);
-		rmap_remove(vcpu->kvm, spte);
+		rmap_remove(kvm, spte);
 		set_shadow_pte(spte, *spte & ~PT_WRITABLE_MASK);
-		kvm_flush_remote_tlbs(vcpu->kvm);
+		kvm_flush_remote_tlbs(kvm);
 	}
 }
 
@@ -670,7 +670,7 @@ static struct kvm_mmu_page *kvm_mmu_get_page(struct kvm_vcpu *vcpu,
 	hlist_add_head(&page->hash_link, bucket);
 	vcpu->mmu.prefetch_page(vcpu, page);
 	if (!metaphysical)
-		rmap_write_protect(vcpu, gfn);
+		rmap_write_protect(vcpu->kvm, gfn);
 	return page;
 }
 
@@ -823,19 +823,19 @@ static void page_header_update_slot(struct kvm *kvm, void *pte, gpa_t gpa)
 	__set_bit(slot, &page_head->slot_bitmap);
 }
 
-hpa_t safe_gpa_to_hpa(struct kvm_vcpu *vcpu, gpa_t gpa)
+hpa_t safe_gpa_to_hpa(struct kvm *kvm, gpa_t gpa)
 {
-	hpa_t hpa = gpa_to_hpa(vcpu, gpa);
+	hpa_t hpa = gpa_to_hpa(kvm, gpa);
 
 	return is_error_hpa(hpa) ? bad_page_address | (gpa & ~PAGE_MASK): hpa;
 }
 
-hpa_t gpa_to_hpa(struct kvm_vcpu *vcpu, gpa_t gpa)
+hpa_t gpa_to_hpa(struct kvm *kvm, gpa_t gpa)
 {
 	struct page *page;
 
 	ASSERT((gpa & HPA_ERR_MASK) == 0);
-	page = gfn_to_page(vcpu->kvm, gpa >> PAGE_SHIFT);
+	page = gfn_to_page(kvm, gpa >> PAGE_SHIFT);
 	if (!page)
 		return gpa | HPA_ERR_MASK;
 	return ((hpa_t)page_to_pfn(page) << PAGE_SHIFT)
@@ -848,7 +848,7 @@ hpa_t gva_to_hpa(struct kvm_vcpu *vcpu, gva_t gva)
 
 	if (gpa == UNMAPPED_GVA)
 		return UNMAPPED_GVA;
-	return gpa_to_hpa(vcpu, gpa);
+	return gpa_to_hpa(vcpu->kvm, gpa);
 }
 
 struct page *gva_to_page(struct kvm_vcpu *vcpu, gva_t gva)
@@ -857,7 +857,7 @@ struct page *gva_to_page(struct kvm_vcpu *vcpu, gva_t gva)
 
 	if (gpa == UNMAPPED_GVA)
 		return NULL;
-	return pfn_to_page(gpa_to_hpa(vcpu, gpa) >> PAGE_SHIFT);
+	return pfn_to_page(gpa_to_hpa(vcpu->kvm, gpa) >> PAGE_SHIFT);
 }
 
 static void nonpaging_new_cr3(struct kvm_vcpu *vcpu)
@@ -1012,7 +1012,7 @@ static int nonpaging_page_fault(struct kvm_vcpu *vcpu, gva_t gva,
 	ASSERT(VALID_PAGE(vcpu->mmu.root_hpa));
 
 
-	paddr = gpa_to_hpa(vcpu , addr & PT64_BASE_ADDR_MASK);
+	paddr = gpa_to_hpa(vcpu->kvm, addr & PT64_BASE_ADDR_MASK);
 
 	if (is_error_hpa(paddr))
 		return 1;
diff --git a/drivers/kvm/paging_tmpl.h b/drivers/kvm/paging_tmpl.h
index 4f6edf8..8e1e4ca 100644
--- a/drivers/kvm/paging_tmpl.h
+++ b/drivers/kvm/paging_tmpl.h
@@ -103,7 +103,7 @@ static int FNAME(walk_addr)(struct guest_walker *walker,
 	pgprintk("%s: table_gfn[%d] %lx\n", __FUNCTION__,
 		 walker->level - 1, table_gfn);
 	slot = gfn_to_memslot(vcpu->kvm, table_gfn);
-	hpa = safe_gpa_to_hpa(vcpu, root & PT64_BASE_ADDR_MASK);
+	hpa = safe_gpa_to_hpa(vcpu->kvm, root & PT64_BASE_ADDR_MASK);
 	walker->page = pfn_to_page(hpa >> PAGE_SHIFT);
 	walker->table = kmap_atomic(walker->page, KM_USER0);
 
@@ -159,7 +159,7 @@ static int FNAME(walk_addr)(struct guest_walker *walker,
 		walker->inherited_ar &= walker->table[index];
 		table_gfn = (*ptep & PT_BASE_ADDR_MASK) >> PAGE_SHIFT;
 		kunmap_atomic(walker->table, KM_USER0);
-		paddr = safe_gpa_to_hpa(vcpu, table_gfn << PAGE_SHIFT);
+		paddr = safe_gpa_to_hpa(vcpu->kvm, table_gfn << PAGE_SHIFT);
 		walker->page = pfn_to_page(paddr >> PAGE_SHIFT);
 		walker->table = kmap_atomic(walker->page, KM_USER0);
 		--walker->level;
@@ -248,7 +248,7 @@ static void FNAME(set_pte_common)(struct kvm_vcpu *vcpu,
 	if (!dirty)
 		access_bits &= ~PT_WRITABLE_MASK;
 
-	paddr = gpa_to_hpa(vcpu, gaddr & PT64_BASE_ADDR_MASK);
+	paddr = gpa_to_hpa(vcpu->kvm, gaddr & PT64_BASE_ADDR_MASK);
 
 	spte |= PT_PRESENT_MASK;
 	if (access_bits & PT_USER_MASK)
-- 
1.5.3.7

