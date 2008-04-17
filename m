Return-Path: <linux-kernel-owner+w=401wt.eu-S1761057AbYDQJOk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761057AbYDQJOk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2008 05:14:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762785AbYDQJLE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Apr 2008 05:11:04 -0400
Received: from bzq-179-150-194.static.bezeqint.net ([212.179.150.194]:58957
	"EHLO il.qumranet.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756908AbYDQJK4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2008 05:10:56 -0400
From: Avi Kivity <avi@qumranet.com>
To: kvm-devel@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org, Carsten Otte <cotte@de.ibm.com>
Subject: [PATCH 06/45] KVM: s390: arch backend for the kvm kernel module
Date: Thu, 17 Apr 2008 12:10:11 +0300
Message-Id: <1208423450-29415-7-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.5
In-Reply-To: <1208423450-29415-1-git-send-email-avi@qumranet.com>
References: <1208423450-29415-1-git-send-email-avi@qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Carsten Otte <cotte@de.ibm.com>

From: Christian Borntraeger <borntraeger@de.ibm.com>
From: Heiko Carstens <heiko.carstens@de.ibm.com>

This patch contains the port of Qumranet's kvm kernel module to IBM zSeries
 (aka s390x, mainframe) architecture. It uses the mainframe's virtualization
instruction SIE to run virtual machines with up to 64 virtual CPUs each.
This port is only usable on 64bit host kernels, and can only run 64bit guest
kernels. However, running 31bit applications in guest userspace is possible.

The following source files are introduced by this patch
arch/s390/kvm/kvm-s390.c    similar to arch/x86/kvm/x86.c, this implements all
                            arch callbacks for kvm. __vcpu_run calls back into
                            sie64a to enter the guest machine context
arch/s390/kvm/sie64a.S      assembler function sie64a, which enters guest
                            context via SIE, and switches world before and after                            that
include/asm-s390/kvm_host.h contains all vital data structures needed to run
                            virtual machines on the mainframe
include/asm-s390/kvm.h      defines kvm_regs and friends for user access to
                            guest register content
arch/s390/kvm/gaccess.h     functions similar to uaccess to access guest memory
arch/s390/kvm/kvm-s390.h    header file for kvm-s390 internals, extended by
                            later patches

Acked-by: Martin Schwidefsky <schwidefsky@de.ibm.com>
Signed-off-by: Christian Borntraeger <borntraeger@de.ibm.com>
Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>
Signed-off-by: Carsten Otte <cotte@de.ibm.com>
Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 arch/s390/Makefile          |    2 +-
 arch/s390/kernel/vtime.c    |    1 +
 arch/s390/kvm/Makefile      |   14 +
 arch/s390/kvm/gaccess.h     |  274 +++++++++++++++++++++
 arch/s390/kvm/kvm-s390.c    |  566 +++++++++++++++++++++++++++++++++++++++++++
 arch/s390/kvm/kvm-s390.h    |   29 +++
 arch/s390/kvm/sie64a.S      |   47 ++++
 include/asm-s390/Kbuild     |    1 +
 include/asm-s390/kvm.h      |   41 +++-
 include/asm-s390/kvm_host.h |  127 ++++++++++
 include/asm-s390/kvm_para.h |   30 +++
 include/linux/kvm.h         |   15 ++
 12 files changed, 1145 insertions(+), 2 deletions(-)
 create mode 100644 arch/s390/kvm/Makefile
 create mode 100644 arch/s390/kvm/gaccess.h
 create mode 100644 arch/s390/kvm/kvm-s390.c
 create mode 100644 arch/s390/kvm/kvm-s390.h
 create mode 100644 arch/s390/kvm/sie64a.S
 create mode 100644 include/asm-s390/kvm_host.h
 create mode 100644 include/asm-s390/kvm_para.h

diff --git a/arch/s390/Makefile b/arch/s390/Makefile
index f708be3..792a4e7 100644
--- a/arch/s390/Makefile
+++ b/arch/s390/Makefile
@@ -87,7 +87,7 @@ LDFLAGS_vmlinux := -e start
 head-y		:= arch/s390/kernel/head.o arch/s390/kernel/init_task.o
 
 core-y		+= arch/s390/mm/ arch/s390/kernel/ arch/s390/crypto/ \
-		   arch/s390/appldata/ arch/s390/hypfs/
+		   arch/s390/appldata/ arch/s390/hypfs/ arch/s390/kvm/
 libs-y		+= arch/s390/lib/
 drivers-y	+= drivers/s390/
 drivers-$(CONFIG_MATHEMU) += arch/s390/math-emu/
diff --git a/arch/s390/kernel/vtime.c b/arch/s390/kernel/vtime.c
index c5f05b3..ca90ee3 100644
--- a/arch/s390/kernel/vtime.c
+++ b/arch/s390/kernel/vtime.c
@@ -110,6 +110,7 @@ void account_system_vtime(struct task_struct *tsk)
 	S390_lowcore.steal_clock -= cputime << 12;
 	account_system_time(tsk, 0, cputime);
 }
