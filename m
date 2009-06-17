Return-Path: <linux-kernel-owner+w=401wt.eu-S932127AbZFQRr1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932127AbZFQRr1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jun 2009 13:47:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752487AbZFQRrS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Jun 2009 13:47:18 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:60078 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758358AbZFQRrR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jun 2009 13:47:17 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Wed, 17 Jun 2009 19:47:02 +0200 (CEST)
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: What's in linux1394-2.6.git? -- Part II.1/3
To: linux-kernel@vger.kernel.org
cc: linux1394-devel@lists.sourceforge.net
In-Reply-To: <tkrat.c0f2f763744b1215@s5r6.in-berlin.de>
Message-ID: <tkrat.027908636dd71025@s5r6.in-berlin.de>
References: <tkrat.70eb865eb2fae29b@s5r6.in-berlin.de>
 <tkrat.c0f2f763744b1215@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=us-ascii
Content-Disposition: INLINE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the part of linux1394-2.6.git's current for-linus..for-next
combined diff which affects firewire-core:  Bug fixes and preparation to
add firewire-net.
---
 drivers/firewire/core-card.c |   20 +++++---
 drivers/firewire/core-iso.c  |   11 +++-
 drivers/firewire/core.h      |   87 -----------------------------------
 include/linux/firewire.h     |   87 +++++++++++++++++++++++++++++++++++
 4 files changed, 109 insertions(+), 96 deletions(-)

Index: b/drivers/firewire/core-card.c
===================================================================
--- a/drivers/firewire/core-card.c
+++ b/drivers/firewire/core-card.c
@@ -176,6 +176,7 @@ int fw_core_add_descriptor(struct fw_des
 
 	return 0;
 }
