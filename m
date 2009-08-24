Return-Path: <linux-kernel-owner+w=401wt.eu-S1751160AbZHXBYd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751160AbZHXBYd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Aug 2009 21:24:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751136AbZHXBYc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Aug 2009 21:24:32 -0400
Received: from netrider.rowland.org ([192.131.102.5]:56929 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751104AbZHXBYb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Aug 2009 21:24:31 -0400
Date: Sun, 23 Aug 2009 21:24:30 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: Bruno =?UTF-8?B?UHLDqW1vbnQ=?= <bonbons@linux-vserver.org>
cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, Greg KH <greg@kroah.com>,
       Kernel development list <linux-kernel@vger.kernel.org>,
       USB list <linux-usb@vger.kernel.org>, "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: 2.6.31-rc5 regression: Oops when USB Serial disconnected while
 in use
In-Reply-To: <20090823183058.01fa4700@neptune.home>
Message-ID: <Pine.LNX.4.44L0.0908232109400.30663-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 23 Aug 2009, Bruno [UTF-8] Prémont wrote:

> On Sun, 23 August 2009 Alan Stern <stern@rowland.harvard.edu> wrote:
> > I have a big patch almost ready for testing.  Unfortunately I don't 
> > have access to my usual hardware right now, so I can't test it until 
> > the middle of the week.  Bruno, if you like I will send you the patch 
> > when it looks okay and you can try it out.
> 
> Fine for me, I can test every week-day during evening as well as during
> week-end (European time, UTC+2).
> If there are any specific tests (other than the surviving of disconnect)
> that I shall run, just ask!

Here it is.  This is meant to apply on top of gregkh-all-2.6.31-rc6;  
it replaces the small patch you tried earlier.  In fact this ought to
be split up into at least four individual patches, but you can test it
all in one piece.

Surviving disconnect, ability to reconnect, deallocating memory 
(destroy_serial and port_free) at the right time...  Anything else you 
can think of.

Alan Stern

P.S.: You may already have the first part, with the changes to
tty_port.c.



Index: usb-2.6/drivers/char/tty_port.c
===================================================================
--- usb-2.6.orig/drivers/char/tty_port.c
+++ usb-2.6/drivers/char/tty_port.c
@@ -100,7 +100,7 @@ EXPORT_SYMBOL(tty_port_tty_set);
 static void tty_port_shutdown(struct tty_port *port)
 {
 	if (port->ops->shutdown &&
-		test_and_clear_bit(ASYNC_INITIALIZED, &port->flags))
+		test_and_clear_bit(ASYNCB_INITIALIZED, &port->flags))
 			port->ops->shutdown(port);
 	
 }
@@ -311,7 +311,7 @@ int tty_port_close_start(struct tty_port
 			port->ops->drop(port);
 		return 0;
 	}
-	set_bit(ASYNC_CLOSING, &port->flags);
+	set_bit(ASYNCB_CLOSING, &port->flags);
 	tty->closing = 1;
 	spin_unlock_irqrestore(&port->lock, flags);
 	/* Don't block on a stalled port, just pull the chain */
Index: usb-2.6/drivers/usb/serial/usb-serial.c
===================================================================
--- usb-2.6.orig/drivers/usb/serial/usb-serial.c
+++ usb-2.6/drivers/usb/serial/usb-serial.c
@@ -126,8 +126,10 @@ static void return_serial(struct usb_ser
 
 	dbg("%s", __func__);
 
+	mutex_lock(&table_lock);
 	for (i = 0; i < serial->num_ports; ++i)
 		serial_table[serial->minor + i] = NULL;
+	mutex_unlock(&table_lock);
 }
 
 static void destroy_serial(struct kref *kref)
@@ -146,35 +148,24 @@ static void destroy_serial(struct kref *
 
 	serial->type->release(serial);
 
-	for (i = 0; i < serial->num_ports; ++i) {
+	for (i = 0; i < serial->num_port_pointers; ++i) {
 		port = serial->port[i];
 		if (port)
-			put_device(&port->dev);
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
-		}
+			port_free(port);
 	}
 
 	usb_put_dev(serial->dev);
-
-	/* free up any memory that we allocated */
 	kfree(serial);
 }
 
+void usb_serial_get(struct usb_serial *serial)
+{
+	kref_get(&serial->kref);
+}
+
 void usb_serial_put(struct usb_serial *serial)
 {
-	mutex_lock(&table_lock);
 	kref_put(&serial->kref, destroy_serial);
-	mutex_unlock(&table_lock);
 }
 
 /*****************************************************************************
@@ -186,16 +177,13 @@ static int serial_open (struct tty_struc
 	struct usb_serial_port *port;
 	unsigned int portNumber;
 	int retval = 0;
-	int first = 0;
 
 	dbg("%s", __func__);
 
 	/* get the serial object associated with this tty pointer */
 	serial = usb_serial_get_by_index(tty->index);
-	if (!serial) {
-		tty->driver_data = NULL;
+	if (!serial)
 		return -ENODEV;
-	}
 
 	mutex_lock(&serial->disc_mutex);
 	portNumber = tty->index - serial->minor;
