Return-Path: <linux-kernel-owner+w=401wt.eu-S1759802AbYHDSdB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759802AbYHDSdB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2008 14:33:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759352AbYHDSbz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Aug 2008 14:31:55 -0400
Received: from e32.co.us.ibm.com ([32.97.110.150]:41333 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756540AbYHDSbw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2008 14:31:52 -0400
From: Dave Hansen <dave@linux.vnet.ibm.com>
To: Avi Kivity <avi@argo.co.il>
Cc: kvm-devel <kvm@vger.kernel.org>, Anthony Liguori <aliguori@us.ibm.com>,
       linux-kernel@vger.kernel.org, Dave Hansen <dave@linux.vnet.ibm.com>
Subject: [PATCH 1/4] reduce kvm stack usage in kvm_arch_vm_ioctl()
Date: Mon,  4 Aug 2008 11:31:33 -0700
Message-Id: <1217874693-28398-1-git-send-email-dave@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.6.0.rc1.34.g0fe8c1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On my machine with gcc 3.4, kvm uses ~2k of stack in a few
select functions.  This is mostly because gcc fails to
notice that the different case: statements could have their
stack usage combined.  It overflows very nicely if interrupts
happen during one of these large uses.

This patch uses two methods for reducing stack usage.
1. dynamically allocate large objects instead of putting
   on the stack.
2. Use a union{} member for all of the case variables. This
   tricks gcc into combining them all into a single stack
   allocation.
---
 arch/x86/kvm/x86.c |  116 ++++++++++++++++++++++++++++++++--------------------
 1 files changed, 72 insertions(+), 44 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 0d682fc..9d77da1 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -1624,12 +1624,73 @@ out:
 	return r;
 }
 
