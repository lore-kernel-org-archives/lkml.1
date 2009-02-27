Return-Path: <linux-kernel-owner+w=401wt.eu-S1760973AbZB0Kfg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760973AbZB0Kfg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Feb 2009 05:35:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757573AbZB0K2B
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Feb 2009 05:28:01 -0500
Received: from mx2.redhat.com ([66.187.237.31]:53586 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755847AbZB0K1L (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Feb 2009 05:27:11 -0500
From: Avi Kivity <avi@redhat.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 25/37] KVM: Interrupt mask notifiers for ioapic
Date: Fri, 27 Feb 2009 12:26:48 +0200
Message-Id: <1235730420-7929-26-git-send-email-avi@redhat.com>
In-Reply-To: <1235730420-7929-1-git-send-email-avi@redhat.com>
References: <1235730420-7929-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Allow clients to request notifications when the guest masks or unmasks a
particular irq line.  This complements irq ack notifications, as the guest
will not ack an irq line that is masked.

Currently implemented for the ioapic only.

Signed-off-by: Avi Kivity <avi@redhat.com>
---
 include/linux/kvm_host.h |   17 +++++++++++++++++
 virt/kvm/ioapic.c        |    6 ++++++
 virt/kvm/irq_comm.c      |   24 ++++++++++++++++++++++++
 virt/kvm/kvm_main.c      |    3 +++
 4 files changed, 50 insertions(+), 0 deletions(-)

diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 3cf0ede..99963f3 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -127,6 +127,10 @@ struct kvm {
 	struct kvm_coalesced_mmio_ring *coalesced_mmio_ring;
 #endif
 
+#ifdef CONFIG_HAVE_KVM_IRQCHIP
+	struct hlist_head mask_notifier_list;
+#endif
+
 #ifdef KVM_ARCH_WANT_MMU_NOTIFIER
 	struct mmu_notifier mmu_notifier;
 	unsigned long mmu_notifier_seq;
@@ -320,6 +324,19 @@ struct kvm_assigned_dev_kernel {
 	struct pci_dev *dev;
 	struct kvm *kvm;
 };
+
+struct kvm_irq_mask_notifier {
+	void (*func)(struct kvm_irq_mask_notifier *kimn, bool masked);
+	int irq;
+	struct hlist_node link;
+};
+
+void kvm_register_irq_mask_notifier(struct kvm *kvm, int irq,
+				    struct kvm_irq_mask_notifier *kimn);
+void kvm_unregister_irq_mask_notifier(struct kvm *kvm, int irq,
+				      struct kvm_irq_mask_notifier *kimn);
+void kvm_fire_mask_notifiers(struct kvm *kvm, int irq, bool mask);
+
 void kvm_set_irq(struct kvm *kvm, int irq_source_id, int irq, int level);
 void kvm_notify_acked_irq(struct kvm *kvm, unsigned gsi);
 void kvm_register_irq_ack_notifier(struct kvm *kvm,
diff --git a/virt/kvm/ioapic.c b/virt/kvm/ioapic.c
index 23b81cf..e85a2bc 100644
--- a/virt/kvm/ioapic.c
+++ b/virt/kvm/ioapic.c
@@ -101,6 +101,7 @@ static void ioapic_service(struct kvm_ioapic *ioapic, unsigned int idx)
 static void ioapic_write_indirect(struct kvm_ioapic *ioapic, u32 val)
 {
 	unsigned index;
+	bool mask_before, mask_after;
 
 	switch (ioapic->ioregsel) {
 	case IOAPIC_REG_VERSION:
@@ -120,6 +121,7 @@ static void ioapic_write_indirect(struct kvm_ioapic *ioapic, u32 val)
 		ioapic_debug("change redir index %x val %x\n", index, val);
 		if (index >= IOAPIC_NUM_PINS)
 			return;
+		mask_before = ioapic->redirtbl[index].fields.mask;
 		if (ioapic->ioregsel & 1) {
 			ioapic->redirtbl[index].bits &= 0xffffffff;
 			ioapic->redirtbl[index].bits |= (u64) val << 32;
@@ -128,6 +130,9 @@ static void ioapic_write_indirect(struct kvm_ioapic *ioapic, u32 val)
 			ioapic->redirtbl[index].bits |= (u32) val;
 			ioapic->redirtbl[index].fields.remote_irr = 0;
 		}
+		mask_after = ioapic->redirtbl[index].fields.mask;
+		if (mask_before != mask_after)
+			kvm_fire_mask_notifiers(ioapic->kvm, index, mask_after);
 		if (ioapic->irr & (1 << index))
 			ioapic_service(ioapic, index);
 		break;
@@ -426,3 +431,4 @@ int kvm_ioapic_init(struct kvm *kvm)
 	kvm_io_bus_register_dev(&kvm->mmio_bus, &ioapic->dev);
 	return 0;
 }
+
diff --git a/virt/kvm/irq_comm.c b/virt/kvm/irq_comm.c
index aa5d1e5..5162a41 100644
--- a/virt/kvm/irq_comm.c
+++ b/virt/kvm/irq_comm.c
@@ -99,3 +99,27 @@ void kvm_free_irq_source_id(struct kvm *kvm, int irq_source_id)
 		clear_bit(irq_source_id, &kvm->arch.irq_states[i]);
 	clear_bit(irq_source_id, &kvm->arch.irq_sources_bitmap);
 }
+
+void kvm_register_irq_mask_notifier(struct kvm *kvm, int irq,
+				    struct kvm_irq_mask_notifier *kimn)
+{
+	kimn->irq = irq;
+	hlist_add_head(&kimn->link, &kvm->mask_notifier_list);
+}
+
+void kvm_unregister_irq_mask_notifier(struct kvm *kvm, int irq,
+				      struct kvm_irq_mask_notifier *kimn)
+{
+	hlist_del(&kimn->link);
+}
+
+void kvm_fire_mask_notifiers(struct kvm *kvm, int irq, bool mask)
+{
+	struct kvm_irq_mask_notifier *kimn;
+	struct hlist_node *n;
+
+	hlist_for_each_entry(kimn, n, &kvm->mask_notifier_list, link)
+		if (kimn->irq == irq)
+			kimn->func(kimn, mask);
+}
+
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 04401e1..786a3ae 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -842,6 +842,9 @@ static struct kvm *kvm_create_vm(void)
 
 	if (IS_ERR(kvm))
 		goto out;
+#ifdef CONFIG_HAVE_KVM_IRQCHIP
+	INIT_HLIST_HEAD(&kvm->mask_notifier_list);
+#endif
 
 #ifdef KVM_COALESCED_MMIO_PAGE_OFFSET
 	page = alloc_page(GFP_KERNEL | __GFP_ZERO);
-- 
1.6.0.6

