Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932875Ab0BPKf7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Feb 2010 05:35:59 -0500
Received: from mx1.redhat.com ([209.132.183.28]:37713 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932830Ab0BPKfl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Feb 2010 05:35:41 -0500
From: Avi Kivity <avi@redhat.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 36/38] KVM: Introduce kvm_host_page_size
Date: Tue, 16 Feb 2010 12:35:34 +0200
Message-Id: <1266316536-28936-37-git-send-email-avi@redhat.com>
In-Reply-To: <1266316536-28936-1-git-send-email-avi@redhat.com>
References: <1266316536-28936-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Joerg Roedel <joerg.roedel@amd.com>

This patch introduces a generic function to find out the
host page size for a given gfn. This function is needed by
the kvm iommu code. This patch also simplifies the x86
host_mapping_level function.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
Signed-off-by: Avi Kivity <avi@redhat.com>
---
 arch/x86/kvm/mmu.c       |   18 ++----------------
 include/linux/kvm_host.h |    1 +
 virt/kvm/kvm_main.c      |   25 +++++++++++++++++++++++++
 3 files changed, 28 insertions(+), 16 deletions(-)

diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index dc4d954..913ef4b 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -468,24 +468,10 @@ static int has_wrprotected_page(struct kvm *kvm,
 
 static int host_mapping_level(struct kvm *kvm, gfn_t gfn)
 {
-	unsigned long page_size = PAGE_SIZE;
-	struct vm_area_struct *vma;
-	unsigned long addr;
+	unsigned long page_size;
 	int i, ret = 0;
 
-	addr = gfn_to_hva(kvm, gfn);
-	if (kvm_is_error_hva(addr))
-		return PT_PAGE_TABLE_LEVEL;
-
-	down_read(&current->mm->mmap_sem);
-	vma = find_vma(current->mm, addr);
-	if (!vma)
-		goto out;
-
-	page_size = vma_kernel_pagesize(vma);
-
-out:
-	up_read(&current->mm->mmap_sem);
+	page_size = kvm_host_page_size(kvm, gfn);
 
 	for (i = PT_PAGE_TABLE_LEVEL;
 	     i < (PT_PAGE_TABLE_LEVEL + KVM_NR_PAGE_SIZES); ++i) {
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 665c370..3145b28 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -300,6 +300,7 @@ int kvm_clear_guest_page(struct kvm *kvm, gfn_t gfn, int offset, int len);
 int kvm_clear_guest(struct kvm *kvm, gpa_t gpa, unsigned long len);
 struct kvm_memory_slot *gfn_to_memslot(struct kvm *kvm, gfn_t gfn);
 int kvm_is_visible_gfn(struct kvm *kvm, gfn_t gfn);
+unsigned long kvm_host_page_size(struct kvm *kvm, gfn_t gfn);
 void mark_page_dirty(struct kvm *kvm, gfn_t gfn);
 
 void kvm_vcpu_block(struct kvm_vcpu *vcpu);
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 2b0974a..0a360c2 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -45,6 +45,7 @@
 #include <linux/spinlock.h>
 #include <linux/compat.h>
 #include <linux/srcu.h>
+#include <linux/hugetlb.h>
 
 #include <asm/processor.h>
 #include <asm/io.h>
@@ -867,6 +868,30 @@ int kvm_is_visible_gfn(struct kvm *kvm, gfn_t gfn)
 }
 EXPORT_SYMBOL_GPL(kvm_is_visible_gfn);
 
+unsigned long kvm_host_page_size(struct kvm *kvm, gfn_t gfn)
+{
+	struct vm_area_struct *vma;
+	unsigned long addr, size;
+
+	size = PAGE_SIZE;
+
+	addr = gfn_to_hva(kvm, gfn);
+	if (kvm_is_error_hva(addr))
+		return PAGE_SIZE;
+
+	down_read(&current->mm->mmap_sem);
+	vma = find_vma(current->mm, addr);
+	if (!vma)
+		goto out;
+
+	size = vma_kernel_pagesize(vma);
+
+out:
+	up_read(&current->mm->mmap_sem);
+
+	return size;
+}
+
 int memslot_id(struct kvm *kvm, gfn_t gfn)
 {
 	int i;
-- 
1.6.5.3

