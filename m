Return-Path: <linux-kernel-owner+w=401wt.eu-S1759061AbYDUKeA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759061AbYDUKeA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2008 06:34:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756565AbYDUKaS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Apr 2008 06:30:18 -0400
Received: from bzq-179-150-194.static.bezeqint.net ([212.179.150.194]:37896
	"EHLO il.qumranet.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755350AbYDUKaC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2008 06:30:02 -0400
From: Avi Kivity <avi@qumranet.com>
To: kvm-devel@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org, Marcelo Tosatti <mtosatti@redhat.com>
Subject: [PATCH 11/31] KVM: hlt emulation should take in-kernel APIC/PIT timers into account
Date: Mon, 21 Apr 2008 13:29:37 +0300
Message-Id: <1208773797-7829-12-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.5
In-Reply-To: <1208773797-7829-1-git-send-email-avi@qumranet.com>
References: <1208773797-7829-1-git-send-email-avi@qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Marcelo Tosatti <mtosatti@redhat.com>

Timers that fire between guest hlt and vcpu_block's add_wait_queue() are
ignored, possibly resulting in hangs.

Also make sure that atomic_inc and waitqueue_active tests happen in the
specified order, otherwise the following race is open:

CPU0                                        CPU1
                                            if (waitqueue_active(wq))
add_wait_queue()
if (!atomic_read(pit_timer->pending))
    schedule()
                                            atomic_inc(pit_timer->pending)

Signed-off-by: Marcelo Tosatti <mtosatti@redhat.com>
Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 arch/ia64/kvm/kvm-ia64.c  |    5 +++++
 arch/s390/kvm/interrupt.c |    5 +++++
 arch/x86/kvm/i8254.c      |   11 +++++++++++
 arch/x86/kvm/irq.c        |   15 +++++++++++++++
 arch/x86/kvm/irq.h        |    3 +++
 arch/x86/kvm/lapic.c      |   10 ++++++++++
 include/linux/kvm_host.h  |    1 +
 virt/kvm/kvm_main.c       |    1 +
 8 files changed, 51 insertions(+), 0 deletions(-)

diff --git a/arch/ia64/kvm/kvm-ia64.c b/arch/ia64/kvm/kvm-ia64.c
index 9c56b64..ca1cfb1 100644
--- a/arch/ia64/kvm/kvm-ia64.c
+++ b/arch/ia64/kvm/kvm-ia64.c
@@ -1778,6 +1778,11 @@ int kvm_cpu_has_interrupt(struct kvm_vcpu *vcpu)
 	return 0;
 }
 
+int kvm_cpu_has_pending_timer(struct kvm_vcpu *vcpu)
+{
+	return 0;
+}
+
 gfn_t unalias_gfn(struct kvm *kvm, gfn_t gfn)
 {
 	return gfn;
diff --git a/arch/s390/kvm/interrupt.c b/arch/s390/kvm/interrupt.c
index f62588c..fcd1ed8 100644
--- a/arch/s390/kvm/interrupt.c
+++ b/arch/s390/kvm/interrupt.c
@@ -325,6 +325,11 @@ int kvm_cpu_has_interrupt(struct kvm_vcpu *vcpu)
 	return rc;
 }
 
