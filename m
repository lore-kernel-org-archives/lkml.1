Return-Path: <linux-kernel-owner+w=401wt.eu-S1755284AbXIQIox@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755284AbXIQIox (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2007 04:44:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754793AbXIQIc7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Sep 2007 04:32:59 -0400
Received: from il.qumranet.com ([82.166.9.18]:45291 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754396AbXIQIcc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2007 04:32:32 -0400
From: Avi Kivity <avi@qumranet.com>
To: kvm-devel@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org, Eddie Dong <eddie.dong@intel.com>
Subject: [PATCH 068/104] KVM: Emulate hlt in the kernel
Date: Mon, 17 Sep 2007 10:31:50 +0200
Message-Id: <11900179482723-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.3
In-Reply-To: <11900179463203-git-send-email-avi@qumranet.com>
References: <11900179463203-git-send-email-avi@qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Eddie Dong <eddie.dong@intel.com>

By sleeping in the kernel when hlt is executed, we simplify the in-kernel
guest interrupt path considerably.

Signed-off-by: Gregory Haskins <ghaskins@novell.com>
Signed-off-by: Yaozu (Eddie) Dong <eddie.dong@intel.com>
Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 drivers/kvm/i8259.c    |    3 +++
 drivers/kvm/irq.c      |    4 ++++
 drivers/kvm/kvm.h      |    2 ++
 drivers/kvm/kvm_main.c |   41 +++++++++++++++++++++++++++++++++++------
 drivers/kvm/svm.c      |    9 ++++++---
 drivers/kvm/vmx.c      |    8 ++++++--
 include/linux/kvm.h    |    1 +
 7 files changed, 57 insertions(+), 11 deletions(-)

diff --git a/drivers/kvm/i8259.c b/drivers/kvm/i8259.c
index 40ad104..ee6030d 100644
--- a/drivers/kvm/i8259.c
+++ b/drivers/kvm/i8259.c
@@ -413,8 +413,11 @@ static void picdev_read(struct kvm_io_device *this,
 static void pic_irq_request(void *opaque, int level)
 {
 	struct kvm *kvm = opaque;
+	struct kvm_vcpu *vcpu = kvm->vcpus[0];
 
 	pic_irqchip(kvm)->output = level;
+	if (vcpu)
+		kvm_vcpu_kick(vcpu);
 }
 
 struct kvm_pic *kvm_create_pic(struct kvm *kvm)
diff --git a/drivers/kvm/irq.c b/drivers/kvm/irq.c
index 5265f82..e09cd65 100644
--- a/drivers/kvm/irq.c
+++ b/drivers/kvm/irq.c
@@ -70,6 +70,10 @@ void kvm_vcpu_kick(struct kvm_vcpu *vcpu)
 {
 	int ipi_pcpu = vcpu->cpu;
 
+	if (waitqueue_active(&vcpu->wq)) {
+		wake_up_interruptible(&vcpu->wq);
+		++vcpu->stat.halt_wakeup;
+	}
 	if (vcpu->guest_mode)
 		smp_call_function_single(ipi_pcpu, vcpu_kick_intr, vcpu, 0, 0);
 }
diff --git a/drivers/kvm/kvm.h b/drivers/kvm/kvm.h
index 0a11b0f..f69b482 100644
--- a/drivers/kvm/kvm.h
+++ b/drivers/kvm/kvm.h
@@ -231,6 +231,7 @@ struct kvm_stat {
 	u32 signal_exits;
 	u32 irq_window_exits;
 	u32 halt_exits;
+	u32 halt_wakeup;
 	u32 request_irq_exits;
 	u32 irq_exits;
 	u32 light_exits;
@@ -353,6 +354,7 @@ struct kvm_vcpu {
 	gva_t mmio_fault_cr2;
 	struct kvm_pio_request pio;
 	void *pio_data;
+	wait_queue_head_t wq;
 
 	int sigset_active;
 	sigset_t sigset;
diff --git a/drivers/kvm/kvm_main.c b/drivers/kvm/kvm_main.c
index ffbdadd..4384364 100644
--- a/drivers/kvm/kvm_main.c
+++ b/drivers/kvm/kvm_main.c
@@ -76,6 +76,7 @@ static struct kvm_stats_debugfs_item {
 	{ "signal_exits", STAT_OFFSET(signal_exits) },
 	{ "irq_window", STAT_OFFSET(irq_window_exits) },
 	{ "halt_exits", STAT_OFFSET(halt_exits) },
+	{ "halt_wakeup", STAT_OFFSET(halt_wakeup) },
 	{ "request_irq", STAT_OFFSET(request_irq_exits) },
 	{ "irq_exits", STAT_OFFSET(irq_exits) },
 	{ "light_exits", STAT_OFFSET(light_exits) },
@@ -248,6 +249,7 @@ int kvm_vcpu_init(struct kvm_vcpu *vcpu, struct kvm *kvm, unsigned id)
 	vcpu->mmu.root_hpa = INVALID_PAGE;
 	vcpu->kvm = kvm;
 	vcpu->vcpu_id = id;
+	init_waitqueue_head(&vcpu->wq);
 
 	page = alloc_page(GFP_KERNEL | __GFP_ZERO);
 	if (!page) {
@@ -1307,15 +1309,41 @@ int emulate_instruction(struct kvm_vcpu *vcpu,
 }
 EXPORT_SYMBOL_GPL(emulate_instruction);
 
-int kvm_emulate_halt(struct kvm_vcpu *vcpu)
+/*
+ * The vCPU has executed a HLT instruction with in-kernel mode enabled.
+ */
+static void kvm_vcpu_kernel_halt(struct kvm_vcpu *vcpu)
 {
-	if (vcpu->irq_summary ||
-		(irqchip_in_kernel(vcpu->kvm) && kvm_cpu_has_interrupt(vcpu)))
-		return 1;
+	DECLARE_WAITQUEUE(wait, current);
+
+	add_wait_queue(&vcpu->wq, &wait);
+
+	/*
+	 * We will block until either an interrupt or a signal wakes us up
+	 */
+	while(!(irqchip_in_kernel(vcpu->kvm) && kvm_cpu_has_interrupt(vcpu))
+	      && !vcpu->irq_summary
+	      && !signal_pending(current)) {
+		set_current_state(TASK_INTERRUPTIBLE);
+		vcpu_put(vcpu);
+		schedule();
+		vcpu_load(vcpu);
+	}
 
-	vcpu->run->exit_reason = KVM_EXIT_HLT;
+	remove_wait_queue(&vcpu->wq, &wait);
+	set_current_state(TASK_RUNNING);
+}
+
+int kvm_emulate_halt(struct kvm_vcpu *vcpu)
+{
 	++vcpu->stat.halt_exits;
-	return 0;
+	if (irqchip_in_kernel(vcpu->kvm)) {
+		kvm_vcpu_kernel_halt(vcpu);
+		return 1;
+	} else {
+		vcpu->run->exit_reason = KVM_EXIT_HLT;
+		return 0;
+	}
 }
 EXPORT_SYMBOL_GPL(kvm_emulate_halt);
 
@@ -2916,6 +2944,7 @@ static long kvm_dev_ioctl(struct file *filp,
 
 		switch (ext) {
 		case KVM_CAP_IRQCHIP:
+		case KVM_CAP_HLT:
 			r = 1;
 			break;
 		default:
diff --git a/drivers/kvm/svm.c b/drivers/kvm/svm.c
index d576451..a347b61 100644
--- a/drivers/kvm/svm.c
+++ b/drivers/kvm/svm.c
@@ -1398,9 +1398,12 @@ static void do_interrupt_requests(struct vcpu_svm *svm,
 static void post_kvm_run_save(struct vcpu_svm *svm,
 			      struct kvm_run *kvm_run)
 {
-	kvm_run->ready_for_interrupt_injection
-		= (svm->vcpu.interrupt_window_open &&
-		   svm->vcpu.irq_summary == 0);
+	if (irqchip_in_kernel(svm->vcpu.kvm))
+		kvm_run->ready_for_interrupt_injection = 1;
+	else
+		kvm_run->ready_for_interrupt_injection =
+					 (svm->vcpu.interrupt_window_open &&
+					  svm->vcpu.irq_summary == 0);
 	kvm_run->if_flag = (svm->vmcb->save.rflags & X86_EFLAGS_IF) != 0;
 	kvm_run->cr8 = get_cr8(&svm->vcpu);
 	kvm_run->apic_base = kvm_get_apic_base(&svm->vcpu);
diff --git a/drivers/kvm/vmx.c b/drivers/kvm/vmx.c
index c4cc17c..7ec8cf8 100644
--- a/drivers/kvm/vmx.c
+++ b/drivers/kvm/vmx.c
@@ -1961,8 +1961,12 @@ static void post_kvm_run_save(struct kvm_vcpu *vcpu,
 	kvm_run->if_flag = (vmcs_readl(GUEST_RFLAGS) & X86_EFLAGS_IF) != 0;
 	kvm_run->cr8 = get_cr8(vcpu);
 	kvm_run->apic_base = kvm_get_apic_base(vcpu);
-	kvm_run->ready_for_interrupt_injection = (vcpu->interrupt_window_open &&
-						  vcpu->irq_summary == 0);
+	if (irqchip_in_kernel(vcpu->kvm))
+		kvm_run->ready_for_interrupt_injection = 1;
+	else
+		kvm_run->ready_for_interrupt_injection =
+					(vcpu->interrupt_window_open &&
+					 vcpu->irq_summary == 0);
 }
 
 static int handle_interrupt_window(struct kvm_vcpu *vcpu,
diff --git a/include/linux/kvm.h b/include/linux/kvm.h
index 997bb3e..b0a13d1 100644
--- a/include/linux/kvm.h
+++ b/include/linux/kvm.h
@@ -283,6 +283,7 @@ struct kvm_signal_mask {
  * Extension capability list.
  */
 #define KVM_CAP_IRQCHIP	  0
+#define KVM_CAP_HLT	  1
 
 /*
  * ioctls for VM fds
-- 
1.5.3

