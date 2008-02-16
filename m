Return-Path: <linux-kernel-owner+w=401wt.eu-S1757933AbYBPOwR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757933AbYBPOwR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Feb 2008 09:52:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751751AbYBPOwF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 Feb 2008 09:52:05 -0500
Received: from mgw1.diku.dk ([130.225.96.91]:34199 "EHLO mgw1.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751916AbYBPOwD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Feb 2008 09:52:03 -0500
Date: Sat, 16 Feb 2008 15:51:59 +0100 (MET)
From: Julia Lawall <julia@diku.dk>
To: gregkh@suse.de, linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org
Subject: [PATCH 3/4] : More use DIV_ROUND_UP
Message-ID: <Pine.LNX.4.58.0802161549420.1185@pc-041.diku.dk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <julia@diku.dk>

The kernel.h macro DIV_ROUND_UP performs the computation (((n) + (d) - 1) /
(d)) but is perhaps more readable.

An extract of the semantic patch that makes this change is as follows:
(http://www.emn.fr/x-info/coccinelle/)

// <smpl>
@haskernel@
@@

#include <linux/kernel.h>

@depends on haskernel@
expression n,d;
@@

(
- (n + d - 1) / d
+ DIV_ROUND_UP(n,d)
|
- (n + (d - 1)) / d
+ DIV_ROUND_UP(n,d)
)

@depends on haskernel@
expression n,d;
@@

- DIV_ROUND_UP((n),d)
+ DIV_ROUND_UP(n,d)

@depends on haskernel@
expression n,d;
@@

- DIV_ROUND_UP(n,(d))
+ DIV_ROUND_UP(n,d)
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>

---

diff -u -p a/drivers/usb/host/r8a66597-hcd.c b/drivers/usb/host/r8a66597-hcd.c
--- a/drivers/usb/host/r8a66597-hcd.c 2007-12-31 08:43:30.000000000 +0100
+++ b/drivers/usb/host/r8a66597-hcd.c 2008-02-15 22:31:12.000000000 +0100
@@ -959,9 +959,9 @@ static void prepare_packet_read(struct r
 				r8a66597_write(r8a66597, TRCLR,
 						td->pipe->pipetre);
 				r8a66597_write(r8a66597,
-						(urb->transfer_buffer_length
-						+ td->maxpacket - 1)
-						/ td->maxpacket,
+						DIV_ROUND_UP
+						  (urb->transfer_buffer_length,
+						   td->maxpacket),
 						td->pipe->pipetrn);
 				r8a66597_bset(r8a66597, TRENB,
 						td->pipe->pipetre);
diff -u -p a/drivers/usb/misc/usbtest.c b/drivers/usb/misc/usbtest.c
--- a/drivers/usb/misc/usbtest.c 2008-02-02 15:28:32.000000000 +0100
+++ b/drivers/usb/misc/usbtest.c 2008-02-15 22:31:16.000000000 +0100
@@ -1403,7 +1403,7 @@ static struct urb *iso_alloc_urb (
 		return NULL;
 	maxp = 0x7ff & le16_to_cpu(desc->wMaxPacketSize);
 	maxp *= 1 + (0x3 & (le16_to_cpu(desc->wMaxPacketSize) >> 11));
-	packets = (bytes + maxp - 1) / maxp;
+	packets = DIV_ROUND_UP(bytes, maxp);

 	urb = usb_alloc_urb (packets, GFP_KERNEL);
 	if (!urb)
diff -u -p a/drivers/usb/serial/ftdi_sio.c b/drivers/usb/serial/ftdi_sio.c
--- a/drivers/usb/serial/ftdi_sio.c 2008-02-02 15:28:32.000000000 +0100
+++ b/drivers/usb/serial/ftdi_sio.c 2008-02-15 22:31:19.000000000 +0100
@@ -1380,7 +1380,7 @@ static void ftdi_write_bulk_callback (st
 	data_offset = priv->write_offset;
 	if (data_offset > 0) {
 		/* Subtract the control bytes */
-		countback -= (data_offset * ((countback + (PKTSZ - 1)) / PKTSZ));
+		countback -= (data_offset * DIV_ROUND_UP(countback, PKTSZ));
 	}
 	spin_lock_irqsave(&priv->tx_lock, flags);
 	--priv->tx_outstanding_urbs;
@@ -1480,7 +1480,7 @@ static void ftdi_read_bulk_callback (str

 	/* count data bytes, but not status bytes */
 	countread = urb->actual_length;
-	countread -= 2 * ((countread + (PKTSZ - 1)) / PKTSZ);
+	countread -= 2 * DIV_ROUND_UP(countread, PKTSZ);
 	spin_lock_irqsave(&priv->rx_lock, flags);
 	priv->rx_bytes += countread;
 	spin_unlock_irqrestore(&priv->rx_lock, flags);
diff -u -p a/drivers/usb/serial/io_ti.c b/drivers/usb/serial/io_ti.c
--- a/drivers/usb/serial/io_ti.c 2008-02-02 15:28:32.000000000 +0100
+++ b/drivers/usb/serial/io_ti.c 2008-02-15 22:31:21.000000000 +0100
@@ -655,7 +655,7 @@ static void TIChasePort(struct edgeport_
 	/* (TIIsTxActive doesn't seem to wait for the last byte) */
 	if ((baud_rate=port->baud_rate) == 0)
 		baud_rate = 50;
-	msleep(max(1,(10000+baud_rate-1)/baud_rate));
+	msleep(max(1, DIV_ROUND_UP(10000, baud_rate)));
 }

 static int TIChooseConfiguration (struct usb_device *dev)
