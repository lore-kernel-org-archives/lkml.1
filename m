Return-Path: <linux-kernel-owner+w=401wt.eu-S1752063AbZHSNCv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752063AbZHSNCv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Aug 2009 09:02:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751991AbZHSNCt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Aug 2009 09:02:49 -0400
Received: from mx2.redhat.com ([66.187.237.31]:50543 "EHLO mx2.redhat.com"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751836AbZHSNCo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Aug 2009 09:02:44 -0400
From: Avi Kivity <avi@redhat.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 02/47] KVM: MMU: introduce is_last_spte helper
Date: Wed, 19 Aug 2009 16:01:58 +0300
Message-Id: <1250686963-8357-3-git-send-email-avi@redhat.com>
In-Reply-To: <1250686963-8357-1-git-send-email-avi@redhat.com>
References: <1250686963-8357-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Marcelo Tosatti <mtosatti@redhat.com>

Hiding some of the last largepage / level interaction (which is useful
for gbpages and for zero based levels).

Also merge the PT_PAGE_TABLE_LEVEL clearing loop in unlink_children.

Signed-off-by: Marcelo Tosatti <mtosatti@redhat.com>
Signed-off-by: Avi Kivity <avi@redhat.com>
---
 arch/x86/kvm/mmu.c |   26 +++++++++++++-------------
 1 files changed, 13 insertions(+), 13 deletions(-)

diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index b6e4cda..f85d995 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -250,6 +250,15 @@ static int is_rmap_spte(u64 pte)
 	return is_shadow_present_pte(pte);
 }
 
+static int is_last_spte(u64 pte, int level)
+{
+	if (level == PT_PAGE_TABLE_LEVEL)
+		return 1;
+	if (level == PT_DIRECTORY_LEVEL && is_large_pte(pte))
+		return 1;
+	return 0;
+}
+
 static pfn_t spte_to_pfn(u64 pte)
 {
 	return (pte & PT64_BASE_ADDR_MASK) >> PAGE_SHIFT;
@@ -1313,25 +1322,17 @@ static void kvm_mmu_page_unlink_children(struct kvm *kvm,
 
 	pt = sp->spt;
 
-	if (sp->role.level == PT_PAGE_TABLE_LEVEL) {
-		for (i = 0; i < PT64_ENT_PER_PAGE; ++i) {
-			if (is_shadow_present_pte(pt[i]))
-				rmap_remove(kvm, &pt[i]);
-			pt[i] = shadow_trap_nonpresent_pte;
-		}
-		return;
-	}
-
 	for (i = 0; i < PT64_ENT_PER_PAGE; ++i) {
 		ent = pt[i];
 
 		if (is_shadow_present_pte(ent)) {
-			if (!is_large_pte(ent)) {
+			if (!is_last_spte(ent, sp->role.level)) {
 				ent &= PT64_BASE_ADDR_MASK;
 				mmu_page_remove_parent_pte(page_header(ent),
 							   &pt[i]);
 			} else {
-				--kvm->stat.lpages;
+				if (is_large_pte(ent))
+					--kvm->stat.lpages;
 				rmap_remove(kvm, &pt[i]);
 			}
 		}
@@ -2381,8 +2382,7 @@ static void mmu_pte_write_zap_pte(struct kvm_vcpu *vcpu,
 
 	pte = *spte;
 	if (is_shadow_present_pte(pte)) {
-		if (sp->role.level == PT_PAGE_TABLE_LEVEL ||
-		    is_large_pte(pte))
+		if (is_last_spte(pte, sp->role.level))
 			rmap_remove(vcpu->kvm, spte);
 		else {
 			child = page_header(pte & PT64_BASE_ADDR_MASK);
-- 
1.6.3.3

