Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756234Ab0CCTP6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Mar 2010 14:15:58 -0500
Received: from va3ehsobe001.messaging.microsoft.com ([216.32.180.11]:38763
	"EHLO VA3EHSOBE001.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753935Ab0CCTND (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Mar 2010 14:13:03 -0500
X-SpamScore: 6
X-BigFish: VPS6(z1857rz936eMab9bhzz1202hzzz32i2a8h6bh87h62h)
X-Spam-TCS-SCL: 1:0
X-FB-DOMAIN-IP-MATCH: fail
X-WSS-ID: 0KYQ01B-01-LM8-02
X-M-MSG: 
From: Joerg Roedel <joerg.roedel@amd.com>
To: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>
CC: Alexander Graf <agraf@suse.de>, kvm@vger.kernel.org,
       linux-kernel@vger.kernel.org, Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 09/18] KVM: MMU: Let is_rsvd_bits_set take mmu context instead of vcpu
Date: Wed, 3 Mar 2010 20:12:12 +0100
Message-ID: <1267643541-451-10-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.7.0
In-Reply-To: <1267643541-451-1-git-send-email-joerg.roedel@amd.com>
References: <1267643541-451-1-git-send-email-joerg.roedel@amd.com>
X-OriginalArrivalTime: 03 Mar 2010 19:12:42.0704 (UTC) FILETIME=[7FCFDD00:01CABB05]
MIME-Version: 1.0
Content-Type: text/plain
X-Reverse-DNS: ausb3extmailp02.amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch changes is_rsvd_bits_set() function prototype to
take only a kvm_mmu context instead of a full vcpu.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 arch/x86/kvm/mmu.c         |    4 ++--
 arch/x86/kvm/paging_tmpl.h |    3 ++-
 2 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index 560ecb6..647353d 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -2270,12 +2270,12 @@ static void paging_free(struct kvm_vcpu *vcpu)
 	nonpaging_free(vcpu);
 }
 
-static bool is_rsvd_bits_set(struct kvm_vcpu *vcpu, u64 gpte, int level)
+static bool is_rsvd_bits_set(struct kvm_mmu *mmu, u64 gpte, int level)
 {
 	int bit7;
 
 	bit7 = (gpte >> 7) & 1;
-	return (gpte & vcpu->arch.mmu.rsvd_bits_mask[bit7][level-1]) != 0;
+	return (gpte & mmu->rsvd_bits_mask[bit7][level-1]) != 0;
 }
 
 #define PTTYPE 64
diff --git a/arch/x86/kvm/paging_tmpl.h b/arch/x86/kvm/paging_tmpl.h
index 1149daa..8608439 100644
--- a/arch/x86/kvm/paging_tmpl.h
+++ b/arch/x86/kvm/paging_tmpl.h
@@ -158,7 +158,8 @@ walk:
 		if (!is_present_gpte(pte))
 			goto not_present;
 
-		rsvd_fault = is_rsvd_bits_set(vcpu, pte, walker->level);
+		rsvd_fault = is_rsvd_bits_set(&vcpu->arch.mmu, pte,
+					      walker->level);
 		if (rsvd_fault)
 			goto access_error;
 
-- 
1.7.0


