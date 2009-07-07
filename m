Return-Path: <linux-kernel-owner+w=401wt.eu-S1758575AbZGGQl7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758575AbZGGQl7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jul 2009 12:41:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756190AbZGGQlc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Jul 2009 12:41:32 -0400
Received: from wa4ehsobe004.messaging.microsoft.com ([216.32.181.14]:51515
	"EHLO WA4EHSOBE004.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755305AbZGGQl3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jul 2009 12:41:29 -0400
X-SpamScore: -2
X-BigFish: VPS-2(zz14c3Mzz1202hzzz32i43j63h)
X-Spam-TCS-SCL: 2:0
X-WSS-ID: 0KMF7OP-04-HX6-01
From: Joerg Roedel <joerg.roedel@amd.com>
To: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <marcelo@kvack.org>
CC: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
       Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 1/6] kvm/mmu: make rmap code aware of mapping levels
Date: Tue, 7 Jul 2009 18:41:02 +0200
Message-ID: <1246984867-15952-2-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1246984867-15952-1-git-send-email-joerg.roedel@amd.com>
References: <1246984867-15952-1-git-send-email-joerg.roedel@amd.com>
X-OriginalArrivalTime: 07 Jul 2009 16:41:16.0178 (UTC) FILETIME=[BF17C720:01C9FF21]
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch removes the largepage parameter from the rmap_add function.
Together with rmap_remove this function now uses the role.level field to
find determine if the page is a huge page.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 arch/x86/kvm/mmu.c |   53 +++++++++++++++++++++++++++------------------------
 1 files changed, 28 insertions(+), 25 deletions(-)

diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index 231d880..0434990 100644
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
@@ -503,7 +503,7 @@ static unsigned long *gfn_to_rmap(struct kvm *kvm, gfn_t gfn, int lpage)
  * If rmapp bit zero is one, (then rmap & ~1) points to a struct kvm_rmap_desc
  * containing more mappings.
  */
-static void rmap_add(struct kvm_vcpu *vcpu, u64 *spte, gfn_t gfn, int lpage)
+static void rmap_add(struct kvm_vcpu *vcpu, u64 *spte, gfn_t gfn)
 {
 	struct kvm_mmu_page *sp;
 	struct kvm_rmap_desc *desc;
@@ -515,7 +515,7 @@ static void rmap_add(struct kvm_vcpu *vcpu, u64 *spte, gfn_t gfn, int lpage)
 	gfn = unalias_gfn(vcpu->kvm, gfn);
 	sp = page_header(__pa(spte));
 	sp->gfns[spte - sp->spt] = gfn;
-	rmapp = gfn_to_rmap(vcpu->kvm, gfn, lpage);
+	rmapp = gfn_to_rmap(vcpu->kvm, gfn, sp->role.level);
 	if (!*rmapp) {
 		rmap_printk("rmap_add: %p %llx 0->1\n", spte, *spte);
 		*rmapp = (unsigned long)spte;
@@ -582,7 +582,7 @@ static void rmap_remove(struct kvm *kvm, u64 *spte)
 		kvm_release_pfn_dirty(pfn);
 	else
 		kvm_release_pfn_clean(pfn);
-	rmapp = gfn_to_rmap(kvm, sp->gfns[spte - sp->spt], is_large_pte(*spte));
+	rmapp = gfn_to_rmap(kvm, sp->gfns[spte - sp->spt], sp->role.level);
 	if (!*rmapp) {
 		printk(KERN_ERR "rmap_remove: %p %llx 0->BUG\n", spte, *spte);
 		BUG();
@@ -645,10 +645,10 @@ static int rmap_write_protect(struct kvm *kvm, u64 gfn)
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
@@ -670,21 +670,24 @@ static int rmap_write_protect(struct kvm *kvm, u64 gfn)
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
@@ -1793,7 +1796,7 @@ static void mmu_set_spte(struct kvm_vcpu *vcpu, u64 *sptep,
 
 	page_header_update_slot(vcpu->kvm, sptep, gfn);
 	if (!was_rmapped) {
-		rmap_add(vcpu, sptep, gfn, largepage);
+		rmap_add(vcpu, sptep, gfn);
 		if (!is_rmap_spte(*sptep))
 			kvm_release_pfn_clean(pfn);
 	} else {
-- 
1.6.3.3


