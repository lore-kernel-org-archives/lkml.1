Return-Path: <linux-kernel-owner+w=401wt.eu-S1755675AbZFEOkj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755675AbZFEOkj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Jun 2009 10:40:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755063AbZFEOk0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Jun 2009 10:40:26 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:56384 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754717AbZFEOkW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Jun 2009 10:40:22 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Fri, 5 Jun 2009 16:39:58 +0200 (CEST)
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: [RFC patch 1/2] firewire: reorganize header files
To: linux1394-devel@lists.sourceforge.net
cc: linux-kernel@vger.kernel.org
Message-ID: <tkrat.b8d0b3fd0adbd091@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=us-ascii
Content-Disposition: INLINE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The three header files of firewire-core, i.e.
 "drivers/firewire/fw-device.h",
 "drivers/firewire/fw-topology.h",
 "drivers/firewire/fw-transaction.h",
are replaced by
 "drivers/firewire/core.h",
 "include/linux/firewire.h".

The latter includes everything which a firewire high-level driver (like
firewire-sbp2) needs besides linux/firewire-constants.h, while core.h
contains the rest which is needed by firewire-core itself and by low-
level drivers (card drivers) like firewire-ohci.

High-level drivers can now also reside outside of drivers/firewire
without having to add drivers/firewire to the header file search path in
makefiles.  At least the firedtv driver will be such a driver.

I also considered to spread the contents of core.h over several files,
one for each .c file where the respective implementation resides.  But
it turned out that most core .c files will end up including most of the
core .h files.  Also, the combined core.h isn't unreasonably big, and it
will lose more of its contents to linux/firewire.h anyway soon when more
firewire drivers are added.  (IP-over-1394, firedtv, and there are plans
for one or two more.)

Furthermore, fw-ohci.h is renamed to ohci.h.  The name of core.h and
ohci.h is chosen with regard to name changes of the .c files in a
follow-up change.

Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
---
 drivers/firewire/core.h                |  293 +++++++++++++++++++++
 drivers/firewire/fw-card.c             |    6 +-
 drivers/firewire/fw-cdev.c             |    5 +-
 drivers/firewire/fw-device.c           |    9 +-
 drivers/firewire/fw-device.h           |  190 --------------
 drivers/firewire/fw-iso.c              |    4 +-
 drivers/firewire/fw-ohci.c             |    5 +-
 drivers/firewire/fw-sbp2.c             |    4 +-
 drivers/firewire/fw-topology.c         |   10 +-
 drivers/firewire/fw-topology.h         |   77 ------
 drivers/firewire/fw-transaction.c      |    8 +-
 drivers/firewire/fw-transaction.h      |  446 --------------------------------
 drivers/firewire/{fw-ohci.h => ohci.h} |    6 +-
 include/linux/firewire.h               |  350 +++++++++++++++++++++++++
 14 files changed, 676 insertions(+), 737 deletions(-)
 create mode 100644 drivers/firewire/core.h
 delete mode 100644 drivers/firewire/fw-device.h
 delete mode 100644 drivers/firewire/fw-topology.h
 delete mode 100644 drivers/firewire/fw-transaction.h
 rename drivers/firewire/{fw-ohci.h => ohci.h} (98%)
 create mode 100644 include/linux/firewire.h

