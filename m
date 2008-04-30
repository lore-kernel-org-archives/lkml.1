Return-Path: <linux-kernel-owner+w=401wt.eu-S1762949AbYD3VtZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762949AbYD3VtZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2008 17:49:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763745AbYD3Vsu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Apr 2008 17:48:50 -0400
Received: from smtp118.sbc.mail.sp1.yahoo.com ([69.147.64.91]:44559 "HELO
	smtp118.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1763551AbYD3Vsq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2008 17:48:46 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Disposition:Message-Id:Content-Type:Content-Transfer-Encoding;
  b=ZmfFYYbGi71PgcwR2nVZ7ArxW7HrnXeXyRiwkkBN958ZYWI/zkjEyfkRs8xgNmJZjiH+r2azc0jv58ybQwPPoa/lmf1rTa/DkVZ/V19WrCV6eY4uB9sVF/tS3PVXbYOh4VQPE144jsNA4kG804b3RAUXMma/v760U99hKghmW0o=  ;
X-YMail-OSG: fLLP0iwVM1kS87PhV5VuYfVYGyfsicWe5bAiwm9F.LS65GGp0aAQ2PRo8k0bmMTLyIAjKn8gND8dVCtkYOw.Q8IArAAbCpDh29DFX3EjvaWhFvmWs0TyXPaz8yNkuJNohaA-
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: lkml <linux-kernel@vger.kernel.org>
Subject: [patch/rfc 2.6.25-git v2] gpio: sysfs interface
Date: Wed, 30 Apr 2008 14:34:24 -0700
User-Agent: KMail/1.9.6
Cc: Ben Nizette <bn@niasdigital.com>, Trent Piepho <tpiepho@freescale.com>,
       hartleys <hartleys@visionengravers.com>,
       Mike Frysinger <vapier.adi@gmail.com>, Bryan Wu <cooloney@kernel.org>
References: <200804281239.51729.david-b@pacbell.net> <1209521291.311.99.camel@moss.renham> <200804301042.42513.david-b@pacbell.net>
In-Reply-To: <200804301042.42513.david-b@pacbell.net>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200804301434.25211.david-b@pacbell.net>
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Simple sysfs interface for GPIOs.

    /sys/class/gpio
    	/control ... to request a GPIO be imported or returned
        /gpioN ... for each exported GPIO #N
	    /value ... always readable, writes fail for input GPIOs
	    /direction ... r/w as: in, out (default low); write high, low
	/gpiochipN ... for each gpiochip; #N is its first GPIO
	    /base ... (r/o) same as N
	    /label ... (r/o) descriptive, not necessarily unique
	    /ngpio ... (r/o) number of GPIOs; numbered N .. N+(ngpio - 1)

GPIOs may be exported by kernel code using gpio_export(), which should
be most useful for driver debugging.  Userspace may also ask that they
be imported by writing to the sysfs control file, helping to cope with
incomplete board support:

  echo "23" > /sys/class/gpio/control
	... will gpio_request(23, "sysfs") and gpio_export(23); use
	/sys/class/gpio/gpio-23/direction to configure it.
  echo "-23" > /sys/class/gpio/control
	... will gpio_free(23)

The extra D-space footprint is a few hundred bytes, except for the sysfs
resources associated with each exported GPIO.  The additional I-space
footprint is about two thirds of the current size of gpiolib (!).  Since
no /dev node creation is involved, no "udev" support is needed.

This adds a device pointer to "struct gpio_chip".  When GPIO providers
initialize that, sysfs gpio class devices become children of that device
instead of being "virtual" devices.  The (few) gpio_chip providers which
have such a device node have been updated.  (Some also needed to update
their module "owner" field ... for which missing kerneldoc was added.)

Based on a patch from Trent Piepho <tpiepho@freescale.com>, and comments
from various folk including most recently Hartley Sweeten and Ben Nizette.

Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
---
Notable updates from previous version:  doc update, mutex protection
for sysfs access, export basic gpio_chip info ("what GPIOs exist"),
depend on new sysfs_streq() call, simplified control file syntax.

 Documentation/gpio.txt       |  101 ++++++++-
 arch/arm/plat-omap/gpio.c    |    3 
 arch/avr32/mach-at32ap/pio.c |    2 
 drivers/gpio/Kconfig         |   15 +
 drivers/gpio/gpiolib.c       |  473 ++++++++++++++++++++++++++++++++++++++++++-
 drivers/gpio/mcp23s08.c      |    1 
 drivers/gpio/pca953x.c       |    1 
 drivers/gpio/pcf857x.c       |    1 
 drivers/i2c/chips/tps65010.c |    2 
 drivers/mfd/htc-egpio.c      |    2 
 include/asm-generic/gpio.h   |   30 ++
 11 files changed, 616 insertions(+), 15 deletions(-)

--- a/Documentation/gpio.txt	2008-04-30 13:00:03.000000000 -0700
+++ b/Documentation/gpio.txt	2008-04-30 14:18:03.000000000 -0700
@@ -347,15 +347,12 @@ necessarily be nonportable.
 Dynamic definition of GPIOs is not currently standard; for example, as
 a side effect of configuring an add-on board with some GPIO expanders.
 
-These calls are purely for kernel space, but a userspace API could be built
-on top of them.
-
 
 GPIO implementor's framework (OPTIONAL)
 =======================================
 As noted earlier, there is an optional implementation framework making it
 easier for platforms to support different kinds of GPIO controller using
-the same programming interface.
+the same programming interface.  This framework is called "gpiolib".
 
 As a debugging aid, if debugfs is available a /sys/kernel/debug/gpio file
 will be found there.  That will list all the controllers registered through
@@ -439,4 +436,98 @@ becomes available.  That may mean the de
 calls for that GPIO can work.  One way to address such dependencies is for
 such gpio_chip controllers to provide setup() and teardown() callbacks to
 board specific code; those board specific callbacks would register devices
-once all the necessary resources are available.
+once all the necessary resources are available, and remove them later when
+the GPIO controller device becomes unavailable.
+
+
+Sysfs Interface for Userspace (OPTIONAL)
+========================================
+Platforms which use the "gpiolib" implementors framework may choose to
+configure a sysfs user interface to GPIOs.  This is different from the
+debugfs interface, since it provides control over GPIO direction and
+value instead of just showing a gpio state summary.  Plus, it would be
+present on production systems without debugging support.
+
+Given approprate hardware documentation for the system, userspace could
+know for example that GPIO #23 controls the write protect line used to
+protect boot loader segments in flash memory.  System upgrade procedures
+may need to temporarily remove that protection, first importing a GPIO,
+then changing its output state, then updating the code before re-enabling
+the write protection.  In normal use, GPIO #23 would never be touched,
+and the kernel would have no need to know about it.
+
+Again depending on appropriate hardware documentation, on some systems
+userspace GPIO can be used to determine system configuration data that
+standard kernels won't know about.  And for some tasks, simple userspace
+GPIO drivers could be all that the system really needs.
+
+
+Paths in Sysfs
+--------------
+There are three kinds of entry in /sys/class/gpio:  GPIO controllers
+("gpio_chip" instances), GPIOs themselves, and a control interface
+used to import GPIOs to userspace (and later return them).
+
+The control interface is write-only.  Userspace may ask to import
+control of a GPIO by writing its number to the control file:
+
+    /sys/class/gpio/control
+
+Write negative numbers to release userspace control.  For example,
+"echo 19 > control" to create a "gpio19" node, which can then be
+configured and modified.  Then "echo -19 > control" to remove the
+userspace controls for that signal.
+
+GPIO signals have paths like /sys/class/gpio/gpio42/ (for GPIO #42)
+and have the following read/write attributes:
+
+    /sys/class/gpio/gpioN/
+
+	"direction" ... reads as either "in" or "out".  This value may
+		normally be written.  Writing as "out" defaults to
+		initializing the value as low.  To ensure glitch free
+		operation, values "low" and "high" may be written to
+		configure the GPIO as an output with that initial value.
+
+	"value" ... reads as either 0 (low) or 1 (high).  If the GPIO
+		is configured as an output, this value may be written;
+		any nonzero value is treated as high.
+
+GPIO controllers have paths like /sys/class/gpio/chipchip42/ (for the
+controller implementing GPIOs starting at #42) and have the following
+read-only attributes:
+
+    /sys/class/gpio/gpiochipN/
+
+    	"base" ... same as N, the first GPIO managed by this chip
+
+    	"label" ... provided for diagnostics (not unique)
+
+    	"ngpio" ... how many GPIOs this manges (N to N + ngpio - 1)
+
+Board documentation should in most cases cover what GPIOs are used
+for what purposes.  However, those numbers are not always stable;
+GPIOs on a daughterboard might be different depending on the base
+board being used, or other cards in the stack.  In such cases, you
+may need to use the gpiochip nodes to determine th correct GPIO
+number to use for a given signal.
+
+
+Exporting from Kernel code
+--------------------------
+Kernel code can explicitly manage exports of GPIOs which have already been
+requested using gpio_request():
+
+	/* export the GPIO to userspace */
+	int gpio_export(unsigned gpio);
+
+	/* reverse gpio_export() */
+	void gpio_unexport();
+
+When a kernel driver has requested a GPIO, it may only be made available
+in the sysfs interface by gpio_export().  This prevents userspace code
+from clobbering important state.
+
+This explicit exporting can help with debugging (by making some kinds
+of experiments easier), or can provide an always-there interface that's
+suitable for documenting as part of a board support package.
--- a/arch/arm/plat-omap/gpio.c	2008-04-22 15:19:26.000000000 -0700
+++ b/arch/arm/plat-omap/gpio.c	2008-04-30 13:01:47.000000000 -0700
@@ -1488,6 +1488,9 @@ static int __init _omap_gpio_init(void)
 		bank->chip.set = gpio_set;
 		if (bank_is_mpuio(bank)) {
 			bank->chip.label = "mpuio";
+#ifdef CONFIG_ARCH_OMAP1
+			bank->chip.dev = &omap_mpuio_device.dev;
+#endif
 			bank->chip.base = OMAP_MPUIO(0);
 		} else {
 			bank->chip.label = "gpio";
--- a/arch/avr32/mach-at32ap/pio.c	2008-04-30 13:00:03.000000000 -0700
+++ b/arch/avr32/mach-at32ap/pio.c	2008-04-30 13:01:47.000000000 -0700
@@ -358,6 +358,8 @@ static int __init pio_probe(struct platf
 	pio->chip.label = pio->name;
 	pio->chip.base = pdev->id * 32;
 	pio->chip.ngpio = 32;
+	pio->chip.dev = &pdev->dev;
+	pio->chip.owner = THIS_MODULE;
 
 	pio->chip.direction_input = direction_input;
 	pio->chip.get = gpio_get;
--- a/drivers/gpio/Kconfig	2008-04-30 13:00:03.000000000 -0700
+++ b/drivers/gpio/Kconfig	2008-04-30 14:20:32.000000000 -0700
@@ -23,6 +23,21 @@ config DEBUG_GPIO
 	  slower.  The diagnostics help catch the type of setup errors
 	  that are most common when setting up new platforms or boards.
 
+config GPIO_SYSFS
+	bool "/sys/class/gpio/... (sysfs interface)"
+	depends on SYSFS && EXPERIMENTAL
+	help
+	  Say Y here to add a sysfs interface for GPIOs.
+
+	  This is mostly useful to work around omissions in a system's
+	  kernel support.  Those are common in custom and semicustom
+	  hardware assembled using standard kernels with a minimum of
+	  custom patches.  In those cases, userspace code may import
+	  a given GPIO from the kernel, if no kernel driver requested it.
+
+	  Kernel drivers may also request that a particular GPIO be
+	  exported to userspace; this can be useful when debugging.
+
 # put expanders in the right section, in alphabetical order
 
 comment "I2C GPIO expanders:"
--- a/drivers/gpio/gpiolib.c	2008-04-30 13:00:03.000000000 -0700
+++ b/drivers/gpio/gpiolib.c	2008-04-30 13:01:47.000000000 -0700
@@ -2,8 +2,11 @@
 #include <linux/module.h>
 #include <linux/irq.h>
 #include <linux/spinlock.h>
-
-#include <asm/gpio.h>
+#include <linux/device.h>
+#include <linux/err.h>
+#include <linux/debugfs.h>
+#include <linux/seq_file.h>
+#include <linux/gpio.h>
 
 
 /* Optional implementation infrastructure for GPIO interfaces.
@@ -44,6 +47,8 @@ struct gpio_desc {
 #define FLAG_REQUESTED	0
 #define FLAG_IS_OUT	1
 #define FLAG_RESERVED	2
+#define FLAG_EXPORT	3	/* protected by sysfs_lock */
+#define FLAG_SYSFS	4	/* exported via /sys/class/gpio/control */
 
 #ifdef CONFIG_DEBUG_FS
 	const char		*label;
@@ -151,6 +156,452 @@ err:
 	return ret;
 }
 
+#ifdef CONFIG_GPIO_SYSFS
+
+/* lock protects against unexport_gpio() being called while
+ * sysfs files are open.
+ */
+static DEFINE_MUTEX(sysfs_lock);
+
+/*
+ * /sys/class/gpio/gpioN... only for GPIOs that are exported
+ *   /direction
+ *      * is read/write as "in" or "out"
+ *      * may also be written as "high" or "low", initializing
+ *        output value as specified ("out" implies "low")
+ *   /value
+ *      * always readable, subject to hardware behavior
+ *      * may be writable, as zero/nonzero
+ *
+ * REVISIT there will likely be an attribute for configuring async
+ * notifications, e.g. to specify polling interval or IRQ trigger type
+ */
+
+static ssize_t gpio_direction_show(struct device *dev,
+		struct device_attribute *attr, char *buf)
+{
+	const struct gpio_desc	*desc = dev_get_drvdata(dev);
+	ssize_t			status;
+
+	mutex_lock(&sysfs_lock);
+
+	if (!test_bit(FLAG_EXPORT, &desc->flags))
+		status = -EIO;
+	else
+		status = sprintf(buf, "%s\n",
+			test_bit(FLAG_IS_OUT, &desc->flags)
+				? "out" : "in");
+
+	mutex_unlock(&sysfs_lock);
+	return status;
+}
+
+static ssize_t gpio_direction_store(struct device *dev,
+		struct device_attribute *attr, const char *buf, size_t size)
+{
+	const struct gpio_desc	*desc = dev_get_drvdata(dev);
+	unsigned		gpio = desc - gpio_desc;
+	ssize_t			status;
+
+	mutex_lock(&sysfs_lock);
+
+	if (!test_bit(FLAG_EXPORT, &desc->flags))
+		status = -EIO;
+	else if (sysfs_streq(buf, "high"))
+		status = gpio_direction_output(gpio, 1);
+	else if (sysfs_streq(buf, "out") || sysfs_streq(buf, "low"))
+		status = gpio_direction_output(gpio, 0);
+	else if (sysfs_streq(buf, "in"))
+		status = gpio_direction_input(gpio);
+	else
+		status = -EINVAL;
+
+	mutex_unlock(&sysfs_lock);
+	return status ? : size;
+}
+
+static const DEVICE_ATTR(direction, 0644,
+		gpio_direction_show, gpio_direction_store);
+
+static ssize_t gpio_value_show(struct device *dev,
+		struct device_attribute *attr, char *buf)
+{
+	const struct gpio_desc	*desc = dev_get_drvdata(dev);
+	unsigned		gpio = desc - gpio_desc;
+	ssize_t			status;
+
+	mutex_lock(&sysfs_lock);
+
+	if (!test_bit(FLAG_EXPORT, &desc->flags))
+		status = -EIO;
+	else
+		status = sprintf(buf, "%d\n", gpio_get_value_cansleep(gpio));
+
+	mutex_unlock(&sysfs_lock);
+	return status;
+}
+
+static ssize_t gpio_value_store(struct device *dev,
+		struct device_attribute *attr, const char *buf, size_t size)
+{
+	const struct gpio_desc	*desc = dev_get_drvdata(dev);
+	unsigned		gpio = desc - gpio_desc;
+	ssize_t			status;
+
+	mutex_lock(&sysfs_lock);
+
+	if (!test_bit(FLAG_EXPORT, &desc->flags))
+		status = -EIO;
+	else if (!test_bit(FLAG_IS_OUT, &desc->flags))
+		status = -EINVAL;
+	else {
+		long		value;
+
+		status = strict_strtol(buf, 0, &value);
+		if (status == 0) {
+			gpio_set_value_cansleep(gpio, value != 0);
+			status = size;
+		}
+	}
+
+	mutex_unlock(&sysfs_lock);
+	return status;
+}
+
+static const DEVICE_ATTR(value, 0644,
+		gpio_value_show, gpio_value_store);
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
+/*
+ * /sys/class/gpio/gpiochipN/
+ *   /base ... matching gpio_chip.base (N)
+ *   /label ... matching gpio_chip.label
+ *   /ngpio ... matching gpio_chip.ngpio
+ */
+
+static ssize_t chip_base_show(struct device *dev,
+			       struct device_attribute *attr, char *buf)
+{
+	const struct gpio_chip	*chip = dev_get_drvdata(dev);
+
+	return sprintf(buf, "%d\n", chip->base);
+}
+static DEVICE_ATTR(base, 0444, chip_base_show, NULL);
+
+static ssize_t chip_label_show(struct device *dev,
+			       struct device_attribute *attr, char *buf)
+{
+	const struct gpio_chip	*chip = dev_get_drvdata(dev);
+
+	return sprintf(buf, "%s\n", chip->label ? : "");
+}
+static DEVICE_ATTR(label, 0444, chip_label_show, NULL);
+
+static ssize_t chip_ngpio_show(struct device *dev,
+			       struct device_attribute *attr, char *buf)
+{
+	const struct gpio_chip	*chip = dev_get_drvdata(dev);
+
+	return sprintf(buf, "%u\n", chip->ngpio);
+}
+static DEVICE_ATTR(ngpio, 0444, chip_ngpio_show, NULL);
+
+static const struct attribute *gpiochip_attrs[] = {
+	&dev_attr_base.attr,
+	&dev_attr_label.attr,
+	&dev_attr_ngpio.attr,
+	NULL,
+};
+
+static const struct attribute_group gpiochip_attr_group = {
+	.attrs = (struct attribute **) gpiochip_attrs,
+};
+
+/*
+ * /sys/class/gpio/control ... write-only
+ *	integer N:  non-negative == export; negative == unexport
+ */
+static ssize_t control_store(struct class *class, const char *buf, size_t len)
+{
+	long	gpio;
+	int	status;
+
+	status = strict_strtol(buf, 0, &gpio);
+	if (status < 0)
+		goto done;
+
+	/* No extra locking here; FLAG_SYSFS just signifies that the
+	 * request and export were done by on behalf of userspace, so
+	 * they may be undone on its behalf too.
+	 */
+
+	if (gpio >= 0) {			/* export */
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
+	} else {				/* unexport */
+		gpio = -gpio;
+
+		/* reject bogus commands (gpio_unexport ignores them) */
+		if (!gpio_is_valid(gpio))
+			goto fail;
+		if (!test_and_clear_bit(FLAG_SYSFS, &gpio_desc[gpio].flags))
+			goto fail;
+		status = 0;
+		gpio_free(gpio);
+	}
+done:
+	if (status)
+		pr_debug("%s: status %d\n", __func__, status);
+	return status ? : len;
+fail:
+	pr_debug("%s: fail\n", __func__);
+	return -EINVAL;
+}
+
+static struct class_attribute gpio_class_attrs[] = {
+	__ATTR(control, 0200, NULL, control_store),
+	{},
+};
+
+static struct class gpio_class = {
+	.name =		"gpio",
+	.owner =	THIS_MODULE,
+
+	.class_attrs =	gpio_class_attrs,
+};
+
+
+/**
+ * gpio_export - export a GPIO through sysfs
+ * @gpio: gpio to make available, already requested
+ * Context: arch_initcall or later
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
+	/* REVISIT param to say if userspace may change direction? */
+
+	/* can't export until sysfs is available ... */
+	if (!gpio_class.children.next) {
+		pr_debug("%s: called too early!\n", __func__);
+		return -ENOENT;
+	}
+
+	if (!gpio_is_valid(gpio))
+		goto done;
+
+	mutex_lock(&sysfs_lock);
+
+	spin_lock_irqsave(&gpio_lock, flags);
+	desc = &gpio_desc[gpio];
+	if (test_bit(FLAG_REQUESTED, &desc->flags)
+			&& !test_bit(FLAG_EXPORT, &desc->flags))
+		status = 0;
+	spin_unlock_irqrestore(&gpio_lock, flags);
+
+	if (status == 0) {
+		struct device	*dev;
+
+		dev = device_create(&gpio_class, desc->chip->dev, 0,
+				"gpio%d", gpio);
+		if (dev) {
+			dev_set_drvdata(dev, desc);
+			status = sysfs_create_group(&dev->kobj,
+					&gpio_attr_group);
+		} else
+			status = -ENODEV;
+		if (status == 0)
+			set_bit(FLAG_EXPORT, &desc->flags);
+	}
+
+	mutex_unlock(&sysfs_lock);
+
+done:
+	if (status)
+		pr_debug("%s: gpio%d status %d\n", __func__, gpio, status);
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
+	struct gpio_desc	*desc;
+	int			status = -EINVAL;
+
+	if (!gpio_is_valid(gpio))
+		goto done;
+
+	mutex_lock(&sysfs_lock);
+
+	desc = &gpio_desc[gpio];
+	if (test_bit(FLAG_EXPORT, &desc->flags)) {
+		struct device	*dev = NULL;
+
+		dev = class_find_device(&gpio_class, desc, match_export);
+		if (dev) {
+			clear_bit(FLAG_EXPORT, &desc->flags);
+			put_device(dev);
+			device_unregister(dev);
+			status = 0;
+		} else
+			status = -ENODEV;
+	}
+
+	mutex_unlock(&sysfs_lock);
+done:
+	if (status)
+		pr_debug("%s: gpio%d status %d\n", __func__, gpio, status);
+}
+EXPORT_SYMBOL_GPL(gpio_unexport);
+
+static int gpiochip_export(struct gpio_chip *chip)
+{
+	int		status;
+	struct device	*dev;
+
+	/* Many systems register gpio chips for SOC support very early,
+	 * before driver model support is available.  In those cases we
+	 * export this later, in gpiolib_sysfs_init()
+	 */
+	if (!gpio_class.children.next)
+		return 0;
+
+	/* use chip->base for the ID; it's already known to be unique */
+	mutex_lock(&sysfs_lock);
+	dev = device_create(&gpio_class, chip->dev, 0,
+			"gpiochip%d", chip->base);
+	if (dev) {
+		dev_set_drvdata(dev, chip);
+		status = sysfs_create_group(&dev->kobj,
+				&gpiochip_attr_group);
+	} else
+		status = -ENODEV;
+	chip->exported = (status == 0);
+	mutex_unlock(&sysfs_lock);
+
+	if (status) {
+		unsigned long	flags;
+		unsigned	gpio;
+
+		spin_lock_irqsave(&gpio_lock, flags);
+		gpio = chip->base;
+		while (gpio_desc[gpio].chip == chip)
+			gpio_desc[gpio++].chip = NULL;
+		spin_unlock_irqrestore(&gpio_lock, flags);
+
+		pr_debug("%s: chip %s status %d\n", __func__,
+				chip->label, status);
+	}
+
+	return status;
+}
+
+static void gpiochip_unexport(struct gpio_chip *chip)
+{
+	int			status;
+	struct device		*dev;
+
+	mutex_lock(&sysfs_lock);
+	dev = class_find_device(&gpio_class, chip, match_export);
+	if (dev) {
+		put_device(dev);
+		device_unregister(dev);
+		chip->exported = 0;
+		status = 0;
+	} else
+		status = -ENODEV;
+	mutex_unlock(&sysfs_lock);
+
+	if (status)
+		pr_debug("%s: chip %s status %d\n", __func__,
+				chip->label, status);
+}
+
+static int __init gpiolib_sysfs_init(void)
+{
+	int		status;
+	unsigned long	flags;
+	unsigned	gpio;
+
+	status = class_register(&gpio_class);
+	if (status < 0)
+		return status;
+
+	/* Scan and register the gpio_chips which registered very
+	 * early (e.g. before the class_register above was called).
+	 *
+	 * Note that we run at arch_initcall() to help ensure that
+	 * the chip->dev devices have had a fair chance to register.
+	 */
+	spin_lock_irqsave(&gpio_lock, flags);
+	for (gpio = 0; gpio < ARCH_NR_GPIOS; gpio++) {
+		struct gpio_chip	*chip;
+
+		chip = gpio_desc[gpio].chip;
+		if (!chip || chip->exported)
+			continue;
+
+		spin_unlock_irqrestore(&gpio_lock, flags);
+		status = gpiochip_export(chip);
+		spin_lock_irqsave(&gpio_lock, flags);
+	}
+	spin_unlock_irqrestore(&gpio_lock, flags);
+
+
+	return status;
+}
+arch_initcall(gpiolib_sysfs_init);
+
+#else
+static inline int gpiochip_export(struct gpio_chip *chip)
+{
+	return 0;
+}
+
+static inline void gpiochip_unexport(struct gpio_chip *chip)
+{
+}
+
+#endif /* CONFIG_GPIO_SYSFS */
+
 /**
  * gpiochip_add() - register a gpio_chip
  * @chip: the chip to register, with chip->base initialized
@@ -160,6 +611,11 @@ err:
  * because the chip->base is invalid or already associated with a
  * different chip.  Otherwise it returns zero as a success code.
  *
+ * When gpiochip_add() is called very early during boot, so that GPIOs
+ * can be freely used, the chip->dev device must be registered before
+ * the gpio framework's arch_initcall().  Otherwise sysfs initialization
+ * for GPIOs will fail rudely.
+ *
  * If chip->base is negative, this requests dynamic assignment of
  * a range of valid GPIOs.
  */
@@ -182,7 +638,7 @@ int gpiochip_add(struct gpio_chip *chip)
 		base = gpiochip_find_base(chip->ngpio);
 		if (base < 0) {
 			status = base;
-			goto fail_unlock;
+			goto unlock;
 		}
 		chip->base = base;
 	}
@@ -201,8 +657,10 @@ int gpiochip_add(struct gpio_chip *chip)
 		}
 	}
 
