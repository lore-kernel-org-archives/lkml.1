Return-Path: <linux-kernel-owner+w=401wt.eu-S1758728AbYAAPuS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758728AbYAAPuS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jan 2008 10:50:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755511AbYAAPg6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Jan 2008 10:36:58 -0500
Received: from il.qumranet.com ([82.166.9.18]:33805 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755244AbYAAPgc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jan 2008 10:36:32 -0500
From: Avi Kivity <avi@qumranet.com>
To: linux-kernel@vger.kernel.org, kvm-devel@lists.sourceforge.net
Subject: [PATCH 49/54] KVM: MMU: Move set_pte() into guest paging mode independent code
Date: Tue,  1 Jan 2008 17:36:15 +0200
Message-Id: <1199201780-14001-50-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.3.7
In-Reply-To: <1199201780-14001-1-git-send-email-avi@qumranet.com>
References: <1199201780-14001-1-git-send-email-avi@qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As set_pte() no longer references either a gpte or the guest walker, we can
move it out of paging mode dependent code (which compiles twice and is
generally nasty).

Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 drivers/kvm/mmu.c         |   83 ++++++++++++++++++++++++++++++++++++++++
 drivers/kvm/paging_tmpl.h |   93 ++------------------------------------------
 2 files changed, 88 insertions(+), 88 deletions(-)

diff --git a/drivers/kvm/mmu.c b/drivers/kvm/mmu.c
index cace1e4..a91e05b 100644
--- a/drivers/kvm/mmu.c
+++ b/drivers/kvm/mmu.c
@@ -879,6 +879,89 @@ struct page *gva_to_page(struct kvm_vcpu *vcpu, gva_t gva)
 	return gfn_to_page(vcpu->kvm, gpa >> PAGE_SHIFT);
 }
 
+static void mmu_set_spte(struct kvm_vcpu *vcpu, u64 *shadow_pte,
+			 unsigned pt_access, unsigned pte_access,
+			 int user_fault, int write_fault, int dirty,
+			 int *ptwrite, gfn_t gfn)
+{
+	u64 spte;
+	int was_rmapped = is_rmap_pte(*shadow_pte);
+	struct page *page;
+
+	pgprintk("%s: spte %llx gpte %llx access %x write_fault %d"
+		 " user_fault %d gfn %lx\n",
+		 __FUNCTION__, *shadow_pte, (u64)gpte, pt_access,
+		 write_fault, user_fault, gfn);
+
+	/*
+	 * We don't set the accessed bit, since we sometimes want to see
+	 * whether the guest actually used the pte (in order to detect
+	 * demand paging).
+	 */
+	spte = PT_PRESENT_MASK | PT_DIRTY_MASK;
+	if (!dirty)
+		pte_access &= ~ACC_WRITE_MASK;
+	if (!(pte_access & ACC_EXEC_MASK))
+		spte |= PT64_NX_MASK;
+
+	page = gfn_to_page(vcpu->kvm, gfn);
+
+	spte |= PT_PRESENT_MASK;
+	if (pte_access & ACC_USER_MASK)
+		spte |= PT_USER_MASK;
+
+	if (is_error_page(page)) {
+		set_shadow_pte(shadow_pte,
+			       shadow_trap_nonpresent_pte | PT_SHADOW_IO_MARK);
+		kvm_release_page_clean(page);
+		return;
+	}
+
+	spte |= page_to_phys(page);
+
+	if ((pte_access & ACC_WRITE_MASK)
+	    || (write_fault && !is_write_protection(vcpu) && !user_fault)) {
+		struct kvm_mmu_page *shadow;
+
+		spte |= PT_WRITABLE_MASK;
+		if (user_fault) {
+			mmu_unshadow(vcpu->kvm, gfn);
+			goto unshadowed;
+		}
+
+		shadow = kvm_mmu_lookup_page(vcpu->kvm, gfn);
+		if (shadow) {
+			pgprintk("%s: found shadow page for %lx, marking ro\n",
+				 __FUNCTION__, gfn);
+			pte_access &= ~ACC_WRITE_MASK;
+			if (is_writeble_pte(spte)) {
+				spte &= ~PT_WRITABLE_MASK;
+				kvm_x86_ops->tlb_flush(vcpu);
+			}
+			if (write_fault)
+				*ptwrite = 1;
+		}
+	}
+
+unshadowed:
+
+	if (pte_access & ACC_WRITE_MASK)
+		mark_page_dirty(vcpu->kvm, gfn);
+
+	pgprintk("%s: setting spte %llx\n", __FUNCTION__, spte);
+	set_shadow_pte(shadow_pte, spte);
+	page_header_update_slot(vcpu->kvm, shadow_pte, gfn);
+	if (!was_rmapped) {
+		rmap_add(vcpu, shadow_pte, gfn);
+		if (!is_rmap_pte(*shadow_pte))
+			kvm_release_page_clean(page);
+	}
+	else
+		kvm_release_page_clean(page);
+	if (!ptwrite || !*ptwrite)
+		vcpu->last_pte_updated = shadow_pte;
+}
+
 static void nonpaging_new_cr3(struct kvm_vcpu *vcpu)
 {
 }
