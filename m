Return-Path: <linux-kernel-owner+w=401wt.eu-S1757029AbYAZAuv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757029AbYAZAuv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2008 19:50:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752509AbYAZAul
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jan 2008 19:50:41 -0500
Received: from hawking.rebel.net.au ([203.20.69.83]:33039 "EHLO
	hawking.rebel.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754059AbYAZAuj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2008 19:50:39 -0500
Message-ID: <479A83DE.8020002@davidnewall.com>
Date: Sat, 26 Jan 2008 11:20:38 +1030
From: David Newall <davidn@davidnewall.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20071022)
MIME-Version: 1.0
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
CC: Willy Tarreau <w@1wt.eu>
Subject: [PATCH] 2.4: Back-port of pl2303.c from 2.6.23.14
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I experienced major major data loss on a PL-2303 USB-serial converter
under 2.4.36, which I remedied by back-porting the pl2303.c from the
latest 2.6 kernel tree.

---

diff -u linux-2.4.36/drivers/usb/serial/pl2303.c.orig linux-2.4.36/drivers/usb/serial/pl2303.c
--- pl2303.c.orig	2008-01-01 22:36:40.000000000 +1030
+++ pl2303.c	2008-01-26 05:32:00.000000000 +1030
@@ -1,17 +1,20 @@
 /*
  * Prolific PL2303 USB to serial adaptor driver
  *
- * Copyright (C) 2001-2003 Greg Kroah-Hartman (greg@kroah.com)
+ * Copyright (C) 2001-2007 Greg Kroah-Hartman (greg@kroah.com)
  * Copyright (C) 2003 IBM Corp.
  *
  * Original driver for 2.2.x by anonymous
  *
- *	This program is free software; you can redistribute it and/or modify
- *	it under the terms of the GNU General Public License as published by
- *	the Free Software Foundation; either version 2 of the License, or
- *	(at your option) any later version.
+ *	This program is free software; you can redistribute it and/or
+ *	modify it under the terms of the GNU General Public License version
+ *	2 as published by the Free Software Foundation.
  *
  * See Documentation/usb/usb-serial.txt for more information on using this driver
+ * 2007_Jan_25 dn
+ *	Back-port pl2303.c from linux-2.6.23.14 - corrects major loss of
+ *	transmitted data, plus minor loss during close. davidn@davidnewall.com.
+ *
  * 2003_Apr_24 gkh
  *	Added line error reporting support.  Hopefully it is correct...
  *
@@ -33,6 +36,9 @@
  * 
  */
 
+/* TODO first char sent is lost on second open of device.  anecdotal evidence
+ * TODO suggests this might be on all even opens of device. dn. */
+
 #include <linux/config.h>
 #include <linux/kernel.h>
 #include <linux/errno.h>
@@ -59,31 +65,60 @@
 /*
  * Version Information
  */
-#define DRIVER_VERSION "v0.10.1"	/* Takes from 2.6's */
 #define DRIVER_DESC "Prolific PL2303 USB to serial adaptor driver"
 
+#define PL2303_CLOSING_WAIT	(30*HZ)
 
