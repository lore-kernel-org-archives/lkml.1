Return-Path: <linux-kernel-owner+w=401wt.eu-S1756000AbYIWOAH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756000AbYIWOAH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2008 10:00:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754432AbYIWNuY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Sep 2008 09:50:24 -0400
Received: from mx2.redhat.com ([66.187.237.31]:43488 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754402AbYIWNuU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2008 09:50:20 -0400
From: Avi Kivity <avi@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: kvm@vger.kernel.org, Ben-Ami Yassour <benami@il.ibm.com>
Subject: [PATCH 36/40] KVM: pci device assignment
Date: Tue, 23 Sep 2008 16:46:50 +0300
Message-Id: <1222177614-26669-37-git-send-email-avi@redhat.com>
In-Reply-To: <1222177614-26669-1-git-send-email-avi@redhat.com>
References: <1222177614-26669-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ben-Ami Yassour <benami@il.ibm.com>

Based on a patch from: Amit Shah <amit.shah@qumranet.com>

This patch adds support for handling PCI devices that are assigned to
the guest.

The device to be assigned to the guest is registered in the host kernel
and interrupt delivery is handled.  If a device is already assigned, or
the device driver for it is still loaded on the host, the device
assignment is failed by conveying a -EBUSY reply to the userspace.

Devices that share their interrupt line are not supported at the moment.

By itself, this patch will not make devices work within the guest.
The VT-d extension is required to enable the device to perform DMA.
Another alternative is PVDMA.

Signed-off-by: Amit Shah <amit.shah@qumranet.com>
Signed-off-by: Ben-Ami Yassour <benami@il.ibm.com>
Signed-off-by: Weidong Han <weidong.han@intel.com>
Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 arch/x86/kvm/x86.c         |  243 ++++++++++++++++++++++++++++++++++++++++++++
 include/asm-x86/kvm_host.h |   16 +++
 include/linux/kvm.h        |   19 ++++
 3 files changed, 278 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 94a2165..a97157c 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -4,10 +4,14 @@
  * derived from drivers/kvm/kvm_main.c
  *
  * Copyright (C) 2006 Qumranet, Inc.
+ * Copyright (C) 2008 Qumranet, Inc.
+ * Copyright IBM Corporation, 2008
  *
  * Authors:
  *   Avi Kivity   <avi@qumranet.com>
  *   Yaniv Kamay  <yaniv@qumranet.com>
+ *   Amit Shah    <amit.shah@qumranet.com>
+ *   Ben-Ami Yassour <benami@il.ibm.com>
  *
  * This work is licensed under the terms of the GNU GPL, version 2.  See
  * the COPYING file in the top-level directory.
@@ -23,8 +27,10 @@
 #include "x86.h"
 
 #include <linux/clocksource.h>
+#include <linux/interrupt.h>
 #include <linux/kvm.h>
 #include <linux/fs.h>
+#include <linux/pci.h>
 #include <linux/vmalloc.h>
 #include <linux/module.h>
 #include <linux/mman.h>
@@ -98,6 +104,219 @@ struct kvm_stats_debugfs_item debugfs_entries[] = {
 	{ NULL }
 };
 
+struct kvm_assigned_dev_kernel *kvm_find_assigned_dev(struct list_head *head,
+						      int assigned_dev_id)
+{
+	struct list_head *ptr;
+	struct kvm_assigned_dev_kernel *match;
+
+	list_for_each(ptr, head) {
+		match = list_entry(ptr, struct kvm_assigned_dev_kernel, list);
+		if (match->assigned_dev_id == assigned_dev_id)
+			return match;
+	}
+	return NULL;
+}
+
+static void kvm_assigned_dev_interrupt_work_handler(struct work_struct *work)
+{
+	struct kvm_assigned_dev_kernel *assigned_dev;
+
+	assigned_dev = container_of(work, struct kvm_assigned_dev_kernel,
+				    interrupt_work);
+
+	/* This is taken to safely inject irq inside the guest. When
+	 * the interrupt injection (or the ioapic code) uses a
+	 * finer-grained lock, update this
+	 */
+	mutex_lock(&assigned_dev->kvm->lock);
+	kvm_set_irq(assigned_dev->kvm,
+		    assigned_dev->guest_irq, 1);
+	mutex_unlock(&assigned_dev->kvm->lock);
+	kvm_put_kvm(assigned_dev->kvm);
+}
+
+/* FIXME: Implement the OR logic needed to make shared interrupts on
+ * this line behave properly
+ */
+static irqreturn_t kvm_assigned_dev_intr(int irq, void *dev_id)
+{
+	struct kvm_assigned_dev_kernel *assigned_dev =
+		(struct kvm_assigned_dev_kernel *) dev_id;
+
+	kvm_get_kvm(assigned_dev->kvm);
+	schedule_work(&assigned_dev->interrupt_work);
+	disable_irq_nosync(irq);
+	return IRQ_HANDLED;
+}
+
+/* Ack the irq line for an assigned device */
+static void kvm_assigned_dev_ack_irq(struct kvm_irq_ack_notifier *kian)
+{
+	struct kvm_assigned_dev_kernel *dev;
+
+	if (kian->gsi == -1)
+		return;
+
+	dev = container_of(kian, struct kvm_assigned_dev_kernel,
+			   ack_notifier);
+	kvm_set_irq(dev->kvm, dev->guest_irq, 0);
+	enable_irq(dev->host_irq);
+}
+
+static int kvm_vm_ioctl_assign_irq(struct kvm *kvm,
+				   struct kvm_assigned_irq
+				   *assigned_irq)
+{
+	int r = 0;
+	struct kvm_assigned_dev_kernel *match;
+
+	mutex_lock(&kvm->lock);
+
+	match = kvm_find_assigned_dev(&kvm->arch.assigned_dev_head,
+				      assigned_irq->assigned_dev_id);
+	if (!match) {
+		mutex_unlock(&kvm->lock);
+		return -EINVAL;
+	}
+
+	if (match->irq_requested) {
+		match->guest_irq = assigned_irq->guest_irq;
+		match->ack_notifier.gsi = assigned_irq->guest_irq;
+		mutex_unlock(&kvm->lock);
+		return 0;
+	}
+
+	INIT_WORK(&match->interrupt_work,
+		  kvm_assigned_dev_interrupt_work_handler);
+
+	if (irqchip_in_kernel(kvm)) {
+		if (assigned_irq->host_irq)
+			match->host_irq = assigned_irq->host_irq;
+		else
+			match->host_irq = match->dev->irq;
+		match->guest_irq = assigned_irq->guest_irq;
+		match->ack_notifier.gsi = assigned_irq->guest_irq;
+		match->ack_notifier.irq_acked = kvm_assigned_dev_ack_irq;
+		kvm_register_irq_ack_notifier(kvm, &match->ack_notifier);
+
+		/* Even though this is PCI, we don't want to use shared
+		 * interrupts. Sharing host devices with guest-assigned devices
+		 * on the same interrupt line is not a happy situation: there
+		 * are going to be long delays in accepting, acking, etc.
+		 */
+		if (request_irq(match->host_irq, kvm_assigned_dev_intr, 0,
+				"kvm_assigned_device", (void *)match)) {
+			printk(KERN_INFO "%s: couldn't allocate irq for pv "
+			       "device\n", __func__);
+			r = -EIO;
+			goto out;
+		}
+	}
+
+	match->irq_requested = true;
+out:
+	mutex_unlock(&kvm->lock);
+	return r;
+}
+
+static int kvm_vm_ioctl_assign_device(struct kvm *kvm,
+				      struct kvm_assigned_pci_dev *assigned_dev)
+{
+	int r = 0;
+	struct kvm_assigned_dev_kernel *match;
+	struct pci_dev *dev;
+
+	mutex_lock(&kvm->lock);
+
+	match = kvm_find_assigned_dev(&kvm->arch.assigned_dev_head,
+				      assigned_dev->assigned_dev_id);
+	if (match) {
+		/* device already assigned */
+		r = -EINVAL;
+		goto out;
+	}
+
+	match = kzalloc(sizeof(struct kvm_assigned_dev_kernel), GFP_KERNEL);
+	if (match == NULL) {
+		printk(KERN_INFO "%s: Couldn't allocate memory\n",
+		       __func__);
+		r = -ENOMEM;
+		goto out;
+	}
+	dev = pci_get_bus_and_slot(assigned_dev->busnr,
+				   assigned_dev->devfn);
+	if (!dev) {
+		printk(KERN_INFO "%s: host device not found\n", __func__);
+		r = -EINVAL;
+		goto out_free;
+	}
+	if (pci_enable_device(dev)) {
+		printk(KERN_INFO "%s: Could not enable PCI device\n", __func__);
+		r = -EBUSY;
+		goto out_put;
+	}
+	r = pci_request_regions(dev, "kvm_assigned_device");
+	if (r) {
+		printk(KERN_INFO "%s: Could not get access to device regions\n",
+		       __func__);
+		goto out_disable;
+	}
+	match->assigned_dev_id = assigned_dev->assigned_dev_id;
+	match->host_busnr = assigned_dev->busnr;
+	match->host_devfn = assigned_dev->devfn;
+	match->dev = dev;
+
+	match->kvm = kvm;
+
+	list_add(&match->list, &kvm->arch.assigned_dev_head);
+
+out:
+	mutex_unlock(&kvm->lock);
+	return r;
+out_disable:
+	pci_disable_device(dev);
+out_put:
+	pci_dev_put(dev);
+out_free:
+	kfree(match);
+	mutex_unlock(&kvm->lock);
+	return r;
+}
+
+static void kvm_free_assigned_devices(struct kvm *kvm)
+{
+	struct list_head *ptr, *ptr2;
+	struct kvm_assigned_dev_kernel *assigned_dev;
+
+	list_for_each_safe(ptr, ptr2, &kvm->arch.assigned_dev_head) {
+		assigned_dev = list_entry(ptr,
+					  struct kvm_assigned_dev_kernel,
+					  list);
+
+		if (irqchip_in_kernel(kvm) && assigned_dev->irq_requested) {
+			free_irq(assigned_dev->host_irq,
+				 (void *)assigned_dev);
+
+			kvm_unregister_irq_ack_notifier(kvm,
+							&assigned_dev->
+							ack_notifier);
+		}
+
+		if (cancel_work_sync(&assigned_dev->interrupt_work))
+			/* We had pending work. That means we will have to take
+			 * care of kvm_put_kvm.
+			 */
+			kvm_put_kvm(kvm);
+
+		pci_release_regions(assigned_dev->dev);
+		pci_disable_device(assigned_dev->dev);
+		pci_dev_put(assigned_dev->dev);
+
+		list_del(&assigned_dev->list);
+		kfree(assigned_dev);
+	}
+}
 
 unsigned long segment_base(u16 selector)
 {
@@ -1766,6 +1985,28 @@ long kvm_arch_vm_ioctl(struct file *filp,
 		r = 0;
 		break;
 	}
+	case KVM_ASSIGN_PCI_DEVICE: {
+		struct kvm_assigned_pci_dev assigned_dev;
+
+		r = -EFAULT;
+		if (copy_from_user(&assigned_dev, argp, sizeof assigned_dev))
+			goto out;
+		r = kvm_vm_ioctl_assign_device(kvm, &assigned_dev);
+		if (r)
+			goto out;
+		break;
+	}
+	case KVM_ASSIGN_IRQ: {
+		struct kvm_assigned_irq assigned_irq;
+
+		r = -EFAULT;
+		if (copy_from_user(&assigned_irq, argp, sizeof assigned_irq))
+			goto out;
+		r = kvm_vm_ioctl_assign_irq(kvm, &assigned_irq);
+		if (r)
+			goto out;
+		break;
+	}
 	case KVM_GET_PIT: {
 		struct kvm_pit_state ps;
 		r = -EFAULT;
@@ -3945,6 +4186,7 @@ struct  kvm *kvm_arch_create_vm(void)
 		return ERR_PTR(-ENOMEM);
 
 	INIT_LIST_HEAD(&kvm->arch.active_mmu_pages);
+	INIT_LIST_HEAD(&kvm->arch.assigned_dev_head);
 
 	return kvm;
 }
@@ -3977,6 +4219,7 @@ static void kvm_free_vcpus(struct kvm *kvm)
 
 void kvm_arch_destroy_vm(struct kvm *kvm)
 {
+	kvm_free_assigned_devices(kvm);
 	kvm_free_pit(kvm);
 	kfree(kvm->arch.vpic);
 	kfree(kvm->arch.vioapic);
diff --git a/include/asm-x86/kvm_host.h b/include/asm-x86/kvm_host.h
index e4297b8..54e92a0 100644
--- a/include/asm-x86/kvm_host.h
+++ b/include/asm-x86/kvm_host.h
@@ -327,6 +327,21 @@ struct kvm_irq_ack_notifier {
 	void (*irq_acked)(struct kvm_irq_ack_notifier *kian);
 };
 
+struct kvm_assigned_dev_kernel {
+	struct kvm_irq_ack_notifier ack_notifier;
+	struct work_struct interrupt_work;
+	struct list_head list;
+	struct kvm_assigned_pci_dev assigned_dev;
+	int assigned_dev_id;
+	int host_busnr;
+	int host_devfn;
+	int host_irq;
+	int guest_irq;
+	int irq_requested;
+	struct pci_dev *dev;
+	struct kvm *kvm;
+};
+
 struct kvm_arch{
 	int naliases;
 	struct kvm_mem_alias aliases[KVM_ALIAS_SLOTS];
@@ -339,6 +354,7 @@ struct kvm_arch{
 	 * Hash table of struct kvm_mmu_page.
 	 */
 	struct list_head active_mmu_pages;
+	struct list_head assigned_dev_head;
 	struct kvm_pic *vpic;
 	struct kvm_ioapic *vioapic;
 	struct kvm_pit *vpit;
diff --git a/include/linux/kvm.h b/include/linux/kvm.h
index d29b648..ef4bc6f 100644
--- a/include/linux/kvm.h
+++ b/include/linux/kvm.h
@@ -383,6 +383,7 @@ struct kvm_trace_rec {
 #define KVM_CAP_MP_STATE 14
 #define KVM_CAP_COALESCED_MMIO 15
 #define KVM_CAP_SYNC_MMU 16  /* Changes to host mmap are reflected in guest */
+#define KVM_CAP_DEVICE_ASSIGNMENT 17
 
 /*
  * ioctls for VM fds
@@ -412,6 +413,10 @@ struct kvm_trace_rec {
 			_IOW(KVMIO,  0x67, struct kvm_coalesced_mmio_zone)
 #define KVM_UNREGISTER_COALESCED_MMIO \
 			_IOW(KVMIO,  0x68, struct kvm_coalesced_mmio_zone)
+#define KVM_ASSIGN_PCI_DEVICE _IOR(KVMIO, 0x69, \
+				   struct kvm_assigned_pci_dev)
+#define KVM_ASSIGN_IRQ _IOR(KVMIO, 0x70, \
+			    struct kvm_assigned_irq)
 
 /*
  * ioctls for vcpu fds
@@ -476,4 +481,18 @@ struct kvm_trace_rec {
 #define KVM_TRC_STLB_INVAL       (KVM_TRC_HANDLER + 0x18)
 #define KVM_TRC_PPC_INSTR        (KVM_TRC_HANDLER + 0x19)
 
+struct kvm_assigned_pci_dev {
+	__u32 assigned_dev_id;
+	__u32 busnr;
+	__u32 devfn;
+	__u32 flags;
+};
+
+struct kvm_assigned_irq {
+	__u32 assigned_dev_id;
+	__u32 host_irq;
+	__u32 guest_irq;
+	__u32 flags;
+};
+
 #endif
-- 
1.6.0.1

