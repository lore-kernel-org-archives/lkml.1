Return-Path: <linux-kernel-owner+w=401wt.eu-S1757344AbZBZORN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757344AbZBZORN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Feb 2009 09:17:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755837AbZBZOPs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Feb 2009 09:15:48 -0500
Received: from mx2.redhat.com ([66.187.237.31]:43048 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753990AbZBZOPk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Feb 2009 09:15:40 -0500
From: Avi Kivity <avi@redhat.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Alexander Graf <agraf@suse.de>
Subject: [PATCH 03/40] KVM: SVM: Add helper functions for nested SVM
Date: Thu, 26 Feb 2009 16:14:53 +0200
Message-Id: <1235657730-27683-4-git-send-email-avi@redhat.com>
In-Reply-To: <1235657730-27683-1-git-send-email-avi@redhat.com>
References: <1235657730-27683-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alexander Graf <agraf@suse.de>

These are helpers for the nested SVM implementation.

- nsvm_printk implements a debug printk variant
- nested_svm_do calls a handler that can accesses gpa-based memory

v3 makes use of the new permission checker
v6 changes:
- streamline nsvm_debug()
- remove printk(KERN_ERR)
- SVME check before CPL check
- give GP error code
- use new EFER constant

Acked-by: Joerg Roedel <joro@8bytes.org>
Signed-off-by: Alexander Graf <agraf@suse.de>
Signed-off-by: Avi Kivity <avi@redhat.com>
---
 arch/x86/kvm/svm.c |   85 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 85 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index e4eb3fd..87debdc 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -50,6 +50,15 @@ MODULE_LICENSE("GPL");
 
 #define DEBUGCTL_RESERVED_BITS (~(0x3fULL))
 
+/* Turn on to get debugging output*/
+/* #define NESTED_DEBUG */
+
+#ifdef NESTED_DEBUG
+#define nsvm_printk(fmt, args...) printk(KERN_INFO fmt, ## args)
+#else
+#define nsvm_printk(fmt, args...) do {} while(0)
+#endif
+
 /* enable NPT for AMD64 and X86 with PAE */
 #if defined(CONFIG_X86_64) || defined(CONFIG_X86_PAE)
 static bool npt_enabled = true;
@@ -1149,6 +1158,82 @@ static int vmmcall_interception(struct vcpu_svm *svm, struct kvm_run *kvm_run)
 	return 1;
 }
 
+static int nested_svm_check_permissions(struct vcpu_svm *svm)
+{
+	if (!(svm->vcpu.arch.shadow_efer & EFER_SVME)
+	    || !is_paging(&svm->vcpu)) {
+		kvm_queue_exception(&svm->vcpu, UD_VECTOR);
+		return 1;
+	}
+
+	if (svm->vmcb->save.cpl) {
+		kvm_inject_gp(&svm->vcpu, 0);
+		return 1;
+	}
+
+       return 0;
+}
+
+static struct page *nested_svm_get_page(struct vcpu_svm *svm, u64 gpa)
+{
+	struct page *page;
+
+	down_read(&current->mm->mmap_sem);
+	page = gfn_to_page(svm->vcpu.kvm, gpa >> PAGE_SHIFT);
+	up_read(&current->mm->mmap_sem);
+
+	if (is_error_page(page)) {
+		printk(KERN_INFO "%s: could not find page at 0x%llx\n",
+		       __func__, gpa);
+		kvm_release_page_clean(page);
+		kvm_inject_gp(&svm->vcpu, 0);
+		return NULL;
+	}
+	return page;
+}
+
+static int nested_svm_do(struct vcpu_svm *svm,
+			 u64 arg1_gpa, u64 arg2_gpa, void *opaque,
+			 int (*handler)(struct vcpu_svm *svm,
+					void *arg1,
+					void *arg2,
+					void *opaque))
+{
+	struct page *arg1_page;
+	struct page *arg2_page = NULL;
+	void *arg1;
+	void *arg2 = NULL;
+	int retval;
+
+	arg1_page = nested_svm_get_page(svm, arg1_gpa);
+	if(arg1_page == NULL)
+		return 1;
+
+	if (arg2_gpa) {
+		arg2_page = nested_svm_get_page(svm, arg2_gpa);
+		if(arg2_page == NULL) {
+			kvm_release_page_clean(arg1_page);
+			return 1;
+		}
+	}
+
+	arg1 = kmap_atomic(arg1_page, KM_USER0);
+	if (arg2_gpa)
+		arg2 = kmap_atomic(arg2_page, KM_USER1);
+
+	retval = handler(svm, arg1, arg2, opaque);
+
+	kunmap_atomic(arg1, KM_USER0);
+	if (arg2_gpa)
+		kunmap_atomic(arg2, KM_USER1);
+
+	kvm_release_page_dirty(arg1_page);
+	if (arg2_gpa)
+		kvm_release_page_dirty(arg2_page);
+
+	return retval;
+}
+
 static int invalid_op_interception(struct vcpu_svm *svm,
 				   struct kvm_run *kvm_run)
 {
-- 
1.6.0.6

