Return-Path: <linux-kernel-owner+w=401wt.eu-S1757222AbZCJUCo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757222AbZCJUCo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Mar 2009 16:02:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755667AbZCJUCc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Mar 2009 16:02:32 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:48129 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755745AbZCJUCb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Mar 2009 16:02:31 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Tue, 10 Mar 2009 21:02:21 +0100 (CET)
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: [PATCH 5/5] firewire: cdev: add closure to async stream ioctl
To: linux1394-devel@lists.sourceforge.net
cc: linux-kernel@vger.kernel.org
In-Reply-To: <tkrat.700492025c5bb3e8@s5r6.in-berlin.de>
Message-ID: <tkrat.8db6a6dcd57419ee@s5r6.in-berlin.de>
References: <tkrat.700492025c5bb3e8@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=us-ascii
Content-Disposition: INLINE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This changes the as yet unreleased FW_CDEV_IOC_SEND_STREAM_PACKET ioctl
to generate an fw_cdev_event_response event just like the other two
ioctls for asynchronous request transmission do.  This way, clients get
feedback on successful or unsuccessful transmission.

This also adds input validation for length, tag, channel, sy, speed.

Furthermore, this changes how future in-kernel drivers can transmit
asynchronous streams:
  - The still unused fw_send_stream_packet() is deleted.
  - Instead, call either fw_send_request() as asynchronous API in any
    context or fw_run_transaction() as synchronous API in non-atomic
    context.
  - Supply tag/ channel/ sy via fw_stream_packet_destination_id().
  - In case of fw_send_request(), supply an fw_transaction and an
    fw_transaction_callback_t instead of an fw_packet and an
    fw_packet_callback_t.

Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
---
 drivers/firewire/fw-cdev.c        |   46 ++++++++++++------------------
 drivers/firewire/fw-transaction.c |   42 ++++++++++-----------------
 drivers/firewire/fw-transaction.h |    9 +++--
 include/linux/firewire-cdev.h     |   31 ++++++++++----------
 4 files changed, 56 insertions(+), 72 deletions(-)

