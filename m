Return-Path: <linux-kernel-owner+w=401wt.eu-S1759046AbZB0KaT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759046AbZB0KaT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Feb 2009 05:30:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757632AbZB0K12
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Feb 2009 05:27:28 -0500
Received: from mx2.redhat.com ([66.187.237.31]:53564 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755361AbZB0K1J (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Feb 2009 05:27:09 -0500
From: Avi Kivity <avi@redhat.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 09/37] KVM: ppc: Add kvmppc_mmu_dtlb/itlb_miss for booke
Date: Fri, 27 Feb 2009 12:26:32 +0200
Message-Id: <1235730420-7929-10-git-send-email-avi@redhat.com>
In-Reply-To: <1235730420-7929-1-git-send-email-avi@redhat.com>
References: <1235730420-7929-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Hollis Blanchard <hollisb@us.ibm.com>

When itlb or dtlb miss happens, E500 needs to update some mmu registers.
So that the auto-load mechanism can work on E500 when write a tlb entry.

Signed-off-by: Liu Yu <yu.liu@freescale.com>
Signed-off-by: Hollis Blanchard <hollisb@us.ibm.com>
Signed-off-by: Avi Kivity <avi@redhat.com>
---
 arch/powerpc/include/asm/kvm_ppc.h |    2 ++
 arch/powerpc/kvm/44x_tlb.c         |    8 ++++++++
 arch/powerpc/kvm/booke.c           |    2 ++
 3 files changed, 12 insertions(+), 0 deletions(-)

diff --git a/arch/powerpc/include/asm/kvm_ppc.h b/arch/powerpc/include/asm/kvm_ppc.h
index 5e80a20..6052779 100644
--- a/arch/powerpc/include/asm/kvm_ppc.h
+++ b/arch/powerpc/include/asm/kvm_ppc.h
@@ -63,6 +63,8 @@ extern int kvmppc_mmu_dtlb_index(struct kvm_vcpu *vcpu, gva_t eaddr);
 extern int kvmppc_mmu_itlb_index(struct kvm_vcpu *vcpu, gva_t eaddr);
 extern gpa_t kvmppc_mmu_xlate(struct kvm_vcpu *vcpu, unsigned int gtlb_index,
                               gva_t eaddr);
+extern void kvmppc_mmu_dtlb_miss(struct kvm_vcpu *vcpu);
+extern void kvmppc_mmu_itlb_miss(struct kvm_vcpu *vcpu);
 
 extern struct kvm_vcpu *kvmppc_core_vcpu_create(struct kvm *kvm,
                                                 unsigned int id);
diff --git a/arch/powerpc/kvm/44x_tlb.c b/arch/powerpc/kvm/44x_tlb.c
index e67b731..4a16f47 100644
--- a/arch/powerpc/kvm/44x_tlb.c
+++ b/arch/powerpc/kvm/44x_tlb.c
@@ -232,6 +232,14 @@ int kvmppc_mmu_dtlb_index(struct kvm_vcpu *vcpu, gva_t eaddr)
 	return kvmppc_44x_tlb_index(vcpu, eaddr, vcpu->arch.pid, as);
 }
 
+void kvmppc_mmu_itlb_miss(struct kvm_vcpu *vcpu)
+{
+}
+
+void kvmppc_mmu_dtlb_miss(struct kvm_vcpu *vcpu)
+{
+}
+
 static void kvmppc_44x_shadow_release(struct kvmppc_vcpu_44x *vcpu_44x,
                                       unsigned int stlb_index)
 {
diff --git a/arch/powerpc/kvm/booke.c b/arch/powerpc/kvm/booke.c
index a73b395..933c406 100644
--- a/arch/powerpc/kvm/booke.c
+++ b/arch/powerpc/kvm/booke.c
@@ -295,6 +295,7 @@ int kvmppc_handle_exit(struct kvm_run *run, struct kvm_vcpu *vcpu,
 			kvmppc_booke_queue_irqprio(vcpu, BOOKE_IRQPRIO_DTLB_MISS);
 			vcpu->arch.dear = vcpu->arch.fault_dear;
 			vcpu->arch.esr = vcpu->arch.fault_esr;
+			kvmppc_mmu_dtlb_miss(vcpu);
 			kvmppc_account_exit(vcpu, DTLB_REAL_MISS_EXITS);
 			r = RESUME_GUEST;
 			break;
@@ -337,6 +338,7 @@ int kvmppc_handle_exit(struct kvm_run *run, struct kvm_vcpu *vcpu,
 		if (gtlb_index < 0) {
 			/* The guest didn't have a mapping for it. */
 			kvmppc_booke_queue_irqprio(vcpu, BOOKE_IRQPRIO_ITLB_MISS);
+			kvmppc_mmu_itlb_miss(vcpu);
 			kvmppc_account_exit(vcpu, ITLB_REAL_MISS_EXITS);
 			break;
 		}
-- 
1.6.0.6

