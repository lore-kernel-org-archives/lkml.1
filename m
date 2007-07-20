Return-Path: <linux-kernel-owner+w=401wt.eu-S1764748AbXGTRcy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764748AbXGTRcy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jul 2007 13:32:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764602AbXGTRcF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Jul 2007 13:32:05 -0400
Received: from il.qumranet.com ([82.166.9.18]:39328 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935838AbXGTRcB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jul 2007 13:32:01 -0400
From: Avi Kivity <avi@qumranet.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: kvm-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: [GIT PULL][RESEND] Late KVM Updates for the 2.6.23 merge window
Date: Fri, 20 Jul 2007 20:32:08 +0300
Message-Id: <1184952728548-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.2.4
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull from the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/avi/kvm.git for-linus

to get the following changes:

Avi Kivity (4):
      KVM: MMU: Store nx bit for large page shadows
      KVM: Fix memory slot management functions for guest smp
      KVM: x86 emulator: implement rdmsr and wrmsr
      KVM: MMU: Fix oopses with SLUB

The last commit is new since the last pull request.

 drivers/kvm/kvm.h         |   10 ++-
 drivers/kvm/kvm_main.c    |   76 ++++--------------------
 drivers/kvm/mmu.c         |  140 +++++++++++++++++++++------------------------
 drivers/kvm/paging_tmpl.h |    2 +
 drivers/kvm/x86_emulate.c |   26 ++++++++-
 5 files changed, 112 insertions(+), 142 deletions(-)

commit d55e2cb20123cdb5020ec4a2b2f1eace5038c292
Author: Avi Kivity <avi@qumranet.com>
Date:   Tue Jul 10 17:50:55 2007 +0300

    KVM: MMU: Store nx bit for large page shadows
    
    We need to distinguish between large page shadows which have the nx bit set
    and those which don't.  The problem shows up when booting a newer smp Linux
    kernel, where the trampoline page (which is in real mode, which uses the
    same shadow pages as large pages) is using the same mapping as a kernel data
    page, which is mapped using nx, causing kvm to spin on that page.
    
    Signed-off-by: Avi Kivity <avi@qumranet.com>

diff --git a/drivers/kvm/kvm.h b/drivers/kvm/kvm.h
index a7c5e6b..65ab268 100644
--- a/drivers/kvm/kvm.h
+++ b/drivers/kvm/kvm.h
@@ -121,7 +121,7 @@ struct kvm_pte_chain {
  *   bits 4:7 - page table level for this shadow (1-4)
  *   bits 8:9 - page table quadrant for 2-level guests
  *   bit   16 - "metaphysical" - gfn is not a real page (huge page/real mode)
- *   bits 17:18 - "access" - the user and writable bits of a huge page pde
+ *   bits 17:19 - "access" - the user, writable, and nx bits of a huge page pde
  */
 union kvm_mmu_page_role {
 	unsigned word;
@@ -131,7 +131,7 @@ union kvm_mmu_page_role {
 		unsigned quadrant : 2;
 		unsigned pad_for_nice_hex_output : 6;
 		unsigned metaphysical : 1;
-		unsigned hugepage_access : 2;
+		unsigned hugepage_access : 3;
 	};
 };
 
diff --git a/drivers/kvm/paging_tmpl.h b/drivers/kvm/paging_tmpl.h
index a7c5cb0..4b5391c 100644
--- a/drivers/kvm/paging_tmpl.h
+++ b/drivers/kvm/paging_tmpl.h
@@ -366,6 +366,8 @@ static u64 *FNAME(fetch)(struct kvm_vcpu *vcpu, gva_t addr,
 			metaphysical = 1;
 			hugepage_access = *guest_ent;
 			hugepage_access &= PT_USER_MASK | PT_WRITABLE_MASK;
+			if (*guest_ent & PT64_NX_MASK)
+				hugepage_access |= (1 << 2);
 			hugepage_access >>= PT_WRITABLE_SHIFT;
 			table_gfn = (*guest_ent & PT_BASE_ADDR_MASK)
 				>> PAGE_SHIFT;

commit 90cb0529dd230548a7f0d6b315997be854caea1b
Author: Avi Kivity <avi@qumranet.com>
Date:   Tue Jul 17 13:04:56 2007 +0300

    KVM: Fix memory slot management functions for guest smp
    
    The memory slot management functions were oriented against vcpu 0, where
    they should be kvm-wide.  This causes hangs starting X on guest smp.
    
    Fix by making the functions (and resultant tail in the mmu) non-vcpu-specific.
    Unfortunately this reduces the efficiency of the mmu object cache a bit.  We
    may have to revisit this later.
    
    Signed-off-by: Avi Kivity <avi@qumranet.com>

diff --git a/drivers/kvm/kvm.h b/drivers/kvm/kvm.h
index 65ab268..6636ae2 100644
--- a/drivers/kvm/kvm.h
+++ b/drivers/kvm/kvm.h
@@ -535,8 +535,8 @@ int kvm_mmu_create(struct kvm_vcpu *vcpu);
 int kvm_mmu_setup(struct kvm_vcpu *vcpu);
 
 int kvm_mmu_reset_context(struct kvm_vcpu *vcpu);
-void kvm_mmu_slot_remove_write_access(struct kvm_vcpu *vcpu, int slot);
-void kvm_mmu_zap_all(struct kvm_vcpu *vcpu);
+void kvm_mmu_slot_remove_write_access(struct kvm *kvm, int slot);
+void kvm_mmu_zap_all(struct kvm *kvm);
 
 hpa_t gpa_to_hpa(struct kvm_vcpu *vcpu, gpa_t gpa);
 #define HPA_MSB ((sizeof(hpa_t) * 8) - 1)
diff --git a/drivers/kvm/kvm_main.c b/drivers/kvm/kvm_main.c
index 1b206f1..05f0418 100644
--- a/drivers/kvm/kvm_main.c
+++ b/drivers/kvm/kvm_main.c
@@ -238,23 +238,6 @@ static void vcpu_load(struct kvm_vcpu *vcpu)
 	kvm_arch_ops->vcpu_load(vcpu);
 }
 
-/*
- * Switches to specified vcpu, until a matching vcpu_put(). Will return NULL
- * if the slot is not populated.
- */
-static struct kvm_vcpu *vcpu_load_slot(struct kvm *kvm, int slot)
-{
-	struct kvm_vcpu *vcpu = &kvm->vcpus[slot];
-
-	mutex_lock(&vcpu->mutex);
-	if (!vcpu->vmcs) {
-		mutex_unlock(&vcpu->mutex);
-		return NULL;
-	}
-	kvm_arch_ops->vcpu_load(vcpu);
-	return vcpu;
-}
-
 static void vcpu_put(struct kvm_vcpu *vcpu)
 {
 	kvm_arch_ops->vcpu_put(vcpu);
@@ -663,13 +646,6 @@ void fx_init(struct kvm_vcpu *vcpu)
 }
 EXPORT_SYMBOL_GPL(fx_init);
 
-static void do_remove_write_access(struct kvm_vcpu *vcpu, int slot)
-{
-	spin_lock(&vcpu->kvm->lock);
-	kvm_mmu_slot_remove_write_access(vcpu, slot);
-	spin_unlock(&vcpu->kvm->lock);
-}
-
 /*
  * Allocate some memory and give it an address in the guest physical address
  * space.
@@ -792,19 +768,10 @@ raced:
 	*memslot = new;
 	++kvm->memory_config_version;
 
-	spin_unlock(&kvm->lock);
-
-	for (i = 0; i < KVM_MAX_VCPUS; ++i) {
-		struct kvm_vcpu *vcpu;
+	kvm_mmu_slot_remove_write_access(kvm, mem->slot);
+	kvm_flush_remote_tlbs(kvm);
 
-		vcpu = vcpu_load_slot(kvm, i);
-		if (!vcpu)
-			continue;
-		if (new.flags & KVM_MEM_LOG_DIRTY_PAGES)
-			do_remove_write_access(vcpu, mem->slot);
-		kvm_mmu_reset_context(vcpu);
-		vcpu_put(vcpu);
-	}
+	spin_unlock(&kvm->lock);
 
 	kvm_free_physmem_slot(&old, &new);
 	return 0;
@@ -826,7 +793,6 @@ static int kvm_vm_ioctl_get_dirty_log(struct kvm *kvm,
 	struct kvm_memory_slot *memslot;
 	int r, i;
 	int n;
-	int cleared;
 	unsigned long any = 0;
 
 	spin_lock(&kvm->lock);
@@ -855,23 +821,11 @@ static int kvm_vm_ioctl_get_dirty_log(struct kvm *kvm,
 	if (copy_to_user(log->dirty_bitmap, memslot->dirty_bitmap, n))
 		goto out;
 
-	if (any) {
-		cleared = 0;
-		for (i = 0; i < KVM_MAX_VCPUS; ++i) {
-			struct kvm_vcpu *vcpu;
-
-			vcpu = vcpu_load_slot(kvm, i);
-			if (!vcpu)
-				continue;
-			if (!cleared) {
-				do_remove_write_access(vcpu, log->slot);
-				memset(memslot->dirty_bitmap, 0, n);
-				cleared = 1;
-			}
-			kvm_arch_ops->tlb_flush(vcpu);
-			vcpu_put(vcpu);
-		}
-	}
+	spin_lock(&kvm->lock);
+	kvm_mmu_slot_remove_write_access(kvm, log->slot);
+	kvm_flush_remote_tlbs(kvm);
+	memset(memslot->dirty_bitmap, 0, n);
+	spin_unlock(&kvm->lock);
 
 	r = 0;
 
@@ -920,13 +874,9 @@ static int kvm_vm_ioctl_set_memory_alias(struct kvm *kvm,
 			break;
 	kvm->naliases = n;
 
-	spin_unlock(&kvm->lock);
+	kvm_mmu_zap_all(kvm);
 
-	vcpu_load(&kvm->vcpus[0]);
-	spin_lock(&kvm->lock);
-	kvm_mmu_zap_all(&kvm->vcpus[0]);
 	spin_unlock(&kvm->lock);
-	vcpu_put(&kvm->vcpus[0]);
 
 	return 0;
 
diff --git a/drivers/kvm/mmu.c b/drivers/kvm/mmu.c
index 1199d3f..48d28f1 100644
--- a/drivers/kvm/mmu.c
+++ b/drivers/kvm/mmu.c
@@ -281,24 +281,15 @@ static void *mmu_memory_cache_alloc(struct kvm_mmu_memory_cache *mc,
 	return p;
 }
 
-static void mmu_memory_cache_free(struct kvm_mmu_memory_cache *mc, void *obj)
-{
-	if (mc->nobjs < KVM_NR_MEM_OBJS)
-		mc->objects[mc->nobjs++] = obj;
-	else
-		kfree(obj);
-}
-
 static struct kvm_pte_chain *mmu_alloc_pte_chain(struct kvm_vcpu *vcpu)
 {
 	return mmu_memory_cache_alloc(&vcpu->mmu_pte_chain_cache,
 				      sizeof(struct kvm_pte_chain));
 }
 
-static void mmu_free_pte_chain(struct kvm_vcpu *vcpu,
-			       struct kvm_pte_chain *pc)
+static void mmu_free_pte_chain(struct kvm_pte_chain *pc)
 {
-	mmu_memory_cache_free(&vcpu->mmu_pte_chain_cache, pc);
+	kfree(pc);
 }
 
 static struct kvm_rmap_desc *mmu_alloc_rmap_desc(struct kvm_vcpu *vcpu)
@@ -307,10 +298,9 @@ static struct kvm_rmap_desc *mmu_alloc_rmap_desc(struct kvm_vcpu *vcpu)
 				      sizeof(struct kvm_rmap_desc));
 }
 
-static void mmu_free_rmap_desc(struct kvm_vcpu *vcpu,
-			       struct kvm_rmap_desc *rd)
+static void mmu_free_rmap_desc(struct kvm_rmap_desc *rd)
 {
-	mmu_memory_cache_free(&vcpu->mmu_rmap_desc_cache, rd);
+	kfree(rd);
 }
 
 /*
@@ -355,8 +345,7 @@ static void rmap_add(struct kvm_vcpu *vcpu, u64 *spte)
 	}
 }
 
-static void rmap_desc_remove_entry(struct kvm_vcpu *vcpu,
-				   struct page *page,
+static void rmap_desc_remove_entry(struct page *page,
 				   struct kvm_rmap_desc *desc,
 				   int i,
 				   struct kvm_rmap_desc *prev_desc)
@@ -376,10 +365,10 @@ static void rmap_desc_remove_entry(struct kvm_vcpu *vcpu,
 			prev_desc->more = desc->more;
 		else
 			set_page_private(page,(unsigned long)desc->more | 1);
-	mmu_free_rmap_desc(vcpu, desc);
+	mmu_free_rmap_desc(desc);
 }
 
-static void rmap_remove(struct kvm_vcpu *vcpu, u64 *spte)
+static void rmap_remove(u64 *spte)
 {
 	struct page *page;
 	struct kvm_rmap_desc *desc;
@@ -407,7 +396,7 @@ static void rmap_remove(struct kvm_vcpu *vcpu, u64 *spte)
 		while (desc) {
 			for (i = 0; i < RMAP_EXT && desc->shadow_ptes[i]; ++i)
 				if (desc->shadow_ptes[i] == spte) {
-					rmap_desc_remove_entry(vcpu, page,
+					rmap_desc_remove_entry(page,
 							       desc, i,
 							       prev_desc);
 					return;
@@ -442,7 +431,7 @@ static void rmap_write_protect(struct kvm_vcpu *vcpu, u64 gfn)
 		BUG_ON(!(*spte & PT_PRESENT_MASK));
 		BUG_ON(!(*spte & PT_WRITABLE_MASK));
 		rmap_printk("rmap_write_protect: spte %p %llx\n", spte, *spte);
-		rmap_remove(vcpu, spte);
+		rmap_remove(spte);
 		set_shadow_pte(spte, *spte & ~PT_WRITABLE_MASK);
 		kvm_flush_remote_tlbs(vcpu->kvm);
 	}
@@ -464,14 +453,14 @@ static int is_empty_shadow_page(u64 *spt)
 }
 #endif
 
-static void kvm_mmu_free_page(struct kvm_vcpu *vcpu,
+static void kvm_mmu_free_page(struct kvm *kvm,
 			      struct kvm_mmu_page *page_head)
 {
 	ASSERT(is_empty_shadow_page(page_head->spt));
 	list_del(&page_head->link);
-	mmu_memory_cache_free(&vcpu->mmu_page_cache, page_head->spt);
-	mmu_memory_cache_free(&vcpu->mmu_page_header_cache, page_head);
-	++vcpu->kvm->n_free_mmu_pages;
+	kfree(page_head->spt);
+	kfree(page_head);
+	++kvm->n_free_mmu_pages;
 }
 
 static unsigned kvm_page_table_hashfn(gfn_t gfn)
@@ -537,8 +526,7 @@ static void mmu_page_add_parent_pte(struct kvm_vcpu *vcpu,
 	pte_chain->parent_ptes[0] = parent_pte;
 }
 
-static void mmu_page_remove_parent_pte(struct kvm_vcpu *vcpu,
-				       struct kvm_mmu_page *page,
+static void mmu_page_remove_parent_pte(struct kvm_mmu_page *page,
 				       u64 *parent_pte)
 {
 	struct kvm_pte_chain *pte_chain;
@@ -565,7 +553,7 @@ static void mmu_page_remove_parent_pte(struct kvm_vcpu *vcpu,
 			pte_chain->parent_ptes[i] = NULL;
 			if (i == 0) {
 				hlist_del(&pte_chain->link);
-				mmu_free_pte_chain(vcpu, pte_chain);
+				mmu_free_pte_chain(pte_chain);
 				if (hlist_empty(&page->parent_ptes)) {
 					page->multimapped = 0;
 					page->parent_pte = NULL;
@@ -643,7 +631,7 @@ static struct kvm_mmu_page *kvm_mmu_get_page(struct kvm_vcpu *vcpu,
 	return page;
 }
 
-static void kvm_mmu_page_unlink_children(struct kvm_vcpu *vcpu,
+static void kvm_mmu_page_unlink_children(struct kvm *kvm,
 					 struct kvm_mmu_page *page)
 {
 	unsigned i;
@@ -655,10 +643,10 @@ static void kvm_mmu_page_unlink_children(struct kvm_vcpu *vcpu,
 	if (page->role.level == PT_PAGE_TABLE_LEVEL) {
 		for (i = 0; i < PT64_ENT_PER_PAGE; ++i) {
 			if (pt[i] & PT_PRESENT_MASK)
-				rmap_remove(vcpu, &pt[i]);
+				rmap_remove(&pt[i]);
 			pt[i] = 0;
 		}
-		kvm_flush_remote_tlbs(vcpu->kvm);
+		kvm_flush_remote_tlbs(kvm);
 		return;
 	}
 
@@ -669,19 +657,18 @@ static void kvm_mmu_page_unlink_children(struct kvm_vcpu *vcpu,
 		if (!(ent & PT_PRESENT_MASK))
 			continue;
 		ent &= PT64_BASE_ADDR_MASK;
-		mmu_page_remove_parent_pte(vcpu, page_header(ent), &pt[i]);
+		mmu_page_remove_parent_pte(page_header(ent), &pt[i]);
 	}
-	kvm_flush_remote_tlbs(vcpu->kvm);
+	kvm_flush_remote_tlbs(kvm);
 }
 
-static void kvm_mmu_put_page(struct kvm_vcpu *vcpu,
-			     struct kvm_mmu_page *page,
+static void kvm_mmu_put_page(struct kvm_mmu_page *page,
 			     u64 *parent_pte)
 {
-	mmu_page_remove_parent_pte(vcpu, page, parent_pte);
+	mmu_page_remove_parent_pte(page, parent_pte);
 }
 
-static void kvm_mmu_zap_page(struct kvm_vcpu *vcpu,
+static void kvm_mmu_zap_page(struct kvm *kvm,
 			     struct kvm_mmu_page *page)
 {
 	u64 *parent_pte;
@@ -697,15 +684,15 @@ static void kvm_mmu_zap_page(struct kvm_vcpu *vcpu,
 			parent_pte = chain->parent_ptes[0];
 		}
 		BUG_ON(!parent_pte);
-		kvm_mmu_put_page(vcpu, page, parent_pte);
+		kvm_mmu_put_page(page, parent_pte);
 		set_shadow_pte(parent_pte, 0);
 	}
-	kvm_mmu_page_unlink_children(vcpu, page);
+	kvm_mmu_page_unlink_children(kvm, page);
 	if (!page->root_count) {
 		hlist_del(&page->hash_link);
-		kvm_mmu_free_page(vcpu, page);
+		kvm_mmu_free_page(kvm, page);
 	} else
-		list_move(&page->link, &vcpu->kvm->active_mmu_pages);
+		list_move(&page->link, &kvm->active_mmu_pages);
 }
 
 static int kvm_mmu_unprotect_page(struct kvm_vcpu *vcpu, gfn_t gfn)
@@ -724,7 +711,7 @@ static int kvm_mmu_unprotect_page(struct kvm_vcpu *vcpu, gfn_t gfn)
 		if (page->gfn == gfn && !page->role.metaphysical) {
 			pgprintk("%s: gfn %lx role %x\n", __FUNCTION__, gfn,
 				 page->role.word);
-			kvm_mmu_zap_page(vcpu, page);
+			kvm_mmu_zap_page(vcpu->kvm, page);
 			r = 1;
 		}
 	return r;
@@ -737,7 +724,7 @@ static void mmu_unshadow(struct kvm_vcpu *vcpu, gfn_t gfn)
 	while ((page = kvm_mmu_lookup_page(vcpu, gfn)) != NULL) {
 		pgprintk("%s: zap %lx %x\n",
 			 __FUNCTION__, gfn, page->role.word);
-		kvm_mmu_zap_page(vcpu, page);
+		kvm_mmu_zap_page(vcpu->kvm, page);
 	}
 }
 
@@ -1089,10 +1076,10 @@ static void mmu_pte_write_zap_pte(struct kvm_vcpu *vcpu,
 	pte = *spte;
 	if (is_present_pte(pte)) {
 		if (page->role.level == PT_PAGE_TABLE_LEVEL)
-			rmap_remove(vcpu, spte);
+			rmap_remove(spte);
 		else {
 			child = page_header(pte & PT64_BASE_ADDR_MASK);
-			mmu_page_remove_parent_pte(vcpu, child, spte);
+			mmu_page_remove_parent_pte(child, spte);
 		}
 	}
 	*spte = 0;
@@ -1161,7 +1148,7 @@ void kvm_mmu_pte_write(struct kvm_vcpu *vcpu, gpa_t gpa,
 			 */
 			pgprintk("misaligned: gpa %llx bytes %d role %x\n",
 				 gpa, bytes, page->role.word);
-			kvm_mmu_zap_page(vcpu, page);
+			kvm_mmu_zap_page(vcpu->kvm, page);
 			continue;
 		}
 		page_offset = offset;
@@ -1207,7 +1194,7 @@ void kvm_mmu_free_some_pages(struct kvm_vcpu *vcpu)
 
 		page = container_of(vcpu->kvm->active_mmu_pages.prev,
 				    struct kvm_mmu_page, link);
-		kvm_mmu_zap_page(vcpu, page);
+		kvm_mmu_zap_page(vcpu->kvm, page);
 	}
 }
 EXPORT_SYMBOL_GPL(kvm_mmu_free_some_pages);
