Return-Path: <linux-kernel-owner+w=401wt.eu-S1757313AbZLXLnN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757313AbZLXLnN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Dec 2009 06:43:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757384AbZLXLnI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Dec 2009 06:43:08 -0500
Received: from mail-ew0-f219.google.com ([209.85.219.219]:44116 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757376AbZLXLnD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Dec 2009 06:43:03 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=nzUdx6cNGAonT5EYVMfs3OAdD8zCmhQY2jRF6n6HQ90Ej6UFWcy0YVI4nd9N2LDeJq
         xudtzb5X+xNHCImGbTwOPgfyS6+cGG3d3dOeCQGFUZl3Q4ajD8FpAy20Xw5+Aqjd3Y6t
         mH4HFXO0P4B0OlURaDGmVSq9zRWfP72Ann/sE=
From: Johan Hovold <jhovold@gmail.com>
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
       Matti Aarnio <matti.aarnio@zmailer.org>,
       Johan Hovold <jhovold@gmail.com>
Subject: [PATCH 2/5] USB: ftdi_sio: fix latency-timeout endianess bug
Date: Thu, 24 Dec 2009 12:42:08 +0100
Message-Id: <1261654931-31543-3-git-send-email-jhovold@gmail.com>
X-Mailer: git-send-email 1.6.6.rc4
In-Reply-To: <1261654931-31543-1-git-send-email-jhovold@gmail.com>
References: <1261654931-31543-1-git-send-email-jhovold@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Also fixes DMA transfer to stack for latency buffer.

Signed-off-by: Johan Hovold <jhovold@gmail.com>
---
 drivers/usb/serial/ftdi_sio.c |   14 ++++++++++----
 1 files changed, 10 insertions(+), 4 deletions(-)

diff --git a/drivers/usb/serial/ftdi_sio.c b/drivers/usb/serial/ftdi_sio.c
index a952a3a..6d191fb 100644
--- a/drivers/usb/serial/ftdi_sio.c
+++ b/drivers/usb/serial/ftdi_sio.c
@@ -1162,22 +1162,28 @@ static int read_latency_timer(struct usb_serial_port *port)
 {
 	struct ftdi_private *priv = usb_get_serial_port_data(port);
 	struct usb_device *udev = port->serial->dev;
-	unsigned short latency = 0;
+	unsigned char *buf;
 	int rv = 0;
 
 	dbg("%s", __func__);
 
+	buf = kmalloc(1, GFP_KERNEL);
+	if (!buf)
+		return -ENOMEM;
+
 	rv = usb_control_msg(udev,
 			     usb_rcvctrlpipe(udev, 0),
 			     FTDI_SIO_GET_LATENCY_TIMER_REQUEST,
 			     FTDI_SIO_GET_LATENCY_TIMER_REQUEST_TYPE,
 			     0, priv->interface,
-			     (char *) &latency, 1, WDR_TIMEOUT);
-
+			     buf, 1, WDR_TIMEOUT);
 	if (rv < 0)
 		dev_err(&port->dev, "Unable to read latency timer: %i\n", rv);
 	else
-		priv->latency = latency;
+		priv->latency = buf[0];
+
+	kfree(buf);
+
 	return rv;
 }
 
-- 
1.6.6.rc4

