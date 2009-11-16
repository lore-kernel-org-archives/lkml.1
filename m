Return-Path: <linux-kernel-owner+w=401wt.eu-S1753622AbZKPMVA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753622AbZKPMVA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Nov 2009 07:21:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753576AbZKPMU4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Nov 2009 07:20:56 -0500
Received: from mx1.redhat.com ([209.132.183.28]:30732 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752797AbZKPMTl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Nov 2009 07:19:41 -0500
From: Avi Kivity <avi@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: kvm@vger.kernel.org
Subject: [PATCH 09/42] KVM: Move irq sharing information to irqchip level
Date: Mon, 16 Nov 2009 14:19:10 +0200
Message-Id: <1258373983-8693-10-git-send-email-avi@redhat.com>
In-Reply-To: <1258373983-8693-1-git-send-email-avi@redhat.com>
References: <1258373983-8693-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Gleb Natapov <gleb@redhat.com>

This removes assumptions that max GSIs is smaller than number of pins.
Sharing is tracked on pin level not GSI level.

[avi: no PIC on ia64]

Signed-off-by: Gleb Natapov <gleb@redhat.com>
Signed-off-by: Avi Kivity <avi@redhat.com>
---
 arch/x86/include/asm/kvm_host.h |    1 -
 arch/x86/kvm/irq.h              |    1 +
 include/linux/kvm_host.h        |    2 +-
 virt/kvm/ioapic.h               |    1 +
 virt/kvm/irq_comm.c             |   59 +++++++++++++++++++++++---------------
 5 files changed, 39 insertions(+), 25 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 0b113f2..35d3236 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -410,7 +410,6 @@ struct kvm_arch{
 	gpa_t ept_identity_map_addr;
 
 	unsigned long irq_sources_bitmap;
-	unsigned long irq_states[KVM_IOAPIC_NUM_PINS];
 	u64 vm_init_tsc;
 };
 
diff --git a/arch/x86/kvm/irq.h b/arch/x86/kvm/irq.h
index 7d6058a..c025a23 100644
--- a/arch/x86/kvm/irq.h
+++ b/arch/x86/kvm/irq.h
@@ -71,6 +71,7 @@ struct kvm_pic {
 	int output;		/* intr from master PIC */
 	struct kvm_io_device dev;
 	void (*ack_notifier)(void *opaque, int irq);
+	unsigned long irq_states[16];
 };
 
 struct kvm_pic *kvm_create_pic(struct kvm *kvm);
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index b7bbb5d..1c7f8c4 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -120,7 +120,7 @@ struct kvm_kernel_irq_routing_entry {
 	u32 gsi;
 	u32 type;
 	int (*set)(struct kvm_kernel_irq_routing_entry *e,
-		    struct kvm *kvm, int level);
+		   struct kvm *kvm, int irq_source_id, int level);
 	union {
 		struct {
 			unsigned irqchip;
diff --git a/virt/kvm/ioapic.h b/virt/kvm/ioapic.h
index 7080b71..6e461ad 100644
--- a/virt/kvm/ioapic.h
+++ b/virt/kvm/ioapic.h
@@ -41,6 +41,7 @@ struct kvm_ioapic {
 	u32 irr;
 	u32 pad;
 	union kvm_ioapic_redirect_entry redirtbl[IOAPIC_NUM_PINS];
+	unsigned long irq_states[IOAPIC_NUM_PINS];
 	struct kvm_io_device dev;
 	struct kvm *kvm;
 	void (*ack_notifier)(void *opaque, int irq);
diff --git a/virt/kvm/irq_comm.c b/virt/kvm/irq_comm.c
index 001663f..9783f5c 100644
--- a/virt/kvm/irq_comm.c
+++ b/virt/kvm/irq_comm.c
@@ -31,20 +31,39 @@
 
 #include "ioapic.h"
 
+static inline int kvm_irq_line_state(unsigned long *irq_state,
+				     int irq_source_id, int level)
+{
+	/* Logical OR for level trig interrupt */
+	if (level)
+		set_bit(irq_source_id, irq_state);
+	else
+		clear_bit(irq_source_id, irq_state);
+
+	return !!(*irq_state);
+}
+
 static int kvm_set_pic_irq(struct kvm_kernel_irq_routing_entry *e,
-			   struct kvm *kvm, int level)
+			   struct kvm *kvm, int irq_source_id, int level)
 {
 #ifdef CONFIG_X86
-	return kvm_pic_set_irq(pic_irqchip(kvm), e->irqchip.pin, level);
+	struct kvm_pic *pic = pic_irqchip(kvm);
+	level = kvm_irq_line_state(&pic->irq_states[e->irqchip.pin],
+				   irq_source_id, level);
+	return kvm_pic_set_irq(pic, e->irqchip.pin, level);
 #else
 	return -1;
 #endif
 }
 
 static int kvm_set_ioapic_irq(struct kvm_kernel_irq_routing_entry *e,
-			      struct kvm *kvm, int level)
+			      struct kvm *kvm, int irq_source_id, int level)
 {
-	return kvm_ioapic_set_irq(kvm->arch.vioapic, e->irqchip.pin, level);
+	struct kvm_ioapic *ioapic = kvm->arch.vioapic;
+	level = kvm_irq_line_state(&ioapic->irq_states[e->irqchip.pin],
+				   irq_source_id, level);
+
+	return kvm_ioapic_set_irq(ioapic, e->irqchip.pin, level);
 }
 
 inline static bool kvm_is_dm_lowest_prio(struct kvm_lapic_irq *irq)
@@ -96,10 +115,13 @@ int kvm_irq_delivery_to_apic(struct kvm *kvm, struct kvm_lapic *src,
 }
 
 static int kvm_set_msi(struct kvm_kernel_irq_routing_entry *e,
-		       struct kvm *kvm, int level)
+		       struct kvm *kvm, int irq_source_id, int level)
 {
 	struct kvm_lapic_irq irq;
 
+	if (!level)
+		return -1;
+
 	trace_kvm_msi_set_irq(e->msi.address_lo, e->msi.data);
 
 	irq.dest_id = (e->msi.address_lo &
@@ -125,34 +147,19 @@ static int kvm_set_msi(struct kvm_kernel_irq_routing_entry *e,
 int kvm_set_irq(struct kvm *kvm, int irq_source_id, int irq, int level)
 {
 	struct kvm_kernel_irq_routing_entry *e;
-	unsigned long *irq_state, sig_level;
 	int ret = -1;
 
 	trace_kvm_set_irq(irq, level, irq_source_id);
 
 	WARN_ON(!mutex_is_locked(&kvm->irq_lock));
 
-	if (irq < KVM_IOAPIC_NUM_PINS) {
-		irq_state = (unsigned long *)&kvm->arch.irq_states[irq];
-
-		/* Logical OR for level trig interrupt */
-		if (level)
-			set_bit(irq_source_id, irq_state);
-		else
-			clear_bit(irq_source_id, irq_state);
-		sig_level = !!(*irq_state);
-	} else if (!level)
-		return ret;
-	else /* Deal with MSI/MSI-X */
-		sig_level = 1;
-
 	/* Not possible to detect if the guest uses the PIC or the
 	 * IOAPIC.  So set the bit in both. The guest will ignore
 	 * writes to the unused one.
 	 */
 	list_for_each_entry(e, &kvm->irq_routing, link)
 		if (e->gsi == irq) {
-			int r = e->set(e, kvm, sig_level);
+			int r = e->set(e, kvm, irq_source_id, level);
 			if (r < 0)
 				continue;
 
@@ -232,8 +239,14 @@ void kvm_free_irq_source_id(struct kvm *kvm, int irq_source_id)
 		printk(KERN_ERR "kvm: IRQ source ID out of range!\n");
 		return;
 	}
-	for (i = 0; i < KVM_IOAPIC_NUM_PINS; i++)
-		clear_bit(irq_source_id, &kvm->arch.irq_states[i]);
+	for (i = 0; i < KVM_IOAPIC_NUM_PINS; i++) {
+		clear_bit(irq_source_id, &kvm->arch.vioapic->irq_states[i]);
+		if (i >= 16)
+			continue;
+#ifdef CONFIG_X86
+		clear_bit(irq_source_id, &pic_irqchip(kvm)->irq_states[i]);
+#endif
+	}
 	clear_bit(irq_source_id, &kvm->arch.irq_sources_bitmap);
 	mutex_unlock(&kvm->irq_lock);
 }
-- 
1.6.5.2

