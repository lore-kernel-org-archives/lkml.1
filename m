Return-Path: <linux-kernel-owner+w=401wt.eu-S1758694AbZBZOTI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758694AbZBZOTI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Feb 2009 09:19:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756779AbZBZOPz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Feb 2009 09:15:55 -0500
Received: from mx2.redhat.com ([66.187.237.31]:43054 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754159AbZBZOPk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Feb 2009 09:15:40 -0500
From: Avi Kivity <avi@redhat.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 26/40] KVM: MMU: Use for_each_shadow_entry() in __direct_map()
Date: Thu, 26 Feb 2009 16:15:16 +0200
Message-Id: <1235657730-27683-27-git-send-email-avi@redhat.com>
In-Reply-To: <1235657730-27683-1-git-send-email-avi@redhat.com>
References: <1235657730-27683-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Eliminating a callback and a useless structure.

Signed-off-by: Avi Kivity <avi@redhat.com>
---
 arch/x86/kvm/mmu.c |   83 ++++++++++++++++++---------------------------------
 1 files changed, 29 insertions(+), 54 deletions(-)

diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index c669f2a..a25e1ad 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -1846,67 +1846,42 @@ static void nonpaging_new_cr3(struct kvm_vcpu *vcpu)
 {
 }
 
-struct direct_shadow_walk {
-	struct kvm_shadow_walk walker;
-	pfn_t pfn;
-	int write;
-	int largepage;
-	int pt_write;
-};
-
-static int direct_map_entry(struct kvm_shadow_walk *_walk,
-			    struct kvm_vcpu *vcpu,
-			    u64 addr, u64 *sptep, int level)
+static int __direct_map(struct kvm_vcpu *vcpu, gpa_t v, int write,
+			int largepage, gfn_t gfn, pfn_t pfn)
 {
-	struct direct_shadow_walk *walk =
-		container_of(_walk, struct direct_shadow_walk, walker);
+	struct kvm_shadow_walk_iterator iterator;
 	struct kvm_mmu_page *sp;
+	int pt_write = 0;
 	gfn_t pseudo_gfn;
-	gfn_t gfn = addr >> PAGE_SHIFT;
-
-	if (level == PT_PAGE_TABLE_LEVEL
-	    || (walk->largepage && level == PT_DIRECTORY_LEVEL)) {
-		mmu_set_spte(vcpu, sptep, ACC_ALL, ACC_ALL,
-			     0, walk->write, 1, &walk->pt_write,
-			     walk->largepage, 0, gfn, walk->pfn, false);
-		++vcpu->stat.pf_fixed;
-		return 1;
-	}
 
-	if (*sptep == shadow_trap_nonpresent_pte) {
-		pseudo_gfn = (addr & PT64_DIR_BASE_ADDR_MASK) >> PAGE_SHIFT;
-		sp = kvm_mmu_get_page(vcpu, pseudo_gfn, (gva_t)addr, level - 1,
-				      1, ACC_ALL, sptep);
-		if (!sp) {
-			pgprintk("nonpaging_map: ENOMEM\n");
-			kvm_release_pfn_clean(walk->pfn);
-			return -ENOMEM;
+	for_each_shadow_entry(vcpu, (u64)gfn << PAGE_SHIFT, iterator) {
+		if (iterator.level == PT_PAGE_TABLE_LEVEL
+		    || (largepage && iterator.level == PT_DIRECTORY_LEVEL)) {
+			mmu_set_spte(vcpu, iterator.sptep, ACC_ALL, ACC_ALL,
+				     0, write, 1, &pt_write,
+				     largepage, 0, gfn, pfn, false);
+			++vcpu->stat.pf_fixed;
+			break;
 		}
 
-		set_shadow_pte(sptep,
-			       __pa(sp->spt)
-			       | PT_PRESENT_MASK | PT_WRITABLE_MASK
-			       | shadow_user_mask | shadow_x_mask);
-	}
-	return 0;
-}
+		if (*iterator.sptep == shadow_trap_nonpresent_pte) {
+			pseudo_gfn = (iterator.addr & PT64_DIR_BASE_ADDR_MASK) >> PAGE_SHIFT;
+			sp = kvm_mmu_get_page(vcpu, pseudo_gfn, iterator.addr,
+					      iterator.level - 1,
+					      1, ACC_ALL, iterator.sptep);
+			if (!sp) {
+				pgprintk("nonpaging_map: ENOMEM\n");
+				kvm_release_pfn_clean(pfn);
+				return -ENOMEM;
+			}
 
-static int __direct_map(struct kvm_vcpu *vcpu, gpa_t v, int write,
-			int largepage, gfn_t gfn, pfn_t pfn)
-{
-	int r;
-	struct direct_shadow_walk walker = {
-		.walker = { .entry = direct_map_entry, },
-		.pfn = pfn,
-		.largepage = largepage,
-		.write = write,
-		.pt_write = 0,
-	};
-
-	r = walk_shadow(&walker.walker, vcpu, gfn << PAGE_SHIFT);
-	if (r < 0)
-		return r;
-	return walker.pt_write;
+			set_shadow_pte(iterator.sptep,
+				       __pa(sp->spt)
+				       | PT_PRESENT_MASK | PT_WRITABLE_MASK
+				       | shadow_user_mask | shadow_x_mask);
+		}
+	}
+	return pt_write;
 }
 
 static int nonpaging_map(struct kvm_vcpu *vcpu, gva_t v, int write, gfn_t gfn)
-- 
1.6.0.6

