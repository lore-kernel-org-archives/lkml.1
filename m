Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756261Ab0CCTQR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Mar 2010 14:16:17 -0500
Received: from va3ehsobe003.messaging.microsoft.com ([216.32.180.13]:53733
	"EHLO VA3EHSOBE003.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753513Ab0CCTNB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Mar 2010 14:13:01 -0500
X-SpamScore: -4
X-BigFish: VPS-4(zz936eMab9bhzz1202hzzz32i87h2a8h6bh65h)
X-Spam-TCS-SCL: 4:0
X-FB-DOMAIN-IP-MATCH: fail
X-WSS-ID: 0KYQ019-02-H58-02
X-M-MSG: 
From: Joerg Roedel <joerg.roedel@amd.com>
To: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>
CC: Alexander Graf <agraf@suse.de>, kvm@vger.kernel.org,
       linux-kernel@vger.kernel.org, Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 08/18] KVM: MMU: Change init_kvm_softmmu to take a context as parameter
Date: Wed, 3 Mar 2010 20:12:11 +0100
Message-ID: <1267643541-451-9-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.7.0
In-Reply-To: <1267643541-451-1-git-send-email-joerg.roedel@amd.com>
References: <1267643541-451-1-git-send-email-joerg.roedel@amd.com>
X-OriginalArrivalTime: 03 Mar 2010 19:12:42.0673 (UTC) FILETIME=[7FCB2210:01CABB05]
MIME-Version: 1.0
Content-Type: text/plain
X-Reverse-DNS: ausb3extmailp02.amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some logic of this function is required to build the Nested
Nested Paging context. So factor the required logic into a
seperate function and export it.
Also make the whole init path suitable for more than one mmu
context.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 arch/x86/kvm/mmu.c |   60 ++++++++++++++++++++++++++++++---------------------
 arch/x86/kvm/mmu.h |    1 +
 2 files changed, 36 insertions(+), 25 deletions(-)

diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index 8f835f1..560ecb6 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -2225,10 +2225,9 @@ static void nonpaging_free(struct kvm_vcpu *vcpu)
 	mmu_free_roots(vcpu);
 }
 
-static int nonpaging_init_context(struct kvm_vcpu *vcpu)
+static int nonpaging_init_context(struct kvm_vcpu *vcpu,
+				  struct kvm_mmu *context)
 {
-	struct kvm_mmu *context = &vcpu->arch.mmu;
-
 	context->new_cr3 = nonpaging_new_cr3;
 	context->page_fault = nonpaging_page_fault;
 	context->gva_to_gpa = nonpaging_gva_to_gpa;
@@ -2287,9 +2286,10 @@ static bool is_rsvd_bits_set(struct kvm_vcpu *vcpu, u64 gpte, int level)
 #include "paging_tmpl.h"
 #undef PTTYPE
 
-static void reset_rsvds_bits_mask(struct kvm_vcpu *vcpu, int level)
+static void reset_rsvds_bits_mask(struct kvm_vcpu *vcpu,
+				  struct kvm_mmu *context,
+				  int level)
 {
-	struct kvm_mmu *context = &vcpu->arch.mmu;
 	int maxphyaddr = cpuid_maxphyaddr(vcpu);
 	u64 exb_bit_rsvd = 0;
 
@@ -2342,9 +2342,11 @@ static void reset_rsvds_bits_mask(struct kvm_vcpu *vcpu, int level)
 	}
 }
 
-static int paging64_init_context_common(struct kvm_vcpu *vcpu, int level)
+static int paging64_init_context_common(struct kvm_vcpu *vcpu,
+					struct kvm_mmu *context,
+					int level)
 {
-	struct kvm_mmu *context = &vcpu->arch.mmu;
+	reset_rsvds_bits_mask(vcpu, context, level);
 
 	ASSERT(is_pae(vcpu));
 	context->new_cr3 = paging_new_cr3;
@@ -2360,17 +2362,17 @@ static int paging64_init_context_common(struct kvm_vcpu *vcpu, int level)
 	return 0;
 }
 
-static int paging64_init_context(struct kvm_vcpu *vcpu)
+static int paging64_init_context(struct kvm_vcpu *vcpu,
+				 struct kvm_mmu *context)
 {
-	reset_rsvds_bits_mask(vcpu, PT64_ROOT_LEVEL);
-	return paging64_init_context_common(vcpu, PT64_ROOT_LEVEL);
+	return paging64_init_context_common(vcpu, context, PT64_ROOT_LEVEL);
 }
 
