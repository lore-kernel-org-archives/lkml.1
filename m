Return-Path: <linux-kernel-owner+w=401wt.eu-S1762474AbYBBOCA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762474AbYBBOCA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Feb 2008 09:02:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753890AbYBBOBx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 Feb 2008 09:01:53 -0500
Received: from einhorn.in-berlin.de ([192.109.42.8]:53972 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753888AbYBBOBw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Feb 2008 09:01:52 -0500
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Sat, 2 Feb 2008 15:01:09 +0100 (CET)
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: [PATCH update 2] firewire: fix "kobject_add failed for fw* with
 -EEXIST"
To: Jarod Wilson <jwilson@redhat.com>
cc: linux1394-devel@lists.sourceforge.net,
       =?iso-8859-1?Q?Kristian_H=F8gsberg?= <krh@redhat.com>,
       linux-kernel@vger.kernel.org
In-Reply-To: <479E65E5.4060307@s5r6.in-berlin.de>
Message-ID: <tkrat.8cbc5b27d5869b96@s5r6.in-berlin.de>
References: <tkrat.e1db90404aee1115@s5r6.in-berlin.de>
 <tkrat.a4603d89e4c2fde1@s5r6.in-berlin.de>
 <200801281148.54017.jwilson@redhat.com> <479E29F2.7020307@s5r6.in-berlin.de>
 <479E65E5.4060307@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=us-ascii
Content-Disposition: INLINE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is a race between shutdown and creation of devices:  fw-core may
attempt to add a device with the same name of an already existing
device.  http://bugzilla.kernel.org/show_bug.cgi?id=9828

Impact of the bug:  Happens rarely (when shutdown of a device coincides
with creation of another), forces the user to unplug and replug the new
device to get it working.

The fix is obvious:  Free the minor number *after* instead of *before*
device_unregister().  This requires to take an additional reference of
the fw_device as long as the IDR tree points to it.

And while we are at it, we fix an additional race condition:
fw_device_op_open() took its reference of the fw_device a little bit too
late, hence was in danger to access an already invalid fw_device.

Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
---
 drivers/firewire/fw-cdev.c   |    8 +++++---
 drivers/firewire/fw-device.c |   20 ++++++++++++++------
 drivers/firewire/fw-device.h |    2 +-
 3 files changed, 20 insertions(+), 10 deletions(-)

Index: linux/drivers/firewire/fw-device.c
===================================================================
--- linux.orig/drivers/firewire/fw-device.c
+++ linux/drivers/firewire/fw-device.c
@@ -610,12 +610,14 @@ static DECLARE_RWSEM(idr_rwsem);
 static DEFINE_IDR(fw_device_idr);
 int fw_cdev_major;
 
-struct fw_device *fw_device_from_devt(dev_t devt)
+struct fw_device *fw_device_get_by_devt(dev_t devt)
 {
 	struct fw_device *device;
 
 	down_read(&idr_rwsem);
 	device = idr_find(&fw_device_idr, MINOR(devt));
+	if (device)
+		fw_device_get(device);
 	up_read(&idr_rwsem);
 
 	return device;
@@ -627,13 +629,14 @@ static void fw_device_shutdown(struct wo
 		container_of(work, struct fw_device, work.work);
 	int minor = MINOR(device->device.devt);
 
-	down_write(&idr_rwsem);
-	idr_remove(&fw_device_idr, minor);
-	up_write(&idr_rwsem);
-
 	fw_device_cdev_remove(device);
 	device_for_each_child(&device->device, NULL, shutdown_unit);
 	device_unregister(&device->device);
+
+	down_write(&idr_rwsem);
+	idr_remove(&fw_device_idr, minor);
+	up_write(&idr_rwsem);
+	fw_device_put(device);
 }
 
 static struct device_type fw_device_type = {
@@ -682,10 +685,13 @@ static void fw_device_init(struct work_s
 	}
 
 	err = -ENOMEM;
+
+	fw_device_get(device);
 	down_write(&idr_rwsem);
 	if (idr_pre_get(&fw_device_idr, GFP_KERNEL))
 		err = idr_get_new(&fw_device_idr, device, &minor);
 	up_write(&idr_rwsem);
+
 	if (err < 0)
 		goto error;
 
@@ -741,7 +747,9 @@ static void fw_device_init(struct work_s
 	idr_remove(&fw_device_idr, minor);
 	up_write(&idr_rwsem);
  error:
-	put_device(&device->device);
+	fw_device_put(device);		/* fw_device_idr's reference */
+
+	put_device(&device->device);	/* our reference */
 }
 
 static int update_unit(struct device *dev, void *data)
Index: linux/drivers/firewire/fw-cdev.c
===================================================================
--- linux.orig/drivers/firewire/fw-cdev.c
+++ linux/drivers/firewire/fw-cdev.c
@@ -109,15 +109,17 @@ static int fw_device_op_open(struct inod
 	struct client *client;
 	unsigned long flags;
 
-	device = fw_device_from_devt(inode->i_rdev);
+	device = fw_device_get_by_devt(inode->i_rdev);
 	if (device == NULL)
 		return -ENODEV;
 
 	client = kzalloc(sizeof(*client), GFP_KERNEL);
-	if (client == NULL)
+	if (client == NULL) {
+		fw_device_put(device);
 		return -ENOMEM;
+	}
 
-	client->device = fw_device_get(device);
+	client->device = device;
 	INIT_LIST_HEAD(&client->event_list);
 	INIT_LIST_HEAD(&client->resource_list);
 	spin_lock_init(&client->lock);
Index: linux/drivers/firewire/fw-device.h
===================================================================
--- linux.orig/drivers/firewire/fw-device.h
+++ linux/drivers/firewire/fw-device.h
@@ -77,13 +77,13 @@ fw_device_is_shutdown(struct fw_device *
 }
 
 struct fw_device *fw_device_get(struct fw_device *device);
+struct fw_device *fw_device_get_by_devt(dev_t devt);
 void fw_device_put(struct fw_device *device);
 int fw_device_enable_phys_dma(struct fw_device *device);
 
 void fw_device_cdev_update(struct fw_device *device);
 void fw_device_cdev_remove(struct fw_device *device);
 
-struct fw_device *fw_device_from_devt(dev_t devt);
 extern int fw_cdev_major;
 
 struct fw_unit {

-- 
Stefan Richter
-=====-==--- --=- ---=-
http://arcgraph.de/sr/

