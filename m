Return-Path: <linux-kernel-owner+w=401wt.eu-S1763787AbYFTU2E@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763787AbYFTU2E (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2008 16:28:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760673AbYFTUUK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Jun 2008 16:20:10 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:35199 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754263AbYFTUUG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2008 16:20:06 -0400
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [PATCH 35/70] empeg: Coding style
To: linux-kernel@vger.kernel.org
Date: Fri, 20 Jun 2008 21:02:41 +0100
Message-ID: <20080620200238.1479.92380.stgit@localhost.localdomain>
In-Reply-To: <20080620195406.1479.12620.stgit@localhost.localdomain>
References: <20080620195406.1479.12620.stgit@localhost.localdomain>
User-Agent: StGIT/0.14.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alan Cox <alan@redhat.com>



Signed-off-by: Alan Cox <alan@redhat.com>
---

 drivers/usb/serial/empeg.c |  203 +++++++++++++++++++++++---------------------
 1 files changed, 107 insertions(+), 96 deletions(-)


diff --git a/drivers/usb/serial/empeg.c b/drivers/usb/serial/empeg.c
index 47ebdf5..a6ab5b5 100644
--- a/drivers/usb/serial/empeg.c
+++ b/drivers/usb/serial/empeg.c
@@ -11,36 +11,39 @@
  *	it under the terms of the GNU General Public License, as published by
  *	the Free Software Foundation, version 2.
  *
- * See Documentation/usb/usb-serial.txt for more information on using this driver
- * 
+ * See Documentation/usb/usb-serial.txt for more information on using this
+ * driver
+ *
  * (07/16/2001) gb
- *	remove unused code in empeg_close() (thanks to Oliver Neukum for pointing this
- *	out) and rewrote empeg_set_termios().
- * 
+ *	remove unused code in empeg_close() (thanks to Oliver Neukum for
+ *	pointing this out) and rewrote empeg_set_termios().
+ *
  * (05/30/2001) gkh
- *	switched from using spinlock to a semaphore, which fixes lots of problems.
+ *	switched from using spinlock to a semaphore, which fixes lots of
+ * problems.
  *
  * (04/08/2001) gb
  *      Identify version on module load.
- * 
+ *
  * (01/22/2001) gb
- *	Added write_room() and chars_in_buffer() support. 
- * 
+ *	Added write_room() and chars_in_buffer() support.
+ *
  * (12/21/2000) gb
  *	Moved termio stuff inside the port->active check.
  *	Moved MOD_DEC_USE_COUNT to end of empeg_close().
- * 
+ *
  * (12/03/2000) gb
- *	Added port->port.tty->ldisc.set_termios(port->port.tty, NULL) to empeg_open()
- *	This notifies the tty driver that the termios have changed.
- * 
+ *	Added port->port.tty->ldisc.set_termios(port->port.tty, NULL) to
+ *	empeg_open(). This notifies the tty driver that the termios have
+ *	changed.
+ *
  * (11/13/2000) gb
- *	Moved tty->low_latency = 1 from empeg_read_bulk_callback() to empeg_open()
- *	(It only needs to be set once - Doh!)
- * 
+ *	Moved tty->low_latency = 1 from empeg_read_bulk_callback() to
+ *	empeg_open() (It only needs to be set once - Doh!)
+ *
  * (11/11/2000) gb
  *	Updated to work with id_table structure.
- * 
+ *
  * (11/04/2000) gb
  *	Forked this from visor.c, and hacked it up to work with an
  *	Empeg ltd. empeg-car player.  Constructive criticism welcomed.
@@ -48,7 +51,7 @@
  *	use of his code, and for his guidance, advice and patience. :)
  *	A 'Thank You' is in order for John Ripley of Empeg ltd for his
  *	advice, and patience too.
- * 
+ *
  */
 
 #include <linux/kernel.h>
@@ -60,7 +63,7 @@
 #include <linux/tty_flip.h>
 #include <linux/module.h>
 #include <linux/spinlock.h>
-#include <asm/uaccess.h>
+#include <linux/uaccess.h>
 #include <linux/usb.h>
 #include <linux/usb/serial.h>
 
