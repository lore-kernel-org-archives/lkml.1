Return-Path: <linux-kernel-owner+w=401wt.eu-S1757860AbZEZTgl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757860AbZEZTgl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 May 2009 15:36:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757902AbZEZTgb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 May 2009 15:36:31 -0400
Received: from victor.provo.novell.com ([137.65.250.26]:60258 "EHLO
	victor.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757883AbZEZTg1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 May 2009 15:36:27 -0400
From: Gregory Haskins <ghaskins@novell.com>
Subject: [KVM PATCH v4 3/3] kvm: add iosignalfd support
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, avi@redhat.com, davide@xmailserver.org,
       mtosatti@redhat.com
Date: Tue, 26 May 2009 15:15:39 -0400
Message-ID: <20090526191539.20860.1385.stgit@dev.haskins.net>
In-Reply-To: <20090526191010.20860.75372.stgit@dev.haskins.net>
References: <20090526191010.20860.75372.stgit@dev.haskins.net>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

iosignalfd is a mechanism to register PIO/MMIO regions to trigger an eventfd
signal when written to by a guest.  Host userspace can register any arbitrary
IO address with a corresponding eventfd and then pass the eventfd to a
specific end-point of interest for handling.

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
iosignalfd.

You can download this test harness here:

ftp://ftp.novell.com/dev/ghaskins/doorbell.tar.bz2

The measured results are as follows:

qemu-mmio:       110000 iops, 9.09us rtt
iosignalfd-mmio: 200100 iops, 5.00us rtt
iosignalfd-pio:  367300 iops, 2.72us rtt

I didn't measure qemu-pio, because I have to figure out how to register a
PIO region with qemu's device model, and I got lazy.  However, for now we
can extrapolate based on the data from the NULLIO runs of +2.56us for MMIO,
and -350ns for HC, we get:

qemu-pio:      153139 iops, 6.53us rtt
iosignalfd-hc: 412585 iops, 2.37us rtt

these are just for fun, for now, until I can gather more data.

Here is a graph for your convenience:

http://developer.novell.com/wiki/images/7/76/Iofd-chart.png

The conclusion to draw is that we save about 4us by skipping the userspace
hop.

--------------------

Signed-off-by: Gregory Haskins <ghaskins@novell.com>
---

 arch/x86/kvm/x86.c       |    1 
 include/linux/kvm.h      |   15 ++++
 include/linux/kvm_host.h |   10 ++-
 virt/kvm/eventfd.c       |  162 ++++++++++++++++++++++++++++++++++++++++++++++
 virt/kvm/kvm_main.c      |   11 +++
 5 files changed, 195 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 6d44dd5..31c86a3 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -1089,6 +1089,7 @@ int kvm_dev_ioctl_check_extension(long ext)
 	case KVM_CAP_IRQ_INJECT_STATUS:
 	case KVM_CAP_ASSIGN_DEV_IRQ:
 	case KVM_CAP_IRQFD:
+	case KVM_CAP_IOSIGNALFD:
 	case KVM_CAP_PIT2:
 		r = 1;
 		break;
diff --git a/include/linux/kvm.h b/include/linux/kvm.h
index 65df6f5..b63475e 100644
--- a/include/linux/kvm.h
+++ b/include/linux/kvm.h
@@ -300,6 +300,19 @@ struct kvm_guest_debug {
 	struct kvm_guest_debug_arch arch;
 };
 
+#define KVM_IOSIGNALFD_FLAG_DEASSIGN  (1 << 0)
+#define KVM_IOSIGNALFD_FLAG_PIO       (1 << 1)
+#define KVM_IOSIGNALFD_FLAG_COOKIE    (1 << 2)
+
+struct kvm_iosignalfd {
+	__u64 cookie;
+	__u64 addr;
+	__u32 len;
+	__u32 fd;
+	__u32 flags;
+	__u8  pad[12];
+};
+
 #define KVM_TRC_SHIFT           16
 /*
  * kvm trace categories
@@ -430,6 +443,7 @@ struct kvm_trace_rec {
 #ifdef __KVM_HAVE_PIT
 #define KVM_CAP_PIT2 33
 #endif
+#define KVM_CAP_IOSIGNALFD 34
 
 #ifdef KVM_CAP_IRQ_ROUTING
 
@@ -537,6 +551,7 @@ struct kvm_irqfd {
 #define KVM_DEASSIGN_DEV_IRQ       _IOW(KVMIO, 0x75, struct kvm_assigned_irq)
 #define KVM_IRQFD                  _IOW(KVMIO, 0x76, struct kvm_irqfd)
 #define KVM_CREATE_PIT2		   _IOW(KVMIO, 0x77, struct kvm_pit_config)
+#define KVM_IOSIGNALFD             _IOW(KVMIO, 0x78, struct kvm_iosignalfd)
 
 /*
  * ioctls for vcpu fds
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 7dcae4b..5b2be86 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -138,6 +138,7 @@ struct kvm {
 	struct kvm_io_bus pio_bus;
 #ifdef CONFIG_HAVE_KVM_EVENTFD
 	struct list_head irqfds;
+	struct list_head iosignalfds;
 #endif
 	struct kvm_vm_stat stat;
 	struct kvm_arch arch;
@@ -535,19 +536,24 @@ static inline void kvm_free_irq_routing(struct kvm *kvm) {}
 
 #ifdef CONFIG_HAVE_KVM_EVENTFD
 
-void kvm_irqfd_init(struct kvm *kvm);
+void kvm_eventfd_init(struct kvm *kvm);
 int kvm_irqfd(struct kvm *kvm, int fd, int gsi, int flags);
 void kvm_irqfd_release(struct kvm *kvm);
+int kvm_iosignalfd(struct kvm *kvm, struct kvm_iosignalfd *args);
 
 #else
 
-static inline void kvm_irqfd_init(struct kvm *kvm) {}
+static inline void kvm_eventfd_init(struct kvm *kvm) {}
 static inline int kvm_irqfd(struct kvm *kvm, int fd, int gsi, int flags)
 {
 	return -EINVAL;
 }
 
 static inline void kvm_irqfd_release(struct kvm *kvm) {}
+static inline int kvm_iosignalfd(struct kvm *kvm, struct kvm_iosignalfd *args)
+{
+	return -EINVAL;
+}
 
 #endif /* CONFIG_HAVE_KVM_EVENTFD */
 
diff --git a/virt/kvm/eventfd.c b/virt/kvm/eventfd.c
index c63ff6a..1112349 100644
--- a/virt/kvm/eventfd.c
+++ b/virt/kvm/eventfd.c
@@ -21,12 +21,16 @@
  */
 
 #include <linux/kvm_host.h>
+#include <linux/kvm.h>
 #include <linux/workqueue.h>
 #include <linux/syscalls.h>
 #include <linux/wait.h>
 #include <linux/poll.h>
 #include <linux/file.h>
 #include <linux/list.h>
+#include <linux/eventfd.h>
+
+#include "iodev.h"
 
 /*
  * --------------------------------------------------------------------
@@ -207,9 +211,10 @@ kvm_deassign_irqfd(struct kvm *kvm, int fd, int gsi)
 }
 
 void
-kvm_irqfd_init(struct kvm *kvm)
+kvm_eventfd_init(struct kvm *kvm)
 {
 	INIT_LIST_HEAD(&kvm->irqfds);
+	INIT_LIST_HEAD(&kvm->iosignalfds);
 }
 
 int
@@ -232,3 +237,158 @@ kvm_irqfd_release(struct kvm *kvm)
 		irqfd_release(irqfd);
 	}
 }
+
+/*
+ * --------------------------------------------------------------------
+ * iosignalfd: translate a PIO/MMIO memory write to an eventfd signal.
+ *
+ * userspace can register a PIO/MMIO address with an eventfd for recieving
+ * notification when the memory has been touched.
+ * --------------------------------------------------------------------
+ */
+
+struct _iosignalfd {
+	u64                  cookie;
+	u64                  addr;
+	size_t               length;
+	struct file         *file;
+	struct list_head     list;
+	struct kvm_io_device dev;
+};
+
+static int
+iosignalfd_in_range(struct kvm_io_device *this, gpa_t addr, int len,
+		    int is_write)
+{
+	struct _iosignalfd *p = (struct _iosignalfd *)this->private;
+
+	return ((addr >= p->addr && (addr < p->addr + p->length)));
+}
+
+/* writes trigger an event */
+static void
+iosignalfd_write(struct kvm_io_device *this, gpa_t addr, int len,
+		 const void *val)
+{
+	struct _iosignalfd *iosignalfd = (struct _iosignalfd *)this->private;
+
+	eventfd_signal(iosignalfd->file, 1);
+}
+
+/* reads return all zeros */
+static void
+iosignalfd_read(struct kvm_io_device *this, gpa_t addr, int len, void *val)
+{
+	memset(val, 0, len);
+}
+
+static void
+_iosignalfd_destructor(struct _iosignalfd *iosignalfd)
+{
+	fput(iosignalfd->file);
+	list_del(&iosignalfd->list);
+
+	kfree(iosignalfd);
+}
+
+static void
+iosignalfd_destructor(struct kvm_io_device *this)
+{
+	struct _iosignalfd *iosignalfd = (struct _iosignalfd *)this->private;
+
+	_iosignalfd_destructor(iosignalfd);
+}
+
+static int
+kvm_assign_iosignalfd(struct kvm *kvm, struct kvm_iosignalfd *args)
+{
+	int                 pio = args->flags & KVM_IOSIGNALFD_FLAG_PIO;
+	struct kvm_io_bus  *bus = pio ? &kvm->pio_bus : &kvm->mmio_bus;
+	struct _iosignalfd *iosignalfd;
+	struct file        *file;
+	int                 ret;
+
+	file = eventfd_fget(args->fd);
+	if (IS_ERR(file)) {
+		ret = PTR_ERR(file);
+		printk(KERN_ERR "iosignalfd: failed to get %d eventfd: %d\n",
+		       args->fd, ret);
+		return ret;
+	}
+
+	iosignalfd = kzalloc(sizeof(*iosignalfd), GFP_KERNEL);
+	if (!iosignalfd) {
+		printk(KERN_ERR "iosignalfd: memory pressure\n");
+		fput(file);
+		return -ENOMEM;
+	}
+
+	iosignalfd->dev.read       = iosignalfd_read;
+	iosignalfd->dev.write      = iosignalfd_write;
+	iosignalfd->dev.in_range   = iosignalfd_in_range;
+	iosignalfd->dev.destructor = iosignalfd_destructor;
+	iosignalfd->dev.private    = iosignalfd;
+
+	iosignalfd->cookie         = args->cookie;
+	iosignalfd->addr           = args->addr;
+	iosignalfd->length         = args->len;
+	iosignalfd->file           = file;
+	INIT_LIST_HEAD(&iosignalfd->list);
+
+	ret = kvm_io_bus_register_dev(bus, &iosignalfd->dev);
+	if (ret < 0) {
+		printk(KERN_ERR "iosignalfd: failed to register IODEV: %d\n",
+		       ret);
+		goto fail;
+	}
+
+	mutex_lock(&kvm->lock);
+	list_add_tail(&iosignalfd->list, &kvm->iosignalfds);
+	mutex_unlock(&kvm->lock);
+
+	return 0;
+
+fail:
+	/*
+	 * This doesn't take a lock, but the failure case will never result
+	 * in the list being populated anyway
+	 */
+	_iosignalfd_destructor(iosignalfd);
+
+	return ret;
+}
+
+static int
+kvm_deassign_iosignalfd(struct kvm *kvm, struct kvm_iosignalfd *args)
+{
+	int                   pio = args->flags & KVM_IOSIGNALFD_FLAG_PIO;
+	struct kvm_io_bus    *bus = pio ? &kvm->pio_bus : &kvm->mmio_bus;
+	struct _iosignalfd   *iosignalfd, *tmp;
+
+	mutex_lock(&kvm->lock);
+
+	list_for_each_entry_safe(iosignalfd, tmp, &kvm->iosignalfds, list) {
+		if (iosignalfd->addr != args->addr)
+			continue;
+
+		if ((args->flags & KVM_IOSIGNALFD_FLAG_COOKIE) &&
+		    (iosignalfd->cookie != args->cookie))
+			continue;
+
+		kvm_io_bus_unregister_dev(bus, &iosignalfd->dev);
+		_iosignalfd_destructor(iosignalfd);
+	}
+
+	mutex_unlock(&kvm->lock);
+
+	return 0;
+}
+
+int
+kvm_iosignalfd(struct kvm *kvm, struct kvm_iosignalfd *args)
+{
+	if (args->flags & KVM_IOSIGNALFD_FLAG_DEASSIGN)
+		return kvm_deassign_iosignalfd(kvm, args);
+
+	return kvm_assign_iosignalfd(kvm, args);
+}
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 4c36ac8..79fdc08 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -983,7 +983,7 @@ static struct kvm *kvm_create_vm(void)
 	atomic_inc(&kvm->mm->mm_count);
 	spin_lock_init(&kvm->mmu_lock);
 	kvm_io_bus_init(&kvm->pio_bus);
-	kvm_irqfd_init(kvm);
+	kvm_eventfd_init(kvm);
 	mutex_init(&kvm->lock);
 	kvm_io_bus_init(&kvm->mmio_bus);
 	init_rwsem(&kvm->slots_lock);
@@ -2221,6 +2221,15 @@ static long kvm_vm_ioctl(struct file *filp,
 		r = kvm_irqfd(kvm, data.fd, data.gsi, data.flags);
 		break;
 	}
+	case KVM_IOSIGNALFD: {
+		struct kvm_iosignalfd entry;
+
+		r = -EFAULT;
+		if (copy_from_user(&entry, argp, sizeof entry))
+			goto out;
+		r = kvm_iosignalfd(kvm, &entry);
+		break;
+	}
 	default:
 		r = kvm_arch_vm_ioctl(filp, ioctl, arg);
 	}

