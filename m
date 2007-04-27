Return-Path: <linux-kernel-owner+w=401wt.eu-S1757057AbXD0S5n@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757057AbXD0S5n (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2007 14:57:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757069AbXD0S5n
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Apr 2007 14:57:43 -0400
Received: from ns.suse.de ([195.135.220.2]:50658 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757045AbXD0S5i (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2007 14:57:38 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@suse.de>,
       Alan Stern <stern@rowland.harvard.edu>, Oliver Neukum <oneukum@suse.de>,
       David Brownell <david-b@pacbell.net>,
       linux-usb-devel <linux-usb-devel@lists.sourceforge.net>
Subject: [PATCH 22/46] USB: remove use of the bus rwsem, as it doesn't really protect anything.
Date: Fri, 27 Apr 2007 11:53:36 -0700
Message-Id: <11777001182501-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.5.1.2
In-Reply-To: <1177700114535-git-send-email-gregkh@suse.de>
References: <20070427185152.GA17121@kroah.com>
 <1177700040520-git-send-email-gregkh@suse.de>
 <11777000433552-git-send-email-gregkh@suse.de>
 <11777000471977-git-send-email-gregkh@suse.de>
 <11777000511784-git-send-email-gregkh@suse.de>
 <11777000552084-git-send-email-gregkh@suse.de>
 <1177700059319-git-send-email-gregkh@suse.de>
 <11777000632194-git-send-email-gregkh@suse.de>
 <11777000663361-git-send-email-gregkh@suse.de>
 <1177700070961-git-send-email-gregkh@suse.de>
 <1177700074272-git-send-email-gregkh@suse.de>
 <11777000773819-git-send-email-gregkh@suse.de>
 <11777000814075-git-send-email-gregkh@suse.de>
 <11777000852694-git-send-email-gregkh@suse.de>
 <11777000881307-git-send-email-gregkh@suse.de>
 <11777000923797-git-send-email-gregkh@suse.de>
 <11777000963332-git-send-email-gregkh@suse.de>
 <11777001002860-git-send-email-gregkh@suse.de>
 <11777001041847-git-send-email-gregkh@suse.de>
 <11777001072576-git-send-email-gregkh@suse.de>
 <11777001102852-git-send-email-gregkh@suse.de>
 <1177700114535-git-send-email-gregkh@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

The driver core stopped using the rwsem a long time ago, yet the USB
core still grabbed the lock, thinking it protected something.  This
patch removes that useless use.

Cc: Alan Stern <stern@rowland.harvard.edu>
Cc: Oliver Neukum <oneukum@suse.de>
Cc: David Brownell <david-b@pacbell.net>
Cc: linux-usb-devel <linux-usb-devel@lists.sourceforge.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/usb/core/devices.c |    2 --
 drivers/usb/core/devio.c   |   13 -------------
 drivers/usb/core/driver.c  |   12 ++++++------
 drivers/usb/core/message.c |    2 +-
 4 files changed, 7 insertions(+), 22 deletions(-)

diff --git a/drivers/usb/core/devices.c b/drivers/usb/core/devices.c
index aefc798..6753ca0 100644
--- a/drivers/usb/core/devices.c
+++ b/drivers/usb/core/devices.c
@@ -246,7 +246,6 @@ static char *usb_dump_interface_descriptor(char *start, char *end,
 
 	if (start > end)
 		return start;
-	down_read(&usb_bus_type.subsys.rwsem);
 	if (iface) {
 		driver_name = (iface->dev.driver
 				? iface->dev.driver->name
@@ -263,7 +262,6 @@ static char *usb_dump_interface_descriptor(char *start, char *end,
 			 desc->bInterfaceSubClass,
 			 desc->bInterfaceProtocol,
 			 driver_name);
-	up_read(&usb_bus_type.subsys.rwsem);
 	return start;
 }
 
diff --git a/drivers/usb/core/devio.c b/drivers/usb/core/devio.c
index 36e7a84..fc3545d 100644
--- a/drivers/usb/core/devio.c
+++ b/drivers/usb/core/devio.c
@@ -421,14 +421,11 @@ static int claimintf(struct dev_state *ps, unsigned int ifnum)
 	if (test_bit(ifnum, &ps->ifclaimed))
 		return 0;
 
-	/* lock against other changes to driver bindings */
-	down_write(&usb_bus_type.subsys.rwsem);
 	intf = usb_ifnum_to_if(dev, ifnum);
 	if (!intf)
 		err = -ENOENT;
 	else
 		err = usb_driver_claim_interface(&usbfs_driver, intf, ps);
-	up_write(&usb_bus_type.subsys.rwsem);
 	if (err == 0)
 		set_bit(ifnum, &ps->ifclaimed);
 	return err;
@@ -444,8 +441,6 @@ static int releaseintf(struct dev_state *ps, unsigned int ifnum)
 	if (ifnum >= 8*sizeof(ps->ifclaimed))
 		return err;
 	dev = ps->dev;
-	/* lock against other changes to driver bindings */
-	down_write(&usb_bus_type.subsys.rwsem);
 	intf = usb_ifnum_to_if(dev, ifnum);
 	if (!intf)
 		err = -ENOENT;
@@ -453,7 +448,6 @@ static int releaseintf(struct dev_state *ps, unsigned int ifnum)
 		usb_driver_release_interface(&usbfs_driver, intf);
 		err = 0;
 	}
-	up_write(&usb_bus_type.subsys.rwsem);
 	return err;
 }
 
@@ -813,7 +807,6 @@ static int proc_getdriver(struct dev_state *ps, void __user *arg)
 
 	if (copy_from_user(&gd, arg, sizeof(gd)))
 		return -EFAULT;
-	down_read(&usb_bus_type.subsys.rwsem);
 	intf = usb_ifnum_to_if(ps->dev, gd.interface);
 	if (!intf || !intf->dev.driver)
 		ret = -ENODATA;
@@ -822,7 +815,6 @@ static int proc_getdriver(struct dev_state *ps, void __user *arg)
 				sizeof(gd.driver));
 		ret = (copy_to_user(arg, &gd, sizeof(gd)) ? -EFAULT : 0);
 	}
-	up_read(&usb_bus_type.subsys.rwsem);
 	return ret;
 }
 
