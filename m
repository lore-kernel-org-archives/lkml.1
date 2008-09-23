Return-Path: <linux-kernel-owner+w=401wt.eu-S1756089AbYIWNyy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756089AbYIWNyy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2008 09:54:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753861AbYIWNrz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Sep 2008 09:47:55 -0400
Received: from mx2.redhat.com ([66.187.237.31]:52423 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753742AbYIWNrr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2008 09:47:47 -0400
From: Avi Kivity <avi@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: kvm@vger.kernel.org, Hollis Blanchard <hollisb@us.ibm.com>
Subject: [PATCH 28/40] KVM: ppc: Write only modified shadow entries into the TLB on exit
Date: Tue, 23 Sep 2008 16:46:42 +0300
Message-Id: <1222177614-26669-29-git-send-email-avi@redhat.com>
In-Reply-To: <1222177614-26669-1-git-send-email-avi@redhat.com>
References: <1222177614-26669-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Hollis Blanchard <hollisb@us.ibm.com>

Track which TLB entries need to be written, instead of overwriting everything
below the high water mark. Typically only a single guest TLB entry will be
modified in a single exit.

Guest boot time performance improvement: about 15%.

Signed-off-by: Hollis Blanchard <hollisb@us.ibm.com>
Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 arch/powerpc/include/asm/kvm_host.h |    3 ++
 arch/powerpc/include/asm/kvm_ppc.h  |    3 ++
 arch/powerpc/kernel/asm-offsets.c   |    1 +
 arch/powerpc/kvm/44x_tlb.c          |    9 +++++-
 arch/powerpc/kvm/booke_interrupts.S |   51 +++++++++++++++++++++++-----------
 arch/powerpc/kvm/powerpc.c          |   15 ++++++++++
 6 files changed, 64 insertions(+), 18 deletions(-)

diff --git a/arch/powerpc/include/asm/kvm_host.h b/arch/powerpc/include/asm/kvm_host.h
index dc3a756..4338b03 100644
--- a/arch/powerpc/include/asm/kvm_host.h
+++ b/arch/powerpc/include/asm/kvm_host.h
@@ -82,6 +82,9 @@ struct kvm_vcpu_arch {
 	/* Pages which are referenced in the shadow TLB. */
 	struct page *shadow_pages[PPC44x_TLB_SIZE];
 
+	/* Track which TLB entries we've modified in the current exit. */
+	u8 shadow_tlb_mod[PPC44x_TLB_SIZE];
+
 	u32 host_stack;
 	u32 host_pid;
 	u32 host_dbcr0;
diff --git a/arch/powerpc/include/asm/kvm_ppc.h b/arch/powerpc/include/asm/kvm_ppc.h
index a8b0687..8e7e429 100644
--- a/arch/powerpc/include/asm/kvm_ppc.h
+++ b/arch/powerpc/include/asm/kvm_ppc.h
@@ -65,6 +65,9 @@ extern void kvmppc_mmu_invalidate(struct kvm_vcpu *vcpu, gva_t eaddr,
                                   gva_t eend, u32 asid);
 extern void kvmppc_mmu_priv_switch(struct kvm_vcpu *vcpu, int usermode);
 
+/* XXX Book E specific */
+extern void kvmppc_tlbe_set_modified(struct kvm_vcpu *vcpu, unsigned int i);
+
 extern void kvmppc_check_and_deliver_interrupts(struct kvm_vcpu *vcpu);
 
 static inline void kvmppc_queue_exception(struct kvm_vcpu *vcpu, int exception)
diff --git a/arch/powerpc/kernel/asm-offsets.c b/arch/powerpc/kernel/asm-offsets.c
index 5940649..1631d67 100644
--- a/arch/powerpc/kernel/asm-offsets.c
+++ b/arch/powerpc/kernel/asm-offsets.c
@@ -357,6 +357,7 @@ int main(void)
 	DEFINE(VCPU_HOST_STACK, offsetof(struct kvm_vcpu, arch.host_stack));
 	DEFINE(VCPU_HOST_PID, offsetof(struct kvm_vcpu, arch.host_pid));
 	DEFINE(VCPU_SHADOW_TLB, offsetof(struct kvm_vcpu, arch.shadow_tlb));
+	DEFINE(VCPU_SHADOW_MOD, offsetof(struct kvm_vcpu, arch.shadow_tlb_mod));
 	DEFINE(VCPU_GPRS, offsetof(struct kvm_vcpu, arch.gpr));
 	DEFINE(VCPU_LR, offsetof(struct kvm_vcpu, arch.lr));
 	DEFINE(VCPU_CR, offsetof(struct kvm_vcpu, arch.cr));
diff --git a/arch/powerpc/kvm/44x_tlb.c b/arch/powerpc/kvm/44x_tlb.c
index a207d16..06a5fcf 100644
--- a/arch/powerpc/kvm/44x_tlb.c
+++ b/arch/powerpc/kvm/44x_tlb.c
@@ -125,6 +125,11 @@ static void kvmppc_44x_shadow_release(struct kvm_vcpu *vcpu,
 	}
 }
 
+void kvmppc_tlbe_set_modified(struct kvm_vcpu *vcpu, unsigned int i)
+{
+    vcpu->arch.shadow_tlb_mod[i] = 1;
+}
+
 /* Caller must ensure that the specified guest TLB entry is safe to insert into
  * the shadow TLB. */
 void kvmppc_mmu_map(struct kvm_vcpu *vcpu, u64 gvaddr, gfn_t gfn, u64 asid,
@@ -172,10 +177,10 @@ void kvmppc_mmu_map(struct kvm_vcpu *vcpu, u64 gvaddr, gfn_t gfn, u64 asid,
 	 * use host large pages in the future. */
 	stlbe->word0 = (gvaddr & PAGE_MASK) | PPC44x_TLB_VALID | PPC44x_TLB_TS
 	               | PPC44x_TLB_4K;
-
 	stlbe->word1 = (hpaddr & 0xfffffc00) | ((hpaddr >> 32) & 0xf);
 	stlbe->word2 = kvmppc_44x_tlb_shadow_attrib(flags,
 	                                            vcpu->arch.msr & MSR_PR);
+	kvmppc_tlbe_set_modified(vcpu, victim);
 
 	KVMTRACE_5D(STLB_WRITE, vcpu, victim,
 			stlbe->tid, stlbe->word0, stlbe->word1, stlbe->word2,
@@ -209,6 +214,7 @@ void kvmppc_mmu_invalidate(struct kvm_vcpu *vcpu, gva_t eaddr,
 
 		kvmppc_44x_shadow_release(vcpu, i);
 		stlbe->word0 = 0;
+		kvmppc_tlbe_set_modified(vcpu, i);
 		KVMTRACE_5D(STLB_INVAL, vcpu, i,
 				stlbe->tid, stlbe->word0, stlbe->word1,
 				stlbe->word2, handler);
@@ -229,6 +235,7 @@ void kvmppc_mmu_priv_switch(struct kvm_vcpu *vcpu, int usermode)
 
 		kvmppc_44x_shadow_release(vcpu, i);
 		stlbe->word0 = 0;
+		kvmppc_tlbe_set_modified(vcpu, i);
 		KVMTRACE_5D(STLB_INVAL, vcpu, i,
 				stlbe->tid, stlbe->word0, stlbe->word1,
 				stlbe->word2, handler);
diff --git a/arch/powerpc/kvm/booke_interrupts.S b/arch/powerpc/kvm/booke_interrupts.S
index 3e88dfa..564ea32 100644
--- a/arch/powerpc/kvm/booke_interrupts.S
+++ b/arch/powerpc/kvm/booke_interrupts.S
@@ -335,7 +335,7 @@ lightweight_exit:
 	lwz	r3, VCPU_PID(r4)
 	mtspr	SPRN_PID, r3
 
-	/* Prevent all TLB updates. */
+	/* Prevent all asynchronous TLB updates. */
 	mfmsr	r5
 	lis	r6, (MSR_EE|MSR_CE|MSR_ME|MSR_DE)@h
 	ori	r6, r6, (MSR_EE|MSR_CE|MSR_ME|MSR_DE)@l
@@ -344,28 +344,45 @@ lightweight_exit:
 
 	/* Load the guest mappings, leaving the host's "pinned" kernel mappings
 	 * in place. */
-	/* XXX optimization: load only modified guest entries. */
 	mfspr	r10, SPRN_MMUCR			/* Save host MMUCR. */
-	lis	r8, tlb_44x_hwater@ha
-	lwz	r8, tlb_44x_hwater@l(r8)
-	addi	r9, r4, VCPU_SHADOW_TLB - 4
-	li	r6, 0
+	li	r5, PPC44x_TLB_SIZE
+	lis	r5, tlb_44x_hwater@ha
+	lwz	r5, tlb_44x_hwater@l(r5)
+	mtctr	r5
+	addi	r9, r4, VCPU_SHADOW_TLB
+	addi	r5, r4, VCPU_SHADOW_MOD
+	li	r3, 0
 1:
+	lbzx	r7, r3, r5
+	cmpwi	r7, 0
+	beq	3f
+
 	/* Load guest entry. */
-	lwzu	r7, 4(r9)
+	mulli	r11, r3, TLBE_BYTES
+	add	r11, r11, r9
+	lwz	r7, 0(r11)
 	mtspr	SPRN_MMUCR, r7
-	lwzu	r7, 4(r9)
-	tlbwe	r7, r6, PPC44x_TLB_PAGEID
-	lwzu	r7, 4(r9)
-	tlbwe	r7, r6, PPC44x_TLB_XLAT
-	lwzu	r7, 4(r9)
-	tlbwe	r7, r6, PPC44x_TLB_ATTRIB
-	/* Increment index. */
-	addi	r6, r6, 1
-	cmpw	r6, r8
-	blt	1b
+	lwz	r7, 4(r11)
+	tlbwe	r7, r3, PPC44x_TLB_PAGEID
+	lwz	r7, 8(r11)
+	tlbwe	r7, r3, PPC44x_TLB_XLAT
+	lwz	r7, 12(r11)
+	tlbwe	r7, r3, PPC44x_TLB_ATTRIB
+3:
+	addi	r3, r3, 1                       /* Increment index. */
+	bdnz	1b
+
 	mtspr	SPRN_MMUCR, r10			/* Restore host MMUCR. */
 
+	/* Clear bitmap of modified TLB entries */
+	li	r5, PPC44x_TLB_SIZE>>2
+	mtctr	r5
+	addi	r5, r4, VCPU_SHADOW_MOD - 4
+	li	r6, 0
+1:
+	stwu	r6, 4(r5)
+	bdnz	1b
+
 	iccci	0, 0 /* XXX hack */
 
 	/* Load some guest volatiles. */
diff --git a/arch/powerpc/kvm/powerpc.c b/arch/powerpc/kvm/powerpc.c
index b756071..90a6fc4 100644
--- a/arch/powerpc/kvm/powerpc.c
+++ b/arch/powerpc/kvm/powerpc.c
@@ -27,6 +27,7 @@
 #include <asm/cputable.h>
 #include <asm/uaccess.h>
 #include <asm/kvm_ppc.h>
+#include <asm/tlbflush.h>
 
 
 gfn_t unalias_gfn(struct kvm *kvm, gfn_t gfn)
@@ -307,14 +308,28 @@ static void kvmppc_load_guest_debug_registers(struct kvm_vcpu *vcpu)
 
 void kvm_arch_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
 {
+	int i;
+
 	if (vcpu->guest_debug.enabled)
 		kvmppc_load_guest_debug_registers(vcpu);
+
+	/* Mark every guest entry in the shadow TLB entry modified, so that they
+	 * will all be reloaded on the next vcpu run (instead of being
+	 * demand-faulted). */
+	for (i = 0; i <= tlb_44x_hwater; i++)
+		kvmppc_tlbe_set_modified(vcpu, i);
 }
 
 void kvm_arch_vcpu_put(struct kvm_vcpu *vcpu)
 {
 	if (vcpu->guest_debug.enabled)
 		kvmppc_restore_host_debug_state(vcpu);
+
+	/* Don't leave guest TLB entries resident when being de-scheduled. */
+	/* XXX It would be nice to differentiate between heavyweight exit and
+	 * sched_out here, since we could avoid the TLB flush for heavyweight
+	 * exits. */
+	_tlbia();
 }
 
 int kvm_arch_vcpu_ioctl_debug_guest(struct kvm_vcpu *vcpu,
-- 
1.6.0.1

