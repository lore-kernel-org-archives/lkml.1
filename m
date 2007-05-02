Return-Path: <linux-kernel-owner+w=401wt.eu-S2993362AbXEBPgZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2993362AbXEBPgZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2007 11:36:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2993377AbXEBPgZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 May 2007 11:36:25 -0400
Received: from Mycroft.westnet.com ([216.187.52.7]:54660 "EHLO
	Mycroft.westnet.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2993362AbXEBPgW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2007 11:36:22 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <17976.44988.734513.121919@smtp.charter.net>
Date: Wed, 2 May 2007 11:35:24 -0400
From: "John Stoffel" <john@stoffel.org>
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: linux-kernel@vger.kernel.org, Kristian H??gsberg <krh@redhat.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       linux1394-devel <linux1394-devel@lists.sourceforge.net>,
       Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 3/6] firewire: char device interface
In-Reply-To: <tkrat.2aa3f3ac11a3d60d@s5r6.in-berlin.de>
References: <4637A29F.6070302@redhat.com>
	<20070502090007.GA28174@infradead.org>
	<tkrat.087ee29add656926@s5r6.in-berlin.de>
	<tkrat.350cb4dfe522266e@s5r6.in-berlin.de>
	<tkrat.65aea95f1451c211@s5r6.in-berlin.de>
	<tkrat.2aa3f3ac11a3d60d@s5r6.in-berlin.de>
X-Mailer: VM 7.19 under Emacs 21.4.1
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

>>>>> "Stefan" == Stefan Richter <stefanr@s5r6.in-berlin.de> writes:

Stefan> Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
Stefan> ---
Stefan>  drivers/firewire/fw-cdev.c    |  954 ++++++++++++++++++++++++++++++++++
Stefan>  include/linux/firewire-cdev.h |  268 +++++++++
Stefan>  2 files changed, 1222 insertions(+)

Stefan> Index: linux_juju/include/linux/firewire-cdev.h
Stefan> ===================================================================
Stefan> --- /dev/null
Stefan> +++ linux_juju/include/linux/firewire-cdev.h
Stefan> @@ -0,0 +1,268 @@
Stefan> +/*						-*- c-basic-offset: 8 -*-
Stefan> + *
Stefan> + * fw-device-cdev.h -- Char device interface.
Stefan> + *
Stefan> + * Copyright (C) 2005-2006  Kristian Hoegsberg <krh@bitplanet.net>
Stefan> + *
Stefan> + * This program is free software; you can redistribute it and/or modify
Stefan> + * it under the terms of the GNU General Public License as published by
Stefan> + * the Free Software Foundation; either version 2 of the License, or
Stefan> + * (at your option) any later version.
Stefan> + *
Stefan> + * This program is distributed in the hope that it will be useful,
Stefan> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
Stefan> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
Stefan> + * GNU General Public License for more details.
Stefan> + *
Stefan> + * You should have received a copy of the GNU General Public License
Stefan> + * along with this program; if not, write to the Free Software Foundation,
Stefan> + * Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
Stefan> + */
Stefan> +
Stefan> +#ifndef __fw_cdev_h
Stefan> +#define __fw_cdev_h
Stefan> +
Stefan> +#include <asm/ioctl.h>
Stefan> +#include <asm/types.h>
Stefan> +
Stefan> +#define TCODE_WRITE_QUADLET_REQUEST	0
Stefan> +#define TCODE_WRITE_BLOCK_REQUEST	1
Stefan> +#define TCODE_WRITE_RESPONSE		2
Stefan> +#define TCODE_READ_QUADLET_REQUEST	4
Stefan> +#define TCODE_READ_BLOCK_REQUEST	5
Stefan> +#define TCODE_READ_QUADLET_RESPONSE	6
Stefan> +#define TCODE_READ_BLOCK_RESPONSE	7
Stefan> +#define TCODE_CYCLE_START		8
Stefan> +#define TCODE_LOCK_REQUEST		9
Stefan> +#define TCODE_STREAM_DATA		10
Stefan> +#define TCODE_LOCK_RESPONSE		11
Stefan> +
Stefan> +#define TCODE_LOCK_MASK_SWAP		0x11
Stefan> +#define TCODE_LOCK_COMPARE_SWAP		0x12
Stefan> +#define TCODE_LOCK_FETCH_ADD		0x13
Stefan> +#define TCODE_LOCK_LITTLE_ADD		0x14
Stefan> +#define TCODE_LOCK_BOUNDED_ADD		0x15
Stefan> +#define TCODE_LOCK_WRAP_ADD		0x16
Stefan> +#define TCODE_LOCK_VENDOR_DEPENDENT	0x17
Stefan> +
Stefan> +#define RCODE_COMPLETE			0x0
Stefan> +#define RCODE_CONFLICT_ERROR		0x4
Stefan> +#define RCODE_DATA_ERROR		0x5
Stefan> +#define RCODE_TYPE_ERROR		0x6
Stefan> +#define RCODE_ADDRESS_ERROR		0x7
Stefan> +
Stefan> +#define RCODE_SEND_ERROR		0x10
Stefan> +#define RCODE_CANCELLED			0x11
Stefan> +#define RCODE_BUSY			0x12
Stefan> +#define RCODE_GENERATION		0x13
Stefan> +#define RCODE_NO_ACK			0x14
Stefan> +
Stefan> +#define SCODE_100			0x0
Stefan> +#define SCODE_200			0x1
Stefan> +#define SCODE_400			0x2
Stefan> +#define SCODE_800			0x3
Stefan> +#define SCODE_1600			0x4
Stefan> +#define SCODE_3200			0x5

These are also defined in fw-transaction.h, though that file doesn't
have all the values.  Can these just be combined into a single
fw-constants.h file instead?  

I honestly haven't checked all your defines....