+#define PL2303_BUF_SIZE		1024
+#define PL2303_TMP_BUF_SIZE	1024
+
+struct pl2303_buf {
+	unsigned int	buf_size;
+	char		*buf_buf;
+	char		*buf_get;
+	char		*buf_put;
+};
 
 static struct usb_device_id id_table [] = {
 	{ USB_DEVICE(PL2303_VENDOR_ID, PL2303_PRODUCT_ID) },
 	{ USB_DEVICE(PL2303_VENDOR_ID, PL2303_PRODUCT_ID_RSAQ2) },
+	{ USB_DEVICE(PL2303_VENDOR_ID, PL2303_PRODUCT_ID_DCU11) },
+	{ USB_DEVICE(PL2303_VENDOR_ID, PL2303_PRODUCT_ID_RSAQ3) },
+	{ USB_DEVICE(PL2303_VENDOR_ID, PL2303_PRODUCT_ID_PHAROS) },
 	{ USB_DEVICE(IODATA_VENDOR_ID, IODATA_PRODUCT_ID) },
 	{ USB_DEVICE(ATEN_VENDOR_ID, ATEN_PRODUCT_ID) },
 	{ USB_DEVICE(ATEN_VENDOR_ID2, ATEN_PRODUCT_ID) },
 	{ USB_DEVICE(ELCOM_VENDOR_ID, ELCOM_PRODUCT_ID) },
+	{ USB_DEVICE(ELCOM_VENDOR_ID, ELCOM_PRODUCT_ID_UCSGT) },
 	{ USB_DEVICE(ITEGNO_VENDOR_ID, ITEGNO_PRODUCT_ID) },
+	{ USB_DEVICE(ITEGNO_VENDOR_ID, ITEGNO_PRODUCT_ID_2080) },
 	{ USB_DEVICE(MA620_VENDOR_ID, MA620_PRODUCT_ID) },
 	{ USB_DEVICE(RATOC_VENDOR_ID, RATOC_PRODUCT_ID) },
 	{ USB_DEVICE(TRIPP_VENDOR_ID, TRIPP_PRODUCT_ID) },
 	{ USB_DEVICE(RADIOSHACK_VENDOR_ID, RADIOSHACK_PRODUCT_ID) },
 	{ USB_DEVICE(DCU10_VENDOR_ID, DCU10_PRODUCT_ID) },
 	{ USB_DEVICE(SITECOM_VENDOR_ID, SITECOM_PRODUCT_ID) },
+	{ USB_DEVICE(ALCATEL_VENDOR_ID, ALCATEL_PRODUCT_ID) },
+	{ USB_DEVICE(SAMSUNG_VENDOR_ID, SAMSUNG_PRODUCT_ID) },
+	{ USB_DEVICE(SIEMENS_VENDOR_ID, SIEMENS_PRODUCT_ID_SX1) },
+	{ USB_DEVICE(SIEMENS_VENDOR_ID, SIEMENS_PRODUCT_ID_X65) },
+	{ USB_DEVICE(SIEMENS_VENDOR_ID, SIEMENS_PRODUCT_ID_X75) },
+	{ USB_DEVICE(SYNTECH_VENDOR_ID, SYNTECH_PRODUCT_ID) },
+	{ USB_DEVICE(NOKIA_CA42_VENDOR_ID, NOKIA_CA42_PRODUCT_ID) },
+	{ USB_DEVICE(CA_42_CA42_VENDOR_ID, CA_42_CA42_PRODUCT_ID) },
+	{ USB_DEVICE(SAGEM_VENDOR_ID, SAGEM_PRODUCT_ID) },
+	{ USB_DEVICE(LEADTEK_VENDOR_ID, LEADTEK_9531_PRODUCT_ID) },
+	{ USB_DEVICE(SPEEDDRAGON_VENDOR_ID, SPEEDDRAGON_PRODUCT_ID) },
+	{ USB_DEVICE(DATAPILOT_U2_VENDOR_ID, DATAPILOT_U2_PRODUCT_ID) },
+	{ USB_DEVICE(BELKIN_VENDOR_ID, BELKIN_PRODUCT_ID) },
+	{ USB_DEVICE(ALCOR_VENDOR_ID, ALCOR_PRODUCT_ID) },
+	{ USB_DEVICE(HUAWEI_VENDOR_ID, HUAWEI_PRODUCT_ID) },
+	{ USB_DEVICE(WS002IN_VENDOR_ID, WS002IN_PRODUCT_ID) },
 	{ }					/* Terminating entry */
 };
 
 MODULE_DEVICE_TABLE (usb, id_table);
 
-
 #define SET_LINE_REQUEST_TYPE		0x21
 #define SET_LINE_REQUEST		0x20
 
@@ -164,6 +199,8 @@
 
 struct pl2303_private {
 	spinlock_t lock;
+	struct pl2303_buf *buf;
+	int write_urb_in_use;
 	wait_queue_head_t delta_msr_wait;
 	u8 line_control;
 	u8 line_status;
@@ -171,6 +208,175 @@
 	enum pl2303_type type;
 };
 
