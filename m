Return-Path: <linux-kernel-owner+w=401wt.eu-S1755138AbZFSNRJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755138AbZFSNRJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Jun 2009 09:17:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752314AbZFSNQr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Jun 2009 09:16:47 -0400
Received: from outbound-dub.frontbridge.com ([213.199.154.16]:47180 "EHLO
	IE1EHSOBE003.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752212AbZFSNQp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Jun 2009 09:16:45 -0400
X-SpamScore: 3
X-BigFish: VPS3(zzzz1202hzzz32i17ch43j64h)
X-Spam-TCS-SCL: 3:0
X-WSS-ID: 0KLHM7P-03-BJ1-01
From: Joerg Roedel <joerg.roedel@amd.com>
To: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <marcelo@kvack.org>
CC: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
       Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 3/8] kvm/mmu: rename is_largepage_backed to mapping_level
Date: Fri, 19 Jun 2009 15:16:24 +0200
Message-ID: <1245417389-5527-4-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.6.3.1
In-Reply-To: <1245417389-5527-1-git-send-email-joerg.roedel@amd.com>
References: <1245417389-5527-1-git-send-email-joerg.roedel@amd.com>
X-OriginalArrivalTime: 19 Jun 2009 13:16:38.0537 (UTC) FILETIME=[2D9CEF90:01C9F0E0]
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With the new name and the corresponding backend changes this function
can now support multiple hugepage sizes.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 arch/x86/kvm/mmu.c         |  100 +++++++++++++++++++++++++++++--------------
 arch/x86/kvm/paging_tmpl.h |    4 +-
 2 files changed, 69 insertions(+), 35 deletions(-)

diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index 1f24d88..3fa6009 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -390,37 +390,52 @@ static void mmu_free_rmap_desc(struct kvm_rmap_desc *rd)
  * Return the pointer to the largepage write count for a given
  * gfn, handling slots that are not large page aligned.
  */
-static int *slot_largepage_idx(gfn_t gfn, struct kvm_memory_slot *slot)
+static int *slot_largepage_idx(gfn_t gfn,
+			       struct kvm_memory_slot *slot,
+			       int level)
 {
 	unsigned long idx;
 
-	idx = (gfn / KVM_PAGES_PER_HPAGE(PT_DIRECTORY_LEVEL)) -
-	      (slot->base_gfn / KVM_PAGES_PER_HPAGE(PT_DIRECTORY_LEVEL));
-	return &slot->lpage_info[0][idx].write_count;
+	idx = (gfn / KVM_PAGES_PER_HPAGE(level)) -
+	      (slot->base_gfn / KVM_PAGES_PER_HPAGE(level));
+	return &slot->lpage_info[level - 2][idx].write_count;
 }
 
 static void account_shadowed(struct kvm *kvm, gfn_t gfn)
 {
+	struct kvm_memory_slot *slot;
 	int *write_count;
+	int i;
 
 	gfn = unalias_gfn(kvm, gfn);
-	write_count = slot_largepage_idx(gfn,
-					 gfn_to_memslot_unaliased(kvm, gfn));
-	*write_count += 1;
+
+	for (i = PT_DIRECTORY_LEVEL;
+	     i < PT_PAGE_TABLE_LEVEL + KVM_NR_PAGE_SIZES; ++i) {
+		slot          = gfn_to_memslot_unaliased(kvm, gfn);
+		write_count   = slot_largepage_idx(gfn, slot, i);
+		*write_count += 1;
+	}
 }
 
 static void unaccount_shadowed(struct kvm *kvm, gfn_t gfn)
 {
+	struct kvm_memory_slot *slot;
 	int *write_count;
+	int i;
 
 	gfn = unalias_gfn(kvm, gfn);
-	write_count = slot_largepage_idx(gfn,
-					 gfn_to_memslot_unaliased(kvm, gfn));
-	*write_count -= 1;
-	WARN_ON(*write_count < 0);
+	for (i = PT_DIRECTORY_LEVEL;
+	     i < PT_PAGE_TABLE_LEVEL + KVM_NR_PAGE_SIZES; ++i) {
+		slot          = gfn_to_memslot_unaliased(kvm, gfn);
+		write_count   = slot_largepage_idx(gfn, slot, i);
+		*write_count -= 1;
+		WARN_ON(*write_count < 0);
+	}
 }
 
-static int has_wrprotected_page(struct kvm *kvm, gfn_t gfn)
+static int has_wrprotected_page(struct kvm *kvm,
+				gfn_t gfn,
+				int level)
 {
 	struct kvm_memory_slot *slot;
 	int *largepage_idx;
@@ -428,47 +443,67 @@ static int has_wrprotected_page(struct kvm *kvm, gfn_t gfn)
 	gfn = unalias_gfn(kvm, gfn);
 	slot = gfn_to_memslot_unaliased(kvm, gfn);
 	if (slot) {
-		largepage_idx = slot_largepage_idx(gfn, slot);
+		largepage_idx = slot_largepage_idx(gfn, slot, level);
 		return *largepage_idx;
 	}
 
 	return 1;
 }
 
