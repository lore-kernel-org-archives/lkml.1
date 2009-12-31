Return-Path: <linux-kernel-owner+w=401wt.eu-S1752845AbZLaPuz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752845AbZLaPuz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Dec 2009 10:50:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752743AbZLaPum
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Dec 2009 10:50:42 -0500
Received: from mail-ew0-f219.google.com ([209.85.219.219]:33387 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752705AbZLaPs7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Dec 2009 10:48:59 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=xcLEbefJ51jEubsb7i7wMrsBzyN6Cc843uF+r36K1knIQUMp6ksXNOsQqOIinOXoDk
         MsEA8XwrMu0dL8N9qhLp9DbaoH9lWe6NnrIfAeRJJ1PIyCDowzPu9lMxhRDV5aAiqY/j
         Q3eKcuWPbE4GnrzPk3fGCEG+HSzFe17gdGt48=
From: Johan Hovold <jhovold@gmail.com>
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
       Johan Hovold <jhovold@gmail.com>
Subject: [PATCH 07/13] USB: keyspan_pda: fix DMA buffers on stack
Date: Thu, 31 Dec 2009 16:48:03 +0100
Message-Id: <1262274489-12447-8-git-send-email-jhovold@gmail.com>
X-Mailer: git-send-email 1.6.6
In-Reply-To: <1262037718-31424-1-git-send-email-jhovold@gmail.com>
References: <1262037718-31424-1-git-send-email-jhovold@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Johan Hovold <jhovold@gmail.com>
---
 drivers/usb/serial/keyspan_pda.c |   45 +++++++++++++++++++++++++++----------
 1 files changed, 33 insertions(+), 12 deletions(-)

diff --git a/drivers/usb/serial/keyspan_pda.c b/drivers/usb/serial/keyspan_pda.c
index 1296a09..427d377 100644
--- a/drivers/usb/serial/keyspan_pda.c
+++ b/drivers/usb/serial/keyspan_pda.c
@@ -429,13 +429,20 @@ static int keyspan_pda_get_modem_info(struct usb_serial *serial,
 				      unsigned char *value)
 {
 	int rc;
-	unsigned char data;
+	u8 *data;
+
+	data = kmalloc(1, GFP_KERNEL);
+	if (!data)
+		return -ENOMEM;
+
 	rc = usb_control_msg(serial->dev, usb_rcvctrlpipe(serial->dev, 0),
 			     3, /* get pins */
 			     USB_TYPE_VENDOR|USB_RECIP_INTERFACE|USB_DIR_IN,
-			     0, 0, &data, 1, 2000);
+			     0, 0, data, 1, 2000);
 	if (rc >= 0)
-		*value = data;
+		*value = *data;
+
+	kfree(data);
 	return rc;
 }
 
@@ -543,7 +550,14 @@ static int keyspan_pda_write(struct tty_struct *tty,
 	   device how much room it really has.  This is done only on
 	   scheduler time, since usb_control_msg() sleeps. */
 	if (count > priv->tx_room && !in_interrupt()) {
-		unsigned char room;
+		u8 *room;
+
+		room = kmalloc(1, GFP_KERNEL);
+		if (!room) {
+			rc = -ENOMEM;
+			goto exit;
+		}
+
 		rc = usb_control_msg(serial->dev,
 				     usb_rcvctrlpipe(serial->dev, 0),
 				     6, /* write_room */
@@ -551,9 +565,14 @@ static int keyspan_pda_write(struct tty_struct *tty,
 				     | USB_DIR_IN,
 				     0, /* value: 0 means "remaining room" */
 				     0, /* index */
-				     &room,
+				     room,
 				     1,
 				     2000);
+		if (rc > 0) {
+			dbg(" roomquery says %d", *room);
+			priv->tx_room = *room;
+		}
+		kfree(room);
 		if (rc < 0) {
 			dbg(" roomquery failed");
 			goto exit;
@@ -563,8 +582,6 @@ static int keyspan_pda_write(struct tty_struct *tty,
 			rc = -EIO; /* device didn't return any data */
 			goto exit;
 		}
-		dbg(" roomquery says %d", room);
-		priv->tx_room = room;
 	}
 	if (count > priv->tx_room) {
 		/* we're about to completely fill the Tx buffer, so
@@ -684,18 +701,22 @@ static int keyspan_pda_open(struct tty_struct *tty,
 					struct usb_serial_port *port)
 {
 	struct usb_serial *serial = port->serial;
-	unsigned char room;
+	u8 *room;
 	int rc = 0;
 	struct keyspan_pda_private *priv;
 
 	/* find out how much room is in the Tx ring */
+	room = kmalloc(1, GFP_KERNEL);
+	if (!room)
+		return -ENOMEM;
+
 	rc = usb_control_msg(serial->dev, usb_rcvctrlpipe(serial->dev, 0),
 			     6, /* write_room */
 			     USB_TYPE_VENDOR | USB_RECIP_INTERFACE
 			     | USB_DIR_IN,
 			     0, /* value */
 			     0, /* index */
-			     &room,
+			     room,
 			     1,
 			     2000);
 	if (rc < 0) {
@@ -708,8 +729,8 @@ static int keyspan_pda_open(struct tty_struct *tty,
 		goto error;
 	}
 	priv = usb_get_serial_port_data(port);
-	priv->tx_room = room;
-	priv->tx_throttled = room ? 0 : 1;
+	priv->tx_room = *room;
+	priv->tx_throttled = *room ? 0 : 1;
 
 	/*Start reading from the device*/
 	port->interrupt_in_urb->dev = serial->dev;
@@ -718,8 +739,8 @@ static int keyspan_pda_open(struct tty_struct *tty,
 		dbg("%s - usb_submit_urb(read int) failed", __func__);
 		goto error;
 	}
-
 error:
+	kfree(room);
 	return rc;
 }
 static void keyspan_pda_close(struct usb_serial_port *port)
-- 
1.6.6

