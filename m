Return-Path: <linux-kernel-owner+w=401wt.eu-S1756964AbZERJ1Q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756964AbZERJ1Q (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 May 2009 05:27:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754705AbZERJXW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 May 2009 05:23:22 -0400
Received: from mx2.redhat.com ([66.187.237.31]:38399 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752461AbZERJXI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 May 2009 05:23:08 -0400
From: Avi Kivity <avi@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: kvm@vger.kernel.org
Subject: [PATCH 05/43] KVM: Change API of kvm_ioapic_get_delivery_bitmask
Date: Mon, 18 May 2009 12:22:27 +0300
Message-Id: <1242638585-18470-6-git-send-email-avi@redhat.com>
In-Reply-To: <1242638585-18470-1-git-send-email-avi@redhat.com>
References: <1242638585-18470-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sheng Yang <sheng@linux.intel.com>

In order to use with bit ops.

Signed-off-by: Sheng Yang <sheng@linux.intel.com>
Signed-off-by: Avi Kivity <avi@redhat.com>
---
 virt/kvm/ioapic.c   |   17 ++++++++---------
 virt/kvm/ioapic.h   |    4 ++--
 virt/kvm/irq_comm.c |    5 +++--
 3 files changed, 13 insertions(+), 13 deletions(-)

diff --git a/virt/kvm/ioapic.c b/virt/kvm/ioapic.c
index 883fd0d..3b53712 100644
--- a/virt/kvm/ioapic.c
+++ b/virt/kvm/ioapic.c
@@ -161,22 +161,22 @@ static void ioapic_inj_nmi(struct kvm_vcpu *vcpu)
 	kvm_vcpu_kick(vcpu);
 }
 
-u32 kvm_ioapic_get_delivery_bitmask(struct kvm_ioapic *ioapic, u8 dest,
-				    u8 dest_mode)
+void kvm_ioapic_get_delivery_bitmask(struct kvm_ioapic *ioapic, u8 dest,
+				     u8 dest_mode, unsigned long *mask)
 {
-	u32 mask = 0;
 	int i;
 	struct kvm *kvm = ioapic->kvm;
 	struct kvm_vcpu *vcpu;
 
 	ioapic_debug("dest %d dest_mode %d\n", dest, dest_mode);
 
+	*mask = 0;
 	if (dest_mode == 0) {	/* Physical mode. */
 		if (dest == 0xFF) {	/* Broadcast. */
 			for (i = 0; i < KVM_MAX_VCPUS; ++i)
 				if (kvm->vcpus[i] && kvm->vcpus[i]->arch.apic)
-					mask |= 1 << i;
-			return mask;
+					*mask |= 1 << i;
+			return;
 		}
 		for (i = 0; i < KVM_MAX_VCPUS; ++i) {
 			vcpu = kvm->vcpus[i];
@@ -184,7 +184,7 @@ u32 kvm_ioapic_get_delivery_bitmask(struct kvm_ioapic *ioapic, u8 dest,
 				continue;
 			if (kvm_apic_match_physical_addr(vcpu->arch.apic, dest)) {
 				if (vcpu->arch.apic)
-					mask = 1 << i;
+					*mask = 1 << i;
 				break;
 			}
 		}
@@ -195,10 +195,9 @@ u32 kvm_ioapic_get_delivery_bitmask(struct kvm_ioapic *ioapic, u8 dest,
 				continue;
 			if (vcpu->arch.apic &&
 			    kvm_apic_match_logical_addr(vcpu->arch.apic, dest))
-				mask |= 1 << vcpu->vcpu_id;
+				*mask |= 1 << vcpu->vcpu_id;
 		}
-	ioapic_debug("mask %x\n", mask);
-	return mask;
+	ioapic_debug("mask %x\n", *mask);
 }
 
 static int ioapic_deliver(struct kvm_ioapic *ioapic, int irq)
diff --git a/virt/kvm/ioapic.h b/virt/kvm/ioapic.h
index 008ec87..f395798 100644
--- a/virt/kvm/ioapic.h
+++ b/virt/kvm/ioapic.h
@@ -70,7 +70,7 @@ void kvm_ioapic_update_eoi(struct kvm *kvm, int vector, int trigger_mode);
 int kvm_ioapic_init(struct kvm *kvm);
 int kvm_ioapic_set_irq(struct kvm_ioapic *ioapic, int irq, int level);
 void kvm_ioapic_reset(struct kvm_ioapic *ioapic);
-u32 kvm_ioapic_get_delivery_bitmask(struct kvm_ioapic *ioapic, u8 dest,
-				u8 dest_mode);
+void kvm_ioapic_get_delivery_bitmask(struct kvm_ioapic *ioapic, u8 dest,
+				     u8 dest_mode, unsigned long *mask);
 
 #endif
diff --git a/virt/kvm/irq_comm.c b/virt/kvm/irq_comm.c
index aec7a0d..e8ff89c 100644
--- a/virt/kvm/irq_comm.c
+++ b/virt/kvm/irq_comm.c
@@ -49,8 +49,9 @@ void kvm_get_intr_delivery_bitmask(struct kvm_ioapic *ioapic,
 {
 	struct kvm_vcpu *vcpu;
 
-	*deliver_bitmask = kvm_ioapic_get_delivery_bitmask(ioapic,
-				entry->fields.dest_id, entry->fields.dest_mode);
+	kvm_ioapic_get_delivery_bitmask(ioapic, entry->fields.dest_id,
+					entry->fields.dest_mode,
+					deliver_bitmask);
 	switch (entry->fields.delivery_mode) {
 	case IOAPIC_LOWEST_PRIORITY:
 		vcpu = kvm_get_lowest_prio_vcpu(ioapic->kvm,
-- 
1.6.0.6

