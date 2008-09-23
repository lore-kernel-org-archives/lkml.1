Return-Path: <linux-kernel-owner+w=401wt.eu-S1757465AbYIWOBS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757465AbYIWOBS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2008 10:01:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754340AbYIWNxY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Sep 2008 09:53:24 -0400
Received: from mx2.redhat.com ([66.187.237.31]:43598 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751716AbYIWNxW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2008 09:53:22 -0400
From: Avi Kivity <avi@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: kvm@vger.kernel.org, Hollis Blanchard <hollisb@us.ibm.com>
Subject: [PATCH 29/40] KVM: powerpc: Map guest userspace with TID=0 mappings
Date: Tue, 23 Sep 2008 16:46:43 +0300
Message-Id: <1222177614-26669-30-git-send-email-avi@redhat.com>
In-Reply-To: <1222177614-26669-1-git-send-email-avi@redhat.com>
References: <1222177614-26669-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Hollis Blanchard <hollisb@us.ibm.com>

When we use TID=N userspace mappings, we must ensure that kernel mappings have
been destroyed when entering userspace. Using TID=1/TID=0 for kernel/user
mappings and running userspace with PID=0 means that userspace can't access the
kernel mappings, but the kernel can directly access userspace.

The net is that we don't need to flush the TLB on privilege switches, but we do
on guest context switches (which are far more infrequent). Guest boot time
performance improvement: about 30%.

Signed-off-by: Hollis Blanchard <hollisb@us.ibm.com>
Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 arch/powerpc/include/asm/kvm_host.h |    4 +++
 arch/powerpc/include/asm/kvm_ppc.h  |    9 ++++++++
 arch/powerpc/kernel/asm-offsets.c   |    2 +-
 arch/powerpc/kvm/44x_tlb.c          |   39 ++++++++++++++++++++--------------
 arch/powerpc/kvm/booke_guest.c      |    2 +
 arch/powerpc/kvm/booke_interrupts.S |    2 +-
 arch/powerpc/kvm/emulate.c          |    2 +-
 7 files changed, 41 insertions(+), 19 deletions(-)

diff --git a/arch/powerpc/include/asm/kvm_host.h b/arch/powerpc/include/asm/kvm_host.h
index 4338b03..34b52b7 100644
--- a/arch/powerpc/include/asm/kvm_host.h
+++ b/arch/powerpc/include/asm/kvm_host.h
@@ -129,7 +129,11 @@ struct kvm_vcpu_arch {
 	u32 ivor[16];
 	u32 ivpr;
 	u32 pir;
+
+	u32 shadow_pid;
 	u32 pid;
+	u32 swap_pid;
+
 	u32 pvr;
 	u32 ccr0;
 	u32 ccr1;
diff --git a/arch/powerpc/include/asm/kvm_ppc.h b/arch/powerpc/include/asm/kvm_ppc.h
index 8e7e429..8931ba7 100644
--- a/arch/powerpc/include/asm/kvm_ppc.h
+++ b/arch/powerpc/include/asm/kvm_ppc.h
@@ -64,6 +64,7 @@ extern void kvmppc_mmu_map(struct kvm_vcpu *vcpu, u64 gvaddr, gfn_t gfn,
 extern void kvmppc_mmu_invalidate(struct kvm_vcpu *vcpu, gva_t eaddr,
                                   gva_t eend, u32 asid);
 extern void kvmppc_mmu_priv_switch(struct kvm_vcpu *vcpu, int usermode);
+extern void kvmppc_mmu_switch_pid(struct kvm_vcpu *vcpu, u32 pid);
 
 /* XXX Book E specific */
 extern void kvmppc_tlbe_set_modified(struct kvm_vcpu *vcpu, unsigned int i);
@@ -95,4 +96,12 @@ static inline void kvmppc_set_msr(struct kvm_vcpu *vcpu, u32 new_msr)
 		kvm_vcpu_block(vcpu);
 }
 
+static inline void kvmppc_set_pid(struct kvm_vcpu *vcpu, u32 new_pid)
+{
+	if (vcpu->arch.pid != new_pid) {
+		vcpu->arch.pid = new_pid;
+		vcpu->arch.swap_pid = 1;
+	}
+}
+
 #endif /* __POWERPC_KVM_PPC_H__ */
diff --git a/arch/powerpc/kernel/asm-offsets.c b/arch/powerpc/kernel/asm-offsets.c
index 1631d67..52649da 100644
--- a/arch/powerpc/kernel/asm-offsets.c
+++ b/arch/powerpc/kernel/asm-offsets.c
@@ -369,7 +369,7 @@ int main(void)
 	DEFINE(VCPU_SPRG5, offsetof(struct kvm_vcpu, arch.sprg5));
 	DEFINE(VCPU_SPRG6, offsetof(struct kvm_vcpu, arch.sprg6));
 	DEFINE(VCPU_SPRG7, offsetof(struct kvm_vcpu, arch.sprg7));
-	DEFINE(VCPU_PID, offsetof(struct kvm_vcpu, arch.pid));
+	DEFINE(VCPU_SHADOW_PID, offsetof(struct kvm_vcpu, arch.shadow_pid));
 
 	DEFINE(VCPU_LAST_INST, offsetof(struct kvm_vcpu, arch.last_inst));
 	DEFINE(VCPU_FAULT_DEAR, offsetof(struct kvm_vcpu, arch.fault_dear));
diff --git a/arch/powerpc/kvm/44x_tlb.c b/arch/powerpc/kvm/44x_tlb.c
index 06a5fcf..3594bbd 100644
--- a/arch/powerpc/kvm/44x_tlb.c
+++ b/arch/powerpc/kvm/44x_tlb.c
@@ -170,7 +170,7 @@ void kvmppc_mmu_map(struct kvm_vcpu *vcpu, u64 gvaddr, gfn_t gfn, u64 asid,
 
 	/* XXX what about AS? */
 
-	stlbe->tid = asid & 0xff;
+	stlbe->tid = !(asid & 0xff);
 
 	/* Force TS=1 for all guest mappings. */
 	/* For now we hardcode 4KB mappings, but it will be important to
@@ -190,7 +190,7 @@ void kvmppc_mmu_map(struct kvm_vcpu *vcpu, u64 gvaddr, gfn_t gfn, u64 asid,
 void kvmppc_mmu_invalidate(struct kvm_vcpu *vcpu, gva_t eaddr,
                            gva_t eend, u32 asid)
 {
-	unsigned int pid = asid & 0xff;
+	unsigned int pid = !(asid & 0xff);
 	int i;
 
 	/* XXX Replace loop with fancy data structures. */
@@ -222,23 +222,30 @@ void kvmppc_mmu_invalidate(struct kvm_vcpu *vcpu, gva_t eaddr,
 	up_write(&current->mm->mmap_sem);
 }
 
-/* Invalidate all mappings, so that when they fault back in they will get the
- * proper permission bits. */
+/* Invalidate all mappings on the privilege switch after PID has been changed.
+ * The guest always runs with PID=1, so we must clear the entire TLB when
+ * switching address spaces. */
 void kvmppc_mmu_priv_switch(struct kvm_vcpu *vcpu, int usermode)
 {
 	int i;
 
-	/* XXX Replace loop with fancy data structures. */
-	down_write(&current->mm->mmap_sem);
-	for (i = 0; i <= tlb_44x_hwater; i++) {
-		struct tlbe *stlbe = &vcpu->arch.shadow_tlb[i];
-
-		kvmppc_44x_shadow_release(vcpu, i);
-		stlbe->word0 = 0;
-		kvmppc_tlbe_set_modified(vcpu, i);
-		KVMTRACE_5D(STLB_INVAL, vcpu, i,
-				stlbe->tid, stlbe->word0, stlbe->word1,
-				stlbe->word2, handler);
+	if (vcpu->arch.swap_pid) {
+		/* XXX Replace loop with fancy data structures. */
+		down_write(&current->mm->mmap_sem);
+		for (i = 0; i <= tlb_44x_hwater; i++) {
+			struct tlbe *stlbe = &vcpu->arch.shadow_tlb[i];
+
+			/* Future optimization: clear only userspace mappings. */
+			kvmppc_44x_shadow_release(vcpu, i);
+			stlbe->word0 = 0;
+			kvmppc_tlbe_set_modified(vcpu, i);
+			KVMTRACE_5D(STLB_INVAL, vcpu, i,
+			            stlbe->tid, stlbe->word0, stlbe->word1,
+			            stlbe->word2, handler);
+		}
+		up_write(&current->mm->mmap_sem);
+		vcpu->arch.swap_pid = 0;
 	}
-	up_write(&current->mm->mmap_sem);
+
+	vcpu->arch.shadow_pid = !usermode;
 }
diff --git a/arch/powerpc/kvm/booke_guest.c b/arch/powerpc/kvm/booke_guest.c
index 3cca079..7b2591e 100644
--- a/arch/powerpc/kvm/booke_guest.c
+++ b/arch/powerpc/kvm/booke_guest.c
@@ -486,6 +486,8 @@ int kvm_arch_vcpu_setup(struct kvm_vcpu *vcpu)
 	vcpu->arch.msr = 0;
 	vcpu->arch.gpr[1] = (16<<20) - 8; /* -8 for the callee-save LR slot */
 
+	vcpu->arch.shadow_pid = 1;
+
 	/* Eye-catching number so we know if the guest takes an interrupt
 	 * before it's programmed its own IVPR. */
 	vcpu->arch.ivpr = 0x55550000;
diff --git a/arch/powerpc/kvm/booke_interrupts.S b/arch/powerpc/kvm/booke_interrupts.S
index 564ea32..95e165b 100644
--- a/arch/powerpc/kvm/booke_interrupts.S
+++ b/arch/powerpc/kvm/booke_interrupts.S
@@ -332,7 +332,7 @@ lightweight_exit:
 
 	mfspr	r3, SPRN_PID
 	stw	r3, VCPU_HOST_PID(r4)
-	lwz	r3, VCPU_PID(r4)
+	lwz	r3, VCPU_SHADOW_PID(r4)
 	mtspr	SPRN_PID, r3
 
 	/* Prevent all asynchronous TLB updates. */
diff --git a/arch/powerpc/kvm/emulate.c b/arch/powerpc/kvm/emulate.c
index c3ed63b..0fce4fb 100644
--- a/arch/powerpc/kvm/emulate.c
+++ b/arch/powerpc/kvm/emulate.c
@@ -508,7 +508,7 @@ int kvmppc_emulate_instruction(struct kvm_run *run, struct kvm_vcpu *vcpu)
 			case SPRN_MMUCR:
 				vcpu->arch.mmucr = vcpu->arch.gpr[rs]; break;
 			case SPRN_PID:
-				vcpu->arch.pid = vcpu->arch.gpr[rs]; break;
+				kvmppc_set_pid(vcpu, vcpu->arch.gpr[rs]); break;
 			case SPRN_CCR0:
 				vcpu->arch.ccr0 = vcpu->arch.gpr[rs]; break;
 			case SPRN_CCR1:
-- 
1.6.0.1

