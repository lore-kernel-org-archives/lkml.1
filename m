Return-Path: <linux-kernel-owner+w=401wt.eu-S1757825AbZERJdA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757825AbZERJdA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 May 2009 05:33:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756312AbZERJXu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 May 2009 05:23:50 -0400
Received: from mx2.redhat.com ([66.187.237.31]:38415 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753813AbZERJXK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 May 2009 05:23:10 -0400
From: Avi Kivity <avi@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: kvm@vger.kernel.org
Subject: [PATCH 21/43] KVM: ioapic/msi interrupt delivery consolidation
Date: Mon, 18 May 2009 12:22:43 +0300
Message-Id: <1242638585-18470-22-git-send-email-avi@redhat.com>
In-Reply-To: <1242638585-18470-1-git-send-email-avi@redhat.com>
References: <1242638585-18470-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Gleb Natapov <gleb@redhat.com>

ioapic_deliver() and kvm_set_msi() have code duplication. Move
the code into ioapic_deliver_entry() function and call it from
both places.

Signed-off-by: Gleb Natapov <gleb@redhat.com>
Signed-off-by: Marcelo Tosatti <mtosatti@redhat.com>
---
 include/linux/kvm_host.h |    2 +-
 virt/kvm/ioapic.c        |   61 ++++++++++++++++++++++++----------------------
 virt/kvm/ioapic.h        |    4 +-
 virt/kvm/irq_comm.c      |   32 ++----------------------
 4 files changed, 38 insertions(+), 61 deletions(-)

diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 3b91ec9..ec9d078 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -364,7 +364,7 @@ void kvm_unregister_irq_mask_notifier(struct kvm *kvm, int irq,
 void kvm_fire_mask_notifiers(struct kvm *kvm, int irq, bool mask);
 
 #ifdef __KVM_HAVE_IOAPIC
-void kvm_get_intr_delivery_bitmask(struct kvm_ioapic *ioapic,
+void kvm_get_intr_delivery_bitmask(struct kvm *kvm,
 				   union kvm_ioapic_redirect_entry *entry,
 				   unsigned long *deliver_bitmask);
 #endif
diff --git a/virt/kvm/ioapic.c b/virt/kvm/ioapic.c
index d4a7948..b71c044 100644
--- a/virt/kvm/ioapic.c
+++ b/virt/kvm/ioapic.c
@@ -142,54 +142,57 @@ static void ioapic_write_indirect(struct kvm_ioapic *ioapic, u32 val)
 	}
 }
 
-static int ioapic_deliver(struct kvm_ioapic *ioapic, int irq)
+int ioapic_deliver_entry(struct kvm *kvm, union kvm_ioapic_redirect_entry *e)
 {
-	union kvm_ioapic_redirect_entry entry = ioapic->redirtbl[irq];
 	DECLARE_BITMAP(deliver_bitmask, KVM_MAX_VCPUS);
-	struct kvm_vcpu *vcpu;
-	int vcpu_id, r = -1;
+	int i, r = -1;
 
-	ioapic_debug("dest=%x dest_mode=%x delivery_mode=%x "
-		     "vector=%x trig_mode=%x\n",
-		     entry.fields.dest, entry.fields.dest_mode,
-		     entry.fields.delivery_mode, entry.fields.vector,
-		     entry.fields.trig_mode);
-
-	/* Always delivery PIT interrupt to vcpu 0 */
-#ifdef CONFIG_X86
-	if (irq == 0) {
-                bitmap_zero(deliver_bitmask, KVM_MAX_VCPUS);
-		__set_bit(0, deliver_bitmask);
-        } else
-#endif
-		kvm_get_intr_delivery_bitmask(ioapic, &entry, deliver_bitmask);
+	kvm_get_intr_delivery_bitmask(kvm, e, deliver_bitmask);
 
 	if (find_first_bit(deliver_bitmask, KVM_MAX_VCPUS) >= KVM_MAX_VCPUS) {
 		ioapic_debug("no target on destination\n");
-		return 0;
+		return r;
 	}
 
-	while ((vcpu_id = find_first_bit(deliver_bitmask, KVM_MAX_VCPUS))
+	while ((i = find_first_bit(deliver_bitmask, KVM_MAX_VCPUS))
 			< KVM_MAX_VCPUS) {
-		__clear_bit(vcpu_id, deliver_bitmask);
-		vcpu = ioapic->kvm->vcpus[vcpu_id];
+		struct kvm_vcpu *vcpu = kvm->vcpus[i];
+		__clear_bit(i, deliver_bitmask);
 		if (vcpu) {
 			if (r < 0)
 				r = 0;
-			r += kvm_apic_set_irq(vcpu,
-					entry.fields.vector,
-					entry.fields.trig_mode,
-					entry.fields.delivery_mode);
+			r += kvm_apic_set_irq(vcpu, e->fields.vector,
+					e->fields.delivery_mode,
+					e->fields.trig_mode);
 		} else
 			ioapic_debug("null destination vcpu: "
 				     "mask=%x vector=%x delivery_mode=%x\n",
-				     entry.fields.deliver_bitmask,
-				     entry.fields.vector,
-				     entry.fields.delivery_mode);
+				     e->fields.deliver_bitmask,
+				     e->fields.vector, e->fields.delivery_mode);
 	}
 	return r;
 }
 
+static int ioapic_deliver(struct kvm_ioapic *ioapic, int irq)
+{
+	union kvm_ioapic_redirect_entry entry = ioapic->redirtbl[irq];
+
+	ioapic_debug("dest=%x dest_mode=%x delivery_mode=%x "
+		     "vector=%x trig_mode=%x\n",
+		     entry.fields.dest, entry.fields.dest_mode,
+		     entry.fields.delivery_mode, entry.fields.vector,
+		     entry.fields.trig_mode);
+
+#ifdef CONFIG_X86
+	/* Always delivery PIT interrupt to vcpu 0 */
+	if (irq == 0) {
+		entry.fields.dest_mode = 0; /* Physical mode. */
+		entry.fields.dest_id = ioapic->kvm->vcpus[0]->vcpu_id;
+	}
+#endif
+	return ioapic_deliver_entry(ioapic->kvm, &entry);
+}
+
 int kvm_ioapic_set_irq(struct kvm_ioapic *ioapic, int irq, int level)
 {
 	u32 old_irr = ioapic->irr;
diff --git a/virt/kvm/ioapic.h b/virt/kvm/ioapic.h
index c8032ab..bedeea5 100644
--- a/virt/kvm/ioapic.h
+++ b/virt/kvm/ioapic.h
@@ -70,8 +70,8 @@ void kvm_ioapic_update_eoi(struct kvm *kvm, int vector, int trigger_mode);
 int kvm_ioapic_init(struct kvm *kvm);
 int kvm_ioapic_set_irq(struct kvm_ioapic *ioapic, int irq, int level);
 void kvm_ioapic_reset(struct kvm_ioapic *ioapic);
-void kvm_get_intr_delivery_bitmask(struct kvm_ioapic *ioapic,
+void kvm_get_intr_delivery_bitmask(struct kvm *kvm,
 				   union kvm_ioapic_redirect_entry *entry,
 				   unsigned long *deliver_bitmask);
-
+int ioapic_deliver_entry(struct kvm *kvm, union kvm_ioapic_redirect_entry *e);
 #endif
diff --git a/virt/kvm/irq_comm.c b/virt/kvm/irq_comm.c
index 325c668..35397a5 100644
--- a/virt/kvm/irq_comm.c
+++ b/virt/kvm/irq_comm.c
@@ -43,12 +43,11 @@ static int kvm_set_ioapic_irq(struct kvm_kernel_irq_routing_entry *e,
 	return kvm_ioapic_set_irq(kvm->arch.vioapic, e->irqchip.pin, level);
 }
 
-void kvm_get_intr_delivery_bitmask(struct kvm_ioapic *ioapic,
+void kvm_get_intr_delivery_bitmask(struct kvm *kvm,
 				   union kvm_ioapic_redirect_entry *entry,
 				   unsigned long *deliver_bitmask)
 {
 	int i;
-	struct kvm *kvm = ioapic->kvm;
 	struct kvm_vcpu *vcpu;
 
 	bitmap_zero(deliver_bitmask, KVM_MAX_VCPUS);
@@ -90,7 +89,7 @@ void kvm_get_intr_delivery_bitmask(struct kvm_ioapic *ioapic,
 	switch (entry->fields.delivery_mode) {
 	case IOAPIC_LOWEST_PRIORITY:
 		/* Select one in deliver_bitmask */
-		vcpu = kvm_get_lowest_prio_vcpu(ioapic->kvm,
+		vcpu = kvm_get_lowest_prio_vcpu(kvm,
 				entry->fields.vector, deliver_bitmask);
 		bitmap_zero(deliver_bitmask, KVM_MAX_VCPUS);
 		if (!vcpu)
@@ -111,13 +110,7 @@ void kvm_get_intr_delivery_bitmask(struct kvm_ioapic *ioapic,
 static int kvm_set_msi(struct kvm_kernel_irq_routing_entry *e,
 		       struct kvm *kvm, int level)
 {
-	int vcpu_id, r = -1;
-	struct kvm_vcpu *vcpu;
-	struct kvm_ioapic *ioapic = ioapic_irqchip(kvm);
 	union kvm_ioapic_redirect_entry entry;
-	DECLARE_BITMAP(deliver_bitmask, KVM_MAX_VCPUS);
-
-	BUG_ON(!ioapic);
 
 	entry.bits = 0;
 	entry.fields.dest_id = (e->msi.address_lo &
@@ -133,26 +126,7 @@ static int kvm_set_msi(struct kvm_kernel_irq_routing_entry *e,
 			(unsigned long *)&e->msi.data);
 
 	/* TODO Deal with RH bit of MSI message address */
-
-	kvm_get_intr_delivery_bitmask(ioapic, &entry, deliver_bitmask);
-
-	if (find_first_bit(deliver_bitmask, KVM_MAX_VCPUS) >= KVM_MAX_VCPUS) {
-		printk(KERN_WARNING "kvm: no destination for MSI delivery!");
-		return -1;
-	}
-	while ((vcpu_id = find_first_bit(deliver_bitmask,
-					KVM_MAX_VCPUS)) < KVM_MAX_VCPUS) {
-		__clear_bit(vcpu_id, deliver_bitmask);
-		vcpu = ioapic->kvm->vcpus[vcpu_id];
-		if (vcpu) {
-			if (r < 0)
-				r = 0;
-			r += kvm_apic_set_irq(vcpu, entry.fields.vector,
-					      entry.fields.dest_mode,
-					      entry.fields.trig_mode);
-		}
-	}
-	return r;
+	return ioapic_deliver_entry(kvm, &entry);
 }
 
 /* This should be called with the kvm->lock mutex held
-- 
1.6.0.6

