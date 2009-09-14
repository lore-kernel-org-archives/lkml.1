Return-Path: <linux-kernel-owner+w=401wt.eu-S1757407AbZINV7x@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757407AbZINV7x (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Sep 2009 17:59:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756942AbZINV7w
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Sep 2009 17:59:52 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:50791 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757393AbZINV7u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Sep 2009 17:59:50 -0400
Date: Mon, 14 Sep 2009 23:59:42 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Greg KH <greg@kroah.com>, arve@android.com, swetland@google.com,
       kernel list <linux-kernel@vger.kernel.org>
Subject: [patch 4/6] add gpios for Dream
Message-ID: <20090914215942.GD11667@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This adds gpio infrastructure for HTC Dream. Other pieces depend on
it, including camera driver.

Signed-off-by: Pavel Machek <pavel@ucw.cz>

diff --git a/drivers/staging/dream/Makefile b/drivers/staging/dream/Makefile
index 6afbadf..b1d4609 100644
--- a/drivers/staging/dream/Makefile
+++ b/drivers/staging/dream/Makefile
@@ -2,4 +2,5 @@ obj-$(CONFIG_MSM_ADSP)		+= qdsp5/ smd/
 obj-$(CONFIG_MSM_CAMERA)	+= camera/
 obj-$(CONFIG_INPUT_GPIO)	+= gpio_axis.o gpio_event.o gpio_input.o gpio_matrix.o gpio_output.o
 obj-$(CONFIG_ANDROID_PMEM)	+= pmem.o
+obj-y				+= generic_gpio.o
 
diff --git a/drivers/staging/dream/generic_gpio.c b/drivers/staging/dream/generic_gpio.c
new file mode 100644
index 0000000..fe24d38
--- /dev/null
+++ b/drivers/staging/dream/generic_gpio.c
@@ -0,0 +1,274 @@
+/* arch/arm/mach-msm/generic_gpio.c
+ *
+ * Copyright (C) 2007 Google, Inc.
+ *
+ * This software is licensed under the terms of the GNU General Public
+ * License version 2, as published by the Free Software Foundation, and
+ * may be copied, distributed, and modified under those terms.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ */
+
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/errno.h>
+#include <linux/slab.h>
+#include <linux/spinlock.h>
+#include <asm/gpio.h>
+#include "gpio_chip.h"
+
+#define GPIO_NUM_TO_CHIP_INDEX(gpio) ((gpio)>>5)
+
+struct gpio_state {
+	unsigned long flags;
+	int refcount;
+};
+
+static DEFINE_SPINLOCK(gpio_chips_lock);
+static LIST_HEAD(gpio_chip_list);
+static struct gpio_chip **gpio_chip_array;
+static unsigned long gpio_chip_array_size;
+
+int register_gpio_chip(struct gpio_chip *new_gpio_chip)
+{
+	int err = 0;
+	struct gpio_chip *gpio_chip;
+	int i;
+	unsigned long irq_flags;
+	unsigned int chip_array_start_index, chip_array_end_index;
+
+	new_gpio_chip->state = kzalloc((new_gpio_chip->end + 1 - new_gpio_chip->start) * sizeof(new_gpio_chip->state[0]), GFP_KERNEL);
+	if (new_gpio_chip->state == NULL) {
+		printk(KERN_ERR "register_gpio_chip: failed to allocate state\n");
+		return -ENOMEM;
+	}
+
+	spin_lock_irqsave(&gpio_chips_lock, irq_flags);
+	chip_array_start_index = GPIO_NUM_TO_CHIP_INDEX(new_gpio_chip->start);
+	chip_array_end_index = GPIO_NUM_TO_CHIP_INDEX(new_gpio_chip->end);
+	if (chip_array_end_index >= gpio_chip_array_size) {
+		struct gpio_chip **new_gpio_chip_array;
+		unsigned long new_gpio_chip_array_size = chip_array_end_index + 1;
+
+		new_gpio_chip_array = kmalloc(new_gpio_chip_array_size * sizeof(new_gpio_chip_array[0]), GFP_ATOMIC);
+		if (new_gpio_chip_array == NULL) {
+			printk(KERN_ERR "register_gpio_chip: failed to allocate array\n");
+			err = -ENOMEM;
+			goto failed;
+		}
+		for (i = 0; i < gpio_chip_array_size; i++)
+			new_gpio_chip_array[i] = gpio_chip_array[i];
+		for (i = gpio_chip_array_size; i < new_gpio_chip_array_size; i++)
+			new_gpio_chip_array[i] = NULL;
+		gpio_chip_array = new_gpio_chip_array;
+		gpio_chip_array_size = new_gpio_chip_array_size;
+	}
+	list_for_each_entry(gpio_chip, &gpio_chip_list, list) {
+		if (gpio_chip->start > new_gpio_chip->end) {
+			list_add_tail(&new_gpio_chip->list, &gpio_chip->list);
+			goto added;
+		}
+		if (gpio_chip->end >= new_gpio_chip->start) {
+			printk(KERN_ERR "register_gpio_source %u-%u overlaps with %u-%u\n",
+			       new_gpio_chip->start, new_gpio_chip->end,
+			       gpio_chip->start, gpio_chip->end);
+			err = -EBUSY;
+			goto failed;
+		}
+	}
+	list_add_tail(&new_gpio_chip->list, &gpio_chip_list);
+added:
+	for (i = chip_array_start_index; i <= chip_array_end_index; i++) {
+		if (gpio_chip_array[i] == NULL || gpio_chip_array[i]->start > new_gpio_chip->start)
+			gpio_chip_array[i] = new_gpio_chip;
+	}
+failed:
+	spin_unlock_irqrestore(&gpio_chips_lock, irq_flags);
+	if (err)
+		kfree(new_gpio_chip->state);
+	return err;
+}
+
+static struct gpio_chip *get_gpio_chip_locked(unsigned int gpio)
+{
+	unsigned long i;
+	struct gpio_chip *chip;
+
+	i = GPIO_NUM_TO_CHIP_INDEX(gpio);
+	if (i >= gpio_chip_array_size)
+		return NULL;
+	chip = gpio_chip_array[i];
+	if (chip == NULL)
+		return NULL;
+	list_for_each_entry_from(chip, &gpio_chip_list, list) {
+		if (gpio < chip->start)
+			return NULL;
+		if (gpio <= chip->end)
+			return chip;
+	}
+	return NULL;
+}
+
+static int request_gpio(unsigned int gpio, unsigned long flags)
+{
+	int err = 0;
+	struct gpio_chip *chip;
+	unsigned long irq_flags;
+	unsigned long chip_index;
+
+	spin_lock_irqsave(&gpio_chips_lock, irq_flags);
+	chip = get_gpio_chip_locked(gpio);
+	if (chip == NULL) {
+		err = -EINVAL;
+		goto err;
+	}
+	chip_index = gpio - chip->start;
+	if (chip->state[chip_index].refcount == 0) {
+		chip->configure(chip, gpio, flags);
+		chip->state[chip_index].flags = flags;
+		chip->state[chip_index].refcount++;
+	} else if ((flags & IRQF_SHARED) && (chip->state[chip_index].flags & IRQF_SHARED))
+		chip->state[chip_index].refcount++;
+	else
+		err = -EBUSY;
+err:
+	spin_unlock_irqrestore(&gpio_chips_lock, irq_flags);
+	return err;
+}
+
+int gpio_request(unsigned gpio, const char *label)
+{
+	return request_gpio(gpio, 0);
+}
+EXPORT_SYMBOL(gpio_request);
+
+void gpio_free(unsigned gpio)
+{
+	struct gpio_chip *chip;
+	unsigned long irq_flags;
+	unsigned long chip_index;
+
+	spin_lock_irqsave(&gpio_chips_lock, irq_flags);
+	chip = get_gpio_chip_locked(gpio);
+	if (chip) {
+		chip_index = gpio - chip->start;
+		chip->state[chip_index].refcount--;
+	}
+	spin_unlock_irqrestore(&gpio_chips_lock, irq_flags);
+}
+EXPORT_SYMBOL(gpio_free);
+
+static int gpio_get_irq_num(unsigned int gpio, unsigned int *irqp, unsigned long *irqnumflagsp)
+{
+	int ret = -ENOTSUPP;
+	struct gpio_chip *chip;
+	unsigned long irq_flags;
+
+	spin_lock_irqsave(&gpio_chips_lock, irq_flags);
+	chip = get_gpio_chip_locked(gpio);
+	if (chip && chip->get_irq_num)
+		ret = chip->get_irq_num(chip, gpio, irqp, irqnumflagsp);
+	spin_unlock_irqrestore(&gpio_chips_lock, irq_flags);
+	return ret;
+}
+
+int gpio_to_irq(unsigned gpio)
+{
+	int ret, irq;
+	ret = gpio_get_irq_num(gpio, &irq, NULL);
+	if (ret)
+		return ret;
+	return irq;
+}
+EXPORT_SYMBOL(gpio_to_irq);
+
+int gpio_configure(unsigned int gpio, unsigned long flags)
+{
+	int ret = -ENOTSUPP;
+	struct gpio_chip *chip;
+	unsigned long irq_flags;
+
+	spin_lock_irqsave(&gpio_chips_lock, irq_flags);
+	chip = get_gpio_chip_locked(gpio);
+	if (chip)
+		ret = chip->configure(chip, gpio, flags);
+	spin_unlock_irqrestore(&gpio_chips_lock, irq_flags);
+	return ret;
+}
+EXPORT_SYMBOL(gpio_configure);
+
+int gpio_direction_input(unsigned gpio)
+{
+	return gpio_configure(gpio, GPIOF_INPUT);
+}
+EXPORT_SYMBOL(gpio_direction_input);
+
+int gpio_direction_output(unsigned gpio, int value)
+{
+	gpio_set_value(gpio, value);
+	return gpio_configure(gpio, GPIOF_DRIVE_OUTPUT);
+}
+EXPORT_SYMBOL(gpio_direction_output);
+
+int gpio_get_value(unsigned gpio)
+{
+	int ret = -ENOTSUPP;
+	struct gpio_chip *chip;
+	unsigned long irq_flags;
+
+	spin_lock_irqsave(&gpio_chips_lock, irq_flags);
+	chip = get_gpio_chip_locked(gpio);
+	if (chip && chip->read)
+		ret = chip->read(chip, gpio);
+	spin_unlock_irqrestore(&gpio_chips_lock, irq_flags);
+	return ret;
+}
+EXPORT_SYMBOL(gpio_get_value);
+
+void gpio_set_value(unsigned gpio, int on)
+{
+	int ret = -ENOTSUPP;
+	struct gpio_chip *chip;
+	unsigned long irq_flags;
+
+	spin_lock_irqsave(&gpio_chips_lock, irq_flags);
+	chip = get_gpio_chip_locked(gpio);
+	if (chip && chip->write)
+		ret = chip->write(chip, gpio, on);
+	spin_unlock_irqrestore(&gpio_chips_lock, irq_flags);
+}
+EXPORT_SYMBOL(gpio_set_value);
+
+int gpio_read_detect_status(unsigned int gpio)
+{
+	int ret = -ENOTSUPP;
+	struct gpio_chip *chip;
+	unsigned long irq_flags;
+
+	spin_lock_irqsave(&gpio_chips_lock, irq_flags);
+	chip = get_gpio_chip_locked(gpio);
+	if (chip && chip->read_detect_status)
+		ret = chip->read_detect_status(chip, gpio);
+	spin_unlock_irqrestore(&gpio_chips_lock, irq_flags);
+	return ret;
+}
+EXPORT_SYMBOL(gpio_read_detect_status);
+
+int gpio_clear_detect_status(unsigned int gpio)
+{
+	int ret = -ENOTSUPP;
+	struct gpio_chip *chip;
+	unsigned long irq_flags;
+
+	spin_lock_irqsave(&gpio_chips_lock, irq_flags);
+	chip = get_gpio_chip_locked(gpio);
+	if (chip && chip->clear_detect_status)
+		ret = chip->clear_detect_status(chip, gpio);
+	spin_unlock_irqrestore(&gpio_chips_lock, irq_flags);
+	return ret;
+}
+EXPORT_SYMBOL(gpio_clear_detect_status);
diff --git a/drivers/staging/dream/gpio_chip.h b/drivers/staging/dream/gpio_chip.h
new file mode 100644
index 0000000..eab9f09
--- /dev/null
+++ b/drivers/staging/dream/gpio_chip.h
@@ -0,0 +1,38 @@
+/* arch/arm/mach-msm/gpio_chip.h
+ *
+ * Copyright (C) 2007 Google, Inc.
+ *
+ * This software is licensed under the terms of the GNU General Public
+ * License version 2, as published by the Free Software Foundation, and
+ * may be copied, distributed, and modified under those terms.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ */
+
+#ifndef _LINUX_GPIO_CHIP_H
+#define _LINUX_GPIO_CHIP_H
+
+#include <linux/list.h>
+
+struct gpio_chip {
+	struct list_head list;
+	struct gpio_state *state;
+
+	unsigned int start;
+	unsigned int end;
+
+	int (*configure)(struct gpio_chip *chip, unsigned int gpio, unsigned long flags);
+	int (*get_irq_num)(struct gpio_chip *chip, unsigned int gpio, unsigned int *irqp, unsigned long *irqnumflagsp);
+	int (*read)(struct gpio_chip *chip, unsigned int gpio);
+	int (*write)(struct gpio_chip *chip, unsigned int gpio, unsigned on);
+	int (*read_detect_status)(struct gpio_chip *chip, unsigned int gpio);
+	int (*clear_detect_status)(struct gpio_chip *chip, unsigned int gpio);
+};
+
+int register_gpio_chip(struct gpio_chip *gpio_chip);
+
+#endif
diff --git a/drivers/staging/dream/gpio_hw.h b/drivers/staging/dream/gpio_hw.h
new file mode 100644
index 0000000..61f410c
--- /dev/null
+++ b/drivers/staging/dream/gpio_hw.h
@@ -0,0 +1,100 @@
+/* arch/arm/mach-msm/gpio_hw.h
+ *
+ * Copyright (C) 2007 Google, Inc.
+ * Author: Brian Swetland <swetland@google.com>
+ *
+ * This software is licensed under the terms of the GNU General Public
+ * License version 2, as published by the Free Software Foundation, and
+ * may be copied, distributed, and modified under those terms.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ */
+
+#ifndef __ARCH_ARM_MACH_MSM_GPIO_HW_H
+#define __ARCH_ARM_MACH_MSM_GPIO_HW_H
+
+#include <mach/msm_iomap.h>
+
+/* see 80-VA736-2 Rev C pp 695-751
+**
+** These are actually the *shadow* gpio registers, since the
+** real ones (which allow full access) are only available to the
+** ARM9 side of the world.
+**
+** Since the _BASE need to be page-aligned when we're mapping them
+** to virtual addresses, adjust for the additional offset in these
+** macros.
+*/
+
+#define GPIO1_REG(off) (MSM_GPIO1_BASE + 0x800 + (off))
+#define GPIO2_REG(off) (MSM_GPIO2_BASE + 0xC00 + (off))
+
+/* output value */
+#define GPIO_OUT_0         GPIO1_REG(0x00)  /* gpio  15-0  */
+#define GPIO_OUT_1         GPIO2_REG(0x00)  /* gpio  42-16 */
+#define GPIO_OUT_2         GPIO1_REG(0x04)  /* gpio  67-43 */
+#define GPIO_OUT_3         GPIO1_REG(0x08)  /* gpio  94-68 */
+#define GPIO_OUT_4         GPIO1_REG(0x0C)  /* gpio 106-95 */
+#define GPIO_OUT_5         GPIO1_REG(0x50)  /* gpio 107-121 */
+
+/* same pin map as above, output enable */
+#define GPIO_OE_0          GPIO1_REG(0x10)
+#define GPIO_OE_1          GPIO2_REG(0x08)
+#define GPIO_OE_2          GPIO1_REG(0x14)
+#define GPIO_OE_3          GPIO1_REG(0x18)
+#define GPIO_OE_4          GPIO1_REG(0x1C)
+#define GPIO_OE_5          GPIO1_REG(0x54)
+
+/* same pin map as above, input read */
+#define GPIO_IN_0          GPIO1_REG(0x34)
+#define GPIO_IN_1          GPIO2_REG(0x20)
+#define GPIO_IN_2          GPIO1_REG(0x38)
+#define GPIO_IN_3          GPIO1_REG(0x3C)
+#define GPIO_IN_4          GPIO1_REG(0x40)
+#define GPIO_IN_5          GPIO1_REG(0x44)
+
+/* same pin map as above, 1=edge 0=level interrup */
+#define GPIO_INT_EDGE_0    GPIO1_REG(0x60)
+#define GPIO_INT_EDGE_1    GPIO2_REG(0x50)
+#define GPIO_INT_EDGE_2    GPIO1_REG(0x64)
+#define GPIO_INT_EDGE_3    GPIO1_REG(0x68)
+#define GPIO_INT_EDGE_4    GPIO1_REG(0x6C)
+#define GPIO_INT_EDGE_5    GPIO1_REG(0xC0)
+
+/* same pin map as above, 1=positive 0=negative */
+#define GPIO_INT_POS_0     GPIO1_REG(0x70)
+#define GPIO_INT_POS_1     GPIO2_REG(0x58)
+#define GPIO_INT_POS_2     GPIO1_REG(0x74)
+#define GPIO_INT_POS_3     GPIO1_REG(0x78)
+#define GPIO_INT_POS_4     GPIO1_REG(0x7C)
+#define GPIO_INT_POS_5     GPIO1_REG(0xBC)
+
+/* same pin map as above, interrupt enable */
+#define GPIO_INT_EN_0      GPIO1_REG(0x80)
+#define GPIO_INT_EN_1      GPIO2_REG(0x60)
+#define GPIO_INT_EN_2      GPIO1_REG(0x84)
+#define GPIO_INT_EN_3      GPIO1_REG(0x88)
+#define GPIO_INT_EN_4      GPIO1_REG(0x8C)
+#define GPIO_INT_EN_5      GPIO1_REG(0xB8)
+
+/* same pin map as above, write 1 to clear interrupt */
+#define GPIO_INT_CLEAR_0   GPIO1_REG(0x90)
+#define GPIO_INT_CLEAR_1   GPIO2_REG(0x68)
+#define GPIO_INT_CLEAR_2   GPIO1_REG(0x94)
+#define GPIO_INT_CLEAR_3   GPIO1_REG(0x98)
+#define GPIO_INT_CLEAR_4   GPIO1_REG(0x9C)
+#define GPIO_INT_CLEAR_5   GPIO1_REG(0xB4)
+
+/* same pin map as above, 1=interrupt pending */
+#define GPIO_INT_STATUS_0  GPIO1_REG(0xA0)
+#define GPIO_INT_STATUS_1  GPIO2_REG(0x70)
+#define GPIO_INT_STATUS_2  GPIO1_REG(0xA4)
+#define GPIO_INT_STATUS_3  GPIO1_REG(0xA8)
+#define GPIO_INT_STATUS_4  GPIO1_REG(0xAC)
+#define GPIO_INT_STATUS_5  GPIO1_REG(0xB0)
+
+#endif

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html

----- End forwarded message -----

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
