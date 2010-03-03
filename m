Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756137Ab0CCTNi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Mar 2010 14:13:38 -0500
Received: from tx2ehsobe003.messaging.microsoft.com ([65.55.88.13]:48645 "EHLO
	TX2EHSOBE005.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754108Ab0CCTNF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Mar 2010 14:13:05 -0500
X-SpamScore: 2
X-BigFish: VPS2(zz936eM10d1Iab9bhab78ozz1202hzzz32i6bh87h2a8h62h)
X-Spam-TCS-SCL: 1:0
X-FB-DOMAIN-IP-MATCH: fail
X-WSS-ID: 0KYQ01F-01-LMJ-02
X-M-MSG: 
From: Joerg Roedel <joerg.roedel@amd.com>
To: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>
CC: Alexander Graf <agraf@suse.de>, kvm@vger.kernel.org,
       linux-kernel@vger.kernel.org, Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 13/18] KVM: MMU: Introduce Nested MMU context
Date: Wed, 3 Mar 2010 20:12:16 +0100
Message-ID: <1267643541-451-14-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.7.0
In-Reply-To: <1267643541-451-1-git-send-email-joerg.roedel@amd.com>
References: <1267643541-451-1-git-send-email-joerg.roedel@amd.com>
X-OriginalArrivalTime: 03 Mar 2010 19:12:42.0813 (UTC) FILETIME=[7FE07ED0:01CABB05]
MIME-Version: 1.0
Content-Type: text/plain
X-Reverse-DNS: ausb3extmailp02.amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch introduces a second MMU context which will hold
the paging information for the l2 guest.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 arch/x86/include/asm/kvm_host.h |    8 ++++++
 arch/x86/kvm/mmu.c              |   48 ++++++++++++++++++++++++++++++++++++++-
 2 files changed, 55 insertions(+), 1 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 20dd1ce..66a698e 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -264,6 +264,13 @@ struct kvm_mmu {
 
 	u64 *pae_root;
 	u64 rsvd_bits_mask[2][4];
+
+	/*
+	 * If true the mmu runs in two-level mode.
+	 * vcpu->arch.nested_mmu needs to contain meaningful
+	 * values then.
+	 */
+	bool nested;
 };
 
 struct kvm_vcpu_arch {
@@ -296,6 +303,7 @@ struct kvm_vcpu_arch {
 
 	struct kvm_mmu mmu;
 
+	/* This will hold the mmu context of the second level guest */
 	struct kvm_mmu nested_mmu;
 
 	/* only needed in kvm_pv_mmu_op() path, but it's hot so
diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index c831955..ccaf6b1 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -2154,6 +2154,18 @@ static gpa_t translate_gpa(struct kvm_vcpu *vcpu, gpa_t gpa, u32 *error)
 	return gpa;
 }
 
+static gpa_t translate_nested_gpa(struct kvm_vcpu *vcpu, gpa_t gpa, u32 *error)
+{
+	u32 access;
+
+	BUG_ON(!vcpu->arch.mmu.nested);
+
+	/* NPT walks are treated as user writes */
+	access = PFERR_WRITE_MASK | PFERR_USER_MASK;
+
+	return vcpu->arch.nested_mmu.gva_to_gpa(vcpu, gpa, access, error);
+}
+
 static gpa_t nonpaging_gva_to_gpa(struct kvm_vcpu *vcpu, gva_t vaddr,
 				  u32 access, u32 *error)
 {
@@ -2476,11 +2488,45 @@ static int init_kvm_softmmu(struct kvm_vcpu *vcpu)
 	return r;
 }
 
+static int init_kvm_nested_mmu(struct kvm_vcpu *vcpu)
+{
+	struct kvm_mmu *g_context = &vcpu->arch.nested_mmu;
+	struct kvm_mmu *h_context = &vcpu->arch.mmu;
+
+	g_context->get_cr3           = get_cr3;
+	g_context->translate_gpa     = translate_nested_gpa;
+	g_context->inject_page_fault = kvm_inject_page_fault;
+
+	/*
+	 * Note that arch.mmu.gva_to_gpa translates l2_gva to l1_gpa. The
+	 * translation of l2_gpa to l1_gpa addresses is done using the
+	 * arch.nested_mmu.gva_to_gpa function. Basically the gva_to_gpa
+	 * functions between mmu and nested_mmu are swapped.
+	 */
+	if (!is_paging(vcpu)) {
+		g_context->root_level = 0;
+		h_context->gva_to_gpa = nonpaging_gva_to_gpa_nested;
+	} else if (is_long_mode(vcpu)) {
+		g_context->root_level = PT64_ROOT_LEVEL;
+		h_context->gva_to_gpa = paging64_gva_to_gpa_nested;
+	} else if (is_pae(vcpu)) {
+		g_context->root_level = PT32E_ROOT_LEVEL;
+		h_context->gva_to_gpa = paging64_gva_to_gpa_nested;
+	} else {
+		g_context->root_level = PT32_ROOT_LEVEL;
+		h_context->gva_to_gpa = paging32_gva_to_gpa_nested;
+	}
+
+	return 0;
+}
+
 static int init_kvm_mmu(struct kvm_vcpu *vcpu)
 {
 	vcpu->arch.update_pte.pfn = bad_pfn;
 
-	if (tdp_enabled)
+	if (vcpu->arch.mmu.nested)
+		return init_kvm_nested_mmu(vcpu);
+	else if (tdp_enabled)
 		return init_kvm_tdp_mmu(vcpu);
 	else
 		return init_kvm_softmmu(vcpu);
-- 
1.7.0


