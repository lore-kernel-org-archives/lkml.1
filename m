Return-Path: <linux-kernel-owner+w=401wt.eu-S1756910AbXIQIqs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756910AbXIQIqs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2007 04:46:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754228AbXIQIdG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Sep 2007 04:33:06 -0400
Received: from il.qumranet.com ([82.166.9.18]:45249 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754391AbXIQIcd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2007 04:32:33 -0400
From: Avi Kivity <avi@qumranet.com>
To: kvm-devel@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org, Eddie Dong <eddie.dong@intel.com>
Subject: [PATCH 067/104] KVM: In-kernel I/O APIC model
Date: Mon, 17 Sep 2007 10:31:49 +0200
Message-Id: <11900179481823-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.3
In-Reply-To: <11900179463203-git-send-email-avi@qumranet.com>
References: <11900179463203-git-send-email-avi@qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Eddie Dong <eddie.dong@intel.com>

This allows in-kernel host-side device drivers to raise guest interrupts
without going to userspace.

Signed-off-by: Yaozu (Eddie) Dong <eddie.dong@intel.com>
Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 drivers/kvm/Makefile   |    2 +-
 drivers/kvm/ioapic.c   |  397 ++++++++++++++++++++++++++++++++++++++++++++++++
 drivers/kvm/irq.c      |    4 -
 drivers/kvm/irq.h      |   50 ++++++
 drivers/kvm/kvm.h      |    1 +
 drivers/kvm/kvm_main.c |   15 ++-
 6 files changed, 461 insertions(+), 8 deletions(-)
 create mode 100644 drivers/kvm/ioapic.c

diff --git a/drivers/kvm/Makefile b/drivers/kvm/Makefile
index 3bf7276..e5a8f4d 100644
--- a/drivers/kvm/Makefile
+++ b/drivers/kvm/Makefile
@@ -2,7 +2,7 @@
 # Makefile for Kernel-based Virtual Machine module
 #
 
-kvm-objs := kvm_main.o mmu.o x86_emulate.o i8259.o irq.o lapic.o
+kvm-objs := kvm_main.o mmu.o x86_emulate.o i8259.o irq.o lapic.o ioapic.o
 obj-$(CONFIG_KVM) += kvm.o
 kvm-intel-objs = vmx.o
 obj-$(CONFIG_KVM_INTEL) += kvm-intel.o
diff --git a/drivers/kvm/ioapic.c b/drivers/kvm/ioapic.c
new file mode 100644
index 0000000..3ee13c3
--- /dev/null
+++ b/drivers/kvm/ioapic.c
@@ -0,0 +1,397 @@
+/*
+ *  Copyright (C) 2001  MandrakeSoft S.A.
+ *
+ *    MandrakeSoft S.A.
+ *    43, rue d'Aboukir
+ *    75002 Paris - France
+ *    http://www.linux-mandrake.com/
+ *    http://www.mandrakesoft.com/
+ *
+ *  This library is free software; you can redistribute it and/or
+ *  modify it under the terms of the GNU Lesser General Public
+ *  License as published by the Free Software Foundation; either
+ *  version 2 of the License, or (at your option) any later version.
+ *
+ *  This library is distributed in the hope that it will be useful,
+ *  but WITHOUT ANY WARRANTY; without even the implied warranty of
+ *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ *  Lesser General Public License for more details.
+ *
+ *  You should have received a copy of the GNU Lesser General Public
+ *  License along with this library; if not, write to the Free Software
+ *  Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307 USA
+ *
+ *  Yunhong Jiang <yunhong.jiang@intel.com>
+ *  Yaozu (Eddie) Dong <eddie.dong@intel.com>
+ *  Based on Xen 3.1 code.
+ */
+
+#include "kvm.h"
+#include <linux/kvm.h>
+#include <linux/mm.h>
+#include <linux/highmem.h>
+#include <linux/smp.h>
+#include <linux/hrtimer.h>
+#include <linux/io.h>
+#include <asm/processor.h>
+#include <asm/msr.h>
+#include <asm/page.h>
+#include <asm/current.h>
+#include <asm/apicdef.h>
+#include "irq.h"
+/* #define ioapic_debug(fmt,arg...) printk(KERN_WARNING fmt,##arg) */
+#define ioapic_debug(fmt, arg...)
+static void ioapic_deliver(struct kvm_ioapic *vioapic, int irq);
+
+static unsigned long ioapic_read_indirect(struct kvm_ioapic *ioapic,
+					  unsigned long addr,
+					  unsigned long length)
+{
+	unsigned long result = 0;
+
+	switch (ioapic->ioregsel) {
+	case IOAPIC_REG_VERSION:
+		result = ((((IOAPIC_NUM_PINS - 1) & 0xff) << 16)
+			  | (IOAPIC_VERSION_ID & 0xff));
+		break;
+
+	case IOAPIC_REG_APIC_ID:
+	case IOAPIC_REG_ARB_ID:
+		result = ((ioapic->id & 0xf) << 24);
+		break;
+
+	default:
+		{
+			u32 redir_index = (ioapic->ioregsel - 0x10) >> 1;
+			u64 redir_content;
+
+			ASSERT(redir_index < IOAPIC_NUM_PINS);
+
+			redir_content = ioapic->redirtbl[redir_index].bits;
+			result = (ioapic->ioregsel & 0x1) ?
+			    (redir_content >> 32) & 0xffffffff :
+			    redir_content & 0xffffffff;
+			break;
+		}
+	}
+
+	return result;
+}
+
+static void ioapic_service(struct kvm_ioapic *ioapic, unsigned int idx)
+{
+	union ioapic_redir_entry *pent;
+
+	pent = &ioapic->redirtbl[idx];
+
+	if (!pent->fields.mask) {
+		ioapic_deliver(ioapic, idx);
+		if (pent->fields.trig_mode == IOAPIC_LEVEL_TRIG)
+			pent->fields.remote_irr = 1;
+	}
+}
+
+static void ioapic_write_indirect(struct kvm_ioapic *ioapic, u32 val)
+{
+	int index;
+
+	switch (ioapic->ioregsel) {
+	case IOAPIC_REG_VERSION:
+		/* Writes are ignored. */
+		break;
+
+	case IOAPIC_REG_APIC_ID:
+		ioapic->id = (val >> 24) & 0xf;
+		break;
+
+	case IOAPIC_REG_ARB_ID:
+		break;
+
+	default:
+		index = (ioapic->ioregsel - 0x10) >> 1;
+
+		ioapic_debug("change redir index %x val %x", index, val);
+		ASSERT(irq < IOAPIC_NUM_PINS);
+		if (ioapic->ioregsel & 1) {
+			ioapic->redirtbl[index].bits &= 0xffffffff;
+			ioapic->redirtbl[index].bits |= (u64) val << 32;
+		} else {
+			ioapic->redirtbl[index].bits &= ~0xffffffffULL;
+			ioapic->redirtbl[index].bits |= (u32) val;
+			ioapic->redirtbl[index].fields.remote_irr = 0;
+		}
+		ioapic_service(ioapic, index);
+		break;
+	}
+}
+
+static void ioapic_inj_irq(struct kvm_ioapic *ioapic,
+			   struct kvm_lapic *target,
+			   u8 vector, u8 trig_mode, u8 delivery_mode)
+{
+	ioapic_debug("irq %d trig %d deliv %d", vector, trig_mode,
+		     delivery_mode);
+
+	ASSERT((delivery_mode == dest_Fixed) ||
+	       (delivery_mode == dest_LowestPrio));
+
+	kvm_apic_set_irq(target, vector, trig_mode);
+}
+
+static u32 ioapic_get_delivery_bitmask(struct kvm_ioapic *ioapic, u8 dest,
+				       u8 dest_mode)
+{
+	u32 mask = 0;
+	int i;
+	struct kvm *kvm = ioapic->kvm;
+	struct kvm_vcpu *vcpu;
+
+	ioapic_debug("dest %d dest_mode %d", dest, dest_mode);
+
+	if (dest_mode == 0) {	/* Physical mode. */
+		if (dest == 0xFF) {	/* Broadcast. */
+			for (i = 0; i < KVM_MAX_VCPUS; ++i)
+				if (kvm->vcpus[i] && kvm->vcpus[i]->apic)
+					mask |= 1 << i;
+			return mask;
+		}
+		for (i = 0; i < KVM_MAX_VCPUS; ++i) {
+			vcpu = kvm->vcpus[i];
+			if (!vcpu)
+				continue;
+			if (kvm_apic_match_physical_addr(vcpu->apic, dest)) {
+				if (vcpu->apic)
+					mask = 1 << i;
+				break;
+			}
+		}
+	} else if (dest != 0)	/* Logical mode, MDA non-zero. */
+		for (i = 0; i < KVM_MAX_VCPUS; ++i) {
+			vcpu = kvm->vcpus[i];
+			if (!vcpu)
+				continue;
+			if (vcpu->apic &&
+			    kvm_apic_match_logical_addr(vcpu->apic, dest))
+				mask |= 1 << vcpu->vcpu_id;
+		}
+	ioapic_debug("mask %x", mask);
+	return mask;
+}
+
+static void ioapic_deliver(struct kvm_ioapic *ioapic, int irq)
+{
+	u8 dest = ioapic->redirtbl[irq].fields.dest_id;
+	u8 dest_mode = ioapic->redirtbl[irq].fields.dest_mode;
+	u8 delivery_mode = ioapic->redirtbl[irq].fields.delivery_mode;
+	u8 vector = ioapic->redirtbl[irq].fields.vector;
+	u8 trig_mode = ioapic->redirtbl[irq].fields.trig_mode;
+	u32 deliver_bitmask;
+	struct kvm_lapic *target;
+	struct kvm_vcpu *vcpu;
+	int vcpu_id;
+
+	ioapic_debug("dest=%x dest_mode=%x delivery_mode=%x "
+		     "vector=%x trig_mode=%x",
+		     dest, dest_mode, delivery_mode, vector, trig_mode);
+
+	deliver_bitmask = ioapic_get_delivery_bitmask(ioapic, dest, dest_mode);
+	if (!deliver_bitmask) {
+		ioapic_debug("no target on destination");
+		return;
+	}
+
+	switch (delivery_mode) {
+	case dest_LowestPrio:
+		target =
+		    kvm_apic_round_robin(ioapic->kvm, vector, deliver_bitmask);
+		if (target != NULL)
+			ioapic_inj_irq(ioapic, target, vector,
+				       trig_mode, delivery_mode);
+		else
+			ioapic_debug("null round robin: "
+				     "mask=%x vector=%x delivery_mode=%x",
+				     deliver_bitmask, vector, dest_LowestPrio);
+		break;
+	case dest_Fixed:
+		for (vcpu_id = 0; deliver_bitmask != 0; vcpu_id++) {
+			if (!(deliver_bitmask & (1 << vcpu_id)))
+				continue;
+			deliver_bitmask &= ~(1 << vcpu_id);
+			vcpu = ioapic->kvm->vcpus[vcpu_id];
+			if (vcpu) {
+				target = vcpu->apic;
+				ioapic_inj_irq(ioapic, target, vector,
+					       trig_mode, delivery_mode);
+			}
+		}
+		break;
+
+		/* TODO: NMI */
+	default:
+		printk(KERN_WARNING "Unsupported delivery mode %d\n",
+		       delivery_mode);
+		break;
+	}
+}
+
+void kvm_ioapic_set_irq(struct kvm_ioapic *ioapic, int irq, int level)
+{
+	u32 mask = 1 << irq;
+	union ioapic_redir_entry entry;
+
+	if (irq >= 0 && irq < IOAPIC_NUM_PINS) {
+		entry = ioapic->redirtbl[irq];
+		if (!level)
+			ioapic->irr &= ~mask;
+		if (entry.fields.trig_mode) {	/* level triggered */
+			if (level && !entry.fields.remote_irr) {
+				ioapic->irr |= mask;
+				ioapic_service(ioapic, irq);
+			}
+		} else if (level && !(ioapic->irr & mask)) {
+			/*
+			 * edge triggered
+			 */
+			ioapic->irr |= mask;
+			ioapic_service(ioapic, irq);
+		}
+	}
+}
+
+static int get_eoi_gsi(struct kvm_ioapic *ioapic, int vector)
+{
+	int i;
+
+	for (i = 0; i < IOAPIC_NUM_PINS; i++)
+		if (ioapic->redirtbl[i].fields.vector == vector)
+			return i;
+	return -1;
+}
+
+void kvm_ioapic_update_eoi(struct kvm *kvm, int vector)
+{
+	struct kvm_ioapic *ioapic = kvm->vioapic;
+	union ioapic_redir_entry *ent;
+	int gsi;
+
+	gsi = get_eoi_gsi(ioapic, vector);
+	if (gsi == -1) {
+		printk(KERN_WARNING "Can't find redir item for %d EOI\n",
+		       vector);
+		return;
+	}
+
+	ent = &ioapic->redirtbl[gsi];
+	ASSERT(ent->fields.trig_mode == IOAPIC_LEVEL_TRIG);
+
+	ent->fields.remote_irr = 0;
+	/*
+	 * TODO:
+	 * qemu ioapic doesn't re-deliver level
+	 * triggered irq at the time of APIC EOI.
+	 * Adding back following code sme time causes RHEL5U
+	 * guest boot no progress at ethernet bringup, so
+	 * leave it same with qemu for now and revisit later.
+	 */
+/*
+	if (!ent->fields.mask && (ioapic->irr & (1 << gsi)))
+		ioapic_deliver(ioapic, gsi);
+*/
+}
+
+static int ioapic_in_range(struct kvm_io_device *this, gpa_t addr)
+{
+	struct kvm_ioapic *ioapic = (struct kvm_ioapic *)this->private;
+
+	return ((addr >= ioapic->base_address &&
+		 (addr < ioapic->base_address + IOAPIC_MEM_LENGTH)));
+}
+
+static void ioapic_mmio_read(struct kvm_io_device *this, gpa_t addr, int len,
+			     void *val)
+{
+	struct kvm_ioapic *ioapic = (struct kvm_ioapic *)this->private;
+	u32 result;
+
+	ioapic_debug("addr %lx", (unsigned long)addr);
+	ASSERT(!(addr & 0xf));	/* check alignment */
+
+	addr &= 0xff;
+	switch (addr) {
+	case IOAPIC_REG_SELECT:
+		result = ioapic->ioregsel;
+		break;
+
+	case IOAPIC_REG_WINDOW:
+		result = ioapic_read_indirect(ioapic, addr, len);
+		break;
+
+	default:
+		result = 0;
+		break;
+	}
+	switch (len) {
+	case 8:
+		*(u64 *) val = result;
+		break;
+	case 1:
+	case 2:
+	case 4:
+		memcpy(val, (char *)&result, len);
+		break;
+	default:
+		printk(KERN_WARNING "ioapic: wrong length %d\n", len);
+	}
+}
+
+static void ioapic_mmio_write(struct kvm_io_device *this, gpa_t addr, int len,
+			      const void *val)
+{
+	struct kvm_ioapic *ioapic = (struct kvm_ioapic *)this->private;
+	u32 data;
+
+	ioapic_debug("ioapic_mmio_write addr=%lx len=%d val=%p\n",
+		     addr, len, val);
+	ASSERT(!(addr & 0xf));	/* check alignment */
+	if (len == 4 || len == 8)
+		data = *(u32 *) val;
+	else {
+		printk(KERN_WARNING "ioapic: Unsupported size %d\n", len);
+		return;
+	}
+
+	addr &= 0xff;
+	switch (addr) {
+	case IOAPIC_REG_SELECT:
+		ioapic->ioregsel = data;
+		break;
+
+	case IOAPIC_REG_WINDOW:
+		ioapic_write_indirect(ioapic, data);
+		break;
+
+	default:
+		break;
+	}
+}
+
+int kvm_ioapic_init(struct kvm *kvm)
+{
+	struct kvm_ioapic *ioapic;
+	int i;
+
+	ioapic = kzalloc(sizeof(struct kvm_ioapic), GFP_KERNEL);
+	if (!ioapic)
+		return -ENOMEM;
+	kvm->vioapic = ioapic;
+	for (i = 0; i < IOAPIC_NUM_PINS; i++)
+		ioapic->redirtbl[i].fields.mask = 1;
+	ioapic->base_address = IOAPIC_DEFAULT_BASE_ADDRESS;
+	ioapic->dev.read = ioapic_mmio_read;
+	ioapic->dev.write = ioapic_mmio_write;
+	ioapic->dev.in_range = ioapic_in_range;
+	ioapic->dev.private = ioapic;
+	ioapic->kvm = kvm;
+	kvm_io_bus_register_dev(&kvm->mmio_bus, &ioapic->dev);
+	return 0;
+}
diff --git a/drivers/kvm/irq.c b/drivers/kvm/irq.c
index 0b4430a..5265f82 100644
--- a/drivers/kvm/irq.c
+++ b/drivers/kvm/irq.c
@@ -74,7 +74,3 @@ void kvm_vcpu_kick(struct kvm_vcpu *vcpu)
 		smp_call_function_single(ipi_pcpu, vcpu_kick_intr, vcpu, 0, 0);
 }
 
