Return-Path: <linux-kernel-owner+w=401wt.eu-S1758800AbXL3HZG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758800AbXL3HZG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Dec 2007 02:25:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753364AbXL3HLe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Dec 2007 02:11:34 -0500
Received: from il.qumranet.com ([82.166.9.18]:59497 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755833AbXL3HKv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Dec 2007 02:10:51 -0500
From: Avi Kivity <avi@qumranet.com>
To: linux-kernel@vger.kernel.org, kvm-devel@lists.sourceforge.net
Subject: [PATCH 50/52] KVM: MMU: Adjust page_header_update_slot() to accept a gfn instead of a gpa
Date: Sun, 30 Dec 2007 09:10:36 +0200
Message-Id: <1198998638-22713-51-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.3.7
In-Reply-To: <1198998638-22713-1-git-send-email-avi@qumranet.com>
References: <1198998638-22713-1-git-send-email-avi@qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 drivers/kvm/mmu.c         |    7 ++++---
 drivers/kvm/paging_tmpl.h |    3 +--
 2 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/kvm/mmu.c b/drivers/kvm/mmu.c
index c3362ba..1dcffc4 100644
--- a/drivers/kvm/mmu.c
+++ b/drivers/kvm/mmu.c
@@ -860,9 +860,9 @@ static void mmu_unshadow(struct kvm *kvm, gfn_t gfn)
 	}
 }
 
-static void page_header_update_slot(struct kvm *kvm, void *pte, gpa_t gpa)
+static void page_header_update_slot(struct kvm *kvm, void *pte, gfn_t gfn)
 {
-	int slot = memslot_id(kvm, gfn_to_memslot(kvm, gpa >> PAGE_SHIFT));
+	int slot = memslot_id(kvm, gfn_to_memslot(kvm, gfn));
 	struct kvm_mmu_page *page_head = page_header(__pa(pte));
 
 	__set_bit(slot, &page_head->slot_bitmap);
@@ -928,7 +928,8 @@ static int nonpaging_map(struct kvm_vcpu *vcpu, gva_t v, hpa_t p)
 				return 0;
 			}
 			mark_page_dirty(vcpu->kvm, v >> PAGE_SHIFT);
-			page_header_update_slot(vcpu->kvm, table, v);
+			page_header_update_slot(vcpu->kvm, table,
+						v >> PAGE_SHIFT);
 			table[index] = p | PT_PRESENT_MASK | PT_WRITABLE_MASK |
 								PT_USER_MASK;
 			if (!was_rmapped)
diff --git a/drivers/kvm/paging_tmpl.h b/drivers/kvm/paging_tmpl.h
index 54a6ee8..a3da98b 100644
--- a/drivers/kvm/paging_tmpl.h
+++ b/drivers/kvm/paging_tmpl.h
@@ -259,8 +259,7 @@ unshadowed:
 
 	pgprintk("%s: setting spte %llx\n", __FUNCTION__, spte);
 	set_shadow_pte(shadow_pte, spte);
-	page_header_update_slot(vcpu->kvm, shadow_pte,
-				(gpa_t)gfn << PAGE_SHIFT);
+	page_header_update_slot(vcpu->kvm, shadow_pte, gfn);
 	if (!was_rmapped) {
 		rmap_add(vcpu, shadow_pte, gfn);
 		if (!is_rmap_pte(*shadow_pte))
-- 
1.5.3.7

