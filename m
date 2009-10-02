Return-Path: <linux-kernel-owner+w=401wt.eu-S932303AbZJBBnl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932303AbZJBBnl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Oct 2009 21:43:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932289AbZJBBnj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Oct 2009 21:43:39 -0400
Received: from kroah.org ([198.145.64.141]:33420 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756843AbZJBBd5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Oct 2009 21:33:57 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Thu Oct  1 18:24:23 2009
Message-Id: <20091002012423.080836301@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Thu, 01 Oct 2009 18:17:29 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Alan Stern <stern@rowland.harvard.edu>
Subject: [101/136] USB serial: update the console driver
References: <20091002011548.335611824@mini.kroah.org>
Content-Disposition: inline; filename=usb-serial-update-the-console-driver.patch
In-Reply-To: <20091002012911.GA18542@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.31-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Alan Stern <stern@rowland.harvard.edu>

commit 7bd032dc2793afcbaf4a350056768da84cdbd89b upstream.

This patch (as1292) modifies the USB serial console driver, to make it
compatible with the recent changes to the USB serial core.  The most
important change is that serial->disc_mutex now has to be unlocked
following a successful call to usb_serial_get_by_index().

Other less notable changes include:

	Use the requested port number instead of port 0 always.

	Prevent the serial device from being autosuspended.

	Use the ASYNCB_INITIALIZED flag bit to indicate when the
	port hardware has been initialized.

In spite of these changes, there's no question that the USB serial
console code is still a big hack.

Signed-off-by: Alan Stern <stern@rowland.harvard.edu>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/usb/serial/console.c |   28 +++++++++++++++++++---------
 1 file changed, 19 insertions(+), 9 deletions(-)

--- a/drivers/usb/serial/console.c
+++ b/drivers/usb/serial/console.c
@@ -16,6 +16,7 @@
 #include <linux/slab.h>
 #include <linux/tty.h>
 #include <linux/console.h>
+#include <linux/serial.h>
 #include <linux/usb.h>
 #include <linux/usb/serial.h>
 
@@ -63,7 +64,7 @@ static int usb_console_setup(struct cons
 	char *s;
 	struct usb_serial *serial;
 	struct usb_serial_port *port;
-	int retval = 0;
+	int retval;
 	struct tty_struct *tty = NULL;
 	struct ktermios *termios = NULL, dummy;
 
@@ -116,13 +117,17 @@ static int usb_console_setup(struct cons
 		return -ENODEV;
 	}
 
-	port = serial->port[0];
+	retval = usb_autopm_get_interface(serial->interface);
+	if (retval)
+		goto error_get_interface;
+
+	port = serial->port[co->index - serial->minor];
 	tty_port_tty_set(&port->port, NULL);
 
 	info->port = port;
 
 	++port->port.count;
-	if (port->port.count == 1) {
+	if (!test_bit(ASYNCB_INITIALIZED, &port->port.flags)) {
 		if (serial->type->set_termios) {
 			/*
 			 * allocate a fake tty so the driver can initialize
@@ -168,6 +173,7 @@ static int usb_console_setup(struct cons
 			kfree(termios);
 			kfree(tty);
 		}
+		set_bit(ASYNCB_INITIALIZED, &port->port.flags);
 	}
 	/* Now that any required fake tty operations are completed restore
 	 * the tty port count */
@@ -175,18 +181,22 @@ static int usb_console_setup(struct cons
 	/* The console is special in terms of closing the device so
 	 * indicate this port is now acting as a system console. */
 	port->console = 1;
-	retval = 0;
 
-out:
+	mutex_unlock(&serial->disc_mutex);
 	return retval;
-free_termios:
+
+ free_termios:
 	kfree(termios);
 	tty_port_tty_set(&port->port, NULL);
-free_tty:
+ free_tty:
 	kfree(tty);
-reset_open_count:
+ reset_open_count:
 	port->port.count = 0;
-	goto out;
+	usb_autopm_put_interface(serial->interface);
+ error_get_interface:
+	usb_serial_put(serial);
+	mutex_unlock(&serial->disc_mutex);
+	return retval;
 }
 
 static void usb_console_write(struct console *co,


