Return-Path: <linux-kernel-owner+w=401wt.eu-S1757358AbYE3K2n@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757358AbYE3K2n (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2008 06:28:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753156AbYE3K15
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 May 2008 06:27:57 -0400
Received: from bzq-179-150-194.static.bezeqint.net ([212.179.150.194]:45209
	"EHLO il.qumranet.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751819AbYE3K1x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2008 06:27:53 -0400
From: Amit Shah <amit.shah@qumranet.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, muli@il.ibm.com, benami@il.ibm.com,
       allen.m.kay@intel.com, chrisw@redhat.com,
       Amit Shah <amit.shah@qumranet.com>
Subject: [PATCH 3/3] KVM: Handle devices assigned to the guest
Date: Fri, 30 May 2008 13:27:50 +0300
Message-Id: <1212143270-18333-3-git-send-email-amit.shah@qumranet.com>
X-Mailer: git-send-email 1.5.5.1
In-Reply-To: <1212143270-18333-2-git-send-email-amit.shah@qumranet.com>
References: <1212143270-18333-1-git-send-email-amit.shah@qumranet.com>
 <1212143270-18333-2-git-send-email-amit.shah@qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Amit Shah <amit.shah@qumranet.com>
From: Ben-Ami Yassour <benami@il.ibm.com>

This patch adds support for handling PCI devices that are assigned to the guest
("PCI passthrough").

The device to be assigned to the guest is registered in the host kernel and
interrupt delivery is handled. It is expected the module for the device in the
host is not loaded.

Devices that share their interrupt line are not supported at the moment.

By itself, this patch will not make devices work within the guest. There has to
be some mechanism of translating guest DMA addresses into machine addresses. This
support comes from one of three approaches:

1. If you have recent Intel hardware with VT-d support, you can use the patches
in

git.kernel.org/pub/scm/linux/kernel/git/amit/kvm.git vtd
git.kernel.org/pub/scm/linux/kernel/git/amit/kvm-userspace.git vtd

Patch your host kernel. These patches are expected to hit mainline soon.

2. For paravirtualised Linux guests, you can use the patches in

git.kernel.org/pub/scm/linux/kernel/git/amit/kvm.git pvdma
git.kernel.org/pub/scm/linux/kernel/git/amit/kvm-userspace.git pvdma

This kernel tree has patches for host as well as guest kernels.

3. 1-1 mapping of guest in host address space

The patch to do this against older kernels is available (on the kvm / lkml list
archives).

Signed-off-by: Amit Shah <amit.shah@qumranet.com>
---
 arch/x86/kvm/lapic.c       |    2 +
 arch/x86/kvm/x86.c         |  271 ++++++++++++++++++++++++++++++++++++++++++++
 include/asm-x86/kvm_host.h |   39 +++++++
 include/asm-x86/kvm_para.h |   16 +++-
 include/linux/kvm.h        |    3 +
 virt/kvm/ioapic.c          |   11 ++-
 6 files changed, 339 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index 8fcd84e..030053b 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -451,6 +451,8 @@ static void apic_set_eoi(struct kvm_lapic *apic)
 
 	if (apic_test_and_clear_vector(vector, apic->regs + APIC_TMR))
 		kvm_ioapic_update_eoi(apic->vcpu->kvm, vector);
+
+	kvm_pci_pt_ack_irq(apic->vcpu->kvm, vector);
 }
 
 static void apic_send_ipi(struct kvm_lapic *apic)
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 77fb2bd..d8bc492 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -21,6 +21,7 @@
 #include "tss.h"
 
 #include <linux/clocksource.h>
+#include <linux/interrupt.h>
 #include <linux/kvm.h>
 #include <linux/fs.h>
 #include <linux/vmalloc.h>
@@ -95,6 +96,263 @@ struct kvm_stats_debugfs_item debugfs_entries[] = {
 	{ NULL }
 };
 
+DEFINE_RWLOCK(kvm_pci_pt_lock);
+
+/*
+ * Used to find a registered host PCI device (a "passthrough" device)
+ * during ioctls, interrupts or EOI
+ */
+struct kvm_pci_pt_dev_list *
+kvm_find_pci_pt_dev(struct list_head *head,
+		struct kvm_pci_pt_info *pt_pci_info, int irq, int source)
+{
+	struct list_head *ptr;
+	struct kvm_pci_pt_dev_list *match;
+
+	list_for_each(ptr, head) {
+		match = list_entry(ptr, struct kvm_pci_pt_dev_list, list);
+
+		switch (source) {
+		case KVM_PT_SOURCE_IRQ:
+			/*
+			 * Used to find a registered host device
+			 * during interrupt context on host
+			 */
+			if (match->pt_dev.host.irq == irq)
+				return match;
+			break;
+		case KVM_PT_SOURCE_IRQ_ACK:
+			/*
+			 * Used to find a registered host device when
+			 * the guest acks an interrupt
+			 */
+			if (match->pt_dev.guest.irq == irq)
+				return match;
+			break;
+		case KVM_PT_SOURCE_ASSIGN:
+			if ((match->pt_dev.guest.busnr == pt_pci_info->busnr) &&
+			    (match->pt_dev.guest.devfn == pt_pci_info->devfn))
+				return match;
+			break;
+		}
+	}
+	return NULL;
+}
+
+static DECLARE_BITMAP(pt_irq_handled, NR_IRQS);
+
+static void kvm_pci_pt_work_fn(struct work_struct *work)
+{
+	struct kvm_pci_pt_dev_list *match;
+	struct kvm_pci_pt_work *int_work;
+	int source;
+	unsigned long flags;
+	int guest_irq;
+	int host_irq;
+
+	int_work = container_of(work, struct kvm_pci_pt_work, work);
+
+	source = int_work->source ? KVM_PT_SOURCE_IRQ_ACK : KVM_PT_SOURCE_IRQ;
+
+	/* This is taken to safely inject irq inside the guest. When
+	 * the interrupt injection (or the ioapic code) uses a
+	 * finer-grained lock, update this
+	 */
+	mutex_lock(&int_work->kvm->lock);
+	read_lock_irqsave(&kvm_pci_pt_lock, flags);
+	match = kvm_find_pci_pt_dev(&int_work->kvm->arch.pci_pt_dev_head, NULL,
+				    int_work->irq, source);
+	if (!match) {
+		printk(KERN_ERR "%s: no matching device assigned to guest "
+		       "found for irq %d, source = %d!\n",
+		       __func__, int_work->irq, int_work->source);
+		read_unlock_irqrestore(&kvm_pci_pt_lock, flags);
+		goto out;
+	}
+	guest_irq = match->pt_dev.guest.irq;
+	host_irq = match->pt_dev.host.irq;
+	read_unlock_irqrestore(&kvm_pci_pt_lock, flags);
+
+	if (source == KVM_PT_SOURCE_IRQ)
+		kvm_set_irq(int_work->kvm, guest_irq, 1);
+	else {
+		kvm_set_irq(int_work->kvm, int_work->irq, 0);
+		enable_irq(host_irq);
+	}
+out:
+	mutex_unlock(&int_work->kvm->lock);
+	kvm_put_kvm(int_work->kvm);
+}
+
+/* FIXME: Implement the OR logic needed to make shared interrupts on
+ * this line behave properly
+ */
+static irqreturn_t kvm_pci_pt_dev_intr(int irq, void *dev_id)
+{
+	struct kvm *kvm = (struct kvm *) dev_id;
+	struct kvm_pci_pt_dev_list *pci_pt_dev;
+
+	if (!test_bit(irq, pt_irq_handled))
+		return IRQ_NONE;
+
+	read_lock(&kvm_pci_pt_lock);
+	pci_pt_dev = kvm_find_pci_pt_dev(&kvm->arch.pci_pt_dev_head, NULL,
+					 irq, KVM_PT_SOURCE_IRQ);
+	if (!pci_pt_dev) {
+		read_unlock(&kvm_pci_pt_lock);
+		return IRQ_NONE;
+	}
+
+	pci_pt_dev->pt_dev.int_work.irq = irq;
+	pci_pt_dev->pt_dev.int_work.kvm = kvm;
+	pci_pt_dev->pt_dev.int_work.source = 0;
+
+	kvm_get_kvm(kvm);
+	schedule_work(&pci_pt_dev->pt_dev.int_work.work);
+	read_unlock(&kvm_pci_pt_lock);
+
+	disable_irq_nosync(irq);
+	return IRQ_HANDLED;
+}
+
+/* Ack the irq line for a passthrough device */
+void kvm_pci_pt_ack_irq(struct kvm *kvm, int vector)
+{
+	int irq;
+	struct kvm_pci_pt_dev_list *pci_pt_dev;
+	unsigned long flags;
+
+	irq = kvm_get_eoi_gsi(kvm->arch.vioapic, vector);
+	if (irq == -1)
+		return;
+
+	read_lock_irqsave(&kvm_pci_pt_lock, flags);
+	pci_pt_dev = kvm_find_pci_pt_dev(&kvm->arch.pci_pt_dev_head, NULL, irq,
+					 KVM_PT_SOURCE_IRQ_ACK);
+
+	if (!pci_pt_dev) {
+		read_unlock_irqrestore(&kvm_pci_pt_lock, flags);
+		return;
+	}
+
+	pci_pt_dev->pt_dev.ack_work.irq = irq;
+	pci_pt_dev->pt_dev.ack_work.kvm = kvm;
+	pci_pt_dev->pt_dev.ack_work.source = 1;
+
+	kvm_get_kvm(kvm);
+	schedule_work(&pci_pt_dev->pt_dev.ack_work.work);
+	read_unlock_irqrestore(&kvm_pci_pt_lock, flags);
+}
+
+static int kvm_vm_ioctl_pci_pt_dev(struct kvm *kvm,
+				   struct kvm_pci_passthrough_dev *pci_pt_dev)
+{
+	int r = 0;
+	struct kvm_pci_pt_dev_list *match;
+	unsigned long flags;
+
+	write_lock_irqsave(&kvm_pci_pt_lock, flags);
+
+	/* Check if this is a request to update the irq of the device
+	 * in the guest (kernels can dynamically reprogram irq numbers).
+	 * This also protects us from adding the same device twice.
+	 */
+	match = kvm_find_pci_pt_dev(&kvm->arch.pci_pt_dev_head, NULL,
+				    pci_pt_dev->host.irq, KVM_PT_SOURCE_IRQ);
+	if (match) {
+		/* Confirm this is a request to update the irq number
+		 * and not to add a new device. A device that's on
+		 * 00:00.0 on the host as well as the guest is an
+		 * unlikely scenario.
+		 */
+		if (!pci_pt_dev->guest.busnr && !pci_pt_dev->guest.devfn &&
+		    !pci_pt_dev->host.busnr && !pci_pt_dev->host.devfn)
+			match->pt_dev.guest.irq = pci_pt_dev->guest.irq;
+		else
+			r = -EINVAL;
+		write_unlock_irqrestore(&kvm_pci_pt_lock, flags);
+		goto out;
+	}
+	write_unlock_irqrestore(&kvm_pci_pt_lock, flags);
+
+	match = kzalloc(sizeof(struct kvm_pci_pt_dev_list), GFP_KERNEL);
+	if (match == NULL) {
+		printk(KERN_INFO "%s: Couldn't allocate memory\n",
+		       __func__);
+		r = -ENOMEM;
+		goto out;
+	}
+	match->pt_dev.guest.busnr = pci_pt_dev->guest.busnr;
+	match->pt_dev.guest.devfn = pci_pt_dev->guest.devfn;
+	match->pt_dev.host.busnr  = pci_pt_dev->host.busnr;
+	match->pt_dev.host.devfn  = pci_pt_dev->host.devfn;
+
+	if (irqchip_in_kernel(kvm)) {
+		match->pt_dev.guest.irq   = pci_pt_dev->guest.irq;
+		match->pt_dev.host.irq    = pci_pt_dev->host.irq;
+
+		/* Even though this is PCI, we don't want to use shared
+		 * interrupts. Sharing host devices with guest-assigned devices
+		 * on the same interrupt line is not a happy situation: there
+		 * are going to be long delays in accepting, acking, etc.
+		 */
+		if (request_irq(pci_pt_dev->host.irq, kvm_pci_pt_dev_intr,
+				0, "kvm_pt_device", (void *)kvm)) {
+			printk(KERN_INFO "%s: couldn't allocate irq for pv "
+			       "device\n", __func__);
+			r = -EIO;
+			goto out_free;
+		}
+	}
+	write_lock_irqsave(&kvm_pci_pt_lock, flags);
+
+	INIT_WORK(&match->pt_dev.int_work.work, kvm_pci_pt_work_fn);
+	INIT_WORK(&match->pt_dev.ack_work.work, kvm_pci_pt_work_fn);
+
+	list_add(&match->list, &kvm->arch.pci_pt_dev_head);
+
+	if (irqchip_in_kernel(kvm))
+		set_bit(pci_pt_dev->host.irq, pt_irq_handled);
+	write_unlock_irqrestore(&kvm_pci_pt_lock, flags);
+out:
+	return r;
+out_free:
+	kfree(match);
+	goto out;
+}
+
+static void kvm_free_pci_passthrough(struct kvm *kvm)
+{
+	struct list_head *ptr, *ptr2;
+	struct kvm_pci_pt_dev_list *pci_pt_dev;
+	unsigned long flags;
+
+	write_lock_irqsave(&kvm_pci_pt_lock, flags);
+	list_for_each_safe(ptr, ptr2, &kvm->arch.pci_pt_dev_head) {
+		pci_pt_dev = list_entry(ptr, struct kvm_pci_pt_dev_list, list);
+		if (cancel_work_sync(&pci_pt_dev->pt_dev.int_work.work))
+			/* We had pending work. That means we will have to take
+			 * care of kvm_put_kvm.
+			 */
+			kvm_put_kvm(kvm);
+
+		if (cancel_work_sync(&pci_pt_dev->pt_dev.ack_work.work))
+			/* We had pending work. That means we will have to take
+			 * care of kvm_put_kvm.
+			 */
+			kvm_put_kvm(kvm);
+	}
+
+	list_for_each_safe(ptr, ptr2, &kvm->arch.pci_pt_dev_head) {
+		pci_pt_dev = list_entry(ptr, struct kvm_pci_pt_dev_list, list);
+
+		if (irqchip_in_kernel(kvm) && pci_pt_dev->pt_dev.host.irq)
+			free_irq(pci_pt_dev->pt_dev.host.irq, kvm);
+
+		list_del(&pci_pt_dev->list);
+	}
+	write_unlock_irqrestore(&kvm_pci_pt_lock, flags);
+}
 
 unsigned long segment_base(u16 selector)
 {
@@ -1691,6 +1949,17 @@ long kvm_arch_vm_ioctl(struct file *filp,
 		r = 0;
 		break;
 	}
+	case KVM_ASSIGN_PCI_PT_DEV: {
+		struct kvm_pci_passthrough_dev pci_pt_dev;
+
+		r = -EFAULT;
+		if (copy_from_user(&pci_pt_dev, argp, sizeof pci_pt_dev))
+			goto out;
+		r = kvm_vm_ioctl_pci_pt_dev(kvm, &pci_pt_dev);
+		if (r)
+			goto out;
+		break;
+	}
 	case KVM_GET_PIT: {
 		struct kvm_pit_state ps;
 		r = -EFAULT;
@@ -3911,6 +4180,7 @@ struct  kvm *kvm_arch_create_vm(void)
 		return ERR_PTR(-ENOMEM);
 
 	INIT_LIST_HEAD(&kvm->arch.active_mmu_pages);
+	INIT_LIST_HEAD(&kvm->arch.pci_pt_dev_head);
 
 	return kvm;
 }
@@ -3943,6 +4213,7 @@ static void kvm_free_vcpus(struct kvm *kvm)
 
 void kvm_arch_destroy_vm(struct kvm *kvm)
 {
+	kvm_free_pci_passthrough(kvm);
 	kvm_free_pit(kvm);
 	kfree(kvm->arch.vpic);
 	kfree(kvm->arch.vioapic);
diff --git a/include/asm-x86/kvm_host.h b/include/asm-x86/kvm_host.h
index cd50380..496adbf 100644
--- a/include/asm-x86/kvm_host.h
+++ b/include/asm-x86/kvm_host.h
@@ -81,6 +81,7 @@
 #define KVM_NR_VAR_MTRR 8
 
 extern spinlock_t kvm_lock;
+extern rwlock_t kvm_pci_pt_lock;
 extern struct list_head vm_list;
 
 struct kvm_vcpu;
@@ -300,6 +301,37 @@ struct kvm_mem_alias {
 	gfn_t target_gfn;
 };
 
+/* Some definitions for devices assigned to the guest by the host */
+#define KVM_PT_SOURCE_IRQ	1
+#define KVM_PT_SOURCE_IRQ_ACK	2
+#define KVM_PT_SOURCE_ASSIGN	3
+
+/* For assigned devices, we schedule work in the system workqueue to
+ * inject interrupts into the guest when an interrupt occurs on the
+ * physical device and also when the guest acks the interrupt.
+ */
+struct kvm_pci_pt_work {
+	struct work_struct work;
+	struct kvm *kvm;
+	int irq;
+	bool source;
+};
+
+struct kvm_pci_passthrough_dev_kernel {
+	struct kvm_pci_pt_info guest;
+	struct kvm_pci_pt_info host;
+	struct kvm_pci_pt_work int_work;
+	struct kvm_pci_pt_work ack_work;
+};
+
+/* This list is to store the guest bus:device:function-irq and host
+ * bus:device:function-irq mapping for assigned devices.
+ */
+struct kvm_pci_pt_dev_list {
+	struct list_head list;
+	struct kvm_pci_passthrough_dev_kernel pt_dev;
+};
+
 struct kvm_arch{
 	int naliases;
 	struct kvm_mem_alias aliases[KVM_ALIAS_SLOTS];
@@ -312,6 +344,7 @@ struct kvm_arch{
 	 * Hash table of struct kvm_mmu_page.
 	 */
 	struct list_head active_mmu_pages;
+	struct list_head pci_pt_dev_head;
 	struct kvm_pic *vpic;
 	struct kvm_ioapic *vioapic;
 	struct kvm_pit *vpit;
@@ -456,6 +489,8 @@ void kvm_mmu_change_mmu_pages(struct kvm *kvm, unsigned int kvm_nr_mmu_pages);
 
 int load_pdptrs(struct kvm_vcpu *vcpu, unsigned long cr3);
 
+void kvm_pci_pt_ack_irq(struct kvm *kvm, int vector);
+
 int emulator_write_phys(struct kvm_vcpu *vcpu, gpa_t gpa,
 			  const void *val, int bytes);
 int kvm_pv_mmu_op(struct kvm_vcpu *vcpu, unsigned long bytes,
@@ -558,6 +593,10 @@ void kvm_enable_tdp(void);
 int load_pdptrs(struct kvm_vcpu *vcpu, unsigned long cr3);
 int complete_pio(struct kvm_vcpu *vcpu);
 
+struct kvm_pci_pt_dev_list *
+kvm_find_pci_pt_dev(struct list_head *head,
+		    struct kvm_pci_pt_info *pt_pci_info, int irq, int source);
+
 static inline struct kvm_mmu_page *page_header(hpa_t shadow_page)
 {
 	struct page *page = pfn_to_page(shadow_page >> PAGE_SHIFT);
diff --git a/include/asm-x86/kvm_para.h b/include/asm-x86/kvm_para.h
index 5098459..5f93b78 100644
--- a/include/asm-x86/kvm_para.h
+++ b/include/asm-x86/kvm_para.h
@@ -155,6 +155,20 @@ static inline unsigned int kvm_arch_para_features(void)
 	return cpuid_eax(KVM_CPUID_FEATURES);
 }
 
-#endif
+#endif /* KERNEL */
 
+/* Stores information for identifying host PCI devices assigned to the
+ * guest: this is used in the host kernel and in the userspace.
+ */
+struct kvm_pci_pt_info {
+	unsigned char busnr;
+	unsigned int devfn;
+	__u32 irq;
+};
+
+/* Mapping between host and guest PCI device */
+struct kvm_pci_passthrough_dev {
+	struct kvm_pci_pt_info guest;
+	struct kvm_pci_pt_info host;
+};
 #endif
diff --git a/include/linux/kvm.h b/include/linux/kvm.h
index a281afe..2bf9edf 100644
--- a/include/linux/kvm.h
+++ b/include/linux/kvm.h
@@ -346,6 +346,7 @@ struct kvm_trace_rec {
 #define KVM_CAP_NOP_IO_DELAY 12
 #define KVM_CAP_PV_MMU 13
 #define KVM_CAP_MP_STATE 14
+#define KVM_CAP_PCI_PASSTHROUGH 15
 
 /*
  * ioctls for VM fds
@@ -371,6 +372,8 @@ struct kvm_trace_rec {
 #define KVM_CREATE_PIT		  _IO(KVMIO,  0x64)
 #define KVM_GET_PIT		  _IOWR(KVMIO, 0x65, struct kvm_pit_state)
 #define KVM_SET_PIT		  _IOR(KVMIO,  0x66, struct kvm_pit_state)
+#define KVM_ASSIGN_PCI_PT_DEV	  _IOR(KVMIO, 0x67, \
+				       struct kvm_pci_passthrough_dev)
 
 /*
  * ioctls for vcpu fds
diff --git a/virt/kvm/ioapic.c b/virt/kvm/ioapic.c
index 4c41a00..294b730 100644
--- a/virt/kvm/ioapic.c
+++ b/virt/kvm/ioapic.c
@@ -298,7 +298,9 @@ void kvm_ioapic_update_eoi(struct kvm *kvm, int vector)
 {
 	struct kvm_ioapic *ioapic = kvm->arch.vioapic;
 	union ioapic_redir_entry *ent;
+	struct kvm_pci_pt_dev_list *match;
 	int gsi;
+	unsigned long flags;
 
 	gsi = kvm_get_eoi_gsi(ioapic, vector);
 	if (gsi == -1) {
@@ -311,8 +313,13 @@ void kvm_ioapic_update_eoi(struct kvm *kvm, int vector)
 	ASSERT(ent->fields.trig_mode == IOAPIC_LEVEL_TRIG);
 
 	ent->fields.remote_irr = 0;
-	if (!ent->fields.mask && (ioapic->irr & (1 << gsi)))
-		ioapic_deliver(ioapic, gsi);
+	read_lock_irqsave(&kvm_pci_pt_lock, flags);
+	match = kvm_find_pci_pt_dev(&kvm->arch.pci_pt_dev_head, NULL, gsi,
+				    KVM_PT_SOURCE_IRQ_ACK);
+	read_unlock_irqrestore(&kvm_pci_pt_lock, flags);
+	if (!match)
+		if (!ent->fields.mask && (ioapic->irr & (1 << gsi)))
+			ioapic_deliver(ioapic, gsi);
 }
 
 static int ioapic_in_range(struct kvm_io_device *this, gpa_t addr)
-- 
1.5.5.1

