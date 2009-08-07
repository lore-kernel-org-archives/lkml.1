Return-Path: <linux-kernel-owner+w=401wt.eu-S1757326AbZHGJuw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757326AbZHGJuw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Aug 2009 05:50:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757292AbZHGJut
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Aug 2009 05:50:49 -0400
Received: from va3ehsobe001.messaging.microsoft.com ([216.32.180.11]:35957
	"EHLO VA3EHSOBE001.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755958AbZHGJuN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Aug 2009 05:50:13 -0400
X-SpamScore: 3
X-BigFish: VPS3(zzzz1202hzzz32i203h43j63h)
X-Spam-TCS-SCL: 2:0
X-WSS-ID: 0KO03BF-04-L8N-01
From: Joerg Roedel <joerg.roedel@amd.com>
To: Avi Kivity <avi@redhat.com>
CC: Alexander Graf <agraf@suse.de>, kvm@vger.kernel.org,
       linux-kernel@vger.kernel.org, Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 17/21] kvm/svm: move special nested exit handling to separate function
Date: Fri, 7 Aug 2009 11:49:44 +0200
Message-ID: <1249638588-10982-18-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1249638588-10982-1-git-send-email-joerg.roedel@amd.com>
References: <1249638588-10982-1-git-send-email-joerg.roedel@amd.com>
X-OriginalArrivalTime: 07 Aug 2009 09:49:51.0186 (UTC) FILETIME=[687F2B20:01CA1744]
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch moves the handling for special nested vmexits like #pf to a
separate function. This makes the kvm_override parameter obsolete and
makes the code more readable.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 arch/x86/kvm/svm.c |   80 ++++++++++++++++++++++++++++++++-------------------
 1 files changed, 50 insertions(+), 30 deletions(-)

diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index cad7582..1839c19 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -47,6 +47,10 @@ MODULE_LICENSE("GPL");
 #define SVM_FEATURE_LBRV (1 << 1)
 #define SVM_FEATURE_SVML (1 << 2)
 
+#define NESTED_EXIT_HOST	0	/* Exit handled on host level */
+#define NESTED_EXIT_DONE	1	/* Exit caused nested vmexit  */
+#define NESTED_EXIT_CONTINUE	2	/* Further checks needed      */
+
 #define DEBUGCTL_RESERVED_BITS (~(0x3fULL))
 
 /* Turn on to get debugging output*/
@@ -127,7 +131,7 @@ module_param(nested, int, S_IRUGO);
 static void svm_flush_tlb(struct kvm_vcpu *vcpu);
 static void svm_complete_interrupts(struct vcpu_svm *svm);
 
-static int nested_svm_exit_handled(struct vcpu_svm *svm, bool kvm_override);
+static int nested_svm_exit_handled(struct vcpu_svm *svm);
 static int nested_svm_vmexit(struct vcpu_svm *svm);
 static int nested_svm_check_exception(struct vcpu_svm *svm, unsigned nr,
 				      bool has_error_code, u32 error_code);
@@ -1368,7 +1372,7 @@ static int nested_svm_check_exception(struct vcpu_svm *svm, unsigned nr,
 	svm->vmcb->control.exit_info_1 = error_code;
 	svm->vmcb->control.exit_info_2 = svm->vcpu.arch.cr2;
 
-	return nested_svm_exit_handled(svm, false);
+	return nested_svm_exit_handled(svm);
 }
 
 static inline int nested_svm_intr(struct vcpu_svm *svm)
@@ -1382,7 +1386,7 @@ static inline int nested_svm_intr(struct vcpu_svm *svm)
 
 		svm->vmcb->control.exit_code = SVM_EXIT_INTR;
 
-		if (nested_svm_exit_handled(svm, false)) {
+		if (nested_svm_exit_handled(svm)) {
 			nsvm_printk("VMexit -> INTR\n");
 			return 1;
 		}
@@ -1471,31 +1475,39 @@ out:
 	return ret;
 }
 