+EXPORT_SYMBOL_GPL(account_system_vtime);
 
 static inline void set_vtimer(__u64 expires)
 {
diff --git a/arch/s390/kvm/Makefile b/arch/s390/kvm/Makefile
new file mode 100644
index 0000000..0d8d113
--- /dev/null
+++ b/arch/s390/kvm/Makefile
@@ -0,0 +1,14 @@
+# Makefile for kernel virtual machines on s390
+#
+# Copyright IBM Corp. 2008
+#
+# This program is free software; you can redistribute it and/or modify
+# it under the terms of the GNU General Public License (version 2 only)
+# as published by the Free Software Foundation.
+
+common-objs = $(addprefix ../../../virt/kvm/, kvm_main.o)
+
+EXTRA_CFLAGS += -Ivirt/kvm -Iarch/s390/kvm
+
+kvm-objs := $(common-objs) kvm-s390.o sie64a.o
+obj-$(CONFIG_KVM) += kvm.o
diff --git a/arch/s390/kvm/gaccess.h b/arch/s390/kvm/gaccess.h
new file mode 100644
index 0000000..4e0633c
--- /dev/null
+++ b/arch/s390/kvm/gaccess.h
@@ -0,0 +1,274 @@
+/*
+ * gaccess.h -  access guest memory
+ *
+ * Copyright IBM Corp. 2008
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License (version 2 only)
+ * as published by the Free Software Foundation.
+ *
+ *    Author(s): Carsten Otte <cotte@de.ibm.com>
+ */
+
+#ifndef __KVM_S390_GACCESS_H
+#define __KVM_S390_GACCESS_H
+
+#include <linux/compiler.h>
+#include <linux/kvm_host.h>
+#include <asm/uaccess.h>
+
+static inline void __user *__guestaddr_to_user(struct kvm_vcpu *vcpu,
+					       u64 guestaddr)
+{
+	u64 prefix  = vcpu->arch.sie_block->prefix;
+	u64 origin  = vcpu->kvm->arch.guest_origin;
+	u64 memsize = vcpu->kvm->arch.guest_memsize;
+
+	if (guestaddr < 2 * PAGE_SIZE)
+		guestaddr += prefix;
+	else if ((guestaddr >= prefix) && (guestaddr < prefix + 2 * PAGE_SIZE))
+		guestaddr -= prefix;
+
+	if (guestaddr > memsize)
+		return (void __user __force *) ERR_PTR(-EFAULT);
+
+	guestaddr += origin;
+
+	return (void __user *) guestaddr;
+}
+
+static inline int get_guest_u64(struct kvm_vcpu *vcpu, u64 guestaddr,
+				u64 *result)
+{
+	void __user *uptr = __guestaddr_to_user(vcpu, guestaddr);
+
+	BUG_ON(guestaddr & 7);
+
+	if (IS_ERR((void __force *) uptr))
+		return PTR_ERR((void __force *) uptr);
+
+	return get_user(*result, (u64 __user *) uptr);
+}
+
+static inline int get_guest_u32(struct kvm_vcpu *vcpu, u64 guestaddr,
+				u32 *result)
+{
+	void __user *uptr = __guestaddr_to_user(vcpu, guestaddr);
+
+	BUG_ON(guestaddr & 3);
+
+	if (IS_ERR((void __force *) uptr))
+		return PTR_ERR((void __force *) uptr);
+
+	return get_user(*result, (u32 __user *) uptr);
+}
+
+static inline int get_guest_u16(struct kvm_vcpu *vcpu, u64 guestaddr,
+				u16 *result)
+{
+	void __user *uptr = __guestaddr_to_user(vcpu, guestaddr);
+
+	BUG_ON(guestaddr & 1);
+
+	if (IS_ERR(uptr))
+		return PTR_ERR(uptr);
+
+	return get_user(*result, (u16 __user *) uptr);
+}
+
+static inline int get_guest_u8(struct kvm_vcpu *vcpu, u64 guestaddr,
+			       u8 *result)
+{
+	void __user *uptr = __guestaddr_to_user(vcpu, guestaddr);
+
+	if (IS_ERR((void __force *) uptr))
+		return PTR_ERR((void __force *) uptr);
+
+	return get_user(*result, (u8 __user *) uptr);
+}
+
+static inline int put_guest_u64(struct kvm_vcpu *vcpu, u64 guestaddr,
+				u64 value)
+{
+	void __user *uptr = __guestaddr_to_user(vcpu, guestaddr);
+
+	BUG_ON(guestaddr & 7);
+
+	if (IS_ERR((void __force *) uptr))
+		return PTR_ERR((void __force *) uptr);
+
+	return put_user(value, (u64 __user *) uptr);
+}
+
+static inline int put_guest_u32(struct kvm_vcpu *vcpu, u64 guestaddr,
+				u32 value)
+{
+	void __user *uptr = __guestaddr_to_user(vcpu, guestaddr);
+
+	BUG_ON(guestaddr & 3);
+
+	if (IS_ERR((void __force *) uptr))
+		return PTR_ERR((void __force *) uptr);
+
+	return put_user(value, (u32 __user *) uptr);
+}
+
+static inline int put_guest_u16(struct kvm_vcpu *vcpu, u64 guestaddr,
+				u16 value)
+{
+	void __user *uptr = __guestaddr_to_user(vcpu, guestaddr);
+
+	BUG_ON(guestaddr & 1);
+
+	if (IS_ERR((void __force *) uptr))
+		return PTR_ERR((void __force *) uptr);
+
+	return put_user(value, (u16 __user *) uptr);
+}
+
+static inline int put_guest_u8(struct kvm_vcpu *vcpu, u64 guestaddr,
+			       u8 value)
+{
+	void __user *uptr = __guestaddr_to_user(vcpu, guestaddr);
+
+	if (IS_ERR((void __force *) uptr))
+		return PTR_ERR((void __force *) uptr);
+
+	return put_user(value, (u8 __user *) uptr);
+}
+
+
+static inline int __copy_to_guest_slow(struct kvm_vcpu *vcpu, u64 guestdest,
+				       const void *from, unsigned long n)
+{
+	int rc;
+	unsigned long i;
+	const u8 *data = from;
+
+	for (i = 0; i < n; i++) {
+		rc = put_guest_u8(vcpu, guestdest++, *(data++));
+		if (rc < 0)
+			return rc;
+	}
+	return 0;
+}
+
+static inline int copy_to_guest(struct kvm_vcpu *vcpu, u64 guestdest,
+				const void *from, unsigned long n)
+{
+	u64 prefix  = vcpu->arch.sie_block->prefix;
+	u64 origin  = vcpu->kvm->arch.guest_origin;
+	u64 memsize = vcpu->kvm->arch.guest_memsize;
+
+	if ((guestdest < 2 * PAGE_SIZE) && (guestdest + n > 2 * PAGE_SIZE))
+		goto slowpath;
+
+	if ((guestdest < prefix) && (guestdest + n > prefix))
+		goto slowpath;
+
+	if ((guestdest < prefix + 2 * PAGE_SIZE)
+	    && (guestdest + n > prefix + 2 * PAGE_SIZE))
+		goto slowpath;
+
+	if (guestdest < 2 * PAGE_SIZE)
+		guestdest += prefix;
+	else if ((guestdest >= prefix) && (guestdest < prefix + 2 * PAGE_SIZE))
+		guestdest -= prefix;
+
+	if (guestdest + n > memsize)
+		return -EFAULT;
+
+	if (guestdest + n < guestdest)
+		return -EFAULT;
+
+	guestdest += origin;
+
+	return copy_to_user((void __user *) guestdest, from, n);
+slowpath:
+	return __copy_to_guest_slow(vcpu, guestdest, from, n);
+}
+
+static inline int __copy_from_guest_slow(struct kvm_vcpu *vcpu, void *to,
+					 u64 guestsrc, unsigned long n)
+{
+	int rc;
+	unsigned long i;
+	u8 *data = to;
+
+	for (i = 0; i < n; i++) {
+		rc = get_guest_u8(vcpu, guestsrc++, data++);
+		if (rc < 0)
+			return rc;
+	}
+	return 0;
+}
+
+static inline int copy_from_guest(struct kvm_vcpu *vcpu, void *to,
+				  u64 guestsrc, unsigned long n)
+{
+	u64 prefix  = vcpu->arch.sie_block->prefix;
+	u64 origin  = vcpu->kvm->arch.guest_origin;
+	u64 memsize = vcpu->kvm->arch.guest_memsize;
+
+	if ((guestsrc < 2 * PAGE_SIZE) && (guestsrc + n > 2 * PAGE_SIZE))
+		goto slowpath;
+
+	if ((guestsrc < prefix) && (guestsrc + n > prefix))
+		goto slowpath;
+
+	if ((guestsrc < prefix + 2 * PAGE_SIZE)
+	    && (guestsrc + n > prefix + 2 * PAGE_SIZE))
+		goto slowpath;
+
+	if (guestsrc < 2 * PAGE_SIZE)
+		guestsrc += prefix;
+	else if ((guestsrc >= prefix) && (guestsrc < prefix + 2 * PAGE_SIZE))
+		guestsrc -= prefix;
+
+	if (guestsrc + n > memsize)
+		return -EFAULT;
+
+	if (guestsrc + n < guestsrc)
+		return -EFAULT;
+
+	guestsrc += origin;
+
+	return copy_from_user(to, (void __user *) guestsrc, n);
+slowpath:
+	return __copy_from_guest_slow(vcpu, to, guestsrc, n);
+}
+
+static inline int copy_to_guest_absolute(struct kvm_vcpu *vcpu, u64 guestdest,
+					 const void *from, unsigned long n)
+{
+	u64 origin  = vcpu->kvm->arch.guest_origin;
+	u64 memsize = vcpu->kvm->arch.guest_memsize;
+
+	if (guestdest + n > memsize)
+		return -EFAULT;
+
+	if (guestdest + n < guestdest)
+		return -EFAULT;
+
+	guestdest += origin;
+
+	return copy_to_user((void __user *) guestdest, from, n);
+}
+
+static inline int copy_from_guest_absolute(struct kvm_vcpu *vcpu, void *to,
+					   u64 guestsrc, unsigned long n)
+{
+	u64 origin  = vcpu->kvm->arch.guest_origin;
+	u64 memsize = vcpu->kvm->arch.guest_memsize;
+
+	if (guestsrc + n > memsize)
+		return -EFAULT;
+
+	if (guestsrc + n < guestsrc)
+		return -EFAULT;
+
+	guestsrc += origin;
+
+	return copy_from_user(to, (void __user *) guestsrc, n);
+}
+#endif
diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
new file mode 100644
index 0000000..6e1e1d3
--- /dev/null
+++ b/arch/s390/kvm/kvm-s390.c
@@ -0,0 +1,566 @@
+/*
+ * s390host.c --  hosting zSeries kernel virtual machines
+ *
+ * Copyright IBM Corp. 2008
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License (version 2 only)
+ * as published by the Free Software Foundation.
+ *
+ *    Author(s): Carsten Otte <cotte@de.ibm.com>
+ *               Christian Borntraeger <borntraeger@de.ibm.com>
+ *               Heiko Carstens <heiko.carstens@de.ibm.com>
+ */
+
+#include <linux/compiler.h>
+#include <linux/err.h>
+#include <linux/fs.h>
+#include <linux/init.h>
+#include <linux/kvm.h>
+#include <linux/kvm_host.h>
+#include <linux/module.h>
+#include <linux/slab.h>
+#include <asm/lowcore.h>
+#include <asm/pgtable.h>
+
+#include "gaccess.h"
+
+#define VCPU_STAT(x) offsetof(struct kvm_vcpu, stat.x), KVM_STAT_VCPU
+
+struct kvm_stats_debugfs_item debugfs_entries[] = {
+	{ "userspace_handled", VCPU_STAT(exit_userspace) },
+	{ NULL }
+};
+
+
+/* Section: not file related */
+void kvm_arch_hardware_enable(void *garbage)
+{
+	/* every s390 is virtualization enabled ;-) */
+}
+
+void kvm_arch_hardware_disable(void *garbage)
+{
+}
+
+void decache_vcpus_on_cpu(int cpu)
+{
+}
+
+int kvm_arch_hardware_setup(void)
+{
+	return 0;
+}
+
+void kvm_arch_hardware_unsetup(void)
+{
+}
+
+void kvm_arch_check_processor_compat(void *rtn)
+{
+}
+
+int kvm_arch_init(void *opaque)
+{
+	return 0;
+}
+
+void kvm_arch_exit(void)
+{
+}
+
+/* Section: device related */
+long kvm_arch_dev_ioctl(struct file *filp,
+			unsigned int ioctl, unsigned long arg)
+{
+	if (ioctl == KVM_S390_ENABLE_SIE)
+		return s390_enable_sie();
+	return -EINVAL;
+}
+
+int kvm_dev_ioctl_check_extension(long ext)
+{
+	return 0;
+}
+
+/* Section: vm related */
+/*
+ * Get (and clear) the dirty memory log for a memory slot.
+ */
+int kvm_vm_ioctl_get_dirty_log(struct kvm *kvm,
+			       struct kvm_dirty_log *log)
+{
+	return 0;
+}
+
+long kvm_arch_vm_ioctl(struct file *filp,
+		       unsigned int ioctl, unsigned long arg)
+{
+	struct kvm *kvm = filp->private_data;
+	void __user *argp = (void __user *)arg;
+	int r;
+
+	switch (ioctl) {
+	default:
+		r = -EINVAL;
+	}
+
+	return r;
+}
+
+struct kvm *kvm_arch_create_vm(void)
+{
+	struct kvm *kvm;
+	int rc;
+	char debug_name[16];
+
+	rc = s390_enable_sie();
+	if (rc)
+		goto out_nokvm;
+
+	rc = -ENOMEM;
+	kvm = kzalloc(sizeof(struct kvm), GFP_KERNEL);
+	if (!kvm)
+		goto out_nokvm;
+
+	kvm->arch.sca = (struct sca_block *) get_zeroed_page(GFP_KERNEL);
+	if (!kvm->arch.sca)
+		goto out_nosca;
+
+	sprintf(debug_name, "kvm-%u", current->pid);
+
+	kvm->arch.dbf = debug_register(debug_name, 8, 2, 8 * sizeof(long));
+	if (!kvm->arch.dbf)
+		goto out_nodbf;
+
+	debug_register_view(kvm->arch.dbf, &debug_sprintf_view);
+	VM_EVENT(kvm, 3, "%s", "vm created");
+
+	try_module_get(THIS_MODULE);
+
+	return kvm;
+out_nodbf:
+	free_page((unsigned long)(kvm->arch.sca));
+out_nosca:
+	kfree(kvm);
+out_nokvm:
+	return ERR_PTR(rc);
+}
+
+void kvm_arch_destroy_vm(struct kvm *kvm)
+{
+	debug_unregister(kvm->arch.dbf);
+	free_page((unsigned long)(kvm->arch.sca));
+	kfree(kvm);
+	module_put(THIS_MODULE);
+}
+
+/* Section: vcpu related */
+int kvm_arch_vcpu_init(struct kvm_vcpu *vcpu)
+{
+	return 0;
+}
+
+void kvm_arch_vcpu_uninit(struct kvm_vcpu *vcpu)
+{
+	/* kvm common code refers to this, but does'nt call it */
+	BUG();
+}
+
+void kvm_arch_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
+{
+	save_fp_regs(&vcpu->arch.host_fpregs);
+	save_access_regs(vcpu->arch.host_acrs);
+	vcpu->arch.guest_fpregs.fpc &= FPC_VALID_MASK;
+	restore_fp_regs(&vcpu->arch.guest_fpregs);
+	restore_access_regs(vcpu->arch.guest_acrs);
+
+	if (signal_pending(current))
+		atomic_set_mask(CPUSTAT_STOP_INT,
+			&vcpu->arch.sie_block->cpuflags);
+}
+
+void kvm_arch_vcpu_put(struct kvm_vcpu *vcpu)
+{
+	save_fp_regs(&vcpu->arch.guest_fpregs);
+	save_access_regs(vcpu->arch.guest_acrs);
+	restore_fp_regs(&vcpu->arch.host_fpregs);
+	restore_access_regs(vcpu->arch.host_acrs);
+}
+
+static void kvm_s390_vcpu_initial_reset(struct kvm_vcpu *vcpu)
+{
+	/* this equals initial cpu reset in pop, but we don't switch to ESA */
+	vcpu->arch.sie_block->gpsw.mask = 0UL;
+	vcpu->arch.sie_block->gpsw.addr = 0UL;
+	vcpu->arch.sie_block->prefix    = 0UL;
+	vcpu->arch.sie_block->ihcpu     = 0xffff;
+	vcpu->arch.sie_block->cputm     = 0UL;
+	vcpu->arch.sie_block->ckc       = 0UL;
+	vcpu->arch.sie_block->todpr     = 0;
+	memset(vcpu->arch.sie_block->gcr, 0, 16 * sizeof(__u64));
+	vcpu->arch.sie_block->gcr[0]  = 0xE0UL;
+	vcpu->arch.sie_block->gcr[14] = 0xC2000000UL;
+	vcpu->arch.guest_fpregs.fpc = 0;
+	asm volatile("lfpc %0" : : "Q" (vcpu->arch.guest_fpregs.fpc));
+	vcpu->arch.sie_block->gbea = 1;
+}
+
+int kvm_arch_vcpu_setup(struct kvm_vcpu *vcpu)
+{
+	atomic_set(&vcpu->arch.sie_block->cpuflags, CPUSTAT_ZARCH);
+	vcpu->arch.sie_block->gmslm = 0xffffffffffUL;
+	vcpu->arch.sie_block->gmsor = 0x000000000000;
+	vcpu->arch.sie_block->ecb   = 2;
+	vcpu->arch.sie_block->eca   = 0xC1002001U;
+
+	return 0;
+}
+
+struct kvm_vcpu *kvm_arch_vcpu_create(struct kvm *kvm,
+				      unsigned int id)
+{
+	struct kvm_vcpu *vcpu = kzalloc(sizeof(struct kvm_vcpu), GFP_KERNEL);
+	int rc = -ENOMEM;
+
+	if (!vcpu)
+		goto out_nomem;
+
+	vcpu->arch.sie_block = (struct sie_block *) get_zeroed_page(GFP_KERNEL);
+
+	if (!vcpu->arch.sie_block)
+		goto out_free_cpu;
+
+	vcpu->arch.sie_block->icpua = id;
+	BUG_ON(!kvm->arch.sca);
+	BUG_ON(kvm->arch.sca->cpu[id].sda);
+	kvm->arch.sca->cpu[id].sda = (__u64) vcpu->arch.sie_block;
+	vcpu->arch.sie_block->scaoh = (__u32)(((__u64)kvm->arch.sca) >> 32);
+	vcpu->arch.sie_block->scaol = (__u32)(__u64)kvm->arch.sca;
+
+	rc = kvm_vcpu_init(vcpu, kvm, id);
+	if (rc)
+		goto out_free_cpu;
+	VM_EVENT(kvm, 3, "create cpu %d at %p, sie block at %p", id, vcpu,
+		 vcpu->arch.sie_block);
+
+	try_module_get(THIS_MODULE);
+
+	return vcpu;
+out_free_cpu:
+	kfree(vcpu);
+out_nomem:
+	return ERR_PTR(rc);
+}
+
+void kvm_arch_vcpu_destroy(struct kvm_vcpu *vcpu)
+{
+	VCPU_EVENT(vcpu, 3, "%s", "destroy cpu");
+	free_page((unsigned long)(vcpu->arch.sie_block));
+	kfree(vcpu);
+	module_put(THIS_MODULE);
+}
+
+int kvm_arch_vcpu_runnable(struct kvm_vcpu *vcpu)
+{
+	/* kvm common code refers to this, but never calls it */
+	BUG();
+	return 0;
+}
+
+static int kvm_arch_vcpu_ioctl_initial_reset(struct kvm_vcpu *vcpu)
+{
+	vcpu_load(vcpu);
+	kvm_s390_vcpu_initial_reset(vcpu);
+	vcpu_put(vcpu);
+	return 0;
+}
+
+int kvm_arch_vcpu_ioctl_set_regs(struct kvm_vcpu *vcpu, struct kvm_regs *regs)
+{
+	vcpu_load(vcpu);
+	memcpy(&vcpu->arch.guest_gprs, &regs->gprs, sizeof(regs->gprs));
+	vcpu_put(vcpu);
+	return 0;
+}
+
+int kvm_arch_vcpu_ioctl_get_regs(struct kvm_vcpu *vcpu, struct kvm_regs *regs)
+{
+	vcpu_load(vcpu);
+	memcpy(&regs->gprs, &vcpu->arch.guest_gprs, sizeof(regs->gprs));
+	vcpu_put(vcpu);
+	return 0;
+}
+
+int kvm_arch_vcpu_ioctl_set_sregs(struct kvm_vcpu *vcpu,
+				  struct kvm_sregs *sregs)
+{
+	vcpu_load(vcpu);
+	memcpy(&vcpu->arch.guest_acrs, &sregs->acrs, sizeof(sregs->acrs));
+	memcpy(&vcpu->arch.sie_block->gcr, &sregs->crs, sizeof(sregs->crs));
+	vcpu_put(vcpu);
+	return 0;
+}
+
+int kvm_arch_vcpu_ioctl_get_sregs(struct kvm_vcpu *vcpu,
+				  struct kvm_sregs *sregs)
+{
+	vcpu_load(vcpu);
+	memcpy(&sregs->acrs, &vcpu->arch.guest_acrs, sizeof(sregs->acrs));
+	memcpy(&sregs->crs, &vcpu->arch.sie_block->gcr, sizeof(sregs->crs));
+	vcpu_put(vcpu);
+	return 0;
+}
+
+int kvm_arch_vcpu_ioctl_set_fpu(struct kvm_vcpu *vcpu, struct kvm_fpu *fpu)
+{
+	vcpu_load(vcpu);
+	memcpy(&vcpu->arch.guest_fpregs.fprs, &fpu->fprs, sizeof(fpu->fprs));
+	vcpu->arch.guest_fpregs.fpc = fpu->fpc;
+	vcpu_put(vcpu);
+	return 0;
+}
+
+int kvm_arch_vcpu_ioctl_get_fpu(struct kvm_vcpu *vcpu, struct kvm_fpu *fpu)
+{
+	vcpu_load(vcpu);
+	memcpy(&fpu->fprs, &vcpu->arch.guest_fpregs.fprs, sizeof(fpu->fprs));
+	fpu->fpc = vcpu->arch.guest_fpregs.fpc;
+	vcpu_put(vcpu);
+	return 0;
+}
+
+static int kvm_arch_vcpu_ioctl_set_initial_psw(struct kvm_vcpu *vcpu, psw_t psw)
+{
+	int rc = 0;
+
+	vcpu_load(vcpu);
+	if (atomic_read(&vcpu->arch.sie_block->cpuflags) & CPUSTAT_RUNNING)
+		rc = -EBUSY;
+	else
+		vcpu->arch.sie_block->gpsw = psw;
+	vcpu_put(vcpu);
+	return rc;
+}
+
+int kvm_arch_vcpu_ioctl_translate(struct kvm_vcpu *vcpu,
+				  struct kvm_translation *tr)
+{
+	return -EINVAL; /* not implemented yet */
+}
+
+int kvm_arch_vcpu_ioctl_debug_guest(struct kvm_vcpu *vcpu,
+				    struct kvm_debug_guest *dbg)
+{
+	return -EINVAL; /* not implemented yet */
+}
+
+static void __vcpu_run(struct kvm_vcpu *vcpu)
+{
+	memcpy(&vcpu->arch.sie_block->gg14, &vcpu->arch.guest_gprs[14], 16);
+
+	if (need_resched())
+		schedule();
+
+	vcpu->arch.sie_block->icptcode = 0;
+	local_irq_disable();
+	kvm_guest_enter();
+	local_irq_enable();
+	VCPU_EVENT(vcpu, 6, "entering sie flags %x",
+		   atomic_read(&vcpu->arch.sie_block->cpuflags));
+	sie64a(vcpu->arch.sie_block, vcpu->arch.guest_gprs);
+	VCPU_EVENT(vcpu, 6, "exit sie icptcode %d",
+		   vcpu->arch.sie_block->icptcode);
+	local_irq_disable();
+	kvm_guest_exit();
+	local_irq_enable();
+
+	memcpy(&vcpu->arch.guest_gprs[14], &vcpu->arch.sie_block->gg14, 16);
+}
+
+int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu, struct kvm_run *kvm_run)
+{
+	sigset_t sigsaved;
+
+	vcpu_load(vcpu);
+
+	if (vcpu->sigset_active)
+		sigprocmask(SIG_SETMASK, &vcpu->sigset, &sigsaved);
+
+	atomic_set_mask(CPUSTAT_RUNNING, &vcpu->arch.sie_block->cpuflags);
+
+	__vcpu_run(vcpu);
+
+	if (vcpu->sigset_active)
+		sigprocmask(SIG_SETMASK, &sigsaved, NULL);
+
+	vcpu_put(vcpu);
+
+	vcpu->stat.exit_userspace++;
+	return 0;
+}
+
+static int __guestcopy(struct kvm_vcpu *vcpu, u64 guestdest, const void *from,
+		       unsigned long n, int prefix)
+{
+	if (prefix)
+		return copy_to_guest(vcpu, guestdest, from, n);
+	else
+		return copy_to_guest_absolute(vcpu, guestdest, from, n);
+}
+
+/*
+ * store status at address
+ * we use have two special cases:
+ * KVM_S390_STORE_STATUS_NOADDR: -> 0x1200 on 64 bit
+ * KVM_S390_STORE_STATUS_PREFIXED: -> prefix
+ */
+int __kvm_s390_vcpu_store_status(struct kvm_vcpu *vcpu, unsigned long addr)
+{
+	const unsigned char archmode = 1;
+	int prefix;
+
+	if (addr == KVM_S390_STORE_STATUS_NOADDR) {
+		if (copy_to_guest_absolute(vcpu, 163ul, &archmode, 1))
+			return -EFAULT;
+		addr = SAVE_AREA_BASE;
+		prefix = 0;
+	} else if (addr == KVM_S390_STORE_STATUS_PREFIXED) {
+		if (copy_to_guest(vcpu, 163ul, &archmode, 1))
+			return -EFAULT;
+		addr = SAVE_AREA_BASE;
+		prefix = 1;
+	} else
+		prefix = 0;
+
+	if (__guestcopy(vcpu, addr + offsetof(struct save_area_s390x, fp_regs),
+			vcpu->arch.guest_fpregs.fprs, 128, prefix))
+		return -EFAULT;
+
+	if (__guestcopy(vcpu, addr + offsetof(struct save_area_s390x, gp_regs),
+			vcpu->arch.guest_gprs, 128, prefix))
+		return -EFAULT;
+
+	if (__guestcopy(vcpu, addr + offsetof(struct save_area_s390x, psw),
+			&vcpu->arch.sie_block->gpsw, 16, prefix))
+		return -EFAULT;
+
+	if (__guestcopy(vcpu, addr + offsetof(struct save_area_s390x, pref_reg),
+			&vcpu->arch.sie_block->prefix, 4, prefix))
+		return -EFAULT;
+
+	if (__guestcopy(vcpu,
+			addr + offsetof(struct save_area_s390x, fp_ctrl_reg),
+			&vcpu->arch.guest_fpregs.fpc, 4, prefix))
+		return -EFAULT;
+
+	if (__guestcopy(vcpu, addr + offsetof(struct save_area_s390x, tod_reg),
+			&vcpu->arch.sie_block->todpr, 4, prefix))
+		return -EFAULT;
+
+	if (__guestcopy(vcpu, addr + offsetof(struct save_area_s390x, timer),
+			&vcpu->arch.sie_block->cputm, 8, prefix))
+		return -EFAULT;
+
+	if (__guestcopy(vcpu, addr + offsetof(struct save_area_s390x, clk_cmp),
+			&vcpu->arch.sie_block->ckc, 8, prefix))
+		return -EFAULT;
+
+	if (__guestcopy(vcpu, addr + offsetof(struct save_area_s390x, acc_regs),
+			&vcpu->arch.guest_acrs, 64, prefix))
+		return -EFAULT;
+
+	if (__guestcopy(vcpu,
+			addr + offsetof(struct save_area_s390x, ctrl_regs),
+			&vcpu->arch.sie_block->gcr, 128, prefix))
+		return -EFAULT;
+	return 0;
+}
+
+static int kvm_s390_vcpu_store_status(struct kvm_vcpu *vcpu, unsigned long addr)
+{
+	int rc;
+
+	vcpu_load(vcpu);
+	rc = __kvm_s390_vcpu_store_status(vcpu, addr);
+	vcpu_put(vcpu);
+	return rc;
+}
+
+long kvm_arch_vcpu_ioctl(struct file *filp,
+			 unsigned int ioctl, unsigned long arg)
+{
+	struct kvm_vcpu *vcpu = filp->private_data;
+	void __user *argp = (void __user *)arg;
+
+	switch (ioctl) {
+	case KVM_S390_STORE_STATUS:
+		return kvm_s390_vcpu_store_status(vcpu, arg);
+	case KVM_S390_SET_INITIAL_PSW: {
+		psw_t psw;
+
+		if (copy_from_user(&psw, argp, sizeof(psw)))
+			return -EFAULT;
+		return kvm_arch_vcpu_ioctl_set_initial_psw(vcpu, psw);
+	}
+	case KVM_S390_INITIAL_RESET:
+		return kvm_arch_vcpu_ioctl_initial_reset(vcpu);
+	default:
+		;
+	}
+	return -EINVAL;
+}
+
+/* Section: memory related */
+int kvm_arch_set_memory_region(struct kvm *kvm,
+				struct kvm_userspace_memory_region *mem,
+				struct kvm_memory_slot old,
+				int user_alloc)
+{
+	/* A few sanity checks. We can have exactly one memory slot which has
+	   to start at guest virtual zero and which has to be located at a
+	   page boundary in userland and which has to end at a page boundary.
+	   The memory in userland is ok to be fragmented into various different
+	   vmas. It is okay to mmap() and munmap() stuff in this slot after
+	   doing this call at any time */
+
+	if (mem->slot)
+		return -EINVAL;
+
+	if (mem->guest_phys_addr)
+		return -EINVAL;
+
+	if (mem->userspace_addr & (PAGE_SIZE - 1))
+		return -EINVAL;
+
+	if (mem->memory_size & (PAGE_SIZE - 1))
+		return -EINVAL;
+
+	kvm->arch.guest_origin = mem->userspace_addr;
+	kvm->arch.guest_memsize = mem->memory_size;
+
+	/* FIXME: we do want to interrupt running CPUs and update their memory
+	   configuration now to avoid race conditions. But hey, changing the
+	   memory layout while virtual CPUs are running is usually bad
+	   programming practice. */
+
+	return 0;
+}
+
+gfn_t unalias_gfn(struct kvm *kvm, gfn_t gfn)
+{
+	return gfn;
+}
+
+static int __init kvm_s390_init(void)
+{
+	return kvm_init(NULL, sizeof(struct kvm_vcpu), THIS_MODULE);
+}
+
+static void __exit kvm_s390_exit(void)
+{
+	kvm_exit();
+}
+
+module_init(kvm_s390_init);
+module_exit(kvm_s390_exit);
diff --git a/arch/s390/kvm/kvm-s390.h b/arch/s390/kvm/kvm-s390.h
new file mode 100644
index 0000000..ed64a22
--- /dev/null
+++ b/arch/s390/kvm/kvm-s390.h
@@ -0,0 +1,29 @@
+/*
+ * kvm_s390.h -  definition for kvm on s390
+ *
+ * Copyright IBM Corp. 2008
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License (version 2 only)
+ * as published by the Free Software Foundation.
+ *
+ *    Author(s): Carsten Otte <cotte@de.ibm.com>
+ *               Christian Borntraeger <borntraeger@de.ibm.com>
+ */
+
+#ifndef ARCH_S390_KVM_S390_H
+#define ARCH_S390_KVM_S390_H
+#define VM_EVENT(d_kvm, d_loglevel, d_string, d_args...)\
+do { \
+	debug_sprintf_event(d_kvm->arch.dbf, d_loglevel, d_string "\n", \
+	  d_args); \
+} while (0)
+
+#define VCPU_EVENT(d_vcpu, d_loglevel, d_string, d_args...)\
+do { \
+	debug_sprintf_event(d_vcpu->kvm->arch.dbf, d_loglevel, \
+	  "%02d[%016lx-%016lx]: " d_string "\n", d_vcpu->vcpu_id, \
+	  d_vcpu->arch.sie_block->gpsw.mask, d_vcpu->arch.sie_block->gpsw.addr,\
+	  d_args); \
+} while (0)
+#endif
diff --git a/arch/s390/kvm/sie64a.S b/arch/s390/kvm/sie64a.S
new file mode 100644
index 0000000..934fd6a
--- /dev/null
+++ b/arch/s390/kvm/sie64a.S
@@ -0,0 +1,47 @@
+/*
+ * sie64a.S - low level sie call
+ *
+ * Copyright IBM Corp. 2008
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License (version 2 only)
+ * as published by the Free Software Foundation.
+ *
+ *    Author(s): Heiko Carstens <heiko.carstens@de.ibm.com>
+ */
+
+#include <linux/errno.h>
+#include <asm/asm-offsets.h>
+
+SP_R5 =	5 * 8	# offset into stackframe
+SP_R6 =	6 * 8
+
+/*
+ * sie64a calling convention:
+ * %r2 pointer to sie control block
+ * %r3 guest register save area
+ */
+	.globl	sie64a
+sie64a:
+	lgr	%r5,%r3
+	stmg	%r5,%r14,SP_R5(%r15)	# save register on entry
+	lgr	%r14,%r2		# pointer to sie control block
+	lmg	%r0,%r13,0(%r3)		# load guest gprs 0-13
+sie_inst:
+	sie	0(%r14)
+	lg	%r14,SP_R5(%r15)
+	stmg	%r0,%r13,0(%r14)	# save guest gprs 0-13
+	lghi	%r2,0
+	lmg	%r6,%r14,SP_R6(%r15)
+	br	%r14
+
+sie_err:
+	lg	%r14,SP_R5(%r15)
+	stmg	%r0,%r13,0(%r14)	# save guest gprs 0-13
+	lghi	%r2,-EFAULT
+	lmg	%r6,%r14,SP_R6(%r15)
+	br	%r14
+
+	.section __ex_table,"a"
+	.quad	sie_inst,sie_err
+	.previous
diff --git a/include/asm-s390/Kbuild b/include/asm-s390/Kbuild
index e92b429..13c9805 100644
--- a/include/asm-s390/Kbuild
+++ b/include/asm-s390/Kbuild
@@ -7,6 +7,7 @@ header-y += tape390.h
 header-y += ucontext.h
 header-y += vtoc.h
 header-y += zcrypt.h
