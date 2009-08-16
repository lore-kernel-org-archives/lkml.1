Return-Path: <linux-kernel-owner+w=401wt.eu-S1754386AbZHPJbi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754386AbZHPJbi (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Aug 2009 05:31:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754123AbZHPJbg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Aug 2009 05:31:36 -0400
Received: from mx2.redhat.com ([66.187.237.31]:45383 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754122AbZHPJaP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Aug 2009 05:30:15 -0400
From: Avi Kivity <avi@redhat.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 44/48] KVM: MMU: s/shadow_pte/spte/
Date: Sun, 16 Aug 2009 12:30:04 +0300
Message-Id: <1250415008-17175-45-git-send-email-avi@redhat.com>
In-Reply-To: <1250415008-17175-1-git-send-email-avi@redhat.com>
References: <1250415008-17175-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We use shadow_pte and spte inconsistently, switch to the shorter spelling.

Rename set_shadow_pte() to __set_spte() to avoid a conflict with the
existing set_spte(), and to indicate its lowlevelness.

Signed-off-by: Avi Kivity <avi@redhat.com>
---
 arch/x86/kvm/mmu.c         |  102 ++++++++++++++++++++++----------------------
 arch/x86/kvm/paging_tmpl.h |   16 +++---
 2 files changed, 59 insertions(+), 59 deletions(-)

diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index a039e6b..d443a42 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -143,7 +143,7 @@ module_param(oos_shadow, bool, 0644);
 #define SHADOW_PT_INDEX(addr, level) PT64_INDEX(addr, level)
 
 struct kvm_rmap_desc {
-	u64 *shadow_ptes[RMAP_EXT];
+	u64 *sptes[RMAP_EXT];
 	struct kvm_rmap_desc *more;
 };
 
@@ -262,7 +262,7 @@ static gfn_t pse36_gfn_delta(u32 gpte)
 	return (gpte & PT32_DIR_PSE36_MASK) << shift;
 }
 
