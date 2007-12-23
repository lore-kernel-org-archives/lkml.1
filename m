Return-Path: <linux-kernel-owner+w=401wt.eu-S1760192AbXLWPH7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760192AbXLWPH7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Dec 2007 10:07:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756184AbXLWOwe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Dec 2007 09:52:34 -0500
Received: from il.qumranet.com ([82.166.9.18]:35922 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755042AbXLWOvr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Dec 2007 09:51:47 -0500
From: Avi Kivity <avi@qumranet.com>
To: linux-kernel@vger.kernel.org, kvm-devel@lists.sourceforge.net
Subject: [PATCH 43/50] KVM: MMU: Simplify page table walker
Date: Sun, 23 Dec 2007 16:51:28 +0200
Message-Id: <1198421495-31481-44-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.3.7
In-Reply-To: <1198421495-31481-1-git-send-email-avi@qumranet.com>
References: <1198421495-31481-1-git-send-email-avi@qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Simplify the walker level loop not to carry so much information from one
loop to the next.  In addition to being complex, this made kmap_atomic()
critical sections difficult to manage.

As a result of this change, kmap_atomic() sections are limited to actually
touching the guest pte, which allows the other functions called from the
walker to do sleepy operations.  This will happen when we enable swapping.

Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 drivers/kvm/paging_tmpl.h |  124 +++++++++++++++++---------------------------
 1 files changed, 48 insertions(+), 76 deletions(-)

diff --git a/drivers/kvm/paging_tmpl.h b/drivers/kvm/paging_tmpl.h
index a9e687b..bab1b7f 100644
--- a/drivers/kvm/paging_tmpl.h
+++ b/drivers/kvm/paging_tmpl.h
@@ -59,32 +59,12 @@
 struct guest_walker {
 	int level;
 	gfn_t table_gfn[PT_MAX_FULL_LEVELS];
-	pt_element_t *table;
 	pt_element_t pte;
-	pt_element_t *ptep;
-	struct page *page;
-	int index;
 	pt_element_t inherited_ar;
 	gfn_t gfn;
 	u32 error_code;
 };
 
-static void FNAME(update_dirty_bit)(struct kvm_vcpu *vcpu,
-				    int write_fault,
-				    pt_element_t *ptep,
-				    gfn_t table_gfn)
-{
-	gpa_t pte_gpa;
-
-	if (write_fault && !is_dirty_pte(*ptep)) {
-		mark_page_dirty(vcpu->kvm, table_gfn);
-		*ptep |= PT_DIRTY_MASK;
-		pte_gpa = ((gpa_t)table_gfn << PAGE_SHIFT);
-		pte_gpa += offset_in_page(ptep);
-		kvm_mmu_pte_write(vcpu, pte_gpa, (u8 *)ptep, sizeof(*ptep));
-	}
-}
-
 /*
  * Fetch a guest pte for a guest virtual address
  */
@@ -94,105 +74,99 @@ static int FNAME(walk_addr)(struct guest_walker *walker,
 {
 	hpa_t hpa;
 	struct kvm_memory_slot *slot;
-	pt_element_t *ptep;
-	pt_element_t root;
+	struct page *page;
+	pt_element_t *table;
+	pt_element_t pte;
 	gfn_t table_gfn;
+	unsigned index;
+	gpa_t pte_gpa;
 
 	pgprintk("%s: addr %lx\n", __FUNCTION__, addr);
 	walker->level = vcpu->mmu.root_level;
-	walker->table = NULL;
-	walker->page = NULL;
-	walker->ptep = NULL;
-	root = vcpu->cr3;
+	pte = vcpu->cr3;
 #if PTTYPE == 64
 	if (!is_long_mode(vcpu)) {
-		walker->ptep = &vcpu->pdptrs[(addr >> 30) & 3];
-		root = *walker->ptep;
-		walker->pte = root;
-		if (!(root & PT_PRESENT_MASK))
+		pte = vcpu->pdptrs[(addr >> 30) & 3];
+		if (!is_present_pte(pte))
 			goto not_present;
 		--walker->level;
 	}
 #endif
-	table_gfn = (root & PT64_BASE_ADDR_MASK) >> PAGE_SHIFT;
-	walker->table_gfn[walker->level - 1] = table_gfn;
-	pgprintk("%s: table_gfn[%d] %lx\n", __FUNCTION__,
-		 walker->level - 1, table_gfn);
-	slot = gfn_to_memslot(vcpu->kvm, table_gfn);
-	hpa = safe_gpa_to_hpa(vcpu->kvm, root & PT64_BASE_ADDR_MASK);
-	walker->page = pfn_to_page(hpa >> PAGE_SHIFT);
-	walker->table = kmap_atomic(walker->page, KM_USER0);
-
 	ASSERT((!is_long_mode(vcpu) && is_pae(vcpu)) ||
 	       (vcpu->cr3 & CR3_NONPAE_RESERVED_BITS) == 0);
 
 	walker->inherited_ar = PT_USER_MASK | PT_WRITABLE_MASK;
 
 	for (;;) {
-		int index = PT_INDEX(addr, walker->level);
-		hpa_t paddr;
+		index = PT_INDEX(addr, walker->level);
 
-		ptep = &walker->table[index];
-		walker->index = index;
-		ASSERT(((unsigned long)walker->table & PAGE_MASK) ==
-		       ((unsigned long)ptep & PAGE_MASK));
+		table_gfn = (pte & PT64_BASE_ADDR_MASK) >> PAGE_SHIFT;
+		walker->table_gfn[walker->level - 1] = table_gfn;
+		pgprintk("%s: table_gfn[%d] %lx\n", __FUNCTION__,
+			 walker->level - 1, table_gfn);
+
+		slot = gfn_to_memslot(vcpu->kvm, table_gfn);
+		hpa = safe_gpa_to_hpa(vcpu->kvm, pte & PT64_BASE_ADDR_MASK);
+		page = pfn_to_page(hpa >> PAGE_SHIFT);
 
-		if (!is_present_pte(*ptep))
+		table = kmap_atomic(page, KM_USER0);
+		pte = table[index];
+		kunmap_atomic(table, KM_USER0);
+
+		if (!is_present_pte(pte))
 			goto not_present;
 
-		if (write_fault && !is_writeble_pte(*ptep))
+		if (write_fault && !is_writeble_pte(pte))
 			if (user_fault || is_write_protection(vcpu))
 				goto access_error;
 
-		if (user_fault && !(*ptep & PT_USER_MASK))
+		if (user_fault && !(pte & PT_USER_MASK))
 			goto access_error;
 
 #if PTTYPE == 64
-		if (fetch_fault && is_nx(vcpu) && (*ptep & PT64_NX_MASK))
+		if (fetch_fault && is_nx(vcpu) && (pte & PT64_NX_MASK))
 			goto access_error;
 #endif
 
-		if (!(*ptep & PT_ACCESSED_MASK)) {
+		if (!(pte & PT_ACCESSED_MASK)) {
 			mark_page_dirty(vcpu->kvm, table_gfn);
-			*ptep |= PT_ACCESSED_MASK;
+			pte |= PT_ACCESSED_MASK;
+			table = kmap_atomic(page, KM_USER0);
+			table[index] = pte;
+			kunmap_atomic(table, KM_USER0);
 		}
 
 		if (walker->level == PT_PAGE_TABLE_LEVEL) {
-			walker->gfn = (*ptep & PT_BASE_ADDR_MASK)
-				>> PAGE_SHIFT;
-			FNAME(update_dirty_bit)(vcpu, write_fault, ptep,
-						table_gfn);
+			walker->gfn = (pte & PT_BASE_ADDR_MASK) >> PAGE_SHIFT;
 			break;
 		}
 
 		if (walker->level == PT_DIRECTORY_LEVEL
-		    && (*ptep & PT_PAGE_SIZE_MASK)
+		    && (pte & PT_PAGE_SIZE_MASK)
 		    && (PTTYPE == 64 || is_pse(vcpu))) {
-			walker->gfn = (*ptep & PT_DIR_BASE_ADDR_MASK)
+			walker->gfn = (pte & PT_DIR_BASE_ADDR_MASK)
 				>> PAGE_SHIFT;
 			walker->gfn += PT_INDEX(addr, PT_PAGE_TABLE_LEVEL);
-			FNAME(update_dirty_bit)(vcpu, write_fault, ptep,
-						table_gfn);
 			break;
 		}
 
-		walker->inherited_ar &= walker->table[index];
-		table_gfn = (*ptep & PT_BASE_ADDR_MASK) >> PAGE_SHIFT;
-		kunmap_atomic(walker->table, KM_USER0);
-		paddr = safe_gpa_to_hpa(vcpu->kvm, table_gfn << PAGE_SHIFT);
-		walker->page = pfn_to_page(paddr >> PAGE_SHIFT);
-		walker->table = kmap_atomic(walker->page, KM_USER0);
+		walker->inherited_ar &= pte;
 		--walker->level;
-		walker->table_gfn[walker->level - 1] = table_gfn;
-		pgprintk("%s: table_gfn[%d] %lx\n", __FUNCTION__,
-			 walker->level - 1, table_gfn);
 	}
-	walker->pte = *ptep;
-	if (walker->page)
-		walker->ptep = NULL;
-	if (walker->table)
-		kunmap_atomic(walker->table, KM_USER0);
-	pgprintk("%s: pte %llx\n", __FUNCTION__, (u64)*ptep);
+
+	if (write_fault && !is_dirty_pte(pte)) {
+		mark_page_dirty(vcpu->kvm, table_gfn);
+		pte |= PT_DIRTY_MASK;
+		table = kmap_atomic(page, KM_USER0);
+		table[index] = pte;
+		kunmap_atomic(table, KM_USER0);
+		pte_gpa = table_gfn << PAGE_SHIFT;
+		pte_gpa += index * sizeof(pt_element_t);
+		kvm_mmu_pte_write(vcpu, pte_gpa, (u8 *)&pte, sizeof(pte));
+	}
+
+	walker->pte = pte;
+	pgprintk("%s: pte %llx\n", __FUNCTION__, (u64)pte);
 	return 1;
 
 not_present:
@@ -209,8 +183,6 @@ err:
 		walker->error_code |= PFERR_USER_MASK;
 	if (fetch_fault)
 		walker->error_code |= PFERR_FETCH_MASK;
-	if (walker->table)
-		kunmap_atomic(walker->table, KM_USER0);
 	return 0;
 }
 
-- 
1.5.3.7

