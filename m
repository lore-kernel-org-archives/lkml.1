Return-Path: <linux-kernel-owner+w=401wt.eu-S1755922AbYAAPh7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755922AbYAAPh7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jan 2008 10:37:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754411AbYAAPg1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Jan 2008 10:36:27 -0500
Received: from il.qumranet.com ([82.166.9.18]:33763 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753500AbYAAPgX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jan 2008 10:36:23 -0500
From: Avi Kivity <avi@qumranet.com>
To: linux-kernel@vger.kernel.org, kvm-devel@lists.sourceforge.net
Subject: [PATCH 03/54] KVM: MMU: Rename variables of type 'struct kvm_mmu_page *'
Date: Tue,  1 Jan 2008 17:35:29 +0200
Message-Id: <1199201780-14001-4-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.3.7
In-Reply-To: <1199201780-14001-1-git-send-email-avi@qumranet.com>
References: <1199201780-14001-1-git-send-email-avi@qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These are traditionally named 'page', but even more traditionally, that name
is reserved for variables that point to a 'struct page'.  Rename them to 'sp'
(for "shadow page").

Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 drivers/kvm/mmu.c |  300 ++++++++++++++++++++++++++---------------------------
 1 files changed, 146 insertions(+), 154 deletions(-)

diff --git a/drivers/kvm/mmu.c b/drivers/kvm/mmu.c
index 9b75b10..86896da 100644
--- a/drivers/kvm/mmu.c
+++ b/drivers/kvm/mmu.c
@@ -367,7 +367,7 @@ static unsigned long *gfn_to_rmap(struct kvm *kvm, gfn_t gfn)
  */
 static void rmap_add(struct kvm_vcpu *vcpu, u64 *spte, gfn_t gfn)
 {
-	struct kvm_mmu_page *page;
+	struct kvm_mmu_page *sp;
 	struct kvm_rmap_desc *desc;
 	unsigned long *rmapp;
 	int i;
@@ -375,8 +375,8 @@ static void rmap_add(struct kvm_vcpu *vcpu, u64 *spte, gfn_t gfn)
 	if (!is_rmap_pte(*spte))
 		return;
 	gfn = unalias_gfn(vcpu->kvm, gfn);
-	page = page_header(__pa(spte));
-	page->gfns[spte - page->spt] = gfn;
+	sp = page_header(__pa(spte));
+	sp->gfns[spte - sp->spt] = gfn;
 	rmapp = gfn_to_rmap(vcpu->kvm, gfn);
 	if (!*rmapp) {
 		rmap_printk("rmap_add: %p %llx 0->1\n", spte, *spte);
@@ -429,20 +429,20 @@ static void rmap_remove(struct kvm *kvm, u64 *spte)
 {
 	struct kvm_rmap_desc *desc;
 	struct kvm_rmap_desc *prev_desc;
-	struct kvm_mmu_page *page;
+	struct kvm_mmu_page *sp;
 	struct page *release_page;
 	unsigned long *rmapp;
 	int i;
 
 	if (!is_rmap_pte(*spte))
 		return;
-	page = page_header(__pa(spte));
+	sp = page_header(__pa(spte));
 	release_page = pfn_to_page((*spte & PT64_BASE_ADDR_MASK) >> PAGE_SHIFT);
 	if (is_writeble_pte(*spte))
 		kvm_release_page_dirty(release_page);
 	else
 		kvm_release_page_clean(release_page);
-	rmapp = gfn_to_rmap(kvm, page->gfns[spte - page->spt]);
+	rmapp = gfn_to_rmap(kvm, sp->gfns[spte - sp->spt]);
 	if (!*rmapp) {
 		printk(KERN_ERR "rmap_remove: %p %llx 0->BUG\n", spte, *spte);
 		BUG();
@@ -537,14 +537,13 @@ static int is_empty_shadow_page(u64 *spt)
 }
 #endif
 
-static void kvm_mmu_free_page(struct kvm *kvm,
-			      struct kvm_mmu_page *page_head)
+static void kvm_mmu_free_page(struct kvm *kvm, struct kvm_mmu_page *sp)
 {
-	ASSERT(is_empty_shadow_page(page_head->spt));
-	list_del(&page_head->link);
-	__free_page(virt_to_page(page_head->spt));
-	__free_page(virt_to_page(page_head->gfns));
-	kfree(page_head);
+	ASSERT(is_empty_shadow_page(sp->spt));
+	list_del(&sp->link);
+	__free_page(virt_to_page(sp->spt));
+	__free_page(virt_to_page(sp->gfns));
+	kfree(sp);
 	++kvm->n_free_mmu_pages;
 }
 
@@ -556,27 +555,26 @@ static unsigned kvm_page_table_hashfn(gfn_t gfn)
 static struct kvm_mmu_page *kvm_mmu_alloc_page(struct kvm_vcpu *vcpu,
 					       u64 *parent_pte)
 {
-	struct kvm_mmu_page *page;
+	struct kvm_mmu_page *sp;
 
 	if (!vcpu->kvm->n_free_mmu_pages)
 		return NULL;
 
-	page = mmu_memory_cache_alloc(&vcpu->mmu_page_header_cache,
-				      sizeof *page);
-	page->spt = mmu_memory_cache_alloc(&vcpu->mmu_page_cache, PAGE_SIZE);
-	page->gfns = mmu_memory_cache_alloc(&vcpu->mmu_page_cache, PAGE_SIZE);
-	set_page_private(virt_to_page(page->spt), (unsigned long)page);
-	list_add(&page->link, &vcpu->kvm->active_mmu_pages);
-	ASSERT(is_empty_shadow_page(page->spt));
-	page->slot_bitmap = 0;
-	page->multimapped = 0;
-	page->parent_pte = parent_pte;
+	sp = mmu_memory_cache_alloc(&vcpu->mmu_page_header_cache, sizeof *sp);
+	sp->spt = mmu_memory_cache_alloc(&vcpu->mmu_page_cache, PAGE_SIZE);
+	sp->gfns = mmu_memory_cache_alloc(&vcpu->mmu_page_cache, PAGE_SIZE);
+	set_page_private(virt_to_page(sp->spt), (unsigned long)sp);
+	list_add(&sp->link, &vcpu->kvm->active_mmu_pages);
+	ASSERT(is_empty_shadow_page(sp->spt));
+	sp->slot_bitmap = 0;
+	sp->multimapped = 0;
+	sp->parent_pte = parent_pte;
 	--vcpu->kvm->n_free_mmu_pages;
-	return page;
+	return sp;
 }
 
 static void mmu_page_add_parent_pte(struct kvm_vcpu *vcpu,
-				    struct kvm_mmu_page *page, u64 *parent_pte)
+				    struct kvm_mmu_page *sp, u64 *parent_pte)
 {
 	struct kvm_pte_chain *pte_chain;
 	struct hlist_node *node;
@@ -584,20 +582,20 @@ static void mmu_page_add_parent_pte(struct kvm_vcpu *vcpu,
 
 	if (!parent_pte)
 		return;
-	if (!page->multimapped) {
-		u64 *old = page->parent_pte;
+	if (!sp->multimapped) {
+		u64 *old = sp->parent_pte;
 
 		if (!old) {
-			page->parent_pte = parent_pte;
+			sp->parent_pte = parent_pte;
 			return;
 		}
-		page->multimapped = 1;
+		sp->multimapped = 1;
 		pte_chain = mmu_alloc_pte_chain(vcpu);
-		INIT_HLIST_HEAD(&page->parent_ptes);
-		hlist_add_head(&pte_chain->link, &page->parent_ptes);
+		INIT_HLIST_HEAD(&sp->parent_ptes);
+		hlist_add_head(&pte_chain->link, &sp->parent_ptes);
 		pte_chain->parent_ptes[0] = old;
 	}
-	hlist_for_each_entry(pte_chain, node, &page->parent_ptes, link) {
+	hlist_for_each_entry(pte_chain, node, &sp->parent_ptes, link) {
 		if (pte_chain->parent_ptes[NR_PTE_CHAIN_ENTRIES-1])
 			continue;
 		for (i = 0; i < NR_PTE_CHAIN_ENTRIES; ++i)
@@ -608,23 +606,23 @@ static void mmu_page_add_parent_pte(struct kvm_vcpu *vcpu,
 	}
 	pte_chain = mmu_alloc_pte_chain(vcpu);
 	BUG_ON(!pte_chain);
-	hlist_add_head(&pte_chain->link, &page->parent_ptes);
+	hlist_add_head(&pte_chain->link, &sp->parent_ptes);
 	pte_chain->parent_ptes[0] = parent_pte;
 }
 
-static void mmu_page_remove_parent_pte(struct kvm_mmu_page *page,
+static void mmu_page_remove_parent_pte(struct kvm_mmu_page *sp,
 				       u64 *parent_pte)
 {
 	struct kvm_pte_chain *pte_chain;
 	struct hlist_node *node;
 	int i;
 
-	if (!page->multimapped) {
-		BUG_ON(page->parent_pte != parent_pte);
-		page->parent_pte = NULL;
+	if (!sp->multimapped) {
+		BUG_ON(sp->parent_pte != parent_pte);
+		sp->parent_pte = NULL;
 		return;
 	}
-	hlist_for_each_entry(pte_chain, node, &page->parent_ptes, link)
+	hlist_for_each_entry(pte_chain, node, &sp->parent_ptes, link)
 		for (i = 0; i < NR_PTE_CHAIN_ENTRIES; ++i) {
 			if (!pte_chain->parent_ptes[i])
 				break;
@@ -640,9 +638,9 @@ static void mmu_page_remove_parent_pte(struct kvm_mmu_page *page,
 			if (i == 0) {
 				hlist_del(&pte_chain->link);
 				mmu_free_pte_chain(pte_chain);
-				if (hlist_empty(&page->parent_ptes)) {
-					page->multimapped = 0;
-					page->parent_pte = NULL;
+				if (hlist_empty(&sp->parent_ptes)) {
+					sp->multimapped = 0;
+					sp->parent_pte = NULL;
 				}
 			}
 			return;
@@ -650,22 +648,21 @@ static void mmu_page_remove_parent_pte(struct kvm_mmu_page *page,
 	BUG();
 }
 
-static struct kvm_mmu_page *kvm_mmu_lookup_page(struct kvm *kvm,
-						gfn_t gfn)
+static struct kvm_mmu_page *kvm_mmu_lookup_page(struct kvm *kvm, gfn_t gfn)
 {
 	unsigned index;
 	struct hlist_head *bucket;
-	struct kvm_mmu_page *page;
+	struct kvm_mmu_page *sp;
 	struct hlist_node *node;
 
 	pgprintk("%s: looking for gfn %lx\n", __FUNCTION__, gfn);
 	index = kvm_page_table_hashfn(gfn) % KVM_NUM_MMU_PAGES;
 	bucket = &kvm->mmu_page_hash[index];
-	hlist_for_each_entry(page, node, bucket, hash_link)
-		if (page->gfn == gfn && !page->role.metaphysical) {
+	hlist_for_each_entry(sp, node, bucket, hash_link)
+		if (sp->gfn == gfn && !sp->role.metaphysical) {
 			pgprintk("%s: found role %x\n",
-				 __FUNCTION__, page->role.word);
-			return page;
+				 __FUNCTION__, sp->role.word);
+			return sp;
 		}
 	return NULL;
 }
@@ -682,7 +679,7 @@ static struct kvm_mmu_page *kvm_mmu_get_page(struct kvm_vcpu *vcpu,
 	unsigned index;
 	unsigned quadrant;
 	struct hlist_head *bucket;
-	struct kvm_mmu_page *page;
+	struct kvm_mmu_page *sp;
 	struct hlist_node *node;
 
 	role.word = 0;
@@ -699,35 +696,35 @@ static struct kvm_mmu_page *kvm_mmu_get_page(struct kvm_vcpu *vcpu,
 		 gfn, role.word);
 	index = kvm_page_table_hashfn(gfn) % KVM_NUM_MMU_PAGES;
 	bucket = &vcpu->kvm->mmu_page_hash[index];
-	hlist_for_each_entry(page, node, bucket, hash_link)
-		if (page->gfn == gfn && page->role.word == role.word) {
-			mmu_page_add_parent_pte(vcpu, page, parent_pte);
+	hlist_for_each_entry(sp, node, bucket, hash_link)
+		if (sp->gfn == gfn && sp->role.word == role.word) {
+			mmu_page_add_parent_pte(vcpu, sp, parent_pte);
 			pgprintk("%s: found\n", __FUNCTION__);
-			return page;
+			return sp;
 		}
-	page = kvm_mmu_alloc_page(vcpu, parent_pte);
-	if (!page)
-		return page;
+	sp = kvm_mmu_alloc_page(vcpu, parent_pte);
+	if (!sp)
+		return sp;
 	pgprintk("%s: adding gfn %lx role %x\n", __FUNCTION__, gfn, role.word);
-	page->gfn = gfn;
-	page->role = role;
-	hlist_add_head(&page->hash_link, bucket);
-	vcpu->mmu.prefetch_page(vcpu, page);
+	sp->gfn = gfn;
+	sp->role = role;
+	hlist_add_head(&sp->hash_link, bucket);
+	vcpu->mmu.prefetch_page(vcpu, sp);
 	if (!metaphysical)
 		rmap_write_protect(vcpu->kvm, gfn);
-	return page;
+	return sp;
 }
 
 static void kvm_mmu_page_unlink_children(struct kvm *kvm,
-					 struct kvm_mmu_page *page)
+					 struct kvm_mmu_page *sp)
 {
 	unsigned i;
 	u64 *pt;
 	u64 ent;
 
-	pt = page->spt;
+	pt = sp->spt;
 
-	if (page->role.level == PT_PAGE_TABLE_LEVEL) {
+	if (sp->role.level == PT_PAGE_TABLE_LEVEL) {
 		for (i = 0; i < PT64_ENT_PER_PAGE; ++i) {
 			if (is_shadow_present_pte(pt[i]))
 				rmap_remove(kvm, &pt[i]);
@@ -749,10 +746,9 @@ static void kvm_mmu_page_unlink_children(struct kvm *kvm,
 	kvm_flush_remote_tlbs(kvm);
 }
 
-static void kvm_mmu_put_page(struct kvm_mmu_page *page,
-			     u64 *parent_pte)
+static void kvm_mmu_put_page(struct kvm_mmu_page *sp, u64 *parent_pte)
 {
-	mmu_page_remove_parent_pte(page, parent_pte);
+	mmu_page_remove_parent_pte(sp, parent_pte);
 }
 
 static void kvm_mmu_reset_last_pte_updated(struct kvm *kvm)
@@ -764,32 +760,31 @@ static void kvm_mmu_reset_last_pte_updated(struct kvm *kvm)
 			kvm->vcpus[i]->last_pte_updated = NULL;
 }
 
-static void kvm_mmu_zap_page(struct kvm *kvm,
-			     struct kvm_mmu_page *page)
+static void kvm_mmu_zap_page(struct kvm *kvm, struct kvm_mmu_page *sp)
 {
 	u64 *parent_pte;
 
 	++kvm->stat.mmu_shadow_zapped;
-	while (page->multimapped || page->parent_pte) {
-		if (!page->multimapped)
-			parent_pte = page->parent_pte;
+	while (sp->multimapped || sp->parent_pte) {
+		if (!sp->multimapped)
+			parent_pte = sp->parent_pte;
 		else {
 			struct kvm_pte_chain *chain;
 
-			chain = container_of(page->parent_ptes.first,
+			chain = container_of(sp->parent_ptes.first,
 					     struct kvm_pte_chain, link);
 			parent_pte = chain->parent_ptes[0];
 		}
 		BUG_ON(!parent_pte);
-		kvm_mmu_put_page(page, parent_pte);
+		kvm_mmu_put_page(sp, parent_pte);
 		set_shadow_pte(parent_pte, shadow_trap_nonpresent_pte);
 	}
-	kvm_mmu_page_unlink_children(kvm, page);
-	if (!page->root_count) {
-		hlist_del(&page->hash_link);
-		kvm_mmu_free_page(kvm, page);
+	kvm_mmu_page_unlink_children(kvm, sp);
+	if (!sp->root_count) {
+		hlist_del(&sp->hash_link);
+		kvm_mmu_free_page(kvm, sp);
 	} else
-		list_move(&page->link, &kvm->active_mmu_pages);
+		list_move(&sp->link, &kvm->active_mmu_pages);
 	kvm_mmu_reset_last_pte_updated(kvm);
 }
 
@@ -831,7 +826,7 @@ static int kvm_mmu_unprotect_page(struct kvm *kvm, gfn_t gfn)
 {
 	unsigned index;
 	struct hlist_head *bucket;
-	struct kvm_mmu_page *page;
+	struct kvm_mmu_page *sp;
 	struct hlist_node *node, *n;
 	int r;
 
@@ -839,11 +834,11 @@ static int kvm_mmu_unprotect_page(struct kvm *kvm, gfn_t gfn)
 	r = 0;
 	index = kvm_page_table_hashfn(gfn) % KVM_NUM_MMU_PAGES;
 	bucket = &kvm->mmu_page_hash[index];
-	hlist_for_each_entry_safe(page, node, n, bucket, hash_link)
-		if (page->gfn == gfn && !page->role.metaphysical) {
+	hlist_for_each_entry_safe(sp, node, n, bucket, hash_link)
+		if (sp->gfn == gfn && !sp->role.metaphysical) {
 			pgprintk("%s: gfn %lx role %x\n", __FUNCTION__, gfn,
-				 page->role.word);
-			kvm_mmu_zap_page(kvm, page);
+				 sp->role.word);
+			kvm_mmu_zap_page(kvm, sp);
 			r = 1;
 		}
 	return r;
@@ -851,21 +846,20 @@ static int kvm_mmu_unprotect_page(struct kvm *kvm, gfn_t gfn)
 
 static void mmu_unshadow(struct kvm *kvm, gfn_t gfn)
 {
-	struct kvm_mmu_page *page;
+	struct kvm_mmu_page *sp;
 
-	while ((page = kvm_mmu_lookup_page(kvm, gfn)) != NULL) {
-		pgprintk("%s: zap %lx %x\n",
-			 __FUNCTION__, gfn, page->role.word);
-		kvm_mmu_zap_page(kvm, page);
+	while ((sp = kvm_mmu_lookup_page(kvm, gfn)) != NULL) {
+		pgprintk("%s: zap %lx %x\n", __FUNCTION__, gfn, sp->role.word);
+		kvm_mmu_zap_page(kvm, sp);
 	}
 }
 
 static void page_header_update_slot(struct kvm *kvm, void *pte, gfn_t gfn)
 {
 	int slot = memslot_id(kvm, gfn_to_memslot(kvm, gfn));
-	struct kvm_mmu_page *page_head = page_header(__pa(pte));
+	struct kvm_mmu_page *sp = page_header(__pa(pte));
 
-	__set_bit(slot, &page_head->slot_bitmap);
+	__set_bit(slot, &sp->slot_bitmap);
 }
 
 struct page *gva_to_page(struct kvm_vcpu *vcpu, gva_t gva)
@@ -951,7 +945,7 @@ static void nonpaging_prefetch_page(struct kvm_vcpu *vcpu,
 static void mmu_free_roots(struct kvm_vcpu *vcpu)
 {
 	int i;
-	struct kvm_mmu_page *page;
+	struct kvm_mmu_page *sp;
 
 	if (!VALID_PAGE(vcpu->mmu.root_hpa))
 		return;
@@ -959,8 +953,8 @@ static void mmu_free_roots(struct kvm_vcpu *vcpu)
 	if (vcpu->mmu.shadow_root_level == PT64_ROOT_LEVEL) {
 		hpa_t root = vcpu->mmu.root_hpa;
 
-		page = page_header(root);
-		--page->root_count;
+		sp = page_header(root);
+		--sp->root_count;
 		vcpu->mmu.root_hpa = INVALID_PAGE;
 		return;
 	}
@@ -970,8 +964,8 @@ static void mmu_free_roots(struct kvm_vcpu *vcpu)
 
 		if (root) {
 			root &= PT64_BASE_ADDR_MASK;
-			page = page_header(root);
-			--page->root_count;
+			sp = page_header(root);
+			--sp->root_count;
 		}
 		vcpu->mmu.pae_root[i] = INVALID_PAGE;
 	}
@@ -982,7 +976,7 @@ static void mmu_alloc_roots(struct kvm_vcpu *vcpu)
 {
 	int i;
 	gfn_t root_gfn;
-	struct kvm_mmu_page *page;
+	struct kvm_mmu_page *sp;
 
 	root_gfn = vcpu->cr3 >> PAGE_SHIFT;
 
@@ -991,10 +985,10 @@ static void mmu_alloc_roots(struct kvm_vcpu *vcpu)
 		hpa_t root = vcpu->mmu.root_hpa;
 
 		ASSERT(!VALID_PAGE(root));
-		page = kvm_mmu_get_page(vcpu, root_gfn, 0,
-					PT64_ROOT_LEVEL, 0, 0, NULL);
-		root = __pa(page->spt);
-		++page->root_count;
+		sp = kvm_mmu_get_page(vcpu, root_gfn, 0,
+				      PT64_ROOT_LEVEL, 0, 0, NULL);
+		root = __pa(sp->spt);
+		++sp->root_count;
 		vcpu->mmu.root_hpa = root;
 		return;
 	}
@@ -1011,11 +1005,11 @@ static void mmu_alloc_roots(struct kvm_vcpu *vcpu)
 			root_gfn = vcpu->pdptrs[i] >> PAGE_SHIFT;
 		} else if (vcpu->mmu.root_level == 0)
 			root_gfn = 0;
-		page = kvm_mmu_get_page(vcpu, root_gfn, i << 30,
-					PT32_ROOT_LEVEL, !is_paging(vcpu),
-					0, NULL);
-		root = __pa(page->spt);
-		++page->root_count;
+		sp = kvm_mmu_get_page(vcpu, root_gfn, i << 30,
+				      PT32_ROOT_LEVEL, !is_paging(vcpu),
+				      0, NULL);
+		root = __pa(sp->spt);
+		++sp->root_count;
 		vcpu->mmu.pae_root[i] = root | PT_PRESENT_MASK;
 	}
 	vcpu->mmu.root_hpa = __pa(vcpu->mmu.pae_root);
@@ -1196,7 +1190,7 @@ void kvm_mmu_unload(struct kvm_vcpu *vcpu)
 }
 
 static void mmu_pte_write_zap_pte(struct kvm_vcpu *vcpu,
-				  struct kvm_mmu_page *page,
+				  struct kvm_mmu_page *sp,
 				  u64 *spte)
 {
 	u64 pte;
@@ -1204,7 +1198,7 @@ static void mmu_pte_write_zap_pte(struct kvm_vcpu *vcpu,
 
 	pte = *spte;
 	if (is_shadow_present_pte(pte)) {
-		if (page->role.level == PT_PAGE_TABLE_LEVEL)
+		if (sp->role.level == PT_PAGE_TABLE_LEVEL)
 			rmap_remove(vcpu->kvm, spte);
 		else {
 			child = page_header(pte & PT64_BASE_ADDR_MASK);
@@ -1215,23 +1209,21 @@ static void mmu_pte_write_zap_pte(struct kvm_vcpu *vcpu,
 }
 
 static void mmu_pte_write_new_pte(struct kvm_vcpu *vcpu,
-				  struct kvm_mmu_page *page,
+				  struct kvm_mmu_page *sp,
 				  u64 *spte,
 				  const void *new, int bytes,
 				  int offset_in_pte)
 {
-	if (page->role.level != PT_PAGE_TABLE_LEVEL) {
+	if (sp->role.level != PT_PAGE_TABLE_LEVEL) {
 		++vcpu->kvm->stat.mmu_pde_zapped;
 		return;
 	}
 
 	++vcpu->kvm->stat.mmu_pte_updated;
-	if (page->role.glevels == PT32_ROOT_LEVEL)
-		paging32_update_pte(vcpu, page, spte, new, bytes,
-				    offset_in_pte);
+	if (sp->role.glevels == PT32_ROOT_LEVEL)
+		paging32_update_pte(vcpu, sp, spte, new, bytes, offset_in_pte);
 	else
-		paging64_update_pte(vcpu, page, spte, new, bytes,
-				    offset_in_pte);
+		paging64_update_pte(vcpu, sp, spte, new, bytes, offset_in_pte);
 }
 
 static bool need_remote_flush(u64 old, u64 new)
@@ -1266,7 +1258,7 @@ void kvm_mmu_pte_write(struct kvm_vcpu *vcpu, gpa_t gpa,
 		       const u8 *new, int bytes)
 {
 	gfn_t gfn = gpa >> PAGE_SHIFT;
-	struct kvm_mmu_page *page;
+	struct kvm_mmu_page *sp;
 	struct hlist_node *node, *n;
 	struct hlist_head *bucket;
 	unsigned index;
@@ -1296,10 +1288,10 @@ void kvm_mmu_pte_write(struct kvm_vcpu *vcpu, gpa_t gpa,
 	}
 	index = kvm_page_table_hashfn(gfn) % KVM_NUM_MMU_PAGES;
 	bucket = &vcpu->kvm->mmu_page_hash[index];
-	hlist_for_each_entry_safe(page, node, n, bucket, hash_link) {
-		if (page->gfn != gfn || page->role.metaphysical)
+	hlist_for_each_entry_safe(sp, node, n, bucket, hash_link) {
+		if (sp->gfn != gfn || sp->role.metaphysical)
 			continue;
-		pte_size = page->role.glevels == PT32_ROOT_LEVEL ? 4 : 8;
+		pte_size = sp->role.glevels == PT32_ROOT_LEVEL ? 4 : 8;
 		misaligned = (offset ^ (offset + bytes - 1)) & ~(pte_size - 1);
 		misaligned |= bytes < 4;
 		if (misaligned || flooded) {
@@ -1314,15 +1306,15 @@ void kvm_mmu_pte_write(struct kvm_vcpu *vcpu, gpa_t gpa,
 			 * page.
 			 */
 			pgprintk("misaligned: gpa %llx bytes %d role %x\n",
-				 gpa, bytes, page->role.word);
-			kvm_mmu_zap_page(vcpu->kvm, page);
+				 gpa, bytes, sp->role.word);
+			kvm_mmu_zap_page(vcpu->kvm, sp);
 			++vcpu->kvm->stat.mmu_flooded;
 			continue;
 		}
 		page_offset = offset;
-		level = page->role.level;
+		level = sp->role.level;
 		npte = 1;
-		if (page->role.glevels == PT32_ROOT_LEVEL) {
+		if (sp->role.glevels == PT32_ROOT_LEVEL) {
 			page_offset <<= 1;	/* 32->64 */
 			/*
 			 * A 32-bit pde maps 4MB while the shadow pdes map
@@ -1336,14 +1328,14 @@ void kvm_mmu_pte_write(struct kvm_vcpu *vcpu, gpa_t gpa,
 			}
 			quadrant = page_offset >> PAGE_SHIFT;
 			page_offset &= ~PAGE_MASK;
-			if (quadrant != page->role.quadrant)
+			if (quadrant != sp->role.quadrant)
 				continue;
 		}
-		spte = &page->spt[page_offset / sizeof(*spte)];
+		spte = &sp->spt[page_offset / sizeof(*spte)];
 		while (npte--) {
 			entry = *spte;
-			mmu_pte_write_zap_pte(vcpu, page, spte);
-			mmu_pte_write_new_pte(vcpu, page, spte, new, bytes,
+			mmu_pte_write_zap_pte(vcpu, sp, spte);
+			mmu_pte_write_new_pte(vcpu, sp, spte, new, bytes,
 					      page_offset & (pte_size - 1));
 			mmu_pte_write_flush_tlb(vcpu, entry, *spte);
 			++spte;
@@ -1362,11 +1354,11 @@ int kvm_mmu_unprotect_page_virt(struct kvm_vcpu *vcpu, gva_t gva)
 void __kvm_mmu_free_some_pages(struct kvm_vcpu *vcpu)
 {
 	while (vcpu->kvm->n_free_mmu_pages < KVM_REFILL_PAGES) {
-		struct kvm_mmu_page *page;
+		struct kvm_mmu_page *sp;
 
-		page = container_of(vcpu->kvm->active_mmu_pages.prev,
-				    struct kvm_mmu_page, link);
-		kvm_mmu_zap_page(vcpu->kvm, page);
+		sp = container_of(vcpu->kvm->active_mmu_pages.prev,
+				  struct kvm_mmu_page, link);
+		kvm_mmu_zap_page(vcpu->kvm, sp);
 		++vcpu->kvm->stat.mmu_recycled;
 	}
 }
@@ -1413,12 +1405,12 @@ EXPORT_SYMBOL_GPL(kvm_mmu_page_fault);
 
 static void free_mmu_pages(struct kvm_vcpu *vcpu)
 {
-	struct kvm_mmu_page *page;
+	struct kvm_mmu_page *sp;
 
 	while (!list_empty(&vcpu->kvm->active_mmu_pages)) {
-		page = container_of(vcpu->kvm->active_mmu_pages.next,
-				    struct kvm_mmu_page, link);
-		kvm_mmu_zap_page(vcpu->kvm, page);
+		sp = container_of(vcpu->kvm->active_mmu_pages.next,
+				  struct kvm_mmu_page, link);
+		kvm_mmu_zap_page(vcpu->kvm, sp);
 	}
 	free_page((unsigned long)vcpu->mmu.pae_root);
 }
@@ -1480,16 +1472,16 @@ void kvm_mmu_destroy(struct kvm_vcpu *vcpu)
 
 void kvm_mmu_slot_remove_write_access(struct kvm *kvm, int slot)
 {
-	struct kvm_mmu_page *page;
+	struct kvm_mmu_page *sp;
 
-	list_for_each_entry(page, &kvm->active_mmu_pages, link) {
+	list_for_each_entry(sp, &kvm->active_mmu_pages, link) {
 		int i;
 		u64 *pt;
 
-		if (!test_bit(slot, &page->slot_bitmap))
+		if (!test_bit(slot, &sp->slot_bitmap))
 			continue;
 
-		pt = page->spt;
+		pt = sp->spt;
 		for (i = 0; i < PT64_ENT_PER_PAGE; ++i)
 			/* avoid RMW */
 			if (pt[i] & PT_WRITABLE_MASK)
@@ -1499,10 +1491,10 @@ void kvm_mmu_slot_remove_write_access(struct kvm *kvm, int slot)
 
 void kvm_mmu_zap_all(struct kvm *kvm)
 {
-	struct kvm_mmu_page *page, *node;
+	struct kvm_mmu_page *sp, *node;
 
-	list_for_each_entry_safe(page, node, &kvm->active_mmu_pages, link)
-		kvm_mmu_zap_page(kvm, page);
+	list_for_each_entry_safe(sp, node, &kvm->active_mmu_pages, link)
+		kvm_mmu_zap_page(kvm, sp);
 
 	kvm_flush_remote_tlbs(kvm);
 }
@@ -1668,13 +1660,13 @@ static int count_rmaps(struct kvm_vcpu *vcpu)
 static int count_writable_mappings(struct kvm_vcpu *vcpu)
 {
 	int nmaps = 0;
-	struct kvm_mmu_page *page;
+	struct kvm_mmu_page *sp;
 	int i;
 
-	list_for_each_entry(page, &vcpu->kvm->active_mmu_pages, link) {
-		u64 *pt = page->spt;
+	list_for_each_entry(sp, &vcpu->kvm->active_mmu_pages, link) {
+		u64 *pt = sp->spt;
 
-		if (page->role.level != PT_PAGE_TABLE_LEVEL)
+		if (sp->role.level != PT_PAGE_TABLE_LEVEL)
 			continue;
 
 		for (i = 0; i < PT64_ENT_PER_PAGE; ++i) {
@@ -1702,23 +1694,23 @@ static void audit_rmap(struct kvm_vcpu *vcpu)
 
 static void audit_write_protection(struct kvm_vcpu *vcpu)
 {
-	struct kvm_mmu_page *page;
+	struct kvm_mmu_page *sp;
 	struct kvm_memory_slot *slot;
 	unsigned long *rmapp;
 	gfn_t gfn;
 
-	list_for_each_entry(page, &vcpu->kvm->active_mmu_pages, link) {
-		if (page->role.metaphysical)
+	list_for_each_entry(sp, &vcpu->kvm->active_mmu_pages, link) {
+		if (sp->role.metaphysical)
 			continue;
 
-		slot = gfn_to_memslot(vcpu->kvm, page->gfn);
-		gfn = unalias_gfn(vcpu->kvm, page->gfn);
+		slot = gfn_to_memslot(vcpu->kvm, sp->gfn);
+		gfn = unalias_gfn(vcpu->kvm, sp->gfn);
 		rmapp = &slot->rmap[gfn - slot->base_gfn];
 		if (*rmapp)
 			printk(KERN_ERR "%s: (%s) shadow page has writable"
 			       " mappings: gfn %lx role %x\n",
-			       __FUNCTION__, audit_msg, page->gfn,
-			       page->role.word);
+			       __FUNCTION__, audit_msg, sp->gfn,
+			       sp->role.word);
 	}
 }
 
-- 
1.5.3.7

