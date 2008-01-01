Return-Path: <linux-kernel-owner+w=401wt.eu-S1756244AbYAAPm4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756244AbYAAPm4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jan 2008 10:42:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755372AbYAAPgj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Jan 2008 10:36:39 -0500
Received: from il.qumranet.com ([82.166.9.18]:33792 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754316AbYAAPg1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jan 2008 10:36:27 -0500
From: Avi Kivity <avi@qumranet.com>
To: linux-kernel@vger.kernel.org, kvm-devel@lists.sourceforge.net
Cc: Zhang Xiantao <xiantao.zhang@intel.com>
Subject: [PATCH 23/54] KVM: Replace kvm_lapic with kvm_vcpu in ioapic/lapic interface
Date: Tue,  1 Jan 2008 17:35:49 +0200
Message-Id: <1199201780-14001-24-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.3.7
In-Reply-To: <1199201780-14001-1-git-send-email-avi@qumranet.com>
References: <1199201780-14001-1-git-send-email-avi@qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Zhang Xiantao <xiantao.zhang@intel.com>

This patch replaces lapic structure with kvm_vcpu in ioapic.c, making ioapic
independent of the local apic, as required by ia64.

Signed-off-by: Zhang Xiantao <xiantao.zhang@intel.com>
Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 drivers/kvm/ioapic.c |   18 ++++++++----------
 drivers/kvm/irq.h    |    5 +++--
 drivers/kvm/lapic.c  |   23 ++++++++++++++++++-----
 3 files changed, 29 insertions(+), 17 deletions(-)

diff --git a/drivers/kvm/ioapic.c b/drivers/kvm/ioapic.c
index cf1d50b..3629867 100644
--- a/drivers/kvm/ioapic.c
+++ b/drivers/kvm/ioapic.c
@@ -136,7 +136,7 @@ static void ioapic_write_indirect(struct kvm_ioapic *ioapic, u32 val)
 }
 
 static void ioapic_inj_irq(struct kvm_ioapic *ioapic,
-			   struct kvm_lapic *target,
+			   struct kvm_vcpu *vcpu,
 			   u8 vector, u8 trig_mode, u8 delivery_mode)
 {
 	ioapic_debug("irq %d trig %d deliv %d\n", vector, trig_mode,
@@ -145,7 +145,7 @@ static void ioapic_inj_irq(struct kvm_ioapic *ioapic,
 	ASSERT((delivery_mode == dest_Fixed) ||
 	       (delivery_mode == dest_LowestPrio));
 
-	kvm_apic_set_irq(target, vector, trig_mode);
+	kvm_apic_set_irq(vcpu, vector, trig_mode);
 }
 
 static u32 ioapic_get_delivery_bitmask(struct kvm_ioapic *ioapic, u8 dest,
@@ -196,7 +196,6 @@ static void ioapic_deliver(struct kvm_ioapic *ioapic, int irq)
 	u8 vector = ioapic->redirtbl[irq].fields.vector;
 	u8 trig_mode = ioapic->redirtbl[irq].fields.trig_mode;
 	u32 deliver_bitmask;
-	struct kvm_lapic *target;
 	struct kvm_vcpu *vcpu;
 	int vcpu_id;
 
@@ -212,13 +211,13 @@ static void ioapic_deliver(struct kvm_ioapic *ioapic, int irq)
 
 	switch (delivery_mode) {
 	case dest_LowestPrio:
-		target =
-		    kvm_apic_round_robin(ioapic->kvm, vector, deliver_bitmask);
-		if (target != NULL)
-			ioapic_inj_irq(ioapic, target, vector,
+		vcpu = kvm_get_lowest_prio_vcpu(ioapic->kvm, vector,
+				deliver_bitmask);
+		if (vcpu != NULL)
+			ioapic_inj_irq(ioapic, vcpu, vector,
 				       trig_mode, delivery_mode);
 		else
-			ioapic_debug("null round robin: "
+			ioapic_debug("null lowest prio vcpu: "
 				     "mask=%x vector=%x delivery_mode=%x\n",
 				     deliver_bitmask, vector, dest_LowestPrio);
 		break;
@@ -229,8 +228,7 @@ static void ioapic_deliver(struct kvm_ioapic *ioapic, int irq)
 			deliver_bitmask &= ~(1 << vcpu_id);
 			vcpu = ioapic->kvm->vcpus[vcpu_id];
 			if (vcpu) {
-				target = vcpu->apic;
-				ioapic_inj_irq(ioapic, target, vector,
+				ioapic_inj_irq(ioapic, vcpu, vector,
 					       trig_mode, delivery_mode);
 			}
 		}
diff --git a/drivers/kvm/irq.h b/drivers/kvm/irq.h
index 5ad3cfd..78a34dd 100644
--- a/drivers/kvm/irq.h
+++ b/drivers/kvm/irq.h
@@ -145,14 +145,15 @@ void kvm_free_lapic(struct kvm_vcpu *vcpu);
 u64 kvm_lapic_get_cr8(struct kvm_vcpu *vcpu);
 void kvm_lapic_set_tpr(struct kvm_vcpu *vcpu, unsigned long cr8);
 void kvm_lapic_set_base(struct kvm_vcpu *vcpu, u64 value);
-struct kvm_lapic *kvm_apic_round_robin(struct kvm *kvm, u8 vector,
+
+struct kvm_vcpu *kvm_get_lowest_prio_vcpu(struct kvm *kvm, u8 vector,
 				       unsigned long bitmap);
 u64 kvm_get_apic_base(struct kvm_vcpu *vcpu);
 void kvm_set_apic_base(struct kvm_vcpu *vcpu, u64 data);
 int kvm_apic_match_physical_addr(struct kvm_lapic *apic, u16 dest);
 void kvm_ioapic_update_eoi(struct kvm *kvm, int vector);
 int kvm_apic_match_logical_addr(struct kvm_lapic *apic, u8 mda);
-int kvm_apic_set_irq(struct kvm_lapic *apic, u8 vec, u8 trig);
+int kvm_apic_set_irq(struct kvm_vcpu *vcpu, u8 vec, u8 trig);
 void kvm_apic_post_state_restore(struct kvm_vcpu *vcpu);
 int kvm_ioapic_init(struct kvm *kvm);
 void kvm_ioapic_set_irq(struct kvm_ioapic *ioapic, int irq, int level);
diff --git a/drivers/kvm/lapic.c b/drivers/kvm/lapic.c
index 64f74bd..5efa6c0 100644
--- a/drivers/kvm/lapic.c
+++ b/drivers/kvm/lapic.c
@@ -185,8 +185,10 @@ int kvm_lapic_find_highest_irr(struct kvm_vcpu *vcpu)
 }
 EXPORT_SYMBOL_GPL(kvm_lapic_find_highest_irr);
 
-int kvm_apic_set_irq(struct kvm_lapic *apic, u8 vec, u8 trig)
+int kvm_apic_set_irq(struct kvm_vcpu *vcpu, u8 vec, u8 trig)
 {
+	struct kvm_lapic *apic = vcpu->apic;
+
 	if (!apic_test_and_set_irr(vec, apic)) {
 		/* a new pending irq is set in IRR */
 		if (trig)
@@ -394,7 +396,7 @@ static int __apic_accept_irq(struct kvm_lapic *apic, int delivery_mode,
 	return result;
 }
 
-struct kvm_lapic *kvm_apic_round_robin(struct kvm *kvm, u8 vector,
+static struct kvm_lapic *kvm_apic_round_robin(struct kvm *kvm, u8 vector,
 				       unsigned long bitmap)
 {
 	int last;
@@ -422,6 +424,17 @@ struct kvm_lapic *kvm_apic_round_robin(struct kvm *kvm, u8 vector,
 	return apic;
 }
 
+struct kvm_vcpu *kvm_get_lowest_prio_vcpu(struct kvm *kvm, u8 vector,
+		unsigned long bitmap)
+{
+	struct kvm_lapic *apic;
+
+	apic = kvm_apic_round_robin(kvm, vector, bitmap);
+	if (apic)
+		return apic->vcpu;
+	return NULL;
+}
+
 static void apic_set_eoi(struct kvm_lapic *apic)
 {
 	int vector = apic_find_highest_isr(apic);
@@ -453,7 +466,7 @@ static void apic_send_ipi(struct kvm_lapic *apic)
 	unsigned int delivery_mode = icr_low & APIC_MODE_MASK;
 	unsigned int vector = icr_low & APIC_VECTOR_MASK;
 
-	struct kvm_lapic *target;
+	struct kvm_vcpu *target;
 	struct kvm_vcpu *vcpu;
 	unsigned long lpr_map = 0;
 	int i;
@@ -480,9 +493,9 @@ static void apic_send_ipi(struct kvm_lapic *apic)
 	}
 
 	if (delivery_mode == APIC_DM_LOWEST) {
-		target = kvm_apic_round_robin(vcpu->kvm, vector, lpr_map);
+		target = kvm_get_lowest_prio_vcpu(vcpu->kvm, vector, lpr_map);
 		if (target != NULL)
-			__apic_accept_irq(target, delivery_mode,
+			__apic_accept_irq(target->apic, delivery_mode,
 					  vector, level, trig_mode);
 	}
 }
-- 
1.5.3.7

