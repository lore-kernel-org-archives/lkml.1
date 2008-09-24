Return-Path: <linux-kernel-owner+w=401wt.eu-S1754439AbYIXT4s@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754439AbYIXT4s (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2008 15:56:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752000AbYIXT4k
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Sep 2008 15:56:40 -0400
Received: from mail-gx0-f16.google.com ([209.85.217.16]:55688 "EHLO
	mail-gx0-f16.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751888AbYIXT4j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2008 15:56:39 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:subject:to:date:message-id:user-agent:mime-version
         :content-type:content-transfer-encoding;
        b=fzHnqsQ/xiUeecHK8aRpwQSzfxC/9OzEyio5P/KSXXNMbzHXB+nMp/OYaxzHyTrIj/
         7wZDndHYrNO9gNAfJozmh9oWqiWRrlyGD/WHxxNT3y+pwICha2M4VfD403WXZjKeRp7f
         C9fSKjoSWOjRdjKMr47nX3XqLameTk+QyFhvU=
From: Jon Smirl <jonsmirl@gmail.com>
Subject: [PATCH] First pass at integrating LIRC into the input subsystem
To: lirc-list@lists.sourceforge.net, linux-kernel@vger.kernel.org
Date: Wed, 24 Sep 2008 15:56:35 -0400
Message-ID: <20080924195634.7220.34917.stgit@terra>
User-Agent: StGIT/0.14.3.224.g199b
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

My hardware consists of a GPIO input pin with a timer attached. The pin is set to generate an interrupt each time the input signal changes state.  I take the timing data from each pulse and pass it into the core IR decode function. The decode function is running a state machine in parallel for each IR protocol. When a state machine detects a valid set of pulses it sends out three input messages as part of a transaction. The first is the detected protocol, second the address, third the command.

User space IR drivers can use the existing input event submission mechanism to get events into the input queue.

To transmit three input IOCTLs need to be implemented. Set frequency, enable transmitters, send data. Send data can take three parameters equivalent to the three from the event messages. A small library can be used to turn these three parameters into timing data for the specific protocols. I don't have transmit hardware in my system.

I've tested the driver and it works. The state machines will need some tuning. They don't handle repeats correctly and they may not be splitting address and command properly.

Jon Smirl
<jonsmirl@gmail.com>
---
 drivers/input/Kconfig     |    2 
 drivers/input/Makefile    |    3 
 drivers/input/input.c     |    4 +
 drivers/input/ir-core.c   |  294 +++++++++++++++++++++++++++++++++++++++++++++
 drivers/input/ir/Kconfig  |   20 +++
 drivers/input/ir/Makefile |    6 +
 drivers/input/ir/ir-gpt.c |  214 +++++++++++++++++++++++++++++++++
 7 files changed, 542 insertions(+), 1 deletions(-)
 create mode 100644 drivers/input/ir-core.c
 create mode 100644 drivers/input/ir/Kconfig
 create mode 100644 drivers/input/ir/Makefile
 create mode 100644 drivers/input/ir/ir-gpt.c

diff --git a/arch/powerpc/boot/dts/dspeak01.dts b/arch/powerpc/boot/dts/dspeak01.dts
index 1d10f0a..cbb22a1 100644
--- a/arch/powerpc/boot/dts/dspeak01.dts
+++ b/arch/powerpc/boot/dts/dspeak01.dts
@@ -131,16 +131,6 @@
 			#gpio-cells = <2>;
 		};
 
-		gpt7: timer@670 { /* General Purpose Timer in GPIO mode */
-			compatible = "fsl,mpc5200b-gpt-gpio","fsl,mpc5200-gpt-gpio";
-			cell-index = <7>;
-			reg = <0x670 0x10>;
-			interrupts = <0x1 0x10 0x0>;
-			interrupt-parent = <&mpc5200_pic>;
-			gpio-controller;
-			#gpio-cells = <2>;
-		};
-
 		rtc@800 {	// Real time clock
 			compatible = "fsl,mpc5200b-rtc","fsl,mpc5200-rtc";
 			device_type = "rtc";
@@ -328,6 +318,14 @@
 			reg = <0x8000 0x4000>;
 		};
 
+		ir0: timer@670 { /* General Purpose Timer 6 in Input mode */
+			compatible = "gpt-ir";
+			cell-index = <7>;
+			reg = <0x670 0x10>;
+			interrupts = <0x1 0x10 0x0>;
+			interrupt-parent = <&mpc5200_pic>;
+		};
+
 		/* This is only an example device to show the usage of gpios. It maps all available
 		 * gpios to the "gpio-provider" device.
 		 */
@@ -345,7 +343,6 @@
 				 &gpt4		0 0 /* timer4		61c		x2-16	   */
 				 &gpt5		0 0 /* timer5		44c		x7-11	   */
 				 &gpt6		0 0 /* timer6		60c		x8-15	   */
-				 &gpt7		0 0 /* timer7		36a		x17-9	   */
 				 >;
 		};
 	};
