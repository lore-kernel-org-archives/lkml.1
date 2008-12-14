Return-Path: <linux-kernel-owner+w=401wt.eu-S1757502AbYLNIRV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757502AbYLNIRV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Dec 2008 03:17:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754056AbYLNIID
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 14 Dec 2008 03:08:03 -0500
Received: from mx2.redhat.com ([66.187.237.31]:59935 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754086AbYLNIHR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Dec 2008 03:07:17 -0500
From: Avi Kivity <avi@redhat.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Marcelo Tosatti <mtosatti@redhat.com>
Subject: [PATCH 34/36] KVM: MMU: skip global pgtables on sync due to cr3 switch
Date: Sun, 14 Dec 2008 10:07:07 +0200
Message-Id: <1229242029-13410-35-git-send-email-avi@redhat.com>
In-Reply-To: <1229242029-13410-1-git-send-email-avi@redhat.com>
References: <1229242029-13410-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Marcelo Tosatti <mtosatti@redhat.com>

Skip syncing global pages on cr3 switch (but not on cr4/cr0). This is
important for Linux 32-bit guests with PAE, where the kmap page is
marked as global.

Signed-off-by: Marcelo Tosatti <mtosatti@redhat.com>
Signed-off-by: Avi Kivity <avi@redhat.com>
---
 arch/x86/include/asm/kvm_host.h |    6 ++++
 arch/x86/kvm/mmu.c              |   53 ++++++++++++++++++++++++++++++++++----
 arch/x86/kvm/paging_tmpl.h      |   10 ++++---
 arch/x86/kvm/x86.c              |    4 +++
 4 files changed, 63 insertions(+), 10 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 93d0aed..65b1ed2 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -182,6 +182,8 @@ struct kvm_mmu_page {
 	struct list_head link;
 	struct hlist_node hash_link;
 
+	struct list_head oos_link;
+
 	/*
 	 * The following two entries are used to key the shadow page in the
 	 * hash table.
@@ -200,6 +202,7 @@ struct kvm_mmu_page {
 	int multimapped;         /* More than one parent_pte? */
 	int root_count;          /* Currently serving as active root */
 	bool unsync;
+	bool global;
 	unsigned int unsync_children;
 	union {
 		u64 *parent_pte;               /* !multimapped */
@@ -356,6 +359,7 @@ struct kvm_arch{
 	 */
 	struct list_head active_mmu_pages;
 	struct list_head assigned_dev_head;
+	struct list_head oos_global_pages;
 	struct dmar_domain *intel_iommu_domain;
 	struct kvm_pic *vpic;
 	struct kvm_ioapic *vioapic;
@@ -385,6 +389,7 @@ struct kvm_vm_stat {
 	u32 mmu_recycled;
 	u32 mmu_cache_miss;
 	u32 mmu_unsync;
+	u32 mmu_unsync_global;
 	u32 remote_tlb_flush;
 	u32 lpages;
 };
@@ -603,6 +608,7 @@ void __kvm_mmu_free_some_pages(struct kvm_vcpu *vcpu);
 int kvm_mmu_load(struct kvm_vcpu *vcpu);
 void kvm_mmu_unload(struct kvm_vcpu *vcpu);
 void kvm_mmu_sync_roots(struct kvm_vcpu *vcpu);
+void kvm_mmu_sync_global(struct kvm_vcpu *vcpu);
 
 int kvm_emulate_hypercall(struct kvm_vcpu *vcpu);
 
diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index 58c35de..cbac9e4 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -793,9 +793,11 @@ static struct kvm_mmu_page *kvm_mmu_alloc_page(struct kvm_vcpu *vcpu,
 	sp->gfns = mmu_memory_cache_alloc(&vcpu->arch.mmu_page_cache, PAGE_SIZE);
 	set_page_private(virt_to_page(sp->spt), (unsigned long)sp);
 	list_add(&sp->link, &vcpu->kvm->arch.active_mmu_pages);
+	INIT_LIST_HEAD(&sp->oos_link);
 	ASSERT(is_empty_shadow_page(sp->spt));
 	bitmap_zero(sp->slot_bitmap, KVM_MEMORY_SLOTS + KVM_PRIVATE_MEM_SLOTS);
 	sp->multimapped = 0;
+	sp->global = 1;
 	sp->parent_pte = parent_pte;
 	--vcpu->kvm->arch.n_free_mmu_pages;
 	return sp;
@@ -1066,10 +1068,18 @@ static struct kvm_mmu_page *kvm_mmu_lookup_page(struct kvm *kvm, gfn_t gfn)
 	return NULL;
 }
 
+static void kvm_unlink_unsync_global(struct kvm *kvm, struct kvm_mmu_page *sp)
+{
+	list_del(&sp->oos_link);
+	--kvm->stat.mmu_unsync_global;
+}
+
 static void kvm_unlink_unsync_page(struct kvm *kvm, struct kvm_mmu_page *sp)
 {
 	WARN_ON(!sp->unsync);
 	sp->unsync = 0;
+	if (sp->global)
+		kvm_unlink_unsync_global(kvm, sp);
 	--kvm->stat.mmu_unsync;
 }
 
@@ -1615,9 +1625,15 @@ static int kvm_unsync_page(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp)
 		if (s->role.word != sp->role.word)
 			return 1;
 	}
-	kvm_mmu_mark_parents_unsync(vcpu, sp);
 	++vcpu->kvm->stat.mmu_unsync;
 	sp->unsync = 1;
+
+	if (sp->global) {
+		list_add(&sp->oos_link, &vcpu->kvm->arch.oos_global_pages);
+		++vcpu->kvm->stat.mmu_unsync_global;
+	} else
+		kvm_mmu_mark_parents_unsync(vcpu, sp);
+
 	mmu_convert_notrap(sp);
 	return 0;
 }
@@ -1643,12 +1659,21 @@ static int mmu_need_write_protect(struct kvm_vcpu *vcpu, gfn_t gfn,
 static int set_spte(struct kvm_vcpu *vcpu, u64 *shadow_pte,
 		    unsigned pte_access, int user_fault,
 		    int write_fault, int dirty, int largepage,
-		    gfn_t gfn, pfn_t pfn, bool speculative,
+		    int global, gfn_t gfn, pfn_t pfn, bool speculative,
 		    bool can_unsync)
 {
 	u64 spte;
 	int ret = 0;
 	u64 mt_mask = shadow_mt_mask;
+	struct kvm_mmu_page *sp = page_header(__pa(shadow_pte));
+
+	if (!global && sp->global) {
+		sp->global = 0;
+		if (sp->unsync) {
+			kvm_unlink_unsync_global(vcpu->kvm, sp);
+			kvm_mmu_mark_parents_unsync(vcpu, sp);
+		}
+	}
 
 	/*
 	 * We don't set the accessed bit, since we sometimes want to see
@@ -1717,8 +1742,8 @@ set_pte:
 static void mmu_set_spte(struct kvm_vcpu *vcpu, u64 *shadow_pte,
 			 unsigned pt_access, unsigned pte_access,
 			 int user_fault, int write_fault, int dirty,
-			 int *ptwrite, int largepage, gfn_t gfn,
-			 pfn_t pfn, bool speculative)
+			 int *ptwrite, int largepage, int global,
+			 gfn_t gfn, pfn_t pfn, bool speculative)
 {
 	int was_rmapped = 0;
 	int was_writeble = is_writeble_pte(*shadow_pte);
@@ -1751,7 +1776,7 @@ static void mmu_set_spte(struct kvm_vcpu *vcpu, u64 *shadow_pte,
 		}
 	}
 	if (set_spte(vcpu, shadow_pte, pte_access, user_fault, write_fault,
-		      dirty, largepage, gfn, pfn, speculative, true)) {
+		      dirty, largepage, global, gfn, pfn, speculative, true)) {
 		if (write_fault)
 			*ptwrite = 1;
 		kvm_x86_ops->tlb_flush(vcpu);
@@ -1808,7 +1833,7 @@ static int direct_map_entry(struct kvm_shadow_walk *_walk,
 	    || (walk->largepage && level == PT_DIRECTORY_LEVEL)) {
 		mmu_set_spte(vcpu, sptep, ACC_ALL, ACC_ALL,
 			     0, walk->write, 1, &walk->pt_write,
-			     walk->largepage, gfn, walk->pfn, false);
+			     walk->largepage, 0, gfn, walk->pfn, false);
 		++vcpu->stat.pf_fixed;
 		return 1;
 	}
@@ -1995,6 +2020,15 @@ static void mmu_sync_roots(struct kvm_vcpu *vcpu)
 	}
 }
 
+static void mmu_sync_global(struct kvm_vcpu *vcpu)
+{
+	struct kvm *kvm = vcpu->kvm;
+	struct kvm_mmu_page *sp, *n;
+
+	list_for_each_entry_safe(sp, n, &kvm->arch.oos_global_pages, oos_link)
+		kvm_sync_page(vcpu, sp);
+}
+
 void kvm_mmu_sync_roots(struct kvm_vcpu *vcpu)
 {
 	spin_lock(&vcpu->kvm->mmu_lock);
@@ -2002,6 +2036,13 @@ void kvm_mmu_sync_roots(struct kvm_vcpu *vcpu)
 	spin_unlock(&vcpu->kvm->mmu_lock);
 }
 
+void kvm_mmu_sync_global(struct kvm_vcpu *vcpu)
+{
+	spin_lock(&vcpu->kvm->mmu_lock);
+	mmu_sync_global(vcpu);
+	spin_unlock(&vcpu->kvm->mmu_lock);
+}
+
 static gpa_t nonpaging_gva_to_gpa(struct kvm_vcpu *vcpu, gva_t vaddr)
 {
 	return vaddr;
diff --git a/arch/x86/kvm/paging_tmpl.h b/arch/x86/kvm/paging_tmpl.h
index 84eee43..e644d81 100644
--- a/arch/x86/kvm/paging_tmpl.h
+++ b/arch/x86/kvm/paging_tmpl.h
@@ -274,7 +274,8 @@ static void FNAME(update_pte)(struct kvm_vcpu *vcpu, struct kvm_mmu_page *page,
 		return;
 	kvm_get_pfn(pfn);
 	mmu_set_spte(vcpu, spte, page->role.access, pte_access, 0, 0,
-		     gpte & PT_DIRTY_MASK, NULL, largepage, gpte_to_gfn(gpte),
+		     gpte & PT_DIRTY_MASK, NULL, largepage,
+		     gpte & PT_GLOBAL_MASK, gpte_to_gfn(gpte),
 		     pfn, true);
 }
 
@@ -301,8 +302,9 @@ static int FNAME(shadow_walk_entry)(struct kvm_shadow_walk *_sw,
 		mmu_set_spte(vcpu, sptep, access, gw->pte_access & access,
 			     sw->user_fault, sw->write_fault,
 			     gw->ptes[gw->level-1] & PT_DIRTY_MASK,
-			     sw->ptwrite, sw->largepage, gw->gfn, sw->pfn,
-			     false);
+			     sw->ptwrite, sw->largepage,
+			     gw->ptes[gw->level-1] & PT_GLOBAL_MASK,
+			     gw->gfn, sw->pfn, false);
 		sw->sptep = sptep;
 		return 1;
 	}
@@ -580,7 +582,7 @@ static int FNAME(sync_page)(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp)
 		nr_present++;
 		pte_access = sp->role.access & FNAME(gpte_access)(vcpu, gpte);
 		set_spte(vcpu, &sp->spt[i], pte_access, 0, 0,
-			 is_dirty_pte(gpte), 0, gfn,
+			 is_dirty_pte(gpte), 0, gpte & PT_GLOBAL_MASK, gfn,
 			 spte_to_pfn(sp->spt[i]), true, false);
 	}
 
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 7a2aeba..774db00 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -104,6 +104,7 @@ struct kvm_stats_debugfs_item debugfs_entries[] = {
 	{ "mmu_recycled", VM_STAT(mmu_recycled) },
 	{ "mmu_cache_miss", VM_STAT(mmu_cache_miss) },
 	{ "mmu_unsync", VM_STAT(mmu_unsync) },
+	{ "mmu_unsync_global", VM_STAT(mmu_unsync_global) },
 	{ "remote_tlb_flush", VM_STAT(remote_tlb_flush) },
 	{ "largepages", VM_STAT(lpages) },
 	{ NULL }
@@ -315,6 +316,7 @@ void kvm_set_cr0(struct kvm_vcpu *vcpu, unsigned long cr0)
 	kvm_x86_ops->set_cr0(vcpu, cr0);
 	vcpu->arch.cr0 = cr0;
 
+	kvm_mmu_sync_global(vcpu);
 	kvm_mmu_reset_context(vcpu);
 	return;
 }
@@ -358,6 +360,7 @@ void kvm_set_cr4(struct kvm_vcpu *vcpu, unsigned long cr4)
 	}
 	kvm_x86_ops->set_cr4(vcpu, cr4);
 	vcpu->arch.cr4 = cr4;
+	kvm_mmu_sync_global(vcpu);
 	kvm_mmu_reset_context(vcpu);
 }
 EXPORT_SYMBOL_GPL(kvm_set_cr4);
@@ -4113,6 +4116,7 @@ struct  kvm *kvm_arch_create_vm(void)
 		return ERR_PTR(-ENOMEM);
 
 	INIT_LIST_HEAD(&kvm->arch.active_mmu_pages);
+	INIT_LIST_HEAD(&kvm->arch.oos_global_pages);
 	INIT_LIST_HEAD(&kvm->arch.assigned_dev_head);
 
 	/* Reserve bit 0 of irq_sources_bitmap for userspace irq source */
-- 
1.6.0.3

