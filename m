Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932929Ab0BPKiV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Feb 2010 05:38:21 -0500
Received: from mx1.redhat.com ([209.132.183.28]:20733 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932821Ab0BPKfl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Feb 2010 05:35:41 -0500
From: Avi Kivity <avi@redhat.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 24/38] KVM: PPC E500: fix tlbcfg emulation
Date: Tue, 16 Feb 2010 12:35:22 +0200
Message-Id: <1266316536-28936-25-git-send-email-avi@redhat.com>
In-Reply-To: <1266316536-28936-1-git-send-email-avi@redhat.com>
References: <1266316536-28936-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Liu Yu <yu.liu@freescale.com>

commit 55fb1027c1cf9797dbdeab48180da530e81b1c39 doesn't update tlbcfg correctly.
Fix it.

And since guest OS likes 'fixed' hardware,
initialize tlbcfg everytime when guest access is useless.
So move this part to init code.

Signed-off-by: Liu Yu <yu.liu@freescale.com>
Acked-by: Alexander Graf <agraf@suse.de>
Signed-off-by: Marcelo Tosatti <mtosatti@redhat.com>
---
 arch/powerpc/include/asm/kvm_e500.h |    2 ++
 arch/powerpc/kvm/e500_emulate.c     |   20 ++------------------
 arch/powerpc/kvm/e500_tlb.c         |    6 ++++++
 3 files changed, 10 insertions(+), 18 deletions(-)

diff --git a/arch/powerpc/include/asm/kvm_e500.h b/arch/powerpc/include/asm/kvm_e500.h
index 569dfd3..7fea26f 100644
--- a/arch/powerpc/include/asm/kvm_e500.h
+++ b/arch/powerpc/include/asm/kvm_e500.h
@@ -56,6 +56,8 @@ struct kvmppc_vcpu_e500 {
 	u32 l1csr1;
 	u32 hid0;
 	u32 hid1;
+	u32 tlb0cfg;
+	u32 tlb1cfg;
 
 	struct kvm_vcpu vcpu;
 };
diff --git a/arch/powerpc/kvm/e500_emulate.c b/arch/powerpc/kvm/e500_emulate.c
index 95f8ec8..8e3edfb 100644
--- a/arch/powerpc/kvm/e500_emulate.c
+++ b/arch/powerpc/kvm/e500_emulate.c
@@ -164,25 +164,9 @@ int kvmppc_core_emulate_mfspr(struct kvm_vcpu *vcpu, int sprn, int rt)
 		kvmppc_set_gpr(vcpu, rt, vcpu_e500->mas7); break;
 
 	case SPRN_TLB0CFG:
-	{
-		ulong tmp = SPRN_TLB0CFG;
-
-		tmp &= ~0xfffUL;
-		tmp |= vcpu_e500->guest_tlb_size[0];
-		kvmppc_set_gpr(vcpu, rt, tmp);
-		break;
-	}
-
+		kvmppc_set_gpr(vcpu, rt, vcpu_e500->tlb0cfg); break;
 	case SPRN_TLB1CFG:
-	{
-		ulong tmp = SPRN_TLB1CFG;
-
-		tmp &= ~0xfffUL;
-		tmp |= vcpu_e500->guest_tlb_size[1];
-		kvmppc_set_gpr(vcpu, rt, tmp);
-		break;
-	}
-
+		kvmppc_set_gpr(vcpu, rt, vcpu_e500->tlb1cfg); break;
 	case SPRN_L1CSR0:
 		kvmppc_set_gpr(vcpu, rt, vcpu_e500->l1csr0); break;
 	case SPRN_L1CSR1:
diff --git a/arch/powerpc/kvm/e500_tlb.c b/arch/powerpc/kvm/e500_tlb.c
index 6a7fc01..0d772e6 100644
--- a/arch/powerpc/kvm/e500_tlb.c
+++ b/arch/powerpc/kvm/e500_tlb.c
@@ -728,6 +728,12 @@ int kvmppc_e500_tlb_init(struct kvmppc_vcpu_e500 *vcpu_e500)
 	if (vcpu_e500->shadow_pages[1] == NULL)
 		goto err_out_page0;
 
+	/* Init TLB configuration register */
+	vcpu_e500->tlb0cfg = mfspr(SPRN_TLB0CFG) & ~0xfffUL;
+	vcpu_e500->tlb0cfg |= vcpu_e500->guest_tlb_size[0];
+	vcpu_e500->tlb1cfg = mfspr(SPRN_TLB1CFG) & ~0xfffUL;
+	vcpu_e500->tlb1cfg |= vcpu_e500->guest_tlb_size[1];
+
 	return 0;
 
 err_out_page0:
-- 
1.6.5.3

