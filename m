Return-Path: <linux-kernel-owner+w=401wt.eu-S1758603AbYDDCIa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758603AbYDDCIa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Apr 2008 22:08:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751861AbYDDCIU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Apr 2008 22:08:20 -0400
Received: from az33egw01.freescale.net ([192.88.158.102]:51918 "EHLO
	az33egw01.freescale.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751457AbYDDCIT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Apr 2008 22:08:19 -0400
Date: Thu, 3 Apr 2008 19:06:27 -0700 (PDT)
From: Trent Piepho <tpiepho@freescale.com>
X-X-Sender: xyzzy@t2.domain.actdsltmp
To: David Brownell <david-b@pacbell.net>
cc: Jean Delvare <khali@linux-fr.org>,
       Linux Kernel list <linux-kernel@vger.kernel.org>
Subject: Re: [patch/rfc 2/4] pcf875x I2C GPIO expander driver
In-Reply-To: <200711301259.22666.david-b@pacbell.net>
Message-ID: <Pine.LNX.4.64.0804031844500.11928@t2.domain.actdsltmp>
References: <200710291809.29936.david-b@pacbell.net> <200711301040.54777.david-b@pacbell.net>
 <20071130211332.49a21a6b@hyperion.delvare> <200711301259.22666.david-b@pacbell.net>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 30 Nov 2007, David Brownell wrote:
> On Friday 30 November 2007, Jean Delvare wrote:
>>
>> So the user-space interface would be part of the generic GPIO
>> infrastructure? I like the idea.
>
> I thought that would make sense too! :)  Someone would need to
> write the code though.  Having such a mechanism would provide
> another "carrot" to migrate folk towards the gpiolib core.

Here's some code to do this.  It's not entirely perfect yet, but it is
usable.  I create a directory in sysfs (class/gpio/<name>:<num>) for each
gpio line.  The are files in this directory to allow reading/setting the
gpio value and direction.  One can also see the label associated with the
gpio if gpiolib is keeping track of labels (i.e.  debugfs is on).  sysfs
also creates a gpio directory under the device associated with the gpio
lines (this is a new thing one needs to add) with that device's gpios. 
Actually, think these are "real" sysfs directories, and the ones in
/sys/class are copies made by sysfs.

----------------------------------------------------------------------------
>From c65d0fb239b79de7f595e47edb2fb641217e7309 Mon Sep 17 00:00:00 2001
From: Trent Piepho <tpiepho@freescale.com>
Date: Thu, 3 Apr 2008 18:37:23 -0700
Subject: GPIO: Create a sysfs gpio class for messing with GPIOs from userspace

struct gpio_chip gets a new field, dev, which points to the struct device
of whatever the gpio lines are part of.  If this is non-NULL, gpio class
entries are created for this device when gpiochip_add() is called, by a new
function gpiochip_classdev_register().

It creates a sysfs directory for each gpio the chip defines.  Each device
has three attributes so far, direction, value, and label.  label is
read-only, and will only be present if DEBUG_FS is on, as without DEBUG_FS
the gpio layer doesn't keep track of any labels.

Maybe the value file should be changed to RO or WO depending on direction?

Setting the direction auto-allocates the gpio, which is not really what I
wanted.  Maybe I should call the chip set method directly?

There are almost certainly a bunch of races with gpio_desc access.

No code has been written yet to remove the devices from the class when the
class is removed.

The GPIO_CLASS define/ifdef code should either be removed, or turned into a
Kconfig variable that can be used turn this feature on and off.

Signed-off-by: Trent Piepho <tpiepho@freescale.com>
---
  drivers/gpio/gpiolib.c     |  188 ++++++++++++++++++++++++++++++++++++++++++++
  include/asm-generic/gpio.h |    2 +
  2 files changed, 190 insertions(+), 0 deletions(-)

diff --git a/drivers/gpio/gpiolib.c b/drivers/gpio/gpiolib.c
index d8db2f8..db0677d 100644
--- a/drivers/gpio/gpiolib.c
+++ b/drivers/gpio/gpiolib.c
@@ -18,6 +18,7 @@
   * only an instruction or two per bit.
   */