diff --git a/drivers/firewire/core.h b/drivers/firewire/core.h
new file mode 100644
index 0000000..273f0ab
--- /dev/null
+++ b/drivers/firewire/core.h
@@ -0,0 +1,293 @@
+#ifndef _FIREWIRE_CORE_H
+#define _FIREWIRE_CORE_H
+
+#include <linux/dma-mapping.h>
+#include <linux/fs.h>
+#include <linux/list.h>
+#include <linux/idr.h>
+#include <linux/mm_types.h>
+#include <linux/rwsem.h>
+#include <linux/slab.h>
+#include <linux/types.h>
+
+#include <asm/atomic.h>
+
+struct device;
+struct fw_card;
+struct fw_device;
+struct fw_iso_buffer;
+struct fw_iso_context;
+struct fw_iso_packet;
+struct fw_node;
+struct fw_packet;
+
+
+/* -card */
+
+/* bitfields within the PHY registers */
+#define PHY_LINK_ACTIVE		0x80
+#define PHY_CONTENDER		0x40
+#define PHY_BUS_RESET		0x40
+#define PHY_BUS_SHORT_RESET	0x40
+
+#define BANDWIDTH_AVAILABLE_INITIAL	4915
+#define BROADCAST_CHANNEL_INITIAL	(1 << 31 | 31)
+#define BROADCAST_CHANNEL_VALID		(1 << 30)
+
+struct fw_card_driver {
+	/*
+	 * Enable the given card with the given initial config rom.
+	 * This function is expected to activate the card, and either
+	 * enable the PHY or set the link_on bit and initiate a bus
+	 * reset.
+	 */
+	int (*enable)(struct fw_card *card, u32 *config_rom, size_t length);
+
+	int (*update_phy_reg)(struct fw_card *card, int address,
+			      int clear_bits, int set_bits);
+
+	/*
+	 * Update the config rom for an enabled card.  This function
+	 * should change the config rom that is presented on the bus
+	 * an initiate a bus reset.
+	 */
+	int (*set_config_rom)(struct fw_card *card,
+			      u32 *config_rom, size_t length);
+
+	void (*send_request)(struct fw_card *card, struct fw_packet *packet);
+	void (*send_response)(struct fw_card *card, struct fw_packet *packet);
+	/* Calling cancel is valid once a packet has been submitted. */
+	int (*cancel_packet)(struct fw_card *card, struct fw_packet *packet);
+
+	/*
+	 * Allow the specified node ID to do direct DMA out and in of
+	 * host memory.  The card will disable this for all node when
+	 * a bus reset happens, so driver need to reenable this after
+	 * bus reset.  Returns 0 on success, -ENODEV if the card
+	 * doesn't support this, -ESTALE if the generation doesn't
+	 * match.
+	 */
+	int (*enable_phys_dma)(struct fw_card *card,
+			       int node_id, int generation);
+
+	u64 (*get_bus_time)(struct fw_card *card);
+
+	struct fw_iso_context *
+	(*allocate_iso_context)(struct fw_card *card,
+				int type, int channel, size_t header_size);
+	void (*free_iso_context)(struct fw_iso_context *ctx);
+
+	int (*start_iso)(struct fw_iso_context *ctx,
+			 s32 cycle, u32 sync, u32 tags);
+
+	int (*queue_iso)(struct fw_iso_context *ctx,
+			 struct fw_iso_packet *packet,
+			 struct fw_iso_buffer *buffer,
+			 unsigned long payload);
+
+	int (*stop_iso)(struct fw_iso_context *ctx);
+};
+
+void fw_card_initialize(struct fw_card *card,
+		const struct fw_card_driver *driver, struct device *device);
+int fw_card_add(struct fw_card *card,
+		u32 max_receive, u32 link_speed, u64 guid);
+void fw_core_remove_card(struct fw_card *card);
+int fw_core_initiate_bus_reset(struct fw_card *card, int short_reset);
+int fw_compute_block_crc(u32 *block);
+void fw_schedule_bm_work(struct fw_card *card, unsigned long delay);
+
+struct fw_descriptor {
+	struct list_head link;
+	size_t length;
+	u32 immediate;
+	u32 key;
+	const u32 *data;
+};
+
+int fw_core_add_descriptor(struct fw_descriptor *desc);
+void fw_core_remove_descriptor(struct fw_descriptor *desc);
+
+
+/* -cdev */
+
+extern const struct file_operations fw_device_ops;
+
+void fw_device_cdev_update(struct fw_device *device);
+void fw_device_cdev_remove(struct fw_device *device);
+
+
+/* -device */
+
+extern struct rw_semaphore fw_device_rwsem;
+extern struct idr fw_device_idr;
+extern int fw_cdev_major;
+
+struct fw_device *fw_device_get_by_devt(dev_t devt);
+void fw_device_set_broadcast_channel(struct fw_device *device, int generation);
+void fw_node_event(struct fw_card *card, struct fw_node *node, int event);
+
+
+/* -iso */
+
+/*
+ * The iso packet format allows for an immediate header/payload part
+ * stored in 'header' immediately after the packet info plus an
+ * indirect payload part that is pointer to by the 'payload' field.
+ * Applications can use one or the other or both to implement simple
+ * low-bandwidth streaming (e.g. audio) or more advanced
+ * scatter-gather streaming (e.g. assembling video frame automatically).
+ */
+struct fw_iso_packet {
+	u16 payload_length;	/* Length of indirect payload. */
+	u32 interrupt:1;	/* Generate interrupt on this packet */
+	u32 skip:1;		/* Set to not send packet at all. */
+	u32 tag:2;
+	u32 sy:4;
+	u32 header_length:8;	/* Length of immediate header. */
+	u32 header[0];
+};
+
+#define FW_ISO_CONTEXT_TRANSMIT	0
+#define FW_ISO_CONTEXT_RECEIVE	1
+
+#define FW_ISO_CONTEXT_MATCH_TAG0	 1
+#define FW_ISO_CONTEXT_MATCH_TAG1	 2
+#define FW_ISO_CONTEXT_MATCH_TAG2	 4
+#define FW_ISO_CONTEXT_MATCH_TAG3	 8
+#define FW_ISO_CONTEXT_MATCH_ALL_TAGS	15
+
+/*
+ * An iso buffer is just a set of pages mapped for DMA in the
+ * specified direction.  Since the pages are to be used for DMA, they
+ * are not mapped into the kernel virtual address space.  We store the
+ * DMA address in the page private. The helper function
+ * fw_iso_buffer_map() will map the pages into a given vma.
+ */
+struct fw_iso_buffer {
+	enum dma_data_direction direction;
+	struct page **pages;
+	int page_count;
+};
+
+typedef void (*fw_iso_callback_t)(struct fw_iso_context *context,
+				  u32 cycle, size_t header_length,
+				  void *header, void *data);
+
+struct fw_iso_context {
+	struct fw_card *card;
+	int type;
+	int channel;
+	int speed;
+	size_t header_size;
+	fw_iso_callback_t callback;
+	void *callback_data;
+};
+
+int fw_iso_buffer_init(struct fw_iso_buffer *buffer, struct fw_card *card,
+		       int page_count, enum dma_data_direction direction);
+int fw_iso_buffer_map(struct fw_iso_buffer *buffer, struct vm_area_struct *vma);
+void fw_iso_buffer_destroy(struct fw_iso_buffer *buffer, struct fw_card *card);
+
+struct fw_iso_context *fw_iso_context_create(struct fw_card *card,
+		int type, int channel, int speed, size_t header_size,
+		fw_iso_callback_t callback, void *callback_data);
+int fw_iso_context_queue(struct fw_iso_context *ctx,
+			 struct fw_iso_packet *packet,
+			 struct fw_iso_buffer *buffer,
+			 unsigned long payload);
+int fw_iso_context_start(struct fw_iso_context *ctx,
+			 int cycle, int sync, int tags);
+int fw_iso_context_stop(struct fw_iso_context *ctx);
+void fw_iso_context_destroy(struct fw_iso_context *ctx);
+
+void fw_iso_resource_manage(struct fw_card *card, int generation,
+		u64 channels_mask, int *channel, int *bandwidth, bool allocate);
+
+
+/* -topology */
+
+enum {
+	FW_NODE_CREATED,
+	FW_NODE_UPDATED,
+	FW_NODE_DESTROYED,
+	FW_NODE_LINK_ON,
+	FW_NODE_LINK_OFF,
+	FW_NODE_INITIATED_RESET,
+};
+
+struct fw_node {
+	u16 node_id;
+	u8 color;
+	u8 port_count;
+	u8 link_on:1;
+	u8 initiated_reset:1;
+	u8 b_path:1;
+	u8 phy_speed:2;	/* As in the self ID packet. */
+	u8 max_speed:2;	/* Minimum of all phy-speeds on the path from the
+			 * local node to this node. */
+	u8 max_depth:4;	/* Maximum depth to any leaf node */
+	u8 max_hops:4;	/* Max hops in this sub tree */
+	atomic_t ref_count;
+
+	/* For serializing node topology into a list. */
+	struct list_head link;
+
+	/* Upper layer specific data. */
+	void *data;
+
+	struct fw_node *ports[0];
+};
+
+static inline struct fw_node *fw_node_get(struct fw_node *node)
+{
+	atomic_inc(&node->ref_count);
+
+	return node;
+}
+
+static inline void fw_node_put(struct fw_node *node)
+{
+	if (atomic_dec_and_test(&node->ref_count))
+		kfree(node);
+}
+
+void fw_core_handle_bus_reset(struct fw_card *card, int node_id,
+			      int generation, int self_id_count, u32 *self_ids);
+void fw_destroy_nodes(struct fw_card *card);
+
+/*
+ * Check whether new_generation is the immediate successor of old_generation.
+ * Take counter roll-over at 255 (as per OHCI) into account.
+ */
+static inline bool is_next_generation(int new_generation, int old_generation)
+{
+	return (new_generation & 0xff) == ((old_generation + 1) & 0xff);
+}
+
+
+/* -transaction */
+
+#define TCODE_IS_READ_REQUEST(tcode)	(((tcode) & ~1) == 4)
+#define TCODE_IS_BLOCK_PACKET(tcode)	(((tcode) &  1) != 0)
+#define TCODE_IS_REQUEST(tcode)		(((tcode) &  2) == 0)
+#define TCODE_IS_RESPONSE(tcode)	(((tcode) &  2) != 0)
+#define TCODE_HAS_REQUEST_DATA(tcode)	(((tcode) & 12) != 4)
+#define TCODE_HAS_RESPONSE_DATA(tcode)	(((tcode) & 12) != 0)
+
+#define LOCAL_BUS 0xffc0
+
+void fw_core_handle_request(struct fw_card *card, struct fw_packet *request);
+void fw_core_handle_response(struct fw_card *card, struct fw_packet *packet);
+void fw_fill_response(struct fw_packet *response, u32 *request_header,
+		      int rcode, void *payload, size_t length);
+void fw_flush_transactions(struct fw_card *card);
+void fw_send_phy_config(struct fw_card *card,
+			int node_id, int generation, int gap_count);
+
+static inline int fw_stream_packet_destination_id(int tag, int channel, int sy)
+{
+	return tag << 14 | channel << 8 | sy;
+}
+
+#endif /* _FIREWIRE_CORE_H */
diff --git a/drivers/firewire/fw-card.c b/drivers/firewire/fw-card.c
index b6f55e2..ba6cd70 100644
--- a/drivers/firewire/fw-card.c
+++ b/drivers/firewire/fw-card.c
@@ -21,6 +21,8 @@
 #include <linux/crc-itu-t.h>
 #include <linux/device.h>
 #include <linux/errno.h>
+#include <linux/firewire.h>
+#include <linux/firewire-constants.h>
 #include <linux/jiffies.h>
 #include <linux/kernel.h>
 #include <linux/kref.h>
@@ -34,9 +36,7 @@
 #include <asm/atomic.h>
 #include <asm/byteorder.h>
 
