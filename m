Return-Path: <linux-kernel-owner+w=401wt.eu-S1755229AbXINR0Q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755229AbXINR0Q (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Sep 2007 13:26:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752846AbXINR0F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Sep 2007 13:26:05 -0400
Received: from il.qumranet.com ([82.166.9.18]:55334 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752653AbXINR0F (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Sep 2007 13:26:05 -0400
From: Avi Kivity <avi@qumranet.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: kvm-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       Avi Kivity <avi@qumranet.com>
Subject: [PATCH -rc][RESEND] KVM: MMU: Fix rare oops on guest context switch
Date: Fri, 14 Sep 2007 20:26:06 +0300
Message-Id: <11897907663574-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.3
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

A guest context switch to an uncached cr3 can require allocation of
shadow pages, but we only recycle shadow pages in kvm_mmu_page_fault().

Move shadow page recycling to mmu_topup_memory_caches(), which is called
from both the page fault handler and from guest cr3 reload.

Signed-off-by: Avi Kivity <avi@qumranet.com>
---

 drivers/kvm/kvm.h |   10 +++++++---
 drivers/kvm/mmu.c |    5 +++--
 2 files changed, 10 insertions(+), 5 deletions(-)

diff --git a/drivers/kvm/kvm.h b/drivers/kvm/kvm.h
index 3ac9cbc..336be86 100644
--- a/drivers/kvm/kvm.h
+++ b/drivers/kvm/kvm.h
@@ -619,7 +619,7 @@ unsigned long segment_base(u16 selector);
 void kvm_mmu_pte_write(struct kvm_vcpu *vcpu, gpa_t gpa,
 		       const u8 *old, const u8 *new, int bytes);
 int kvm_mmu_unprotect_page_virt(struct kvm_vcpu *vcpu, gva_t gva);
-void kvm_mmu_free_some_pages(struct kvm_vcpu *vcpu);
+void __kvm_mmu_free_some_pages(struct kvm_vcpu *vcpu);
 int kvm_mmu_load(struct kvm_vcpu *vcpu);
 void kvm_mmu_unload(struct kvm_vcpu *vcpu);
 
@@ -628,11 +628,15 @@ int kvm_hypercall(struct kvm_vcpu *vcpu, struct kvm_run *run);
 static inline int kvm_mmu_page_fault(struct kvm_vcpu *vcpu, gva_t gva,
 				     u32 error_code)
 {
-	if (unlikely(vcpu->kvm->n_free_mmu_pages < KVM_MIN_FREE_MMU_PAGES))
-		kvm_mmu_free_some_pages(vcpu);
 	return vcpu->mmu.page_fault(vcpu, gva, error_code);
 }
 
+static inline void kvm_mmu_free_some_pages(struct kvm_vcpu *vcpu)
+{
+	if (unlikely(vcpu->kvm->n_free_mmu_pages < KVM_MIN_FREE_MMU_PAGES))
+		__kvm_mmu_free_some_pages(vcpu);
+}
+
 static inline int kvm_mmu_reload(struct kvm_vcpu *vcpu)
 {
 	if (likely(vcpu->mmu.root_hpa != INVALID_PAGE))
diff --git a/drivers/kvm/mmu.c b/drivers/kvm/mmu.c
index 1a87ba9..23965aa 100644
--- a/drivers/kvm/mmu.c
+++ b/drivers/kvm/mmu.c
@@ -273,12 +273,14 @@ static int mmu_topup_memory_caches(struct kvm_vcpu *vcpu)
 	int r;
 
 	r = __mmu_topup_memory_caches(vcpu, GFP_NOWAIT);
+	kvm_mmu_free_some_pages(vcpu);
 	if (r < 0) {
 		spin_unlock(&vcpu->kvm->lock);
 		kvm_arch_ops->vcpu_put(vcpu);
 		r = __mmu_topup_memory_caches(vcpu, GFP_KERNEL);
 		kvm_arch_ops->vcpu_load(vcpu);
 		spin_lock(&vcpu->kvm->lock);
+		kvm_mmu_free_some_pages(vcpu);
 	}
 	return r;
 }
@@ -1208,7 +1210,7 @@ int kvm_mmu_unprotect_page_virt(struct kvm_vcpu *vcpu, gva_t gva)
 	return kvm_mmu_unprotect_page(vcpu, gpa >> PAGE_SHIFT);
 }
 
-void kvm_mmu_free_some_pages(struct kvm_vcpu *vcpu)
+void __kvm_mmu_free_some_pages(struct kvm_vcpu *vcpu)
 {
 	while (vcpu->kvm->n_free_mmu_pages < KVM_REFILL_PAGES) {
 		struct kvm_mmu_page *page;
@@ -1218,7 +1220,6 @@ void kvm_mmu_free_some_pages(struct kvm_vcpu *vcpu)
 		kvm_mmu_zap_page(vcpu->kvm, page);
 	}
 }
-EXPORT_SYMBOL_GPL(kvm_mmu_free_some_pages);
 
 static void free_mmu_pages(struct kvm_vcpu *vcpu)
 {
-- 
1.5.3

