Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756021Ab0BJRYf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Feb 2010 12:24:35 -0500
Received: from mx1.redhat.com ([209.132.183.28]:42700 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755776Ab0BJRXP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Feb 2010 12:23:15 -0500
From: Avi Kivity <avi@redhat.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 36/40] KVM: convert slots_lock to a mutex
Date: Wed, 10 Feb 2010 19:23:05 +0200
Message-Id: <1265822589-11155-37-git-send-email-avi@redhat.com>
In-Reply-To: <1265822589-11155-1-git-send-email-avi@redhat.com>
References: <1265822589-11155-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Marcelo Tosatti <mtosatti@redhat.com>

Signed-off-by: Marcelo Tosatti <mtosatti@redhat.com>
---
 arch/ia64/kvm/kvm-ia64.c  |    4 ++--
 arch/powerpc/kvm/book3s.c |    4 ++--
 arch/x86/kvm/i8254.c      |    2 +-
 arch/x86/kvm/i8259.c      |    4 ++--
 arch/x86/kvm/vmx.c        |    8 ++++----
 arch/x86/kvm/x86.c        |   16 ++++++++--------
 include/linux/kvm_host.h  |    2 +-
 virt/kvm/coalesced_mmio.c |   14 +++++++-------
 virt/kvm/eventfd.c        |   10 +++++-----
 virt/kvm/ioapic.c         |    4 ++--
 virt/kvm/kvm_main.c       |   10 +++++-----
 11 files changed, 39 insertions(+), 39 deletions(-)

diff --git a/arch/ia64/kvm/kvm-ia64.c b/arch/ia64/kvm/kvm-ia64.c
index d5e3846..e6ac549 100644
--- a/arch/ia64/kvm/kvm-ia64.c
+++ b/arch/ia64/kvm/kvm-ia64.c
@@ -1834,7 +1834,7 @@ int kvm_vm_ioctl_get_dirty_log(struct kvm *kvm,
 	struct kvm_memory_slot *memslot;
 	int is_dirty = 0;
 
-	down_write(&kvm->slots_lock);
+	mutex_lock(&kvm->slots_lock);
 	spin_lock(&kvm->arch.dirty_log_lock);
 
 	r = kvm_ia64_sync_dirty_log(kvm, log);
@@ -1854,7 +1854,7 @@ int kvm_vm_ioctl_get_dirty_log(struct kvm *kvm,
 	}
 	r = 0;
 out:
-	up_write(&kvm->slots_lock);
+	mutex_unlock(&kvm->slots_lock);
 	spin_unlock(&kvm->arch.dirty_log_lock);
 	return r;
 }
