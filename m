Return-Path: <linux-kernel-owner+w=401wt.eu-S1755716AbYLIXU6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755716AbYLIXU6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Dec 2008 18:20:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754750AbYLIXUt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Dec 2008 18:20:49 -0500
Received: from einhorn.in-berlin.de ([192.109.42.8]:60448 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753362AbYLIXUs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Dec 2008 18:20:48 -0500
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Wed, 10 Dec 2008 00:20:38 +0100 (CET)
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: [PATCH] firewire: fw-ohci: fix possible IOMMU resource exhaustion
To: linux1394-devel@lists.sourceforge.net
cc: linux-kernel@vger.kernel.org
Message-ID: <tkrat.8d55c1b322c680dc@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=us-ascii
Content-Disposition: INLINE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is a DMA map/ unmap imbalance whenever a block write request
packet is sent and then dequeued with ohci_cancel_packet.  The latter
may happen frequently if the AR resp tasklet is executed before the AT
req tasklet for the same transaction.

Add the missing dma_unmap_single.

Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
---

This was spotted due to https://bugzilla.redhat.com/show_bug.cgi?id=475156,
but whether the patch already fixes bug 475156 has yet to be tested.

 drivers/firewire/fw-ohci.c        |   11 +++++++----
 drivers/firewire/fw-transaction.c |    3 +++
 drivers/firewire/fw-transaction.h |    2 ++
 3 files changed, 12 insertions(+), 4 deletions(-)

Index: linux/drivers/firewire/fw-ohci.c
===================================================================
--- linux.orig/drivers/firewire/fw-ohci.c
+++ linux/drivers/firewire/fw-ohci.c
@@ -974,6 +974,7 @@ at_context_queue_packet(struct context *
 			packet->ack = RCODE_SEND_ERROR;
 			return -1;
 		}
+		packet->payload_bus = payload_bus;
 
 		d[2].req_count    = cpu_to_le16(packet->payload_length);
 		d[2].data_address = cpu_to_le32(payload_bus);
@@ -1025,7 +1026,6 @@ static int handle_at_packet(struct conte
 	struct driver_data *driver_data;
 	struct fw_packet *packet;
 	struct fw_ohci *ohci = context->ohci;
-	dma_addr_t payload_bus;
 	int evt;
 
 	if (last->transfer_status == 0)
@@ -1038,9 +1038,8 @@ static int handle_at_packet(struct conte
 		/* This packet was cancelled, just continue. */
 		return 1;
 
-	payload_bus = le32_to_cpu(last->data_address);
-	if (payload_bus != 0)
-		dma_unmap_single(ohci->card.device, payload_bus,
+	if (packet->payload_bus)
+		dma_unmap_single(ohci->card.device, packet->payload_bus,
 				 packet->payload_length, DMA_TO_DEVICE);
 
 	evt = le16_to_cpu(last->transfer_status) & 0x1f;
@@ -1697,6 +1696,10 @@ static int ohci_cancel_packet(struct fw_
 	if (packet->ack != 0)
 		goto out;
 
+	if (packet->payload_bus)
+		dma_unmap_single(ohci->card.device, packet->payload_bus,
+				 packet->payload_length, DMA_TO_DEVICE);
+
 	log_ar_at_event('T', packet->speed, packet->header, 0x20);
 	driver_data->packet = NULL;
 	packet->ack = RCODE_CANCELLED;
Index: linux/drivers/firewire/fw-transaction.c
===================================================================
--- linux.orig/drivers/firewire/fw-transaction.c
+++ linux/drivers/firewire/fw-transaction.c
@@ -208,6 +208,7 @@ fw_fill_request(struct fw_packet *packet
 	packet->speed = speed;
 	packet->generation = generation;
 	packet->ack = 0;
+	packet->payload_bus = 0;
 }
 
 /**
@@ -582,6 +583,8 @@ fw_fill_response(struct fw_packet *respo
 		BUG();
 		return;
 	}
+
+	response->payload_bus = 0;
 }
 EXPORT_SYMBOL(fw_fill_response);
 
Index: linux/drivers/firewire/fw-transaction.h
===================================================================
--- linux.orig/drivers/firewire/fw-transaction.h
+++ linux/drivers/firewire/fw-transaction.h
@@ -27,6 +27,7 @@
 #include <linux/list.h>
 #include <linux/spinlock_types.h>
 #include <linux/timer.h>
+#include <linux/types.h>
 #include <linux/workqueue.h>
 
 #define TCODE_IS_READ_REQUEST(tcode)	(((tcode) & ~1) == 4)
@@ -153,6 +154,7 @@ struct fw_packet {
 	size_t header_length;
 	void *payload;
 	size_t payload_length;
+	dma_addr_t payload_bus;
 	u32 timestamp;
 
 	/*

-- 
Stefan Richter
-=====-==--- ==-- -=-=-
http://arcgraph.de/sr/

