Return-Path: <linux-kernel-owner+w=401wt.eu-S1755990AbZHGJuX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755990AbZHGJuX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Aug 2009 05:50:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753185AbZHGJuU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Aug 2009 05:50:20 -0400
Received: from tx2ehsobe001.messaging.microsoft.com ([65.55.88.11]:3589 "EHLO
	TX2EHSOBE002.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755909AbZHGJuJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Aug 2009 05:50:09 -0400
X-SpamScore: 3
X-BigFish: VPS3(zzzz1202hzzz32i203h43j62h)
X-Spam-TCS-SCL: 1:0
X-FB-SS: 5,
X-WSS-ID: 0KO03BC-03-0WX-01
From: Joerg Roedel <joerg.roedel@amd.com>
To: Avi Kivity <avi@redhat.com>
CC: Alexander Graf <agraf@suse.de>, kvm@vger.kernel.org,
       linux-kernel@vger.kernel.org, Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 13/21] kvm/svm: clean up nestec vmload/vmsave paths
Date: Fri, 7 Aug 2009 11:49:40 +0200
Message-ID: <1249638588-10982-14-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1249638588-10982-1-git-send-email-joerg.roedel@amd.com>
References: <1249638588-10982-1-git-send-email-joerg.roedel@amd.com>
X-OriginalArrivalTime: 07 Aug 2009 09:49:51.0202 (UTC) FILETIME=[68819C20:01CA1744]
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch removes the usage of nested_svm_do from the vmload and
vmsave emulation code paths.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 arch/x86/kvm/svm.c |   36 +++++++++++++++++-------------------
 1 files changed, 17 insertions(+), 19 deletions(-)

diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index 448d493..c2ca953 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -129,8 +129,6 @@ static void svm_complete_interrupts(struct vcpu_svm *svm);
 
 static int nested_svm_exit_handled(struct vcpu_svm *svm, bool kvm_override);
 static int nested_svm_vmexit(struct vcpu_svm *svm);
-static int nested_svm_vmsave(struct vcpu_svm *svm, void *nested_vmcb,
-			     void *arg2, void *opaque);
 static int nested_svm_check_exception(struct vcpu_svm *svm, unsigned nr,
 				      bool has_error_code, u32 error_code);
 
@@ -1871,7 +1869,7 @@ static int nested_svm_vmrun(struct vcpu_svm *svm, void *arg1,
 	return 0;
 }
 
-static int nested_svm_vmloadsave(struct vmcb *from_vmcb, struct vmcb *to_vmcb)
+static void nested_svm_vmloadsave(struct vmcb *from_vmcb, struct vmcb *to_vmcb)
 {
 	to_vmcb->save.fs = from_vmcb->save.fs;
 	to_vmcb->save.gs = from_vmcb->save.gs;
@@ -1885,44 +1883,44 @@ static int nested_svm_vmloadsave(struct vmcb *from_vmcb, struct vmcb *to_vmcb)
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
1.6.3.3


