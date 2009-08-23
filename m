Return-Path: <linux-kernel-owner+w=401wt.eu-S933634AbZHWL53@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933634AbZHWL53 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Aug 2009 07:57:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933619AbZHWL5T
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Aug 2009 07:57:19 -0400
Received: from mx1.redhat.com ([209.132.183.28]:45236 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933562AbZHWL4v (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Aug 2009 07:56:51 -0400
From: Avi Kivity <avi@redhat.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 42/46] KVM: MMU: make direct mapping paths aware of mapping levels
Date: Sun, 23 Aug 2009 14:56:41 +0300
Message-Id: <1251028605-31977-43-git-send-email-avi@redhat.com>
In-Reply-To: <1251028605-31977-1-git-send-email-avi@redhat.com>
References: <1251028605-31977-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Joerg Roedel <joerg.roedel@amd.com>

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
Signed-off-by: Avi Kivity <avi@redhat.com>
---
 arch/x86/include/asm/kvm_host.h |    2 +-
 arch/x86/kvm/mmu.c              |   83 +++++++++++++++++++++++----------------
 arch/x86/kvm/paging_tmpl.h      |    6 +-
 3 files changed, 53 insertions(+), 38 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index e210b21..e09dc26 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -315,7 +315,7 @@ struct kvm_vcpu_arch {
 	struct {
 		gfn_t gfn;	/* presumed gfn during guest pte update */
 		pfn_t pfn;	/* pfn corresponding to that gfn */
-		int largepage;
+		int level;
 		unsigned long mmu_seq;
 	} update_pte;
 
diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index c707936..110c224 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -257,7 +257,7 @@ static int is_last_spte(u64 pte, int level)
 {
 	if (level == PT_PAGE_TABLE_LEVEL)
 		return 1;
-	if (level == PT_DIRECTORY_LEVEL && is_large_pte(pte))
+	if (is_large_pte(pte))
 		return 1;
 	return 0;
 }
@@ -753,7 +753,7 @@ static int kvm_unmap_rmapp(struct kvm *kvm, unsigned long *rmapp)
 static int kvm_handle_hva(struct kvm *kvm, unsigned long hva,
 			  int (*handler)(struct kvm *kvm, unsigned long *rmapp))
 {
-	int i;
+	int i, j;
 	int retval = 0;
 
 	/*
@@ -772,11 +772,15 @@ static int kvm_handle_hva(struct kvm *kvm, unsigned long hva,
 		end = start + (memslot->npages << PAGE_SHIFT);
 		if (hva >= start && hva < end) {
 			gfn_t gfn_offset = (hva - start) >> PAGE_SHIFT;
-			int idx = gfn_offset /
-			          KVM_PAGES_PER_HPAGE(PT_DIRECTORY_LEVEL);
+
 			retval |= handler(kvm, &memslot->rmap[gfn_offset]);
-			retval |= handler(kvm,
-					&memslot->lpage_info[0][idx].rmap_pde);
+
+			for (j = 0; j < KVM_NR_PAGE_SIZES - 1; ++j) {
+				int idx = gfn_offset;
+				idx /= KVM_PAGES_PER_HPAGE(PT_DIRECTORY_LEVEL + j);
+				retval |= handler(kvm,
+					&memslot->lpage_info[j][idx].rmap_pde);
+			}
 		}
 	}
 
@@ -814,12 +818,15 @@ static int kvm_age_rmapp(struct kvm *kvm, unsigned long *rmapp)
 
 #define RMAP_RECYCLE_THRESHOLD 1000
 
-static void rmap_recycle(struct kvm_vcpu *vcpu, gfn_t gfn, int lpage)
+static void rmap_recycle(struct kvm_vcpu *vcpu, u64 *spte, gfn_t gfn)
 {
 	unsigned long *rmapp;
+	struct kvm_mmu_page *sp;
+
+	sp = page_header(__pa(spte));
 
 	gfn = unalias_gfn(vcpu->kvm, gfn);
-	rmapp = gfn_to_rmap(vcpu->kvm, gfn, lpage);
+	rmapp = gfn_to_rmap(vcpu->kvm, gfn, sp->role.level);
 
 	kvm_unmap_rmapp(vcpu->kvm, rmapp);
 	kvm_flush_remote_tlbs(vcpu->kvm);
@@ -1734,7 +1741,7 @@ static int mmu_need_write_protect(struct kvm_vcpu *vcpu, gfn_t gfn,
 
 static int set_spte(struct kvm_vcpu *vcpu, u64 *sptep,
 		    unsigned pte_access, int user_fault,
-		    int write_fault, int dirty, int largepage,
+		    int write_fault, int dirty, int level,
 		    gfn_t gfn, pfn_t pfn, bool speculative,
 		    bool can_unsync)
 {
@@ -1757,7 +1764,7 @@ static int set_spte(struct kvm_vcpu *vcpu, u64 *sptep,
 		spte |= shadow_nx_mask;
 	if (pte_access & ACC_USER_MASK)
 		spte |= shadow_user_mask;
-	if (largepage)
+	if (level > PT_PAGE_TABLE_LEVEL)
 		spte |= PT_PAGE_SIZE_MASK;
 	if (tdp_enabled)
 		spte |= kvm_x86_ops->get_mt_mask(vcpu, gfn,
@@ -1768,7 +1775,8 @@ static int set_spte(struct kvm_vcpu *vcpu, u64 *sptep,
 	if ((pte_access & ACC_WRITE_MASK)
 	    || (write_fault && !is_write_protection(vcpu) && !user_fault)) {
 
-		if (largepage && has_wrprotected_page(vcpu->kvm, gfn, 1)) {
+		if (level > PT_PAGE_TABLE_LEVEL &&
+		    has_wrprotected_page(vcpu->kvm, gfn, level)) {
 			ret = 1;
 			spte = shadow_trap_nonpresent_pte;
 			goto set_pte;
@@ -1806,7 +1814,7 @@ set_pte:
 static void mmu_set_spte(struct kvm_vcpu *vcpu, u64 *sptep,
 			 unsigned pt_access, unsigned pte_access,
 			 int user_fault, int write_fault, int dirty,
-			 int *ptwrite, int largepage, gfn_t gfn,
+			 int *ptwrite, int level, gfn_t gfn,
 			 pfn_t pfn, bool speculative)
 {
 	int was_rmapped = 0;
@@ -1823,7 +1831,8 @@ static void mmu_set_spte(struct kvm_vcpu *vcpu, u64 *sptep,
 		 * If we overwrite a PTE page pointer with a 2MB PMD, unlink
 		 * the parent of the now unreachable PTE.
 		 */
-		if (largepage && !is_large_pte(*sptep)) {
+		if (level > PT_PAGE_TABLE_LEVEL &&
+		    !is_large_pte(*sptep)) {
 			struct kvm_mmu_page *child;
 			u64 pte = *sptep;
 
@@ -1836,8 +1845,9 @@ static void mmu_set_spte(struct kvm_vcpu *vcpu, u64 *sptep,
 		} else
 			was_rmapped = 1;
 	}
+
 	if (set_spte(vcpu, sptep, pte_access, user_fault, write_fault,
-		      dirty, largepage, gfn, pfn, speculative, true)) {
+		      dirty, level, gfn, pfn, speculative, true)) {
 		if (write_fault)
 			*ptwrite = 1;
 		kvm_x86_ops->tlb_flush(vcpu);
@@ -1857,7 +1867,7 @@ static void mmu_set_spte(struct kvm_vcpu *vcpu, u64 *sptep,
 		if (!is_rmap_spte(*sptep))
 			kvm_release_pfn_clean(pfn);
 		if (rmap_count > RMAP_RECYCLE_THRESHOLD)
-			rmap_recycle(vcpu, gfn, largepage);
+			rmap_recycle(vcpu, sptep, gfn);
 	} else {
 		if (was_writeble)
 			kvm_release_pfn_dirty(pfn);
@@ -1875,7 +1885,7 @@ static void nonpaging_new_cr3(struct kvm_vcpu *vcpu)
 }
 
 static int __direct_map(struct kvm_vcpu *vcpu, gpa_t v, int write,
-			int largepage, gfn_t gfn, pfn_t pfn)
+			int level, gfn_t gfn, pfn_t pfn)
 {
 	struct kvm_shadow_walk_iterator iterator;
 	struct kvm_mmu_page *sp;
@@ -1883,11 +1893,10 @@ static int __direct_map(struct kvm_vcpu *vcpu, gpa_t v, int write,
 	gfn_t pseudo_gfn;
 
 	for_each_shadow_entry(vcpu, (u64)gfn << PAGE_SHIFT, iterator) {
-		if (iterator.level == PT_PAGE_TABLE_LEVEL
-		    || (largepage && iterator.level == PT_DIRECTORY_LEVEL)) {
+		if (iterator.level == level) {
 			mmu_set_spte(vcpu, iterator.sptep, ACC_ALL, ACC_ALL,
 				     0, write, 1, &pt_write,
-				     largepage, gfn, pfn, false);
+				     level, gfn, pfn, false);
 			++vcpu->stat.pf_fixed;
 			break;
 		}
@@ -1915,14 +1924,20 @@ static int __direct_map(struct kvm_vcpu *vcpu, gpa_t v, int write,
 static int nonpaging_map(struct kvm_vcpu *vcpu, gva_t v, int write, gfn_t gfn)
 {
 	int r;
-	int largepage = 0;
+	int level;
 	pfn_t pfn;
 	unsigned long mmu_seq;
 
-	if (mapping_level(vcpu, gfn) == PT_DIRECTORY_LEVEL) {
-		gfn &= ~(KVM_PAGES_PER_HPAGE(PT_DIRECTORY_LEVEL) - 1);
-		largepage = 1;
-	}
+	level = mapping_level(vcpu, gfn);
+
+	/*
+	 * This path builds a PAE pagetable - so we can map 2mb pages at
+	 * maximum. Therefore check if the level is larger than that.
+	 */
+	if (level > PT_DIRECTORY_LEVEL)
+		level = PT_DIRECTORY_LEVEL;
+
+	gfn &= ~(KVM_PAGES_PER_HPAGE(level) - 1);
 
 	mmu_seq = vcpu->kvm->mmu_notifier_seq;
 	smp_rmb();
@@ -1938,7 +1953,7 @@ static int nonpaging_map(struct kvm_vcpu *vcpu, gva_t v, int write, gfn_t gfn)
 	if (mmu_notifier_retry(vcpu, mmu_seq))
 		goto out_unlock;
 	kvm_mmu_free_some_pages(vcpu);
-	r = __direct_map(vcpu, v, write, largepage, gfn, pfn);
+	r = __direct_map(vcpu, v, write, level, gfn, pfn);
 	spin_unlock(&vcpu->kvm->mmu_lock);
 
 
@@ -2114,7 +2129,7 @@ static int tdp_page_fault(struct kvm_vcpu *vcpu, gva_t gpa,
 {
 	pfn_t pfn;
 	int r;
-	int largepage = 0;
+	int level;
 	gfn_t gfn = gpa >> PAGE_SHIFT;
 	unsigned long mmu_seq;
 
@@ -2125,10 +2140,10 @@ static int tdp_page_fault(struct kvm_vcpu *vcpu, gva_t gpa,
 	if (r)
 		return r;
 
-	if (mapping_level(vcpu, gfn) == PT_DIRECTORY_LEVEL) {
-		gfn &= ~(KVM_PAGES_PER_HPAGE(PT_DIRECTORY_LEVEL) - 1);
-		largepage = 1;
-	}
+	level = mapping_level(vcpu, gfn);
+
+	gfn &= ~(KVM_PAGES_PER_HPAGE(level) - 1);
+
 	mmu_seq = vcpu->kvm->mmu_notifier_seq;
 	smp_rmb();
 	pfn = gfn_to_pfn(vcpu->kvm, gfn);
@@ -2141,7 +2156,7 @@ static int tdp_page_fault(struct kvm_vcpu *vcpu, gva_t gpa,
 		goto out_unlock;
 	kvm_mmu_free_some_pages(vcpu);
 	r = __direct_map(vcpu, gpa, error_code & PFERR_WRITE_MASK,
-			 largepage, gfn, pfn);
+			 level, gfn, pfn);
 	spin_unlock(&vcpu->kvm->mmu_lock);
 
 	return r;
@@ -2448,7 +2463,7 @@ static void mmu_pte_write_new_pte(struct kvm_vcpu *vcpu,
 				  const void *new)
 {
 	if (sp->role.level != PT_PAGE_TABLE_LEVEL) {
-		if (!vcpu->arch.update_pte.largepage ||
+		if (vcpu->arch.update_pte.level == PT_PAGE_TABLE_LEVEL ||
 		    sp->role.glevels == PT32_ROOT_LEVEL) {
 			++vcpu->kvm->stat.mmu_pde_zapped;
 			return;
@@ -2498,7 +2513,7 @@ static void mmu_guess_page_from_pte_write(struct kvm_vcpu *vcpu, gpa_t gpa,
 	u64 gpte = 0;
 	pfn_t pfn;
 
-	vcpu->arch.update_pte.largepage = 0;
+	vcpu->arch.update_pte.level = PT_PAGE_TABLE_LEVEL;
 
 	if (bytes != 4 && bytes != 8)
 		return;
@@ -2530,7 +2545,7 @@ static void mmu_guess_page_from_pte_write(struct kvm_vcpu *vcpu, gpa_t gpa,
 	if (is_large_pte(gpte) &&
 	    (mapping_level(vcpu, gfn) == PT_DIRECTORY_LEVEL)) {
 		gfn &= ~(KVM_PAGES_PER_HPAGE(PT_DIRECTORY_LEVEL) - 1);
-		vcpu->arch.update_pte.largepage = 1;
+		vcpu->arch.update_pte.level = PT_DIRECTORY_LEVEL;
 	}
 	vcpu->arch.update_pte.mmu_seq = vcpu->kvm->mmu_notifier_seq;
 	smp_rmb();
diff --git a/arch/x86/kvm/paging_tmpl.h b/arch/x86/kvm/paging_tmpl.h
index 44f0346..b167f0d 100644
--- a/arch/x86/kvm/paging_tmpl.h
+++ b/arch/x86/kvm/paging_tmpl.h
@@ -253,7 +253,7 @@ static void FNAME(update_pte)(struct kvm_vcpu *vcpu, struct kvm_mmu_page *page,
 	pt_element_t gpte;
 	unsigned pte_access;
 	pfn_t pfn;
-	int largepage = vcpu->arch.update_pte.largepage;
+	int level = vcpu->arch.update_pte.level;
 
 	gpte = *(const pt_element_t *)pte;
 	if (~gpte & (PT_PRESENT_MASK | PT_ACCESSED_MASK)) {
@@ -272,7 +272,7 @@ static void FNAME(update_pte)(struct kvm_vcpu *vcpu, struct kvm_mmu_page *page,
 		return;
 	kvm_get_pfn(pfn);
 	mmu_set_spte(vcpu, spte, page->role.access, pte_access, 0, 0,
-		     gpte & PT_DIRTY_MASK, NULL, largepage,
+		     gpte & PT_DIRTY_MASK, NULL, level,
 		     gpte_to_gfn(gpte), pfn, true);
 }
 
@@ -306,7 +306,7 @@ static u64 *FNAME(fetch)(struct kvm_vcpu *vcpu, gva_t addr,
 				     gw->pte_access & access,
 				     user_fault, write_fault,
 				     gw->ptes[gw->level-1] & PT_DIRTY_MASK,
-				     ptwrite, largepage,
+				     ptwrite, level,
 				     gw->gfn, pfn, false);
 			break;
 		}
-- 
1.6.4.1

