Return-Path: <linux-kernel-owner+w=401wt.eu-S1758042AbZERJfB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758042AbZERJfB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 May 2009 05:35:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756337AbZERJYA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 May 2009 05:24:00 -0400
Received: from mx2.redhat.com ([66.187.237.31]:38422 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754152AbZERJXL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 May 2009 05:23:11 -0400
From: Avi Kivity <avi@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: kvm@vger.kernel.org
Subject: [PATCH 23/43] KVM: change the way how lowest priority vcpu is calculated
Date: Mon, 18 May 2009 12:22:45 +0300
Message-Id: <1242638585-18470-24-git-send-email-avi@redhat.com>
In-Reply-To: <1242638585-18470-1-git-send-email-avi@redhat.com>
References: <1242638585-18470-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Gleb Natapov <gleb@redhat.com>

The new way does not require additional loop over vcpus to calculate
the one with lowest priority as one is chosen during delivery bitmap
construction.

Signed-off-by: Gleb Natapov <gleb@redhat.com>
Signed-off-by: Marcelo Tosatti <mtosatti@redhat.com>
---
 arch/ia64/kvm/kvm-ia64.c        |   15 +-----------
 arch/ia64/kvm/lapic.h           |    1 +
 arch/x86/include/asm/kvm_host.h |    2 +-
 arch/x86/kvm/lapic.c            |   43 +++++---------------------------------
 virt/kvm/ioapic.h               |    3 +-
 virt/kvm/irq_comm.c             |   19 ++++++++++-------
 6 files changed, 22 insertions(+), 61 deletions(-)

diff --git a/arch/ia64/kvm/kvm-ia64.c b/arch/ia64/kvm/kvm-ia64.c
index 8eea9cb..1887a93 100644
--- a/arch/ia64/kvm/kvm-ia64.c
+++ b/arch/ia64/kvm/kvm-ia64.c
@@ -1836,20 +1836,9 @@ int kvm_apic_match_logical_addr(struct kvm_lapic *apic, u8 mda)
 	return 0;
 }
 
