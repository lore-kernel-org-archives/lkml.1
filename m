Return-Path: <linux-kernel-owner+w=401wt.eu-S1758596AbZERJks@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758596AbZERJks (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 May 2009 05:40:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755301AbZERJY7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 May 2009 05:24:59 -0400
Received: from mx2.redhat.com ([66.187.237.31]:38435 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754593AbZERJXL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 May 2009 05:23:11 -0400
From: Avi Kivity <avi@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: kvm@vger.kernel.org
Subject: [PATCH 24/43] KVM: APIC: get rid of deliver_bitmask
Date: Mon, 18 May 2009 12:22:46 +0300
Message-Id: <1242638585-18470-25-git-send-email-avi@redhat.com>
In-Reply-To: <1242638585-18470-1-git-send-email-avi@redhat.com>
References: <1242638585-18470-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Gleb Natapov <gleb@redhat.com>

Deliver interrupt during destination matching loop.

Signed-off-by: Gleb Natapov <gleb@redhat.com>
Acked-by: Xiantao Zhang <xiantao.zhang@intel.com>
Signed-off-by: Marcelo Tosatti <mtosatti@redhat.com>
---
 arch/ia64/kvm/kvm-ia64.c  |   33 ++++++++++++---------
 arch/ia64/kvm/lapic.h     |    4 +-
 arch/x86/kvm/lapic.c      |   59 ++++++++++---------------------------
 arch/x86/kvm/lapic.h      |    3 +-
 include/linux/kvm_types.h |   10 ++++++
 virt/kvm/ioapic.c         |   57 ++++++++++--------------------------
 virt/kvm/ioapic.h         |    6 +--
 virt/kvm/irq_comm.c       |   71 ++++++++++++++++++++++++++------------------
 8 files changed, 108 insertions(+), 135 deletions(-)

diff --git a/arch/ia64/kvm/kvm-ia64.c b/arch/ia64/kvm/kvm-ia64.c
index 1887a93..acf43ec 100644
--- a/arch/ia64/kvm/kvm-ia64.c
+++ b/arch/ia64/kvm/kvm-ia64.c
@@ -283,6 +283,18 @@ static int handle_sal_call(struct kvm_vcpu *vcpu, struct kvm_run *kvm_run)
 
 }
 
+static int __apic_accept_irq(struct kvm_vcpu *vcpu, uint64_t vector)
+{
+	struct vpd *vpd = to_host(vcpu->kvm, vcpu->arch.vpd);
+
+	if (!test_and_set_bit(vector, &vpd->irr[0])) {
+		vcpu->arch.irq_new_pending = 1;
+		kvm_vcpu_kick(vcpu);
+		return 1;
+	}
+	return 0;
+}
+
 /*
  *  offset: address offset to IPI space.
  *  value:  deliver value.
@@ -292,20 +304,20 @@ static void vcpu_deliver_ipi(struct kvm_vcpu *vcpu, uint64_t dm,
 {
 	switch (dm) {
 	case SAPIC_FIXED:
-		kvm_apic_set_irq(vcpu, vector, dm, 0);
 		break;
 	case SAPIC_NMI:
-		kvm_apic_set_irq(vcpu, 2, dm, 0);
+		vector = 2;
 		break;
 	case SAPIC_EXTINT:
-		kvm_apic_set_irq(vcpu, 0, dm, 0);
+		vector = 0;
 		break;
 	case SAPIC_INIT:
 	case SAPIC_PMI:
 	default:
 		printk(KERN_ERR"kvm: Unimplemented Deliver reserved IPI!\n");
-		break;
+		return;
 	}
+	__apic_accept_irq(vcpu, vector);
 }
 
 static struct kvm_vcpu *lid_to_vcpu(struct kvm *kvm, unsigned long id,
@@ -1813,17 +1825,9 @@ void kvm_vcpu_kick(struct kvm_vcpu *vcpu)
 	put_cpu();
 }
 
-int kvm_apic_set_irq(struct kvm_vcpu *vcpu, u8 vec, u8 dmode, u8 trig)
+int kvm_apic_set_irq(struct kvm_vcpu *vcpu, struct kvm_lapic_irq *irq)
 {
-
-	struct vpd *vpd = to_host(vcpu->kvm, vcpu->arch.vpd);
-
-	if (!test_and_set_bit(vec, &vpd->irr[0])) {
-		vcpu->arch.irq_new_pending = 1;
-		kvm_vcpu_kick(vcpu);
-		return 1;
-	}
-	return 0;
+	return __apic_accept_irq(vcpu, irq->vector);
 }
 
 int kvm_apic_match_physical_addr(struct kvm_lapic *apic, u16 dest)
@@ -1844,6 +1848,7 @@ int kvm_apic_compare_prio(struct kvm_vcpu *vcpu1, struct kvm_vcpu *vcpu2)
 int kvm_apic_match_dest(struct kvm_vcpu *vcpu, struct kvm_lapic *source,
 		int short_hand, int dest, int dest_mode)
 {
+	struct kvm_lapic *target = vcpu->arch.apic;
 	return (dest_mode == 0) ?
 		kvm_apic_match_physical_addr(target, dest) :
 		kvm_apic_match_logical_addr(target, dest);
diff --git a/arch/ia64/kvm/lapic.h b/arch/ia64/kvm/lapic.h
index e42109e..ee541ce 100644
--- a/arch/ia64/kvm/lapic.h
+++ b/arch/ia64/kvm/lapic.h
@@ -23,7 +23,7 @@ int kvm_apic_match_logical_addr(struct kvm_lapic *apic, u8 mda);
 int kvm_apic_match_dest(struct kvm_vcpu *vcpu, struct kvm_lapic *source,
 		int short_hand, int dest, int dest_mode);
 int kvm_apic_compare_prio(struct kvm_vcpu *vcpu1, struct kvm_vcpu *vcpu2);
-bool kvm_apic_present(struct kvm_vcpu *vcpu);
-int kvm_apic_set_irq(struct kvm_vcpu *vcpu, u8 vec, u8 dmode, u8 trig);
+int kvm_apic_set_irq(struct kvm_vcpu *vcpu, struct kvm_lapic_irq *irq);
+#define kvm_apic_present(x) (true)
 
 #endif
diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index 814466f..dd934d2 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -199,27 +199,12 @@ EXPORT_SYMBOL_GPL(kvm_lapic_find_highest_irr);
 static int __apic_accept_irq(struct kvm_lapic *apic, int delivery_mode,
 			     int vector, int level, int trig_mode);
 
-int kvm_apic_set_irq(struct kvm_vcpu *vcpu, u8 vec, u8 dmode, u8 trig)
+int kvm_apic_set_irq(struct kvm_vcpu *vcpu, struct kvm_lapic_irq *irq)
 {
 	struct kvm_lapic *apic = vcpu->arch.apic;
-	int lapic_dmode;
 
-	switch (dmode) {
-	case IOAPIC_LOWEST_PRIORITY:
-		lapic_dmode = APIC_DM_LOWEST;
-		break;
-	case IOAPIC_FIXED:
-		lapic_dmode = APIC_DM_FIXED;
-		break;
-	case IOAPIC_NMI:
-		lapic_dmode = APIC_DM_NMI;
-		break;
-	default:
-		printk(KERN_DEBUG"Ignoring delivery mode %d\n", dmode);
-		return 0;
-		break;
-	}
-	return __apic_accept_irq(apic, lapic_dmode, vec, 1, trig);
+	return __apic_accept_irq(apic, irq->delivery_mode, irq->vector,
+			irq->level, irq->trig_mode);
 }
 
 static inline int apic_find_highest_isr(struct kvm_lapic *apic)
@@ -447,36 +432,24 @@ static void apic_send_ipi(struct kvm_lapic *apic)
 {
 	u32 icr_low = apic_get_reg(apic, APIC_ICR);
 	u32 icr_high = apic_get_reg(apic, APIC_ICR2);
+	struct kvm_lapic_irq irq;
 
-	unsigned int dest = GET_APIC_DEST_FIELD(icr_high);
-	unsigned int short_hand = icr_low & APIC_SHORT_MASK;
-	unsigned int trig_mode = icr_low & APIC_INT_LEVELTRIG;
-	unsigned int level = icr_low & APIC_INT_ASSERT;
-	unsigned int dest_mode = icr_low & APIC_DEST_MASK;
-	unsigned int delivery_mode = icr_low & APIC_MODE_MASK;
-	unsigned int vector = icr_low & APIC_VECTOR_MASK;
-
-	DECLARE_BITMAP(deliver_bitmask, KVM_MAX_VCPUS);
-	int i;
+	irq.vector = icr_low & APIC_VECTOR_MASK;
+	irq.delivery_mode = icr_low & APIC_MODE_MASK;
+	irq.dest_mode = icr_low & APIC_DEST_MASK;
+	irq.level = icr_low & APIC_INT_ASSERT;
+	irq.trig_mode = icr_low & APIC_INT_LEVELTRIG;
+	irq.shorthand = icr_low & APIC_SHORT_MASK;
+	irq.dest_id = GET_APIC_DEST_FIELD(icr_high);
 
 	apic_debug("icr_high 0x%x, icr_low 0x%x, "
 		   "short_hand 0x%x, dest 0x%x, trig_mode 0x%x, level 0x%x, "
 		   "dest_mode 0x%x, delivery_mode 0x%x, vector 0x%x\n",
-		   icr_high, icr_low, short_hand, dest,
-		   trig_mode, level, dest_mode, delivery_mode, vector);
-
-	kvm_get_intr_delivery_bitmask(apic->vcpu->kvm, apic, dest, dest_mode,
-			delivery_mode == APIC_DM_LOWEST, short_hand,
-			deliver_bitmask);
-
-	while ((i = find_first_bit(deliver_bitmask, KVM_MAX_VCPUS))
-			< KVM_MAX_VCPUS) {
-		struct kvm_vcpu *vcpu = apic->vcpu->kvm->vcpus[i];
-		__clear_bit(i, deliver_bitmask);
-		if (vcpu)
-			__apic_accept_irq(vcpu->arch.apic, delivery_mode,
-					vector, level, trig_mode);
-	}
+		   icr_high, icr_low, irq.shorthand, irq.dest,
+		   irq.trig_mode, irq.level, irq.dest_mode, irq.delivery_mode,
+		   irq.vector);
+
+	kvm_irq_delivery_to_apic(apic->vcpu->kvm, apic, &irq);
 }
 
 static u32 apic_get_tmcct(struct kvm_lapic *apic)
diff --git a/arch/x86/kvm/lapic.h b/arch/x86/kvm/lapic.h
index b66dc14..a587f83 100644
--- a/arch/x86/kvm/lapic.h
+++ b/arch/x86/kvm/lapic.h
@@ -31,14 +31,13 @@ u64 kvm_lapic_get_base(struct kvm_vcpu *vcpu);
 
 int kvm_apic_match_physical_addr(struct kvm_lapic *apic, u16 dest);
 int kvm_apic_match_logical_addr(struct kvm_lapic *apic, u8 mda);
-int kvm_apic_set_irq(struct kvm_vcpu *vcpu, u8 vec, u8 dmode, u8 trig);
+int kvm_apic_set_irq(struct kvm_vcpu *vcpu, struct kvm_lapic_irq *irq);
 
 u64 kvm_get_apic_base(struct kvm_vcpu *vcpu);
 void kvm_set_apic_base(struct kvm_vcpu *vcpu, u64 data);
 void kvm_apic_post_state_restore(struct kvm_vcpu *vcpu);
 int kvm_lapic_enabled(struct kvm_vcpu *vcpu);
 bool kvm_apic_present(struct kvm_vcpu *vcpu);
-bool kvm_lapic_present(struct kvm_vcpu *vcpu);
 int kvm_lapic_find_highest_irr(struct kvm_vcpu *vcpu);
 
 void kvm_lapic_set_vapic_addr(struct kvm_vcpu *vcpu, gpa_t vapic_addr);
diff --git a/include/linux/kvm_types.h b/include/linux/kvm_types.h
index b84aca3..fb46efb 100644
--- a/include/linux/kvm_types.h
+++ b/include/linux/kvm_types.h
@@ -57,4 +57,14 @@ union kvm_ioapic_redirect_entry {
 	} fields;
 };
 
+struct kvm_lapic_irq {
+	u32 vector;
+	u32 delivery_mode;
+	u32 dest_mode;
+	u32 level;
+	u32 trig_mode;
+	u32 shorthand;
+	u32 dest_id;
+};
+
 #endif /* __KVM_TYPES_H__ */
diff --git a/virt/kvm/ioapic.c b/virt/kvm/ioapic.c
index 43969bb..1eddae9 100644
--- a/virt/kvm/ioapic.c
+++ b/virt/kvm/ioapic.c
@@ -142,58 +142,33 @@ static void ioapic_write_indirect(struct kvm_ioapic *ioapic, u32 val)
 	}
 }
 
