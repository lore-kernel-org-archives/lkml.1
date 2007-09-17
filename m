Return-Path: <linux-kernel-owner+w=401wt.eu-S1759042AbXIQI5n@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759042AbXIQI5n (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2007 04:57:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754921AbXIQIdm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Sep 2007 04:33:42 -0400
Received: from il.qumranet.com ([82.166.9.18]:45323 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754515AbXIQIce (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2007 04:32:34 -0400
From: Avi Kivity <avi@qumranet.com>
To: kvm-devel@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org, "He, Qing" <qing.he@intel.com>
Subject: [PATCH 081/104] KVM: enable in-kernel APIC INIT/SIPI handling
Date: Mon, 17 Sep 2007 10:32:03 +0200
Message-Id: <11900179492084-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.3
In-Reply-To: <11900179463203-git-send-email-avi@qumranet.com>
References: <11900179463203-git-send-email-avi@qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: He, Qing <qing.he@intel.com>

This patch enables INIT/SIPI handling using in-kernel APIC by
introducing a ->mp_state field to emulate the SMP state transition.

[avi: remove smp_processor_id() warning]

Signed-off-by: Qing He <qing.he@intel.com>
Signed-off-by: Xin Li <xin.b.li@intel.com>
Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 drivers/kvm/irq.h      |    1 +
 drivers/kvm/kvm.h      |    7 +++++++
 drivers/kvm/kvm_main.c |   26 ++++++++++++++++++++------
 drivers/kvm/lapic.c    |   43 ++++++++++++++++++++++++++++++++++++-------
 drivers/kvm/vmx.c      |   24 +++++++++++++++++++++---
 5 files changed, 85 insertions(+), 16 deletions(-)

diff --git a/drivers/kvm/irq.h b/drivers/kvm/irq.h
index ec46a09..11fc014 100644
--- a/drivers/kvm/irq.h
+++ b/drivers/kvm/irq.h
@@ -138,6 +138,7 @@ int kvm_apic_has_interrupt(struct kvm_vcpu *vcpu);
 int kvm_apic_accept_pic_intr(struct kvm_vcpu *vcpu);
 int kvm_get_apic_interrupt(struct kvm_vcpu *vcpu);
 int kvm_create_lapic(struct kvm_vcpu *vcpu);
+void kvm_lapic_reset(struct kvm_vcpu *vcpu);
 void kvm_free_apic(struct kvm_lapic *apic);
 u64 kvm_lapic_get_cr8(struct kvm_vcpu *vcpu);
 void kvm_lapic_set_tpr(struct kvm_vcpu *vcpu, unsigned long cr8);
diff --git a/drivers/kvm/kvm.h b/drivers/kvm/kvm.h
index dbb929d..5e318b6 100644
--- a/drivers/kvm/kvm.h
+++ b/drivers/kvm/kvm.h
@@ -326,6 +326,13 @@ struct kvm_vcpu {
 	u64 shadow_efer;
 	u64 apic_base;
 	struct kvm_lapic *apic;    /* kernel irqchip context */
+#define VCPU_MP_STATE_RUNNABLE          0
+#define VCPU_MP_STATE_UNINITIALIZED     1
+#define VCPU_MP_STATE_INIT_RECEIVED     2
+#define VCPU_MP_STATE_SIPI_RECEIVED     3
+#define VCPU_MP_STATE_HALTED            4
+	int mp_state;
+	int sipi_vector;
 	u64 ia32_misc_enable_msr;
 
 	struct kvm_mmu mmu;
diff --git a/drivers/kvm/kvm_main.c b/drivers/kvm/kvm_main.c
index a25dfc9..f101430 100644
--- a/drivers/kvm/kvm_main.c
+++ b/drivers/kvm/kvm_main.c
@@ -249,6 +249,10 @@ int kvm_vcpu_init(struct kvm_vcpu *vcpu, struct kvm *kvm, unsigned id)
 	vcpu->mmu.root_hpa = INVALID_PAGE;
 	vcpu->kvm = kvm;
 	vcpu->vcpu_id = id;
+	if (!irqchip_in_kernel(kvm) || id == 0)
+		vcpu->mp_state = VCPU_MP_STATE_RUNNABLE;
+	else
+		vcpu->mp_state = VCPU_MP_STATE_UNINITIALIZED;
 	init_waitqueue_head(&vcpu->wq);
 
 	page = alloc_page(GFP_KERNEL | __GFP_ZERO);
@@ -1371,7 +1375,7 @@ EXPORT_SYMBOL_GPL(emulate_instruction);
 /*
  * The vCPU has executed a HLT instruction with in-kernel mode enabled.
  */
-static void kvm_vcpu_kernel_halt(struct kvm_vcpu *vcpu)
+static void kvm_vcpu_block(struct kvm_vcpu *vcpu)
 {
 	DECLARE_WAITQUEUE(wait, current);
 
@@ -1380,24 +1384,28 @@ static void kvm_vcpu_kernel_halt(struct kvm_vcpu *vcpu)
 	/*
 	 * We will block until either an interrupt or a signal wakes us up
 	 */
-	while(!(irqchip_in_kernel(vcpu->kvm) && kvm_cpu_has_interrupt(vcpu))
-	      && !vcpu->irq_summary
-	      && !signal_pending(current)) {
+	while (!kvm_cpu_has_interrupt(vcpu)
+	       && !signal_pending(current)
+	       && vcpu->mp_state != VCPU_MP_STATE_RUNNABLE
+	       && vcpu->mp_state != VCPU_MP_STATE_SIPI_RECEIVED) {
 		set_current_state(TASK_INTERRUPTIBLE);
 		vcpu_put(vcpu);
 		schedule();
 		vcpu_load(vcpu);
 	}
 
+	__set_current_state(TASK_RUNNING);
 	remove_wait_queue(&vcpu->wq, &wait);
-	set_current_state(TASK_RUNNING);
 }
 
 int kvm_emulate_halt(struct kvm_vcpu *vcpu)
 {
 	++vcpu->stat.halt_exits;
 	if (irqchip_in_kernel(vcpu->kvm)) {
-		kvm_vcpu_kernel_halt(vcpu);
+		vcpu->mp_state = VCPU_MP_STATE_HALTED;
+		kvm_vcpu_block(vcpu);
+		if (vcpu->mp_state != VCPU_MP_STATE_RUNNABLE)
+			return -EINTR;
 		return 1;
 	} else {
 		vcpu->run->exit_reason = KVM_EXIT_HLT;
@@ -2001,6 +2009,12 @@ static int kvm_vcpu_ioctl_run(struct kvm_vcpu *vcpu, struct kvm_run *kvm_run)
 
 	vcpu_load(vcpu);
 
+	if (unlikely(vcpu->mp_state == VCPU_MP_STATE_UNINITIALIZED)) {
+		kvm_vcpu_block(vcpu);
+		vcpu_put(vcpu);
+		return -EAGAIN;
+	}
+
 	if (vcpu->sigset_active)
 		sigprocmask(SIG_SETMASK, &vcpu->sigset, &sigsaved);
 
diff --git a/drivers/kvm/lapic.c b/drivers/kvm/lapic.c
index ca1db38..a190587 100644
--- a/drivers/kvm/lapic.c
+++ b/drivers/kvm/lapic.c
@@ -312,8 +312,8 @@ static int apic_match_dest(struct kvm_vcpu *vcpu, struct kvm_lapic *source,
 static int __apic_accept_irq(struct kvm_lapic *apic, int delivery_mode,
 			     int vector, int level, int trig_mode)
 {
-	int result = 0;
-	int orig_irr;
+	int orig_irr, result = 0;
+	struct kvm_vcpu *vcpu = apic->vcpu;
 
 	switch (delivery_mode) {
 	case APIC_DM_FIXED:
@@ -335,7 +335,13 @@ static int __apic_accept_irq(struct kvm_lapic *apic, int delivery_mode,
 		} else
 			apic_clear_vector(vector, apic->regs + APIC_TMR);
 
-		kvm_vcpu_kick(apic->vcpu);
+		if (vcpu->mp_state == VCPU_MP_STATE_RUNNABLE)
+			kvm_vcpu_kick(vcpu);
+		else if (vcpu->mp_state == VCPU_MP_STATE_HALTED) {
+			vcpu->mp_state = VCPU_MP_STATE_RUNNABLE;
+			if (waitqueue_active(&vcpu->wq))
+				wake_up_interruptible(&vcpu->wq);
+		}
 
 		result = (orig_irr == 0);
 		break;
@@ -352,11 +358,30 @@ static int __apic_accept_irq(struct kvm_lapic *apic, int delivery_mode,
 		break;
 
 	case APIC_DM_INIT:
-		printk(KERN_DEBUG "Ignoring guest INIT\n");
+		if (level) {
+			if (vcpu->mp_state == VCPU_MP_STATE_RUNNABLE)
+				printk(KERN_DEBUG
+				       "INIT on a runnable vcpu %d\n",
+				       vcpu->vcpu_id);
+			vcpu->mp_state = VCPU_MP_STATE_INIT_RECEIVED;
+			kvm_vcpu_kick(vcpu);
+		} else {
+			printk(KERN_DEBUG
+			       "Ignoring de-assert INIT to vcpu %d\n",
+			       vcpu->vcpu_id);
+		}
+
 		break;
 
 	case APIC_DM_STARTUP:
-		printk(KERN_DEBUG "Ignoring guest STARTUP\n");
+		printk(KERN_DEBUG "SIPI to vcpu %d vector 0x%02x\n",
+		       vcpu->vcpu_id, vector);
+		if (vcpu->mp_state == VCPU_MP_STATE_INIT_RECEIVED) {
+			vcpu->sipi_vector = vector;
+			vcpu->mp_state = VCPU_MP_STATE_SIPI_RECEIVED;
+			if (waitqueue_active(&vcpu->wq))
+				wake_up_interruptible(&vcpu->wq);
+		}
 		break;
 
 	default:
@@ -792,7 +817,7 @@ u64 kvm_lapic_get_base(struct kvm_vcpu *vcpu)
 }
 EXPORT_SYMBOL_GPL(kvm_lapic_get_base);
 
-static void lapic_reset(struct kvm_vcpu *vcpu)
+void kvm_lapic_reset(struct kvm_vcpu *vcpu)
 {
 	struct kvm_lapic *apic;
 	int i;
@@ -839,6 +864,7 @@ static void lapic_reset(struct kvm_vcpu *vcpu)
 		   vcpu, kvm_apic_id(apic),
 		   vcpu->apic_base, apic->base_address);
 }
+EXPORT_SYMBOL_GPL(kvm_lapic_reset);
 
 int kvm_lapic_enabled(struct kvm_vcpu *vcpu)
 {
@@ -867,7 +893,10 @@ static int __apic_timer_fn(struct kvm_lapic *apic)
 
 	atomic_inc(&apic->timer.pending);
 	if (waitqueue_active(q))
+	{
+		apic->vcpu->mp_state = VCPU_MP_STATE_RUNNABLE;
 		wake_up_interruptible(q);
+	}
 	if (apic_lvtt_period(apic)) {
 		result = 1;
 		apic->timer.dev.expires = ktime_add_ns(
@@ -928,7 +957,7 @@ int kvm_create_lapic(struct kvm_vcpu *vcpu)
 	apic->base_address = APIC_DEFAULT_PHYS_BASE;
 	vcpu->apic_base = APIC_DEFAULT_PHYS_BASE;
 
-	lapic_reset(vcpu);
+	kvm_lapic_reset(vcpu);
 	apic->dev.read = apic_mmio_read;
 	apic->dev.write = apic_mmio_write;
 	apic->dev.in_range = apic_mmio_range;
diff --git a/drivers/kvm/vmx.c b/drivers/kvm/vmx.c
index f4618b9..440cacf 100644
--- a/drivers/kvm/vmx.c
+++ b/drivers/kvm/vmx.c
@@ -1412,6 +1412,8 @@ static int vmx_vcpu_setup(struct vcpu_vmx *vmx)
 		goto out;
 	}
 
+	vmx->vcpu.rmode.active = 0;
+
 	vmx->vcpu.regs[VCPU_REGS_RDX] = get_rdx_init_val();
 	set_cr8(&vmx->vcpu, 0);
 	msr = 0xfee00000 | MSR_IA32_APICBASE_ENABLE;
@@ -1425,8 +1427,13 @@ static int vmx_vcpu_setup(struct vcpu_vmx *vmx)
 	 * GUEST_CS_BASE should really be 0xffff0000, but VT vm86 mode
 	 * insists on having GUEST_CS_BASE == GUEST_CS_SELECTOR << 4.  Sigh.
 	 */
-	vmcs_write16(GUEST_CS_SELECTOR, 0xf000);
-	vmcs_writel(GUEST_CS_BASE, 0x000f0000);
+	if (vmx->vcpu.vcpu_id == 0) {
+		vmcs_write16(GUEST_CS_SELECTOR, 0xf000);
+		vmcs_writel(GUEST_CS_BASE, 0x000f0000);
+	} else {
+		vmcs_write16(GUEST_CS_SELECTOR, vmx->vcpu.sipi_vector << 8);
+		vmcs_writel(GUEST_CS_BASE, vmx->vcpu.sipi_vector << 12);
+	}
 	vmcs_write32(GUEST_CS_LIMIT, 0xffff);
 	vmcs_write32(GUEST_CS_AR_BYTES, 0x9b);
 
@@ -1451,7 +1458,10 @@ static int vmx_vcpu_setup(struct vcpu_vmx *vmx)
 	vmcs_writel(GUEST_SYSENTER_EIP, 0);
 
 	vmcs_writel(GUEST_RFLAGS, 0x02);
-	vmcs_writel(GUEST_RIP, 0xfff0);
+	if (vmx->vcpu.vcpu_id == 0)
+		vmcs_writel(GUEST_RIP, 0xfff0);
+	else
+		vmcs_writel(GUEST_RIP, 0);
 	vmcs_writel(GUEST_RSP, 0);
 
 	//todo: dr0 = dr1 = dr2 = dr3 = 0; dr6 = 0xffff0ff0
@@ -2201,6 +2211,14 @@ static int vmx_vcpu_run(struct kvm_vcpu *vcpu, struct kvm_run *kvm_run)
 	u8 fail;
 	int r;
 
+	if (unlikely(vcpu->mp_state == VCPU_MP_STATE_SIPI_RECEIVED)) {
+		printk("vcpu %d received sipi with vector # %x\n",
+		       vcpu->vcpu_id, vcpu->sipi_vector);
+		kvm_lapic_reset(vcpu);
+		vmx_vcpu_setup(vmx);
+		vcpu->mp_state = VCPU_MP_STATE_RUNNABLE;
+	}
+
 preempted:
 	if (vcpu->guest_debug.enabled)
 		kvm_guest_debug_pre(vcpu);
-- 
1.5.3