@@ -209,24 +197,42 @@ static int serial_open (struct tty_struc
 	 * to be acquired while serial->disc_mutex is held.
 	 */
 	mutex_unlock(&serial->disc_mutex);
-	if (retval)
-		goto bailout_serial_put;
 
+	/* serial is pinned by port->dev, so we can drop its reference */
+	usb_serial_put(serial);
+
+	/* Associate this tty with our port structure, if it isn't already
+	 * associated.  This reference will be dropped in serial_shutdown(),
+	 * when the TTY layer is finished with the tty.
+	 */
+	if (retval == 0 && !tty->driver_data) {
+		tty->driver_data = port;
+		get_device(&port->dev);
+	}
+
+	/* Every open call associated with a port must increment the
+	 * port's use counter, even if the call fails, unless the tty
+	 * has been hung up.
+	 */
+	if (tty->driver_data) {
+		spin_lock_irq(&port->port.lock);
+		if (!tty_hung_up_p(filp))
+			++port->port.count;
+		spin_unlock_irq(&port->port.lock);
+		tty_port_tty_set(&port->port, tty);
+	}
+
+	if (retval)
+		return retval;
 	if (mutex_lock_interruptible(&port->mutex)) {
 		retval = -ERESTARTSYS;
 		goto bailout_port_put;
 	}
 
-	++port->port.count;
-
-	/* set up our port structure making the tty driver
-	 * remember our port object, and us it */
-	tty->driver_data = port;
-	tty_port_tty_set(&port->port, tty);
-
-	/* If the console is attached, the device is already open */
-	if (port->port.count == 1 && !port->console) {
-		first = 1;
+	/* Do the device-specific open only if the hardware isn't
+	 * already initialized.
+	 */
+	if (!test_bit(ASYNCB_INITIALIZED, &port->port.flags)) {
 		/* lock this module before we call it
 		 * this may fail, which means we must bail out,
 		 * safe because we are called with BKL held */
@@ -243,8 +249,6 @@ static int serial_open (struct tty_struc
 		if (retval)
 			goto bailout_module_put;
 
-		/* only call the device specific open if this
-		 * is the first time the port is opened */
 		retval = serial->type->open(tty, port);
 		if (retval)
 			goto bailout_interface_put;
@@ -252,32 +256,26 @@ static int serial_open (struct tty_struc
 		set_bit(ASYNCB_INITIALIZED, &port->port.flags);
 	}
 	mutex_unlock(&port->mutex);
+
+	/* The port object was pinned by the tty when the association
+	 * was made above.  We don't need an extra reference for each
+	 * open call.
+	 */
+	put_device(&port->dev);
+
 	/* Now do the correct tty layer semantics */
 	retval = tty_port_block_til_ready(&port->port, tty, filp);
-	if (retval == 0) {
-		if (!first)
-			usb_serial_put(serial);
-		return 0;
-	}
-	mutex_lock(&port->mutex);
-	if (first == 0)
-		goto bailout_mutex_unlock;
-	/* Undo the initial port actions */
-	mutex_lock(&serial->disc_mutex);
-bailout_interface_put:
+	return retval;
+
+ bailout_interface_put:
 	usb_autopm_put_interface(serial->interface);
-bailout_module_put:
+ bailout_module_put:
 	mutex_unlock(&serial->disc_mutex);
 	module_put(serial->type->driver.owner);
-bailout_mutex_unlock:
-	port->port.count = 0;
-	tty->driver_data = NULL;
-	tty_port_tty_set(&port->port, NULL);
+ bailout_mutex_unlock:
 	mutex_unlock(&port->mutex);
-bailout_port_put:
+ bailout_port_put:
 	put_device(&port->dev);
-bailout_serial_put:
-	usb_serial_put(serial);
 	return retval;
 }
 
@@ -287,56 +285,34 @@ bailout_serial_put:
  *
  *	Shut down a USB port unless it is the console. We never shut down the
  *	console hardware as it will always be in use.
- *
- *	Don't free any resources at this point
  */
 static void serial_do_down(struct usb_serial_port *port)
 {
-	struct usb_serial_driver *drv = port->serial->type;
+	struct usb_serial *serial = port->serial;
+	struct usb_serial_driver *drv = serial->type;
 
 	/* The console is magical, do not hang up the console hardware
 	   or there will be tears */
 	if (port->console)
 		return;
 
+	/* Don't call the close method if the hardware hasn't been
+	 * initialized.
+	 */
+	if (!test_and_clear_bit(ASYNCB_INITIALIZED, &port->port.flags))
+		return;
+
 	mutex_lock(&port->mutex);
 	if (drv->close)
 		drv->close(port);
 	mutex_unlock(&port->mutex);
-}
-
-/**
- *	serial_do_free		-	free resources post close/hangup
- *	@port: port to free up
- *
- *	Do the resource freeing and refcount dropping for the port. We must
- *	be careful about ordering and we must avoid freeing up the console.
- *
- *	Called when the last tty kref is dropped.
- */
 
-static void serial_do_free(struct tty_struct *tty)
-{
-	struct usb_serial_port *port = tty->driver_data;
-	struct usb_serial *serial;
-	struct module *owner;
+	module_put(drv->driver.owner);
 
-	/* The console is magical, do not hang up the console hardware
-	   or there will be tears */
-	if (port == NULL || port->console)
-		return;
-
-	serial = port->serial;
-	owner = serial->type->driver.owner;
-	put_device(&port->dev);
-	/* Mustn't dereference port any more */
 	mutex_lock(&serial->disc_mutex);
 	if (!serial->disconnected)
 		usb_autopm_put_interface(serial->interface);
 	mutex_unlock(&serial->disc_mutex);
-	usb_serial_put(serial);
-	/* Mustn't dereference serial any more */
-	module_put(owner);
 }
 
 static void serial_close(struct tty_struct *tty, struct file *filp)
@@ -348,21 +324,45 @@ static void serial_close(struct tty_stru
 
 	dbg("%s - port %d", __func__, port->number);
 
+	if (tty_hung_up_p(filp))
+		return;
 	if (tty_port_close_start(&port->port, tty, filp) == 0)
 		return;
+
 	serial_do_down(port);		
 	tty_port_close_end(&port->port, tty);
 	tty_port_tty_set(&port->port, NULL);
-
 }
 
 static void serial_hangup(struct tty_struct *tty)
 {
 	struct usb_serial_port *port = tty->driver_data;
+
 	serial_do_down(port);
 	tty_port_hangup(&port->port);
-	/* We must not free port yet - the USB serial layer depends on it's
-	   continued existence */
+}
+
+/**
+ * serial_shutdown - free resources post close/hangup
+ * @tty: TTY whose port should be freed
+ *
+ * Do the resource freeing and refcount dropping for the port. We must
+ * avoid freeing up the console.
+ *
+ * Called when the last tty kref is dropped.
+ */
+static void serial_shutdown(struct tty_struct *tty)
+{
+	struct usb_serial_port *port = tty->driver_data;
+
+	/* The console is magical, do not hang up the console hardware
+	   or there will be tears */
+	if (port == NULL || port->console)
+		return;
+
+	/* Release the reference owned by the tty object */
+	tty->driver_data = NULL;
+	put_device(&port->dev);
 }
 
 static int serial_write(struct tty_struct *tty, const unsigned char *buf,
@@ -581,7 +581,9 @@ static void port_release(struct device *
 	struct usb_serial_port *port = to_usb_serial_port(dev);
 
 	dbg ("%s - %s", __func__, dev_name(dev));
-	port_free(port);
+
+	/* The port structure will be freed in destroy_serial(). */
+	usb_serial_put(port->serial);
 }
 
 static void kill_traffic(struct usb_serial_port *port)
@@ -945,10 +947,16 @@ int usb_serial_probe(struct usb_interfac
 			goto probe_error;
 		tty_port_init(&port->port);
 		port->port.ops = &serial_port_ops;
-		port->serial = serial;
 		spin_lock_init(&port->lock);
 		mutex_init(&port->mutex);
 		INIT_WORK(&port->work, usb_serial_port_work);
+		port->dev.parent = &interface->dev;
+		port->dev.driver = NULL;
+		port->dev.bus = &usb_serial_bus_type;
+		port->dev.release = &port_release;
+		device_initialize(&port->dev);
+		port->serial = serial;
+		usb_serial_get(serial);
 		serial->port[i] = port;
 	}
 
@@ -1097,15 +1105,10 @@ int usb_serial_probe(struct usb_interfac
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
@@ -1123,41 +1126,13 @@ exit:
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
-		if (port->write_fifo)
-			kfifo_free(port->write_fifo);
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
+	/* free all the ports, along with their URBs */
+	for (i = 0; i < serial->num_port_pointers; ++i) {
 		port = serial->port[i];
-		if (!port)
-			continue;
-		usb_free_urb(port->interrupt_out_urb);
-		kfree(port->interrupt_out_buffer);
+		if (port)
+			put_device(&port->dev);
 	}
-
-	/* free up any memory that we allocated */
-	for (i = 0; i < serial->num_port_pointers; ++i)
-		kfree(serial->port[i]);
-	kfree(serial);
+	usb_serial_put(serial);
 	return -EIO;
 }
 EXPORT_SYMBOL_GPL(usb_serial_probe);
@@ -1205,6 +1180,7 @@ void usb_serial_disconnect(struct usb_in
 				port->dev_state = PORT_UNREGISTERED;
 			}
 		}
+		put_device(&port->dev);
 	}
 	serial->type->disconnect(serial);
 
@@ -1269,7 +1245,7 @@ static const struct tty_operations seria
 	.chars_in_buffer =	serial_chars_in_buffer,
 	.tiocmget =		serial_tiocmget,
 	.tiocmset =		serial_tiocmset,
-	.shutdown = 		serial_do_free,
+	.shutdown = 		serial_shutdown,
 	.install = 		serial_install,
 	.proc_fops =		&serial_proc_fops,
 };