@@ -1219,7 +1206,7 @@ static void free_mmu_pages(struct kvm_vcpu *vcpu)
 	while (!list_empty(&vcpu->kvm->active_mmu_pages)) {
 		page = container_of(vcpu->kvm->active_mmu_pages.next,
 				    struct kvm_mmu_page, link);
-		kvm_mmu_zap_page(vcpu, page);
+		kvm_mmu_zap_page(vcpu->kvm, page);
 	}
 	free_page((unsigned long)vcpu->mmu.pae_root);
 }
@@ -1277,9 +1264,8 @@ void kvm_mmu_destroy(struct kvm_vcpu *vcpu)
 	mmu_free_memory_caches(vcpu);
 }
 
-void kvm_mmu_slot_remove_write_access(struct kvm_vcpu *vcpu, int slot)
+void kvm_mmu_slot_remove_write_access(struct kvm *kvm, int slot)
 {
-	struct kvm *kvm = vcpu->kvm;
 	struct kvm_mmu_page *page;
 
 	list_for_each_entry(page, &kvm->active_mmu_pages, link) {
@@ -1293,27 +1279,20 @@ void kvm_mmu_slot_remove_write_access(struct kvm_vcpu *vcpu, int slot)
 		for (i = 0; i < PT64_ENT_PER_PAGE; ++i)
 			/* avoid RMW */
 			if (pt[i] & PT_WRITABLE_MASK) {
-				rmap_remove(vcpu, &pt[i]);
+				rmap_remove(&pt[i]);
 				pt[i] &= ~PT_WRITABLE_MASK;
 			}
 	}
 }
 
