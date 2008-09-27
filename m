Return-Path: <linux-kernel-owner+w=401wt.eu-S1753957AbYI0Ppt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753957AbYI0Ppt (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Sep 2008 11:45:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752652AbYI0Pom
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 27 Sep 2008 11:44:42 -0400
Received: from mx2.redhat.com ([66.187.237.31]:33193 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752595AbYI0Pok (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Sep 2008 11:44:40 -0400
From: Avi Kivity <avi@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: viro@ZenIV.linux.org.uk, linux-kernel@vger.kernel.org
Subject: [PATCH 3/3] KVM: Convert x86 vcpu ioctls to use dispatch_ioctl_extensible()
Date: Sat, 27 Sep 2008 18:44:02 +0300
Message-Id: <1222530242-1272-4-git-send-email-avi@redhat.com>
In-Reply-To: <1222530242-1272-1-git-send-email-avi@redhat.com>
References: <1222530242-1272-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Avi Kivity <avi@redhat.com>
---
 arch/x86/kvm/x86.c |  241 +++++++++++++++++-----------------------------------
 1 files changed, 77 insertions(+), 164 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 4cfdd1b..aa9d228 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -1084,26 +1084,24 @@ static int __msr_io(struct kvm_vcpu *vcpu, struct kvm_msrs *msrs,
  *
  * @return number of msrs set successfully.
  */
-static int msr_io(struct kvm_vcpu *vcpu, struct kvm_msrs __user *user_msrs,
+static int msr_io(const struct ioctl_arg *iarg,
 		  int (*do_msr)(struct kvm_vcpu *vcpu,
-				unsigned index, u64 *data),
-		  int writeback)
+				unsigned index, u64 *data))
 {
-	struct kvm_msrs msrs;
+	struct kvm_vcpu *vcpu = iarg->file->private_data;
+	struct kvm_msrs *msrs = iarg->argp;
+	struct kvm_msrs __user *user_msrs =
+		(void __user *)iarg->argl + _IOC_SIZE(iarg->cmd);
 	struct kvm_msr_entry *entries;
-	int r, n;
+	int r;
 	unsigned size;
 
-	r = -EFAULT;
-	if (copy_from_user(&msrs, user_msrs, sizeof msrs))
-		goto out;
-
 	r = -E2BIG;
-	if (msrs.nmsrs >= MAX_IO_MSRS)
+	if (msrs->nmsrs >= MAX_IO_MSRS)
 		goto out;
 
 	r = -ENOMEM;
-	size = sizeof(struct kvm_msr_entry) * msrs.nmsrs;
+	size = sizeof(struct kvm_msr_entry) * msrs->nmsrs;
 	entries = vmalloc(size);
 	if (!entries)
 		goto out;
@@ -1112,22 +1110,26 @@ static int msr_io(struct kvm_vcpu *vcpu, struct kvm_msrs __user *user_msrs,
 	if (copy_from_user(entries, user_msrs->entries, size))
 		goto out_free;
 
-	r = n = __msr_io(vcpu, &msrs, entries, do_msr);
+	r = __msr_io(vcpu, msrs, entries, do_msr);
 	if (r < 0)
 		goto out_free;
 
-	r = -EFAULT;
-	if (writeback && copy_to_user(user_msrs->entries, entries, size))
-		goto out_free;
-
-	r = n;
-
 out_free:
 	vfree(entries);
 out:
 	return r;
 }
 
+static long kvm_vcpu_ioctl_get_msrs(const struct ioctl_arg *iarg)
+{
+	return msr_io(iarg, kvm_get_msr);
+}
+
+static long kvm_vcpu_ioctl_set_msrs(const struct ioctl_arg *iarg)
+{
+	return msr_io(iarg, do_set_msr);
+}
+
 int kvm_dev_ioctl_check_extension(long ext)
 {
 	int r;
@@ -1271,10 +1273,12 @@ static void cpuid_fix_nx_cap(struct kvm_vcpu *vcpu)
 }
 
 /* when an old userspace process fills a new kernel module */
-static int kvm_vcpu_ioctl_set_cpuid(struct kvm_vcpu *vcpu,
-				    struct kvm_cpuid *cpuid,
-				    struct kvm_cpuid_entry __user *entries)
+static long kvm_vcpu_ioctl_set_cpuid(const struct ioctl_arg *iarg)
 {
+	struct kvm_vcpu *vcpu = iarg->file->private_data;
+	struct kvm_cpuid *cpuid = iarg->argp;
+	struct kvm_cpuid_entry __user *entries
+		= (void __user *)iarg->argl + _IOC_SIZE(iarg->cmd);
 	int r, i;
 	struct kvm_cpuid_entry *cpuid_entries;
 
@@ -1311,10 +1315,12 @@ out:
 	return r;
 }
 
-static int kvm_vcpu_ioctl_set_cpuid2(struct kvm_vcpu *vcpu,
-				    struct kvm_cpuid2 *cpuid,
-				    struct kvm_cpuid_entry2 __user *entries)
+static long kvm_vcpu_ioctl_set_cpuid2(const struct ioctl_arg *iarg)
 {
+	struct kvm_vcpu *vcpu = iarg->file->private_data;
+	struct kvm_cpuid2 *cpuid = iarg->argp;
+	struct kvm_cpuid_entry2 __user *entries
+		= (void __user *)iarg->argl + _IOC_SIZE(iarg->cmd);
 	int r;
 
 	r = -E2BIG;
@@ -1331,10 +1337,12 @@ out:
 	return r;
 }
 
-static int kvm_vcpu_ioctl_get_cpuid2(struct kvm_vcpu *vcpu,
-				    struct kvm_cpuid2 *cpuid,
-				    struct kvm_cpuid_entry2 __user *entries)
+static long kvm_vcpu_ioctl_get_cpuid2(const struct ioctl_arg *iarg)
 {
+	struct kvm_vcpu *vcpu = iarg->file->private_data;
+	struct kvm_cpuid2 *cpuid = iarg->argp;
+	struct kvm_cpuid_entry2 __user *entries
+		= (void __user *)iarg->argl + _IOC_SIZE(iarg->cmd);
 	int r;
 
 	r = -E2BIG;
@@ -1513,19 +1521,22 @@ out:
 	return r;
 }
 
-static int kvm_vcpu_ioctl_get_lapic(struct kvm_vcpu *vcpu,
-				    struct kvm_lapic_state *s)
+static long kvm_vcpu_ioctl_get_lapic(const struct ioctl_arg *iarg)
 {
+	struct kvm_vcpu *vcpu = iarg->file->private_data;
+	struct kvm_lapic_state *s = iarg->argp;
+
 	vcpu_load(vcpu);
 	memcpy(s->regs, vcpu->arch.apic->regs, sizeof *s);
 	vcpu_put(vcpu);
-
 	return 0;
 }
 
-static int kvm_vcpu_ioctl_set_lapic(struct kvm_vcpu *vcpu,
-				    struct kvm_lapic_state *s)
+static long kvm_vcpu_ioctl_set_lapic(const struct ioctl_arg *iarg)
 {
+	struct kvm_vcpu *vcpu = iarg->file->private_data;
+	struct kvm_lapic_state *s = iarg->argp;
+
 	vcpu_load(vcpu);
 	memcpy(vcpu->arch.apic->regs, s->regs, sizeof *s);
 	kvm_apic_post_state_restore(vcpu);
@@ -1534,9 +1545,11 @@ static int kvm_vcpu_ioctl_set_lapic(struct kvm_vcpu *vcpu,
 	return 0;
 }
 
-static int kvm_vcpu_ioctl_interrupt(struct kvm_vcpu *vcpu,
-				    struct kvm_interrupt *irq)
+static long kvm_vcpu_ioctl_interrupt(const struct ioctl_arg *iarg)
 {
+	struct kvm_vcpu *vcpu = iarg->file->private_data;
+	struct kvm_interrupt *irq = iarg->argp;
+
 	if (irq->irq < 0 || irq->irq >= 256)
 		return -EINVAL;
 	if (irqchip_in_kernel(vcpu->kvm))
@@ -1551,148 +1564,48 @@ static int kvm_vcpu_ioctl_interrupt(struct kvm_vcpu *vcpu,
 	return 0;
 }
 
-static int vcpu_ioctl_tpr_access_reporting(struct kvm_vcpu *vcpu,
-					   struct kvm_tpr_access_ctl *tac)
+static long vcpu_ioctl_tpr_access_reporting(const struct ioctl_arg *iarg)
 {
+	struct kvm_vcpu *vcpu = iarg->file->private_data;
+	struct kvm_tpr_access_ctl *tac = iarg->argp;
+
 	if (tac->flags)
 		return -EINVAL;
 	vcpu->arch.tpr_access_reporting = !!tac->enabled;
 	return 0;
 }
 
-long kvm_arch_vcpu_ioctl(struct file *filp,
-			 unsigned int ioctl, unsigned long arg)
+static long vcpu_ioctl_set_vapic_addr(const struct ioctl_arg *iarg)
 {
-	struct kvm_vcpu *vcpu = filp->private_data;
-	void __user *argp = (void __user *)arg;
-	int r;
-	struct kvm_lapic_state *lapic = NULL;
-
-	switch (ioctl) {
-	case KVM_GET_LAPIC: {
-		lapic = kzalloc(sizeof(struct kvm_lapic_state), GFP_KERNEL);
-
-		r = -ENOMEM;
-		if (!lapic)
-			goto out;
-		r = kvm_vcpu_ioctl_get_lapic(vcpu, lapic);
-		if (r)
-			goto out;
-		r = -EFAULT;
-		if (copy_to_user(argp, lapic, sizeof(struct kvm_lapic_state)))
-			goto out;
-		r = 0;
-		break;
-	}
-	case KVM_SET_LAPIC: {
-		lapic = kmalloc(sizeof(struct kvm_lapic_state), GFP_KERNEL);
-		r = -ENOMEM;
-		if (!lapic)
-			goto out;
-		r = -EFAULT;
-		if (copy_from_user(lapic, argp, sizeof(struct kvm_lapic_state)))
-			goto out;
-		r = kvm_vcpu_ioctl_set_lapic(vcpu, lapic);
-		if (r)
-			goto out;
-		r = 0;
-		break;
-	}
-	case KVM_INTERRUPT: {
-		struct kvm_interrupt irq;
-
-		r = -EFAULT;
-		if (copy_from_user(&irq, argp, sizeof irq))
-			goto out;
-		r = kvm_vcpu_ioctl_interrupt(vcpu, &irq);
-		if (r)
-			goto out;
-		r = 0;
-		break;
-	}
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
-	case KVM_SET_CPUID2: {
-		struct kvm_cpuid2 __user *cpuid_arg = argp;
-		struct kvm_cpuid2 cpuid;
+	struct kvm_vcpu *vcpu = iarg->file->private_data;
+	struct kvm_vapic_addr *va = iarg->argp;
 
-		r = -EFAULT;
-		if (copy_from_user(&cpuid, cpuid_arg, sizeof cpuid))
-			goto out;
-		r = kvm_vcpu_ioctl_set_cpuid2(vcpu, &cpuid,
-				cpuid_arg->entries);
-		if (r)
-			goto out;
-		break;
-	}
-	case KVM_GET_CPUID2: {
-		struct kvm_cpuid2 __user *cpuid_arg = argp;
-		struct kvm_cpuid2 cpuid;
+	if (!irqchip_in_kernel(vcpu->kvm))
+		return -EINVAL;
 
-		r = -EFAULT;
-		if (copy_from_user(&cpuid, cpuid_arg, sizeof cpuid))
-			goto out;
-		r = kvm_vcpu_ioctl_get_cpuid2(vcpu, &cpuid,
-				cpuid_arg->entries);
-		if (r)
-			goto out;
-		r = -EFAULT;
-		if (copy_to_user(cpuid_arg, &cpuid, sizeof cpuid))
-			goto out;
-		r = 0;
-		break;
-	}
-	case KVM_GET_MSRS:
-		r = msr_io(vcpu, argp, kvm_get_msr, 1);
-		break;
-	case KVM_SET_MSRS:
-		r = msr_io(vcpu, argp, do_set_msr, 0);
-		break;
-	case KVM_TPR_ACCESS_REPORTING: {
-		struct kvm_tpr_access_ctl tac;
+	kvm_lapic_set_vapic_addr(vcpu, va->vapic_addr);
+	return 0;
+}
 
-		r = -EFAULT;
-		if (copy_from_user(&tac, argp, sizeof tac))
-			goto out;
-		r = vcpu_ioctl_tpr_access_reporting(vcpu, &tac);
-		if (r)
-			goto out;
-		r = -EFAULT;
-		if (copy_to_user(argp, &tac, sizeof tac))
-			goto out;
-		r = 0;
-		break;
-	};
-	case KVM_SET_VAPIC_ADDR: {
-		struct kvm_vapic_addr va;
+static const struct ioctl_handler vcpu_ioctl_handlers[] = {
+	{ KVM_GET_LAPIC, kvm_vcpu_ioctl_get_lapic },
+	{ KVM_SET_LAPIC, kvm_vcpu_ioctl_set_lapic },
+	{ KVM_INTERRUPT, kvm_vcpu_ioctl_interrupt },
+	{ KVM_SET_CPUID, kvm_vcpu_ioctl_set_cpuid },
+	{ KVM_SET_CPUID2, kvm_vcpu_ioctl_set_cpuid2 },
+	{ KVM_GET_CPUID2, kvm_vcpu_ioctl_get_cpuid2 },
+	{ KVM_GET_MSRS, kvm_vcpu_ioctl_get_msrs },
+	{ KVM_SET_MSRS, kvm_vcpu_ioctl_set_msrs },
+	{ KVM_TPR_ACCESS_REPORTING, vcpu_ioctl_tpr_access_reporting },
+	{ KVM_SET_VAPIC_ADDR, vcpu_ioctl_set_vapic_addr },
+	{ }
+};
 
-		r = -EINVAL;
-		if (!irqchip_in_kernel(vcpu->kvm))
-			goto out;
-		r = -EFAULT;
-		if (copy_from_user(&va, argp, sizeof va))
-			goto out;
-		r = 0;
-		kvm_lapic_set_vapic_addr(vcpu, va.vapic_addr);
-		break;
-	}
-	default:
-		r = -EINVAL;
-	}
-out:
-	if (lapic)
-		kfree(lapic);
-	return r;
+long kvm_arch_vcpu_ioctl(struct file *filp,
+			 unsigned int ioctl, unsigned long arg)
+{
+	return dispatch_ioctl_extensible(NULL, filp, ioctl, arg,
+					 vcpu_ioctl_handlers, NULL);
 }
 
 static int kvm_vm_ioctl_set_tss_addr(struct kvm *kvm, unsigned long addr)
-- 
1.6.0.1

