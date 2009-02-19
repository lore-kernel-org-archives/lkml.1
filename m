Return-Path: <linux-kernel-owner+w=401wt.eu-S1757820AbZBSLTX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757820AbZBSLTX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Feb 2009 06:19:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751989AbZBSLTK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Feb 2009 06:19:10 -0500
Received: from wa4ehsobe001.messaging.microsoft.com ([216.32.181.11]:20072
	"EHLO WA4EHSOBE001.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753114AbZBSLTI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Feb 2009 06:19:08 -0500
X-BigFish: VPS3(zzzzzzz32i43j64h)
X-Spam-TCS-SCL: 3:0
X-WSS-ID: 0KFB8RK-04-4HV-01
From: Joerg Roedel <joerg.roedel@amd.com>
To: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>
CC: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
       Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH] kvm mmu: fix another largepage memory leak
Date: Thu, 19 Feb 2009 12:18:56 +0100
Message-ID: <1235042336-20101-1-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.5.6.4
X-OriginalArrivalTime: 19 Feb 2009 11:18:56.0615 (UTC) FILETIME=[DACF2770:01C99283]
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In the paging_fetch function rmap_remove is called after setting a large
pte to non-present. This causes rmap_remove to not drop the reference to
the large page. The result is a memory leak of that page.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 arch/x86/kvm/paging_tmpl.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kvm/paging_tmpl.h b/arch/x86/kvm/paging_tmpl.h
index 7314c09..0f11792 100644
--- a/arch/x86/kvm/paging_tmpl.h
+++ b/arch/x86/kvm/paging_tmpl.h
@@ -306,9 +306,9 @@ static u64 *FNAME(fetch)(struct kvm_vcpu *vcpu, gva_t addr,
 			continue;
 
 		if (is_large_pte(*sptep)) {
+			rmap_remove(vcpu->kvm, sptep);
 			set_shadow_pte(sptep, shadow_trap_nonpresent_pte);
 			kvm_flush_remote_tlbs(vcpu->kvm);
-			rmap_remove(vcpu->kvm, sptep);
 		}
 
 		if (level == PT_DIRECTORY_LEVEL
-- 
1.5.6.4


