Return-Path: <linux-kernel-owner+w=401wt.eu-S932764AbZHNUCw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932764AbZHNUCw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Aug 2009 16:02:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932746AbZHNUCw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Aug 2009 16:02:52 -0400
Received: from sj-iport-1.cisco.com ([171.71.176.70]:45889 "EHLO
	sj-iport-1.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932237AbZHNUCu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Aug 2009 16:02:50 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApoEAFtfhUqrR7PE/2dsb2JhbAC6TYgtkQcFhBk
X-IronPort-AV: E=Sophos;i="4.43,381,1246838400"; 
   d="scan'208";a="228186480"
Date: Fri, 14 Aug 2009 13:02:51 -0700
From: David VomLehn <dvomlehn@cisco.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, greg@kroah.com, linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] Use kfifo to buffer USB generic serial writes
Message-ID: <20090814200251.GA26258@cuplxvomd02.corp.sa.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Authentication-Results: sj-dkim-4; header.From=dvomlehn@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim4002 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When do_output_char() attempts to write a carriage return/line feed sequence,
it first checks to see how much buffer room is available. If there are at least
two characters free, it will write the carriage return/line feed with two calls
to tty_put_char(). It calls the tty_operation functions write() for devices that
don't support the tty_operations function put_char(). If the USB generic serial
device's write URB is not in use, it will return the buffer size when asked how
much room is available. The write() of the carriage return will cause it to mark
the write URB busy, so the subsequent write() of the line feed will be ignored.

The first part of patch uses the kfifo infrastructure to implement a write
FIFO that accurately returns the amount of space available in the buffer. The
second makes a minor change to kfifo_put() and __kfifo_put() to add the "const"
attribute to their input buffer pointers.

Signed-off-by: David VomLehn
---
 drivers/usb/serial/generic.c    |  147 +++++++++++++++++++++++---------------
 drivers/usb/serial/usb-serial.c |    8 ++
 include/linux/kfifo.h           |    5 +-
 include/linux/usb/serial.h      |    2 +
 kernel/kfifo.c                  |    2 +-
 5 files changed, 103 insertions(+), 61 deletions(-)

diff --git a/drivers/usb/serial/generic.c b/drivers/usb/serial/generic.c
index ce57f6a..fa1b5b2 100644
--- a/drivers/usb/serial/generic.c
+++ b/drivers/usb/serial/generic.c
@@ -19,7 +19,7 @@
 #include <linux/usb.h>
 #include <linux/usb/serial.h>
 #include <linux/uaccess.h>
-
+#include <linux/kfifo.h>
 
 static int debug;
 
@@ -273,12 +273,81 @@ error_no_buffer:
 	return bwrite;
 }
 