-static int host_largepage_backed(struct kvm *kvm, gfn_t gfn)
+static int host_mapping_level(struct kvm *kvm, gfn_t gfn)
 {
+	unsigned long page_size = PAGE_SIZE;
 	struct vm_area_struct *vma;
 	unsigned long addr;
-	int ret = 0;
+	int i, ret = 0;
 
 	addr = gfn_to_hva(kvm, gfn);
 	if (kvm_is_error_hva(addr))
-		return ret;
+		return page_size;
 
 	down_read(&current->mm->mmap_sem);
 	vma = find_vma(current->mm, addr);
-	if (vma && is_vm_hugetlb_page(vma))
-		ret = 1;
+	if (!vma)
+		goto out;
+
+	page_size = vma_kernel_pagesize(vma);
+
+out:
 	up_read(&current->mm->mmap_sem);
 
+	for (i = PT_PAGE_TABLE_LEVEL;
+	     i < (PT_PAGE_TABLE_LEVEL + KVM_NR_PAGE_SIZES); ++i) {
+		if (page_size >= KVM_HPAGE_SIZE(i))
+			ret = i;
+		else
+			break;
+	}
+
 	return ret;
 }
 
-static int is_largepage_backed(struct kvm_vcpu *vcpu, gfn_t large_gfn)
+static int mapping_level(struct kvm_vcpu *vcpu, gfn_t large_gfn)
 {
 	struct kvm_memory_slot *slot;
-
-	if (has_wrprotected_page(vcpu->kvm, large_gfn))
-		return 0;
-
-	if (!host_largepage_backed(vcpu->kvm, large_gfn))
-		return 0;
+	int host_level;
+	int level = PT_PAGE_TABLE_LEVEL;
 
 	slot = gfn_to_memslot(vcpu->kvm, large_gfn);
 	if (slot && slot->dirty_bitmap)
-		return 0;
+		return PT_PAGE_TABLE_LEVEL;
 
-	return 1;
+	host_level = host_mapping_level(vcpu->kvm, large_gfn);
+
+	if (host_level == PT_PAGE_TABLE_LEVEL)
+		return host_level;
+
+	for (level = PT_DIRECTORY_LEVEL; level <= host_level; ++level) {
+
+		if (has_wrprotected_page(vcpu->kvm, large_gfn, level))
+			break;
+	}
+
+	return level - 1;
 }
 
 /*
@@ -1704,7 +1739,7 @@ static int set_spte(struct kvm_vcpu *vcpu, u64 *sptep,
 	if ((pte_access & ACC_WRITE_MASK)
 	    || (write_fault && !is_write_protection(vcpu) && !user_fault)) {
 
-		if (largepage && has_wrprotected_page(vcpu->kvm, gfn)) {
+		if (largepage && has_wrprotected_page(vcpu->kvm, gfn, 1)) {
 			ret = 1;
 			spte = shadow_trap_nonpresent_pte;
 			goto set_pte;
@@ -1852,8 +1887,7 @@ static int nonpaging_map(struct kvm_vcpu *vcpu, gva_t v, int write, gfn_t gfn)
 	pfn_t pfn;
 	unsigned long mmu_seq;
 
-	if (is_largepage_backed(vcpu, gfn &
-			~(KVM_PAGES_PER_HPAGE(PT_DIRECTORY_LEVEL) - 1))) {
+	if (mapping_level(vcpu, gfn) == PT_DIRECTORY_LEVEL) {
 		gfn &= ~(KVM_PAGES_PER_HPAGE(PT_DIRECTORY_LEVEL) - 1);
 		largepage = 1;
 	}
@@ -2059,8 +2093,7 @@ static int tdp_page_fault(struct kvm_vcpu *vcpu, gva_t gpa,
 	if (r)
 		return r;
 
-	if (is_largepage_backed(vcpu, gfn &
-			~(KVM_PAGES_PER_HPAGE(PT_DIRECTORY_LEVEL) - 1))) {
+	if (mapping_level(vcpu, gfn) == PT_DIRECTORY_LEVEL) {
 		gfn &= ~(KVM_PAGES_PER_HPAGE(PT_DIRECTORY_LEVEL) - 1);
 		largepage = 1;
 	}
@@ -2462,7 +2495,8 @@ static void mmu_guess_page_from_pte_write(struct kvm_vcpu *vcpu, gpa_t gpa,
 		return;
 	gfn = (gpte & PT64_BASE_ADDR_MASK) >> PAGE_SHIFT;
 
-	if (is_large_pte(gpte) && is_largepage_backed(vcpu, gfn)) {
+	if (is_large_pte(gpte) &&
+	    (mapping_level(vcpu, gfn) == PT_DIRECTORY_LEVEL)) {
 		gfn &= ~(KVM_PAGES_PER_HPAGE(PT_DIRECTORY_LEVEL) - 1);
 		vcpu->arch.update_pte.largepage = 1;
 	}
diff --git a/arch/x86/kvm/paging_tmpl.h b/arch/x86/kvm/paging_tmpl.h
index 53e129c..25a4437 100644
--- a/arch/x86/kvm/paging_tmpl.h
+++ b/arch/x86/kvm/paging_tmpl.h
@@ -402,8 +402,8 @@ static int FNAME(page_fault)(struct kvm_vcpu *vcpu, gva_t addr,
 	if (walker.level == PT_DIRECTORY_LEVEL) {
 		gfn_t large_gfn;
 		large_gfn = walker.gfn &
-			~(KVM_PAGES_PER_HPAGE(PT_DIRECTORY_LEVEL) - 1);
-		if (is_largepage_backed(vcpu, large_gfn)) {
+			    ~(KVM_PAGES_PER_HPAGE(PT_DIRECTORY_LEVEL) - 1);
+		if (mapping_level(vcpu, large_gfn) == PT_DIRECTORY_LEVEL) {
 			walker.gfn = large_gfn;
 			largepage = 1;
 		}
-- 
1.6.3.1


