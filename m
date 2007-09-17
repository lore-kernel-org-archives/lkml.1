Return-Path: <linux-kernel-owner+w=401wt.eu-S1759004AbXIQI7G@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759004AbXIQI7G (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2007 04:59:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754953AbXIQIdp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Sep 2007 04:33:45 -0400
Received: from il.qumranet.com ([82.166.9.18]:45258 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754438AbXIQIcd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2007 04:32:33 -0400
From: Avi Kivity <avi@qumranet.com>
To: kvm-devel@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org, Eddie Dong <eddie.dong@intel.com>
Subject: [PATCH 074/104] KVM: pending irq save/restore
Date: Mon, 17 Sep 2007 10:31:56 +0200
Message-Id: <11900179481921-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.3
In-Reply-To: <11900179463203-git-send-email-avi@qumranet.com>
References: <11900179463203-git-send-email-avi@qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Eddie Dong <eddie.dong@intel.com>

Add in kernel irqchip save/restore support for pending vectors.

Signed-off-by: Yaozu (Eddie) Dong <eddie.dong@intel.com>
Signed-off-by: Qing He <qing.he@intel.com>
Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 drivers/kvm/kvm.h      |    2 ++
 drivers/kvm/kvm_main.c |   22 +++++++++++++++++++---
 drivers/kvm/svm.c      |   19 +++++++++++++++++++
 drivers/kvm/vmx.c      |   16 ++++++++++++++++
 4 files changed, 56 insertions(+), 3 deletions(-)

diff --git a/drivers/kvm/kvm.h b/drivers/kvm/kvm.h
index bb506b7..f8fe87d 100644
--- a/drivers/kvm/kvm.h
+++ b/drivers/kvm/kvm.h
@@ -490,6 +490,8 @@ struct kvm_arch_ops {
 	void (*skip_emulated_instruction)(struct kvm_vcpu *vcpu);
 	void (*patch_hypercall)(struct kvm_vcpu *vcpu,
 				unsigned char *hypercall_addr);
+	int (*get_irq)(struct kvm_vcpu *vcpu);
+	void (*set_irq)(struct kvm_vcpu *vcpu, int vec);
 };
 
 extern struct kvm_arch_ops *kvm_arch_ops;
diff --git a/drivers/kvm/kvm_main.c b/drivers/kvm/kvm_main.c
index a012d70..5092a59 100644
--- a/drivers/kvm/kvm_main.c
+++ b/drivers/kvm/kvm_main.c
@@ -2126,6 +2126,7 @@ static int kvm_vcpu_ioctl_get_sregs(struct kvm_vcpu *vcpu,
 				    struct kvm_sregs *sregs)
 {
 	struct descriptor_table dt;
+	int pending_vec;
 
 	vcpu_load(vcpu);
 
@@ -2155,10 +2156,15 @@ static int kvm_vcpu_ioctl_get_sregs(struct kvm_vcpu *vcpu,
 	sregs->efer = vcpu->shadow_efer;
 	sregs->apic_base = kvm_get_apic_base(vcpu);
 
-	if (irqchip_in_kernel(vcpu->kvm))
+	if (irqchip_in_kernel(vcpu->kvm)) {
 		memset(sregs->interrupt_bitmap, 0,
 		       sizeof sregs->interrupt_bitmap);
-	else
+		pending_vec = kvm_arch_ops->get_irq(vcpu);
+		if (pending_vec >= 0) {
+			set_bit(pending_vec, sregs->interrupt_bitmap);
+			printk("pending irq in kernel %d\n",pending_vec);
+		}
+	} else
 		memcpy(sregs->interrupt_bitmap, vcpu->irq_pending,
 		       sizeof sregs->interrupt_bitmap);
 
@@ -2177,7 +2183,7 @@ static int kvm_vcpu_ioctl_set_sregs(struct kvm_vcpu *vcpu,
 				    struct kvm_sregs *sregs)
 {
 	int mmu_reset_needed = 0;
-	int i;
+	int i, pending_vec, max_bits;
 	struct descriptor_table dt;
 
 	vcpu_load(vcpu);
@@ -2221,6 +2227,16 @@ static int kvm_vcpu_ioctl_set_sregs(struct kvm_vcpu *vcpu,
 		for (i = 0; i < ARRAY_SIZE(vcpu->irq_pending); ++i)
 			if (vcpu->irq_pending[i])
 				__set_bit(i, &vcpu->irq_summary);
+	} else {
+		max_bits = (sizeof sregs->interrupt_bitmap) << 3;
+		pending_vec = find_first_bit(
+			(const unsigned long *)sregs->interrupt_bitmap,
+			max_bits);
+		/* Only pending external irq is handled here */
+		if (pending_vec < max_bits) {
+			kvm_arch_ops->set_irq(vcpu, pending_vec);
+			printk("Set back pending irq %d\n", pending_vec);
+		}
 	}
 
 	set_segment(vcpu, &sregs->cs, VCPU_SREG_CS);
diff --git a/drivers/kvm/svm.c b/drivers/kvm/svm.c
index a347b61..c8cd242 100644
--- a/drivers/kvm/svm.c
+++ b/drivers/kvm/svm.c
@@ -843,6 +843,16 @@ static int svm_guest_debug(struct kvm_vcpu *vcpu, struct kvm_debug_guest *dbg)
 	return -EOPNOTSUPP;
 }
 
+static int svm_get_irq(struct kvm_vcpu *vcpu)
+{
+	struct vcpu_svm *svm = to_svm(vcpu);
+	u32 exit_int_info = svm->vmcb->control.exit_int_info;
+
+	if (is_external_interrupt(exit_int_info))
+		return exit_int_info & SVM_EVTINJ_VEC_MASK;
+	return -1;
+}
+
 static void load_host_msrs(struct kvm_vcpu *vcpu)
 {
 #ifdef CONFIG_X86_64
@@ -1310,6 +1320,13 @@ static inline void svm_inject_irq(struct vcpu_svm *svm, int irq)
 		((/*control->int_vector >> 4*/ 0xf) << V_INTR_PRIO_SHIFT);
 }
 
+static void svm_set_irq(struct kvm_vcpu *vcpu, int irq)
+{
+	struct vcpu_svm *svm = to_svm(vcpu);
+
+	svm_inject_irq(svm, irq);
+}
+
 static void svm_intr_assist(struct vcpu_svm *svm)
 {
 	struct vmcb *vmcb = svm->vmcb;
@@ -1783,6 +1800,8 @@ static struct kvm_arch_ops svm_arch_ops = {
 	.run = svm_vcpu_run,
 	.skip_emulated_instruction = skip_emulated_instruction,
 	.patch_hypercall = svm_patch_hypercall,
+	.get_irq = svm_get_irq,
+	.set_irq = svm_set_irq,
 };
 
 static int __init svm_init(void)
diff --git a/drivers/kvm/vmx.c b/drivers/kvm/vmx.c
index 7ec8cf8..6c371ea 100644
--- a/drivers/kvm/vmx.c
+++ b/drivers/kvm/vmx.c
@@ -790,6 +790,20 @@ static int set_guest_debug(struct kvm_vcpu *vcpu, struct kvm_debug_guest *dbg)
 	return 0;
 }
 
+static int vmx_get_irq(struct kvm_vcpu *vcpu)
+{
+	u32 idtv_info_field;
+
+	idtv_info_field = vmcs_read32(IDT_VECTORING_INFO_FIELD);
+	if (idtv_info_field & INTR_INFO_VALID_MASK) {
+		if (is_external_interrupt(idtv_info_field))
+			return idtv_info_field & VECTORING_INFO_VECTOR_MASK;
+		else
+			printk("pending exception: not handled yet\n");
+	}
+	return -1;
+}
+
 static __init int cpu_has_kvm_support(void)
 {
 	unsigned long ecx = cpuid_ecx(1);
@@ -2500,6 +2514,8 @@ static struct kvm_arch_ops vmx_arch_ops = {
 	.run = vmx_vcpu_run,
 	.skip_emulated_instruction = skip_emulated_instruction,
 	.patch_hypercall = vmx_patch_hypercall,
+	.get_irq = vmx_get_irq,
+	.set_irq = vmx_inject_irq,
 };
 
 static int __init vmx_init(void)
-- 
1.5.3

