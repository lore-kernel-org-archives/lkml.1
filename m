Return-Path: <linux-kernel-owner+w=401wt.eu-S1758842AbZC0Oe0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758842AbZC0Oe0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Mar 2009 10:34:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757573AbZC0Ocd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Mar 2009 10:32:33 -0400
Received: from tx2ehsobe003.messaging.microsoft.com ([65.55.88.13]:4367 "EHLO
	TX2EHSOBE006.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756337AbZC0OcY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Mar 2009 10:32:24 -0400
X-BigFish: VPS-2(z5b2jz14c3Mzz1202hzzz32i62h)
X-Spam-TCS-SCL: 1:0
X-FB-SS: 5,8,
X-WSS-ID: 0KH65PE-02-E3S-01
From: Joerg Roedel <joerg.roedel@amd.com>
To: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>
CC: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
       Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 2/7] kvm mmu: infrastructure changes for multiple huge page support
Date: Fri, 27 Mar 2009 15:31:54 +0100
Message-ID: <1238164319-16092-3-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.5.6.4
In-Reply-To: <1238164319-16092-1-git-send-email-joerg.roedel@amd.com>
References: <1238164319-16092-1-git-send-email-joerg.roedel@amd.com>
X-OriginalArrivalTime: 27 Mar 2009 14:32:00.0259 (UTC) FILETIME=[CA11F530:01C9AEE8]
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch includes most of the necessary changes to the KVM SoftMMU for
supporting more than one huge page size. The changes in this patch
include:

  * introduce 'enum kvm_page_size' which is used to represent the page
    size used
  * change boolean is_largepage_backed() function to backing_size()
    which returns the largest page size KVM can use to map a gfn
  * change the other largepage flags to 'enum kvm_page_size'

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 arch/x86/include/asm/kvm_host.h |   17 ++++--
 arch/x86/kvm/mmu.c              |  111 +++++++++++++++++++++------------------
 arch/x86/kvm/paging_tmpl.h      |   22 ++++----
 3 files changed, 83 insertions(+), 67 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 8351c4d..f268f99 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -52,11 +52,13 @@
 #define UNMAPPED_GVA (~(gpa_t)0)
 
 /* shadow tables are PAE even on non-PAE hosts */
-#define KVM_HPAGE_SHIFT 21
-#define KVM_HPAGE_SIZE (1UL << KVM_HPAGE_SHIFT)
-#define KVM_HPAGE_MASK (~(KVM_HPAGE_SIZE - 1))
+#define KVM_2M_PAGE_SHIFT 21
+#define KVM_2M_PAGE_SIZE (1UL << KVM_2M_PAGE_SHIFT)
+#define KVM_2M_PAGE_MASK (~(KVM_2M_PAGE_SIZE - 1))
 
-#define KVM_PAGES_PER_HPAGE (KVM_HPAGE_SIZE / PAGE_SIZE)
+#define KVM_PAGES_PER_2M_PAGE (KVM_2M_PAGE_SIZE / PAGE_SIZE)
+
+#define KVM_PAGES_PER_HPAGE	KVM_PAGES_PER_2M_PAGE
 
 #define DE_VECTOR 0
 #define DB_VECTOR 1
@@ -263,6 +265,11 @@ struct kvm_mmu {
 	u64 *pae_root;
 };
 
