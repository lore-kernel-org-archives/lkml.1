Return-Path: <linux-kernel-owner+w=401wt.eu-S1761274AbZBZO0Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761274AbZBZO0Y (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Feb 2009 09:26:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757260AbZBZOQu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Feb 2009 09:16:50 -0500
Received: from mx2.redhat.com ([66.187.237.31]:43100 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755906AbZBZOPs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Feb 2009 09:15:48 -0500
From: Avi Kivity <avi@redhat.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Hollis Blanchard <hollisb@us.ibm.com>
Subject: [PATCH 40/40] KVM: ppc: turn tlb_xlate() into a per-core hook (and give it a better name)
Date: Thu, 26 Feb 2009 16:15:30 +0200
Message-Id: <1235657730-27683-41-git-send-email-avi@redhat.com>
In-Reply-To: <1235657730-27683-1-git-send-email-avi@redhat.com>
References: <1235657730-27683-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Hollis Blanchard <hollisb@us.ibm.com>

Signed-off-by: Hollis Blanchard <hollisb@us.ibm.com>
Signed-off-by: Avi Kivity <avi@redhat.com>
---
 arch/powerpc/include/asm/kvm_ppc.h |    2 ++
 arch/powerpc/kvm/44x.c             |    6 +-----
 arch/powerpc/kvm/44x_tlb.c         |   10 ++++++++++
 arch/powerpc/kvm/44x_tlb.h         |    7 -------
 arch/powerpc/kvm/booke.c           |   10 ++--------
 5 files changed, 15 insertions(+), 20 deletions(-)

diff --git a/arch/powerpc/include/asm/kvm_ppc.h b/arch/powerpc/include/asm/kvm_ppc.h
index f661f8b..9fd70aa 100644
--- a/arch/powerpc/include/asm/kvm_ppc.h
+++ b/arch/powerpc/include/asm/kvm_ppc.h
@@ -59,6 +59,8 @@ extern void kvmppc_mmu_map(struct kvm_vcpu *vcpu, u64 gvaddr, gpa_t gpaddr,
 extern void kvmppc_mmu_priv_switch(struct kvm_vcpu *vcpu, int usermode);
 extern void kvmppc_mmu_switch_pid(struct kvm_vcpu *vcpu, u32 pid);
 extern void kvmppc_mmu_destroy(struct kvm_vcpu *vcpu);
+extern gpa_t kvmppc_mmu_xlate(struct kvm_vcpu *vcpu, unsigned int gtlb_index,
+                              gva_t eaddr);
 
 extern struct kvm_vcpu *kvmppc_core_vcpu_create(struct kvm *kvm,
                                                 unsigned int id);
diff --git a/arch/powerpc/kvm/44x.c b/arch/powerpc/kvm/44x.c
index a66bec5..8383603 100644
--- a/arch/powerpc/kvm/44x.c
+++ b/arch/powerpc/kvm/44x.c
@@ -149,8 +149,6 @@ int kvmppc_core_vcpu_setup(struct kvm_vcpu *vcpu)
 int kvmppc_core_vcpu_translate(struct kvm_vcpu *vcpu,
                                struct kvm_translation *tr)
 {
-	struct kvmppc_vcpu_44x *vcpu_44x = to_44x(vcpu);
-	struct kvmppc_44x_tlbe *gtlbe;
 	int index;
 	gva_t eaddr;
 	u8 pid;
@@ -166,9 +164,7 @@ int kvmppc_core_vcpu_translate(struct kvm_vcpu *vcpu,
 		return 0;
 	}
 
-	gtlbe = &vcpu_44x->guest_tlb[index];
-
-	tr->physical_address = tlb_xlate(gtlbe, eaddr);
+	tr->physical_address = kvmppc_mmu_xlate(vcpu, index, eaddr);
 	/* XXX what does "writeable" and "usermode" even mean? */
 	tr->valid = 1;
 
diff --git a/arch/powerpc/kvm/44x_tlb.c b/arch/powerpc/kvm/44x_tlb.c
index e8ed22f..2f14671 100644
--- a/arch/powerpc/kvm/44x_tlb.c
+++ b/arch/powerpc/kvm/44x_tlb.c
@@ -208,6 +208,16 @@ int kvmppc_44x_tlb_index(struct kvm_vcpu *vcpu, gva_t eaddr, unsigned int pid,
 	return -1;
 }
 
+gpa_t kvmppc_mmu_xlate(struct kvm_vcpu *vcpu, unsigned int gtlb_index,
+                       gva_t eaddr)
+{
+	struct kvmppc_vcpu_44x *vcpu_44x = to_44x(vcpu);
+	struct kvmppc_44x_tlbe *gtlbe = &vcpu_44x->guest_tlb[gtlb_index];
+	unsigned int pgmask = get_tlb_bytes(gtlbe) - 1;
+
+	return get_tlb_raddr(gtlbe) | (eaddr & pgmask);
+}
+
 int kvmppc_44x_itlb_index(struct kvm_vcpu *vcpu, gva_t eaddr)
 {
 	unsigned int as = !!(vcpu->arch.msr & MSR_IS);
diff --git a/arch/powerpc/kvm/44x_tlb.h b/arch/powerpc/kvm/44x_tlb.h
index 772191f..05b6f7e 100644
--- a/arch/powerpc/kvm/44x_tlb.h
+++ b/arch/powerpc/kvm/44x_tlb.h
@@ -85,11 +85,4 @@ static inline unsigned int get_mmucr_sts(const struct kvm_vcpu *vcpu)
 	return (vcpu->arch.mmucr >> 16) & 0x1;
 }
 
-static inline gpa_t tlb_xlate(struct kvmppc_44x_tlbe *tlbe, gva_t eaddr)
-{
-	unsigned int pgmask = get_tlb_bytes(tlbe) - 1;
-
-	return get_tlb_raddr(tlbe) | (eaddr & pgmask);
-}
-
 #endif /* __KVM_POWERPC_TLB_H__ */
diff --git a/arch/powerpc/kvm/booke.c b/arch/powerpc/kvm/booke.c
index 85b9e2f..56d6ed6 100644
--- a/arch/powerpc/kvm/booke.c
+++ b/arch/powerpc/kvm/booke.c
@@ -286,8 +286,6 @@ int kvmppc_handle_exit(struct kvm_run *run, struct kvm_vcpu *vcpu,
 
 	/* XXX move to a 440-specific file. */
 	case BOOKE_INTERRUPT_DTLB_MISS: {
-		struct kvmppc_vcpu_44x *vcpu_44x = to_44x(vcpu);
-		struct kvmppc_44x_tlbe *gtlbe;
 		unsigned long eaddr = vcpu->arch.fault_dear;
 		int gtlb_index;
 		gpa_t gpaddr;
@@ -305,8 +303,7 @@ int kvmppc_handle_exit(struct kvm_run *run, struct kvm_vcpu *vcpu,
 			break;
 		}
 
-		gtlbe = &vcpu_44x->guest_tlb[gtlb_index];
-		gpaddr = tlb_xlate(gtlbe, eaddr);
+		gpaddr = kvmppc_mmu_xlate(vcpu, gtlb_index, eaddr);
 		gfn = gpaddr >> PAGE_SHIFT;
 
 		if (kvm_is_visible_gfn(vcpu->kvm, gfn)) {
@@ -332,8 +329,6 @@ int kvmppc_handle_exit(struct kvm_run *run, struct kvm_vcpu *vcpu,
 
 	/* XXX move to a 440-specific file. */
 	case BOOKE_INTERRUPT_ITLB_MISS: {
-		struct kvmppc_vcpu_44x *vcpu_44x = to_44x(vcpu);
-		struct kvmppc_44x_tlbe *gtlbe;
 		unsigned long eaddr = vcpu->arch.pc;
 		gpa_t gpaddr;
 		gfn_t gfn;
@@ -352,8 +347,7 @@ int kvmppc_handle_exit(struct kvm_run *run, struct kvm_vcpu *vcpu,
 
 		kvmppc_account_exit(vcpu, ITLB_VIRT_MISS_EXITS);
 
-		gtlbe = &vcpu_44x->guest_tlb[gtlb_index];
-		gpaddr = tlb_xlate(gtlbe, eaddr);
+		gpaddr = kvmppc_mmu_xlate(vcpu, gtlb_index, eaddr);
 		gfn = gpaddr >> PAGE_SHIFT;
 
 		if (kvm_is_visible_gfn(vcpu->kvm, gfn)) {
-- 
1.6.0.6

