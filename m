Return-Path: <linux-kernel-owner+w=401wt.eu-S1755049AbZERJ0R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755049AbZERJ0R (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 May 2009 05:26:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755493AbZERJXP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 May 2009 05:23:15 -0400
Received: from mx2.redhat.com ([66.187.237.31]:38397 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751857AbZERJXH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 May 2009 05:23:07 -0400
From: Avi Kivity <avi@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: kvm@vger.kernel.org
Subject: [PATCH 04/43] KVM: Unify the delivery of IOAPIC and MSI interrupts
Date: Mon, 18 May 2009 12:22:26 +0300
Message-Id: <1242638585-18470-5-git-send-email-avi@redhat.com>
In-Reply-To: <1242638585-18470-1-git-send-email-avi@redhat.com>
References: <1242638585-18470-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sheng Yang <sheng@linux.intel.com>

Signed-off-by: Sheng Yang <sheng@linux.intel.com>
Signed-off-by: Avi Kivity <avi@redhat.com>
---
 include/linux/kvm_host.h |    3 +
 virt/kvm/ioapic.c        |   91 ++++++++++++++++---------------------------
 virt/kvm/irq_comm.c      |   95 ++++++++++++++++++++++++++++------------------
 3 files changed, 95 insertions(+), 94 deletions(-)

diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 894a56e..1a2f98f 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -352,6 +352,9 @@ void kvm_unregister_irq_mask_notifier(struct kvm *kvm, int irq,
 				      struct kvm_irq_mask_notifier *kimn);
 void kvm_fire_mask_notifiers(struct kvm *kvm, int irq, bool mask);
 
+void kvm_get_intr_delivery_bitmask(struct kvm_ioapic *ioapic,
+				   union kvm_ioapic_redirect_entry *entry,
+				   unsigned long *deliver_bitmask);
 int kvm_set_irq(struct kvm *kvm, int irq_source_id, int irq, int level);
 void kvm_notify_acked_irq(struct kvm *kvm, unsigned irqchip, unsigned pin);
 void kvm_register_irq_ack_notifier(struct kvm *kvm,
diff --git a/virt/kvm/ioapic.c b/virt/kvm/ioapic.c
index 8128013..883fd0d 100644
--- a/virt/kvm/ioapic.c
+++ b/virt/kvm/ioapic.c
@@ -203,79 +203,56 @@ u32 kvm_ioapic_get_delivery_bitmask(struct kvm_ioapic *ioapic, u8 dest,
 
 static int ioapic_deliver(struct kvm_ioapic *ioapic, int irq)
 {
-	u8 dest = ioapic->redirtbl[irq].fields.dest_id;
-	u8 dest_mode = ioapic->redirtbl[irq].fields.dest_mode;
-	u8 delivery_mode = ioapic->redirtbl[irq].fields.delivery_mode;
-	u8 vector = ioapic->redirtbl[irq].fields.vector;
-	u8 trig_mode = ioapic->redirtbl[irq].fields.trig_mode;
-	u32 deliver_bitmask;
+	union kvm_ioapic_redirect_entry entry = ioapic->redirtbl[irq];
+	unsigned long deliver_bitmask;
 	struct kvm_vcpu *vcpu;
 	int vcpu_id, r = -1;
 
 	ioapic_debug("dest=%x dest_mode=%x delivery_mode=%x "
 		     "vector=%x trig_mode=%x\n",
-		     dest, dest_mode, delivery_mode, vector, trig_mode);
+		     entry.fields.dest, entry.fields.dest_mode,
+		     entry.fields.delivery_mode, entry.fields.vector,
+		     entry.fields.trig_mode);
 
-	deliver_bitmask = kvm_ioapic_get_delivery_bitmask(ioapic, dest,
-							  dest_mode);
+	kvm_get_intr_delivery_bitmask(ioapic, &entry, &deliver_bitmask);
 	if (!deliver_bitmask) {
 		ioapic_debug("no target on destination\n");
 		return 0;
 	}
 
-	switch (delivery_mode) {
-	case IOAPIC_LOWEST_PRIORITY:
-		vcpu = kvm_get_lowest_prio_vcpu(ioapic->kvm, vector,
-				deliver_bitmask);
+	/* Always delivery PIT interrupt to vcpu 0 */
 #ifdef CONFIG_X86
-		if (irq == 0)
-			vcpu = ioapic->kvm->vcpus[0];
+	if (irq == 0)
+		deliver_bitmask = 1;
 #endif
-		if (vcpu != NULL)
-			r = ioapic_inj_irq(ioapic, vcpu, vector,
-				       trig_mode, delivery_mode);
-		else
-			ioapic_debug("null lowest prio vcpu: "
-				     "mask=%x vector=%x delivery_mode=%x\n",
-				     deliver_bitmask, vector, IOAPIC_LOWEST_PRIORITY);
-		break;
-	case IOAPIC_FIXED:
-#ifdef CONFIG_X86
-		if (irq == 0)
-			deliver_bitmask = 1;
-#endif
-		for (vcpu_id = 0; deliver_bitmask != 0; vcpu_id++) {
-			if (!(deliver_bitmask & (1 << vcpu_id)))
-				continue;
-			deliver_bitmask &= ~(1 << vcpu_id);
-			vcpu = ioapic->kvm->vcpus[vcpu_id];
-			if (vcpu) {
+
+	for (vcpu_id = 0; deliver_bitmask != 0; vcpu_id++) {
+		if (!(deliver_bitmask & (1 << vcpu_id)))
+			continue;
+		deliver_bitmask &= ~(1 << vcpu_id);
+		vcpu = ioapic->kvm->vcpus[vcpu_id];
+		if (vcpu) {
+			if (entry.fields.delivery_mode ==
+					IOAPIC_LOWEST_PRIORITY ||
+			    entry.fields.delivery_mode == IOAPIC_FIXED) {
 				if (r < 0)
 					r = 0;
-				r += ioapic_inj_irq(ioapic, vcpu, vector,
-					       trig_mode, delivery_mode);
-			}
-		}
-		break;
-	case IOAPIC_NMI:
-		for (vcpu_id = 0; deliver_bitmask != 0; vcpu_id++) {
-			if (!(deliver_bitmask & (1 << vcpu_id)))
-				continue;
-			deliver_bitmask &= ~(1 << vcpu_id);
-			vcpu = ioapic->kvm->vcpus[vcpu_id];
-			if (vcpu) {
-				ioapic_inj_nmi(vcpu);
+				r += ioapic_inj_irq(ioapic, vcpu,
+						    entry.fields.vector,
+						    entry.fields.trig_mode,
+						    entry.fields.delivery_mode);
+			} else if (entry.fields.delivery_mode == IOAPIC_NMI) {
 				r = 1;
-			}
-			else
-				ioapic_debug("NMI to vcpu %d failed\n",
-						vcpu->vcpu_id);
-		}
-		break;
-	default:
-		printk(KERN_WARNING "Unsupported delivery mode %d\n",
-		       delivery_mode);
-		break;
+				ioapic_inj_nmi(vcpu);
+			} else
+				ioapic_debug("unsupported delivery mode %x!\n",
+					     entry.fields.delivery_mode);
+		} else
+			ioapic_debug("null destination vcpu: "
+				     "mask=%x vector=%x delivery_mode=%x\n",
+				     entry.fields.deliver_bitmask,
+				     entry.fields.vector,
+				     entry.fields.delivery_mode);
 	}
 	return r;
 }
diff --git a/virt/kvm/irq_comm.c b/virt/kvm/irq_comm.c
index 864ac54..aec7a0d 100644
--- a/virt/kvm/irq_comm.c
+++ b/virt/kvm/irq_comm.c
@@ -43,53 +43,74 @@ static int kvm_set_ioapic_irq(struct kvm_kernel_irq_routing_entry *e,
 	return kvm_ioapic_set_irq(kvm->arch.vioapic, e->irqchip.pin, level);
 }
 
+void kvm_get_intr_delivery_bitmask(struct kvm_ioapic *ioapic,
+				   union kvm_ioapic_redirect_entry *entry,
+				   unsigned long *deliver_bitmask)
+{
+	struct kvm_vcpu *vcpu;
+
+	*deliver_bitmask = kvm_ioapic_get_delivery_bitmask(ioapic,
+				entry->fields.dest_id, entry->fields.dest_mode);
+	switch (entry->fields.delivery_mode) {
+	case IOAPIC_LOWEST_PRIORITY:
+		vcpu = kvm_get_lowest_prio_vcpu(ioapic->kvm,
+				entry->fields.vector, *deliver_bitmask);
+		*deliver_bitmask = 1 << vcpu->vcpu_id;
+		break;
+	case IOAPIC_FIXED:
+	case IOAPIC_NMI:
+		break;
+	default:
+		if (printk_ratelimit())
+			printk(KERN_INFO "kvm: unsupported delivery mode %d\n",
+				entry->fields.delivery_mode);
+		*deliver_bitmask = 0;
+	}
+}
+
 static int kvm_set_msi(struct kvm_kernel_irq_routing_entry *e,
 		       struct kvm *kvm, int level)
 {
 	int vcpu_id, r = -1;
 	struct kvm_vcpu *vcpu;
 	struct kvm_ioapic *ioapic = ioapic_irqchip(kvm);
-	int dest_id = (e->msi.address_lo & MSI_ADDR_DEST_ID_MASK)
-			>> MSI_ADDR_DEST_ID_SHIFT;
-	int vector = (e->msi.data & MSI_DATA_VECTOR_MASK)
-			>> MSI_DATA_VECTOR_SHIFT;
-	int dest_mode = test_bit(MSI_ADDR_DEST_MODE_SHIFT,
-				(unsigned long *)&e->msi.address_lo);
-	int trig_mode = test_bit(MSI_DATA_TRIGGER_SHIFT,
-				(unsigned long *)&e->msi.data);
-	int delivery_mode = test_bit(MSI_DATA_DELIVERY_MODE_SHIFT,
-				(unsigned long *)&e->msi.data);
-	u32 deliver_bitmask;
+	union kvm_ioapic_redirect_entry entry;
+	unsigned long deliver_bitmask;
 
 	BUG_ON(!ioapic);
 
-	deliver_bitmask = kvm_ioapic_get_delivery_bitmask(ioapic,
-				dest_id, dest_mode);
-	/* IOAPIC delivery mode value is the same as MSI here */
-	switch (delivery_mode) {
-	case IOAPIC_LOWEST_PRIORITY:
-		vcpu = kvm_get_lowest_prio_vcpu(ioapic->kvm, vector,
-				deliver_bitmask);
-		if (vcpu != NULL)
-			r = kvm_apic_set_irq(vcpu, vector, trig_mode);
-		else
-			printk(KERN_INFO "kvm: null lowest priority vcpu!\n");
-		break;
-	case IOAPIC_FIXED:
-		for (vcpu_id = 0; deliver_bitmask != 0; vcpu_id++) {
-			if (!(deliver_bitmask & (1 << vcpu_id)))
-				continue;
-			deliver_bitmask &= ~(1 << vcpu_id);
-			vcpu = ioapic->kvm->vcpus[vcpu_id];
-			if (vcpu) {
-				if (r < 0)
-					r = 0;
-				r += kvm_apic_set_irq(vcpu, vector, trig_mode);
-			}
+	entry.bits = 0;
+	entry.fields.dest_id = (e->msi.address_lo &
+			MSI_ADDR_DEST_ID_MASK) >> MSI_ADDR_DEST_ID_SHIFT;
+	entry.fields.vector = (e->msi.data &
+			MSI_DATA_VECTOR_MASK) >> MSI_DATA_VECTOR_SHIFT;
+	entry.fields.dest_mode = test_bit(MSI_ADDR_DEST_MODE_SHIFT,
+			(unsigned long *)&e->msi.address_lo);
+	entry.fields.trig_mode = test_bit(MSI_DATA_TRIGGER_SHIFT,
+			(unsigned long *)&e->msi.data);
+	entry.fields.delivery_mode = test_bit(
+			MSI_DATA_DELIVERY_MODE_SHIFT,
+			(unsigned long *)&e->msi.data);
+
+	/* TODO Deal with RH bit of MSI message address */
+
+	kvm_get_intr_delivery_bitmask(ioapic, &entry, &deliver_bitmask);
+
+	if (!deliver_bitmask) {
+		printk(KERN_WARNING "kvm: no destination for MSI delivery!");
+		return -1;
+	}
+	for (vcpu_id = 0; deliver_bitmask != 0; vcpu_id++) {
+		if (!(deliver_bitmask & (1 << vcpu_id)))
+			continue;
+		deliver_bitmask &= ~(1 << vcpu_id);
+		vcpu = ioapic->kvm->vcpus[vcpu_id];
+		if (vcpu) {
+			if (r < 0)
+				r = 0;
+			r += kvm_apic_set_irq(vcpu, entry.fields.vector,
+					      entry.fields.trig_mode);
 		}
-		break;
-	default:
-		break;
 	}
 	return r;
 }
-- 
1.6.0.6

