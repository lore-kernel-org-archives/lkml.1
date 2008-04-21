Return-Path: <linux-kernel-owner+w=401wt.eu-S1758087AbYDUKbl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758087AbYDUKbl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2008 06:31:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756106AbYDUKaJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Apr 2008 06:30:09 -0400
Received: from bzq-179-150-194.static.bezeqint.net ([212.179.150.194]:37841
	"EHLO il.qumranet.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754119AbYDUKaA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2008 06:30:00 -0400
From: Avi Kivity <avi@qumranet.com>
To: kvm-devel@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org, Anthony Liguori <aliguori@us.ibm.com>
Subject: [PATCH 01/31] KVM: MMU: Don't assume struct page for x86
Date: Mon, 21 Apr 2008 13:29:27 +0300
Message-Id: <1208773797-7829-2-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.5
In-Reply-To: <1208773797-7829-1-git-send-email-avi@qumranet.com>
References: <1208773797-7829-1-git-send-email-avi@qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Anthony Liguori <aliguori@us.ibm.com>

This patch introduces a gfn_to_pfn() function and corresponding functions like
kvm_release_pfn_dirty().  Using these new functions, we can modify the x86
MMU to no longer assume that it can always get a struct page for any given gfn.

We don't want to eliminate gfn_to_page() entirely because a number of places
assume they can do gfn_to_page() and then kmap() the results.  When we support
IO memory, gfn_to_page() will fail for IO pages although gfn_to_pfn() will
succeed.

This does not implement support for avoiding reference counting for reserved
RAM or for IO memory.  However, it should make those things pretty straight
forward.

Since we're only introducing new common symbols, I don't think it will break
the non-x86 architectures but I haven't tested those.  I've tested Intel,
AMD, NPT, and hugetlbfs with Windows and Linux guests.

[avi: fix overflow when shifting left pfns by adding casts]

Signed-off-by: Anthony Liguori <aliguori@us.ibm.com>
Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 arch/x86/kvm/mmu.c         |   89 +++++++++++++++++++++----------------------
 arch/x86/kvm/paging_tmpl.h |   26 ++++++------
 include/asm-x86/kvm_host.h |    4 +-
 include/linux/kvm_host.h   |   12 ++++++
 include/linux/kvm_types.h  |    2 +
 virt/kvm/kvm_main.c        |   68 ++++++++++++++++++++++++++++++---
 6 files changed, 133 insertions(+), 68 deletions(-)

diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index c89bf23..078a7f1 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -240,11 +240,9 @@ static int is_rmap_pte(u64 pte)
 	return is_shadow_present_pte(pte);
 }
 
-static struct page *spte_to_page(u64 pte)
+static pfn_t spte_to_pfn(u64 pte)
 {
-	hfn_t hfn = (pte & PT64_BASE_ADDR_MASK) >> PAGE_SHIFT;
-
-	return pfn_to_page(hfn);
+	return (pte & PT64_BASE_ADDR_MASK) >> PAGE_SHIFT;
 }
 
 static gfn_t pse36_gfn_delta(u32 gpte)
@@ -541,20 +539,20 @@ static void rmap_remove(struct kvm *kvm, u64 *spte)
 	struct kvm_rmap_desc *desc;
 	struct kvm_rmap_desc *prev_desc;
 	struct kvm_mmu_page *sp;
-	struct page *page;
+	pfn_t pfn;
 	unsigned long *rmapp;
 	int i;
 
 	if (!is_rmap_pte(*spte))
 		return;
 	sp = page_header(__pa(spte));
-	page = spte_to_page(*spte);
+	pfn = spte_to_pfn(*spte);
 	if (*spte & PT_ACCESSED_MASK)
-		mark_page_accessed(page);
+		kvm_set_pfn_accessed(pfn);
 	if (is_writeble_pte(*spte))
-		kvm_release_page_dirty(page);
+		kvm_release_pfn_dirty(pfn);
 	else
