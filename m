Return-Path: <linux-kernel-owner+w=401wt.eu-S1758087AbZC0Oc7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758087AbZC0Oc7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Mar 2009 10:32:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754972AbZC0OcW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Mar 2009 10:32:22 -0400
Received: from wa4ehsobe002.messaging.microsoft.com ([216.32.181.12]:17555
	"EHLO WA4EHSOBE002.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751864AbZC0OcS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Mar 2009 10:32:18 -0400
X-BigFish: VPS1(zzzz1202hzzz32i62h)
X-Spam-TCS-SCL: 1:0
X-FB-SS: 5,
X-WSS-ID: 0KH65PD-01-IGV-01
From: Joerg Roedel <joerg.roedel@amd.com>
To: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>
CC: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
       Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 3/7] kvm mmu: add page size parameter to rmap_remove
Date: Fri, 27 Mar 2009 15:31:55 +0100
Message-ID: <1238164319-16092-4-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.5.6.4
In-Reply-To: <1238164319-16092-1-git-send-email-joerg.roedel@amd.com>
References: <1238164319-16092-1-git-send-email-joerg.roedel@amd.com>
X-OriginalArrivalTime: 27 Mar 2009 14:32:00.0290 (UTC) FILETIME=[CA16B020:01C9AEE8]
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Two reasons for this:

  * To make rmap_remove interface consistent with rmap_add which already
    has a page size parameter
  * When supporting more than one huge page size rmap_remove can't guess
    the huge page size anymore

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 arch/x86/kvm/mmu.c         |   40 ++++++++++++++++++++++------------------
 arch/x86/kvm/paging_tmpl.h |   10 +++++++---
 2 files changed, 29 insertions(+), 21 deletions(-)

diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index 3a57c17..9936b45 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -556,7 +556,7 @@ static void rmap_desc_remove_entry(unsigned long *rmapp,
 	mmu_free_rmap_desc(desc);
 }
 