+enum kvm_page_size {
+	KVM_PAGE_SIZE_4k = (1 << 12),
+	KVM_PAGE_SIZE_2M = (1 << 21),
+};
+
 struct kvm_vcpu_arch {
 	u64 host_tsc;
 	int interrupt_window_open;
@@ -310,7 +317,7 @@ struct kvm_vcpu_arch {
 	struct {
 		gfn_t gfn;	/* presumed gfn during guest pte update */
 		pfn_t pfn;	/* pfn corresponding to that gfn */
-		int largepage;
+		enum kvm_page_size page_size;
 		unsigned long mmu_seq;
 	} update_pte;
 
diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index b625ed4..3a57c17 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -385,8 +385,8 @@ static int *slot_largepage_idx(gfn_t gfn, struct kvm_memory_slot *slot)
 {
 	unsigned long idx;
 
-	idx = (gfn / KVM_PAGES_PER_HPAGE) -
-	      (slot->base_gfn / KVM_PAGES_PER_HPAGE);
+	idx = (gfn / KVM_PAGES_PER_2M_PAGE) -
+	      (slot->base_gfn / KVM_PAGES_PER_2M_PAGE);
 	return &slot->lpage_info[idx].write_count;
 }
 
@@ -426,11 +426,11 @@ static int has_wrprotected_page(struct kvm *kvm, gfn_t gfn)
 	return 1;
 }
 
-static int host_largepage_backed(struct kvm *kvm, gfn_t gfn)
+static enum kvm_page_size host_page_size(struct kvm *kvm, gfn_t gfn)
 {
 	struct vm_area_struct *vma;
-	unsigned long addr;
-	int ret = 0;
+	unsigned long addr, size;
+	enum kvm_page_size ret = KVM_PAGE_SIZE_4k;
 
 	addr = gfn_to_hva(kvm, gfn);
 	if (kvm_is_error_hva(addr))
@@ -438,28 +438,31 @@ static int host_largepage_backed(struct kvm *kvm, gfn_t gfn)
 
 	down_read(&current->mm->mmap_sem);
 	vma = find_vma(current->mm, addr);
-	if (vma && is_vm_hugetlb_page(vma))
-		ret = 1;
+	if (vma) {
+		size = vma_kernel_pagesize(vma);
+		if (size >= KVM_PAGE_SIZE_2M)
+			ret = KVM_PAGE_SIZE_2M;
+	}
 	up_read(&current->mm->mmap_sem);
 
 	return ret;
 }
 
-static int is_largepage_backed(struct kvm_vcpu *vcpu, gfn_t large_gfn)
+static enum kvm_page_size backing_size(struct kvm_vcpu *vcpu, gfn_t gfn)
 {
 	struct kvm_memory_slot *slot;
 
-	if (has_wrprotected_page(vcpu->kvm, large_gfn))
-		return 0;
+	if (has_wrprotected_page(vcpu->kvm, gfn))
+		return KVM_PAGE_SIZE_4k;
 
-	if (!host_largepage_backed(vcpu->kvm, large_gfn))
-		return 0;
+	if (host_page_size(vcpu->kvm, gfn) < KVM_PAGE_SIZE_2M)
+		return KVM_PAGE_SIZE_4k;
 
-	slot = gfn_to_memslot(vcpu->kvm, large_gfn);
+	slot = gfn_to_memslot(vcpu->kvm, gfn);
 	if (slot && slot->dirty_bitmap)
-		return 0;
+		return KVM_PAGE_SIZE_4k;
 
-	return 1;
+	return KVM_PAGE_SIZE_2M;
 }
 
 /*
@@ -467,17 +470,18 @@ static int is_largepage_backed(struct kvm_vcpu *vcpu, gfn_t large_gfn)
  * Note: gfn must be unaliased before this function get called
  */
 
-static unsigned long *gfn_to_rmap(struct kvm *kvm, gfn_t gfn, int lpage)
+static unsigned long *gfn_to_rmap(struct kvm *kvm, gfn_t gfn,
+				  enum kvm_page_size psize)
 {
 	struct kvm_memory_slot *slot;
 	unsigned long idx;
 
 	slot = gfn_to_memslot(kvm, gfn);
-	if (!lpage)
+	if (psize == KVM_PAGE_SIZE_4k)
 		return &slot->rmap[gfn - slot->base_gfn];
 
-	idx = (gfn / KVM_PAGES_PER_HPAGE) -
-	      (slot->base_gfn / KVM_PAGES_PER_HPAGE);
+	idx = (gfn / KVM_PAGES_PER_2M_PAGE) -
+	      (slot->base_gfn / KVM_PAGES_PER_2M_PAGE);
 
 	return &slot->lpage_info[idx].rmap_pde;
 }
@@ -491,7 +495,8 @@ static unsigned long *gfn_to_rmap(struct kvm *kvm, gfn_t gfn, int lpage)
  * If rmapp bit zero is one, (then rmap & ~1) points to a struct kvm_rmap_desc
  * containing more mappings.
  */
-static void rmap_add(struct kvm_vcpu *vcpu, u64 *spte, gfn_t gfn, int lpage)
+static void rmap_add(struct kvm_vcpu *vcpu, u64 *spte, gfn_t gfn,
+		     enum kvm_page_size psize)
 {
 	struct kvm_mmu_page *sp;
 	struct kvm_rmap_desc *desc;
@@ -503,7 +508,7 @@ static void rmap_add(struct kvm_vcpu *vcpu, u64 *spte, gfn_t gfn, int lpage)
 	gfn = unalias_gfn(vcpu->kvm, gfn);
 	sp = page_header(__pa(spte));
 	sp->gfns[spte - sp->spt] = gfn;
-	rmapp = gfn_to_rmap(vcpu->kvm, gfn, lpage);
+	rmapp = gfn_to_rmap(vcpu->kvm, gfn, psize);
 	if (!*rmapp) {
 		rmap_printk("rmap_add: %p %llx 0->1\n", spte, *spte);
 		*rmapp = (unsigned long)spte;
@@ -559,6 +564,7 @@ static void rmap_remove(struct kvm *kvm, u64 *spte)
 	pfn_t pfn;
 	unsigned long *rmapp;
 	int i;
+	enum kvm_page_size psize;
 
 	if (!is_rmap_pte(*spte))
 		return;
@@ -570,7 +576,8 @@ static void rmap_remove(struct kvm *kvm, u64 *spte)
 		kvm_release_pfn_dirty(pfn);
 	else
 		kvm_release_pfn_clean(pfn);
-	rmapp = gfn_to_rmap(kvm, sp->gfns[spte - sp->spt], is_large_pte(*spte));
+	psize = is_large_pte(*spte) ? KVM_PAGE_SIZE_2M : KVM_PAGE_SIZE_4k;
+	rmapp = gfn_to_rmap(kvm, sp->gfns[spte - sp->spt], psize);
 	if (!*rmapp) {
 		printk(KERN_ERR "rmap_remove: %p %llx 0->BUG\n", spte, *spte);
 		BUG();
@@ -636,7 +643,7 @@ static int rmap_write_protect(struct kvm *kvm, u64 gfn)
 	int write_protected = 0;
 
 	gfn = unalias_gfn(kvm, gfn);
-	rmapp = gfn_to_rmap(kvm, gfn, 0);
+	rmapp = gfn_to_rmap(kvm, gfn, KVM_PAGE_SIZE_4k);
 
 	spte = rmap_next(kvm, rmapp, NULL);
 	while (spte) {
@@ -658,7 +665,7 @@ static int rmap_write_protect(struct kvm *kvm, u64 gfn)
 	}
 
 	/* check for huge page mappings */
-	rmapp = gfn_to_rmap(kvm, gfn, 1);
+	rmapp = gfn_to_rmap(kvm, gfn, KVM_PAGE_SIZE_2M);
 	spte = rmap_next(kvm, rmapp, NULL);
 	while (spte) {
 		BUG_ON(!spte);
@@ -719,7 +726,7 @@ static int kvm_handle_hva(struct kvm *kvm, unsigned long hva,
 			retval |= handler(kvm,
 					  &memslot->lpage_info[
 						  gfn_offset /
-						  KVM_PAGES_PER_HPAGE].rmap_pde);
+						  KVM_PAGES_PER_2M_PAGE].rmap_pde);
 		}
 	}
 
@@ -1676,7 +1683,7 @@ static int mmu_need_write_protect(struct kvm_vcpu *vcpu, gfn_t gfn,
 
 static int set_spte(struct kvm_vcpu *vcpu, u64 *shadow_pte,
 		    unsigned pte_access, int user_fault,
-		    int write_fault, int dirty, int largepage,
+		    int write_fault, int dirty, enum kvm_page_size psize,
 		    int global, gfn_t gfn, pfn_t pfn, bool speculative,
 		    bool can_unsync)
 {
@@ -1709,7 +1716,7 @@ static int set_spte(struct kvm_vcpu *vcpu, u64 *shadow_pte,
 		spte |= shadow_nx_mask;
 	if (pte_access & ACC_USER_MASK)
 		spte |= shadow_user_mask;
-	if (largepage)
+	if (psize > KVM_PAGE_SIZE_4k)
 		spte |= PT_PAGE_SIZE_MASK;
 	if (mt_mask) {
 		if (!kvm_is_mmio_pfn(pfn)) {
@@ -1727,7 +1734,8 @@ static int set_spte(struct kvm_vcpu *vcpu, u64 *shadow_pte,
 	if ((pte_access & ACC_WRITE_MASK)
 	    || (write_fault && !is_write_protection(vcpu) && !user_fault)) {
 
-		if (largepage && has_wrprotected_page(vcpu->kvm, gfn)) {
+		if (psize > KVM_PAGE_SIZE_4k &&
+		    has_wrprotected_page(vcpu->kvm, gfn)) {
 			ret = 1;
 			spte = shadow_trap_nonpresent_pte;
 			goto set_pte;
@@ -1765,7 +1773,7 @@ set_pte:
 static void mmu_set_spte(struct kvm_vcpu *vcpu, u64 *shadow_pte,
 			 unsigned pt_access, unsigned pte_access,
 			 int user_fault, int write_fault, int dirty,
-			 int *ptwrite, int largepage, int global,
+			 int *ptwrite, enum kvm_page_size psize, int global,
 			 gfn_t gfn, pfn_t pfn, bool speculative)
 {
 	int was_rmapped = 0;
@@ -1781,7 +1789,7 @@ static void mmu_set_spte(struct kvm_vcpu *vcpu, u64 *shadow_pte,
 		 * If we overwrite a PTE page pointer with a 2MB PMD, unlink
 		 * the parent of the now unreachable PTE.
 		 */
-		if (largepage && !is_large_pte(*shadow_pte)) {
+		if (psize > KVM_PAGE_SIZE_4k && !is_large_pte(*shadow_pte)) {
 			struct kvm_mmu_page *child;
 			u64 pte = *shadow_pte;
 
@@ -1795,7 +1803,7 @@ static void mmu_set_spte(struct kvm_vcpu *vcpu, u64 *shadow_pte,
 			was_rmapped = 1;
 	}
 	if (set_spte(vcpu, shadow_pte, pte_access, user_fault, write_fault,
-		      dirty, largepage, global, gfn, pfn, speculative, true)) {
+		      dirty, psize, global, gfn, pfn, speculative, true)) {
 		if (write_fault)
 			*ptwrite = 1;
 		kvm_x86_ops->tlb_flush(vcpu);
@@ -1811,7 +1819,7 @@ static void mmu_set_spte(struct kvm_vcpu *vcpu, u64 *shadow_pte,
 
 	page_header_update_slot(vcpu->kvm, shadow_pte, gfn);
 	if (!was_rmapped) {
-		rmap_add(vcpu, shadow_pte, gfn, largepage);
+		rmap_add(vcpu, shadow_pte, gfn, psize);
 		if (!is_rmap_pte(*shadow_pte))
 			kvm_release_pfn_clean(pfn);
 	} else {
@@ -1831,7 +1839,7 @@ static void nonpaging_new_cr3(struct kvm_vcpu *vcpu)
 }
 
 static int __direct_map(struct kvm_vcpu *vcpu, gpa_t v, int write,
-			int largepage, gfn_t gfn, pfn_t pfn)
+			enum kvm_page_size psize, gfn_t gfn, pfn_t pfn)
 {
 	struct kvm_shadow_walk_iterator iterator;
 	struct kvm_mmu_page *sp;
@@ -1840,10 +1848,11 @@ static int __direct_map(struct kvm_vcpu *vcpu, gpa_t v, int write,
 
 	for_each_shadow_entry(vcpu, (u64)gfn << PAGE_SHIFT, iterator) {
 		if (iterator.level == PT_PAGE_TABLE_LEVEL
-		    || (largepage && iterator.level == PT_DIRECTORY_LEVEL)) {
+		    || (psize == KVM_PAGE_SIZE_2M &&
+			iterator.level == PT_DIRECTORY_LEVEL)) {
 			mmu_set_spte(vcpu, iterator.sptep, ACC_ALL, ACC_ALL,
 				     0, write, 1, &pt_write,
-				     largepage, 0, gfn, pfn, false);
+				     psize, 0, gfn, pfn, false);
 			++vcpu->stat.pf_fixed;
 			break;
 		}
@@ -1871,14 +1880,12 @@ static int __direct_map(struct kvm_vcpu *vcpu, gpa_t v, int write,
 static int nonpaging_map(struct kvm_vcpu *vcpu, gva_t v, int write, gfn_t gfn)
 {
 	int r;
-	int largepage = 0;
 	pfn_t pfn;
 	unsigned long mmu_seq;
+	enum kvm_page_size psize = backing_size(vcpu, gfn);
 
-	if (is_largepage_backed(vcpu, gfn & ~(KVM_PAGES_PER_HPAGE-1))) {
-		gfn &= ~(KVM_PAGES_PER_HPAGE-1);
-		largepage = 1;
-	}
+	if (psize == KVM_PAGE_SIZE_2M)
+		gfn &= ~(KVM_PAGES_PER_2M_PAGE-1);
 
 	mmu_seq = vcpu->kvm->mmu_notifier_seq;
 	smp_rmb();
@@ -1894,7 +1901,7 @@ static int nonpaging_map(struct kvm_vcpu *vcpu, gva_t v, int write, gfn_t gfn)
 	if (mmu_notifier_retry(vcpu, mmu_seq))
 		goto out_unlock;
 	kvm_mmu_free_some_pages(vcpu);
-	r = __direct_map(vcpu, v, write, largepage, gfn, pfn);
+	r = __direct_map(vcpu, v, write, psize, gfn, pfn);
 	spin_unlock(&vcpu->kvm->mmu_lock);
 
 
@@ -2067,9 +2074,9 @@ static int tdp_page_fault(struct kvm_vcpu *vcpu, gva_t gpa,
 {
 	pfn_t pfn;
 	int r;
-	int largepage = 0;
 	gfn_t gfn = gpa >> PAGE_SHIFT;
 	unsigned long mmu_seq;
+	enum kvm_page_size psize;
 
 	ASSERT(vcpu);
 	ASSERT(VALID_PAGE(vcpu->arch.mmu.root_hpa));
@@ -2078,10 +2085,9 @@ static int tdp_page_fault(struct kvm_vcpu *vcpu, gva_t gpa,
 	if (r)
 		return r;
 
-	if (is_largepage_backed(vcpu, gfn & ~(KVM_PAGES_PER_HPAGE-1))) {
-		gfn &= ~(KVM_PAGES_PER_HPAGE-1);
-		largepage = 1;
-	}
+	psize = backing_size(vcpu, gfn);
+	if (psize == KVM_PAGE_SIZE_2M)
+		gfn &= ~(KVM_PAGES_PER_2M_PAGE-1);
 	mmu_seq = vcpu->kvm->mmu_notifier_seq;
 	smp_rmb();
 	pfn = gfn_to_pfn(vcpu->kvm, gfn);
@@ -2094,7 +2100,7 @@ static int tdp_page_fault(struct kvm_vcpu *vcpu, gva_t gpa,
 		goto out_unlock;
 	kvm_mmu_free_some_pages(vcpu);
 	r = __direct_map(vcpu, gpa, error_code & PFERR_WRITE_MASK,
-			 largepage, gfn, pfn);
+			 psize, gfn, pfn);
 	spin_unlock(&vcpu->kvm->mmu_lock);
 
 	return r;
@@ -2333,7 +2339,7 @@ static void mmu_pte_write_new_pte(struct kvm_vcpu *vcpu,
 				  const void *new)
 {
 	if (sp->role.level != PT_PAGE_TABLE_LEVEL) {
-		if (!vcpu->arch.update_pte.largepage ||
+		if (vcpu->arch.update_pte.page_size != KVM_PAGE_SIZE_2M ||
 		    sp->role.glevels == PT32_ROOT_LEVEL) {
 			++vcpu->kvm->stat.mmu_pde_zapped;
 			return;
@@ -2383,7 +2389,7 @@ static void mmu_guess_page_from_pte_write(struct kvm_vcpu *vcpu, gpa_t gpa,
 	u64 gpte = 0;
 	pfn_t pfn;
 
-	vcpu->arch.update_pte.largepage = 0;
+	vcpu->arch.update_pte.page_size = KVM_PAGE_SIZE_4k;
 
 	if (bytes != 4 && bytes != 8)
 		return;
@@ -2412,9 +2418,10 @@ static void mmu_guess_page_from_pte_write(struct kvm_vcpu *vcpu, gpa_t gpa,
 		return;
 	gfn = (gpte & PT64_BASE_ADDR_MASK) >> PAGE_SHIFT;
 
-	if (is_large_pte(gpte) && is_largepage_backed(vcpu, gfn)) {
-		gfn &= ~(KVM_PAGES_PER_HPAGE-1);
-		vcpu->arch.update_pte.largepage = 1;
+	if (is_large_pte(gpte) &&
+	    backing_size(vcpu, gfn) != KVM_PAGE_SIZE_4k) {
+		gfn &= ~(KVM_PAGES_PER_2M_PAGE-1);
+		vcpu->arch.update_pte.page_size = KVM_PAGE_SIZE_2M;
 	}
 	vcpu->arch.update_pte.mmu_seq = vcpu->kvm->mmu_notifier_seq;
 	smp_rmb();
diff --git a/arch/x86/kvm/paging_tmpl.h b/arch/x86/kvm/paging_tmpl.h
index 855eb71..9fbd049 100644
--- a/arch/x86/kvm/paging_tmpl.h
+++ b/arch/x86/kvm/paging_tmpl.h
@@ -241,7 +241,7 @@ static void FNAME(update_pte)(struct kvm_vcpu *vcpu, struct kvm_mmu_page *page,
 	pt_element_t gpte;
 	unsigned pte_access;
 	pfn_t pfn;
-	int largepage = vcpu->arch.update_pte.largepage;
+	enum kvm_page_size psize = vcpu->arch.update_pte.page_size;
 
 	gpte = *(const pt_element_t *)pte;
 	if (~gpte & (PT_PRESENT_MASK | PT_ACCESSED_MASK)) {
@@ -260,7 +260,7 @@ static void FNAME(update_pte)(struct kvm_vcpu *vcpu, struct kvm_mmu_page *page,
 		return;
 	kvm_get_pfn(pfn);
 	mmu_set_spte(vcpu, spte, page->role.access, pte_access, 0, 0,
-		     gpte & PT_DIRTY_MASK, NULL, largepage,
+		     gpte & PT_DIRTY_MASK, NULL, psize,
 		     gpte & PT_GLOBAL_MASK, gpte_to_gfn(gpte),
 		     pfn, true);
 }
@@ -270,7 +270,8 @@ static void FNAME(update_pte)(struct kvm_vcpu *vcpu, struct kvm_mmu_page *page,
  */
 static u64 *FNAME(fetch)(struct kvm_vcpu *vcpu, gva_t addr,
 			 struct guest_walker *gw,
-			 int user_fault, int write_fault, int largepage,
+			 int user_fault, int write_fault,
+			 enum kvm_page_size psize,
 			 int *ptwrite, pfn_t pfn)
 {
 	unsigned access = gw->pt_access;
@@ -290,12 +291,13 @@ static u64 *FNAME(fetch)(struct kvm_vcpu *vcpu, gva_t addr,
 		level = iterator.level;
 		sptep = iterator.sptep;
 		if (level == PT_PAGE_TABLE_LEVEL
-		    || (largepage && level == PT_DIRECTORY_LEVEL)) {
+		    || (psize == KVM_PAGE_SIZE_2M &&
+			level == PT_DIRECTORY_LEVEL)) {
 			mmu_set_spte(vcpu, sptep, access,
 				     gw->pte_access & access,
 				     user_fault, write_fault,
 				     gw->ptes[gw->level-1] & PT_DIRTY_MASK,
-				     ptwrite, largepage,
+				     ptwrite, psize,
 				     gw->ptes[gw->level-1] & PT_GLOBAL_MASK,
 				     gw->gfn, pfn, false);
 			break;
@@ -368,7 +370,7 @@ static int FNAME(page_fault)(struct kvm_vcpu *vcpu, gva_t addr,
 	int write_pt = 0;
 	int r;
 	pfn_t pfn;
-	int largepage = 0;
+	enum kvm_page_size psize = KVM_PAGE_SIZE_4k;
 	unsigned long mmu_seq;
 
 	pgprintk("%s: addr %lx err %x\n", __func__, addr, error_code);
@@ -396,10 +398,10 @@ static int FNAME(page_fault)(struct kvm_vcpu *vcpu, gva_t addr,
 
 	if (walker.level == PT_DIRECTORY_LEVEL) {
 		gfn_t large_gfn;
-		large_gfn = walker.gfn & ~(KVM_PAGES_PER_HPAGE-1);
-		if (is_largepage_backed(vcpu, large_gfn)) {
+		large_gfn = walker.gfn & ~(KVM_PAGES_PER_2M_PAGE-1);
+		if (backing_size(vcpu, large_gfn) != KVM_PAGE_SIZE_4k) {
 			walker.gfn = large_gfn;
-			largepage = 1;
+			psize = KVM_PAGE_SIZE_2M;
 		}
 	}
 	mmu_seq = vcpu->kvm->mmu_notifier_seq;
@@ -418,7 +420,7 @@ static int FNAME(page_fault)(struct kvm_vcpu *vcpu, gva_t addr,
 		goto out_unlock;
 	kvm_mmu_free_some_pages(vcpu);
 	shadow_pte = FNAME(fetch)(vcpu, addr, &walker, user_fault, write_fault,
-				  largepage, &write_pt, pfn);
+				  psize, &write_pt, pfn);
 
 	pgprintk("%s: shadow pte %p %llx ptwrite %d\n", __func__,
 		 shadow_pte, *shadow_pte, write_pt);
-- 
1.5.6.4