-void kvm_mmu_zap_all(struct kvm_vcpu *vcpu)
+void kvm_mmu_zap_all(struct kvm *kvm)
 {
-	destroy_kvm_mmu(vcpu);
+	struct kvm_mmu_page *page, *node;
 
-	while (!list_empty(&vcpu->kvm->active_mmu_pages)) {
-		struct kvm_mmu_page *page;
-
-		page = container_of(vcpu->kvm->active_mmu_pages.next,
-				    struct kvm_mmu_page, link);
-		kvm_mmu_zap_page(vcpu, page);
-	}
+	list_for_each_entry_safe(page, node, &kvm->active_mmu_pages, link)
+		kvm_mmu_zap_page(kvm, page);
 
-	mmu_free_memory_caches(vcpu);
-	kvm_flush_remote_tlbs(vcpu->kvm);
-	init_kvm_mmu(vcpu);
+	kvm_flush_remote_tlbs(kvm);
 }
 
 void kvm_mmu_module_exit(void)

commit 35f3f28613bc7263949db23a4c7078e425810c8c
Author: Avi Kivity <avi@qumranet.com>
Date:   Tue Jul 17 14:20:30 2007 +0300

    KVM: x86 emulator: implement rdmsr and wrmsr
    
    Allow real-mode emulation of rdmsr and wrmsr.  This allows smp Windows to
    boot, presumably for its sipi trampoline.
    
    Signed-off-by: Avi Kivity <avi@qumranet.com>

