Return-Path: <linux-kernel-owner+w=401wt.eu-S1755945AbYCaOiu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755945AbYCaOiu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Mar 2008 10:38:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751447AbYCaOhd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 31 Mar 2008 10:37:33 -0400
Received: from bzq-179-150-194.static.bezeqint.net ([212.179.150.194]:51275
	"EHLO il.qumranet.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751104AbYCaOh3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Mar 2008 10:37:29 -0400
From: Avi Kivity <avi@qumranet.com>
To: kvm-devel@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org, "Dong, Eddie" <eddie.dong@intel.com>
Subject: [PATCH 01/40] KVM: MMU: Update shadow ptes on partial guest pte writes
Date: Mon, 31 Mar 2008 17:36:45 +0300
Message-Id: <1206974244-9716-2-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.4.5
In-Reply-To: <1206974244-9716-1-git-send-email-avi@qumranet.com>
References: <1206974244-9716-1-git-send-email-avi@qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dong, Eddie <eddie.dong@intel.com>

A guest partial guest pte write will leave shadow_trap_nonpresent_pte
in spte, which generates a vmexit at the next guest access through that pte.

This patch improves this by reading the full guest pte in advance and thus
being able to update the spte and eliminate the vmexit.

This helps pae guests which use two 32-bit writes to set a single 64-bit pte.

[truncation fix by Eric]

Signed-off-by: Yaozu (Eddie) Dong <eddie.dong@intel.com>
Signed-off-by: Feng (Eric) Liu <eric.e.liu@intel.com>
Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 arch/x86/kvm/mmu.c         |   23 ++++++++++++++++-------
 arch/x86/kvm/paging_tmpl.h |    7 ++-----
 2 files changed, 18 insertions(+), 12 deletions(-)

diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index e55af12..28f9a44 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -1329,8 +1329,7 @@ static void mmu_pte_write_zap_pte(struct kvm_vcpu *vcpu,
 static void mmu_pte_write_new_pte(struct kvm_vcpu *vcpu,
 				  struct kvm_mmu_page *sp,
 				  u64 *spte,
-				  const void *new, int bytes,
-				  int offset_in_pte)
+				  const void *new)
 {
 	if (sp->role.level != PT_PAGE_TABLE_LEVEL) {
 		++vcpu->kvm->stat.mmu_pde_zapped;
@@ -1339,9 +1338,9 @@ static void mmu_pte_write_new_pte(struct kvm_vcpu *vcpu,
 
 	++vcpu->kvm->stat.mmu_pte_updated;
 	if (sp->role.glevels == PT32_ROOT_LEVEL)
-		paging32_update_pte(vcpu, sp, spte, new, bytes, offset_in_pte);
+		paging32_update_pte(vcpu, sp, spte, new);
 	else
-		paging64_update_pte(vcpu, sp, spte, new, bytes, offset_in_pte);
+		paging64_update_pte(vcpu, sp, spte, new);
 }
 
 static bool need_remote_flush(u64 old, u64 new)
@@ -1423,7 +1422,7 @@ void kvm_mmu_pte_write(struct kvm_vcpu *vcpu, gpa_t gpa,
 	struct hlist_node *node, *n;
 	struct hlist_head *bucket;
 	unsigned index;
-	u64 entry;
+	u64 entry, gentry;
 	u64 *spte;
 	unsigned offset = offset_in_page(gpa);
 	unsigned pte_size;
@@ -1433,6 +1432,7 @@ void kvm_mmu_pte_write(struct kvm_vcpu *vcpu, gpa_t gpa,
 	int level;
 	int flooded = 0;
 	int npte;
+	int r;
 
 	pgprintk("%s: gpa %llx bytes %d\n", __FUNCTION__, gpa, bytes);
 	mmu_guess_page_from_pte_write(vcpu, gpa, new, bytes);
@@ -1496,11 +1496,20 @@ void kvm_mmu_pte_write(struct kvm_vcpu *vcpu, gpa_t gpa,
 				continue;
 		}
 		spte = &sp->spt[page_offset / sizeof(*spte)];
+		if ((gpa & (pte_size - 1)) || (bytes < pte_size)) {
+			gentry = 0;
+			r = kvm_read_guest_atomic(vcpu->kvm,
+						  gpa & ~(u64)(pte_size - 1),
+						  &gentry, pte_size);
+			new = (const void *)&gentry;
+			if (r < 0)
+				new = NULL;
+		}
 		while (npte--) {
 			entry = *spte;
 			mmu_pte_write_zap_pte(vcpu, sp, spte);
-			mmu_pte_write_new_pte(vcpu, sp, spte, new, bytes,
-					      page_offset & (pte_size - 1));
+			if (new)
+				mmu_pte_write_new_pte(vcpu, sp, spte, new);
 			mmu_pte_write_flush_tlb(vcpu, entry, *spte);
 			++spte;
 		}
diff --git a/arch/x86/kvm/paging_tmpl.h b/arch/x86/kvm/paging_tmpl.h
index ecc0856..c2fd2b9 100644
--- a/arch/x86/kvm/paging_tmpl.h
+++ b/arch/x86/kvm/paging_tmpl.h
@@ -243,8 +243,7 @@ err:
 }
 
 static void FNAME(update_pte)(struct kvm_vcpu *vcpu, struct kvm_mmu_page *page,
-			      u64 *spte, const void *pte, int bytes,
-			      int offset_in_pte)
+			      u64 *spte, const void *pte)
 {
 	pt_element_t gpte;
 	unsigned pte_access;
@@ -252,12 +251,10 @@ static void FNAME(update_pte)(struct kvm_vcpu *vcpu, struct kvm_mmu_page *page,
 
 	gpte = *(const pt_element_t *)pte;
 	if (~gpte & (PT_PRESENT_MASK | PT_ACCESSED_MASK)) {
-		if (!offset_in_pte && !is_present_pte(gpte))
+		if (!is_present_pte(gpte))
 			set_shadow_pte(spte, shadow_notrap_nonpresent_pte);
 		return;
 	}
-	if (bytes < sizeof(pt_element_t))
-		return;
 	pgprintk("%s: gpte %llx spte %p\n", __FUNCTION__, (u64)gpte, spte);
 	pte_access = page->role.access & FNAME(gpte_access)(vcpu, gpte);
 	if (gpte_to_gfn(gpte) != vcpu->arch.update_pte.gfn)
-- 
1.5.4.5

