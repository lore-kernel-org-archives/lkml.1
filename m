Return-Path: <linux-kernel-owner+w=401wt.eu-S1760817AbZBZOar@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760817AbZBZOar (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Feb 2009 09:30:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758078AbZBZORv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Feb 2009 09:17:51 -0500
Received: from mx2.redhat.com ([66.187.237.31]:43066 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754191AbZBZOPl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Feb 2009 09:15:41 -0500
From: Avi Kivity <avi@redhat.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Alexander Graf <agraf@suse.de>
Subject: [PATCH 06/40] KVM: SVM: Add VMLOAD and VMSAVE handlers
Date: Thu, 26 Feb 2009 16:14:56 +0200
Message-Id: <1235657730-27683-7-git-send-email-avi@redhat.com>
In-Reply-To: <1235657730-27683-1-git-send-email-avi@redhat.com>
References: <1235657730-27683-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alexander Graf <agraf@suse.de>

This implements the VMLOAD and VMSAVE instructions, that usually surround
the VMRUN instructions. Both instructions load / restore the same elements,
so we only need to implement them once.

v2 fixes CPL checking and replaces memcpy by assignments
v3 makes use of the new permission checking

Acked-by: Joerg Roedel <joro@8bytes.org>
Signed-off-by: Alexander Graf <agraf@suse.de>
Signed-off-by: Avi Kivity <avi@redhat.com>
---
 arch/x86/kvm/svm.c |   60 ++++++++++++++++++++++++++++++++++++++++++++++++++-
 1 files changed, 58 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index 59aaff1..a83c94e 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -1243,6 +1243,62 @@ static int nested_svm_do(struct vcpu_svm *svm,
 	return retval;
 }
 
+static int nested_svm_vmloadsave(struct vmcb *from_vmcb, struct vmcb *to_vmcb)
+{
+	to_vmcb->save.fs = from_vmcb->save.fs;
+	to_vmcb->save.gs = from_vmcb->save.gs;
+	to_vmcb->save.tr = from_vmcb->save.tr;
+	to_vmcb->save.ldtr = from_vmcb->save.ldtr;
+	to_vmcb->save.kernel_gs_base = from_vmcb->save.kernel_gs_base;
+	to_vmcb->save.star = from_vmcb->save.star;
+	to_vmcb->save.lstar = from_vmcb->save.lstar;
+	to_vmcb->save.cstar = from_vmcb->save.cstar;
+	to_vmcb->save.sfmask = from_vmcb->save.sfmask;
+	to_vmcb->save.sysenter_cs = from_vmcb->save.sysenter_cs;
+	to_vmcb->save.sysenter_esp = from_vmcb->save.sysenter_esp;
+	to_vmcb->save.sysenter_eip = from_vmcb->save.sysenter_eip;
+
+	return 1;
+}
+
+static int nested_svm_vmload(struct vcpu_svm *svm, void *nested_vmcb,
+			     void *arg2, void *opaque)
+{
+	return nested_svm_vmloadsave((struct vmcb *)nested_vmcb, svm->vmcb);
+}
+
+static int nested_svm_vmsave(struct vcpu_svm *svm, void *nested_vmcb,
+			     void *arg2, void *opaque)
+{
+	return nested_svm_vmloadsave(svm->vmcb, (struct vmcb *)nested_vmcb);
+}
+
+static int vmload_interception(struct vcpu_svm *svm, struct kvm_run *kvm_run)
+{
+	if (nested_svm_check_permissions(svm))
+		return 1;
+
+	svm->next_rip = kvm_rip_read(&svm->vcpu) + 3;
+	skip_emulated_instruction(&svm->vcpu);
+
+	nested_svm_do(svm, svm->vmcb->save.rax, 0, NULL, nested_svm_vmload);
+
+	return 1;
+}
+
+static int vmsave_interception(struct vcpu_svm *svm, struct kvm_run *kvm_run)
+{
+	if (nested_svm_check_permissions(svm))
+		return 1;
+
+	svm->next_rip = kvm_rip_read(&svm->vcpu) + 3;
+	skip_emulated_instruction(&svm->vcpu);
+
+	nested_svm_do(svm, svm->vmcb->save.rax, 0, NULL, nested_svm_vmsave);
+
+	return 1;
+}
+
 static int stgi_interception(struct vcpu_svm *svm, struct kvm_run *kvm_run)
 {
 	if (nested_svm_check_permissions(svm))
@@ -1578,8 +1634,8 @@ static int (*svm_exit_handlers[])(struct vcpu_svm *svm,
 	[SVM_EXIT_SHUTDOWN]			= shutdown_interception,
 	[SVM_EXIT_VMRUN]			= invalid_op_interception,
 	[SVM_EXIT_VMMCALL]			= vmmcall_interception,
-	[SVM_EXIT_VMLOAD]			= invalid_op_interception,
-	[SVM_EXIT_VMSAVE]			= invalid_op_interception,
+	[SVM_EXIT_VMLOAD]			= vmload_interception,
+	[SVM_EXIT_VMSAVE]			= vmsave_interception,
 	[SVM_EXIT_STGI]				= stgi_interception,
 	[SVM_EXIT_CLGI]				= clgi_interception,
 	[SVM_EXIT_SKINIT]			= invalid_op_interception,
-- 
1.6.0.6

