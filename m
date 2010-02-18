Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757914Ab0BRLi6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Feb 2010 06:38:58 -0500
Received: from va3ehsobe002.messaging.microsoft.com ([216.32.180.12]:43594
	"EHLO VA3EHSOBE002.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1757822Ab0BRLix (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Feb 2010 06:38:53 -0500
X-SpamScore: -4
X-BigFish: VPS-4(zz936eMab9bhzz1202hzzz32i87h6bh62h)
X-Spam-TCS-SCL: 1:0
X-FB-DOMAIN-IP-MATCH: fail
X-WSS-ID: 0KY1CCF-01-N2N-02
X-M-MSG: 
From: Joerg Roedel <joerg.roedel@amd.com>
To: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>
CC: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
       Joerg Roedel <joerg.roedel@amd.com>, stable@kernel.org
Subject: [PATCH 03/10] KVM: SVM: Fix schedule-while-atomic on nested exception handling
Date: Thu, 18 Feb 2010 12:38:28 +0100
Message-ID: <1266493115-28386-4-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.6.6
In-Reply-To: <1266493115-28386-1-git-send-email-joerg.roedel@amd.com>
References: <1266493115-28386-1-git-send-email-joerg.roedel@amd.com>
X-OriginalArrivalTime: 18 Feb 2010 11:38:37.0421 (UTC) FILETIME=[E8FCD9D0:01CAB08E]
MIME-Version: 1.0
Content-Type: text/plain
X-Reverse-DNS: ausb3extmailp02.amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Move the actual vmexit routine out of code that runs with
irqs and preemption disabled.

Cc: stable@kernel.org
Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 arch/x86/kvm/svm.c |   20 +++++++++++++++++---
 1 files changed, 17 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index 7c96b8b..25d26ec 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -128,6 +128,7 @@ static void svm_flush_tlb(struct kvm_vcpu *vcpu);
 static void svm_complete_interrupts(struct vcpu_svm *svm);
 
 static int nested_svm_exit_handled(struct vcpu_svm *svm);
+static int nested_svm_exit_handled_atomic(struct vcpu_svm *svm);
 static int nested_svm_vmexit(struct vcpu_svm *svm);
 static int nested_svm_check_exception(struct vcpu_svm *svm, unsigned nr,
 				      bool has_error_code, u32 error_code);
@@ -1386,7 +1387,7 @@ static int nested_svm_check_exception(struct vcpu_svm *svm, unsigned nr,
 	svm->vmcb->control.exit_info_1 = error_code;
 	svm->vmcb->control.exit_info_2 = svm->vcpu.arch.cr2;
 
-	return nested_svm_exit_handled(svm);
+	return nested_svm_exit_handled_atomic(svm);
 }
 
 /* This function returns true if it is save to enable the irq window */
@@ -1520,7 +1521,7 @@ static int nested_svm_exit_special(struct vcpu_svm *svm)
 /*
  * If this function returns true, this #vmexit was already handled
  */
-static int nested_svm_exit_handled(struct vcpu_svm *svm)
+static int __nested_svm_exit_handled(struct vcpu_svm *svm, bool atomic)
 {
 	u32 exit_code = svm->vmcb->control.exit_code;
 	int vmexit = NESTED_EXIT_HOST;
@@ -1567,12 +1568,25 @@ static int nested_svm_exit_handled(struct vcpu_svm *svm)
 	}
 
 	if (vmexit == NESTED_EXIT_DONE) {
-		nested_svm_vmexit(svm);
+		if (!atomic)
+			nested_svm_vmexit(svm);
+		else
+			svm->nested.exit_required = true;
 	}
 
 	return vmexit;
 }
 
+static int nested_svm_exit_handled(struct vcpu_svm *svm)
+{
+	return __nested_svm_exit_handled(svm, false);
+}
+
+static int nested_svm_exit_handled_atomic(struct vcpu_svm *svm)
+{
+	return __nested_svm_exit_handled(svm, true);
+}
+
 static inline void copy_vmcb_control_area(struct vmcb *dst_vmcb, struct vmcb *from_vmcb)
 {
 	struct vmcb_control_area *dst  = &dst_vmcb->control;
-- 
1.6.6


