Return-Path: <linux-kernel-owner+w=401wt.eu-S1760455AbYAFOsp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760455AbYAFOsp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jan 2008 09:48:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758547AbYAFOkS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Jan 2008 09:40:18 -0500
Received: from il.qumranet.com ([82.166.9.18]:46610 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756655AbYAFOjs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jan 2008 09:39:48 -0500
From: Avi Kivity <avi@qumranet.com>
To: linux-kernel@vger.kernel.org, kvm-devel@lists.sourceforge.net
Subject: [PATCH 29/33] KVM: MMU: Avoid calling gfn_to_page() in mmu_set_spte()
Date: Sun,  6 Jan 2008 16:39:35 +0200
Message-Id: <1199630379-28638-30-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.3.7
In-Reply-To: <1199630379-28638-1-git-send-email-avi@qumranet.com>
References: <1199630379-28638-1-git-send-email-avi@qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since gfn_to_page() is a sleeping function, and we want to make the core mmu
spinlocked, we need to pass the page from the walker context (which can sleep)
to the shadow context (which cannot).

[marcelo: avoid recursive locking of mmap_sem]

Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 arch/x86/kvm/mmu.c         |   55 ++++++++++++++++++++++++++++++++++++++++----
 arch/x86/kvm/paging_tmpl.h |   23 ++++++++++++++----
 include/asm-x86/kvm_host.h |    5 ++++
 3 files changed, 73 insertions(+), 10 deletions(-)

diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index 3b91227..c0b757b 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -890,11 +890,10 @@ struct page *gva_to_page(struct kvm_vcpu *vcpu, gva_t gva)
 static void mmu_set_spte(struct kvm_vcpu *vcpu, u64 *shadow_pte,
 			 unsigned pt_access, unsigned pte_access,
 			 int user_fault, int write_fault, int dirty,
-			 int *ptwrite, gfn_t gfn)
+			 int *ptwrite, gfn_t gfn, struct page *page)
 {
 	u64 spte;
 	int was_rmapped = is_rmap_pte(*shadow_pte);
-	struct page *page;
 
 	pgprintk("%s: spte %llx access %x write_fault %d"
 		 " user_fault %d gfn %lx\n",
@@ -912,8 +911,6 @@ static void mmu_set_spte(struct kvm_vcpu *vcpu, u64 *shadow_pte,
 	if (!(pte_access & ACC_EXEC_MASK))
 		spte |= PT64_NX_MASK;
 
-	page = gfn_to_page(vcpu->kvm, gfn);
-
 	spte |= PT_PRESENT_MASK;
 	if (pte_access & ACC_USER_MASK)
 		spte |= PT_USER_MASK;
@@ -979,6 +976,11 @@ static int __nonpaging_map(struct kvm_vcpu *vcpu, gva_t v, int write, gfn_t gfn)
 	int level = PT32E_ROOT_LEVEL;
 	hpa_t table_addr = vcpu->arch.mmu.root_hpa;
 	int pt_write = 0;
+	struct page *page;
+
+	down_read(&current->mm->mmap_sem);
+	page = gfn_to_page(vcpu->kvm, gfn);
+	up_read(&current->mm->mmap_sem);
 
 	for (; ; level--) {
 		u32 index = PT64_INDEX(v, level);
@@ -989,7 +991,7 @@ static int __nonpaging_map(struct kvm_vcpu *vcpu, gva_t v, int write, gfn_t gfn)
 
 		if (level == 1) {
 			mmu_set_spte(vcpu, &table[index], ACC_ALL, ACC_ALL,
-				     0, write, 1, &pt_write, gfn);
+				     0, write, 1, &pt_write, gfn, page);
 			return pt_write || is_io_pte(table[index]);
 		}
 
@@ -1005,6 +1007,7 @@ static int __nonpaging_map(struct kvm_vcpu *vcpu, gva_t v, int write, gfn_t gfn)
 						     NULL);
 			if (!new_table) {
 				pgprintk("nonpaging_map: ENOMEM\n");
+				kvm_release_page_clean(page);
 				return -ENOMEM;
 			}
 
@@ -1347,6 +1350,43 @@ static bool last_updated_pte_accessed(struct kvm_vcpu *vcpu)
 	return !!(spte && (*spte & PT_ACCESSED_MASK));
 }
 
+static void mmu_guess_page_from_pte_write(struct kvm_vcpu *vcpu, gpa_t gpa,
+					  const u8 *new, int bytes)
+{
+	gfn_t gfn;
+	int r;
+	u64 gpte = 0;
+
+	if (bytes != 4 && bytes != 8)
+		return;
+
+	/*
+	 * Assume that the pte write on a page table of the same type
+	 * as the current vcpu paging mode.  This is nearly always true
+	 * (might be false while changing modes).  Note it is verified later
+	 * by update_pte().
+	 */
+	if (is_pae(vcpu)) {
+		/* Handle a 32-bit guest writing two halves of a 64-bit gpte */
+		if ((bytes == 4) && (gpa % 4 == 0)) {
+			r = kvm_read_guest(vcpu->kvm, gpa & ~(u64)7, &gpte, 8);
+			if (r)
+				return;
+			memcpy((void *)&gpte + (gpa % 8), new, 4);
+		} else if ((bytes == 8) && (gpa % 8 == 0)) {
+			memcpy((void *)&gpte, new, 8);
+		}
+	} else {
+		if ((bytes == 4) && (gpa % 4 == 0))
+			memcpy((void *)&gpte, new, 4);
+	}
+	if (!is_present_pte(gpte))
+		return;
+	gfn = (gpte & PT64_BASE_ADDR_MASK) >> PAGE_SHIFT;
+	vcpu->arch.update_pte.gfn = gfn;
+	vcpu->arch.update_pte.page = gfn_to_page(vcpu->kvm, gfn);
+}
+
 void kvm_mmu_pte_write(struct kvm_vcpu *vcpu, gpa_t gpa,
 		       const u8 *new, int bytes)
 {
@@ -1367,6 +1407,7 @@ void kvm_mmu_pte_write(struct kvm_vcpu *vcpu, gpa_t gpa,
 	int npte;
 
 	pgprintk("%s: gpa %llx bytes %d\n", __FUNCTION__, gpa, bytes);
+	mmu_guess_page_from_pte_write(vcpu, gpa, new, bytes);
 	mutex_lock(&vcpu->kvm->lock);
 	++vcpu->kvm->stat.mmu_pte_write;
 	kvm_mmu_audit(vcpu, "pre pte write");
@@ -1437,6 +1478,10 @@ void kvm_mmu_pte_write(struct kvm_vcpu *vcpu, gpa_t gpa,
 	}
 	kvm_mmu_audit(vcpu, "post pte write");
 	mutex_unlock(&vcpu->kvm->lock);
+	if (vcpu->arch.update_pte.page) {
+		kvm_release_page_clean(vcpu->arch.update_pte.page);
+		vcpu->arch.update_pte.page = NULL;
+	}
 }
 
 int kvm_mmu_unprotect_page_virt(struct kvm_vcpu *vcpu, gva_t gva)
diff --git a/arch/x86/kvm/paging_tmpl.h b/arch/x86/kvm/paging_tmpl.h
index 136a65d..3d7846b 100644
--- a/arch/x86/kvm/paging_tmpl.h
+++ b/arch/x86/kvm/paging_tmpl.h
@@ -245,6 +245,7 @@ static void FNAME(update_pte)(struct kvm_vcpu *vcpu, struct kvm_mmu_page *page,
 {
 	pt_element_t gpte;
 	unsigned pte_access;
+	struct page *npage;
 
 	gpte = *(const pt_element_t *)pte;
 	if (~gpte & (PT_PRESENT_MASK | PT_ACCESSED_MASK)) {
@@ -256,8 +257,14 @@ static void FNAME(update_pte)(struct kvm_vcpu *vcpu, struct kvm_mmu_page *page,
 		return;
 	pgprintk("%s: gpte %llx spte %p\n", __FUNCTION__, (u64)gpte, spte);
 	pte_access = page->role.access & FNAME(gpte_access)(vcpu, gpte);
+	if (gpte_to_gfn(gpte) != vcpu->arch.update_pte.gfn)
+		return;
+	npage = vcpu->arch.update_pte.page;
+	if (!npage)
+		return;
+	get_page(npage);
 	mmu_set_spte(vcpu, spte, page->role.access, pte_access, 0, 0,
-		     gpte & PT_DIRTY_MASK, NULL, gpte_to_gfn(gpte));
+		     gpte & PT_DIRTY_MASK, NULL, gpte_to_gfn(gpte), npage);
 }
 
 /*
@@ -265,7 +272,8 @@ static void FNAME(update_pte)(struct kvm_vcpu *vcpu, struct kvm_mmu_page *page,
  */
 static u64 *FNAME(fetch)(struct kvm_vcpu *vcpu, gva_t addr,
 			 struct guest_walker *walker,
-			 int user_fault, int write_fault, int *ptwrite)
+			 int user_fault, int write_fault, int *ptwrite,
+			 struct page *page)
 {
 	hpa_t shadow_addr;
 	int level;
@@ -321,8 +329,10 @@ static u64 *FNAME(fetch)(struct kvm_vcpu *vcpu, gva_t addr,
 			r = kvm_read_guest_atomic(vcpu->kvm,
 						  walker->pte_gpa[level - 2],
 						  &curr_pte, sizeof(curr_pte));
-			if (r || curr_pte != walker->ptes[level - 2])
+			if (r || curr_pte != walker->ptes[level - 2]) {
+				kvm_release_page_clean(page);
 				return NULL;
+			}
 		}
 		shadow_addr = __pa(shadow_page->spt);
 		shadow_pte = shadow_addr | PT_PRESENT_MASK | PT_ACCESSED_MASK
@@ -333,7 +343,7 @@ static u64 *FNAME(fetch)(struct kvm_vcpu *vcpu, gva_t addr,
 	mmu_set_spte(vcpu, shadow_ent, access, walker->pte_access & access,
 		     user_fault, write_fault,
 		     walker->ptes[walker->level-1] & PT_DIRTY_MASK,
-		     ptwrite, walker->gfn);
+		     ptwrite, walker->gfn, page);
 
 	return shadow_ent;
 }
@@ -362,6 +372,7 @@ static int FNAME(page_fault)(struct kvm_vcpu *vcpu, gva_t addr,
 	u64 *shadow_pte;
 	int write_pt = 0;
 	int r;
+	struct page *page;
 
 	pgprintk("%s: addr %lx err %x\n", __FUNCTION__, addr, error_code);
 	kvm_mmu_audit(vcpu, "pre page fault");
@@ -388,9 +399,11 @@ static int FNAME(page_fault)(struct kvm_vcpu *vcpu, gva_t addr,
 		return 0;
 	}
 
+	page = gfn_to_page(vcpu->kvm, walker.gfn);
+
 	mutex_lock(&vcpu->kvm->lock);
 	shadow_pte = FNAME(fetch)(vcpu, addr, &walker, user_fault, write_fault,
-				  &write_pt);
+				  &write_pt, page);
 	pgprintk("%s: shadow pte %p %llx ptwrite %d\n", __FUNCTION__,
 		 shadow_pte, *shadow_pte, write_pt);
 
diff --git a/include/asm-x86/kvm_host.h b/include/asm-x86/kvm_host.h
index 44b8925..20597bc 100644
--- a/include/asm-x86/kvm_host.h
+++ b/include/asm-x86/kvm_host.h
@@ -224,6 +224,11 @@ struct kvm_vcpu_arch {
 	int   last_pt_write_count;
 	u64  *last_pte_updated;
 
+	struct {
+		gfn_t gfn;          /* presumed gfn during guest pte update */
+		struct page *page;  /* page corresponding to that gfn */
+	} update_pte;
+
 	struct i387_fxsave_struct host_fx_image;
 	struct i387_fxsave_struct guest_fx_image;
 
-- 
1.5.3.7

