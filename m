Return-Path: <linux-kernel-owner+w=401wt.eu-S1758567AbZFPNnU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758567AbZFPNnU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jun 2009 09:43:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757928AbZFPNmv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Jun 2009 09:42:51 -0400
Received: from victor.provo.novell.com ([137.65.250.26]:51091 "EHLO
	victor.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757979AbZFPNms (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jun 2009 09:42:48 -0400
From: Gregory Haskins <ghaskins@novell.com>
Subject: [KVM PATCH v7 2/2] KVM: add iosignalfd support
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, avi@redhat.com, davidel@xmailserver.org,
       mtosatti@redhat.com, paulmck@linux.vnet.ibm.com, markmc@redhat.com
Date: Tue, 16 Jun 2009 09:42:35 -0400
Message-ID: <20090616134235.14362.64014.stgit@dev.haskins.net>
In-Reply-To: <20090616133751.14362.12674.stgit@dev.haskins.net>
References: <20090616133751.14362.12674.stgit@dev.haskins.net>
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

 arch/x86/kvm/Kconfig     |    8 +
 arch/x86/kvm/x86.c       |    3 
 include/linux/kvm.h      |   15 ++
 include/linux/kvm_host.h |   10 +
 virt/kvm/Kconfig         |    2 
 virt/kvm/eventfd.c       |  402 ++++++++++++++++++++++++++++++++++++++++++++++
 virt/kvm/kvm_main.c      |   11 +
 7 files changed, 447 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kvm/Kconfig b/arch/x86/kvm/Kconfig
index 7fbedfd..61b3b24 100644
--- a/arch/x86/kvm/Kconfig
+++ b/arch/x86/kvm/Kconfig
@@ -74,6 +74,14 @@ config KVM_TRACE
 	  relayfs.  Note the ABI is not considered stable and will be
 	  modified in future updates.
 
+config KVM_MAX_IOSIGNALFD_ITEMS
+	int "Maximum IOSIGNALFD items per address"
+	depends on KVM
+	default "32"
+	---help---
+	  This option influences the maximum number of fd's per PIO/MMIO
+	  address that are allowed to register
+
 # OK, it's a little counter-intuitive to do this, but it puts it neatly under
 # the virtualization menu.
 source drivers/lguest/Kconfig
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 1b91ea7..c5fd38b 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -1121,6 +1121,9 @@ int kvm_dev_ioctl_check_extension(long ext)
 	case KVM_CAP_MCE:
 		r = KVM_MAX_MCE_BANKS;
 		break;
+	case KVM_CAP_IOSIGNALFD:
+		r = CONFIG_KVM_MAX_IOSIGNALFD_ITEMS;
+		break;
 	default:
 		r = 0;
 		break;
diff --git a/include/linux/kvm.h b/include/linux/kvm.h
index 38ff31e..9de6486 100644
--- a/include/linux/kvm.h
+++ b/include/linux/kvm.h
@@ -307,6 +307,19 @@ struct kvm_guest_debug {
 	struct kvm_guest_debug_arch arch;
 };
 
+#define KVM_IOSIGNALFD_FLAG_TRIGGER   (1 << 0)
+#define KVM_IOSIGNALFD_FLAG_PIO       (1 << 1)
+#define KVM_IOSIGNALFD_FLAG_DEASSIGN  (1 << 2)
+
+struct kvm_iosignalfd {
+	__u64 trigger;
+	__u64 addr;
+	__u32 len;
+	__u32 fd;
+	__u32 flags;
+	__u8  pad[36];
+};
+
 #define KVM_TRC_SHIFT           16
 /*
  * kvm trace categories
@@ -438,6 +451,7 @@ struct kvm_trace_rec {
 #define KVM_CAP_PIT2 33
 #endif
 #define KVM_CAP_SET_BOOT_CPU_ID 34
+#define KVM_CAP_IOSIGNALFD 35
 
 #ifdef KVM_CAP_IRQ_ROUTING
 
@@ -544,6 +558,7 @@ struct kvm_irqfd {
 #define KVM_IRQFD                  _IOW(KVMIO, 0x76, struct kvm_irqfd)
 #define KVM_CREATE_PIT2		   _IOW(KVMIO, 0x77, struct kvm_pit_config)
 #define KVM_SET_BOOT_CPU_ID        _IO(KVMIO, 0x78)
+#define KVM_IOSIGNALFD             _IOW(KVMIO, 0x79, struct kvm_iosignalfd)
 
 /*
  * ioctls for vcpu fds
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index eafa2b3..2e01409 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -143,6 +143,7 @@ struct kvm {
 	struct kvm_io_bus pio_bus;
 #ifdef CONFIG_HAVE_KVM_EVENTFD
 	struct list_head irqfds;
+	struct list_head iosignalfds;
 #endif
 	struct kvm_vm_stat stat;
 	struct kvm_arch arch;
@@ -551,19 +552,24 @@ static inline void kvm_free_irq_routing(struct kvm *kvm) {}
 
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
 
diff --git a/virt/kvm/Kconfig b/virt/kvm/Kconfig
index daece36..a4b427f 100644
--- a/virt/kvm/Kconfig
+++ b/virt/kvm/Kconfig
@@ -12,3 +12,5 @@ config HAVE_KVM_EVENTFD
 
 config KVM_APIC_ARCHITECTURE
        bool
+
+
diff --git a/virt/kvm/eventfd.c b/virt/kvm/eventfd.c
index 2c8028c..90137de 100644
--- a/virt/kvm/eventfd.c
+++ b/virt/kvm/eventfd.c
@@ -21,6 +21,7 @@
  */
 
 #include <linux/kvm_host.h>
+#include <linux/kvm.h>
 #include <linux/workqueue.h>
 #include <linux/syscalls.h>
 #include <linux/wait.h>
@@ -30,6 +31,8 @@
 #include <linux/eventfd.h>
 #include <linux/srcu.h>
 
+#include "iodev.h"
+
 /*
  * --------------------------------------------------------------------
  * irqfd: Allows an fd to be used to inject an interrupt to the guest
@@ -202,9 +205,10 @@ fail:
 }
 
 void
-kvm_irqfd_init(struct kvm *kvm)
+kvm_eventfd_init(struct kvm *kvm)
 {
 	INIT_LIST_HEAD(&kvm->irqfds);
+	INIT_LIST_HEAD(&kvm->iosignalfds);
 }
 
 void
@@ -215,3 +219,399 @@ kvm_irqfd_release(struct kvm *kvm)
 	list_for_each_entry_safe(irqfd, tmp, &kvm->irqfds, list)
 		irqfd_disconnect(irqfd);
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
+/*
+ * Design note: We create one PIO/MMIO device (iosignalfd_group) which
+ * aggregates  one or more iosignalfd_items.  Each item points to exactly one
+ * eventfd, and can be registered to trigger on any write to the group
+ * (wildcard), or to a write of a specific value.  If more than one item is to
+ * be supported, the addr/len ranges must all be identical in the group.  If a
+ * trigger value is to be supported on a particular item, the group range must
+ * be exactly the width of the trigger.
+ */
+
+struct _iosignalfd_item {
+	struct list_head     list;
+	struct file         *file;
+	unsigned char       *match;
+	struct rcu_head      rcu;
+};
+
+struct _iosignalfd_group {
+	struct list_head     list;
+	u64                  addr;
+	size_t               length;
+	size_t               count;
+	struct list_head     items;
+	struct kvm_io_device dev;
+	struct rcu_head      rcu;
+};
+
+static inline struct _iosignalfd_group *
+to_group(struct kvm_io_device *dev)
+{
+	return container_of(dev, struct _iosignalfd_group, dev);
+}
+
+static void
+iosignalfd_item_free(struct _iosignalfd_item *item)
+{
+	fput(item->file);
+	kfree(item->match);
+	kfree(item);
+}
+
+static void
+iosignalfd_item_deferred_free(struct rcu_head *rhp)
+{
+	struct _iosignalfd_item *item;
+
+	item = container_of(rhp, struct _iosignalfd_item, rcu);
+
+	iosignalfd_item_free(item);
+}
+
+static void
+iosignalfd_group_deferred_free(struct rcu_head *rhp)
+{
+	struct _iosignalfd_group *group;
+
+	group = container_of(rhp, struct _iosignalfd_group, rcu);
+
+	kfree(group);
+}
+
+static int
+iosignalfd_group_in_range(struct kvm_io_device *this, gpa_t addr, int len,
+			  int is_write)
+{
+	struct _iosignalfd_group *p = to_group(this);
+
+	return ((addr >= p->addr && (addr < p->addr + p->length)));
+}
+
+static int
+iosignalfd_is_match(struct _iosignalfd_group *group,
+		    struct _iosignalfd_item *item,
+		    const void *val,
+		    int len)
+{
+	if (!item->match)
+		/* wildcard is a hit */
+		return true;
+
+	if (len != group->length)
+		/* mis-matched length is a miss */
+		return false;
+
+	/* otherwise, we have to actually compare the data */
+	return !memcmp(item->match, val, len) ? true : false;
+}
+
+/*
+ * MMIO/PIO writes trigger an event (if the data matches).
+ *
+ * This is invoked by the io_bus subsystem in response to an address match
+ * against the group.  We must then walk the list of individual items to check
+ * for a match and, if applicable, to send the appropriate signal. If the item
+ * in question does not have a "match" pointer, it is considered a wildcard
+ * and will always generate a signal.  There can be an arbitrary number
+ * of distinct matches or wildcards per group.
+ */
+static void
+iosignalfd_group_write(struct kvm_io_device *this, gpa_t addr, int len,
+		       const void *val)
+{
+	struct _iosignalfd_group *group = to_group(this);
+	struct _iosignalfd_item *item;
+
+	rcu_read_lock();
+
+	list_for_each_entry_rcu(item, &group->items, list) {
+		if (iosignalfd_is_match(group, item, val, len))
+			eventfd_signal(item->file, 1);
+	}
+
+	rcu_read_unlock();
+}
+
+/*
+ * MMIO/PIO reads against the group indiscriminately return all zeros
+ */
+static void
+iosignalfd_group_read(struct kvm_io_device *this, gpa_t addr, int len,
+		      void *val)
+{
+	memset(val, 0, len);
+}
+
+/*
+ * This function is called as KVM is completely shutting down.  We do not
+ * need to worry about locking or careful RCU dancing...just nuke anything
+ * we have as quickly as possible
+ */
+static void
+iosignalfd_group_destructor(struct kvm_io_device *this)
+{
+	struct _iosignalfd_group *group = to_group(this);
+	struct _iosignalfd_item *item, *tmp;
+
+	list_for_each_entry_safe(item, tmp, &group->items, list) {
+		list_del(&item->list);
+		group->count--;
+		iosignalfd_item_free(item);
+	}
+
+	list_del(&group->list);
+	kfree(group);
+}
+
+static const struct kvm_io_device_ops iosignalfd_ops = {
+	.read       = iosignalfd_group_read,
+	.write      = iosignalfd_group_write,
+	.in_range   = iosignalfd_group_in_range,
+	.destructor = iosignalfd_group_destructor,
+};
+
+/* assumes kvm->lock held */
+static struct _iosignalfd_group *
+iosignalfd_group_find(struct kvm *kvm, u64 addr)
+{
+	struct _iosignalfd_group *group;
+
+	list_for_each_entry(group, &kvm->iosignalfds, list) {
+		if (group->addr == addr)
+			return group;
+	}
+
+	return NULL;
+}
+
+/*
+ * Atomically find an existing group, or create a new one if it doesn't already
+ * exist.
+ *
+ * assumes kvm->lock is held
+ */
+static struct _iosignalfd_group *
+iosignalfd_group_get(struct kvm *kvm, struct kvm_io_bus *bus,
+		      u64 addr, size_t len)
+{
+	struct _iosignalfd_group *group;
+
+	group = iosignalfd_group_find(kvm, addr);
+	if (!group) {
+		int ret;
+
+		group = kzalloc(sizeof(*group), GFP_KERNEL);
+		if (!group)
+			return ERR_PTR(-ENOMEM);
+
+		INIT_LIST_HEAD(&group->list);
+		INIT_LIST_HEAD(&group->items);
+		group->addr   = addr;
+		group->length = len;
+		kvm_iodevice_init(&group->dev, &iosignalfd_ops);
+
+		ret = kvm_io_bus_register_dev(bus, &group->dev);
+		if (ret < 0) {
+			kfree(group);
+			return ERR_PTR(ret);
+		}
+
+		list_add_tail(&group->list, &kvm->iosignalfds);
+
+	} else if (group->length != len)
+		/*
+		 * Existing groups must have the same addr/len tuple or we
+		 * reject the request
+		 */
+		return ERR_PTR(-EINVAL);
+
+	return group;
+}
+
+static int
+kvm_assign_iosignalfd(struct kvm *kvm, struct kvm_iosignalfd *args)
+{
+	int                       pio = args->flags & KVM_IOSIGNALFD_FLAG_PIO;
+	struct kvm_io_bus        *bus = pio ? &kvm->pio_bus : &kvm->mmio_bus;
+	struct _iosignalfd_group *group = NULL;
+	struct _iosignalfd_item  *item = NULL;
+	struct file              *file;
+	int                       ret;
+
+	file = eventfd_fget(args->fd);
+	if (IS_ERR(file))
+		return PTR_ERR(file);
+
+	item = kzalloc(sizeof(*item), GFP_KERNEL);
+	if (!item) {
+		ret = -ENOMEM;
+		goto fail;
+	}
+
+	INIT_LIST_HEAD(&item->list);
+	item->file = file;
+
+	/*
+	 * Registering a "trigger" address is optional.  If this flag
+	 * is not specified, we leave the item->match pointer NULL, which
+	 * indicates a wildcard
+	 */
+	if (args->flags & KVM_IOSIGNALFD_FLAG_TRIGGER) {
+		if (args->len > sizeof(u64)) {
+			ret = -EINVAL;
+			goto fail;
+		}
+
+		item->match = kzalloc(args->len, GFP_KERNEL);
+		if (!item->match) {
+			ret = -ENOMEM;
+			goto fail;
+		}
+
+		if (copy_from_user(item->match,
+				   (void *)args->trigger,
+				   args->len)) {
+			ret = -EFAULT;
+			goto fail;
+		}
+	}
+
+	mutex_lock(&kvm->lock);
+
+	group = iosignalfd_group_get(kvm, bus, args->addr, args->len);
+	if (IS_ERR(group)) {
+		ret = PTR_ERR(group);
+		goto unlock_fail;
+	}
+
+	/*
+	 * Put an upper limit on the number of items-per-group we support
+	 */
+	if (group->count >= CONFIG_KVM_MAX_IOSIGNALFD_ITEMS) {
+		ret = -ENOSPC;
+		goto unlock_fail;
+	}
+
+	/*
+	 * Note: We are committed to succeed at this point since we have
+	 * (potentially) published a new group-device.  Any failure handling
+	 * added in the future after this point will need to be carefully
+	 * considered.
+	 */
+
+	list_add_tail_rcu(&item->list, &group->items);
+	group->count++;
+
+	mutex_unlock(&kvm->lock);
+
+	return 0;
+
+unlock_fail:
+	mutex_unlock(&kvm->lock);
+fail:
+	if (item) {
+		/*
+		 * it would have never made it to the group->items list
+		 * in the failure path, so we dont need to worry about removing
+		 * it
+		 */
+		kfree(item->match);
+		kfree(item);
+	}
+
+	fput(file);
+
+	return ret;
+}
+
+
+static int
+kvm_deassign_iosignalfd(struct kvm *kvm, struct kvm_iosignalfd *args)
+{
+	int                       pio = args->flags & KVM_IOSIGNALFD_FLAG_PIO;
+	struct kvm_io_bus        *bus = pio ? &kvm->pio_bus : &kvm->mmio_bus;
+	struct _iosignalfd_group *group;
+	struct _iosignalfd_item  *item, *tmp;
+	struct file              *file;
+	int                       ret = 0;
+
+	file = eventfd_fget(args->fd);
+	if (IS_ERR(file))
+		return PTR_ERR(file);
+
+	mutex_lock(&kvm->lock);
+
+	group = iosignalfd_group_find(kvm, args->addr);
+	if (!group) {
+		ret = -EINVAL;
+		goto out;
+	}
+
+	/*
+	 * Exhaustively search our group->items list for any items that might
+	 * match the specified fd, and (carefully) remove each one found.
+	 */
+	list_for_each_entry_safe(item, tmp, &group->items, list) {
+
+		if (item->file != file)
+			continue;
+
+		list_del_rcu(&item->list);
+		group->count--;
+
+		/*
+		 * The item may be still referenced inside our group->write()
+		 * path's RCU read-side CS, so defer the actual free to the
+		 * next grace
+		 */
+		call_rcu(&item->rcu, iosignalfd_item_deferred_free);
+	}
+
+	/*
+	 * Check if the group is now completely vacated as a result of
+	 * removing the items.  If so, unregister/delete it
+	 */
+	if (list_empty(&group->items)) {
+
+		kvm_io_bus_unregister_dev(bus, &group->dev);
+
+		/*
+		 * Like the item, the group may also still be referenced as
+		 * per above.  However, the kvm->iosignalfds list is not
+		 * RCU protected (its protected by kvm->lock instead) so
+		 * we can just plain-vanilla remove it.  What needs to be
+		 * done carefully is the actual freeing of the group pointer
+		 * since we walk the group->items list within the RCU CS.
+		 */
+		list_del(&group->list);
+		call_rcu(&group->rcu, iosignalfd_group_deferred_free);
+	}
+
+out:
+	mutex_unlock(&kvm->lock);
+
+	fput(file);
+
+	return ret;
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
index b2cd59c..7fee49e 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -971,7 +971,7 @@ static struct kvm *kvm_create_vm(void)
 	atomic_inc(&kvm->mm->mm_count);
 	spin_lock_init(&kvm->mmu_lock);
 	kvm_io_bus_init(&kvm->pio_bus);
-	kvm_irqfd_init(kvm);
+	kvm_eventfd_init(kvm);
 	mutex_init(&kvm->lock);
 	mutex_init(&kvm->irq_lock);
 	kvm_io_bus_init(&kvm->mmio_bus);
@@ -2227,6 +2227,15 @@ static long kvm_vm_ioctl(struct file *filp,
 		r = kvm_irqfd(kvm, data.fd, data.gsi, data.flags);
 		break;
 	}
+	case KVM_IOSIGNALFD: {
+		struct kvm_iosignalfd data;
+
+		r = -EFAULT;
+		if (copy_from_user(&data, argp, sizeof data))
+			goto out;
+		r = kvm_iosignalfd(kvm, &data);
+		break;
+	}
 #ifdef CONFIG_KVM_APIC_ARCHITECTURE
 	case KVM_SET_BOOT_CPU_ID:
 		r = 0;

