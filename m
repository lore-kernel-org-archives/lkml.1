Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752915Ab0CFQtz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Mar 2010 11:49:55 -0500
Received: from www84.your-server.de ([213.133.104.84]:34618 "EHLO
	www84.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752281Ab0CFQty (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Mar 2010 11:49:54 -0500
Subject: [PATCH] fix race condition in drivers/base/dd.c
From: Stefani Seibold <stefani@seibold.net>
To: linux-kernel <linux-kernel@vger.kernel.org>,
       Greg Kroah-Hartman <gregkh@suse.de>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Sat, 06 Mar 2010 17:50:14 +0100
Message-ID: <1267894214.18869.1.camel@wall-e>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: stefani@seibold.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fix a potential race condition in the driver_bound() function
in the file driver/base/dd.c. 

The broadcast of the BUS_NOTIFY_BOUND_DRIVER notifier should be done
after adding the new device to the driver list. Otherwise notifier
listener will fail if they use functions like usb_find_interface().

The patch is against kernel 2.6.33. Please merge it.

Signed-off-by: Stefani Seibold <stefani@seibold.net>
---
 dd.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- linux-2.6.33.orig/drivers/base/dd.c	2010-02-24 19:52:17.000000000 +0100
+++ linux-2.6.33/drivers/base/dd.c	2010-02-28 20:25:06.595037275 +0100
@@ -40,11 +40,11 @@ static void driver_bound(struct device *
 	pr_debug("driver: '%s': %s: bound to device '%s'\n", dev_name(dev),
 		 __func__, dev->driver->name);
 
+	klist_add_tail(&dev->p->knode_driver, &dev->driver->p->klist_devices);
+
 	if (dev->bus)
 		blocking_notifier_call_chain(&dev->bus->p->bus_notifier,
 					     BUS_NOTIFY_BOUND_DRIVER, dev);
-
-	klist_add_tail(&dev->p->knode_driver, &dev->driver->p->klist_devices);
 }
 
 static int driver_sysfs_add(struct device *dev)



