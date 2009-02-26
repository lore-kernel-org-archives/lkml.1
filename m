Return-Path: <linux-kernel-owner+w=401wt.eu-S1759375AbZBZOX4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759375AbZBZOX4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Feb 2009 09:23:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757484AbZBZOQe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Feb 2009 09:16:34 -0500
Received: from mx2.redhat.com ([66.187.237.31]:43092 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754907AbZBZOPm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Feb 2009 09:15:42 -0500
From: Avi Kivity <avi@redhat.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Jes Sorensen <jes@sgi.com>
Subject: [PATCH 17/40] KVM: ia64: stack get/restore patch
Date: Thu, 26 Feb 2009 16:15:07 +0200
Message-Id: <1235657730-27683-18-git-send-email-avi@redhat.com>
In-Reply-To: <1235657730-27683-1-git-send-email-avi@redhat.com>
References: <1235657730-27683-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jes Sorensen <jes@sgi.com>

Implement KVM_IA64_VCPU_[GS]ET_STACK ioctl calls. This is required
for live migrations.

Patch is based on previous implementation that was part of old
GET/SET_REGS ioctl calls.

Signed-off-by: Jes Sorensen <jes@sgi.com>
Signed-off-by: Avi Kivity <avi@redhat.com>
---
 arch/ia64/include/asm/kvm.h      |    7 +++
 arch/ia64/include/asm/kvm_host.h |    6 ++-
 arch/ia64/kvm/kvm-ia64.c         |   92 ++++++++++++++++++++++++++++++++++++-
 include/linux/kvm.h              |    3 +
 4 files changed, 104 insertions(+), 4 deletions(-)

diff --git a/arch/ia64/include/asm/kvm.h b/arch/ia64/include/asm/kvm.h
index be3fdb8..b514578 100644
--- a/arch/ia64/include/asm/kvm.h
+++ b/arch/ia64/include/asm/kvm.h
@@ -214,6 +214,13 @@ struct kvm_sregs {
 struct kvm_fpu {
 };
 
+#define KVM_IA64_VCPU_STACK_SHIFT	16
+#define KVM_IA64_VCPU_STACK_SIZE	(1UL << KVM_IA64_VCPU_STACK_SHIFT)
+
+struct kvm_ia64_vcpu_stack {
+	unsigned char stack[KVM_IA64_VCPU_STACK_SIZE];
+};
+
 struct kvm_debug_exit_arch {
 };
 
diff --git a/arch/ia64/include/asm/kvm_host.h b/arch/ia64/include/asm/kvm_host.h
index 3486636..7da0c09 100644
--- a/arch/ia64/include/asm/kvm_host.h
+++ b/arch/ia64/include/asm/kvm_host.h
@@ -112,7 +112,11 @@
 #define VCPU_STRUCT_SHIFT	16
 #define VCPU_STRUCT_SIZE	(__IA64_UL_CONST(1) << VCPU_STRUCT_SHIFT)
 
-#define KVM_STK_OFFSET		VCPU_STRUCT_SIZE
+/*
+ * This must match KVM_IA64_VCPU_STACK_{SHIFT,SIZE} arch/ia64/include/asm/kvm.h
+ */
+#define KVM_STK_SHIFT		16
+#define KVM_STK_OFFSET		(__IA64_UL_CONST(1)<< KVM_STK_SHIFT)
 
 #define KVM_VM_STRUCT_SHIFT	19
 #define KVM_VM_STRUCT_SIZE	(__IA64_UL_CONST(1) << KVM_VM_STRUCT_SHIFT)
diff --git a/arch/ia64/kvm/kvm-ia64.c b/arch/ia64/kvm/kvm-ia64.c
index de47467..1477f91 100644
--- a/arch/ia64/kvm/kvm-ia64.c
+++ b/arch/ia64/kvm/kvm-ia64.c
@@ -1421,6 +1421,23 @@ int kvm_arch_vcpu_ioctl_get_regs(struct kvm_vcpu *vcpu, struct kvm_regs *regs)
 	return 0;
 }
 
+int kvm_arch_vcpu_ioctl_get_stack(struct kvm_vcpu *vcpu,
+				  struct kvm_ia64_vcpu_stack *stack)
+{
+	memcpy(stack, vcpu, sizeof(struct kvm_ia64_vcpu_stack));
+	return 0;
+}
+
+int kvm_arch_vcpu_ioctl_set_stack(struct kvm_vcpu *vcpu,
+				  struct kvm_ia64_vcpu_stack *stack)
+{
+	memcpy(vcpu + 1, &stack->stack[0] + sizeof(struct kvm_vcpu),
+	       sizeof(struct kvm_ia64_vcpu_stack) - sizeof(struct kvm_vcpu));
+
+	vcpu->arch.exit_data = ((struct kvm_vcpu *)stack)->arch.exit_data;
+	return 0;
+}
+
 void kvm_arch_vcpu_uninit(struct kvm_vcpu *vcpu)
 {
 
@@ -1430,9 +1447,78 @@ void kvm_arch_vcpu_uninit(struct kvm_vcpu *vcpu)
 
 
 long kvm_arch_vcpu_ioctl(struct file *filp,
-		unsigned int ioctl, unsigned long arg)
+			 unsigned int ioctl, unsigned long arg)
 {
-	return -EINVAL;
+	struct kvm_vcpu *vcpu = filp->private_data;
+	void __user *argp = (void __user *)arg;
+	struct kvm_ia64_vcpu_stack *stack = NULL;
+	long r;
+
+	switch (ioctl) {
+	case KVM_IA64_VCPU_GET_STACK: {
+		struct kvm_ia64_vcpu_stack __user *user_stack;
+	        void __user *first_p = argp;
+
+		r = -EFAULT;
+		if (copy_from_user(&user_stack, first_p, sizeof(void *)))
+			goto out;
+
+		if (!access_ok(VERIFY_WRITE, user_stack,
+			       sizeof(struct kvm_ia64_vcpu_stack))) {
+			printk(KERN_INFO "KVM_IA64_VCPU_GET_STACK: "
+			       "Illegal user destination address for stack\n");
+			goto out;
+		}
+		stack = kzalloc(sizeof(struct kvm_ia64_vcpu_stack), GFP_KERNEL);
+		if (!stack) {
+			r = -ENOMEM;
+			goto out;
+		}
+
+		r = kvm_arch_vcpu_ioctl_get_stack(vcpu, stack);
+		if (r)
+			goto out;
+
+		if (copy_to_user(user_stack, stack,
+				 sizeof(struct kvm_ia64_vcpu_stack)))
+			goto out;
+
+		break;
+	}
+	case KVM_IA64_VCPU_SET_STACK: {
+		struct kvm_ia64_vcpu_stack __user *user_stack;
+	        void __user *first_p = argp;
+
+		r = -EFAULT;
+		if (copy_from_user(&user_stack, first_p, sizeof(void *)))
+			goto out;
+
+		if (!access_ok(VERIFY_READ, user_stack,
+			    sizeof(struct kvm_ia64_vcpu_stack))) {
+			printk(KERN_INFO "KVM_IA64_VCPU_SET_STACK: "
+			       "Illegal user address for stack\n");
+			goto out;
+		}
+		stack = kmalloc(sizeof(struct kvm_ia64_vcpu_stack), GFP_KERNEL);
+		if (!stack) {
+			r = -ENOMEM;
+			goto out;
+		}
+		if (copy_from_user(stack, user_stack,
+				   sizeof(struct kvm_ia64_vcpu_stack)))
+			goto out;
+
+		r = kvm_arch_vcpu_ioctl_set_stack(vcpu, stack);
+		break;
+	}
+
+	default:
+		r = -EINVAL;
+	}
+
+out:
+	kfree(stack);
+	return r;
 }
 
 int kvm_arch_set_memory_region(struct kvm *kvm,
@@ -1472,7 +1558,7 @@ void kvm_arch_flush_shadow(struct kvm *kvm)
 }
 
 long kvm_arch_dev_ioctl(struct file *filp,
-		unsigned int ioctl, unsigned long arg)
+			unsigned int ioctl, unsigned long arg)
 {
 	return -EINVAL;
 }
diff --git a/include/linux/kvm.h b/include/linux/kvm.h
index 429a2ce..28582fc 100644
--- a/include/linux/kvm.h
+++ b/include/linux/kvm.h
@@ -489,6 +489,9 @@ struct kvm_debug_guest {
 
 #define __KVM_DEPRECATED_DEBUG_GUEST _IOW(KVMIO,  0x87, struct kvm_debug_guest)
 
+#define KVM_IA64_VCPU_GET_STACK   _IOR(KVMIO,  0x9a, void *)
+#define KVM_IA64_VCPU_SET_STACK   _IOW(KVMIO,  0x9b, void *)
+
 #define KVM_TRC_INJ_VIRQ         (KVM_TRC_HANDLER + 0x02)
 #define KVM_TRC_REDELIVER_EVT    (KVM_TRC_HANDLER + 0x03)
 #define KVM_TRC_PEND_INTR        (KVM_TRC_HANDLER + 0x04)
-- 
1.6.0.6

