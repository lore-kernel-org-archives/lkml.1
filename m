Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753038Ab0BUQ4i (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Feb 2010 11:56:38 -0500
Received: from einhorn.in-berlin.de ([192.109.42.8]:58339 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752098Ab0BUQ4g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Feb 2010 11:56:36 -0500
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Sun, 21 Feb 2010 17:56:21 +0100 (CET)
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: [PATCH 1/8] firewire: core: change type of a data buffer
To: linux1394-devel@lists.sourceforge.net
cc: linux-kernel@vger.kernel.org
In-Reply-To: <tkrat.70de9801677fe5e9@s5r6.in-berlin.de>
Message-ID: <tkrat.4014c4d777b9cf5a@s5r6.in-berlin.de>
References: <tkrat.70de9801677fe5e9@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=us-ascii
Content-Disposition: INLINE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

from array of char to union of structs.  I already used a union to size
the buffer which holds ioctl arguments; more consequent is to define it
as an instance of this union in the first place.

Also rename several local variables from "request" to "a"(rgument) since
the term request can be mistaken to mean a transaction subaction, e.g.
an instance of struct fw_request.

Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
---
 drivers/firewire/core-cdev.c |  325 ++++++++++++++++-------------------
 1 file changed, 152 insertions(+), 173 deletions(-)

Index: b/drivers/firewire/core-cdev.c
===================================================================
--- a/drivers/firewire/core-cdev.c
+++ b/drivers/firewire/core-cdev.c
@@ -368,39 +368,56 @@ void fw_device_cdev_remove(struct fw_dev
 	for_each_client(device, wake_up_client);
 }
 
-static int ioctl_get_info(struct client *client, void *buffer)
+union ioctl_arg {
+	struct fw_cdev_get_info			get_info;
+	struct fw_cdev_send_request		send_request;
+	struct fw_cdev_allocate			allocate;
+	struct fw_cdev_deallocate		deallocate;
+	struct fw_cdev_send_response		send_response;
+	struct fw_cdev_initiate_bus_reset	initiate_bus_reset;
+	struct fw_cdev_add_descriptor		add_descriptor;
+	struct fw_cdev_remove_descriptor	remove_descriptor;
+	struct fw_cdev_create_iso_context	create_iso_context;
+	struct fw_cdev_queue_iso		queue_iso;
+	struct fw_cdev_start_iso		start_iso;
+	struct fw_cdev_stop_iso			stop_iso;
+	struct fw_cdev_get_cycle_timer		get_cycle_timer;
+	struct fw_cdev_allocate_iso_resource	allocate_iso_resource;
+	struct fw_cdev_send_stream_packet	send_stream_packet;
+	struct fw_cdev_get_cycle_timer2		get_cycle_timer2;
+};
+
+static int ioctl_get_info(struct client *client, union ioctl_arg *arg)
 {
-	struct fw_cdev_get_info *get_info = buffer;
+	struct fw_cdev_get_info *a = &arg->get_info;
 	struct fw_cdev_event_bus_reset bus_reset;
 	unsigned long ret = 0;
 
-	client->version = get_info->version;
-	get_info->version = FW_CDEV_VERSION;
-	get_info->card = client->device->card->index;
+	client->version = a->version;
+	a->version = FW_CDEV_VERSION;
+	a->card = client->device->card->index;
 
 	down_read(&fw_device_rwsem);
 
-	if (get_info->rom != 0) {
-		void __user *uptr = u64_to_uptr(get_info->rom);
-		size_t want = get_info->rom_length;
+	if (a->rom != 0) {
+		size_t want = a->rom_length;
 		size_t have = client->device->config_rom_length * 4;
 
-		ret = copy_to_user(uptr, client->device->config_rom,
-				   min(want, have));
+		ret = copy_to_user(u64_to_uptr(a->rom),
+				   client->device->config_rom, min(want, have));
 	}
-	get_info->rom_length = client->device->config_rom_length * 4;
+	a->rom_length = client->device->config_rom_length * 4;
 
 	up_read(&fw_device_rwsem);
 
 	if (ret != 0)
 		return -EFAULT;
 
-	client->bus_reset_closure = get_info->bus_reset_closure;
-	if (get_info->bus_reset != 0) {
-		void __user *uptr = u64_to_uptr(get_info->bus_reset);
-
+	client->bus_reset_closure = a->bus_reset_closure;
+	if (a->bus_reset != 0) {
 		fill_bus_reset_event(&bus_reset, client);
-		if (copy_to_user(uptr, &bus_reset, sizeof(bus_reset)))
+		if (copy_to_user(u64_to_uptr(a->bus_reset),
+				 &bus_reset, sizeof(bus_reset)))
 			return -EFAULT;
 	}
 
@@ -571,11 +588,9 @@ static int init_request(struct client *c
 	return ret;
 }
 
-static int ioctl_send_request(struct client *client, void *buffer)
+static int ioctl_send_request(struct client *client, union ioctl_arg *arg)
 {
-	struct fw_cdev_send_request *request = buffer;
-
-	switch (request->tcode) {
+	switch (arg->send_request.tcode) {
 	case TCODE_WRITE_QUADLET_REQUEST:
 	case TCODE_WRITE_BLOCK_REQUEST:
 	case TCODE_READ_QUADLET_REQUEST:
@@ -592,7 +607,7 @@ static int ioctl_send_request(struct cli
 		return -EINVAL;
 	}
 
-	return init_request(client, request, client->device->node_id,
+	return init_request(client, &arg->send_request, client->device->node_id,
 			    client->device->max_speed);
 }
 
@@ -683,9 +698,9 @@ static void release_address_handler(stru
 	kfree(r);
 }
 
-static int ioctl_allocate(struct client *client, void *buffer)
+static int ioctl_allocate(struct client *client, union ioctl_arg *arg)
 {
-	struct fw_cdev_allocate *request = buffer;
+	struct fw_cdev_allocate *a = &arg->allocate;
 	struct address_handler_resource *r;
 	struct fw_address_region region;
 	int ret;
@@ -694,13 +709,13 @@ static int ioctl_allocate(struct client 
 	if (r == NULL)
 		return -ENOMEM;
 
-	region.start = request->offset;
-	region.end = request->offset + request->length;
-	r->handler.length = request->length;
+	region.start = a->offset;
+	region.end   = a->offset + a->length;
+	r->handler.length           = a->length;
 	r->handler.address_callback = handle_request;
-	r->handler.callback_data = r;
-	r->closure = request->closure;
-	r->client = client;
+	r->handler.callback_data    = r;
+	r->closure   = a->closure;
+	r->client    = client;
 
 	ret = fw_core_add_address_handler(&r->handler, &region);
 	if (ret < 0) {
@@ -714,27 +729,25 @@ static int ioctl_allocate(struct client 
 		release_address_handler(client, &r->resource);
 		return ret;
 	}
-	request->handle = r->resource.handle;
+	a->handle = r->resource.handle;
 
 	return 0;
 }
 
-static int ioctl_deallocate(struct client *client, void *buffer)
+static int ioctl_deallocate(struct client *client, union ioctl_arg *arg)
 {
-	struct fw_cdev_deallocate *request = buffer;
-
-	return release_client_resource(client, request->handle,
+	return release_client_resource(client, arg->deallocate.handle,
 				       release_address_handler, NULL);
 }
 
-static int ioctl_send_response(struct client *client, void *buffer)
+static int ioctl_send_response(struct client *client, union ioctl_arg *arg)
 {
-	struct fw_cdev_send_response *request = buffer;
+	struct fw_cdev_send_response *a = &arg->send_response;
 	struct client_resource *resource;
 	struct inbound_transaction_resource *r;
 	int ret = 0;
 
-	if (release_client_resource(client, request->handle,
+	if (release_client_resource(client, a->handle,
 				    release_request, &resource) < 0)
 		return -EINVAL;
 
@@ -743,28 +756,24 @@ static int ioctl_send_response(struct cl
 	if (is_fcp_request(r->request))
 		goto out;
 
-	if (request->length < r->length)
-		r->length = request->length;
-	if (copy_from_user(r->data, u64_to_uptr(request->data), r->length)) {
+	if (a->length < r->length)
+		r->length = a->length;
+	if (copy_from_user(r->data, u64_to_uptr(a->data), r->length)) {
 		ret = -EFAULT;
 		kfree(r->request);
 		goto out;
 	}
-	fw_send_response(client->device->card, r->request, request->rcode);
+	fw_send_response(client->device->card, r->request, a->rcode);
  out:
 	kfree(r);
 
 	return ret;
 }
 
-static int ioctl_initiate_bus_reset(struct client *client, void *buffer)
+static int ioctl_initiate_bus_reset(struct client *client, union ioctl_arg *arg)
 {
-	struct fw_cdev_initiate_bus_reset *request = buffer;
-	int short_reset;
-
-	short_reset = (request->type == FW_CDEV_SHORT_RESET);
-
-	return fw_core_initiate_bus_reset(client->device->card, short_reset);
+	return fw_core_initiate_bus_reset(client->device->card,
+			arg->initiate_bus_reset.type == FW_CDEV_SHORT_RESET);
 }
 
 static void release_descriptor(struct client *client,
@@ -777,9 +786,9 @@ static void release_descriptor(struct cl
 	kfree(r);
 }
 
-static int ioctl_add_descriptor(struct client *client, void *buffer)
+static int ioctl_add_descriptor(struct client *client, union ioctl_arg *arg)
 {
-	struct fw_cdev_add_descriptor *request = buffer;
+	struct fw_cdev_add_descriptor *a = &arg->add_descriptor;
 	struct descriptor_resource *r;
 	int ret;
 
@@ -787,22 +796,21 @@ static int ioctl_add_descriptor(struct c
 	if (!client->device->is_local)
 		return -ENOSYS;
 
-	if (request->length > 256)
+	if (a->length > 256)
 		return -EINVAL;
 
-	r = kmalloc(sizeof(*r) + request->length * 4, GFP_KERNEL);
+	r = kmalloc(sizeof(*r) + a->length * 4, GFP_KERNEL);
 	if (r == NULL)
 		return -ENOMEM;
 
-	if (copy_from_user(r->data,
-			   u64_to_uptr(request->data), request->length * 4)) {
+	if (copy_from_user(r->data, u64_to_uptr(a->data), a->length * 4)) {
 		ret = -EFAULT;
 		goto failed;
 	}
 
-	r->descriptor.length    = request->length;
-	r->descriptor.immediate = request->immediate;
-	r->descriptor.key       = request->key;
+	r->descriptor.length    = a->length;
+	r->descriptor.immediate = a->immediate;
+	r->descriptor.key       = a->key;
 	r->descriptor.data      = r->data;
 
 	ret = fw_core_add_descriptor(&r->descriptor);
@@ -815,7 +823,7 @@ static int ioctl_add_descriptor(struct c
 		fw_core_remove_descriptor(&r->descriptor);
 		goto failed;
 	}
-	request->handle = r->resource.handle;
+	a->handle = r->resource.handle;
 
 	return 0;
  failed:
@@ -824,11 +832,9 @@ static int ioctl_add_descriptor(struct c
 	return ret;
 }
 
-static int ioctl_remove_descriptor(struct client *client, void *buffer)
+static int ioctl_remove_descriptor(struct client *client, union ioctl_arg *arg)
 {
-	struct fw_cdev_remove_descriptor *request = buffer;
-
-	return release_client_resource(client, request->handle,
+	return release_client_resource(client, arg->remove_descriptor.handle,
 				       release_descriptor, NULL);
 }
 
@@ -851,49 +857,44 @@ static void iso_callback(struct fw_iso_c
 		    sizeof(e->interrupt) + header_length, NULL, 0);
 }
 
-static int ioctl_create_iso_context(struct client *client, void *buffer)
+static int ioctl_create_iso_context(struct client *client, union ioctl_arg *arg)
 {
-	struct fw_cdev_create_iso_context *request = buffer;
+	struct fw_cdev_create_iso_context *a = &arg->create_iso_context;
 	struct fw_iso_context *context;
 
 	/* We only support one context at this time. */
 	if (client->iso_context != NULL)
 		return -EBUSY;
 
-	if (request->channel > 63)
+	if (a->channel > 63)
 		return -EINVAL;
 
-	switch (request->type) {
+	switch (a->type) {
 	case FW_ISO_CONTEXT_RECEIVE:
-		if (request->header_size < 4 || (request->header_size & 3))
+		if (a->header_size < 4 || (a->header_size & 3))
 			return -EINVAL;
-
 		break;
 
 	case FW_ISO_CONTEXT_TRANSMIT:
-		if (request->speed > SCODE_3200)
+		if (a->speed > SCODE_3200)
 			return -EINVAL;
-
 		break;
 
 	default:
 		return -EINVAL;
 	}
 
-	context =  fw_iso_context_create(client->device->card,
-					 request->type,
-					 request->channel,
-					 request->speed,
-					 request->header_size,
-					 iso_callback, client);
+	context = fw_iso_context_create(client->device->card, a->type,
+					a->channel, a->speed, a->header_size,
+					iso_callback, client);
 	if (IS_ERR(context))
 		return PTR_ERR(context);
 
-	client->iso_closure = request->closure;
+	client->iso_closure = a->closure;
 	client->iso_context = context;
 
 	/* We only support one context at this time. */
-	request->handle = 0;
+	a->handle = 0;
 
 	return 0;
 }
@@ -906,9 +907,9 @@ static int ioctl_create_iso_context(stru
 #define GET_SY(v)		(((v) >> 20) & 0x0f)
 #define GET_HEADER_LENGTH(v)	(((v) >> 24) & 0xff)
 
-static int ioctl_queue_iso(struct client *client, void *buffer)
+static int ioctl_queue_iso(struct client *client, union ioctl_arg *arg)
 {
-	struct fw_cdev_queue_iso *request = buffer;
+	struct fw_cdev_queue_iso *a = &arg->queue_iso;
 	struct fw_cdev_iso_packet __user *p, *end, *next;
 	struct fw_iso_context *ctx = client->iso_context;
 	unsigned long payload, buffer_end, header_length;
@@ -919,7 +920,7 @@ static int ioctl_queue_iso(struct client
 		u8 header[256];
 	} u;
 
-	if (ctx == NULL || request->handle != 0)
+	if (ctx == NULL || a->handle != 0)
 		return -EINVAL;
 
 	/*
@@ -929,23 +930,23 @@ static int ioctl_queue_iso(struct client
 	 * set them both to 0, which will still let packets with
 	 * payload_length == 0 through.  In other words, if no packets
 	 * use the indirect payload, the iso buffer need not be mapped
-	 * and the request->data pointer is ignored.
+	 * and the a->data pointer is ignored.
 	 */
 
-	payload = (unsigned long)request->data - client->vm_start;
+	payload = (unsigned long)a->data - client->vm_start;
 	buffer_end = client->buffer.page_count << PAGE_SHIFT;
-	if (request->data == 0 || client->buffer.pages == NULL ||
+	if (a->data == 0 || client->buffer.pages == NULL ||
 	    payload >= buffer_end) {
 		payload = 0;
 		buffer_end = 0;
 	}
 
-	p = (struct fw_cdev_iso_packet __user *)u64_to_uptr(request->packets);
+	p = (struct fw_cdev_iso_packet __user *)u64_to_uptr(a->packets);
 
-	if (!access_ok(VERIFY_READ, p, request->size))
+	if (!access_ok(VERIFY_READ, p, a->size))
 		return -EFAULT;
 
-	end = (void __user *)p + request->size;
+	end = (void __user *)p + a->size;
 	count = 0;
 	while (p < end) {
 		if (get_user(control, &p->control))
@@ -995,45 +996,41 @@ static int ioctl_queue_iso(struct client
 		count++;
 	}
 
-	request->size    -= uptr_to_u64(p) - request->packets;
-	request->packets  = uptr_to_u64(p);
-	request->data     = client->vm_start + payload;
+	a->size    -= uptr_to_u64(p) - a->packets;
+	a->packets  = uptr_to_u64(p);
+	a->data     = client->vm_start + payload;
 
 	return count;
 }
 
-static int ioctl_start_iso(struct client *client, void *buffer)
+static int ioctl_start_iso(struct client *client, union ioctl_arg *arg)
 {
-	struct fw_cdev_start_iso *request = buffer;
+	struct fw_cdev_start_iso *a = &arg->start_iso;
 
-	if (client->iso_context == NULL || request->handle != 0)
+	if (client->iso_context == NULL || a->handle != 0)
 		return -EINVAL;
 
-	if (client->iso_context->type == FW_ISO_CONTEXT_RECEIVE) {
-		if (request->tags == 0 || request->tags > 15)
-			return -EINVAL;
-
-		if (request->sync > 15)
-			return -EINVAL;
-	}
+	if (client->iso_context->type == FW_ISO_CONTEXT_RECEIVE &&
+	    (a->tags == 0 || a->tags > 15 || a->sync > 15))
+		return -EINVAL;
 
-	return fw_iso_context_start(client->iso_context, request->cycle,
-				    request->sync, request->tags);
+	return fw_iso_context_start(client->iso_context,
+				    a->cycle, a->sync, a->tags);
 }
 
-static int ioctl_stop_iso(struct client *client, void *buffer)
+static int ioctl_stop_iso(struct client *client, union ioctl_arg *arg)
 {
-	struct fw_cdev_stop_iso *request = buffer;
+	struct fw_cdev_stop_iso *a = &arg->stop_iso;
 
-	if (client->iso_context == NULL || request->handle != 0)
+	if (client->iso_context == NULL || a->handle != 0)
 		return -EINVAL;
 
 	return fw_iso_context_stop(client->iso_context);
 }
 
-static int ioctl_get_cycle_timer2(struct client *client, void *buffer)
+static int ioctl_get_cycle_timer2(struct client *client, union ioctl_arg *arg)
 {
-	struct fw_cdev_get_cycle_timer2 *request = buffer;
+	struct fw_cdev_get_cycle_timer2 *a = &arg->get_cycle_timer2;
 	struct fw_card *card = client->device->card;
 	struct timespec ts = {0, 0};
 	u32 cycle_time;
@@ -1043,7 +1040,7 @@ static int ioctl_get_cycle_timer2(struct
 
 	cycle_time = card->driver->get_cycle_time(card);
 
-	switch (request->clk_id) {
+	switch (a->clk_id) {
 	case CLOCK_REALTIME:      getnstimeofday(&ts);                   break;
 	case CLOCK_MONOTONIC:     do_posix_clock_monotonic_gettime(&ts); break;
 	case CLOCK_MONOTONIC_RAW: getrawmonotonic(&ts);                  break;
@@ -1053,24 +1050,23 @@ static int ioctl_get_cycle_timer2(struct
 
 	local_irq_enable();
 
-	request->tv_sec		= ts.tv_sec;
-	request->tv_nsec	= ts.tv_nsec;
-	request->cycle_timer	= cycle_time;
+	a->tv_sec      = ts.tv_sec;
+	a->tv_nsec     = ts.tv_nsec;
+	a->cycle_timer = cycle_time;
 
 	return ret;
 }
 
-static int ioctl_get_cycle_timer(struct client *client, void *buffer)
+static int ioctl_get_cycle_timer(struct client *client, union ioctl_arg *arg)
 {
-	struct fw_cdev_get_cycle_timer *request = buffer;
+	struct fw_cdev_get_cycle_timer *a = &arg->get_cycle_timer;
 	struct fw_cdev_get_cycle_timer2 ct2;
 
 	ct2.clk_id = CLOCK_REALTIME;
-	ioctl_get_cycle_timer2(client, &ct2);
+	ioctl_get_cycle_timer2(client, (union ioctl_arg *)&ct2);
 
-	request->local_time	= ct2.tv_sec * USEC_PER_SEC +
-				  ct2.tv_nsec / NSEC_PER_USEC;
-	request->cycle_timer	= ct2.cycle_timer;
+	a->local_time = ct2.tv_sec * USEC_PER_SEC + ct2.tv_nsec / NSEC_PER_USEC;
+	a->cycle_timer = ct2.cycle_timer;
 
 	return 0;
 }
@@ -1242,33 +1238,32 @@ static int init_iso_resource(struct clie
 	return ret;
 }
 
-static int ioctl_allocate_iso_resource(struct client *client, void *buffer)
+static int ioctl_allocate_iso_resource(struct client *client,
+				       union ioctl_arg *arg)
 {
-	struct fw_cdev_allocate_iso_resource *request = buffer;
-
-	return init_iso_resource(client, request, ISO_RES_ALLOC);
+	return init_iso_resource(client,
+			&arg->allocate_iso_resource, ISO_RES_ALLOC);
 }
 
-static int ioctl_deallocate_iso_resource(struct client *client, void *buffer)
+static int ioctl_deallocate_iso_resource(struct client *client,
+					 union ioctl_arg *arg)
 {
-	struct fw_cdev_deallocate *request = buffer;
-
-	return release_client_resource(client, request->handle,
-				       release_iso_resource, NULL);
+	return release_client_resource(client,
+			arg->deallocate.handle, release_iso_resource, NULL);
 }
 
-static int ioctl_allocate_iso_resource_once(struct client *client, void *buffer)
+static int ioctl_allocate_iso_resource_once(struct client *client,
+					    union ioctl_arg *arg)
 {
-	struct fw_cdev_allocate_iso_resource *request = buffer;
-
-	return init_iso_resource(client, request, ISO_RES_ALLOC_ONCE);
+	return init_iso_resource(client,
+			&arg->allocate_iso_resource, ISO_RES_ALLOC_ONCE);
 }
 
-static int ioctl_deallocate_iso_resource_once(struct client *client, void *buffer)
+static int ioctl_deallocate_iso_resource_once(struct client *client,
+					      union ioctl_arg *arg)
 {
-	struct fw_cdev_allocate_iso_resource *request = buffer;
-
-	return init_iso_resource(client, request, ISO_RES_DEALLOC_ONCE);
+	return init_iso_resource(client,
+			&arg->allocate_iso_resource, ISO_RES_DEALLOC_ONCE);
 }
 
 /*
@@ -1276,16 +1271,17 @@ static int ioctl_deallocate_iso_resource
  * limited by the device's link speed, the local node's link speed,
  * and all PHY port speeds between the two links.
  */
-static int ioctl_get_speed(struct client *client, void *buffer)
+static int ioctl_get_speed(struct client *client, union ioctl_arg *arg)
 {
 	return client->device->max_speed;
 }
 
-static int ioctl_send_broadcast_request(struct client *client, void *buffer)
+static int ioctl_send_broadcast_request(struct client *client,
+					union ioctl_arg *arg)
 {
-	struct fw_cdev_send_request *request = buffer;
+	struct fw_cdev_send_request *a = &arg->send_request;
 
-	switch (request->tcode) {
+	switch (a->tcode) {
 	case TCODE_WRITE_QUADLET_REQUEST:
 	case TCODE_WRITE_BLOCK_REQUEST:
 		break;
@@ -1294,36 +1290,36 @@ static int ioctl_send_broadcast_request(
 	}
 
 	/* Security policy: Only allow accesses to Units Space. */
-	if (request->offset < CSR_REGISTER_BASE + CSR_CONFIG_ROM_END)
+	if (a->offset < CSR_REGISTER_BASE + CSR_CONFIG_ROM_END)
 		return -EACCES;
 
-	return init_request(client, request, LOCAL_BUS | 0x3f, SCODE_100);
+	return init_request(client, a, LOCAL_BUS | 0x3f, SCODE_100);
 }
 
-static int ioctl_send_stream_packet(struct client *client, void *buffer)
+static int ioctl_send_stream_packet(struct client *client, union ioctl_arg *arg)
 {
-	struct fw_cdev_send_stream_packet *p = buffer;
+	struct fw_cdev_send_stream_packet *a = &arg->send_stream_packet;
 	struct fw_cdev_send_request request;
 	int dest;
 
-	if (p->speed > client->device->card->link_speed ||
-	    p->length > 1024 << p->speed)
+	if (a->speed > client->device->card->link_speed ||
+	    a->length > 1024 << a->speed)
 		return -EIO;
 
-	if (p->tag > 3 || p->channel > 63 || p->sy > 15)
+	if (a->tag > 3 || a->channel > 63 || a->sy > 15)
 		return -EINVAL;
 
-	dest = fw_stream_packet_destination_id(p->tag, p->channel, p->sy);
+	dest = fw_stream_packet_destination_id(a->tag, a->channel, a->sy);
 	request.tcode		= TCODE_STREAM_DATA;
-	request.length		= p->length;
-	request.closure		= p->closure;
-	request.data		= p->data;
-	request.generation	= p->generation;
+	request.length		= a->length;
+	request.closure		= a->closure;
+	request.data		= a->data;
+	request.generation	= a->generation;
 
-	return init_request(client, &request, dest, p->speed);
+	return init_request(client, &request, dest, a->speed);
 }
 
-static int (* const ioctl_handlers[])(struct client *client, void *buffer) = {
+static int (* const ioctl_handlers[])(struct client *, union ioctl_arg *) = {
 	ioctl_get_info,
 	ioctl_send_request,
 	ioctl_allocate,
@@ -1350,24 +1346,7 @@ static int (* const ioctl_handlers[])(st
 static int dispatch_ioctl(struct client *client,
 			  unsigned int cmd, void __user *arg)
 {
-	char buffer[sizeof(union {
-		struct fw_cdev_get_info			_00;
-		struct fw_cdev_send_request		_01;
-		struct fw_cdev_allocate			_02;
-		struct fw_cdev_deallocate		_03;
-		struct fw_cdev_send_response		_04;
-		struct fw_cdev_initiate_bus_reset	_05;
-		struct fw_cdev_add_descriptor		_06;
-		struct fw_cdev_remove_descriptor	_07;
-		struct fw_cdev_create_iso_context	_08;
-		struct fw_cdev_queue_iso		_09;
-		struct fw_cdev_start_iso		_0a;
-		struct fw_cdev_stop_iso			_0b;
-		struct fw_cdev_get_cycle_timer		_0c;
-		struct fw_cdev_allocate_iso_resource	_0d;
-		struct fw_cdev_send_stream_packet	_13;
-		struct fw_cdev_get_cycle_timer2		_14;
-	})];
+	union ioctl_arg buffer;
 	int ret;
 
 	if (_IOC_TYPE(cmd) != '#' ||
@@ -1376,17 +1355,17 @@ static int dispatch_ioctl(struct client 
 
 	if (_IOC_DIR(cmd) & _IOC_WRITE) {
 		if (_IOC_SIZE(cmd) > sizeof(buffer) ||
-		    copy_from_user(buffer, arg, _IOC_SIZE(cmd)))
+		    copy_from_user(&buffer, arg, _IOC_SIZE(cmd)))
 			return -EFAULT;
 	}
 
-	ret = ioctl_handlers[_IOC_NR(cmd)](client, buffer);
+	ret = ioctl_handlers[_IOC_NR(cmd)](client, &buffer);
 	if (ret < 0)
 		return ret;
 
 	if (_IOC_DIR(cmd) & _IOC_READ) {
 		if (_IOC_SIZE(cmd) > sizeof(buffer) ||
-		    copy_to_user(arg, buffer, _IOC_SIZE(cmd)))
+		    copy_to_user(arg, &buffer, _IOC_SIZE(cmd)))
 			return -EFAULT;
 	}
 

-- 
Stefan Richter
-=====-==-=- --=- =-=-=
http://arcgraph.de/sr/

