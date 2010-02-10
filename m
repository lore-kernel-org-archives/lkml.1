Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756062Ab0BJRZ5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Feb 2010 12:25:57 -0500
Received: from mx1.redhat.com ([209.132.183.28]:14844 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755753Ab0BJRXO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Feb 2010 12:23:14 -0500
From: Avi Kivity <avi@redhat.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 22/40] KVM: powerpc: Improve DEC handling
Date: Wed, 10 Feb 2010 19:22:51 +0200
Message-Id: <1265822589-11155-23-git-send-email-avi@redhat.com>
In-Reply-To: <1265822589-11155-1-git-send-email-avi@redhat.com>
References: <1265822589-11155-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alexander Graf <agraf@suse.de>

We treated the DEC interrupt like an edge based one. This is not true for
Book3s. The DEC keeps firing until mtdec is issued again and thus clears
the interrupt line.

So let's implement this logic in KVM too. This patch moves the line clearing
from the firing of the interrupt to the mtdec emulation.

This makes PPC64 guests work without AGGRESSIVE_DEC defined.

Signed-off-by: Alexander Graf <agraf@suse.de>
Acked-by: Acked-by: Hollis Blanchard <hollis@penguinppc.org>
Signed-off-by: Avi Kivity <avi@redhat.com>
---
 arch/powerpc/include/asm/kvm_ppc.h |    1 +
 arch/powerpc/kvm/book3s.c          |   16 +++++++++++++++-
 arch/powerpc/kvm/booke.c           |    5 +++++
 arch/powerpc/kvm/emulate.c         |    3 +++
 4 files changed, 24 insertions(+), 1 deletions(-)

diff --git a/arch/powerpc/include/asm/kvm_ppc.h b/arch/powerpc/include/asm/kvm_ppc.h
index 269ee46..abfd0c4 100644
--- a/arch/powerpc/include/asm/kvm_ppc.h
+++ b/arch/powerpc/include/asm/kvm_ppc.h
@@ -82,6 +82,7 @@ extern void kvmppc_core_deliver_interrupts(struct kvm_vcpu *vcpu);
 extern int kvmppc_core_pending_dec(struct kvm_vcpu *vcpu);
 extern void kvmppc_core_queue_program(struct kvm_vcpu *vcpu);
 extern void kvmppc_core_queue_dec(struct kvm_vcpu *vcpu);
+extern void kvmppc_core_dequeue_dec(struct kvm_vcpu *vcpu);
 extern void kvmppc_core_queue_external(struct kvm_vcpu *vcpu,
                                        struct kvm_interrupt *irq);
 
diff --git a/arch/powerpc/kvm/book3s.c b/arch/powerpc/kvm/book3s.c
index 241795b..fd3ad6c 100644
--- a/arch/powerpc/kvm/book3s.c
+++ b/arch/powerpc/kvm/book3s.c
@@ -151,6 +151,13 @@ static int kvmppc_book3s_vec2irqprio(unsigned int vec)
 	return prio;
 }
 
+static void kvmppc_book3s_dequeue_irqprio(struct kvm_vcpu *vcpu,
+					  unsigned int vec)
+{
+	clear_bit(kvmppc_book3s_vec2irqprio(vec),
+		  &vcpu->arch.pending_exceptions);
+}
+
 void kvmppc_book3s_queue_irqprio(struct kvm_vcpu *vcpu, unsigned int vec)
 {
 	vcpu->stat.queue_intr++;
@@ -178,6 +185,11 @@ int kvmppc_core_pending_dec(struct kvm_vcpu *vcpu)
 	return test_bit(BOOK3S_INTERRUPT_DECREMENTER >> 7, &vcpu->arch.pending_exceptions);
 }
 
+void kvmppc_core_dequeue_dec(struct kvm_vcpu *vcpu)
+{
+	kvmppc_book3s_dequeue_irqprio(vcpu, BOOK3S_INTERRUPT_DECREMENTER);
+}
+
 void kvmppc_core_queue_external(struct kvm_vcpu *vcpu,
                                 struct kvm_interrupt *irq)
 {
@@ -275,7 +287,9 @@ void kvmppc_core_deliver_interrupts(struct kvm_vcpu *vcpu)
 #endif
 	priority = __ffs(*pending);
 	while (priority <= (sizeof(unsigned int) * 8)) {
-		if (kvmppc_book3s_irqprio_deliver(vcpu, priority)) {
+		if (kvmppc_book3s_irqprio_deliver(vcpu, priority) &&
+		    (priority != BOOK3S_IRQPRIO_DECREMENTER)) {
+			/* DEC interrupts get cleared by mtdec */
 			clear_bit(priority, &vcpu->arch.pending_exceptions);
 			break;
 		}
diff --git a/arch/powerpc/kvm/booke.c b/arch/powerpc/kvm/booke.c
index 06f5a9e..d8b6342 100644
--- a/arch/powerpc/kvm/booke.c
+++ b/arch/powerpc/kvm/booke.c
@@ -97,6 +97,11 @@ int kvmppc_core_pending_dec(struct kvm_vcpu *vcpu)
 	return test_bit(BOOKE_IRQPRIO_DECREMENTER, &vcpu->arch.pending_exceptions);
 }
 
+void kvmppc_core_dequeue_dec(struct kvm_vcpu *vcpu)
+{
+	clear_bit(BOOKE_IRQPRIO_DECREMENTER, &vcpu->arch.pending_exceptions);
+}
+
 void kvmppc_core_queue_external(struct kvm_vcpu *vcpu,
                                 struct kvm_interrupt *irq)
 {
diff --git a/arch/powerpc/kvm/emulate.c b/arch/powerpc/kvm/emulate.c
index 4a9ac66..303457b 100644
--- a/arch/powerpc/kvm/emulate.c
+++ b/arch/powerpc/kvm/emulate.c
@@ -83,6 +83,9 @@ void kvmppc_emulate_dec(struct kvm_vcpu *vcpu)
 
 	pr_debug("mtDEC: %x\n", vcpu->arch.dec);
 #ifdef CONFIG_PPC64
+	/* mtdec lowers the interrupt line when positive. */
+	kvmppc_core_dequeue_dec(vcpu);
+
 	/* POWER4+ triggers a dec interrupt if the value is < 0 */
 	if (vcpu->arch.dec & 0x80000000) {
 		hrtimer_try_to_cancel(&vcpu->arch.dec_timer);
-- 
1.6.5.3

