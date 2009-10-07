Return-Path: <linux-kernel-owner+w=401wt.eu-S1759421AbZJGO51@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759421AbZJGO51 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Oct 2009 10:57:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759395AbZJGO51
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Oct 2009 10:57:27 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:56332 "EHLO
	bob.linux.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1759387AbZJGO5Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Oct 2009 10:57:25 -0400
From: Alan Cox <alan@linux.intel.com>
Subject: [PATCH 1/4] tty_port: add "tty_port_open" helper
To: linux-kernel@vger.kernel.org, strakh@ispras.ru, jirislaby@gmail.com
Date: Wed, 07 Oct 2009 15:46:16 +0100
Message-ID: <20091007144609.14550.22354.stgit@localhost.localdomain>
In-Reply-To: <20091007144455.14550.95003.stgit@localhost.localdomain>
References: <20091007144455.14550.95003.stgit@localhost.localdomain>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For the moment this just moves the USB logic over and fixes the 'what if
we open and hangup at the same time' race noticed by Oliver Neukum.

Signed-off-by: Alan Cox <alan@linux.intel.com>
---

 drivers/char/tty_port.c         |   36 ++++++++++++++++++++++++++++-
 drivers/usb/serial/usb-serial.c |   49 ++++++++++++++++-----------------------
 include/linux/tty.h             |   10 +++++++-
 3 files changed, 64 insertions(+), 31 deletions(-)


diff --git a/drivers/char/tty_port.c b/drivers/char/tty_port.c
index a4bbb28..2512262 100644
--- a/drivers/char/tty_port.c
+++ b/drivers/char/tty_port.c
@@ -99,10 +99,11 @@ EXPORT_SYMBOL(tty_port_tty_set);
 
 static void tty_port_shutdown(struct tty_port *port)
 {
+	mutex_lock(&port->mutex);
 	if (port->ops->shutdown &&
 		test_and_clear_bit(ASYNCB_INITIALIZED, &port->flags))
 			port->ops->shutdown(port);
-
+	mutex_unlock(&port->mutex);
 }
 
 /**
@@ -375,3 +376,36 @@ void tty_port_close(struct tty_port *port, struct tty_struct *tty,
 	tty_port_tty_set(port, NULL);
 }
 EXPORT_SYMBOL(tty_port_close);
+
+int tty_port_open(struct tty_port *port, struct tty_struct *tty,
+                                                        struct file *filp)
+{
+	spin_lock_irq(&port->lock);
+	if (!tty_hung_up_p(filp))
+		++port->count;
+	spin_unlock_irq(&port->lock);
+	tty_port_tty_set(port, tty);
+
+	/*
+	 * Do the device-specific open only if the hardware isn't
+	 * already initialized. Serialize open and shutdown using the
+	 * port mutex.
+	 */
+
+	mutex_lock(&port->mutex);
+
+	if (!test_bit(ASYNCB_INITIALIZED, &port->flags)) {
+		if (port->ops->activate) {
+			int retval = port->ops->activate(port, tty);
+			if (retval) {
+        		        mutex_unlock(&port->mutex);
+        			return retval;
+        		}
+                }
+		set_bit(ASYNCB_INITIALIZED, &port->flags);
+	}
+	mutex_unlock(&port->mutex);
+	return tty_port_block_til_ready(port, tty, filp);
+}        
+
+EXPORT_SYMBOL(tty_port_open);
diff --git a/drivers/usb/serial/usb-serial.c b/drivers/usb/serial/usb-serial.c
index aa6b2ae..95c34da 100644
--- a/drivers/usb/serial/usb-serial.c
+++ b/drivers/usb/serial/usb-serial.c
@@ -246,41 +246,31 @@ static int serial_install(struct tty_driver *driver, struct tty_struct *tty)
 	return retval;
 }
 
