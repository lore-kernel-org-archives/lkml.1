Return-Path: <linux-kernel-owner+w=401wt.eu-S1761297AbXFQJyB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761297AbXFQJyB (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Jun 2007 05:54:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759664AbXFQJpH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Jun 2007 05:45:07 -0400
Received: from il.qumranet.com ([82.166.9.18]:55207 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759194AbXFQJor (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Jun 2007 05:44:47 -0400
From: Avi Kivity <avi@qumranet.com>
To: kvm-devel@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org, Avi Kivity <avi@qumranet.com>
Subject: [PATCH 32/58] KVM: MMU: Use slab caches for shadow pages and their headers
Date: Sun, 17 Jun 2007 12:44:13 +0300
Message-Id: <11820734801148-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.0.6
In-Reply-To: <1182073479890-git-send-email-avi@qumranet.com>
References: <1182073479890-git-send-email-avi@qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Use slab caches instead of a simple custom list.

Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 drivers/kvm/kvm.h      |    4 +-
 drivers/kvm/kvm_main.c |    1 -
 drivers/kvm/mmu.c      |   64 +++++++++++++++++++++++++++++------------------
 3 files changed, 41 insertions(+), 28 deletions(-)

diff --git a/drivers/kvm/kvm.h b/drivers/kvm/kvm.h
index 90001b5..199e1e9 100644
--- a/drivers/kvm/kvm.h
+++ b/drivers/kvm/kvm.h
@@ -299,12 +299,12 @@ struct kvm_vcpu {
 	struct vmx_msr_entry *guest_msrs;
 	struct vmx_msr_entry *host_msrs;
 
-	struct list_head free_pages;
-	struct kvm_mmu_page page_header_buf[KVM_NUM_MMU_PAGES];
 	struct kvm_mmu mmu;
 
 	struct kvm_mmu_memory_cache mmu_pte_chain_cache;
 	struct kvm_mmu_memory_cache mmu_rmap_desc_cache;
+	struct kvm_mmu_memory_cache mmu_page_cache;
+	struct kvm_mmu_memory_cache mmu_page_header_cache;
 
 	gfn_t last_pt_write_gfn;
 	int   last_pt_write_count;
diff --git a/drivers/kvm/kvm_main.c b/drivers/kvm/kvm_main.c
index af07cd5..bf35457 100644
--- a/drivers/kvm/kvm_main.c
+++ b/drivers/kvm/kvm_main.c
@@ -326,7 +326,6 @@ static struct kvm *kvm_create_vm(void)
 		vcpu->cpu = -1;
 		vcpu->kvm = kvm;
 		vcpu->mmu.root_hpa = INVALID_PAGE;
-		INIT_LIST_HEAD(&vcpu->free_pages);
 		spin_lock(&kvm_lock);
 		list_add(&kvm->vm_list, &vm_list);
 		spin_unlock(&kvm_lock);
diff --git a/drivers/kvm/mmu.c b/drivers/kvm/mmu.c
index c85c664..46491b4 100644
--- a/drivers/kvm/mmu.c
+++ b/drivers/kvm/mmu.c
@@ -165,6 +165,8 @@ struct kvm_rmap_desc {
 
 static struct kmem_cache *pte_chain_cache;
 static struct kmem_cache *rmap_desc_cache;
+static struct kmem_cache *mmu_page_cache;
+static struct kmem_cache *mmu_page_header_cache;
 
 static int is_write_protection(struct kvm_vcpu *vcpu)
 {
@@ -235,6 +237,14 @@ static int __mmu_topup_memory_caches(struct kvm_vcpu *vcpu, gfp_t gfp_flags)
 		goto out;
 	r = mmu_topup_memory_cache(&vcpu->mmu_rmap_desc_cache,
 				   rmap_desc_cache, 1, gfp_flags);
+	if (r)
+		goto out;
+	r = mmu_topup_memory_cache(&vcpu->mmu_page_cache,
+				   mmu_page_cache, 4, gfp_flags);
+	if (r)
+		goto out;
+	r = mmu_topup_memory_cache(&vcpu->mmu_page_header_cache,
+				   mmu_page_header_cache, 4, gfp_flags);
 out:
 	return r;
 }
@@ -258,6 +268,8 @@ static void mmu_free_memory_caches(struct kvm_vcpu *vcpu)
 {
 	mmu_free_memory_cache(&vcpu->mmu_pte_chain_cache);
 	mmu_free_memory_cache(&vcpu->mmu_rmap_desc_cache);
+	mmu_free_memory_cache(&vcpu->mmu_page_cache);
+	mmu_free_memory_cache(&vcpu->mmu_page_header_cache);
 }
 
 static void *mmu_memory_cache_alloc(struct kvm_mmu_memory_cache *mc,
@@ -458,7 +470,9 @@ static void kvm_mmu_free_page(struct kvm_vcpu *vcpu,
 			      struct kvm_mmu_page *page_head)
 {
 	ASSERT(is_empty_shadow_page(page_head->spt));
-	list_move(&page_head->link, &vcpu->free_pages);
+	list_del(&page_head->link);
+	mmu_memory_cache_free(&vcpu->mmu_page_cache, page_head->spt);
+	mmu_memory_cache_free(&vcpu->mmu_page_header_cache, page_head);
 	++vcpu->kvm->n_free_mmu_pages;
 }
 
@@ -472,11 +486,14 @@ static struct kvm_mmu_page *kvm_mmu_alloc_page(struct kvm_vcpu *vcpu,
 {
 	struct kvm_mmu_page *page;
 
-	if (list_empty(&vcpu->free_pages))
+	if (!vcpu->kvm->n_free_mmu_pages)
 		return NULL;
 
-	page = list_entry(vcpu->free_pages.next, struct kvm_mmu_page, link);
-	list_move(&page->link, &vcpu->kvm->active_mmu_pages);
+	page = mmu_memory_cache_alloc(&vcpu->mmu_page_header_cache,
+				      sizeof *page);
+	page->spt = mmu_memory_cache_alloc(&vcpu->mmu_page_cache, PAGE_SIZE);
+	set_page_private(virt_to_page(page->spt), (unsigned long)page);
+	list_add(&page->link, &vcpu->kvm->active_mmu_pages);
 	ASSERT(is_empty_shadow_page(page->spt));
 	page->slot_bitmap = 0;
 	page->multimapped = 0;
@@ -1083,6 +1100,7 @@ static int init_kvm_mmu(struct kvm_vcpu *vcpu)
 	ASSERT(vcpu);
 	ASSERT(!VALID_PAGE(vcpu->mmu.root_hpa));
 
+	mmu_topup_memory_caches(vcpu);
 	if (!is_paging(vcpu))
 		return nonpaging_init_context(vcpu);
 	else if (is_long_mode(vcpu))
@@ -1256,13 +1274,6 @@ static void free_mmu_pages(struct kvm_vcpu *vcpu)
 				    struct kvm_mmu_page, link);
 		kvm_mmu_zap_page(vcpu, page);
 	}
-	while (!list_empty(&vcpu->free_pages)) {
-		page = list_entry(vcpu->free_pages.next,
-				  struct kvm_mmu_page, link);
-		list_del(&page->link);
-		free_page((unsigned long)page->spt);
-		page->spt = NULL;
-	}
 	free_page((unsigned long)vcpu->mmu.pae_root);
 }
 
@@ -1273,18 +1284,7 @@ static int alloc_mmu_pages(struct kvm_vcpu *vcpu)
 
 	ASSERT(vcpu);
 
-	for (i = 0; i < KVM_NUM_MMU_PAGES; i++) {
-		struct kvm_mmu_page *page_header = &vcpu->page_header_buf[i];
-
-		INIT_LIST_HEAD(&page_header->link);
-		if ((page = alloc_page(GFP_KERNEL)) == NULL)
-			goto error_1;
-		set_page_private(page, (unsigned long)page_header);
-		page_header->spt = page_address(page);
-		memset(page_header->spt, 0, PAGE_SIZE);
-		list_add(&page_header->link, &vcpu->free_pages);
-		++vcpu->kvm->n_free_mmu_pages;
-	}
+	vcpu->kvm->n_free_mmu_pages = KVM_NUM_MMU_PAGES;
 
 	/*
 	 * When emulating 32-bit mode, cr3 is only 32 bits even on x86_64.
@@ -1309,7 +1309,6 @@ int kvm_mmu_create(struct kvm_vcpu *vcpu)
 {
 	ASSERT(vcpu);
 	ASSERT(!VALID_PAGE(vcpu->mmu.root_hpa));
-	ASSERT(list_empty(&vcpu->free_pages));
 
 	return alloc_mmu_pages(vcpu);
 }
@@ -1318,7 +1317,6 @@ int kvm_mmu_setup(struct kvm_vcpu *vcpu)
 {
 	ASSERT(vcpu);
 	ASSERT(!VALID_PAGE(vcpu->mmu.root_hpa));
-	ASSERT(!list_empty(&vcpu->free_pages));
 
 	return init_kvm_mmu(vcpu);
 }
@@ -1377,6 +1375,10 @@ void kvm_mmu_module_exit(void)
 		kmem_cache_destroy(pte_chain_cache);
 	if (rmap_desc_cache)
 		kmem_cache_destroy(rmap_desc_cache);
+	if (mmu_page_cache)
+		kmem_cache_destroy(mmu_page_cache);
+	if (mmu_page_header_cache)
+		kmem_cache_destroy(mmu_page_header_cache);
 }
 
 int kvm_mmu_module_init(void)
@@ -1392,6 +1394,18 @@ int kvm_mmu_module_init(void)
 	if (!rmap_desc_cache)
 		goto nomem;
 
+	mmu_page_cache = kmem_cache_create("kvm_mmu_page",
+					   PAGE_SIZE,
+					   PAGE_SIZE, 0, NULL, NULL);
+	if (!mmu_page_cache)
+		goto nomem;
+
+	mmu_page_header_cache = kmem_cache_create("kvm_mmu_page_header",
+						  sizeof(struct kvm_mmu_page),
+						  0, 0, NULL, NULL);
+	if (!mmu_page_header_cache)
+		goto nomem;
+
 	return 0;
 
 nomem:
-- 
1.5.0.6

