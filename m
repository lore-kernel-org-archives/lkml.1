Return-Path: <linux-kernel-owner+w=401wt.eu-S1757219AbXLWOyd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757219AbXLWOyd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Dec 2007 09:54:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755321AbXLWOvs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Dec 2007 09:51:48 -0500
Received: from il.qumranet.com ([82.166.9.18]:35902 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752662AbXLWOvj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Dec 2007 09:51:39 -0500
From: Avi Kivity <avi@qumranet.com>
To: linux-kernel@vger.kernel.org, kvm-devel@lists.sourceforge.net
Subject: [PATCH 10/50] KVM: MMU: Make flooding detection work when guest page faults are bypassed
Date: Sun, 23 Dec 2007 16:50:55 +0200
Message-Id: <1198421495-31481-11-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.3.7
In-Reply-To: <1198421495-31481-1-git-send-email-avi@qumranet.com>
References: <1198421495-31481-1-git-send-email-avi@qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When we allow guest page faults to reach the guests directly, we lose
the fault tracking which allows us to detect demand paging.  So we provide
an alternate mechnism by clearing the accessed bit when we set a pte, and
checking it later to see if the guest actually used it.

Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 drivers/kvm/kvm.h         |    1 +
 drivers/kvm/mmu.c         |   21 ++++++++++++++++++++-
 drivers/kvm/paging_tmpl.h |    9 ++++++++-
 3 files changed, 29 insertions(+), 2 deletions(-)

diff --git a/drivers/kvm/kvm.h b/drivers/kvm/kvm.h
index 7de948e..08ffc82 100644
--- a/drivers/kvm/kvm.h
+++ b/drivers/kvm/kvm.h
@@ -346,6 +346,7 @@ struct kvm_vcpu {
 
 	gfn_t last_pt_write_gfn;
 	int   last_pt_write_count;
+	u64  *last_pte_updated;
 
 	struct kvm_guest_debug guest_debug;
 
diff --git a/drivers/kvm/mmu.c b/drivers/kvm/mmu.c
index 069ce83..d347e89 100644
--- a/drivers/kvm/mmu.c
+++ b/drivers/kvm/mmu.c
@@ -692,6 +692,15 @@ static void kvm_mmu_put_page(struct kvm_mmu_page *page,
 	mmu_page_remove_parent_pte(page, parent_pte);
 }
 
+static void kvm_mmu_reset_last_pte_updated(struct kvm *kvm)
+{
+	int i;
+
+	for (i = 0; i < KVM_MAX_VCPUS; ++i)
+		if (kvm->vcpus[i])
+			kvm->vcpus[i]->last_pte_updated = NULL;
+}
+
 static void kvm_mmu_zap_page(struct kvm *kvm,
 			     struct kvm_mmu_page *page)
 {
@@ -717,6 +726,7 @@ static void kvm_mmu_zap_page(struct kvm *kvm,
 		kvm_mmu_free_page(kvm, page);
 	} else
 		list_move(&page->link, &kvm->active_mmu_pages);
+	kvm_mmu_reset_last_pte_updated(kvm);
 }
 
 static int kvm_mmu_unprotect_page(struct kvm_vcpu *vcpu, gfn_t gfn)
@@ -1140,6 +1150,13 @@ static void mmu_pte_write_new_pte(struct kvm_vcpu *vcpu,
 				    offset_in_pte);
 }
 
+static bool last_updated_pte_accessed(struct kvm_vcpu *vcpu)
+{
+	u64 *spte = vcpu->last_pte_updated;
+
+	return !!(spte && (*spte & PT_ACCESSED_MASK));
+}
+
 void kvm_mmu_pte_write(struct kvm_vcpu *vcpu, gpa_t gpa,
 		       const u8 *new, int bytes)
 {
@@ -1160,13 +1177,15 @@ void kvm_mmu_pte_write(struct kvm_vcpu *vcpu, gpa_t gpa,
 
 	pgprintk("%s: gpa %llx bytes %d\n", __FUNCTION__, gpa, bytes);
 	kvm_mmu_audit(vcpu, "pre pte write");
-	if (gfn == vcpu->last_pt_write_gfn) {
+	if (gfn == vcpu->last_pt_write_gfn
+	    && !last_updated_pte_accessed(vcpu)) {
 		++vcpu->last_pt_write_count;
 		if (vcpu->last_pt_write_count >= 3)
 			flooded = 1;
 	} else {
 		vcpu->last_pt_write_gfn = gfn;
 		vcpu->last_pt_write_count = 1;
+		vcpu->last_pte_updated = NULL;
 	}
 	index = kvm_page_table_hashfn(gfn) % KVM_NUM_MMU_PAGES;
 	bucket = &vcpu->kvm->mmu_page_hash[index];
diff --git a/drivers/kvm/paging_tmpl.h b/drivers/kvm/paging_tmpl.h
index 99ac9b1..be0f852 100644
--- a/drivers/kvm/paging_tmpl.h
+++ b/drivers/kvm/paging_tmpl.h
@@ -238,7 +238,12 @@ static void FNAME(set_pte_common)(struct kvm_vcpu *vcpu,
 		FNAME(mark_pagetable_dirty)(vcpu->kvm, walker);
 	}
 
-	spte = PT_PRESENT_MASK | PT_ACCESSED_MASK | PT_DIRTY_MASK;
+	/*
+	 * We don't set the accessed bit, since we sometimes want to see
+	 * whether the guest actually used the pte (in order to detect
+	 * demand paging).
+	 */
+	spte = PT_PRESENT_MASK | PT_DIRTY_MASK;
 	spte |= gpte & PT64_NX_MASK;
 	if (!dirty)
 		access_bits &= ~PT_WRITABLE_MASK;
@@ -291,6 +296,8 @@ unshadowed:
 	page_header_update_slot(vcpu->kvm, shadow_pte, gaddr);
 	if (!was_rmapped)
 		rmap_add(vcpu, shadow_pte);
+	if (!ptwrite || !*ptwrite)
+		vcpu->last_pte_updated = shadow_pte;
 }
 
 static void FNAME(set_pte)(struct kvm_vcpu *vcpu, pt_element_t gpte,
-- 
1.5.3.7

