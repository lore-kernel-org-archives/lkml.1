Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754448Ab0CCTP2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Mar 2010 14:15:28 -0500
Received: from tx2ehsobe002.messaging.microsoft.com ([65.55.88.12]:5579 "EHLO
	TX2EHSOBE003.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754736Ab0CCTNS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Mar 2010 14:13:18 -0500
X-SpamScore: -4
X-BigFish: VPS-4(zz936eMab9bhzz1202hzzz32i6bh2a8h87h43h66h)
X-Spam-TCS-SCL: 5:0
X-FB-DOMAIN-IP-MATCH: fail
X-WSS-ID: 0KYQ015-02-H50-02
X-M-MSG: 
From: Joerg Roedel <joerg.roedel@amd.com>
To: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>
CC: Alexander Graf <agraf@suse.de>, kvm@vger.kernel.org,
       linux-kernel@vger.kernel.org, Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 02/18] KVM: MMU: Make tdp_enabled a mmu-context parameter
Date: Wed, 3 Mar 2010 20:12:05 +0100
Message-ID: <1267643541-451-3-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.7.0
In-Reply-To: <1267643541-451-1-git-send-email-joerg.roedel@amd.com>
References: <1267643541-451-1-git-send-email-joerg.roedel@amd.com>
X-OriginalArrivalTime: 03 Mar 2010 19:12:42.0454 (UTC) FILETIME=[7FA9B760:01CABB05]
MIME-Version: 1.0
Content-Type: text/plain
X-Reverse-DNS: unknown
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch changes the tdp_enabled flag from its global
meaning to the mmu-context. This is necessary for Nested SVM
with emulation of Nested Paging where we need an extra MMU
context to shadow the Nested Nested Page Table.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 arch/x86/include/asm/kvm_host.h |    1 +
 arch/x86/kvm/mmu.c              |    8 +++++---
 2 files changed, 6 insertions(+), 3 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index ec891a2..e7bef19 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -254,6 +254,7 @@ struct kvm_mmu {
 	int root_level;
 	int shadow_root_level;
 	union kvm_mmu_page_role base_role;
+	bool tdp_enabled;
 
 	u64 *pae_root;
 	u64 rsvd_bits_mask[2][4];
diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index 741373e..5c66c99 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -1812,7 +1812,7 @@ static int set_spte(struct kvm_vcpu *vcpu, u64 *sptep,
 		spte |= shadow_user_mask;
 	if (level > PT_PAGE_TABLE_LEVEL)
 		spte |= PT_PAGE_SIZE_MASK;
-	if (tdp_enabled)
+	if (vcpu->arch.mmu.tdp_enabled)
 		spte |= kvm_x86_ops->get_mt_mask(vcpu, gfn,
 			kvm_is_mmio_pfn(pfn));
 
@@ -2077,7 +2077,7 @@ static int mmu_alloc_roots(struct kvm_vcpu *vcpu)
 		hpa_t root = vcpu->arch.mmu.root_hpa;
 
 		ASSERT(!VALID_PAGE(root));
-		if (tdp_enabled)
+		if (vcpu->arch.mmu.tdp_enabled)
 			direct = 1;
 		if (mmu_check_root(vcpu, root_gfn))
 			return 1;
@@ -2090,7 +2090,7 @@ static int mmu_alloc_roots(struct kvm_vcpu *vcpu)
 		return 0;
 	}
 	direct = !is_paging(vcpu);
-	if (tdp_enabled)
+	if (vcpu->arch.mmu.tdp_enabled)
 		direct = 1;
 	for (i = 0; i < 4; ++i) {
 		hpa_t root = vcpu->arch.mmu.pae_root[i];
@@ -2397,6 +2397,7 @@ static int init_kvm_tdp_mmu(struct kvm_vcpu *vcpu)
 	context->invlpg = nonpaging_invlpg;
 	context->shadow_root_level = kvm_x86_ops->get_tdp_level();
 	context->root_hpa = INVALID_PAGE;
+	vcpu->arch.mmu.tdp_enabled = true;
 
 	if (!is_paging(vcpu)) {
 		context->gva_to_gpa = nonpaging_gva_to_gpa;
@@ -2435,6 +2436,7 @@ static int init_kvm_softmmu(struct kvm_vcpu *vcpu)
 		r = paging32_init_context(vcpu);
 
 	vcpu->arch.mmu.base_role.glevels = vcpu->arch.mmu.root_level;
+	vcpu->arch.mmu.tdp_enabled       = false;
 
 	return r;
 }
-- 
1.7.0


