Return-Path: <linux-kernel-owner+w=401wt.eu-S1757926AbYDUKep@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757926AbYDUKep (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2008 06:34:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756598AbYDUKaU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Apr 2008 06:30:20 -0400
Received: from bzq-179-150-194.static.bezeqint.net ([212.179.150.194]:37897
	"EHLO il.qumranet.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755405AbYDUKaC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2008 06:30:02 -0400
From: Avi Kivity <avi@qumranet.com>
To: kvm-devel@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 12/31] KVM: Rename VCPU_MP_STATE_* to KVM_MP_STATE_*
Date: Mon, 21 Apr 2008 13:29:38 +0300
Message-Id: <1208773797-7829-13-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.5
In-Reply-To: <1208773797-7829-1-git-send-email-avi@qumranet.com>
References: <1208773797-7829-1-git-send-email-avi@qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We wish to export it to userspace, so move it into the kvm namespace.

Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 arch/ia64/kvm/kvm-ia64.c    |   26 +++++++++++++-------------
 arch/x86/kvm/i8254.c        |    2 +-
 arch/x86/kvm/lapic.c        |   16 ++++++++--------
 arch/x86/kvm/x86.c          |   18 +++++++++---------
 include/asm-ia64/kvm_host.h |    8 ++++----
 include/asm-x86/kvm_host.h  |   10 +++++-----
 6 files changed, 40 insertions(+), 40 deletions(-)

diff --git a/arch/ia64/kvm/kvm-ia64.c b/arch/ia64/kvm/kvm-ia64.c
index ca1cfb1..f7589db 100644
--- a/arch/ia64/kvm/kvm-ia64.c
+++ b/arch/ia64/kvm/kvm-ia64.c
@@ -340,7 +340,7 @@ static int handle_ipi(struct kvm_vcpu *vcpu, struct kvm_run *kvm_run)
 		regs->cr_iip = vcpu->kvm->arch.rdv_sal_data.boot_ip;
 		regs->r1 = vcpu->kvm->arch.rdv_sal_data.boot_gp;
 
-		target_vcpu->arch.mp_state = VCPU_MP_STATE_RUNNABLE;
+		target_vcpu->arch.mp_state = KVM_MP_STATE_RUNNABLE;
 		if (waitqueue_active(&target_vcpu->wq))
 			wake_up_interruptible(&target_vcpu->wq);
 	} else {
@@ -386,7 +386,7 @@ static int handle_global_purge(struct kvm_vcpu *vcpu, struct kvm_run *kvm_run)
 
 	for (i = 0; i < KVM_MAX_VCPUS; i++) {
 		if (!kvm->vcpus[i] || kvm->vcpus[i]->arch.mp_state ==
-						VCPU_MP_STATE_UNINITIALIZED ||
+						KVM_MP_STATE_UNINITIALIZED ||
 					vcpu == kvm->vcpus[i])
 			continue;
 
@@ -437,12 +437,12 @@ int kvm_emulate_halt(struct kvm_vcpu *vcpu)
 	hrtimer_start(p_ht, kt, HRTIMER_MODE_ABS);
 
 	if (irqchip_in_kernel(vcpu->kvm)) {
-		vcpu->arch.mp_state = VCPU_MP_STATE_HALTED;
+		vcpu->arch.mp_state = KVM_MP_STATE_HALTED;
 		kvm_vcpu_block(vcpu);
 		hrtimer_cancel(p_ht);
 		vcpu->arch.ht_active = 0;
 
-		if (vcpu->arch.mp_state != VCPU_MP_STATE_RUNNABLE)
+		if (vcpu->arch.mp_state != KVM_MP_STATE_RUNNABLE)
 			return -EINTR;
 		return 1;
 	} else {
@@ -668,7 +668,7 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu, struct kvm_run *kvm_run)
 
 	vcpu_load(vcpu);
 
-	if (unlikely(vcpu->arch.mp_state == VCPU_MP_STATE_UNINITIALIZED)) {
+	if (unlikely(vcpu->arch.mp_state == KVM_MP_STATE_UNINITIALIZED)) {
 		kvm_vcpu_block(vcpu);
 		vcpu_put(vcpu);
 		return -EAGAIN;
@@ -1127,12 +1127,12 @@ static enum hrtimer_restart hlt_timer_fn(struct hrtimer *data)
 	wait_queue_head_t *q;
 
 	vcpu  = container_of(data, struct kvm_vcpu, arch.hlt_timer);
-	if (vcpu->arch.mp_state != VCPU_MP_STATE_HALTED)
+	if (vcpu->arch.mp_state != KVM_MP_STATE_HALTED)
 		goto out;
 
 	q = &vcpu->wq;
 	if (waitqueue_active(q)) {
-		vcpu->arch.mp_state = VCPU_MP_STATE_RUNNABLE;
+		vcpu->arch.mp_state = KVM_MP_STATE_RUNNABLE;
 		wake_up_interruptible(q);
 	}
 out:
@@ -1159,7 +1159,7 @@ int kvm_arch_vcpu_init(struct kvm_vcpu *vcpu)
 		return PTR_ERR(vmm_vcpu);
 
 	if (vcpu->vcpu_id == 0) {
-		vcpu->arch.mp_state = VCPU_MP_STATE_RUNNABLE;
+		vcpu->arch.mp_state = KVM_MP_STATE_RUNNABLE;
 
 		/*Set entry address for first run.*/
 		regs->cr_iip = PALE_RESET_ENTRY;
@@ -1172,7 +1172,7 @@ int kvm_arch_vcpu_init(struct kvm_vcpu *vcpu)
 			v->arch.last_itc = 0;
 		}
 	} else
-		vcpu->arch.mp_state = VCPU_MP_STATE_UNINITIALIZED;
+		vcpu->arch.mp_state = KVM_MP_STATE_UNINITIALIZED;
 
 	r = -ENOMEM;
 	vcpu->arch.apic = kzalloc(sizeof(struct kvm_lapic), GFP_KERNEL);
@@ -1704,10 +1704,10 @@ int kvm_apic_set_irq(struct kvm_vcpu *vcpu, u8 vec, u8 trig)
 
 	if (!test_and_set_bit(vec, &vpd->irr[0])) {
 		vcpu->arch.irq_new_pending = 1;
-		 if (vcpu->arch.mp_state == VCPU_MP_STATE_RUNNABLE)
+		 if (vcpu->arch.mp_state == KVM_MP_STATE_RUNNABLE)
 			kvm_vcpu_kick(vcpu);
-		else if (vcpu->arch.mp_state == VCPU_MP_STATE_HALTED) {
-			vcpu->arch.mp_state = VCPU_MP_STATE_RUNNABLE;
+		else if (vcpu->arch.mp_state == KVM_MP_STATE_HALTED) {
+			vcpu->arch.mp_state = KVM_MP_STATE_RUNNABLE;
 			if (waitqueue_active(&vcpu->wq))
 				wake_up_interruptible(&vcpu->wq);
 		}
@@ -1790,5 +1790,5 @@ gfn_t unalias_gfn(struct kvm *kvm, gfn_t gfn)
 
 int kvm_arch_vcpu_runnable(struct kvm_vcpu *vcpu)
 {
-	return vcpu->arch.mp_state == VCPU_MP_STATE_RUNNABLE;
+	return vcpu->arch.mp_state == KVM_MP_STATE_RUNNABLE;
 }
diff --git a/arch/x86/kvm/i8254.c b/arch/x86/kvm/i8254.c
index abb4b16..2852dd1 100644
--- a/arch/x86/kvm/i8254.c
+++ b/arch/x86/kvm/i8254.c
@@ -201,7 +201,7 @@ int __pit_timer_fn(struct kvm_kpit_state *ps)
 	atomic_inc(&pt->pending);
 	smp_mb__after_atomic_inc();
 	if (vcpu0 && waitqueue_active(&vcpu0->wq)) {
-		vcpu0->arch.mp_state = VCPU_MP_STATE_RUNNABLE;
+		vcpu0->arch.mp_state = KVM_MP_STATE_RUNNABLE;
 		wake_up_interruptible(&vcpu0->wq);
 	}
 
diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index debf582..2ccf994 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -338,10 +338,10 @@ static int __apic_accept_irq(struct kvm_lapic *apic, int delivery_mode,
 		} else
 			apic_clear_vector(vector, apic->regs + APIC_TMR);
 
-		if (vcpu->arch.mp_state == VCPU_MP_STATE_RUNNABLE)
+		if (vcpu->arch.mp_state == KVM_MP_STATE_RUNNABLE)
 			kvm_vcpu_kick(vcpu);
-		else if (vcpu->arch.mp_state == VCPU_MP_STATE_HALTED) {
-			vcpu->arch.mp_state = VCPU_MP_STATE_RUNNABLE;
+		else if (vcpu->arch.mp_state == KVM_MP_STATE_HALTED) {
+			vcpu->arch.mp_state = KVM_MP_STATE_RUNNABLE;
 			if (waitqueue_active(&vcpu->wq))
 				wake_up_interruptible(&vcpu->wq);
 		}
@@ -362,11 +362,11 @@ static int __apic_accept_irq(struct kvm_lapic *apic, int delivery_mode,
 
 	case APIC_DM_INIT:
 		if (level) {
-			if (vcpu->arch.mp_state == VCPU_MP_STATE_RUNNABLE)
+			if (vcpu->arch.mp_state == KVM_MP_STATE_RUNNABLE)
 				printk(KERN_DEBUG
 				       "INIT on a runnable vcpu %d\n",
 				       vcpu->vcpu_id);
-			vcpu->arch.mp_state = VCPU_MP_STATE_INIT_RECEIVED;
+			vcpu->arch.mp_state = KVM_MP_STATE_INIT_RECEIVED;
 			kvm_vcpu_kick(vcpu);
 		} else {
 			printk(KERN_DEBUG
@@ -379,9 +379,9 @@ static int __apic_accept_irq(struct kvm_lapic *apic, int delivery_mode,
 	case APIC_DM_STARTUP:
 		printk(KERN_DEBUG "SIPI to vcpu %d vector 0x%02x\n",
 		       vcpu->vcpu_id, vector);
-		if (vcpu->arch.mp_state == VCPU_MP_STATE_INIT_RECEIVED) {
+		if (vcpu->arch.mp_state == KVM_MP_STATE_INIT_RECEIVED) {
 			vcpu->arch.sipi_vector = vector;
-			vcpu->arch.mp_state = VCPU_MP_STATE_SIPI_RECEIVED;
+			vcpu->arch.mp_state = KVM_MP_STATE_SIPI_RECEIVED;
 			if (waitqueue_active(&vcpu->wq))
 				wake_up_interruptible(&vcpu->wq);
 		}
@@ -940,7 +940,7 @@ static int __apic_timer_fn(struct kvm_lapic *apic)
 
 	atomic_inc(&apic->timer.pending);
 	if (waitqueue_active(q)) {
-		apic->vcpu->arch.mp_state = VCPU_MP_STATE_RUNNABLE;
+		apic->vcpu->arch.mp_state = KVM_MP_STATE_RUNNABLE;
 		wake_up_interruptible(q);
 	}
 	if (apic_lvtt_period(apic)) {
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index f070f0a..b364d19 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -2433,11 +2433,11 @@ int kvm_emulate_halt(struct kvm_vcpu *vcpu)
 	++vcpu->stat.halt_exits;
 	KVMTRACE_0D(HLT, vcpu, handler);
 	if (irqchip_in_kernel(vcpu->kvm)) {
-		vcpu->arch.mp_state = VCPU_MP_STATE_HALTED;
+		vcpu->arch.mp_state = KVM_MP_STATE_HALTED;
 		up_read(&vcpu->kvm->slots_lock);
 		kvm_vcpu_block(vcpu);
 		down_read(&vcpu->kvm->slots_lock);
-		if (vcpu->arch.mp_state != VCPU_MP_STATE_RUNNABLE)
+		if (vcpu->arch.mp_state != KVM_MP_STATE_RUNNABLE)
 			return -EINTR;
 		return 1;
 	} else {
@@ -2726,14 +2726,14 @@ static int __vcpu_run(struct kvm_vcpu *vcpu, struct kvm_run *kvm_run)
 {
 	int r;
 
-	if (unlikely(vcpu->arch.mp_state == VCPU_MP_STATE_SIPI_RECEIVED)) {
+	if (unlikely(vcpu->arch.mp_state == KVM_MP_STATE_SIPI_RECEIVED)) {
 		pr_debug("vcpu %d received sipi with vector # %x\n",
 		       vcpu->vcpu_id, vcpu->arch.sipi_vector);
 		kvm_lapic_reset(vcpu);
 		r = kvm_x86_ops->vcpu_reset(vcpu);
 		if (r)
 			return r;
-		vcpu->arch.mp_state = VCPU_MP_STATE_RUNNABLE;
+		vcpu->arch.mp_state = KVM_MP_STATE_RUNNABLE;
 	}
 
 	down_read(&vcpu->kvm->slots_lock);
@@ -2891,7 +2891,7 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu, struct kvm_run *kvm_run)
 
 	vcpu_load(vcpu);
 
-	if (unlikely(vcpu->arch.mp_state == VCPU_MP_STATE_UNINITIALIZED)) {
+	if (unlikely(vcpu->arch.mp_state == KVM_MP_STATE_UNINITIALIZED)) {
 		kvm_vcpu_block(vcpu);
 		vcpu_put(vcpu);
 		return -EAGAIN;
@@ -3794,9 +3794,9 @@ int kvm_arch_vcpu_init(struct kvm_vcpu *vcpu)
 
 	vcpu->arch.mmu.root_hpa = INVALID_PAGE;
 	if (!irqchip_in_kernel(kvm) || vcpu->vcpu_id == 0)
-		vcpu->arch.mp_state = VCPU_MP_STATE_RUNNABLE;
+		vcpu->arch.mp_state = KVM_MP_STATE_RUNNABLE;
 	else
-		vcpu->arch.mp_state = VCPU_MP_STATE_UNINITIALIZED;
+		vcpu->arch.mp_state = KVM_MP_STATE_UNINITIALIZED;
 
 	page = alloc_page(GFP_KERNEL | __GFP_ZERO);
 	if (!page) {
@@ -3936,8 +3936,8 @@ int kvm_arch_set_memory_region(struct kvm *kvm,
 
 int kvm_arch_vcpu_runnable(struct kvm_vcpu *vcpu)
 {
-	return vcpu->arch.mp_state == VCPU_MP_STATE_RUNNABLE
-	       || vcpu->arch.mp_state == VCPU_MP_STATE_SIPI_RECEIVED;
+	return vcpu->arch.mp_state == KVM_MP_STATE_RUNNABLE
+	       || vcpu->arch.mp_state == KVM_MP_STATE_SIPI_RECEIVED;
 }
 
 static void vcpu_kick_intr(void *info)
diff --git a/include/asm-ia64/kvm_host.h b/include/asm-ia64/kvm_host.h
index d6d6e15..c082c20 100644
--- a/include/asm-ia64/kvm_host.h
+++ b/include/asm-ia64/kvm_host.h
@@ -318,10 +318,10 @@ struct kvm_vcpu_arch {
 	int vmm_tr_slot;
 	int vm_tr_slot;
 
-#define VCPU_MP_STATE_RUNNABLE          0
-#define VCPU_MP_STATE_UNINITIALIZED     1
-#define VCPU_MP_STATE_INIT_RECEIVED     2
-#define VCPU_MP_STATE_HALTED            3
+#define KVM_MP_STATE_RUNNABLE          0
+#define KVM_MP_STATE_UNINITIALIZED     1
+#define KVM_MP_STATE_INIT_RECEIVED     2
+#define KVM_MP_STATE_HALTED            3
 	int mp_state;
 
 #define MAX_PTC_G_NUM			3
diff --git a/include/asm-x86/kvm_host.h b/include/asm-x86/kvm_host.h
index 15169cb..f35a6ad 100644
--- a/include/asm-x86/kvm_host.h
+++ b/include/asm-x86/kvm_host.h
@@ -227,11 +227,11 @@ struct kvm_vcpu_arch {
 	u64 shadow_efer;
 	u64 apic_base;
 	struct kvm_lapic *apic;    /* kernel irqchip context */
-#define VCPU_MP_STATE_RUNNABLE          0
-#define VCPU_MP_STATE_UNINITIALIZED     1
-#define VCPU_MP_STATE_INIT_RECEIVED     2
-#define VCPU_MP_STATE_SIPI_RECEIVED     3
-#define VCPU_MP_STATE_HALTED            4
+#define KVM_MP_STATE_RUNNABLE          0
+#define KVM_MP_STATE_UNINITIALIZED     1
+#define KVM_MP_STATE_INIT_RECEIVED     2
+#define KVM_MP_STATE_SIPI_RECEIVED     3
+#define KVM_MP_STATE_HALTED            4
 	int mp_state;
 	int sipi_vector;
 	u64 ia32_misc_enable_msr;
-- 
1.5.5

