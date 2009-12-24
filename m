Return-Path: <linux-kernel-owner+w=401wt.eu-S1757412AbZLXLnt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757412AbZLXLnt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Dec 2009 06:43:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757390AbZLXLnj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Dec 2009 06:43:39 -0500
Received: from mail-ew0-f219.google.com ([209.85.219.219]:65136 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757394AbZLXLnK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Dec 2009 06:43:10 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=P2gnSRdFecRqQVKiD5eVPoWW366t6VK1HXWpNxw8cxeQwW1rDv4JJM6MsIo4fifIGS
         pUmkFzFTLl1sY3vj4FDCNblgQB1Zr8uGoWennFhoGn47Bnf6sF2oGC6Xh/Hhn94r40Tn
         xj0IN95hBwBLz8wHKUhTAdWxu/TKGKsg2zzfw=
From: Johan Hovold <jhovold@gmail.com>
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
       Matti Aarnio <matti.aarnio@zmailer.org>,
       Johan Hovold <jhovold@gmail.com>
Subject: [PATCH 4/5] USB: ftdi_sio: clean up modem status handling
Date: Thu, 24 Dec 2009 12:42:10 +0100
Message-Id: <1261654931-31543-5-git-send-email-jhovold@gmail.com>
X-Mailer: git-send-email 1.6.6.rc4
In-Reply-To: <1261654931-31543-1-git-send-email-jhovold@gmail.com>
References: <1261654931-31543-1-git-send-email-jhovold@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Johan Hovold <jhovold@gmail.com>
---
 drivers/usb/serial/ftdi_sio.c |   37 ++++++++++++++++---------------------
 1 files changed, 16 insertions(+), 21 deletions(-)

diff --git a/drivers/usb/serial/ftdi_sio.c b/drivers/usb/serial/ftdi_sio.c
index 4b3f115..49c981f 100644
--- a/drivers/usb/serial/ftdi_sio.c
+++ b/drivers/usb/serial/ftdi_sio.c
@@ -2322,6 +2322,7 @@ static int ftdi_tiocmget(struct tty_struct *tty, struct file *file)
 	struct usb_serial_port *port = tty->driver_data;
 	struct ftdi_private *priv = usb_get_serial_port_data(port);
 	unsigned char *buf;
+	int len;
 	int ret;
 
 	dbg("%s TIOCMGET", __func__);
@@ -2329,18 +2330,13 @@ static int ftdi_tiocmget(struct tty_struct *tty, struct file *file)
 	buf = kmalloc(2, GFP_KERNEL);
 	if (!buf)
 		return -ENOMEM;
-
+	/*
+	 * The 8U232AM returns a two byte value (the SIO a 1 byte value) in
+	 * the same format as the data returned from the in point.
+	 */
 	switch (priv->chip_type) {
 	case SIO:
-		/* Request the status from the device */
-		ret = usb_control_msg(port->serial->dev,
-			   usb_rcvctrlpipe(port->serial->dev, 0),
-			   FTDI_SIO_GET_MODEM_STATUS_REQUEST,
-			   FTDI_SIO_GET_MODEM_STATUS_REQUEST_TYPE,
-			   0, 0,
-			   buf, 1, WDR_TIMEOUT);
-		if (ret < 0)
-			goto out;
+		len = 1;
 		break;
 	case FT8U232AM:
 	case FT232BM:
@@ -2348,23 +2344,22 @@ static int ftdi_tiocmget(struct tty_struct *tty, struct file *file)
 	case FT232RL:
 	case FT2232H:
 	case FT4232H:
-		/* the 8U232AM returns a two byte value (the sio is a 1 byte
-		   value) - in the same format as the data returned from the in
-		   point */
-		ret = usb_control_msg(port->serial->dev,
-				   usb_rcvctrlpipe(port->serial->dev, 0),
-				   FTDI_SIO_GET_MODEM_STATUS_REQUEST,
-				   FTDI_SIO_GET_MODEM_STATUS_REQUEST_TYPE,
-				   0, priv->interface,
-				   buf, 2, WDR_TIMEOUT);
-		if (ret < 0)
-			goto out;
+		len = 2;
 		break;
 	default:
 		ret = -EFAULT;
 		goto out;
 	}
 
+	ret = usb_control_msg(port->serial->dev,
+			usb_rcvctrlpipe(port->serial->dev, 0),
+			FTDI_SIO_GET_MODEM_STATUS_REQUEST,
+			FTDI_SIO_GET_MODEM_STATUS_REQUEST_TYPE,
+			0, priv->interface,
+			buf, len, WDR_TIMEOUT);
+	if (ret < 0)
+		goto out;
+
 	ret = (buf[0] & FTDI_SIO_DSR_MASK ? TIOCM_DSR : 0) |
 		(buf[0] & FTDI_SIO_CTS_MASK ? TIOCM_CTS : 0) |
 		(buf[0]  & FTDI_SIO_RI_MASK  ? TIOCM_RI  : 0) |
-- 
1.6.6.rc4

