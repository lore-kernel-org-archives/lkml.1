Return-Path: <linux-kernel-owner+w=401wt.eu-S1757789AbZJPR13@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757789AbZJPR13 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Oct 2009 13:27:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753403AbZJPRSU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Oct 2009 13:18:20 -0400
Received: from kroah.org ([198.145.64.141]:48460 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751363AbZJPRSR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Oct 2009 13:18:17 -0400
X-Mailbox-Line: From linux@linux.site Fri Oct 16 10:11:51 2009
Message-Id: <20091016171150.956658137@linux.site>
User-Agent: quilt/0.47-14.9
Date: Fri, 16 Oct 2009 10:10:02 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Johan Hovold <jhovold@gmail.com>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [09/46] USB: ftdi_sio: clean up read completion handler
References: <20091016170953.128828149@linux.site>
Content-Disposition: inline; filename=usb-ftdi_sio-clean-up-read-completion-handler.patch
In-Reply-To: <20091016171422.GA13339@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.31-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Johan Hovold <jhovold@gmail.com>

commit e63e278b4d2d867893962d3c7cd13a3a24ceb3f1 upstream.

Remove superfluous error checks in completion handler:

 - No need to check private data and urb pointers as we check urb-status
   before dereferencing priv (which is not freed until urb has been killed
   on close).
 - No need to check tty as it is checked again when processing.
 - No need to check urb->number_of_packets on bulk urb.

Note that both private data and tty are checked again before processing
(possibly from work queue which also is cancelled on close).

Signed-off-by: Johan Hovold <jhovold@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/usb/serial/ftdi_sio.c |   28 +---------------------------
 1 file changed, 1 insertion(+), 27 deletions(-)

--- a/drivers/usb/serial/ftdi_sio.c
+++ b/drivers/usb/serial/ftdi_sio.c
@@ -2010,39 +2010,14 @@ static int ftdi_chars_in_buffer(struct t
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
@@ -2050,9 +2025,8 @@ static void ftdi_read_bulk_callback(stru
 		goto out;
 	}
 
+	priv = usb_get_serial_port_data(port);
 	ftdi_process_read(&priv->rx_work.work);
-out:
-	tty_kref_put(tty);
 } /* ftdi_read_bulk_callback */
 
 


