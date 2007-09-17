Return-Path: <linux-kernel-owner+w=401wt.eu-S1755779AbXIQIqR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755779AbXIQIqR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2007 04:46:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754817AbXIQIdD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Sep 2007 04:33:03 -0400
Received: from il.qumranet.com ([82.166.9.18]:45310 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753103AbXIQIcd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2007 04:32:33 -0400
From: Avi Kivity <avi@qumranet.com>
To: kvm-devel@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org, Eddie Dong <eddie.dong@intel.com>
Subject: [PATCH 064/104] KVM: Add support for in-kernel PIC emulation
Date: Mon, 17 Sep 2007 10:31:46 +0200
Message-Id: <11900179482767-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.3
In-Reply-To: <11900179463203-git-send-email-avi@qumranet.com>
References: <11900179463203-git-send-email-avi@qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Eddie Dong <eddie.dong@intel.com>

Signed-off-by: Yaozu (Eddie) Dong <eddie.dong@intel.com>
Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 drivers/kvm/Makefile   |    2 +-
 drivers/kvm/i8259.c    |  442 ++++++++++++++++++++++++++++++++++++++++++++++++
 drivers/kvm/irq.c      |   61 +++++++
 drivers/kvm/irq.h      |   64 +++++++
 drivers/kvm/kvm.h      |   11 ++
 drivers/kvm/kvm_main.c |   46 +++++-
 drivers/kvm/svm.c      |   69 +++++++-
 drivers/kvm/vmx.c      |   80 ++++++++-
 include/linux/kvm.h    |   19 ++
 9 files changed, 770 insertions(+), 24 deletions(-)
 create mode 100644 drivers/kvm/i8259.c
 create mode 100644 drivers/kvm/irq.c
 create mode 100644 drivers/kvm/irq.h

diff --git a/drivers/kvm/Makefile b/drivers/kvm/Makefile
index c0a789f..952dff3 100644
--- a/drivers/kvm/Makefile
+++ b/drivers/kvm/Makefile
@@ -2,7 +2,7 @@
 # Makefile for Kernel-based Virtual Machine module
 #
 
-kvm-objs := kvm_main.o mmu.o x86_emulate.o
+kvm-objs := kvm_main.o mmu.o x86_emulate.o i8259.o irq.o
 obj-$(CONFIG_KVM) += kvm.o
 kvm-intel-objs = vmx.o
 obj-$(CONFIG_KVM_INTEL) += kvm-intel.o
diff --git a/drivers/kvm/i8259.c b/drivers/kvm/i8259.c
new file mode 100644
index 0000000..40ad104
--- /dev/null
+++ b/drivers/kvm/i8259.c
@@ -0,0 +1,442 @@
+/*
+ * 8259 interrupt controller emulation
+ *
+ * Copyright (c) 2003-2004 Fabrice Bellard
+ * Copyright (c) 2007 Intel Corporation
+ *
+ * Permission is hereby granted, free of charge, to any person obtaining a copy
+ * of this software and associated documentation files (the "Software"), to deal
+ * in the Software without restriction, including without limitation the rights
+ * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
+ * copies of the Software, and to permit persons to whom the Software is
+ * furnished to do so, subject to the following conditions:
+ *
+ * The above copyright notice and this permission notice shall be included in
+ * all copies or substantial portions of the Software.
+ *
+ * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
+ * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
+ * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL
+ * THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
+ * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
+ * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
+ * THE SOFTWARE.
+ * Authors:
+ *   Yaozu (Eddie) Dong <Eddie.dong@intel.com>
+ *   Port from Qemu.
+ */
+#include <linux/mm.h>
+#include "irq.h"
+
+/*
+ * set irq level. If an edge is detected, then the IRR is set to 1
+ */
+static inline void pic_set_irq1(struct kvm_kpic_state *s, int irq, int level)
+{
+	int mask;
+	mask = 1 << irq;
+	if (s->elcr & mask)	/* level triggered */
+		if (level) {
+			s->irr |= mask;
+			s->last_irr |= mask;
+		} else {
+			s->irr &= ~mask;
+			s->last_irr &= ~mask;
+		}
+	else	/* edge triggered */
+		if (level) {
+			if ((s->last_irr & mask) == 0)
+				s->irr |= mask;
+			s->last_irr |= mask;
+		} else
+			s->last_irr &= ~mask;
+}
+
+/*
+ * return the highest priority found in mask (highest = smallest
+ * number). Return 8 if no irq
+ */
+static inline int get_priority(struct kvm_kpic_state *s, int mask)
+{
+	int priority;
+	if (mask == 0)
+		return 8;
+	priority = 0;
+	while ((mask & (1 << ((priority + s->priority_add) & 7))) == 0)
+		priority++;
+	return priority;
+}
+
+/*
+ * return the pic wanted interrupt. return -1 if none
+ */
+static int pic_get_irq(struct kvm_kpic_state *s)
+{
+	int mask, cur_priority, priority;
+
+	mask = s->irr & ~s->imr;
+	priority = get_priority(s, mask);
+	if (priority == 8)
+		return -1;
+	/*
+	 * compute current priority. If special fully nested mode on the
+	 * master, the IRQ coming from the slave is not taken into account
+	 * for the priority computation.
+	 */
+	mask = s->isr;
+	if (s->special_fully_nested_mode && s == &s->pics_state->pics[0])
+		mask &= ~(1 << 2);
+	cur_priority = get_priority(s, mask);
+	if (priority < cur_priority)
+		/*
+		 * higher priority found: an irq should be generated
+		 */
+		return (priority + s->priority_add) & 7;
+	else
+		return -1;
+}
+
+/*
+ * raise irq to CPU if necessary. must be called every time the active
+ * irq may change
+ */
+static void pic_update_irq(struct kvm_pic *s)
+{
+	int irq2, irq;
+
+	irq2 = pic_get_irq(&s->pics[1]);
+	if (irq2 >= 0) {
+		/*
+		 * if irq request by slave pic, signal master PIC
+		 */
+		pic_set_irq1(&s->pics[0], 2, 1);
+		pic_set_irq1(&s->pics[0], 2, 0);
+	}
+	irq = pic_get_irq(&s->pics[0]);
+	if (irq >= 0)
+		s->irq_request(s->irq_request_opaque, 1);
+	else
+		s->irq_request(s->irq_request_opaque, 0);
+}
+
+void kvm_pic_set_irq(void *opaque, int irq, int level)
+{
+	struct kvm_pic *s = opaque;
+
+	pic_set_irq1(&s->pics[irq >> 3], irq & 7, level);
+	pic_update_irq(s);
+}
+
+/*
+ * acknowledge interrupt 'irq'
+ */
+static inline void pic_intack(struct kvm_kpic_state *s, int irq)
+{
+	if (s->auto_eoi) {
+		if (s->rotate_on_auto_eoi)
+			s->priority_add = (irq + 1) & 7;
+	} else
+		s->isr |= (1 << irq);
+	/*
+	 * We don't clear a level sensitive interrupt here
+	 */
+	if (!(s->elcr & (1 << irq)))
+		s->irr &= ~(1 << irq);
+}
+
+int kvm_pic_read_irq(struct kvm_pic *s)
+{
+	int irq, irq2, intno;
+
+	irq = pic_get_irq(&s->pics[0]);
+	if (irq >= 0) {
+		pic_intack(&s->pics[0], irq);
+		if (irq == 2) {
+			irq2 = pic_get_irq(&s->pics[1]);
+			if (irq2 >= 0)
+				pic_intack(&s->pics[1], irq2);
+			else
+				/*
+				 * spurious IRQ on slave controller
+				 */
+				irq2 = 7;
+			intno = s->pics[1].irq_base + irq2;
+			irq = irq2 + 8;
+		} else
+			intno = s->pics[0].irq_base + irq;
+	} else {
+		/*
+		 * spurious IRQ on host controller
+		 */
+		irq = 7;
+		intno = s->pics[0].irq_base + irq;
+	}
+	pic_update_irq(s);
+
+	return intno;
+}
+
+static void pic_reset(void *opaque)
+{
+	struct kvm_kpic_state *s = opaque;
+
+	s->last_irr = 0;
+	s->irr = 0;
+	s->imr = 0;
+	s->isr = 0;
+	s->priority_add = 0;
+	s->irq_base = 0;
+	s->read_reg_select = 0;
+	s->poll = 0;
+	s->special_mask = 0;
+	s->init_state = 0;
+	s->auto_eoi = 0;
+	s->rotate_on_auto_eoi = 0;
+	s->special_fully_nested_mode = 0;
+	s->init4 = 0;
+}
+
+static void pic_ioport_write(void *opaque, u32 addr, u32 val)
+{
+	struct kvm_kpic_state *s = opaque;
+	int priority, cmd, irq;
+
+	addr &= 1;
+	if (addr == 0) {
+		if (val & 0x10) {
+			pic_reset(s);	/* init */
+			/*
+			 * deassert a pending interrupt
+			 */
+			s->pics_state->irq_request(s->pics_state->
+						   irq_request_opaque, 0);
+			s->init_state = 1;
+			s->init4 = val & 1;
+			if (val & 0x02)
+				printk(KERN_ERR "single mode not supported");
+			if (val & 0x08)
+				printk(KERN_ERR
+				       "level sensitive irq not supported");
+		} else if (val & 0x08) {
+			if (val & 0x04)
+				s->poll = 1;
+			if (val & 0x02)
+				s->read_reg_select = val & 1;
+			if (val & 0x40)
+				s->special_mask = (val >> 5) & 1;
+		} else {
+			cmd = val >> 5;
+			switch (cmd) {
+			case 0:
+			case 4:
+				s->rotate_on_auto_eoi = cmd >> 2;
+				break;
+			case 1:	/* end of interrupt */
+			case 5:
+				priority = get_priority(s, s->isr);
+				if (priority != 8) {
+					irq = (priority + s->priority_add) & 7;
+					s->isr &= ~(1 << irq);
+					if (cmd == 5)
+						s->priority_add = (irq + 1) & 7;
+					pic_update_irq(s->pics_state);
+				}
+				break;
+			case 3:
+				irq = val & 7;
+				s->isr &= ~(1 << irq);
+				pic_update_irq(s->pics_state);
+				break;
+			case 6:
+				s->priority_add = (val + 1) & 7;
+				pic_update_irq(s->pics_state);
+				break;
+			case 7:
+				irq = val & 7;
+				s->isr &= ~(1 << irq);
+				s->priority_add = (irq + 1) & 7;
+				pic_update_irq(s->pics_state);
+				break;
+			default:
+				break;	/* no operation */
+			}
+		}
+	} else
+		switch (s->init_state) {
+		case 0:		/* normal mode */
+			s->imr = val;
+			pic_update_irq(s->pics_state);
+			break;
+		case 1:
+			s->irq_base = val & 0xf8;
+			s->init_state = 2;
+			break;
+		case 2:
+			if (s->init4)
+				s->init_state = 3;
+			else
+				s->init_state = 0;
+			break;
+		case 3:
+			s->special_fully_nested_mode = (val >> 4) & 1;
+			s->auto_eoi = (val >> 1) & 1;
+			s->init_state = 0;
+			break;
+		}
+}
+
+static u32 pic_poll_read(struct kvm_kpic_state *s, u32 addr1)
+{
+	int ret;
+
+	ret = pic_get_irq(s);
+	if (ret >= 0) {
+		if (addr1 >> 7) {
+			s->pics_state->pics[0].isr &= ~(1 << 2);
+			s->pics_state->pics[0].irr &= ~(1 << 2);
+		}
+		s->irr &= ~(1 << ret);
+		s->isr &= ~(1 << ret);
+		if (addr1 >> 7 || ret != 2)
+			pic_update_irq(s->pics_state);
+	} else {
+		ret = 0x07;
+		pic_update_irq(s->pics_state);
+	}
+
+	return ret;
+}
+
+static u32 pic_ioport_read(void *opaque, u32 addr1)
+{
+	struct kvm_kpic_state *s = opaque;
+	unsigned int addr;
+	int ret;
+
+	addr = addr1;
+	addr &= 1;
+	if (s->poll) {
+		ret = pic_poll_read(s, addr1);
+		s->poll = 0;
+	} else
+		if (addr == 0)
+			if (s->read_reg_select)
+				ret = s->isr;
+			else
+				ret = s->irr;
+		else
+			ret = s->imr;
+	return ret;
+}
+
+static void elcr_ioport_write(void *opaque, u32 addr, u32 val)
+{
+	struct kvm_kpic_state *s = opaque;
+	s->elcr = val & s->elcr_mask;
+}
+
+static u32 elcr_ioport_read(void *opaque, u32 addr1)
+{
+	struct kvm_kpic_state *s = opaque;
+	return s->elcr;
+}
+
+static int picdev_in_range(struct kvm_io_device *this, gpa_t addr)
+{
+	switch (addr) {
+	case 0x20:
+	case 0x21:
+	case 0xa0:
+	case 0xa1:
+	case 0x4d0:
+	case 0x4d1:
+		return 1;
+	default:
+		return 0;
+	}
+}
+
+static void picdev_write(struct kvm_io_device *this,
+			 gpa_t addr, int len, const void *val)
+{
+	struct kvm_pic *s = this->private;
+	unsigned char data = *(unsigned char *)val;
+
+	if (len != 1) {
+		if (printk_ratelimit())
+			printk(KERN_ERR "PIC: non byte write\n");
+		return;
+	}
+	switch (addr) {
+	case 0x20:
+	case 0x21:
+	case 0xa0:
+	case 0xa1:
+		pic_ioport_write(&s->pics[addr >> 7], addr, data);
+		break;
+	case 0x4d0:
+	case 0x4d1:
+		elcr_ioport_write(&s->pics[addr & 1], addr, data);
+		break;
+	}
+}
+
+static void picdev_read(struct kvm_io_device *this,
+			gpa_t addr, int len, void *val)
+{
+	struct kvm_pic *s = this->private;
+	unsigned char data = 0;
+
+	if (len != 1) {
+		if (printk_ratelimit())
+			printk(KERN_ERR "PIC: non byte read\n");
+		return;
+	}
+	switch (addr) {
+	case 0x20:
+	case 0x21:
+	case 0xa0:
+	case 0xa1:
+		data = pic_ioport_read(&s->pics[addr >> 7], addr);
+		break;
+	case 0x4d0:
+	case 0x4d1:
+		data = elcr_ioport_read(&s->pics[addr & 1], addr);
+		break;
+	}
+	*(unsigned char *)val = data;
+}
+
+/*
+ * callback when PIC0 irq status changed
+ */
+static void pic_irq_request(void *opaque, int level)
+{
+	struct kvm *kvm = opaque;
+
+	pic_irqchip(kvm)->output = level;
+}
+
+struct kvm_pic *kvm_create_pic(struct kvm *kvm)
+{
+	struct kvm_pic *s;
+	s = kzalloc(sizeof(struct kvm_pic), GFP_KERNEL);
+	if (!s)
+		return NULL;
+	s->pics[0].elcr_mask = 0xf8;
+	s->pics[1].elcr_mask = 0xde;
+	s->irq_request = pic_irq_request;
+	s->irq_request_opaque = kvm;
+	s->pics[0].pics_state = s;
+	s->pics[1].pics_state = s;
+
+	/*
+	 * Initialize PIO device
+	 */
+	s->dev.read = picdev_read;
+	s->dev.write = picdev_write;
+	s->dev.in_range = picdev_in_range;
+	s->dev.private = s;
+	kvm_io_bus_register_dev(&kvm->pio_bus, &s->dev);
+	return s;
+}
diff --git a/drivers/kvm/irq.c b/drivers/kvm/irq.c
new file mode 100644
index 0000000..b08005c
--- /dev/null
+++ b/drivers/kvm/irq.c
@@ -0,0 +1,61 @@
+/*
+ * irq.c: API for in kernel interrupt controller
+ * Copyright (c) 2007, Intel Corporation.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms and conditions of the GNU General Public License,
+ * version 2, as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope it will be useful, but WITHOUT
+ * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
+ * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
+ * more details.
+ *
+ * You should have received a copy of the GNU General Public License along with
+ * this program; if not, write to the Free Software Foundation, Inc., 59 Temple
+ * Place - Suite 330, Boston, MA 02111-1307 USA.
+ * Authors:
+ *   Yaozu (Eddie) Dong <Eddie.dong@intel.com>
+ *
+ */
+
+#include <linux/module.h>
+
+#include "kvm.h"
+#include "irq.h"
+
+/*
+ * check if there is pending interrupt without
+ * intack.
+ */
+int kvm_cpu_has_interrupt(struct kvm_vcpu *v)
+{
+	struct kvm_pic *s = pic_irqchip(v->kvm);
+
+	if (s->output)	/* PIC */
+		return 1;
+	/*
+	 * TODO: APIC
+	 */
+	return 0;
+}
+EXPORT_SYMBOL_GPL(kvm_cpu_has_interrupt);
+
+/*
+ * Read pending interrupt vector and intack.
+ */
+int kvm_cpu_get_interrupt(struct kvm_vcpu *v)
+{
+	struct kvm_pic *s = pic_irqchip(v->kvm);
+	int vector;
+
+	s->output = 0;
+	vector = kvm_pic_read_irq(s);
+	if (vector != -1)
+		return vector;
+	/*
+	 * TODO: APIC
+	 */
+	return -1;
+}
+EXPORT_SYMBOL_GPL(kvm_cpu_get_interrupt);
diff --git a/drivers/kvm/irq.h b/drivers/kvm/irq.h
new file mode 100644
index 0000000..bdb2fc3
--- /dev/null
+++ b/drivers/kvm/irq.h
@@ -0,0 +1,64 @@
+/*
+ * irq.h: in kernel interrupt controller related definitions
+ * Copyright (c) 2007, Intel Corporation.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms and conditions of the GNU General Public License,
+ * version 2, as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope it will be useful, but WITHOUT
+ * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
+ * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
+ * more details.
+ *
+ * You should have received a copy of the GNU General Public License along with
+ * this program; if not, write to the Free Software Foundation, Inc., 59 Temple
+ * Place - Suite 330, Boston, MA 02111-1307 USA.
+ * Authors:
+ *   Yaozu (Eddie) Dong <Eddie.dong@intel.com>
+ *
+ */
+
+#ifndef __IRQ_H
+#define __IRQ_H
+
+#include "kvm.h"
+
+typedef void irq_request_func(void *opaque, int level);
+
+struct kvm_pic;
+struct kvm_kpic_state {
+	u8 last_irr;	/* edge detection */
+	u8 irr;		/* interrupt request register */
+	u8 imr;		/* interrupt mask register */
+	u8 isr;		/* interrupt service register */
+	u8 priority_add;	/* highest irq priority */
+	u8 irq_base;
+	u8 read_reg_select;
+	u8 poll;
+	u8 special_mask;
+	u8 init_state;
+	u8 auto_eoi;
+	u8 rotate_on_auto_eoi;
+	u8 special_fully_nested_mode;
+	u8 init4;		/* true if 4 byte init */
+	u8 elcr;		/* PIIX edge/trigger selection */
+	u8 elcr_mask;
+	struct kvm_pic *pics_state;
+};
+
+struct kvm_pic {
+	struct kvm_kpic_state pics[2]; /* 0 is master pic, 1 is slave pic */
+	irq_request_func *irq_request;
+	void *irq_request_opaque;
+	int output;		/* intr from master PIC */
+	struct kvm_io_device dev;
+};
+
+struct kvm_pic *kvm_create_pic(struct kvm *kvm);
+void kvm_pic_set_irq(void *opaque, int irq, int level);
+int kvm_pic_read_irq(struct kvm_pic *s);
+int kvm_cpu_get_interrupt(struct kvm_vcpu *v);
+int kvm_cpu_has_interrupt(struct kvm_vcpu *v);
+
+#endif
diff --git a/drivers/kvm/kvm.h b/drivers/kvm/kvm.h
index a42a6f3..d71712d 100644
--- a/drivers/kvm/kvm.h
+++ b/drivers/kvm/kvm.h
@@ -408,8 +408,19 @@ struct kvm {
 	struct file *filp;
 	struct kvm_io_bus mmio_bus;
 	struct kvm_io_bus pio_bus;
+	struct kvm_pic *vpic;
 };
 
+static inline struct kvm_pic *pic_irqchip(struct kvm *kvm)
+{
+	return kvm->vpic;
+}
+
+static inline int irqchip_in_kernel(struct kvm *kvm)
+{
+	return pic_irqchip(kvm) != 0;
+}
+
 struct descriptor_table {
 	u16 limit;
 	unsigned long base;
diff --git a/drivers/kvm/kvm_main.c b/drivers/kvm/kvm_main.c
index d154487..09a04bc 100644
--- a/drivers/kvm/kvm_main.c
+++ b/drivers/kvm/kvm_main.c
@@ -18,6 +18,7 @@
 #include "kvm.h"
 #include "x86_emulate.h"
 #include "segment_descriptor.h"
+#include "irq.h"
 
 #include <linux/kvm.h>
 #include <linux/module.h>
@@ -378,6 +379,7 @@ static void kvm_destroy_vm(struct kvm *kvm)
 	spin_unlock(&kvm_lock);
 	kvm_io_bus_destroy(&kvm->pio_bus);
 	kvm_io_bus_destroy(&kvm->mmio_bus);
+	kfree(kvm->vpic);
 	kvm_free_vcpus(kvm);
 	kvm_free_physmem(kvm);
 	kfree(kvm);
@@ -1258,7 +1260,8 @@ EXPORT_SYMBOL_GPL(emulate_instruction);
 
 int kvm_emulate_halt(struct kvm_vcpu *vcpu)
 {
-	if (vcpu->irq_summary)
+	if (vcpu->irq_summary ||
+		(irqchip_in_kernel(vcpu->kvm) && kvm_cpu_has_interrupt(vcpu)))
 		return 1;
 
 	vcpu->run->exit_reason = KVM_EXIT_HLT;
@@ -2715,6 +2718,30 @@ static long kvm_vm_ioctl(struct file *filp,
 			goto out;
 		break;
 	}
+	case KVM_CREATE_IRQCHIP:
+		r = -ENOMEM;
+		kvm->vpic = kvm_create_pic(kvm);
+		if (kvm->vpic)
+			r = 0;
+		else
+			goto out;
+		break;
+	case KVM_IRQ_LINE: {
+		struct kvm_irq_level irq_event;
+
+		r = -EFAULT;
+		if (copy_from_user(&irq_event, argp, sizeof irq_event))
+			goto out;
+		if (irqchip_in_kernel(kvm)) {
+			if (irq_event.irq < 16)
+				kvm_pic_set_irq(pic_irqchip(kvm),
+					irq_event.irq,
+					irq_event.level);
+			/* TODO: IOAPIC */
+			r = 0;
+		}
+		break;
+	}
 	default:
 		;
 	}
@@ -2825,12 +2852,19 @@ static long kvm_dev_ioctl(struct file *filp,
 		r = 0;
 		break;
 	}
-	case KVM_CHECK_EXTENSION:
-		/*
-		 * No extensions defined at present.
-		 */
-		r = 0;
+	case KVM_CHECK_EXTENSION: {
+		int ext = (long)argp;
+
+		switch (ext) {
+		case KVM_CAP_IRQCHIP:
+			r = 1;
+			break;
+		default:
+			r = 0;
+			break;
+		}
 		break;
+	}
 	case KVM_GET_VCPU_MMAP_SIZE:
 		r = -EINVAL;
 		if (arg)
diff --git a/drivers/kvm/svm.c b/drivers/kvm/svm.c
index cc674bf..2237a59 100644
--- a/drivers/kvm/svm.c
+++ b/drivers/kvm/svm.c
@@ -16,6 +16,7 @@
 
 #include "kvm_svm.h"
 #include "x86_emulate.h"
+#include "irq.h"
 
 #include <linux/module.h>
 #include <linux/kernel.h>
@@ -921,7 +922,8 @@ static int pf_interception(struct vcpu_svm *svm, struct kvm_run *kvm_run)
 	enum emulation_result er;
 	int r;
 
-	if (is_external_interrupt(exit_int_info))
+	if (!irqchip_in_kernel(kvm) &&
+		is_external_interrupt(exit_int_info))
 		push_irq(&svm->vcpu, exit_int_info & SVM_EVTINJ_VEC_MASK);
 
 	mutex_lock(&kvm->lock);
@@ -1185,6 +1187,8 @@ static int msr_interception(struct vcpu_svm *svm, struct kvm_run *kvm_run)
 static int interrupt_window_interception(struct vcpu_svm *svm,
 				   struct kvm_run *kvm_run)
 {
+	svm->vmcb->control.intercept &= ~(1ULL << INTERCEPT_VINTR);
+	svm->vmcb->control.int_ctl &= ~V_IRQ_MASK;
 	/*
 	 * If the user space waits to inject interrupts, exit as soon as
 	 * possible
@@ -1289,22 +1293,56 @@ static void pre_svm_run(struct vcpu_svm *svm)
 }
 
 
-static inline void inject_irq(struct vcpu_svm *svm)
+static inline void svm_inject_irq(struct vcpu_svm *svm, int irq)
 {
 	struct vmcb_control_area *control;
 
 	control = &svm->vmcb->control;
-	control->int_vector = pop_irq(&svm->vcpu);
+	control->int_vector = irq;
 	control->int_ctl &= ~V_INTR_PRIO_MASK;
 	control->int_ctl |= V_IRQ_MASK |
 		((/*control->int_vector >> 4*/ 0xf) << V_INTR_PRIO_SHIFT);
 }
 
