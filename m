Return-Path: <linux-kernel-owner+w=401wt.eu-S1755272AbZISQDs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755272AbZISQDs (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Sep 2009 12:03:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753247AbZISQDs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Sep 2009 12:03:48 -0400
Received: from mail-ew0-f206.google.com ([209.85.219.206]:56633 "EHLO
	mail-ew0-f206.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752562AbZISQDr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Sep 2009 12:03:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:bcc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=UPXts5A0oBGt5Palgi9BOlAHUetiWjLQpcSaYL8rx0ir29lLb6+cicXURyBr/WIhDr
         /doc0H4PDzEtnE+Wo4WVhMxNdinBG4M70Wfwb9uD9lAzLeN9DBd520BHzcmAz8xt+3kW
         41C3IwJs34x7Nd8ubHilh6Grt5a5Gj61WREmc=
Date: Sat, 19 Sep 2009 18:03:47 +0200
From: Johan Hovold <jhovold@gmail.com>
To: Greg KH <greg@kroah.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Alan Stern <stern@rowland.harvard.edu>, linux-usb@vger.kernel.org,
       e9hack <e9hack@googlemail.com>, linux-kernel@vger.kernel.org
Subject: [PATCH] USB: ftdi_sio: Fix read regression in 2.6.31.
Message-ID: <20090919160347.GA14156@localhost>
References: <20090916162640.2840db66@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090916162640.2840db66@lxorguk.ukuu.org.uk>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use ASYNCB_INITIALIZED to determine when to stop reading.

Since 335f8514f200e63d689113d29cb7253a5c282967 port count can no longer
be used to determine when to stop reading from the device as it can be
zero when the first read callbacks are made (see tty_port_block_til_read
where port count is temporarily decremented during serial_open).

This fixes the regression where reads fail after connecting the device
and opening the port more than once (reads usually succeed after the
first open due to the device latency timer then being set to the default
16ms rather than 1ms).

Signed-off-by: Johan Hovold <jhovold@gmail.com>
---

Tested against 2.6.31 as well as Greg's patch set
(f9752c181c0f7d8bc9c16df0124bf06c5a4d4d88).

Note that ASYNCB_INITIALIZED does not yet get cleared on close in
2.6.31 (as it does in Greg's patches), but ftdi_close kills the urb so
the driver stops reading at the next callback as the urb status then is
non-zero.

Regards,
Johan


 drivers/usb/serial/ftdi_sio.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/usb/serial/ftdi_sio.c b/drivers/usb/serial/ftdi_sio.c
index 4f883b1..7eaea14 100644
--- a/drivers/usb/serial/ftdi_sio.c
+++ b/drivers/usb/serial/ftdi_sio.c
@@ -2033,7 +2033,7 @@ static void ftdi_read_bulk_callback(struct urb *urb)
 
 	dbg("%s - port %d", __func__, port->number);
 
-	if (port->port.count <= 0)
+	if (!test_bit(ASYNCB_INITIALIZED, &port->port.flags))
 		return;
 
 	tty = tty_port_tty_get(&port->port);
@@ -2089,7 +2089,7 @@ static void ftdi_process_read(struct work_struct *work)
 
 	dbg("%s - port %d", __func__, port->number);
 
-	if (port->port.count <= 0)
+	if (!test_bit(ASYNCB_INITIALIZED, &port->port.flags))
 		return;
 
 	tty = tty_port_tty_get(&port->port);
@@ -2247,7 +2247,7 @@ static void ftdi_process_read(struct work_struct *work)
 		}
 		spin_unlock_irqrestore(&priv->rx_lock, flags);
 		/* if the port is closed stop trying to read */
-		if (port->port.count > 0)
+		if (test_bit(ASYNCB_INITIALIZED, &port->port.flags))
 			/* delay processing of remainder */
 			schedule_delayed_work(&priv->rx_work, 1);
 		else
@@ -2259,7 +2259,7 @@ static void ftdi_process_read(struct work_struct *work)
 	priv->rx_processed = 0;
 
 	/* if the port is closed stop trying to read */
-	if (port->port.count > 0) {
+	if (test_bit(ASYNCB_INITIALIZED, &port->port.flags)) {
 		/* Continue trying to always read  */
 		usb_fill_bulk_urb(port->read_urb, port->serial->dev,
 			usb_rcvbulkpipe(port->serial->dev,
-- 
1.6.4.2

