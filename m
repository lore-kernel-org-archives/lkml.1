Return-Path: <linux-kernel-owner+w=401wt.eu-S1759761AbZDWPP7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759761AbZDWPP7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Apr 2009 11:15:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759422AbZDWPPA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Apr 2009 11:15:00 -0400
Received: from victor.provo.novell.com ([137.65.250.26]:44279 "EHLO
	victor.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757999AbZDWPO6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Apr 2009 11:14:58 -0400
From: Gregory Haskins <ghaskins@novell.com>
Subject: [KVM PATCH 3/3] kvm: add support for irqfd via eventfd-notification
	interface
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, avi@redhat.com, davidel@xmailserver.org
Date: Thu, 23 Apr 2009 11:14:41 -0400
Message-ID: <20090423151441.14094.22549.stgit@dev.haskins.net>
In-Reply-To: <20090423150910.14094.73708.stgit@dev.haskins.net>
References: <20090423150910.14094.73708.stgit@dev.haskins.net>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This allows an eventfd to be registered as an irq source with a guest.  Any
signaling operation on the eventfd (via userspace or kernel) will inject
the registered GSI at the next available window.

Signed-off-by: Gregory Haskins <ghaskins@novell.com>
---

 arch/x86/kvm/Makefile    |    2 -
 arch/x86/kvm/x86.c       |    1 
 include/linux/kvm.h      |    7 ++
 include/linux/kvm_host.h |    7 ++
 virt/kvm/irqfd.c         |  133 ++++++++++++++++++++++++++++++++++++++++++++++
 virt/kvm/kvm_main.c      |   12 ++++
 6 files changed, 161 insertions(+), 1 deletions(-)
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
index 8cb8542..88c45e6 100644
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
index 3db5d8d..2404775 100644
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
+	__u32 fd;
+	__u32 gsi;
+};
+
 /*
  * ioctls for VM fds
  */