-static int serial_open(struct tty_struct *tty, struct file *filp)
+static int serial_activate(struct tty_port *tport, struct tty_struct *tty)
 {
-	struct usb_serial_port *port = tty->driver_data;
+	struct usb_serial_port *port =
+		container_of(tport, struct usb_serial_port, port);
 	struct usb_serial *serial = port->serial;
 	int retval;
 
-	dbg("%s - port %d", __func__, port->number);
-
-	spin_lock_irq(&port->port.lock);
-	if (!tty_hung_up_p(filp))
-		++port->port.count;
-	spin_unlock_irq(&port->port.lock);
-	tty_port_tty_set(&port->port, tty);
+	if (mutex_lock_interruptible(&port->mutex))
+		return -ERESTARTSYS;
+	mutex_lock(&serial->disc_mutex);
+	if (serial->disconnected)
+		retval = -ENODEV;
+	else
+		retval = port->serial->type->open(tty, port);
+	mutex_unlock(&serial->disc_mutex);
+	mutex_unlock(&port->mutex);
+	return retval;
+}
 
-	/* Do the device-specific open only if the hardware isn't
-	 * already initialized.
-	 */
-	if (!test_bit(ASYNCB_INITIALIZED, &port->port.flags)) {
-		if (mutex_lock_interruptible(&port->mutex))
-			return -ERESTARTSYS;
-		mutex_lock(&serial->disc_mutex);
-		if (serial->disconnected)
-			retval = -ENODEV;
-		else
-			retval = port->serial->type->open(tty, port);
-		mutex_unlock(&serial->disc_mutex);
-		mutex_unlock(&port->mutex);
-		if (retval)
-			return retval;
-		set_bit(ASYNCB_INITIALIZED, &port->port.flags);
-	}
+static int serial_open(struct tty_struct *tty, struct file *filp)
+{
+	struct usb_serial_port *port = tty->driver_data;
 
-	/* Now do the correct tty layer semantics */
-	retval = tty_port_block_til_ready(&port->port, tty, filp);
-	return retval;
+	dbg("%s - port %d", __func__, port->number);
+	return tty_port_open(&port->port, tty, filp);
 }
 
 /**
@@ -724,6 +714,7 @@ static void serial_dtr_rts(struct tty_port *port, int on)
 static const struct tty_port_operations serial_port_ops = {
 	.carrier_raised = serial_carrier_raised,
 	.dtr_rts = serial_dtr_rts,
+	.activate = serial_activate,
 };
 
 int usb_serial_probe(struct usb_interface *interface,
diff --git a/include/linux/tty.h b/include/linux/tty.h
index ed24493..262c5da 100644
--- a/include/linux/tty.h
+++ b/include/linux/tty.h
@@ -191,9 +191,15 @@ struct tty_port_operations {
 	/* Control the DTR line */
 	void (*dtr_rts)(struct tty_port *port, int raise);
 	/* Called when the last close completes or a hangup finishes
-	   IFF the port was initialized. Do not use to free resources */
+	   IFF the port was initialized. Do not use to free resources. Called
+	   under the port mutex to serialize against activate/shutdowns */
 	void (*shutdown)(struct tty_port *port);
 	void (*drop)(struct tty_port *port);
+	/* Called under the port mutex from tty_port_open, serialized using
+	   the port mutex */
+        /* FIXME: long term getting the tty argument *out* of this would be
+           good for consoles */
+	int (*activate)(struct tty_port *port, struct tty_struct *tty);
 };
 	
 struct tty_port {
@@ -468,6 +474,8 @@ extern int tty_port_close_start(struct tty_port *port,
 extern void tty_port_close_end(struct tty_port *port, struct tty_struct *tty);
 extern void tty_port_close(struct tty_port *port,
 				struct tty_struct *tty, struct file *filp);
+extern int tty_port_open(struct tty_port *port,
+				struct tty_struct *tty, struct file *filp);
 extern inline int tty_port_users(struct tty_port *port)
 {
 	return port->count + port->blocked_open;

