Return-Path: <linux-kernel-owner+w=401wt.eu-S2993076AbXEBMSD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2993076AbXEBMSD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2007 08:18:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2993079AbXEBMSD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 May 2007 08:18:03 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:58886 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2993076AbXEBMR5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2007 08:17:57 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Wed, 2 May 2007 14:16:44 +0200 (CEST)
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: [PATCH 2/6] firewire: isochronous and asynchronous I/O
To: linux-kernel@vger.kernel.org
cc: Kristian H??gsberg <krh@redhat.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       linux1394-devel <linux1394-devel@lists.sourceforge.net>,
       Christoph Hellwig <hch@infradead.org>
In-Reply-To: <tkrat.350cb4dfe522266e@s5r6.in-berlin.de>
Message-ID: <tkrat.65aea95f1451c211@s5r6.in-berlin.de>
References: <4637A29F.6070302@redhat.com>
 <20070502090007.GA28174@infradead.org>
 <tkrat.087ee29add656926@s5r6.in-berlin.de>
 <tkrat.350cb4dfe522266e@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=us-ascii
Content-Disposition: INLINE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
---
 drivers/firewire/fw-iso.c         |  163 +++++
 drivers/firewire/fw-transaction.c |  889 ++++++++++++++++++++++++++++++
 drivers/firewire/fw-transaction.h |  505 +++++++++++++++++
 3 files changed, 1557 insertions(+)