+#define GPIO_CLASS	1

  /* When debugging, extend minimal trust to callers and platform code.
   * Also emit diagnostic messages that may help initial bringup, when
@@ -47,6 +48,9 @@ struct gpio_desc {
  #ifdef CONFIG_DEBUG_FS
  	const char		*label;
  #endif
+#if GPIO_CLASS
+	struct device		*dev;
+#endif
  };
  static struct gpio_desc gpio_desc[ARCH_NR_GPIOS];

@@ -57,6 +61,174 @@ static inline void desc_set_label(struct gpio_desc *d, const char *label)
  #endif
  }

+#if GPIO_CLASS
+#include <linux/device.h>
+#include <linux/string.h>
+#include <linux/ctype.h>
+#include <linux/err.h>
+
+static struct class *gpio_class;
+
+static ssize_t gpio_direction_show(struct device *dev,
+		struct device_attribute *attr, char *buf)
+{
+	const struct gpio_desc *gdesc = dev_get_drvdata(dev);
+
+	strcpy(buf, test_bit(FLAG_IS_OUT, &gdesc->flags) ? "out\n" : "in\n\0");
+
+	return 5;
+}
+
+static ssize_t gpio_direction_store(struct device *dev,
+		struct device_attribute *attr, const char *buf, size_t size)
+{
+	const struct gpio_desc *gdesc = dev_get_drvdata(dev);
+	int d, n = gdesc - gpio_desc;
+
+	if (size >= 3 && !strncmp(buf, "out", 3)) {
+		d = 1;
+	} else if (size >= 2 && !strncmp(buf, "in", 2)) {
+		d = 0;
+	} else {
+		d = simple_strtoul(buf, NULL, 0);
+	}
+
+	if (d)
+		gpio_direction_output(n, 0);
+	else
+		gpio_direction_input(n);
+
+	return size;
+}
+
+static DEVICE_ATTR(direction, 0644, gpio_direction_show, gpio_direction_store);
+
+static ssize_t gpio_value_show(struct device *dev,
+			       struct device_attribute *attr, char *buf)
+{
+	const struct gpio_desc *gdesc = dev_get_drvdata(dev);
+	int n = gdesc - gpio_desc;
+
+	if (test_bit(FLAG_IS_OUT, &gdesc->flags)) {
+		return -EINVAL;
+		/* strcpy(buf, "-1\n"); return 4; */ /* Or this? */
+	}
+	return sprintf(buf, "%d\n", gpio_get_value(n)) + 1;
+}
+
+static ssize_t gpio_value_store(struct device *dev,
+		struct device_attribute *attr, const char *buf, size_t size)
+{
+	const struct gpio_desc *gdesc = dev_get_drvdata(dev);
+	int v, n = gdesc - gpio_desc;
+
+	if (!test_bit(FLAG_IS_OUT, &gdesc->flags))
+		return -EINVAL;
+
+	v = simple_strtoul(buf, NULL, 0);
+	gpio_set_value(n, v);
+
+	return size;
+}
+
+static DEVICE_ATTR(value, 0644, gpio_value_show, gpio_value_store);
+
+#ifdef CONFIG_DEBUG_FS
+static ssize_t gpio_label_show(struct device *dev,
+			       struct device_attribute *attr, char *buf)
+{
+	const struct gpio_desc *gdesc = dev_get_drvdata(dev);
+
+	if (!gdesc->label) {
+		strcpy(buf, "free\n");
+		return 6;
+	} else
+		return sprintf(buf, "%s\n", gdesc->label) + 1;
+}
+
+static DEVICE_ATTR(label, 0444, gpio_label_show, NULL);
+#endif
+
+static int gpiochip_classdev_register(const struct gpio_chip *chip)
+{
+	int ret, i;
+	struct gpio_desc *gdesc;
+
+	BUG_ON(!chip->dev);
+
+	for (i = chip->base; i < chip->base + chip->ngpio; i++) {
+		gdesc = gpio_desc + i;
+		gdesc->dev = device_create(gpio_class, chip->dev, 0, "%s:%d",
+					   chip->label, i);
+		if (IS_ERR(gdesc->dev)) {
+			ret = PTR_ERR(gdesc->dev);
+			i--;
+			goto fail;
+		}
+
+		dev_set_drvdata(gdesc->dev, gdesc);
+
+		ret = device_create_file(gdesc->dev, &dev_attr_direction);
+		if (ret)
+			goto fail_dev;
+		ret = device_create_file(gdesc->dev, &dev_attr_value);
+		if (ret)
+			goto fail_dir;
+#ifdef CONFIG_DEBUG_FS
+		ret = device_create_file(gdesc->dev, &dev_attr_label);
+		if (ret)
+			goto fail_value;
+#endif
+	}
+	return 0;
+
+fail:
+	for (; i >= chip->base; i--) {
+		gdesc = gpio_desc + i;
+
+#ifdef CONFIG_DEBUG_FS
+		device_remove_file(gdesc->dev, &dev_attr_label);
+
+fail_value:
+#endif
+		device_remove_file(gdesc->dev, &dev_attr_value);
+
+fail_dir:
+		device_remove_file(gdesc->dev, &dev_attr_direction);
+
+fail_dev:
+		device_unregister(gdesc->dev);
+		gdesc->dev = NULL;
+	}
+	return ret;
+}
+
+static int __init gpio_class_init(void)
+{
+	gpio_class = class_create(THIS_MODULE, "gpio");
+	if (IS_ERR(gpio_class))
+		return PTR_ERR(gpio_class);
+	return 0;
+}
+
+static void __exit gpio_class_exit(void)
+{
+	/* FIXME:  Code to remove all the sysfs devices and files created
+	 * should go here */
+	class_destroy(gpio_class);
+}
+subsys_initcall(gpio_class_init);
+module_exit(gpio_class_exit);
+
+#else /* no class */
+
+/* I coulda been a contender, I coulda had class... */
+static inline int gpiochip_classdev_register(const struct gpio_chip *chip)
+{ return 0; }
+
+#endif
+
+
  /* Warn when drivers omit gpio_request() calls -- legal but ill-advised
   * when setting direction, and otherwise illegal.  Until board setup code
   * and drivers use explicit requests everywhere (which won't happen when
@@ -118,6 +290,22 @@ int gpiochip_add(struct gpio_chip *chip)
  	}

  	spin_unlock_irqrestore(&gpio_lock, flags);
+
+	if (status)
+		goto fail;
+
+	if (chip->dev) {
+		/* can sleep, so can't call with the spinlock held */
+		status = gpiochip_classdev_register(chip);
+		if (status) {
+			/* De-allocate GPIOs */
+			spin_lock_irqsave(&gpio_lock, flags);
+			for (id = chip->base; id < chip->base + chip->ngpio; id++)
+				gpio_desc[id].chip = NULL;
+			spin_unlock_irqrestore(&gpio_lock, flags);
+		}
+	}
+
  fail:
  	/* failures here can mean systems won't boot... */
  	if (status)
diff --git a/include/asm-generic/gpio.h b/include/asm-generic/gpio.h
index f29a502..b2a5262 100644
--- a/include/asm-generic/gpio.h
+++ b/include/asm-generic/gpio.h
@@ -29,6 +29,7 @@ struct seq_file;
   * @dbg_show: optional routine to show contents in debugfs; default code
   *	will be used when this is omitted, but custom code can show extra
   *	state (such as pullup/pulldown configuration).
+ * @dev: optional device for the GPIO chip.  Used to create sysfs files.
   * @base: identifies the first GPIO number handled by this chip; or, if
   *	negative during registration, requests dynamic ID allocation.
   * @ngpio: the number of GPIOs handled by this controller; the last GPIO
@@ -59,6 +60,7 @@ struct gpio_chip {
  						unsigned offset, int value);
  	void			(*dbg_show)(struct seq_file *s,
  						struct gpio_chip *chip);
+	struct device		*dev;
  	int			base;
  	u16			ngpio;
  	unsigned		can_sleep:1;
-- 
1.5.4.1

