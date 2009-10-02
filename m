Return-Path: <linux-kernel-owner+w=401wt.eu-S1756284AbZJBBdx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756284AbZJBBdx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Oct 2009 21:33:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756799AbZJBBdr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Oct 2009 21:33:47 -0400
Received: from kroah.org ([198.145.64.141]:33366 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756284AbZJBBdq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Oct 2009 21:33:46 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Thu Oct  1 18:24:21 2009
Message-Id: <20091002012421.235577611@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Thu, 01 Oct 2009 18:17:18 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Alan Cox <alan@linux.intel.com>
Subject: [090/136] tty: USB can now use the shutdown method for kref based freeing of ports
References: <20091002011548.335611824@mini.kroah.org>
Content-Disposition: inline; filename=tty-usb-can-now-use-the-shutdown-method-for-kref-based-freeing-of-ports.patch
In-Reply-To: <20091002012911.GA18542@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.31-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Alan Cox <alan@linux.intel.com>

commit 4455e344959a217ffc28de2ab1af87541322b343 upstream.

Signed-off-by: Alan Cox <alan@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/usb/serial/usb-serial.c |   28 +++++++---------------------
 1 file changed, 7 insertions(+), 21 deletions(-)

--- a/drivers/usb/serial/usb-serial.c
+++ b/drivers/usb/serial/usb-serial.c
@@ -316,16 +316,19 @@ static void serial_do_down(struct usb_se
  *
  *	Do the resource freeing and refcount dropping for the port. We must
  *	be careful about ordering and we must avoid freeing up the console.
+ *
+ *	Called when the last tty kref is dropped.
  */
 
-static void serial_do_free(struct usb_serial_port *port)
+static void serial_do_free(struct tty_struct *tty)
 {
+	struct usb_serial_port *port = tty->driver_data;
 	struct usb_serial *serial;
 	struct module *owner;
 
 	/* The console is magical, do not hang up the console hardware
 	   or there will be tears */
-	if (port->console)
+	if (port == NULL || port->console)
 		return;
 
 	serial = port->serial;
@@ -350,30 +353,12 @@ static void serial_close(struct tty_stru
 
 	dbg("%s - port %d", __func__, port->number);
 
-	/* FIXME:
-	   This leaves a very narrow race. Really we should do the
-	   serial_do_free() on tty->shutdown(), but tty->shutdown can
-	   be called from IRQ context and serial_do_free can sleep.
-
-	   The right fix is probably to make the tty free (which is rare)
-	   and thus tty->shutdown() occur via a work queue and simplify all
-	   the drivers that use it.
-	*/
-	if (tty_hung_up_p(filp)) {
-		/* serial_hangup already called serial_down at this point.
-		   Another user may have already reopened the port but
-		   serial_do_free is refcounted */
-		serial_do_free(port);
-		return;
-	}
-
 	if (tty_port_close_start(&port->port, tty, filp) == 0)
 		return;
-
 	serial_do_down(port);		
 	tty_port_close_end(&port->port, tty);
 	tty_port_tty_set(&port->port, NULL);
-	serial_do_free(port);
+
 }
 
 static void serial_hangup(struct tty_struct *tty)
@@ -1243,6 +1228,7 @@ static const struct tty_operations seria
 	.chars_in_buffer =	serial_chars_in_buffer,
 	.tiocmget =		serial_tiocmget,
 	.tiocmset =		serial_tiocmset,
+	.shutdown =		serial_do_free,
 	.proc_fops =		&serial_proc_fops,
 };
 