-int ioapic_deliver_entry(struct kvm *kvm, union kvm_ioapic_redirect_entry *e)
-{
-	DECLARE_BITMAP(deliver_bitmask, KVM_MAX_VCPUS);
-	int i, r = -1;
-
-	kvm_get_intr_delivery_bitmask(kvm, NULL, e->fields.dest_id,
-			e->fields.dest_mode,
-			e->fields.delivery_mode == IOAPIC_LOWEST_PRIORITY,
-			0, deliver_bitmask);
-
-	if (find_first_bit(deliver_bitmask, KVM_MAX_VCPUS) >= KVM_MAX_VCPUS) {
-		ioapic_debug("no target on destination\n");
-		return r;
-	}
-
-	while ((i = find_first_bit(deliver_bitmask, KVM_MAX_VCPUS))
-			< KVM_MAX_VCPUS) {
-		struct kvm_vcpu *vcpu = kvm->vcpus[i];
-		__clear_bit(i, deliver_bitmask);
-		if (vcpu) {
-			if (r < 0)
-				r = 0;
-			r += kvm_apic_set_irq(vcpu, e->fields.vector,
-					e->fields.delivery_mode,
-					e->fields.trig_mode);
-		} else
-			ioapic_debug("null destination vcpu: "
-				     "mask=%x vector=%x delivery_mode=%x\n",
-				     e->fields.deliver_bitmask,
-				     e->fields.vector, e->fields.delivery_mode);
-	}
-	return r;
-}
-
 static int ioapic_deliver(struct kvm_ioapic *ioapic, int irq)
 {
-	union kvm_ioapic_redirect_entry entry = ioapic->redirtbl[irq];
+	union kvm_ioapic_redirect_entry *entry = &ioapic->redirtbl[irq];
+	struct kvm_lapic_irq irqe;
 
 	ioapic_debug("dest=%x dest_mode=%x delivery_mode=%x "
 		     "vector=%x trig_mode=%x\n",
-		     entry.fields.dest, entry.fields.dest_mode,
-		     entry.fields.delivery_mode, entry.fields.vector,
-		     entry.fields.trig_mode);
+		     entry->fields.dest, entry->fields.dest_mode,
+		     entry->fields.delivery_mode, entry->fields.vector,
+		     entry->fields.trig_mode);
+
+	irqe.dest_id = entry->fields.dest_id;
+	irqe.vector = entry->fields.vector;
+	irqe.dest_mode = entry->fields.dest_mode;
+	irqe.trig_mode = entry->fields.trig_mode;
+	irqe.delivery_mode = entry->fields.delivery_mode << 8;
+	irqe.level = 1;
+	irqe.shorthand = 0;
 
 #ifdef CONFIG_X86
 	/* Always delivery PIT interrupt to vcpu 0 */
 	if (irq == 0) {
-		entry.fields.dest_mode = 0; /* Physical mode. */
-		entry.fields.dest_id = ioapic->kvm->vcpus[0]->vcpu_id;
+		irqe.dest_mode = 0; /* Physical mode. */
+		irqe.dest_id = ioapic->kvm->vcpus[0]->vcpu_id;
 	}
 #endif
