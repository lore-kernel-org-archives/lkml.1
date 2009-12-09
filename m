Return-Path: <linux-kernel-owner+w=401wt.eu-S1756072AbZLINuI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756072AbZLINuI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Dec 2009 08:50:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756048AbZLINuF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Dec 2009 08:50:05 -0500
Received: from smtp.nokia.com ([192.100.105.134]:48430 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755987AbZLINuB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Dec 2009 08:50:01 -0500
From: Jani Nikula <ext-jani.1.nikula@nokia.com>
To: dbrownell@users.sourceforge.net, gregkh@suse.de
Cc: linux-kernel@vger.kernel.org, dsilvers@simtec.co.uk, ben@simtec.co.uk,
       Artem.Bityutskiy@nokia.com, akpm@linux-foundation.org,
       ext-jani.1.nikula@nokia.com
Subject: [PATCH 2/3] gpiolib: add support for having symlinks under gpio class directory
Date: Wed,  9 Dec 2009 15:49:03 +0200
Message-Id: <71eff9c88d3fec3daa218341c83c19a106ee1f62.1260364108.git.ext-jani.1.nikula@nokia.com>
X-Mailer: git-send-email 1.6.5.2
In-Reply-To: <30f1f2c867089bb78cdb9fe3c2032c091bed106a.1260364108.git.ext-jani.1.nikula@nokia.com>
References: <cover.1260364108.git.ext-jani.1.nikula@nokia.com>
 <30f1f2c867089bb78cdb9fe3c2032c091bed106a.1260364108.git.ext-jani.1.nikula@nokia.com>
In-Reply-To: <cover.1260364108.git.ext-jani.1.nikula@nokia.com>
References: <cover.1260364108.git.ext-jani.1.nikula@nokia.com>
X-OriginalArrivalTime: 09 Dec 2009 13:49:15.0513 (UTC) FILETIME=[65868690:01CA78D6]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Extend the functionality of gpio_export_link() to allow exported GPIOs
to have names using sysfs links under /sys/class/gpio.

Also automatically remove links on gpio_unexport().

Signed-off-by: Jani Nikula <ext-jani.1.nikula@nokia.com>
---
 drivers/gpio/gpiolib.c |   95 +++++++++++++++++++++++++++++++++++++++++++++---
 1 files changed, 90 insertions(+), 5 deletions(-)

diff --git a/drivers/gpio/gpiolib.c b/drivers/gpio/gpiolib.c
index 50de0f5..f254195 100644
--- a/drivers/gpio/gpiolib.c
+++ b/drivers/gpio/gpiolib.c
@@ -9,6 +9,8 @@
 #include <linux/seq_file.h>
 #include <linux/gpio.h>
 #include <linux/idr.h>
+#include <linux/list.h>
+#include "../base/base.h"
 
 
 /* Optional implementation infrastructure for GPIO interfaces.
@@ -608,6 +610,84 @@ static struct class gpio_class = {
 	.class_attrs =	gpio_class_attrs,
 };
 
+/* sysfs link */
+struct sysfs_link {
+	unsigned gpio;
+	struct device *dev;
+	const char *name;
+	struct list_head node;
+};
+
+/* list of links to gpio sysfs nodes, protected by sysfs_mutex */
+static LIST_HEAD(sysfs_links);
+
+/* create link, store info */
+static int create_link(unsigned gpio, struct device *dev,
+		struct kobject *target, const char *name)
+{
+	struct sysfs_link	*link;
+	int			status = -ENOMEM;
+
+	link = kzalloc(sizeof(*link), GFP_KERNEL);
+	if (link == NULL)
+		goto err0;
+
+	link->name = kstrdup(name, GFP_KERNEL);
+	if (link->name == NULL)
+		goto err1;
+
+	link->gpio = gpio;
+	link->dev = dev;
+
+	if (dev != NULL) {
+		dev = get_device(dev);
+		if (dev == NULL) {
+			status = -ENODEV;
+			goto err2;
+		}
+		status = sysfs_create_link(&dev->kobj, target, name);
+	} else {
+		status = class_create_link(&gpio_class, target, name);
+	}
+
+	if (status)
+		goto err3;
+
+	list_add(&link->node, &sysfs_links);
+
+	return 0;
+
+err3:
+	if (dev != NULL)
+		put_device(dev);
+err2:
+	kfree(link->name);
+err1:
+	kfree(link);
+err0:
+
+	return status;
+}
+
+/* remove symlinks pointing to gpio */
+static void remove_links(unsigned gpio)
+{
+	struct sysfs_link	*link, *tmp;
+
+	list_for_each_entry_safe(link, tmp, &sysfs_links, node) {
+		if (link->gpio == gpio) {
+			if (link->dev != NULL) {
+				sysfs_remove_link(&link->dev->kobj, link->name);
+				put_device(link->dev);
+			} else {
+				class_remove_link(&gpio_class, link->name);
+			}
+			list_del(&link->node);
+			kfree(link->name);
+			kfree(link);
+		}
+	}
+}
 
 /**
  * gpio_export - export a GPIO through sysfs
@@ -701,12 +781,17 @@ static int match_export(struct device *dev, void *data)
 
 /**
  * gpio_export_link - create a sysfs link to an exported GPIO node
- * @dev: device under which to create symlink
+ * @dev: device under which to create symlink, or NULL for gpio class
  * @name: name of the symlink
  * @gpio: gpio to create symlink to, already exported
  *
- * Set up a symlink from /sys/.../dev/name to /sys/class/gpio/gpioN
- * node. Caller is responsible for unlinking.
+ * If @dev is non-NULL, set up a symlink from /sys/.../dev/name to
+ * /sys/class/gpio/gpioN node.
+ *
+ * If @dev is NULL, set up the symlink from /sys/class/gpio/name to
+ * /sys/class/gpio/gpioN node.
+ *
+ * Symlinks are removed on gpio_unexport() on the @gpio.
  *
  * Returns zero on success, else an error.
  */
@@ -727,8 +812,7 @@ int gpio_export_link(struct device *dev, const char *name, unsigned gpio)
 
 		tdev = class_find_device(&gpio_class, NULL, desc, match_export);
 		if (tdev != NULL) {
-			status = sysfs_create_link(&dev->kobj, &tdev->kobj,
-						name);
+			status = create_link(gpio, dev, &tdev->kobj, name);
 		} else {
 			status = -ENODEV;
 		}
@@ -769,6 +853,7 @@ void gpio_unexport(unsigned gpio)
 		if (dev) {
 			gpio_setup_irq(desc, dev, 0);
 			clear_bit(FLAG_EXPORT, &desc->flags);
+			remove_links(gpio);
 			put_device(dev);
 			device_unregister(dev);
 			status = 0;
-- 
1.6.5.2

