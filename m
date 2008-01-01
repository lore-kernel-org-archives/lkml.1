Return-Path: <linux-kernel-owner+w=401wt.eu-S1759693AbYAAPxv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759693AbYAAPxv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jan 2008 10:53:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755295AbYAAPhN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Jan 2008 10:37:13 -0500
Received: from il.qumranet.com ([82.166.9.18]:33794 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755147AbYAAPga (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jan 2008 10:36:30 -0500
From: Avi Kivity <avi@qumranet.com>
To: linux-kernel@vger.kernel.org, kvm-devel@lists.sourceforge.net
Subject: [PATCH 42/54] KVM: MMU: Simplify calculation of pte access
Date: Tue,  1 Jan 2008 17:36:08 +0200
Message-Id: <1199201780-14001-43-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.3.7
In-Reply-To: <1199201780-14001-1-git-send-email-avi@qumranet.com>
References: <1199201780-14001-1-git-send-email-avi@qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The nx bit is awkwardly placed in the 63rd bit position; furthermore it
has a reversed meaning compared to the other bits, which means we can't use
a bitwise and to calculate compounded access masks.

So, we simplify things by creating a new 3-bit exec/write/user access word,
and doing all calculations in that.

Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 drivers/kvm/mmu.c         |   14 +++++++---
 drivers/kvm/paging_tmpl.h |   58 +++++++++++++++++++++++++-------------------
 2 files changed, 43 insertions(+), 29 deletions(-)

diff --git a/drivers/kvm/mmu.c b/drivers/kvm/mmu.c
index 62a7415..f8a2137 100644
--- a/drivers/kvm/mmu.c
+++ b/drivers/kvm/mmu.c
@@ -85,7 +85,8 @@ static int dbg = 1;
 #define PT_PAGE_SIZE_MASK (1ULL << 7)
 #define PT_PAT_MASK (1ULL << 7)
 #define PT_GLOBAL_MASK (1ULL << 8)
-#define PT64_NX_MASK (1ULL << 63)
+#define PT64_NX_SHIFT 63
+#define PT64_NX_MASK (1ULL << PT64_NX_SHIFT)
 
 #define PT_PAT_SHIFT 7
 #define PT_DIR_PAT_SHIFT 12
@@ -153,6 +154,11 @@ static int dbg = 1;
 
 #define RMAP_EXT 4
 
+#define ACC_EXEC_MASK    1
+#define ACC_WRITE_MASK   PT_WRITABLE_MASK
+#define ACC_USER_MASK    PT_USER_MASK
+#define ACC_ALL          (ACC_EXEC_MASK | ACC_WRITE_MASK | ACC_USER_MASK)
+
 struct kvm_rmap_desc {
 	u64 *shadow_ptes[RMAP_EXT];
 	struct kvm_rmap_desc *more;
@@ -921,7 +927,7 @@ static int nonpaging_map(struct kvm_vcpu *vcpu, gva_t v, struct page *page)
 				>> PAGE_SHIFT;
 			new_table = kvm_mmu_get_page(vcpu, pseudo_gfn,
 						     v, level - 1,
-						     1, 3, &table[index]);
+						     1, ACC_ALL, &table[index]);
 			if (!new_table) {
 				pgprintk("nonpaging_map: ENOMEM\n");
 				kvm_release_page_clean(page);
@@ -988,7 +994,7 @@ static void mmu_alloc_roots(struct kvm_vcpu *vcpu)
 
 		ASSERT(!VALID_PAGE(root));
 		sp = kvm_mmu_get_page(vcpu, root_gfn, 0,
-				      PT64_ROOT_LEVEL, 0, 0, NULL);
+				      PT64_ROOT_LEVEL, 0, ACC_ALL, NULL);
 		root = __pa(sp->spt);
 		++sp->root_count;
 		vcpu->mmu.root_hpa = root;
@@ -1009,7 +1015,7 @@ static void mmu_alloc_roots(struct kvm_vcpu *vcpu)
 			root_gfn = 0;
 		sp = kvm_mmu_get_page(vcpu, root_gfn, i << 30,
 				      PT32_ROOT_LEVEL, !is_paging(vcpu),
-				      0, NULL);
+				      ACC_ALL, NULL);
 		root = __pa(sp->spt);
 		++sp->root_count;
 		vcpu->mmu.pae_root[i] = root | PT_PRESENT_MASK;
diff --git a/drivers/kvm/paging_tmpl.h b/drivers/kvm/paging_tmpl.h
index 8086f82..7688cbf 100644
--- a/drivers/kvm/paging_tmpl.h
+++ b/drivers/kvm/paging_tmpl.h
@@ -66,7 +66,8 @@ struct guest_walker {
 	int level;
 	gfn_t table_gfn[PT_MAX_FULL_LEVELS];
 	pt_element_t pte;
-	pt_element_t inherited_ar;
+	unsigned pt_access;
+	unsigned pte_access;
 	gfn_t gfn;
 	u32 error_code;
 };
@@ -110,7 +111,7 @@ static int FNAME(walk_addr)(struct guest_walker *walker,
 {
 	pt_element_t pte;
 	gfn_t table_gfn;
-	unsigned index;
+	unsigned index, pt_access, pte_access;
 	gpa_t pte_gpa;
 
 	pgprintk("%s: addr %lx\n", __FUNCTION__, addr);
@@ -128,7 +129,7 @@ walk:
 	ASSERT((!is_long_mode(vcpu) && is_pae(vcpu)) ||
 	       (vcpu->cr3 & CR3_NONPAE_RESERVED_BITS) == 0);
 
-	walker->inherited_ar = PT_USER_MASK | PT_WRITABLE_MASK;
+	pt_access = ACC_ALL;
 
 	for (;;) {
 		index = PT_INDEX(addr, walker->level);
@@ -165,6 +166,14 @@ walk:
 			pte |= PT_ACCESSED_MASK;
 		}
 
+		pte_access = pte & (PT_WRITABLE_MASK | PT_USER_MASK);
+		pte_access |= ACC_EXEC_MASK;
+#if PTTYPE == 64
+		if (is_nx(vcpu))
+			pte_access &= ~(pte >> PT64_NX_SHIFT);
+#endif
+		pte_access &= pt_access;
+
 		if (walker->level == PT_PAGE_TABLE_LEVEL) {
 			walker->gfn = gpte_to_gfn(pte);
 			break;
@@ -180,7 +189,7 @@ walk:
 			break;
 		}
 
-		walker->inherited_ar &= pte;
+		pt_access = pte_access;
 		--walker->level;
 	}
 
@@ -197,7 +206,10 @@ walk:
 	}
 
 	walker->pte = pte;
-	pgprintk("%s: pte %llx\n", __FUNCTION__, (u64)pte);
+	walker->pt_access = pt_access;
+	walker->pte_access = pte_access;
+	pgprintk("%s: pte %llx pte_access %x pt_access %x\n",
+		 __FUNCTION__, (u64)pte, pt_access, pte_access);
 	return 1;
 
 not_present:
@@ -218,7 +230,8 @@ err:
 }
 
 static void FNAME(set_pte)(struct kvm_vcpu *vcpu, pt_element_t gpte,
-			   u64 *shadow_pte, u64 access_bits,
+			   u64 *shadow_pte, unsigned pt_access,
+			   unsigned pte_access,
 			   int user_fault, int write_fault,
 			   int *ptwrite, struct guest_walker *walker,
 			   gfn_t gfn)
