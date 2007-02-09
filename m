Return-Path: <linux-kernel-owner+w=401wt.eu-S2992430AbXBIQmc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992430AbXBIQmc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Feb 2007 11:42:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946657AbXBIQmG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Feb 2007 11:42:06 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:51735 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1946667AbXBIQj4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Feb 2007 11:39:56 -0500
To: torvalds@linux-foundation.org
Subject: [PATCH] trivial usb endianness annotations
Cc: gregkh@suse.de, linux-kernel@vger.kernel.org
Message-Id: <E1HFYmx-0006rC-Oa@ZenIV.linux.org.uk>
From: Al Viro <viro@ftp.linux.org.uk>
Date: Fri, 09 Feb 2007 16:39:55 +0000
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 drivers/usb/net/gl620a.c    |   26 ++++++++++++--------------
 drivers/usb/serial/cp2101.c |    8 ++++----
 2 files changed, 16 insertions(+), 18 deletions(-)

diff --git a/drivers/usb/net/gl620a.c b/drivers/usb/net/gl620a.c
index a6f0f4d..31e5fe3 100644
--- a/drivers/usb/net/gl620a.c
+++ b/drivers/usb/net/gl620a.c
@@ -70,12 +70,12 @@
 	(((GL_MAX_PACKET_LEN + 4) * GL_MAX_TRANSMIT_PACKETS) + 4)
 
 struct gl_packet {
-	u32		packet_length;
+	__le32		packet_length;
 	char		packet_data [1];
 };
 
 struct gl_header {
-	u32			packet_count;
+	__le32			packet_count;
 	struct gl_packet	packets;
 };
 
@@ -85,15 +85,14 @@ static int genelink_rx_fixup(struct usbnet *dev, struct sk_buff *skb)
 	struct gl_packet	*packet;
 	struct sk_buff		*gl_skb;
 	u32			size;
+	u32			count;
 
 	header = (struct gl_header *) skb->data;
 
 	// get the packet count of the received skb
-	le32_to_cpus(&header->packet_count);
-	if ((header->packet_count > GL_MAX_TRANSMIT_PACKETS)
-			|| (header->packet_count < 0)) {
-		dbg("genelink: invalid received packet count %d",
-			header->packet_count);
+	count = le32_to_cpu(header->packet_count);
+	if (count > GL_MAX_TRANSMIT_PACKETS) {
+		dbg("genelink: invalid received packet count %u", count);
 		return 0;
 	}
 
@@ -103,7 +102,7 @@ static int genelink_rx_fixup(struct usbnet *dev, struct sk_buff *skb)
 	// decrement the length for the packet count size 4 bytes
 	skb_pull(skb, 4);
 
-	while (header->packet_count > 1) {
+	while (count > 1) {
 		// get the packet length
 		size = le32_to_cpu(packet->packet_length);
 
@@ -124,9 +123,8 @@ static int genelink_rx_fixup(struct usbnet *dev, struct sk_buff *skb)
 		}
 
 		// advance to the next packet
-		packet = (struct gl_packet *)
-			&packet->packet_data [size];
-		header->packet_count--;
+		packet = (struct gl_packet *)&packet->packet_data[size];
+		count--;
 
 		// shift the data pointer to the next gl_packet
 		skb_pull(skb, size + 4);
@@ -149,8 +147,8 @@ genelink_tx_fixup(struct usbnet *dev, struct sk_buff *skb, gfp_t flags)
 	int	length = skb->len;
 	int	headroom = skb_headroom(skb);
 	int	tailroom = skb_tailroom(skb);
-	u32	*packet_count;
-	u32	*packet_len;
+	__le32	*packet_count;
+	__le32	*packet_len;
 
 	// FIXME:  magic numbers, bleech
 	padlen = ((skb->len + (4 + 4*1)) % 64) ? 0 : 1;
@@ -172,7 +170,7 @@ genelink_tx_fixup(struct usbnet *dev, struct sk_buff *skb, gfp_t flags)
 	}
 
 	// attach the packet count to the header
-	packet_count = (u32 *) skb_push(skb, (4 + 4*1));
+	packet_count = (__le32 *) skb_push(skb, (4 + 4*1));
 	packet_len = packet_count + 1;
 
 	*packet_count = cpu_to_le32(1);
diff --git a/drivers/usb/serial/cp2101.c b/drivers/usb/serial/cp2101.c
index 06b4fff..3ec2487 100644
--- a/drivers/usb/serial/cp2101.c
+++ b/drivers/usb/serial/cp2101.c
@@ -170,13 +170,13 @@ static int cp2101_get_config(struct usb_serial_port* port, u8 request,
 		unsigned int *data, int size)
 {
 	struct usb_serial *serial = port->serial;
-	u32 *buf;
+	__le32 *buf;
 	int result, i, length;
 
 	/* Number of integers required to contain the array */
 	length = (((size - 1) | 3) + 1)/4;
 
-	buf = kcalloc(length, sizeof(u32), GFP_KERNEL);
+	buf = kcalloc(length, sizeof(__le32), GFP_KERNEL);
 	if (!buf) {
 		dev_err(&port->dev, "%s - out of memory.\n", __FUNCTION__);
 		return -ENOMEM;
@@ -216,13 +216,13 @@ static int cp2101_set_config(struct usb_serial_port* port, u8 request,
 		unsigned int *data, int size)
 {
 	struct usb_serial *serial = port->serial;
-	u32 *buf;
+	__le32 *buf;
 	int result, i, length;
 
 	/* Number of integers required to contain the array */
 	length = (((size - 1) | 3) + 1)/4;
 
-	buf = kmalloc(length * sizeof(u32), GFP_KERNEL);
+	buf = kmalloc(length * sizeof(__le32), GFP_KERNEL);
 	if (!buf) {
 		dev_err(&port->dev, "%s - out of memory.\n",
 				__FUNCTION__);
-- 
1.5.0-rc2.GIT


