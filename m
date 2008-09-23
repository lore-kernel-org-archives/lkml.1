Return-Path: <linux-kernel-owner+w=401wt.eu-S1755418AbYIWNzz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755418AbYIWNzz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2008 09:55:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752626AbYIWNr6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Sep 2008 09:47:58 -0400
Received: from mx2.redhat.com ([66.187.237.31]:52432 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753665AbYIWNrv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2008 09:47:51 -0400
From: Avi Kivity <avi@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: kvm@vger.kernel.org, Marcelo Tosatti <mtosatti@redhat.com>
Subject: [PATCH 31/40] KVM: irq ack notification
Date: Tue, 23 Sep 2008 16:46:45 +0300
Message-Id: <1222177614-26669-32-git-send-email-avi@redhat.com>
In-Reply-To: <1222177614-26669-1-git-send-email-avi@redhat.com>
References: <1222177614-26669-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Marcelo Tosatti <mtosatti@redhat.com>

Based on a patch from: Ben-Ami Yassour <benami@il.ibm.com>
which was based on a patch from: Amit Shah <amit.shah@qumranet.com>

Notify IRQ acking on PIC/APIC emulation. The previous patch missed two things:

- Edge triggered interrupts on IOAPIC
- PIC reset with IRR/ISR set should be equivalent to ack (LAPIC probably
needs something similar).

Signed-off-by: Marcelo Tosatti <mtosatti@redhat.com>
CC: Amit Shah <amit.shah@qumranet.com>
CC: Ben-Ami Yassour <benami@il.ibm.com>
Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 arch/x86/kvm/i8259.c |   12 +++++++++++-
 arch/x86/kvm/irq.c   |    2 +-
 arch/x86/kvm/irq.h   |    3 ++-
 arch/x86/kvm/lapic.c |    7 +++++--
 virt/kvm/ioapic.c    |   20 +++++++++++++-------
 virt/kvm/ioapic.h    |    3 ++-
 6 files changed, 34 insertions(+), 13 deletions(-)

diff --git a/arch/x86/kvm/i8259.c b/arch/x86/kvm/i8259.c
index 55e179a..de70499 100644
--- a/arch/x86/kvm/i8259.c
+++ b/arch/x86/kvm/i8259.c
@@ -159,9 +159,10 @@ static inline void pic_intack(struct kvm_kpic_state *s, int irq)
 		s->irr &= ~(1 << irq);
 }
 
-int kvm_pic_read_irq(struct kvm_pic *s)
+int kvm_pic_read_irq(struct kvm *kvm)
 {
 	int irq, irq2, intno;
+	struct kvm_pic *s = pic_irqchip(kvm);
 
 	irq = pic_get_irq(&s->pics[0]);
 	if (irq >= 0) {
@@ -187,12 +188,21 @@ int kvm_pic_read_irq(struct kvm_pic *s)
 		intno = s->pics[0].irq_base + irq;
 	}
 	pic_update_irq(s);
+	kvm_notify_acked_irq(kvm, irq);
 
 	return intno;
 }
 
 void kvm_pic_reset(struct kvm_kpic_state *s)
 {
+	int irq;
+	struct kvm *kvm = s->pics_state->irq_request_opaque;
+
+	for (irq = 0; irq < PIC_NUM_PINS; irq++) {
+		if (!(s->imr & (1 << irq)) && (s->irr & (1 << irq) ||
+		    s->isr & (1 << irq)))
+			kvm_notify_acked_irq(kvm, irq);
+	}
 	s->last_irr = 0;
 	s->irr = 0;
 	s->imr = 0;
diff --git a/arch/x86/kvm/irq.c b/arch/x86/kvm/irq.c
index 9091195..3c508af 100644
--- a/arch/x86/kvm/irq.c
+++ b/arch/x86/kvm/irq.c
@@ -72,7 +72,7 @@ int kvm_cpu_get_interrupt(struct kvm_vcpu *v)
 		if (kvm_apic_accept_pic_intr(v)) {
 			s = pic_irqchip(v->kvm);
 			s->output = 0;		/* PIC */
-			vector = kvm_pic_read_irq(s);
+			vector = kvm_pic_read_irq(v->kvm);
 		}
 	}
 	return vector;
diff --git a/arch/x86/kvm/irq.h b/arch/x86/kvm/irq.h
index 95fe718..479a3d2 100644
--- a/arch/x86/kvm/irq.h
+++ b/arch/x86/kvm/irq.h
@@ -63,11 +63,12 @@ struct kvm_pic {
 	void *irq_request_opaque;
 	int output;		/* intr from master PIC */
 	struct kvm_io_device dev;
+	void (*ack_notifier)(void *opaque, int irq);
 };
 
 struct kvm_pic *kvm_create_pic(struct kvm *kvm);
 void kvm_pic_set_irq(void *opaque, int irq, int level);