+/*
+ * pl2303_buf_alloc
+ *
+ * Allocate a circular buffer and all associated memory.
+ */
+static struct pl2303_buf *pl2303_buf_alloc(unsigned int size)
+{
+	struct pl2303_buf *pb;
+
+	if (size == 0)
+		return NULL;
+
+	pb = kmalloc(sizeof(struct pl2303_buf), GFP_KERNEL);
+	if (pb == NULL)
+		return NULL;
+
+	pb->buf_buf = kmalloc(size, GFP_KERNEL);
+	if (pb->buf_buf == NULL) {
+		kfree(pb);
+		return NULL;
+	}
+
+	pb->buf_size = size;
+	pb->buf_get = pb->buf_put = pb->buf_buf;
+
+	return pb;
+}
+
+/*
+ * pl2303_buf_free
+ *
+ * Free the buffer and all associated memory.
+ */
+static void pl2303_buf_free(struct pl2303_buf *pb)
+{
+	if (pb) {
+		kfree(pb->buf_buf);
+		kfree(pb);
+	}
+}
+
+/*
+ * pl2303_buf_clear
+ *
+ * Clear out all data in the circular buffer.
+ */
+static void pl2303_buf_clear(struct pl2303_buf *pb)
+{
+	if (pb != NULL)
+		pb->buf_get = pb->buf_put;
+		/* equivalent to a get of all data available */
+}
+
+/*
+ * pl2303_buf_data_avail
+ *
+ * Return the number of bytes of data available in the circular
+ * buffer.
+ */
+static unsigned int pl2303_buf_data_avail(struct pl2303_buf *pb)
+{
+	if (pb == NULL)
+		return 0;
+
+	return ((pb->buf_size + pb->buf_put - pb->buf_get) % pb->buf_size);
+}
+
+/*
+ * pl2303_buf_space_avail
+ *
+ * Return the number of bytes of space available in the circular
+ * buffer.
+ */
+static unsigned int pl2303_buf_space_avail(struct pl2303_buf *pb)
+{
+	if (pb == NULL)
+		return 0;
+
+	return ((pb->buf_size + pb->buf_get - pb->buf_put - 1) % pb->buf_size);
+}
+
+static int copy_in(char *dest, int from_user, const char *source, unsigned count)
+{
+	if (!from_user)
+		memcpy (dest, source, count);
+	else if (copy_from_user (dest, source, count))
+		return -EFAULT;
+	return count;
+}
+
+/*
+ * pl2303_buf_put
+ *
+ * Copy data data from a user buffer and put it into the circular buffer.
+ * Restrict to the amount of space available.
+ *
+ * Return the number of bytes copied.
+ */
+static unsigned int pl2303_buf_put(struct pl2303_buf *pb, int from_user, const char *buf, unsigned int count)
+{
+	unsigned int len;
+
+	if (pb == NULL)
+		return 0;
+
+	len  = pl2303_buf_space_avail(pb);
+	if (count > len)
+		count = len;
+
+	if (count == 0)
+		return 0;
+
+	len = pb->buf_buf + pb->buf_size - pb->buf_put;
+	if (count > len) {
+		if (copy_in(pb->buf_put, from_user, buf, len) < 0)
+			return -EFAULT;
+ 		if (copy_in(pb->buf_buf, from_user, buf+len, count - len) < 0)
+			return -EFAULT;
+		pb->buf_put = pb->buf_buf + count - len;
+	} else {
+		if (copy_in(pb->buf_put, from_user, buf, count) < 0)
+			return -EFAULT;
+		if (count < len)
+			pb->buf_put += count;
+		else /* count == len */
+			pb->buf_put = pb->buf_buf;
+	}
+
+	return count;
+}
+
+/*
+ * pl2303_buf_get
+ *
+ * Get data from the circular buffer and copy to the given buffer.
+ * Restrict to the amount of data available.
+ *
+ * Return the number of bytes copied.
+ */
+static unsigned int pl2303_buf_get(struct pl2303_buf *pb, char *buf,
+				   unsigned int count)
+{
+	unsigned int len;
+
+	if (pb == NULL)
+		return 0;
+
+	len = pl2303_buf_data_avail(pb);
+	if (count > len)
+		count = len;
+
+	if (count == 0)
+		return 0;
+
+	len = pb->buf_buf + pb->buf_size - pb->buf_get;
+	if (count > len) {
+		memcpy(buf, pb->buf_get, len);
+		memcpy(buf+len, pb->buf_buf, count - len);
+		pb->buf_get = pb->buf_buf + count - len;
+	} else {
+		memcpy(buf, pb->buf_get, count);
+		if (count < len)
+			pb->buf_get += count;
+		else /* count == len */
+			pb->buf_get = pb->buf_buf;
+	}
+
+	return count;
+}
 
 static int pl2303_startup (struct usb_serial *serial)
 {
@@ -191,14 +397,28 @@
 	for (i = 0; i < serial->num_ports; ++i) {
 		priv = kmalloc (sizeof (struct pl2303_private), GFP_KERNEL);
 		if (!priv)
-			return -ENOMEM;
+			goto cleanup;
 		memset (priv, 0x00, sizeof (struct pl2303_private));
 		spin_lock_init(&priv->lock);
+		priv->buf = pl2303_buf_alloc(PL2303_BUF_SIZE);
+		if (priv->buf == NULL) {
+			kfree(priv);
+			goto cleanup;
+		}
 		init_waitqueue_head(&priv->delta_msr_wait);
 		usb_set_serial_port_data(&serial->port[i], priv);
 		priv->type = type;
 	}
 	return 0;
+
+cleanup:
+	for (--i; i>=0; --i) {
+		priv = usb_get_serial_port_data(&serial->port[i]);
+		pl2303_buf_free(priv->buf);
+		kfree(priv);
+		usb_set_serial_port_data(&serial->port[i], NULL);
+	}
+	return -ENOMEM;
 }
 
 static int set_control_lines (struct usb_device *dev, u8 value)
