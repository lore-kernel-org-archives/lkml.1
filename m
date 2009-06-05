Return-Path: <linux-kernel-owner+w=401wt.eu-S1755375AbZFEOgm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755375AbZFEOgm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Jun 2009 10:36:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753294AbZFEOgb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Jun 2009 10:36:31 -0400
Received: from mx1.emlix.com ([193.175.82.87]:48299 "EHLO mx1.emlix.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755218AbZFEOga convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Jun 2009 10:36:30 -0400
From: =?utf-8?q?Daniel=20Gl=C3=B6ckner?= <dg@emlix.com>
To: David Brownell <dbrownell@users.sourceforge.net>
Cc: linux-kernel@vger.kernel.org,
       =?utf-8?q?Daniel=20Gl=C3=B6ckner?= <dg@emlix.com>
Subject: [PATCH] gpiolib: allow poll on gpio value
Date: Fri,  5 Jun 2009 16:36:30 +0200
Message-Id: <1244212590-15620-1-git-send-email-dg@emlix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Organization: emlix gmbh, Goettingen, Germany
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Many gpio chips allow to generate interrupts when the value of a pin
changes. This patch gives usermode application the opportunity to make
use of this feature by calling poll on the /sys/class/gpio/gpioN/value
sysfs file. The edge to trigger can be set in the poll_edge file in the
same directory. Possible values are "none", "rising", "falling", and
"both".

Using level triggers is not possible with current sysfs as poll will
not return if the value did not change. On the other hand edge triggers
are relative to the last read by the application and not to the start
of poll. So if there was an event between read and poll, poll will
return immediately.

Signed-off-by: Daniel Glöckner <dg@emlix.com>
---
 Documentation/gpio.txt |    7 ++
 drivers/gpio/gpiolib.c |  146 ++++++++++++++++++++++++++++++++++++++++++++++--
 2 files changed, 148 insertions(+), 5 deletions(-)

diff --git a/Documentation/gpio.txt b/Documentation/gpio.txt
index 145c25a..eb2eb31 100644
--- a/Documentation/gpio.txt
+++ b/Documentation/gpio.txt
@@ -524,6 +524,13 @@ and have the following read/write attributes:
 		is configured as an output, this value may be written;
 		any nonzero value is treated as high.
 
+	"poll_edge" ... reads as either "none", "rising", "falling", or
+		"both". Write these strings to select the signal edge(s)
+		that will make poll on the "value" file return.
+
+		This file exists only if the pin can be configured as an
+		interrupt generating input pin.
+
 GPIO controllers have paths like /sys/class/gpio/chipchip42/ (for the
 controller implementing GPIOs starting at #42) and have the following
 read-only attributes:
diff --git a/drivers/gpio/gpiolib.c b/drivers/gpio/gpiolib.c
index 51a8d41..9a37835 100644
--- a/drivers/gpio/gpiolib.c
+++ b/drivers/gpio/gpiolib.c
@@ -1,5 +1,6 @@
 #include <linux/kernel.h>
 #include <linux/module.h>
+#include <linux/interrupt.h>
 #include <linux/irq.h>
 #include <linux/spinlock.h>
 #include <linux/device.h>
@@ -49,10 +50,14 @@ struct gpio_desc {
 #define FLAG_RESERVED	2
 #define FLAG_EXPORT	3	/* protected by sysfs_lock */
 #define FLAG_SYSFS	4	/* exported via /sys/class/gpio/control */
+#define FLAG_TRIG_FALL	5	/* trigger on falling edge */
+#define FLAG_TRIG_RISE	6	/* trigger on rising edge */
 
 #ifdef CONFIG_DEBUG_FS
 	const char		*label;
 #endif
+
+	struct sysfs_dirent	*value_sd;
 };
 static struct gpio_desc gpio_desc[ARCH_NR_GPIOS];
 
@@ -188,10 +193,10 @@ static DEFINE_MUTEX(sysfs_lock);
  *   /value
  *      * always readable, subject to hardware behavior
  *      * may be writable, as zero/nonzero
- *
- * REVISIT there will likely be an attribute for configuring async
- * notifications, e.g. to specify polling interval or IRQ trigger type
- * that would for example trigger a poll() on the "value".
+ *   /poll_edge
+ *      * configures behavior of poll on /value
+ *      * available only if pin can generate IRQs on input
+ *      * is read/write as "none", "falling", "rising", or "both"
  */
 
 static ssize_t gpio_direction_show(struct device *dev,
@@ -288,6 +293,106 @@ static ssize_t gpio_value_store(struct device *dev,
 static /*const*/ DEVICE_ATTR(value, 0644,
 		gpio_value_show, gpio_value_store);
 
+static irqreturn_t gpio_sysfs_irq(int irq, void *priv)
+{
+	struct gpio_desc *desc = priv;
+
+	sysfs_notify_dirent(desc->value_sd);
+	return IRQ_HANDLED;
+}
+
+static const struct {
+	const char *name;
+	unsigned long flags;
+} trigger_types[] = {
+	{ "none",    0 },
+	{ "falling", 1 << FLAG_TRIG_FALL },
+	{ "rising",  1 << FLAG_TRIG_RISE },
+	{ "both",    (1 << FLAG_TRIG_FALL) | (1 << FLAG_TRIG_RISE) },
+};
+
+static ssize_t gpio_trigger_show(struct device *dev,
+		struct device_attribute *attr, char *buf)
+{
+	const struct gpio_desc	*desc = dev_get_drvdata(dev);
+	ssize_t			status;
+
+	mutex_lock(&sysfs_lock);
+
+	if (!test_bit(FLAG_EXPORT, &desc->flags))
+		status = -EIO;
+	else {
+		int i;
+		status = 0;
+		for (i = 0; i < ARRAY_SIZE(trigger_types); i++)
+			if ((desc->flags & ((1 << FLAG_TRIG_FALL)
+					 | (1 << FLAG_TRIG_RISE)))
+			     == trigger_types[i].flags) {
+				status = sprintf(buf, "%s\n",
+						 trigger_types[i].name);
+				break;
+		}
+	}
+
+	mutex_unlock(&sysfs_lock);
+	return status;
+}
+
+static ssize_t gpio_trigger_store(struct device *dev,
+		struct device_attribute *attr, const char *buf, size_t size)
+{
+	struct gpio_desc	*desc = dev_get_drvdata(dev);
+	ssize_t			status;
+	int			i;
+
+	for (i = 0; i < ARRAY_SIZE(trigger_types); i++)
+		if (sysfs_streq(trigger_types[i].name, buf))
+			break;
+
+	mutex_lock(&sysfs_lock);
+
+	if (!test_bit(FLAG_EXPORT, &desc->flags))
+		status = -EIO;
+	else if (i == ARRAY_SIZE(trigger_types))
+		status = -EINVAL;
+	else {
+		int irq = gpio_to_irq(desc - gpio_desc);
+		if (irq >= 0) {
+			if (desc->flags & ((1 << FLAG_TRIG_FALL)
+					 | (1 << FLAG_TRIG_RISE)))
+				free_irq(irq, desc);
+
+			desc->flags &= ~((1 << FLAG_TRIG_FALL)
+				       | (1 << FLAG_TRIG_RISE));
+
+			if (trigger_types[i].flags & ((1 << FLAG_TRIG_FALL)
+						    | (1 << FLAG_TRIG_RISE))) {
+				unsigned long flags = IRQF_SHARED;
+
+				if (test_bit(FLAG_TRIG_FALL,
+					     &trigger_types[i].flags))
+					flags |= IRQF_TRIGGER_FALLING;
+				if (test_bit(FLAG_TRIG_RISE,
+					     &trigger_types[i].flags))
+					flags |= IRQF_TRIGGER_RISING;
+				status = request_irq(irq, gpio_sysfs_irq, flags,
+						     "gpiolib", desc);
+				if (!status) {
+					desc->flags |= trigger_types[i].flags;
+					status = size;
+				}
+			} else
+				status = size;
+		} else
+			status = -EIO;
+	}
+
+	mutex_unlock(&sysfs_lock);
+	return status;
+}
+
+static DEVICE_ATTR(poll_edge, 0644, gpio_trigger_show, gpio_trigger_store);
+
 static const struct attribute *gpio_attrs[] = {
 	&dev_attr_direction.attr,
 	&dev_attr_value.attr,
@@ -481,8 +586,28 @@ int gpio_export(unsigned gpio, bool direction_may_change)
 			else
 				status = device_create_file(dev,
 						&dev_attr_value);
-			if (status != 0)
+
+			if (!status) {
+				desc->value_sd = sysfs_get_dirent(dev->kobj.sd,
+								  "value");
+				if (!desc->value_sd)
+					status = -ENODEV;
+			}
+
+			if (!status
+			    && gpio_to_irq(gpio) >= 0
+			    && (direction_may_change
+				|| !test_bit(FLAG_IS_OUT, &desc->flags)))
+				status = device_create_file(dev,
+						&dev_attr_poll_edge);
+
+			if (status != 0) {
+				if (desc->value_sd) {
+					sysfs_put(desc->value_sd);
+					desc->value_sd = NULL;
+				}
 				device_unregister(dev);
+			}
 		} else
 			status = -ENODEV;
 		if (status == 0)
@@ -527,6 +652,17 @@ void gpio_unexport(unsigned gpio)
 
 		dev = class_find_device(&gpio_class, NULL, desc, match_export);
 		if (dev) {
+			if (desc->flags & ((1 << FLAG_TRIG_FALL)
+					 | (1 << FLAG_TRIG_RISE))) {
+				free_irq(gpio_to_irq(gpio), desc);
+				desc->flags &= ~((1 << FLAG_TRIG_FALL)
+					       | (1 << FLAG_TRIG_RISE));
+			}
+
+			if (desc->value_sd) {
+				sysfs_put(desc->value_sd);
+				desc->value_sd = NULL;
+			}
 			clear_bit(FLAG_EXPORT, &desc->flags);
 			put_device(dev);
 			device_unregister(dev);
-- 
1.6.1.3

