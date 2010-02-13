Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757585Ab0BMIJm (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Feb 2010 03:09:42 -0500
Received: from mx1.redhat.com ([209.132.183.28]:55964 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752332Ab0BMICD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Feb 2010 03:02:03 -0500
From: Avi Kivity <avi@redhat.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 07/39] KVM: PPC: Add helpers for CR, XER
Date: Sat, 13 Feb 2010 10:01:27 +0200
Message-Id: <1266048119-14325-8-git-send-email-avi@redhat.com>
In-Reply-To: <1266048119-14325-1-git-send-email-avi@redhat.com>
References: <1266048119-14325-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alexander Graf <agraf@suse.de>

We now have helpers for the GPRs, so let's also add some for CR and XER.

Having them in the PACA simplifies code a lot, as we don't need to care
about where to store CC or not to overflow any integers.

Signed-off-by: Alexander Graf <agraf@suse.de>
Signed-off-by: Avi Kivity <avi@redhat.com>
---
 arch/powerpc/include/asm/kvm_ppc.h |   40 ++++++++++++++++++++++++++++++++++++
 arch/powerpc/kvm/44x_tlb.c         |    6 +++-
 arch/powerpc/kvm/book3s.c          |    8 +++---
 arch/powerpc/kvm/booke.c           |    8 +++---
 4 files changed, 52 insertions(+), 10 deletions(-)

diff --git a/arch/powerpc/include/asm/kvm_ppc.h b/arch/powerpc/include/asm/kvm_ppc.h
index ba01b9c..d60b2f0 100644
--- a/arch/powerpc/include/asm/kvm_ppc.h
+++ b/arch/powerpc/include/asm/kvm_ppc.h
@@ -108,6 +108,26 @@ static inline ulong kvmppc_get_gpr(struct kvm_vcpu *vcpu, int num)
 	return vcpu->arch.gpr[num];
 }
 
+static inline void kvmppc_set_cr(struct kvm_vcpu *vcpu, u32 val)
+{
+	vcpu->arch.cr = val;
+}
+
+static inline u32 kvmppc_get_cr(struct kvm_vcpu *vcpu)
+{
+	return vcpu->arch.cr;
+}
+
+static inline void kvmppc_set_xer(struct kvm_vcpu *vcpu, u32 val)
+{
+	vcpu->arch.xer = val;
+}
+
+static inline u32 kvmppc_get_xer(struct kvm_vcpu *vcpu)
+{
+	return vcpu->arch.xer;
+}
+
 #else
 
 static inline void kvmppc_set_gpr(struct kvm_vcpu *vcpu, int num, ulong val)
@@ -120,6 +140,26 @@ static inline ulong kvmppc_get_gpr(struct kvm_vcpu *vcpu, int num)
 	return vcpu->arch.gpr[num];
 }
 
+static inline void kvmppc_set_cr(struct kvm_vcpu *vcpu, u32 val)
+{
+	vcpu->arch.cr = val;
+}
+
+static inline u32 kvmppc_get_cr(struct kvm_vcpu *vcpu)
+{
+	return vcpu->arch.cr;
+}
+
+static inline void kvmppc_set_xer(struct kvm_vcpu *vcpu, u32 val)
+{
+	vcpu->arch.xer = val;
+}
+
+static inline u32 kvmppc_get_xer(struct kvm_vcpu *vcpu)
+{
+	return vcpu->arch.xer;
+}
+
 #endif
 
 #endif /* __POWERPC_KVM_PPC_H__ */
diff --git a/arch/powerpc/kvm/44x_tlb.c b/arch/powerpc/kvm/44x_tlb.c
index 8b37736..2570fcc 100644
--- a/arch/powerpc/kvm/44x_tlb.c
+++ b/arch/powerpc/kvm/44x_tlb.c
@@ -506,10 +506,12 @@ int kvmppc_44x_emul_tlbsx(struct kvm_vcpu *vcpu, u8 rt, u8 ra, u8 rb, u8 rc)
 
 	gtlb_index = kvmppc_44x_tlb_index(vcpu, ea, pid, as);
 	if (rc) {
+		u32 cr = kvmppc_get_cr(vcpu);
+
 		if (gtlb_index < 0)
-			vcpu->arch.cr &= ~0x20000000;
+			kvmppc_set_cr(vcpu, cr & ~0x20000000);
 		else
-			vcpu->arch.cr |= 0x20000000;
+			kvmppc_set_cr(vcpu, cr | 0x20000000);
 	}
 	kvmppc_set_gpr(vcpu, rt, gtlb_index);
 
