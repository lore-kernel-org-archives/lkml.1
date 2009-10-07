Return-Path: <linux-kernel-owner+w=401wt.eu-S1759849AbZJGSGy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759849AbZJGSGy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Oct 2009 14:06:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759814AbZJGSGp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Oct 2009 14:06:45 -0400
Received: from mail-ew0-f208.google.com ([209.85.219.208]:62365 "EHLO
	mail-ew0-f208.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759780AbZJGSGm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Oct 2009 14:06:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=bZ5hctk956QNl/Y1R3TBB0QAbgz+mlB/9QYL3YbfocbmBIjcqpqn5QDgApaULz8ZPP
         68WdNEr6yAKHr3H7KChaBsfIVQZomM/nqYhgw6hrcpcAiA69aMJGWe9oq2/Ho/vMJzT/
         jvmQQVn4L+brlZNy0WDPRHoqOJVDGNXCAszw0=
From: Johan Hovold <jhovold@gmail.com>
To: Greg Kroah-Hartman <gregkh@suse.de>, Alan Cox <alan@linux.intel.com>
Cc: Oliver Neukum <oliver@neukum.org>, Alan Stern <stern@rowland.harvard.edu>,
       linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
       Johan Hovold <jhovold@gmail.com>
Subject: [PATCH 2/4] USB: ftdi_sio: remove unused rx_byte counter
Date: Wed,  7 Oct 2009 20:05:05 +0200
Message-Id: <1254938707-6996-3-git-send-email-jhovold@gmail.com>
X-Mailer: git-send-email 1.6.5.rc2
In-Reply-To: <1254938707-6996-1-git-send-email-jhovold@gmail.com>
References: <1254938707-6996-1-git-send-email-jhovold@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove unused rx_byte counter which is never exposed as noted by Alan
Cox.

Signed-off-by: Johan Hovold <jhovold@gmail.com>
---
 drivers/usb/serial/ftdi_sio.c |   13 -------------
 1 files changed, 0 insertions(+), 13 deletions(-)

diff --git a/drivers/usb/serial/ftdi_sio.c b/drivers/usb/serial/ftdi_sio.c
index 0ac2c2f..bfb23d6 100644
--- a/drivers/usb/serial/ftdi_sio.c
+++ b/drivers/usb/serial/ftdi_sio.c
@@ -81,7 +81,6 @@ struct ftdi_private {
 	struct delayed_work rx_work;
 	struct usb_serial_port *port;
 	int rx_processed;
-	unsigned long rx_bytes;
 
 	__u16 interface;	/* FT2232C, FT2232H or FT4232H port interface
 				   (0 for FT232/245) */
@@ -1699,9 +1698,6 @@ static int ftdi_open(struct tty_struct *tty, struct usb_serial_port *port)
 	spin_lock_irqsave(&priv->tx_lock, flags);
 	priv->tx_bytes = 0;
 	spin_unlock_irqrestore(&priv->tx_lock, flags);
-	spin_lock_irqsave(&priv->rx_lock, flags);
-	priv->rx_bytes = 0;
-	spin_unlock_irqrestore(&priv->rx_lock, flags);
 
 	write_latency_timer(port);
 
@@ -2014,8 +2010,6 @@ static void ftdi_read_bulk_callback(struct urb *urb)
 	struct usb_serial_port *port = urb->context;
 	struct tty_struct *tty;
 	struct ftdi_private *priv;
-	unsigned long countread;
-	unsigned long flags;
 	int status = urb->status;
 
 	if (urb->number_of_packets > 0) {
@@ -2054,13 +2048,6 @@ static void ftdi_read_bulk_callback(struct urb *urb)
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
-- 
1.6.5.rc2