-	return ioapic_deliver_entry(ioapic->kvm, &entry);
+	return kvm_irq_delivery_to_apic(ioapic->kvm, NULL, &irqe);
 }
 
 int kvm_ioapic_set_irq(struct kvm_ioapic *ioapic, int irq, int level)
diff --git a/virt/kvm/ioapic.h b/virt/kvm/ioapic.h
index e7bc92d..7080b71 100644
--- a/virt/kvm/ioapic.h
+++ b/virt/kvm/ioapic.h
@@ -71,8 +71,6 @@ void kvm_ioapic_update_eoi(struct kvm *kvm, int vector, int trigger_mode);
 int kvm_ioapic_init(struct kvm *kvm);
 int kvm_ioapic_set_irq(struct kvm_ioapic *ioapic, int irq, int level);
 void kvm_ioapic_reset(struct kvm_ioapic *ioapic);
-void kvm_get_intr_delivery_bitmask(struct kvm *kvm, struct kvm_lapic *src,
-		int dest_id, int dest_mode, bool low_prio, int short_hand,
-		unsigned long *deliver_bitmask);
-int ioapic_deliver_entry(struct kvm *kvm, union kvm_ioapic_redirect_entry *e);
+int kvm_irq_delivery_to_apic(struct kvm *kvm, struct kvm_lapic *src,
+		struct kvm_lapic_irq *irq);
 #endif
