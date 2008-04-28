Return-Path: <linux-kernel-owner+w=401wt.eu-S937211AbYD1Tkb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937211AbYD1Tkb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2008 15:40:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S936909AbYD1TkB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Apr 2008 15:40:01 -0400
Received: from smtp118.sbc.mail.sp1.yahoo.com ([69.147.64.91]:23645 "HELO
	smtp118.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S936689AbYD1Tjz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2008 15:39:55 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=UJykRbASlNfQdlS0Dpoj/f0IP8IUL0sU5x6dNjjxcuQRQageUg1ZWIHtYOyhmfWFIV+ChAeji8jTl5n6iuiXZYEcT+GJUmYSsxYVZ93wZS0Tn7yWundq8HyPRkCQuen/fZRbQ5toUFRRrAFyS+Pb+7FUv5gz67n2b3FvaIWDUJQ=  ;
X-YMail-OSG: K0xsvm0VM1n10DeilLZDVFHXgUom0THoy0ucXqYfwjbTsIj_qcf3RMFrrRP8KnwavckAbjg1GvBxaanl4U65evyK75sl8Yli1r421V_EgXUz1T1tEojc5TaebnoBxnmdfkg-
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: lkml <linux-kernel@vger.kernel.org>
Subject: [patch/rfc 2.6.25-git] gpio: sysfs interface
Date: Mon, 28 Apr 2008 12:39:51 -0700
User-Agent: KMail/1.9.6
Cc: Trent Piepho <tpiepho@freescale.com>,
       hartleys <hartleys@visionengravers.com>,
       Ben Nizette <bn@niasdigital.com>, Mike Frysinger <vapier.adi@gmail.com>,
       Bryan Wu <cooloney@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200804281239.51729.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Simple sysfs interface for GPIOs.

    /sys/class/gpio
        /gpio-N ... for each exported GPIO #N
	    /value ... always readable, writes fail except for output GPIOs
	    /direction ... writable as: in, out (default low), high, low
    	/control ... to request a GPIO be exported or unexported

GPIOs may be exported by kernel code using gpio_export(), which should
be most useful for driver debugging.  Userspace may also ask that they
be exported by writing to the sysfs control file, helping to cope with
incomplete board support:

  echo "export 23" > /sys/class/gpio/control
	... will gpio_request(23, "sysfs") and gpio_export(23); use
	/sys/class/gpio/gpio-23/direction to configure it.
  echo "unexport 23" > /sys/class/gpio/control
	... will gpio_free(23)

The D-space footprint is negligible, except for the sysfs resources
associated with each exported GPIO.  The additional I-space footprint
is about half of the current size of gpiolib.  No /dev node creation
involved, and no "udev" support is needed.

This adds a device pointer to "struct gpio_chip".  When GPIO providers
initialize that, sysfs gpio class devices become children of that device
instead of being "virtual" devices.  The (few) gpio_chip providers which
have such a device node have been updated.  (Some also needed to update
their module "owner" field ... for which missing kerneldoc was added.)

Based on a patch from Trent Piepho <tpiepho@freescale.com>, and comments
from various folk including Hartley Sweeten.

Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
---
 arch/avr32/mach-at32ap/pio.c |    2 
 drivers/gpio/Kconfig         |   16 ++
 drivers/gpio/gpiolib.c       |  281 +++++++++++++++++++++++++++++++++++++++++++
 drivers/gpio/mcp23s08.c      |    1 
 drivers/gpio/pca953x.c       |    1 
 drivers/gpio/pcf857x.c       |    1 
 drivers/i2c/chips/tps65010.c |    2 
 drivers/mfd/htc-egpio.c      |    2 
 include/asm-generic/gpio.h   |   28 ++++
 9 files changed, 333 insertions(+), 1 deletion(-)

--- g26.orig/arch/avr32/mach-at32ap/pio.c	2008-04-28 11:11:07.000000000 -0700
+++ g26/arch/avr32/mach-at32ap/pio.c	2008-04-28 11:31:21.000000000 -0700
@@ -358,6 +358,8 @@ static int __init pio_probe(struct platf
 	pio->chip.label = pio->name;
 	pio->chip.base = pdev->id * 32;
 	pio->chip.ngpio = 32;
+	pio->chip.dev = &pdev->dev;
+	pio->chip.owner = THIS_MODULE;
 
 	pio->chip.direction_input = direction_input;
 	pio->chip.get = gpio_get;
--- g26.orig/drivers/gpio/Kconfig	2008-04-28 11:11:08.000000000 -0700
+++ g26/drivers/gpio/Kconfig	2008-04-28 11:46:57.000000000 -0700
@@ -23,6 +23,22 @@ config DEBUG_GPIO
 	  slower.  The diagnostics help catch the type of setup errors
 	  that are most common when setting up new platforms or boards.
 
+config GPIO_SYSFS
+	bool "/sys/class/gpio/... (EXPERIMENTAL sysfs interface)"
+	depends on SYSFS && EXPERIMENTAL
+	help
+	  Say Y here to add a sysfs interface for GPIOs.
+
+	  This is mostly useful to work around omissions in a system's
+	  kernel support.  Those are common in custom and semicustom
+	  hardware assembled using standard kernels with a minimum of
+	  custom patches.  In those cases, userspace code may ask that
+	  a given GPIO be exported, if no kernel driver requested it.
+
+	  Kernel drivers may also request that a particular GPIO be
+	  made available to userspace as well as that driver.  This
+	  can be useful when debugging.
+
 # put expanders in the right section, in alphabetical order
 
 comment "I2C GPIO expanders:"
--- g26.orig/drivers/gpio/gpiolib.c	2008-04-28 11:17:42.000000000 -0700
+++ g26/drivers/gpio/gpiolib.c	2008-04-28 11:40:36.000000000 -0700
@@ -44,6 +44,8 @@ struct gpio_desc {
 #define FLAG_REQUESTED	0
 #define FLAG_IS_OUT	1
 #define FLAG_RESERVED	2
+#define FLAG_EXPORT	3
+#define FLAG_SYSFS	4
 
 #ifdef CONFIG_DEBUG_FS
 	const char		*label;
@@ -286,6 +288,283 @@ done:
 }
 EXPORT_SYMBOL_GPL(gpio_request);
 
+
+#ifdef CONFIG_GPIO_SYSFS
+
+/*
+ * /sys/class/gpio/gpio-N/... only for GPIOs that are exported
+ *  - direction
+ *      * is read/write as in/out
+ *      * may also be written as high/low, initializing output
+ *        value as specified (plain "out" implies "low")
+ *  - value
+ *      * always readable, subject to hardware behavior
+ *      * may be writable, as zero/nonzero
+ */
+
+#include <linux/device.h>
+#include <linux/err.h>
+
+static ssize_t gpio_direction_show(struct device *dev,
+		struct device_attribute *attr, char *buf)
+{
+	const struct gpio_desc	*desc = dev_get_drvdata(dev);
+
+	/* handle GPIOs being removed from underneath us... */
+	if (!test_bit(FLAG_EXPORT, &desc->flags))
+		return -EIO;
+
+	return sprintf(buf, "%s\n",
+		test_bit(FLAG_IS_OUT, &desc->flags) ? "out" : "in");
+}
+
+static ssize_t gpio_direction_store(struct device *dev,
+		struct device_attribute *attr, const char *buf, size_t size)
+{
+	const struct gpio_desc	*desc = dev_get_drvdata(dev);
+	unsigned		gpio = desc - gpio_desc;
+	unsigned		len = size;
+	ssize_t			status = -EINVAL;
+
+	/* handle GPIOs being removed from underneath us... */
+	if (!test_bit(FLAG_EXPORT, &desc->flags))
+		return -EIO;
+
+	if (buf[len - 1] == '\n')
+		len--;
+
+	if (len == 4 && strncmp(buf, "high", 4) == 0)
+		status = gpio_direction_output(gpio, 1);
+
+	else if (len == 3 && (strncmp(buf, "out", 3) == 0
+			|| strncmp(buf, "low", 3) == 0))
+		status = gpio_direction_output(gpio, 0);
+
+	else if (len == 2 && strncmp(buf, "in", 2) == 0)
+		status = gpio_direction_input(gpio);
+
+	return (status < 0) ? status : size;
+}
+
+static const DEVICE_ATTR(direction, 0644, gpio_direction_show, gpio_direction_store);
+
+static ssize_t gpio_value_show(struct device *dev,
+		struct device_attribute *attr, char *buf)
+{
+	const struct gpio_desc	*desc = dev_get_drvdata(dev);
+	unsigned		gpio = desc - gpio_desc;
+
+	/* handle GPIOs being removed from underneath us... */
+	if (!test_bit(FLAG_EXPORT, &desc->flags))
+		return -EIO;
+
+	return sprintf(buf, "%d\n", gpio_get_value_cansleep(gpio));
+}
+
+static ssize_t gpio_value_store(struct device *dev,
+		struct device_attribute *attr, const char *buf, size_t size)
+{
+	const struct gpio_desc	*desc = dev_get_drvdata(dev);
+	unsigned		gpio = desc - gpio_desc;
+	long			value;
+	int			ret;
+
+	/* handle GPIOs being removed from underneath us... */
+	if (!test_bit(FLAG_EXPORT, &desc->flags))
+		return -EIO;
+
+	if (!test_bit(FLAG_IS_OUT, &desc->flags))
+		return -EINVAL;
+
+	ret = strict_strtol(buf, 0, &value);
+	if (ret < 0)
+		return ret;
+	gpio_set_value_cansleep(gpio, value != 0);
+	return size;
+}
+
+static const DEVICE_ATTR(value, 0644, gpio_value_show, gpio_value_store);
+
+static const struct attribute *gpio_attrs[] = {
+	&dev_attr_direction.attr,
+	&dev_attr_value.attr,
+	NULL,
+};
+
+static const struct attribute_group gpio_attr_group = {
+	.attrs = (struct attribute **) gpio_attrs,
+};
+
+static struct class *gpio_class;
+
+/**
+ * gpio_export - export a GPIO through sysfs
+ * @gpio: gpio to make available, already requested
+ *
+ * When drivers want to make a GPIO accessible to userspace after they
+ * have requested it -- perhaps while debugging, or as part of their
+ * public interface -- they may use this routine.
+ *
+ * Returns zero on success, else an error.
+ */
+int gpio_export(unsigned gpio)
+{
+	unsigned long		flags;
+	struct gpio_desc	*desc;
+	int			status = -EINVAL;
+
+	if (!gpio_class)
+		return -ENOSYS;
+
+	if (!gpio_is_valid(gpio))
+		return -EINVAL;
+
+	/* REVISIT mode param to say if it direction may be changed */
+
+	spin_lock_irqsave(&gpio_lock, flags);
+	desc = &gpio_desc[gpio];
+	if (test_bit(FLAG_REQUESTED, &desc->flags)
+			&& !test_bit(FLAG_EXPORT, &desc->flags))
+		status = 0;
+	spin_unlock_irqrestore(&gpio_lock, flags);
+
+	if (status)
+		pr_debug("%s: gpio-%d status %d\n", __func__, gpio, status);
+	else {
+		struct device	*dev;
+
+		dev = device_create(gpio_class, desc->chip->dev, 0,
+				"gpio-%d", gpio);
+		if (dev) {
+			dev_set_drvdata(dev, desc);
+			status = sysfs_create_group(&dev->kobj,
+					&gpio_attr_group);
+		}
+		if (status == 0)
+			set_bit(FLAG_EXPORT, &desc->flags);
+	}
+
+	return status;
+}
+EXPORT_SYMBOL_GPL(gpio_export);
+
+static int match_export(struct device *dev, void *data)
+{
+	return dev_get_drvdata(dev) == data;
+}
+
+/**
+ * gpio_unexport - reverse effect of gpio_export()
+ * @gpio: gpio to make unavailable
+ *
+ * This is implicit on gpio_free().
+ */
+void gpio_unexport(unsigned gpio)
+{
+	unsigned long		flags;
+	struct gpio_desc	*desc;
+	int			status = -EINVAL;
+
+	if (!gpio_is_valid(gpio))
+		return;
+
+	spin_lock_irqsave(&gpio_lock, flags);
+	desc = &gpio_desc[gpio];
+	if (test_bit(FLAG_EXPORT, &desc->flags))
+		status = 0;
+	spin_unlock_irqrestore(&gpio_lock, flags);
+
+	if (status == 0) {
+		struct device	*dev = NULL;
+
+		dev = class_find_device(gpio_class, desc, match_export);
+		if (dev) {
+			clear_bit(FLAG_EXPORT, &desc->flags);
+			put_device(dev);
+			device_unregister(dev);
+		}
+	}
+
+}
+EXPORT_SYMBOL_GPL(gpio_unexport);
+
+/*
+ * /sys/class/gpio/control ... write-only
+ *	export N
+ *	unexport N
+ */
+static ssize_t control_store(struct class *class, const char *buf, size_t len)
+{
+	char *scratch = (char *)buf;
+	char *cmd, *tmp;
+	int status;
+	unsigned long gpio;
+
+	/* export/unexport */
+	cmd = strsep(&scratch, " \t\n");
+	if (!cmd)
+		goto fail;
+
+	/* N */
+	tmp = strsep(&scratch, " \t\n");
+	if (!tmp)
+		goto fail;
+	status = strict_strtoul(tmp, 0, &gpio);
+	if (status < 0)
+		goto done;
+
+	/* reject commands with garbage at end */
+	tmp = strsep(&scratch, " \t\n");
+	if ((tmp && *tmp) || scratch)
+		goto fail;
+
+	if (strcmp(cmd, "export") == 0) {
+		status = gpio_request(gpio, "sysfs");
+		if (status < 0)
+			goto done;
+
+		status = gpio_export(gpio);
+		if (status < 0)
+			gpio_free(gpio);
+		else
+			set_bit(FLAG_SYSFS, &gpio_desc[gpio].flags);
+
+	} else if (strcmp(cmd, "unexport") == 0) {
+		/* reject bogus commands (gpio_unexport ignores them) */
+		if (!gpio_is_valid(gpio))
+			goto fail;
+		if (!test_and_clear_bit(FLAG_SYSFS, &gpio_desc[gpio].flags))
+			goto fail;
+
+		gpio_free(gpio);
+	}
+done:
+	return (status < 0) ? status : len;
+fail:
+	return -EINVAL;
+}
+
+static CLASS_ATTR(control, 0200, NULL, control_store);
+
+static int __init gpiolib_sysfs_init(void)
+{
+	int	status;
+
+	gpio_class = class_create(THIS_MODULE, "gpio");
+	if (IS_ERR(gpio_class))
+		return PTR_ERR(gpio_class);
+
+	status = class_create_file(gpio_class, &class_attr_control);
+	if (status < 0) {
+		class_destroy(gpio_class);
+		gpio_class = NULL;
+	}
+	return status;
+}
+postcore_initcall(gpiolib_sysfs_init);
+
+#endif /* CONFIG_GPIO_SYSFS */
+
 void gpio_free(unsigned gpio)
 {
 	unsigned long		flags;
@@ -296,6 +575,8 @@ void gpio_free(unsigned gpio)
 		return;
 	}
 
+	gpio_unexport(gpio);
+
 	spin_lock_irqsave(&gpio_lock, flags);
 
 	desc = &gpio_desc[gpio];
--- g26.orig/drivers/gpio/mcp23s08.c	2008-04-28 11:17:42.000000000 -0700
+++ g26/drivers/gpio/mcp23s08.c	2008-04-28 11:31:21.000000000 -0700
@@ -239,6 +239,7 @@ static int mcp23s08_probe(struct spi_dev
 	mcp->chip.base = pdata->base;
 	mcp->chip.ngpio = 8;
 	mcp->chip.can_sleep = 1;
+	mcp->chip.dev = &spi->dev;
 	mcp->chip.owner = THIS_MODULE;
 
 	spi_set_drvdata(spi, mcp);
--- g26.orig/drivers/gpio/pca953x.c	2008-04-28 11:17:42.000000000 -0700
+++ g26/drivers/gpio/pca953x.c	2008-04-28 11:31:21.000000000 -0700
@@ -189,6 +189,7 @@ static void pca953x_setup_gpio(struct pc
 	gc->base = chip->gpio_start;
 	gc->ngpio = gpios;
 	gc->label = chip->client->name;
+	gc->dev = &chip->client->dev;
 	gc->owner = THIS_MODULE;
 }
 
--- g26.orig/drivers/gpio/pcf857x.c	2008-04-28 11:17:42.000000000 -0700
+++ g26/drivers/gpio/pcf857x.c	2008-04-28 11:31:21.000000000 -0700
@@ -159,6 +159,7 @@ static int pcf857x_probe(struct i2c_clie
 
 	gpio->chip.base = pdata->gpio_base;
 	gpio->chip.can_sleep = 1;
+	gpio->chip.dev = &client->dev;
 	gpio->chip.owner = THIS_MODULE;
 
 	/* NOTE:  the OnSemi jlc1562b is also largely compatible with
--- g26.orig/drivers/i2c/chips/tps65010.c	2008-04-28 11:11:07.000000000 -0700
+++ g26/drivers/i2c/chips/tps65010.c	2008-04-28 11:31:21.000000000 -0700
@@ -650,6 +650,8 @@ static int tps65010_probe(struct i2c_cli
 		tps->outmask = board->outmask;
 
 		tps->chip.label = client->name;
+		tps->chip.dev = &client->dev;
+		tps->chip.owner = THIS_MODULE;
 
 		tps->chip.set = tps65010_gpio_set;
 		tps->chip.direction_output = tps65010_output;
--- g26.orig/drivers/mfd/htc-egpio.c	2008-04-28 11:11:07.000000000 -0700
+++ g26/drivers/mfd/htc-egpio.c	2008-04-28 11:31:21.000000000 -0700
@@ -318,6 +318,8 @@ static int __init egpio_probe(struct pla
 		ei->chip[i].dev = &(pdev->dev);
 		chip = &(ei->chip[i].chip);
 		chip->label           = "htc-egpio";
+		chip->dev             = &pdev->dev;
+		chip->owner           = THIS_MODULE;
 		chip->get             = egpio_get;
 		chip->set             = egpio_set;
 		chip->direction_input = egpio_direction_input;
--- g26.orig/include/asm-generic/gpio.h	2008-04-28 11:17:44.000000000 -0700
+++ g26/include/asm-generic/gpio.h	2008-04-28 11:49:49.000000000 -0700
@@ -28,6 +28,8 @@ struct module;
 /**
  * struct gpio_chip - abstract a GPIO controller
  * @label: for diagnostics
+ * @dev: optional device providing the GPIOs
+ * @owner: helps prevent removal of modules exporting active GPIOs
  * @direction_input: configures signal "offset" as input, or returns error
  * @get: returns value for signal "offset"; for output signals this
  *	returns either the value actually sensed, or zero
@@ -55,6 +57,7 @@ struct module;
  */
 struct gpio_chip {
 	char			*label;
+	struct device		*dev;
 	struct module		*owner;
 
 	int			(*direction_input)(struct gpio_chip *chip,
@@ -104,7 +107,19 @@ extern void __gpio_set_value(unsigned gp
 extern int __gpio_cansleep(unsigned gpio);
 
 
-#else
+#ifdef CONFIG_GPIO_SYSFS
+#define HAVE_GPIO_SYSFS
+
+/*
+ * A sysfs interface can be exported by individual drivers if they want,
+ * but more typically is configured entirely from userspace.
+ */
+extern int gpio_export(unsigned gpio);
+extern void gpio_unexport(unsigned gpio);
+
+#endif	/* CONFIG_GPIO_SYSFS */
+
+#else	/* !CONFIG_HAVE_GPIO_LIB */
 
 static inline int gpio_is_valid(int number)
 {
@@ -135,4 +150,15 @@ static inline void gpio_set_value_cansle
 
 #endif
 
+#ifndef HAVE_GPIO_SYSFS
+static inline int gpio_export(unsigned gpio)
+{
+	return -ENOSYS;
+}
+
+static inline void gpio_unexport(unsigned gpio)
+{
+}
+#endif	/* HAVE_GPIO_SYSFS */
+
 #endif /* _ASM_GENERIC_GPIO_H */
