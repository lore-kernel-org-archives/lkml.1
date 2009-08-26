Return-Path: <linux-kernel-owner+w=401wt.eu-S932615AbZHZKgT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932615AbZHZKgT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Aug 2009 06:36:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932545AbZHZKdi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Aug 2009 06:33:38 -0400
Received: from mx1.redhat.com ([209.132.183.28]:27903 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757100AbZHZKaN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Aug 2009 06:30:13 -0400
From: Avi Kivity <avi@redhat.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 25/47] KVM: SVM: clean up nested vmrun path
Date: Wed, 26 Aug 2009 13:29:47 +0300
Message-Id: <1251282609-12835-26-git-send-email-avi@redhat.com>
In-Reply-To: <1251282609-12835-1-git-send-email-avi@redhat.com>
References: <1251282609-12835-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Joerg Roedel <joerg.roedel@amd.com>

This patch removes the usage of nested_svm_do from the vmrun emulation
path.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
Signed-off-by: Avi Kivity <avi@redhat.com>
---
 arch/x86/kvm/svm.c |   34 ++++++++++++++++++++++------------
 1 files changed, 22 insertions(+), 12 deletions(-)

diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index 419e3fa..1a915f3 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -1727,25 +1727,35 @@ static int nested_svm_vmexit(struct vcpu_svm *svm)
 	return 0;
 }
 
-static int nested_svm_vmrun_msrpm(struct vcpu_svm *svm, void *arg1,
-				  void *arg2, void *opaque)
+static bool nested_svm_vmrun_msrpm(struct vcpu_svm *svm)
 {
+	u32 *nested_msrpm;
 	int i;
-	u32 *nested_msrpm = (u32*)arg1;
+
+	nested_msrpm = nested_svm_map(svm, svm->nested.vmcb_msrpm, KM_USER0);
+	if (!nested_msrpm)
+		return false;
+
 	for (i=0; i< PAGE_SIZE * (1 << MSRPM_ALLOC_ORDER) / 4; i++)
 		svm->nested.msrpm[i] = svm->msrpm[i] | nested_msrpm[i];
+
 	svm->vmcb->control.msrpm_base_pa = __pa(svm->nested.msrpm);
 
-	return 0;
+	nested_svm_unmap(nested_msrpm, KM_USER0);
+
+	return true;
 }
 
-static int nested_svm_vmrun(struct vcpu_svm *svm, void *arg1,
-			    void *arg2, void *opaque)
+static bool nested_svm_vmrun(struct vcpu_svm *svm)
 {
-	struct vmcb *nested_vmcb = (struct vmcb *)arg1;
+	struct vmcb *nested_vmcb;
 	struct vmcb *hsave = svm->nested.hsave;
 	struct vmcb *vmcb = svm->vmcb;
 
+	nested_vmcb = nested_svm_map(svm, svm->vmcb->save.rax, KM_USER0);
+	if (!nested_vmcb)
+		return false;
+
 	/* nested_vmcb is our indicator if nested SVM is activated */
 	svm->nested.vmcb = svm->vmcb->save.rax;
 
@@ -1861,9 +1871,11 @@ static int nested_svm_vmrun(struct vcpu_svm *svm, void *arg1,
 	svm->vmcb->control.event_inj = nested_vmcb->control.event_inj;
 	svm->vmcb->control.event_inj_err = nested_vmcb->control.event_inj_err;
 
+	nested_svm_unmap(nested_vmcb, KM_USER0);
+
 	enable_gif(svm);
 
-	return 0;
+	return true;
 }
 
 static void nested_svm_vmloadsave(struct vmcb *from_vmcb, struct vmcb *to_vmcb)
@@ -1931,12 +1943,10 @@ static int vmrun_interception(struct vcpu_svm *svm, struct kvm_run *kvm_run)
 	svm->next_rip = kvm_rip_read(&svm->vcpu) + 3;
 	skip_emulated_instruction(&svm->vcpu);
 
-	if (nested_svm_do(svm, svm->vmcb->save.rax, 0,
-			  NULL, nested_svm_vmrun))
+	if (!nested_svm_vmrun(svm))
 		return 1;
 
-	if (nested_svm_do(svm, svm->nested.vmcb_msrpm, 0,
-		      NULL, nested_svm_vmrun_msrpm))
+	if (!nested_svm_vmrun_msrpm(svm))
 		return 1;
 
 	return 1;
-- 
1.6.4.1

