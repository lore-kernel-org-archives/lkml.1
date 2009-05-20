Return-Path: <linux-kernel-owner+w=401wt.eu-S1755390AbZETLal@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755390AbZETLal (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 May 2009 07:30:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757175AbZETLVD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 May 2009 07:21:03 -0400
Received: from mx2.redhat.com ([66.187.237.31]:55267 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755327AbZETLSs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 May 2009 07:18:48 -0400
From: Avi Kivity <avi@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: kvm@vger.kernel.org
Subject: [PATCH 10/46] KVM: Use rsvd_bits_mask in load_pdptrs()
Date: Wed, 20 May 2009 14:18:07 +0300
Message-Id: <1242818323-10413-11-git-send-email-avi@redhat.com>
In-Reply-To: <1242818323-10413-1-git-send-email-avi@redhat.com>
References: <1242818323-10413-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dong, Eddie <eddie.dong@intel.com>

Also remove bit 5-6 from rsvd_bits_mask per latest SDM.

Signed-off-by: Eddie Dong <Eddie.Dong@intel.com>
Signed-off-by: Avi Kivity <avi@redhat.com>
---
 arch/x86/kvm/mmu.c |    8 +++-----
 arch/x86/kvm/mmu.h |    5 +++++
 arch/x86/kvm/x86.c |    3 ++-
 3 files changed, 10 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index 24f5a57..5baf539 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -225,11 +225,6 @@ static int is_nx(struct kvm_vcpu *vcpu)
 	return vcpu->arch.shadow_efer & EFER_NX;
 }
 
-static int is_present_pte(unsigned long pte)
-{
-	return pte & PT_PRESENT_MASK;
-}
-
 static int is_shadow_present_pte(u64 pte)
 {
 	return pte != shadow_trap_nonpresent_pte
@@ -2195,6 +2190,9 @@ static void reset_rsvds_bits_mask(struct kvm_vcpu *vcpu, int level)
 		context->rsvd_bits_mask[1][0] = ~0ull;
 		break;
 	case PT32E_ROOT_LEVEL:
+		context->rsvd_bits_mask[0][2] =
+			rsvd_bits(maxphyaddr, 63) |
+			rsvd_bits(7, 8) | rsvd_bits(1, 2);	/* PDPTE */
 		context->rsvd_bits_mask[0][1] = exb_bit_rsvd |
 			rsvd_bits(maxphyaddr, 62);		/* PDE */
 		context->rsvd_bits_mask[0][0] = exb_bit_rsvd |
diff --git a/arch/x86/kvm/mmu.h b/arch/x86/kvm/mmu.h
index eaab214..3494a2f 100644
--- a/arch/x86/kvm/mmu.h
+++ b/arch/x86/kvm/mmu.h
@@ -75,4 +75,9 @@ static inline int is_paging(struct kvm_vcpu *vcpu)
 	return vcpu->arch.cr0 & X86_CR0_PG;
 }
 
+static inline int is_present_pte(unsigned long pte)
+{
+	return pte & PT_PRESENT_MASK;
+}
+
 #endif
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 34516bf..7be18d4 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -234,7 +234,8 @@ int load_pdptrs(struct kvm_vcpu *vcpu, unsigned long cr3)
 		goto out;
 	}
 	for (i = 0; i < ARRAY_SIZE(pdpte); ++i) {
-		if ((pdpte[i] & 1) && (pdpte[i] & 0xfffffff0000001e6ull)) {
+		if (is_present_pte(pdpte[i]) &&
+		    (pdpte[i] & vcpu->arch.mmu.rsvd_bits_mask[0][2])) {
 			ret = 0;
 			goto out;
 		}
-- 
1.6.0.6