-static void rmap_remove(struct kvm *kvm, u64 *spte)
+static void rmap_remove(struct kvm *kvm, u64 *spte, enum kvm_page_size psize)
 {
 	struct kvm_rmap_desc *desc;
 	struct kvm_rmap_desc *prev_desc;
@@ -564,7 +564,6 @@ static void rmap_remove(struct kvm *kvm, u64 *spte)
 	pfn_t pfn;
 	unsigned long *rmapp;
 	int i;
-	enum kvm_page_size psize;
 
 	if (!is_rmap_pte(*spte))
 		return;
@@ -576,7 +575,6 @@ static void rmap_remove(struct kvm *kvm, u64 *spte)
 		kvm_release_pfn_dirty(pfn);
 	else
 		kvm_release_pfn_clean(pfn);
-	psize = is_large_pte(*spte) ? KVM_PAGE_SIZE_2M : KVM_PAGE_SIZE_4k;
 	rmapp = gfn_to_rmap(kvm, sp->gfns[spte - sp->spt], psize);
 	if (!*rmapp) {
 		printk(KERN_ERR "rmap_remove: %p %llx 0->BUG\n", spte, *spte);
@@ -673,7 +671,7 @@ static int rmap_write_protect(struct kvm *kvm, u64 gfn)
 		BUG_ON((*spte & (PT_PAGE_SIZE_MASK|PT_PRESENT_MASK)) != (PT_PAGE_SIZE_MASK|PT_PRESENT_MASK));
 		pgprintk("rmap_write_protect(large): spte %p %llx %lld\n", spte, *spte, gfn);
 		if (is_writeble_pte(*spte)) {
-			rmap_remove(kvm, spte);
+			rmap_remove(kvm, spte, KVM_PAGE_SIZE_2M);
 			--kvm->stat.lpages;
 			set_shadow_pte(spte, shadow_trap_nonpresent_pte);
 			spte = NULL;
@@ -685,7 +683,8 @@ static int rmap_write_protect(struct kvm *kvm, u64 gfn)
 	return write_protected;
 }
 
-static int kvm_unmap_rmapp(struct kvm *kvm, unsigned long *rmapp)
+static int kvm_unmap_rmapp(struct kvm *kvm, unsigned long *rmapp,
+			   enum kvm_page_size psize)
 {
 	u64 *spte;
 	int need_tlb_flush = 0;
@@ -693,7 +692,7 @@ static int kvm_unmap_rmapp(struct kvm *kvm, unsigned long *rmapp)
 	while ((spte = rmap_next(kvm, rmapp, NULL))) {
 		BUG_ON(!(*spte & PT_PRESENT_MASK));
 		rmap_printk("kvm_rmap_unmap_hva: spte %p %llx\n", spte, *spte);
-		rmap_remove(kvm, spte);
+		rmap_remove(kvm, spte, psize);
 		set_shadow_pte(spte, shadow_trap_nonpresent_pte);
 		need_tlb_flush = 1;
 	}
@@ -701,7 +700,8 @@ static int kvm_unmap_rmapp(struct kvm *kvm, unsigned long *rmapp)
 }
 
 static int kvm_handle_hva(struct kvm *kvm, unsigned long hva,
-			  int (*handler)(struct kvm *kvm, unsigned long *rmapp))
+			  int (*handler)(struct kvm *kvm, unsigned long *rmapp,
+					 enum kvm_page_size psize))
 {
 	int i;
 	int retval = 0;
@@ -722,11 +722,12 @@ static int kvm_handle_hva(struct kvm *kvm, unsigned long hva,
 		end = start + (memslot->npages << PAGE_SHIFT);
 		if (hva >= start && hva < end) {
 			gfn_t gfn_offset = (hva - start) >> PAGE_SHIFT;
-			retval |= handler(kvm, &memslot->rmap[gfn_offset]);
+			unsigned long lidx = gfn_offset / KVM_PAGES_PER_2M_PAGE;
+			retval |= handler(kvm, &memslot->rmap[gfn_offset],
+					  KVM_PAGE_SIZE_4k);
 			retval |= handler(kvm,
-					  &memslot->lpage_info[
-						  gfn_offset /
-						  KVM_PAGES_PER_2M_PAGE].rmap_pde);
+					  &memslot->lpage_info[lidx].rmap_pde,
+					  KVM_PAGE_SIZE_2M);
 		}
 	}
 
@@ -738,7 +739,8 @@ int kvm_unmap_hva(struct kvm *kvm, unsigned long hva)
 	return kvm_handle_hva(kvm, hva, kvm_unmap_rmapp);
 }
 
-static int kvm_age_rmapp(struct kvm *kvm, unsigned long *rmapp)
+static int kvm_age_rmapp(struct kvm *kvm, unsigned long *rmapp,
+			 enum kvm_page_size psize)
 {
 	u64 *spte;
 	int young = 0;
@@ -1312,7 +1314,7 @@ static void kvm_mmu_page_unlink_children(struct kvm *kvm,
 	if (sp->role.level == PT_PAGE_TABLE_LEVEL) {
 		for (i = 0; i < PT64_ENT_PER_PAGE; ++i) {
 			if (is_shadow_present_pte(pt[i]))
-				rmap_remove(kvm, &pt[i]);
+				rmap_remove(kvm, &pt[i], KVM_PAGE_SIZE_4k);
 			pt[i] = shadow_trap_nonpresent_pte;
 		}
 		return;
@@ -1328,7 +1330,7 @@ static void kvm_mmu_page_unlink_children(struct kvm *kvm,
 							   &pt[i]);
 			} else {
 				--kvm->stat.lpages;
-				rmap_remove(kvm, &pt[i]);
+				rmap_remove(kvm, &pt[i], KVM_PAGE_SIZE_2M);
 			}
 		}
 		pt[i] = shadow_trap_nonpresent_pte;
@@ -1798,7 +1800,7 @@ static void mmu_set_spte(struct kvm_vcpu *vcpu, u64 *shadow_pte,
 		} else if (pfn != spte_to_pfn(*shadow_pte)) {
 			pgprintk("hfn old %lx new %lx\n",
 				 spte_to_pfn(*shadow_pte), pfn);
-			rmap_remove(vcpu->kvm, shadow_pte);
+			rmap_remove(vcpu->kvm, shadow_pte, psize);
 		} else
 			was_rmapped = 1;
 	}
