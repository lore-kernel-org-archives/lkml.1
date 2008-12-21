Return-Path: <linux-kernel-owner+w=401wt.eu-S1754601AbYLUPsR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754601AbYLUPsR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Dec 2008 10:48:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752429AbYLUPsF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 21 Dec 2008 10:48:05 -0500
Received: from einhorn.in-berlin.de ([192.109.42.8]:50500 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752376AbYLUPsB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Dec 2008 10:48:01 -0500
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Sun, 21 Dec 2008 16:47:17 +0100 (CET)
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: [PATCH 2/4 update] firewire: cdev: use an idr rather than a linked
 list for resources
To: linux1394-devel@lists.sourceforge.net
cc: linux-kernel@vger.kernel.org, Jay Fenlason <fenlason@redhat.com>
In-Reply-To: <494AD72B.5050107@s5r6.in-berlin.de>
Message-ID: <tkrat.63b5be4a961a29a5@s5r6.in-berlin.de>
References: <20081124163728.GA5826@redhat.com>
 <492AEED8.9030102@s5r6.in-berlin.de> <492AEF9D.5010307@s5r6.in-berlin.de>
 <tkrat.7bf80e1dd5c90f36@s5r6.in-berlin.de>
 <tkrat.c14b3f03d12b2b29@s5r6.in-berlin.de>
 <494AD224.4000200@s5r6.in-berlin.de> <494AD72B.5050107@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=us-ascii
Content-Disposition: INLINE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jay Fenlason <fenlason@redhat.com>

The current code uses a linked list and a counter for storing
resources and the corresponding handle numbers.  By changing to an idr
we can be safe from counter wrap-around giving two resources the same
handle.

Furthermore, the deallocation ioctls now check whether the resource to
be freed is of the intended type.

Signed-off-by: Jay Fenlason <fenlason@redhat.com>

Some rework by Stefan R:
  - The idr API documentation says we get an ID within 0...0x7fffffff.
    Hence we can rest assured that idr handles fit into cdev handles.
  - Fix some races.  Add a client->in_shutdown flag for this purpose.
  - Add allocation retry to add_client_resource().
  - It is possible to use idr_for_each() in fw_device_op_release().
  - Fix ioctl_send_response() regression.
  - Small style changes.

Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
---

FCP broke in the previous iteration of this patch because
ioctl_send_response() specified a wrong release hook to
release_client_resource().

 drivers/firewire/fw-cdev.c |  165 +++++++++++++++++++++++++------------
 1 file changed, 114 insertions(+), 51 deletions(-)

Index: linux/drivers/firewire/fw-cdev.c
===================================================================
--- linux.orig/drivers/firewire/fw-cdev.c
+++ linux/drivers/firewire/fw-cdev.c
@@ -41,10 +41,12 @@
 #include "fw-device.h"
 
 struct client;
+struct client_resource;
+typedef void (*client_resource_release_fn_t)(struct client *,
+					     struct client_resource *);
 struct client_resource {
-	struct list_head link;
-	void (*release)(struct client *client, struct client_resource *r);
-	u32 handle;
+	client_resource_release_fn_t release;
+	int handle;
 };
 
 /*
@@ -78,9 +80,10 @@ struct iso_interrupt {
 struct client {
 	u32 version;
 	struct fw_device *device;
+
 	spinlock_t lock;
-	u32 resource_handle;
-	struct list_head resource_list;
+	bool in_shutdown;
+	struct idr resource_idr;
 	struct list_head event_list;
 	wait_queue_head_t wait;
 	u64 bus_reset_closure;
@@ -126,9 +129,9 @@ static int fw_device_op_open(struct inod
 	}
 
 	client->device = device;
-	INIT_LIST_HEAD(&client->event_list);
-	INIT_LIST_HEAD(&client->resource_list);
 	spin_lock_init(&client->lock);
+	idr_init(&client->resource_idr);
+	INIT_LIST_HEAD(&client->event_list);
 	init_waitqueue_head(&client->wait);
 
 	file->private_data = client;
@@ -151,7 +154,10 @@ static void queue_event(struct client *c
 	event->v[1].size = size1;
 
 	spin_lock_irqsave(&client->lock, flags);
-	list_add_tail(&event->link, &client->event_list);
+	if (client->in_shutdown)
+		kfree(event);
+	else
+		list_add_tail(&event->link, &client->event_list);
 	spin_unlock_irqrestore(&client->lock, flags);
 
 	wake_up_interruptible(&client->wait);
@@ -310,34 +316,49 @@ static int ioctl_get_info(struct client 
 	return 0;
 }
 
-static void
-add_client_resource(struct client *client, struct client_resource *resource)
+static int
+add_client_resource(struct client *client, struct client_resource *resource,
+		    gfp_t gfp_mask)
 {
 	unsigned long flags;
+	int ret;
+
+ retry:
+	if (idr_pre_get(&client->resource_idr, gfp_mask) == 0)
+		return -ENOMEM;
 
 	spin_lock_irqsave(&client->lock, flags);
-	list_add_tail(&resource->link, &client->resource_list);
-	resource->handle = client->resource_handle++;
+	if (client->in_shutdown)
+		ret = -ECANCELED;
+	else
+		ret = idr_get_new(&client->resource_idr, resource,
+				  &resource->handle);
 	spin_unlock_irqrestore(&client->lock, flags);
+
+	if (ret == -EAGAIN)
+		goto retry;
+
+	return ret < 0 ? ret : 0;
 }
 
 static int
 release_client_resource(struct client *client, u32 handle,
+			client_resource_release_fn_t release,
 			struct client_resource **resource)
 {
 	struct client_resource *r;
 	unsigned long flags;
 
 	spin_lock_irqsave(&client->lock, flags);
-	list_for_each_entry(r, &client->resource_list, link) {
-		if (r->handle == handle) {
-			list_del(&r->link);
-			break;
-		}
-	}
+	if (client->in_shutdown)
+		r = NULL;
+	else
+		r = idr_find(&client->resource_idr, handle);
+	if (r && r->release == release)
+		idr_remove(&client->resource_idr, handle);
 	spin_unlock_irqrestore(&client->lock, flags);
 
-	if (&r->link == &client->resource_list)
+	if (!(r && r->release == release))
 		return -EINVAL;
 
 	if (resource)
@@ -372,7 +393,12 @@ complete_transaction(struct fw_card *car
 		memcpy(r->data, payload, r->length);
 
 	spin_lock_irqsave(&client->lock, flags);
-	list_del(&response->resource.link);
+	/*
+	 * If called while in shutdown, the idr tree must be left untouched.
+	 * The idr handle will be removed later.
+	 */
+	if (!client->in_shutdown)
+		idr_remove(&client->resource_idr, response->resource.handle);
 	spin_unlock_irqrestore(&client->lock, flags);
 
 	r->type   = FW_CDEV_EVENT_RESPONSE;
@@ -416,7 +442,7 @@ static int ioctl_send_request(struct cli
 	    copy_from_user(response->response.data,
 			   u64_to_uptr(request->data), request->length)) {
 		ret = -EFAULT;
-		goto err;
+		goto failed;
 	}
 
 	switch (request->tcode) {
@@ -434,11 +460,13 @@ static int ioctl_send_request(struct cli
 		break;
 	default:
 		ret = -EINVAL;
-		goto err;
+		goto failed;
 	}
 
 	response->resource.release = release_transaction;
-	add_client_resource(client, &response->resource);
+	ret = add_client_resource(client, &response->resource, GFP_KERNEL);
+	if (ret < 0)
+		goto failed;
 
 	fw_send_request(device->card, &response->transaction,
 			request->tcode & 0x1f,
@@ -453,7 +481,7 @@ static int ioctl_send_request(struct cli
 		return sizeof(request) + request->length;
 	else
 		return sizeof(request);
- err:
+ failed:
 	kfree(response);
 
 	return ret;
@@ -500,22 +528,21 @@ handle_request(struct fw_card *card, str
 	struct request *request;
 	struct request_event *e;
 	struct client *client = handler->client;
+	int ret;
 
 	request = kmalloc(sizeof(*request), GFP_ATOMIC);
 	e = kmalloc(sizeof(*e), GFP_ATOMIC);
-	if (request == NULL || e == NULL) {
-		kfree(request);
-		kfree(e);
-		fw_send_response(card, r, RCODE_CONFLICT_ERROR);
-		return;
-	}
+	if (request == NULL || e == NULL)
+		goto failed;
 
 	request->request = r;
 	request->data    = payload;
 	request->length  = length;
 
 	request->resource.release = release_request;
-	add_client_resource(client, &request->resource);
+	ret = add_client_resource(client, &request->resource, GFP_ATOMIC);
+	if (ret < 0)
+		goto failed;
 
 	e->request.type    = FW_CDEV_EVENT_REQUEST;
 	e->request.tcode   = tcode;
@@ -526,6 +553,12 @@ handle_request(struct fw_card *card, str
 
 	queue_event(client, &e->event,
 		    &e->request, sizeof(e->request), payload, length);
+	return;
+
+ failed:
+	kfree(request);
+	kfree(e);
+	fw_send_response(card, r, RCODE_CONFLICT_ERROR);
 }
 
 static void
@@ -544,6 +577,7 @@ static int ioctl_allocate(struct client 
 	struct fw_cdev_allocate *request = buffer;
 	struct address_handler *handler;
 	struct fw_address_region region;
+	int ret;
 
 	handler = kmalloc(sizeof(*handler), GFP_KERNEL);
 	if (handler == NULL)
@@ -563,7 +597,11 @@ static int ioctl_allocate(struct client 
 	}
 
 	handler->resource.release = release_address_handler;
-	add_client_resource(client, &handler->resource);
+	ret = add_client_resource(client, &handler->resource, GFP_KERNEL);
+	if (ret < 0) {
+		release_address_handler(client, &handler->resource);
+		return ret;
+	}
 	request->handle = handler->resource.handle;
 
 	return 0;
@@ -573,7 +611,8 @@ static int ioctl_deallocate(struct clien
 {
 	struct fw_cdev_deallocate *request = buffer;
 
-	return release_client_resource(client, request->handle, NULL);
+	return release_client_resource(client, request->handle,
+				       release_address_handler, NULL);
 }
 
 static int ioctl_send_response(struct client *client, void *buffer)
@@ -582,8 +621,10 @@ static int ioctl_send_response(struct cl
 	struct client_resource *resource;
 	struct request *r;
 
-	if (release_client_resource(client, request->handle, &resource) < 0)
+	if (release_client_resource(client, request->handle,
+				    release_request, &resource) < 0)
 		return -EINVAL;
+
 	r = container_of(resource, struct request, resource);
 	if (request->length < r->length)
 		r->length = request->length;
@@ -626,7 +667,7 @@ static int ioctl_add_descriptor(struct c
 {
 	struct fw_cdev_add_descriptor *request = buffer;
 	struct descriptor *descriptor;
-	int retval;
+	int ret;
 
 	if (request->length > 256)
 		return -EINVAL;
@@ -638,8 +679,8 @@ static int ioctl_add_descriptor(struct c
 
 	if (copy_from_user(descriptor->data,
 			   u64_to_uptr(request->data), request->length * 4)) {
-		kfree(descriptor);
-		return -EFAULT;
+		ret = -EFAULT;
+		goto failed;
 	}
 
 	descriptor->d.length = request->length;
@@ -647,24 +688,31 @@ static int ioctl_add_descriptor(struct c
 	descriptor->d.key = request->key;
 	descriptor->d.data = descriptor->data;
 
-	retval = fw_core_add_descriptor(&descriptor->d);
-	if (retval < 0) {
-		kfree(descriptor);
-		return retval;
-	}
+	ret = fw_core_add_descriptor(&descriptor->d);
+	if (ret < 0)
+		goto failed;
 
 	descriptor->resource.release = release_descriptor;
-	add_client_resource(client, &descriptor->resource);
+	ret = add_client_resource(client, &descriptor->resource, GFP_KERNEL);
+	if (ret < 0) {
+		fw_core_remove_descriptor(&descriptor->d);
+		goto failed;
+	}
 	request->handle = descriptor->resource.handle;
 
 	return 0;
+ failed:
+	kfree(descriptor);
+
+	return ret;
 }
 
 static int ioctl_remove_descriptor(struct client *client, void *buffer)
 {
 	struct fw_cdev_remove_descriptor *request = buffer;
 
-	return release_client_resource(client, request->handle, NULL);
+	return release_client_resource(client, request->handle,
+				       release_descriptor, NULL);
 }
 
 static void
@@ -1003,11 +1051,21 @@ static int fw_device_op_mmap(struct file
 	return retval;
 }
 
+static int shutdown_resource(int id, void *p, void *data)
+{
+	struct client_resource *r = p;
+	struct client *client = data;
+
+	r->release(client, r);
+
+	return 0;
+}
+
 static int fw_device_op_release(struct inode *inode, struct file *file)
 {
 	struct client *client = file->private_data;
 	struct event *e, *next_e;
-	struct client_resource *r, *next_r;
+	unsigned long flags;
 
 	mutex_lock(&client->device->client_list_mutex);
 	list_del(&client->link);
@@ -1019,17 +1077,22 @@ static int fw_device_op_release(struct i
 	if (client->iso_context)
 		fw_iso_context_destroy(client->iso_context);
 
-	list_for_each_entry_safe(r, next_r, &client->resource_list, link)
-		r->release(client, r);
+	/* Freeze client->resource_idr and client->event_list */
+	spin_lock_irqsave(&client->lock, flags);
+	client->in_shutdown = true;
+	spin_unlock_irqrestore(&client->lock, flags);
 
-	/*
-	 * FIXME: We should wait for the async tasklets to stop
-	 * running before freeing the memory.
-	 */
+	idr_for_each(&client->resource_idr, shutdown_resource, client);
+	idr_remove_all(&client->resource_idr);
+	idr_destroy(&client->resource_idr);
 
 	list_for_each_entry_safe(e, next_e, &client->event_list, link)
 		kfree(e);
 
+	/*
+	 * FIXME: client should be reference-counted.  It's extremely unlikely
+	 * but there may still be transactions being completed at this point.
+	 */
 	fw_device_put(client->device);
 	kfree(client);
 

-- 
Stefan Richter
-=====-==--- ==-- =-=-=
http://arcgraph.de/sr/

