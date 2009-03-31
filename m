Return-Path: <linux-kernel-owner+w=401wt.eu-S1761241AbZCaACw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761241AbZCaACw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Mar 2009 20:02:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759945AbZCaABP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Mar 2009 20:01:15 -0400
Received: from mx2.redhat.com ([66.187.237.31]:59768 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759822AbZCaABO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Mar 2009 20:01:14 -0400
From: Izik Eidus <ieidus@redhat.com>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org, linux-mm@kvack.org,
       avi@redhat.com, aarcange@redhat.com, chrisw@redhat.com, riel@redhat.com,
       jeremy@goop.org, mtosatti@redhat.com, hugh@veritas.com, corbet@lwn.net,
       yaniv@redhat.com, dmonakhov@openvz.org, Izik Eidus <ieidus@redhat.com>
Subject: [PATCH 1/3] kvm: dont hold pagecount reference for mapped sptes pages.
Date: Tue, 31 Mar 2009 03:00:02 +0300
Message-Id: <1238457604-7637-2-git-send-email-ieidus@redhat.com>
In-Reply-To: <1238457604-7637-1-git-send-email-ieidus@redhat.com>
References: <1238457604-7637-1-git-send-email-ieidus@redhat.com>
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When using mmu notifiers, we are allowed to remove the page count
reference tooken by get_user_pages to a specific page that is mapped
inside the shadow page tables.

This is needed so we can balance the pagecount against mapcount
checking.

(Right now kvm increase the pagecount and does not increase the
mapcount when mapping page into shadow page table entry,
so when comparing pagecount against mapcount, you have no
reliable result.)

Signed-off-by: Izik Eidus <ieidus@redhat.com>
---
 arch/x86/kvm/mmu.c |    7 ++-----
 1 files changed, 2 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index b625ed4..df8fbaf 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -567,9 +567,7 @@ static void rmap_remove(struct kvm *kvm, u64 *spte)
 	if (*spte & shadow_accessed_mask)
 		kvm_set_pfn_accessed(pfn);
 	if (is_writeble_pte(*spte))
-		kvm_release_pfn_dirty(pfn);
-	else
-		kvm_release_pfn_clean(pfn);
+		kvm_set_pfn_dirty(pfn);
 	rmapp = gfn_to_rmap(kvm, sp->gfns[spte - sp->spt], is_large_pte(*spte));
 	if (!*rmapp) {
 		printk(KERN_ERR "rmap_remove: %p %llx 0->BUG\n", spte, *spte);
@@ -1812,8 +1810,7 @@ static void mmu_set_spte(struct kvm_vcpu *vcpu, u64 *shadow_pte,
 	page_header_update_slot(vcpu->kvm, shadow_pte, gfn);
 	if (!was_rmapped) {
 		rmap_add(vcpu, shadow_pte, gfn, largepage);
-		if (!is_rmap_pte(*shadow_pte))
-			kvm_release_pfn_clean(pfn);
+		kvm_release_pfn_clean(pfn);
 	} else {
 		if (was_writeble)
 			kvm_release_pfn_dirty(pfn);
-- 
1.5.6.5

