Return-Path: <linux-kernel-owner+w=401wt.eu-S1757225AbXL3HNQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757225AbXL3HNQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Dec 2007 02:13:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756019AbXL3HKy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Dec 2007 02:10:54 -0500
Received: from il.qumranet.com ([82.166.9.18]:59483 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752144AbXL3HKo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Dec 2007 02:10:44 -0500
From: Avi Kivity <avi@qumranet.com>
To: linux-kernel@vger.kernel.org, kvm-devel@lists.sourceforge.net
Subject: [PATCH 08/52] KVM: MMU: Add some mmu statistics
Date: Sun, 30 Dec 2007 09:09:54 +0200
Message-Id: <1198998638-22713-9-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.3.7
In-Reply-To: <1198998638-22713-1-git-send-email-avi@qumranet.com>
References: <1198998638-22713-1-git-send-email-avi@qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 drivers/kvm/kvm.h |    6 ++++++
 drivers/kvm/mmu.c |    9 ++++++++-
 drivers/kvm/x86.c |    6 ++++++
 3 files changed, 20 insertions(+), 1 deletions(-)

diff --git a/drivers/kvm/kvm.h b/drivers/kvm/kvm.h
index d3171f9..bdcc44e 100644
--- a/drivers/kvm/kvm.h
+++ b/drivers/kvm/kvm.h
@@ -362,6 +362,12 @@ struct kvm_memory_slot {
 };
 
 struct kvm_vm_stat {
+	u32 mmu_shadow_zapped;
+	u32 mmu_pte_write;
+	u32 mmu_pte_updated;
+	u32 mmu_pde_zapped;
+	u32 mmu_flooded;
+	u32 mmu_recycled;
 };
 
 struct kvm {
diff --git a/drivers/kvm/mmu.c b/drivers/kvm/mmu.c
index 9be54a5..87d8e70 100644
--- a/drivers/kvm/mmu.c
+++ b/drivers/kvm/mmu.c
@@ -755,6 +755,7 @@ static void kvm_mmu_zap_page(struct kvm *kvm,
 {
 	u64 *parent_pte;
 
+	++kvm->stat.mmu_shadow_zapped;
 	while (page->multimapped || page->parent_pte) {
 		if (!page->multimapped)
 			parent_pte = page->parent_pte;
@@ -1226,9 +1227,12 @@ static void mmu_pte_write_new_pte(struct kvm_vcpu *vcpu,
 				  const void *new, int bytes,
 				  int offset_in_pte)
 {
-	if (page->role.level != PT_PAGE_TABLE_LEVEL)
+	if (page->role.level != PT_PAGE_TABLE_LEVEL) {
+		++vcpu->kvm->stat.mmu_pde_zapped;
 		return;
+	}
 
+	++vcpu->kvm->stat.mmu_pte_updated;
 	if (page->role.glevels == PT32_ROOT_LEVEL)
 		paging32_update_pte(vcpu, page, spte, new, bytes,
 				    offset_in_pte);
@@ -1263,6 +1267,7 @@ void kvm_mmu_pte_write(struct kvm_vcpu *vcpu, gpa_t gpa,
 	int npte;
 
 	pgprintk("%s: gpa %llx bytes %d\n", __FUNCTION__, gpa, bytes);
+	++vcpu->kvm->stat.mmu_pte_write;
 	kvm_mmu_audit(vcpu, "pre pte write");
 	if (gfn == vcpu->last_pt_write_gfn
 	    && !last_updated_pte_accessed(vcpu)) {
@@ -1296,6 +1301,7 @@ void kvm_mmu_pte_write(struct kvm_vcpu *vcpu, gpa_t gpa,
 			pgprintk("misaligned: gpa %llx bytes %d role %x\n",
 				 gpa, bytes, page->role.word);
 			kvm_mmu_zap_page(vcpu->kvm, page);
+			++vcpu->kvm->stat.mmu_flooded;
 			continue;
 		}
 		page_offset = offset;
@@ -1344,6 +1350,7 @@ void __kvm_mmu_free_some_pages(struct kvm_vcpu *vcpu)
 		page = container_of(vcpu->kvm->active_mmu_pages.prev,
 				    struct kvm_mmu_page, link);
 		kvm_mmu_zap_page(vcpu->kvm, page);
+		++vcpu->kvm->stat.mmu_recycled;
 	}
 }
 
diff --git a/drivers/kvm/x86.c b/drivers/kvm/x86.c
index 016abc3..fdc7632 100644
--- a/drivers/kvm/x86.c
+++ b/drivers/kvm/x86.c
@@ -66,6 +66,12 @@ struct kvm_stats_debugfs_item debugfs_entries[] = {
 	{ "fpu_reload", VCPU_STAT(fpu_reload) },
 	{ "insn_emulation", VCPU_STAT(insn_emulation) },
 	{ "insn_emulation_fail", VCPU_STAT(insn_emulation_fail) },
+	{ "mmu_shadow_zapped", VM_STAT(mmu_shadow_zapped) },
+	{ "mmu_pte_write", VM_STAT(mmu_pte_write) },
+	{ "mmu_pte_updated", VM_STAT(mmu_pte_updated) },
+	{ "mmu_pde_zapped", VM_STAT(mmu_pde_zapped) },
+	{ "mmu_flooded", VM_STAT(mmu_flooded) },
+	{ "mmu_recycled", VM_STAT(mmu_recycled) },
 	{ NULL }
 };
 
-- 
1.5.3.7

