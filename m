Return-Path: <linux-kernel-owner+w=401wt.eu-S1758451AbZERJjk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758451AbZERJjk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 May 2009 05:39:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756401AbZERJYx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 May 2009 05:24:53 -0400
Received: from mx2.redhat.com ([66.187.237.31]:38439 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754869AbZERJXM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 May 2009 05:23:12 -0400
From: Avi Kivity <avi@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: kvm@vger.kernel.org
Subject: [PATCH 42/43] KVM: Timer event should not unconditionally unhalt vcpu.
Date: Mon, 18 May 2009 12:23:04 +0300
Message-Id: <1242638585-18470-43-git-send-email-avi@redhat.com>
In-Reply-To: <1242638585-18470-1-git-send-email-avi@redhat.com>
References: <1242638585-18470-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Gleb Natapov <gleb@redhat.com>

Currently timer events are processed before entering guest mode. Move it
to main vcpu event loop since timer events should be processed even while
vcpu is halted.  Timer may cause interrupt/nmi to be injected and only then
vcpu will be unhalted.

Signed-off-by: Gleb Natapov <gleb@redhat.com>
Signed-off-by: Avi Kivity <avi@redhat.com>
---
 arch/ia64/kvm/kvm-ia64.c |    6 ++--
 arch/x86/kvm/x86.c       |   57 +++++++++++++++++++++++++++------------------
 virt/kvm/kvm_main.c      |    5 ++-
 3 files changed, 40 insertions(+), 28 deletions(-)

diff --git a/arch/ia64/kvm/kvm-ia64.c b/arch/ia64/kvm/kvm-ia64.c
index 4623a90..d2a90fd 100644
--- a/arch/ia64/kvm/kvm-ia64.c
+++ b/arch/ia64/kvm/kvm-ia64.c
@@ -488,10 +488,10 @@ int kvm_emulate_halt(struct kvm_vcpu *vcpu)
 		hrtimer_cancel(p_ht);
 		vcpu->arch.ht_active = 0;
 
-		if (test_and_clear_bit(KVM_REQ_UNHALT, &vcpu->requests))
+		if (test_and_clear_bit(KVM_REQ_UNHALT, &vcpu->requests) ||
+				kvm_cpu_has_pending_timer(vcpu))
 			if (vcpu->arch.mp_state == KVM_MP_STATE_HALTED)
-				vcpu->arch.mp_state =
-					KVM_MP_STATE_RUNNABLE;
+				vcpu->arch.mp_state = KVM_MP_STATE_RUNNABLE;
 
 		if (vcpu->arch.mp_state != KVM_MP_STATE_RUNNABLE)
 			return -EINTR;
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 0131b5f..aa8b585 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -3129,9 +3129,6 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu, struct kvm_run *kvm_run)
 		}
 	}
 
-	clear_bit(KVM_REQ_PENDING_TIMER, &vcpu->requests);
-	kvm_inject_pending_timer_irqs(vcpu);
-
 	preempt_disable();
 
 	kvm_x86_ops->prepare_guest_switch(vcpu);
@@ -3231,6 +3228,7 @@ out:
 	return r;
 }
 
+
 static int __vcpu_run(struct kvm_vcpu *vcpu, struct kvm_run *kvm_run)
 {
 	int r;
@@ -3257,29 +3255,42 @@ static int __vcpu_run(struct kvm_vcpu *vcpu, struct kvm_run *kvm_run)
 			kvm_vcpu_block(vcpu);
 			down_read(&vcpu->kvm->slots_lock);
 			if (test_and_clear_bit(KVM_REQ_UNHALT, &vcpu->requests))
-				if (vcpu->arch.mp_state == KVM_MP_STATE_HALTED)
+			{
+				switch(vcpu->arch.mp_state) {
+				case KVM_MP_STATE_HALTED:
 					vcpu->arch.mp_state =
-							KVM_MP_STATE_RUNNABLE;
-			if (vcpu->arch.mp_state != KVM_MP_STATE_RUNNABLE)
-				r = -EINTR;
+						KVM_MP_STATE_RUNNABLE;
+				case KVM_MP_STATE_RUNNABLE:
+					break;
+				case KVM_MP_STATE_SIPI_RECEIVED:
+				default:
+					r = -EINTR;
+					break;
+				}
+			}
 		}
 
-		if (r > 0) {
-			if (dm_request_for_irq_injection(vcpu, kvm_run)) {
-				r = -EINTR;
-				kvm_run->exit_reason = KVM_EXIT_INTR;
-				++vcpu->stat.request_irq_exits;
-			}
-			if (signal_pending(current)) {
-				r = -EINTR;
-				kvm_run->exit_reason = KVM_EXIT_INTR;
-				++vcpu->stat.signal_exits;
-			}
-			if (need_resched()) {
-				up_read(&vcpu->kvm->slots_lock);
-				kvm_resched(vcpu);
-				down_read(&vcpu->kvm->slots_lock);
-			}
+		if (r <= 0)
+			break;
+
+		clear_bit(KVM_REQ_PENDING_TIMER, &vcpu->requests);
+		if (kvm_cpu_has_pending_timer(vcpu))
+			kvm_inject_pending_timer_irqs(vcpu);
+
+		if (dm_request_for_irq_injection(vcpu, kvm_run)) {
+			r = -EINTR;
+			kvm_run->exit_reason = KVM_EXIT_INTR;
+			++vcpu->stat.request_irq_exits;
+		}
+		if (signal_pending(current)) {
+			r = -EINTR;
+			kvm_run->exit_reason = KVM_EXIT_INTR;
+			++vcpu->stat.signal_exits;
+		}
+		if (need_resched()) {
+			up_read(&vcpu->kvm->slots_lock);
+			kvm_resched(vcpu);
+			down_read(&vcpu->kvm->slots_lock);
 		}
 	}
 
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 7379eab..ffe2826 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -1611,11 +1611,12 @@ void kvm_vcpu_block(struct kvm_vcpu *vcpu)
 		prepare_to_wait(&vcpu->wq, &wait, TASK_INTERRUPTIBLE);
 
 		if (kvm_cpu_has_interrupt(vcpu) ||
-		    kvm_cpu_has_pending_timer(vcpu) ||
-		    kvm_arch_vcpu_runnable(vcpu)) {
+				kvm_arch_vcpu_runnable(vcpu)) {
 			set_bit(KVM_REQ_UNHALT, &vcpu->requests);
 			break;
 		}
+		if (kvm_cpu_has_pending_timer(vcpu))
+			break;
 		if (signal_pending(current))
 			break;
 
-- 
1.6.0.6

