Return-Path: <linux-kernel-owner+w=401wt.eu-S1756127AbZJGWoG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756127AbZJGWoG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Oct 2009 18:44:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755498AbZJGWoF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Oct 2009 18:44:05 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:44060 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755677AbZJGWoD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Oct 2009 18:44:03 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Thu, 8 Oct 2009 00:42:53 +0200 (CEST)
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: [PATCH 8/8] firewire: core: optimize Topology Map creation
To: linux1394-devel@lists.sourceforge.net
cc: linux-kernel@vger.kernel.org
In-Reply-To: <tkrat.27888275592fd267@s5r6.in-berlin.de>
Message-ID: <tkrat.2d203c48cd66e49c@s5r6.in-berlin.de>
References: <tkrat.27888275592fd267@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=us-ascii
Content-Disposition: INLINE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The Topology Map of the local node was created in CPU byte order,
then a temporary big endian copy was created to compute the CRC,
and when a read request to the Topology Map arrived it had to be
converted to big endian byte order again.

We now generate it in big endian byte order in the first place.
This also rids us of 1000 bytes stack usage in tasklet context.

Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
---
 drivers/firewire/core-card.c        |   17 ++---------------
 drivers/firewire/core-topology.c    |   17 ++++++++++-------
 drivers/firewire/core-transaction.c |    9 ++-------
 drivers/firewire/core.h             |    2 +-
 include/linux/firewire.h            |    2 +-
 5 files changed, 16 insertions(+), 31 deletions(-)

Index: linux-2.6.31/drivers/firewire/core-card.c
===================================================================
--- linux-2.6.31.orig/drivers/firewire/core-card.c
+++ linux-2.6.31/drivers/firewire/core-card.c
@@ -38,7 +38,7 @@
 
 #include "core.h"
 
-static int __compute_block_crc(__be32 *block)
+int fw_compute_block_crc(__be32 *block)
 {
 	int length;
 	u16 crc;
@@ -50,19 +50,6 @@ static int __compute_block_crc(__be32 *b
 	return length;
 }
 
-int fw_compute_block_crc(u32 *block)
-{
-	__be32 be32_block[256];
-	int i, length;
-
-	length = (*block >> 16) & 0xff;
-	for (i = 0; i < length; i++)
-		be32_block[i] = cpu_to_be32(block[i + 1]);
-	*block |= crc_itu_t(0, (u8 *) be32_block, length * 4);
-
-	return length;
-}
-
 static DEFINE_MUTEX(card_mutex);
 static LIST_HEAD(card_list);
 
@@ -141,7 +128,7 @@ static size_t generate_config_rom(struct
 	 * the bus info block, which is always the case for this
 	 * implementation. */
 	for (i = 0; i < j; i += length + 1)
-		length = __compute_block_crc(config_rom + i);
+		length = fw_compute_block_crc(config_rom + i);
 
 	return j;
 }
Index: linux-2.6.31/drivers/firewire/core-topology.c
===================================================================
--- linux-2.6.31.orig/drivers/firewire/core-topology.c
+++ linux-2.6.31/drivers/firewire/core-topology.c
@@ -28,9 +28,9 @@
 #include <linux/module.h>
 #include <linux/slab.h>
 #include <linux/spinlock.h>
-#include <linux/string.h>
 
 #include <asm/atomic.h>
+#include <asm/byteorder.h>
 #include <asm/system.h>
 
 #include "core.h"
@@ -510,13 +510,16 @@ static void update_tree(struct fw_card *
 static void update_topology_map(struct fw_card *card,
 				u32 *self_ids, int self_id_count)
 {
-	int node_count;
+	int node_count = (card->root_node->node_id & 0x3f) + 1;
+	__be32 *map = card->topology_map;
+
+	*map++ = cpu_to_be32((self_id_count + 2) << 16);
+	*map++ = cpu_to_be32(be32_to_cpu(card->topology_map[1]) + 1);
+	*map++ = cpu_to_be32((node_count << 16) | self_id_count);
+
+	while (self_id_count--)
+		*map++ = cpu_to_be32p(self_ids++);
 
-	card->topology_map[1]++;
-	node_count = (card->root_node->node_id & 0x3f) + 1;
-	card->topology_map[2] = (node_count << 16) | self_id_count;
-	card->topology_map[0] = (self_id_count + 2) << 16;
-	memcpy(&card->topology_map[3], self_ids, self_id_count * 4);
 	fw_compute_block_crc(card->topology_map);
 }
 
Index: linux-2.6.31/drivers/firewire/core-transaction.c
===================================================================
--- linux-2.6.31.orig/drivers/firewire/core-transaction.c
+++ linux-2.6.31/drivers/firewire/core-transaction.c
@@ -810,8 +810,7 @@ static void handle_topology_map(struct f
 		int speed, unsigned long long offset,
 		void *payload, size_t length, void *callback_data)
 {
-	int i, start, end;
-	__be32 *map;
+	int start;
 
 	if (!TCODE_IS_READ_REQUEST(tcode)) {
 		fw_send_response(card, request, RCODE_TYPE_ERROR);
@@ -824,11 +823,7 @@ static void handle_topology_map(struct f
 	}
 
 	start = (offset - topology_map_region.start) / 4;
-	end = start + length / 4;
-	map = payload;
-
-	for (i = 0; i < length / 4; i++)
-		map[i] = cpu_to_be32(card->topology_map[start + i]);
+	memcpy(payload, &card->topology_map[start], length);
 
 	fw_send_response(card, request, RCODE_COMPLETE);
 }
Index: linux-2.6.31/drivers/firewire/core.h
===================================================================
--- linux-2.6.31.orig/drivers/firewire/core.h
+++ linux-2.6.31/drivers/firewire/core.h
@@ -94,7 +94,7 @@ int fw_card_add(struct fw_card *card,
 		u32 max_receive, u32 link_speed, u64 guid);
 void fw_core_remove_card(struct fw_card *card);
 int fw_core_initiate_bus_reset(struct fw_card *card, int short_reset);
-int fw_compute_block_crc(u32 *block);
+int fw_compute_block_crc(__be32 *block);
 void fw_schedule_bm_work(struct fw_card *card, unsigned long delay);
 
 static inline struct fw_card *fw_card_get(struct fw_card *card)
Index: linux-2.6.31/include/linux/firewire.h
===================================================================
--- linux-2.6.31.orig/include/linux/firewire.h
+++ linux-2.6.31/include/linux/firewire.h
@@ -117,7 +117,7 @@ struct fw_card {
 
 	bool broadcast_channel_allocated;
 	u32 broadcast_channel;
-	u32 topology_map[(CSR_TOPOLOGY_MAP_END - CSR_TOPOLOGY_MAP) / 4];
+	__be32 topology_map[(CSR_TOPOLOGY_MAP_END - CSR_TOPOLOGY_MAP) / 4];
 };
 
 struct fw_attribute_group {

-- 
Stefan Richter
-=====-==--= =-=- -=---
http://arcgraph.de/sr/