-int kvm_pic_read_irq(struct kvm_pic *s);
+int kvm_pic_read_irq(struct kvm *kvm);
 void kvm_pic_update_irq(struct kvm_pic *s);
 
 static inline struct kvm_pic *pic_irqchip(struct kvm *kvm)
diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index 9fde0ac..be94f93 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -439,7 +439,7 @@ struct kvm_vcpu *kvm_get_lowest_prio_vcpu(struct kvm *kvm, u8 vector,
 static void apic_set_eoi(struct kvm_lapic *apic)
 {
 	int vector = apic_find_highest_isr(apic);
-
+	int trigger_mode;
 	/*
 	 * Not every write EOI will has corresponding ISR,
 	 * one example is when Kernel check timer on setup_IO_APIC
@@ -451,7 +451,10 @@ static void apic_set_eoi(struct kvm_lapic *apic)
 	apic_update_ppr(apic);
 
 	if (apic_test_and_clear_vector(vector, apic->regs + APIC_TMR))
-		kvm_ioapic_update_eoi(apic->vcpu->kvm, vector);
+		trigger_mode = IOAPIC_LEVEL_TRIG;
+	else
+		trigger_mode = IOAPIC_EDGE_TRIG;
+	kvm_ioapic_update_eoi(apic->vcpu->kvm, vector, trigger_mode);
 }
 
 static void apic_send_ipi(struct kvm_lapic *apic)
diff --git a/virt/kvm/ioapic.c b/virt/kvm/ioapic.c
index c0d2287..515cd7c 100644
--- a/virt/kvm/ioapic.c
+++ b/virt/kvm/ioapic.c
@@ -39,6 +39,7 @@
 
 #include "ioapic.h"
 #include "lapic.h"
+#include "irq.h"
 
 #if 0
 #define ioapic_debug(fmt,arg...) printk(KERN_WARNING fmt,##arg)
@@ -285,26 +286,31 @@ void kvm_ioapic_set_irq(struct kvm_ioapic *ioapic, int irq, int level)
 	}
 }
 
-static void __kvm_ioapic_update_eoi(struct kvm_ioapic *ioapic, int gsi)
+static void __kvm_ioapic_update_eoi(struct kvm_ioapic *ioapic, int gsi,
+				    int trigger_mode)
 {
 	union ioapic_redir_entry *ent;
 
 	ent = &ioapic->redirtbl[gsi];
-	ASSERT(ent->fields.trig_mode == IOAPIC_LEVEL_TRIG);
 
-	ent->fields.remote_irr = 0;
-	if (!ent->fields.mask && (ioapic->irr & (1 << gsi)))
-		ioapic_service(ioapic, gsi);
+	kvm_notify_acked_irq(ioapic->kvm, gsi);
+
+	if (trigger_mode == IOAPIC_LEVEL_TRIG) {
+		ASSERT(ent->fields.trig_mode == IOAPIC_LEVEL_TRIG);
+		ent->fields.remote_irr = 0;
+		if (!ent->fields.mask && (ioapic->irr & (1 << gsi)))
+			ioapic_service(ioapic, gsi);
+	}
 }
 
-void kvm_ioapic_update_eoi(struct kvm *kvm, int vector)
+void kvm_ioapic_update_eoi(struct kvm *kvm, int vector, int trigger_mode)
 {
 	struct kvm_ioapic *ioapic = kvm->arch.vioapic;
 	int i;
 
 	for (i = 0; i < IOAPIC_NUM_PINS; i++)
 		if (ioapic->redirtbl[i].fields.vector == vector)
-			__kvm_ioapic_update_eoi(ioapic, i);
+			__kvm_ioapic_update_eoi(ioapic, i, trigger_mode);
 }
 
 static int ioapic_in_range(struct kvm_io_device *this, gpa_t addr,
diff --git a/virt/kvm/ioapic.h b/virt/kvm/ioapic.h
index 7f16675..b52732f 100644
--- a/virt/kvm/ioapic.h
+++ b/virt/kvm/ioapic.h
@@ -58,6 +58,7 @@ struct kvm_ioapic {
 	} redirtbl[IOAPIC_NUM_PINS];
 	struct kvm_io_device dev;
 	struct kvm *kvm;
+	void (*ack_notifier)(void *opaque, int irq);
 };
 
 #ifdef DEBUG
@@ -87,7 +88,7 @@ static inline int irqchip_in_kernel(struct kvm *kvm)
 
 struct kvm_vcpu *kvm_get_lowest_prio_vcpu(struct kvm *kvm, u8 vector,
 				       unsigned long bitmap);
-void kvm_ioapic_update_eoi(struct kvm *kvm, int vector);
+void kvm_ioapic_update_eoi(struct kvm *kvm, int vector, int trigger_mode);
 int kvm_ioapic_init(struct kvm *kvm);
 void kvm_ioapic_set_irq(struct kvm_ioapic *ioapic, int irq, int level);
 void kvm_ioapic_reset(struct kvm_ioapic *ioapic);
-- 
1.6.0.1