diff --git a/drivers/kvm/kvm.h b/drivers/kvm/kvm.h
index 6636ae2..3ac9cbc 100644
--- a/drivers/kvm/kvm.h
+++ b/drivers/kvm/kvm.h
@@ -569,6 +569,8 @@ void realmode_lmsw(struct kvm_vcpu *vcpu, unsigned long msw,
 unsigned long realmode_get_cr(struct kvm_vcpu *vcpu, int cr);
 void realmode_set_cr(struct kvm_vcpu *vcpu, int cr, unsigned long value,
 		     unsigned long *rflags);
+int kvm_get_msr(struct kvm_vcpu *vcpu, u32 msr_index, u64 *data);
+int kvm_set_msr(struct kvm_vcpu *vcpu, u32 msr_index, u64 data);
 
 struct x86_emulate_ctxt;
 
diff --git a/drivers/kvm/kvm_main.c b/drivers/kvm/kvm_main.c
index 05f0418..bcbe683 100644
--- a/drivers/kvm/kvm_main.c
+++ b/drivers/kvm/kvm_main.c
@@ -1517,7 +1517,7 @@ EXPORT_SYMBOL_GPL(kvm_get_msr_common);
  * Returns 0 on success, non-0 otherwise.
  * Assumes vcpu_load() was already called.
  */
-static int get_msr(struct kvm_vcpu *vcpu, u32 msr_index, u64 *pdata)
+int kvm_get_msr(struct kvm_vcpu *vcpu, u32 msr_index, u64 *pdata)
 {
 	return kvm_arch_ops->get_msr(vcpu, msr_index, pdata);
 }
@@ -1595,7 +1595,7 @@ EXPORT_SYMBOL_GPL(kvm_set_msr_common);
  * Returns 0 on success, non-0 otherwise.
  * Assumes vcpu_load() was already called.
  */
-static int set_msr(struct kvm_vcpu *vcpu, u32 msr_index, u64 data)
+int kvm_set_msr(struct kvm_vcpu *vcpu, u32 msr_index, u64 data)
 {
 	return kvm_arch_ops->set_msr(vcpu, msr_index, data);
 }
@@ -2133,7 +2133,7 @@ static __init void kvm_init_msr_list(void)
  */
 static int do_set_msr(struct kvm_vcpu *vcpu, unsigned index, u64 *data)
 {
-	return set_msr(vcpu, index, *data);
+	return kvm_set_msr(vcpu, index, *data);
 }
 
 /*
@@ -2617,7 +2617,7 @@ static long kvm_vcpu_ioctl(struct file *filp,
 		break;
 	}
 	case KVM_GET_MSRS:
-		r = msr_io(vcpu, argp, get_msr, 1);
+		r = msr_io(vcpu, argp, kvm_get_msr, 1);
 		break;
 	case KVM_SET_MSRS:
 		r = msr_io(vcpu, argp, do_set_msr, 0);
diff --git a/drivers/kvm/x86_emulate.c b/drivers/kvm/x86_emulate.c
index f60012d..1b800fc 100644
--- a/drivers/kvm/x86_emulate.c
+++ b/drivers/kvm/x86_emulate.c
@@ -163,7 +163,7 @@ static u16 twobyte_table[256] = {
 	ModRM | ImplicitOps, ModRM, ModRM | ImplicitOps, ModRM, 0, 0, 0, 0,
 	0, 0, 0, 0, 0, 0, 0, 0,
 	/* 0x30 - 0x3F */
-	0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
+	ImplicitOps, 0, ImplicitOps, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
 	/* 0x40 - 0x47 */
 	DstReg | SrcMem | ModRM | Mov, DstReg | SrcMem | ModRM | Mov,
 	DstReg | SrcMem | ModRM | Mov, DstReg | SrcMem | ModRM | Mov,
@@ -486,6 +486,7 @@ x86_emulate_memop(struct x86_emulate_ctxt *ctxt, struct x86_emulate_ops *ops)
 	unsigned long modrm_ea;
 	int use_modrm_ea, index_reg = 0, base_reg = 0, scale, rip_relative = 0;
 	int no_wb = 0;
+	u64 msr_data;
 
 	/* Shadow copy of register state. Committed on successful emulation. */
 	unsigned long _regs[NR_VCPU_REGS];
@@ -1344,6 +1345,29 @@ twobyte_special_insn:
 			goto cannot_emulate;
 		realmode_set_cr(ctxt->vcpu, modrm_reg, modrm_val, &_eflags);
 		break;
+	case 0x30:
+		/* wrmsr */
+		msr_data = (u32)_regs[VCPU_REGS_RAX]
+			| ((u64)_regs[VCPU_REGS_RDX] << 32);
+		rc = kvm_set_msr(ctxt->vcpu, _regs[VCPU_REGS_RCX], msr_data);
+		if (rc) {
+			kvm_arch_ops->inject_gp(ctxt->vcpu, 0);
+			_eip = ctxt->vcpu->rip;
+		}
+		rc = X86EMUL_CONTINUE;
+		break;
+	case 0x32:
+		/* rdmsr */
+		rc = kvm_get_msr(ctxt->vcpu, _regs[VCPU_REGS_RCX], &msr_data);
+		if (rc) {
+			kvm_arch_ops->inject_gp(ctxt->vcpu, 0);
+			_eip = ctxt->vcpu->rip;
+		} else {
+			_regs[VCPU_REGS_RAX] = (u32)msr_data;
+			_regs[VCPU_REGS_RDX] = msr_data >> 32;
+		}
+		rc = X86EMUL_CONTINUE;
+		break;
 	case 0xc7:		/* Grp9 (cmpxchg8b) */
 		{
 			u64 old, new;

commit c1158e63dfeb3928e94c768f0a403b3e0e799f70
Author: Avi Kivity <avi@qumranet.com>
Date:   Fri Jul 20 08:18:27 2007 +0300

    KVM: MMU: Fix oopses with SLUB
    
    The kvm mmu uses page->private on shadow page tables; so does slub, and
    an oops result.  Fix by allocating regular pages for shadows instead of
    using slub.
    
    Tested-by: S.Çağlar Onur <caglar@pardus.org.tr>
    Signed-off-by: Avi Kivity <avi@qumranet.com>

diff --git a/drivers/kvm/mmu.c b/drivers/kvm/mmu.c
index 48d28f1..d99d2fe 100644
--- a/drivers/kvm/mmu.c
+++ b/drivers/kvm/mmu.c
@@ -154,7 +154,6 @@ struct kvm_rmap_desc {
 
 static struct kmem_cache *pte_chain_cache;
 static struct kmem_cache *rmap_desc_cache;
-static struct kmem_cache *mmu_page_cache;
 static struct kmem_cache *mmu_page_header_cache;
 
 static int is_write_protection(struct kvm_vcpu *vcpu)
@@ -225,6 +224,29 @@ static void mmu_free_memory_cache(struct kvm_mmu_memory_cache *mc)
 		kfree(mc->objects[--mc->nobjs]);
 }
 
+static int mmu_topup_memory_cache_page(struct kvm_mmu_memory_cache *cache,
+				       int min, gfp_t gfp_flags)
+{
+	struct page *page;
+
+	if (cache->nobjs >= min)
+		return 0;
+	while (cache->nobjs < ARRAY_SIZE(cache->objects)) {
+		page = alloc_page(gfp_flags);
+		if (!page)
+			return -ENOMEM;
+		set_page_private(page, 0);
+		cache->objects[cache->nobjs++] = page_address(page);
+	}
+	return 0;
+}
+
+static void mmu_free_memory_cache_page(struct kvm_mmu_memory_cache *mc)
+{
+	while (mc->nobjs)
+		__free_page(mc->objects[--mc->nobjs]);
+}
+
 static int __mmu_topup_memory_caches(struct kvm_vcpu *vcpu, gfp_t gfp_flags)
 {
 	int r;
@@ -237,8 +259,7 @@ static int __mmu_topup_memory_caches(struct kvm_vcpu *vcpu, gfp_t gfp_flags)
 				   rmap_desc_cache, 1, gfp_flags);
 	if (r)
 		goto out;
-	r = mmu_topup_memory_cache(&vcpu->mmu_page_cache,
-				   mmu_page_cache, 4, gfp_flags);
+	r = mmu_topup_memory_cache_page(&vcpu->mmu_page_cache, 4, gfp_flags);
 	if (r)
 		goto out;
 	r = mmu_topup_memory_cache(&vcpu->mmu_page_header_cache,
@@ -266,7 +287,7 @@ static void mmu_free_memory_caches(struct kvm_vcpu *vcpu)
 {
 	mmu_free_memory_cache(&vcpu->mmu_pte_chain_cache);
 	mmu_free_memory_cache(&vcpu->mmu_rmap_desc_cache);
-	mmu_free_memory_cache(&vcpu->mmu_page_cache);
+	mmu_free_memory_cache_page(&vcpu->mmu_page_cache);
 	mmu_free_memory_cache(&vcpu->mmu_page_header_cache);
 }
 
@@ -458,7 +479,7 @@ static void kvm_mmu_free_page(struct kvm *kvm,
 {
 	ASSERT(is_empty_shadow_page(page_head->spt));
 	list_del(&page_head->link);
-	kfree(page_head->spt);
+	__free_page(virt_to_page(page_head->spt));
 	kfree(page_head);
 	++kvm->n_free_mmu_pages;
 }
@@ -1301,8 +1322,6 @@ void kvm_mmu_module_exit(void)
 		kmem_cache_destroy(pte_chain_cache);
 	if (rmap_desc_cache)
 		kmem_cache_destroy(rmap_desc_cache);
-	if (mmu_page_cache)
-		kmem_cache_destroy(mmu_page_cache);
 	if (mmu_page_header_cache)
 		kmem_cache_destroy(mmu_page_header_cache);
 }
@@ -1320,12 +1339,6 @@ int kvm_mmu_module_init(void)
 	if (!rmap_desc_cache)
 		goto nomem;
 
-	mmu_page_cache = kmem_cache_create("kvm_mmu_page",
-					   PAGE_SIZE,
-					   PAGE_SIZE, 0, NULL);
-	if (!mmu_page_cache)
-		goto nomem;
-
 	mmu_page_header_cache = kmem_cache_create("kvm_mmu_page_header",
 						  sizeof(struct kvm_mmu_page),
 						  0, 0, NULL);
