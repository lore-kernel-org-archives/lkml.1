Return-Path: <linux-kernel-owner+w=401wt.eu-S1763941AbYDCTl5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763941AbYDCTl5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Apr 2008 15:41:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760898AbYDCTd0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Apr 2008 15:33:26 -0400
Received: from bzq-179-150-194.static.bezeqint.net ([212.179.150.194]:39114
	"EHLO il.qumranet.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756705AbYDCTdA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Apr 2008 15:33:00 -0400
From: Avi Kivity <avi@qumranet.com>
To: kvm-devel@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 28/35] KVM: MMU: Set the accessed bit on non-speculative shadow ptes
Date: Thu,  3 Apr 2008 22:32:43 +0300
Message-Id: <1207251170-5013-29-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.4.5
In-Reply-To: <1207251170-5013-1-git-send-email-avi@qumranet.com>
References: <1207251170-5013-1-git-send-email-avi@qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If we populate a shadow pte due to a fault (and not speculatively due to a
pte write) then we can set the accessed bit on it, as we know it will be
set immediately on the next guest instruction.  This saves a read-modify-write
operation.

Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 arch/x86/kvm/mmu.c         |    8 +++++---
 arch/x86/kvm/paging_tmpl.h |    4 ++--
 2 files changed, 7 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index 072e942..a5872b3 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -1020,7 +1020,7 @@ static void mmu_set_spte(struct kvm_vcpu *vcpu, u64 *shadow_pte,
 			 unsigned pt_access, unsigned pte_access,
 			 int user_fault, int write_fault, int dirty,
 			 int *ptwrite, int largepage, gfn_t gfn,
-			 struct page *page)
+			 struct page *page, bool speculative)
 {
 	u64 spte;
 	int was_rmapped = 0;
@@ -1061,6 +1061,8 @@ static void mmu_set_spte(struct kvm_vcpu *vcpu, u64 *shadow_pte,
 	 * demand paging).
 	 */
 	spte = PT_PRESENT_MASK | PT_DIRTY_MASK;
+	if (!speculative)
+		pte_access |= PT_ACCESSED_MASK;
 	if (!dirty)
 		pte_access &= ~ACC_WRITE_MASK;
 	if (!(pte_access & ACC_EXEC_MASK))
@@ -1148,13 +1150,13 @@ static int __direct_map(struct kvm_vcpu *vcpu, gpa_t v, int write,
 
 		if (level == 1) {
 			mmu_set_spte(vcpu, &table[index], ACC_ALL, ACC_ALL,
-				     0, write, 1, &pt_write, 0, gfn, page);
+				     0, write, 1, &pt_write, 0, gfn, page, false);
 			return pt_write;
 		}
 
 		if (largepage && level == 2) {
 			mmu_set_spte(vcpu, &table[index], ACC_ALL, ACC_ALL,
-				    0, write, 1, &pt_write, 1, gfn, page);
+				     0, write, 1, &pt_write, 1, gfn, page, false);
 			return pt_write;
 		}
 
diff --git a/arch/x86/kvm/paging_tmpl.h b/arch/x86/kvm/paging_tmpl.h
index 57abbd0..e9ae5db 100644
--- a/arch/x86/kvm/paging_tmpl.h
+++ b/arch/x86/kvm/paging_tmpl.h
@@ -266,7 +266,7 @@ static void FNAME(update_pte)(struct kvm_vcpu *vcpu, struct kvm_mmu_page *page,
 	get_page(npage);
 	mmu_set_spte(vcpu, spte, page->role.access, pte_access, 0, 0,
 		     gpte & PT_DIRTY_MASK, NULL, largepage, gpte_to_gfn(gpte),
-		     npage);
+		     npage, true);
 }
 
 /*
@@ -349,7 +349,7 @@ static u64 *FNAME(fetch)(struct kvm_vcpu *vcpu, gva_t addr,
 	mmu_set_spte(vcpu, shadow_ent, access, walker->pte_access & access,
 		     user_fault, write_fault,
 		     walker->ptes[walker->level-1] & PT_DIRTY_MASK,
-		     ptwrite, largepage, walker->gfn, page);
+		     ptwrite, largepage, walker->gfn, page, false);
 
 	return shadow_ent;
 }
-- 
1.5.4.5