@@ -2320,9 +2322,11 @@ static void mmu_pte_write_zap_pte(struct kvm_vcpu *vcpu,
 
 	pte = *spte;
 	if (is_shadow_present_pte(pte)) {
-		if (sp->role.level == PT_PAGE_TABLE_LEVEL ||
-		    is_large_pte(pte))
-			rmap_remove(vcpu->kvm, spte);
+		if (sp->role.level == PT_PAGE_TABLE_LEVEL)
+			rmap_remove(vcpu->kvm, spte, KVM_PAGE_SIZE_4k);
+		else if (is_large_pte(pte) &&
+			 sp->role.level == PT_DIRECTORY_LEVEL)
+			rmap_remove(vcpu->kvm, spte, KVM_PAGE_SIZE_2M);
 		else {
 			child = page_header(pte & PT64_BASE_ADDR_MASK);
 			mmu_page_remove_parent_pte(child, spte);
diff --git a/arch/x86/kvm/paging_tmpl.h b/arch/x86/kvm/paging_tmpl.h
index 9fbd049..6704ec7 100644
--- a/arch/x86/kvm/paging_tmpl.h
+++ b/arch/x86/kvm/paging_tmpl.h
@@ -307,7 +307,7 @@ static u64 *FNAME(fetch)(struct kvm_vcpu *vcpu, gva_t addr,
 			continue;
 
 		if (is_large_pte(*sptep)) {
-			rmap_remove(vcpu->kvm, sptep);
+			rmap_remove(vcpu->kvm, sptep, KVM_PAGE_SIZE_2M);
 			set_shadow_pte(sptep, shadow_trap_nonpresent_pte);
 			kvm_flush_remote_tlbs(vcpu->kvm);
 		}
@@ -459,12 +459,16 @@ static void FNAME(invlpg)(struct kvm_vcpu *vcpu, gva_t gva)
 		if (level == PT_PAGE_TABLE_LEVEL ||
 		    ((level == PT_DIRECTORY_LEVEL) && is_large_pte(*sptep))) {
 			struct kvm_mmu_page *sp = page_header(__pa(sptep));
+			enum kvm_page_size psize = KVM_PAGE_SIZE_4k;
+
+			if (level == PT_DIRECTORY_LEVEL)
+				psize = KVM_PAGE_SIZE_2M;
 
 			pte_gpa = (sp->gfn << PAGE_SHIFT);
 			pte_gpa += (sptep - sp->spt) * sizeof(pt_element_t);
 
 			if (is_shadow_present_pte(*sptep)) {
-				rmap_remove(vcpu->kvm, sptep);
+				rmap_remove(vcpu->kvm, sptep, psize);
 				if (is_large_pte(*sptep))
 					--vcpu->kvm->stat.lpages;
 				need_flush = 1;
@@ -575,7 +579,7 @@ static int FNAME(sync_page)(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp)
 		    !(gpte & PT_ACCESSED_MASK)) {
 			u64 nonpresent;
 
-			rmap_remove(vcpu->kvm, &sp->spt[i]);
+			rmap_remove(vcpu->kvm, &sp->spt[i], KVM_PAGE_SIZE_4k);
 			if (is_present_pte(gpte))
 				nonpresent = shadow_trap_nonpresent_pte;
 			else
-- 
1.5.6.4


