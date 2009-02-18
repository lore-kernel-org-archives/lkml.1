Return-Path: <linux-kernel-owner+w=401wt.eu-S1756523AbZBRSjB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756523AbZBRSjB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Feb 2009 13:39:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753103AbZBRSiu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Feb 2009 13:38:50 -0500
Received: from mx2.redhat.com ([66.187.237.31]:41824 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752951AbZBRSit (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Feb 2009 13:38:49 -0500
Date: Wed, 18 Feb 2009 15:38:08 -0300
From: Marcelo Tosatti <mtosatti@redhat.com>
To: Joerg Roedel <joerg.roedel@amd.com>
Cc: Avi Kivity <avi@redhat.com>, kvm@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] kvm mmu: remove redundant check in mmu_set_spte
Message-ID: <20090218183808.GE25719@amt.cnet>
References: <1234962540-7131-1-git-send-email-joerg.roedel@amd.com> <1234962540-7131-3-git-send-email-joerg.roedel@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1234962540-7131-3-git-send-email-joerg.roedel@amd.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


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
