Return-Path: <linux-kernel-owner+w=401wt.eu-S932750AbZHZKj0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932750AbZHZKj0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Aug 2009 06:39:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932511AbZHZKik
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Aug 2009 06:38:40 -0400
Received: from mx1.redhat.com ([209.132.183.28]:46158 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757004AbZHZKaM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Aug 2009 06:30:12 -0400
From: Avi Kivity <avi@redhat.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 15/47] KVM: SVM: copy only necessary parts of the control area on vmrun/vmexit
Date: Wed, 26 Aug 2009 13:29:37 +0300
Message-Id: <1251282609-12835-16-git-send-email-avi@redhat.com>
In-Reply-To: <1251282609-12835-1-git-send-email-avi@redhat.com>
References: <1251282609-12835-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Joerg Roedel <joerg.roedel@amd.com>

The vmcb control area contains more then 800 bytes of reserved fields
which are unnecessarily copied. Fix this by introducing a copy
function which only copies the relevant part and saves time.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
Acked-by: Alexander Graf <agraf@suse.de>
Signed-off-by: Avi Kivity <avi@redhat.com>
---
 arch/x86/kvm/svm.c |   36 ++++++++++++++++++++++++++++++++++--
 1 files changed, 34 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index f11f880..df795bc 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -1567,6 +1567,38 @@ static int nested_svm_exit_handled(struct vcpu_svm *svm, bool kvm_override)
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
@@ -1612,7 +1644,7 @@ static int nested_svm_vmexit_real(struct vcpu_svm *svm, void *arg1,
 		nested_vmcb->control.int_ctl &= ~V_INTR_MASKING_MASK;
 
 	/* Restore the original control entries */
-	svm->vmcb->control = hsave->control;
+	copy_vmcb_control_area(vmcb, hsave);
 
 	/* Kill any pending exceptions */
 	if (svm->vcpu.arch.exception.pending == true)
@@ -1710,7 +1742,7 @@ static int nested_svm_vmrun(struct vcpu_svm *svm, void *arg1,
 	else
 		hsave->save.cr3    = svm->vcpu.arch.cr3;
 
-	hsave->control = vmcb->control;
+	copy_vmcb_control_area(hsave, vmcb);
 
 	if (svm->vmcb->save.rflags & X86_EFLAGS_IF)
 		svm->vcpu.arch.hflags |= HF_HIF_MASK;
-- 
1.6.4.1

