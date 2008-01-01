Return-Path: <linux-kernel-owner+w=401wt.eu-S1758654AbYAAPut@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758654AbYAAPut (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jan 2008 10:50:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755520AbYAAPg7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Jan 2008 10:36:59 -0500
Received: from il.qumranet.com ([82.166.9.18]:33785 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755256AbYAAPgc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jan 2008 10:36:32 -0500
From: Avi Kivity <avi@qumranet.com>
To: linux-kernel@vger.kernel.org, kvm-devel@lists.sourceforge.net
Subject: [PATCH 51/54] KVM: MMU: Use mmu_set_spte() for real-mode shadows
Date: Tue,  1 Jan 2008 17:36:17 +0200
Message-Id: <1199201780-14001-52-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.3.7
In-Reply-To: <1199201780-14001-1-git-send-email-avi@qumranet.com>
References: <1199201780-14001-1-git-send-email-avi@qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In addition to removing some duplicated code, this also handles the unlikely
case of real-mode code updating a guest page table.  This can happen when
one vcpu (in real mode) touches a second vcpu's (in protected mode) page
tables, or if a vcpu switches to real mode, touches page tables, and switches
back.

Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 drivers/kvm/mmu.c |   41 ++++++++++-------------------------------
 1 files changed, 10 insertions(+), 31 deletions(-)

diff --git a/drivers/kvm/mmu.c b/drivers/kvm/mmu.c
index b4dd726..ba71e8d 100644
--- a/drivers/kvm/mmu.c
+++ b/drivers/kvm/mmu.c
@@ -966,40 +966,23 @@ static void nonpaging_new_cr3(struct kvm_vcpu *vcpu)
 {
 }
 
-static int nonpaging_map(struct kvm_vcpu *vcpu, gva_t v, struct page *page)
+static int nonpaging_map(struct kvm_vcpu *vcpu, gva_t v, int write, gfn_t gfn)
 {
 	int level = PT32E_ROOT_LEVEL;
 	hpa_t table_addr = vcpu->mmu.root_hpa;
+	int pt_write = 0;
 
 	for (; ; level--) {
 		u32 index = PT64_INDEX(v, level);
 		u64 *table;
-		u64 pte;
 
 		ASSERT(VALID_PAGE(table_addr));
 		table = __va(table_addr);
 
 		if (level == 1) {
-			int was_rmapped;
-
-			pte = table[index];
-			was_rmapped = is_rmap_pte(pte);
-			if (is_shadow_present_pte(pte) && is_writeble_pte(pte)) {
-				kvm_release_page_clean(page);
-				return 0;
-			}
-			mark_page_dirty(vcpu->kvm, v >> PAGE_SHIFT);
-			page_header_update_slot(vcpu->kvm, table,
-						v >> PAGE_SHIFT);
-			table[index] = page_to_phys(page)
-				| PT_PRESENT_MASK | PT_WRITABLE_MASK
-				| PT_USER_MASK;
-			if (!was_rmapped)
-				rmap_add(vcpu, &table[index], v >> PAGE_SHIFT);
-			else
-				kvm_release_page_clean(page);
-
-			return 0;
+			mmu_set_spte(vcpu, &table[index], ACC_ALL, ACC_ALL,
+				     0, write, 1, &pt_write, gfn);
+			return pt_write || is_io_pte(table[index]);
 		}
 
 		if (table[index] == shadow_trap_nonpresent_pte) {
@@ -1013,7 +996,6 @@ static int nonpaging_map(struct kvm_vcpu *vcpu, gva_t v, struct page *page)
 						     1, ACC_ALL, &table[index]);
 			if (!new_table) {
 				pgprintk("nonpaging_map: ENOMEM\n");
-				kvm_release_page_clean(page);
 				return -ENOMEM;
 			}
 
@@ -1114,9 +1096,10 @@ static gpa_t nonpaging_gva_to_gpa(struct kvm_vcpu *vcpu, gva_t vaddr)
 static int nonpaging_page_fault(struct kvm_vcpu *vcpu, gva_t gva,
 				u32 error_code)
 {
-	struct page *page;
+	gfn_t gfn;
 	int r;
 
+	pgprintk("%s: gva %lx error %x\n", __FUNCTION__, gva, error_code);
 	r = mmu_topup_memory_caches(vcpu);
 	if (r)
 		return r;
@@ -1124,14 +1107,10 @@ static int nonpaging_page_fault(struct kvm_vcpu *vcpu, gva_t gva,
 	ASSERT(vcpu);
 	ASSERT(VALID_PAGE(vcpu->mmu.root_hpa));
 
-	page = gfn_to_page(vcpu->kvm, gva >> PAGE_SHIFT);
-
-	if (is_error_page(page)) {
-		kvm_release_page_clean(page);
-		return 1;
-	}
+	gfn = gva >> PAGE_SHIFT;
 
-	return nonpaging_map(vcpu, gva & PAGE_MASK, page);
+	return nonpaging_map(vcpu, gva & PAGE_MASK,
+			     error_code & PFERR_WRITE_MASK, gfn);
 }
 
 static void nonpaging_free(struct kvm_vcpu *vcpu)
-- 
1.5.3.7