-static int paging32_init_context(struct kvm_vcpu *vcpu)
+static int paging32_init_context(struct kvm_vcpu *vcpu,
+				 struct kvm_mmu *context)
 {
-	struct kvm_mmu *context = &vcpu->arch.mmu;
+	reset_rsvds_bits_mask(vcpu, context, PT32_ROOT_LEVEL);
 
-	reset_rsvds_bits_mask(vcpu, PT32_ROOT_LEVEL);
 	context->new_cr3 = paging_new_cr3;
 	context->page_fault = paging32_page_fault;
 	context->gva_to_gpa = paging32_gva_to_gpa;
@@ -2384,10 +2386,10 @@ static int paging32_init_context(struct kvm_vcpu *vcpu)
 	return 0;
 }
 
-static int paging32E_init_context(struct kvm_vcpu *vcpu)
+static int paging32E_init_context(struct kvm_vcpu *vcpu,
+				  struct kvm_mmu *context)
 {
-	reset_rsvds_bits_mask(vcpu, PT32E_ROOT_LEVEL);
-	return paging64_init_context_common(vcpu, PT32E_ROOT_LEVEL);
+	return paging64_init_context_common(vcpu, context, PT32E_ROOT_LEVEL);
 }
 
 static int init_kvm_tdp_mmu(struct kvm_vcpu *vcpu)
@@ -2410,15 +2412,15 @@ static int init_kvm_tdp_mmu(struct kvm_vcpu *vcpu)
 		context->gva_to_gpa = nonpaging_gva_to_gpa;
 		context->root_level = 0;
 	} else if (is_long_mode(vcpu)) {
-		reset_rsvds_bits_mask(vcpu, PT64_ROOT_LEVEL);
+		reset_rsvds_bits_mask(vcpu, context, PT64_ROOT_LEVEL);
 		context->gva_to_gpa = paging64_gva_to_gpa;
 		context->root_level = PT64_ROOT_LEVEL;
 	} else if (is_pae(vcpu)) {
-		reset_rsvds_bits_mask(vcpu, PT32E_ROOT_LEVEL);
+		reset_rsvds_bits_mask(vcpu, context, PT32E_ROOT_LEVEL);
 		context->gva_to_gpa = paging64_gva_to_gpa;
 		context->root_level = PT32E_ROOT_LEVEL;
 	} else {
-		reset_rsvds_bits_mask(vcpu, PT32_ROOT_LEVEL);
+		reset_rsvds_bits_mask(vcpu, context, PT32_ROOT_LEVEL);
 		context->gva_to_gpa = paging32_gva_to_gpa;
 		context->root_level = PT32_ROOT_LEVEL;
 	}
@@ -2426,24 +2428,32 @@ static int init_kvm_tdp_mmu(struct kvm_vcpu *vcpu)
 	return 0;
 }
 
-static int init_kvm_softmmu(struct kvm_vcpu *vcpu)
+int kvm_init_shadow_mmu(struct kvm_vcpu *vcpu, struct kvm_mmu *context)
 {
 	int r;
-
 	ASSERT(vcpu);
 	ASSERT(!VALID_PAGE(vcpu->arch.mmu.root_hpa));
 
 	if (!is_paging(vcpu))
-		r = nonpaging_init_context(vcpu);
+		r = nonpaging_init_context(vcpu, context);
 	else if (is_long_mode(vcpu))
-		r = paging64_init_context(vcpu);
+		r = paging64_init_context(vcpu, context);
 	else if (is_pae(vcpu))
-		r = paging32E_init_context(vcpu);
+		r = paging32E_init_context(vcpu, context);
 	else
-		r = paging32_init_context(vcpu);
+		r = paging32_init_context(vcpu, context);
 
 	vcpu->arch.mmu.base_role.glevels = vcpu->arch.mmu.root_level;
 	vcpu->arch.mmu.tdp_enabled       = false;
+
+	return r;
+}
+EXPORT_SYMBOL_GPL(kvm_init_shadow_mmu);
+
+static int init_kvm_softmmu(struct kvm_vcpu *vcpu)
+{
+	int r = kvm_init_shadow_mmu(vcpu, &vcpu->arch.mmu);
+
 	vcpu->arch.mmu.set_cr3           = kvm_x86_ops->set_cr3;
 	vcpu->arch.mmu.get_cr3           = get_cr3;
 	vcpu->arch.mmu.inject_page_fault = kvm_inject_page_fault;
diff --git a/arch/x86/kvm/mmu.h b/arch/x86/kvm/mmu.h
index be66759..64f619b 100644
--- a/arch/x86/kvm/mmu.h
+++ b/arch/x86/kvm/mmu.h
@@ -49,6 +49,7 @@
 #define PFERR_FETCH_MASK (1U << 4)
 
 int kvm_mmu_get_spte_hierarchy(struct kvm_vcpu *vcpu, u64 addr, u64 sptes[4]);
+int kvm_init_shadow_mmu(struct kvm_vcpu *vcpu, struct kvm_mmu *context);
 
 static inline void kvm_mmu_free_some_pages(struct kvm_vcpu *vcpu)
 {
-- 
1.7.0


