Return-Path: <linux-kernel-owner+w=401wt.eu-S1757683AbXIQIuv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757683AbXIQIuv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2007 04:50:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754835AbXIQIdW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Sep 2007 04:33:22 -0400
Received: from il.qumranet.com ([82.166.9.18]:45281 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754563AbXIQIcf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2007 04:32:35 -0400
From: Avi Kivity <avi@qumranet.com>
To: kvm-devel@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org, Avi Kivity <avi@qumranet.com>
Subject: [PATCH 089/104] KVM: MMU: Don't do GFP_NOWAIT allocations
Date: Mon, 17 Sep 2007 10:32:11 +0200
Message-Id: <11900179493572-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.3
In-Reply-To: <11900179463203-git-send-email-avi@qumranet.com>
References: <11900179463203-git-send-email-avi@qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Before preempt notifiers, kvm needed to allocate memory with GFP_NOWAIT so
as not to have to enable preemption and take a heavyweight exit.  On oom, we'd
fall back to a GFP_KERNEL allocation.

With preemption notifiers, we can do a GFP_KERNEL allocation, and perform
the heavyweight exit only if the kernel decides to put us to sleep.

Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 drivers/kvm/mmu.c |   34 ++++++++++------------------------
 1 files changed, 10 insertions(+), 24 deletions(-)

diff --git a/drivers/kvm/mmu.c b/drivers/kvm/mmu.c
index 7b42c88..6d84d30 100644
--- a/drivers/kvm/mmu.c
+++ b/drivers/kvm/mmu.c
@@ -202,15 +202,14 @@ static void set_shadow_pte(u64 *sptep, u64 spte)
 }
 
 static int mmu_topup_memory_cache(struct kvm_mmu_memory_cache *cache,
-				  struct kmem_cache *base_cache, int min,
-				  gfp_t gfp_flags)
+				  struct kmem_cache *base_cache, int min)
 {
 	void *obj;
 
 	if (cache->nobjs >= min)
 		return 0;
 	while (cache->nobjs < ARRAY_SIZE(cache->objects)) {
-		obj = kmem_cache_zalloc(base_cache, gfp_flags);
+		obj = kmem_cache_zalloc(base_cache, GFP_KERNEL);
 		if (!obj)
 			return -ENOMEM;
 		cache->objects[cache->nobjs++] = obj;
@@ -225,14 +224,14 @@ static void mmu_free_memory_cache(struct kvm_mmu_memory_cache *mc)
 }
 
 static int mmu_topup_memory_cache_page(struct kvm_mmu_memory_cache *cache,
-				       int min, gfp_t gfp_flags)
+				       int min)
 {
 	struct page *page;
 
 	if (cache->nobjs >= min)
 		return 0;
 	while (cache->nobjs < ARRAY_SIZE(cache->objects)) {
-		page = alloc_page(gfp_flags);
+		page = alloc_page(GFP_KERNEL);
 		if (!page)
 			return -ENOMEM;
 		set_page_private(page, 0);
@@ -247,41 +246,28 @@ static void mmu_free_memory_cache_page(struct kvm_mmu_memory_cache *mc)
 		free_page((unsigned long)mc->objects[--mc->nobjs]);
 }
 
-static int __mmu_topup_memory_caches(struct kvm_vcpu *vcpu, gfp_t gfp_flags)
+static int mmu_topup_memory_caches(struct kvm_vcpu *vcpu)
 {
 	int r;
 
+	kvm_mmu_free_some_pages(vcpu);
 	r = mmu_topup_memory_cache(&vcpu->mmu_pte_chain_cache,
-				   pte_chain_cache, 4, gfp_flags);
+				   pte_chain_cache, 4);
 	if (r)
 		goto out;
 	r = mmu_topup_memory_cache(&vcpu->mmu_rmap_desc_cache,
-				   rmap_desc_cache, 1, gfp_flags);
+				   rmap_desc_cache, 1);
 	if (r)
 		goto out;
-	r = mmu_topup_memory_cache_page(&vcpu->mmu_page_cache, 4, gfp_flags);
+	r = mmu_topup_memory_cache_page(&vcpu->mmu_page_cache, 4);
 	if (r)
 		goto out;
 	r = mmu_topup_memory_cache(&vcpu->mmu_page_header_cache,
-				   mmu_page_header_cache, 4, gfp_flags);
+				   mmu_page_header_cache, 4);
 out:
 	return r;
 }
 
-static int mmu_topup_memory_caches(struct kvm_vcpu *vcpu)
-{
-	int r;
-
-	r = __mmu_topup_memory_caches(vcpu, GFP_NOWAIT);
-	kvm_mmu_free_some_pages(vcpu);
-	if (r < 0) {
-		mutex_unlock(&vcpu->kvm->lock);
-		r = __mmu_topup_memory_caches(vcpu, GFP_KERNEL);
-		mutex_lock(&vcpu->kvm->lock);
-	}
-	return r;
-}
-
 static void mmu_free_memory_caches(struct kvm_vcpu *vcpu)
 {
 	mmu_free_memory_cache(&vcpu->mmu_pte_chain_cache);
-- 
1.5.3