-fail_unlock:
+unlock:
 	spin_unlock_irqrestore(&gpio_lock, flags);
+	if (status == 0)
+		status = gpiochip_export(chip);
 fail:
 	/* failures here can mean systems won't boot... */
 	if (status)
@@ -234,6 +692,7 @@ int gpiochip_remove(struct gpio_chip *ch
 		}
 	}
 	if (status == 0) {
+		gpiochip_unexport(chip);
 		for (id = chip->base; id < chip->base + chip->ngpio; id++)
 			gpio_desc[id].chip = NULL;
 	}
@@ -296,6 +755,8 @@ void gpio_free(unsigned gpio)
 		return;
 	}
 
+	gpio_unexport(gpio);
+
 	spin_lock_irqsave(&gpio_lock, flags);
 
 	desc = &gpio_desc[gpio];
@@ -534,10 +995,6 @@ EXPORT_SYMBOL_GPL(gpio_set_value_canslee
 
 #ifdef CONFIG_DEBUG_FS
 
-#include <linux/debugfs.h>
-#include <linux/seq_file.h>
-
-
 static void gpiolib_dbg_show(struct seq_file *s, struct gpio_chip *chip)
 {
 	unsigned		i;
--- a/drivers/gpio/mcp23s08.c	2008-04-30 13:00:03.000000000 -0700
+++ b/drivers/gpio/mcp23s08.c	2008-04-30 13:01:47.000000000 -0700
@@ -239,6 +239,7 @@ static int mcp23s08_probe(struct spi_dev
 	mcp->chip.base = pdata->base;
 	mcp->chip.ngpio = 8;
 	mcp->chip.can_sleep = 1;
+	mcp->chip.dev = &spi->dev;
 	mcp->chip.owner = THIS_MODULE;
 
 	spi_set_drvdata(spi, mcp);
--- a/drivers/gpio/pca953x.c	2008-04-30 13:00:03.000000000 -0700
+++ b/drivers/gpio/pca953x.c	2008-04-30 13:01:47.000000000 -0700
@@ -185,6 +185,7 @@ static void pca953x_setup_gpio(struct pc
 	gc->base = chip->gpio_start;
 	gc->ngpio = gpios;
 	gc->label = chip->client->name;
+	gc->dev = &chip->client->dev;
 	gc->owner = THIS_MODULE;
 }
 
--- a/drivers/gpio/pcf857x.c	2008-04-30 13:00:03.000000000 -0700
+++ b/drivers/gpio/pcf857x.c	2008-04-30 13:01:47.000000000 -0700
@@ -175,6 +175,7 @@ static int pcf857x_probe(struct i2c_clie
 
 	gpio->chip.base = pdata->gpio_base;
 	gpio->chip.can_sleep = 1;
+	gpio->chip.dev = &client->dev;
 	gpio->chip.owner = THIS_MODULE;
 
 	/* NOTE:  the OnSemi jlc1562b is also largely compatible with
--- a/drivers/i2c/chips/tps65010.c	2008-04-30 13:00:03.000000000 -0700
+++ b/drivers/i2c/chips/tps65010.c	2008-04-30 13:01:47.000000000 -0700
@@ -636,6 +636,8 @@ static int tps65010_probe(struct i2c_cli
 		tps->outmask = board->outmask;
 
 		tps->chip.label = client->name;
+		tps->chip.dev = &client->dev;
+		tps->chip.owner = THIS_MODULE;
 
 		tps->chip.set = tps65010_gpio_set;
 		tps->chip.direction_output = tps65010_output;
--- a/drivers/mfd/htc-egpio.c	2008-04-30 13:00:03.000000000 -0700
+++ b/drivers/mfd/htc-egpio.c	2008-04-30 13:01:47.000000000 -0700
@@ -318,6 +318,8 @@ static int __init egpio_probe(struct pla
 		ei->chip[i].dev = &(pdev->dev);
 		chip = &(ei->chip[i].chip);
 		chip->label           = "htc-egpio";
+		chip->dev             = &pdev->dev;
+		chip->owner           = THIS_MODULE;
 		chip->get             = egpio_get;
 		chip->set             = egpio_set;
 		chip->direction_input = egpio_direction_input;
--- a/include/asm-generic/gpio.h	2008-04-30 13:00:03.000000000 -0700
+++ b/include/asm-generic/gpio.h	2008-04-30 13:01:47.000000000 -0700
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
@@ -70,6 +73,7 @@ struct gpio_chip {
 	int			base;
 	u16			ngpio;
 	unsigned		can_sleep:1;
+	unsigned		exported:1;
 };
 
 extern const char *gpiochip_is_requested(struct gpio_chip *chip,
@@ -104,7 +108,18 @@ extern void __gpio_set_value(unsigned gp
 extern int __gpio_cansleep(unsigned gpio);
 
 
-#else
+#ifdef CONFIG_GPIO_SYSFS
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
@@ -133,6 +148,17 @@ static inline void gpio_set_value_cansle
 	gpio_set_value(gpio, value);
 }
 
-#endif
+#endif /* !CONFIG_HAVE_GPIO_LIB */
+
+#ifndef CONFIG_GPIO_SYSFS
+static inline int gpio_export(unsigned gpio)
+{
+	return -ENOSYS;
+}
+
+static inline void gpio_unexport(unsigned gpio)
+{
+}
+#endif	/* CONFIG_GPIO_SYSFS */
 
 #endif /* _ASM_GENERIC_GPIO_H */