diff --git a/virt/kvm/irq_comm.c b/virt/kvm/irq_comm.c
index f5e059b..4fa1f60 100644
--- a/virt/kvm/irq_comm.c
+++ b/virt/kvm/irq_comm.c
@@ -22,6 +22,9 @@
 #include <linux/kvm_host.h>
 
 #include <asm/msidef.h>
+#ifdef CONFIG_IA64
+#include <asm/iosapic.h>
+#endif
 
 #include "irq.h"
 
@@ -43,61 +46,71 @@ static int kvm_set_ioapic_irq(struct kvm_kernel_irq_routing_entry *e,
 	return kvm_ioapic_set_irq(kvm->arch.vioapic, e->irqchip.pin, level);
 }
 
-void kvm_get_intr_delivery_bitmask(struct kvm *kvm, struct kvm_lapic *src,
-		int dest_id, int dest_mode, bool low_prio, int short_hand,
-		unsigned long *deliver_bitmask)
+inline static bool kvm_is_dm_lowest_prio(struct kvm_lapic_irq *irq)
 {
-	int i, lowest = -1;
-	struct kvm_vcpu *vcpu;
+#ifdef CONFIG_IA64
+	return irq->delivery_mode ==
+		(IOSAPIC_LOWEST_PRIORITY << IOSAPIC_DELIVERY_SHIFT);
+#else
+	return irq->delivery_mode == APIC_DM_LOWEST;
+#endif
+}
 
