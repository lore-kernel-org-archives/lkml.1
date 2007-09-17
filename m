Return-Path: <linux-kernel-owner+w=401wt.eu-S1754932AbXIQIvO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754932AbXIQIvO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2007 04:51:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754852AbXIQIdX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Sep 2007 04:33:23 -0400
Received: from il.qumranet.com ([82.166.9.18]:45249 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753420AbXIQIcf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2007 04:32:35 -0400
From: Avi Kivity <avi@qumranet.com>
To: kvm-devel@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org, Laurent Vivier <Laurent.Vivier@bull.net>
Subject: [PATCH 087/104] KVM: Simplify memory allocation
Date: Mon, 17 Sep 2007 10:32:09 +0200
Message-Id: <11900179493584-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.3
In-Reply-To: <11900179463203-git-send-email-avi@qumranet.com>
References: <11900179463203-git-send-email-avi@qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Laurent Vivier <Laurent.Vivier@bull.net>

The mutex->splinlock convertion alllows us to make some code simplifications.
As we can keep the lock longer, we don't have to release it and then
have to check if the environment has not been modified before re-taking it. We
can remove kvm->busy and kvm->memory_config_version.

Signed-off-by: Laurent Vivier <Laurent.Vivier@bull.net>
Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 drivers/kvm/kvm.h      |    2 --
 drivers/kvm/kvm_main.c |   38 +++-----------------------------------
 2 files changed, 3 insertions(+), 37 deletions(-)

diff --git a/drivers/kvm/kvm.h b/drivers/kvm/kvm.h
index ee9f8bd..351da40 100644
--- a/drivers/kvm/kvm.h
+++ b/drivers/kvm/kvm.h
@@ -411,8 +411,6 @@ struct kvm {
 	int n_free_mmu_pages;
 	struct hlist_head mmu_page_hash[KVM_NUM_MMU_PAGES];
 	struct kvm_vcpu *vcpus[KVM_MAX_VCPUS];
-	int memory_config_version;
-	int busy;
 	unsigned long rmap_overflow;
 	struct list_head vm_list;
 	struct file *filp;
diff --git a/drivers/kvm/kvm_main.c b/drivers/kvm/kvm_main.c
index 49a0ff4..c2c8c93 100644
--- a/drivers/kvm/kvm_main.c
+++ b/drivers/kvm/kvm_main.c
@@ -679,7 +679,6 @@ static int kvm_vm_ioctl_set_memory_region(struct kvm *kvm,
 	unsigned long i;
 	struct kvm_memory_slot *memslot;
 	struct kvm_memory_slot old, new;
-	int memory_config_version;
 
 	r = -EINVAL;
 	/* General sanity checks */
@@ -699,10 +698,8 @@ static int kvm_vm_ioctl_set_memory_region(struct kvm *kvm,
 	if (!npages)
 		mem->flags &= ~KVM_MEM_LOG_DIRTY_PAGES;
 
-raced:
 	mutex_lock(&kvm->lock);
 
-	memory_config_version = kvm->memory_config_version;
 	new = old = *memslot;
 
 	new.base_gfn = base_gfn;
@@ -725,11 +722,6 @@ raced:
 		      (base_gfn >= s->base_gfn + s->npages)))
 			goto out_unlock;
 	}
-	/*
-	 * Do memory allocations outside lock.  memory_config_version will
-	 * detect any races.
-	 */
-	mutex_unlock(&kvm->lock);
 
 	/* Deallocate if slot is being removed */
 	if (!npages)
@@ -746,14 +738,14 @@ raced:
 		new.phys_mem = vmalloc(npages * sizeof(struct page *));
 
 		if (!new.phys_mem)
-			goto out_free;
+			goto out_unlock;
 
 		memset(new.phys_mem, 0, npages * sizeof(struct page *));
 		for (i = 0; i < npages; ++i) {
 			new.phys_mem[i] = alloc_page(GFP_HIGHUSER
 						     | __GFP_ZERO);
 			if (!new.phys_mem[i])
-				goto out_free;
+				goto out_unlock;
 			set_page_private(new.phys_mem[i],0);
 		}
 	}
@@ -764,27 +756,14 @@ raced:
 
 		new.dirty_bitmap = vmalloc(dirty_bytes);
 		if (!new.dirty_bitmap)
-			goto out_free;
+			goto out_unlock;
 		memset(new.dirty_bitmap, 0, dirty_bytes);
 	}
 
-	mutex_lock(&kvm->lock);
-
-	if (memory_config_version != kvm->memory_config_version) {
-		mutex_unlock(&kvm->lock);
-		kvm_free_physmem_slot(&new, &old);
-		goto raced;
-	}
-
-	r = -EAGAIN;
-	if (kvm->busy)
-		goto out_unlock;
-
 	if (mem->slot >= kvm->nmemslots)
 		kvm->nmemslots = mem->slot + 1;
 
 	*memslot = new;
-	++kvm->memory_config_version;
 
 	kvm_mmu_slot_remove_write_access(kvm, mem->slot);
 	kvm_flush_remote_tlbs(kvm);
@@ -796,7 +775,6 @@ raced:
 
 out_unlock:
 	mutex_unlock(&kvm->lock);
-out_free:
 	kvm_free_physmem_slot(&new, &old);
 out:
 	return r;
@@ -815,12 +793,6 @@ static int kvm_vm_ioctl_get_dirty_log(struct kvm *kvm,
 
 	mutex_lock(&kvm->lock);
 
-	/*
-	 * Prevent changes to guest memory configuration even while the lock
-	 * is not taken.
-	 */
-	++kvm->busy;
-	mutex_unlock(&kvm->lock);
 	r = -EINVAL;
 	if (log->slot >= KVM_MEMORY_SLOTS)
 		goto out;
@@ -841,18 +813,14 @@ static int kvm_vm_ioctl_get_dirty_log(struct kvm *kvm,
 
 	/* If nothing is dirty, don't bother messing with page tables. */
 	if (any) {
-		mutex_lock(&kvm->lock);
 		kvm_mmu_slot_remove_write_access(kvm, log->slot);
 		kvm_flush_remote_tlbs(kvm);
 		memset(memslot->dirty_bitmap, 0, n);
-		mutex_unlock(&kvm->lock);
 	}
 
 	r = 0;
 
 out:
-	mutex_lock(&kvm->lock);
-	--kvm->busy;
 	mutex_unlock(&kvm->lock);
 	return r;
 }
-- 
1.5.3

