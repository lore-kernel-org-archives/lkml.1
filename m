Return-Path: <linux-kernel-owner+w=401wt.eu-S1755218AbYJTWu2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755218AbYJTWu2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2008 18:50:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752565AbYJTWuQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Oct 2008 18:50:16 -0400
Received: from outbound.icp-qv1-irony-out2.iinet.net.au ([203.59.1.107]:35515
	"EHLO outbound.icp-qv1-irony-out2.iinet.net.au" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751261AbYJTWuO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2008 18:50:14 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApIBALun/Eh8qNfA/2dsb2JhbAAIA54ppRODbA
X-IronPort-AV: E=Sophos;i="4.33,454,1220198400"; 
   d="scan'208";a="390201508"
Subject: [PATCH v2 RESEND] gpiolib: Add pin change notification
From: Ben Nizette <bn@niasdigital.com>
To: David Brownell <david-b@pacbell.net>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       linux-embedded <linux-embedded@vger.kernel.org>
Content-Type: multipart/mixed; boundary="=-3Bh/OTCEeQX5vH4S1jVk"
Organization: Nias Digital
Date: Tue, 21 Oct 2008 09:50:06 +1100
Message-Id: <1224543007.3954.71.camel@moss.renham>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-3Bh/OTCEeQX5vH4S1jVk
Content-Type: text/plain
Content-Transfer-Encoding: 7bit


This adds pin change notification to the gpiolib sysfs interface. It
requires 16 extra bytes in gpio_desc iff CONFIG_GPIO_SYSFS which in turn
means, eg, 4k of .bss usage on AVR32.  Due to limitations in sysfs, this
patch makes poll(2) and friends work as expected on the "value"
attribute, though reads on "value" will never block and there is no
facility for async reads and writes.

Signed-off-by: Ben Nizette <bn@niasdigital.com>

---

Right, there seems to be a new outgoing mail server between me and you
which viciously attacks tabulations.  Until I find the monkey
responsible please accept the patch as an attachment along with my
apologies.

 Documentation/gpio.txt |   48 +++++++++
 drivers/gpio/gpiolib.c |  246 ++++++++++++++++++++++++++++++++++++++++++++++++-
 2 files changed, 289 insertions(+), 5 deletions(-)

--=-3Bh/OTCEeQX5vH4S1jVk
Content-Disposition: attachment; filename=pinchange.patch
Content-Type: text/x-patch; name=pinchange.patch; charset=UTF-8
Content-Transfer-Encoding: 7bit

diff --git a/Documentation/gpio.txt b/Documentation/gpio.txt
index b1b9887..998a40f 100644
--- a/Documentation/gpio.txt
+++ b/Documentation/gpio.txt
@@ -529,6 +529,21 @@ and have the following read/write attributes:
 		is configured as an output, this value may be written;
 		any nonzero value is treated as high.
 
+	"notify" ... Selects a method for the detection of pin change
+		events.  This can be written or read as one of "none",
+		"irq" or a number.  If "none", no detection will be
+		done, if "irq" then the change detection will be done
+		by registering an interrupt handler on the line given
+		by gpio_to_irq for that gpio.  If a number is written,
+		the gpio will be polled for a state change every n
+		milliseconds where n is the number written.  The
+		minimum interval is 10 milliseconds.
+
+	"notify_filter" ... This can be written and read as one of
+		"rising", "falling" or "both".  If "rising", only
+		rising edges will be reported, similarly for "falling"
+		and "both".
+
 GPIO controllers have paths like /sys/class/gpio/chipchip42/ (for the
 controller implementing GPIOs starting at #42) and have the following
 read-only attributes:
@@ -549,6 +564,39 @@ gpiochip nodes (possibly in conjunction with schematics) to determine
 the correct GPIO number to use for a given signal.
 
 
+Pin Change Notification
+-----------------------
+The "value" attribute of a gpio is pollable.  For this to work, you
+must have set up the notify attribute of that gpio to the type of
+detection suitable for the underlying hardware.
+
+If the hardware supports interrupts on both edges and the gpio to
+interrupt line mapping is unique, you should write "irq" to the notify
+attribute.
+
+If the hardware doesn't support this, or you're unsure, you can write
+a number to the notify attribute.  This number is the delay between
+successive polls of the gpio state in milliseconds.  You may not poll
+more often than 10ms intervals.
+
+You must use poll mode if communication with the gpio's chip requires
+sleeping.  This is the case if, for example, the gpio is part of a
+I2C or SPI GPIO expander.
+
+By default, both rising and falling edges are reported.  To filter
+this, you can write one of "rising" or "falling" to the notify_filter
+attribute.  To go back to being notified of both edge changes, write
+"both" to this attribute.
+
+Once the notification has been set up, you may use poll(2) and friends
+on the "value" attribute.  This attribute will register as having new
+data ready to be read if and only if there has been a state change
+since the last read(2) to the "value" attribute.
+
+Note that unlike a regular device file, a read on the "value" attribute
+will never block whether or not there's new data to be read.
+
+
 Exporting from Kernel code
 --------------------------
 Kernel code can explicitly manage exports of GPIOs which have already been
diff --git a/drivers/gpio/gpiolib.c b/drivers/gpio/gpiolib.c
index 9112830..f43f231 100644
--- a/drivers/gpio/gpiolib.c
+++ b/drivers/gpio/gpiolib.c
@@ -1,6 +1,7 @@
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/irq.h>
+#include <linux/interrupt.h>
 #include <linux/spinlock.h>
 #include <linux/device.h>
 #include <linux/err.h>
@@ -49,13 +50,35 @@ struct gpio_desc {
 #define FLAG_RESERVED	2
 #define FLAG_EXPORT	3	/* protected by sysfs_lock */
 #define FLAG_SYSFS	4	/* exported via /sys/class/gpio/control */
+#define ASYNC_MODE_IRQ	5	/* using interrupts for async notification */
+#define ASYNC_MODE_POLL	6	/* using polling for async notification */
+#define ASYNC_RISING	7	/* will notify on rising edges */
+#define ASYNC_FALLING	8	/* will notify on falling edges */
 
 #ifdef CONFIG_DEBUG_FS
 	const char		*label;
 #endif
+
+#ifdef CONFIG_GPIO_SYSFS
+	struct device		*dev;
+	struct poll_desc	*poll;
+
+	/* Poll interval in jiffies, here (rather than in struct poll_desc
+	 * so the user can change the value no matter what their current
+	 * notification mode is */
+	long			timeout;
+
+	/* Last known value */
+	int			val;
+#endif
 };
 static struct gpio_desc gpio_desc[ARCH_NR_GPIOS];
 
+struct poll_desc {
+	struct delayed_work	work;
+	unsigned		gpio;
+};
+
 static inline void desc_set_label(struct gpio_desc *d, const char *label)
 {
 #ifdef CONFIG_DEBUG_FS
@@ -184,12 +207,56 @@ static DEFINE_MUTEX(sysfs_lock);
  *   /value
  *      * always readable, subject to hardware behavior
  *      * may be writable, as zero/nonzero
- *
- * REVISIT there will likely be an attribute for configuring async
- * notifications, e.g. to specify polling interval or IRQ trigger type
- * that would for example trigger a poll() on the "value".
+ *   /notify
+ *      * read/write as "irq", numeric or "none"
+ *   /notify_filter
+ *      * read/write as "rising", "falling" or "both"
  */
 
+struct poll_desc *work_to_poll(struct work_struct *ws)
+{
+	return container_of((struct delayed_work *)ws, struct poll_desc, work);
+}
+
+void gpio_poll_work(struct work_struct *ws)
+{
+	struct poll_desc	*poll = work_to_poll(ws);
+
+	unsigned		gpio = poll->gpio;
+	struct gpio_desc	*desc = &gpio_desc[gpio];
+
+	int new = gpio_get_value_cansleep(gpio);
+	int old = desc->val;
+
+	if ((new && !old && test_bit(ASYNC_RISING, &desc->flags)) ||
+	    (!new && old && test_bit(ASYNC_FALLING, &desc->flags)))
+		sysfs_notify(&desc->dev->kobj, NULL, "value");
+
+	desc->val = new;
+	schedule_delayed_work(&poll->work, desc->timeout);
+}
+
+static irqreturn_t gpio_irq_handler(int irq, void *dev_id)
+{
+	struct gpio_desc *desc = dev_id;
+	int gpio = desc - gpio_desc;
+	int new, old;
+
+	if (!gpio_is_valid(gpio))
+		return IRQ_NONE;
+
+	new = gpio_get_value(gpio);
+	old = desc->val;
+
+	if ((new && !old && test_bit(ASYNC_RISING, &desc->flags)) ||
+	    (!new && old && test_bit(ASYNC_FALLING, &desc->flags)))
+		sysfs_notify(&desc->dev->kobj, NULL, "value");
+
+	desc->val = new;
+
+	return IRQ_HANDLED;
+}
+
 static ssize_t gpio_direction_show(struct device *dev,
 		struct device_attribute *attr, char *buf)
 {
@@ -284,9 +351,162 @@ static ssize_t gpio_value_store(struct device *dev,
 static /*const*/ DEVICE_ATTR(value, 0644,
 		gpio_value_show, gpio_value_store);
 
+static ssize_t gpio_notify_show(struct device *dev,
+		struct device_attribute *attr, char *buf)
+{
+	const struct gpio_desc	*desc = dev_get_drvdata(dev);
+	ssize_t ret;
+
+	mutex_lock(&sysfs_lock);
+
+	if (test_bit(ASYNC_MODE_IRQ, &desc->flags))
+		ret = sprintf(buf, "irq\n");
+	else if (test_bit(ASYNC_MODE_POLL, &desc->flags))
+		ret = sprintf(buf, "%ld\n", desc->timeout * 1000 / HZ);
+	else
+		ret = sprintf(buf, "none\n");
+
+	mutex_unlock(&sysfs_lock);
+	return ret;
+}
+
+static ssize_t gpio_notify_store(struct device *dev,
+		struct device_attribute *attr, const char *buf, size_t size)
+{
+	struct gpio_desc	*desc = dev_get_drvdata(dev);
+	unsigned		gpio = desc - gpio_desc;
+	ssize_t			status = 0;
+	int			new;
+	long			value;
+
+	mutex_lock(&sysfs_lock);
+
+	if (sysfs_streq(buf, "irq"))
+		new = ASYNC_MODE_IRQ;
+	else if (sysfs_streq(buf, "none"))
+		new = -1;
+	else {
+		status = strict_strtol(buf, 0, &value);
+
+		if (status || value < 10) {
+			status = -EINVAL;
+			goto out;
+		}
+
+		/* value will be in ms, convert to jiffies. */
+		desc->timeout = DIV_ROUND_UP(value * HZ, 1000);
+		new = ASYNC_MODE_POLL;
+	}
+
+	if (test_and_clear_bit(ASYNC_MODE_IRQ, &desc->flags))
+		free_irq(gpio_to_irq(gpio), desc);
+	else if (test_and_clear_bit(ASYNC_MODE_POLL, &desc->flags)) {
+		BUG_ON(!desc->poll);
+
+		cancel_delayed_work(&desc->poll->work);
+		kfree(desc->poll);
+	}
+
+	if (new == ASYNC_MODE_IRQ) {
+		if (desc->chip->can_sleep) {
+			/* -EINVAL probably isn't appropriate here,
+			 * what's code for "not supported by
+			 * underlying hardware"? */
+			status = -EINVAL;
+			goto out;
+		}
+
+		desc->val = gpio_get_value(gpio);
+
+		/* REVISIT: We always request both edges then filter in the
+		 * irq handler.  How many devices don't support this..?? */
+		status = request_irq(gpio_to_irq(gpio), gpio_irq_handler,
+				     IRQF_SHARED | IRQF_TRIGGER_RISING |
+						IRQF_TRIGGER_FALLING,
+				     "gpiolib", desc);
+	} else if (new == ASYNC_MODE_POLL) {
+
+		desc->poll = kmalloc(sizeof(struct poll_desc), GFP_KERNEL);
+		if (!desc->poll) {
+			status = -ENOMEM;
+			goto out;
+		}
+
+		desc->poll->gpio = gpio;
+
+		desc->val = gpio_get_value_cansleep(gpio);
+
+		INIT_DELAYED_WORK(&desc->poll->work, gpio_poll_work);
+		schedule_delayed_work(&desc->poll->work, desc->timeout);
+	}
+
+	if (new >= 0 && !status)
+		set_bit(new, &desc->flags);
+
+out:
+	if (status)
+		dev_dbg(dev, "gpio notification mode set fail, err %d\n",
+			(int)status);
+
+	mutex_unlock(&sysfs_lock);
+	return status ? : size;
+}
+
+static const DEVICE_ATTR(notify, 0644,
+		gpio_notify_show, gpio_notify_store);
+
+static ssize_t gpio_notify_filter_show(struct device *dev,
+		struct device_attribute *attr, char *buf)
+{
+	struct gpio_desc	*desc = dev_get_drvdata(dev);
+	ssize_t			status;
+
+	mutex_lock(&sysfs_lock);
+
+	if (test_bit(ASYNC_FALLING, &desc->flags) &&
+			test_bit(ASYNC_RISING, &desc->flags))
+		status = sprintf(buf, "both\n");
+	else if (test_bit(ASYNC_RISING, &desc->flags))
+		status = sprintf(buf, "rising\n");
+	else
+		status = sprintf(buf, "falling\n");
+
+	mutex_unlock(&sysfs_lock);
+	return status;
+}
+
+static ssize_t gpio_notify_filter_store(struct device *dev,
+		struct device_attribute *attr, const char *buf, size_t size)
+{
+	struct gpio_desc	*desc = dev_get_drvdata(dev);
+	ssize_t			status = 0;
+
+	mutex_lock(&sysfs_lock);
+
+	if (sysfs_streq(buf, "rising")) {
+		set_bit(ASYNC_RISING, &desc->flags);
+		clear_bit(ASYNC_FALLING, &desc->flags);
+	} else if (sysfs_streq(buf, "falling")) {
+		clear_bit(ASYNC_RISING, &desc->flags);
+		set_bit(ASYNC_FALLING, &desc->flags);
+	} else if (sysfs_streq(buf, "both")) {
+		set_bit(ASYNC_RISING, &desc->flags);
+		set_bit(ASYNC_FALLING, &desc->flags);
+	} else
+		status = -EINVAL;
+
+	mutex_unlock(&sysfs_lock);
+	return status ? : size;
+}
+
+static const DEVICE_ATTR(notify_filter, 0644,
+		gpio_notify_filter_show, gpio_notify_filter_store);
+
 static const struct attribute *gpio_attrs[] = {
 	&dev_attr_direction.attr,
 	&dev_attr_value.attr,
+	&dev_attr_notify.attr,
+	&dev_attr_notify_filter.attr,
 	NULL,
 };
 
@@ -398,6 +618,17 @@ static ssize_t unexport_store(struct class *class, const char *buf, size_t len)
 		status = 0;
 		gpio_free(gpio);
 	}
+
+	if (test_and_clear_bit(ASYNC_MODE_IRQ, &gpio_desc[gpio].flags))
+		free_irq(gpio_to_irq(gpio), &gpio_desc[gpio]);
+
+	if (test_and_clear_bit(ASYNC_MODE_POLL, &gpio_desc[gpio].flags)) {
+		BUG_ON(!gpio_desc[gpio].poll);
+
+		cancel_delayed_work(&gpio_desc[gpio].poll->work);
+		kfree(gpio_desc[gpio].poll);
+	}
+
 done:
 	if (status)
 		pr_debug("%s: status %d\n", __func__, status);
@@ -479,6 +710,12 @@ int gpio_export(unsigned gpio, bool direction_may_change)
 			status = -ENODEV;
 		if (status == 0)
 			set_bit(FLAG_EXPORT, &desc->flags);
+
+		desc->dev = dev;
+		/* 100ms default poll interval */
+		desc->timeout = HZ / 10;
+		set_bit(ASYNC_RISING, &desc->flags);
+		set_bit(ASYNC_FALLING, &desc->flags);
 	}
 
 	mutex_unlock(&sysfs_lock);
@@ -626,7 +863,6 @@ static int __init gpiolib_sysfs_init(void)
 	}
 	spin_unlock_irqrestore(&gpio_lock, flags);
 
-
 	return status;
 }
 postcore_initcall(gpiolib_sysfs_init);

--=-3Bh/OTCEeQX5vH4S1jVk--

