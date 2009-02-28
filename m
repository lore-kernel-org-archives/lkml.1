Return-Path: <linux-kernel-owner+w=401wt.eu-S1762476AbZB1BtV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762476AbZB1BtV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Feb 2009 20:49:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756835AbZB1Bmq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Feb 2009 20:42:46 -0500
Received: from mx2.redhat.com ([66.187.237.31]:41786 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754794AbZB1Bl7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Feb 2009 20:41:59 -0500
From: Avi Kivity <avi@redhat.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 22/30] KVM: ppc: Add emulation of E500 register mmucsr0
Date: Sat, 28 Feb 2009 03:41:41 +0200
Message-Id: <1235785309-12835-23-git-send-email-avi@redhat.com>
In-Reply-To: <1235785309-12835-1-git-send-email-avi@redhat.com>
References: <1235785309-12835-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Liu Yu <yu.liu@freescale.com>

Latest kernel flushes TLB via mmucsr0.

Signed-off-by: Liu Yu <yu.liu@freescale.com>
Acked-by: Hollis Blanchard <hollisb@us.ibm.com>
Signed-off-by: Avi Kivity <avi@redhat.com>
---
 arch/powerpc/kvm/e500_emulate.c |    8 ++++++++
 arch/powerpc/kvm/e500_tlb.c     |   16 ++++++++++++++++
 arch/powerpc/kvm/e500_tlb.h     |    1 +
 3 files changed, 25 insertions(+), 0 deletions(-)

diff --git a/arch/powerpc/kvm/e500_emulate.c b/arch/powerpc/kvm/e500_emulate.c
index 7a98d4a..3f76041 100644
--- a/arch/powerpc/kvm/e500_emulate.c
+++ b/arch/powerpc/kvm/e500_emulate.c
@@ -105,6 +105,11 @@ int kvmppc_core_emulate_mtspr(struct kvm_vcpu *vcpu, int sprn, int rs)
 	case SPRN_HID1:
 		vcpu_e500->hid1 = vcpu->arch.gpr[rs]; break;
 
+	case SPRN_MMUCSR0:
+		emulated = kvmppc_e500_emul_mt_mmucsr0(vcpu_e500,
+				vcpu->arch.gpr[rs]);
+		break;
+
 	/* extra exceptions */
 	case SPRN_IVOR32:
 		vcpu->arch.ivor[BOOKE_IRQPRIO_SPE_UNAVAIL] = vcpu->arch.gpr[rs];
@@ -172,6 +177,9 @@ int kvmppc_core_emulate_mfspr(struct kvm_vcpu *vcpu, int sprn, int rt)
 	case SPRN_HID1:
 		vcpu->arch.gpr[rt] = vcpu_e500->hid1; break;
 
+	case SPRN_MMUCSR0:
+		vcpu->arch.gpr[rt] = 0; break;
+
 	/* extra exceptions */
 	case SPRN_IVOR32:
 		vcpu->arch.gpr[rt] = vcpu->arch.ivor[BOOKE_IRQPRIO_SPE_UNAVAIL];
diff --git a/arch/powerpc/kvm/e500_tlb.c b/arch/powerpc/kvm/e500_tlb.c
index d437160..72386dd 100644
--- a/arch/powerpc/kvm/e500_tlb.c
+++ b/arch/powerpc/kvm/e500_tlb.c
@@ -391,6 +391,22 @@ static int kvmppc_e500_gtlbe_invalidate(struct kvmppc_vcpu_e500 *vcpu_e500,
 	return 0;
 }
 
+int kvmppc_e500_emul_mt_mmucsr0(struct kvmppc_vcpu_e500 *vcpu_e500, ulong value)
+{
+	int esel;
+
+	if (value & MMUCSR0_TLB0FI)
+		for (esel = 0; esel < vcpu_e500->guest_tlb_size[0]; esel++)
+			kvmppc_e500_gtlbe_invalidate(vcpu_e500, 0, esel);
+	if (value & MMUCSR0_TLB1FI)
+		for (esel = 0; esel < vcpu_e500->guest_tlb_size[1]; esel++)
+			kvmppc_e500_gtlbe_invalidate(vcpu_e500, 1, esel);
+
+	_tlbil_all();
+
+	return EMULATE_DONE;
+}
+
 int kvmppc_e500_emul_tlbivax(struct kvm_vcpu *vcpu, int ra, int rb)
 {
 	struct kvmppc_vcpu_e500 *vcpu_e500 = to_e500(vcpu);
diff --git a/arch/powerpc/kvm/e500_tlb.h b/arch/powerpc/kvm/e500_tlb.h
index ab49e93..4d5cc0f 100644
--- a/arch/powerpc/kvm/e500_tlb.h
+++ b/arch/powerpc/kvm/e500_tlb.h
@@ -44,6 +44,7 @@
 	   | E500_TLB_USER_PERM_MASK | E500_TLB_SUPER_PERM_MASK)
 
 extern void kvmppc_dump_tlbs(struct kvm_vcpu *);
+extern int kvmppc_e500_emul_mt_mmucsr0(struct kvmppc_vcpu_e500 *, ulong);
 extern int kvmppc_e500_emul_tlbwe(struct kvm_vcpu *);
 extern int kvmppc_e500_emul_tlbre(struct kvm_vcpu *);
 extern int kvmppc_e500_emul_tlbivax(struct kvm_vcpu *, int, int);
-- 
1.6.0.6

