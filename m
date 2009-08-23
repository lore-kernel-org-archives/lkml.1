Return-Path: <linux-kernel-owner+w=401wt.eu-S933568AbZHWL6f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933568AbZHWL6f (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Aug 2009 07:58:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933512AbZHWL6d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Aug 2009 07:58:33 -0400
Received: from mx1.redhat.com ([209.132.183.28]:9066 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933560AbZHWL4u (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Aug 2009 07:56:50 -0400
From: Avi Kivity <avi@redhat.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 40/46] KVM: MMU: make rmap code aware of mapping levels
Date: Sun, 23 Aug 2009 14:56:39 +0300
Message-Id: <1251028605-31977-41-git-send-email-avi@redhat.com>
In-Reply-To: <1251028605-31977-1-git-send-email-avi@redhat.com>
References: <1251028605-31977-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Joerg Roedel <joerg.roedel@amd.com>

This patch removes the largepage parameter from the rmap_add function.
Together with rmap_remove this function now uses the role.level field to
find determine if the page is a huge page.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
Signed-off-by: Avi Kivity <avi@redhat.com>
---
 arch/x86/kvm/mmu.c |   53 +++++++++++++++++++++++++++------------------------
 1 files changed, 28 insertions(+), 25 deletions(-)

diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index 86c2551..b93ad2c 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -479,19 +479,19 @@ static int is_largepage_backed(struct kvm_vcpu *vcpu, gfn_t large_gfn)
  * Note: gfn must be unaliased before this function get called
  */
 
-static unsigned long *gfn_to_rmap(struct kvm *kvm, gfn_t gfn, int lpage)
+static unsigned long *gfn_to_rmap(struct kvm *kvm, gfn_t gfn, int level)
 {
 	struct kvm_memory_slot *slot;
 	unsigned long idx;
 
 	slot = gfn_to_memslot(kvm, gfn);
-	if (!lpage)
+	if (likely(level == PT_PAGE_TABLE_LEVEL))
 		return &slot->rmap[gfn - slot->base_gfn];
 
-	idx = (gfn / KVM_PAGES_PER_HPAGE(PT_DIRECTORY_LEVEL)) -
-	      (slot->base_gfn / KVM_PAGES_PER_HPAGE(PT_DIRECTORY_LEVEL));
+	idx = (gfn / KVM_PAGES_PER_HPAGE(level)) -
+		(slot->base_gfn / KVM_PAGES_PER_HPAGE(level));
 
-	return &slot->lpage_info[0][idx].rmap_pde;
+	return &slot->lpage_info[level - 2][idx].rmap_pde;
 }
 
 /*
@@ -507,7 +507,7 @@ static unsigned long *gfn_to_rmap(struct kvm *kvm, gfn_t gfn, int lpage)
  * the spte was not added.
  *
  */
-static int rmap_add(struct kvm_vcpu *vcpu, u64 *spte, gfn_t gfn, int lpage)
+static int rmap_add(struct kvm_vcpu *vcpu, u64 *spte, gfn_t gfn)
 {
 	struct kvm_mmu_page *sp;
 	struct kvm_rmap_desc *desc;
@@ -519,7 +519,7 @@ static int rmap_add(struct kvm_vcpu *vcpu, u64 *spte, gfn_t gfn, int lpage)
 	gfn = unalias_gfn(vcpu->kvm, gfn);
 	sp = page_header(__pa(spte));
 	sp->gfns[spte - sp->spt] = gfn;
-	rmapp = gfn_to_rmap(vcpu->kvm, gfn, lpage);
+	rmapp = gfn_to_rmap(vcpu->kvm, gfn, sp->role.level);
 	if (!*rmapp) {
 		rmap_printk("rmap_add: %p %llx 0->1\n", spte, *spte);
 		*rmapp = (unsigned long)spte;
@@ -589,7 +589,7 @@ static void rmap_remove(struct kvm *kvm, u64 *spte)
 		kvm_release_pfn_dirty(pfn);
 	else
 		kvm_release_pfn_clean(pfn);
-	rmapp = gfn_to_rmap(kvm, sp->gfns[spte - sp->spt], is_large_pte(*spte));
+	rmapp = gfn_to_rmap(kvm, sp->gfns[spte - sp->spt], sp->role.level);
 	if (!*rmapp) {
 		printk(KERN_ERR "rmap_remove: %p %llx 0->BUG\n", spte, *spte);
 		BUG();
@@ -652,10 +652,10 @@ static int rmap_write_protect(struct kvm *kvm, u64 gfn)
 {
 	unsigned long *rmapp;
 	u64 *spte;
-	int write_protected = 0;
+	int i, write_protected = 0;
 
 	gfn = unalias_gfn(kvm, gfn);
-	rmapp = gfn_to_rmap(kvm, gfn, 0);
+	rmapp = gfn_to_rmap(kvm, gfn, PT_PAGE_TABLE_LEVEL);
 
 	spte = rmap_next(kvm, rmapp, NULL);
 	while (spte) {
@@ -677,21 +677,24 @@ static int rmap_write_protect(struct kvm *kvm, u64 gfn)
 	}
 
 	/* check for huge page mappings */
-	rmapp = gfn_to_rmap(kvm, gfn, 1);
-	spte = rmap_next(kvm, rmapp, NULL);
-	while (spte) {
-		BUG_ON(!spte);
-		BUG_ON(!(*spte & PT_PRESENT_MASK));
-		BUG_ON((*spte & (PT_PAGE_SIZE_MASK|PT_PRESENT_MASK)) != (PT_PAGE_SIZE_MASK|PT_PRESENT_MASK));
-		pgprintk("rmap_write_protect(large): spte %p %llx %lld\n", spte, *spte, gfn);
-		if (is_writeble_pte(*spte)) {
-			rmap_remove(kvm, spte);
-			--kvm->stat.lpages;
-			__set_spte(spte, shadow_trap_nonpresent_pte);
-			spte = NULL;
-			write_protected = 1;
+	for (i = PT_DIRECTORY_LEVEL;
+	     i < PT_PAGE_TABLE_LEVEL + KVM_NR_PAGE_SIZES; ++i) {
+		rmapp = gfn_to_rmap(kvm, gfn, i);
+		spte = rmap_next(kvm, rmapp, NULL);
+		while (spte) {
+			BUG_ON(!spte);
+			BUG_ON(!(*spte & PT_PRESENT_MASK));
+			BUG_ON((*spte & (PT_PAGE_SIZE_MASK|PT_PRESENT_MASK)) != (PT_PAGE_SIZE_MASK|PT_PRESENT_MASK));
+			pgprintk("rmap_write_protect(large): spte %p %llx %lld\n", spte, *spte, gfn);
+			if (is_writeble_pte(*spte)) {
+				rmap_remove(kvm, spte);
+				--kvm->stat.lpages;
+				__set_spte(spte, shadow_trap_nonpresent_pte);
+				spte = NULL;
+				write_protected = 1;
+			}
+			spte = rmap_next(kvm, rmapp, spte);
 		}
-		spte = rmap_next(kvm, rmapp, spte);
 	}
 
 	return write_protected;
@@ -1815,7 +1818,7 @@ static void mmu_set_spte(struct kvm_vcpu *vcpu, u64 *sptep,
 
 	page_header_update_slot(vcpu->kvm, sptep, gfn);
 	if (!was_rmapped) {
-		rmap_count = rmap_add(vcpu, sptep, gfn, largepage);
+		rmap_count = rmap_add(vcpu, sptep, gfn);
 		if (!is_rmap_spte(*sptep))
 			kvm_release_pfn_clean(pfn);
 		if (rmap_count > RMAP_RECYCLE_THRESHOLD)
-- 
1.6.4.1