+EXPORT_SYMBOL(fw_core_add_descriptor);
 
 void fw_core_remove_descriptor(struct fw_descriptor *desc)
 {
@@ -189,6 +190,7 @@ void fw_core_remove_descriptor(struct fw
 
 	mutex_unlock(&card_mutex);
 }
+EXPORT_SYMBOL(fw_core_remove_descriptor);
 
 static void allocate_broadcast_channel(struct fw_card *card, int generation)
 {
@@ -459,11 +461,11 @@ EXPORT_SYMBOL(fw_card_add);
 
 
 /*
- * The next few functions implements a dummy driver that use once a
- * card driver shuts down an fw_card.  This allows the driver to
- * cleanly unload, as all IO to the card will be handled by the dummy
- * driver instead of calling into the (possibly) unloaded module.  The
- * dummy driver just fails all IO.
+ * The next few functions implement a dummy driver that is used once a card
+ * driver shuts down an fw_card.  This allows the driver to cleanly unload,
+ * as all IO to the card will be handled (and failed) by the dummy driver
+ * instead of calling into the module.  Only functions for iso context
+ * shutdown still need to be provided by the card driver.
  */
 
 static int dummy_enable(struct fw_card *card, u32 *config_rom, size_t length)
@@ -510,7 +512,7 @@ static int dummy_enable_phys_dma(struct 
 	return -ENODEV;
 }
 
-static struct fw_card_driver dummy_driver = {
+static const struct fw_card_driver dummy_driver_template = {
 	.enable          = dummy_enable,
 	.update_phy_reg  = dummy_update_phy_reg,
 	.set_config_rom  = dummy_set_config_rom,
@@ -529,6 +531,8 @@ void fw_card_release(struct kref *kref)
 
 void fw_core_remove_card(struct fw_card *card)
 {
+	struct fw_card_driver dummy_driver = dummy_driver_template;
+
 	card->driver->update_phy_reg(card, 4,
 				     PHY_LINK_ACTIVE | PHY_CONTENDER, 0);
 	fw_core_initiate_bus_reset(card, 1);
@@ -537,7 +541,9 @@ void fw_core_remove_card(struct fw_card 
 	list_del_init(&card->link);
 	mutex_unlock(&card_mutex);
 
-	/* Set up the dummy driver. */
+	/* Switch off most of the card driver interface. */
+	dummy_driver.free_iso_context	= card->driver->free_iso_context;
+	dummy_driver.stop_iso		= card->driver->stop_iso;
 	card->driver = &dummy_driver;
 
 	fw_destroy_nodes(card);
Index: b/drivers/firewire/core-iso.c
===================================================================
--- a/drivers/firewire/core-iso.c
+++ b/drivers/firewire/core-iso.c
@@ -71,7 +71,7 @@ int fw_iso_buffer_init(struct fw_iso_buf
 	for (j = 0; j < i; j++) {
 		address = page_private(buffer->pages[j]);
 		dma_unmap_page(card->device, address,
-			       PAGE_SIZE, DMA_TO_DEVICE);
+			       PAGE_SIZE, direction);
 		__free_page(buffer->pages[j]);
 	}
 	kfree(buffer->pages);
@@ -80,6 +80,7 @@ int fw_iso_buffer_init(struct fw_iso_buf
 
 	return -ENOMEM;
 }
+EXPORT_SYMBOL(fw_iso_buffer_init);
 
 int fw_iso_buffer_map(struct fw_iso_buffer *buffer, struct vm_area_struct *vma)
 {
@@ -107,13 +108,14 @@ void fw_iso_buffer_destroy(struct fw_iso
 	for (i = 0; i < buffer->page_count; i++) {
 		address = page_private(buffer->pages[i]);
 		dma_unmap_page(card->device, address,
-			       PAGE_SIZE, DMA_TO_DEVICE);
+			       PAGE_SIZE, buffer->direction);
 		__free_page(buffer->pages[i]);
 	}
 
 	kfree(buffer->pages);
 	buffer->pages = NULL;
 }
+EXPORT_SYMBOL(fw_iso_buffer_destroy);
 
 struct fw_iso_context *fw_iso_context_create(struct fw_card *card,
 		int type, int channel, int speed, size_t header_size,
@@ -136,6 +138,7 @@ struct fw_iso_context *fw_iso_context_cr
 
 	return ctx;
 }
+EXPORT_SYMBOL(fw_iso_context_create);
 
 void fw_iso_context_destroy(struct fw_iso_context *ctx)
 {
@@ -143,12 +146,14 @@ void fw_iso_context_destroy(struct fw_is
 
 	card->driver->free_iso_context(ctx);
 }
+EXPORT_SYMBOL(fw_iso_context_destroy);
 
 int fw_iso_context_start(struct fw_iso_context *ctx,
 			 int cycle, int sync, int tags)
 {
 	return ctx->card->driver->start_iso(ctx, cycle, sync, tags);
 }
+EXPORT_SYMBOL(fw_iso_context_start);
 
 int fw_iso_context_queue(struct fw_iso_context *ctx,
 			 struct fw_iso_packet *packet,
@@ -159,11 +164,13 @@ int fw_iso_context_queue(struct fw_iso_c
 
 	return card->driver->queue_iso(ctx, packet, buffer, payload);
 }
+EXPORT_SYMBOL(fw_iso_context_queue);
 
 int fw_iso_context_stop(struct fw_iso_context *ctx)
 {
 	return ctx->card->driver->stop_iso(ctx);
 }
+EXPORT_SYMBOL(fw_iso_context_stop);
 
 /*
  * Isochronous bus resource management (channels, bandwidth), client side
Index: b/drivers/firewire/core.h
===================================================================
--- a/drivers/firewire/core.h
+++ b/drivers/firewire/core.h
@@ -1,7 +1,6 @@
 #ifndef _FIREWIRE_CORE_H
 #define _FIREWIRE_CORE_H
 
-#include <linux/dma-mapping.h>
 #include <linux/fs.h>
 #include <linux/list.h>
 #include <linux/idr.h>
@@ -97,17 +96,6 @@ int fw_core_initiate_bus_reset(struct fw
 int fw_compute_block_crc(u32 *block);
 void fw_schedule_bm_work(struct fw_card *card, unsigned long delay);
 
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
 
 /* -cdev */
 
@@ -130,77 +118,7 @@ void fw_node_event(struct fw_card *card,
 
 /* -iso */
 
-/*
- * The iso packet format allows for an immediate header/payload part
- * stored in 'header' immediately after the packet info plus an
- * indirect payload part that is pointer to by the 'payload' field.
- * Applications can use one or the other or both to implement simple
- * low-bandwidth streaming (e.g. audio) or more advanced
- * scatter-gather streaming (e.g. assembling video frame automatically).
- */
-struct fw_iso_packet {
-	u16 payload_length;	/* Length of indirect payload. */
-	u32 interrupt:1;	/* Generate interrupt on this packet */
-	u32 skip:1;		/* Set to not send packet at all. */
-	u32 tag:2;
-	u32 sy:4;
-	u32 header_length:8;	/* Length of immediate header. */
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
-/*
- * An iso buffer is just a set of pages mapped for DMA in the
- * specified direction.  Since the pages are to be used for DMA, they
- * are not mapped into the kernel virtual address space.  We store the
- * DMA address in the page private. The helper function
- * fw_iso_buffer_map() will map the pages into a given vma.
- */
-struct fw_iso_buffer {
-	enum dma_data_direction direction;
-	struct page **pages;
-	int page_count;
-};
-
-typedef void (*fw_iso_callback_t)(struct fw_iso_context *context,
-				  u32 cycle, size_t header_length,
-				  void *header, void *data);
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
 int fw_iso_buffer_map(struct fw_iso_buffer *buffer, struct vm_area_struct *vma);
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
 void fw_iso_resource_manage(struct fw_card *card, int generation,
 		u64 channels_mask, int *channel, int *bandwidth, bool allocate);
 
@@ -285,9 +203,4 @@ void fw_flush_transactions(struct fw_car
 void fw_send_phy_config(struct fw_card *card,
 			int node_id, int generation, int gap_count);
 
-static inline int fw_stream_packet_destination_id(int tag, int channel, int sy)
-{
-	return tag << 14 | channel << 8 | sy;
-}
-
 #endif /* _FIREWIRE_CORE_H */
Index: b/include/linux/firewire.h
===================================================================
--- a/include/linux/firewire.h
+++ b/include/linux/firewire.h
@@ -3,6 +3,7 @@
 
 #include <linux/completion.h>
 #include <linux/device.h>
+#include <linux/dma-mapping.h>
 #include <linux/kernel.h>
 #include <linux/kref.h>
 #include <linux/list.h>
@@ -355,4 +356,90 @@ int fw_run_transaction(struct fw_card *c
 		       int generation, int speed, unsigned long long offset,
 		       void *payload, size_t length);
 
+static inline int fw_stream_packet_destination_id(int tag, int channel, int sy)
+{
+	return tag << 14 | channel << 8 | sy;
+}
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
+int fw_iso_buffer_init(struct fw_iso_buffer *buffer, struct fw_card *card,
+		       int page_count, enum dma_data_direction direction);
+void fw_iso_buffer_destroy(struct fw_iso_buffer *buffer, struct fw_card *card);
+
+struct fw_iso_context;
+typedef void (*fw_iso_callback_t)(struct fw_iso_context *context,
+				  u32 cycle, size_t header_length,
+				  void *header, void *data);
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
 #endif /* _LINUX_FIREWIRE_H */

-- 
Stefan Richter
-=====-==--= -==- =---=
http://arcgraph.de/sr/

