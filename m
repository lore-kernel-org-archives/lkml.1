Return-Path: <linux-kernel-owner+w=401wt.eu-S933843AbXDZJ1s@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933843AbXDZJ1s (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2007 05:27:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933780AbXDZJ1S
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Apr 2007 05:27:18 -0400
Received: from il.qumranet.com ([82.166.9.18]:53030 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933782AbXDZJW0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2007 05:22:26 -0400
From: Avi Kivity <avi@qumranet.com>
To: kvm-devel@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org, Avi Kivity <avi@qumranet.com>
Subject: [PATCH 06/18] KVM: Retry sleeping allocation if atomic allocation fails
Date: Thu, 26 Apr 2007 12:22:06 +0300
Message-Id: <1177579338198-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.0.6
In-Reply-To: <11775793382353-git-send-email-avi@qumranet.com>
References: <11775793382353-git-send-email-avi@qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This avoids -ENOMEM under memory pressure.

Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 drivers/kvm/mmu.c |   26 +++++++++++++++++++++-----
 1 files changed, 21 insertions(+), 5 deletions(-)

diff --git a/drivers/kvm/mmu.c b/drivers/kvm/mmu.c
index a368ea8..c814394 100644
--- a/drivers/kvm/mmu.c
+++ b/drivers/kvm/mmu.c
@@ -199,14 +199,15 @@ static int is_rmap_pte(u64 pte)
 }
 
 static int mmu_topup_memory_cache(struct kvm_mmu_memory_cache *cache,
-				  struct kmem_cache *base_cache, int min)
+				  struct kmem_cache *base_cache, int min,
+				  gfp_t gfp_flags)
 {
 	void *obj;
 
 	if (cache->nobjs >= min)
 		return 0;
 	while (cache->nobjs < ARRAY_SIZE(cache->objects)) {
-		obj = kmem_cache_zalloc(base_cache, GFP_NOWAIT);
+		obj = kmem_cache_zalloc(base_cache, gfp_flags);
 		if (!obj)
 			return -ENOMEM;
 		cache->objects[cache->nobjs++] = obj;
@@ -220,20 +221,35 @@ static void mmu_free_memory_cache(struct kvm_mmu_memory_cache *mc)
 		kfree(mc->objects[--mc->nobjs]);
 }
 
-static int mmu_topup_memory_caches(struct kvm_vcpu *vcpu)
+static int __mmu_topup_memory_caches(struct kvm_vcpu *vcpu, gfp_t gfp_flags)
 {
 	int r;
 
 	r = mmu_topup_memory_cache(&vcpu->mmu_pte_chain_cache,
-				   pte_chain_cache, 4);
+				   pte_chain_cache, 4, gfp_flags);
 	if (r)
 		goto out;
 	r = mmu_topup_memory_cache(&vcpu->mmu_rmap_desc_cache,
-				   rmap_desc_cache, 1);
+				   rmap_desc_cache, 1, gfp_flags);
 out:
 	return r;
 }
 
+static int mmu_topup_memory_caches(struct kvm_vcpu *vcpu)
+{
+	int r;
+
+	r = __mmu_topup_memory_caches(vcpu, GFP_NOWAIT);
+	if (r < 0) {
+		spin_unlock(&vcpu->kvm->lock);
+		kvm_arch_ops->vcpu_put(vcpu);
+		r = __mmu_topup_memory_caches(vcpu, GFP_KERNEL);
+		kvm_arch_ops->vcpu_load(vcpu);
+		spin_lock(&vcpu->kvm->lock);
+	}
+	return r;
+}
+
 static void mmu_free_memory_caches(struct kvm_vcpu *vcpu)
 {
 	mmu_free_memory_cache(&vcpu->mmu_pte_chain_cache);
-- 
1.5.0.6

