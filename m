Return-Path: <linux-kernel-owner+w=401wt.eu-S1756859AbYIYMEf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756859AbYIYMEf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2008 08:04:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755028AbYIYL4N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Sep 2008 07:56:13 -0400
Received: from mx2.redhat.com ([66.187.237.31]:48599 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755005AbYIYL4J (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2008 07:56:09 -0400
From: Avi Kivity <avi@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: kvm@vger.kernel.org, Avi Kivity <avi@qumranet.com>
Subject: [PATCH 28/39] KVM: MMU: Convert the paging mode shadow walk to use the generic walker
Date: Thu, 25 Sep 2008 14:55:00 +0300
Message-Id: <1222343711-12508-29-git-send-email-avi@redhat.com>
In-Reply-To: <1222343711-12508-1-git-send-email-avi@redhat.com>
References: <1222343711-12508-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Avi Kivity <avi@qumranet.com>

Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 arch/x86/kvm/paging_tmpl.h |  158 ++++++++++++++++++++++++--------------------
 1 files changed, 86 insertions(+), 72 deletions(-)

diff --git a/arch/x86/kvm/paging_tmpl.h b/arch/x86/kvm/paging_tmpl.h
index ebb26a0..b7064e1 100644
--- a/arch/x86/kvm/paging_tmpl.h
+++ b/arch/x86/kvm/paging_tmpl.h
@@ -25,6 +25,7 @@
 #if PTTYPE == 64
 	#define pt_element_t u64
 	#define guest_walker guest_walker64
+	#define shadow_walker shadow_walker64
 	#define FNAME(name) paging##64_##name
 	#define PT_BASE_ADDR_MASK PT64_BASE_ADDR_MASK
 	#define PT_DIR_BASE_ADDR_MASK PT64_DIR_BASE_ADDR_MASK
@@ -41,6 +42,7 @@
 #elif PTTYPE == 32
 	#define pt_element_t u32
 	#define guest_walker guest_walker32
+	#define shadow_walker shadow_walker32
 	#define FNAME(name) paging##32_##name
 	#define PT_BASE_ADDR_MASK PT32_BASE_ADDR_MASK
 	#define PT_DIR_BASE_ADDR_MASK PT32_DIR_BASE_ADDR_MASK
@@ -71,6 +73,17 @@ struct guest_walker {
 	u32 error_code;
 };
 
+struct shadow_walker {
+	struct kvm_shadow_walk walker;
+	struct guest_walker *guest_walker;
+	int user_fault;
+	int write_fault;
+	int largepage;
+	int *ptwrite;
+	pfn_t pfn;
+	u64 *sptep;
+};
+
 static gfn_t gpte_to_gfn(pt_element_t gpte)
 {
 	return (gpte & PT_BASE_ADDR_MASK) >> PAGE_SHIFT;
@@ -272,86 +285,86 @@ static void FNAME(update_pte)(struct kvm_vcpu *vcpu, struct kvm_mmu_page *page,
 /*
  * Fetch a shadow pte for a specific level in the paging hierarchy.
  */
-static u64 *FNAME(fetch)(struct kvm_vcpu *vcpu, gva_t addr,
-			 struct guest_walker *walker,
-			 int user_fault, int write_fault, int largepage,
-			 int *ptwrite, pfn_t pfn)
+static int FNAME(shadow_walk_entry)(struct kvm_shadow_walk *_sw,
+				    struct kvm_vcpu *vcpu, gva_t addr,
+				    u64 *sptep, int level)
 {
-	hpa_t shadow_addr;
-	int level;
-	u64 *shadow_ent;
-	unsigned access = walker->pt_access;
-
-	if (!is_present_pte(walker->ptes[walker->level - 1]))
-		return NULL;
-
-	shadow_addr = vcpu->arch.mmu.root_hpa;
-	level = vcpu->arch.mmu.shadow_root_level;
-	if (level == PT32E_ROOT_LEVEL) {
-		shadow_addr = vcpu->arch.mmu.pae_root[(addr >> 30) & 3];
-		shadow_addr &= PT64_BASE_ADDR_MASK;
-		--level;
+	struct shadow_walker *sw =
+		container_of(_sw, struct shadow_walker, walker);
+	struct guest_walker *gw = sw->guest_walker;
+	unsigned access = gw->pt_access;
+	struct kvm_mmu_page *shadow_page;
+	u64 spte;
+	int metaphysical;
+	gfn_t table_gfn;
+	int r;
+	pt_element_t curr_pte;
+
+	if (level == PT_PAGE_TABLE_LEVEL
+	    || (sw->largepage && level == PT_DIRECTORY_LEVEL)) {
+		mmu_set_spte(vcpu, sptep, access, gw->pte_access & access,
+			     sw->user_fault, sw->write_fault,
+			     gw->ptes[gw->level-1] & PT_DIRTY_MASK,
+			     sw->ptwrite, sw->largepage, gw->gfn, sw->pfn,
+			     false);
+		sw->sptep = sptep;
+		return 1;
 	}
 
-	for (; ; level--) {
-		u32 index = SHADOW_PT_INDEX(addr, level);
-		struct kvm_mmu_page *shadow_page;
-		u64 shadow_pte;
-		int metaphysical;
-		gfn_t table_gfn;
-
-		shadow_ent = ((u64 *)__va(shadow_addr)) + index;
-		if (level == PT_PAGE_TABLE_LEVEL)
-			break;
-
-		if (largepage && level == PT_DIRECTORY_LEVEL)
-			break;
-
-		if (is_shadow_present_pte(*shadow_ent)
-		    && !is_large_pte(*shadow_ent)) {
-			shadow_addr = *shadow_ent & PT64_BASE_ADDR_MASK;
-			continue;
-		}
+	if (is_shadow_present_pte(*sptep) && !is_large_pte(*sptep))
+		return 0;
 
-		if (is_large_pte(*shadow_ent))
-			rmap_remove(vcpu->kvm, shadow_ent);
-
-		if (level - 1 == PT_PAGE_TABLE_LEVEL
-		    && walker->level == PT_DIRECTORY_LEVEL) {
-			metaphysical = 1;
-			if (!is_dirty_pte(walker->ptes[level - 1]))
-				access &= ~ACC_WRITE_MASK;
-			table_gfn = gpte_to_gfn(walker->ptes[level - 1]);
-		} else {
-			metaphysical = 0;
-			table_gfn = walker->table_gfn[level - 2];
-		}
-		shadow_page = kvm_mmu_get_page(vcpu, table_gfn, addr, level-1,
-					       metaphysical, access,
-					       shadow_ent);
-		if (!metaphysical) {
-			int r;
-			pt_element_t curr_pte;
-			r = kvm_read_guest_atomic(vcpu->kvm,
-						  walker->pte_gpa[level - 2],
-						  &curr_pte, sizeof(curr_pte));
-			if (r || curr_pte != walker->ptes[level - 2]) {
-				kvm_release_pfn_clean(pfn);
-				return NULL;
-			}
+	if (is_large_pte(*sptep))
+		rmap_remove(vcpu->kvm, sptep);
+
+	if (level == PT_DIRECTORY_LEVEL && gw->level == PT_DIRECTORY_LEVEL) {
+		metaphysical = 1;
+		if (!is_dirty_pte(gw->ptes[level - 1]))
+			access &= ~ACC_WRITE_MASK;
+		table_gfn = gpte_to_gfn(gw->ptes[level - 1]);
+	} else {
+		metaphysical = 0;
+		table_gfn = gw->table_gfn[level - 2];
+	}
+	shadow_page = kvm_mmu_get_page(vcpu, table_gfn, addr, level-1,
+				       metaphysical, access, sptep);
+	if (!metaphysical) {
+		r = kvm_read_guest_atomic(vcpu->kvm, gw->pte_gpa[level - 2],
+					  &curr_pte, sizeof(curr_pte));
+		if (r || curr_pte != gw->ptes[level - 2]) {
+			kvm_release_pfn_clean(sw->pfn);
+			sw->sptep = NULL;
+			return 1;
 		}
-		shadow_addr = __pa(shadow_page->spt);
-		shadow_pte = shadow_addr | PT_PRESENT_MASK | PT_ACCESSED_MASK
-			| PT_WRITABLE_MASK | PT_USER_MASK;
-		set_shadow_pte(shadow_ent, shadow_pte);
 	}
 
-	mmu_set_spte(vcpu, shadow_ent, access, walker->pte_access & access,
-		     user_fault, write_fault,
-		     walker->ptes[walker->level-1] & PT_DIRTY_MASK,
-		     ptwrite, largepage, walker->gfn, pfn, false);
+	spte = __pa(shadow_page->spt) | PT_PRESENT_MASK | PT_ACCESSED_MASK
+		| PT_WRITABLE_MASK | PT_USER_MASK;
+	*sptep = spte;
+	return 0;
+}
+
+static u64 *FNAME(fetch)(struct kvm_vcpu *vcpu, gva_t addr,
+			 struct guest_walker *guest_walker,
+			 int user_fault, int write_fault, int largepage,
+			 int *ptwrite, pfn_t pfn)
+{
+	struct shadow_walker walker = {
+		.walker = { .entry = FNAME(shadow_walk_entry), },
+		.guest_walker = guest_walker,
+		.user_fault = user_fault,
+		.write_fault = write_fault,
+		.largepage = largepage,
+		.ptwrite = ptwrite,
+		.pfn = pfn,
+	};
+
+	if (!is_present_pte(guest_walker->ptes[guest_walker->level - 1]))
+		return NULL;
+
+	walk_shadow(&walker.walker, vcpu, addr);
 
-	return shadow_ent;
+	return walker.sptep;
 }
 
 /*
@@ -499,6 +512,7 @@ static void FNAME(prefetch_page)(struct kvm_vcpu *vcpu,
 
 #undef pt_element_t
 #undef guest_walker
+#undef shadow_walker
 #undef FNAME
 #undef PT_BASE_ADDR_MASK
 #undef PT_INDEX
-- 
1.6.0.1

