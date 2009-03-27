Return-Path: <linux-kernel-owner+w=401wt.eu-S1759400AbZC0OgN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759400AbZC0OgN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Mar 2009 10:36:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759354AbZC0Ofp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Mar 2009 10:35:45 -0400
Received: from va3ehsobe002.messaging.microsoft.com ([216.32.180.12]:54818
	"EHLO VA3EHSOBE002.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1759330AbZC0Ofn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Mar 2009 10:35:43 -0400
X-BigFish: VPS3(zzzz1202hzzz32i43j64h)
X-Spam-TCS-SCL: 3:0
X-FB-SS: 5,
X-WSS-ID: 0KH65UT-03-6O2-01
From: Joerg Roedel <joerg.roedel@amd.com>
To: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>
CC: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
       Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH] kvm mmu: add support for 1GB pages in shadow paging code
Date: Fri, 27 Mar 2009 15:35:18 +0100
Message-ID: <1238164518-16261-1-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.5.6.4
X-OriginalArrivalTime: 27 Mar 2009 14:35:18.0721 (UTC) FILETIME=[405CDB10:01C9AEE9]
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds support for 1GB pages in the shadow paging code. The
guest can map 1GB pages in his page tables and KVM will map the page
frame with a 1GB, a 2MB or even a 4kb page size, according to backing
host page size and the write protections in place.
This is the theory. In practice there are conditions which turn the
guest unstable when running with this patch and GB pages enabled. The
failing conditions are:

	* KVM is loaded using shadow paging
	* The Linux guest uses GB pages for the kernel direct mapping
	* The guest memory is backed with 4kb pages on the host side

With the above configuration there are random application or kernel
crashed when the guest runs under load. When GB pages for HugeTLBfs in
the guest are allocated at boot time in the guest the guest kernel
crashes or stucks at boot depending on the amount of RAM in the guest.
The following parameters have no impact:

	* It bug occurs also without guest SMP (so likely no race
	  condition)
	* Use PV-MMU makes no difference

I have searched this bug for quite some time with no real luck. Maybe
some other reviewers have more luck than I had by now.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 arch/x86/kvm/mmu.c         |   56 +++++++++++++++++++++++++++++++------------
 arch/x86/kvm/paging_tmpl.h |   35 +++++++++++++++++++++------
 arch/x86/kvm/svm.c         |    2 +-
 3 files changed, 68 insertions(+), 25 deletions(-)

diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index 471e5d0..e3120fe 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -705,6 +705,7 @@ static int rmap_write_protect(struct kvm *kvm, u64 gfn)
 	unsigned long *rmapp;
 	u64 *spte;
 	int write_protected = 0;
+	enum kvm_page_size psize;
 
 	gfn = unalias_gfn(kvm, gfn);
 	rmapp = gfn_to_rmap(kvm, gfn, KVM_PAGE_SIZE_4k);
@@ -729,7 +730,9 @@ static int rmap_write_protect(struct kvm *kvm, u64 gfn)
 	}
 
 	/* check for huge page mappings */
-	rmapp = gfn_to_rmap(kvm, gfn, KVM_PAGE_SIZE_2M);
+	psize = KVM_PAGE_SIZE_2M;
+again:
+	rmapp = gfn_to_rmap(kvm, gfn, psize);
 	spte = rmap_next(kvm, rmapp, NULL);
 	while (spte) {
 		BUG_ON(!spte);
@@ -737,7 +740,7 @@ static int rmap_write_protect(struct kvm *kvm, u64 gfn)
 		BUG_ON((*spte & (PT_PAGE_SIZE_MASK|PT_PRESENT_MASK)) != (PT_PAGE_SIZE_MASK|PT_PRESENT_MASK));
 		pgprintk("rmap_write_protect(large): spte %p %llx %lld\n", spte, *spte, gfn);
 		if (is_writeble_pte(*spte)) {
-			rmap_remove(kvm, spte, KVM_PAGE_SIZE_2M);
+			rmap_remove(kvm, spte, psize);
 			--kvm->stat.lpages;
 			set_shadow_pte(spte, shadow_trap_nonpresent_pte);
 			spte = NULL;
@@ -746,6 +749,11 @@ static int rmap_write_protect(struct kvm *kvm, u64 gfn)
 		spte = rmap_next(kvm, rmapp, spte);
 	}
 
+	if (psize == KVM_PAGE_SIZE_2M) {
+		psize = KVM_PAGE_SIZE_1G;
+		goto again;
+	}
+
 	return write_protected;
 }
 
@@ -789,11 +797,14 @@ static int kvm_handle_hva(struct kvm *kvm, unsigned long hva,
 		if (hva >= start && hva < end) {
 			gfn_t gfn_offset = (hva - start) >> PAGE_SHIFT;
 			unsigned long lidx = gfn_offset / KVM_PAGES_PER_2M_PAGE;
+			unsigned long hidx = gfn_offset / KVM_PAGES_PER_1G_PAGE;
 			retval |= handler(kvm, &memslot->rmap[gfn_offset],
 					  KVM_PAGE_SIZE_4k);
 			retval |= handler(kvm,
 					  &memslot->lpage_info[lidx].rmap_pde,
 					  KVM_PAGE_SIZE_2M);
+			retval |= handler(kvm, &memslot->hpage_info[hidx].rmap_pde,
+					  KVM_PAGE_SIZE_1G);
 		}
 	}
 
