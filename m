Return-Path: <linux-kernel-owner+w=401wt.eu-S933230AbXDAOlO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933230AbXDAOlO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Apr 2007 10:41:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933277AbXDAOjt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Apr 2007 10:39:49 -0400
Received: from il.qumranet.com ([82.166.9.18]:47566 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933230AbXDAOfp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Apr 2007 10:35:45 -0400
From: Avi Kivity <avi@qumranet.com>
To: kvm-devel@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org, Avi Kivity <avi@qumranet.com>
Subject: [PATCH 22/41] KVM: MMU: Remove global pte tracking
Date: Sun,  1 Apr 2007 17:35:19 +0300
Message-Id: <117543813916-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.0.5
In-Reply-To: <11754381392186-git-send-email-avi@qumranet.com>
References: <1175438138288-git-send-email-avi@qumranet.com> <11754381381990-git-send-email-avi@qumranet.com> <11754381384009-git-send-email-avi@qumranet.com> <1175438138805-git-send-email-avi@qumranet.com> <11754381382515-git-send-email-avi@qumranet.com> <11754381383730-git-send-email-avi@qumranet.com> <11754381383144-git-send-email-avi@qumranet.com> <11754381381597-git-send-email-avi@qumranet.com> <1175438139242-git-send-email-avi@qumranet.com> <1175438139494-git-send-email-avi@qumranet.com> <11754381392046-git-send-email-avi@qumranet.com> <1175438139795-git-send-email-avi@qumranet.com> <1175438139430-git-send-email-avi@qumranet.com> <11754381393496-git-send-email-avi@qumranet.com> <11754381391514-git-send-email-avi@qumranet.com> <11754381392382-git-send-email-avi@qumranet.com> <11754381392358-git-send-email-avi@qumranet.com> <1175438139872-git-send-email-avi@qumranet.com> <11754381392921-git-send-email-avi@qumranet.com> <117543813978-git-send-email-avi@qumranet.com> <117543
 81393061-git-send-email-avi@qumranet.com> <11754381392186-git-send-email-avi@qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

The initial, noncaching, version of the kvm mmu flushed the all nonglobal
shadow page table translations (much like a native tlb flush).  The new
implementation flushes translations only when they change, rendering global
pte tracking superfluous.

This removes the unused tracking mechanism and storage space.

Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 drivers/kvm/kvm.h |    1 -
 drivers/kvm/mmu.c |    9 ---------
 2 files changed, 0 insertions(+), 10 deletions(-)

diff --git a/drivers/kvm/kvm.h b/drivers/kvm/kvm.h
index 7866b34..a4331da 100644
--- a/drivers/kvm/kvm.h
+++ b/drivers/kvm/kvm.h
@@ -136,7 +136,6 @@ struct kvm_mmu_page {
 	unsigned long slot_bitmap; /* One bit set per slot which has memory
 				    * in this shadow page.
 				    */
-	int global;              /* Set if all ptes in this page are global */
 	int multimapped;         /* More than one parent_pte? */
 	int root_count;          /* Currently serving as active root */
 	union {
diff --git a/drivers/kvm/mmu.c b/drivers/kvm/mmu.c
index e8e2750..b181106 100644
--- a/drivers/kvm/mmu.c
+++ b/drivers/kvm/mmu.c
@@ -461,7 +461,6 @@ static struct kvm_mmu_page *kvm_mmu_alloc_page(struct kvm_vcpu *vcpu,
 	list_add(&page->link, &vcpu->kvm->active_mmu_pages);
 	ASSERT(is_empty_shadow_page(page->page_hpa));
 	page->slot_bitmap = 0;
-	page->global = 1;
 	page->multimapped = 0;
 	page->parent_pte = parent_pte;
 	--vcpu->kvm->n_free_mmu_pages;
@@ -927,11 +926,6 @@ static void paging_new_cr3(struct kvm_vcpu *vcpu)
 	kvm_arch_ops->set_cr3(vcpu, vcpu->mmu.root_hpa);
 }
 
-static void mark_pagetable_nonglobal(void *shadow_pte)
-{
-	page_header(__pa(shadow_pte))->global = 0;
-}
-
 static inline void set_pte_common(struct kvm_vcpu *vcpu,
 			     u64 *shadow_pte,
 			     gpa_t gaddr,
@@ -949,9 +943,6 @@ static inline void set_pte_common(struct kvm_vcpu *vcpu,
 
 	*shadow_pte |= access_bits;
 
-	if (!(*shadow_pte & PT_GLOBAL_MASK))
-		mark_pagetable_nonglobal(shadow_pte);
-
 	if (is_error_hpa(paddr)) {
 		*shadow_pte |= gaddr;
 		*shadow_pte |= PT_SHADOW_IO_MARK;
-- 
1.5.0.5

