Return-Path: <linux-kernel-owner+w=401wt.eu-S1752494AbZFTLYS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752494AbZFTLYS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Jun 2009 07:24:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751896AbZFTLYL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 20 Jun 2009 07:24:11 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:55591 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751826AbZFTLYK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Jun 2009 07:24:10 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Sat, 20 Jun 2009 13:23:59 +0200 (CEST)
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: [PATCH] firewire: core: do not DMA-map stack addresses
To: linux1394-devel@lists.sourceforge.net
cc: linux-kernel@vger.kernel.org
Message-ID: <tkrat.8d1748a1e1db2c7a@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=us-ascii
Content-Disposition: INLINE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The DMA mapping API cannot map on-stack addresses, as explained in
Documentation/DMA-mapping.txt.  Convert the two cases of on-stack packet
payload buffers in firewire-core (payload of lock requests in the bus
manager work and in iso resource management) to slab-allocated memory.

There are a number on-stack buffers for quadlet write or quadlet read
requests in firewire-core and firewire-sbp2.  These are harmless; they
are copied to/ from card driver internal DMA buffers since quadlet
payloads are inlined with packet headers.

Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
---
 drivers/firewire/core-card.c |   14 +++++++-------
 drivers/firewire/core-cdev.c |    4 +++-
 drivers/firewire/core-iso.c  |   24 +++++++++++++-----------
 drivers/firewire/core.h      |    3 ++-
 include/linux/firewire.h     |    1 +
 5 files changed, 26 insertions(+), 20 deletions(-)

