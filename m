Return-Path: <linux-kernel-owner+w=401wt.eu-S1754045AbYI2QRs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754045AbYI2QRs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2008 12:17:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752596AbYI2QR2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Sep 2008 12:17:28 -0400
Received: from mail-gx0-f16.google.com ([209.85.217.16]:48444 "EHLO
	mail-gx0-f16.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751482AbYI2QR0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2008 12:17:26 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:subject:to:date:message-id:in-reply-to:references:user-agent
         :mime-version:content-type:content-transfer-encoding;
        b=G7r7S9sDVETOp0LKFCi/lJksqZW2Y6hutFHCX/xgZkhm0VfuNULFrZaBwzQ2dfM8LQ
         4ri6/mV3RYxmfJNMwcg+DPotKhtJhV0vPe/is99VmEVcnrWAAZ+sM02GzFYleOD/gWHE
         lDfvS5/yaj7V2HgWRnmQ08Cokioo5TDEG7Zhw=
From: Jon Smirl <jonsmirl@gmail.com>
Subject: [RFC PATCH 1/4] Changes to core input subsystem to allow send and
	receive of IR messages. Encode and decode state machines are
	provided for common IR porotocols such as Sony, JVC, NEC,
	Philips, etc.
To: linux-kernel@vger.kernel.org, lirc-list@lists.sourceforge.net,
       lirc@bartelmus.de
Date: Mon, 29 Sep 2008 12:17:23 -0400
Message-ID: <20080929161722.14559.94649.stgit@terra>
In-Reply-To: <20080929155506.14559.35166.stgit@terra>
References: <20080929155506.14559.35166.stgit@terra>
User-Agent: StGIT/0.14.3.224.g199b
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Received IR messages generate event in the input queue.
IR messages are sent using an input IOCTL.

Jon Smirl
<jonsmirl@gmail.com>
---
 drivers/input/Kconfig     |    2 
 drivers/input/Makefile    |    3 
 drivers/input/evdev.c     |   55 +++++
 drivers/input/input.c     |    4 
 drivers/input/ir-core.c   |  523 +++++++++++++++++++++++++++++++++++++++++++++
 drivers/input/ir/Kconfig  |   14 +
 drivers/input/ir/Makefile |    5 
 include/linux/input.h     |   70 ++++++
 8 files changed, 675 insertions(+), 1 deletions(-)
 create mode 100644 drivers/input/ir-core.c
 create mode 100644 drivers/input/ir/Kconfig
 create mode 100644 drivers/input/ir/Makefile

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
 
diff --git a/drivers/input/evdev.c b/drivers/input/evdev.c
index 3524bef..7a3f935 100644
--- a/drivers/input/evdev.c
+++ b/drivers/input/evdev.c
@@ -329,6 +329,14 @@ struct ff_effect_compat {
 	} u;
 };
 
+struct ir_command_compat {
+	__u32 protocol;
+	__u32 device;
+	__u32 command;
+	__u32 transmitters;
+};
+
+
 /* Note to the author of this code: did it ever occur to
    you why the ifdefs are needed? Think about it again. -AK */
 #ifdef CONFIG_X86_64
@@ -433,6 +441,32 @@ static int evdev_ff_effect_from_user(const char __user *buffer, size_t size,
 	return 0;
 }
 
+static int evdev_ir_send_from_user(const char __user *buffer, size_t size,
+				     struct ir_command *ir_command)
+{
+	if (COMPAT_TEST) {
+		struct ir_command_compat *compat_ir_command;
+
+		if (size != sizeof(struct ir_command_compat))
+			return -EINVAL;
+
+		compat_ir_command = (struct ir_command_compat *)ir_command;
+
+		if (copy_from_user(compat_ir_command, buffer,
+				   sizeof(struct ir_command_compat)))
+			return -EFAULT;
+
+	} else {
+		if (size != sizeof(struct ir_command))
+			return -EINVAL;
+
+		if (copy_from_user(ir_command, buffer, sizeof(struct ir_command)))
+			return -EFAULT;
+	}
+
+	return 0;
+}
+
 #else
 
 static inline size_t evdev_event_size(void)
@@ -470,6 +504,18 @@ static int evdev_ff_effect_from_user(const char __user *buffer, size_t size,
 	return 0;
 }
 
