Return-Path: <linux-kernel-owner+w=401wt.eu-S1758695AbZEFCAr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758695AbZEFCAr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 May 2009 22:00:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756253AbZEFCAY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 May 2009 22:00:24 -0400
Received: from mail.windriver.com ([147.11.1.11]:50554 "EHLO mail.wrs.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755932AbZEFCAV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 May 2009 22:00:21 -0400
From: Jason Wessel <jason.wessel@windriver.com>
To: greg@kroah.com
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
       Jason Wessel <jason.wessel@windriver.com>
Subject: [PATCH 1/5] usb_debug: implement multi urb write
Date: Tue,  5 May 2009 21:00:01 -0500
Message-Id: <1241575205-12199-2-git-send-email-jason.wessel@windriver.com>
X-Mailer: git-send-email 1.6.3.rc0.1.gf800
In-Reply-To: <1241575205-12199-1-git-send-email-jason.wessel@windriver.com>
References: <1241575205-12199-1-git-send-email-jason.wessel@windriver.com>
X-OriginalArrivalTime: 06 May 2009 02:00:01.0081 (UTC) FILETIME=[5D77C290:01C9CDEE]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The usb_debug driver, when used as the console, will always fail to
insert the carriage return and new line sequence as well as randomly
drop console output.  This is a result of only having the single
write_urb and that the tty layer will have a lock that prevents the
processing of the back to back urb requests.

The solution is to allow more than one urb to be outstanding and have
a slightly deeper transmit queue.  The idea and some code is borrowed
from the ftdi_sio usb driver.

This patch does not solve the problem of lost console writes during
the kernel boot, but it does allow the usb_debug driver to function as
a usable interactive console.

Signed-off-by: Jason Wessel <jason.wessel@windriver.com>
---
 drivers/usb/serial/usb_debug.c |  177 ++++++++++++++++++++++++++++++++++++++++
 1 files changed, 177 insertions(+), 0 deletions(-)

diff --git a/drivers/usb/serial/usb_debug.c b/drivers/usb/serial/usb_debug.c
index 6c9cbb5..ec88c26 100644
--- a/drivers/usb/serial/usb_debug.c
+++ b/drivers/usb/serial/usb_debug.c
@@ -2,6 +2,7 @@
  * USB Debug cable driver
  *
  * Copyright (C) 2006 Greg Kroah-Hartman <greg@kroah.com>
+ * Copyright (C) 2009 Jason Wessel <jason.wessel@windriver.com>
  *
  *	This program is free software; you can redistribute it and/or
  *	modify it under the terms of the GNU General Public License version
@@ -15,7 +16,9 @@
 #include <linux/usb.h>
 #include <linux/usb/serial.h>
 
+#define URB_UPPER_LIMIT			42
 #define USB_DEBUG_MAX_PACKET_SIZE	8
+static int debug;
 
 static struct usb_device_id id_table [] = {
 	{ USB_DEVICE(0x0525, 0x127a) },
@@ -23,6 +26,11 @@ static struct usb_device_id id_table [] = {
 };
 MODULE_DEVICE_TABLE(usb, id_table);
 
+struct usb_debug_private {
+	spinlock_t tx_lock;
+	unsigned long tx_outstanding_urbs;
+};
+
 static struct usb_driver debug_driver = {
 	.name =		"debug",
 	.probe =	usb_serial_probe,
@@ -38,6 +46,170 @@ static int usb_debug_open(struct tty_struct *tty, struct usb_serial_port *port,
 	return usb_serial_generic_open(tty, port, filp);
 }
 
+static int usb_debug_port_remove(struct usb_serial_port *port)
+{
+	struct udb_debug_private *priv = usb_get_serial_port_data(port);
+
+	if (priv) {
+		usb_set_serial_port_data(port, NULL);
+		kfree(priv);
+	}
+	return 0;
+}
+static int usb_debug_port_probe(struct usb_serial_port *port)
+{
+	struct usb_debug_private *priv;
+
+	priv = kzalloc(sizeof(struct usb_debug_private), GFP_KERNEL);
+	if (!priv) {
+		dev_err(&port->dev, "%s- kmalloc(%Zd) failed.\n", __func__,
+					sizeof(struct usb_debug_private));
+		return -ENOMEM;
+	}
+	spin_lock_init(&priv->tx_lock);
+	if (port->write_urb) {
+		usb_free_urb(port->write_urb);
+		port->write_urb = NULL;
+	}
+	if (port->bulk_out_buffer) {
+		kfree(port->bulk_out_buffer);
+		port->bulk_out_buffer = NULL;
+	}
+
+	usb_set_serial_port_data(port, priv);
+	return 0;
+}
+
+static int usb_debug_write_room(struct tty_struct *tty)
+{
+	unsigned long flags;
+	struct usb_serial_port *port = tty->driver_data;
+	struct usb_debug_private *priv = usb_get_serial_port_data(port);
+	int room = 0;
+
+	dbg("%s - port %d", __func__, port->number);
+
+	spin_lock_irqsave(&priv->tx_lock, flags);
+	if (priv->tx_outstanding_urbs < URB_UPPER_LIMIT)
+		room = port->bulk_out_size;
+	spin_unlock_irqrestore(&priv->tx_lock, flags);
+
+	dbg("%s - returns %d", __func__, room);
+	return room;
+}
+
+static void usb_debug_write_bulk_callback(struct urb *urb)
+{
+	unsigned long flags;
+	struct usb_serial_port *port = urb->context;
+	struct usb_debug_private *priv;
+	int status = urb->status;
+
+	/* free up the transfer buffer, as usb_free_urb() does not do this */
+	kfree(urb->transfer_buffer);
+
+	dbg("%s - port %d", __func__, port->number);
+
+	if (status) {
+		dbg("nonzero write bulk status received: %d", status);
+		return;
+	}
+
+	priv = usb_get_serial_port_data(port);
+	if (!priv) {
+		dbg("%s - bad port private data pointer - exiting", __func__);
+		return;
+	}
+
+	spin_lock_irqsave(&priv->tx_lock, flags);
+	--priv->tx_outstanding_urbs;
+	spin_unlock_irqrestore(&priv->tx_lock, flags);
+
+	usb_serial_port_softint(port);
+}
+
+static int usb_debug_write(struct tty_struct *tty,
+	struct usb_serial_port *port, const unsigned char *buf, int count)
+{
+	struct usb_debug_private *priv = usb_get_serial_port_data(port);
+	unsigned long flags;
+	struct urb *urb;
+	unsigned char *buffer;
+	int status;
+	int towrite;
+	int bwrite = 0;
+
+	dbg("%s - port %d", __func__, port->number);
+
+	if (count == 0)
+		dbg("%s - write request of 0 bytes", __func__);
+
+	while (count > 0) {
+		spin_lock_irqsave(&priv->tx_lock, flags);
+		if (priv->tx_outstanding_urbs > URB_UPPER_LIMIT) {
+			spin_unlock_irqrestore(&priv->tx_lock, flags);
+			dbg("%s - write limit hit\n", __func__);
+			return bwrite;
+		}
+
+		priv->tx_outstanding_urbs++;
+		spin_unlock_irqrestore(&priv->tx_lock, flags);
+
+		towrite = (count > port->bulk_out_size) ?
+			port->bulk_out_size : count;
+
+		buffer = kmalloc(towrite, GFP_ATOMIC);
+		if (!buffer) {
+			dev_err(&port->dev,
+			"%s ran out of kernel memory for urb ...\n", __func__);
+			goto error_no_buffer;
+		}
+
+		urb = usb_alloc_urb(0, GFP_ATOMIC);
+		if (!urb) {
+			dev_err(&port->dev, "%s - no more free urbs\n",
+				__func__);
+			goto error_no_urb;
+		}
+
+		/* Copy data */
+		memcpy(buffer, buf + bwrite, towrite);
+		usb_serial_debug_data(debug, &port->dev, __func__,
+				      towrite, buffer);
+		/* fill the buffer and send it */
+		usb_fill_bulk_urb(urb, port->serial->dev,
+			usb_sndbulkpipe(port->serial->dev,
+					port->bulk_out_endpointAddress),
+			buffer, towrite,
+			usb_debug_write_bulk_callback, port);
+
+		status = usb_submit_urb(urb, GFP_ATOMIC);
+		if (status) {
+			dev_err(&port->dev,
+				"%s - failed submitting write urb, error %d\n",
+				__func__, status);
+			goto error;
+		}
+
+		/* This urb is the responsibility of the host driver now */
+		usb_free_urb(urb);
+		dbg("%s write: %d", __func__, towrite);
+		count -= towrite;
+		bwrite += towrite;
+	}
+	return bwrite;
+
+error:
+	usb_free_urb(urb);
+error_no_urb:
+	kfree(buffer);
+error_no_buffer:
+	spin_lock_irqsave(&priv->tx_lock, flags);
+	priv->tx_outstanding_urbs--;
+	spin_unlock_irqrestore(&priv->tx_lock, flags);
+	return bwrite;
+}
+
 static struct usb_serial_driver debug_device = {
 	.driver = {
 		.owner =	THIS_MODULE,
@@ -46,6 +218,11 @@ static struct usb_serial_driver debug_device = {
 	.id_table =		id_table,
 	.num_ports =		1,
 	.open =			usb_debug_open,
+	.port_probe = 		usb_debug_port_probe,
+	.port_remove = 		usb_debug_port_remove,
+	.write = 		usb_debug_write,
+	.write_bulk_callback = 	usb_debug_write_bulk_callback,
+	.write_room = 		usb_debug_write_room,
 };
 
 static int __init debug_init(void)
-- 
1.6.3.rc0.1.gf800

