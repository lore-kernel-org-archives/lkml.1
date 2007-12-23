Return-Path: <linux-kernel-owner+w=401wt.eu-S1760160AbXLWPGo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760160AbXLWPGo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Dec 2007 10:06:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755995AbXLWOwb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Dec 2007 09:52:31 -0500
Received: from il.qumranet.com ([82.166.9.18]:35928 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755206AbXLWOvs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Dec 2007 09:51:48 -0500
From: Avi Kivity <avi@qumranet.com>
To: linux-kernel@vger.kernel.org, kvm-devel@lists.sourceforge.net
Cc: Anthony Liguori <aliguori@us.ibm.com>
Subject: [PATCH 50/50] KVM: Allocate userspace memory for older userspace
Date: Sun, 23 Dec 2007 16:51:35 +0200
Message-Id: <1198421495-31481-51-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.3.7
In-Reply-To: <1198421495-31481-1-git-send-email-avi@qumranet.com>
References: <1198421495-31481-1-git-send-email-avi@qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Anthony Liguori <aliguori@us.ibm.com>

Allocate a userspace buffer for older userspaces.  Also eliminate phys_mem
buffer.  The memset() in kvmctl really kills initial memory usage but swapping
works even with old userspaces.

A side effect is that maximum guest side is reduced for older userspace on
i386.

Signed-off-by: Anthony Liguori <aliguori@us.ibm.com>
Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 drivers/kvm/kvm.h      |    2 -
 drivers/kvm/kvm_main.c |   83 +++++++++++++++++------------------------------
 2 files changed, 30 insertions(+), 55 deletions(-)

diff --git a/drivers/kvm/kvm.h b/drivers/kvm/kvm.h
index e8a21e8..eb006ed 100644
--- a/drivers/kvm/kvm.h
+++ b/drivers/kvm/kvm.h
@@ -406,10 +406,8 @@ struct kvm_memory_slot {
 	gfn_t base_gfn;
 	unsigned long npages;
 	unsigned long flags;
-	struct page **phys_mem;
 	unsigned long *rmap;
 	unsigned long *dirty_bitmap;
-	int user_alloc; /* user allocated memory */
 	unsigned long userspace_addr;
 };
 
diff --git a/drivers/kvm/kvm_main.c b/drivers/kvm/kvm_main.c
index 1c64047..3aec716 100644
--- a/drivers/kvm/kvm_main.c
+++ b/drivers/kvm/kvm_main.c
@@ -42,6 +42,7 @@
 #include <linux/profile.h>
 #include <linux/kvm_para.h>
 #include <linux/pagemap.h>
+#include <linux/mman.h>
 
 #include <asm/processor.h>
 #include <asm/msr.h>
@@ -300,36 +301,21 @@ static struct kvm *kvm_create_vm(void)
 	return kvm;
 }
 
-static void kvm_free_kernel_physmem(struct kvm_memory_slot *free)
-{
-	int i;
-
-	for (i = 0; i < free->npages; ++i)
-		if (free->phys_mem[i])
-			__free_page(free->phys_mem[i]);
-}
-
 /*
  * Free any memory in @free but not in @dont.
  */
 static void kvm_free_physmem_slot(struct kvm_memory_slot *free,
 				  struct kvm_memory_slot *dont)
 {
-	if (!dont || free->phys_mem != dont->phys_mem)
-		if (free->phys_mem) {
-			if (!free->user_alloc)
-				kvm_free_kernel_physmem(free);
-			vfree(free->phys_mem);
-		}
 	if (!dont || free->rmap != dont->rmap)
 		vfree(free->rmap);
 
 	if (!dont || free->dirty_bitmap != dont->dirty_bitmap)
 		vfree(free->dirty_bitmap);
 
-	free->phys_mem = NULL;
 	free->npages = 0;
 	free->dirty_bitmap = NULL;
+	free->rmap = NULL;
 }
 
 static void kvm_free_physmem(struct kvm *kvm)
