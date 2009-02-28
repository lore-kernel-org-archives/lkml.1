Return-Path: <linux-kernel-owner+w=401wt.eu-S1762246AbZB1Bsj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762246AbZB1Bsj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Feb 2009 20:48:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755414AbZB1Bml
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Feb 2009 20:42:41 -0500
Received: from mx2.redhat.com ([66.187.237.31]:41783 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754759AbZB1Bl6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Feb 2009 20:41:58 -0500
From: Avi Kivity <avi@redhat.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 16/30] KVM: MMU: remove redundant check in mmu_set_spte
Date: Sat, 28 Feb 2009 03:41:35 +0200
Message-Id: <1235785309-12835-17-git-send-email-avi@redhat.com>
In-Reply-To: <1235785309-12835-1-git-send-email-avi@redhat.com>
References: <1235785309-12835-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Joerg Roedel <joerg.roedel@amd.com>

The following code flow is unnecessary:

	if (largepage)
		was_rmapped = is_large_pte(*shadow_pte);
	 else
	 	was_rmapped = 1;

The is_large_pte() function will always evaluate to one here because the
(largepage && !is_large_pte) case is already handled in the first
if-clause. So we can remove this check and set was_rmapped to one always
here.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
Acked-by: Marcelo Tosatti <mtosatti@redhat.com>
Signed-off-by: Avi Kivity <avi@redhat.com>
---
 arch/x86/kvm/mmu.c |    8 ++------
 1 files changed, 2 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index ef060ec..c90b4b2 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -1791,12 +1791,8 @@ static void mmu_set_spte(struct kvm_vcpu *vcpu, u64 *shadow_pte,
 			pgprintk("hfn old %lx new %lx\n",
 				 spte_to_pfn(*shadow_pte), pfn);
 			rmap_remove(vcpu->kvm, shadow_pte);
-		} else {
-			if (largepage)
-				was_rmapped = is_large_pte(*shadow_pte);
-			else
-				was_rmapped = 1;
-		}
+		} else
+			was_rmapped = 1;
 	}
 	if (set_spte(vcpu, shadow_pte, pte_access, user_fault, write_fault,
 		      dirty, largepage, global, gfn, pfn, speculative, true)) {
-- 
1.6.0.6