@@ -77,27 +80,30 @@ static int debug;
 #define EMPEG_PRODUCT_ID		0x0001
 
 /* function prototypes for an empeg-car player */
-static int  empeg_open			(struct tty_struct *tty, struct usb_serial_port *port, struct file *filp);
-static void empeg_close			(struct tty_struct *tty, struct usb_serial_port *port, struct file *filp);
-static int  empeg_write			(struct tty_struct *tty, struct usb_serial_port *port,
-					const unsigned char *buf,
-					int count);
-static int  empeg_write_room		(struct tty_struct *tty);
-static int  empeg_chars_in_buffer	(struct tty_struct *tty);
-static void empeg_throttle		(struct tty_struct *tty);
-static void empeg_unthrottle		(struct tty_struct *tty);
-static int  empeg_startup		(struct usb_serial *serial);
-static void empeg_shutdown		(struct usb_serial *serial);
-static void empeg_set_termios		(struct tty_struct *tty, struct usb_serial_port *port, struct ktermios *old_termios);
-static void empeg_write_bulk_callback	(struct urb *urb);
-static void empeg_read_bulk_callback	(struct urb *urb);
+static int  empeg_open(struct tty_struct *tty, struct usb_serial_port *port,
+						struct file *filp);
+static void empeg_close(struct tty_struct *tty, struct usb_serial_port *port,
+						struct file *filp);
+static int  empeg_write(struct tty_struct *tty, struct usb_serial_port *port,
+						const unsigned char *buf,
+						int count);
+static int  empeg_write_room(struct tty_struct *tty);
+static int  empeg_chars_in_buffer(struct tty_struct *tty);
+static void empeg_throttle(struct tty_struct *tty);
+static void empeg_unthrottle(struct tty_struct *tty);
+static int  empeg_startup(struct usb_serial *serial);
+static void empeg_shutdown(struct usb_serial *serial);
+static void empeg_set_termios(struct tty_struct *tty,
+		struct usb_serial_port *port, struct ktermios *old_termios);
+static void empeg_write_bulk_callback(struct urb *urb);
+static void empeg_read_bulk_callback(struct urb *urb);
 
 static struct usb_device_id id_table [] = {
 	{ USB_DEVICE(EMPEG_VENDOR_ID, EMPEG_PRODUCT_ID) },
 	{ }					/* Terminating entry */
 };
 
