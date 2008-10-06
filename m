Return-Path: <linux-kernel-owner+w=401wt.eu-S1755522AbYJFTnu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755522AbYJFTnu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Oct 2008 15:43:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753234AbYJFTnR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Oct 2008 15:43:17 -0400
Received: from mail-gx0-f16.google.com ([209.85.217.16]:49828 "EHLO
	mail-gx0-f16.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752752AbYJFTnO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Oct 2008 15:43:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:subject:to:date:message-id:in-reply-to:references:user-agent
         :mime-version:content-type:content-transfer-encoding;
        b=WXysSWXXiIaXXncUpOl2JwoFOp2ALE/8G79s/WmnVuBv+3hCcDvKLFyNsOyWtS/QaV
         AgFs8H/ZkGGNS8/2E/4F2E02u6Lk4KGXdXp7qmfbuIvriwfIUCLopHirTNJ2FFiF5x2b
         j2v4U++aSkLyiQx0q2HpRSmLB3vtEw7aIkOCQ=
From: Jon Smirl <jonsmirl@gmail.com>
Subject: [RFC PATCH 1/4] Changes to core input subsystem to allow send and
	receive of IR messages. Encode and decode state machines are
	provided for common IR porotocols such as Sony, JVC, NEC,
	Philips, etc.
To: linux-kernel@vger.kernel.org, lirc-list@lists.sourceforge.net
Date: Mon, 06 Oct 2008 15:43:08 -0400
Message-ID: <20081006194308.15992.98682.stgit@terra>
In-Reply-To: <20081006194032.15992.8393.stgit@terra>
References: <20081006194032.15992.8393.stgit@terra>
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
 drivers/input/Kconfig           |    2 
 drivers/input/Makefile          |    3 
 drivers/input/evdev.c           |   55 +++
 drivers/input/input.c           |   21 +
 drivers/input/ir-core.c         |  659 +++++++++++++++++++++++++++++++++++++++
 drivers/input/ir/Kconfig        |   14 +
 drivers/input/ir/Makefile       |    5 
 include/linux/input.h           |  101 ++++++
 include/linux/mod_devicetable.h |    3 
 9 files changed, 862 insertions(+), 1 deletions(-)
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
index c13ced3..18f36d7 100644
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
@@ -693,6 +697,7 @@ static const struct input_device_id *input_match_device(const struct input_devic
 		MATCH_BIT(sndbit, SND_MAX);
 		MATCH_BIT(ffbit,  FF_MAX);
 		MATCH_BIT(swbit,  SW_MAX);
+		MATCH_BIT(irbit,  IR_MAX);
 
 		return id;
 	}
@@ -815,6 +820,8 @@ static int input_devices_seq_show(struct seq_file *seq, void *v)
 		input_seq_print_bitmap(seq, "FF", dev->ffbit, FF_MAX);
 	if (test_bit(EV_SW, dev->evbit))
 		input_seq_print_bitmap(seq, "SW", dev->swbit, SW_MAX);
+	if (test_bit(EV_IR, dev->evbit))
+		input_seq_print_bitmap(seq, "IR", dev->irbit, IR_MAX);
 
 	seq_putc(seq, '\n');
 
@@ -992,6 +999,8 @@ static int input_print_modalias(char *buf, int size, struct input_dev *id,
 				'f', id->ffbit, 0, FF_MAX);
 	len += input_print_modalias_bits(buf + len, size - len,
 				'w', id->swbit, 0, SW_MAX);
+	len += input_print_modalias_bits(buf + len, size - len,
+				'i', id->irbit, 0, IR_MAX);
 
 	if (add_cr)
 		len += snprintf(buf + len, max(size - len, 0), "\n");
@@ -1093,6 +1102,7 @@ INPUT_DEV_CAP_ATTR(LED, led);
 INPUT_DEV_CAP_ATTR(SND, snd);
 INPUT_DEV_CAP_ATTR(FF, ff);
 INPUT_DEV_CAP_ATTR(SW, sw);
+INPUT_DEV_CAP_ATTR(IR, ir);
 
 static struct attribute *input_dev_caps_attrs[] = {
 	&dev_attr_ev.attr,
@@ -1104,6 +1114,7 @@ static struct attribute *input_dev_caps_attrs[] = {
 	&dev_attr_snd.attr,
 	&dev_attr_ff.attr,
 	&dev_attr_sw.attr,
+	&dev_attr_ir.attr,
 	NULL
 };
 
@@ -1221,6 +1232,8 @@ static int input_dev_uevent(struct device *device, struct kobj_uevent_env *env)
 		INPUT_ADD_HOTPLUG_BM_VAR("FF=", dev->ffbit, FF_MAX);
 	if (test_bit(EV_SW, dev->evbit))
 		INPUT_ADD_HOTPLUG_BM_VAR("SW=", dev->swbit, SW_MAX);
+	if (test_bit(EV_IR, dev->evbit))
+		INPUT_ADD_HOTPLUG_BM_VAR("IR=", dev->irbit, IR_MAX);
 
 	INPUT_ADD_HOTPLUG_MODALIAS_VAR(dev);
 
@@ -1333,6 +1346,10 @@ void input_set_capability(struct input_dev *dev, unsigned int type, unsigned int
 		__set_bit(code, dev->ffbit);
 		break;
 
+	case EV_IR:
+		__set_bit(code, dev->irbit);
+		break;
+
 	case EV_PWR:
 		/* do nothing */
 		break;
@@ -1396,6 +1413,10 @@ int input_register_device(struct input_dev *dev)
 	if (error)
 		return error;
 
+	error = input_ir_register(dev);
+	if (error)
+		return error;
+
 	path = kobject_get_path(&dev->dev.kobj, GFP_KERNEL);
 	printk(KERN_INFO "input: %s as %s\n",
 		dev->name ? dev->name : "Unspecified device", path ? path : "N/A");
diff --git a/drivers/input/ir-core.c b/drivers/input/ir-core.c
new file mode 100644
index 0000000..8efcfa7
--- /dev/null
+++ b/drivers/input/ir-core.c
@@ -0,0 +1,659 @@
+/*
+ * Core routines for IR support
+ *
+ * Copyright (C) 2008 Jon Smirl <jonsmirl@gmail.com>
+ */
+
+#include <linux/kernel.h>
+#include <linux/device.h>
+#include <linux/input.h>
+
+#undef IR_PROTOCOL_DEBUG
+#ifdef IR_PROTOCOL_DEBUG
+#define PDEBUG( format, arg... ) \
+	printk(KERN_DEBUG format , ## arg);
+#else
+#define PDEBUG(format, arg...) \
+	({ if (0) printk(KERN_DEBUG format , ## arg); 0; })
+#endif
+
+static int encode_sony(struct ir_device *ir, struct ir_command *command)
+{
+	/* Sony SIRC IR code */
+	/* http://www.sbprojects.com/knowledge/ir/sirc.htm */
+	int i, bit, dev, cmd, total;
+
+	ir->send.count = 0;
+	switch (command->protocol) {
+	case IR_PROTOCOL_SONY_20:
+		dev = 10; cmd = 10; break;
+	case IR_PROTOCOL_SONY_15:
+		dev = 8; cmd = 7; break;
+	default:
+	case IR_PROTOCOL_SONY_12:
+		dev = 5; cmd = 7; break;
+	}
+	ir->send.buffer[ir->send.count++] = 2400;
+	ir->send.buffer[ir->send.count++] = 600;
+
+	for (i = 0; i < cmd; i++) {
+		bit = command->command & 1;
+		command->command >>= 1;
+		ir->send.buffer[ir->send.count++] = (bit ? 1200 : 600);
+		ir->send.buffer[ir->send.count++] = 600;
+	}
+	for (i = 0; i < dev; i++) {
+		bit = command->device & 1;
+		command->device >>= 1;
+		ir->send.buffer[ir->send.count++] = (bit ? 1200 : 600);
+		ir->send.buffer[ir->send.count++] = 600;
+	}
+	total = 0;
+	for (i = 0; i < ir->send.count; i++)
+		total += ir->send.buffer[i];
+	ir->send.buffer[ir->send.count++] = 45000 - total;
+
+	memcpy(&ir->send.buffer[ir->send.count], &ir->send.buffer[0], ir->send.count * sizeof ir->send.buffer[0]);
+	ir->send.count += ir->send.count;
+	memcpy(&ir->send.buffer[ir->send.count], &ir->send.buffer[0], ir->send.count * sizeof ir->send.buffer[0]);
+	ir->send.count += ir->send.count;
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
+
+	if ((bit == 0) && (delta > 22)) {
+		PDEBUG("SIRC state 1\n");
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
+				PDEBUG("SIRC - Saving %d bit %05x\n", (sony->state - 2) / 2, sony->code);
+				sony->good = sony->code;
+			}
+		}
+		sony->state = 1;
+		sony->code = 0;
+		return ret;
+	}
+	if ((sony->state == 1) && (bit == 1) && (delta == 4)) {
+		sony->state = 2;
+		PDEBUG("SIRC state 2\n");
+		return 0;
+	}
+	if ((sony->state == 2) && (bit == 0) && (delta == 1)) {
+		sony->state = 3;
+		PDEBUG("SIRC state 3\n");
+		return 0;
+	}
+	if ((sony->state >= 3) && (sony->state & 1) && (bit == 1) && ((delta == 1) || (delta == 2))) {
+		sony->state++;
+		sony->code |= ((delta - 1) << ((sony->state - 4) / 2));
+		PDEBUG("SIRC state %d bit %d\n", sony->state, delta - 1);
+		return 0;
+	}
+	if ((sony->state >= 3) && !(sony->state & 1) && (bit == 0) && (delta == 1)) {
+		sony->state++;
+		PDEBUG("SIRC state %d\n", sony-> state);
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
+	ir->send.count = 0;
+
+	ir->send.buffer[ir->send.count++] = 8400;
+	ir->send.buffer[ir->send.count++] = 4200;
+
+	for (i = 0; i < 8; i++) {
+		bit = command->device & 1;
+		command->device >>= 1;
+		ir->send.buffer[ir->send.count++] = 525;
+		ir->send.buffer[ir->send.count++] = (bit ? 1575 : 525);
+	}
+	for (i = 0; i < 8; i++) {
+		bit = command->command & 1;
+		command->command >>= 1;
+		ir->send.buffer[ir->send.count++] = 525;
+		ir->send.buffer[ir->send.count++] = (bit ? 1575 : 525);
+	}
+	ir->send.buffer[ir->send.count++] = 525;
+
+	total = 0;
+	for (i = 0; i < ir->send.count; i++)
+		total += ir->send.buffer[i];
+	ir->send.buffer[ir->send.count] = 55000 - total;
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
+
+	if ((bit == 0) && (delta > 22)) {
+		PDEBUG("JVC state 1\n");
+		jvc->state = 1;
+		jvc->code = 0;
+		return ret;
+	}
+	if ((jvc->state == 1) && (bit == 1) && (delta == 16)) {
+		jvc->state = 2;
+		PDEBUG("JVC state 2\n");
+		return 0;
+	}
+	if ((jvc->state == 2) && (bit == 0) && (delta == 8)) {
+		jvc->state = 3;
+		PDEBUG("JVC state 3\n");
+		return 0;
+	}
+	if ((jvc->state >= 3) && (jvc->state & 1) && (bit == 1) && (delta == 1)) {
+		jvc->state++;
+		PDEBUG("JVC state %d\n", jvc-> state);
+		return 0;
+	}
+	if ((jvc->state >= 3) && !(jvc->state & 1) && (bit == 0) && ((delta == 1) || (delta == 3))) {
+		if (delta == 3)
+			jvc->code |= 1 << ((jvc->state - 4) / 2);
+		jvc->state++;
+		PDEBUG("JVC state %d bit %d\n", jvc->state, delta - 1);
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
+				PDEBUG("JVC - Saving 16 bit %05x\n", jvc->code);
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
+	ir->send.count = 0;
+
+	ir->send.buffer[ir->send.count++] = 9000;
+	ir->send.buffer[ir->send.count++] = 4500;
+
+	for (i = 0; i < 8; i++) {
+		bit = command->device & 1;
+		command->device >>= 1;
+		ir->send.buffer[ir->send.count++] = 563;
+		ir->send.buffer[ir->send.count++] = (bit ? 1687 : 562);
+	}
+	for (i = 0; i < 8; i++) {
+		bit = command->command & 1;
+		command->command >>= 1;
+		ir->send.buffer[ir->send.count++] = 563;
+		ir->send.buffer[ir->send.count++] = (bit ? 1687 : 562);
+	}
+	ir->send.buffer[ir->send.count++] = 562;
+
+	total = 0;
+	for (i = 0; i < ir->send.count; i++)
+		total += ir->send.buffer[i];
+	ir->send.buffer[ir->send.count] = 110000 - total;
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
+
+	if ((bit == 0) && (delta > 22)) {
+		PDEBUG("nec state 1\n");
+		nec->state = 1;
+		nec->code = 0;
+		return 0;
+	}
+	if ((nec->state == 1) && (bit == 1) && (delta == 16)) {
+		nec->state = 2;
+		PDEBUG("nec state 2\n");
+		return 0;
+	}
+	if ((nec->state == 2) && (bit == 0) && (delta == 8)) {
+		nec->state = 3;
+		PDEBUG("nec state 3\n");
+		return 0;
+	}
+	if ((nec->state >= 3) && (nec->state & 1) && (bit == 1) && (delta == 1)) {
+		nec->state++;
+		PDEBUG("nec state %d\n", nec-> state);
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
+		PDEBUG("nec state %d bit %d\n", nec->state, delta - 1);
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
+	ir->send.count = 0;
+
+	ir->send.buffer[ir->send.count++] = 2666;
+	ir->send.buffer[ir->send.count++] = 889;
+
+	ir->send.buffer[ir->send.count++] = 444;
+	ir->send.buffer[ir->send.count++] = 444;
+
+	last = 1;
+	for (i = 0; i < 8; i++) {
+		bit = command->device & 1;
+		command->device >>= 1;
+
+		if (last != bit)
+			ir->send.buffer[ir->send.count - 1] += 444;
+		else
+			ir->send.buffer[ir->send.count++] = 444;
+		ir->send.buffer[ir->send.count++] = 444;
+		last = bit;
+	}
+	for (i = 0; i < 8; i++) {
+		bit = command->command & 1;
+		command->command >>= 1;
+
+		if (last != bit)
+			ir->send.buffer[ir->send.count - 1] += 444;
+		else
+			ir->send.buffer[ir->send.count++] = 444;
+		ir->send.buffer[ir->send.count++] = 444;
+		last = bit;
+	}
+	ir->send.buffer[ir->send.count] = 2666;
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
+		PDEBUG("rc6 state %d bit %d\n", rc6->state, rc6->bits == 2);
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
+
+	if ((bit == 0) && (delta > 19)) {
+		rc6->count = 0;
+		rc6->bits = 0;
+		rc6->state = 1;
+		rc6->code = 0;
+		PDEBUG("rc6 state 1\n");
+		return 0;
+	}
+	if ((rc6->state == 1) && (bit == 1) && (delta == 6)) {
+		rc6->state = 2;
+		PDEBUG("rc6 state 2\n");
+		return 0;
+	}
+	if ((rc6->state == 2) && (bit == 0) && (delta == 2)) {
+		rc6->state = 3;
+		PDEBUG("rc6 state 3\n");
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
+static void record_raw(struct input_dev *dev, unsigned int delta, unsigned int bit)
+{
+	int head = dev->ir->raw.head;
+	if (bit)
+		delta = -delta;
+
+	head += 1;
+	if (head > sizeof dev->ir->raw.buffer)
+		head = 0;
+
+	if (head != dev->ir->raw.tail) {
+		dev->ir->raw.buffer[dev->ir->raw.head] = delta;
+		dev->ir->raw.head = head;
+	}
+}
+
+void input_ir_decode(struct input_dev *dev, unsigned int delta, unsigned int bit)
+{
+	PDEBUG("IR bit %d %d\n", delta, bit);
+	record_raw(dev, delta, bit);
+	decode_sony(dev, &dev->ir->sony, delta, bit);
+	decode_jvc(dev, &dev->ir->jvc, delta, bit);
+	decode_nec(dev, &dev->ir->nec, delta, bit);
+	decode_rc5(dev, &dev->ir->rc5, delta, bit);
+	decode_rc6(dev, &dev->ir->rc6, delta, bit);
+}
+EXPORT_SYMBOL_GPL(input_ir_decode);
+
+static ssize_t ir_raw_show(struct device *dev,
+				 struct device_attribute *attr, char *buf)
+{
+	struct input_dev *input_dev = to_input_dev(dev);
+	unsigned int i = input_dev->ir->raw.tail;
+	unsigned int count = 0;
+
+	printk("head %d tail %d\n", input_dev->ir->raw.head, input_dev->ir->raw.tail);
+	while (i != input_dev->ir->raw.head) {
+		count += snprintf(&buf[count], PAGE_SIZE, "%i\n", input_dev->ir->raw.buffer[i++]);
+		if (count >= PAGE_SIZE) {
+			input_dev->ir->raw.tail = i;
+			return PAGE_SIZE;
+		}
+		if (i > sizeof input_dev->ir->raw.buffer)
+			i = 0;
+	}
+	input_dev->ir->raw.tail = i;
+	return count;
+}
+
+static ssize_t ir_raw_store(struct device *dev,
+				  struct device_attribute *attr,
+				  const char *buf,
+				  size_t count)
+{
+	struct ir_device *ir = to_input_dev(dev)->ir;
+	long delta;
+	int i = count;
+	int first = 0;
+
+	if (!ir->xmit)
+		return count;
+	ir->send.count = 0;
+
+	while (i > 0) {
+		i -= strict_strtoul(&buf[i], i, &delta);
+		while ((buf[i] != '\n') && (i > 0))
+			i--;
+		i--;
+		/* skip leading zeros */
+		if ((delta > 0) && !first)
+			continue;
+
+		ir->send.buffer[ir->send.count++] = abs(delta);
+	}
+
+	ir->xmit(ir->private, ir->send.buffer, ir->send.count, ir->raw.carrier, ir->raw.xmitter);
+
+	return count;
+}
+
+static ssize_t ir_carrier_show(struct device *dev,
+				 struct device_attribute *attr, char *buf)
+{
+	struct ir_device *ir = to_input_dev(dev)->ir;
+
+	return sprintf(buf, "%i\n", ir->raw.carrier);
+}
+
+static ssize_t ir_carrier_store(struct device *dev,
+				  struct device_attribute *attr,
+				  const char *buf,
+				  size_t count)
+{
+	struct ir_device *ir = to_input_dev(dev)->ir;
+
+	ir->raw.carrier = simple_strtoul(buf, NULL, 0);
+	return count;
+}
+
+static ssize_t ir_xmitter_show(struct device *dev,
+				 struct device_attribute *attr, char *buf)
+{
+	struct ir_device *ir = to_input_dev(dev)->ir;
+
+	return sprintf(buf, "%i\n", ir->raw.xmitter);
+}
+
+static ssize_t ir_xmitter_store(struct device *dev,
+				  struct device_attribute *attr,
+				  const char *buf,
+				  size_t count)
+{
+	struct ir_device *ir = to_input_dev(dev)->ir;
+
+	ir->raw.xmitter = simple_strtoul(buf, NULL, 0);
+	return count;
+}
+
+static DEVICE_ATTR(ir_raw, 0644, ir_raw_show, ir_raw_store);
+static DEVICE_ATTR(ir_carrier, 0644, ir_carrier_show, ir_carrier_store);
+static DEVICE_ATTR(ir_xmitter, 0644, ir_xmitter_show, ir_xmitter_store);
+
+int input_ir_register(struct input_dev *dev)
+{
+	int rc;
+
+	if (!dev->ir)
+		return 0;
+
+	rc = device_create_file(&dev->dev, &dev_attr_ir_raw);
+	if (rc)
+		return rc;
+
+	rc = device_create_file(&dev->dev, &dev_attr_ir_carrier);
+	if (rc)
+		return rc;
+
+	rc = device_create_file(&dev->dev, &dev_attr_ir_xmitter);
+	return rc;
+}
+
+int input_ir_create(struct input_dev *dev, void *private, send_func xmit)
+{
+	dev->ir = kzalloc(sizeof(struct ir_device), GFP_KERNEL);
+	if (!dev->ir)
+		return -ENOMEM;
+
+	dev->evbit[0] = BIT_MASK(EV_IR);
+	dev->ir->private = private;
+	dev->ir->xmit = xmit;
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
+	if (dev->ir && dev->ir->xmit)
+		ret = dev->ir->xmit(dev->ir->private, dev->ir->send.buffer, dev->ir->send.count, freq, xmit);
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
index a5802c9..2fbdf5a 100644
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
 
@@ -946,6 +949,55 @@ struct ff_effect {
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
+#define IR_CAP_RECEIVE_BASEBAND 0
+#define IR_CAP_RECEIVE_36K 1
+#define IR_CAP_RECEIVE_38K 2
+#define IR_CAP_RECEIVE_40K 3
+#define IR_CAP_RECEIVE_56K 4
+#define IR_CAP_SEND_BASEBAND 5
+#define IR_CAP_SEND_36K 6
+#define IR_CAP_SEND_38K 7
+#define IR_CAP_SEND_40K 8
+#define IR_CAP_SEND_56K 9
+#define IR_CAP_XMITTER_1 10
+#define IR_CAP_XMITTER_2 11
+#define IR_CAP_XMITTER_3 12
+#define IR_CAP_XMITTER_4 13
+#define IR_CAP_RECEIVE_RAW 14
+#define IR_CAP_SEND_RAW 15
+#define IR_MAX 0x0f
+#define IR_CNT IR_MAX + 1
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
@@ -973,6 +1025,7 @@ struct ff_effect {
  * @sndbit: bitmap of sound effects supported by the device
  * @ffbit: bitmap of force feedback effects supported by the device
  * @swbit: bitmap of switches present on the device
+ * @irbit: bitmap of capabilies of the IR hardware
  * @keycodemax: size of keycode table
  * @keycodesize: size of elements in keycode table
  * @keycode: map of scancodes to keycodes for this device
@@ -1045,6 +1098,7 @@ struct input_dev {
 	unsigned long sndbit[BITS_TO_LONGS(SND_CNT)];
 	unsigned long ffbit[BITS_TO_LONGS(FF_CNT)];
 	unsigned long swbit[BITS_TO_LONGS(SW_CNT)];
+	unsigned long irbit[BITS_TO_LONGS(IR_CNT)];
 
 	unsigned int keycodemax;
 	unsigned int keycodesize;
@@ -1053,6 +1107,7 @@ struct input_dev {
 	int (*getkeycode)(struct input_dev *dev, int scancode, int *keycode);
 
 	struct ff_device *ff;
+	struct ir_device *ir;
 
 	unsigned int repeat_key;
 	struct timer_list timer;
@@ -1288,6 +1343,11 @@ static inline void input_report_switch(struct input_dev *dev, unsigned int code,
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
@@ -1366,5 +1426,46 @@ int input_ff_erase(struct input_dev *dev, int effect_id, struct file *file);
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
+	struct mutex lock;
+	void *private;
+	send_func xmit;
+	struct {
+		unsigned int buffer[200];
+		unsigned int count;
+	} send;
+	struct {
+		int buffer[200];
+		unsigned int head;
+		unsigned int tail;
+		unsigned int carrier;
+		unsigned int xmitter;
+	} raw;
+};
+
+int input_ir_create(struct input_dev *dev, void *private, send_func send);
+void input_ir_destroy(struct input_dev *dev);
+
+void input_ir_decode(struct input_dev *dev, unsigned int delta, unsigned int bit);
+int input_ir_send(struct input_dev *dev, struct ir_command *ir_command, struct file *file);
+
+int input_ir_register(struct input_dev *dev);
+
 #endif
 #endif
diff --git a/include/linux/mod_devicetable.h b/include/linux/mod_devicetable.h
index c4db582..cb088ec 100644
--- a/include/linux/mod_devicetable.h
+++ b/include/linux/mod_devicetable.h
@@ -282,6 +282,7 @@ struct pcmcia_device_id {
 #define INPUT_DEVICE_ID_SND_MAX		0x07
 #define INPUT_DEVICE_ID_FF_MAX		0x7f
 #define INPUT_DEVICE_ID_SW_MAX		0x0f
+#define INPUT_DEVICE_ID_IR_MAX		0x0f
 
 #define INPUT_DEVICE_ID_MATCH_BUS	1
 #define INPUT_DEVICE_ID_MATCH_VENDOR	2
@@ -297,6 +298,7 @@ struct pcmcia_device_id {
 #define INPUT_DEVICE_ID_MATCH_SNDBIT	0x0400
 #define INPUT_DEVICE_ID_MATCH_FFBIT	0x0800
 #define INPUT_DEVICE_ID_MATCH_SWBIT	0x1000
+#define INPUT_DEVICE_ID_MATCH_IRBIT	0x2000
 
 struct input_device_id {
 
@@ -316,6 +318,7 @@ struct input_device_id {
 	kernel_ulong_t sndbit[INPUT_DEVICE_ID_SND_MAX / BITS_PER_LONG + 1];
 	kernel_ulong_t ffbit[INPUT_DEVICE_ID_FF_MAX / BITS_PER_LONG + 1];
 	kernel_ulong_t swbit[INPUT_DEVICE_ID_SW_MAX / BITS_PER_LONG + 1];
+	kernel_ulong_t irbit[INPUT_DEVICE_ID_IR_MAX / BITS_PER_LONG + 1];
 
 	kernel_ulong_t driver_info;
 };

