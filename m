Return-Path: <linux-kernel-owner+w=401wt.eu-S1757854AbZAFWTo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757854AbZAFWTo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2009 17:19:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755880AbZAFWNg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Jan 2009 17:13:36 -0500
Received: from kroah.org ([198.145.64.141]:51219 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755183AbZAFWNf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2009 17:13:35 -0500
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Alan Stern <stern@rowland.harvard.edu>, Kay Sievers <kay.sievers@vrfy.org>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 18/60] Driver core: move the bus notifier call points
Date: Tue,  6 Jan 2009 14:11:37 -0800
Message-Id: <1231279939-32728-18-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.6.0.4
In-Reply-To: <20090106221123.GA32689@kroah.com>
References: <20090106221123.GA32689@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alan Stern <stern@rowland.harvard.edu>

This patch (as1184) changes the location of the notifications in
device_add() and device_del().  Now the BUS_NOTIFY_ADD_DEVICE message
is sent after dpm_sysfs_add(), which is necessary for clients that
want to add attributes to the power/ subdirectory.  The
BUS_NOTIFY_DEL_DEVICE message is correspondingly moved before
dpm_sysfs_remove().

Signed-off-by: Alan Stern <stern@rowland.harvard.edu>
Cc: Kay Sievers <kay.sievers@vrfy.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/base/core.c |   25 ++++++++++++++-----------
 1 files changed, 14 insertions(+), 11 deletions(-)

diff --git a/drivers/base/core.c b/drivers/base/core.c
index 180ff84..ee555d7 100644
--- a/drivers/base/core.c
+++ b/drivers/base/core.c
@@ -894,11 +894,6 @@ int device_add(struct device *dev)
 	if (platform_notify)
 		platform_notify(dev);
 
-	/* notify clients of device entry (new way) */
-	if (dev->bus)
-		blocking_notifier_call_chain(&dev->bus->p->bus_notifier,
-					     BUS_NOTIFY_ADD_DEVICE, dev);
-
 	error = device_create_file(dev, &uevent_attr);
 	if (error)
 		goto attrError;
@@ -926,6 +921,14 @@ int device_add(struct device *dev)
 	if (error)
 		goto DPMError;
 	device_pm_add(dev);
+
+	/* Notify clients of device addition.  This call must come
+	 * after dpm_sysf_add() and before kobject_uevent().
+	 */
+	if (dev->bus)
+		blocking_notifier_call_chain(&dev->bus->p->bus_notifier,
+					     BUS_NOTIFY_ADD_DEVICE, dev);
+
 	kobject_uevent(&dev->kobj, KOBJ_ADD);
 	bus_attach_device(dev);
 	if (parent)
@@ -951,9 +954,6 @@ done:
  DPMError:
 	bus_remove_device(dev);
  BusError:
-	if (dev->bus)
-		blocking_notifier_call_chain(&dev->bus->p->bus_notifier,
-					     BUS_NOTIFY_DEL_DEVICE, dev);
 	device_remove_attrs(dev);
  AttrsError:
 	device_remove_class_symlinks(dev);
@@ -1038,6 +1038,12 @@ void device_del(struct device *dev)
 	struct device *parent = dev->parent;
 	struct class_interface *class_intf;
 
+	/* Notify clients of device removal.  This call must come
+	 * before dpm_sysfs_remove().
+	 */
+	if (dev->bus)
+		blocking_notifier_call_chain(&dev->bus->p->bus_notifier,
+					     BUS_NOTIFY_DEL_DEVICE, dev);
 	device_pm_remove(dev);
 	dpm_sysfs_remove(dev);
 	if (parent)
@@ -1075,9 +1081,6 @@ void device_del(struct device *dev)
 	 */
 	if (platform_notify_remove)
 		platform_notify_remove(dev);
-	if (dev->bus)
-		blocking_notifier_call_chain(&dev->bus->p->bus_notifier,
-					     BUS_NOTIFY_DEL_DEVICE, dev);
 	kobject_uevent(&dev->kobj, KOBJ_REMOVE);
 	cleanup_device_parent(dev);
 	kobject_del(&dev->kobj);
-- 
1.6.0.4

