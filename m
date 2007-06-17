Return-Path: <linux-kernel-owner+w=401wt.eu-S1761632AbXFQJ4t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761632AbXFQJ4t (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Jun 2007 05:56:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759694AbXFQJpU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Jun 2007 05:45:20 -0400
Received: from il.qumranet.com ([82.166.9.18]:55202 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759420AbXFQJot (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Jun 2007 05:44:49 -0400
From: Avi Kivity <avi@qumranet.com>
To: kvm-devel@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org, Avi Kivity <avi@qumranet.com>
Subject: [PATCH 45/58] KVM: Lazy guest cr3 switching
Date: Sun, 17 Jun 2007 12:44:26 +0300
Message-Id: <11820734812605-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.0.6
In-Reply-To: <1182073479890-git-send-email-avi@qumranet.com>
References: <1182073479890-git-send-email-avi@qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Switch guest paging context may require us to allocate memory, which
might fail.  Instead of wiring up error paths everywhere, make context
switching lazy and actually do the switch before the next guest entry,
where we can return an error if allocation fails.

Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 drivers/kvm/kvm.h |   10 ++++++++++
 drivers/kvm/mmu.c |   43 ++++++++++++++++++++++---------------------
 drivers/kvm/svm.c |    4 ++++
 drivers/kvm/vmx.c |    4 ++++
 4 files changed, 40 insertions(+), 21 deletions(-)

diff --git a/drivers/kvm/kvm.h b/drivers/kvm/kvm.h
index 199e1e9..3ec4e26 100644
--- a/drivers/kvm/kvm.h
+++ b/drivers/kvm/kvm.h
@@ -544,6 +544,8 @@ void kvm_mmu_pte_write(struct kvm_vcpu *vcpu, gpa_t gpa,
 		       const u8 *old, const u8 *new, int bytes);
 int kvm_mmu_unprotect_page_virt(struct kvm_vcpu *vcpu, gva_t gva);
 void kvm_mmu_free_some_pages(struct kvm_vcpu *vcpu);
+int kvm_mmu_load(struct kvm_vcpu *vcpu);
+void kvm_mmu_unload(struct kvm_vcpu *vcpu);
 
 int kvm_hypercall(struct kvm_vcpu *vcpu, struct kvm_run *run);
 
@@ -555,6 +557,14 @@ static inline int kvm_mmu_page_fault(struct kvm_vcpu *vcpu, gva_t gva,
 	return vcpu->mmu.page_fault(vcpu, gva, error_code);
 }
 
+static inline int kvm_mmu_reload(struct kvm_vcpu *vcpu)
+{
+	if (likely(vcpu->mmu.root_hpa != INVALID_PAGE))
+		return 0;
+
+	return kvm_mmu_load(vcpu);
+}
+
 static inline int is_long_mode(struct kvm_vcpu *vcpu)
 {
 #ifdef CONFIG_X86_64
diff --git a/drivers/kvm/mmu.c b/drivers/kvm/mmu.c
index 283df03..5915d7a 100644
--- a/drivers/kvm/mmu.c
+++ b/drivers/kvm/mmu.c
@@ -949,9 +949,7 @@ static int nonpaging_init_context(struct kvm_vcpu *vcpu)
 	context->free = nonpaging_free;
 	context->root_level = 0;
 	context->shadow_root_level = PT32E_ROOT_LEVEL;
-	mmu_alloc_roots(vcpu);
-	ASSERT(VALID_PAGE(context->root_hpa));
-	kvm_arch_ops->set_cr3(vcpu, context->root_hpa);
+	context->root_hpa = INVALID_PAGE;
 	return 0;
 }
 
@@ -965,11 +963,6 @@ static void paging_new_cr3(struct kvm_vcpu *vcpu)
 {
 	pgprintk("%s: cr3 %lx\n", __FUNCTION__, vcpu->cr3);
 	mmu_free_roots(vcpu);
-	if (unlikely(vcpu->kvm->n_free_mmu_pages < KVM_MIN_FREE_MMU_PAGES))
-		kvm_mmu_free_some_pages(vcpu);
-	mmu_alloc_roots(vcpu);
-	kvm_mmu_flush_tlb(vcpu);
-	kvm_arch_ops->set_cr3(vcpu, vcpu->mmu.root_hpa);
 }
 
 static void inject_page_fault(struct kvm_vcpu *vcpu,
@@ -1003,10 +996,7 @@ static int paging64_init_context_common(struct kvm_vcpu *vcpu, int level)
 	context->free = paging_free;
 	context->root_level = level;
 	context->shadow_root_level = level;
-	mmu_alloc_roots(vcpu);
-	ASSERT(VALID_PAGE(context->root_hpa));
-	kvm_arch_ops->set_cr3(vcpu, context->root_hpa |
-		    (vcpu->cr3 & (CR3_PCD_MASK | CR3_WPT_MASK)));
+	context->root_hpa = INVALID_PAGE;
 	return 0;
 }
 
@@ -1025,10 +1015,7 @@ static int paging32_init_context(struct kvm_vcpu *vcpu)
 	context->free = paging_free;
 	context->root_level = PT32_ROOT_LEVEL;
 	context->shadow_root_level = PT32E_ROOT_LEVEL;
-	mmu_alloc_roots(vcpu);
-	ASSERT(VALID_PAGE(context->root_hpa));
-	kvm_arch_ops->set_cr3(vcpu, context->root_hpa |
-		    (vcpu->cr3 & (CR3_PCD_MASK | CR3_WPT_MASK)));
+	context->root_hpa = INVALID_PAGE;
 	return 0;
 }
 
@@ -1042,7 +1029,6 @@ static int init_kvm_mmu(struct kvm_vcpu *vcpu)
 	ASSERT(vcpu);
 	ASSERT(!VALID_PAGE(vcpu->mmu.root_hpa));
 
-	mmu_topup_memory_caches(vcpu);
 	if (!is_paging(vcpu))
 		return nonpaging_init_context(vcpu);
 	else if (is_long_mode(vcpu))
@@ -1064,16 +1050,31 @@ static void destroy_kvm_mmu(struct kvm_vcpu *vcpu)
 
 int kvm_mmu_reset_context(struct kvm_vcpu *vcpu)
 {
+	destroy_kvm_mmu(vcpu);
+	return init_kvm_mmu(vcpu);
+}
+
+int kvm_mmu_load(struct kvm_vcpu *vcpu)
+{
 	int r;
 
-	destroy_kvm_mmu(vcpu);
-	r = init_kvm_mmu(vcpu);
-	if (r < 0)
-		goto out;
+	spin_lock(&vcpu->kvm->lock);
 	r = mmu_topup_memory_caches(vcpu);
+	if (r)
+		goto out;
+	mmu_alloc_roots(vcpu);
+	kvm_arch_ops->set_cr3(vcpu, vcpu->mmu.root_hpa);
+	kvm_mmu_flush_tlb(vcpu);
 out:
+	spin_unlock(&vcpu->kvm->lock);
 	return r;
 }
+EXPORT_SYMBOL_GPL(kvm_mmu_load);
+
+void kvm_mmu_unload(struct kvm_vcpu *vcpu)
+{
+	mmu_free_roots(vcpu);
+}
 
 static void mmu_pte_write_zap_pte(struct kvm_vcpu *vcpu,
 				  struct kvm_mmu_page *page,
diff --git a/drivers/kvm/svm.c b/drivers/kvm/svm.c
index 6cd6a50..ec040e2 100644
--- a/drivers/kvm/svm.c
+++ b/drivers/kvm/svm.c
@@ -1483,6 +1483,10 @@ static int svm_vcpu_run(struct kvm_vcpu *vcpu, struct kvm_run *kvm_run)
 	int r;
 
 again:
+	r = kvm_mmu_reload(vcpu);
+	if (unlikely(r))
+		return r;
+
 	if (!vcpu->mmio_read_completed)
 		do_interrupt_requests(vcpu, kvm_run);
 
diff --git a/drivers/kvm/vmx.c b/drivers/kvm/vmx.c
index 93e5bb2..4d25549 100644
--- a/drivers/kvm/vmx.c
+++ b/drivers/kvm/vmx.c
@@ -1988,6 +1988,10 @@ again:
 	vmx_save_host_state(vcpu);
 	kvm_load_guest_fpu(vcpu);
 
+	r = kvm_mmu_reload(vcpu);
+	if (unlikely(r))
+		goto out;
+
 	/*
 	 * Loading guest fpu may have cleared host cr0.ts
 	 */
-- 
1.5.0.6

