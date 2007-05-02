Return-Path: <linux-kernel-owner+w=401wt.eu-S2993080AbXEBMSm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2993080AbXEBMSm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2007 08:18:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755176AbXEBMSe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 May 2007 08:18:34 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:58898 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2993079AbXEBMSH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2007 08:18:07 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Wed, 2 May 2007 14:17:26 +0200 (CEST)
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: [PATCH 3/6] firewire: char device interface
To: linux-kernel@vger.kernel.org
cc: Kristian H??gsberg <krh@redhat.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       linux1394-devel <linux1394-devel@lists.sourceforge.net>,
       Christoph Hellwig <hch@infradead.org>
In-Reply-To: <tkrat.65aea95f1451c211@s5r6.in-berlin.de>
Message-ID: <tkrat.2aa3f3ac11a3d60d@s5r6.in-berlin.de>
References: <4637A29F.6070302@redhat.com>
 <20070502090007.GA28174@infradead.org>
 <tkrat.087ee29add656926@s5r6.in-berlin.de>
 <tkrat.350cb4dfe522266e@s5r6.in-berlin.de>
 <tkrat.65aea95f1451c211@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=us-ascii
Content-Disposition: INLINE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
---
 drivers/firewire/fw-cdev.c    |  954 ++++++++++++++++++++++++++++++++++
 include/linux/firewire-cdev.h |  268 +++++++++
 2 files changed, 1222 insertions(+)

