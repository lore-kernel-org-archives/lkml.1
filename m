Return-Path: <linux-kernel-owner+w=401wt.eu-S1756027AbZGNT00@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756027AbZGNT00 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jul 2009 15:26:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754543AbZGNT00
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Jul 2009 15:26:26 -0400
Received: from mx1.emlix.com ([193.175.82.87]:49125 "EHLO mx1.emlix.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753815AbZGNT0Z convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jul 2009 15:26:25 -0400
From: =?utf-8?q?Daniel=20Gl=C3=B6ckner?= <dg@emlix.com>
To: David Brownell <dbrownell@users.sourceforge.net>
Cc: linux-kernel@vger.kernel.org, Ben Nizette <bn@niasdigital.com>,
       Jani Nikula <ext-jani.1.nikula@nokia.com>,
       =?utf-8?q?Daniel=20Gl=C3=B6ckner?= <dg@emlix.com>
Subject: [PATCH v3] gpiolib: allow poll(2) on gpio value
Date: Tue, 14 Jul 2009 21:26:12 +0200
Message-Id: <1247599572-23209-1-git-send-email-dg@emlix.com>
In-Reply-To: <1244637376-24666-1-git-send-email-dg@emlix.com>
References: <1244637376-24666-1-git-send-email-dg@emlix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Organization: emlix gmbh, Goettingen, Germany
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Many gpio chips allow to generate interrupts when the value of a pin
changes. This patch gives usermode application the opportunity to make
use of this feature by calling poll(2) on the /sys/class/gpio/gpioN/value
sysfs file. The edge to trigger can be set in the edge file in the same
directory. Possible values are "none", "rising", "falling", and "both".

Using level triggers is not possible with current sysfs as poll will
not return if the value did not change. On the other hand edge triggers
are relative to the last read by the application and not to the start
of poll. So if there was an event between read and poll, poll will
return immediately.

Changes compared to v2:
- use idr to store pointer to poll_desc
- use upper bits of gpio_desc.flags to store id for idr
- exit early from gpio_edge_store on bad string
- more whitespace changes

Changes of v2 compared to v1:
- use workqueue to call sysfs_notify_dirent as it takes a spinlock
- move reconfiguration into separate function
- allocate work_struct & co. as needed
- wrap additional element in gpio_desc in #ifdef CONFIG_GPIO_SYSFS
- rename poll_edge to edge
- update Documentation/ABI/testing/sysfs-gpio as well
- refer to poll syscall as "poll(2)"
- use BIT() and define trigger mask for more readable expressions
- whitespace changes

Signed-off-by: Daniel Glöckner <dg@emlix.com>
---
 Documentation/ABI/testing/sysfs-gpio |    1 +
 Documentation/gpio.txt               |    7 +
 drivers/gpio/gpiolib.c               |  205 +++++++++++++++++++++++++++++++++-
 3 files changed, 209 insertions(+), 4 deletions(-)


As requested in previous versions I am now using an idr to reduce the
memory footprint. Currently all 25 unused bits of the flags element are
used to store the id. When new flags are needed, this can be reduced.
For simplicity the code assumes the id is in the upper bits.

I tested v3 on a s6105 that I have sitting on my table.
Former revisions have been tested on an i.MX1 as well.

  Daniel


diff --git a/Documentation/ABI/testing/sysfs-gpio b/Documentation/ABI/testing/sysfs-gpio
index 8aab809..80f4c94 100644
--- a/Documentation/ABI/testing/sysfs-gpio
+++ b/Documentation/ABI/testing/sysfs-gpio
@@ -19,6 +19,7 @@ Description:
 	/gpioN ... for each exported GPIO #N
 	    /value ... always readable, writes fail for input GPIOs
 	    /direction ... r/w as: in, out (default low); write: high, low
+	    /edge ... r/w as: none, falling, rising, both
 	/gpiochipN ... for each gpiochip; #N is its first GPIO
 	    /base ... (r/o) same as N
 	    /label ... (r/o) descriptive, not necessarily unique
diff --git a/Documentation/gpio.txt b/Documentation/gpio.txt
index e4b6985..bcf12fa 100644
--- a/Documentation/gpio.txt
+++ b/Documentation/gpio.txt
@@ -524,6 +524,13 @@ and have the following read/write attributes:
 		is configured as an output, this value may be written;
 		any nonzero value is treated as high.
 
+	"edge" ... reads as either "none", "rising", "falling", or
+		"both". Write these strings to select the signal edge(s)
+		that will make poll(2) on the "value" file return.
+
+		This file exists only if the pin can be configured as an
+		interrupt generating input pin.
+
 GPIO controllers have paths like /sys/class/gpio/chipchip42/ (for the
 controller implementing GPIOs starting at #42) and have the following
 read-only attributes:
diff --git a/drivers/gpio/gpiolib.c b/drivers/gpio/gpiolib.c
index 51a8d41..73d45b5 100644
--- a/drivers/gpio/gpiolib.c
+++ b/drivers/gpio/gpiolib.c
@@ -1,5 +1,6 @@
 #include <linux/kernel.h>
 #include <linux/module.h>
+#include <linux/interrupt.h>
 #include <linux/irq.h>
 #include <linux/spinlock.h>
 #include <linux/device.h>
@@ -7,6 +8,7 @@
 #include <linux/debugfs.h>
 #include <linux/seq_file.h>
 #include <linux/gpio.h>
+#include <linux/idr.h>
 
 
 /* Optional implementation infrastructure for GPIO interfaces.
@@ -49,6 +51,12 @@ struct gpio_desc {
 #define FLAG_RESERVED	2
 #define FLAG_EXPORT	3	/* protected by sysfs_lock */
 #define FLAG_SYSFS	4	/* exported via /sys/class/gpio/control */
+#define FLAG_TRIG_FALL	5	/* trigger on falling edge */
+#define FLAG_TRIG_RISE	6	/* trigger on rising edge */
+#define PDESC_ID_SHIFT	7	/* add new flags before this one */
+
+#define GPIO_FLAGS_MASK		((1 << PDESC_ID_SHIFT) - 1)
+#define GPIO_TRIGGER_MASK	(BIT(FLAG_TRIG_FALL) | BIT(FLAG_TRIG_RISE))
 
 #ifdef CONFIG_DEBUG_FS
 	const char		*label;
@@ -56,6 +64,15 @@ struct gpio_desc {
 };
 static struct gpio_desc gpio_desc[ARCH_NR_GPIOS];
 
+#ifdef CONFIG_GPIO_SYSFS
+struct poll_desc {
+	struct work_struct	work;
+	struct sysfs_dirent	*value_sd;
+};
+
+static struct idr pdesc_idr;
+#endif
+
 static inline void desc_set_label(struct gpio_desc *d, const char *label)
 {
 #ifdef CONFIG_DEBUG_FS
@@ -188,10 +205,10 @@ static DEFINE_MUTEX(sysfs_lock);
  *   /value
  *      * always readable, subject to hardware behavior
  *      * may be writable, as zero/nonzero
- *
- * REVISIT there will likely be an attribute for configuring async
- * notifications, e.g. to specify polling interval or IRQ trigger type
- * that would for example trigger a poll() on the "value".
+ *   /edge
+ *      * configures behavior of poll(2) on /value
+ *      * available only if pin can generate IRQs on input
+ *      * is read/write as "none", "falling", "rising", or "both"
  */
 
 static ssize_t gpio_direction_show(struct device *dev,
@@ -288,6 +305,176 @@ static ssize_t gpio_value_store(struct device *dev,
 static /*const*/ DEVICE_ATTR(value, 0644,
 		gpio_value_show, gpio_value_store);
 
+static irqreturn_t gpio_sysfs_irq(int irq, void *priv)
+{
+	struct work_struct	*work = priv;
+
+	schedule_work(work);
+	return IRQ_HANDLED;
+}
+
+static void gpio_notify_sysfs(struct work_struct *work)
+{
+	struct poll_desc	*pdesc;
+
+	pdesc = container_of(work, struct poll_desc, work);
+	sysfs_notify_dirent(pdesc->value_sd);
+}
+
+static int gpio_setup_irq(struct gpio_desc *desc, struct device *dev,
+		unsigned long gpio_flags)
+{
+	struct poll_desc *pdesc;
+	unsigned long	irq_flags;
+	int		ret, irq, id;
+
+	if ((desc->flags & GPIO_TRIGGER_MASK) == gpio_flags)
+		return 0;
+
+	irq = gpio_to_irq(desc - gpio_desc);
+	if (irq < 0)
+		return -EIO;
+
+	id = desc->flags >> PDESC_ID_SHIFT;
+	pdesc = idr_find(&pdesc_idr, id);
+	if (pdesc) {
+		free_irq(irq, &pdesc->work);
+		cancel_work_sync(&pdesc->work);
+	}
+
+	desc->flags &= ~GPIO_TRIGGER_MASK;
+
+	if (!gpio_flags) {
+		ret = 0;
+		goto free_sd;
+	}
+
+	irq_flags = IRQF_SHARED;
+	if (test_bit(FLAG_TRIG_FALL, &gpio_flags))
+		irq_flags |= IRQF_TRIGGER_FALLING;
+	if (test_bit(FLAG_TRIG_RISE, &gpio_flags))
+		irq_flags |= IRQF_TRIGGER_RISING;
+
+	if (!pdesc) {
+		pdesc = kmalloc(sizeof(struct poll_desc), GFP_KERNEL);
+		if (!pdesc) {
+			ret = -ENOMEM;
+			goto err_out;
+		}
+
+		do {
+			ret = -ENOMEM;
+			if (idr_pre_get(&pdesc_idr, GFP_KERNEL))
+				ret = idr_get_new_above(&pdesc_idr, pdesc, 1,
+							&id);
+		} while (ret == -EAGAIN);
+
+		if (ret)
+			goto free_mem;
+
+		desc->flags &= GPIO_FLAGS_MASK;
+		desc->flags |= (unsigned long)id << PDESC_ID_SHIFT;
+
+		if (desc->flags >> PDESC_ID_SHIFT != id) {
+			ret = -ERANGE;
+			goto free_id;
+		}
+
+		pdesc->value_sd = sysfs_get_dirent(dev->kobj.sd,
+							 "value");
+		if (!pdesc->value_sd) {
+			ret = -ENODEV;
+			goto free_id;
+		}
+		INIT_WORK(&pdesc->work, gpio_notify_sysfs);
+	}
+
+	ret = request_irq(irq, gpio_sysfs_irq, irq_flags,
+			  "gpiolib", &pdesc->work);
+	if (ret)
+		goto free_sd;
+
+	desc->flags |= gpio_flags;
+	return 0;
+
+free_sd:
+	sysfs_put(pdesc->value_sd);
+free_id:
+	idr_remove(&pdesc_idr, id);
+	desc->flags &= GPIO_FLAGS_MASK;
+free_mem:
+	kfree(pdesc);
+err_out:
+	return ret;
+}
+
+static const struct {
+	const char *name;
+	unsigned long flags;
+} trigger_types[] = {
+	{ "none",    0 },
+	{ "falling", BIT(FLAG_TRIG_FALL) },
+	{ "rising",  BIT(FLAG_TRIG_RISE) },
+	{ "both",    BIT(FLAG_TRIG_FALL) | BIT(FLAG_TRIG_RISE) },
+};
+
+static ssize_t gpio_edge_show(struct device *dev,
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
+
+		status = 0;
+		for (i = 0; i < ARRAY_SIZE(trigger_types); i++)
+			if ((desc->flags & GPIO_TRIGGER_MASK)
+					== trigger_types[i].flags) {
+				status = sprintf(buf, "%s\n",
+						 trigger_types[i].name);
+				break;
+			}
+	}
+
+	mutex_unlock(&sysfs_lock);
+	return status;
+}
+
+static ssize_t gpio_edge_store(struct device *dev,
+		struct device_attribute *attr, const char *buf, size_t size)
+{
+	struct gpio_desc	*desc = dev_get_drvdata(dev);
+	ssize_t			status;
+	int			i;
+
+	for (i = 0; i < ARRAY_SIZE(trigger_types); i++)
+		if (sysfs_streq(trigger_types[i].name, buf))
+			goto found;
+	return -EINVAL;
+
+found:
+	mutex_lock(&sysfs_lock);
+
+	if (!test_bit(FLAG_EXPORT, &desc->flags))
+		status = -EIO;
+	else {
+		status = gpio_setup_irq(desc, dev, trigger_types[i].flags);
+		if (!status)
+			status = size;
+	}
+
+	mutex_unlock(&sysfs_lock);
+
+	return status;
+}
+
+static DEVICE_ATTR(edge, 0644, gpio_edge_show, gpio_edge_store);
+
 static const struct attribute *gpio_attrs[] = {
 	&dev_attr_direction.attr,
 	&dev_attr_value.attr,
@@ -481,6 +668,13 @@ int gpio_export(unsigned gpio, bool direction_may_change)
 			else
 				status = device_create_file(dev,
 						&dev_attr_value);
+
+			if (!status && gpio_to_irq(gpio) >= 0 &&
+					(direction_may_change ||
+					!test_bit(FLAG_IS_OUT, &desc->flags)))
+				status = device_create_file(dev,
+						&dev_attr_edge);
+
 			if (status != 0)
 				device_unregister(dev);
 		} else
@@ -527,6 +721,7 @@ void gpio_unexport(unsigned gpio)
 
 		dev = class_find_device(&gpio_class, NULL, desc, match_export);
 		if (dev) {
+			gpio_setup_irq(desc, dev, 0);
 			clear_bit(FLAG_EXPORT, &desc->flags);
 			put_device(dev);
 			device_unregister(dev);
@@ -611,6 +806,8 @@ static int __init gpiolib_sysfs_init(void)
 	unsigned long	flags;
 	unsigned	gpio;
 
+	idr_init(&pdesc_idr);
+
 	status = class_register(&gpio_class);
 	if (status < 0)
 		return status;
-- 
1.6.1.3

