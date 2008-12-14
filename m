Return-Path: <linux-kernel-owner+w=401wt.eu-S1753842AbYLNSTx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753842AbYLNSTx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Dec 2008 13:19:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751120AbYLNSTp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 14 Dec 2008 13:19:45 -0500
Received: from einhorn.in-berlin.de ([192.109.42.8]:35758 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751046AbYLNSTp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Dec 2008 13:19:45 -0500
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Sun, 14 Dec 2008 19:19:23 +0100 (CET)
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: [PATCH 1/4] firewire: cdev: fix race of fw_device_op_release with bus
 reset
To: linux1394-devel@lists.sourceforge.net
cc: linux-kernel@vger.kernel.org, Jay Fenlason <fenlason@redhat.com>
In-Reply-To: <tkrat.7bf80e1dd5c90f36@s5r6.in-berlin.de>
Message-ID: <tkrat.48fd4e3f4e528775@s5r6.in-berlin.de>
References: <20081124163728.GA5826@redhat.com>
 <492AEED8.9030102@s5r6.in-berlin.de> <492AEF9D.5010307@s5r6.in-berlin.de>
 <tkrat.7bf80e1dd5c90f36@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=us-ascii
Content-Disposition: INLINE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Unlink the client from the fw_device earlier in order to prevent bus
reset events being added to client->event_list during shutdown.

Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
---
 drivers/firewire/fw-cdev.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

Index: linux/drivers/firewire/fw-cdev.c
===================================================================
--- linux.orig/drivers/firewire/fw-cdev.c
+++ linux/drivers/firewire/fw-cdev.c
@@ -1009,6 +1009,10 @@ static int fw_device_op_release(struct i
 	struct event *e, *next_e;
 	struct client_resource *r, *next_r;
 
+	mutex_lock(&client->device->client_list_mutex);
+	list_del(&client->link);
+	mutex_unlock(&client->device->client_list_mutex);
+
 	if (client->buffer.pages)
 		fw_iso_buffer_destroy(&client->buffer, client->device->card);
 
@@ -1026,10 +1030,6 @@ static int fw_device_op_release(struct i
 	list_for_each_entry_safe(e, next_e, &client->event_list, link)
 		kfree(e);
 
-	mutex_lock(&client->device->client_list_mutex);
-	list_del(&client->link);
-	mutex_unlock(&client->device->client_list_mutex);
-
 	fw_device_put(client->device);
 	kfree(client);
 


-- 
Stefan Richter
-=====-==--- ==-- -===-
http://arcgraph.de/sr/

