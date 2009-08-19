Return-Path: <linux-kernel-owner+w=401wt.eu-S1752798AbZHSNNp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752798AbZHSNNp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Aug 2009 09:13:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752750AbZHSNNn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Aug 2009 09:13:43 -0400
Received: from mx2.redhat.com ([66.187.237.31]:50547 "EHLO mx2.redhat.com"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751890AbZHSNCq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Aug 2009 09:02:46 -0400
From: Avi Kivity <avi@redhat.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 06/47] KVM: MMU audit: audit_mappings tweaks
Date: Wed, 19 Aug 2009 16:02:02 +0300
Message-Id: <1250686963-8357-7-git-send-email-avi@redhat.com>
In-Reply-To: <1250686963-8357-1-git-send-email-avi@redhat.com>
References: <1250686963-8357-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Marcelo Tosatti <mtosatti@redhat.com>

- Fail early in case gfn_to_pfn returns is_error_pfn.
- For the pre pte write case, avoid spurious "gva is valid but spte is notrap"
  messages (the emulation code does the guest write first, so this particular
  case is OK).

Signed-off-by: Marcelo Tosatti <mtosatti@redhat.com>
Signed-off-by: Avi Kivity <avi@redhat.com>
---
 arch/x86/kvm/mmu.c |    8 +++++++-
 1 files changed, 7 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index 8643351..50fe854 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -3117,6 +3117,11 @@ static void audit_mappings_page(struct kvm_vcpu *vcpu, u64 page_pte,
 			pfn_t pfn = gfn_to_pfn(vcpu->kvm, gfn);
 			hpa_t hpa = (hpa_t)pfn << PAGE_SHIFT;
 
+			if (is_error_pfn(pfn)) {
+				kvm_release_pfn_clean(pfn);
+				continue;
+			}
+
 			if (is_shadow_present_pte(ent)
 			    && (ent & PT64_BASE_ADDR_MASK) != hpa)
 				printk(KERN_ERR "xx audit error: (%s) levels %d"
@@ -3288,7 +3293,8 @@ static void kvm_mmu_audit(struct kvm_vcpu *vcpu, const char *msg)
 	audit_msg = msg;
 	audit_rmap(vcpu);
 	audit_write_protection(vcpu);
-	audit_mappings(vcpu);
+	if (strcmp("pre pte write", audit_msg) != 0)
+		audit_mappings(vcpu);
 	audit_writable_sptes_have_rmaps(vcpu);
 	dbg = olddbg;
 }
-- 
1.6.3.3

