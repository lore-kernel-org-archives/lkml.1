Return-Path: <linux-kernel-owner+w=401wt.eu-S1761474AbZEMTmr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761474AbZEMTmr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 May 2009 15:42:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752669AbZEMTmi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 May 2009 15:42:38 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:39080 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752590AbZEMTmh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 May 2009 15:42:37 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Wed, 13 May 2009 21:42:14 +0200 (CEST)
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: [PATCH] firewire: core: improve check for local node
To: linux1394-devel@lists.sourceforge.net
cc: linux-kernel@vger.kernel.org
Message-ID: <tkrat.250cf8d21adf9e43@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=us-ascii
Content-Disposition: INLINE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

My recently added test for a device being local in fw-cdev.c got it
slightly wrong:  Comparisons of node IDs are only valid if the
generation is current, which I forgot to check.  Better would be a
direct comparison of fw_node pointers but this only works in a current
generation too.

The best way is to cache the property of being local in an fw_device
flag when the device is created.  This even makes the code more readable
and, so I'm told, will be good to have for an RFC-2734 driver too.

Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
---
 drivers/firewire/fw-cdev.c   |    6 +-----
 drivers/firewire/fw-device.c |    3 ++-
 drivers/firewire/fw-device.h |    1 +
 3 files changed, 4 insertions(+), 6 deletions(-)

Index: linux-2.6.30/drivers/firewire/fw-cdev.c
===================================================================
--- linux-2.6.30.orig/drivers/firewire/fw-cdev.c
+++ linux-2.6.30/drivers/firewire/fw-cdev.c
@@ -739,15 +739,11 @@ static void release_descriptor(struct cl
 static int ioctl_add_descriptor(struct client *client, void *buffer)
 {
 	struct fw_cdev_add_descriptor *request = buffer;
-	struct fw_card *card = client->device->card;
 	struct descriptor_resource *r;
 	int ret;
 
 	/* Access policy: Allow this ioctl only on local nodes' device files. */
-	spin_lock_irq(&card->lock);
-	ret = client->device->node_id != card->local_node->node_id;
-	spin_unlock_irq(&card->lock);
-	if (ret)
+	if (!client->device->is_local)
 		return -ENOSYS;
 
 	if (request->length > 256)
Index: linux-2.6.30/drivers/firewire/fw-device.c
===================================================================
--- linux-2.6.30.orig/drivers/firewire/fw-device.c
+++ linux-2.6.30/drivers/firewire/fw-device.c
@@ -1042,6 +1042,7 @@ void fw_node_event(struct fw_card *card,
 		device->node = fw_node_get(node);
 		device->node_id = node->node_id;
 		device->generation = card->generation;
+		device->is_local = node == card->local_node;
 		mutex_init(&device->client_list_mutex);
 		INIT_LIST_HEAD(&device->client_list);
 
@@ -1075,7 +1076,7 @@ void fw_node_event(struct fw_card *card,
 			    FW_DEVICE_INITIALIZING) == FW_DEVICE_RUNNING) {
 			PREPARE_DELAYED_WORK(&device->work, fw_device_refresh);
 			schedule_delayed_work(&device->work,
-				node == card->local_node ? 0 : INITIAL_DELAY);
+				device->is_local ? 0 : INITIAL_DELAY);
 		}
 		break;
 
Index: linux-2.6.30/drivers/firewire/fw-device.h
===================================================================
--- linux-2.6.30.orig/drivers/firewire/fw-device.h
+++ linux-2.6.30/drivers/firewire/fw-device.h
@@ -80,6 +80,7 @@ struct fw_device {
 	u32 *config_rom;
 	size_t config_rom_length;
 	int config_rom_retries;
+	unsigned is_local:1;
 	unsigned cmc:1;
 	unsigned bc_implemented:2;
 

-- 
Stefan Richter
-=====-==--= -=-= -==-=
http://arcgraph.de/sr/

