Return-Path: <linux-kernel-owner+w=401wt.eu-S1758002AbZETLYe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758002AbZETLYe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 May 2009 07:24:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756240AbZETLTp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 May 2009 07:19:45 -0400
Received: from mx2.redhat.com ([66.187.237.31]:55300 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755930AbZETLSw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 May 2009 07:18:52 -0400
From: Avi Kivity <avi@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: kvm@vger.kernel.org
Subject: [PATCH 43/46] KVM: VMX: Cleanup vmx_intr_assist()
Date: Wed, 20 May 2009 14:18:40 +0300
Message-Id: <1242818323-10413-44-git-send-email-avi@redhat.com>
In-Reply-To: <1242818323-10413-1-git-send-email-avi@redhat.com>
References: <1242818323-10413-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Gleb Natapov <gleb@redhat.com>

Signed-off-by: Gleb Natapov <gleb@redhat.com>
Signed-off-by: Avi Kivity <avi@redhat.com>
---
 arch/x86/kvm/vmx.c |   55 ++++++++++++++++++++++++++++-----------------------
 1 files changed, 30 insertions(+), 25 deletions(-)

diff --git a/arch/x86/kvm/vmx.c b/arch/x86/kvm/vmx.c
index 06252f7..9eb518f 100644
--- a/arch/x86/kvm/vmx.c
+++ b/arch/x86/kvm/vmx.c
@@ -3309,6 +3309,34 @@ static void vmx_complete_interrupts(struct vcpu_vmx *vmx)
 	}
 }
 
+static void vmx_intr_inject(struct kvm_vcpu *vcpu)
+{
+	/* try to reinject previous events if any */
+	if (vcpu->arch.nmi_injected) {
+		vmx_inject_nmi(vcpu);
+		return;
+	}
+
+	if (vcpu->arch.interrupt.pending) {
+		vmx_inject_irq(vcpu, vcpu->arch.interrupt.nr);
+		return;
+	}
+
+	/* try to inject new event if pending */
+	if (vcpu->arch.nmi_pending) {
+		if (vcpu->arch.nmi_window_open) {
+			vcpu->arch.nmi_pending = false;
+			vcpu->arch.nmi_injected = true;
+			vmx_inject_nmi(vcpu);
+		}
+	} else if (kvm_cpu_has_interrupt(vcpu)) {
+		if (vcpu->arch.interrupt_window_open) {
+			kvm_queue_interrupt(vcpu, kvm_cpu_get_interrupt(vcpu));
+			vmx_inject_irq(vcpu, vcpu->arch.interrupt.nr);
+		}
+	}
+}
+
 static void vmx_intr_assist(struct kvm_vcpu *vcpu, struct kvm_run *kvm_run)
 {
 	bool req_int_win = !irqchip_in_kernel(vcpu->kvm) &&
@@ -3323,32 +3351,9 @@ static void vmx_intr_assist(struct kvm_vcpu *vcpu, struct kvm_run *kvm_run)
 				GUEST_INTR_STATE_STI |
 				GUEST_INTR_STATE_MOV_SS);
 
-	if (vcpu->arch.nmi_pending && !vcpu->arch.nmi_injected) {
-		if (vcpu->arch.interrupt.pending) {
-			enable_nmi_window(vcpu);
-		} else if (vcpu->arch.nmi_window_open) {
-			vcpu->arch.nmi_pending = false;
-			vcpu->arch.nmi_injected = true;
-		} else {
-			enable_nmi_window(vcpu);
-			return;
-		}
-	}
-
-	if (vcpu->arch.nmi_injected) {
-		vmx_inject_nmi(vcpu);
-		goto out;
-	}
-
-	if (!vcpu->arch.interrupt.pending && kvm_cpu_has_interrupt(vcpu)) {
-		if (vcpu->arch.interrupt_window_open)
-			kvm_queue_interrupt(vcpu, kvm_cpu_get_interrupt(vcpu));
-	}
-
-	if (vcpu->arch.interrupt.pending)
-		vmx_inject_irq(vcpu, vcpu->arch.interrupt.nr);
+	vmx_intr_inject(vcpu);
 
-out:
+	/* enable NMI/IRQ window open exits if needed */
 	if (vcpu->arch.nmi_pending)
 		enable_nmi_window(vcpu);
 	else if (kvm_cpu_has_interrupt(vcpu) || req_int_win)
-- 
1.6.0.6

