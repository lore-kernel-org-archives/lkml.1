Return-Path: <linux-kernel-owner+w=401wt.eu-S1761174AbZBZOZ7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761174AbZBZOZ7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Feb 2009 09:25:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757546AbZBZOQw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Feb 2009 09:16:52 -0500
Received: from mx2.redhat.com ([66.187.237.31]:43099 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755761AbZBZOPr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Feb 2009 09:15:47 -0500
From: Avi Kivity <avi@redhat.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Hollis Blanchard <hollisb@us.ibm.com>
Subject: [PATCH 38/40] KVM: ppc: small cosmetic changes to Book E DTLB miss handler
Date: Thu, 26 Feb 2009 16:15:28 +0200
Message-Id: <1235657730-27683-39-git-send-email-avi@redhat.com>
In-Reply-To: <1235657730-27683-1-git-send-email-avi@redhat.com>
References: <1235657730-27683-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Hollis Blanchard <hollisb@us.ibm.com>

Signed-off-by: Hollis Blanchard <hollisb@us.ibm.com>
Signed-off-by: Avi Kivity <avi@redhat.com>
---
 arch/powerpc/kvm/booke.c |    8 +++++---
 1 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/arch/powerpc/kvm/booke.c b/arch/powerpc/kvm/booke.c
index 35485dd..d196ae6 100644
--- a/arch/powerpc/kvm/booke.c
+++ b/arch/powerpc/kvm/booke.c
@@ -290,6 +290,7 @@ int kvmppc_handle_exit(struct kvm_run *run, struct kvm_vcpu *vcpu,
 		struct kvmppc_44x_tlbe *gtlbe;
 		unsigned long eaddr = vcpu->arch.fault_dear;
 		int gtlb_index;
+		gpa_t gpaddr;
 		gfn_t gfn;
 
 		/* Check the guest TLB. */
@@ -305,8 +306,8 @@ int kvmppc_handle_exit(struct kvm_run *run, struct kvm_vcpu *vcpu,
 		}
 
 		gtlbe = &vcpu_44x->guest_tlb[gtlb_index];
-		vcpu->arch.paddr_accessed = tlb_xlate(gtlbe, eaddr);
-		gfn = vcpu->arch.paddr_accessed >> PAGE_SHIFT;
+		gpaddr = tlb_xlate(gtlbe, eaddr);
+		gfn = gpaddr >> PAGE_SHIFT;
 
 		if (kvm_is_visible_gfn(vcpu->kvm, gfn)) {
 			/* The guest TLB had a mapping, but the shadow TLB
@@ -315,13 +316,14 @@ int kvmppc_handle_exit(struct kvm_run *run, struct kvm_vcpu *vcpu,
 			 * b) the guest used a large mapping which we're faking
 			 * Either way, we need to satisfy the fault without
 			 * invoking the guest. */
-			kvmppc_mmu_map(vcpu, eaddr, vcpu->arch.paddr_accessed, gtlbe->tid,
+			kvmppc_mmu_map(vcpu, eaddr, gpaddr, gtlbe->tid,
 			               gtlbe->word2, get_tlb_bytes(gtlbe), gtlb_index);
 			kvmppc_account_exit(vcpu, DTLB_VIRT_MISS_EXITS);
 			r = RESUME_GUEST;
 		} else {
 			/* Guest has mapped and accessed a page which is not
 			 * actually RAM. */
+			vcpu->arch.paddr_accessed = gpaddr;
 			r = kvmppc_emulate_mmio(run, vcpu);
 			kvmppc_account_exit(vcpu, MMIO_EXITS);
 		}
-- 
1.6.0.6

