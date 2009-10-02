Return-Path: <linux-kernel-owner+w=401wt.eu-S1758095AbZJBUTk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758095AbZJBUTk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Oct 2009 16:19:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758029AbZJBUTj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Oct 2009 16:19:39 -0400
Received: from victor.provo.novell.com ([137.65.250.26]:39245 "EHLO
	victor.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758020AbZJBUTf (ORCPT
	<rfc822;groupwise-GHaskins@novell.com;0:0>);
	Fri, 2 Oct 2009 16:19:35 -0400
From: Gregory Haskins <ghaskins@novell.com>
Subject: [PATCH v2 2/4] KVM: introduce "xinterface" API for external
	interaction with guests
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, ghaskins@novell.com
Date: Fri, 02 Oct 2009 16:19:27 -0400
Message-ID: <20091002201927.4014.29432.stgit@dev.haskins.net>
In-Reply-To: <20091002201159.4014.33268.stgit@dev.haskins.net>
References: <20091002201159.4014.33268.stgit@dev.haskins.net>
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
a mechanism to find and bind to this interface at run-time.

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

Example usage: QEMU instantiates a guest, and an external module "foo"
that desires the ability to interface with the guest (say via
open("/dev/foo")).  QEMU may then pass the kvmfd to foo via an
ioctl, such as: ioctl(foofd, FOO_SET_VMID, &kvmfd).  Upon receipt, the
foo module can issue kvm_xinterface_bind(kvmfd) to acquire
the proper context.  Internally, the struct kvm* and associated
struct module* will remain pinned at least until the foo module calls
kvm_xinterface_put().

Signed-off-by: Gregory Haskins <ghaskins@novell.com>
---

 arch/x86/kvm/Makefile          |    2 
 include/linux/kvm_host.h       |    3 
 include/linux/kvm_xinterface.h |  114 +++++++++++
 kernel/fork.c                  |    1 
 virt/kvm/kvm_main.c            |   24 ++
 virt/kvm/xinterface.c          |  409 ++++++++++++++++++++++++++++++++++++++++
 6 files changed, 552 insertions(+), 1 deletions(-)
 create mode 100644 include/linux/kvm_xinterface.h
 create mode 100644 virt/kvm/xinterface.c

diff --git a/arch/x86/kvm/Makefile b/arch/x86/kvm/Makefile
index 31a7035..0449d6e 100644
--- a/arch/x86/kvm/Makefile
+++ b/arch/x86/kvm/Makefile
@@ -7,7 +7,7 @@ CFLAGS_vmx.o := -I.
 
 kvm-y			+= $(addprefix ../../../virt/kvm/, kvm_main.o ioapic.o \
 				coalesced_mmio.o irq_comm.o eventfd.o \
-				assigned-dev.o)
+				assigned-dev.o xinterface.o)
 kvm-$(CONFIG_IOMMU_API)	+= $(addprefix ../../../virt/kvm/, iommu.o)
 
 kvm-y			+= x86.o mmu.o emulate.o i8259.o irq.o lapic.o \
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index b985a29..7cc1afb 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -362,6 +362,9 @@ void kvm_arch_sync_events(struct kvm *kvm);
 int kvm_cpu_has_pending_timer(struct kvm_vcpu *vcpu);
 void kvm_vcpu_kick(struct kvm_vcpu *vcpu);
 
