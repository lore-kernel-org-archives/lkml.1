Return-Path: <linux-kernel-owner+w=401wt.eu-S1756056AbZJGWmT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756056AbZJGWmT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Oct 2009 18:42:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756030AbZJGWmS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Oct 2009 18:42:18 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:44049 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755621AbZJGWmR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Oct 2009 18:42:17 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Thu, 8 Oct 2009 00:41:10 +0200 (CEST)
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: [PATCH 4/8] firewire: normalize style of queue_work wrappers
To: linux1394-devel@lists.sourceforge.net
cc: linux-kernel@vger.kernel.org
In-Reply-To: <tkrat.27888275592fd267@s5r6.in-berlin.de>
Message-ID: <tkrat.051a659dcb344ff2@s5r6.in-berlin.de>
References: <tkrat.27888275592fd267@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=us-ascii
Content-Disposition: INLINE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A few stylistic changes to unify some code patterns in the subsystem:

  - The similar queue_delayed_work helpers fw_schedule_bm_work,
    schedule_iso_resource, and sbp2_queue_work now have the same call
    convention.
  - Two conditional calls of schedule_iso_resource are factored into
    another small helper.
  - An sbp2_target_get helper is added as counterpart to
    sbp2_target_put.

Object size of firewire-core is decreased a little bit, object size of
firewire-sbp2 remains unchanged.

Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
---
 drivers/firewire/core-card.c |    5 +----
 drivers/firewire/core-cdev.c |   38 +++++++++++++++++-----------------
 drivers/firewire/sbp2.c      |    9 ++++++--
 3 files changed, 27 insertions(+), 25 deletions(-)

Index: linux-2.6.31/drivers/firewire/core-card.c
===================================================================
--- linux-2.6.31.orig/drivers/firewire/core-card.c
+++ linux-2.6.31/drivers/firewire/core-card.c
@@ -211,11 +211,8 @@ static const char gap_count_table[] = {
 
 void fw_schedule_bm_work(struct fw_card *card, unsigned long delay)
 {
-	int scheduled;
-
 	fw_card_get(card);
-	scheduled = schedule_delayed_work(&card->work, delay);
-	if (!scheduled)
+	if (!schedule_delayed_work(&card->work, delay))
 		fw_card_put(card);
 }
 
Index: linux-2.6.31/drivers/firewire/core-cdev.c
===================================================================
--- linux-2.6.31.orig/drivers/firewire/core-cdev.c
+++ linux-2.6.31/drivers/firewire/core-cdev.c
@@ -129,9 +129,22 @@ struct iso_resource {
 	struct iso_resource_event *e_alloc, *e_dealloc;
 };
 
-static void schedule_iso_resource(struct iso_resource *);
 static void release_iso_resource(struct client *, struct client_resource *);
 
+static void schedule_iso_resource(struct iso_resource *r, unsigned long delay)
+{
+	client_get(r->client);
+	if (!schedule_delayed_work(&r->work, delay))
+		client_put(r->client);
+}
+
+static void schedule_if_iso_resource(struct client_resource *resource)
+{
+	if (resource->release == release_iso_resource)
+		schedule_iso_resource(container_of(resource,
+					struct iso_resource, resource), 0);
+}
+
 /*
  * dequeue_event() just kfree()'s the event, so the event has to be
  * the first field in a struct XYZ_event.
@@ -313,11 +326,8 @@ static void for_each_client(struct fw_de
 
 static int schedule_reallocations(int id, void *p, void *data)
 {
-	struct client_resource *r = p;
+	schedule_if_iso_resource(p);
 
-	if (r->release == release_iso_resource)
-		schedule_iso_resource(container_of(r,
-					struct iso_resource, resource));
 	return 0;
 }
 
@@ -413,9 +423,7 @@ static int add_client_resource(struct cl
 				  &resource->handle);
 	if (ret >= 0) {
 		client_get(client);
-		if (resource->release == release_iso_resource)
-			schedule_iso_resource(container_of(resource,
-						struct iso_resource, resource));
+		schedule_if_iso_resource(resource);
 	}
 	spin_unlock_irqrestore(&client->lock, flags);
 
@@ -1032,8 +1040,7 @@ static void iso_resource_work(struct wor
 	/* Allow 1000ms grace period for other reallocations. */
 	if (todo == ISO_RES_ALLOC &&
 	    time_is_after_jiffies(client->device->card->reset_jiffies + HZ)) {
-		if (schedule_delayed_work(&r->work, DIV_ROUND_UP(HZ, 3)))
-			client_get(client);
+		schedule_iso_resource(r, DIV_ROUND_UP(HZ, 3));
 		skip = true;
 	} else {
 		/* We could be called twice within the same generation. */
@@ -1118,13 +1125,6 @@ static void iso_resource_work(struct wor
 	client_put(client);
 }
 
-static void schedule_iso_resource(struct iso_resource *r)
-{
-	client_get(r->client);
-	if (!schedule_delayed_work(&r->work, 0))
-		client_put(r->client);
-}
-
 static void release_iso_resource(struct client *client,
 				 struct client_resource *resource)
 {
@@ -1133,7 +1133,7 @@ static void release_iso_resource(struct 
 
 	spin_lock_irq(&client->lock);
 	r->todo = ISO_RES_DEALLOC;
-	schedule_iso_resource(r);
+	schedule_iso_resource(r, 0);
 	spin_unlock_irq(&client->lock);
 }
 
@@ -1179,7 +1179,7 @@ static int init_iso_resource(struct clie
 	} else {
 		r->resource.release = NULL;
 		r->resource.handle = -1;
-		schedule_iso_resource(r);
+		schedule_iso_resource(r, 0);
 	}
 	request->handle = r->resource.handle;
 
Index: linux-2.6.31/drivers/firewire/sbp2.c
===================================================================
--- linux-2.6.31.orig/drivers/firewire/sbp2.c
+++ linux-2.6.31/drivers/firewire/sbp2.c
@@ -820,20 +820,25 @@ static void sbp2_release_target(struct k
 	fw_device_put(device);
 }
 
-static struct workqueue_struct *sbp2_wq;
+static void sbp2_target_get(struct sbp2_target *tgt)
+{
+	kref_get(&tgt->kref);
+}
 
 static void sbp2_target_put(struct sbp2_target *tgt)
 {
 	kref_put(&tgt->kref, sbp2_release_target);
 }
 
+static struct workqueue_struct *sbp2_wq;
+
 /*
  * Always get the target's kref when scheduling work on one its units.
  * Each workqueue job is responsible to call sbp2_target_put() upon return.
  */
 static void sbp2_queue_work(struct sbp2_logical_unit *lu, unsigned long delay)
 {
-	kref_get(&lu->tgt->kref);
+	sbp2_target_get(lu->tgt);
 	if (!queue_delayed_work(sbp2_wq, &lu->work, delay))
 		sbp2_target_put(lu->tgt);
 }

-- 
Stefan Richter
-=====-==--= =-=- -=---
http://arcgraph.de/sr/

