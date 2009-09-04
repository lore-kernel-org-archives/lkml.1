Return-Path: <linux-kernel-owner+w=401wt.eu-S934026AbZIDUVd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934026AbZIDUVd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Sep 2009 16:21:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933990AbZIDUV3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Sep 2009 16:21:29 -0400
Received: from kroah.org ([198.145.64.141]:36146 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933994AbZIDUOV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Sep 2009 16:14:21 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Fri Sep  4 13:08:52 2009
Message-Id: <20090904200852.199656362@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Fri, 04 Sep 2009 13:07:26 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Avi Kivity <avi@redhat.com>, Dave Hansen <dave@linux.vnet.ibm.com>,
       Avi Kivity <avi@qumranet.com>
Subject: [patch 14/48] KVM: Reduce kvm stack usage in kvm_arch_vm_ioctl()
References: <20090904200712.724048145@mini.kroah.org>
Content-Disposition: inline; filename=kvm-reduce-kvm-stack-usage-in-kvm_arch_vm_ioctl.patch
In-Reply-To: <20090904201112.GA8274@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


2.6.27-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Dave Hansen <dave@linux.vnet.ibm.com>

(cherry picked from commit f0d662759a2465babdba1160749c446648c9d159)

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
Signed-off-by: Avi Kivity <avi@qumranet.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 arch/x86/kvm/x86.c |   72 +++++++++++++++++++++++++++++++++--------------------
 1 file changed, 45 insertions(+), 27 deletions(-)

--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -1630,6 +1630,15 @@ long kvm_arch_vm_ioctl(struct file *filp
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
@@ -1661,17 +1670,14 @@ long kvm_arch_vm_ioctl(struct file *filp
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
@@ -1713,65 +1719,77 @@ long kvm_arch_vm_ioctl(struct file *filp
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


