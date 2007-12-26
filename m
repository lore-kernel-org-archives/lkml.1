Return-Path: <linux-kernel-owner+w=401wt.eu-S1754018AbXLZLL7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754018AbXLZLL7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Dec 2007 06:11:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752531AbXLZLGf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Dec 2007 06:06:35 -0500
Received: from il.qumranet.com ([82.166.9.18]:50481 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751746AbXLZLGG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Dec 2007 06:06:06 -0500
From: Avi Kivity <avi@qumranet.com>
To: linux-kernel@vger.kernel.org, kvm-devel@lists.sourceforge.net
Cc: Carsten Otte <cotte@de.ibm.com>
Subject: [PATCH 18/55] KVM: Portability: Split kvm_vm_ioctl v3
Date: Wed, 26 Dec 2007 13:05:23 +0200
Message-Id: <1198667160-22953-19-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.3.7
In-Reply-To: <1198667160-22953-1-git-send-email-avi@qumranet.com>
References: <1198667160-22953-1-git-send-email-avi@qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Carsten Otte <cotte@de.ibm.com>

This patch splits kvm_vm_ioctl into archtecture independent parts, and
x86 specific parts which go to kvm_arch_vcpu_ioctl in x86.c.
The patch is unchanged since last submission.

Common ioctls for all architectures are:
KVM_CREATE_VCPU, KVM_GET_DIRTY_LOG, KVM_SET_USER_MEMORY_REGION

x86 specific ioctls are:
KVM_SET_MEMORY_REGION,
KVM_GET/SET_NR_MMU_PAGES, KVM_SET_MEMORY_ALIAS, KVM_CREATE_IRQCHIP,
KVM_CREATE_IRQ_LINE, KVM_GET/SET_IRQCHIP
KVM_SET_TSS_ADDR

Signed-off-by: Carsten Otte <cotte@de.ibm.com>
Reviewed-by: Christian Borntraeger <borntraeger@de.ibm.com>
Acked-by: Hollis Blanchard <hollisb@us.ibm.com>
Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 drivers/kvm/kvm.h      |    7 ++
 drivers/kvm/kvm_main.c |  255 +----------------------------------------------
 drivers/kvm/x86.c      |  258 ++++++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 271 insertions(+), 249 deletions(-)

diff --git a/drivers/kvm/kvm.h b/drivers/kvm/kvm.h
index 3d07d9b..516f79f 100644
--- a/drivers/kvm/kvm.h
+++ b/drivers/kvm/kvm.h
@@ -620,6 +620,13 @@ long kvm_arch_vcpu_ioctl(struct file *filp,
 			 unsigned int ioctl, unsigned long arg);
 void kvm_arch_vcpu_load(struct kvm_vcpu *vcpu, int cpu);
 void kvm_arch_vcpu_put(struct kvm_vcpu *vcpu);
+int kvm_vm_ioctl_set_memory_region(struct kvm *kvm,
+				   struct
+				   kvm_userspace_memory_region *mem,
+				   int user_alloc);
+long kvm_arch_vm_ioctl(struct file *filp,
+		       unsigned int ioctl, unsigned long arg);
+void kvm_arch_destroy_vm(struct kvm *kvm);
 
 __init void kvm_arch_init(void);
 
diff --git a/drivers/kvm/kvm_main.c b/drivers/kvm/kvm_main.c
index 26a6399..9c0175d 100644
--- a/drivers/kvm/kvm_main.c
+++ b/drivers/kvm/kvm_main.c
@@ -792,36 +792,16 @@ out:
 }
 EXPORT_SYMBOL_GPL(kvm_set_memory_region);
 
-static int kvm_vm_ioctl_set_memory_region(struct kvm *kvm,
-					  struct
-					  kvm_userspace_memory_region *mem,
-					  int user_alloc)
+int kvm_vm_ioctl_set_memory_region(struct kvm *kvm,
+				   struct
+				   kvm_userspace_memory_region *mem,
+				   int user_alloc)
 {
 	if (mem->slot >= KVM_MEMORY_SLOTS)
 		return -EINVAL;
 	return kvm_set_memory_region(kvm, mem, user_alloc);
 }
 
