Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757644Ab0BMIKw (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Feb 2010 03:10:52 -0500
Received: from mx1.redhat.com ([209.132.183.28]:33259 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752288Ab0BMICD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Feb 2010 03:02:03 -0500
From: Avi Kivity <avi@redhat.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 11/39] KVM: PPC: Call SLB patching code in interrupt safe manner
Date: Sat, 13 Feb 2010 10:01:31 +0200
Message-Id: <1266048119-14325-12-git-send-email-avi@redhat.com>
In-Reply-To: <1266048119-14325-1-git-send-email-avi@redhat.com>
References: <1266048119-14325-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alexander Graf <agraf@suse.de>

Currently we're racy when doing the transition from IR=1 to IR=0, from
the module memory entry code to the real mode SLB switching code.

To work around that I took a look at the RTAS entry code which is faced
with a similar problem and did the same thing:

  A small helper in linear mapped memory that does mtmsr with IR=0 and
  then RFIs info the actual handler.

Thanks to that trick we can safely take page faults in the entry code
and only need to be really wary of what to do as of the SLB switching
part.

Signed-off-by: Alexander Graf <agraf@suse.de>
Signed-off-by: Avi Kivity <avi@redhat.com>
---
 arch/powerpc/include/asm/kvm_book3s.h        |    1 +
 arch/powerpc/include/asm/kvm_book3s_64_asm.h |    1 -
 arch/powerpc/include/asm/kvm_host.h          |    1 +
 arch/powerpc/kernel/asm-offsets.c            |    3 +--
 arch/powerpc/kvm/book3s.c                    |    1 +
 arch/powerpc/kvm/book3s_64_exports.c         |    1 +
 arch/powerpc/kvm/book3s_64_interrupts.S      |   25 +++++++------------------
 arch/powerpc/kvm/book3s_64_rmhandlers.S      |   18 ++++++++++++++++++
 arch/powerpc/kvm/book3s_64_slb.S             |    4 ++++
 9 files changed, 34 insertions(+), 21 deletions(-)

diff --git a/arch/powerpc/include/asm/kvm_book3s.h b/arch/powerpc/include/asm/kvm_book3s.h
index f192017..c91be0f 100644
--- a/arch/powerpc/include/asm/kvm_book3s.h
+++ b/arch/powerpc/include/asm/kvm_book3s.h
@@ -121,6 +121,7 @@ extern void kvmppc_set_bat(struct kvm_vcpu *vcpu, struct kvmppc_bat *bat,
 
 extern u32 kvmppc_trampoline_lowmem;
 extern u32 kvmppc_trampoline_enter;
+extern void kvmppc_rmcall(ulong srr0, ulong srr1);
 
 static inline struct kvmppc_vcpu_book3s *to_book3s(struct kvm_vcpu *vcpu)
 {
diff --git a/arch/powerpc/include/asm/kvm_book3s_64_asm.h b/arch/powerpc/include/asm/kvm_book3s_64_asm.h
index fca9404..183461b 100644
--- a/arch/powerpc/include/asm/kvm_book3s_64_asm.h
+++ b/arch/powerpc/include/asm/kvm_book3s_64_asm.h
@@ -69,7 +69,6 @@ struct kvmppc_book3s_shadow_vcpu {
 	ulong scratch0;
 	ulong scratch1;
 	ulong vmhandler;
-	ulong rmhandler;
 };
 
 #endif /*__ASSEMBLY__ */
diff --git a/arch/powerpc/include/asm/kvm_host.h b/arch/powerpc/include/asm/kvm_host.h
index d615fa8..f7215e6 100644
--- a/arch/powerpc/include/asm/kvm_host.h
+++ b/arch/powerpc/include/asm/kvm_host.h
@@ -167,6 +167,7 @@ struct kvm_vcpu_arch {
 	ulong trampoline_lowmem;
 	ulong trampoline_enter;
 	ulong highmem_handler;
+	ulong rmcall;
 	ulong host_paca_phys;
 	struct kvmppc_mmu mmu;
 #endif
diff --git a/arch/powerpc/kernel/asm-offsets.c b/arch/powerpc/kernel/asm-offsets.c
index 1501e77..ee99354 100644
--- a/arch/powerpc/kernel/asm-offsets.c
+++ b/arch/powerpc/kernel/asm-offsets.c
@@ -214,8 +214,6 @@ int main(void)
 	DEFINE(PACA_KVM_HOST_R2, offsetof(struct paca_struct, shadow_vcpu.host_r2));
 	DEFINE(PACA_KVM_VMHANDLER, offsetof(struct paca_struct,
 					    shadow_vcpu.vmhandler));
-	DEFINE(PACA_KVM_RMHANDLER, offsetof(struct paca_struct,
-					    shadow_vcpu.rmhandler));
 	DEFINE(PACA_KVM_SCRATCH0, offsetof(struct paca_struct,
 					   shadow_vcpu.scratch0));
 	DEFINE(PACA_KVM_SCRATCH1, offsetof(struct paca_struct,
@@ -438,6 +436,7 @@ int main(void)
 	DEFINE(VCPU_TRAMPOLINE_LOWMEM, offsetof(struct kvm_vcpu, arch.trampoline_lowmem));
 	DEFINE(VCPU_TRAMPOLINE_ENTER, offsetof(struct kvm_vcpu, arch.trampoline_enter));
 	DEFINE(VCPU_HIGHMEM_HANDLER, offsetof(struct kvm_vcpu, arch.highmem_handler));
+	DEFINE(VCPU_RMCALL, offsetof(struct kvm_vcpu, arch.rmcall));
 	DEFINE(VCPU_HFLAGS, offsetof(struct kvm_vcpu, arch.hflags));
 #else
 	DEFINE(VCPU_CR, offsetof(struct kvm_vcpu, arch.cr));
diff --git a/arch/powerpc/kvm/book3s.c b/arch/powerpc/kvm/book3s.c
index 3e06eae..1317392 100644
--- a/arch/powerpc/kvm/book3s.c
+++ b/arch/powerpc/kvm/book3s.c
@@ -919,6 +919,7 @@ struct kvm_vcpu *kvmppc_core_vcpu_create(struct kvm *kvm, unsigned int id)
 	vcpu->arch.trampoline_lowmem = kvmppc_trampoline_lowmem;
 	vcpu->arch.trampoline_enter = kvmppc_trampoline_enter;
 	vcpu->arch.highmem_handler = (ulong)kvmppc_handler_highmem;
+	vcpu->arch.rmcall = *(ulong*)kvmppc_rmcall;
 
 	vcpu->arch.shadow_msr = MSR_USER64;
 
diff --git a/arch/powerpc/kvm/book3s_64_exports.c b/arch/powerpc/kvm/book3s_64_exports.c
index 5b2db38..99b0712 100644
--- a/arch/powerpc/kvm/book3s_64_exports.c
+++ b/arch/powerpc/kvm/book3s_64_exports.c
@@ -22,3 +22,4 @@
 
 EXPORT_SYMBOL_GPL(kvmppc_trampoline_enter);
 EXPORT_SYMBOL_GPL(kvmppc_trampoline_lowmem);
+EXPORT_SYMBOL_GPL(kvmppc_rmcall);
diff --git a/arch/powerpc/kvm/book3s_64_interrupts.S b/arch/powerpc/kvm/book3s_64_interrupts.S
index 3c0ba55..33aef53 100644
--- a/arch/powerpc/kvm/book3s_64_interrupts.S
+++ b/arch/powerpc/kvm/book3s_64_interrupts.S
@@ -95,17 +95,14 @@ kvm_start_entry:
 	ld	r3, VCPU_HIGHMEM_HANDLER(r4)
 	std	r3, PACA_KVM_VMHANDLER(r13)
 
-	ld	r3, VCPU_TRAMPOLINE_ENTER(r4)
-	std	r3, PACA_KVM_RMHANDLER(r13)
-
 kvm_start_lightweight:
 
 	ld	r9, VCPU_PC(r4)			/* r9 = vcpu->arch.pc */
 	ld	r10, VCPU_SHADOW_MSR(r4)	/* r10 = vcpu->arch.shadow_msr */
 
 	/* Load some guest state in the respective registers */
-	ld	r3, VCPU_CTR(r4)	/* r3 = vcpu->arch.ctr */
-	mtctr	r3			/* CTR = r3 */
+	ld	r5, VCPU_CTR(r4)	/* r5 = vcpu->arch.ctr */
+					/* will be swapped in by rmcall */
 
 	ld	r3, VCPU_LR(r4)		/* r3 = vcpu->arch.lr */
 	mtlr	r3			/* LR = r3 */
@@ -131,22 +128,14 @@ kvm_start_lightweight:
 
 no_dcbz32_on:
 
-	/* This sets the Magic value for the trampoline */
-
-	/* XXX this needs to move into a safe function, so we can
-	   be sure we don't get any interrupts */
-
-	li	r11, 1
-	stb	r11, PACA_KVM_IN_GUEST(r13)
-
-	ld	r3, PACA_KVM_RMHANDLER(r13)
-	mtsrr0	r3
+	ld	r6, VCPU_RMCALL(r4)
+	mtctr	r6
 
-	LOAD_REG_IMMEDIATE(r3, MSR_KERNEL & ~(MSR_IR | MSR_DR))
-	mtsrr1	r3
+	ld	r3, VCPU_TRAMPOLINE_ENTER(r4)
+	LOAD_REG_IMMEDIATE(r4, MSR_KERNEL & ~(MSR_IR | MSR_DR))
 
 	/* Jump to SLB patching handlder and into our guest */
-	RFI
+	bctr
 
 /*
  * This is the handler in module memory. It gets jumped at from the
diff --git a/arch/powerpc/kvm/book3s_64_rmhandlers.S b/arch/powerpc/kvm/book3s_64_rmhandlers.S
index 9ad1c26..e7091c9 100644
--- a/arch/powerpc/kvm/book3s_64_rmhandlers.S
+++ b/arch/powerpc/kvm/book3s_64_rmhandlers.S
@@ -140,6 +140,24 @@ kvmppc_handler_lowmem_trampoline:
 	blr
 kvmppc_handler_lowmem_trampoline_end:
 
+/*
+ * Call a function in real mode
+ *
+ * Input Registers:
+ *
+ * R3 = function
+ * R4 = MSR
+ * R5 = CTR
+ *
+ */
+_GLOBAL(kvmppc_rmcall)
+	mtmsr	r4		/* Disable relocation, so mtsrr
+				   doesn't get interrupted */
+	mtctr	r5
+	mtsrr0	r3
+	mtsrr1	r4
+	RFI
+
 .global kvmppc_trampoline_lowmem
 kvmppc_trampoline_lowmem:
 	.long kvmppc_handler_lowmem_trampoline - _stext
diff --git a/arch/powerpc/kvm/book3s_64_slb.S b/arch/powerpc/kvm/book3s_64_slb.S
index d07b886..35b7627 100644
--- a/arch/powerpc/kvm/book3s_64_slb.S
+++ b/arch/powerpc/kvm/book3s_64_slb.S
@@ -63,6 +63,10 @@ kvmppc_handler_trampoline_enter:
 	mtsrr0	r9
 	mtsrr1	r10
 
+	/* Activate guest mode, so faults get handled by KVM */
+	li	r11, KVM_GUEST_MODE_GUEST
+	stb	r11, PACA_KVM_IN_GUEST(r13)
+
 	/* Remove LPAR shadow entries */
 
 #if SLB_NUM_BOLTED == 3
-- 
1.6.5.3