-#include "fw-device.h"
-#include "fw-topology.h"
-#include "fw-transaction.h"
+#include "core.h"
 
 int fw_compute_block_crc(u32 *block)
 {
diff --git a/drivers/firewire/fw-cdev.c b/drivers/firewire/fw-cdev.c
index 8a5e6ae..042c045 100644
--- a/drivers/firewire/fw-cdev.c
+++ b/drivers/firewire/fw-cdev.c
@@ -22,6 +22,7 @@
 #include <linux/delay.h>
 #include <linux/device.h>
 #include <linux/errno.h>
+#include <linux/firewire.h>
 #include <linux/firewire-cdev.h>
 #include <linux/idr.h>
 #include <linux/jiffies.h>
@@ -41,9 +42,7 @@
 #include <asm/system.h>
 #include <asm/uaccess.h>
 
-#include "fw-device.h"
-#include "fw-topology.h"
-#include "fw-transaction.h"
+#include "core.h"
 
 struct client {
 	u32 version;
diff --git a/drivers/firewire/fw-device.c b/drivers/firewire/fw-device.c
index 238acac..65d84dd 100644
--- a/drivers/firewire/fw-device.c
+++ b/drivers/firewire/fw-device.c
@@ -22,6 +22,8 @@
 #include <linux/delay.h>
 #include <linux/device.h>
 #include <linux/errno.h>
+#include <linux/firewire.h>
+#include <linux/firewire-constants.h>
 #include <linux/idr.h>
 #include <linux/jiffies.h>
 #include <linux/kobject.h>
@@ -39,9 +41,7 @@
 #include <asm/byteorder.h>
 #include <asm/system.h>
 
-#include "fw-device.h"
-#include "fw-topology.h"
-#include "fw-transaction.h"
+#include "core.h"
 
 void fw_csr_iterator_init(struct fw_csr_iterator *ci, u32 * p)
 {
@@ -94,8 +94,9 @@ static int fw_unit_match(struct device *dev, struct device_driver *drv)
 		return 0;
 
 	device = fw_device(unit->device.parent);
+	id = container_of(drv, struct fw_driver, driver)->id_table;
 
-	for (id = fw_driver(drv)->id_table; id->match_flags != 0; id++) {
+	for (; id->match_flags != 0; id++) {
 		if (match_unit_directory(unit->directory, id->match_flags, id))
 			return 1;
 
diff --git a/drivers/firewire/fw-device.h b/drivers/firewire/fw-device.h
deleted file mode 100644
index e973c43..0000000
--- a/drivers/firewire/fw-device.h
+++ /dev/null
@@ -1,190 +0,0 @@
-/*
- * Copyright (C) 2005-2006  Kristian Hoegsberg <krh@bitplanet.net>
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License as published by
- * the Free Software Foundation; either version 2 of the License, or
- * (at your option) any later version.
- *
- * This program is distributed in the hope that it will be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- * GNU General Public License for more details.
- *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software Foundation,
- * Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
- */
-
-#ifndef __fw_device_h
-#define __fw_device_h
-
-#include <linux/device.h>
-#include <linux/fs.h>
-#include <linux/idr.h>
-#include <linux/kernel.h>
-#include <linux/list.h>
-#include <linux/mod_devicetable.h>
-#include <linux/mutex.h>
-#include <linux/rwsem.h>
-#include <linux/sysfs.h>
-#include <linux/types.h>
-#include <linux/workqueue.h>
-
-#include <asm/atomic.h>
-
-enum fw_device_state {
-	FW_DEVICE_INITIALIZING,
-	FW_DEVICE_RUNNING,
-	FW_DEVICE_GONE,
-	FW_DEVICE_SHUTDOWN,
-};
-
-struct fw_attribute_group {
-	struct attribute_group *groups[2];
-	struct attribute_group group;
-	struct attribute *attrs[12];
-};
-
-struct fw_node;
-struct fw_card;
-
-/*
- * Note, fw_device.generation always has to be read before fw_device.node_id.
- * Use SMP memory barriers to ensure this.  Otherwise requests will be sent
- * to an outdated node_id if the generation was updated in the meantime due
- * to a bus reset.
- *
- * Likewise, fw-core will take care to update .node_id before .generation so
- * that whenever fw_device.generation is current WRT the actual bus generation,
- * fw_device.node_id is guaranteed to be current too.
- *
- * The same applies to fw_device.card->node_id vs. fw_device.generation.
- *
- * fw_device.config_rom and fw_device.config_rom_length may be accessed during
- * the lifetime of any fw_unit belonging to the fw_device, before device_del()
- * was called on the last fw_unit.  Alternatively, they may be accessed while
- * holding fw_device_rwsem.
- */
-struct fw_device {
-	atomic_t state;
-	struct fw_node *node;
-	int node_id;
-	int generation;
-	unsigned max_speed;
-	struct fw_card *card;
-	struct device device;
-
-	struct mutex client_list_mutex;
-	struct list_head client_list;
-
-	u32 *config_rom;
-	size_t config_rom_length;
-	int config_rom_retries;
-	unsigned is_local:1;
-	unsigned cmc:1;
-	unsigned bc_implemented:2;
-
-	struct delayed_work work;
-	struct fw_attribute_group attribute_group;
-};
-
-static inline struct fw_device *fw_device(struct device *dev)
-{
-	return container_of(dev, struct fw_device, device);
-}
-
-static inline int fw_device_is_shutdown(struct fw_device *device)
-{
-	return atomic_read(&device->state) == FW_DEVICE_SHUTDOWN;
-}
-
-static inline struct fw_device *fw_device_get(struct fw_device *device)
-{
-	get_device(&device->device);
-
-	return device;
-}
-
-static inline void fw_device_put(struct fw_device *device)
-{
-	put_device(&device->device);
-}
-
-struct fw_device *fw_device_get_by_devt(dev_t devt);
-int fw_device_enable_phys_dma(struct fw_device *device);
-void fw_device_set_broadcast_channel(struct fw_device *device, int generation);
-
-void fw_device_cdev_update(struct fw_device *device);
-void fw_device_cdev_remove(struct fw_device *device);
-
-extern struct rw_semaphore fw_device_rwsem;
-extern struct idr fw_device_idr;
-extern int fw_cdev_major;
-
-/*
- * fw_unit.directory must not be accessed after device_del(&fw_unit.device).
- */
-struct fw_unit {
-	struct device device;
-	u32 *directory;
-	struct fw_attribute_group attribute_group;
-};
-
-static inline struct fw_unit *fw_unit(struct device *dev)
-{
-	return container_of(dev, struct fw_unit, device);
-}
-
-static inline struct fw_unit *fw_unit_get(struct fw_unit *unit)
-{
-	get_device(&unit->device);
-
-	return unit;
-}
-
-static inline void fw_unit_put(struct fw_unit *unit)
-{
-	put_device(&unit->device);
-}
-
-#define CSR_OFFSET	0x40
-#define CSR_LEAF	0x80
-#define CSR_DIRECTORY	0xc0
-
-#define CSR_DESCRIPTOR		0x01
-#define CSR_VENDOR		0x03
-#define CSR_HARDWARE_VERSION	0x04
-#define CSR_NODE_CAPABILITIES	0x0c
-#define CSR_UNIT		0x11
-#define CSR_SPECIFIER_ID	0x12
-#define CSR_VERSION		0x13
-#define CSR_DEPENDENT_INFO	0x14
-#define CSR_MODEL		0x17
-#define CSR_INSTANCE		0x18
-#define CSR_DIRECTORY_ID	0x20
-
-struct fw_csr_iterator {
-	u32 *p;
-	u32 *end;
-};
-
-void fw_csr_iterator_init(struct fw_csr_iterator *ci, u32 *p);
-int fw_csr_iterator_next(struct fw_csr_iterator *ci,
-			 int *key, int *value);
-
-struct fw_driver {
-	struct device_driver driver;
-	/* Called when the parent device sits through a bus reset. */
-	void (*update)(struct fw_unit *unit);
-	const struct ieee1394_device_id *id_table;
-};
-
-static inline struct fw_driver *fw_driver(struct device_driver *drv)
-{
-	return container_of(drv, struct fw_driver, driver);
-}
-
-extern const struct file_operations fw_device_ops;
-
-#endif /* __fw_device_h */
diff --git a/drivers/firewire/fw-iso.c b/drivers/firewire/fw-iso.c
index 0ff3e9c..28076c8 100644
--- a/drivers/firewire/fw-iso.c
+++ b/drivers/firewire/fw-iso.c
@@ -22,6 +22,7 @@
 
 #include <linux/dma-mapping.h>
 #include <linux/errno.h>
+#include <linux/firewire.h>
 #include <linux/firewire-constants.h>
 #include <linux/kernel.h>
 #include <linux/mm.h>
@@ -30,8 +31,7 @@
 
 #include <asm/byteorder.h>
 
-#include "fw-topology.h"
-#include "fw-transaction.h"
+#include "core.h"
 
 /*
  * Isochronous DMA context management
diff --git a/drivers/firewire/fw-ohci.c b/drivers/firewire/fw-ohci.c
index d296d12..ecddd11 100644
--- a/drivers/firewire/fw-ohci.c
+++ b/drivers/firewire/fw-ohci.c
@@ -22,6 +22,7 @@
 #include <linux/delay.h>
 #include <linux/device.h>
 #include <linux/dma-mapping.h>
+#include <linux/firewire.h>
 #include <linux/firewire-constants.h>
 #include <linux/gfp.h>
 #include <linux/init.h>
@@ -45,8 +46,8 @@
 #include <asm/pmac_feature.h>
 #endif
 
-#include "fw-ohci.h"
-#include "fw-transaction.h"
+#include "core.h"
+#include "ohci.h"
 
 #define DESCRIPTOR_OUTPUT_MORE		0
 #define DESCRIPTOR_OUTPUT_LAST		(1 << 12)
diff --git a/drivers/firewire/fw-sbp2.c b/drivers/firewire/fw-sbp2.c
index 027b91f..d41cb6e 100644
--- a/drivers/firewire/fw-sbp2.c
+++ b/drivers/firewire/fw-sbp2.c
@@ -34,6 +34,7 @@
 #include <linux/delay.h>
 #include <linux/device.h>
 #include <linux/dma-mapping.h>
+#include <linux/firewire.h>
 #include <linux/firewire-constants.h>
 #include <linux/init.h>
 #include <linux/jiffies.h>
@@ -58,9 +59,6 @@
 #include <scsi/scsi_device.h>
 #include <scsi/scsi_host.h>
 
-#include "fw-device.h"
-#include "fw-transaction.h"
-
 /*
  * So far only bridges from Oxford Semiconductor are known to support
  * concurrent logins. Depending on firmware, four or two concurrent logins
diff --git a/drivers/firewire/fw-topology.c b/drivers/firewire/fw-topology.c
index 6d0ea1b..fddf2b3 100644
--- a/drivers/firewire/fw-topology.c
+++ b/drivers/firewire/fw-topology.c
@@ -20,6 +20,8 @@
 
 #include <linux/bug.h>
 #include <linux/errno.h>
+#include <linux/firewire.h>
+#include <linux/firewire-constants.h>
 #include <linux/jiffies.h>
 #include <linux/kernel.h>
 #include <linux/list.h>
@@ -31,8 +33,7 @@
 #include <asm/atomic.h>
 #include <asm/system.h>
 
-#include "fw-topology.h"
-#include "fw-transaction.h"
+#include "core.h"
 
 #define SELF_ID_PHY_ID(q)		(((q) >> 24) & 0x3f)
 #define SELF_ID_EXTENDED(q)		(((q) >> 23) & 0x01)
@@ -45,6 +46,11 @@
 
 #define SELF_ID_EXT_SEQUENCE(q)		(((q) >> 20) & 0x07)
 
+#define SELFID_PORT_CHILD	0x3
+#define SELFID_PORT_PARENT	0x2
+#define SELFID_PORT_NCONN	0x1
+#define SELFID_PORT_NONE	0x0
+
 static u32 *count_ports(u32 *sid, int *total_port_count, int *child_port_count)
 {
 	u32 q;
diff --git a/drivers/firewire/fw-topology.h b/drivers/firewire/fw-topology.h
deleted file mode 100644
index 3c497bb..0000000
--- a/drivers/firewire/fw-topology.h
+++ /dev/null
@@ -1,77 +0,0 @@
-/*
- * Copyright (C) 2003-2006 Kristian Hoegsberg <krh@bitplanet.net>
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License as published by
- * the Free Software Foundation; either version 2 of the License, or
- * (at your option) any later version.
- *
- * This program is distributed in the hope that it will be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- * GNU General Public License for more details.
- *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software Foundation,
- * Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
- */
-
-#ifndef __fw_topology_h
-#define __fw_topology_h
-
-#include <linux/list.h>
-#include <linux/slab.h>
-
-#include <asm/atomic.h>
-
-enum {
-	FW_NODE_CREATED,
-	FW_NODE_UPDATED,
-	FW_NODE_DESTROYED,
-	FW_NODE_LINK_ON,
-	FW_NODE_LINK_OFF,
-	FW_NODE_INITIATED_RESET,
-};
-
-struct fw_node {
-	u16 node_id;
-	u8 color;
-	u8 port_count;
-	u8 link_on : 1;
-	u8 initiated_reset : 1;
-	u8 b_path : 1;
-	u8 phy_speed : 2; /* As in the self ID packet. */
-	u8 max_speed : 2; /* Minimum of all phy-speeds on the path from the
-			   * local node to this node. */
-	u8 max_depth : 4; /* Maximum depth to any leaf node */
-	u8 max_hops : 4;  /* Max hops in this sub tree */
-	atomic_t ref_count;
-
-	/* For serializing node topology into a list. */
-	struct list_head link;
-
-	/* Upper layer specific data. */
-	void *data;
-
-	struct fw_node *ports[0];
-};
-
-static inline struct fw_node *fw_node_get(struct fw_node *node)
-{
-	atomic_inc(&node->ref_count);
-
-	return node;
-}
-
-static inline void fw_node_put(struct fw_node *node)
-{
-	if (atomic_dec_and_test(&node->ref_count))
-		kfree(node);
-}
-
-struct fw_card;
-void fw_destroy_nodes(struct fw_card *card);
-
-int fw_compute_block_crc(u32 *block);
-
-#endif /* __fw_topology_h */
diff --git a/drivers/firewire/fw-transaction.c b/drivers/firewire/fw-transaction.c
index 7008214..9a6ce9a 100644
--- a/drivers/firewire/fw-transaction.c
+++ b/drivers/firewire/fw-transaction.c
@@ -22,6 +22,7 @@
 #include <linux/completion.h>
 #include <linux/device.h>
 #include <linux/errno.h>
+#include <linux/firewire.h>
 #include <linux/firewire-constants.h>
 #include <linux/fs.h>
 #include <linux/init.h>
@@ -38,8 +39,7 @@
 
 #include <asm/byteorder.h>
 
-#include "fw-device.h"	/* for fw_device_ops */
-#include "fw-transaction.h"
+#include "core.h"
 
 #define HEADER_PRI(pri)			((pri) << 0)
 #define HEADER_TCODE(tcode)		((tcode) << 4)
@@ -64,6 +64,10 @@
 #define HEADER_DESTINATION_IS_BROADCAST(q) \
 	(((q) & HEADER_DESTINATION(0x3f)) == HEADER_DESTINATION(0x3f))
 
+#define PHY_PACKET_CONFIG	0x0
+#define PHY_PACKET_LINK_ON	0x1
+#define PHY_PACKET_SELF_ID	0x2
+
 #define PHY_CONFIG_GAP_COUNT(gap_count)	(((gap_count) << 16) | (1 << 22))
 #define PHY_CONFIG_ROOT_ID(node_id)	((((node_id) & 0x3f) << 24) | (1 << 23))
 #define PHY_IDENTIFIER(id)		((id) << 30)
diff --git a/drivers/firewire/fw-transaction.h b/drivers/firewire/fw-transaction.h
deleted file mode 100644
index dfa7990..0000000
--- a/drivers/firewire/fw-transaction.h
+++ /dev/null
@@ -1,446 +0,0 @@
-/*
- * Copyright (C) 2003-2006 Kristian Hoegsberg <krh@bitplanet.net>
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License as published by
- * the Free Software Foundation; either version 2 of the License, or
- * (at your option) any later version.
- *
- * This program is distributed in the hope that it will be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- * GNU General Public License for more details.
- *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software Foundation,
- * Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
- */
-
-#ifndef __fw_transaction_h
-#define __fw_transaction_h
-
-#include <linux/completion.h>
-#include <linux/device.h>
-#include <linux/dma-mapping.h>
-#include <linux/firewire-constants.h>
-#include <linux/kref.h>
-#include <linux/list.h>
-#include <linux/spinlock_types.h>
-#include <linux/timer.h>
-#include <linux/types.h>
-#include <linux/workqueue.h>
-
-#define TCODE_IS_READ_REQUEST(tcode)	(((tcode) & ~1) == 4)
-#define TCODE_IS_BLOCK_PACKET(tcode)	(((tcode) &  1) != 0)
-#define TCODE_IS_REQUEST(tcode)		(((tcode) &  2) == 0)
-#define TCODE_IS_RESPONSE(tcode)	(((tcode) &  2) != 0)
-#define TCODE_HAS_REQUEST_DATA(tcode)	(((tcode) & 12) != 4)
-#define TCODE_HAS_RESPONSE_DATA(tcode)	(((tcode) & 12) != 0)
-
-#define LOCAL_BUS 0xffc0
-
-#define SELFID_PORT_CHILD	0x3
-#define SELFID_PORT_PARENT	0x2
-#define SELFID_PORT_NCONN	0x1
-#define SELFID_PORT_NONE	0x0
-
-#define PHY_PACKET_CONFIG	0x0
-#define PHY_PACKET_LINK_ON	0x1
-#define PHY_PACKET_SELF_ID	0x2
-
-/* Bit fields _within_ the PHY registers. */
-#define PHY_LINK_ACTIVE		0x80
-#define PHY_CONTENDER		0x40
-#define PHY_BUS_RESET		0x40
-#define PHY_BUS_SHORT_RESET	0x40
-
-#define CSR_REGISTER_BASE		0xfffff0000000ULL
-
-/* register offsets relative to CSR_REGISTER_BASE */
-#define CSR_STATE_CLEAR			0x0
-#define CSR_STATE_SET			0x4
-#define CSR_NODE_IDS			0x8
-#define CSR_RESET_START			0xc
-#define CSR_SPLIT_TIMEOUT_HI		0x18
-#define CSR_SPLIT_TIMEOUT_LO		0x1c
-#define CSR_CYCLE_TIME			0x200
-#define CSR_BUS_TIME			0x204
-#define CSR_BUSY_TIMEOUT		0x210
-#define CSR_BUS_MANAGER_ID		0x21c
-#define CSR_BANDWIDTH_AVAILABLE		0x220
-#define CSR_CHANNELS_AVAILABLE		0x224
-#define CSR_CHANNELS_AVAILABLE_HI	0x224
-#define CSR_CHANNELS_AVAILABLE_LO	0x228
-#define CSR_BROADCAST_CHANNEL		0x234
-#define CSR_CONFIG_ROM			0x400
-#define CSR_CONFIG_ROM_END		0x800
-#define CSR_FCP_COMMAND			0xB00
-#define CSR_FCP_RESPONSE		0xD00
-#define CSR_FCP_END			0xF00
-#define CSR_TOPOLOGY_MAP		0x1000
-#define CSR_TOPOLOGY_MAP_END		0x1400
-#define CSR_SPEED_MAP			0x2000
-#define CSR_SPEED_MAP_END		0x3000
-
-#define BANDWIDTH_AVAILABLE_INITIAL	4915
-#define BROADCAST_CHANNEL_INITIAL	(1 << 31 | 31)
-#define BROADCAST_CHANNEL_VALID		(1 << 30)
-
-#define fw_notify(s, args...) printk(KERN_NOTICE KBUILD_MODNAME ": " s, ## args)
-#define fw_error(s, args...) printk(KERN_ERR KBUILD_MODNAME ": " s, ## args)
-
-static inline void fw_memcpy_from_be32(void *_dst, void *_src, size_t size)
-{
-	u32    *dst = _dst;
-	__be32 *src = _src;
-	int i;
-
-	for (i = 0; i < size / 4; i++)
-		dst[i] = be32_to_cpu(src[i]);
-}
-
-static inline void fw_memcpy_to_be32(void *_dst, void *_src, size_t size)
-{
-	fw_memcpy_from_be32(_dst, _src, size);
-}
-
-struct fw_card;
-struct fw_packet;
-struct fw_node;
-struct fw_request;
-
-struct fw_descriptor {
-	struct list_head link;
-	size_t length;
-	u32 immediate;
-	u32 key;
-	const u32 *data;
-};
-
-int fw_core_add_descriptor(struct fw_descriptor *desc);
-void fw_core_remove_descriptor(struct fw_descriptor *desc);
-
-typedef void (*fw_packet_callback_t)(struct fw_packet *packet,
-				     struct fw_card *card, int status);
-
-typedef void (*fw_transaction_callback_t)(struct fw_card *card, int rcode,
-					  void *data, size_t length,
-					  void *callback_data);
-
-/*
- * Important note:  The callback must guarantee that either fw_send_response()
- * or kfree() is called on the @request.
- */
-typedef void (*fw_address_callback_t)(struct fw_card *card,
-				      struct fw_request *request,
-				      int tcode, int destination, int source,
-				      int generation, int speed,
-				      unsigned long long offset,
-				      void *data, size_t length,
-				      void *callback_data);
-
-struct fw_packet {
-	int speed;
-	int generation;
-	u32 header[4];
-	size_t header_length;
-	void *payload;
-	size_t payload_length;
-	dma_addr_t payload_bus;
-	u32 timestamp;
-
-	/*
-	 * This callback is called when the packet transmission has
-	 * completed; for successful transmission, the status code is
-	 * the ack received from the destination, otherwise it's a
-	 * negative errno: ENOMEM, ESTALE, ETIMEDOUT, ENODEV, EIO.
-	 * The callback can be called from tasklet context and thus
-	 * must never block.
-	 */
-	fw_packet_callback_t callback;
-	int ack;
-	struct list_head link;
-	void *driver_data;
-};
-
-struct fw_transaction {
-	int node_id; /* The generation is implied; it is always the current. */
-	int tlabel;
-	int timestamp;
-	struct list_head link;
-
-	struct fw_packet packet;
-
-	/*
-	 * The data passed to the callback is valid only during the
-	 * callback.
-	 */
-	fw_transaction_callback_t callback;
-	void *callback_data;
-};
-
-struct fw_address_handler {
-	u64 offset;
-	size_t length;
-	fw_address_callback_t address_callback;
-	void *callback_data;
-	struct list_head link;
-};
-
-struct fw_address_region {
-	u64 start;
-	u64 end;
-};
-
-extern const struct fw_address_region fw_high_memory_region;
-
-int fw_core_add_address_handler(struct fw_address_handler *handler,
-				const struct fw_address_region *region);
-void fw_core_remove_address_handler(struct fw_address_handler *handler);
-void fw_fill_response(struct fw_packet *response, u32 *request_header,
-		      int rcode, void *payload, size_t length);
-void fw_send_response(struct fw_card *card,
-		      struct fw_request *request, int rcode);
-
-extern struct bus_type fw_bus_type;
-
-struct fw_card {
-	const struct fw_card_driver *driver;
-	struct device *device;
-	struct kref kref;
-	struct completion done;
-
-	int node_id;
-	int generation;
-	int current_tlabel, tlabel_mask;
-	struct list_head transaction_list;
-	struct timer_list flush_timer;
-	unsigned long reset_jiffies;
-
-	unsigned long long guid;
-	unsigned max_receive;
-	int link_speed;
-	int config_rom_generation;
-
-	spinlock_t lock; /* Take this lock when handling the lists in
-			  * this struct. */
-	struct fw_node *local_node;
-	struct fw_node *root_node;
-	struct fw_node *irm_node;
-	u8 color; /* must be u8 to match the definition in struct fw_node */
-	int gap_count;
-	bool beta_repeaters_present;
-
-	int index;
-
-	struct list_head link;
-
-	/* Work struct for BM duties. */
-	struct delayed_work work;
-	int bm_retries;
-	int bm_generation;
-
-	bool broadcast_channel_allocated;
-	u32 broadcast_channel;
-	u32 topology_map[(CSR_TOPOLOGY_MAP_END - CSR_TOPOLOGY_MAP) / 4];
-};
-
-static inline struct fw_card *fw_card_get(struct fw_card *card)
-{
-	kref_get(&card->kref);
-
-	return card;
-}
-
-void fw_card_release(struct kref *kref);
-
-static inline void fw_card_put(struct fw_card *card)
-{
-	kref_put(&card->kref, fw_card_release);
-}
-
-extern void fw_schedule_bm_work(struct fw_card *card, unsigned long delay);
-
-/*
- * Check whether new_generation is the immediate successor of old_generation.
- * Take counter roll-over at 255 (as per to OHCI) into account.
- */
-static inline bool is_next_generation(int new_generation, int old_generation)
-{
-	return (new_generation & 0xff) == ((old_generation + 1) & 0xff);
-}
-
-/*
- * The iso packet format allows for an immediate header/payload part
- * stored in 'header' immediately after the packet info plus an
- * indirect payload part that is pointer to by the 'payload' field.
- * Applications can use one or the other or both to implement simple
- * low-bandwidth streaming (e.g. audio) or more advanced
- * scatter-gather streaming (e.g. assembling video frame automatically).
- */
-
-struct fw_iso_packet {
-	u16 payload_length;	/* Length of indirect payload. */
-	u32 interrupt : 1;	/* Generate interrupt on this packet */
-	u32 skip : 1;		/* Set to not send packet at all. */
-	u32 tag : 2;
-	u32 sy : 4;
-	u32 header_length : 8;	/* Length of immediate header. */
-	u32 header[0];
-};
-
-#define FW_ISO_CONTEXT_TRANSMIT	0
-#define FW_ISO_CONTEXT_RECEIVE	1
-
-#define FW_ISO_CONTEXT_MATCH_TAG0	 1
-#define FW_ISO_CONTEXT_MATCH_TAG1	 2
-#define FW_ISO_CONTEXT_MATCH_TAG2	 4
-#define FW_ISO_CONTEXT_MATCH_TAG3	 8
-#define FW_ISO_CONTEXT_MATCH_ALL_TAGS	15
-
-struct fw_iso_context;
-
-typedef void (*fw_iso_callback_t)(struct fw_iso_context *context,
-				  u32 cycle, size_t header_length,
-				  void *header, void *data);
-
-/*
- * An iso buffer is just a set of pages mapped for DMA in the
- * specified direction.  Since the pages are to be used for DMA, they
- * are not mapped into the kernel virtual address space.  We store the
- * DMA address in the page private. The helper function
- * fw_iso_buffer_map() will map the pages into a given vma.
- */
-
-struct fw_iso_buffer {
-	enum dma_data_direction direction;
-	struct page **pages;
-	int page_count;
-};
-
-struct fw_iso_context {
-	struct fw_card *card;
-	int type;
-	int channel;
-	int speed;
-	size_t header_size;
-	fw_iso_callback_t callback;
-	void *callback_data;
-};
-
-int fw_iso_buffer_init(struct fw_iso_buffer *buffer, struct fw_card *card,
-		       int page_count, enum dma_data_direction direction);
-int fw_iso_buffer_map(struct fw_iso_buffer *buffer, struct vm_area_struct *vma);
-void fw_iso_buffer_destroy(struct fw_iso_buffer *buffer, struct fw_card *card);
-
-struct fw_iso_context *fw_iso_context_create(struct fw_card *card,
-		int type, int channel, int speed, size_t header_size,
-		fw_iso_callback_t callback, void *callback_data);
-int fw_iso_context_queue(struct fw_iso_context *ctx,
-			 struct fw_iso_packet *packet,
-			 struct fw_iso_buffer *buffer,
-			 unsigned long payload);
-int fw_iso_context_start(struct fw_iso_context *ctx,
-			 int cycle, int sync, int tags);
-int fw_iso_context_stop(struct fw_iso_context *ctx);
-void fw_iso_context_destroy(struct fw_iso_context *ctx);
-
-void fw_iso_resource_manage(struct fw_card *card, int generation,
-		u64 channels_mask, int *channel, int *bandwidth, bool allocate);
-
-struct fw_card_driver {
-	/*
-	 * Enable the given card with the given initial config rom.
-	 * This function is expected to activate the card, and either
-	 * enable the PHY or set the link_on bit and initiate a bus
-	 * reset.
-	 */
-	int (*enable)(struct fw_card *card, u32 *config_rom, size_t length);
-
-	int (*update_phy_reg)(struct fw_card *card, int address,
-			      int clear_bits, int set_bits);
-
-	/*
-	 * Update the config rom for an enabled card.  This function
-	 * should change the config rom that is presented on the bus
-	 * an initiate a bus reset.
-	 */
-	int (*set_config_rom)(struct fw_card *card,
-			      u32 *config_rom, size_t length);
-
-	void (*send_request)(struct fw_card *card, struct fw_packet *packet);
-	void (*send_response)(struct fw_card *card, struct fw_packet *packet);
-	/* Calling cancel is valid once a packet has been submitted. */
-	int (*cancel_packet)(struct fw_card *card, struct fw_packet *packet);
-
-	/*
-	 * Allow the specified node ID to do direct DMA out and in of
-	 * host memory.  The card will disable this for all node when
-	 * a bus reset happens, so driver need to reenable this after
-	 * bus reset.  Returns 0 on success, -ENODEV if the card
-	 * doesn't support this, -ESTALE if the generation doesn't
-	 * match.
-	 */
-	int (*enable_phys_dma)(struct fw_card *card,
-			       int node_id, int generation);
-
-	u64 (*get_bus_time)(struct fw_card *card);
-
-	struct fw_iso_context *
-	(*allocate_iso_context)(struct fw_card *card,
-				int type, int channel, size_t header_size);
-	void (*free_iso_context)(struct fw_iso_context *ctx);
-
-	int (*start_iso)(struct fw_iso_context *ctx,
-			 s32 cycle, u32 sync, u32 tags);
-
-	int (*queue_iso)(struct fw_iso_context *ctx,
-			 struct fw_iso_packet *packet,
-			 struct fw_iso_buffer *buffer,
-			 unsigned long payload);
-
-	int (*stop_iso)(struct fw_iso_context *ctx);
-};
-
-int fw_core_initiate_bus_reset(struct fw_card *card, int short_reset);
-
-void fw_send_request(struct fw_card *card, struct fw_transaction *t,
-		int tcode, int destination_id, int generation, int speed,
-		unsigned long long offset, void *payload, size_t length,
-		fw_transaction_callback_t callback, void *callback_data);
-int fw_cancel_transaction(struct fw_card *card,
-			  struct fw_transaction *transaction);
-void fw_flush_transactions(struct fw_card *card);
-int fw_run_transaction(struct fw_card *card, int tcode, int destination_id,
-		       int generation, int speed, unsigned long long offset,
-		       void *payload, size_t length);
-void fw_send_phy_config(struct fw_card *card,
-			int node_id, int generation, int gap_count);
-
-static inline int fw_stream_packet_destination_id(int tag, int channel, int sy)
-{
-	return tag << 14 | channel << 8 | sy;
-}
-
-/*
- * Called by the topology code to inform the device code of node
- * activity; found, lost, or updated nodes.
- */
-void fw_node_event(struct fw_card *card, struct fw_node *node, int event);
-
-/* API used by card level drivers */
-
-void fw_card_initialize(struct fw_card *card,
-		const struct fw_card_driver *driver, struct device *device);
-int fw_card_add(struct fw_card *card,
-		u32 max_receive, u32 link_speed, u64 guid);
-void fw_core_remove_card(struct fw_card *card);
-void fw_core_handle_bus_reset(struct fw_card *card, int node_id,
-		int generation, int self_id_count, u32 *self_ids);
-void fw_core_handle_request(struct fw_card *card, struct fw_packet *request);
-void fw_core_handle_response(struct fw_card *card, struct fw_packet *packet);
-
-extern int fw_irm_set_broadcast_channel_register(struct device *dev,
-						 void *data);
-
-#endif /* __fw_transaction_h */
diff --git a/drivers/firewire/fw-ohci.h b/drivers/firewire/ohci.h
similarity index 98%
rename from drivers/firewire/fw-ohci.h
rename to drivers/firewire/ohci.h
index a2fbb62..ba492d8 100644
--- a/drivers/firewire/fw-ohci.h
+++ b/drivers/firewire/ohci.h
@@ -1,5 +1,5 @@
-#ifndef __fw_ohci_h
-#define __fw_ohci_h
+#ifndef _FIREWIRE_OHCI_H
+#define _FIREWIRE_OHCI_H
 
 /* OHCI register map */
 
@@ -154,4 +154,4 @@
 
 #define OHCI1394_phy_tcode		0xe
 
-#endif /* __fw_ohci_h */
+#endif /* _FIREWIRE_OHCI_H */
diff --git a/include/linux/firewire.h b/include/linux/firewire.h
new file mode 100644
index 0000000..e979f9b
--- /dev/null
+++ b/include/linux/firewire.h
@@ -0,0 +1,350 @@
+#ifndef _LINUX_FIREWIRE_H
+#define _LINUX_FIREWIRE_H
+
+#include <linux/completion.h>
+#include <linux/device.h>
+#include <linux/kernel.h>
+#include <linux/kref.h>
+#include <linux/list.h>
+#include <linux/mutex.h>
+#include <linux/spinlock.h>
+#include <linux/sysfs.h>
+#include <linux/timer.h>
+#include <linux/types.h>
+#include <linux/workqueue.h>
+
+#include <asm/atomic.h>
+#include <asm/byteorder.h>
+
+#define fw_notify(s, args...) printk(KERN_NOTICE KBUILD_MODNAME ": " s, ## args)
+#define fw_error(s, args...) printk(KERN_ERR KBUILD_MODNAME ": " s, ## args)
+
+static inline void fw_memcpy_from_be32(void *_dst, void *_src, size_t size)
+{
+	u32    *dst = _dst;
+	__be32 *src = _src;
+	int i;
+
+	for (i = 0; i < size / 4; i++)
+		dst[i] = be32_to_cpu(src[i]);
+}
+
+static inline void fw_memcpy_to_be32(void *_dst, void *_src, size_t size)
+{
+	fw_memcpy_from_be32(_dst, _src, size);
+}
+#define CSR_REGISTER_BASE		0xfffff0000000ULL
+
+/* register offsets are relative to CSR_REGISTER_BASE */
+#define CSR_STATE_CLEAR			0x0
+#define CSR_STATE_SET			0x4
+#define CSR_NODE_IDS			0x8
+#define CSR_RESET_START			0xc
+#define CSR_SPLIT_TIMEOUT_HI		0x18
+#define CSR_SPLIT_TIMEOUT_LO		0x1c
+#define CSR_CYCLE_TIME			0x200
+#define CSR_BUS_TIME			0x204
+#define CSR_BUSY_TIMEOUT		0x210
+#define CSR_BUS_MANAGER_ID		0x21c
+#define CSR_BANDWIDTH_AVAILABLE		0x220
+#define CSR_CHANNELS_AVAILABLE		0x224
+#define CSR_CHANNELS_AVAILABLE_HI	0x224
+#define CSR_CHANNELS_AVAILABLE_LO	0x228
+#define CSR_BROADCAST_CHANNEL		0x234
+#define CSR_CONFIG_ROM			0x400
+#define CSR_CONFIG_ROM_END		0x800
+#define CSR_FCP_COMMAND			0xB00
+#define CSR_FCP_RESPONSE		0xD00
+#define CSR_FCP_END			0xF00
+#define CSR_TOPOLOGY_MAP		0x1000
+#define CSR_TOPOLOGY_MAP_END		0x1400
+#define CSR_SPEED_MAP			0x2000
+#define CSR_SPEED_MAP_END		0x3000
+
+#define CSR_OFFSET		0x40
+#define CSR_LEAF		0x80
+#define CSR_DIRECTORY		0xc0
+
+#define CSR_DESCRIPTOR		0x01
+#define CSR_VENDOR		0x03
+#define CSR_HARDWARE_VERSION	0x04
+#define CSR_NODE_CAPABILITIES	0x0c
+#define CSR_UNIT		0x11
+#define CSR_SPECIFIER_ID	0x12
+#define CSR_VERSION		0x13
+#define CSR_DEPENDENT_INFO	0x14
+#define CSR_MODEL		0x17
+#define CSR_INSTANCE		0x18
+#define CSR_DIRECTORY_ID	0x20
+
+struct fw_csr_iterator {
+	u32 *p;
+	u32 *end;
+};
+
+void fw_csr_iterator_init(struct fw_csr_iterator *ci, u32 *p);
+int fw_csr_iterator_next(struct fw_csr_iterator *ci, int *key, int *value);
+
+extern struct bus_type fw_bus_type;
+
+struct fw_card_driver;
+struct fw_node;
+
+struct fw_card {
+	const struct fw_card_driver *driver;
+	struct device *device;
+	struct kref kref;
+	struct completion done;
+
+	int node_id;
+	int generation;
+	int current_tlabel, tlabel_mask;
+	struct list_head transaction_list;
+	struct timer_list flush_timer;
+	unsigned long reset_jiffies;
+
+	unsigned long long guid;
+	unsigned max_receive;
+	int link_speed;
+	int config_rom_generation;
+
+	spinlock_t lock; /* Take this lock when handling the lists in
+			  * this struct. */
+	struct fw_node *local_node;
+	struct fw_node *root_node;
+	struct fw_node *irm_node;
+	u8 color; /* must be u8 to match the definition in struct fw_node */
+	int gap_count;
+	bool beta_repeaters_present;
+
+	int index;
+
+	struct list_head link;
+
+	/* Work struct for BM duties. */
+	struct delayed_work work;
+	int bm_retries;
+	int bm_generation;
+
+	bool broadcast_channel_allocated;
+	u32 broadcast_channel;
+	u32 topology_map[(CSR_TOPOLOGY_MAP_END - CSR_TOPOLOGY_MAP) / 4];
+};
+
+static inline struct fw_card *fw_card_get(struct fw_card *card)
+{
+	kref_get(&card->kref);
+
+	return card;
+}
+
+void fw_card_release(struct kref *kref);
+
+static inline void fw_card_put(struct fw_card *card)
+{
+	kref_put(&card->kref, fw_card_release);
+}
+
+struct fw_attribute_group {
+	struct attribute_group *groups[2];
+	struct attribute_group group;
+	struct attribute *attrs[12];
+};
+
+enum fw_device_state {
+	FW_DEVICE_INITIALIZING,
+	FW_DEVICE_RUNNING,
+	FW_DEVICE_GONE,
+	FW_DEVICE_SHUTDOWN,
+};
+
+/*
+ * Note, fw_device.generation always has to be read before fw_device.node_id.
+ * Use SMP memory barriers to ensure this.  Otherwise requests will be sent
+ * to an outdated node_id if the generation was updated in the meantime due
+ * to a bus reset.
+ *
+ * Likewise, fw-core will take care to update .node_id before .generation so
+ * that whenever fw_device.generation is current WRT the actual bus generation,
+ * fw_device.node_id is guaranteed to be current too.
+ *
+ * The same applies to fw_device.card->node_id vs. fw_device.generation.
+ *
+ * fw_device.config_rom and fw_device.config_rom_length may be accessed during
+ * the lifetime of any fw_unit belonging to the fw_device, before device_del()
+ * was called on the last fw_unit.  Alternatively, they may be accessed while
+ * holding fw_device_rwsem.
+ */
+struct fw_device {
+	atomic_t state;
+	struct fw_node *node;
+	int node_id;
+	int generation;
+	unsigned max_speed;
+	struct fw_card *card;
+	struct device device;
+
+	struct mutex client_list_mutex;
+	struct list_head client_list;
+
+	u32 *config_rom;
+	size_t config_rom_length;
+	int config_rom_retries;
+	unsigned is_local:1;
+	unsigned cmc:1;
+	unsigned bc_implemented:2;
+
+	struct delayed_work work;
+	struct fw_attribute_group attribute_group;
+};
+
+static inline struct fw_device *fw_device(struct device *dev)
+{
+	return container_of(dev, struct fw_device, device);
+}
+
+static inline int fw_device_is_shutdown(struct fw_device *device)
+{
+	return atomic_read(&device->state) == FW_DEVICE_SHUTDOWN;
+}
+
+static inline struct fw_device *fw_device_get(struct fw_device *device)
+{
+	get_device(&device->device);
+
+	return device;
+}
+
+static inline void fw_device_put(struct fw_device *device)
+{
+	put_device(&device->device);
+}
+
+int fw_device_enable_phys_dma(struct fw_device *device);
+
+/*
+ * fw_unit.directory must not be accessed after device_del(&fw_unit.device).
+ */
+struct fw_unit {
+	struct device device;
+	u32 *directory;
+	struct fw_attribute_group attribute_group;
+};
+
+static inline struct fw_unit *fw_unit(struct device *dev)
+{
+	return container_of(dev, struct fw_unit, device);
+}
+
+static inline struct fw_unit *fw_unit_get(struct fw_unit *unit)
+{
+	get_device(&unit->device);
+
+	return unit;
+}
+
+static inline void fw_unit_put(struct fw_unit *unit)
+{
+	put_device(&unit->device);
+}
+
+struct ieee1394_device_id;
+
+struct fw_driver {
+	struct device_driver driver;
+	/* Called when the parent device sits through a bus reset. */
+	void (*update)(struct fw_unit *unit);
+	const struct ieee1394_device_id *id_table;
+};
+
+struct fw_packet;
+struct fw_request;
+
+typedef void (*fw_packet_callback_t)(struct fw_packet *packet,
+				     struct fw_card *card, int status);
+typedef void (*fw_transaction_callback_t)(struct fw_card *card, int rcode,
+					  void *data, size_t length,
+					  void *callback_data);
+/*
+ * Important note:  The callback must guarantee that either fw_send_response()
+ * or kfree() is called on the @request.
+ */
+typedef void (*fw_address_callback_t)(struct fw_card *card,
+				      struct fw_request *request,
+				      int tcode, int destination, int source,
+				      int generation, int speed,
+				      unsigned long long offset,
+				      void *data, size_t length,
+				      void *callback_data);
+
+struct fw_packet {
+	int speed;
+	int generation;
+	u32 header[4];
+	size_t header_length;
+	void *payload;
+	size_t payload_length;
+	dma_addr_t payload_bus;
+	u32 timestamp;
+
+	/*
+	 * This callback is called when the packet transmission has
+	 * completed; for successful transmission, the status code is
+	 * the ack received from the destination, otherwise it's a
+	 * negative errno: ENOMEM, ESTALE, ETIMEDOUT, ENODEV, EIO.
+	 * The callback can be called from tasklet context and thus
+	 * must never block.
+	 */
+	fw_packet_callback_t callback;
+	int ack;
+	struct list_head link;
+	void *driver_data;
+};
+
+struct fw_transaction {
+	int node_id; /* The generation is implied; it is always the current. */
+	int tlabel;
+	int timestamp;
+	struct list_head link;
+
+	struct fw_packet packet;
+
+	/*
+	 * The data passed to the callback is valid only during the
+	 * callback.
+	 */
+	fw_transaction_callback_t callback;
+	void *callback_data;
+};
+
+struct fw_address_handler {
+	u64 offset;
+	size_t length;
+	fw_address_callback_t address_callback;
+	void *callback_data;
+	struct list_head link;
+};
+
+struct fw_address_region {
+	u64 start;
+	u64 end;
+};
+
+extern const struct fw_address_region fw_high_memory_region;
+
+int fw_core_add_address_handler(struct fw_address_handler *handler,
+				const struct fw_address_region *region);
+void fw_core_remove_address_handler(struct fw_address_handler *handler);
+void fw_send_response(struct fw_card *card,
+		      struct fw_request *request, int rcode);
+void fw_send_request(struct fw_card *card, struct fw_transaction *t,
+		     int tcode, int destination_id, int generation, int speed,
+		     unsigned long long offset, void *payload, size_t length,
+		     fw_transaction_callback_t callback, void *callback_data);
+int fw_cancel_transaction(struct fw_card *card,
+			  struct fw_transaction *transaction);
+int fw_run_transaction(struct fw_card *card, int tcode, int destination_id,
+		       int generation, int speed, unsigned long long offset,
+		       void *payload, size_t length);
+
+#endif /* _LINUX_FIREWIRE_H */
-- 
1.6.0.6


-- 
Stefan Richter
-=====-==--= -==- --=-=
http://arcgraph.de/sr/

