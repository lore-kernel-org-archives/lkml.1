Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756084Ab0BJR0G (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Feb 2010 12:26:06 -0500
Received: from mx1.redhat.com ([209.132.183.28]:26026 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755748Ab0BJRXO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Feb 2010 12:23:14 -0500
From: Avi Kivity <avi@redhat.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 28/40] KVM: split kvm_arch_set_memory_region into prepare and commit
Date: Wed, 10 Feb 2010 19:22:57 +0200
Message-Id: <1265822589-11155-29-git-send-email-avi@redhat.com>
In-Reply-To: <1265822589-11155-1-git-send-email-avi@redhat.com>
References: <1265822589-11155-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Marcelo Tosatti <mtosatti@redhat.com>

Required for SRCU convertion later.

Signed-off-by: Marcelo Tosatti <mtosatti@redhat.com>
---
 arch/ia64/kvm/kvm-ia64.c   |   16 ++++++++++---
 arch/powerpc/kvm/powerpc.c |   18 ++++++++++++---
 arch/s390/kvm/kvm-s390.c   |   25 +++++++++++++-------
 arch/x86/kvm/x86.c         |   51 +++++++++++++++++++++++++-------------------
 include/linux/kvm_host.h   |    7 +++++-
 virt/kvm/kvm_main.c        |   12 ++++------
 6 files changed, 82 insertions(+), 47 deletions(-)

diff --git a/arch/ia64/kvm/kvm-ia64.c b/arch/ia64/kvm/kvm-ia64.c
index 1ca1dbf..0757c70 100644
--- a/arch/ia64/kvm/kvm-ia64.c
+++ b/arch/ia64/kvm/kvm-ia64.c
@@ -1578,15 +1578,15 @@ out:
 	return r;
 }
 
