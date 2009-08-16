Return-Path: <linux-kernel-owner+w=401wt.eu-S1754530AbZHPJcY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754530AbZHPJcY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Aug 2009 05:32:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754068AbZHPJcW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Aug 2009 05:32:22 -0400
Received: from mx2.redhat.com ([66.187.237.31]:45365 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754063AbZHPJaN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Aug 2009 05:30:13 -0400
From: Avi Kivity <avi@redhat.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 31/48] KVM: ppc: e500: Move to Book-3e MMU definitions
Date: Sun, 16 Aug 2009 12:29:51 +0300
Message-Id: <1250415008-17175-32-git-send-email-avi@redhat.com>
In-Reply-To: <1250415008-17175-1-git-send-email-avi@redhat.com>
References: <1250415008-17175-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Liu Yu <yu.liu@freescale.com>

According to commit 70fe3af8403f85196bb74f22ce4813db7dfedc1a.

Signed-off-by: Liu Yu <yu.liu@freescale.com>
Signed-off-by: Avi Kivity <avi@redhat.com>
---
 arch/powerpc/kvm/e500_tlb.c |   10 +++++-----
 arch/powerpc/kvm/e500_tlb.h |    6 +++---
 2 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/arch/powerpc/kvm/e500_tlb.c b/arch/powerpc/kvm/e500_tlb.c
index 0e773fc..a2048ac 100644
--- a/arch/powerpc/kvm/e500_tlb.c
+++ b/arch/powerpc/kvm/e500_tlb.c
@@ -269,7 +269,7 @@ static inline void kvmppc_e500_deliver_tlb_miss(struct kvm_vcpu *vcpu,
 	tlbsel = (vcpu_e500->mas4 >> 28) & 0x1;
 	victim = (tlbsel == 0) ? tlb0_get_next_victim(vcpu_e500) : 0;
 	pidsel = (vcpu_e500->mas4 >> 16) & 0xf;
-	tsized = (vcpu_e500->mas4 >> 8) & 0xf;
+	tsized = (vcpu_e500->mas4 >> 7) & 0x1f;
 
 	vcpu_e500->mas0 = MAS0_TLBSEL(tlbsel) | MAS0_ESEL(victim)
 		| MAS0_NV(vcpu_e500->guest_tlb_nv[tlbsel]);
@@ -309,7 +309,7 @@ static inline void kvmppc_e500_shadow_map(struct kvmppc_vcpu_e500 *vcpu_e500,
 	vcpu_e500->shadow_pages[tlbsel][esel] = new_page;
 
 	/* Force TS=1 IPROT=0 TSIZE=4KB for all guest mappings. */
-	stlbe->mas1 = MAS1_TSIZE(BOOKE_PAGESZ_4K)
+	stlbe->mas1 = MAS1_TSIZE(BOOK3E_PAGESZ_4K)
 		| MAS1_TID(get_tlb_tid(gtlbe)) | MAS1_TS | MAS1_VALID;
 	stlbe->mas2 = (gvaddr & MAS2_EPN)
 		| e500_shadow_mas2_attrib(gtlbe->mas2,
@@ -545,7 +545,7 @@ int kvmppc_e500_emul_tlbwe(struct kvm_vcpu *vcpu)
 		case 0:
 			/* TLB0 */
 			gtlbe->mas1 &= ~MAS1_TSIZE(~0);
-			gtlbe->mas1 |= MAS1_TSIZE(BOOKE_PAGESZ_4K);
+			gtlbe->mas1 |= MAS1_TSIZE(BOOK3E_PAGESZ_4K);
 
 			stlbsel = 0;
 			sesel = kvmppc_e500_stlbe_map(vcpu_e500, 0, esel);
@@ -679,14 +679,14 @@ void kvmppc_e500_tlb_setup(struct kvmppc_vcpu_e500 *vcpu_e500)
 
 	/* Insert large initial mapping for guest. */
 	tlbe = &vcpu_e500->guest_tlb[1][0];
-	tlbe->mas1 = MAS1_VALID | MAS1_TSIZE(BOOKE_PAGESZ_256M);
+	tlbe->mas1 = MAS1_VALID | MAS1_TSIZE(BOOK3E_PAGESZ_256M);
 	tlbe->mas2 = 0;
 	tlbe->mas3 = E500_TLB_SUPER_PERM_MASK;
 	tlbe->mas7 = 0;
 
 	/* 4K map for serial output. Used by kernel wrapper. */
 	tlbe = &vcpu_e500->guest_tlb[1][1];
-	tlbe->mas1 = MAS1_VALID | MAS1_TSIZE(BOOKE_PAGESZ_4K);
+	tlbe->mas1 = MAS1_VALID | MAS1_TSIZE(BOOK3E_PAGESZ_4K);
 	tlbe->mas2 = (0xe0004500 & 0xFFFFF000) | MAS2_I | MAS2_G;
 	tlbe->mas3 = (0xe0004500 & 0xFFFFF000) | E500_TLB_SUPER_PERM_MASK;
 	tlbe->mas7 = 0;
diff --git a/arch/powerpc/kvm/e500_tlb.h b/arch/powerpc/kvm/e500_tlb.h
index 45b064b..d28e301 100644
--- a/arch/powerpc/kvm/e500_tlb.h
+++ b/arch/powerpc/kvm/e500_tlb.h
@@ -16,7 +16,7 @@
 #define __KVM_E500_TLB_H__
 
 #include <linux/kvm_host.h>
-#include <asm/mmu-fsl-booke.h>
+#include <asm/mmu-book3e.h>
 #include <asm/tlb.h>
 #include <asm/kvm_e500.h>
 
@@ -59,7 +59,7 @@ extern void kvmppc_e500_tlb_setup(struct kvmppc_vcpu_e500 *);
 /* TLB helper functions */
 static inline unsigned int get_tlb_size(const struct tlbe *tlbe)
 {
-	return (tlbe->mas1 >> 8) & 0xf;
+	return (tlbe->mas1 >> 7) & 0x1f;
 }
 
 static inline gva_t get_tlb_eaddr(const struct tlbe *tlbe)
@@ -70,7 +70,7 @@ static inline gva_t get_tlb_eaddr(const struct tlbe *tlbe)
 static inline u64 get_tlb_bytes(const struct tlbe *tlbe)
 {
 	unsigned int pgsize = get_tlb_size(tlbe);
-	return 1ULL << 10 << (pgsize << 1);
+	return 1ULL << 10 << pgsize;
 }
 
 static inline gva_t get_tlb_end(const struct tlbe *tlbe)
-- 
1.6.3.3