Stefan> +#define FW_CDEV_EVENT_BUS_RESET		0x00
Stefan> +#define FW_CDEV_EVENT_RESPONSE		0x01
Stefan> +#define FW_CDEV_EVENT_REQUEST		0x02
Stefan> +#define FW_CDEV_EVENT_ISO_INTERRUPT	0x03
Stefan> +
Stefan> +/* The 'closure' fields are for user space to use.  Data passed in the
Stefan> + * 'closure' field for a request will be returned in the corresponding
Stefan> + * event.  It's a 64-bit type so that it's a fixed size type big
Stefan> + * enough to hold a pointer on all platforms. */
Stefan> +
Stefan> +struct fw_cdev_event_common {
Stefan> +	__u64 closure;
Stefan> +	__u32 type;
Stefan> +};
Stefan> +
Stefan> +struct fw_cdev_event_bus_reset {
Stefan> +	__u64 closure;
Stefan> +	__u32 type;
Stefan> +	__u32 node_id;
Stefan> +	__u32 local_node_id;
Stefan> +	__u32 bm_node_id;
Stefan> +	__u32 irm_node_id;
Stefan> +	__u32 root_node_id;
Stefan> +	__u32 generation;
Stefan> +};
Stefan> +
Stefan> +struct fw_cdev_event_response {
Stefan> +	__u64 closure;
Stefan> +	__u32 type;
Stefan> +	__u32 rcode;
Stefan> +	__u32 length;
Stefan> +	__u32 data[0];
Stefan> +};
Stefan> +
Stefan> +struct fw_cdev_event_request {
Stefan> +	__u64 closure;
Stefan> +	__u32 type;
Stefan> +	__u32 tcode;
Stefan> +	__u64 offset;
Stefan> +	__u32 handle;
Stefan> +	__u32 length;
Stefan> +	__u32 data[0];
Stefan> +};
Stefan> +
Stefan> +struct fw_cdev_event_iso_interrupt {
Stefan> +	__u64 closure;
Stefan> +	__u32 type;
Stefan> +	__u32 cycle;
Stefan> +	__u32 header_length;	/* Length in bytes of following headers. */
Stefan> +	__u32 header[0];
Stefan> +};
Stefan> +
Stefan> +union fw_cdev_event {
Stefan> +	struct fw_cdev_event_common common;
Stefan> +	struct fw_cdev_event_bus_reset bus_reset;
Stefan> +	struct fw_cdev_event_response response;
Stefan> +	struct fw_cdev_event_request request;
Stefan> +	struct fw_cdev_event_iso_interrupt iso_interrupt;
Stefan> +};
Stefan> +
Stefan> +#define FW_CDEV_IOC_GET_INFO		_IOWR('#', 0x00, struct fw_cdev_get_info)
Stefan> +#define FW_CDEV_IOC_SEND_REQUEST	_IOW('#', 0x01, struct fw_cdev_send_request)
Stefan> +#define FW_CDEV_IOC_ALLOCATE		_IOWR('#', 0x02, struct fw_cdev_allocate)
Stefan> +#define FW_CDEV_IOC_DEALLOCATE		_IOW('#', 0x03, struct fw_cdev_deallocate)
Stefan> +#define FW_CDEV_IOC_SEND_RESPONSE	_IOW('#', 0x04, struct fw_cdev_send_response)
Stefan> +#define FW_CDEV_IOC_INITIATE_BUS_RESET	_IOW('#', 0x05, struct fw_cdev_initiate_bus_reset)
Stefan> +#define FW_CDEV_IOC_ADD_DESCRIPTOR	_IOWR('#', 0x06, struct fw_cdev_add_descriptor)
Stefan> +#define FW_CDEV_IOC_REMOVE_DESCRIPTOR	_IOW('#', 0x07, struct fw_cdev_remove_descriptor)
Stefan> +
Stefan> +#define FW_CDEV_IOC_CREATE_ISO_CONTEXT	_IOWR('#', 0x08, struct fw_cdev_create_iso_context)
Stefan> +#define FW_CDEV_IOC_QUEUE_ISO		_IOWR('#', 0x09, struct fw_cdev_queue_iso)
Stefan> +#define FW_CDEV_IOC_START_ISO		_IOW('#', 0x0a, struct fw_cdev_start_iso)
Stefan> +#define FW_CDEV_IOC_STOP_ISO		_IOW('#', 0x0b, struct fw_cdev_stop_iso)
Stefan> +
Stefan> +/* FW_CDEV_VERSION History
Stefan> + *
Stefan> + * 1	Feb 18, 2007:  Initial version.
Stefan> + */
Stefan> +#define FW_CDEV_VERSION		1
Stefan> +
Stefan> +struct fw_cdev_get_info {
Stefan> +	/* The version field is just a running serial number.  We
Stefan> +	 * never break backwards compatibility.  Userspace passes in
Stefan> +	 * the version it expects and the kernel passes back the
Stefan> +	 * highest version it can provide.  Even if the structs in
Stefan> +	 * this interface are extended in a later version, the kernel
Stefan> +	 * will not copy back more data than what was present in the
Stefan> +	 * interface version userspace expects. */
Stefan> +	__u32 version;
Stefan> +
Stefan> +	/* If non-zero, at most rom_length bytes of config rom will be
Stefan> +	 * copied into that user space address.  In either case,
Stefan> +	 * rom_length is updated with the actual length of the config
Stefan> +	 * rom. */
Stefan> +	__u32 rom_length;
Stefan> +	__u64 rom;
Stefan> +
Stefan> +	/* If non-zero, a fw_cdev_event_bus_reset struct will be
Stefan> +	 * copied here with the current state of the bus.  This does
Stefan> +	 * not cause a bus reset to happen.  The value of closure in
Stefan> +	 * this and sub-sequent bus reset events is set to
Stefan> +	 * bus_reset_closure. */
Stefan> +	__u64 bus_reset;
Stefan> +	__u64 bus_reset_closure;
Stefan> +
Stefan> +	/* The index of the card this devices belongs to. */
Stefan> +	__u32 card;
Stefan> +};
Stefan> +
Stefan> +struct fw_cdev_send_request {
Stefan> +	__u32 tcode;
Stefan> +	__u32 length;
Stefan> +	__u64 offset;
Stefan> +	__u64 closure;
Stefan> +	__u64 data;
Stefan> +	__u32 generation;
Stefan> +};
Stefan> +
Stefan> +struct fw_cdev_send_response {
Stefan> +	__u32 rcode;
Stefan> +	__u32 length;
Stefan> +	__u64 data;
Stefan> +	__u32 handle;
Stefan> +};
Stefan> +
Stefan> +struct fw_cdev_allocate {
Stefan> +	__u64 offset;
Stefan> +	__u64 closure;
Stefan> +	__u32 length;
Stefan> +	__u32 handle;
Stefan> +};
Stefan> +
Stefan> +struct fw_cdev_deallocate {
Stefan> +	__u32 handle;
Stefan> +};
Stefan> +
Stefan> +#define FW_CDEV_LONG_RESET	0
Stefan> +#define FW_CDEV_SHORT_RESET	1
Stefan> +
Stefan> +struct fw_cdev_initiate_bus_reset {
Stefan> +	__u32 type;
Stefan> +};
Stefan> +
Stefan> +struct fw_cdev_add_descriptor {
Stefan> +	__u32 immediate;
Stefan> +	__u32 key;
Stefan> +	__u64 data;
Stefan> +	__u32 length;
Stefan> +	__u32 handle;
Stefan> +};
Stefan> +
Stefan> +struct fw_cdev_remove_descriptor {
Stefan> +	__u32 handle;
Stefan> +};
Stefan> +
Stefan> +#define FW_CDEV_ISO_CONTEXT_TRANSMIT	0
Stefan> +#define FW_CDEV_ISO_CONTEXT_RECEIVE	1
Stefan> +
Stefan> +#define FW_CDEV_ISO_CONTEXT_MATCH_TAG0		 1
Stefan> +#define FW_CDEV_ISO_CONTEXT_MATCH_TAG1		 2
Stefan> +#define FW_CDEV_ISO_CONTEXT_MATCH_TAG2		 4
Stefan> +#define FW_CDEV_ISO_CONTEXT_MATCH_TAG3		 8
Stefan> +#define FW_CDEV_ISO_CONTEXT_MATCH_ALL_TAGS	15
Stefan> +
Stefan> +struct fw_cdev_create_iso_context {
Stefan> +	__u32 type;
Stefan> +	__u32 header_size;
Stefan> +	__u32 channel;
Stefan> +	__u32 speed;
Stefan> +	__u64 closure;
Stefan> +	__u32 handle;
Stefan> +};
Stefan> +
Stefan> +struct fw_cdev_iso_packet {
Stefan> +	__u16 payload_length;	/* Length of indirect payload. */
Stefan> +	__u32 interrupt : 1;	/* Generate interrupt on this packet */
Stefan> +	__u32 skip : 1;		/* Set to not send packet at all. */
Stefan> +	__u32 tag : 2;
Stefan> +	__u32 sy : 4;
Stefan> +	__u32 header_length : 8;	/* Length of immediate header. */
Stefan> +	__u32 header[0];
Stefan> +};
Stefan> +
Stefan> +struct fw_cdev_queue_iso {
Stefan> +	__u64 packets;
Stefan> +	__u64 data;
Stefan> +	__u32 size;
Stefan> +	__u32 handle;
Stefan> +};
Stefan> +
Stefan> +struct fw_cdev_start_iso {
Stefan> +	__s32 cycle;
Stefan> +	__u32 sync;
Stefan> +	__u32 tags;
Stefan> +	__u32 handle;
Stefan> +};
Stefan> +
Stefan> +struct fw_cdev_stop_iso {
Stefan> +	__u32 handle;
Stefan> +};
Stefan> +
Stefan> +#endif /* __fw_cdev_h */
Stefan> Index: linux_juju/drivers/firewire/fw-cdev.c
Stefan> ===================================================================
Stefan> --- /dev/null
Stefan> +++ linux_juju/drivers/firewire/fw-cdev.c
Stefan> @@ -0,0 +1,954 @@
Stefan> +/*						-*- c-basic-offset: 8 -*-
Stefan> + *
Stefan> + * fw-device-cdev.c - Char device for device raw access
Stefan> + *
Stefan> + * Copyright (C) 2005-2006  Kristian Hoegsberg <krh@bitplanet.net>
Stefan> + *
Stefan> + * This program is free software; you can redistribute it and/or modify
Stefan> + * it under the terms of the GNU General Public License as published by
Stefan> + * the Free Software Foundation; either version 2 of the License, or
Stefan> + * (at your option) any later version.
Stefan> + *
Stefan> + * This program is distributed in the hope that it will be useful,
Stefan> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
Stefan> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
Stefan> + * GNU General Public License for more details.
Stefan> + *
Stefan> + * You should have received a copy of the GNU General Public License
Stefan> + * along with this program; if not, write to the Free Software Foundation,
Stefan> + * Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
Stefan> + */
Stefan> +
Stefan> +#include <linux/module.h>
Stefan> +#include <linux/kernel.h>
Stefan> +#include <linux/wait.h>
Stefan> +#include <linux/errno.h>
Stefan> +#include <linux/device.h>
Stefan> +#include <linux/vmalloc.h>
Stefan> +#include <linux/poll.h>
Stefan> +#include <linux/delay.h>
Stefan> +#include <linux/mm.h>
Stefan> +#include <linux/idr.h>
Stefan> +#include <linux/compat.h>
Stefan> +#include <linux/firewire-cdev.h>
Stefan> +#include <asm/uaccess.h>
Stefan> +#include "fw-transaction.h"
Stefan> +#include "fw-topology.h"
Stefan> +#include "fw-device.h"
Stefan> +
Stefan> +/* dequeue_event() just kfree()'s the event, so the event has to be
Stefan> + * the first field in the struct. */
Stefan> +
Stefan> +struct client;
Stefan> +struct client_resource {
Stefan> +	struct list_head link;
Stefan> +	void (*release)(struct client *client, struct client_resource *r);
Stefan> +	u32 handle;
Stefan> +};
Stefan> +
Stefan> +struct event {
Stefan> +	struct { void *data; size_t size; } v[2];
Stefan> +	struct list_head link;
Stefan> +};
Stefan> +
Stefan> +struct bus_reset {
Stefan> +	struct event event;
Stefan> +	struct fw_cdev_event_bus_reset reset;
Stefan> +};
Stefan> +
Stefan> +struct response {
Stefan> +	struct event event;
Stefan> +	struct fw_transaction transaction;
Stefan> +	struct client *client;
Stefan> +	struct client_resource resource;
Stefan> +	struct fw_cdev_event_response response;
Stefan> +};
Stefan> +
Stefan> +struct iso_interrupt {
Stefan> +	struct event event;
Stefan> +	struct fw_cdev_event_iso_interrupt interrupt;
Stefan> +};
Stefan> +
Stefan> +struct client {
Stefan> +	u32 version;
Stefan> +	struct fw_device *device;
Stefan> +	spinlock_t lock;
Stefan> +	u32 resource_handle;
Stefan> +	struct list_head resource_list;
Stefan> +	struct list_head event_list;
Stefan> +	wait_queue_head_t wait;
Stefan> +	u64 bus_reset_closure;
Stefan> +
Stefan> +	struct fw_iso_context *iso_context;
Stefan> +	u64 iso_closure;
Stefan> +	struct fw_iso_buffer buffer;
Stefan> +	unsigned long vm_start;
Stefan> +
Stefan> +	struct list_head link;
Stefan> +};
Stefan> +
Stefan> +static inline void __user *
Stefan> +u64_to_uptr(__u64 value)
Stefan> +{
Stefan> +	return (void __user *)(unsigned long)value;
Stefan> +}
Stefan> +
Stefan> +static inline __u64
Stefan> +uptr_to_u64(void __user *ptr)
Stefan> +{
Stefan> +	return (__u64)(unsigned long)ptr;
Stefan> +}
Stefan> +
Stefan> +static int fw_device_op_open(struct inode *inode, struct file *file)
Stefan> +{
Stefan> +	struct fw_device *device;
Stefan> +	struct client *client;
Stefan> +	unsigned long flags;
Stefan> +
Stefan> +	device = fw_device_from_devt(inode->i_rdev);
Stefan> +	if (device == NULL)
Stefan> +		return -ENODEV;
Stefan> +
Stefan> +	client = kzalloc(sizeof *client, GFP_KERNEL);
Stefan> +	if (client == NULL)
Stefan> +		return -ENOMEM;
Stefan> +
Stefan> +	client->device = fw_device_get(device);
Stefan> +	INIT_LIST_HEAD(&client->event_list);
Stefan> +	INIT_LIST_HEAD(&client->resource_list);
Stefan> +	spin_lock_init(&client->lock);
Stefan> +	init_waitqueue_head(&client->wait);
Stefan> +
Stefan> +	file->private_data = client;
Stefan> +
Stefan> +	spin_lock_irqsave(&device->card->lock, flags);
Stefan> +	list_add_tail(&client->link, &device->client_list);
Stefan> +	spin_unlock_irqrestore(&device->card->lock, flags);
Stefan> +
Stefan> +	return 0;
Stefan> +}
Stefan> +
Stefan> +static void queue_event(struct client *client, struct event *event,
Stefan> +			void *data0, size_t size0, void *data1, size_t size1)
Stefan> +{
Stefan> +	unsigned long flags;
Stefan> +
Stefan> +	event->v[0].data = data0;
Stefan> +	event->v[0].size = size0;
Stefan> +	event->v[1].data = data1;
Stefan> +	event->v[1].size = size1;
Stefan> +
Stefan> +	spin_lock_irqsave(&client->lock, flags);
Stefan> +
Stefan> +	list_add_tail(&event->link, &client->event_list);
Stefan> +	wake_up_interruptible(&client->wait);
Stefan> +
Stefan> +	spin_unlock_irqrestore(&client->lock, flags);
Stefan> +}
Stefan> +
Stefan> +static int
Stefan> +dequeue_event(struct client *client, char __user *buffer, size_t count)
Stefan> +{
Stefan> +	unsigned long flags;
Stefan> +	struct event *event;
Stefan> +	size_t size, total;
Stefan> +	int i, retval;
Stefan> +
Stefan> +	retval = wait_event_interruptible(client->wait,
Stefan> +					  !list_empty(&client->event_list) ||
Stefan> +					  fw_device_is_shutdown(client->device));
Stefan> +	if (retval < 0)
Stefan> +		return retval;
Stefan> +
Stefan> +	if (list_empty(&client->event_list) &&
Stefan> +		       fw_device_is_shutdown(client->device))
Stefan> +		return -ENODEV;
Stefan> +
Stefan> +	spin_lock_irqsave(&client->lock, flags);
Stefan> +	event = container_of(client->event_list.next, struct event, link);
Stefan> +	list_del(&event->link);
Stefan> +	spin_unlock_irqrestore(&client->lock, flags);
Stefan> +
Stefan> +	total = 0;
Stefan> +	for (i = 0; i < ARRAY_SIZE(event->v) && total < count; i++) {
Stefan> +		size = min(event->v[i].size, count - total);
Stefan> +		if (copy_to_user(buffer + total, event->v[i].data, size)) {
Stefan> +			retval = -EFAULT;
Stefan> +			goto out;
Stefan> +		}
Stefan> +		total += size;
Stefan> +	}
Stefan> +	retval = total;
Stefan> +
Stefan> + out:
Stefan> +	kfree(event);
Stefan> +
Stefan> +	return retval;
Stefan> +}
Stefan> +
Stefan> +static ssize_t
Stefan> +fw_device_op_read(struct file *file,
Stefan> +		  char __user *buffer, size_t count, loff_t *offset)
Stefan> +{
Stefan> +	struct client *client = file->private_data;
Stefan> +
Stefan> +	return dequeue_event(client, buffer, count);
Stefan> +}
Stefan> +
Stefan> +static void
Stefan> +fill_bus_reset_event(struct fw_cdev_event_bus_reset *event,
Stefan> +		     struct client *client)
Stefan> +{
Stefan> +	struct fw_card *card = client->device->card;
Stefan> +
Stefan> +	event->closure	     = client->bus_reset_closure;
Stefan> +	event->type          = FW_CDEV_EVENT_BUS_RESET;
Stefan> +	event->node_id       = client->device->node_id;
Stefan> +	event->local_node_id = card->local_node->node_id;
Stefan> +	event->bm_node_id    = 0; /* FIXME: We don't track the BM. */
Stefan> +	event->irm_node_id   = card->irm_node->node_id;
Stefan> +	event->root_node_id  = card->root_node->node_id;
Stefan> +	event->generation    = card->generation;
Stefan> +}
Stefan> +
Stefan> +static void
Stefan> +for_each_client(struct fw_device *device,
Stefan> +		void (*callback)(struct client *client))
Stefan> +{
Stefan> +	struct fw_card *card = device->card;
Stefan> +	struct client *c;
Stefan> +	unsigned long flags;
Stefan> +
Stefan> +	spin_lock_irqsave(&card->lock, flags);
Stefan> +
Stefan> +	list_for_each_entry(c, &device->client_list, link)
Stefan> +		callback(c);
Stefan> +
Stefan> +	spin_unlock_irqrestore(&card->lock, flags);
Stefan> +}
Stefan> +
Stefan> +static void
Stefan> +queue_bus_reset_event(struct client *client)
Stefan> +{
Stefan> +	struct bus_reset *bus_reset;
Stefan> +
Stefan> +	bus_reset = kzalloc(sizeof *bus_reset, GFP_ATOMIC);
Stefan> +	if (bus_reset == NULL) {
Stefan> +		fw_notify("Out of memory when allocating bus reset event\n");
Stefan> +		return;
Stefan> +	}
Stefan> +
Stefan> +	fill_bus_reset_event(&bus_reset->reset, client);
Stefan> +
Stefan> +	queue_event(client, &bus_reset->event,
Stefan> +		    &bus_reset->reset, sizeof bus_reset->reset, NULL, 0);
Stefan> +}
Stefan> +
Stefan> +void fw_device_cdev_update(struct fw_device *device)
Stefan> +{
Stefan> +	for_each_client(device, queue_bus_reset_event);
Stefan> +}
Stefan> +
Stefan> +static void wake_up_client(struct client *client)
Stefan> +{
Stefan> +	wake_up_interruptible(&client->wait);
Stefan> +}
Stefan> +
Stefan> +void fw_device_cdev_remove(struct fw_device *device)
Stefan> +{
Stefan> +	for_each_client(device, wake_up_client);
Stefan> +}
Stefan> +
Stefan> +static int ioctl_get_info(struct client *client, void *buffer)
Stefan> +{
Stefan> +	struct fw_cdev_get_info *get_info = buffer;
Stefan> +	struct fw_cdev_event_bus_reset bus_reset;
Stefan> +
Stefan> +	client->version = get_info->version;
Stefan> +	get_info->version = FW_CDEV_VERSION;
Stefan> +
Stefan> +	if (get_info->rom != 0) {
Stefan> +		void __user *uptr = u64_to_uptr(get_info->rom);
Stefan> +		size_t want = get_info->rom_length;
Stefan> +		size_t have = client->device->config_rom_length * 4;
Stefan> +
Stefan> +		if (copy_to_user(uptr, client->device->config_rom,
Stefan> +				 min(want, have)))
Stefan> +			return -EFAULT;
Stefan> +	}
Stefan> +	get_info->rom_length = client->device->config_rom_length * 4;
Stefan> +
Stefan> +	client->bus_reset_closure = get_info->bus_reset_closure;
Stefan> +	if (get_info->bus_reset != 0) {
Stefan> +		void __user *uptr = u64_to_uptr(get_info->bus_reset);
Stefan> +
Stefan> +		fill_bus_reset_event(&bus_reset, client);
Stefan> +		if (copy_to_user(uptr, &bus_reset, sizeof bus_reset))
Stefan> +			return -EFAULT;
Stefan> +	}
Stefan> +
Stefan> +	get_info->card = client->device->card->index;
Stefan> +
Stefan> +	return 0;
Stefan> +}
Stefan> +
Stefan> +static void
Stefan> +add_client_resource(struct client *client, struct client_resource *resource)
Stefan> +{
Stefan> +	unsigned long flags;
Stefan> +
Stefan> +	spin_lock_irqsave(&client->lock, flags);
Stefan> +	list_add_tail(&resource->link, &client->resource_list);
Stefan> +	resource->handle = client->resource_handle++;
Stefan> +	spin_unlock_irqrestore(&client->lock, flags);
Stefan> +}
Stefan> +
Stefan> +static int
Stefan> +release_client_resource(struct client *client, u32 handle,
Stefan> +			struct client_resource **resource)
Stefan> +{
Stefan> +	struct client_resource *r;
Stefan> +	unsigned long flags;
Stefan> +
Stefan> +	spin_lock_irqsave(&client->lock, flags);
Stefan> +	list_for_each_entry(r, &client->resource_list, link) {
Stefan> +		if (r->handle == handle) {
Stefan> +			list_del(&r->link);
Stefan> +			break;
Stefan> +		}
Stefan> +	}
Stefan> +	spin_unlock_irqrestore(&client->lock, flags);
Stefan> +
Stefan> +	if (&r->link == &client->resource_list)
Stefan> +		return -EINVAL;
Stefan> +
Stefan> +	if (resource)
Stefan> +		*resource = r;
Stefan> +	else
Stefan> +		r->release(client, r);
Stefan> +
Stefan> +	return 0;
Stefan> +}
Stefan> +
Stefan> +static void
Stefan> +release_transaction(struct client *client, struct client_resource *resource)
Stefan> +{
Stefan> +	struct response *response =
Stefan> +		container_of(resource, struct response, resource);
Stefan> +
Stefan> +	fw_cancel_transaction(client->device->card, &response->transaction);
Stefan> +}
Stefan> +
Stefan> +static void
Stefan> +complete_transaction(struct fw_card *card, int rcode,
Stefan> +		     void *payload, size_t length, void *data)
Stefan> +{
Stefan> +	struct response *response = data;
Stefan> +	struct client *client = response->client;
Stefan> +	unsigned long flags;
Stefan> +
Stefan> +	if (length < response->response.length)
Stefan> +		response->response.length = length;
Stefan> +	if (rcode == RCODE_COMPLETE)
Stefan> +		memcpy(response->response.data, payload,
Stefan> +		       response->response.length);
Stefan> +
Stefan> +	spin_lock_irqsave(&client->lock, flags);
Stefan> +	list_del(&response->resource.link);
Stefan> +	spin_unlock_irqrestore(&client->lock, flags);
Stefan> +
Stefan> +	response->response.type   = FW_CDEV_EVENT_RESPONSE;
Stefan> +	response->response.rcode  = rcode;
Stefan> +	queue_event(client, &response->event,
Stefan> +		    &response->response, sizeof response->response,
Stefan> +		    response->response.data, response->response.length);
Stefan> +}
Stefan> +
Stefan> +static ssize_t ioctl_send_request(struct client *client, void *buffer)
Stefan> +{
Stefan> +	struct fw_device *device = client->device;
Stefan> +	struct fw_cdev_send_request *request = buffer;
Stefan> +	struct response *response;
Stefan> +
Stefan> +	/* What is the biggest size we'll accept, really? */
Stefan> +	if (request->length > 4096)
Stefan> +		return -EINVAL;
Stefan> +
Stefan> +	response = kmalloc(sizeof *response + request->length, GFP_KERNEL);
Stefan> +	if (response == NULL)
Stefan> +		return -ENOMEM;
Stefan> +
Stefan> +	response->client = client;
Stefan> +	response->response.length = request->length;
Stefan> +	response->response.closure = request->closure;
Stefan> +
Stefan> +	if (request->data &&
Stefan> +	    copy_from_user(response->response.data,
Stefan> +			   u64_to_uptr(request->data), request->length)) {
Stefan> +		kfree(response);
Stefan> +		return -EFAULT;
Stefan> +	}
Stefan> +
Stefan> +	response->resource.release = release_transaction;
Stefan> +	add_client_resource(client, &response->resource);
Stefan> +
Stefan> +	fw_send_request(device->card, &response->transaction,
Stefan> +			request->tcode & 0x1f,
Stefan> +			device->node->node_id,
Stefan> +			request->generation,
Stefan> +			device->node->max_speed,
Stefan> +			request->offset,
Stefan> +			response->response.data, request->length,
Stefan> +			complete_transaction, response);
Stefan> +
Stefan> +	if (request->data)
Stefan> +		return sizeof request + request->length;
Stefan> +	else
Stefan> +		return sizeof request;
Stefan> +}
Stefan> +
Stefan> +struct address_handler {
Stefan> +	struct fw_address_handler handler;
Stefan> +	__u64 closure;
Stefan> +	struct client *client;
Stefan> +	struct client_resource resource;
Stefan> +};
Stefan> +
Stefan> +struct request {
Stefan> +	struct fw_request *request;
Stefan> +	void *data;
Stefan> +	size_t length;
Stefan> +	struct client_resource resource;
Stefan> +};
Stefan> +
Stefan> +struct request_event {
Stefan> +	struct event event;
Stefan> +	struct fw_cdev_event_request request;
Stefan> +};
Stefan> +
Stefan> +static void
Stefan> +release_request(struct client *client, struct client_resource *resource)
Stefan> +{
Stefan> +	struct request *request =
Stefan> +		container_of(resource, struct request, resource);
Stefan> +
Stefan> +	fw_send_response(client->device->card, request->request,
Stefan> +			 RCODE_CONFLICT_ERROR);
Stefan> +	kfree(request);
Stefan> +}
Stefan> +
Stefan> +static void
Stefan> +handle_request(struct fw_card *card, struct fw_request *r,
Stefan> +	       int tcode, int destination, int source,
Stefan> +	       int generation, int speed,
Stefan> +	       unsigned long long offset,
Stefan> +	       void *payload, size_t length, void *callback_data)
Stefan> +{
Stefan> +	struct address_handler *handler = callback_data;
Stefan> +	struct request *request;
Stefan> +	struct request_event *e;
Stefan> +	struct client *client = handler->client;
Stefan> +
Stefan> +	request = kmalloc(sizeof *request, GFP_ATOMIC);
Stefan> +	e = kmalloc(sizeof *e, GFP_ATOMIC);
Stefan> +	if (request == NULL || e == NULL) {
Stefan> +		kfree(request);
Stefan> +		kfree(e);
Stefan> +		fw_send_response(card, r, RCODE_CONFLICT_ERROR);
Stefan> +		return;
Stefan> +	}
Stefan> +
Stefan> +	request->request = r;
Stefan> +	request->data    = payload;
Stefan> +	request->length  = length;
Stefan> +
Stefan> +	request->resource.release = release_request;
Stefan> +	add_client_resource(client, &request->resource);
Stefan> +
Stefan> +	e->request.type    = FW_CDEV_EVENT_REQUEST;
Stefan> +	e->request.tcode   = tcode;
Stefan> +	e->request.offset  = offset;
Stefan> +	e->request.length  = length;
Stefan> +	e->request.handle  = request->resource.handle;
Stefan> +	e->request.closure = handler->closure;
Stefan> +
Stefan> +	queue_event(client, &e->event,
Stefan> +		    &e->request, sizeof e->request, payload, length);
Stefan> +}
Stefan> +
Stefan> +static void
Stefan> +release_address_handler(struct client *client,
Stefan> +			struct client_resource *resource)
Stefan> +{
Stefan> +	struct address_handler *handler =
Stefan> +		container_of(resource, struct address_handler, resource);
Stefan> +
Stefan> +	fw_core_remove_address_handler(&handler->handler);
Stefan> +	kfree(handler);
Stefan> +}
Stefan> +
Stefan> +static int ioctl_allocate(struct client *client, void *buffer)
Stefan> +{
Stefan> +	struct fw_cdev_allocate *request = buffer;
Stefan> +	struct address_handler *handler;
Stefan> +	struct fw_address_region region;
Stefan> +
Stefan> +	handler = kmalloc(sizeof *handler, GFP_KERNEL);
Stefan> +	if (handler == NULL)
Stefan> +		return -ENOMEM;
Stefan> +
Stefan> +	region.start = request->offset;
Stefan> +	region.end = request->offset + request->length;
Stefan> +	handler->handler.length = request->length;
Stefan> +	handler->handler.address_callback = handle_request;
Stefan> +	handler->handler.callback_data = handler;
Stefan> +	handler->closure = request->closure;
Stefan> +	handler->client = client;
Stefan> +
Stefan> +	if (fw_core_add_address_handler(&handler->handler, &region) < 0) {
Stefan> +		kfree(handler);
Stefan> +		return -EBUSY;
Stefan> +	}
Stefan> +
Stefan> +	handler->resource.release = release_address_handler;
Stefan> +	add_client_resource(client, &handler->resource);
Stefan> +	request->handle = handler->resource.handle;
Stefan> +
Stefan> +	return 0;
Stefan> +}
Stefan> +
Stefan> +static int ioctl_deallocate(struct client *client, void *buffer)
Stefan> +{
Stefan> +	struct fw_cdev_deallocate *request = buffer;
Stefan> +
Stefan> +	return release_client_resource(client, request->handle, NULL);
Stefan> +}
Stefan> +
Stefan> +static int ioctl_send_response(struct client *client, void *buffer)
Stefan> +{
Stefan> +	struct fw_cdev_send_response *request = buffer;
Stefan> +	struct client_resource *resource;
Stefan> +	struct request *r;
Stefan> +
Stefan> +	if (release_client_resource(client, request->handle, &resource) < 0)
Stefan> +		return -EINVAL;
Stefan> +	r = container_of(resource, struct request, resource);
Stefan> +	if (request->length < r->length)
Stefan> +		r->length = request->length;
Stefan> +	if (copy_from_user(r->data, u64_to_uptr(request->data), r->length))
Stefan> +		return -EFAULT;
Stefan> +
Stefan> +	fw_send_response(client->device->card, r->request, request->rcode);
Stefan> +	kfree(r);
Stefan> +
Stefan> +	return 0;
Stefan> +}
Stefan> +
Stefan> +static int ioctl_initiate_bus_reset(struct client *client, void *buffer)
Stefan> +{
Stefan> +	struct fw_cdev_initiate_bus_reset *request = buffer;
Stefan> +	int short_reset;
Stefan> +
Stefan> +	short_reset = (request->type == FW_CDEV_SHORT_RESET);
Stefan> +
Stefan> +	return fw_core_initiate_bus_reset(client->device->card, short_reset);
Stefan> +}
Stefan> +
Stefan> +struct descriptor {
Stefan> +	struct fw_descriptor d;
Stefan> +	struct client_resource resource;
Stefan> +	u32 data[0];
Stefan> +};
Stefan> +
Stefan> +static void release_descriptor(struct client *client,
Stefan> +			       struct client_resource *resource)
Stefan> +{
Stefan> +	struct descriptor *descriptor =
Stefan> +		container_of(resource, struct descriptor, resource);
Stefan> +
Stefan> +	fw_core_remove_descriptor(&descriptor->d);
Stefan> +	kfree(descriptor);
Stefan> +}
Stefan> +
Stefan> +static int ioctl_add_descriptor(struct client *client, void *buffer)
Stefan> +{
Stefan> +	struct fw_cdev_add_descriptor *request = buffer;
Stefan> +	struct descriptor *descriptor;
Stefan> +	int retval;
Stefan> +
Stefan> +	if (request->length > 256)
Stefan> +		return -EINVAL;
Stefan> +
Stefan> +	descriptor =
Stefan> +		kmalloc(sizeof *descriptor + request->length * 4, GFP_KERNEL);
Stefan> +	if (descriptor == NULL)
Stefan> +		return -ENOMEM;
Stefan> +
Stefan> +	if (copy_from_user(descriptor->data,
Stefan> +			   u64_to_uptr(request->data), request->length * 4)) {
Stefan> +		kfree(descriptor);
Stefan> +		return -EFAULT;
Stefan> +	}
Stefan> +
Stefan> +	descriptor->d.length = request->length;
Stefan> +	descriptor->d.immediate = request->immediate;
Stefan> +	descriptor->d.key = request->key;
Stefan> +	descriptor->d.data = descriptor->data;
Stefan> +
Stefan> +	retval = fw_core_add_descriptor(&descriptor->d);
Stefan> +	if (retval < 0) {
Stefan> +		kfree(descriptor);
Stefan> +		return retval;
Stefan> +	}
Stefan> +
Stefan> +	descriptor->resource.release = release_descriptor;
Stefan> +	add_client_resource(client, &descriptor->resource);
Stefan> +	request->handle = descriptor->resource.handle;
Stefan> +
Stefan> +	return 0;
Stefan> +}
Stefan> +
Stefan> +static int ioctl_remove_descriptor(struct client *client, void *buffer)
Stefan> +{
Stefan> +	struct fw_cdev_remove_descriptor *request = buffer;
Stefan> +
Stefan> +	return release_client_resource(client, request->handle, NULL);
Stefan> +}
Stefan> +
Stefan> +static void
Stefan> +iso_callback(struct fw_iso_context *context, u32 cycle,
Stefan> +	     size_t header_length, void *header, void *data)
Stefan> +{
Stefan> +	struct client *client = data;
Stefan> +	struct iso_interrupt *interrupt;
Stefan> +
Stefan> +	interrupt = kzalloc(sizeof *interrupt + header_length, GFP_ATOMIC);
Stefan> +	if (interrupt == NULL)
Stefan> +		return;
Stefan> +
Stefan> +	interrupt->interrupt.type      = FW_CDEV_EVENT_ISO_INTERRUPT;
Stefan> +	interrupt->interrupt.closure   = client->iso_closure;
Stefan> +	interrupt->interrupt.cycle     = cycle;
Stefan> +	interrupt->interrupt.header_length = header_length;
Stefan> +	memcpy(interrupt->interrupt.header, header, header_length);
Stefan> +	queue_event(client, &interrupt->event,
Stefan> +		    &interrupt->interrupt,
Stefan> +		    sizeof interrupt->interrupt + header_length, NULL, 0);
Stefan> +}
Stefan> +
Stefan> +static int ioctl_create_iso_context(struct client *client, void *buffer)
Stefan> +{
Stefan> +	struct fw_cdev_create_iso_context *request = buffer;
Stefan> +
Stefan> +	if (request->channel > 63)
Stefan> +		return -EINVAL;
Stefan> +
Stefan> +	switch (request->type) {
Stefan> +	case FW_ISO_CONTEXT_RECEIVE:
Stefan> +		if (request->header_size < 4 || (request->header_size & 3))
Stefan> +			return -EINVAL;
Stefan> +
Stefan> +		break;
Stefan> +
Stefan> +	case FW_ISO_CONTEXT_TRANSMIT:
Stefan> +		if (request->speed > SCODE_3200)
Stefan> +			return -EINVAL;
Stefan> +
Stefan> +		break;
Stefan> +
Stefan> +	default:
Stefan> +		return -EINVAL;
Stefan> +	}
Stefan> +
Stefan> +	client->iso_closure = request->closure;
Stefan> +	client->iso_context = fw_iso_context_create(client->device->card,
Stefan> +						    request->type,
Stefan> +						    request->channel,
Stefan> +						    request->speed,
Stefan> +						    request->header_size,
Stefan> +						    iso_callback, client);
Stefan> +	if (IS_ERR(client->iso_context))
Stefan> +		return PTR_ERR(client->iso_context);
Stefan> +
Stefan> +	/* We only support one context at this time. */
Stefan> +	request->handle = 0;
Stefan> +
Stefan> +	return 0;
Stefan> +}
Stefan> +
Stefan> +static int ioctl_queue_iso(struct client *client, void *buffer)
Stefan> +{
Stefan> +	struct fw_cdev_queue_iso *request = buffer;
Stefan> +	struct fw_cdev_iso_packet __user *p, *end, *next;
Stefan> +	struct fw_iso_context *ctx = client->iso_context;
Stefan> +	unsigned long payload, buffer_end, header_length;
Stefan> +	int count;
Stefan> +	struct {
Stefan> +		struct fw_iso_packet packet;
Stefan> +		u8 header[256];
Stefan> +	} u;
Stefan> +
Stefan> +	if (ctx == NULL || request->handle != 0)
Stefan> +		return -EINVAL;
Stefan> +
Stefan> +	/* If the user passes a non-NULL data pointer, has mmap()'ed
Stefan> +	 * the iso buffer, and the pointer points inside the buffer,
Stefan> +	 * we setup the payload pointers accordingly.  Otherwise we
Stefan> +	 * set them both to 0, which will still let packets with
Stefan> +	 * payload_length == 0 through.  In other words, if no packets
Stefan> +	 * use the indirect payload, the iso buffer need not be mapped
Stefan> +	 * and the request->data pointer is ignored.*/
Stefan> +
Stefan> +	payload = (unsigned long)request->data - client->vm_start;
Stefan> +	buffer_end = client->buffer.page_count << PAGE_SHIFT;
Stefan> +	if (request->data == 0 || client->buffer.pages == NULL ||
Stefan> +	    payload >= buffer_end) {
Stefan> +		payload = 0;
Stefan> +		buffer_end = 0;
Stefan> +	}
Stefan> +
Stefan> +	if (!access_ok(VERIFY_READ, request->packets, request->size))
Stefan> +		return -EFAULT;
Stefan> +
Stefan> +	p = (struct fw_cdev_iso_packet __user *)u64_to_uptr(request->packets);
Stefan> +	end = (void __user *)p + request->size;
Stefan> +	count = 0;
Stefan> +	while (p < end) {
Stefan> +		if (__copy_from_user(&u.packet, p, sizeof *p))
Stefan> +			return -EFAULT;
Stefan> +
Stefan> +		if (ctx->type == FW_ISO_CONTEXT_TRANSMIT) {
Stefan> +			header_length = u.packet.header_length;
Stefan> +		} else {
Stefan> +			/* We require that header_length is a multiple of
Stefan> +			 * the fixed header size, ctx->header_size */
Stefan> +			if (ctx->header_size == 0) {
Stefan> +				if (u.packet.header_length > 0)
Stefan> +					return -EINVAL;
Stefan> +			} else if (u.packet.header_length % ctx->header_size != 0) {
Stefan> +				return -EINVAL;
Stefan> +			}
Stefan> +			header_length = 0;
Stefan> +		}
Stefan> +
Stefan> +		next = (struct fw_cdev_iso_packet __user *)
Stefan> +			&p->header[header_length / 4];
Stefan> +		if (next > end)
Stefan> +			return -EINVAL;
Stefan> +		if (__copy_from_user
Stefan> +		    (u.packet.header, p->header, header_length))
Stefan> +			return -EFAULT;
Stefan> +		if (u.packet.skip && ctx->type == FW_ISO_CONTEXT_TRANSMIT &&
Stefan> +		    u.packet.header_length + u.packet.payload_length > 0)
Stefan> +			return -EINVAL;
Stefan> +		if (payload + u.packet.payload_length > buffer_end)
Stefan> +			return -EINVAL;
Stefan> +
Stefan> +		if (fw_iso_context_queue(ctx, &u.packet,
Stefan> +					 &client->buffer, payload))
Stefan> +			break;
Stefan> +
Stefan> +		p = next;
Stefan> +		payload += u.packet.payload_length;
Stefan> +		count++;
Stefan> +	}
Stefan> +
Stefan> +	request->size    -= uptr_to_u64(p) - request->packets;
Stefan> +	request->packets  = uptr_to_u64(p);
Stefan> +	request->data     = client->vm_start + payload;
Stefan> +
Stefan> +	return count;
Stefan> +}
Stefan> +
Stefan> +static int ioctl_start_iso(struct client *client, void *buffer)
Stefan> +{
Stefan> +	struct fw_cdev_start_iso *request = buffer;
Stefan> +
Stefan> +	if (request->handle != 0)
Stefan> +		return -EINVAL;
Stefan> +	if (client->iso_context->type == FW_ISO_CONTEXT_RECEIVE) {
Stefan> +		if (request->tags == 0 || request->tags > 15)
Stefan> +			return -EINVAL;
Stefan> +
Stefan> +		if (request->sync > 15)
Stefan> +			return -EINVAL;
Stefan> +	}
Stefan> +
Stefan> +	return fw_iso_context_start(client->iso_context, request->cycle,
Stefan> +				    request->sync, request->tags);
Stefan> +}
Stefan> +
Stefan> +static int ioctl_stop_iso(struct client *client, void *buffer)
Stefan> +{
Stefan> +	struct fw_cdev_stop_iso *request = buffer;
Stefan> +
Stefan> +	if (request->handle != 0)
Stefan> +		return -EINVAL;
Stefan> +
Stefan> +	return fw_iso_context_stop(client->iso_context);
Stefan> +}
Stefan> +
Stefan> +static int (* const ioctl_handlers[])(struct client *client, void *buffer) = {
Stefan> +	ioctl_get_info,
Stefan> +	ioctl_send_request,
Stefan> +	ioctl_allocate,
Stefan> +	ioctl_deallocate,
Stefan> +	ioctl_send_response,
Stefan> +	ioctl_initiate_bus_reset,
Stefan> +	ioctl_add_descriptor,
Stefan> +	ioctl_remove_descriptor,
Stefan> +	ioctl_create_iso_context,
Stefan> +	ioctl_queue_iso,
Stefan> +	ioctl_start_iso,
Stefan> +	ioctl_stop_iso,
Stefan> +};
Stefan> +
Stefan> +static int
Stefan> +dispatch_ioctl(struct client *client, unsigned int cmd, void __user *arg)
Stefan> +{
Stefan> +	char buffer[256];
Stefan> +	int retval;
Stefan> +
Stefan> +	if (_IOC_TYPE(cmd) != '#' ||
Stefan> +	    _IOC_NR(cmd) >= ARRAY_SIZE(ioctl_handlers))
Stefan> +		return -EINVAL;
Stefan> +
Stefan> +	if (_IOC_DIR(cmd) & _IOC_WRITE) {
Stefan> +		if (_IOC_SIZE(cmd) > sizeof buffer ||
Stefan> +		    copy_from_user(buffer, arg, _IOC_SIZE(cmd)))
Stefan> +			return -EFAULT;
Stefan> +	}
Stefan> +
Stefan> +	retval = ioctl_handlers[_IOC_NR(cmd)](client, buffer);
Stefan> +	if (retval < 0)
Stefan> +		return retval;
Stefan> +
Stefan> +	if (_IOC_DIR(cmd) & _IOC_READ) {
Stefan> +		if (_IOC_SIZE(cmd) > sizeof buffer ||
Stefan> +		    copy_to_user(arg, buffer, _IOC_SIZE(cmd)))
Stefan> +			return -EFAULT;
Stefan> +	}
Stefan> +
Stefan> +	return 0;
Stefan> +}
Stefan> +
Stefan> +static long
Stefan> +fw_device_op_ioctl(struct file *file,
Stefan> +		   unsigned int cmd, unsigned long arg)
Stefan> +{
Stefan> +	struct client *client = file->private_data;
Stefan> +
Stefan> +	return dispatch_ioctl(client, cmd, (void __user *) arg);
Stefan> +}
Stefan> +
Stefan> +#ifdef CONFIG_COMPAT
Stefan> +static long
Stefan> +fw_device_op_compat_ioctl(struct file *file,
Stefan> +			  unsigned int cmd, unsigned long arg)
Stefan> +{
Stefan> +	struct client *client = file->private_data;
Stefan> +
Stefan> +	return dispatch_ioctl(client, cmd, compat_ptr(arg));
Stefan> +}
Stefan> +#endif
Stefan> +
Stefan> +static int fw_device_op_mmap(struct file *file, struct vm_area_struct *vma)
Stefan> +{
Stefan> +	struct client *client = file->private_data;
Stefan> +	enum dma_data_direction direction;
Stefan> +	unsigned long size;
Stefan> +	int page_count, retval;
Stefan> +
Stefan> +	/* FIXME: We could support multiple buffers, but we don't. */
Stefan> +	if (client->buffer.pages != NULL)
Stefan> +		return -EBUSY;
Stefan> +
Stefan> +	if (!(vma->vm_flags & VM_SHARED))
Stefan> +		return -EINVAL;
Stefan> +
Stefan> +	if (vma->vm_start & ~PAGE_MASK)
Stefan> +		return -EINVAL;
Stefan> +
Stefan> +	client->vm_start = vma->vm_start;
Stefan> +	size = vma->vm_end - vma->vm_start;
Stefan> +	page_count = size >> PAGE_SHIFT;
Stefan> +	if (size & ~PAGE_MASK)
Stefan> +		return -EINVAL;
Stefan> +
Stefan> +	if (vma->vm_flags & VM_WRITE)
Stefan> +		direction = DMA_TO_DEVICE;
Stefan> +	else
Stefan> +		direction = DMA_FROM_DEVICE;
Stefan> +
Stefan> +	retval = fw_iso_buffer_init(&client->buffer, client->device->card,
Stefan> +				    page_count, direction);
Stefan> +	if (retval < 0)
Stefan> +		return retval;
Stefan> +
Stefan> +	retval = fw_iso_buffer_map(&client->buffer, vma);
Stefan> +	if (retval < 0)
Stefan> +		fw_iso_buffer_destroy(&client->buffer, client->device->card);
Stefan> +
Stefan> +	return retval;
Stefan> +}
Stefan> +
Stefan> +static int fw_device_op_release(struct inode *inode, struct file *file)
Stefan> +{
Stefan> +	struct client *client = file->private_data;
Stefan> +	struct event *e, *next_e;
Stefan> +	struct client_resource *r, *next_r;
Stefan> +	unsigned long flags;
Stefan> +
Stefan> +	if (client->buffer.pages)
Stefan> +		fw_iso_buffer_destroy(&client->buffer, client->device->card);
Stefan> +
Stefan> +	if (client->iso_context)
Stefan> +		fw_iso_context_destroy(client->iso_context);
Stefan> +
Stefan> +	list_for_each_entry_safe(r, next_r, &client->resource_list, link)
Stefan> +		r->release(client, r);
Stefan> +
Stefan> +	/* FIXME: We should wait for the async tasklets to stop
Stefan> +	 * running before freeing the memory. */
Stefan> +
Stefan> +	list_for_each_entry_safe(e, next_e, &client->event_list, link)
Stefan> +		kfree(e);
Stefan> +
Stefan> +	spin_lock_irqsave(&client->device->card->lock, flags);
Stefan> +	list_del(&client->link);
Stefan> +	spin_unlock_irqrestore(&client->device->card->lock, flags);
Stefan> +
Stefan> +	fw_device_put(client->device);
Stefan> +	kfree(client);
Stefan> +
Stefan> +	return 0;
Stefan> +}
Stefan> +
Stefan> +static unsigned int fw_device_op_poll(struct file *file, poll_table * pt)
Stefan> +{
Stefan> +	struct client *client = file->private_data;
Stefan> +	unsigned int mask = 0;
Stefan> +
Stefan> +	poll_wait(file, &client->wait, pt);
Stefan> +
Stefan> +	if (fw_device_is_shutdown(client->device))
Stefan> +		mask |= POLLHUP | POLLERR;
Stefan> +	if (!list_empty(&client->event_list))
Stefan> +		mask |= POLLIN | POLLRDNORM;
Stefan> +
Stefan> +	return mask;
Stefan> +}
Stefan> +
Stefan> +const struct file_operations fw_device_ops = {
Stefan> +	.owner		= THIS_MODULE,
Stefan> +	.open		= fw_device_op_open,
Stefan> +	.read		= fw_device_op_read,
Stefan> +	.unlocked_ioctl	= fw_device_op_ioctl,
Stefan> +	.poll		= fw_device_op_poll,
Stefan> +	.release	= fw_device_op_release,
Stefan> +	.mmap		= fw_device_op_mmap,
Stefan> +
Stefan> +#ifdef CONFIG_COMPAT
Stefan> +	.compat_ioctl	= fw_device_op_compat_ioctl,
Stefan> +#endif
Stefan> +};

Stefan> -- 
Stefan> Stefan Richter
Stefan> -=====-=-=== -=-= ---=-
Stefan> http://arcgraph.de/sr/

Stefan> -
Stefan> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
Stefan> the body of a message to majordomo@vger.kernel.org
Stefan> More majordomo info at  http://vger.kernel.org/majordomo-info.html
Stefan> Please read the FAQ at  http://www.tux.org/lkml/


Stefan> !DSPAM:463882d8304681268012190!
