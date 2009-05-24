Return-Path: <linux-kernel-owner+w=401wt.eu-S1758648AbZEXPxW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758648AbZEXPxW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 May 2009 11:53:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755280AbZEXPvd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 May 2009 11:51:33 -0400
Received: from mx2.redhat.com ([66.187.237.31]:41859 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755123AbZEXPuf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 May 2009 11:50:35 -0400
From: Avi Kivity <avi@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: kvm@vger.kernel.org
Subject: [PATCH 40/45] KVM: Do not re-execute INTn instruction.
Date: Sun, 24 May 2009 18:50:25 +0300
Message-Id: <1243180230-2480-41-git-send-email-avi@redhat.com>
In-Reply-To: <1243180230-2480-1-git-send-email-avi@redhat.com>
References: <1243180230-2480-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Gleb Natapov <gleb@redhat.com>

Re-inject event instead. This is what Intel suggest. Also use correct
instruction length when re-injecting soft fault/interrupt.

Signed-off-by: Gleb Natapov <gleb@redhat.com>
Signed-off-by: Avi Kivity <avi@redhat.com>
---
 arch/x86/include/asm/kvm_host.h |    5 ++++-
 arch/x86/kvm/svm.c              |    8 ++++----
 arch/x86/kvm/vmx.c              |   32 +++++++++++++++++++++++++-------
 arch/x86/kvm/x86.c              |   11 ++++++-----
 arch/x86/kvm/x86.h              |    9 ++++++++-
 5 files changed, 47 insertions(+), 18 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 977a785..1d6c3f7 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -319,6 +319,8 @@ struct kvm_vcpu_arch {
 	struct kvm_pio_request pio;
 	void *pio_data;
 
+	u8 event_exit_inst_len;
+
 	struct kvm_queued_exception {
 		bool pending;
 		bool has_error_code;
@@ -328,6 +330,7 @@ struct kvm_vcpu_arch {
 
 	struct kvm_queued_interrupt {
 		bool pending;
+		bool soft;
 		u8 nr;
 	} interrupt;
 
@@ -510,7 +513,7 @@ struct kvm_x86_ops {
 	u32 (*get_interrupt_shadow)(struct kvm_vcpu *vcpu, int mask);
 	void (*patch_hypercall)(struct kvm_vcpu *vcpu,
 				unsigned char *hypercall_addr);
-	void (*set_irq)(struct kvm_vcpu *vcpu, int vec);
+	void (*set_irq)(struct kvm_vcpu *vcpu);
 	void (*set_nmi)(struct kvm_vcpu *vcpu);
 	void (*queue_exception)(struct kvm_vcpu *vcpu, unsigned nr,
 				bool has_error_code, u32 error_code);
diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index 1315ce0..377c4f1 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -2310,13 +2310,13 @@ static void svm_queue_irq(struct kvm_vcpu *vcpu, unsigned nr)
 		SVM_EVTINJ_VALID | SVM_EVTINJ_TYPE_INTR;
 }
 
-static void svm_set_irq(struct kvm_vcpu *vcpu, int irq)
+static void svm_set_irq(struct kvm_vcpu *vcpu)
 {
 	struct vcpu_svm *svm = to_svm(vcpu);
 
 	nested_svm_intr(svm);
 
-	svm_queue_irq(vcpu, irq);
+	svm_queue_irq(vcpu, vcpu->arch.interrupt.nr);
 }
 
 static void update_cr8_intercept(struct kvm_vcpu *vcpu, int tpr, int irr)
@@ -2418,7 +2418,7 @@ static void svm_complete_interrupts(struct vcpu_svm *svm)
 	case SVM_EXITINTINFO_TYPE_EXEPT:
 		/* In case of software exception do not reinject an exception
 		   vector, but re-execute and instruction instead */
-		if (vector == BP_VECTOR || vector == OF_VECTOR)
+		if (kvm_exception_is_soft(vector))
 			break;
 		if (exitintinfo & SVM_EXITINTINFO_VALID_ERR) {
 			u32 err = svm->vmcb->control.exit_int_info_err;
@@ -2428,7 +2428,7 @@ static void svm_complete_interrupts(struct vcpu_svm *svm)
 			kvm_queue_exception(&svm->vcpu, vector);
 		break;
 	case SVM_EXITINTINFO_TYPE_INTR:
-		kvm_queue_interrupt(&svm->vcpu, vector);
+		kvm_queue_interrupt(&svm->vcpu, vector, false);
 		break;
 	default:
 		break;
diff --git a/arch/x86/kvm/vmx.c b/arch/x86/kvm/vmx.c
index 8981654..29b49f0 100644
--- a/arch/x86/kvm/vmx.c
+++ b/arch/x86/kvm/vmx.c
@@ -801,8 +801,9 @@ static void vmx_queue_exception(struct kvm_vcpu *vcpu, unsigned nr,
 		return;
 	}
 
-	if (nr == BP_VECTOR || nr == OF_VECTOR) {
-		vmcs_write32(VM_ENTRY_INSTRUCTION_LEN, 1);
+	if (kvm_exception_is_soft(nr)) {
+		vmcs_write32(VM_ENTRY_INSTRUCTION_LEN,
+			     vmx->vcpu.arch.event_exit_inst_len);
 		intr_info |= INTR_TYPE_SOFT_EXCEPTION;
 	} else
 		intr_info |= INTR_TYPE_HARD_EXCEPTION;
@@ -2445,9 +2446,11 @@ static void enable_nmi_window(struct kvm_vcpu *vcpu)
 	vmcs_write32(CPU_BASED_VM_EXEC_CONTROL, cpu_based_vm_exec_control);
 }
 
-static void vmx_inject_irq(struct kvm_vcpu *vcpu, int irq)
+static void vmx_inject_irq(struct kvm_vcpu *vcpu)
 {
 	struct vcpu_vmx *vmx = to_vmx(vcpu);
+	uint32_t intr;
+	int irq = vcpu->arch.interrupt.nr;
 
 	KVMTRACE_1D(INJ_VIRQ, vcpu, (u32)irq, handler);
 
@@ -2462,8 +2465,14 @@ static void vmx_inject_irq(struct kvm_vcpu *vcpu, int irq)
 		kvm_rip_write(vcpu, vmx->rmode.irq.rip - 1);
 		return;
 	}
-	vmcs_write32(VM_ENTRY_INTR_INFO_FIELD,
-			irq | INTR_TYPE_EXT_INTR | INTR_INFO_VALID_MASK);
+	intr = irq | INTR_INFO_VALID_MASK;
+	if (vcpu->arch.interrupt.soft) {
+		intr |= INTR_TYPE_SOFT_INTR;
+		vmcs_write32(VM_ENTRY_INSTRUCTION_LEN,
+			     vmx->vcpu.arch.event_exit_inst_len);
+	} else
+		intr |= INTR_TYPE_EXT_INTR;
+	vmcs_write32(VM_ENTRY_INTR_INFO_FIELD, intr);
 }
 
 static void vmx_inject_nmi(struct kvm_vcpu *vcpu)
@@ -3024,6 +3033,7 @@ static int handle_task_switch(struct kvm_vcpu *vcpu, struct kvm_run *kvm_run)
 					      GUEST_INTR_STATE_NMI);
 			break;
 		case INTR_TYPE_EXT_INTR:
+		case INTR_TYPE_SOFT_INTR:
 			kvm_clear_interrupt_queue(vcpu);
 			break;
 		case INTR_TYPE_HARD_EXCEPTION:
@@ -3295,16 +3305,24 @@ static void vmx_complete_interrupts(struct vcpu_vmx *vmx)
 		vmcs_clear_bits(GUEST_INTERRUPTIBILITY_INFO,
 				GUEST_INTR_STATE_NMI);
 		break;
-	case INTR_TYPE_HARD_EXCEPTION:
 	case INTR_TYPE_SOFT_EXCEPTION:
+		vmx->vcpu.arch.event_exit_inst_len =
+			vmcs_read32(VM_EXIT_INSTRUCTION_LEN);
+		/* fall through */
+	case INTR_TYPE_HARD_EXCEPTION:
 		if (idt_vectoring_info & VECTORING_INFO_DELIVER_CODE_MASK) {
 			u32 err = vmcs_read32(IDT_VECTORING_ERROR_CODE);
 			kvm_queue_exception_e(&vmx->vcpu, vector, err);
 		} else
 			kvm_queue_exception(&vmx->vcpu, vector);
 		break;
+	case INTR_TYPE_SOFT_INTR:
+		vmx->vcpu.arch.event_exit_inst_len =
+			vmcs_read32(VM_EXIT_INSTRUCTION_LEN);
+		/* fall through */
 	case INTR_TYPE_EXT_INTR:
-		kvm_queue_interrupt(&vmx->vcpu, vector);
+		kvm_queue_interrupt(&vmx->vcpu, vector,
+			type == INTR_TYPE_SOFT_INTR);
 		break;
 	default:
 		break;
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index c176b1f..e395ca4 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -1437,7 +1437,7 @@ static int kvm_vcpu_ioctl_interrupt(struct kvm_vcpu *vcpu,
 		return -ENXIO;
 	vcpu_load(vcpu);
 
-	kvm_queue_interrupt(vcpu, irq->irq);
+	kvm_queue_interrupt(vcpu, irq->irq, false);
 
 	vcpu_put(vcpu);
 
@@ -3157,7 +3157,7 @@ static void inject_irq(struct kvm_vcpu *vcpu)
 	}
 
 	if (vcpu->arch.interrupt.pending) {
-		kvm_x86_ops->set_irq(vcpu, vcpu->arch.interrupt.nr);
+		kvm_x86_ops->set_irq(vcpu);
 		return;
 	}
 
@@ -3170,8 +3170,9 @@ static void inject_irq(struct kvm_vcpu *vcpu)
 		}
 	} else if (kvm_cpu_has_interrupt(vcpu)) {
 		if (kvm_x86_ops->interrupt_allowed(vcpu)) {
-			kvm_queue_interrupt(vcpu, kvm_cpu_get_interrupt(vcpu));
-			kvm_x86_ops->set_irq(vcpu, vcpu->arch.interrupt.nr);
+			kvm_queue_interrupt(vcpu, kvm_cpu_get_interrupt(vcpu),
+					    false);
+			kvm_x86_ops->set_irq(vcpu);
 		}
 	}
 }
