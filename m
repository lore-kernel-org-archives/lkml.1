Return-Path: <linux-kernel-owner+w=401wt.eu-S1757471AbZETLWh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757471AbZETLWh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 May 2009 07:22:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756291AbZETLTN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 May 2009 07:19:13 -0400
Received: from mx2.redhat.com ([66.187.237.31]:55293 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755836AbZETLSv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 May 2009 07:18:51 -0400
From: Avi Kivity <avi@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: kvm@vger.kernel.org
Subject: [PATCH 40/46] KVM: MMU: Fix auditing code
Date: Wed, 20 May 2009 14:18:37 +0300
Message-Id: <1242818323-10413-41-git-send-email-avi@redhat.com>
In-Reply-To: <1242818323-10413-1-git-send-email-avi@redhat.com>
References: <1242818323-10413-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jan Kiszka <jan.kiszka@web.de>

Fix build breakage of hpa lookup in audit_mappings_page. Moreover, make
this function robust against shadow_notrap_nonpresent_pte entries.

Signed-off-by: Jan Kiszka <jan.kiszka@siemens.com>
Signed-off-by: Avi Kivity <avi@redhat.com>
---
 arch/x86/kvm/mmu.c |    8 +++++---
 1 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index 5b79afa..a55373c 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -3030,11 +3030,13 @@ static void audit_mappings_page(struct kvm_vcpu *vcpu, u64 page_pte,
 				       " in nonleaf level: levels %d gva %lx"
 				       " level %d pte %llx\n", audit_msg,
 				       vcpu->arch.mmu.root_level, va, level, ent);
-
-			audit_mappings_page(vcpu, ent, va, level - 1);
+			else
+				audit_mappings_page(vcpu, ent, va, level - 1);
 		} else {
 			gpa_t gpa = vcpu->arch.mmu.gva_to_gpa(vcpu, va);
-			hpa_t hpa = (hpa_t)gpa_to_pfn(vcpu, gpa) << PAGE_SHIFT;
+			gfn_t gfn = gpa >> PAGE_SHIFT;
+			pfn_t pfn = gfn_to_pfn(vcpu->kvm, gfn);
+			hpa_t hpa = (hpa_t)pfn << PAGE_SHIFT;
 
 			if (is_shadow_present_pte(ent)
 			    && (ent & PT64_BASE_ADDR_MASK) != hpa)
-- 
1.6.0.6