-		kvm_release_page_clean(page);
+		kvm_release_pfn_clean(pfn);
 	rmapp = gfn_to_rmap(kvm, sp->gfns[spte - sp->spt], is_large_pte(*spte));
 	if (!*rmapp) {
 		printk(KERN_ERR "rmap_remove: %p %llx 0->BUG\n", spte, *spte);
@@ -635,11 +633,11 @@ static void rmap_write_protect(struct kvm *kvm, u64 gfn)
 		spte = rmap_next(kvm, rmapp, spte);
 	}
 	if (write_protected) {
-		struct page *page;
+		pfn_t pfn;
 
 		spte = rmap_next(kvm, rmapp, NULL);
-		page = spte_to_page(*spte);
-		SetPageDirty(page);
+		pfn = spte_to_pfn(*spte);
+		kvm_set_pfn_dirty(pfn);
 	}
 
 	/* check for huge page mappings */
@@ -1036,7 +1034,7 @@ static void mmu_set_spte(struct kvm_vcpu *vcpu, u64 *shadow_pte,
 			 unsigned pt_access, unsigned pte_access,
 			 int user_fault, int write_fault, int dirty,
 			 int *ptwrite, int largepage, gfn_t gfn,
-			 struct page *page, bool speculative)
+			 pfn_t pfn, bool speculative)
 {
 	u64 spte;
 	int was_rmapped = 0;
@@ -1058,10 +1056,9 @@ static void mmu_set_spte(struct kvm_vcpu *vcpu, u64 *shadow_pte,
 
 			child = page_header(pte & PT64_BASE_ADDR_MASK);
 			mmu_page_remove_parent_pte(child, shadow_pte);
-		} else if (page != spte_to_page(*shadow_pte)) {
+		} else if (pfn != spte_to_pfn(*shadow_pte)) {
 			pgprintk("hfn old %lx new %lx\n",
-				 page_to_pfn(spte_to_page(*shadow_pte)),
-				 page_to_pfn(page));
+				 spte_to_pfn(*shadow_pte), pfn);
 			rmap_remove(vcpu->kvm, shadow_pte);
 		} else {
 			if (largepage)
@@ -1090,7 +1087,7 @@ static void mmu_set_spte(struct kvm_vcpu *vcpu, u64 *shadow_pte,
 	if (largepage)
 		spte |= PT_PAGE_SIZE_MASK;
 
-	spte |= page_to_phys(page);
+	spte |= (u64)pfn << PAGE_SHIFT;
 
 	if ((pte_access & ACC_WRITE_MASK)
 	    || (write_fault && !is_write_protection(vcpu) && !user_fault)) {
@@ -1135,12 +1132,12 @@ unshadowed:
 	if (!was_rmapped) {
 		rmap_add(vcpu, shadow_pte, gfn, largepage);
 		if (!is_rmap_pte(*shadow_pte))
-			kvm_release_page_clean(page);
+			kvm_release_pfn_clean(pfn);
 	} else {
 		if (was_writeble)
-			kvm_release_page_dirty(page);
+			kvm_release_pfn_dirty(pfn);
 		else
-			kvm_release_page_clean(page);
+			kvm_release_pfn_clean(pfn);
 	}
 	if (!ptwrite || !*ptwrite)
 		vcpu->arch.last_pte_updated = shadow_pte;
@@ -1151,7 +1148,7 @@ static void nonpaging_new_cr3(struct kvm_vcpu *vcpu)
 }
 
 static int __direct_map(struct kvm_vcpu *vcpu, gpa_t v, int write,
-			   int largepage, gfn_t gfn, struct page *page,
+			   int largepage, gfn_t gfn, pfn_t pfn,
 			   int level)
 {
 	hpa_t table_addr = vcpu->arch.mmu.root_hpa;
@@ -1166,13 +1163,13 @@ static int __direct_map(struct kvm_vcpu *vcpu, gpa_t v, int write,
 
 		if (level == 1) {
 			mmu_set_spte(vcpu, &table[index], ACC_ALL, ACC_ALL,
-				     0, write, 1, &pt_write, 0, gfn, page, false);
+				     0, write, 1, &pt_write, 0, gfn, pfn, false);
 			return pt_write;
 		}
 
 		if (largepage && level == 2) {
 			mmu_set_spte(vcpu, &table[index], ACC_ALL, ACC_ALL,
-				     0, write, 1, &pt_write, 1, gfn, page, false);
+				     0, write, 1, &pt_write, 1, gfn, pfn, false);
 			return pt_write;
 		}
 
@@ -1187,7 +1184,7 @@ static int __direct_map(struct kvm_vcpu *vcpu, gpa_t v, int write,
 						     1, ACC_ALL, &table[index]);
 			if (!new_table) {
 				pgprintk("nonpaging_map: ENOMEM\n");
-				kvm_release_page_clean(page);
+				kvm_release_pfn_clean(pfn);
 				return -ENOMEM;
 			}
 
@@ -1202,8 +1199,7 @@ static int nonpaging_map(struct kvm_vcpu *vcpu, gva_t v, int write, gfn_t gfn)
 {
 	int r;
 	int largepage = 0;
-
-	struct page *page;
+	pfn_t pfn;
 
 	down_read(&current->mm->mmap_sem);
 	if (is_largepage_backed(vcpu, gfn & ~(KVM_PAGES_PER_HPAGE-1))) {
@@ -1211,18 +1207,18 @@ static int nonpaging_map(struct kvm_vcpu *vcpu, gva_t v, int write, gfn_t gfn)
 		largepage = 1;
 	}
 
-	page = gfn_to_page(vcpu->kvm, gfn);
+	pfn = gfn_to_pfn(vcpu->kvm, gfn);
 	up_read(&current->mm->mmap_sem);
 
 	/* mmio */
-	if (is_error_page(page)) {
-		kvm_release_page_clean(page);
+	if (is_error_pfn(pfn)) {
+		kvm_release_pfn_clean(pfn);
 		return 1;
 	}
 
 	spin_lock(&vcpu->kvm->mmu_lock);
 	kvm_mmu_free_some_pages(vcpu);
-	r = __direct_map(vcpu, v, write, largepage, gfn, page,
+	r = __direct_map(vcpu, v, write, largepage, gfn, pfn,
 			 PT32E_ROOT_LEVEL);
 	spin_unlock(&vcpu->kvm->mmu_lock);
 
@@ -1355,7 +1351,7 @@ static int nonpaging_page_fault(struct kvm_vcpu *vcpu, gva_t gva,
 static int tdp_page_fault(struct kvm_vcpu *vcpu, gva_t gpa,
 				u32 error_code)
 {
-	struct page *page;
+	pfn_t pfn;
 	int r;
 	int largepage = 0;
 	gfn_t gfn = gpa >> PAGE_SHIFT;
@@ -1372,16 +1368,16 @@ static int tdp_page_fault(struct kvm_vcpu *vcpu, gva_t gpa,
 		gfn &= ~(KVM_PAGES_PER_HPAGE-1);
 		largepage = 1;
 	}
-	page = gfn_to_page(vcpu->kvm, gfn);
+	pfn = gfn_to_pfn(vcpu->kvm, gfn);
 	up_read(&current->mm->mmap_sem);
-	if (is_error_page(page)) {
-		kvm_release_page_clean(page);
+	if (is_error_pfn(pfn)) {
+		kvm_release_pfn_clean(pfn);
 		return 1;
 	}
 	spin_lock(&vcpu->kvm->mmu_lock);
 	kvm_mmu_free_some_pages(vcpu);
 	r = __direct_map(vcpu, gpa, error_code & PFERR_WRITE_MASK,
-			 largepage, gfn, page, TDP_ROOT_LEVEL);
+			 largepage, gfn, pfn, TDP_ROOT_LEVEL);
 	spin_unlock(&vcpu->kvm->mmu_lock);
 
 	return r;
@@ -1525,6 +1521,8 @@ static int init_kvm_softmmu(struct kvm_vcpu *vcpu)
 
 static int init_kvm_mmu(struct kvm_vcpu *vcpu)
 {
+	vcpu->arch.update_pte.pfn = bad_pfn;
+
 	if (tdp_enabled)
 		return init_kvm_tdp_mmu(vcpu);
 	else
@@ -1644,7 +1642,7 @@ static void mmu_guess_page_from_pte_write(struct kvm_vcpu *vcpu, gpa_t gpa,
 	gfn_t gfn;
 	int r;
 	u64 gpte = 0;
-	struct page *page;
+	pfn_t pfn;
 
 	vcpu->arch.update_pte.largepage = 0;
 
@@ -1680,15 +1678,15 @@ static void mmu_guess_page_from_pte_write(struct kvm_vcpu *vcpu, gpa_t gpa,
 		gfn &= ~(KVM_PAGES_PER_HPAGE-1);
 		vcpu->arch.update_pte.largepage = 1;
 	}
-	page = gfn_to_page(vcpu->kvm, gfn);
+	pfn = gfn_to_pfn(vcpu->kvm, gfn);
 	up_read(&current->mm->mmap_sem);
 
-	if (is_error_page(page)) {
-		kvm_release_page_clean(page);
+	if (is_error_pfn(pfn)) {
+		kvm_release_pfn_clean(pfn);
 		return;
 	}
 	vcpu->arch.update_pte.gfn = gfn;
-	vcpu->arch.update_pte.page = page;
+	vcpu->arch.update_pte.pfn = pfn;
 }
 
 void kvm_mmu_pte_write(struct kvm_vcpu *vcpu, gpa_t gpa,
@@ -1793,9 +1791,9 @@ void kvm_mmu_pte_write(struct kvm_vcpu *vcpu, gpa_t gpa,
 	}
 	kvm_mmu_audit(vcpu, "post pte write");
 	spin_unlock(&vcpu->kvm->mmu_lock);
-	if (vcpu->arch.update_pte.page) {
-		kvm_release_page_clean(vcpu->arch.update_pte.page);
-		vcpu->arch.update_pte.page = NULL;
+	if (!is_error_pfn(vcpu->arch.update_pte.pfn)) {
+		kvm_release_pfn_clean(vcpu->arch.update_pte.pfn);
+		vcpu->arch.update_pte.pfn = bad_pfn;
 	}
 }
 
@@ -2236,8 +2234,7 @@ static void audit_mappings_page(struct kvm_vcpu *vcpu, u64 page_pte,
 			audit_mappings_page(vcpu, ent, va, level - 1);
 		} else {
 			gpa_t gpa = vcpu->arch.mmu.gva_to_gpa(vcpu, va);
-			struct page *page = gpa_to_page(vcpu, gpa);
-			hpa_t hpa = page_to_phys(page);
+			hpa_t hpa = (hpa_t)gpa_to_pfn(vcpu, gpa) << PAGE_SHIFT;
 
 			if (is_shadow_present_pte(ent)
 			    && (ent & PT64_BASE_ADDR_MASK) != hpa)
@@ -2250,7 +2247,7 @@ static void audit_mappings_page(struct kvm_vcpu *vcpu, u64 page_pte,
 				 && !is_error_hpa(hpa))
 				printk(KERN_ERR "audit: (%s) notrap shadow,"
 				       " valid guest gva %lx\n", audit_msg, va);
-			kvm_release_page_clean(page);
+			kvm_release_pfn_clean(pfn);
 
 		}
 	}
diff --git a/arch/x86/kvm/paging_tmpl.h b/arch/x86/kvm/paging_tmpl.h
index 57d872a..156fe10 100644
--- a/arch/x86/kvm/paging_tmpl.h
+++ b/arch/x86/kvm/paging_tmpl.h
@@ -247,7 +247,7 @@ static void FNAME(update_pte)(struct kvm_vcpu *vcpu, struct kvm_mmu_page *page,
 {
 	pt_element_t gpte;
 	unsigned pte_access;
-	struct page *npage;
+	pfn_t pfn;
 	int largepage = vcpu->arch.update_pte.largepage;
 
 	gpte = *(const pt_element_t *)pte;
@@ -260,13 +260,13 @@ static void FNAME(update_pte)(struct kvm_vcpu *vcpu, struct kvm_mmu_page *page,
 	pte_access = page->role.access & FNAME(gpte_access)(vcpu, gpte);
 	if (gpte_to_gfn(gpte) != vcpu->arch.update_pte.gfn)
 		return;
-	npage = vcpu->arch.update_pte.page;
-	if (!npage)
+	pfn = vcpu->arch.update_pte.pfn;
+	if (is_error_pfn(pfn))
 		return;
-	get_page(npage);
+	kvm_get_pfn(pfn);
 	mmu_set_spte(vcpu, spte, page->role.access, pte_access, 0, 0,
 		     gpte & PT_DIRTY_MASK, NULL, largepage, gpte_to_gfn(gpte),
-		     npage, true);
+		     pfn, true);
 }
 
 /*
@@ -275,7 +275,7 @@ static void FNAME(update_pte)(struct kvm_vcpu *vcpu, struct kvm_mmu_page *page,
 static u64 *FNAME(fetch)(struct kvm_vcpu *vcpu, gva_t addr,
 			 struct guest_walker *walker,
 			 int user_fault, int write_fault, int largepage,
-			 int *ptwrite, struct page *page)
+			 int *ptwrite, pfn_t pfn)
 {
 	hpa_t shadow_addr;
 	int level;
@@ -336,7 +336,7 @@ static u64 *FNAME(fetch)(struct kvm_vcpu *vcpu, gva_t addr,
 						  walker->pte_gpa[level - 2],
 						  &curr_pte, sizeof(curr_pte));
 			if (r || curr_pte != walker->ptes[level - 2]) {
-				kvm_release_page_clean(page);
+				kvm_release_pfn_clean(pfn);
 				return NULL;
 			}
 		}
@@ -349,7 +349,7 @@ static u64 *FNAME(fetch)(struct kvm_vcpu *vcpu, gva_t addr,
 	mmu_set_spte(vcpu, shadow_ent, access, walker->pte_access & access,
 		     user_fault, write_fault,
 		     walker->ptes[walker->level-1] & PT_DIRTY_MASK,
-		     ptwrite, largepage, walker->gfn, page, false);
+		     ptwrite, largepage, walker->gfn, pfn, false);
 
 	return shadow_ent;
 }
@@ -378,7 +378,7 @@ static int FNAME(page_fault)(struct kvm_vcpu *vcpu, gva_t addr,
 	u64 *shadow_pte;
 	int write_pt = 0;
 	int r;
-	struct page *page;
+	pfn_t pfn;
 	int largepage = 0;
 
 	pgprintk("%s: addr %lx err %x\n", __func__, addr, error_code);
@@ -413,20 +413,20 @@ static int FNAME(page_fault)(struct kvm_vcpu *vcpu, gva_t addr,
 			largepage = 1;
 		}
 	}
-	page = gfn_to_page(vcpu->kvm, walker.gfn);
+	pfn = gfn_to_pfn(vcpu->kvm, walker.gfn);
 	up_read(&current->mm->mmap_sem);
 
 	/* mmio */
-	if (is_error_page(page)) {
+	if (is_error_pfn(pfn)) {
 		pgprintk("gfn %x is mmio\n", walker.gfn);
-		kvm_release_page_clean(page);
+		kvm_release_pfn_clean(pfn);
 		return 1;
 	}
 
 	spin_lock(&vcpu->kvm->mmu_lock);
 	kvm_mmu_free_some_pages(vcpu);
 	shadow_pte = FNAME(fetch)(vcpu, addr, &walker, user_fault, write_fault,
-				  largepage, &write_pt, page);
+				  largepage, &write_pt, pfn);
 
 	pgprintk("%s: shadow pte %p %llx ptwrite %d\n", __func__,
 		 shadow_pte, *shadow_pte, write_pt);
diff --git a/include/asm-x86/kvm_host.h b/include/asm-x86/kvm_host.h
index b923049..de3eccf 100644
--- a/include/asm-x86/kvm_host.h
+++ b/include/asm-x86/kvm_host.h
@@ -248,8 +248,8 @@ struct kvm_vcpu_arch {
 	u64  *last_pte_updated;
 
 	struct {
-		gfn_t gfn;          /* presumed gfn during guest pte update */
-		struct page *page;  /* page corresponding to that gfn */
+		gfn_t gfn;	/* presumed gfn during guest pte update */
+		pfn_t pfn;	/* pfn corresponding to that gfn */
 		int largepage;
 	} update_pte;
 
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index a2ceb51..578c363 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -150,8 +150,10 @@ static inline int is_error_hpa(hpa_t hpa) { return hpa >> HPA_MSB; }
 struct page *gva_to_page(struct kvm_vcpu *vcpu, gva_t gva);
 
 extern struct page *bad_page;
+extern pfn_t bad_pfn;
 
 int is_error_page(struct page *page);
+int is_error_pfn(pfn_t pfn);
 int kvm_is_error_hva(unsigned long addr);
 int kvm_set_memory_region(struct kvm *kvm,
 			  struct kvm_userspace_memory_region *mem,
@@ -168,6 +170,16 @@ struct page *gfn_to_page(struct kvm *kvm, gfn_t gfn);
 unsigned long gfn_to_hva(struct kvm *kvm, gfn_t gfn);
 void kvm_release_page_clean(struct page *page);
 void kvm_release_page_dirty(struct page *page);
+void kvm_set_page_dirty(struct page *page);
+void kvm_set_page_accessed(struct page *page);
+
+pfn_t gfn_to_pfn(struct kvm *kvm, gfn_t gfn);
+void kvm_release_pfn_dirty(pfn_t);
+void kvm_release_pfn_clean(pfn_t pfn);
+void kvm_set_pfn_dirty(pfn_t pfn);
+void kvm_set_pfn_accessed(pfn_t pfn);
+void kvm_get_pfn(pfn_t pfn);
+
 int kvm_read_guest_page(struct kvm *kvm, gfn_t gfn, void *data, int offset,
 			int len);
 int kvm_read_guest_atomic(struct kvm *kvm, gpa_t gpa, void *data,
diff --git a/include/linux/kvm_types.h b/include/linux/kvm_types.h
index 1c4e46d..9b6f395 100644
--- a/include/linux/kvm_types.h
+++ b/include/linux/kvm_types.h
@@ -38,6 +38,8 @@ typedef unsigned long  hva_t;
 typedef u64            hpa_t;
 typedef unsigned long  hfn_t;
 
+typedef hfn_t pfn_t;
+
 struct kvm_pio_request {
 	unsigned long count;
 	int cur_count;
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 93ed78b..6a52c08 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -40,6 +40,7 @@
 #include <linux/kvm_para.h>
 #include <linux/pagemap.h>
 #include <linux/mman.h>
+#include <linux/swap.h>
 
 #include <asm/processor.h>
 #include <asm/io.h>
@@ -458,6 +459,12 @@ int is_error_page(struct page *page)
 }
 EXPORT_SYMBOL_GPL(is_error_page);
 
+int is_error_pfn(pfn_t pfn)
+{
+	return pfn == bad_pfn;
+}
+EXPORT_SYMBOL_GPL(is_error_pfn);
+
 static inline unsigned long bad_hva(void)
 {
 	return PAGE_OFFSET;
@@ -519,7 +526,7 @@ unsigned long gfn_to_hva(struct kvm *kvm, gfn_t gfn)
 /*
  * Requires current->mm->mmap_sem to be held
  */
-struct page *gfn_to_page(struct kvm *kvm, gfn_t gfn)
+pfn_t gfn_to_pfn(struct kvm *kvm, gfn_t gfn)
 {
 	struct page *page[1];
 	unsigned long addr;
@@ -530,7 +537,7 @@ struct page *gfn_to_page(struct kvm *kvm, gfn_t gfn)
 	addr = gfn_to_hva(kvm, gfn);
 	if (kvm_is_error_hva(addr)) {
 		get_page(bad_page);
-		return bad_page;
+		return page_to_pfn(bad_page);
 	}
 
 	npages = get_user_pages(current, current->mm, addr, 1, 1, 1, page,
@@ -538,27 +545,71 @@ struct page *gfn_to_page(struct kvm *kvm, gfn_t gfn)
 
 	if (npages != 1) {
 		get_page(bad_page);
-		return bad_page;
+		return page_to_pfn(bad_page);
 	}
 
-	return page[0];
+	return page_to_pfn(page[0]);
+}
+
+EXPORT_SYMBOL_GPL(gfn_to_pfn);
+
+struct page *gfn_to_page(struct kvm *kvm, gfn_t gfn)
+{
+	return pfn_to_page(gfn_to_pfn(kvm, gfn));
 }
 
 EXPORT_SYMBOL_GPL(gfn_to_page);
 
 void kvm_release_page_clean(struct page *page)
 {
-	put_page(page);
+	kvm_release_pfn_clean(page_to_pfn(page));
 }
 EXPORT_SYMBOL_GPL(kvm_release_page_clean);
 
+void kvm_release_pfn_clean(pfn_t pfn)
+{
+	put_page(pfn_to_page(pfn));
+}
+EXPORT_SYMBOL_GPL(kvm_release_pfn_clean);
+
 void kvm_release_page_dirty(struct page *page)
 {
+	kvm_release_pfn_dirty(page_to_pfn(page));
+}
+EXPORT_SYMBOL_GPL(kvm_release_page_dirty);
+
+void kvm_release_pfn_dirty(pfn_t pfn)
+{
+	kvm_set_pfn_dirty(pfn);
+	kvm_release_pfn_clean(pfn);
+}
+EXPORT_SYMBOL_GPL(kvm_release_pfn_dirty);
+
+void kvm_set_page_dirty(struct page *page)
+{
+	kvm_set_pfn_dirty(page_to_pfn(page));
+}
+EXPORT_SYMBOL_GPL(kvm_set_page_dirty);
+
+void kvm_set_pfn_dirty(pfn_t pfn)
+{
+	struct page *page = pfn_to_page(pfn);
 	if (!PageReserved(page))
 		SetPageDirty(page);
-	put_page(page);
 }
-EXPORT_SYMBOL_GPL(kvm_release_page_dirty);
+EXPORT_SYMBOL_GPL(kvm_set_pfn_dirty);
+
+void kvm_set_pfn_accessed(pfn_t pfn)
+{
+	mark_page_accessed(pfn_to_page(pfn));
+}
+EXPORT_SYMBOL_GPL(kvm_set_pfn_accessed);
+
+void kvm_get_pfn(pfn_t pfn)
+{
+	get_page(pfn_to_page(pfn));
+}
+EXPORT_SYMBOL_GPL(kvm_get_pfn);
 
 static int next_segment(unsigned long len, int offset)
 {
@@ -1351,6 +1402,7 @@ static struct sys_device kvm_sysdev = {
 };
 
 struct page *bad_page;
+pfn_t bad_pfn;
 
 static inline
 struct kvm_vcpu *preempt_notifier_to_vcpu(struct preempt_notifier *pn)
@@ -1392,6 +1444,8 @@ int kvm_init(void *opaque, unsigned int vcpu_size,
 		goto out;
 	}
 
+	bad_pfn = page_to_pfn(bad_page);
+
 	r = kvm_arch_hardware_setup();
 	if (r < 0)
 		goto out_free_0;
-- 
1.5.5