Index: linux_juju/drivers/firewire/fw-iso.c
===================================================================
--- /dev/null
+++ linux_juju/drivers/firewire/fw-iso.c
@@ -0,0 +1,163 @@
+/*						-*- c-basic-offset: 8 -*-
+ *
+ * fw-iso.c - Isochronous IO
+ * Copyright (C) 2006 Kristian Hoegsberg <krh@bitplanet.net>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software Foundation,
+ * Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
+ */
+
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/dma-mapping.h>
+#include <linux/vmalloc.h>
+#include <linux/mm.h>
+
+#include "fw-transaction.h"
+#include "fw-topology.h"
+#include "fw-device.h"
+
+int
+fw_iso_buffer_init(struct fw_iso_buffer *buffer, struct fw_card *card,
+		   int page_count, enum dma_data_direction direction)
+{
+	int i, j, retval = -ENOMEM;
+	dma_addr_t address;
+
+	buffer->page_count = page_count;
+	buffer->direction = direction;
+
+	buffer->pages = kmalloc(page_count * sizeof(buffer->pages[0]),
+				GFP_KERNEL);
+	if (buffer->pages == NULL)
+		goto out;
+
+	for (i = 0; i < buffer->page_count; i++) {
+		buffer->pages[i] = alloc_page(GFP_KERNEL | GFP_DMA32 | __GFP_ZERO);
+		if (buffer->pages[i] == NULL)
+			goto out_pages;
+
+		address = dma_map_page(card->device, buffer->pages[i],
+				       0, PAGE_SIZE, direction);
+		if (dma_mapping_error(address)) {
+			__free_page(buffer->pages[i]);
+			goto out_pages;
+		}
+		set_page_private(buffer->pages[i], address);
+	}
+
+	return 0;
+
+ out_pages:
+	for (j = 0; j < i; j++) {
+		address = page_private(buffer->pages[j]);
+		dma_unmap_page(card->device, address,
+			       PAGE_SIZE, DMA_TO_DEVICE);
+		__free_page(buffer->pages[j]);
+	}
+	kfree(buffer->pages);
+ out:
+	buffer->pages = NULL;
+	return retval;
+}
+
+int fw_iso_buffer_map(struct fw_iso_buffer *buffer, struct vm_area_struct *vma)
+{
+	unsigned long uaddr;
+	int i, retval;
+
+	uaddr = vma->vm_start;
+	for (i = 0; i < buffer->page_count; i++) {
+		retval = vm_insert_page(vma, uaddr, buffer->pages[i]);
+		if (retval)
+			return retval;
+		uaddr += PAGE_SIZE;
+	}
+
+	return 0;
+}
+
+void fw_iso_buffer_destroy(struct fw_iso_buffer *buffer,
+			   struct fw_card *card)
+{
+	int i;
+	dma_addr_t address;
+
+	for (i = 0; i < buffer->page_count; i++) {
+		address = page_private(buffer->pages[i]);
+		dma_unmap_page(card->device, address,
+			       PAGE_SIZE, DMA_TO_DEVICE);
+		__free_page(buffer->pages[i]);
+	}
+
+	kfree(buffer->pages);
+	buffer->pages = NULL;
+}
+
+struct fw_iso_context *
+fw_iso_context_create(struct fw_card *card, int type,
+		      int channel, int speed, size_t header_size,
+		      fw_iso_callback_t callback, void *callback_data)
+{
+	struct fw_iso_context *ctx;
+
+	ctx = card->driver->allocate_iso_context(card, type, header_size);
+	if (IS_ERR(ctx))
+		return ctx;
+
+	ctx->card = card;
+	ctx->type = type;
+	ctx->channel = channel;
+	ctx->speed = speed;
+	ctx->header_size = header_size;
+	ctx->callback = callback;
+	ctx->callback_data = callback_data;
+
+	return ctx;
+}
+EXPORT_SYMBOL(fw_iso_context_create);
+
+void fw_iso_context_destroy(struct fw_iso_context *ctx)
+{
+	struct fw_card *card = ctx->card;
+
+	card->driver->free_iso_context(ctx);
+}
+EXPORT_SYMBOL(fw_iso_context_destroy);
+
+int
+fw_iso_context_start(struct fw_iso_context *ctx, int cycle, int sync, int tags)
+{
+	return ctx->card->driver->start_iso(ctx, cycle, sync, tags);
+}
+EXPORT_SYMBOL(fw_iso_context_start);
+
+int
+fw_iso_context_queue(struct fw_iso_context *ctx,
+		     struct fw_iso_packet *packet,
+		     struct fw_iso_buffer *buffer,
+		     unsigned long payload)
+{
+	struct fw_card *card = ctx->card;
+
+	return card->driver->queue_iso(ctx, packet, buffer, payload);
+}
+EXPORT_SYMBOL(fw_iso_context_queue);
+
+int
+fw_iso_context_stop(struct fw_iso_context *ctx)
+{
+	return ctx->card->driver->stop_iso(ctx);
+}
+EXPORT_SYMBOL(fw_iso_context_stop);
Index: linux_juju/drivers/firewire/fw-transaction.h
===================================================================
--- /dev/null
+++ linux_juju/drivers/firewire/fw-transaction.h
@@ -0,0 +1,505 @@
+/*						-*- c-basic-offset: 8 -*-
+ *
+ * fw-transaction.h - Header for IEEE1394 transaction logic
+ *
+ * Copyright (C) 2003-2006 Kristian Hoegsberg <krh@bitplanet.net>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software Foundation,
+ * Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
+ */
+
+#ifndef __fw_transaction_h
+#define __fw_transaction_h
+
+#include <linux/device.h>
+#include <linux/timer.h>
+#include <linux/interrupt.h>
+#include <linux/list.h>
+#include <linux/fs.h>
+#include <linux/dma-mapping.h>
+
+#define TCODE_WRITE_QUADLET_REQUEST	0
+#define TCODE_WRITE_BLOCK_REQUEST	1
+#define TCODE_WRITE_RESPONSE		2
+#define TCODE_READ_QUADLET_REQUEST	4
+#define TCODE_READ_BLOCK_REQUEST	5
+#define TCODE_READ_QUADLET_RESPONSE	6
+#define TCODE_READ_BLOCK_RESPONSE	7
+#define TCODE_CYCLE_START		8
+#define TCODE_LOCK_REQUEST		9
+#define TCODE_STREAM_DATA		10
+#define TCODE_LOCK_RESPONSE		11
+
+#define TCODE_IS_READ_REQUEST(tcode)	(((tcode) & ~1) == 4)
+#define TCODE_IS_BLOCK_PACKET(tcode)	(((tcode) &  1) != 0)
+#define TCODE_IS_REQUEST(tcode)		(((tcode) &  2) == 0)
+#define TCODE_IS_RESPONSE(tcode)	(((tcode) &  2) != 0)
+#define TCODE_HAS_REQUEST_DATA(tcode)	(((tcode) & 12) != 4)
+#define TCODE_HAS_RESPONSE_DATA(tcode)	(((tcode) & 12) != 0)
+
+/* Juju specific tcodes */
+#define TCODE_DEALLOCATE		0x10
+#define TCODE_LOCK_MASK_SWAP		0x11
+#define TCODE_LOCK_COMPARE_SWAP		0x12
+#define TCODE_LOCK_FETCH_ADD		0x13
+#define TCODE_LOCK_LITTLE_ADD		0x14
+#define TCODE_LOCK_BOUNDED_ADD		0x15
+#define TCODE_LOCK_WRAP_ADD		0x16
+#define TCODE_LOCK_VENDOR_SPECIFIC	0x17
+
+#define SCODE_100			0x0
+#define SCODE_200			0x1
+#define SCODE_400			0x2
+#define SCODE_BETA			0x3
+
+#define EXTCODE_MASK_SWAP	0x1
+#define EXTCODE_COMPARE_SWAP	0x2
+#define EXTCODE_FETCH_ADD	0x3
+#define EXTCODE_LITTLE_ADD	0x4
+#define EXTCODE_BOUNDED_ADD	0x5
+#define EXTCODE_WRAP_ADD	0x6
+
+#define ACK_COMPLETE		0x1
+#define ACK_PENDING		0x2
+#define ACK_BUSY_X		0x4
+#define ACK_BUSY_A		0x5
+#define ACK_BUSY_B		0x6
+#define ACK_DATA_ERROR		0xd
+#define ACK_TYPE_ERROR		0xe
+
+#define RCODE_COMPLETE		0x0
+#define RCODE_CONFLICT_ERROR	0x4
+#define RCODE_DATA_ERROR	0x5
+#define RCODE_TYPE_ERROR	0x6
+#define RCODE_ADDRESS_ERROR	0x7
+
+/* Juju specific rcodes */
+#define RCODE_SEND_ERROR	0x10
+#define RCODE_CANCELLED		0x11
+#define RCODE_BUSY		0x12
+#define RCODE_GENERATION	0x13
+#define RCODE_NO_ACK		0x14
+
+#define RETRY_1	0x00
+#define RETRY_X	0x01
+#define RETRY_A	0x02
+#define RETRY_B	0x03
+
+#define LOCAL_BUS 0xffc0
+
+#define SELFID_PORT_CHILD	0x3
+#define SELFID_PORT_PARENT	0x2
+#define SELFID_PORT_NCONN	0x1
+#define SELFID_PORT_NONE	0x0
+
+#define PHY_PACKET_CONFIG	0x0
+#define PHY_PACKET_LINK_ON	0x1
+#define PHY_PACKET_SELF_ID	0x2
+
+/* Bit fields _within_ the PHY registers. */
+#define PHY_LINK_ACTIVE		0x80
+#define PHY_CONTENDER		0x40
+#define PHY_BUS_RESET		0x40
+#define PHY_BUS_SHORT_RESET	0x40
+
+#define CSR_REGISTER_BASE		0xfffff0000000ULL
+
+/* register offsets relative to CSR_REGISTER_BASE */
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
+#define fw_notify(s, args...) printk(KERN_NOTICE KBUILD_MODNAME ": " s, ## args)
+#define fw_error(s, args...) printk(KERN_ERR KBUILD_MODNAME ": " s, ## args)
+#define fw_debug(s, args...) printk(KERN_DEBUG KBUILD_MODNAME ": " s, ## args)
+
+static inline void
+fw_memcpy_from_be32(void *_dst, void *_src, size_t size)
+{
+	u32 *dst = _dst;
+	u32 *src = _src;
+	int i;
+
+	for (i = 0; i < size / 4; i++)
+		dst[i] = cpu_to_be32(src[i]);
+}
+
+static inline void
+fw_memcpy_to_be32(void *_dst, void *_src, size_t size)
+{
+	fw_memcpy_from_be32(_dst, _src, size);
+}
+
+struct fw_card;
+struct fw_packet;
+struct fw_node;
+struct fw_request;
+
+struct fw_descriptor {
+	struct list_head link;
+	size_t length;
+	u32 immediate;
+	u32 key;
+	const u32 *data;
+};
+
+int fw_core_add_descriptor (struct fw_descriptor *desc);
+void fw_core_remove_descriptor (struct fw_descriptor *desc);
+
+typedef void (*fw_packet_callback_t) (struct fw_packet *packet,
+				      struct fw_card *card, int status);
+
+typedef void (*fw_transaction_callback_t)(struct fw_card *card, int rcode,
+					  void *data,
+					  size_t length,
+					  void *callback_data);
+
+typedef void (*fw_address_callback_t)(struct fw_card *card,
+				      struct fw_request *request,
+				      int tcode, int destination, int source,
+				      int generation, int speed,
+				      unsigned long long offset,
+				      void *data, size_t length,
+				      void *callback_data);
+
+typedef void (*fw_bus_reset_callback_t)(struct fw_card *handle,
+					int node_id, int generation,
+					u32 *self_ids,
+					int self_id_count,
+					void *callback_data);
+
+struct fw_packet {
+	int speed;
+	int generation;
+	u32 header[4];
+	size_t header_length;
+	void *payload;
+	size_t payload_length;
+	u32 timestamp;
+
+	/* This callback is called when the packet transmission has
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
+	/* The data passed to the callback is valid only during the
+	 * callback.  */
+	fw_transaction_callback_t callback;
+	void *callback_data;
+};
+
+static inline struct fw_packet *
+fw_packet(struct list_head *l)
+{
+	return list_entry (l, struct fw_packet, link);
+}
+
+struct fw_address_handler {
+	u64 offset;
+	size_t length;
+	fw_address_callback_t address_callback;
+	void *callback_data;
+	struct list_head link;
+};
+
+
+struct fw_address_region {
+	u64 start;
+	u64 end;
+};
+
+extern const struct fw_address_region fw_low_memory_region;
+extern const struct fw_address_region fw_high_memory_region;
+extern const struct fw_address_region fw_private_region;
+extern const struct fw_address_region fw_csr_region;
+extern const struct fw_address_region fw_unit_space_region;
+
+int fw_core_add_address_handler(struct fw_address_handler *handler,
+				const struct fw_address_region *region);
+void fw_core_remove_address_handler(struct fw_address_handler *handler);
+void fw_fill_response(struct fw_packet *response, u32 *request_header,
+		      int rcode, void *payload, size_t length);
+void fw_send_response(struct fw_card *card,
+		      struct fw_request *request, int rcode);
+
+extern struct bus_type fw_bus_type;
+
+struct fw_card {
+	const struct fw_card_driver *driver;
+	struct device *device;
+	struct kref kref;
+
+	int node_id;
+	int generation;
+	/* This is the generation used for timestamping incoming requests. */
+	int request_generation;
+	int current_tlabel, tlabel_mask;
+	struct list_head transaction_list;
+	struct timer_list flush_timer;
+	unsigned long reset_jiffies;
+
+	unsigned long long guid;
+	int max_receive;
+	int link_speed;
+	int config_rom_generation;
+
+	/* We need to store up to 4 self ID for a maximum of 63
+	 * devices plus 3 words for the topology map header. */
+	int self_id_count;
+	u32 topology_map[252 + 3];
+
+	spinlock_t lock; /* Take this lock when handling the lists in
+			  * this struct. */
+	struct fw_node *local_node;
+	struct fw_node *root_node;
+	struct fw_node *irm_node;
+	int color;
+	int gap_count;
+	int topology_type;
+
+	int index;
+
+	struct list_head link;
+
+	/* Work struct for BM duties. */
+	struct delayed_work work;
+	int bm_retries;
+	int bm_generation;
+};
+
+struct fw_card *fw_card_get(struct fw_card *card);
+void fw_card_put(struct fw_card *card);
+
+/* The iso packet format allows for an immediate header/payload part
+ * stored in 'header' immediately after the packet info plus an
+ * indirect payload part that is pointer to by the 'payload' field.
+ * Applications can use one or the other or both to implement simple
+ * low-bandwidth streaming (e.g. audio) or more advanced
+ * scatter-gather streaming (e.g. assembling video frame automatically). */
+
+struct fw_iso_packet {
+	u16 payload_length;	/* Length of indirect payload. */
+	u32 interrupt : 1;	/* Generate interrupt on this packet */
+	u32 skip : 1;		/* Set to not send packet at all. */
+	u32 tag : 2;
+	u32 sy : 4;
+	u32 header_length : 8;	/* Length of immediate header. */
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
+struct fw_iso_context;
+
+typedef void (*fw_iso_callback_t) (struct fw_iso_context *context,
+				   u32 cycle,
+				   size_t header_length,
+				   void *header,
+				   void *data);
+
+/* An iso buffer is just a set of pages mapped for DMA in the
+ * specified direction.  Since the pages are to be used for DMA, they
+ * are not mapped into the kernel virtual address space.  We store the
+ * DMA address in the page private. The helper function
+ * fw_iso_buffer_map() will map the pages into a given vma. */
+
+struct fw_iso_buffer {
+	enum dma_data_direction direction;
+	struct page **pages;
+	int page_count;
+};
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
+int
+fw_iso_buffer_init(struct fw_iso_buffer *buffer,
+		   struct fw_card *card,
+		   int page_count,
+		   enum dma_data_direction direction);
+int
+fw_iso_buffer_map(struct fw_iso_buffer *buffer, struct vm_area_struct *vma);
+void
+fw_iso_buffer_destroy(struct fw_iso_buffer *buffer, struct fw_card *card);
+
+struct fw_iso_context *
+fw_iso_context_create(struct fw_card *card, int type,
+		      int channel, int speed, size_t header_size,
+		      fw_iso_callback_t callback, void *callback_data);
+
+void
+fw_iso_context_destroy(struct fw_iso_context *ctx);
+
+int
+fw_iso_context_queue(struct fw_iso_context *ctx,
+		     struct fw_iso_packet *packet,
+		     struct fw_iso_buffer *buffer,
+		     unsigned long payload);
+
+int
+fw_iso_context_start(struct fw_iso_context *ctx,
+		     int cycle, int sync, int tags);
+
+int
+fw_iso_context_stop(struct fw_iso_context *ctx);
+
+struct fw_card_driver {
+	const char *name;
+
+	/* Enable the given card with the given initial config rom.
+	 * This function is expected to activate the card, and either
+	 * enable the PHY or set the link_on bit and initiate a bus
+	 * reset. */
+	int (*enable) (struct fw_card *card, u32 *config_rom, size_t length);
+
+	int (*update_phy_reg) (struct fw_card *card, int address,
+			       int clear_bits, int set_bits);
+
+	/* Update the config rom for an enabled card.  This function
+	 * should change the config rom that is presented on the bus
+	 * an initiate a bus reset. */
+	int (*set_config_rom) (struct fw_card *card,
+			       u32 *config_rom, size_t length);
+
+	void (*send_request) (struct fw_card *card, struct fw_packet *packet);
+	void (*send_response) (struct fw_card *card, struct fw_packet *packet);
+	/* Calling cancel is valid once a packet has been submitted. */
+	int (*cancel_packet) (struct fw_card *card, struct fw_packet *packet);
+
+	/* Allow the specified node ID to do direct DMA out and in of
+	 * host memory.  The card will disable this for all node when
+	 * a bus reset happens, so driver need to reenable this after
+	 * bus reset.  Returns 0 on success, -ENODEV if the card
+	 * doesn't support this, -ESTALE if the generation doesn't
+	 * match. */
+	int (*enable_phys_dma) (struct fw_card *card,
+				int node_id, int generation);
+
+	u64 (*get_bus_time) (struct fw_card *card);
+
+	struct fw_iso_context *
+	(*allocate_iso_context)(struct fw_card *card,
+				int type, size_t header_size);
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
+int
+fw_core_initiate_bus_reset(struct fw_card *card, int short_reset);
+
+void
+fw_send_request(struct fw_card *card, struct fw_transaction *t,
+		int tcode, int node_id, int generation, int speed,
+		unsigned long long offset,
+		void *data, size_t length,
+		fw_transaction_callback_t callback, void *callback_data);
+
+int fw_cancel_transaction(struct fw_card *card,
+			  struct fw_transaction *transaction);
+
+void fw_flush_transactions(struct fw_card *card);
+
+void fw_send_phy_config(struct fw_card *card,
+			int node_id, int generation, int gap_count);
+
+/* Called by the topology code to inform the device code of node
+ * activity; found, lost, or updated nodes */
+void
+fw_node_event(struct fw_card *card, struct fw_node *node, int event);
+
+/* API used by card level drivers */
+
+/* Do we need phy speed here also?  If we add more args, maybe we
+   should go back to struct fw_card_info. */
+void
+fw_card_initialize(struct fw_card *card, const struct fw_card_driver *driver,
+		   struct device *device);
+int
+fw_card_add(struct fw_card *card,
+	    u32 max_receive, u32 link_speed, u64 guid);
+
+void
+fw_core_remove_card(struct fw_card *card);
+
+void
+fw_core_handle_bus_reset(struct fw_card *card,
+			 int node_id, int generation,
+			 int self_id_count, u32 *self_ids);
+void
+fw_core_handle_request(struct fw_card *card, struct fw_packet *request);
+
+void
+fw_core_handle_response(struct fw_card *card, struct fw_packet *packet);
+
+#endif /* __fw_transaction_h */
Index: linux_juju/drivers/firewire/fw-transaction.c
===================================================================
--- /dev/null
+++ linux_juju/drivers/firewire/fw-transaction.c
@@ -0,0 +1,889 @@
+/*						-*- c-basic-offset: 8 -*-
+ *
+ * fw-transaction.c - core IEEE1394 transaction logic
+ *
+ * Copyright (C) 2004-2006 Kristian Hoegsberg <krh@bitplanet.net>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software Foundation,
+ * Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
+ */
+
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/init.h>
+#include <linux/interrupt.h>
+#include <linux/pci.h>
+#include <linux/delay.h>
+#include <linux/poll.h>
+#include <linux/list.h>
+#include <linux/kthread.h>
+#include <asm/uaccess.h>
+#include <asm/semaphore.h>
+
+#include "fw-transaction.h"
+#include "fw-topology.h"
+#include "fw-device.h"
+
+#define header_pri(pri)			((pri) << 0)
+#define header_tcode(tcode)		((tcode) << 4)
+#define header_retry(retry)		((retry) << 8)
+#define header_tlabel(tlabel)		((tlabel) << 10)
+#define header_destination(destination)	((destination) << 16)
+#define header_source(source)		((source) << 16)
+#define header_rcode(rcode)		((rcode) << 12)
+#define header_offset_high(offset_high)	((offset_high) << 0)
+#define header_data_length(length)	((length) << 16)
+#define header_extended_tcode(tcode)	((tcode) << 0)
+
+#define header_get_tcode(q)		(((q) >> 4) & 0x0f)
+#define header_get_tlabel(q)		(((q) >> 10) & 0x3f)
+#define header_get_rcode(q)		(((q) >> 12) & 0x0f)
+#define header_get_destination(q)	(((q) >> 16) & 0xffff)
+#define header_get_source(q)		(((q) >> 16) & 0xffff)
+#define header_get_offset_high(q)	(((q) >> 0) & 0xffff)
+#define header_get_data_length(q)	(((q) >> 16) & 0xffff)
+#define header_get_extended_tcode(q)	(((q) >> 0) & 0xffff)
+
+#define phy_config_gap_count(gap_count)	(((gap_count) << 16) | (1 << 22))
+#define phy_config_root_id(node_id)	((((node_id) & 0x3f) << 24) | (1 << 23))
+#define phy_identifier(id)		((id) << 30)
+
+static int
+close_transaction(struct fw_transaction *transaction,
+		  struct fw_card *card, int rcode,
+		  u32 *payload, size_t length)
+{
+	struct fw_transaction *t;
+	unsigned long flags;
+
+	spin_lock_irqsave(&card->lock, flags);
+	list_for_each_entry(t, &card->transaction_list, link) {
+		if (t == transaction) {
+			list_del(&t->link);
+			card->tlabel_mask &= ~(1 << t->tlabel);
+			break;
+		}
+	}
+	spin_unlock_irqrestore(&card->lock, flags);
+
+	if (&t->link != &card->transaction_list) {
+		t->callback(card, rcode, payload, length, t->callback_data);
+		return 0;
+	}
+
+	return -ENOENT;
+}
+
+/* Only valid for transactions that are potentially pending (ie have
+ * been sent). */
+int
+fw_cancel_transaction(struct fw_card *card,
+		      struct fw_transaction *transaction)
+{
+	/* Cancel the packet transmission if it's still queued.  That
+	 * will call the packet transmission callback which cancels
+	 * the transaction. */
+
+	if (card->driver->cancel_packet(card, &transaction->packet) == 0)
+		return 0;
+
+	/* If the request packet has already been sent, we need to see
+	 * if the transaction is still pending and remove it in that case. */
+
+	return close_transaction(transaction, card, RCODE_CANCELLED, NULL, 0);
+}
+EXPORT_SYMBOL(fw_cancel_transaction);
+
+static void
+transmit_complete_callback(struct fw_packet *packet,
+			   struct fw_card *card, int status)
+{
+	struct fw_transaction *t =
+	    container_of(packet, struct fw_transaction, packet);
+
+	switch (status) {
+	case ACK_COMPLETE:
+		close_transaction(t, card, RCODE_COMPLETE, NULL, 0);
+		break;
+	case ACK_PENDING:
+		t->timestamp = packet->timestamp;
+		break;
+	case ACK_BUSY_X:
+	case ACK_BUSY_A:
+	case ACK_BUSY_B:
+		close_transaction(t, card, RCODE_BUSY, NULL, 0);
+		break;
+	case ACK_DATA_ERROR:
+		close_transaction(t, card, RCODE_DATA_ERROR, NULL, 0);
+		break;
+	case ACK_TYPE_ERROR:
+		close_transaction(t, card, RCODE_TYPE_ERROR, NULL, 0);
+		break;
+	default:
+		/* In this case the ack is really a juju specific
+		 * rcode, so just forward that to the callback. */
+		close_transaction(t, card, status, NULL, 0);
+		break;
+	}
+}
+
+static void
+fw_fill_request(struct fw_packet *packet, int tcode, int tlabel,
+		int node_id, int source_id, int generation, int speed,
+		unsigned long long offset, void *payload, size_t length)
+{
+	int ext_tcode;
+
+	if (tcode > 0x10) {
+		ext_tcode = tcode - 0x10;
+		tcode = TCODE_LOCK_REQUEST;
+	} else
+		ext_tcode = 0;
+
+	packet->header[0] =
+		header_retry(RETRY_X) |
+		header_tlabel(tlabel) |
+		header_tcode(tcode) |
+		header_destination(node_id);
+	packet->header[1] =
+		header_offset_high(offset >> 32) | header_source(source_id);
+	packet->header[2] =
+		offset;
+
+	switch (tcode) {
+	case TCODE_WRITE_QUADLET_REQUEST:
+		packet->header[3] = *(u32 *)payload;
+		packet->header_length = 16;
+		packet->payload_length = 0;
+		break;
+
+	case TCODE_LOCK_REQUEST:
+	case TCODE_WRITE_BLOCK_REQUEST:
+		packet->header[3] =
+			header_data_length(length) |
+			header_extended_tcode(ext_tcode);
+		packet->header_length = 16;
+		packet->payload = payload;
+		packet->payload_length = length;
+		break;
+
+	case TCODE_READ_QUADLET_REQUEST:
+		packet->header_length = 12;
+		packet->payload_length = 0;
+		break;
+
+	case TCODE_READ_BLOCK_REQUEST:
+		packet->header[3] =
+			header_data_length(length) |
+			header_extended_tcode(ext_tcode);
+		packet->header_length = 16;
+		packet->payload_length = 0;
+		break;
+	}
+
+	packet->speed = speed;
+	packet->generation = generation;
+	packet->ack = 0;
+}
+
+/**
+ * This function provides low-level access to the IEEE1394 transaction
+ * logic.  Most C programs would use either fw_read(), fw_write() or
+ * fw_lock() instead - those function are convenience wrappers for
+ * this function.  The fw_send_request() function is primarily
+ * provided as a flexible, one-stop entry point for languages bindings
+ * and protocol bindings.
+ *
+ * FIXME: Document this function further, in particular the possible
+ * values for rcode in the callback.  In short, we map ACK_COMPLETE to
+ * RCODE_COMPLETE, internal errors set errno and set rcode to
+ * RCODE_SEND_ERROR (which is out of range for standard ieee1394
+ * rcodes).  All other rcodes are forwarded unchanged.  For all
+ * errors, payload is NULL, length is 0.
+ *
+ * Can not expect the callback to be called before the function
+ * returns, though this does happen in some cases (ACK_COMPLETE and
+ * errors).
+ *
+ * The payload is only used for write requests and must not be freed
+ * until the callback has been called.
+ *
+ * @param card the card from which to send the request
+ * @param tcode the tcode for this transaction.  Do not use
+ *   TCODE_LOCK_REQUEST directly, insted use TCODE_LOCK_MASK_SWAP
+ *   etc. to specify tcode and ext_tcode.
+ * @param node_id the destination node ID (bus ID and PHY ID concatenated)
+ * @param generation the generation for which node_id is valid
+ * @param speed the speed to use for sending the request
+ * @param offset the 48 bit offset on the destination node
+ * @param payload the data payload for the request subaction
+ * @param length the length in bytes of the data to read
+ * @param callback function to be called when the transaction is completed
+ * @param callback_data pointer to arbitrary data, which will be
+ *   passed to the callback
+ */
+void
+fw_send_request(struct fw_card *card, struct fw_transaction *t,
+		int tcode, int node_id, int generation, int speed,
+		unsigned long long offset,
+		void *payload, size_t length,
+		fw_transaction_callback_t callback, void *callback_data)
+{
+	unsigned long flags;
+	int tlabel, source;
+
+	/* Bump the flush timer up 100ms first of all so we
+	 * don't race with a flush timer callback. */
+
+	mod_timer(&card->flush_timer, jiffies + DIV_ROUND_UP(HZ, 10));
+
+	/* Allocate tlabel from the bitmap and put the transaction on
+	 * the list while holding the card spinlock. */
+
+	spin_lock_irqsave(&card->lock, flags);
+
+	source = card->node_id;
+	tlabel = card->current_tlabel;
+	if (card->tlabel_mask & (1 << tlabel)) {
+		spin_unlock_irqrestore(&card->lock, flags);
+		callback(card, RCODE_SEND_ERROR, NULL, 0, callback_data);
+		return;
+	}
+
+	card->current_tlabel = (card->current_tlabel + 1) & 0x1f;
+	card->tlabel_mask |= (1 << tlabel);
+
+	list_add_tail(&t->link, &card->transaction_list);
+
+	spin_unlock_irqrestore(&card->lock, flags);
+
+	/* Initialize rest of transaction, fill out packet and send it. */
+	t->node_id = node_id;
+	t->tlabel = tlabel;
+	t->callback = callback;
+	t->callback_data = callback_data;
+
+	fw_fill_request(&t->packet, tcode, t->tlabel,
+			node_id, source, generation,
+			speed, offset, payload, length);
+	t->packet.callback = transmit_complete_callback;
+
+	card->driver->send_request(card, &t->packet);
+}
+EXPORT_SYMBOL(fw_send_request);
+
+static void
+transmit_phy_packet_callback(struct fw_packet *packet,
+			     struct fw_card *card, int status)
+{
+	kfree(packet);
+}
+
+static void send_phy_packet(struct fw_card *card, u32 data, int generation)
+{
+	struct fw_packet *packet;
+
+	packet = kzalloc(sizeof *packet, GFP_ATOMIC);
+	if (packet == NULL)
+		return;
+
+	packet->header[0] = data;
+	packet->header[1] = ~data;
+	packet->header_length = 8;
+	packet->payload_length = 0;
+	packet->speed = SCODE_100;
+	packet->generation = generation;
+	packet->callback = transmit_phy_packet_callback;
+
+	card->driver->send_request(card, packet);
+}
+
+void fw_send_phy_config(struct fw_card *card,
+			int node_id, int generation, int gap_count)
+{
+	u32 q;
+
+	q = phy_identifier(PHY_PACKET_CONFIG) |
+		phy_config_root_id(node_id) |
+		phy_config_gap_count(gap_count);
+
+	send_phy_packet(card, q, generation);
+}
+
+void fw_flush_transactions(struct fw_card *card)
+{
+	struct fw_transaction *t, *next;
+	struct list_head list;
+	unsigned long flags;
+
+	INIT_LIST_HEAD(&list);
+	spin_lock_irqsave(&card->lock, flags);
+	list_splice_init(&card->transaction_list, &list);
+	card->tlabel_mask = 0;
+	spin_unlock_irqrestore(&card->lock, flags);
+
+	list_for_each_entry_safe(t, next, &list, link) {
+		card->driver->cancel_packet(card, &t->packet);
+
+		/* At this point cancel_packet will never call the
+		 * transaction callback, since we just took all the
+		 * transactions out of the list.  So do it here.*/
+		t->callback(card, RCODE_CANCELLED, NULL, 0, t->callback_data);
+	}
+}
+
+static struct fw_address_handler *
+lookup_overlapping_address_handler(struct list_head *list,
+				   unsigned long long offset, size_t length)
+{
+	struct fw_address_handler *handler;
+
+	list_for_each_entry(handler, list, link) {
+		if (handler->offset < offset + length &&
+		    offset < handler->offset + handler->length)
+			return handler;
+	}
+
+	return NULL;
+}
+
+static struct fw_address_handler *
+lookup_enclosing_address_handler(struct list_head *list,
+				 unsigned long long offset, size_t length)
+{
+	struct fw_address_handler *handler;
+
+	list_for_each_entry(handler, list, link) {
+		if (handler->offset <= offset &&
+		    offset + length <= handler->offset + handler->length)
+			return handler;
+	}
+
+	return NULL;
+}
+
+static DEFINE_SPINLOCK(address_handler_lock);
+static LIST_HEAD(address_handler_list);
+
+const struct fw_address_region fw_low_memory_region =
+	{ .start = 0x000000000000ULL, .end = 0x000100000000ULL,  };
+const struct fw_address_region fw_high_memory_region =
+	{ .start = 0x000100000000ULL, .end = 0xffffe0000000ULL,  };
+const struct fw_address_region fw_private_region =
+	{ .start = 0xffffe0000000ULL, .end = 0xfffff0000000ULL,  };
+const struct fw_address_region fw_csr_region =
+	{ .start = 0xfffff0000000ULL, .end = 0xfffff0000800ULL,  };
+const struct fw_address_region fw_unit_space_region =
+	{ .start = 0xfffff0000900ULL, .end = 0x1000000000000ULL, };
+EXPORT_SYMBOL(fw_low_memory_region);
+EXPORT_SYMBOL(fw_high_memory_region);
+EXPORT_SYMBOL(fw_private_region);
+EXPORT_SYMBOL(fw_csr_region);
+EXPORT_SYMBOL(fw_unit_space_region);
+
+/**
+ * Allocate a range of addresses in the node space of the OHCI
+ * controller.  When a request is received that falls within the
+ * specified address range, the specified callback is invoked.  The
+ * parameters passed to the callback give the details of the
+ * particular request
+ */
+int
+fw_core_add_address_handler(struct fw_address_handler *handler,
+			    const struct fw_address_region *region)
+{
+	struct fw_address_handler *other;
+	unsigned long flags;
+	int ret = -EBUSY;
+
+	spin_lock_irqsave(&address_handler_lock, flags);
+
+	handler->offset = region->start;
+	while (handler->offset + handler->length <= region->end) {
+		other =
+		    lookup_overlapping_address_handler(&address_handler_list,
+						       handler->offset,
+						       handler->length);
+		if (other != NULL) {
+			handler->offset += other->length;
+		} else {
+			list_add_tail(&handler->link, &address_handler_list);
+			ret = 0;
+			break;
+		}
+	}
+
+	spin_unlock_irqrestore(&address_handler_lock, flags);
+
+	return ret;
+}
+EXPORT_SYMBOL(fw_core_add_address_handler);
+
+/**
+ * Deallocate a range of addresses allocated with fw_allocate.  This
+ * will call the associated callback one last time with a the special
+ * tcode TCODE_DEALLOCATE, to let the client destroy the registered
+ * callback data.  For convenience, the callback parameters offset and
+ * length are set to the start and the length respectively for the
+ * deallocated region, payload is set to NULL.
+ */
+void fw_core_remove_address_handler(struct fw_address_handler *handler)
+{
+	unsigned long flags;
+
+	spin_lock_irqsave(&address_handler_lock, flags);
+	list_del(&handler->link);
+	spin_unlock_irqrestore(&address_handler_lock, flags);
+}
+EXPORT_SYMBOL(fw_core_remove_address_handler);
+
+struct fw_request {
+	struct fw_packet response;
+	u32 request_header[4];
+	int ack;
+	u32 length;
+	u32 data[0];
+};
+
+static void
+free_response_callback(struct fw_packet *packet,
+		       struct fw_card *card, int status)
+{
+	struct fw_request *request;
+
+	request = container_of(packet, struct fw_request, response);
+	kfree(request);
+}
+
+void
+fw_fill_response(struct fw_packet *response, u32 *request_header,
+		 int rcode, void *payload, size_t length)
+{
+	int tcode, tlabel, extended_tcode, source, destination;
+
+	tcode          = header_get_tcode(request_header[0]);
+	tlabel         = header_get_tlabel(request_header[0]);
+	source         = header_get_destination(request_header[0]);
+	destination    = header_get_source(request_header[1]);
+	extended_tcode = header_get_extended_tcode(request_header[3]);
+
+	response->header[0] =
+		header_retry(RETRY_1) |
+		header_tlabel(tlabel) |
+		header_destination(destination);
+	response->header[1] =
+		header_source(source) |
+		header_rcode(rcode);
+	response->header[2] = 0;
+
+	switch (tcode) {
+	case TCODE_WRITE_QUADLET_REQUEST:
+	case TCODE_WRITE_BLOCK_REQUEST:
+		response->header[0] |= header_tcode(TCODE_WRITE_RESPONSE);
+		response->header_length = 12;
+		response->payload_length = 0;
+		break;
+
+	case TCODE_READ_QUADLET_REQUEST:
+		response->header[0] |=
+			header_tcode(TCODE_READ_QUADLET_RESPONSE);
+		if (payload != NULL)
+			response->header[3] = *(u32 *)payload;
+		else
+			response->header[3] = 0;
+		response->header_length = 16;
+		response->payload_length = 0;
+		break;
+
+	case TCODE_READ_BLOCK_REQUEST:
+	case TCODE_LOCK_REQUEST:
+		response->header[0] |= header_tcode(tcode + 2);
+		response->header[3] =
+			header_data_length(length) |
+			header_extended_tcode(extended_tcode);
+		response->header_length = 16;
+		response->payload = payload;
+		response->payload_length = length;
+		break;
+
+	default:
+		BUG();
+		return;
+	}
+}
+EXPORT_SYMBOL(fw_fill_response);
+
+static struct fw_request *
+allocate_request(struct fw_packet *p)
+{
+	struct fw_request *request;
+	u32 *data, length;
+	int request_tcode, t;
+
+	request_tcode = header_get_tcode(p->header[0]);
+	switch (request_tcode) {
+	case TCODE_WRITE_QUADLET_REQUEST:
+		data = &p->header[3];
+		length = 4;
+		break;
+
+	case TCODE_WRITE_BLOCK_REQUEST:
+	case TCODE_LOCK_REQUEST:
+		data = p->payload;
+		length = header_get_data_length(p->header[3]);
+		break;
+
+	case TCODE_READ_QUADLET_REQUEST:
+		data = NULL;
+		length = 4;
+		break;
+
+	case TCODE_READ_BLOCK_REQUEST:
+		data = NULL;
+		length = header_get_data_length(p->header[3]);
+		break;
+
+	default:
+		BUG();
+		return NULL;
+	}
+
+	request = kmalloc(sizeof *request + length, GFP_ATOMIC);
+	if (request == NULL)
+		return NULL;
+
+	t = (p->timestamp & 0x1fff) + 4000;
+	if (t >= 8000)
+		t = (p->timestamp & ~0x1fff) + 0x2000 + t - 8000;
+	else
+		t = (p->timestamp & ~0x1fff) + t;
+
+	request->response.speed = p->speed;
+	request->response.timestamp = t;
+	request->response.generation = p->generation;
+	request->response.ack = 0;
+	request->response.callback = free_response_callback;
+	request->ack = p->ack;
+	request->length = length;
+	if (data)
+		memcpy(request->data, data, length);
+
+	memcpy(request->request_header, p->header, sizeof p->header);
+
+	return request;
+}
+
+void
+fw_send_response(struct fw_card *card, struct fw_request *request, int rcode)
+{
+	/* Broadcast packets are reported as ACK_COMPLETE, so this
+	 * check is sufficient to ensure we don't send response to
+	 * broadcast packets or posted writes. */
+	if (request->ack != ACK_PENDING)
+		return;
+
+	if (rcode == RCODE_COMPLETE)
+		fw_fill_response(&request->response, request->request_header,
+				 rcode, request->data, request->length);
+	else
+		fw_fill_response(&request->response, request->request_header,
+				 rcode, NULL, 0);
+
+	card->driver->send_response(card, &request->response);
+}
+EXPORT_SYMBOL(fw_send_response);
+
+void
+fw_core_handle_request(struct fw_card *card, struct fw_packet *p)
+{
+	struct fw_address_handler *handler;
+	struct fw_request *request;
+	unsigned long long offset;
+	unsigned long flags;
+	int tcode, destination, source;
+
+	if (p->payload_length > 2048) {
+		/* FIXME: send error response. */
+		return;
+	}
+
+	if (p->ack != ACK_PENDING && p->ack != ACK_COMPLETE)
+		return;
+
+	request = allocate_request(p);
+	if (request == NULL) {
+		/* FIXME: send statically allocated busy packet. */
+		return;
+	}
+
+	offset      =
+		((unsigned long long)
+		 header_get_offset_high(p->header[1]) << 32) | p->header[2];
+	tcode       = header_get_tcode(p->header[0]);
+	destination = header_get_destination(p->header[0]);
+	source      = header_get_source(p->header[0]);
+
+	spin_lock_irqsave(&address_handler_lock, flags);
+	handler = lookup_enclosing_address_handler(&address_handler_list,
+						   offset, request->length);
+	spin_unlock_irqrestore(&address_handler_lock, flags);
+
+	/* FIXME: lookup the fw_node corresponding to the sender of
+	 * this request and pass that to the address handler instead
+	 * of the node ID.  We may also want to move the address
+	 * allocations to fw_node so we only do this callback if the
+	 * upper layers registered it for this node. */
+
+	if (handler == NULL)
+		fw_send_response(card, request, RCODE_ADDRESS_ERROR);
+	else
+		handler->address_callback(card, request,
+					  tcode, destination, source,
+					  p->generation, p->speed, offset,
+					  request->data, request->length,
+					  handler->callback_data);
+}
+EXPORT_SYMBOL(fw_core_handle_request);
+
+void
+fw_core_handle_response(struct fw_card *card, struct fw_packet *p)
+{
+	struct fw_transaction *t;
+	unsigned long flags;
+	u32 *data;
+	size_t data_length;
+	int tcode, tlabel, destination, source, rcode;
+
+	tcode       = header_get_tcode(p->header[0]);
+	tlabel      = header_get_tlabel(p->header[0]);
+	destination = header_get_destination(p->header[0]);
+	source      = header_get_source(p->header[1]);
+	rcode       = header_get_rcode(p->header[1]);
+
+	spin_lock_irqsave(&card->lock, flags);
+	list_for_each_entry(t, &card->transaction_list, link) {
+		if (t->node_id == source && t->tlabel == tlabel) {
+			list_del(&t->link);
+			card->tlabel_mask &= ~(1 << t->tlabel);
+			break;
+		}
+	}
+	spin_unlock_irqrestore(&card->lock, flags);
+
+	if (&t->link == &card->transaction_list) {
+		fw_notify("Unsolicited response (source %x, tlabel %x)\n",
+			  source, tlabel);
+		return;
+	}
+
+	/* FIXME: sanity check packet, is length correct, does tcodes
+	 * and addresses match. */
+
+	switch (tcode) {
+	case TCODE_READ_QUADLET_RESPONSE:
+		data = (u32 *) &p->header[3];
+		data_length = 4;
+		break;
+
+	case TCODE_WRITE_RESPONSE:
+		data = NULL;
+		data_length = 0;
+		break;
+
+	case TCODE_READ_BLOCK_RESPONSE:
+	case TCODE_LOCK_RESPONSE:
+		data = p->payload;
+		data_length = header_get_data_length(p->header[3]);
+		break;
+
+	default:
+		/* Should never happen, this is just to shut up gcc. */
+		data = NULL;
+		data_length = 0;
+		break;
+	}
+
+	t->callback(card, rcode, data, data_length, t->callback_data);
+}
+EXPORT_SYMBOL(fw_core_handle_response);
+
+const struct fw_address_region topology_map_region =
+	{ .start = 0xfffff0001000ull, .end = 0xfffff0001400ull, };
+
+static void
+handle_topology_map(struct fw_card *card, struct fw_request *request,
+		    int tcode, int destination, int source,
+		    int generation, int speed,
+		    unsigned long long offset,
+		    void *payload, size_t length, void *callback_data)
+{
+	int i, start, end;
+	u32 *map;
+
+	if (!TCODE_IS_READ_REQUEST(tcode)) {
+		fw_send_response(card, request, RCODE_TYPE_ERROR);
+		return;
+	}
+
+	if ((offset & 3) > 0 || (length & 3) > 0) {
+		fw_send_response(card, request, RCODE_ADDRESS_ERROR);
+		return;
+	}
+
+	start = (offset - topology_map_region.start) / 4;
+	end = start + length / 4;
+	map = payload;
+
+	for (i = 0; i < length / 4; i++)
+		map[i] = cpu_to_be32(card->topology_map[start + i]);
+
+	fw_send_response(card, request, RCODE_COMPLETE);
+}
+
+static struct fw_address_handler topology_map = {
+	.length			= 0x200,
+	.address_callback	= handle_topology_map,
+};
+
+const struct fw_address_region registers_region =
+	{ .start = 0xfffff0000000ull, .end = 0xfffff0000400ull, };
+
+static void
+handle_registers(struct fw_card *card, struct fw_request *request,
+		 int tcode, int destination, int source,
+		 int generation, int speed,
+		 unsigned long long offset,
+		 void *payload, size_t length, void *callback_data)
+{
+	int reg = offset - CSR_REGISTER_BASE;
+	unsigned long long bus_time;
+	__be32 *data = payload;
+
+	switch (reg) {
+	case CSR_CYCLE_TIME:
+	case CSR_BUS_TIME:
+		if (!TCODE_IS_READ_REQUEST(tcode) || length != 4) {
+			fw_send_response(card, request, RCODE_TYPE_ERROR);
+			break;
+		}
+
+		bus_time = card->driver->get_bus_time(card);
+		if (reg == CSR_CYCLE_TIME)
+			*data = cpu_to_be32(bus_time);
+		else
+			*data = cpu_to_be32(bus_time >> 25);
+		fw_send_response(card, request, RCODE_COMPLETE);
+		break;
+
+	case CSR_BUS_MANAGER_ID:
+	case CSR_BANDWIDTH_AVAILABLE:
+	case CSR_CHANNELS_AVAILABLE_HI:
+	case CSR_CHANNELS_AVAILABLE_LO:
+		/* FIXME: these are handled by the OHCI hardware and
+		 * the stack never sees these request. If we add
+		 * support for a new type of controller that doesn't
+		 * handle this in hardware we need to deal with these
+		 * transactions. */
+		BUG();
+		break;
+
+	case CSR_BUSY_TIMEOUT:
+		/* FIXME: Implement this. */
+	default:
+		fw_send_response(card, request, RCODE_ADDRESS_ERROR);
+		break;
+	}
+}
+
+static struct fw_address_handler registers = {
+	.length			= 0x400,
+	.address_callback	= handle_registers,
+};
+
+MODULE_AUTHOR("Kristian Hoegsberg <krh@bitplanet.net>");
+MODULE_DESCRIPTION("Core IEEE1394 transaction logic");
+MODULE_LICENSE("GPL");
+
+static const u32 vendor_textual_descriptor[] = {
+	/* textual descriptor leaf () */
+	0x00060000,
+	0x00000000,
+	0x00000000,
+	0x4c696e75,		/* L i n u */
+	0x78204669,		/* x   F i */
+	0x72657769,		/* r e w i */
+	0x72650000,		/* r e     */
+};
+
+static const u32 model_textual_descriptor[] = {
+	/* model descriptor leaf () */
+	0x00030000,
+	0x00000000,
+	0x00000000,
+	0x4a756a75,		/* J u j u */
+};
+
+static struct fw_descriptor vendor_id_descriptor = {
+	.length = ARRAY_SIZE(vendor_textual_descriptor),
+	.immediate = 0x03d00d1e,
+	.key = 0x81000000,
+	.data = vendor_textual_descriptor,
+};
+
+static struct fw_descriptor model_id_descriptor = {
+	.length = ARRAY_SIZE(model_textual_descriptor),
+	.immediate = 0x17000001,
+	.key = 0x81000000,
+	.data = model_textual_descriptor,
+};
+
+static int __init fw_core_init(void)
+{
+	int retval;
+
+	retval = bus_register(&fw_bus_type);
+	if (retval < 0)
+		return retval;
+
+	fw_cdev_major = register_chrdev(0, "firewire", &fw_device_ops);
+	if (fw_cdev_major < 0) {
+		bus_unregister(&fw_bus_type);
+		return fw_cdev_major;
+	}
+
+	retval = fw_core_add_address_handler(&topology_map,
+					     &topology_map_region);
+	BUG_ON(retval < 0);
+
+	retval = fw_core_add_address_handler(&registers,
+					     &registers_region);
+	BUG_ON(retval < 0);
+
+	/* Add the vendor textual descriptor. */
+	retval = fw_core_add_descriptor(&vendor_id_descriptor);
+	BUG_ON(retval < 0);
+	retval = fw_core_add_descriptor(&model_id_descriptor);
+	BUG_ON(retval < 0);
+
+	return 0;
+}
+
+static void __exit fw_core_cleanup(void)
+{
+	unregister_chrdev(fw_cdev_major, "firewire");
+	bus_unregister(&fw_bus_type);
+}
+
+module_init(fw_core_init);
+module_exit(fw_core_cleanup);

-- 
Stefan Richter
-=====-=-=== -=-= ---=-
http://arcgraph.de/sr/