+header-y += kvm.h
 
 unifdef-y += cmb.h
 unifdef-y += debug.h
diff --git a/include/asm-s390/kvm.h b/include/asm-s390/kvm.h
index 573f2a3..d74002f 100644
--- a/include/asm-s390/kvm.h
+++ b/include/asm-s390/kvm.h
@@ -1,6 +1,45 @@
 #ifndef __LINUX_KVM_S390_H
 #define __LINUX_KVM_S390_H
 
-/* s390 does not support KVM */
+/*
+ * asm-s390/kvm.h - KVM s390 specific structures and definitions
+ *
+ * Copyright IBM Corp. 2008
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License (version 2 only)
+ * as published by the Free Software Foundation.
+ *
+ *    Author(s): Carsten Otte <cotte@de.ibm.com>
+ *               Christian Borntraeger <borntraeger@de.ibm.com>
+ */
+#include <asm/types.h>
+
+/* for KVM_GET_IRQCHIP and KVM_SET_IRQCHIP */
+struct kvm_pic_state {
+	/* no PIC for s390 */
+};
+
+struct kvm_ioapic_state {
+	/* no IOAPIC for s390 */
+};
+
+/* for KVM_GET_REGS and KVM_SET_REGS */
+struct kvm_regs {
+	/* general purpose regs for s390 */
+	__u64 gprs[16];
+};
+
+/* for KVM_GET_SREGS and KVM_SET_SREGS */
+struct kvm_sregs {
+	__u32 acrs[16];
+	__u64 crs[16];
+};
+
+/* for KVM_GET_FPU and KVM_SET_FPU */
+struct kvm_fpu {
+	__u32 fpc;
+	__u64 fprs[16];
+};
 
 #endif
