Return-Path: <linux-kernel-owner+w=401wt.eu-S1752863AbXDVJ2K@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752863AbXDVJ2K (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Apr 2007 05:28:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753880AbXDVJ2K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Apr 2007 05:28:10 -0400
Received: from il.qumranet.com ([82.166.9.18]:36148 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752863AbXDVJ2J (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Apr 2007 05:28:09 -0400
From: Avi Kivity <avi@qumranet.com>
To: stable@kernel.org
Cc: linux-kernel@vger.kernel.org, kvm-devel@lists.sourceforge.net,
       Avi Kivity <avi@qumranet.com>
Subject: [PATCH -stable] KVM: MMU: Fix guest writes to nonpae pde
Date: Sun, 22 Apr 2007 12:28:05 +0300
Message-Id: <11772340852200-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.0.6
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

KVM shadow page tables are always in pae mode, regardless of the guest
setting.  This means that a guest pde (mapping 4MB of memory) is mapped
to two shadow pdes (mapping 2MB each).

When the guest writes to a pte or pde, we intercept the write and emulate it.
We also remove any shadowed mappings corresponding to the write.  Since the
mmu did not account for the doubling in the number of pdes, it removed the
wrong entry, resulting in a mismatch between shadow page tables and guest
page tables, followed shortly by guest memory corruption.

This patch fixes the problem by detecting the special case of writing to
a non-pae pde and adjusting the address and number of shadow pdes zapped
accordingly.

Acked-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 drivers/kvm/mmu.c |   47 +++++++++++++++++++++++++++++++++++------------
 1 files changed, 35 insertions(+), 12 deletions(-)

diff --git a/drivers/kvm/mmu.c b/drivers/kvm/mmu.c
index 22c426c..1e09d4e 100644
--- a/drivers/kvm/mmu.c
+++ b/drivers/kvm/mmu.c
@@ -1093,22 +1093,40 @@ out:
 	return r;
 }
 
+static void mmu_pre_write_zap_pte(struct kvm_vcpu *vcpu,
+				  struct kvm_mmu_page *page,
+				  u64 *spte)
+{
+	u64 pte;
+	struct kvm_mmu_page *child;
+
+	pte = *spte;
+	if (is_present_pte(pte)) {
+		if (page->role.level == PT_PAGE_TABLE_LEVEL)
+			rmap_remove(vcpu, spte);
+		else {
+			child = page_header(pte & PT64_BASE_ADDR_MASK);
+			mmu_page_remove_parent_pte(vcpu, child, spte);
+		}
+	}
+	*spte = 0;
+}
+
 void kvm_mmu_pre_write(struct kvm_vcpu *vcpu, gpa_t gpa, int bytes)
 {
 	gfn_t gfn = gpa >> PAGE_SHIFT;
 	struct kvm_mmu_page *page;
-	struct kvm_mmu_page *child;
 	struct hlist_node *node, *n;
 	struct hlist_head *bucket;
 	unsigned index;
 	u64 *spte;
-	u64 pte;
 	unsigned offset = offset_in_page(gpa);
 	unsigned pte_size;
 	unsigned page_offset;
 	unsigned misaligned;
 	int level;
 	int flooded = 0;
+	int npte;
 
 	pgprintk("%s: gpa %llx bytes %d\n", __FUNCTION__, gpa, bytes);
 	if (gfn == vcpu->last_pt_write_gfn) {
@@ -1144,22 +1162,27 @@ void kvm_mmu_pre_write(struct kvm_vcpu *vcpu, gpa_t gpa, int bytes)
 		}
 		page_offset = offset;
 		level = page->role.level;
+		npte = 1;
 		if (page->role.glevels == PT32_ROOT_LEVEL) {
-			page_offset <<= 1;          /* 32->64 */
+			page_offset <<= 1;	/* 32->64 */
+			/*
+			 * A 32-bit pde maps 4MB while the shadow pdes map
+			 * only 2MB.  So we need to double the offset again
+			 * and zap two pdes instead of one.
+			 */
+			if (level == PT32_ROOT_LEVEL) {
+				page_offset &= ~7; /* kill rounding error */
+				page_offset <<= 1;
+				npte = 2;
+			}
 			page_offset &= ~PAGE_MASK;
 		}
 		spte = __va(page->page_hpa);
 		spte += page_offset / sizeof(*spte);
-		pte = *spte;
-		if (is_present_pte(pte)) {
-			if (level == PT_PAGE_TABLE_LEVEL)
-				rmap_remove(vcpu, spte);
-			else {
-				child = page_header(pte & PT64_BASE_ADDR_MASK);
-				mmu_page_remove_parent_pte(vcpu, child, spte);
-			}
+		while (npte--) {
+			mmu_pre_write_zap_pte(vcpu, page, spte);
+			++spte;
 		}
-		*spte = 0;
 	}
 }
 
-- 
1.5.0.6

