Return-Path: <linux-kernel-owner+w=401wt.eu-S1758721AbZEXP6q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758721AbZEXP6q (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 May 2009 11:58:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758816AbZEXPyH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 May 2009 11:54:07 -0400
Received: from mx2.redhat.com ([66.187.237.31]:41839 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754409AbZEXPud (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 May 2009 11:50:33 -0400
From: Avi Kivity <avi@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: kvm@vger.kernel.org
Subject: [PATCH 22/45] KVM: use smp_send_reschedule in kvm_vcpu_kick
Date: Sun, 24 May 2009 18:50:07 +0300
Message-Id: <1243180230-2480-23-git-send-email-avi@redhat.com>
In-Reply-To: <1243180230-2480-1-git-send-email-avi@redhat.com>
References: <1243180230-2480-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Marcelo Tosatti <mtosatti@redhat.com>

KVM uses a function call IPI to cause the exit of a guest running on a
physical cpu. For virtual interrupt notification there is no need to
wait on IPI receival, or to execute any function.

This is exactly what the reschedule IPI does, without the overhead
of function IPI. So use it instead of smp_call_function_single in
kvm_vcpu_kick.

Also change the "guest_mode" variable to a bit in vcpu->requests, and
use that to collapse multiple IPI's that would be issued between the
first one and zeroing of guest mode.

This allows kvm_vcpu_kick to called with interrupts disabled.

Signed-off-by: Marcelo Tosatti <mtosatti@redhat.com>
Signed-off-by: Avi Kivity <avi@redhat.com>
---
 arch/ia64/kernel/irq_ia64.c |    3 +++
 arch/ia64/kvm/kvm-ia64.c    |   22 ++++++++--------------
 arch/x86/kernel/smp.c       |    3 +++
 arch/x86/kvm/x86.c          |   36 +++++++++++-------------------------
 include/linux/kvm_host.h    |    2 +-
 5 files changed, 26 insertions(+), 40 deletions(-)

diff --git a/arch/ia64/kernel/irq_ia64.c b/arch/ia64/kernel/irq_ia64.c
index acc4d19..b448197 100644
--- a/arch/ia64/kernel/irq_ia64.c
+++ b/arch/ia64/kernel/irq_ia64.c
@@ -610,6 +610,9 @@ static struct irqaction ipi_irqaction = {
 	.name =		"IPI"
 };
 
+/*
+ * KVM uses this interrupt to force a cpu out of guest mode
+ */
 static struct irqaction resched_irqaction = {
 	.handler =	dummy_handler,
 	.flags =	IRQF_DISABLED,
diff --git a/arch/ia64/kvm/kvm-ia64.c b/arch/ia64/kvm/kvm-ia64.c
index be4413e..80c57b0 100644
--- a/arch/ia64/kvm/kvm-ia64.c
+++ b/arch/ia64/kvm/kvm-ia64.c
@@ -668,7 +668,7 @@ again:
 	host_ctx = kvm_get_host_context(vcpu);
 	guest_ctx = kvm_get_guest_context(vcpu);
 
-	vcpu->guest_mode = 1;
+	clear_bit(KVM_REQ_KICK, &vcpu->requests);
 
 	r = kvm_vcpu_pre_transition(vcpu);
 	if (r < 0)
@@ -685,7 +685,7 @@ again:
 	kvm_vcpu_post_transition(vcpu);
 
 	vcpu->arch.launched = 1;
-	vcpu->guest_mode = 0;
+	set_bit(KVM_REQ_KICK, &vcpu->requests);
 	local_irq_enable();
 
 	/*
@@ -1879,24 +1879,18 @@ void kvm_arch_hardware_unsetup(void)
 {
 }
 
-static void vcpu_kick_intr(void *info)
-{
-#ifdef DEBUG
-	struct kvm_vcpu *vcpu = (struct kvm_vcpu *)info;
-	printk(KERN_DEBUG"vcpu_kick_intr %p \n", vcpu);
-#endif
-}
-
 void kvm_vcpu_kick(struct kvm_vcpu *vcpu)
 {
-	int ipi_pcpu = vcpu->cpu;
-	int cpu = get_cpu();
+	int me;
+	int cpu = vcpu->cpu;
 
 	if (waitqueue_active(&vcpu->wq))
 		wake_up_interruptible(&vcpu->wq);
 
-	if (vcpu->guest_mode && cpu != ipi_pcpu)
-		smp_call_function_single(ipi_pcpu, vcpu_kick_intr, vcpu, 0);
+	me = get_cpu();
+	if (cpu != me && (unsigned) cpu < nr_cpu_ids && cpu_online(cpu))
+		if (!test_and_set_bit(KVM_REQ_KICK, &vcpu->requests))
+			smp_send_reschedule(cpu);
 	put_cpu();
 }
 
diff --git a/arch/x86/kernel/smp.c b/arch/x86/kernel/smp.c
index 13f33ea..3b2e55e 100644
--- a/arch/x86/kernel/smp.c
+++ b/arch/x86/kernel/smp.c
@@ -172,6 +172,9 @@ void smp_reschedule_interrupt(struct pt_regs *regs)
 {
 	ack_APIC_irq();
 	inc_irq_stat(irq_resched_count);
+	/*
+	 * KVM uses this interrupt to force a cpu out of guest mode
+	 */
 }
 
 void smp_call_function_interrupt(struct pt_regs *regs)
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 038ef77..fd0a571 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -3226,6 +3226,9 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu, struct kvm_run *kvm_run)
 
 	local_irq_disable();
 
+	clear_bit(KVM_REQ_KICK, &vcpu->requests);
+	smp_mb__after_clear_bit();
+
 	if (vcpu->requests || need_resched() || signal_pending(current)) {
 		local_irq_enable();
 		preempt_enable();
@@ -3233,13 +3236,6 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu, struct kvm_run *kvm_run)
 		goto out;
 	}
 
-	vcpu->guest_mode = 1;
-	/*
-	 * Make sure that guest_mode assignment won't happen after
-	 * testing the pending IRQ vector bitmap.
-	 */
-	smp_wmb();
-
 	if (vcpu->arch.exception.pending)
 		__queue_exception(vcpu);
 	else
@@ -3284,7 +3280,7 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu, struct kvm_run *kvm_run)
 	set_debugreg(vcpu->arch.host_dr6, 6);
 	set_debugreg(vcpu->arch.host_dr7, 7);
 
