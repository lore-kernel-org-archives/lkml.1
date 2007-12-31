Return-Path: <linux-kernel-owner+w=401wt.eu-S1753209AbXLaSk2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753209AbXLaSk2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Dec 2007 13:40:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751746AbXLaSkW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 31 Dec 2007 13:40:22 -0500
Received: from iolanthe.rowland.org ([192.131.102.54]:44454 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1750789AbXLaSkV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Dec 2007 13:40:21 -0500
Date: Mon, 31 Dec 2007 13:40:20 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Greg KH <greg@kroah.com>, Andrew Morton <akpm@linux-foundation.org>
cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux-pm mailing list <linux-pm@lists.linux-foundation.org>,
       Kernel development list <linux-kernel@vger.kernel.org>
Subject: [PATCH] Warn about attempts to register/unregister devices during
 system suspend
Message-ID: <Pine.LNX.4.44L0.0712311335360.10555-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch (as1030) prints warning messages in the system log when
drivers try to register or unregister devices during a system sleep
transition.  These actions are now illegal and will either fail or
block (likely leading to deadlock).

Signed-off-by: Alan Stern <stern@rowland.harvard.edu>

---

This patch applies on top of
gregkh-driver-pm-acquire-device-locks-prior-to-suspending.patch.  The
new locking arrangement can cause deadlocks or other errors if drivers
try to do the wrong thing.  With this patch we should easily be able to
tell where the problems are.

Alan Stern


Index: usb-2.6/drivers/base/core.c
===================================================================
--- usb-2.6.orig/drivers/base/core.c
+++ usb-2.6/drivers/base/core.c
@@ -789,8 +789,11 @@ int device_add(struct device *dev)
 	int error;
 
 	error = pm_sleep_lock();
-	if (error)
+	if (error) {
+		dev_warn(dev, "Illegal %s during suspend\n", __FUNCTION__);
+		dump_stack();
 		return error;
+	}
 
 	dev = get_device(dev);
 	if (!dev || !strlen(dev->bus_id)) {
@@ -953,6 +956,13 @@ void device_del(struct device * dev)
 	struct device * parent = dev->parent;
 	struct class_interface *class_intf;
 
+	if (pm_sleep_lock()) {
+		dev_warn(dev, "Illegal %s during suspend\n", __FUNCTION__);
+		dump_stack();
+	} else {
+		pm_sleep_unlock();
+	}
+
 	if (parent)
 		klist_del(&dev->knode_parent);
 	if (MAJOR(dev->devt))

