Return-Path: <linux-kernel-owner+w=401wt.eu-S932736AbZHZKiz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932736AbZHZKiz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Aug 2009 06:38:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932690AbZHZKin
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Aug 2009 06:38:43 -0400
Received: from mx1.redhat.com ([209.132.183.28]:34880 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757038AbZHZKaM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Aug 2009 06:30:12 -0400
From: Avi Kivity <avi@redhat.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 14/47] KVM: SVM: optimize nested vmrun
Date: Wed, 26 Aug 2009 13:29:36 +0300
Message-Id: <1251282609-12835-15-git-send-email-avi@redhat.com>
In-Reply-To: <1251282609-12835-1-git-send-email-avi@redhat.com>
References: <1251282609-12835-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Joerg Roedel <joerg.roedel@amd.com>

Only copy the necessary parts of the vmcb save area on vmrun and save
precious time.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
Acked-by: Alexander Graf <agraf@suse.de>
Signed-off-by: Avi Kivity <avi@redhat.com>
---
 arch/x86/kvm/svm.c |   28 +++++++++++++++++++++-------
 1 files changed, 21 insertions(+), 7 deletions(-)

diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index 2f5f223..f11f880 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -1681,6 +1681,7 @@ static int nested_svm_vmrun(struct vcpu_svm *svm, void *arg1,
 {
 	struct vmcb *nested_vmcb = (struct vmcb *)arg1;
 	struct vmcb *hsave = svm->hsave;
+	struct vmcb *vmcb = svm->vmcb;
 
 	/* nested_vmcb is our indicator if nested SVM is activated */
 	svm->nested_vmcb = svm->vmcb->save.rax;
@@ -1691,12 +1692,25 @@ static int nested_svm_vmrun(struct vcpu_svm *svm, void *arg1,
 
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
@@ -1721,7 +1735,7 @@ static int nested_svm_vmrun(struct vcpu_svm *svm, void *arg1,
 		kvm_set_cr3(&svm->vcpu, nested_vmcb->save.cr3);
 		kvm_mmu_reset_context(&svm->vcpu);
 	}
-	svm->vmcb->save.cr2 = nested_vmcb->save.cr2;
+	svm->vmcb->save.cr2 = svm->vcpu.arch.cr2 = nested_vmcb->save.cr2;
 	kvm_register_write(&svm->vcpu, VCPU_REGS_RAX, nested_vmcb->save.rax);
 	kvm_register_write(&svm->vcpu, VCPU_REGS_RSP, nested_vmcb->save.rsp);
 	kvm_register_write(&svm->vcpu, VCPU_REGS_RIP, nested_vmcb->save.rip);
-- 
1.6.4.1

