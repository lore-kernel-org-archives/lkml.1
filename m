Return-Path: <linux-kernel-owner+w=401wt.eu-S1757672AbXL3HW3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757672AbXL3HW3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Dec 2007 02:22:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756530AbXL3HL0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Dec 2007 02:11:26 -0500
Received: from il.qumranet.com ([82.166.9.18]:59483 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755604AbXL3HKu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Dec 2007 02:10:50 -0500
From: Avi Kivity <avi@qumranet.com>
To: linux-kernel@vger.kernel.org, kvm-devel@lists.sourceforge.net
Subject: [PATCH 42/52] KVM: MMU: Avoid unnecessary remote tlb flushes when guest updates a pte
Date: Sun, 30 Dec 2007 09:10:28 +0200
Message-Id: <1198998638-22713-43-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.3.7
In-Reply-To: <1198998638-22713-1-git-send-email-avi@qumranet.com>
References: <1198998638-22713-1-git-send-email-avi@qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If all we're doing is increasing permissions on a pte (typical for demand
paging), then there's not need to flush remote tlbs.  Worst case they'll
get a spurious page fault.

Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 drivers/kvm/mmu.c |   27 ++++++++++++++++++++++++++-
 1 files changed, 26 insertions(+), 1 deletions(-)

diff --git a/drivers/kvm/mmu.c b/drivers/kvm/mmu.c
index 101cd53..281dd5f 100644
--- a/drivers/kvm/mmu.c
+++ b/drivers/kvm/mmu.c
@@ -134,6 +134,8 @@ static int dbg = 1;
 #define PT32_DIR_BASE_ADDR_MASK \
 	(PAGE_MASK & ~((1ULL << (PAGE_SHIFT + PT32_LEVEL_BITS)) - 1))
 
+#define PT64_PERM_MASK (PT_PRESENT_MASK | PT_WRITABLE_MASK | PT_USER_MASK \
+			| PT64_NX_MASK)
 
 #define PFERR_PRESENT_MASK (1U << 0)
 #define PFERR_WRITE_MASK (1U << 1)
@@ -1227,7 +1229,6 @@ static void mmu_pte_write_zap_pte(struct kvm_vcpu *vcpu,
 		}
 	}
 	set_shadow_pte(spte, shadow_trap_nonpresent_pte);
-	kvm_flush_remote_tlbs(vcpu->kvm);
 }
 
 static void mmu_pte_write_new_pte(struct kvm_vcpu *vcpu,
@@ -1250,6 +1251,27 @@ static void mmu_pte_write_new_pte(struct kvm_vcpu *vcpu,
 				    offset_in_pte);
 }
 
+static bool need_remote_flush(u64 old, u64 new)
+{
+	if (!is_shadow_present_pte(old))
+		return false;
+	if (!is_shadow_present_pte(new))
+		return true;
+	if ((old ^ new) & PT64_BASE_ADDR_MASK)
+		return true;
+	old ^= PT64_NX_MASK;
+	new ^= PT64_NX_MASK;
+	return (old & ~new & PT64_PERM_MASK) != 0;
+}
+
+static void mmu_pte_write_flush_tlb(struct kvm_vcpu *vcpu, u64 old, u64 new)
+{
+	if (need_remote_flush(old, new))
+		kvm_flush_remote_tlbs(vcpu->kvm);
+	else
+		kvm_mmu_flush_tlb(vcpu);
+}
+
 static bool last_updated_pte_accessed(struct kvm_vcpu *vcpu)
 {
 	u64 *spte = vcpu->last_pte_updated;
@@ -1265,6 +1287,7 @@ void kvm_mmu_pte_write(struct kvm_vcpu *vcpu, gpa_t gpa,
 	struct hlist_node *node, *n;
 	struct hlist_head *bucket;
 	unsigned index;
+	u64 entry;
 	u64 *spte;
 	unsigned offset = offset_in_page(gpa);
 	unsigned pte_size;
@@ -1335,9 +1358,11 @@ void kvm_mmu_pte_write(struct kvm_vcpu *vcpu, gpa_t gpa,
 		}
 		spte = &page->spt[page_offset / sizeof(*spte)];
 		while (npte--) {
+			entry = *spte;
 			mmu_pte_write_zap_pte(vcpu, page, spte);
 			mmu_pte_write_new_pte(vcpu, page, spte, new, bytes,
 					      page_offset & (pte_size - 1));
+			mmu_pte_write_flush_tlb(vcpu, entry, *spte);
 			++spte;
 		}
 	}
-- 
1.5.3.7

