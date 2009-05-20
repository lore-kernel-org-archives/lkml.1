Return-Path: <linux-kernel-owner+w=401wt.eu-S1757867AbZETLXu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757867AbZETLXu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 May 2009 07:23:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756390AbZETLT0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 May 2009 07:19:26 -0400
Received: from mx2.redhat.com ([66.187.237.31]:55301 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755899AbZETLSw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 May 2009 07:18:52 -0400
From: Avi Kivity <avi@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: kvm@vger.kernel.org
Subject: [PATCH 42/46] KVM: VMX: Consolidate userspace and kernel interrupt injection for VMX
Date: Wed, 20 May 2009 14:18:39 +0300
Message-Id: <1242818323-10413-43-git-send-email-avi@redhat.com>
In-Reply-To: <1242818323-10413-1-git-send-email-avi@redhat.com>
References: <1242818323-10413-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Gleb Natapov <gleb@redhat.com>

Use the same callback to inject irq/nmi events no matter what irqchip is
in use. Only from VMX for now.

Signed-off-by: Gleb Natapov <gleb@redhat.com>
Signed-off-by: Avi Kivity <avi@redhat.com>
---
 arch/x86/include/asm/kvm_host.h |    2 +-
 arch/x86/kvm/svm.c              |    2 +-
 arch/x86/kvm/vmx.c              |   71 +++++++++------------------------------
 arch/x86/kvm/x86.c              |    2 +-
 4 files changed, 19 insertions(+), 58 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index cb306cf..5edae35 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -517,7 +517,7 @@ struct kvm_x86_ops {
 	void (*queue_exception)(struct kvm_vcpu *vcpu, unsigned nr,
 				bool has_error_code, u32 error_code);
 	bool (*exception_injected)(struct kvm_vcpu *vcpu);
-	void (*inject_pending_irq)(struct kvm_vcpu *vcpu);
+	void (*inject_pending_irq)(struct kvm_vcpu *vcpu, struct kvm_run *run);
 	void (*inject_pending_vectors)(struct kvm_vcpu *vcpu,
 				       struct kvm_run *run);
 	int (*interrupt_allowed)(struct kvm_vcpu *vcpu);
diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index 6eef6d2..f2933ab 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -2298,7 +2298,7 @@ static int svm_interrupt_allowed(struct kvm_vcpu *vcpu)
 		(svm->vcpu.arch.hflags & HF_GIF_MASK);
 }
 
-static void svm_intr_assist(struct kvm_vcpu *vcpu)
+static void svm_intr_assist(struct kvm_vcpu *vcpu, struct kvm_run *kvm_run)
 {
 	struct vcpu_svm *svm = to_svm(vcpu);
 	struct vmcb *vmcb = svm->vmcb;
diff --git a/arch/x86/kvm/vmx.c b/arch/x86/kvm/vmx.c
index b3292c1..06252f7 100644
--- a/arch/x86/kvm/vmx.c
+++ b/arch/x86/kvm/vmx.c
@@ -2510,48 +2510,6 @@ static int vmx_interrupt_allowed(struct kvm_vcpu *vcpu)
 	return vcpu->arch.interrupt_window_open;
 }
 
-static void do_interrupt_requests(struct kvm_vcpu *vcpu,
-				       struct kvm_run *kvm_run)
-{
-	vmx_update_window_states(vcpu);
-
-	if (vcpu->guest_debug & KVM_GUESTDBG_SINGLESTEP)
-		vmcs_clear_bits(GUEST_INTERRUPTIBILITY_INFO,
-				GUEST_INTR_STATE_STI |
-				GUEST_INTR_STATE_MOV_SS);
-
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
-	if (vcpu->arch.nmi_injected) {
-		vmx_inject_nmi(vcpu);
-		if (vcpu->arch.nmi_pending)
-			enable_nmi_window(vcpu);
-		else if (kvm_cpu_has_interrupt(vcpu) ||
-			 kvm_run->request_interrupt_window)
-			enable_irq_window(vcpu);
-		return;
-	}
-
-	if (vcpu->arch.interrupt_window_open) {
-		if (kvm_cpu_has_interrupt(vcpu) && !vcpu->arch.interrupt.pending)
-			kvm_queue_interrupt(vcpu, kvm_cpu_get_interrupt(vcpu));
-
-		if (vcpu->arch.interrupt.pending)
-			vmx_inject_irq(vcpu, vcpu->arch.interrupt.nr);
-	} else if(kvm_cpu_has_interrupt(vcpu) ||
-		  kvm_run->request_interrupt_window)
-		enable_irq_window(vcpu);
-}
-
 static int vmx_set_tss_addr(struct kvm *kvm, unsigned int addr)
 {
 	int ret;
@@ -3351,8 +3309,11 @@ static void vmx_complete_interrupts(struct vcpu_vmx *vmx)
 	}
 }
 