diff --git a/drivers/input/Kconfig b/drivers/input/Kconfig
index 747633c..780d321 100644
--- a/drivers/input/Kconfig
+++ b/drivers/input/Kconfig
@@ -172,6 +172,8 @@ source "drivers/input/touchscreen/Kconfig"
 
 source "drivers/input/misc/Kconfig"
 
+source "drivers/input/ir/Kconfig"
+
 endif
 
 menu "Hardware I/O ports"
diff --git a/drivers/input/Makefile b/drivers/input/Makefile
index 6a1049b..da47340 100644
--- a/drivers/input/Makefile
+++ b/drivers/input/Makefile
@@ -5,7 +5,7 @@
 # Each configuration option enables a list of files.
 
 obj-$(CONFIG_INPUT)		+= input-core.o
-input-core-objs := input.o ff-core.o
+input-core-objs := input.o ff-core.o ir-core.o
 
 obj-$(CONFIG_INPUT_FF_MEMLESS)	+= ff-memless.o
 obj-$(CONFIG_INPUT_POLLDEV)	+= input-polldev.o
@@ -21,6 +21,7 @@ obj-$(CONFIG_INPUT_JOYSTICK)	+= joystick/
 obj-$(CONFIG_INPUT_TABLET)	+= tablet/
 obj-$(CONFIG_INPUT_TOUCHSCREEN)	+= touchscreen/
 obj-$(CONFIG_INPUT_MISC)	+= misc/
+obj-$(CONFIG_INPUT_IR)		+= ir/
 
 obj-$(CONFIG_INPUT_APMPOWER)	+= apm-power.o
 
diff --git a/drivers/input/input.c b/drivers/input/input.c
index c13ced3..2159be8 100644
--- a/drivers/input/input.c
+++ b/drivers/input/input.c
@@ -240,6 +240,10 @@ static void input_handle_event(struct input_dev *dev,
 	case EV_PWR:
 		disposition = INPUT_PASS_TO_ALL;
 		break;
+
+	case EV_IR:
+		disposition = INPUT_PASS_TO_ALL;
+		break;
 	}
 
 	if (disposition != INPUT_IGNORE_EVENT && type != EV_SYN)