@@ -4094,7 +4095,7 @@ int kvm_arch_vcpu_ioctl_set_sregs(struct kvm_vcpu *vcpu,
 	pending_vec = find_first_bit(
 		(const unsigned long *)sregs->interrupt_bitmap, max_bits);
 	if (pending_vec < max_bits) {
-		kvm_queue_interrupt(vcpu, pending_vec);
+		kvm_queue_interrupt(vcpu, pending_vec, false);
 		pr_debug("Set back pending irq %d\n", pending_vec);
 		if (irqchip_in_kernel(vcpu->kvm))
 			kvm_pic_clear_isr_ack(vcpu->kvm);
diff --git a/arch/x86/kvm/x86.h b/arch/x86/kvm/x86.h
index c1f1a8c..4c8e10a 100644
--- a/arch/x86/kvm/x86.h
+++ b/arch/x86/kvm/x86.h
@@ -8,9 +8,11 @@ static inline void kvm_clear_exception_queue(struct kvm_vcpu *vcpu)
 	vcpu->arch.exception.pending = false;
 }
 
-static inline void kvm_queue_interrupt(struct kvm_vcpu *vcpu, u8 vector)
+static inline void kvm_queue_interrupt(struct kvm_vcpu *vcpu, u8 vector,
+	bool soft)
 {
 	vcpu->arch.interrupt.pending = true;
+	vcpu->arch.interrupt.soft = soft;
 	vcpu->arch.interrupt.nr = vector;
 }
 
@@ -24,4 +26,9 @@ static inline bool kvm_event_needs_reinjection(struct kvm_vcpu *vcpu)
 	return vcpu->arch.exception.pending || vcpu->arch.interrupt.pending ||
 		vcpu->arch.nmi_injected;
 }
+
+static inline bool kvm_exception_is_soft(unsigned int nr)
+{
+	return (nr == BP_VECTOR) || (nr == OF_VECTOR);
+}
 #endif
-- 
1.6.0.6

