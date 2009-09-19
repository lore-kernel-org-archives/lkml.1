Return-Path: <linux-kernel-owner+w=401wt.eu-S1755155AbZISVp6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755155AbZISVp6 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Sep 2009 17:45:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755041AbZISVpd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Sep 2009 17:45:33 -0400
Received: from kroah.org ([198.145.64.141]:52808 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755134AbZISVpa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Sep 2009 17:45:30 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Alan Stern <stern@rowland.harvard.edu>, stable <stable@kernel.org>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 77/79] usb-serial: add missing tests and debug lines
Date: Sat, 19 Sep 2009 14:37:22 -0700
Message-Id: <1253396244-7885-77-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.6.4.2
In-Reply-To: <20090919213345.GB7668@kroah.com>
References: <20090919213345.GB7668@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alan Stern <stern@rowland.harvard.edu>

This patch (as1290) adds some missing tests.  serial_down() isn't
supposed to do anything if the hardware hasn't been initialized, and
serial_close() isn't supposed to do anything if the tty has gotten a
hangup (because serial_hangup() takes care of shutting down the
hardware).

The patch also updates and adds a few debugging lines.

Signed-off-by: Alan Stern <stern@rowland.harvard.edu>
Cc: stable <stable@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/usb/serial/usb-serial.c |   21 +++++++++++++++++----
 1 files changed, 17 insertions(+), 4 deletions(-)

diff --git a/drivers/usb/serial/usb-serial.c b/drivers/usb/serial/usb-serial.c
index 28125de..9a32580 100644
--- a/drivers/usb/serial/usb-serial.c
+++ b/drivers/usb/serial/usb-serial.c
@@ -200,6 +200,8 @@ static int serial_install(struct tty_driver *driver, struct tty_struct *tty)
 	struct usb_serial_port *port;
 	int retval = -ENODEV;
 
+	dbg("%s", __func__);
+
 	serial = usb_serial_get_by_index(idx);
 	if (!serial)
 		return retval;
@@ -250,11 +252,11 @@ static int serial_open (struct tty_struct *tty, struct file *filp)
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
 
@@ -315,6 +317,12 @@ static void serial_down(struct usb_serial_port *port)
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
@@ -328,10 +336,11 @@ static void serial_down(struct usb_serial_port *port)
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
@@ -340,6 +349,8 @@ static void serial_close(struct tty_struct *tty, struct file *filp)
 
 	dbg("%s - port %d", __func__, port->number);
 
+	if (tty_hung_up_p(filp))
+		return;
 	if (tty_port_close_start(&port->port, tty, filp) == 0)
 		return;
 	serial_down(port);
@@ -368,6 +379,8 @@ static void serial_release(struct tty_struct *tty)
 	if (port->console)
 		return;
 
+	dbg("%s - port %d", __func__, port->number);
+
 	/* Standard shutdown processing */
 	tty_shutdown(tty);
 
-- 
1.6.4.2

