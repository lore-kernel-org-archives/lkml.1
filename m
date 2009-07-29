Return-Path: <linux-kernel-owner+w=401wt.eu-S1755059AbZG2M7e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755059AbZG2M7e (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jul 2009 08:59:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754842AbZG2M5S
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Jul 2009 08:57:18 -0400
Received: from sg2ehsobe003.messaging.microsoft.com ([207.46.51.77]:14361 "EHLO
	SG2EHSOBE003.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754650AbZG2M47 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jul 2009 08:56:59 -0400
X-SpamScore: 3
X-BigFish: VPS3(zzzz1202hzzz32i203h43j64h)
X-Spam-TCS-SCL: 3:0
X-WSS-ID: 0KNJNYJ-04-405-01
From: Joerg Roedel <joerg.roedel@amd.com>
To: Avi Kivity <avi@redhat.com>
CC: Alexander Graf <agraf@suse.de>, kvm@vger.kernel.org,
       linux-kernel@vger.kernel.org, Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 09/12] kvm/svm: consolidate nested_svm_exit_handled
Date: Wed, 29 Jul 2009 14:56:29 +0200
Message-ID: <1248872192-30881-10-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1248872192-30881-1-git-send-email-joerg.roedel@amd.com>
References: <1248872192-30881-1-git-send-email-joerg.roedel@amd.com>
X-OriginalArrivalTime: 29 Jul 2009 12:56:37.0045 (UTC) FILETIME=[01FDCE50:01CA104C]
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When caching guest intercepts there is no need anymore for the
nested_svm_exit_handled_real function. So move its code into
nested_svm_exit_handled.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 arch/x86/kvm/svm.c |  108 +++++++++++++++++++++++-----------------------------
 1 files changed, 48 insertions(+), 60 deletions(-)

diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index 9192c9a..263dfa4 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -1463,15 +1463,57 @@ static int nested_svm_do(struct vcpu_svm *svm,
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
+        u32 t0, t1;
+	u32 msr = svm->vcpu.arch.regs[VCPU_REGS_RCX];
+	u32 param = svm->vmcb->control.exit_info_1 & 1;
+
+	if (!(nested_vmcb->control.intercept & (1ULL << INTERCEPT_MSR_PROT)))
+		return 0;
+
+	switch(msr) {
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
+	default: break;
+	}
+
+	if (kvm_override) {
 		switch (exit_code) {
 		case SVM_EXIT_INTR:
 		case SVM_EXIT_NMI:
@@ -1533,60 +1575,6 @@ static int nested_svm_exit_handled_real(struct vcpu_svm *svm,
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


