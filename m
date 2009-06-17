Return-Path: <linux-kernel-owner+w=401wt.eu-S1763670AbZFQJmR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763670AbZFQJmR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jun 2009 05:42:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756275AbZFQJmF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Jun 2009 05:42:05 -0400
Received: from smtp.nokia.com ([192.100.122.230]:51559 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752693AbZFQJmE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jun 2009 05:42:04 -0400
From: Jani Nikula <ext-jani.1.nikula@nokia.com>
To: david-b@pacbell.net, linux-kernel@vger.kernel.org
Cc: ext-jani.1.nikula@nokia.com
Subject: [PATCH RESEND] gpiolib: allow exported GPIO nodes to be named using sysfs links
Date: Wed, 17 Jun 2009 12:41:33 +0300
Message-Id: <1245231693-26530-1-git-send-email-ext-jani.1.nikula@nokia.com>
X-Mailer: git-send-email 1.6.3.2
X-OriginalArrivalTime: 17 Jun 2009 09:41:35.0848 (UTC) FILETIME=[CE2F5680:01C9EF2F]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 926b663ce8215ba448960e1ff6e58b67a2c3b99b (gpiolib: allow GPIOs to
be named) already provides naming on the chip level. This patch provides
more flexibility by allowing multiple names where ever in sysfs on a per
GPIO basis.

Adapted from David Brownell's comments on a similar concept:
http://lkml.org/lkml/2009/4/20/203.

Signed-off-by: Jani Nikula <ext-jani.1.nikula@nokia.com>
---
 Documentation/gpio.txt     |   10 +++++++++
 drivers/gpio/gpiolib.c     |   48 ++++++++++++++++++++++++++++++++++++++++++++
 include/asm-generic/gpio.h |    8 +++++++
 include/linux/gpio.h       |    9 ++++++++
 4 files changed, 75 insertions(+), 0 deletions(-)

diff --git a/Documentation/gpio.txt b/Documentation/gpio.txt
index e4b6985..566edaa 100644
--- a/Documentation/gpio.txt
+++ b/Documentation/gpio.txt
@@ -555,6 +555,11 @@ requested using gpio_request():
 	/* reverse gpio_export() */
 	void gpio_unexport();
 
+	/* create a sysfs link to an exported GPIO node */
+	int gpio_export_link(struct device *dev, const char *name,
+		unsigned gpio)
+
+
 After a kernel driver requests a GPIO, it may only be made available in
 the sysfs interface by gpio_export().  The driver can control whether the
 signal direction may change.  This helps drivers prevent userspace code
@@ -563,3 +568,8 @@ from accidentally clobbering important system state.
 This explicit exporting can help with debugging (by making some kinds
 of experiments easier), or can provide an always-there interface that's
 suitable for documenting as part of a board support package.
+
+After the GPIO has been exported, gpio_export_link() allows creating
+symlinks from elsewhere in sysfs to the GPIO sysfs node.  Drivers can
+use this to provide the interface under their own device in sysfs with
+a descriptive name.
diff --git a/drivers/gpio/gpiolib.c b/drivers/gpio/gpiolib.c
index 51a8d41..860fb95 100644
--- a/drivers/gpio/gpiolib.c
+++ b/drivers/gpio/gpiolib.c
@@ -505,6 +505,54 @@ static int match_export(struct device *dev, void *data)
 }
 
 /**
+ * gpio_export_link - create a sysfs link to an exported GPIO node
+ * @dev: device under which to create symlink
+ * @name: name of the symlink
+ * @gpio: gpio to create symlink to, already exported
+ *
+ * Set up a symlink from /sys/.../dev/name to /sys/class/gpio/gpioN
+ * node. Caller is responsible for unlinking.
+ *
+ * Returns zero on success, else an error.
+ */
+int gpio_export_link(struct device *dev, const char *name, unsigned gpio)
+{
+	struct gpio_desc	*desc;
+	int			status = -EINVAL;
+
+	BUG_ON(dev == NULL);
+	BUG_ON(name == NULL);
+
+	if (!gpio_is_valid(gpio))
+		goto done;
+
+	mutex_lock(&sysfs_lock);
+
+	desc = &gpio_desc[gpio];
+
+	if (test_bit(FLAG_EXPORT, &desc->flags)) {
+		struct device *tdev;
+
+		tdev = class_find_device(&gpio_class, NULL, desc, match_export);
+		if (tdev != NULL) {
+			status = sysfs_create_link(&dev->kobj, &tdev->kobj,
+						name);
+		} else {
+			status = -ENODEV;
+		}
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
+EXPORT_SYMBOL_GPL(gpio_export_link);
+
+/**
  * gpio_unexport - reverse effect of gpio_export()
  * @gpio: gpio to make unavailable
  *
diff --git a/include/asm-generic/gpio.h b/include/asm-generic/gpio.h
index d6c379d..9cca378 100644
--- a/include/asm-generic/gpio.h
+++ b/include/asm-generic/gpio.h
@@ -141,6 +141,8 @@ extern int __gpio_to_irq(unsigned gpio);
  * but more typically is configured entirely from userspace.
  */
 extern int gpio_export(unsigned gpio, bool direction_may_change);
+extern int gpio_export_link(struct device *dev, const char *name,
+			unsigned gpio);
 extern void gpio_unexport(unsigned gpio);
 
 #endif	/* CONFIG_GPIO_SYSFS */
@@ -185,6 +187,12 @@ static inline int gpio_export(unsigned gpio, bool direction_may_change)
 	return -ENOSYS;
 }
 
+static inline int gpio_export_link(struct device *dev, const char *name,
+				unsigned gpio)
+{
+	return -ENOSYS;
+}
+
 static inline void gpio_unexport(unsigned gpio)
 {
 }
diff --git a/include/linux/gpio.h b/include/linux/gpio.h
index e10c49a..ff374ce 100644
--- a/include/linux/gpio.h
+++ b/include/linux/gpio.h
@@ -89,6 +89,15 @@ static inline int gpio_export(unsigned gpio, bool direction_may_change)
 	return -EINVAL;
 }
 
+static inline int gpio_export_link(struct device *dev, const char *name,
+				unsigned gpio)
+{
+	/* GPIO can never have been exported */
+	WARN_ON(1);
+	return -EINVAL;
+}
+
+
 static inline void gpio_unexport(unsigned gpio)
 {
 	/* GPIO can never have been exported */
-- 
1.6.3.2

