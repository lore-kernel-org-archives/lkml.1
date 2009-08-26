Return-Path: <linux-kernel-owner+w=401wt.eu-S1757213AbZHZKj6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757213AbZHZKj6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Aug 2009 06:39:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757323AbZHZKig
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Aug 2009 06:38:36 -0400
Received: from mx1.redhat.com ([209.132.183.28]:29168 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757051AbZHZKaM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Aug 2009 06:30:12 -0400
From: Avi Kivity <avi@redhat.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 23/47] KVM: SVM: clean up nested_svm_exit_handled_msr
Date: Wed, 26 Aug 2009 13:29:45 +0300
Message-Id: <1251282609-12835-24-git-send-email-avi@redhat.com>
In-Reply-To: <1251282609-12835-1-git-send-email-avi@redhat.com>
References: <1251282609-12835-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Joerg Roedel <joerg.roedel@amd.com>

This patch changes nested svm to call nested_svm_exit_handled_msr
directly and not through nested_svm_do.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
Signed-off-by: Avi Kivity <avi@redhat.com>
---
 arch/x86/kvm/svm.c |   37 ++++++++++++++++++++++---------------
 1 files changed, 22 insertions(+), 15 deletions(-)

diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index 5e55a1b..518d578 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -1483,15 +1483,20 @@ static int nested_svm_do(struct vcpu_svm *svm,
 	return retval;
 }
 
-static int nested_svm_exit_handled_msr(struct vcpu_svm *svm,
-				       void *arg1, void *arg2,
-				       void *opaque)
+static bool nested_svm_exit_handled_msr(struct vcpu_svm *svm)
 {
-	struct vmcb *nested_vmcb = (struct vmcb *)arg1;
-	u8 *msrpm = (u8 *)arg2;
-	u32 t0, t1;
-	u32 msr = svm->vcpu.arch.regs[VCPU_REGS_RCX];
 	u32 param = svm->vmcb->control.exit_info_1 & 1;
+	u32 msr = svm->vcpu.arch.regs[VCPU_REGS_RCX];
+	struct vmcb *nested_vmcb;
+	bool ret = false;
+	u32 t0, t1;
+	u8 *msrpm;
+
+	nested_vmcb = nested_svm_map(svm, svm->nested.vmcb, KM_USER0);
+	msrpm       = nested_svm_map(svm, svm->nested.vmcb_msrpm, KM_USER1);
+
+	if (!nested_vmcb || !msrpm)
+		goto out;
 
 	if (!(nested_vmcb->control.intercept & (1ULL << INTERCEPT_MSR_PROT)))
 		return 0;
@@ -1512,13 +1517,17 @@ static int nested_svm_exit_handled_msr(struct vcpu_svm *svm,
 		t0 %= 8;
 		break;
 	default:
-		return 1;
-		break;
+		ret = true;
+		goto out;
 	}
-	if (msrpm[t1] & ((1 << param) << t0))
-		return 1;
 
-	return 0;
+	ret = msrpm[t1] & ((1 << param) << t0);
+
+out:
+	nested_svm_unmap(nested_vmcb, KM_USER0);
+	nested_svm_unmap(msrpm, KM_USER1);
+
+	return ret;
 }
 
 static int nested_svm_exit_handled(struct vcpu_svm *svm, bool kvm_override)
@@ -1548,9 +1557,7 @@ static int nested_svm_exit_handled(struct vcpu_svm *svm, bool kvm_override)
 
 	switch (exit_code) {
 	case SVM_EXIT_MSR:
-		if (nested_svm_do(svm, svm->nested.vmcb, svm->nested.vmcb_msrpm,
-				  NULL, nested_svm_exit_handled_msr))
-			vmexit = true;
+		vmexit = nested_svm_exit_handled_msr(svm);
 		break;
 	case SVM_EXIT_READ_CR0 ... SVM_EXIT_READ_CR8: {
 		u32 cr_bits = 1 << (exit_code - SVM_EXIT_READ_CR0);
-- 
1.6.4.1