+struct kvm_xinterface *
+kvm_xinterface_alloc(struct kvm *kvm, struct module *owner);
+
 int kvm_is_mmio_pfn(pfn_t pfn);
 
 struct kvm_irq_ack_notifier {
diff --git a/include/linux/kvm_xinterface.h b/include/linux/kvm_xinterface.h
new file mode 100644
index 0000000..01f092b
--- /dev/null
+++ b/include/linux/kvm_xinterface.h
@@ -0,0 +1,114 @@
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
+#include <linux/file.h>
+
+struct kvm_xinterface;
+struct kvm_xvmap;
+
+struct kvm_xinterface_ops {
+	unsigned long (*copy_to)(struct kvm_xinterface *intf,
+				 unsigned long gpa, const void *src,
+				 unsigned long len);
+	unsigned long (*copy_from)(struct kvm_xinterface *intf, void *dst,
+				   unsigned long gpa, unsigned long len);
+	struct kvm_xvmap* (*vmap)(struct kvm_xinterface *intf,
+				  unsigned long gpa,
+				  unsigned long len);
+	void (*release)(struct kvm_xinterface *);
+};
+
+struct kvm_xinterface {
+	struct module                   *owner;
+	struct kref                      kref;
+	const struct kvm_xinterface_ops *ops;
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
+	owner = intf->owner;
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
+struct kvm_xvmap_ops {
+	void (*release)(struct kvm_xvmap *vmap);
+};
+
+struct kvm_xvmap {
+	struct kref                 kref;
+	const struct kvm_xvmap_ops *ops;
+	struct kvm_xinterface      *intf;
+	void                       *addr;
+	size_t                      len;
+};
+
+static inline void
+kvm_xvmap_init(struct kvm_xvmap *vmap, const struct kvm_xvmap_ops *ops,
+	       struct kvm_xinterface *intf)
+{
+	memset(vmap, 0, sizeof(vmap));
+	kref_init(&vmap->kref);
+	vmap->ops = ops;
+	vmap->intf = intf;
+
+	kvm_xinterface_get(intf);
+}
+
+static inline void
+kvm_xvmap_get(struct kvm_xvmap *vmap)
+{
+	kref_get(&vmap->kref);
+}
+
+static inline void
+_kvm_xvmap_release(struct kref *kref)
+{
+	struct kvm_xvmap *vmap;
+	struct kvm_xinterface *intf;
+
+	vmap = container_of(kref, struct kvm_xvmap, kref);
+
+	intf = vmap->intf;
+	rmb();
+
+	vmap->ops->release(vmap);
+	kvm_xinterface_put(intf);
+}
+
+static inline void
+kvm_xvmap_put(struct kvm_xvmap *vmap)
+{
+	kref_put(&vmap->kref, _kvm_xvmap_release);
+}
+
+struct kvm_xinterface *kvm_xinterface_bind(int fd);
+
+#endif /* __KVM_XINTERFACE_H */
diff --git a/kernel/fork.c b/kernel/fork.c
index 1020977..6290e95 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -167,6 +167,7 @@ void __put_task_struct(struct task_struct *tsk)
 	if (!profile_handoff_task(tsk))
 		free_task(tsk);
 }
+EXPORT_SYMBOL_GPL(__put_task_struct);
 
 /*
  * macro override instead of weak attribute alias, to workaround
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 9e776d9..0fae69c 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -43,6 +43,7 @@
 #include <linux/swap.h>
 #include <linux/bitops.h>
 #include <linux/spinlock.h>
+#include <linux/kvm_xinterface.h>
 
 #include <asm/processor.h>
 #include <asm/io.h>
@@ -2098,3 +2099,26 @@ void kvm_exit(void)
 	__free_page(bad_page);
 }
 EXPORT_SYMBOL_GPL(kvm_exit);
+
+struct kvm_xinterface *
+kvm_xinterface_bind(int fd)
+{
+	struct kvm_xinterface *intf;
+	struct file *file;
+
+	file = fget(fd);
+	if (!file)
+		return ERR_PTR(-EBADF);
+
+	if (file->f_op != &kvm_vm_fops) {
+		fput(file);
+		return ERR_PTR(-EINVAL);
+	}
+
+	intf = kvm_xinterface_alloc(file->private_data, file->f_op->owner);
+
+	fput(file);
+
+	return intf;
+}
+EXPORT_SYMBOL_GPL(kvm_xinterface_bind);
diff --git a/virt/kvm/xinterface.c b/virt/kvm/xinterface.c
new file mode 100644
index 0000000..3b586c5
--- /dev/null
+++ b/virt/kvm/xinterface.c
@@ -0,0 +1,409 @@
+/*
+ * KVM module interface - Allows external modules to interface with a guest
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
+#include <linux/mm.h>
+#include <linux/vmalloc.h>
+#include <linux/highmem.h>
+#include <linux/module.h>
+#include <linux/mmu_context.h>
+#include <linux/kvm_host.h>
+#include <linux/kvm_xinterface.h>
+
+struct _xinterface {
+	struct kvm             *kvm;
+	struct task_struct     *task;
+	struct mm_struct       *mm;
+	struct kvm_xinterface   intf;
+	struct kvm_memory_slot *slotcache[NR_CPUS];
+};
+
+struct _xvmap {
+	struct kvm_memory_slot    *memslot;
+	unsigned long              npages;
+	struct kvm_xvmap           vmap;
+};
+
+static struct _xinterface *
+to_intf(struct kvm_xinterface *intf)
+{
+	return container_of(intf, struct _xinterface, intf);
+}
+
+#define _gfn_to_hva(gfn, memslot) \
+	(memslot->userspace_addr + (gfn - memslot->base_gfn) * PAGE_SIZE)
+
+/*
+ * gpa_to_hva() - translate a guest-physical to host-virtual using
+ * a per-cpu cache of the memslot.
+ *
+ * The gfn_to_memslot() call is relatively expensive, and the gpa access
+ * patterns exhibit a high degree of locality.  Therefore, lets cache
+ * the last slot used on a per-cpu basis to optimize the lookup
+ *
+ * assumes slots_lock held for read
+ */
+static unsigned long
+gpa_to_hva(struct _xinterface *_intf, unsigned long gpa)
+{
+	int                     cpu     = get_cpu();
+	unsigned long           gfn     = gpa >> PAGE_SHIFT;
+	struct kvm_memory_slot *memslot = _intf->slotcache[cpu];
+	unsigned long           addr    = 0;
+
+	if (!memslot
+	    || gfn < memslot->base_gfn
+	    || gfn >= memslot->base_gfn + memslot->npages) {
+
+		memslot = gfn_to_memslot(_intf->kvm, gfn);
+		if (!memslot)
+			goto out;
+
+		_intf->slotcache[cpu] = memslot;
+	}
+
+	addr = _gfn_to_hva(gfn, memslot) + offset_in_page(gpa);
+
+out:
+	put_cpu();
+
+	return addr;
+}
+
+/*------------------------------------------------------------------------*/
+
+static void *
+_vmap(struct _xinterface *_intf, unsigned long addr, unsigned long offset,
+      unsigned long npages)
+{
+	struct task_struct *p = _intf->task;
+	struct mm_struct *mm = _intf->mm;
+	struct page **page_list;
+	void *ptr = NULL;
+	int ret;
+
+	if (npages > (PAGE_SIZE / sizeof(struct page *)))
+		return NULL;
+
+	page_list = (struct page **) __get_free_page(GFP_KERNEL);
+	if (!page_list)
+		return NULL;
+
+	down_write(&mm->mmap_sem);
+
+	ret = get_user_pages(p, mm, addr, npages, 1, 0, page_list, NULL);
+	if (ret < 0)
+		goto out;
+
+	ptr = vmap(page_list, npages, VM_MAP, PAGE_KERNEL);
+	if (ptr)
+		mm->locked_vm += npages;
+
+	ptr = ptr + offset;
+
+out:
+	up_write(&mm->mmap_sem);
+
+	free_page((unsigned long)page_list);
+
+	return ptr;
+}
+
+static void
+_vunmap(struct _xinterface *_intf, void *addr, size_t npages)
+{
+	down_write(&_intf->mm->mmap_sem);
+
+	vunmap((void *)((unsigned long)addr & PAGE_MASK));
+	_intf->mm->locked_vm -= npages;
+
+	up_write(&_intf->mm->mmap_sem);
+}
+
+static void
+xvmap_release(struct kvm_xvmap *vmap)
+{
+	struct _xvmap *_xvmap = container_of(vmap, struct _xvmap, vmap);
+	struct _xinterface *_intf = to_intf(_xvmap->vmap.intf);
+
+	_vunmap(_intf, _xvmap->vmap.addr, _xvmap->npages);
+	kfree(_xvmap);
+}
+
+const static struct kvm_xvmap_ops _xvmap_ops = {
+	.release = xvmap_release,
+};
+
+/*------------------------------------------------------------------------*/
+
+/*
+ * This function is invoked in the cases where a process context other
+ * than _intf->mm tries to copy data.  Otherwise, we use copy_to_user()
+ */
+static unsigned long
+_slow_copy_to_user(struct _xinterface *_intf, unsigned long dst,
+		    const void *src, unsigned long n)
+{
+	struct task_struct *p = _intf->task;
+	struct mm_struct *mm = _intf->mm;
+
+	while (n) {
+		unsigned long offset = offset_in_page(dst);
+		unsigned long len = PAGE_SIZE - offset;
+		int ret;
+		struct page *pg;
+		void *maddr;
+
+		if (len > n)
+			len = n;
+
+		down_read(&mm->mmap_sem);
+		ret = get_user_pages(p, mm, dst, 1, 1, 0, &pg, NULL);
+
+		if (ret != 1) {
+			up_read(&mm->mmap_sem);
+			break;
+		}
+
+		maddr = kmap_atomic(pg, KM_USER0);
+		memcpy(maddr + offset, src, len);
+		kunmap_atomic(maddr, KM_USER0);
+		set_page_dirty_lock(pg);
+		put_page(pg);
+		up_read(&mm->mmap_sem);
+
+		src += len;
+		dst += len;
+		n -= len;
+	}
+
+	return n;
+}
+
+static unsigned long
+xinterface_copy_to(struct kvm_xinterface *intf, unsigned long gpa,
+		   const void *src, unsigned long n)
+{
+	struct _xinterface *_intf = to_intf(intf);
+	unsigned long dst;
+	bool kthread = !current->mm;
+
+	down_read(&_intf->kvm->slots_lock);
+
+	dst = gpa_to_hva(_intf, gpa);
+	if (!dst)
+		goto out;
+
+	if (kthread)
+		use_mm(_intf->mm);
+
+	if (kthread || _intf->mm == current->mm)
+		n = copy_to_user((void *)dst, src, n);
+	else
+		n = _slow_copy_to_user(_intf, dst, src, n);
+
+	if (kthread)
+		unuse_mm(_intf->mm);
+
+out:
+	up_read(&_intf->kvm->slots_lock);
+
+	return n;
+}
+
+/*
+ * This function is invoked in the cases where a process context other
+ * than _intf->mm tries to copy data.  Otherwise, we use copy_from_user()
+ */
+static unsigned long
+_slow_copy_from_user(struct _xinterface *_intf, void *dst,
+		     unsigned long src, unsigned long n)
+{
+	struct task_struct *p = _intf->task;
+	struct mm_struct *mm = _intf->mm;
+
+	while (n) {
+		unsigned long offset = offset_in_page(src);
+		unsigned long len = PAGE_SIZE - offset;
+		int ret;
+		struct page *pg;
+		void *maddr;
+
+		if (len > n)
+			len = n;
+
+		down_read(&mm->mmap_sem);
+		ret = get_user_pages(p, mm, src, 1, 1, 0, &pg, NULL);
+
+		if (ret != 1) {
+			up_read(&mm->mmap_sem);
+			break;
+		}
+
+		maddr = kmap_atomic(pg, KM_USER0);
+		memcpy(dst, maddr + offset, len);
+		kunmap_atomic(maddr, KM_USER0);
+		put_page(pg);
+		up_read(&mm->mmap_sem);
+
+		src += len;
+		dst += len;
+		n -= len;
+	}
+
+	return n;
+}
+
+static unsigned long
+xinterface_copy_from(struct kvm_xinterface *intf, void *dst,
+		     unsigned long gpa, unsigned long n)
+{
+	struct _xinterface *_intf = to_intf(intf);
+	unsigned long src;
+	bool kthread = !current->mm;
+
+	down_read(&_intf->kvm->slots_lock);
+
+	src = gpa_to_hva(_intf, gpa);
+	if (!src)
+		goto out;
+
+	if (kthread)
+		use_mm(_intf->mm);
+
+	if (kthread || _intf->mm == current->mm)
+		n = copy_from_user(dst, (void *)src, n);
+	else
+		n = _slow_copy_from_user(_intf, dst, src, n);
+
+	if (kthread)
+		unuse_mm(_intf->mm);
+
+out:
+	up_read(&_intf->kvm->slots_lock);
+
+	return n;
+}
+
+static struct kvm_xvmap *
+xinterface_vmap(struct kvm_xinterface *intf,
+		unsigned long gpa,
+		unsigned long len)
+{
+	struct _xinterface         *_intf = to_intf(intf);
+	struct _xvmap               *_xvmap;
+	struct kvm_memory_slot     *memslot;
+	struct kvm                 *kvm = _intf->kvm;
+	int                         ret = -EINVAL;
+	void                       *addr = NULL;
+	off_t                       offset = offset_in_page(gpa);
+	unsigned long               gfn = gpa >> PAGE_SHIFT;
+	unsigned long               npages;
+
+	down_read(&kvm->slots_lock);
+
+	memslot = gfn_to_memslot(kvm, gfn);
+	if (!memslot)
+		goto fail;
+
+	/* Check if the request walks off the end of the slot */
+	if ((offset + len) > (memslot->npages << PAGE_SHIFT))
+		goto fail;
+
+	npages = PAGE_ALIGN(len + offset) >> PAGE_SHIFT;
+
+	addr = _vmap(_intf, _gfn_to_hva(gfn, memslot), offset, npages);
+	if (!addr) {
+		ret = -EFAULT;
+		goto fail;
+	}
+
+	_xvmap = kzalloc(sizeof(*_xvmap), GFP_KERNEL);
+	if (!_xvmap) {
+		ret = -ENOMEM;
+		goto fail;
+	}
+
+	_xvmap->memslot = memslot;
+	_xvmap->npages  = npages;
+
+	kvm_xvmap_init(&_xvmap->vmap, &_xvmap_ops, intf);
+	_xvmap->vmap.addr = addr;
+	_xvmap->vmap.len  = len;
+
+	up_read(&kvm->slots_lock);
+
+	return &_xvmap->vmap;
+
+fail:
+	if (addr)
+		_vunmap(_intf, addr, len);
+
+	up_read(&kvm->slots_lock);
+
+	return ERR_PTR(ret);
+}
+
+static void
+xinterface_release(struct kvm_xinterface *intf)
+{
+	struct _xinterface *_intf = to_intf(intf);
+
+	mmput(_intf->mm);
+	put_task_struct(_intf->task);
+	kvm_put_kvm(_intf->kvm);
+	kfree(_intf);
+}
+
+struct kvm_xinterface_ops _xinterface_ops = {
+	.copy_to     = xinterface_copy_to,
+	.copy_from   = xinterface_copy_from,
+	.vmap        = xinterface_vmap,
+	.release     = xinterface_release,
+};
+
+struct kvm_xinterface *
+kvm_xinterface_alloc(struct kvm *kvm, struct module *owner)
+{
+	struct _xinterface *_intf;
+	struct kvm_xinterface *intf;
+
+	_intf = kzalloc(sizeof(*_intf), GFP_KERNEL);
+	if (!_intf)
+		return ERR_PTR(-ENOMEM);
+
+	intf = &_intf->intf;
+
+	__module_get(owner);
+	intf->owner = owner;
+	kref_init(&intf->kref);
+	intf->ops = &_xinterface_ops;
+
+	kvm_get_kvm(kvm);
+	_intf->kvm = kvm;
+
+	_intf->task = current;
+	get_task_struct(_intf->task);
+
+	_intf->mm = get_task_mm(_intf->task);
+
+	return intf;
+}

