Return-Path: <linux-kernel-owner+w=401wt.eu-S1761755AbZB1Bup@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761755AbZB1Bup (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Feb 2009 20:50:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755821AbZB1Bmx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Feb 2009 20:42:53 -0500
Received: from mx2.redhat.com ([66.187.237.31]:41791 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754842AbZB1Bl7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Feb 2009 20:41:59 -0500
From: Avi Kivity <avi@redhat.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 18/30] KVM: Report IRQ injection status to userspace.
Date: Sat, 28 Feb 2009 03:41:37 +0200
Message-Id: <1235785309-12835-19-git-send-email-avi@redhat.com>
In-Reply-To: <1235785309-12835-1-git-send-email-avi@redhat.com>
References: <1235785309-12835-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Gleb Natapov <gleb@redhat.com>

IRQ injection status is either -1 (if there was no CPU found
that should except the interrupt because IRQ was masked or
ioapic was misconfigured or ...) or >= 0 in that case the
number indicates to how many CPUs interrupt was injected.
If the value is 0 it means that the interrupt was coalesced
and probably should be reinjected.

Signed-off-by: Gleb Natapov <gleb@redhat.com>
Signed-off-by: Avi Kivity <avi@redhat.com>
---
 arch/ia64/kvm/kvm-ia64.c        |   12 +++++++++-
 arch/x86/include/asm/kvm_host.h |    2 +-
 arch/x86/kvm/i8259.c            |   18 ++++++++++++----
 arch/x86/kvm/x86.c              |   13 ++++++++++-
 include/linux/kvm.h             |    7 +++++-
 include/linux/kvm_host.h        |    4 +-
 virt/kvm/ioapic.c               |   23 +++++++++++++++------
 virt/kvm/ioapic.h               |    2 +-
 virt/kvm/irq_comm.c             |   41 ++++++++++++++++++++++++++------------
 9 files changed, 88 insertions(+), 34 deletions(-)

diff --git a/arch/ia64/kvm/kvm-ia64.c b/arch/ia64/kvm/kvm-ia64.c
index 9c77e39..076b00d 100644
--- a/arch/ia64/kvm/kvm-ia64.c
+++ b/arch/ia64/kvm/kvm-ia64.c
@@ -182,7 +182,7 @@ int kvm_dev_ioctl_check_extension(long ext)
 	switch (ext) {
 	case KVM_CAP_IRQCHIP:
 	case KVM_CAP_MP_STATE:
-
+	case KVM_CAP_IRQ_INJECT_STATUS:
 		r = 1;
 		break;
 	case KVM_CAP_COALESCED_MMIO:
@@ -927,6 +927,7 @@ long kvm_arch_vm_ioctl(struct file *filp,
 			goto out;
 		}
 		break;
+	case KVM_IRQ_LINE_STATUS:
 	case KVM_IRQ_LINE: {
 		struct kvm_irq_level irq_event;
 
@@ -934,10 +935,17 @@ long kvm_arch_vm_ioctl(struct file *filp,
 		if (copy_from_user(&irq_event, argp, sizeof irq_event))
 			goto out;
 		if (irqchip_in_kernel(kvm)) {
+			__s32 status;
 			mutex_lock(&kvm->lock);
-			kvm_set_irq(kvm, KVM_USERSPACE_IRQ_SOURCE_ID,
+			status = kvm_set_irq(kvm, KVM_USERSPACE_IRQ_SOURCE_ID,
 				    irq_event.irq, irq_event.level);
 			mutex_unlock(&kvm->lock);
+			if (ioctl == KVM_IRQ_LINE_STATUS) {
+				irq_event.status = status;
+				if (copy_to_user(argp, &irq_event,
+							sizeof irq_event))
+					goto out;
+			}
 			r = 0;
 		}
 		break;
diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 55fd4c5..f0faf58 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -616,7 +616,7 @@ void kvm_queue_exception_e(struct kvm_vcpu *vcpu, unsigned nr, u32 error_code);
 void kvm_inject_page_fault(struct kvm_vcpu *vcpu, unsigned long cr2,
 			   u32 error_code);
 
-void kvm_pic_set_irq(void *opaque, int irq, int level);
+int kvm_pic_set_irq(void *opaque, int irq, int level);
 
 void kvm_inject_nmi(struct kvm_vcpu *vcpu);
 
diff --git a/arch/x86/kvm/i8259.c b/arch/x86/kvm/i8259.c
index 9316037..b4e662e 100644
--- a/arch/x86/kvm/i8259.c
+++ b/arch/x86/kvm/i8259.c
@@ -77,12 +77,13 @@ void kvm_pic_clear_isr_ack(struct kvm *kvm)
 /*
  * set irq level. If an edge is detected, then the IRR is set to 1
  */
-static inline void pic_set_irq1(struct kvm_kpic_state *s, int irq, int level)
+static inline int pic_set_irq1(struct kvm_kpic_state *s, int irq, int level)
 {
-	int mask;
+	int mask, ret = 1;
 	mask = 1 << irq;
 	if (s->elcr & mask)	/* level triggered */
 		if (level) {
+			ret = !(s->irr & mask);
 			s->irr |= mask;
 			s->last_irr |= mask;
 		} else {
@@ -91,11 +92,15 @@ static inline void pic_set_irq1(struct kvm_kpic_state *s, int irq, int level)
 		}
 	else	/* edge triggered */
 		if (level) {
-			if ((s->last_irr & mask) == 0)
+			if ((s->last_irr & mask) == 0) {
+				ret = !(s->irr & mask);
 				s->irr |= mask;
+			}
 			s->last_irr |= mask;
 		} else
 			s->last_irr &= ~mask;
+
+	return (s->imr & mask) ? -1 : ret;
 }
 
 /*
@@ -172,16 +177,19 @@ void kvm_pic_update_irq(struct kvm_pic *s)
 	pic_unlock(s);
 }
 
-void kvm_pic_set_irq(void *opaque, int irq, int level)
+int kvm_pic_set_irq(void *opaque, int irq, int level)
 {
 	struct kvm_pic *s = opaque;
+	int ret = -1;
 
 	pic_lock(s);
 	if (irq >= 0 && irq < PIC_NUM_PINS) {
-		pic_set_irq1(&s->pics[irq >> 3], irq & 7, level);
+		ret = pic_set_irq1(&s->pics[irq >> 3], irq & 7, level);
 		pic_update_irq(s);
 	}
 	pic_unlock(s);
+
+	return ret;
 }
 
 /*
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 05d7be8..e4db5be 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -1019,6 +1019,7 @@ int kvm_dev_ioctl_check_extension(long ext)
 	case KVM_CAP_MP_STATE:
 	case KVM_CAP_SYNC_MMU:
 	case KVM_CAP_REINJECT_CONTROL:
+	case KVM_CAP_IRQ_INJECT_STATUS:
 		r = 1;
 		break;
 	case KVM_CAP_COALESCED_MMIO:
@@ -1877,6 +1878,7 @@ long kvm_arch_vm_ioctl(struct file *filp,
 	create_pit_unlock:
 		mutex_unlock(&kvm->lock);
 		break;
+	case KVM_IRQ_LINE_STATUS:
 	case KVM_IRQ_LINE: {
 		struct kvm_irq_level irq_event;
 
@@ -1884,10 +1886,17 @@ long kvm_arch_vm_ioctl(struct file *filp,
 		if (copy_from_user(&irq_event, argp, sizeof irq_event))
 			goto out;
 		if (irqchip_in_kernel(kvm)) {
+			__s32 status;
 			mutex_lock(&kvm->lock);
-			kvm_set_irq(kvm, KVM_USERSPACE_IRQ_SOURCE_ID,
-				    irq_event.irq, irq_event.level);
+			status = kvm_set_irq(kvm, KVM_USERSPACE_IRQ_SOURCE_ID,
+					irq_event.irq, irq_event.level);
 			mutex_unlock(&kvm->lock);
+			if (ioctl == KVM_IRQ_LINE_STATUS) {
+				irq_event.status = status;
+				if (copy_to_user(argp, &irq_event,
+							sizeof irq_event))
+					goto out;
+			}
 			r = 0;
 		}
 		break;
diff --git a/include/linux/kvm.h b/include/linux/kvm.h
index 2163b3d..dd48225 100644
--- a/include/linux/kvm.h
+++ b/include/linux/kvm.h
@@ -48,7 +48,10 @@ struct kvm_irq_level {
 	 * For IA-64 (APIC model) IOAPIC0: irq 0-23; IOAPIC1: irq 24-47..
 	 * For X86 (standard AT mode) PIC0/1: irq 0-15. IOAPIC0: 0-23..
 	 */
-	__u32 irq;
+	union {
+		__u32 irq;
+		__s32 status;
+	};
 	__u32 level;
 };
 
@@ -402,6 +405,7 @@ struct kvm_trace_rec {
 #ifdef __KVM_HAVE_IOAPIC
 #define KVM_CAP_IRQ_ROUTING 25
 #endif
+#define KVM_CAP_IRQ_INJECT_STATUS 26
 
 #ifdef KVM_CAP_IRQ_ROUTING
 
@@ -465,6 +469,7 @@ struct kvm_irq_routing {
 #define KVM_CREATE_PIT		  _IO(KVMIO,  0x64)
 #define KVM_GET_PIT		  _IOWR(KVMIO, 0x65, struct kvm_pit_state)
 #define KVM_SET_PIT		  _IOR(KVMIO,  0x66, struct kvm_pit_state)
+#define KVM_IRQ_LINE_STATUS	  _IOWR(KVMIO, 0x67, struct kvm_irq_level)
 #define KVM_REGISTER_COALESCED_MMIO \
 			_IOW(KVMIO,  0x67, struct kvm_coalesced_mmio_zone)
 #define KVM_UNREGISTER_COALESCED_MMIO \
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 18b4df8..894a56e 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -110,7 +110,7 @@ struct kvm_memory_slot {
 
 struct kvm_kernel_irq_routing_entry {
 	u32 gsi;
-	void (*set)(struct kvm_kernel_irq_routing_entry *e,
+	int (*set)(struct kvm_kernel_irq_routing_entry *e,
 		    struct kvm *kvm, int level);
 	union {
 		struct {
@@ -352,7 +352,7 @@ void kvm_unregister_irq_mask_notifier(struct kvm *kvm, int irq,
 				      struct kvm_irq_mask_notifier *kimn);
 void kvm_fire_mask_notifiers(struct kvm *kvm, int irq, bool mask);
 
-void kvm_set_irq(struct kvm *kvm, int irq_source_id, int irq, int level);
+int kvm_set_irq(struct kvm *kvm, int irq_source_id, int irq, int level);
 void kvm_notify_acked_irq(struct kvm *kvm, unsigned irqchip, unsigned pin);
 void kvm_register_irq_ack_notifier(struct kvm *kvm,
 				   struct kvm_irq_ack_notifier *kian);
diff --git a/virt/kvm/ioapic.c b/virt/kvm/ioapic.c
index 1c986ac..c3b99de 100644
--- a/virt/kvm/ioapic.c
+++ b/virt/kvm/ioapic.c
@@ -83,19 +83,22 @@ static unsigned long ioapic_read_indirect(struct kvm_ioapic *ioapic,
 	return result;
 }
 
-static void ioapic_service(struct kvm_ioapic *ioapic, unsigned int idx)
+static int ioapic_service(struct kvm_ioapic *ioapic, unsigned int idx)
 {
 	union ioapic_redir_entry *pent;
+	int injected = -1;
 
 	pent = &ioapic->redirtbl[idx];
 
 	if (!pent->fields.mask) {
-		int injected = ioapic_deliver(ioapic, idx);
+		injected = ioapic_deliver(ioapic, idx);
 		if (injected && pent->fields.trig_mode == IOAPIC_LEVEL_TRIG)
 			pent->fields.remote_irr = 1;
 	}
 	if (!pent->fields.trig_mode)
 		ioapic->irr &= ~(1 << idx);
+
+	return injected;
 }
 
 static void ioapic_write_indirect(struct kvm_ioapic *ioapic, u32 val)
@@ -207,7 +210,7 @@ static int ioapic_deliver(struct kvm_ioapic *ioapic, int irq)
 	u8 trig_mode = ioapic->redirtbl[irq].fields.trig_mode;
 	u32 deliver_bitmask;
 	struct kvm_vcpu *vcpu;
-	int vcpu_id, r = 0;
+	int vcpu_id, r = -1;
 
 	ioapic_debug("dest=%x dest_mode=%x delivery_mode=%x "
 		     "vector=%x trig_mode=%x\n",
@@ -247,7 +250,9 @@ static int ioapic_deliver(struct kvm_ioapic *ioapic, int irq)
 			deliver_bitmask &= ~(1 << vcpu_id);
 			vcpu = ioapic->kvm->vcpus[vcpu_id];
 			if (vcpu) {
-				r = ioapic_inj_irq(ioapic, vcpu, vector,
+				if (r < 0)
+					r = 0;
+				r += ioapic_inj_irq(ioapic, vcpu, vector,
 					       trig_mode, delivery_mode);
 			}
 		}
@@ -258,8 +263,10 @@ static int ioapic_deliver(struct kvm_ioapic *ioapic, int irq)
 				continue;
 			deliver_bitmask &= ~(1 << vcpu_id);
 			vcpu = ioapic->kvm->vcpus[vcpu_id];
-			if (vcpu)
+			if (vcpu) {
 				ioapic_inj_nmi(vcpu);
+				r = 1;
+			}
 			else
 				ioapic_debug("NMI to vcpu %d failed\n",
 						vcpu->vcpu_id);
@@ -273,11 +280,12 @@ static int ioapic_deliver(struct kvm_ioapic *ioapic, int irq)
 	return r;
 }
 
-void kvm_ioapic_set_irq(struct kvm_ioapic *ioapic, int irq, int level)
+int kvm_ioapic_set_irq(struct kvm_ioapic *ioapic, int irq, int level)
 {
 	u32 old_irr = ioapic->irr;
 	u32 mask = 1 << irq;
 	union ioapic_redir_entry entry;
+	int ret = 1;
 
 	if (irq >= 0 && irq < IOAPIC_NUM_PINS) {
 		entry = ioapic->redirtbl[irq];
@@ -288,9 +296,10 @@ void kvm_ioapic_set_irq(struct kvm_ioapic *ioapic, int irq, int level)
 			ioapic->irr |= mask;
 			if ((!entry.fields.trig_mode && old_irr != ioapic->irr)
 			    || !entry.fields.remote_irr)
-				ioapic_service(ioapic, irq);
+				ret = ioapic_service(ioapic, irq);
 		}
 	}
+	return ret;
 }
 
 static void __kvm_ioapic_update_eoi(struct kvm_ioapic *ioapic, int pin,
diff --git a/virt/kvm/ioapic.h b/virt/kvm/ioapic.h
index 49c9581..a34bd5e 100644
--- a/virt/kvm/ioapic.h
+++ b/virt/kvm/ioapic.h
@@ -83,7 +83,7 @@ struct kvm_vcpu *kvm_get_lowest_prio_vcpu(struct kvm *kvm, u8 vector,
 				       unsigned long bitmap);
 void kvm_ioapic_update_eoi(struct kvm *kvm, int vector, int trigger_mode);
 int kvm_ioapic_init(struct kvm *kvm);
-void kvm_ioapic_set_irq(struct kvm_ioapic *ioapic, int irq, int level);
+int kvm_ioapic_set_irq(struct kvm_ioapic *ioapic, int irq, int level);
 void kvm_ioapic_reset(struct kvm_ioapic *ioapic);
 u32 kvm_ioapic_get_delivery_bitmask(struct kvm_ioapic *ioapic, u8 dest,
 				u8 dest_mode);
diff --git a/virt/kvm/irq_comm.c b/virt/kvm/irq_comm.c
index 6bc7439..be8aba7 100644
--- a/virt/kvm/irq_comm.c
+++ b/virt/kvm/irq_comm.c
@@ -29,22 +29,24 @@
 
 #include "ioapic.h"
 
-static void kvm_set_pic_irq(struct kvm_kernel_irq_routing_entry *e,
-			    struct kvm *kvm, int level)
+static int kvm_set_pic_irq(struct kvm_kernel_irq_routing_entry *e,
+			   struct kvm *kvm, int level)
 {
 #ifdef CONFIG_X86
-	kvm_pic_set_irq(pic_irqchip(kvm), e->irqchip.pin, level);
+	return kvm_pic_set_irq(pic_irqchip(kvm), e->irqchip.pin, level);
+#else
+	return -1;
 #endif
 }
 
-static void kvm_set_ioapic_irq(struct kvm_kernel_irq_routing_entry *e,
-			       struct kvm *kvm, int level)
+static int kvm_set_ioapic_irq(struct kvm_kernel_irq_routing_entry *e,
+			      struct kvm *kvm, int level)
 {
-	kvm_ioapic_set_irq(kvm->arch.vioapic, e->irqchip.pin, level);
+	return kvm_ioapic_set_irq(kvm->arch.vioapic, e->irqchip.pin, level);
 }
 
-static void kvm_set_msi(struct kvm_kernel_irq_routing_entry *e,
-			struct kvm *kvm, int level)
+static int kvm_set_msi(struct kvm_kernel_irq_routing_entry *e,
+		       struct kvm *kvm, int level)
 {
 	int vcpu_id;
 	struct kvm_vcpu *vcpu;
@@ -88,13 +90,20 @@ static void kvm_set_msi(struct kvm_kernel_irq_routing_entry *e,
 	default:
 		break;
 	}
+	return 1;
 }
 
-/* This should be called with the kvm->lock mutex held */
-void kvm_set_irq(struct kvm *kvm, int irq_source_id, int irq, int level)
+/* This should be called with the kvm->lock mutex held
+ * Return value:
+ *  < 0   Interrupt was ignored (masked or not delivered for other reasons)
+ *  = 0   Interrupt was coalesced (previous irq is still pending)
+ *  > 0   Number of CPUs interrupt was delivered to
+ */
+int kvm_set_irq(struct kvm *kvm, int irq_source_id, int irq, int level)
 {
 	struct kvm_kernel_irq_routing_entry *e;
 	unsigned long *irq_state, sig_level;
+	int ret = -1;
 
 	if (irq < KVM_IOAPIC_NUM_PINS) {
 		irq_state = (unsigned long *)&kvm->arch.irq_states[irq];
@@ -113,8 +122,14 @@ void kvm_set_irq(struct kvm *kvm, int irq_source_id, int irq, int level)
 	 * writes to the unused one.
 	 */
 	list_for_each_entry(e, &kvm->irq_routing, link)
-		if (e->gsi == irq)
-			e->set(e, kvm, sig_level);
+		if (e->gsi == irq) {
+			int r = e->set(e, kvm, sig_level);
+			if (r < 0)
+				continue;
+
+			ret = r + ((ret < 0) ? 0 : ret);
+		}
+	return ret;
 }
 
 void kvm_notify_acked_irq(struct kvm *kvm, unsigned irqchip, unsigned pin)
@@ -232,7 +247,7 @@ int setup_routing_entry(struct kvm_kernel_irq_routing_entry *e,
 			e->set = kvm_set_pic_irq;
 			break;
 		case KVM_IRQCHIP_PIC_SLAVE:
-				e->set = kvm_set_pic_irq;
+			e->set = kvm_set_pic_irq;
 			delta = 8;
 			break;
 		case KVM_IRQCHIP_IOAPIC:
-- 
1.6.0.6

