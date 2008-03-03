Return-Path: <linux-kernel-owner+w=401wt.eu-S1758063AbYCCAuU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758063AbYCCAuU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Mar 2008 19:50:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751563AbYCCAuI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Mar 2008 19:50:08 -0500
Received: from einhorn.in-berlin.de ([192.109.42.8]:49748 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751287AbYCCAuG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Mar 2008 19:50:06 -0500
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Mon, 3 Mar 2008 01:48:30 +0100 (CET)
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: [PATCH] firewire: reread config ROM when device reset the bus
To: linux1394-devel@lists.sourceforge.net
cc: linux-kernel@vger.kernel.org
In-Reply-To: <tkrat.c6610a8633fe0e41@s5r6.in-berlin.de>
Message-ID: <tkrat.da30e6f15a74e036@s5r6.in-berlin.de>
References: <tkrat.c6610a8633fe0e41@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=us-ascii
Content-Disposition: INLINE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When a device changes its configuration ROM, it announces this with a
bus reset.  firewire-core has to check which node initiated a bus reset
and whether any unit directories went away or were added on this node.

Tested with an IOI FWB-IDE01AB which has its link-on bit set if bus
power is available but does not respond to ROM read requests if self
power is off.  This implements
  - recognition of the units if self power is switched on after fw-core
    gave up the initial attempt to read the config ROM,
  - shutdown of the units when self power is switched off.

Also tested with a second PC running Linux/ieee1394.  When the eth1394
driver is inserted and removed on that node, fw-core now notices the
addition and removal of the IPv4 unit on the ieee1394 node.

Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
---

Applies after "firewire: replace static ROM cache by allocated cache".

 drivers/firewire/fw-cdev.c     |   18 ++--
 drivers/firewire/fw-device.c   |  147 ++++++++++++++++++++++++++++++---
 drivers/firewire/fw-topology.c |    3 
 drivers/firewire/fw-topology.h |   11 +-
 4 files changed, 158 insertions(+), 21 deletions(-)

Index: linux/drivers/firewire/fw-cdev.c
===================================================================
--- linux.orig/drivers/firewire/fw-cdev.c
+++ linux/drivers/firewire/fw-cdev.c
@@ -32,6 +32,7 @@
 #include <linux/idr.h>
 #include <linux/compat.h>
 #include <linux/firewire-cdev.h>
+#include <asm/semaphore.h>
 #include <asm/system.h>
 #include <asm/uaccess.h>
 #include "fw-transaction.h"
@@ -269,20 +270,25 @@ static int ioctl_get_info(struct client 
 {
 	struct fw_cdev_get_info *get_info = buffer;
 	struct fw_cdev_event_bus_reset bus_reset;
+	struct fw_device *device = client->device;
+	unsigned long ret = 0;
 
 	client->version = get_info->version;
 	get_info->version = FW_CDEV_VERSION;
 
+	down(&device->device.sem);
 	if (get_info->rom != 0) {
 		void __user *uptr = u64_to_uptr(get_info->rom);
 		size_t want = get_info->rom_length;
-		size_t have = client->device->config_rom_length * 4;
+		size_t have;
 
-		if (copy_to_user(uptr, client->device->config_rom,
-				 min(want, have)))
-			return -EFAULT;
+		have = device->config_rom_length * 4;
+		ret = copy_to_user(uptr, device->config_rom, min(want, have));
 	}
-	get_info->rom_length = client->device->config_rom_length * 4;
+	get_info->rom_length = device->config_rom_length * 4;
+	up(&device->device.sem);
+	if (ret != 0)
+		return -EFAULT;
 
 	client->bus_reset_closure = get_info->bus_reset_closure;
 	if (get_info->bus_reset != 0) {
@@ -293,7 +299,7 @@ static int ioctl_get_info(struct client 
 			return -EFAULT;
 	}
 
-	get_info->card = client->device->card->index;
+	get_info->card = device->card->index;
 
 	return 0;
 }
Index: linux/drivers/firewire/fw-device.c
===================================================================
--- linux.orig/drivers/firewire/fw-device.c
+++ linux/drivers/firewire/fw-device.c
@@ -26,6 +26,7 @@
 #include <linux/delay.h>
 #include <linux/idr.h>
 #include <linux/rwsem.h>
+#include <linux/string.h>
 #include <asm/semaphore.h>
 #include <asm/system.h>
 #include <linux/ctype.h>
@@ -160,9 +161,9 @@ static void fw_device_release(struct dev
 	 * Take the card lock so we don't set this to NULL while a
 	 * FW_NODE_UPDATED callback is being handled.
 	 */
-	spin_lock_irqsave(&device->card->lock, flags);
+	spin_lock_irqsave(&card->lock, flags);
 	device->node->data = NULL;
-	spin_unlock_irqrestore(&device->card->lock, flags);
+	spin_unlock_irqrestore(&card->lock, flags);
 
 	fw_node_put(device->node);
 	kfree(device->config_rom);
@@ -337,10 +338,14 @@ static ssize_t
 config_rom_show(struct device *dev, struct device_attribute *attr, char *buf)
 {
 	struct fw_device *device = fw_device(dev);
+	size_t length;
 
-	memcpy(buf, device->config_rom, device->config_rom_length * 4);
+	down(&dev->sem);
+	length = device->config_rom_length * 4;
+	memcpy(buf, device->config_rom, length);
+	up(&dev->sem);
 
-	return device->config_rom_length * 4;
+	return length;
 }
 
 static ssize_t
@@ -412,7 +417,7 @@ read_rom(struct fw_device *device, int g
  */
 static int read_bus_info_block(struct fw_device *device, int generation)
 {
-	u32 *rom, *stack;
+	u32 *rom, *stack, *old_rom, *new_rom;
 	u32 sp, key;
 	int i, end, length, ret = -1;
 
@@ -527,11 +532,18 @@ static int read_bus_info_block(struct fw
 			length = i;
 	}
 
-	device->config_rom = kmalloc(length * 4, GFP_KERNEL);
-	if (device->config_rom == NULL)
+	old_rom = device->config_rom;
+	new_rom = kmemdup(rom, length * 4, GFP_KERNEL);
+	if (new_rom == NULL)
 		goto out;
-	memcpy(device->config_rom, rom, length * 4);
+
+	/* serialize with readers via sysfs or ioctl */
+	down(&device->device.sem);
+	device->config_rom = new_rom;
 	device->config_rom_length = length;
+	up(&device->device.sem);
+
+	kfree(old_rom);
 	ret = 0;
  out:
 	kfree(rom);
@@ -724,7 +736,7 @@ static void fw_device_init(struct work_s
 	if (atomic_cmpxchg(&device->state,
 		    FW_DEVICE_INITIALIZING,
 		    FW_DEVICE_RUNNING) == FW_DEVICE_SHUTDOWN) {
-		fw_device_shutdown(&device->work.work);
+		fw_device_shutdown(work);
 	} else {
 		if (device->config_rom_retries)
 			fw_notify("created device %s: GUID %08x%08x, S%d00, "
@@ -738,6 +750,7 @@ static void fw_device_init(struct work_s
 				  device->device.bus_id,
 				  device->config_rom[3], device->config_rom[4],
 				  1 << device->max_speed);
+		device->config_rom_retries = 0;
 	}
 
 	/*
@@ -784,6 +797,104 @@ static void fw_device_update(struct work
 	device_for_each_child(&device->device, NULL, update_unit);
 }
 
+enum {
+	REREAD_BIB_ERROR,
+	REREAD_BIB_GONE,
+	REREAD_BIB_UNCHANGED,
+	REREAD_BIB_CHANGED,
+};
+
+/* Reread and compare bus info block and header of root directory */
+static int reread_bus_info_block(struct fw_device *device, int generation)
+{
+	u32 q;
+	int i;
+
+	for (i = 0; i < 6; i++) {
+		if (read_rom(device, generation, i, &q) != RCODE_COMPLETE)
+			return REREAD_BIB_ERROR;
+
+		if (i == 0 && q == 0)
+			return REREAD_BIB_GONE;
+
+		if (i > device->config_rom_length || q != device->config_rom[i])
+			return REREAD_BIB_CHANGED;
+	}
+
+	return REREAD_BIB_UNCHANGED;
+}
+
+static void fw_device_refresh(struct work_struct *work)
+{
+	struct fw_device *device =
+		container_of(work, struct fw_device, work.work);
+	struct fw_card *card = device->card;
+	int node_id = device->node_id;
+
+	switch (reread_bus_info_block(device, device->generation)) {
+	case REREAD_BIB_ERROR:
+		if (device->config_rom_retries < MAX_RETRIES / 2 &&
+		    atomic_read(&device->state) == FW_DEVICE_INITIALIZING) {
+			device->config_rom_retries++;
+			schedule_delayed_work(&device->work, RETRY_DELAY / 2);
+
+			return;
+		}
+		goto give_up;
+
+	case REREAD_BIB_GONE:
+		goto gone;
+
+	case REREAD_BIB_UNCHANGED:
+		if (atomic_cmpxchg(&device->state,
+			    FW_DEVICE_INITIALIZING,
+			    FW_DEVICE_RUNNING) == FW_DEVICE_SHUTDOWN)
+			goto gone;
+
+		fw_device_update(work);
+		device->config_rom_retries = 0;
+
+		return;
+	}
+
+	/*
+	 * Something changed.  We keep things simple and don't investigate
+	 * further.  We just destroy all previous units and create new ones.
+	 */
+	device_for_each_child(&device->device, NULL, shutdown_unit);
+
+	if (read_bus_info_block(device, device->generation) < 0) {
+		if (device->config_rom_retries < MAX_RETRIES &&
+		    atomic_read(&device->state) == FW_DEVICE_INITIALIZING) {
+			device->config_rom_retries++;
+			schedule_delayed_work(&device->work, RETRY_DELAY);
+
+			return;
+		}
+		goto give_up;
+	}
+
+	create_units(device);
+
+	if (atomic_cmpxchg(&device->state,
+		    FW_DEVICE_INITIALIZING,
+		    FW_DEVICE_RUNNING) == FW_DEVICE_SHUTDOWN)
+		goto gone;
+
+	fw_notify("refreshed device %s\n", device->device.bus_id);
+	device->config_rom_retries = 0;
+	goto out;
+
+ give_up:
+	fw_notify("giving up on refresh of device %s\n", device->device.bus_id);
+ gone:
+	atomic_set(&device->state, FW_DEVICE_SHUTDOWN);
+	fw_device_shutdown(work);
+ out:
+	if (node_id == card->root_node->node_id)
+		schedule_delayed_work(&card->work, 0);
+}
+
 void fw_node_event(struct fw_card *card, struct fw_node *node, int event)
 {
 	struct fw_device *device;
@@ -793,7 +904,7 @@ void fw_node_event(struct fw_card *card,
 	case FW_NODE_LINK_ON:
 		if (!node->link_on)
 			break;
-
+ create:
 		device = kzalloc(sizeof(*device), GFP_ATOMIC);
 		if (device == NULL)
 			break;
@@ -832,6 +943,22 @@ void fw_node_event(struct fw_card *card,
 		schedule_delayed_work(&device->work, INITIAL_DELAY);
 		break;
 
+	case FW_NODE_INITIATED_RESET:
+		device = node->data;
+		if (device == NULL)
+			goto create;
+
+		device->node_id = node->node_id;
+		smp_wmb();  /* update node_id before generation */
+		device->generation = card->generation;
+		if (atomic_cmpxchg(&device->state,
+			    FW_DEVICE_RUNNING,
+			    FW_DEVICE_INITIALIZING) == FW_DEVICE_RUNNING) {
+			PREPARE_DELAYED_WORK(&device->work, fw_device_refresh);
+			schedule_delayed_work(&device->work, INITIAL_DELAY);
+		}
+		break;
+
 	case FW_NODE_UPDATED:
 		if (!node->link_on || node->data == NULL)
 			break;
Index: linux/drivers/firewire/fw-topology.c
===================================================================
--- linux.orig/drivers/firewire/fw-topology.c
+++ linux/drivers/firewire/fw-topology.c
@@ -107,6 +107,7 @@ static struct fw_node *fw_node_create(u3
 	node->node_id = LOCAL_BUS | SELF_ID_PHY_ID(sid);
 	node->link_on = SELF_ID_LINK_ON(sid);
 	node->phy_speed = SELF_ID_PHY_SPEED(sid);
+	node->initiated_reset = SELF_ID_PHY_INITIATOR(sid);
 	node->port_count = port_count;
 
 	atomic_set(&node->ref_count, 1);
@@ -430,6 +431,8 @@ update_tree(struct fw_card *card, struct
 			event = FW_NODE_LINK_OFF;
 		else if (!node0->link_on && node1->link_on)
 			event = FW_NODE_LINK_ON;
+		else if (node1->initiated_reset && node1->link_on)
+			event = FW_NODE_INITIATED_RESET;
 		else
 			event = FW_NODE_UPDATED;
 
Index: linux/drivers/firewire/fw-topology.h
===================================================================
--- linux.orig/drivers/firewire/fw-topology.h
+++ linux/drivers/firewire/fw-topology.h
@@ -20,11 +20,12 @@
 #define __fw_topology_h
 
 enum {
-	FW_NODE_CREATED =   0x00,
-	FW_NODE_UPDATED =   0x01,
-	FW_NODE_DESTROYED = 0x02,
-	FW_NODE_LINK_ON =   0x03,
-	FW_NODE_LINK_OFF =  0x04,
+	FW_NODE_CREATED,
+	FW_NODE_UPDATED,
+	FW_NODE_DESTROYED,
+	FW_NODE_LINK_ON,
+	FW_NODE_LINK_OFF,
+	FW_NODE_INITIATED_RESET,
 };
 
 struct fw_node {

-- 
Stefan Richter
-=====-==--- --== ---==
http://arcgraph.de/sr/

