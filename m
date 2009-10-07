Return-Path: <linux-kernel-owner+w=401wt.eu-S1755844AbZJGWmk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755844AbZJGWmk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Oct 2009 18:42:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754561AbZJGWmj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Oct 2009 18:42:39 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:44053 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754454AbZJGWmi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Oct 2009 18:42:38 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Thu, 8 Oct 2009 00:41:38 +0200 (CEST)
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: [PATCH 5/8] firewire: cdev: normalize variable names
To: linux1394-devel@lists.sourceforge.net
cc: linux-kernel@vger.kernel.org
In-Reply-To: <tkrat.27888275592fd267@s5r6.in-berlin.de>
Message-ID: <tkrat.0d59759692c3c264@s5r6.in-berlin.de>
References: <tkrat.27888275592fd267@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=us-ascii
Content-Disposition: INLINE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Unify some names:
  - "e" for pointers to subtypes of struct event,
  - "event" for struct members and pointers to struct event,
  - "r" for pointers to subtypes of struct client_resource,
  - "resource" for struct members and pointers to struct client_resource,
  - other names for struct members and pointers to other types.

Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
---
 drivers/firewire/core-cdev.c |   46 +++++++++++++++++-----------------
 1 file changed, 23 insertions(+), 23 deletions(-)

Index: linux-2.6.31/drivers/firewire/core-cdev.c
===================================================================
--- linux-2.6.31.orig/drivers/firewire/core-cdev.c
+++ linux-2.6.31/drivers/firewire/core-cdev.c
@@ -178,7 +178,7 @@ struct iso_interrupt_event {
 
 struct iso_resource_event {
 	struct event event;
-	struct fw_cdev_event_iso_resource resource;
+	struct fw_cdev_event_iso_resource iso_resource;
 };
 
 static inline void __user *u64_to_uptr(__u64 value)
@@ -435,26 +435,26 @@ static int add_client_resource(struct cl
 
 static int release_client_resource(struct client *client, u32 handle,
 				   client_resource_release_fn_t release,
-				   struct client_resource **resource)
+				   struct client_resource **return_resource)
 {
-	struct client_resource *r;
+	struct client_resource *resource;
 
 	spin_lock_irq(&client->lock);
 	if (client->in_shutdown)
-		r = NULL;
+		resource = NULL;
 	else
-		r = idr_find(&client->resource_idr, handle);
-	if (r && r->release == release)
+		resource = idr_find(&client->resource_idr, handle);
+	if (resource && resource->release == release)
 		idr_remove(&client->resource_idr, handle);
 	spin_unlock_irq(&client->lock);
 
-	if (!(r && r->release == release))
+	if (!(resource && resource->release == release))
 		return -EINVAL;
 
-	if (resource)
-		*resource = r;
+	if (return_resource)
+		*return_resource = resource;
 	else
-		r->release(client, r);
+		resource->release(client, resource);
 
 	client_put(client);
 
@@ -1108,12 +1108,12 @@ static void iso_resource_work(struct wor
 		e = r->e_dealloc;
 		r->e_dealloc = NULL;
 	}
-	e->resource.handle	= r->resource.handle;
-	e->resource.channel	= channel;
-	e->resource.bandwidth	= bandwidth;
+	e->iso_resource.handle    = r->resource.handle;
+	e->iso_resource.channel   = channel;
+	e->iso_resource.bandwidth = bandwidth;
 
 	queue_event(client, &e->event,
-		    &e->resource, sizeof(e->resource), NULL, 0);
+		    &e->iso_resource, sizeof(e->iso_resource), NULL, 0);
 
 	if (free) {
 		cancel_delayed_work(&r->work);
@@ -1166,10 +1166,10 @@ static int init_iso_resource(struct clie
 	r->e_alloc	= e1;
 	r->e_dealloc	= e2;
 
-	e1->resource.closure	= request->closure;
-	e1->resource.type	= FW_CDEV_EVENT_ISO_RESOURCE_ALLOCATED;
-	e2->resource.closure	= request->closure;
-	e2->resource.type	= FW_CDEV_EVENT_ISO_RESOURCE_DEALLOCATED;
+	e1->iso_resource.closure = request->closure;
+	e1->iso_resource.type    = FW_CDEV_EVENT_ISO_RESOURCE_ALLOCATED;
+	e2->iso_resource.closure = request->closure;
+	e2->iso_resource.type    = FW_CDEV_EVENT_ISO_RESOURCE_DEALLOCATED;
 
 	if (todo == ISO_RES_ALLOC) {
 		r->resource.release = release_iso_resource;
@@ -1413,10 +1413,10 @@ static int fw_device_op_mmap(struct file
 
 static int shutdown_resource(int id, void *p, void *data)
 {
-	struct client_resource *r = p;
+	struct client_resource *resource = p;
 	struct client *client = data;
 
-	r->release(client, r);
+	resource->release(client, resource);
 	client_put(client);
 
 	return 0;
@@ -1425,7 +1425,7 @@ static int shutdown_resource(int id, voi
 static int fw_device_op_release(struct inode *inode, struct file *file)
 {
 	struct client *client = file->private_data;
-	struct event *e, *next_e;
+	struct event *event, *next_event;
 
 	mutex_lock(&client->device->client_list_mutex);
 	list_del(&client->link);
@@ -1446,8 +1446,8 @@ static int fw_device_op_release(struct i
 	idr_remove_all(&client->resource_idr);
 	idr_destroy(&client->resource_idr);
 
-	list_for_each_entry_safe(e, next_e, &client->event_list, link)
-		kfree(e);
+	list_for_each_entry_safe(event, next_event, &client->event_list, link)
+		kfree(event);
 
 	client_put(client);
 

-- 
Stefan Richter
-=====-==--= =-=- -=---
http://arcgraph.de/sr/

