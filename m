Return-Path: <linux-kernel-owner+w=401wt.eu-S1753139AbXLZLIc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753139AbXLZLIc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Dec 2007 06:08:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752490AbXLZLGW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Dec 2007 06:06:22 -0500
Received: from il.qumranet.com ([82.166.9.18]:50470 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751625AbXLZLGE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Dec 2007 06:06:04 -0500
From: Avi Kivity <avi@qumranet.com>
To: linux-kernel@vger.kernel.org, kvm-devel@lists.sourceforge.net
Cc: Izik Eidus <izike@qumranet.com>
Subject: [PATCH 09/55] KVM: Add kernel-internal memory slots
Date: Wed, 26 Dec 2007 13:05:14 +0200
Message-Id: <1198667160-22953-10-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.3.7
In-Reply-To: <1198667160-22953-1-git-send-email-avi@qumranet.com>
References: <1198667160-22953-1-git-send-email-avi@qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Izik Eidus <izike@qumranet.com>

Reserve a few memory slots for kernel internal use.  This is good for case
you have to register memory region and you want to be sure it was not
registered from userspace, and for case you want to register a memory region
that won't be seen from userspace.

Signed-off-by: Izik Eidus <izike@qumranet.com>
Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 drivers/kvm/kvm.h      |    6 +++++-
 drivers/kvm/kvm_main.c |   22 +++++++++++++++++++++-
 2 files changed, 26 insertions(+), 2 deletions(-)

diff --git a/drivers/kvm/kvm.h b/drivers/kvm/kvm.h
index f3dda08..82c3b13 100644
--- a/drivers/kvm/kvm.h
+++ b/drivers/kvm/kvm.h
@@ -41,6 +41,8 @@
 #define KVM_MAX_VCPUS 4
 #define KVM_ALIAS_SLOTS 4
 #define KVM_MEMORY_SLOTS 8
+/* memory slots that does not exposed to userspace */
+#define KVM_PRIVATE_MEM_SLOTS 4
 #define KVM_PERMILLE_MMU_PAGES 20
 #define KVM_MIN_ALLOC_MMU_PAGES 64
 #define KVM_NUM_MMU_PAGES 1024
@@ -361,7 +363,8 @@ struct kvm {
 	int naliases;
 	struct kvm_mem_alias aliases[KVM_ALIAS_SLOTS];
 	int nmemslots;
-	struct kvm_memory_slot memslots[KVM_MEMORY_SLOTS];
+	struct kvm_memory_slot memslots[KVM_MEMORY_SLOTS +
+					KVM_PRIVATE_MEM_SLOTS];
 	/*
 	 * Hash table of struct kvm_mmu_page.
 	 */
@@ -529,6 +532,7 @@ int kvm_write_guest(struct kvm *kvm, gpa_t gpa, const void *data,
 int kvm_clear_guest_page(struct kvm *kvm, gfn_t gfn, int offset, int len);
 int kvm_clear_guest(struct kvm *kvm, gpa_t gpa, unsigned long len);
 struct kvm_memory_slot *gfn_to_memslot(struct kvm *kvm, gfn_t gfn);
+int kvm_is_visible_gfn(struct kvm *kvm, gfn_t gfn);
 void mark_page_dirty(struct kvm *kvm, gfn_t gfn);
 
 enum emulation_result {
diff --git a/drivers/kvm/kvm_main.c b/drivers/kvm/kvm_main.c
index 16176a2..bc8334b 100644
--- a/drivers/kvm/kvm_main.c
+++ b/drivers/kvm/kvm_main.c
@@ -660,7 +660,7 @@ int kvm_set_memory_region(struct kvm *kvm,
 		goto out;
 	if (mem->guest_phys_addr & (PAGE_SIZE - 1))
 		goto out;
-	if (mem->slot >= KVM_MEMORY_SLOTS)
+	if (mem->slot >= KVM_MEMORY_SLOTS + KVM_PRIVATE_MEM_SLOTS)
 		goto out;
 	if (mem->guest_phys_addr + mem->memory_size < mem->guest_phys_addr)
 		goto out;
@@ -797,6 +797,8 @@ static int kvm_vm_ioctl_set_memory_region(struct kvm *kvm,
 					  kvm_userspace_memory_region *mem,
 					  int user_alloc)
 {
+	if (mem->slot >= KVM_MEMORY_SLOTS)
+		return -EINVAL;
 	return kvm_set_memory_region(kvm, mem, user_alloc);
 }
 
@@ -1010,6 +1012,22 @@ struct kvm_memory_slot *gfn_to_memslot(struct kvm *kvm, gfn_t gfn)
 	return __gfn_to_memslot(kvm, gfn);
 }
 
+int kvm_is_visible_gfn(struct kvm *kvm, gfn_t gfn)
+{
+	int i;
+
+	gfn = unalias_gfn(kvm, gfn);
+	for (i = 0; i < KVM_MEMORY_SLOTS; ++i) {
+		struct kvm_memory_slot *memslot = &kvm->memslots[i];
+
+		if (gfn >= memslot->base_gfn
+		    && gfn < memslot->base_gfn + memslot->npages)
+			return 1;
+	}
+	return 0;
+}
+EXPORT_SYMBOL_GPL(kvm_is_visible_gfn);
+
 struct page *gfn_to_page(struct kvm *kvm, gfn_t gfn)
 {
 	struct kvm_memory_slot *slot;
@@ -3087,6 +3105,8 @@ static struct page *kvm_vm_nopage(struct vm_area_struct *vma,
 	struct page *page;
 
 	pgoff = ((address - vma->vm_start) >> PAGE_SHIFT) + vma->vm_pgoff;
+	if (!kvm_is_visible_gfn(kvm, pgoff))
+		return NOPAGE_SIGBUS;
 	page = gfn_to_page(kvm, pgoff);
 	if (is_error_page(page)) {
 		kvm_release_page(page);
-- 
1.5.3.7