diff --git a/include/asm-s390/kvm_host.h b/include/asm-s390/kvm_host.h
new file mode 100644
index 0000000..c9d6533
--- /dev/null
+++ b/include/asm-s390/kvm_host.h
@@ -0,0 +1,127 @@
+/*
+ * asm-s390/kvm_host.h - definition for kernel virtual machines on s390
+ *
+ * Copyright IBM Corp. 2008
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License (version 2 only)
+ * as published by the Free Software Foundation.
+ *
+ *    Author(s): Carsten Otte <cotte@de.ibm.com>
+ */
+
+
+#ifndef ASM_KVM_HOST_H
+#define ASM_KVM_HOST_H
+#include <linux/kvm_host.h>
+#include <asm/debug.h>
+
+#define KVM_MAX_VCPUS 64
+#define KVM_MEMORY_SLOTS 32
+/* memory slots that does not exposed to userspace */
+#define KVM_PRIVATE_MEM_SLOTS 4
+
+struct kvm_guest_debug {
+};
+
+struct sca_entry {
+	atomic_t scn;
+	__u64	reserved;
+	__u64	sda;
+	__u64	reserved2[2];
+} __attribute__((packed));
+
+
+struct sca_block {
+	__u64	ipte_control;
+	__u64	reserved[5];
+	__u64	mcn;
+	__u64	reserved2;
+	struct sca_entry cpu[64];
+} __attribute__((packed));
+
+#define KVM_PAGES_PER_HPAGE 256
+
+#define CPUSTAT_HOST       0x80000000
+#define CPUSTAT_WAIT       0x10000000
+#define CPUSTAT_ECALL_PEND 0x08000000
+#define CPUSTAT_STOP_INT   0x04000000
+#define CPUSTAT_IO_INT     0x02000000
+#define CPUSTAT_EXT_INT    0x01000000
+#define CPUSTAT_RUNNING    0x00800000
+#define CPUSTAT_RETAINED   0x00400000
+#define CPUSTAT_TIMING_SUB 0x00020000
+#define CPUSTAT_SIE_SUB    0x00010000
+#define CPUSTAT_RRF        0x00008000
+#define CPUSTAT_SLSV       0x00004000
+#define CPUSTAT_SLSR       0x00002000
+#define CPUSTAT_ZARCH      0x00000800
+#define CPUSTAT_MCDS       0x00000100
+#define CPUSTAT_SM         0x00000080
+#define CPUSTAT_G          0x00000008
+#define CPUSTAT_J          0x00000002
+#define CPUSTAT_P          0x00000001
+
+struct sie_block {
+	atomic_t cpuflags;		/* 0x0000 */
+	__u32	prefix;			/* 0x0004 */
+	__u8	reserved8[32];		/* 0x0008 */
+	__u64	cputm;			/* 0x0028 */
+	__u64	ckc;			/* 0x0030 */
+	__u64	epoch;			/* 0x0038 */
+	__u8	reserved40[4];		/* 0x0040 */
+	__u16   lctl;			/* 0x0044 */
+	__s16	icpua;			/* 0x0046 */
+	__u32	ictl;			/* 0x0048 */
+	__u32	eca;			/* 0x004c */
+	__u8	icptcode;		/* 0x0050 */
+	__u8	reserved51;		/* 0x0051 */
+	__u16	ihcpu;			/* 0x0052 */
+	__u8	reserved54[2];		/* 0x0054 */
+	__u16	ipa;			/* 0x0056 */
+	__u32	ipb;			/* 0x0058 */
+	__u32	scaoh;			/* 0x005c */
+	__u8	reserved60;		/* 0x0060 */
+	__u8	ecb;			/* 0x0061 */
+	__u8	reserved62[2];		/* 0x0062 */
+	__u32	scaol;			/* 0x0064 */
+	__u8	reserved68[4];		/* 0x0068 */
+	__u32	todpr;			/* 0x006c */
+	__u8	reserved70[16];		/* 0x0070 */
+	__u64	gmsor;			/* 0x0080 */
+	__u64	gmslm;			/* 0x0088 */
+	psw_t	gpsw;			/* 0x0090 */
+	__u64	gg14;			/* 0x00a0 */
+	__u64	gg15;			/* 0x00a8 */
+	__u8	reservedb0[80];		/* 0x00b0 */
+	__u64	gcr[16];		/* 0x0100 */
+	__u64	gbea;			/* 0x0180 */
+	__u8	reserved188[120];	/* 0x0188 */
+} __attribute__((packed));
+
+struct kvm_vcpu_stat {
+	u32 exit_userspace;
+};
+
+struct kvm_vcpu_arch {
+	struct sie_block *sie_block;
+	unsigned long	  guest_gprs[16];
+	s390_fp_regs      host_fpregs;
+	unsigned int      host_acrs[NUM_ACRS];
+	s390_fp_regs      guest_fpregs;
+	unsigned int      guest_acrs[NUM_ACRS];
+};
+
+struct kvm_vm_stat {
+	u32 remote_tlb_flush;
+};
+
+struct kvm_arch{
+	unsigned long guest_origin;
+	unsigned long guest_memsize;
+	struct sca_block *sca;
+	debug_info_t *dbf;
+};
+
+extern int sie64a(struct sie_block *, __u64 *);
+#endif
diff --git a/include/asm-s390/kvm_para.h b/include/asm-s390/kvm_para.h
new file mode 100644
index 0000000..e9bd3fb
--- /dev/null
+++ b/include/asm-s390/kvm_para.h
@@ -0,0 +1,30 @@
+/*
+ * asm-s390/kvm_para.h - definition for paravirtual devices on s390
+ *
+ * Copyright IBM Corp. 2008
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License (version 2 only)
+ * as published by the Free Software Foundation.
+ *
+ *    Author(s): Christian Borntraeger <borntraeger@de.ibm.com>
+ */
+
+#ifndef __S390_KVM_PARA_H
+#define __S390_KVM_PARA_H
+
+/*
+ * No hypercalls for KVM on s390
+ */
+
+static inline int kvm_para_available(void)
+{
+	return 0;
+}
+
+static inline unsigned int kvm_arch_para_features(void)
+{
+	return 0;
+}
+
+#endif /* __S390_KVM_PARA_H */
diff --git a/include/linux/kvm.h b/include/linux/kvm.h
index 3bd3828..2367ff0 100644
--- a/include/linux/kvm.h
+++ b/include/linux/kvm.h
@@ -205,6 +205,11 @@ struct kvm_vapic_addr {
 	__u64 vapic_addr;
 };
 
