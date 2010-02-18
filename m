Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757676Ab0BRLjd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Feb 2010 06:39:33 -0500
Received: from tx2ehsobe004.messaging.microsoft.com ([65.55.88.14]:20632 "EHLO
	TX2EHSOBE007.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757477Ab0BRLj3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Feb 2010 06:39:29 -0500
X-SpamScore: -4
X-BigFish: VPS-4(zz936eMab9bhzz1202hzzz32i87h6bh61h)
X-Spam-TCS-SCL: 0:0
X-FB-DOMAIN-IP-MATCH: fail
X-WSS-ID: 0KY1CCK-01-N2Q-02
X-M-MSG: 
From: Joerg Roedel <joerg.roedel@amd.com>
To: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>
CC: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
       Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 08/10] KVM: SVM: Activate nested state only when guest state is complete
Date: Thu, 18 Feb 2010 12:38:33 +0100
Message-ID: <1266493115-28386-9-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.6.6
In-Reply-To: <1266493115-28386-1-git-send-email-joerg.roedel@amd.com>
References: <1266493115-28386-1-git-send-email-joerg.roedel@amd.com>
X-OriginalArrivalTime: 18 Feb 2010 11:38:37.0624 (UTC) FILETIME=[E91BD380:01CAB08E]
MIME-Version: 1.0
Content-Type: text/plain
X-Reverse-DNS: ausb3extmailp02.amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Certain functions called during the emulated world switch
behave differently when the vcpu is running nested. This is
not the expected behavior during a world switch emulation.
This patch ensures that the nested state is activated only
if the vcpu is completly in nested state.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 arch/x86/kvm/svm.c |   15 +++++++++------
 1 files changed, 9 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index 2a3d525..a64b871 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -1631,6 +1631,9 @@ static int nested_svm_vmexit(struct vcpu_svm *svm)
 	if (!nested_vmcb)
 		return 1;
 
+	/* Exit nested SVM mode */
+	svm->nested.vmcb = 0;
+
 	/* Give the current vmcb to the guest */
 	disable_gif(svm);
 
@@ -1718,9 +1721,6 @@ static int nested_svm_vmexit(struct vcpu_svm *svm)
 	svm->vmcb->save.cpl = 0;
 	svm->vmcb->control.exit_int_info = 0;
 
-	/* Exit nested SVM mode */
-	svm->nested.vmcb = 0;
-
 	nested_svm_unmap(nested_vmcb);
 
 	kvm_mmu_reset_context(&svm->vcpu);
@@ -1753,14 +1753,14 @@ static bool nested_svm_vmrun(struct vcpu_svm *svm)
 	struct vmcb *nested_vmcb;
 	struct vmcb *hsave = svm->nested.hsave;
 	struct vmcb *vmcb = svm->vmcb;
+	u64 vmcb_gpa;
+
+	vmcb_gpa = svm->vmcb->save.rax;
 
 	nested_vmcb = nested_svm_map(svm, svm->vmcb->save.rax);
 	if (!nested_vmcb)
 		return false;
 
-	/* nested_vmcb is our indicator if nested SVM is activated */
-	svm->nested.vmcb = svm->vmcb->save.rax;
-
 	trace_kvm_nested_vmrun(svm->vmcb->save.rip - 3, svm->nested.vmcb,
 			       nested_vmcb->save.rip,
 			       nested_vmcb->control.int_ctl,
@@ -1875,6 +1875,9 @@ static bool nested_svm_vmrun(struct vcpu_svm *svm)
 
 	nested_svm_unmap(nested_vmcb);
 
+	/* nested_vmcb is our indicator if nested SVM is activated */
+	svm->nested.vmcb = vmcb_gpa;
+
 	enable_gif(svm);
 
 	return true;
-- 
1.6.6


