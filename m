Return-Path: <linux-kernel-owner+w=401wt.eu-S1754244AbZHPJab@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754244AbZHPJab (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Aug 2009 05:30:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754169AbZHPJa2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Aug 2009 05:30:28 -0400
Received: from mx2.redhat.com ([66.187.237.31]:45377 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754111AbZHPJaP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Aug 2009 05:30:15 -0400
From: Avi Kivity <avi@redhat.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 43/48] KVM: MMU: Adjust pte accessors to explicitly indicate guest or shadow pte
Date: Sun, 16 Aug 2009 12:30:03 +0300
Message-Id: <1250415008-17175-44-git-send-email-avi@redhat.com>
In-Reply-To: <1250415008-17175-1-git-send-email-avi@redhat.com>
References: <1250415008-17175-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since the guest and host ptes can have wildly different format, adjust
the pte accessor names to indicate on which type of pte they operate on.

No functional changes.

Signed-off-by: Avi Kivity <avi@redhat.com>
---
 arch/x86/kvm/mmu.c         |   16 ++++++++--------
 arch/x86/kvm/mmu.h         |    2 +-
 arch/x86/kvm/paging_tmpl.h |   22 +++++++++++-----------
 arch/x86/kvm/x86.c         |    2 +-
 4 files changed, 21 insertions(+), 21 deletions(-)

diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index 8f2cb29..a039e6b 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -240,12 +240,12 @@ static int is_writeble_pte(unsigned long pte)
 	return pte & PT_WRITABLE_MASK;
 }
 
-static int is_dirty_pte(unsigned long pte)
+static int is_dirty_gpte(unsigned long pte)
 {
 	return pte & PT_DIRTY_MASK;
 }
 
-static int is_rmap_pte(u64 pte)
+static int is_rmap_spte(u64 pte)
 {
 	return is_shadow_present_pte(pte);
 }
@@ -502,7 +502,7 @@ static int rmap_add(struct kvm_vcpu *vcpu, u64 *spte, gfn_t gfn, int lpage)
 	unsigned long *rmapp;
 	int i, count = 0;
 
-	if (!is_rmap_pte(*spte))
+	if (!is_rmap_spte(*spte))
 		return count;
 	gfn = unalias_gfn(vcpu->kvm, gfn);
 	sp = page_header(__pa(spte));
@@ -567,7 +567,7 @@ static void rmap_remove(struct kvm *kvm, u64 *spte)
 	unsigned long *rmapp;
 	int i;
 
-	if (!is_rmap_pte(*spte))
+	if (!is_rmap_spte(*spte))
 		return;
 	sp = page_header(__pa(spte));
 	pfn = spte_to_pfn(*spte);
@@ -1769,7 +1769,7 @@ static void mmu_set_spte(struct kvm_vcpu *vcpu, u64 *shadow_pte,
 		 __func__, *shadow_pte, pt_access,
 		 write_fault, user_fault, gfn);
 
