Return-Path: <linux-kernel-owner+w=401wt.eu-S1759531AbYGVFga@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759531AbYGVFga (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2008 01:36:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757302AbYGVFYd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jul 2008 01:24:33 -0400
Received: from cantor2.suse.de ([195.135.220.15]:43191 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757052AbYGVFYc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2008 01:24:32 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@suse.de>, Kay Sievers <kay.sievers@vrfy.org>
Subject: [PATCH 44/79] class: rename "devices" to "class_devices" in internal class structure
Date: Mon, 21 Jul 2008 22:19:08 -0700
Message-Id: <1216703983-21448-44-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.5.6.3
In-Reply-To: <20080722051805.GA17373@suse.de>
References: <20080722051805.GA17373@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This renames the struct class "devices" field to be "class_devices" to
make things easier when struct bus_type and struct class merge in the
future.  It also makes grepping for fields easier as well.

Based on an idea from Kay.

Cc: Kay Sievers <kay.sievers@vrfy.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/base/base.h  |    4 ++--
 drivers/base/class.c |   10 +++++-----
 drivers/base/core.c  |    2 +-
 3 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/base/base.h b/drivers/base/base.h
index 0ec372a..586c4ca 100644
--- a/drivers/base/base.h
+++ b/drivers/base/base.h
@@ -42,7 +42,7 @@ struct driver_private {
  *
  * @subsys - the struct kset that defines this class.  This is the main kobject
  * @children - list of class_devices associated with this class
- * @devices - list of devices associated with this class
+ * @class_devices - list of devices associated with this class
  * @interfaces - list of class_interfaces associated with this class
  * @class_dirs -
  * @sem - semaphore to protect the children, devices, and interfaces lists.
@@ -55,7 +55,7 @@ struct driver_private {
  */
 struct class_private {
 	struct kset subsys;
-	struct list_head devices;
+	struct list_head class_devices;
 	struct list_head interfaces;
 	struct kset class_dirs;
 	struct semaphore sem;
diff --git a/drivers/base/class.c b/drivers/base/class.c
index 06f09c9..9947560 100644
--- a/drivers/base/class.c
+++ b/drivers/base/class.c
@@ -143,7 +143,7 @@ int class_register(struct class *cls)
 	cp = kzalloc(sizeof(*cp), GFP_KERNEL);
 	if (!cp)
 		return -ENOMEM;
-	INIT_LIST_HEAD(&cp->devices);
+	INIT_LIST_HEAD(&cp->class_devices);
 	INIT_LIST_HEAD(&cp->interfaces);
 	kset_init(&cp->class_dirs);
 	init_MUTEX(&cp->sem);
@@ -290,7 +290,7 @@ int class_for_each_device(struct class *class, struct device *start,
 	if (!class)
 		return -EINVAL;
 	down(&class->p->sem);
-	list_for_each_entry(dev, &class->p->devices, node) {
+	list_for_each_entry(dev, &class->p->class_devices, node) {
 		if (start) {
 			if (start == dev)
 				start = NULL;
@@ -340,7 +340,7 @@ struct device *class_find_device(struct class *class, struct device *start,
 		return NULL;
 
 	down(&class->p->sem);
-	list_for_each_entry(dev, &class->p->devices, node) {
+	list_for_each_entry(dev, &class->p->class_devices, node) {
 		if (start) {
 			if (start == dev)
 				start = NULL;
@@ -374,7 +374,7 @@ int class_interface_register(struct class_interface *class_intf)
 	down(&parent->p->sem);
 	list_add_tail(&class_intf->node, &parent->p->interfaces);
 	if (class_intf->add_dev) {
-		list_for_each_entry(dev, &parent->p->devices, node)
+		list_for_each_entry(dev, &parent->p->class_devices, node)
 			class_intf->add_dev(dev, class_intf);
 	}
 	up(&parent->p->sem);
@@ -393,7 +393,7 @@ void class_interface_unregister(struct class_interface *class_intf)
 	down(&parent->p->sem);
 	list_del_init(&class_intf->node);
 	if (class_intf->remove_dev) {
-		list_for_each_entry(dev, &parent->p->devices, node)
+		list_for_each_entry(dev, &parent->p->class_devices, node)
 			class_intf->remove_dev(dev, class_intf);
 	}
 	up(&parent->p->sem);
diff --git a/drivers/base/core.c b/drivers/base/core.c
index 64c150b..52d1e71 100644
--- a/drivers/base/core.c
+++ b/drivers/base/core.c
@@ -906,7 +906,7 @@ int device_add(struct device *dev)
 	if (dev->class) {
 		down(&dev->class->p->sem);
 		/* tie the class to the device */
-		list_add_tail(&dev->node, &dev->class->p->devices);
+		list_add_tail(&dev->node, &dev->class->p->class_devices);
 
 		/* notify any interfaces that the device is here */
 		list_for_each_entry(class_intf, &dev->class->p->interfaces,
-- 
1.5.6.3

