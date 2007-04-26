Return-Path: <linux-kernel-owner+w=401wt.eu-S933814AbXDZJWy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933814AbXDZJWy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2007 05:22:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933773AbXDZJWw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Apr 2007 05:22:52 -0400
Received: from il.qumranet.com ([82.166.9.18]:53029 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933801AbXDZJW2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2007 05:22:28 -0400
From: Avi Kivity <avi@qumranet.com>
To: kvm-devel@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org, Anthony Liguori <aliguori@us.ibm.com>,
       Avi Kivity <avi@qumranet.com>
Subject: [PATCH 17/18] KVM: Lazy FPU support for SVM
Date: Thu, 26 Apr 2007 12:22:17 +0300
Message-Id: <11775793381543-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.0.6
In-Reply-To: <11775793382353-git-send-email-avi@qumranet.com>
References: <11775793382353-git-send-email-avi@qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Anthony Liguori <aliguori@us.ibm.com>

Avoid saving and restoring the guest fpu state on every exit.  This
shaves ~100 cycles off the guest/host switch.

Signed-off-by: Anthony Liguori <aliguori@us.ibm.com>
Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 drivers/kvm/kvm.h |    2 ++
 drivers/kvm/svm.c |   35 +++++++++++++++++++++++++++++++----
 2 files changed, 33 insertions(+), 4 deletions(-)

diff --git a/drivers/kvm/kvm.h b/drivers/kvm/kvm.h
index d1a90c5..61ff085 100644
--- a/drivers/kvm/kvm.h
+++ b/drivers/kvm/kvm.h
@@ -63,6 +63,7 @@
 #define FX_BUF_SIZE (2 * FX_IMAGE_SIZE + FX_IMAGE_ALIGN)
 
 #define DE_VECTOR 0
+#define NM_VECTOR 7
 #define DF_VECTOR 8
 #define TS_VECTOR 10
 #define NP_VECTOR 11
@@ -301,6 +302,7 @@ struct kvm_vcpu {
 	char fx_buf[FX_BUF_SIZE];
 	char *host_fx_image;
 	char *guest_fx_image;
+	int fpu_active;
 
 	int mmio_needed;
 	int mmio_read_completed;
diff --git a/drivers/kvm/svm.c b/drivers/kvm/svm.c
index 644efc5..9438931 100644
--- a/drivers/kvm/svm.c
+++ b/drivers/kvm/svm.c
@@ -587,6 +587,7 @@ static int svm_create_vcpu(struct kvm_vcpu *vcpu)
 	init_vmcb(vcpu->svm->vmcb);
 
 	fx_init(vcpu);
+	vcpu->fpu_active = 1;
 	vcpu->apic_base = 0xfee00000 |
 			/*for vcpu 0*/ MSR_IA32_APICBASE_BSP |
 			MSR_IA32_APICBASE_ENABLE;
@@ -756,6 +757,11 @@ static void svm_set_cr0(struct kvm_vcpu *vcpu, unsigned long cr0)
 		}
 	}
 #endif
+	if ((vcpu->cr0 & CR0_TS_MASK) && !(cr0 & CR0_TS_MASK)) {
+		vcpu->svm->vmcb->control.intercept_exceptions &= ~(1 << NM_VECTOR);
+		vcpu->fpu_active = 1;
+	}
+ 
 	vcpu->cr0 = cr0;
 	cr0 |= CR0_PG_MASK | CR0_WP_MASK;
 	cr0 &= ~(CR0_CD_MASK | CR0_NW_MASK);
@@ -928,6 +934,16 @@ static int pf_interception(struct kvm_vcpu *vcpu, struct kvm_run *kvm_run)
 	return 0;
 }
 
+static int nm_interception(struct kvm_vcpu *vcpu, struct kvm_run *kvm_run)
+{
+       vcpu->svm->vmcb->control.intercept_exceptions &= ~(1 << NM_VECTOR);
+       if (!(vcpu->cr0 & CR0_TS_MASK))
+               vcpu->svm->vmcb->save.cr0 &= ~CR0_TS_MASK;
+       vcpu->fpu_active = 1;
+
+       return 1;
+}
+
 static int shutdown_interception(struct kvm_vcpu *vcpu, struct kvm_run *kvm_run)
 {
 	/*
@@ -1292,6 +1308,7 @@ static int (*svm_exit_handlers[])(struct kvm_vcpu *vcpu,
 	[SVM_EXIT_WRITE_DR5]			= emulate_on_interception,
 	[SVM_EXIT_WRITE_DR7]			= emulate_on_interception,
 	[SVM_EXIT_EXCP_BASE + PF_VECTOR] 	= pf_interception,
+	[SVM_EXIT_EXCP_BASE + NM_VECTOR] 	= nm_interception,
 	[SVM_EXIT_INTR] 			= nop_on_interception,
 	[SVM_EXIT_NMI]				= nop_on_interception,
 	[SVM_EXIT_SMI]				= nop_on_interception,
@@ -1481,8 +1498,10 @@ again:
 		load_db_regs(vcpu->svm->db_regs);
 	}
 
-	fx_save(vcpu->host_fx_image);
-	fx_restore(vcpu->guest_fx_image);
+	if (vcpu->fpu_active) {
+		fx_save(vcpu->host_fx_image);
+		fx_restore(vcpu->guest_fx_image);
+	}
 
 	asm volatile (
 #ifdef CONFIG_X86_64
@@ -1593,8 +1612,10 @@ again:
 #endif
 		: "cc", "memory" );
 
-	fx_save(vcpu->guest_fx_image);
-	fx_restore(vcpu->host_fx_image);
+	if (vcpu->fpu_active) {
+		fx_save(vcpu->guest_fx_image);
+		fx_restore(vcpu->host_fx_image);
+	}
 
 	if ((vcpu->svm->vmcb->save.dr7 & 0xff))
 		load_db_regs(vcpu->svm->host_db_regs);
@@ -1664,6 +1685,12 @@ static void svm_set_cr3(struct kvm_vcpu *vcpu, unsigned long root)
 {
 	vcpu->svm->vmcb->save.cr3 = root;
 	force_new_asid(vcpu);
+ 
+	if (vcpu->fpu_active) {
+		vcpu->svm->vmcb->control.intercept_exceptions |= (1 << NM_VECTOR);
+		vcpu->svm->vmcb->save.cr0 |= CR0_TS_MASK;
+		vcpu->fpu_active = 0;
+	}
 }
 
 static void svm_inject_page_fault(struct kvm_vcpu *vcpu,
-- 
1.5.0.6

