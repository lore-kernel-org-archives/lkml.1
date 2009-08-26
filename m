Return-Path: <linux-kernel-owner+w=401wt.eu-S1757217AbZHZKaX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757217AbZHZKaX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Aug 2009 06:30:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757126AbZHZKaU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Aug 2009 06:30:20 -0400
Received: from mx1.redhat.com ([209.132.183.28]:19842 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757083AbZHZKaN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Aug 2009 06:30:13 -0400
From: Avi Kivity <avi@redhat.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 22/47] KVM: SVM: get rid of nested_svm_vmexit_real
Date: Wed, 26 Aug 2009 13:29:44 +0300
Message-Id: <1251282609-12835-23-git-send-email-avi@redhat.com>
In-Reply-To: <1251282609-12835-1-git-send-email-avi@redhat.com>
References: <1251282609-12835-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Joerg Roedel <joerg.roedel@amd.com>

This patch is the starting point of removing nested_svm_do from the
nested svm code. The nested_svm_do function basically maps two guest
physical pages to host virtual addresses and calls a passed function
on it. This function pointer code flow is hard to read and not the
best technical solution here.
As a side effect this patch indroduces the nested_svm_[un]map helper
functions.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
Signed-off-by: Avi Kivity <avi@redhat.com>
---
 arch/x86/kvm/svm.c |   52 ++++++++++++++++++++++++++++++++++++++++------------
 1 files changed, 40 insertions(+), 12 deletions(-)

diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index 67fad66..5e55a1b 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -1390,6 +1390,39 @@ static inline int nested_svm_intr(struct vcpu_svm *svm)
 	return 0;
 }
 
+static void *nested_svm_map(struct vcpu_svm *svm, u64 gpa, enum km_type idx)
+{
+	struct page *page;
+
+	down_read(&current->mm->mmap_sem);
+	page = gfn_to_page(svm->vcpu.kvm, gpa >> PAGE_SHIFT);
+	up_read(&current->mm->mmap_sem);
+
+	if (is_error_page(page))
+		goto error;
+
+	return kmap_atomic(page, idx);
+
+error:
+	kvm_release_page_clean(page);
+	kvm_inject_gp(&svm->vcpu, 0);
+
+	return NULL;
+}
+
+static void nested_svm_unmap(void *addr, enum km_type idx)
+{
+	struct page *page;
+
+	if (!addr)
+		return;
+
+	page = kmap_atomic_to_page(addr);
+
+	kunmap_atomic(addr, idx);
+	kvm_release_page_dirty(page);
+}
+
 static struct page *nested_svm_get_page(struct vcpu_svm *svm, u64 gpa)
 {
 	struct page *page;
@@ -1597,13 +1630,16 @@ static inline void copy_vmcb_control_area(struct vmcb *dst_vmcb, struct vmcb *fr
 	dst->lbr_ctl              = from->lbr_ctl;
 }
 
-static int nested_svm_vmexit_real(struct vcpu_svm *svm, void *arg1,
-				  void *arg2, void *opaque)
+static int nested_svm_vmexit(struct vcpu_svm *svm)
 {
-	struct vmcb *nested_vmcb = (struct vmcb *)arg1;
+	struct vmcb *nested_vmcb;
 	struct vmcb *hsave = svm->nested.hsave;
 	struct vmcb *vmcb = svm->vmcb;
 
+	nested_vmcb = nested_svm_map(svm, svm->nested.vmcb, KM_USER0);
+	if (!nested_vmcb)
+		return 1;
+
 	/* Give the current vmcb to the guest */
 	disable_gif(svm);
 
@@ -1678,15 +1714,7 @@ static int nested_svm_vmexit_real(struct vcpu_svm *svm, void *arg1,
 	/* Exit nested SVM mode */
 	svm->nested.vmcb = 0;
 
-	return 0;
-}
-
-static int nested_svm_vmexit(struct vcpu_svm *svm)
-{
-	nsvm_printk("VMexit\n");
-	if (nested_svm_do(svm, svm->nested.vmcb, 0,
-			  NULL, nested_svm_vmexit_real))
-		return 1;
+	nested_svm_unmap(nested_vmcb, KM_USER0);
 
 	kvm_mmu_reset_context(&svm->vcpu);
 	kvm_mmu_load(&svm->vcpu);
-- 
1.6.4.1