-static int kvm_vm_ioctl_set_nr_mmu_pages(struct kvm *kvm,
-					  u32 kvm_nr_mmu_pages)
-{
-	if (kvm_nr_mmu_pages < KVM_MIN_ALLOC_MMU_PAGES)
-		return -EINVAL;
-
-	mutex_lock(&kvm->lock);
-
-	kvm_mmu_change_mmu_pages(kvm, kvm_nr_mmu_pages);
-	kvm->n_requested_mmu_pages = kvm_nr_mmu_pages;
-
-	mutex_unlock(&kvm->lock);
-	return 0;
-}
-
-static int kvm_vm_ioctl_get_nr_mmu_pages(struct kvm *kvm)
-{
-	return kvm->n_alloc_mmu_pages;
-}
-
 /*
  * Get (and clear) the dirty memory log for a memory slot.
  */
@@ -867,111 +847,6 @@ out:
 	return r;
 }
 
-/*
- * Set a new alias region.  Aliases map a portion of physical memory into
- * another portion.  This is useful for memory windows, for example the PC
- * VGA region.
- */
-static int kvm_vm_ioctl_set_memory_alias(struct kvm *kvm,
-					 struct kvm_memory_alias *alias)
-{
-	int r, n;
-	struct kvm_mem_alias *p;
-
-	r = -EINVAL;
-	/* General sanity checks */
-	if (alias->memory_size & (PAGE_SIZE - 1))
-		goto out;
-	if (alias->guest_phys_addr & (PAGE_SIZE - 1))
-		goto out;
-	if (alias->slot >= KVM_ALIAS_SLOTS)
-		goto out;
-	if (alias->guest_phys_addr + alias->memory_size
-	    < alias->guest_phys_addr)
-		goto out;
-	if (alias->target_phys_addr + alias->memory_size
-	    < alias->target_phys_addr)
-		goto out;
-
-	mutex_lock(&kvm->lock);
-
-	p = &kvm->aliases[alias->slot];
-	p->base_gfn = alias->guest_phys_addr >> PAGE_SHIFT;
-	p->npages = alias->memory_size >> PAGE_SHIFT;
-	p->target_gfn = alias->target_phys_addr >> PAGE_SHIFT;
-
-	for (n = KVM_ALIAS_SLOTS; n > 0; --n)
-		if (kvm->aliases[n - 1].npages)
-			break;
-	kvm->naliases = n;
-
-	kvm_mmu_zap_all(kvm);
-
-	mutex_unlock(&kvm->lock);
-
-	return 0;
-
-out:
-	return r;
-}
-
-static int kvm_vm_ioctl_get_irqchip(struct kvm *kvm, struct kvm_irqchip *chip)
-{
-	int r;
-
-	r = 0;
-	switch (chip->chip_id) {
-	case KVM_IRQCHIP_PIC_MASTER:
-		memcpy(&chip->chip.pic,
-			&pic_irqchip(kvm)->pics[0],
-			sizeof(struct kvm_pic_state));
-		break;
-	case KVM_IRQCHIP_PIC_SLAVE:
-		memcpy(&chip->chip.pic,
-			&pic_irqchip(kvm)->pics[1],
-			sizeof(struct kvm_pic_state));
-		break;
-	case KVM_IRQCHIP_IOAPIC:
-		memcpy(&chip->chip.ioapic,
-			ioapic_irqchip(kvm),
-			sizeof(struct kvm_ioapic_state));
-		break;
-	default:
-		r = -EINVAL;
-		break;
-	}
-	return r;
-}
-
-static int kvm_vm_ioctl_set_irqchip(struct kvm *kvm, struct kvm_irqchip *chip)
-{
-	int r;
-
-	r = 0;
-	switch (chip->chip_id) {
-	case KVM_IRQCHIP_PIC_MASTER:
-		memcpy(&pic_irqchip(kvm)->pics[0],
-			&chip->chip.pic,
-			sizeof(struct kvm_pic_state));
-		break;
-	case KVM_IRQCHIP_PIC_SLAVE:
-		memcpy(&pic_irqchip(kvm)->pics[1],
-			&chip->chip.pic,
-			sizeof(struct kvm_pic_state));
-		break;
-	case KVM_IRQCHIP_IOAPIC:
-		memcpy(ioapic_irqchip(kvm),
-			&chip->chip.ioapic,
-			sizeof(struct kvm_ioapic_state));
-		break;
-	default:
-		r = -EINVAL;
-		break;
-	}
-	kvm_pic_update_irq(pic_irqchip(kvm));
-	return r;
-}
-
 int is_error_page(struct page *page)
 {
 	return page == bad_page;
@@ -2661,16 +2536,6 @@ static int create_vcpu_fd(struct kvm_vcpu *vcpu)
 	return fd;
 }
 
