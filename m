Return-Path: <linux-kernel-owner+w=401wt.eu-S1755086AbZEXPyR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755086AbZEXPyR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 May 2009 11:54:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757828AbZEXPvm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 May 2009 11:51:42 -0400
Received: from mx2.redhat.com ([66.187.237.31]:41853 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754890AbZEXPuf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 May 2009 11:50:35 -0400
From: Avi Kivity <avi@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: kvm@vger.kernel.org
Subject: [PATCH 38/45] KVM: Remove irq_pending bitmap
Date: Sun, 24 May 2009 18:50:23 +0300
Message-Id: <1243180230-2480-39-git-send-email-avi@redhat.com>
In-Reply-To: <1243180230-2480-1-git-send-email-avi@redhat.com>
References: <1243180230-2480-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Gleb Natapov <gleb@redhat.com>

Only one interrupt vector can be injected from userspace irqchip at
any given time so no need to store it in a bitmap. Put it into interrupt
queue directly.

Signed-off-by: Gleb Natapov <gleb@redhat.com>
Signed-off-by: Avi Kivity <avi@redhat.com>
---
 arch/x86/include/asm/kvm_host.h |    2 --
 arch/x86/kvm/irq.c              |    4 ++--
 arch/x86/kvm/x86.c              |   38 +++++++++++---------------------------
 arch/x86/kvm/x86.h              |   12 ------------
 4 files changed, 13 insertions(+), 43 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 16d1481..977a785 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -266,8 +266,6 @@ struct kvm_mmu {
 
 struct kvm_vcpu_arch {
 	u64 host_tsc;
-	unsigned long irq_summary; /* bit vector: 1 per word in irq_pending */
-	DECLARE_BITMAP(irq_pending, KVM_NR_INTERRUPTS);
 	/*
 	 * rip and regs accesses must go through
 	 * kvm_{register,rip}_{read,write} functions.
diff --git a/arch/x86/kvm/irq.c b/arch/x86/kvm/irq.c
index 11c2757..96dfbb6 100644
--- a/arch/x86/kvm/irq.c
+++ b/arch/x86/kvm/irq.c
@@ -50,7 +50,7 @@ int kvm_cpu_has_interrupt(struct kvm_vcpu *v)
 	struct kvm_pic *s;
 
 	if (!irqchip_in_kernel(v->kvm))
-		return v->arch.irq_summary;
+		return v->arch.interrupt.pending;
 
 	if (kvm_apic_has_interrupt(v) == -1) {	/* LAPIC */
 		if (kvm_apic_accept_pic_intr(v)) {
@@ -72,7 +72,7 @@ int kvm_cpu_get_interrupt(struct kvm_vcpu *v)
 	int vector;
 
 	if (!irqchip_in_kernel(v->kvm))
-		return kvm_pop_irq(v);
+		return v->arch.interrupt.nr;
 
 	vector = kvm_get_apic_interrupt(v);	/* APIC */
 	if (vector == -1) {
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index d9396a7..c176b1f 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -1437,8 +1437,7 @@ static int kvm_vcpu_ioctl_interrupt(struct kvm_vcpu *vcpu,
 		return -ENXIO;
 	vcpu_load(vcpu);
 
-	set_bit(irq->irq, vcpu->arch.irq_pending);
-	set_bit(irq->irq / BITS_PER_LONG, &vcpu->arch.irq_summary);
+	kvm_queue_interrupt(vcpu, irq->irq);
 
 	vcpu_put(vcpu);
 
@@ -3579,12 +3578,7 @@ int kvm_arch_vcpu_ioctl_get_sregs(struct kvm_vcpu *vcpu,
 	sregs->efer = vcpu->arch.shadow_efer;
 	sregs->apic_base = kvm_get_apic_base(vcpu);
 
-	if (irqchip_in_kernel(vcpu->kvm))
-		memset(sregs->interrupt_bitmap, 0,
-		       sizeof sregs->interrupt_bitmap);
-	else
-		memcpy(sregs->interrupt_bitmap, vcpu->arch.irq_pending,
-		       sizeof sregs->interrupt_bitmap);
+	memset(sregs->interrupt_bitmap, 0, sizeof sregs->interrupt_bitmap);
 
 	if (vcpu->arch.interrupt.pending)
 		set_bit(vcpu->arch.interrupt.nr,
@@ -4054,7 +4048,7 @@ int kvm_arch_vcpu_ioctl_set_sregs(struct kvm_vcpu *vcpu,
 				  struct kvm_sregs *sregs)
 {
 	int mmu_reset_needed = 0;
-	int i, pending_vec, max_bits;
+	int pending_vec, max_bits;
 	struct descriptor_table dt;
 
 	vcpu_load(vcpu);
@@ -4096,24 +4090,14 @@ int kvm_arch_vcpu_ioctl_set_sregs(struct kvm_vcpu *vcpu,
 	if (mmu_reset_needed)
 		kvm_mmu_reset_context(vcpu);
 
-	if (!irqchip_in_kernel(vcpu->kvm)) {
-		memcpy(vcpu->arch.irq_pending, sregs->interrupt_bitmap,
-		       sizeof vcpu->arch.irq_pending);
-		vcpu->arch.irq_summary = 0;
-		for (i = 0; i < ARRAY_SIZE(vcpu->arch.irq_pending); ++i)
-			if (vcpu->arch.irq_pending[i])
-				__set_bit(i, &vcpu->arch.irq_summary);
-	} else {
-		max_bits = (sizeof sregs->interrupt_bitmap) << 3;
-		pending_vec = find_first_bit(
-			(const unsigned long *)sregs->interrupt_bitmap,
-			max_bits);
-		/* Only pending external irq is handled here */
-		if (pending_vec < max_bits) {
-			kvm_queue_interrupt(vcpu, pending_vec);
-			pr_debug("Set back pending irq %d\n", pending_vec);
-		}
-		kvm_pic_clear_isr_ack(vcpu->kvm);
+	max_bits = (sizeof sregs->interrupt_bitmap) << 3;
+	pending_vec = find_first_bit(
+		(const unsigned long *)sregs->interrupt_bitmap, max_bits);
+	if (pending_vec < max_bits) {
+		kvm_queue_interrupt(vcpu, pending_vec);
+		pr_debug("Set back pending irq %d\n", pending_vec);
+		if (irqchip_in_kernel(vcpu->kvm))
+			kvm_pic_clear_isr_ack(vcpu->kvm);
 	}
 
 	kvm_set_segment(vcpu, &sregs->cs, VCPU_SREG_CS);
diff --git a/arch/x86/kvm/x86.h b/arch/x86/kvm/x86.h
index 21203d4..c1f1a8c 100644
--- a/arch/x86/kvm/x86.h
+++ b/arch/x86/kvm/x86.h
@@ -19,18 +19,6 @@ static inline void kvm_clear_interrupt_queue(struct kvm_vcpu *vcpu)
 	vcpu->arch.interrupt.pending = false;
 }
 
-static inline u8 kvm_pop_irq(struct kvm_vcpu *vcpu)
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
 static inline bool kvm_event_needs_reinjection(struct kvm_vcpu *vcpu)
 {
 	return vcpu->arch.exception.pending || vcpu->arch.interrupt.pending ||
-- 
1.6.0.6