diff --git a/drivers/input/ir-core.c b/drivers/input/ir-core.c
new file mode 100644
index 0000000..ea63e53
--- /dev/null
+++ b/drivers/input/ir-core.c
@@ -0,0 +1,294 @@
+/*
+ * Core routines for IR support
+ *
+ * Copyright (C) 2008 Jon Smirl <jonsmirl@gmail.com>
+ */
+
+#include <linux/input.h>
+
+static int decode_sirc(struct input_dev *dev, struct ir_protocol *sirc, unsigned int d, unsigned int bit)
+{
+	/* Sony SIRC IR code */
+	/* http://www.sbprojects.com/knowledge/ir/sirc.htm */
+	/* based on a 600us cadence */
+	int ret = 0, delta = d;
+
+	delta = (delta + 300) / 600;
+	//printk("D %d %d %d\n", d, delta, bit);
+
+	if ((bit == 0) && (delta > 22)) {
+		//printk("SIRC state 1\n");
+		if ((sirc->state == 26) || (sirc->state == 32) || (sirc->state == 42)) {
+			if (sirc->good && (sirc->good == sirc->code)) {
+
+				input_report_ir(dev, IR_PROTOCOL, IR_PROTOCOL_SONY);
+
+				if (sirc->state == 26) {
+					input_report_ir(dev, IR_ADDRESS, sirc->code & 0x1F);
+					input_report_ir(dev, IR_COMMAND, sirc->code >> 5);
+				} else {
+					input_report_ir(dev, IR_ADDRESS, sirc->code & 0xFF);
+					input_report_ir(dev, IR_COMMAND, sirc->code >> 8);
+				}
+				input_sync(dev);
+
+				sirc->good = 0;
+				ret = 1;
+			} else {
+				//printk("SIRC - Saving %d bit %05x\n", (sirc->state - 2) / 2, sirc->code);
+				sirc->good = sirc->code;
+			}
+		}
+		sirc->state = 1;
+		sirc->code = 0;
+		return ret;
+	}
+	if ((sirc->state == 1) && (bit == 1) && (delta == 4)) {
+		sirc->state = 2;
+		//printk("SIRC state 2\n");
+		return 0;
+	}
+	if ((sirc->state == 2) && (bit == 0) && (delta == 1)) {
+		sirc->state = 3;
+		//printk("SIRC state 3\n");
+		return 0;
+	}
+	if ((sirc->state >= 3) && (sirc->state & 1) && (bit == 1) && ((delta == 1) || (delta == 2))) {
+		sirc->state++;
+		sirc->code |= ((delta - 1) << ((sirc->state - 4) / 2));
+		//printk("SIRC state %d bit %d\n", sirc->state, delta - 1);
+		return 0;
+	}
+	if ((sirc->state >= 3) && !(sirc->state & 1) && (bit == 0) && (delta == 1)) {
+		sirc->state++;
+		//printk("SIRC state %d\n", sirc-> state);
+		return 0;
+	}
+	sirc->state = 0;
+	return 0;
+}
+
+static int decode_jvc(struct input_dev *dev, struct ir_protocol *jvc, unsigned int d, unsigned int bit)
+{
+	/* JVC IR code */
+	/* http://www.sbprojects.com/knowledge/ir/jvc.htm */
+	/* based on a 525us cadence */
+	int ret = 0, delta = d;
+
+	delta = (delta + 263) / 525;
+	//printk("D %d %d %d\n", d, delta, bit);
+
+	if ((bit == 0) && (delta > 22)) {
+		//printk("JVC state 1\n");
+		jvc->state = 1;
+		jvc->code = 0;
+		return ret;
+	}
+	if ((jvc->state == 1) && (bit == 1) && (delta == 16)) {
+		jvc->state = 2;
+		//printk("JVC state 2\n");
+		return 0;
+	}
+	if ((jvc->state == 2) && (bit == 0) && (delta == 8)) {
+		jvc->state = 3;
+		//printk("JVC state 3\n");
+		return 0;
+	}
+	if ((jvc->state >= 3) && (jvc->state & 1) && (bit == 1) && (delta == 1)) {
+		jvc->state++;
+		//printk("JVC state %d\n", jvc-> state);
+		return 0;
+	}
+	if ((jvc->state >= 3) && !(jvc->state & 1) && (bit == 0) && ((delta == 1) || (delta == 3))) {
+		if (delta == 3)
+			jvc->code |= 1 << ((jvc->state - 4) / 2);
+		jvc->state++;
+		//printk("JVC state %d bit %d\n", jvc->state, delta - 1);
+		if (jvc->state == 34) {
+			jvc->state = 3;
+			if (jvc->good && (jvc->good == jvc->code)) {
+				input_report_ir(dev, IR_PROTOCOL, IR_PROTOCOL_JVC);
+				input_report_ir(dev, IR_ADDRESS, jvc->code >> 8);
+				input_report_ir(dev, IR_COMMAND, jvc->code & 0xFF);
+				input_sync(dev);
+				jvc->good = 0;
+				ret = 1;
+			} else {
+				//printk("JVC - Saving 16 bit %05x\n", jvc->code);
+				jvc->good = jvc->code;
+			}
+			jvc->code = 0;
+		}
+		return 0;
+	}
+	jvc->state = 0;
+	return 0;
+}
+
+static int decode_nec(struct input_dev *dev, struct ir_protocol *nec, unsigned int d, unsigned int bit)
+{
+	/* NEC IR code */
+	/* http://www.sbprojects.com/knowledge/ir/nec.htm */
+	/* based on a 560us cadence */
+	int delta = d;
+
+	delta = (delta + 280) / 560;
+	//printk("D %d %d %d\n", d, delta, bit);
+
+	if ((bit == 0) && (delta > 22)) {
+		//printk("nec state 1\n");
+		nec->state = 1;
+		nec->code = 0;
+		return 0;
+	}
+	if ((nec->state == 1) && (bit == 1) && (delta == 16)) {
+		nec->state = 2;
+		//printk("nec state 2\n");
+		return 0;
+	}
+	if ((nec->state == 2) && (bit == 0) && (delta == 8)) {
+		nec->state = 3;
+		//printk("nec state 3\n");
+		return 0;
+	}
+	if ((nec->state >= 3) && (nec->state & 1) && (bit == 1) && (delta == 1)) {
+		nec->state++;
+		//printk("nec state %d\n", nec-> state);
+		if (nec->state == 68) {
+			input_report_ir(dev, IR_PROTOCOL, IR_PROTOCOL_NEC);
+			input_report_ir(dev, IR_ADDRESS, nec->code >> 16);
+			input_report_ir(dev, IR_COMMAND, nec->code & 0xFFFF);
+			input_sync(dev);
+			return 1;
+		}
+		return 0;
+	}
+	if ((nec->state >= 3) && !(nec->state & 1) && (bit == 0) && ((delta == 1) || (delta == 3))) {
+		if (delta == 3)
+			nec->code |= 1 << ((nec->state - 4) / 2);
+		nec->state++;
+		//printk("nec state %d bit %d\n", nec->state, delta - 1);
+		return 0;
+	}
+	nec->state = 0;
+	nec->code = 0;
+	return 0;
+}
+
+static int decode_rc5(struct input_dev *dev, struct ir_protocol *rc5, unsigned int d, unsigned int bit)
+{
+	/* Philips RC-5 IR code */
+	/* http://www.sbprojects.com/knowledge/ir/rc5.htm */
+	/* based on a 889us cadence */
+	int delta = d;
+
+	delta = (delta + 444) / 889;
+	//printk("D %d %d %d\n", d, delta, bit);
+
+	return 0;
+}
+
+static void decode_rc6_bit(struct input_dev *dev, struct ir_protocol *rc6, unsigned int bit)
+{
+	/* bits come in one at a time */
+	/* when two are collected look for a symbol */
+	/* rc6->bits == 1 is a zero symbol */
+	/* rc6->bits == 2 is a one symbol */
+	rc6->count++;
+	rc6->bits <<= 1;
+	rc6->bits |= bit;
+	if (rc6->count == 2) {
+		if ((rc6->bits == 0) || (rc6->bits == 3)) {
+			rc6->mode = rc6->code;
+			rc6->code = 0;
+		} else {
+			rc6->code <<= 1;
+			if (rc6->bits == 2)
+				rc6->code |= 1;
+		}
+		rc6->count = 0;
+		if (rc6->state == 23) {
+			input_report_ir(dev, IR_PROTOCOL, IR_PROTOCOL_PHILIPS_RC6);
+			input_report_ir(dev, IR_ADDRESS, rc6->code >> 8);
+			input_report_ir(dev, IR_COMMAND, rc6->code & 0xFF);
+			input_sync(dev);
+			rc6->state = 0;
+		} else
+			rc6->state++;
+		//printk("rc6 state %d bit %d\n", rc6->state, rc6->bits == 2);
+		rc6->bits = 0;
+	}
+}
+
+static int decode_rc6(struct input_dev *dev, struct ir_protocol *rc6, unsigned int d, unsigned int bit)
+{
+	/* Philips RC-6 IR code */
+	/* http://www.sbprojects.com/knowledge/ir/rc6.htm */
+	/* based on a 444us cadence */
+
+	int delta = d;
+
+	delta = (delta + 222) / 444;
+	//printk("D %d %d %d\n", d, delta, bit);
+
+	if ((bit == 0) && (delta > 19)) {
+		rc6->count = 0;
+		rc6->bits = 0;
+		rc6->state = 1;
+		rc6->code = 0;
+		//printk("rc6 state 1\n");
+		return 0;
+	}
+	if ((rc6->state == 1) && (bit == 1) && (delta == 6)) {
+		rc6->state = 2;
+		//printk("rc6 state 2\n");
+		return 0;
+	}
+	if ((rc6->state == 2) && (bit == 0) && (delta == 2)) {
+		rc6->state = 3;
+		//printk("rc6 state 3\n");
+		return 0;
+	}
+	if (rc6->state >= 3) {
+		if ((delta >= 1) || (delta <= 3)) {
+			while (delta-- >= 1)
+				decode_rc6_bit(dev, rc6, bit);
+			return 0;
+		}
+	}
+	rc6->state = 0;
+	rc6->code = 0;
+	return 0;
+}
+
+void input_ir_decode(struct input_dev *dev, unsigned int delta, unsigned int bit)
+{
+	decode_sirc(dev, &dev->ir->sirc, delta, bit);
+	decode_jvc(dev, &dev->ir->jvc, delta, bit);
+	decode_nec(dev, &dev->ir->nec, delta, bit);
+	decode_rc5(dev, &dev->ir->rc5, delta, bit);
+	decode_rc6(dev, &dev->ir->rc6, delta, bit);
+}
+EXPORT_SYMBOL_GPL(input_ir_decode);
+
+
+int input_ir_create(struct input_dev *dev)
+{
+	dev->ir = kzalloc(sizeof(struct ir_device), GFP_KERNEL);
+	if (!dev->ir)
+		return -ENOMEM;
+	dev->evbit[0] = BIT_MASK(EV_IR);
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(input_ir_create);
+
+
+void input_ir_destroy(struct input_dev *dev)
+{
+	if (dev->ir) {
+		kfree(dev->ir);
+		dev->ir = NULL;
+	}
+}
+EXPORT_SYMBOL_GPL(input_ir_destroy);
diff --git a/drivers/input/ir/Kconfig b/drivers/input/ir/Kconfig
new file mode 100644
index 0000000..b80ab31
--- /dev/null
+++ b/drivers/input/ir/Kconfig
@@ -0,0 +1,20 @@
+#
+# LIRC driver(s) configuration
+#
+menuconfig INPUT_IR
+	bool "Infrared Remote (IR) receiver/transmitter drivers"
+	default n
+	help
+	  Say Y here, and all supported Infrared Remote Control IR
+	  receiver and transmitter drivers will be displayed. The receiver drivers
+	  allow control of your Linux system via remote control.
+
+if INPUT_IR
+
+config IR_GPT
+	tristate "GPT Based IR Receiver"
+	default m
+	help
+	  Driver for GPT-based IR receiver found on Digispeaker
+
+endif
diff --git a/drivers/input/ir/Makefile b/drivers/input/ir/Makefile
new file mode 100644
index 0000000..7082f1d
--- /dev/null
+++ b/drivers/input/ir/Makefile
@@ -0,0 +1,6 @@
+# Makefile for the ir drivers.
+#
+
+# Each configuration option enables a list of files.
+
+obj-$(CONFIG_IR_GPT)		+= ir-gpt.o
diff --git a/drivers/input/ir/ir-gpt.c b/drivers/input/ir/ir-gpt.c
new file mode 100644
index 0000000..a8263a1
--- /dev/null
+++ b/drivers/input/ir/ir-gpt.c
@@ -0,0 +1,214 @@
+/*
+ * GPT timer based IR device
+ *
+ * Copyright (C) 2008 Jon Smirl <jonsmirl@gmail.com>
+ */
+
+#define DEBUG
+
+#include <linux/init.h>
+#include <linux/module.h>
+#include <linux/interrupt.h>
+#include <linux/device.h>
+#include <linux/of_device.h>
+#include <linux/of_platform.h>
+#include <linux/input.h>
+#include <asm/io.h>
+#include <asm/mpc52xx.h>
+
+#define MAX_SAMPLES 200
+
+struct ir_gpt {
+	int irq;
+	struct mpc52xx_gpt __iomem *regs;
+	spinlock_t lock;
+	struct work_struct queue;
+	int head, tail, previous;
+	unsigned int samples[MAX_SAMPLES];
+	struct input_dev *input;
+};
+
+static void ir_event(struct work_struct *work)
+{
+	unsigned long flags;
+	int delta, count;
+	unsigned int sample, wrap, bit;
+	struct ir_gpt *ir_gpt = container_of(work, struct ir_gpt, queue);
+
+	while (1) {
+		spin_lock_irqsave(ir_gpt->lock, flags);
+		if (ir_gpt->tail == ir_gpt->head) {
+			spin_unlock_irqrestore(ir_gpt->lock, flags);
+			break;
+		}
+		sample = ir_gpt->samples[ir_gpt->tail];
+
+		ir_gpt->tail++;
+		if (ir_gpt->tail >= MAX_SAMPLES)
+			ir_gpt->tail = 0;
+
+		spin_unlock_irqrestore(ir_gpt->lock, flags);
+
+		count = sample >> 16;
+		wrap = (sample >> 12) & 7;
+		bit = (sample >> 8) & 1;
+
+		delta = count - ir_gpt->previous;
+		delta += wrap * 0x10000;
+
+		ir_gpt->previous = count;
+
+		input_ir_decode(ir_gpt->input, delta, bit);
+	}
+}
+
+/*
+ * Interrupt handlers
+ */
+static irqreturn_t dpeak_ir_irq(int irq, void *_ir)
+{
+	unsigned long flags;
+	unsigned int sample, next;
+	struct ir_gpt *ir_gpt = _ir;
+
+	sample = in_be32(&ir_gpt->regs->status);
+	out_be32(&ir_gpt->regs->status, 0xF);
+
+	spin_lock_irqsave(ir_gpt->lock, flags);
+	ir_gpt->samples[ir_gpt->head] = sample;
+	next = ir_gpt->head + 1;
+	ir_gpt->head = (next >= MAX_SAMPLES ? 0 : next);
+	spin_unlock_irqrestore(ir_gpt->lock, flags);
+
+	schedule_work(&ir_gpt->queue);
+
+	return IRQ_HANDLED;
+}
+
+
+/* ---------------------------------------------------------------------
+ * OF platform bus binding code:
+ * - Probe/remove operations
+ * - OF device match table
+ */
+static int __devinit ir_gpt_of_probe(struct of_device *op,
+				      const struct of_device_id *match)
+{
+	struct ir_gpt *ir_gpt;
+	struct resource res;
+	int ret, rc;
+
+	dev_dbg(&op->dev, "ir_gpt_of_probe\n");
+
+	/* Allocate and initialize the driver private data */
+	ir_gpt = kzalloc(sizeof *ir_gpt, GFP_KERNEL);
+	if (!ir_gpt)
+		return -ENOMEM;
+
+	ir_gpt->input = input_allocate_device();
+	if (!ir_gpt->input) {
+		ret = -ENOMEM;
+		goto free_mem;
+	}
+	ret = input_ir_create(ir_gpt->input);
+	if (ret)
+		goto free_input;
+
+	ir_gpt->input->name = "GPT IR Receiver";
+	ret = input_register_device(ir_gpt->input);
+	if (ret)
+		goto free_input;
+
+	spin_lock_init(&ir_gpt->lock);
+	INIT_WORK (&ir_gpt->queue, ir_event);
+
+	/* Fetch the registers and IRQ of the GPT */
+	if (of_address_to_resource(op->node, 0, &res)) {
+		dev_err(&op->dev, "Missing reg property\n");
+		ret = -ENODEV;
+		goto free_input;
+	}
+	ir_gpt->regs = ioremap(res.start, 1 + res.end - res.start);
+	if (!ir_gpt->regs) {
+		dev_err(&op->dev, "Could not map registers\n");
+		ret = -ENODEV;
+		goto free_input;
+	}
+	ir_gpt->irq = irq_of_parse_and_map(op->node, 0);
+	if (ir_gpt->irq == NO_IRQ) {
+		ret = -ENODEV;
+		goto free_input;
+	}
+	dev_dbg(&op->dev, "ir_gpt_of_probe irq=%d\n", ir_gpt->irq);
+
+	rc = request_irq(ir_gpt->irq, &dpeak_ir_irq, IRQF_SHARED,
+			 "gpt-ir", ir_gpt);
+	dev_dbg(&op->dev, "ir_gpt_of_probe request irq rc=%d\n", rc);
+
+	/* set prescale to ? */
+	out_be32(&ir_gpt->regs->count, 0x00870000);
+
+	/* Select input capture, enable the counter, and interrupt */
+	out_be32(&ir_gpt->regs->mode, 0x0);
+	out_be32(&ir_gpt->regs->mode, 0x00000501);
+
+	/* Save what we've done so it can be found again later */
+	dev_set_drvdata(&op->dev, ir_gpt);
+
+	printk("GPT IR Receiver driver\n");
+
+	return 0;
+
+free_input:
+	input_ir_destroy(ir_gpt->input);
+	input_free_device(ir_gpt->input);
+free_mem:
+	kfree(ir_gpt);
+	return ret;
+}
+
+static int __devexit ir_gpt_of_remove(struct of_device *op)
+{
+	struct ir_gpt *ir_gpt = dev_get_drvdata(&op->dev);
+
+	dev_dbg(&op->dev, "ir_gpt_remove()\n");
+
+	input_ir_destroy(ir_gpt->input);
+	input_free_device(ir_gpt->input);
+	kfree(ir_gpt);
+	dev_set_drvdata(&op->dev, NULL);
+
+	return 0;
+}
+
+/* Match table for of_platform binding */
+static struct of_device_id ir_gpt_match[] __devinitdata = {
+	{ .compatible = "gpt-ir", },
+	{}
+};
+MODULE_DEVICE_TABLE(of, ir_gpt_match);
+
+static struct of_platform_driver ir_gpt_driver = {
+	.match_table = ir_gpt_match,
+	.probe = ir_gpt_of_probe,
+	.remove = __devexit_p(ir_gpt_of_remove),
+	.driver = {
+		.name = "ir-gpt",
+		.owner = THIS_MODULE,
+	},
+};
+
+/* ---------------------------------------------------------------------
+ * Module setup and teardown; simply register the of_platform driver
+ */
+static int __init ir_gpt_init(void)
+{
+	return of_register_platform_driver(&ir_gpt_driver);
+}
+module_init(ir_gpt_init);
+
+static void __exit ir_gpt_exit(void)
+{
+	of_unregister_platform_driver(&ir_gpt_driver);
+}
+module_exit(ir_gpt_exit);
diff --git a/include/linux/input.h b/include/linux/input.h
index a5802c9..ed3a586 100644
--- a/include/linux/input.h
+++ b/include/linux/input.h
@@ -97,6 +97,7 @@ struct input_absinfo {
 #define EV_FF			0x15
 #define EV_PWR			0x16
 #define EV_FF_STATUS		0x17
+#define EV_IR			0x18
 #define EV_MAX			0x1f
 #define EV_CNT			(EV_MAX+1)
 
@@ -946,6 +947,25 @@ struct ff_effect {
 #define FF_MAX		0x7f
 #define FF_CNT		(FF_MAX+1)
 
+/*
+ * IR Support
+ */
+
+#define IR_PROTOCOL_JVC 1
+#define IR_PROTOCOL_NEC 2
+#define IR_PROTOCOL_NOKIA 3
+#define IR_PROTOCOL_SHARP 4
+#define IR_PROTOCOL_SONY 5
+#define IR_PROTOCOL_PHILIPS_RC5 6
+#define IR_PROTOCOL_PHILIPS_RC6 7
+#define IR_PROTOCOL_PHILIPS_RCMM 8
+#define IR_PROTOCOL_PHILIPS_RECS80 9
+
+#define IR_PROTOCOL 1
+#define IR_ADDRESS 2
+#define IR_COMMAND 3
+
+
 #ifdef __KERNEL__
 
 /*
@@ -1053,6 +1073,7 @@ struct input_dev {
 	int (*getkeycode)(struct input_dev *dev, int scancode, int *keycode);
 
 	struct ff_device *ff;
+	struct ir_device *ir;
 
 	unsigned int repeat_key;
 	struct timer_list timer;
@@ -1288,6 +1309,11 @@ static inline void input_report_switch(struct input_dev *dev, unsigned int code,
 	input_event(dev, EV_SW, code, !!value);
 }
 
+static inline void input_report_ir(struct input_dev *dev, unsigned int code, int value)
+{
+	input_event(dev, EV_IR, code, value);
+}
+
 static inline void input_sync(struct input_dev *dev)
 {
 	input_event(dev, EV_SYN, SYN_REPORT, 0);
@@ -1366,5 +1392,27 @@ int input_ff_erase(struct input_dev *dev, int effect_id, struct file *file);
 int input_ff_create_memless(struct input_dev *dev, void *data,
 		int (*play_effect)(struct input_dev *, void *, struct ff_effect *));
 
+/**
+ * struct ir_device - IR support structures
+ */
+
+struct ir_protocol {
+	unsigned int state, code, good, count, bits, mode;
+};
+
+struct ir_device {
+	struct ir_protocol sirc;
+	struct ir_protocol jvc;
+	struct ir_protocol nec;
+	struct ir_protocol rc5;
+	struct ir_protocol rc6;
+};
+
+int input_ir_create(struct input_dev *dev);
+void input_ir_destroy(struct input_dev *dev);
+
+void input_ir_decode(struct input_dev *dev, unsigned int delta, unsigned int bit);
+
+
 #endif
 #endif

