Return-Path: <linux-kernel-owner+w=401wt.eu-S932463AbZGPPUA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932463AbZGPPUA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jul 2009 11:20:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932454AbZGPPUA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Jul 2009 11:20:00 -0400
Received: from victor.provo.novell.com ([137.65.250.26]:52577 "EHLO
	victor.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932303AbZGPPT5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jul 2009 11:19:57 -0400
From: Gregory Haskins <ghaskins@novell.com>
Subject: [KVM PATCH] KVM: introduce "xinterface" API for external interaction
	with guests
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, avi@redhat.com, glommer@redhat.com,
       aliguori@us.ibm.com
Date: Thu, 16 Jul 2009 11:19:46 -0400
Message-ID: <20090716151945.29318.10882.stgit@dev.haskins.net>
In-Reply-To: <20090716150323.29318.17714.stgit@dev.haskins.net>
References: <20090716150323.29318.17714.stgit@dev.haskins.net>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

What: xinterface is a mechanism that allows kernel modules external to
the kvm.ko proper to interface with a running guest.  It accomplishes
this by creating an abstracted interface which does not expose any
private details of the guest or its related KVM structures, and provides
a mechanism to find and bind to this interface at run-time.  This
binding mechanism uses a userspace friendly token "u64 vmid" as a
handle.  This vmid acts similar to a file-descriptor in the sense that
it can be extracted from a guest, passed to an end-point of interest,
and finally, converted back to a vtable pointer using a stable interface.

Why: There are various subsystems that would like to interact with a KVM
guest which are ideally suited to exist outside the domain of the kvm.ko
core logic. For instance, external pci-passthrough, virtual-bus, and
virtio-net modules are currently under development.  In order for these
modules to successfully interact with the guest, they need, at the very
least, various interfaces for signaling IO events, pointer translation,
and possibly memory mapping.

The signaling case is covered by the recent introduction of the
irqfd/ioeventfd mechanisms.  This patch provides a mechanism to cover the
other cases.  Note that today we only expose pointer-translation related
functions, but more could be added at a future date as needs arise.

Security considerations: This concept is not believed to expose KVM to
any kind of additional security risk.  The vmid token itself can only be
acquired via an open handle to the vmfd (i.e. qemu-kvm), and the interface
is only available within the kernel.  Therefore the xinterface
admission policy is delegated to the kernel/lkm admission policy, which
must be assumed secure or the system is already compromised independent of
this work.

Additionally, the xinterface design is hardened against malformed vmid
tokens, as well as race conditions against valid tokens (e.g. guest
exiting before the token is redeemed).  It is additionally hardened
against races in the kvm.ko module itself by acquiring proper module
references.  As a final measure, we link the xinterface code statically
into the kernel so that callers are guaranteed a stable interface to
kvm_xinterface_find() without implicitly pinning kvm.ko or racing against
it.

Example usage: QEMU instantiates a guest, and an external module "foo"
that desires the ability to interface with the guest (say via
open("/dev/foo")).  QEMU may then issue a KVM_GET_VMID operation to acquire
the u64-based vmid, and pass it to ioctl(foofd, FOO_SET_VMID, &vmid).
Upon receipt, the foo module can issue kvm_xinterface_find(vmid) to acquire
the proper context.  Internally, the struct kvm* and associated
struct module* will remain pinned at least until the foo module calls
kvm_xinterface_put().

Signed-off-by: Gregory Haskins <ghaskins@novell.com>
---

 arch/x86/Kbuild                |    4 +
 arch/x86/kvm/Makefile          |    4 +
 arch/x86/kvm/x86.c             |    1 
 include/linux/kvm.h            |    2 +
 include/linux/kvm_host.h       |    6 ++
 include/linux/kvm_xinterface.h |   58 ++++++++++++++++
 virt/kvm/kvm_main.c            |   72 ++++++++++++++++++++
 virt/kvm/xinterface.c          |  147 ++++++++++++++++++++++++++++++++++++++++
 8 files changed, 293 insertions(+), 1 deletions(-)
 create mode 100644 include/linux/kvm_xinterface.h
 create mode 100644 virt/kvm/xinterface.c

diff --git a/arch/x86/Kbuild b/arch/x86/Kbuild
index ad8ec35..9f50cc3 100644
--- a/arch/x86/Kbuild
+++ b/arch/x86/Kbuild
@@ -1,5 +1,7 @@
 
-obj-$(CONFIG_KVM) += kvm/
+ifdef CONFIG_KVM
+obj-y += kvm/
+endif
 
 # Xen paravirtualization support
 obj-$(CONFIG_XEN) += xen/
diff --git a/arch/x86/kvm/Makefile b/arch/x86/kvm/Makefile
index afaaa76..80d951d 100644
--- a/arch/x86/kvm/Makefile
+++ b/arch/x86/kvm/Makefile
@@ -17,3 +17,7 @@ kvm-amd-y		+= svm.o
 obj-$(CONFIG_KVM)	+= kvm.o
 obj-$(CONFIG_KVM_INTEL)	+= kvm-intel.o
 obj-$(CONFIG_KVM_AMD)	+= kvm-amd.o
+
+ifdef CONFIG_KVM
+obj-y += $(addprefix ../../../virt/kvm/, xinterface.o)
+endif
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 48567fa..5725527 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -1208,6 +1208,7 @@ int kvm_dev_ioctl_check_extension(long ext)
 	case KVM_CAP_IOEVENTFD:
 	case KVM_CAP_PIT2:
 	case KVM_CAP_PIT_STATE2:
+	case KVM_CAP_XINTERFACE:
 		r = 1;
 		break;
 	case KVM_CAP_COALESCED_MMIO:
diff --git a/include/linux/kvm.h b/include/linux/kvm.h
index 230a91a..7790894 100644
--- a/include/linux/kvm.h
+++ b/include/linux/kvm.h
@@ -435,6 +435,7 @@ struct kvm_ioeventfd {
 #define KVM_CAP_PIT_STATE2 35
 #endif
 #define KVM_CAP_IOEVENTFD 36
+#define KVM_CAP_XINTERFACE 37
 
 #ifdef KVM_CAP_IRQ_ROUTING
 
@@ -544,6 +545,7 @@ struct kvm_irqfd {
 #define KVM_CREATE_PIT2		   _IOW(KVMIO, 0x77, struct kvm_pit_config)
 #define KVM_SET_BOOT_CPU_ID        _IO(KVMIO, 0x78)
 #define KVM_IOEVENTFD             _IOW(KVMIO, 0x79, struct kvm_ioeventfd)
+#define KVM_GET_VMID              _IOR(KVMIO, 0x7a, __u64)
 
 /*
  * ioctls for vcpu fds
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index f244f11..0ee95df 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -23,6 +23,7 @@
 #include <linux/kvm_para.h>
 
 #include <linux/kvm_types.h>
+#include <linux/kvm_xinterface.h>
 
 #include <asm/kvm_host.h>
 
@@ -175,6 +176,7 @@ struct kvm {
 	unsigned long mmu_notifier_seq;
 	long mmu_notifier_count;
 #endif
+	struct kvm_xinterface xinterface; /* interface for external modules */
 };
 
 /* The guest did something we don't support. */
@@ -199,6 +201,10 @@ static inline struct kvm_vcpu *kvm_get_vcpu(struct kvm *kvm, int i)
 	     idx < atomic_read(&kvm->online_vcpus) && vcpup; \
 	     vcpup = kvm_get_vcpu(kvm, ++idx))
 
+void kvm_xinterface_register(struct kvm_xinterface *intf,
+			     const struct kvm_xinterface_ops *ops);
+void kvm_xinterface_unregister(struct kvm_xinterface *intf);
+
 int kvm_vcpu_init(struct kvm_vcpu *vcpu, struct kvm *kvm, unsigned id);
 void kvm_vcpu_uninit(struct kvm_vcpu *vcpu);
 
diff --git a/include/linux/kvm_xinterface.h b/include/linux/kvm_xinterface.h
new file mode 100644
index 0000000..858acfd
--- /dev/null
+++ b/include/linux/kvm_xinterface.h
@@ -0,0 +1,58 @@
+#ifndef __KVM_XINTERFACE_H
+#define __KVM_XINTERFACE_H
+
+/*
+ * This work is licensed under the terms of the GNU GPL, version 2.  See
+ * the COPYING file in the top-level directory.
+ */
+
+#include <linux/kref.h>
+#include <linux/module.h>
+#include <linux/rbtree.h>
+
+struct kvm_xinterface;
+
+struct kvm_xinterface_ops {
+	struct module *owner;
+
+	unsigned long (*gpa_to_hva)(struct kvm_xinterface *, unsigned long gpa);
+	struct page*  (*gpa_to_page)(struct kvm_xinterface *, unsigned long gpa);
+	void (*release)(struct kvm_xinterface *);
+};
+
+struct kvm_xinterface {
+	struct kref                     kref;
+	const struct kvm_xinterface_ops *ops;
+	struct rb_node                  node;
+};
+
+static inline void
+kvm_xinterface_get(struct kvm_xinterface *intf)
+{
+	kref_get(&intf->kref);
+}
+
+static inline void
+_kvm_xinterface_release(struct kref *kref)
+{
+	struct kvm_xinterface *intf;
+	struct module *owner;
+
+	intf = container_of(kref, struct kvm_xinterface, kref);
+
+	owner = intf->ops->owner;
+	rmb();
+
+	intf->ops->release(intf);
+	module_put(owner);
+}
+
+static inline void
+kvm_xinterface_put(struct kvm_xinterface *intf)
+{
+	kref_put(&intf->kref, _kvm_xinterface_release);
+}
+
+struct kvm_xinterface *kvm_xinterface_find(long vmid);
+
+#endif /* __KVM_XINTERFACE_H */
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 7cd1c10..058cb6c 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -935,6 +935,58 @@ static const struct mmu_notifier_ops kvm_mmu_notifier_ops = {
 };
 #endif /* CONFIG_MMU_NOTIFIER && KVM_ARCH_WANT_MMU_NOTIFIER */
 
+/*
+ * ------------
+ * XINTERFACE (External Interface)
+ * -------------
+ */
+
+static struct kvm *
+intf_to_kvm(struct kvm_xinterface *intf)
+{
+	return container_of(intf, struct kvm, xinterface);
+}
+
+static unsigned long
+xinterface_gpa_to_hva(struct kvm_xinterface *intf, unsigned long gpa)
+{
+	struct kvm *kvm = intf_to_kvm(intf);
+	unsigned long addr;
+
+	addr = gfn_to_hva(kvm, gpa >> PAGE_SHIFT);
+	if (kvm_is_error_hva(addr))
+		return 0;
+
+	return addr + offset_in_page(gpa);
+}
+
+static struct page *
+xinterface_gpa_to_page(struct kvm_xinterface *intf, unsigned long gpa)
+{
+	struct kvm *kvm = intf_to_kvm(intf);
+	struct page *page;
+
+	page = gfn_to_page(kvm, gpa >> PAGE_SHIFT);
+	if (page == bad_page)
+		return ERR_PTR(-EINVAL);
+
+	return page;
+}
+
+static void
+xinterface_release(struct kvm_xinterface *intf)
+{
+	struct kvm *kvm = intf_to_kvm(intf);
+
+	kvm_put_kvm(kvm);
+}
+
+struct kvm_xinterface_ops _kvm_xinterface_ops = {
+	.gpa_to_hva  = xinterface_gpa_to_hva,
+	.gpa_to_page = xinterface_gpa_to_page,
+	.release     = xinterface_release,
+};
+
 static struct kvm *kvm_create_vm(void)
 {
 	struct kvm *kvm = kvm_arch_create_vm();
@@ -991,6 +1043,8 @@ static struct kvm *kvm_create_vm(void)
 #ifdef KVM_COALESCED_MMIO_PAGE_OFFSET
 	kvm_coalesced_mmio_init(kvm);
 #endif
+	kvm_get_kvm(kvm); /* the xinterface needs another ref */
+	kvm_xinterface_register(&kvm->xinterface, &_kvm_xinterface_ops);
 out:
 	return kvm;
 }
@@ -1073,6 +1127,7 @@ static int kvm_vm_release(struct inode *inode, struct file *filp)
 	struct kvm *kvm = filp->private_data;
 
 	kvm_irqfd_release(kvm);
+	kvm_xinterface_unregister(&kvm->xinterface);
 
 	kvm_put_kvm(kvm);
 	return 0;
@@ -2289,6 +2344,22 @@ static long kvm_vm_ioctl(struct file *filp,
 		mutex_unlock(&kvm->lock);
 		break;
 #endif
+	case KVM_GET_VMID: {
+		u64 vmid = (u64)&kvm->xinterface.node;
+
+		/*
+		 * our vmid is simply the address of our rb_node in the
+		 * registry, which is guaranteed unique.  This also simplifies
+		 * the registry map-lookup since we dont need to do a deep
+		 * decode on the pointer to figure out if we have a match
+		 */
+
+		r = -EFAULT;
+		if (copy_to_user(argp, &vmid, (sizeof vmid)))
+			goto out;
+		r = 0;
+		break;
+	}
 	default:
 		r = kvm_arch_vm_ioctl(filp, ioctl, arg);
 	}
@@ -2761,6 +2832,7 @@ int kvm_init(void *opaque, unsigned int vcpu_size,
 	kvm_chardev_ops.owner = module;
 	kvm_vm_fops.owner = module;
 	kvm_vcpu_fops.owner = module;
+	_kvm_xinterface_ops.owner = module;
 
 	r = misc_register(&kvm_dev);
 	if (r) {
diff --git a/virt/kvm/xinterface.c b/virt/kvm/xinterface.c
new file mode 100644
index 0000000..fe9a214
--- /dev/null
+++ b/virt/kvm/xinterface.c
@@ -0,0 +1,147 @@
+/*
+ * KVM module interface - Allows external modules to interface with a guest
+ *
+ * This code is designed to be statically linked to the kernel, regardless
+ * of the configuration of kvm.ko.  This allows the kvm_xinterface_find
+ * routine to be stably exported without dependencies on, or race conditions
+ * against acquiring the kvm.ko module itself.
+ *
+ * Copyright 2009 Novell.  All Rights Reserved.
+ *
+ * Author:
+ *      Gregory Haskins <ghaskins@novell.com>
+ *
+ * This file is free software; you can redistribute it and/or modify
+ * it under the terms of version 2 of the GNU General Public License
+ * as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software Foundation,
+ * Inc., 51 Franklin St, Fifth Floor, Boston, MA 02110-1301, USA.
+ */
+
+#include <linux/module.h>
+#include <linux/mutex.h>
+#include <linux/kvm_host.h>
+#include <linux/kvm_xinterface.h>
+
+struct kvm_registry {
+	struct mutex   lock;
+	struct rb_root root;
+};
+
+/* system wide registry of kvm based VMs */
+static struct kvm_registry kvm_registry = {
+	.lock = __MUTEX_INITIALIZER(kvm_registry.lock),
+	.root = RB_ROOT,
+};
+
+static struct kvm_xinterface *
+to_intf(struct rb_node *node)
+{
+	return node ? container_of(node, struct kvm_xinterface, node) : NULL;
+}
+
+struct kvm_xinterface *
+kvm_xinterface_find(long vmid)
+{
+	struct rb_node       *node;
+	struct kvm_xinterface *intf;
+
+	mutex_lock(&kvm_registry.lock);
+
+	node = kvm_registry.root.rb_node;
+
+	while (node) {
+		long val;
+
+		val = vmid - (long)node;
+		if (val < 0)
+			node = node->rb_left;
+		else if (val > 0)
+			node = node->rb_right;
+		else
+			break;
+	}
+
+	intf = to_intf(node);
+	if (intf)
+		kvm_xinterface_get(intf);
+
+	mutex_unlock(&kvm_registry.lock);
+
+	return intf;
+}
+EXPORT_SYMBOL_GPL(kvm_xinterface_find);
+
+/*
+ * ------------------------------------------
+ * register/unregister
+ * ------------------------------------------
+ *
+ * These functions are private to the API and are only to be called
+ * by the KVM core
+ * ------------------------------------------
+ */
+
+/* caller must hold intf->ops->owner */
+void
+kvm_xinterface_register(struct kvm_xinterface *intf,
+			const struct kvm_xinterface_ops *ops)
+{
+	struct rb_root *root;
+	struct rb_node **new, *parent = NULL;
+	struct rb_node *node;
+
+	memset(intf, 0, sizeof(*intf));
+	kref_init(&intf->kref);
+	intf->ops = ops;
+
+	mutex_lock(&kvm_registry.lock);
+
+	root = &kvm_registry.root;
+	new  = &(root->rb_node);
+	node = &intf->node;
+
+	/* Figure out where to put new node */
+	while (*new) {
+		long val;
+
+		parent = *new;
+
+		val = node - parent;
+		if (val < 0)
+			new = &((*new)->rb_left);
+		else if (val > 0)
+			new = &((*new)->rb_right);
+		else
+			panic("kvm_xinterface: duplicate entry: %ld\n", val);
+	}
+
+	/* Add new node and rebalance tree. */
+	rb_link_node(node, parent, new);
+	rb_insert_color(node, root);
+
+	/* released when the last xinterface reference is released */
+	__module_get(intf->ops->owner);
+
+	mutex_unlock(&kvm_registry.lock);
+}
+EXPORT_SYMBOL_GPL(kvm_xinterface_register);
+
+/* caller must hold intf->ops->owner */
+void
+kvm_xinterface_unregister(struct kvm_xinterface *intf)
+{
+	mutex_lock(&kvm_registry.lock);
+	rb_erase(&intf->node, &kvm_registry.root);
+	mutex_unlock(&kvm_registry.lock);
+
+	kvm_xinterface_put(intf);
+}
+EXPORT_SYMBOL_GPL(kvm_xinterface_unregister);

