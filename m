Return-Path: <linux-kernel-owner+w=401wt.eu-S1758891AbXL3HYB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758891AbXL3HYB (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Dec 2007 02:24:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752175AbXL3HLb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Dec 2007 02:11:31 -0500
Received: from il.qumranet.com ([82.166.9.18]:59496 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755751AbXL3HKv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Dec 2007 02:10:51 -0500
From: Avi Kivity <avi@qumranet.com>
To: linux-kernel@vger.kernel.org, kvm-devel@lists.sourceforge.net
Subject: [PATCH 47/52] KVM: MMU: Remove extra gaddr parameter from set_pte_common()
Date: Sun, 30 Dec 2007 09:10:33 +0200
Message-Id: <1198998638-22713-48-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.3.7
In-Reply-To: <1198998638-22713-1-git-send-email-avi@qumranet.com>
References: <1198998638-22713-1-git-send-email-avi@qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Similar information is available in the gfn parameter, so use that.

Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 drivers/kvm/mmu.c         |    1 +
 drivers/kvm/paging_tmpl.h |   29 +++++++++--------------------
 2 files changed, 10 insertions(+), 20 deletions(-)

diff --git a/drivers/kvm/mmu.c b/drivers/kvm/mmu.c
index a9fed59..c3362ba 100644
--- a/drivers/kvm/mmu.c
+++ b/drivers/kvm/mmu.c
@@ -29,6 +29,7 @@
 
 #include <asm/page.h>
 #include <asm/cmpxchg.h>
+#include <asm/io.h>
 
 #undef MMU_DEBUG
 
diff --git a/drivers/kvm/paging_tmpl.h b/drivers/kvm/paging_tmpl.h
index dceb4b9..cc373ed 100644
--- a/drivers/kvm/paging_tmpl.h
+++ b/drivers/kvm/paging_tmpl.h
@@ -188,7 +188,6 @@ err:
 
 static void FNAME(set_pte_common)(struct kvm_vcpu *vcpu,
 				  u64 *shadow_pte,
-				  gpa_t gaddr,
 				  pt_element_t gpte,
 				  u64 access_bits,
 				  int user_fault,
@@ -197,7 +196,6 @@ static void FNAME(set_pte_common)(struct kvm_vcpu *vcpu,
 				  struct guest_walker *walker,
 				  gfn_t gfn)
 {
-	hpa_t paddr;
 	int dirty = gpte & PT_DIRTY_MASK;
 	u64 spte;
 	int was_rmapped = is_rmap_pte(*shadow_pte);
@@ -218,26 +216,20 @@ static void FNAME(set_pte_common)(struct kvm_vcpu *vcpu,
 	if (!dirty)
 		access_bits &= ~PT_WRITABLE_MASK;
 
-	paddr = gpa_to_hpa(vcpu->kvm, gaddr & PT64_BASE_ADDR_MASK);
-
-	/*
-	 * the reason paddr get mask even that it isnt pte is beacuse the
-	 * HPA_ERR_MASK bit might be used to signal error
-	 */
-	page = pfn_to_page((paddr & PT64_BASE_ADDR_MASK) >> PAGE_SHIFT);
+	page = gfn_to_page(vcpu->kvm, gfn);
 
 	spte |= PT_PRESENT_MASK;
 	if (access_bits & PT_USER_MASK)
 		spte |= PT_USER_MASK;
 
-	if (is_error_hpa(paddr)) {
+	if (is_error_page(page)) {
 		set_shadow_pte(shadow_pte,
 			       shadow_trap_nonpresent_pte | PT_SHADOW_IO_MARK);
 		kvm_release_page_clean(page);
 		return;
 	}
 
-	spte |= paddr;
+	spte |= page_to_phys(page);
 
 	if ((access_bits & PT_WRITABLE_MASK)
 	    || (write_fault && !is_write_protection(vcpu) && !user_fault)) {
@@ -266,14 +258,14 @@ static void FNAME(set_pte_common)(struct kvm_vcpu *vcpu,
 unshadowed:
 
 	if (access_bits & PT_WRITABLE_MASK)
-		mark_page_dirty(vcpu->kvm, gaddr >> PAGE_SHIFT);
+		mark_page_dirty(vcpu->kvm, gfn);
 
 	pgprintk("%s: setting spte %llx\n", __FUNCTION__, spte);
 	set_shadow_pte(shadow_pte, spte);
-	page_header_update_slot(vcpu->kvm, shadow_pte, gaddr);
+	page_header_update_slot(vcpu->kvm, shadow_pte,
+				(gpa_t)gfn << PAGE_SHIFT);
 	if (!was_rmapped) {
-		rmap_add(vcpu, shadow_pte, (gaddr & PT64_BASE_ADDR_MASK)
-			 >> PAGE_SHIFT);
+		rmap_add(vcpu, shadow_pte, gfn);
 		if (!is_rmap_pte(*shadow_pte))
 			kvm_release_page_clean(page);
 	}
@@ -289,7 +281,7 @@ static void FNAME(set_pte)(struct kvm_vcpu *vcpu, pt_element_t gpte,
 			   struct guest_walker *walker, gfn_t gfn)
 {
 	access_bits &= gpte;
-	FNAME(set_pte_common)(vcpu, shadow_pte, gpte & PT_BASE_ADDR_MASK,
+	FNAME(set_pte_common)(vcpu, shadow_pte,
 			      gpte, access_bits, user_fault, write_fault,
 			      ptwrite, walker, gfn);
 }
@@ -318,11 +310,8 @@ static void FNAME(set_pde)(struct kvm_vcpu *vcpu, pt_element_t gpde,
 			   int user_fault, int write_fault, int *ptwrite,
 			   struct guest_walker *walker, gfn_t gfn)
 {
-	gpa_t gaddr;
-
 	access_bits &= gpde;
-	gaddr = (gpa_t)gfn << PAGE_SHIFT;
-	FNAME(set_pte_common)(vcpu, shadow_pte, gaddr,
+	FNAME(set_pte_common)(vcpu, shadow_pte,
 			      gpde, access_bits, user_fault, write_fault,
 			      ptwrite, walker, gfn);
 }
-- 
1.5.3.7

