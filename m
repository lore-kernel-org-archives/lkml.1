Return-Path: <linux-kernel-owner+w=401wt.eu-S1755985AbXK0HOu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755985AbXK0HOu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Nov 2007 02:14:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751235AbXK0HOm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Nov 2007 02:14:42 -0500
Received: from cantor2.suse.de ([195.135.220.15]:47165 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751179AbXK0HOl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Nov 2007 02:14:41 -0500
Subject: patch driver-core-fix-race-in-__device_release_driver.patch added to gregkh-2.6 tree
To: stern@rowland.harvard.edu, dwmw2@infradead.org, greg@kroah.com,
       gregkh@suse.de, linux-kernel@vger.kernel.org,
       linux-usb-devel@lists.sourceforge.net
From: <gregkh@suse.de>
Date: Mon, 26 Nov 2007 23:14:23 -0800
In-Reply-To: <Pine.LNX.4.44L0.0711161151340.3268-100000@iolanthe.rowland.org>
Message-Id: <20071127071438.A79341454447@imap.suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


This is a note to let you know that I've just added the patch titled

     Subject: Driver core: fix race in __device_release_driver

to my gregkh-2.6 tree.  Its filename is

     driver-core-fix-race-in-__device_release_driver.patch

This tree can be found at 
    http://www.kernel.org/pub/linux/kernel/people/gregkh/gregkh-2.6/patches/


>From stern@rowland.harvard.edu  Mon Nov 26 22:49:20 2007
From: Alan Stern <stern@rowland.harvard.edu>
Date: Fri, 16 Nov 2007 11:57:28 -0500 (EST)
Subject: Driver core: fix race in __device_release_driver
To: Greg KH <greg@kroah.com>, David Woodhouse <dwmw2@infradead.org>
Cc: USB development list <linux-usb-devel@lists.sourceforge.net>,  Kernel development list <linux-kernel@vger.kernel.org>
Message-ID: <Pine.LNX.4.44L0.0711161151340.3268-100000@iolanthe.rowland.org>


This patch (as1013) was suggested by David Woodhouse; it fixes a race
in the driver core.  If a device is unregistered at the same time as
its driver is unloaded, the driver's code pages may be unmapped while
the remove method is still running.  The calls to get_driver() and
put_driver() were intended to prevent this, but they don't work if the
driver's module count has already dropped to 0.

Instead, the patch keeps the device on the driver's list until after
the remove method has returned.  This forces the necessary
synchronization to occur.

Signed-off-by: Alan Stern <stern@rowland.harvard.edu>
Signed-off-by: David Woodhouse <dwmw2@infradead.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/base/dd.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

--- a/drivers/base/dd.c
+++ b/drivers/base/dd.c
@@ -289,11 +289,10 @@ static void __device_release_driver(stru
 {
 	struct device_driver * drv;
 
-	drv = get_driver(dev->driver);
+	drv = dev->driver;
 	if (drv) {
 		driver_sysfs_remove(dev);
 		sysfs_remove_link(&dev->kobj, "driver");
-		klist_remove(&dev->knode_driver);
 
 		if (dev->bus)
 			blocking_notifier_call_chain(&dev->bus->p->bus_notifier,
@@ -306,7 +305,7 @@ static void __device_release_driver(stru
 			drv->remove(dev);
 		devres_release_all(dev);
 		dev->driver = NULL;
-		put_driver(drv);
+		klist_remove(&dev->knode_driver);
 	}
 }
 


Patches currently in gregkh-2.6 which might be from stern@rowland.harvard.edu are

driver/pm-acquire-device-locks-prior-to-suspending.patch
driver/create-sys-...-power-when-config_pm-is-set.patch
driver/driver-core-fix-race-in-__device_release_driver.patch
usb/usb-add-support-for-an-older-firmware-revision-for-the-nikon-d200.patch
usb/usb-fix-priority-mistakes-in-drivers-usb-core-hub.c.patch
usb/usb-fix-signr-comment-in-usbdevice_fs.h.patch
usb/usb-mailing-lists-have-changed.patch
usb/usb-power-management-documenation-update.patch
usb/usb-hcd-avoid-duplicate-local_irq_disable.patch
usb/usb-usb-mon-mon_bin.c-cleanups.patch
usb/usb-keep-track-of-whether-interface-sysfs-files-exist.patch
usb/usb-uevent-environment-key-fix.patch
usb/usb-autosuspend-for-cdc-acm.patch
usb/usb-fix-up-ehci-startup-synchronization.patch
usb/usb-usb-storage-new-lockable-subclass-0x07.patch
usb/usb-don-t-change-hc-power-state-for-a-freeze.patch
usb/usb-dummy_hcd-don-t-register-drivers-on-the-platform-bus.patch
usb/usb-force-handover-port-to-companion-when-hub_port_connect_change-fails.patch
usb/usb-make-ksuspend_usbd-thread-non-freezable.patch
usb/usb-usb-storage-unusual_devs-entry-for-jetflash-ts1gjf2a.patch
usb/usb-storage-always-set-the-allow_restart-flag.patch
