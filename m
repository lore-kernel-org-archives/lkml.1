Return-Path: <linux-kernel-owner+w=401wt.eu-S1756550AbZERJgM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756550AbZERJgM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 May 2009 05:36:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756373AbZERJYG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 May 2009 05:24:06 -0400
Received: from mx2.redhat.com ([66.187.237.31]:38424 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754193AbZERJXL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 May 2009 05:23:11 -0400
From: Avi Kivity <avi@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: kvm@vger.kernel.org
Subject: [PATCH 22/43] KVM: consolidate ioapic/ipi interrupt delivery logic
Date: Mon, 18 May 2009 12:22:44 +0300
Message-Id: <1242638585-18470-23-git-send-email-avi@redhat.com>
In-Reply-To: <1242638585-18470-1-git-send-email-avi@redhat.com>
References: <1242638585-18470-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Gleb Natapov <gleb@redhat.com>

Use kvm_apic_match_dest() in kvm_get_intr_delivery_bitmask() instead
of duplicating the same code. Use kvm_get_intr_delivery_bitmask() in
apic_send_ipi() to figure out ipi destination instead of reimplementing
the logic.

Signed-off-by: Gleb Natapov <gleb@redhat.com>
Signed-off-by: Marcelo Tosatti <mtosatti@redhat.com>
---
 arch/ia64/kvm/kvm-ia64.c |    8 +++++
 arch/ia64/kvm/lapic.h    |    3 ++
 arch/x86/kvm/lapic.c     |   69 ++++++++++++++++--------------------------
 arch/x86/kvm/lapic.h     |    2 +
 include/linux/kvm_host.h |    5 ---
 virt/kvm/ioapic.c        |    5 ++-
 virt/kvm/ioapic.h        |   10 ++++--
 virt/kvm/irq_comm.c      |   76 +++++++++++++--------------------------------
 8 files changed, 71 insertions(+), 107 deletions(-)

diff --git a/arch/ia64/kvm/kvm-ia64.c b/arch/ia64/kvm/kvm-ia64.c
index 99d6d17..8eea9cb 100644
--- a/arch/ia64/kvm/kvm-ia64.c
+++ b/arch/ia64/kvm/kvm-ia64.c
@@ -1852,6 +1852,14 @@ struct kvm_vcpu *kvm_get_lowest_prio_vcpu(struct kvm *kvm, u8 vector,
 	return lvcpu;
 }
 
+int kvm_apic_match_dest(struct kvm_vcpu *vcpu, struct kvm_lapic *source,
+		int short_hand, int dest, int dest_mode)
+{
+	return (dest_mode == 0) ?
+		kvm_apic_match_physical_addr(target, dest) :
+		kvm_apic_match_logical_addr(target, dest);
+}
+
 static int find_highest_bits(int *dat)
 {
 	u32  bits, bitnum;
diff --git a/arch/ia64/kvm/lapic.h b/arch/ia64/kvm/lapic.h
index cbcfaa6..31602e7 100644
--- a/arch/ia64/kvm/lapic.h
+++ b/arch/ia64/kvm/lapic.h
@@ -20,6 +20,9 @@ void kvm_free_lapic(struct kvm_vcpu *vcpu);
 
 int kvm_apic_match_physical_addr(struct kvm_lapic *apic, u16 dest);
 int kvm_apic_match_logical_addr(struct kvm_lapic *apic, u8 mda);
+int kvm_apic_match_dest(struct kvm_vcpu *vcpu, struct kvm_lapic *source,
+		int short_hand, int dest, int dest_mode);
+bool kvm_apic_present(struct kvm_vcpu *vcpu);
 int kvm_apic_set_irq(struct kvm_vcpu *vcpu, u8 vec, u8 dmode, u8 trig);
 
 #endif
diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index a42f968..998862a 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -260,7 +260,7 @@ static void apic_set_tpr(struct kvm_lapic *apic, u32 tpr)
 
 int kvm_apic_match_physical_addr(struct kvm_lapic *apic, u16 dest)
 {
-	return kvm_apic_id(apic) == dest;
+	return dest == 0xff || kvm_apic_id(apic) == dest;
 }
 
 int kvm_apic_match_logical_addr(struct kvm_lapic *apic, u8 mda)
@@ -289,37 +289,34 @@ int kvm_apic_match_logical_addr(struct kvm_lapic *apic, u8 mda)
 	return result;
 }
 
-static int apic_match_dest(struct kvm_vcpu *vcpu, struct kvm_lapic *source,
+int kvm_apic_match_dest(struct kvm_vcpu *vcpu, struct kvm_lapic *source,
 			   int short_hand, int dest, int dest_mode)
 {
 	int result = 0;
 	struct kvm_lapic *target = vcpu->arch.apic;
 
 	apic_debug("target %p, source %p, dest 0x%x, "
-		   "dest_mode 0x%x, short_hand 0x%x",
+		   "dest_mode 0x%x, short_hand 0x%x\n",
 		   target, source, dest, dest_mode, short_hand);
 
 	ASSERT(!target);
 	switch (short_hand) {
 	case APIC_DEST_NOSHORT:
-		if (dest_mode == 0) {
+		if (dest_mode == 0)
 			/* Physical mode. */
-			if ((dest == 0xFF) || (dest == kvm_apic_id(target)))
-				result = 1;
-		} else
+			result = kvm_apic_match_physical_addr(target, dest);
+		else
 			/* Logical mode. */
 			result = kvm_apic_match_logical_addr(target, dest);
 		break;
 	case APIC_DEST_SELF:
-		if (target == source)
-			result = 1;
+		result = (target == source);
 		break;
 	case APIC_DEST_ALLINC:
 		result = 1;
 		break;
 	case APIC_DEST_ALLBUT:
-		if (target != source)
-			result = 1;
+		result = (target != source);
 		break;
 	default:
 		printk(KERN_WARNING "Bad dest shorthand value %x\n",
@@ -492,38 +489,26 @@ static void apic_send_ipi(struct kvm_lapic *apic)
 	unsigned int delivery_mode = icr_low & APIC_MODE_MASK;
 	unsigned int vector = icr_low & APIC_VECTOR_MASK;
 
-	struct kvm_vcpu *target;
-	struct kvm_vcpu *vcpu;
-	DECLARE_BITMAP(lpr_map, KVM_MAX_VCPUS);
+	DECLARE_BITMAP(deliver_bitmask, KVM_MAX_VCPUS);
 	int i;
 
-	bitmap_zero(lpr_map, KVM_MAX_VCPUS);
 	apic_debug("icr_high 0x%x, icr_low 0x%x, "
 		   "short_hand 0x%x, dest 0x%x, trig_mode 0x%x, level 0x%x, "
 		   "dest_mode 0x%x, delivery_mode 0x%x, vector 0x%x\n",
 		   icr_high, icr_low, short_hand, dest,
 		   trig_mode, level, dest_mode, delivery_mode, vector);
 
-	for (i = 0; i < KVM_MAX_VCPUS; i++) {
-		vcpu = apic->vcpu->kvm->vcpus[i];
-		if (!vcpu)
-			continue;
-
-		if (vcpu->arch.apic &&
-		    apic_match_dest(vcpu, apic, short_hand, dest, dest_mode)) {
-			if (delivery_mode == APIC_DM_LOWEST)
-				__set_bit(vcpu->vcpu_id, lpr_map);
-			else
-				__apic_accept_irq(vcpu->arch.apic, delivery_mode,
-						  vector, level, trig_mode);
-		}
-	}
-
-	if (delivery_mode == APIC_DM_LOWEST) {
-		target = kvm_get_lowest_prio_vcpu(vcpu->kvm, vector, lpr_map);
-		if (target != NULL)
-			__apic_accept_irq(target->arch.apic, delivery_mode,
-					  vector, level, trig_mode);
+	kvm_get_intr_delivery_bitmask(apic->vcpu->kvm, apic, dest, dest_mode,
+			delivery_mode == APIC_DM_LOWEST, short_hand,
+			deliver_bitmask);
+
+	while ((i = find_first_bit(deliver_bitmask, KVM_MAX_VCPUS))
+			< KVM_MAX_VCPUS) {
+		struct kvm_vcpu *vcpu = apic->vcpu->kvm->vcpus[i];
+		__clear_bit(i, deliver_bitmask);
+		if (vcpu)
+			__apic_accept_irq(vcpu->arch.apic, delivery_mode,
+					vector, level, trig_mode);
 	}
 }
 
@@ -930,16 +915,14 @@ void kvm_lapic_reset(struct kvm_vcpu *vcpu)
 }
 EXPORT_SYMBOL_GPL(kvm_lapic_reset);
 
-int kvm_lapic_enabled(struct kvm_vcpu *vcpu)
+bool kvm_apic_present(struct kvm_vcpu *vcpu)
 {
-	struct kvm_lapic *apic = vcpu->arch.apic;
-	int ret = 0;
-
-	if (!apic)
-		return 0;
-	ret = apic_enabled(apic);
+	return vcpu->arch.apic && apic_hw_enabled(vcpu->arch.apic);
+}
 
-	return ret;
+int kvm_lapic_enabled(struct kvm_vcpu *vcpu)
+{
+	return kvm_apic_present(vcpu) && apic_sw_enabled(vcpu->arch.apic);
 }
 EXPORT_SYMBOL_GPL(kvm_lapic_enabled);
 
diff --git a/arch/x86/kvm/lapic.h b/arch/x86/kvm/lapic.h
index 1b0e3c0..b66dc14 100644
--- a/arch/x86/kvm/lapic.h
+++ b/arch/x86/kvm/lapic.h
@@ -37,6 +37,8 @@ u64 kvm_get_apic_base(struct kvm_vcpu *vcpu);
 void kvm_set_apic_base(struct kvm_vcpu *vcpu, u64 data);
 void kvm_apic_post_state_restore(struct kvm_vcpu *vcpu);
 int kvm_lapic_enabled(struct kvm_vcpu *vcpu);
+bool kvm_apic_present(struct kvm_vcpu *vcpu);
+bool kvm_lapic_present(struct kvm_vcpu *vcpu);
 int kvm_lapic_find_highest_irr(struct kvm_vcpu *vcpu);
 
 void kvm_lapic_set_vapic_addr(struct kvm_vcpu *vcpu, gpa_t vapic_addr);
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index ec9d078..fb60f31 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -363,11 +363,6 @@ void kvm_unregister_irq_mask_notifier(struct kvm *kvm, int irq,
 				      struct kvm_irq_mask_notifier *kimn);
 void kvm_fire_mask_notifiers(struct kvm *kvm, int irq, bool mask);
 
-#ifdef __KVM_HAVE_IOAPIC
-void kvm_get_intr_delivery_bitmask(struct kvm *kvm,
-				   union kvm_ioapic_redirect_entry *entry,
-				   unsigned long *deliver_bitmask);
-#endif
 int kvm_set_irq(struct kvm *kvm, int irq_source_id, int irq, int level);
 void kvm_notify_acked_irq(struct kvm *kvm, unsigned irqchip, unsigned pin);
 void kvm_register_irq_ack_notifier(struct kvm *kvm,
diff --git a/virt/kvm/ioapic.c b/virt/kvm/ioapic.c
index b71c044..43969bb 100644
--- a/virt/kvm/ioapic.c
+++ b/virt/kvm/ioapic.c
@@ -147,7 +147,10 @@ int ioapic_deliver_entry(struct kvm *kvm, union kvm_ioapic_redirect_entry *e)
 	DECLARE_BITMAP(deliver_bitmask, KVM_MAX_VCPUS);
 	int i, r = -1;
 
-	kvm_get_intr_delivery_bitmask(kvm, e, deliver_bitmask);
+	kvm_get_intr_delivery_bitmask(kvm, NULL, e->fields.dest_id,
+			e->fields.dest_mode,
+			e->fields.delivery_mode == IOAPIC_LOWEST_PRIORITY,
+			0, deliver_bitmask);
 
 	if (find_first_bit(deliver_bitmask, KVM_MAX_VCPUS) >= KVM_MAX_VCPUS) {
 		ioapic_debug("no target on destination\n");
diff --git a/virt/kvm/ioapic.h b/virt/kvm/ioapic.h
index bedeea5..d996c7a 100644
--- a/virt/kvm/ioapic.h
+++ b/virt/kvm/ioapic.h
@@ -65,13 +65,15 @@ static inline struct kvm_ioapic *ioapic_irqchip(struct kvm *kvm)
 }
 
 struct kvm_vcpu *kvm_get_lowest_prio_vcpu(struct kvm *kvm, u8 vector,
-				       unsigned long *bitmap);
+		unsigned long *bitmap);
+int kvm_apic_match_dest(struct kvm_vcpu *vcpu, struct kvm_lapic *source,
+		int short_hand, int dest, int dest_mode);
 void kvm_ioapic_update_eoi(struct kvm *kvm, int vector, int trigger_mode);
 int kvm_ioapic_init(struct kvm *kvm);
 int kvm_ioapic_set_irq(struct kvm_ioapic *ioapic, int irq, int level);
 void kvm_ioapic_reset(struct kvm_ioapic *ioapic);
-void kvm_get_intr_delivery_bitmask(struct kvm *kvm,
-				   union kvm_ioapic_redirect_entry *entry,
-				   unsigned long *deliver_bitmask);
+void kvm_get_intr_delivery_bitmask(struct kvm *kvm, struct kvm_lapic *src,
+		int dest_id, int dest_mode, bool low_prio, int short_hand,
+		unsigned long *deliver_bitmask);
 int ioapic_deliver_entry(struct kvm *kvm, union kvm_ioapic_redirect_entry *e);
 #endif
diff --git a/virt/kvm/irq_comm.c b/virt/kvm/irq_comm.c
index 35397a5..e43701c 100644
--- a/virt/kvm/irq_comm.c
+++ b/virt/kvm/irq_comm.c
@@ -43,67 +43,35 @@ static int kvm_set_ioapic_irq(struct kvm_kernel_irq_routing_entry *e,
 	return kvm_ioapic_set_irq(kvm->arch.vioapic, e->irqchip.pin, level);
 }
 
-void kvm_get_intr_delivery_bitmask(struct kvm *kvm,
-				   union kvm_ioapic_redirect_entry *entry,
-				   unsigned long *deliver_bitmask)
+void kvm_get_intr_delivery_bitmask(struct kvm *kvm, struct kvm_lapic *src,
+		int dest_id, int dest_mode, bool low_prio, int short_hand,
+		unsigned long *deliver_bitmask)
 {
 	int i;
 	struct kvm_vcpu *vcpu;
 
+	if (dest_mode == 0 && dest_id == 0xff && low_prio)
+		printk(KERN_INFO "kvm: apic: phys broadcast and lowest prio\n");
+
 	bitmap_zero(deliver_bitmask, KVM_MAX_VCPUS);
+	for (i = 0; i < KVM_MAX_VCPUS; i++) {
+		vcpu = kvm->vcpus[i];
 
-	if (entry->fields.dest_mode == 0) {	/* Physical mode. */
-		if (entry->fields.dest_id == 0xFF) {	/* Broadcast. */
-			for (i = 0; i < KVM_MAX_VCPUS; ++i)
-				if (kvm->vcpus[i] && kvm->vcpus[i]->arch.apic)
-					__set_bit(i, deliver_bitmask);
-			/* Lowest priority shouldn't combine with broadcast */
-			if (entry->fields.delivery_mode ==
-			    IOAPIC_LOWEST_PRIORITY && printk_ratelimit())
-				printk(KERN_INFO "kvm: apic: phys broadcast "
-						  "and lowest prio\n");
-			return;
-		}
-		for (i = 0; i < KVM_MAX_VCPUS; ++i) {
-			vcpu = kvm->vcpus[i];
-			if (!vcpu)
-				continue;
-			if (kvm_apic_match_physical_addr(vcpu->arch.apic,
-					entry->fields.dest_id)) {
-				if (vcpu->arch.apic)
-					__set_bit(i, deliver_bitmask);
-				break;
-			}
-		}
-	} else if (entry->fields.dest_id != 0) /* Logical mode, MDA non-zero. */
-		for (i = 0; i < KVM_MAX_VCPUS; ++i) {
-			vcpu = kvm->vcpus[i];
-			if (!vcpu)
-				continue;
-			if (vcpu->arch.apic &&
-			    kvm_apic_match_logical_addr(vcpu->arch.apic,
-					entry->fields.dest_id))
-				__set_bit(i, deliver_bitmask);
-		}
+		if (!vcpu || !kvm_apic_present(vcpu))
+			continue;
 
-	switch (entry->fields.delivery_mode) {
-	case IOAPIC_LOWEST_PRIORITY:
-		/* Select one in deliver_bitmask */
-		vcpu = kvm_get_lowest_prio_vcpu(kvm,
-				entry->fields.vector, deliver_bitmask);
-		bitmap_zero(deliver_bitmask, KVM_MAX_VCPUS);
-		if (!vcpu)
-			return;
-		__set_bit(vcpu->vcpu_id, deliver_bitmask);
-		break;
-	case IOAPIC_FIXED:
-	case IOAPIC_NMI:
-		break;
-	default:
-		if (printk_ratelimit())
-			printk(KERN_INFO "kvm: unsupported delivery mode %d\n",
-				entry->fields.delivery_mode);
+		if (!kvm_apic_match_dest(vcpu, src, short_hand, dest_id,
+					dest_mode))
+			continue;
+
+		__set_bit(i, deliver_bitmask);
+	}
+
+	if (low_prio) {
+		vcpu = kvm_get_lowest_prio_vcpu(kvm, 0, deliver_bitmask);
 		bitmap_zero(deliver_bitmask, KVM_MAX_VCPUS);
+		if (vcpu)
+			__set_bit(vcpu->vcpu_id, deliver_bitmask);
 	}
 }
 
-- 
1.6.0.6

