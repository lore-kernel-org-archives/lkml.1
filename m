Return-Path: <linux-kernel-owner+w=401wt.eu-S1757215AbZADPZx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757215AbZADPZx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Jan 2009 10:25:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751584AbZADPZo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Jan 2009 10:25:44 -0500
Received: from einhorn.in-berlin.de ([192.109.42.8]:44042 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751329AbZADPZn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Jan 2009 10:25:43 -0500
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Sun, 4 Jan 2009 16:25:22 +0100 (CET)
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: [PATCH 02/11] firewire: cdev: unify names of struct types and of
 their instances
To: linux1394-devel@lists.sourceforge.net
cc: linux-kernel@vger.kernel.org
In-Reply-To: <tkrat.3905b2754a8fc519@s5r6.in-berlin.de>
Message-ID: <tkrat.00309228806cc3dd@s5r6.in-berlin.de>
References: <tkrat.3905b2754a8fc519@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=us-ascii
Content-Disposition: INLINE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

to indicate that they are specializations of struct event or of struct
client_resource, respectively.

struct response was both an event and a client_resource; it is now split
into struct outbound_transaction_resource and ~_event in order to
document more explicitly which types of client resources exist.

struct request and struct_request_event are renamed to struct
inbound_transaction_resource and ~_event because requests and responses
occur in outbound and in inbound transactions.

Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
---
 drivers/firewire/fw-cdev.c |  337 ++++++++++++++++++-------------------
 1 file changed, 169 insertions(+), 168 deletions(-)

Index: linux/drivers/firewire/fw-cdev.c
===================================================================
--- linux.orig/drivers/firewire/fw-cdev.c
+++ linux/drivers/firewire/fw-cdev.c
@@ -41,43 +41,6 @@
 #include "fw-topology.h"
 #include "fw-device.h"
 
-struct client;
-struct client_resource;
-typedef void (*client_resource_release_fn_t)(struct client *,
-					     struct client_resource *);
-struct client_resource {
-	client_resource_release_fn_t release;
-	int handle;
-};
-
-/*
- * dequeue_event() just kfree()'s the event, so the event has to be
- * the first field in the struct.
- */
-
-struct event {
-	struct { void *data; size_t size; } v[2];
-	struct list_head link;
-};
-
-struct bus_reset {
-	struct event event;
-	struct fw_cdev_event_bus_reset reset;
-};
-
-struct response {
-	struct event event;
-	struct fw_transaction transaction;
-	struct client *client;
-	struct client_resource resource;
-	struct fw_cdev_event_response response;
-};
-
-struct iso_interrupt {
-	struct event event;
-	struct fw_cdev_event_iso_interrupt interrupt;
-};
-
 struct client {
 	u32 version;
 	struct fw_device *device;
@@ -116,6 +79,70 @@ static void client_put(struct client *cl
 	kref_put(&client->kref, client_release);
 }
 
+struct client_resource;
+typedef void (*client_resource_release_fn_t)(struct client *,
+					     struct client_resource *);
+struct client_resource {
+	client_resource_release_fn_t release;
+	int handle;
+};
+
+struct address_handler_resource {
+	struct client_resource resource;
+	struct fw_address_handler handler;
+	__u64 closure;
+	struct client *client;
+};
+
+struct outbound_transaction_resource {
+	struct client_resource resource;
+	struct fw_transaction transaction;
+};
+
+struct inbound_transaction_resource {
+	struct client_resource resource;
+	struct fw_request *request;
+	void *data;
+	size_t length;
+};
+
+struct descriptor_resource {
+	struct client_resource resource;
+	struct fw_descriptor descriptor;
+	u32 data[0];
+};
+
+/*
+ * dequeue_event() just kfree()'s the event, so the event has to be
+ * the first field in a struct XYZ_event.
+ */
+struct event {
+	struct { void *data; size_t size; } v[2];
+	struct list_head link;
+};
+
+struct bus_reset_event {
+	struct event event;
+	struct fw_cdev_event_bus_reset reset;
+};
+
+struct outbound_transaction_event {
+	struct event event;
+	struct client *client;
+	struct outbound_transaction_resource r;
+	struct fw_cdev_event_response response;
+};
+
+struct inbound_transaction_event {
+	struct event event;
+	struct fw_cdev_event_request request;
+};
+
+struct iso_interrupt_event {
+	struct event event;
+	struct fw_cdev_event_iso_interrupt interrupt;
+};
+
 static inline void __user *u64_to_uptr(__u64 value)
 {
 	return (void __user *)(unsigned long)value;
@@ -263,18 +290,18 @@ static void for_each_client(struct fw_de
 
 static void queue_bus_reset_event(struct client *client)
 {
-	struct bus_reset *bus_reset;
+	struct bus_reset_event *e;
 
-	bus_reset = kzalloc(sizeof(*bus_reset), GFP_KERNEL);
-	if (bus_reset == NULL) {
+	e = kzalloc(sizeof(*e), GFP_KERNEL);
+	if (e == NULL) {
 		fw_notify("Out of memory when allocating bus reset event\n");
 		return;
 	}
 
-	fill_bus_reset_event(&bus_reset->reset, client);
+	fill_bus_reset_event(&e->reset, client);
 
-	queue_event(client, &bus_reset->event,
-		    &bus_reset->reset, sizeof(bus_reset->reset), NULL, 0);
+	queue_event(client, &e->event,
+		    &e->reset, sizeof(e->reset), NULL, 0);
 }
 
 void fw_device_cdev_update(struct fw_device *device)
@@ -389,24 +416,24 @@ static int release_client_resource(struc
 static void release_transaction(struct client *client,
 				struct client_resource *resource)
 {
-	struct response *response =
-		container_of(resource, struct response, resource);
+	struct outbound_transaction_resource *r = container_of(resource,
+			struct outbound_transaction_resource, resource);
 
-	fw_cancel_transaction(client->device->card, &response->transaction);
+	fw_cancel_transaction(client->device->card, &r->transaction);
 }
 
 static void complete_transaction(struct fw_card *card, int rcode,
 				 void *payload, size_t length, void *data)
 {
-	struct response *response = data;
-	struct client *client = response->client;
+	struct outbound_transaction_event *e = data;
+	struct fw_cdev_event_response *rsp = &e->response;
+	struct client *client = e->client;
 	unsigned long flags;
-	struct fw_cdev_event_response *r = &response->response;
 
-	if (length < r->length)
-		r->length = length;
+	if (length < rsp->length)
+		rsp->length = length;
 	if (rcode == RCODE_COMPLETE)
-		memcpy(r->data, payload, r->length);
+		memcpy(rsp->data, payload, rsp->length);
 
 	spin_lock_irqsave(&client->lock, flags);
 	/*
@@ -420,28 +447,28 @@ static void complete_transaction(struct 
 	 *    by release_client_resource and we must not drop it here.
 	 */
 	if (!client->in_shutdown &&
-	    idr_find(&client->resource_idr, response->resource.handle)) {
-		idr_remove(&client->resource_idr, response->resource.handle);
+	    idr_find(&client->resource_idr, e->r.resource.handle)) {
+		idr_remove(&client->resource_idr, e->r.resource.handle);
 		/* Drop the idr's reference */
 		client_put(client);
 	}
 	spin_unlock_irqrestore(&client->lock, flags);
 
-	r->type   = FW_CDEV_EVENT_RESPONSE;
-	r->rcode  = rcode;
+	rsp->type = FW_CDEV_EVENT_RESPONSE;
+	rsp->rcode = rcode;
 
 	/*
-	 * In the case that sizeof(*r) doesn't align with the position of the
+	 * In the case that sizeof(*rsp) doesn't align with the position of the
 	 * data, and the read is short, preserve an extra copy of the data
 	 * to stay compatible with a pre-2.6.27 bug.  Since the bug is harmless
 	 * for short reads and some apps depended on it, this is both safe
 	 * and prudent for compatibility.
 	 */
-	if (r->length <= sizeof(*r) - offsetof(typeof(*r), data))
-		queue_event(client, &response->event, r, sizeof(*r),
-			    r->data, r->length);
+	if (rsp->length <= sizeof(*rsp) - offsetof(typeof(*rsp), data))
+		queue_event(client, &e->event, rsp, sizeof(*rsp),
+			    rsp->data, rsp->length);
 	else
-		queue_event(client, &response->event, r, sizeof(*r) + r->length,
+		queue_event(client, &e->event, rsp, sizeof(*rsp) + rsp->length,
 			    NULL, 0);
 
 	/* Drop the transaction callback's reference */
@@ -452,23 +479,23 @@ static int ioctl_send_request(struct cli
 {
 	struct fw_device *device = client->device;
 	struct fw_cdev_send_request *request = buffer;
-	struct response *response;
+	struct outbound_transaction_event *e;
 	int ret;
 
 	/* What is the biggest size we'll accept, really? */
 	if (request->length > 4096)
 		return -EINVAL;
 
-	response = kmalloc(sizeof(*response) + request->length, GFP_KERNEL);
-	if (response == NULL)
+	e = kmalloc(sizeof(*e) + request->length, GFP_KERNEL);
+	if (e == NULL)
 		return -ENOMEM;
 
-	response->client = client;
-	response->response.length = request->length;
-	response->response.closure = request->closure;
+	e->client = client;
+	e->response.length = request->length;
+	e->response.closure = request->closure;
 
 	if (request->data &&
-	    copy_from_user(response->response.data,
+	    copy_from_user(e->response.data,
 			   u64_to_uptr(request->data), request->length)) {
 		ret = -EFAULT;
 		goto failed;
@@ -492,86 +519,66 @@ static int ioctl_send_request(struct cli
 		goto failed;
 	}
 
-	response->resource.release = release_transaction;
-	ret = add_client_resource(client, &response->resource, GFP_KERNEL);
+	e->r.resource.release = release_transaction;
+	ret = add_client_resource(client, &e->r.resource, GFP_KERNEL);
 	if (ret < 0)
 		goto failed;
 
 	/* Get a reference for the transaction callback */
 	client_get(client);
 
-	fw_send_request(device->card, &response->transaction,
+	fw_send_request(device->card, &e->r.transaction,
 			request->tcode & 0x1f,
 			device->node->node_id,
 			request->generation,
 			device->max_speed,
 			request->offset,
-			response->response.data, request->length,
-			complete_transaction, response);
+			e->response.data, request->length,
+			complete_transaction, e);
 
 	if (request->data)
 		return sizeof(request) + request->length;
 	else
 		return sizeof(request);
  failed:
-	kfree(response);
+	kfree(e);
 
 	return ret;
 }
 
-struct address_handler {
-	struct fw_address_handler handler;
-	__u64 closure;
-	struct client *client;
-	struct client_resource resource;
-};
-
-struct request {
-	struct fw_request *request;
-	void *data;
-	size_t length;
-	struct client_resource resource;
-};
-
-struct request_event {
-	struct event event;
-	struct fw_cdev_event_request request;
-};
-
 static void release_request(struct client *client,
 			    struct client_resource *resource)
 {
-	struct request *request =
-		container_of(resource, struct request, resource);
+	struct inbound_transaction_resource *r = container_of(resource,
+			struct inbound_transaction_resource, resource);
 
-	fw_send_response(client->device->card, request->request,
+	fw_send_response(client->device->card, r->request,
 			 RCODE_CONFLICT_ERROR);
-	kfree(request);
+	kfree(r);
 }
 
-static void handle_request(struct fw_card *card, struct fw_request *r,
+static void handle_request(struct fw_card *card, struct fw_request *request,
 			   int tcode, int destination, int source,
 			   int generation, int speed,
 			   unsigned long long offset,
 			   void *payload, size_t length, void *callback_data)
 {
-	struct address_handler *handler = callback_data;
-	struct request *request;
-	struct request_event *e;
-	struct client *client = handler->client;
+	struct address_handler_resource *handler = callback_data;
+	struct inbound_transaction_resource *r;
+	struct inbound_transaction_event *e;
 	int ret;
 
-	request = kmalloc(sizeof(*request), GFP_ATOMIC);
+	r = kmalloc(sizeof(*r), GFP_ATOMIC);
 	e = kmalloc(sizeof(*e), GFP_ATOMIC);
-	if (request == NULL || e == NULL)
+	if (r == NULL || e == NULL)
 		goto failed;
 
-	request->request = r;
-	request->data    = payload;
-	request->length  = length;
+	r->request = request;
+	r->data    = payload;
+	r->length  = length;
 
-	request->resource.release = release_request;
-	ret = add_client_resource(client, &request->resource, GFP_ATOMIC);
+	r->resource.release = release_request;
+	ret = add_client_resource(handler->client, &r->resource, GFP_ATOMIC);
 	if (ret < 0)
 		goto failed;
 
@@ -579,61 +586,61 @@ static void handle_request(struct fw_car
 	e->request.tcode   = tcode;
 	e->request.offset  = offset;
 	e->request.length  = length;
-	e->request.handle  = request->resource.handle;
+	e->request.handle  = r->resource.handle;
 	e->request.closure = handler->closure;
 
-	queue_event(client, &e->event,
+	queue_event(handler->client, &e->event,
 		    &e->request, sizeof(e->request), payload, length);
 	return;
 
  failed:
-	kfree(request);
+	kfree(r);
 	kfree(e);
-	fw_send_response(card, r, RCODE_CONFLICT_ERROR);
+	fw_send_response(card, request, RCODE_CONFLICT_ERROR);
 }
 
 static void release_address_handler(struct client *client,
 				    struct client_resource *resource)
 {
-	struct address_handler *handler =
-		container_of(resource, struct address_handler, resource);
+	struct address_handler_resource *r =
+	    container_of(resource, struct address_handler_resource, resource);
 
-	fw_core_remove_address_handler(&handler->handler);
-	kfree(handler);
+	fw_core_remove_address_handler(&r->handler);
+	kfree(r);
 }
 
 static int ioctl_allocate(struct client *client, void *buffer)
 {
 	struct fw_cdev_allocate *request = buffer;
-	struct address_handler *handler;
+	struct address_handler_resource *r;
 	struct fw_address_region region;
 	int ret;
 
-	handler = kmalloc(sizeof(*handler), GFP_KERNEL);
-	if (handler == NULL)
+	r = kmalloc(sizeof(*r), GFP_KERNEL);
+	if (r == NULL)
 		return -ENOMEM;
 
 	region.start = request->offset;
 	region.end = request->offset + request->length;
-	handler->handler.length = request->length;
-	handler->handler.address_callback = handle_request;
-	handler->handler.callback_data = handler;
-	handler->closure = request->closure;
-	handler->client = client;
+	r->handler.length = request->length;
+	r->handler.address_callback = handle_request;
+	r->handler.callback_data = r;
+	r->closure = request->closure;
+	r->client = client;
 
-	ret = fw_core_add_address_handler(&handler->handler, &region);
+	ret = fw_core_add_address_handler(&r->handler, &region);
 	if (ret < 0) {
-		kfree(handler);
+		kfree(r);
 		return ret;
 	}
 
-	handler->resource.release = release_address_handler;
-	ret = add_client_resource(client, &handler->resource, GFP_KERNEL);
+	r->resource.release = release_address_handler;
+	ret = add_client_resource(client, &r->resource, GFP_KERNEL);
 	if (ret < 0) {
-		release_address_handler(client, &handler->resource);
+		release_address_handler(client, &r->resource);
 		return ret;
 	}
-	request->handle = handler->resource.handle;
+	request->handle = r->resource.handle;
 
 	return 0;
 }
@@ -650,13 +657,14 @@ static int ioctl_send_response(struct cl
 {
 	struct fw_cdev_send_response *request = buffer;
 	struct client_resource *resource;
-	struct request *r;
+	struct inbound_transaction_resource *r;
 
 	if (release_client_resource(client, request->handle,
 				    release_request, &resource) < 0)
 		return -EINVAL;
 
-	r = container_of(resource, struct request, resource);
+	r = container_of(resource, struct inbound_transaction_resource,
+			 resource);
 	if (request->length < r->length)
 		r->length = request->length;
 	if (copy_from_user(r->data, u64_to_uptr(request->data), r->length))
@@ -678,62 +686,55 @@ static int ioctl_initiate_bus_reset(stru
 	return fw_core_initiate_bus_reset(client->device->card, short_reset);
 }
 
-struct descriptor {
-	struct fw_descriptor d;
-	struct client_resource resource;
-	u32 data[0];
-};
-
 static void release_descriptor(struct client *client,
 			       struct client_resource *resource)
 {
-	struct descriptor *descriptor =
-		container_of(resource, struct descriptor, resource);
+	struct descriptor_resource *r =
+		container_of(resource, struct descriptor_resource, resource);
 
-	fw_core_remove_descriptor(&descriptor->d);
-	kfree(descriptor);
+	fw_core_remove_descriptor(&r->descriptor);
+	kfree(r);
 }
 
 static int ioctl_add_descriptor(struct client *client, void *buffer)
 {
 	struct fw_cdev_add_descriptor *request = buffer;
-	struct descriptor *descriptor;
+	struct descriptor_resource *r;
 	int ret;
 
 	if (request->length > 256)
 		return -EINVAL;
 
-	descriptor =
-		kmalloc(sizeof(*descriptor) + request->length * 4, GFP_KERNEL);
-	if (descriptor == NULL)
+	r = kmalloc(sizeof(*r) + request->length * 4, GFP_KERNEL);
+	if (r == NULL)
 		return -ENOMEM;
 
-	if (copy_from_user(descriptor->data,
+	if (copy_from_user(r->data,
 			   u64_to_uptr(request->data), request->length * 4)) {
 		ret = -EFAULT;
 		goto failed;
 	}
 
-	descriptor->d.length = request->length;
-	descriptor->d.immediate = request->immediate;
-	descriptor->d.key = request->key;
-	descriptor->d.data = descriptor->data;
+	r->descriptor.length    = request->length;
+	r->descriptor.immediate = request->immediate;
+	r->descriptor.key       = request->key;
+	r->descriptor.data      = r->data;
 
-	ret = fw_core_add_descriptor(&descriptor->d);
+	ret = fw_core_add_descriptor(&r->descriptor);
 	if (ret < 0)
 		goto failed;
 
-	descriptor->resource.release = release_descriptor;
-	ret = add_client_resource(client, &descriptor->resource, GFP_KERNEL);
+	r->resource.release = release_descriptor;
+	ret = add_client_resource(client, &r->resource, GFP_KERNEL);
 	if (ret < 0) {
-		fw_core_remove_descriptor(&descriptor->d);
+		fw_core_remove_descriptor(&r->descriptor);
 		goto failed;
 	}
-	request->handle = descriptor->resource.handle;
+	request->handle = r->resource.handle;
 
 	return 0;
  failed:
-	kfree(descriptor);
+	kfree(r);
 
 	return ret;
 }
@@ -750,19 +751,19 @@ static void iso_callback(struct fw_iso_c
 			 size_t header_length, void *header, void *data)
 {
 	struct client *client = data;
-	struct iso_interrupt *irq;
+	struct iso_interrupt_event *e;
 
-	irq = kzalloc(sizeof(*irq) + header_length, GFP_ATOMIC);
-	if (irq == NULL)
+	e = kzalloc(sizeof(*e) + header_length, GFP_ATOMIC);
+	if (e == NULL)
 		return;
 
-	irq->interrupt.type      = FW_CDEV_EVENT_ISO_INTERRUPT;
-	irq->interrupt.closure   = client->iso_closure;
-	irq->interrupt.cycle     = cycle;
-	irq->interrupt.header_length = header_length;
-	memcpy(irq->interrupt.header, header, header_length);
-	queue_event(client, &irq->event, &irq->interrupt,
-		    sizeof(irq->interrupt) + header_length, NULL, 0);
+	e->interrupt.type      = FW_CDEV_EVENT_ISO_INTERRUPT;
+	e->interrupt.closure   = client->iso_closure;
+	e->interrupt.cycle     = cycle;
+	e->interrupt.header_length = header_length;
+	memcpy(e->interrupt.header, header, header_length);
+	queue_event(client, &e->event, &e->interrupt,
+		    sizeof(e->interrupt) + header_length, NULL, 0);
 }
 
 static int ioctl_create_iso_context(struct client *client, void *buffer)

-- 
Stefan Richter
-=====-==--= ---= --=--
http://arcgraph.de/sr/

