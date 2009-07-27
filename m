Return-Path: <linux-kernel-owner+w=401wt.eu-S1752216AbZG0Ofc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752216AbZG0Ofc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jul 2009 10:35:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752137AbZG0Ofb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Jul 2009 10:35:31 -0400
Received: from sg2ehsobe002.messaging.microsoft.com ([207.46.51.76]:10983 "EHLO
	SG2EHSOBE002.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752110AbZG0Of3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jul 2009 10:35:29 -0400
X-SpamScore: 3
X-BigFish: VPS3(zzzz1202hzzz32i43j65h)
X-Spam-TCS-SCL: 4:0
X-WSS-ID: 0KNG2ZH-03-X0F-01
From: Joerg Roedel <joerg.roedel@amd.com>
To: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <marcelo@kvack.org>
CC: linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
       Joerg Roedel <joerg.roedel@amd.com>,
       Marcelo Tosatti <mtosatti@redhat.com>
Subject: [PATCH 5/7] kvm/mmu: shadow support for 1gb pages
Date: Mon, 27 Jul 2009 16:30:46 +0200
Message-ID: <1248705048-22607-6-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1248705048-22607-1-git-send-email-joerg.roedel@amd.com>
References: <1248705048-22607-1-git-send-email-joerg.roedel@amd.com>
X-OriginalArrivalTime: 27 Jul 2009 14:30:51.0004 (UTC) FILETIME=[D72FFBC0:01CA0EC6]
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds support for shadow paging to the 1gb page table code in KVM.
With this code the guest can use 1gb pages even if the host does not support
them.

[ Marcelo: fix shadow page collision on pmd level if a guest 1gb page is mapped
           with 4kb ptes on host level ]

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
Signed-off-by: Marcelo Tosatti <mtosatti@redhat.com>
---
 arch/x86/include/asm/kvm_host.h |    1 -
 arch/x86/kvm/mmu.c              |   14 +----------
 arch/x86/kvm/paging_tmpl.h      |   43 ++++++++++++++++++--------------------
 3 files changed, 22 insertions(+), 36 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index e09dc26..c9fb2bc 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -315,7 +315,6 @@ struct kvm_vcpu_arch {
 	struct {
 		gfn_t gfn;	/* presumed gfn during guest pte update */
 		pfn_t pfn;	/* pfn corresponding to that gfn */
-		int level;
 		unsigned long mmu_seq;
 	} update_pte;
 
diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index 9ba0acb..f82d511 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -2452,11 +2452,8 @@ static void mmu_pte_write_new_pte(struct kvm_vcpu *vcpu,
 				  const void *new)
 {
 	if (sp->role.level != PT_PAGE_TABLE_LEVEL) {
-		if (vcpu->arch.update_pte.level == PT_PAGE_TABLE_LEVEL ||
-		    sp->role.glevels == PT32_ROOT_LEVEL) {
-			++vcpu->kvm->stat.mmu_pde_zapped;
-			return;
-		}
+		++vcpu->kvm->stat.mmu_pde_zapped;
+		return;
         }
 
 	++vcpu->kvm->stat.mmu_pte_updated;
@@ -2502,8 +2499,6 @@ static void mmu_guess_page_from_pte_write(struct kvm_vcpu *vcpu, gpa_t gpa,
 	u64 gpte = 0;
 	pfn_t pfn;
 
-	vcpu->arch.update_pte.level = PT_PAGE_TABLE_LEVEL;
-
 	if (bytes != 4 && bytes != 8)
 		return;
 
@@ -2531,11 +2526,6 @@ static void mmu_guess_page_from_pte_write(struct kvm_vcpu *vcpu, gpa_t gpa,
 		return;
 	gfn = (gpte & PT64_BASE_ADDR_MASK) >> PAGE_SHIFT;
 
-	if (is_large_pte(gpte) &&
-	    (mapping_level(vcpu, gfn) == PT_DIRECTORY_LEVEL)) {
-		gfn &= ~(KVM_PAGES_PER_HPAGE(PT_DIRECTORY_LEVEL) - 1);
-		vcpu->arch.update_pte.level = PT_DIRECTORY_LEVEL;
-	}
 	vcpu->arch.update_pte.mmu_seq = vcpu->kvm->mmu_notifier_seq;
 	smp_rmb();
 	pfn = gfn_to_pfn(vcpu->kvm, gfn);
diff --git a/arch/x86/kvm/paging_tmpl.h b/arch/x86/kvm/paging_tmpl.h
index 578276e..d2fec9c 100644
--- a/arch/x86/kvm/paging_tmpl.h
+++ b/arch/x86/kvm/paging_tmpl.h
@@ -256,7 +256,6 @@ static void FNAME(update_pte)(struct kvm_vcpu *vcpu, struct kvm_mmu_page *page,
 	pt_element_t gpte;
 	unsigned pte_access;
 	pfn_t pfn;
-	int level = vcpu->arch.update_pte.level;
 
 	gpte = *(const pt_element_t *)pte;
 	if (~gpte & (PT_PRESENT_MASK | PT_ACCESSED_MASK)) {
@@ -275,7 +274,7 @@ static void FNAME(update_pte)(struct kvm_vcpu *vcpu, struct kvm_mmu_page *page,
 		return;
 	kvm_get_pfn(pfn);
 	mmu_set_spte(vcpu, spte, page->role.access, pte_access, 0, 0,
-		     gpte & PT_DIRTY_MASK, NULL, level,
+		     gpte & PT_DIRTY_MASK, NULL, PT_PAGE_TABLE_LEVEL,
 		     gpte_to_gfn(gpte), pfn, true);
 }
 
@@ -284,7 +283,7 @@ static void FNAME(update_pte)(struct kvm_vcpu *vcpu, struct kvm_mmu_page *page,
  */
 static u64 *FNAME(fetch)(struct kvm_vcpu *vcpu, gva_t addr,
 			 struct guest_walker *gw,
-			 int user_fault, int write_fault, int largepage,
+			 int user_fault, int write_fault, int hlevel,
 			 int *ptwrite, pfn_t pfn)
 {
 	unsigned access = gw->pt_access;
@@ -303,8 +302,7 @@ static u64 *FNAME(fetch)(struct kvm_vcpu *vcpu, gva_t addr,
 	for_each_shadow_entry(vcpu, addr, iterator) {
 		level = iterator.level;
 		sptep = iterator.sptep;
-		if (level == PT_PAGE_TABLE_LEVEL
-		    || (largepage && level == PT_DIRECTORY_LEVEL)) {
+		if (iterator.level == hlevel) {
 			mmu_set_spte(vcpu, sptep, access,
 				     gw->pte_access & access,
 				     user_fault, write_fault,
@@ -323,12 +321,15 @@ static u64 *FNAME(fetch)(struct kvm_vcpu *vcpu, gva_t addr,
 			kvm_flush_remote_tlbs(vcpu->kvm);
 		}
 
-		if (level == PT_DIRECTORY_LEVEL
-		    && gw->level == PT_DIRECTORY_LEVEL) {
+		if (level <= gw->level) {
+			int delta = level - gw->level + 1;
 			direct = 1;
-			if (!is_dirty_gpte(gw->ptes[level - 1]))
+			if (!is_dirty_gpte(gw->ptes[level - delta]))
 				access &= ~ACC_WRITE_MASK;
-			table_gfn = gpte_to_gfn(gw->ptes[level - 1]);
+			table_gfn = gpte_to_gfn(gw->ptes[level - delta]);
+			/* advance table_gfn when emulating 1gb pages with 4k */
+			if (delta == 0)
+				table_gfn += PT_INDEX(addr, level);
 		} else {
 			direct = 0;
 			table_gfn = gw->table_gfn[level - 2];
@@ -381,7 +382,7 @@ static int FNAME(page_fault)(struct kvm_vcpu *vcpu, gva_t addr,
 	int write_pt = 0;
 	int r;
 	pfn_t pfn;
-	int largepage = 0;
+	int level = PT_PAGE_TABLE_LEVEL;
 	unsigned long mmu_seq;
 
 	pgprintk("%s: addr %lx err %x\n", __func__, addr, error_code);
@@ -407,15 +408,11 @@ static int FNAME(page_fault)(struct kvm_vcpu *vcpu, gva_t addr,
 		return 0;
 	}
 
-	if (walker.level == PT_DIRECTORY_LEVEL) {
-		gfn_t large_gfn;
-		large_gfn = walker.gfn &
-			    ~(KVM_PAGES_PER_HPAGE(PT_DIRECTORY_LEVEL) - 1);
-		if (mapping_level(vcpu, large_gfn) == PT_DIRECTORY_LEVEL) {
-			walker.gfn = large_gfn;
-			largepage = 1;
-		}
+	if (walker.level >= PT_DIRECTORY_LEVEL) {
+		level = min(walker.level, mapping_level(vcpu, walker.gfn));
+		walker.gfn = walker.gfn & ~(KVM_PAGES_PER_HPAGE(level) - 1);
 	}
+
 	mmu_seq = vcpu->kvm->mmu_notifier_seq;
 	smp_rmb();
 	pfn = gfn_to_pfn(vcpu->kvm, walker.gfn);
@@ -432,8 +429,7 @@ static int FNAME(page_fault)(struct kvm_vcpu *vcpu, gva_t addr,
 		goto out_unlock;
 	kvm_mmu_free_some_pages(vcpu);
 	sptep = FNAME(fetch)(vcpu, addr, &walker, user_fault, write_fault,
-			     largepage, &write_pt, pfn);
-
+			     level, &write_pt, pfn);
 	pgprintk("%s: shadow pte %p %llx ptwrite %d\n", __func__,
 		 sptep, *sptep, write_pt);
 
@@ -468,8 +464,9 @@ static void FNAME(invlpg)(struct kvm_vcpu *vcpu, gva_t gva)
 		sptep = iterator.sptep;
 
 		/* FIXME: properly handle invlpg on large guest pages */
-		if (level == PT_PAGE_TABLE_LEVEL ||
-		    ((level == PT_DIRECTORY_LEVEL) && is_large_pte(*sptep))) {
+		if (level == PT_PAGE_TABLE_LEVEL  ||
+		    ((level == PT_DIRECTORY_LEVEL && is_large_pte(*sptep))) ||
+		    ((level == PT_PDPE_LEVEL && is_large_pte(*sptep)))) {
 			struct kvm_mmu_page *sp = page_header(__pa(sptep));
 
 			pte_gpa = (sp->gfn << PAGE_SHIFT);
@@ -599,7 +596,7 @@ static int FNAME(sync_page)(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp)
 		nr_present++;
 		pte_access = sp->role.access & FNAME(gpte_access)(vcpu, gpte);
 		set_spte(vcpu, &sp->spt[i], pte_access, 0, 0,
-			 is_dirty_gpte(gpte), 0, gfn,
+			 is_dirty_gpte(gpte), PT_PAGE_TABLE_LEVEL, gfn,
 			 spte_to_pfn(sp->spt[i]), true, false);
 	}
 
-- 
1.6.3.3


