Return-Path: <linux-kernel-owner+w=401wt.eu-S933780AbXDZJ1s@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933780AbXDZJ1s (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2007 05:27:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933786AbXDZJ1Q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Apr 2007 05:27:16 -0400
Received: from il.qumranet.com ([82.166.9.18]:53029 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933780AbXDZJW0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2007 05:22:26 -0400
From: Avi Kivity <avi@qumranet.com>
To: kvm-devel@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org, Avi Kivity <avi@qumranet.com>
Subject: [PATCH 05/18] KVM: Use slab caches to allocate mmu data structures
Date: Thu, 26 Apr 2007 12:22:05 +0300
Message-Id: <11775793381079-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.0.6
In-Reply-To: <11775793382353-git-send-email-avi@qumranet.com>
References: <11775793382353-git-send-email-avi@qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Better leak detection, statistics, memory use, speed -- goodness all
around.

Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 drivers/kvm/kvm.h      |    3 +++
 drivers/kvm/kvm_main.c |    7 +++++++
 drivers/kvm/mmu.c      |   39 +++++++++++++++++++++++++++++++++++----
 3 files changed, 45 insertions(+), 4 deletions(-)

diff --git a/drivers/kvm/kvm.h b/drivers/kvm/kvm.h
index fceeb84..b9c318a 100644
--- a/drivers/kvm/kvm.h
+++ b/drivers/kvm/kvm.h
@@ -433,6 +433,9 @@ extern struct kvm_arch_ops *kvm_arch_ops;
 int kvm_init_arch(struct kvm_arch_ops *ops, struct module *module);
 void kvm_exit_arch(void);
 
+int kvm_mmu_module_init(void);
+void kvm_mmu_module_exit(void);
+
 void kvm_mmu_destroy(struct kvm_vcpu *vcpu);
 int kvm_mmu_create(struct kvm_vcpu *vcpu);
 int kvm_mmu_setup(struct kvm_vcpu *vcpu);
diff --git a/drivers/kvm/kvm_main.c b/drivers/kvm/kvm_main.c
index 0b30631..ab4dbd7 100644
--- a/drivers/kvm/kvm_main.c
+++ b/drivers/kvm/kvm_main.c
@@ -3063,6 +3063,10 @@ static __init int kvm_init(void)
 	static struct page *bad_page;
 	int r;
 
+	r = kvm_mmu_module_init();
+	if (r)
+		goto out4;
+
 	r = register_filesystem(&kvm_fs_type);
 	if (r)
 		goto out3;
@@ -3091,6 +3095,8 @@ out:
 out2:
 	unregister_filesystem(&kvm_fs_type);
 out3:
+	kvm_mmu_module_exit();
+out4:
 	return r;
 }
 
@@ -3100,6 +3106,7 @@ static __exit void kvm_exit(void)
 	__free_page(pfn_to_page(bad_page_address >> PAGE_SHIFT));
 	mntput(kvmfs_mnt);
 	unregister_filesystem(&kvm_fs_type);
+	kvm_mmu_module_exit();
 }
 
 module_init(kvm_init)
diff --git a/drivers/kvm/mmu.c b/drivers/kvm/mmu.c
index 9ff7480..a368ea8 100644
--- a/drivers/kvm/mmu.c
+++ b/drivers/kvm/mmu.c
@@ -159,6 +159,9 @@ struct kvm_rmap_desc {
 	struct kvm_rmap_desc *more;
 };
 
+static struct kmem_cache *pte_chain_cache;
+static struct kmem_cache *rmap_desc_cache;
+
 static int is_write_protection(struct kvm_vcpu *vcpu)
 {
 	return vcpu->cr0 & CR0_WP_MASK;
@@ -196,14 +199,14 @@ static int is_rmap_pte(u64 pte)
 }
 
 static int mmu_topup_memory_cache(struct kvm_mmu_memory_cache *cache,
-				  size_t objsize, int min)
+				  struct kmem_cache *base_cache, int min)
 {
 	void *obj;
 
 	if (cache->nobjs >= min)
 		return 0;
 	while (cache->nobjs < ARRAY_SIZE(cache->objects)) {
-		obj = kzalloc(objsize, GFP_NOWAIT);
+		obj = kmem_cache_zalloc(base_cache, GFP_NOWAIT);
 		if (!obj)
 			return -ENOMEM;
 		cache->objects[cache->nobjs++] = obj;
@@ -222,11 +225,11 @@ static int mmu_topup_memory_caches(struct kvm_vcpu *vcpu)
 	int r;
 
 	r = mmu_topup_memory_cache(&vcpu->mmu_pte_chain_cache,
-				   sizeof(struct kvm_pte_chain), 4);
+				   pte_chain_cache, 4);
 	if (r)
 		goto out;
 	r = mmu_topup_memory_cache(&vcpu->mmu_rmap_desc_cache,
-				   sizeof(struct kvm_rmap_desc), 1);
+				   rmap_desc_cache, 1);
 out:
 	return r;
 }
@@ -1333,6 +1336,34 @@ void kvm_mmu_zap_all(struct kvm_vcpu *vcpu)
 	init_kvm_mmu(vcpu);
 }
 
+void kvm_mmu_module_exit(void)
+{
+	if (pte_chain_cache)
+		kmem_cache_destroy(pte_chain_cache);
+	if (rmap_desc_cache)
+		kmem_cache_destroy(rmap_desc_cache);
+}
+
+int kvm_mmu_module_init(void)
+{
+	pte_chain_cache = kmem_cache_create("kvm_pte_chain",
+					    sizeof(struct kvm_pte_chain),
+					    0, 0, NULL, NULL);
+	if (!pte_chain_cache)
+		goto nomem;
+	rmap_desc_cache = kmem_cache_create("kvm_rmap_desc",
+					    sizeof(struct kvm_rmap_desc),
+					    0, 0, NULL, NULL);
+	if (!rmap_desc_cache)
+		goto nomem;
+
+	return 0;
+
+nomem:
+	kvm_mmu_module_exit();
+	return -ENOMEM;
+}
+
 #ifdef AUDIT
 
 static const char *audit_msg;
-- 
1.5.0.6

