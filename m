Return-Path: <linux-kernel-owner+w=401wt.eu-S1763806AbYDCTlm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763806AbYDCTlm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Apr 2008 15:41:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761213AbYDCTdZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Apr 2008 15:33:25 -0400
Received: from bzq-179-150-194.static.bezeqint.net ([212.179.150.194]:53020
	"EHLO il.qumranet.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760830AbYDCTdB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Apr 2008 15:33:01 -0400
From: Avi Kivity <avi@qumranet.com>
To: kvm-devel@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 31/35] KVM: MMU: Introduce and use spte_to_page()
Date: Thu,  3 Apr 2008 22:32:46 +0300
Message-Id: <1207251170-5013-32-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.4.5
In-Reply-To: <1207251170-5013-1-git-send-email-avi@qumranet.com>
References: <1207251170-5013-1-git-send-email-avi@qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Encapsulate the pte mask'n'shift in a function.

Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 arch/x86/kvm/mmu.c |   17 ++++++++++++-----
 1 files changed, 12 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index dd4b95b..6fc3421 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -240,6 +240,13 @@ static int is_rmap_pte(u64 pte)
 	return is_shadow_present_pte(pte);
 }
 
+static struct page *spte_to_page(u64 pte)
+{
+	hfn_t hfn = (pte & PT64_BASE_ADDR_MASK) >> PAGE_SHIFT;
+
+	return pfn_to_page(hfn);
+}
+
 static gfn_t pse36_gfn_delta(u32 gpte)
 {
 	int shift = 32 - PT32_DIR_PSE36_SHIFT - PAGE_SHIFT;
@@ -541,7 +548,7 @@ static void rmap_remove(struct kvm *kvm, u64 *spte)
 	if (!is_rmap_pte(*spte))
 		return;
 	sp = page_header(__pa(spte));
-	page = pfn_to_page((*spte & PT64_BASE_ADDR_MASK) >> PAGE_SHIFT);
+	page = spte_to_page(*spte);
 	mark_page_accessed(page);
 	if (is_writeble_pte(*spte))
 		kvm_release_page_dirty(page);
@@ -630,7 +637,7 @@ static void rmap_write_protect(struct kvm *kvm, u64 gfn)
 		struct page *page;
 
 		spte = rmap_next(kvm, rmapp, NULL);
-		page = pfn_to_page((*spte & PT64_BASE_ADDR_MASK) >> PAGE_SHIFT);
+		page = spte_to_page(*spte);
 		SetPageDirty(page);
 	}
 
@@ -1033,7 +1040,6 @@ static void mmu_set_spte(struct kvm_vcpu *vcpu, u64 *shadow_pte,
 	u64 spte;
 	int was_rmapped = 0;
 	int was_writeble = is_writeble_pte(*shadow_pte);
-	hfn_t host_pfn = (*shadow_pte & PT64_BASE_ADDR_MASK) >> PAGE_SHIFT;
 
 	pgprintk("%s: spte %llx access %x write_fault %d"
 		 " user_fault %d gfn %lx\n",
@@ -1051,9 +1057,10 @@ static void mmu_set_spte(struct kvm_vcpu *vcpu, u64 *shadow_pte,
 
 			child = page_header(pte & PT64_BASE_ADDR_MASK);
 			mmu_page_remove_parent_pte(child, shadow_pte);
-		} else if (host_pfn != page_to_pfn(page)) {
+		} else if (page != spte_to_page(*shadow_pte)) {
 			pgprintk("hfn old %lx new %lx\n",
-				 host_pfn, page_to_pfn(page));
+				 page_to_pfn(spte_to_page(*shadow_pte)),
+				 page_to_pfn(page));
 			rmap_remove(vcpu->kvm, shadow_pte);
 		} else {
 			if (largepage)
-- 
1.5.4.5