@@ -212,42 +432,65 @@
 	return retval;
 }
 
-static int pl2303_write (struct usb_serial_port *port, int from_user,  const unsigned char *buf, int count)
+static void pl2303_send(struct usb_serial_port *port)
 {
-	int result;
+	int count, result;
+	struct pl2303_private *priv = usb_get_serial_port_data(port);
+	unsigned long flags;
 
-	dbg("%s - port %d, %d bytes", __FUNCTION__, port->number, count);
+	dbg("%s - port %d", __FUNCTION__, port->number);
 
-	if (!count)
-		return count;
+	spin_lock_irqsave(&priv->lock, flags);
 
-	if (port->write_urb->status == -EINPROGRESS) {
-		dbg("%s - already writing", __FUNCTION__);
-		return 0;
+	if (priv->write_urb_in_use) {
+		spin_unlock_irqrestore(&priv->lock, flags);
+		return;
 	}
 
-	count = (count > port->bulk_out_size) ? port->bulk_out_size : count;
-	if (from_user) {
-		if (copy_from_user (port->write_urb->transfer_buffer, buf, count))
-			return -EFAULT;
-	} else {
-		memcpy (port->write_urb->transfer_buffer, buf, count);
+	count = pl2303_buf_get(priv->buf, port->write_urb->transfer_buffer,
+			       port->bulk_out_size);
+
+	if (count == 0) {
+		spin_unlock_irqrestore(&priv->lock, flags);
+		return;
 	}
 	
+	priv->write_urb_in_use = 1;
+
+	spin_unlock_irqrestore(&priv->lock, flags);
+
 	usb_serial_debug_data (__FILE__, __FUNCTION__, count, port->write_urb->transfer_buffer);
 
 	port->write_urb->transfer_buffer_length = count;
 	port->write_urb->dev = port->serial->dev;
 	result = usb_submit_urb (port->write_urb);
-	if (result)
+	if (result) {
 		err("%s - failed submitting write urb, error %d", __FUNCTION__, result);
-	else
-		result = count;
+		priv->write_urb_in_use = 0;
+		// TODO: reschedule pl2303_send
+	}
 
-	return result;
+	wake_up_interruptible(&port->tty->write_wait);	/* this, at very least, wakes up pl2303_close */
 }
+ 
+static int pl2303_write (struct usb_serial_port *port, int from_user, const unsigned char *buf, int count)
+{
+	struct pl2303_private *priv = usb_get_serial_port_data(port);
+	unsigned long flags;
 
+	dbg("%s - port %d, %d bytes", __FUNCTION__, port->number, count);
+
+	if (!count)
+		return count;
+
+	spin_lock_irqsave(&priv->lock, flags);
+	count = pl2303_buf_put(priv->buf, from_user, buf, count);
+	spin_unlock_irqrestore(&priv->lock, flags);
 
+	pl2303_send(port);
+
+	return count;
+}
 
 static void pl2303_set_termios (struct usb_serial_port *port, struct termios *old_termios)
 {
@@ -278,6 +521,7 @@
 
 	cflag = port->tty->termios->c_cflag;
 	/* check that they really want us to change something */
+	/* important to do this as even a null change can corrupt data in transit */
 	if (old_termios) {
 		if ((cflag == old_termios->c_cflag) &&
 		    (RELEVANT_IFLAG(port->tty->termios->c_iflag) == RELEVANT_IFLAG(old_termios->c_iflag))) {
@@ -299,7 +543,6 @@
 	dbg ("0xa1:0x21:0:0  %d - %x %x %x %x %x %x %x", i,
 	     buf[0], buf[1], buf[2], buf[3], buf[4], buf[5], buf[6]);
 
-
 	if (cflag & CSIZE) {
 		switch (cflag & CSIZE) {
 			case CS5:	buf[6] = 5;	break;
@@ -311,28 +554,7 @@
 		dbg("%s - data bits = %d", __FUNCTION__, buf[6]);
 	}
 
-	baud = 0;
-	switch (cflag & CBAUD) {
-		case B0:	baud = 0;	break;
-		case B75:	baud = 75;	break;
-		case B150:	baud = 150;	break;
-		case B300:	baud = 300;	break;
-		case B600:	baud = 600;	break;
-		case B1200:	baud = 1200;	break;
-		case B1800:	baud = 1800;	break;
-		case B2400:	baud = 2400;	break;
-		case B4800:	baud = 4800;	break;
-		case B9600:	baud = 9600;	break;
-		case B19200:	baud = 19200;	break;
-		case B38400:	baud = 38400;	break;
-		case B57600:	baud = 57600;	break;
-		case B115200:	baud = 115200;	break;
-		case B230400:	baud = 230400;	break;
-		case B460800:	baud = 460800;	break;
-		default:
-			err ("pl2303 driver does not support the baudrate requested (fix it)");
-			break;
-	}
+	baud = tty_get_baud_rate(port->tty);
 	dbg("%s - baud = %d", __FUNCTION__, baud);
 	if (baud) {
 		buf[0] = baud & 0xff;
@@ -410,6 +632,13 @@
 				    VENDOR_WRITE_REQUEST_TYPE,
 				    0x0, index, NULL, 0, 100);
 		dbg ("0x40:0x1:0x0:0x%x  %d", index, i);
+	} else {
+		i = usb_control_msg(serial->dev,
+				    usb_sndctrlpipe(serial->dev, 0),
+				    VENDOR_WRITE_REQUEST,
+				    VENDOR_WRITE_REQUEST_TYPE,
+				    0x0, 0x0, NULL, 0, 100);
+		dbg ("0x40:0x1:0x0:0x0  %d", i);
 	}
 
 	kfree (buf);
@@ -420,8 +649,8 @@
 {
 	struct termios tmp_termios;
 	struct usb_serial *serial = port->serial;
+	struct pl2303_private *priv = usb_get_serial_port_data(port);
 	unsigned char *buf;
-	struct pl2303_private *priv = port->private;
 	int result;
 
 	if (port_paranoia_check (port, __FUNCTION__))
@@ -429,8 +658,10 @@
 		
 	dbg("%s -  port %d", __FUNCTION__, port->number);
 
-	usb_clear_halt(serial->dev, port->write_urb->pipe);
-	usb_clear_halt(serial->dev, port->read_urb->pipe);
+	if (priv->type != HX) {
+		usb_clear_halt(serial->dev, port->write_urb->pipe);
+		usb_clear_halt(serial->dev, port->read_urb->pipe);
+	}
 
 	buf = kmalloc(10, GFP_KERNEL);
 	if (buf==NULL)
@@ -500,10 +731,12 @@
 static void pl2303_close (struct usb_serial_port *port, struct file *filp)
 {
 	struct usb_serial *serial;
-	struct pl2303_private *priv;
+	struct pl2303_private *priv = usb_get_serial_port_data(port);
 	unsigned long flags;
 	unsigned int c_cflag;
 	int result;
+	long timeout;
+	wait_queue_t wait;
 
 	if (port_paranoia_check (port, __FUNCTION__))
 		return;
@@ -513,6 +746,43 @@
 	
 	dbg("%s - port %d", __FUNCTION__, port->number);
 
+	/* wait for data to drain from the buffer */
+	spin_lock_irqsave(&priv->lock, flags);
+	timeout = PL2303_CLOSING_WAIT;
+	init_waitqueue_entry(&wait, current);
+	add_wait_queue(&port->tty->write_wait, &wait);
+	for (;;) {
+		dbg("%s - buf_data_avail %d",
+		    __FUNCTION__, pl2303_buf_data_avail(priv->buf));
+		set_current_state(TASK_INTERRUPTIBLE);
+		if (pl2303_buf_data_avail(priv->buf) == 0 ||
+		    timeout == 0 || signal_pending(current))
+			break;
+		spin_unlock_irqrestore(&priv->lock, flags);
+		timeout = schedule_timeout(timeout);
+		spin_lock_irqsave(&priv->lock, flags);
+	}
+	set_current_state(TASK_RUNNING);
+	remove_wait_queue(&port->tty->write_wait, &wait);
+	/* clear out any remaining data in the buffer */
+	pl2303_buf_clear(priv->buf);
+	spin_unlock_irqrestore(&priv->lock, flags);
+
+	/* wait for characters to drain from the device */
+	/* (this is long enough for the entire 256 byte */
+	/* pl2303 hardware buffer to drain with no flow */
+	/* control for data rates of 1200 bps or more, */
+	/* for lower rates we should really know how much */
+	/* data is in the buffer to compute a delay */
+	/* that is not unnecessarily long) */
+	int bps = tty_get_baud_rate(port->tty);
+	if (bps > 1200)
+		timeout = max((HZ*2560)/bps,HZ/10);
+	else
+		timeout = 2*HZ;
+	set_current_state(TASK_INTERRUPTIBLE);
+	schedule_timeout(timeout);
+
 	if (serial->dev) {
 		if (port->tty) {
 			c_cflag = port->tty->termios->c_cflag;
@@ -700,34 +970,68 @@
 		dbg("%s - error sending break = %d", __FUNCTION__, result);
 }
 
-
 static void pl2303_shutdown (struct usb_serial *serial)
 {
 	int i;
+	struct pl2303_private *priv;
 
 	dbg("%s", __FUNCTION__);
 
 	for (i = 0; i < serial->num_ports; ++i) {
-		kfree (usb_get_serial_port_data(&serial->port[i]));
-		usb_set_serial_port_data(&serial->port[i], NULL);
-	}		
+		priv = usb_get_serial_port_data(&serial->port[i]);
+		if (priv) {
+			pl2303_buf_free(priv->buf);
+			kfree(priv);
+			usb_set_serial_port_data(&serial->port[i], NULL);
+		}
+	}
 }
 
+static void pl2303_update_line_status(struct usb_serial_port *port,
+				      unsigned char *data,
+				      unsigned int actual_length)
+{
+	struct pl2303_private *priv = usb_get_serial_port_data(port);
+	unsigned long flags;
+	u8 status_idx = UART_STATE;
+	u8 length = UART_STATE + 1;
+	u16 idv, idp;
+
+	idv = le16_to_cpu(port->serial->dev->descriptor.idVendor);
+	idp = le16_to_cpu(port->serial->dev->descriptor.idProduct);
+
+
+	if (idv == SIEMENS_VENDOR_ID) {
+		if (idp == SIEMENS_PRODUCT_ID_X65 ||
+		    idp == SIEMENS_PRODUCT_ID_SX1 ||
+		    idp == SIEMENS_PRODUCT_ID_X75) {
+
+			length = 1;
+			status_idx = 0;
+		}
+	}
+
+	if (actual_length < length)
+		return;
+
+        /* Save off the uart status for others to look at */
+	spin_lock_irqsave(&priv->lock, flags);
+	priv->line_status = data[status_idx];
+	spin_unlock_irqrestore(&priv->lock, flags);
+	wake_up_interruptible(&priv->delta_msr_wait);
+}
 
 static void pl2303_read_int_callback (struct urb *urb)
 {
 	struct usb_serial_port *port = (struct usb_serial_port *) urb->context;
-	struct usb_serial *serial = get_usb_serial (port, __FUNCTION__);
-	struct pl2303_private *priv = usb_get_serial_port_data(port);
 	unsigned char *data = urb->transfer_buffer;
-	unsigned long flags;
-	u8 uart_state;
+	int status = urb->status;
 
 	dbg("%s (%d)", __FUNCTION__, port->number);
 
 	/* ints auto restart... */
 
-	switch (urb->status) {
+	switch (status) {
 	case 0:
 		/* success */
 		break;
@@ -735,34 +1039,26 @@
 	case -ENOENT:
 	case -ESHUTDOWN:
 		/* this urb is terminated, clean up */
-		dbg("%s - urb shutting down with status: %d", __FUNCTION__, urb->status);
+		dbg("%s - urb shutting down with status: %d", __FUNCTION__, status);
 		return;
 	default:
-		dbg("%s - nonzero urb status received: %d", __FUNCTION__, urb->status);
-		return;
-	}
-
-	if (!serial) {
-		return;
+		dbg("%s - nonzero urb status received: %d", __FUNCTION__, status);
+		goto exit;
 	}
 
 	usb_serial_debug_data (__FILE__, __FUNCTION__, urb->actual_length, urb->transfer_buffer);
 
-	if (urb->actual_length < UART_STATE)
-		return;
-
-	/* Save off the uart status for others to look at */
-	uart_state = data[UART_STATE];
-	spin_lock_irqsave(&priv->lock, flags);
-	uart_state |= (priv->line_status & UART_STATE_TRANSIENT_MASK);
-	priv->line_status = uart_state;
-	spin_unlock_irqrestore(&priv->lock, flags);
-	wake_up_interruptible (&priv->delta_msr_wait);
+	pl2303_update_line_status(port, data, urb->actual_length);
 
+exit:
+	status = usb_submit_urb(urb);
+	if (status)
+		err("%s - usb_submit_urb failed with result %d\n", __FUNCTION__, status);
+	else
+		dbg("%s - usb_submit_urb succeeded.  peaches.", __FUNCTION__);
 	return;
 }
 
-
 static void pl2303_read_bulk_callback (struct urb *urb)
 {
 	struct usb_serial_port *port = (struct usb_serial_port *) urb->context;
@@ -773,12 +1069,10 @@
 	unsigned long flags;
 	int i;
 	int result;
-	u8 status;
+	int status = urb->status;
+	u8 line_status;
 	char tty_flag;
 
-	if (port_paranoia_check (port, __FUNCTION__))
-		return;
-
 	dbg("%s - port %d", __FUNCTION__, port->number);
 
 	if (!serial) {
@@ -786,17 +1080,16 @@
 		return;
 	}
 
-	if (urb->status) {
-		dbg("%s - urb->status = %d", __FUNCTION__, urb->status);
+	if (status) {
+		dbg("%s - status = %d", __FUNCTION__, status);
 		if (!port->open_count) {
 			dbg("%s - port is closed, exiting.", __FUNCTION__);
 			return;
 		}
-		if (urb->status == -EPROTO) {
+		if (status == -EPROTO) {
 			/* PL2303 mysteriously fails with -EPROTO reschedule the read */
 			dbg("%s - caught -EPROTO, resubmitting the urb", __FUNCTION__);
-			urb->status = 0;
-			urb->dev = serial->dev;
+			urb->dev = port->serial->dev;
 			result = usb_submit_urb(urb);
 			if (result)
 				err("%s - failed resubmitting read urb, error %d", __FUNCTION__, result);
@@ -812,25 +1105,25 @@
 	tty_flag = TTY_NORMAL;
 
 	spin_lock_irqsave(&priv->lock, flags);
-	status = priv->line_status;
+	line_status = priv->line_status;
 	priv->line_status &= ~UART_STATE_TRANSIENT_MASK;
 	spin_unlock_irqrestore(&priv->lock, flags);
-	wake_up_interruptible (&priv->delta_msr_wait); //AF from 2.6
+	wake_up_interruptible (&priv->delta_msr_wait);
 
 	/* break takes precedence over parity, */
 	/* which takes precedence over framing errors */
-	if (status & UART_BREAK_ERROR )
+	if (line_status & UART_BREAK_ERROR )
 		tty_flag = TTY_BREAK;
-	else if (status & UART_PARITY_ERROR)
+	else if (line_status & UART_PARITY_ERROR)
 		tty_flag = TTY_PARITY;
-	else if (status & UART_FRAME_ERROR)
+	else if (line_status & UART_FRAME_ERROR)
 		tty_flag = TTY_FRAME;
 	dbg("%s - tty_flag = %d", __FUNCTION__, tty_flag);
 
 	tty = port->tty;
 	if (tty && urb->actual_length) {
 		/* overrun is special, not associated with a char */
-		if (status & UART_OVERRUN_ERROR)
+		if (line_status & UART_OVERRUN_ERROR)
 			tty_insert_flip_char(tty, 0, TTY_OVERRUN);
 
 		for (i = 0; i < urb->actual_length; ++i) {
@@ -844,7 +1137,7 @@
 
 	/* Schedule the next read _if_ we are still open */
 	if (port->open_count) {
-		urb->dev = serial->dev;
+		urb->dev = port->serial->dev;
 		result = usb_submit_urb(urb);
 		if (result)
 			err("%s - failed resubmitting read urb, error %d", __FUNCTION__, result);
@@ -853,38 +1146,50 @@
 	return;
 }
 
-
-
 static void pl2303_write_bulk_callback (struct urb *urb)
 {
 	struct usb_serial_port *port = (struct usb_serial_port *) urb->context;
+	struct pl2303_private *priv = usb_get_serial_port_data(port);
 	int result;
+	int status = urb->status;
 
 	if (port_paranoia_check (port, __FUNCTION__))
 		return;
 	
 	dbg("%s - port %d", __FUNCTION__, port->number);
 	
-	if (urb->status) {
+	switch (status) {
+	case 0:
+		/* success */
+		break;
+	case -ECONNRESET:
+	case -ENOENT:
+	case -ESHUTDOWN:
+		/* this urb is terminated, clean up */
+		dbg("%s - urb shutting down with status: %d", __FUNCTION__,
+		    status);
+		priv->write_urb_in_use = 0;
+		return;
+	default:
 		/* error in the urb, so we have to resubmit it */
 		if (serial_paranoia_check (port->serial, __FUNCTION__)) {
 			return;
 		}
 		dbg("%s - Overflow in write", __FUNCTION__);
-		dbg("%s - nonzero write bulk status received: %d", __FUNCTION__, urb->status);
+		dbg("%s - nonzero write bulk status received: %d", __FUNCTION__, status);
 		port->write_urb->transfer_buffer_length = 1;
 		port->write_urb->dev = port->serial->dev;
 		result = usb_submit_urb (port->write_urb);
 		if (result)
 			err("%s - failed resubmitting write urb, error %d", __FUNCTION__, result);
-
-		return;
+		else
+			return;
 	}
 
-	queue_task(&port->tqueue, &tq_immediate);
-	mark_bh(IMMEDIATE_BH);
+	priv->write_urb_in_use = 0;
 
-	return;
+	/* send any buffered data */
+	pl2303_send(port);
 }
 
 
@@ -894,19 +1199,17 @@
 	retval = usb_serial_register(&pl2303_device);
 	if (retval)
 		goto failed_usb_serial_register;
-	info(DRIVER_DESC " " DRIVER_VERSION);
+	info(DRIVER_DESC);
 	return 0;
 failed_usb_serial_register:
 	return retval;
 }
 
-
 static void __exit pl2303_exit (void)
 {
 	usb_serial_deregister (&pl2303_device);
 }
 
-
 module_init(pl2303_init);
 module_exit(pl2303_exit);
 


