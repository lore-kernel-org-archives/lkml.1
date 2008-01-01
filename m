Return-Path: <linux-kernel-owner+w=401wt.eu-S1755162AbYAAPvb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755162AbYAAPvb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jan 2008 10:51:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754612AbYAAPhD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Jan 2008 10:37:03 -0500
Received: from il.qumranet.com ([82.166.9.18]:33806 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754154AbYAAPgd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jan 2008 10:36:33 -0500
From: Avi Kivity <avi@qumranet.com>
To: linux-kernel@vger.kernel.org, kvm-devel@lists.sourceforge.net
Cc: Marcelo Tosatti <marcelo@kvack.org>
Subject: [PATCH 53/54] KVM: MMU: Fix SMP shadow instantiation race
Date: Tue,  1 Jan 2008 17:36:19 +0200
Message-Id: <1199201780-14001-54-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.3.7
In-Reply-To: <1199201780-14001-1-git-send-email-avi@qumranet.com>
References: <1199201780-14001-1-git-send-email-avi@qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Marcelo Tosatti <marcelo@kvack.org>

There is a race where VCPU0 is shadowing a pagetable entry while VCPU1
is updating it, which results in a stale shadow copy.

Fix that by comparing the contents of the cached guest pte with the
current guest pte after write-protecting the guest pagetable.

Signed-off-by: Marcelo Tosatti <mtosatti@redhat.com>
Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 drivers/kvm/mmu.c         |   12 ++++++++----
 drivers/kvm/paging_tmpl.h |   29 +++++++++++++++++++++--------
 2 files changed, 29 insertions(+), 12 deletions(-)

diff --git a/drivers/kvm/mmu.c b/drivers/kvm/mmu.c
index ba71e8d..92ac0d1 100644
--- a/drivers/kvm/mmu.c
+++ b/drivers/kvm/mmu.c
@@ -681,7 +681,8 @@ static struct kvm_mmu_page *kvm_mmu_get_page(struct kvm_vcpu *vcpu,
 					     unsigned level,
 					     int metaphysical,
 					     unsigned access,
-					     u64 *parent_pte)
+					     u64 *parent_pte,
+					     bool *new_page)
 {
 	union kvm_mmu_page_role role;
 	unsigned index;
@@ -720,6 +721,8 @@ static struct kvm_mmu_page *kvm_mmu_get_page(struct kvm_vcpu *vcpu,
 	vcpu->mmu.prefetch_page(vcpu, sp);
 	if (!metaphysical)
 		rmap_write_protect(vcpu->kvm, gfn);
+	if (new_page)
+		*new_page = 1;
 	return sp;
 }
 
@@ -993,7 +996,8 @@ static int nonpaging_map(struct kvm_vcpu *vcpu, gva_t v, int write, gfn_t gfn)
 				>> PAGE_SHIFT;
 			new_table = kvm_mmu_get_page(vcpu, pseudo_gfn,
 						     v, level - 1,
-						     1, ACC_ALL, &table[index]);
+						     1, ACC_ALL, &table[index],
+						     NULL);
 			if (!new_table) {
 				pgprintk("nonpaging_map: ENOMEM\n");
 				return -ENOMEM;
@@ -1059,7 +1063,7 @@ static void mmu_alloc_roots(struct kvm_vcpu *vcpu)
 
 		ASSERT(!VALID_PAGE(root));
 		sp = kvm_mmu_get_page(vcpu, root_gfn, 0,
-				      PT64_ROOT_LEVEL, 0, ACC_ALL, NULL);
+				      PT64_ROOT_LEVEL, 0, ACC_ALL, NULL, NULL);
 		root = __pa(sp->spt);
 		++sp->root_count;
 		vcpu->mmu.root_hpa = root;
@@ -1080,7 +1084,7 @@ static void mmu_alloc_roots(struct kvm_vcpu *vcpu)
 			root_gfn = 0;
 		sp = kvm_mmu_get_page(vcpu, root_gfn, i << 30,
 				      PT32_ROOT_LEVEL, !is_paging(vcpu),
-				      ACC_ALL, NULL);
+				      ACC_ALL, NULL, NULL);
 		root = __pa(sp->spt);
 		++sp->root_count;
 		vcpu->mmu.pae_root[i] = root | PT_PRESENT_MASK;
