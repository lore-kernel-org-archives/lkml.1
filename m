Return-Path: <linux-kernel-owner+w=401wt.eu-S1759587AbYGVFgp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759587AbYGVFgp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2008 01:36:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757320AbYGVFYh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jul 2008 01:24:37 -0400
Received: from ns2.suse.de ([195.135.220.15]:43204 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757316AbYGVFYg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2008 01:24:36 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@suse.de>, Kay Sievers <kay.sievers@vrfy.org>
Subject: [PATCH 45/79] class: rename "interfaces" to "class_interfaces" in internal class structure
Date: Mon, 21 Jul 2008 22:19:09 -0700
Message-Id: <1216703983-21448-45-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.5.6.3
In-Reply-To: <20080722051805.GA17373@suse.de>
References: <20080722051805.GA17373@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This renames the struct class "interfaces" field to be
"class_interfaces" to make things easier when struct bus_type and struct
class merge in the future.  It also makes grepping for fields easier as
well.

Based on an idea from Kay.

Cc: Kay Sievers <kay.sievers@vrfy.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/base/base.h  |    4 ++--
 drivers/base/class.c |    4 ++--
 drivers/base/core.c  |    8 ++++----
 3 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/base/base.h b/drivers/base/base.h
index 586c4ca..670b95a 100644
--- a/drivers/base/base.h
+++ b/drivers/base/base.h
@@ -43,7 +43,7 @@ struct driver_private {
  * @subsys - the struct kset that defines this class.  This is the main kobject
  * @children - list of class_devices associated with this class
  * @class_devices - list of devices associated with this class
- * @interfaces - list of class_interfaces associated with this class
+ * @class_interfaces - list of class_interfaces associated with this class
  * @class_dirs -
  * @sem - semaphore to protect the children, devices, and interfaces lists.
  * @class - pointer back to the struct class that this structure is associated
@@ -56,7 +56,7 @@ struct driver_private {
 struct class_private {
 	struct kset subsys;
 	struct list_head class_devices;
-	struct list_head interfaces;
+	struct list_head class_interfaces;
 	struct kset class_dirs;
 	struct semaphore sem;
 	struct class *class;
diff --git a/drivers/base/class.c b/drivers/base/class.c
index 9947560..48b518e 100644
--- a/drivers/base/class.c
+++ b/drivers/base/class.c
@@ -144,7 +144,7 @@ int class_register(struct class *cls)
 	if (!cp)
 		return -ENOMEM;
 	INIT_LIST_HEAD(&cp->class_devices);
-	INIT_LIST_HEAD(&cp->interfaces);
+	INIT_LIST_HEAD(&cp->class_interfaces);
 	kset_init(&cp->class_dirs);
 	init_MUTEX(&cp->sem);
 	error = kobject_set_name(&cp->subsys.kobj, "%s", cls->name);
@@ -372,7 +372,7 @@ int class_interface_register(struct class_interface *class_intf)
 		return -EINVAL;
 
 	down(&parent->p->sem);
-	list_add_tail(&class_intf->node, &parent->p->interfaces);
+	list_add_tail(&class_intf->node, &parent->p->class_interfaces);
 	if (class_intf->add_dev) {
 		list_for_each_entry(dev, &parent->p->class_devices, node)
 			class_intf->add_dev(dev, class_intf);
diff --git a/drivers/base/core.c b/drivers/base/core.c
index 52d1e71..76fdd41 100644
--- a/drivers/base/core.c
+++ b/drivers/base/core.c
@@ -909,8 +909,8 @@ int device_add(struct device *dev)
 		list_add_tail(&dev->node, &dev->class->p->class_devices);
 
 		/* notify any interfaces that the device is here */
-		list_for_each_entry(class_intf, &dev->class->p->interfaces,
-				    node)
+		list_for_each_entry(class_intf,
+				    &dev->class->p->class_interfaces, node)
 			if (class_intf->add_dev)
 				class_intf->add_dev(dev, class_intf);
 		up(&dev->class->p->sem);
@@ -1016,8 +1016,8 @@ void device_del(struct device *dev)
 
 		down(&dev->class->p->sem);
 		/* notify any interfaces that the device is now gone */
-		list_for_each_entry(class_intf, &dev->class->p->interfaces,
-				    node)
+		list_for_each_entry(class_intf,
+				    &dev->class->p->class_interfaces, node)
 			if (class_intf->remove_dev)
 				class_intf->remove_dev(dev, class_intf);
 		/* remove the device from the class list */
-- 
1.5.6.3

