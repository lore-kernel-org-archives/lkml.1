Return-Path: <linux-kernel-owner+w=401wt.eu-S1758002AbZADP31@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758002AbZADP31 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Jan 2009 10:29:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751400AbZADP3T
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Jan 2009 10:29:19 -0500
Received: from einhorn.in-berlin.de ([192.109.42.8]:44073 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751329AbZADP3S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Jan 2009 10:29:18 -0500
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Sun, 4 Jan 2009 16:29:02 +0100 (CET)
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: [PATCH 08/11] firewire: cdev: add ioctl for broadcast write requests
To: linux1394-devel@lists.sourceforge.net
cc: linux-kernel@vger.kernel.org
In-Reply-To: <tkrat.3905b2754a8fc519@s5r6.in-berlin.de>
Message-ID: <tkrat.ac5c25bcae9e00f6@s5r6.in-berlin.de>
References: <tkrat.3905b2754a8fc519@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=us-ascii
Content-Disposition: INLINE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Write transactions to the broadcast node ID are a convenient way to
trigger functions of multiple nodes at once.  IIDC is a protocol which
can make use of this if multiple cameras with same command_regs_base are
connected at the same bus.

Based on
    Date: Wed, 10 Sep 2008 11:32:16 -0400
    From: Jay Fenlason <fenlason@redhat.com>
    Subject: [patch] SEND_BROADCAST_REQUEST
Changes:  ioctl_send_request() and ioctl_send_broadcast_request() now
share code.  Broadcast speed corrected to S100.  Check for proper tcode.

Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
---
 drivers/firewire/fw-cdev.c    |   74 +++++++++++++++++++++-------------
 include/linux/firewire-cdev.h |    1 
 2 files changed, 48 insertions(+), 27 deletions(-)

Index: linux/include/linux/firewire-cdev.h
===================================================================
--- linux.orig/include/linux/firewire-cdev.h
+++ linux/include/linux/firewire-cdev.h
@@ -230,6 +230,7 @@ union fw_cdev_event {
 #define FW_CDEV_IOC_ALLOCATE_ISO_RESOURCE_ONCE   _IOW('#', 0x0f, struct fw_cdev_allocate_iso_resource)
 #define FW_CDEV_IOC_DEALLOCATE_ISO_RESOURCE_ONCE _IOW('#', 0x10, struct fw_cdev_allocate_iso_resource)
 #define FW_CDEV_IOC_GET_SPEED                    _IOR('#', 0x11, struct fw_cdev_get_speed)
+#define FW_CDEV_IOC_SEND_BROADCAST_REQUEST       _IOW('#', 0x12, struct fw_cdev_send_request)
 
 /* FW_CDEV_VERSION History
  *
Index: linux/drivers/firewire/fw-cdev.c
===================================================================
--- linux.orig/drivers/firewire/fw-cdev.c
+++ linux/drivers/firewire/fw-cdev.c
@@ -518,10 +518,10 @@ static void complete_transaction(struct 
 	client_put(client);
 }
 
-static int ioctl_send_request(struct client *client, void *buffer)
+static int init_request(struct client *client,
+			struct fw_cdev_send_request *request,
+			int destination_id, int speed)
 {
-	struct fw_device *device = client->device;
-	struct fw_cdev_send_request *request = buffer;
 	struct outbound_transaction_event *e;
 	int ret;
 
@@ -544,24 +544,6 @@ static int ioctl_send_request(struct cli
 		goto failed;
 	}
 
-	switch (request->tcode) {
-	case TCODE_WRITE_QUADLET_REQUEST:
-	case TCODE_WRITE_BLOCK_REQUEST:
-	case TCODE_READ_QUADLET_REQUEST:
-	case TCODE_READ_BLOCK_REQUEST:
-	case TCODE_LOCK_MASK_SWAP:
-	case TCODE_LOCK_COMPARE_SWAP:
-	case TCODE_LOCK_FETCH_ADD:
-	case TCODE_LOCK_LITTLE_ADD:
-	case TCODE_LOCK_BOUNDED_ADD:
-	case TCODE_LOCK_WRAP_ADD:
-	case TCODE_LOCK_VENDOR_DEPENDENT:
-		break;
-	default:
-		ret = -EINVAL;
-		goto failed;
-	}
-
 	e->r.resource.release = release_transaction;
 	ret = add_client_resource(client, &e->r.resource, GFP_KERNEL);
 	if (ret < 0)
@@ -570,12 +552,9 @@ static int ioctl_send_request(struct cli
 	/* Get a reference for the transaction callback */
 	client_get(client);
 
-	fw_send_request(device->card, &e->r.transaction,
-			request->tcode & 0x1f,
-			device->node->node_id,
-			request->generation,
-			device->max_speed,
-			request->offset,
+	fw_send_request(client->device->card, &e->r.transaction,
+			request->tcode & 0x1f, destination_id,
+			request->generation, speed, request->offset,
 			e->response.data, request->length,
 			complete_transaction, e);
 
@@ -589,6 +568,31 @@ static int ioctl_send_request(struct cli
 	return ret;
 }
 
+static int ioctl_send_request(struct client *client, void *buffer)
+{
+	struct fw_cdev_send_request *request = buffer;
+
+	switch (request->tcode) {
+	case TCODE_WRITE_QUADLET_REQUEST:
+	case TCODE_WRITE_BLOCK_REQUEST:
+	case TCODE_READ_QUADLET_REQUEST:
+	case TCODE_READ_BLOCK_REQUEST:
+	case TCODE_LOCK_MASK_SWAP:
+	case TCODE_LOCK_COMPARE_SWAP:
+	case TCODE_LOCK_FETCH_ADD:
+	case TCODE_LOCK_LITTLE_ADD:
+	case TCODE_LOCK_BOUNDED_ADD:
+	case TCODE_LOCK_WRAP_ADD:
+	case TCODE_LOCK_VENDOR_DEPENDENT:
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	return init_request(client, request, client->device->node->node_id,
+			    client->device->max_speed);
+}
+
 static void release_request(struct client *client,
 			    struct client_resource *resource)
 {
@@ -1229,6 +1233,21 @@ static int ioctl_get_speed(struct client
 	return 0;
 }
 
+static int ioctl_send_broadcast_request(struct client *client, void *buffer)
+{
+	struct fw_cdev_send_request *request = buffer;
+
+	switch (request->tcode) {
+	case TCODE_WRITE_QUADLET_REQUEST:
+	case TCODE_WRITE_BLOCK_REQUEST:
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	return init_request(client, request, LOCAL_BUS | 0x3f, SCODE_100);
+}
+
 static int (* const ioctl_handlers[])(struct client *client, void *buffer) = {
 	ioctl_get_info,
 	ioctl_send_request,
@@ -1248,6 +1267,7 @@ static int (* const ioctl_handlers[])(st
 	ioctl_allocate_iso_resource_once,
 	ioctl_deallocate_iso_resource_once,
 	ioctl_get_speed,
+	ioctl_send_broadcast_request,
 };
 
 static int dispatch_ioctl(struct client *client,

-- 
Stefan Richter
-=====-==--= ---= --=--
http://arcgraph.de/sr/

