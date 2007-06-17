Return-Path: <linux-kernel-owner+w=401wt.eu-S1762583AbXFQKB6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762583AbXFQKB6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Jun 2007 06:01:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759767AbXFQJpt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Jun 2007 05:45:49 -0400
Received: from il.qumranet.com ([82.166.9.18]:55166 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759260AbXFQJor (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Jun 2007 05:44:47 -0400
From: Avi Kivity <avi@qumranet.com>
To: kvm-devel@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org, Avi Kivity <avi@qumranet.com>
Subject: [PATCH 37/58] KVM: MMU: Fold fix_write_pf() into set_pte_common()
Date: Sun, 17 Jun 2007 12:44:18 +0300
Message-Id: <11820734803451-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.0.6
In-Reply-To: <1182073479890-git-send-email-avi@qumranet.com>
References: <1182073479890-git-send-email-avi@qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This prevents some work from being performed twice, and, more importantly,
reduces the number of places where we modify shadow ptes.

Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 drivers/kvm/mmu.c         |   11 +++
 drivers/kvm/paging_tmpl.h |  168 +++++++++++++++-----------------------------
 2 files changed, 68 insertions(+), 111 deletions(-)

diff --git a/drivers/kvm/mmu.c b/drivers/kvm/mmu.c
index 2079d69..3cdbf68 100644
--- a/drivers/kvm/mmu.c
+++ b/drivers/kvm/mmu.c
@@ -731,6 +731,17 @@ static int kvm_mmu_unprotect_page(struct kvm_vcpu *vcpu, gfn_t gfn)
 	return r;
 }
 
+static void mmu_unshadow(struct kvm_vcpu *vcpu, gfn_t gfn)
+{
+	struct kvm_mmu_page *page;
+
+	while ((page = kvm_mmu_lookup_page(vcpu, gfn)) != NULL) {
+		pgprintk("%s: zap %lx %x\n",
+			 __FUNCTION__, gfn, page->role.word);
+		kvm_mmu_zap_page(vcpu, page);
+	}
+}
+
 static void page_header_update_slot(struct kvm *kvm, void *pte, gpa_t gpa)
 {
 	int slot = memslot_id(kvm, gfn_to_memslot(kvm, gpa >> PAGE_SHIFT));
diff --git a/drivers/kvm/paging_tmpl.h b/drivers/kvm/paging_tmpl.h
index 869582b..c067203 100644
--- a/drivers/kvm/paging_tmpl.h
+++ b/drivers/kvm/paging_tmpl.h
@@ -197,11 +197,26 @@ static void FNAME(set_pte_common)(struct kvm_vcpu *vcpu,
 				  gpa_t gaddr,
 				  pt_element_t *gpte,
 				  u64 access_bits,
+				  int user_fault,
 				  int write_fault,
+				  int *ptwrite,
+				  struct guest_walker *walker,
 				  gfn_t gfn)
 {
 	hpa_t paddr;
 	int dirty = *gpte & PT_DIRTY_MASK;
+	int was_rmapped = is_rmap_pte(*shadow_pte);
+
+	pgprintk("%s: spte %llx gpte %llx access %llx write_fault %d"
+		 " user_fault %d gfn %lx\n",
+		 __FUNCTION__, *shadow_pte, (u64)*gpte, access_bits,
+		 write_fault, user_fault, gfn);
+
+	if (write_fault && !dirty) {
+		*gpte |= PT_DIRTY_MASK;
+		dirty = 1;
+		FNAME(mark_pagetable_dirty)(vcpu->kvm, walker);
+	}
 
 	*shadow_pte |= access_bits << PT_SHADOW_BITS_OFFSET;
 	if (!dirty)
@@ -209,7 +224,9 @@ static void FNAME(set_pte_common)(struct kvm_vcpu *vcpu,
 
 	paddr = gpa_to_hpa(vcpu, gaddr & PT64_BASE_ADDR_MASK);
 
-	*shadow_pte |= access_bits;
+	*shadow_pte |= PT_PRESENT_MASK;
+	if (access_bits & PT_USER_MASK)
+		*shadow_pte |= PT_USER_MASK;
 
 	if (is_error_hpa(paddr)) {
 		*shadow_pte |= gaddr;
@@ -231,37 +248,50 @@ static void FNAME(set_pte_common)(struct kvm_vcpu *vcpu,
 		access_bits &= ~PT_WRITABLE_MASK;
 	}
 
-	if (access_bits & PT_WRITABLE_MASK) {
+	if ((access_bits & PT_WRITABLE_MASK)
+	    || (write_fault && !is_write_protection(vcpu) && !user_fault)) {
 		struct kvm_mmu_page *shadow;
 
+		*shadow_pte |= PT_WRITABLE_MASK;
+		if (user_fault) {
+			mmu_unshadow(vcpu, gfn);
+			goto unshadowed;
+		}
+
 		shadow = kvm_mmu_lookup_page(vcpu, gfn);
 		if (shadow) {
 			pgprintk("%s: found shadow page for %lx, marking ro\n",
 				 __FUNCTION__, gfn);
 			access_bits &= ~PT_WRITABLE_MASK;
 			if (is_writeble_pte(*shadow_pte)) {
-				    *shadow_pte &= ~PT_WRITABLE_MASK;
-				    kvm_arch_ops->tlb_flush(vcpu);
+				*shadow_pte &= ~PT_WRITABLE_MASK;
+				kvm_arch_ops->tlb_flush(vcpu);
 			}
+			if (write_fault)
+				*ptwrite = 1;
 		}
 	}
 
+unshadowed:
+
 	if (access_bits & PT_WRITABLE_MASK)
 		mark_page_dirty(vcpu->kvm, gaddr >> PAGE_SHIFT);
 
 	page_header_update_slot(vcpu->kvm, shadow_pte, gaddr);
-	rmap_add(vcpu, shadow_pte);
+	if (!was_rmapped)
+		rmap_add(vcpu, shadow_pte);
 }
 
 static void FNAME(set_pte)(struct kvm_vcpu *vcpu, pt_element_t *gpte,
 			   u64 *shadow_pte, u64 access_bits,
-			   int write_fault, gfn_t gfn)
+			   int user_fault, int write_fault, int *ptwrite,
+			   struct guest_walker *walker, gfn_t gfn)
 {
-	ASSERT(*shadow_pte == 0);
 	access_bits &= *gpte;
-	*shadow_pte = (*gpte & PT_PTE_COPY_MASK);
+	*shadow_pte |= (*gpte & PT_PTE_COPY_MASK);
 	FNAME(set_pte_common)(vcpu, shadow_pte, *gpte & PT_BASE_ADDR_MASK,
-			      gpte, access_bits, write_fault, gfn);
+			      gpte, access_bits, user_fault, write_fault,
+			      ptwrite, walker, gfn);
 }
 
 static void FNAME(update_pte)(struct kvm_vcpu *vcpu, struct kvm_mmu_page *page,
@@ -276,31 +306,34 @@ static void FNAME(update_pte)(struct kvm_vcpu *vcpu, struct kvm_mmu_page *page,
 		return;
 	pgprintk("%s: gpte %llx spte %p\n", __FUNCTION__, (u64)gpte, spte);
 	FNAME(set_pte)(vcpu, &gpte, spte, PT_USER_MASK | PT_WRITABLE_MASK, 0,
+		       0, NULL, NULL,
 		       (gpte & PT_BASE_ADDR_MASK) >> PAGE_SHIFT);
 }
 
 static void FNAME(set_pde)(struct kvm_vcpu *vcpu, pt_element_t *gpde,
-			   u64 *shadow_pte, u64 access_bits, int write_fault,
-			   gfn_t gfn)
+			   u64 *shadow_pte, u64 access_bits,
+			   int user_fault, int write_fault, int *ptwrite,
+			   struct guest_walker *walker, gfn_t gfn)
 {
 	gpa_t gaddr;
 
-	ASSERT(*shadow_pte == 0);
 	access_bits &= *gpde;
 	gaddr = (gpa_t)gfn << PAGE_SHIFT;
 	if (PTTYPE == 32 && is_cpuid_PSE36())
 		gaddr |= (*gpde & PT32_DIR_PSE36_MASK) <<
 			(32 - PT32_DIR_PSE36_SHIFT);
-	*shadow_pte = *gpde & PT_PTE_COPY_MASK;
+	*shadow_pte |= *gpde & PT_PTE_COPY_MASK;
 	FNAME(set_pte_common)(vcpu, shadow_pte, gaddr,
-			      gpde, access_bits, write_fault, gfn);
+			      gpde, access_bits, user_fault, write_fault,
+			      ptwrite, walker, gfn);
 }
 
 /*
  * Fetch a shadow pte for a specific level in the paging hierarchy.
  */
 static u64 *FNAME(fetch)(struct kvm_vcpu *vcpu, gva_t addr,
-			 struct guest_walker *walker, int write_fault)
+			 struct guest_walker *walker,
+			 int user_fault, int write_fault, int *ptwrite)
 {
 	hpa_t shadow_addr;
 	int level;
@@ -330,7 +363,7 @@ static u64 *FNAME(fetch)(struct kvm_vcpu *vcpu, gva_t addr,
 		shadow_ent = ((u64 *)__va(shadow_addr)) + index;
 		if (is_present_pte(*shadow_ent) || is_io_pte(*shadow_ent)) {
 			if (level == PT_PAGE_TABLE_LEVEL)
-				return shadow_ent;
+				break;
 			shadow_addr = *shadow_ent & PT64_BASE_ADDR_MASK;
 			prev_shadow_ent = shadow_ent;
 			continue;
@@ -365,95 +398,18 @@ static u64 *FNAME(fetch)(struct kvm_vcpu *vcpu, gva_t addr,
 		if (prev_shadow_ent)
 			*prev_shadow_ent |= PT_SHADOW_PS_MARK;
 		FNAME(set_pde)(vcpu, guest_ent, shadow_ent,
-			       walker->inherited_ar, write_fault, walker->gfn);
+			       walker->inherited_ar, user_fault, write_fault,
+			       ptwrite, walker, walker->gfn);
 	} else {
 		ASSERT(walker->level == PT_PAGE_TABLE_LEVEL);
 		FNAME(set_pte)(vcpu, guest_ent, shadow_ent,
-			       walker->inherited_ar,
-			       write_fault, walker->gfn);
+			       walker->inherited_ar, user_fault, write_fault,
+			       ptwrite, walker, walker->gfn);
 	}
 	return shadow_ent;
 }
 
 /*
- * The guest faulted for write.  We need to
- *
- * - check write permissions
- * - update the guest pte dirty bit
- * - update our own dirty page tracking structures
- */
-static int FNAME(fix_write_pf)(struct kvm_vcpu *vcpu,
-			       u64 *shadow_ent,
-			       struct guest_walker *walker,
-			       gva_t addr,
-			       int user,
-			       int *write_pt)
-{
-	pt_element_t *guest_ent;
-	int writable_shadow;
-	gfn_t gfn;
-	struct kvm_mmu_page *page;
-
-	if (is_writeble_pte(*shadow_ent))
-		return !user || (*shadow_ent & PT_USER_MASK);
-
-	writable_shadow = *shadow_ent & PT_SHADOW_WRITABLE_MASK;
-	if (user) {
-		/*
-		 * User mode access.  Fail if it's a kernel page or a read-only
-		 * page.
-		 */
-		if (!(*shadow_ent & PT_SHADOW_USER_MASK) || !writable_shadow)
-			return 0;
-		ASSERT(*shadow_ent & PT_USER_MASK);
-	} else
-		/*
-		 * Kernel mode access.  Fail if it's a read-only page and
-		 * supervisor write protection is enabled.
-		 */
-		if (!writable_shadow) {
-			if (is_write_protection(vcpu))
-				return 0;
-			*shadow_ent &= ~PT_USER_MASK;
-		}
-
-	guest_ent = walker->ptep;
-
-	if (!is_present_pte(*guest_ent)) {
-		*shadow_ent = 0;
-		return 0;
-	}
-
-	gfn = walker->gfn;
-
-	if (user) {
-		/*
-		 * Usermode page faults won't be for page table updates.
-		 */
-		while ((page = kvm_mmu_lookup_page(vcpu, gfn)) != NULL) {
-			pgprintk("%s: zap %lx %x\n",
-				 __FUNCTION__, gfn, page->role.word);
-			kvm_mmu_zap_page(vcpu, page);
-		}
-	} else if (kvm_mmu_lookup_page(vcpu, gfn)) {
-		pgprintk("%s: found shadow page for %lx, marking ro\n",
-			 __FUNCTION__, gfn);
-		mark_page_dirty(vcpu->kvm, gfn);
-		FNAME(mark_pagetable_dirty)(vcpu->kvm, walker);
-		*guest_ent |= PT_DIRTY_MASK;
-		*write_pt = 1;
-		return 0;
-	}
-	mark_page_dirty(vcpu->kvm, gfn);
-	*shadow_ent |= PT_WRITABLE_MASK;
-	FNAME(mark_pagetable_dirty)(vcpu->kvm, walker);
-	*guest_ent |= PT_DIRTY_MASK;
-	rmap_add(vcpu, shadow_ent);
-
-	return 1;
-}
-
-/*
  * Page fault handler.  There are several causes for a page fault:
  *   - there is no shadow pte for the guest pte
  *   - write access through a shadow pte marked read only so that we can set
@@ -475,7 +431,6 @@ static int FNAME(page_fault)(struct kvm_vcpu *vcpu, gva_t addr,
 	int fetch_fault = error_code & PFERR_FETCH_MASK;
 	struct guest_walker walker;
 	u64 *shadow_pte;
-	int fixed;
 	int write_pt = 0;
 	int r;
 
@@ -503,19 +458,10 @@ static int FNAME(page_fault)(struct kvm_vcpu *vcpu, gva_t addr,
 		return 0;
 	}
 
-	shadow_pte = FNAME(fetch)(vcpu, addr, &walker, write_fault);
-	pgprintk("%s: shadow pte %p %llx\n", __FUNCTION__,
-		 shadow_pte, *shadow_pte);
-
-	/*
-	 * Update the shadow pte.
-	 */
-	if (write_fault)
-		fixed = FNAME(fix_write_pf)(vcpu, shadow_pte, &walker, addr,
-					    user_fault, &write_pt);
-
-	pgprintk("%s: updated shadow pte %p %llx\n", __FUNCTION__,
-		 shadow_pte, *shadow_pte);
+	shadow_pte = FNAME(fetch)(vcpu, addr, &walker, user_fault, write_fault,
+				  &write_pt);
+	pgprintk("%s: shadow pte %p %llx ptwrite %d\n", __FUNCTION__,
+		 shadow_pte, *shadow_pte, write_pt);
 
 	FNAME(release_walker)(&walker);
 
-- 
1.5.0.6

