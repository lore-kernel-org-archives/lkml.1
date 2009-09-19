Return-Path: <linux-kernel-owner+w=401wt.eu-S1755118AbZISVoq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755118AbZISVoq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Sep 2009 17:44:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755081AbZISVop
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Sep 2009 17:44:45 -0400
Received: from kroah.org ([198.145.64.141]:40570 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755079AbZISVom (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Sep 2009 17:44:42 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Alan Stern <stern@rowland.harvard.edu>, stable <stable@kernel.org>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 71/79] usb-serial: change referencing of port and serial structures
Date: Sat, 19 Sep 2009 14:37:16 -0700
Message-Id: <1253396244-7885-71-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.6.4.2
In-Reply-To: <20090919213345.GB7668@kroah.com>
References: <20090919213345.GB7668@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alan Stern <stern@rowland.harvard.edu>

This patch (as1284) changes the referencing of the usb_serial and
usb_serial_port structures in usb-serial.c.  It's not feasible to make
the port structures keep a reference to the serial structure, because
the ports need to remain in existence when serial is released -- quite
a few of the drivers expect this.  Consequently taking a reference
to the port when the device file is open is insufficient; such a
reference would not pin serial.

To fix this, we now take a reference to serial when the device file is
opened.  The final put_device() for the ports occurs in
destroy_serial(), so that the ports will last as long as they are
needed.

The patch initializes all the port devices, including those in the
unused "fake" ports.  This makes the code more uniform because they
can all be released in the same way.  The error handling code in
usb_serial_probe() is much simplified by this approach; instead of
freeing everything by hand we can use a single usb_serial_put() call.

Also simplified is the port-release mechanism.  Instead of being two
separate routines, port_release() and port_free() can be combined into
one.

Signed-off-by: Alan Stern <stern@rowland.harvard.edu>
Cc: stable <stable@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/usb/serial/usb-serial.c |   95 ++++++++------------------------------
 1 files changed, 20 insertions(+), 75 deletions(-)

diff --git a/drivers/usb/serial/usb-serial.c b/drivers/usb/serial/usb-serial.c
index 80c1f4d..f1a1f0f 100644
--- a/drivers/usb/serial/usb-serial.c
+++ b/drivers/usb/serial/usb-serial.c
@@ -43,8 +43,6 @@
 #define DRIVER_AUTHOR "Greg Kroah-Hartman, greg@kroah.com, http://www.kroah.com/linux/"
 #define DRIVER_DESC "USB Serial Driver core"
 
-static void port_free(struct usb_serial_port *port);
-
 /* Driver structure we register with the USB core */
 static struct usb_driver usb_serial_driver = {
 	.name =		"usbserial",
@@ -145,27 +143,16 @@ static void destroy_serial(struct kref *kref)
 
 	serial->type->release(serial);
 
-	for (i = 0; i < serial->num_ports; ++i) {
+	/* Now that nothing is using the ports, they can be freed */
+	for (i = 0; i < serial->num_port_pointers; ++i) {
 		port = serial->port[i];
-		if (port)
+		if (port) {
+			port->serial = NULL;
 			put_device(&port->dev);
-	}
-
-	/* If this is a "fake" port, we have to clean it up here, as it will
-	 * not get cleaned up in port_release() as it was never registered with
-	 * the driver core */
-	if (serial->num_ports < serial->num_port_pointers) {
-		for (i = serial->num_ports;
-					i < serial->num_port_pointers; ++i) {
-			port = serial->port[i];
-			if (port)
-				port_free(port);
 		}
 	}
 
 	usb_put_dev(serial->dev);
-
-	/* free up any memory that we allocated */
 	kfree(serial);
 }
 
@@ -201,8 +188,6 @@ static int serial_open (struct tty_struct *tty, struct file *filp)
 	port = serial->port[portNumber];
 	if (!port || serial->disconnected)
 		retval = -ENODEV;
-	else
-		get_device(&port->dev);
 	/*
 	 * Note: Our locking order requirement does not allow port->mutex
 	 * to be acquired while serial->disc_mutex is held.
@@ -213,7 +198,7 @@ static int serial_open (struct tty_struct *tty, struct file *filp)
 
 	if (mutex_lock_interruptible(&port->mutex)) {
 		retval = -ERESTARTSYS;
-		goto bailout_port_put;
+		goto bailout_serial_put;
 	}
 
 	++port->port.count;
@@ -273,8 +258,6 @@ bailout_mutex_unlock:
 	tty->driver_data = NULL;
 	tty_port_tty_set(&port->port, NULL);
 	mutex_unlock(&port->mutex);
-bailout_port_put:
-	put_device(&port->dev);
 bailout_serial_put:
 	usb_serial_put(serial);
 	return retval;
@@ -333,14 +316,13 @@ static void serial_do_free(struct tty_struct *tty)
 
 	serial = port->serial;
 	owner = serial->type->driver.owner;
-	put_device(&port->dev);
-	/* Mustn't dereference port any more */
+
 	mutex_lock(&serial->disc_mutex);
 	if (!serial->disconnected)
 		usb_autopm_put_interface(serial->interface);
 	mutex_unlock(&serial->disc_mutex);
+
 	usb_serial_put(serial);
-	/* Mustn't dereference serial any more */
 	module_put(owner);
 }
 
@@ -581,14 +563,6 @@ static void usb_serial_port_work(struct work_struct *work)
 	tty_kref_put(tty);
 }
 
-static void port_release(struct device *dev)
-{
-	struct usb_serial_port *port = to_usb_serial_port(dev);
-
-	dbg ("%s - %s", __func__, dev_name(dev));
-	port_free(port);
-}
-
 static void kill_traffic(struct usb_serial_port *port)
 {
 	usb_kill_urb(port->read_urb);
@@ -608,8 +582,12 @@ static void kill_traffic(struct usb_serial_port *port)
 	usb_kill_urb(port->interrupt_out_urb);
 }
 
-static void port_free(struct usb_serial_port *port)
+static void port_release(struct device *dev)
 {
+	struct usb_serial_port *port = to_usb_serial_port(dev);
+
+	dbg ("%s - %s", __func__, dev_name(dev));
+
 	/*
 	 * Stop all the traffic before cancelling the work, so that
 	 * nobody will restart it by calling usb_serial_port_softint.
@@ -955,6 +933,11 @@ int usb_serial_probe(struct usb_interface *interface,
 		mutex_init(&port->mutex);
 		INIT_WORK(&port->work, usb_serial_port_work);
 		serial->port[i] = port;
+		port->dev.parent = &interface->dev;
+		port->dev.driver = NULL;
+		port->dev.bus = &usb_serial_bus_type;
+		port->dev.release = &port_release;
+		device_initialize(&port->dev);
 	}
 
 	/* set up the endpoint information */
@@ -1097,15 +1080,10 @@ int usb_serial_probe(struct usb_interface *interface,
 	/* register all of the individual ports with the driver core */
 	for (i = 0; i < num_ports; ++i) {
 		port = serial->port[i];
-		port->dev.parent = &interface->dev;
-		port->dev.driver = NULL;
-		port->dev.bus = &usb_serial_bus_type;
-		port->dev.release = &port_release;
-
 		dev_set_name(&port->dev, "ttyUSB%d", port->number);
 		dbg ("%s - registering %s", __func__, dev_name(&port->dev));
 		port->dev_state = PORT_REGISTERING;
-		retval = device_register(&port->dev);
+		retval = device_add(&port->dev);
 		if (retval) {
 			dev_err(&port->dev, "Error registering port device, "
 				"continuing\n");
@@ -1123,39 +1101,7 @@ exit:
 	return 0;
 
 probe_error:
-	for (i = 0; i < num_bulk_in; ++i) {
-		port = serial->port[i];
-		if (!port)
-			continue;
-		usb_free_urb(port->read_urb);
-		kfree(port->bulk_in_buffer);
-	}
-	for (i = 0; i < num_bulk_out; ++i) {
-		port = serial->port[i];
-		if (!port)
-			continue;
-		usb_free_urb(port->write_urb);
-		kfree(port->bulk_out_buffer);
-	}
-	for (i = 0; i < num_interrupt_in; ++i) {
-		port = serial->port[i];
-		if (!port)
-			continue;
-		usb_free_urb(port->interrupt_in_urb);
-		kfree(port->interrupt_in_buffer);
-	}
-	for (i = 0; i < num_interrupt_out; ++i) {
-		port = serial->port[i];
-		if (!port)
-			continue;
-		usb_free_urb(port->interrupt_out_urb);
-		kfree(port->interrupt_out_buffer);
-	}
-
-	/* free up any memory that we allocated */
-	for (i = 0; i < serial->num_port_pointers; ++i)
-		kfree(serial->port[i]);
-	kfree(serial);
+	usb_serial_put(serial);
 	return -EIO;
 }
 EXPORT_SYMBOL_GPL(usb_serial_probe);
@@ -1206,8 +1152,7 @@ void usb_serial_disconnect(struct usb_interface *interface)
 	}
 	serial->type->disconnect(serial);
 
-	/* let the last holder of this object
-	 * cause it to be cleaned up */
+	/* let the last holder of this object cause it to be cleaned up */
 	usb_serial_put(serial);
 	dev_info(dev, "device disconnected\n");
 }
-- 
1.6.4.2

