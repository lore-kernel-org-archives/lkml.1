Return-Path: <linux-kernel-owner+w=401wt.eu-S1754774Ab0AEAli@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754774Ab0AEAli (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jan 2010 19:41:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754766Ab0AEAlc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jan 2010 19:41:32 -0500
Received: from kroah.org ([198.145.64.141]:42399 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754489Ab0AEAf6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jan 2010 19:35:58 -0500
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org, stable-review@kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, Paolo Bonzini <pbonzini@redhat.com>,
       Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 75/97] xen: fix is_disconnected_device/exists_disconnected_device
Date: Mon,  4 Jan 2010 16:33:28 -0800
Message-Id: <1262651630-7354-75-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.6.6
In-Reply-To: <20100105003133.GA7199@kroah.com>
References: <20100105003133.GA7199@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Paolo Bonzini <pbonzini@redhat.com>

commit c6e1971139be1342902873181f3b80a979bfb33b upstream.

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
Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/xen/xenbus/xenbus_probe.c |   13 +++++++------
 1 files changed, 7 insertions(+), 6 deletions(-)

diff --git a/drivers/xen/xenbus/xenbus_probe.c b/drivers/xen/xenbus/xenbus_probe.c
index 3800da7..19bce3e 100644
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
1.6.6

