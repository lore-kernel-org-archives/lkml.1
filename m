Return-Path: <linux-kernel-owner+w=401wt.eu-S1759186AbYAFOni@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759186AbYAFOni (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jan 2008 09:43:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758270AbYAFOj5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Jan 2008 09:39:57 -0500
Received: from il.qumranet.com ([82.166.9.18]:46610 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755067AbYAFOjn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jan 2008 09:39:43 -0500
From: Avi Kivity <avi@qumranet.com>
To: linux-kernel@vger.kernel.org, kvm-devel@lists.sourceforge.net
Cc: Zhang Xiantao <xiantao.zhang@intel.com>
Subject: [PATCH 10/33] KVM: Portability: Move mmu-related fields to kvm_arch
Date: Sun,  6 Jan 2008 16:39:16 +0200
Message-Id: <1199630379-28638-11-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.3.7
In-Reply-To: <1199630379-28638-1-git-send-email-avi@qumranet.com>
References: <1199630379-28638-1-git-send-email-avi@qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Zhang Xiantao <xiantao.zhang@intel.com>

This patches moves mmu-related fields to kvm_arch.

Signed-off-by: Zhang Xiantao <xiantao.zhang@intel.com>
Acked-by: Carsten Otte <cotte@de.ibm.com>
Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 drivers/kvm/kvm.h |    8 -------
 drivers/kvm/mmu.c |   58 +++++++++++++++++++++++++++-------------------------
 drivers/kvm/mmu.h |    2 +-
 drivers/kvm/x86.c |    8 +++---
 drivers/kvm/x86.h |    9 ++++++++
 5 files changed, 44 insertions(+), 41 deletions(-)

diff --git a/drivers/kvm/kvm.h b/drivers/kvm/kvm.h
index bf5b85c..65de5e4 100644
--- a/drivers/kvm/kvm.h
+++ b/drivers/kvm/kvm.h
@@ -119,14 +119,6 @@ struct kvm {
 	int nmemslots;
 	struct kvm_memory_slot memslots[KVM_MEMORY_SLOTS +
 					KVM_PRIVATE_MEM_SLOTS];
-	/*
-	 * Hash table of struct kvm_mmu_page.
-	 */
-	struct list_head active_mmu_pages;
-	unsigned int n_free_mmu_pages;
-	unsigned int n_requested_mmu_pages;
-	unsigned int n_alloc_mmu_pages;
-	struct hlist_head mmu_page_hash[KVM_NUM_MMU_PAGES];
 	struct kvm_vcpu *vcpus[KVM_MAX_VCPUS];
 	struct list_head vm_list;
 	struct file *filp;
diff --git a/drivers/kvm/mmu.c b/drivers/kvm/mmu.c
index 1dc0e8c..c26d83f 100644
--- a/drivers/kvm/mmu.c
+++ b/drivers/kvm/mmu.c
@@ -553,7 +553,7 @@ static void kvm_mmu_free_page(struct kvm *kvm, struct kvm_mmu_page *sp)
 	__free_page(virt_to_page(sp->spt));
 	__free_page(virt_to_page(sp->gfns));
 	kfree(sp);
-	++kvm->n_free_mmu_pages;
+	++kvm->arch.n_free_mmu_pages;
 }
 
 static unsigned kvm_page_table_hashfn(gfn_t gfn)
@@ -566,19 +566,19 @@ static struct kvm_mmu_page *kvm_mmu_alloc_page(struct kvm_vcpu *vcpu,
 {
 	struct kvm_mmu_page *sp;
 
-	if (!vcpu->kvm->n_free_mmu_pages)
+	if (!vcpu->kvm->arch.n_free_mmu_pages)
 		return NULL;
 
 	sp = mmu_memory_cache_alloc(&vcpu->arch.mmu_page_header_cache, sizeof *sp);
 	sp->spt = mmu_memory_cache_alloc(&vcpu->arch.mmu_page_cache, PAGE_SIZE);
 	sp->gfns = mmu_memory_cache_alloc(&vcpu->arch.mmu_page_cache, PAGE_SIZE);
 	set_page_private(virt_to_page(sp->spt), (unsigned long)sp);
-	list_add(&sp->link, &vcpu->kvm->active_mmu_pages);
+	list_add(&sp->link, &vcpu->kvm->arch.active_mmu_pages);
 	ASSERT(is_empty_shadow_page(sp->spt));
 	sp->slot_bitmap = 0;
 	sp->multimapped = 0;
 	sp->parent_pte = parent_pte;
-	--vcpu->kvm->n_free_mmu_pages;
+	--vcpu->kvm->arch.n_free_mmu_pages;
 	return sp;
 }
 
@@ -666,7 +666,7 @@ static struct kvm_mmu_page *kvm_mmu_lookup_page(struct kvm *kvm, gfn_t gfn)
 
 	pgprintk("%s: looking for gfn %lx\n", __FUNCTION__, gfn);
 	index = kvm_page_table_hashfn(gfn) % KVM_NUM_MMU_PAGES;
-	bucket = &kvm->mmu_page_hash[index];
+	bucket = &kvm->arch.mmu_page_hash[index];
 	hlist_for_each_entry(sp, node, bucket, hash_link)
 		if (sp->gfn == gfn && !sp->role.metaphysical) {
 			pgprintk("%s: found role %x\n",
@@ -705,7 +705,7 @@ static struct kvm_mmu_page *kvm_mmu_get_page(struct kvm_vcpu *vcpu,
 	pgprintk("%s: looking gfn %lx role %x\n", __FUNCTION__,
 		 gfn, role.word);
 	index = kvm_page_table_hashfn(gfn) % KVM_NUM_MMU_PAGES;
-	bucket = &vcpu->kvm->mmu_page_hash[index];
+	bucket = &vcpu->kvm->arch.mmu_page_hash[index];
 	hlist_for_each_entry(sp, node, bucket, hash_link)
 		if (sp->gfn == gfn && sp->role.word == role.word) {
 			mmu_page_add_parent_pte(vcpu, sp, parent_pte);
@@ -796,7 +796,7 @@ static void kvm_mmu_zap_page(struct kvm *kvm, struct kvm_mmu_page *sp)
 		hlist_del(&sp->hash_link);
 		kvm_mmu_free_page(kvm, sp);
 	} else
-		list_move(&sp->link, &kvm->active_mmu_pages);
+		list_move(&sp->link, &kvm->arch.active_mmu_pages);
 	kvm_mmu_reset_last_pte_updated(kvm);
 }
 
@@ -812,26 +812,26 @@ void kvm_mmu_change_mmu_pages(struct kvm *kvm, unsigned int kvm_nr_mmu_pages)
 	 * change the value
 	 */
 
-	if ((kvm->n_alloc_mmu_pages - kvm->n_free_mmu_pages) >
+	if ((kvm->arch.n_alloc_mmu_pages - kvm->arch.n_free_mmu_pages) >
 	    kvm_nr_mmu_pages) {
-		int n_used_mmu_pages = kvm->n_alloc_mmu_pages
-				       - kvm->n_free_mmu_pages;
+		int n_used_mmu_pages = kvm->arch.n_alloc_mmu_pages
+				       - kvm->arch.n_free_mmu_pages;
 
 		while (n_used_mmu_pages > kvm_nr_mmu_pages) {
 			struct kvm_mmu_page *page;
 
-			page = container_of(kvm->active_mmu_pages.prev,
+			page = container_of(kvm->arch.active_mmu_pages.prev,
 					    struct kvm_mmu_page, link);
 			kvm_mmu_zap_page(kvm, page);
 			n_used_mmu_pages--;
 		}
-		kvm->n_free_mmu_pages = 0;
+		kvm->arch.n_free_mmu_pages = 0;
 	}
 	else
-		kvm->n_free_mmu_pages += kvm_nr_mmu_pages
-					 - kvm->n_alloc_mmu_pages;
+		kvm->arch.n_free_mmu_pages += kvm_nr_mmu_pages
+					 - kvm->arch.n_alloc_mmu_pages;
 
-	kvm->n_alloc_mmu_pages = kvm_nr_mmu_pages;
+	kvm->arch.n_alloc_mmu_pages = kvm_nr_mmu_pages;
 }
 
 static int kvm_mmu_unprotect_page(struct kvm *kvm, gfn_t gfn)
@@ -845,7 +845,7 @@ static int kvm_mmu_unprotect_page(struct kvm *kvm, gfn_t gfn)
 	pgprintk("%s: looking for gfn %lx\n", __FUNCTION__, gfn);
 	r = 0;
 	index = kvm_page_table_hashfn(gfn) % KVM_NUM_MMU_PAGES;
-	bucket = &kvm->mmu_page_hash[index];
+	bucket = &kvm->arch.mmu_page_hash[index];
 	hlist_for_each_entry_safe(sp, node, n, bucket, hash_link)
 		if (sp->gfn == gfn && !sp->role.metaphysical) {
 			pgprintk("%s: gfn %lx role %x\n", __FUNCTION__, gfn,
@@ -1362,7 +1362,7 @@ void kvm_mmu_pte_write(struct kvm_vcpu *vcpu, gpa_t gpa,
 		vcpu->arch.last_pte_updated = NULL;
 	}
 	index = kvm_page_table_hashfn(gfn) % KVM_NUM_MMU_PAGES;
-	bucket = &vcpu->kvm->mmu_page_hash[index];
+	bucket = &vcpu->kvm->arch.mmu_page_hash[index];
 	hlist_for_each_entry_safe(sp, node, n, bucket, hash_link) {
 		if (sp->gfn != gfn || sp->role.metaphysical)
 			continue;
@@ -1428,10 +1428,10 @@ int kvm_mmu_unprotect_page_virt(struct kvm_vcpu *vcpu, gva_t gva)
 
 void __kvm_mmu_free_some_pages(struct kvm_vcpu *vcpu)
 {
-	while (vcpu->kvm->n_free_mmu_pages < KVM_REFILL_PAGES) {
+	while (vcpu->kvm->arch.n_free_mmu_pages < KVM_REFILL_PAGES) {
 		struct kvm_mmu_page *sp;
 
-		sp = container_of(vcpu->kvm->active_mmu_pages.prev,
+		sp = container_of(vcpu->kvm->arch.active_mmu_pages.prev,
 				  struct kvm_mmu_page, link);
 		kvm_mmu_zap_page(vcpu->kvm, sp);
 		++vcpu->kvm->stat.mmu_recycled;
@@ -1482,8 +1482,8 @@ static void free_mmu_pages(struct kvm_vcpu *vcpu)
 {
 	struct kvm_mmu_page *sp;
 
-	while (!list_empty(&vcpu->kvm->active_mmu_pages)) {
-		sp = container_of(vcpu->kvm->active_mmu_pages.next,
+	while (!list_empty(&vcpu->kvm->arch.active_mmu_pages)) {
+		sp = container_of(vcpu->kvm->arch.active_mmu_pages.next,
 				  struct kvm_mmu_page, link);
 		kvm_mmu_zap_page(vcpu->kvm, sp);
 	}
@@ -1497,10 +1497,12 @@ static int alloc_mmu_pages(struct kvm_vcpu *vcpu)
 
 	ASSERT(vcpu);
 
-	if (vcpu->kvm->n_requested_mmu_pages)
-		vcpu->kvm->n_free_mmu_pages = vcpu->kvm->n_requested_mmu_pages;
+	if (vcpu->kvm->arch.n_requested_mmu_pages)
+		vcpu->kvm->arch.n_free_mmu_pages =
+					vcpu->kvm->arch.n_requested_mmu_pages;
 	else
-		vcpu->kvm->n_free_mmu_pages = vcpu->kvm->n_alloc_mmu_pages;
+		vcpu->kvm->arch.n_free_mmu_pages =
+					vcpu->kvm->arch.n_alloc_mmu_pages;
 	/*
 	 * When emulating 32-bit mode, cr3 is only 32 bits even on x86_64.
 	 * Therefore we need to allocate shadow page tables in the first
@@ -1549,7 +1551,7 @@ void kvm_mmu_slot_remove_write_access(struct kvm *kvm, int slot)
 {
 	struct kvm_mmu_page *sp;
 
-	list_for_each_entry(sp, &kvm->active_mmu_pages, link) {
+	list_for_each_entry(sp, &kvm->arch.active_mmu_pages, link) {
 		int i;
 		u64 *pt;
 
@@ -1568,7 +1570,7 @@ void kvm_mmu_zap_all(struct kvm *kvm)
 {
 	struct kvm_mmu_page *sp, *node;
 
-	list_for_each_entry_safe(sp, node, &kvm->active_mmu_pages, link)
+	list_for_each_entry_safe(sp, node, &kvm->arch.active_mmu_pages, link)
 		kvm_mmu_zap_page(kvm, sp);
 
 	kvm_flush_remote_tlbs(kvm);
@@ -1738,7 +1740,7 @@ static int count_writable_mappings(struct kvm_vcpu *vcpu)
 	struct kvm_mmu_page *sp;
 	int i;
 
-	list_for_each_entry(sp, &vcpu->kvm->active_mmu_pages, link) {
+	list_for_each_entry(sp, &vcpu->kvm->arch.active_mmu_pages, link) {
 		u64 *pt = sp->spt;
 
 		if (sp->role.level != PT_PAGE_TABLE_LEVEL)
@@ -1774,7 +1776,7 @@ static void audit_write_protection(struct kvm_vcpu *vcpu)
 	unsigned long *rmapp;
 	gfn_t gfn;
 
-	list_for_each_entry(sp, &vcpu->kvm->active_mmu_pages, link) {
+	list_for_each_entry(sp, &vcpu->kvm->arch.active_mmu_pages, link) {
 		if (sp->role.metaphysical)
 			continue;
 
diff --git a/drivers/kvm/mmu.h b/drivers/kvm/mmu.h
index 9ebfd1c..cbfc272 100644
--- a/drivers/kvm/mmu.h
+++ b/drivers/kvm/mmu.h
@@ -5,7 +5,7 @@
 
 static inline void kvm_mmu_free_some_pages(struct kvm_vcpu *vcpu)
 {
-	if (unlikely(vcpu->kvm->n_free_mmu_pages < KVM_MIN_FREE_MMU_PAGES))
+	if (unlikely(vcpu->kvm->arch.n_free_mmu_pages < KVM_MIN_FREE_MMU_PAGES))
 		__kvm_mmu_free_some_pages(vcpu);
 }
 
diff --git a/drivers/kvm/x86.c b/drivers/kvm/x86.c
index 7e1bd52..c0e95fb 100644
--- a/drivers/kvm/x86.c
+++ b/drivers/kvm/x86.c
@@ -1175,7 +1175,7 @@ static int kvm_vm_ioctl_set_nr_mmu_pages(struct kvm *kvm,
 	mutex_lock(&kvm->lock);
 
 	kvm_mmu_change_mmu_pages(kvm, kvm_nr_mmu_pages);
-	kvm->n_requested_mmu_pages = kvm_nr_mmu_pages;
+	kvm->arch.n_requested_mmu_pages = kvm_nr_mmu_pages;
 
 	mutex_unlock(&kvm->lock);
 	return 0;
@@ -1183,7 +1183,7 @@ static int kvm_vm_ioctl_set_nr_mmu_pages(struct kvm *kvm,
 
 static int kvm_vm_ioctl_get_nr_mmu_pages(struct kvm *kvm)
 {
-	return kvm->n_alloc_mmu_pages;
+	return kvm->arch.n_alloc_mmu_pages;
 }
 
 gfn_t unalias_gfn(struct kvm *kvm, gfn_t gfn)
@@ -3051,7 +3051,7 @@ struct  kvm *kvm_arch_create_vm(void)
 	if (!kvm)
 		return ERR_PTR(-ENOMEM);
 
-	INIT_LIST_HEAD(&kvm->active_mmu_pages);
+	INIT_LIST_HEAD(&kvm->arch.active_mmu_pages);
 
 	return kvm;
 }
@@ -3130,7 +3130,7 @@ int kvm_arch_set_memory_region(struct kvm *kvm,
 		}
 	}
 
-	if (!kvm->n_requested_mmu_pages) {
+	if (!kvm->arch.n_requested_mmu_pages) {
 		unsigned int nr_mmu_pages = kvm_mmu_calculate_mmu_pages(kvm);
 		kvm_mmu_change_mmu_pages(kvm, nr_mmu_pages);
 	}
diff --git a/drivers/kvm/x86.h b/drivers/kvm/x86.h
index be84f2b..5cdc366 100644
--- a/drivers/kvm/x86.h
+++ b/drivers/kvm/x86.h
@@ -266,6 +266,15 @@ struct kvm_mem_alias {
 struct kvm_arch{
 	int naliases;
 	struct kvm_mem_alias aliases[KVM_ALIAS_SLOTS];
+
+	unsigned int n_free_mmu_pages;
+	unsigned int n_requested_mmu_pages;
+	unsigned int n_alloc_mmu_pages;
+	struct hlist_head mmu_page_hash[KVM_NUM_MMU_PAGES];
+	/*
+	 * Hash table of struct kvm_mmu_page.
+	 */
+	struct list_head active_mmu_pages;
 };
 
 struct kvm_vcpu_stat {
-- 
1.5.3.7