-void kvm_ioapic_update_eoi(struct kvm *kvm, int vector)
-{
-	/* TODO: for kernel IOAPIC */
-}
diff --git a/drivers/kvm/irq.h b/drivers/kvm/irq.h
index 57e23bd..fff5733 100644
--- a/drivers/kvm/irq.h
+++ b/drivers/kvm/irq.h
@@ -60,6 +60,49 @@ int kvm_pic_read_irq(struct kvm_pic *s);
 int kvm_cpu_get_interrupt(struct kvm_vcpu *v);
 int kvm_cpu_has_interrupt(struct kvm_vcpu *v);
 
+#define IOAPIC_NUM_PINS  24
+#define IOAPIC_VERSION_ID 0x11	/* IOAPIC version */
+#define IOAPIC_EDGE_TRIG  0
+#define IOAPIC_LEVEL_TRIG 1
+
+#define IOAPIC_DEFAULT_BASE_ADDRESS  0xfec00000
+#define IOAPIC_MEM_LENGTH            0x100
+
+/* Direct registers. */
+#define IOAPIC_REG_SELECT  0x00
+#define IOAPIC_REG_WINDOW  0x10
+#define IOAPIC_REG_EOI     0x40	/* IA64 IOSAPIC only */
+
+/* Indirect registers. */
+#define IOAPIC_REG_APIC_ID 0x00	/* x86 IOAPIC only */
+#define IOAPIC_REG_VERSION 0x01
+#define IOAPIC_REG_ARB_ID  0x02	/* x86 IOAPIC only */
+
+struct kvm_ioapic {
+	struct kvm_io_device dev;
+	unsigned long base_address;
+	struct kvm *kvm;
+	u32 ioregsel;
+	u32 id;
+	u32 irr;
+	union ioapic_redir_entry {
+		u64 bits;
+		struct {
+			u8 vector;
+			u8 delivery_mode:3;
+			u8 dest_mode:1;
+			u8 delivery_status:1;
+			u8 polarity:1;
+			u8 remote_irr:1;
+			u8 trig_mode:1;
+			u8 mask:1;
+			u8 reserve:7;
+			u8 reserved[4];
+			u8 dest_id;
+		} fields;
+	} redirtbl[IOAPIC_NUM_PINS];
+};
+
 struct kvm_lapic {
 	unsigned long base_address;
 	struct kvm_io_device dev;
@@ -96,8 +139,15 @@ void kvm_free_apic(struct kvm_lapic *apic);
 u64 kvm_lapic_get_cr8(struct kvm_vcpu *vcpu);
 void kvm_lapic_set_tpr(struct kvm_vcpu *vcpu, unsigned long cr8);
 void kvm_lapic_set_base(struct kvm_vcpu *vcpu, u64 value);
+struct kvm_lapic *kvm_apic_round_robin(struct kvm *kvm, u8 vector,
+				       unsigned long bitmap);
 u64 kvm_get_apic_base(struct kvm_vcpu *vcpu);
 void kvm_set_apic_base(struct kvm_vcpu *vcpu, u64 data);
+int kvm_apic_match_physical_addr(struct kvm_lapic *apic, u16 dest);
 void kvm_ioapic_update_eoi(struct kvm *kvm, int vector);
+int kvm_apic_match_logical_addr(struct kvm_lapic *apic, u8 mda);
+int kvm_apic_set_irq(struct kvm_lapic *apic, u8 vec, u8 trig);
+int kvm_ioapic_init(struct kvm *kvm);
+void kvm_ioapic_set_irq(struct kvm_ioapic *ioapic, int irq, int level);
 
 #endif
diff --git a/drivers/kvm/kvm.h b/drivers/kvm/kvm.h
index a5790cb..0a11b0f 100644
--- a/drivers/kvm/kvm.h
+++ b/drivers/kvm/kvm.h
@@ -410,6 +410,7 @@ struct kvm {
 	struct kvm_io_bus mmio_bus;
 	struct kvm_io_bus pio_bus;
 	struct kvm_pic *vpic;
+	struct kvm_ioapic *vioapic;
 };
 
 static inline struct kvm_pic *pic_irqchip(struct kvm *kvm)
diff --git a/drivers/kvm/kvm_main.c b/drivers/kvm/kvm_main.c
index 401e3cd..ffbdadd 100644
--- a/drivers/kvm/kvm_main.c
+++ b/drivers/kvm/kvm_main.c
@@ -381,6 +381,7 @@ static void kvm_destroy_vm(struct kvm *kvm)
 	kvm_io_bus_destroy(&kvm->pio_bus);
 	kvm_io_bus_destroy(&kvm->mmio_bus);
 	kfree(kvm->vpic);
+	kfree(kvm->vioapic);
 	kvm_free_vcpus(kvm);
 	kvm_free_physmem(kvm);
 	kfree(kvm);
@@ -2771,8 +2772,14 @@ static long kvm_vm_ioctl(struct file *filp,
 	case KVM_CREATE_IRQCHIP:
 		r = -ENOMEM;
 		kvm->vpic = kvm_create_pic(kvm);
-		if (kvm->vpic)
-			r = 0;
+		if (kvm->vpic) {
+			r = kvm_ioapic_init(kvm);
+			if (r) {
+				kfree(kvm->vpic);
+				kvm->vpic = NULL;
+				goto out;
+			}
+		}
 		else
 			goto out;
 		break;
@@ -2787,7 +2794,9 @@ static long kvm_vm_ioctl(struct file *filp,
 				kvm_pic_set_irq(pic_irqchip(kvm),
 					irq_event.irq,
 					irq_event.level);
-			/* TODO: IOAPIC */
+			kvm_ioapic_set_irq(kvm->vioapic,
+					irq_event.irq,
+					irq_event.level);
 			r = 0;
 		}
 		break;
-- 
1.5.3