@@ -228,12 +241,11 @@ static void FNAME(set_pte)(struct kvm_vcpu *vcpu, pt_element_t gpte,
 	int was_rmapped = is_rmap_pte(*shadow_pte);
 	struct page *page;
 
-	pgprintk("%s: spte %llx gpte %llx access %llx write_fault %d"
+	pgprintk("%s: spte %llx gpte %llx access %x write_fault %d"
 		 " user_fault %d gfn %lx\n",
-		 __FUNCTION__, *shadow_pte, (u64)gpte, access_bits,
+		 __FUNCTION__, *shadow_pte, (u64)gpte, pt_access,
 		 write_fault, user_fault, gfn);
 
-	access_bits &= gpte;
 	/*
 	 * We don't set the accessed bit, since we sometimes want to see
 	 * whether the guest actually used the pte (in order to detect
@@ -242,12 +254,12 @@ static void FNAME(set_pte)(struct kvm_vcpu *vcpu, pt_element_t gpte,
 	spte = PT_PRESENT_MASK | PT_DIRTY_MASK;
 	spte |= gpte & PT64_NX_MASK;
 	if (!dirty)
-		access_bits &= ~PT_WRITABLE_MASK;
+		pte_access &= ~ACC_WRITE_MASK;
 
 	page = gfn_to_page(vcpu->kvm, gfn);
 
 	spte |= PT_PRESENT_MASK;
-	if (access_bits & PT_USER_MASK)
+	if (pte_access & ACC_USER_MASK)
 		spte |= PT_USER_MASK;
 
 	if (is_error_page(page)) {
@@ -259,7 +271,7 @@ static void FNAME(set_pte)(struct kvm_vcpu *vcpu, pt_element_t gpte,
 
 	spte |= page_to_phys(page);
 
-	if ((access_bits & PT_WRITABLE_MASK)
+	if ((pte_access & ACC_WRITE_MASK)
 	    || (write_fault && !is_write_protection(vcpu) && !user_fault)) {
 		struct kvm_mmu_page *shadow;
 
@@ -273,7 +285,7 @@ static void FNAME(set_pte)(struct kvm_vcpu *vcpu, pt_element_t gpte,
 		if (shadow) {
 			pgprintk("%s: found shadow page for %lx, marking ro\n",
 				 __FUNCTION__, gfn);
-			access_bits &= ~PT_WRITABLE_MASK;
+			pte_access &= ~ACC_WRITE_MASK;
 			if (is_writeble_pte(spte)) {
 				spte &= ~PT_WRITABLE_MASK;
 				kvm_x86_ops->tlb_flush(vcpu);
@@ -285,7 +297,7 @@ static void FNAME(set_pte)(struct kvm_vcpu *vcpu, pt_element_t gpte,
 
 unshadowed:
 
-	if (access_bits & PT_WRITABLE_MASK)
+	if (pte_access & ACC_WRITE_MASK)
 		mark_page_dirty(vcpu->kvm, gfn);
 
 	pgprintk("%s: setting spte %llx\n", __FUNCTION__, spte);
@@ -317,8 +329,8 @@ static void FNAME(update_pte)(struct kvm_vcpu *vcpu, struct kvm_mmu_page *page,
 	if (bytes < sizeof(pt_element_t))
 		return;
 	pgprintk("%s: gpte %llx spte %p\n", __FUNCTION__, (u64)gpte, spte);
-	FNAME(set_pte)(vcpu, gpte, spte, PT_USER_MASK | PT_WRITABLE_MASK, 0,
-		       0, NULL, NULL, gpte_to_gfn(gpte));
+	FNAME(set_pte)(vcpu, gpte, spte, ACC_ALL, ACC_ALL,
+		       0, 0, NULL, NULL, gpte_to_gfn(gpte));
 }
 
 /*
@@ -331,6 +343,7 @@ static u64 *FNAME(fetch)(struct kvm_vcpu *vcpu, gva_t addr,
 	hpa_t shadow_addr;
 	int level;
 	u64 *shadow_ent;
+	unsigned access = walker->pt_access;
 
 	if (!is_present_pte(walker->pte))
 		return NULL;
@@ -349,7 +362,6 @@ static u64 *FNAME(fetch)(struct kvm_vcpu *vcpu, gva_t addr,
 		u64 shadow_pte;
 		int metaphysical;
 		gfn_t table_gfn;
-		unsigned hugepage_access = 0;
 
 		shadow_ent = ((u64 *)__va(shadow_addr)) + index;
 		if (is_shadow_present_pte(*shadow_ent)) {
@@ -365,20 +377,15 @@ static u64 *FNAME(fetch)(struct kvm_vcpu *vcpu, gva_t addr,
 		if (level - 1 == PT_PAGE_TABLE_LEVEL
 		    && walker->level == PT_DIRECTORY_LEVEL) {
 			metaphysical = 1;
-			hugepage_access = walker->pte;
-			hugepage_access &= PT_USER_MASK | PT_WRITABLE_MASK;
 			if (!is_dirty_pte(walker->pte))
-				hugepage_access &= ~PT_WRITABLE_MASK;
-			hugepage_access >>= PT_WRITABLE_SHIFT;
-			if (walker->pte & PT64_NX_MASK)
-				hugepage_access |= (1 << 2);
+				access &= ~ACC_WRITE_MASK;
 			table_gfn = gpte_to_gfn(walker->pte);
 		} else {
 			metaphysical = 0;
 			table_gfn = walker->table_gfn[level - 2];
 		}
 		shadow_page = kvm_mmu_get_page(vcpu, table_gfn, addr, level-1,
-					       metaphysical, hugepage_access,
+					       metaphysical, access,
 					       shadow_ent);
 		shadow_addr = __pa(shadow_page->spt);
 		shadow_pte = shadow_addr | PT_PRESENT_MASK | PT_ACCESSED_MASK
@@ -387,7 +394,8 @@ static u64 *FNAME(fetch)(struct kvm_vcpu *vcpu, gva_t addr,
 	}
 
 	FNAME(set_pte)(vcpu, walker->pte, shadow_ent,
-		       walker->inherited_ar, user_fault, write_fault,
+		       access, walker->pte_access & access,
+		       user_fault, write_fault,
 		       ptwrite, walker, walker->gfn);
 
 	return shadow_ent;
-- 
1.5.3.7

