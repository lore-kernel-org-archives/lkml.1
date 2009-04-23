Return-Path: <linux-kernel-owner+w=401wt.eu-S1759888AbZDWHwx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759888AbZDWHwx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Apr 2009 03:52:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757331AbZDWHdu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Apr 2009 03:33:50 -0400
Received: from sous-sol.org ([216.99.217.87]:50985 "EHLO x200.localdomain"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757284AbZDWHdr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Apr 2009 03:33:47 -0400
Message-Id: <20090423072956.172395129@sous-sol.org>
User-Agent: quilt/0.47-1
Date: Thu, 23 Apr 2009 00:21:44 -0700
From: Chris Wright <chrisw@sous-sol.org>
To: linux-kernel@vger.kernel.org, stable@kernel.org, chrisw@redhat.com
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, Willy Tarreau <w@1wt.eu>,
       Rodrigo Rubira Branco <rbranco@la.checkpoint.com>,
       Jake Edge <jake@lwn.net>, Eugene Teo <eteo@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, mtosatti@redhat.com,
       Avi Kivity <avi@redhat.com>
Subject: [patch 084/100] KVM: Interrupt mask notifiers for ioapic
References: <20090423072020.428683652@sous-sol.org>
Content-Disposition: inline; filename=kvm-interrupt-mask-notifiers-for-ioapic.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-stable review patch.  If anyone has any objections, please let us know.
---------------------

From: Avi Kivity <avi@redhat.com>

upstream commit: 75858a84a6207f5e60196f6bbd18fde4250e5759

Allow clients to request notifications when the guest masks or unmasks a
particular irq line.  This complements irq ack notifications, as the guest
will not ack an irq line that is masked.

Currently implemented for the ioapic only.

Signed-off-by: Avi Kivity <avi@redhat.com>
Signed-off-by: Chris Wright <chrisw@sous-sol.org>
---
 include/linux/kvm_host.h |   17 +++++++++++++++++
 virt/kvm/ioapic.c        |    6 ++++++
 virt/kvm/irq_comm.c      |   24 ++++++++++++++++++++++++
 virt/kvm/kvm_main.c      |    3 +++
 4 files changed, 50 insertions(+)

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
@@ -321,6 +325,19 @@ struct kvm_assigned_dev_kernel {
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
--- a/virt/kvm/ioapic.c
+++ b/virt/kvm/ioapic.c
@@ -101,6 +101,7 @@ static void ioapic_service(struct kvm_io
 static void ioapic_write_indirect(struct kvm_ioapic *ioapic, u32 val)
 {
 	unsigned index;
+	bool mask_before, mask_after;
 
 	switch (ioapic->ioregsel) {
 	case IOAPIC_REG_VERSION:
@@ -120,6 +121,7 @@ static void ioapic_write_indirect(struct
 		ioapic_debug("change redir index %x val %x\n", index, val);
 		if (index >= IOAPIC_NUM_PINS)
 			return;
+		mask_before = ioapic->redirtbl[index].fields.mask;
 		if (ioapic->ioregsel & 1) {
 			ioapic->redirtbl[index].bits &= 0xffffffff;
 			ioapic->redirtbl[index].bits |= (u64) val << 32;
@@ -128,6 +130,9 @@ static void ioapic_write_indirect(struct
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
--- a/virt/kvm/irq_comm.c
+++ b/virt/kvm/irq_comm.c
@@ -99,3 +99,27 @@ void kvm_free_irq_source_id(struct kvm *
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
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -828,6 +828,9 @@ static struct kvm *kvm_create_vm(void)
 
 	if (IS_ERR(kvm))
 		goto out;
+#ifdef CONFIG_HAVE_KVM_IRQCHIP
+	INIT_HLIST_HEAD(&kvm->mask_notifier_list);
+#endif
 
 #ifdef KVM_COALESCED_MMIO_PAGE_OFFSET
 	page = alloc_page(GFP_KERNEL | __GFP_ZERO);

