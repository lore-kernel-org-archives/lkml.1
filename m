Return-Path: <linux-kernel-owner+w=401wt.eu-S1757359AbZHGJxq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757359AbZHGJxq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Aug 2009 05:53:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757082AbZHGJuc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Aug 2009 05:50:32 -0400
Received: from tx2ehsobe002.messaging.microsoft.com ([65.55.88.12]:45387 "EHLO
	TX2EHSOBE004.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755905AbZHGJuI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Aug 2009 05:50:08 -0400
X-SpamScore: 3
X-BigFish: VPS3(zzzz1202hzzz32i203h43j62h)
X-Spam-TCS-SCL: 1:0
X-FB-SS: 5,
X-WSS-ID: 0KO03B9-04-L8B-01
From: Joerg Roedel <joerg.roedel@amd.com>
To: Avi Kivity <avi@redhat.com>
CC: Alexander Graf <agraf@suse.de>, kvm@vger.kernel.org,
       linux-kernel@vger.kernel.org, Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 07/21] kvm/svm: cache nested intercepts
Date: Fri, 7 Aug 2009 11:49:34 +0200
Message-ID: <1249638588-10982-8-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1249638588-10982-1-git-send-email-joerg.roedel@amd.com>
References: <1249638588-10982-1-git-send-email-joerg.roedel@amd.com>
X-OriginalArrivalTime: 07 Aug 2009 09:49:50.0983 (UTC) FILETIME=[68603170:01CA1744]
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When the nested intercepts are cached we don't need to call
get_user_pages and/or map the nested vmcb on every nested #vmexit to
check who will handle the intercept.
Further this patch aligns the emulated svm behavior better to real
hardware.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 arch/x86/kvm/svm.c |   30 +++++++++++++++++++++++-------
 1 files changed, 23 insertions(+), 7 deletions(-)

diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index b4e2587..75fdfe7 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -80,6 +80,15 @@ struct nested_state {
 
 	/* gpa pointers to the real vectors */
 	u64 vmcb_msrpm;
+
+	/* cache for intercepts of the guest */
+	u16 intercept_cr_read;
+	u16 intercept_cr_write;
+	u16 intercept_dr_read;
+	u16 intercept_dr_write;
+	u32 intercept_exceptions;
+	u64 intercept;
+
 };
 
 struct vcpu_svm {
@@ -1455,7 +1464,6 @@ static int nested_svm_exit_handled_real(struct vcpu_svm *svm,
 					void *arg2,
 					void *opaque)
 {
-	struct vmcb *nested_vmcb = (struct vmcb *)arg1;
 	bool kvm_overrides = *(bool *)opaque;
 	u32 exit_code = svm->vmcb->control.exit_code;
 
@@ -1482,38 +1490,38 @@ static int nested_svm_exit_handled_real(struct vcpu_svm *svm,
 	switch (exit_code) {
 	case SVM_EXIT_READ_CR0 ... SVM_EXIT_READ_CR8: {
 		u32 cr_bits = 1 << (exit_code - SVM_EXIT_READ_CR0);
-		if (nested_vmcb->control.intercept_cr_read & cr_bits)
+		if (svm->nested.intercept_cr_read & cr_bits)
 			return 1;
 		break;
 	}
 	case SVM_EXIT_WRITE_CR0 ... SVM_EXIT_WRITE_CR8: {
 		u32 cr_bits = 1 << (exit_code - SVM_EXIT_WRITE_CR0);
-		if (nested_vmcb->control.intercept_cr_write & cr_bits)
+		if (svm->nested.intercept_cr_write & cr_bits)
 			return 1;
 		break;
 	}
 	case SVM_EXIT_READ_DR0 ... SVM_EXIT_READ_DR7: {
 		u32 dr_bits = 1 << (exit_code - SVM_EXIT_READ_DR0);
-		if (nested_vmcb->control.intercept_dr_read & dr_bits)
+		if (svm->nested.intercept_dr_read & dr_bits)
 			return 1;
 		break;
 	}
 	case SVM_EXIT_WRITE_DR0 ... SVM_EXIT_WRITE_DR7: {
 		u32 dr_bits = 1 << (exit_code - SVM_EXIT_WRITE_DR0);
-		if (nested_vmcb->control.intercept_dr_write & dr_bits)
+		if (svm->nested.intercept_dr_write & dr_bits)
 			return 1;
 		break;
 	}
 	case SVM_EXIT_EXCP_BASE ... SVM_EXIT_EXCP_BASE + 0x1f: {
 		u32 excp_bits = 1 << (exit_code - SVM_EXIT_EXCP_BASE);
-		if (nested_vmcb->control.intercept_exceptions & excp_bits)
+		if (svm->nested.intercept_exceptions & excp_bits)
 			return 1;
 		break;
 	}
 	default: {
 		u64 exit_bits = 1ULL << (exit_code - SVM_EXIT_INTR);
 		nsvm_printk("exit code: 0x%x\n", exit_code);
-		if (nested_vmcb->control.intercept & exit_bits)
+		if (svm->nested.intercept & exit_bits)
 			return 1;
 	}
 	}
@@ -1804,6 +1812,14 @@ static int nested_svm_vmrun(struct vcpu_svm *svm, void *arg1,
 
 	svm->nested.vmcb_msrpm = nested_vmcb->control.msrpm_base_pa;
 
+	/* cache intercepts */
+	svm->nested.intercept_cr_read    = nested_vmcb->control.intercept_cr_read;
+	svm->nested.intercept_cr_write   = nested_vmcb->control.intercept_cr_write;
+	svm->nested.intercept_dr_read    = nested_vmcb->control.intercept_dr_read;
+	svm->nested.intercept_dr_write   = nested_vmcb->control.intercept_dr_write;
+	svm->nested.intercept_exceptions = nested_vmcb->control.intercept_exceptions;
+	svm->nested.intercept            = nested_vmcb->control.intercept;
+
 	force_new_asid(&svm->vcpu);
 	svm->vmcb->control.exit_int_info = nested_vmcb->control.exit_int_info;
 	svm->vmcb->control.exit_int_info_err = nested_vmcb->control.exit_int_info_err;
-- 
1.6.3.3


