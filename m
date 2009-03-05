Return-Path: <linux-kernel-owner+w=401wt.eu-S1756819AbZCESJo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756819AbZCESJo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Mar 2009 13:09:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755758AbZCESJg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Mar 2009 13:09:36 -0500
Received: from einhorn.in-berlin.de ([192.109.42.8]:42246 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755697AbZCESJf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Mar 2009 13:09:35 -0500
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Thu, 5 Mar 2009 19:08:40 +0100 (CET)
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: [PATCH update] firewire: implement asynchronous stream transmission
To: Jay Fenlason <fenlason@redhat.com>
cc: linux1394-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
In-Reply-To: <20090217171412.GB8496@redhat.com>
Message-ID: <tkrat.c703cc635844204e@s5r6.in-berlin.de>
References: <20090217171412.GB8496@redhat.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=us-ascii
Content-Disposition: INLINE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jay Fenlason <fenlason@redhat.com>

Allow userspace and other firewire drivers (fw-ipv4 I'm looking at
you!) to send Asynchronous Transmit Streams as described in 7.8.3 of
release 1.1 of the 1394 Open Host Controller Interface Specification.

Signed-off-by: Jay Fenlason <fenlason@redhat.com>
Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de> (tweaks)
---
Updates by Stefan R:
  - Drop EXPORT_SYMBOL for now.  Needs to be re-added by an actual user.
  - Drop GFP_DMA32 in packet allocation.  We can re-add it if we learn
    that we should have it.
  - Trivial changes:  Use fw_packet_callback_t in function prototype,
    remove unused variable, fix comment typo, change whitespace.

I plan a follow-up change to add a closure event to the API.

 drivers/firewire/fw-cdev.c        |   33 ++++++++++++++++++++++++++++++
 drivers/firewire/fw-ohci.c        |   21 +++++++++++++++++--
 drivers/firewire/fw-transaction.c |   25 ++++++++++++++++++++++
 drivers/firewire/fw-transaction.h |    4 +++
 include/linux/firewire-cdev.h     |   27 ++++++++++++++++++++++++
 5 files changed, 108 insertions(+), 2 deletions(-)

Index: linux/drivers/firewire/fw-cdev.c
===================================================================
--- linux.orig/drivers/firewire/fw-cdev.c
+++ linux/drivers/firewire/fw-cdev.c
@@ -1242,6 +1242,38 @@ static int ioctl_send_broadcast_request(
 	return init_request(client, request, LOCAL_BUS | 0x3f, SCODE_100);
 }
 
+struct stream_packet {
+	struct fw_packet packet;
+	u8 data[0];
+};
+
+static void send_stream_packet_done(struct fw_packet *packet,
+				    struct fw_card *card, int status)
+{
+	kfree(container_of(packet, struct stream_packet, packet));
+}
+
+static int ioctl_send_stream_packet(struct client *client, void *buffer)
+{
+	struct fw_cdev_send_stream_packet *request = buffer;
+	struct stream_packet *p;
+
+	p = kmalloc(sizeof(*p) + request->size, GFP_KERNEL);
+	if (p == NULL)
+		return -ENOMEM;
+
+	if (request->data &&
+	    copy_from_user(p->data, u64_to_uptr(request->data), request->size)) {
+		kfree(p);
+		return -EFAULT;
+	}
+	fw_send_stream_packet(client->device->card, &p->packet,
+			      request->generation, request->speed,
+			      request->channel, request->sy, request->tag,
+			      p->data, request->size, send_stream_packet_done);
+	return 0;
+}
+
 static int (* const ioctl_handlers[])(struct client *client, void *buffer) = {
 	ioctl_get_info,
 	ioctl_send_request,
@@ -1262,6 +1294,7 @@ static int (* const ioctl_handlers[])(st
 	ioctl_deallocate_iso_resource_once,
 	ioctl_get_speed,
 	ioctl_send_broadcast_request,
+	ioctl_send_stream_packet,
 };
 
 static int dispatch_ioctl(struct client *client,
Index: linux/drivers/firewire/fw-ohci.c
===================================================================
--- linux.orig/drivers/firewire/fw-ohci.c
+++ linux/drivers/firewire/fw-ohci.c
@@ -936,7 +936,9 @@ static int at_context_queue_packet(struc
 	 */
 
 	header = (__le32 *) &d[1];
-	if (packet->header_length > 8) {
+	switch (packet->header_length) {
+	case 16:
+	case 12:
 		header[0] = cpu_to_le32((packet->header[0] & 0xffff) |
 					(packet->speed << 16));
 		header[1] = cpu_to_le32((packet->header[1] & 0xffff) |
@@ -950,12 +952,27 @@ static int at_context_queue_packet(struc
 			header[3] = (__force __le32) packet->header[3];
 
 		d[0].req_count = cpu_to_le16(packet->header_length);
-	} else {
+		break;
+
+	case 8:
 		header[0] = cpu_to_le32((OHCI1394_phy_tcode << 4) |
 					(packet->speed << 16));
 		header[1] = cpu_to_le32(packet->header[0]);
 		header[2] = cpu_to_le32(packet->header[1]);
 		d[0].req_count = cpu_to_le16(12);
+		break;
+
+	case 4:
+		header[0] = cpu_to_le32((packet->header[0] & 0xffff) |
+					(packet->speed << 16));
+		header[1] = cpu_to_le32(packet->header[0] & 0xffff0000);
+		d[0].req_count = cpu_to_le16(8);
+		break;
+
+	default:
+		/* BUG(); */
+		packet->ack = RCODE_SEND_ERROR;
+		return -1;
 	}
 
 	driver_data = (struct driver_data *) &d[3];
Index: linux/drivers/firewire/fw-transaction.c
===================================================================
--- linux.orig/drivers/firewire/fw-transaction.c
+++ linux/drivers/firewire/fw-transaction.c
@@ -37,6 +37,10 @@
 #include "fw-topology.h"
 #include "fw-device.h"
 
+#define HEADER_TAG(tag)			((tag) << 14)
+#define HEADER_CHANNEL(ch)		((ch) << 8)
+#define HEADER_SY(sy)			((sy) << 0)
+
 #define HEADER_PRI(pri)			((pri) << 0)
 #define HEADER_TCODE(tcode)		((tcode) << 4)
 #define HEADER_RETRY(retry)		((retry) << 8)
@@ -293,6 +297,27 @@ void fw_send_request(struct fw_card *car
 }
 EXPORT_SYMBOL(fw_send_request);
 
+void fw_send_stream_packet(struct fw_card *card, struct fw_packet *p,
+		int generation, int speed, int channel, int sy, int tag,
+		void *payload, size_t length, fw_packet_callback_t callback)
+{
+	p->callback = callback;
+	p->header[0] =
+		  HEADER_DATA_LENGTH(length)
+		| HEADER_TAG(tag)
+		| HEADER_CHANNEL(channel)
+		| HEADER_TCODE(TCODE_STREAM_DATA)
+		| HEADER_SY(sy);
+	p->header_length = 4;
+	p->payload = payload;
+	p->payload_length = length;
+	p->speed = speed;
+	p->generation = generation;
+	p->ack = 0;
+
+	card->driver->send_request(card, p);
+}
+
 struct transaction_callback_data {
 	struct completion done;
 	void *payload;
Index: linux/drivers/firewire/fw-transaction.h
===================================================================
--- linux.orig/drivers/firewire/fw-transaction.h
+++ linux/drivers/firewire/fw-transaction.h
@@ -407,6 +407,10 @@ void fw_send_request(struct fw_card *car
 		int tcode, int destination_id, int generation, int speed,
 		unsigned long long offset, void *payload, size_t length,
 		fw_transaction_callback_t callback, void *callback_data);
+void fw_send_stream_packet(struct fw_card *card, struct fw_packet *p,
+		int generation, int speed, int channel, int sy, int tag,
+		void *payload, size_t length, fw_packet_callback_t callback);
+
 int fw_cancel_transaction(struct fw_card *card,
 			  struct fw_transaction *transaction);
 void fw_flush_transactions(struct fw_card *card);
Index: linux/include/linux/firewire-cdev.h
===================================================================
--- linux.orig/include/linux/firewire-cdev.h
+++ linux/include/linux/firewire-cdev.h
@@ -246,6 +246,7 @@ union fw_cdev_event {
 #define FW_CDEV_IOC_DEALLOCATE_ISO_RESOURCE_ONCE _IOW('#', 0x10, struct fw_cdev_allocate_iso_resource)
 #define FW_CDEV_IOC_GET_SPEED                    _IOR('#', 0x11, struct fw_cdev_get_speed)
 #define FW_CDEV_IOC_SEND_BROADCAST_REQUEST       _IOW('#', 0x12, struct fw_cdev_send_request)
+#define FW_CDEV_IOC_SEND_STREAM_PACKET           _IOW('#', 0x13, struct fw_cdev_send_stream_packet)
 
 /*
  * FW_CDEV_VERSION History
@@ -609,4 +610,30 @@ struct fw_cdev_get_speed {
 	__u32 max_speed;
 };
 
+/**
+ * struct fw_cdev_send_stream_packet - send an asynchronous stream packet
+ * @generation:   Bus generation where the packet is valid
+ * @speed:	  Speed code to send the packet at
+ * @channel:	  Channel to send the packet on
+ * @sy:		  Four-bit sy code for the packet
+ * @tag:	  Two-bit tag field to use for the packet
+ * @size:	  Size of the packet's data payload
+ * @data:	  Userspace pointer to the payload
+ *
+ * The %FW_CDEV_IOC_SEND_STREAM_PACKET ioctl sends an asynchronous stream packet
+ * to every device (that is listening to the specified channel) on the
+ * firewire bus.  It is the applications's job to ensure
+ * that the intended device(s) will be able to receive the packet at the chosen
+ * transmit speed.
+ */
+struct fw_cdev_send_stream_packet {
+	__u32 generation;
+	__u32 speed;
+	__u32 channel;
+	__u32 sy;
+	__u32 tag;
+	__u32 size;
+	__u64 data;
+};
+
 #endif /* _LINUX_FIREWIRE_CDEV_H */

-- 
Stefan Richter
-=====-==--= --== --=-=
http://arcgraph.de/sr/