-static void vmx_intr_assist(struct kvm_vcpu *vcpu)
+static void vmx_intr_assist(struct kvm_vcpu *vcpu, struct kvm_run *kvm_run)
 {
+	bool req_int_win = !irqchip_in_kernel(vcpu->kvm) &&
+		kvm_run->request_interrupt_window;
+
 	update_tpr_threshold(vcpu);
 
 	vmx_update_window_states(vcpu);
@@ -3373,25 +3334,25 @@ static void vmx_intr_assist(struct kvm_vcpu *vcpu)
 			return;
 		}
 	}
+
 	if (vcpu->arch.nmi_injected) {
 		vmx_inject_nmi(vcpu);
-		if (vcpu->arch.nmi_pending)
-			enable_nmi_window(vcpu);
-		else if (kvm_cpu_has_interrupt(vcpu))
-			enable_irq_window(vcpu);
-		return;
+		goto out;
 	}
+
 	if (!vcpu->arch.interrupt.pending && kvm_cpu_has_interrupt(vcpu)) {
 		if (vcpu->arch.interrupt_window_open)
 			kvm_queue_interrupt(vcpu, kvm_cpu_get_interrupt(vcpu));
-		else
-			enable_irq_window(vcpu);
 	}
-	if (vcpu->arch.interrupt.pending) {
+
+	if (vcpu->arch.interrupt.pending)
 		vmx_inject_irq(vcpu, vcpu->arch.interrupt.nr);
-		if (kvm_cpu_has_interrupt(vcpu))
-			enable_irq_window(vcpu);
-	}
+
+out:
+	if (vcpu->arch.nmi_pending)
+		enable_nmi_window(vcpu);
+	else if (kvm_cpu_has_interrupt(vcpu) || req_int_win)
+		enable_irq_window(vcpu);
 }
 
 /*
@@ -3733,7 +3694,7 @@ static struct kvm_x86_ops vmx_x86_ops = {
 	.queue_exception = vmx_queue_exception,
 	.exception_injected = vmx_exception_injected,
 	.inject_pending_irq = vmx_intr_assist,
-	.inject_pending_vectors = do_interrupt_requests,
+	.inject_pending_vectors = vmx_intr_assist,
 	.interrupt_allowed = vmx_interrupt_allowed,
 	.set_tss_addr = vmx_set_tss_addr,
 	.get_tdp_level = get_ept_level,
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 0c9c13c..7a572ec 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -3169,7 +3169,7 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu, struct kvm_run *kvm_run)
 	if (vcpu->arch.exception.pending)
 		__queue_exception(vcpu);
 	else if (irqchip_in_kernel(vcpu->kvm))
-		kvm_x86_ops->inject_pending_irq(vcpu);
+		kvm_x86_ops->inject_pending_irq(vcpu, kvm_run);
 	else
 		kvm_x86_ops->inject_pending_vectors(vcpu, kvm_run);
 
-- 
1.6.0.6

