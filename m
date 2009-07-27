Return-Path: <linux-kernel-owner+w=401wt.eu-S1751961AbZG0ObN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751961AbZG0ObN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jul 2009 10:31:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751887AbZG0ObN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Jul 2009 10:31:13 -0400
Received: from va3ehsobe004.messaging.microsoft.com ([216.32.180.14]:51050
	"EHLO VA3EHSOBE004.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751356AbZG0ObJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jul 2009 10:31:09 -0400
X-SpamScore: 3
X-BigFish: VPS3(zzzz1202hzzz32i43j66h)
X-Spam-TCS-SCL: 5:0
X-FB-SS: 5,
X-WSS-ID: 0KNG2ZE-04-HYC-01
From: Joerg Roedel <joerg.roedel@amd.com>
To: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <marcelo@kvack.org>
CC: linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
       Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 3/7] kvm/mmu: make direct mapping paths aware of mapping levels
Date: Mon, 27 Jul 2009 16:30:44 +0200
Message-ID: <1248705048-22607-4-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1248705048-22607-1-git-send-email-joerg.roedel@amd.com>
References: <1248705048-22607-1-git-send-email-joerg.roedel@amd.com>
X-OriginalArrivalTime: 27 Jul 2009 14:30:50.0786 (UTC) FILETIME=[D70EB820:01CA0EC6]
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 arch/x86/include/asm/kvm_host.h |    2 +-
 arch/x86/kvm/mmu.c              |   74 ++++++++++++++++++++++----------------
 arch/x86/kvm/paging_tmpl.h      |    6 ++--
 3 files changed, 47 insertions(+), 35 deletions(-)

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
index 7a03216..ffea432 100644
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
@@ -746,7 +746,7 @@ static int kvm_unmap_rmapp(struct kvm *kvm, unsigned long *rmapp)
 static int kvm_handle_hva(struct kvm *kvm, unsigned long hva,
 			  int (*handler)(struct kvm *kvm, unsigned long *rmapp))
 {
-	int i;
+	int i, j;
 	int retval = 0;
 
 	/*
@@ -765,11 +765,15 @@ static int kvm_handle_hva(struct kvm *kvm, unsigned long hva,
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
 
@@ -1714,7 +1718,7 @@ static int mmu_need_write_protect(struct kvm_vcpu *vcpu, gfn_t gfn,
 
 static int set_spte(struct kvm_vcpu *vcpu, u64 *sptep,
 		    unsigned pte_access, int user_fault,
-		    int write_fault, int dirty, int largepage,
+		    int write_fault, int dirty, int level,
 		    gfn_t gfn, pfn_t pfn, bool speculative,
 		    bool can_unsync)
 {
@@ -1737,7 +1741,7 @@ static int set_spte(struct kvm_vcpu *vcpu, u64 *sptep,
 		spte |= shadow_nx_mask;
 	if (pte_access & ACC_USER_MASK)
 		spte |= shadow_user_mask;
-	if (largepage)
+	if (level > PT_PAGE_TABLE_LEVEL)
 		spte |= PT_PAGE_SIZE_MASK;
 	if (tdp_enabled)
 		spte |= kvm_x86_ops->get_mt_mask(vcpu, gfn,
@@ -1748,7 +1752,8 @@ static int set_spte(struct kvm_vcpu *vcpu, u64 *sptep,
 	if ((pte_access & ACC_WRITE_MASK)
 	    || (write_fault && !is_write_protection(vcpu) && !user_fault)) {
 
-		if (largepage && has_wrprotected_page(vcpu->kvm, gfn, 1)) {
+		if (level > PT_PAGE_TABLE_LEVEL &&
+		    has_wrprotected_page(vcpu->kvm, gfn, level)) {
 			ret = 1;
 			spte = shadow_trap_nonpresent_pte;
 			goto set_pte;
@@ -1786,7 +1791,7 @@ set_pte:
 static void mmu_set_spte(struct kvm_vcpu *vcpu, u64 *sptep,
 			 unsigned pt_access, unsigned pte_access,
 			 int user_fault, int write_fault, int dirty,
-			 int *ptwrite, int largepage, gfn_t gfn,
+			 int *ptwrite, int level, gfn_t gfn,
 			 pfn_t pfn, bool speculative)
 {
 	int was_rmapped = 0;
@@ -1802,7 +1807,8 @@ static void mmu_set_spte(struct kvm_vcpu *vcpu, u64 *sptep,
 		 * If we overwrite a PTE page pointer with a 2MB PMD, unlink
 		 * the parent of the now unreachable PTE.
 		 */
-		if (largepage && !is_large_pte(*sptep)) {
+		if (level > PT_PAGE_TABLE_LEVEL &&
+		    !is_large_pte(*sptep)) {
 			struct kvm_mmu_page *child;
 			u64 pte = *sptep;
 
@@ -1815,8 +1821,9 @@ static void mmu_set_spte(struct kvm_vcpu *vcpu, u64 *sptep,
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
@@ -1852,7 +1859,7 @@ static void nonpaging_new_cr3(struct kvm_vcpu *vcpu)
 }
 
 static int __direct_map(struct kvm_vcpu *vcpu, gpa_t v, int write,
-			int largepage, gfn_t gfn, pfn_t pfn)
+			int level, gfn_t gfn, pfn_t pfn)
 {
 	struct kvm_shadow_walk_iterator iterator;
 	struct kvm_mmu_page *sp;
@@ -1860,11 +1867,10 @@ static int __direct_map(struct kvm_vcpu *vcpu, gpa_t v, int write,
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
@@ -1892,14 +1898,20 @@ static int __direct_map(struct kvm_vcpu *vcpu, gpa_t v, int write,
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
@@ -1915,7 +1927,7 @@ static int nonpaging_map(struct kvm_vcpu *vcpu, gva_t v, int write, gfn_t gfn)
 	if (mmu_notifier_retry(vcpu, mmu_seq))
 		goto out_unlock;
 	kvm_mmu_free_some_pages(vcpu);
-	r = __direct_map(vcpu, v, write, largepage, gfn, pfn);
+	r = __direct_map(vcpu, v, write, level, gfn, pfn);
 	spin_unlock(&vcpu->kvm->mmu_lock);
 
 
@@ -2091,7 +2103,7 @@ static int tdp_page_fault(struct kvm_vcpu *vcpu, gva_t gpa,
 {
 	pfn_t pfn;
 	int r;
-	int largepage = 0;
+	int level;
 	gfn_t gfn = gpa >> PAGE_SHIFT;
 	unsigned long mmu_seq;
 
@@ -2102,10 +2114,10 @@ static int tdp_page_fault(struct kvm_vcpu *vcpu, gva_t gpa,
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
@@ -2118,7 +2130,7 @@ static int tdp_page_fault(struct kvm_vcpu *vcpu, gva_t gpa,
 		goto out_unlock;
 	kvm_mmu_free_some_pages(vcpu);
 	r = __direct_map(vcpu, gpa, error_code & PFERR_WRITE_MASK,
-			 largepage, gfn, pfn);
+			 level, gfn, pfn);
 	spin_unlock(&vcpu->kvm->mmu_lock);
 
 	return r;
@@ -2425,7 +2437,7 @@ static void mmu_pte_write_new_pte(struct kvm_vcpu *vcpu,
 				  const void *new)
 {
 	if (sp->role.level != PT_PAGE_TABLE_LEVEL) {
-		if (!vcpu->arch.update_pte.largepage ||
+		if (vcpu->arch.update_pte.level == PT_PAGE_TABLE_LEVEL ||
 		    sp->role.glevels == PT32_ROOT_LEVEL) {
 			++vcpu->kvm->stat.mmu_pde_zapped;
 			return;
@@ -2475,7 +2487,7 @@ static void mmu_guess_page_from_pte_write(struct kvm_vcpu *vcpu, gpa_t gpa,
 	u64 gpte = 0;
 	pfn_t pfn;
 
-	vcpu->arch.update_pte.largepage = 0;
+	vcpu->arch.update_pte.level = PT_PAGE_TABLE_LEVEL;
 
 	if (bytes != 4 && bytes != 8)
 		return;
@@ -2507,7 +2519,7 @@ static void mmu_guess_page_from_pte_write(struct kvm_vcpu *vcpu, gpa_t gpa,
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
1.6.3.3


