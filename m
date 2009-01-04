Return-Path: <linux-kernel-owner+w=401wt.eu-S1758767AbZADPbq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758767AbZADPbq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Jan 2009 10:31:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751953AbZADPbi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Jan 2009 10:31:38 -0500
Received: from einhorn.in-berlin.de ([192.109.42.8]:44123 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751643AbZADPbg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Jan 2009 10:31:36 -0500
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Sun, 4 Jan 2009 16:31:18 +0100 (CET)
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: [PATCH 11/11] firewire: cdev: replace some spin_lock_irqsave by
 spin_lock_irq
To: linux1394-devel@lists.sourceforge.net
cc: linux-kernel@vger.kernel.org
In-Reply-To: <tkrat.3905b2754a8fc519@s5r6.in-berlin.de>
Message-ID: <tkrat.42cc51e90e4f6ce2@s5r6.in-berlin.de>
References: <tkrat.3905b2754a8fc519@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=us-ascii
Content-Disposition: INLINE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

All of these functions are entered with IRQs enabled.
Hence the unconditional spin_unlock_irq can be used.

Function:                  Caller context:
    dequeue_event()            client process, via read(2)
    fill_bus_reset_event()     fw-device.c update worqueue job
    release_client_resource()  client process, via ioctl(2)
    fw_device_op_release()     client process, via close(2)

Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
---
 drivers/firewire/fw-cdev.c |   20 ++++++++------------
 1 file changed, 8 insertions(+), 12 deletions(-)

Index: linux/drivers/firewire/fw-cdev.c
===================================================================
--- linux.orig/drivers/firewire/fw-cdev.c
+++ linux/drivers/firewire/fw-cdev.c
@@ -237,7 +237,6 @@ static void queue_event(struct client *c
 static int dequeue_event(struct client *client,
 			 char __user *buffer, size_t count)
 {
-	unsigned long flags;
 	struct event *event;
 	size_t size, total;
 	int i, ret;
@@ -252,10 +251,10 @@ static int dequeue_event(struct client *
 		       fw_device_is_shutdown(client->device))
 		return -ENODEV;
 
-	spin_lock_irqsave(&client->lock, flags);
+	spin_lock_irq(&client->lock);
 	event = list_first_entry(&client->event_list, struct event, link);
 	list_del(&event->link);
-	spin_unlock_irqrestore(&client->lock, flags);
+	spin_unlock_irq(&client->lock);
 
 	total = 0;
 	for (i = 0; i < ARRAY_SIZE(event->v) && total < count; i++) {
@@ -286,9 +285,8 @@ static void fill_bus_reset_event(struct 
 				 struct client *client)
 {
 	struct fw_card *card = client->device->card;
-	unsigned long flags;
 
-	spin_lock_irqsave(&card->lock, flags);
+	spin_lock_irq(&card->lock);
 
 	event->closure	     = client->bus_reset_closure;
 	event->type          = FW_CDEV_EVENT_BUS_RESET;
@@ -299,7 +297,7 @@ static void fill_bus_reset_event(struct 
 	event->irm_node_id   = card->irm_node->node_id;
 	event->root_node_id  = card->root_node->node_id;
 
-	spin_unlock_irqrestore(&card->lock, flags);
+	spin_unlock_irq(&card->lock);
 }
 
 static void for_each_client(struct fw_device *device,
@@ -432,16 +430,15 @@ static int release_client_resource(struc
 				   struct client_resource **resource)
 {
 	struct client_resource *r;
-	unsigned long flags;
 
-	spin_lock_irqsave(&client->lock, flags);
+	spin_lock_irq(&client->lock);
 	if (client->in_shutdown)
 		r = NULL;
 	else
 		r = idr_find(&client->resource_idr, handle);
 	if (r && r->release == release)
 		idr_remove(&client->resource_idr, handle);
-	spin_unlock_irqrestore(&client->lock, flags);
+	spin_unlock_irq(&client->lock);
 
 	if (!(r && r->release == release))
 		return -EINVAL;
@@ -1384,7 +1381,6 @@ static int fw_device_op_release(struct i
 {
 	struct client *client = file->private_data;
 	struct event *e, *next_e;
-	unsigned long flags;
 
 	mutex_lock(&client->device->client_list_mutex);
 	list_del(&client->link);
@@ -1397,9 +1393,9 @@ static int fw_device_op_release(struct i
 		fw_iso_context_destroy(client->iso_context);
 
 	/* Freeze client->resource_idr and client->event_list */
-	spin_lock_irqsave(&client->lock, flags);
+	spin_lock_irq(&client->lock);
 	client->in_shutdown = true;
-	spin_unlock_irqrestore(&client->lock, flags);
+	spin_unlock_irq(&client->lock);
 
 	idr_for_each(&client->resource_idr, shutdown_resource, client);
 	idr_remove_all(&client->resource_idr);

-- 
Stefan Richter
-=====-==--= ---= --=--
http://arcgraph.de/sr/

