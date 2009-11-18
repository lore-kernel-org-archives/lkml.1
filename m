Return-Path: <linux-kernel-owner+w=401wt.eu-S932143AbZKRSDF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932143AbZKRSDF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Nov 2009 13:03:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758030AbZKRSDF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Nov 2009 13:03:05 -0500
Received: from mail-fx0-f221.google.com ([209.85.220.221]:33145 "EHLO
	mail-fx0-f221.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758010AbZKRSDD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Nov 2009 13:03:03 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=OSOeEVn8Ol97B9dPFuGqPVPS5WE8p1PFhHAcbdzPqs1eQvtYm46mHElIeuSRlocwc1
         +V/sThaDeDqpf8l6jw+3Vj+p+iiLLYeiPAvrjxvrYwwC92avTTMy11++WbFgU/f7lDft
         72a3xxV3X5lxTvcvzmr1aOPsYhPCMj9B/I4dM=
From: Russ Dill <russ.dill@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Greg KH <greg@kroah.com>, Alan Stern <stern@rowland.harvard.edu>,
       Jiri Kosina <jkosina@suse.cz>, linux-usb@vger.kernel.org,
       Russ Dill <Russ.Dill@gmail.com>
Subject: [PATCH] Close usb_find_interface race
Date: Wed, 18 Nov 2009 11:02:13 -0700
Message-Id: <1258567334-14846-1-git-send-email-Russ.Dill@gmail.com>
X-Mailer: git-send-email 1.6.5
In-Reply-To: <20091118153947.GA32440@kroah.com>
References: <20091118153947.GA32440@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

USB drivers that create character devices call usb_register_dev in their
probe function. This associates the usb_interface device with that minor
number and creates the character device and announces it to the world.
However, the driver's probe function is called before the new
usb_interface is added to the driver's klist_devices.

This is a problem because userspace will respond to the character device
creation announcement by opening the character device. The driver's open
function will the call usb_find_interface to find the usb_interface
associated with that minor number. usb_find_interface will walk the
driver's list of devices and find the usb_interface with the matching
minor number.

Because the announcement happens before the usb_interface is added to the
driver's klist_devices, a race condition exists. A straightforward fix
is to walk the list of devices on usb_bus_type instead since the device
is added to that list before the announcement occurs.

bus_find_device calls get_device to bump the reference count on the found
device. It is arguable that the reference count should be dropped by the
caller of usb_find_interface instead of usb_find_interface, however,
the current users of usb_find_interface do not expect this.

Signed-off-by: Russ Dill <Russ.Dill@gmail.com>
---
 drivers/usb/core/usb.c |   30 +++++++++++-------------------
 1 files changed, 11 insertions(+), 19 deletions(-)

diff --git a/drivers/usb/core/usb.c b/drivers/usb/core/usb.c
index b1b85ab..d1e9440 100644
--- a/drivers/usb/core/usb.c
+++ b/drivers/usb/core/usb.c
@@ -130,24 +130,17 @@ struct usb_host_interface *usb_altnum_to_altsetting(
 }
 EXPORT_SYMBOL_GPL(usb_altnum_to_altsetting);
 
-struct find_interface_arg {
-	int minor;
-	struct usb_interface *interface;
-};
-
 static int __find_interface(struct device *dev, void *data)
 {
-	struct find_interface_arg *arg = data;
+	int *minor = data;
 	struct usb_interface *intf;
 
 	if (!is_usb_interface(dev))
 		return 0;
 
 	intf = to_usb_interface(dev);
-	if (intf->minor != -1 && intf->minor == arg->minor) {
-		arg->interface = intf;
+	if (intf->minor != -1 && intf->minor == *minor)
 		return 1;
-	}
 	return 0;
 }
 
@@ -156,21 +149,20 @@ static int __find_interface(struct device *dev, void *data)
  * @drv: the driver whose current configuration is considered
  * @minor: the minor number of the desired device
  *
- * This walks the driver device list and returns a pointer to the interface
+ * This walks the bus device list and returns a pointer to the interface
  * with the matching minor.  Note, this only works for devices that share the
  * USB major number.
  */
 struct usb_interface *usb_find_interface(struct usb_driver *drv, int minor)
 {
-	struct find_interface_arg argb;
-	int retval;
+	struct device *dev;
+
+	dev = bus_find_device(&usb_bus_type, NULL, &minor, __find_interface);
+
+	/* Drop reference count from bus_find_device */
+	put_device(dev);
 
-	argb.minor = minor;
-	argb.interface = NULL;
-	/* eat the error, it will be in argb.interface */
-	retval = driver_for_each_device(&drv->drvwrap.driver, NULL, &argb,
-					__find_interface);
-	return argb.interface;
+	return dev ? to_usb_interface(dev) : NULL;
 }
 EXPORT_SYMBOL_GPL(usb_find_interface);
 
-- 
1.6.5

