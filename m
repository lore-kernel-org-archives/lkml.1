Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754963Ab0CCTO6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Mar 2010 14:14:58 -0500
Received: from tx2ehsobe002.messaging.microsoft.com ([65.55.88.12]:8275 "EHLO
	TX2EHSOBE004.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756127Ab0CCTNg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Mar 2010 14:13:36 -0500
X-SpamScore: -4
X-BigFish: VPS-4(zz936eMab9bhzz1202hzzz32i6bh2a8h87h64h)
X-Spam-TCS-SCL: 3:0
X-FB-DOMAIN-IP-MATCH: fail
X-WSS-ID: 0KYQ018-01-LM1-02
X-M-MSG: 
From: Joerg Roedel <joerg.roedel@amd.com>
To: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>
CC: Alexander Graf <agraf@suse.de>, kvm@vger.kernel.org,
       linux-kernel@vger.kernel.org, Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 05/18] KVM: MMU: Introduce get_cr3 function pointer
Date: Wed, 3 Mar 2010 20:12:08 +0100
Message-ID: <1267643541-451-6-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.7.0
In-Reply-To: <1267643541-451-1-git-send-email-joerg.roedel@amd.com>
References: <1267643541-451-1-git-send-email-joerg.roedel@amd.com>
X-OriginalArrivalTime: 03 Mar 2010 19:12:42.0657 (UTC) FILETIME=[7FC8B110:01CABB05]
MIME-Version: 1.0
Content-Type: text/plain
X-Reverse-DNS: ausb3extmailp02.amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This function pointer in the MMU context is required to
implement Nested Nested Paging.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 arch/x86/include/asm/kvm_host.h |    1 +
 arch/x86/kvm/mmu.c              |    9 ++++++++-
 arch/x86/kvm/paging_tmpl.h      |    4 ++--
 3 files changed, 11 insertions(+), 3 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 1bf8501..37d0145 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -242,6 +242,7 @@ struct kvm_pio_request {
 struct kvm_mmu {
 	void (*new_cr3)(struct kvm_vcpu *vcpu);
 	void (*set_cr3)(struct kvm_vcpu *vcpu, unsigned long root);
+	unsigned long (*get_cr3)(struct kvm_vcpu *vcpu);
 	int (*page_fault)(struct kvm_vcpu *vcpu, gva_t gva, u32 err);
 	void (*free)(struct kvm_vcpu *vcpu);
 	gpa_t (*gva_to_gpa)(struct kvm_vcpu *vcpu, gva_t gva, u32 access,
diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index 84e3209..189c68d 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -2071,7 +2071,7 @@ static int mmu_alloc_roots(struct kvm_vcpu *vcpu)
 	int direct = 0;
 	u64 pdptr;
 
-	root_gfn = vcpu->arch.cr3 >> PAGE_SHIFT;
+	root_gfn = vcpu->arch.mmu.get_cr3(vcpu) >> PAGE_SHIFT;
 
 	if (vcpu->arch.mmu.shadow_root_level == PT64_ROOT_LEVEL) {
 		hpa_t root = vcpu->arch.mmu.root_hpa;
@@ -2254,6 +2254,11 @@ static void paging_new_cr3(struct kvm_vcpu *vcpu)
 	mmu_free_roots(vcpu);
 }
 
+static unsigned long get_cr3(struct kvm_vcpu *vcpu)
+{
+	return vcpu->arch.cr3;
+}
+
 static void inject_page_fault(struct kvm_vcpu *vcpu,
 			      u64 addr,
 			      u32 err_code)
@@ -2399,6 +2404,7 @@ static int init_kvm_tdp_mmu(struct kvm_vcpu *vcpu)
 	context->root_hpa = INVALID_PAGE;
 	vcpu->arch.mmu.tdp_enabled = true;
 	vcpu->arch.mmu.set_cr3 = kvm_x86_ops->set_tdp_cr3;
+	vcpu->arch.mmu.get_cr3 = get_cr3;
 
 	if (!is_paging(vcpu)) {
 		context->gva_to_gpa = nonpaging_gva_to_gpa;
@@ -2439,6 +2445,7 @@ static int init_kvm_softmmu(struct kvm_vcpu *vcpu)
 	vcpu->arch.mmu.base_role.glevels = vcpu->arch.mmu.root_level;
 	vcpu->arch.mmu.tdp_enabled       = false;
 	vcpu->arch.mmu.set_cr3           = kvm_x86_ops->set_cr3;
+	vcpu->arch.mmu.get_cr3           = get_cr3;
 
 	return r;
 }
diff --git a/arch/x86/kvm/paging_tmpl.h b/arch/x86/kvm/paging_tmpl.h
index 92b6bb5..1149daa 100644
--- a/arch/x86/kvm/paging_tmpl.h
+++ b/arch/x86/kvm/paging_tmpl.h
@@ -126,7 +126,7 @@ static int FNAME(walk_addr)(struct guest_walker *walker,
 				     fetch_fault);
 walk:
 	walker->level = vcpu->arch.mmu.root_level;
-	pte = vcpu->arch.cr3;
+	pte = vcpu->arch.mmu.get_cr3(vcpu);
 #if PTTYPE == 64
 	if (vcpu->arch.mmu.root_level == PT32E_ROOT_LEVEL) {
 		pte = kvm_pdptr_read(vcpu, (addr >> 30) & 3);
@@ -137,7 +137,7 @@ walk:
 	}
 #endif
 	ASSERT((!is_long_mode(vcpu) && is_pae(vcpu)) ||
-	       (vcpu->arch.cr3 & CR3_NONPAE_RESERVED_BITS) == 0);
+	       (vcpu->arch.mmu.get_cr3(vcpu) & CR3_NONPAE_RESERVED_BITS) == 0);
 
 	pt_access = ACC_ALL;
 
-- 
1.7.0


