Return-Path: <linux-kernel-owner+w=401wt.eu-S1765543AbXGWG70@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765543AbXGWG70 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jul 2007 02:59:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763808AbXGWG5P
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jul 2007 02:57:15 -0400
Received: from mga01.intel.com ([192.55.52.88]:55412 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761187AbXGWG4w (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jul 2007 02:56:52 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.16,569,1175497200"; 
   d="scan'208";a="271462896"
Subject: [RFC 4/8]KVM: move gfn_to_page out of kmap/unmap pars
From: Shaohua Li <shaohua.li@intel.com>
To: kvm-devel <kvm-devel@lists.sourceforge.net>,
       lkml <linux-kernel@vger.kernel.org>
Cc: Avi Kivity <avi@qumranet.com>, Ingo Molnar <mingo@elte.hu>
Content-Type: text/plain
Date: Mon, 23 Jul 2007 14:51:39 +0800
Message-Id: <1185173499.2645.68.camel@sli10-conroe.sh.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 (2.8.3-2.fc6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

gfn_to_page might sleep with swap support. Move it out of the kmap calls.

Signed-off-by: Shaohua Li <shaohua.li@intel.com>
---
 drivers/kvm/kvm.h         |    2 -
 drivers/kvm/kvm_main.c    |    9 ++---
 drivers/kvm/mmu.c         |    2 -
 drivers/kvm/paging_tmpl.h |   80 +++++++++++++++++++++++++++-------------------
 4 files changed, 54 insertions(+), 39 deletions(-)

Index: linux/drivers/kvm/kvm.h
===================================================================
--- linux.orig/drivers/kvm/kvm.h	2007-07-18 16:11:47.000000000 +0800
+++ linux/drivers/kvm/kvm.h	2007-07-20 14:19:15.000000000 +0800
@@ -616,7 +616,7 @@ int kvm_write_guest(struct kvm_vcpu *vcp
 unsigned long segment_base(u16 selector);
 
 void kvm_mmu_pte_write(struct kvm_vcpu *vcpu, gpa_t gpa,
-		       const u8 *old, const u8 *new, int bytes);
+		       const u8 *new, int bytes);
 int kvm_mmu_unprotect_page_virt(struct kvm_vcpu *vcpu, gva_t gva);
 void kvm_mmu_free_some_pages(struct kvm_vcpu *vcpu);
 int kvm_mmu_load(struct kvm_vcpu *vcpu);
Index: linux/drivers/kvm/kvm_main.c
===================================================================
--- linux.orig/drivers/kvm/kvm_main.c	2007-07-18 16:11:47.000000000 +0800
+++ linux/drivers/kvm/kvm_main.c	2007-07-20 14:19:14.000000000 +0800
@@ -1123,7 +1123,6 @@ static int emulator_write_phys(struct kv
 {
 	struct page *page;
 	void *virt;
-	unsigned offset = offset_in_page(gpa);
 
 	if (((gpa + bytes - 1) >> PAGE_SHIFT) != (gpa >> PAGE_SHIFT))
 		return 0;
@@ -1133,7 +1132,9 @@ static int emulator_write_phys(struct kv
 	mark_page_dirty(vcpu->kvm, gpa >> PAGE_SHIFT);
 	virt = kmap_atomic(page, KM_USER0);
 	if (memcmp(virt + offset_in_page(gpa), val, bytes)) {
-		kvm_mmu_pte_write(vcpu, gpa, virt + offset, val, bytes);
+		kunmap_atomic(virt, KM_USER0);
+		kvm_mmu_pte_write(vcpu, gpa, val, bytes);
+		virt = kmap_atomic(page, KM_USER0);
 		memcpy(virt + offset_in_page(gpa), val, bytes);
 	}
 	kunmap_atomic(virt, KM_USER0);
@@ -1483,7 +1484,7 @@ static int vcpu_register_para(struct kvm
 
 	mark_page_dirty(vcpu->kvm, para_state_gpa >> PAGE_SHIFT);
 	para_state_page = pfn_to_page(para_state_hpa >> PAGE_SHIFT);
-	para_state = kmap_atomic(para_state_page, KM_USER0);
+	para_state = kmap(para_state_page);
 
 	printk(KERN_DEBUG "....  guest version: %d\n", para_state->guest_version);
 	printk(KERN_DEBUG "....           size: %d\n", para_state->size);
@@ -1519,7 +1520,7 @@ static int vcpu_register_para(struct kvm
 
 	para_state->ret = 0;
 err_kunmap_skip:
-	kunmap_atomic(para_state, KM_USER0);
+	kunmap(para_state_page);
 	return 0;
 err_gp:
 	return 1;
Index: linux/drivers/kvm/mmu.c
===================================================================
--- linux.orig/drivers/kvm/mmu.c	2007-07-18 16:11:47.000000000 +0800
+++ linux/drivers/kvm/mmu.c	2007-07-20 14:19:16.000000000 +0800
@@ -1112,7 +1112,7 @@ static void mmu_pte_write_new_pte(struct
 }
 
 void kvm_mmu_pte_write(struct kvm_vcpu *vcpu, gpa_t gpa,
-		       const u8 *old, const u8 *new, int bytes)
+		       const u8 *new, int bytes)
 {
 	gfn_t gfn = gpa >> PAGE_SHIFT;
 	struct kvm_mmu_page *page;
Index: linux/drivers/kvm/paging_tmpl.h
===================================================================
--- linux.orig/drivers/kvm/paging_tmpl.h	2007-07-18 16:11:12.000000000 +0800
+++ linux/drivers/kvm/paging_tmpl.h	2007-07-20 14:20:50.000000000 +0800
@@ -58,7 +58,10 @@ struct guest_walker {
 	int level;
 	gfn_t table_gfn[PT_MAX_FULL_LEVELS];
 	pt_element_t *table;
+	pt_element_t pte;
 	pt_element_t *ptep;
+	struct page *page;
+	int index;
 	pt_element_t inherited_ar;
 	gfn_t gfn;
 	u32 error_code;
@@ -80,11 +83,14 @@ static int FNAME(walk_addr)(struct guest
 	pgprintk("%s: addr %lx\n", __FUNCTION__, addr);
 	walker->level = vcpu->mmu.root_level;
 	walker->table = NULL;
+	walker->page = NULL;
+	walker->ptep = NULL;
 	root = vcpu->cr3;
 #if PTTYPE == 64
 	if (!is_long_mode(vcpu)) {
 		walker->ptep = &vcpu->pdptrs[(addr >> 30) & 3];
 		root = *walker->ptep;
+		walker->pte = root;
 		if (!(root & PT_PRESENT_MASK))
 			goto not_present;
 		--walker->level;
@@ -96,7 +102,8 @@ static int FNAME(walk_addr)(struct guest
 		 walker->level - 1, table_gfn);
 	slot = gfn_to_memslot(vcpu->kvm, table_gfn);
 	hpa = safe_gpa_to_hpa(vcpu, root & PT64_BASE_ADDR_MASK);
-	walker->table = kmap_atomic(pfn_to_page(hpa >> PAGE_SHIFT), KM_USER0);
+	walker->page = pfn_to_page(hpa >> PAGE_SHIFT);
+	walker->table = kmap_atomic(walker->page, KM_USER0);
 
 	ASSERT((!is_long_mode(vcpu) && is_pae(vcpu)) ||
 	       (vcpu->cr3 & ~(PAGE_MASK | CR3_FLAGS_MASK)) == 0);
@@ -108,6 +115,7 @@ static int FNAME(walk_addr)(struct guest
 		hpa_t paddr;
 
 		ptep = &walker->table[index];
+		walker->index = index;
 		ASSERT(((unsigned long)walker->table & PAGE_MASK) ==
 		       ((unsigned long)ptep & PAGE_MASK));
 
@@ -148,16 +156,20 @@ static int FNAME(walk_addr)(struct guest
 
 		walker->inherited_ar &= walker->table[index];
 		table_gfn = (*ptep & PT_BASE_ADDR_MASK) >> PAGE_SHIFT;
-		paddr = safe_gpa_to_hpa(vcpu, *ptep & PT_BASE_ADDR_MASK);
 		kunmap_atomic(walker->table, KM_USER0);
-		walker->table = kmap_atomic(pfn_to_page(paddr >> PAGE_SHIFT),
-					    KM_USER0);
+		paddr = safe_gpa_to_hpa(vcpu, table_gfn << PAGE_SHIFT);
+		walker->page = pfn_to_page(paddr >> PAGE_SHIFT);
+		walker->table = kmap_atomic(walker->page, KM_USER0);
 		--walker->level;
 		walker->table_gfn[walker->level - 1 ] = table_gfn;
 		pgprintk("%s: table_gfn[%d] %lx\n", __FUNCTION__,
 			 walker->level - 1, table_gfn);
 	}
-	walker->ptep = ptep;
+	walker->pte = *ptep;
+	if (walker->page)
+		walker->ptep = NULL;
+	if (walker->table)
+		kunmap_atomic(walker->table, KM_USER0);
 	pgprintk("%s: pte %llx\n", __FUNCTION__, (u64)*ptep);
 	return 1;
 
@@ -175,13 +187,9 @@ err:
 		walker->error_code |= PFERR_USER_MASK;
 	if (fetch_fault)
 		walker->error_code |= PFERR_FETCH_MASK;
-	return 0;
-}
-
-static void FNAME(release_walker)(struct guest_walker *walker)
-{
 	if (walker->table)
 		kunmap_atomic(walker->table, KM_USER0);
+	return 0;
 }
 
 static void FNAME(mark_pagetable_dirty)(struct kvm *kvm,
@@ -193,7 +201,7 @@ static void FNAME(mark_pagetable_dirty)(
 static void FNAME(set_pte_common)(struct kvm_vcpu *vcpu,
 				  u64 *shadow_pte,
 				  gpa_t gaddr,
-				  pt_element_t *gpte,
+				  pt_element_t gpte,
 				  u64 access_bits,
 				  int user_fault,
 				  int write_fault,
@@ -202,23 +210,34 @@ static void FNAME(set_pte_common)(struct
 				  gfn_t gfn)
 {
 	hpa_t paddr;
-	int dirty = *gpte & PT_DIRTY_MASK;
+	int dirty = gpte & PT_DIRTY_MASK;
 	u64 spte = *shadow_pte;
 	int was_rmapped = is_rmap_pte(spte);
 
 	pgprintk("%s: spte %llx gpte %llx access %llx write_fault %d"
 		 " user_fault %d gfn %lx\n",
-		 __FUNCTION__, spte, (u64)*gpte, access_bits,
+		 __FUNCTION__, spte, (u64)gpte, access_bits,
 		 write_fault, user_fault, gfn);
 
 	if (write_fault && !dirty) {
-		*gpte |= PT_DIRTY_MASK;
+		pt_element_t *guest_ent, *tmp = NULL;
+
+		if (walker->ptep)
+			guest_ent = walker->ptep;
+		else {
+			tmp = kmap_atomic(walker->page, KM_USER0);
+			guest_ent = &tmp[walker->index];
+		}
+
+		*guest_ent |= PT_DIRTY_MASK;
+		if (!walker->ptep)
+			kunmap_atomic(tmp, KM_USER0);
 		dirty = 1;
 		FNAME(mark_pagetable_dirty)(vcpu->kvm, walker);
 	}
 
 	spte |= PT_PRESENT_MASK | PT_ACCESSED_MASK | PT_DIRTY_MASK;
-	spte |= *gpte & PT64_NX_MASK;
+	spte |= gpte & PT64_NX_MASK;
 	if (!dirty)
 		access_bits &= ~PT_WRITABLE_MASK;
 
@@ -273,13 +292,13 @@ unshadowed:
 		rmap_add(vcpu, shadow_pte);
 }
 
-static void FNAME(set_pte)(struct kvm_vcpu *vcpu, pt_element_t *gpte,
+static void FNAME(set_pte)(struct kvm_vcpu *vcpu, pt_element_t gpte,
 			   u64 *shadow_pte, u64 access_bits,
 			   int user_fault, int write_fault, int *ptwrite,
 			   struct guest_walker *walker, gfn_t gfn)
 {
-	access_bits &= *gpte;
-	FNAME(set_pte_common)(vcpu, shadow_pte, *gpte & PT_BASE_ADDR_MASK,
+	access_bits &= gpte;
+	FNAME(set_pte_common)(vcpu, shadow_pte, gpte & PT_BASE_ADDR_MASK,
 			      gpte, access_bits, user_fault, write_fault,
 			      ptwrite, walker, gfn);
 }
@@ -295,22 +314,22 @@ static void FNAME(update_pte)(struct kvm
 	if (~gpte & (PT_PRESENT_MASK | PT_ACCESSED_MASK))
 		return;
 	pgprintk("%s: gpte %llx spte %p\n", __FUNCTION__, (u64)gpte, spte);
-	FNAME(set_pte)(vcpu, &gpte, spte, PT_USER_MASK | PT_WRITABLE_MASK, 0,
+	FNAME(set_pte)(vcpu, gpte, spte, PT_USER_MASK | PT_WRITABLE_MASK, 0,
 		       0, NULL, NULL,
 		       (gpte & PT_BASE_ADDR_MASK) >> PAGE_SHIFT);
 }
 
-static void FNAME(set_pde)(struct kvm_vcpu *vcpu, pt_element_t *gpde,
+static void FNAME(set_pde)(struct kvm_vcpu *vcpu, pt_element_t gpde,
 			   u64 *shadow_pte, u64 access_bits,
 			   int user_fault, int write_fault, int *ptwrite,
 			   struct guest_walker *walker, gfn_t gfn)
 {
 	gpa_t gaddr;
 
-	access_bits &= *gpde;
+	access_bits &= gpde;
 	gaddr = (gpa_t)gfn << PAGE_SHIFT;
 	if (PTTYPE == 32 && is_cpuid_PSE36())
-		gaddr |= (*gpde & PT32_DIR_PSE36_MASK) <<
+		gaddr |= (gpde & PT32_DIR_PSE36_MASK) <<
 			(32 - PT32_DIR_PSE36_SHIFT);
 	FNAME(set_pte_common)(vcpu, shadow_pte, gaddr,
 			      gpde, access_bits, user_fault, write_fault,
@@ -328,9 +347,8 @@ static u64 *FNAME(fetch)(struct kvm_vcpu
 	int level;
 	u64 *shadow_ent;
 	u64 *prev_shadow_ent = NULL;
-	pt_element_t *guest_ent = walker->ptep;
 
-	if (!is_present_pte(*guest_ent))
+	if (!is_present_pte(walker->pte))
 		return NULL;
 
 	shadow_addr = vcpu->mmu.root_hpa;
@@ -364,12 +382,12 @@ static u64 *FNAME(fetch)(struct kvm_vcpu
 		if (level - 1 == PT_PAGE_TABLE_LEVEL
 		    && walker->level == PT_DIRECTORY_LEVEL) {
 			metaphysical = 1;
-			hugepage_access = *guest_ent;
+			hugepage_access = walker->pte;
 			hugepage_access &= PT_USER_MASK | PT_WRITABLE_MASK;
-			if (*guest_ent & PT64_NX_MASK)
+			if (walker->pte & PT64_NX_MASK)
 				hugepage_access |= (1 << 2);
 			hugepage_access >>= PT_WRITABLE_SHIFT;
-			table_gfn = (*guest_ent & PT_BASE_ADDR_MASK)
+			table_gfn = (walker->pte & PT_BASE_ADDR_MASK)
 				>> PAGE_SHIFT;
 		} else {
 			metaphysical = 0;
@@ -386,12 +404,12 @@ static u64 *FNAME(fetch)(struct kvm_vcpu
 	}
 
 	if (walker->level == PT_DIRECTORY_LEVEL) {
-		FNAME(set_pde)(vcpu, guest_ent, shadow_ent,
+		FNAME(set_pde)(vcpu, walker->pte, shadow_ent,
 			       walker->inherited_ar, user_fault, write_fault,
 			       ptwrite, walker, walker->gfn);
 	} else {
 		ASSERT(walker->level == PT_PAGE_TABLE_LEVEL);
-		FNAME(set_pte)(vcpu, guest_ent, shadow_ent,
+		FNAME(set_pte)(vcpu, walker->pte, shadow_ent,
 			       walker->inherited_ar, user_fault, write_fault,
 			       ptwrite, walker, walker->gfn);
 	}
@@ -442,7 +460,6 @@ static int FNAME(page_fault)(struct kvm_
 	if (!r) {
 		pgprintk("%s: guest page fault\n", __FUNCTION__);
 		inject_page_fault(vcpu, addr, walker.error_code);
-		FNAME(release_walker)(&walker);
 		vcpu->last_pt_write_count = 0; /* reset fork detector */
 		return 0;
 	}
@@ -452,8 +469,6 @@ static int FNAME(page_fault)(struct kvm_
 	pgprintk("%s: shadow pte %p %llx ptwrite %d\n", __FUNCTION__,
 		 shadow_pte, *shadow_pte, write_pt);
 
-	FNAME(release_walker)(&walker);
-
 	if (!write_pt)
 		vcpu->last_pt_write_count = 0; /* reset fork detector */
 
@@ -482,7 +497,6 @@ static gpa_t FNAME(gva_to_gpa)(struct kv
 		gpa |= vaddr & ~PAGE_MASK;
 	}
 
-	FNAME(release_walker)(&walker);
 	return gpa;
 }
 
