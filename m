Return-Path: <linux-kernel-owner+w=401wt.eu-S1755768AbYLHLrV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755768AbYLHLrV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2008 06:47:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753781AbYLHLiV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Dec 2008 06:38:21 -0500
Received: from mx2.redhat.com ([66.187.237.31]:48267 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753326AbYLHLhF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2008 06:37:05 -0500
From: Avi Kivity <avi@redhat.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Izik Eidus <ieidus@redhat.com>
Subject: [PATCH 37/45] KVM: MMU: Fix aliased gfns treated as unaliased
Date: Mon,  8 Dec 2008 13:36:48 +0200
Message-Id: <1228736216-15787-38-git-send-email-avi@redhat.com>
In-Reply-To: <1228736216-15787-1-git-send-email-avi@redhat.com>
References: <1228736216-15787-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Izik Eidus <ieidus@redhat.com>

Some areas of kvm x86 mmu are using gfn offset inside a slot without
unaliasing the gfn first.  This patch makes sure that the gfn will be
unaliased and add gfn_to_memslot_unaliased() to save the calculating
of the gfn unaliasing in case we have it unaliased already.

Signed-off-by: Izik Eidus <ieidus@redhat.com>
Acked-by: Marcelo Tosatti <mtosatti@redhat.com>
Signed-off-by: Avi Kivity <avi@redhat.com>
---
 arch/x86/include/asm/kvm_host.h |    2 ++
 arch/x86/kvm/mmu.c              |   14 ++++++++++----
 virt/kvm/kvm_main.c             |    9 +++++----
 3 files changed, 17 insertions(+), 8 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 09e6c56..99e3cc1 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -617,6 +617,8 @@ void kvm_disable_tdp(void);
 int load_pdptrs(struct kvm_vcpu *vcpu, unsigned long cr3);
 int complete_pio(struct kvm_vcpu *vcpu);
 
+struct kvm_memory_slot *gfn_to_memslot_unaliased(struct kvm *kvm, gfn_t gfn);
+
 static inline struct kvm_mmu_page *page_header(hpa_t shadow_page)
 {
 	struct page *page = pfn_to_page(shadow_page >> PAGE_SHIFT);
diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index 8687758..8904e8a 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -386,7 +386,9 @@ static void account_shadowed(struct kvm *kvm, gfn_t gfn)
 {
 	int *write_count;
 
-	write_count = slot_largepage_idx(gfn, gfn_to_memslot(kvm, gfn));
+	gfn = unalias_gfn(kvm, gfn);
+	write_count = slot_largepage_idx(gfn,
+					 gfn_to_memslot_unaliased(kvm, gfn));
 	*write_count += 1;
 }
 
@@ -394,16 +396,20 @@ static void unaccount_shadowed(struct kvm *kvm, gfn_t gfn)
 {
 	int *write_count;
 
-	write_count = slot_largepage_idx(gfn, gfn_to_memslot(kvm, gfn));
+	gfn = unalias_gfn(kvm, gfn);
+	write_count = slot_largepage_idx(gfn,
+					 gfn_to_memslot_unaliased(kvm, gfn));
 	*write_count -= 1;
 	WARN_ON(*write_count < 0);
 }
 
 static int has_wrprotected_page(struct kvm *kvm, gfn_t gfn)
 {
-	struct kvm_memory_slot *slot = gfn_to_memslot(kvm, gfn);
+	struct kvm_memory_slot *slot;
 	int *largepage_idx;
 
+	gfn = unalias_gfn(kvm, gfn);
+	slot = gfn_to_memslot_unaliased(kvm, gfn);
 	if (slot) {
 		largepage_idx = slot_largepage_idx(gfn, slot);
 		return *largepage_idx;
@@ -2973,8 +2979,8 @@ static void audit_write_protection(struct kvm_vcpu *vcpu)
 		if (sp->role.metaphysical)
 			continue;
 
-		slot = gfn_to_memslot(vcpu->kvm, sp->gfn);
 		gfn = unalias_gfn(vcpu->kvm, sp->gfn);
+		slot = gfn_to_memslot_unaliased(vcpu->kvm, sp->gfn);
 		rmapp = &slot->rmap[gfn - slot->base_gfn];
 		if (*rmapp)
 			printk(KERN_ERR "%s: (%s) shadow page has writable"
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 1838052..a65baa9 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -923,7 +923,7 @@ int kvm_is_error_hva(unsigned long addr)
 }
 EXPORT_SYMBOL_GPL(kvm_is_error_hva);
 
-static struct kvm_memory_slot *__gfn_to_memslot(struct kvm *kvm, gfn_t gfn)
+struct kvm_memory_slot *gfn_to_memslot_unaliased(struct kvm *kvm, gfn_t gfn)
 {
 	int i;
 
@@ -936,11 +936,12 @@ static struct kvm_memory_slot *__gfn_to_memslot(struct kvm *kvm, gfn_t gfn)
 	}
 	return NULL;
 }
+EXPORT_SYMBOL_GPL(gfn_to_memslot_unaliased);
 
 struct kvm_memory_slot *gfn_to_memslot(struct kvm *kvm, gfn_t gfn)
 {
 	gfn = unalias_gfn(kvm, gfn);
-	return __gfn_to_memslot(kvm, gfn);
+	return gfn_to_memslot_unaliased(kvm, gfn);
 }
 
 int kvm_is_visible_gfn(struct kvm *kvm, gfn_t gfn)
@@ -964,7 +965,7 @@ unsigned long gfn_to_hva(struct kvm *kvm, gfn_t gfn)
 	struct kvm_memory_slot *slot;
 
 	gfn = unalias_gfn(kvm, gfn);
-	slot = __gfn_to_memslot(kvm, gfn);
+	slot = gfn_to_memslot_unaliased(kvm, gfn);
 	if (!slot)
 		return bad_hva();
 	return (slot->userspace_addr + (gfn - slot->base_gfn) * PAGE_SIZE);
@@ -1215,7 +1216,7 @@ void mark_page_dirty(struct kvm *kvm, gfn_t gfn)
 	struct kvm_memory_slot *memslot;
 
 	gfn = unalias_gfn(kvm, gfn);
-	memslot = __gfn_to_memslot(kvm, gfn);
+	memslot = gfn_to_memslot_unaliased(kvm, gfn);
 	if (memslot && memslot->dirty_bitmap) {
 		unsigned long rel_gfn = gfn - memslot->base_gfn;
 
-- 
1.6.0.3

