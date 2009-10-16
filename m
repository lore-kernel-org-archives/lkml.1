Return-Path: <linux-kernel-owner+w=401wt.eu-S1753577AbZJPRSV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753577AbZJPRSV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Oct 2009 13:18:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753351AbZJPRST
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Oct 2009 13:18:19 -0400
Received: from kroah.org ([198.145.64.141]:48454 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753321AbZJPRSQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Oct 2009 13:18:16 -0400
X-Mailbox-Line: From linux@linux.site Fri Oct 16 10:11:50 2009
Message-Id: <20091016171150.453227667@linux.site>
User-Agent: quilt/0.47-14.9
Date: Fri, 16 Oct 2009 10:10:01 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Johan Hovold <jhovold@gmail.com>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [08/46] USB: ftdi_sio: remove unused rx_byte counter
References: <20091016170953.128828149@linux.site>
Content-Disposition: inline; filename=usb-ftdi_sio-remove-unused-rx_byte-counter.patch
In-Reply-To: <20091016171422.GA13339@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.31-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Johan Hovold <jhovold@gmail.com>

commit 63b0061246b54b849da8f189ae048e8110d8ce7d upstream.

Remove unused rx_byte counter which is never exposed as noted by Alan
Cox.

Signed-off-by: Johan Hovold <jhovold@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/usb/serial/ftdi_sio.c |   13 -------------
 1 file changed, 13 deletions(-)

--- a/drivers/usb/serial/ftdi_sio.c
+++ b/drivers/usb/serial/ftdi_sio.c
@@ -81,7 +81,6 @@ struct ftdi_private {
 	struct delayed_work rx_work;
 	struct usb_serial_port *port;
 	int rx_processed;
-	unsigned long rx_bytes;
 
 	__u16 interface;	/* FT2232C, FT2232H or FT4232H port interface
 				   (0 for FT232/245) */
@@ -1701,9 +1700,6 @@ static int ftdi_open(struct tty_struct *
 	spin_lock_irqsave(&priv->tx_lock, flags);
 	priv->tx_bytes = 0;
 	spin_unlock_irqrestore(&priv->tx_lock, flags);
-	spin_lock_irqsave(&priv->rx_lock, flags);
-	priv->rx_bytes = 0;
-	spin_unlock_irqrestore(&priv->rx_lock, flags);
 
 	write_latency_timer(port);
 
@@ -2016,8 +2012,6 @@ static void ftdi_read_bulk_callback(stru
 	struct usb_serial_port *port = urb->context;
 	struct tty_struct *tty;
 	struct ftdi_private *priv;
-	unsigned long countread;
-	unsigned long flags;
 	int status = urb->status;
 
 	if (urb->number_of_packets > 0) {
@@ -2056,13 +2050,6 @@ static void ftdi_read_bulk_callback(stru
 		goto out;
 	}
 
-	/* count data bytes, but not status bytes */
-	countread = urb->actual_length;
-	countread -= 2 * DIV_ROUND_UP(countread, priv->max_packet_size);
-	spin_lock_irqsave(&priv->rx_lock, flags);
-	priv->rx_bytes += countread;
-	spin_unlock_irqrestore(&priv->rx_lock, flags);
-
 	ftdi_process_read(&priv->rx_work.work);
 out:
 	tty_kref_put(tty);


