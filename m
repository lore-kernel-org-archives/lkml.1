Return-Path: <linux-kernel-owner+w=401wt.eu-S1764611AbYFFULu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764611AbYFFULu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2008 16:11:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758131AbYFFULl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Jun 2008 16:11:41 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:60562 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757983AbYFFULk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2008 16:11:40 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Fri, 6 Jun 2008 22:11:30 +0200 (CEST)
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: [PATCH] firewire: fill_bus_reset_event needs lock protection
To: linux1394-devel@lists.sourceforge.net
cc: linux-kernel@vger.kernel.org
Message-ID: <tkrat.c85eeaa74264184c@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=us-ascii
Content-Disposition: INLINE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Callers of fill_bus_reset_event() have to take card->lock.  Otherwise
access to node data may oops if node removal is in progress.

A lockless alternative would be

-	event->local_node_id = card->local_node->node_id;
+	tmp = fw_node_get(card->local_node);
+	event->local_node_id = tmp->node_id;
+	fw_node_put(tmp);

and ditto with the other node pointers which fill_bus_reset_event()
accesses.  But I went the locked route because one of the two callers
already holds the lock.  As a bonus, we don't need the memory barrier
anymore because device->generation and device->node_id are written in
a card->lock protected section.

Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
---
 drivers/firewire/fw-cdev.c |    9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

Index: linux/drivers/firewire/fw-cdev.c
===================================================================
--- linux.orig/drivers/firewire/fw-cdev.c
+++ linux/drivers/firewire/fw-cdev.c
@@ -205,6 +205,7 @@ fw_device_op_read(struct file *file,
 	return dequeue_event(client, buffer, count);
 }
 
+/* caller must hold card->lock so that node pointers can be dereferenced here */
 static void
 fill_bus_reset_event(struct fw_cdev_event_bus_reset *event,
 		     struct client *client)
@@ -214,7 +215,6 @@ fill_bus_reset_event(struct fw_cdev_even
 	event->closure	     = client->bus_reset_closure;
 	event->type          = FW_CDEV_EVENT_BUS_RESET;
 	event->generation    = client->device->generation;
-	smp_rmb();           /* node_id must not be older than generation */
 	event->node_id       = client->device->node_id;
 	event->local_node_id = card->local_node->node_id;
 	event->bm_node_id    = 0; /* FIXME: We don't track the BM. */
@@ -274,6 +274,7 @@ static int ioctl_get_info(struct client 
 {
 	struct fw_cdev_get_info *get_info = buffer;
 	struct fw_cdev_event_bus_reset bus_reset;
+	struct fw_card *card = client->device->card;
 	unsigned long ret = 0;
 
 	client->version = get_info->version;
@@ -299,13 +300,17 @@ static int ioctl_get_info(struct client 
 	client->bus_reset_closure = get_info->bus_reset_closure;
 	if (get_info->bus_reset != 0) {
 		void __user *uptr = u64_to_uptr(get_info->bus_reset);
+		unsigned long flags;
 
+		spin_lock_irqsave(&card->lock, flags);
 		fill_bus_reset_event(&bus_reset, client);
+		spin_unlock_irqrestore(&card->lock, flags);
+
 		if (copy_to_user(uptr, &bus_reset, sizeof(bus_reset)))
 			return -EFAULT;
 	}
 
-	get_info->card = client->device->card->index;
+	get_info->card = card->index;
 
 	return 0;
 }

-- 
Stefan Richter
-=====-==--- -==- --==-
http://arcgraph.de/sr/

