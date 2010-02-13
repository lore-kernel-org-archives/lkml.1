Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751971Ab0BMIJi (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Feb 2010 03:09:38 -0500
Received: from mx1.redhat.com ([209.132.183.28]:6630 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752346Ab0BMICE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Feb 2010 03:02:04 -0500
From: Avi Kivity <avi@redhat.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 08/39] KVM: PPC: Use PACA backed shadow vcpu
Date: Sat, 13 Feb 2010 10:01:28 +0200
Message-Id: <1266048119-14325-9-git-send-email-avi@redhat.com>
In-Reply-To: <1266048119-14325-1-git-send-email-avi@redhat.com>
References: <1266048119-14325-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alexander Graf <agraf@suse.de>

We're being horribly racy right now. All the entry and exit code hijacks
random fields from the PACA that could easily be used by different code in
case we get interrupted, for example by a #MC or even page fault.

After discussing this with Ben, we figured it's best to reserve some more
space in the PACA and just shove off some vcpu state to there.

That way we can drastically improve the readability of the code, make it
less racy and less complex.

Signed-off-by: Alexander Graf <agraf@suse.de>
Signed-off-by: Avi Kivity <avi@redhat.com>
---
 arch/powerpc/include/asm/kvm_book3s.h        |    2 +
 arch/powerpc/include/asm/kvm_book3s_64_asm.h |   19 +++
 arch/powerpc/include/asm/kvm_host.h          |    5 +-
 arch/powerpc/include/asm/kvm_ppc.h           |   20 ++-
 arch/powerpc/include/asm/paca.h              |    5 +
 arch/powerpc/kernel/asm-offsets.c            |   33 ++++-
 arch/powerpc/kvm/book3s.c                    |    4 +
 arch/powerpc/kvm/book3s_64_interrupts.S      |  216 +++++++++-----------------
 arch/powerpc/kvm/book3s_64_rmhandlers.S      |   32 +---
 arch/powerpc/kvm/book3s_64_slb.S             |  150 +++++++++++-------
 10 files changed, 249 insertions(+), 237 deletions(-)

diff --git a/arch/powerpc/include/asm/kvm_book3s.h b/arch/powerpc/include/asm/kvm_book3s.h
index 74b7369..f192017 100644
--- a/arch/powerpc/include/asm/kvm_book3s.h
+++ b/arch/powerpc/include/asm/kvm_book3s.h
@@ -23,6 +23,7 @@
 #include <linux/types.h>
 #include <linux/kvm_host.h>
 #include <asm/kvm_ppc.h>
+#include <asm/kvm_book3s_64_asm.h>
 
 struct kvmppc_slb {
 	u64 esid;
@@ -69,6 +70,7 @@ struct kvmppc_sid_map {
 
 struct kvmppc_vcpu_book3s {
 	struct kvm_vcpu vcpu;
+	struct kvmppc_book3s_shadow_vcpu shadow_vcpu;
 	struct kvmppc_sid_map sid_map[SID_MAP_NUM];
 	struct kvmppc_slb slb[64];
 	struct {
diff --git a/arch/powerpc/include/asm/kvm_book3s_64_asm.h b/arch/powerpc/include/asm/kvm_book3s_64_asm.h
index 2e06ee8..fca9404 100644
--- a/arch/powerpc/include/asm/kvm_book3s_64_asm.h
+++ b/arch/powerpc/include/asm/kvm_book3s_64_asm.h
@@ -20,6 +20,8 @@
 #ifndef __ASM_KVM_BOOK3S_ASM_H__
 #define __ASM_KVM_BOOK3S_ASM_H__
 
+#ifdef __ASSEMBLY__
+
 #ifdef CONFIG_KVM_BOOK3S_64_HANDLER
 
 #include <asm/kvm_asm.h>
@@ -55,4 +57,21 @@ kvmppc_resume_\intno:
 
 #endif /* CONFIG_KVM_BOOK3S_64_HANDLER */
 
+#else  /*__ASSEMBLY__ */
+
+struct kvmppc_book3s_shadow_vcpu {
+	ulong gpr[14];
+	u32 cr;
+	u32 xer;
+	ulong host_r1;
+	ulong host_r2;
+	ulong handler;
+	ulong scratch0;
+	ulong scratch1;
+	ulong vmhandler;
+	ulong rmhandler;
+};
+
+#endif /*__ASSEMBLY__ */
+
 #endif /* __ASM_KVM_BOOK3S_ASM_H__ */
diff --git a/arch/powerpc/include/asm/kvm_host.h b/arch/powerpc/include/asm/kvm_host.h
index 1201f62..d615fa8 100644
--- a/arch/powerpc/include/asm/kvm_host.h
+++ b/arch/powerpc/include/asm/kvm_host.h
@@ -175,10 +175,13 @@ struct kvm_vcpu_arch {
 	ulong gpr[32];
 
 	ulong pc;
-	u32 cr;
 	ulong ctr;
 	ulong lr;
+
+#ifdef CONFIG_BOOKE
 	ulong xer;
+	u32 cr;
+#endif
 
 	ulong msr;
 #ifdef CONFIG_PPC64
diff --git a/arch/powerpc/include/asm/kvm_ppc.h b/arch/powerpc/include/asm/kvm_ppc.h
index d60b2f0..89c5d79 100644
--- a/arch/powerpc/include/asm/kvm_ppc.h
+++ b/arch/powerpc/include/asm/kvm_ppc.h
@@ -98,34 +98,42 @@ extern void kvmppc_core_destroy_mmu(struct kvm_vcpu *vcpu);
 
 #ifdef CONFIG_PPC_BOOK3S
 
+/* We assume we're always acting on the current vcpu */
+
 static inline void kvmppc_set_gpr(struct kvm_vcpu *vcpu, int num, ulong val)
 {
-	vcpu->arch.gpr[num] = val;
+	if ( num < 14 )
+		get_paca()->shadow_vcpu.gpr[num] = val;
+	else
+		vcpu->arch.gpr[num] = val;
 }
 
 static inline ulong kvmppc_get_gpr(struct kvm_vcpu *vcpu, int num)
 {
-	return vcpu->arch.gpr[num];
+	if ( num < 14 )
+		return get_paca()->shadow_vcpu.gpr[num];
+	else
+		return vcpu->arch.gpr[num];
 }
 
 static inline void kvmppc_set_cr(struct kvm_vcpu *vcpu, u32 val)
 {
-	vcpu->arch.cr = val;
+	get_paca()->shadow_vcpu.cr = val;
 }
 
 static inline u32 kvmppc_get_cr(struct kvm_vcpu *vcpu)
 {
-	return vcpu->arch.cr;
+	return get_paca()->shadow_vcpu.cr;
 }
 
 static inline void kvmppc_set_xer(struct kvm_vcpu *vcpu, u32 val)
 {
-	vcpu->arch.xer = val;
+	get_paca()->shadow_vcpu.xer = val;
 }
 
 static inline u32 kvmppc_get_xer(struct kvm_vcpu *vcpu)
 {
-	return vcpu->arch.xer;
+	return get_paca()->shadow_vcpu.xer;
 }
 
 #else
diff --git a/arch/powerpc/include/asm/paca.h b/arch/powerpc/include/asm/paca.h
index 5e9b4ef..d8a6931 100644
--- a/arch/powerpc/include/asm/paca.h
+++ b/arch/powerpc/include/asm/paca.h
@@ -19,6 +19,9 @@
 #include <asm/mmu.h>
 #include <asm/page.h>
 #include <asm/exception-64e.h>
+#ifdef CONFIG_KVM_BOOK3S_64_HANDLER
+#include <asm/kvm_book3s_64_asm.h>
+#endif
 
 register struct paca_struct *local_paca asm("r13");
 
@@ -135,6 +138,8 @@ struct paca_struct {
 		u64     esid;
 		u64     vsid;
 	} kvm_slb[64];			/* guest SLB */
+	/* We use this to store guest state in */
+	struct kvmppc_book3s_shadow_vcpu shadow_vcpu;
 	u8 kvm_slb_max;			/* highest used guest slb entry */
 	u8 kvm_in_guest;		/* are we inside the guest? */
 #endif
diff --git a/arch/powerpc/kernel/asm-offsets.c b/arch/powerpc/kernel/asm-offsets.c
index a6c2b63..1501e77 100644
--- a/arch/powerpc/kernel/asm-offsets.c
+++ b/arch/powerpc/kernel/asm-offsets.c
@@ -194,6 +194,32 @@ int main(void)
 	DEFINE(PACA_KVM_IN_GUEST, offsetof(struct paca_struct, kvm_in_guest));
 	DEFINE(PACA_KVM_SLB, offsetof(struct paca_struct, kvm_slb));
 	DEFINE(PACA_KVM_SLB_MAX, offsetof(struct paca_struct, kvm_slb_max));
+	DEFINE(PACA_KVM_CR, offsetof(struct paca_struct, shadow_vcpu.cr));
+	DEFINE(PACA_KVM_XER, offsetof(struct paca_struct, shadow_vcpu.xer));
+	DEFINE(PACA_KVM_R0, offsetof(struct paca_struct, shadow_vcpu.gpr[0]));
+	DEFINE(PACA_KVM_R1, offsetof(struct paca_struct, shadow_vcpu.gpr[1]));
+	DEFINE(PACA_KVM_R2, offsetof(struct paca_struct, shadow_vcpu.gpr[2]));
+	DEFINE(PACA_KVM_R3, offsetof(struct paca_struct, shadow_vcpu.gpr[3]));
+	DEFINE(PACA_KVM_R4, offsetof(struct paca_struct, shadow_vcpu.gpr[4]));
+	DEFINE(PACA_KVM_R5, offsetof(struct paca_struct, shadow_vcpu.gpr[5]));
+	DEFINE(PACA_KVM_R6, offsetof(struct paca_struct, shadow_vcpu.gpr[6]));
+	DEFINE(PACA_KVM_R7, offsetof(struct paca_struct, shadow_vcpu.gpr[7]));
+	DEFINE(PACA_KVM_R8, offsetof(struct paca_struct, shadow_vcpu.gpr[8]));
+	DEFINE(PACA_KVM_R9, offsetof(struct paca_struct, shadow_vcpu.gpr[9]));
+	DEFINE(PACA_KVM_R10, offsetof(struct paca_struct, shadow_vcpu.gpr[10]));
+	DEFINE(PACA_KVM_R11, offsetof(struct paca_struct, shadow_vcpu.gpr[11]));
+	DEFINE(PACA_KVM_R12, offsetof(struct paca_struct, shadow_vcpu.gpr[12]));
+	DEFINE(PACA_KVM_R13, offsetof(struct paca_struct, shadow_vcpu.gpr[13]));
+	DEFINE(PACA_KVM_HOST_R1, offsetof(struct paca_struct, shadow_vcpu.host_r1));
+	DEFINE(PACA_KVM_HOST_R2, offsetof(struct paca_struct, shadow_vcpu.host_r2));
+	DEFINE(PACA_KVM_VMHANDLER, offsetof(struct paca_struct,
+					    shadow_vcpu.vmhandler));
+	DEFINE(PACA_KVM_RMHANDLER, offsetof(struct paca_struct,
+					    shadow_vcpu.rmhandler));
+	DEFINE(PACA_KVM_SCRATCH0, offsetof(struct paca_struct,
+					   shadow_vcpu.scratch0));
+	DEFINE(PACA_KVM_SCRATCH1, offsetof(struct paca_struct,
+					   shadow_vcpu.scratch1));
 #endif
 #endif /* CONFIG_PPC64 */
 
@@ -389,8 +415,6 @@ int main(void)
 	DEFINE(VCPU_HOST_PID, offsetof(struct kvm_vcpu, arch.host_pid));
 	DEFINE(VCPU_GPRS, offsetof(struct kvm_vcpu, arch.gpr));
 	DEFINE(VCPU_LR, offsetof(struct kvm_vcpu, arch.lr));
-	DEFINE(VCPU_CR, offsetof(struct kvm_vcpu, arch.cr));
-	DEFINE(VCPU_XER, offsetof(struct kvm_vcpu, arch.xer));
 	DEFINE(VCPU_CTR, offsetof(struct kvm_vcpu, arch.ctr));
 	DEFINE(VCPU_PC, offsetof(struct kvm_vcpu, arch.pc));
 	DEFINE(VCPU_MSR, offsetof(struct kvm_vcpu, arch.msr));
@@ -415,7 +439,10 @@ int main(void)
 	DEFINE(VCPU_TRAMPOLINE_ENTER, offsetof(struct kvm_vcpu, arch.trampoline_enter));
 	DEFINE(VCPU_HIGHMEM_HANDLER, offsetof(struct kvm_vcpu, arch.highmem_handler));
 	DEFINE(VCPU_HFLAGS, offsetof(struct kvm_vcpu, arch.hflags));
-#endif
+#else
+	DEFINE(VCPU_CR, offsetof(struct kvm_vcpu, arch.cr));
+	DEFINE(VCPU_XER, offsetof(struct kvm_vcpu, arch.xer));
+#endif /* CONFIG_PPC64 */
 #endif
 #ifdef CONFIG_44x
 	DEFINE(PGD_T_LOG2, PGD_T_LOG2);
diff --git a/arch/powerpc/kvm/book3s.c b/arch/powerpc/kvm/book3s.c
index 09ba8db..3e06eae 100644
--- a/arch/powerpc/kvm/book3s.c
+++ b/arch/powerpc/kvm/book3s.c
@@ -66,12 +66,16 @@ void kvmppc_core_load_guest_debugstate(struct kvm_vcpu *vcpu)
 void kvmppc_core_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
 {
 	memcpy(get_paca()->kvm_slb, to_book3s(vcpu)->slb_shadow, sizeof(get_paca()->kvm_slb));
+	memcpy(&get_paca()->shadow_vcpu, &to_book3s(vcpu)->shadow_vcpu,
+	       sizeof(get_paca()->shadow_vcpu));
 	get_paca()->kvm_slb_max = to_book3s(vcpu)->slb_shadow_max;
 }
 
 void kvmppc_core_vcpu_put(struct kvm_vcpu *vcpu)
 {
 	memcpy(to_book3s(vcpu)->slb_shadow, get_paca()->kvm_slb, sizeof(get_paca()->kvm_slb));
+	memcpy(&to_book3s(vcpu)->shadow_vcpu, &get_paca()->shadow_vcpu,
+	       sizeof(get_paca()->shadow_vcpu));
 	to_book3s(vcpu)->slb_shadow_max = get_paca()->kvm_slb_max;
 }
 
diff --git a/arch/powerpc/kvm/book3s_64_interrupts.S b/arch/powerpc/kvm/book3s_64_interrupts.S
index d95d0d9..66e3b11 100644
--- a/arch/powerpc/kvm/book3s_64_interrupts.S
+++ b/arch/powerpc/kvm/book3s_64_interrupts.S
@@ -28,11 +28,6 @@
 #define ULONG_SIZE 8
 #define VCPU_GPR(n)     (VCPU_GPRS + (n * ULONG_SIZE))
 
-.macro mfpaca tmp_reg, src_reg, offset, vcpu_reg
-	ld	\tmp_reg, (PACA_EXMC+\offset)(r13)
-	std	\tmp_reg, VCPU_GPR(\src_reg)(\vcpu_reg)
-.endm
-
 .macro DISABLE_INTERRUPTS
        mfmsr   r0
        rldicl  r0,r0,48,1
@@ -92,37 +87,30 @@ kvm_start_entry:
 	/* Load non-volatile guest state from the vcpu */
 	VCPU_LOAD_NVGPRS(r4)
 
-kvm_start_lightweight:
-
-	ld	r9, VCPU_PC(r4)			/* r9 = vcpu->arch.pc */
-	ld	r10, VCPU_SHADOW_MSR(r4)	/* r10 = vcpu->arch.shadow_msr */
-
-	DISABLE_INTERRUPTS
-
 	/* Save R1/R2 in the PACA */
-	std	r1, PACAR1(r13)
-	std	r2, (PACA_EXMC+EX_SRR0)(r13)
+	std	r1, PACA_KVM_HOST_R1(r13)
+	std	r2, PACA_KVM_HOST_R2(r13)
+
+	/* XXX swap in/out on load? */
 	ld	r3, VCPU_HIGHMEM_HANDLER(r4)
-	std	r3, PACASAVEDMSR(r13)
+	std	r3, PACA_KVM_VMHANDLER(r13)
 
 	ld	r3, VCPU_TRAMPOLINE_ENTER(r4)
-	mtsrr0	r3
+	std	r3, PACA_KVM_RMHANDLER(r13)
 
-	LOAD_REG_IMMEDIATE(r3, MSR_KERNEL & ~(MSR_IR | MSR_DR))
-	mtsrr1	r3
+kvm_start_lightweight:
 
-	/* Load guest state in the respective registers */
-	lwz	r3, VCPU_CR(r4)		/* r3 = vcpu->arch.cr */
-	stw	r3, (PACA_EXMC + EX_CCR)(r13)
+	ld	r9, VCPU_PC(r4)			/* r9 = vcpu->arch.pc */
+	ld	r10, VCPU_SHADOW_MSR(r4)	/* r10 = vcpu->arch.shadow_msr */
 
+	/* Load some guest state in the respective registers */
 	ld	r3, VCPU_CTR(r4)	/* r3 = vcpu->arch.ctr */
 	mtctr	r3			/* CTR = r3 */
 
 	ld	r3, VCPU_LR(r4)		/* r3 = vcpu->arch.lr */
 	mtlr	r3			/* LR = r3 */
 
-	ld	r3, VCPU_XER(r4)	/* r3 = vcpu->arch.xer */
-	std	r3, (PACA_EXMC + EX_R3)(r13)
+	DISABLE_INTERRUPTS
 
 	/* Some guests may need to have dcbz set to 32 byte length.
 	 *
@@ -142,34 +130,21 @@ kvm_start_lightweight:
 	mtspr   SPRN_HID5,r3
 
 no_dcbz32_on:
-	/*	Load guest GPRs */
-
-	ld	r3, VCPU_GPR(r9)(r4)
-	std	r3, (PACA_EXMC + EX_R9)(r13)
-	ld	r3, VCPU_GPR(r10)(r4)
-	std	r3, (PACA_EXMC + EX_R10)(r13)
-	ld	r3, VCPU_GPR(r11)(r4)
-	std	r3, (PACA_EXMC + EX_R11)(r13)
-	ld	r3, VCPU_GPR(r12)(r4)
-	std	r3, (PACA_EXMC + EX_R12)(r13)
-	ld	r3, VCPU_GPR(r13)(r4)
-	std	r3, (PACA_EXMC + EX_R13)(r13)
-
-	ld	r0, VCPU_GPR(r0)(r4)
-	ld	r1, VCPU_GPR(r1)(r4)
-	ld	r2, VCPU_GPR(r2)(r4)
-	ld	r3, VCPU_GPR(r3)(r4)
-	ld	r5, VCPU_GPR(r5)(r4)
-	ld	r6, VCPU_GPR(r6)(r4)
-	ld	r7, VCPU_GPR(r7)(r4)
-	ld	r8, VCPU_GPR(r8)(r4)
-	ld	r4, VCPU_GPR(r4)(r4)
 
 	/* This sets the Magic value for the trampoline */
 
+	/* XXX this needs to move into a safe function, so we can
+	   be sure we don't get any interrupts */
+
 	li	r11, 1
 	stb	r11, PACA_KVM_IN_GUEST(r13)
 
+	ld	r3, PACA_KVM_RMHANDLER(r13)
+	mtsrr0	r3
+
+	LOAD_REG_IMMEDIATE(r3, MSR_KERNEL & ~(MSR_IR | MSR_DR))
+	mtsrr1	r3
+
 	/* Jump to SLB patching handlder and into our guest */
 	RFI
 
@@ -185,60 +160,31 @@ kvmppc_handler_highmem:
 	/*
 	 * Register usage at this point:
 	 *
-	 * R00   = guest R13
-	 * R01   = host R1
-	 * R02   = host R2
-	 * R10   = guest PC
-	 * R11   = guest MSR
-	 * R12   = exit handler id
-	 * R13   = PACA
-	 * PACA.exmc.R9    = guest R1
-	 * PACA.exmc.R10   = guest R10
-	 * PACA.exmc.R11   = guest R11
-	 * PACA.exmc.R12   = guest R12
-	 * PACA.exmc.R13   = guest R2
-	 * PACA.exmc.DAR   = guest DAR
-	 * PACA.exmc.DSISR = guest DSISR
-	 * PACA.exmc.LR    = guest instruction
-	 * PACA.exmc.CCR   = guest CR
-	 * PACA.exmc.SRR0  = guest R0
+	 * R0         = guest last inst
+	 * R1         = host R1
+	 * R2         = host R2
+	 * R3         = guest PC
+	 * R4         = guest MSR
+	 * R5         = guest DAR
+	 * R6         = guest DSISR
+	 * R13        = PACA
+	 * PACA.KVM.* = guest *
 	 *
 	 */
 
-	std	r3, (PACA_EXMC+EX_R3)(r13)
+	/* R7 = vcpu */
+	ld	r7, GPR4(r1)
 
-	/* save the exit id in R3 */
-	mr	r3, r12
+	/* Now save the guest state */
 
-	/* R12 = vcpu */
-	ld	r12, GPR4(r1)
+	stw	r0, VCPU_LAST_INST(r7)
 
-	/* Now save the guest state */
+	std	r3, VCPU_PC(r7)
+	std	r4, VCPU_SHADOW_MSR(r7)
+	std	r5, VCPU_FAULT_DEAR(r7)
+	std	r6, VCPU_FAULT_DSISR(r7)
 
-	std	r0, VCPU_GPR(r13)(r12)
-	std	r4, VCPU_GPR(r4)(r12)
-	std	r5, VCPU_GPR(r5)(r12)
-	std	r6, VCPU_GPR(r6)(r12)
-	std	r7, VCPU_GPR(r7)(r12)
-	std	r8, VCPU_GPR(r8)(r12)
-	std	r9, VCPU_GPR(r9)(r12)
-
-	/* get registers from PACA */
-	mfpaca	r5, r0, EX_SRR0, r12
-	mfpaca	r5, r3, EX_R3, r12
-	mfpaca	r5, r1, EX_R9, r12
-	mfpaca	r5, r10, EX_R10, r12
-	mfpaca	r5, r11, EX_R11, r12
-	mfpaca	r5, r12, EX_R12, r12
-	mfpaca	r5, r2, EX_R13, r12
-
-	lwz	r5, (PACA_EXMC+EX_LR)(r13)
-	stw	r5, VCPU_LAST_INST(r12)
-
-	lwz	r5, (PACA_EXMC+EX_CCR)(r13)
-	stw	r5, VCPU_CR(r12)
-
-	ld	r5, VCPU_HFLAGS(r12)
+	ld	r5, VCPU_HFLAGS(r7)
 	rldicl.	r5, r5, 0, 63		/* CR = ((r5 & 1) == 0) */
 	beq	no_dcbz32_off
 
@@ -248,58 +194,42 @@ kvmppc_handler_highmem:
 
 no_dcbz32_off:
 
-	std	r14, VCPU_GPR(r14)(r12)
-	std	r15, VCPU_GPR(r15)(r12)
-	std	r16, VCPU_GPR(r16)(r12)
-	std	r17, VCPU_GPR(r17)(r12)
-	std	r18, VCPU_GPR(r18)(r12)
-	std	r19, VCPU_GPR(r19)(r12)
-	std	r20, VCPU_GPR(r20)(r12)
-	std	r21, VCPU_GPR(r21)(r12)
-	std	r22, VCPU_GPR(r22)(r12)
-	std	r23, VCPU_GPR(r23)(r12)
-	std	r24, VCPU_GPR(r24)(r12)
-	std	r25, VCPU_GPR(r25)(r12)
-	std	r26, VCPU_GPR(r26)(r12)
-	std	r27, VCPU_GPR(r27)(r12)
-	std	r28, VCPU_GPR(r28)(r12)
-	std	r29, VCPU_GPR(r29)(r12)
-	std	r30, VCPU_GPR(r30)(r12)
-	std	r31, VCPU_GPR(r31)(r12)
-
-	/* Save guest PC (R10) */
-	std	r10, VCPU_PC(r12)
-
-	/* Save guest msr (R11) */
-	std	r11, VCPU_SHADOW_MSR(r12)
-
-	/* Save guest CTR (in R12) */
+	std	r14, VCPU_GPR(r14)(r7)
+	std	r15, VCPU_GPR(r15)(r7)
+	std	r16, VCPU_GPR(r16)(r7)
+	std	r17, VCPU_GPR(r17)(r7)
+	std	r18, VCPU_GPR(r18)(r7)
+	std	r19, VCPU_GPR(r19)(r7)
+	std	r20, VCPU_GPR(r20)(r7)
+	std	r21, VCPU_GPR(r21)(r7)
+	std	r22, VCPU_GPR(r22)(r7)
+	std	r23, VCPU_GPR(r23)(r7)
+	std	r24, VCPU_GPR(r24)(r7)
+	std	r25, VCPU_GPR(r25)(r7)
+	std	r26, VCPU_GPR(r26)(r7)
+	std	r27, VCPU_GPR(r27)(r7)
+	std	r28, VCPU_GPR(r28)(r7)
+	std	r29, VCPU_GPR(r29)(r7)
+	std	r30, VCPU_GPR(r30)(r7)
+	std	r31, VCPU_GPR(r31)(r7)
+
+	/* Save guest CTR */
 	mfctr	r5
-	std	r5, VCPU_CTR(r12)
+	std	r5, VCPU_CTR(r7)
 
 	/* Save guest LR */
 	mflr	r5
-	std	r5, VCPU_LR(r12)
-
-	/* Save guest XER */
-	mfxer	r5
-	std	r5, VCPU_XER(r12)
+	std	r5, VCPU_LR(r7)
 
-	/* Save guest DAR */
-	ld	r5, (PACA_EXMC+EX_DAR)(r13)
-	std	r5, VCPU_FAULT_DEAR(r12)
-
-	/* Save guest DSISR */
-	lwz	r5, (PACA_EXMC+EX_DSISR)(r13)
-	std	r5, VCPU_FAULT_DSISR(r12)
+	/* XXX convert to safe function call */
 
 	/* Restore host msr -> SRR1 */
-	ld	r7, VCPU_HOST_MSR(r12)
-	mtsrr1	r7
+	ld	r6, VCPU_HOST_MSR(r7)
+	mtsrr1	r6
 
 	/* Restore host IP -> SRR0 */
-	ld	r6, VCPU_HOST_RETIP(r12)
-	mtsrr0	r6
+	ld	r5, VCPU_HOST_RETIP(r7)
+	mtsrr0	r5
 
 	/*
 	 * For some interrupts, we need to call the real Linux
@@ -311,9 +241,9 @@ no_dcbz32_off:
 	 * r3 = address of interrupt handler (exit reason)
 	 */
 
-	cmpwi	r3, BOOK3S_INTERRUPT_EXTERNAL
+	cmpwi	r12, BOOK3S_INTERRUPT_EXTERNAL
 	beq	call_linux_handler
-	cmpwi	r3, BOOK3S_INTERRUPT_DECREMENTER
+	cmpwi	r12, BOOK3S_INTERRUPT_DECREMENTER
 	beq	call_linux_handler
 
 	/* Back to Interruptable Mode! (goto kvm_return_point) */
@@ -334,12 +264,12 @@ call_linux_handler:
 	 * R7 VCPU_HOST_MSR
 	 */
 
-	mtlr	r3
+	mtlr	r12
 
-	ld	r5, VCPU_TRAMPOLINE_LOWMEM(r12)
-	mtsrr0	r5
-	LOAD_REG_IMMEDIATE(r5, MSR_KERNEL & ~(MSR_IR | MSR_DR))
-	mtsrr1	r5
+	ld	r4, VCPU_TRAMPOLINE_LOWMEM(r7)
+	mtsrr0	r4
+	LOAD_REG_IMMEDIATE(r3, MSR_KERNEL & ~(MSR_IR | MSR_DR))
+	mtsrr1	r3
 
 	RFI
 
@@ -350,7 +280,7 @@ kvm_return_point:
 	/* go back into the guest */
 
 	/* Pass the exit number as 3rd argument to kvmppc_handle_exit */
-	mr	r5, r3
+	mr	r5, r12
 
 	/* Restore r3 (kvm_run) and r4 (vcpu) */
 	REST_2GPRS(3, r1)
diff --git a/arch/powerpc/kvm/book3s_64_rmhandlers.S b/arch/powerpc/kvm/book3s_64_rmhandlers.S
index fb7dd2e..cd9f0b6 100644
--- a/arch/powerpc/kvm/book3s_64_rmhandlers.S
+++ b/arch/powerpc/kvm/book3s_64_rmhandlers.S
@@ -45,37 +45,21 @@ kvmppc_trampoline_\intno:
 	 * To distinguish, we check a magic byte in the PACA
 	 */
 	mfspr	r13, SPRN_SPRG_PACA		/* r13 = PACA */
-	std	r12, (PACA_EXMC + EX_R12)(r13)
+	std	r12, PACA_KVM_SCRATCH0(r13)
 	mfcr	r12
-	stw	r12, (PACA_EXMC + EX_CCR)(r13)
+	stw	r12, PACA_KVM_SCRATCH1(r13)
 	lbz	r12, PACA_KVM_IN_GUEST(r13)
 	cmpwi	r12, 0
 	bne	..kvmppc_handler_hasmagic_\intno
 	/* No KVM guest? Then jump back to the Linux handler! */
-	lwz	r12, (PACA_EXMC + EX_CCR)(r13)
+	lwz	r12, PACA_KVM_SCRATCH1(r13)
 	mtcr	r12
-	ld	r12, (PACA_EXMC + EX_R12)(r13)
+	ld	r12, PACA_KVM_SCRATCH0(r13)
 	mfspr	r13, SPRN_SPRG_SCRATCH0		/* r13 = original r13 */
 	b	kvmppc_resume_\intno		/* Get back original handler */
 
 	/* Now we know we're handling a KVM guest */
 ..kvmppc_handler_hasmagic_\intno:
-	/* Unset guest state */
-	li	r12, 0
-	stb	r12, PACA_KVM_IN_GUEST(r13)
-
-	std	r1, (PACA_EXMC+EX_R9)(r13)
-	std	r10, (PACA_EXMC+EX_R10)(r13)
-	std	r11, (PACA_EXMC+EX_R11)(r13)
-	std	r2, (PACA_EXMC+EX_R13)(r13)
-
-	mfsrr0	r10
-	mfsrr1	r11
-
-	/* Restore R1/R2 so we can handle faults */
-	ld	r1, PACAR1(r13)
-	ld	r2, (PACA_EXMC+EX_SRR0)(r13)
-
 	/* Let's store which interrupt we're handling */
 	li	r12, \intno
 
@@ -106,16 +90,16 @@ INTERRUPT_TRAMPOLINE	BOOK3S_INTERRUPT_VSX
  *
  * Input Registers:
  *
- * R6 = SRR0
- * R7 = SRR1
+ * R5 = SRR0
+ * R6 = SRR1
  * LR = real-mode IP
  *
  */
 .global kvmppc_handler_lowmem_trampoline
 kvmppc_handler_lowmem_trampoline:
 
-	mtsrr0	r6
-	mtsrr1	r7
+	mtsrr0	r5
+	mtsrr1	r6
 	blr
 kvmppc_handler_lowmem_trampoline_end:
 
diff --git a/arch/powerpc/kvm/book3s_64_slb.S b/arch/powerpc/kvm/book3s_64_slb.S
index 8e44788..7188c11 100644
--- a/arch/powerpc/kvm/book3s_64_slb.S
+++ b/arch/powerpc/kvm/book3s_64_slb.S
@@ -51,24 +51,18 @@ kvmppc_handler_trampoline_enter:
 	 *
 	 * MSR = ~IR|DR
 	 * R13 = PACA
+	 * R1 = host R1
+	 * R2 = host R2
 	 * R9 = guest IP
 	 * R10 = guest MSR
-	 * R11 = free
-	 * R12 = free
-	 * PACA[PACA_EXMC + EX_R9] = guest R9
-	 * PACA[PACA_EXMC + EX_R10] = guest R10
-	 * PACA[PACA_EXMC + EX_R11] = guest R11
-	 * PACA[PACA_EXMC + EX_R12] = guest R12
-	 * PACA[PACA_EXMC + EX_R13] = guest R13
-	 * PACA[PACA_EXMC + EX_CCR] = guest CR
-	 * PACA[PACA_EXMC + EX_R3] = guest XER
+	 * all other GPRS = free
+	 * PACA[KVM_CR] = guest CR
+	 * PACA[KVM_XER] = guest XER
 	 */
 
 	mtsrr0	r9
 	mtsrr1	r10
 
-	mtspr	SPRN_SPRG_SCRATCH0, r0
-
 	/* Remove LPAR shadow entries */
 
 #if SLB_NUM_BOLTED == 3
@@ -131,20 +125,27 @@ slb_do_enter:
 
 	/* Enter guest */
 
-	mfspr	r0, SPRN_SPRG_SCRATCH0
-
-	ld	r9, (PACA_EXMC+EX_R9)(r13)
-	ld	r10, (PACA_EXMC+EX_R10)(r13)
-	ld	r12, (PACA_EXMC+EX_R12)(r13)
-
-	lwz	r11, (PACA_EXMC+EX_CCR)(r13)
+	ld	r0, (PACA_KVM_R0)(r13)
+	ld	r1, (PACA_KVM_R1)(r13)
+	ld	r2, (PACA_KVM_R2)(r13)
+	ld	r3, (PACA_KVM_R3)(r13)
+	ld	r4, (PACA_KVM_R4)(r13)
+	ld	r5, (PACA_KVM_R5)(r13)
+	ld	r6, (PACA_KVM_R6)(r13)
+	ld	r7, (PACA_KVM_R7)(r13)
+	ld	r8, (PACA_KVM_R8)(r13)
+	ld	r9, (PACA_KVM_R9)(r13)
+	ld	r10, (PACA_KVM_R10)(r13)
+	ld	r12, (PACA_KVM_R12)(r13)
+
+	lwz	r11, (PACA_KVM_CR)(r13)
 	mtcr	r11
 
-	ld	r11, (PACA_EXMC+EX_R3)(r13)
+	ld	r11, (PACA_KVM_XER)(r13)
 	mtxer	r11
 
-	ld	r11, (PACA_EXMC+EX_R11)(r13)
-	ld	r13, (PACA_EXMC+EX_R13)(r13)
+	ld	r11, (PACA_KVM_R11)(r13)
+	ld	r13, (PACA_KVM_R13)(r13)
 
 	RFI
 kvmppc_handler_trampoline_enter_end:
@@ -162,28 +163,58 @@ kvmppc_handler_trampoline_exit:
 
 	/* Register usage at this point:
 	 *
-	 * SPRG_SCRATCH0 = guest R13
-	 * R01           = host R1
-	 * R02           = host R2
-	 * R10           = guest PC
-	 * R11           = guest MSR
-	 * R12           = exit handler id
-	 * R13           = PACA
-	 * PACA.exmc.CCR  = guest CR
-	 * PACA.exmc.R9  = guest R1
-	 * PACA.exmc.R10 = guest R10
-	 * PACA.exmc.R11 = guest R11
-	 * PACA.exmc.R12 = guest R12
-	 * PACA.exmc.R13 = guest R2
+	 * SPRG_SCRATCH0     = guest R13
+	 * R12               = exit handler id
+	 * R13               = PACA
+	 * PACA.KVM.SCRATCH0 = guest R12
+	 * PACA.KVM.SCRATCH1 = guest CR
 	 *
 	 */
 
 	/* Save registers */
 
-	std	r0, (PACA_EXMC+EX_SRR0)(r13)
-	std	r9, (PACA_EXMC+EX_R3)(r13)
-	std	r10, (PACA_EXMC+EX_LR)(r13)
-	std	r11, (PACA_EXMC+EX_DAR)(r13)
+	std	r0, PACA_KVM_R0(r13)
+	std	r1, PACA_KVM_R1(r13)
+	std	r2, PACA_KVM_R2(r13)
+	std	r3, PACA_KVM_R3(r13)
+	std	r4, PACA_KVM_R4(r13)
+	std	r5, PACA_KVM_R5(r13)
+	std	r6, PACA_KVM_R6(r13)
+	std	r7, PACA_KVM_R7(r13)
+	std	r8, PACA_KVM_R8(r13)
+	std	r9, PACA_KVM_R9(r13)
+	std	r10, PACA_KVM_R10(r13)
+	std	r11, PACA_KVM_R11(r13)
+
+	/* Restore R1/R2 so we can handle faults */
+	ld	r1, PACA_KVM_HOST_R1(r13)
+	ld	r2, PACA_KVM_HOST_R2(r13)
+
+	/* Save guest PC and MSR in GPRs */
+	mfsrr0	r3
+	mfsrr1	r4
+
+	/* Get scratch'ed off registers */
+	mfspr	r9, SPRN_SPRG_SCRATCH0
+	std	r9, PACA_KVM_R13(r13)
+
+	ld	r8, PACA_KVM_SCRATCH0(r13)
+	std	r8, PACA_KVM_R12(r13)
+
+	lwz	r7, PACA_KVM_SCRATCH1(r13)
+	stw	r7, PACA_KVM_CR(r13)
+
+	/* Save more register state  */
+
+	mfxer	r6
+	stw	r6, PACA_KVM_XER(r13)
+
+	mfdar	r5
+	mfdsisr	r6
+
+	/* Unset guest state */
+	li	r9, 0
+	stb	r9, PACA_KVM_IN_GUEST(r13)
 
 	/*
 	 * In order for us to easily get the last instruction,
@@ -207,7 +238,8 @@ ld_last_inst:
 	ori	r11, r9, MSR_DR			/* Enable paging for data */
 	mtmsr	r11
 	/*    2) fetch the instruction */
-	lwz	r0, 0(r10)
+	/* XXX implement PACA_KVM_IN_GUEST=2 path to safely jump over this */
+	lwz	r0, 0(r3)
 	/*    3) disable paging again */
 	mtmsr	r9
 
@@ -233,29 +265,27 @@ no_ld_last_inst:
 
 slb_do_exit:
 
-	/* Restore registers */
-
-	ld	r11, (PACA_EXMC+EX_DAR)(r13)
-	ld	r10, (PACA_EXMC+EX_LR)(r13)
-	ld	r9, (PACA_EXMC+EX_R3)(r13)
-
-	/* Save last inst */
-	stw	r0, (PACA_EXMC+EX_LR)(r13)
-
-	/* Save DAR and DSISR before going to paged mode */
-	mfdar	r0
-	std	r0, (PACA_EXMC+EX_DAR)(r13)
-	mfdsisr	r0
-	stw	r0, (PACA_EXMC+EX_DSISR)(r13)
+	/* Register usage at this point:
+	 *
+	 * R0         = guest last inst
+	 * R1         = host R1
+	 * R2         = host R2
+	 * R3         = guest PC
+	 * R4         = guest MSR
+	 * R5         = guest DAR
+	 * R6         = guest DSISR
+	 * R12        = exit handler id
+	 * R13        = PACA
+	 * PACA.KVM.* = guest *
+	 *
+	 */
 
 	/* RFI into the highmem handler */
-	mfmsr	r0
-	ori	r0, r0, MSR_IR|MSR_DR|MSR_RI	/* Enable paging */
-	mtsrr1	r0
-	ld	r0, PACASAVEDMSR(r13)		/* Highmem handler address */
-	mtsrr0	r0
-
-	mfspr	r0, SPRN_SPRG_SCRATCH0
+	mfmsr	r7
+	ori	r7, r7, MSR_IR|MSR_DR|MSR_RI	/* Enable paging */
+	mtsrr1	r7
+	ld	r8, PACA_KVM_VMHANDLER(r13)	/* Highmem handler address */
+	mtsrr0	r8
 
 	RFI
 kvmppc_handler_trampoline_exit_end:
-- 
1.6.5.3