diff --git a/arch/powerpc/kvm/book3s.c b/arch/powerpc/kvm/book3s.c
index bb8873d..492dcc1 100644
--- a/arch/powerpc/kvm/book3s.c
+++ b/arch/powerpc/kvm/book3s.c
@@ -857,7 +857,7 @@ int kvm_vm_ioctl_get_dirty_log(struct kvm *kvm,
 	int is_dirty = 0;
 	int r, n;
 
-	down_write(&kvm->slots_lock);
+	mutex_lock(&kvm->slots_lock);
 
 	r = kvm_get_dirty_log(kvm, log, &is_dirty);
 	if (r)
@@ -879,7 +879,7 @@ int kvm_vm_ioctl_get_dirty_log(struct kvm *kvm,
 
 	r = 0;
 out:
-	up_write(&kvm->slots_lock);
+	mutex_unlock(&kvm->slots_lock);
 	return r;
 }
 
diff --git a/arch/x86/kvm/i8254.c b/arch/x86/kvm/i8254.c
index a7259e8..caad189 100644
--- a/arch/x86/kvm/i8254.c
+++ b/arch/x86/kvm/i8254.c
@@ -602,7 +602,7 @@ static const struct kvm_io_device_ops speaker_dev_ops = {
 	.write    = speaker_ioport_write,
 };
 
-/* Caller must have writers lock on slots_lock */
+/* Caller must hold slots_lock */
 struct kvm_pit *kvm_create_pit(struct kvm *kvm, u32 flags)
 {
 	struct kvm_pit *pit;
diff --git a/arch/x86/kvm/i8259.c b/arch/x86/kvm/i8259.c
index b7d145b..d5753a7 100644
--- a/arch/x86/kvm/i8259.c
+++ b/arch/x86/kvm/i8259.c
@@ -533,9 +533,9 @@ struct kvm_pic *kvm_create_pic(struct kvm *kvm)
 	 * Initialize PIO device
 	 */
 	kvm_iodevice_init(&s->dev, &picdev_ops);
-	down_write(&kvm->slots_lock);
+	mutex_lock(&kvm->slots_lock);
 	ret = kvm_io_bus_register_dev(kvm, KVM_PIO_BUS, &s->dev);
-	up_write(&kvm->slots_lock);
+	mutex_unlock(&kvm->slots_lock);
 	if (ret < 0) {
 		kfree(s);
 		return NULL;
diff --git a/arch/x86/kvm/vmx.c b/arch/x86/kvm/vmx.c
index 22ab713..f04e2ff 100644
--- a/arch/x86/kvm/vmx.c
+++ b/arch/x86/kvm/vmx.c
@@ -2223,7 +2223,7 @@ static int alloc_apic_access_page(struct kvm *kvm)
 	struct kvm_userspace_memory_region kvm_userspace_mem;
 	int r = 0;
 
-	down_write(&kvm->slots_lock);
+	mutex_lock(&kvm->slots_lock);
 	if (kvm->arch.apic_access_page)
 		goto out;
 	kvm_userspace_mem.slot = APIC_ACCESS_PAGE_PRIVATE_MEMSLOT;
@@ -2236,7 +2236,7 @@ static int alloc_apic_access_page(struct kvm *kvm)
 
 	kvm->arch.apic_access_page = gfn_to_page(kvm, 0xfee00);
 out:
-	up_write(&kvm->slots_lock);
+	mutex_unlock(&kvm->slots_lock);
 	return r;
 }
 
@@ -2245,7 +2245,7 @@ static int alloc_identity_pagetable(struct kvm *kvm)
 	struct kvm_userspace_memory_region kvm_userspace_mem;
 	int r = 0;
 
-	down_write(&kvm->slots_lock);
+	mutex_lock(&kvm->slots_lock);
 	if (kvm->arch.ept_identity_pagetable)
 		goto out;
 	kvm_userspace_mem.slot = IDENTITY_PAGETABLE_PRIVATE_MEMSLOT;
@@ -2260,7 +2260,7 @@ static int alloc_identity_pagetable(struct kvm *kvm)
 	kvm->arch.ept_identity_pagetable = gfn_to_page(kvm,
 			kvm->arch.ept_identity_map_addr >> PAGE_SHIFT);
 out:
-	up_write(&kvm->slots_lock);
+	mutex_unlock(&kvm->slots_lock);
 	return r;
 }
 
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 0cb795c..4b00831 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -2209,14 +2209,14 @@ static int kvm_vm_ioctl_set_nr_mmu_pages(struct kvm *kvm,
 	if (kvm_nr_mmu_pages < KVM_MIN_ALLOC_MMU_PAGES)
 		return -EINVAL;
 
-	down_write(&kvm->slots_lock);
+	mutex_lock(&kvm->slots_lock);
 	spin_lock(&kvm->mmu_lock);
 
 	kvm_mmu_change_mmu_pages(kvm, kvm_nr_mmu_pages);
 	kvm->arch.n_requested_mmu_pages = kvm_nr_mmu_pages;
 
 	spin_unlock(&kvm->mmu_lock);
-	up_write(&kvm->slots_lock);
+	mutex_unlock(&kvm->slots_lock);
 	return 0;
 }
 
@@ -2293,7 +2293,7 @@ static int kvm_vm_ioctl_set_memory_alias(struct kvm *kvm,
 	if (!aliases)
 		goto out;
 
-	down_write(&kvm->slots_lock);
+	mutex_lock(&kvm->slots_lock);
 
 	/* invalidate any gfn reference in case of deletion/shrinking */
 	memcpy(aliases, kvm->arch.aliases, sizeof(struct kvm_mem_aliases));
@@ -2329,7 +2329,7 @@ static int kvm_vm_ioctl_set_memory_alias(struct kvm *kvm,
 	r = 0;
 
 out_unlock:
-	up_write(&kvm->slots_lock);
+	mutex_unlock(&kvm->slots_lock);
 out:
 	return r;
 }
@@ -2463,7 +2463,7 @@ int kvm_vm_ioctl_get_dirty_log(struct kvm *kvm,
 	unsigned long is_dirty = 0;
 	unsigned long *dirty_bitmap = NULL;
 
-	down_write(&kvm->slots_lock);
+	mutex_lock(&kvm->slots_lock);
 
 	r = -EINVAL;
 	if (log->slot >= KVM_MEMORY_SLOTS)
@@ -2513,7 +2513,7 @@ int kvm_vm_ioctl_get_dirty_log(struct kvm *kvm,
 out_free:
 	vfree(dirty_bitmap);
 out:
-	up_write(&kvm->slots_lock);
+	mutex_unlock(&kvm->slots_lock);
 	return r;
 }
 
@@ -2626,7 +2626,7 @@ long kvm_arch_vm_ioctl(struct file *filp,
 				   sizeof(struct kvm_pit_config)))
 			goto out;
 	create_pit:
-		down_write(&kvm->slots_lock);
+		mutex_lock(&kvm->slots_lock);
 		r = -EEXIST;
 		if (kvm->arch.vpit)
 			goto create_pit_unlock;
@@ -2635,7 +2635,7 @@ long kvm_arch_vm_ioctl(struct file *filp,
 		if (kvm->arch.vpit)
 			r = 0;
 	create_pit_unlock:
-		up_write(&kvm->slots_lock);
+		mutex_unlock(&kvm->slots_lock);
 		break;
 	case KVM_IRQ_LINE_STATUS:
 	case KVM_IRQ_LINE: {
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 0bb9aa2..bb0314e 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -161,7 +161,7 @@ struct kvm_memslots {
 struct kvm {
 	spinlock_t mmu_lock;
 	spinlock_t requests_lock;
-	struct rw_semaphore slots_lock;
+	struct mutex slots_lock;
 	struct mm_struct *mm; /* userspace tied to this vm */
 	struct kvm_memslots *memslots;
 	struct srcu_struct srcu;
diff --git a/virt/kvm/coalesced_mmio.c b/virt/kvm/coalesced_mmio.c
index a736a93..5de6594 100644
--- a/virt/kvm/coalesced_mmio.c
+++ b/virt/kvm/coalesced_mmio.c
@@ -110,9 +110,9 @@ int kvm_coalesced_mmio_init(struct kvm *kvm)
 	dev->kvm = kvm;
 	kvm->coalesced_mmio_dev = dev;
 
-	down_write(&kvm->slots_lock);
+	mutex_lock(&kvm->slots_lock);
 	ret = kvm_io_bus_register_dev(kvm, KVM_MMIO_BUS, &dev->dev);
-	up_write(&kvm->slots_lock);
+	mutex_unlock(&kvm->slots_lock);
 	if (ret < 0)
 		goto out_free_dev;
 
@@ -140,16 +140,16 @@ int kvm_vm_ioctl_register_coalesced_mmio(struct kvm *kvm,
 	if (dev == NULL)
 		return -EINVAL;
 
-	down_write(&kvm->slots_lock);
+	mutex_lock(&kvm->slots_lock);
 	if (dev->nb_zones >= KVM_COALESCED_MMIO_ZONE_MAX) {
-		up_write(&kvm->slots_lock);
+		mutex_unlock(&kvm->slots_lock);
 		return -ENOBUFS;
 	}
 
 	dev->zone[dev->nb_zones] = *zone;
 	dev->nb_zones++;
 
-	up_write(&kvm->slots_lock);
+	mutex_unlock(&kvm->slots_lock);
 	return 0;
 }
 
@@ -163,7 +163,7 @@ int kvm_vm_ioctl_unregister_coalesced_mmio(struct kvm *kvm,
 	if (dev == NULL)
 		return -EINVAL;
 
-	down_write(&kvm->slots_lock);
+	mutex_lock(&kvm->slots_lock);
 
 	i = dev->nb_zones;
 	while(i) {
@@ -181,7 +181,7 @@ int kvm_vm_ioctl_unregister_coalesced_mmio(struct kvm *kvm,
 		i--;
 	}
 
-	up_write(&kvm->slots_lock);
+	mutex_unlock(&kvm->slots_lock);
 
 	return 0;
 }
diff --git a/virt/kvm/eventfd.c b/virt/kvm/eventfd.c
index 315a586..486c604 100644
--- a/virt/kvm/eventfd.c
+++ b/virt/kvm/eventfd.c
@@ -508,7 +508,7 @@ kvm_assign_ioeventfd(struct kvm *kvm, struct kvm_ioeventfd *args)
 	else
 		p->wildcard = true;
 
-	down_write(&kvm->slots_lock);
+	mutex_lock(&kvm->slots_lock);
 
 	/* Verify that there isnt a match already */
 	if (ioeventfd_check_collision(kvm, p)) {
@@ -524,12 +524,12 @@ kvm_assign_ioeventfd(struct kvm *kvm, struct kvm_ioeventfd *args)
 
 	list_add_tail(&p->list, &kvm->ioeventfds);
 
-	up_write(&kvm->slots_lock);
+	mutex_unlock(&kvm->slots_lock);
 
 	return 0;
 
 unlock_fail:
-	up_write(&kvm->slots_lock);
+	mutex_unlock(&kvm->slots_lock);
 
 fail:
 	kfree(p);
@@ -551,7 +551,7 @@ kvm_deassign_ioeventfd(struct kvm *kvm, struct kvm_ioeventfd *args)
 	if (IS_ERR(eventfd))
 		return PTR_ERR(eventfd);
 
-	down_write(&kvm->slots_lock);
+	mutex_lock(&kvm->slots_lock);
 
 	list_for_each_entry_safe(p, tmp, &kvm->ioeventfds, list) {
 		bool wildcard = !(args->flags & KVM_IOEVENTFD_FLAG_DATAMATCH);
@@ -571,7 +571,7 @@ kvm_deassign_ioeventfd(struct kvm *kvm, struct kvm_ioeventfd *args)
 		break;
 	}
 
-	up_write(&kvm->slots_lock);
+	mutex_unlock(&kvm->slots_lock);
 
 	eventfd_ctx_put(eventfd);
 
diff --git a/virt/kvm/ioapic.c b/virt/kvm/ioapic.c
index f326a6f..f01392f 100644
--- a/virt/kvm/ioapic.c
+++ b/virt/kvm/ioapic.c
@@ -372,9 +372,9 @@ int kvm_ioapic_init(struct kvm *kvm)
 	kvm_ioapic_reset(ioapic);
 	kvm_iodevice_init(&ioapic->dev, &ioapic_mmio_ops);
 	ioapic->kvm = kvm;
-	down_write(&kvm->slots_lock);
+	mutex_lock(&kvm->slots_lock);
 	ret = kvm_io_bus_register_dev(kvm, KVM_MMIO_BUS, &ioapic->dev);
-	up_write(&kvm->slots_lock);
+	mutex_unlock(&kvm->slots_lock);
 	if (ret < 0)
 		kfree(ioapic);
 
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 659bc12..2b7cd6c 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -429,7 +429,7 @@ static struct kvm *kvm_create_vm(void)
 	kvm_eventfd_init(kvm);
 	mutex_init(&kvm->lock);
 	mutex_init(&kvm->irq_lock);
-	init_rwsem(&kvm->slots_lock);
+	mutex_init(&kvm->slots_lock);
 	atomic_set(&kvm->users_count, 1);
 	spin_lock(&kvm_lock);
 	list_add(&kvm->vm_list, &vm_list);
@@ -763,9 +763,9 @@ int kvm_set_memory_region(struct kvm *kvm,
 {
 	int r;
 
-	down_write(&kvm->slots_lock);
+	mutex_lock(&kvm->slots_lock);
 	r = __kvm_set_memory_region(kvm, mem, user_alloc);
-	up_write(&kvm->slots_lock);
+	mutex_unlock(&kvm->slots_lock);
 	return r;
 }
 EXPORT_SYMBOL_GPL(kvm_set_memory_region);
@@ -1997,7 +1997,7 @@ int kvm_io_bus_read(struct kvm *kvm, enum kvm_bus bus_idx, gpa_t addr,
 	return -EOPNOTSUPP;
 }
 
-/* Caller must have write lock on slots_lock. */
+/* Caller must hold slots_lock. */
 int kvm_io_bus_register_dev(struct kvm *kvm, enum kvm_bus bus_idx,
 			    struct kvm_io_device *dev)
 {
@@ -2019,7 +2019,7 @@ int kvm_io_bus_register_dev(struct kvm *kvm, enum kvm_bus bus_idx,
 	return 0;
 }
 
-/* Caller must have write lock on slots_lock. */
+/* Caller must hold slots_lock. */
 int kvm_io_bus_unregister_dev(struct kvm *kvm, enum kvm_bus bus_idx,
 			      struct kvm_io_device *dev)
 {
-- 
1.6.5.3

