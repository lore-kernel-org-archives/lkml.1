Return-Path: <linux-kernel-owner+w=401wt.eu-S1755453AbYFYG2l@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755453AbYFYG2l (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2008 02:28:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753446AbYFYG2c
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jun 2008 02:28:32 -0400
Received: from outbound.icp-qv1-irony-out1.iinet.net.au ([203.59.1.108]:6162
	"EHLO outbound.icp-qv1-irony-out1.iinet.net.au" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752201AbYFYG2b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2008 02:28:31 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApQAANeBYUjLrQkK/2dsb2JhbAAIsXE
X-IronPort-AV: E=Sophos;i="4.27,700,1204470000"; 
   d="scan'208";a="347371578"
Subject: [PATCH][RFC] gpiolib: async notification of gpio events
From: Ben Nizette <bn@niasdigital.com>
To: David Brownell <david-b@pacbell.net>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
       Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Content-Type: text/plain
Organization: Nias Digital
Date: Wed, 25 Jun 2008 16:28:34 +1000
Message-Id: <1214375314.8462.62.camel@moss.renham>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This patch adds poll/select functionality to the gpio sysfs interface's
"value" attribute.  It applies on top of the latest sysfs interface
patch along with the locking bugfix.

This patch hits .text size for 1.5k but .bss for an annoying 13k on
AVR32.  Owch.  This is mostly due to the per-descriptor workqueues.  We
can get around this by
	- Using one big delayed workqueue which scans each descriptor and acts
on it appropriately.  I don't love this approach, scanning each
descriptor (or keeping a list of descriptors needing attention) is
awkward.
	- Only creating the struct delayed_work when needed.  This isn't
completely trivial as that struct can no longer take a reference back to
private data and therefore must be container_of() friendly.

Also before final inclusion I'll do a docco update.

I've left this a little late (uni exams took more study than I'd
hoped :-) ) and I'll be on leave for 2 weeks from Monday.  I doubt
there's enough of a rush for this to be a problem though, eh?

Signed-off-by: Ben Nizette <bn@niasdigital.com>

---
diff --git a/drivers/gpio/gpiolib.c b/drivers/gpio/gpiolib.c
index 02c1f44..4d75cbe 100644
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
@@ -49,10 +50,25 @@ struct gpio_desc {
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
+
+	/* Poll interval in jiffies */
+	long			timeout;
+	struct delayed_work	work;
+
+	/* Last known value */
+	int			val;
+#endif
 };
 static struct gpio_desc gpio_desc[ARCH_NR_GPIOS];
 
@@ -173,12 +189,60 @@ static DEFINE_MUTEX(sysfs_lock);
  *   /value
  *      * always readable, subject to hardware behavior
  *      * may be writable, as zero/nonzero
- *
- * REVISIT there will likely be an attribute for configuring async
- * notifications, e.g. to specify polling interval or IRQ trigger type
- * that would for example trigger a poll() on the "value".
+ *   /notify
+ *      * read/write as "irq", "poll" or "none"
+ *   /notify_filter
+ *      * read/write as "rising", "falling" or "both"
+ *   /notify_interval
+ *      * write the preferred interval (in ms) between polls of
+ *        the pin.
+ *      * read the actual interval between polls, accounting
+ *        for timer resolution etc.
  */
 
+struct gpio_desc *work_to_desc(struct work_struct *ws)
+{
+	return container_of((struct delayed_work *)ws, struct gpio_desc, work);
+}
+
+void gpio_poll_work(struct work_struct *ws)
+{
+	struct gpio_desc	*desc = work_to_desc(ws);
+	int			gpio = desc - gpio_desc;
+
+	int new = gpio_get_value_cansleep(gpio);
+	int old = desc->val;
+
+	if ((new && !old && test_bit(ASYNC_RISING, &desc->flags)) ||
+	    (!new && old && test_bit(ASYNC_FALLING, &desc->flags)))
+		sysfs_notify(&desc->dev->kobj, NULL, "value");
+
+	desc->val = new;
+
+	schedule_delayed_work(&desc->work, desc->timeout);
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
@@ -273,9 +337,185 @@ static ssize_t gpio_value_store(struct device *dev,
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
+		ret = sprintf(buf, "poll\n");
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
+
+	mutex_lock(&sysfs_lock);
+
+	if (sysfs_streq(buf, "irq"))
+		new = ASYNC_MODE_IRQ;
+	else if (sysfs_streq(buf, "poll"))
+		new = ASYNC_MODE_POLL;
+	else if (sysfs_streq(buf, "none"))
+		new = -1;
+	else {
+		status = -EINVAL;
+		goto out;
+	}
+
+	if (test_and_clear_bit(ASYNC_MODE_IRQ, &desc->flags))
+		free_irq(gpio_to_irq(gpio), desc);
+	else if (test_and_clear_bit(ASYNC_MODE_POLL, &desc->flags))
+		cancel_delayed_work(&desc->work);
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
+		desc->val = gpio_get_value_cansleep(gpio);
+		INIT_DELAYED_WORK(&desc->work, gpio_poll_work);
+		schedule_delayed_work(&desc->work, desc->timeout);
+	}
+
+	if (status) {
+		dev_err(dev, "Can't set gpio notification mode to %s\n", buf);
+		goto out;
+	}
+
+	if (new >= 0)
+		set_bit(new, &desc->flags);
+
+out:
+	mutex_unlock(&sysfs_lock);
+	return status ? : size;
+}
+
+static const DEVICE_ATTR(notify, 0644,
+		gpio_notify_show, gpio_notify_store);
+
+static ssize_t gpio_notify_interval_show(struct device *dev,
+		struct device_attribute *attr, char *buf)
+{
+	const struct gpio_desc	*desc = dev_get_drvdata(dev);
+
+	long ms = desc->timeout * 1000 / HZ;
+
+	return sprintf(buf, "%ld\n", ms);
+}
+
+static ssize_t gpio_notify_interval_store(struct device *dev,
+		struct device_attribute *attr, const char *buf, size_t size)
+{
+	struct gpio_desc	*desc = dev_get_drvdata(dev);
+	long			value, rnd;
+	ssize_t			status;
+
+	mutex_lock(&sysfs_lock);
+
+	status = strict_strtol(buf, 0, &value);
+
+	if (status)
+		goto out;
+
+	/* 10ms arbitrary limit on poll interval to stop DoS */
+	if (value < 10) {
+		status = -EINVAL;
+		goto out;
+	}
+
+	/* value will be in ms, convert to jiffies, minimum 1. */
+	desc->timeout = DIV_ROUND_UP(value * HZ, 1000);
+	rnd = desc->timeout * 1000 / HZ;
+
+out:
+	mutex_unlock(&sysfs_lock);
+	return status ? : size;
+}
+
+static const DEVICE_ATTR(notify_interval, 0644,
+		gpio_notify_interval_show, gpio_notify_interval_store);
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
+	&dev_attr_notify_interval.attr,
 	NULL,
 };
 
@@ -469,6 +709,14 @@ int gpio_export(unsigned gpio, bool direction_may_change)
 			status = -ENODEV;
 		if (status == 0)
 			set_bit(FLAG_EXPORT, &desc->flags);
+
+#ifdef CONFIG_GPIO_SYSFS
+		desc->dev = dev;
+		/* 100ms default poll interval */
+		desc->timeout = HZ / 10;
+		set_bit(ASYNC_RISING, &desc->flags);
+		set_bit(ASYNC_FALLING, &desc->flags);
+#endif
 	}
 
 	mutex_unlock(&sysfs_lock);


