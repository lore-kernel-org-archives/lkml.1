Return-Path: <linux-kernel-owner+w=401wt.eu-S1759541AbYAAPyP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759541AbYAAPyP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jan 2008 10:54:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755421AbYAAPhO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Jan 2008 10:37:14 -0500
Received: from il.qumranet.com ([82.166.9.18]:33801 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755125AbYAAPg3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jan 2008 10:36:29 -0500
From: Avi Kivity <avi@qumranet.com>
To: linux-kernel@vger.kernel.org, kvm-devel@lists.sourceforge.net
Cc: Marcelo Tosatti <marcelo@kvack.org>
Subject: [PATCH 41/54] KVM: MMU: Use cmpxchg for pte updates on walk_addr()
Date: Tue,  1 Jan 2008 17:36:07 +0200
Message-Id: <1199201780-14001-42-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.3.7
In-Reply-To: <1199201780-14001-1-git-send-email-avi@qumranet.com>
References: <1199201780-14001-1-git-send-email-avi@qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Marcelo Tosatti <marcelo@kvack.org>

In preparation for multi-threaded guest pte walking, use cmpxchg()
when updating guest pte's. This guarantees that the assignment of the
dirty bit can't be lost if two CPU's are faulting the same address
simultaneously.

[avi: fix kunmap_atomic() parameters]

Signed-off-by: Marcelo Tosatti <mtosatti@redhat.com>
Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 drivers/kvm/paging_tmpl.h |   36 ++++++++++++++++++++++++++++++++++--
 1 files changed, 34 insertions(+), 2 deletions(-)

diff --git a/drivers/kvm/paging_tmpl.h b/drivers/kvm/paging_tmpl.h
index 3c40a59..8086f82 100644
--- a/drivers/kvm/paging_tmpl.h
+++ b/drivers/kvm/paging_tmpl.h
@@ -34,7 +34,9 @@
 	#define PT_LEVEL_BITS PT64_LEVEL_BITS
 	#ifdef CONFIG_X86_64
 	#define PT_MAX_FULL_LEVELS 4
+	#define CMPXCHG cmpxchg
 	#else
+	#define CMPXCHG cmpxchg64
 	#define PT_MAX_FULL_LEVELS 2
 	#endif
 #elif PTTYPE == 32
@@ -48,6 +50,7 @@
 	#define PT_LEVEL_MASK(level) PT32_LEVEL_MASK(level)
 	#define PT_LEVEL_BITS PT32_LEVEL_BITS
 	#define PT_MAX_FULL_LEVELS 2
+	#define CMPXCHG cmpxchg
 #else
 	#error Invalid PTTYPE value
 #endif
@@ -78,6 +81,26 @@ static gfn_t gpte_to_gfn_pde(pt_element_t gpte)
 	return (gpte & PT_DIR_BASE_ADDR_MASK) >> PAGE_SHIFT;
 }
 
+static bool FNAME(cmpxchg_gpte)(struct kvm *kvm,
+			 gfn_t table_gfn, unsigned index,
+			 pt_element_t orig_pte, pt_element_t new_pte)
+{
+	pt_element_t ret;
+	pt_element_t *table;
+	struct page *page;
+
+	page = gfn_to_page(kvm, table_gfn);
+	table = kmap_atomic(page, KM_USER0);
+
+	ret = CMPXCHG(&table[index], orig_pte, new_pte);
+
+	kunmap_atomic(table, KM_USER0);
+
+	kvm_release_page_dirty(page);
+
+	return (ret != orig_pte);
+}
+
 /*
  * Fetch a guest pte for a guest virtual address
  */
@@ -91,6 +114,7 @@ static int FNAME(walk_addr)(struct guest_walker *walker,
 	gpa_t pte_gpa;
 
 	pgprintk("%s: addr %lx\n", __FUNCTION__, addr);
+walk:
 	walker->level = vcpu->mmu.root_level;
 	pte = vcpu->cr3;
 #if PTTYPE == 64
@@ -135,8 +159,10 @@ static int FNAME(walk_addr)(struct guest_walker *walker,
 
 		if (!(pte & PT_ACCESSED_MASK)) {
 			mark_page_dirty(vcpu->kvm, table_gfn);
+			if (FNAME(cmpxchg_gpte)(vcpu->kvm, table_gfn,
+			    index, pte, pte|PT_ACCESSED_MASK))
+				goto walk;
 			pte |= PT_ACCESSED_MASK;
-			kvm_write_guest(vcpu->kvm, pte_gpa, &pte, sizeof(pte));
 		}
 
 		if (walker->level == PT_PAGE_TABLE_LEVEL) {
@@ -159,9 +185,14 @@ static int FNAME(walk_addr)(struct guest_walker *walker,
 	}
 
 	if (write_fault && !is_dirty_pte(pte)) {
+		bool ret;
+
 		mark_page_dirty(vcpu->kvm, table_gfn);
+		ret = FNAME(cmpxchg_gpte)(vcpu->kvm, table_gfn, index, pte,
+			    pte|PT_DIRTY_MASK);
+		if (ret)
+			goto walk;
 		pte |= PT_DIRTY_MASK;
-		kvm_write_guest(vcpu->kvm, pte_gpa, &pte, sizeof(pte));
 		kvm_mmu_pte_write(vcpu, pte_gpa, (u8 *)&pte, sizeof(pte));
 	}
 
@@ -484,3 +515,4 @@ static void FNAME(prefetch_page)(struct kvm_vcpu *vcpu,
 #undef PT_MAX_FULL_LEVELS
 #undef gpte_to_gfn
 #undef gpte_to_gfn_pde
+#undef CMPXCHG
-- 
1.5.3.7