@@ -2408,6 +2419,9 @@ static void mmu_pte_write_zap_pte(struct kvm_vcpu *vcpu,
 		else if (is_large_pte(pte) &&
 			 sp->role.level == PT_DIRECTORY_LEVEL)
 			rmap_remove(vcpu->kvm, spte, KVM_PAGE_SIZE_2M);
+		else if (is_large_pte(pte) &&
+			 sp->role.level == PT_MIDDLE_LEVEL)
+			rmap_remove(vcpu->kvm, spte, KVM_PAGE_SIZE_1G);
 		else {
 			child = page_header(pte & PT64_BASE_ADDR_MASK);
 			mmu_page_remove_parent_pte(child, spte);
@@ -2423,19 +2437,36 @@ static void mmu_pte_write_new_pte(struct kvm_vcpu *vcpu,
 				  u64 *spte,
 				  const void *new)
 {
-	if (sp->role.level != PT_PAGE_TABLE_LEVEL) {
-		if (vcpu->arch.update_pte.page_size != KVM_PAGE_SIZE_2M ||
-		    sp->role.glevels == PT32_ROOT_LEVEL) {
-			++vcpu->kvm->stat.mmu_pde_zapped;
-			return;
-		}
-        }
+	enum kvm_page_size psize = KVM_PAGE_SIZE_4k;
+
+	if (sp->role.level == PT_PAGE_TABLE_LEVEL)
+		goto write_pte;
 
+	if (!is_large_pte(*(u64*)new))
+		goto out_pde;
+
+	psize = backing_size(vcpu, vcpu->arch.update_pte.gfn);
+	if ((sp->role.level == PT_DIRECTORY_LEVEL) &&
+	    (psize >= KVM_PAGE_SIZE_2M)) {
+		psize = KVM_PAGE_SIZE_2M;
+		vcpu->arch.update_pte.gfn &= ~(KVM_PAGES_PER_2M_PAGE-1);
+		vcpu->arch.update_pte.pfn &= ~(KVM_PAGES_PER_2M_PAGE-1);
+	} else if ((sp->role.level == PT_MIDDLE_LEVEL) &&
+		   (psize == KVM_PAGE_SIZE_1G)) {
+		vcpu->arch.update_pte.gfn &= ~(KVM_PAGES_PER_1G_PAGE-1);
+		vcpu->arch.update_pte.pfn &= ~(KVM_PAGES_PER_1G_PAGE-1);
+	} else
+		goto out_pde;
+
+write_pte:
+	vcpu->arch.update_pte.page_size = psize;
 	++vcpu->kvm->stat.mmu_pte_updated;
 	if (sp->role.glevels == PT32_ROOT_LEVEL)
 		paging32_update_pte(vcpu, sp, spte, new);
 	else
 		paging64_update_pte(vcpu, sp, spte, new);
+out_pde:
+	++vcpu->kvm->stat.mmu_pde_zapped;
 }
 
 static bool need_remote_flush(u64 old, u64 new)
@@ -2474,8 +2505,6 @@ static void mmu_guess_page_from_pte_write(struct kvm_vcpu *vcpu, gpa_t gpa,
 	u64 gpte = 0;
 	pfn_t pfn;
 
-	vcpu->arch.update_pte.page_size = KVM_PAGE_SIZE_4k;
-
 	if (bytes != 4 && bytes != 8)
 		return;
 
@@ -2503,11 +2532,6 @@ static void mmu_guess_page_from_pte_write(struct kvm_vcpu *vcpu, gpa_t gpa,
 		return;
 	gfn = (gpte & PT64_BASE_ADDR_MASK) >> PAGE_SHIFT;
 
-	if (is_large_pte(gpte) &&
-	    backing_size(vcpu, gfn) != KVM_PAGE_SIZE_4k) {
-		gfn &= ~(KVM_PAGES_PER_2M_PAGE-1);
-		vcpu->arch.update_pte.page_size = KVM_PAGE_SIZE_2M;
-	}
 	vcpu->arch.update_pte.mmu_seq = vcpu->kvm->mmu_notifier_seq;
 	smp_rmb();
 	pfn = gfn_to_pfn(vcpu->kvm, gfn);
diff --git a/arch/x86/kvm/paging_tmpl.h b/arch/x86/kvm/paging_tmpl.h
index 67d6bfb..a2cbc3f 100644
--- a/arch/x86/kvm/paging_tmpl.h
+++ b/arch/x86/kvm/paging_tmpl.h
@@ -306,7 +306,9 @@ static u64 *FNAME(fetch)(struct kvm_vcpu *vcpu, gva_t addr,
 		sptep = iterator.sptep;
 		if (level == PT_PAGE_TABLE_LEVEL
 		    || (psize == KVM_PAGE_SIZE_2M &&
-			level == PT_DIRECTORY_LEVEL)) {
+			level == PT_DIRECTORY_LEVEL)
+		    || (psize == KVM_PAGE_SIZE_1G &&
+			level == PT_MIDDLE_LEVEL)) {
 			mmu_set_spte(vcpu, sptep, access,
 				     gw->pte_access & access,
 				     user_fault, write_fault,
@@ -321,17 +323,20 @@ static u64 *FNAME(fetch)(struct kvm_vcpu *vcpu, gva_t addr,
 			continue;
 
 		if (is_large_pte(*sptep)) {
-			rmap_remove(vcpu->kvm, sptep, KVM_PAGE_SIZE_2M);
+			enum kvm_page_size __psize = KVM_PAGE_SIZE_2M;
+			if (level == PT_MIDDLE_LEVEL)
+				__psize = KVM_PAGE_SIZE_1G;
+			rmap_remove(vcpu->kvm, sptep, __psize);
 			set_shadow_pte(sptep, shadow_trap_nonpresent_pte);
 			kvm_flush_remote_tlbs(vcpu->kvm);
 		}
 
-		if (level == PT_DIRECTORY_LEVEL
-		    && gw->level == PT_DIRECTORY_LEVEL) {
+		if (level <= gw->level) {
+			int delta = level - gw->level + 1;
 			direct = 1;
-			if (!is_dirty_pte(gw->ptes[level - 1]))
+			if (!is_dirty_pte(gw->ptes[level - delta]))
 				access &= ~ACC_WRITE_MASK;
-			table_gfn = gpte_to_gfn(gw->ptes[level - 1]);
+			table_gfn = gpte_to_gfn(gw->ptes[level - delta]);
 		} else {
 			direct = 0;
 			table_gfn = gw->table_gfn[level - 2];
@@ -418,6 +423,15 @@ static int FNAME(page_fault)(struct kvm_vcpu *vcpu, gva_t addr,
 			psize = KVM_PAGE_SIZE_2M;
 		}
 	}
+
+	if (walker.level == PT_MIDDLE_LEVEL) {
+		psize = backing_size(vcpu, walker.gfn);
+		if (psize == KVM_PAGE_SIZE_1G)
+			walker.gfn &= ~(KVM_PAGES_PER_1G_PAGE-1);
+		else if (psize == KVM_PAGE_SIZE_2M)
+			walker.gfn &= ~(KVM_PAGES_PER_2M_PAGE-1);
+	}
+
 	mmu_seq = vcpu->kvm->mmu_notifier_seq;
 	smp_rmb();
 	pfn = gfn_to_pfn(vcpu->kvm, walker.gfn);
@@ -471,12 +485,15 @@ static void FNAME(invlpg)(struct kvm_vcpu *vcpu, gva_t gva)
 
 		/* FIXME: properly handle invlpg on large guest pages */
 		if (level == PT_PAGE_TABLE_LEVEL ||
-		    ((level == PT_DIRECTORY_LEVEL) && is_large_pte(*sptep))) {
+		    ((level == PT_DIRECTORY_LEVEL) && is_large_pte(*sptep)) ||
+		    ((level == PT_MIDDLE_LEVEL) && is_large_pte(*sptep))) {
 			struct kvm_mmu_page *sp = page_header(__pa(sptep));
 			enum kvm_page_size psize = KVM_PAGE_SIZE_4k;
 
 			if (level == PT_DIRECTORY_LEVEL)
 				psize = KVM_PAGE_SIZE_2M;
+			else if (level == PT_MIDDLE_LEVEL)
+				psize = KVM_PAGE_SIZE_1G;
 
 			pte_gpa = (sp->gfn << PAGE_SHIFT);
 			pte_gpa += (sptep - sp->spt) * sizeof(pt_element_t);
@@ -605,7 +622,8 @@ static int FNAME(sync_page)(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp)
 		nr_present++;
 		pte_access = sp->role.access & FNAME(gpte_access)(vcpu, gpte);
 		set_spte(vcpu, &sp->spt[i], pte_access, 0, 0,
-			 is_dirty_pte(gpte), 0, gpte & PT_GLOBAL_MASK, gfn,
+			 is_dirty_pte(gpte), KVM_PAGE_SIZE_4k,
+			 gpte & PT_GLOBAL_MASK, gfn,
 			 spte_to_pfn(sp->spt[i]), true, false);
 	}
 
@@ -623,4 +641,5 @@ static int FNAME(sync_page)(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp)
 #undef PT_MAX_FULL_LEVELS
 #undef gpte_to_gfn
 #undef gpte_to_gfn_pde
+#undef gpte_to_gfn_pmd
 #undef CMPXCHG
diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index d140686..1152ca9 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -2606,7 +2606,7 @@ static int svm_get_mt_mask_shift(void)
 
 static bool svm_gb_page_enable(void)
 {
-	return npt_enabled;
+	return true;
 }
 
 static struct kvm_x86_ops svm_x86_ops = {
-- 
1.5.6.4


