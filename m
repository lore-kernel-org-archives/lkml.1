Return-Path: <linux-kernel-owner+w=401wt.eu-S1754773AbZG2M44@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754773AbZG2M44 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jul 2009 08:56:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754669AbZG2M4z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Jul 2009 08:56:55 -0400
Received: from tx2ehsobe003.messaging.microsoft.com ([65.55.88.13]:19610 "EHLO
	TX2EHSOBE005.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751194AbZG2M4y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jul 2009 08:56:54 -0400
X-SpamScore: 3
X-BigFish: VPS3(zzzz1202hzzz32i203h43j62h)
X-Spam-TCS-SCL: 1:0
X-FB-SS: 5,
X-WSS-ID: 0KNJNYF-04-3ZY-01
From: Joerg Roedel <joerg.roedel@amd.com>
To: Avi Kivity <avi@redhat.com>
CC: Alexander Graf <agraf@suse.de>, kvm@vger.kernel.org,
       linux-kernel@vger.kernel.org, Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 03/12] kvm/svm: optimize nested #vmexit
Date: Wed, 29 Jul 2009 14:56:23 +0200
Message-ID: <1248872192-30881-4-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1248872192-30881-1-git-send-email-joerg.roedel@amd.com>
References: <1248872192-30881-1-git-send-email-joerg.roedel@amd.com>
X-OriginalArrivalTime: 29 Jul 2009 12:56:36.0655 (UTC) FILETIME=[01C24BF0:01CA104C]
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It is more efficient to copy only the relevant parts of the vmcb back to
the nested vmcb when we emulate an vmexit.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 arch/x86/kvm/svm.c |   68 +++++++++++++++++++++++++--------------------------
 1 files changed, 33 insertions(+), 35 deletions(-)

diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index 9f69b25..3e794f0 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -1579,53 +1579,52 @@ static int nested_svm_vmexit_real(struct vcpu_svm *svm, void *arg1,
 {
 	struct vmcb *nested_vmcb = (struct vmcb *)arg1;
 	struct vmcb *hsave = svm->hsave;
-	u64 nested_save[] = { nested_vmcb->save.cr0,
-			      nested_vmcb->save.cr3,
-			      nested_vmcb->save.cr4,
-			      nested_vmcb->save.efer,
-			      nested_vmcb->control.intercept_cr_read,
-			      nested_vmcb->control.intercept_cr_write,
-			      nested_vmcb->control.intercept_dr_read,
-			      nested_vmcb->control.intercept_dr_write,
-			      nested_vmcb->control.intercept_exceptions,
-			      nested_vmcb->control.intercept,
-			      nested_vmcb->control.msrpm_base_pa,
-			      nested_vmcb->control.iopm_base_pa,
-			      nested_vmcb->control.tsc_offset };
+	struct vmcb *vmcb = svm->vmcb;
 
 	/* Give the current vmcb to the guest */
-	memcpy(nested_vmcb, svm->vmcb, sizeof(struct vmcb));
-	nested_vmcb->save.cr0 = nested_save[0];
-	if (!npt_enabled)
-		nested_vmcb->save.cr3 = nested_save[1];
-	nested_vmcb->save.cr4 = nested_save[2];
-	nested_vmcb->save.efer = nested_save[3];
-	nested_vmcb->control.intercept_cr_read = nested_save[4];
-	nested_vmcb->control.intercept_cr_write = nested_save[5];
-	nested_vmcb->control.intercept_dr_read = nested_save[6];
-	nested_vmcb->control.intercept_dr_write = nested_save[7];
-	nested_vmcb->control.intercept_exceptions = nested_save[8];
-	nested_vmcb->control.intercept = nested_save[9];
-	nested_vmcb->control.msrpm_base_pa = nested_save[10];
-	nested_vmcb->control.iopm_base_pa = nested_save[11];
-	nested_vmcb->control.tsc_offset = nested_save[12];
+	disable_gif(svm);
+
+	nested_vmcb->save.es     = vmcb->save.es;
+	nested_vmcb->save.cs     = vmcb->save.cs;
+	nested_vmcb->save.ss     = vmcb->save.ss;
+	nested_vmcb->save.ds     = vmcb->save.ds;
+	nested_vmcb->save.gdtr   = vmcb->save.gdtr;
+	nested_vmcb->save.idtr   = vmcb->save.idtr;
+	if (npt_enabled)
+		nested_vmcb->save.cr3    = vmcb->save.cr3;
+	nested_vmcb->save.cr2    = vmcb->save.cr2;
+	nested_vmcb->save.rflags = vmcb->save.rflags;
+	nested_vmcb->save.rip    = vmcb->save.rip;
+	nested_vmcb->save.rsp    = vmcb->save.rsp;
+	nested_vmcb->save.rax    = vmcb->save.rax;
+	nested_vmcb->save.dr7    = vmcb->save.dr7;
+	nested_vmcb->save.dr6    = vmcb->save.dr6;
+	nested_vmcb->save.cpl    = vmcb->save.cpl;
+
+	nested_vmcb->control.int_ctl           = vmcb->control.int_ctl;
+	nested_vmcb->control.int_vector        = vmcb->control.int_vector;
+	nested_vmcb->control.int_state         = vmcb->control.int_state;
+	nested_vmcb->control.exit_code         = vmcb->control.exit_code;
+	nested_vmcb->control.exit_code_hi      = vmcb->control.exit_code_hi;
+	nested_vmcb->control.exit_info_1       = vmcb->control.exit_info_1;
+	nested_vmcb->control.exit_info_2       = vmcb->control.exit_info_2;
+	nested_vmcb->control.exit_int_info     = vmcb->control.exit_int_info;
+	nested_vmcb->control.exit_int_info_err = vmcb->control.exit_int_info_err;
+	nested_vmcb->control.tlb_ctl           = 0;
+	nested_vmcb->control.event_inj         = 0;
+	nested_vmcb->control.event_inj_err     = 0;
 
 	/* We always set V_INTR_MASKING and remember the old value in hflags */
 	if (!(svm->vcpu.arch.hflags & HF_VINTR_MASK))
 		nested_vmcb->control.int_ctl &= ~V_INTR_MASKING_MASK;
 
-	if ((nested_vmcb->control.int_ctl & V_IRQ_MASK) &&
-	    (nested_vmcb->control.int_vector)) {
-		nsvm_printk("WARNING: IRQ 0x%x still enabled on #VMEXIT\n",
-				nested_vmcb->control.int_vector);
-	}
-
 	/* Restore the original control entries */
 	svm->vmcb->control = hsave->control;
 
 	/* Kill any pending exceptions */
 	if (svm->vcpu.arch.exception.pending == true)
 		nsvm_printk("WARNING: Pending Exception\n");
+
 	kvm_clear_exception_queue(&svm->vcpu);
 	kvm_clear_interrupt_queue(&svm->vcpu);
 
@@ -1653,7 +1652,6 @@ static int nested_svm_vmexit_real(struct vcpu_svm *svm, void *arg1,
 	svm->vmcb->save.cpl = 0;
 	svm->vmcb->control.exit_int_info = 0;
 
-	disable_gif(svm);
 	/* Exit nested SVM mode */
 	svm->nested_vmcb = 0;
 
-- 
1.6.3.3