@@ -498,6 +504,7 @@ struct kvm_irq_routing {
 #define KVM_ASSIGN_SET_MSIX_ENTRY \
 			_IOW(KVMIO, 0x74, struct kvm_assigned_msix_entry)
 #define KVM_DEASSIGN_DEV_IRQ       _IOW(KVMIO, 0x75, struct kvm_assigned_irq)
+#define KVM_ASSIGN_IRQFD          _IOW(KVMIO, 0x76, struct kvm_irqfd)
 
 /*
  * ioctls for vcpu fds
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 095ebb6..57f8dfe 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -134,6 +134,10 @@ struct kvm {
 	struct list_head vm_list;
 	struct kvm_io_bus mmio_bus;
 	struct kvm_io_bus pio_bus;
+	struct {
+		struct list_head items;
+		int              src;
+	} irqfd;
 	struct kvm_vm_stat stat;
 	struct kvm_arch arch;
 	atomic_t users_count;
@@ -524,4 +528,7 @@ static inline void kvm_free_irq_routing(struct kvm *kvm) {}
 
 #endif
 
+int kvm_irqfd_assign(struct kvm *kvm, int fd, int gsi);
+void kvm_irqfd_release(struct kvm *kvm);
+
 #endif
diff --git a/virt/kvm/irqfd.c b/virt/kvm/irqfd.c
new file mode 100644
index 0000000..d6829b3
--- /dev/null
+++ b/virt/kvm/irqfd.c
@@ -0,0 +1,133 @@
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
+#include <linux/notifier.h>
+#include <linux/file.h>
+#include <linux/list.h>
+
+struct _irqfd {
+	struct kvm               *kvm;
+	int                       gsi;
+	struct file              *file;
+	struct list_head          list;
+	struct notifier_block     nb;
+	struct work_struct        work;
+};
+
+static void
+irqfd_deferred_inject(struct work_struct *work)
+{
+	struct _irqfd *irqfd = container_of(work, struct _irqfd, work);
+	struct kvm *kvm = irqfd->kvm;
+
+	mutex_lock(&kvm->lock);
+	kvm_set_irq(kvm, kvm->irqfd.src, irqfd->gsi, 1);
+	mutex_unlock(&kvm->lock);
+}
+
+static int
+irqfd_inject(struct notifier_block *nb, unsigned long nr, void *val)
+{
+	struct _irqfd *irqfd = container_of(nb, struct _irqfd, nb);
+
+	/*
+	 * The eventfd calls its notifier chain with interrupts disabled,
+	 * so we need to defer the IRQ injection until later since we need
+	 * to acquire the kvm->lock to do so.
+	 */
+	schedule_work(&irqfd->work);
+
+	return 0;
+}
+
+int
+kvm_irqfd_assign(struct kvm *kvm, int fd, int gsi)
+{
+	struct _irqfd *irqfd;
+	int ret;
+
+	irqfd = kzalloc(sizeof(*irqfd), GFP_KERNEL);
+	if (!irqfd)
+		return -ENOMEM;
+
+	irqfd->kvm = kvm;
+	irqfd->gsi = gsi;
+	INIT_LIST_HEAD(&irqfd->list);
+	irqfd->nb.notifier_call = &irqfd_inject;
+	irqfd->nb.priority = 0;
+	INIT_WORK(&irqfd->work, irqfd_deferred_inject);
+
+	/*
+	 * note: this acquires a reference to the fd that we are responsible
+	 * for dropping later
+	 */
+	irqfd->file = eventfd_notifier_register(fd, &irqfd->nb);
+	if (IS_ERR(irqfd->file)) {
+		ret = PTR_ERR(irqfd->file);
+		goto fail;
+	}
+
+	mutex_lock(&kvm->lock);
+	if (kvm->irqfd.src == -1) {
+		ret = kvm_request_irq_source_id(kvm);
+		BUG_ON(ret < 0);
+
+		kvm->irqfd.src = ret;
+	}
+
+	list_add_tail(&irqfd->list, &kvm->irqfd.items);
+
+	mutex_unlock(&kvm->lock);
+
+	return 0;
+
+fail:
+	kfree(irqfd);
+	return ret;
+}
+
+void
+kvm_irqfd_release(struct kvm *kvm)
+{
+	struct _irqfd *irqfd, *tmp;
+	int ret;
+
+	list_for_each_entry_safe(irqfd, tmp, &kvm->irqfd.items, list) {
+		ret = eventfd_notifier_unregister(irqfd->file, &irqfd->nb);
+		BUG_ON(ret < 0);
+
+		flush_work(&irqfd->work);
+		fput(irqfd->file);
+
+		list_del(&irqfd->list);
+		kfree(irqfd);
+	}
+
+	if (kvm->irqfd.src != -1)
+		kvm_free_irq_source_id(kvm, kvm->irqfd.src);
+
+}
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 3265566..c822d79 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -972,6 +972,8 @@ static struct kvm *kvm_create_vm(void)
 	atomic_inc(&kvm->mm->mm_count);
 	spin_lock_init(&kvm->mmu_lock);
 	kvm_io_bus_init(&kvm->pio_bus);
+	INIT_LIST_HEAD(&kvm->irqfd.items);
+	kvm->irqfd.src = -1;
 	mutex_init(&kvm->lock);
 	kvm_io_bus_init(&kvm->mmio_bus);
 	init_rwsem(&kvm->slots_lock);
@@ -1023,6 +1025,7 @@ static void kvm_destroy_vm(struct kvm *kvm)
 	spin_lock(&kvm_lock);
 	list_del(&kvm->vm_list);
 	spin_unlock(&kvm_lock);
+	kvm_irqfd_release(kvm);
 	kvm_free_irq_routing(kvm);
 	kvm_io_bus_destroy(&kvm->pio_bus);
 	kvm_io_bus_destroy(&kvm->mmio_bus);
@@ -2197,6 +2200,15 @@ static long kvm_vm_ioctl(struct file *filp,
 	}
 #endif
 #endif /* KVM_CAP_IRQ_ROUTING */
+	case KVM_ASSIGN_IRQFD: {
+		struct kvm_irqfd data;
+
+		r = -EFAULT;
+		if (copy_from_user(&data, argp, sizeof data))
+			goto out;
+		r = kvm_irqfd_assign(kvm, data.fd, data.gsi);
+		break;
+	}
 	default:
 		r = kvm_arch_vm_ioctl(filp, ioctl, arg);
 	}

