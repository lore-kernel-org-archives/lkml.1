Return-Path: <linux-kernel-owner+w=401wt.eu-S1757065AbZHGJu2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757065AbZHGJu2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Aug 2009 05:50:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756051AbZHGJu0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Aug 2009 05:50:26 -0400
Received: from va3ehsobe005.messaging.microsoft.com ([216.32.180.15]:57452
	"EHLO VA3EHSOBE006.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755881AbZHGJuH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Aug 2009 05:50:07 -0400
X-SpamScore: 3
X-BigFish: VPS3(zzzz1202hzzz32i203h43j62h)
X-Spam-TCS-SCL: 1:0
X-WSS-ID: 0KO03BB-04-L8I-01
From: Joerg Roedel <joerg.roedel@amd.com>
To: Avi Kivity <avi@redhat.com>
CC: Alexander Graf <agraf@suse.de>, kvm@vger.kernel.org,
       linux-kernel@vger.kernel.org, Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 14/21] kvm/svm: clean up nested vmrun path
Date: Fri, 7 Aug 2009 11:49:41 +0200
Message-ID: <1249638588-10982-15-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1249638588-10982-1-git-send-email-joerg.roedel@amd.com>
References: <1249638588-10982-1-git-send-email-joerg.roedel@amd.com>
X-OriginalArrivalTime: 07 Aug 2009 09:49:51.0202 (UTC) FILETIME=[68819C20:01CA1744]
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch removes the usage of nested_svm_do from the vmrun emulation
path.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 arch/x86/kvm/svm.c |   34 ++++++++++++++++++++++------------
 1 files changed, 22 insertions(+), 12 deletions(-)

diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index c2ca953..c1e3f46 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -1730,25 +1730,35 @@ static int nested_svm_vmexit(struct vcpu_svm *svm)
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
 
@@ -1864,9 +1874,11 @@ static int nested_svm_vmrun(struct vcpu_svm *svm, void *arg1,
 	svm->vmcb->control.event_inj = nested_vmcb->control.event_inj;
 	svm->vmcb->control.event_inj_err = nested_vmcb->control.event_inj_err;
 
+	nested_svm_unmap(nested_vmcb, KM_USER0);
+
 	enable_gif(svm);
 
-	return 0;
+	return true;
 }
 
 static void nested_svm_vmloadsave(struct vmcb *from_vmcb, struct vmcb *to_vmcb)
@@ -1934,12 +1946,10 @@ static int vmrun_interception(struct vcpu_svm *svm, struct kvm_run *kvm_run)
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
1.6.3.3