-static void set_shadow_pte(u64 *sptep, u64 spte)
+static void __set_spte(u64 *sptep, u64 spte)
 {
 #ifdef CONFIG_X86_64
 	set_64bit((unsigned long *)sptep, spte);
@@ -514,23 +514,23 @@ static int rmap_add(struct kvm_vcpu *vcpu, u64 *spte, gfn_t gfn, int lpage)
 	} else if (!(*rmapp & 1)) {
 		rmap_printk("rmap_add: %p %llx 1->many\n", spte, *spte);
 		desc = mmu_alloc_rmap_desc(vcpu);
-		desc->shadow_ptes[0] = (u64 *)*rmapp;
-		desc->shadow_ptes[1] = spte;
+		desc->sptes[0] = (u64 *)*rmapp;
+		desc->sptes[1] = spte;
 		*rmapp = (unsigned long)desc | 1;
 	} else {
 		rmap_printk("rmap_add: %p %llx many->many\n", spte, *spte);
 		desc = (struct kvm_rmap_desc *)(*rmapp & ~1ul);
-		while (desc->shadow_ptes[RMAP_EXT-1] && desc->more) {
+		while (desc->sptes[RMAP_EXT-1] && desc->more) {
 			desc = desc->more;
 			count += RMAP_EXT;
 		}
-		if (desc->shadow_ptes[RMAP_EXT-1]) {
+		if (desc->sptes[RMAP_EXT-1]) {
 			desc->more = mmu_alloc_rmap_desc(vcpu);
 			desc = desc->more;
 		}
-		for (i = 0; desc->shadow_ptes[i]; ++i)
+		for (i = 0; desc->sptes[i]; ++i)
 			;
-		desc->shadow_ptes[i] = spte;
+		desc->sptes[i] = spte;
 	}
 	return count;
 }
@@ -542,14 +542,14 @@ static void rmap_desc_remove_entry(unsigned long *rmapp,
 {
 	int j;
 
-	for (j = RMAP_EXT - 1; !desc->shadow_ptes[j] && j > i; --j)
+	for (j = RMAP_EXT - 1; !desc->sptes[j] && j > i; --j)
 		;
-	desc->shadow_ptes[i] = desc->shadow_ptes[j];
-	desc->shadow_ptes[j] = NULL;
+	desc->sptes[i] = desc->sptes[j];
+	desc->sptes[j] = NULL;
 	if (j != 0)
 		return;
 	if (!prev_desc && !desc->more)
-		*rmapp = (unsigned long)desc->shadow_ptes[0];
+		*rmapp = (unsigned long)desc->sptes[0];
 	else
 		if (prev_desc)
 			prev_desc->more = desc->more;
@@ -594,8 +594,8 @@ static void rmap_remove(struct kvm *kvm, u64 *spte)
 		desc = (struct kvm_rmap_desc *)(*rmapp & ~1ul);
 		prev_desc = NULL;
 		while (desc) {
-			for (i = 0; i < RMAP_EXT && desc->shadow_ptes[i]; ++i)
-				if (desc->shadow_ptes[i] == spte) {
+			for (i = 0; i < RMAP_EXT && desc->sptes[i]; ++i)
+				if (desc->sptes[i] == spte) {
 					rmap_desc_remove_entry(rmapp,
 							       desc, i,
 							       prev_desc);
@@ -626,10 +626,10 @@ static u64 *rmap_next(struct kvm *kvm, unsigned long *rmapp, u64 *spte)
 	prev_desc = NULL;
 	prev_spte = NULL;
 	while (desc) {
-		for (i = 0; i < RMAP_EXT && desc->shadow_ptes[i]; ++i) {
+		for (i = 0; i < RMAP_EXT && desc->sptes[i]; ++i) {
 			if (prev_spte == spte)
-				return desc->shadow_ptes[i];
-			prev_spte = desc->shadow_ptes[i];
+				return desc->sptes[i];
+			prev_spte = desc->sptes[i];
 		}
 		desc = desc->more;
 	}
@@ -651,7 +651,7 @@ static int rmap_write_protect(struct kvm *kvm, u64 gfn)
 		BUG_ON(!(*spte & PT_PRESENT_MASK));
 		rmap_printk("rmap_write_protect: spte %p %llx\n", spte, *spte);
 		if (is_writeble_pte(*spte)) {
-			set_shadow_pte(spte, *spte & ~PT_WRITABLE_MASK);
+			__set_spte(spte, *spte & ~PT_WRITABLE_MASK);
 			write_protected = 1;
 		}
 		spte = rmap_next(kvm, rmapp, spte);
@@ -675,7 +675,7 @@ static int rmap_write_protect(struct kvm *kvm, u64 gfn)
 		if (is_writeble_pte(*spte)) {
 			rmap_remove(kvm, spte);
 			--kvm->stat.lpages;
-			set_shadow_pte(spte, shadow_trap_nonpresent_pte);
+			__set_spte(spte, shadow_trap_nonpresent_pte);
 			spte = NULL;
 			write_protected = 1;
 		}
@@ -694,7 +694,7 @@ static int kvm_unmap_rmapp(struct kvm *kvm, unsigned long *rmapp)
 		BUG_ON(!(*spte & PT_PRESENT_MASK));
 		rmap_printk("kvm_rmap_unmap_hva: spte %p %llx\n", spte, *spte);
 		rmap_remove(kvm, spte);
-		set_shadow_pte(spte, shadow_trap_nonpresent_pte);
+		__set_spte(spte, shadow_trap_nonpresent_pte);
 		need_tlb_flush = 1;
 	}
 	return need_tlb_flush;
@@ -1369,7 +1369,7 @@ static void kvm_mmu_unlink_parents(struct kvm *kvm, struct kvm_mmu_page *sp)
 		}
 		BUG_ON(!parent_pte);
 		kvm_mmu_put_page(sp, parent_pte);
-		set_shadow_pte(parent_pte, shadow_trap_nonpresent_pte);
+		__set_spte(parent_pte, shadow_trap_nonpresent_pte);
 	}
 }
 
@@ -1517,7 +1517,7 @@ static void mmu_convert_notrap(struct kvm_mmu_page *sp)
 
 	for (i = 0; i < PT64_ENT_PER_PAGE; ++i) {
 		if (pt[i] == shadow_notrap_nonpresent_pte)
-			set_shadow_pte(&pt[i], shadow_trap_nonpresent_pte);
+			__set_spte(&pt[i], shadow_trap_nonpresent_pte);
 	}
 }
 
@@ -1683,7 +1683,7 @@ static int mmu_need_write_protect(struct kvm_vcpu *vcpu, gfn_t gfn,
 	return 0;
 }
 
-static int set_spte(struct kvm_vcpu *vcpu, u64 *shadow_pte,
+static int set_spte(struct kvm_vcpu *vcpu, u64 *sptep,
 		    unsigned pte_access, int user_fault,
 		    int write_fault, int dirty, int largepage,
 		    gfn_t gfn, pfn_t pfn, bool speculative,
@@ -1733,7 +1733,7 @@ static int set_spte(struct kvm_vcpu *vcpu, u64 *shadow_pte,
 		 * is responsibility of mmu_get_page / kvm_sync_page.
 		 * Same reasoning can be applied to dirty page accounting.
 		 */
-		if (!can_unsync && is_writeble_pte(*shadow_pte))
+		if (!can_unsync && is_writeble_pte(*sptep))
 			goto set_pte;
 
 		if (mmu_need_write_protect(vcpu, gfn, can_unsync)) {
@@ -1750,62 +1750,62 @@ static int set_spte(struct kvm_vcpu *vcpu, u64 *shadow_pte,
 		mark_page_dirty(vcpu->kvm, gfn);
 
 set_pte:
-	set_shadow_pte(shadow_pte, spte);
+	__set_spte(sptep, spte);
 	return ret;
 }
 
-static void mmu_set_spte(struct kvm_vcpu *vcpu, u64 *shadow_pte,
+static void mmu_set_spte(struct kvm_vcpu *vcpu, u64 *sptep,
 			 unsigned pt_access, unsigned pte_access,
 			 int user_fault, int write_fault, int dirty,
 			 int *ptwrite, int largepage, gfn_t gfn,
 			 pfn_t pfn, bool speculative)
 {
 	int was_rmapped = 0;
-	int was_writeble = is_writeble_pte(*shadow_pte);
+	int was_writeble = is_writeble_pte(*sptep);
 	int rmap_count;
 
 	pgprintk("%s: spte %llx access %x write_fault %d"
 		 " user_fault %d gfn %lx\n",
-		 __func__, *shadow_pte, pt_access,
+		 __func__, *sptep, pt_access,
 		 write_fault, user_fault, gfn);
 
-	if (is_rmap_spte(*shadow_pte)) {
+	if (is_rmap_spte(*sptep)) {
 		/*
 		 * If we overwrite a PTE page pointer with a 2MB PMD, unlink
 		 * the parent of the now unreachable PTE.
 		 */
-		if (largepage && !is_large_pte(*shadow_pte)) {
+		if (largepage && !is_large_pte(*sptep)) {
 			struct kvm_mmu_page *child;
-			u64 pte = *shadow_pte;
+			u64 pte = *sptep;
 
 			child = page_header(pte & PT64_BASE_ADDR_MASK);
-			mmu_page_remove_parent_pte(child, shadow_pte);
-		} else if (pfn != spte_to_pfn(*shadow_pte)) {
+			mmu_page_remove_parent_pte(child, sptep);
+		} else if (pfn != spte_to_pfn(*sptep)) {
 			pgprintk("hfn old %lx new %lx\n",
-				 spte_to_pfn(*shadow_pte), pfn);
-			rmap_remove(vcpu->kvm, shadow_pte);
+				 spte_to_pfn(*sptep), pfn);
+			rmap_remove(vcpu->kvm, sptep);
 		} else
 			was_rmapped = 1;
 	}
-	if (set_spte(vcpu, shadow_pte, pte_access, user_fault, write_fault,
+	if (set_spte(vcpu, sptep, pte_access, user_fault, write_fault,
 		      dirty, largepage, gfn, pfn, speculative, true)) {
 		if (write_fault)
 			*ptwrite = 1;
 		kvm_x86_ops->tlb_flush(vcpu);
 	}
 
-	pgprintk("%s: setting spte %llx\n", __func__, *shadow_pte);
+	pgprintk("%s: setting spte %llx\n", __func__, *sptep);
 	pgprintk("instantiating %s PTE (%s) at %ld (%llx) addr %p\n",
-		 is_large_pte(*shadow_pte)? "2MB" : "4kB",
-		 is_present_pte(*shadow_pte)?"RW":"R", gfn,
-		 *shadow_pte, shadow_pte);
-	if (!was_rmapped && is_large_pte(*shadow_pte))
+		 is_large_pte(*sptep)? "2MB" : "4kB",
+		 is_present_pte(*sptep)?"RW":"R", gfn,
+		 *shadow_pte, sptep);
+	if (!was_rmapped && is_large_pte(*sptep))
 		++vcpu->kvm->stat.lpages;
 
-	page_header_update_slot(vcpu->kvm, shadow_pte, gfn);
+	page_header_update_slot(vcpu->kvm, sptep, gfn);
 	if (!was_rmapped) {
-		rmap_count = rmap_add(vcpu, shadow_pte, gfn, largepage);
-		if (!is_rmap_spte(*shadow_pte))
+		rmap_count = rmap_add(vcpu, sptep, gfn, largepage);
+		if (!is_rmap_spte(*sptep))
 			kvm_release_pfn_clean(pfn);
 		if (rmap_count > RMAP_RECYCLE_THRESHOLD)
 			rmap_recycle(vcpu, gfn, largepage);
@@ -1816,7 +1816,7 @@ static void mmu_set_spte(struct kvm_vcpu *vcpu, u64 *shadow_pte,
 			kvm_release_pfn_clean(pfn);
 	}
 	if (speculative) {
-		vcpu->arch.last_pte_updated = shadow_pte;
+		vcpu->arch.last_pte_updated = sptep;
 		vcpu->arch.last_pte_gfn = gfn;
 	}
 }
@@ -1854,10 +1854,10 @@ static int __direct_map(struct kvm_vcpu *vcpu, gpa_t v, int write,
 				return -ENOMEM;
 			}
 
-			set_shadow_pte(iterator.sptep,
-				       __pa(sp->spt)
-				       | PT_PRESENT_MASK | PT_WRITABLE_MASK
-				       | shadow_user_mask | shadow_x_mask);
+			__set_spte(iterator.sptep,
+				   __pa(sp->spt)
+				   | PT_PRESENT_MASK | PT_WRITABLE_MASK
+				   | shadow_user_mask | shadow_x_mask);
 		}
 	}
 	return pt_write;
@@ -2389,7 +2389,7 @@ static void mmu_pte_write_zap_pte(struct kvm_vcpu *vcpu,
 			mmu_page_remove_parent_pte(child, spte);
 		}
 	}
-	set_shadow_pte(spte, shadow_trap_nonpresent_pte);
+	__set_spte(spte, shadow_trap_nonpresent_pte);
 	if (is_large_pte(pte))
 		--vcpu->kvm->stat.lpages;
 }
@@ -3125,7 +3125,7 @@ static int count_rmaps(struct kvm_vcpu *vcpu)
 			d = (struct kvm_rmap_desc *)(*rmapp & ~1ul);
 			while (d) {
 				for (k = 0; k < RMAP_EXT; ++k)
-					if (d->shadow_ptes[k])
+					if (d->sptes[k])
 						++nmaps;
 					else
 						break;
diff --git a/arch/x86/kvm/paging_tmpl.h b/arch/x86/kvm/paging_tmpl.h
index 238a193..322e811 100644
--- a/arch/x86/kvm/paging_tmpl.h
+++ b/arch/x86/kvm/paging_tmpl.h
@@ -253,7 +253,7 @@ static void FNAME(update_pte)(struct kvm_vcpu *vcpu, struct kvm_mmu_page *page,
 	gpte = *(const pt_element_t *)pte;
 	if (~gpte & (PT_PRESENT_MASK | PT_ACCESSED_MASK)) {
 		if (!is_present_gpte(gpte))
-			set_shadow_pte(spte, shadow_notrap_nonpresent_pte);
+			__set_spte(spte, shadow_notrap_nonpresent_pte);
 		return;
 	}
 	pgprintk("%s: gpte %llx spte %p\n", __func__, (u64)gpte, spte);
@@ -311,7 +311,7 @@ static u64 *FNAME(fetch)(struct kvm_vcpu *vcpu, gva_t addr,
 
 		if (is_large_pte(*sptep)) {
 			rmap_remove(vcpu->kvm, sptep);
-			set_shadow_pte(sptep, shadow_trap_nonpresent_pte);
+			__set_spte(sptep, shadow_trap_nonpresent_pte);
 			kvm_flush_remote_tlbs(vcpu->kvm);
 		}
 
@@ -369,7 +369,7 @@ static int FNAME(page_fault)(struct kvm_vcpu *vcpu, gva_t addr,
 	int user_fault = error_code & PFERR_USER_MASK;
 	int fetch_fault = error_code & PFERR_FETCH_MASK;
 	struct guest_walker walker;
-	u64 *shadow_pte;
+	u64 *sptep;
 	int write_pt = 0;
 	int r;
 	pfn_t pfn;
@@ -422,11 +422,11 @@ static int FNAME(page_fault)(struct kvm_vcpu *vcpu, gva_t addr,
 	if (mmu_notifier_retry(vcpu, mmu_seq))
 		goto out_unlock;
 	kvm_mmu_free_some_pages(vcpu);
-	shadow_pte = FNAME(fetch)(vcpu, addr, &walker, user_fault, write_fault,
-				  largepage, &write_pt, pfn);
+	sptep = FNAME(fetch)(vcpu, addr, &walker, user_fault, write_fault,
+			     largepage, &write_pt, pfn);
 
 	pgprintk("%s: shadow pte %p %llx ptwrite %d\n", __func__,
-		 shadow_pte, *shadow_pte, write_pt);
+		 sptep, *sptep, write_pt);
 
 	if (!write_pt)
 		vcpu->arch.last_pt_write_count = 0; /* reset fork detector */
@@ -472,7 +472,7 @@ static void FNAME(invlpg)(struct kvm_vcpu *vcpu, gva_t gva)
 					--vcpu->kvm->stat.lpages;
 				need_flush = 1;
 			}
-			set_shadow_pte(sptep, shadow_trap_nonpresent_pte);
+			__set_spte(sptep, shadow_trap_nonpresent_pte);
 			break;
 		}
 
@@ -583,7 +583,7 @@ static int FNAME(sync_page)(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp)
 				nonpresent = shadow_trap_nonpresent_pte;
 			else
 				nonpresent = shadow_notrap_nonpresent_pte;
-			set_shadow_pte(&sp->spt[i], nonpresent);
+			__set_spte(&sp->spt[i], nonpresent);
 			continue;
 		}
 
-- 
1.6.3.3

