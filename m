Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756203Ab0CCTO1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Mar 2010 14:14:27 -0500
Received: from va3ehsobe001.messaging.microsoft.com ([216.32.180.11]:42018
	"EHLO VA3EHSOBE001.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756172Ab0CCTOB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Mar 2010 14:14:01 -0500
X-SpamScore: 3
X-BigFish: VPS3(zz936eMab9bhab78ozz1202hzzz32i2a8h87h6bh62h)
X-Spam-TCS-SCL: 1:0
X-FB-DOMAIN-IP-MATCH: fail
X-WSS-ID: 0KYQ01B-02-H5E-02
X-M-MSG: 
From: Joerg Roedel <joerg.roedel@amd.com>
To: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>
CC: Alexander Graf <agraf@suse.de>, kvm@vger.kernel.org,
       linux-kernel@vger.kernel.org, Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 11/18] KVM: MMU: Add infrastructure for two-level page walker
Date: Wed, 3 Mar 2010 20:12:14 +0100
Message-ID: <1267643541-451-12-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.7.0
In-Reply-To: <1267643541-451-1-git-send-email-joerg.roedel@amd.com>
References: <1267643541-451-1-git-send-email-joerg.roedel@amd.com>
X-OriginalArrivalTime: 03 Mar 2010 19:12:42.0735 (UTC) FILETIME=[7FD497F0:01CABB05]
MIME-Version: 1.0
Content-Type: text/plain
X-Reverse-DNS: ausb3extmailp02.amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch introduces a mmu-callback to translate gpa
addresses in the walk_addr code. This is later used to
translate l2_gpa addresses into l1_gpa addresses.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 arch/x86/include/asm/kvm_host.h |    1 +
 arch/x86/kvm/mmu.c              |    7 +++++++
 arch/x86/kvm/paging_tmpl.h      |   19 +++++++++++++++++++
 include/linux/kvm_host.h        |    5 +++++
 4 files changed, 32 insertions(+), 0 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index c0b5576..76c8b5f 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -250,6 +250,7 @@ struct kvm_mmu {
 	void (*free)(struct kvm_vcpu *vcpu);
 	gpa_t (*gva_to_gpa)(struct kvm_vcpu *vcpu, gva_t gva, u32 access,
 			    u32 *error);
+	gpa_t (*translate_gpa)(struct kvm_vcpu *vcpu, gpa_t gpa, u32 *error);
 	void (*prefetch_page)(struct kvm_vcpu *vcpu,
 			      struct kvm_mmu_page *page);
 	int (*sync_page)(struct kvm_vcpu *vcpu,
diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index 647353d..ec3830c 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -2149,6 +2149,11 @@ void kvm_mmu_sync_roots(struct kvm_vcpu *vcpu)
 	spin_unlock(&vcpu->kvm->mmu_lock);
 }
 
+static gpa_t translate_gpa(struct kvm_vcpu *vcpu, gpa_t gpa, u32 *error)
+{
+	return gpa;
+}
+
 static gpa_t nonpaging_gva_to_gpa(struct kvm_vcpu *vcpu, gva_t vaddr,
 				  u32 access, u32 *error)
 {
@@ -2399,6 +2404,7 @@ static int init_kvm_tdp_mmu(struct kvm_vcpu *vcpu)
 	context->new_cr3 = nonpaging_new_cr3;
 	context->page_fault = tdp_page_fault;
 	context->free = nonpaging_free;
+	context->translate_gpa = translate_gpa;
 	context->prefetch_page = nonpaging_prefetch_page;
 	context->sync_page = nonpaging_sync_page;
 	context->invlpg = nonpaging_invlpg;
@@ -2443,6 +2449,7 @@ int kvm_init_shadow_mmu(struct kvm_vcpu *vcpu, struct kvm_mmu *context)
 	else
 		r = paging32_init_context(vcpu, context);
 
+	vcpu->arch.mmu.translate_gpa = translate_gpa;
 	vcpu->arch.mmu.base_role.glevels = vcpu->arch.mmu.root_level;
 	vcpu->arch.mmu.tdp_enabled       = false;
 
diff --git a/arch/x86/kvm/paging_tmpl.h b/arch/x86/kvm/paging_tmpl.h
index 6c55a31..a72d5ea 100644
--- a/arch/x86/kvm/paging_tmpl.h
+++ b/arch/x86/kvm/paging_tmpl.h
@@ -122,6 +122,7 @@ static int FNAME(walk_addr_generic)(struct guest_walker *walker,
 	unsigned index, pt_access, pte_access;
 	gpa_t pte_gpa;
 	int rsvd_fault = 0;
+	u32 error;
 
 	trace_kvm_mmu_pagetable_walk(addr, write_fault, user_fault,
 				     fetch_fault);
@@ -150,6 +151,15 @@ walk:
 		table_gfn = gpte_to_gfn(pte);
 		pte_gpa = gfn_to_gpa(table_gfn);
 		pte_gpa += index * sizeof(pt_element_t);
+
+		pte_gpa = mmu->translate_gpa(vcpu, pte_gpa, &error);
+		if (pte_gpa == UNMAPPED_GVA) {
+			walker->error_code = error;
+			return 0;
+		}
+		/* pte_gpa might have changed - recalculate table_gfn */
+		table_gfn = gpa_to_gfn(pte_gpa);
+
 		walker->table_gfn[walker->level - 1] = table_gfn;
 		walker->pte_gpa[walker->level - 1] = pte_gpa;
 
@@ -209,6 +219,15 @@ walk:
 			    is_cpuid_PSE36())
 				walker->gfn += pse36_gfn_delta(pte);
 
+			/* Do the final translation */
+			pte_gpa = gfn_to_gpa(walker->gfn);
+			pte_gpa = mmu->translate_gpa(vcpu, pte_gpa, &error);
+			if (pte_gpa == UNMAPPED_GVA) {
+				walker->error_code = error;
+				return 0;
+			}
+			walker->gfn = gpa_to_gfn(pte_gpa);
+
 			break;
 		}
 
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index a3fd0f9..ef2e81a 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -503,6 +503,11 @@ static inline gpa_t gfn_to_gpa(gfn_t gfn)
 	return (gpa_t)gfn << PAGE_SHIFT;
 }
 
+static inline gfn_t gpa_to_gfn(gpa_t gpa)
+{
+	return (gfn_t)gpa >> PAGE_SHIFT;
+}
+
 static inline hpa_t pfn_to_hpa(pfn_t pfn)
 {
 	return (hpa_t)pfn << PAGE_SHIFT;
-- 
1.7.0