Index: linux/drivers/firewire/fw-cdev.c
===================================================================
--- linux.orig/drivers/firewire/fw-cdev.c
+++ linux/drivers/firewire/fw-cdev.c
@@ -522,7 +522,8 @@ static int init_request(struct client *c
 	struct outbound_transaction_event *e;
 	int ret;
 
-	if (request->length > 4096 || request->length > 512 << speed)
+	if (request->tcode != TCODE_STREAM_DATA &&
+	    (request->length > 4096 || request->length > 512 << speed))
 		return -EIO;
 
 	e = kmalloc(sizeof(*e) + request->length, GFP_KERNEL);
@@ -1247,36 +1248,27 @@ static int ioctl_send_broadcast_request(
 	return init_request(client, request, LOCAL_BUS | 0x3f, SCODE_100);
 }
 
-struct stream_packet {
-	struct fw_packet packet;
-	u8 data[0];
-};
-
-static void send_stream_packet_done(struct fw_packet *packet,
-				    struct fw_card *card, int status)
-{
-	kfree(container_of(packet, struct stream_packet, packet));
-}
-
 static int ioctl_send_stream_packet(struct client *client, void *buffer)
 {
-	struct fw_cdev_send_stream_packet *request = buffer;
-	struct stream_packet *p;
+	struct fw_cdev_send_stream_packet *p = buffer;
+	struct fw_cdev_send_request request;
+	int dest;
 
-	p = kmalloc(sizeof(*p) + request->size, GFP_KERNEL);
-	if (p == NULL)
-		return -ENOMEM;
+	if (p->speed > client->device->card->link_speed ||
+	    p->length > 1024 << p->speed)
+		return -EIO;
 
-	if (request->data &&
-	    copy_from_user(p->data, u64_to_uptr(request->data), request->size)) {
-		kfree(p);
-		return -EFAULT;
-	}
-	fw_send_stream_packet(client->device->card, &p->packet,
-			      request->generation, request->speed,
-			      request->channel, request->sy, request->tag,
-			      p->data, request->size, send_stream_packet_done);
-	return 0;
+	if (p->tag > 3 || p->channel > 63 || p->sy > 15)
+		return -EINVAL;
+
+	dest = fw_stream_packet_destination_id(p->tag, p->channel, p->sy);
+	request.tcode		= TCODE_STREAM_DATA;
+	request.length		= p->length;
+	request.closure		= p->closure;
+	request.data		= p->data;
+	request.generation	= p->generation;
+
+	return init_request(client, &request, dest, p->speed);
 }
 
 static int (* const ioctl_handlers[])(struct client *client, void *buffer) = {
Index: linux/drivers/firewire/fw-transaction.c
===================================================================
--- linux.orig/drivers/firewire/fw-transaction.c
+++ linux/drivers/firewire/fw-transaction.c
@@ -37,10 +37,6 @@
 #include "fw-topology.h"
 #include "fw-device.h"
 
-#define HEADER_TAG(tag)			((tag) << 14)
-#define HEADER_CHANNEL(ch)		((ch) << 8)
-#define HEADER_SY(sy)			((sy) << 0)
-
 #define HEADER_PRI(pri)			((pri) << 0)
 #define HEADER_TCODE(tcode)		((tcode) << 4)
 #define HEADER_RETRY(retry)		((retry) << 8)
@@ -158,6 +154,18 @@ static void fw_fill_request(struct fw_pa
 {
 	int ext_tcode;
 
+	if (tcode == TCODE_STREAM_DATA) {
+		packet->header[0] =
+			HEADER_DATA_LENGTH(length) |
+			destination_id |
+			HEADER_TCODE(TCODE_STREAM_DATA);
+		packet->header_length = 4;
+		packet->payload = payload;
+		packet->payload_length = length;
+
+		goto common;
+	}
+
 	if (tcode > 0x10) {
 		ext_tcode = tcode & ~0x10;
 		tcode = TCODE_LOCK_REQUEST;
@@ -204,7 +212,7 @@ static void fw_fill_request(struct fw_pa
 		packet->payload_length = 0;
 		break;
 	}
-
+ common:
 	packet->speed = speed;
 	packet->generation = generation;
 	packet->ack = 0;
@@ -246,6 +254,9 @@ static void fw_fill_request(struct fw_pa
  * @param callback function to be called when the transaction is completed
  * @param callback_data pointer to arbitrary data, which will be
  *   passed to the callback
+ *
+ * In case of asynchronous stream packets i.e. TCODE_STREAM_DATA, the caller
+ * needs to synthesize @destination_id with fw_stream_packet_destination_id().
  */
 void fw_send_request(struct fw_card *card, struct fw_transaction *t, int tcode,
 		     int destination_id, int generation, int speed,
@@ -297,27 +308,6 @@ void fw_send_request(struct fw_card *car
 }
 EXPORT_SYMBOL(fw_send_request);
 
-void fw_send_stream_packet(struct fw_card *card, struct fw_packet *p,
-		int generation, int speed, int channel, int sy, int tag,
-		void *payload, size_t length, fw_packet_callback_t callback)
-{
-	p->callback = callback;
-	p->header[0] =
-		  HEADER_DATA_LENGTH(length)
-		| HEADER_TAG(tag)
-		| HEADER_CHANNEL(channel)
-		| HEADER_TCODE(TCODE_STREAM_DATA)
-		| HEADER_SY(sy);
-	p->header_length = 4;
-	p->payload = payload;
-	p->payload_length = length;
-	p->speed = speed;
-	p->generation = generation;
-	p->ack = 0;
-
-	card->driver->send_request(card, p);
-}
-
 struct transaction_callback_data {
 	struct completion done;
 	void *payload;
Index: linux/drivers/firewire/fw-transaction.h
===================================================================
--- linux.orig/drivers/firewire/fw-transaction.h
+++ linux/drivers/firewire/fw-transaction.h
@@ -412,10 +412,6 @@ void fw_send_request(struct fw_card *car
 		int tcode, int destination_id, int generation, int speed,
 		unsigned long long offset, void *payload, size_t length,
 		fw_transaction_callback_t callback, void *callback_data);
-void fw_send_stream_packet(struct fw_card *card, struct fw_packet *p,
-		int generation, int speed, int channel, int sy, int tag,
-		void *payload, size_t length, fw_packet_callback_t callback);
-
 int fw_cancel_transaction(struct fw_card *card,
 			  struct fw_transaction *transaction);
 void fw_flush_transactions(struct fw_card *card);
@@ -425,6 +421,11 @@ int fw_run_transaction(struct fw_card *c
 void fw_send_phy_config(struct fw_card *card,
 			int node_id, int generation, int gap_count);
 
+static inline int fw_stream_packet_destination_id(int tag, int channel, int sy)
+{
+	return tag << 14 | channel << 8 | sy;
+}
+
 /*
  * Called by the topology code to inform the device code of node
  * activity; found, lost, or updated nodes.
Index: linux/include/linux/firewire-cdev.h
===================================================================
--- linux.orig/include/linux/firewire-cdev.h
+++ linux/include/linux/firewire-cdev.h
@@ -606,28 +606,29 @@ struct fw_cdev_allocate_iso_resource {
 
 /**
  * struct fw_cdev_send_stream_packet - send an asynchronous stream packet
- * @generation:   Bus generation where the packet is valid
- * @speed:	  Speed code to send the packet at
- * @channel:	  Channel to send the packet on
- * @sy:		  Four-bit sy code for the packet
- * @tag:	  Two-bit tag field to use for the packet
- * @size:	  Size of the packet's data payload
- * @data:	  Userspace pointer to the payload
+ * @length:	Length of outgoing payload, in bytes
+ * @tag:	Data format tag
+ * @channel:	Isochronous channel to transmit to
+ * @sy:		Synchronization code
+ * @closure:	Passed back to userspace in the response event
+ * @data:	Userspace pointer to payload
+ * @generation:	The bus generation where packet is valid
+ * @speed:	Speed to transmit at
  *
  * The %FW_CDEV_IOC_SEND_STREAM_PACKET ioctl sends an asynchronous stream packet
- * to every device (that is listening to the specified channel) on the
- * firewire bus.  It is the applications's job to ensure
- * that the intended device(s) will be able to receive the packet at the chosen
- * transmit speed.
+ * to every device which is listening to the specified channel.  The kernel
+ * writes an &fw_cdev_event_response event which indicates success or failure of
+ * the transmission.
  */
 struct fw_cdev_send_stream_packet {
-	__u32 generation;
-	__u32 speed;
+	__u32 length;
+	__u32 tag;
 	__u32 channel;
 	__u32 sy;
-	__u32 tag;
-	__u32 size;
+	__u64 closure;
 	__u64 data;
+	__u32 generation;
+	__u32 speed;
 };
 
 #endif /* _LINUX_FIREWIRE_CDEV_H */

-- 
Stefan Richter
-=====-==--= --== -=-=-
http://arcgraph.de/sr/

