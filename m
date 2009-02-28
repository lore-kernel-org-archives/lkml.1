Return-Path: <linux-kernel-owner+w=401wt.eu-S1762610AbZB1Btj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762610AbZB1Btj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Feb 2009 20:49:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756498AbZB1BmZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Feb 2009 20:42:25 -0500
Received: from mx2.redhat.com ([66.187.237.31]:41770 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754539AbZB1Bl5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Feb 2009 20:41:57 -0500
From: Avi Kivity <avi@redhat.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 08/30] KVM: make irq ack notifications aware of routing table
Date: Sat, 28 Feb 2009 03:41:27 +0200
Message-Id: <1235785309-12835-9-git-send-email-avi@redhat.com>
In-Reply-To: <1235785309-12835-1-git-send-email-avi@redhat.com>
References: <1235785309-12835-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Marcelo Tosatti <mtosatti@redhat.com>

IRQ ack notifications assume an identity mapping between pin->gsi,
which might not be the case with, for example, HPET.

Translate before acking.

Signed-off-by: Marcelo Tosatti <mtosatti@redhat.com>
Acked-by: Gleb Natapov <gleb@redhat.com>
---
 arch/x86/kvm/i8259.c     |    5 +++--
 arch/x86/kvm/irq.h       |    2 ++
 include/linux/kvm_host.h |    2 +-
 virt/kvm/ioapic.c        |   10 +++++-----
 virt/kvm/irq_comm.c      |   13 ++++++++++---
 5 files changed, 21 insertions(+), 11 deletions(-)

diff --git a/arch/x86/kvm/i8259.c b/arch/x86/kvm/i8259.c
index 179dcb0..9316037 100644
--- a/arch/x86/kvm/i8259.c
+++ b/arch/x86/kvm/i8259.c
@@ -49,7 +49,8 @@ static void pic_unlock(struct kvm_pic *s)
 	spin_unlock(&s->lock);
 
 	while (acks) {
-		kvm_notify_acked_irq(kvm, __ffs(acks));
+		kvm_notify_acked_irq(kvm, SELECT_PIC(__ffs(acks)),
+				     __ffs(acks));
 		acks &= acks - 1;
 	}
 
@@ -232,7 +233,7 @@ int kvm_pic_read_irq(struct kvm *kvm)
 	}
 	pic_update_irq(s);
 	pic_unlock(s);
-	kvm_notify_acked_irq(kvm, irq);
+	kvm_notify_acked_irq(kvm, SELECT_PIC(irq), irq);
 
 	return intno;
 }
diff --git a/arch/x86/kvm/irq.h b/arch/x86/kvm/irq.h
index 82579ee..9f59318 100644
--- a/arch/x86/kvm/irq.h
+++ b/arch/x86/kvm/irq.h
@@ -32,6 +32,8 @@
 #include "lapic.h"
 
 #define PIC_NUM_PINS 16
+#define SELECT_PIC(irq) \
+	((irq) < 8 ? KVM_IRQCHIP_PIC_MASTER : KVM_IRQCHIP_PIC_SLAVE)
 
 struct kvm;
 struct kvm_vcpu;
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index ce285e0..c03a0a9 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -352,7 +352,7 @@ void kvm_unregister_irq_mask_notifier(struct kvm *kvm, int irq,
 void kvm_fire_mask_notifiers(struct kvm *kvm, int irq, bool mask);
 
 void kvm_set_irq(struct kvm *kvm, int irq_source_id, int irq, int level);
-void kvm_notify_acked_irq(struct kvm *kvm, unsigned gsi);
+void kvm_notify_acked_irq(struct kvm *kvm, unsigned irqchip, unsigned pin);
 void kvm_register_irq_ack_notifier(struct kvm *kvm,
 				   struct kvm_irq_ack_notifier *kian);
 void kvm_unregister_irq_ack_notifier(struct kvm_irq_ack_notifier *kian);
diff --git a/virt/kvm/ioapic.c b/virt/kvm/ioapic.c
index e85a2bc..1c986ac 100644
--- a/virt/kvm/ioapic.c
+++ b/virt/kvm/ioapic.c
@@ -293,20 +293,20 @@ void kvm_ioapic_set_irq(struct kvm_ioapic *ioapic, int irq, int level)
 	}
 }
 
-static void __kvm_ioapic_update_eoi(struct kvm_ioapic *ioapic, int gsi,
+static void __kvm_ioapic_update_eoi(struct kvm_ioapic *ioapic, int pin,
 				    int trigger_mode)
 {
 	union ioapic_redir_entry *ent;
 
-	ent = &ioapic->redirtbl[gsi];
+	ent = &ioapic->redirtbl[pin];
 
-	kvm_notify_acked_irq(ioapic->kvm, gsi);
+	kvm_notify_acked_irq(ioapic->kvm, KVM_IRQCHIP_IOAPIC, pin);
 
 	if (trigger_mode == IOAPIC_LEVEL_TRIG) {
 		ASSERT(ent->fields.trig_mode == IOAPIC_LEVEL_TRIG);
 		ent->fields.remote_irr = 0;
-		if (!ent->fields.mask && (ioapic->irr & (1 << gsi)))
-			ioapic_service(ioapic, gsi);
+		if (!ent->fields.mask && (ioapic->irr & (1 << pin)))
+			ioapic_service(ioapic, pin);
 	}
 }
 
diff --git a/virt/kvm/irq_comm.c b/virt/kvm/irq_comm.c
index a797fa5..7aa5086 100644
--- a/virt/kvm/irq_comm.c
+++ b/virt/kvm/irq_comm.c
@@ -59,10 +59,19 @@ void kvm_set_irq(struct kvm *kvm, int irq_source_id, int irq, int level)
 			e->set(e, kvm, !!(*irq_state));
 }
 
-void kvm_notify_acked_irq(struct kvm *kvm, unsigned gsi)
+void kvm_notify_acked_irq(struct kvm *kvm, unsigned irqchip, unsigned pin)
 {
+	struct kvm_kernel_irq_routing_entry *e;
 	struct kvm_irq_ack_notifier *kian;
 	struct hlist_node *n;
+	unsigned gsi = pin;
+
+	list_for_each_entry(e, &kvm->irq_routing, link)
+		if (e->irqchip.irqchip == irqchip &&
+		    e->irqchip.pin == pin) {
+			gsi = e->gsi;
+			break;
+		}
 
 	hlist_for_each_entry(kian, n, &kvm->arch.irq_ack_notifier_list, link)
 		if (kian->gsi == gsi)
@@ -237,8 +246,6 @@ out:
 #define ROUTING_ENTRY1(irq) IOAPIC_ROUTING_ENTRY(irq)
 
 #ifdef CONFIG_X86
-#define SELECT_PIC(irq) \
-	((irq) < 8 ? KVM_IRQCHIP_PIC_MASTER : KVM_IRQCHIP_PIC_SLAVE)
 #  define PIC_ROUTING_ENTRY(irq) \
 	{ .gsi = irq, .type = KVM_IRQ_ROUTING_IRQCHIP,	\
 	  .u.irqchip.irqchip = SELECT_PIC(irq), .u.irqchip.pin = (irq) % 8 }
-- 
1.6.0.6