-struct kvm_vcpu *kvm_get_lowest_prio_vcpu(struct kvm *kvm, u8 vector,
-				       unsigned long *bitmap)
+int kvm_apic_compare_prio(struct kvm_vcpu *vcpu1, struct kvm_vcpu *vcpu2)
 {
-	struct kvm_vcpu *lvcpu = kvm->vcpus[0];
-	int i;
-
-	for (i = 1; i < kvm->arch.online_vcpus; i++) {
-		if (!kvm->vcpus[i])
-			continue;
-		if (lvcpu->arch.xtp > kvm->vcpus[i]->arch.xtp)
-			lvcpu = kvm->vcpus[i];
-	}
-
-	return lvcpu;
+	return vcpu1->arch.xtp - vcpu2->arch.xtp;
 }
 
 int kvm_apic_match_dest(struct kvm_vcpu *vcpu, struct kvm_lapic *source,
diff --git a/arch/ia64/kvm/lapic.h b/arch/ia64/kvm/lapic.h
index 31602e7..e42109e 100644
--- a/arch/ia64/kvm/lapic.h
+++ b/arch/ia64/kvm/lapic.h
@@ -22,6 +22,7 @@ int kvm_apic_match_physical_addr(struct kvm_lapic *apic, u16 dest);
 int kvm_apic_match_logical_addr(struct kvm_lapic *apic, u8 mda);
 int kvm_apic_match_dest(struct kvm_vcpu *vcpu, struct kvm_lapic *source,
 		int short_hand, int dest, int dest_mode);
+int kvm_apic_compare_prio(struct kvm_vcpu *vcpu1, struct kvm_vcpu *vcpu2);
 bool kvm_apic_present(struct kvm_vcpu *vcpu);
 int kvm_apic_set_irq(struct kvm_vcpu *vcpu, u8 vec, u8 dmode, u8 trig);
 
diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index f0faf58..4627627 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -286,6 +286,7 @@ struct kvm_vcpu_arch {
 	u64 shadow_efer;
 	u64 apic_base;
 	struct kvm_lapic *apic;    /* kernel irqchip context */
+	int32_t apic_arb_prio;
 	int mp_state;
 	int sipi_vector;
 	u64 ia32_misc_enable_msr;
@@ -400,7 +401,6 @@ struct kvm_arch{
 	struct hlist_head irq_ack_notifier_list;
 	int vapics_in_nmi_mode;
 
-	int round_robin_prev_vcpu;
 	unsigned int tss_addr;
 	struct page *apic_access_page;
 
diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index 998862a..814466f 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -338,8 +338,9 @@ static int __apic_accept_irq(struct kvm_lapic *apic, int delivery_mode,
 	struct kvm_vcpu *vcpu = apic->vcpu;
 
 	switch (delivery_mode) {
-	case APIC_DM_FIXED:
 	case APIC_DM_LOWEST:
+		vcpu->arch.apic_arb_prio++;
+	case APIC_DM_FIXED:
 		/* FIXME add logic for vcpu on reset */
 		if (unlikely(!apic_enabled(apic)))
 			break;
@@ -416,43 +417,9 @@ static int __apic_accept_irq(struct kvm_lapic *apic, int delivery_mode,
 	return result;
 }
 
-static struct kvm_lapic *kvm_apic_round_robin(struct kvm *kvm, u8 vector,
-				       unsigned long *bitmap)
+int kvm_apic_compare_prio(struct kvm_vcpu *vcpu1, struct kvm_vcpu *vcpu2)
 {
-	int last;
-	int next;
-	struct kvm_lapic *apic = NULL;
-
-	last = kvm->arch.round_robin_prev_vcpu;
-	next = last;
-
-	do {
-		if (++next == KVM_MAX_VCPUS)
-			next = 0;
-		if (kvm->vcpus[next] == NULL || !test_bit(next, bitmap))
-			continue;
-		apic = kvm->vcpus[next]->arch.apic;
-		if (apic && apic_enabled(apic))
-			break;
-		apic = NULL;
-	} while (next != last);
-	kvm->arch.round_robin_prev_vcpu = next;
-
-	if (!apic)
-		printk(KERN_DEBUG "vcpu not ready for apic_round_robin\n");
-
-	return apic;
-}
-
-struct kvm_vcpu *kvm_get_lowest_prio_vcpu(struct kvm *kvm, u8 vector,
-		unsigned long *bitmap)
-{
-	struct kvm_lapic *apic;
-
-	apic = kvm_apic_round_robin(kvm, vector, bitmap);
-	if (apic)
-		return apic->vcpu;
-	return NULL;
+	return vcpu1->arch.apic_arb_prio - vcpu2->arch.apic_arb_prio;
 }
 
 static void apic_set_eoi(struct kvm_lapic *apic)
@@ -908,6 +875,8 @@ void kvm_lapic_reset(struct kvm_vcpu *vcpu)
 		vcpu->arch.apic_base |= MSR_IA32_APICBASE_BSP;
 	apic_update_ppr(apic);
 
+	vcpu->arch.apic_arb_prio = 0;
+
 	apic_debug(KERN_INFO "%s: vcpu=%p, id=%d, base_msr="
 		   "0x%016" PRIx64 ", base_address=0x%0lx.\n", __func__,
 		   vcpu, kvm_apic_id(apic),
diff --git a/virt/kvm/ioapic.h b/virt/kvm/ioapic.h
index d996c7a..e7bc92d 100644
--- a/virt/kvm/ioapic.h
+++ b/virt/kvm/ioapic.h
@@ -64,10 +64,9 @@ static inline struct kvm_ioapic *ioapic_irqchip(struct kvm *kvm)
 	return kvm->arch.vioapic;
 }
 
-struct kvm_vcpu *kvm_get_lowest_prio_vcpu(struct kvm *kvm, u8 vector,
-		unsigned long *bitmap);
 int kvm_apic_match_dest(struct kvm_vcpu *vcpu, struct kvm_lapic *source,
 		int short_hand, int dest, int dest_mode);
+int kvm_apic_compare_prio(struct kvm_vcpu *vcpu1, struct kvm_vcpu *vcpu2);
 void kvm_ioapic_update_eoi(struct kvm *kvm, int vector, int trigger_mode);
 int kvm_ioapic_init(struct kvm *kvm);
 int kvm_ioapic_set_irq(struct kvm_ioapic *ioapic, int irq, int level);
diff --git a/virt/kvm/irq_comm.c b/virt/kvm/irq_comm.c
index e43701c..f5e059b 100644
--- a/virt/kvm/irq_comm.c
+++ b/virt/kvm/irq_comm.c
@@ -47,7 +47,7 @@ void kvm_get_intr_delivery_bitmask(struct kvm *kvm, struct kvm_lapic *src,
 		int dest_id, int dest_mode, bool low_prio, int short_hand,
 		unsigned long *deliver_bitmask)
 {
-	int i;
+	int i, lowest = -1;
 	struct kvm_vcpu *vcpu;
 
 	if (dest_mode == 0 && dest_id == 0xff && low_prio)
@@ -64,15 +64,18 @@ void kvm_get_intr_delivery_bitmask(struct kvm *kvm, struct kvm_lapic *src,
 					dest_mode))
 			continue;
 
-		__set_bit(i, deliver_bitmask);
+		if (!low_prio) {
+			__set_bit(i, deliver_bitmask);
+		} else {
+			if (lowest < 0)
+				lowest = i;
+			if (kvm_apic_compare_prio(vcpu, kvm->vcpus[lowest]) < 0)
+				lowest = i;
+		}
 	}
 
-	if (low_prio) {
-		vcpu = kvm_get_lowest_prio_vcpu(kvm, 0, deliver_bitmask);
-		bitmap_zero(deliver_bitmask, KVM_MAX_VCPUS);
-		if (vcpu)
-			__set_bit(vcpu->vcpu_id, deliver_bitmask);
-	}
+	if (lowest != -1)
+		__set_bit(lowest, deliver_bitmask);
 }
 
 static int kvm_set_msi(struct kvm_kernel_irq_routing_entry *e,
-- 
1.6.0.6

