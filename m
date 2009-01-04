Return-Path: <linux-kernel-owner+w=401wt.eu-S1758426AbZADP2f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758426AbZADP2f (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Jan 2009 10:28:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752155AbZADP2Y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Jan 2009 10:28:24 -0500
Received: from einhorn.in-berlin.de ([192.109.42.8]:44058 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752046AbZADP2Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Jan 2009 10:28:24 -0500
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Sun, 4 Jan 2009 16:28:07 +0100 (CET)
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: [PATCH 07/11] firewire: cdev: add ioctl to query maximum transmission
 speed
To: linux1394-devel@lists.sourceforge.net
cc: linux-kernel@vger.kernel.org
In-Reply-To: <tkrat.3905b2754a8fc519@s5r6.in-berlin.de>
Message-ID: <tkrat.04ed34d0fc3ff505@s5r6.in-berlin.de>
References: <tkrat.3905b2754a8fc519@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=us-ascii
Content-Disposition: INLINE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

While the speed of asynchronous transactions is automatically chosen by
the kernel, the speed of isochronous streams has to be chosen by the
initiating client.

In case of 1394a bus topologies, the maximum possible speed could be
figured out with some effort by evaluation of the remote node's link
speed field in the config ROM, the local node's link speed field, and
the PHY speeds and topologic information in the local node's or IRM's
topology map CSR.  However, this does not work in case of 1394b buses.

Hence add an ioctl to export the maximum speed which the kernel already
determined.

Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
---
 drivers/firewire/fw-cdev.c    |   10 ++++++++++
 include/linux/firewire-cdev.h |   10 ++++++++++
 2 files changed, 20 insertions(+)

Index: linux/include/linux/firewire-cdev.h
===================================================================
--- linux.orig/include/linux/firewire-cdev.h
+++ linux/include/linux/firewire-cdev.h
@@ -229,6 +229,7 @@ union fw_cdev_event {
 #define FW_CDEV_IOC_DEALLOCATE_ISO_RESOURCE      _IOW('#', 0x0e, struct fw_cdev_deallocate)
 #define FW_CDEV_IOC_ALLOCATE_ISO_RESOURCE_ONCE   _IOW('#', 0x0f, struct fw_cdev_allocate_iso_resource)
 #define FW_CDEV_IOC_DEALLOCATE_ISO_RESOURCE_ONCE _IOW('#', 0x10, struct fw_cdev_allocate_iso_resource)
+#define FW_CDEV_IOC_GET_SPEED                    _IOR('#', 0x11, struct fw_cdev_get_speed)
 
 /* FW_CDEV_VERSION History
  *
@@ -575,4 +576,13 @@ struct fw_cdev_allocate_iso_resource {
 	__u32 handle;
 };
 
+/**
+ * struct fw_cdev_get_speed - Query maximum speed to or from this device
+ * @max_speed:	Speed code; minimum of the device's link speed, the local node's
+ *		link speed, and all PHY port speeds between the two links
+ */
+struct fw_cdev_get_speed {
+	__u32 max_speed;
+};
+
 #endif /* _LINUX_FIREWIRE_CDEV_H */
Index: linux/drivers/firewire/fw-cdev.c
===================================================================
--- linux.orig/drivers/firewire/fw-cdev.c
+++ linux/drivers/firewire/fw-cdev.c
@@ -1220,6 +1220,15 @@ static int ioctl_deallocate_iso_resource
 	return init_iso_resource(client, request, ISO_RES_DEALLOC_ONCE);
 }
 
+static int ioctl_get_speed(struct client *client, void *buffer)
+{
+	struct fw_cdev_get_speed *request = buffer;
+
+	request->max_speed = client->device->max_speed;
+
+	return 0;
+}
+
 static int (* const ioctl_handlers[])(struct client *client, void *buffer) = {
 	ioctl_get_info,
 	ioctl_send_request,
@@ -1238,6 +1247,7 @@ static int (* const ioctl_handlers[])(st
 	ioctl_deallocate_iso_resource,
 	ioctl_allocate_iso_resource_once,
 	ioctl_deallocate_iso_resource_once,
+	ioctl_get_speed,
 };
 
 static int dispatch_ioctl(struct client *client,

-- 
Stefan Richter
-=====-==--= ---= --=--
http://arcgraph.de/sr/

