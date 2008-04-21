Return-Path: <linux-kernel-owner+w=401wt.eu-S1761768AbYDUKjz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761768AbYDUKjz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2008 06:39:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754914AbYDUKam
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Apr 2008 06:30:42 -0400
Received: from bzq-179-150-194.static.bezeqint.net ([212.179.150.194]:37896
	"EHLO il.qumranet.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756087AbYDUKaK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2008 06:30:10 -0400
From: Avi Kivity <avi@qumranet.com>
To: kvm-devel@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org, Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 27/31] KVM: SVM: disable CR8 intercept when tpr is not masking interrupts
Date: Mon, 21 Apr 2008 13:29:53 +0300
Message-Id: <1208773797-7829-28-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.5
In-Reply-To: <1208773797-7829-1-git-send-email-avi@qumranet.com>
References: <1208773797-7829-1-git-send-email-avi@qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Joerg Roedel <joerg.roedel@amd.com>

This patch disables the intercept of CR8 writes if the TPR is not masking
interrupts. This reduces the total number CR8 intercepts to below 1 percent of
what we have without this patch using Windows 64 bit guests.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 arch/x86/kvm/svm.c |   31 +++++++++++++++++++++++++++----
 1 files changed, 27 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index ee2ee83..61bb2cb 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -1502,6 +1502,27 @@ static void svm_set_irq(struct kvm_vcpu *vcpu, int irq)
 	svm_inject_irq(svm, irq);
 }
 
+static void update_cr8_intercept(struct kvm_vcpu *vcpu)
+{
+	struct vcpu_svm *svm = to_svm(vcpu);
+	struct vmcb *vmcb = svm->vmcb;
+	int max_irr, tpr;
+
+	if (!irqchip_in_kernel(vcpu->kvm) || vcpu->arch.apic->vapic_addr)
+		return;
+
+	vmcb->control.intercept_cr_write &= ~INTERCEPT_CR8_MASK;
+
+	max_irr = kvm_lapic_find_highest_irr(vcpu);
+	if (max_irr == -1)
+		return;
+
+	tpr = kvm_lapic_get_cr8(vcpu) << 4;
+
+	if (tpr >= (max_irr & 0xf0))
+		vmcb->control.intercept_cr_write |= INTERCEPT_CR8_MASK;
+}
+
 static void svm_intr_assist(struct kvm_vcpu *vcpu)
 {
 	struct vcpu_svm *svm = to_svm(vcpu);
@@ -1514,14 +1535,14 @@ static void svm_intr_assist(struct kvm_vcpu *vcpu)
 			      SVM_EVTINJ_VEC_MASK;
 		vmcb->control.exit_int_info = 0;
 		svm_inject_irq(svm, intr_vector);
-		return;
+		goto out;
 	}
 
 	if (vmcb->control.int_ctl & V_IRQ_MASK)
-		return;
+		goto out;
 
 	if (!kvm_cpu_has_interrupt(vcpu))
-		return;
+		goto out;
 
 	if (!(vmcb->save.rflags & X86_EFLAGS_IF) ||
 	    (vmcb->control.int_state & SVM_INTERRUPT_SHADOW_MASK) ||
@@ -1529,12 +1550,14 @@ static void svm_intr_assist(struct kvm_vcpu *vcpu)
 		/* unable to deliver irq, set pending irq */
 		vmcb->control.intercept |= (1ULL << INTERCEPT_VINTR);
 		svm_inject_irq(svm, 0x0);
-		return;
+		goto out;
 	}
 	/* Okay, we can deliver the interrupt: grab it and update PIC state. */
 	intr_vector = kvm_cpu_get_interrupt(vcpu);
 	svm_inject_irq(svm, intr_vector);
 	kvm_timer_intr_post(vcpu, intr_vector);
+out:
+	update_cr8_intercept(vcpu);
 }
 
 static void kvm_reput_irq(struct vcpu_svm *svm)
-- 
1.5.5

