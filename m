Return-Path: <linux-kernel-owner+w=401wt.eu-S1761044AbXFQJxm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761044AbXFQJxm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Jun 2007 05:53:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759646AbXFQJpF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Jun 2007 05:45:05 -0400
Received: from il.qumranet.com ([82.166.9.18]:55188 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759215AbXFQJor (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Jun 2007 05:44:47 -0400
From: Avi Kivity <avi@qumranet.com>
To: kvm-devel@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org, Avi Kivity <avi@qumranet.com>
Subject: [PATCH 35/58] KVM: MMU: Pass the guest pde to set_pte_common
Date: Sun, 17 Jun 2007 12:44:16 +0300
Message-Id: <11820734802695-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.0.6
In-Reply-To: <1182073479890-git-send-email-avi@qumranet.com>
References: <1182073479890-git-send-email-avi@qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

We will need the accessed bit (in addition to the dirty bit) and
also write access (for setting the dirty bit) in a future patch.

Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 drivers/kvm/paging_tmpl.h |   29 +++++++++++++++--------------
 1 files changed, 15 insertions(+), 14 deletions(-)

diff --git a/drivers/kvm/paging_tmpl.h b/drivers/kvm/paging_tmpl.h
index 6576300..7e998d1 100644
--- a/drivers/kvm/paging_tmpl.h
+++ b/drivers/kvm/paging_tmpl.h
@@ -195,11 +195,12 @@ static void FNAME(mark_pagetable_dirty)(struct kvm *kvm,
 static void FNAME(set_pte_common)(struct kvm_vcpu *vcpu,
 				  u64 *shadow_pte,
 				  gpa_t gaddr,
-				  int dirty,
+				  pt_element_t *gpte,
 				  u64 access_bits,
 				  gfn_t gfn)
 {
 	hpa_t paddr;
+	int dirty = *gpte & PT_DIRTY_MASK;
 
 	*shadow_pte |= access_bits << PT_SHADOW_BITS_OFFSET;
 	if (!dirty)
@@ -240,14 +241,14 @@ static void FNAME(set_pte_common)(struct kvm_vcpu *vcpu,
 	rmap_add(vcpu, shadow_pte);
 }
 
-static void FNAME(set_pte)(struct kvm_vcpu *vcpu, u64 guest_pte,
+static void FNAME(set_pte)(struct kvm_vcpu *vcpu, pt_element_t *gpte,
 			   u64 *shadow_pte, u64 access_bits, gfn_t gfn)
 {
 	ASSERT(*shadow_pte == 0);
-	access_bits &= guest_pte;
-	*shadow_pte = (guest_pte & PT_PTE_COPY_MASK);
-	FNAME(set_pte_common)(vcpu, shadow_pte, guest_pte & PT_BASE_ADDR_MASK,
-			      guest_pte & PT_DIRTY_MASK, access_bits, gfn);
+	access_bits &= *gpte;
+	*shadow_pte = (*gpte & PT_PTE_COPY_MASK);
+	FNAME(set_pte_common)(vcpu, shadow_pte, *gpte & PT_BASE_ADDR_MASK,
+			      gpte, access_bits, gfn);
 }
 
 static void FNAME(update_pte)(struct kvm_vcpu *vcpu, struct kvm_mmu_page *page,
@@ -261,24 +262,24 @@ static void FNAME(update_pte)(struct kvm_vcpu *vcpu, struct kvm_mmu_page *page,
 	if (~gpte & (PT_PRESENT_MASK | PT_ACCESSED_MASK))
 		return;
 	pgprintk("%s: gpte %llx spte %p\n", __FUNCTION__, (u64)gpte, spte);
-	FNAME(set_pte)(vcpu, gpte, spte, PT_USER_MASK | PT_WRITABLE_MASK,
+	FNAME(set_pte)(vcpu, &gpte, spte, PT_USER_MASK | PT_WRITABLE_MASK,
 		       (gpte & PT_BASE_ADDR_MASK) >> PAGE_SHIFT);
 }
 
-static void FNAME(set_pde)(struct kvm_vcpu *vcpu, u64 guest_pde,
+static void FNAME(set_pde)(struct kvm_vcpu *vcpu, pt_element_t *gpde,
 			   u64 *shadow_pte, u64 access_bits, gfn_t gfn)
 {
 	gpa_t gaddr;
 
 	ASSERT(*shadow_pte == 0);
-	access_bits &= guest_pde;
+	access_bits &= *gpde;
 	gaddr = (gpa_t)gfn << PAGE_SHIFT;
 	if (PTTYPE == 32 && is_cpuid_PSE36())
-		gaddr |= (guest_pde & PT32_DIR_PSE36_MASK) <<
+		gaddr |= (*gpde & PT32_DIR_PSE36_MASK) <<
 			(32 - PT32_DIR_PSE36_SHIFT);
-	*shadow_pte = guest_pde & PT_PTE_COPY_MASK;
+	*shadow_pte = *gpde & PT_PTE_COPY_MASK;
 	FNAME(set_pte_common)(vcpu, shadow_pte, gaddr,
-			      guest_pde & PT_DIRTY_MASK, access_bits, gfn);
+			      gpde, access_bits, gfn);
 }
 
 /*
@@ -349,11 +350,11 @@ static u64 *FNAME(fetch)(struct kvm_vcpu *vcpu, gva_t addr,
 	if (walker->level == PT_DIRECTORY_LEVEL) {
 		if (prev_shadow_ent)
 			*prev_shadow_ent |= PT_SHADOW_PS_MARK;
-		FNAME(set_pde)(vcpu, *guest_ent, shadow_ent,
+		FNAME(set_pde)(vcpu, guest_ent, shadow_ent,
 			       walker->inherited_ar, walker->gfn);
 	} else {
 		ASSERT(walker->level == PT_PAGE_TABLE_LEVEL);
-		FNAME(set_pte)(vcpu, *guest_ent, shadow_ent,
+		FNAME(set_pte)(vcpu, guest_ent, shadow_ent,
 			       walker->inherited_ar,
 			       walker->gfn);
 	}
-- 
1.5.0.6