+static inline int kvm_arch_vm_irqchip_ioctl(struct kvm *kvm, void *argp,
+					    unsigned int ioctl)
+{
+	int ret = 0;
+	struct kvm_irqchip *chip = kmalloc(sizeof(struct kvm_irqchip), GFP_KERNEL);
+
+	if (!chip)
+		return -ENOMEM;
+
+	/* cheaper than the copy, so do this first */
+	if (!irqchip_in_kernel(kvm)) {
+		ret = -ENXIO;
+		goto out;
+	}
+	if (copy_from_user(chip, argp, sizeof(struct kvm_irqchip))) {
+		ret = -EFAULT;
+		goto out;
+	}
+	switch (ioctl) {
+	case KVM_GET_IRQCHIP:
+		ret = kvm_vm_ioctl_get_irqchip(kvm, chip);
+		if (ret)
+			goto out;
+		ret = copy_to_user(argp, chip, sizeof(struct kvm_irqchip));
+		if (ret) {
+			ret = -EFAULT;
+			goto out;
+		}
+		break;
+	case KVM_SET_IRQCHIP:
+		ret = kvm_vm_ioctl_set_irqchip(kvm, chip);
+		break;
+	default:
+		ret = -EINVAL;
+		break;
+	}
+out:
+	kfree(chip);
+	return ret;
+}
+
+
+static inline int x86_kvm_vm_ioctl_set_memory_region(struct kvm *kvm, void *argp)
+{
+	struct kvm_memory_region kvm_mem;
+	struct kvm_userspace_memory_region kvm_userspace_mem;
+
+	if (copy_from_user(&kvm_mem, argp, sizeof(struct kvm_memory_region)))
+		return -EFAULT;
+	kvm_userspace_mem.slot = kvm_mem.slot;
+	kvm_userspace_mem.flags = kvm_mem.flags;
+	kvm_userspace_mem.guest_phys_addr = kvm_mem.guest_phys_addr;
+	kvm_userspace_mem.memory_size = kvm_mem.memory_size;
+	return kvm_vm_ioctl_set_memory_region(kvm, &kvm_userspace_mem, 0);
+}
+
 long kvm_arch_vm_ioctl(struct file *filp,
 		       unsigned int ioctl, unsigned long arg)
 {
 	struct kvm *kvm = filp->private_data;
 	void __user *argp = (void __user *)arg;
 	int r = -EINVAL;
+	union {
+		/* 0: PIC master, 1: PIC slave, 2: IOAPIC */
+		struct kvm_pit_state ps;
+		struct kvm_memory_alias alias;
+	} u;
 
 	switch (ioctl) {
 	case KVM_SET_TSS_ADDR:
@@ -1661,17 +1722,14 @@ long kvm_arch_vm_ioctl(struct file *filp,
 	case KVM_GET_NR_MMU_PAGES:
 		r = kvm_vm_ioctl_get_nr_mmu_pages(kvm);
 		break;
-	case KVM_SET_MEMORY_ALIAS: {
-		struct kvm_memory_alias alias;
-
+	case KVM_SET_MEMORY_ALIAS:
 		r = -EFAULT;
-		if (copy_from_user(&alias, argp, sizeof alias))
+		if (copy_from_user(&u.alias, argp, sizeof(struct kvm_memory_alias)))
 			goto out;
-		r = kvm_vm_ioctl_set_memory_alias(kvm, &alias);
+		r = kvm_vm_ioctl_set_memory_alias(kvm, &u.alias);
 		if (r)
 			goto out;
 		break;
-	}
 	case KVM_CREATE_IRQCHIP:
 		r = -ENOMEM;
 		kvm->arch.vpic = kvm_create_pic(kvm);
@@ -1711,67 +1769,37 @@ long kvm_arch_vm_ioctl(struct file *filp,
 		}
 		break;
 	}
-	case KVM_GET_IRQCHIP: {
-		/* 0: PIC master, 1: PIC slave, 2: IOAPIC */
-		struct kvm_irqchip chip;
-
-		r = -EFAULT;
-		if (copy_from_user(&chip, argp, sizeof chip))
-			goto out;
-		r = -ENXIO;
-		if (!irqchip_in_kernel(kvm))
-			goto out;
-		r = kvm_vm_ioctl_get_irqchip(kvm, &chip);
-		if (r)
-			goto out;
-		r = -EFAULT;
-		if (copy_to_user(argp, &chip, sizeof chip))
-			goto out;
-		r = 0;
-		break;
-	}
-	case KVM_SET_IRQCHIP: {
-		/* 0: PIC master, 1: PIC slave, 2: IOAPIC */
-		struct kvm_irqchip chip;
-
-		r = -EFAULT;
-		if (copy_from_user(&chip, argp, sizeof chip))
-			goto out;
-		r = -ENXIO;
-		if (!irqchip_in_kernel(kvm))
-			goto out;
-		r = kvm_vm_ioctl_set_irqchip(kvm, &chip);
+	case KVM_GET_IRQCHIP:
+	case KVM_SET_IRQCHIP:
+		r = kvm_arch_vm_irqchip_ioctl(kvm, argp, ioctl);
 		if (r)
 			goto out;
 		r = 0;
 		break;
-	}
 	case KVM_GET_PIT: {
-		struct kvm_pit_state ps;
 		r = -EFAULT;
-		if (copy_from_user(&ps, argp, sizeof ps))
+		if (copy_from_user(&u.ps, argp, sizeof(struct kvm_pit_state)))
 			goto out;
 		r = -ENXIO;
 		if (!kvm->arch.vpit)
 			goto out;
-		r = kvm_vm_ioctl_get_pit(kvm, &ps);
+		r = kvm_vm_ioctl_get_pit(kvm, &u.ps);
 		if (r)
 			goto out;
 		r = -EFAULT;
-		if (copy_to_user(argp, &ps, sizeof ps))
+		if (copy_to_user(argp, &u.ps, sizeof(struct kvm_pit_state)))
 			goto out;
 		r = 0;
 		break;
 	}
 	case KVM_SET_PIT: {
-		struct kvm_pit_state ps;
 		r = -EFAULT;
-		if (copy_from_user(&ps, argp, sizeof ps))
+		if (copy_from_user(&u.ps, argp, sizeof u.ps))
 			goto out;
 		r = -ENXIO;
 		if (!kvm->arch.vpit)
 			goto out;
-		r = kvm_vm_ioctl_set_pit(kvm, &ps);
+		r = kvm_vm_ioctl_set_pit(kvm, &u.ps);
 		if (r)
 			goto out;
 		r = 0;
-- 
1.5.4.3

