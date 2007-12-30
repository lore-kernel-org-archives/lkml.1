Return-Path: <linux-kernel-owner+w=401wt.eu-S1758804AbXL3H0M@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758804AbXL3H0M (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Dec 2007 02:26:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756554AbXL3HLg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Dec 2007 02:11:36 -0500
Received: from il.qumranet.com ([82.166.9.18]:59495 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755724AbXL3HKv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Dec 2007 02:10:51 -0500
From: Avi Kivity <avi@qumranet.com>
To: linux-kernel@vger.kernel.org, kvm-devel@lists.sourceforge.net
Subject: [PATCH 45/52] KVM: MMU: Introduce and use gpte_to_gfn()
Date: Sun, 30 Dec 2007 09:10:31 +0200
Message-Id: <1198998638-22713-46-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.3.7
In-Reply-To: <1198998638-22713-1-git-send-email-avi@qumranet.com>
References: <1198998638-22713-1-git-send-email-avi@qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Instead of repretitively open-coding this.

Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 drivers/kvm/paging_tmpl.h |   28 ++++++++++++++++++++--------
 1 files changed, 20 insertions(+), 8 deletions(-)

diff --git a/drivers/kvm/paging_tmpl.h b/drivers/kvm/paging_tmpl.h
index 6e01301..6f79ae8 100644
--- a/drivers/kvm/paging_tmpl.h
+++ b/drivers/kvm/paging_tmpl.h
@@ -52,6 +52,9 @@
 	#error Invalid PTTYPE value
 #endif
 
+#define gpte_to_gfn FNAME(gpte_to_gfn)
+#define gpte_to_gfn_pde FNAME(gpte_to_gfn_pde)
+
 /*
  * The guest_walker structure emulates the behavior of the hardware page
  * table walker.
@@ -65,6 +68,16 @@ struct guest_walker {
 	u32 error_code;
 };
 
+static gfn_t gpte_to_gfn(pt_element_t gpte)
+{
+	return (gpte & PT_BASE_ADDR_MASK) >> PAGE_SHIFT;
+}
+
+static gfn_t gpte_to_gfn_pde(pt_element_t gpte)
+{
+	return (gpte & PT_DIR_BASE_ADDR_MASK) >> PAGE_SHIFT;
+}
+
 /*
  * Fetch a guest pte for a guest virtual address
  */
@@ -96,7 +109,7 @@ static int FNAME(walk_addr)(struct guest_walker *walker,
 	for (;;) {
 		index = PT_INDEX(addr, walker->level);
 
-		table_gfn = (pte & PT64_BASE_ADDR_MASK) >> PAGE_SHIFT;
+		table_gfn = gpte_to_gfn(pte);
 		pte_gpa = table_gfn << PAGE_SHIFT;
 		pte_gpa += index * sizeof(pt_element_t);
 		walker->table_gfn[walker->level - 1] = table_gfn;
@@ -127,15 +140,14 @@ static int FNAME(walk_addr)(struct guest_walker *walker,
 		}
 
 		if (walker->level == PT_PAGE_TABLE_LEVEL) {
-			walker->gfn = (pte & PT_BASE_ADDR_MASK) >> PAGE_SHIFT;
+			walker->gfn = gpte_to_gfn(pte);
 			break;
 		}
 
 		if (walker->level == PT_DIRECTORY_LEVEL
 		    && (pte & PT_PAGE_SIZE_MASK)
 		    && (PTTYPE == 64 || is_pse(vcpu))) {
-			walker->gfn = (pte & PT_DIR_BASE_ADDR_MASK)
-				>> PAGE_SHIFT;
+			walker->gfn = gpte_to_gfn_pde(pte);
 			walker->gfn += PT_INDEX(addr, PT_PAGE_TABLE_LEVEL);
 			break;
 		}
@@ -296,8 +308,7 @@ static void FNAME(update_pte)(struct kvm_vcpu *vcpu, struct kvm_mmu_page *page,
 		return;
 	pgprintk("%s: gpte %llx spte %p\n", __FUNCTION__, (u64)gpte, spte);
 	FNAME(set_pte)(vcpu, gpte, spte, PT_USER_MASK | PT_WRITABLE_MASK, 0,
-		       0, NULL, NULL,
-		       (gpte & PT_BASE_ADDR_MASK) >> PAGE_SHIFT);
+		       0, NULL, NULL, gpte_to_gfn(gpte));
 }
 
 static void FNAME(set_pde)(struct kvm_vcpu *vcpu, pt_element_t gpde,
@@ -370,8 +381,7 @@ static u64 *FNAME(fetch)(struct kvm_vcpu *vcpu, gva_t addr,
 			hugepage_access >>= PT_WRITABLE_SHIFT;
 			if (walker->pte & PT64_NX_MASK)
 				hugepage_access |= (1 << 2);
-			table_gfn = (walker->pte & PT_BASE_ADDR_MASK)
-				>> PAGE_SHIFT;
+			table_gfn = gpte_to_gfn(walker->pte);
 		} else {
 			metaphysical = 0;
 			table_gfn = walker->table_gfn[level - 2];
@@ -519,3 +529,5 @@ static void FNAME(prefetch_page)(struct kvm_vcpu *vcpu,
 #undef PT_DIR_BASE_ADDR_MASK
 #undef PT_LEVEL_BITS
 #undef PT_MAX_FULL_LEVELS
+#undef gpte_to_gfn
+#undef gpte_to_gfn_pde
-- 
1.5.3.7