-static void reput_irq(struct vcpu_svm *svm)
+static void svm_intr_assist(struct vcpu_svm *svm)
 {
+	struct vmcb *vmcb = svm->vmcb;
+	int intr_vector = -1;
+
+	if ((vmcb->control.exit_int_info & SVM_EVTINJ_VALID) &&
+	    ((vmcb->control.exit_int_info & SVM_EVTINJ_TYPE_MASK) == 0)) {
+		intr_vector = vmcb->control.exit_int_info &
+			      SVM_EVTINJ_VEC_MASK;
+		vmcb->control.exit_int_info = 0;
+		svm_inject_irq(svm, intr_vector);
+		return;
+	}
+
+	if (vmcb->control.int_ctl & V_IRQ_MASK)
+		return;
+
+	if (!kvm_cpu_has_interrupt(&svm->vcpu))
+		return;
+
+	if (!(vmcb->save.rflags & X86_EFLAGS_IF) ||
+	    (vmcb->control.int_state & SVM_INTERRUPT_SHADOW_MASK) ||
+	    (vmcb->control.event_inj & SVM_EVTINJ_VALID)) {
+		/* unable to deliver irq, set pending irq */
+		vmcb->control.intercept |= (1ULL << INTERCEPT_VINTR);
+		svm_inject_irq(svm, 0x0);
+		return;
+	}
+	/* Okay, we can deliver the interrupt: grab it and update PIC state. */
+	intr_vector = kvm_cpu_get_interrupt(&svm->vcpu);
+	svm_inject_irq(svm, intr_vector);
+}
+
+static void kvm_reput_irq(struct vcpu_svm *svm)
+{
+	struct kvm_vcpu *vcpu = &svm->vcpu;
 	struct vmcb_control_area *control = &svm->vmcb->control;
 
-	if (control->int_ctl & V_IRQ_MASK) {
+	if ((control->int_ctl & V_IRQ_MASK) && !irqchip_in_kernel(vcpu->kvm)) {
 		control->int_ctl &= ~V_IRQ_MASK;
 		push_irq(&svm->vcpu, control->int_vector);
 	}
@@ -1313,6 +1351,19 @@ static void reput_irq(struct vcpu_svm *svm)
 		!(control->int_state & SVM_INTERRUPT_SHADOW_MASK);
 }
 
+static void svm_do_inject_vector(struct vcpu_svm *svm)
+{
+	struct kvm_vcpu *vcpu = &svm->vcpu;
+	int word_index = __ffs(vcpu->irq_summary);
+	int bit_index = __ffs(vcpu->irq_pending[word_index]);
+	int irq = word_index * BITS_PER_LONG + bit_index;
+
+	clear_bit(bit_index, &vcpu->irq_pending[word_index]);
+	if (!vcpu->irq_pending[word_index])
+		clear_bit(word_index, &vcpu->irq_summary);
+	svm_inject_irq(svm, irq);
+}
+
 static void do_interrupt_requests(struct vcpu_svm *svm,
 				       struct kvm_run *kvm_run)
 {
@@ -1326,7 +1377,7 @@ static void do_interrupt_requests(struct vcpu_svm *svm,
 		/*
 		 * If interrupts enabled, and not blocked by sti or mov ss. Good.
 		 */
-		inject_irq(svm);
+		svm_do_inject_vector(svm);
 
 	/*
 	 * Interrupts blocked.  Wait for unblock.
@@ -1408,7 +1459,9 @@ again:
 		return -EINTR;
 	}
 
-	if (!vcpu->mmio_read_completed)
+	if (irqchip_in_kernel(vcpu->kvm))
+		svm_intr_assist(svm);
+	else if (!vcpu->mmio_read_completed)
 		do_interrupt_requests(svm, kvm_run);
 
 	vcpu->guest_mode = 1;
@@ -1576,7 +1629,7 @@ again:
 
 	stgi();
 
-	reput_irq(svm);
+	kvm_reput_irq(svm);
 
 	svm->next_rip = 0;
 
diff --git a/drivers/kvm/vmx.c b/drivers/kvm/vmx.c
index d63e82e..f1e80a9 100644
--- a/drivers/kvm/vmx.c
+++ b/drivers/kvm/vmx.c
@@ -17,6 +17,7 @@
 
 #include "kvm.h"
 #include "x86_emulate.h"
+#include "irq.h"
 #include "vmx.h"
 #include "segment_descriptor.h"
 
@@ -1582,6 +1583,16 @@ static void inject_rmode_irq(struct kvm_vcpu *vcpu, int irq)
 	vmcs_writel(GUEST_RSP, (vmcs_readl(GUEST_RSP) & ~0xffff) | (sp - 6));
 }
 
+static void vmx_inject_irq(struct kvm_vcpu *vcpu, int irq)
+{
+	if (vcpu->rmode.active) {
+		inject_rmode_irq(vcpu, irq);
+		return;
+	}
+	vmcs_write32(VM_ENTRY_INTR_INFO_FIELD,
+			irq | INTR_TYPE_EXT_INTR | INTR_INFO_VALID_MASK);
+}
+
 static void kvm_do_inject_irq(struct kvm_vcpu *vcpu)
 {
 	int word_index = __ffs(vcpu->irq_summary);
@@ -1591,13 +1602,7 @@ static void kvm_do_inject_irq(struct kvm_vcpu *vcpu)
 	clear_bit(bit_index, &vcpu->irq_pending[word_index]);
 	if (!vcpu->irq_pending[word_index])
 		clear_bit(word_index, &vcpu->irq_summary);
-
-	if (vcpu->rmode.active) {
-		inject_rmode_irq(vcpu, irq);
-		return;
-	}
-	vmcs_write32(VM_ENTRY_INTR_INFO_FIELD,
-			irq | INTR_TYPE_EXT_INTR | INTR_INFO_VALID_MASK);
+	vmx_inject_irq(vcpu, irq);
 }
 
 
@@ -1681,7 +1686,7 @@ static int handle_exception(struct kvm_vcpu *vcpu, struct kvm_run *kvm_run)
 		       "intr info 0x%x\n", __FUNCTION__, vect_info, intr_info);
 	}
 
-	if (is_external_interrupt(vect_info)) {
+	if (!irqchip_in_kernel(vcpu->kvm) && is_external_interrupt(vect_info)) {
 		int irq = vect_info & VECTORING_INFO_VECTOR_MASK;
 		set_bit(irq, vcpu->irq_pending);
 		set_bit(irq / BITS_PER_LONG, &vcpu->irq_summary);
@@ -1961,6 +1966,12 @@ static void post_kvm_run_save(struct kvm_vcpu *vcpu,
 static int handle_interrupt_window(struct kvm_vcpu *vcpu,
 				   struct kvm_run *kvm_run)
 {
+	u32 cpu_based_vm_exec_control;
+
+	/* clear pending irq */
+	cpu_based_vm_exec_control = vmcs_read32(CPU_BASED_VM_EXEC_CONTROL);
+	cpu_based_vm_exec_control &= ~CPU_BASED_VIRTUAL_INTR_PENDING;
+	vmcs_write32(CPU_BASED_VM_EXEC_CONTROL, cpu_based_vm_exec_control);
 	/*
 	 * If the user space waits to inject interrupts, exit as soon as
 	 * possible
@@ -2052,6 +2063,55 @@ static void vmx_flush_tlb(struct kvm_vcpu *vcpu)
 {
 }
 
+static void enable_irq_window(struct kvm_vcpu *vcpu)
+{
+	u32 cpu_based_vm_exec_control;
+
+	cpu_based_vm_exec_control = vmcs_read32(CPU_BASED_VM_EXEC_CONTROL);
+	cpu_based_vm_exec_control |= CPU_BASED_VIRTUAL_INTR_PENDING;
+	vmcs_write32(CPU_BASED_VM_EXEC_CONTROL, cpu_based_vm_exec_control);
+}
+
+static void vmx_intr_assist(struct kvm_vcpu *vcpu)
+{
+	u32 idtv_info_field, intr_info_field;
+	int has_ext_irq, interrupt_window_open;
+
+	has_ext_irq = kvm_cpu_has_interrupt(vcpu);
+	intr_info_field = vmcs_read32(VM_ENTRY_INTR_INFO_FIELD);
+	idtv_info_field = vmcs_read32(IDT_VECTORING_INFO_FIELD);
+	if (intr_info_field & INTR_INFO_VALID_MASK) {
+		if (idtv_info_field & INTR_INFO_VALID_MASK) {
+			/* TODO: fault when IDT_Vectoring */
+			printk(KERN_ERR "Fault when IDT_Vectoring\n");
+		}
+		if (has_ext_irq)
+			enable_irq_window(vcpu);
+		return;
+	}
+	if (unlikely(idtv_info_field & INTR_INFO_VALID_MASK)) {
+		vmcs_write32(VM_ENTRY_INTR_INFO_FIELD, idtv_info_field);
+		vmcs_write32(VM_ENTRY_INSTRUCTION_LEN,
+				vmcs_read32(VM_EXIT_INSTRUCTION_LEN));
+
+		if (unlikely(idtv_info_field & INTR_INFO_DELIEVER_CODE_MASK))
+			vmcs_write32(VM_ENTRY_EXCEPTION_ERROR_CODE,
+				vmcs_read32(IDT_VECTORING_ERROR_CODE));
+		if (unlikely(has_ext_irq))
+			enable_irq_window(vcpu);
+		return;
+	}
+	if (!has_ext_irq)
+		return;
+	interrupt_window_open =
+		((vmcs_readl(GUEST_RFLAGS) & X86_EFLAGS_IF) &&
+		 (vmcs_read32(GUEST_INTERRUPTIBILITY_INFO) & 3) == 0);
+	if (interrupt_window_open)
+		vmx_inject_irq(vcpu, kvm_cpu_get_interrupt(vcpu));
+	else
+		enable_irq_window(vcpu);
+}
+
 static int vmx_vcpu_run(struct kvm_vcpu *vcpu, struct kvm_run *kvm_run)
 {
 	struct vcpu_vmx *vmx = to_vmx(vcpu);
@@ -2088,7 +2148,9 @@ again:
 		goto out;
 	}
 
