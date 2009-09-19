Return-Path: <linux-kernel-owner+w=401wt.eu-S1754254AbZISVlw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754254AbZISVlw (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Sep 2009 17:41:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754235AbZISVlt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Sep 2009 17:41:49 -0400
Received: from kroah.org ([198.145.64.141]:40471 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754126AbZISVlq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Sep 2009 17:41:46 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Alan Cox <alan@linux.intel.com>, stable <stable@kernel.org>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 39/79] tty: USB can now use the shutdown method for kref based freeing of ports
Date: Sat, 19 Sep 2009 14:36:44 -0700
Message-Id: <1253396244-7885-39-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.6.4.2
In-Reply-To: <20090919213345.GB7668@kroah.com>
References: <20090919213345.GB7668@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alan Cox <alan@linux.intel.com>

Signed-off-by: Alan Cox <alan@linux.intel.com>
Cc: stable <stable@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/usb/serial/usb-serial.c |   28 +++++++---------------------
 1 files changed, 7 insertions(+), 21 deletions(-)

diff --git a/drivers/usb/serial/usb-serial.c b/drivers/usb/serial/usb-serial.c
index 21dd72a..31c7a09 100644
--- a/drivers/usb/serial/usb-serial.c
+++ b/drivers/usb/serial/usb-serial.c
@@ -316,16 +316,19 @@ static void serial_do_down(struct usb_serial_port *port)
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
@@ -350,30 +353,12 @@ static void serial_close(struct tty_struct *tty, struct file *filp)
 
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
@@ -1243,6 +1228,7 @@ static const struct tty_operations serial_ops = {
 	.chars_in_buffer =	serial_chars_in_buffer,
 	.tiocmget =		serial_tiocmget,
 	.tiocmset =		serial_tiocmset,
+	.shutdown =		serial_do_free,
 	.proc_fops =		&serial_proc_fops,
 };
 
-- 
1.6.4.2

