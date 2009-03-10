Return-Path: <linux-kernel-owner+w=401wt.eu-S1757694AbZCJUJu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757694AbZCJUJu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Mar 2009 16:09:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753160AbZCJUJj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Mar 2009 16:09:39 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:48196 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752999AbZCJUJi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Mar 2009 16:09:38 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Tue, 10 Mar 2009 21:09:28 +0100 (CET)
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: [PATCH 4/5] firewire: core: optimize propagation of BROADCAST_CHANNEL
To: linux1394-devel@lists.sourceforge.net
cc: linux-kernel@vger.kernel.org
In-Reply-To: <tkrat.be62682e320707a0@s5r6.in-berlin.de>
Message-ID: <tkrat.a5203b3380577b04@s5r6.in-berlin.de>
References: <tkrat.be62682e320707a0@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=us-ascii
Content-Disposition: INLINE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cache the test result of whether a device implements BROADCAST_CHANNEL.
This minimizes traffic on the bus after each bus reset.  A majority of
devices does not implement BROADCAST_CHANNEL.

Remove busy retries; just rely on the hardware to retry requests to busy
responders.  Remove unnecessary log messages.

Rename the flag is_irm to broadcast_channel_allocated to better reflect
its meaning.  Reset the flag earlier in fw_core_handle_bus_reset.

Pass the generation down as a call parameter; that way generation can't
be newer than card->broadcast_channel_allocated and device->node_id.

Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
---
 drivers/firewire/fw-card.c        |   85 +-----------------------------
 drivers/firewire/fw-device.c      |   45 ++++++++++++++-
 drivers/firewire/fw-device.h      |    5 +
 drivers/firewire/fw-topology.c    |    1 
 drivers/firewire/fw-transaction.h |    6 --
 5 files changed, 52 insertions(+), 90 deletions(-)

Index: linux/drivers/firewire/fw-card.c
===================================================================
--- linux.orig/drivers/firewire/fw-card.c
+++ linux/drivers/firewire/fw-card.c
@@ -181,83 +181,9 @@ void fw_core_remove_descriptor(struct fw
 	mutex_unlock(&card_mutex);
 }
 
-#define IRM_RETRIES 2
-
-/*
- * The abi is set by device_for_each_child(), even though we have no use
- * for data, nor do we have a meaningful return value.
- */
-int fw_irm_set_broadcast_channel_register(struct device *dev, void *data)
+static int set_broadcast_channel(struct device *dev, void *data)
 {
-	struct fw_device *d;
-	int rcode;
-	int node_id;
-	int max_speed;
-	int retries;
-	int generation;
-	__be32 regval;
-	struct fw_card *card;
-
-	d = fw_device(dev);
-	/* FIXME: do we need locking here? */
-	generation = d->generation;
-	smp_rmb(); /* Ensure generation is at least as old as node_id */
-	node_id = d->node_id;
-	max_speed = d->max_speed;
-	retries = IRM_RETRIES;
-	card = d->card;
-tryagain_r:
-	rcode = fw_run_transaction(card, TCODE_READ_QUADLET_REQUEST,
-				   node_id, generation, max_speed,
-				   CSR_REGISTER_BASE + CSR_BROADCAST_CHANNEL,
-				   &regval, 4);
-	switch (rcode) {
-	case RCODE_BUSY:
-		if (retries--)
-			goto tryagain_r;
-		fw_notify("node %x read broadcast channel busy\n",
-			  node_id);
-		return 0;
-
-	default:
-		fw_notify("node %x read broadcast channel failed %x\n",
-			  node_id, rcode);
-		return 0;
-
-	case RCODE_COMPLETE:
-		/*
-		 * Paranoid reporting of nonstandard broadcast channel
-		 * contents goes here
-		 */
-		if (regval != cpu_to_be32(BROADCAST_CHANNEL_INITIAL))
-			return 0;
-		break;
-	}
-	retries = IRM_RETRIES;
-	regval = cpu_to_be32(BROADCAST_CHANNEL_INITIAL |
-			     BROADCAST_CHANNEL_VALID);
-tryagain_w:
-	rcode = fw_run_transaction(card,
-			TCODE_WRITE_QUADLET_REQUEST, node_id,
-			generation, max_speed,
-			CSR_REGISTER_BASE + CSR_BROADCAST_CHANNEL,
-			&regval, 4);
-	switch (rcode) {
-	case RCODE_BUSY:
-		if (retries--)
-			goto tryagain_w;
-		fw_notify("node %x write broadcast channel busy\n",
-			  node_id);
-		return 0;
-
-	default:
-		fw_notify("node %x write broadcast channel failed %x\n",
-			  node_id, rcode);
-		return 0;
-
-	case RCODE_COMPLETE:
-		return 0;
-	}
+	fw_device_set_broadcast_channel(fw_device(dev), (long)data);
 	return 0;
 }
 
@@ -268,9 +194,9 @@ static void allocate_broadcast_channel(s
 	fw_iso_resource_manage(card, generation, 1ULL << 31,
 			       &channel, &bandwidth, true);
 	if (channel == 31) {
-		card->is_irm = true;
-		device_for_each_child(card->device, NULL,
-				      fw_irm_set_broadcast_channel_register);
+		card->broadcast_channel_allocated = true;
+		device_for_each_child(card->device, (void *)(long)generation,
+				      set_broadcast_channel);
 	}
 }
 
