Return-Path: <linux-kernel-owner+w=401wt.eu-S1759110AbZC0Oem@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759110AbZC0Oem (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Mar 2009 10:34:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755385AbZC0Ocg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Mar 2009 10:32:36 -0400
Received: from outbound-sin.frontbridge.com ([207.46.51.80]:24586 "EHLO
	SG2EHSOBE001.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755682AbZC0Oc0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Mar 2009 10:32:26 -0400
X-BigFish: VPS-3(zz1102Lzz1202hzzz32i64h)
X-Spam-TCS-SCL: 3:0
X-WSS-ID: 0KH65PH-02-E3V-01
From: Joerg Roedel <joerg.roedel@amd.com>
To: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>
CC: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
       Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 5/7] kvm mmu: add support for 1GB pages to direct mapping paths
Date: Fri, 27 Mar 2009 15:31:57 +0100
Message-ID: <1238164319-16092-6-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.5.6.4
In-Reply-To: <1238164319-16092-1-git-send-email-joerg.roedel@amd.com>
References: <1238164319-16092-1-git-send-email-joerg.roedel@amd.com>
X-OriginalArrivalTime: 27 Mar 2009 14:32:00.0618 (UTC) FILETIME=[CA48BCA0:01C9AEE8]
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch makes the MMU path for TDP aware of 1GB pages.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 arch/x86/kvm/mmu.c         |   56 +++++++++++++++++++++++++++++++++++--------
 arch/x86/kvm/paging_tmpl.h |   14 +++++++++++
 2 files changed, 59 insertions(+), 11 deletions(-)

diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index 7d4162d..3f5e20b 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -116,6 +116,11 @@ module_param(oos_shadow, bool, 0644);
 #define PT64_DIR_BASE_ADDR_MASK \
 	(PT64_BASE_ADDR_MASK & ~((1ULL << (PAGE_SHIFT + PT64_LEVEL_BITS)) - 1))
 
+#define PT64_MID_BASE_ADDR_MASK (PT64_BASE_ADDR_MASK & \
+		~((1ULL << (PAGE_SHIFT + (2 * PT64_LEVEL_BITS))) - 1))
+#define PT64_MID_GFN_DELTA_MASK (PT64_BASE_ADDR_MASK & (((1ULL << \
+				(2 * PT64_LEVEL_BITS)) - 1) << PAGE_SHIFT))
+
 #define PT32_BASE_ADDR_MASK PAGE_MASK
 #define PT32_DIR_BASE_ADDR_MASK \
 	(PAGE_MASK & ~((1ULL << (PAGE_SHIFT + PT32_LEVEL_BITS)) - 1))
@@ -128,6 +133,7 @@ module_param(oos_shadow, bool, 0644);
 #define PFERR_USER_MASK (1U << 2)
 #define PFERR_FETCH_MASK (1U << 4)
 
+#define PT_MIDDLE_LEVEL 3
 #define PT_DIRECTORY_LEVEL 2
 #define PT_PAGE_TABLE_LEVEL 1
 
