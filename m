Return-Path: <linux-kernel-owner+w=401wt.eu-S1760383AbXFQJuk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760383AbXFQJuk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Jun 2007 05:50:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759560AbXFQJoy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Jun 2007 05:44:54 -0400
Received: from il.qumranet.com ([82.166.9.18]:55166 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758390AbXFQJoo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Jun 2007 05:44:44 -0400
From: Avi Kivity <avi@qumranet.com>
To: kvm-devel@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org, Avi Kivity <avi@qumranet.com>
Subject: [PATCH 19/58] KVM: MMU: Store shadow page tables as kernel virtual addresses, not physical
Date: Sun, 17 Jun 2007 12:44:00 +0300
Message-Id: <11820734803871-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.0.6
In-Reply-To: <1182073479890-git-send-email-avi@qumranet.com>
References: <1182073479890-git-send-email-avi@qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Simpifies things a bit.

Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 drivers/kvm/kvm.h         |    2 +-
 drivers/kvm/mmu.c         |   32 +++++++++++++++-----------------
 drivers/kvm/paging_tmpl.h |    2 +-
 3 files changed, 17 insertions(+), 19 deletions(-)

diff --git a/drivers/kvm/kvm.h b/drivers/kvm/kvm.h
index 5e6dac5..fc4a6c1 100644
--- a/drivers/kvm/kvm.h
+++ b/drivers/kvm/kvm.h
@@ -139,7 +139,7 @@ struct kvm_mmu_page {
 	gfn_t gfn;
 	union kvm_mmu_page_role role;
 
-	hpa_t page_hpa;
+	u64 *spt;
 	unsigned long slot_bitmap; /* One bit set per slot which has memory
 				    * in this shadow page.
 				    */
diff --git a/drivers/kvm/mmu.c b/drivers/kvm/mmu.c
index a96c9ae..c85c664 100644
--- a/drivers/kvm/mmu.c
+++ b/drivers/kvm/mmu.c
@@ -439,13 +439,12 @@ static void rmap_write_protect(struct kvm_vcpu *vcpu, u64 gfn)
 }
 
 #ifdef MMU_DEBUG
-static int is_empty_shadow_page(hpa_t page_hpa)
+static int is_empty_shadow_page(u64 *spt)
 {
 	u64 *pos;
 	u64 *end;
 
-	for (pos = __va(page_hpa), end = pos + PAGE_SIZE / sizeof(u64);
-		      pos != end; pos++)
+	for (pos = spt, end = pos + PAGE_SIZE / sizeof(u64); pos != end; pos++)
 		if (*pos != 0) {
 			printk(KERN_ERR "%s: %p %llx\n", __FUNCTION__,
 			       pos, *pos);
@@ -458,7 +457,7 @@ static int is_empty_shadow_page(hpa_t page_hpa)
 static void kvm_mmu_free_page(struct kvm_vcpu *vcpu,
 			      struct kvm_mmu_page *page_head)
 {
-	ASSERT(is_empty_shadow_page(page_head->page_hpa));
+	ASSERT(is_empty_shadow_page(page_head->spt));
 	list_move(&page_head->link, &vcpu->free_pages);
 	++vcpu->kvm->n_free_mmu_pages;
 }
@@ -478,7 +477,7 @@ static struct kvm_mmu_page *kvm_mmu_alloc_page(struct kvm_vcpu *vcpu,
 
 	page = list_entry(vcpu->free_pages.next, struct kvm_mmu_page, link);
 	list_move(&page->link, &vcpu->kvm->active_mmu_pages);
-	ASSERT(is_empty_shadow_page(page->page_hpa));
+	ASSERT(is_empty_shadow_page(page->spt));
 	page->slot_bitmap = 0;
 	page->multimapped = 0;
 	page->parent_pte = parent_pte;
@@ -636,7 +635,7 @@ static void kvm_mmu_page_unlink_children(struct kvm_vcpu *vcpu,
 	u64 *pt;
 	u64 ent;
 
-	pt = __va(page->page_hpa);
+	pt = page->spt;
 
 	if (page->role.level == PT_PAGE_TABLE_LEVEL) {
 		for (i = 0; i < PT64_ENT_PER_PAGE; ++i) {
@@ -803,7 +802,7 @@ static int nonpaging_map(struct kvm_vcpu *vcpu, gva_t v, hpa_t p)
 				return -ENOMEM;
 			}
 
-			table[index] = new_table->page_hpa | PT_PRESENT_MASK
+			table[index] = __pa(new_table->spt) | PT_PRESENT_MASK
 				| PT_WRITABLE_MASK | PT_USER_MASK;
 		}
 		table_addr = table[index] & PT64_BASE_ADDR_MASK;
@@ -855,7 +854,7 @@ static void mmu_alloc_roots(struct kvm_vcpu *vcpu)
 		ASSERT(!VALID_PAGE(root));
 		page = kvm_mmu_get_page(vcpu, root_gfn, 0,
 					PT64_ROOT_LEVEL, 0, 0, NULL);
-		root = page->page_hpa;
+		root = __pa(page->spt);
 		++page->root_count;
 		vcpu->mmu.root_hpa = root;
 		return;
@@ -876,7 +875,7 @@ static void mmu_alloc_roots(struct kvm_vcpu *vcpu)
 		page = kvm_mmu_get_page(vcpu, root_gfn, i << 30,
 					PT32_ROOT_LEVEL, !is_paging(vcpu),
 					0, NULL);
-		root = page->page_hpa;
+		root = __pa(page->spt);
 		++page->root_count;
 		vcpu->mmu.pae_root[i] = root | PT_PRESENT_MASK;
 	}
@@ -1220,8 +1219,7 @@ void kvm_mmu_pte_write(struct kvm_vcpu *vcpu, gpa_t gpa,
 			if (quadrant != page->role.quadrant)
 				continue;
 		}
-		spte = __va(page->page_hpa);
-		spte += page_offset / sizeof(*spte);
+		spte = &page->spt[page_offset / sizeof(*spte)];
 		while (npte--) {
 			mmu_pte_write_zap_pte(vcpu, page, spte);
 			mmu_pte_write_new_pte(vcpu, page, spte, new, bytes);
@@ -1262,8 +1260,8 @@ static void free_mmu_pages(struct kvm_vcpu *vcpu)
 		page = list_entry(vcpu->free_pages.next,
 				  struct kvm_mmu_page, link);
 		list_del(&page->link);
-		__free_page(pfn_to_page(page->page_hpa >> PAGE_SHIFT));
-		page->page_hpa = INVALID_PAGE;
+		free_page((unsigned long)page->spt);
+		page->spt = NULL;
 	}
 	free_page((unsigned long)vcpu->mmu.pae_root);
 }
@@ -1282,8 +1280,8 @@ static int alloc_mmu_pages(struct kvm_vcpu *vcpu)
 		if ((page = alloc_page(GFP_KERNEL)) == NULL)
 			goto error_1;
 		set_page_private(page, (unsigned long)page_header);
-		page_header->page_hpa = (hpa_t)page_to_pfn(page) << PAGE_SHIFT;
-		memset(__va(page_header->page_hpa), 0, PAGE_SIZE);
+		page_header->spt = page_address(page);
+		memset(page_header->spt, 0, PAGE_SIZE);
 		list_add(&page_header->link, &vcpu->free_pages);
 		++vcpu->kvm->n_free_mmu_pages;
 	}
@@ -1346,7 +1344,7 @@ void kvm_mmu_slot_remove_write_access(struct kvm_vcpu *vcpu, int slot)
 		if (!test_bit(slot, &page->slot_bitmap))
 			continue;
 
-		pt = __va(page->page_hpa);
+		pt = page->spt;
 		for (i = 0; i < PT64_ENT_PER_PAGE; ++i)
 			/* avoid RMW */
 			if (pt[i] & PT_WRITABLE_MASK) {
@@ -1497,7 +1495,7 @@ static int count_writable_mappings(struct kvm_vcpu *vcpu)
 	int i;
 
 	list_for_each_entry(page, &vcpu->kvm->active_mmu_pages, link) {
-		u64 *pt = __va(page->page_hpa);
+		u64 *pt = page->spt;
 
 		if (page->role.level != PT_PAGE_TABLE_LEVEL)
 			continue;
diff --git a/drivers/kvm/paging_tmpl.h b/drivers/kvm/paging_tmpl.h
index 10ba0a8..6dd0da9 100644
--- a/drivers/kvm/paging_tmpl.h
+++ b/drivers/kvm/paging_tmpl.h
@@ -304,7 +304,7 @@ static u64 *FNAME(fetch)(struct kvm_vcpu *vcpu, gva_t addr,
 		shadow_page = kvm_mmu_get_page(vcpu, table_gfn, addr, level-1,
 					       metaphysical, hugepage_access,
 					       shadow_ent);
-		shadow_addr = shadow_page->page_hpa;
+		shadow_addr = __pa(shadow_page->spt);
 		shadow_pte = shadow_addr | PT_PRESENT_MASK | PT_ACCESSED_MASK
 			| PT_WRITABLE_MASK | PT_USER_MASK;
 		*shadow_ent = shadow_pte;
-- 
1.5.0.6

