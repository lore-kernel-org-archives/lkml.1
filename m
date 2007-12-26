Return-Path: <linux-kernel-owner+w=401wt.eu-S1752566AbXLZLJ4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752566AbXLZLJ4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Dec 2007 06:09:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752501AbXLZLG0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Dec 2007 06:06:26 -0500
Received: from il.qumranet.com ([82.166.9.18]:50471 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751631AbXLZLGE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Dec 2007 06:06:04 -0500
From: Avi Kivity <avi@qumranet.com>
To: linux-kernel@vger.kernel.org, kvm-devel@lists.sourceforge.net
Cc: Izik Eidus <izike@qumranet.com>
Subject: [PATCH 10/55] KVM: Add ioctl to tss address from userspace,
Date: Wed, 26 Dec 2007 13:05:15 +0200
Message-Id: <1198667160-22953-11-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.3.7
In-Reply-To: <1198667160-22953-1-git-send-email-avi@qumranet.com>
References: <1198667160-22953-1-git-send-email-avi@qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Izik Eidus <izike@qumranet.com>

Currently kvm has a wart in that it requires three extra pages for use
as a tss when emulating real mode on Intel.  This patch moves the allocation
internally, only requiring userspace to tell us where in the physical address
space we can place the tss.

Signed-off-by: Izik Eidus <izike@qumranet.com>
Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 drivers/kvm/kvm.h      |    3 +++
 drivers/kvm/kvm_main.c |   16 ++++++++++++++++
 drivers/kvm/svm.c      |    7 +++++++
 drivers/kvm/vmx.c      |   27 +++++++++++++++++++++++++--
 include/linux/kvm.h    |    2 ++
 5 files changed, 53 insertions(+), 2 deletions(-)

diff --git a/drivers/kvm/kvm.h b/drivers/kvm/kvm.h
index 82c3b13..3d07d9b 100644
--- a/drivers/kvm/kvm.h
+++ b/drivers/kvm/kvm.h
@@ -382,6 +382,7 @@ struct kvm {
 	struct kvm_pic *vpic;
 	struct kvm_ioapic *vioapic;
 	int round_robin_prev_vcpu;
+	unsigned int tss_addr;
 };
 
 static inline struct kvm_pic *pic_irqchip(struct kvm *kvm)
@@ -467,6 +468,8 @@ struct kvm_x86_ops {
 	void (*inject_pending_irq)(struct kvm_vcpu *vcpu);
 	void (*inject_pending_vectors)(struct kvm_vcpu *vcpu,
 				       struct kvm_run *run);
+
+	int (*set_tss_addr)(struct kvm *kvm, unsigned int addr);
 };
 
 extern struct kvm_x86_ops *kvm_x86_ops;
diff --git a/drivers/kvm/kvm_main.c b/drivers/kvm/kvm_main.c
index bc8334b..26a6399 100644
--- a/drivers/kvm/kvm_main.c
+++ b/drivers/kvm/kvm_main.c
@@ -2661,6 +2661,16 @@ static int create_vcpu_fd(struct kvm_vcpu *vcpu)
 	return fd;
 }
 
+static int kvm_vm_ioctl_set_tss_addr(struct kvm *kvm, unsigned long addr)
+{
+	int ret;
+
+	if (addr > (unsigned int)(-3 * PAGE_SIZE))
+		return -1;
+	ret = kvm_x86_ops->set_tss_addr(kvm, addr);
+	return ret;
+}
+
 /*
  * Creates some virtual cpus.  Good luck creating more than one.
  */
