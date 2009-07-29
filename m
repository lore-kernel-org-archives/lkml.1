Return-Path: <linux-kernel-owner+w=401wt.eu-S1754954AbZG2M5Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754954AbZG2M5Z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jul 2009 08:57:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754909AbZG2M5Y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Jul 2009 08:57:24 -0400
Received: from va3ehsobe003.messaging.microsoft.com ([216.32.180.13]:51935
	"EHLO VA3EHSOBE003.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754796AbZG2M5E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jul 2009 08:57:04 -0400
X-SpamScore: 3
X-BigFish: VPS3(zzzz1202hzzz32i203h43j65h)
X-Spam-TCS-SCL: 4:0
X-FB-SS: 5,
X-WSS-ID: 0KNJNYI-04-403-01
From: Joerg Roedel <joerg.roedel@amd.com>
To: Avi Kivity <avi@redhat.com>
CC: Alexander Graf <agraf@suse.de>, kvm@vger.kernel.org,
       linux-kernel@vger.kernel.org, Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 05/12] kvm/svm: copy only necessary parts of the control area on vmrun/vmexit
Date: Wed, 29 Jul 2009 14:56:25 +0200
Message-ID: <1248872192-30881-6-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1248872192-30881-1-git-send-email-joerg.roedel@amd.com>
References: <1248872192-30881-1-git-send-email-joerg.roedel@amd.com>
X-OriginalArrivalTime: 29 Jul 2009 12:56:37.0030 (UTC) FILETIME=[01FB8460:01CA104C]
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 arch/x86/kvm/svm.c |   36 ++++++++++++++++++++++++++++++++++--
 1 files changed, 34 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index b85da3f..0a0b3e1 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -1574,6 +1574,38 @@ static int nested_svm_exit_handled(struct vcpu_svm *svm, bool kvm_override)
 			     nested_svm_exit_handled_real);
 }
 
+static inline void copy_vmcb_control_area(struct vmcb *dst_vmcb, struct vmcb *from_vmcb)
+{
+	struct vmcb_control_area *dst  = &dst_vmcb->control;
+	struct vmcb_control_area *from = &from_vmcb->control;
+
+	dst->intercept_cr_read    = from->intercept_cr_read;
+	dst->intercept_cr_write   = from->intercept_cr_write;
+	dst->intercept_dr_read    = from->intercept_dr_read;
+	dst->intercept_dr_write   = from->intercept_dr_write;
+	dst->intercept_exceptions = from->intercept_exceptions;
+	dst->intercept            = from->intercept;
+	dst->iopm_base_pa         = from->iopm_base_pa;
+	dst->msrpm_base_pa        = from->msrpm_base_pa;
+	dst->tsc_offset           = from->tsc_offset;
+	dst->asid                 = from->asid;
+	dst->tlb_ctl              = from->tlb_ctl;
+	dst->int_ctl              = from->int_ctl;
+	dst->int_vector           = from->int_vector;
+	dst->int_state            = from->int_state;
+	dst->exit_code            = from->exit_code;
+	dst->exit_code_hi         = from->exit_code_hi;
+	dst->exit_info_1          = from->exit_info_1;
+	dst->exit_info_2          = from->exit_info_2;
+	dst->exit_int_info        = from->exit_int_info;
+	dst->exit_int_info_err    = from->exit_int_info_err;
+	dst->nested_ctl           = from->nested_ctl;
+	dst->event_inj            = from->event_inj;
+	dst->event_inj_err        = from->event_inj_err;
+	dst->nested_cr3           = from->nested_cr3;
+	dst->lbr_ctl              = from->lbr_ctl;
+}
+
 static int nested_svm_vmexit_real(struct vcpu_svm *svm, void *arg1,
 				  void *arg2, void *opaque)
 {
@@ -1619,7 +1651,7 @@ static int nested_svm_vmexit_real(struct vcpu_svm *svm, void *arg1,
 		nested_vmcb->control.int_ctl &= ~V_INTR_MASKING_MASK;
 
 	/* Restore the original control entries */
-	svm->vmcb->control = hsave->control;
+	copy_vmcb_control_area(vmcb, hsave);
 
 	/* Kill any pending exceptions */
 	if (svm->vcpu.arch.exception.pending == true)
@@ -1717,7 +1749,7 @@ static int nested_svm_vmrun(struct vcpu_svm *svm, void *arg1,
 	else
 		hsave->save.cr3    = svm->vcpu.arch.cr3;
 
-	hsave->control = vmcb->control;
+	copy_vmcb_control_area(hsave, vmcb);
 
 	if (svm->vmcb->save.rflags & X86_EFLAGS_IF)
 		svm->vcpu.arch.hflags |= HF_HIF_MASK;
-- 
1.6.3.3


