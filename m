Return-Path: <linux-kernel-owner+w=401wt.eu-S1755525AbXIQIuA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755525AbXIQIuA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2007 04:50:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754838AbXIQIdT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Sep 2007 04:33:19 -0400
Received: from il.qumranet.com ([82.166.9.18]:45296 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754497AbXIQIce (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2007 04:32:34 -0400
From: Avi Kivity <avi@qumranet.com>
To: kvm-devel@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org, Eddie Dong <eddie.dong@intel.com>
Subject: [PATCH 076/104] KVM: Keep track of missed timer irq injections
Date: Mon, 17 Sep 2007 10:31:58 +0200
Message-Id: <1190017949608-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.3
In-Reply-To: <11900179463203-git-send-email-avi@qumranet.com>
References: <11900179463203-git-send-email-avi@qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Eddie Dong <eddie.dong@intel.com>

APIC timer IRQ is set every time when a certain period
expires at host time, but the guest may be descheduled
at that time and thus the irq be overwritten by later fire.
This patch keep track of firing irq numbers and decrease
only when the IRQ is injected to guest or buffered in
APIC.

Signed-off-by: Yaozu (Eddie) Dong <Eddie.Dong@intel.com>
Signed-off-by: Qing He <qing.he@intel.com>
Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 drivers/kvm/irq.c      |   13 ++++++++++
 drivers/kvm/irq.h      |    4 +++
 drivers/kvm/kvm_main.c |    2 +
 drivers/kvm/lapic.c    |   58 +++++++++++++++++++++++++++++++----------------
 drivers/kvm/svm.c      |    7 ++++-
 drivers/kvm/vmx.c      |   10 +++++--
 6 files changed, 69 insertions(+), 25 deletions(-)

diff --git a/drivers/kvm/irq.c b/drivers/kvm/irq.c
index e09cd65..b88e501 100644
--- a/drivers/kvm/irq.c
+++ b/drivers/kvm/irq.c
@@ -78,3 +78,16 @@ void kvm_vcpu_kick(struct kvm_vcpu *vcpu)
 		smp_call_function_single(ipi_pcpu, vcpu_kick_intr, vcpu, 0, 0);
 }
 
+void kvm_inject_pending_timer_irqs(struct kvm_vcpu *vcpu)
+{
+	kvm_inject_apic_timer_irqs(vcpu);
+	/* TODO: PIT, RTC etc. */
+}
+EXPORT_SYMBOL_GPL(kvm_inject_pending_timer_irqs);
+
+void kvm_timer_intr_post(struct kvm_vcpu *vcpu, int vec)
+{
+	kvm_apic_timer_intr_post(vcpu, vec);
+	/* TODO: PIT, RTC etc. */
+}
+EXPORT_SYMBOL_GPL(kvm_timer_intr_post);
diff --git a/drivers/kvm/irq.h b/drivers/kvm/irq.h
index 07035e8..87baf7e 100644
--- a/drivers/kvm/irq.h
+++ b/drivers/kvm/irq.h
@@ -154,5 +154,9 @@ int kvm_ioapic_init(struct kvm *kvm);
 void kvm_ioapic_set_irq(struct kvm_ioapic *ioapic, int irq, int level);
 int kvm_lapic_enabled(struct kvm_vcpu *vcpu);
 int kvm_lapic_find_highest_irr(struct kvm_vcpu *vcpu);
+void kvm_apic_timer_intr_post(struct kvm_vcpu *vcpu, int vec);
+void kvm_timer_intr_post(struct kvm_vcpu *vcpu, int vec);
+void kvm_inject_pending_timer_irqs(struct kvm_vcpu *vcpu);
+void kvm_inject_apic_timer_irqs(struct kvm_vcpu *vcpu);
 
 #endif
diff --git a/drivers/kvm/kvm_main.c b/drivers/kvm/kvm_main.c
index 5092a59..f4cbd4f 100644
--- a/drivers/kvm/kvm_main.c
+++ b/drivers/kvm/kvm_main.c
@@ -283,6 +283,8 @@ EXPORT_SYMBOL_GPL(kvm_vcpu_init);
 void kvm_vcpu_uninit(struct kvm_vcpu *vcpu)
 {
 	kvm_mmu_destroy(vcpu);
+	if (vcpu->apic)
+		hrtimer_cancel(&vcpu->apic->timer.dev);
 	kvm_free_apic(vcpu->apic);
 	free_page((unsigned long)vcpu->pio_data);
 	free_page((unsigned long)vcpu->run);
diff --git a/drivers/kvm/lapic.c b/drivers/kvm/lapic.c
index 68bbbb3..490d493 100644
--- a/drivers/kvm/lapic.c
+++ b/drivers/kvm/lapic.c
@@ -313,6 +313,7 @@ static int __apic_accept_irq(struct kvm_lapic *apic, int delivery_mode,
 			     int vector, int level, int trig_mode)
 {
 	int result = 0;
+	int orig_irr;
 
 	switch (delivery_mode) {
 	case APIC_DM_FIXED:
@@ -321,7 +322,8 @@ static int __apic_accept_irq(struct kvm_lapic *apic, int delivery_mode,
 		if (unlikely(!apic_enabled(apic)))
 			break;
 
-		if (apic_test_and_set_irr(vector, apic) && trig_mode) {
+		orig_irr = apic_test_and_set_irr(vector, apic);
+		if (orig_irr && trig_mode) {
 			apic_debug("level trig mode repeatedly for vector %d",
 				   vector);
 			break;
@@ -335,7 +337,7 @@ static int __apic_accept_irq(struct kvm_lapic *apic, int delivery_mode,
 
 		kvm_vcpu_kick(apic->vcpu);
 
-		result = 1;
+		result = (orig_irr == 0);
 		break;
 
 	case APIC_DM_REMRD:
@@ -831,38 +833,33 @@ EXPORT_SYMBOL_GPL(kvm_lapic_enabled);
  * timer interface
  *----------------------------------------------------------------------
  */
+
+/* TODO: make sure __apic_timer_fn runs in current pCPU */
 static int __apic_timer_fn(struct kvm_lapic *apic)
 {
-	u32 vector;
 	int result = 0;
+	wait_queue_head_t *q = &apic->vcpu->wq;
 
-	if (unlikely(!apic_enabled(apic) ||
-		     !apic_lvt_enabled(apic, APIC_LVTT))) {
-		apic_debug("%s: time interrupt although apic is down\n",
-			   __FUNCTION__);
-		return 0;
-	}
-
-	vector = apic_lvt_vector(apic, APIC_LVTT);
-	apic->timer.last_update = apic->timer.dev.expires;
 	atomic_inc(&apic->timer.pending);
-	__apic_accept_irq(apic, APIC_DM_FIXED, vector, 1, 0);
-
+	if (waitqueue_active(q))
+		wake_up_interruptible(q);
 	if (apic_lvtt_period(apic)) {
-		u32 offset;
-		u32 tmict = apic_get_reg(apic, APIC_TMICT);
-
-		offset = APIC_BUS_CYCLE_NS * apic->timer.divide_count * tmict;
-
 		result = 1;
 		apic->timer.dev.expires = ktime_add_ns(
 					apic->timer.dev.expires,
 					apic->timer.period);
 	}
-
 	return result;
 }
 
+static int __inject_apic_timer_irq(struct kvm_lapic *apic)
+{
+	int vector;
+
+	vector = apic_lvt_vector(apic, APIC_LVTT);
+	return __apic_accept_irq(apic, APIC_DM_FIXED, vector, 1, 0);
+}
+
 static enum hrtimer_restart apic_timer_fn(struct hrtimer *data)
 {
 	struct kvm_lapic *apic;
@@ -935,6 +932,27 @@ int kvm_apic_has_interrupt(struct kvm_vcpu *vcpu)
 	return highest_irr;
 }
 
+void kvm_inject_apic_timer_irqs(struct kvm_vcpu *vcpu)
+{
+	struct kvm_lapic *apic = vcpu->apic;
+
+	if (apic && apic_lvt_enabled(apic, APIC_LVTT) &&
+		atomic_read(&apic->timer.pending) > 0) {
+		if (__inject_apic_timer_irq(apic))
+			atomic_dec(&apic->timer.pending);
+	}
+}
+
+void kvm_apic_timer_intr_post(struct kvm_vcpu *vcpu, int vec)
+{
+	struct kvm_lapic *apic = vcpu->apic;
+
+	if (apic && apic_lvt_vector(apic, APIC_LVTT) == vec)
+		apic->timer.last_update = ktime_add_ns(
+				apic->timer.last_update,
+				apic->timer.period);
+}
+
 int kvm_get_apic_interrupt(struct kvm_vcpu *vcpu)
 {
 	int vector = kvm_apic_has_interrupt(vcpu);
diff --git a/drivers/kvm/svm.c b/drivers/kvm/svm.c
index c8cd242..00119ec 100644
--- a/drivers/kvm/svm.c
+++ b/drivers/kvm/svm.c
@@ -1331,7 +1331,9 @@ static void svm_intr_assist(struct vcpu_svm *svm)
 {
 	struct vmcb *vmcb = svm->vmcb;
 	int intr_vector = -1;
+	struct kvm_vcpu *vcpu = &svm->vcpu;
 
+	kvm_inject_pending_timer_irqs(vcpu);
 	if ((vmcb->control.exit_int_info & SVM_EVTINJ_VALID) &&
 	    ((vmcb->control.exit_int_info & SVM_EVTINJ_TYPE_MASK) == 0)) {
 		intr_vector = vmcb->control.exit_int_info &
@@ -1344,7 +1346,7 @@ static void svm_intr_assist(struct vcpu_svm *svm)
 	if (vmcb->control.int_ctl & V_IRQ_MASK)
 		return;
 
-	if (!kvm_cpu_has_interrupt(&svm->vcpu))
+	if (!kvm_cpu_has_interrupt(vcpu))
 		return;
 
 	if (!(vmcb->save.rflags & X86_EFLAGS_IF) ||
@@ -1356,8 +1358,9 @@ static void svm_intr_assist(struct vcpu_svm *svm)
 		return;
 	}
 	/* Okay, we can deliver the interrupt: grab it and update PIC state. */
-	intr_vector = kvm_cpu_get_interrupt(&svm->vcpu);
+	intr_vector = kvm_cpu_get_interrupt(vcpu);
 	svm_inject_irq(svm, intr_vector);
+	kvm_timer_intr_post(vcpu, intr_vector);
 }
 
 static void kvm_reput_irq(struct vcpu_svm *svm)
diff --git a/drivers/kvm/vmx.c b/drivers/kvm/vmx.c
index 5c2c6e7..eeecadf 100644
--- a/drivers/kvm/vmx.c
+++ b/drivers/kvm/vmx.c
@@ -2151,7 +2151,9 @@ static void vmx_intr_assist(struct kvm_vcpu *vcpu)
 {
 	u32 idtv_info_field, intr_info_field;
 	int has_ext_irq, interrupt_window_open;
+	int vector;
 
+	kvm_inject_pending_timer_irqs(vcpu);
 	update_tpr_threshold(vcpu);
 
 	has_ext_irq = kvm_cpu_has_interrupt(vcpu);
@@ -2183,9 +2185,11 @@ static void vmx_intr_assist(struct kvm_vcpu *vcpu)
 	interrupt_window_open =
 		((vmcs_readl(GUEST_RFLAGS) & X86_EFLAGS_IF) &&
 		 (vmcs_read32(GUEST_INTERRUPTIBILITY_INFO) & 3) == 0);
-	if (interrupt_window_open)
-		vmx_inject_irq(vcpu, kvm_cpu_get_interrupt(vcpu));
-	else
+	if (interrupt_window_open) {
+		vector = kvm_cpu_get_interrupt(vcpu);
+		vmx_inject_irq(vcpu, vector);
+		kvm_timer_intr_post(vcpu, vector);
+	} else
 		enable_irq_window(vcpu);
 }
 
-- 
1.5.3

