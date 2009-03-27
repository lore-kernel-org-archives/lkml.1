Return-Path: <linux-kernel-owner+w=401wt.eu-S1758600AbZC0Odo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758600AbZC0Odo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Mar 2009 10:33:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757144AbZC0Oc1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Mar 2009 10:32:27 -0400
Received: from outbound-sin.frontbridge.com ([207.46.51.80]:24110 "EHLO
	SG2EHSOBE004.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756148AbZC0OcY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Mar 2009 10:32:24 -0400
X-BigFish: VPS1(z5b2jz1102Lzz1202hzzz32i43j62h)
X-Spam-TCS-SCL: 1:0
X-WSS-ID: 0KH65PC-02-E3R-01
From: Joerg Roedel <joerg.roedel@amd.com>
To: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>
CC: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
       Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 4/7] kvm mmu: implement necessary data structures for second huge page accounting
Date: Fri, 27 Mar 2009 15:31:56 +0100
Message-ID: <1238164319-16092-5-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.5.6.4
In-Reply-To: <1238164319-16092-1-git-send-email-joerg.roedel@amd.com>
References: <1238164319-16092-1-git-send-email-joerg.roedel@amd.com>
X-OriginalArrivalTime: 27 Mar 2009 14:32:00.0306 (UTC) FILETIME=[CA192120:01C9AEE8]
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds the necessary data structures to take care of write
protections in place within a second huge page sized page.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 arch/x86/include/asm/kvm_host.h |   10 ++++++++++
 arch/x86/kvm/mmu.c              |   33 +++++++++++++++++++++++++++++++++
 include/linux/kvm_host.h        |    2 +-
 virt/kvm/kvm_main.c             |   26 ++++++++++++++++++++++++++
 4 files changed, 70 insertions(+), 1 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index f268f99..a1df2a3 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -58,7 +58,16 @@
 
 #define KVM_PAGES_PER_2M_PAGE (KVM_2M_PAGE_SIZE / PAGE_SIZE)
 
+#define KVM_1G_PAGE_SHIFT 30
+#define KVM_1G_PAGE_SIZE (1UL << KVM_1G_PAGE_SHIFT)
+#define KVM_1G_PAGE_MASK (~(KVM_1G_PAGE_SIZE - 1))
+
+#define KVM_PAGES_PER_1G_PAGE (KVM_1G_PAGE_SIZE / PAGE_SIZE)
+
+/* Huge Page */
 #define KVM_PAGES_PER_HPAGE	KVM_PAGES_PER_2M_PAGE
+/* Large Huge Page ;-) */
+#define KVM_PAGES_PER_LHPAGE	KVM_PAGES_PER_1G_PAGE
 
 #define DE_VECTOR 0
 #define DB_VECTOR 1
@@ -268,6 +277,7 @@ struct kvm_mmu {
 enum kvm_page_size {
 	KVM_PAGE_SIZE_4k = (1 << 12),
 	KVM_PAGE_SIZE_2M = (1 << 21),
+	KVM_PAGE_SIZE_1G = (1 << 30),
 };
 
 struct kvm_vcpu_arch {
diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index 9936b45..7d4162d 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -390,6 +390,15 @@ static int *slot_largepage_idx(gfn_t gfn, struct kvm_memory_slot *slot)
 	return &slot->lpage_info[idx].write_count;
 }
 
+static int *slot_hugepage_idx(gfn_t gfn, struct kvm_memory_slot *slot)
+{
+	unsigned long idx;
+
+	idx = (gfn / KVM_PAGES_PER_1G_PAGE) -
+	      (slot->base_gfn / KVM_PAGES_PER_1G_PAGE);
+	return &slot->hpage_info[idx].write_count;
+}
+
 static void account_shadowed(struct kvm *kvm, gfn_t gfn)
 {
 	int *write_count;
@@ -398,6 +407,10 @@ static void account_shadowed(struct kvm *kvm, gfn_t gfn)
 	write_count = slot_largepage_idx(gfn,
 					 gfn_to_memslot_unaliased(kvm, gfn));
 	*write_count += 1;
+
+	write_count = slot_hugepage_idx(gfn,
+					gfn_to_memslot_unaliased(kvm, gfn));
+	*write_count += 1;
 }
 
 static void unaccount_shadowed(struct kvm *kvm, gfn_t gfn)
@@ -409,6 +422,11 @@ static void unaccount_shadowed(struct kvm *kvm, gfn_t gfn)
 					 gfn_to_memslot_unaliased(kvm, gfn));
 	*write_count -= 1;
 	WARN_ON(*write_count < 0);
