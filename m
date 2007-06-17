Return-Path: <linux-kernel-owner+w=401wt.eu-S1761332AbXFQJy1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761332AbXFQJy1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Jun 2007 05:54:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759666AbXFQJpJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Jun 2007 05:45:09 -0400
Received: from il.qumranet.com ([82.166.9.18]:55187 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759203AbXFQJor (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Jun 2007 05:44:47 -0400
From: Avi Kivity <avi@qumranet.com>
To: kvm-devel@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org, Avi Kivity <avi@qumranet.com>
Subject: [PATCH 36/58] KVM: MMU: Fold fix_read_pf() into set_pte_common()
Date: Sun, 17 Jun 2007 12:44:17 +0300
Message-Id: <1182073480939-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.0.6
In-Reply-To: <1182073479890-git-send-email-avi@qumranet.com>
References: <1182073479890-git-send-email-avi@qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 drivers/kvm/mmu.c         |   17 -----------------
 drivers/kvm/paging_tmpl.h |   34 +++++++++++++++++++++++-----------
 2 files changed, 23 insertions(+), 28 deletions(-)

diff --git a/drivers/kvm/mmu.c b/drivers/kvm/mmu.c
index a763150..2079d69 100644
--- a/drivers/kvm/mmu.c
+++ b/drivers/kvm/mmu.c
@@ -972,23 +972,6 @@ static void inject_page_fault(struct kvm_vcpu *vcpu,
 	kvm_arch_ops->inject_page_fault(vcpu, addr, err_code);
 }
 
-static inline int fix_read_pf(u64 *shadow_ent)
-{
-	if ((*shadow_ent & PT_SHADOW_USER_MASK) &&
-	    !(*shadow_ent & PT_USER_MASK)) {
-		/*
-		 * If supervisor write protect is disabled, we shadow kernel
-		 * pages as user pages so we can trap the write access.
-		 */
-		*shadow_ent |= PT_USER_MASK;
-		*shadow_ent &= ~PT_WRITABLE_MASK;
-
-		return 1;
-
-	}
-	return 0;
-}
-
 static void paging_free(struct kvm_vcpu *vcpu)
 {
 	nonpaging_free(vcpu);
diff --git a/drivers/kvm/paging_tmpl.h b/drivers/kvm/paging_tmpl.h
index 7e998d1..869582b 100644
--- a/drivers/kvm/paging_tmpl.h
+++ b/drivers/kvm/paging_tmpl.h
@@ -197,6 +197,7 @@ static void FNAME(set_pte_common)(struct kvm_vcpu *vcpu,
 				  gpa_t gaddr,
 				  pt_element_t *gpte,
 				  u64 access_bits,
+				  int write_fault,
 				  gfn_t gfn)
 {
 	hpa_t paddr;
@@ -219,6 +220,17 @@ static void FNAME(set_pte_common)(struct kvm_vcpu *vcpu,
 
 	*shadow_pte |= paddr;
 
+	if (!write_fault && (*shadow_pte & PT_SHADOW_USER_MASK) &&
+	    !(*shadow_pte & PT_USER_MASK)) {
+		/*
+		 * If supervisor write protect is disabled, we shadow kernel
+		 * pages as user pages so we can trap the write access.
+		 */
+		*shadow_pte |= PT_USER_MASK;
+		*shadow_pte &= ~PT_WRITABLE_MASK;
+		access_bits &= ~PT_WRITABLE_MASK;
+	}
+
 	if (access_bits & PT_WRITABLE_MASK) {
 		struct kvm_mmu_page *shadow;
 
@@ -242,13 +254,14 @@ static void FNAME(set_pte_common)(struct kvm_vcpu *vcpu,
 }
 
 static void FNAME(set_pte)(struct kvm_vcpu *vcpu, pt_element_t *gpte,
-			   u64 *shadow_pte, u64 access_bits, gfn_t gfn)
+			   u64 *shadow_pte, u64 access_bits,
+			   int write_fault, gfn_t gfn)
 {
 	ASSERT(*shadow_pte == 0);
 	access_bits &= *gpte;
 	*shadow_pte = (*gpte & PT_PTE_COPY_MASK);
 	FNAME(set_pte_common)(vcpu, shadow_pte, *gpte & PT_BASE_ADDR_MASK,
-			      gpte, access_bits, gfn);
+			      gpte, access_bits, write_fault, gfn);
 }
 
 static void FNAME(update_pte)(struct kvm_vcpu *vcpu, struct kvm_mmu_page *page,
@@ -262,12 +275,13 @@ static void FNAME(update_pte)(struct kvm_vcpu *vcpu, struct kvm_mmu_page *page,
 	if (~gpte & (PT_PRESENT_MASK | PT_ACCESSED_MASK))
 		return;
 	pgprintk("%s: gpte %llx spte %p\n", __FUNCTION__, (u64)gpte, spte);
-	FNAME(set_pte)(vcpu, &gpte, spte, PT_USER_MASK | PT_WRITABLE_MASK,
+	FNAME(set_pte)(vcpu, &gpte, spte, PT_USER_MASK | PT_WRITABLE_MASK, 0,
 		       (gpte & PT_BASE_ADDR_MASK) >> PAGE_SHIFT);
 }
 
 static void FNAME(set_pde)(struct kvm_vcpu *vcpu, pt_element_t *gpde,
-			   u64 *shadow_pte, u64 access_bits, gfn_t gfn)
+			   u64 *shadow_pte, u64 access_bits, int write_fault,
+			   gfn_t gfn)
 {
 	gpa_t gaddr;
 
@@ -279,14 +293,14 @@ static void FNAME(set_pde)(struct kvm_vcpu *vcpu, pt_element_t *gpde,
 			(32 - PT32_DIR_PSE36_SHIFT);
 	*shadow_pte = *gpde & PT_PTE_COPY_MASK;
 	FNAME(set_pte_common)(vcpu, shadow_pte, gaddr,
-			      gpde, access_bits, gfn);
+			      gpde, access_bits, write_fault, gfn);
 }
 
 /*
  * Fetch a shadow pte for a specific level in the paging hierarchy.
  */
 static u64 *FNAME(fetch)(struct kvm_vcpu *vcpu, gva_t addr,
-			      struct guest_walker *walker)
+			 struct guest_walker *walker, int write_fault)
 {
 	hpa_t shadow_addr;
 	int level;
@@ -351,12 +365,12 @@ static u64 *FNAME(fetch)(struct kvm_vcpu *vcpu, gva_t addr,
 		if (prev_shadow_ent)
 			*prev_shadow_ent |= PT_SHADOW_PS_MARK;
 		FNAME(set_pde)(vcpu, guest_ent, shadow_ent,
-			       walker->inherited_ar, walker->gfn);
+			       walker->inherited_ar, write_fault, walker->gfn);
 	} else {
 		ASSERT(walker->level == PT_PAGE_TABLE_LEVEL);
 		FNAME(set_pte)(vcpu, guest_ent, shadow_ent,
 			       walker->inherited_ar,
-			       walker->gfn);
+			       write_fault, walker->gfn);
 	}
 	return shadow_ent;
 }
@@ -489,7 +503,7 @@ static int FNAME(page_fault)(struct kvm_vcpu *vcpu, gva_t addr,
 		return 0;
 	}
 
-	shadow_pte = FNAME(fetch)(vcpu, addr, &walker);
+	shadow_pte = FNAME(fetch)(vcpu, addr, &walker, write_fault);
 	pgprintk("%s: shadow pte %p %llx\n", __FUNCTION__,
 		 shadow_pte, *shadow_pte);
 
@@ -499,8 +513,6 @@ static int FNAME(page_fault)(struct kvm_vcpu *vcpu, gva_t addr,
 	if (write_fault)
 		fixed = FNAME(fix_write_pf)(vcpu, shadow_pte, &walker, addr,
 					    user_fault, &write_pt);
-	else
-		fixed = fix_read_pf(shadow_pte);
 
 	pgprintk("%s: updated shadow pte %p %llx\n", __FUNCTION__,
 		 shadow_pte, *shadow_pte);
-- 
1.5.0.6

