Return-Path: <linux-kernel-owner+w=401wt.eu-S1756738AbYLHLri@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756738AbYLHLri (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2008 06:47:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753343AbYLHLiW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Dec 2008 06:38:22 -0500
Received: from mx2.redhat.com ([66.187.237.31]:48266 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753317AbYLHLhF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2008 06:37:05 -0500
From: Avi Kivity <avi@redhat.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Jan Kiszka <jan.kiszka@siemens.com>
Subject: [PATCH 27/45] KVM: x86: Optimize NMI watchdog delivery
Date: Mon,  8 Dec 2008 13:36:38 +0200
Message-Id: <1228736216-15787-28-git-send-email-avi@redhat.com>
In-Reply-To: <1228736216-15787-1-git-send-email-avi@redhat.com>
References: <1228736216-15787-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jan Kiszka <jan.kiszka@siemens.com>

As suggested by Avi, this patch introduces a counter of VCPUs that have
LVT0 set to NMI mode. Only if the counter > 0, we push the PIT ticks via
all LAPIC LVT0 lines to enable NMI watchdog support.

Signed-off-by: Jan Kiszka <jan.kiszka@siemens.com>
Acked-by: Sheng Yang <sheng@linux.intel.com>
Signed-off-by: Avi Kivity <avi@redhat.com>
---
 arch/x86/include/asm/kvm_host.h |    1 +
 arch/x86/kvm/i8254.c            |   11 ++++++-----
 arch/x86/kvm/lapic.c            |   23 ++++++++++++++++++++---
 3 files changed, 27 insertions(+), 8 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 59c3ae1..09e6c56 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -361,6 +361,7 @@ struct kvm_arch{
 	struct kvm_ioapic *vioapic;
 	struct kvm_pit *vpit;
 	struct hlist_head irq_ack_notifier_list;
+	int vapics_in_nmi_mode;
 
 	int round_robin_prev_vcpu;
 	unsigned int tss_addr;
diff --git a/arch/x86/kvm/i8254.c b/arch/x86/kvm/i8254.c
index b6fcf5a..e665d1c 100644
--- a/arch/x86/kvm/i8254.c
+++ b/arch/x86/kvm/i8254.c
@@ -620,11 +620,12 @@ static void __inject_pit_timer_intr(struct kvm *kvm)
 	 * LVT0 to NMI delivery. Other PIC interrupts are just sent to
 	 * VCPU0, and only if its LVT0 is in EXTINT mode.
 	 */
-	for (i = 0; i < KVM_MAX_VCPUS; ++i) {
-		vcpu = kvm->vcpus[i];
-		if (vcpu)
-			kvm_apic_nmi_wd_deliver(vcpu);
-	}
+	if (kvm->arch.vapics_in_nmi_mode > 0)
+		for (i = 0; i < KVM_MAX_VCPUS; ++i) {
+			vcpu = kvm->vcpus[i];
+			if (vcpu)
+				kvm_apic_nmi_wd_deliver(vcpu);
+		}
 }
 
 void kvm_inject_pit_timer_irqs(struct kvm_vcpu *vcpu)
diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index 0b0d413..afac68c 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -130,6 +130,11 @@ static inline int apic_lvtt_period(struct kvm_lapic *apic)
 	return apic_get_reg(apic, APIC_LVTT) & APIC_LVT_TIMER_PERIODIC;
 }
 
+static inline int apic_lvt_nmi_mode(u32 lvt_val)
+{
+	return (lvt_val & (APIC_MODE_MASK | APIC_LVT_MASKED)) == APIC_DM_NMI;
+}
+
 static unsigned int apic_lvt_mask[APIC_LVT_NUM] = {
 	LVT_MASK | APIC_LVT_TIMER_PERIODIC,	/* LVTT */
 	LVT_MASK | APIC_MODE_MASK,	/* LVTTHMR */
@@ -672,6 +677,20 @@ static void start_apic_timer(struct kvm_lapic *apic)
 					apic->timer.period)));
 }
 
+static void apic_manage_nmi_watchdog(struct kvm_lapic *apic, u32 lvt0_val)
+{
+	int nmi_wd_enabled = apic_lvt_nmi_mode(apic_get_reg(apic, APIC_LVT0));
+
+	if (apic_lvt_nmi_mode(lvt0_val)) {
+		if (!nmi_wd_enabled) {
+			apic_debug("Receive NMI setting on APIC_LVT0 "
+				   "for cpu %d\n", apic->vcpu->vcpu_id);
+			apic->vcpu->kvm->arch.vapics_in_nmi_mode++;
+		}
+	} else if (nmi_wd_enabled)
+		apic->vcpu->kvm->arch.vapics_in_nmi_mode--;
+}
+
 static void apic_mmio_write(struct kvm_io_device *this,
 			    gpa_t address, int len, const void *data)
 {
@@ -753,9 +772,7 @@ static void apic_mmio_write(struct kvm_io_device *this,
 		break;
 
 	case APIC_LVT0:
-		if (val == APIC_DM_NMI)
-			apic_debug("Receive NMI setting on APIC_LVT0 "
-				"for cpu %d\n", apic->vcpu->vcpu_id);
+		apic_manage_nmi_watchdog(apic, val);
 	case APIC_LVTT:
 	case APIC_LVTTHMR:
 	case APIC_LVTPC:
-- 
1.6.0.3

