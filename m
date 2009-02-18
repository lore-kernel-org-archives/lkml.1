Return-Path: <linux-kernel-owner+w=401wt.eu-S1754040AbZBRNJy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754040AbZBRNJy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Feb 2009 08:09:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752296AbZBRNJa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Feb 2009 08:09:30 -0500
Received: from outbound-sin.frontbridge.com ([207.46.51.80]:24554 "EHLO
	SG2EHSOBE006.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751585AbZBRNJ1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Feb 2009 08:09:27 -0500
X-BigFish: VPS3(zzzzzzz32i43j65h)
X-Spam-TCS-SCL: 4:0
X-FB-SS: 5,
X-WSS-ID: 0KF9J73-03-C6P-01
From: Joerg Roedel <joerg.roedel@amd.com>
To: Avi Kivity <avi@redhat.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, kvm@vger.kernel.org,
       linux-kernel@vger.kernel.org, Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 2/3] kvm mmu: remove redundant check in mmu_set_spte
Date: Wed, 18 Feb 2009 14:08:59 +0100
Message-ID: <1234962540-7131-3-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.5.6.4
In-Reply-To: <1234962540-7131-1-git-send-email-joerg.roedel@amd.com>
References: <1234962540-7131-1-git-send-email-joerg.roedel@amd.com>
X-OriginalArrivalTime: 18 Feb 2009 13:09:00.0210 (UTC) FILETIME=[10720920:01C991CA]
MIME-Version: 1.0
Content-Type: text/plain
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
1.5.6.4