+int kvm_cpu_has_pending_timer(struct kvm_vcpu *vcpu)
+{
+	return 0;
+}
+
 int kvm_s390_handle_wait(struct kvm_vcpu *vcpu)
 {
 	u64 now, sltime;
diff --git a/arch/x86/kvm/i8254.c b/arch/x86/kvm/i8254.c
index 06a241a..abb4b16 100644
--- a/arch/x86/kvm/i8254.c
+++ b/arch/x86/kvm/i8254.c
@@ -199,6 +199,7 @@ int __pit_timer_fn(struct kvm_kpit_state *ps)
 	struct kvm_kpit_timer *pt = &ps->pit_timer;
 
 	atomic_inc(&pt->pending);
+	smp_mb__after_atomic_inc();
 	if (vcpu0 && waitqueue_active(&vcpu0->wq)) {
 		vcpu0->arch.mp_state = VCPU_MP_STATE_RUNNABLE;
 		wake_up_interruptible(&vcpu0->wq);
@@ -210,6 +211,16 @@ int __pit_timer_fn(struct kvm_kpit_state *ps)
 	return (pt->period == 0 ? 0 : 1);
 }
 
+int pit_has_pending_timer(struct kvm_vcpu *vcpu)
+{
+	struct kvm_pit *pit = vcpu->kvm->arch.vpit;
+
+	if (pit && vcpu->vcpu_id == 0)
+		return atomic_read(&pit->pit_state.pit_timer.pending);
+
+	return 0;
+}
+
 static enum hrtimer_restart pit_timer_fn(struct hrtimer *data)
 {
 	struct kvm_kpit_state *ps;
diff --git a/arch/x86/kvm/irq.c b/arch/x86/kvm/irq.c
index dbfe21c..ce1f583 100644
--- a/arch/x86/kvm/irq.c
+++ b/arch/x86/kvm/irq.c
@@ -26,6 +26,21 @@
 #include "i8254.h"
 
 /*
+ * check if there are pending timer events
+ * to be processed.
+ */
+int kvm_cpu_has_pending_timer(struct kvm_vcpu *vcpu)
+{
+	int ret;
+
+	ret = pit_has_pending_timer(vcpu);
+	ret |= apic_has_pending_timer(vcpu);
+
+	return ret;
+}
+EXPORT_SYMBOL(kvm_cpu_has_pending_timer);
+
+/*
  * check if there is pending interrupt without
  * intack.
  */
diff --git a/arch/x86/kvm/irq.h b/arch/x86/kvm/irq.h
index fa5ed5d..1802134 100644
--- a/arch/x86/kvm/irq.h
+++ b/arch/x86/kvm/irq.h
@@ -85,4 +85,7 @@ void kvm_inject_pending_timer_irqs(struct kvm_vcpu *vcpu);
 void kvm_inject_apic_timer_irqs(struct kvm_vcpu *vcpu);
 void __kvm_migrate_apic_timer(struct kvm_vcpu *vcpu);
 
+int pit_has_pending_timer(struct kvm_vcpu *vcpu);
+int apic_has_pending_timer(struct kvm_vcpu *vcpu);
+
 #endif
diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index 31280df..debf582 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -952,6 +952,16 @@ static int __apic_timer_fn(struct kvm_lapic *apic)
 	return result;
 }
 
+int apic_has_pending_timer(struct kvm_vcpu *vcpu)
+{
+	struct kvm_lapic *lapic = vcpu->arch.apic;
+
+	if (lapic)
+		return atomic_read(&lapic->timer.pending);
+
+	return 0;
+}
+
 static int __inject_apic_timer_irq(struct kvm_lapic *apic)
 {
 	int vector;
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index bd0c2d2..0bc4003 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -269,6 +269,7 @@ void kvm_arch_destroy_vm(struct kvm *kvm);
 
 int kvm_cpu_get_interrupt(struct kvm_vcpu *v);
 int kvm_cpu_has_interrupt(struct kvm_vcpu *v);
+int kvm_cpu_has_pending_timer(struct kvm_vcpu *vcpu);
 void kvm_vcpu_kick(struct kvm_vcpu *vcpu);
 
 static inline void kvm_guest_enter(void)
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index d5911d9..47cbc6e 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -765,6 +765,7 @@ void kvm_vcpu_block(struct kvm_vcpu *vcpu)
 	 * We will block until either an interrupt or a signal wakes us up
 	 */
 	while (!kvm_cpu_has_interrupt(vcpu)
+	       && !kvm_cpu_has_pending_timer(vcpu)
 	       && !signal_pending(current)
 	       && !kvm_arch_vcpu_runnable(vcpu)) {
 		set_current_state(TASK_INTERRUPTIBLE);
-- 
1.5.5

