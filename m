Return-Path: <linux-kernel-owner+w=401wt.eu-S932399AbZHZKbv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932399AbZHZKbv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Aug 2009 06:31:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932143AbZHZKbt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Aug 2009 06:31:49 -0400
Received: from mx1.redhat.com ([209.132.183.28]:55670 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757137AbZHZKaP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Aug 2009 06:30:15 -0400
From: Avi Kivity <avi@redhat.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 26/47] KVM: SVM: remove nested_svm_do and helper functions
Date: Wed, 26 Aug 2009 13:29:48 +0300
Message-Id: <1251282609-12835-27-git-send-email-avi@redhat.com>
In-Reply-To: <1251282609-12835-1-git-send-email-avi@redhat.com>
References: <1251282609-12835-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Joerg Roedel <joerg.roedel@amd.com>

This function is not longer required. So remove it.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
Signed-off-by: Avi Kivity <avi@redhat.com>
---
 arch/x86/kvm/svm.c |   60 ----------------------------------------------------
 1 files changed, 0 insertions(+), 60 deletions(-)

diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index 1a915f3..42b8b67 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -1421,66 +1421,6 @@ static void nested_svm_unmap(void *addr, enum km_type idx)
 	kvm_release_page_dirty(page);
 }
 
-static struct page *nested_svm_get_page(struct vcpu_svm *svm, u64 gpa)
-{
-	struct page *page;
-
-	down_read(&current->mm->mmap_sem);
-	page = gfn_to_page(svm->vcpu.kvm, gpa >> PAGE_SHIFT);
-	up_read(&current->mm->mmap_sem);
-
-	if (is_error_page(page)) {
-		printk(KERN_INFO "%s: could not find page at 0x%llx\n",
-		       __func__, gpa);
-		kvm_release_page_clean(page);
-		kvm_inject_gp(&svm->vcpu, 0);
-		return NULL;
-	}
-	return page;
-}
-
-static int nested_svm_do(struct vcpu_svm *svm,
-			 u64 arg1_gpa, u64 arg2_gpa, void *opaque,
-			 int (*handler)(struct vcpu_svm *svm,
-					void *arg1,
-					void *arg2,
-					void *opaque))
-{
-	struct page *arg1_page;
-	struct page *arg2_page = NULL;
-	void *arg1;
-	void *arg2 = NULL;
-	int retval;
-
-	arg1_page = nested_svm_get_page(svm, arg1_gpa);
-	if(arg1_page == NULL)
-		return 1;
-
-	if (arg2_gpa) {
-		arg2_page = nested_svm_get_page(svm, arg2_gpa);
-		if(arg2_page == NULL) {
-			kvm_release_page_clean(arg1_page);
-			return 1;
-		}
-	}
-
-	arg1 = kmap_atomic(arg1_page, KM_USER0);
-	if (arg2_gpa)
-		arg2 = kmap_atomic(arg2_page, KM_USER1);
-
-	retval = handler(svm, arg1, arg2, opaque);
-
-	kunmap_atomic(arg1, KM_USER0);
-	if (arg2_gpa)
-		kunmap_atomic(arg2, KM_USER1);
-
-	kvm_release_page_dirty(arg1_page);
-	if (arg2_gpa)
-		kvm_release_page_dirty(arg2_page);
-
-	return retval;
-}
-
 static bool nested_svm_exit_handled_msr(struct vcpu_svm *svm)
 {
 	u32 param = svm->vmcb->control.exit_info_1 & 1;
-- 
1.6.4.1

