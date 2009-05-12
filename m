Return-Path: <linux-kernel-owner+w=401wt.eu-S1756066AbZELS2Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756066AbZELS2Y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 May 2009 14:28:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752888AbZELS1T
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 May 2009 14:27:19 -0400
Received: from victor.provo.novell.com ([137.65.250.26]:36911 "EHLO
	victor.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753957AbZELS1R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 May 2009 14:27:17 -0400
From: Gregory Haskins <ghaskins@novell.com>
Subject: [KVM PATCH v7 3/3] kvm: add iofd support
To: kvm@vger.kernel.org
Cc: viro@ZenIV.linux.org.uk, linux-kernel@vger.kernel.org, avi@redhat.com,
       davidel@xmailserver.org
Date: Tue, 12 May 2009 14:27:01 -0400
Message-ID: <20090512182701.26131.66801.stgit@dev.haskins.net>
In-Reply-To: <20090512181134.26131.10023.stgit@dev.haskins.net>
References: <20090512181134.26131.10023.stgit@dev.haskins.net>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

iofd is a mechanism to register PIO/MMIO regions to trigger an eventfd
signal when written to.  Userspace can register any arbitrary address
with a corresponding eventfd.

Signed-off-by: Gregory Haskins <ghaskins@novell.com>
---

 include/linux/kvm.h      |   12 +++++
 include/linux/kvm_host.h |    2 +
 virt/kvm/eventfd.c       |  107 ++++++++++++++++++++++++++++++++++++++++++++++
 virt/kvm/kvm_main.c      |   13 ++++++
 4 files changed, 134 insertions(+), 0 deletions(-)

diff --git a/include/linux/kvm.h b/include/linux/kvm.h
index dfc4bcc..99b6e45 100644
--- a/include/linux/kvm.h
+++ b/include/linux/kvm.h
@@ -292,6 +292,17 @@ struct kvm_guest_debug {
 	struct kvm_guest_debug_arch arch;
 };
 
+#define KVM_IOFD_FLAG_DEASSIGN  (1 << 0)
+#define KVM_IOFD_FLAG_PIO       (1 << 1)
+
+struct kvm_iofd {
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
@@ -508,6 +519,7 @@ struct kvm_irqfd {
 #define KVM_DEASSIGN_DEV_IRQ       _IOW(KVMIO, 0x75, struct kvm_assigned_irq)
 #define KVM_ASSIGN_IRQFD           _IOW(KVMIO, 0x76, struct kvm_irqfd)
 #define KVM_DEASSIGN_IRQFD         _IOW(KVMIO, 0x77, __u32)
+#define KVM_IOFD                   _IOW(KVMIO, 0x78, struct kvm_iofd)
 
 /*
  * ioctls for vcpu fds
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 1acc528..d53cb70 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -529,5 +529,7 @@ static inline void kvm_free_irq_routing(struct kvm *kvm) {}
 int kvm_assign_irqfd(struct kvm *kvm, int fd, int gsi, int flags);
 int kvm_deassign_irqfd(struct kvm *kvm, int fd);
 void kvm_irqfd_release(struct kvm *kvm);
+int kvm_iofd(struct kvm *kvm, unsigned long addr, size_t len,
+	     int fd, int flags);
 
 #endif
diff --git a/virt/kvm/eventfd.c b/virt/kvm/eventfd.c
index 71afd62..8b23317 100644
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
@@ -185,3 +189,106 @@ kvm_irqfd_release(struct kvm *kvm)
 	list_for_each_entry_safe(irqfd, tmp, &kvm->irqfds, list)
 		irqfd_release(irqfd);
 }
+
+/*
+ * --------------------------------------------------------------------
+ * iofd: translate a PIO/MMIO memory write to an eventfd signal.
+ *
+ * userspace can register a PIO/MMIO address with an eventfd for recieving
+ * notification when the memory has been touched.
+ * --------------------------------------------------------------------
+ */
+
+struct _iofd {
+	u64                  addr;
+	size_t               length;
+	struct file         *file;
+	struct kvm_io_device dev;
+};
+
+static int
+iofd_in_range(struct kvm_io_device *this, gpa_t addr, int len, int is_write)
+{
+	struct _iofd *iofd = (struct _iofd *)this->private;
+
+	return ((addr >= iofd->addr && (addr < iofd->addr + iofd->length)));
+}
+
+/* writes trigger an event */
+static void
+iofd_write(struct kvm_io_device *this, gpa_t addr, int len, const void *val)
+{
+	struct _iofd *iofd = (struct _iofd *)this->private;
+
+	eventfd_signal(iofd->file, 1);
+}
+
+/* reads return all zeros */
+static void
+iofd_read(struct kvm_io_device *this, gpa_t addr, int len, void *val)
+{
+	memset(val, 0, len);
+}
+
+static void
+iofd_destructor(struct kvm_io_device *this)
+{
+	struct _iofd *iofd = (struct _iofd *)this->private;
+
+	fput(iofd->file);
+	kfree(iofd);
+}
+
+static int
+kvm_assign_iofd(struct kvm *kvm, unsigned long addr, size_t len,
+		int fd, int flags)
+{
+	int                pio = flags & KVM_IOFD_FLAG_PIO;
+	struct kvm_io_bus *bus = pio ? &kvm->pio_bus : &kvm->mmio_bus;
+	struct _iofd      *iofd;
+	struct file       *file;
+
+	file = eventfd_fget(fd);
+	if (IS_ERR(file))
+		return PTR_ERR(file);
+
+	iofd = kzalloc(sizeof(*iofd), GFP_KERNEL);
+	if (!iofd) {
+		fput(file);
+		return -ENOMEM;
+	}
+
+	iofd->dev.read       = iofd_read;
+	iofd->dev.write      = iofd_write;
+	iofd->dev.in_range   = iofd_in_range;
+	iofd->dev.destructor = iofd_destructor;
+	iofd->dev.private    = iofd;
+
+	iofd->addr           = addr;
+	iofd->length         = len;
+	iofd->file           = file;
+
+	kvm_io_bus_register_dev(bus, &iofd->dev);
+
+	printk(KERN_DEBUG "registering %s iofd at %lx of size %d\n",
+	       pio  ? "PIO" : "MMIO", addr, (int)len);
+
+	return 0;
+}
+
+static int
+kvm_deassign_iofd(struct kvm *kvm, unsigned long addr, size_t len,
+		  int fd, int flags)
+{
+	/* FIXME: We need an io_bus_unregister() function */
+	return -EINVAL;
+}
+
+int
+kvm_iofd(struct kvm *kvm, unsigned long addr, size_t len, int fd, int flags)
+{
+	if (flags & KVM_IOFD_FLAG_DEASSIGN)
+		return kvm_deassign_iofd(kvm, addr, len, fd, flags);
+
+	return kvm_assign_iofd(kvm, addr, len, fd, flags);
+}
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 7aa9f0a..a443974 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -2228,6 +2228,19 @@ static long kvm_vm_ioctl(struct file *filp,
 		r = kvm_deassign_irqfd(kvm, data);
 		break;
 	}
+	case KVM_IOFD: {
+		struct kvm_iofd entry;
+
+		r = -EFAULT;
+		if (copy_from_user(&entry, argp, sizeof entry))
+			goto out;
+
+		r = kvm_iofd(kvm, entry.addr, entry.len, entry.fd,
+			     entry.flags);
+		if (r)
+			goto out;
+		break;
+	}
 	default:
 		r = kvm_arch_vm_ioctl(filp, ioctl, arg);
 	}

