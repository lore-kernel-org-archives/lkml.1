Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754479Ab0BSPXf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Feb 2010 10:23:35 -0500
Received: from tx2ehsobe005.messaging.microsoft.com ([65.55.88.15]:7712 "EHLO
	TX2EHSOBE010.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753748Ab0BSPX0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Feb 2010 10:23:26 -0500
X-SpamScore: -2
X-BigFish: VPS-2(zz936eMab9bhzz1202hzzz32i87h6bh43j61h)
X-Spam-TCS-SCL: 0:0
X-FB-DOMAIN-IP-MATCH: fail
X-WSS-ID: 0KY3HER-02-7NH-02
X-M-MSG: 
From: Joerg Roedel <joerg.roedel@amd.com>
To: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>
CC: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
       Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 08/11] KVM: SVM: Activate nested state only when guest state is complete
Date: Fri, 19 Feb 2010 16:23:07 +0100
Message-ID: <1266592990-8911-9-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.6.6
In-Reply-To: <1266592990-8911-1-git-send-email-joerg.roedel@amd.com>
References: <1266592990-8911-1-git-send-email-joerg.roedel@amd.com>
X-OriginalArrivalTime: 19 Feb 2010 15:23:12.0886 (UTC) FILETIME=[73676160:01CAB177]
MIME-Version: 1.0
Content-Type: text/plain
X-Reverse-DNS: unknown
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
index d7b75fb..4e8d42b 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -1628,6 +1628,9 @@ static int nested_svm_vmexit(struct vcpu_svm *svm)
 	if (!nested_vmcb)
 		return 1;
 
+	/* Exit nested SVM mode */
+	svm->nested.vmcb = 0;
+
 	/* Give the current vmcb to the guest */
 	disable_gif(svm);
 
@@ -1715,9 +1718,6 @@ static int nested_svm_vmexit(struct vcpu_svm *svm)
 	svm->vmcb->save.cpl = 0;
 	svm->vmcb->control.exit_int_info = 0;
 
-	/* Exit nested SVM mode */
-	svm->nested.vmcb = 0;
-
 	nested_svm_unmap(page);
 
 	kvm_mmu_reset_context(&svm->vcpu);
@@ -1752,14 +1752,14 @@ static bool nested_svm_vmrun(struct vcpu_svm *svm)
 	struct vmcb *hsave = svm->nested.hsave;
 	struct vmcb *vmcb = svm->vmcb;
 	struct page *page;
+	u64 vmcb_gpa;
+
+	vmcb_gpa = svm->vmcb->save.rax;
 
 	nested_vmcb = nested_svm_map(svm, svm->vmcb->save.rax, &page);
 	if (!nested_vmcb)
 		return false;
 
-	/* nested_vmcb is our indicator if nested SVM is activated */
-	svm->nested.vmcb = svm->vmcb->save.rax;
-
 	trace_kvm_nested_vmrun(svm->vmcb->save.rip - 3, svm->nested.vmcb,
 			       nested_vmcb->save.rip,
 			       nested_vmcb->control.int_ctl,
@@ -1874,6 +1874,9 @@ static bool nested_svm_vmrun(struct vcpu_svm *svm)
 
 	nested_svm_unmap(page);
 
+	/* nested_vmcb is our indicator if nested SVM is activated */
+	svm->nested.vmcb = vmcb_gpa;
+
 	enable_gif(svm);
 
 	return true;
-- 
1.6.6


