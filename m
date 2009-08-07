Return-Path: <linux-kernel-owner+w=401wt.eu-S1757357AbZHGJzC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757357AbZHGJzC (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Aug 2009 05:55:02 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755999AbZHGJzA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Aug 2009 05:55:00 -0400
Received: from sg2ehsobe002.messaging.microsoft.com ([207.46.51.76]:37982 "EHLO
	SG2EHSOBE002.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755963AbZHGJuR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Aug 2009 05:50:17 -0400
X-SpamScore: 3
X-BigFish: VPS3(zzzz1202hzzz32i203h43j)
X-WSS-ID: 0KO03BA-04-L8H-01
From: Joerg Roedel <joerg.roedel@amd.com>
To: Avi Kivity <avi@redhat.com>
CC: Alexander Graf <agraf@suse.de>, kvm@vger.kernel.org,
       linux-kernel@vger.kernel.org, Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 08/21] kvm/svm: consolidate nested_svm_exit_handled
Date: Fri, 7 Aug 2009 11:49:35 +0200
Message-ID: <1249638588-10982-9-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1249638588-10982-1-git-send-email-joerg.roedel@amd.com>
References: <1249638588-10982-1-git-send-email-joerg.roedel@amd.com>
X-OriginalArrivalTime: 07 Aug 2009 09:49:50.0983 (UTC) FILETIME=[68603170:01CA1744]
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When caching guest intercepts there is no need anymore for the
nested_svm_exit_handled_real function. So move its code into
nested_svm_exit_handled.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
Acked-by: Alexander Graf <agraf@suse.de>
---
 arch/x86/kvm/svm.c |  109 +++++++++++++++++++++++----------------------------
 1 files changed, 49 insertions(+), 60 deletions(-)

diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index 75fdfe7..b2c9a9e 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -1459,15 +1459,58 @@ static int nested_svm_do(struct vcpu_svm *svm,
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
@@ -1529,60 +1572,6 @@ static int nested_svm_exit_handled_real(struct vcpu_svm *svm,
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
1.6.3.3


