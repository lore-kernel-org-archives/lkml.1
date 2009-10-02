Return-Path: <linux-kernel-owner+w=401wt.eu-S1756805AbZJBBds@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756805AbZJBBds (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Oct 2009 21:33:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756795AbZJBBdp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Oct 2009 21:33:45 -0400
Received: from kroah.org ([198.145.64.141]:33347 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756284AbZJBBdn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Oct 2009 21:33:43 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Thu Oct  1 18:24:20 2009
Message-Id: <20091002012420.455929915@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Thu, 01 Oct 2009 18:17:15 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Alan Stern <stern@rowland.harvard.edu>,
       Kay Sievers <kay.sievers@vrfy.org>
Subject: [087/136] Driver core: add new device to buss list before probing
References: <20091002011548.335611824@mini.kroah.org>
Content-Disposition: inline; filename=driver-core-add-new-device-to-bus-s-list-before-probing.patch
In-Reply-To: <20091002012911.GA18542@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.31-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Alan Stern <stern@rowland.harvard.edu>

commit 2023c610dc54a4f4130b0494309a9bd668ca3df8 upstream.

This patch (as1271) affects when new devices get linked into their
bus's list of devices.  Currently this happens after probing, and it
doesn't happen at all if probing fails.  Clearly this is wrong,
because at that point quite a few symbolic links have already been
created in sysfs.  We are committed to adding the device, so it should
be linked into the bus's list regardless.

In addition, this needs to happen before the uevent announcing the new
device gets issued.  Otherwise user programs might try to access the
device before it has been added to the bus.

To fix both these problems, the patch moves the call to
klist_add_tail() forward from bus_attach_device() to bus_add_device().
Since bus_attach_device() now does nothing but probe for drivers, it
has been renamed to bus_probe_device().  And lastly, the kerneldoc is
updated.

Signed-off-by: Alan Stern <stern@rowland.harvard.edu>
CC: Kay Sievers <kay.sievers@vrfy.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/base/base.h |    2 +-
 drivers/base/bus.c  |   23 ++++++++++-------------
 drivers/base/core.c |    2 +-
 3 files changed, 12 insertions(+), 15 deletions(-)

--- a/drivers/base/base.h
+++ b/drivers/base/base.h
@@ -104,7 +104,7 @@ extern int system_bus_init(void);
 extern int cpu_dev_init(void);
 
 extern int bus_add_device(struct device *dev);
-extern void bus_attach_device(struct device *dev);
+extern void bus_probe_device(struct device *dev);
 extern void bus_remove_device(struct device *dev);
 
 extern int bus_add_driver(struct device_driver *drv);
--- a/drivers/base/bus.c
+++ b/drivers/base/bus.c
@@ -459,8 +459,9 @@ static inline void remove_deprecated_bus
  * bus_add_device - add device to bus
  * @dev: device being added
  *
+ * - Add device's bus attributes.
+ * - Create links to device's bus.
  * - Add the device to its bus's list of devices.
- * - Create link to device's bus.
  */
 int bus_add_device(struct device *dev)
 {
@@ -483,6 +484,7 @@ int bus_add_device(struct device *dev)
 		error = make_deprecated_bus_links(dev);
 		if (error)
 			goto out_deprecated;
+		klist_add_tail(&dev->p->knode_bus, &bus->p->klist_devices);
 	}
 	return 0;
 
@@ -498,24 +500,19 @@ out_put:
 }
 
 /**
- * bus_attach_device - add device to bus
- * @dev: device tried to attach to a driver
+ * bus_probe_device - probe drivers for a new device
+ * @dev: device to probe
  *
- * - Add device to bus's list of devices.
- * - Try to attach to driver.
+ * - Automatically probe for a driver if the bus allows it.
  */
-void bus_attach_device(struct device *dev)
+void bus_probe_device(struct device *dev)
 {
 	struct bus_type *bus = dev->bus;
-	int ret = 0;
+	int ret;
 
-	if (bus) {
-		if (bus->p->drivers_autoprobe)
-			ret = device_attach(dev);
+	if (bus && bus->p->drivers_autoprobe) {
+		ret = device_attach(dev);
 		WARN_ON(ret < 0);
-		if (ret >= 0)
-			klist_add_tail(&dev->p->knode_bus,
-				       &bus->p->klist_devices);
 	}
 }
 
--- a/drivers/base/core.c
+++ b/drivers/base/core.c
@@ -945,7 +945,7 @@ int device_add(struct device *dev)
 					     BUS_NOTIFY_ADD_DEVICE, dev);
 
 	kobject_uevent(&dev->kobj, KOBJ_ADD);
-	bus_attach_device(dev);
+	bus_probe_device(dev);
 	if (parent)
 		klist_add_tail(&dev->p->knode_parent,
 			       &parent->p->klist_children);