-	if (!vcpu->mmio_read_completed)
+	if (irqchip_in_kernel(vcpu->kvm))
+		vmx_intr_assist(vcpu);
+	else if (!vcpu->mmio_read_completed)
 		do_interrupt_requests(vcpu, kvm_run);
 
 	vcpu->guest_mode = 1;
diff --git a/include/linux/kvm.h b/include/linux/kvm.h
index 1d5a49c..bfe742b 100644
--- a/include/linux/kvm.h
+++ b/include/linux/kvm.h
@@ -34,6 +34,17 @@ struct kvm_memory_alias {
 	__u64 target_phys_addr;
 };
 
+/* for KVM_SET_IRQ_LEVEL */
+struct kvm_irq_level {
+	/*
+	 * ACPI gsi notion of irq.
+	 * For IA-64 (APIC model) IOAPIC0: irq 0-23; IOAPIC1: irq 24-47..
+	 * For X86 (standard AT mode) PIC0/1: irq 0-15. IOAPIC0: 0-23..
+	 */
+	__u32 irq;
+	__u32 level;
+};
+
 enum kvm_exit_reason {
 	KVM_EXIT_UNKNOWN          = 0,
 	KVM_EXIT_EXCEPTION        = 1,
@@ -269,6 +280,11 @@ struct kvm_signal_mask {
 #define KVM_GET_VCPU_MMAP_SIZE    _IO(KVMIO,   0x04) /* in bytes */
 
 /*
+ * Extension capability list.
+ */
+#define KVM_CAP_IRQCHIP	  0
+
+/*
  * ioctls for VM fds
  */
 #define KVM_SET_MEMORY_REGION     _IOW(KVMIO, 0x40, struct kvm_memory_region)
@@ -279,6 +295,9 @@ struct kvm_signal_mask {
 #define KVM_CREATE_VCPU           _IO(KVMIO,  0x41)
 #define KVM_GET_DIRTY_LOG         _IOW(KVMIO, 0x42, struct kvm_dirty_log)
 #define KVM_SET_MEMORY_ALIAS      _IOW(KVMIO, 0x43, struct kvm_memory_alias)
+/* Device model IOC */
+#define KVM_CREATE_IRQCHIP	  _IO(KVMIO,  0x60)
+#define KVM_IRQ_LINE		  _IO(KVMIO,  0x61)
 
 /*
  * ioctls for vcpu fds
-- 
1.5.3

