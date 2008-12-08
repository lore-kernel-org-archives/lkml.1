Return-Path: <linux-kernel-owner+w=401wt.eu-S1756256AbYLHLpB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756256AbYLHLpB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2008 06:45:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753689AbYLHLiG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Dec 2008 06:38:06 -0500
Received: from mx2.redhat.com ([66.187.237.31]:48279 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753349AbYLHLhG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2008 06:37:06 -0500
From: Avi Kivity <avi@redhat.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Hollis Blanchard <hollisb@us.ibm.com>
Subject: [PATCH 44/45] KVM: ppc: Move the last bits of 44x code out of booke.c
Date: Mon,  8 Dec 2008 13:36:55 +0200
Message-Id: <1228736216-15787-45-git-send-email-avi@redhat.com>
In-Reply-To: <1228736216-15787-1-git-send-email-avi@redhat.com>
References: <1228736216-15787-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Hollis Blanchard <hollisb@us.ibm.com>

Needed to port to other Book E processors.

Signed-off-by: Hollis Blanchard <hollisb@us.ibm.com>
Signed-off-by: Avi Kivity <avi@redhat.com>
---
 arch/powerpc/include/asm/kvm_ppc.h |    3 ++
 arch/powerpc/kvm/44x.c             |   53 ++++++++++++++++++++++++++++++++++++
 arch/powerpc/kvm/booke.c           |   46 +-----------------------------
 3 files changed, 58 insertions(+), 44 deletions(-)

diff --git a/arch/powerpc/include/asm/kvm_ppc.h b/arch/powerpc/include/asm/kvm_ppc.h
index aecf95d..d593325 100644
--- a/arch/powerpc/include/asm/kvm_ppc.h
+++ b/arch/powerpc/include/asm/kvm_ppc.h
@@ -62,7 +62,10 @@ extern void kvmppc_mmu_switch_pid(struct kvm_vcpu *vcpu, u32 pid);
 
 /* Core-specific hooks */
 
+extern int kvmppc_core_vcpu_setup(struct kvm_vcpu *vcpu);
 extern int kvmppc_core_check_processor_compat(void);
+extern int kvmppc_core_vcpu_translate(struct kvm_vcpu *vcpu,
+                                      struct kvm_translation *tr);
 
 extern void kvmppc_core_vcpu_load(struct kvm_vcpu *vcpu, int cpu);
 extern void kvmppc_core_vcpu_put(struct kvm_vcpu *vcpu);
diff --git a/arch/powerpc/kvm/44x.c b/arch/powerpc/kvm/44x.c
index fcf8c7d..f5d7028 100644
--- a/arch/powerpc/kvm/44x.c
+++ b/arch/powerpc/kvm/44x.c
@@ -121,3 +121,56 @@ int kvmppc_core_check_processor_compat(void)
 
 	return r;
 }
