Return-Path: <linux-kernel-owner+w=401wt.eu-S1757348AbZHGJxc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757348AbZHGJxc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Aug 2009 05:53:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755965AbZHGJue
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Aug 2009 05:50:34 -0400
Received: from va3ehsobe004.messaging.microsoft.com ([216.32.180.14]:43893
	"EHLO VA3EHSOBE004.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753079AbZHGJuG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Aug 2009 05:50:06 -0400
X-SpamScore: 3
X-BigFish: VPS3(zzzz1202hzzz32i203h43j62h)
X-Spam-TCS-SCL: 1:0
X-WSS-ID: 0KO03B5-03-0WN-01
From: Joerg Roedel <joerg.roedel@amd.com>
To: Avi Kivity <avi@redhat.com>
CC: Alexander Graf <agraf@suse.de>, kvm@vger.kernel.org,
       linux-kernel@vger.kernel.org, Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 03/21] kvm/svm: optimize nested vmrun
Date: Fri, 7 Aug 2009 11:49:30 +0200
Message-ID: <1249638588-10982-4-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1249638588-10982-1-git-send-email-joerg.roedel@amd.com>
References: <1249638588-10982-1-git-send-email-joerg.roedel@amd.com>
X-OriginalArrivalTime: 07 Aug 2009 09:49:50.0733 (UTC) FILETIME=[683A0BD0:01CA1744]
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Only copy the necessary parts of the vmcb save area on vmrun and save
precious time.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
Acked-by: Alexander Graf <agraf@suse.de>
---
 arch/x86/kvm/svm.c |   28 +++++++++++++++++++++-------
 1 files changed, 21 insertions(+), 7 deletions(-)

diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index 02ebc3f..d4011cc 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -1684,6 +1684,7 @@ static int nested_svm_vmrun(struct vcpu_svm *svm, void *arg1,
 {
 	struct vmcb *nested_vmcb = (struct vmcb *)arg1;
 	struct vmcb *hsave = svm->hsave;
+	struct vmcb *vmcb = svm->vmcb;
 
 	/* nested_vmcb is our indicator if nested SVM is activated */
 	svm->nested_vmcb = svm->vmcb->save.rax;
@@ -1694,12 +1695,25 @@ static int nested_svm_vmrun(struct vcpu_svm *svm, void *arg1,
 
 	/* Save the old vmcb, so we don't need to pick what we save, but
 	   can restore everything when a VMEXIT occurs */
-	memcpy(hsave, svm->vmcb, sizeof(struct vmcb));
-	/* We need to remember the original CR3 in the SPT case */
-	if (!npt_enabled)
-		hsave->save.cr3 = svm->vcpu.arch.cr3;
-	hsave->save.cr4 = svm->vcpu.arch.cr4;
-	hsave->save.rip = svm->next_rip;
+	hsave->save.es     = vmcb->save.es;
+	hsave->save.cs     = vmcb->save.cs;
+	hsave->save.ss     = vmcb->save.ss;
+	hsave->save.ds     = vmcb->save.ds;
+	hsave->save.gdtr   = vmcb->save.gdtr;
+	hsave->save.idtr   = vmcb->save.idtr;
+	hsave->save.efer   = svm->vcpu.arch.shadow_efer;
+	hsave->save.cr0    = svm->vcpu.arch.cr0;
+	hsave->save.cr4    = svm->vcpu.arch.cr4;
+	hsave->save.rflags = vmcb->save.rflags;
+	hsave->save.rip    = svm->next_rip;
+	hsave->save.rsp    = vmcb->save.rsp;
+	hsave->save.rax    = vmcb->save.rax;
+	if (npt_enabled)
+		hsave->save.cr3    = vmcb->save.cr3;
+	else
+		hsave->save.cr3    = svm->vcpu.arch.cr3;
+
+	hsave->control = vmcb->control;
 
 	if (svm->vmcb->save.rflags & X86_EFLAGS_IF)
 		svm->vcpu.arch.hflags |= HF_HIF_MASK;
@@ -1724,7 +1738,7 @@ static int nested_svm_vmrun(struct vcpu_svm *svm, void *arg1,
 		kvm_set_cr3(&svm->vcpu, nested_vmcb->save.cr3);
 		kvm_mmu_reset_context(&svm->vcpu);
 	}
-	svm->vmcb->save.cr2 = nested_vmcb->save.cr2;
+	svm->vmcb->save.cr2 = svm->vcpu.arch.cr2 = nested_vmcb->save.cr2;
 	kvm_register_write(&svm->vcpu, VCPU_REGS_RAX, nested_vmcb->save.rax);
 	kvm_register_write(&svm->vcpu, VCPU_REGS_RSP, nested_vmcb->save.rsp);
 	kvm_register_write(&svm->vcpu, VCPU_REGS_RIP, nested_vmcb->save.rip);
-- 
1.6.3.3


