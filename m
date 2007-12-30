Return-Path: <linux-kernel-owner+w=401wt.eu-S1758871AbXL3HYq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758871AbXL3HYq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Dec 2007 02:24:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753312AbXL3HLd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Dec 2007 02:11:33 -0500
Received: from il.qumranet.com ([82.166.9.18]:59499 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751657AbXL3HKw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Dec 2007 02:10:52 -0500
From: Avi Kivity <avi@qumranet.com>
To: linux-kernel@vger.kernel.org, kvm-devel@lists.sourceforge.net
Subject: [PATCH 52/52] KVM: MMU: Simplify nonpaging_map()
Date: Sun, 30 Dec 2007 09:10:38 +0200
Message-Id: <1198998638-22713-53-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.3.7
In-Reply-To: <1198998638-22713-1-git-send-email-avi@qumranet.com>
References: <1198998638-22713-1-git-send-email-avi@qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Instead of passing an hpa, pass a regular struct page.

Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 drivers/kvm/mmu.c |   24 ++++++++++--------------
 1 files changed, 10 insertions(+), 14 deletions(-)

diff --git a/drivers/kvm/mmu.c b/drivers/kvm/mmu.c
index 1dcffc4..1965185 100644
--- a/drivers/kvm/mmu.c
+++ b/drivers/kvm/mmu.c
@@ -903,13 +903,11 @@ static void nonpaging_new_cr3(struct kvm_vcpu *vcpu)
 {
 }
 
-static int nonpaging_map(struct kvm_vcpu *vcpu, gva_t v, hpa_t p)
+static int nonpaging_map(struct kvm_vcpu *vcpu, gva_t v, struct page *page)
 {
 	int level = PT32E_ROOT_LEVEL;
 	hpa_t table_addr = vcpu->mmu.root_hpa;
-	struct page *page;
 
-	page = pfn_to_page(p >> PAGE_SHIFT);
 	for (; ; level--) {
 		u32 index = PT64_INDEX(v, level);
 		u64 *table;
@@ -930,8 +928,9 @@ static int nonpaging_map(struct kvm_vcpu *vcpu, gva_t v, hpa_t p)
 			mark_page_dirty(vcpu->kvm, v >> PAGE_SHIFT);
 			page_header_update_slot(vcpu->kvm, table,
 						v >> PAGE_SHIFT);
-			table[index] = p | PT_PRESENT_MASK | PT_WRITABLE_MASK |
-								PT_USER_MASK;
+			table[index] = page_to_phys(page)
+				| PT_PRESENT_MASK | PT_WRITABLE_MASK
+				| PT_USER_MASK;
 			if (!was_rmapped)
 				rmap_add(vcpu, &table[index], v >> PAGE_SHIFT);
 			else
@@ -1050,10 +1049,9 @@ static gpa_t nonpaging_gva_to_gpa(struct kvm_vcpu *vcpu, gva_t vaddr)
 }
 
 static int nonpaging_page_fault(struct kvm_vcpu *vcpu, gva_t gva,
-			       u32 error_code)
+				u32 error_code)
 {
-	gpa_t addr = gva;
-	hpa_t paddr;
+	struct page *page;
 	int r;
 
 	r = mmu_topup_memory_caches(vcpu);
@@ -1063,16 +1061,14 @@ static int nonpaging_page_fault(struct kvm_vcpu *vcpu, gva_t gva,
 	ASSERT(vcpu);
 	ASSERT(VALID_PAGE(vcpu->mmu.root_hpa));
 
+	page = gfn_to_page(vcpu->kvm, gva >> PAGE_SHIFT);
 
-	paddr = gpa_to_hpa(vcpu->kvm, addr & PT64_BASE_ADDR_MASK);
-
-	if (is_error_hpa(paddr)) {
-		kvm_release_page_clean(pfn_to_page((paddr & PT64_BASE_ADDR_MASK)
-				       >> PAGE_SHIFT));
+	if (is_error_page(page)) {
+		kvm_release_page_clean(page);
 		return 1;
 	}
 
-	return nonpaging_map(vcpu, addr & PAGE_MASK, paddr);
+	return nonpaging_map(vcpu, gva & PAGE_MASK, page);
 }
 
 static void nonpaging_free(struct kvm_vcpu *vcpu)
-- 
1.5.3.7

