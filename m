Return-Path: <linux-kernel-owner+w=401wt.eu-S1759300AbXLWPBt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759300AbXLWPBt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Dec 2007 10:01:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753087AbXLWOwO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Dec 2007 09:52:14 -0500
Received: from il.qumranet.com ([82.166.9.18]:35913 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753854AbXLWOvp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Dec 2007 09:51:45 -0500
From: Avi Kivity <avi@qumranet.com>
To: linux-kernel@vger.kernel.org, kvm-devel@lists.sourceforge.net
Cc: Carsten Otte <cotte@de.ibm.com>
Subject: [PATCH 37/50] KVM: Portability: split kvm_vcpu_ioctl
Date: Sun, 23 Dec 2007 16:51:22 +0200
Message-Id: <1198421495-31481-38-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.3.7
In-Reply-To: <1198421495-31481-1-git-send-email-avi@qumranet.com>
References: <1198421495-31481-1-git-send-email-avi@qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Carsten Otte <cotte@de.ibm.com>

This patch splits kvm_vcpu_ioctl into archtecture independent parts, and
x86 specific parts which go to kvm_arch_vcpu_ioctl in x86.c.

Common ioctls for all architectures are:
KVM_RUN, KVM_GET/SET_(S-)REGS, KVM_TRANSLATE, KVM_INTERRUPT,
KVM_DEBUG_GUEST, KVM_SET_SIGNAL_MASK, KVM_GET/SET_FPU
Note that some PPC chips don't have an FPU, so we might need an #ifdef
around KVM_GET/SET_FPU one day.

x86 specific ioctls are:
KVM_GET/SET_LAPIC, KVM_SET_CPUID, KVM_GET/SET_MSRS

An interresting aspect is vcpu_load/vcpu_put. We now have a common
vcpu_load/put which does the preemption stuff, and an architecture
specific kvm_arch_vcpu_load/put. In the x86 case, this one calls the
vmx/svm function defined in kvm_x86_ops.

Signed-off-by: Carsten Otte <cotte@de.ibm.com>
Reviewed-by: Christian Borntraeger <borntraeger@de.ibm.com>
Reviewed-by: Christian Ehrhardt <ehrhardt@linux.vnet.ibm.com>
Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 drivers/kvm/kvm.h      |    9 ++
 drivers/kvm/kvm_main.c |  200 ++------------------------------------------
 drivers/kvm/x86.c      |  219 ++++++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 234 insertions(+), 194 deletions(-)

diff --git a/drivers/kvm/kvm.h b/drivers/kvm/kvm.h
index d56962d..1edf8a5 100644
--- a/drivers/kvm/kvm.h
+++ b/drivers/kvm/kvm.h
@@ -537,6 +537,10 @@ extern struct kvm_x86_ops *kvm_x86_ops;
 int kvm_vcpu_init(struct kvm_vcpu *vcpu, struct kvm *kvm, unsigned id);
 void kvm_vcpu_uninit(struct kvm_vcpu *vcpu);
 
+void vcpu_load(struct kvm_vcpu *vcpu);
+void vcpu_put(struct kvm_vcpu *vcpu);
+
+
 int kvm_init_x86(struct kvm_x86_ops *ops, unsigned int vcpu_size,
 		  struct module *module);
 void kvm_exit_x86(void);
@@ -655,6 +659,11 @@ int kvm_fix_hypercall(struct kvm_vcpu *vcpu);
 
 long kvm_arch_dev_ioctl(struct file *filp,
 			unsigned int ioctl, unsigned long arg);
+long kvm_arch_vcpu_ioctl(struct file *filp,
+			 unsigned int ioctl, unsigned long arg);
+void kvm_arch_vcpu_load(struct kvm_vcpu *vcpu, int cpu);
+void kvm_arch_vcpu_put(struct kvm_vcpu *vcpu);
+
 __init void kvm_arch_init(void);
 
 static inline void kvm_guest_enter(void)
diff --git a/drivers/kvm/kvm_main.c b/drivers/kvm/kvm_main.c
index 9f7370f..03d6069 100644
--- a/drivers/kvm/kvm_main.c
+++ b/drivers/kvm/kvm_main.c
@@ -90,8 +90,6 @@ static struct kvm_stats_debugfs_item {
 
 static struct dentry *debugfs_dir;
 
-#define MAX_IO_MSRS 256
-
 #define CR0_RESERVED_BITS						\
 	(~(unsigned long)(X86_CR0_PE | X86_CR0_MP | X86_CR0_EM | X86_CR0_TS \
 			  | X86_CR0_ET | X86_CR0_NE | X86_CR0_WP | X86_CR0_AM \
@@ -179,21 +177,21 @@ EXPORT_SYMBOL_GPL(kvm_put_guest_fpu);
 /*
  * Switches to specified vcpu, until a matching vcpu_put()
  */
-static void vcpu_load(struct kvm_vcpu *vcpu)
+void vcpu_load(struct kvm_vcpu *vcpu)
 {
 	int cpu;
 
 	mutex_lock(&vcpu->mutex);
 	cpu = get_cpu();
 	preempt_notifier_register(&vcpu->preempt_notifier);
-	kvm_x86_ops->vcpu_load(vcpu, cpu);
+	kvm_arch_vcpu_load(vcpu, cpu);
 	put_cpu();
 }
 
-static void vcpu_put(struct kvm_vcpu *vcpu)
+void vcpu_put(struct kvm_vcpu *vcpu)
 {
 	preempt_disable();
-	kvm_x86_ops->vcpu_put(vcpu);
+	kvm_arch_vcpu_put(vcpu);
 	preempt_notifier_unregister(&vcpu->preempt_notifier);
 	preempt_enable();
 	mutex_unlock(&vcpu->mutex);
@@ -2509,86 +2507,6 @@ void kvm_get_cs_db_l_bits(struct kvm_vcpu *vcpu, int *db, int *l)
 EXPORT_SYMBOL_GPL(kvm_get_cs_db_l_bits);
 
 /*
- * Adapt set_msr() to msr_io()'s calling convention
- */
-static int do_set_msr(struct kvm_vcpu *vcpu, unsigned index, u64 *data)
-{
-	return kvm_set_msr(vcpu, index, *data);
-}
-
-/*
- * Read or write a bunch of msrs. All parameters are kernel addresses.
- *
- * @return number of msrs set successfully.
- */
-static int __msr_io(struct kvm_vcpu *vcpu, struct kvm_msrs *msrs,
-		    struct kvm_msr_entry *entries,
-		    int (*do_msr)(struct kvm_vcpu *vcpu,
-				  unsigned index, u64 *data))
-{
-	int i;
-
-	vcpu_load(vcpu);
-
-	for (i = 0; i < msrs->nmsrs; ++i)
-		if (do_msr(vcpu, entries[i].index, &entries[i].data))
-			break;
-
-	vcpu_put(vcpu);
-
-	return i;
-}
-
-/*
- * Read or write a bunch of msrs. Parameters are user addresses.
- *
- * @return number of msrs set successfully.
- */
-static int msr_io(struct kvm_vcpu *vcpu, struct kvm_msrs __user *user_msrs,
-		  int (*do_msr)(struct kvm_vcpu *vcpu,
-				unsigned index, u64 *data),
-		  int writeback)
-{
-	struct kvm_msrs msrs;
-	struct kvm_msr_entry *entries;
-	int r, n;
-	unsigned size;
-
-	r = -EFAULT;
-	if (copy_from_user(&msrs, user_msrs, sizeof msrs))
-		goto out;
-
-	r = -E2BIG;
-	if (msrs.nmsrs >= MAX_IO_MSRS)
-		goto out;
-
-	r = -ENOMEM;
-	size = sizeof(struct kvm_msr_entry) * msrs.nmsrs;
-	entries = vmalloc(size);
-	if (!entries)
-		goto out;
-
-	r = -EFAULT;
-	if (copy_from_user(entries, user_msrs->entries, size))
-		goto out_free;
-
-	r = n = __msr_io(vcpu, &msrs, entries, do_msr);
-	if (r < 0)
-		goto out_free;
-
-	r = -EFAULT;
-	if (writeback && copy_to_user(user_msrs->entries, entries, size))
-		goto out_free;
-
-	r = n;
-
-out_free:
-	vfree(entries);
-out:
-	return r;
-}
-
-/*
  * Translate a guest virtual address to a guest physical address.
  */
 static int kvm_vcpu_ioctl_translate(struct kvm_vcpu *vcpu,
@@ -2761,48 +2679,6 @@ free_vcpu:
 	return r;
 }
 
-static void cpuid_fix_nx_cap(struct kvm_vcpu *vcpu)
-{
-	u64 efer;
-	int i;
-	struct kvm_cpuid_entry *e, *entry;
-
-	rdmsrl(MSR_EFER, efer);
-	entry = NULL;
-	for (i = 0; i < vcpu->cpuid_nent; ++i) {
-		e = &vcpu->cpuid_entries[i];
-		if (e->function == 0x80000001) {
-			entry = e;
-			break;
-		}
-	}
-	if (entry && (entry->edx & (1 << 20)) && !(efer & EFER_NX)) {
-		entry->edx &= ~(1 << 20);
-		printk(KERN_INFO "kvm: guest NX capability removed\n");
-	}
-}
-
-static int kvm_vcpu_ioctl_set_cpuid(struct kvm_vcpu *vcpu,
-				    struct kvm_cpuid *cpuid,
-				    struct kvm_cpuid_entry __user *entries)
-{
-	int r;
-
-	r = -E2BIG;
-	if (cpuid->nent > KVM_MAX_CPUID_ENTRIES)
-		goto out;
-	r = -EFAULT;
-	if (copy_from_user(&vcpu->cpuid_entries, entries,
-			   cpuid->nent * sizeof(struct kvm_cpuid_entry)))
-		goto out;
-	vcpu->cpuid_nent = cpuid->nent;
-	cpuid_fix_nx_cap(vcpu);
-	return 0;
-
-out:
-	return r;
-}
-
 static int kvm_vcpu_ioctl_set_sigmask(struct kvm_vcpu *vcpu, sigset_t *sigset)
 {
 	if (sigset) {
@@ -2875,33 +2751,12 @@ static int kvm_vcpu_ioctl_set_fpu(struct kvm_vcpu *vcpu, struct kvm_fpu *fpu)
 	return 0;
 }
 
-static int kvm_vcpu_ioctl_get_lapic(struct kvm_vcpu *vcpu,
-				    struct kvm_lapic_state *s)
-{
-	vcpu_load(vcpu);
-	memcpy(s->regs, vcpu->apic->regs, sizeof *s);
-	vcpu_put(vcpu);
-
-	return 0;
-}
-
-static int kvm_vcpu_ioctl_set_lapic(struct kvm_vcpu *vcpu,
-				    struct kvm_lapic_state *s)
-{
-	vcpu_load(vcpu);
-	memcpy(vcpu->apic->regs, s->regs, sizeof *s);
-	kvm_apic_post_state_restore(vcpu);
-	vcpu_put(vcpu);
-
-	return 0;
-}
-
 static long kvm_vcpu_ioctl(struct file *filp,
 			   unsigned int ioctl, unsigned long arg)
 {
 	struct kvm_vcpu *vcpu = filp->private_data;
 	void __user *argp = (void __user *)arg;
-	int r = -EINVAL;
+	int r;
 
 	switch (ioctl) {
 	case KVM_RUN:
@@ -2999,24 +2854,6 @@ static long kvm_vcpu_ioctl(struct file *filp,
 		r = 0;
 		break;
 	}
-	case KVM_GET_MSRS:
-		r = msr_io(vcpu, argp, kvm_get_msr, 1);
-		break;
-	case KVM_SET_MSRS:
-		r = msr_io(vcpu, argp, do_set_msr, 0);
-		break;
-	case KVM_SET_CPUID: {
-		struct kvm_cpuid __user *cpuid_arg = argp;
-		struct kvm_cpuid cpuid;
-
-		r = -EFAULT;
-		if (copy_from_user(&cpuid, cpuid_arg, sizeof cpuid))
-			goto out;
-		r = kvm_vcpu_ioctl_set_cpuid(vcpu, &cpuid, cpuid_arg->entries);
-		if (r)
-			goto out;
-		break;
-	}
 	case KVM_SET_SIGNAL_MASK: {
 		struct kvm_signal_mask __user *sigmask_arg = argp;
 		struct kvm_signal_mask kvm_sigmask;
@@ -3065,33 +2902,8 @@ static long kvm_vcpu_ioctl(struct file *filp,
 		r = 0;
 		break;
 	}
-	case KVM_GET_LAPIC: {
-		struct kvm_lapic_state lapic;
-
-		memset(&lapic, 0, sizeof lapic);
-		r = kvm_vcpu_ioctl_get_lapic(vcpu, &lapic);
-		if (r)
-			goto out;
-		r = -EFAULT;
-		if (copy_to_user(argp, &lapic, sizeof lapic))
-			goto out;
-		r = 0;
-		break;
-	}
-	case KVM_SET_LAPIC: {
-		struct kvm_lapic_state lapic;
-
-		r = -EFAULT;
-		if (copy_from_user(&lapic, argp, sizeof lapic))
-			goto out;
-		r = kvm_vcpu_ioctl_set_lapic(vcpu, &lapic);;
-		if (r)
-			goto out;
-		r = 0;
-		break;
-	}
 	default:
-		;
+		r = kvm_arch_vcpu_ioctl(filp, ioctl, arg);
 	}
 out:
 	return r;
diff --git a/drivers/kvm/x86.c b/drivers/kvm/x86.c
index 437902c..1fe209d 100644
--- a/drivers/kvm/x86.c
+++ b/drivers/kvm/x86.c
@@ -14,10 +14,18 @@
  *
  */
 
+#include "kvm.h"
 #include "x86.h"
+#include "irq.h"
+
+#include <linux/kvm.h>
+#include <linux/fs.h>
+#include <linux/vmalloc.h>
 
 #include <asm/uaccess.h>
 
+#define MAX_IO_MSRS 256
+
 /*
  * List of msr numbers which we expose to userspace through KVM_GET_MSRS
  * and KVM_SET_MSRS, and KVM_GET_MSR_INDEX_LIST.
@@ -40,6 +48,86 @@ static u32 emulated_msrs[] = {
 	MSR_IA32_MISC_ENABLE,
 };
 
+/*
+ * Adapt set_msr() to msr_io()'s calling convention
+ */
+static int do_set_msr(struct kvm_vcpu *vcpu, unsigned index, u64 *data)
+{
+	return kvm_set_msr(vcpu, index, *data);
+}
+
+/*
+ * Read or write a bunch of msrs. All parameters are kernel addresses.
+ *
+ * @return number of msrs set successfully.
+ */
+static int __msr_io(struct kvm_vcpu *vcpu, struct kvm_msrs *msrs,
+		    struct kvm_msr_entry *entries,
+		    int (*do_msr)(struct kvm_vcpu *vcpu,
+				  unsigned index, u64 *data))
+{
+	int i;
+
+	vcpu_load(vcpu);
+
+	for (i = 0; i < msrs->nmsrs; ++i)
+		if (do_msr(vcpu, entries[i].index, &entries[i].data))
+			break;
+
+	vcpu_put(vcpu);
+
+	return i;
+}
+
+/*
+ * Read or write a bunch of msrs. Parameters are user addresses.
+ *
+ * @return number of msrs set successfully.
+ */
+static int msr_io(struct kvm_vcpu *vcpu, struct kvm_msrs __user *user_msrs,
+		  int (*do_msr)(struct kvm_vcpu *vcpu,
+				unsigned index, u64 *data),
+		  int writeback)
+{
+	struct kvm_msrs msrs;
+	struct kvm_msr_entry *entries;
+	int r, n;
+	unsigned size;
+
+	r = -EFAULT;
+	if (copy_from_user(&msrs, user_msrs, sizeof msrs))
+		goto out;
+
+	r = -E2BIG;
+	if (msrs.nmsrs >= MAX_IO_MSRS)
+		goto out;
+
+	r = -ENOMEM;
+	size = sizeof(struct kvm_msr_entry) * msrs.nmsrs;
+	entries = vmalloc(size);
+	if (!entries)
+		goto out;
+
+	r = -EFAULT;
+	if (copy_from_user(entries, user_msrs->entries, size))
+		goto out_free;
+
+	r = n = __msr_io(vcpu, &msrs, entries, do_msr);
+	if (r < 0)
+		goto out_free;
+
+	r = -EFAULT;
+	if (writeback && copy_to_user(user_msrs->entries, entries, size))
+		goto out_free;
+
+	r = n;
+
+out_free:
+	vfree(entries);
+out:
+	return r;
+}
+
 long kvm_arch_dev_ioctl(struct file *filp,
 			unsigned int ioctl, unsigned long arg)
 {
@@ -81,6 +169,137 @@ out:
 	return r;
 }
 
+void kvm_arch_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
+{
+	kvm_x86_ops->vcpu_load(vcpu, cpu);
+}
+
+void kvm_arch_vcpu_put(struct kvm_vcpu *vcpu)
+{
+	kvm_x86_ops->vcpu_put(vcpu);
+}
+
+static void cpuid_fix_nx_cap(struct kvm_vcpu *vcpu)
+{
+	u64 efer;
+	int i;
+	struct kvm_cpuid_entry *e, *entry;
+
+	rdmsrl(MSR_EFER, efer);
+	entry = NULL;
+	for (i = 0; i < vcpu->cpuid_nent; ++i) {
+		e = &vcpu->cpuid_entries[i];
+		if (e->function == 0x80000001) {
+			entry = e;
+			break;
+		}
+	}
+	if (entry && (entry->edx & (1 << 20)) && !(efer & EFER_NX)) {
+		entry->edx &= ~(1 << 20);
+		printk(KERN_INFO "kvm: guest NX capability removed\n");
+	}
+}
+
+static int kvm_vcpu_ioctl_set_cpuid(struct kvm_vcpu *vcpu,
+				    struct kvm_cpuid *cpuid,
+				    struct kvm_cpuid_entry __user *entries)
+{
+	int r;
+
+	r = -E2BIG;
+	if (cpuid->nent > KVM_MAX_CPUID_ENTRIES)
+		goto out;
+	r = -EFAULT;
+	if (copy_from_user(&vcpu->cpuid_entries, entries,
+			   cpuid->nent * sizeof(struct kvm_cpuid_entry)))
+		goto out;
+	vcpu->cpuid_nent = cpuid->nent;
+	cpuid_fix_nx_cap(vcpu);
+	return 0;
+
+out:
+	return r;
+}
+
+static int kvm_vcpu_ioctl_get_lapic(struct kvm_vcpu *vcpu,
+				    struct kvm_lapic_state *s)
+{
+	vcpu_load(vcpu);
+	memcpy(s->regs, vcpu->apic->regs, sizeof *s);
+	vcpu_put(vcpu);
+
+	return 0;
+}
+
+static int kvm_vcpu_ioctl_set_lapic(struct kvm_vcpu *vcpu,
+				    struct kvm_lapic_state *s)
+{
+	vcpu_load(vcpu);
+	memcpy(vcpu->apic->regs, s->regs, sizeof *s);
+	kvm_apic_post_state_restore(vcpu);
+	vcpu_put(vcpu);
+
+	return 0;
+}
+
+long kvm_arch_vcpu_ioctl(struct file *filp,
+			 unsigned int ioctl, unsigned long arg)
+{
+	struct kvm_vcpu *vcpu = filp->private_data;
+	void __user *argp = (void __user *)arg;
+	int r;
+
+	switch (ioctl) {
+	case KVM_GET_LAPIC: {
+		struct kvm_lapic_state lapic;
+
+		memset(&lapic, 0, sizeof lapic);
+		r = kvm_vcpu_ioctl_get_lapic(vcpu, &lapic);
+		if (r)
+			goto out;
+		r = -EFAULT;
+		if (copy_to_user(argp, &lapic, sizeof lapic))
+			goto out;
+		r = 0;
+		break;
+	}
+	case KVM_SET_LAPIC: {
+		struct kvm_lapic_state lapic;
+
+		r = -EFAULT;
+		if (copy_from_user(&lapic, argp, sizeof lapic))
+			goto out;
+		r = kvm_vcpu_ioctl_set_lapic(vcpu, &lapic);;
+		if (r)
+			goto out;
+		r = 0;
+		break;
+	}
+	case KVM_SET_CPUID: {
+		struct kvm_cpuid __user *cpuid_arg = argp;
+		struct kvm_cpuid cpuid;
+
+		r = -EFAULT;
+		if (copy_from_user(&cpuid, cpuid_arg, sizeof cpuid))
+			goto out;
+		r = kvm_vcpu_ioctl_set_cpuid(vcpu, &cpuid, cpuid_arg->entries);
+		if (r)
+			goto out;
+		break;
+	}
+	case KVM_GET_MSRS:
+		r = msr_io(vcpu, argp, kvm_get_msr, 1);
+		break;
+	case KVM_SET_MSRS:
+		r = msr_io(vcpu, argp, do_set_msr, 0);
+		break;
+	default:
+		r = -EINVAL;
+	}
+out:
+	return r;
+}
+
 static __init void kvm_init_msr_list(void)
 {
 	u32 dummy[2];
-- 
1.5.3.7

