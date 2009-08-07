Return-Path: <linux-kernel-owner+w=401wt.eu-S932377AbZHGJvA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932377AbZHGJvA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Aug 2009 05:51:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932291AbZHGJu7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Aug 2009 05:50:59 -0400
Received: from outbound-dub.frontbridge.com ([213.199.154.16]:20613 "EHLO
	IE1EHSOBE004.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757167AbZHGJuj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Aug 2009 05:50:39 -0400
X-SpamScore: 3
X-BigFish: VPS3(zzzz1202hzzz32i203h43j62h)
X-Spam-TCS-SCL: 1:0
X-WSS-ID: 0KO03B6-04-L87-01
From: Joerg Roedel <joerg.roedel@amd.com>
To: Avi Kivity <avi@redhat.com>
CC: Alexander Graf <agraf@suse.de>, kvm@vger.kernel.org,
       linux-kernel@vger.kernel.org, Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 04/21] kvm/svm: copy only necessary parts of the control area on vmrun/vmexit
Date: Fri, 7 Aug 2009 11:49:31 +0200
Message-ID: <1249638588-10982-5-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1249638588-10982-1-git-send-email-joerg.roedel@amd.com>
References: <1249638588-10982-1-git-send-email-joerg.roedel@amd.com>
X-OriginalArrivalTime: 07 Aug 2009 09:49:50.0796 (UTC) FILETIME=[6843A8C0:01CA1744]
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The vmcb control area contains more then 800 bytes of reserved fields
which are unnecessarily copied. Fix this by introducing a copy
function which only copies the relevant part and saves time.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
Acked-by: Alexander Graf <agraf@suse.de>
---
 arch/x86/kvm/svm.c |   36 ++++++++++++++++++++++++++++++++++--
 1 files changed, 34 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index d4011cc..e656425 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -1570,6 +1570,38 @@ static int nested_svm_exit_handled(struct vcpu_svm *svm, bool kvm_override)
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
@@ -1615,7 +1647,7 @@ static int nested_svm_vmexit_real(struct vcpu_svm *svm, void *arg1,
 		nested_vmcb->control.int_ctl &= ~V_INTR_MASKING_MASK;
 
 	/* Restore the original control entries */
-	svm->vmcb->control = hsave->control;
+	copy_vmcb_control_area(vmcb, hsave);
 
 	/* Kill any pending exceptions */
 	if (svm->vcpu.arch.exception.pending == true)
@@ -1713,7 +1745,7 @@ static int nested_svm_vmrun(struct vcpu_svm *svm, void *arg1,
 	else
 		hsave->save.cr3    = svm->vcpu.arch.cr3;
 
-	hsave->control = vmcb->control;
+	copy_vmcb_control_area(hsave, vmcb);
 
 	if (svm->vmcb->save.rflags & X86_EFLAGS_IF)
 		svm->vcpu.arch.hflags |= HF_HIF_MASK;
-- 
1.6.3.3


