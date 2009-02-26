Return-Path: <linux-kernel-owner+w=401wt.eu-S1757758AbZBZOWe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757758AbZBZOWe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Feb 2009 09:22:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757386AbZBZOQX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Feb 2009 09:16:23 -0500
Received: from mx2.redhat.com ([66.187.237.31]:43074 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754561AbZBZOPl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Feb 2009 09:15:41 -0500
From: Avi Kivity <avi@redhat.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 27/40] KVM: MMU: Replace walk_shadow() by for_each_shadow_entry() in fetch()
Date: Thu, 26 Feb 2009 16:15:17 +0200
Message-Id: <1235657730-27683-28-git-send-email-avi@redhat.com>
In-Reply-To: <1235657730-27683-1-git-send-email-avi@redhat.com>
References: <1235657730-27683-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Effectively reverting to the pre walk_shadow() version -- but now
with the reusable for_each().

Signed-off-by: Avi Kivity <avi@redhat.com>
---
 arch/x86/kvm/paging_tmpl.h |  128 ++++++++++++++++++++------------------------
 1 files changed, 58 insertions(+), 70 deletions(-)

diff --git a/arch/x86/kvm/paging_tmpl.h b/arch/x86/kvm/paging_tmpl.h
index 9fd78b6..69c7e33 100644
--- a/arch/x86/kvm/paging_tmpl.h
+++ b/arch/x86/kvm/paging_tmpl.h
@@ -283,91 +283,79 @@ static void FNAME(update_pte)(struct kvm_vcpu *vcpu, struct kvm_mmu_page *page,
 /*
  * Fetch a shadow pte for a specific level in the paging hierarchy.
  */
-static int FNAME(shadow_walk_entry)(struct kvm_shadow_walk *_sw,
-				    struct kvm_vcpu *vcpu, u64 addr,
-				    u64 *sptep, int level)
+static u64 *FNAME(fetch)(struct kvm_vcpu *vcpu, gva_t addr,
+			 struct guest_walker *gw,
+			 int user_fault, int write_fault, int largepage,
+			 int *ptwrite, pfn_t pfn)
 {
-	struct shadow_walker *sw =
-		container_of(_sw, struct shadow_walker, walker);
-	struct guest_walker *gw = sw->guest_walker;
 	unsigned access = gw->pt_access;
 	struct kvm_mmu_page *shadow_page;
-	u64 spte;
+	u64 spte, *sptep;
 	int metaphysical;
 	gfn_t table_gfn;
 	int r;
+	int level;
 	pt_element_t curr_pte;
+	struct kvm_shadow_walk_iterator iterator;
 
-	if (level == PT_PAGE_TABLE_LEVEL
-	    || (sw->largepage && level == PT_DIRECTORY_LEVEL)) {
-		mmu_set_spte(vcpu, sptep, access, gw->pte_access & access,
-			     sw->user_fault, sw->write_fault,
-			     gw->ptes[gw->level-1] & PT_DIRTY_MASK,
-			     sw->ptwrite, sw->largepage,
-			     gw->ptes[gw->level-1] & PT_GLOBAL_MASK,
-			     gw->gfn, sw->pfn, false);
-		sw->sptep = sptep;
-		return 1;
-	}
-
-	if (is_shadow_present_pte(*sptep) && !is_large_pte(*sptep))
-		return 0;
-
-	if (is_large_pte(*sptep)) {
-		set_shadow_pte(sptep, shadow_trap_nonpresent_pte);
-		kvm_flush_remote_tlbs(vcpu->kvm);
-		rmap_remove(vcpu->kvm, sptep);
-	}
+	if (!is_present_pte(gw->ptes[gw->level - 1]))
+		return NULL;
 
-	if (level == PT_DIRECTORY_LEVEL && gw->level == PT_DIRECTORY_LEVEL) {
-		metaphysical = 1;
-		if (!is_dirty_pte(gw->ptes[level - 1]))
-			access &= ~ACC_WRITE_MASK;
-		table_gfn = gpte_to_gfn(gw->ptes[level - 1]);
-	} else {
-		metaphysical = 0;
-		table_gfn = gw->table_gfn[level - 2];
-	}
-	shadow_page = kvm_mmu_get_page(vcpu, table_gfn, (gva_t)addr, level-1,
-				       metaphysical, access, sptep);
-	if (!metaphysical) {
-		r = kvm_read_guest_atomic(vcpu->kvm, gw->pte_gpa[level - 2],
-					  &curr_pte, sizeof(curr_pte));
-		if (r || curr_pte != gw->ptes[level - 2]) {
-			kvm_mmu_put_page(shadow_page, sptep);
-			kvm_release_pfn_clean(sw->pfn);
-			sw->sptep = NULL;
-			return 1;
+	for_each_shadow_entry(vcpu, addr, iterator) {
+		level = iterator.level;
+		sptep = iterator.sptep;
+		if (level == PT_PAGE_TABLE_LEVEL
+		    || (largepage && level == PT_DIRECTORY_LEVEL)) {
+			mmu_set_spte(vcpu, sptep, access,
+				     gw->pte_access & access,
+				     user_fault, write_fault,
+				     gw->ptes[gw->level-1] & PT_DIRTY_MASK,
+				     ptwrite, largepage,
+				     gw->ptes[gw->level-1] & PT_GLOBAL_MASK,
+				     gw->gfn, pfn, false);
+			break;
 		}
-	}
 
-	spte = __pa(shadow_page->spt) | PT_PRESENT_MASK | PT_ACCESSED_MASK
-		| PT_WRITABLE_MASK | PT_USER_MASK;
-	*sptep = spte;
-	return 0;
-}
+		if (is_shadow_present_pte(*sptep) && !is_large_pte(*sptep))
+			continue;
 
-static u64 *FNAME(fetch)(struct kvm_vcpu *vcpu, gva_t addr,
-			 struct guest_walker *guest_walker,
-			 int user_fault, int write_fault, int largepage,
-			 int *ptwrite, pfn_t pfn)
-{
-	struct shadow_walker walker = {
-		.walker = { .entry = FNAME(shadow_walk_entry), },
-		.guest_walker = guest_walker,
-		.user_fault = user_fault,
-		.write_fault = write_fault,
-		.largepage = largepage,
-		.ptwrite = ptwrite,
-		.pfn = pfn,
-	};
+		if (is_large_pte(*sptep)) {
+			set_shadow_pte(sptep, shadow_trap_nonpresent_pte);
+			kvm_flush_remote_tlbs(vcpu->kvm);
+			rmap_remove(vcpu->kvm, sptep);
+		}
 
-	if (!is_present_pte(guest_walker->ptes[guest_walker->level - 1]))
-		return NULL;
+		if (level == PT_DIRECTORY_LEVEL
+		    && gw->level == PT_DIRECTORY_LEVEL) {
+			metaphysical = 1;
+			if (!is_dirty_pte(gw->ptes[level - 1]))
+				access &= ~ACC_WRITE_MASK;
+			table_gfn = gpte_to_gfn(gw->ptes[level - 1]);
+		} else {
+			metaphysical = 0;
+			table_gfn = gw->table_gfn[level - 2];
+		}
+		shadow_page = kvm_mmu_get_page(vcpu, table_gfn, addr, level-1,
+					       metaphysical, access, sptep);
+		if (!metaphysical) {
+			r = kvm_read_guest_atomic(vcpu->kvm,
+						  gw->pte_gpa[level - 2],
+						  &curr_pte, sizeof(curr_pte));
+			if (r || curr_pte != gw->ptes[level - 2]) {
+				kvm_mmu_put_page(shadow_page, sptep);
+				kvm_release_pfn_clean(pfn);
+				sptep = NULL;
+				break;
+			}
+		}
 
-	walk_shadow(&walker.walker, vcpu, addr);
+		spte = __pa(shadow_page->spt)
+			| PT_PRESENT_MASK | PT_ACCESSED_MASK
+			| PT_WRITABLE_MASK | PT_USER_MASK;
+		*sptep = spte;
+	}
 
-	return walker.sptep;
+	return sptep;
 }
 
 /*
-- 
1.6.0.6

