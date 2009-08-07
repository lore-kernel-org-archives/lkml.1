Return-Path: <linux-kernel-owner+w=401wt.eu-S1757197AbZHGJuj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757197AbZHGJuj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Aug 2009 05:50:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756051AbZHGJug
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Aug 2009 05:50:36 -0400
Received: from va3ehsobe005.messaging.microsoft.com ([216.32.180.15]:57452
	"EHLO VA3EHSOBE006.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753174AbZHGJuG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Aug 2009 05:50:06 -0400
X-SpamScore: 3
X-BigFish: VPS3(zzzz1202hzzz32i203h43j62h)
X-Spam-TCS-SCL: 1:0
X-FB-SS: 5,
X-WSS-ID: 0KO03B9-04-L8E-01
From: Joerg Roedel <joerg.roedel@amd.com>
To: Avi Kivity <avi@redhat.com>
CC: Alexander Graf <agraf@suse.de>, kvm@vger.kernel.org,
       linux-kernel@vger.kernel.org, Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 12/21] kvm/svm: clean up nested_svm_exit_handled_msr
Date: Fri, 7 Aug 2009 11:49:39 +0200
Message-ID: <1249638588-10982-13-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1249638588-10982-1-git-send-email-joerg.roedel@amd.com>
References: <1249638588-10982-1-git-send-email-joerg.roedel@amd.com>
X-OriginalArrivalTime: 07 Aug 2009 09:49:51.0140 (UTC) FILETIME=[68782640:01CA1744]
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch changes nested svm to call nested_svm_exit_handled_msr
directly and not through nested_svm_do.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 arch/x86/kvm/svm.c |   37 ++++++++++++++++++++++---------------
 1 files changed, 22 insertions(+), 15 deletions(-)

diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index 1753a64..448d493 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -1486,15 +1486,20 @@ static int nested_svm_do(struct vcpu_svm *svm,
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
@@ -1515,13 +1520,17 @@ static int nested_svm_exit_handled_msr(struct vcpu_svm *svm,
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
@@ -1551,9 +1560,7 @@ static int nested_svm_exit_handled(struct vcpu_svm *svm, bool kvm_override)
 
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
1.6.3.3