+static int evdev_ir_send_from_user(const char __user *buffer, size_t size,
+				     struct ir_command *ir_command)
+{
+	if (size != sizeof(struct ir_command))
+		return -EINVAL;
+
+	if (copy_from_user(ir_command, buffer, sizeof(struct ir_command)))
+		return -EFAULT;
+
+	return 0;
+}
+
 #endif /* CONFIG_COMPAT */
 
 static ssize_t evdev_write(struct file *file, const char __user *buffer,
@@ -696,6 +742,7 @@ static long evdev_do_ioctl(struct file *file, unsigned int cmd,
 	struct input_dev *dev = evdev->handle.dev;
 	struct input_absinfo abs;
 	struct ff_effect effect;
+	struct ir_command ir_command;
 	int __user *ip = (int __user *)p;
 	int i, t, u, v;
 	int error;
@@ -860,6 +907,14 @@ static long evdev_do_ioctl(struct file *file, unsigned int cmd,
 
 				return 0;
 			}
+
+			if (_IOC_NR(cmd) == _IOC_NR(EVIOIRSEND)) {
+
+				if (evdev_ir_send_from_user(p, _IOC_SIZE(cmd), &ir_command))
+					return -EFAULT;
+
+				return input_ir_send(dev, &ir_command, file);
+			}
 		}
 	}
 	return -EINVAL;
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
index 0000000..2f0595c
--- /dev/null
+++ b/drivers/input/ir-core.c
@@ -0,0 +1,523 @@
+/*
+ * Core routines for IR support
+ *
+ * Copyright (C) 2008 Jon Smirl <jonsmirl@gmail.com>
+ */
+
+#include <linux/input.h>
+
+static int encode_sony(struct ir_device *ir, struct ir_command *command)
+{
+	/* Sony SIRC IR code */
+	/* http://www.sbprojects.com/knowledge/ir/sirc.htm */
+	int i, bit, dev, cmd, total;
+
+	ir->count = 0;
+	switch (command->protocol) {
+	default:
+	case IR_PROTOCOL_SONY_12:
+		dev = 5; cmd = 7; break;
+	case IR_PROTOCOL_SONY_15:
+		dev = 8; cmd = 7; break;
+	case IR_PROTOCOL_SONY_20:
+		dev = 10; cmd = 10; break;
+	}
+	ir->buffer[ir->count++] = 2400;
+	ir->buffer[ir->count++] = 600;
+
+	for (i = 0; i < cmd; i++) {
+		bit = command->command & 1;
+		command->command >>= 1;
+		ir->buffer[ir->count++] = (bit ? 1200 : 600);
+		ir->buffer[ir->count++] = 600;
+	}
+	for (i = 0; i < dev; i++) {
+		bit = command->device & 1;
+		command->device >>= 1;
+		ir->buffer[ir->count++] = (bit ? 1200 : 600);
+		ir->buffer[ir->count++] = 600;
+	}
+	total = 0;
+	for (i = 0; i < ir->count; i++)
+		total += ir->buffer[i];
+	ir->buffer[ir->count++] = 45000 - total;
+
+	memcpy(&ir->buffer[ir->count], &ir->buffer[0], ir->count * sizeof ir->buffer[0]);
+	ir->count += ir->count;
+	memcpy(&ir->buffer[ir->count], &ir->buffer[0], ir->count * sizeof ir->buffer[0]);
+	ir->count += ir->count;
+
+	return 0;
+}
+
+static int decode_sony(struct input_dev *dev, struct ir_protocol *sony, unsigned int d, unsigned int bit)
+{
+	/* Sony SIRC IR code */
+	/* http://www.sbprojects.com/knowledge/ir/sirc.htm */
+	/* based on a 600us cadence */
+	int ret = 0, delta = d;
+
+	delta = (delta + 300) / 600;
+	printk("D %d %d %d\n", d, delta, bit);
+
+	if ((bit == 0) && (delta > 22)) {
+		printk("SIRC state 1\n");
+		if ((sony->state == 26) || (sony->state == 32) || (sony->state == 42)) {
+			if (sony->good && (sony->good == sony->code)) {
+
+				input_report_ir(dev, IR_PROTOCOL, (sony->state == 26) ? IR_PROTOCOL_SONY_12 :
+						(sony->state == 32) ? IR_PROTOCOL_SONY_15 : IR_PROTOCOL_SONY_20);
+
+				if (sony->state == 26) {
+					input_report_ir(dev, IR_DEVICE, sony->code & 0x1F);
+					input_report_ir(dev, IR_COMMAND, sony->code >> 5);
+				} else {
+					input_report_ir(dev, IR_DEVICE, sony->code & 0xFF);
+					input_report_ir(dev, IR_COMMAND, sony->code >> 8);
+				}
+				input_sync(dev);
+
+				sony->good = 0;
+				ret = 1;
+			} else {
+				printk("SIRC - Saving %d bit %05x\n", (sony->state - 2) / 2, sony->code);
+				sony->good = sony->code;
+			}
+		}
+		sony->state = 1;
+		sony->code = 0;
+		return ret;
+	}
+	if ((sony->state == 1) && (bit == 1) && (delta == 4)) {
+		sony->state = 2;
+		printk("SIRC state 2\n");
+		return 0;
+	}
+	if ((sony->state == 2) && (bit == 0) && (delta == 1)) {
+		sony->state = 3;
+		printk("SIRC state 3\n");
+		return 0;
+	}
+	if ((sony->state >= 3) && (sony->state & 1) && (bit == 1) && ((delta == 1) || (delta == 2))) {
+		sony->state++;
+		sony->code |= ((delta - 1) << ((sony->state - 4) / 2));
+		printk("SIRC state %d bit %d\n", sony->state, delta - 1);
+		return 0;
+	}
+	if ((sony->state >= 3) && !(sony->state & 1) && (bit == 0) && (delta == 1)) {
+		sony->state++;
+		printk("SIRC state %d\n", sony-> state);
+		return 0;
+	}
+	sony->state = 0;
+	return 0;
+}
+
+
+static int encode_jvc(struct ir_device *ir, struct ir_command *command)
+{
+	/* JVC IR code */
+	/* http://www.sbprojects.com/knowledge/ir/jvc.htm */
+	int i, bit, total;
+
+	ir->count = 0;
+
+	ir->buffer[ir->count++] = 8400;
+	ir->buffer[ir->count++] = 4200;
+
+	for (i = 0; i < 8; i++) {
+		bit = command->device & 1;
+		command->device >>= 1;
+		ir->buffer[ir->count++] = 525;
+		ir->buffer[ir->count++] = (bit ? 1575 : 525);
+	}
+	for (i = 0; i < 8; i++) {
+		bit = command->command & 1;
+		command->command >>= 1;
+		ir->buffer[ir->count++] = 525;
+		ir->buffer[ir->count++] = (bit ? 1575 : 525);
+	}
+	ir->buffer[ir->count++] = 525;
+
+	total = 0;
+	for (i = 0; i < ir->count; i++)
+		total += ir->buffer[i];
+	ir->buffer[ir->count] = 55000 - total;
+
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
+				input_report_ir(dev, IR_DEVICE, jvc->code >> 8);
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
+
+static int encode_nec(struct ir_device *ir, struct ir_command *command)
+{
+	/* NEC IR code */
+	/* http://www.sbprojects.com/knowledge/ir/nec.htm */
+	int i, bit, total;
+
+	ir->count = 0;
+
+	ir->buffer[ir->count++] = 9000;
+	ir->buffer[ir->count++] = 4500;
+
+	for (i = 0; i < 8; i++) {
+		bit = command->device & 1;
+		command->device >>= 1;
+		ir->buffer[ir->count++] = 563;
+		ir->buffer[ir->count++] = (bit ? 1687 : 562);
+	}
+	for (i = 0; i < 8; i++) {
+		bit = command->command & 1;
+		command->command >>= 1;
+		ir->buffer[ir->count++] = 563;
+		ir->buffer[ir->count++] = (bit ? 1687 : 562);
+	}
+	ir->buffer[ir->count++] = 562;
+
+	total = 0;
+	for (i = 0; i < ir->count; i++)
+		total += ir->buffer[i];
+	ir->buffer[ir->count] = 110000 - total;
+
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
+			input_report_ir(dev, IR_DEVICE, nec->code >> 16);
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
+
+static int encode_rc5(struct ir_device *ir, struct ir_command *command)
+{
+	/* Philips RC-5 IR code */
+	/* http://www.sbprojects.com/knowledge/ir/rc5.htm */
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
+
+static int encode_rc6(struct ir_device *ir, struct ir_command *command)
+{
+	/* Philips RC-6 IR code */
+	/* http://www.sbprojects.com/knowledge/ir/rc6.htm */
+	int i, bit, last;
+
+	ir->count = 0;
+
+	ir->buffer[ir->count++] = 2666;
+	ir->buffer[ir->count++] = 889;
+
+	ir->buffer[ir->count++] = 444;
+	ir->buffer[ir->count++] = 444;
+
+	last = 1;
+	for (i = 0; i < 8; i++) {
+		bit = command->device & 1;
+		command->device >>= 1;
+
+		if (last != bit)
+			ir->buffer[ir->count - 1] += 444;
+		else
+			ir->buffer[ir->count++] = 444;
+		ir->buffer[ir->count++] = 444;
+		last = bit;
+	}
+	for (i = 0; i < 8; i++) {
+		bit = command->command & 1;
+		command->command >>= 1;
+
+		if (last != bit)
+			ir->buffer[ir->count - 1] += 444;
+		else
+			ir->buffer[ir->count++] = 444;
+		ir->buffer[ir->count++] = 444;
+		last = bit;
+	}
+	ir->buffer[ir->count] = 2666;
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
+			input_report_ir(dev, IR_DEVICE, rc6->code >> 8);
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
+	decode_sony(dev, &dev->ir->sony, delta, bit);
+	decode_jvc(dev, &dev->ir->jvc, delta, bit);
+	decode_nec(dev, &dev->ir->nec, delta, bit);
+	decode_rc5(dev, &dev->ir->rc5, delta, bit);
+	decode_rc6(dev, &dev->ir->rc6, delta, bit);
+}
+EXPORT_SYMBOL_GPL(input_ir_decode);
+
+
+int input_ir_create(struct input_dev *dev, void *private, send_func send)
+{
+	dev->ir = kzalloc(sizeof(struct ir_device), GFP_KERNEL);
+	if (!dev->ir)
+		return -ENOMEM;
+
+	dev->evbit[0] = BIT_MASK(EV_IR);
+	dev->ir->private = private;
+	dev->ir->send = send;
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
+
+int input_ir_send(struct input_dev *dev, struct ir_command *ir_command, struct file *file)
+{
+	unsigned freq, xmit = 0;
+	int ret;
+
+	mutex_lock(&dev->ir->lock);
+
+	switch (ir_command->protocol) {
+	case IR_PROTOCOL_PHILIPS_RC5:
+		freq = 36000;
+		encode_rc5(dev->ir, ir_command);
+		break;
+	case IR_PROTOCOL_PHILIPS_RC6:
+		freq = 36000;
+		encode_rc6(dev->ir, ir_command);
+		break;
+	case IR_PROTOCOL_PHILIPS_RCMM:
+		freq = 36000;
+		encode_rc5(dev->ir, ir_command);
+		break;
+	case IR_PROTOCOL_JVC:
+		freq = 38000;
+		encode_jvc(dev->ir, ir_command);
+		break;
+	case IR_PROTOCOL_NEC:
+		freq = 38000;
+		encode_nec(dev->ir, ir_command);
+		break;
+	case IR_PROTOCOL_NOKIA:
+	case IR_PROTOCOL_SHARP:
+	case IR_PROTOCOL_PHILIPS_RECS80:
+		freq = 38000;
+		break;
+	case IR_PROTOCOL_SONY_12:
+	case IR_PROTOCOL_SONY_15:
+	case IR_PROTOCOL_SONY_20:
+		encode_sony(dev->ir, ir_command);
+		freq = 40000;
+		break;
+	case IR_PROTOCOL_RCA:
+		freq = 56000;
+		break;
+	case IR_PROTOCOL_ITT:
+		freq = 0;
+		break;
+	default:
+		ret = -ENODEV;
+		goto exit;
+	}
+
+	if (dev->ir && dev->ir->send)
+		ret = dev->ir->send(dev->ir->private, dev->ir->buffer, dev->ir->count, freq, xmit);
+	else
+		ret = -ENODEV;
+
+exit:
+	mutex_unlock(&dev->ir->lock);
+	return ret;
+}
+EXPORT_SYMBOL_GPL(input_ir_send);
+
diff --git a/drivers/input/ir/Kconfig b/drivers/input/ir/Kconfig
new file mode 100644
index 0000000..8afd2d6
--- /dev/null
+++ b/drivers/input/ir/Kconfig
@@ -0,0 +1,14 @@
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
+endif
diff --git a/drivers/input/ir/Makefile b/drivers/input/ir/Makefile
new file mode 100644
index 0000000..08e6954
--- /dev/null
+++ b/drivers/input/ir/Makefile
@@ -0,0 +1,5 @@
+# Makefile for the ir drivers.
+#
+
+# Each configuration option enables a list of files.
+
diff --git a/include/linux/input.h b/include/linux/input.h
index a5802c9..2e3be0b 100644
--- a/include/linux/input.h
+++ b/include/linux/input.h
@@ -79,6 +79,8 @@ struct input_absinfo {
 #define EVIOCRMFF		_IOW('E', 0x81, int)			/* Erase a force effect */
 #define EVIOCGEFFECTS		_IOR('E', 0x84, int)			/* Report number of effects playable at the same time */
 
+#define EVIOIRSEND		_IOC(_IOC_WRITE, 'E', 0x80, sizeof(struct ir_command))	/* send an IR command */
+
 #define EVIOCGRAB		_IOW('E', 0x90, int)			/* Grab/Release device */
 
 /*
@@ -97,6 +99,7 @@ struct input_absinfo {
 #define EV_FF			0x15
 #define EV_PWR			0x16
 #define EV_FF_STATUS		0x17
+#define EV_IR			0x18
 #define EV_MAX			0x1f
 #define EV_CNT			(EV_MAX+1)
 
@@ -946,6 +949,36 @@ struct ff_effect {
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
+#define IR_PROTOCOL_SONY_12 5
+#define IR_PROTOCOL_SONY_15 6
+#define IR_PROTOCOL_SONY_20 7
+#define IR_PROTOCOL_PHILIPS_RC5 8
+#define IR_PROTOCOL_PHILIPS_RC6 9
+#define IR_PROTOCOL_PHILIPS_RCMM 10
+#define IR_PROTOCOL_PHILIPS_RECS80 11
+#define IR_PROTOCOL_RCA 12
+#define IR_PROTOCOL_ITT 13
+
+#define IR_PROTOCOL 1
+#define IR_DEVICE 2
+#define IR_COMMAND 3
+
+struct ir_command {
+	__u32 protocol;
+	__u32 device;
+	__u32 command;
+	__u32 transmitters;
+};
+
+
 #ifdef __KERNEL__
 
 /*
@@ -1053,6 +1086,7 @@ struct input_dev {
 	int (*getkeycode)(struct input_dev *dev, int scancode, int *keycode);
 
 	struct ff_device *ff;
+	struct ir_device *ir;
 
 	unsigned int repeat_key;
 	struct timer_list timer;
@@ -1288,6 +1322,11 @@ static inline void input_report_switch(struct input_dev *dev, unsigned int code,
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
@@ -1366,5 +1405,36 @@ int input_ff_erase(struct input_dev *dev, int effect_id, struct file *file);
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
+typedef int (*send_func)(void *private, unsigned int *buffer, unsigned int count,
+		unsigned int frequency, unsigned int xmitters);
+
+struct ir_device {
+	struct ir_protocol sony;
+	struct ir_protocol jvc;
+	struct ir_protocol nec;
+	struct ir_protocol rc5;
+	struct ir_protocol rc6;
+	send_func send;
+	void *private;
+	struct mutex lock;
+	unsigned int buffer[200];
+	unsigned int count;
+};
+
+int input_ir_create(struct input_dev *dev, void *private, send_func send);
+void input_ir_destroy(struct input_dev *dev);
+
+void input_ir_decode(struct input_dev *dev, unsigned int delta, unsigned int bit);
+int input_ir_send(struct input_dev *dev, struct ir_command *ir_command, struct file *file);
+
+
 #endif
 #endif

