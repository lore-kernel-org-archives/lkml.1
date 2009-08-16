Return-Path: <linux-kernel-owner+w=401wt.eu-S1755479AbZHPJku@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755479AbZHPJku (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Aug 2009 05:40:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754019AbZHPJip
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Aug 2009 05:38:45 -0400
Received: from mx2.redhat.com ([66.187.237.31]:45343 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753987AbZHPJaL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Aug 2009 05:30:11 -0400
From: Avi Kivity <avi@redhat.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 11/48] KVM: irqfd
Date: Sun, 16 Aug 2009 12:29:31 +0300
Message-Id: <1250415008-17175-12-git-send-email-avi@redhat.com>
In-Reply-To: <1250415008-17175-1-git-send-email-avi@redhat.com>
References: <1250415008-17175-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Gregory Haskins <ghaskins@novell.com>

KVM provides a complete virtual system environment for guests, including
support for injecting interrupts modeled after the real exception/interrupt
facilities present on the native platform (such as the IDT on x86).
Virtual interrupts can come from a variety of sources (emulated devices,
pass-through devices, etc) but all must be injected to the guest via
the KVM infrastructure.  This patch adds a new mechanism to inject a specific
interrupt to a guest using a decoupled eventfd mechnanism:  Any legal signal
on the irqfd (using eventfd semantics from either userspace or kernel) will
translate into an injected interrupt in the guest at the next available
interrupt window.

Signed-off-by: Gregory Haskins <ghaskins@novell.com>
Signed-off-by: Avi Kivity <avi@redhat.com>
---
 arch/x86/kvm/Kconfig     |    1 +
 arch/x86/kvm/Makefile    |    2 +-
 arch/x86/kvm/x86.c       |    1 +
 include/linux/kvm.h      |   11 ++
 include/linux/kvm_host.h |   24 ++++
 virt/kvm/Kconfig         |    4 +
 virt/kvm/eventfd.c       |  329 ++++++++++++++++++++++++++++++++++++++++++++++
 virt/kvm/kvm_main.c      |   12 ++
 8 files changed, 383 insertions(+), 1 deletions(-)
 create mode 100644 virt/kvm/eventfd.c

diff --git a/arch/x86/kvm/Kconfig b/arch/x86/kvm/Kconfig
index 939b1cb..8cd2a4e 100644
--- a/arch/x86/kvm/Kconfig
+++ b/arch/x86/kvm/Kconfig
@@ -26,6 +26,7 @@ config KVM
 	select MMU_NOTIFIER
 	select ANON_INODES
 	select HAVE_KVM_IRQCHIP
+	select HAVE_KVM_EVENTFD
 	---help---
 	  Support hosting fully virtualized guest machines using hardware
 	  virtualization extensions.  You will need a fairly recent
diff --git a/arch/x86/kvm/Makefile b/arch/x86/kvm/Makefile
index bee9512..01e3c61 100644
--- a/arch/x86/kvm/Makefile
+++ b/arch/x86/kvm/Makefile
@@ -2,7 +2,7 @@
 EXTRA_CFLAGS += -Ivirt/kvm -Iarch/x86/kvm
 
 kvm-y			+= $(addprefix ../../../virt/kvm/, kvm_main.o ioapic.o \
-				coalesced_mmio.o irq_comm.o)
+				coalesced_mmio.o irq_comm.o eventfd.o)
 kvm-$(CONFIG_KVM_TRACE)	+= $(addprefix ../../../virt/kvm/, kvm_trace.o)
 kvm-$(CONFIG_IOMMU_API)	+= $(addprefix ../../../virt/kvm/, iommu.o)
 
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index f064239..15f39fc 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -1126,6 +1126,7 @@ int kvm_dev_ioctl_check_extension(long ext)
 	case KVM_CAP_REINJECT_CONTROL:
 	case KVM_CAP_IRQ_INJECT_STATUS:
 	case KVM_CAP_ASSIGN_DEV_IRQ:
