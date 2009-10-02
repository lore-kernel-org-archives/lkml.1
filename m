Return-Path: <linux-kernel-owner+w=401wt.eu-S1756966AbZJBBmw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756966AbZJBBmw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Oct 2009 21:42:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756853AbZJBBd6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Oct 2009 21:33:58 -0400
Received: from kroah.org ([198.145.64.141]:33391 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756813AbZJBBdw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Oct 2009 21:33:52 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Thu Oct  1 18:24:22 2009
Message-Id: <20091002012422.148055949@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Thu, 01 Oct 2009 18:17:24 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Alan Stern <stern@rowland.harvard.edu>
Subject: [096/136] usb-serial: acquire references when a new tty is installed
References: <20091002011548.335611824@mini.kroah.org>
Content-Disposition: inline; filename=usb-serial-acquire-references-when-a-new-tty-is-installed.patch
In-Reply-To: <20091002012911.GA18542@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.31-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Alan Stern <stern@rowland.harvard.edu>

commit cc56cd0157753c04a987888a2f793803df661a40 upstream.

This patch (as1287) makes serial_install() be reponsible for acquiring
references to the usb_serial structure and the driver module when a
tty is first used.  This is more sensible than having serial_open() do
it, because a tty can be opened many times whereas it is installed
only once, when it is created.  (Not to mention that these actions are
reversed when the tty is released, not when it is closed.)  Finally,
it is at install time that the TTY core takes its own reference to the
usb_serial module, so it is only fitting that we should act the same
way in regard to the lower-level serial driver.

Signed-off-by: Alan Stern <stern@rowland.harvard.edu>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/usb/serial/usb-serial.c |  111 ++++++++++++++++------------------------
 1 file changed, 47 insertions(+), 64 deletions(-)

--- a/drivers/usb/serial/usb-serial.c
+++ b/drivers/usb/serial/usb-serial.c
@@ -187,100 +187,92 @@ void usb_serial_put(struct usb_serial *s
  * Create the termios objects for this tty.  We use the default
  * USB serial settings but permit them to be overridden by
  * serial->type->init_termios.
+ *
+ * This is the first place a new tty gets used.  Hence this is where we
+ * acquire references to the usb_serial structure and the driver module,
+ * where we store a pointer to the port, and where we do an autoresume.
+ * All these actions are reversed in serial_do_free().
  */
 static int serial_install(struct tty_driver *driver, struct tty_struct *tty)
 {
 	int idx = tty->index;
 	struct usb_serial *serial;
-	int retval;
+	struct usb_serial_port *port;
+	int retval = -ENODEV;
+
+	serial = usb_serial_get_by_index(idx);
+	if (!serial)
+		return retval;
+
+	port = serial->port[idx - serial->minor];
+	if (!port)
+		goto error_no_port;
+	if (!try_module_get(serial->type->driver.owner))
+		goto error_module_get;
+
+	retval = usb_autopm_get_interface(serial->interface);
+	if (retval)
+		goto error_get_interface;
 
 	/* If the termios setup has yet to be done */
 	if (tty->driver->termios[idx] == NULL) {
 		/* perform the standard setup */
 		retval = tty_init_termios(tty);
 		if (retval)
-			return retval;
+			goto error_init_termios;
 		/* allow the driver to update it */
-		serial = usb_serial_get_by_index(tty->index);
-		if (serial) {
-			if (serial->type->init_termios)
-				serial->type->init_termios(tty);
-			usb_serial_put(serial);
-			mutex_unlock(&serial->disc_mutex);
-		}
+		if (serial->type->init_termios)
+			serial->type->init_termios(tty);
 	}
+	mutex_unlock(&serial->disc_mutex);
+
+	tty->driver_data = port;
+
 	/* Final install (we use the default method) */
 	tty_driver_kref_get(driver);
 	tty->count++;
 	driver->ttys[idx] = tty;
-	return 0;
+	return retval;
+
+ error_init_termios:
+	usb_autopm_put_interface(serial->interface);
+ error_get_interface:
+	module_put(serial->type->driver.owner);
+ error_module_get:
+ error_no_port:
+	usb_serial_put(serial);
+	mutex_unlock(&serial->disc_mutex);
+	return retval;
 }
 
 static int serial_open (struct tty_struct *tty, struct file *filp)
 {
 	struct usb_serial *serial;
 	struct usb_serial_port *port;
-	unsigned int portNumber;
 	int retval = 0;
 	int first = 0;
 
 	dbg("%s", __func__);
 
-	/* get the serial object associated with this tty pointer */
-	serial = usb_serial_get_by_index(tty->index);
-	if (!serial) {
-		tty->driver_data = NULL;
-		return -ENODEV;
-	}
-
-	portNumber = tty->index - serial->minor;
-	port = serial->port[portNumber];
-	if (!port || serial->disconnected)
-		retval = -ENODEV;
-	/*
-	 * Note: Our locking order requirement does not allow port->mutex
-	 * to be acquired while serial->disc_mutex is held.
-	 */
-	mutex_unlock(&serial->disc_mutex);
-	if (retval)
-		goto bailout_serial_put;
+	port = tty->driver_data;
+	serial = port->serial;
 
-	if (mutex_lock_interruptible(&port->mutex)) {
-		retval = -ERESTARTSYS;
-		goto bailout_serial_put;
-	}
+	if (mutex_lock_interruptible(&port->mutex))
+		return -ERESTARTSYS;
 
 	++port->port.count;
-
-	/* set up our port structure making the tty driver
-	 * remember our port object, and us it */
-	tty->driver_data = port;
 	tty_port_tty_set(&port->port, tty);
 
 	/* If the console is attached, the device is already open */
 	if (port->port.count == 1 && !port->console) {
 		first = 1;
-		/* lock this module before we call it
-		 * this may fail, which means we must bail out,
-		 * safe because we are called with BKL held */
-		if (!try_module_get(serial->type->driver.owner)) {
-			retval = -ENODEV;
-			goto bailout_mutex_unlock;
-		}
-
 		mutex_lock(&serial->disc_mutex);
-		if (serial->disconnected)
-			retval = -ENODEV;
-		else
-			retval = usb_autopm_get_interface(serial->interface);
-		if (retval)
-			goto bailout_module_put;
 
 		/* only call the device specific open if this
 		 * is the first time the port is opened */
 		retval = serial->type->open(tty, port, filp);
 		if (retval)
-			goto bailout_interface_put;
+			goto bailout_module_put;
 		mutex_unlock(&serial->disc_mutex);
 		set_bit(ASYNCB_INITIALIZED, &port->port.flags);
 	}
@@ -297,18 +289,11 @@ static int serial_open (struct tty_struc
 		goto bailout_mutex_unlock;
 	/* Undo the initial port actions */
 	mutex_lock(&serial->disc_mutex);
-bailout_interface_put:
-	usb_autopm_put_interface(serial->interface);
 bailout_module_put:
 	mutex_unlock(&serial->disc_mutex);
-	module_put(serial->type->driver.owner);
 bailout_mutex_unlock:
 	port->port.count = 0;
-	tty->driver_data = NULL;
-	tty_port_tty_set(&port->port, NULL);
 	mutex_unlock(&port->mutex);
-bailout_serial_put:
-	usb_serial_put(serial);
 	return retval;
 }
 
@@ -355,9 +340,6 @@ static void serial_close(struct tty_stru
 {
 	struct usb_serial_port *port = tty->driver_data;
 
-	if (!port)
-		return;
-
 	dbg("%s - port %d", __func__, port->number);
 
 	if (tty_port_close_start(&port->port, tty, filp) == 0)
@@ -365,7 +347,6 @@ static void serial_close(struct tty_stru
 	serial_do_down(port);
 	tty_port_close_end(&port->port, tty);
 	tty_port_tty_set(&port->port, NULL);
-
 }
 
 /**
@@ -386,9 +367,11 @@ static void serial_do_free(struct tty_st
 	/* The console is magical.  Do not hang up the console hardware
 	 * or there will be tears.
 	 */
-	if (port == NULL || port->console)
+	if (port->console)
 		return;
 
+	tty->driver_data = NULL;
+
 	serial = port->serial;
 	owner = serial->type->driver.owner;
 


