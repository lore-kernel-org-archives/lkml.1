Return-Path: <linux-kernel-owner+w=401wt.eu-S1756963AbZJBBl4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756963AbZJBBl4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Oct 2009 21:41:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756869AbZJBBeD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Oct 2009 21:34:03 -0400
Received: from kroah.org ([198.145.64.141]:33402 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756799AbZJBBdy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Oct 2009 21:33:54 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Thu Oct  1 18:24:22 2009
Message-Id: <20091002012422.533759505@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Thu, 01 Oct 2009 18:17:26 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Alan Stern <stern@rowland.harvard.edu>
Subject: [098/136] usb-serial: rename subroutines
References: <20091002011548.335611824@mini.kroah.org>
Content-Disposition: inline; filename=usb-serial-rename-subroutines.patch
In-Reply-To: <20091002012911.GA18542@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.31-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Alan Stern <stern@rowland.harvard.edu>

commit 74556123e034c8337b69a3ebac2f3a5fc0a97032 upstream.

This patch (as1289) renames serial_do_down() to serial_down() and
serial_do_free() to serial_release().  It also adds a missing call to
tty_shutdown() in serial_release().

Signed-off-by: Alan Stern <stern@rowland.harvard.edu>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/usb/serial/usb-serial.c |   19 +++++++++++--------
 1 file changed, 11 insertions(+), 8 deletions(-)

--- a/drivers/usb/serial/usb-serial.c
+++ b/drivers/usb/serial/usb-serial.c
@@ -191,7 +191,7 @@ void usb_serial_put(struct usb_serial *s
  * This is the first place a new tty gets used.  Hence this is where we
  * acquire references to the usb_serial structure and the driver module,
  * where we store a pointer to the port, and where we do an autoresume.
- * All these actions are reversed in serial_do_free().
+ * All these actions are reversed in serial_release().
  */
 static int serial_install(struct tty_driver *driver, struct tty_struct *tty)
 {
@@ -296,13 +296,13 @@ bailout_mutex_unlock:
 }
 
 /**
- * serial_do_down - shut down hardware
+ * serial_down - shut down hardware
  * @port: port to shut down
  *
  * Shut down a USB serial port unless it is the console.  We never
  * shut down the console hardware as it will always be in use.
  */
-static void serial_do_down(struct usb_serial_port *port)
+static void serial_down(struct usb_serial_port *port)
 {
 	struct usb_serial_driver *drv = port->serial->type;
 	struct usb_serial *serial;
@@ -328,7 +328,7 @@ static void serial_do_down(struct usb_se
 static void serial_hangup(struct tty_struct *tty)
 {
 	struct usb_serial_port *port = tty->driver_data;
-	serial_do_down(port);
+	serial_down(port);
 	tty_port_hangup(&port->port);
 	/* We must not free port yet - the USB serial layer depends on it's
 	   continued existence */
@@ -342,13 +342,13 @@ static void serial_close(struct tty_stru
 
 	if (tty_port_close_start(&port->port, tty, filp) == 0)
 		return;
-	serial_do_down(port);
+	serial_down(port);
 	tty_port_close_end(&port->port, tty);
 	tty_port_tty_set(&port->port, NULL);
 }
 
 /**
- * serial_do_free - free resources post close/hangup
+ * serial_release - free resources post close/hangup
  * @port: port to free up
  *
  * Do the resource freeing and refcount dropping for the port.
@@ -356,7 +356,7 @@ static void serial_close(struct tty_stru
  *
  * Called when the last tty kref is dropped.
  */
-static void serial_do_free(struct tty_struct *tty)
+static void serial_release(struct tty_struct *tty)
 {
 	struct usb_serial_port *port = tty->driver_data;
 	struct usb_serial *serial;
@@ -368,6 +368,9 @@ static void serial_do_free(struct tty_st
 	if (port->console)
 		return;
 
+	/* Standard shutdown processing */
+	tty_shutdown(tty);
+
 	tty->driver_data = NULL;
 
 	serial = port->serial;
@@ -1204,7 +1207,7 @@ static const struct tty_operations seria
 	.chars_in_buffer =	serial_chars_in_buffer,
 	.tiocmget =		serial_tiocmget,
 	.tiocmset =		serial_tiocmset,
-	.shutdown = 		serial_do_free,
+	.shutdown = 		serial_release,
 	.install = 		serial_install,
 	.proc_fops =		&serial_proc_fops,
 };


