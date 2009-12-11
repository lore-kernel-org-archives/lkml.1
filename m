Return-Path: <linux-kernel-owner+w=401wt.eu-S934961AbZLKXlB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934961AbZLKXlB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Dec 2009 18:41:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933806AbZLKXgu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Dec 2009 18:36:50 -0500
Received: from kroah.org ([198.145.64.141]:50457 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933817AbZLKX27 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Dec 2009 18:28:59 -0500
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Alan Cox <alan@linux.intel.com>, Alan Stern <stern@rowland.harvard.edu>,
       Oliver Neukum <oliver@neukum.org>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 15/58] usb_serial: Use the shutdown() operation
Date: Fri, 11 Dec 2009 15:27:59 -0800
Message-Id: <1260574122-10676-15-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.6.5.3
In-Reply-To: <20091211232805.GA10652@kroah.com>
References: <20091211232805.GA10652@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alan Cox <alan@linux.intel.com>

As Alan Stern pointed out - now we have tty_port_open the shutdown method
and locking allow us to whack the other bits into the full helper methods
and provide a shutdown op which the tty port code will synchronize with
setup for us.

Signed-off-by: Alan Cox <alan@linux.intel.com>
Cc: Alan Stern <stern@rowland.harvard.edu>
Cc: Oliver Neukum <oliver@neukum.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/usb/serial/usb-serial.c |   39 +++++++++++----------------------------
 1 files changed, 11 insertions(+), 28 deletions(-)

diff --git a/drivers/usb/serial/usb-serial.c b/drivers/usb/serial/usb-serial.c
index b0649d9..829a466 100644
--- a/drivers/usb/serial/usb-serial.c
+++ b/drivers/usb/serial/usb-serial.c
@@ -254,15 +254,12 @@ static int serial_activate(struct tty_port *tport, struct tty_struct *tty)
 	struct usb_serial *serial = port->serial;
 	int retval;
 
-	if (mutex_lock_interruptible(&port->mutex))
-		return -ERESTARTSYS;
 	mutex_lock(&serial->disc_mutex);
 	if (serial->disconnected)
 		retval = -ENODEV;
 	else
 		retval = port->serial->type->open(tty, port);
 	mutex_unlock(&serial->disc_mutex);
-	mutex_unlock(&port->mutex);
 	return retval;
 }
 
@@ -276,57 +273,40 @@ static int serial_open(struct tty_struct *tty, struct file *filp)
 
 /**
  * serial_down - shut down hardware
- * @port: port to shut down
+ * @tport: tty port to shut down
  *
  * Shut down a USB serial port unless it is the console.  We never
- * shut down the console hardware as it will always be in use.
+ * shut down the console hardware as it will always be in use. Serialized
+ * against activate by the tport mutex and kept to matching open/close pairs
+ * of calls by the ASYNCB_INITIALIZED flag.
  */
-static void serial_down(struct usb_serial_port *port)
+static void serial_down(struct tty_port *tport)
 {
+	struct usb_serial_port *port =
+		container_of(tport, struct usb_serial_port, port);
 	struct usb_serial_driver *drv = port->serial->type;
-
 	/*
 	 * The console is magical.  Do not hang up the console hardware
 	 * or there will be tears.
 	 */
 	if (port->console)
 		return;
-
-	/* Don't call the close method if the hardware hasn't been
-	 * initialized.
-	 */
-	if (!test_and_clear_bit(ASYNCB_INITIALIZED, &port->port.flags))
-		return;
-
-	mutex_lock(&port->mutex);
 	if (drv->close)
 		drv->close(port);
-	mutex_unlock(&port->mutex);
 }
 
 static void serial_hangup(struct tty_struct *tty)
 {
 	struct usb_serial_port *port = tty->driver_data;
-
 	dbg("%s - port %d", __func__, port->number);
-
-	serial_down(port);
 	tty_port_hangup(&port->port);
 }
 
 static void serial_close(struct tty_struct *tty, struct file *filp)
 {
 	struct usb_serial_port *port = tty->driver_data;
-
 	dbg("%s - port %d", __func__, port->number);
-
-	if (tty_hung_up_p(filp))
-		return;
-	if (tty_port_close_start(&port->port, tty, filp) == 0)
-		return;
-	serial_down(port);
-	tty_port_close_end(&port->port, tty);
-	tty_port_tty_set(&port->port, NULL);
+	tty_port_close(&port->port, tty, filp);
 }
 
 /**
@@ -716,6 +696,7 @@ static const struct tty_port_operations serial_port_ops = {
 	.carrier_raised = serial_carrier_raised,
 	.dtr_rts = serial_dtr_rts,
 	.activate = serial_activate,
+	.shutdown = serial_down,
 };
 
 int usb_serial_probe(struct usb_interface *interface,
@@ -914,6 +895,8 @@ int usb_serial_probe(struct usb_interface *interface,
 		port->port.ops = &serial_port_ops;
 		port->serial = serial;
 		spin_lock_init(&port->lock);
+		/* Keep this for private driver use for the moment but
+		   should probably go away */
 		mutex_init(&port->mutex);
 		INIT_WORK(&port->work, usb_serial_port_work);
 		serial->port[i] = port;
-- 
1.6.5.5