@@ -2957,6 +2967,11 @@ static long kvm_vm_ioctl(struct file *filp,
 	int r = -EINVAL;
 
 	switch (ioctl) {
+	case KVM_SET_TSS_ADDR:
+		r = kvm_vm_ioctl_set_tss_addr(kvm, arg);
+		if (r < 0)
+			goto out;
+		break;
 	case KVM_CREATE_VCPU:
 		r = kvm_vm_ioctl_create_vcpu(kvm, arg);
 		if (r < 0)
@@ -3183,6 +3198,7 @@ static long kvm_dev_ioctl(struct file *filp,
 		case KVM_CAP_HLT:
 		case KVM_CAP_MMU_SHADOW_CACHE_CONTROL:
 		case KVM_CAP_USER_MEMORY:
+		case KVM_CAP_SET_TSS_ADDR:
 			r = 1;
 			break;
 		default:
diff --git a/drivers/kvm/svm.c b/drivers/kvm/svm.c
index 4a70168..56d1ad6 100644
--- a/drivers/kvm/svm.c
+++ b/drivers/kvm/svm.c
@@ -1439,6 +1439,11 @@ static void do_interrupt_requests(struct kvm_vcpu *vcpu,
 		control->intercept &= ~(1ULL << INTERCEPT_VINTR);
 }
 
+static int svm_set_tss_addr(struct kvm *kvm, unsigned int addr)
+{
+	return 0;
+}
+
 static void save_db_regs(unsigned long *db_regs)
 {
 	asm volatile ("mov %%dr0, %0" : "=r"(db_regs[0]));
@@ -1744,6 +1749,8 @@ static struct kvm_x86_ops svm_x86_ops = {
 	.set_irq = svm_set_irq,
 	.inject_pending_irq = svm_intr_assist,
 	.inject_pending_vectors = do_interrupt_requests,
+
+	.set_tss_addr = svm_set_tss_addr,
 };
 
 static int __init svm_init(void)
diff --git a/drivers/kvm/vmx.c b/drivers/kvm/vmx.c
index 77083e4..50c151e 100644
--- a/drivers/kvm/vmx.c
+++ b/drivers/kvm/vmx.c
@@ -1105,8 +1105,12 @@ static void enter_pmode(struct kvm_vcpu *vcpu)
 
 static gva_t rmode_tss_base(struct kvm *kvm)
 {
-	gfn_t base_gfn = kvm->memslots[0].base_gfn + kvm->memslots[0].npages - 3;
-	return base_gfn << PAGE_SHIFT;
+	if (!kvm->tss_addr) {
+		gfn_t base_gfn = kvm->memslots[0].base_gfn +
+				 kvm->memslots[0].npages - 3;
+		return base_gfn << PAGE_SHIFT;
+	}
+	return kvm->tss_addr;
 }
 
 static void fix_rmode_seg(int seg, struct kvm_save_segment *save)
@@ -1735,6 +1739,23 @@ static void do_interrupt_requests(struct kvm_vcpu *vcpu,
 	vmcs_write32(CPU_BASED_VM_EXEC_CONTROL, cpu_based_vm_exec_control);
 }
 
+static int vmx_set_tss_addr(struct kvm *kvm, unsigned int addr)
+{
+	int ret;
+	struct kvm_userspace_memory_region tss_mem = {
+		.slot = 8,
+		.guest_phys_addr = addr,
+		.memory_size = PAGE_SIZE * 3,
+		.flags = 0,
+	};
+
+	ret = kvm_set_memory_region(kvm, &tss_mem, 0);
+	if (ret)
+		return ret;
+	kvm->tss_addr = addr;
+	return 0;
+}
+
 static void kvm_guest_debug_pre(struct kvm_vcpu *vcpu)
 {
 	struct kvm_guest_debug *dbg = &vcpu->guest_debug;
@@ -2543,6 +2564,8 @@ static struct kvm_x86_ops vmx_x86_ops = {
 	.set_irq = vmx_inject_irq,
 	.inject_pending_irq = vmx_intr_assist,
 	.inject_pending_vectors = do_interrupt_requests,
+
+	.set_tss_addr = vmx_set_tss_addr,
 };
 
 static int __init vmx_init(void)
diff --git a/include/linux/kvm.h b/include/linux/kvm.h
index 971f465..71d33d6 100644
--- a/include/linux/kvm.h
+++ b/include/linux/kvm.h
@@ -358,6 +358,7 @@ struct kvm_signal_mask {
 #define KVM_CAP_HLT	  1
 #define KVM_CAP_MMU_SHADOW_CACHE_CONTROL 2
 #define KVM_CAP_USER_MEMORY 3
+#define KVM_CAP_SET_TSS_ADDR 4
 
 /*
  * ioctls for VM fds
@@ -367,6 +368,7 @@ struct kvm_signal_mask {
 #define KVM_GET_NR_MMU_PAGES      _IO(KVMIO, 0x45)
 #define KVM_SET_USER_MEMORY_REGION _IOW(KVMIO, 0x46,\
 					struct kvm_userspace_memory_region)
+#define KVM_SET_TSS_ADDR          _IO(KVMIO, 0x47)
 /*
  * KVM_CREATE_VCPU receives as a parameter the vcpu slot, and returns
  * a vcpu fd.
-- 
1.5.3.7

