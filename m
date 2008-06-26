Return-Path: <linux-kernel-owner+w=401wt.eu-S1759692AbYFZMqF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759692AbYFZMqF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2008 08:46:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752259AbYFZM37
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jun 2008 08:29:59 -0400
Received: from il.qumranet.com ([212.179.150.194]:32376 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752085AbYFZM2i (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2008 08:28:38 -0400
From: Avi Kivity <avi@qumranet.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 13/50] KVM: MMU: Fix false flooding when a pte points to page table
Date: Thu, 26 Jun 2008 15:27:55 +0300
Message-Id: <1214483312-9265-14-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.6
In-Reply-To: <1214483312-9265-1-git-send-email-avi@qumranet.com>
References: <1214483312-9265-1-git-send-email-avi@qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The KVM MMU tries to detect when a speculative pte update is not actually
used by demand fault, by checking the accessed bit of the shadow pte.  If
the shadow pte has not been accessed, we deem that page table flooded and
remove the shadow page table, allowing further pte updates to proceed
without emulation.

However, if the pte itself points at a page table and only used for write
operations, the accessed bit will never be set since all access will happen
through the emulator.

This is exactly what happens with kscand on old (2.4.x) HIGHMEM kernels.
The kernel points a kmap_atomic() pte at a page table, and then
proceeds with read-modify-write operations to look at the dirty and accessed
bits.  We get a false flood trigger on the kmap ptes, which results in the
mmu spending all its time setting up and tearing down shadows.

Fix by setting the shadow accessed bit on emulated accesses.

Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 arch/x86/kvm/mmu.c         |   17 ++++++++++++++++-
 arch/x86/kvm/mmu.h         |    3 ++-
 include/asm-x86/kvm_host.h |    1 +
 3 files changed, 19 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index 8e449db..53f1ed8 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -1122,8 +1122,10 @@ static void mmu_set_spte(struct kvm_vcpu *vcpu, u64 *shadow_pte,
 		else
 			kvm_release_pfn_clean(pfn);
 	}
-	if (!ptwrite || !*ptwrite)
+	if (speculative) {
 		vcpu->arch.last_pte_updated = shadow_pte;
+		vcpu->arch.last_pte_gfn = gfn;
+	}
 }
 
 static void nonpaging_new_cr3(struct kvm_vcpu *vcpu)
@@ -1671,6 +1673,18 @@ static void mmu_guess_page_from_pte_write(struct kvm_vcpu *vcpu, gpa_t gpa,
 	vcpu->arch.update_pte.pfn = pfn;
 }
 
+static void kvm_mmu_access_page(struct kvm_vcpu *vcpu, gfn_t gfn)
+{
+	u64 *spte = vcpu->arch.last_pte_updated;
+
+	if (spte
+	    && vcpu->arch.last_pte_gfn == gfn
+	    && shadow_accessed_mask
+	    && !(*spte & shadow_accessed_mask)
+	    && is_shadow_present_pte(*spte))
+		set_bit(PT_ACCESSED_SHIFT, (unsigned long *)spte);
+}
+
 void kvm_mmu_pte_write(struct kvm_vcpu *vcpu, gpa_t gpa,
 		       const u8 *new, int bytes)
 {
@@ -1694,6 +1708,7 @@ void kvm_mmu_pte_write(struct kvm_vcpu *vcpu, gpa_t gpa,
 	pgprintk("%s: gpa %llx bytes %d\n", __func__, gpa, bytes);
 	mmu_guess_page_from_pte_write(vcpu, gpa, new, bytes);
 	spin_lock(&vcpu->kvm->mmu_lock);
+	kvm_mmu_access_page(vcpu, gfn);
 	kvm_mmu_free_some_pages(vcpu);
 	++vcpu->kvm->stat.mmu_pte_write;
 	kvm_mmu_audit(vcpu, "pre pte write");
diff --git a/arch/x86/kvm/mmu.h b/arch/x86/kvm/mmu.h
index 1730757..258e5d5 100644
--- a/arch/x86/kvm/mmu.h
+++ b/arch/x86/kvm/mmu.h
@@ -15,7 +15,8 @@
 #define PT_USER_MASK (1ULL << 2)
 #define PT_PWT_MASK (1ULL << 3)
 #define PT_PCD_MASK (1ULL << 4)
-#define PT_ACCESSED_MASK (1ULL << 5)
+#define PT_ACCESSED_SHIFT 5
+#define PT_ACCESSED_MASK (1ULL << PT_ACCESSED_SHIFT)
 #define PT_DIRTY_MASK (1ULL << 6)
 #define PT_PAGE_SIZE_MASK (1ULL << 7)
 #define PT_PAT_MASK (1ULL << 7)
diff --git a/include/asm-x86/kvm_host.h b/include/asm-x86/kvm_host.h
index 844f2a8..c2d066e 100644
--- a/include/asm-x86/kvm_host.h
+++ b/include/asm-x86/kvm_host.h
@@ -243,6 +243,7 @@ struct kvm_vcpu_arch {
 	gfn_t last_pt_write_gfn;
 	int   last_pt_write_count;
 	u64  *last_pte_updated;
+	gfn_t last_pte_gfn;
 
 	struct {
 		gfn_t gfn;	/* presumed gfn during guest pte update */
-- 
1.5.6

