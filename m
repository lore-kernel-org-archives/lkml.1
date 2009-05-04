Return-Path: <linux-kernel-owner+w=401wt.eu-S1758743AbZEDSDv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758743AbZEDSDv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 May 2009 14:03:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755277AbZEDSDi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 May 2009 14:03:38 -0400
Received: from victor.provo.novell.com ([137.65.250.26]:41940 "EHLO
	victor.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751863AbZEDSDh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 May 2009 14:03:37 -0400
From: Gregory Haskins <ghaskins@novell.com>
Subject: [KVM PATCH v4 2/2] kvm: add support for irqfd via
	eventfd-notification interface
To: kvm@vger.kernel.org
Cc: viro@ZenIV.linux.org.uk, linux-kernel@vger.kernel.org, avi@redhat.com,
       davidel@xmailserver.org
Date: Mon, 04 May 2009 13:57:51 -0400
Message-ID: <20090504175750.26758.7023.stgit@dev.haskins.net>
In-Reply-To: <20090504175657.26758.12503.stgit@dev.haskins.net>
References: <20090504175657.26758.12503.stgit@dev.haskins.net>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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
---

 arch/x86/kvm/Makefile    |    2 -
 arch/x86/kvm/x86.c       |    1 
 include/linux/kvm.h      |    7 ++
 include/linux/kvm_host.h |    4 +
 virt/kvm/irqfd.c         |  159 ++++++++++++++++++++++++++++++++++++++++++++++
 virt/kvm/kvm_main.c      |   11 +++
 6 files changed, 183 insertions(+), 1 deletions(-)
 create mode 100644 virt/kvm/irqfd.c

diff --git a/arch/x86/kvm/Makefile b/arch/x86/kvm/Makefile
index b43c4ef..d5fff51 100644
--- a/arch/x86/kvm/Makefile
+++ b/arch/x86/kvm/Makefile
@@ -3,7 +3,7 @@
 #
 
 common-objs = $(addprefix ../../../virt/kvm/, kvm_main.o ioapic.o \
-                coalesced_mmio.o irq_comm.o)
+                coalesced_mmio.o irq_comm.o irqfd.o)
 ifeq ($(CONFIG_KVM_TRACE),y)
 common-objs += $(addprefix ../../../virt/kvm/, kvm_trace.o)
 endif
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 2d7082c..699a407 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -1027,6 +1027,7 @@ int kvm_dev_ioctl_check_extension(long ext)
 	case KVM_CAP_REINJECT_CONTROL:
 	case KVM_CAP_IRQ_INJECT_STATUS:
 	case KVM_CAP_ASSIGN_DEV_IRQ:
+	case KVM_CAP_IRQFD:
 		r = 1;
 		break;
 	case KVM_CAP_COALESCED_MMIO:
