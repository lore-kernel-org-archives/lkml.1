Return-Path: <linux-kernel-owner+w=401wt.eu-S932566AbZHZKdt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932566AbZHZKdt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Aug 2009 06:33:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757223AbZHZKdn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Aug 2009 06:33:43 -0400
Received: from mx1.redhat.com ([209.132.183.28]:32706 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757075AbZHZKaN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Aug 2009 06:30:13 -0400
From: Avi Kivity <avi@redhat.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 20/47] KVM: SVM: do nested vmexit in nested_svm_exit_handled
Date: Wed, 26 Aug 2009 13:29:42 +0300
Message-Id: <1251282609-12835-21-git-send-email-avi@redhat.com>
In-Reply-To: <1251282609-12835-1-git-send-email-avi@redhat.com>
References: <1251282609-12835-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Joerg Roedel <joerg.roedel@amd.com>

If this function returns true a nested vmexit is required. Move that
vmexit into the nested_svm_exit_handled function. This also simplifies
the handling of nested #pf intercepts in this function.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
Acked-by: Alexander Graf <agraf@suse.de>
Signed-off-by: Avi Kivity <avi@redhat.com>
---
 arch/x86/kvm/svm.c |   42 +++++++++++++++++++-----------------------
 1 files changed, 19 insertions(+), 23 deletions(-)

diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index bdd73fd..3bb6d4b 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -1366,8 +1366,6 @@ static int nested_svm_check_exception(struct vcpu_svm *svm, unsigned nr,
 		svm->vmcb->control.exit_info_2 = svm->vcpu.arch.cr2;
 		if (nested_svm_exit_handled(svm, false)) {
 			nsvm_printk("VMexit -> EXCP 0x%x\n", nr);
-
-			nested_svm_vmexit(svm);
 			return 1;
 		}
 	}
@@ -1388,7 +1386,6 @@ static inline int nested_svm_intr(struct vcpu_svm *svm)
 
 		if (nested_svm_exit_handled(svm, false)) {
 			nsvm_printk("VMexit -> INTR\n");
-			nested_svm_vmexit(svm);
 			return 1;
 		}
 	}
@@ -1497,15 +1494,7 @@ static int nested_svm_exit_handled_msr(struct vcpu_svm *svm,
 static int nested_svm_exit_handled(struct vcpu_svm *svm, bool kvm_override)
 {
 	u32 exit_code = svm->vmcb->control.exit_code;
-
-	switch (svm->vmcb->control.exit_code) {
-	case SVM_EXIT_MSR:
-		return nested_svm_do(svm, svm->nested.vmcb,
-				     svm->nested.vmcb_msrpm, NULL,
-				     nested_svm_exit_handled_msr);
-	default:
-		break;
-	}
+	bool vmexit = false;
 
 	if (kvm_override) {
 		switch (exit_code) {
@@ -1528,45 +1517,55 @@ static int nested_svm_exit_handled(struct vcpu_svm *svm, bool kvm_override)
 	}
 
 	switch (exit_code) {
+	case SVM_EXIT_MSR:
+		if (nested_svm_do(svm, svm->nested.vmcb, svm->nested.vmcb_msrpm,
+				  NULL, nested_svm_exit_handled_msr))
+			vmexit = true;
+		break;
 	case SVM_EXIT_READ_CR0 ... SVM_EXIT_READ_CR8: {
 		u32 cr_bits = 1 << (exit_code - SVM_EXIT_READ_CR0);
 		if (svm->nested.intercept_cr_read & cr_bits)
-			return 1;
+			vmexit = true;
 		break;
 	}
 	case SVM_EXIT_WRITE_CR0 ... SVM_EXIT_WRITE_CR8: {
 		u32 cr_bits = 1 << (exit_code - SVM_EXIT_WRITE_CR0);
 		if (svm->nested.intercept_cr_write & cr_bits)
-			return 1;
+			vmexit = true;
 		break;
 	}
 	case SVM_EXIT_READ_DR0 ... SVM_EXIT_READ_DR7: {
 		u32 dr_bits = 1 << (exit_code - SVM_EXIT_READ_DR0);
 		if (svm->nested.intercept_dr_read & dr_bits)
-			return 1;
+			vmexit = true;
 		break;
 	}
 	case SVM_EXIT_WRITE_DR0 ... SVM_EXIT_WRITE_DR7: {
 		u32 dr_bits = 1 << (exit_code - SVM_EXIT_WRITE_DR0);
 		if (svm->nested.intercept_dr_write & dr_bits)
-			return 1;
+			vmexit = true;
 		break;
 	}
 	case SVM_EXIT_EXCP_BASE ... SVM_EXIT_EXCP_BASE + 0x1f: {
 		u32 excp_bits = 1 << (exit_code - SVM_EXIT_EXCP_BASE);
 		if (svm->nested.intercept_exceptions & excp_bits)
-			return 1;
+			vmexit = true;
 		break;
 	}
 	default: {
 		u64 exit_bits = 1ULL << (exit_code - SVM_EXIT_INTR);
 		nsvm_printk("exit code: 0x%x\n", exit_code);
 		if (svm->nested.intercept & exit_bits)
-			return 1;
+			vmexit = true;
 	}
 	}
 
-	return 0;
+	if (vmexit) {
+		nsvm_printk("#VMEXIT reason=%04x\n", exit_code);
+		nested_svm_vmexit(svm);
+	}
+
+	return vmexit;
 }
 
 static inline void copy_vmcb_control_area(struct vmcb *dst_vmcb, struct vmcb *from_vmcb)
@@ -2327,11 +2326,8 @@ static int handle_exit(struct kvm_run *kvm_run, struct kvm_vcpu *vcpu)
 		nsvm_printk("nested handle_exit: 0x%x | 0x%lx | 0x%lx | 0x%lx\n",
 			    exit_code, svm->vmcb->control.exit_info_1,
 			    svm->vmcb->control.exit_info_2, svm->vmcb->save.rip);
-		if (nested_svm_exit_handled(svm, true)) {
-			nested_svm_vmexit(svm);
-			nsvm_printk("-> #VMEXIT\n");
+		if (nested_svm_exit_handled(svm, true))
 			return 1;
-		}
 	}
 
 	svm_complete_interrupts(svm);
-- 
1.6.4.1

