Return-Path: <linux-kernel-owner+w=401wt.eu-S1755285AbZISVqE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755285AbZISVqE (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Sep 2009 17:46:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755276AbZISVp6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Sep 2009 17:45:58 -0400
Received: from kroah.org ([198.145.64.141]:52814 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755155AbZISVpd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Sep 2009 17:45:33 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Alan Stern <stern@rowland.harvard.edu>, stable <stable@kernel.org>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 78/79] usb-serial: straighten out serial_open
Date: Sat, 19 Sep 2009 14:37:23 -0700
Message-Id: <1253396244-7885-78-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.6.4.2
In-Reply-To: <20090919213345.GB7668@kroah.com>
References: <20090919213345.GB7668@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alan Stern <stern@rowland.harvard.edu>

This patch (as1291) removes a bunch of code from serial_open(), things
that were rendered unnecessary by earlier patches.  A missing spinlock
is added to protect port->port.count, which needs to be incremented
even if the open fails but not if the tty has gotten a hangup.  The
test for whether the hardware has been initialized, based on the use
count, is replaced by a more transparent test of the
ASYNCB_INITIALIZED bit in the port flags.

Signed-off-by: Alan Stern <stern@rowland.harvard.edu>
Cc: stable <stable@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/usb/serial/usb-serial.c |   59 ++++++++++++++------------------------
 1 files changed, 22 insertions(+), 37 deletions(-)

diff --git a/drivers/usb/serial/usb-serial.c b/drivers/usb/serial/usb-serial.c
index 9a32580..9d7ca48 100644
--- a/drivers/usb/serial/usb-serial.c
+++ b/drivers/usb/serial/usb-serial.c
@@ -245,55 +245,40 @@ static int serial_install(struct tty_driver *driver, struct tty_struct *tty)
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
-		retval = serial->type->open(tty, port);
-		if (retval)
-			goto bailout_module_put;
+		if (serial->disconnected)
+			retval = -ENODEV;
+		else
+			retval = port->serial->type->open(tty, port);
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
 
-- 
1.6.4.2