diff --git a/include/linux/kvm.h b/include/linux/kvm.h
index 3db5d8d..5e9b861 100644
--- a/include/linux/kvm.h
+++ b/include/linux/kvm.h
@@ -415,6 +415,7 @@ struct kvm_trace_rec {
 #define KVM_CAP_ASSIGN_DEV_IRQ 29
 /* Another bug in KVM_SET_USER_MEMORY_REGION fixed: */
 #define KVM_CAP_JOIN_MEMORY_REGIONS_WORKS 30
+#define KVM_CAP_IRQFD 31
 
 #ifdef KVM_CAP_IRQ_ROUTING
 
@@ -454,6 +455,11 @@ struct kvm_irq_routing {
 
 #endif
 
+struct kvm_irqfd {
+	__u32 gsi;
+	__u32 flags;
+};
+
 /*
  * ioctls for VM fds
  */
@@ -498,6 +504,7 @@ struct kvm_irq_routing {
 #define KVM_ASSIGN_SET_MSIX_ENTRY \
 			_IOW(KVMIO, 0x74, struct kvm_assigned_msix_entry)
 #define KVM_DEASSIGN_DEV_IRQ       _IOW(KVMIO, 0x75, struct kvm_assigned_irq)
+#define KVM_IRQFD                  _IOW(KVMIO, 0x76, struct kvm_irqfd)
 
 /*
  * ioctls for vcpu fds
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 095ebb6..6a8d1c1 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -134,6 +134,7 @@ struct kvm {
 	struct list_head vm_list;
 	struct kvm_io_bus mmio_bus;
 	struct kvm_io_bus pio_bus;
+	struct list_head irqfds;
 	struct kvm_vm_stat stat;
 	struct kvm_arch arch;
 	atomic_t users_count;
@@ -524,4 +525,7 @@ static inline void kvm_free_irq_routing(struct kvm *kvm) {}
 
 #endif
 
+int kvm_irqfd(struct kvm *kvm, int gsi, int flags);
+void kvm_irqfd_release(struct kvm *kvm);
+
 #endif
diff --git a/virt/kvm/irqfd.c b/virt/kvm/irqfd.c
new file mode 100644
index 0000000..6c82fcb
--- /dev/null
+++ b/virt/kvm/irqfd.c
@@ -0,0 +1,159 @@
+/*
+ * irqfd: Allows an eventfd to be used to inject an interrupt to the guest
+ *
+ * Credit goes to Avi Kivity for the original idea.
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
+#include <linux/eventfd.h>
+#include <linux/workqueue.h>
+#include <linux/syscalls.h>
+#include <linux/wait.h>
+#include <linux/poll.h>
+#include <linux/file.h>
+#include <linux/list.h>
+
+struct _irqfd {
+	struct kvm               *kvm;
+	int                       gsi;
+	struct file              *file;
+	struct list_head          list;
+	poll_table                pt;
+	wait_queue_head_t        *wqh;
+	wait_queue_t              wait;
+	struct work_struct        work;
+};
+
+static void
+irqfd_inject(struct work_struct *work)
+{
+	struct _irqfd *irqfd = container_of(work, struct _irqfd, work);
+	struct kvm *kvm = irqfd->kvm;
+
+	mutex_lock(&kvm->lock);
+	kvm_set_irq(kvm, KVM_USERSPACE_IRQ_SOURCE_ID, irqfd->gsi, 1);
+	kvm_set_irq(kvm, KVM_USERSPACE_IRQ_SOURCE_ID, irqfd->gsi, 0);
+	mutex_unlock(&kvm->lock);
+}
+
+static int
+irqfd_wakeup(wait_queue_t *wait, unsigned mode, int sync, void *key)
+{
+	struct _irqfd *irqfd = container_of(wait, struct _irqfd, wait);
+
+	/*
+	 * The eventfd calls its wake_up with interrupts disabled, and
+	 * eventfd_signal() may be called from interrupt context. Therefore
+	 * we need to defer the IRQ injection until later since we need to
+	 * acquire the kvm->lock to do so.
+	 */
+	schedule_work(&irqfd->work);
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
+int
+kvm_irqfd(struct kvm *kvm, int gsi, int flags)
+{
+	struct _irqfd *irqfd;
+	struct file *file = NULL;
+	int fd = -1;
+	int ret;
+
+	irqfd = kzalloc(sizeof(*irqfd), GFP_KERNEL);
+	if (!irqfd)
+		return -ENOMEM;
+
+	irqfd->kvm = kvm;
+	irqfd->gsi = gsi;
+	INIT_LIST_HEAD(&irqfd->list);
+	INIT_WORK(&irqfd->work, irqfd_inject);
+
+	/*
+	 * We re-use eventfd for irqfd, and therefore will embed the eventfd
+	 * lifetime in the irqfd.
+	 */
+	file = eventfd_file_create(0, 0);
+	if (IS_ERR(file)) {
+		ret = PTR_ERR(file);
+		goto fail;
+	}
+
+	irqfd->file = file;
+
+	/*
+	 * Install our own custom wake-up handling so we are notified via
+	 * a callback whenever someone signals the underlying eventfd
+	 */
+	init_waitqueue_func_entry(&irqfd->wait, irqfd_wakeup);
+	init_poll_funcptr(&irqfd->pt, irqfd_ptable_queue_proc);
+
+	ret = file->f_op->poll(file, &irqfd->pt);
+	if (ret < 0)
+		goto fail;
+
+	mutex_lock(&kvm->lock);
+	list_add_tail(&irqfd->list, &kvm->irqfds);
+	mutex_unlock(&kvm->lock);
+
+	ret = get_unused_fd();
+	if (ret < 0)
+		goto fail;
+
+	fd = ret;
+
+	fd_install(fd, file);
+
+	return fd;
+
+fail:
+	if (file && !IS_ERR(file))
+		fput(file);
+
+	kfree(irqfd);
+	return ret;
+}
+
+void
+kvm_irqfd_release(struct kvm *kvm)
+{
+	struct _irqfd *irqfd, *tmp;
+
+	list_for_each_entry_safe(irqfd, tmp, &kvm->irqfds, list) {
+		remove_wait_queue(irqfd->wqh, &irqfd->wait);
+
+		flush_work(&irqfd->work);
+		fput(irqfd->file);
+
+		list_del(&irqfd->list);
+		kfree(irqfd);
+	}
+}
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 2b73e19..8b3b06a 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -972,6 +972,7 @@ static struct kvm *kvm_create_vm(void)
 	atomic_inc(&kvm->mm->mm_count);
 	spin_lock_init(&kvm->mmu_lock);
 	kvm_io_bus_init(&kvm->pio_bus);
+	INIT_LIST_HEAD(&kvm->irqfds);
 	mutex_init(&kvm->lock);
 	kvm_io_bus_init(&kvm->mmio_bus);
 	init_rwsem(&kvm->slots_lock);
@@ -1023,6 +1024,7 @@ static void kvm_destroy_vm(struct kvm *kvm)
 	spin_lock(&kvm_lock);
 	list_del(&kvm->vm_list);
 	spin_unlock(&kvm_lock);
+	kvm_irqfd_release(kvm);
 	kvm_free_irq_routing(kvm);
 	kvm_io_bus_destroy(&kvm->pio_bus);
 	kvm_io_bus_destroy(&kvm->mmio_bus);
@@ -2197,6 +2199,15 @@ static long kvm_vm_ioctl(struct file *filp,
 	}
 #endif
 #endif /* KVM_CAP_IRQ_ROUTING */
+	case KVM_IRQFD: {
+		struct kvm_irqfd data;
+
+		r = -EFAULT;
+		if (copy_from_user(&data, argp, sizeof data))
+			goto out;
+		r = kvm_irqfd(kvm, data.gsi, data.flags);
+		break;
+	}
 	default:
 		r = kvm_arch_vm_ioctl(filp, ioctl, arg);
 	}