-	vcpu->guest_mode = 0;
+	set_bit(KVM_REQ_KICK, &vcpu->requests);
 	local_irq_enable();
 
 	++vcpu->stat.exits;
@@ -4567,30 +4563,20 @@ int kvm_arch_vcpu_runnable(struct kvm_vcpu *vcpu)
 	       || vcpu->arch.nmi_pending;
 }
 
-static void vcpu_kick_intr(void *info)
-{
-#ifdef DEBUG
-	struct kvm_vcpu *vcpu = (struct kvm_vcpu *)info;
-	printk(KERN_DEBUG "vcpu_kick_intr %p \n", vcpu);
-#endif
-}
-
 void kvm_vcpu_kick(struct kvm_vcpu *vcpu)
 {
-	int ipi_pcpu = vcpu->cpu;
-	int cpu;
+	int me;
+	int cpu = vcpu->cpu;
 
 	if (waitqueue_active(&vcpu->wq)) {
 		wake_up_interruptible(&vcpu->wq);
 		++vcpu->stat.halt_wakeup;
 	}
-	/*
-	 * We may be called synchronously with irqs disabled in guest mode,
-	 * So need not to call smp_call_function_single() in that case.
-	 */
-	cpu = get_cpu();
-	if (vcpu->guest_mode && vcpu->cpu != cpu)
-		smp_call_function_single(ipi_pcpu, vcpu_kick_intr, vcpu, 0);
+
+	me = get_cpu();
+	if (cpu != me && (unsigned)cpu < nr_cpu_ids && cpu_online(cpu))
+		if (!test_and_set_bit(KVM_REQ_KICK, &vcpu->requests))
+			smp_send_reschedule(cpu);
 	put_cpu();
 }
 
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index bdce8e1..1618162 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -38,6 +38,7 @@
 #define KVM_REQ_UNHALT             6
 #define KVM_REQ_MMU_SYNC           7
 #define KVM_REQ_KVMCLOCK_UPDATE    8
+#define KVM_REQ_KICK               9
 
 #define KVM_USERSPACE_IRQ_SOURCE_ID	0
 
@@ -72,7 +73,6 @@ struct kvm_vcpu {
 	struct mutex mutex;
 	int   cpu;
 	struct kvm_run *run;
-	int guest_mode;
 	unsigned long requests;
 	unsigned long guest_debug;
 	int fpu_active;
-- 
1.6.0.6