+
+	write_count = slot_hugepage_idx(gfn,
+					gfn_to_memslot_unaliased(kvm, gfn));
+	*write_count -= 1;
+	WARN_ON(*write_count < 0);
 }
 
 static int has_wrprotected_page(struct kvm *kvm, gfn_t gfn)
@@ -426,6 +444,21 @@ static int has_wrprotected_page(struct kvm *kvm, gfn_t gfn)
 	return 1;
 }
 
+static int has_wrprotected_largepage(struct kvm *kvm, gfn_t gfn)
+{
+	struct kvm_memory_slot *slot;
+	int *hugepage_idx;
+
+	gfn = unalias_gfn(kvm, gfn);
+	slot = gfn_to_memslot_unaliased(kvm, gfn);
+	if (slot) {
+		hugepage_idx = slot_hugepage_idx(gfn, slot);
+		return *hugepage_idx;
+	}
+
+	return 1;
+}
+
 static enum kvm_page_size host_page_size(struct kvm *kvm, gfn_t gfn)
 {
 	struct vm_area_struct *vma;
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 095ebb6..2f05d48 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -103,7 +103,7 @@ struct kvm_memory_slot {
 	struct {
 		unsigned long rmap_pde;
 		int write_count;
-	} *lpage_info;
+	} *lpage_info, *hpage_info;
 	unsigned long userspace_addr;
 	int user_alloc;
 };
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 8aa3b95..c4842f4 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -1001,10 +1001,14 @@ static void kvm_free_physmem_slot(struct kvm_memory_slot *free,
 	if (!dont || free->lpage_info != dont->lpage_info)
 		vfree(free->lpage_info);
 
+	if (!dont || free->hpage_info != dont->hpage_info)
+		vfree(free->hpage_info);
+
 	free->npages = 0;
 	free->dirty_bitmap = NULL;
 	free->rmap = NULL;
 	free->lpage_info = NULL;
+	free->hpage_info = NULL;
 }
 
 void kvm_free_physmem(struct kvm *kvm)
@@ -1170,6 +1174,28 @@ int __kvm_set_memory_region(struct kvm *kvm,
 			new.lpage_info[largepages-1].write_count = 1;
 	}
 
+#ifdef KVM_PAGES_PER_LHPAGE
+	if (npages && !new.hpage_info) {
+		int hugepages = npages / KVM_PAGES_PER_LHPAGE;
+		if (npages % KVM_PAGES_PER_LHPAGE)
+			hugepages++;
+		if (base_gfn % KVM_PAGES_PER_LHPAGE)
+			hugepages++;
+
+		new.hpage_info = vmalloc(hugepages * sizeof(*new.hpage_info));
+
+		if (!new.hpage_info)
+			goto out_free;
+
+		memset(new.hpage_info, 0, hugepages * sizeof(*new.hpage_info));
+
+		if (base_gfn % KVM_PAGES_PER_LHPAGE)
+			new.hpage_info[0].write_count = 1;
+		if ((base_gfn+npages) % KVM_PAGES_PER_LHPAGE)
+			new.hpage_info[hugepages-1].write_count = 1;
+	}
+#endif
+
 	/* Allocate page dirty bitmap if needed */
 	if ((new.flags & KVM_MEM_LOG_DIRTY_PAGES) && !new.dirty_bitmap) {
 		unsigned dirty_bytes = ALIGN(npages, BITS_PER_LONG) / 8;
-- 
1.5.6.4