-static int kvm_vm_ioctl_set_tss_addr(struct kvm *kvm, unsigned long addr)
-{
-	int ret;
-
-	if (addr > (unsigned int)(-3 * PAGE_SIZE))
-		return -1;
-	ret = kvm_x86_ops->set_tss_addr(kvm, addr);
-	return ret;
-}
-
 /*
  * Creates some virtual cpus.  Good luck creating more than one.
  */
@@ -2964,35 +2829,14 @@ static long kvm_vm_ioctl(struct file *filp,
 {
 	struct kvm *kvm = filp->private_data;
 	void __user *argp = (void __user *)arg;
-	int r = -EINVAL;
+	int r;
 
 	switch (ioctl) {
-	case KVM_SET_TSS_ADDR:
-		r = kvm_vm_ioctl_set_tss_addr(kvm, arg);
-		if (r < 0)
-			goto out;
-		break;
 	case KVM_CREATE_VCPU:
 		r = kvm_vm_ioctl_create_vcpu(kvm, arg);
 		if (r < 0)
 			goto out;
 		break;
-	case KVM_SET_MEMORY_REGION: {
-		struct kvm_memory_region kvm_mem;
-		struct kvm_userspace_memory_region kvm_userspace_mem;
-
-		r = -EFAULT;
-		if (copy_from_user(&kvm_mem, argp, sizeof kvm_mem))
-			goto out;
-		kvm_userspace_mem.slot = kvm_mem.slot;
-		kvm_userspace_mem.flags = kvm_mem.flags;
-		kvm_userspace_mem.guest_phys_addr = kvm_mem.guest_phys_addr;
-		kvm_userspace_mem.memory_size = kvm_mem.memory_size;
-		r = kvm_vm_ioctl_set_memory_region(kvm, &kvm_userspace_mem, 0);
-		if (r)
-			goto out;
-		break;
-	}
 	case KVM_SET_USER_MEMORY_REGION: {
 		struct kvm_userspace_memory_region kvm_userspace_mem;
 
@@ -3006,14 +2850,6 @@ static long kvm_vm_ioctl(struct file *filp,
 			goto out;
 		break;
 	}
-	case KVM_SET_NR_MMU_PAGES:
-		r = kvm_vm_ioctl_set_nr_mmu_pages(kvm, arg);
-		if (r)
-			goto out;
-		break;
-	case KVM_GET_NR_MMU_PAGES:
-		r = kvm_vm_ioctl_get_nr_mmu_pages(kvm);
-		break;
 	case KVM_GET_DIRTY_LOG: {
 		struct kvm_dirty_log log;
 
@@ -3025,87 +2861,8 @@ static long kvm_vm_ioctl(struct file *filp,
 			goto out;
 		break;
 	}
-	case KVM_SET_MEMORY_ALIAS: {
-		struct kvm_memory_alias alias;
-
-		r = -EFAULT;
-		if (copy_from_user(&alias, argp, sizeof alias))
-			goto out;
-		r = kvm_vm_ioctl_set_memory_alias(kvm, &alias);
-		if (r)
-			goto out;
-		break;
-	}
-	case KVM_CREATE_IRQCHIP:
-		r = -ENOMEM;
-		kvm->vpic = kvm_create_pic(kvm);
-		if (kvm->vpic) {
-			r = kvm_ioapic_init(kvm);
-			if (r) {
-				kfree(kvm->vpic);
-				kvm->vpic = NULL;
-				goto out;
-			}
-		} else
-			goto out;
-		break;
-	case KVM_IRQ_LINE: {
-		struct kvm_irq_level irq_event;
-
-		r = -EFAULT;
-		if (copy_from_user(&irq_event, argp, sizeof irq_event))
-			goto out;
-		if (irqchip_in_kernel(kvm)) {
-			mutex_lock(&kvm->lock);
-			if (irq_event.irq < 16)
-				kvm_pic_set_irq(pic_irqchip(kvm),
-					irq_event.irq,
-					irq_event.level);
-			kvm_ioapic_set_irq(kvm->vioapic,
-					irq_event.irq,
-					irq_event.level);
-			mutex_unlock(&kvm->lock);
-			r = 0;
-		}
-		break;
-	}
-	case KVM_GET_IRQCHIP: {
-		/* 0: PIC master, 1: PIC slave, 2: IOAPIC */
-		struct kvm_irqchip chip;
-
-		r = -EFAULT;
-		if (copy_from_user(&chip, argp, sizeof chip))
-			goto out;
-		r = -ENXIO;
-		if (!irqchip_in_kernel(kvm))
-			goto out;
-		r = kvm_vm_ioctl_get_irqchip(kvm, &chip);
-		if (r)
-			goto out;
-		r = -EFAULT;
-		if (copy_to_user(argp, &chip, sizeof chip))
-			goto out;
-		r = 0;
-		break;
-	}
-	case KVM_SET_IRQCHIP: {
-		/* 0: PIC master, 1: PIC slave, 2: IOAPIC */
-		struct kvm_irqchip chip;
-
-		r = -EFAULT;
-		if (copy_from_user(&chip, argp, sizeof chip))
-			goto out;
-		r = -ENXIO;
-		if (!irqchip_in_kernel(kvm))
-			goto out;
-		r = kvm_vm_ioctl_set_irqchip(kvm, &chip);
-		if (r)
-			goto out;
-		r = 0;
-		break;
-	}
 	default:
-		;
+		r = kvm_arch_vm_ioctl(filp, ioctl, arg);
 	}
 out:
 	return r;
diff --git a/drivers/kvm/x86.c b/drivers/kvm/x86.c
index 1fe209d..b84cb67 100644
--- a/drivers/kvm/x86.c
+++ b/drivers/kvm/x86.c
@@ -300,6 +300,264 @@ out:
 	return r;
 }
 
+static int kvm_vm_ioctl_set_tss_addr(struct kvm *kvm, unsigned long addr)
+{
+	int ret;
+
+	if (addr > (unsigned int)(-3 * PAGE_SIZE))
+		return -1;
+	ret = kvm_x86_ops->set_tss_addr(kvm, addr);
+	return ret;
+}
+
+static int kvm_vm_ioctl_set_nr_mmu_pages(struct kvm *kvm,
+					  u32 kvm_nr_mmu_pages)
+{
+	if (kvm_nr_mmu_pages < KVM_MIN_ALLOC_MMU_PAGES)
+		return -EINVAL;
+
+	mutex_lock(&kvm->lock);
+
+	kvm_mmu_change_mmu_pages(kvm, kvm_nr_mmu_pages);
+	kvm->n_requested_mmu_pages = kvm_nr_mmu_pages;
+
+	mutex_unlock(&kvm->lock);
+	return 0;
+}
+
+static int kvm_vm_ioctl_get_nr_mmu_pages(struct kvm *kvm)
+{
+	return kvm->n_alloc_mmu_pages;
+}
+
+/*
+ * Set a new alias region.  Aliases map a portion of physical memory into
+ * another portion.  This is useful for memory windows, for example the PC
+ * VGA region.
+ */
+static int kvm_vm_ioctl_set_memory_alias(struct kvm *kvm,
+					 struct kvm_memory_alias *alias)
+{
+	int r, n;
+	struct kvm_mem_alias *p;
+
+	r = -EINVAL;
+	/* General sanity checks */
+	if (alias->memory_size & (PAGE_SIZE - 1))
+		goto out;
+	if (alias->guest_phys_addr & (PAGE_SIZE - 1))
+		goto out;
+	if (alias->slot >= KVM_ALIAS_SLOTS)
+		goto out;
+	if (alias->guest_phys_addr + alias->memory_size
+	    < alias->guest_phys_addr)
+		goto out;
+	if (alias->target_phys_addr + alias->memory_size
+	    < alias->target_phys_addr)
+		goto out;
+
+	mutex_lock(&kvm->lock);
+
+	p = &kvm->aliases[alias->slot];
+	p->base_gfn = alias->guest_phys_addr >> PAGE_SHIFT;
+	p->npages = alias->memory_size >> PAGE_SHIFT;
+	p->target_gfn = alias->target_phys_addr >> PAGE_SHIFT;
+
+	for (n = KVM_ALIAS_SLOTS; n > 0; --n)
+		if (kvm->aliases[n - 1].npages)
+			break;
+	kvm->naliases = n;
+
+	kvm_mmu_zap_all(kvm);
+
+	mutex_unlock(&kvm->lock);
+
+	return 0;
+
+out:
+	return r;
+}
+
+static int kvm_vm_ioctl_get_irqchip(struct kvm *kvm, struct kvm_irqchip *chip)
+{
+	int r;
+
+	r = 0;
+	switch (chip->chip_id) {
+	case KVM_IRQCHIP_PIC_MASTER:
+		memcpy(&chip->chip.pic,
+			&pic_irqchip(kvm)->pics[0],
+			sizeof(struct kvm_pic_state));
+		break;
+	case KVM_IRQCHIP_PIC_SLAVE:
+		memcpy(&chip->chip.pic,
+			&pic_irqchip(kvm)->pics[1],
+			sizeof(struct kvm_pic_state));
+		break;
+	case KVM_IRQCHIP_IOAPIC:
+		memcpy(&chip->chip.ioapic,
+			ioapic_irqchip(kvm),
+			sizeof(struct kvm_ioapic_state));
+		break;
+	default:
+		r = -EINVAL;
+		break;
+	}
+	return r;
+}
+
+static int kvm_vm_ioctl_set_irqchip(struct kvm *kvm, struct kvm_irqchip *chip)
+{
+	int r;
+
+	r = 0;
+	switch (chip->chip_id) {
+	case KVM_IRQCHIP_PIC_MASTER:
+		memcpy(&pic_irqchip(kvm)->pics[0],
+			&chip->chip.pic,
+			sizeof(struct kvm_pic_state));
+		break;
+	case KVM_IRQCHIP_PIC_SLAVE:
+		memcpy(&pic_irqchip(kvm)->pics[1],
+			&chip->chip.pic,
+			sizeof(struct kvm_pic_state));
+		break;
+	case KVM_IRQCHIP_IOAPIC:
+		memcpy(ioapic_irqchip(kvm),
+			&chip->chip.ioapic,
+			sizeof(struct kvm_ioapic_state));
+		break;
+	default:
+		r = -EINVAL;
+		break;
+	}
+	kvm_pic_update_irq(pic_irqchip(kvm));
+	return r;
+}
+
+long kvm_arch_vm_ioctl(struct file *filp,
+		       unsigned int ioctl, unsigned long arg)
+{
+	struct kvm *kvm = filp->private_data;
+	void __user *argp = (void __user *)arg;
+	int r = -EINVAL;
+
+	switch (ioctl) {
+	case KVM_SET_TSS_ADDR:
+		r = kvm_vm_ioctl_set_tss_addr(kvm, arg);
+		if (r < 0)
+			goto out;
+		break;
+	case KVM_SET_MEMORY_REGION: {
+		struct kvm_memory_region kvm_mem;
+		struct kvm_userspace_memory_region kvm_userspace_mem;
+
+		r = -EFAULT;
+		if (copy_from_user(&kvm_mem, argp, sizeof kvm_mem))
+			goto out;
+		kvm_userspace_mem.slot = kvm_mem.slot;
+		kvm_userspace_mem.flags = kvm_mem.flags;
+		kvm_userspace_mem.guest_phys_addr = kvm_mem.guest_phys_addr;
+		kvm_userspace_mem.memory_size = kvm_mem.memory_size;
+		r = kvm_vm_ioctl_set_memory_region(kvm, &kvm_userspace_mem, 0);
+		if (r)
+			goto out;
+		break;
+	}
+	case KVM_SET_NR_MMU_PAGES:
+		r = kvm_vm_ioctl_set_nr_mmu_pages(kvm, arg);
+		if (r)
+			goto out;
+		break;
+	case KVM_GET_NR_MMU_PAGES:
+		r = kvm_vm_ioctl_get_nr_mmu_pages(kvm);
+		break;
+	case KVM_SET_MEMORY_ALIAS: {
+		struct kvm_memory_alias alias;
+
+		r = -EFAULT;
+		if (copy_from_user(&alias, argp, sizeof alias))
+			goto out;
+		r = kvm_vm_ioctl_set_memory_alias(kvm, &alias);
+		if (r)
+			goto out;
+		break;
+	}
+	case KVM_CREATE_IRQCHIP:
+		r = -ENOMEM;
+		kvm->vpic = kvm_create_pic(kvm);
+		if (kvm->vpic) {
+			r = kvm_ioapic_init(kvm);
+			if (r) {
+				kfree(kvm->vpic);
+				kvm->vpic = NULL;
+				goto out;
+			}
+		} else
+			goto out;
+		break;
+	case KVM_IRQ_LINE: {
+		struct kvm_irq_level irq_event;
+
+		r = -EFAULT;
+		if (copy_from_user(&irq_event, argp, sizeof irq_event))
+			goto out;
+		if (irqchip_in_kernel(kvm)) {
+			mutex_lock(&kvm->lock);
+			if (irq_event.irq < 16)
+				kvm_pic_set_irq(pic_irqchip(kvm),
+					irq_event.irq,
+					irq_event.level);
+			kvm_ioapic_set_irq(kvm->vioapic,
+					irq_event.irq,
+					irq_event.level);
+			mutex_unlock(&kvm->lock);
+			r = 0;
+		}
+		break;
+	}
+	case KVM_GET_IRQCHIP: {
+		/* 0: PIC master, 1: PIC slave, 2: IOAPIC */
+		struct kvm_irqchip chip;
+
+		r = -EFAULT;
+		if (copy_from_user(&chip, argp, sizeof chip))
+			goto out;
+		r = -ENXIO;
+		if (!irqchip_in_kernel(kvm))
+			goto out;
+		r = kvm_vm_ioctl_get_irqchip(kvm, &chip);
+		if (r)
+			goto out;
+		r = -EFAULT;
+		if (copy_to_user(argp, &chip, sizeof chip))
+			goto out;
+		r = 0;
+		break;
+	}
+	case KVM_SET_IRQCHIP: {
+		/* 0: PIC master, 1: PIC slave, 2: IOAPIC */
+		struct kvm_irqchip chip;
+
+		r = -EFAULT;
+		if (copy_from_user(&chip, argp, sizeof chip))
+			goto out;
+		r = -ENXIO;
+		if (!irqchip_in_kernel(kvm))
+			goto out;
+		r = kvm_vm_ioctl_set_irqchip(kvm, &chip);
+		if (r)
+			goto out;
+		r = 0;
+		break;
+	}
+	default:
+		;
+	}
+out:
+	return r;
+}
+
 static __init void kvm_init_msr_list(void)
 {
 	u32 dummy[2];
-- 
1.5.3.7

