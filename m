Return-Path: <linux-kernel-owner+w=401wt.eu-S1758600AbZETL1B@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758600AbZETL1B (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 May 2009 07:27:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756801AbZETLUN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 May 2009 07:20:13 -0400
Received: from mx2.redhat.com ([66.187.237.31]:55283 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755666AbZETLSu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 May 2009 07:18:50 -0400
From: Avi Kivity <avi@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: kvm@vger.kernel.org
Subject: [PATCH 21/46] KVM: MMU: remove global page optimization logic
Date: Wed, 20 May 2009 14:18:18 +0300
Message-Id: <1242818323-10413-22-git-send-email-avi@redhat.com>
In-Reply-To: <1242818323-10413-1-git-send-email-avi@redhat.com>
References: <1242818323-10413-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Marcelo Tosatti <mtosatti@redhat.com>

Complexity to fix it not worthwhile the gains, as discussed
in http://article.gmane.org/gmane.comp.emulators.kvm.devel/28649.

Signed-off-by: Marcelo Tosatti <mtosatti@redhat.com>
Signed-off-by: Avi Kivity <avi@redhat.com>
---
 arch/x86/include/asm/kvm_host.h |    4 ---
 arch/x86/kvm/mmu.c              |   50 ++++----------------------------------
 arch/x86/kvm/paging_tmpl.h      |    6 +---
 arch/x86/kvm/x86.c              |    4 ---
 4 files changed, 8 insertions(+), 56 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 3fc4623..0e3a7c6 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -213,7 +213,6 @@ struct kvm_mmu_page {
 	int multimapped;         /* More than one parent_pte? */
 	int root_count;          /* Currently serving as active root */
 	bool unsync;
-	bool global;
 	unsigned int unsync_children;
 	union {
 		u64 *parent_pte;               /* !multimapped */
@@ -395,7 +394,6 @@ struct kvm_arch{
 	 */
 	struct list_head active_mmu_pages;
 	struct list_head assigned_dev_head;
-	struct list_head oos_global_pages;
 	struct iommu_domain *iommu_domain;
 	struct kvm_pic *vpic;
 	struct kvm_ioapic *vioapic;
@@ -425,7 +423,6 @@ struct kvm_vm_stat {
 	u32 mmu_recycled;
 	u32 mmu_cache_miss;
 	u32 mmu_unsync;
-	u32 mmu_unsync_global;
 	u32 remote_tlb_flush;
 	u32 lpages;
 };
@@ -640,7 +637,6 @@ void __kvm_mmu_free_some_pages(struct kvm_vcpu *vcpu);
 int kvm_mmu_load(struct kvm_vcpu *vcpu);
 void kvm_mmu_unload(struct kvm_vcpu *vcpu);
 void kvm_mmu_sync_roots(struct kvm_vcpu *vcpu);
-void kvm_mmu_sync_global(struct kvm_vcpu *vcpu);
 
 int kvm_emulate_hypercall(struct kvm_vcpu *vcpu);
 
diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index 409d08e..5b79afa 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -1075,18 +1075,10 @@ static struct kvm_mmu_page *kvm_mmu_lookup_page(struct kvm *kvm, gfn_t gfn)
 	return NULL;
 }
 
-static void kvm_unlink_unsync_global(struct kvm *kvm, struct kvm_mmu_page *sp)
-{
-	list_del(&sp->oos_link);
-	--kvm->stat.mmu_unsync_global;
-}
-
 static void kvm_unlink_unsync_page(struct kvm *kvm, struct kvm_mmu_page *sp)
 {
 	WARN_ON(!sp->unsync);
 	sp->unsync = 0;
-	if (sp->global)
-		kvm_unlink_unsync_global(kvm, sp);
 	--kvm->stat.mmu_unsync;
 }
 
@@ -1249,7 +1241,6 @@ static struct kvm_mmu_page *kvm_mmu_get_page(struct kvm_vcpu *vcpu,
 	pgprintk("%s: adding gfn %lx role %x\n", __func__, gfn, role.word);
 	sp->gfn = gfn;
 	sp->role = role;
-	sp->global = 0;
 	hlist_add_head(&sp->hash_link, bucket);
 	if (!direct) {
 		if (rmap_write_protect(vcpu->kvm, gfn))
@@ -1647,11 +1638,7 @@ static int kvm_unsync_page(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp)
 	++vcpu->kvm->stat.mmu_unsync;
 	sp->unsync = 1;
 
-	if (sp->global) {
-		list_add(&sp->oos_link, &vcpu->kvm->arch.oos_global_pages);
-		++vcpu->kvm->stat.mmu_unsync_global;
-	} else
-		kvm_mmu_mark_parents_unsync(vcpu, sp);
+	kvm_mmu_mark_parents_unsync(vcpu, sp);
 
 	mmu_convert_notrap(sp);
 	return 0;
@@ -1678,21 +1665,12 @@ static int mmu_need_write_protect(struct kvm_vcpu *vcpu, gfn_t gfn,
 static int set_spte(struct kvm_vcpu *vcpu, u64 *shadow_pte,
 		    unsigned pte_access, int user_fault,
 		    int write_fault, int dirty, int largepage,
-		    int global, gfn_t gfn, pfn_t pfn, bool speculative,
+		    gfn_t gfn, pfn_t pfn, bool speculative,
 		    bool can_unsync)
 {
 	u64 spte;
 	int ret = 0;
 	u64 mt_mask = shadow_mt_mask;
-	struct kvm_mmu_page *sp = page_header(__pa(shadow_pte));
-
-	if (!global && sp->global) {
-		sp->global = 0;
-		if (sp->unsync) {
-			kvm_unlink_unsync_global(vcpu->kvm, sp);
-			kvm_mmu_mark_parents_unsync(vcpu, sp);
-		}
-	}
 
 	/*
 	 * We don't set the accessed bit, since we sometimes want to see
@@ -1766,8 +1744,8 @@ set_pte:
 static void mmu_set_spte(struct kvm_vcpu *vcpu, u64 *shadow_pte,
 			 unsigned pt_access, unsigned pte_access,
 			 int user_fault, int write_fault, int dirty,
-			 int *ptwrite, int largepage, int global,
-			 gfn_t gfn, pfn_t pfn, bool speculative)
+			 int *ptwrite, int largepage, gfn_t gfn,
+			 pfn_t pfn, bool speculative)
 {
 	int was_rmapped = 0;
 	int was_writeble = is_writeble_pte(*shadow_pte);
@@ -1796,7 +1774,7 @@ static void mmu_set_spte(struct kvm_vcpu *vcpu, u64 *shadow_pte,
 			was_rmapped = 1;
 	}
 	if (set_spte(vcpu, shadow_pte, pte_access, user_fault, write_fault,
-		      dirty, largepage, global, gfn, pfn, speculative, true)) {
+		      dirty, largepage, gfn, pfn, speculative, true)) {
 		if (write_fault)
 			*ptwrite = 1;
 		kvm_x86_ops->tlb_flush(vcpu);
@@ -1844,7 +1822,7 @@ static int __direct_map(struct kvm_vcpu *vcpu, gpa_t v, int write,
 		    || (largepage && iterator.level == PT_DIRECTORY_LEVEL)) {
 			mmu_set_spte(vcpu, iterator.sptep, ACC_ALL, ACC_ALL,
 				     0, write, 1, &pt_write,
-				     largepage, 0, gfn, pfn, false);
+				     largepage, gfn, pfn, false);
 			++vcpu->stat.pf_fixed;
 			break;
 		}
@@ -2015,15 +1993,6 @@ static void mmu_sync_roots(struct kvm_vcpu *vcpu)
 	}
 }
 
-static void mmu_sync_global(struct kvm_vcpu *vcpu)
-{
-	struct kvm *kvm = vcpu->kvm;
-	struct kvm_mmu_page *sp, *n;
-
-	list_for_each_entry_safe(sp, n, &kvm->arch.oos_global_pages, oos_link)
-		kvm_sync_page(vcpu, sp);
-}
-
 void kvm_mmu_sync_roots(struct kvm_vcpu *vcpu)
 {
 	spin_lock(&vcpu->kvm->mmu_lock);
@@ -2031,13 +2000,6 @@ void kvm_mmu_sync_roots(struct kvm_vcpu *vcpu)
 	spin_unlock(&vcpu->kvm->mmu_lock);
 }
 
-void kvm_mmu_sync_global(struct kvm_vcpu *vcpu)
-{
-	spin_lock(&vcpu->kvm->mmu_lock);
-	mmu_sync_global(vcpu);
-	spin_unlock(&vcpu->kvm->mmu_lock);
-}
-
 static gpa_t nonpaging_gva_to_gpa(struct kvm_vcpu *vcpu, gva_t vaddr)
 {
 	return vaddr;
diff --git a/arch/x86/kvm/paging_tmpl.h b/arch/x86/kvm/paging_tmpl.h
index 09782a9..258e459 100644
--- a/arch/x86/kvm/paging_tmpl.h
+++ b/arch/x86/kvm/paging_tmpl.h
@@ -268,8 +268,7 @@ static void FNAME(update_pte)(struct kvm_vcpu *vcpu, struct kvm_mmu_page *page,
 	kvm_get_pfn(pfn);
 	mmu_set_spte(vcpu, spte, page->role.access, pte_access, 0, 0,
 		     gpte & PT_DIRTY_MASK, NULL, largepage,
-		     gpte & PT_GLOBAL_MASK, gpte_to_gfn(gpte),
-		     pfn, true);
+		     gpte_to_gfn(gpte), pfn, true);
 }
 
 /*
@@ -303,7 +302,6 @@ static u64 *FNAME(fetch)(struct kvm_vcpu *vcpu, gva_t addr,
 				     user_fault, write_fault,
 				     gw->ptes[gw->level-1] & PT_DIRTY_MASK,
 				     ptwrite, largepage,
-				     gw->ptes[gw->level-1] & PT_GLOBAL_MASK,
 				     gw->gfn, pfn, false);
 			break;
 		}
@@ -592,7 +590,7 @@ static int FNAME(sync_page)(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp)
 		nr_present++;
 		pte_access = sp->role.access & FNAME(gpte_access)(vcpu, gpte);
 		set_spte(vcpu, &sp->spt[i], pte_access, 0, 0,
-			 is_dirty_pte(gpte), 0, gpte & PT_GLOBAL_MASK, gfn,
+			 is_dirty_pte(gpte), 0, gfn,
 			 spte_to_pfn(sp->spt[i]), true, false);
 	}
 
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 95f1369..9b89d9b 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -108,7 +108,6 @@ struct kvm_stats_debugfs_item debugfs_entries[] = {
 	{ "mmu_recycled", VM_STAT(mmu_recycled) },
 	{ "mmu_cache_miss", VM_STAT(mmu_cache_miss) },
 	{ "mmu_unsync", VM_STAT(mmu_unsync) },
-	{ "mmu_unsync_global", VM_STAT(mmu_unsync_global) },
 	{ "remote_tlb_flush", VM_STAT(remote_tlb_flush) },
 	{ "largepages", VM_STAT(lpages) },
 	{ NULL }
@@ -322,7 +321,6 @@ void kvm_set_cr0(struct kvm_vcpu *vcpu, unsigned long cr0)
 	kvm_x86_ops->set_cr0(vcpu, cr0);
 	vcpu->arch.cr0 = cr0;
 
-	kvm_mmu_sync_global(vcpu);
 	kvm_mmu_reset_context(vcpu);
 	return;
 }
@@ -367,7 +365,6 @@ void kvm_set_cr4(struct kvm_vcpu *vcpu, unsigned long cr4)
 	kvm_x86_ops->set_cr4(vcpu, cr4);
 	vcpu->arch.cr4 = cr4;
 	vcpu->arch.mmu.base_role.cr4_pge = (cr4 & X86_CR4_PGE) && !tdp_enabled;
-	kvm_mmu_sync_global(vcpu);
 	kvm_mmu_reset_context(vcpu);
 }
 EXPORT_SYMBOL_GPL(kvm_set_cr4);
@@ -4360,7 +4357,6 @@ struct  kvm *kvm_arch_create_vm(void)
 		return ERR_PTR(-ENOMEM);
 
 	INIT_LIST_HEAD(&kvm->arch.active_mmu_pages);
-	INIT_LIST_HEAD(&kvm->arch.oos_global_pages);
 	INIT_LIST_HEAD(&kvm->arch.assigned_dev_head);
 
 	/* Reserve bit 0 of irq_sources_bitmap for userspace irq source */
-- 
1.6.0.6