+/**
+ * usb_serial_generic_write_start - kick off an URB write
+ * @port:	Pointer to the &struct usb_serial_port data
+ * @status:	Value to return on success.
+ *
+ * Returns status on success, otherwise a negative errno value
+ */
+static int usb_serial_generic_write_start(struct usb_serial_port *port,
+	int status)
+{
+	struct usb_serial *serial = port->serial;
+	unsigned char *data;
+	int result;
+	int count;
+	unsigned long flags;
+	bool start_io;
+
+	/* Atomically determine whether we can and need to start a USB
+	 * operation. */
+	spin_lock_irqsave(&port->write_fifo_lock, flags);
+	if (port->write_urb_busy)
+		start_io = false;
+	else {
+		start_io = (__kfifo_len(port->write_fifo) != 0);
+		port->write_urb_busy = start_io;
+	}
+	spin_unlock_irqrestore(&port->write_fifo_lock, flags);
+
+	if (!start_io)
+		return status;
+
+	data = port->write_urb->transfer_buffer;
+	count = kfifo_get(port->write_fifo, data, port->bulk_out_size);
+	usb_serial_debug_data(debug, &port->dev, __func__, count, data);
+
+	/* set up our urb */
+	usb_fill_bulk_urb(port->write_urb, serial->dev,
+			   usb_sndbulkpipe(serial->dev,
+				port->bulk_out_endpointAddress),
+			   port->write_urb->transfer_buffer, count,
+			   ((serial->type->write_bulk_callback) ?
+			     serial->type->write_bulk_callback :
+			     usb_serial_generic_write_bulk_callback),
+			   port);
+
+	/* send the data out the bulk port */
+	result = usb_submit_urb(port->write_urb, GFP_ATOMIC);
+	if (result) {
+		dev_err(&port->dev,
+			"%s - failed submitting write urb, error %d\n",
+						__func__, result);
+		/* don't have to grab the lock here, as we will
+		   retry if != 0 */
+		port->write_urb_busy = 0;
+		status = result;
+	}
+
+	return status;
+}
+
+/**
+ * usb_serial_generic_write - generic write function for serial USB devices
+ * @tty:	Pointer to &struct tty_struct for the device
+ * @port:	Pointer to the &usb_serial_port structure for the device
+ * @buf:	Pointer to the data to write
+ * @count:	Number of bytes to write
+ *
+ * Returns the number of characters actually written, which may be anything
+ * from zero to @count. If an error occurs, it returns the negative errno
+ * value.
+ */
 int usb_serial_generic_write(struct tty_struct *tty,
 	struct usb_serial_port *port, const unsigned char *buf, int count)
 {
 	struct usb_serial *serial = port->serial;
-	int result;
-	unsigned char *data;
 
 	dbg("%s - port %d", __func__, port->number);
 
@@ -288,57 +357,20 @@ int usb_serial_generic_write(struct tty_struct *tty,
 	}
 
 	/* only do something if we have a bulk out endpoint */
-	if (serial->num_bulk_out) {
-		unsigned long flags;
-
-		if (serial->type->max_in_flight_urbs)
-			return usb_serial_multi_urb_write(tty, port,
-							  buf, count);
-
-		spin_lock_irqsave(&port->lock, flags);
-		if (port->write_urb_busy) {
-			spin_unlock_irqrestore(&port->lock, flags);
-			dbg("%s - already writing", __func__);
-			return 0;
-		}
-		port->write_urb_busy = 1;
-		spin_unlock_irqrestore(&port->lock, flags);
-
-		count = (count > port->bulk_out_size) ?
-					port->bulk_out_size : count;
-
-		memcpy(port->write_urb->transfer_buffer, buf, count);
-		data = port->write_urb->transfer_buffer;
-		usb_serial_debug_data(debug, &port->dev, __func__, count, data);
-
-		/* set up our urb */
-		usb_fill_bulk_urb(port->write_urb, serial->dev,
-				   usb_sndbulkpipe(serial->dev,
-					port->bulk_out_endpointAddress),
-				   port->write_urb->transfer_buffer, count,
-				   ((serial->type->write_bulk_callback) ?
-				     serial->type->write_bulk_callback :
-				     usb_serial_generic_write_bulk_callback),
-				   port);
+	if (!serial->num_bulk_out)
+		return 0;
 
-		/* send the data out the bulk port */
-		port->write_urb_busy = 1;
-		result = usb_submit_urb(port->write_urb, GFP_ATOMIC);
-		if (result) {
-			dev_err(&port->dev,
-				"%s - failed submitting write urb, error %d\n",
-							__func__, result);
-			/* don't have to grab the lock here, as we will
-			   retry if != 0 */
-			port->write_urb_busy = 0;
-		} else
-			result = count;
+	if (serial->type->max_in_flight_urbs)
+		return usb_serial_multi_urb_write(tty, port,
+						  buf, count);
 
-		return result;
-	}
+	/* TODO: Much of the time there won't be a write pending and won't be
+	 * any data ahead of the current chunk. In those cases, we could save
+	 * a copy by putting the data directly into the URB transfer buffer.
+	 * This adds some complexity, is it worth it for serial I/O? */
+	count = kfifo_put(port->write_fifo, buf, count);
 
-	/* no bulk out, so return 0 bytes written */
-	return 0;
+	return usb_serial_generic_write_start(port, count);
 }
 EXPORT_SYMBOL_GPL(usb_serial_generic_write);
 
