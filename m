Return-Path: <linux-kernel-owner+w=401wt.eu-S1756888AbZB0K2t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756888AbZB0K2t (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Feb 2009 05:28:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756435AbZB0K1N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Feb 2009 05:27:13 -0500
Received: from mx2.redhat.com ([66.187.237.31]:53559 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755301AbZB0K1I (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Feb 2009 05:27:08 -0500
From: Avi Kivity <avi@redhat.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 01/37] KVM: ppc: rename 44x MMU functions used in booke.c
Date: Fri, 27 Feb 2009 12:26:24 +0200
Message-Id: <1235730420-7929-2-git-send-email-avi@redhat.com>
In-Reply-To: <1235730420-7929-1-git-send-email-avi@redhat.com>
References: <1235730420-7929-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Hollis Blanchard <hollisb@us.ibm.com>

e500 will provide its own implementation of these.

Signed-off-by: Hollis Blanchard <hollisb@us.ibm.com>
Signed-off-by: Avi Kivity <avi@redhat.com>
---
 arch/powerpc/include/asm/kvm_ppc.h |    2 ++
 arch/powerpc/kvm/44x_tlb.c         |    4 ++--
 arch/powerpc/kvm/44x_tlb.h         |    2 --
 arch/powerpc/kvm/booke.c           |    4 ++--
 4 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/arch/powerpc/include/asm/kvm_ppc.h b/arch/powerpc/include/asm/kvm_ppc.h
index 9fd70aa..5e80a20 100644
--- a/arch/powerpc/include/asm/kvm_ppc.h
+++ b/arch/powerpc/include/asm/kvm_ppc.h
@@ -59,6 +59,8 @@ extern void kvmppc_mmu_map(struct kvm_vcpu *vcpu, u64 gvaddr, gpa_t gpaddr,
 extern void kvmppc_mmu_priv_switch(struct kvm_vcpu *vcpu, int usermode);
 extern void kvmppc_mmu_switch_pid(struct kvm_vcpu *vcpu, u32 pid);
 extern void kvmppc_mmu_destroy(struct kvm_vcpu *vcpu);
+extern int kvmppc_mmu_dtlb_index(struct kvm_vcpu *vcpu, gva_t eaddr);
+extern int kvmppc_mmu_itlb_index(struct kvm_vcpu *vcpu, gva_t eaddr);
 extern gpa_t kvmppc_mmu_xlate(struct kvm_vcpu *vcpu, unsigned int gtlb_index,
                               gva_t eaddr);
 
diff --git a/arch/powerpc/kvm/44x_tlb.c b/arch/powerpc/kvm/44x_tlb.c
index 2f14671..e67b731 100644
--- a/arch/powerpc/kvm/44x_tlb.c
+++ b/arch/powerpc/kvm/44x_tlb.c
@@ -218,14 +218,14 @@ gpa_t kvmppc_mmu_xlate(struct kvm_vcpu *vcpu, unsigned int gtlb_index,
 	return get_tlb_raddr(gtlbe) | (eaddr & pgmask);
 }
 
-int kvmppc_44x_itlb_index(struct kvm_vcpu *vcpu, gva_t eaddr)
+int kvmppc_mmu_itlb_index(struct kvm_vcpu *vcpu, gva_t eaddr)
 {
 	unsigned int as = !!(vcpu->arch.msr & MSR_IS);
 
 	return kvmppc_44x_tlb_index(vcpu, eaddr, vcpu->arch.pid, as);
 }
 
-int kvmppc_44x_dtlb_index(struct kvm_vcpu *vcpu, gva_t eaddr)
+int kvmppc_mmu_dtlb_index(struct kvm_vcpu *vcpu, gva_t eaddr)
 {
 	unsigned int as = !!(vcpu->arch.msr & MSR_DS);
 
diff --git a/arch/powerpc/kvm/44x_tlb.h b/arch/powerpc/kvm/44x_tlb.h
index 05b6f7e..a9ff80e 100644
--- a/arch/powerpc/kvm/44x_tlb.h
+++ b/arch/powerpc/kvm/44x_tlb.h
@@ -25,8 +25,6 @@
 
 extern int kvmppc_44x_tlb_index(struct kvm_vcpu *vcpu, gva_t eaddr,
                                 unsigned int pid, unsigned int as);
-extern int kvmppc_44x_dtlb_index(struct kvm_vcpu *vcpu, gva_t eaddr);
-extern int kvmppc_44x_itlb_index(struct kvm_vcpu *vcpu, gva_t eaddr);
 
 extern int kvmppc_44x_emul_tlbsx(struct kvm_vcpu *vcpu, u8 rt, u8 ra, u8 rb,
                                  u8 rc);
diff --git a/arch/powerpc/kvm/booke.c b/arch/powerpc/kvm/booke.c
index 56d6ed6..1e692ac 100644
--- a/arch/powerpc/kvm/booke.c
+++ b/arch/powerpc/kvm/booke.c
@@ -292,7 +292,7 @@ int kvmppc_handle_exit(struct kvm_run *run, struct kvm_vcpu *vcpu,
 		gfn_t gfn;
 
 		/* Check the guest TLB. */
-		gtlb_index = kvmppc_44x_dtlb_index(vcpu, eaddr);
+		gtlb_index = kvmppc_mmu_dtlb_index(vcpu, eaddr);
 		if (gtlb_index < 0) {
 			/* The guest didn't have a mapping for it. */
 			kvmppc_booke_queue_irqprio(vcpu, BOOKE_IRQPRIO_DTLB_MISS);
@@ -337,7 +337,7 @@ int kvmppc_handle_exit(struct kvm_run *run, struct kvm_vcpu *vcpu,
 		r = RESUME_GUEST;
 
 		/* Check the guest TLB. */
-		gtlb_index = kvmppc_44x_itlb_index(vcpu, eaddr);
+		gtlb_index = kvmppc_mmu_itlb_index(vcpu, eaddr);
 		if (gtlb_index < 0) {
 			/* The guest didn't have a mapping for it. */
 			kvmppc_booke_queue_irqprio(vcpu, BOOKE_IRQPRIO_ITLB_MISS);
-- 
1.6.0.6

