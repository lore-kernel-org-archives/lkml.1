Return-Path: <linux-kernel-owner+w=401wt.eu-S1755968AbZADPZN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755968AbZADPZN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Jan 2009 10:25:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751329AbZADPZA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Jan 2009 10:25:00 -0500
Received: from einhorn.in-berlin.de ([192.109.42.8]:44039 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751222AbZADPY7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Jan 2009 10:24:59 -0500
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Sun, 4 Jan 2009 16:24:41 +0100 (CET)
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: [PATCH 01/11] firewire: cdev: reference-count client instances
To: linux1394-devel@lists.sourceforge.net
cc: linux-kernel@vger.kernel.org
In-Reply-To: <tkrat.3905b2754a8fc519@s5r6.in-berlin.de>
Message-ID: <tkrat.8de770712ed54822@s5r6.in-berlin.de>
References: <tkrat.3905b2754a8fc519@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=us-ascii
Content-Disposition: INLINE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The lifetime of struct client instances must be longer than the lifetime
of any client resource.

This fixes a possible race between fw_device_op_release and transaction
completions.  It also prepares for new ioctls for isochronous resource
management which will involve delayed processing of client resources.

Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
---
 drivers/firewire/fw-cdev.c |   55 ++++++++++++++++++++++++++++++-------
 1 file changed, 46 insertions(+), 9 deletions(-)

Index: linux/drivers/firewire/fw-cdev.c
===================================================================
--- linux.orig/drivers/firewire/fw-cdev.c
+++ linux/drivers/firewire/fw-cdev.c
@@ -20,6 +20,7 @@
 
 #include <linux/module.h>
 #include <linux/kernel.h>
+#include <linux/kref.h>
 #include <linux/wait.h>
 #include <linux/errno.h>
 #include <linux/device.h>
@@ -94,8 +95,27 @@ struct client {
 	unsigned long vm_start;
 
 	struct list_head link;
+	struct kref kref;
 };
 
+static inline void client_get(struct client *client)
+{
+	kref_get(&client->kref);
+}
+
+static void client_release(struct kref *kref)
+{
+	struct client *client = container_of(kref, struct client, kref);
+
+	fw_device_put(client->device);
+	kfree(client);
+}
+
+static void client_put(struct client *client)
+{
+	kref_put(&client->kref, client_release);
+}
+
 static inline void __user *u64_to_uptr(__u64 value)
 {
 	return (void __user *)(unsigned long)value;
@@ -131,6 +151,7 @@ static int fw_device_op_open(struct inod
 	idr_init(&client->resource_idr);
 	INIT_LIST_HEAD(&client->event_list);
 	init_waitqueue_head(&client->wait);
+	kref_init(&client->kref);
 
 	file->private_data = client;
 
@@ -326,6 +347,8 @@ static int add_client_resource(struct cl
 	else
 		ret = idr_get_new(&client->resource_idr, resource,
 				  &resource->handle);
+	if (ret >= 0)
+		client_get(client);
 	spin_unlock_irqrestore(&client->lock, flags);
 
 	if (ret == -EAGAIN)
@@ -358,6 +381,8 @@ static int release_client_resource(struc
 	else
 		r->release(client, r);
 
+	client_put(client);
+
 	return 0;
 }
 
@@ -385,11 +410,21 @@ static void complete_transaction(struct 
 
 	spin_lock_irqsave(&client->lock, flags);
 	/*
-	 * If called while in shutdown, the idr tree must be left untouched.
-	 * The idr handle will be removed later.
+	 * 1. If called while in shutdown, the idr tree must be left untouched.
+	 *    The idr handle will be removed and the client reference will be
+	 *    dropped later.
+	 * 2. If the call chain was release_client_resource ->
+	 *    release_transaction -> complete_transaction (instead of a normal
+	 *    conclusion of the transaction), i.e. if this resource was already
+	 *    unregistered from the idr, the client reference will be dropped
+	 *    by release_client_resource and we must not drop it here.
 	 */
-	if (!client->in_shutdown)
+	if (!client->in_shutdown &&
+	    idr_find(&client->resource_idr, response->resource.handle)) {
 		idr_remove(&client->resource_idr, response->resource.handle);
+		/* Drop the idr's reference */
+		client_put(client);
+	}
 	spin_unlock_irqrestore(&client->lock, flags);
 
 	r->type   = FW_CDEV_EVENT_RESPONSE;
@@ -408,6 +443,9 @@ static void complete_transaction(struct 
 	else
 		queue_event(client, &response->event, r, sizeof(*r) + r->length,
 			    NULL, 0);
+
+	/* Drop the transaction callback's reference */
+	client_put(client);
 }
 
 static int ioctl_send_request(struct client *client, void *buffer)
@@ -459,6 +497,9 @@ static int ioctl_send_request(struct cli
 	if (ret < 0)
 		goto failed;
 
+	/* Get a reference for the transaction callback */
+	client_get(client);
+
 	fw_send_request(device->card, &response->transaction,
 			request->tcode & 0x1f,
 			device->node->node_id,
@@ -1044,6 +1085,7 @@ static int shutdown_resource(int id, voi
 	struct client *client = data;
 
 	r->release(client, r);
+	client_put(client);
 
 	return 0;
 }
@@ -1076,12 +1118,7 @@ static int fw_device_op_release(struct i
 	list_for_each_entry_safe(e, next_e, &client->event_list, link)
 		kfree(e);
 
-	/*
-	 * FIXME: client should be reference-counted.  It's extremely unlikely
-	 * but there may still be transactions being completed at this point.
-	 */
-	fw_device_put(client->device);
-	kfree(client);
+	client_put(client);
 
 	return 0;
 }

-- 
Stefan Richter
-=====-==--= ---= --=--
http://arcgraph.de/sr/

