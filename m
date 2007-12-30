Return-Path: <linux-kernel-owner+w=401wt.eu-S1757408AbXL3HQy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757408AbXL3HQy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Dec 2007 02:16:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756333AbXL3HLG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Dec 2007 02:11:06 -0500
Received: from il.qumranet.com ([82.166.9.18]:59492 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753105AbXL3HKp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Dec 2007 02:10:45 -0500
From: Avi Kivity <avi@qumranet.com>
To: linux-kernel@vger.kernel.org, kvm-devel@lists.sourceforge.net
Cc: Izik Eidus <izike@qumranet.com>
Subject: [PATCH 18/52] KVM: MMU: Change guest pte access to kvm_{read,write}_guest()
Date: Sun, 30 Dec 2007 09:10:04 +0200
Message-Id: <1198998638-22713-19-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.3.7
In-Reply-To: <1198998638-22713-1-git-send-email-avi@qumranet.com>
References: <1198998638-22713-1-git-send-email-avi@qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Izik Eidus <izike@qumranet.com>

Things are simpler and more regular this way.

Signed-off-by: Izik Eidus <izike@qumranet.com>
Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 drivers/kvm/paging_tmpl.h |   24 +++++-------------------
 1 files changed, 5 insertions(+), 19 deletions(-)

diff --git a/drivers/kvm/paging_tmpl.h b/drivers/kvm/paging_tmpl.h
index 0f0266a..be66401 100644
--- a/drivers/kvm/paging_tmpl.h
+++ b/drivers/kvm/paging_tmpl.h
@@ -72,7 +72,6 @@ static int FNAME(walk_addr)(struct guest_walker *walker,
 			    struct kvm_vcpu *vcpu, gva_t addr,
 			    int write_fault, int user_fault, int fetch_fault)
 {
-	struct page *page = NULL;
 	pt_element_t *table;
 	pt_element_t pte;
 	gfn_t table_gfn;
@@ -99,16 +98,13 @@ static int FNAME(walk_addr)(struct guest_walker *walker,
 		index = PT_INDEX(addr, walker->level);
 
 		table_gfn = (pte & PT64_BASE_ADDR_MASK) >> PAGE_SHIFT;
+		pte_gpa = table_gfn << PAGE_SHIFT;
+		pte_gpa += index * sizeof(pt_element_t);
 		walker->table_gfn[walker->level - 1] = table_gfn;
 		pgprintk("%s: table_gfn[%d] %lx\n", __FUNCTION__,
 			 walker->level - 1, table_gfn);
 
-		page = gfn_to_page(vcpu->kvm, (pte & PT64_BASE_ADDR_MASK)
-				   >> PAGE_SHIFT);
-
-		table = kmap_atomic(page, KM_USER0);
-		pte = table[index];
-		kunmap_atomic(table, KM_USER0);
+		kvm_read_guest(vcpu->kvm, pte_gpa, &pte, sizeof(pte));
 
 		if (!is_present_pte(pte))
 			goto not_present;
@@ -128,9 +124,7 @@ static int FNAME(walk_addr)(struct guest_walker *walker,
 		if (!(pte & PT_ACCESSED_MASK)) {
 			mark_page_dirty(vcpu->kvm, table_gfn);
 			pte |= PT_ACCESSED_MASK;
-			table = kmap_atomic(page, KM_USER0);
-			table[index] = pte;
-			kunmap_atomic(table, KM_USER0);
+			kvm_write_guest(vcpu->kvm, pte_gpa, &pte, sizeof(pte));
 		}
 
 		if (walker->level == PT_PAGE_TABLE_LEVEL) {
@@ -149,21 +143,15 @@ static int FNAME(walk_addr)(struct guest_walker *walker,
 
 		walker->inherited_ar &= pte;
 		--walker->level;
-		kvm_release_page(page);
 	}
 
 	if (write_fault && !is_dirty_pte(pte)) {
 		mark_page_dirty(vcpu->kvm, table_gfn);
 		pte |= PT_DIRTY_MASK;
-		table = kmap_atomic(page, KM_USER0);
-		table[index] = pte;
-		kunmap_atomic(table, KM_USER0);
-		pte_gpa = table_gfn << PAGE_SHIFT;
-		pte_gpa += index * sizeof(pt_element_t);
+		kvm_write_guest(vcpu->kvm, pte_gpa, &pte, sizeof(pte));
 		kvm_mmu_pte_write(vcpu, pte_gpa, (u8 *)&pte, sizeof(pte));
 	}
 
-	kvm_release_page(page);
 	walker->pte = pte;
 	pgprintk("%s: pte %llx\n", __FUNCTION__, (u64)pte);
 	return 1;
@@ -182,8 +170,6 @@ err:
 		walker->error_code |= PFERR_USER_MASK;
 	if (fetch_fault)
 		walker->error_code |= PFERR_FETCH_MASK;
-	if (page)
-		kvm_release_page(page);
 	return 0;
 }
 
-- 
1.5.3.7

