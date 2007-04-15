Return-Path: <linux-kernel-owner+w=401wt.eu-S1753947AbXDOUzx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753947AbXDOUzx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Apr 2007 16:55:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753934AbXDOUz2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Apr 2007 16:55:28 -0400
Received: from smtp101.sbc.mail.mud.yahoo.com ([68.142.198.200]:26721 "HELO
	smtp101.sbc.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753932AbXDOUz0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Apr 2007 16:55:26 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=wU+Y7q1JM3L3o2IWsyRW/S84YxSXZF1bMKHIcRoICT0D4XlGzXrz6UQ/TT8/N3/1cdwY1L+5eWhpj2U2RAJGinqJDqZuYG0OkGV0EOrfueVsXyXav1bc4T9Dti6LfwjKzqMytpI6v3/u2dixCkKdegKqxH9kBGfAalp/tkXv+K4=  ;
X-YMail-OSG: hDcOHTsVM1njFq9oj4nB2Gp3L6GYlF2WNOnsvaK7.yEbRbHdcgddxO7T0yoNDqMcO_apXquIBw--
From: David Brownell <david-b@pacbell.net>
To: Paul Sokolovsky <pmiscml@gmail.com>
Subject: Re: is there any generic GPIO chip framework like IRQ chips?
Date: Sun, 15 Apr 2007 12:53:36 -0700
User-Agent: KMail/1.7.1
Cc: linux-arm-kernel@lists.arm.linux.org.uk, linux-kernel@vger.kernel.org
References: <f17812d70704090309l8dd764cxc06fbd7b765c55d8@mail.gmail.com> <200704102152.21287.david-b@pacbell.net> <1686019041.20070412165702@gmail.com>
In-Reply-To: <1686019041.20070412165702@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200704151253.37244.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch shows some almost-mergeable code matching $SUBJECT.

========	CUT HERE
Provide some implementation infrastructure that platforms may choose
to use when implementing the GPIO programming interface.

As previously discussed on LKML, this can be very desirable on some
platforms -- with GPIOs provided by non-SOC controllers -- but such
implementation choices are transparent to the driver interface.

When debugfs is available this provides an /sys/debug/gpio file showing
what GPIOs are available, and how the ones in use are configured.

Note that both OMAP and AVR32 implementations of the gpio_request() and
gpio_free() calls have additional features, which may be worth stealing.

Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
---
 Documentation/gpio.txt     |    4 
 include/asm-generic/gpio.h |   96 +++++++++++
 lib/Kconfig                |    6 
 lib/Makefile               |    2 
 lib/gpiolib.c              |  364 +++++++++++++++++++++++++++++++++++++++++++++
 5 files changed, 472 insertions(+), 2 deletions(-)

--- g26.orig/Documentation/gpio.txt	2007-04-14 19:51:00.000000000 -0700
+++ g26/Documentation/gpio.txt	2007-04-14 19:51:12.000000000 -0700
@@ -63,7 +63,9 @@ and that can be critical for glue logic.
 Plus, this doesn't define an implementation framework, just an interface.
 One platform might implement it as simple inline functions accessing chip
 registers; another might implement it by delegating through abstractions
-used for several very different kinds of GPIO controller.
+used for several very different kinds of GPIO controller.  (There is some
+library code supporting such an implementation strategy, but drivers using
+the interface should not care if that's how the interface is implemented.)
 
 That said, if the convention is supported on their platform, drivers should
 use it when possible:
--- g26.orig/lib/Kconfig	2007-04-14 19:51:00.000000000 -0700
+++ g26/lib/Kconfig	2007-04-14 19:51:12.000000000 -0700
@@ -111,4 +111,10 @@ config HAS_IOPORT
 	depends on HAS_IOMEM && !NO_IOPORT
 	default y
 
+#
+# gpiolib is selected if needed
+#
+config GPIO_LIB
+	boolean
+
 endmenu
--- g26.orig/include/asm-generic/gpio.h	2007-04-14 19:51:00.000000000 -0700
+++ g26/include/asm-generic/gpio.h	2007-04-15 10:58:19.000000000 -0700
@@ -1,6 +1,101 @@
 #ifndef _ASM_GENERIC_GPIO_H
 #define _ASM_GENERIC_GPIO_H
 
+#ifdef CONFIG_GPIO_LIB
+
+/* Platforms may implement their GPIO interface with library code,
+ * at the cost of performance for non-inlined operations.
+ */
+
+#ifndef ARCH_GPIOS_PER_CHIP
+#define ARCH_GPIOS_PER_CHIP	BITS_PER_LONG
+#endif
+
+/**
+ * struct gpio_chip - abstract a GPIO controller
+ * @get: retrieves value for a given gpio signal
+ * @set: assigns value for a given gpio signal
+ * @direction_input: assigns signal as input, or returns error code
+ * @direction_output: assigns assigns signal as output, or returns error code
+ * @base: identifies the first GPIO number handled by this chip
+ * @name: for use in diagnostics
+ * @irqs: to report optional coupling to the IRQ framework
+ * @irq_base: identifies the first IRQ handled by this chip
+ * @ngpio: the number of GPIOs handled by this controller; the value must
+ *	be at most ARCH_GPIOS_PER_CHIP, so the last GPIO handled is
+ *	(base + ngpio - 1).
+ * @can_sleep: flag must be set iff get()/set() methods sleep, as they
+ *	must while accessing GPIO expander chips over I2C or SPI
+ *
+ * A gpio_chip can help platforms abstract various sources of GPIOs so
+ * they can all be accessed through a common programing interface.
+ * Example sources would be SOC controllers, FPGAs, multifunction
+ * chips, dedicated GPIO expanders, and so on.
+ */
+struct gpio_chip {
+	int			(*get)(struct gpio_chip *chip,
+						unsigned offset);
+	void			(*set)(struct gpio_chip *chip,
+						unsigned offset, int value);
+	int			(*direction_input)(struct gpio_chip *chip,
+						unsigned offset);
+	int			(*direction_output)(struct gpio_chip *chip,
+						unsigned offset, int value);
+	unsigned		base;
+	const char		*name;
+	struct irq_desc		*irqs;
+	unsigned		irq_base;
+	u16			ngpio;
+	unsigned		can_sleep:1;
+
+	/* other fields are for the gpio library only */
+	struct list_head	chips;
+	unsigned long		is_out[DIV_ROUND_UP(ARCH_GPIOS_PER_CHIP,
+					BITS_PER_LONG)];
+#ifdef CONFIG_DEBUG_FS
+	/* fat bits */
+	const char		*requested[ARCH_GPIOS_PER_CHIP];
+#else
+	/* thin bits */
+	unsigned long		requested[DIV_ROUND_UP(ARCH_GPIOS_PER_CHIP,
+					BITS_PER_LONG)];
+#endif
+};
+
+/* Platform init code must declare each gpio chip. */
+extern int gpio_chip_declare(struct gpio_chip *chip);
+
+/* Platform may assign gpio_to_chip() hook to get something faster
+ * than the default (e.g. matching IRQ assignments).
+ */
+extern struct gpio_chip *(*gpio_to_chip)(unsigned gpio);
+
+
+/* Always use the library code for GPIO management calls,
+ * or when sleeping may be involved.
+ */
+extern int gpio_request(unsigned gpio, const char *label);
+extern void gpio_free(unsigned gpio);
+
+extern int gpio_direction_input(unsigned gpio);
+extern int gpio_direction_output(unsigned gpio, int value);
+
+extern int gpio_get_value_cansleep(unsigned gpio);
+extern void gpio_set_value_cansleep(unsigned gpio, int value);
+
+
+/* A platform's <asm/gpio.h> code may want to inline the I/O calls when
+ * the GPIO is constant and refers to some always-present controller,
+ * giving direct access to chip registers and tight bitbanging loops.
+ */
+extern int __gpio_get_value(unsigned gpio);
+extern void __gpio_set_value(unsigned gpio, int value);
+
+extern int __gpio_cansleep(unsigned gpio);
+
+
+#else
+
 /* platforms that don't directly support access to GPIOs through I2C, SPI,
  * or other blocking infrastructure can use these wrappers.
  */
@@ -22,4 +117,6 @@ static inline void gpio_set_value_cansle
 	gpio_set_value(gpio, value);
 }
 
+#endif
+
 #endif /* _ASM_GENERIC_GPIO_H */
--- g26.orig/lib/Makefile	2007-04-14 19:51:00.000000000 -0700
+++ g26/lib/Makefile	2007-04-14 19:51:12.000000000 -0700
@@ -60,6 +60,8 @@ obj-$(CONFIG_FAULT_INJECTION) += fault-i
 
 lib-$(CONFIG_GENERIC_BUG) += bug.o
 
+lib-$(CONFIG_GPIO_LIB) += gpiolib.o
+
 hostprogs-y	:= gen_crc32table
 clean-files	:= crc32table.h
 
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ g26/lib/gpiolib.c	2007-04-15 10:58:57.000000000 -0700
@@ -0,0 +1,364 @@
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/irq.h>
+
+#include <asm-generic/gpio.h>
+
+
+/*
+ * Platform code calls __gpio_*() routines when it can't inline a given
+ * GPIO call, and is using the gpio library infrastructure.  It must declare
+ * each gpio_chip during platform initialization, and may also choose to
+ * provide an optimized gpio_to_chip hook (e.g. the same linear mapping used
+ * to hook GPIOs into the IRQ framework)
+ */
+
+static DEFINE_SPINLOCK(chip_list_lock);
+static LIST_HEAD(chip_list);
+
+static struct gpio_chip *simple_to_chip(unsigned gpio)
+{
+	struct gpio_chip	*chip;
+
+	list_for_each_entry(chip, &chip_list, chips) {
+		if (gpio < chip->base || gpio >= (chip->base + chip->ngpio))
+			continue;
+		return chip;
+	}
+	return NULL;
+}
+
+static struct gpio_chip *default_to_chip(unsigned gpio)
+{
+	struct gpio_chip	*chip;
+	unsigned long		flags;
+
+	spin_lock_irqsave(&chip_list_lock, flags);
+	chip = simple_to_chip(gpio);
+	spin_unlock_irqrestore(&chip_list_lock, flags);
+	return chip;
+}
+
+struct gpio_chip *(*gpio_to_chip)(unsigned gpio) = default_to_chip;
+
+
+/**
+ * gpio_chip_declare - publish a gpio_chip to the infrastructure
+ * @chip: the chip
+ *
+ * Each GPIO controller needs to be published.  If it supports input
+ * pins, get() and direction_input() methods must be provided.  If it
+ * supports output pins, set() and direction_output() must be provided.
+ *
+ * Once declared, gpio chips are always available.
+ */
+int gpio_chip_declare(struct gpio_chip *chip)
+{
+	unsigned long		flags;
+
+	if (!chip || !(chip->set || chip->get) || !chip->ngpio)
+		return -EINVAL;
+	if (chip->set && !chip->direction_output)
+		return -EINVAL;
+	if (chip->get && !chip->direction_input)
+		return -EINVAL;
+	if (!chip->name)
+		chip->name = "generic";
+
+	spin_lock_irqsave(&chip_list_lock, flags);
+	if (simple_to_chip(chip->base + chip->ngpio - 1)
+			|| simple_to_chip(chip->base)) {
+		printk(KERN_ERR "GPIO: collision for '%s', %u..%u\n",
+				chip->name, chip->base,
+				chip->base + chip->ngpio - 1);
+		chip = NULL;
+	} else
+		list_add_tail(&chip->chips, &chip_list);
+	spin_unlock_irqrestore(&chip_list_lock, flags);
+
+	if (!chip)
+		return -EBUSY;
+
+	pr_debug("GPIO: added '%s' for %u..%u\n", chip->name,
+			chip->base, chip->base + chip->ngpio - 1);
+	return 0;
+}
+
+
+/* These "optional" allocation calls help prevent drivers from stomping
+ * on each other, and help provide better diagnostics in debugfs.
+ */
+int gpio_request(unsigned gpio, const char *label)
+{
+	struct gpio_chip	*chip = gpio_to_chip(gpio);
+	unsigned long		flags;
+	int			status = 0;
+
+	if (!chip || gpio < chip->base)
+		return -EINVAL;
+
+	gpio -= chip->base;
+	if (gpio >= chip->ngpio)
+		return -EINVAL;
+
+	if (!label)
+		label = "?";
+
+	spin_lock_irqsave(&chip_list_lock, flags);
+#ifdef CONFIG_DEBUG_FS
+	if (chip->requested[gpio])
+		status = -EBUSY;
+	else
+		chip->requested[gpio] = label;
+#else
+	if (test_and_set_bit(gpio, chip->requested))
+		status = -EBUSY;
+#endif
+	spin_unlock_irqrestore(&chip_list_lock, flags);
+	return status;
+}
+EXPORT_SYMBOL(gpio_request);
+
+void gpio_free(unsigned gpio)
+{
+	struct gpio_chip	*chip = gpio_to_chip(gpio);
+	unsigned long		flags;
+
+	if (!chip || gpio < chip->base)
+		return;
+	gpio -= chip->base;
+	if (gpio >= chip->ngpio)
+		return;
+
+	spin_lock_irqsave(&chip_list_lock, flags);
+#ifdef CONFIG_DEBUG_FS
+	if (!chip->requested[gpio])
+		chip = NULL;
+	else
+		chip->requested[gpio] = NULL;
+#else
+	if (!test_and_clear_bit(gpio, chip->requested))
+		chip = NULL;
+#endif
+	spin_unlock_irqrestore(&chip_list_lock, flags);
+	WARN_ON(chip == NULL);
+}
+EXPORT_SYMBOL(gpio_free);
+
+
+/* Drivers MUST make configuration calls before get/set calls */
+
+int gpio_direction_input(unsigned gpio)
+{
+	struct gpio_chip	*chip = gpio_to_chip(gpio);
+	int			status;
+
+	might_sleep();
+	if (!chip || !chip->direction_input || !chip->get || gpio < chip->base)
+		return -EINVAL;
+	gpio -= chip->base;
+	if (gpio >= chip->ngpio)
+		return -EINVAL;
+
+	status = chip->direction_input(chip, gpio);
+	if (status == 0)
+		clear_bit(gpio, chip->is_out);
+	return status;
+}
+EXPORT_SYMBOL(gpio_direction_input);
+
+int gpio_direction_output(unsigned gpio, int value)
+{
+	struct gpio_chip	*chip = gpio_to_chip(gpio);
+	int			status;
+
+	might_sleep();
+	if (!chip || !chip->direction_output || !chip->set || gpio < chip->base)
+		return -EINVAL;
+	gpio -= chip->base;
+	if (gpio >= chip->ngpio)
+		return -EINVAL;
+
+	status = chip->direction_output(chip, gpio, value);
+	if (status == 0)
+		set_bit(gpio, chip->is_out);
+	return status;
+}
+EXPORT_SYMBOL(gpio_direction_output);
+
+
+/* I/O calls are only valid after configuration completed;
+ * the relevant error checks have already been done.
+ *
+ * "Get" operations are often inlinable as reading a pin value register,
+ * and masking the relevant bit in that register.
+ *
+ * When "set" operations are inlinable, they involve writing that mask to
+ * one register to set a low value, or a different register to set it high.
+ * Otherwise a spinlock is needed, and there's little value to inlining.
+ */
+int __gpio_get_value(unsigned gpio)
+{
+	struct gpio_chip *chip = gpio_to_chip(gpio);
+
+	WARN_ON(chip->can_sleep != 0);
+	return chip->get(chip, gpio - chip->base);
+}
+EXPORT_SYMBOL(__gpio_get_value);
+
+void __gpio_set_value(unsigned gpio, int value)
+{
+	struct gpio_chip *chip = gpio_to_chip(gpio);
+
+	WARN_ON(chip->can_sleep != 0);
+	return chip->set(chip, gpio - chip->base, value);
+}
+EXPORT_SYMBOL(__gpio_set_value);
+
+int __gpio_cansleep(unsigned gpio)
+{
+	struct gpio_chip *chip = gpio_to_chip(gpio);
+
+	return chip->can_sleep;
+}
+EXPORT_SYMBOL(__gpio_cansleep);
+
+
+/* There's no value in inlining GPIO calls that may sleep */
+
+int gpio_get_value_cansleep(unsigned gpio)
+{
+	struct gpio_chip *chip = gpio_to_chip(gpio);
+
+	might_sleep();
+	return chip->get(chip, gpio - chip->base);
+}
+EXPORT_SYMBOL(gpio_get_value_cansleep);
+
+void gpio_set_value_cansleep(unsigned gpio, int value)
+{
+	struct gpio_chip *chip = gpio_to_chip(gpio);
+
+	might_sleep();
+	return chip->set(chip, gpio - chip->base, value);
+}
+EXPORT_SYMBOL(gpio_set_value_cansleep);
+
+
+#ifdef CONFIG_DEBUG_FS
+
+/*
+ * When debugfs is available, use it to dump a summary of the
+ * GPIO signals currently used, and their status.
+ */
+
+#include <linux/debugfs.h>
+#include <linux/seq_file.h>
+
+static int dbg_gpio_show(struct seq_file *s, void *unused)
+{
+	struct gpio_chip	*chip;
+
+	list_for_each_entry(chip, &chip_list, chips) {
+		unsigned	offset;
+		const char	*name = NULL;
+
+		for (offset = 0; offset < chip->ngpio; offset++) {
+			unsigned	gpio;
+			unsigned	value, is_out;
+
+			if (!chip->requested[offset])
+				continue;
+
+			/* Show each irq bank separately */
+			if (!name) {
+				name = chip->name;
+				seq_printf(s,
+					"Controller: %s, %u..%d%s%s\n",
+					name, chip->base,
+					chip->base + chip->ngpio - 1,
+					chip->irqs ? ", irqs" : "",
+					chip->can_sleep ? ", can sleep" : "");
+			}
+
+			/* Dump basic per-GPIO status */
+			gpio = chip->base + offset;
+			is_out = test_bit(offset, chip->is_out);
+			value = chip->get ? chip->get(chip, offset) : 0;
+			seq_printf(s, "  GPIO %3u (%2u): %s %s (%10s)",
+					gpio, offset,
+					is_out ? "out" : "in ",
+					value  ? "hi"  : "lo",
+					chip->requested[offset]);
+
+			/* For GPIOs used as IRQs, dump more status.  Wakeup
+			 * is often set only between suspend() and resume().
+			 */
+			if (!is_out && chip->irqs) {
+				struct irq_desc	*irq = chip->irqs + offset;
+
+				if (irq->action) {
+					char		*trigger;
+					unsigned	stat;
+
+					stat = irq->status;
+					switch (stat & IRQ_TYPE_SENSE_MASK) {
+					case IRQ_TYPE_EDGE_FALLING:
+						trigger = "falling";
+						break;
+					case IRQ_TYPE_EDGE_RISING:
+						trigger = "rising";
+						break;
+					case IRQ_TYPE_EDGE_BOTH:
+						trigger = "bothedge";
+						break;
+					case IRQ_TYPE_LEVEL_LOW:
+						trigger = "low";
+						break;
+					case IRQ_TYPE_LEVEL_HIGH:
+						trigger = "high";
+						break;
+					default:
+						trigger = "?";
+						break;
+					}
+					seq_printf(s,
+						", IRQ %3d/%s%s",
+						chip->irq_base + offset,
+						trigger,
+						(stat & IRQ_WAKEUP)
+							? " wakeup"
+							: "");
+				}
+			}
+
+			seq_printf(s, "\n");
+		}
+
+		if (name)
+			seq_printf(s, "\n");
+	}
+	return 0;
+}
+
+static int dbg_gpio_open(struct inode *inode, struct file *file)
+{
+	return single_open(file, dbg_gpio_show, &inode->i_private);
+}
+
+static const struct file_operations debug_fops = {
+	.open		= dbg_gpio_open,
+	.read		= seq_read,
+	.llseek		= seq_lseek,
+	.release	= single_release,
+};
+
+static int __init gpiolib_debuginit(void)
+{
+	(void) debugfs_create_file("gpio", S_IRUGO, NULL, NULL, &debug_fops);
+	return 0;
+}
+subsys_initcall(gpiolib_debuginit);
+
+#endif
+