@@ -1351,15 +1343,12 @@ static int proc_ioctl(struct dev_state *ps, struct usbdevfs_ioctl *ctl)
 
 	/* disconnect kernel driver from interface */
 	case USBDEVFS_DISCONNECT:
-
-		down_write(&usb_bus_type.subsys.rwsem);
 		if (intf->dev.driver) {
 			driver = to_usb_driver(intf->dev.driver);
 			dev_dbg (&intf->dev, "disconnect by usbfs\n");
 			usb_driver_release_interface(driver, intf);
 		} else
 			retval = -ENODATA;
-		up_write(&usb_bus_type.subsys.rwsem);
 		break;
 
 	/* let kernel drivers try to (re)bind to the interface */
@@ -1371,7 +1360,6 @@ static int proc_ioctl(struct dev_state *ps, struct usbdevfs_ioctl *ctl)
 
 	/* talk directly to the interface's driver */
 	default:
-		down_read(&usb_bus_type.subsys.rwsem);
 		if (intf->dev.driver)
 			driver = to_usb_driver(intf->dev.driver);
 		if (driver == NULL || driver->ioctl == NULL) {
@@ -1381,7 +1369,6 @@ static int proc_ioctl(struct dev_state *ps, struct usbdevfs_ioctl *ctl)
 			if (retval == -ENOIOCTLCMD)
 				retval = -ENOTTY;
 		}
-		up_read(&usb_bus_type.subsys.rwsem);
 	}
 
 	/* cleanup and return */
diff --git a/drivers/usb/core/driver.c b/drivers/usb/core/driver.c
index 9e3e943..e6dd2b9 100644
--- a/drivers/usb/core/driver.c
+++ b/drivers/usb/core/driver.c
@@ -287,9 +287,9 @@ static int usb_unbind_interface(struct device *dev)
  * way to bind to an interface is to return the private data from
  * the driver's probe() method.
  *
- * Callers must own the device lock and the driver model's usb_bus_type.subsys
- * writelock.  So driver probe() entries don't need extra locking,
- * but other call contexts may need to explicitly claim those locks.
+ * Callers must own the device lock, so driver probe() entries don't need
+ * extra locking, but other call contexts may need to explicitly claim that
+ * lock.
  */
 int usb_driver_claim_interface(struct usb_driver *driver,
 				struct usb_interface *iface, void* priv)
@@ -330,9 +330,9 @@ EXPORT_SYMBOL(usb_driver_claim_interface);
  * also causes the driver disconnect() method to be called.
  *
  * This call is synchronous, and may not be used in an interrupt context.
- * Callers must own the device lock and the driver model's usb_bus_type.subsys
- * writelock.  So driver disconnect() entries don't need extra locking,
- * but other call contexts may need to explicitly claim those locks.
+ * Callers must own the device lock, so driver disconnect() entries don't
+ * need extra locking, but other call contexts may need to explicitly claim
+ * that lock.
  */
 void usb_driver_release_interface(struct usb_driver *driver,
 					struct usb_interface *iface)
diff --git a/drivers/usb/core/message.c b/drivers/usb/core/message.c
index 217a3d6..c359ccb 100644
--- a/drivers/usb/core/message.c
+++ b/drivers/usb/core/message.c
@@ -1349,7 +1349,7 @@ static void release_interface(struct device *dev)
  *
  * This call is synchronous. The calling context must be able to sleep,
  * must own the device lock, and must not hold the driver model's USB
- * bus rwsem; usb device driver probe() methods cannot use this routine.
+ * bus mutex; usb device driver probe() methods cannot use this routine.
  *
  * Returns zero on success, or else the status code returned by the
  * underlying call that failed.  On successful completion, each interface
-- 
1.5.1.2

