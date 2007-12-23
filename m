Return-Path: <linux-kernel-owner+w=401wt.eu-S1757683AbXLWO73@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757683AbXLWO73 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Dec 2007 09:59:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756027AbXLWOwG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Dec 2007 09:52:06 -0500
Received: from il.qumranet.com ([82.166.9.18]:35908 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753215AbXLWOvo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Dec 2007 09:51:44 -0500
From: Avi Kivity <avi@qumranet.com>
To: linux-kernel@vger.kernel.org, kvm-devel@lists.sourceforge.net
Cc: Izik Eidus <izike@qumranet.com>
Subject: [PATCH 27/50] KVM: Support assigning userspace memory to the guest
Date: Sun, 23 Dec 2007 16:51:12 +0200
Message-Id: <1198421495-31481-28-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.3.7
In-Reply-To: <1198421495-31481-1-git-send-email-avi@qumranet.com>
References: <1198421495-31481-1-git-send-email-avi@qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Izik Eidus <izike@qumranet.com>

Instead of having the kernel allocate memory to the guest, let userspace
allocate it and pass the address to the kernel.

This is required for s390 support, but also enables features like memory
sharing and using hugetlbfs backed memory.

Signed-off-by: Izik Eidus <izike@qumranet.com>
Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 drivers/kvm/kvm.h      |    1 +
 drivers/kvm/kvm_main.c |   81 +++++++++++++++++++++++++++++++++++++++++------
 include/linux/kvm.h    |   12 +++++++
 3 files changed, 83 insertions(+), 11 deletions(-)

diff --git a/drivers/kvm/kvm.h b/drivers/kvm/kvm.h
index ec5b498..3eaed4d 100644
--- a/drivers/kvm/kvm.h
+++ b/drivers/kvm/kvm.h
@@ -408,6 +408,7 @@ struct kvm_memory_slot {
 	struct page **phys_mem;
 	unsigned long *rmap;
 	unsigned long *dirty_bitmap;
+	int user_alloc; /* user allocated memory */
 };
 
 struct kvm {
diff --git a/drivers/kvm/kvm_main.c b/drivers/kvm/kvm_main.c
index 47ffefb..9633fd3 100644
--- a/drivers/kvm/kvm_main.c
+++ b/drivers/kvm/kvm_main.c
@@ -40,6 +40,7 @@
 #include <linux/anon_inodes.h>
 #include <linux/profile.h>
 #include <linux/kvm_para.h>
+#include <linux/pagemap.h>
 
 #include <asm/processor.h>
 #include <asm/msr.h>
@@ -300,19 +301,40 @@ static struct kvm *kvm_create_vm(void)
 	return kvm;
 }
 
+static void kvm_free_userspace_physmem(struct kvm_memory_slot *free)
+{
+	int i;
+
+	for (i = 0; i < free->npages; ++i) {
+		if (free->phys_mem[i]) {
+			if (!PageReserved(free->phys_mem[i]))
+				SetPageDirty(free->phys_mem[i]);
+			page_cache_release(free->phys_mem[i]);
+		}
+	}
+}
+
+static void kvm_free_kernel_physmem(struct kvm_memory_slot *free)
+{
+	int i;
+
+	for (i = 0; i < free->npages; ++i)
+		if (free->phys_mem[i])
+			__free_page(free->phys_mem[i]);
+}
+
 /*
  * Free any memory in @free but not in @dont.
  */
 static void kvm_free_physmem_slot(struct kvm_memory_slot *free,
 				  struct kvm_memory_slot *dont)
 {
-	int i;
-
 	if (!dont || free->phys_mem != dont->phys_mem)
 		if (free->phys_mem) {
-			for (i = 0; i < free->npages; ++i)
-				if (free->phys_mem[i])
-					__free_page(free->phys_mem[i]);
+			if (free->user_alloc)
+				kvm_free_userspace_physmem(free);
+			else
+				kvm_free_kernel_physmem(free);
 			vfree(free->phys_mem);
 		}
 	if (!dont || free->rmap != dont->rmap)
@@ -652,7 +674,9 @@ EXPORT_SYMBOL_GPL(fx_init);
  * Discontiguous memory is allowed, mostly for framebuffers.
  */
 static int kvm_vm_ioctl_set_memory_region(struct kvm *kvm,
-					  struct kvm_memory_region *mem)
+					  struct
+					  kvm_userspace_memory_region *mem,
+					  int user_alloc)
 {
 	int r;
 	gfn_t base_gfn;
@@ -728,11 +752,27 @@ static int kvm_vm_ioctl_set_memory_region(struct kvm *kvm,
 
 		memset(new.phys_mem, 0, npages * sizeof(struct page *));
 		memset(new.rmap, 0, npages * sizeof(*new.rmap));
-		for (i = 0; i < npages; ++i) {
-			new.phys_mem[i] = alloc_page(GFP_HIGHUSER
-						     | __GFP_ZERO);
-			if (!new.phys_mem[i])
+		if (user_alloc) {
+			unsigned long pages_num;
+
+			new.user_alloc = 1;
+			down_read(&current->mm->mmap_sem);
+
+			pages_num = get_user_pages(current, current->mm,
+						   mem->userspace_addr,
+						   npages, 1, 0, new.phys_mem,
+						   NULL);
+
+			up_read(&current->mm->mmap_sem);
+			if (pages_num != npages)
 				goto out_unlock;
+		} else {
+			for (i = 0; i < npages; ++i) {
+				new.phys_mem[i] = alloc_page(GFP_HIGHUSER
+							     | __GFP_ZERO);
+				if (!new.phys_mem[i])
+					goto out_unlock;
+			}
 		}
 	}
 
@@ -3108,11 +3148,29 @@ static long kvm_vm_ioctl(struct file *filp,
 		break;
 	case KVM_SET_MEMORY_REGION: {
 		struct kvm_memory_region kvm_mem;
+		struct kvm_userspace_memory_region kvm_userspace_mem;
 
 		r = -EFAULT;
 		if (copy_from_user(&kvm_mem, argp, sizeof kvm_mem))
 			goto out;
-		r = kvm_vm_ioctl_set_memory_region(kvm, &kvm_mem);
+		kvm_userspace_mem.slot = kvm_mem.slot;
+		kvm_userspace_mem.flags = kvm_mem.flags;
+		kvm_userspace_mem.guest_phys_addr = kvm_mem.guest_phys_addr;
+		kvm_userspace_mem.memory_size = kvm_mem.memory_size;
+		r = kvm_vm_ioctl_set_memory_region(kvm, &kvm_userspace_mem, 0);
+		if (r)
+			goto out;
+		break;
+	}
+	case KVM_SET_USER_MEMORY_REGION: {
+		struct kvm_userspace_memory_region kvm_userspace_mem;
+
+		r = -EFAULT;
+		if (copy_from_user(&kvm_userspace_mem, argp,
+						sizeof kvm_userspace_mem))
+			goto out;
+
+		r = kvm_vm_ioctl_set_memory_region(kvm, &kvm_userspace_mem, 1);
 		if (r)
 			goto out;
 		break;
@@ -3332,6 +3390,7 @@ static long kvm_dev_ioctl(struct file *filp,
 		case KVM_CAP_IRQCHIP:
 		case KVM_CAP_HLT:
 		case KVM_CAP_MMU_SHADOW_CACHE_CONTROL:
+		case KVM_CAP_USER_MEMORY:
 			r = 1;
 			break;
 		default:
diff --git a/include/linux/kvm.h b/include/linux/kvm.h
index d2fd973..971f465 100644
--- a/include/linux/kvm.h
+++ b/include/linux/kvm.h
@@ -23,6 +23,15 @@ struct kvm_memory_region {
 	__u64 memory_size; /* bytes */
 };
 
+/* for KVM_SET_USER_MEMORY_REGION */
+struct kvm_userspace_memory_region {
+	__u32 slot;
+	__u32 flags;
+	__u64 guest_phys_addr;
+	__u64 memory_size; /* bytes */
+	__u64 userspace_addr; /* start of the userspace allocated memory */
+};
+
 /* for kvm_memory_region::flags */
 #define KVM_MEM_LOG_DIRTY_PAGES  1UL
 
@@ -348,6 +357,7 @@ struct kvm_signal_mask {
 #define KVM_CAP_IRQCHIP	  0
 #define KVM_CAP_HLT	  1
 #define KVM_CAP_MMU_SHADOW_CACHE_CONTROL 2
+#define KVM_CAP_USER_MEMORY 3
 
 /*
  * ioctls for VM fds
@@ -355,6 +365,8 @@ struct kvm_signal_mask {
 #define KVM_SET_MEMORY_REGION     _IOW(KVMIO, 0x40, struct kvm_memory_region)
 #define KVM_SET_NR_MMU_PAGES      _IO(KVMIO, 0x44)
 #define KVM_GET_NR_MMU_PAGES      _IO(KVMIO, 0x45)
+#define KVM_SET_USER_MEMORY_REGION _IOW(KVMIO, 0x46,\
+					struct kvm_userspace_memory_region)
 /*
  * KVM_CREATE_VCPU receives as a parameter the vcpu slot, and returns
  * a vcpu fd.
-- 
1.5.3.7

