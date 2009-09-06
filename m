Return-Path: <linux-kernel-owner+w=401wt.eu-S1757980AbZIFQtB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757980AbZIFQtB (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Sep 2009 12:49:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752995AbZIFQtA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Sep 2009 12:49:00 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:48853 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752678AbZIFQtA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Sep 2009 12:49:00 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Sun, 6 Sep 2009 18:48:42 +0200 (CEST)
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: [PATCH 1/6] firewire: core: reduce stack usage in bus reset tasklet
To: linux1394-devel@lists.sourceforge.net
cc: linux-kernel@vger.kernel.org, PaX Team <pageexec@freemail.hu>
In-Reply-To: <tkrat.85bb80d9295444c1@s5r6.in-berlin.de>
Message-ID: <tkrat.3db711855693c0e5@s5r6.in-berlin.de>
References: <tkrat.85bb80d9295444c1@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=us-ascii
Content-Disposition: INLINE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

fw_compute_block_crc() used 1024 bytes of the kernel stack.  This
function is called
  - in process context when the local node's config ROM is updated,
  - in tasklet context of the bus reset handler.

Slab-allocate the buffer instead.

A drawback is that unlike before, the function may now fail.  This is
very unlikely though and the damage is limited (Config ROM or Topology
Map without CRC).  We don't pass an error code to callers because they
couldn't do anything about it anyway.

Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
---

Update:  kmalloc() and kfree() the buffer on the fly instead of
retaining 1 kB of a static buffer.

 drivers/firewire/core-card.c     |   15 ++++++++++-----
 drivers/firewire/core-topology.c |    2 +-
 drivers/firewire/core.h          |    2 +-
 3 files changed, 12 insertions(+), 7 deletions(-)

Index: linux-2.6.31-rc9/drivers/firewire/core-card.c
===================================================================
--- linux-2.6.31-rc9.orig/drivers/firewire/core-card.c
+++ linux-2.6.31-rc9/drivers/firewire/core-card.c
@@ -38,16 +38,21 @@
 
 #include "core.h"
 
-int fw_compute_block_crc(u32 *block)
+int fw_compute_block_crc(u32 *block, gfp_t flags)
 {
-	__be32 be32_block[256];
-	int i, length;
+	static __be32 *be32_block;
+	int i, length = (*block >> 16) & 0xff;
+
+	be32_block = kmalloc(length * 4, flags);
+	if (WARN_ON(!be32_block))
+		goto out;
 
-	length = (*block >> 16) & 0xff;
 	for (i = 0; i < length; i++)
 		be32_block[i] = cpu_to_be32(block[i + 1]);
 	*block |= crc_itu_t(0, (u8 *) be32_block, length * 4);
 
+	kfree(be32_block);
+ out:
 	return length;
 }
 
@@ -129,7 +134,7 @@ static u32 *generate_config_rom(struct f
 	 * the bus info block, which is always the case for this
 	 * implementation. */
 	for (i = 0; i < j; i += length + 1)
-		length = fw_compute_block_crc(config_rom + i);
+		length = fw_compute_block_crc(config_rom + i, GFP_KERNEL);
 
 	*config_rom_length = j;
 
Index: linux-2.6.31-rc9/drivers/firewire/core-topology.c
===================================================================
--- linux-2.6.31-rc9.orig/drivers/firewire/core-topology.c
+++ linux-2.6.31-rc9/drivers/firewire/core-topology.c
@@ -517,7 +517,7 @@ static void update_topology_map(struct f
 	card->topology_map[2] = (node_count << 16) | self_id_count;
 	card->topology_map[0] = (self_id_count + 2) << 16;
 	memcpy(&card->topology_map[3], self_ids, self_id_count * 4);
-	fw_compute_block_crc(card->topology_map);
+	fw_compute_block_crc(card->topology_map, GFP_ATOMIC);
 }
 
 void fw_core_handle_bus_reset(struct fw_card *card, int node_id, int generation,
Index: linux-2.6.31-rc9/drivers/firewire/core.h
===================================================================
--- linux-2.6.31-rc9.orig/drivers/firewire/core.h
+++ linux-2.6.31-rc9/drivers/firewire/core.h
@@ -93,7 +93,7 @@ int fw_card_add(struct fw_card *card,
 		u32 max_receive, u32 link_speed, u64 guid);
 void fw_core_remove_card(struct fw_card *card);
 int fw_core_initiate_bus_reset(struct fw_card *card, int short_reset);
-int fw_compute_block_crc(u32 *block);
+int fw_compute_block_crc(u32 *block, gfp_t flags);
 void fw_schedule_bm_work(struct fw_card *card, unsigned long delay);
 
 

-- 
Stefan Richter
-=====-==--= =--= --==-
http://arcgraph.de/sr/

