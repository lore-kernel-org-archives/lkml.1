Return-Path: <linux-kernel-owner+w=401wt.eu-S1757298AbYLHLtl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757298AbYLHLtl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2008 06:49:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753931AbYLHLih
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Dec 2008 06:38:37 -0500
Received: from mx2.redhat.com ([66.187.237.31]:48235 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753277AbYLHLhE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2008 06:37:04 -0500
From: Avi Kivity <avi@redhat.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Jan Kiszka <jan.kiszka@siemens.com>
Subject: [PATCH 09/45] KVM: x86: Enable NMI Watchdog via in-kernel PIT source
Date: Mon,  8 Dec 2008 13:36:20 +0200
Message-Id: <1228736216-15787-10-git-send-email-avi@redhat.com>
In-Reply-To: <1228736216-15787-1-git-send-email-avi@redhat.com>
References: <1228736216-15787-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jan Kiszka <jan.kiszka@siemens.com>

LINT0 of the LAPIC can be used to route PIT events as NMI watchdog ticks
into the guest. This patch aligns the in-kernel irqchip emulation with
the user space irqchip with already supports this feature. The trick is
to route PIT interrupts to all LAPIC's LVT0 lines.

Rebased and slightly polished patch originally posted by Sheng Yang.

Signed-off-by: Jan Kiszka <jan.kiszka@siemens.com>
Signed-off-by: Sheng Yang <sheng.yang@intel.com>
Signed-off-by: Avi Kivity <avi@redhat.com>
---
 arch/x86/kvm/i8254.c |   15 +++++++++++++++
 arch/x86/kvm/irq.h   |    1 +
 arch/x86/kvm/lapic.c |   34 +++++++++++++++++++++++++++++-----
 3 files changed, 45 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kvm/i8254.c b/arch/x86/kvm/i8254.c
index 59ebd37..580cc1d 100644
--- a/arch/x86/kvm/i8254.c
+++ b/arch/x86/kvm/i8254.c
@@ -603,10 +603,25 @@ void kvm_free_pit(struct kvm *kvm)
 
 static void __inject_pit_timer_intr(struct kvm *kvm)
 {
+	struct kvm_vcpu *vcpu;
+	int i;
+
 	mutex_lock(&kvm->lock);
 	kvm_set_irq(kvm, kvm->arch.vpit->irq_source_id, 0, 1);
 	kvm_set_irq(kvm, kvm->arch.vpit->irq_source_id, 0, 0);
 	mutex_unlock(&kvm->lock);
+
+	/*
+	 * Provides NMI watchdog support in IOAPIC mode.
+	 * The route is: PIT -> PIC -> LVT0 in NMI mode,
+	 * timer IRQs will continue to flow through the IOAPIC.
+	 */
+	for (i = 0; i < KVM_MAX_VCPUS; ++i) {
+		vcpu = kvm->vcpus[i];
+		if (!vcpu)
+			continue;
+		kvm_apic_local_deliver(vcpu, APIC_LVT0);
+	}
 }
 
 void kvm_inject_pit_timer_irqs(struct kvm_vcpu *vcpu)
diff --git a/arch/x86/kvm/irq.h b/arch/x86/kvm/irq.h
index f17c8f5..71e37a5 100644
--- a/arch/x86/kvm/irq.h
+++ b/arch/x86/kvm/irq.h
@@ -87,6 +87,7 @@ void kvm_pic_reset(struct kvm_kpic_state *s);
 void kvm_timer_intr_post(struct kvm_vcpu *vcpu, int vec);
 void kvm_inject_pending_timer_irqs(struct kvm_vcpu *vcpu);
 void kvm_inject_apic_timer_irqs(struct kvm_vcpu *vcpu);
+int kvm_apic_local_deliver(struct kvm_vcpu *vcpu, int lvt_type);
 void __kvm_migrate_apic_timer(struct kvm_vcpu *vcpu);
 void __kvm_migrate_pit_timer(struct kvm_vcpu *vcpu);
 void __kvm_migrate_timers(struct kvm_vcpu *vcpu);
diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index 0fc3cab..206cc11 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -380,6 +380,14 @@ static int __apic_accept_irq(struct kvm_lapic *apic, int delivery_mode,
 		}
 		break;
 
+	case APIC_DM_EXTINT:
+		/*
+		 * Should only be called by kvm_apic_local_deliver() with LVT0,
+		 * before NMI watchdog was enabled. Already handled by
+		 * kvm_apic_accept_pic_intr().
+		 */
+		break;
+
 	default:
 		printk(KERN_ERR "TODO: unsupported delivery mode %x\n",
 		       delivery_mode);
@@ -743,10 +751,13 @@ static void apic_mmio_write(struct kvm_io_device *this,
 		apic_set_reg(apic, APIC_ICR2, val & 0xff000000);
 		break;
 
+	case APIC_LVT0:
+		if (val == APIC_DM_NMI)
+			apic_debug("Receive NMI setting on APIC_LVT0 "
+				"for cpu %d\n", apic->vcpu->vcpu_id);
 	case APIC_LVTT:
 	case APIC_LVTTHMR:
 	case APIC_LVTPC:
-	case APIC_LVT0:
 	case APIC_LVT1:
 	case APIC_LVTERR:
 		/* TODO: Check vector */
@@ -961,12 +972,25 @@ int apic_has_pending_timer(struct kvm_vcpu *vcpu)
 	return 0;
 }
 
-static int __inject_apic_timer_irq(struct kvm_lapic *apic)
+int kvm_apic_local_deliver(struct kvm_vcpu *vcpu, int lvt_type)
 {
-	int vector;
+	struct kvm_lapic *apic = vcpu->arch.apic;
+	int vector, mode, trig_mode;
+	u32 reg;
+
+	if (apic && apic_enabled(apic)) {
+		reg = apic_get_reg(apic, lvt_type);
+		vector = reg & APIC_VECTOR_MASK;
+		mode = reg & APIC_MODE_MASK;
+		trig_mode = reg & APIC_LVT_LEVEL_TRIGGER;
+		return __apic_accept_irq(apic, mode, vector, 1, trig_mode);
+	}
+	return 0;
+}
 
-	vector = apic_lvt_vector(apic, APIC_LVTT);
-	return __apic_accept_irq(apic, APIC_DM_FIXED, vector, 1, 0);
+static inline int __inject_apic_timer_irq(struct kvm_lapic *apic)
+{
+	return kvm_apic_local_deliver(apic->vcpu, APIC_LVTT);
 }
 
 static enum hrtimer_restart apic_timer_fn(struct hrtimer *data)
-- 
1.6.0.3