-	if (is_rmap_pte(*shadow_pte)) {
+	if (is_rmap_spte(*shadow_pte)) {
 		/*
 		 * If we overwrite a PTE page pointer with a 2MB PMD, unlink
 		 * the parent of the now unreachable PTE.
@@ -1805,7 +1805,7 @@ static void mmu_set_spte(struct kvm_vcpu *vcpu, u64 *shadow_pte,
 	page_header_update_slot(vcpu->kvm, shadow_pte, gfn);
 	if (!was_rmapped) {
 		rmap_count = rmap_add(vcpu, shadow_pte, gfn, largepage);
-		if (!is_rmap_pte(*shadow_pte))
+		if (!is_rmap_spte(*shadow_pte))
 			kvm_release_pfn_clean(pfn);
 		if (rmap_count > RMAP_RECYCLE_THRESHOLD)
 			rmap_recycle(vcpu, gfn, largepage);
@@ -1984,7 +1984,7 @@ static int mmu_alloc_roots(struct kvm_vcpu *vcpu)
 		ASSERT(!VALID_PAGE(root));
 		if (vcpu->arch.mmu.root_level == PT32E_ROOT_LEVEL) {
 			pdptr = kvm_pdptr_read(vcpu, i);
-			if (!is_present_pte(pdptr)) {
+			if (!is_present_gpte(pdptr)) {
 				vcpu->arch.mmu.pae_root[i] = 0;
 				continue;
 			}
@@ -2475,7 +2475,7 @@ static void mmu_guess_page_from_pte_write(struct kvm_vcpu *vcpu, gpa_t gpa,
 		if ((bytes == 4) && (gpa % 4 == 0))
 			memcpy((void *)&gpte, new, 4);
 	}
-	if (!is_present_pte(gpte))
+	if (!is_present_gpte(gpte))
 		return;
 	gfn = (gpte & PT64_BASE_ADDR_MASK) >> PAGE_SHIFT;
 
diff --git a/arch/x86/kvm/mmu.h b/arch/x86/kvm/mmu.h
index 3494a2f..016bf71 100644
--- a/arch/x86/kvm/mmu.h
+++ b/arch/x86/kvm/mmu.h
@@ -75,7 +75,7 @@ static inline int is_paging(struct kvm_vcpu *vcpu)
 	return vcpu->arch.cr0 & X86_CR0_PG;
 }
 
-static inline int is_present_pte(unsigned long pte)
+static inline int is_present_gpte(unsigned long pte)
 {
 	return pte & PT_PRESENT_MASK;
 }
diff --git a/arch/x86/kvm/paging_tmpl.h b/arch/x86/kvm/paging_tmpl.h
index 4cb1dbf..238a193 100644
--- a/arch/x86/kvm/paging_tmpl.h
+++ b/arch/x86/kvm/paging_tmpl.h
@@ -132,7 +132,7 @@ walk:
 #if PTTYPE == 64
 	if (!is_long_mode(vcpu)) {
 		pte = kvm_pdptr_read(vcpu, (addr >> 30) & 3);
-		if (!is_present_pte(pte))
+		if (!is_present_gpte(pte))
 			goto not_present;
 		--walker->level;
 	}
@@ -155,7 +155,7 @@ walk:
 
 		kvm_read_guest(vcpu->kvm, pte_gpa, &pte, sizeof(pte));
 
-		if (!is_present_pte(pte))
+		if (!is_present_gpte(pte))
 			goto not_present;
 
 		rsvd_fault = is_rsvd_bits_set(vcpu, pte, walker->level);
@@ -205,7 +205,7 @@ walk:
 		--walker->level;
 	}
 
-	if (write_fault && !is_dirty_pte(pte)) {
+	if (write_fault && !is_dirty_gpte(pte)) {
 		bool ret;
 
 		mark_page_dirty(vcpu->kvm, table_gfn);
@@ -252,7 +252,7 @@ static void FNAME(update_pte)(struct kvm_vcpu *vcpu, struct kvm_mmu_page *page,
 
 	gpte = *(const pt_element_t *)pte;
 	if (~gpte & (PT_PRESENT_MASK | PT_ACCESSED_MASK)) {
-		if (!is_present_pte(gpte))
+		if (!is_present_gpte(gpte))
 			set_shadow_pte(spte, shadow_notrap_nonpresent_pte);
 		return;
 	}
@@ -289,7 +289,7 @@ static u64 *FNAME(fetch)(struct kvm_vcpu *vcpu, gva_t addr,
 	pt_element_t curr_pte;
 	struct kvm_shadow_walk_iterator iterator;
 
-	if (!is_present_pte(gw->ptes[gw->level - 1]))
+	if (!is_present_gpte(gw->ptes[gw->level - 1]))
 		return NULL;
 
 	for_each_shadow_entry(vcpu, addr, iterator) {
@@ -318,7 +318,7 @@ static u64 *FNAME(fetch)(struct kvm_vcpu *vcpu, gva_t addr,
 		if (level == PT_DIRECTORY_LEVEL
 		    && gw->level == PT_DIRECTORY_LEVEL) {
 			direct = 1;
-			if (!is_dirty_pte(gw->ptes[level - 1]))
+			if (!is_dirty_gpte(gw->ptes[level - 1]))
 				access &= ~ACC_WRITE_MASK;
 			table_gfn = gpte_to_gfn(gw->ptes[level - 1]);
 		} else {
@@ -489,7 +489,7 @@ static void FNAME(invlpg)(struct kvm_vcpu *vcpu, gva_t gva)
 	if (kvm_read_guest_atomic(vcpu->kvm, pte_gpa, &gpte,
 				  sizeof(pt_element_t)))
 		return;
-	if (is_present_pte(gpte) && (gpte & PT_ACCESSED_MASK)) {
+	if (is_present_gpte(gpte) && (gpte & PT_ACCESSED_MASK)) {
 		if (mmu_topup_memory_caches(vcpu))
 			return;
 		kvm_mmu_pte_write(vcpu, pte_gpa, (const u8 *)&gpte,
@@ -536,7 +536,7 @@ static void FNAME(prefetch_page)(struct kvm_vcpu *vcpu,
 		r = kvm_read_guest_atomic(vcpu->kvm, pte_gpa, pt, sizeof pt);
 		pte_gpa += ARRAY_SIZE(pt) * sizeof(pt_element_t);
 		for (j = 0; j < ARRAY_SIZE(pt); ++j)
-			if (r || is_present_pte(pt[j]))
+			if (r || is_present_gpte(pt[j]))
 				sp->spt[i+j] = shadow_trap_nonpresent_pte;
 			else
 				sp->spt[i+j] = shadow_notrap_nonpresent_pte;
@@ -574,12 +574,12 @@ static int FNAME(sync_page)(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp)
 					  sizeof(pt_element_t)))
 			return -EINVAL;
 
-		if (gpte_to_gfn(gpte) != gfn || !is_present_pte(gpte) ||
+		if (gpte_to_gfn(gpte) != gfn || !is_present_gpte(gpte) ||
 		    !(gpte & PT_ACCESSED_MASK)) {
 			u64 nonpresent;
 
 			rmap_remove(vcpu->kvm, &sp->spt[i]);
-			if (is_present_pte(gpte))
+			if (is_present_gpte(gpte))
 				nonpresent = shadow_trap_nonpresent_pte;
 			else
 				nonpresent = shadow_notrap_nonpresent_pte;
@@ -590,7 +590,7 @@ static int FNAME(sync_page)(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp)
 		nr_present++;
 		pte_access = sp->role.access & FNAME(gpte_access)(vcpu, gpte);
 		set_spte(vcpu, &sp->spt[i], pte_access, 0, 0,
-			 is_dirty_pte(gpte), 0, gfn,
+			 is_dirty_gpte(gpte), 0, gfn,
 			 spte_to_pfn(sp->spt[i]), true, false);
 	}
 
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 05cbe83..e877efa 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -237,7 +237,7 @@ int load_pdptrs(struct kvm_vcpu *vcpu, unsigned long cr3)
 		goto out;
 	}
 	for (i = 0; i < ARRAY_SIZE(pdpte); ++i) {
-		if (is_present_pte(pdpte[i]) &&
+		if (is_present_gpte(pdpte[i]) &&
 		    (pdpte[i] & vcpu->arch.mmu.rsvd_bits_mask[0][2])) {
 			ret = 0;
 			goto out;
-- 
1.6.3.3

