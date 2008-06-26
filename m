Return-Path: <linux-kernel-owner+w=401wt.eu-S1758229AbYFZMfa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758229AbYFZMfa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2008 08:35:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752392AbYFZM3D
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jun 2008 08:29:03 -0400
Received: from il.qumranet.com ([212.179.150.194]:32424 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752485AbYFZM2o (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2008 08:28:44 -0400
From: Avi Kivity <avi@qumranet.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Laurent Vivier <Laurent.Vivier@bull.net>
Subject: [PATCH 34/50] KVM: Add coalesced MMIO support (common part)
Date: Thu, 26 Jun 2008 15:28:16 +0300
Message-Id: <1214483312-9265-35-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.6
In-Reply-To: <1214483312-9265-1-git-send-email-avi@qumranet.com>
References: <1214483312-9265-1-git-send-email-avi@qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Laurent Vivier <Laurent.Vivier@bull.net>

This patch adds all needed structures to coalesce MMIOs.
Until an architecture uses it, it is not compiled.

Coalesced MMIO introduces two ioctl() to define where are the MMIO zones that
can be coalesced:

- KVM_REGISTER_COALESCED_MMIO registers a coalesced MMIO zone.
  It requests one parameter (struct kvm_coalesced_mmio_zone) which defines
  a memory area where MMIOs can be coalesced until the next switch to
  user space. The maximum number of MMIO zones is KVM_COALESCED_MMIO_ZONE_MAX.

- KVM_UNREGISTER_COALESCED_MMIO cancels all registered zones inside
  the given bounds (bounds are also given by struct kvm_coalesced_mmio_zone).

The userspace client can check kernel coalesced MMIO availability by asking
ioctl(KVM_CHECK_EXTENSION) for the KVM_CAP_COALESCED_MMIO capability.
The ioctl() call to KVM_CAP_COALESCED_MMIO will return 0 if not supported,
or the page offset where will be stored the ring buffer.
The page offset depends on the architecture.

After an ioctl(KVM_RUN), the first page of the KVM memory mapped points to
a kvm_run structure. The offset given by KVM_CAP_COALESCED_MMIO is
an offset to the coalesced MMIO ring expressed in PAGE_SIZE relatively
to the address of the start of th kvm_run structure. The MMIO ring buffer
is defined by the structure kvm_coalesced_mmio_ring.

[akio: fix oops during guest shutdown]

Signed-off-by: Laurent Vivier <Laurent.Vivier@bull.net>
Signed-off-by: Akio Takebe <takebe_akio@jp.fujitsu.com>
Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 include/linux/kvm.h       |   29 ++++++++
 include/linux/kvm_host.h  |    4 +
 virt/kvm/coalesced_mmio.c |  156 +++++++++++++++++++++++++++++++++++++++++++++
 virt/kvm/coalesced_mmio.h |   23 +++++++
 virt/kvm/kvm_main.c       |   57 ++++++++++++++++
 5 files changed, 269 insertions(+), 0 deletions(-)
 create mode 100644 virt/kvm/coalesced_mmio.c
 create mode 100644 virt/kvm/coalesced_mmio.h

diff --git a/include/linux/kvm.h b/include/linux/kvm.h
index a281afe..1c908ac 100644
--- a/include/linux/kvm.h
+++ b/include/linux/kvm.h
@@ -173,6 +173,30 @@ struct kvm_run {
 	};
 };
 
+/* for KVM_REGISTER_COALESCED_MMIO / KVM_UNREGISTER_COALESCED_MMIO */
+
+struct kvm_coalesced_mmio_zone {
+	__u64 addr;
+	__u32 size;
+	__u32 pad;
+};
+
+struct kvm_coalesced_mmio {
+	__u64 phys_addr;
+	__u32 len;
+	__u32 pad;
+	__u8  data[8];
+};
+
+struct kvm_coalesced_mmio_ring {
+	__u32 first, last;
+	struct kvm_coalesced_mmio coalesced_mmio[0];
+};
+
+#define KVM_COALESCED_MMIO_MAX \
+	((PAGE_SIZE - sizeof(struct kvm_coalesced_mmio_ring)) / \
+	 sizeof(struct kvm_coalesced_mmio))
+
 /* for KVM_TRANSLATE */
 struct kvm_translation {
 	/* in */
@@ -346,6 +370,7 @@ struct kvm_trace_rec {
 #define KVM_CAP_NOP_IO_DELAY 12
 #define KVM_CAP_PV_MMU 13
 #define KVM_CAP_MP_STATE 14
+#define KVM_CAP_COALESCED_MMIO 15
 
 /*
  * ioctls for VM fds
@@ -371,6 +396,10 @@ struct kvm_trace_rec {
 #define KVM_CREATE_PIT		  _IO(KVMIO,  0x64)
 #define KVM_GET_PIT		  _IOWR(KVMIO, 0x65, struct kvm_pit_state)
 #define KVM_SET_PIT		  _IOR(KVMIO,  0x66, struct kvm_pit_state)
+#define KVM_REGISTER_COALESCED_MMIO \
+			_IOW(KVMIO,  0x67, struct kvm_coalesced_mmio_zone)
+#define KVM_UNREGISTER_COALESCED_MMIO \
+			_IOW(KVMIO,  0x68, struct kvm_coalesced_mmio_zone)
 
 /*
  * ioctls for vcpu fds
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 499ff06..d220b49 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -117,6 +117,10 @@ struct kvm {
 	struct kvm_vm_stat stat;
 	struct kvm_arch arch;
 	atomic_t users_count;
+#ifdef KVM_COALESCED_MMIO_PAGE_OFFSET
+	struct kvm_coalesced_mmio_dev *coalesced_mmio_dev;
+	struct kvm_coalesced_mmio_ring *coalesced_mmio_ring;
+#endif
 };
 
 /* The guest did something we don't support. */
diff --git a/virt/kvm/coalesced_mmio.c b/virt/kvm/coalesced_mmio.c
new file mode 100644
index 0000000..5ae620d
--- /dev/null
+++ b/virt/kvm/coalesced_mmio.c
@@ -0,0 +1,156 @@
+/*
+ * KVM coalesced MMIO
+ *
+ * Copyright (c) 2008 Bull S.A.S.
+ *
+ *  Author: Laurent Vivier <Laurent.Vivier@bull.net>
+ *
+ */
+
+#include "iodev.h"
+
+#include <linux/kvm_host.h>
+#include <linux/kvm.h>
+
+#include "coalesced_mmio.h"
+
+static int coalesced_mmio_in_range(struct kvm_io_device *this,
+				   gpa_t addr, int len, int is_write)
+{
+	struct kvm_coalesced_mmio_dev *dev =
+				(struct kvm_coalesced_mmio_dev*)this->private;
+	struct kvm_coalesced_mmio_zone *zone;
+	int next;
+	int i;
+
+	if (!is_write)
+		return 0;
+
+	/* kvm->lock is taken by the caller and must be not released before
+         * dev.read/write
+         */
+
+	/* Are we able to batch it ? */
+
+	/* last is the first free entry
+	 * check if we don't meet the first used entry
+	 * there is always one unused entry in the buffer
+	 */
+
+	next = (dev->kvm->coalesced_mmio_ring->last + 1) %
+							KVM_COALESCED_MMIO_MAX;
+	if (next == dev->kvm->coalesced_mmio_ring->first) {
+		/* full */
+		return 0;
+	}
+
+	/* is it in a batchable area ? */
+
+	for (i = 0; i < dev->nb_zones; i++) {
+		zone = &dev->zone[i];
+
+		/* (addr,len) is fully included in
+		 * (zone->addr, zone->size)
+		 */
+
+		if (zone->addr <= addr &&
+		    addr + len <= zone->addr + zone->size)
+			return 1;
+	}
+	return 0;
+}
+
+static void coalesced_mmio_write(struct kvm_io_device *this,
+				 gpa_t addr, int len, const void *val)
+{
+	struct kvm_coalesced_mmio_dev *dev =
+				(struct kvm_coalesced_mmio_dev*)this->private;
+	struct kvm_coalesced_mmio_ring *ring = dev->kvm->coalesced_mmio_ring;
+
+	/* kvm->lock must be taken by caller before call to in_range()*/
+
+	/* copy data in first free entry of the ring */
+
+	ring->coalesced_mmio[ring->last].phys_addr = addr;
+	ring->coalesced_mmio[ring->last].len = len;
+	memcpy(ring->coalesced_mmio[ring->last].data, val, len);
+	smp_wmb();
+	ring->last = (ring->last + 1) % KVM_COALESCED_MMIO_MAX;
+}
+
+static void coalesced_mmio_destructor(struct kvm_io_device *this)
+{
+	kfree(this);
+}
+
+int kvm_coalesced_mmio_init(struct kvm *kvm)
+{
+	struct kvm_coalesced_mmio_dev *dev;
+
+	dev = kzalloc(sizeof(struct kvm_coalesced_mmio_dev), GFP_KERNEL);
+	if (!dev)
+		return -ENOMEM;
+	dev->dev.write  = coalesced_mmio_write;
+	dev->dev.in_range  = coalesced_mmio_in_range;
+	dev->dev.destructor  = coalesced_mmio_destructor;
+	dev->dev.private  = dev;
+	dev->kvm = kvm;
+	kvm->coalesced_mmio_dev = dev;
+	kvm_io_bus_register_dev(&kvm->mmio_bus, &dev->dev);
+
+	return 0;
+}
+
+int kvm_vm_ioctl_register_coalesced_mmio(struct kvm *kvm,
+				         struct kvm_coalesced_mmio_zone *zone)
+{
+	struct kvm_coalesced_mmio_dev *dev = kvm->coalesced_mmio_dev;
+
+	if (dev == NULL)
+		return -EINVAL;
+
+	mutex_lock(&kvm->lock);
+	if (dev->nb_zones >= KVM_COALESCED_MMIO_ZONE_MAX) {
+		mutex_unlock(&kvm->lock);
+		return -ENOBUFS;
+	}
+
+	dev->zone[dev->nb_zones] = *zone;
+	dev->nb_zones++;
+
+	mutex_unlock(&kvm->lock);
+	return 0;
+}
+
+int kvm_vm_ioctl_unregister_coalesced_mmio(struct kvm *kvm,
+					   struct kvm_coalesced_mmio_zone *zone)
+{
+	int i;
+	struct kvm_coalesced_mmio_dev *dev = kvm->coalesced_mmio_dev;
+	struct kvm_coalesced_mmio_zone *z;
+
+	if (dev == NULL)
+		return -EINVAL;
+
+	mutex_lock(&kvm->lock);
+
+	i = dev->nb_zones;
+	while(i) {
+		z = &dev->zone[i - 1];
+
+		/* unregister all zones
+		 * included in (zone->addr, zone->size)
+		 */
+
+		if (zone->addr <= z->addr &&
+		    z->addr + z->size <= zone->addr + zone->size) {
+			dev->nb_zones--;
+			*z = dev->zone[dev->nb_zones];
+		}
+		i--;
+	}
+
+	mutex_unlock(&kvm->lock);
+
+	return 0;
+}
diff --git a/virt/kvm/coalesced_mmio.h b/virt/kvm/coalesced_mmio.h
new file mode 100644
index 0000000..5ac0ec6
--- /dev/null
+++ b/virt/kvm/coalesced_mmio.h
@@ -0,0 +1,23 @@
+/*
+ * KVM coalesced MMIO
+ *
+ * Copyright (c) 2008 Bull S.A.S.
+ *
+ *  Author: Laurent Vivier <Laurent.Vivier@bull.net>
+ *
+ */
+
+#define KVM_COALESCED_MMIO_ZONE_MAX 100
+
+struct kvm_coalesced_mmio_dev {
+	struct kvm_io_device dev;
+	struct kvm *kvm;
+	int nb_zones;
+	struct kvm_coalesced_mmio_zone zone[KVM_COALESCED_MMIO_ZONE_MAX];
+};
+
+int kvm_coalesced_mmio_init(struct kvm *kvm);
+int kvm_vm_ioctl_register_coalesced_mmio(struct kvm *kvm,
+                                       struct kvm_coalesced_mmio_zone *zone);
+int kvm_vm_ioctl_unregister_coalesced_mmio(struct kvm *kvm,
+                                         struct kvm_coalesced_mmio_zone *zone);
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index d602700..f9427e2 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -47,6 +47,10 @@
 #include <asm/uaccess.h>
 #include <asm/pgtable.h>
 
+#ifdef KVM_COALESCED_MMIO_PAGE_OFFSET
+#include "coalesced_mmio.h"
+#endif
+
 MODULE_AUTHOR("Qumranet");
 MODULE_LICENSE("GPL");
 
@@ -185,10 +189,23 @@ EXPORT_SYMBOL_GPL(kvm_vcpu_uninit);
 static struct kvm *kvm_create_vm(void)
 {
 	struct kvm *kvm = kvm_arch_create_vm();
+#ifdef KVM_COALESCED_MMIO_PAGE_OFFSET
+	struct page *page;
+#endif
 
 	if (IS_ERR(kvm))
 		goto out;
 
+#ifdef KVM_COALESCED_MMIO_PAGE_OFFSET
+	page = alloc_page(GFP_KERNEL | __GFP_ZERO);
+	if (!page) {
+		kfree(kvm);
+		return ERR_PTR(-ENOMEM);
+	}
+	kvm->coalesced_mmio_ring =
+			(struct kvm_coalesced_mmio_ring *)page_address(page);
+#endif
+
 	kvm->mm = current->mm;
 	atomic_inc(&kvm->mm->mm_count);
 	spin_lock_init(&kvm->mmu_lock);
@@ -200,6 +217,9 @@ static struct kvm *kvm_create_vm(void)
 	spin_lock(&kvm_lock);
 	list_add(&kvm->vm_list, &vm_list);
 	spin_unlock(&kvm_lock);
+#ifdef KVM_COALESCED_MMIO_PAGE_OFFSET
+	kvm_coalesced_mmio_init(kvm);
+#endif
 out:
 	return kvm;
 }
@@ -242,6 +262,10 @@ static void kvm_destroy_vm(struct kvm *kvm)
 	spin_unlock(&kvm_lock);
 	kvm_io_bus_destroy(&kvm->pio_bus);
 	kvm_io_bus_destroy(&kvm->mmio_bus);
+#ifdef KVM_COALESCED_MMIO_PAGE_OFFSET
+	if (kvm->coalesced_mmio_ring != NULL)
+		free_page((unsigned long)kvm->coalesced_mmio_ring);
+#endif
 	kvm_arch_destroy_vm(kvm);
 	mmdrop(mm);
 }
@@ -826,6 +850,10 @@ static int kvm_vcpu_fault(struct vm_area_struct *vma, struct vm_fault *vmf)
 	else if (vmf->pgoff == KVM_PIO_PAGE_OFFSET)
 		page = virt_to_page(vcpu->arch.pio_data);
 #endif
+#ifdef KVM_COALESCED_MMIO_PAGE_OFFSET
+	else if (vmf->pgoff == KVM_COALESCED_MMIO_PAGE_OFFSET)
+		page = virt_to_page(vcpu->kvm->coalesced_mmio_ring);
+#endif
 	else
 		return VM_FAULT_SIGBUS;
 	get_page(page);
@@ -1148,6 +1176,32 @@ static long kvm_vm_ioctl(struct file *filp,
 			goto out;
 		break;
 	}
+#ifdef KVM_COALESCED_MMIO_PAGE_OFFSET
+	case KVM_REGISTER_COALESCED_MMIO: {
+		struct kvm_coalesced_mmio_zone zone;
+		r = -EFAULT;
+		if (copy_from_user(&zone, argp, sizeof zone))
+			goto out;
+		r = -ENXIO;
+		r = kvm_vm_ioctl_register_coalesced_mmio(kvm, &zone);
+		if (r)
+			goto out;
+		r = 0;
+		break;
+	}
+	case KVM_UNREGISTER_COALESCED_MMIO: {
+		struct kvm_coalesced_mmio_zone zone;
+		r = -EFAULT;
+		if (copy_from_user(&zone, argp, sizeof zone))
+			goto out;
+		r = -ENXIO;
+		r = kvm_vm_ioctl_unregister_coalesced_mmio(kvm, &zone);
+		if (r)
+			goto out;
+		r = 0;
+		break;
+	}
+#endif
 	default:
 		r = kvm_arch_vm_ioctl(filp, ioctl, arg);
 	}
@@ -1232,6 +1286,9 @@ static long kvm_dev_ioctl(struct file *filp,
 #ifdef CONFIG_X86
 		r += PAGE_SIZE;    /* pio data page */
 #endif
+#ifdef KVM_COALESCED_MMIO_PAGE_OFFSET
+		r += PAGE_SIZE;    /* coalesced mmio ring page */
+#endif
 		break;
 	case KVM_TRACE_ENABLE:
 	case KVM_TRACE_PAUSE:
-- 
1.5.6