+struct kvm_s390_psw {
+	__u64 mask;
+	__u64 addr;
+};
+
 #define KVMIO 0xAE
 
 /*
@@ -213,6 +218,8 @@ struct kvm_vapic_addr {
 #define KVM_GET_API_VERSION       _IO(KVMIO,   0x00)
 #define KVM_CREATE_VM             _IO(KVMIO,   0x01) /* returns a VM fd */
 #define KVM_GET_MSR_INDEX_LIST    _IOWR(KVMIO, 0x02, struct kvm_msr_list)
+
+#define KVM_S390_ENABLE_SIE       _IO(KVMIO,   0x06)
 /*
  * Check if a kvm extension is available.  Argument is extension number,
  * return is 1 (yes) or 0 (no, sorry).
@@ -291,5 +298,13 @@ struct kvm_vapic_addr {
 #define KVM_TPR_ACCESS_REPORTING  _IOWR(KVMIO,  0x92, struct kvm_tpr_access_ctl)
 /* Available with KVM_CAP_VAPIC */
 #define KVM_SET_VAPIC_ADDR        _IOW(KVMIO,  0x93, struct kvm_vapic_addr)
+/* store status for s390 */
+#define KVM_S390_STORE_STATUS_NOADDR    (-1ul)
+#define KVM_S390_STORE_STATUS_PREFIXED  (-2ul)
+#define KVM_S390_STORE_STATUS	  _IOW(KVMIO,  0x95, unsigned long)
+/* initial ipl psw for s390 */
+#define KVM_S390_SET_INITIAL_PSW  _IOW(KVMIO,  0x96, struct kvm_s390_psw)
+/* initial reset for s390 */
+#define KVM_S390_INITIAL_RESET    _IO(KVMIO,  0x97)
 
 #endif
-- 
1.5.5

