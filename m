Return-Path: <linux-kernel-owner+w=401wt.eu-S1759825AbZJGSGq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759825AbZJGSGq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Oct 2009 14:06:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759789AbZJGSGp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Oct 2009 14:06:45 -0400
Received: from mail-ew0-f208.google.com ([209.85.219.208]:46333 "EHLO
	mail-ew0-f208.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759772AbZJGSGm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Oct 2009 14:06:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=SiqvveP0XSJ0zkVvashvu4FoaIyQlbX0OaGhuMV6tI09gr80T0Dt4bXEECo3wPs5V6
         C5xk/94ssMBuBg4kwdnSQBeRJmHzid1IYVM6Vj7Mn/1PuKXdgFy0smO5qA7i755eP6oQ
         d+vpYo4CpEL+o7/645qwrC53vneNcxFVyCvs4=
From: Johan Hovold <jhovold@gmail.com>
To: Greg Kroah-Hartman <gregkh@suse.de>, Alan Cox <alan@linux.intel.com>
Cc: Oliver Neukum <oliver@neukum.org>, Alan Stern <stern@rowland.harvard.edu>,
       linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
       Johan Hovold <jhovold@gmail.com>
Subject: [PATCH 3/4] USB: ftdi_sio: clean up read completion handler
Date: Wed,  7 Oct 2009 20:05:06 +0200
Message-Id: <1254938707-6996-4-git-send-email-jhovold@gmail.com>
X-Mailer: git-send-email 1.6.5.rc2
In-Reply-To: <1254938707-6996-1-git-send-email-jhovold@gmail.com>
References: <1254938707-6996-1-git-send-email-jhovold@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove superfluous error checks in completion handler:

 - No need to check private data and urb pointers as we check urb-status
   before dereferencing priv (which is not freed until urb has been killed
   on close).
 - No need to check tty as it is checked again when processing.
 - No need to check urb->number_of_packets on bulk urb.

Note that both private data and tty are checked again before processing
(possibly from work queue which also is cancelled on close).

Signed-off-by: Johan Hovold <jhovold@gmail.com>
---
 drivers/usb/serial/ftdi_sio.c |   28 +---------------------------
 1 files changed, 1 insertions(+), 27 deletions(-)

diff --git a/drivers/usb/serial/ftdi_sio.c b/drivers/usb/serial/ftdi_sio.c
index bfb23d6..75c84d9 100644
--- a/drivers/usb/serial/ftdi_sio.c
+++ b/drivers/usb/serial/ftdi_sio.c
@@ -2008,39 +2008,14 @@ static int ftdi_chars_in_buffer(struct tty_struct *tty)
 static void ftdi_read_bulk_callback(struct urb *urb)
 {
 	struct usb_serial_port *port = urb->context;
-	struct tty_struct *tty;
 	struct ftdi_private *priv;
 	int status = urb->status;
 
-	if (urb->number_of_packets > 0) {
-		dev_err(&port->dev, "%s transfer_buffer_length %d "
-			"actual_length %d number of packets %d\n", __func__,
-			urb->transfer_buffer_length,
-			urb->actual_length, urb->number_of_packets);
-		dev_err(&port->dev, "%s transfer_flags %x\n", __func__,
-			urb->transfer_flags);
-	}
-
 	dbg("%s - port %d", __func__, port->number);
 
 	if (port->port.count <= 0)
 		return;
 
-	tty = tty_port_tty_get(&port->port);
-	if (!tty) {
-		dbg("%s - bad tty pointer - exiting", __func__);
-		return;
-	}
-
-	priv = usb_get_serial_port_data(port);
-	if (!priv) {
-		dbg("%s - bad port private data pointer - exiting", __func__);
-		goto out;
-	}
-
-	if (urb != port->read_urb)
-		dev_err(&port->dev, "%s - Not my urb!\n", __func__);
-
 	if (status) {
 		/* This will happen at close every time so it is a dbg not an
 		   err */
@@ -2048,9 +2023,8 @@ static void ftdi_read_bulk_callback(struct urb *urb)
 		goto out;
 	}
 
+	priv = usb_get_serial_port_data(port);
 	ftdi_process_read(&priv->rx_work.work);
-out:
-	tty_kref_put(tty);
 } /* ftdi_read_bulk_callback */
 
 
-- 
1.6.5.rc2

