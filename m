Return-Path: <linux-kernel-owner+w=401wt.eu-S1752178AbXCQXzY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752178AbXCQXzY (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Mar 2007 19:55:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752474AbXCQXzY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Mar 2007 19:55:24 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:59140 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752178AbXCQXzX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Mar 2007 19:55:23 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Sun, 18 Mar 2007 00:55:15 +0100 (CET)
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: [PATCH] ieee1394: unroll a weird macro
To: linux1394-devel@lists.sourceforge.net
cc: linux-kernel@vger.kernel.org
In-Reply-To: <tkrat.be8814c580bba408@s5r6.in-berlin.de>
Message-ID: <tkrat.ea4a8e134ed9c6e1@s5r6.in-berlin.de>
References: <tkrat.be8814c580bba408@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=us-ascii
Content-Disposition: INLINE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is a coding style touch-up for ieee1394's handle_incoming_packet().

A preprocessor macro contained hardwired variable names and, even worse,
the 'break' keyword.  This macro is now unrolled and removed.

Also, all 'break's which had the effect of a return are replaced by
return.  And a FIXME comment is brought up to date.

Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
---

 drivers/ieee1394/ieee1394_core.c |   91 +++++++++++++------------------
 1 file changed, 41 insertions(+), 50 deletions(-)


Index: linux/drivers/ieee1394/ieee1394_core.c
===================================================================
--- linux.orig/drivers/ieee1394/ieee1394_core.c
+++ linux/drivers/ieee1394/ieee1394_core.c
@@ -856,12 +856,9 @@ static void fill_async_lock_resp(struct 
 	packet->data_size = length;
 }
 
-#define PREP_REPLY_PACKET(length) \
-		packet = create_reply_packet(host, data, length); \
-		if (packet == NULL) break
-
 static void handle_incoming_packet(struct hpsb_host *host, int tcode,
-				   quadlet_t *data, size_t size, int write_acked)
+				   quadlet_t *data, size_t size,
+				   int write_acked)
 {
 	struct hpsb_packet *packet;
 	int length, rcode, extcode;
@@ -871,74 +868,72 @@ static void handle_incoming_packet(struc
 	u16 flags = (u16) data[0];
 	u64 addr;
 
-	/* big FIXME - no error checking is done for an out of bounds length */
+	/* FIXME?
+	 * Out-of-bounds lengths are left for highlevel_read|write to cap. */
 
 	switch (tcode) {
 	case TCODE_WRITEQ:
 		addr = (((u64)(data[1] & 0xffff)) << 32) | data[2];
-		rcode = highlevel_write(host, source, dest, data+3,
+		rcode = highlevel_write(host, source, dest, data + 3,
 					addr, 4, flags);
-
-		if (!write_acked
-		    && (NODEID_TO_NODE(data[0] >> 16) != NODE_MASK)
-		    && (rcode >= 0)) {
-			/* not a broadcast write, reply */
-			PREP_REPLY_PACKET(0);
-			fill_async_write_resp(packet, rcode);
-			send_packet_nocare(packet);
-		}
-		break;
+		goto handle_write_request;
 
 	case TCODE_WRITEB:
 		addr = (((u64)(data[1] & 0xffff)) << 32) | data[2];
-		rcode = highlevel_write(host, source, dest, data+4,
-					addr, data[3]>>16, flags);
-
-		if (!write_acked
-		    && (NODEID_TO_NODE(data[0] >> 16) != NODE_MASK)
-		    && (rcode >= 0)) {
-			/* not a broadcast write, reply */
-			PREP_REPLY_PACKET(0);
+		rcode = highlevel_write(host, source, dest, data + 4,
+					addr, data[3] >> 16, flags);
+handle_write_request:
+		if (rcode < 0 || write_acked ||
+		    NODEID_TO_NODE(data[0] >> 16) == NODE_MASK)
+			return;
+		/* not a broadcast write, reply */
+		packet = create_reply_packet(host, data, 0);
+		if (packet) {
 			fill_async_write_resp(packet, rcode);
 			send_packet_nocare(packet);
 		}
-		break;
+		return;
 
 	case TCODE_READQ:
 		addr = (((u64)(data[1] & 0xffff)) << 32) | data[2];
 		rcode = highlevel_read(host, source, &buffer, addr, 4, flags);
+		if (rcode < 0)
+			return;
 
-		if (rcode >= 0) {
-			PREP_REPLY_PACKET(0);
+		packet = create_reply_packet(host, data, 0);
+		if (packet) {
 			fill_async_readquad_resp(packet, rcode, buffer);
 			send_packet_nocare(packet);
 		}
-		break;
+		return;
 
 	case TCODE_READB:
 		length = data[3] >> 16;
-		PREP_REPLY_PACKET(length);
+		packet = create_reply_packet(host, data, length);
+		if (!packet)
+			return;
 
 		addr = (((u64)(data[1] & 0xffff)) << 32) | data[2];
 		rcode = highlevel_read(host, source, packet->data, addr,
 				       length, flags);
-
-		if (rcode >= 0) {
-			fill_async_readblock_resp(packet, rcode, length);
-			send_packet_nocare(packet);
-		} else {
+		if (rcode < 0) {
 			hpsb_free_packet(packet);
+			return;
 		}
-		break;
+		fill_async_readblock_resp(packet, rcode, length);
+		send_packet_nocare(packet);
+		return;
 
 	case TCODE_LOCK_REQUEST:
 		length = data[3] >> 16;
 		extcode = data[3] & 0xffff;
 		addr = (((u64)(data[1] & 0xffff)) << 32) | data[2];
 
-		PREP_REPLY_PACKET(8);
+		packet = create_reply_packet(host, data, 8);
+		if (!packet)
+			return;
 
-		if ((extcode == 0) || (extcode >= 7)) {
+		if (extcode == 0 || extcode >= 7) {
 			/* let switch default handle error */
 			length = 0;
 		}
@@ -946,12 +941,12 @@ static void handle_incoming_packet(struc
 		switch (length) {
 		case 4:
 			rcode = highlevel_lock(host, source, packet->data, addr,
-					       data[4], 0, extcode,flags);
+					       data[4], 0, extcode, flags);
 			fill_async_lock_resp(packet, rcode, extcode, 4);
 			break;
 		case 8:
-			if ((extcode != EXTCODE_FETCH_ADD)
-			    && (extcode != EXTCODE_LITTLE_ADD)) {
+			if (extcode != EXTCODE_FETCH_ADD &&
+			    extcode != EXTCODE_LITTLE_ADD) {
 				rcode = highlevel_lock(host, source,
 						       packet->data, addr,
 						       data[5], data[4],
@@ -975,20 +970,16 @@ static void handle_incoming_packet(struc
 			break;
 		default:
 			rcode = RCODE_TYPE_ERROR;
-			fill_async_lock_resp(packet, rcode,
-					     extcode, 0);
+			fill_async_lock_resp(packet, rcode, extcode, 0);
 		}
 
-		if (rcode >= 0) {
-			send_packet_nocare(packet);
-		} else {
+		if (rcode < 0)
 			hpsb_free_packet(packet);
-		}
-		break;
+		else
+			send_packet_nocare(packet);
+		return;
 	}
-
 }
-#undef PREP_REPLY_PACKET
 
 /**
  * hpsb_packet_received - hand over received packet to the core


-- 
Stefan Richter
-=====-=-=== --== =--=-
http://arcgraph.de/sr/

