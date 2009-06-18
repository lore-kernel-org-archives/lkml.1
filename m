Return-Path: <linux-kernel-owner+w=401wt.eu-S1757548AbZFRCUo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757548AbZFRCUo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jun 2009 22:20:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754792AbZFRCUV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Jun 2009 22:20:21 -0400
Received: from mail.windriver.com ([147.11.1.11]:55089 "EHLO mail.wrs.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753953AbZFRCUU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jun 2009 22:20:20 -0400
From: Jason Wessel <jason.wessel@windriver.com>
To: greg@kroah.com, alan@lxorguk.ukuu.org.uk
Cc: linux-kernel@vger.kernel.org, Jason Wessel <jason.wessel@windriver.com>
Subject: [PATCH 1/3] usb,console: Fix regression in usb console on kernel boot
Date: Wed, 17 Jun 2009 21:20:07 -0500
Message-Id: <1245291609-14871-2-git-send-email-jason.wessel@windriver.com>
X-Mailer: git-send-email 1.6.3.1.9.g95405b
In-Reply-To: <1245291609-14871-1-git-send-email-jason.wessel@windriver.com>
References: <1245291609-14871-1-git-send-email-jason.wessel@windriver.com>
X-OriginalArrivalTime: 18 Jun 2009 02:20:15.0155 (UTC) FILETIME=[50E00030:01C9EFBB]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The commit 335f8514f200e63d689113d29cb7253a5c282967 introduced a
regression which stopped usb consoles from working correctly as a
kernel boot console as well as interactive login device.

The addition of the serial_close() which in turn calls
tty_port_close_start() will change the reference count of port.count
and warn about it.  The usb console code had previously incremented
the port.count to indicate it was making use of the device as a
console and the forced change causes a double open on the usb device
which leads to a non obvious kernel oops later on when the tty is
freed.

To fix the problem instead make use of port->console to track if the
port is in fact an active console port to avoid double initialization
of the usb serial device.  The port.count is incremented and
decremented only with in the scope of usb_console_setup() for the
purpose of the low level driver initialization.

Signed-off-by: Jason Wessel <jason.wessel@windriver.com>
---
 drivers/usb/serial/console.c    |   13 +++++++------
 drivers/usb/serial/usb-serial.c |    3 ++-
 2 files changed, 9 insertions(+), 7 deletions(-)

diff --git a/drivers/usb/serial/console.c b/drivers/usb/serial/console.c
index 247b61b..0e4f2e4 100644
--- a/drivers/usb/serial/console.c
+++ b/drivers/usb/serial/console.c
@@ -169,9 +169,11 @@ static int usb_console_setup(struct console *co, char *options)
 			kfree(tty);
 		}
 	}
-	/* So we know not to kill the hardware on a hangup on this
-	   port. We have also bumped the use count by one so it won't go
-	   idle */
+	/* Now that any required fake tty operations are completed restore
+	 * the tty port count */
+	--port->port.count;
+	/* The console is special in terms of closing the device so
+	 * indicate this port is now acting as a system console. */
 	port->console = 1;
 	retval = 0;
 
@@ -204,7 +206,7 @@ static void usb_console_write(struct console *co,
 
 	dbg("%s - port %d, %d byte(s)", __func__, port->number, count);
 
-	if (!port->port.count) {
+	if (!port->console) {
 		dbg("%s - port not opened", __func__);
 		return;
 	}
@@ -300,8 +302,7 @@ void usb_serial_console_exit(void)
 {
 	if (usbcons_info.port) {
 		unregister_console(&usbcons);
-		if (usbcons_info.port->port.count)
-			usbcons_info.port->port.count--;
+		usbcons_info.port->console = 0;
 		usbcons_info.port = NULL;
 	}
 }
diff --git a/drivers/usb/serial/usb-serial.c b/drivers/usb/serial/usb-serial.c
index d595aa5..329e098 100644
--- a/drivers/usb/serial/usb-serial.c
+++ b/drivers/usb/serial/usb-serial.c
@@ -220,7 +220,8 @@ static int serial_open (struct tty_struct *tty, struct file *filp)
 	tty->driver_data = port;
 	tty_port_tty_set(&port->port, tty);
 
-	if (port->port.count == 1) {
+	/* If the console is attached, the device is already open */
+	if (port->port.count == 1 && !port->console) {
 
 		/* lock this module before we call it
 		 * this may fail, which means we must bail out,
-- 
1.6.3.1.9.g95405b