diff --git a/arch/powerpc/kvm/book3s.c b/arch/powerpc/kvm/book3s.c
index 574b24f..09ba8db 100644
--- a/arch/powerpc/kvm/book3s.c
+++ b/arch/powerpc/kvm/book3s.c
@@ -717,10 +717,10 @@ int kvm_arch_vcpu_ioctl_get_regs(struct kvm_vcpu *vcpu, struct kvm_regs *regs)
 	int i;
 
 	regs->pc = vcpu->arch.pc;
-	regs->cr = vcpu->arch.cr;
+	regs->cr = kvmppc_get_cr(vcpu);
 	regs->ctr = vcpu->arch.ctr;
 	regs->lr = vcpu->arch.lr;
-	regs->xer = vcpu->arch.xer;
+	regs->xer = kvmppc_get_xer(vcpu);
 	regs->msr = vcpu->arch.msr;
 	regs->srr0 = vcpu->arch.srr0;
 	regs->srr1 = vcpu->arch.srr1;
@@ -744,10 +744,10 @@ int kvm_arch_vcpu_ioctl_set_regs(struct kvm_vcpu *vcpu, struct kvm_regs *regs)
 	int i;
 
 	vcpu->arch.pc = regs->pc;
-	vcpu->arch.cr = regs->cr;
+	kvmppc_set_cr(vcpu, regs->cr);
 	vcpu->arch.ctr = regs->ctr;
 	vcpu->arch.lr = regs->lr;
-	vcpu->arch.xer = regs->xer;
+	kvmppc_set_xer(vcpu, regs->xer);
 	kvmppc_set_msr(vcpu, regs->msr);
 	vcpu->arch.srr0 = regs->srr0;
 	vcpu->arch.srr1 = regs->srr1;
diff --git a/arch/powerpc/kvm/booke.c b/arch/powerpc/kvm/booke.c
index 49af80e..338baf9 100644
--- a/arch/powerpc/kvm/booke.c
+++ b/arch/powerpc/kvm/booke.c
@@ -449,10 +449,10 @@ int kvm_arch_vcpu_ioctl_get_regs(struct kvm_vcpu *vcpu, struct kvm_regs *regs)
 	int i;
 
 	regs->pc = vcpu->arch.pc;
-	regs->cr = vcpu->arch.cr;
+	regs->cr = kvmppc_get_cr(vcpu);
 	regs->ctr = vcpu->arch.ctr;
 	regs->lr = vcpu->arch.lr;
-	regs->xer = vcpu->arch.xer;
+	regs->xer = kvmppc_get_xer(vcpu);
 	regs->msr = vcpu->arch.msr;
 	regs->srr0 = vcpu->arch.srr0;
 	regs->srr1 = vcpu->arch.srr1;
@@ -476,10 +476,10 @@ int kvm_arch_vcpu_ioctl_set_regs(struct kvm_vcpu *vcpu, struct kvm_regs *regs)
 	int i;
 
 	vcpu->arch.pc = regs->pc;
-	vcpu->arch.cr = regs->cr;
+	kvmppc_set_cr(vcpu, regs->cr);
 	vcpu->arch.ctr = regs->ctr;
 	vcpu->arch.lr = regs->lr;
-	vcpu->arch.xer = regs->xer;
+	kvmppc_set_xer(vcpu, regs->xer);
 	kvmppc_set_msr(vcpu, regs->msr);
 	vcpu->arch.srr0 = regs->srr0;
 	vcpu->arch.srr1 = regs->srr1;
-- 
1.6.5.3

