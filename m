Return-Path: <linux-kernel-owner+w=401wt.eu-S932738AbYDQJSY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932738AbYDQJSY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2008 05:18:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763102AbYDQJLQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Apr 2008 05:11:16 -0400
Received: from bzq-179-150-194.static.bezeqint.net ([212.179.150.194]:58975
	"EHLO il.qumranet.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760359AbYDQJLA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2008 05:11:00 -0400
From: Avi Kivity <avi@qumranet.com>
To: kvm-devel@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org, Izik Eidus <izike@qumranet.com>
Subject: [PATCH 19/45] KVM: MMU: allow the vm to shrink the kvm mmu shadow caches
Date: Thu, 17 Apr 2008 12:10:24 +0300
Message-Id: <1208423450-29415-20-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.5
In-Reply-To: <1208423450-29415-1-git-send-email-avi@qumranet.com>
References: <1208423450-29415-1-git-send-email-avi@qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Izik Eidus <izike@qumranet.com>

Allow the Linux memory manager to reclaim memory in the kvm shadow cache.

Signed-off-by: Izik Eidus <izike@qumranet.com>
Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 arch/x86/kvm/mmu.c |   58 ++++++++++++++++++++++++++++++++++++++++++++++++++-
 1 files changed, 56 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index c563283..1594ee0 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -1966,7 +1966,53 @@ void kvm_mmu_zap_all(struct kvm *kvm)
 	kvm_flush_remote_tlbs(kvm);
 }
 
-void kvm_mmu_module_exit(void)
+void kvm_mmu_remove_one_alloc_mmu_page(struct kvm *kvm)
+{
+	struct kvm_mmu_page *page;
+
+	page = container_of(kvm->arch.active_mmu_pages.prev,
+			    struct kvm_mmu_page, link);
+	kvm_mmu_zap_page(kvm, page);
+}
+
+static int mmu_shrink(int nr_to_scan, gfp_t gfp_mask)
+{
+	struct kvm *kvm;
+	struct kvm *kvm_freed = NULL;
+	int cache_count = 0;
+
+	spin_lock(&kvm_lock);
+
+	list_for_each_entry(kvm, &vm_list, vm_list) {
+		int npages;
+
+		spin_lock(&kvm->mmu_lock);
+		npages = kvm->arch.n_alloc_mmu_pages -
+			 kvm->arch.n_free_mmu_pages;
+		cache_count += npages;
+		if (!kvm_freed && nr_to_scan > 0 && npages > 0) {
+			kvm_mmu_remove_one_alloc_mmu_page(kvm);
+			cache_count--;
+			kvm_freed = kvm;
+		}
+		nr_to_scan--;
+
+		spin_unlock(&kvm->mmu_lock);
+	}
+	if (kvm_freed)
+		list_move_tail(&kvm_freed->vm_list, &vm_list);
+
+	spin_unlock(&kvm_lock);
+
+	return cache_count;
+}
+
+static struct shrinker mmu_shrinker = {
+	.shrink = mmu_shrink,
+	.seeks = DEFAULT_SEEKS * 10,
+};
+
+void mmu_destroy_caches(void)
 {
 	if (pte_chain_cache)
 		kmem_cache_destroy(pte_chain_cache);
@@ -1976,6 +2022,12 @@ void kvm_mmu_module_exit(void)
 		kmem_cache_destroy(mmu_page_header_cache);
 }
 
+void kvm_mmu_module_exit(void)
+{
+	mmu_destroy_caches();
+	unregister_shrinker(&mmu_shrinker);
+}
+
 int kvm_mmu_module_init(void)
 {
 	pte_chain_cache = kmem_cache_create("kvm_pte_chain",
@@ -1995,10 +2047,12 @@ int kvm_mmu_module_init(void)
 	if (!mmu_page_header_cache)
 		goto nomem;
 
+	register_shrinker(&mmu_shrinker);
+
 	return 0;
 
 nomem:
-	kvm_mmu_module_exit();
+	mmu_destroy_caches();
 	return -ENOMEM;
 }
 
-- 
1.5.5