@@ -302,7 +228,6 @@ static void fw_card_bm_work(struct work_
 	__be32 lock_data[2];
 
 	spin_lock_irqsave(&card->lock, flags);
-	card->is_irm = false;
 
 	if (card->local_node == NULL) {
 		spin_unlock_irqrestore(&card->lock, flags);
Index: linux/drivers/firewire/fw-device.c
===================================================================
--- linux.orig/drivers/firewire/fw-device.c
+++ linux/drivers/firewire/fw-device.c
@@ -518,7 +518,7 @@ static int read_bus_info_block(struct fw
 
 	kfree(old_rom);
 	ret = 0;
-	device->cmc = rom[2] & 1 << 30;
+	device->cmc = rom[2] >> 30 & 1;
  out:
 	kfree(rom);
 
@@ -756,6 +756,44 @@ static int lookup_existing_device(struct
 	return match;
 }
 
+enum { BC_UNKNOWN = 0, BC_UNIMPLEMENTED, BC_IMPLEMENTED, };
+
+void fw_device_set_broadcast_channel(struct fw_device *device, int generation)
+{
+	struct fw_card *card = device->card;
+	__be32 data;
+	int rcode;
+
+	if (!card->broadcast_channel_allocated)
+		return;
+
+	if (device->bc_implemented == BC_UNKNOWN) {
+		rcode = fw_run_transaction(card, TCODE_READ_QUADLET_REQUEST,
+				device->node_id, generation, device->max_speed,
+				CSR_REGISTER_BASE + CSR_BROADCAST_CHANNEL,
+				&data, 4);
+		switch (rcode) {
+		case RCODE_COMPLETE:
+			if (data & cpu_to_be32(1 << 31)) {
+				device->bc_implemented = BC_IMPLEMENTED;
+				break;
+			}
+			/* else fall through to case address error */
+		case RCODE_ADDRESS_ERROR:
+			device->bc_implemented = BC_UNIMPLEMENTED;
+		}
+	}
+
+	if (device->bc_implemented == BC_IMPLEMENTED) {
+		data = cpu_to_be32(BROADCAST_CHANNEL_INITIAL |
+				   BROADCAST_CHANNEL_VALID);
+		fw_run_transaction(card, TCODE_WRITE_QUADLET_REQUEST,
+				device->node_id, generation, device->max_speed,
+				CSR_REGISTER_BASE + CSR_BROADCAST_CHANNEL,
+				&data, 4);
+	}
+}
+
 static void fw_device_init(struct work_struct *work)
 {
 	struct fw_device *device =
@@ -849,9 +887,8 @@ static void fw_device_init(struct work_s
 				  device->config_rom[3], device->config_rom[4],
 				  1 << device->max_speed);
 		device->config_rom_retries = 0;
-		if (device->card->is_irm)
-			fw_irm_set_broadcast_channel_register(&device->device,
-							      NULL);
+
+		fw_device_set_broadcast_channel(device, device->generation);
 	}
 
 	/*
Index: linux/drivers/firewire/fw-device.h
===================================================================
--- linux.orig/drivers/firewire/fw-device.h
+++ linux/drivers/firewire/fw-device.h
@@ -71,7 +71,6 @@ struct fw_device {
 	int node_id;
 	int generation;
 	unsigned max_speed;
-	bool cmc;
 	struct fw_card *card;
 	struct device device;
 
@@ -81,6 +80,9 @@ struct fw_device {
 	u32 *config_rom;
 	size_t config_rom_length;
 	int config_rom_retries;
+	unsigned cmc:1;
+	unsigned bc_implemented:2;
+
 	struct delayed_work work;
 	struct fw_attribute_group attribute_group;
 };
@@ -109,6 +111,7 @@ static inline void fw_device_put(struct 
 
 struct fw_device *fw_device_get_by_devt(dev_t devt);
 int fw_device_enable_phys_dma(struct fw_device *device);
+void fw_device_set_broadcast_channel(struct fw_device *device, int generation);
 
 void fw_device_cdev_update(struct fw_device *device);
 void fw_device_cdev_remove(struct fw_device *device);
Index: linux/drivers/firewire/fw-topology.c
===================================================================
--- linux.orig/drivers/firewire/fw-topology.c
+++ linux/drivers/firewire/fw-topology.c
@@ -526,6 +526,7 @@ void fw_core_handle_bus_reset(struct fw_
 
 	spin_lock_irqsave(&card->lock, flags);
 
+	card->broadcast_channel_allocated = false;
 	card->node_id = node_id;
 	/*
 	 * Update node_id before generation to prevent anybody from using
Index: linux/drivers/firewire/fw-transaction.h
===================================================================
--- linux.orig/drivers/firewire/fw-transaction.h
+++ linux/drivers/firewire/fw-transaction.h
@@ -230,11 +230,6 @@ struct fw_card {
 	u8 color; /* must be u8 to match the definition in struct fw_node */
 	int gap_count;
 	bool beta_repeaters_present;
-	/*
-	 * Set if the local device is the IRM and the broadcast channel
-	 * was allocated.
-	 */
-	bool is_irm;
 
 	int index;
 
@@ -245,6 +240,7 @@ struct fw_card {
 	int bm_retries;
 	int bm_generation;
 
+	bool broadcast_channel_allocated;
 	u32 broadcast_channel;
 	u32 topology_map[(CSR_TOPOLOGY_MAP_END - CSR_TOPOLOGY_MAP) / 4];
 };

-- 
Stefan Richter
-=====-==--= --== -=-=-
http://arcgraph.de/sr/

