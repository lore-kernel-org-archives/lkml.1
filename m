Return-Path: <linux-kernel-owner+w=401wt.eu-S1756882AbZJBBeF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756882AbZJBBeF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Oct 2009 21:34:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756851AbZJBBeA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Oct 2009 21:34:00 -0400
Received: from kroah.org ([198.145.64.141]:33408 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756827AbZJBBdz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Oct 2009 21:33:55 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Thu Oct  1 18:24:22 2009
Message-Id: <20091002012422.697706742@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Thu, 01 Oct 2009 18:17:27 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Alan Stern <stern@rowland.harvard.edu>
Subject: [099/136] usb-serial: add missing tests and debug lines
References: <20091002011548.335611824@mini.kroah.org>
Content-Disposition: inline; filename=usb-serial-add-missing-tests-and-debug-lines.patch
In-Reply-To: <20091002012911.GA18542@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.31-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Alan Stern <stern@rowland.harvard.edu>

commit ff8324df1187b7280e507c976777df76c73a1ef1 upstream.

This patch (as1290) adds some missing tests.  serial_down() isn't
supposed to do anything if the hardware hasn't been initialized, and
serial_close() isn't supposed to do anything if the tty has gotten a
hangup (because serial_hangup() takes care of shutting down the
hardware).

The patch also updates and adds a few debugging lines.

Signed-off-by: Alan Stern <stern@rowland.harvard.edu>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/usb/serial/usb-serial.c |   21 +++++++++++++++++----
 1 file changed, 17 insertions(+), 4 deletions(-)

--- a/drivers/usb/serial/usb-serial.c
+++ b/drivers/usb/serial/usb-serial.c
@@ -200,6 +200,8 @@ static int serial_install(struct tty_dri
 	struct usb_serial_port *port;
 	int retval = -ENODEV;
 
+	dbg("%s", __func__);
+
 	serial = usb_serial_get_by_index(idx);
 	if (!serial)
 		return retval;
@@ -250,11 +252,11 @@ static int serial_open (struct tty_struc
 	int retval = 0;
 	int first = 0;
 
-	dbg("%s", __func__);
-
 	port = tty->driver_data;
 	serial = port->serial;
 
+	dbg("%s - port %d", __func__, port->number);
+
 	if (mutex_lock_interruptible(&port->mutex))
 		return -ERESTARTSYS;
 
@@ -315,6 +317,12 @@ static void serial_down(struct usb_seria
 	if (port->console)
 		return;
 
+	/* Don't call the close method if the hardware hasn't been
+	 * initialized.
+	 */
+	if (!test_and_clear_bit(ASYNCB_INITIALIZED, &port->port.flags))
+		return;
+
 	mutex_lock(&port->mutex);
 	serial = port->serial;
 	owner = serial->type->driver.owner;
@@ -328,10 +336,11 @@ static void serial_down(struct usb_seria
 static void serial_hangup(struct tty_struct *tty)
 {
 	struct usb_serial_port *port = tty->driver_data;
+
+	dbg("%s - port %d", __func__, port->number);
+
 	serial_down(port);
 	tty_port_hangup(&port->port);
-	/* We must not free port yet - the USB serial layer depends on it's
-	   continued existence */
 }
 
 static void serial_close(struct tty_struct *tty, struct file *filp)
@@ -340,6 +349,8 @@ static void serial_close(struct tty_stru
 
 	dbg("%s - port %d", __func__, port->number);
 
+	if (tty_hung_up_p(filp))
+		return;
 	if (tty_port_close_start(&port->port, tty, filp) == 0)
 		return;
 	serial_down(port);
@@ -368,6 +379,8 @@ static void serial_release(struct tty_st
 	if (port->console)
 		return;
 
+	dbg("%s - port %d", __func__, port->number);
+
 	/* Standard shutdown processing */
 	tty_shutdown(tty);
 


