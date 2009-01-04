Return-Path: <linux-kernel-owner+w=401wt.eu-S1758275AbZADP17@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758275AbZADP17 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Jan 2009 10:27:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752125AbZADP1t
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Jan 2009 10:27:49 -0500
Received: from einhorn.in-berlin.de ([192.109.42.8]:44053 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751643AbZADP1s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Jan 2009 10:27:48 -0500
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Sun, 4 Jan 2009 16:27:31 +0100 (CET)
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: [PATCH 06/11] firewire: cdev: add ioctls for manual iso resource
 management
To: linux1394-devel@lists.sourceforge.net
cc: linux-kernel@vger.kernel.org
In-Reply-To: <tkrat.3905b2754a8fc519@s5r6.in-berlin.de>
Message-ID: <tkrat.f364570373ba8da5@s5r6.in-berlin.de>
References: <tkrat.3905b2754a8fc519@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=us-ascii
Content-Disposition: INLINE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This adds ioctls for allocation and deallocation of a channel or/and
bandwidth without auto-reallocation and without auto-deallocation.

The benefit of these ioctls is that libraw1394-style isochronous
resource management can be implemented without write access to the IRM's
character device file.

Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
---
 drivers/firewire/fw-cdev.c    |   67 +++++++++++++++++++++++++++-------
 include/linux/firewire-cdev.h |   38 +++++++++++++++----
 2 files changed, 84 insertions(+), 21 deletions(-)

Index: linux/include/linux/firewire-cdev.h
===================================================================
--- linux.orig/include/linux/firewire-cdev.h
+++ linux/include/linux/firewire-cdev.h
@@ -151,7 +151,7 @@ struct fw_cdev_event_iso_interrupt {
 /**
  * struct fw_cdev_event_iso_resource - Iso resources were allocated or freed
  * @closure:	See &fw_cdev_event_common;
- *		set by %FW_CDEV_IOC_ALLOCATE_ISO_RESOURCE ioctl
+ *		set by %FW_CDEV_IOC_(DE)ALLOCATE_ISO_RESOURCE(_ONCE) ioctl
  * @type:	%FW_CDEV_EVENT_ISO_RESOURCE_ALLOCATED or
  *		%FW_CDEV_EVENT_ISO_RESOURCE_DEALLOCATED
  * @handle:	Reference by which an allocated resource can be deallocated
@@ -164,12 +164,12 @@ struct fw_cdev_event_iso_interrupt {
  * resource was allocated at the IRM.  The client has to check @channel and
  * @bandwidth for whether the allocation actually succeeded.
  *
- * @channel is <0 if no channel was allocated.
- * @bandwidth is 0 if no bandwidth was allocated.
- *
  * An %FW_CDEV_EVENT_ISO_RESOURCE_DEALLOCATED event is sent after an isochronous
  * resource was deallocated at the IRM.  It is also sent when automatic
  * reallocation after a bus reset failed.
+ *
+ * @channel is <0 if no channel was (de)allocated or if reallocation failed.
+ * @bandwidth is 0 if no bandwidth was (de)allocated or if reallocation failed.
  */
 struct fw_cdev_event_iso_resource {
 	__u64 closure;
@@ -227,6 +227,8 @@ union fw_cdev_event {
 /* available since kernel version 2.6.30 */
 #define FW_CDEV_IOC_ALLOCATE_ISO_RESOURCE   _IOWR('#', 0x0d, struct fw_cdev_allocate_iso_resource)
 #define FW_CDEV_IOC_DEALLOCATE_ISO_RESOURCE _IOW('#', 0x0e, struct fw_cdev_deallocate)
+#define FW_CDEV_IOC_ALLOCATE_ISO_RESOURCE_ONCE _IOW('#', 0x0f, struct fw_cdev_allocate_iso_resource)
+#define FW_CDEV_IOC_DEALLOCATE_ISO_RESOURCE_ONCE _IOW('#', 0x10, struct fw_cdev_allocate_iso_resource)
 
 /* FW_CDEV_VERSION History
  *
@@ -523,11 +525,12 @@ struct fw_cdev_get_cycle_timer {
 };
 
 /**
- * struct fw_cdev_allocate_iso_resource - Allocate a channel or bandwidth
+ * struct fw_cdev_allocate_iso_resource - (De)allocate a channel or bandwidth
  * @closure:	Passed back to userspace in correponding iso resource events
- * @channels:	Isochronous channels of which one is to be allocated
- * @bandwidth:	Isochronous bandwidth units to be allocated
- * @handle:	Handle to the allocation, written by the kernel
+ * @channels:	Isochronous channels of which one is to be (de)allocated
+ * @bandwidth:	Isochronous bandwidth units to be (de)allocated
+ * @handle:	Handle to the allocation, written by the kernel (only valid in
+ *		case of %FW_CDEV_IOC_ALLOCATE_ISO_RESOURCE ioctls)
  *
  * The %FW_CDEV_IOC_ALLOCATE_ISO_RESOURCE ioctl initiates allocation of an
  * isochronous channel and/or of isochronous bandwidth at the isochronous
@@ -539,6 +542,25 @@ struct fw_cdev_get_cycle_timer {
  * will be sent.  The kernel will also automatically deallocate the resources
  * when the file descriptor is closed.
  *
+ * The %FW_CDEV_IOC_DEALLOCATE_ISO_RESOURCE ioctl can be used to initiate
+ * deallocation of resources which were allocated as described above.
+ * An %FW_CDEV_EVENT_ISO_RESOURCE_DEALLOCATED event concludes this operation.
+ *
+ * The %FW_CDEV_IOC_ALLOCATE_ISO_RESOURCE_ONCE ioctl is a variant of allocation
+ * without automatic re- or deallocation.
+ * An %FW_CDEV_EVENT_ISO_RESOURCE_ALLOCATED event concludes this operation,
+ * indicating success or failure in its data.
+ *
+ * The %FW_CDEV_IOC_DEALLOCATE_ISO_RESOURCE_ONCE ioctl works like
+ * %FW_CDEV_IOC_ALLOCATE_ISO_RESOURCE_ONCE except that resources are freed
+ * instead of allocated.  At most one channel may be specified in this ioctl.
+ * An %FW_CDEV_EVENT_ISO_RESOURCE_DEALLOCATED event concludes this operation.
+ *
+ * To summarize, %FW_CDEV_IOC_DEALLOCATE_ISO_RESOURCE allocates iso resources
+ * for the lifetime of the fd or handle.
+ * In contrast, %FW_CDEV_IOC_ALLOCATE_ISO_RESOURCE_ONCE allocates iso resources
+ * for the duration of a bus generation.
+ *
  * @channels is a host-endian bitfield with the most significant bit
  * representing channel 0 and the least significant bit representing channel 63:
  * 1ULL << (63 - c)
Index: linux/drivers/firewire/fw-cdev.c
===================================================================
--- linux.orig/drivers/firewire/fw-cdev.c
+++ linux/drivers/firewire/fw-cdev.c
@@ -121,14 +121,15 @@ struct iso_resource {
 	struct client *client;
 	/* Schedule work and access todo only with client->lock held. */
 	struct delayed_work work;
-	enum {ISO_RES_ALLOC, ISO_RES_REALLOC, ISO_RES_DEALLOC,} todo;
+	enum {ISO_RES_ALLOC, ISO_RES_REALLOC, ISO_RES_DEALLOC,
+	      ISO_RES_ALLOC_ONCE, ISO_RES_DEALLOC_ONCE,} todo;
 	int generation;
 	u64 channels;
 	s32 bandwidth;
 	struct iso_resource_event *e_alloc, *e_dealloc;
 };
 
-static void schedule_iso_resource(struct iso_resource *);
+static int schedule_iso_resource(struct iso_resource *);
 static void release_iso_resource(struct client *, struct client_resource *);
 
 /*
@@ -1033,7 +1034,9 @@ static void iso_resource_work(struct wor
 		skip = todo == ISO_RES_REALLOC &&
 		       r->generation == generation;
 	}
-	free = todo == ISO_RES_DEALLOC;
+	free = todo == ISO_RES_DEALLOC ||
+	       todo == ISO_RES_ALLOC_ONCE ||
+	       todo == ISO_RES_DEALLOC_ONCE;
 	r->generation = generation;
 	spin_unlock_irq(&client->lock);
 
@@ -1044,7 +1047,9 @@ static void iso_resource_work(struct wor
 
 	fw_iso_resource_manage(client->device->card, generation,
 			r->channels, &channel, &bandwidth,
-			todo == ISO_RES_ALLOC || todo == ISO_RES_REALLOC);
+			todo == ISO_RES_ALLOC ||
+			todo == ISO_RES_REALLOC ||
+			todo == ISO_RES_ALLOC_ONCE);
 	/*
 	 * Is this generation outdated already?  As long as this resource sticks
 	 * in the idr, it will be scheduled again for a newer generation or at
@@ -1082,7 +1087,7 @@ static void iso_resource_work(struct wor
 	if (todo == ISO_RES_REALLOC && success)
 		goto out;
 
-	if (todo == ISO_RES_ALLOC) {
+	if (todo == ISO_RES_ALLOC || todo == ISO_RES_ALLOC_ONCE) {
 		e = r->e_alloc;
 		r->e_alloc = NULL;
 	} else {
@@ -1106,10 +1111,17 @@ static void iso_resource_work(struct wor
 	client_put(client);
 }
 
-static void schedule_iso_resource(struct iso_resource *r)
+static int schedule_iso_resource(struct iso_resource *r)
 {
-	if (schedule_delayed_work(&r->work, 0))
-		client_get(r->client);
+	int scheduled;
+
+	client_get(r->client);
+
+	scheduled = schedule_delayed_work(&r->work, 0);
+	if (!scheduled)
+		client_put(r->client);
+
+	return scheduled;
 }
 
 static void release_iso_resource(struct client *client,
@@ -1124,9 +1136,9 @@ static void release_iso_resource(struct 
 	spin_unlock_irq(&client->lock);
 }
 
-static int ioctl_allocate_iso_resource(struct client *client, void *buffer)
+static int init_iso_resource(struct client *client,
+		struct fw_cdev_allocate_iso_resource *request, int todo)
 {
-	struct fw_cdev_allocate_iso_resource *request = buffer;
 	struct iso_resource_event *e1, *e2;
 	struct iso_resource *r;
 	int ret;
@@ -1146,7 +1158,7 @@ static int ioctl_allocate_iso_resource(s
 
 	INIT_DELAYED_WORK(&r->work, iso_resource_work);
 	r->client	= client;
-	r->todo		= ISO_RES_ALLOC;
+	r->todo		= todo;
 	r->generation	= -1;
 	r->channels	= request->channels;
 	r->bandwidth	= request->bandwidth;
@@ -1158,8 +1170,14 @@ static int ioctl_allocate_iso_resource(s
 	e2->resource.closure	= request->closure;
 	e2->resource.type	= FW_CDEV_EVENT_ISO_RESOURCE_DEALLOCATED;
 
-	r->resource.release = release_iso_resource;
-	ret = add_client_resource(client, &r->resource, GFP_KERNEL);
+	if (todo == ISO_RES_ALLOC) {
+		r->resource.release = release_iso_resource;
+		ret = add_client_resource(client, &r->resource, GFP_KERNEL);
+	} else {
+		r->resource.release = NULL;
+		r->resource.handle = -1;
+		ret = schedule_iso_resource(r) ? 0 : -ENOMEM;
+	}
 	if (ret < 0)
 		goto fail;
 	request->handle = r->resource.handle;
@@ -1173,6 +1191,13 @@ static int ioctl_allocate_iso_resource(s
 	return ret;
 }
 
+static int ioctl_allocate_iso_resource(struct client *client, void *buffer)
+{
+	struct fw_cdev_allocate_iso_resource *request = buffer;
+
+	return init_iso_resource(client, request, ISO_RES_ALLOC);
+}
+
 static int ioctl_deallocate_iso_resource(struct client *client, void *buffer)
 {
 	struct fw_cdev_deallocate *request = buffer;
@@ -1181,6 +1206,20 @@ static int ioctl_deallocate_iso_resource
 				       release_iso_resource, NULL);
 }
 
+static int ioctl_allocate_iso_resource_once(struct client *client, void *buffer)
+{
+	struct fw_cdev_allocate_iso_resource *request = buffer;
+
+	return init_iso_resource(client, request, ISO_RES_ALLOC_ONCE);
+}
+
+static int ioctl_deallocate_iso_resource_once(struct client *client, void *buffer)
+{
+	struct fw_cdev_allocate_iso_resource *request = buffer;
+
+	return init_iso_resource(client, request, ISO_RES_DEALLOC_ONCE);
+}
+
 static int (* const ioctl_handlers[])(struct client *client, void *buffer) = {
 	ioctl_get_info,
 	ioctl_send_request,
@@ -1197,6 +1236,8 @@ static int (* const ioctl_handlers[])(st
 	ioctl_get_cycle_timer,
 	ioctl_allocate_iso_resource,
 	ioctl_deallocate_iso_resource,
+	ioctl_allocate_iso_resource_once,
+	ioctl_deallocate_iso_resource_once,
 };
 
 static int dispatch_ioctl(struct client *client,

-- 
Stefan Richter
-=====-==--= ---= --=--
http://arcgraph.de/sr/

