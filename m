Return-Path: <linux-kernel-owner+w=401wt.eu-S1757194AbXLWO7M@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757194AbXLWO7M (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Dec 2007 09:59:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755992AbXLWOwE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Dec 2007 09:52:04 -0500
Received: from il.qumranet.com ([82.166.9.18]:35893 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753388AbXLWOvo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Dec 2007 09:51:44 -0500
From: Avi Kivity <avi@qumranet.com>
To: linux-kernel@vger.kernel.org, kvm-devel@lists.sourceforge.net
Subject: [PATCH 31/50] KVM: Move guest pte dirty bit management to the guest pagetable walker
Date: Sun, 23 Dec 2007 16:51:16 +0200
Message-Id: <1198421495-31481-32-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.3.7
In-Reply-To: <1198421495-31481-1-git-send-email-avi@qumranet.com>
References: <1198421495-31481-1-git-send-email-avi@qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is more consistent with the accessed bit management, and makes the dirty
bit available earlier for other purposes.

Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 drivers/kvm/mmu.c         |    5 +++++
 drivers/kvm/paging_tmpl.h |   31 ++++++++-----------------------
 2 files changed, 13 insertions(+), 23 deletions(-)

diff --git a/drivers/kvm/mmu.c b/drivers/kvm/mmu.c
index d046ba8..e6616a6 100644
--- a/drivers/kvm/mmu.c
+++ b/drivers/kvm/mmu.c
@@ -199,6 +199,11 @@ static int is_writeble_pte(unsigned long pte)
 	return pte & PT_WRITABLE_MASK;
 }
 
+static int is_dirty_pte(unsigned long pte)
+{
+	return pte & PT_DIRTY_MASK;
+}
+
 static int is_io_pte(unsigned long pte)
 {
 	return pte & PT_SHADOW_IO_MARK;
diff --git a/drivers/kvm/paging_tmpl.h b/drivers/kvm/paging_tmpl.h
index 8e1e4ca..da36e48 100644
--- a/drivers/kvm/paging_tmpl.h
+++ b/drivers/kvm/paging_tmpl.h
@@ -144,6 +144,10 @@ static int FNAME(walk_addr)(struct guest_walker *walker,
 		if (walker->level == PT_PAGE_TABLE_LEVEL) {
 			walker->gfn = (*ptep & PT_BASE_ADDR_MASK)
 				>> PAGE_SHIFT;
+			if (write_fault && !is_dirty_pte(*ptep)) {
+				mark_page_dirty(vcpu->kvm, table_gfn);
+				*ptep |= PT_DIRTY_MASK;
+			}
 			break;
 		}
 
@@ -153,6 +157,10 @@ static int FNAME(walk_addr)(struct guest_walker *walker,
 			walker->gfn = (*ptep & PT_DIR_BASE_ADDR_MASK)
 				>> PAGE_SHIFT;
 			walker->gfn += PT_INDEX(addr, PT_PAGE_TABLE_LEVEL);
+			if (write_fault && !is_dirty_pte(*ptep)) {
+				mark_page_dirty(vcpu->kvm, table_gfn);
+				*ptep |= PT_DIRTY_MASK;
+			}
 			break;
 		}
 
@@ -194,12 +202,6 @@ err:
 	return 0;
 }
 
-static void FNAME(mark_pagetable_dirty)(struct kvm *kvm,
-					struct guest_walker *walker)
-{
-	mark_page_dirty(kvm, walker->table_gfn[walker->level - 1]);
-}
-
 static void FNAME(set_pte_common)(struct kvm_vcpu *vcpu,
 				  u64 *shadow_pte,
 				  gpa_t gaddr,
@@ -221,23 +223,6 @@ static void FNAME(set_pte_common)(struct kvm_vcpu *vcpu,
 		 __FUNCTION__, *shadow_pte, (u64)gpte, access_bits,
 		 write_fault, user_fault, gfn);
 
-	if (write_fault && !dirty) {
-		pt_element_t *guest_ent, *tmp = NULL;
-
-		if (walker->ptep)
-			guest_ent = walker->ptep;
-		else {
-			tmp = kmap_atomic(walker->page, KM_USER0);
-			guest_ent = &tmp[walker->index];
-		}
-
-		*guest_ent |= PT_DIRTY_MASK;
-		if (!walker->ptep)
-			kunmap_atomic(tmp, KM_USER0);
-		dirty = 1;
-		FNAME(mark_pagetable_dirty)(vcpu->kvm, walker);
-	}
-
 	/*
 	 * We don't set the accessed bit, since we sometimes want to see
 	 * whether the guest actually used the pte (in order to detect
-- 
1.5.3.7

