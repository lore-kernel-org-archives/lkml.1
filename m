Return-Path: <linux-kernel-owner+w=401wt.eu-S1752428AbZADP12@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752428AbZADP12 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Jan 2009 10:27:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751749AbZADP1S
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Jan 2009 10:27:18 -0500
Received: from einhorn.in-berlin.de ([192.109.42.8]:44051 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751329AbZADP1P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Jan 2009 10:27:15 -0500
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Sun, 4 Jan 2009 16:26:55 +0100 (CET)
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: [PATCH 05/11] firewire: cdev: add ioctls for isochronous resource
 management
To: linux1394-devel@lists.sourceforge.net
cc: linux-kernel@vger.kernel.org
In-Reply-To: <tkrat.3905b2754a8fc519@s5r6.in-berlin.de>
Message-ID: <tkrat.c425621dbf524825@s5r6.in-berlin.de>
References: <tkrat.3905b2754a8fc519@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=us-ascii
Content-Disposition: INLINE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Based on
    Date: Tue, 18 Nov 2008 11:41:27 -0500
    From: Jay Fenlason <fenlason@redhat.com>
    Subject: [Patch V4] Add ISO resource management support
with several changes to the ABI and implementation.  Only the part of
the ABI which enables auto-reallocation and auto-deallocation is
included here.

This implements ioctls for kernel-assisted allocation of isochronous
channels and isochronous bandwidth.  The benefits are:
  - The client does not have to have write access to the /dev/fw* device
    corresponding to the IRM.
  - The client does not have to perform reallocation after bus resets.
  - Channel and bandwidth are deallocated by the kernel if the file is
    closed before the client deallocated the resources.  Thus resources
    are released even if the client crashes.

It is anticipated that future in-kernel code (firewire-core IRM code;
the firewire port of firedtv), will use the fw-iso.c portions of this
code too.

Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
---
 drivers/firewire/fw-cdev.c        |  215 +++++++++++++++++++++++++++++-
 drivers/firewire/fw-iso.c         |  176 +++++++++++++++++++++++-
 drivers/firewire/fw-transaction.h |    4 
 include/linux/firewire-cdev.h     |  100 ++++++++++++-
 4 files changed, 475 insertions(+), 20 deletions(-)

Index: linux/include/linux/firewire-cdev.h
===================================================================
--- linux.orig/include/linux/firewire-cdev.h
+++ linux/include/linux/firewire-cdev.h
@@ -25,10 +25,12 @@
 #include <linux/types.h>
 #include <linux/firewire-constants.h>
 
-#define FW_CDEV_EVENT_BUS_RESET		0x00
-#define FW_CDEV_EVENT_RESPONSE		0x01
-#define FW_CDEV_EVENT_REQUEST		0x02
-#define FW_CDEV_EVENT_ISO_INTERRUPT	0x03
+#define FW_CDEV_EVENT_BUS_RESET			0x00
+#define FW_CDEV_EVENT_RESPONSE			0x01
+#define FW_CDEV_EVENT_REQUEST			0x02
+#define FW_CDEV_EVENT_ISO_INTERRUPT		0x03
+#define FW_CDEV_EVENT_ISO_RESOURCE_ALLOCATED	0x04
+#define FW_CDEV_EVENT_ISO_RESOURCE_DEALLOCATED	0x05
 
 /**
  * struct fw_cdev_event_common - Common part of all fw_cdev_event_ types
@@ -147,12 +149,46 @@ struct fw_cdev_event_iso_interrupt {
 };
 
 /**
+ * struct fw_cdev_event_iso_resource - Iso resources were allocated or freed
+ * @closure:	See &fw_cdev_event_common;
+ *		set by %FW_CDEV_IOC_ALLOCATE_ISO_RESOURCE ioctl
+ * @type:	%FW_CDEV_EVENT_ISO_RESOURCE_ALLOCATED or
+ *		%FW_CDEV_EVENT_ISO_RESOURCE_DEALLOCATED
+ * @handle:	Reference by which an allocated resource can be deallocated
+ * @channel:	Isochronous channel which was (de)allocated, if any
+ * @bandwidth:	Bandwidth allocation units which were (de)allocated, if any
+ * @channels_available:  Last known availability of channels
+ * @bandwidth_available: Last known availability of bandwidth
+ *
+ * An %FW_CDEV_EVENT_ISO_RESOURCE_ALLOCATED event is sent after an isochronous
+ * resource was allocated at the IRM.  The client has to check @channel and
+ * @bandwidth for whether the allocation actually succeeded.
+ *
+ * @channel is <0 if no channel was allocated.
+ * @bandwidth is 0 if no bandwidth was allocated.
+ *
+ * An %FW_CDEV_EVENT_ISO_RESOURCE_DEALLOCATED event is sent after an isochronous
+ * resource was deallocated at the IRM.  It is also sent when automatic
+ * reallocation after a bus reset failed.
+ */
+struct fw_cdev_event_iso_resource {
+	__u64 closure;
+	__u32 type;
+	__u32 handle;
+	__s32 channel;
+	__s32 bandwidth;
+};
+
+/**
  * union fw_cdev_event - Convenience union of fw_cdev_event_ types
  * @common:        Valid for all types
  * @bus_reset:     Valid if @common.type == %FW_CDEV_EVENT_BUS_RESET
  * @response:      Valid if @common.type == %FW_CDEV_EVENT_RESPONSE
  * @request:       Valid if @common.type == %FW_CDEV_EVENT_REQUEST
  * @iso_interrupt: Valid if @common.type == %FW_CDEV_EVENT_ISO_INTERRUPT
+ * @iso_resource:  Valid if @common.type ==
+ *				%FW_CDEV_EVENT_ISO_RESOURCE_ALLOCATED or
+ *				%FW_CDEV_EVENT_ISO_RESOURCE_DEALLOCATED
  *
  * Convenience union for userspace use.  Events could be read(2) into an
  * appropriately aligned char buffer and then cast to this union for further
@@ -163,13 +199,15 @@ struct fw_cdev_event_iso_interrupt {
  * not fit will be discarded so that the next read(2) will return a new event.
  */
 union fw_cdev_event {
-	struct fw_cdev_event_common common;
-	struct fw_cdev_event_bus_reset bus_reset;
-	struct fw_cdev_event_response response;
-	struct fw_cdev_event_request request;
-	struct fw_cdev_event_iso_interrupt iso_interrupt;
+	struct fw_cdev_event_common		common;
+	struct fw_cdev_event_bus_reset		bus_reset;
+	struct fw_cdev_event_response		response;
+	struct fw_cdev_event_request		request;
+	struct fw_cdev_event_iso_interrupt	iso_interrupt;
+	struct fw_cdev_event_iso_resource	iso_resource;
 };
 
+/* available since kernel version 2.6.22 */
 #define FW_CDEV_IOC_GET_INFO		_IOWR('#', 0x00, struct fw_cdev_get_info)
 #define FW_CDEV_IOC_SEND_REQUEST	_IOW('#', 0x01, struct fw_cdev_send_request)
 #define FW_CDEV_IOC_ALLOCATE		_IOWR('#', 0x02, struct fw_cdev_allocate)
@@ -178,13 +216,18 @@ union fw_cdev_event {
 #define FW_CDEV_IOC_INITIATE_BUS_RESET	_IOW('#', 0x05, struct fw_cdev_initiate_bus_reset)
 #define FW_CDEV_IOC_ADD_DESCRIPTOR	_IOWR('#', 0x06, struct fw_cdev_add_descriptor)
 #define FW_CDEV_IOC_REMOVE_DESCRIPTOR	_IOW('#', 0x07, struct fw_cdev_remove_descriptor)
-
 #define FW_CDEV_IOC_CREATE_ISO_CONTEXT	_IOWR('#', 0x08, struct fw_cdev_create_iso_context)
 #define FW_CDEV_IOC_QUEUE_ISO		_IOWR('#', 0x09, struct fw_cdev_queue_iso)
 #define FW_CDEV_IOC_START_ISO		_IOW('#', 0x0a, struct fw_cdev_start_iso)
 #define FW_CDEV_IOC_STOP_ISO		_IOW('#', 0x0b, struct fw_cdev_stop_iso)
+
+/* available since kernel version 2.6.24 */
 #define FW_CDEV_IOC_GET_CYCLE_TIMER	_IOR('#', 0x0c, struct fw_cdev_get_cycle_timer)
 
+/* available since kernel version 2.6.30 */
+#define FW_CDEV_IOC_ALLOCATE_ISO_RESOURCE   _IOWR('#', 0x0d, struct fw_cdev_allocate_iso_resource)
+#define FW_CDEV_IOC_DEALLOCATE_ISO_RESOURCE _IOW('#', 0x0e, struct fw_cdev_deallocate)
+
 /* FW_CDEV_VERSION History
  *
  * 1	Feb 18, 2007:  Initial version.
@@ -284,9 +327,9 @@ struct fw_cdev_allocate {
 };
 
 /**
- * struct fw_cdev_deallocate - Free an address range allocation
- * @handle:	Handle to the address range, as returned by the kernel when the
- *		range was allocated
+ * struct fw_cdev_deallocate - Free a CSR address range or isochronous resource
+ * @handle:	Handle to the address range or iso resource, as returned by the
+ *		kernel when the range or resource was allocated
  */
 struct fw_cdev_deallocate {
 	__u32 handle;
@@ -479,4 +522,35 @@ struct fw_cdev_get_cycle_timer {
 	__u32 cycle_timer;
 };
 
+/**
+ * struct fw_cdev_allocate_iso_resource - Allocate a channel or bandwidth
+ * @closure:	Passed back to userspace in correponding iso resource events
+ * @channels:	Isochronous channels of which one is to be allocated
+ * @bandwidth:	Isochronous bandwidth units to be allocated
+ * @handle:	Handle to the allocation, written by the kernel
+ *
+ * The %FW_CDEV_IOC_ALLOCATE_ISO_RESOURCE ioctl initiates allocation of an
+ * isochronous channel and/or of isochronous bandwidth at the isochronous
+ * resource manager (IRM).  Only one of the channels specified in @channels is
+ * allocated.  An %FW_CDEV_EVENT_ISO_RESOURCE_ALLOCATED is sent after
+ * communication with the IRM, indicating success or failure in the event data.
+ * The kernel will automatically reallocate the resources after bus resets.
+ * Should a reallocation fail, an %FW_CDEV_EVENT_ISO_RESOURCE_DEALLOCATED event
+ * will be sent.  The kernel will also automatically deallocate the resources
+ * when the file descriptor is closed.
+ *
+ * @channels is a host-endian bitfield with the most significant bit
+ * representing channel 0 and the least significant bit representing channel 63:
+ * 1ULL << (63 - c)
+ *
+ * @bandwidth is expressed in bandwidth allocation units, i.e. the time to send
+ * one quadlet of data (payload or header data) at speed S1600.
+ */
+struct fw_cdev_allocate_iso_resource {
+	__u64 closure;
+	__u64 channels;
+	__u32 bandwidth;
+	__u32 handle;
+};
+
 #endif /* _LINUX_FIREWIRE_CDEV_H */
Index: linux/drivers/firewire/fw-cdev.c
===================================================================
--- linux.orig/drivers/firewire/fw-cdev.c
+++ linux/drivers/firewire/fw-cdev.c
@@ -24,6 +24,7 @@
 #include <linux/errno.h>
 #include <linux/firewire-cdev.h>
 #include <linux/idr.h>
+#include <linux/jiffies.h>
 #include <linux/kernel.h>
 #include <linux/kref.h>
 #include <linux/mm.h>
@@ -35,6 +36,7 @@
 #include <linux/time.h>
 #include <linux/vmalloc.h>
 #include <linux/wait.h>
+#include <linux/workqueue.h>
 
 #include <asm/system.h>
 #include <asm/uaccess.h>
@@ -114,6 +116,21 @@ struct descriptor_resource {
 	u32 data[0];
 };
 
+struct iso_resource {
+	struct client_resource resource;
+	struct client *client;
+	/* Schedule work and access todo only with client->lock held. */
+	struct delayed_work work;
+	enum {ISO_RES_ALLOC, ISO_RES_REALLOC, ISO_RES_DEALLOC,} todo;
+	int generation;
+	u64 channels;
+	s32 bandwidth;
+	struct iso_resource_event *e_alloc, *e_dealloc;
+};
+
+static void schedule_iso_resource(struct iso_resource *);
+static void release_iso_resource(struct client *, struct client_resource *);
+
 /*
  * dequeue_event() just kfree()'s the event, so the event has to be
  * the first field in a struct XYZ_event.
@@ -145,6 +162,11 @@ struct iso_interrupt_event {
 	struct fw_cdev_event_iso_interrupt interrupt;
 };
 
+struct iso_resource_event {
+	struct event event;
+	struct fw_cdev_event_iso_resource resource;
+};
+
 static inline void __user *u64_to_uptr(__u64 value)
 {
 	return (void __user *)(unsigned long)value;
@@ -290,6 +312,16 @@ static void for_each_client(struct fw_de
 	mutex_unlock(&device->client_list_mutex);
 }
 
+static int schedule_reallocations(int id, void *p, void *data)
+{
+	struct client_resource *r = p;
+
+	if (r->release == release_iso_resource)
+		schedule_iso_resource(container_of(r,
+					struct iso_resource, resource));
+	return 0;
+}
+
 static void queue_bus_reset_event(struct client *client)
 {
 	struct bus_reset_event *e;
@@ -304,6 +336,10 @@ static void queue_bus_reset_event(struct
 
 	queue_event(client, &e->event,
 		    &e->reset, sizeof(e->reset), NULL, 0);
+
+	spin_lock_irq(&client->lock);
+	idr_for_each(&client->resource_idr, schedule_reallocations, client);
+	spin_unlock_irq(&client->lock);
 }
 
 void fw_device_cdev_update(struct fw_device *device)
@@ -376,8 +412,12 @@ static int add_client_resource(struct cl
 	else
 		ret = idr_get_new(&client->resource_idr, resource,
 				  &resource->handle);
-	if (ret >= 0)
+	if (ret >= 0) {
 		client_get(client);
+		if (resource->release == release_iso_resource)
+			schedule_iso_resource(container_of(resource,
+						struct iso_resource, resource));
+	}
 	spin_unlock_irqrestore(&client->lock, flags);
 
 	if (ret == -EAGAIN)
@@ -970,6 +1010,177 @@ static int ioctl_get_cycle_timer(struct 
 	return 0;
 }
 
+static void iso_resource_work(struct work_struct *work)
+{
+	struct iso_resource_event *e;
+	struct iso_resource *r =
+			container_of(work, struct iso_resource, work.work);
+	struct client *client = r->client;
+	int generation, channel, bandwidth, todo;
+	bool skip, free, success;
+
+	spin_lock_irq(&client->lock);
+	generation = client->device->generation;
+	todo = r->todo;
+	/* Allow 1000ms grace period for other reallocations. */
+	if (todo == ISO_RES_ALLOC &&
+	    time_is_after_jiffies(client->device->card->reset_jiffies + HZ)) {
+		if (schedule_delayed_work(&r->work, DIV_ROUND_UP(HZ, 3)))
+			client_get(client);
+		skip = true;
+	} else {
+		/* We could be called twice within the same generation. */
+		skip = todo == ISO_RES_REALLOC &&
+		       r->generation == generation;
+	}
+	free = todo == ISO_RES_DEALLOC;
+	r->generation = generation;
+	spin_unlock_irq(&client->lock);
+
+	if (skip)
+		goto out;
+
+	bandwidth = r->bandwidth;
+
+	fw_iso_resource_manage(client->device->card, generation,
+			r->channels, &channel, &bandwidth,
+			todo == ISO_RES_ALLOC || todo == ISO_RES_REALLOC);
+	/*
+	 * Is this generation outdated already?  As long as this resource sticks
+	 * in the idr, it will be scheduled again for a newer generation or at
+	 * shutdown.
+	 */
+	if (channel == -EAGAIN &&
+	    (todo == ISO_RES_ALLOC || todo == ISO_RES_REALLOC))
+		goto out;
+
+	success = channel >= 0 || bandwidth > 0;
+
+	spin_lock_irq(&client->lock);
+	/*
+	 * Transit from allocation to reallocation, except if the client
+	 * requested deallocation in the meantime.
+	 */
+	if (r->todo == ISO_RES_ALLOC)
+		r->todo = ISO_RES_REALLOC;
+	/*
+	 * Allocation or reallocation failure?  Pull this resource out of the
+	 * idr and prepare for deletion, unless the client is shutting down.
+	 */
+	if (r->todo == ISO_RES_REALLOC && !success &&
+	    !client->in_shutdown &&
+	    idr_find(&client->resource_idr, r->resource.handle)) {
+		idr_remove(&client->resource_idr, r->resource.handle);
+		client_put(client);
+		free = true;
+	}
+	spin_unlock_irq(&client->lock);
+
+	if (todo == ISO_RES_ALLOC && channel >= 0)
+		r->channels = 1ULL << (63 - channel);
+
+	if (todo == ISO_RES_REALLOC && success)
+		goto out;
+
+	if (todo == ISO_RES_ALLOC) {
+		e = r->e_alloc;
+		r->e_alloc = NULL;
+	} else {
+		e = r->e_dealloc;
+		r->e_dealloc = NULL;
+	}
+	e->resource.handle	= r->resource.handle;
+	e->resource.channel	= channel;
+	e->resource.bandwidth	= bandwidth;
+
+	queue_event(client, &e->event,
+		    &e->resource, sizeof(e->resource), NULL, 0);
+
+	if (free) {
+		cancel_delayed_work(&r->work);
+		kfree(r->e_alloc);
+		kfree(r->e_dealloc);
+		kfree(r);
+	}
+ out:
+	client_put(client);
+}
+
+static void schedule_iso_resource(struct iso_resource *r)
+{
+	if (schedule_delayed_work(&r->work, 0))
+		client_get(r->client);
+}
+
+static void release_iso_resource(struct client *client,
+				 struct client_resource *resource)
+{
+	struct iso_resource *r =
+		container_of(resource, struct iso_resource, resource);
+
+	spin_lock_irq(&client->lock);
+	r->todo = ISO_RES_DEALLOC;
+	schedule_iso_resource(r);
+	spin_unlock_irq(&client->lock);
+}
+
+static int ioctl_allocate_iso_resource(struct client *client, void *buffer)
+{
+	struct fw_cdev_allocate_iso_resource *request = buffer;
+	struct iso_resource_event *e1, *e2;
+	struct iso_resource *r;
+	int ret;
+
+	if ((request->channels == 0 && request->bandwidth == 0) ||
+	    request->bandwidth > BANDWIDTH_AVAILABLE_INITIAL ||
+	    request->bandwidth < 0)
+		return -EINVAL;
+
+	r  = kmalloc(sizeof(*r), GFP_KERNEL);
+	e1 = kmalloc(sizeof(*e1), GFP_KERNEL);
+	e2 = kmalloc(sizeof(*e2), GFP_KERNEL);
+	if (r == NULL || e1 == NULL || e2 == NULL) {
+		ret = -ENOMEM;
+		goto fail;
+	}
+
+	INIT_DELAYED_WORK(&r->work, iso_resource_work);
+	r->client	= client;
+	r->todo		= ISO_RES_ALLOC;
+	r->generation	= -1;
+	r->channels	= request->channels;
+	r->bandwidth	= request->bandwidth;
+	r->e_alloc	= e1;
+	r->e_dealloc	= e2;
+
+	e1->resource.closure	= request->closure;
+	e1->resource.type	= FW_CDEV_EVENT_ISO_RESOURCE_ALLOCATED;
+	e2->resource.closure	= request->closure;
+	e2->resource.type	= FW_CDEV_EVENT_ISO_RESOURCE_DEALLOCATED;
+
+	r->resource.release = release_iso_resource;
+	ret = add_client_resource(client, &r->resource, GFP_KERNEL);
+	if (ret < 0)
+		goto fail;
+	request->handle = r->resource.handle;
+
+	return 0;
+ fail:
+	kfree(r);
+	kfree(e1);
+	kfree(e2);
+
+	return ret;
+}
+
+static int ioctl_deallocate_iso_resource(struct client *client, void *buffer)
+{
+	struct fw_cdev_deallocate *request = buffer;
+
+	return release_client_resource(client, request->handle,
+				       release_iso_resource, NULL);
+}
+
 static int (* const ioctl_handlers[])(struct client *client, void *buffer) = {
 	ioctl_get_info,
 	ioctl_send_request,
@@ -984,6 +1195,8 @@ static int (* const ioctl_handlers[])(st
 	ioctl_start_iso,
 	ioctl_stop_iso,
 	ioctl_get_cycle_timer,
+	ioctl_allocate_iso_resource,
+	ioctl_deallocate_iso_resource,
 };
 
 static int dispatch_ioctl(struct client *client,
Index: linux/drivers/firewire/fw-iso.c
===================================================================
--- linux.orig/drivers/firewire/fw-iso.c
+++ linux/drivers/firewire/fw-iso.c
@@ -1,5 +1,7 @@
 /*
- * Isochronous IO functionality
+ * Isochronous I/O functionality:
+ *   - Isochronous DMA context management
+ *   - Isochronous bus resource management (channels, bandwidth), client side
  *
  * Copyright (C) 2006 Kristian Hoegsberg <krh@bitplanet.net>
  *
@@ -18,15 +20,20 @@
  * Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
  */
 
-#include <linux/kernel.h>
-#include <linux/module.h>
 #include <linux/dma-mapping.h>
-#include <linux/vmalloc.h>
+#include <linux/errno.h>
+#include <linux/firewire-constants.h>
+#include <linux/kernel.h>
 #include <linux/mm.h>
+#include <linux/spinlock.h>
+#include <linux/vmalloc.h>
 
-#include "fw-transaction.h"
 #include "fw-topology.h"
-#include "fw-device.h"
+#include "fw-transaction.h"
+
+/*
+ * Isochronous DMA context management
+ */
 
 int fw_iso_buffer_init(struct fw_iso_buffer *buffer, struct fw_card *card,
 		       int page_count, enum dma_data_direction direction)
@@ -153,3 +160,160 @@ int fw_iso_context_stop(struct fw_iso_co
 {
 	return ctx->card->driver->stop_iso(ctx);
 }
+
+/*
+ * Isochronous bus resource management (channels, bandwidth), client side
+ */
+
+static int manage_bandwidth(struct fw_card *card, int irm_id, int generation,
+			    int bandwidth, bool allocate)
+{
+	__be32 data[2];
+	int try, new, old = allocate ? BANDWIDTH_AVAILABLE_INITIAL : 0;
+
+	/*
+	 * On a 1394a IRM with low contention, try < 1 is enough.
+	 * On a 1394-1995 IRM, we need at least try < 2.
+	 * Let's just do try < 5.
+	 */
+	for (try = 0; try < 5; try++) {
+		new = allocate ? old - bandwidth : old + bandwidth;
+		if (new < 0 || new > BANDWIDTH_AVAILABLE_INITIAL)
+			break;
+
+		data[0] = cpu_to_be32(old);
+		data[1] = cpu_to_be32(new);
+		switch (fw_run_transaction(card, TCODE_LOCK_COMPARE_SWAP,
+				irm_id, generation, SCODE_100,
+				CSR_REGISTER_BASE + CSR_BANDWIDTH_AVAILABLE,
+				data, sizeof(data))) {
+		case RCODE_GENERATION:
+			/* A generation change frees all bandwidth. */
+			return allocate ? -EAGAIN : bandwidth;
+
+		case RCODE_COMPLETE:
+			if (be32_to_cpup(data) == old)
+				return bandwidth;
+
+			old = be32_to_cpup(data);
+			/* Fall through. */
+		}
+	}
+
+	return -EIO;
+}
+
+static int manage_channel(struct fw_card *card, int irm_id, int generation,
+			  __be32 channels_mask, u64 offset, bool allocate)
+{
+	__be32 data[2], c, old = allocate ? cpu_to_be32(~0) : 0;
+	int i, retry = 5;
+
+	for (i = 0; i < 32; i++) {
+		c = cpu_to_be32(1 << (31 - i));
+		if (!(channels_mask & c))
+			continue;
+
+		if (allocate == !(old & c))
+			continue;
+
+		data[0] = old;
+		data[1] = old ^ c;
+		switch (fw_run_transaction(card, TCODE_LOCK_COMPARE_SWAP,
+					   irm_id, generation, SCODE_100,
+					   offset, data, sizeof(data))) {
+		case RCODE_GENERATION:
+			/* A generation change frees all channels. */
+			return allocate ? -EAGAIN : i;
+
+		case RCODE_COMPLETE:
+			if (data[0] == old)
+				return i;
+
+			old = data[0];
+
+			/* Is the IRM 1394a-2000 compliant? */
+			if ((data[0] & c) != (data[1] & c))
+				continue;
+
+			/* 1394-1995 IRM, fall through to retry. */
+		default:
+			if (retry--)
+				i--;
+		}
+	}
+
+	return -EIO;
+}
+
+static void deallocate_channel(struct fw_card *card, int irm_id,
+			       int generation, int channel)
+{
+	__be32 mask;
+	u64 offset;
+
+	mask = channel < 32 ? cpu_to_be32(1 << (31 - channel)) :
+			      cpu_to_be32(1 << (63 - channel));
+	offset = channel < 32 ? CSR_REGISTER_BASE + CSR_CHANNELS_AVAILABLE_HI :
+				CSR_REGISTER_BASE + CSR_CHANNELS_AVAILABLE_LO;
+
+	manage_channel(card, irm_id, generation, mask, offset, false);
+}
+
+/**
+ * fw_iso_resource_manage - Allocate or deallocate a channel and/or bandwidth
+ *
+ * In parameters: card, generation, channels_mask, bandwidth, allocate
+ * Out parameters: channel, bandwidth
+ * This function blocks (sleeps) during communication with the IRM.
+ * Allocates or deallocates at most one channel out of channels_mask.
+ *
+ * Returns channel < 0 if no channel was allocated or deallocated.
+ * Returns bandwidth = 0 if no bandwidth was allocated or deallocated.
+ *
+ * If generation is stale, deallocations succeed but allocations fail with
+ * channel = -EAGAIN.
+ *
+ * If channel (de)allocation fails, bandwidth (de)allocation fails too.
+ * If bandwidth allocation fails, no channel will be allocated either.
+ * If bandwidth deallocation fails, channel deallocation may still have been
+ * successful.
+ */
+void fw_iso_resource_manage(struct fw_card *card, int generation,
+			    u64 channels_mask, int *channel, int *bandwidth,
+			    bool allocate)
+{
+	__be32 channels_hi = cpu_to_be32(channels_mask >> 32);
+	__be32 channels_lo = cpu_to_be32(channels_mask);
+	int irm_id, ret, c = -EINVAL;
+
+	spin_lock_irq(&card->lock);
+	irm_id = card->irm_node->node_id;
+	spin_unlock_irq(&card->lock);
+
+	if (channels_hi)
+		c = manage_channel(card, irm_id, generation, channels_hi,
+		    CSR_REGISTER_BASE + CSR_CHANNELS_AVAILABLE_HI, allocate);
+	if (channels_lo && c < 0) {
+		c = manage_channel(card, irm_id, generation, channels_lo,
+		    CSR_REGISTER_BASE + CSR_CHANNELS_AVAILABLE_LO, allocate);
+		if (c >= 0)
+			c += 32;
+	}
+	*channel = c;
+
+	if (channels_mask != 0 && c < 0)
+		*bandwidth = 0;
+
+	if (*bandwidth == 0)
+		return;
+
+	ret = manage_bandwidth(card, irm_id, generation, *bandwidth, allocate);
+	if (ret < 0)
+		*bandwidth = 0;
+
+	if (ret < 0 && c >= 0 && allocate) {
+		deallocate_channel(card, irm_id, generation, c);
+		*channel = ret;
+	}
+}
Index: linux/drivers/firewire/fw-transaction.h
===================================================================
--- linux.orig/drivers/firewire/fw-transaction.h
+++ linux/drivers/firewire/fw-transaction.h
@@ -82,6 +82,7 @@
 #define CSR_SPEED_MAP			0x2000
 #define CSR_SPEED_MAP_END		0x3000
 
+#define BANDWIDTH_AVAILABLE_INITIAL	4915
 #define BROADCAST_CHANNEL_INITIAL	(1 << 31 | 31)
 #define BROADCAST_CHANNEL_VALID		(1 << 30)
 
@@ -343,6 +344,9 @@ int fw_iso_context_start(struct fw_iso_c
 int fw_iso_context_stop(struct fw_iso_context *ctx);
 void fw_iso_context_destroy(struct fw_iso_context *ctx);
 
+void fw_iso_resource_manage(struct fw_card *card, int generation,
+		u64 channels_mask, int *channel, int *bandwidth, bool allocate);
+
 struct fw_card_driver {
 	/*
 	 * Enable the given card with the given initial config rom.

-- 
Stefan Richter
-=====-==--= ---= --=--
http://arcgraph.de/sr/

