Return-Path: <linux-kernel-owner+w=401wt.eu-S1757183AbYLHLtA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757183AbYLHLtA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2008 06:49:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753852AbYLHLi3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Dec 2008 06:38:29 -0500
Received: from mx2.redhat.com ([66.187.237.31]:48245 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753287AbYLHLhE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2008 06:37:04 -0500
From: Avi Kivity <avi@redhat.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Sheng Yang <sheng@linux.intel.com>
Subject: [PATCH 23/45] KVM: MMU: Extend kvm_mmu_page->slot_bitmap size
Date: Mon,  8 Dec 2008 13:36:34 +0200
Message-Id: <1228736216-15787-24-git-send-email-avi@redhat.com>
In-Reply-To: <1228736216-15787-1-git-send-email-avi@redhat.com>
References: <1228736216-15787-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sheng Yang <sheng@linux.intel.com>

Otherwise set_bit() for private memory slot(above KVM_MEMORY_SLOTS) would
corrupted memory in 32bit host.

Signed-off-by: Sheng Yang <sheng@linux.intel.com>
Signed-off-by: Avi Kivity <avi@redhat.com>
---
 arch/x86/include/asm/kvm_host.h |    8 +++++---
 arch/x86/kvm/mmu.c              |    6 +++---
 2 files changed, 8 insertions(+), 6 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 93040b5..59c3ae1 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -192,9 +192,11 @@ struct kvm_mmu_page {
 	u64 *spt;
 	/* hold the gfn of each spte inside spt */
 	gfn_t *gfns;
-	unsigned long slot_bitmap; /* One bit set per slot which has memory
-				    * in this shadow page.
-				    */
+	/*
+	 * One bit set per slot which has memory
+	 * in this shadow page.
+	 */
+	DECLARE_BITMAP(slot_bitmap, KVM_MEMORY_SLOTS + KVM_PRIVATE_MEM_SLOTS);
 	int multimapped;         /* More than one parent_pte? */
 	int root_count;          /* Currently serving as active root */
 	bool unsync;
diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index 09d05f5..8687758 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -789,7 +789,7 @@ static struct kvm_mmu_page *kvm_mmu_alloc_page(struct kvm_vcpu *vcpu,
 	set_page_private(virt_to_page(sp->spt), (unsigned long)sp);
 	list_add(&sp->link, &vcpu->kvm->arch.active_mmu_pages);
 	ASSERT(is_empty_shadow_page(sp->spt));
-	sp->slot_bitmap = 0;
+	bitmap_zero(sp->slot_bitmap, KVM_MEMORY_SLOTS + KVM_PRIVATE_MEM_SLOTS);
 	sp->multimapped = 0;
 	sp->parent_pte = parent_pte;
 	--vcpu->kvm->arch.n_free_mmu_pages;
@@ -1364,7 +1364,7 @@ static void page_header_update_slot(struct kvm *kvm, void *pte, gfn_t gfn)
 	int slot = memslot_id(kvm, gfn_to_memslot(kvm, gfn));
 	struct kvm_mmu_page *sp = page_header(__pa(pte));
 
-	__set_bit(slot, &sp->slot_bitmap);
+	__set_bit(slot, sp->slot_bitmap);
 }
 
 static void mmu_convert_notrap(struct kvm_mmu_page *sp)
@@ -2564,7 +2564,7 @@ void kvm_mmu_slot_remove_write_access(struct kvm *kvm, int slot)
 		int i;
 		u64 *pt;
 
-		if (!test_bit(slot, &sp->slot_bitmap))
+		if (!test_bit(slot, sp->slot_bitmap))
 			continue;
 
 		pt = sp->spt;
-- 
1.6.0.3

