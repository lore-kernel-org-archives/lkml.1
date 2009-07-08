Return-Path: <linux-kernel-owner+w=401wt.eu-S1753598AbZGHK1y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753598AbZGHK1y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jul 2009 06:27:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753152AbZGHK1o
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Jul 2009 06:27:44 -0400
Received: from mx2.redhat.com ([66.187.237.31]:41609 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752265AbZGHK1n (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jul 2009 06:27:43 -0400
From: Paolo Bonzini <pbonzini@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: pbonzini@redhat.com, Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Subject: [PATCH 1/3 v2] xen: fix is_disconnected_device/exists_disconnected_device
Date: Wed,  8 Jul 2009 12:27:37 +0200
Message-Id: <1247048859-31845-1-git-send-email-pbonzini@redhat.com>
In-Reply-To: <4A5272A6.6090302@citrix.com>
References: <4A5272A6.6090302@citrix.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The logic of is_disconnected_device/exists_disconnected_device is wrong
in that they are used to test whether a device is trying to connect (i.e.
connecting).  For this reason the patch fixes them to not consider a
Closing or Closed device to be connecting.  At the same time the patch
also renames the functions according to what they really do; you could
say a closed device is "disconnected" (the old name), but not "connecting"
(the new name).

This patch is a backport of changeset 909 from the Xenbits tree.

Cc: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
	The code for this series is exactly the same as for v1, just
	split into three separate bisectable patches.

 drivers/xen/xenbus/xenbus_probe.c |   13 +++++++------
 1 files changed, 7 insertions(+), 6 deletions(-)

diff --git a/drivers/xen/xenbus/xenbus_probe.c b/drivers/xen/xenbus/xenbus_probe.c
index d42e25d..c543766 100644
--- a/drivers/xen/xenbus/xenbus_probe.c
+++ b/drivers/xen/xenbus/xenbus_probe.c
@@ -843,7 +843,7 @@ postcore_initcall(xenbus_probe_init);
 
 MODULE_LICENSE("GPL");
 
-static int is_disconnected_device(struct device *dev, void *data)
+static int is_device_connecting(struct device *dev, void *data)
 {
 	struct xenbus_device *xendev = to_xenbus_device(dev);
 	struct device_driver *drv = data;
@@ -861,14 +861,15 @@ static int is_disconnected_device(struct device *dev, void *data)
 		return 0;
 
 	xendrv = to_xenbus_driver(dev->driver);
-	return (xendev->state != XenbusStateConnected ||
-		(xendrv->is_ready && !xendrv->is_ready(xendev)));
+	return (xendev->state < XenbusStateConnected ||
+		(xendev->state == XenbusStateConnected &&
+		 xendrv->is_ready && !xendrv->is_ready(xendev)));
 }
 
-static int exists_disconnected_device(struct device_driver *drv)
+static int exists_connecting_device(struct device_driver *drv)
 {
 	return bus_for_each_dev(&xenbus_frontend.bus, NULL, drv,
-				is_disconnected_device);
+				is_device_connecting);
 }
 
 static int print_device_status(struct device *dev, void *data)
@@ -918,7 +919,7 @@ static void wait_for_devices(struct xenbus_driver *xendrv)
 	if (!ready_to_wait_for_devices || !xen_domain())
 		return;
 
-	while (exists_disconnected_device(drv)) {
+	while (exists_connecting_device(drv)) {
 		if (time_after(jiffies, timeout))
 			break;
 		schedule_timeout_interruptible(HZ/10);
-- 
1.6.2.5


