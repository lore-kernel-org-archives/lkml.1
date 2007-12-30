Return-Path: <linux-kernel-owner+w=401wt.eu-S1759515AbXL3H1x@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759515AbXL3H1x (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Dec 2007 02:27:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753816AbXL3HLk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Dec 2007 02:11:40 -0500
Received: from il.qumranet.com ([82.166.9.18]:59492 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755467AbXL3HKt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Dec 2007 02:10:49 -0500
From: Avi Kivity <avi@qumranet.com>
To: linux-kernel@vger.kernel.org, kvm-devel@lists.sourceforge.net
Cc: Zhang Xiantao <xiantao.zhang@intel.com>
Subject: [PATCH 38/52] KVM: Portability:  Split kvm_set_memory_region() to have an arch callout
Date: Sun, 30 Dec 2007 09:10:24 +0200
Message-Id: <1198998638-22713-39-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.3.7
In-Reply-To: <1198998638-22713-1-git-send-email-avi@qumranet.com>
References: <1198998638-22713-1-git-send-email-avi@qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Zhang Xiantao <xiantao.zhang@intel.com>

Moving !user_alloc case to kvm_arch to avoid unnecessary
code logic in non-x86 platform.

Signed-off-by: Zhang Xiantao <xiantao.zhang@intel.com>
Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 drivers/kvm/kvm.h      |    4 +++
 drivers/kvm/kvm_main.c |   38 ++++-------------------------------
 drivers/kvm/x86.c      |   51 ++++++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 60 insertions(+), 33 deletions(-)

diff --git a/drivers/kvm/kvm.h b/drivers/kvm/kvm.h
index c2acd74..49094a2 100644
--- a/drivers/kvm/kvm.h
+++ b/drivers/kvm/kvm.h
@@ -391,6 +391,10 @@ int kvm_set_memory_region(struct kvm *kvm,
 int __kvm_set_memory_region(struct kvm *kvm,
 			    struct kvm_userspace_memory_region *mem,
 			    int user_alloc);
+int kvm_arch_set_memory_region(struct kvm *kvm,
+				struct kvm_userspace_memory_region *mem,
+				struct kvm_memory_slot old,
+				int user_alloc);
 gfn_t unalias_gfn(struct kvm *kvm, gfn_t gfn);
 struct page *gfn_to_page(struct kvm *kvm, gfn_t gfn);
 void kvm_release_page_clean(struct page *page);
diff --git a/drivers/kvm/kvm_main.c b/drivers/kvm/kvm_main.c
index 6a702e1..5f3ef54 100644
--- a/drivers/kvm/kvm_main.c
+++ b/drivers/kvm/kvm_main.c
@@ -291,33 +291,7 @@ int __kvm_set_memory_region(struct kvm *kvm,
 		memset(new.rmap, 0, npages * sizeof(*new.rmap));
 
 		new.user_alloc = user_alloc;
-		if (user_alloc)
-			new.userspace_addr = mem->userspace_addr;
-		else {
-			down_write(&current->mm->mmap_sem);
-			new.userspace_addr = do_mmap(NULL, 0,
-						     npages * PAGE_SIZE,
-						     PROT_READ | PROT_WRITE,
-						     MAP_SHARED | MAP_ANONYMOUS,
-						     0);
-			up_write(&current->mm->mmap_sem);
-
-			if (IS_ERR((void *)new.userspace_addr))
-				goto out_free;
-		}
-	} else {
-		if (!old.user_alloc && old.rmap) {
-			int ret;
-
-			down_write(&current->mm->mmap_sem);
-			ret = do_munmap(current->mm, old.userspace_addr,
-					old.npages * PAGE_SIZE);
-			up_write(&current->mm->mmap_sem);
-			if (ret < 0)
-				printk(KERN_WARNING
-				       "kvm_vm_ioctl_set_memory_region: "
-				       "failed to munmap memory\n");
-		}
+		new.userspace_addr = mem->userspace_addr;
 	}
 
 	/* Allocate page dirty bitmap if needed */
@@ -335,14 +309,12 @@ int __kvm_set_memory_region(struct kvm *kvm,
 
 	*memslot = new;
 
-	if (!kvm->n_requested_mmu_pages) {
-		unsigned int nr_mmu_pages = kvm_mmu_calculate_mmu_pages(kvm);
-		kvm_mmu_change_mmu_pages(kvm, nr_mmu_pages);
+	r = kvm_arch_set_memory_region(kvm, mem, old, user_alloc);
+	if (r) {
+		*memslot = old;
+		goto out_free;
 	}
 
-	kvm_mmu_slot_remove_write_access(kvm, mem->slot);
-	kvm_flush_remote_tlbs(kvm);
-
 	kvm_free_physmem_slot(&old, &new);
 	return 0;
 
diff --git a/drivers/kvm/x86.c b/drivers/kvm/x86.c
index 5a54e32..6abb2ed 100644
--- a/drivers/kvm/x86.c
+++ b/drivers/kvm/x86.c
@@ -24,6 +24,7 @@
 #include <linux/fs.h>
 #include <linux/vmalloc.h>
 #include <linux/module.h>
+#include <linux/mman.h>
 
 #include <asm/uaccess.h>
 #include <asm/msr.h>
@@ -2637,3 +2638,53 @@ void kvm_arch_destroy_vm(struct kvm *kvm)
 	kvm_free_physmem(kvm);
 	kfree(kvm);
 }
+
+int kvm_arch_set_memory_region(struct kvm *kvm,
+				struct kvm_userspace_memory_region *mem,
+				struct kvm_memory_slot old,
+				int user_alloc)
+{
+	int npages = mem->memory_size >> PAGE_SHIFT;
+	struct kvm_memory_slot *memslot = &kvm->memslots[mem->slot];
+
+	/*To keep backward compatibility with older userspace,
+	 *x86 needs to hanlde !user_alloc case.
+	 */
+	if (!user_alloc) {
+		if (npages && !old.rmap) {
+			down_write(&current->mm->mmap_sem);
+			memslot->userspace_addr = do_mmap(NULL, 0,
+						     npages * PAGE_SIZE,
+						     PROT_READ | PROT_WRITE,
+						     MAP_SHARED | MAP_ANONYMOUS,
+						     0);
+			up_write(&current->mm->mmap_sem);
+
+			if (IS_ERR((void *)memslot->userspace_addr))
+				return PTR_ERR((void *)memslot->userspace_addr);
+		} else {
+			if (!old.user_alloc && old.rmap) {
+				int ret;
+
+				down_write(&current->mm->mmap_sem);
+				ret = do_munmap(current->mm, old.userspace_addr,
+						old.npages * PAGE_SIZE);
+				up_write(&current->mm->mmap_sem);
+				if (ret < 0)
+					printk(KERN_WARNING
+				       "kvm_vm_ioctl_set_memory_region: "
+				       "failed to munmap memory\n");
+			}
+		}
+	}
+
+	if (!kvm->n_requested_mmu_pages) {
+		unsigned int nr_mmu_pages = kvm_mmu_calculate_mmu_pages(kvm);
+		kvm_mmu_change_mmu_pages(kvm, nr_mmu_pages);
+	}
+
+	kvm_mmu_slot_remove_write_access(kvm, mem->slot);
+	kvm_flush_remote_tlbs(kvm);
+
+	return 0;
+}
-- 
1.5.3.7

