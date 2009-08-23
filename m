Return-Path: <linux-kernel-owner+w=401wt.eu-S933556AbZHWL6n@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933556AbZHWL6n (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Aug 2009 07:58:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933649AbZHWL6k
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Aug 2009 07:58:40 -0400
Received: from mx1.redhat.com ([209.132.183.28]:2068 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933552AbZHWL4u (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Aug 2009 07:56:50 -0400
From: Avi Kivity <avi@redhat.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 22/46] KVM: add ioeventfd support
Date: Sun, 23 Aug 2009 14:56:21 +0300
Message-Id: <1251028605-31977-23-git-send-email-avi@redhat.com>
In-Reply-To: <1251028605-31977-1-git-send-email-avi@redhat.com>
References: <1251028605-31977-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Gregory Haskins <ghaskins@novell.com>

ioeventfd is a mechanism to register PIO/MMIO regions to trigger an eventfd
signal when written to by a guest.  Host userspace can register any
arbitrary IO address with a corresponding eventfd and then pass the eventfd
to a specific end-point of interest for handling.

Normal IO requires a blocking round-trip since the operation may cause
side-effects in the emulated model or may return data to the caller.
Therefore, an IO in KVM traps from the guest to the host, causes a VMX/SVM
"heavy-weight" exit back to userspace, and is ultimately serviced by qemu's
device model synchronously before returning control back to the vcpu.

However, there is a subclass of IO which acts purely as a trigger for
other IO (such as to kick off an out-of-band DMA request, etc).  For these
patterns, the synchronous call is particularly expensive since we really
only want to simply get our notification transmitted asychronously and
return as quickly as possible.  All the sychronous infrastructure to ensure
proper data-dependencies are met in the normal IO case are just unecessary
overhead for signalling.  This adds additional computational load on the
system, as well as latency to the signalling path.

Therefore, we provide a mechanism for registration of an in-kernel trigger
point that allows the VCPU to only require a very brief, lightweight
exit just long enough to signal an eventfd.  This also means that any
clients compatible with the eventfd interface (which includes userspace
and kernelspace equally well) can now register to be notified. The end
result should be a more flexible and higher performance notification API
for the backend KVM hypervisor and perhipheral components.

To test this theory, we built a test-harness called "doorbell".  This
module has a function called "doorbell_ring()" which simply increments a
counter for each time the doorbell is signaled.  It supports signalling
from either an eventfd, or an ioctl().

We then wired up two paths to the doorbell: One via QEMU via a registered
io region and through the doorbell ioctl().  The other is direct via
ioeventfd.

You can download this test harness here:

ftp://ftp.novell.com/dev/ghaskins/doorbell.tar.bz2

The measured results are as follows:

qemu-mmio:       110000 iops, 9.09us rtt
ioeventfd-mmio: 200100 iops, 5.00us rtt
ioeventfd-pio:  367300 iops, 2.72us rtt

I didn't measure qemu-pio, because I have to figure out how to register a
PIO region with qemu's device model, and I got lazy.  However, for now we
can extrapolate based on the data from the NULLIO runs of +2.56us for MMIO,
and -350ns for HC, we get:

qemu-pio:      153139 iops, 6.53us rtt
ioeventfd-hc: 412585 iops, 2.37us rtt

these are just for fun, for now, until I can gather more data.

Here is a graph for your convenience:

http://developer.novell.com/wiki/images/7/76/Iofd-chart.png

The conclusion to draw is that we save about 4us by skipping the userspace
hop.

--------------------

Signed-off-by: Gregory Haskins <ghaskins@novell.com>
Acked-by: Michael S. Tsirkin <mst@redhat.com>
Signed-off-by: Avi Kivity <avi@redhat.com>
---
 arch/x86/kvm/x86.c       |    1 +
 include/linux/kvm.h      |   24 +++++
 include/linux/kvm_host.h |   10 ++-
 virt/kvm/eventfd.c       |  251 +++++++++++++++++++++++++++++++++++++++++++++-
 virt/kvm/kvm_main.c      |   11 ++-
 5 files changed, 293 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 1fd67dd..a2f5a9c 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -1212,6 +1212,7 @@ int kvm_dev_ioctl_check_extension(long ext)
 	case KVM_CAP_IRQ_INJECT_STATUS:
 	case KVM_CAP_ASSIGN_DEV_IRQ:
 	case KVM_CAP_IRQFD:
+	case KVM_CAP_IOEVENTFD:
 	case KVM_CAP_PIT2:
 	case KVM_CAP_PIT_STATE2:
 		r = 1;
diff --git a/include/linux/kvm.h b/include/linux/kvm.h
index a74a1fc..230a91a 100644
--- a/include/linux/kvm.h
+++ b/include/linux/kvm.h
@@ -307,6 +307,28 @@ struct kvm_guest_debug {
 	struct kvm_guest_debug_arch arch;
 };
 
+enum {
+	kvm_ioeventfd_flag_nr_datamatch,
+	kvm_ioeventfd_flag_nr_pio,
+	kvm_ioeventfd_flag_nr_deassign,
+	kvm_ioeventfd_flag_nr_max,
+};
+
+#define KVM_IOEVENTFD_FLAG_DATAMATCH (1 << kvm_ioeventfd_flag_nr_datamatch)
+#define KVM_IOEVENTFD_FLAG_PIO       (1 << kvm_ioeventfd_flag_nr_pio)
+#define KVM_IOEVENTFD_FLAG_DEASSIGN  (1 << kvm_ioeventfd_flag_nr_deassign)
+
+#define KVM_IOEVENTFD_VALID_FLAG_MASK  ((1 << kvm_ioeventfd_flag_nr_max) - 1)
+
+struct kvm_ioeventfd {
+	__u64 datamatch;
+	__u64 addr;        /* legal pio/mmio address */
+	__u32 len;         /* 1, 2, 4, or 8 bytes    */
+	__s32 fd;
+	__u32 flags;
+	__u8  pad[36];
+};
+
 #define KVM_TRC_SHIFT           16
 /*
  * kvm trace categories
@@ -412,6 +434,7 @@ struct kvm_guest_debug {
 #ifdef __KVM_HAVE_PIT_STATE2
 #define KVM_CAP_PIT_STATE2 35
 #endif
+#define KVM_CAP_IOEVENTFD 36
 
 #ifdef KVM_CAP_IRQ_ROUTING
 
@@ -520,6 +543,7 @@ struct kvm_irqfd {
 #define KVM_IRQFD                  _IOW(KVMIO, 0x76, struct kvm_irqfd)
 #define KVM_CREATE_PIT2		   _IOW(KVMIO, 0x77, struct kvm_pit_config)
 #define KVM_SET_BOOT_CPU_ID        _IO(KVMIO, 0x78)
+#define KVM_IOEVENTFD             _IOW(KVMIO, 0x79, struct kvm_ioeventfd)
 
 /*
  * ioctls for vcpu fds
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 983b0bd..6ec9fc5 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -155,6 +155,7 @@ struct kvm {
 		spinlock_t        lock;
 		struct list_head  items;
 	} irqfds;
+	struct list_head ioeventfds;
 #endif
 	struct kvm_vm_stat stat;
 	struct kvm_arch arch;
@@ -528,19 +529,24 @@ static inline void kvm_free_irq_routing(struct kvm *kvm) {}
 
 #ifdef CONFIG_HAVE_KVM_EVENTFD
 
-void kvm_irqfd_init(struct kvm *kvm);
+void kvm_eventfd_init(struct kvm *kvm);
 int kvm_irqfd(struct kvm *kvm, int fd, int gsi, int flags);
 void kvm_irqfd_release(struct kvm *kvm);
+int kvm_ioeventfd(struct kvm *kvm, struct kvm_ioeventfd *args);
 
 #else
 
-static inline void kvm_irqfd_init(struct kvm *kvm) {}
+static inline void kvm_eventfd_init(struct kvm *kvm) {}
 static inline int kvm_irqfd(struct kvm *kvm, int fd, int gsi, int flags)
 {
 	return -EINVAL;
 }
 
 static inline void kvm_irqfd_release(struct kvm *kvm) {}
+static inline int kvm_ioeventfd(struct kvm *kvm, struct kvm_ioeventfd *args)
+{
+	return -ENOSYS;
+}
 
 #endif /* CONFIG_HAVE_KVM_EVENTFD */
 
diff --git a/virt/kvm/eventfd.c b/virt/kvm/eventfd.c
index 4092b8d..99017e8 100644
--- a/virt/kvm/eventfd.c
+++ b/virt/kvm/eventfd.c
@@ -21,6 +21,7 @@
  */
 
 #include <linux/kvm_host.h>
+#include <linux/kvm.h>
 #include <linux/workqueue.h>
 #include <linux/syscalls.h>
 #include <linux/wait.h>
@@ -28,6 +29,9 @@
 #include <linux/file.h>
 #include <linux/list.h>
 #include <linux/eventfd.h>
+#include <linux/kernel.h>
+
+#include "iodev.h"
 
 /*
  * --------------------------------------------------------------------
@@ -234,10 +238,11 @@ fail:
 }
 
 void
-kvm_irqfd_init(struct kvm *kvm)
+kvm_eventfd_init(struct kvm *kvm)
 {
 	spin_lock_init(&kvm->irqfds.lock);
 	INIT_LIST_HEAD(&kvm->irqfds.items);
+	INIT_LIST_HEAD(&kvm->ioeventfds);
 }
 
 /*
@@ -327,3 +332,247 @@ static void __exit irqfd_module_exit(void)
 
 module_init(irqfd_module_init);
 module_exit(irqfd_module_exit);
+
+/*
+ * --------------------------------------------------------------------
+ * ioeventfd: translate a PIO/MMIO memory write to an eventfd signal.
+ *
+ * userspace can register a PIO/MMIO address with an eventfd for receiving
+ * notification when the memory has been touched.
+ * --------------------------------------------------------------------
+ */
+
+struct _ioeventfd {
+	struct list_head     list;
+	u64                  addr;
+	int                  length;
+	struct eventfd_ctx  *eventfd;
+	u64                  datamatch;
+	struct kvm_io_device dev;
+	bool                 wildcard;
+};
+
+static inline struct _ioeventfd *
+to_ioeventfd(struct kvm_io_device *dev)
+{
+	return container_of(dev, struct _ioeventfd, dev);
+}
+
+static void
+ioeventfd_release(struct _ioeventfd *p)
+{
+	eventfd_ctx_put(p->eventfd);
+	list_del(&p->list);
+	kfree(p);
+}
+
+static bool
+ioeventfd_in_range(struct _ioeventfd *p, gpa_t addr, int len, const void *val)
+{
+	u64 _val;
+
+	if (!(addr == p->addr && len == p->length))
+		/* address-range must be precise for a hit */
+		return false;
+
+	if (p->wildcard)
+		/* all else equal, wildcard is always a hit */
+		return true;
+
+	/* otherwise, we have to actually compare the data */
+
+	BUG_ON(!IS_ALIGNED((unsigned long)val, len));
+
+	switch (len) {
+	case 1:
+		_val = *(u8 *)val;
+		break;
+	case 2:
+		_val = *(u16 *)val;
+		break;
+	case 4:
+		_val = *(u32 *)val;
+		break;
+	case 8:
+		_val = *(u64 *)val;
+		break;
+	default:
+		return false;
+	}
+
+	return _val == p->datamatch ? true : false;
+}
+
+/* MMIO/PIO writes trigger an event if the addr/val match */
+static int
+ioeventfd_write(struct kvm_io_device *this, gpa_t addr, int len,
+		const void *val)
+{
+	struct _ioeventfd *p = to_ioeventfd(this);
+
+	if (!ioeventfd_in_range(p, addr, len, val))
+		return -EOPNOTSUPP;
+
+	eventfd_signal(p->eventfd, 1);
+	return 0;
+}
+
+/*
+ * This function is called as KVM is completely shutting down.  We do not
+ * need to worry about locking just nuke anything we have as quickly as possible
+ */
+static void
+ioeventfd_destructor(struct kvm_io_device *this)
+{
+	struct _ioeventfd *p = to_ioeventfd(this);
+
+	ioeventfd_release(p);
+}
+
+static const struct kvm_io_device_ops ioeventfd_ops = {
+	.write      = ioeventfd_write,
+	.destructor = ioeventfd_destructor,
+};
+
+/* assumes kvm->slots_lock held */
+static bool
+ioeventfd_check_collision(struct kvm *kvm, struct _ioeventfd *p)
+{
+	struct _ioeventfd *_p;
+
+	list_for_each_entry(_p, &kvm->ioeventfds, list)
+		if (_p->addr == p->addr && _p->length == p->length &&
+		    (_p->wildcard || p->wildcard ||
+		     _p->datamatch == p->datamatch))
+			return true;
+
+	return false;
+}
+
+static int
+kvm_assign_ioeventfd(struct kvm *kvm, struct kvm_ioeventfd *args)
+{
+	int                       pio = args->flags & KVM_IOEVENTFD_FLAG_PIO;
+	struct kvm_io_bus        *bus = pio ? &kvm->pio_bus : &kvm->mmio_bus;
+	struct _ioeventfd        *p;
+	struct eventfd_ctx       *eventfd;
+	int                       ret;
+
+	/* must be natural-word sized */
+	switch (args->len) {
+	case 1:
+	case 2:
+	case 4:
+	case 8:
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	/* check for range overflow */
+	if (args->addr + args->len < args->addr)
+		return -EINVAL;
+
+	/* check for extra flags that we don't understand */
+	if (args->flags & ~KVM_IOEVENTFD_VALID_FLAG_MASK)
+		return -EINVAL;
+
+	eventfd = eventfd_ctx_fdget(args->fd);
+	if (IS_ERR(eventfd))
+		return PTR_ERR(eventfd);
+
+	p = kzalloc(sizeof(*p), GFP_KERNEL);
+	if (!p) {
+		ret = -ENOMEM;
+		goto fail;
+	}
+
+	INIT_LIST_HEAD(&p->list);
+	p->addr    = args->addr;
+	p->length  = args->len;
+	p->eventfd = eventfd;
+
+	/* The datamatch feature is optional, otherwise this is a wildcard */
+	if (args->flags & KVM_IOEVENTFD_FLAG_DATAMATCH)
+		p->datamatch = args->datamatch;
+	else
+		p->wildcard = true;
+
+	down_write(&kvm->slots_lock);
+
+	/* Verify that there isnt a match already */
+	if (ioeventfd_check_collision(kvm, p)) {
+		ret = -EEXIST;
+		goto unlock_fail;
+	}
+
+	kvm_iodevice_init(&p->dev, &ioeventfd_ops);
+
+	ret = __kvm_io_bus_register_dev(bus, &p->dev);
+	if (ret < 0)
+		goto unlock_fail;
+
+	list_add_tail(&p->list, &kvm->ioeventfds);
+
+	up_write(&kvm->slots_lock);
+
+	return 0;
+
+unlock_fail:
+	up_write(&kvm->slots_lock);
+
+fail:
+	kfree(p);
+	eventfd_ctx_put(eventfd);
+
+	return ret;
+}
+
+static int
+kvm_deassign_ioeventfd(struct kvm *kvm, struct kvm_ioeventfd *args)
+{
+	int                       pio = args->flags & KVM_IOEVENTFD_FLAG_PIO;
+	struct kvm_io_bus        *bus = pio ? &kvm->pio_bus : &kvm->mmio_bus;
+	struct _ioeventfd        *p, *tmp;
+	struct eventfd_ctx       *eventfd;
+	int                       ret = -ENOENT;
+
+	eventfd = eventfd_ctx_fdget(args->fd);
+	if (IS_ERR(eventfd))
+		return PTR_ERR(eventfd);
+
+	down_write(&kvm->slots_lock);
+
+	list_for_each_entry_safe(p, tmp, &kvm->ioeventfds, list) {
+		bool wildcard = !(args->flags & KVM_IOEVENTFD_FLAG_DATAMATCH);
+
+		if (p->eventfd != eventfd  ||
+		    p->addr != args->addr  ||
+		    p->length != args->len ||
+		    p->wildcard != wildcard)
+			continue;
+
+		if (!p->wildcard && p->datamatch != args->datamatch)
+			continue;
+
+		__kvm_io_bus_unregister_dev(bus, &p->dev);
+		ioeventfd_release(p);
+		ret = 0;
+		break;
+	}
+
+	up_write(&kvm->slots_lock);
+
+	eventfd_ctx_put(eventfd);
+
+	return ret;
+}
+
+int
+kvm_ioeventfd(struct kvm *kvm, struct kvm_ioeventfd *args)
+{
+	if (args->flags & KVM_IOEVENTFD_FLAG_DEASSIGN)
+		return kvm_deassign_ioeventfd(kvm, args);
+
+	return kvm_assign_ioeventfd(kvm, args);
+}
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 9c2fd02..d7b9bbb 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -979,7 +979,7 @@ static struct kvm *kvm_create_vm(void)
 	spin_lock_init(&kvm->mmu_lock);
 	spin_lock_init(&kvm->requests_lock);
 	kvm_io_bus_init(&kvm->pio_bus);
-	kvm_irqfd_init(kvm);
+	kvm_eventfd_init(kvm);
 	mutex_init(&kvm->lock);
 	mutex_init(&kvm->irq_lock);
 	kvm_io_bus_init(&kvm->mmio_bus);
@@ -2271,6 +2271,15 @@ static long kvm_vm_ioctl(struct file *filp,
 		r = kvm_irqfd(kvm, data.fd, data.gsi, data.flags);
 		break;
 	}
+	case KVM_IOEVENTFD: {
+		struct kvm_ioeventfd data;
+
+		r = -EFAULT;
+		if (copy_from_user(&data, argp, sizeof data))
+			goto out;
+		r = kvm_ioeventfd(kvm, &data);
+		break;
+	}
 #ifdef CONFIG_KVM_APIC_ARCHITECTURE
 	case KVM_SET_BOOT_CPU_ID:
 		r = 0;
-- 
1.6.4.1

