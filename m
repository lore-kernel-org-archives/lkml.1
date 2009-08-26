Return-Path: <linux-kernel-owner+w=401wt.eu-S1757276AbZHZKfX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757276AbZHZKfX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Aug 2009 06:35:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757236AbZHZKdp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Aug 2009 06:33:45 -0400
Received: from mx1.redhat.com ([209.132.183.28]:46795 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757067AbZHZKaN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Aug 2009 06:30:13 -0400
From: Avi Kivity <avi@redhat.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 19/47] KVM: SVM: consolidate nested_svm_exit_handled
Date: Wed, 26 Aug 2009 13:29:41 +0300
Message-Id: <1251282609-12835-20-git-send-email-avi@redhat.com>
In-Reply-To: <1251282609-12835-1-git-send-email-avi@redhat.com>
References: <1251282609-12835-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Joerg Roedel <joerg.roedel@amd.com>

When caching guest intercepts there is no need anymore for the
nested_svm_exit_handled_real function. So move its code into
nested_svm_exit_handled.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
Acked-by: Alexander Graf <agraf@suse.de>
Signed-off-by: Avi Kivity <avi@redhat.com>
---
 arch/x86/kvm/svm.c |  109 +++++++++++++++++++++++----------------------------
 1 files changed, 49 insertions(+), 60 deletions(-)

diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index 4426c63..bdd73fd 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -1456,15 +1456,58 @@ static int nested_svm_do(struct vcpu_svm *svm,
 	return retval;
 }
 
-static int nested_svm_exit_handled_real(struct vcpu_svm *svm,
-					void *arg1,
-					void *arg2,
-					void *opaque)
+static int nested_svm_exit_handled_msr(struct vcpu_svm *svm,
+				       void *arg1, void *arg2,
+				       void *opaque)
+{
+	struct vmcb *nested_vmcb = (struct vmcb *)arg1;
+	u8 *msrpm = (u8 *)arg2;
+	u32 t0, t1;
+	u32 msr = svm->vcpu.arch.regs[VCPU_REGS_RCX];
+	u32 param = svm->vmcb->control.exit_info_1 & 1;
+
+	if (!(nested_vmcb->control.intercept & (1ULL << INTERCEPT_MSR_PROT)))
+		return 0;
+
+	switch (msr) {
+	case 0 ... 0x1fff:
+		t0 = (msr * 2) % 8;
+		t1 = msr / 8;
+		break;
+	case 0xc0000000 ... 0xc0001fff:
+		t0 = (8192 + msr - 0xc0000000) * 2;
+		t1 = (t0 / 8);
+		t0 %= 8;
+		break;
+	case 0xc0010000 ... 0xc0011fff:
+		t0 = (16384 + msr - 0xc0010000) * 2;
+		t1 = (t0 / 8);
+		t0 %= 8;
+		break;
+	default:
+		return 1;
+		break;
+	}
+	if (msrpm[t1] & ((1 << param) << t0))
+		return 1;
+
+	return 0;
+}
+
+static int nested_svm_exit_handled(struct vcpu_svm *svm, bool kvm_override)
 {
-	bool kvm_overrides = *(bool *)opaque;
 	u32 exit_code = svm->vmcb->control.exit_code;
 
-	if (kvm_overrides) {
+	switch (svm->vmcb->control.exit_code) {
+	case SVM_EXIT_MSR:
+		return nested_svm_do(svm, svm->nested.vmcb,
+				     svm->nested.vmcb_msrpm, NULL,
+				     nested_svm_exit_handled_msr);
+	default:
+		break;
+	}
+
+	if (kvm_override) {
 		switch (exit_code) {
 		case SVM_EXIT_INTR:
 		case SVM_EXIT_NMI:
@@ -1526,60 +1569,6 @@ static int nested_svm_exit_handled_real(struct vcpu_svm *svm,
 	return 0;
 }
 
-static int nested_svm_exit_handled_msr(struct vcpu_svm *svm,
-				       void *arg1, void *arg2,
-				       void *opaque)
-{
-	struct vmcb *nested_vmcb = (struct vmcb *)arg1;
-	u8 *msrpm = (u8 *)arg2;
-        u32 t0, t1;
-	u32 msr = svm->vcpu.arch.regs[VCPU_REGS_RCX];
-	u32 param = svm->vmcb->control.exit_info_1 & 1;
-
-	if (!(nested_vmcb->control.intercept & (1ULL << INTERCEPT_MSR_PROT)))
-		return 0;
-
-	switch(msr) {
-	case 0 ... 0x1fff:
-		t0 = (msr * 2) % 8;
-		t1 = msr / 8;
-		break;
-	case 0xc0000000 ... 0xc0001fff:
-		t0 = (8192 + msr - 0xc0000000) * 2;
-		t1 = (t0 / 8);
-		t0 %= 8;
-		break;
-	case 0xc0010000 ... 0xc0011fff:
-		t0 = (16384 + msr - 0xc0010000) * 2;
-		t1 = (t0 / 8);
-		t0 %= 8;
-		break;
-	default:
-		return 1;
-		break;
-	}
-	if (msrpm[t1] & ((1 << param) << t0))
-		return 1;
-
-	return 0;
-}
-
-static int nested_svm_exit_handled(struct vcpu_svm *svm, bool kvm_override)
-{
-	bool k = kvm_override;
-
-	switch (svm->vmcb->control.exit_code) {
-	case SVM_EXIT_MSR:
-		return nested_svm_do(svm, svm->nested.vmcb,
-				     svm->nested.vmcb_msrpm, NULL,
-				     nested_svm_exit_handled_msr);
-	default: break;
-	}
-
-	return nested_svm_do(svm, svm->nested.vmcb, 0, &k,
-			     nested_svm_exit_handled_real);
-}
-
 static inline void copy_vmcb_control_area(struct vmcb *dst_vmcb, struct vmcb *from_vmcb)
 {
 	struct vmcb_control_area *dst  = &dst_vmcb->control;
-- 
1.6.4.1

