Return-Path: <linux-kernel-owner+w=401wt.eu-S1755967AbYHKRC0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755967AbYHKRC0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2008 13:02:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753481AbYHKRBy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Aug 2008 13:01:54 -0400
Received: from e3.ny.us.ibm.com ([32.97.182.143]:47969 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753092AbYHKRBv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2008 13:01:51 -0400
From: Dave Hansen <dave@linux.vnet.ibm.com>
To: Avi Kivity <avi@argo.co.il>
Cc: kvm-devel <kvm@vger.kernel.org>, linux-kernel@vger.kernel.org,
       Dave Hansen <dave@linux.vnet.ibm.com>
Subject: [PATCH 1/4] reduce kvm stack usage in kvm_arch_vm_ioctl()
Date: Mon, 11 Aug 2008 10:01:45 -0700
Message-Id: <1218474105-14678-1-git-send-email-dave@linux.vnet.ibm.com>
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
   allocation. (There's also a comment on this)

Signed-off-by: Dave Hansen <dave@linux.vnet.ibm.com>
---
 arch/x86/kvm/x86.c |   73 ++++++++++++++++++++++++++++++++-------------------
 1 files changed, 46 insertions(+), 27 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 0d682fc..6f5f8bd 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -1630,6 +1630,15 @@ long kvm_arch_vm_ioctl(struct file *filp,
 	struct kvm *kvm = filp->private_data;
 	void __user *argp = (void __user *)arg;
 	int r = -EINVAL;
+	/*
+	 * This union makes it completely explicit to gcc-3.x
+	 * that these two variables' stack usage should be
+	 * combined, not added together.
+	 */
+	union {
+		struct kvm_pit_state ps;
+		struct kvm_memory_alias alias;
+	} u;
 
 	switch (ioctl) {
 	case KVM_SET_TSS_ADDR:
@@ -1661,17 +1670,14 @@ long kvm_arch_vm_ioctl(struct file *filp,
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
@@ -1713,65 +1719,78 @@ long kvm_arch_vm_ioctl(struct file *filp,
 	}
 	case KVM_GET_IRQCHIP: {
 		/* 0: PIC master, 1: PIC slave, 2: IOAPIC */
-		struct kvm_irqchip chip;
+		struct kvm_irqchip *chip = kmalloc(sizeof(*chip), GFP_KERNEL);
 
-		r = -EFAULT;
-		if (copy_from_user(&chip, argp, sizeof chip))
+		r = -ENOMEM;
+		if (!chip)
 			goto out;
+		r = -EFAULT;
+		if (copy_from_user(chip, argp, sizeof *chip))
+			goto get_irqchip_out;
 		r = -ENXIO;
 		if (!irqchip_in_kernel(kvm))
-			goto out;
-		r = kvm_vm_ioctl_get_irqchip(kvm, &chip);
+			goto get_irqchip_out;
+		r = kvm_vm_ioctl_get_irqchip(kvm, chip);
 		if (r)
-			goto out;
+			goto get_irqchip_out;
 		r = -EFAULT;
-		if (copy_to_user(argp, &chip, sizeof chip))
-			goto out;
+		if (copy_to_user(argp, chip, sizeof *chip))
+			goto get_irqchip_out;
 		r = 0;
+	get_irqchip_out:
+		kfree(chip);
+		if (r)
+			goto out;
 		break;
 	}
 	case KVM_SET_IRQCHIP: {
 		/* 0: PIC master, 1: PIC slave, 2: IOAPIC */
-		struct kvm_irqchip chip;
+		struct kvm_irqchip *chip = kmalloc(sizeof(*chip), GFP_KERNEL);
 
-		r = -EFAULT;
-		if (copy_from_user(&chip, argp, sizeof chip))
+		r = -ENOMEM;
+		if (!chip)
 			goto out;
+		r = -EFAULT;
+		if (copy_from_user(chip, argp, sizeof *chip))
+			goto set_irqchip_out;
 		r = -ENXIO;
 		if (!irqchip_in_kernel(kvm))
-			goto out;
-		r = kvm_vm_ioctl_set_irqchip(kvm, &chip);
+			goto set_irqchip_out;
+		r = kvm_vm_ioctl_set_irqchip(kvm, chip);
 		if (r)
-			goto out;
+			goto set_irqchip_out;
 		r = 0;
+	set_irqchip_out:
+		kfree(chip);
+		if (r)
+			goto out;
 		break;
 	}
+
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