@@ -356,9 +388,8 @@ int usb_serial_generic_write_room(struct tty_struct *tty)
 			room = port->bulk_out_size *
 				(serial->type->max_in_flight_urbs -
 				 port->urbs_in_flight);
-	} else if (serial->num_bulk_out && !(port->write_urb_busy)) {
-		room = port->bulk_out_size;
-	}
+	} else if (serial->num_bulk_out)
+		room = port->write_fifo->size - __kfifo_len(port->write_fifo);
 	spin_unlock_irqrestore(&port->lock, flags);
 
 	dbg("%s - returns %d", __func__, room);
@@ -379,9 +410,9 @@ int usb_serial_generic_chars_in_buffer(struct tty_struct *tty)
 		chars = port->tx_bytes_flight;
 		spin_unlock_irqrestore(&port->lock, flags);
 	} else if (serial->num_bulk_out) {
-		/* FIXME: Locking */
-		if (port->write_urb_busy)
-			chars = port->write_urb->transfer_buffer_length;
+		spin_lock_irqsave(&port->write_fifo_lock, flags);
+		chars = __kfifo_len(port->write_fifo);
+		spin_unlock_irqrestore(&port->write_fifo_lock, flags);
 	}
 
 	dbg("%s - returns %d", __func__, chars);
@@ -487,8 +518,8 @@ void usb_serial_generic_write_bulk_callback(struct urb *urb)
 			port->urbs_in_flight = 0;
 		spin_unlock_irqrestore(&port->lock, flags);
 	} else {
-		/* Handle the case for single urb mode */
 		port->write_urb_busy = 0;
+		usb_serial_generic_write_start(port, 0);
 	}
 
 	if (status) {
diff --git a/drivers/usb/serial/usb-serial.c b/drivers/usb/serial/usb-serial.c
index 99188c9..e545423 100644
--- a/drivers/usb/serial/usb-serial.c
+++ b/drivers/usb/serial/usb-serial.c
@@ -35,6 +35,7 @@
 #include <linux/serial.h>
 #include <linux/usb.h>
 #include <linux/usb/serial.h>
+#include <linux/kfifo.h>
 #include "pl2303.h"
 
 /*
@@ -970,6 +971,11 @@ int usb_serial_probe(struct usb_interface *interface,
 			dev_err(&interface->dev, "No free urbs available\n");
 			goto probe_error;
 		}
+		port->write_fifo = kfifo_alloc(PAGE_SIZE, GFP_KERNEL,
+			&port->write_fifo_lock);
+		if (!port->write_fifo)
+			goto probe_error;
+		spin_lock_init(&port->write_fifo_lock);
 		buffer_size = le16_to_cpu(endpoint->wMaxPacketSize);
 		port->bulk_out_size = buffer_size;
 		port->bulk_out_endpointAddress = endpoint->bEndpointAddress;
@@ -1114,6 +1120,8 @@ probe_error:
 		port = serial->port[i];
 		if (!port)
 			continue;
+		if (port->write_fifo)
+			kfifo_free(port->write_fifo);
 		usb_free_urb(port->write_urb);
 		kfree(port->bulk_out_buffer);
 	}
diff --git a/include/linux/usb/serial.h b/include/linux/usb/serial.h
index 0ec50ba..9474c4e 100644
--- a/include/linux/usb/serial.h
+++ b/include/linux/usb/serial.h
@@ -96,6 +96,8 @@ struct usb_serial_port {
 	unsigned char		*bulk_out_buffer;
 	int			bulk_out_size;
 	struct urb		*write_urb;
+	struct kfifo		*write_fifo;
+	spinlock_t		write_fifo_lock;
 	int			write_urb_busy;
 	__u8			bulk_out_endpointAddress;
 