+
+int kvmppc_core_vcpu_setup(struct kvm_vcpu *vcpu)
+{
+	struct kvmppc_44x_tlbe *tlbe = &vcpu->arch.guest_tlb[0];
+
+	tlbe->tid = 0;
+	tlbe->word0 = PPC44x_TLB_16M | PPC44x_TLB_VALID;
+	tlbe->word1 = 0;
+	tlbe->word2 = PPC44x_TLB_SX | PPC44x_TLB_SW | PPC44x_TLB_SR;
+
+	tlbe++;
+	tlbe->tid = 0;
+	tlbe->word0 = 0xef600000 | PPC44x_TLB_4K | PPC44x_TLB_VALID;
+	tlbe->word1 = 0xef600000;
+	tlbe->word2 = PPC44x_TLB_SX | PPC44x_TLB_SW | PPC44x_TLB_SR
+	              | PPC44x_TLB_I | PPC44x_TLB_G;
+
+	/* Since the guest can directly access the timebase, it must know the
+	 * real timebase frequency. Accordingly, it must see the state of
+	 * CCR1[TCS]. */
+	vcpu->arch.ccr1 = mfspr(SPRN_CCR1);
+
+	return 0;
+}
+
+/* 'linear_address' is actually an encoding of AS|PID|EADDR . */
+int kvmppc_core_vcpu_translate(struct kvm_vcpu *vcpu,
+                               struct kvm_translation *tr)
+{
+	struct kvmppc_44x_tlbe *gtlbe;
+	int index;
+	gva_t eaddr;
+	u8 pid;
+	u8 as;
+
+	eaddr = tr->linear_address;
+	pid = (tr->linear_address >> 32) & 0xff;
+	as = (tr->linear_address >> 40) & 0x1;
+
+	index = kvmppc_44x_tlb_index(vcpu, eaddr, pid, as);
+	if (index == -1) {
+		tr->valid = 0;
+		return 0;
+	}
+
+	gtlbe = &vcpu->arch.guest_tlb[index];
+
+	tr->physical_address = tlb_xlate(gtlbe, eaddr);
+	/* XXX what does "writeable" and "usermode" even mean? */
+	tr->valid = 1;
+
+	return 0;
+}
diff --git a/arch/powerpc/kvm/booke.c b/arch/powerpc/kvm/booke.c
index ea63009..c619d1b 100644
--- a/arch/powerpc/kvm/booke.c
+++ b/arch/powerpc/kvm/booke.c
@@ -479,20 +479,6 @@ int kvmppc_handle_exit(struct kvm_run *run, struct kvm_vcpu *vcpu,
 /* Initial guest state: 16MB mapping 0 -> 0, PC = 0, MSR = 0, R1 = 16MB */
 int kvm_arch_vcpu_setup(struct kvm_vcpu *vcpu)
 {
-	struct kvmppc_44x_tlbe *tlbe = &vcpu->arch.guest_tlb[0];
-
-	tlbe->tid = 0;
-	tlbe->word0 = PPC44x_TLB_16M | PPC44x_TLB_VALID;
-	tlbe->word1 = 0;
-	tlbe->word2 = PPC44x_TLB_SX | PPC44x_TLB_SW | PPC44x_TLB_SR;
-
-	tlbe++;
-	tlbe->tid = 0;
-	tlbe->word0 = 0xef600000 | PPC44x_TLB_4K | PPC44x_TLB_VALID;
-	tlbe->word1 = 0xef600000;
-	tlbe->word2 = PPC44x_TLB_SX | PPC44x_TLB_SW | PPC44x_TLB_SR
-	              | PPC44x_TLB_I | PPC44x_TLB_G;
-
 	vcpu->arch.pc = 0;
 	vcpu->arch.msr = 0;
 	vcpu->arch.gpr[1] = (16<<20) - 8; /* -8 for the callee-save LR slot */
@@ -503,12 +489,7 @@ int kvm_arch_vcpu_setup(struct kvm_vcpu *vcpu)
 	 * before it's programmed its own IVPR. */
 	vcpu->arch.ivpr = 0x55550000;
 
-	/* Since the guest can directly access the timebase, it must know the
-	 * real timebase frequency. Accordingly, it must see the state of
-	 * CCR1[TCS]. */
-	vcpu->arch.ccr1 = mfspr(SPRN_CCR1);
-
-	return 0;
+	return kvmppc_core_vcpu_setup(vcpu);
 }
 
 int kvm_arch_vcpu_ioctl_get_regs(struct kvm_vcpu *vcpu, struct kvm_regs *regs)
@@ -586,33 +567,10 @@ int kvm_arch_vcpu_ioctl_set_fpu(struct kvm_vcpu *vcpu, struct kvm_fpu *fpu)
 	return -ENOTSUPP;
 }
 
-/* 'linear_address' is actually an encoding of AS|PID|EADDR . */
 int kvm_arch_vcpu_ioctl_translate(struct kvm_vcpu *vcpu,
                                   struct kvm_translation *tr)
 {
-	struct kvmppc_44x_tlbe *gtlbe;
-	int index;
-	gva_t eaddr;
-	u8 pid;
-	u8 as;
-
-	eaddr = tr->linear_address;
-	pid = (tr->linear_address >> 32) & 0xff;
-	as = (tr->linear_address >> 40) & 0x1;
-
-	index = kvmppc_44x_tlb_index(vcpu, eaddr, pid, as);
-	if (index == -1) {
-		tr->valid = 0;
-		return 0;
-	}
-
-	gtlbe = &vcpu->arch.guest_tlb[index];
-
-	tr->physical_address = tlb_xlate(gtlbe, eaddr);
-	/* XXX what does "writeable" and "usermode" even mean? */
-	tr->valid = 1;
-
-	return 0;
+	return kvmppc_core_vcpu_translate(vcpu, tr);
 }
 
 static int kvmppc_booke_init(void)
-- 
1.6.0.3

