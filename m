Return-Path: <linux-kernel-owner+w=401wt.eu-S1754702AbYLHLq5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754702AbYLHLq5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2008 06:46:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752031AbYLHLiS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Dec 2008 06:38:18 -0500
Received: from mx2.redhat.com ([66.187.237.31]:48269 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753333AbYLHLhF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2008 06:37:05 -0500
From: Avi Kivity <avi@redhat.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Jan Kiszka <jan.kiszka@siemens.com>
Subject: [PATCH 26/45] KVM: x86: Fix and refactor NMI watchdog emulation
Date: Mon,  8 Dec 2008 13:36:37 +0200
Message-Id: <1228736216-15787-27-git-send-email-avi@redhat.com>
In-Reply-To: <1228736216-15787-1-git-send-email-avi@redhat.com>
References: <1228736216-15787-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jan Kiszka <jan.kiszka@siemens.com>

This patch refactors the NMI watchdog delivery patch, consolidating
tests and providing a proper API for delivering watchdog events.

An included micro-optimization is to check only for apic_hw_enabled in
kvm_apic_local_deliver (the test for LVT mask is covering the
soft-disabled case already).

Signed-off-by: Jan Kiszka <jan.kiszka@siemens.com>
Acked-by: Sheng Yang <sheng@linux.intel.com>
Signed-off-by: Avi Kivity <avi@redhat.com>
---
 arch/x86/kvm/i8254.c |   15 +++++++++------
 arch/x86/kvm/irq.h   |    2 +-
 arch/x86/kvm/lapic.c |   20 ++++++++++----------
 3 files changed, 20 insertions(+), 17 deletions(-)

diff --git a/arch/x86/kvm/i8254.c b/arch/x86/kvm/i8254.c
index 580cc1d..b6fcf5a 100644
--- a/arch/x86/kvm/i8254.c
+++ b/arch/x86/kvm/i8254.c
@@ -612,15 +612,18 @@ static void __inject_pit_timer_intr(struct kvm *kvm)
 	mutex_unlock(&kvm->lock);
 
 	/*
-	 * Provides NMI watchdog support in IOAPIC mode.
-	 * The route is: PIT -> PIC -> LVT0 in NMI mode,
-	 * timer IRQs will continue to flow through the IOAPIC.
+	 * Provides NMI watchdog support via Virtual Wire mode.
+	 * The route is: PIT -> PIC -> LVT0 in NMI mode.
+	 *
+	 * Note: Our Virtual Wire implementation is simplified, only
+	 * propagating PIT interrupts to all VCPUs when they have set
+	 * LVT0 to NMI delivery. Other PIC interrupts are just sent to
+	 * VCPU0, and only if its LVT0 is in EXTINT mode.
 	 */
 	for (i = 0; i < KVM_MAX_VCPUS; ++i) {
 		vcpu = kvm->vcpus[i];
-		if (!vcpu)
-			continue;
-		kvm_apic_local_deliver(vcpu, APIC_LVT0);
+		if (vcpu)
+			kvm_apic_nmi_wd_deliver(vcpu);
 	}
 }
 
diff --git a/arch/x86/kvm/irq.h b/arch/x86/kvm/irq.h
index 71e37a5..b9e9051 100644
--- a/arch/x86/kvm/irq.h
+++ b/arch/x86/kvm/irq.h
@@ -87,7 +87,7 @@ void kvm_pic_reset(struct kvm_kpic_state *s);
 void kvm_timer_intr_post(struct kvm_vcpu *vcpu, int vec);
 void kvm_inject_pending_timer_irqs(struct kvm_vcpu *vcpu);
 void kvm_inject_apic_timer_irqs(struct kvm_vcpu *vcpu);
-int kvm_apic_local_deliver(struct kvm_vcpu *vcpu, int lvt_type);
+void kvm_apic_nmi_wd_deliver(struct kvm_vcpu *vcpu);
 void __kvm_migrate_apic_timer(struct kvm_vcpu *vcpu);
 void __kvm_migrate_pit_timer(struct kvm_vcpu *vcpu);
 void __kvm_migrate_timers(struct kvm_vcpu *vcpu);
diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index 304f9dd..0b0d413 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -973,14 +973,12 @@ int apic_has_pending_timer(struct kvm_vcpu *vcpu)
 	return 0;
 }
 
-int kvm_apic_local_deliver(struct kvm_vcpu *vcpu, int lvt_type)
+static int kvm_apic_local_deliver(struct kvm_lapic *apic, int lvt_type)
 {
-	struct kvm_lapic *apic = vcpu->arch.apic;
+	u32 reg = apic_get_reg(apic, lvt_type);
 	int vector, mode, trig_mode;
-	u32 reg;
 
-	if (apic && apic_enabled(apic)) {
-		reg = apic_get_reg(apic, lvt_type);
+	if (apic_hw_enabled(apic) && !(reg & APIC_LVT_MASKED)) {
 		vector = reg & APIC_VECTOR_MASK;
 		mode = reg & APIC_MODE_MASK;
 		trig_mode = reg & APIC_LVT_LEVEL_TRIGGER;
@@ -989,9 +987,12 @@ int kvm_apic_local_deliver(struct kvm_vcpu *vcpu, int lvt_type)
 	return 0;
 }
 
-static inline int __inject_apic_timer_irq(struct kvm_lapic *apic)
+void kvm_apic_nmi_wd_deliver(struct kvm_vcpu *vcpu)
 {
-	return kvm_apic_local_deliver(apic->vcpu, APIC_LVTT);
+	struct kvm_lapic *apic = vcpu->arch.apic;
+
+	if (apic)
+		kvm_apic_local_deliver(apic, APIC_LVT0);
 }
 
 static enum hrtimer_restart apic_timer_fn(struct hrtimer *data)
@@ -1086,9 +1087,8 @@ void kvm_inject_apic_timer_irqs(struct kvm_vcpu *vcpu)
 {
 	struct kvm_lapic *apic = vcpu->arch.apic;
 
-	if (apic && apic_lvt_enabled(apic, APIC_LVTT) &&
-		atomic_read(&apic->timer.pending) > 0) {
-		if (__inject_apic_timer_irq(apic))
+	if (apic && atomic_read(&apic->timer.pending) > 0) {
+		if (kvm_apic_local_deliver(apic, APIC_LVTT))
 			atomic_dec(&apic->timer.pending);
 	}
 }
-- 
1.6.0.3

