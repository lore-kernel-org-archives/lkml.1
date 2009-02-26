Return-Path: <linux-kernel-owner+w=401wt.eu-S1760300AbZBZO16@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760300AbZBZO16 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Feb 2009 09:27:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757894AbZBZORO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Feb 2009 09:17:14 -0500
Received: from mx2.redhat.com ([66.187.237.31]:43087 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754789AbZBZOPm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Feb 2009 09:15:42 -0500
From: Avi Kivity <avi@redhat.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 28/40] KVM: MMU: Replace walk_shadow() by for_each_shadow_entry() in invlpg()
Date: Thu, 26 Feb 2009 16:15:18 +0200
Message-Id: <1235657730-27683-29-git-send-email-avi@redhat.com>
In-Reply-To: <1235657730-27683-1-git-send-email-avi@redhat.com>
References: <1235657730-27683-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Avi Kivity <avi@redhat.com>
---
 arch/x86/kvm/paging_tmpl.h |   81 +++++++++++++++++--------------------------
 1 files changed, 32 insertions(+), 49 deletions(-)

diff --git a/arch/x86/kvm/paging_tmpl.h b/arch/x86/kvm/paging_tmpl.h
index 69c7e33..46b68f9 100644
--- a/arch/x86/kvm/paging_tmpl.h
+++ b/arch/x86/kvm/paging_tmpl.h
@@ -25,7 +25,6 @@
 #if PTTYPE == 64
 	#define pt_element_t u64
 	#define guest_walker guest_walker64
-	#define shadow_walker shadow_walker64
 	#define FNAME(name) paging##64_##name
 	#define PT_BASE_ADDR_MASK PT64_BASE_ADDR_MASK
 	#define PT_DIR_BASE_ADDR_MASK PT64_DIR_BASE_ADDR_MASK
@@ -42,7 +41,6 @@
 #elif PTTYPE == 32
 	#define pt_element_t u32
 	#define guest_walker guest_walker32
-	#define shadow_walker shadow_walker32
 	#define FNAME(name) paging##32_##name
 	#define PT_BASE_ADDR_MASK PT32_BASE_ADDR_MASK
 	#define PT_DIR_BASE_ADDR_MASK PT32_DIR_BASE_ADDR_MASK
@@ -73,18 +71,6 @@ struct guest_walker {
 	u32 error_code;
 };
 
-struct shadow_walker {
-	struct kvm_shadow_walk walker;
-	struct guest_walker *guest_walker;
-	int user_fault;
-	int write_fault;
-	int largepage;
-	int *ptwrite;
-	pfn_t pfn;
-	u64 *sptep;
-	gpa_t pte_gpa;
-};
-
 static gfn_t gpte_to_gfn(pt_element_t gpte)
 {
 	return (gpte & PT_BASE_ADDR_MASK) >> PAGE_SHIFT;
@@ -453,54 +439,52 @@ out_unlock:
 	return 0;
 }
 
-static int FNAME(shadow_invlpg_entry)(struct kvm_shadow_walk *_sw,
-				      struct kvm_vcpu *vcpu, u64 addr,
-				      u64 *sptep, int level)
+static void FNAME(invlpg)(struct kvm_vcpu *vcpu, gva_t gva)
 {
-	struct shadow_walker *sw =
-		container_of(_sw, struct shadow_walker, walker);
+	struct kvm_shadow_walk_iterator iterator;
+	pt_element_t gpte;
+	gpa_t pte_gpa = -1;
+	int level;
+	u64 *sptep;
+
+	spin_lock(&vcpu->kvm->mmu_lock);
 
-	/* FIXME: properly handle invlpg on large guest pages */
-	if (level == PT_PAGE_TABLE_LEVEL ||
-	    ((level == PT_DIRECTORY_LEVEL) && is_large_pte(*sptep))) {
-		struct kvm_mmu_page *sp = page_header(__pa(sptep));
+	for_each_shadow_entry(vcpu, gva, iterator) {
+		level = iterator.level;
+		sptep = iterator.sptep;
 
-		sw->pte_gpa = (sp->gfn << PAGE_SHIFT);
-		sw->pte_gpa += (sptep - sp->spt) * sizeof(pt_element_t);
+		/* FIXME: properly handle invlpg on large guest pages */
+		if (level == PT_PAGE_TABLE_LEVEL ||
+		    ((level == PT_DIRECTORY_LEVEL) && is_large_pte(*sptep))) {
+			struct kvm_mmu_page *sp = page_header(__pa(sptep));
 
-		if (is_shadow_present_pte(*sptep)) {
-			rmap_remove(vcpu->kvm, sptep);
-			if (is_large_pte(*sptep))
-				--vcpu->kvm->stat.lpages;
+			pte_gpa = (sp->gfn << PAGE_SHIFT);
+			pte_gpa += (sptep - sp->spt) * sizeof(pt_element_t);
+
+			if (is_shadow_present_pte(*sptep)) {
+				rmap_remove(vcpu->kvm, sptep);
+				if (is_large_pte(*sptep))
+					--vcpu->kvm->stat.lpages;
+			}
+			set_shadow_pte(sptep, shadow_trap_nonpresent_pte);
+			break;
 		}
-		set_shadow_pte(sptep, shadow_trap_nonpresent_pte);
-		return 1;
-	}
-	if (!is_shadow_present_pte(*sptep))
-		return 1;
-	return 0;
-}
 
-static void FNAME(invlpg)(struct kvm_vcpu *vcpu, gva_t gva)
-{
-	pt_element_t gpte;
-	struct shadow_walker walker = {
-		.walker = { .entry = FNAME(shadow_invlpg_entry), },
-		.pte_gpa = -1,
-	};
+		if (!is_shadow_present_pte(*sptep))
+			break;
+	}
 
-	spin_lock(&vcpu->kvm->mmu_lock);
-	walk_shadow(&walker.walker, vcpu, gva);
 	spin_unlock(&vcpu->kvm->mmu_lock);
-	if (walker.pte_gpa == -1)
+
+	if (pte_gpa == -1)
 		return;
-	if (kvm_read_guest_atomic(vcpu->kvm, walker.pte_gpa, &gpte,
+	if (kvm_read_guest_atomic(vcpu->kvm, pte_gpa, &gpte,
 				  sizeof(pt_element_t)))
 		return;
 	if (is_present_pte(gpte) && (gpte & PT_ACCESSED_MASK)) {
 		if (mmu_topup_memory_caches(vcpu))
 			return;
-		kvm_mmu_pte_write(vcpu, walker.pte_gpa, (const u8 *)&gpte,
+		kvm_mmu_pte_write(vcpu, pte_gpa, (const u8 *)&gpte,
 				  sizeof(pt_element_t), 0);
 	}
 }
@@ -607,7 +591,6 @@ static int FNAME(sync_page)(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp)
 
 #undef pt_element_t
 #undef guest_walker
-#undef shadow_walker
 #undef FNAME
 #undef PT_BASE_ADDR_MASK
 #undef PT_INDEX
-- 
1.6.0.6

