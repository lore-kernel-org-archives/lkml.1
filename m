Return-Path: <linux-kernel-owner+w=401wt.eu-S1763327AbYCEAf4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763327AbYCEAf4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2008 19:35:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754564AbYCEAfq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Mar 2008 19:35:46 -0500
Received: from einhorn.in-berlin.de ([192.109.42.8]:32892 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754036AbYCEAfp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2008 19:35:45 -0500
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Wed, 5 Mar 2008 01:34:55 +0100 (CET)
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: [PATCH update] firewire: reread config ROM when device reset the bus
To: =?iso-8859-1?Q?Kristian_H=F8gsberg?= <krh@bitplanet.net>,
       Jarod Wilson <jwilson@redhat.com>
cc: linux1394-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
In-Reply-To: <59ad55d30803030817l6fce6716x2a97cc809b15b234@mail.gmail.com>
Message-ID: <tkrat.5eee3ebd5076fd4a@s5r6.in-berlin.de>
References: <tkrat.c6610a8633fe0e41@s5r6.in-berlin.de> 
 <tkrat.da30e6f15a74e036@s5r6.in-berlin.de>
 <59ad55d30803030817l6fce6716x2a97cc809b15b234@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=us-ascii
Content-Disposition: INLINE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Date: 
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: firewire: reread config ROM when device reset the bus

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

Update:
  - added explicit "case REREAD_BIB_CHANGED"
  - moved from dev->dem to idr_rwsem
  - extended note about semaphore protection of .config_rom and
    .config_rom_length
  - secure a few more places which access the config_rom...
    should have covered all of them now

 drivers/firewire/fw-card.c     |    2 
 drivers/firewire/fw-cdev.c     |   13 +
 drivers/firewire/fw-device.c   |  222 +++++++++++++++++++++++++++------
 drivers/firewire/fw-device.h   |   11 +
 drivers/firewire/fw-sbp2.c     |    8 -
 drivers/firewire/fw-topology.c |    3 
 drivers/firewire/fw-topology.h |   11 -
 7 files changed, 223 insertions(+), 47 deletions(-)

Index: linux/drivers/firewire/fw-card.c
===================================================================
--- linux.orig/drivers/firewire/fw-card.c
+++ linux/drivers/firewire/fw-card.c
@@ -331,7 +331,7 @@ fw_card_bm_work(struct work_struct *work
 		 */
 		spin_unlock_irqrestore(&card->lock, flags);
 		goto out;
-	} else if (root_device->config_rom[2] & BIB_CMC) {
+	} else if (root_device->cmc) {
 		/*
 		 * FIXME: I suppose we should set the cmstr bit in the
 		 * STATE_CLEAR register of this node, as described in
Index: linux/drivers/firewire/fw-cdev.c
===================================================================
--- linux.orig/drivers/firewire/fw-cdev.c
+++ linux/drivers/firewire/fw-cdev.c
@@ -269,21 +269,28 @@ static int ioctl_get_info(struct client 
 {
 	struct fw_cdev_get_info *get_info = buffer;
 	struct fw_cdev_event_bus_reset bus_reset;
+	unsigned long ret = 0;
 
 	client->version = get_info->version;
 	get_info->version = FW_CDEV_VERSION;
 
+	down_read(&fw_device_rwsem);
+
 	if (get_info->rom != 0) {
 		void __user *uptr = u64_to_uptr(get_info->rom);
 		size_t want = get_info->rom_length;
 		size_t have = client->device->config_rom_length * 4;
 
-		if (copy_to_user(uptr, client->device->config_rom,
-				 min(want, have)))
-			return -EFAULT;
+		ret = copy_to_user(uptr, client->device->config_rom,
+				   min(want, have));
 	}
 	get_info->rom_length = client->device->config_rom_length * 4;
 
+	up_read(&fw_device_rwsem);
+
+	if (ret != 0)
+		return -EFAULT;
+
 	client->bus_reset_closure = get_info->bus_reset_closure;
 	if (get_info->bus_reset != 0) {
 		void __user *uptr = u64_to_uptr(get_info->bus_reset);
Index: linux/drivers/firewire/fw-device.c
===================================================================
--- linux.orig/drivers/firewire/fw-device.c
+++ linux/drivers/firewire/fw-device.c
@@ -25,7 +25,7 @@
 #include <linux/device.h>
 #include <linux/delay.h>
 #include <linux/idr.h>
-#include <linux/rwsem.h>
+#include <linux/string.h>
 #include <asm/semaphore.h>
 #include <asm/system.h>
 #include <linux/ctype.h>
@@ -160,9 +160,9 @@ static void fw_device_release(struct dev
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
@@ -195,7 +195,9 @@ show_immediate(struct device *dev, struc
 		container_of(dattr, struct config_rom_attribute, attr);
 	struct fw_csr_iterator ci;
 	u32 *dir;
-	int key, value;
+	int key, value, ret = -ENOENT;
+
+	down_read(&fw_device_rwsem);
 
 	if (is_fw_unit(dev))
 		dir = fw_unit(dev)->directory;
@@ -204,11 +206,15 @@ show_immediate(struct device *dev, struc
 
 	fw_csr_iterator_init(&ci, dir);
 	while (fw_csr_iterator_next(&ci, &key, &value))
-		if (attr->key == key)
-			return snprintf(buf, buf ? PAGE_SIZE : 0,
-					"0x%06x\n", value);
+		if (attr->key == key) {
+			ret = snprintf(buf, buf ? PAGE_SIZE : 0,
+				       "0x%06x\n", value);
+			break;
+		}
+
+	up_read(&fw_device_rwsem);
 
-	return -ENOENT;
+	return ret;
 }
 
 #define IMMEDIATE_ATTR(name, key)				\
@@ -221,9 +227,11 @@ show_text_leaf(struct device *dev, struc
 		container_of(dattr, struct config_rom_attribute, attr);
 	struct fw_csr_iterator ci;
 	u32 *dir, *block = NULL, *p, *end;
-	int length, key, value, last_key = 0;
+	int length, key, value, last_key = 0, ret = -ENOENT;
 	char *b;
 
+	down_read(&fw_device_rwsem);
+
 	if (is_fw_unit(dev))
 		dir = fw_unit(dev)->directory;
 	else
@@ -238,18 +246,20 @@ show_text_leaf(struct device *dev, struc
 	}
 
 	if (block == NULL)
-		return -ENOENT;
+		goto out;
 
 	length = min(block[0] >> 16, 256U);
 	if (length < 3)
-		return -ENOENT;
+		goto out;
 
 	if (block[1] != 0 || block[2] != 0)
 		/* Unknown encoding. */
-		return -ENOENT;
+		goto out;
 
-	if (buf == NULL)
-		return length * 4;
+	if (buf == NULL) {
+		ret = length * 4;
+		goto out;
+	}
 
 	b = buf;
 	end = &block[length + 1];
@@ -259,8 +269,11 @@ show_text_leaf(struct device *dev, struc
 	/* Strip trailing whitespace and add newline. */
 	while (b--, (isspace(*b) || *b == '\0') && b > buf);
 	strcpy(b + 1, "\n");
+	ret = b + 2 - buf;
+ out:
+	up_read(&fw_device_rwsem);
 
-	return b + 2 - buf;
+	return ret;
 }
 
 #define TEXT_LEAF_ATTR(name, key)				\
@@ -337,19 +350,28 @@ static ssize_t
 config_rom_show(struct device *dev, struct device_attribute *attr, char *buf)
 {
 	struct fw_device *device = fw_device(dev);
+	size_t length;
 
-	memcpy(buf, device->config_rom, device->config_rom_length * 4);
+	down_read(&fw_device_rwsem);
+	length = device->config_rom_length * 4;
+	memcpy(buf, device->config_rom, length);
+	up_read(&fw_device_rwsem);
 
-	return device->config_rom_length * 4;
+	return length;
 }
 
 static ssize_t
 guid_show(struct device *dev, struct device_attribute *attr, char *buf)
 {
 	struct fw_device *device = fw_device(dev);
+	int ret;
 
-	return snprintf(buf, PAGE_SIZE, "0x%08x%08x\n",
-			device->config_rom[3], device->config_rom[4]);
+	down_read(&fw_device_rwsem);
+	ret = snprintf(buf, PAGE_SIZE, "0x%08x%08x\n",
+		       device->config_rom[3], device->config_rom[4]);
+	up_read(&fw_device_rwsem);
+
+	return ret;
 }
 
 static struct device_attribute fw_device_attributes[] = {
@@ -412,7 +434,7 @@ read_rom(struct fw_device *device, int g
  */
 static int read_bus_info_block(struct fw_device *device, int generation)
 {
-	u32 *rom, *stack;
+	u32 *rom, *stack, *old_rom, *new_rom;
 	u32 sp, key;
 	int i, end, length, ret = -1;
 
@@ -527,12 +549,19 @@ static int read_bus_info_block(struct fw
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
+	down_write(&fw_device_rwsem);
+	device->config_rom = new_rom;
 	device->config_rom_length = length;
+	up_write(&fw_device_rwsem);
+
+	kfree(old_rom);
 	ret = 0;
+	device->cmc = rom[2] & 1 << 30;
  out:
 	kfree(rom);
 
@@ -605,7 +634,14 @@ static int shutdown_unit(struct device *
 	return 0;
 }
 
-static DECLARE_RWSEM(idr_rwsem);
+/*
+ * fw_device_rwsem acts as dual purpose mutex:
+ *   - serializes accesses to fw_device_idr,
+ *   - serializes accesses to fw_device.config_rom/.config_rom_length and
+ *     fw_unit.directory, unless those accesses happen at safe occasions
+ */
+DECLARE_RWSEM(fw_device_rwsem);
+
 static DEFINE_IDR(fw_device_idr);
 int fw_cdev_major;
 
@@ -613,11 +649,11 @@ struct fw_device *fw_device_get_by_devt(
 {
 	struct fw_device *device;
 
-	down_read(&idr_rwsem);
+	down_read(&fw_device_rwsem);
 	device = idr_find(&fw_device_idr, MINOR(devt));
 	if (device)
 		fw_device_get(device);
-	up_read(&idr_rwsem);
+	up_read(&fw_device_rwsem);
 
 	return device;
 }
@@ -632,9 +668,9 @@ static void fw_device_shutdown(struct wo
 	device_for_each_child(&device->device, NULL, shutdown_unit);
 	device_unregister(&device->device);
 
-	down_write(&idr_rwsem);
+	down_write(&fw_device_rwsem);
 	idr_remove(&fw_device_idr, minor);
-	up_write(&idr_rwsem);
+	up_write(&fw_device_rwsem);
 	fw_device_put(device);
 }
 
@@ -687,10 +723,10 @@ static void fw_device_init(struct work_s
 	err = -ENOMEM;
 
 	fw_device_get(device);
-	down_write(&idr_rwsem);
+	down_write(&fw_device_rwsem);
 	if (idr_pre_get(&fw_device_idr, GFP_KERNEL))
 		err = idr_get_new(&fw_device_idr, device, &minor);
-	up_write(&idr_rwsem);
+	up_write(&fw_device_rwsem);
 
 	if (err < 0)
 		goto error;
@@ -724,7 +760,7 @@ static void fw_device_init(struct work_s
 	if (atomic_cmpxchg(&device->state,
 		    FW_DEVICE_INITIALIZING,
 		    FW_DEVICE_RUNNING) == FW_DEVICE_SHUTDOWN) {
-		fw_device_shutdown(&device->work.work);
+		fw_device_shutdown(work);
 	} else {
 		if (device->config_rom_retries)
 			fw_notify("created device %s: GUID %08x%08x, S%d00, "
@@ -738,6 +774,7 @@ static void fw_device_init(struct work_s
 				  device->device.bus_id,
 				  device->config_rom[3], device->config_rom[4],
 				  1 << device->max_speed);
+		device->config_rom_retries = 0;
 	}
 
 	/*
@@ -752,9 +789,9 @@ static void fw_device_init(struct work_s
 	return;
 
  error_with_cdev:
-	down_write(&idr_rwsem);
+	down_write(&fw_device_rwsem);
 	idr_remove(&fw_device_idr, minor);
-	up_write(&idr_rwsem);
+	up_write(&fw_device_rwsem);
  error:
 	fw_device_put(device);		/* fw_device_idr's reference */
 
@@ -784,6 +821,107 @@ static void fw_device_update(struct work
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
+
+	case REREAD_BIB_CHANGED:
+		break;
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
@@ -793,7 +931,7 @@ void fw_node_event(struct fw_card *card,
 	case FW_NODE_LINK_ON:
 		if (!node->link_on)
 			break;
-
+ create:
 		device = kzalloc(sizeof(*device), GFP_ATOMIC);
 		if (device == NULL)
 			break;
@@ -832,6 +970,22 @@ void fw_node_event(struct fw_card *card,
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
Index: linux/drivers/firewire/fw-device.h
===================================================================
--- linux.orig/drivers/firewire/fw-device.h
+++ linux/drivers/firewire/fw-device.h
@@ -21,6 +21,7 @@
 
 #include <linux/fs.h>
 #include <linux/cdev.h>
+#include <linux/rwsem.h>
 #include <asm/atomic.h>
 
 enum fw_device_state {
@@ -46,6 +47,11 @@ struct fw_attribute_group {
  * fw_device.node_id is guaranteed to be current too.
  *
  * The same applies to fw_device.card->node_id vs. fw_device.generation.
+ *
+ * fw_device.config_rom and fw_device.config_rom_length may be accessed during
+ * the lifetime of any fw_unit belonging to the fw_device, before device_del()
+ * was called on the last fw_unit.  Alternatively, they may be accessed while
+ * holding fw_device_rwsem.
  */
 struct fw_device {
 	atomic_t state;
@@ -53,6 +59,7 @@ struct fw_device {
 	int node_id;
 	int generation;
 	unsigned max_speed;
+	bool cmc;
 	struct fw_card *card;
 	struct device device;
 	struct list_head link;
@@ -92,8 +99,12 @@ int fw_device_enable_phys_dma(struct fw_
 void fw_device_cdev_update(struct fw_device *device);
 void fw_device_cdev_remove(struct fw_device *device);
 
+extern struct rw_semaphore fw_device_rwsem;
 extern int fw_cdev_major;
 
+/*
+ * fw_unit.directory must not be accessed after device_del(&fw_unit.device).
+ */
 struct fw_unit {
 	struct device device;
 	u32 *directory;
Index: linux/drivers/firewire/fw-sbp2.c
===================================================================
--- linux.orig/drivers/firewire/fw-sbp2.c
+++ linux/drivers/firewire/fw-sbp2.c
@@ -153,6 +153,7 @@ struct sbp2_target {
 	struct list_head lu_list;
 
 	u64 management_agent_address;
+	u64 guid;
 	int directory_id;
 	int node_id;
 	int address_high;
@@ -1070,6 +1071,7 @@ static int sbp2_probe(struct device *dev
 	kref_init(&tgt->kref);
 	INIT_LIST_HEAD(&tgt->lu_list);
 	tgt->bus_id = unit->device.bus_id;
+	tgt->guid = (u64)device->config_rom[3] << 32 | device->config_rom[4];
 
 	if (fw_device_enable_phys_dma(device) < 0)
 		goto fail_shost_put;
@@ -1527,16 +1529,14 @@ sbp2_sysfs_ieee1394_id_show(struct devic
 {
 	struct scsi_device *sdev = to_scsi_device(dev);
 	struct sbp2_logical_unit *lu;
-	struct fw_device *device;
 
 	if (!sdev)
 		return 0;
 
 	lu = sdev->hostdata;
-	device = fw_device(lu->tgt->unit->device.parent);
 
-	return sprintf(buf, "%08x%08x:%06x:%04x\n",
-			device->config_rom[3], device->config_rom[4],
+	return sprintf(buf, "%016llx:%06x:%04x\n",
+			(unsigned long long)lu->tgt->guid,
 			lu->tgt->directory_id, lu->lun);
 }
 
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
-=====-==--- --== --=-=
http://arcgraph.de/sr/