-static int nested_svm_exit_handled(struct vcpu_svm *svm, bool kvm_override)
+static int nested_svm_exit_special(struct vcpu_svm *svm)
 {
 	u32 exit_code = svm->vmcb->control.exit_code;
-	bool vmexit = false;
 
-	if (kvm_override) {
-		switch (exit_code) {
-		case SVM_EXIT_INTR:
-		case SVM_EXIT_NMI:
-			return 0;
+	switch (exit_code) {
+	case SVM_EXIT_INTR:
+	case SVM_EXIT_NMI:
+		return NESTED_EXIT_HOST;
 		/* For now we are always handling NPFs when using them */
-		case SVM_EXIT_NPF:
-			if (npt_enabled)
-				return 0;
-			break;
-		/* When we're shadowing, trap PFs */
-		case SVM_EXIT_EXCP_BASE + PF_VECTOR:
-			if (!npt_enabled)
-				return 0;
-			break;
-		default:
-			break;
-		}
+	case SVM_EXIT_NPF:
+		if (npt_enabled)
+			return NESTED_EXIT_HOST;
+		break;
+	/* When we're shadowing, trap PFs */
+	case SVM_EXIT_EXCP_BASE + PF_VECTOR:
+		if (!npt_enabled)
+			return NESTED_EXIT_HOST;
+		break;
+	default:
+		break;
 	}
 
+	return NESTED_EXIT_CONTINUE;
+}
+
+/*
+ * If this function returns true, this #vmexit was already handled
+ */
+static int nested_svm_exit_handled(struct vcpu_svm *svm)
+{
+	u32 exit_code = svm->vmcb->control.exit_code;
+	int vmexit = NESTED_EXIT_HOST;
+
 	switch (exit_code) {
 	case SVM_EXIT_MSR:
 		vmexit = nested_svm_exit_handled_msr(svm);
@@ -1503,42 +1515,42 @@ static int nested_svm_exit_handled(struct vcpu_svm *svm, bool kvm_override)
 	case SVM_EXIT_READ_CR0 ... SVM_EXIT_READ_CR8: {
 		u32 cr_bits = 1 << (exit_code - SVM_EXIT_READ_CR0);
 		if (svm->nested.intercept_cr_read & cr_bits)
-			vmexit = true;
+			vmexit = NESTED_EXIT_DONE;
 		break;
 	}
 	case SVM_EXIT_WRITE_CR0 ... SVM_EXIT_WRITE_CR8: {
 		u32 cr_bits = 1 << (exit_code - SVM_EXIT_WRITE_CR0);
 		if (svm->nested.intercept_cr_write & cr_bits)
-			vmexit = true;
+			vmexit = NESTED_EXIT_DONE;
 		break;
 	}
 	case SVM_EXIT_READ_DR0 ... SVM_EXIT_READ_DR7: {
 		u32 dr_bits = 1 << (exit_code - SVM_EXIT_READ_DR0);
 		if (svm->nested.intercept_dr_read & dr_bits)
-			vmexit = true;
+			vmexit = NESTED_EXIT_DONE;
 		break;
 	}
 	case SVM_EXIT_WRITE_DR0 ... SVM_EXIT_WRITE_DR7: {
 		u32 dr_bits = 1 << (exit_code - SVM_EXIT_WRITE_DR0);
 		if (svm->nested.intercept_dr_write & dr_bits)
-			vmexit = true;
+			vmexit = NESTED_EXIT_DONE;
 		break;
 	}
 	case SVM_EXIT_EXCP_BASE ... SVM_EXIT_EXCP_BASE + 0x1f: {
 		u32 excp_bits = 1 << (exit_code - SVM_EXIT_EXCP_BASE);
 		if (svm->nested.intercept_exceptions & excp_bits)
-			vmexit = true;
+			vmexit = NESTED_EXIT_DONE;
 		break;
 	}
 	default: {
 		u64 exit_bits = 1ULL << (exit_code - SVM_EXIT_INTR);
 		nsvm_printk("exit code: 0x%x\n", exit_code);
 		if (svm->nested.intercept & exit_bits)
-			vmexit = true;
+			vmexit = NESTED_EXIT_DONE;
 	}
 	}
 
-	if (vmexit) {
+	if (vmexit == NESTED_EXIT_DONE) {
 		nsvm_printk("#VMEXIT reason=%04x\n", exit_code);
 		nested_svm_vmexit(svm);
 	}
@@ -2316,10 +2328,18 @@ static int handle_exit(struct kvm_run *kvm_run, struct kvm_vcpu *vcpu)
 	trace_kvm_exit(exit_code, svm->vmcb->save.rip);
 
 	if (is_nested(svm)) {
+		int vmexit;
+
 		nsvm_printk("nested handle_exit: 0x%x | 0x%lx | 0x%lx | 0x%lx\n",
 			    exit_code, svm->vmcb->control.exit_info_1,
 			    svm->vmcb->control.exit_info_2, svm->vmcb->save.rip);
-		if (nested_svm_exit_handled(svm, true))
+
+		vmexit = nested_svm_exit_special(svm);
+
+		if (vmexit == NESTED_EXIT_CONTINUE)
+			vmexit = nested_svm_exit_handled(svm);
+
+		if (vmexit == NESTED_EXIT_DONE)
 			return 1;
 	}
 
-- 
1.6.3.3


