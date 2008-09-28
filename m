Return-Path: <linux-kernel-owner+w=401wt.eu-S1755555AbYI1Pxv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755555AbYI1Pxv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Sep 2008 11:53:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752798AbYI1PpY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Sep 2008 11:45:24 -0400
Received: from mx2.redhat.com ([66.187.237.31]:50841 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752108AbYI1PpQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Sep 2008 11:45:16 -0400
From: Avi Kivity <avi@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: kvm@vger.kernel.org, Marcelo Tosatti <mtosatti@redhat.com>
Subject: [PATCH 06/25] KVM: x86: do not execute halted vcpus
Date: Sun, 28 Sep 2008 18:44:42 +0300
Message-Id: <1222616701-1206-7-git-send-email-avi@redhat.com>
In-Reply-To: <1222616701-1206-1-git-send-email-avi@redhat.com>
References: <1222616701-1206-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Marcelo Tosatti <mtosatti@redhat.com>

Offline or uninitialized vcpu's can be executed if requested to perform
userspace work.

Follow Avi's suggestion to handle halted vcpu's in the main loop,
simplifying kvm_emulate_halt(). Introduce a new vcpu->requests bit to
indicate events that promote state from halted to running.

Also standardize vcpu wake sites.

Signed-off-by: Marcelo Tosatti <mtosatti <at> redhat.com>
Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 arch/x86/kvm/i8254.c     |    5 +-
 arch/x86/kvm/lapic.c     |   16 ++------
 arch/x86/kvm/x86.c       |  100 +++++++++++++++++++++++++---------------------
 include/linux/kvm_host.h |    1 +
 virt/kvm/kvm_main.c      |   10 ++--
 5 files changed, 67 insertions(+), 65 deletions(-)

diff --git a/arch/x86/kvm/i8254.c b/arch/x86/kvm/i8254.c
index 4cb4430..634132a 100644
--- a/arch/x86/kvm/i8254.c
+++ b/arch/x86/kvm/i8254.c
@@ -200,10 +200,9 @@ static int __pit_timer_fn(struct kvm_kpit_state *ps)
 
 	if (!atomic_inc_and_test(&pt->pending))
 		set_bit(KVM_REQ_PENDING_TIMER, &vcpu0->requests);
-	if (vcpu0 && waitqueue_active(&vcpu0->wq)) {
-		vcpu0->arch.mp_state = KVM_MP_STATE_RUNNABLE;
+
+	if (vcpu0 && waitqueue_active(&vcpu0->wq))
 		wake_up_interruptible(&vcpu0->wq);
-	}
 
 	pt->timer.expires = ktime_add_ns(pt->timer.expires, pt->period);
 	pt->scheduled = ktime_to_ns(pt->timer.expires);
diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index be94f93..fd00f69 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -339,13 +339,7 @@ static int __apic_accept_irq(struct kvm_lapic *apic, int delivery_mode,
 		} else
 			apic_clear_vector(vector, apic->regs + APIC_TMR);
 
-		if (vcpu->arch.mp_state == KVM_MP_STATE_RUNNABLE)
-			kvm_vcpu_kick(vcpu);
-		else if (vcpu->arch.mp_state == KVM_MP_STATE_HALTED) {
-			vcpu->arch.mp_state = KVM_MP_STATE_RUNNABLE;
-			if (waitqueue_active(&vcpu->wq))
-				wake_up_interruptible(&vcpu->wq);
-		}
+		kvm_vcpu_kick(vcpu);
 
 		result = (orig_irr == 0);
 		break;
@@ -384,8 +378,7 @@ static int __apic_accept_irq(struct kvm_lapic *apic, int delivery_mode,
 		if (vcpu->arch.mp_state == KVM_MP_STATE_INIT_RECEIVED) {
 			vcpu->arch.sipi_vector = vector;
 			vcpu->arch.mp_state = KVM_MP_STATE_SIPI_RECEIVED;
-			if (waitqueue_active(&vcpu->wq))
-				wake_up_interruptible(&vcpu->wq);
+			kvm_vcpu_kick(vcpu);
 		}
 		break;
 
@@ -950,10 +943,9 @@ static int __apic_timer_fn(struct kvm_lapic *apic)
 
 	if(!atomic_inc_and_test(&apic->timer.pending))
 		set_bit(KVM_REQ_PENDING_TIMER, &apic->vcpu->requests);
-	if (waitqueue_active(q)) {
-		apic->vcpu->arch.mp_state = KVM_MP_STATE_RUNNABLE;
+	if (waitqueue_active(q))
 		wake_up_interruptible(q);
-	}
+
 	if (apic_lvtt_period(apic)) {
 		result = 1;
 		apic->timer.dev.expires = ktime_add_ns(
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 3f3cb71..bf98d40 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -2798,11 +2798,6 @@ int kvm_emulate_halt(struct kvm_vcpu *vcpu)
 	KVMTRACE_0D(HLT, vcpu, handler);
 	if (irqchip_in_kernel(vcpu->kvm)) {
 		vcpu->arch.mp_state = KVM_MP_STATE_HALTED;
-		up_read(&vcpu->kvm->slots_lock);
-		kvm_vcpu_block(vcpu);
-		down_read(&vcpu->kvm->slots_lock);
-		if (vcpu->arch.mp_state != KVM_MP_STATE_RUNNABLE)
-			return -EINTR;
 		return 1;
 	} else {
 		vcpu->run->exit_reason = KVM_EXIT_HLT;
@@ -3097,24 +3092,10 @@ static void vapic_exit(struct kvm_vcpu *vcpu)
 	up_read(&vcpu->kvm->slots_lock);
 }
 
-static int __vcpu_run(struct kvm_vcpu *vcpu, struct kvm_run *kvm_run)
+static int vcpu_enter_guest(struct kvm_vcpu *vcpu, struct kvm_run *kvm_run)
 {
 	int r;
 
-	if (unlikely(vcpu->arch.mp_state == KVM_MP_STATE_SIPI_RECEIVED)) {
-		pr_debug("vcpu %d received sipi with vector # %x\n",
-		       vcpu->vcpu_id, vcpu->arch.sipi_vector);
-		kvm_lapic_reset(vcpu);
-		r = kvm_x86_ops->vcpu_reset(vcpu);
-		if (r)
-			return r;
-		vcpu->arch.mp_state = KVM_MP_STATE_RUNNABLE;
-	}
-
-	down_read(&vcpu->kvm->slots_lock);
-	vapic_enter(vcpu);
-
-again:
 	if (vcpu->requests)
 		if (test_and_clear_bit(KVM_REQ_MMU_RELOAD, &vcpu->requests))
 			kvm_mmu_unload(vcpu);
@@ -3151,22 +3132,13 @@ again:
 
 	local_irq_disable();
 
-	if (vcpu->requests || need_resched()) {
+	if (vcpu->requests || need_resched() || signal_pending(current)) {
 		local_irq_enable();
 		preempt_enable();
 		r = 1;
 		goto out;
 	}
 
-	if (signal_pending(current)) {
-		local_irq_enable();
-		preempt_enable();
-		r = -EINTR;
-		kvm_run->exit_reason = KVM_EXIT_INTR;
-		++vcpu->stat.signal_exits;
-		goto out;
-	}
-
 	if (vcpu->guest_debug.enabled)
 		kvm_x86_ops->guest_debug_pre(vcpu);
 
@@ -3227,26 +3199,63 @@ again:
 	kvm_lapic_sync_from_vapic(vcpu);
 
 	r = kvm_x86_ops->handle_exit(kvm_run, vcpu);
+out:
+	return r;
+}
 
-	if (r > 0) {
-		if (dm_request_for_irq_injection(vcpu, kvm_run)) {
-			r = -EINTR;
-			kvm_run->exit_reason = KVM_EXIT_INTR;
-			++vcpu->stat.request_irq_exits;
-			goto out;
-		}
-		if (!need_resched())
-			goto again;
+static int __vcpu_run(struct kvm_vcpu *vcpu, struct kvm_run *kvm_run)
+{
+	int r;
+
+	if (unlikely(vcpu->arch.mp_state == KVM_MP_STATE_SIPI_RECEIVED)) {
+		printk("vcpu %d received sipi with vector # %x\n",
+		       vcpu->vcpu_id, vcpu->arch.sipi_vector);
+		kvm_lapic_reset(vcpu);
+		r = kvm_x86_ops->vcpu_reset(vcpu);
+		if (r)
+			return r;
+		vcpu->arch.mp_state = KVM_MP_STATE_RUNNABLE;
 	}
 
-out:
-	up_read(&vcpu->kvm->slots_lock);
-	if (r > 0) {
-		kvm_resched(vcpu);
-		down_read(&vcpu->kvm->slots_lock);
-		goto again;
+	down_read(&vcpu->kvm->slots_lock);
+	vapic_enter(vcpu);
+
+	r = 1;
+	while (r > 0) {
+		if (kvm_arch_vcpu_runnable(vcpu))
+			r = vcpu_enter_guest(vcpu, kvm_run);
+		else {
+			up_read(&vcpu->kvm->slots_lock);
+			kvm_vcpu_block(vcpu);
+			down_read(&vcpu->kvm->slots_lock);
+			if (test_and_clear_bit(KVM_REQ_UNHALT, &vcpu->requests))
+				if (vcpu->arch.mp_state == KVM_MP_STATE_HALTED)
+					vcpu->arch.mp_state =
+							KVM_MP_STATE_RUNNABLE;
+			if (vcpu->arch.mp_state != KVM_MP_STATE_RUNNABLE)
+				r = -EINTR;
+		}
+
+		if (r > 0) {
+			if (dm_request_for_irq_injection(vcpu, kvm_run)) {
+				r = -EINTR;
+				kvm_run->exit_reason = KVM_EXIT_INTR;
+				++vcpu->stat.request_irq_exits;
+			}
+			if (signal_pending(current)) {
+				r = -EINTR;
+				kvm_run->exit_reason = KVM_EXIT_INTR;
+				++vcpu->stat.signal_exits;
+			}
+			if (need_resched()) {
+				up_read(&vcpu->kvm->slots_lock);
+				kvm_resched(vcpu);
+				down_read(&vcpu->kvm->slots_lock);
+			}
+		}
 	}
 
+	up_read(&vcpu->kvm->slots_lock);
 	post_kvm_run_save(vcpu, kvm_run);
 
 	vapic_exit(vcpu);
@@ -3266,6 +3275,7 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu, struct kvm_run *kvm_run)
 
 	if (unlikely(vcpu->arch.mp_state == KVM_MP_STATE_UNINITIALIZED)) {
 		kvm_vcpu_block(vcpu);
+		clear_bit(KVM_REQ_UNHALT, &vcpu->requests);
 		r = -EAGAIN;
 		goto out;
 	}
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index a18aaad..4b03643 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -34,6 +34,7 @@
 #define KVM_REQ_MMU_RELOAD         3
 #define KVM_REQ_TRIPLE_FAULT       4
 #define KVM_REQ_PENDING_TIMER      5
+#define KVM_REQ_UNHALT             6
 
 struct kvm_vcpu;
 extern struct kmem_cache *kvm_vcpu_cache;
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index de3b029..63e661b 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -980,12 +980,12 @@ void kvm_vcpu_block(struct kvm_vcpu *vcpu)
 	for (;;) {
 		prepare_to_wait(&vcpu->wq, &wait, TASK_INTERRUPTIBLE);
 
-		if (kvm_cpu_has_interrupt(vcpu))
-			break;
-		if (kvm_cpu_has_pending_timer(vcpu))
-			break;
-		if (kvm_arch_vcpu_runnable(vcpu))
+		if (kvm_cpu_has_interrupt(vcpu) ||
+		    kvm_cpu_has_pending_timer(vcpu) ||
+		    kvm_arch_vcpu_runnable(vcpu)) {
+			set_bit(KVM_REQ_UNHALT, &vcpu->requests);
 			break;
+		}
 		if (signal_pending(current))
 			break;
 
-- 
1.6.0.1

