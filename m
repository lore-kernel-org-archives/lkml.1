Return-Path: <linux-kernel-owner+w=401wt.eu-S1760363AbZB0Kd2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760363AbZB0Kd2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Feb 2009 05:33:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755301AbZB0K1s
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Feb 2009 05:27:48 -0500
Received: from mx2.redhat.com ([66.187.237.31]:53591 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756096AbZB0K1L (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Feb 2009 05:27:11 -0500
From: Avi Kivity <avi@redhat.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 36/37] KVM: Userspace controlled irq routing
Date: Fri, 27 Feb 2009 12:26:59 +0200
Message-Id: <1235730420-7929-37-git-send-email-avi@redhat.com>
In-Reply-To: <1235730420-7929-1-git-send-email-avi@redhat.com>
References: <1235730420-7929-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently KVM has a static routing from GSI numbers to interrupts (namely,
0-15 are mapped 1:1 to both PIC and IOAPIC, and 16:23 are mapped 1:1 to
the IOAPIC).  This is insufficient for several reasons:

- HPET requires non 1:1 mapping for the timer interrupt
- MSIs need a new method to assign interrupt numbers and dispatch them
- ACPI APIC mode needs to be able to reassign the PCI LINK interrupts to the
  ioapics

This patch implements an interrupt routing table (as a linked list, but this
can be easily changed) and a userspace interface to replace the table.  The
routing table is initialized according to the current hardwired mapping.

Signed-off-by: Avi Kivity <avi@redhat.com>
---
 arch/ia64/kvm/kvm-ia64.c |    5 ++
 arch/x86/kvm/x86.c       |    6 ++
 include/linux/kvm.h      |   33 +++++++++
 include/linux/kvm_host.h |   31 +++++++++
 virt/kvm/irq_comm.c      |  168 ++++++++++++++++++++++++++++++++++++++++++++-
 virt/kvm/kvm_main.c      |   36 ++++++++++
 6 files changed, 275 insertions(+), 4 deletions(-)

diff --git a/arch/ia64/kvm/kvm-ia64.c b/arch/ia64/kvm/kvm-ia64.c
index 1477f91..dbf527a 100644
--- a/arch/ia64/kvm/kvm-ia64.c
+++ b/arch/ia64/kvm/kvm-ia64.c
@@ -919,6 +919,11 @@ long kvm_arch_vm_ioctl(struct file *filp,
 		r = kvm_ioapic_init(kvm);
 		if (r)
 			goto out;
+		r = kvm_setup_default_irq_routing(kvm);
+		if (r) {
+			kfree(kvm->arch.vioapic);
+			goto out;
+		}
 		break;
 	case KVM_IRQ_LINE: {
 		struct kvm_irq_level irq_event;
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 141a016..32e3a7e 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -1835,6 +1835,12 @@ long kvm_arch_vm_ioctl(struct file *filp,
 			}
 		} else
 			goto out;
+		r = kvm_setup_default_irq_routing(kvm);
+		if (r) {
+			kfree(kvm->arch.vpic);
+			kfree(kvm->arch.vioapic);
+			goto out;
+		}
 		break;
 	case KVM_CREATE_PIT:
 		mutex_lock(&kvm->lock);
diff --git a/include/linux/kvm.h b/include/linux/kvm.h
index 73f3480..7a5d73a 100644
--- a/include/linux/kvm.h
+++ b/include/linux/kvm.h
@@ -399,6 +399,38 @@ struct kvm_trace_rec {
 #if defined(CONFIG_X86)
 #define KVM_CAP_REINJECT_CONTROL 24
 #endif
+#if defined(CONFIG_X86)||defined(CONFIG_IA64)
+#define KVM_CAP_IRQ_ROUTING 25
+#endif
+
+#ifdef KVM_CAP_IRQ_ROUTING
+
+struct kvm_irq_routing_irqchip {
+	__u32 irqchip;
+	__u32 pin;
+};
+
+/* gsi routing entry types */
+#define KVM_IRQ_ROUTING_IRQCHIP 1
+
+struct kvm_irq_routing_entry {
+	__u32 gsi;
+	__u32 type;
+	__u32 flags;
+	__u32 pad;
+	union {
+		struct kvm_irq_routing_irqchip irqchip;
+		__u32 pad[8];
+	} u;
+};
+
+struct kvm_irq_routing {
+	__u32 nr;
+	__u32 flags;
+	struct kvm_irq_routing_entry entries[0];
+};
+
+#endif
 
 /*
  * ioctls for VM fds
@@ -430,6 +462,7 @@ struct kvm_trace_rec {
 			_IOW(KVMIO,  0x68, struct kvm_coalesced_mmio_zone)
 #define KVM_ASSIGN_PCI_DEVICE _IOR(KVMIO, 0x69, \
 				   struct kvm_assigned_pci_dev)
+#define KVM_SET_GSI_ROUTING       _IOW(KVMIO, 0x6a, struct kvm_irq_routing)
 #define KVM_ASSIGN_IRQ _IOR(KVMIO, 0x70, \
 			    struct kvm_assigned_irq)
 #define KVM_REINJECT_CONTROL      _IO(KVMIO, 0x71)
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 99963f3..ce285e0 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -107,6 +107,19 @@ struct kvm_memory_slot {
 	int user_alloc;
 };
 
+struct kvm_kernel_irq_routing_entry {
+	u32 gsi;
+	void (*set)(struct kvm_kernel_irq_routing_entry *e,
+		    struct kvm *kvm, int level);
+	union {
+		struct {
+			unsigned irqchip;
+			unsigned pin;
+		} irqchip;
+	};
+	struct list_head link;
+};
+
 struct kvm {
 	struct mutex lock; /* protects the vcpus array and APIC accesses */
 	spinlock_t mmu_lock;
@@ -128,6 +141,7 @@ struct kvm {
 #endif
 
 #ifdef CONFIG_HAVE_KVM_IRQCHIP
+	struct list_head irq_routing; /* of kvm_kernel_irq_routing_entry */
 	struct hlist_head mask_notifier_list;
 #endif
 
@@ -480,4 +494,21 @@ static inline int mmu_notifier_retry(struct kvm_vcpu *vcpu, unsigned long mmu_se
 }
 #endif
 
+#ifdef CONFIG_HAVE_KVM_IRQCHIP
+
+#define KVM_MAX_IRQ_ROUTES 1024
+
+int kvm_setup_default_irq_routing(struct kvm *kvm);
+int kvm_set_irq_routing(struct kvm *kvm,
+			const struct kvm_irq_routing_entry *entries,
+			unsigned nr,
+			unsigned flags);
+void kvm_free_irq_routing(struct kvm *kvm);
+
+#else
+
+static inline void kvm_free_irq_routing(struct kvm *kvm) {}
+
+#endif
+
 #endif
diff --git a/virt/kvm/irq_comm.c b/virt/kvm/irq_comm.c
index 5162a41..a797fa5 100644
--- a/virt/kvm/irq_comm.c
+++ b/virt/kvm/irq_comm.c
@@ -24,9 +24,24 @@
 
 #include "ioapic.h"
 
+static void kvm_set_pic_irq(struct kvm_kernel_irq_routing_entry *e,
+			    struct kvm *kvm, int level)
+{
+#ifdef CONFIG_X86
+	kvm_pic_set_irq(pic_irqchip(kvm), e->irqchip.pin, level);
+#endif
+}
+
+static void kvm_set_ioapic_irq(struct kvm_kernel_irq_routing_entry *e,
+			       struct kvm *kvm, int level)
+{
+	kvm_ioapic_set_irq(kvm->arch.vioapic, e->irqchip.pin, level);
+}
+
 /* This should be called with the kvm->lock mutex held */
 void kvm_set_irq(struct kvm *kvm, int irq_source_id, int irq, int level)
 {
+	struct kvm_kernel_irq_routing_entry *e;
 	unsigned long *irq_state = (unsigned long *)&kvm->arch.irq_states[irq];
 
 	/* Logical OR for level trig interrupt */
@@ -39,10 +54,9 @@ void kvm_set_irq(struct kvm *kvm, int irq_source_id, int irq, int level)
 	 * IOAPIC.  So set the bit in both. The guest will ignore
 	 * writes to the unused one.
 	 */
-	kvm_ioapic_set_irq(kvm->arch.vioapic, irq, !!(*irq_state));
-#ifdef CONFIG_X86
-	kvm_pic_set_irq(pic_irqchip(kvm), irq, !!(*irq_state));
-#endif
+	list_for_each_entry(e, &kvm->irq_routing, link)
+		if (e->gsi == irq)
+			e->set(e, kvm, !!(*irq_state));
 }
 
 void kvm_notify_acked_irq(struct kvm *kvm, unsigned gsi)
@@ -123,3 +137,149 @@ void kvm_fire_mask_notifiers(struct kvm *kvm, int irq, bool mask)
 			kimn->func(kimn, mask);
 }
 
+static void __kvm_free_irq_routing(struct list_head *irq_routing)
+{
+	struct kvm_kernel_irq_routing_entry *e, *n;
+
+	list_for_each_entry_safe(e, n, irq_routing, link)
+		kfree(e);
+}
+
+void kvm_free_irq_routing(struct kvm *kvm)
+{
+	__kvm_free_irq_routing(&kvm->irq_routing);
+}
+
+int setup_routing_entry(struct kvm_kernel_irq_routing_entry *e,
+			const struct kvm_irq_routing_entry *ue)
+{
+	int r = -EINVAL;
+	int delta;
+
+	e->gsi = ue->gsi;
+	switch (ue->type) {
+	case KVM_IRQ_ROUTING_IRQCHIP:
+		delta = 0;
+		switch (ue->u.irqchip.irqchip) {
+		case KVM_IRQCHIP_PIC_MASTER:
+			e->set = kvm_set_pic_irq;
+			break;
+		case KVM_IRQCHIP_PIC_SLAVE:
+				e->set = kvm_set_pic_irq;
+			delta = 8;
+			break;
+		case KVM_IRQCHIP_IOAPIC:
+				e->set = kvm_set_ioapic_irq;
+			break;
+		default:
+			goto out;
+		}
+		e->irqchip.irqchip = ue->u.irqchip.irqchip;
+		e->irqchip.pin = ue->u.irqchip.pin + delta;
+		break;
+	default:
+		goto out;
+	}
+	r = 0;
+out:
+	return r;
+}
+
+
+int kvm_set_irq_routing(struct kvm *kvm,
+			const struct kvm_irq_routing_entry *ue,
+			unsigned nr,
+			unsigned flags)
+{
+	struct list_head irq_list = LIST_HEAD_INIT(irq_list);
+	struct list_head tmp = LIST_HEAD_INIT(tmp);
+	struct kvm_kernel_irq_routing_entry *e = NULL;
+	unsigned i;
+	int r;
+
+	for (i = 0; i < nr; ++i) {
+		r = -EINVAL;
+		if (ue->gsi >= KVM_MAX_IRQ_ROUTES)
+			goto out;
+		if (ue->flags)
+			goto out;
+		r = -ENOMEM;
+		e = kzalloc(sizeof(*e), GFP_KERNEL);
+		if (!e)
+			goto out;
+		r = setup_routing_entry(e, ue);
+		if (r)
+			goto out;
+		++ue;
+		list_add(&e->link, &irq_list);
+		e = NULL;
+	}
+
+	mutex_lock(&kvm->lock);
+	list_splice(&kvm->irq_routing, &tmp);
+	INIT_LIST_HEAD(&kvm->irq_routing);
+	list_splice(&irq_list, &kvm->irq_routing);
+	INIT_LIST_HEAD(&irq_list);
+	list_splice(&tmp, &irq_list);
+	mutex_unlock(&kvm->lock);
+
+	r = 0;
+
+out:
+	kfree(e);
+	__kvm_free_irq_routing(&irq_list);
+	return r;
+}
+
+#define IOAPIC_ROUTING_ENTRY(irq) \
+	{ .gsi = irq, .type = KVM_IRQ_ROUTING_IRQCHIP,	\
+	  .u.irqchip.irqchip = KVM_IRQCHIP_IOAPIC, .u.irqchip.pin = (irq) }
+#define ROUTING_ENTRY1(irq) IOAPIC_ROUTING_ENTRY(irq)
+
+#ifdef CONFIG_X86
+#define SELECT_PIC(irq) \
+	((irq) < 8 ? KVM_IRQCHIP_PIC_MASTER : KVM_IRQCHIP_PIC_SLAVE)
+#  define PIC_ROUTING_ENTRY(irq) \
+	{ .gsi = irq, .type = KVM_IRQ_ROUTING_IRQCHIP,	\
+	  .u.irqchip.irqchip = SELECT_PIC(irq), .u.irqchip.pin = (irq) % 8 }
+#  define ROUTING_ENTRY2(irq) \
+	IOAPIC_ROUTING_ENTRY(irq), PIC_ROUTING_ENTRY(irq)
+#else
+#  define ROUTING_ENTRY2(irq) \
+	IOAPIC_ROUTING_ENTRY(irq)
+#endif
+
+static const struct kvm_irq_routing_entry default_routing[] = {
+	ROUTING_ENTRY2(0), ROUTING_ENTRY2(1),
+	ROUTING_ENTRY2(2), ROUTING_ENTRY2(3),
+	ROUTING_ENTRY2(4), ROUTING_ENTRY2(5),
+	ROUTING_ENTRY2(6), ROUTING_ENTRY2(7),
+	ROUTING_ENTRY2(8), ROUTING_ENTRY2(9),
+	ROUTING_ENTRY2(10), ROUTING_ENTRY2(11),
+	ROUTING_ENTRY2(12), ROUTING_ENTRY2(13),
+	ROUTING_ENTRY2(14), ROUTING_ENTRY2(15),
+	ROUTING_ENTRY1(16), ROUTING_ENTRY1(17),
+	ROUTING_ENTRY1(18), ROUTING_ENTRY1(19),
+	ROUTING_ENTRY1(20), ROUTING_ENTRY1(21),
+	ROUTING_ENTRY1(22), ROUTING_ENTRY1(23),
+#ifdef CONFIG_IA64
+	ROUTING_ENTRY1(24), ROUTING_ENTRY1(25),
+	ROUTING_ENTRY1(26), ROUTING_ENTRY1(27),
+	ROUTING_ENTRY1(28), ROUTING_ENTRY1(29),
+	ROUTING_ENTRY1(30), ROUTING_ENTRY1(31),
+	ROUTING_ENTRY1(32), ROUTING_ENTRY1(33),
+	ROUTING_ENTRY1(34), ROUTING_ENTRY1(35),
+	ROUTING_ENTRY1(36), ROUTING_ENTRY1(37),
+	ROUTING_ENTRY1(38), ROUTING_ENTRY1(39),
+	ROUTING_ENTRY1(40), ROUTING_ENTRY1(41),
+	ROUTING_ENTRY1(42), ROUTING_ENTRY1(43),
+	ROUTING_ENTRY1(44), ROUTING_ENTRY1(45),
+	ROUTING_ENTRY1(46), ROUTING_ENTRY1(47),
+#endif
+};
+
+int kvm_setup_default_irq_routing(struct kvm *kvm)
+{
+	return kvm_set_irq_routing(kvm, default_routing,
+				   ARRAY_SIZE(default_routing), 0);
+}
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 786a3ae..c65484b 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -843,6 +843,7 @@ static struct kvm *kvm_create_vm(void)
 	if (IS_ERR(kvm))
 		goto out;
 #ifdef CONFIG_HAVE_KVM_IRQCHIP
+	INIT_LIST_HEAD(&kvm->irq_routing);
 	INIT_HLIST_HEAD(&kvm->mask_notifier_list);
 #endif
 
@@ -926,6 +927,7 @@ static void kvm_destroy_vm(struct kvm *kvm)
 	spin_lock(&kvm_lock);
 	list_del(&kvm->vm_list);
 	spin_unlock(&kvm_lock);
+	kvm_free_irq_routing(kvm);
 	kvm_io_bus_destroy(&kvm->pio_bus);
 	kvm_io_bus_destroy(&kvm->mmio_bus);
 #ifdef KVM_COALESCED_MMIO_PAGE_OFFSET
@@ -1946,6 +1948,36 @@ static long kvm_vm_ioctl(struct file *filp,
 		break;
 	}
 #endif
+#ifdef KVM_CAP_IRQ_ROUTING
+	case KVM_SET_GSI_ROUTING: {
+		struct kvm_irq_routing routing;
+		struct kvm_irq_routing __user *urouting;
+		struct kvm_irq_routing_entry *entries;
+
+		r = -EFAULT;
+		if (copy_from_user(&routing, argp, sizeof(routing)))
+			goto out;
+		r = -EINVAL;
+		if (routing.nr >= KVM_MAX_IRQ_ROUTES)
+			goto out;
+		if (routing.flags)
+			goto out;
+		r = -ENOMEM;
+		entries = vmalloc(routing.nr * sizeof(*entries));
+		if (!entries)
+			goto out;
+		r = -EFAULT;
+		urouting = argp;
+		if (copy_from_user(entries, urouting->entries,
+				   routing.nr * sizeof(*entries)))
+			goto out_free_irq_routing;
+		r = kvm_set_irq_routing(kvm, entries, routing.nr,
+					routing.flags);
+	out_free_irq_routing:
+		vfree(entries);
+		break;
+	}
+#endif
 	default:
 		r = kvm_arch_vm_ioctl(filp, ioctl, arg);
 	}
@@ -2012,6 +2044,10 @@ static long kvm_dev_ioctl_check_extension_generic(long arg)
 	case KVM_CAP_USER_MEMORY:
 	case KVM_CAP_DESTROY_MEMORY_REGION_WORKS:
 		return 1;
+#ifdef CONFIG_HAVE_KVM_IRQCHIP
+	case KVM_CAP_IRQ_ROUTING:
+		return 1;
+#endif
 	default:
 		break;
 	}
-- 
1.6.0.6

