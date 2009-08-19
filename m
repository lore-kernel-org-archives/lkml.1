Return-Path: <linux-kernel-owner+w=401wt.eu-S1752781AbZHSNM6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752781AbZHSNM6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Aug 2009 09:12:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751898AbZHSNM4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Aug 2009 09:12:56 -0400
Received: from mx2.redhat.com ([66.187.237.31]:50548 "EHLO mx2.redhat.com"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751882AbZHSNCq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Aug 2009 09:02:46 -0400
From: Avi Kivity <avi@redhat.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 07/47] KVM: MMU audit: largepage handling
Date: Wed, 19 Aug 2009 16:02:03 +0300
Message-Id: <1250686963-8357-8-git-send-email-avi@redhat.com>
In-Reply-To: <1250686963-8357-1-git-send-email-avi@redhat.com>
References: <1250686963-8357-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Marcelo Tosatti <mtosatti@redhat.com>

Make the audit code aware of largepages.

Signed-off-by: Marcelo Tosatti <mtosatti@redhat.com>
Signed-off-by: Avi Kivity <avi@redhat.com>
---
 arch/x86/kvm/mmu.c |   15 +++++++--------
 1 files changed, 7 insertions(+), 8 deletions(-)

diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index 50fe854..780ce3f 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -3058,12 +3058,11 @@ static void __mmu_spte_walk(struct kvm *kvm, struct kvm_mmu_page *sp,
 		u64 ent = sp->spt[i];
 
 		if (is_shadow_present_pte(ent)) {
-			if (sp->role.level > 1 && !is_large_pte(ent)) {
+			if (!is_last_spte(ent, sp->role.level)) {
 				struct kvm_mmu_page *child;
 				child = page_header(ent & PT64_BASE_ADDR_MASK);
 				__mmu_spte_walk(kvm, child, fn);
-			}
-			if (sp->role.level == 1)
+			} else
 				fn(kvm, sp, &sp->spt[i]);
 		}
 	}
@@ -3108,10 +3107,9 @@ static void audit_mappings_page(struct kvm_vcpu *vcpu, u64 page_pte,
 			continue;
 
 		va = canonicalize(va);
-		if (level > 1) {
-			if (is_shadow_present_pte(ent))
-				audit_mappings_page(vcpu, ent, va, level - 1);
-		} else {
+		if (is_shadow_present_pte(ent) && !is_last_spte(ent, level))
+			audit_mappings_page(vcpu, ent, va, level - 1);
+		else {
 			gpa_t gpa = vcpu->arch.mmu.gva_to_gpa(vcpu, va);
 			gfn_t gfn = gpa >> PAGE_SHIFT;
 			pfn_t pfn = gfn_to_pfn(vcpu->kvm, gfn);
@@ -3208,7 +3206,8 @@ void inspect_spte_has_rmap(struct kvm *kvm, struct kvm_mmu_page *sp, u64 *sptep)
 			return;
 		}
 
-		rmapp = gfn_to_rmap(kvm, rev_sp->gfns[sptep - rev_sp->spt], 0);
+		rmapp = gfn_to_rmap(kvm, rev_sp->gfns[sptep - rev_sp->spt],
+				    is_large_pte(*sptep));
 		if (!*rmapp) {
 			if (!printk_ratelimit())
 				return;
-- 
1.6.3.3