-	if (dest_mode == 0 && dest_id == 0xff && low_prio)
+int kvm_irq_delivery_to_apic(struct kvm *kvm, struct kvm_lapic *src,
+		struct kvm_lapic_irq *irq)
+{
+	int i, r = -1;
+	struct kvm_vcpu *vcpu, *lowest = NULL;
+
+	if (irq->dest_mode == 0 && irq->dest_id == 0xff &&
+			kvm_is_dm_lowest_prio(irq))
 		printk(KERN_INFO "kvm: apic: phys broadcast and lowest prio\n");
 
-	bitmap_zero(deliver_bitmask, KVM_MAX_VCPUS);
 	for (i = 0; i < KVM_MAX_VCPUS; i++) {
 		vcpu = kvm->vcpus[i];
 
 		if (!vcpu || !kvm_apic_present(vcpu))
 			continue;
 
-		if (!kvm_apic_match_dest(vcpu, src, short_hand, dest_id,
-					dest_mode))
+		if (!kvm_apic_match_dest(vcpu, src, irq->shorthand,
+					irq->dest_id, irq->dest_mode))
 			continue;
 
-		if (!low_prio) {
-			__set_bit(i, deliver_bitmask);
+		if (!kvm_is_dm_lowest_prio(irq)) {
+			if (r < 0)
+				r = 0;
+			r += kvm_apic_set_irq(vcpu, irq);
 		} else {
-			if (lowest < 0)
-				lowest = i;
-			if (kvm_apic_compare_prio(vcpu, kvm->vcpus[lowest]) < 0)
-				lowest = i;
+			if (!lowest)
+				lowest = vcpu;
+			else if (kvm_apic_compare_prio(vcpu, lowest) < 0)
+				lowest = vcpu;
 		}
 	}
 
-	if (lowest != -1)
-		__set_bit(lowest, deliver_bitmask);
+	if (lowest)
+		r = kvm_apic_set_irq(lowest, irq);
+
+	return r;
 }
 
 static int kvm_set_msi(struct kvm_kernel_irq_routing_entry *e,
 		       struct kvm *kvm, int level)
 {
-	union kvm_ioapic_redirect_entry entry;
+	struct kvm_lapic_irq irq;
 
-	entry.bits = 0;
-	entry.fields.dest_id = (e->msi.address_lo &
+	irq.dest_id = (e->msi.address_lo &
 			MSI_ADDR_DEST_ID_MASK) >> MSI_ADDR_DEST_ID_SHIFT;
-	entry.fields.vector = (e->msi.data &
+	irq.vector = (e->msi.data &
 			MSI_DATA_VECTOR_MASK) >> MSI_DATA_VECTOR_SHIFT;
-	entry.fields.dest_mode = test_bit(MSI_ADDR_DEST_MODE_SHIFT,
-			(unsigned long *)&e->msi.address_lo);
-	entry.fields.trig_mode = test_bit(MSI_DATA_TRIGGER_SHIFT,
-			(unsigned long *)&e->msi.data);
-	entry.fields.delivery_mode = test_bit(
-			MSI_DATA_DELIVERY_MODE_SHIFT,
-			(unsigned long *)&e->msi.data);
+	irq.dest_mode = (1 << MSI_ADDR_DEST_MODE_SHIFT) & e->msi.address_lo;
+	irq.trig_mode = (1 << MSI_DATA_TRIGGER_SHIFT) & e->msi.data;
+	irq.delivery_mode = e->msi.data & 0x700;
+	irq.level = 1;
+	irq.shorthand = 0;
 
 	/* TODO Deal with RH bit of MSI message address */
-	return ioapic_deliver_entry(kvm, &entry);
+	return kvm_irq_delivery_to_apic(kvm, NULL, &irq);
 }
 
 /* This should be called with the kvm->lock mutex held
-- 
1.6.0.6