Index: linux_juju/include/linux/firewire-cdev.h
===================================================================
--- /dev/null
+++ linux_juju/include/linux/firewire-cdev.h
@@ -0,0 +1,268 @@
+/*						-*- c-basic-offset: 8 -*-
+ *
+ * fw-device-cdev.h -- Char device interface.
+ *
+ * Copyright (C) 2005-2006  Kristian Hoegsberg <krh@bitplanet.net>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software Foundation,
+ * Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
+ */
+
+#ifndef __fw_cdev_h
+#define __fw_cdev_h
+
+#include <asm/ioctl.h>
+#include <asm/types.h>
+
+#define TCODE_WRITE_QUADLET_REQUEST	0
+#define TCODE_WRITE_BLOCK_REQUEST	1
+#define TCODE_WRITE_RESPONSE		2
+#define TCODE_READ_QUADLET_REQUEST	4
+#define TCODE_READ_BLOCK_REQUEST	5
+#define TCODE_READ_QUADLET_RESPONSE	6
+#define TCODE_READ_BLOCK_RESPONSE	7
+#define TCODE_CYCLE_START		8
+#define TCODE_LOCK_REQUEST		9
+#define TCODE_STREAM_DATA		10
+#define TCODE_LOCK_RESPONSE		11
+
+#define TCODE_LOCK_MASK_SWAP		0x11
+#define TCODE_LOCK_COMPARE_SWAP		0x12
+#define TCODE_LOCK_FETCH_ADD		0x13
+#define TCODE_LOCK_LITTLE_ADD		0x14
+#define TCODE_LOCK_BOUNDED_ADD		0x15
+#define TCODE_LOCK_WRAP_ADD		0x16
+#define TCODE_LOCK_VENDOR_DEPENDENT	0x17
+
+#define RCODE_COMPLETE			0x0
+#define RCODE_CONFLICT_ERROR		0x4
+#define RCODE_DATA_ERROR		0x5
+#define RCODE_TYPE_ERROR		0x6
+#define RCODE_ADDRESS_ERROR		0x7
+
+#define RCODE_SEND_ERROR		0x10
+#define RCODE_CANCELLED			0x11
+#define RCODE_BUSY			0x12
+#define RCODE_GENERATION		0x13
+#define RCODE_NO_ACK			0x14
+
+#define SCODE_100			0x0
+#define SCODE_200			0x1
+#define SCODE_400			0x2
+#define SCODE_800			0x3
+#define SCODE_1600			0x4
+#define SCODE_3200			0x5
+
+#define FW_CDEV_EVENT_BUS_RESET		0x00
+#define FW_CDEV_EVENT_RESPONSE		0x01
+#define FW_CDEV_EVENT_REQUEST		0x02
+#define FW_CDEV_EVENT_ISO_INTERRUPT	0x03
+
+/* The 'closure' fields are for user space to use.  Data passed in the
+ * 'closure' field for a request will be returned in the corresponding
+ * event.  It's a 64-bit type so that it's a fixed size type big
+ * enough to hold a pointer on all platforms. */
+
+struct fw_cdev_event_common {
+	__u64 closure;
+	__u32 type;
+};
+
+struct fw_cdev_event_bus_reset {
+	__u64 closure;
+	__u32 type;
+	__u32 node_id;
+	__u32 local_node_id;
+	__u32 bm_node_id;
+	__u32 irm_node_id;
+	__u32 root_node_id;
+	__u32 generation;
+};
+
+struct fw_cdev_event_response {
+	__u64 closure;
+	__u32 type;
+	__u32 rcode;
+	__u32 length;
+	__u32 data[0];
+};
+
+struct fw_cdev_event_request {
+	__u64 closure;
+	__u32 type;
+	__u32 tcode;
+	__u64 offset;
+	__u32 handle;
+	__u32 length;
+	__u32 data[0];
+};
+
+struct fw_cdev_event_iso_interrupt {
+	__u64 closure;
+	__u32 type;
+	__u32 cycle;
+	__u32 header_length;	/* Length in bytes of following headers. */
+	__u32 header[0];
+};
+
+union fw_cdev_event {
+	struct fw_cdev_event_common common;
+	struct fw_cdev_event_bus_reset bus_reset;
+	struct fw_cdev_event_response response;
+	struct fw_cdev_event_request request;
+	struct fw_cdev_event_iso_interrupt iso_interrupt;
+};
+
+#define FW_CDEV_IOC_GET_INFO		_IOWR('#', 0x00, struct fw_cdev_get_info)
+#define FW_CDEV_IOC_SEND_REQUEST	_IOW('#', 0x01, struct fw_cdev_send_request)
+#define FW_CDEV_IOC_ALLOCATE		_IOWR('#', 0x02, struct fw_cdev_allocate)
+#define FW_CDEV_IOC_DEALLOCATE		_IOW('#', 0x03, struct fw_cdev_deallocate)
+#define FW_CDEV_IOC_SEND_RESPONSE	_IOW('#', 0x04, struct fw_cdev_send_response)
+#define FW_CDEV_IOC_INITIATE_BUS_RESET	_IOW('#', 0x05, struct fw_cdev_initiate_bus_reset)
+#define FW_CDEV_IOC_ADD_DESCRIPTOR	_IOWR('#', 0x06, struct fw_cdev_add_descriptor)
+#define FW_CDEV_IOC_REMOVE_DESCRIPTOR	_IOW('#', 0x07, struct fw_cdev_remove_descriptor)
+
+#define FW_CDEV_IOC_CREATE_ISO_CONTEXT	_IOWR('#', 0x08, struct fw_cdev_create_iso_context)
+#define FW_CDEV_IOC_QUEUE_ISO		_IOWR('#', 0x09, struct fw_cdev_queue_iso)
+#define FW_CDEV_IOC_START_ISO		_IOW('#', 0x0a, struct fw_cdev_start_iso)
+#define FW_CDEV_IOC_STOP_ISO		_IOW('#', 0x0b, struct fw_cdev_stop_iso)
+
+/* FW_CDEV_VERSION History
+ *
+ * 1	Feb 18, 2007:  Initial version.
+ */
+#define FW_CDEV_VERSION		1
+
+struct fw_cdev_get_info {
+	/* The version field is just a running serial number.  We
+	 * never break backwards compatibility.  Userspace passes in
+	 * the version it expects and the kernel passes back the
+	 * highest version it can provide.  Even if the structs in
+	 * this interface are extended in a later version, the kernel
+	 * will not copy back more data than what was present in the
+	 * interface version userspace expects. */
+	__u32 version;
+
+	/* If non-zero, at most rom_length bytes of config rom will be
+	 * copied into that user space address.  In either case,
+	 * rom_length is updated with the actual length of the config
+	 * rom. */
+	__u32 rom_length;
+	__u64 rom;
+
+	/* If non-zero, a fw_cdev_event_bus_reset struct will be
+	 * copied here with the current state of the bus.  This does
+	 * not cause a bus reset to happen.  The value of closure in
+	 * this and sub-sequent bus reset events is set to
+	 * bus_reset_closure. */
+	__u64 bus_reset;
+	__u64 bus_reset_closure;
+
+	/* The index of the card this devices belongs to. */
+	__u32 card;
+};
+
+struct fw_cdev_send_request {
+	__u32 tcode;
+	__u32 length;
+	__u64 offset;
+	__u64 closure;
+	__u64 data;
+	__u32 generation;
+};
+
+struct fw_cdev_send_response {
+	__u32 rcode;
+	__u32 length;
+	__u64 data;
+	__u32 handle;
+};
+
+struct fw_cdev_allocate {
+	__u64 offset;
+	__u64 closure;
+	__u32 length;
+	__u32 handle;
+};
+
+struct fw_cdev_deallocate {
+	__u32 handle;
+};
+
+#define FW_CDEV_LONG_RESET	0
+#define FW_CDEV_SHORT_RESET	1
+
+struct fw_cdev_initiate_bus_reset {
+	__u32 type;
+};
+
+struct fw_cdev_add_descriptor {
+	__u32 immediate;
+	__u32 key;
+	__u64 data;
+	__u32 length;
+	__u32 handle;
+};
+
+struct fw_cdev_remove_descriptor {
+	__u32 handle;
+};
+
+#define FW_CDEV_ISO_CONTEXT_TRANSMIT	0
+#define FW_CDEV_ISO_CONTEXT_RECEIVE	1
+
+#define FW_CDEV_ISO_CONTEXT_MATCH_TAG0		 1
+#define FW_CDEV_ISO_CONTEXT_MATCH_TAG1		 2
+#define FW_CDEV_ISO_CONTEXT_MATCH_TAG2		 4
+#define FW_CDEV_ISO_CONTEXT_MATCH_TAG3		 8
+#define FW_CDEV_ISO_CONTEXT_MATCH_ALL_TAGS	15
+
+struct fw_cdev_create_iso_context {
+	__u32 type;
+	__u32 header_size;
+	__u32 channel;
+	__u32 speed;
+	__u64 closure;
+	__u32 handle;
+};
+
+struct fw_cdev_iso_packet {
+	__u16 payload_length;	/* Length of indirect payload. */
+	__u32 interrupt : 1;	/* Generate interrupt on this packet */
+	__u32 skip : 1;		/* Set to not send packet at all. */
+	__u32 tag : 2;
+	__u32 sy : 4;
+	__u32 header_length : 8;	/* Length of immediate header. */
+	__u32 header[0];
+};
+
+struct fw_cdev_queue_iso {
+	__u64 packets;
+	__u64 data;
+	__u32 size;
+	__u32 handle;
+};
+
+struct fw_cdev_start_iso {
+	__s32 cycle;
+	__u32 sync;
+	__u32 tags;
+	__u32 handle;
+};
+
+struct fw_cdev_stop_iso {
+	__u32 handle;
+};
+
+#endif /* __fw_cdev_h */
Index: linux_juju/drivers/firewire/fw-cdev.c
===================================================================
--- /dev/null
+++ linux_juju/drivers/firewire/fw-cdev.c
@@ -0,0 +1,954 @@
+/*						-*- c-basic-offset: 8 -*-
+ *
+ * fw-device-cdev.c - Char device for device raw access
+ *
+ * Copyright (C) 2005-2006  Kristian Hoegsberg <krh@bitplanet.net>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software Foundation,
+ * Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
+ */
+
+#include <linux/module.h>
+#include <linux/kernel.h>
+#include <linux/wait.h>
+#include <linux/errno.h>
+#include <linux/device.h>
+#include <linux/vmalloc.h>
+#include <linux/poll.h>
+#include <linux/delay.h>
+#include <linux/mm.h>
+#include <linux/idr.h>
+#include <linux/compat.h>
+#include <linux/firewire-cdev.h>
+#include <asm/uaccess.h>
+#include "fw-transaction.h"
+#include "fw-topology.h"
+#include "fw-device.h"
+
+/* dequeue_event() just kfree()'s the event, so the event has to be
+ * the first field in the struct. */
+
+struct client;
+struct client_resource {
+	struct list_head link;
+	void (*release)(struct client *client, struct client_resource *r);
+	u32 handle;
+};
+
+struct event {
+	struct { void *data; size_t size; } v[2];
+	struct list_head link;
+};
+
+struct bus_reset {
+	struct event event;
+	struct fw_cdev_event_bus_reset reset;
+};
+
+struct response {
+	struct event event;
+	struct fw_transaction transaction;
+	struct client *client;
+	struct client_resource resource;
+	struct fw_cdev_event_response response;
+};
+
+struct iso_interrupt {
+	struct event event;
+	struct fw_cdev_event_iso_interrupt interrupt;
+};
+
+struct client {
+	u32 version;
+	struct fw_device *device;
+	spinlock_t lock;
+	u32 resource_handle;
+	struct list_head resource_list;
+	struct list_head event_list;
+	wait_queue_head_t wait;
+	u64 bus_reset_closure;
+
+	struct fw_iso_context *iso_context;
+	u64 iso_closure;
+	struct fw_iso_buffer buffer;
+	unsigned long vm_start;
+
+	struct list_head link;
+};
+
+static inline void __user *
+u64_to_uptr(__u64 value)
+{
+	return (void __user *)(unsigned long)value;
+}
+
+static inline __u64
+uptr_to_u64(void __user *ptr)
+{
+	return (__u64)(unsigned long)ptr;
+}
+
+static int fw_device_op_open(struct inode *inode, struct file *file)
+{
+	struct fw_device *device;
+	struct client *client;
+	unsigned long flags;
+
+	device = fw_device_from_devt(inode->i_rdev);
+	if (device == NULL)
+		return -ENODEV;
+
+	client = kzalloc(sizeof *client, GFP_KERNEL);
+	if (client == NULL)
+		return -ENOMEM;
+
+	client->device = fw_device_get(device);
+	INIT_LIST_HEAD(&client->event_list);
+	INIT_LIST_HEAD(&client->resource_list);
+	spin_lock_init(&client->lock);
+	init_waitqueue_head(&client->wait);
+
+	file->private_data = client;
+
+	spin_lock_irqsave(&device->card->lock, flags);
+	list_add_tail(&client->link, &device->client_list);
+	spin_unlock_irqrestore(&device->card->lock, flags);
+
+	return 0;
+}
+
+static void queue_event(struct client *client, struct event *event,
+			void *data0, size_t size0, void *data1, size_t size1)
+{
+	unsigned long flags;
+
+	event->v[0].data = data0;
+	event->v[0].size = size0;
+	event->v[1].data = data1;
+	event->v[1].size = size1;
+
+	spin_lock_irqsave(&client->lock, flags);
+
+	list_add_tail(&event->link, &client->event_list);
+	wake_up_interruptible(&client->wait);
+
+	spin_unlock_irqrestore(&client->lock, flags);
+}
+
+static int
+dequeue_event(struct client *client, char __user *buffer, size_t count)
+{
+	unsigned long flags;
+	struct event *event;
+	size_t size, total;
+	int i, retval;
+
+	retval = wait_event_interruptible(client->wait,
+					  !list_empty(&client->event_list) ||
+					  fw_device_is_shutdown(client->device));
+	if (retval < 0)
+		return retval;
+
+	if (list_empty(&client->event_list) &&
+		       fw_device_is_shutdown(client->device))
+		return -ENODEV;
+
+	spin_lock_irqsave(&client->lock, flags);
+	event = container_of(client->event_list.next, struct event, link);
+	list_del(&event->link);
+	spin_unlock_irqrestore(&client->lock, flags);
+
+	total = 0;
+	for (i = 0; i < ARRAY_SIZE(event->v) && total < count; i++) {
+		size = min(event->v[i].size, count - total);
+		if (copy_to_user(buffer + total, event->v[i].data, size)) {
+			retval = -EFAULT;
+			goto out;
+		}
+		total += size;
+	}
+	retval = total;
+
+ out:
+	kfree(event);
+
+	return retval;
+}
+
+static ssize_t
+fw_device_op_read(struct file *file,
+		  char __user *buffer, size_t count, loff_t *offset)
+{
+	struct client *client = file->private_data;
+
+	return dequeue_event(client, buffer, count);
+}
+
+static void
+fill_bus_reset_event(struct fw_cdev_event_bus_reset *event,
+		     struct client *client)
+{
+	struct fw_card *card = client->device->card;
+
+	event->closure	     = client->bus_reset_closure;
+	event->type          = FW_CDEV_EVENT_BUS_RESET;
+	event->node_id       = client->device->node_id;
+	event->local_node_id = card->local_node->node_id;
+	event->bm_node_id    = 0; /* FIXME: We don't track the BM. */
+	event->irm_node_id   = card->irm_node->node_id;
+	event->root_node_id  = card->root_node->node_id;
+	event->generation    = card->generation;
+}
+
+static void
+for_each_client(struct fw_device *device,
+		void (*callback)(struct client *client))
+{
+	struct fw_card *card = device->card;
+	struct client *c;
+	unsigned long flags;
+
+	spin_lock_irqsave(&card->lock, flags);
+
+	list_for_each_entry(c, &device->client_list, link)
+		callback(c);
+
+	spin_unlock_irqrestore(&card->lock, flags);
+}
+
+static void
+queue_bus_reset_event(struct client *client)
+{
+	struct bus_reset *bus_reset;
+
+	bus_reset = kzalloc(sizeof *bus_reset, GFP_ATOMIC);
+	if (bus_reset == NULL) {
+		fw_notify("Out of memory when allocating bus reset event\n");
+		return;
+	}
+
+	fill_bus_reset_event(&bus_reset->reset, client);
+
+	queue_event(client, &bus_reset->event,
+		    &bus_reset->reset, sizeof bus_reset->reset, NULL, 0);
+}
+
+void fw_device_cdev_update(struct fw_device *device)
+{
+	for_each_client(device, queue_bus_reset_event);
+}
+
+static void wake_up_client(struct client *client)
+{
+	wake_up_interruptible(&client->wait);
+}
+
+void fw_device_cdev_remove(struct fw_device *device)
+{
+	for_each_client(device, wake_up_client);
+}
+
+static int ioctl_get_info(struct client *client, void *buffer)
+{
+	struct fw_cdev_get_info *get_info = buffer;
+	struct fw_cdev_event_bus_reset bus_reset;
+
+	client->version = get_info->version;
+	get_info->version = FW_CDEV_VERSION;
+
+	if (get_info->rom != 0) {
+		void __user *uptr = u64_to_uptr(get_info->rom);
+		size_t want = get_info->rom_length;
+		size_t have = client->device->config_rom_length * 4;
+
+		if (copy_to_user(uptr, client->device->config_rom,
+				 min(want, have)))
+			return -EFAULT;
+	}
+	get_info->rom_length = client->device->config_rom_length * 4;
+
+	client->bus_reset_closure = get_info->bus_reset_closure;
+	if (get_info->bus_reset != 0) {
+		void __user *uptr = u64_to_uptr(get_info->bus_reset);
+
+		fill_bus_reset_event(&bus_reset, client);
+		if (copy_to_user(uptr, &bus_reset, sizeof bus_reset))
+			return -EFAULT;
+	}
+
+	get_info->card = client->device->card->index;
+
+	return 0;
+}
+
+static void
+add_client_resource(struct client *client, struct client_resource *resource)
+{
+	unsigned long flags;
+
+	spin_lock_irqsave(&client->lock, flags);
+	list_add_tail(&resource->link, &client->resource_list);
+	resource->handle = client->resource_handle++;
+	spin_unlock_irqrestore(&client->lock, flags);
+}
+
+static int
+release_client_resource(struct client *client, u32 handle,
+			struct client_resource **resource)
+{
+	struct client_resource *r;
+	unsigned long flags;
+
+	spin_lock_irqsave(&client->lock, flags);
+	list_for_each_entry(r, &client->resource_list, link) {
+		if (r->handle == handle) {
+			list_del(&r->link);
+			break;
+		}
+	}
+	spin_unlock_irqrestore(&client->lock, flags);
+
+	if (&r->link == &client->resource_list)
+		return -EINVAL;
+
+	if (resource)
+		*resource = r;
+	else
+		r->release(client, r);
+
+	return 0;
+}
+
+static void
+release_transaction(struct client *client, struct client_resource *resource)
+{
+	struct response *response =
+		container_of(resource, struct response, resource);
+
+	fw_cancel_transaction(client->device->card, &response->transaction);
+}
+
+static void
+complete_transaction(struct fw_card *card, int rcode,
+		     void *payload, size_t length, void *data)
+{
+	struct response *response = data;
+	struct client *client = response->client;
+	unsigned long flags;
+
+	if (length < response->response.length)
+		response->response.length = length;
+	if (rcode == RCODE_COMPLETE)
+		memcpy(response->response.data, payload,
+		       response->response.length);
+
+	spin_lock_irqsave(&client->lock, flags);
+	list_del(&response->resource.link);
+	spin_unlock_irqrestore(&client->lock, flags);
+
+	response->response.type   = FW_CDEV_EVENT_RESPONSE;
+	response->response.rcode  = rcode;
+	queue_event(client, &response->event,
+		    &response->response, sizeof response->response,
+		    response->response.data, response->response.length);
+}
+
+static ssize_t ioctl_send_request(struct client *client, void *buffer)
+{
+	struct fw_device *device = client->device;
+	struct fw_cdev_send_request *request = buffer;
+	struct response *response;
+
+	/* What is the biggest size we'll accept, really? */
+	if (request->length > 4096)
+		return -EINVAL;
+
+	response = kmalloc(sizeof *response + request->length, GFP_KERNEL);
+	if (response == NULL)
+		return -ENOMEM;
+
+	response->client = client;
+	response->response.length = request->length;
+	response->response.closure = request->closure;
+
+	if (request->data &&
+	    copy_from_user(response->response.data,
+			   u64_to_uptr(request->data), request->length)) {
+		kfree(response);
+		return -EFAULT;
+	}
+
+	response->resource.release = release_transaction;
+	add_client_resource(client, &response->resource);
+
+	fw_send_request(device->card, &response->transaction,
+			request->tcode & 0x1f,
+			device->node->node_id,
+			request->generation,
+			device->node->max_speed,
+			request->offset,
+			response->response.data, request->length,
+			complete_transaction, response);
+
+	if (request->data)
+		return sizeof request + request->length;
+	else
+		return sizeof request;
+}
+
+struct address_handler {
+	struct fw_address_handler handler;
+	__u64 closure;
+	struct client *client;
+	struct client_resource resource;
+};
+
+struct request {
+	struct fw_request *request;
+	void *data;
+	size_t length;
+	struct client_resource resource;
+};
+
+struct request_event {
+	struct event event;
+	struct fw_cdev_event_request request;
+};
+
+static void
+release_request(struct client *client, struct client_resource *resource)
+{
+	struct request *request =
+		container_of(resource, struct request, resource);
+
+	fw_send_response(client->device->card, request->request,
+			 RCODE_CONFLICT_ERROR);
+	kfree(request);
+}
+
+static void
+handle_request(struct fw_card *card, struct fw_request *r,
+	       int tcode, int destination, int source,
+	       int generation, int speed,
+	       unsigned long long offset,
+	       void *payload, size_t length, void *callback_data)
+{
+	struct address_handler *handler = callback_data;
+	struct request *request;
+	struct request_event *e;
+	struct client *client = handler->client;
+
+	request = kmalloc(sizeof *request, GFP_ATOMIC);
+	e = kmalloc(sizeof *e, GFP_ATOMIC);
+	if (request == NULL || e == NULL) {
+		kfree(request);
+		kfree(e);
+		fw_send_response(card, r, RCODE_CONFLICT_ERROR);
+		return;
+	}
+
+	request->request = r;
+	request->data    = payload;
+	request->length  = length;
+
+	request->resource.release = release_request;
+	add_client_resource(client, &request->resource);
+
+	e->request.type    = FW_CDEV_EVENT_REQUEST;
+	e->request.tcode   = tcode;
+	e->request.offset  = offset;
+	e->request.length  = length;
+	e->request.handle  = request->resource.handle;
+	e->request.closure = handler->closure;
+
+	queue_event(client, &e->event,
+		    &e->request, sizeof e->request, payload, length);
+}
+
+static void
+release_address_handler(struct client *client,
+			struct client_resource *resource)
+{
+	struct address_handler *handler =
+		container_of(resource, struct address_handler, resource);
+
+	fw_core_remove_address_handler(&handler->handler);
+	kfree(handler);
+}
+
+static int ioctl_allocate(struct client *client, void *buffer)
+{
+	struct fw_cdev_allocate *request = buffer;
+	struct address_handler *handler;
+	struct fw_address_region region;
+
+	handler = kmalloc(sizeof *handler, GFP_KERNEL);
+	if (handler == NULL)
+		return -ENOMEM;
+
+	region.start = request->offset;
+	region.end = request->offset + request->length;
+	handler->handler.length = request->length;
+	handler->handler.address_callback = handle_request;
+	handler->handler.callback_data = handler;
+	handler->closure = request->closure;
+	handler->client = client;
+
+	if (fw_core_add_address_handler(&handler->handler, &region) < 0) {
+		kfree(handler);
+		return -EBUSY;
+	}
+
+	handler->resource.release = release_address_handler;
+	add_client_resource(client, &handler->resource);
+	request->handle = handler->resource.handle;
+
+	return 0;
+}
+
+static int ioctl_deallocate(struct client *client, void *buffer)
+{
+	struct fw_cdev_deallocate *request = buffer;
+
+	return release_client_resource(client, request->handle, NULL);
+}
+
+static int ioctl_send_response(struct client *client, void *buffer)
+{
+	struct fw_cdev_send_response *request = buffer;
+	struct client_resource *resource;
+	struct request *r;
+
+	if (release_client_resource(client, request->handle, &resource) < 0)
+		return -EINVAL;
+	r = container_of(resource, struct request, resource);
+	if (request->length < r->length)
+		r->length = request->length;
+	if (copy_from_user(r->data, u64_to_uptr(request->data), r->length))
+		return -EFAULT;
+
+	fw_send_response(client->device->card, r->request, request->rcode);
+	kfree(r);
+
+	return 0;
+}
+
+static int ioctl_initiate_bus_reset(struct client *client, void *buffer)
+{
+	struct fw_cdev_initiate_bus_reset *request = buffer;
+	int short_reset;
+
+	short_reset = (request->type == FW_CDEV_SHORT_RESET);
+
+	return fw_core_initiate_bus_reset(client->device->card, short_reset);
+}
+
+struct descriptor {
+	struct fw_descriptor d;
+	struct client_resource resource;
+	u32 data[0];
+};
+
+static void release_descriptor(struct client *client,
+			       struct client_resource *resource)
+{
+	struct descriptor *descriptor =
+		container_of(resource, struct descriptor, resource);
+
+	fw_core_remove_descriptor(&descriptor->d);
+	kfree(descriptor);
+}
+
+static int ioctl_add_descriptor(struct client *client, void *buffer)
+{
+	struct fw_cdev_add_descriptor *request = buffer;
+	struct descriptor *descriptor;
+	int retval;
+
+	if (request->length > 256)
+		return -EINVAL;
+
+	descriptor =
+		kmalloc(sizeof *descriptor + request->length * 4, GFP_KERNEL);
+	if (descriptor == NULL)
+		return -ENOMEM;
+
+	if (copy_from_user(descriptor->data,
+			   u64_to_uptr(request->data), request->length * 4)) {
+		kfree(descriptor);
+		return -EFAULT;
+	}
+
+	descriptor->d.length = request->length;
+	descriptor->d.immediate = request->immediate;
+	descriptor->d.key = request->key;
+	descriptor->d.data = descriptor->data;
+
+	retval = fw_core_add_descriptor(&descriptor->d);
+	if (retval < 0) {
+		kfree(descriptor);
+		return retval;
+	}
+
+	descriptor->resource.release = release_descriptor;
+	add_client_resource(client, &descriptor->resource);
+	request->handle = descriptor->resource.handle;
+
+	return 0;
+}
+
+static int ioctl_remove_descriptor(struct client *client, void *buffer)
+{
+	struct fw_cdev_remove_descriptor *request = buffer;
+
+	return release_client_resource(client, request->handle, NULL);
+}
+
+static void
+iso_callback(struct fw_iso_context *context, u32 cycle,
+	     size_t header_length, void *header, void *data)
+{
+	struct client *client = data;
+	struct iso_interrupt *interrupt;
+
+	interrupt = kzalloc(sizeof *interrupt + header_length, GFP_ATOMIC);
+	if (interrupt == NULL)
+		return;
+
+	interrupt->interrupt.type      = FW_CDEV_EVENT_ISO_INTERRUPT;
+	interrupt->interrupt.closure   = client->iso_closure;
+	interrupt->interrupt.cycle     = cycle;
+	interrupt->interrupt.header_length = header_length;
+	memcpy(interrupt->interrupt.header, header, header_length);
+	queue_event(client, &interrupt->event,
+		    &interrupt->interrupt,
+		    sizeof interrupt->interrupt + header_length, NULL, 0);
+}
+
+static int ioctl_create_iso_context(struct client *client, void *buffer)
+{
+	struct fw_cdev_create_iso_context *request = buffer;
+
+	if (request->channel > 63)
+		return -EINVAL;
+
+	switch (request->type) {
+	case FW_ISO_CONTEXT_RECEIVE:
+		if (request->header_size < 4 || (request->header_size & 3))
+			return -EINVAL;
+
+		break;
+
+	case FW_ISO_CONTEXT_TRANSMIT:
+		if (request->speed > SCODE_3200)
+			return -EINVAL;
+
+		break;
+
+	default:
+		return -EINVAL;
+	}
+
+	client->iso_closure = request->closure;
+	client->iso_context = fw_iso_context_create(client->device->card,
+						    request->type,
+						    request->channel,
+						    request->speed,
+						    request->header_size,
+						    iso_callback, client);
+	if (IS_ERR(client->iso_context))
+		return PTR_ERR(client->iso_context);
+
+	/* We only support one context at this time. */
+	request->handle = 0;
+
+	return 0;
+}
+
+static int ioctl_queue_iso(struct client *client, void *buffer)
+{
+	struct fw_cdev_queue_iso *request = buffer;
+	struct fw_cdev_iso_packet __user *p, *end, *next;
+	struct fw_iso_context *ctx = client->iso_context;
+	unsigned long payload, buffer_end, header_length;
+	int count;
+	struct {
+		struct fw_iso_packet packet;
+		u8 header[256];
+	} u;
+
+	if (ctx == NULL || request->handle != 0)
+		return -EINVAL;
+
+	/* If the user passes a non-NULL data pointer, has mmap()'ed
+	 * the iso buffer, and the pointer points inside the buffer,
+	 * we setup the payload pointers accordingly.  Otherwise we
+	 * set them both to 0, which will still let packets with
+	 * payload_length == 0 through.  In other words, if no packets
+	 * use the indirect payload, the iso buffer need not be mapped
+	 * and the request->data pointer is ignored.*/
+
+	payload = (unsigned long)request->data - client->vm_start;
+	buffer_end = client->buffer.page_count << PAGE_SHIFT;
+	if (request->data == 0 || client->buffer.pages == NULL ||
+	    payload >= buffer_end) {
+		payload = 0;
+		buffer_end = 0;
+	}
+
+	if (!access_ok(VERIFY_READ, request->packets, request->size))
+		return -EFAULT;
+
+	p = (struct fw_cdev_iso_packet __user *)u64_to_uptr(request->packets);
+	end = (void __user *)p + request->size;
+	count = 0;
+	while (p < end) {
+		if (__copy_from_user(&u.packet, p, sizeof *p))
+			return -EFAULT;
+
+		if (ctx->type == FW_ISO_CONTEXT_TRANSMIT) {
+			header_length = u.packet.header_length;
+		} else {
+			/* We require that header_length is a multiple of
+			 * the fixed header size, ctx->header_size */
+			if (ctx->header_size == 0) {
+				if (u.packet.header_length > 0)
+					return -EINVAL;
+			} else if (u.packet.header_length % ctx->header_size != 0) {
+				return -EINVAL;
+			}
+			header_length = 0;
+		}
+
+		next = (struct fw_cdev_iso_packet __user *)
+			&p->header[header_length / 4];
+		if (next > end)
+			return -EINVAL;
+		if (__copy_from_user
+		    (u.packet.header, p->header, header_length))
+			return -EFAULT;
+		if (u.packet.skip && ctx->type == FW_ISO_CONTEXT_TRANSMIT &&
+		    u.packet.header_length + u.packet.payload_length > 0)
+			return -EINVAL;
+		if (payload + u.packet.payload_length > buffer_end)
+			return -EINVAL;
+
+		if (fw_iso_context_queue(ctx, &u.packet,
+					 &client->buffer, payload))
+			break;
+
+		p = next;
+		payload += u.packet.payload_length;
+		count++;
+	}
+
+	request->size    -= uptr_to_u64(p) - request->packets;
+	request->packets  = uptr_to_u64(p);
+	request->data     = client->vm_start + payload;
+
+	return count;
+}
+
+static int ioctl_start_iso(struct client *client, void *buffer)
+{
+	struct fw_cdev_start_iso *request = buffer;
+
+	if (request->handle != 0)
+		return -EINVAL;
+	if (client->iso_context->type == FW_ISO_CONTEXT_RECEIVE) {
+		if (request->tags == 0 || request->tags > 15)
+			return -EINVAL;
+
+		if (request->sync > 15)
+			return -EINVAL;
+	}
+
+	return fw_iso_context_start(client->iso_context, request->cycle,
+				    request->sync, request->tags);
+}
+
+static int ioctl_stop_iso(struct client *client, void *buffer)
+{
+	struct fw_cdev_stop_iso *request = buffer;
+
+	if (request->handle != 0)
+		return -EINVAL;
+
+	return fw_iso_context_stop(client->iso_context);
+}
+
+static int (* const ioctl_handlers[])(struct client *client, void *buffer) = {
+	ioctl_get_info,
+	ioctl_send_request,
+	ioctl_allocate,
+	ioctl_deallocate,
+	ioctl_send_response,
+	ioctl_initiate_bus_reset,
+	ioctl_add_descriptor,
+	ioctl_remove_descriptor,
+	ioctl_create_iso_context,
+	ioctl_queue_iso,
+	ioctl_start_iso,
+	ioctl_stop_iso,
+};
+
+static int
+dispatch_ioctl(struct client *client, unsigned int cmd, void __user *arg)
+{
+	char buffer[256];
+	int retval;
+
+	if (_IOC_TYPE(cmd) != '#' ||
+	    _IOC_NR(cmd) >= ARRAY_SIZE(ioctl_handlers))
+		return -EINVAL;
+
+	if (_IOC_DIR(cmd) & _IOC_WRITE) {
+		if (_IOC_SIZE(cmd) > sizeof buffer ||
+		    copy_from_user(buffer, arg, _IOC_SIZE(cmd)))
+			return -EFAULT;
+	}
+
+	retval = ioctl_handlers[_IOC_NR(cmd)](client, buffer);
+	if (retval < 0)
+		return retval;
+
+	if (_IOC_DIR(cmd) & _IOC_READ) {
+		if (_IOC_SIZE(cmd) > sizeof buffer ||
+		    copy_to_user(arg, buffer, _IOC_SIZE(cmd)))
+			return -EFAULT;
+	}
+
+	return 0;
+}
+
+static long
+fw_device_op_ioctl(struct file *file,
+		   unsigned int cmd, unsigned long arg)
+{
+	struct client *client = file->private_data;
+
+	return dispatch_ioctl(client, cmd, (void __user *) arg);
+}
+
+#ifdef CONFIG_COMPAT
+static long
+fw_device_op_compat_ioctl(struct file *file,
+			  unsigned int cmd, unsigned long arg)
+{
+	struct client *client = file->private_data;
+
+	return dispatch_ioctl(client, cmd, compat_ptr(arg));
+}
+#endif
+
+static int fw_device_op_mmap(struct file *file, struct vm_area_struct *vma)
+{
+	struct client *client = file->private_data;
+	enum dma_data_direction direction;
+	unsigned long size;
+	int page_count, retval;
+
+	/* FIXME: We could support multiple buffers, but we don't. */
+	if (client->buffer.pages != NULL)
+		return -EBUSY;
+
+	if (!(vma->vm_flags & VM_SHARED))
+		return -EINVAL;
+
+	if (vma->vm_start & ~PAGE_MASK)
+		return -EINVAL;
+
+	client->vm_start = vma->vm_start;
+	size = vma->vm_end - vma->vm_start;
+	page_count = size >> PAGE_SHIFT;
+	if (size & ~PAGE_MASK)
+		return -EINVAL;
+
+	if (vma->vm_flags & VM_WRITE)
+		direction = DMA_TO_DEVICE;
+	else
+		direction = DMA_FROM_DEVICE;
+
+	retval = fw_iso_buffer_init(&client->buffer, client->device->card,
+				    page_count, direction);
+	if (retval < 0)
+		return retval;
+
+	retval = fw_iso_buffer_map(&client->buffer, vma);
+	if (retval < 0)
+		fw_iso_buffer_destroy(&client->buffer, client->device->card);
+
+	return retval;
+}
+
+static int fw_device_op_release(struct inode *inode, struct file *file)
+{
+	struct client *client = file->private_data;
+	struct event *e, *next_e;
+	struct client_resource *r, *next_r;
+	unsigned long flags;
+
+	if (client->buffer.pages)
+		fw_iso_buffer_destroy(&client->buffer, client->device->card);
+
+	if (client->iso_context)
+		fw_iso_context_destroy(client->iso_context);
+
+	list_for_each_entry_safe(r, next_r, &client->resource_list, link)
+		r->release(client, r);
+
+	/* FIXME: We should wait for the async tasklets to stop
+	 * running before freeing the memory. */
+
+	list_for_each_entry_safe(e, next_e, &client->event_list, link)
+		kfree(e);
+
+	spin_lock_irqsave(&client->device->card->lock, flags);
+	list_del(&client->link);
+	spin_unlock_irqrestore(&client->device->card->lock, flags);
+
+	fw_device_put(client->device);
+	kfree(client);
+
+	return 0;
+}
+
+static unsigned int fw_device_op_poll(struct file *file, poll_table * pt)
+{
+	struct client *client = file->private_data;
+	unsigned int mask = 0;
+
+	poll_wait(file, &client->wait, pt);
+
+	if (fw_device_is_shutdown(client->device))
+		mask |= POLLHUP | POLLERR;
+	if (!list_empty(&client->event_list))
+		mask |= POLLIN | POLLRDNORM;
+
+	return mask;
+}
+
+const struct file_operations fw_device_ops = {
+	.owner		= THIS_MODULE,
+	.open		= fw_device_op_open,
+	.read		= fw_device_op_read,
+	.unlocked_ioctl	= fw_device_op_ioctl,
+	.poll		= fw_device_op_poll,
+	.release	= fw_device_op_release,
+	.mmap		= fw_device_op_mmap,
+
+#ifdef CONFIG_COMPAT
+	.compat_ioctl	= fw_device_op_compat_ioctl,
+#endif
+};

-- 
Stefan Richter
-=====-=-=== -=-= ---=-
http://arcgraph.de/sr/