-int kvm_arch_set_memory_region(struct kvm *kvm,
-		struct kvm_userspace_memory_region *mem,
+int kvm_arch_prepare_memory_region(struct kvm *kvm,
+		struct kvm_memory_slot *memslot,
 		struct kvm_memory_slot old,
+		struct kvm_userspace_memory_region *mem,
 		int user_alloc)
 {
 	unsigned long i;
 	unsigned long pfn;
-	int npages = mem->memory_size >> PAGE_SHIFT;
-	struct kvm_memory_slot *memslot = &kvm->memslots[mem->slot];
+	int npages = memslot->npages;
 	unsigned long base_gfn = memslot->base_gfn;
 
 	if (base_gfn + npages > (KVM_MAX_MEM_SIZE >> PAGE_SHIFT))
@@ -1610,6 +1610,14 @@ int kvm_arch_set_memory_region(struct kvm *kvm,
 	return 0;
 }
 
+void kvm_arch_commit_memory_region(struct kvm *kvm,
+		struct kvm_userspace_memory_region *mem,
+		struct kvm_memory_slot old,
+		int user_alloc)
+{
+	return;
+}
+
 void kvm_arch_flush_shadow(struct kvm *kvm)
 {
 	kvm_flush_remote_tlbs(kvm);
diff --git a/arch/powerpc/kvm/powerpc.c b/arch/powerpc/kvm/powerpc.c
index f06cf93..4633e78 100644
--- a/arch/powerpc/kvm/powerpc.c
+++ b/arch/powerpc/kvm/powerpc.c
@@ -165,14 +165,24 @@ long kvm_arch_dev_ioctl(struct file *filp,
 	return -EINVAL;
 }
 
-int kvm_arch_set_memory_region(struct kvm *kvm,
-                               struct kvm_userspace_memory_region *mem,
-                               struct kvm_memory_slot old,
-                               int user_alloc)
+int kvm_arch_prepare_memory_region(struct kvm *kvm,
+                                   struct kvm_memory_slot *memslot,
+                                   struct kvm_memory_slot old,
+                                   struct kvm_userspace_memory_region *mem,
+                                   int user_alloc)
 {
 	return 0;
 }
 
+void kvm_arch_commit_memory_region(struct kvm *kvm,
+               struct kvm_userspace_memory_region *mem,
+               struct kvm_memory_slot old,
+               int user_alloc)
+{
+       return;
+}
+
+
 void kvm_arch_flush_shadow(struct kvm *kvm)
 {
 }
diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
index f8bcaef..8bedd31 100644
--- a/arch/s390/kvm/kvm-s390.c
+++ b/arch/s390/kvm/kvm-s390.c
@@ -689,14 +689,12 @@ long kvm_arch_vcpu_ioctl(struct file *filp,
 }
 
 /* Section: memory related */
-int kvm_arch_set_memory_region(struct kvm *kvm,
-				struct kvm_userspace_memory_region *mem,
-				struct kvm_memory_slot old,
-				int user_alloc)
+int kvm_arch_prepare_memory_region(struct kvm *kvm,
+				   struct kvm_memory_slot *memslot,
+				   struct kvm_memory_slot old,
+				   struct kvm_userspace_memory_region *mem,
+				   int user_alloc)
 {
-	int i;
-	struct kvm_vcpu *vcpu;
-
 	/* A few sanity checks. We can have exactly one memory slot which has
 	   to start at guest virtual zero and which has to be located at a
 	   page boundary in userland and which has to end at a page boundary.
@@ -719,14 +717,23 @@ int kvm_arch_set_memory_region(struct kvm *kvm,
 	if (!user_alloc)
 		return -EINVAL;
 
+	return 0;
+}
+
+void kvm_arch_commit_memory_region(struct kvm *kvm,
+				struct kvm_userspace_memory_region *mem,
+				struct kvm_memory_slot old,
+				int user_alloc)
+{
+	int i;
+	struct kvm_vcpu *vcpu;
+
 	/* request update of sie control block for all available vcpus */
 	kvm_for_each_vcpu(i, vcpu, kvm) {
 		if (test_and_set_bit(KVM_REQ_MMU_RELOAD, &vcpu->requests))
 			continue;
 		kvm_s390_inject_sigp_stop(vcpu, ACTION_RELOADVCPU_ON_STOP);
 	}
-
-	return 0;
 }
 
 void kvm_arch_flush_shadow(struct kvm *kvm)
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 6a3593f..6a795be 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -5229,13 +5229,13 @@ void kvm_arch_destroy_vm(struct kvm *kvm)
 	kfree(kvm);
 }
 
-int kvm_arch_set_memory_region(struct kvm *kvm,
-				struct kvm_userspace_memory_region *mem,
+int kvm_arch_prepare_memory_region(struct kvm *kvm,
+				struct kvm_memory_slot *memslot,
 				struct kvm_memory_slot old,
+				struct kvm_userspace_memory_region *mem,
 				int user_alloc)
 {
-	int npages = mem->memory_size >> PAGE_SHIFT;
-	struct kvm_memory_slot *memslot = &kvm->memslots->memslots[mem->slot];
+	int npages = memslot->npages;
 
 	/*To keep backward compatibility with older userspace,
 	 *x86 needs to hanlde !user_alloc case.
@@ -5255,26 +5255,35 @@ int kvm_arch_set_memory_region(struct kvm *kvm,
 			if (IS_ERR((void *)userspace_addr))
 				return PTR_ERR((void *)userspace_addr);
 
-			/* set userspace_addr atomically for kvm_hva_to_rmapp */
-			spin_lock(&kvm->mmu_lock);
 			memslot->userspace_addr = userspace_addr;
-			spin_unlock(&kvm->mmu_lock);
-		} else {
-			if (!old.user_alloc && old.rmap) {
-				int ret;
-
-				down_write(&current->mm->mmap_sem);
-				ret = do_munmap(current->mm, old.userspace_addr,
-						old.npages * PAGE_SIZE);
-				up_write(&current->mm->mmap_sem);
-				if (ret < 0)
-					printk(KERN_WARNING
-				       "kvm_vm_ioctl_set_memory_region: "
-				       "failed to munmap memory\n");
-			}
 		}
 	}
 
+
+	return 0;
+}
+
+void kvm_arch_commit_memory_region(struct kvm *kvm,
+				struct kvm_userspace_memory_region *mem,
+				struct kvm_memory_slot old,
+				int user_alloc)
+{
+
+	int npages = mem->memory_size >> PAGE_SHIFT;
+
+	if (!user_alloc && !old.user_alloc && old.rmap && !npages) {
+		int ret;
+
+		down_write(&current->mm->mmap_sem);
+		ret = do_munmap(current->mm, old.userspace_addr,
+				old.npages * PAGE_SIZE);
+		up_write(&current->mm->mmap_sem);
+		if (ret < 0)
+			printk(KERN_WARNING
+			       "kvm_vm_ioctl_set_memory_region: "
+			       "failed to munmap memory\n");
+	}
+
 	spin_lock(&kvm->mmu_lock);
 	if (!kvm->arch.n_requested_mmu_pages) {
 		unsigned int nr_mmu_pages = kvm_mmu_calculate_mmu_pages(kvm);
@@ -5283,8 +5292,6 @@ int kvm_arch_set_memory_region(struct kvm *kvm,
 
 	kvm_mmu_slot_remove_write_access(kvm, mem->slot);
 	spin_unlock(&kvm->mmu_lock);
-
-	return 0;
 }
 
 void kvm_arch_flush_shadow(struct kvm *kvm)
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 782bfb1..3c44687 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -253,7 +253,12 @@ int kvm_set_memory_region(struct kvm *kvm,
 int __kvm_set_memory_region(struct kvm *kvm,
 			    struct kvm_userspace_memory_region *mem,
 			    int user_alloc);
-int kvm_arch_set_memory_region(struct kvm *kvm,
+int kvm_arch_prepare_memory_region(struct kvm *kvm,
+				struct kvm_memory_slot *memslot,
+				struct kvm_memory_slot old,
+				struct kvm_userspace_memory_region *mem,
+				int user_alloc);
+void kvm_arch_commit_memory_region(struct kvm *kvm,
 				struct kvm_userspace_memory_region *mem,
 				struct kvm_memory_slot old,
 				int user_alloc);
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 86dd8f3..c9f6cfe 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -663,6 +663,10 @@ skip_lpage:
 	if (!npages)
 		kvm_arch_flush_shadow(kvm);
 
+	r = kvm_arch_prepare_memory_region(kvm, &new, old, mem, user_alloc);
+	if (r)
+		goto out_free;
+
 	spin_lock(&kvm->mmu_lock);
 	if (mem->slot >= kvm->memslots->nmemslots)
 		kvm->memslots->nmemslots = mem->slot + 1;
@@ -670,13 +674,7 @@ skip_lpage:
 	*memslot = new;
 	spin_unlock(&kvm->mmu_lock);
 
-	r = kvm_arch_set_memory_region(kvm, mem, old, user_alloc);
-	if (r) {
-		spin_lock(&kvm->mmu_lock);
-		*memslot = old;
-		spin_unlock(&kvm->mmu_lock);
-		goto out_free;
-	}
+	kvm_arch_commit_memory_region(kvm, mem, old, user_alloc);
 
 	kvm_free_physmem_slot(&old, npages ? &new : NULL);
 	/* Slot deletion case: we have to update the current slot */
-- 
1.6.5.3