Index: b/drivers/firewire/core-card.c
===================================================================
--- a/drivers/firewire/core-card.c
+++ b/drivers/firewire/core-card.c
@@ -196,8 +196,8 @@ static void allocate_broadcast_channel(s
 {
 	int channel, bandwidth = 0;
 
-	fw_iso_resource_manage(card, generation, 1ULL << 31,
-			       &channel, &bandwidth, true);
+	fw_iso_resource_manage(card, generation, 1ULL << 31, &channel,
+			       &bandwidth, true, card->bm_transaction_data);
 	if (channel == 31) {
 		card->broadcast_channel_allocated = true;
 		device_for_each_child(card->device, (void *)(long)generation,
@@ -230,7 +230,6 @@ static void fw_card_bm_work(struct work_
 	bool do_reset = false;
 	bool root_device_is_running;
 	bool root_device_is_cmc;
-	__be32 lock_data[2];
 
 	spin_lock_irqsave(&card->lock, flags);
 
@@ -273,22 +272,23 @@ static void fw_card_bm_work(struct work_
 			goto pick_me;
 		}
 
-		lock_data[0] = cpu_to_be32(0x3f);
-		lock_data[1] = cpu_to_be32(local_id);
+		card->bm_transaction_data[0] = cpu_to_be32(0x3f);
+		card->bm_transaction_data[1] = cpu_to_be32(local_id);
 
 		spin_unlock_irqrestore(&card->lock, flags);
 
 		rcode = fw_run_transaction(card, TCODE_LOCK_COMPARE_SWAP,
 				irm_id, generation, SCODE_100,
 				CSR_REGISTER_BASE + CSR_BUS_MANAGER_ID,
-				lock_data, sizeof(lock_data));
+				card->bm_transaction_data,
+				sizeof(card->bm_transaction_data));
 
 		if (rcode == RCODE_GENERATION)
 			/* Another bus reset, BM work has been rescheduled. */
 			goto out;
 
 		if (rcode == RCODE_COMPLETE &&
-		    lock_data[0] != cpu_to_be32(0x3f)) {
+		    card->bm_transaction_data[0] != cpu_to_be32(0x3f)) {
 
 			/* Somebody else is BM.  Only act as IRM. */
 			if (local_id == irm_id)
Index: b/drivers/firewire/core-cdev.c
===================================================================
--- a/drivers/firewire/core-cdev.c
+++ b/drivers/firewire/core-cdev.c
@@ -125,6 +125,7 @@ struct iso_resource {
 	int generation;
 	u64 channels;
 	s32 bandwidth;
+	__be32 transaction_data[2];
 	struct iso_resource_event *e_alloc, *e_dealloc;
 };
 
@@ -1049,7 +1050,8 @@ static void iso_resource_work(struct wor
 			r->channels, &channel, &bandwidth,
 			todo == ISO_RES_ALLOC ||
 			todo == ISO_RES_REALLOC ||
-			todo == ISO_RES_ALLOC_ONCE);
+			todo == ISO_RES_ALLOC_ONCE,
+			r->transaction_data);
 	/*
 	 * Is this generation outdated already?  As long as this resource sticks
 	 * in the idr, it will be scheduled again for a newer generation or at
Index: b/drivers/firewire/core-iso.c
===================================================================
--- a/drivers/firewire/core-iso.c
+++ b/drivers/firewire/core-iso.c
@@ -177,9 +177,8 @@ EXPORT_SYMBOL(fw_iso_context_stop);
  */
 
 static int manage_bandwidth(struct fw_card *card, int irm_id, int generation,
-			    int bandwidth, bool allocate)
+			    int bandwidth, bool allocate, __be32 data[2])
 {
-	__be32 data[2];
 	int try, new, old = allocate ? BANDWIDTH_AVAILABLE_INITIAL : 0;
 
 	/*
@@ -215,9 +214,9 @@ static int manage_bandwidth(struct fw_ca
 }
 
 static int manage_channel(struct fw_card *card, int irm_id, int generation,
-			  u32 channels_mask, u64 offset, bool allocate)
+		u32 channels_mask, u64 offset, bool allocate, __be32 data[2])
 {
-	__be32 data[2], c, all, old;
+	__be32 c, all, old;
 	int i, retry = 5;
 
 	old = all = allocate ? cpu_to_be32(~0) : 0;
@@ -260,7 +259,7 @@ static int manage_channel(struct fw_card
 }
 
 static void deallocate_channel(struct fw_card *card, int irm_id,
-			       int generation, int channel)
+			       int generation, int channel, __be32 buffer[2])
 {
 	u32 mask;
 	u64 offset;
@@ -269,7 +268,7 @@ static void deallocate_channel(struct fw
 	offset = channel < 32 ? CSR_REGISTER_BASE + CSR_CHANNELS_AVAILABLE_HI :
 				CSR_REGISTER_BASE + CSR_CHANNELS_AVAILABLE_LO;
 
-	manage_channel(card, irm_id, generation, mask, offset, false);
+	manage_channel(card, irm_id, generation, mask, offset, false, buffer);
 }
 
 /**
@@ -298,7 +297,7 @@ static void deallocate_channel(struct fw
  */
 void fw_iso_resource_manage(struct fw_card *card, int generation,
 			    u64 channels_mask, int *channel, int *bandwidth,
-			    bool allocate)
+			    bool allocate, __be32 buffer[2])
 {
 	u32 channels_hi = channels_mask;	/* channels 31...0 */
 	u32 channels_lo = channels_mask >> 32;	/* channels 63...32 */
@@ -310,10 +309,12 @@ void fw_iso_resource_manage(struct fw_ca
 
 	if (channels_hi)
 		c = manage_channel(card, irm_id, generation, channels_hi,
-		    CSR_REGISTER_BASE + CSR_CHANNELS_AVAILABLE_HI, allocate);
+				CSR_REGISTER_BASE + CSR_CHANNELS_AVAILABLE_HI,
+				allocate, buffer);
 	if (channels_lo && c < 0) {
 		c = manage_channel(card, irm_id, generation, channels_lo,
-		    CSR_REGISTER_BASE + CSR_CHANNELS_AVAILABLE_LO, allocate);
+				CSR_REGISTER_BASE + CSR_CHANNELS_AVAILABLE_LO,
+				allocate, buffer);
 		if (c >= 0)
 			c += 32;
 	}
@@ -325,12 +326,13 @@ void fw_iso_resource_manage(struct fw_ca
 	if (*bandwidth == 0)
 		return;
 
-	ret = manage_bandwidth(card, irm_id, generation, *bandwidth, allocate);
+	ret = manage_bandwidth(card, irm_id, generation, *bandwidth,
+			       allocate, buffer);
 	if (ret < 0)
 		*bandwidth = 0;
 
 	if (allocate && ret < 0 && c >= 0) {
-		deallocate_channel(card, irm_id, generation, c);
+		deallocate_channel(card, irm_id, generation, c, buffer);
 		*channel = ret;
 	}
 }
Index: b/drivers/firewire/core.h
===================================================================
--- a/drivers/firewire/core.h
+++ b/drivers/firewire/core.h
@@ -120,7 +120,8 @@ void fw_node_event(struct fw_card *card,
 
 int fw_iso_buffer_map(struct fw_iso_buffer *buffer, struct vm_area_struct *vma);
 void fw_iso_resource_manage(struct fw_card *card, int generation,
-		u64 channels_mask, int *channel, int *bandwidth, bool allocate);
+			    u64 channels_mask, int *channel, int *bandwidth,
+			    bool allocate, __be32 buffer[2]);
 
 
 /* -topology */
Index: b/include/linux/firewire.h
===================================================================
--- a/include/linux/firewire.h
+++ b/include/linux/firewire.h
@@ -127,6 +127,7 @@ struct fw_card {
 	struct delayed_work work;
 	int bm_retries;
 	int bm_generation;
+	__be32 bm_transaction_data[2];
 
 	bool broadcast_channel_allocated;
 	u32 broadcast_channel;

-- 
Stefan Richter
-=====-==--= -==- =-=--
http://arcgraph.de/sr/

