Return-Path: <linux-kernel-owner+w=401wt.eu-S1754737AbZHPJfO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754737AbZHPJfO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Aug 2009 05:35:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754437AbZHPJcM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Aug 2009 05:32:12 -0400
Received: from mx2.redhat.com ([66.187.237.31]:45374 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754089AbZHPJaO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Aug 2009 05:30:14 -0400
From: Avi Kivity <avi@redhat.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 46/48] KVM: Use pointer to vcpu instead of vcpu_id in timer code.
Date: Sun, 16 Aug 2009 12:30:06 +0300
Message-Id: <1250415008-17175-47-git-send-email-avi@redhat.com>
In-Reply-To: <1250415008-17175-1-git-send-email-avi@redhat.com>
References: <1250415008-17175-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Gleb Natapov <gleb@redhat.com>

Signed-off-by: Gleb Natapov <gleb@redhat.com>
Signed-off-by: Avi Kivity <avi@redhat.com>
---
 arch/x86/kvm/i8254.c     |    2 +-
 arch/x86/kvm/kvm_timer.h |    2 +-
 arch/x86/kvm/lapic.c     |    2 +-
 arch/x86/kvm/timer.c     |    2 +-
 4 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kvm/i8254.c b/arch/x86/kvm/i8254.c
index 008a831..06d8f84 100644
--- a/arch/x86/kvm/i8254.c
+++ b/arch/x86/kvm/i8254.c
@@ -294,7 +294,7 @@ static void create_pit_timer(struct kvm_kpit_state *ps, u32 val, int is_period)
 	pt->timer.function = kvm_timer_fn;
 	pt->t_ops = &kpit_ops;
 	pt->kvm = ps->pit->kvm;
-	pt->vcpu_id = 0;
+	pt->vcpu = pt->kvm->bsp_vcpu;
 
 	atomic_set(&pt->pending, 0);
 	ps->irq_ack = 1;
diff --git a/arch/x86/kvm/kvm_timer.h b/arch/x86/kvm/kvm_timer.h
index 26bd6ba..55c7524 100644
--- a/arch/x86/kvm/kvm_timer.h
+++ b/arch/x86/kvm/kvm_timer.h
@@ -6,7 +6,7 @@ struct kvm_timer {
 	bool reinject;
 	struct kvm_timer_ops *t_ops;
 	struct kvm *kvm;
-	int vcpu_id;
+	struct kvm_vcpu *vcpu;
 };
 
 struct kvm_timer_ops {
diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index b066130..b1694dc 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -950,7 +950,7 @@ int kvm_create_lapic(struct kvm_vcpu *vcpu)
 	apic->lapic_timer.timer.function = kvm_timer_fn;
 	apic->lapic_timer.t_ops = &lapic_timer_ops;
 	apic->lapic_timer.kvm = vcpu->kvm;
-	apic->lapic_timer.vcpu_id = vcpu->vcpu_id;
+	apic->lapic_timer.vcpu = vcpu;
 
 	apic->base_address = APIC_DEFAULT_PHYS_BASE;
 	vcpu->arch.apic_base = APIC_DEFAULT_PHYS_BASE;
diff --git a/arch/x86/kvm/timer.c b/arch/x86/kvm/timer.c
index 86dbac0..85cc743 100644
--- a/arch/x86/kvm/timer.c
+++ b/arch/x86/kvm/timer.c
@@ -33,7 +33,7 @@ enum hrtimer_restart kvm_timer_fn(struct hrtimer *data)
 	struct kvm_vcpu *vcpu;
 	struct kvm_timer *ktimer = container_of(data, struct kvm_timer, timer);
 
-	vcpu = ktimer->kvm->vcpus[ktimer->vcpu_id];
+	vcpu = ktimer->vcpu;
 	if (!vcpu)
 		return HRTIMER_NORESTART;
 
-- 
1.6.3.3

