Return-Path: <linux-kernel-owner+w=401wt.eu-S1755921AbZETL2H@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755921AbZETL2H (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 May 2009 07:28:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756851AbZETLUV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 May 2009 07:20:21 -0400
Received: from mx2.redhat.com ([66.187.237.31]:55277 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755599AbZETLSt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 May 2009 07:18:49 -0400
From: Avi Kivity <avi@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: kvm@vger.kernel.org
Subject: [PATCH 16/46] KVM: MMU: Discard reserved bits checking on PDE bit 7-8
Date: Wed, 20 May 2009 14:18:13 +0300
Message-Id: <1242818323-10413-17-git-send-email-avi@redhat.com>
In-Reply-To: <1242818323-10413-1-git-send-email-avi@redhat.com>
References: <1242818323-10413-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sheng Yang <sheng@linux.intel.com>

1. It's related to a Linux kernel bug which fixed by Ingo on
07a66d7c53a538e1a9759954a82bb6c07365eff9. The original code exists for quite a
long time, and it would convert a PDE for large page into a normal PDE. But it
fail to fit normal PDE well.  With the code before Ingo's fix, the kernel would
fall reserved bit checking with bit 8 - the remaining global bit of PTE. So the
kernel would receive a double-fault.

2. After discussion, we decide to discard PDE bit 7-8 reserved checking for now.
For this marked as reserved in SDM, but didn't checked by the processor in
fact...

Signed-off-by: Sheng Yang <sheng@linux.intel.com>
Signed-off-by: Avi Kivity <avi@redhat.com>
---
 arch/x86/kvm/mmu.c |    7 ++++---
 1 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index 5baf539..409d08e 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -2194,7 +2194,7 @@ static void reset_rsvds_bits_mask(struct kvm_vcpu *vcpu, int level)
 			rsvd_bits(maxphyaddr, 63) |
 			rsvd_bits(7, 8) | rsvd_bits(1, 2);	/* PDPTE */
 		context->rsvd_bits_mask[0][1] = exb_bit_rsvd |
-			rsvd_bits(maxphyaddr, 62);		/* PDE */
+			rsvd_bits(maxphyaddr, 62);	/* PDE */
 		context->rsvd_bits_mask[0][0] = exb_bit_rsvd |
 			rsvd_bits(maxphyaddr, 62); 	/* PTE */
 		context->rsvd_bits_mask[1][1] = exb_bit_rsvd |
@@ -2208,13 +2208,14 @@ static void reset_rsvds_bits_mask(struct kvm_vcpu *vcpu, int level)
 		context->rsvd_bits_mask[0][2] = exb_bit_rsvd |
 			rsvd_bits(maxphyaddr, 51) | rsvd_bits(7, 8);
 		context->rsvd_bits_mask[0][1] = exb_bit_rsvd |
-			rsvd_bits(maxphyaddr, 51) | rsvd_bits(7, 8);
+			rsvd_bits(maxphyaddr, 51);
 		context->rsvd_bits_mask[0][0] = exb_bit_rsvd |
 			rsvd_bits(maxphyaddr, 51);
 		context->rsvd_bits_mask[1][3] = context->rsvd_bits_mask[0][3];
 		context->rsvd_bits_mask[1][2] = context->rsvd_bits_mask[0][2];
 		context->rsvd_bits_mask[1][1] = exb_bit_rsvd |
-			rsvd_bits(maxphyaddr, 51) | rsvd_bits(13, 20);
+			rsvd_bits(maxphyaddr, 51) |
+			rsvd_bits(13, 20);		/* large page */
 		context->rsvd_bits_mask[1][0] = ~0ull;
 		break;
 	}
-- 
1.6.0.6

