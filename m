Return-Path: <linux-kernel-owner+w=401wt.eu-S1754863AbYA0AG3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754863AbYA0AG3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jan 2008 19:06:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751911AbYA0AGV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Jan 2008 19:06:21 -0500
Received: from einhorn.in-berlin.de ([192.109.42.8]:46939 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751623AbYA0AGU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jan 2008 19:06:20 -0500
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Sun, 27 Jan 2008 01:05:39 +0100 (CET)
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: [PATCH] firewire: fix "kobject_add failed for fw* with -EEXIST"
To: linux1394-devel@lists.sourceforge.net
cc: Jarod Wilson <jwilson@redhat.com>,
       =?iso-8859-1?Q?Kristian_H=F8gsberg?= <krh@redhat.com>,
       linux-kernel@vger.kernel.org
Message-ID: <tkrat.e1db90404aee1115@s5r6.in-berlin.de>
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

The fix is to defer the deregistration of the minor number until after
device_unregister().  This requires an adjustment of the device lookup
function though to prevent the character device from being newly opened
during shutdown.

Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
---
 drivers/firewire/fw-device.c |   10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

Index: linux/drivers/firewire/fw-device.c
===================================================================
--- linux.orig/drivers/firewire/fw-device.c
+++ linux/drivers/firewire/fw-device.c
@@ -616,6 +616,8 @@ struct fw_device *fw_device_from_devt(de
 
 	down_read(&idr_rwsem);
 	device = idr_find(&fw_device_idr, MINOR(devt));
+	if (fw_device_is_shutdown(device))
+		device = NULL;
 	up_read(&idr_rwsem);
 
 	return device;
@@ -627,13 +629,13 @@ static void fw_device_shutdown(struct wo
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

-- 
Stefan Richter
-=====-==--- ---= ==-==
http://arcgraph.de/sr/

