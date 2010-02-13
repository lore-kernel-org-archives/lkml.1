Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754194Ab0BMICg (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Feb 2010 03:02:36 -0500
Received: from mx1.redhat.com ([209.132.183.28]:45335 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752231Ab0BMICD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Feb 2010 03:02:03 -0500
From: Avi Kivity <avi@redhat.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 01/39] KVM: PPC: Enable lightweight exits again
Date: Sat, 13 Feb 2010 10:01:21 +0200
Message-Id: <1266048119-14325-2-git-send-email-avi@redhat.com>
In-Reply-To: <1266048119-14325-1-git-send-email-avi@redhat.com>
References: <1266048119-14325-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alexander Graf <agraf@suse.de>

The PowerPC C ABI defines that registers r14-r31 need to be preserved across
function calls. Since our exit handler is written in C, we can make use of that
and don't need to reload r14-r31 on every entry/exit cycle.

This technique is also used in the BookE code and is called "lightweight exits"
there. To follow the tradition, it's called the same in Book3S.

So far this optimization was disabled though, as the code didn't do what it was
expected to do, but failed to work.

This patch fixes and enables lightweight exits again.

Signed-off-by: Alexander Graf <agraf@suse.de>
Signed-off-by: Marcelo Tosatti <mtosatti@redhat.com>
---
 arch/powerpc/kvm/book3s.c               |    4 +-
 arch/powerpc/kvm/book3s_64_interrupts.S |  106 ++++++++++++++++---------------
 2 files changed, 57 insertions(+), 53 deletions(-)

diff --git a/arch/powerpc/kvm/book3s.c b/arch/powerpc/kvm/book3s.c
index 492dcc1..fd2a4d5 100644
--- a/arch/powerpc/kvm/book3s.c
+++ b/arch/powerpc/kvm/book3s.c
@@ -539,8 +539,6 @@ int kvmppc_handle_pagefault(struct kvm_run *run, struct kvm_vcpu *vcpu,
 		r = kvmppc_emulate_mmio(run, vcpu);
 		if ( r == RESUME_HOST_NV )
 			r = RESUME_HOST;
-		if ( r == RESUME_GUEST_NV )
-			r = RESUME_GUEST;
 	}
 
 	return r;
@@ -645,7 +643,7 @@ int kvmppc_handle_exit(struct kvm_run *run, struct kvm_vcpu *vcpu,
 		er = kvmppc_emulate_instruction(run, vcpu);
 		switch (er) {
 		case EMULATE_DONE:
-			r = RESUME_GUEST;
+			r = RESUME_GUEST_NV;
 			break;
 		case EMULATE_FAIL:
 			printk(KERN_CRIT "%s: emulation at %lx failed (%08x)\n",
diff --git a/arch/powerpc/kvm/book3s_64_interrupts.S b/arch/powerpc/kvm/book3s_64_interrupts.S
index 7b55d80..d95d0d9 100644
--- a/arch/powerpc/kvm/book3s_64_interrupts.S
+++ b/arch/powerpc/kvm/book3s_64_interrupts.S
@@ -40,6 +40,26 @@
        mtmsrd  r0,1
 .endm
 
+#define VCPU_LOAD_NVGPRS(vcpu) \
+	ld	r14, VCPU_GPR(r14)(vcpu); \
+	ld	r15, VCPU_GPR(r15)(vcpu); \
+	ld	r16, VCPU_GPR(r16)(vcpu); \
+	ld	r17, VCPU_GPR(r17)(vcpu); \
+	ld	r18, VCPU_GPR(r18)(vcpu); \
+	ld	r19, VCPU_GPR(r19)(vcpu); \
+	ld	r20, VCPU_GPR(r20)(vcpu); \
+	ld	r21, VCPU_GPR(r21)(vcpu); \
+	ld	r22, VCPU_GPR(r22)(vcpu); \
+	ld	r23, VCPU_GPR(r23)(vcpu); \
+	ld	r24, VCPU_GPR(r24)(vcpu); \
+	ld	r25, VCPU_GPR(r25)(vcpu); \
+	ld	r26, VCPU_GPR(r26)(vcpu); \
+	ld	r27, VCPU_GPR(r27)(vcpu); \
+	ld	r28, VCPU_GPR(r28)(vcpu); \
+	ld	r29, VCPU_GPR(r29)(vcpu); \
+	ld	r30, VCPU_GPR(r30)(vcpu); \
+	ld	r31, VCPU_GPR(r31)(vcpu); \
+
 /*****************************************************************************
  *                                                                           *
  *     Guest entry / exit code that is in kernel module memory (highmem)     *
@@ -67,12 +87,16 @@ kvm_start_entry:
 	SAVE_NVGPRS(r1)
 
 	/* Save LR */
-	mflr	r14
-	std	r14, _LINK(r1)
+	std	r0, _LINK(r1)
+
+	/* Load non-volatile guest state from the vcpu */
+	VCPU_LOAD_NVGPRS(r4)
 
-/* XXX optimize non-volatile loading away */
 kvm_start_lightweight:
 
+	ld	r9, VCPU_PC(r4)			/* r9 = vcpu->arch.pc */
+	ld	r10, VCPU_SHADOW_MSR(r4)	/* r10 = vcpu->arch.shadow_msr */
+
 	DISABLE_INTERRUPTS
 
 	/* Save R1/R2 in the PACA */
@@ -81,29 +105,6 @@ kvm_start_lightweight:
 	ld	r3, VCPU_HIGHMEM_HANDLER(r4)
 	std	r3, PACASAVEDMSR(r13)
 
-	/* Load non-volatile guest state from the vcpu */
-	ld	r14, VCPU_GPR(r14)(r4)
-	ld	r15, VCPU_GPR(r15)(r4)
-	ld	r16, VCPU_GPR(r16)(r4)
-	ld	r17, VCPU_GPR(r17)(r4)
-	ld	r18, VCPU_GPR(r18)(r4)
-	ld	r19, VCPU_GPR(r19)(r4)
-	ld	r20, VCPU_GPR(r20)(r4)
-	ld	r21, VCPU_GPR(r21)(r4)
-	ld	r22, VCPU_GPR(r22)(r4)
-	ld	r23, VCPU_GPR(r23)(r4)
-	ld	r24, VCPU_GPR(r24)(r4)
-	ld	r25, VCPU_GPR(r25)(r4)
-	ld	r26, VCPU_GPR(r26)(r4)
-	ld	r27, VCPU_GPR(r27)(r4)
-	ld	r28, VCPU_GPR(r28)(r4)
-	ld	r29, VCPU_GPR(r29)(r4)
-	ld	r30, VCPU_GPR(r30)(r4)
-	ld	r31, VCPU_GPR(r31)(r4)
-
-	ld	r9, VCPU_PC(r4)			/* r9 = vcpu->arch.pc */
-	ld	r10, VCPU_SHADOW_MSR(r4)	/* r10 = vcpu->arch.shadow_msr */
-
 	ld	r3, VCPU_TRAMPOLINE_ENTER(r4)
 	mtsrr0	r3
 
@@ -247,7 +248,6 @@ kvmppc_handler_highmem:
 
 no_dcbz32_off:
 
-	/* XXX maybe skip on lightweight? */
 	std	r14, VCPU_GPR(r14)(r12)
 	std	r15, VCPU_GPR(r15)(r12)
 	std	r16, VCPU_GPR(r16)(r12)
@@ -267,9 +267,6 @@ no_dcbz32_off:
 	std	r30, VCPU_GPR(r30)(r12)
 	std	r31, VCPU_GPR(r31)(r12)
 
-	/* Restore non-volatile host registers (r14 - r31) */
-	REST_NVGPRS(r1)
-
 	/* Save guest PC (R10) */
 	std	r10, VCPU_PC(r12)
 
@@ -351,42 +348,51 @@ kvm_return_point:
 
 	/* Jump back to lightweight entry if we're supposed to */
 	/* go back into the guest */
+
+	/* Pass the exit number as 3rd argument to kvmppc_handle_exit */
 	mr	r5, r3
+
 	/* Restore r3 (kvm_run) and r4 (vcpu) */
 	REST_2GPRS(3, r1)
 	bl	KVMPPC_HANDLE_EXIT
 
-#if 0 /* XXX get lightweight exits back */
+	/* If RESUME_GUEST, get back in the loop */
 	cmpwi	r3, RESUME_GUEST
-	bne	kvm_exit_heavyweight
+	beq	kvm_loop_lightweight
 
-	/* put VCPU and KVM_RUN back into place and roll again! */
-	REST_2GPRS(3, r1)
-	b	kvm_start_lightweight
+	cmpwi	r3, RESUME_GUEST_NV
+	beq	kvm_loop_heavyweight
 
-kvm_exit_heavyweight:
-	/* Restore non-volatile host registers */
-	ld	r14, _LINK(r1)
-	mtlr	r14
-	REST_NVGPRS(r1)
+kvm_exit_loop:
 
-	addi    r1, r1, SWITCH_FRAME_SIZE
-#else
 	ld	r4, _LINK(r1)
 	mtlr	r4
 
-	cmpwi	r3, RESUME_GUEST
-	bne	kvm_exit_heavyweight
+	/* Restore non-volatile host registers (r14 - r31) */
+	REST_NVGPRS(r1)
+
+	addi    r1, r1, SWITCH_FRAME_SIZE
+	blr
+
+kvm_loop_heavyweight:
 
+	ld	r4, _LINK(r1)
+	std     r4, (16 + SWITCH_FRAME_SIZE)(r1)
+
+	/* Load vcpu and cpu_run */
 	REST_2GPRS(3, r1)
 
-	addi    r1, r1, SWITCH_FRAME_SIZE
+	/* Load non-volatile guest state from the vcpu */
+	VCPU_LOAD_NVGPRS(r4)
 
-	b	kvm_start_entry
+	/* Jump back into the beginning of this function */
+	b	kvm_start_lightweight
 
-kvm_exit_heavyweight:
+kvm_loop_lightweight:
 
-	addi    r1, r1, SWITCH_FRAME_SIZE
-#endif
+	/* We'll need the vcpu pointer */
+	REST_GPR(4, r1)
+
+	/* Jump back into the beginning of this function */
+	b	kvm_start_lightweight
 
-	blr
-- 
1.6.5.3