diff --git a/drivers/kvm/paging_tmpl.h b/drivers/kvm/paging_tmpl.h
index 3ab3fb6..fb19596 100644
--- a/drivers/kvm/paging_tmpl.h
+++ b/drivers/kvm/paging_tmpl.h
@@ -65,7 +65,8 @@
 struct guest_walker {
 	int level;
 	gfn_t table_gfn[PT_MAX_FULL_LEVELS];
-	pt_element_t pte;
+	pt_element_t ptes[PT_MAX_FULL_LEVELS];
+	gpa_t pte_gpa[PT_MAX_FULL_LEVELS];
 	unsigned pt_access;
 	unsigned pte_access;
 	gfn_t gfn;
@@ -150,6 +151,7 @@ walk:
 		pte_gpa = gfn_to_gpa(table_gfn);
 		pte_gpa += index * sizeof(pt_element_t);
 		walker->table_gfn[walker->level - 1] = table_gfn;
+		walker->pte_gpa[walker->level - 1] = pte_gpa;
 		pgprintk("%s: table_gfn[%d] %lx\n", __FUNCTION__,
 			 walker->level - 1, table_gfn);
 
@@ -180,6 +182,8 @@ walk:
 
 		pte_access = pt_access & FNAME(gpte_access)(vcpu, pte);
 
+		walker->ptes[walker->level - 1] = pte;
+
 		if (walker->level == PT_PAGE_TABLE_LEVEL) {
 			walker->gfn = gpte_to_gfn(pte);
 			break;
@@ -209,9 +213,9 @@ walk:
 			goto walk;
 		pte |= PT_DIRTY_MASK;
 		kvm_mmu_pte_write(vcpu, pte_gpa, (u8 *)&pte, sizeof(pte));
+		walker->ptes[walker->level - 1] = pte;
 	}
 
-	walker->pte = pte;
 	walker->pt_access = pt_access;
 	walker->pte_access = pte_access;
 	pgprintk("%s: pte %llx pte_access %x pt_access %x\n",
@@ -268,7 +272,7 @@ static u64 *FNAME(fetch)(struct kvm_vcpu *vcpu, gva_t addr,
 	u64 *shadow_ent;
 	unsigned access = walker->pt_access;
 
-	if (!is_present_pte(walker->pte))
+	if (!is_present_pte(walker->ptes[walker->level - 1]))
 		return NULL;
 
 	shadow_addr = vcpu->mmu.root_hpa;
@@ -285,6 +289,7 @@ static u64 *FNAME(fetch)(struct kvm_vcpu *vcpu, gva_t addr,
 		u64 shadow_pte;
 		int metaphysical;
 		gfn_t table_gfn;
+		bool new_page = 0;
 
 		shadow_ent = ((u64 *)__va(shadow_addr)) + index;
 		if (is_shadow_present_pte(*shadow_ent)) {
@@ -300,16 +305,23 @@ static u64 *FNAME(fetch)(struct kvm_vcpu *vcpu, gva_t addr,
 		if (level - 1 == PT_PAGE_TABLE_LEVEL
 		    && walker->level == PT_DIRECTORY_LEVEL) {
 			metaphysical = 1;
-			if (!is_dirty_pte(walker->pte))
+			if (!is_dirty_pte(walker->ptes[level - 1]))
 				access &= ~ACC_WRITE_MASK;
-			table_gfn = gpte_to_gfn(walker->pte);
+			table_gfn = gpte_to_gfn(walker->ptes[level - 1]);
 		} else {
 			metaphysical = 0;
 			table_gfn = walker->table_gfn[level - 2];
 		}
 		shadow_page = kvm_mmu_get_page(vcpu, table_gfn, addr, level-1,
 					       metaphysical, access,
-					       shadow_ent);
+					       shadow_ent, &new_page);
+		if (new_page && !metaphysical) {
+			pt_element_t curr_pte;
+			kvm_read_guest(vcpu->kvm, walker->pte_gpa[level - 2],
+				       &curr_pte, sizeof(curr_pte));
+			if (curr_pte != walker->ptes[level - 2])
+				return NULL;
+		}
 		shadow_addr = __pa(shadow_page->spt);
 		shadow_pte = shadow_addr | PT_PRESENT_MASK | PT_ACCESSED_MASK
 			| PT_WRITABLE_MASK | PT_USER_MASK;
@@ -317,7 +329,8 @@ static u64 *FNAME(fetch)(struct kvm_vcpu *vcpu, gva_t addr,
 	}
 
 	mmu_set_spte(vcpu, shadow_ent, access, walker->pte_access & access,
-		     user_fault, write_fault, walker->pte & PT_DIRTY_MASK,
+		     user_fault, write_fault,
+		     walker->ptes[walker->level-1] & PT_DIRTY_MASK,
 		     ptwrite, walker->gfn);
 
 	return shadow_ent;
@@ -382,7 +395,7 @@ static int FNAME(page_fault)(struct kvm_vcpu *vcpu, gva_t addr,
 	/*
 	 * mmio: emulate if accessible, otherwise its a guest fault.
 	 */
-	if (is_io_pte(*shadow_pte))
+	if (shadow_pte && is_io_pte(*shadow_pte))
 		return 1;
 
 	++vcpu->stat.pf_fixed;
-- 
1.5.3.7

