Return-Path: <linux-kernel-owner+w=401wt.eu-S1756390AbZERJ1h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756390AbZERJ1h (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 May 2009 05:27:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754818AbZERJXX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 May 2009 05:23:23 -0400
Received: from mx2.redhat.com ([66.187.237.31]:38400 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752494AbZERJXI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 May 2009 05:23:08 -0400
From: Avi Kivity <avi@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: kvm@vger.kernel.org
Subject: [PATCH 06/43] KVM: Update intr delivery func to accept unsigned long* bitmap
Date: Mon, 18 May 2009 12:22:28 +0300
Message-Id: <1242638585-18470-7-git-send-email-avi@redhat.com>
In-Reply-To: <1242638585-18470-1-git-send-email-avi@redhat.com>
References: <1242638585-18470-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sheng Yang <sheng@linux.intel.com>

Would be used with bit ops, and would be easily extended if KVM_MAX_VCPUS is
increased.

Signed-off-by: Sheng Yang <sheng@linux.intel.com>
Signed-off-by: Avi Kivity <avi@redhat.com>
---
 arch/x86/kvm/lapic.c |    8 ++++----
 virt/kvm/ioapic.h    |    2 +-
 virt/kvm/irq_comm.c  |    2 +-
 3 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index f0b67f2..6aa8d20 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -409,7 +409,7 @@ static int __apic_accept_irq(struct kvm_lapic *apic, int delivery_mode,
 }
 
 static struct kvm_lapic *kvm_apic_round_robin(struct kvm *kvm, u8 vector,
-				       unsigned long bitmap)
+				       unsigned long *bitmap)
 {
 	int last;
 	int next;
@@ -421,7 +421,7 @@ static struct kvm_lapic *kvm_apic_round_robin(struct kvm *kvm, u8 vector,
 	do {
 		if (++next == KVM_MAX_VCPUS)
 			next = 0;
-		if (kvm->vcpus[next] == NULL || !test_bit(next, &bitmap))
+		if (kvm->vcpus[next] == NULL || !test_bit(next, bitmap))
 			continue;
 		apic = kvm->vcpus[next]->arch.apic;
 		if (apic && apic_enabled(apic))
@@ -437,7 +437,7 @@ static struct kvm_lapic *kvm_apic_round_robin(struct kvm *kvm, u8 vector,
 }
 
 struct kvm_vcpu *kvm_get_lowest_prio_vcpu(struct kvm *kvm, u8 vector,
-		unsigned long bitmap)
+		unsigned long *bitmap)
 {
 	struct kvm_lapic *apic;
 
@@ -508,7 +508,7 @@ static void apic_send_ipi(struct kvm_lapic *apic)
 	}
 
 	if (delivery_mode == APIC_DM_LOWEST) {
-		target = kvm_get_lowest_prio_vcpu(vcpu->kvm, vector, lpr_map);
+		target = kvm_get_lowest_prio_vcpu(vcpu->kvm, vector, &lpr_map);
 		if (target != NULL)
 			__apic_accept_irq(target->arch.apic, delivery_mode,
 					  vector, level, trig_mode);
diff --git a/virt/kvm/ioapic.h b/virt/kvm/ioapic.h
index f395798..7275f87 100644
--- a/virt/kvm/ioapic.h
+++ b/virt/kvm/ioapic.h
@@ -65,7 +65,7 @@ static inline struct kvm_ioapic *ioapic_irqchip(struct kvm *kvm)
 }
 
 struct kvm_vcpu *kvm_get_lowest_prio_vcpu(struct kvm *kvm, u8 vector,
-				       unsigned long bitmap);
+				       unsigned long *bitmap);
 void kvm_ioapic_update_eoi(struct kvm *kvm, int vector, int trigger_mode);
 int kvm_ioapic_init(struct kvm *kvm);
 int kvm_ioapic_set_irq(struct kvm_ioapic *ioapic, int irq, int level);
diff --git a/virt/kvm/irq_comm.c b/virt/kvm/irq_comm.c
index e8ff89c..d4421cd 100644
--- a/virt/kvm/irq_comm.c
+++ b/virt/kvm/irq_comm.c
@@ -55,7 +55,7 @@ void kvm_get_intr_delivery_bitmask(struct kvm_ioapic *ioapic,
 	switch (entry->fields.delivery_mode) {
 	case IOAPIC_LOWEST_PRIORITY:
 		vcpu = kvm_get_lowest_prio_vcpu(ioapic->kvm,
-				entry->fields.vector, *deliver_bitmask);
+				entry->fields.vector, deliver_bitmask);
 		*deliver_bitmask = 1 << vcpu->vcpu_id;
 		break;
 	case IOAPIC_FIXED:
-- 
1.6.0.6

