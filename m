Return-Path: <linux-kernel-owner+w=401wt.eu-S1758871AbZERJqT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758871AbZERJqT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 May 2009 05:46:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756862AbZERJZq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 May 2009 05:25:46 -0400
Received: from mx2.redhat.com ([66.187.237.31]:38426 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754351AbZERJXL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 May 2009 05:23:11 -0400
From: Avi Kivity <avi@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: kvm@vger.kernel.org
Subject: [PATCH 34/43] KVM: reuse (pop|push)_irq from svm.c in vmx.c
Date: Mon, 18 May 2009 12:22:56 +0300
Message-Id: <1242638585-18470-35-git-send-email-avi@redhat.com>
In-Reply-To: <1242638585-18470-1-git-send-email-avi@redhat.com>
References: <1242638585-18470-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Gleb Natapov <gleb@redhat.com>

The prioritized bit vector manipulation functions are useful in both vmx and
svm.

Signed-off-by: Gleb Natapov <gleb@redhat.com>
Signed-off-by: Avi Kivity <avi@redhat.com>
---
 arch/x86/kvm/svm.c |   25 ++++---------------------
 arch/x86/kvm/vmx.c |   17 ++---------------
 arch/x86/kvm/x86.h |   18 ++++++++++++++++++
 3 files changed, 24 insertions(+), 36 deletions(-)

diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index 5b35ebd..aa528db 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -19,6 +19,7 @@
 #include "irq.h"
 #include "mmu.h"
 #include "kvm_cache_regs.h"
+#include "x86.h"
 
 #include <linux/module.h>
 #include <linux/kernel.h>
@@ -132,24 +133,6 @@ static inline u32 svm_has(u32 feat)
 	return svm_features & feat;
 }
 
-static inline u8 pop_irq(struct kvm_vcpu *vcpu)
-{
-	int word_index = __ffs(vcpu->arch.irq_summary);
-	int bit_index = __ffs(vcpu->arch.irq_pending[word_index]);
-	int irq = word_index * BITS_PER_LONG + bit_index;
-
-	clear_bit(bit_index, &vcpu->arch.irq_pending[word_index]);
-	if (!vcpu->arch.irq_pending[word_index])
-		clear_bit(word_index, &vcpu->arch.irq_summary);
-	return irq;
-}
-
-static inline void push_irq(struct kvm_vcpu *vcpu, u8 irq)
-{
-	set_bit(irq, vcpu->arch.irq_pending);
-	set_bit(irq / BITS_PER_LONG, &vcpu->arch.irq_summary);
-}
-
 static inline void clgi(void)
 {
 	asm volatile (__ex(SVM_CLGI));
@@ -1116,7 +1099,7 @@ static int pf_interception(struct vcpu_svm *svm, struct kvm_run *kvm_run)
 	if (!irqchip_in_kernel(kvm) &&
 	    is_external_interrupt(exit_int_info)) {
 		event_injection = true;
-		push_irq(&svm->vcpu, exit_int_info & SVM_EVTINJ_VEC_MASK);
+		kvm_push_irq(&svm->vcpu, exit_int_info & SVM_EVTINJ_VEC_MASK);
 	}
 
 	fault_address  = svm->vmcb->control.exit_info_2;
@@ -2336,7 +2319,7 @@ static void kvm_reput_irq(struct vcpu_svm *svm)
 	if ((control->int_ctl & V_IRQ_MASK)
 	    && !irqchip_in_kernel(svm->vcpu.kvm)) {
 		control->int_ctl &= ~V_IRQ_MASK;
-		push_irq(&svm->vcpu, control->int_vector);
+		kvm_push_irq(&svm->vcpu, control->int_vector);
 	}
 
 	svm->vcpu.arch.interrupt_window_open =
@@ -2346,7 +2329,7 @@ static void kvm_reput_irq(struct vcpu_svm *svm)
 
 static void svm_do_inject_vector(struct vcpu_svm *svm)
 {
-	svm_inject_irq(svm, pop_irq(&svm->vcpu));
+	svm_inject_irq(svm, kvm_pop_irq(&svm->vcpu));
 }
 
 static void do_interrupt_requests(struct kvm_vcpu *vcpu,
diff --git a/arch/x86/kvm/vmx.c b/arch/x86/kvm/vmx.c
index b5eae7a..2c0a2ed 100644
--- a/arch/x86/kvm/vmx.c
+++ b/arch/x86/kvm/vmx.c
@@ -2489,18 +2489,6 @@ static void vmx_update_window_states(struct kvm_vcpu *vcpu)
 				 GUEST_INTR_STATE_MOV_SS)));
 }
 