@@ -712,10 +698,6 @@ static int kvm_vm_ioctl_set_memory_region(struct kvm *kvm,
 			goto out_unlock;
 	}
 
-	/* Deallocate if slot is being removed */
-	if (!npages)
-		new.phys_mem = NULL;
-
 	/* Free page dirty bitmap if unneeded */
 	if (!(new.flags & KVM_MEM_LOG_DIRTY_PAGES))
 		new.dirty_bitmap = NULL;
@@ -723,29 +705,27 @@ static int kvm_vm_ioctl_set_memory_region(struct kvm *kvm,
 	r = -ENOMEM;
 
 	/* Allocate if a slot is being created */
-	if (npages && !new.phys_mem) {
-		new.phys_mem = vmalloc(npages * sizeof(struct page *));
-
-		if (!new.phys_mem)
-			goto out_unlock;
-
+	if (npages && !new.rmap) {
 		new.rmap = vmalloc(npages * sizeof(struct page *));
 
 		if (!new.rmap)
 			goto out_unlock;
 
-		memset(new.phys_mem, 0, npages * sizeof(struct page *));
 		memset(new.rmap, 0, npages * sizeof(*new.rmap));
-		if (user_alloc) {
-			new.user_alloc = 1;
+
+		if (user_alloc)
 			new.userspace_addr = mem->userspace_addr;
-		} else {
-			for (i = 0; i < npages; ++i) {
-				new.phys_mem[i] = alloc_page(GFP_HIGHUSER
-							     | __GFP_ZERO);
-				if (!new.phys_mem[i])
-					goto out_unlock;
-			}
+		else {
+			down_write(&current->mm->mmap_sem);
+			new.userspace_addr = do_mmap(NULL, 0,
+						     npages * PAGE_SIZE,
+						     PROT_READ | PROT_WRITE,
+						     MAP_SHARED | MAP_ANONYMOUS,
+						     0);
+			up_write(&current->mm->mmap_sem);
+
+			if (IS_ERR((void *)new.userspace_addr))
+				goto out_unlock;
 		}
 	}
 
@@ -1010,6 +990,8 @@ struct kvm_memory_slot *gfn_to_memslot(struct kvm *kvm, gfn_t gfn)
 struct page *gfn_to_page(struct kvm *kvm, gfn_t gfn)
 {
 	struct kvm_memory_slot *slot;
+	struct page *page[1];
+	int npages;
 
 	gfn = unalias_gfn(kvm, gfn);
 	slot = __gfn_to_memslot(kvm, gfn);
@@ -1017,24 +999,19 @@ struct page *gfn_to_page(struct kvm *kvm, gfn_t gfn)
 		get_page(bad_page);
 		return bad_page;
 	}
-	if (slot->user_alloc) {
-		struct page *page[1];
-		int npages;
-
-		down_read(&current->mm->mmap_sem);
-		npages = get_user_pages(current, current->mm,
-					slot->userspace_addr
-					+ (gfn - slot->base_gfn) * PAGE_SIZE, 1,
-					1, 0, page, NULL);
-		up_read(&current->mm->mmap_sem);
-		if (npages != 1) {
-			get_page(bad_page);
-			return bad_page;
-		}
-		return page[0];
+
+	down_read(&current->mm->mmap_sem);
+	npages = get_user_pages(current, current->mm,
+				slot->userspace_addr
+				+ (gfn - slot->base_gfn) * PAGE_SIZE, 1,
+				1, 0, page, NULL);
+	up_read(&current->mm->mmap_sem);
+	if (npages != 1) {
+		get_page(bad_page);
+		return bad_page;
 	}
-	get_page(slot->phys_mem[gfn - slot->base_gfn]);
-	return slot->phys_mem[gfn - slot->base_gfn];
+
+	return page[0];
 }
 EXPORT_SYMBOL_GPL(gfn_to_page);
 
-- 
1.5.3.7

