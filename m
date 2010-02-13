Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757419Ab0BMIKr (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Feb 2010 03:10:47 -0500
Received: from mx1.redhat.com ([209.132.183.28]:49526 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752321Ab0BMICD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Feb 2010 03:02:03 -0500
From: Avi Kivity <avi@redhat.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 09/39] KVM: PPC: Implement 'skip instruction' mode
Date: Sat, 13 Feb 2010 10:01:29 +0200
Message-Id: <1266048119-14325-10-git-send-email-avi@redhat.com>
In-Reply-To: <1266048119-14325-1-git-send-email-avi@redhat.com>
References: <1266048119-14325-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alexander Graf <agraf@suse.de>

To fetch the last instruction we were interrupted on, we enable DR in early
exit code, where we are still in a very transitional phase between guest
and host state.

Most of the time this seemed to work, but another CPU can easily flush our
TLB and HTAB which makes us go in the Linux page fault handler which totally
breaks because we still use the guest's SLB entries.

To work around that, let's introduce a second KVM guest mode that defines
that whenever we get a trap, we don't call the Linux handler or go into
the KVM exit code, but just jump over the faulting instruction.

That way a potentially bad lwz doesn't trigger any faults and we can later
on interpret the invalid instruction we fetched as "fetch didn't work".

Signed-off-by: Alexander Graf <agraf@suse.de>
Signed-off-by: Avi Kivity <avi@redhat.com>
---
 arch/powerpc/include/asm/kvm_asm.h      |    6 ++++
 arch/powerpc/kvm/book3s_64_rmhandlers.S |   39 ++++++++++++++++++++++++++++++-
 arch/powerpc/kvm/book3s_64_slb.S        |   16 ++++++++----
 arch/powerpc/kvm/emulate.c              |    4 +++
 4 files changed, 59 insertions(+), 6 deletions(-)

diff --git a/arch/powerpc/include/asm/kvm_asm.h b/arch/powerpc/include/asm/kvm_asm.h
index af2abe7..aadf2dd 100644
--- a/arch/powerpc/include/asm/kvm_asm.h
+++ b/arch/powerpc/include/asm/kvm_asm.h
@@ -97,4 +97,10 @@
 #define RESUME_HOST             RESUME_FLAG_HOST
 #define RESUME_HOST_NV          (RESUME_FLAG_HOST|RESUME_FLAG_NV)
 
+#define KVM_GUEST_MODE_NONE	0
+#define KVM_GUEST_MODE_GUEST	1
+#define KVM_GUEST_MODE_SKIP	2
+
+#define KVM_INST_FETCH_FAILED	-1
+
 #endif /* __POWERPC_KVM_ASM_H__ */
diff --git a/arch/powerpc/kvm/book3s_64_rmhandlers.S b/arch/powerpc/kvm/book3s_64_rmhandlers.S
index cd9f0b6..9ad1c26 100644
--- a/arch/powerpc/kvm/book3s_64_rmhandlers.S
+++ b/arch/powerpc/kvm/book3s_64_rmhandlers.S
@@ -49,7 +49,7 @@ kvmppc_trampoline_\intno:
 	mfcr	r12
 	stw	r12, PACA_KVM_SCRATCH1(r13)
 	lbz	r12, PACA_KVM_IN_GUEST(r13)
-	cmpwi	r12, 0
+	cmpwi	r12, KVM_GUEST_MODE_NONE
 	bne	..kvmppc_handler_hasmagic_\intno
 	/* No KVM guest? Then jump back to the Linux handler! */
 	lwz	r12, PACA_KVM_SCRATCH1(r13)
@@ -60,6 +60,11 @@ kvmppc_trampoline_\intno:
 
 	/* Now we know we're handling a KVM guest */
 ..kvmppc_handler_hasmagic_\intno:
+
+	/* Should we just skip the faulting instruction? */
+	cmpwi	r12, KVM_GUEST_MODE_SKIP
+	beq	kvmppc_handler_skip_ins
+
 	/* Let's store which interrupt we're handling */
 	li	r12, \intno
 
@@ -86,6 +91,38 @@ INTERRUPT_TRAMPOLINE	BOOK3S_INTERRUPT_ALTIVEC
 INTERRUPT_TRAMPOLINE	BOOK3S_INTERRUPT_VSX
 
 /*
+ * Bring us back to the faulting code, but skip the
+ * faulting instruction.
+ *
+ * This is a generic exit path from the interrupt
+ * trampolines above.
+ *
+ * Input Registers:
+ *
+ * R12               = free
+ * R13               = PACA
+ * PACA.KVM.SCRATCH0 = guest R12
+ * PACA.KVM.SCRATCH1 = guest CR
+ * SPRG_SCRATCH0     = guest R13
+ *
+ */
+kvmppc_handler_skip_ins:
+
+	/* Patch the IP to the next instruction */
+	mfsrr0	r12
+	addi	r12, r12, 4
+	mtsrr0	r12
+
+	/* Clean up all state */
+	lwz	r12, PACA_KVM_SCRATCH1(r13)
+	mtcr	r12
+	ld	r12, PACA_KVM_SCRATCH0(r13)
+	mfspr	r13, SPRN_SPRG_SCRATCH0
+
+	/* And get back into the code */
+	RFI
+
+/*
  * This trampoline brings us back to a real mode handler
  *
  * Input Registers:
diff --git a/arch/powerpc/kvm/book3s_64_slb.S b/arch/powerpc/kvm/book3s_64_slb.S
index 7188c11..d07b886 100644
--- a/arch/powerpc/kvm/book3s_64_slb.S
+++ b/arch/powerpc/kvm/book3s_64_slb.S
@@ -212,10 +212,6 @@ kvmppc_handler_trampoline_exit:
 	mfdar	r5
 	mfdsisr	r6
 
-	/* Unset guest state */
-	li	r9, 0
-	stb	r9, PACA_KVM_IN_GUEST(r13)
-
 	/*
 	 * In order for us to easily get the last instruction,
 	 * we got the #vmexit at, we exploit the fact that the
@@ -233,18 +229,28 @@ kvmppc_handler_trampoline_exit:
 
 ld_last_inst:
 	/* Save off the guest instruction we're at */
+
+	/* Set guest mode to 'jump over instruction' so if lwz faults
+	 * we'll just continue at the next IP. */
+	li	r9, KVM_GUEST_MODE_SKIP
+	stb	r9, PACA_KVM_IN_GUEST(r13)
+
 	/*    1) enable paging for data */
 	mfmsr	r9
 	ori	r11, r9, MSR_DR			/* Enable paging for data */
 	mtmsr	r11
 	/*    2) fetch the instruction */
-	/* XXX implement PACA_KVM_IN_GUEST=2 path to safely jump over this */
+	li	r0, KVM_INST_FETCH_FAILED	/* In case lwz faults */
 	lwz	r0, 0(r3)
 	/*    3) disable paging again */
 	mtmsr	r9
 
 no_ld_last_inst:
 
+	/* Unset guest mode */
+	li	r9, KVM_GUEST_MODE_NONE
+	stb	r9, PACA_KVM_IN_GUEST(r13)
+
 	/* Restore bolted entries from the shadow and fix it along the way */
 
 	/* We don't store anything in entry 0, so we don't need to take care of it */
diff --git a/arch/powerpc/kvm/emulate.c b/arch/powerpc/kvm/emulate.c
index 38219af..04e317c 100644
--- a/arch/powerpc/kvm/emulate.c
+++ b/arch/powerpc/kvm/emulate.c
@@ -143,6 +143,10 @@ int kvmppc_emulate_instruction(struct kvm_run *run, struct kvm_vcpu *vcpu)
 
 	pr_debug(KERN_INFO "Emulating opcode %d / %d\n", get_op(inst), get_xop(inst));
 
+	/* Try again next time */
+	if (inst == KVM_INST_FETCH_FAILED)
+		return EMULATE_DONE;
+
 	switch (get_op(inst)) {
 	case OP_TRAP:
 #ifdef CONFIG_PPC64
-- 
1.6.5.3

