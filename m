Return-Path: <linux-kernel-owner+w=401wt.eu-S1754830AbZG2M5N@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754830AbZG2M5N (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jul 2009 08:57:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754806AbZG2M5M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Jul 2009 08:57:12 -0400
Received: from tx2ehsobe001.messaging.microsoft.com ([65.55.88.11]:43995 "EHLO
	TX2EHSOBE002.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754669AbZG2M47 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jul 2009 08:56:59 -0400
X-SpamScore: 3
X-BigFish: VPS3(zzzz1202hzzz32i203h43j62h)
X-Spam-TCS-SCL: 1:0
X-FB-SS: 5,8,
X-WSS-ID: 0KNJNYG-03-5SR-01
From: Joerg Roedel <joerg.roedel@amd.com>
To: Avi Kivity <avi@redhat.com>
CC: Alexander Graf <agraf@suse.de>, kvm@vger.kernel.org,
       linux-kernel@vger.kernel.org, Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 04/12] kvm/svm: optimize nested vmrun
Date: Wed, 29 Jul 2009 14:56:24 +0200
Message-ID: <1248872192-30881-5-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1248872192-30881-1-git-send-email-joerg.roedel@amd.com>
References: <1248872192-30881-1-git-send-email-joerg.roedel@amd.com>
X-OriginalArrivalTime: 29 Jul 2009 12:56:36.0999 (UTC) FILETIME=[01F6C970:01CA104C]
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Only copy the necessary parts of the vmcb save area on vmrun and save
precious time.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 arch/x86/kvm/svm.c |   26 ++++++++++++++++++++------
 1 files changed, 20 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index 3e794f0..b85da3f 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -1688,6 +1688,7 @@ static int nested_svm_vmrun(struct vcpu_svm *svm, void *arg1,
 {
 	struct vmcb *nested_vmcb = (struct vmcb *)arg1;
 	struct vmcb *hsave = svm->hsave;
+	struct vmcb *vmcb = svm->vmcb;
 
 	/* nested_vmcb is our indicator if nested SVM is activated */
 	svm->nested_vmcb = svm->vmcb->save.rax;
@@ -1698,12 +1699,25 @@ static int nested_svm_vmrun(struct vcpu_svm *svm, void *arg1,
 
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
-- 
1.6.3.3


