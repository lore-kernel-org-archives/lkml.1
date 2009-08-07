Return-Path: <linux-kernel-owner+w=401wt.eu-S1757334AbZHGJxK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757334AbZHGJxK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Aug 2009 05:53:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757200AbZHGJxD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Aug 2009 05:53:03 -0400
Received: from outbound-dub.frontbridge.com ([213.199.154.16]:20506 "EHLO
	IE1EHSOBE005.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757151AbZHGJuh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Aug 2009 05:50:37 -0400
X-SpamScore: 3
X-BigFish: VPS3(zzzz1202hzzz32i203h43j62h)
X-Spam-TCS-SCL: 1:0
X-WSS-ID: 0KO03BF-04-L8O-01
From: Joerg Roedel <joerg.roedel@amd.com>
To: Avi Kivity <avi@redhat.com>
CC: Alexander Graf <agraf@suse.de>, kvm@vger.kernel.org,
       linux-kernel@vger.kernel.org, Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 09/21] kvm/svm: do nested vmexit in nested_svm_exit_handled
Date: Fri, 7 Aug 2009 11:49:36 +0200
Message-ID: <1249638588-10982-10-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1249638588-10982-1-git-send-email-joerg.roedel@amd.com>
References: <1249638588-10982-1-git-send-email-joerg.roedel@amd.com>
X-OriginalArrivalTime: 07 Aug 2009 09:49:51.0061 (UTC) FILETIME=[686C1850:01CA1744]
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If this function returns true a nested vmexit is required. Move that
vmexit into the nested_svm_exit_handled function. This also simplifies
the handling of nested #pf intercepts in this function.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
Acked-by: Alexander Graf <agraf@suse.de>
---
 arch/x86/kvm/svm.c |   42 +++++++++++++++++++-----------------------
 1 files changed, 19 insertions(+), 23 deletions(-)

diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index b2c9a9e..c473ad9 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -1369,8 +1369,6 @@ static int nested_svm_check_exception(struct vcpu_svm *svm, unsigned nr,
 		svm->vmcb->control.exit_info_2 = svm->vcpu.arch.cr2;
 		if (nested_svm_exit_handled(svm, false)) {
 			nsvm_printk("VMexit -> EXCP 0x%x\n", nr);
-
-			nested_svm_vmexit(svm);
 			return 1;
 		}
 	}
@@ -1391,7 +1389,6 @@ static inline int nested_svm_intr(struct vcpu_svm *svm)
 
 		if (nested_svm_exit_handled(svm, false)) {
 			nsvm_printk("VMexit -> INTR\n");
-			nested_svm_vmexit(svm);
 			return 1;
 		}
 	}
@@ -1500,15 +1497,7 @@ static int nested_svm_exit_handled_msr(struct vcpu_svm *svm,
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
@@ -1531,45 +1520,55 @@ static int nested_svm_exit_handled(struct vcpu_svm *svm, bool kvm_override)
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
@@ -2328,11 +2327,8 @@ static int handle_exit(struct kvm_run *kvm_run, struct kvm_vcpu *vcpu)
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
1.6.3.3


