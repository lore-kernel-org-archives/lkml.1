Return-Path: <linux-kernel-owner+w=401wt.eu-S1753906AbZFFQhz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753906AbZFFQhz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Jun 2009 12:37:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752916AbZFFQhs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 6 Jun 2009 12:37:48 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:34809 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752535AbZFFQhr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Jun 2009 12:37:47 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Sat, 6 Jun 2009 18:37:25 +0200 (CEST)
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: [PATCH] firewire: core: prepare for non-core children of card devices
To: linux1394-devel@lists.sourceforge.net
cc: linux-kernel@vger.kernel.org
Message-ID: <tkrat.9d438980a14f6287@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=us-ascii
Content-Disposition: INLINE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The IP-over-1394 driver will add child devices beneath card devices
which are not of type fw_device.  Hence firewire-core's callbacks in
device_for_each_child() and device_find_child() need to check for the
device type now.

Initial version written by Jay Fenlason.

Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
---
 drivers/firewire/core-card.c   |    8 +-------
 drivers/firewire/core-device.c |   24 ++++++++++++++++++++----
 drivers/firewire/core.h        |    2 +-
 3 files changed, 22 insertions(+), 12 deletions(-)

Index: linux/drivers/firewire/core-device.c
===================================================================
--- linux.orig/drivers/firewire/core-device.c
+++ linux/drivers/firewire/core-device.c
@@ -59,7 +59,7 @@ int fw_csr_iterator_next(struct fw_csr_i
 }
 EXPORT_SYMBOL(fw_csr_iterator_next);
 
-static int is_fw_unit(struct device *dev);
+static bool is_fw_unit(struct device *dev);
 
 static int match_unit_directory(u32 *directory, u32 match_flags,
 				const struct ieee1394_device_id *id)
@@ -599,7 +599,7 @@ static struct device_type fw_unit_type =
 	.release	= fw_unit_release,
 };
 
-static int is_fw_unit(struct device *dev)
+static bool is_fw_unit(struct device *dev)
 {
 	return dev->type == &fw_unit_type;
 }
@@ -749,6 +749,11 @@ static struct device_type fw_device_type
 	.release = fw_device_release,
 };
 
+static bool is_fw_device(struct device *dev)
+{
+	return dev->type == &fw_device_type;
+}
+
 static int update_unit(struct device *dev, void *data)
 {
 	struct fw_unit *unit = fw_unit(dev);
@@ -785,6 +790,9 @@ static int lookup_existing_device(struct
 	struct fw_card *card = new->card;
 	int match = 0;
 
+	if (!is_fw_device(dev))
+		return 0;
+
 	down_read(&fw_device_rwsem); /* serialize config_rom access */
 	spin_lock_irq(&card->lock);  /* serialize node access */
 
@@ -824,7 +832,7 @@ static int lookup_existing_device(struct
 
 enum { BC_UNKNOWN = 0, BC_UNIMPLEMENTED, BC_IMPLEMENTED, };
 
-void fw_device_set_broadcast_channel(struct fw_device *device, int generation)
+static void set_broadcast_channel(struct fw_device *device, int generation)
 {
 	struct fw_card *card = device->card;
 	__be32 data;
@@ -860,6 +868,14 @@ void fw_device_set_broadcast_channel(str
 	}
 }
 
+int fw_device_set_broadcast_channel(struct device *dev, void *gen)
+{
+	if (is_fw_device(dev))
+		set_broadcast_channel(fw_device(dev), (long)gen);
+
+	return 0;
+}
+
 static void fw_device_init(struct work_struct *work)
 {
 	struct fw_device *device =
@@ -958,7 +974,7 @@ static void fw_device_init(struct work_s
 				  1 << device->max_speed);
 		device->config_rom_retries = 0;
 
-		fw_device_set_broadcast_channel(device, device->generation);
+		set_broadcast_channel(device, device->generation);
 	}
 
 	/*
Index: linux/drivers/firewire/core-card.c
===================================================================
--- linux.orig/drivers/firewire/core-card.c
+++ linux/drivers/firewire/core-card.c
@@ -190,12 +190,6 @@ void fw_core_remove_descriptor(struct fw
 	mutex_unlock(&card_mutex);
 }
 
-static int set_broadcast_channel(struct device *dev, void *data)
-{
-	fw_device_set_broadcast_channel(fw_device(dev), (long)data);
-	return 0;
-}
-
 static void allocate_broadcast_channel(struct fw_card *card, int generation)
 {
 	int channel, bandwidth = 0;
@@ -205,7 +199,7 @@ static void allocate_broadcast_channel(s
 	if (channel == 31) {
 		card->broadcast_channel_allocated = true;
 		device_for_each_child(card->device, (void *)(long)generation,
-				      set_broadcast_channel);
+				      fw_device_set_broadcast_channel);
 	}
 }
 
Index: linux/drivers/firewire/core.h
===================================================================
--- linux.orig/drivers/firewire/core.h
+++ linux/drivers/firewire/core.h
@@ -124,7 +124,7 @@ extern struct idr fw_device_idr;
 extern int fw_cdev_major;
 
 struct fw_device *fw_device_get_by_devt(dev_t devt);
-void fw_device_set_broadcast_channel(struct fw_device *device, int generation);
+int fw_device_set_broadcast_channel(struct device *dev, void *gen);
 void fw_node_event(struct fw_card *card, struct fw_node *node, int event);
 
 

-- 
Stefan Richter
-=====-==--= -==- --==-
http://arcgraph.de/sr/

