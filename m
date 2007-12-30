Return-Path: <linux-kernel-owner+w=401wt.eu-S1758517AbXL3HV7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758517AbXL3HV7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Dec 2007 02:21:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756518AbXL3HLZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Dec 2007 02:11:25 -0500
Received: from il.qumranet.com ([82.166.9.18]:59485 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755424AbXL3HKt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Dec 2007 02:10:49 -0500
From: Avi Kivity <avi@qumranet.com>
To: linux-kernel@vger.kernel.org, kvm-devel@lists.sourceforge.net
Cc: Zhang Xiantao <xiantao.zhang@intel.com>
Subject: [PATCH 37/52] KVM: Recalculate mmu pages needed for every memory region change
Date: Sun, 30 Dec 2007 09:10:23 +0200
Message-Id: <1198998638-22713-38-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.3.7
In-Reply-To: <1198998638-22713-1-git-send-email-avi@qumranet.com>
References: <1198998638-22713-1-git-send-email-avi@qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Zhang Xiantao <xiantao.zhang@intel.com>

Instead of incrementally changing the mmu cache size for every memory slot
operation, recalculate it from scratch.  This is simpler and safer.

Signed-off-by: Zhang Xiantao <xiantao.zhang@intel.com>
Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 drivers/kvm/kvm_main.c |   21 ++++-----------------
 drivers/kvm/mmu.c      |   19 +++++++++++++++++++
 drivers/kvm/x86.h      |    1 +
 3 files changed, 24 insertions(+), 17 deletions(-)

diff --git a/drivers/kvm/kvm_main.c b/drivers/kvm/kvm_main.c
index f06fa3a..6a702e1 100644
--- a/drivers/kvm/kvm_main.c
+++ b/drivers/kvm/kvm_main.c
@@ -333,26 +333,13 @@ int __kvm_set_memory_region(struct kvm *kvm,
 	if (mem->slot >= kvm->nmemslots)
 		kvm->nmemslots = mem->slot + 1;
 
+	*memslot = new;
+
 	if (!kvm->n_requested_mmu_pages) {
-		unsigned int n_pages;
-
-		if (npages) {
-			n_pages = npages * KVM_PERMILLE_MMU_PAGES / 1000;
-			kvm_mmu_change_mmu_pages(kvm, kvm->n_alloc_mmu_pages +
-						 n_pages);
-		} else {
-			unsigned int nr_mmu_pages;
-
-			n_pages = old.npages * KVM_PERMILLE_MMU_PAGES / 1000;
-			nr_mmu_pages = kvm->n_alloc_mmu_pages - n_pages;
-			nr_mmu_pages = max(nr_mmu_pages,
-				        (unsigned int) KVM_MIN_ALLOC_MMU_PAGES);
-			kvm_mmu_change_mmu_pages(kvm, nr_mmu_pages);
-		}
+		unsigned int nr_mmu_pages = kvm_mmu_calculate_mmu_pages(kvm);
+		kvm_mmu_change_mmu_pages(kvm, nr_mmu_pages);
 	}
 
-	*memslot = new;
-
 	kvm_mmu_slot_remove_write_access(kvm, mem->slot);
 	kvm_flush_remote_tlbs(kvm);
 
diff --git a/drivers/kvm/mmu.c b/drivers/kvm/mmu.c
index 4624f37..101cd53 100644
--- a/drivers/kvm/mmu.c
+++ b/drivers/kvm/mmu.c
@@ -1535,6 +1535,25 @@ nomem:
 	return -ENOMEM;
 }
 
+/*
+ * Caculate mmu pages needed for kvm.
+ */
+unsigned int kvm_mmu_calculate_mmu_pages(struct kvm *kvm)
+{
+	int i;
+	unsigned int nr_mmu_pages;
+	unsigned int  nr_pages = 0;
+
+	for (i = 0; i < kvm->nmemslots; i++)
+		nr_pages += kvm->memslots[i].npages;
+
+	nr_mmu_pages = nr_pages * KVM_PERMILLE_MMU_PAGES / 1000;
+	nr_mmu_pages = max(nr_mmu_pages,
+			(unsigned int) KVM_MIN_ALLOC_MMU_PAGES);
+
+	return nr_mmu_pages;
+}
+
 #ifdef AUDIT
 
 static const char *audit_msg;
diff --git a/drivers/kvm/x86.h b/drivers/kvm/x86.h
index 90b791b..71f2477 100644
--- a/drivers/kvm/x86.h
+++ b/drivers/kvm/x86.h
@@ -236,6 +236,7 @@ void kvm_mmu_set_nonpresent_ptes(u64 trap_pte, u64 notrap_pte);
 int kvm_mmu_reset_context(struct kvm_vcpu *vcpu);
 void kvm_mmu_slot_remove_write_access(struct kvm *kvm, int slot);
 void kvm_mmu_zap_all(struct kvm *kvm);
+unsigned int kvm_mmu_calculate_mmu_pages(struct kvm *kvm);
 void kvm_mmu_change_mmu_pages(struct kvm *kvm, unsigned int kvm_nr_mmu_pages);
 
 enum emulation_result {
-- 
1.5.3.7

