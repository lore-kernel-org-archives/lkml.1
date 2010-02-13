Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757619Ab0BMIKu (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Feb 2010 03:10:50 -0500
Received: from mx1.redhat.com ([209.132.183.28]:64714 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752299Ab0BMICD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Feb 2010 03:02:03 -0500
From: Avi Kivity <avi@redhat.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 12/39] KVM: PPC: Emulate trap SRR1 flags properly
Date: Sat, 13 Feb 2010 10:01:32 +0200
Message-Id: <1266048119-14325-13-git-send-email-avi@redhat.com>
In-Reply-To: <1266048119-14325-1-git-send-email-avi@redhat.com>
References: <1266048119-14325-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alexander Graf <agraf@suse.de>

Book3S needs some flags in SRR1 to get to know details about an interrupt.

One such example is the trap instruction. It tells the guest kernel that
a program interrupt is due to a trap using a bit in SRR1.

This patch implements above behavior, making WARN_ON behave like WARN_ON.

Signed-off-by: Alexander Graf <agraf@suse.de>
Signed-off-by: Avi Kivity <avi@redhat.com>
---
 arch/powerpc/include/asm/kvm_book3s.h |    1 +
 arch/powerpc/include/asm/kvm_ppc.h    |    2 +-
 arch/powerpc/include/asm/reg.h        |    4 ++++
 arch/powerpc/kvm/book3s.c             |    7 +++++--
 arch/powerpc/kvm/booke.c              |    3 ++-
 arch/powerpc/kvm/emulate.c            |    2 +-
 6 files changed, 14 insertions(+), 5 deletions(-)

diff --git a/arch/powerpc/include/asm/kvm_book3s.h b/arch/powerpc/include/asm/kvm_book3s.h
index c91be0f..79ab8fa 100644
--- a/arch/powerpc/include/asm/kvm_book3s.h
+++ b/arch/powerpc/include/asm/kvm_book3s.h
@@ -91,6 +91,7 @@ struct kvmppc_vcpu_book3s {
 	u64 vsid_next;
 	u64 vsid_max;
 	int context_id;
+	ulong prog_flags; /* flags to inject when giving a 700 trap */
 };
 
 #define CONTEXT_HOST		0
diff --git a/arch/powerpc/include/asm/kvm_ppc.h b/arch/powerpc/include/asm/kvm_ppc.h
index 89c5d79..09816da 100644
--- a/arch/powerpc/include/asm/kvm_ppc.h
+++ b/arch/powerpc/include/asm/kvm_ppc.h
@@ -80,7 +80,7 @@ extern void kvmppc_core_vcpu_put(struct kvm_vcpu *vcpu);
 
 extern void kvmppc_core_deliver_interrupts(struct kvm_vcpu *vcpu);
 extern int kvmppc_core_pending_dec(struct kvm_vcpu *vcpu);
-extern void kvmppc_core_queue_program(struct kvm_vcpu *vcpu);
+extern void kvmppc_core_queue_program(struct kvm_vcpu *vcpu, ulong flags);
 extern void kvmppc_core_queue_dec(struct kvm_vcpu *vcpu);
 extern void kvmppc_core_dequeue_dec(struct kvm_vcpu *vcpu);
 extern void kvmppc_core_queue_external(struct kvm_vcpu *vcpu,
diff --git a/arch/powerpc/include/asm/reg.h b/arch/powerpc/include/asm/reg.h
index bc8dd53..5572e86 100644
--- a/arch/powerpc/include/asm/reg.h
+++ b/arch/powerpc/include/asm/reg.h
@@ -426,6 +426,10 @@
 #define   SRR1_WAKEMT		0x00280000 /* mtctrl */
 #define   SRR1_WAKEDEC		0x00180000 /* Decrementer interrupt */
 #define   SRR1_WAKETHERM	0x00100000 /* Thermal management interrupt */
+#define   SRR1_PROGFPE		0x00100000 /* Floating Point Enabled */
+#define   SRR1_PROGPRIV		0x00040000 /* Privileged instruction */
+#define   SRR1_PROGTRAP		0x00020000 /* Trap */
+#define   SRR1_PROGADDR		0x00010000 /* SRR0 contains subsequent addr */
 #define SPRN_HSRR0	0x13A	/* Save/Restore Register 0 */
 #define SPRN_HSRR1	0x13B	/* Save/Restore Register 1 */
 
diff --git a/arch/powerpc/kvm/book3s.c b/arch/powerpc/kvm/book3s.c
index 1317392..66b5924 100644
--- a/arch/powerpc/kvm/book3s.c
+++ b/arch/powerpc/kvm/book3s.c
@@ -168,8 +168,9 @@ void kvmppc_book3s_queue_irqprio(struct kvm_vcpu *vcpu, unsigned int vec)
 }
 
 
-void kvmppc_core_queue_program(struct kvm_vcpu *vcpu)
+void kvmppc_core_queue_program(struct kvm_vcpu *vcpu, ulong flags)
 {
+	to_book3s(vcpu)->prog_flags = flags;
 	kvmppc_book3s_queue_irqprio(vcpu, BOOK3S_INTERRUPT_PROGRAM);
 }
 
@@ -198,6 +199,7 @@ int kvmppc_book3s_irqprio_deliver(struct kvm_vcpu *vcpu, unsigned int priority)
 {
 	int deliver = 1;
 	int vec = 0;
+	ulong flags = 0ULL;
 
 	switch (priority) {
 	case BOOK3S_IRQPRIO_DECREMENTER:
@@ -231,6 +233,7 @@ int kvmppc_book3s_irqprio_deliver(struct kvm_vcpu *vcpu, unsigned int priority)
 		break;
 	case BOOK3S_IRQPRIO_PROGRAM:
 		vec = BOOK3S_INTERRUPT_PROGRAM;
+		flags = to_book3s(vcpu)->prog_flags;
 		break;
 	case BOOK3S_IRQPRIO_VSX:
 		vec = BOOK3S_INTERRUPT_VSX;
@@ -261,7 +264,7 @@ int kvmppc_book3s_irqprio_deliver(struct kvm_vcpu *vcpu, unsigned int priority)
 #endif
 
 	if (deliver)
-		kvmppc_inject_interrupt(vcpu, vec, 0ULL);
+		kvmppc_inject_interrupt(vcpu, vec, flags);
 
 	return deliver;
 }
diff --git a/arch/powerpc/kvm/booke.c b/arch/powerpc/kvm/booke.c
index 338baf9..e283e44 100644
--- a/arch/powerpc/kvm/booke.c
+++ b/arch/powerpc/kvm/booke.c
@@ -82,8 +82,9 @@ static void kvmppc_booke_queue_irqprio(struct kvm_vcpu *vcpu,
 	set_bit(priority, &vcpu->arch.pending_exceptions);
 }
 
-void kvmppc_core_queue_program(struct kvm_vcpu *vcpu)
+void kvmppc_core_queue_program(struct kvm_vcpu *vcpu, ulong flags)
 {
+	/* BookE does flags in ESR, so ignore those we get here */
 	kvmppc_booke_queue_irqprio(vcpu, BOOKE_IRQPRIO_PROGRAM);
 }
 
diff --git a/arch/powerpc/kvm/emulate.c b/arch/powerpc/kvm/emulate.c
index 04e317c..8b0ba0b 100644
--- a/arch/powerpc/kvm/emulate.c
+++ b/arch/powerpc/kvm/emulate.c
@@ -154,7 +154,7 @@ int kvmppc_emulate_instruction(struct kvm_run *run, struct kvm_vcpu *vcpu)
 #else
 		vcpu->arch.esr |= ESR_PTR;
 #endif
-		kvmppc_core_queue_program(vcpu);
+		kvmppc_core_queue_program(vcpu, SRR1_PROGTRAP);
 		advance = 0;
 		break;
 
-- 
1.6.5.3