+	case KVM_CAP_IRQFD:
 		r = 1;
 		break;
 	case KVM_CAP_COALESCED_MMIO:
diff --git a/include/linux/kvm.h b/include/linux/kvm.h
index 7b17141..8f53f24 100644
--- a/include/linux/kvm.h
+++ b/include/linux/kvm.h
@@ -418,6 +418,7 @@ struct kvm_trace_rec {
 #ifdef __KVM_HAVE_MCE
 #define KVM_CAP_MCE 31
 #endif
+#define KVM_CAP_IRQFD 32
 
 #ifdef KVM_CAP_IRQ_ROUTING
 
@@ -470,6 +471,15 @@ struct kvm_x86_mce {
 };
 #endif
 
+#define KVM_IRQFD_FLAG_DEASSIGN (1 << 0)
+
+struct kvm_irqfd {
+	__u32 fd;
+	__u32 gsi;
+	__u32 flags;
+	__u8  pad[20];
+};
+
 /*
  * ioctls for VM fds
  */
@@ -514,6 +524,7 @@ struct kvm_x86_mce {
 #define KVM_ASSIGN_SET_MSIX_ENTRY \
 			_IOW(KVMIO, 0x74, struct kvm_assigned_msix_entry)
 #define KVM_DEASSIGN_DEV_IRQ       _IOW(KVMIO, 0x75, struct kvm_assigned_irq)
+#define KVM_IRQFD                  _IOW(KVMIO, 0x76, struct kvm_irqfd)
 
 /*
  * ioctls for vcpu fds
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 3060bdc..7724dcb 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -136,6 +136,12 @@ struct kvm {
 	struct list_head vm_list;
 	struct kvm_io_bus mmio_bus;
 	struct kvm_io_bus pio_bus;
+#ifdef CONFIG_HAVE_KVM_EVENTFD
+	struct {
+		spinlock_t        lock;
+		struct list_head  items;
+	} irqfds;
+#endif
 	struct kvm_vm_stat stat;
 	struct kvm_arch arch;
 	atomic_t users_count;
@@ -525,4 +531,22 @@ static inline void kvm_free_irq_routing(struct kvm *kvm) {}
 
 #endif
 
+#ifdef CONFIG_HAVE_KVM_EVENTFD
+
+void kvm_irqfd_init(struct kvm *kvm);
+int kvm_irqfd(struct kvm *kvm, int fd, int gsi, int flags);
+void kvm_irqfd_release(struct kvm *kvm);
+
+#else
+
+static inline void kvm_irqfd_init(struct kvm *kvm) {}
+static inline int kvm_irqfd(struct kvm *kvm, int fd, int gsi, int flags)
+{
+	return -EINVAL;
+}
+
+static inline void kvm_irqfd_release(struct kvm *kvm) {}
+
+#endif /* CONFIG_HAVE_KVM_EVENTFD */
+
 #endif
diff --git a/virt/kvm/Kconfig b/virt/kvm/Kconfig
index 79e83fc..56c6848 100644
--- a/virt/kvm/Kconfig
+++ b/virt/kvm/Kconfig
@@ -5,3 +5,7 @@ config HAVE_KVM
 
 config HAVE_KVM_IRQCHIP
        bool
+
+config HAVE_KVM_EVENTFD
+       bool
+       select EVENTFD
diff --git a/virt/kvm/eventfd.c b/virt/kvm/eventfd.c
new file mode 100644
index 0000000..3140123
--- /dev/null
+++ b/virt/kvm/eventfd.c
@@ -0,0 +1,329 @@
+/*
+ * kvm eventfd support - use eventfd objects to signal various KVM events
+ *
+ * Copyright 2009 Novell.  All Rights Reserved.
+ *
+ * Author:
+ *	Gregory Haskins <ghaskins@novell.com>
+ *
+ * This file is free software; you can redistribute it and/or modify
+ * it under the terms of version 2 of the GNU General Public License
+ * as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.	 See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software Foundation,
+ * Inc., 51 Franklin St, Fifth Floor, Boston, MA 02110-1301, USA.
+ */
+
+#include <linux/kvm_host.h>
+#include <linux/workqueue.h>
+#include <linux/syscalls.h>
+#include <linux/wait.h>
+#include <linux/poll.h>
+#include <linux/file.h>
+#include <linux/list.h>
+#include <linux/eventfd.h>
+
+/*
+ * --------------------------------------------------------------------
+ * irqfd: Allows an fd to be used to inject an interrupt to the guest
+ *
+ * Credit goes to Avi Kivity for the original idea.
+ * --------------------------------------------------------------------
+ */
+
+struct _irqfd {
+	struct kvm               *kvm;
+	struct eventfd_ctx       *eventfd;
+	int                       gsi;
+	struct list_head          list;
+	poll_table                pt;
+	wait_queue_head_t        *wqh;
+	wait_queue_t              wait;
+	struct work_struct        inject;
+	struct work_struct        shutdown;
+};
+
+static struct workqueue_struct *irqfd_cleanup_wq;
+
+static void
+irqfd_inject(struct work_struct *work)
+{
+	struct _irqfd *irqfd = container_of(work, struct _irqfd, inject);
+	struct kvm *kvm = irqfd->kvm;
+
+	mutex_lock(&kvm->lock);
+	kvm_set_irq(kvm, KVM_USERSPACE_IRQ_SOURCE_ID, irqfd->gsi, 1);
+	kvm_set_irq(kvm, KVM_USERSPACE_IRQ_SOURCE_ID, irqfd->gsi, 0);
+	mutex_unlock(&kvm->lock);
+}
+
+/*
+ * Race-free decouple logic (ordering is critical)
+ */
+static void
+irqfd_shutdown(struct work_struct *work)
+{
+	struct _irqfd *irqfd = container_of(work, struct _irqfd, shutdown);
+
+	/*
+	 * Synchronize with the wait-queue and unhook ourselves to prevent
+	 * further events.
+	 */
+	remove_wait_queue(irqfd->wqh, &irqfd->wait);
+
+	/*
+	 * We know no new events will be scheduled at this point, so block
+	 * until all previously outstanding events have completed
+	 */
+	flush_work(&irqfd->inject);
+
+	/*
+	 * It is now safe to release the object's resources
+	 */
+	eventfd_ctx_put(irqfd->eventfd);
+	kfree(irqfd);
+}
+
+
+/* assumes kvm->irqfds.lock is held */
+static bool
+irqfd_is_active(struct _irqfd *irqfd)
+{
+	return list_empty(&irqfd->list) ? false : true;
+}
+
+/*
+ * Mark the irqfd as inactive and schedule it for removal
+ *
+ * assumes kvm->irqfds.lock is held
+ */
+static void
+irqfd_deactivate(struct _irqfd *irqfd)
+{
+	BUG_ON(!irqfd_is_active(irqfd));
+
+	list_del_init(&irqfd->list);
+
+	queue_work(irqfd_cleanup_wq, &irqfd->shutdown);
+}
+
+/*
+ * Called with wqh->lock held and interrupts disabled
+ */
+static int
+irqfd_wakeup(wait_queue_t *wait, unsigned mode, int sync, void *key)
+{
+	struct _irqfd *irqfd = container_of(wait, struct _irqfd, wait);
+	unsigned long flags = (unsigned long)key;
+
+	if (flags & POLLIN)
+		/* An event has been signaled, inject an interrupt */
+		schedule_work(&irqfd->inject);
+
+	if (flags & POLLHUP) {
+		/* The eventfd is closing, detach from KVM */
+		struct kvm *kvm = irqfd->kvm;
+		unsigned long flags;
+
+		spin_lock_irqsave(&kvm->irqfds.lock, flags);
+
+		/*
+		 * We must check if someone deactivated the irqfd before
+		 * we could acquire the irqfds.lock since the item is
+		 * deactivated from the KVM side before it is unhooked from
+		 * the wait-queue.  If it is already deactivated, we can
+		 * simply return knowing the other side will cleanup for us.
+		 * We cannot race against the irqfd going away since the
+		 * other side is required to acquire wqh->lock, which we hold
+		 */
+		if (irqfd_is_active(irqfd))
+			irqfd_deactivate(irqfd);
+
+		spin_unlock_irqrestore(&kvm->irqfds.lock, flags);
+	}
+
+	return 0;
+}
+
+static void
+irqfd_ptable_queue_proc(struct file *file, wait_queue_head_t *wqh,
+			poll_table *pt)
+{
+	struct _irqfd *irqfd = container_of(pt, struct _irqfd, pt);
+
+	irqfd->wqh = wqh;
+	add_wait_queue(wqh, &irqfd->wait);
+}
+
+static int
+kvm_irqfd_assign(struct kvm *kvm, int fd, int gsi)
+{
+	struct _irqfd *irqfd;
+	struct file *file = NULL;
+	struct eventfd_ctx *eventfd = NULL;
+	int ret;
+	unsigned int events;
+
+	irqfd = kzalloc(sizeof(*irqfd), GFP_KERNEL);
+	if (!irqfd)
+		return -ENOMEM;
+
+	irqfd->kvm = kvm;
+	irqfd->gsi = gsi;
+	INIT_LIST_HEAD(&irqfd->list);
+	INIT_WORK(&irqfd->inject, irqfd_inject);
+	INIT_WORK(&irqfd->shutdown, irqfd_shutdown);
+
+	file = eventfd_fget(fd);
+	if (IS_ERR(file)) {
+		ret = PTR_ERR(file);
+		goto fail;
+	}
+
+	eventfd = eventfd_ctx_fileget(file);
+	if (IS_ERR(eventfd)) {
+		ret = PTR_ERR(eventfd);
+		goto fail;
+	}
+
+	irqfd->eventfd = eventfd;
+
+	/*
+	 * Install our own custom wake-up handling so we are notified via
+	 * a callback whenever someone signals the underlying eventfd
+	 */
+	init_waitqueue_func_entry(&irqfd->wait, irqfd_wakeup);
+	init_poll_funcptr(&irqfd->pt, irqfd_ptable_queue_proc);
+
+	events = file->f_op->poll(file, &irqfd->pt);
+
+	spin_lock_irq(&kvm->irqfds.lock);
+	list_add_tail(&irqfd->list, &kvm->irqfds.items);
+	spin_unlock_irq(&kvm->irqfds.lock);
+
+	/*
+	 * Check if there was an event already pending on the eventfd
+	 * before we registered, and trigger it as if we didn't miss it.
+	 */
+	if (events & POLLIN)
+		schedule_work(&irqfd->inject);
+
+	/*
+	 * do not drop the file until the irqfd is fully initialized, otherwise
+	 * we might race against the POLLHUP
+	 */
+	fput(file);
+
+	return 0;
+
+fail:
+	if (eventfd && !IS_ERR(eventfd))
+		eventfd_ctx_put(eventfd);
+
+	if (file && !IS_ERR(file))
+		fput(file);
+
+	kfree(irqfd);
+	return ret;
+}
+
+void
+kvm_irqfd_init(struct kvm *kvm)
+{
+	spin_lock_init(&kvm->irqfds.lock);
+	INIT_LIST_HEAD(&kvm->irqfds.items);
+}
+
+/*
+ * shutdown any irqfd's that match fd+gsi
+ */
+static int
+kvm_irqfd_deassign(struct kvm *kvm, int fd, int gsi)
+{
+	struct _irqfd *irqfd, *tmp;
+	struct eventfd_ctx *eventfd;
+
+	eventfd = eventfd_ctx_fdget(fd);
+	if (IS_ERR(eventfd))
+		return PTR_ERR(eventfd);
+
+	spin_lock_irq(&kvm->irqfds.lock);
+
+	list_for_each_entry_safe(irqfd, tmp, &kvm->irqfds.items, list) {
+		if (irqfd->eventfd == eventfd && irqfd->gsi == gsi)
+			irqfd_deactivate(irqfd);
+	}
+
+	spin_unlock_irq(&kvm->irqfds.lock);
+	eventfd_ctx_put(eventfd);
+
+	/*
+	 * Block until we know all outstanding shutdown jobs have completed
+	 * so that we guarantee there will not be any more interrupts on this
+	 * gsi once this deassign function returns.
+	 */
+	flush_workqueue(irqfd_cleanup_wq);
+
+	return 0;
+}
+
+int
+kvm_irqfd(struct kvm *kvm, int fd, int gsi, int flags)
+{
+	if (flags & KVM_IRQFD_FLAG_DEASSIGN)
+		return kvm_irqfd_deassign(kvm, fd, gsi);
+
+	return kvm_irqfd_assign(kvm, fd, gsi);
+}
+
+/*
+ * This function is called as the kvm VM fd is being released. Shutdown all
+ * irqfds that still remain open
+ */
+void
+kvm_irqfd_release(struct kvm *kvm)
+{
+	struct _irqfd *irqfd, *tmp;
+
+	spin_lock_irq(&kvm->irqfds.lock);
+
+	list_for_each_entry_safe(irqfd, tmp, &kvm->irqfds.items, list)
+		irqfd_deactivate(irqfd);
+
+	spin_unlock_irq(&kvm->irqfds.lock);
+
+	/*
+	 * Block until we know all outstanding shutdown jobs have completed
+	 * since we do not take a kvm* reference.
+	 */
+	flush_workqueue(irqfd_cleanup_wq);
+
+}
+
+/*
+ * create a host-wide workqueue for issuing deferred shutdown requests
+ * aggregated from all vm* instances. We need our own isolated single-thread
+ * queue to prevent deadlock against flushing the normal work-queue.
+ */
+static int __init irqfd_module_init(void)
+{
+	irqfd_cleanup_wq = create_singlethread_workqueue("kvm-irqfd-cleanup");
+	if (!irqfd_cleanup_wq)
+		return -ENOMEM;
+
+	return 0;
+}
+
+static void __exit irqfd_module_exit(void)
+{
+	destroy_workqueue(irqfd_cleanup_wq);
+}
+
+module_init(irqfd_module_init);
+module_exit(irqfd_module_exit);
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 2884baf..dee321e 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -986,6 +986,7 @@ static struct kvm *kvm_create_vm(void)
 	spin_lock_init(&kvm->mmu_lock);
 	spin_lock_init(&kvm->requests_lock);
 	kvm_io_bus_init(&kvm->pio_bus);
+	kvm_irqfd_init(kvm);
 	mutex_init(&kvm->lock);
 	kvm_io_bus_init(&kvm->mmio_bus);
 	init_rwsem(&kvm->slots_lock);
@@ -1071,6 +1072,8 @@ static int kvm_vm_release(struct inode *inode, struct file *filp)
 {
 	struct kvm *kvm = filp->private_data;
 
+	kvm_irqfd_release(kvm);
+
 	kvm_put_kvm(kvm);
 	return 0;
 }
@@ -2222,6 +2225,15 @@ static long kvm_vm_ioctl(struct file *filp,
 	}
 #endif
 #endif /* KVM_CAP_IRQ_ROUTING */
+	case KVM_IRQFD: {
+		struct kvm_irqfd data;
+
+		r = -EFAULT;
+		if (copy_from_user(&data, argp, sizeof data))
+			goto out;
+		r = kvm_irqfd(kvm, data.fd, data.gsi, data.flags);
+		break;
+	}
 	default:
 		r = kvm_arch_vm_ioctl(filp, ioctl, arg);
 	}
-- 
1.6.3.3

