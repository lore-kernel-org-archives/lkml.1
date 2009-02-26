Return-Path: <linux-kernel-owner+w=401wt.eu-S1761375AbZBZO0p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761375AbZBZO0p (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Feb 2009 09:26:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755266AbZBZOQt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Feb 2009 09:16:49 -0500
Received: from mx2.redhat.com ([66.187.237.31]:43101 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756218AbZBZOPu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Feb 2009 09:15:50 -0500
From: Avi Kivity <avi@redhat.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Hollis Blanchard <hollisb@us.ibm.com>
Subject: [PATCH 39/40] KVM: ppc: change kvmppc_mmu_map() parameters
Date: Thu, 26 Feb 2009 16:15:29 +0200
Message-Id: <1235657730-27683-40-git-send-email-avi@redhat.com>
In-Reply-To: <1235657730-27683-1-git-send-email-avi@redhat.com>
References: <1235657730-27683-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Hollis Blanchard <hollisb@us.ibm.com>

Passing just the TLB index will ease an e500 implementation.

Signed-off-by: Hollis Blanchard <hollisb@us.ibm.com>
Signed-off-by: Avi Kivity <avi@redhat.com>
---
 arch/powerpc/include/asm/kvm_ppc.h |    1 -
 arch/powerpc/kvm/44x_tlb.c         |   15 +++++++--------
 arch/powerpc/kvm/booke.c           |    6 ++----
 3 files changed, 9 insertions(+), 13 deletions(-)

diff --git a/arch/powerpc/include/asm/kvm_ppc.h b/arch/powerpc/include/asm/kvm_ppc.h
index 7ba95d2..f661f8b 100644
--- a/arch/powerpc/include/asm/kvm_ppc.h
+++ b/arch/powerpc/include/asm/kvm_ppc.h
@@ -55,7 +55,6 @@ extern void kvmppc_emulate_dec(struct kvm_vcpu *vcpu);
 /* Core-specific hooks */
 
 extern void kvmppc_mmu_map(struct kvm_vcpu *vcpu, u64 gvaddr, gpa_t gpaddr,
-                           u64 asid, u32 flags, u32 max_bytes,
                            unsigned int gtlb_idx);
 extern void kvmppc_mmu_priv_switch(struct kvm_vcpu *vcpu, int usermode);
 extern void kvmppc_mmu_switch_pid(struct kvm_vcpu *vcpu, u32 pid);
diff --git a/arch/powerpc/kvm/44x_tlb.c b/arch/powerpc/kvm/44x_tlb.c
index 8f9c09c..e8ed22f 100644
--- a/arch/powerpc/kvm/44x_tlb.c
+++ b/arch/powerpc/kvm/44x_tlb.c
@@ -269,15 +269,19 @@ void kvmppc_mmu_destroy(struct kvm_vcpu *vcpu)
  * Caller must ensure that the specified guest TLB entry is safe to insert into
  * the shadow TLB.
  */
-void kvmppc_mmu_map(struct kvm_vcpu *vcpu, u64 gvaddr, gpa_t gpaddr, u64 asid,
-                    u32 flags, u32 max_bytes, unsigned int gtlb_index)
+void kvmppc_mmu_map(struct kvm_vcpu *vcpu, u64 gvaddr, gpa_t gpaddr,
+                    unsigned int gtlb_index)
 {
 	struct kvmppc_44x_tlbe stlbe;
 	struct kvmppc_vcpu_44x *vcpu_44x = to_44x(vcpu);
+	struct kvmppc_44x_tlbe *gtlbe = &vcpu_44x->guest_tlb[gtlb_index];
 	struct kvmppc_44x_shadow_ref *ref;
 	struct page *new_page;
 	hpa_t hpaddr;
 	gfn_t gfn;
+	u32 asid = gtlbe->tid;
+	u32 flags = gtlbe->word2;
+	u32 max_bytes = get_tlb_bytes(gtlbe);
 	unsigned int victim;
 
 	/* Select TLB entry to clobber. Indirectly guard against races with the TLB
@@ -448,10 +452,8 @@ int kvmppc_44x_emul_tlbwe(struct kvm_vcpu *vcpu, u8 ra, u8 rs, u8 ws)
 	}
 
 	if (tlbe_is_host_safe(vcpu, tlbe)) {
-		u64 asid;
 		gva_t eaddr;
 		gpa_t gpaddr;
-		u32 flags;
 		u32 bytes;
 
 		eaddr = get_tlb_eaddr(tlbe);
@@ -462,10 +464,7 @@ int kvmppc_44x_emul_tlbwe(struct kvm_vcpu *vcpu, u8 ra, u8 rs, u8 ws)
 		eaddr &= ~(bytes - 1);
 		gpaddr &= ~(bytes - 1);
 
-		asid = (tlbe->word0 & PPC44x_TLB_TS) | tlbe->tid;
-		flags = tlbe->word2 & 0xffff;
-
-		kvmppc_mmu_map(vcpu, eaddr, gpaddr, asid, flags, bytes, gtlb_index);
+		kvmppc_mmu_map(vcpu, eaddr, gpaddr, gtlb_index);
 	}
 
 	KVMTRACE_5D(GTLB_WRITE, vcpu, gtlb_index, tlbe->tid, tlbe->word0,
diff --git a/arch/powerpc/kvm/booke.c b/arch/powerpc/kvm/booke.c
index d196ae6..85b9e2f 100644
--- a/arch/powerpc/kvm/booke.c
+++ b/arch/powerpc/kvm/booke.c
@@ -316,8 +316,7 @@ int kvmppc_handle_exit(struct kvm_run *run, struct kvm_vcpu *vcpu,
 			 * b) the guest used a large mapping which we're faking
 			 * Either way, we need to satisfy the fault without
 			 * invoking the guest. */
-			kvmppc_mmu_map(vcpu, eaddr, gpaddr, gtlbe->tid,
-			               gtlbe->word2, get_tlb_bytes(gtlbe), gtlb_index);
+			kvmppc_mmu_map(vcpu, eaddr, gpaddr, gtlb_index);
 			kvmppc_account_exit(vcpu, DTLB_VIRT_MISS_EXITS);
 			r = RESUME_GUEST;
 		} else {
@@ -364,8 +363,7 @@ int kvmppc_handle_exit(struct kvm_run *run, struct kvm_vcpu *vcpu,
 			 * b) the guest used a large mapping which we're faking
 			 * Either way, we need to satisfy the fault without
 			 * invoking the guest. */
-			kvmppc_mmu_map(vcpu, eaddr, gpaddr, gtlbe->tid,
-			               gtlbe->word2, get_tlb_bytes(gtlbe), gtlb_index);
+			kvmppc_mmu_map(vcpu, eaddr, gpaddr, gtlb_index);
 		} else {
 			/* Guest mapped and leaped at non-RAM! */
 			kvmppc_booke_queue_irqprio(vcpu, BOOKE_IRQPRIO_MACHINE_CHECK);
-- 
1.6.0.6

