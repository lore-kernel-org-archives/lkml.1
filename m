Return-Path: <linux-kernel-owner+w=401wt.eu-S1761453AbZB0KhU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761453AbZB0KhU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Feb 2009 05:37:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758120AbZB0K2R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Feb 2009 05:28:17 -0500
Received: from mx2.redhat.com ([66.187.237.31]:53583 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755467AbZB0K1L (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Feb 2009 05:27:11 -0500
From: Avi Kivity <avi@redhat.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 34/37] KVM: ppc: Move to new TLB invalidate interface
Date: Fri, 27 Feb 2009 12:26:57 +0200
Message-Id: <1235730420-7929-35-git-send-email-avi@redhat.com>
In-Reply-To: <1235730420-7929-1-git-send-email-avi@redhat.com>
References: <1235730420-7929-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Liu Yu <yu.liu@freescale.com>

Commit 2a4aca1144394653269720ffbb5a325a77abd5fa removed old method _tlbia().

Signed-off-by: Liu Yu <yu.liu@freescale.com>
Signed-off-by: Hollis Blanchard <hollisb@us.ibm.com>
Signed-off-by: Avi Kivity <avi@redhat.com>
---
 arch/powerpc/kvm/e500_tlb.c |   10 +++++-----
 1 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/arch/powerpc/kvm/e500_tlb.c b/arch/powerpc/kvm/e500_tlb.c
index e3daf57..d437160 100644
--- a/arch/powerpc/kvm/e500_tlb.c
+++ b/arch/powerpc/kvm/e500_tlb.c
@@ -20,6 +20,7 @@
 #include <asm/kvm_ppc.h>
 #include <asm/kvm_e500.h>
 
+#include "../mm/mmu_decl.h"
 #include "e500_tlb.h"
 
 #define to_htlb1_esel(esel) (tlb1_entry_num - (esel) - 1)
@@ -158,7 +159,7 @@ void kvmppc_e500_tlb_load(struct kvm_vcpu *vcpu, int cpu)
 
 void kvmppc_e500_tlb_put(struct kvm_vcpu *vcpu)
 {
-	_tlbia();
+	_tlbil_all();
 }
 
 /* Search the guest TLB for a matching entry. */
@@ -362,11 +363,10 @@ void kvmppc_mmu_priv_switch(struct kvm_vcpu *vcpu, int usermode)
 		int i;
 
 		/* XXX Replace loop with fancy data structures. */
-		/* needn't set modified since tlbia will make TLB1 coherent */
 		for (i = 0; i < tlb1_max_shadow_size(); i++)
 			kvmppc_e500_stlbe_invalidate(vcpu_e500, 1, i);
 
-		_tlbia();
+		_tlbil_all();
 	}
 }
 
@@ -417,7 +417,7 @@ int kvmppc_e500_emul_tlbivax(struct kvm_vcpu *vcpu, int ra, int rb)
 			kvmppc_e500_gtlbe_invalidate(vcpu_e500, tlbsel, esel);
 	}
 
-	_tlbia();
+	_tlbil_all();
 
 	return EMULATE_DONE;
 }
@@ -604,7 +604,7 @@ void kvmppc_mmu_destroy(struct kvm_vcpu *vcpu)
 			kvmppc_e500_shadow_release(vcpu_e500, tlbsel, i);
 
 	/* discard all guest mapping */
-	_tlbia();
+	_tlbil_all();
 }
 
 void kvmppc_mmu_map(struct kvm_vcpu *vcpu, u64 eaddr, gpa_t gpaddr,
-- 
1.6.0.6

