Return-Path: <linux-kernel-owner+w=401wt.eu-S1759384AbXLWPF2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759384AbXLWPF2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Dec 2007 10:05:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755452AbXLWOw0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Dec 2007 09:52:26 -0500
Received: from il.qumranet.com ([82.166.9.18]:35897 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755128AbXLWOvr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Dec 2007 09:51:47 -0500
From: Avi Kivity <avi@qumranet.com>
To: linux-kernel@vger.kernel.org, kvm-devel@lists.sourceforge.net
Cc: Izik Eidus <izike@qumranet.com>
Subject: [PATCH 46/50] KVM: MMU: Keep a reverse mapping of non-writable translations
Date: Sun, 23 Dec 2007 16:51:31 +0200
Message-Id: <1198421495-31481-47-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.3.7
In-Reply-To: <1198421495-31481-1-git-send-email-avi@qumranet.com>
References: <1198421495-31481-1-git-send-email-avi@qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Izik Eidus <izike@qumranet.com>

The current kvm mmu only reverse maps writable translation.  This is used
to write-protect a page in case it becomes a pagetable.

But with swapping support, we need a reverse mapping of read-only pages as
well:  when we evict a page, we need to remove any mapping to it, whether
writable or not.

Signed-off-by: Izik Eidus <izike@qumranet.com>
Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 drivers/kvm/mmu.c |   23 +++++++++++------------
 1 files changed, 11 insertions(+), 12 deletions(-)

diff --git a/drivers/kvm/mmu.c b/drivers/kvm/mmu.c
index 14e54e3..bbf5eb4 100644
--- a/drivers/kvm/mmu.c
+++ b/drivers/kvm/mmu.c
@@ -211,8 +211,8 @@ static int is_io_pte(unsigned long pte)
 
 static int is_rmap_pte(u64 pte)
 {
-	return (pte & (PT_WRITABLE_MASK | PT_PRESENT_MASK))
-		== (PT_WRITABLE_MASK | PT_PRESENT_MASK);
+	return pte != shadow_trap_nonpresent_pte
+		&& pte != shadow_notrap_nonpresent_pte;
 }
 
 static void set_shadow_pte(u64 *sptep, u64 spte)
@@ -488,7 +488,6 @@ static void rmap_write_protect(struct kvm *kvm, u64 gfn)
 {
 	unsigned long *rmapp;
 	u64 *spte;
-	u64 *prev_spte;
 
 	gfn = unalias_gfn(kvm, gfn);
 	rmapp = gfn_to_rmap(kvm, gfn);
@@ -497,13 +496,11 @@ static void rmap_write_protect(struct kvm *kvm, u64 gfn)
 	while (spte) {
 		BUG_ON(!spte);
 		BUG_ON(!(*spte & PT_PRESENT_MASK));
-		BUG_ON(!(*spte & PT_WRITABLE_MASK));
 		rmap_printk("rmap_write_protect: spte %p %llx\n", spte, *spte);
-		prev_spte = spte;
-		spte = rmap_next(kvm, rmapp, spte);
-		rmap_remove(kvm, prev_spte);
-		set_shadow_pte(prev_spte, *prev_spte & ~PT_WRITABLE_MASK);
+		if (is_writeble_pte(*spte))
+			set_shadow_pte(spte, *spte & ~PT_WRITABLE_MASK);
 		kvm_flush_remote_tlbs(kvm);
+		spte = rmap_next(kvm, rmapp, spte);
 	}
 }
 
@@ -908,14 +905,18 @@ static int nonpaging_map(struct kvm_vcpu *vcpu, gva_t v, hpa_t p)
 		table = __va(table_addr);
 
 		if (level == 1) {
+			int was_rmapped;
+
 			pte = table[index];
+			was_rmapped = is_rmap_pte(pte);
 			if (is_shadow_present_pte(pte) && is_writeble_pte(pte))
 				return 0;
 			mark_page_dirty(vcpu->kvm, v >> PAGE_SHIFT);
 			page_header_update_slot(vcpu->kvm, table, v);
 			table[index] = p | PT_PRESENT_MASK | PT_WRITABLE_MASK |
 								PT_USER_MASK;
-			rmap_add(vcpu, &table[index], v >> PAGE_SHIFT);
+			if (!was_rmapped)
+				rmap_add(vcpu, &table[index], v >> PAGE_SHIFT);
 			return 0;
 		}
 
@@ -1424,10 +1425,8 @@ void kvm_mmu_slot_remove_write_access(struct kvm *kvm, int slot)
 		pt = page->spt;
 		for (i = 0; i < PT64_ENT_PER_PAGE; ++i)
 			/* avoid RMW */
-			if (pt[i] & PT_WRITABLE_MASK) {
-				rmap_remove(kvm, &pt[i]);
+			if (pt[i] & PT_WRITABLE_MASK)
 				pt[i] &= ~PT_WRITABLE_MASK;
-			}
 	}
 }
 
-- 
1.5.3.7

