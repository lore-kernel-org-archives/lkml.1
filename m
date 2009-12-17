Return-Path: <linux-kernel-owner+w=401wt.eu-S935754AbZLQEf5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935754AbZLQEf5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Dec 2009 23:35:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935345AbZLQEEX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Dec 2009 23:04:23 -0500
Received: from kroah.org ([198.145.64.141]:55509 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763975AbZLQEER (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Dec 2009 23:04:17 -0500
X-Mailbox-Line: From gregkh@mini.kroah.org Wed Dec 16 19:56:49 2009
Message-Id: <20091217035649.777133501@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Wed, 16 Dec 2009 19:55:50 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Russ Dill <Russ.Dill@gmail.com>
Subject: [053/151] USB: Close usb_find_interface race v3
In-Reply-To: <20091217040208.GA26571@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Russ Dill <Russ.Dill@gmail.com>

commit c2d284ee04ab6f6718de2ddcf1b43160e046c41d upstream.

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

The original version of this patch only matched against minor number
instead of driver and minor number. This version matches against both.

Signed-off-by: Russ Dill <Russ.Dill@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/usb/core/usb.c |   31 ++++++++++++++++---------------
 1 file changed, 16 insertions(+), 15 deletions(-)

--- a/drivers/usb/core/usb.c
+++ b/drivers/usb/core/usb.c
@@ -132,7 +132,7 @@ EXPORT_SYMBOL_GPL(usb_altnum_to_altsetti
 
 struct find_interface_arg {
 	int minor;
-	struct usb_interface *interface;
+	struct device_driver *drv;
 };
 
 static int __find_interface(struct device *dev, void *data)
@@ -143,12 +143,10 @@ static int __find_interface(struct devic
 	if (!is_usb_interface(dev))
 		return 0;
 
+	if (dev->driver != arg->drv)
+		return 0;
 	intf = to_usb_interface(dev);
-	if (intf->minor != -1 && intf->minor == arg->minor) {
-		arg->interface = intf;
-		return 1;
-	}
-	return 0;
+	return intf->minor == arg->minor;
 }
 
 /**
@@ -156,21 +154,24 @@ static int __find_interface(struct devic
  * @drv: the driver whose current configuration is considered
  * @minor: the minor number of the desired device
  *
- * This walks the driver device list and returns a pointer to the interface
- * with the matching minor.  Note, this only works for devices that share the
- * USB major number.
+ * This walks the bus device list and returns a pointer to the interface
+ * with the matching minor and driver.  Note, this only works for devices
+ * that share the USB major number.
  */
 struct usb_interface *usb_find_interface(struct usb_driver *drv, int minor)
 {
 	struct find_interface_arg argb;
-	int retval;
+	struct device *dev;
 
 	argb.minor = minor;
-	argb.interface = NULL;
-	/* eat the error, it will be in argb.interface */
-	retval = driver_for_each_device(&drv->drvwrap.driver, NULL, &argb,
-					__find_interface);
-	return argb.interface;
+	argb.drv = &drv->drvwrap.driver;
+
+	dev = bus_find_device(&usb_bus_type, NULL, &argb, __find_interface);
+
+	/* Drop reference count from bus_find_device */
+	put_device(dev);
+
+	return dev ? to_usb_interface(dev) : NULL;
 }
 EXPORT_SYMBOL_GPL(usb_find_interface);
 


