Return-Path: <linux-kernel-owner+w=401wt.eu-S1756945AbZJBBoN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756945AbZJBBoN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Oct 2009 21:44:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756357AbZJBBoL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Oct 2009 21:44:11 -0400
Received: from kroah.org ([198.145.64.141]:33414 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756832AbZJBBd4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Oct 2009 21:33:56 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Thu Oct  1 18:24:23 2009
Message-Id: <20091002012422.926509484@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Thu, 01 Oct 2009 18:17:28 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Alan Stern <stern@rowland.harvard.edu>
Subject: [100/136] usb-serial: straighten out serial_open
References: <20091002011548.335611824@mini.kroah.org>
Content-Disposition: inline; filename=usb-serial-straighten-out-serial_open.patch
In-Reply-To: <20091002012911.GA18542@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.31-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Alan Stern <stern@rowland.harvard.edu>

commit 320348c8d5c9b591282633ddb8959b42f7fc7a1c upstream.

This patch (as1291) removes a bunch of code from serial_open(), things
that were rendered unnecessary by earlier patches.  A missing spinlock
is added to protect port->port.count, which needs to be incremented
even if the open fails but not if the tty has gotten a hangup.  The
test for whether the hardware has been initialized, based on the use
count, is replaced by a more transparent test of the
ASYNCB_INITIALIZED bit in the port flags.

Signed-off-by: Alan Stern <stern@rowland.harvard.edu>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/usb/serial/usb-serial.c |   59 ++++++++++++++--------------------------
 1 file changed, 22 insertions(+), 37 deletions(-)

--- a/drivers/usb/serial/usb-serial.c
+++ b/drivers/usb/serial/usb-serial.c
@@ -245,55 +245,40 @@ static int serial_install(struct tty_dri
 	return retval;
 }
 
-static int serial_open (struct tty_struct *tty, struct file *filp)
+static int serial_open(struct tty_struct *tty, struct file *filp)
 {
-	struct usb_serial *serial;
-	struct usb_serial_port *port;
-	int retval = 0;
-	int first = 0;
-
-	port = tty->driver_data;
-	serial = port->serial;
+	struct usb_serial_port *port = tty->driver_data;
+	struct usb_serial *serial = port->serial;
+	int retval;
 
 	dbg("%s - port %d", __func__, port->number);
 
-	if (mutex_lock_interruptible(&port->mutex))
-		return -ERESTARTSYS;
-
-	++port->port.count;
+	spin_lock_irq(&port->port.lock);
+	if (!tty_hung_up_p(filp))
+		++port->port.count;
+	spin_unlock_irq(&port->port.lock);
 	tty_port_tty_set(&port->port, tty);
 
-	/* If the console is attached, the device is already open */
-	if (port->port.count == 1 && !port->console) {
-		first = 1;
+	/* Do the device-specific open only if the hardware isn't
+	 * already initialized.
+	 */
+	if (!test_bit(ASYNCB_INITIALIZED, &port->port.flags)) {
+		if (mutex_lock_interruptible(&port->mutex))
+			return -ERESTARTSYS;
 		mutex_lock(&serial->disc_mutex);
-
-		/* only call the device specific open if this
-		 * is the first time the port is opened */
-		retval = serial->type->open(tty, port, filp);
-		if (retval)
-			goto bailout_module_put;
+		if (serial->disconnected)
+			retval = -ENODEV;
+		else
+			retval = port->serial->type->open(tty, port, flip);
 		mutex_unlock(&serial->disc_mutex);
+		mutex_unlock(&port->mutex);
+		if (retval)
+			return retval;
 		set_bit(ASYNCB_INITIALIZED, &port->port.flags);
 	}
-	mutex_unlock(&port->mutex);
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
-bailout_module_put:
-	mutex_unlock(&serial->disc_mutex);
-bailout_mutex_unlock:
-	port->port.count = 0;
-	mutex_unlock(&port->mutex);
 	return retval;
 }
 


