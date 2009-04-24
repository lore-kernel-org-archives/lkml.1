Return-Path: <linux-kernel-owner+w=401wt.eu-S1757100AbZDXMAF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757100AbZDXMAF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Apr 2009 08:00:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755958AbZDXL7I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Apr 2009 07:59:08 -0400
Received: from va3ehsobe004.messaging.microsoft.com ([216.32.180.14]:44617
	"EHLO VA3EHSOBE004.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754184AbZDXL7E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Apr 2009 07:59:04 -0400
X-BigFish: VPS1(zzzz1202hzzz32i66h)
X-Spam-TCS-SCL: 5:0
X-FB-SS: 5,
X-WSS-ID: 0KILTA5-02-NGY-01
From: Joerg Roedel <joerg.roedel@amd.com>
To: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <marcelo@kvack.or>
CC: <linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>,
       Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 5/7] kvm/mmu: make direct mapping paths aware of mapping levels
Date: Fri, 24 Apr 2009 13:58:45 +0200
Message-ID: <1240574327-21575-6-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.6.2.3
In-Reply-To: <1240574327-21575-1-git-send-email-joerg.roedel@amd.com>
References: <1240574327-21575-1-git-send-email-joerg.roedel@amd.com>
X-OriginalArrivalTime: 24 Apr 2009 11:58:48.0393 (UTC) FILETIME=[06DB8390:01C9C4D4]
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 arch/x86/include/asm/kvm_host.h |    2 +-
 arch/x86/kvm/mmu.c              |   57 ++++++++++++++++++++++-----------------
 arch/x86/kvm/paging_tmpl.h      |    6 ++--
 3 files changed, 36 insertions(+), 29 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index e0ddbdb..5795177 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -311,7 +311,7 @@ struct kvm_vcpu_arch {
 	struct {
 		gfn_t gfn;	/* presumed gfn during guest pte update */
 		pfn_t pfn;	/* pfn corresponding to that gfn */
-		int largepage;
+		int level;
 		unsigned long mmu_seq;
 	} update_pte;
 
diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index 7aeff22..9c50b36 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -1705,7 +1705,7 @@ static int mmu_need_write_protect(struct kvm_vcpu *vcpu, gfn_t gfn,
 
 static int set_spte(struct kvm_vcpu *vcpu, u64 *shadow_pte,
 		    unsigned pte_access, int user_fault,
-		    int write_fault, int dirty, int largepage,
+		    int write_fault, int dirty, int level,
 		    gfn_t gfn, pfn_t pfn, bool speculative,
 		    bool can_unsync)
 {
@@ -1729,7 +1729,7 @@ static int set_spte(struct kvm_vcpu *vcpu, u64 *shadow_pte,
 		spte |= shadow_nx_mask;
 	if (pte_access & ACC_USER_MASK)
 		spte |= shadow_user_mask;
-	if (largepage)
+	if (level > PT_PAGE_TABLE_LEVEL)
 		spte |= PT_PAGE_SIZE_MASK;
 	if (mt_mask) {
 		if (!kvm_is_mmio_pfn(pfn)) {
@@ -1747,7 +1747,8 @@ static int set_spte(struct kvm_vcpu *vcpu, u64 *shadow_pte,
 	if ((pte_access & ACC_WRITE_MASK)
 	    || (write_fault && !is_write_protection(vcpu) && !user_fault)) {
 
-		if (largepage && has_wrprotected_page(vcpu->kvm, gfn, 1)) {
+		if (level > PT_PAGE_TABLE_LEVEL &&
+		    has_wrprotected_page(vcpu->kvm, gfn, level)) {
 			ret = 1;
 			spte = shadow_trap_nonpresent_pte;
 			goto set_pte;
@@ -1785,7 +1786,7 @@ set_pte:
 static void mmu_set_spte(struct kvm_vcpu *vcpu, u64 *shadow_pte,
 			 unsigned pt_access, unsigned pte_access,
 			 int user_fault, int write_fault, int dirty,
-			 int *ptwrite, int largepage, gfn_t gfn,
+			 int *ptwrite, int level, gfn_t gfn,
 			 pfn_t pfn, bool speculative)
 {
 	int was_rmapped = 0;
@@ -1801,7 +1802,8 @@ static void mmu_set_spte(struct kvm_vcpu *vcpu, u64 *shadow_pte,
 		 * If we overwrite a PTE page pointer with a 2MB PMD, unlink
 		 * the parent of the now unreachable PTE.
 		 */
-		if (largepage && !is_large_pte(*shadow_pte)) {
+		if (level > PT_PAGE_TABLE_LEVEL &&
+		    !is_large_pte(*shadow_pte)) {
 			struct kvm_mmu_page *child;
 			u64 pte = *shadow_pte;
 
@@ -1815,7 +1817,7 @@ static void mmu_set_spte(struct kvm_vcpu *vcpu, u64 *shadow_pte,
 			was_rmapped = 1;
 	}
 	if (set_spte(vcpu, shadow_pte, pte_access, user_fault, write_fault,
-		      dirty, largepage, gfn, pfn, speculative, true)) {
+		      dirty, level, gfn, pfn, speculative, true)) {
 		if (write_fault)
 			*ptwrite = 1;
 		kvm_x86_ops->tlb_flush(vcpu);
@@ -1851,7 +1853,7 @@ static void nonpaging_new_cr3(struct kvm_vcpu *vcpu)
 }
 
 static int __direct_map(struct kvm_vcpu *vcpu, gpa_t v, int write,
-			int largepage, gfn_t gfn, pfn_t pfn)
+			int level, gfn_t gfn, pfn_t pfn)
 {
 	struct kvm_shadow_walk_iterator iterator;
 	struct kvm_mmu_page *sp;
@@ -1859,11 +1861,10 @@ static int __direct_map(struct kvm_vcpu *vcpu, gpa_t v, int write,
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
@@ -1891,14 +1892,20 @@ static int __direct_map(struct kvm_vcpu *vcpu, gpa_t v, int write,
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
@@ -1914,7 +1921,7 @@ static int nonpaging_map(struct kvm_vcpu *vcpu, gva_t v, int write, gfn_t gfn)
 	if (mmu_notifier_retry(vcpu, mmu_seq))
 		goto out_unlock;
 	kvm_mmu_free_some_pages(vcpu);
-	r = __direct_map(vcpu, v, write, largepage, gfn, pfn);
+	r = __direct_map(vcpu, v, write, level, gfn, pfn);
 	spin_unlock(&vcpu->kvm->mmu_lock);
 
 
@@ -2071,7 +2078,7 @@ static int tdp_page_fault(struct kvm_vcpu *vcpu, gva_t gpa,
 {
 	pfn_t pfn;
 	int r;
-	int largepage = 0;
+	int level;
 	gfn_t gfn = gpa >> PAGE_SHIFT;
 	unsigned long mmu_seq;
 
@@ -2082,10 +2089,10 @@ static int tdp_page_fault(struct kvm_vcpu *vcpu, gva_t gpa,
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
@@ -2098,7 +2105,7 @@ static int tdp_page_fault(struct kvm_vcpu *vcpu, gva_t gpa,
 		goto out_unlock;
 	kvm_mmu_free_some_pages(vcpu);
 	r = __direct_map(vcpu, gpa, error_code & PFERR_WRITE_MASK,
-			 largepage, gfn, pfn);
+			 level, gfn, pfn);
 	spin_unlock(&vcpu->kvm->mmu_lock);
 
 	return r;
@@ -2404,7 +2411,7 @@ static void mmu_pte_write_new_pte(struct kvm_vcpu *vcpu,
 				  const void *new)
 {
 	if (sp->role.level != PT_PAGE_TABLE_LEVEL) {
-		if (!vcpu->arch.update_pte.largepage ||
+		if (vcpu->arch.update_pte.level == PT_PAGE_TABLE_LEVEL ||
 		    sp->role.glevels == PT32_ROOT_LEVEL) {
 			++vcpu->kvm->stat.mmu_pde_zapped;
 			return;
@@ -2454,7 +2461,7 @@ static void mmu_guess_page_from_pte_write(struct kvm_vcpu *vcpu, gpa_t gpa,
 	u64 gpte = 0;
 	pfn_t pfn;
 
-	vcpu->arch.update_pte.largepage = 0;
+	vcpu->arch.update_pte.level = PT_PAGE_TABLE_LEVEL;
 
 	if (bytes != 4 && bytes != 8)
 		return;
@@ -2486,7 +2493,7 @@ static void mmu_guess_page_from_pte_write(struct kvm_vcpu *vcpu, gpa_t gpa,
 	if (is_large_pte(gpte) &&
 	    (mapping_level(vcpu, gfn) == PT_DIRECTORY_LEVEL)) {
 		gfn &= ~(KVM_PAGES_PER_HPAGE(PT_DIRECTORY_LEVEL) - 1);
-		vcpu->arch.update_pte.largepage = 1;
+		vcpu->arch.update_pte.level = PT_DIRECTORY_LEVEL;
 	}
 	vcpu->arch.update_pte.mmu_seq = vcpu->kvm->mmu_notifier_seq;
 	smp_rmb();
diff --git a/arch/x86/kvm/paging_tmpl.h b/arch/x86/kvm/paging_tmpl.h
index 6a0cc46..08ac5cd 100644
--- a/arch/x86/kvm/paging_tmpl.h
+++ b/arch/x86/kvm/paging_tmpl.h
@@ -248,7 +248,7 @@ static void FNAME(update_pte)(struct kvm_vcpu *vcpu, struct kvm_mmu_page *page,
 	pt_element_t gpte;
 	unsigned pte_access;
 	pfn_t pfn;
-	int largepage = vcpu->arch.update_pte.largepage;
+	int level = vcpu->arch.update_pte.level;
 
 	gpte = *(const pt_element_t *)pte;
 	if (~gpte & (PT_PRESENT_MASK | PT_ACCESSED_MASK)) {
@@ -267,7 +267,7 @@ static void FNAME(update_pte)(struct kvm_vcpu *vcpu, struct kvm_mmu_page *page,
 		return;
 	kvm_get_pfn(pfn);
 	mmu_set_spte(vcpu, spte, page->role.access, pte_access, 0, 0,
-		     gpte & PT_DIRTY_MASK, NULL, largepage,
+		     gpte & PT_DIRTY_MASK, NULL, level,
 		     gpte_to_gfn(gpte), pfn, true);
 }
 
@@ -301,7 +301,7 @@ static u64 *FNAME(fetch)(struct kvm_vcpu *vcpu, gva_t addr,
 				     gw->pte_access & access,
 				     user_fault, write_fault,
 				     gw->ptes[gw->level-1] & PT_DIRTY_MASK,
-				     ptwrite, largepage,
+				     ptwrite, level,
 				     gw->gfn, pfn, false);
 			break;
 		}
-- 
1.6.2.3


