Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754800Ab0CCPCE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Mar 2010 10:02:04 -0500
Received: from mail-ew0-f220.google.com ([209.85.219.220]:51417 "EHLO
	mail-ew0-f220.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754301Ab0CCPCA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Mar 2010 10:02:00 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=l1MajbyDFRPRrmOaHA0iK36el3u3NV8mRkzglfWjQVZDzt2o3hkoNEAFnPdsgv4BEK
         imRCjYPKBrDISHzkswSP3nPXJjJCwbbNk5qi+g58Q+wZ6PYZvF0GUYJQtCV12AAbeH5s
         Ztx1rLoTDyWH4stRTGS8plE7zGq7M9MzVy9DM=
From: Johan Hovold <jhovold@gmail.com>
To: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Greg KH <greg@kroah.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Peter Feuerer <peter@piie.net>, Johan Hovold <jhovold@gmail.com>
Subject: [PATCH] USB: pl2303: switch to generic write implementation
Date: Wed,  3 Mar 2010 16:01:33 +0100
Message-Id: <1267628493-30080-1-git-send-email-jhovold@gmail.com>
X-Mailer: git-send-email 1.7.0
In-Reply-To: <20100303145046.GB15162@localhost>
References: <20100303145046.GB15162@localhost>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Replace custom fifo-based write implementation with the generic
kfifo-based one.

Signed-off-by: Johan Hovold <jhovold@gmail.com>
---

Forgot to cc the lists...


 drivers/usb/serial/pl2303.c |  332 +------------------------------------------
 1 files changed, 4 insertions(+), 328 deletions(-)

diff --git a/drivers/usb/serial/pl2303.c b/drivers/usb/serial/pl2303.c
index 9ec1a49..00d64db 100644
--- a/drivers/usb/serial/pl2303.c
+++ b/drivers/usb/serial/pl2303.c
@@ -40,16 +40,6 @@ static int debug;
 
 #define PL2303_CLOSING_WAIT	(30*HZ)
 
-#define PL2303_BUF_SIZE		1024
-#define PL2303_TMP_BUF_SIZE	1024
-
-struct pl2303_buf {
-	unsigned int	buf_size;
-	char		*buf_buf;
-	char		*buf_get;
-	char		*buf_put;
-};
-
 static struct usb_device_id id_table [] = {
 	{ USB_DEVICE(PL2303_VENDOR_ID, PL2303_PRODUCT_ID) },
 	{ USB_DEVICE(PL2303_VENDOR_ID, PL2303_PRODUCT_ID_RSAQ2) },
@@ -155,173 +145,12 @@ enum pl2303_type {
 
 struct pl2303_private {
 	spinlock_t lock;
-	struct pl2303_buf *buf;
-	int write_urb_in_use;
 	wait_queue_head_t delta_msr_wait;
 	u8 line_control;
 	u8 line_status;
 	enum pl2303_type type;
 };
 
-/*
- * pl2303_buf_alloc
- *
- * Allocate a circular buffer and all associated memory.
- */
-static struct pl2303_buf *pl2303_buf_alloc(unsigned int size)
-{
-	struct pl2303_buf *pb;
-
-	if (size == 0)
-		return NULL;
-
-	pb = kmalloc(sizeof(struct pl2303_buf), GFP_KERNEL);
-	if (pb == NULL)
-		return NULL;
-
-	pb->buf_buf = kmalloc(size, GFP_KERNEL);
-	if (pb->buf_buf == NULL) {
-		kfree(pb);
-		return NULL;
-	}
-
-	pb->buf_size = size;
-	pb->buf_get = pb->buf_put = pb->buf_buf;
-
-	return pb;
-}
-
-/*
- * pl2303_buf_free
- *
- * Free the buffer and all associated memory.
- */
-static void pl2303_buf_free(struct pl2303_buf *pb)
-{
-	if (pb) {
-		kfree(pb->buf_buf);
-		kfree(pb);
-	}
-}
-
-/*
- * pl2303_buf_clear
- *
- * Clear out all data in the circular buffer.
- */
-static void pl2303_buf_clear(struct pl2303_buf *pb)
-{
-	if (pb != NULL)
-		pb->buf_get = pb->buf_put;
-		/* equivalent to a get of all data available */
-}
-
-/*
- * pl2303_buf_data_avail
- *
- * Return the number of bytes of data available in the circular
- * buffer.
- */
-static unsigned int pl2303_buf_data_avail(struct pl2303_buf *pb)
-{
-	if (pb == NULL)
-		return 0;
-
-	return (pb->buf_size + pb->buf_put - pb->buf_get) % pb->buf_size;
-}
-
-/*
- * pl2303_buf_space_avail
- *
- * Return the number of bytes of space available in the circular
- * buffer.
- */
-static unsigned int pl2303_buf_space_avail(struct pl2303_buf *pb)
-{
-	if (pb == NULL)
-		return 0;
-
-	return (pb->buf_size + pb->buf_get - pb->buf_put - 1) % pb->buf_size;
-}
-
-/*
- * pl2303_buf_put
- *
- * Copy data data from a user buffer and put it into the circular buffer.
- * Restrict to the amount of space available.
- *
- * Return the number of bytes copied.
- */
-static unsigned int pl2303_buf_put(struct pl2303_buf *pb, const char *buf,
-				   unsigned int count)
-{
-	unsigned int len;
-
-	if (pb == NULL)
-		return 0;
-
-	len  = pl2303_buf_space_avail(pb);
-	if (count > len)
-		count = len;
-
-	if (count == 0)
-		return 0;
-
-	len = pb->buf_buf + pb->buf_size - pb->buf_put;
-	if (count > len) {
-		memcpy(pb->buf_put, buf, len);
-		memcpy(pb->buf_buf, buf+len, count - len);
-		pb->buf_put = pb->buf_buf + count - len;
-	} else {
-		memcpy(pb->buf_put, buf, count);
-		if (count < len)
-			pb->buf_put += count;
-		else /* count == len */
-			pb->buf_put = pb->buf_buf;
-	}
-
-	return count;
-}
-
-/*
- * pl2303_buf_get
- *
- * Get data from the circular buffer and copy to the given buffer.
- * Restrict to the amount of data available.
- *
- * Return the number of bytes copied.
- */
-static unsigned int pl2303_buf_get(struct pl2303_buf *pb, char *buf,
-				   unsigned int count)
-{
-	unsigned int len;
-
-	if (pb == NULL)
-		return 0;
-
-	len = pl2303_buf_data_avail(pb);
-	if (count > len)
-		count = len;
-
-	if (count == 0)
-		return 0;
-
-	len = pb->buf_buf + pb->buf_size - pb->buf_get;
-	if (count > len) {
-		memcpy(buf, pb->buf_get, len);
-		memcpy(buf+len, pb->buf_buf, count - len);
-		pb->buf_get = pb->buf_buf + count - len;
-	} else {
-		memcpy(buf, pb->buf_get, count);
-		if (count < len)
-			pb->buf_get += count;
-		else /* count == len */
-			pb->buf_get = pb->buf_buf;
-	}
-
-	return count;
-}
-
 static int pl2303_vendor_read(__u16 value, __u16 index,
 		struct usb_serial *serial, unsigned char *buf)
 {
@@ -369,12 +198,6 @@ static int pl2303_startup(struct usb_serial *serial)
 		priv = kzalloc(sizeof(struct pl2303_private), GFP_KERNEL);
 		if (!priv)
 			goto cleanup;
-		spin_lock_init(&priv->lock);
-		priv->buf = pl2303_buf_alloc(PL2303_BUF_SIZE);
-		if (priv->buf == NULL) {
-			kfree(priv);
-			goto cleanup;
-		}
 		init_waitqueue_head(&priv->delta_msr_wait);
 		priv->type = type;
 		usb_set_serial_port_data(serial->port[i], priv);
@@ -402,7 +225,6 @@ cleanup:
 	kfree(buf);
 	for (--i; i >= 0; --i) {
 		priv = usb_get_serial_port_data(serial->port[i]);
-		pl2303_buf_free(priv->buf);
 		kfree(priv);
 		usb_set_serial_port_data(serial->port[i], NULL);
 	}
@@ -420,103 +242,6 @@ static int set_control_lines(struct usb_device *dev, u8 value)
 	return retval;
 }
 
-static void pl2303_send(struct usb_serial_port *port)
-{
-	int count, result;
-	struct pl2303_private *priv = usb_get_serial_port_data(port);
-	unsigned long flags;
-
-	dbg("%s - port %d", __func__, port->number);
-
-	spin_lock_irqsave(&priv->lock, flags);
-
-	if (priv->write_urb_in_use) {
-		spin_unlock_irqrestore(&priv->lock, flags);
-		return;
-	}
-
-	count = pl2303_buf_get(priv->buf, port->write_urb->transfer_buffer,
-			       port->bulk_out_size);
-
-	if (count == 0) {
-		spin_unlock_irqrestore(&priv->lock, flags);
-		return;
-	}
-
-	priv->write_urb_in_use = 1;
-
-	spin_unlock_irqrestore(&priv->lock, flags);
-
-	usb_serial_debug_data(debug, &port->dev, __func__, count,
-			      port->write_urb->transfer_buffer);
-
-	port->write_urb->transfer_buffer_length = count;
-	port->write_urb->dev = port->serial->dev;
-	result = usb_submit_urb(port->write_urb, GFP_ATOMIC);
-	if (result) {
-		dev_err(&port->dev, "%s - failed submitting write urb,"
-			" error %d\n", __func__, result);
-		priv->write_urb_in_use = 0;
-		/* TODO: reschedule pl2303_send */
-	}
-
-	usb_serial_port_softint(port);
-}
-
-static int pl2303_write(struct tty_struct *tty, struct usb_serial_port *port,
-				const unsigned char *buf, int count)
-{
-	struct pl2303_private *priv = usb_get_serial_port_data(port);
-	unsigned long flags;
-
-	dbg("%s - port %d, %d bytes", __func__, port->number, count);
-
-	if (!count)
-		return count;
-
-	spin_lock_irqsave(&priv->lock, flags);
-	count = pl2303_buf_put(priv->buf, buf, count);
-	spin_unlock_irqrestore(&priv->lock, flags);
-
-	pl2303_send(port);
-
-	return count;
-}
-
-static int pl2303_write_room(struct tty_struct *tty)
-{
-	struct usb_serial_port *port = tty->driver_data;
-	struct pl2303_private *priv = usb_get_serial_port_data(port);
-	int room = 0;
-	unsigned long flags;
-
-	dbg("%s - port %d", __func__, port->number);
-
-	spin_lock_irqsave(&priv->lock, flags);
-	room = pl2303_buf_space_avail(priv->buf);
-	spin_unlock_irqrestore(&priv->lock, flags);
-
-	dbg("%s - returns %d", __func__, room);
-	return room;
-}
-
-static int pl2303_chars_in_buffer(struct tty_struct *tty)
-{
-	struct usb_serial_port *port = tty->driver_data;
-	struct pl2303_private *priv = usb_get_serial_port_data(port);
-	int chars = 0;
-	unsigned long flags;
-
-	dbg("%s - port %d", __func__, port->number);
-
-	spin_lock_irqsave(&priv->lock, flags);
-	chars = pl2303_buf_data_avail(priv->buf);
-	spin_unlock_irqrestore(&priv->lock, flags);
-
-	dbg("%s - returns %d", __func__, chars);
-	return chars;
-}
-
 static void pl2303_set_termios(struct tty_struct *tty,
 		struct usb_serial_port *port, struct ktermios *old_termios)
 {
@@ -728,15 +453,14 @@ static void pl2303_dtr_rts(struct usb_serial_port *port, int on)
 
 static void pl2303_close(struct usb_serial_port *port)
 {
-	struct pl2303_private *priv = usb_get_serial_port_data(port);
 	unsigned long flags;
 
 	dbg("%s - port %d", __func__, port->number);
 
-	spin_lock_irqsave(&priv->lock, flags);
+	spin_lock_irqsave(&port->lock, flags);
 	/* clear out any remaining data in the buffer */
-	pl2303_buf_clear(priv->buf);
-	spin_unlock_irqrestore(&priv->lock, flags);
+	kfifo_reset_out(&port->write_fifo);
+	spin_unlock_irqrestore(&port->lock, flags);
 
 	/* shutdown our urbs */
 	dbg("%s - shutting down urbs", __func__);
@@ -941,10 +665,8 @@ static void pl2303_release(struct usb_serial *serial)
 
 	for (i = 0; i < serial->num_ports; ++i) {
 		priv = usb_get_serial_port_data(serial->port[i]);
-		if (priv) {
-			pl2303_buf_free(priv->buf);
+		if (priv)
 			kfree(priv);
-		}
 	}
 }
 
@@ -1119,48 +841,6 @@ static void pl2303_read_bulk_callback(struct urb *urb)
 	return;
 }
 
-static void pl2303_write_bulk_callback(struct urb *urb)
-{
-	struct usb_serial_port *port =  urb->context;
-	struct pl2303_private *priv = usb_get_serial_port_data(port);
-	int result;
-	int status = urb->status;
-
-	dbg("%s - port %d", __func__, port->number);
-
-	switch (status) {
-	case 0:
-		/* success */
-		break;
-	case -ECONNRESET:
-	case -ENOENT:
-	case -ESHUTDOWN:
-		/* this urb is terminated, clean up */
-		dbg("%s - urb shutting down with status: %d", __func__,
-		    status);
-		priv->write_urb_in_use = 0;
-		return;
-	default:
-		/* error in the urb, so we have to resubmit it */
-		dbg("%s - Overflow in write", __func__);
-		dbg("%s - nonzero write bulk status received: %d", __func__,
-		    status);
-		port->write_urb->transfer_buffer_length = 1;
-		port->write_urb->dev = port->serial->dev;
-		result = usb_submit_urb(port->write_urb, GFP_ATOMIC);
-		if (result)
-			dev_err(&urb->dev->dev, "%s - failed resubmitting write"
-				" urb, error %d\n", __func__, result);
-		else
-			return;
-	}
-
-	priv->write_urb_in_use = 0;
-
-	/* send any buffered data */
-	pl2303_send(port);
-}
-
 /* All of the device info needed for the PL2303 SIO serial converter */
 static struct usb_serial_driver pl2303_device = {
 	.driver = {
@@ -1174,7 +854,6 @@ static struct usb_serial_driver pl2303_device = {
 	.close =		pl2303_close,
 	.dtr_rts = 		pl2303_dtr_rts,
 	.carrier_raised =	pl2303_carrier_raised,
-	.write =		pl2303_write,
 	.ioctl =		pl2303_ioctl,
 	.break_ctl =		pl2303_break_ctl,
 	.set_termios =		pl2303_set_termios,
@@ -1182,9 +861,6 @@ static struct usb_serial_driver pl2303_device = {
 	.tiocmset =		pl2303_tiocmset,
 	.read_bulk_callback =	pl2303_read_bulk_callback,
 	.read_int_callback =	pl2303_read_int_callback,
-	.write_bulk_callback =	pl2303_write_bulk_callback,
-	.write_room =		pl2303_write_room,
-	.chars_in_buffer =	pl2303_chars_in_buffer,
 	.attach =		pl2303_startup,
 	.release =		pl2303_release,
 };
-- 
1.7.0

