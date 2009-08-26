Return-Path: <linux-kernel-owner+w=401wt.eu-S932567AbZHZKfm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932567AbZHZKfm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Aug 2009 06:35:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757100AbZHZKdk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Aug 2009 06:33:40 -0400
Received: from mx1.redhat.com ([209.132.183.28]:54740 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757092AbZHZKaN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Aug 2009 06:30:13 -0400
From: Avi Kivity <avi@redhat.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 24/47] KVM: SVM: clean up nestec vmload/vmsave paths
Date: Wed, 26 Aug 2009 13:29:46 +0300
Message-Id: <1251282609-12835-25-git-send-email-avi@redhat.com>
In-Reply-To: <1251282609-12835-1-git-send-email-avi@redhat.com>
References: <1251282609-12835-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Joerg Roedel <joerg.roedel@amd.com>

This patch removes the usage of nested_svm_do from the vmload and
vmsave emulation code paths.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
Signed-off-by: Avi Kivity <avi@redhat.com>
---
 arch/x86/kvm/svm.c |   36 +++++++++++++++++-------------------
 1 files changed, 17 insertions(+), 19 deletions(-)

diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index 518d578..419e3fa 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -128,8 +128,6 @@ static void svm_complete_interrupts(struct vcpu_svm *svm);
 
 static int nested_svm_exit_handled(struct vcpu_svm *svm, bool kvm_override);
 static int nested_svm_vmexit(struct vcpu_svm *svm);
-static int nested_svm_vmsave(struct vcpu_svm *svm, void *nested_vmcb,
-			     void *arg2, void *opaque);
 static int nested_svm_check_exception(struct vcpu_svm *svm, unsigned nr,
 				      bool has_error_code, u32 error_code);
 
@@ -1868,7 +1866,7 @@ static int nested_svm_vmrun(struct vcpu_svm *svm, void *arg1,
 	return 0;
 }
 
-static int nested_svm_vmloadsave(struct vmcb *from_vmcb, struct vmcb *to_vmcb)
+static void nested_svm_vmloadsave(struct vmcb *from_vmcb, struct vmcb *to_vmcb)
 {
 	to_vmcb->save.fs = from_vmcb->save.fs;
 	to_vmcb->save.gs = from_vmcb->save.gs;
@@ -1882,44 +1880,44 @@ static int nested_svm_vmloadsave(struct vmcb *from_vmcb, struct vmcb *to_vmcb)
 	to_vmcb->save.sysenter_cs = from_vmcb->save.sysenter_cs;
 	to_vmcb->save.sysenter_esp = from_vmcb->save.sysenter_esp;
 	to_vmcb->save.sysenter_eip = from_vmcb->save.sysenter_eip;
-
-	return 1;
-}
-
-static int nested_svm_vmload(struct vcpu_svm *svm, void *nested_vmcb,
-			     void *arg2, void *opaque)
-{
-	return nested_svm_vmloadsave((struct vmcb *)nested_vmcb, svm->vmcb);
-}
-
-static int nested_svm_vmsave(struct vcpu_svm *svm, void *nested_vmcb,
-			     void *arg2, void *opaque)
-{
-	return nested_svm_vmloadsave(svm->vmcb, (struct vmcb *)nested_vmcb);
 }
 
 static int vmload_interception(struct vcpu_svm *svm, struct kvm_run *kvm_run)
 {
+	struct vmcb *nested_vmcb;
+
 	if (nested_svm_check_permissions(svm))
 		return 1;
 
 	svm->next_rip = kvm_rip_read(&svm->vcpu) + 3;
 	skip_emulated_instruction(&svm->vcpu);
 
-	nested_svm_do(svm, svm->vmcb->save.rax, 0, NULL, nested_svm_vmload);
+	nested_vmcb = nested_svm_map(svm, svm->vmcb->save.rax, KM_USER0);
+	if (!nested_vmcb)
+		return 1;
+
+	nested_svm_vmloadsave(nested_vmcb, svm->vmcb);
+	nested_svm_unmap(nested_vmcb, KM_USER0);
 
 	return 1;
 }
 
 static int vmsave_interception(struct vcpu_svm *svm, struct kvm_run *kvm_run)
 {
+	struct vmcb *nested_vmcb;
+
 	if (nested_svm_check_permissions(svm))
 		return 1;
 
 	svm->next_rip = kvm_rip_read(&svm->vcpu) + 3;
 	skip_emulated_instruction(&svm->vcpu);
 
-	nested_svm_do(svm, svm->vmcb->save.rax, 0, NULL, nested_svm_vmsave);
+	nested_vmcb = nested_svm_map(svm, svm->vmcb->save.rax, KM_USER0);
+	if (!nested_vmcb)
+		return 1;
+
+	nested_svm_vmloadsave(svm->vmcb, nested_vmcb);
+	nested_svm_unmap(nested_vmcb, KM_USER0);
 
 	return 1;
 }
-- 
1.6.4.1

