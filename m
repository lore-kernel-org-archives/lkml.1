Return-Path: <linux-kernel-owner+w=401wt.eu-S1759506AbYFZMkc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759506AbYFZMkc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2008 08:40:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754483AbYFZM3c
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jun 2008 08:29:32 -0400
Received: from il.qumranet.com ([212.179.150.194]:32381 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753193AbYFZM2p (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2008 08:28:45 -0400
From: Avi Kivity <avi@qumranet.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Marcelo Tosatti <mtosatti@redhat.com>
Subject: [PATCH 38/50] KVM: only abort guest entry if timer count goes from 0->1
Date: Thu, 26 Jun 2008 15:28:20 +0300
Message-Id: <1214483312-9265-39-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.6
In-Reply-To: <1214483312-9265-1-git-send-email-avi@qumranet.com>
References: <1214483312-9265-1-git-send-email-avi@qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Marcelo Tosatti <mtosatti@redhat.com>

Only abort guest entry if the timer count went from 0->1, since for 1->2
or larger the bit will either be set already or a timer irq will have
been injected.

Using atomic_inc_and_test() for it also introduces an SMP barrier
to the LAPIC version (thought it was unecessary because of timer
migration, but guest can be scheduled to a different pCPU between exit
and kvm_vcpu_block(), so there is the possibility for a race).

Noticed by Avi.

Signed-off-by: Marcelo Tosatti <mtosatti@redhat.com>
Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 arch/x86/kvm/i8254.c |   11 ++++-------
 arch/x86/kvm/lapic.c |    4 ++--
 2 files changed, 6 insertions(+), 9 deletions(-)

diff --git a/arch/x86/kvm/i8254.c b/arch/x86/kvm/i8254.c
index 9e3391e..c0f7872 100644
--- a/arch/x86/kvm/i8254.c
+++ b/arch/x86/kvm/i8254.c
@@ -198,14 +198,11 @@ static int __pit_timer_fn(struct kvm_kpit_state *ps)
 	struct kvm_vcpu *vcpu0 = ps->pit->kvm->vcpus[0];
 	struct kvm_kpit_timer *pt = &ps->pit_timer;
 
-	atomic_inc(&pt->pending);
-	smp_mb__after_atomic_inc();
-	if (vcpu0) {
+	if (!atomic_inc_and_test(&pt->pending))
 		set_bit(KVM_REQ_PENDING_TIMER, &vcpu0->requests);
-		if (waitqueue_active(&vcpu0->wq)) {
-			vcpu0->arch.mp_state = KVM_MP_STATE_RUNNABLE;
-			wake_up_interruptible(&vcpu0->wq);
-		}
+	if (vcpu0 && waitqueue_active(&vcpu0->wq)) {
+		vcpu0->arch.mp_state = KVM_MP_STATE_RUNNABLE;
+		wake_up_interruptible(&vcpu0->wq);
 	}
 
 	pt->timer.expires = ktime_add_ns(pt->timer.expires, pt->period);
diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index 180ba73..73f43de 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -945,8 +945,8 @@ static int __apic_timer_fn(struct kvm_lapic *apic)
 	int result = 0;
 	wait_queue_head_t *q = &apic->vcpu->wq;
 
-	atomic_inc(&apic->timer.pending);
-	set_bit(KVM_REQ_PENDING_TIMER, &apic->vcpu->requests);
+	if(!atomic_inc_and_test(&apic->timer.pending))
+		set_bit(KVM_REQ_PENDING_TIMER, &apic->vcpu->requests);
 	if (waitqueue_active(q)) {
 		apic->vcpu->arch.mp_state = KVM_MP_STATE_RUNNABLE;
 		wake_up_interruptible(q);
-- 
1.5.6