diff --git a/drivers/kvm/paging_tmpl.h b/drivers/kvm/paging_tmpl.h
index 2e5a80a..3ab3fb6 100644
--- a/drivers/kvm/paging_tmpl.h
+++ b/drivers/kvm/paging_tmpl.h
@@ -235,89 +235,6 @@ err:
 	return 0;
 }
 
-static void FNAME(set_pte)(struct kvm_vcpu *vcpu, u64 *shadow_pte,
-			   unsigned pt_access, unsigned pte_access,
-			   int user_fault, int write_fault, int dirty,
-			   int *ptwrite, gfn_t gfn)
-{
-	u64 spte;
-	int was_rmapped = is_rmap_pte(*shadow_pte);
-	struct page *page;
-
-	pgprintk("%s: spte %llx gpte %llx access %x write_fault %d"
-		 " user_fault %d gfn %lx\n",
-		 __FUNCTION__, *shadow_pte, (u64)gpte, pt_access,
-		 write_fault, user_fault, gfn);
-
-	/*
-	 * We don't set the accessed bit, since we sometimes want to see
-	 * whether the guest actually used the pte (in order to detect
-	 * demand paging).
-	 */
-	spte = PT_PRESENT_MASK | PT_DIRTY_MASK;
-	if (!dirty)
-		pte_access &= ~ACC_WRITE_MASK;
-	if (!(pte_access & ACC_EXEC_MASK))
-		spte |= PT64_NX_MASK;
-
-	page = gfn_to_page(vcpu->kvm, gfn);
-
-	spte |= PT_PRESENT_MASK;
-	if (pte_access & ACC_USER_MASK)
-		spte |= PT_USER_MASK;
-
-	if (is_error_page(page)) {
-		set_shadow_pte(shadow_pte,
-			       shadow_trap_nonpresent_pte | PT_SHADOW_IO_MARK);
-		kvm_release_page_clean(page);
-		return;
-	}
-
-	spte |= page_to_phys(page);
-
-	if ((pte_access & ACC_WRITE_MASK)
-	    || (write_fault && !is_write_protection(vcpu) && !user_fault)) {
-		struct kvm_mmu_page *shadow;
-
-		spte |= PT_WRITABLE_MASK;
-		if (user_fault) {
-			mmu_unshadow(vcpu->kvm, gfn);
-			goto unshadowed;
-		}
-
-		shadow = kvm_mmu_lookup_page(vcpu->kvm, gfn);
-		if (shadow) {
-			pgprintk("%s: found shadow page for %lx, marking ro\n",
-				 __FUNCTION__, gfn);
-			pte_access &= ~ACC_WRITE_MASK;
-			if (is_writeble_pte(spte)) {
-				spte &= ~PT_WRITABLE_MASK;
-				kvm_x86_ops->tlb_flush(vcpu);
-			}
-			if (write_fault)
-				*ptwrite = 1;
-		}
-	}
-
-unshadowed:
-
-	if (pte_access & ACC_WRITE_MASK)
-		mark_page_dirty(vcpu->kvm, gfn);
-
-	pgprintk("%s: setting spte %llx\n", __FUNCTION__, spte);
-	set_shadow_pte(shadow_pte, spte);
-	page_header_update_slot(vcpu->kvm, shadow_pte, gfn);
-	if (!was_rmapped) {
-		rmap_add(vcpu, shadow_pte, gfn);
-		if (!is_rmap_pte(*shadow_pte))
-			kvm_release_page_clean(page);
-	}
-	else
-		kvm_release_page_clean(page);
-	if (!ptwrite || !*ptwrite)
-		vcpu->last_pte_updated = shadow_pte;
-}
-
 static void FNAME(update_pte)(struct kvm_vcpu *vcpu, struct kvm_mmu_page *page,
 			      u64 *spte, const void *pte, int bytes,
 			      int offset_in_pte)
@@ -335,8 +252,8 @@ static void FNAME(update_pte)(struct kvm_vcpu *vcpu, struct kvm_mmu_page *page,
 		return;
 	pgprintk("%s: gpte %llx spte %p\n", __FUNCTION__, (u64)gpte, spte);
 	pte_access = page->role.access & FNAME(gpte_access)(vcpu, gpte);
-	FNAME(set_pte)(vcpu, spte, page->role.access, pte_access, 0, 0,
-		       gpte & PT_DIRTY_MASK, NULL, gpte_to_gfn(gpte));
+	mmu_set_spte(vcpu, spte, page->role.access, pte_access, 0, 0,
+		     gpte & PT_DIRTY_MASK, NULL, gpte_to_gfn(gpte));
 }
 
 /*
@@ -399,9 +316,9 @@ static u64 *FNAME(fetch)(struct kvm_vcpu *vcpu, gva_t addr,
 		*shadow_ent = shadow_pte;
 	}
 
-	FNAME(set_pte)(vcpu, shadow_ent, access, walker->pte_access & access,
-		       user_fault, write_fault, walker->pte & PT_DIRTY_MASK,
-		       ptwrite, walker->gfn);
+	mmu_set_spte(vcpu, shadow_ent, access, walker->pte_access & access,
+		     user_fault, write_fault, walker->pte & PT_DIRTY_MASK,
+		     ptwrite, walker->gfn);
 
 	return shadow_ent;
 }
-- 
1.5.3.7