-MODULE_DEVICE_TABLE (usb, id_table);
+MODULE_DEVICE_TABLE(usb, id_table);
 
 static struct usb_driver empeg_driver = {
 	.name =		"empeg",
@@ -149,7 +155,7 @@ static int empeg_open(struct tty_struct *tty, struct usb_serial_port *port,
 	dbg("%s - port %d", __func__, port->number);
 
 	/* Force default termio settings */
-	empeg_set_termios (tty, port, NULL) ;
+	empeg_set_termios(tty, port, NULL) ;
 
 	bytes_in = 0;
 	bytes_out = 0;
@@ -157,7 +163,7 @@ static int empeg_open(struct tty_struct *tty, struct usb_serial_port *port,
 	/* Start reading from the device */
 	usb_fill_bulk_urb(
 		port->read_urb,
-		serial->dev, 
+		serial->dev,
 		usb_rcvbulkpipe(serial->dev,
 			port->bulk_in_endpointAddress),
 		port->read_urb->transfer_buffer,
@@ -168,14 +174,16 @@ static int empeg_open(struct tty_struct *tty, struct usb_serial_port *port,
 	result = usb_submit_urb(port->read_urb, GFP_KERNEL);
 
 	if (result)
-		dev_err(&port->dev, "%s - failed submitting read urb, error %d\n", __func__, result);
+		dev_err(&port->dev,
+			"%s - failed submitting read urb, error %d\n",
+							__func__, result);
 
 	return result;
 }
 
 
 static void empeg_close(struct tty_struct *tty, struct usb_serial_port *port,
-				struct file * filp)
+				struct file *filp)
 {
 	dbg("%s - port %d", __func__, port->number);
 
@@ -186,7 +194,8 @@ static void empeg_close(struct tty_struct *tty, struct usb_serial_port *port,
 }
 
 
-static int empeg_write(struct tty_struct *tty, struct usb_serial_port *port, const unsigned char *buf, int count)
+static int empeg_write(struct tty_struct *tty, struct usb_serial_port *port,
+					const unsigned char *buf, int count)
 {
 	struct usb_serial *serial = port->serial;
 	struct urb *urb;
@@ -203,7 +212,7 @@ static int empeg_write(struct tty_struct *tty, struct usb_serial_port *port, con
 		/* try to find a free urb in our list of them */
 		urb = NULL;
 
-		spin_lock_irqsave (&write_urb_pool_lock, flags);
+		spin_lock_irqsave(&write_urb_pool_lock, flags);
 
 		for (i = 0; i < NUM_URBS; ++i) {
 			if (write_urb_pool[i]->status != -EINPROGRESS) {
@@ -212,7 +221,7 @@ static int empeg_write(struct tty_struct *tty, struct usb_serial_port *port, con
 			}
 		}
 
-		spin_unlock_irqrestore (&write_urb_pool_lock, flags);
+		spin_unlock_irqrestore(&write_urb_pool_lock, flags);
 
 		if (urb == NULL) {
 			dbg("%s - no more free urbs", __func__);
@@ -220,25 +229,27 @@ static int empeg_write(struct tty_struct *tty, struct usb_serial_port *port, con
 		}
 
 		if (urb->transfer_buffer == NULL) {
-			urb->transfer_buffer = kmalloc (URB_TRANSFER_BUFFER_SIZE, GFP_ATOMIC);
+			urb->transfer_buffer = kmalloc(URB_TRANSFER_BUFFER_SIZE, GFP_ATOMIC);
 			if (urb->transfer_buffer == NULL) {
-				dev_err(&port->dev, "%s no more kernel memory...\n", __func__);
+				dev_err(&port->dev,
+					"%s no more kernel memory...\n",
+								__func__);
 				goto exit;
 			}
 		}
 
-		transfer_size = min (count, URB_TRANSFER_BUFFER_SIZE);
+		transfer_size = min(count, URB_TRANSFER_BUFFER_SIZE);
 
-		memcpy (urb->transfer_buffer, current_position, transfer_size);
+		memcpy(urb->transfer_buffer, current_position, transfer_size);
 
 		usb_serial_debug_data(debug, &port->dev, __func__, transfer_size, urb->transfer_buffer);
 
 		/* build up our urb */
-		usb_fill_bulk_urb (
+		usb_fill_bulk_urb(
 			urb,
 			serial->dev,
 			usb_sndbulkpipe(serial->dev,
-				port->bulk_out_endpointAddress), 
+					port->bulk_out_endpointAddress),
 			urb->transfer_buffer,
 			transfer_size,
 			empeg_write_bulk_callback,
@@ -260,7 +271,7 @@ static int empeg_write(struct tty_struct *tty, struct usb_serial_port *port, con
 	}
 exit:
 	return bytes_sent;
-} 
+}
 
 
 static int empeg_write_room(struct tty_struct *tty)
@@ -272,14 +283,13 @@ static int empeg_write_room(struct tty_struct *tty)
 
 	dbg("%s - port %d", __func__, port->number);
 
-	spin_lock_irqsave (&write_urb_pool_lock, flags);
+	spin_lock_irqsave(&write_urb_pool_lock, flags);
 	/* tally up the number of bytes available */
 	for (i = 0; i < NUM_URBS; ++i) {
-		if (write_urb_pool[i]->status != -EINPROGRESS) {
+		if (write_urb_pool[i]->status != -EINPROGRESS)
 			room += URB_TRANSFER_BUFFER_SIZE;
-		}
-	} 
-	spin_unlock_irqrestore (&write_urb_pool_lock, flags);
+	}
+	spin_unlock_irqrestore(&write_urb_pool_lock, flags);
 	dbg("%s - returns %d", __func__, room);
 	return room;
 
@@ -295,25 +305,21 @@ static int empeg_chars_in_buffer(struct tty_struct *tty)
 
 	dbg("%s - port %d", __func__, port->number);
 
-	spin_lock_irqsave (&write_urb_pool_lock, flags);
+	spin_lock_irqsave(&write_urb_pool_lock, flags);
 
 	/* tally up the number of bytes waiting */
 	for (i = 0; i < NUM_URBS; ++i) {
-		if (write_urb_pool[i]->status == -EINPROGRESS) {
+		if (write_urb_pool[i]->status == -EINPROGRESS)
 			chars += URB_TRANSFER_BUFFER_SIZE;
-		}
 	}
 
-	spin_unlock_irqrestore (&write_urb_pool_lock, flags);
-
+	spin_unlock_irqrestore(&write_urb_pool_lock, flags);
 	dbg("%s - returns %d", __func__, chars);
-
-	return (chars);
-
+	return chars;
 }
 
 
-static void empeg_write_bulk_callback (struct urb *urb)
+static void empeg_write_bulk_callback(struct urb *urb)
 {
 	struct usb_serial_port *port = urb->context;
 	int status = urb->status;
@@ -330,7 +336,7 @@ static void empeg_write_bulk_callback (struct urb *urb)
 }
 
 
-static void empeg_read_bulk_callback (struct urb *urb)
+static void empeg_read_bulk_callback(struct urb *urb)
 {
 	struct usb_serial_port *port = urb->context;
 	struct tty_struct *tty;
@@ -346,8 +352,8 @@ static void empeg_read_bulk_callback (struct urb *urb)
 		return;
 	}
 
-	usb_serial_debug_data(debug, &port->dev, __func__, urb->actual_length, data);
-
+	usb_serial_debug_data(debug, &port->dev, __func__,
+						urb->actual_length, data);
 	tty = port->port.tty;
 
 	if (urb->actual_length) {
@@ -360,7 +366,7 @@ static void empeg_read_bulk_callback (struct urb *urb)
 	/* Continue trying to always read  */
 	usb_fill_bulk_urb(
 		port->read_urb,
-		port->serial->dev, 
+		port->serial->dev,
 		usb_rcvbulkpipe(port->serial->dev,
 			port->bulk_in_endpointAddress),
 		port->read_urb->transfer_buffer,
@@ -371,7 +377,9 @@ static void empeg_read_bulk_callback (struct urb *urb)
 	result = usb_submit_urb(port->read_urb, GFP_ATOMIC);
 
 	if (result)
-		dev_err(&urb->dev->dev, "%s - failed resubmitting read urb, error %d\n", __func__, result);
+		dev_err(&urb->dev->dev,
+			"%s - failed resubmitting read urb, error %d\n",
+							__func__, result);
 
 	return;
 
@@ -395,11 +403,13 @@ static void empeg_unthrottle(struct tty_struct *tty)
 	port->read_urb->dev = port->serial->dev;
 	result = usb_submit_urb(port->read_urb, GFP_ATOMIC);
 	if (result)
-		dev_err(&port->dev, "%s - failed submitting read urb, error %d\n", __func__, result);
+		dev_err(&port->dev,
+			"%s - failed submitting read urb, error %d\n",
+							__func__, result);
 }
 
 
-static int  empeg_startup (struct usb_serial *serial)
+static int  empeg_startup(struct usb_serial *serial)
 {
 	int r;
 
@@ -411,7 +421,7 @@ static int  empeg_startup (struct usb_serial *serial)
 		return -ENODEV;
 	}
 	dbg("%s - reset config", __func__);
-	r = usb_reset_configuration (serial->dev);
+	r = usb_reset_configuration(serial->dev);
 
 	/* continue on with initialization */
 	return r;
@@ -419,9 +429,9 @@ static int  empeg_startup (struct usb_serial *serial)
 }
 
 
-static void empeg_shutdown (struct usb_serial *serial)
+static void empeg_shutdown(struct usb_serial *serial)
 {
-	dbg ("%s", __func__);
+	dbg("%s", __func__);
 }
 
 
@@ -432,14 +442,14 @@ static void empeg_set_termios(struct tty_struct *tty,
 	dbg("%s - port %d", __func__, port->number);
 
 	/*
-         * The empeg-car player wants these particular tty settings.
-         * You could, for example, change the baud rate, however the
-         * player only supports 115200 (currently), so there is really
-         * no point in support for changes to the tty settings.
-         * (at least for now)
-         *
-         * The default requirements for this device are:
-         */
+	 * The empeg-car player wants these particular tty settings.
+	 * You could, for example, change the baud rate, however the
+	 * player only supports 115200 (currently), so there is really
+	 * no point in support for changes to the tty settings.
+	 * (at least for now)
+	 *
+	 * The default requirements for this device are:
+	 */
 	termios->c_iflag
 		&= ~(IGNBRK	/* disable ignore break */
 		| BRKINT	/* disable break causes interrupt */
@@ -478,13 +488,13 @@ static void empeg_set_termios(struct tty_struct *tty,
 }
 
 
-static int __init empeg_init (void)
+static int __init empeg_init(void)
 {
 	struct urb *urb;
 	int i, retval;
 
-	/* create our write urb pool and transfer buffers */ 
-	spin_lock_init (&write_urb_pool_lock);
+	/* create our write urb pool and transfer buffers */
+	spin_lock_init(&write_urb_pool_lock);
 	for (i = 0; i < NUM_URBS; ++i) {
 		urb = usb_alloc_urb(0, GFP_KERNEL);
 		write_urb_pool[i] = urb;
@@ -493,9 +503,10 @@ static int __init empeg_init (void)
 			continue;
 		}
 
-		urb->transfer_buffer = kmalloc (URB_TRANSFER_BUFFER_SIZE, GFP_KERNEL);
+		urb->transfer_buffer = kmalloc(URB_TRANSFER_BUFFER_SIZE,
+								GFP_KERNEL);
 		if (!urb->transfer_buffer) {
-			err("%s - out of memory for urb buffers.", 
+			err("%s - out of memory for urb buffers.",
 			    __func__);
 			continue;
 		}
@@ -524,36 +535,36 @@ failed_usb_serial_register:
 }
 
 
-static void __exit empeg_exit (void)
+static void __exit empeg_exit(void)
 {
 	int i;
 	unsigned long flags;
 
 	usb_deregister(&empeg_driver);
-	usb_serial_deregister (&empeg_device);
+	usb_serial_deregister(&empeg_device);
 
-	spin_lock_irqsave (&write_urb_pool_lock, flags);
+	spin_lock_irqsave(&write_urb_pool_lock, flags);
 
 	for (i = 0; i < NUM_URBS; ++i) {
 		if (write_urb_pool[i]) {
-			/* FIXME - uncomment the following usb_kill_urb call when
-			 * the host controllers get fixed to set urb->dev = NULL after
-			 * the urb is finished.  Otherwise this call oopses. */
+			/* FIXME - uncomment the following usb_kill_urb call
+			 * when the host controllers get fixed to set urb->dev
+			 * = NULL after the urb is finished.  Otherwise this
+			 * call oopses. */
 			/* usb_kill_urb(write_urb_pool[i]); */
 			kfree(write_urb_pool[i]->transfer_buffer);
-			usb_free_urb (write_urb_pool[i]);
+			usb_free_urb(write_urb_pool[i]);
 		}
 	}
-
-	spin_unlock_irqrestore (&write_urb_pool_lock, flags);
+	spin_unlock_irqrestore(&write_urb_pool_lock, flags);
 }
 
 
 module_init(empeg_init);
 module_exit(empeg_exit);
 
-MODULE_AUTHOR( DRIVER_AUTHOR );
-MODULE_DESCRIPTION( DRIVER_DESC );
+MODULE_AUTHOR(DRIVER_AUTHOR);
+MODULE_DESCRIPTION(DRIVER_DESC);
 MODULE_LICENSE("GPL");
 
 module_param(debug, bool, S_IRUGO | S_IWUSR);