-static void kvm_do_inject_irq(struct kvm_vcpu *vcpu)
-{
-	int word_index = __ffs(vcpu->arch.irq_summary);
-	int bit_index = __ffs(vcpu->arch.irq_pending[word_index]);
-	int irq = word_index * BITS_PER_LONG + bit_index;
-
-	clear_bit(bit_index, &vcpu->arch.irq_pending[word_index]);
-	if (!vcpu->arch.irq_pending[word_index])
-		clear_bit(word_index, &vcpu->arch.irq_summary);
-	kvm_queue_interrupt(vcpu, irq);
-}
-
 static void do_interrupt_requests(struct kvm_vcpu *vcpu,
 				       struct kvm_run *kvm_run)
 {
@@ -2534,7 +2522,7 @@ static void do_interrupt_requests(struct kvm_vcpu *vcpu,
 
 	if (vcpu->arch.interrupt_window_open) {
 		if (vcpu->arch.irq_summary && !vcpu->arch.interrupt.pending)
-			kvm_do_inject_irq(vcpu);
+			kvm_queue_interrupt(vcpu, kvm_pop_irq(vcpu));
 
 		if (vcpu->arch.interrupt.pending)
 			vmx_inject_irq(vcpu, vcpu->arch.interrupt.nr);
@@ -2619,8 +2607,7 @@ static int handle_exception(struct kvm_vcpu *vcpu, struct kvm_run *kvm_run)
 
 	if (!irqchip_in_kernel(vcpu->kvm) && is_external_interrupt(vect_info)) {
 		int irq = vect_info & VECTORING_INFO_VECTOR_MASK;
-		set_bit(irq, vcpu->arch.irq_pending);
-		set_bit(irq / BITS_PER_LONG, &vcpu->arch.irq_summary);
+		kvm_push_irq(vcpu, irq);
 	}
 
 	if ((intr_info & INTR_INFO_INTR_TYPE_MASK) == INTR_TYPE_NMI_INTR)
diff --git a/arch/x86/kvm/x86.h b/arch/x86/kvm/x86.h
index 6a4be78..2ab6791 100644
--- a/arch/x86/kvm/x86.h
+++ b/arch/x86/kvm/x86.h
@@ -19,4 +19,22 @@ static inline void kvm_clear_interrupt_queue(struct kvm_vcpu *vcpu)
 	vcpu->arch.interrupt.pending = false;
 }
 
+static inline u8 kvm_pop_irq(struct kvm_vcpu *vcpu)
+{
+	int word_index = __ffs(vcpu->arch.irq_summary);
+	int bit_index = __ffs(vcpu->arch.irq_pending[word_index]);
+	int irq = word_index * BITS_PER_LONG + bit_index;
+
+	clear_bit(bit_index, &vcpu->arch.irq_pending[word_index]);
+	if (!vcpu->arch.irq_pending[word_index])
+		clear_bit(word_index, &vcpu->arch.irq_summary);
+	return irq;
+}
+
+static inline void kvm_push_irq(struct kvm_vcpu *vcpu, u8 irq)
+{
+        set_bit(irq, vcpu->arch.irq_pending);
+        set_bit(irq / BITS_PER_LONG, &vcpu->arch.irq_summary);
+}
+
 #endif
-- 
1.6.0.6

