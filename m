Return-Path: <linux-kernel-owner+w=401wt.eu-S1757141AbZERJ2M@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757141AbZERJ2M (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 May 2009 05:28:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755078AbZERJXZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 May 2009 05:23:25 -0400
Received: from mx2.redhat.com ([66.187.237.31]:38401 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752592AbZERJXI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 May 2009 05:23:08 -0400
From: Avi Kivity <avi@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: kvm@vger.kernel.org
Subject: [PATCH 07/43] KVM: bit ops for deliver_bitmap
Date: Mon, 18 May 2009 12:22:29 +0300
Message-Id: <1242638585-18470-8-git-send-email-avi@redhat.com>
In-Reply-To: <1242638585-18470-1-git-send-email-avi@redhat.com>
References: <1242638585-18470-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sheng Yang <sheng@linux.intel.com>

It's also convenient when we extend KVM supported vcpu number in the future.

Signed-off-by: Sheng Yang <sheng@linux.intel.com>
Signed-off-by: Avi Kivity <avi@redhat.com>
---
 arch/x86/kvm/lapic.c |    7 ++++---
 virt/kvm/ioapic.c    |   24 +++++++++++++-----------
 virt/kvm/irq_comm.c  |   17 +++++++++--------
 3 files changed, 26 insertions(+), 22 deletions(-)

diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index 6aa8d20..afc59b2 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -483,9 +483,10 @@ static void apic_send_ipi(struct kvm_lapic *apic)
 
 	struct kvm_vcpu *target;
 	struct kvm_vcpu *vcpu;
-	unsigned long lpr_map = 0;
+	DECLARE_BITMAP(lpr_map, KVM_MAX_VCPUS);
 	int i;
 
+	bitmap_zero(lpr_map, KVM_MAX_VCPUS);
 	apic_debug("icr_high 0x%x, icr_low 0x%x, "
 		   "short_hand 0x%x, dest 0x%x, trig_mode 0x%x, level 0x%x, "
 		   "dest_mode 0x%x, delivery_mode 0x%x, vector 0x%x\n",
@@ -500,7 +501,7 @@ static void apic_send_ipi(struct kvm_lapic *apic)
 		if (vcpu->arch.apic &&
 		    apic_match_dest(vcpu, apic, short_hand, dest, dest_mode)) {
 			if (delivery_mode == APIC_DM_LOWEST)
-				set_bit(vcpu->vcpu_id, &lpr_map);
+				__set_bit(vcpu->vcpu_id, lpr_map);
 			else
 				__apic_accept_irq(vcpu->arch.apic, delivery_mode,
 						  vector, level, trig_mode);
@@ -508,7 +509,7 @@ static void apic_send_ipi(struct kvm_lapic *apic)
 	}
 
 	if (delivery_mode == APIC_DM_LOWEST) {
-		target = kvm_get_lowest_prio_vcpu(vcpu->kvm, vector, &lpr_map);
+		target = kvm_get_lowest_prio_vcpu(vcpu->kvm, vector, lpr_map);
 		if (target != NULL)
 			__apic_accept_irq(target->arch.apic, delivery_mode,
 					  vector, level, trig_mode);
diff --git a/virt/kvm/ioapic.c b/virt/kvm/ioapic.c
index 3b53712..7c2cb2b 100644
--- a/virt/kvm/ioapic.c
+++ b/virt/kvm/ioapic.c
@@ -203,7 +203,7 @@ void kvm_ioapic_get_delivery_bitmask(struct kvm_ioapic *ioapic, u8 dest,
 static int ioapic_deliver(struct kvm_ioapic *ioapic, int irq)
 {
 	union kvm_ioapic_redirect_entry entry = ioapic->redirtbl[irq];
-	unsigned long deliver_bitmask;
+	DECLARE_BITMAP(deliver_bitmask, KVM_MAX_VCPUS);
 	struct kvm_vcpu *vcpu;
 	int vcpu_id, r = -1;
 
@@ -213,22 +213,24 @@ static int ioapic_deliver(struct kvm_ioapic *ioapic, int irq)
 		     entry.fields.delivery_mode, entry.fields.vector,
 		     entry.fields.trig_mode);
 
-	kvm_get_intr_delivery_bitmask(ioapic, &entry, &deliver_bitmask);
-	if (!deliver_bitmask) {
-		ioapic_debug("no target on destination\n");
-		return 0;
-	}
+	bitmap_zero(deliver_bitmask, KVM_MAX_VCPUS);
 
 	/* Always delivery PIT interrupt to vcpu 0 */
 #ifdef CONFIG_X86
 	if (irq == 0)
-		deliver_bitmask = 1;
+		__set_bit(0, deliver_bitmask);
+	else
 #endif
+		kvm_get_intr_delivery_bitmask(ioapic, &entry, deliver_bitmask);
+
+	if (find_first_bit(deliver_bitmask, KVM_MAX_VCPUS) >= KVM_MAX_VCPUS) {
+		ioapic_debug("no target on destination\n");
+		return 0;
+	}
 
-	for (vcpu_id = 0; deliver_bitmask != 0; vcpu_id++) {
-		if (!(deliver_bitmask & (1 << vcpu_id)))
-			continue;
-		deliver_bitmask &= ~(1 << vcpu_id);
+	while ((vcpu_id = find_first_bit(deliver_bitmask, KVM_MAX_VCPUS))
+			< KVM_MAX_VCPUS) {
+		__clear_bit(vcpu_id, deliver_bitmask);
 		vcpu = ioapic->kvm->vcpus[vcpu_id];
 		if (vcpu) {
 			if (entry.fields.delivery_mode ==
diff --git a/virt/kvm/irq_comm.c b/virt/kvm/irq_comm.c
index d4421cd..d165e05 100644
--- a/virt/kvm/irq_comm.c
+++ b/virt/kvm/irq_comm.c
@@ -56,7 +56,7 @@ void kvm_get_intr_delivery_bitmask(struct kvm_ioapic *ioapic,
 	case IOAPIC_LOWEST_PRIORITY:
 		vcpu = kvm_get_lowest_prio_vcpu(ioapic->kvm,
 				entry->fields.vector, deliver_bitmask);
-		*deliver_bitmask = 1 << vcpu->vcpu_id;
+		__set_bit(vcpu->vcpu_id, deliver_bitmask);
 		break;
 	case IOAPIC_FIXED:
 	case IOAPIC_NMI:
@@ -76,10 +76,12 @@ static int kvm_set_msi(struct kvm_kernel_irq_routing_entry *e,
 	struct kvm_vcpu *vcpu;
 	struct kvm_ioapic *ioapic = ioapic_irqchip(kvm);
 	union kvm_ioapic_redirect_entry entry;
-	unsigned long deliver_bitmask;
+	DECLARE_BITMAP(deliver_bitmask, KVM_MAX_VCPUS);
 
 	BUG_ON(!ioapic);
 
+	bitmap_zero(deliver_bitmask, KVM_MAX_VCPUS);
+
 	entry.bits = 0;
 	entry.fields.dest_id = (e->msi.address_lo &
 			MSI_ADDR_DEST_ID_MASK) >> MSI_ADDR_DEST_ID_SHIFT;
@@ -95,16 +97,15 @@ static int kvm_set_msi(struct kvm_kernel_irq_routing_entry *e,
 
 	/* TODO Deal with RH bit of MSI message address */
 
-	kvm_get_intr_delivery_bitmask(ioapic, &entry, &deliver_bitmask);
+	kvm_get_intr_delivery_bitmask(ioapic, &entry, deliver_bitmask);
 
-	if (!deliver_bitmask) {
+	if (find_first_bit(deliver_bitmask, KVM_MAX_VCPUS) >= KVM_MAX_VCPUS) {
 		printk(KERN_WARNING "kvm: no destination for MSI delivery!");
 		return -1;
 	}
-	for (vcpu_id = 0; deliver_bitmask != 0; vcpu_id++) {
-		if (!(deliver_bitmask & (1 << vcpu_id)))
-			continue;
-		deliver_bitmask &= ~(1 << vcpu_id);
+	while ((vcpu_id = find_first_bit(deliver_bitmask,
+					KVM_MAX_VCPUS)) < KVM_MAX_VCPUS) {
+		__clear_bit(vcpu_id, deliver_bitmask);
 		vcpu = ioapic->kvm->vcpus[vcpu_id];
 		if (vcpu) {
 			if (r < 0)
-- 
1.6.0.6

