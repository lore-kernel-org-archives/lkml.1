Return-Path: <linux-kernel-owner+w=401wt.eu-S1759424AbZEKUZu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759424AbZEKUZu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 May 2009 16:25:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758778AbZEKUZK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 May 2009 16:25:10 -0400
Received: from mail.windriver.com ([147.11.1.11]:52581 "EHLO mail.wrs.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753601AbZEKUZH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 May 2009 16:25:07 -0400
From: Jason Wessel <jason.wessel@windriver.com>
To: greg@kroah.com
Cc: stern@rowland.harvard.edu, linux-usb@vger.kernel.org,
       linux-kernel@vger.kernel.org, Jason Wessel <jason.wessel@windriver.com>
Subject: [PATCH 1/4] usb_debug, usb_generic_serial: implement multi urb write
Date: Mon, 11 May 2009 15:24:07 -0500
Message-Id: <1242073450-3794-2-git-send-email-jason.wessel@windriver.com>
X-Mailer: git-send-email 1.6.3.rc0.1.gf800
In-Reply-To: <1242073450-3794-1-git-send-email-jason.wessel@windriver.com>
References: <1242073450-3794-1-git-send-email-jason.wessel@windriver.com>
X-OriginalArrivalTime: 11 May 2009 20:25:05.0934 (UTC) FILETIME=[924E2AE0:01C9D276]
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

The generic usb serial driver was modified so as to allow the classic
method of 1 write urb, or a multi write urb scheme with N allowed
outstanding urbs where N is controlled by max_in_flight_urbs.  When
max_in_flight_urbs in a "struct usb_serial_driver" is non zero the
multi write urb scheme will be used.

The size of 4000 was selected for the usb_debug driver so that the
driver lowers possibility of losing the queued console messages during
the kernel startup.

Signed-off-by: Jason Wessel <jason.wessel@windriver.com>
---
 drivers/usb/serial/generic.c   |  121 +++++++++++++++++++++++++++++++++++++--
 drivers/usb/serial/usb_debug.c |    2 +
 include/linux/usb/serial.h     |    4 +
 3 files changed, 120 insertions(+), 7 deletions(-)

diff --git a/drivers/usb/serial/generic.c b/drivers/usb/serial/generic.c
index 4cec990..6a1b45d 100644
--- a/drivers/usb/serial/generic.c
+++ b/drivers/usb/serial/generic.c
@@ -191,6 +191,88 @@ void usb_serial_generic_close(struct tty_struct *tty,
 	generic_cleanup(port);
 }
 
+static int usb_serial_multi_urb_write(struct tty_struct *tty,
+	struct usb_serial_port *port, const unsigned char *buf, int count)
+{
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
+		towrite = (count > port->bulk_out_size) ?
+			port->bulk_out_size : count;
+		spin_lock_irqsave(&port->lock, flags);
+		if (port->urbs_in_flight >
+		    port->serial->type->max_in_flight_urbs) {
+			spin_unlock_irqrestore(&port->lock, flags);
+			dbg("%s - write limit hit\n", __func__);
+			return bwrite;
+		}
+		port->tx_bytes_flight += towrite;
+		port->urbs_in_flight++;
+		spin_unlock_irqrestore(&port->lock, flags);
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
+			usb_serial_generic_write_bulk_callback, port);
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
+	spin_lock_irqsave(&port->lock, flags);
+	port->urbs_in_flight--;
+	port->tx_bytes_flight -= towrite;
+	spin_unlock_irqrestore(&port->lock, flags);
+	return bwrite;
+}
+
 int usb_serial_generic_write(struct tty_struct *tty,
 	struct usb_serial_port *port, const unsigned char *buf, int count)
 {
@@ -208,6 +290,11 @@ int usb_serial_generic_write(struct tty_struct *tty,
 	/* only do something if we have a bulk out endpoint */
 	if (serial->num_bulk_out) {
 		unsigned long flags;
+
+		if (serial->type->max_in_flight_urbs)
+			return usb_serial_multi_urb_write(tty, port,
+							  buf, count);
+
 		spin_lock_irqsave(&port->lock, flags);
 		if (port->write_urb_busy) {
 			spin_unlock_irqrestore(&port->lock, flags);
@@ -258,15 +345,18 @@ int usb_serial_generic_write_room(struct tty_struct *tty)
 {
 	struct usb_serial_port *port = tty->driver_data;
 	struct usb_serial *serial = port->serial;
+	unsigned long flags;
 	int room = 0;
 
 	dbg("%s - port %d", __func__, port->number);
-
-	/* FIXME: Locking */
-	if (serial->num_bulk_out) {
-		if (!(port->write_urb_busy))
+	spin_lock_irqsave(&port->lock, flags);
+	if (serial->type->max_in_flight_urbs) {
+		if (port->urbs_in_flight < serial->type->max_in_flight_urbs)
 			room = port->bulk_out_size;
+	} else if (serial->num_bulk_out && !(port->write_urb_busy)) {
+		room = port->bulk_out_size;
 	}
+	spin_unlock_irqrestore(&port->lock, flags);
 
 	dbg("%s - returns %d", __func__, room);
 	return room;
@@ -277,11 +367,16 @@ int usb_serial_generic_chars_in_buffer(struct tty_struct *tty)
 	struct usb_serial_port *port = tty->driver_data;
 	struct usb_serial *serial = port->serial;
 	int chars = 0;
+	unsigned long flags;
 
 	dbg("%s - port %d", __func__, port->number);
 
-	/* FIXME: Locking */
-	if (serial->num_bulk_out) {
+	if (serial->type->max_in_flight_urbs) {
+		spin_lock_irqsave(&port->lock, flags);
+		chars = port->tx_bytes_flight;
+		spin_unlock_irqrestore(&port->lock, flags);
+	} else if (serial->num_bulk_out) {
+		/* FIXME: Locking */
 		if (port->write_urb_busy)
 			chars = port->write_urb->transfer_buffer_length;
 	}
@@ -364,12 +459,24 @@ EXPORT_SYMBOL_GPL(usb_serial_generic_read_bulk_callback);
 
 void usb_serial_generic_write_bulk_callback(struct urb *urb)
 {
+	unsigned long flags;
 	struct usb_serial_port *port = urb->context;
 	int status = urb->status;
 
 	dbg("%s - port %d", __func__, port->number);
 
-	port->write_urb_busy = 0;
+	if (port->serial->type->max_in_flight_urbs) {
+		spin_lock_irqsave(&port->lock, flags);
+		--port->urbs_in_flight;
+		port->tx_bytes_flight -= urb->transfer_buffer_length;
+		if (port->urbs_in_flight < 0)
+			port->urbs_in_flight = 0;
+		spin_unlock_irqrestore(&port->lock, flags);
+	} else {
+		/* Handle the case for single urb mode */
+		port->write_urb_busy = 0;
+	}
+
 	if (status) {
 		dbg("%s - nonzero write bulk status received: %d",
 		    __func__, status);
diff --git a/drivers/usb/serial/usb_debug.c b/drivers/usb/serial/usb_debug.c
index 6c9cbb5..157a6e2 100644
--- a/drivers/usb/serial/usb_debug.c
+++ b/drivers/usb/serial/usb_debug.c
@@ -15,6 +15,7 @@
 #include <linux/usb.h>
 #include <linux/usb/serial.h>
 
+#define URB_DEBUG_MAX_IN_FLIGHT_URBS	4000
 #define USB_DEBUG_MAX_PACKET_SIZE	8
 
 static struct usb_device_id id_table [] = {
@@ -46,6 +47,7 @@ static struct usb_serial_driver debug_device = {
 	.id_table =		id_table,
 	.num_ports =		1,
 	.open =			usb_debug_open,
+	.max_in_flight_urbs = URB_DEBUG_MAX_IN_FLIGHT_URBS,
 };
 
 static int __init debug_init(void)
diff --git a/include/linux/usb/serial.h b/include/linux/usb/serial.h
index 625e9e4..5cacba1 100644
--- a/include/linux/usb/serial.h
+++ b/include/linux/usb/serial.h
@@ -91,6 +91,9 @@ struct usb_serial_port {
 	int			write_urb_busy;
 	__u8			bulk_out_endpointAddress;
 
+	int			tx_bytes_flight;
+	int			urbs_in_flight;
+
 	wait_queue_head_t	write_wait;
 	struct work_struct	work;
 	char			throttled;
@@ -207,6 +210,7 @@ struct usb_serial_driver {
 	struct device_driver	driver;
 	struct usb_driver	*usb_driver;
 	struct usb_dynids	dynids;
+	int			max_in_flight_urbs;
 
 	int (*probe)(struct usb_serial *serial, const struct usb_device_id *id);
 	int (*attach)(struct usb_serial *serial);
-- 
1.6.3.rc0.1.gf800