@@ -507,16 +513,29 @@ static unsigned long *gfn_to_rmap(struct kvm *kvm, gfn_t gfn,
 				  enum kvm_page_size psize)
 {
 	struct kvm_memory_slot *slot;
-	unsigned long idx;
+	unsigned long idx, *ret;
 
 	slot = gfn_to_memslot(kvm, gfn);
-	if (psize == KVM_PAGE_SIZE_4k)
-		return &slot->rmap[gfn - slot->base_gfn];
 
-	idx = (gfn / KVM_PAGES_PER_2M_PAGE) -
-	      (slot->base_gfn / KVM_PAGES_PER_2M_PAGE);
+	switch (psize) {
+	case KVM_PAGE_SIZE_4k:
+		ret = &slot->rmap[gfn - slot->base_gfn];
+		break;
+	case KVM_PAGE_SIZE_2M:
+		idx = (gfn / KVM_PAGES_PER_2M_PAGE) -
+		      (slot->base_gfn / KVM_PAGES_PER_2M_PAGE);
+		ret = &slot->lpage_info[idx].rmap_pde;
+		break;
+	case KVM_PAGE_SIZE_1G:
+		idx = (gfn / KVM_PAGES_PER_1G_PAGE) -
+		      (slot->base_gfn / KVM_PAGES_PER_1G_PAGE);
+		ret = &slot->hpage_info[idx].rmap_pde;
+		break;
+	default:
+		BUG();
+	}
 
-	return &slot->lpage_info[idx].rmap_pde;
+	return ret;
 }
 
 /*
@@ -1363,7 +1382,10 @@ static void kvm_mmu_page_unlink_children(struct kvm *kvm,
 							   &pt[i]);
 			} else {
 				--kvm->stat.lpages;
-				rmap_remove(kvm, &pt[i], KVM_PAGE_SIZE_2M);
+				if (sp->role.level == PT_DIRECTORY_LEVEL)
+					rmap_remove(kvm, &pt[i], KVM_PAGE_SIZE_2M);
+				else
+					rmap_remove(kvm, &pt[i], KVM_PAGE_SIZE_1G);
 			}
 		}
 		pt[i] = shadow_trap_nonpresent_pte;
@@ -1769,8 +1791,10 @@ static int set_spte(struct kvm_vcpu *vcpu, u64 *shadow_pte,
 	if ((pte_access & ACC_WRITE_MASK)
 	    || (write_fault && !is_write_protection(vcpu) && !user_fault)) {
 
-		if (psize > KVM_PAGE_SIZE_4k &&
-		    has_wrprotected_page(vcpu->kvm, gfn)) {
+		if ((psize == KVM_PAGE_SIZE_2M &&
+		     has_wrprotected_page(vcpu->kvm, gfn)) ||
+		    (psize == KVM_PAGE_SIZE_1G &&
+		     has_wrprotected_largepage(vcpu->kvm, gfn))) {
 			ret = 1;
 			spte = shadow_trap_nonpresent_pte;
 			goto set_pte;
@@ -1884,7 +1908,9 @@ static int __direct_map(struct kvm_vcpu *vcpu, gpa_t v, int write,
 	for_each_shadow_entry(vcpu, (u64)gfn << PAGE_SHIFT, iterator) {
 		if (iterator.level == PT_PAGE_TABLE_LEVEL
 		    || (psize == KVM_PAGE_SIZE_2M &&
-			iterator.level == PT_DIRECTORY_LEVEL)) {
+			iterator.level == PT_DIRECTORY_LEVEL)
+		    || (psize == KVM_PAGE_SIZE_1G &&
+			iterator.level == PT_MIDDLE_LEVEL)) {
 			mmu_set_spte(vcpu, iterator.sptep, ACC_ALL, ACC_ALL,
 				     0, write, 1, &pt_write,
 				     psize, 0, gfn, pfn, false);
@@ -1919,8 +1945,14 @@ static int nonpaging_map(struct kvm_vcpu *vcpu, gva_t v, int write, gfn_t gfn)
 	unsigned long mmu_seq;
 	enum kvm_page_size psize = backing_size(vcpu, gfn);
 
-	if (psize == KVM_PAGE_SIZE_2M)
+	if (psize >= KVM_PAGE_SIZE_2M) {
+		/*
+		 * nonpaging mode uses pae page tables - so we
+		 * can't use gbpages here - take care of this
+		 */
 		gfn &= ~(KVM_PAGES_PER_2M_PAGE-1);
+		psize = KVM_PAGE_SIZE_2M;
+	}
 
 	mmu_seq = vcpu->kvm->mmu_notifier_seq;
 	smp_rmb();
@@ -2123,6 +2155,8 @@ static int tdp_page_fault(struct kvm_vcpu *vcpu, gva_t gpa,
 	psize = backing_size(vcpu, gfn);
 	if (psize == KVM_PAGE_SIZE_2M)
 		gfn &= ~(KVM_PAGES_PER_2M_PAGE-1);
+	else if (psize == KVM_PAGE_SIZE_1G)
+		gfn &= ~(KVM_PAGES_PER_1G_PAGE-1);
 	mmu_seq = vcpu->kvm->mmu_notifier_seq;
 	smp_rmb();
 	pfn = gfn_to_pfn(vcpu->kvm, gfn);
diff --git a/arch/x86/kvm/paging_tmpl.h b/arch/x86/kvm/paging_tmpl.h
index 6704ec7..67d6bfb 100644
--- a/arch/x86/kvm/paging_tmpl.h
+++ b/arch/x86/kvm/paging_tmpl.h
@@ -55,6 +55,7 @@
 
 #define gpte_to_gfn FNAME(gpte_to_gfn)
 #define gpte_to_gfn_pde FNAME(gpte_to_gfn_pde)
+#define gpte_to_gfn_pmd FNAME(gpte_to_gfn_pmd)
 
 /*
  * The guest_walker structure emulates the behavior of the hardware page
@@ -81,6 +82,11 @@ static gfn_t gpte_to_gfn_pde(pt_element_t gpte)
 	return (gpte & PT_DIR_BASE_ADDR_MASK) >> PAGE_SHIFT;
 }
 
+static gfn_t gpte_to_gfn_pmd(pt_element_t gpte)
+{
+	return (gpte & PT64_MID_BASE_ADDR_MASK) >> PAGE_SHIFT;
+}
+
 static bool FNAME(cmpxchg_gpte)(struct kvm *kvm,
 			 gfn_t table_gfn, unsigned index,
 			 pt_element_t orig_pte, pt_element_t new_pte)
@@ -196,6 +202,14 @@ walk:
 			break;
 		}
 
+		if (walker->level == PT_MIDDLE_LEVEL &&
+		    (pte & PT_PAGE_SIZE_MASK) &&
+		    is_long_mode(vcpu)) {
+			walker->gfn = gpte_to_gfn_pmd(pte);
+			walker->gfn += (addr & PT64_MID_GFN_DELTA_MASK) >> PAGE_SHIFT;
+			break;
+		}
+
 		pt_access = pte_access;
 		--walker->level;
 	}
-- 
1.5.6.4


