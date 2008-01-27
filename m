Return-Path: <linux-kernel-owner+w=401wt.eu-S1758116AbYA0RVm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758116AbYA0RVm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jan 2008 12:21:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752514AbYA0RVf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Jan 2008 12:21:35 -0500
Received: from einhorn.in-berlin.de ([192.109.42.8]:51402 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752487AbYA0RVe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jan 2008 12:21:34 -0500
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Sun, 27 Jan 2008 18:20:40 +0100 (CET)
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: [PATCH update] firewire: fix "kobject_add failed for fw* with
 -EEXIST"
To: linux1394-devel@lists.sourceforge.net
cc: Jarod Wilson <jwilson@redhat.com>,
       =?iso-8859-1?Q?Kristian_H=F8gsberg?= <krh@redhat.com>,
       linux-kernel@vger.kernel.org
In-Reply-To: <tkrat.e1db90404aee1115@s5r6.in-berlin.de>
Message-ID: <tkrat.a4603d89e4c2fde1@s5r6.in-berlin.de>
References: <tkrat.e1db90404aee1115@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=us-ascii
Content-Disposition: INLINE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is a race between shutdown and creation of devices:  fw-core may
attempt to add a device with the same name of an already existing
device.  http://bugzilla.kernel.org/show_bug.cgi?id=9828

Impact of the bug:  Happens rarely, forces the user to unplug and replug
the new device to get it working.

The fix moves deregistration of the minor number and device_unregister()
into a common rw_sem protected section.

We also move the ref count increment from fw_device_op_open into an
rw_sem protected section with the lookup of the device, so that the
device pointer can't become invalid between lookup and usage.

Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
---
 drivers/firewire/fw-cdev.c   |    6 ++++--
 drivers/firewire/fw-device.c |   10 ++++++----
 2 files changed, 10 insertions(+), 6 deletions(-)

Index: linux/drivers/firewire/fw-device.c
===================================================================
--- linux.orig/drivers/firewire/fw-device.c
+++ linux/drivers/firewire/fw-device.c
@@ -614,10 +614,12 @@ struct fw_device *fw_device_from_devt(de
 {
 	struct fw_device *device;
 
 	down_read(&idr_rwsem);
 	device = idr_find(&fw_device_idr, MINOR(devt));
+	if (device)
+		fw_device_get(device);
 	up_read(&idr_rwsem);
 
 	return device;
 }
 
@@ -625,17 +627,17 @@ static void fw_device_shutdown(struct wo
 {
 	struct fw_device *device =
 		container_of(work, struct fw_device, work.work);
 	int minor = MINOR(device->device.devt);
 
-	down_write(&idr_rwsem);
-	idr_remove(&fw_device_idr, minor);
-	up_write(&idr_rwsem);
-
 	fw_device_cdev_remove(device);
 	device_for_each_child(&device->device, NULL, shutdown_unit);
+
+	down_write(&idr_rwsem);
 	device_unregister(&device->device);
+	idr_remove(&fw_device_idr, minor);
+	up_write(&idr_rwsem);
 }
 
 static struct device_type fw_device_type = {
 	.release	= fw_device_release,
 };
Index: linux/drivers/firewire/fw-cdev.c
===================================================================
--- linux.orig/drivers/firewire/fw-cdev.c
+++ linux/drivers/firewire/fw-cdev.c
@@ -112,14 +112,16 @@ static int fw_device_op_open(struct inod
 	device = fw_device_from_devt(inode->i_rdev);
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
 	init_waitqueue_head(&client->wait);
 

-- 
Stefan Richter
-=====-==--- ---= ==-==
http://arcgraph.de/sr/

