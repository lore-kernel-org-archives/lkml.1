Return-Path: <linux-kernel-owner+w=401wt.eu-S1758710AbZJNSlJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758710AbZJNSlJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Oct 2009 14:41:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758121AbZJNSlI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Oct 2009 14:41:08 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:54605 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758118AbZJNSlG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Oct 2009 14:41:06 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Wed, 14 Oct 2009 20:40:10 +0200 (CEST)
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: [PATCH 2/2] firewire: ohci: 0 may be a valid DMA address
To: linux1394-devel@lists.sourceforge.net
cc: linux-kernel@vger.kernel.org
In-Reply-To: <tkrat.97d03c31313cb391@s5r6.in-berlin.de>
Message-ID: <tkrat.9e7418910f1183e1@s5r6.in-berlin.de>
References: <tkrat.97d03c31313cb391@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=us-ascii
Content-Disposition: INLINE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I was told that there are obscure architectures with non-coherent DMA
which may DMA-map to bus address 0.  We shall not use 0 as a magic
number of uninitialized bus address variables.

Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
---
 drivers/firewire/core-transaction.c |    4 ++--
 drivers/firewire/ohci.c             |    9 +++++----
 include/linux/firewire.h            |    1 +
 3 files changed, 8 insertions(+), 6 deletions(-)

Index: linux-2.6.31/drivers/firewire/ohci.c
===================================================================
--- linux-2.6.31.orig/drivers/firewire/ohci.c
+++ linux-2.6.31/drivers/firewire/ohci.c
@@ -995,7 +995,8 @@ static int at_context_queue_packet(struc
 			packet->ack = RCODE_SEND_ERROR;
 			return -1;
 		}
-		packet->payload_bus = payload_bus;
+		packet->payload_bus	= payload_bus;
+		packet->payload_mapped	= true;
 
 		d[2].req_count    = cpu_to_le16(packet->payload_length);
 		d[2].data_address = cpu_to_le32(payload_bus);
@@ -1023,7 +1024,7 @@ static int at_context_queue_packet(struc
 	 */
 	if (ohci->generation != packet->generation ||
 	    reg_read(ohci, OHCI1394_IntEventSet) & OHCI1394_busReset) {
-		if (packet->payload_length > 0)
+		if (packet->payload_mapped)
 			dma_unmap_single(ohci->card.device, payload_bus,
 					 packet->payload_length, DMA_TO_DEVICE);
 		packet->ack = RCODE_GENERATION;
@@ -1059,7 +1060,7 @@ static int handle_at_packet(struct conte
 		/* This packet was cancelled, just continue. */
 		return 1;
 
-	if (packet->payload_bus)
+	if (packet->payload_mapped)
 		dma_unmap_single(ohci->card.device, packet->payload_bus,
 				 packet->payload_length, DMA_TO_DEVICE);
 
@@ -1723,7 +1724,7 @@ static int ohci_cancel_packet(struct fw_
 	if (packet->ack != 0)
 		goto out;
 
-	if (packet->payload_bus)
+	if (packet->payload_mapped)
 		dma_unmap_single(ohci->card.device, packet->payload_bus,
 				 packet->payload_length, DMA_TO_DEVICE);
 
Index: linux-2.6.31/drivers/firewire/core-transaction.c
===================================================================
--- linux-2.6.31.orig/drivers/firewire/core-transaction.c
+++ linux-2.6.31/drivers/firewire/core-transaction.c
@@ -226,7 +226,7 @@ static void fw_fill_request(struct fw_pa
 	packet->speed = speed;
 	packet->generation = generation;
 	packet->ack = 0;
-	packet->payload_bus = 0;
+	packet->payload_mapped = false;
 }
 
 /**
@@ -601,7 +601,7 @@ void fw_fill_response(struct fw_packet *
 		WARN(1, KERN_ERR "wrong tcode %d", tcode);
 	}
 
-	response->payload_bus = 0;
+	response->payload_mapped = false;
 }
 EXPORT_SYMBOL(fw_fill_response);
 
Index: linux-2.6.31/include/linux/firewire.h
===================================================================
--- linux-2.6.31.orig/include/linux/firewire.h
+++ linux-2.6.31/include/linux/firewire.h
@@ -267,6 +267,7 @@ struct fw_packet {
 	void *payload;
 	size_t payload_length;
 	dma_addr_t payload_bus;
+	bool payload_mapped;
 	u32 timestamp;
 
 	/*

-- 
Stefan Richter
-=====-==--= =-=- -===-
http://arcgraph.de/sr/

